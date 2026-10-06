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

## 6. Comparing the Options

The cost optimization method depends on the workload.

For an oversized production instance, I would first look at **right-sizing**.

For development instances that are not required outside working hours, I would use **automatic start/stop scheduling**.

For stable production workloads that run continuously, I would compare **Savings Plans and Reserved Instances**.

For batch processing or other workloads that can tolerate interruption, I would consider **Spot Instances**.

I would also monitor the environment after applying the optimization to make sure the change has reduced cost without affecting application performance or availability.

## Conclusion

The main approach I would follow for EC2 cost optimization is to first understand the actual workload and utilization. I would then remove unnecessary capacity, right-size instances, automate non-production environments and select the appropriate pricing model for stable or interruptible workloads.

For production environments, cost reduction should always be balanced with availability, performance and operational requirements. The cheapest option is not always the correct option; the right option depends on the workload and its business requirements.
