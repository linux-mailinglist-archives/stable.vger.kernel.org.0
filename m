Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD47E3C3CAB
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhGKNBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 09:01:20 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:56209 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232842AbhGKNBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 09:01:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id D4BE31AC10D9;
        Sun, 11 Jul 2021 08:58:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 08:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=quBoJX
        OgDvGRIT/C2Z+yE7cF+1CapxsJYmOzrE+KMJQ=; b=kkDGvcnKMSY+58Xyshp/tC
        ga8HzdFnaQgw/6L1gzcLLc85Ep1yq4xRcXFL+8HRnsd+XmCthfZP3rRajnL3V3fU
        LbUPF8jLGVTt3PdHkcmpRlM9RkBzPnNihOn34CittXYJzpp2y/BvCC7WAyd2r6vP
        zqBaEWb048Ot8pS6/I3KjQohdJptwumcW+qKWe8xQcOnLHlMP0GDxE66FQC2L4qK
        CEcbsJEVfh3dICaL3BHekLUh8zl6cRcyuvLn5P9iU1rbBiDz/BfPdxh8LyoKMUKR
        sDbk7cM7n2csKS8gpeSnEF1SAzuHRLsbxCIC3kp8Fge664hCCBV5lE/+7DIEiulw
        ==
X-ME-Sender: <xms:9erqYB5WyAWjquus3kMSt2fL8F74Lj2FdPoRMGsitjU4ZgV8Y1X43w>
    <xme:9erqYO66SSPgy1y2cN79PbcgjI9P_FC_KpFkCTFSyGpyj6QiEFZfrX7MXpjUY4oHy
    Bq5PH-c5DIVPA>
X-ME-Received: <xmr:9erqYIfDHvObvbkaVE6Sbj9UX8LLlb2sTxhsqOfFMqsBFdw27qweVENw16LVxnIkB8pwbeiC19f9YLo7Xugr8G18tg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:9erqYKL2G7-C215nKAYN8vyIyWaW8JaflpWh6jFOHHw5xpjn68bPSg>
    <xmx:9erqYFJTGZQDND_GidYZ4MPDn3mK_bfnCBkLOdN12o4IEsXEGKtvxw>
    <xmx:9erqYDzCIjwP3imoz6evgohHpraqzT-U72wF_bhD--L6Dx62txOFhg>
    <xmx:9erqYDh0il8jLytm5I_Am-NxxnyXDeE0FwUYPLx3viHHmTeccazGKo2UXm8>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:58:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] clk: agilex/stratix10: add support for the 2nd bypass" failed to apply to 5.12-stable tree
To:     dinguyen@kernel.org, sboyd@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:58:27 +0200
Message-ID: <162600830740127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c2c9c5661a48bf2e67dcb4e989003144304acd6a Mon Sep 17 00:00:00 2001
From: Dinh Nguyen <dinguyen@kernel.org>
Date: Thu, 10 Jun 2021 21:52:00 -0500
Subject: [PATCH] clk: agilex/stratix10: add support for the 2nd bypass

The EMAC clocks on Stratix10/Agilex/N5X have an additional bypass that
was not being accounted for. The bypass selects between
emaca_clk/emacb_clk and boot_clk.

Because the bypass register offset is different between Stratix10 and
Agilex/N5X, it's best to create a new function to calculate the bypass.

Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20210611025201.118799-3-dinguyen@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>

