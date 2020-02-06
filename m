Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDD8154C2A
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgBFTYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:24:53 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53085 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbgBFTYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 14:24:53 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9AD3B22083;
        Thu,  6 Feb 2020 14:24:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 14:24:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4UNI6A
        GcIxJvvgv26Jf5rdvdsBNKRJSHIg5st0QgCkU=; b=eoE2X5vm7UBUzScHqgmBlM
        Ix1Lt0Zt0DVx28ObgUvBYriQJfrptW2mXD7Asc4zaSoehvIlPI4kbfRdv1kK34Nj
        JdgFn7E9/k8T0h8xjMF9bIaSMsiNNUewFRf/8qz5WdixGnF3z8UyLKteLoBbkrbm
        i5foUUljwr+rCJSBknVsk5hfGsgU+B1BWndk6YOJEmYj7GKIxmcnzTm2f0DzpDqh
        W9+JVF4/FM9qKAaMwzJSBY0EeY4BvFbeInqkGat/Ftpi3ww6UweXiJYNF5utgs/G
        LFaY90Fiba7rW1AmABjAbXSD0AvqYYASt+v8qz5q/OxCrGJWFtsh8mb9UJkGWzxA
        ==
X-ME-Sender: <xms:BGg8Xu7EA6TAESgi1dWkqhJ2MT_ex0ZGR-je6Sgkodt1zT3hrrLBjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheefgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:BGg8XpLJSqNgiccHO3ujF43xjfbclvTj25tJAXk-0-tP-8fQhvPUMQ>
    <xmx:BGg8Xl4DUamF5brm7ftn7PMmxAnr5fbhC9g7Ox23oPekDhsZOjq0KQ>
    <xmx:BGg8XhX0ndGlju_WZZg022dEhBXy9HuXjL94OmCapKaUwvU2gwgsWA>
    <xmx:BGg8XhKx_Z004HJk_gm6i0DO1626W0SNtZ-lxSiduBGA5oA5vfZ1eA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3609A328005A;
        Thu,  6 Feb 2020 14:24:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci: Update the tuning failed messages to pr_debug" failed to apply to 4.14-stable tree
To:     faiz_abbas@ti.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 06 Feb 2020 20:08:26 +0100
Message-ID: <158101610642213@kroah.com>
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

