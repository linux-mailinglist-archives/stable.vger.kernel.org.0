Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C85A5176261
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 19:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgCBSV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 13:21:26 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:49911 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726997AbgCBSV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 13:21:26 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 698F8754;
        Mon,  2 Mar 2020 13:21:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 02 Mar 2020 13:21:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=UPqjdr
        OafJKvwdMMAGz0ItRsyv29A6iY7jJY+2NSVHw=; b=aVWJivJ5V0LQIZYgqqT7Nr
        cVj0VhMUSnaGd1khe/WAdNCnRnc+tajdgyrtX+8Ly+X4Q/JjzviD2dp36g45aGXY
        bDlzjFC4Wtm5kelJN3Pq2IzdV21+gCx4D3pPHGOU/Y1YGQ/u1wFOLgSWwVWpWqTo
        JqYg03eb+gv/CFnQEpqvUIb6gPuiU/wIv/G5JkLuJBKP6cXndNGqJVOJnTatsjws
        P8vNZeQOVOrsn2XXBJmh4lI2jy6kZrLZ8Z/NSSYby4RytAimKanUFn9JIxGTqP2y
        BifM77nIjtiD1yHwte2E1NJmcteiaOdPGW3c/SheDtDlT1tgd9CXu/Hhu2mx8wJA
        ==
X-ME-Sender: <xms:pE5dXqW5P8JbzJHkwE_RXRcNc8Qjw1Jksk7RyPq5sgvpo6_MJnpBgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtgedgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepud
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:pE5dXi4Tit2ZgDlM3Kxml4WPTutu7eKAwpek1YHsVUgVpIhXgBxNTQ>
    <xmx:pE5dXgAhY60j3nEHwsZNdS4Iu4s80TnLJPWqDe-bS9Gr6XfIHRvMeQ>
    <xmx:pE5dXufLH5i2vf0FSyYBBnKBPMDw_1kAwhV4OrcE7iEb0qIf2UP9vQ>
    <xmx:pU5dXkpAglR173UAd3AhYTorNNPaM2-mvihJsTI-i-J5ktVhy8UfoQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A62C73280059;
        Mon,  2 Mar 2020 13:21:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] audit: always check the netlink payload length in" failed to apply to 4.9-stable tree
To:     paul@paul-moore.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Mar 2020 19:21:12 +0100
Message-ID: <1583173272195153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 756125289285f6e55a03861bf4b6257aa3d19a93 Mon Sep 17 00:00:00 2001
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 24 Feb 2020 16:38:57 -0500
Subject: [PATCH] audit: always check the netlink payload length in
 audit_receive_msg()

This patch ensures that we always check the netlink payload length
in audit_receive_msg() before we take any action on the payload
itself.

Cc: stable@vger.kernel.org
Reported-by: syzbot+399c44bf1f43b8747403@syzkaller.appspotmail.com
Reported-by: syzbot+e4b12d8d202701f08b6d@syzkaller.appspotmail.com
Signed-off-by: Paul Moore <paul@paul-moore.com>

diff --git a/kernel/audit.c b/kernel/audit.c
index 17b0d523afb3..9ddfe2aa6671 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1101,13 +1101,11 @@ static void audit_log_feature_change(int which, u32 old_feature, u32 new_feature
 	audit_log_end(ab);
 }
 
