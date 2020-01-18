Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48AE514181C
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 16:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgARPD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 10:03:58 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:55877 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbgARPD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 10:03:58 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 605B143E;
        Sat, 18 Jan 2020 10:03:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 18 Jan 2020 10:03:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=tMlvP4
        T4r8nmNinnSDVBv9w21tnyACDU7Lk8HMDXttw=; b=wWnklI22su6nrPMws/Q0YL
        QC2wBpeE9zUfs36maFRf5ezU7ek6fOVOjml4AXtaOwr0yDe7UvpY57ePX49sowlp
        TkqjLMywcXfGlBycMGMeL0d6PnMzlZFwtyIaLDx8Mm9IZreJL9knMWo1N8QF7LUW
        yEZuA/6CyYPzWzEI/ZydmvDZzj8DVlJ1TbPvrJj0od00HtCTI999YgvSv7243Gy3
        k8SsWBxuABzPPD2yXtJx6XW3B/VCyAg4o9TswMeD3GbBX/0hquD0qB8iINj+npD8
        IQHmdCde1/x3TziNOtpKgf4CAWpFhxfL/YEKrzNca7yn8mOVx+/rs61rlDUX2YNA
        ==
X-ME-Sender: <xms:XB4jXhp3BK2a3dc-cQ1SbvS4yhk2ucNXF0JyRC9proYCVRhLkVMFRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeejrdejuddrudegfedrudejtdenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:XB4jXuYiDF4L9mK1ziy7A4igKUnFE62Jqo-jtM4_LU-QTpz-000YNQ>
    <xmx:XB4jXtFPMJ9aZJrdt7ysR7uEKdv5m_v3ljRdI8iYPH62f3vfRNB_dQ>
    <xmx:XB4jXjobPJ7e1uEnIYRVOdaTNMASvWP3d_2y-O9DU4qWTnRONPvsxw>
    <xmx:XR4jXjoohHqP3d0DEwfrebh7p0CA0AZThiSV0DqbQ3hATpfuBc9pug>
Received: from localhost (170.143.71.37.rev.sfr.net [37.71.143.170])
        by mail.messagingengine.com (Postfix) with ESMTPA id A417E30607CD;
        Sat, 18 Jan 2020 10:03:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: dts: agilex/stratix10: fix pmu interrupt numbers" failed to apply to 4.9-stable tree
To:     dinguyen@kernel.org, Meng.Li@windriver.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Jan 2020 16:03:46 +0100
Message-ID: <157935982661210@kroah.com>
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

