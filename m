Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C914328301
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbhCAQFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:05:50 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:37431 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237488AbhCAQE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 11:04:27 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5C30519428FE;
        Mon,  1 Mar 2021 11:02:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 11:02:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/Xm+tt
        Db3WTJOcM42M/XSf0fu2wyJ9HBIn4dmaut1ZE=; b=n2l5LCZjmEj8kVBi/RRVPR
        vNSlqVBc1M1ERSJzYKjDHY6ZkMTs+qcfdS7L95Xt73ivCeqc7DmzAlSAwR8tEITd
        ggyYaHP0x15SDHdaKRuqDEcLjNzxEs0ZqB48UBkq/1LlS3WINN5mZeiUDbH2izC5
        DsXmVtzXh7zY7LqRb+wGiM3JGnXK2m6w5vkOdgK8IR2YTLtmq4QZmEMbNpZ1E4ea
        A0FlF4tL4IE+JztLZdtHXO4LHJVuqRIk7PwXCH8MNHFySfXvrweJV2SKElrkiAFI
        6YPlVZemS+HI3EYzRJCnbB4J6Cp9AJx7cDUQd7/hME1JpR05jIxxkwewsxsvkU2A
        ==
X-ME-Sender: <xms:MBA9YO0AM9d3HuUPz3K8nKxqSnXipAQKcQNMwN8IJlg842haLndoUA>
    <xme:MBA9YBFv_hsK5-Y2sfpEZR-2T37S_zBLHeCsAOdPfBTT--K8-0QCA1GFipxXjZaJo
    RU9ZbDg5NV4Xw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:MBA9YG7oKpxhyDi2Itr2BJ-YHYeCq07jw66O5FegjtJt5gCqNytrJw>
    <xmx:MBA9YP02Y_mIy__XsibJulYtCoFZXroC6NyqVOKyX_WGmdmYjy9iHw>
    <xmx:MBA9YBF8JaYvl1y6Vy6jpLiUGLSYnGwJSiGxbjyRFAd3gsvjpcWjqw>
    <xmx:MRA9YGSaI-1aaemO5gbAPdazyNEeLy7iv6819K5uATgp2JK7uwhbpg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8BD6E240054;
        Mon,  1 Mar 2021 11:02:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] net_sched: fix RTNL deadlock again caused by request_module()" failed to apply to 5.4-stable tree
To:     cong.wang@bytedance.com, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 17:02:54 +0100
Message-ID: <161461457416034@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d349f997686887906b1183b5be96933c5452362a Mon Sep 17 00:00:00 2001
From: Cong Wang <cong.wang@bytedance.com>
Date: Sat, 16 Jan 2021 16:56:57 -0800
Subject: [PATCH] net_sched: fix RTNL deadlock again caused by request_module()

tcf_action_init_1() loads tc action modules automatically with
request_module() after parsing the tc action names, and it drops RTNL
lock and re-holds it before and after request_module(). This causes a
lot of troubles, as discovered by syzbot, because we can be in the
middle of batch initializations when we create an array of tc actions.

One of the problem is deadlock:

CPU 0					CPU 1
rtnl_lock();
for (...) {
  tcf_action_init_1();
    -> rtnl_unlock();
    -> request_module();
				rtnl_lock();
				for (...) {
				  tcf_action_init_1();
				    -> tcf_idr_check_alloc();
				   // Insert one action into idr,
				   // but it is not committed until
				   // tcf_idr_insert_many(), then drop
				   // the RTNL lock in the _next_
				   // iteration
				   -> rtnl_unlock();
    -> rtnl_lock();
    -> a_o->init();
      -> tcf_idr_check_alloc();
      // Now waiting for the same index
      // to be committed
				    -> request_module();
				    -> rtnl_lock()
				    // Now waiting for RTNL lock
				}
				rtnl_unlock();
}
rtnl_unlock();

This is not easy to solve, we can move the request_module() before
this loop and pre-load all the modules we need for this netlink
message and then do the rest initializations. So the loop breaks down
to two now:

        for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
                struct tc_action_ops *a_o;

                a_o = tc_action_load_ops(name, tb[i]...);
                ops[i - 1] = a_o;
        }

        for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
                act = tcf_action_init_1(ops[i - 1]...);
        }