-static int audit_set_feature(struct sk_buff *skb)
+static int audit_set_feature(struct audit_features *uaf)
 {
-	struct audit_features *uaf;
 	int i;
 
 	BUILD_BUG_ON(AUDIT_LAST_FEATURE + 1 > ARRAY_SIZE(audit_feature_names));
-	uaf = nlmsg_data(nlmsg_hdr(skb));
 
 	/* if there is ever a version 2 we should handle that here */
 
@@ -1175,6 +1173,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
 	u32			seq;
 	void			*data;
+	int			data_len;
 	int			err;
 	struct audit_buffer	*ab;
 	u16			msg_type = nlh->nlmsg_type;
@@ -1188,6 +1187,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 	seq  = nlh->nlmsg_seq;
 	data = nlmsg_data(nlh);
+	data_len = nlmsg_len(nlh);
 
 	switch (msg_type) {
 	case AUDIT_GET: {
@@ -1211,7 +1211,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		struct audit_status	s;
 		memset(&s, 0, sizeof(s));
 		/* guard against past and future API changes */
-		memcpy(&s, data, min_t(size_t, sizeof(s), nlmsg_len(nlh)));
+		memcpy(&s, data, min_t(size_t, sizeof(s), data_len));
 		if (s.mask & AUDIT_STATUS_ENABLED) {
 			err = audit_set_enabled(s.enabled);
 			if (err < 0)
@@ -1315,7 +1315,9 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			return err;
 		break;
 	case AUDIT_SET_FEATURE:
-		err = audit_set_feature(skb);
+		if (data_len < sizeof(struct audit_features))
+			return -EINVAL;
+		err = audit_set_feature(data);
 		if (err)
 			return err;
 		break;
@@ -1327,6 +1329,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 		err = audit_filter(msg_type, AUDIT_FILTER_USER);
 		if (err == 1) { /* match or error */
+			char *str = data;
+
 			err = 0;
 			if (msg_type == AUDIT_USER_TTY) {
 				err = tty_audit_push();
@@ -1334,26 +1338,24 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 					break;
 			}
 			audit_log_user_recv_msg(&ab, msg_type);
-			if (msg_type != AUDIT_USER_TTY)
+			if (msg_type != AUDIT_USER_TTY) {
+				/* ensure NULL termination */
+				str[data_len - 1] = '\0';
 				audit_log_format(ab, " msg='%.*s'",
 						 AUDIT_MESSAGE_TEXT_MAX,
-						 (char *)data);
-			else {
-				int size;
-
+						 str);
+			} else {
 				audit_log_format(ab, " data=");
-				size = nlmsg_len(nlh);
-				if (size > 0 &&
-				    ((unsigned char *)data)[size - 1] == '\0')
-					size--;
-				audit_log_n_untrustedstring(ab, data, size);
+				if (data_len > 0 && str[data_len - 1] == '\0')
+					data_len--;
+				audit_log_n_untrustedstring(ab, str, data_len);
 			}
 			audit_log_end(ab);
 		}
 		break;
 	case AUDIT_ADD_RULE:
 	case AUDIT_DEL_RULE:
-		if (nlmsg_len(nlh) < sizeof(struct audit_rule_data))
+		if (data_len < sizeof(struct audit_rule_data))
 			return -EINVAL;
 		if (audit_enabled == AUDIT_LOCKED) {
 			audit_log_common_recv_msg(audit_context(), &ab,
@@ -1365,7 +1367,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			audit_log_end(ab);
 			return -EPERM;
 		}
-		err = audit_rule_change(msg_type, seq, data, nlmsg_len(nlh));
+		err = audit_rule_change(msg_type, seq, data, data_len);
 		break;
 	case AUDIT_LIST_RULES:
 		err = audit_list_rules_send(skb, seq);
@@ -1380,7 +1382,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case AUDIT_MAKE_EQUIV: {
 		void *bufp = data;
 		u32 sizes[2];
-		size_t msglen = nlmsg_len(nlh);
+		size_t msglen = data_len;
 		char *old, *new;
 
 		err = -EINVAL;
@@ -1456,7 +1458,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 		memset(&s, 0, sizeof(s));
 		/* guard against past and future API changes */
-		memcpy(&s, data, min_t(size_t, sizeof(s), nlmsg_len(nlh)));
+		memcpy(&s, data, min_t(size_t, sizeof(s), data_len));
 		/* check if new data is valid */
 		if ((s.enabled != 0 && s.enabled != 1) ||
 		    (s.log_passwd != 0 && s.log_passwd != 1))

