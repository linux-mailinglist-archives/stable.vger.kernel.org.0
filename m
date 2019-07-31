Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F37297C7B3
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 17:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfGaP4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 11:56:49 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:40053 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725209AbfGaP4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 11:56:49 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A111132E;
        Wed, 31 Jul 2019 11:56:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 31 Jul 2019 11:56:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=O7IRKI
        kEpLs/vGw/DmgnB8e4Tg7jYz08AP66w6D39aM=; b=eQEYnCeWP/VMwKBsAIuDSW
        50wTJPnoUHbKRXPxoO3iv5cqUrmGLx6CFRflBWb6jH/iTKN5Djdml5J0Wg+Oq7Vi
        ArDYmFjtU1DYi6Ay8HVHY5aiFnc6j0ojpc2plarEs3RkMp2GBXBzeneQulbtqaD+
        fl5t8Xnv9yAZNw2n4dnrRYQlLqUhKQ55B829cau0g52wCZH06fUa14j96rdgy3Fr
        oRqr7ozlOkJhNzhJTXP+NlpuHkIls7nCNJZvfNfnSCim9YKP6u1IV1Qamkm+7Bpw
        TUhaZnfjM3eHUysptBbXA1X5SqeVxg6FLbMhhjPRTuvuDgJEYeI0IKWqtkDZ98Rw
        ==
X-ME-Sender: <xms:PrpBXVLYWlIHBlgI5pNwXTPVzhIUfxZQeFRpEs_e0SJH0LDb6V64lQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleehgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:PrpBXb3MTBXrRD1uqK4qRIY4AcvxEOZnQNxfOH-37fZ3-TZ9V9d4Bw>
    <xmx:PrpBXWbEYmOIRqmhiihzX6Jp2o5plbY89vQCyOVTE9SOqJnYp2Rk1g>
    <xmx:PrpBXdjlfklV9kHDhjFkxNSaX1iY5kjbeidgaLuitorvb7CXkzJDqA>
    <xmx:P7pBXTo3UYvZT3qyCnt1pKZDOY-UF4OTDdaqhu3yv32n_f6UBl5mmA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BF3C780060;
        Wed, 31 Jul 2019 11:56:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] cpufreq: Add QoS requests for userspace constraints" failed to apply to 5.2-stable tree
To:     viresh.kumar@linaro.org, mka@chromium.org,
        rafael.j.wysocki@intel.com,
        syzbot+de771ae9390dffed7266@syzkaller.appspotmail.com,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 31 Jul 2019 17:56:44 +0200
Message-ID: <15645886047744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 18c49926c4bf4915e5194d1de3299c0537229f9f Mon Sep 17 00:00:00 2001
From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Fri, 5 Jul 2019 16:21:24 +0530
Subject: [PATCH] cpufreq: Add QoS requests for userspace constraints

This implements QoS requests to manage userspace configuration of min
and max frequency.

Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: syzbot <syzbot+de771ae9390dffed7266@syzkaller.appspotmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 79bac52919a5..99aa7d20b458 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -718,23 +718,15 @@ static ssize_t show_scaling_cur_freq(struct cpufreq_policy *policy, char *buf)
 static ssize_t store_##file_name					\
 (struct cpufreq_policy *policy, const char *buf, size_t count)		\
 {									\
-	int ret, temp;							\
-	struct cpufreq_policy new_policy;				\
+	unsigned long val;						\
+	int ret;							\
 									\
-	memcpy(&new_policy, policy, sizeof(*policy));			\
-	new_policy.min = policy->user_policy.min;			\
-	new_policy.max = policy->user_policy.max;			\
-									\
-	ret = sscanf(buf, "%u", &new_policy.object);			\
+	ret = sscanf(buf, "%lu", &val);					\
 	if (ret != 1)							\
 		return -EINVAL;						\
 									\
-	temp = new_policy.object;					\
-	ret = cpufreq_set_policy(policy, &new_policy);		\
-	if (!ret)							\
-		policy->user_policy.object = temp;			\
-									\
-	return ret ? ret : count;					\
+	ret = dev_pm_qos_update_request(policy->object##_freq_req, val);\
+	return ret >= 0 ? count : ret;					\
 }
 
 store_one(scaling_min_freq, min);
@@ -1124,8 +1116,6 @@ void refresh_frequency_limits(struct cpufreq_policy *policy)
 		new_policy = *policy;
 		pr_debug("updating policy for CPU %u\n", policy->cpu);
 
-		new_policy.min = policy->user_policy.min;
-		new_policy.max = policy->user_policy.max;
 		cpufreq_set_policy(policy, &new_policy);
 	}
 }
@@ -1281,6 +1271,9 @@ static void cpufreq_policy_free(struct cpufreq_policy *policy)
 				   DEV_PM_QOS_MAX_FREQUENCY);
 	dev_pm_qos_remove_notifier(dev, &policy->nb_min,
 				   DEV_PM_QOS_MIN_FREQUENCY);
+	dev_pm_qos_remove_request(policy->max_freq_req);
+	dev_pm_qos_remove_request(policy->min_freq_req);
+	kfree(policy->min_freq_req);
 
 	cpufreq_policy_put_kobj(policy);
 	free_cpumask_var(policy->real_cpus);
