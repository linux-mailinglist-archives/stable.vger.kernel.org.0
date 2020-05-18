Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A7B1D7A7D
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 15:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgERN4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 09:56:37 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:53797 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726800AbgERN4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 09:56:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id DC2041940DAC;
        Mon, 18 May 2020 09:56:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 18 May 2020 09:56:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=61UEAg
        MGuVIOmuYI7CkNwRMQ1Ms8Hf+ZHjwF2JPz0FI=; b=xOrs98FEBSDNBaeJGYhKU2
        JiVqwHy15eyYord+vFI8GSBgRuEiBN8ezH9wVJE/iuNE6F5efzGQHsFtBQwB9uDt
        qppuFfGs/feicH6QSeYirAXKN2nYtDGXukv2kEGuN+MC5+NctMXlPzDR7Ls8uLrE
        b2BbQA+gHq65X461Df2ZtHRmtR6SR5xctoKRQm9gCFv0dhErliEEA4wRFXZOsj05
        yKSxsWCbUgJIrpT83shOAlgOEDt0jlQ7XrPeehM5PDxvhpDqFBcCObaNrzQP0yba
        HYWeNH94eNAQPpjYcSHZ5O1cv1iuXiCvGD2MRJOGM3nh6QjwBgyoNyZDB6iKaZ5w
        ==
X-ME-Sender: <xms:EZTCXuLlyPPC12vqyuKegYHEKjAXJO-A7oiNzuJ8QZtwwpDd067jNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlhedmnecujfgurhepuffvhf
    ffkfggtgfgsehtkeertddttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhho
    uhhnuggrthhiohhnrdhorhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtte
    egudegfffghfduffduudekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhn
    vghlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:EZTCXmIJYXuCZrrCqho6av0tM5bXsGxVxXrYt4FMGlQuoiZnfVVnaA>
    <xmx:EZTCXutid1BplSsr52GSjNlGvO-QxItzy-5TZ-qFFMdahpCW30M_Tg>
    <xmx:EZTCXjasO8WZTnruFEjTRlxV2GMd7irJFWfXiMgiqjrvsTcTuqOwXg>
    <xmx:E5TCXn1GRNXyRG4fZYBOf6YFSDZ1Jr6gL8DBzuNtOcaq8fku5Gzebg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9EF5C3280064;
        Mon, 18 May 2020 09:56:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] clk: rockchip: fix incorrect configuration of rk3228" failed to apply to 4.9-stable tree
To:     justin.swartz@risingedge.co.za, heiko@sntech.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 15:56:31 +0200
Message-ID: <15898101914101@kroah.com>
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

From cec9d101d70a3509da9bd2e601e0b242154ce616 Mon Sep 17 00:00:00 2001
From: Justin Swartz <justin.swartz@risingedge.co.za>
Date: Tue, 14 Jan 2020 16:25:02 +0000
Subject: [PATCH] clk: rockchip: fix incorrect configuration of rk3228
 aclk_gpu* clocks

The following changes prevent the unrecoverable freezes and rcu_sched
stall warnings experienced in each of my attempts to take advantage of
lima.

Replace the COMPOSITE_NOGATE definition of aclk_gpu_pre with a
COMPOSITE that retains the selection of HDMIPHY as the PLL source, but
instead makes uses of the aclk_gpu PLL source gate and parent names
defined by mux_pll_src_4plls_p rather than mux_aclk_gpu_pre_p.

Remove the now unused mux_aclk_gpu_pre_p and the four named but also
unused definitions (cpll_gpu, gpll_gpu, hdmiphy_gpu and usb480m_gpu)
of the aclk_gpu PLL source gate.

Use the correct gate offset for aclk_gpu and aclk_gpu_noc.

Fixes: 307a2e9ac524 ("clk: rockchip: add clock controller for rk3228")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Swartz <justin.swartz@risingedge.co.za>
[double-checked against SoC manual and added fixes tag]
Link: https://lore.kernel.org/r/20200114162503.7548-1-justin.swartz@risingedge.co.za
Signed-off-by: Heiko Stuebner <heiko@sntech.de>