Although this looks serious, it only has been reported by syzbot, so it
seems hard to trigger this by humans. And given the size of this patch,
I'd suggest to make it to net-next and not to backport to stable.

This patch has been tested by syzbot and tested with tdc.py by me.

Fixes: 0fedc63fadf0 ("net_sched: commit action insertions together")
Reported-and-tested-by: syzbot+82752bc5331601cf4899@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+b3b63b6bff456bd95294@syzkaller.appspotmail.com
Reported-by: syzbot+ba67b12b1ca729912834@syzkaller.appspotmail.com
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20210117005657.14810-1-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 55dab604861f..761c0e331915 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -186,10 +186,13 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, char *name, int ovr, int bind,
 		    struct tc_action *actions[], size_t *attr_size,
 		    bool rtnl_held, struct netlink_ext_ack *extack);
+struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
+					 bool rtnl_held,
+					 struct netlink_ext_ack *extack);
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
-				    bool rtnl_held,
+				    struct tc_action_ops *ops, bool rtnl_held,
 				    struct netlink_ext_ack *extack);
 int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[], int bind,
 		    int ref, bool terse);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 2e85b636b27b..4dd235ce9a07 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -928,19 +928,13 @@ static void tcf_idr_insert_many(struct tc_action *actions[])
 	}
 }
 
-struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
-				    struct nlattr *nla, struct nlattr *est,
-				    char *name, int ovr, int bind,
-				    bool rtnl_held,
-				    struct netlink_ext_ack *extack)
+struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
+					 bool rtnl_held,
+					 struct netlink_ext_ack *extack)
 {
-	struct nla_bitfield32 flags = { 0, 0 };
-	u8 hw_stats = TCA_ACT_HW_STATS_ANY;
-	struct tc_action *a;
+	struct nlattr *tb[TCA_ACT_MAX + 1];
 	struct tc_action_ops *a_o;
-	struct tc_cookie *cookie = NULL;
 	char act_name[IFNAMSIZ];
-	struct nlattr *tb[TCA_ACT_MAX + 1];
 	struct nlattr *kind;
 	int err;
 
@@ -948,33 +942,21 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 		err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla,
 						  tcf_action_policy, extack);
 		if (err < 0)
-			goto err_out;
+			return ERR_PTR(err);
 		err = -EINVAL;
 		kind = tb[TCA_ACT_KIND];
 		if (!kind) {
 			NL_SET_ERR_MSG(extack, "TC action kind must be specified");
-			goto err_out;
+			return ERR_PTR(err);
 		}
 		if (nla_strscpy(act_name, kind, IFNAMSIZ) < 0) {
 			NL_SET_ERR_MSG(extack, "TC action name too long");
-			goto err_out;
-		}
-		if (tb[TCA_ACT_COOKIE]) {
-			cookie = nla_memdup_cookie(tb);
-			if (!cookie) {
-				NL_SET_ERR_MSG(extack, "No memory to generate TC cookie");
-				err = -ENOMEM;
-				goto err_out;
-			}
+			return ERR_PTR(err);
 		}
-		hw_stats = tcf_action_hw_stats_get(tb[TCA_ACT_HW_STATS]);
-		if (tb[TCA_ACT_FLAGS])
-			flags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
 	} else {
 		if (strlcpy(act_name, name, IFNAMSIZ) >= IFNAMSIZ) {
 			NL_SET_ERR_MSG(extack, "TC action name too long");
-			err = -EINVAL;
-			goto err_out;
+			return ERR_PTR(-EINVAL);
 		}
 	}
 
@@ -996,24 +978,56 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 		 * indicate this using -EAGAIN.
 		 */
 		if (a_o != NULL) {
-			err = -EAGAIN;
-			goto err_mod;
+			module_put(a_o->owner);
+			return ERR_PTR(-EAGAIN);
 		}
 #endif
 		NL_SET_ERR_MSG(extack, "Failed to load TC action module");
-		err = -ENOENT;
-		goto err_free;
+		return ERR_PTR(-ENOENT);
 	}
 
