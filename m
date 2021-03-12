Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E18338CA9
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhCLMYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:24:32 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:41941 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230398AbhCLMYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 07:24:03 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 537191942C71;
        Fri, 12 Mar 2021 07:24:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 12 Mar 2021 07:24:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mjnKIg
        UT13eXH8l3M2EP0tUzyMHeJ4rV4hEEwg88AI0=; b=DucGBH4yRQetxnlQp0Eux/
        BZ1SLjKqBiWlmo5W+KEFqj3lsiwy1RC4QnlUZ05+hu5w+2H39wiVGW5R8WKj4muD
        Yx4B+xdeP9tjudoNnBCAsJVXfA8KW6uwCmNxKwaJrx+2wzo/FgfL66C4A9Uh208e
        5B4PcL+xwvXZkaS1nsGhAb1WMul6kKzUxDw2rumZcgqgOYwmH9zupaCB7tAMqXhd
        VSwrmhg553zB9ZS/qa3VQl5wl9kkwSSxQTFPVsAy6pilvz4yqMql3HZRiho4EInY
        XqCTOBW0ELMKfIKyaOAN0dTtSgYracBSQSgWcHEjL3DEmJPhM/ZZezW7JNxjs/qQ
        ==
X-ME-Sender: <xms:Y11LYMvVrNSvzyftZ6nJ6mkd4ROXs50LeznTGZ9I5DQBZUcsymc3_g>
    <xme:Y11LYEVzomRUfbWb2u2Nqzx5MM7nF9k0IZBHKHzppjjpL8qZ5LAyQYBuWXotLQWaE
    idR6TSQVDljwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:Y11LYPnShUmNVlxCjDVHX3gEfEmz5MJ0f88sXI3C8VIF7mp4fuOp4Q>
    <xmx:Y11LYNaX_GJrBzCYMyh2ZLzqHEXICdxOrikjOVLnnBpuNXx9T8shSA>
    <xmx:Y11LYCP4XnwCabfLZbjRbCF3OICcmjQm6RJV_ge9tQrwJOv0hUQOpA>
    <xmx:Y11LYB-9fkgdP-FAB6Tto5cJl-CoDkcfar295BaP6YHBZT50cekB9A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CBB221080064;
        Fri, 12 Mar 2021 07:24:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] net: dsa: tag_mtk: fix 802.1ad VLAN egress" failed to apply to 5.10-stable tree
To:     dqfext@gmail.com, davem@davemloft.net, iochesonome@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 13:24:01 +0100
Message-ID: <1615551841172192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9200f515c41f4cbaeffd8fdd1d8b6373a18b1b67 Mon Sep 17 00:00:00 2001
From: DENG Qingfang <dqfext@gmail.com>
Date: Tue, 2 Mar 2021 00:01:59 +0800
Subject: [PATCH] net: dsa: tag_mtk: fix 802.1ad VLAN egress

A different TPID bit is used for 802.1ad VLAN frames.

Reported-by: Ilario Gelmetti <iochesonome@gmail.com>
Fixes: f0af34317f4b ("net: dsa: mediatek: combine MediaTek tag with VLAN tag")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 38dcdded74c0..59748487664f 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -13,6 +13,7 @@
 #define MTK_HDR_LEN		4
 #define MTK_HDR_XMIT_UNTAGGED		0
 #define MTK_HDR_XMIT_TAGGED_TPID_8100	1
+#define MTK_HDR_XMIT_TAGGED_TPID_88A8	2
 #define MTK_HDR_RECV_SOURCE_PORT_MASK	GENMASK(2, 0)
 #define MTK_HDR_XMIT_DP_BIT_MASK	GENMASK(5, 0)
 #define MTK_HDR_XMIT_SA_DIS		BIT(6)
@@ -21,8 +22,8 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u8 xmit_tpid;
 	u8 *mtk_tag;
-	bool is_vlan_skb = true;
 	unsigned char *dest = eth_hdr(skb)->h_dest;
 	bool is_multicast_skb = is_multicast_ether_addr(dest) &&
 				!is_broadcast_ether_addr(dest);
@@ -33,10 +34,17 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	 * the both special and VLAN tag at the same time and then look up VLAN
 	 * table with VID.
 	 */
-	if (!skb_vlan_tagged(skb)) {
+	switch (skb->protocol) {
+	case htons(ETH_P_8021Q):
+		xmit_tpid = MTK_HDR_XMIT_TAGGED_TPID_8100;
+		break;
+	case htons(ETH_P_8021AD):
+		xmit_tpid = MTK_HDR_XMIT_TAGGED_TPID_88A8;
+		break;
+	default:
+		xmit_tpid = MTK_HDR_XMIT_UNTAGGED;
 		skb_push(skb, MTK_HDR_LEN);
 		memmove(skb->data, skb->data + MTK_HDR_LEN, 2 * ETH_ALEN);
-		is_vlan_skb = false;
 	}
 
 	mtk_tag = skb->data + 2 * ETH_ALEN;
@@ -44,8 +52,7 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	/* Mark tag attribute on special tag insertion to notify hardware
 	 * whether that's a combined special tag with 802.1Q header.
 	 */
-	mtk_tag[0] = is_vlan_skb ? MTK_HDR_XMIT_TAGGED_TPID_8100 :
-		     MTK_HDR_XMIT_UNTAGGED;
+	mtk_tag[0] = xmit_tpid;
 	mtk_tag[1] = (1 << dp->index) & MTK_HDR_XMIT_DP_BIT_MASK;
 
 	/* Disable SA learning for multicast frames */
@@ -53,7 +60,7 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 		mtk_tag[1] |= MTK_HDR_XMIT_SA_DIS;
 
 	/* Tag control information is kept for 802.1Q */
-	if (!is_vlan_skb) {
+	if (xmit_tpid == MTK_HDR_XMIT_UNTAGGED) {
 		mtk_tag[2] = 0;
 		mtk_tag[3] = 0;
 	}

