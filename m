Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23609154C27
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgBFTYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:24:49 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59549 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbgBFTYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 14:24:49 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5A69E21D28;
        Thu,  6 Feb 2020 14:24:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 14:24:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xwyPz3
        ZmsNYLjZKS/Ktv+/jm8xLhAsR72UD4gM3y7cU=; b=ADPQ8kMDk7JmC7FDuKkai7
        G5JDvUCiqb0YOObwIjn+LccA7FXEkZY3ZJSt0ItlLD57rw7ZvWPo1FgoAmA88ehd
        yZZISY4wYVMC+ZhjN9t4aVU5ZRFOzU9Vzq772VI6/eBoUy9prchS3/LW8Ba7oAfw
        ylxp/2xRa/UkyrMRV2tP1/uiA8gtNB5ZNqVaXNchhY3Mjwr9lrCqbUGwDrzumwEZ
        22tTujk2xhjVtB2cgscGa8EdvwTeHk78v81pzjrKK+dv2uDLAPo2Fi+E/AUbNctp
        jzy33xHlIVjvPblIJcHUE89hLPWxxd7Y1kMiwpsy7CgwoHWroGsk9tdikTglSBOw
        ==
X-ME-Sender: <xms:AGg8Xms-nQAlPOuDimeWylCvwPtdDKjIeu63SvxoopA7iZwZnWB3Cg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheefgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:AGg8XlQuolMr50owzFE1tLkxnQ1iAv9zHYSxjz2uR4aFokvob1ayiA>
    <xmx:AGg8Xnkl3U41x4RLX7ER-9BgwUy6JcAmeqQ-Oc2qU73rvM0dW8eX9w>
    <xmx:AGg8XpME0apBZ7bCI_G9E_wLvppgZoy6tWWhgFjlU0G3mWyv7tPMxg>
    <xmx:AGg8XpQnUcz69PQBOhe6KRzQ1LvsWfUmA67u5GOeCGvZVCCWKtUJpQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E79C63060701;
        Thu,  6 Feb 2020 14:24:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci: Update the tuning failed messages to pr_debug" failed to apply to 4.19-stable tree
To:     faiz_abbas@ti.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 06 Feb 2020 20:08:25 +0100
Message-ID: <158101610529192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

