# EC2 Cost Optimization

## Objective

As part of this activity, I reviewed the main options available for reducing EC2 costs in a production environment. The main focus was on understanding when to use Savings Plans, Reserved Instances, Spot Instances, auto-stopping of development instances, and right-sizing.

The main point I understood is that cost optimization should be based on the workload type and usage pattern. We should not choose a cost-saving option only because it provides a higher discount.

## 1. Right-Sizing

Right-sizing means selecting an EC2 instance type and size based on the actual resource requirements of the application.

In a production environment, an instance may have been selected with higher CPU or memory than the application actually needs. For example, if a production application is running on an `m5.2xlarge` instance but CloudWatch shows that CPU and memory utilization are consistently low, we can review whether a smaller instance is sufficient.

Before changing the instance size, I would check CloudWatch metrics over a reasonable period rather than looking at only the current utilization. I would also consider peak traffic, memory usage, network usage and application performance.

### Production use case

Suppose a production API is running continuously on four large EC2 instances. After checking the metrics, we find that the instances are using only a small percentage of their available CPU and memory even during normal peak traffic.

In this case, I would evaluate moving to a smaller instance type. After the change, I would continue monitoring the application to make sure there is no performance degradation.

Right-sizing is usually one of the first things I would check because there is no benefit in getting a discounted price for an instance that is already unnecessarily large.

---

## 2. Savings Plans

Savings Plans are useful when an organization has predictable compute usage and expects that usage to continue for a longer period.

Instead of paying the full On-Demand price, the organization commits to a certain amount of compute usage for a term and receives a discounted rate.

For production workloads, I would first analyze the historical compute usage and identify the amount of usage that is consistently required. I would avoid making a commitment based only on temporary or seasonal usage.

### Production use case

Suppose a company has several production applications that run continuously throughout the year. The compute usage has been stable for the last several months and there is no expectation of a major reduction.

In this situation, I would evaluate a Savings Plan for the predictable baseline usage. Any additional usage that is not covered by the commitment can continue to use other pricing options.

The main consideration is to understand the expected future usage before making a long-term commitment.

---

## 3. Reserved Instances

Reserved Instances can be useful for workloads that have stable and predictable EC2 requirements.

If an application is expected to run continuously and the instance configuration is not expected to change frequently, a Reserved Instance can provide a discount compared with On-Demand pricing.

There are different RI options, so I would consider the required flexibility before selecting one.

### Production use case

For example, suppose a production application has been running continuously on a specific EC2 instance configuration for a long period. The application has stable traffic and there is no planned migration or major change in the near future.

For this type of workload, I would compare the cost of continuing with On-Demand instances against the available Reserved Instance options.

I would also compare Reserved Instances with Savings Plans before making the final decision.

---

## 4. Spot Instances

Spot Instances allow us to use unused EC2 capacity at a lower price than On-Demand instances. The main limitation is that the instance can be interrupted when AWS needs the capacity.

Because of this, I would only use Spot for workloads that can tolerate interruption or can recover automatically.

Suitable workloads can include batch processing, CI/CD jobs, data processing, testing environments and other fault-tolerant workloads.

### Production use case

For example, suppose a company has a nightly data-processing job that processes a large number of files. The job does not require a specific EC2 instance to stay available continuously, and the application can retry the work if an instance is interrupted.

In this case, Spot Instances can significantly reduce the compute cost.

I would not use a single Spot Instance for a critical production application where an interruption could directly cause service downtime. If Spot is required for a production workload, I would make sure the application has appropriate fault tolerance and can handle instance replacement.

---

## 5. Auto-Stopping Idle Development Instances

Development and testing environments are often running even when nobody is using them. These instances do not normally need to run 24/7.

For such environments, we can configure an automated schedule to stop instances outside working hours and start them again when the team needs them.

### Production use case

For example, a development environment may only be used from 9 AM to 7 PM on working days. Instead of keeping the EC2 instances running overnight and during weekends, we can automatically stop them outside the required working hours.

This reduces unnecessary compute charges without affecting the production environment.

I would identify which instances are safe to stop before applying the schedule. Production instances or workloads that need to run continuously should not be included.

It is also important to remember that stopping an EC2 instance does not remove all related costs. EBS volumes and other associated resources can continue to incur charges.

