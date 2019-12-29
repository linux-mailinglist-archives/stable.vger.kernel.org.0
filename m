Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E701212C342
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 17:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfL2QFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 11:05:33 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:54629 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726455AbfL2QFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 11:05:32 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D9A3E473;
        Sun, 29 Dec 2019 11:05:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 11:05:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2LAtLq
        wdIkFt9Wx1/l5FDOWA52cw47I6lC1tR5cBKiE=; b=isqjZyHBI7c/xLFG9lrOaI
        1xA/ZjlkbFB3TNhlwdyqEVnnkgUqZu6jrkCYqLqZdftnfgcaqOyLOf2l+tawds0y
        G6+pjiEWjOTHAixumlukpLyn6ZGpOAdwyeFimK9sd+EUdUiEArhr7OT3oDs0Rt16
        fI8CLNoItnvrMINp9dYPf7IHck4oEhlEIAU87T48Uh3w31KSJiMvIM68XJoZKTK5
        mEYzVIVipTSTRA4/tdIbdY+TSztL0xJ+kveOnxSlitgYr+gJGJ5xeP/HUbXCizPa
        crdJN+XrAw3s4IwIMLTGRAHNuREutqtIxjRahT7BdYBqOd7+N9oQafRsak4+4wWQ
        ==
X-ME-Sender: <xms:y84IXnhRkGNDdYdqAYRc3RAMupWOyMVr4a66Ze9xknuhyGtvdFab-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:y84IXrKxY6v1yT5BPFRNahtHg4KZomPM_0jFD5VTLzvMJXHQWqfy5g>
    <xmx:y84IXpcRC6cQNfzqVGqVplDkPOtRf3Jc_cVrTEUfTdSuMVlfim1xgA>
    <xmx:y84IXt8RGPit2R9xjXXOlx4ND3NZYI9H4Yk2kvv72WuKqJ7Udf9ovg>
    <xmx:y84IXhtuXaAz5wyb_LWd4_Krxc1MVwrcomrsizNE82pCxHoc2-HRyA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 277C83060A32;
        Sun, 29 Dec 2019 11:05:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci: Update the tuning failed messages to pr_debug" failed to apply to 4.4-stable tree
To:     faiz_abbas@ti.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 17:05:22 +0100
Message-ID: <15776355225665@kroah.com>
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

From 2c92dd20304f505b6ef43d206fff21bda8f1f0ae Mon Sep 17 00:00:00 2001
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
index 296d955ede59..42a9c8179da7 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2417,8 +2417,8 @@ static int __sdhci_execute_tuning(struct sdhci_host *host, u32 opcode)
 		sdhci_send_tuning(host, opcode);
 
 		if (!host->tuning_done) {
-			pr_info("%s: Tuning timeout, falling back to fixed sampling clock\n",
-				mmc_hostname(host->mmc));
+			pr_debug("%s: Tuning timeout, falling back to fixed sampling clock\n",
+				 mmc_hostname(host->mmc));
 			sdhci_abort_tuning(host, opcode);
 			return -ETIMEDOUT;
 		}

