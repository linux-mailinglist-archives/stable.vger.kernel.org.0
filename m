Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4AE225E4A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgGTMTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:19:31 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:50411 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728532AbgGTMTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:19:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0BF3419410A3;
        Mon, 20 Jul 2020 08:19:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:19:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=bcp1no
        I6M9oQYm2XhkF5raGtrKNSZnHgpT0ma4vAnzI=; b=TzXQFfDzlI1aIm8UPiqTDS
        4CyiVcmO8dSS2RyZji7NQYYc7UnUL+jzOG9PfRCN2YLiRiwFu8RbPKwZplgggiVs
        VP6dry/r5jz+ppAQoqH52Ur+neSJt34yb/cxbVDrV72JiIq2ncHge8ws2DoGHOZE
        PC3gf7waVHgML43AUAsyRHY5q25sdPTlzGgGhhopZta0dGsfZXaTXtx1eY9p5G5V
        5VdRRaaiZCXqBSZfxVXpq6KJXyvYl7v3jwAp73OFXl9IVH5VQhfgp+SlY1dPdsy5
        +IXMSlFmIjq9Ya8jTE5xMI0MKBcWtKQLtX8jCMJ2axN3Jvd8qmzii2r87YoBoK4g
        ==
X-ME-Sender: <xms:0YsVX3w4APERtFPx1MurY-9zE9x5vZZ6rLJiBaOvLn_uz35mh90yXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:0YsVX_SQHbJk9URGTq6ZVX_-xAvu9sdRVxG9w5Mvbmx1nIX5Ti6T-A>
    <xmx:0YsVXxVIIpce6Ijpz6V8NlhaZzI_0Cmr8JpLE5g67VEWaw3VP91_8w>
    <xmx:0YsVXxj7mhRPRbhyKdgK7TU0unptYFAL2D4a8vgvkfHaCYIgqJ4rPA>
    <xmx:0osVX8O2WO6RypFxuAYCxrQTpJDliKf0M19akXLoqAxcJYy7-u5v6A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D05030600A9;
        Mon, 20 Jul 2020 08:19:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: dts: stratix10: add status to qspi dts node" failed to apply to 5.4-stable tree
To:     dinguyen@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 14:19:37 +0200
Message-ID: <159524757716479@kroah.com>
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

From 263a0269a59c0b4145829462a107fe7f7327105f Mon Sep 17 00:00:00 2001
From: Dinh Nguyen <dinguyen@kernel.org>
Date: Mon, 29 Jun 2020 11:25:43 -0500
Subject: [PATCH] arm64: dts: stratix10: add status to qspi dts node

Add status = "okay" to QSPI node.

Fixes: 0cb140d07fc75 ("arm64: dts: stratix10: Add QSPI support for Stratix10")
Cc: linux-stable <stable@vger.kernel.org> # >= v5.6
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>

diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
index f6c4a15079d3..feadd21bc0dc 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
@@ -155,6 +155,7 @@
 };
 
 &qspi {
+	status = "okay";
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
index 9946515b8afd..4000c393243d 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
@@ -188,6 +188,7 @@
 };
 
 &qspi {
+	status = "okay";
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;