---
## 6. On-Demand Instances
On-Demand Instances allow us to launch EC2 instances and pay for the compute capacity we use without making any long-term commitment. This option provides flexibility because we can increase or decrease capacity based on application requirements.

On-Demand pricing is generally suitable for workloads with unpredictable usage, short-term requirements, or applications where future compute needs are not yet clear.

For production environments, I would use On-Demand Instances when flexibility is more important than receiving a long-term pricing discount.

### Production use case
Suppose a company is launching a new application, and its traffic pattern is not yet predictable. The company does not know how much compute capacity will be required over the next several months.

In this situation, I would initially use On-Demand Instances rather than committing to a Savings Plan or Reserved Instance before understanding the actual usage pattern.

After monitoring the application for a few months, I would analyze its baseline compute requirements and evaluate whether Savings Plans or Reserved Instances could reduce the cost.

The main advantage of On-Demand Instances is flexibility. They are useful when workloads are temporary, unpredictable, or still being evaluated, although their rates are generally higher than discounted commitment-based options.

## 7. Dedicated Instances and Dedicated Hosts
Dedicated Instances and Dedicated Hosts provide EC2 capacity on hardware dedicated to a single customer. They are useful when an organization has specific isolation, compliance, licensing, or regulatory requirements.

Although both options provide dedicated hardware, they serve different purposes.

### Dedicated Instances
Dedicated Instances run on hardware dedicated to a single AWS customer. Other AWS customers do not share that hardware, but the customer has less visibility and control over the physical server than with a Dedicated Host.

### Production use case

Suppose a company runs a production application that requires instance-level hardware isolation to meet internal security or compliance requirements.

In this case, I would evaluate Dedicated Instances to provide hardware isolation while continuing to use EC2's standard instance management capabilities.

I would compare the additional cost with the application's security and compliance requirements before selecting this option.

### Dedicated Hosts
Dedicated Hosts provide a physical server dedicated to a single customer, with visibility into the host's physical resources and control over instance placement.

They are particularly useful when an organization has software licensing requirements tied to physical servers, sockets, or cores, or when it needs greater control over host placement for compliance purposes.

### Production use case

Suppose a company runs a production database application that uses third-party software licensed based on physical CPU sockets or cores. The company needs visibility into the underlying physical server to meet its licensing requirements.

In this case, I would evaluate Dedicated Hosts because they provide host-level visibility and can help the company manage eligible software licensing requirements.

However, I would compare the cost of Dedicated Hosts with standard EC2 pricing and verify the software vendor's licensing terms before making a decision.

The key difference: Dedicated Instances provide hardware isolation, while Dedicated Hosts provide hardware isolation along with visibility and control at the physical host level. Neither option should be selected solely to reduce cost; they are primarily used to satisfy isolation, compliance, or licensing requirements.

## 8. Comparing the Options
The appropriate EC2 cost optimization method depends on workload characteristics, availability requirements, and business needs.

Option                                                  Best suited for

Right-sizing                      Instances with more CPU, memory, or capacity than required

Savings Plans                     Predictable compute usage with a long-term commitment

Reserved Instances                Stable workloads that benefit from reservation-based pricing

Spot Instances                    Fault-tolerant workloads that can handle interruptions

Auto-stop scheduling              Development and testing instances that are not needed 24/7

On-Demand Instances               Unpredictable, temporary, or newly launched workloads

Dedicated Instances               Workloads requiring dedicated hardware isolation

Dedicated Hosts                   Workloads requiring host-level control or eligible license management

## Conclusion
My approach to EC2 cost optimization would be to first understand workload requirements and utilization, then remove unnecessary capacity and select the most appropriate pricing model.

For oversized instances, I would start with right-sizing.

For predictable production workloads, I would compare Savings Plans and Reserved Instances.

For interruptible batch workloads, I would consider Spot Instances.

For development environments, I would automate start/stop scheduling.

For unpredictable or short-term workloads, I would use On-Demand Instances.

For workloads with specific hardware isolation, compliance, or licensing requirements, I would evaluate Dedicated Instances or Dedicated Hosts.

Ultimately, EC2 cost optimization is not just about choosing the lowest hourly rate. It is about balancing cost, performance, availability, flexibility, and compliance while selecting the right option for each workload.
