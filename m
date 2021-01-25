Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AC5302667
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 15:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbhAYOn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 09:43:26 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:32965 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729614AbhAYOmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:42:20 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8A074871;
        Mon, 25 Jan 2021 09:41:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 25 Jan 2021 09:41:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=clvtl8
        UmWXadWwD9BkW6lyRSe/WVXDOuKPG6hvQz06M=; b=AZit35zhKoXRHhPTfH+5+B
        EyUHfcq0i9OfszLR97JwiVkVV7nLFP/Wgt+mDcnGMfOExRc59jke1qzqENcMxpst
        cPVmT7jRr5dIrWL4rNUe3PLjw2xxjjNzP6KhLBQn9TdsKMBbkVowYmqiqCQ+M4C6
        hjHFIbxzYdtqK7fEt+y0U/uVFl4/lNYO8v4bcjpp74+A0pVWbfqA6Zvy7F+sGxie
        2/WpjRIRT8m0f6xjhjzielMX1uKQIMO+BzfCObN8H1dVzosC/my0ILMiF0jv05aH
        8spQHqJlwQYLF0A2ftmIOOhgqp1zTIdgWnhePtirzPH1FdyXtpHPh9F6c0FYlNaA
        ==
X-ME-Sender: <xms:i9gOYLakBUIO-gAova2n3t3FURmCE-MmmasPz9nke0RyGmwA5Pfnng>
    <xme:i9gOYOuQwndAmayJrO_u0zv2p9mzDAfuq53Jfn336uBc3LNL8KxCn1HRVun19EKgW
    5OkubP_6EQvGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:i9gOYNGIQwrAYYyjp6zj2djerQTqVUuX-tDDso501RsEPo9VrdgCPA>
    <xmx:i9gOYJz-Khxy22PJEh1M_DvBMmy0HVQITJzFddhq1eoxfnh6_JyDKw>
    <xmx:i9gOYMiYXNOK3G2ExZcBzbjBsYjhRunzq0FQwF7iUnAA99axouEFXw>
    <xmx:jNgOYC6hNpNanEimnZ4j-diWSeqZ9psG8z3gsC1qMzXD7p2KExMuFbn_x90>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A777824005D;
        Mon, 25 Jan 2021 09:41:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] pinctrl: qcom: Properly clear "intr_ack_high" interrupts when" failed to apply to 5.10-stable tree
To:     dianders@chromium.org, bjorn.andersson@linaro.org,
        linus.walleij@linaro.org, mkshah@codeaurora.org,
        swboyd@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:41:14 +0100
Message-ID: <1611585674115135@kroah.com>
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

From a95881d6aa2c000e3649f27a1a7329cf356e6bb3 Mon Sep 17 00:00:00 2001
From: Douglas Anderson <dianders@chromium.org>
Date: Thu, 14 Jan 2021 19:16:23 -0800
Subject: [PATCH] pinctrl: qcom: Properly clear "intr_ack_high" interrupts when
 unmasking

In commit 4b7618fdc7e6 ("pinctrl: qcom: Add irq_enable callback for
msm gpio") we tried to Ack interrupts during unmask.  However, that
patch forgot to check "intr_ack_high" so, presumably, it only worked
for a certain subset of SoCs.

Let's add a small accessor so we don't need to open-code the logic in
both places.

This was found by code inspection.  I don't have any access to the
hardware in question nor software that needs the Ack during unmask.

Fixes: 4b7618fdc7e6 ("pinctrl: qcom: Add irq_enable callback for msm gpio")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Maulik Shah <mkshah@codeaurora.org>
Tested-by: Maulik Shah <mkshah@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210114191601.v7.3.I32d0f4e174d45363b49ab611a13c3da8f1e87d0f@changeid
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 2f363c28d9d9..192ed31eabf4 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -96,6 +96,14 @@ MSM_ACCESSOR(intr_cfg)
 MSM_ACCESSOR(intr_status)
 MSM_ACCESSOR(intr_target)
 
+static void msm_ack_intr_status(struct msm_pinctrl *pctrl,
+				const struct msm_pingroup *g)
+{
+	u32 val = g->intr_ack_high ? BIT(g->intr_status_bit) : 0;
+
+	msm_writel_intr_status(val, pctrl, g);
+}
+
 static int msm_get_groups_count(struct pinctrl_dev *pctldev)
 {
 	struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
@@ -797,7 +805,7 @@ static void msm_gpio_irq_clear_unmask(struct irq_data *d, bool status_clear)
 	 * when the interrupt is not in use.
 	 */
 	if (status_clear)
-		msm_writel_intr_status(0, pctrl, g);
+		msm_ack_intr_status(pctrl, g);
 
 	val = msm_readl_intr_cfg(pctrl, g);
 	val |= BIT(g->intr_raw_status_bit);
@@ -890,7 +898,6 @@ static void msm_gpio_irq_ack(struct irq_data *d)
 	struct msm_pinctrl *pctrl = gpiochip_get_data(gc);
 	const struct msm_pingroup *g;
 	unsigned long flags;
-	u32 val;
 
 	if (test_bit(d->hwirq, pctrl->skip_wake_irqs)) {
 		if (test_bit(d->hwirq, pctrl->dual_edge_irqs))
@@ -902,8 +909,7 @@ static void msm_gpio_irq_ack(struct irq_data *d)
 
 	raw_spin_lock_irqsave(&pctrl->lock, flags);
 
-	val = g->intr_ack_high ? BIT(g->intr_status_bit) : 0;
-	msm_writel_intr_status(val, pctrl, g);
+	msm_ack_intr_status(pctrl, g);
 
 	if (test_bit(d->hwirq, pctrl->dual_edge_irqs))
 		msm_gpio_update_dual_edge_pos(pctrl, g, d);

