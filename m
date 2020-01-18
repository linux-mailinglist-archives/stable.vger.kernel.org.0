Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA81E14181B
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 16:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgARPD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 10:03:57 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:39491 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbgARPD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 10:03:56 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 20F28443;
        Sat, 18 Jan 2020 10:03:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 18 Jan 2020 10:03:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=1XWxGC
        YaqUlbOZiKwy2QzVhnwsPIvsQZixEr37V3858=; b=LH+1DU1jBvw4D4T5akNKZw
        Lu6t/1HOpw7e1HyR3/133DqX+CijMR03bNHyVSAJ4lxxlmxqP7zb0RkDhl5ZwyQ5
        Avh23AtmVMzTTOpZDPj71ooBlGLReeM1k8EQKfNg/o4suoDXbxlpo3mJvzTwFd5y
        yEcZ20+pd84rr9UEod7JH0NUI+ugmcM1q8hdpiENjXDc94DRWC0q0kBbM33mgTZ3
        NqxPf3DMCU3I/aOuTnMVsNJXDo+q8pWJmg/ASr5/GDbHaJaGVzrBoc+DU78PL8K8
        2jIWLNuDHTpD8WfMTgIdAiLsaZjOo0PJ7+zHBQgs2Mpc9t15MaucSWF8Llf4CBnQ
        ==
X-ME-Sender: <xms:Wx4jXnSvw1zOxiamNDSxHf0DOptWzvGE9M4aNt8TMx8njJCeM4tiyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeejrdejuddrudegfedrudejtdenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:Wx4jXj_g_jWq7hFvQLJVOfMbZ-apQS1832GjJsWymBD3kEvLiwZyKA>
    <xmx:Wx4jXr9vKGuNgSGcGZQHtWboHS2ROd7BU18j1H19KNwOibo3xVLbJQ>
    <xmx:Wx4jXnTsSGgc9QRgMfOQB5vWJoYD2dc2JWrNH9UaCz5z548wIHvfcw>
    <xmx:Wx4jXno93wlGfkd-Hiwcg3Tl1oZ07NRx-a49TFKEAUvHp5Fq8YF2Qg>
Received: from localhost (170.143.71.37.rev.sfr.net [37.71.143.170])
        by mail.messagingengine.com (Postfix) with ESMTPA id 66F5930607CD;
        Sat, 18 Jan 2020 10:03:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: dts: agilex/stratix10: fix pmu interrupt numbers" failed to apply to 4.14-stable tree
To:     dinguyen@kernel.org, Meng.Li@windriver.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Jan 2020 16:03:46 +0100
Message-ID: <157935982616724@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 210de0e996aee8e360ccc9e173fe7f0a7ed2f695 Mon Sep 17 00:00:00 2001
From: Dinh Nguyen <dinguyen@kernel.org>
Date: Wed, 20 Nov 2019 09:15:17 -0600
Subject: [PATCH] arm64: dts: agilex/stratix10: fix pmu interrupt numbers

Fix up the correct interrupt numbers for the PMU unit on Agilex
and Stratix10.

Fixes: 78cd6a9d8e15 ("arm64: dts: Add base stratix 10 dtsi")
Cc: linux-stable <stable@vger.kernel.org>
Reported-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>

diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi b/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
index 144a2c19ac02..d1fc9c2055f4 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
@@ -61,10 +61,10 @@ cpu3: cpu@3 {
 
 	pmu {
 		compatible = "arm,armv8-pmuv3";
-		interrupts = <0 120 8>,
-			     <0 121 8>,
-			     <0 122 8>,
-			     <0 123 8>;
+		interrupts = <0 170 4>,
+			     <0 171 4>,
+			     <0 172 4>,
+			     <0 173 4>;
 		interrupt-affinity = <&cpu0>,
 				     <&cpu1>,
 				     <&cpu2>,
diff --git a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
index 94090c6fb946..d43e1299c8ef 100644
--- a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
@@ -60,10 +60,10 @@ cpu3: cpu@3 {
 
 	pmu {
 		compatible = "arm,armv8-pmuv3";
-		interrupts = <0 120 8>,
-			     <0 121 8>,
-			     <0 122 8>,
-			     <0 123 8>;
+		interrupts = <0 170 4>,
+			     <0 171 4>,
+			     <0 172 4>,
+			     <0 173 4>;
 		interrupt-affinity = <&cpu0>,
 				     <&cpu1>,
 				     <&cpu2>,