@@ -1359,16 +1352,50 @@ static int cpufreq_online(unsigned int cpu)
 	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
 
 	if (new_policy) {
-		policy->user_policy.min = policy->min;
-		policy->user_policy.max = policy->max;
+		struct device *dev = get_cpu_device(cpu);
 
 		for_each_cpu(j, policy->related_cpus) {
 			per_cpu(cpufreq_cpu_data, j) = policy;
 			add_cpu_dev_symlink(policy, j);
 		}
-	} else {
-		policy->min = policy->user_policy.min;
-		policy->max = policy->user_policy.max;
+
+		policy->min_freq_req = kzalloc(2 * sizeof(*policy->min_freq_req),
+					       GFP_KERNEL);
+		if (!policy->min_freq_req)
+			goto out_destroy_policy;
+
+		ret = dev_pm_qos_add_request(dev, policy->min_freq_req,
+					     DEV_PM_QOS_MIN_FREQUENCY,
+					     policy->min);
+		if (ret < 0) {
+			/*
+			 * So we don't call dev_pm_qos_remove_request() for an
+			 * uninitialized request.
+			 */
+			kfree(policy->min_freq_req);
+			policy->min_freq_req = NULL;
+
+			dev_err(dev, "Failed to add min-freq constraint (%d)\n",
+				ret);
+			goto out_destroy_policy;
+		}
+
+		/*
+		 * This must be initialized right here to avoid calling
+		 * dev_pm_qos_remove_request() on uninitialized request in case
+		 * of errors.
+		 */
+		policy->max_freq_req = policy->min_freq_req + 1;
+
+		ret = dev_pm_qos_add_request(dev, policy->max_freq_req,
+					     DEV_PM_QOS_MAX_FREQUENCY,
+					     policy->max);
+		if (ret < 0) {
+			policy->max_freq_req = NULL;
+			dev_err(dev, "Failed to add max-freq constraint (%d)\n",
+				ret);
+			goto out_destroy_policy;
+		}
 	}
 
 	if (cpufreq_driver->get && has_target()) {
@@ -2342,7 +2369,6 @@ int cpufreq_set_policy(struct cpufreq_policy *policy,
 {
 	struct cpufreq_governor *old_gov;
 	struct device *cpu_dev = get_cpu_device(policy->cpu);
-	unsigned long min, max;
 	int ret;
 
 	pr_debug("setting new policy for CPU %u: %u - %u kHz\n",
@@ -2350,24 +2376,12 @@ int cpufreq_set_policy(struct cpufreq_policy *policy,
 
 	memcpy(&new_policy->cpuinfo, &policy->cpuinfo, sizeof(policy->cpuinfo));
 
-	/*
-	* This check works well when we store new min/max freq attributes,
-	* because new_policy is a copy of policy with one field updated.
-	*/
-	if (new_policy->min > new_policy->max)
-		return -EINVAL;
-
 	/*
 	 * PM QoS framework collects all the requests from users and provide us
 	 * the final aggregated value here.
 	 */
-	min = dev_pm_qos_read_value(cpu_dev, DEV_PM_QOS_MIN_FREQUENCY);
-	max = dev_pm_qos_read_value(cpu_dev, DEV_PM_QOS_MAX_FREQUENCY);
-
-	if (min > new_policy->min)
-		new_policy->min = min;
-	if (max < new_policy->max)
-		new_policy->max = max;
+	new_policy->min = dev_pm_qos_read_value(cpu_dev, DEV_PM_QOS_MIN_FREQUENCY);
+	new_policy->max = dev_pm_qos_read_value(cpu_dev, DEV_PM_QOS_MAX_FREQUENCY);
 
 	/* verify the cpu speed can be set within this limit */
 	ret = cpufreq_driver->verify(new_policy);
@@ -2456,10 +2470,9 @@ int cpufreq_set_policy(struct cpufreq_policy *policy,
  * @cpu: CPU to re-evaluate the policy for.
  *
  * Update the current frequency for the cpufreq policy of @cpu and use
- * cpufreq_set_policy() to re-apply the min and max limits saved in the
- * user_policy sub-structure of that policy, which triggers the evaluation
- * of policy notifiers and the cpufreq driver's ->verify() callback for the
- * policy in question, among other things.
+ * cpufreq_set_policy() to re-apply the min and max limits, which triggers the
+ * evaluation of policy notifiers and the cpufreq driver's ->verify() callback
+ * for the policy in question, among other things.
  */
 void cpufreq_update_policy(unsigned int cpu)
 {
@@ -2519,10 +2532,9 @@ static int cpufreq_boost_set_sw(int state)
 			break;
 		}
 
-		down_write(&policy->rwsem);
-		policy->user_policy.max = policy->max;
-		cpufreq_governor_limits(policy);
-		up_write(&policy->rwsem);
+		ret = dev_pm_qos_update_request(policy->max_freq_req, policy->max);
+		if (ret)
+			break;
 	}
 
 	return ret;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 1fa37b675a80..afc683021ac5 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -50,11 +50,6 @@ struct cpufreq_cpuinfo {
 	unsigned int		transition_latency;
 };
 
-struct cpufreq_user_policy {
-	unsigned int		min;    /* in kHz */
-	unsigned int		max;    /* in kHz */
-};
-
 struct cpufreq_policy {
 	/* CPUs sharing clock, require sw coordination */
 	cpumask_var_t		cpus;	/* Online CPUs only */
@@ -84,7 +79,8 @@ struct cpufreq_policy {
 	struct work_struct	update; /* if update_policy() needs to be
 					 * called, but you're in IRQ context */
 
-	struct cpufreq_user_policy user_policy;
+	struct dev_pm_qos_request *min_freq_req;
+	struct dev_pm_qos_request *max_freq_req;
 	struct cpufreq_frequency_table	*freq_table;
 	enum cpufreq_table_sorting freq_table_sorted;
 

