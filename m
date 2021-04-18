Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2977E3634A4
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 12:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhDRKhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 06:37:11 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:44591 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhDRKhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 06:37:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 73BCA19401B0;
        Sun, 18 Apr 2021 06:36:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 06:36:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=U4pNl1
        DxuHDXozegg7acci2K9YUTwsFCB9gM0ghWMgQ=; b=lhMDAZujf01C4HmR/cmy0V
        oN3bYTPf3cXhLptNmVbjpIAU2bAeS7PYrFz2Zxs9pbwzBWSC07w5yqi3kq5AvPKh
        m3rrfC7l1XAkDE4YWAeZsDoL4kzo8nFdB1k8V80qQkrXHUCUV1eIfBX6rFunqdaj
        ZVgPZ78Z+qRFL4MdBmjQ562oN2MozHIKA6IarYgH/H92IEpC/NDP5jpeBfY/u7fn
        zl1ggGhB5MDSF9b5eQF9fV+JPQ+Ok5R/WAKyJcQlVhLrre/1EQsggx8xvMaohG9u
        OfjfP8m9QI8TC3F+q3QyRAj5uaanR1IJJhde48YCD8GcEeEixPKFGoiiPVcz/idQ
        ==
X-ME-Sender: <xms:ugt8YKKAnRegVfhK_kg6WD_MDvxLStSZoMieevTXRESCBJ0mxTLFww>
    <xme:ugt8YCJt7-jooWiIQVOHPHQmgUl-YDuSdToM-xJudTWfHDaFmuaYClJ3tQ5Urttx4
    RtqVxCgdrO3Ug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ugt8YKtbtljgLFsXUEVuA0tUOEPajk3iaEXX1Y2ao892rASSk2oP5Q>
    <xmx:ugt8YPYViKzTeHV7q9feoT48dQvtBf9MwDPLjp8HlIZof1jOq0wGnA>
    <xmx:ugt8YBYiuIgetkq8GXidmQYFN65O5LXIHI9MenCHNFRK6GY-6jFBpw>
    <xmx:ugt8YAyqE9UZawC9ILZPwQgw9-gyj0vWtqD0yZNvMWgHYQcCrnBoxA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC6D3240054;
        Sun, 18 Apr 2021 06:36:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] r8169: don't advertise pause in jumbo mode" failed to apply to 5.10-stable tree
To:     hkallweit1@gmail.com, davem@davemloft.net, rm+bko@romanrm.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 12:36:30 +0200
Message-ID: <161874219017114@kroah.com>
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

