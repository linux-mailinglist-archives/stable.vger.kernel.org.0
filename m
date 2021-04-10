Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8146A35AE12
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 16:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhDJOSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 10:18:35 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:36971 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234392AbhDJOSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 10:18:35 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id EFA881940C02;
        Sat, 10 Apr 2021 10:18:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:18:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mQKpRA
        /Ak/Vf7EvtuBJolyjv+SQOEHOJtreUFH8JCp8=; b=RTTpJfVYDej7855uX0TBBq
        clA50J/xvlkywHuMNIZOnG98cdyownVddrkxzrRjDn1WZxo/+4JK1dG+6TlrEVXB
        BnxNy+lfXB4sgQyU19ytvUFvBqLtw53ZJHB9xkwRYk2Xr3cJm1f8u3yAc9jFn+x7
        CCxVMijET3jg9LkOoM5WC5xdUfvmuLU+5u/tGYaYLRR2WcMM0NoWjt31LvMJaH6r
        hyW7Fhh45vj2Aqef37S3odiGPwAJ374Miyxq2BwHqchUi2Hp+hv1bAbXuslTgeKX
        iB47HqKWbjiXB4cqYS3nKWpDoFe+Hl/yzDh38ArNqlaDu5Lf9sVKqjpgFkOEIDcg
        ==
X-ME-Sender: <xms:qrNxYBH2tW61xUEmVJmov61Zc2FSoHDK2GpXkxSeLN4aQQrEkjCwrw>
    <xme:qrNxYGUnL3wOBIeMT2zOX8wyIXf-C9J0gwLGju7uLoutvkJHxTE-4n5BYvCaLYQET
    YL3BShTFaJjzw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:qrNxYDLc9BvRVQamolHM0V4QKbAZgtfqwGGnTPTNmH55AbqwPRNr_g>
    <xmx:qrNxYHEZEoRXE4J_9syTHKi5EuMRpGkD0Ad0DLfIvHSTkq94cgVUoQ>
    <xmx:qrNxYHUfAC3szhL6dSMG7r9t0zCs0_rOz8RW9MrEarxKWt8XsGCZ5A>
    <xmx:qrNxYOeBzjs1fnxQ98IV-WbPCtO_3jcvlkBjY4ifcEfK3jXfIkFk_w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A98F4108005F;
        Sat, 10 Apr 2021 10:18:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: sched: fix err handler in tcf_action_init()" failed to apply to 5.11-stable tree
To:     vladbu@nvidia.com, davem@davemloft.net, xiyou.wangcong@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Apr 2021 16:18:08 +0200
Message-ID: <161806428853115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b3650bf76a32380d4d80a3e21b5583e7303f216c Mon Sep 17 00:00:00 2001
From: Vlad Buslov <vladbu@nvidia.com>
Date: Wed, 7 Apr 2021 18:36:04 +0300
Subject: [PATCH] net: sched: fix err handler in tcf_action_init()

With recent changes that separated action module load from action
initialization tcf_action_init() function error handling code was modified
to manually release the loaded modules if loading/initialization of any
further action in same batch failed. For the case when all modules
successfully loaded and some of the actions were initialized before one of
them failed in init handler. In this case for all previous actions the
module will be released twice by the error handler: First time by the loop
that manually calls module_put() for all ops, and second time by the action
destroy code that puts the module after destroying the action.

Reproduction:

$ sudo tc actions add action simple sdata \"2\" index 2
$ sudo tc actions add action simple sdata \"1\" index 1 \
                      action simple sdata \"2\" index 2
RTNETLINK answers: File exists
We have an error talking to the kernel
$ sudo tc actions ls action simple
total acts 1

        action order 0: Simple <"2">
         index 2 ref 1 bind 0
$ sudo tc actions flush action simple
$ sudo tc actions ls action simple
$ sudo tc actions add action simple sdata \"2\" index 2
Error: Failed to load TC action module.
We have an error talking to the kernel
$ lsmod | grep simple
act_simple             20480  -1

Fix the issue by modifying module reference counting handling in action
initialization code:

- Get module reference in tcf_idr_create() and put it in tcf_idr_release()
instead of taking over the reference held by the caller.

- Modify users of tcf_action_init_1() to always release the module
reference which they obtain before calling init function instead of
assuming that created action takes over the reference.

- Finally, modify tcf_action_init_1() to not release the module reference
when overwriting existing action as this is no longer necessary since both
upper and lower layers obtain and manage their own module references
independently.

Fixes: d349f9976868 ("net_sched: fix RTNL deadlock again caused by request_module()")
Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 312f0f6554a0..086b291e9530 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -170,12 +170,7 @@ void tcf_idr_insert_many(struct tc_action *actions[]);
 void tcf_idr_cleanup(struct tc_action_net *tn, u32 index);
 int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
 			struct tc_action **a, int bind);
-int __tcf_idr_release(struct tc_action *a, bool bind, bool strict);
-
-static inline int tcf_idr_release(struct tc_action *a, bool bind)
-{
-	return __tcf_idr_release(a, bind, false);
-}
+int tcf_idr_release(struct tc_action *a, bool bind);
 
 int tcf_register_action(struct tc_action_ops *a, struct pernet_operations *ops);
 int tcf_unregister_action(struct tc_action_ops *a,
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 50854cfbfcdb..f6d5755d669e 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -158,7 +158,7 @@ static int __tcf_action_put(struct tc_action *p, bool bind)
 	return 0;
 }
 
-int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
+static int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
 {
 	int ret = 0;
 
@@ -184,7 +184,18 @@ int __tcf_idr_release(struct tc_action *p, bool bind, bool strict)
 
 	return ret;
 }
-EXPORT_SYMBOL(__tcf_idr_release);
+
+int tcf_idr_release(struct tc_action *a, bool bind)
+{
+	const struct tc_action_ops *ops = a->ops;
+	int ret;
+
+	ret = __tcf_idr_release(a, bind, false);
+	if (ret == ACT_P_DELETED)
+		module_put(ops->owner);
+	return ret;
+}
+EXPORT_SYMBOL(tcf_idr_release);
 
 static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 {
@@ -493,6 +504,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 	}
 
 	p->idrinfo = idrinfo;
+	__module_get(ops->owner);
 	p->ops = ops;
 	*a = p;
 	return 0;
@@ -1037,13 +1049,6 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	if (!name)
 		a->hw_stats = hw_stats;
 
-	/* module count goes up only when brand new policy is created
-	 * if it exists and is only bound to in a_o->init() then
-	 * ACT_P_CREATED is not returned (a zero is).
-	 */
-	if (err != ACT_P_CREATED)
-		module_put(a_o->owner);
-
 	return a;
 
 err_out:
@@ -1103,7 +1108,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	tcf_idr_insert_many(actions);
 
 	*attr_size = tcf_action_full_attrs_size(sz);
-	return i - 1;
+	err = i - 1;
+	goto err_mod;
 
 err:
 	tcf_action_destroy(actions, bind);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 9ecb91ebf094..340d5af86e87 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3054,10 +3054,9 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 						rate_tlv, "police", ovr,
 						TCA_ACT_BIND, a_o, init_res,
 						rtnl_held, extack);
-			if (IS_ERR(act)) {
-				module_put(a_o->owner);
+			module_put(a_o->owner);
+			if (IS_ERR(act))
 				return PTR_ERR(act);
-			}
 
 			act->type = exts->type = TCA_OLD_COMPAT;
 			exts->actions[0] = act;