+	return a_o;
+}
+
+struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
+				    struct nlattr *nla, struct nlattr *est,
+				    char *name, int ovr, int bind,
+				    struct tc_action_ops *a_o, bool rtnl_held,
+				    struct netlink_ext_ack *extack)
+{
+	struct nla_bitfield32 flags = { 0, 0 };
+	u8 hw_stats = TCA_ACT_HW_STATS_ANY;
+	struct nlattr *tb[TCA_ACT_MAX + 1];
+	struct tc_cookie *cookie = NULL;
+	struct tc_action *a;
+	int err;
+
 	/* backward compatibility for policer */
-	if (name == NULL)
+	if (name == NULL) {
+		err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla,
+						  tcf_action_policy, extack);
+		if (err < 0)
+			return ERR_PTR(err);
+		if (tb[TCA_ACT_COOKIE]) {
+			cookie = nla_memdup_cookie(tb);
+			if (!cookie) {
+				NL_SET_ERR_MSG(extack, "No memory to generate TC cookie");
+				err = -ENOMEM;
+				goto err_out;
+			}
+		}
+		hw_stats = tcf_action_hw_stats_get(tb[TCA_ACT_HW_STATS]);
+		if (tb[TCA_ACT_FLAGS])
+			flags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
+
 		err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, ovr, bind,
 				rtnl_held, tp, flags.value, extack);
-	else
+	} else {
 		err = a_o->init(net, nla, est, &a, ovr, bind, rtnl_held,
 				tp, flags.value, extack);
+	}
 	if (err < 0)
-		goto err_mod;
+		goto err_out;
 
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
@@ -1030,14 +1044,11 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 
 	return a;
 
-err_mod:
-	module_put(a_o->owner);
-err_free:
+err_out:
 	if (cookie) {
 		kfree(cookie->data);
 		kfree(cookie);
 	}
-err_out:
 	return ERR_PTR(err);
 }
 
@@ -1048,6 +1059,7 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct tc_action *actions[], size_t *attr_size,
 		    bool rtnl_held, struct netlink_ext_ack *extack)
 {
+	struct tc_action_ops *ops[TCA_ACT_MAX_PRIO] = {};
 	struct nlattr *tb[TCA_ACT_MAX_PRIO + 1];
 	struct tc_action *act;
 	size_t sz = 0;
@@ -1059,9 +1071,20 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	if (err < 0)
 		return err;
 
+	for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
+		struct tc_action_ops *a_o;
+
+		a_o = tc_action_load_ops(name, tb[i], rtnl_held, extack);
+		if (IS_ERR(a_o)) {
+			err = PTR_ERR(a_o);
+			goto err_mod;
+		}
+		ops[i - 1] = a_o;
+	}
+
 	for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
 		act = tcf_action_init_1(net, tp, tb[i], est, name, ovr, bind,
-					rtnl_held, extack);
+					ops[i - 1], rtnl_held, extack);
 		if (IS_ERR(act)) {
 			err = PTR_ERR(act);
 			goto err;
@@ -1081,6 +1104,11 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 
 err:
 	tcf_action_destroy(actions, bind);
+err_mod:
+	for (i = 0; i < TCA_ACT_MAX_PRIO; i++) {
+		if (ops[i])
+			module_put(ops[i]->owner);
+	}
 	return err;
 }
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 37b77bd30974..a67c66a512a4 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3043,12 +3043,19 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 		size_t attr_size = 0;
 
 		if (exts->police && tb[exts->police]) {
+			struct tc_action_ops *a_o;
+
+			a_o = tc_action_load_ops("police", tb[exts->police], rtnl_held, extack);
+			if (IS_ERR(a_o))
+				return PTR_ERR(a_o);
 			act = tcf_action_init_1(net, tp, tb[exts->police],
 						rate_tlv, "police", ovr,
-						TCA_ACT_BIND, rtnl_held,
+						TCA_ACT_BIND, a_o, rtnl_held,
 						extack);
-			if (IS_ERR(act))
+			if (IS_ERR(act)) {
+				module_put(a_o->owner);
 				return PTR_ERR(act);
+			}
 
 			act->type = exts->type = TCA_OLD_COMPAT;
 			exts->actions[0] = act;

