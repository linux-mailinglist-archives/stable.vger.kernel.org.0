Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB88C14181D
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 16:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgARPD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 10:03:59 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:46853 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbgARPD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 10:03:59 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9EAD24C9;
        Sat, 18 Jan 2020 10:03:58 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 18 Jan 2020 10:03:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gZU226
        p6OZXW0S/Vupb/6qP6NAfEzK4+yKSXriaXSxQ=; b=TYjpNGrjxoF26i8PiFHUfl
        4Uybcqd5eTZcR2Fr6FE7tHOlaEhrLFjLPKNwuHal2lMLNF25D1tjT3UNUPtQbDU9
        4C1U1wy5qOxXoA0ec9svTr3W5m6JgfACC8huIj00yJnq0OtejQnt2eehbMYhemJG
        EdylN7oA63eGp2W5khbZGWn/4uw1BzeKfCgqUdoKoN/WWddSePvDE3EQmbzpI0/3
        +g8A/tWMN7kyhDbMo9pHxelwO1AiLviEv9q2j6U2gLAX++TK2d4Vz0JOeiHqTVNc
        E42L/gwa5sVw6Q4Ph76gzwg7y21QokF6s58djK2puQTrG+SzJJoscQ0ERKS7OQzw
        ==
X-ME-Sender: <xms:Xh4jXhGvTTy8lk2PSnm3jNNizCD9HpuShpUd2mME87tCtXSFKc8KLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeejrdejuddrudegfedrudejtdenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:Xh4jXgzfdzep3Vlzo5XEUBnNQoVaGxvnXBfQILJ0ABMMsPUYPwvwPw>
    <xmx:Xh4jXp4PWXf8sAwJtTVU-XM_k_jKrnsf3RdcxtDOyV4BpxzM-7brcg>
    <xmx:Xh4jXhiNLZ_Evt2SGJ9_U-w5w6vp--iKBnaafqRoBTnrZUrMetNuiw>
    <xmx:Xh4jXsmlLVieQIuDpbLSCa7ufryUhiHUcltYlLztc815K6-eVdhAMg>
Received: from localhost (170.143.71.37.rev.sfr.net [37.71.143.170])
        by mail.messagingengine.com (Postfix) with ESMTPA id E0ECE30607CD;
        Sat, 18 Jan 2020 10:03:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: dts: agilex/stratix10: fix pmu interrupt numbers" failed to apply to 4.4-stable tree
To:     dinguyen@kernel.org, Meng.Li@windriver.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Jan 2020 16:03:47 +0100
Message-ID: <1579359827103124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

