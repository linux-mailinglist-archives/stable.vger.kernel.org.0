Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E5032D60E
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 16:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhCDPHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 10:07:32 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:42699 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229538AbhCDPHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 10:07:00 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B2B511562;
        Thu,  4 Mar 2021 10:05:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 04 Mar 2021 10:05:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zAOLuo
        sdwgcHF9WYeYV/PN+VOkF1n1+ODAA2fq3j+W0=; b=I+4LiK/C6jKdr+PZy8gDF7
        V96GmFXU0NO+qy7S81b9EqPEp7VSTNGf0StZl8YaeRcQe9kSopTHHB5oKE5l9VYG
        mMllU2m/WttQC2iJG0l4qDQPo8hEp2djPx2UZVq/InWjOhfLCpFaUG0ymDOS5YEJ
        9zkaK17A/fBZ4q7lbQU/2bkPe2pGUek+LIExDLF7f+8V2DhZLL+k5brFvcf8JpdQ
        Wdtcik6yAfP64wpguxb1Ss+fgjT41fQQ0upooMSVLhTV8uGsk3ioahtS2BVdouJp
        r7XoQMn3Pa0uOg0vBMn2vTJb9mAaUHneWxw+hhWPBpEA5LmThlbU7KUSeoau1A7g
        ==
X-ME-Sender: <xms:UPdAYMPKVSIX48sbD8joN2pUoOAHc8c-Qk3odqk06t2UVMywIWTMXg>
    <xme:UPdAYC-jbACO0BgBTqNf9lV4jGvaSoOClliSpi6-jXvHyNqptbqo-YT1XmtrxI1xT
    1opNM5WSLcjDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:UPdAYDQNkvH3wPaVCjR5XgeJZ6ImoReQDjvpENn5pqyblckcKPktGQ>
    <xmx:UPdAYEvD35vUu37ViiA9NdYo2vY_VGHFefLMxaIrijmr66DZjqQKMw>
    <xmx:UPdAYEdNI7fsHE-pQDkkBDcOo_Cg4aPfvChL7YEtXwx9b3lP9gqCNQ>
    <xmx:UvdAYFocmokp7C-CD-gbch2Rf_67EcSHqc-UuiWw3gQ3azIQaNWRaz0VLUs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4FBFA1080066;
        Thu,  4 Mar 2021 10:05:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] net/sched: cls_flower: Reject invalid ct_state flags rules" failed to apply to 5.4-stable tree
To:     wenxu@ucloud.cn, davem@davemloft.net, kuba@kernel.org,
        marcelo.leitner@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Mar 2021 16:05:50 +0100
Message-ID: <161487035070165@kroah.com>
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

From 1bcc51ac0731aab1b109b2cd5c3d495f1884e5ca Mon Sep 17 00:00:00 2001
From: wenxu <wenxu@ucloud.cn>
Date: Tue, 9 Feb 2021 14:37:49 +0800
Subject: [PATCH] net/sched: cls_flower: Reject invalid ct_state flags rules

Reject the unsupported and invalid ct_state flags of cls flower rules.

Fixes: e0ace68af2ac ("net/sched: cls_flower: Add matching on conntrack info")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index ee95f42fb0ec..88f4bf0047e7 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -591,6 +591,8 @@ enum {
 	TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED = 1 << 1, /* Part of an existing connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_RELATED = 1 << 2, /* Related to an established connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_TRACKED = 1 << 3, /* Conntrack has occurred. */
+
+	__TCA_FLOWER_KEY_CT_FLAGS_MAX,
 };
 
 enum {
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 84f932532db7..46c1b3e9f66a 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -30,6 +30,11 @@
 
 #include <uapi/linux/netfilter/nf_conntrack_common.h>
 
+#define TCA_FLOWER_KEY_CT_FLAGS_MAX \
+		((__TCA_FLOWER_KEY_CT_FLAGS_MAX - 1) << 1)
+#define TCA_FLOWER_KEY_CT_FLAGS_MASK \
+		(TCA_FLOWER_KEY_CT_FLAGS_MAX - 1)
+
 struct fl_flow_key {
 	struct flow_dissector_key_meta meta;
 	struct flow_dissector_key_control control;
@@ -686,8 +691,10 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_ENC_IP_TTL_MASK] = { .type = NLA_U8 },
 	[TCA_FLOWER_KEY_ENC_OPTS]	= { .type = NLA_NESTED },
 	[TCA_FLOWER_KEY_ENC_OPTS_MASK]	= { .type = NLA_NESTED },
-	[TCA_FLOWER_KEY_CT_STATE]	= { .type = NLA_U16 },
-	[TCA_FLOWER_KEY_CT_STATE_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_CT_STATE]	=
+		NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK),
+	[TCA_FLOWER_KEY_CT_STATE_MASK]	=
+		NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK),
 	[TCA_FLOWER_KEY_CT_ZONE]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_CT_ZONE_MASK]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_CT_MARK]	= { .type = NLA_U32 },
@@ -1390,12 +1397,33 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 	return 0;
 }
 
+static int fl_validate_ct_state(u16 state, struct nlattr *tb,
+				struct netlink_ext_ack *extack)
+{
+	if (state && !(state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
+		NL_SET_ERR_MSG_ATTR(extack, tb,
+				    "no trk, so no other flag can be set");
+		return -EINVAL;
+	}
+
+	if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
+	    state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED) {
+		NL_SET_ERR_MSG_ATTR(extack, tb,
+				    "new and est are mutually exclusive");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int fl_set_key_ct(struct nlattr **tb,
 			 struct flow_dissector_key_ct *key,
 			 struct flow_dissector_key_ct *mask,
 			 struct netlink_ext_ack *extack)
 {
 	if (tb[TCA_FLOWER_KEY_CT_STATE]) {
+		int err;
+
 		if (!IS_ENABLED(CONFIG_NF_CONNTRACK)) {
 			NL_SET_ERR_MSG(extack, "Conntrack isn't enabled");
 			return -EOPNOTSUPP;
@@ -1403,6 +1431,13 @@ static int fl_set_key_ct(struct nlattr **tb,
 		fl_set_key_val(tb, &key->ct_state, TCA_FLOWER_KEY_CT_STATE,
 			       &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
 			       sizeof(key->ct_state));
+
+		err = fl_validate_ct_state(mask->ct_state,
+					   tb[TCA_FLOWER_KEY_CT_STATE_MASK],
+					   extack);
+		if (err)
+			return err;
+
 	}
 	if (tb[TCA_FLOWER_KEY_CT_ZONE]) {
 		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)) {

