Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D4435AE13
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 16:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhDJOSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 10:18:47 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:58657 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234548AbhDJOSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 10:18:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0488C1940B2B;
        Sat, 10 Apr 2021 10:18:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:18:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=dEHF/T
        8s6HuqvlBZjpGaTL1nSw1NI9r08LbTp8rYts4=; b=iJMDISuv+ZPBcMGcxQqW2b
        vuOHQUA2IYbJJqImNhzx/X5pNCHopARPFBri7bzf2CIRCsXrjQIawf4QtczR4uEq
        40xKhji1OuPIG1I1oSHlAhBYFfmgReo0wH74NrZEmNf/zc+WiF18WVrVEf/dijub
        AW87mz+ijWmYpbjmDvYMNVX3K3ZvpVNaRnh/6NQqw+XgFBhPg2n4gXkJ3p0joNbA
        FjipuDG3OHiS/ZR8bL17YwVAYK3UybglQGv2Y8DCqd6c1dxA+aSmi5dtXP9PR0Ug
        EYGEmGnE4c2o5HvE8YocVHN8T8AqKeJTwy3aQXR16HJyb7TTEnPtsE6VnfUwWfKQ
        ==
X-ME-Sender: <xms:t7NxYEDNYgLRMjct6orjPvShQyCbYS-7q6JcygGxQEc4tQZ69XEt2w>
    <xme:t7NxYGgAb8dgDf1dLAbWll5pkhzJkcEkUyEydzSzya2btPnsQ7JT6JLjAHVg4bQc6
    xJCSPyd5MvdBw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:t7NxYHn04CsVDVwb7FqqBINs8yEK_HqqH6VzBXdpjSw2EVumdBb5hw>
    <xmx:t7NxYKw53FzebgLkD5nfzlZEwf_Zu1fWZa_IDsg3tZSh1Y-F4T9f1A>
    <xmx:t7NxYJTaaPTarGpQ6zSrWferHYaABV_OoyPrOdnGJg7ru41v9XDw3A>
    <xmx:uLNxYIJOaAU3Dx8q2uRsfn-9nhJDmkRx80JY5livz0ktPkmlTduCVQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8ED74240065;
        Sat, 10 Apr 2021 10:18:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: sched: fix action overwrite reference counting" failed to apply to 4.14-stable tree
To:     vladbu@nvidia.com, davem@davemloft.net, memxor@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Apr 2021 16:18:30 +0200
Message-ID: <16180643102052@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 87c750e8c38bce706eb32e4d8f1e3402f2cebbd4 Mon Sep 17 00:00:00 2001
From: Vlad Buslov <vladbu@nvidia.com>
Date: Wed, 7 Apr 2021 18:36:03 +0300
Subject: [PATCH] net: sched: fix action overwrite reference counting

Action init code increments reference counter when it changes an action.
This is the desired behavior for cls API which needs to obtain action
reference for every classifier that points to action. However, act API just
needs to change the action and releases the reference before returning.
This sequence breaks when the requested action doesn't exist, which causes
act API init code to create new action with specified index, but action is
still released before returning and is deleted (unless it was referenced
concurrently by cls API).

Reproduction:

$ sudo tc actions ls action gact
$ sudo tc actions change action gact drop index 1
$ sudo tc actions ls action gact

Extend tcf_action_init() to accept 'init_res' array and initialize it with
action->ops->init() result. In tcf_action_add() remove pointers to created
actions from actions array before passing it to tcf_action_put_many().

Fixes: cae422f379f3 ("net: sched: use reference counting action init")
Reported-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 2bf3092ae7ec..312f0f6554a0 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -185,7 +185,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 		    int nr_actions, struct tcf_result *res);
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, char *name, int ovr, int bind,
-		    struct tc_action *actions[], size_t *attr_size,
+		    struct tc_action *actions[], int init_res[], size_t *attr_size,
 		    bool rtnl_held, struct netlink_ext_ack *extack);
 struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
 					 bool rtnl_held,
