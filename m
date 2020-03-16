Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDAEF186A23
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 12:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbgCPLeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 07:34:13 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:35813 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730783AbgCPLeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 07:34:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 191B25D6;
        Mon, 16 Mar 2020 07:34:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 07:34:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XvfftL
        LyoDo74hQ824+8juoSQ0qPyOYR9snvj4FxGI8=; b=0XJkhomwqKkigUU34e0Snh
        Q/nhDlidiyg4CfZIP2CGM5U16nAsCPaZlZyUMPEGJxGUqdX3rjWjbIBRa+NqYJ4T
        4XJFeziU3x1FStaCBg7BMU1ZD9iTmb9z9GjdTXK9fVPQ4GFAM57skONvx+uGvxNd
        8XSx/Ph2ucxifpjOBstAzl1mZuZ3X1R00vyCk7BXKOg7CoXqZD4vrY3urRH0zTwK
        b4Q9lFOYrMGmydejZsO6vX7dr5JFvSTxcvaR+G7EZsovUN0pCV6RgTKWBE6VCeRO
        f9vasCtLbkA/4apuZ/No0ilszm2vX5BPnZROOs8ipDKNA3A20oXSmhf+oSQCq2sA
        ==
X-ME-Sender: <xms:M2RvXqt-HF40doXWwRFCBNXuq06LiirVYDHuq1lzInjPgiU1mTNDgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:M2RvXrK6vpm6BnoyBqjbFxzYWumvqtf648pHjVY3vnOr93Y1E7B_BQ>
    <xmx:M2RvXlgALAiESe0TYpON6UgB5HkqXNDrkDJwy2hCyKf7G14kmmcT8w>
    <xmx:M2RvXoY10ezK82xE_u_ZbCrmE_TWHzdaAm7lpoiadPAVyesGzA6x5Q>
    <xmx:M2RvXlFTai774BXVyn5foVr0UBoIq1WmCwew0RQ7IqZMBXLOhxSDOQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DDE30328005A;
        Mon, 16 Mar 2020 07:34:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] pinctrl: qcom: Assign irq_eoi conditionally" failed to apply to 5.4-stable tree
To:     linus.walleij@linaro.org, bjorn.andersson@linaro.org,
        david@ixit.cz, ilina@codeaurora.org, maz@kernel.org,
        swboyd@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 12:34:09 +0100
Message-ID: <1584358449195216@kroah.com>
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

From 1cada2f307665e208a486d7ac2294ed9a6f74a6f Mon Sep 17 00:00:00 2001
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 9 Mar 2020 16:26:04 +0100
Subject: [PATCH] pinctrl: qcom: Assign irq_eoi conditionally

The hierarchical parts of MSM pinctrl/GPIO is only
used when the device tree has a "wakeup-parent" as
a phandle, but the .irq_eoi is anyway assigned leading
to semantic problems on elder Qualcomm chipsets.

When the drivers/mfd/qcom-pm8xxx.c driver calls
chained_irq_exit() that call will in turn call chip->irq_eoi()
which is set to irq_chip_eoi_parent() by default on a
hierachical IRQ chip, and the parent is pinctrl-msm.c
so that will in turn unconditionally call
irq_chip_eoi_parent() again, but its parent is invalid
so we get the following crash:

 Unnable to handle kernel NULL pointer dereference at
 virtual address 00000010
 pgd = (ptrval)
 [00000010] *pgd=00000000
 Internal error: Oops: 5 [#1] PREEMPT SMP ARM
 (...)
 PC is at irq_chip_eoi_parent+0x4/0x10
 LR is at pm8xxx_irq_handler+0x1b4/0x2d8

If we solve this crash by avoiding to call up to
irq_chip_eoi_parent(), the machine will hang and get
reset by the watchdog, because of semantic issues,
probably inside irq_chip.

As a solution, just assign the .irq_eoi conditionally if
we are actually using a wakeup parent.

Cc: David Heidelberg <david@ixit.cz>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Lina Iyer <ilina@codeaurora.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: stable@vger.kernel.org
Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
Link: https://lore.kernel.org/r/20200306121221.1231296-1-linus.walleij@linaro.org
Link: https://lore.kernel.org/r/20200309125207.571840-1-linus.walleij@linaro.org
Link: https://lore.kernel.org/r/20200309152604.585112-1-linus.walleij@linaro.org
Tested-by: David Heidelberg <david@ixit.cz>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 9a8daa256a32..1a948c3f54b7 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1104,7 +1104,6 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 	pctrl->irq_chip.irq_mask = msm_gpio_irq_mask;
 	pctrl->irq_chip.irq_unmask = msm_gpio_irq_unmask;
 	pctrl->irq_chip.irq_ack = msm_gpio_irq_ack;
-	pctrl->irq_chip.irq_eoi = irq_chip_eoi_parent;
 	pctrl->irq_chip.irq_set_type = msm_gpio_irq_set_type;
 	pctrl->irq_chip.irq_set_wake = msm_gpio_irq_set_wake;
 	pctrl->irq_chip.irq_request_resources = msm_gpio_irq_reqres;
@@ -1118,7 +1117,7 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 		if (!chip->irq.parent_domain)
 			return -EPROBE_DEFER;
 		chip->irq.child_to_parent_hwirq = msm_gpio_wakeirq;
-
+		pctrl->irq_chip.irq_eoi = irq_chip_eoi_parent;
 		/*
 		 * Let's skip handling the GPIOs, if the parent irqchip
 		 * is handling the direct connect IRQ of the GPIO.