diff --git a/drivers/clk/socfpga/clk-agilex.c b/drivers/clk/socfpga/clk-agilex.c
index edfa87d0cd76..1cb21ea79c64 100644
--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -177,6 +177,8 @@ static const struct clk_parent_data emac_mux[] = {
 	  .name = "emaca_free_clk", },
 	{ .fw_name = "emacb_free_clk",
 	  .name = "emacb_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
 };
 
 static const struct clk_parent_data noc_mux[] = {
@@ -399,7 +401,7 @@ static int agilex_clk_register_gate(const struct stratix10_gate_clock *clks,
 	int i;
 
 	for (i = 0; i < nums; i++) {
-		hw_clk = s10_register_gate(&clks[i], base);
+		hw_clk = agilex_register_gate(&clks[i], base);
 		if (IS_ERR(hw_clk)) {
 			pr_err("%s: failed to register clock %s\n",
 			       __func__, clks[i].name);
diff --git a/drivers/clk/socfpga/clk-gate-s10.c b/drivers/clk/socfpga/clk-gate-s10.c
index b84f2627551e..32567795765f 100644
--- a/drivers/clk/socfpga/clk-gate-s10.c
+++ b/drivers/clk/socfpga/clk-gate-s10.c
@@ -11,6 +11,13 @@
 #define SOCFPGA_CS_PDBG_CLK	"cs_pdbg_clk"
 #define to_socfpga_gate_clk(p) container_of(p, struct socfpga_gate_clk, hw.hw)
 
+#define SOCFPGA_EMAC0_CLK		"emac0_clk"
+#define SOCFPGA_EMAC1_CLK		"emac1_clk"
+#define SOCFPGA_EMAC2_CLK		"emac2_clk"
+#define AGILEX_BYPASS_OFFSET		0xC
+#define STRATIX10_BYPASS_OFFSET		0x2C
+#define BOOTCLK_BYPASS			2
+
 static unsigned long socfpga_gate_clk_recalc_rate(struct clk_hw *hwclk,
 						  unsigned long parent_rate)
 {
@@ -44,14 +51,61 @@ static unsigned long socfpga_dbg_clk_recalc_rate(struct clk_hw *hwclk,
 static u8 socfpga_gate_get_parent(struct clk_hw *hwclk)
 {
 	struct socfpga_gate_clk *socfpgaclk = to_socfpga_gate_clk(hwclk);
-	u32 mask;
+	u32 mask, second_bypass;
+	u8 parent = 0;
+	const char *name = clk_hw_get_name(hwclk);
+
+	if (socfpgaclk->bypass_reg) {
+		mask = (0x1 << socfpgaclk->bypass_shift);
+		parent = ((readl(socfpgaclk->bypass_reg) & mask) >>
+			  socfpgaclk->bypass_shift);
+	}
+
+	if (streq(name, SOCFPGA_EMAC0_CLK) ||
+	    streq(name, SOCFPGA_EMAC1_CLK) ||
+	    streq(name, SOCFPGA_EMAC2_CLK)) {
+		second_bypass = readl(socfpgaclk->bypass_reg -
+				      STRATIX10_BYPASS_OFFSET);
+		/* EMACA bypass to bootclk @0xB0 offset */
+		if (second_bypass & 0x1)
+			if (parent == 0) /* only applicable if parent is maca */
+				parent = BOOTCLK_BYPASS;
+
+		if (second_bypass & 0x2)
+			if (parent == 1) /* only applicable if parent is macb */
+				parent = BOOTCLK_BYPASS;
+	}
+	return parent;
+}
+
+static u8 socfpga_agilex_gate_get_parent(struct clk_hw *hwclk)
+{
+	struct socfpga_gate_clk *socfpgaclk = to_socfpga_gate_clk(hwclk);
+	u32 mask, second_bypass;
 	u8 parent = 0;
+	const char *name = clk_hw_get_name(hwclk);
 
 	if (socfpgaclk->bypass_reg) {
 		mask = (0x1 << socfpgaclk->bypass_shift);
 		parent = ((readl(socfpgaclk->bypass_reg) & mask) >>
 			  socfpgaclk->bypass_shift);
 	}
+
+	if (streq(name, SOCFPGA_EMAC0_CLK) ||
+	    streq(name, SOCFPGA_EMAC1_CLK) ||
+	    streq(name, SOCFPGA_EMAC2_CLK)) {
+		second_bypass = readl(socfpgaclk->bypass_reg -
+				      AGILEX_BYPASS_OFFSET);
+		/* EMACA bypass to bootclk @0x88 offset */
+		if (second_bypass & 0x1)
+			if (parent == 0) /* only applicable if parent is maca */
+				parent = BOOTCLK_BYPASS;
+
+		if (second_bypass & 0x2)
+			if (parent == 1) /* only applicable if parent is macb */
+				parent = BOOTCLK_BYPASS;
+	}
+
 	return parent;
 }
 
@@ -60,6 +114,11 @@ static struct clk_ops gateclk_ops = {
 	.get_parent = socfpga_gate_get_parent,
 };
 
+static const struct clk_ops agilex_gateclk_ops = {
+	.recalc_rate = socfpga_gate_clk_recalc_rate,
+	.get_parent = socfpga_agilex_gate_get_parent,
+};
+
 static const struct clk_ops dbgclk_ops = {
 	.recalc_rate = socfpga_dbg_clk_recalc_rate,
 	.get_parent = socfpga_gate_get_parent,
@@ -122,3 +181,61 @@ struct clk_hw *s10_register_gate(const struct stratix10_gate_clock *clks, void _
 	}
 	return hw_clk;
 }
+
+struct clk_hw *agilex_register_gate(const struct stratix10_gate_clock *clks, void __iomem *regbase)
+{
+	struct clk_hw *hw_clk;
+	struct socfpga_gate_clk *socfpga_clk;
+	struct clk_init_data init;
+	const char *parent_name = clks->parent_name;
+	int ret;
+
+	socfpga_clk = kzalloc(sizeof(*socfpga_clk), GFP_KERNEL);
+	if (!socfpga_clk)
+		return NULL;
+
+	socfpga_clk->hw.reg = regbase + clks->gate_reg;
+	socfpga_clk->hw.bit_idx = clks->gate_idx;
+
+	gateclk_ops.enable = clk_gate_ops.enable;
+	gateclk_ops.disable = clk_gate_ops.disable;
+
+	socfpga_clk->fixed_div = clks->fixed_div;
+
+	if (clks->div_reg)
+		socfpga_clk->div_reg = regbase + clks->div_reg;
+	else
+		socfpga_clk->div_reg = NULL;
+
+	socfpga_clk->width = clks->div_width;
+	socfpga_clk->shift = clks->div_offset;
+
+	if (clks->bypass_reg)
+		socfpga_clk->bypass_reg = regbase + clks->bypass_reg;
+	else
+		socfpga_clk->bypass_reg = NULL;
+	socfpga_clk->bypass_shift = clks->bypass_shift;
+
+	if (streq(clks->name, "cs_pdbg_clk"))
+		init.ops = &dbgclk_ops;
+	else
+		init.ops = &agilex_gateclk_ops;
+
+	init.name = clks->name;
+	init.flags = clks->flags;
+
+	init.num_parents = clks->num_parents;
+	init.parent_names = parent_name ? &parent_name : NULL;
+	if (init.parent_names == NULL)
+		init.parent_data = clks->parent_data;
+	socfpga_clk->hw.hw.init = &init;
+
+	hw_clk = &socfpga_clk->hw.hw;
+
+	ret = clk_hw_register(NULL, &socfpga_clk->hw.hw);
+	if (ret) {
+		kfree(socfpga_clk);
+		return ERR_PTR(ret);
+	}
+	return hw_clk;
+}
diff --git a/drivers/clk/socfpga/stratix10-clk.h b/drivers/clk/socfpga/stratix10-clk.h
index 61eaf3a41fbb..75234e0783e1 100644
--- a/drivers/clk/socfpga/stratix10-clk.h
+++ b/drivers/clk/socfpga/stratix10-clk.h
@@ -85,4 +85,6 @@ struct clk_hw *s10_register_cnt_periph(const struct stratix10_perip_cnt_clock *c
 				    void __iomem *reg);
 struct clk_hw *s10_register_gate(const struct stratix10_gate_clock *clks,
 			      void __iomem *reg);
+struct clk_hw *agilex_register_gate(const struct stratix10_gate_clock *clks,
+			      void __iomem *reg);
 #endif	/* __STRATIX10_CLK_H */