@@ -193,7 +193,8 @@ struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
-				    struct tc_action_ops *ops, bool rtnl_held,
+				    struct tc_action_ops *a_o, int *init_res,
+				    bool rtnl_held,
 				    struct netlink_ext_ack *extack);
 int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[], int bind,
 		    int ref, bool terse);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index b919826939e0..50854cfbfcdb 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -992,7 +992,8 @@ struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
-				    struct tc_action_ops *a_o, bool rtnl_held,
+				    struct tc_action_ops *a_o, int *init_res,
+				    bool rtnl_held,
 				    struct netlink_ext_ack *extack)
 {
 	struct nla_bitfield32 flags = { 0, 0 };
@@ -1028,6 +1029,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	}
 	if (err < 0)
 		goto err_out;
+	*init_res = err;
 
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
@@ -1056,7 +1058,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, char *name, int ovr, int bind,
-		    struct tc_action *actions[], size_t *attr_size,
+		    struct tc_action *actions[], int init_res[], size_t *attr_size,
 		    bool rtnl_held, struct netlink_ext_ack *extack)
 {
 	struct tc_action_ops *ops[TCA_ACT_MAX_PRIO] = {};
@@ -1084,7 +1086,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 
 	for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
 		act = tcf_action_init_1(net, tp, tb[i], est, name, ovr, bind,
-					ops[i - 1], rtnl_held, extack);
+					ops[i - 1], &init_res[i - 1], rtnl_held,
+					extack);
 		if (IS_ERR(act)) {
 			err = PTR_ERR(act);
 			goto err;
@@ -1497,12 +1500,13 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 			  struct netlink_ext_ack *extack)
 {
 	size_t attr_size = 0;
-	int loop, ret;
+	int loop, ret, i;
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {};
+	int init_res[TCA_ACT_MAX_PRIO] = {};
 
 	for (loop = 0; loop < 10; loop++) {
 		ret = tcf_action_init(net, NULL, nla, NULL, NULL, ovr, 0,
-				      actions, &attr_size, true, extack);
+				      actions, init_res, &attr_size, true, extack);
 		if (ret != -EAGAIN)
 			break;
 	}
@@ -1510,8 +1514,12 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 	if (ret < 0)
 		return ret;
 	ret = tcf_add_notify(net, n, actions, portid, attr_size, extack);
-	if (ovr)
-		tcf_action_put_many(actions);
+
+	/* only put existing actions */
+	for (i = 0; i < TCA_ACT_MAX_PRIO; i++)
+		if (init_res[i] == ACT_P_CREATED)
+			actions[i] = NULL;
+	tcf_action_put_many(actions);
 
 	return ret;
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 9332ec6863e8..9ecb91ebf094 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3040,6 +3040,7 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 {
 #ifdef CONFIG_NET_CLS_ACT
 	{
+		int init_res[TCA_ACT_MAX_PRIO] = {};
 		struct tc_action *act;
 		size_t attr_size = 0;
 
@@ -3051,8 +3052,8 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 				return PTR_ERR(a_o);
 			act = tcf_action_init_1(net, tp, tb[exts->police],
 						rate_tlv, "police", ovr,
-						TCA_ACT_BIND, a_o, rtnl_held,
-						extack);
+						TCA_ACT_BIND, a_o, init_res,
+						rtnl_held, extack);
 			if (IS_ERR(act)) {
 				module_put(a_o->owner);
 				return PTR_ERR(act);
@@ -3067,8 +3068,8 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 
 			err = tcf_action_init(net, tp, tb[exts->action],
 					      rate_tlv, NULL, ovr, TCA_ACT_BIND,
-					      exts->actions, &attr_size,
-					      rtnl_held, extack);
+					      exts->actions, init_res,
+					      &attr_size, rtnl_held, extack);
 			if (err < 0)
 				return err;
 			exts->nr_actions = err;

