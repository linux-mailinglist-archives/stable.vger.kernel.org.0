Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C533634A2
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 12:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhDRKhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 06:37:02 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:41693 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhDRKhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 06:37:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id BE9F419401B0;
        Sun, 18 Apr 2021 06:36:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 06:36:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Bcmc5L
        aaHegh7nr3KN+epE8iBwv3+An72tABos2koPI=; b=BiUzG+1Lw0UFE3DMwCSUda
        DRmggGQHE90RgfrxED+zD7SAsx4ikAbr7xo5LD19MZeELW/GRwDMMzCH2lu3Qm/4
        4gehlo6f9hh5jAt7T8DKmBOyWPqfEDKiTGZe45pxzbYkF9n1PbtWH75cfkQ/uZXl
        sn0eFK5j5A6mK4vsiB+aJXPcj+jhy1nT/yON24GE5BmB5Op4rSNz7U4WjlRyUIVQ
        vJ3cNab6lbEhgwY01CIy1GOzSOmMnyz5Pm4GEWkR0SMceeMx8Vs3Raz9zN4MBXiW
        SCqaMcCyP5xILhIRjeL7j5a2Ihk1DN6fSQn5O3wWJ8xDT3ZnGJ1UFlSaf+KTDnPw
        ==
X-ME-Sender: <xms:sAt8YDf_WMRJso4g-qSkPtNWVv-HbFOeOT3yXJ5cUfdDyh4w3Tt4eQ>
    <xme:sAt8YJMw2s86dPzyETzo8jBwRx1sMlioh2ZuzKHEAMRdyrBXxgBAfnFmyyDOaNRC5
    xppN7I7ytMceA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:sAt8YMgYb8AuM3vuhqAT6JAEsnF_cgpjLTwmaPuuoTiKEGDpr9YdrA>
    <xmx:sAt8YE-p1EzDuDA9eRyfTGT8TPofPK_n9gcrArEl9yxZrkYzjF8exg>
    <xmx:sAt8YPvUwJl2z2GYh7qg2Q8v4efW7blUmb4TjI8GmKkI79yvT_LTrQ>
    <xmx:sAt8YIXvU6FBKoptnCLY5MtxuwHCVZX9HCux_YZJj2_YatCIBXxSwA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B9E1240054;
        Sun, 18 Apr 2021 06:36:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] r8169: don't advertise pause in jumbo mode" failed to apply to 5.4-stable tree
To:     hkallweit1@gmail.com, davem@davemloft.net, rm+bko@romanrm.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 12:36:29 +0200
Message-ID: <161874218928233@kroah.com>
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

From 453a77894efa4d9b6ef9644d74b9419c47ac427c Mon Sep 17 00:00:00 2001
From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 14 Apr 2021 10:47:10 +0200
Subject: [PATCH] r8169: don't advertise pause in jumbo mode

It has been reported [0] that using pause frames in jumbo mode impacts
performance. There's no available chip documentation, but vendor
drivers r8168 and r8125 don't advertise pause in jumbo mode. So let's
do the same, according to Roman it fixes the issue.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=212617

Fixes: 9cf9b84cc701 ("r8169: make use of phy_set_asym_pause")
Reported-by: Roman Mamedov <rm+bko@romanrm.net>
Tested-by: Roman Mamedov <rm+bko@romanrm.net>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 581a92fc3292..1df2c002c9f6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2350,6 +2350,13 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
 
 	if (pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
 		pcie_set_readrq(tp->pci_dev, readrq);
+
+	/* Chip doesn't support pause in jumbo mode */
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+			 tp->phydev->advertising, !jumbo);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			 tp->phydev->advertising, !jumbo);
+	phy_start_aneg(tp->phydev);
 }
 
 DECLARE_RTL_COND(rtl_chipcmd_cond)
@@ -4630,8 +4637,6 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 	if (!tp->supports_gmii)
 		phy_set_max_speed(phydev, SPEED_100);
 
-	phy_support_asym_pause(phydev);
-
 	phy_attached_info(phydev);
 
 	return 0;

