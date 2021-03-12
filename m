Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FCA338C94
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhCLMWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:22:22 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:54063 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230127AbhCLMVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 07:21:51 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id EF33A1942B13;
        Fri, 12 Mar 2021 07:21:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 12 Mar 2021 07:21:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3a1lyK
        uLnC6hlgT93StrNj0Klhi0HU7rSs9axgy0pHI=; b=EiG5aUyf8Lu9EGzeF22A8u
        WIL2j7Py+Hmv7Iy+AKy8IG1Ib+GGzoJhFWNF73bRoYFH0iePPBJdjqkJ7CbHiLf4
        QxcvEoJi1HIQtiRcSsBrI1teeTpYA7MXOC1W7B467kBxTf4Ljuu66+V/LaDKAbGw
        CpbrKyk4vr5sA8nKYkgk40ITR+6NsZgVrpJWfoKNCowyBaPqtKqPZH8mN/KX0ASl
        DYMi60sGlDjwMldnN7YVeqQ036+7lKg2hPK4ezMECB3Va0zMuAzAMLy+bZIRenxH
        O6gmnV8dsHfksvb8r7C7/NHJLaGh08heFDni2Q6SwcZb0J+fBD7QcrAUJXEKpYIA
        ==
X-ME-Sender: <xms:3lxLYA4VRyXivNBVx0MOP2mm0UXo1RUFN_T0KimMDYQnR94Q9668GQ>
    <xme:3lxLYB6nDJHm5tocI8urhQYBft2_s-EaKRrP4G0Tl3KOn-0kJGscGP7mbmcZ0V6a0
    IomGJ5u-ole4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:3lxLYPdzkCvb2yV5j5DTfhAYhiUe3A8s_QBEJ0faU4b3cjdHFNfKzg>
    <xmx:3lxLYFK2SLOgaiVvrcWcsNReISSbh3PLBTipK5R5_b5j7l5dAdu9wg>
    <xmx:3lxLYEIRnxWQLaE0GcV3BPJE6mh77f3gw7TygFt_iF-JjGfembOZpQ>
    <xmx:3lxLYOx4pak3VKTmYSj9VMOn7PKxv-2mmkGEi7QqYqfHa1YfUWl1OQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1600E240057;
        Fri, 12 Mar 2021 07:21:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] net: enetc: fix incorrect TPID when receiving 802.1ad tagged" failed to apply to 5.4-stable tree
To:     vladimir.oltean@nxp.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 13:21:48 +0100
Message-ID: <161555170819198@kroah.com>
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

From 827b6fd046516af605e190c872949f22208b5d41 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon, 1 Mar 2021 13:18:14 +0200
Subject: [PATCH] net: enetc: fix incorrect TPID when receiving 802.1ad tagged
 packets

When the enetc ports have rx-vlan-offload enabled, they report a TPID of
ETH_P_8021Q regardless of what was actually in the packet. When
rx-vlan-offload is disabled, packets have the proper TPID. Fix this
inconsistency by finishing the TODO left in the code.

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 9bcceb74fb9c..8ddf0cdc37a5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -523,9 +523,8 @@ static void enetc_get_rx_tstamp(struct net_device *ndev,
 static void enetc_get_offloads(struct enetc_bdr *rx_ring,
 			       union enetc_rx_bd *rxbd, struct sk_buff *skb)
 {
-#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	struct enetc_ndev_priv *priv = netdev_priv(rx_ring->ndev);
-#endif
+
 	/* TODO: hashing */
 	if (rx_ring->ndev->features & NETIF_F_RXCSUM) {
 		u16 inet_csum = le16_to_cpu(rxbd->r.inet_csum);
@@ -534,12 +533,31 @@ static void enetc_get_offloads(struct enetc_bdr *rx_ring,
 		skb->ip_summed = CHECKSUM_COMPLETE;
 	}
 
-	/* copy VLAN to skb, if one is extracted, for now we assume it's a
-	 * standard TPID, but HW also supports custom values
-	 */
-	if (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_VLAN)
-		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
-				       le16_to_cpu(rxbd->r.vlan_opt));
+	if (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_VLAN) {
+		__be16 tpid = 0;
+
+		switch (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_TPID) {
+		case 0:
+			tpid = htons(ETH_P_8021Q);
+			break;
+		case 1:
+			tpid = htons(ETH_P_8021AD);
+			break;
+		case 2:
+			tpid = htons(enetc_port_rd(&priv->si->hw,
+						   ENETC_PCVLANR1));
+			break;
+		case 3:
+			tpid = htons(enetc_port_rd(&priv->si->hw,
+						   ENETC_PCVLANR2));
+			break;
+		default:
+			break;
+		}
+
+		__vlan_hwaccel_put_tag(skb, tpid, le16_to_cpu(rxbd->r.vlan_opt));
+	}
+
 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	if (priv->active_offloads & ENETC_F_RX_TSTAMP)
 		enetc_get_rx_tstamp(rx_ring->ndev, rxbd, skb);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 8b54562f5da6..a62604a1e54e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -172,6 +172,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PSIPMAR0(n)	(0x0100 + (n) * 0x8) /* n = SI index */
 #define ENETC_PSIPMAR1(n)	(0x0104 + (n) * 0x8)
 #define ENETC_PVCLCTR		0x0208
+#define ENETC_PCVLANR1		0x0210
+#define ENETC_PCVLANR2		0x0214
 #define ENETC_VLAN_TYPE_C	BIT(0)
 #define ENETC_VLAN_TYPE_S	BIT(1)
 #define ENETC_PVCLCTR_OVTPIDL(bmp)	((bmp) & 0xff) /* VLAN_TYPE */
@@ -570,6 +572,7 @@ union enetc_rx_bd {
 #define ENETC_RXBD_LSTATUS(flags)	((flags) << 16)
 #define ENETC_RXBD_FLAG_VLAN	BIT(9)
 #define ENETC_RXBD_FLAG_TSTMP	BIT(10)
+#define ENETC_RXBD_FLAG_TPID	GENMASK(1, 0)
 
 #define ENETC_MAC_ADDR_FILT_CNT	8 /* # of supported entries per port */
 #define EMETC_MAC_ADDR_FILT_RES	3 /* # of reserved entries at the beginning */

