Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FE4225E48
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgGTMTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:19:02 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:40371 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728532AbgGTMTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:19:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id E01FA1941118;
        Mon, 20 Jul 2020 08:19:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:19:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tkh4HE
        bJoEFojiUrtwOQuVsZgXPJ8bfHdxbJntMF46g=; b=E8L3bQzMrwuw+3X3GIj2wU
        tOCLj5fYp8QxgoZ0BPqi/KY/ByMEicdhjn/LhSy7rJBgOE58pu722qT75yVEcRc5
        rD8C3utf7uFYTVbm3Pp9j5qvIwR2u2iXpvvRgJzxgdQpZXpQ4GvpMJHQ+ayqoHvx
        rWkzQa1VclYfc29hFCErwyCweRO+lYpzsAJpFN5MYPmjQldBU4dXlqpg8zElQ1aq
        iAiAMeEwbMr1CmC2DoUD4ERAo4UQHdF8nQwx9XtPJSUie0vfB0N9UN1FBGXtkQ0p
        t4JAS0Ry82MjaPpRNHFjVp3kS2FOrqcssYb9fiW3P0LL3ALrD6bcyTeos/gMGIpw
        ==
X-ME-Sender: <xms:tIsVXyTiNYtAFy9ZfGJ_F6waexI1S5hYVucxjZyX-ymuCDCC3asxNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:tIsVX3y9Q6hk4pV0HgS_lNJI_eiNqc3xq8QzPNDmpjW0cVwdeq_BVQ>
    <xmx:tIsVX_1txa6gNP1yv_qOgC4SVzEx2PimQrOgnpZACc2ZRPAincL1bA>
    <xmx:tIsVX-COANsqcdUEFv30_GKviBNmHVJ6kaB4oiC6wXAW7lIk_cOUgg>
    <xmx:tIsVX9ejG5reWIDQdNcEk5Ibjc7O04r4Hsj8tvdE3U0nSdKF9JFZsQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5C04E3060067;
        Mon, 20 Jul 2020 08:19:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ARM: dts: imx6qdl-gw551x: fix audio SSI" failed to apply to 5.4-stable tree
To:     tharvey@gateworks.com, shawnguo@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 14:19:11 +0200
Message-ID: <1595247551166250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 4237c625304b212a3f30adf787901082082511ec Mon Sep 17 00:00:00 2001
From: Tim Harvey <tharvey@gateworks.com>
Date: Tue, 23 Jun 2020 12:06:54 -0700
Subject: [PATCH] ARM: dts: imx6qdl-gw551x: fix audio SSI

The audio codec on the GW551x routes to ssi1.  It fixes audio capture on
the device.

Cc: stable@vger.kernel.org
Fixes: 3117e851cef1 ("ARM: dts: imx: Add TDA19971 HDMI Receiver to GW551x")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>

diff --git a/arch/arm/boot/dts/imx6qdl-gw551x.dtsi b/arch/arm/boot/dts/imx6qdl-gw551x.dtsi
index c38e86eedcc0..8c33510c9519 100644
--- a/arch/arm/boot/dts/imx6qdl-gw551x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw551x.dtsi
@@ -110,7 +110,7 @@
 		simple-audio-card,frame-master = <&sound_codec>;
 
 		sound_cpu: simple-audio-card,cpu {
-			sound-dai = <&ssi2>;
+			sound-dai = <&ssi1>;
 		};
 
 		sound_codec: simple-audio-card,codec {