diff --git a/drivers/clk/rockchip/clk-rk3228.c b/drivers/clk/rockchip/clk-rk3228.c
index d17cfb7a3ff4..d7243c09cc84 100644
--- a/drivers/clk/rockchip/clk-rk3228.c
+++ b/drivers/clk/rockchip/clk-rk3228.c
@@ -156,8 +156,6 @@ PNAME(mux_i2s_out_p)		= { "i2s1_pre", "xin12m" };
 PNAME(mux_i2s2_p)		= { "i2s2_src", "i2s2_frac", "xin12m" };
 PNAME(mux_sclk_spdif_p)		= { "sclk_spdif_src", "spdif_frac", "xin12m" };
 
-PNAME(mux_aclk_gpu_pre_p)	= { "cpll_gpu", "gpll_gpu", "hdmiphy_gpu", "usb480m_gpu" };
-
 PNAME(mux_uart0_p)		= { "uart0_src", "uart0_frac", "xin24m" };
 PNAME(mux_uart1_p)		= { "uart1_src", "uart1_frac", "xin24m" };
 PNAME(mux_uart2_p)		= { "uart2_src", "uart2_frac", "xin24m" };
@@ -468,16 +466,9 @@ static struct rockchip_clk_branch rk3228_clk_branches[] __initdata = {
 			RK2928_CLKSEL_CON(24), 6, 10, DFLAGS,
 			RK2928_CLKGATE_CON(2), 8, GFLAGS),
 
-	GATE(0, "cpll_gpu", "cpll", 0,
-			RK2928_CLKGATE_CON(3), 13, GFLAGS),
-	GATE(0, "gpll_gpu", "gpll", 0,
-			RK2928_CLKGATE_CON(3), 13, GFLAGS),
-	GATE(0, "hdmiphy_gpu", "hdmiphy", 0,
-			RK2928_CLKGATE_CON(3), 13, GFLAGS),
-	GATE(0, "usb480m_gpu", "usb480m", 0,
+	COMPOSITE(0, "aclk_gpu_pre", mux_pll_src_4plls_p, 0,
+			RK2928_CLKSEL_CON(34), 5, 2, MFLAGS, 0, 5, DFLAGS,
 			RK2928_CLKGATE_CON(3), 13, GFLAGS),
-	COMPOSITE_NOGATE(0, "aclk_gpu_pre", mux_aclk_gpu_pre_p, 0,
-			RK2928_CLKSEL_CON(34), 5, 2, MFLAGS, 0, 5, DFLAGS),
 
 	COMPOSITE(SCLK_SPI0, "sclk_spi0", mux_pll_src_2plls_p, 0,
 			RK2928_CLKSEL_CON(25), 8, 1, MFLAGS, 0, 7, DFLAGS,
@@ -582,8 +573,8 @@ static struct rockchip_clk_branch rk3228_clk_branches[] __initdata = {
 	GATE(0, "pclk_peri_noc", "pclk_peri", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(12), 2, GFLAGS),
 
 	/* PD_GPU */
-	GATE(ACLK_GPU, "aclk_gpu", "aclk_gpu_pre", 0, RK2928_CLKGATE_CON(13), 14, GFLAGS),
-	GATE(0, "aclk_gpu_noc", "aclk_gpu_pre", 0, RK2928_CLKGATE_CON(13), 15, GFLAGS),
+	GATE(ACLK_GPU, "aclk_gpu", "aclk_gpu_pre", 0, RK2928_CLKGATE_CON(7), 14, GFLAGS),
+	GATE(0, "aclk_gpu_noc", "aclk_gpu_pre", 0, RK2928_CLKGATE_CON(7), 15, GFLAGS),
 
 	/* PD_BUS */
 	GATE(0, "sclk_initmem_mbist", "aclk_cpu", 0, RK2928_CLKGATE_CON(8), 1, GFLAGS),

