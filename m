Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3126154C26
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgBFTYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:24:48 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55973 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbgBFTYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 14:24:48 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0362E21B6A;
        Thu,  6 Feb 2020 14:24:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 14:24:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=DaVSi9
        KManyWnDfVgR8mDo9CtQ8LRXO9Lqz4g6JghqA=; b=aRdB/dCbb3TgIASrS3/Wl4
        MGt2RCMCNQpeANMBCgfQgtRJtNdvj64JN8WkVl8EH3jL6fIdOXTXlhTU9sh8vanY
        n6aFPZWGvSyNkj0GI3Z0/N/uoZAHSKuBp6EzudB7LrXhlVugRvrJXUF7g4PTIyT1
        2nU6hNPUhk7HihzdGWI3ZLr3lKzqIwcCH/zyb+uzbo5pTRkX72+GYs3ph4qk46RN
        wFs+xaY9WFPDhaD0qYLoZ9P1mLLlqDRtPHspVFdba7SY24WvnozuFRcTQDd5C5qp
        fUZF9H3QCE3/gXzDuCqomT5PhLFjqXdT4ZYisHO/KTnT/x2GogRTerElTeyv4x8A
        ==
X-ME-Sender: <xms:_mc8XkPFJbl0XR-8g3PvcrZK_BQchD59PlfIhv6qA6hyJ-3iAtWnYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheefgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:_mc8XlA6_VBVLIZBUARLMO_D78IJke2JfjHR2361blrEQntWXfSe5g>
    <xmx:_mc8XgMAoC2ApdL79eDC_3jNTQAIVJrVDyoF20wNUM5e4S_Xxuyt8w>
    <xmx:_mc8XkeW1EObPztx8HKFqmKVRljnWAoVl9XuoQi2_7cSG_ydtH7PuQ>
    <xmx:_mc8XgcFVACbAwLRIMCn2Wlfw8pxbXeMRNZbkYKacHtJ0Pngf3MtHg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 82F243060701;
        Thu,  6 Feb 2020 14:24:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci: Update the tuning failed messages to pr_debug" failed to apply to 5.5-stable tree
To:     faiz_abbas@ti.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 06 Feb 2020 20:08:24 +0100
Message-ID: <15810161041093@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 811ba67632aae618985209cb9455f1d342426e6d Mon Sep 17 00:00:00 2001
From: Faiz Abbas <faiz_abbas@ti.com>
Date: Fri, 6 Dec 2019 17:13:26 +0530
Subject: [PATCH] mmc: sdhci: Update the tuning failed messages to pr_debug
 level

Tuning support in DDR50 speed mode was added in SD Specifications Part1
Physical Layer Specification v3.01. Its not possible to distinguish
between v3.00 and v3.01 from the SCR and that is why since
commit 4324f6de6d2e ("mmc: core: enable CMD19 tuning for DDR50 mode")
tuning failures are ignored in DDR50 speed mode.

Cards compatible with v3.00 don't respond to CMD19 in DDR50 and this
error gets printed during enumeration and also if retune is triggered at
any time during operation. Update the printk level to pr_debug so that
these errors don't lead to false error reports.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Cc: stable@vger.kernel.org # v4.4+
Link: https://lore.kernel.org/r/20191206114326.15856-1-faiz_abbas@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 012b1d9145b9..d8f1d87c58c6 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2408,8 +2408,8 @@ static int __sdhci_execute_tuning(struct sdhci_host *host, u32 opcode)
 		sdhci_send_tuning(host, opcode);
 
 		if (!host->tuning_done) {
-			pr_info("%s: Tuning timeout, falling back to fixed sampling clock\n",
-				mmc_hostname(host->mmc));
+			pr_debug("%s: Tuning timeout, falling back to fixed sampling clock\n",
+				 mmc_hostname(host->mmc));
 			sdhci_abort_tuning(host, opcode);
 			return -ETIMEDOUT;
 		}

