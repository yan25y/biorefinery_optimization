


using JuMP
using Gurobi
using CSV


# create 
supply_nodes=Array{String,1}(undef,34559)

for x in 1:34559
    supply_nodes[x]=string("i",x)
end

s0= CSV.read("OrigindID.csv",header=false)
s=convert(Matrix,s0)
s_dict=Dict()
for i in 1:length(supply_nodes)
    s_dict[supply_nodes[i]]=s[i]
end


middle_nodes=Array{String,1}(undef,141)
for j in 1:141
    middle_nodes[j]=string("j",j)
end



m0=CSV.read("collection_capacity.csv",header=false)
m=convert(Matrix,m0)
m_dict=Dict()
for j in 1:length(middle_nodes)
    m_dict[middle_nodes[j]]=m[j]
end


dist1_0=CSV.read("distance.csv",header=false)
dist1=convert(Matrix,dist1_0)
dist_ij_dict=Dict()


for i in 1:length(supply_nodes)
    for j in 1:length(middle_nodes)
        dist_ij_dict[supply_nodes[i],middle_nodes[j]]=dist1[i,j]
    end
end

dist2_0=CSV.read("distance2.csv",header=false)
dist2=convert(Matrix,dist2_0)


demand_nodes=Array{String,1}(undef,23)
for k in 1:23
    demand_nodes[k]=string("k",k)
end
demand_nodes

dist_jk_dict=Dict()
for j in 1:length(middle_nodes)
    for k in 1:length(demand_nodes)
        dist_jk_dict[middle_nodes[j],demand_nodes[k]]=dist2[j,k]
    end
end
        


c_b=10.2
tv1=0.0091
tv2=0.0046
tf1=5780
tf2=2890
c_c=26.8
D=244120
c_s=10.26



model=Model(with_optimizer(Gurobi.Optimizer))


@variable(model,f1[supply_nodes,middle_nodes]>=0)

@variable(model,f2[middle_nodes,demand_nodes]>=0)

@expression(model,Cb, sum(c_b*f1[i,j] for i in supply_nodes,j in middle_nodes))

@constraint(model,sum(f1[i,j] for i in supply_nodes,j in middle_nodes)==D)


for i in supply_nodes
    @constraint(model,sum(f1[i,j] for j in middle_nodes) <= s_dict[i])
end


for j in middle_nodes
    @constraint(model,sum(f1[i,j] for i in supply_nodes) <= m_dict[j])
end


for j in middle_nodes
    @constraint(model,sum(f2[j,k] for k in demand_nodes)==sum(f1[i,j] for i in supply_nodes))
end

@expression(model,Cc,sum(c_c*f1[i,j] for i in supply_nodes,j in middle_nodes))


@expression(model,Tv,sum(tv1*f1[i,j]*dist_ij_dict[i,j] for i in supply_nodes,j in middle_nodes)+sum(tv2*f2[j,k]*dist_jk_dict[j,k] for j in middle_nodes,k in demand_nodes))

@expression(model,Tf,sum(tf1*f1[i,j] for i in supply_nodes,j in middle_nodes)+sum(tf2*f2[j,k] for j in middle_nodes, k in demand_nodes))


@expression(model,Ct,Tv+Tf)


@expression(model,Cs,c_s*D)



scale_nodes=["l1","l2","l3"]

lamda=[0 146000 547500 182500]

p_cv=[712,328,191]

p_cf=[37*10^6,91*10^6,163*10^6]


p_cv_dict=Dict()
p_cf_dict=Dict()
for l in 1:length(scale_nodes)
    p_cv_dict[scale_nodes[l]]=p_cv[l]
    p_cf_dict[scale_nodes[l]]=p_cf[l]
end



@variable(model,o1[demand_nodes,scale_nodes],Bin)


@variable(model,o2[demand_nodes],Bin)


@variable(model,q[demand_nodes,scale_nodes]>=0)



for k in demand_nodes
    for l in scale_nodes
        if l==scale_nodes[1]
            @constraint(model,q[k,l] >= lamda[1]*o1[k,l])
            @constraint(model,q[k,l] <= lamda[2]*o1[k,l])
        elseif l==scale_nodes[2]
            @constraint(model,q[k,l] >= lamda[2]*o1[k,l])
            @constraint(model,q[k,l] <= lamda[3]*o1[k,l])
        elseif l==scale_nodes[3]
            @constraint(model,q[k,l] >= lamda[3]*o1[k,l])
            @constraint(model,q[k,l] <= lamda[4]*o1[k,l])
        end
    end
end


for k in demand_nodes
    @constraint(model,sum(o1[k,l] for l in scale_nodes)==o2[k])
end



for k in demand_nodes
 @constraint(model,sum(f2[j,k] for j in middle_nodes)==sum(q[k,l] for l in scale_nodes))
end


@constraint(model,sum(q[k,l] for k in demand_nodes,l in scale_nodes)==D)


@expression(model,Pc,sum(q[k,l]*p_cv_dict[l]+p_cf_dict[l]*o1[k,l] for k in demand_nodes,l in scale_nodes))


p_ov=27.39

p_of=1.75*10^6

@expression(model,Po,sum(p_ov*sum(q[k,l] for l in scale_nodes)+p_of*o2[k] for k in demand_nodes))

@expression(model,Cp,Po+Pc)

@objective(model,Min,Cb+Cc+Ct+Cs+Cp)



optimize!(model)



Cb1=JuMP.value(Cb)


Ct1=JuMP.value(C)


Cp=JuMP.value(Cp)





