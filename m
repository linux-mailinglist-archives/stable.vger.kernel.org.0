Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8DA154C2B
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgBFTYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:24:55 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41149 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbgBFTYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 14:24:55 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 119322207A;
        Thu,  6 Feb 2020 14:24:54 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 14:24:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TM7jJO
        WQAR1NaRE3HrhsMQMzGKi5xvyfS6365VWyF00=; b=kPhtcwXUWPPNwjdMtmvMx5
        sSBsAwIdcX9eNXR765SxB4Mk8Sc/G6juBIxnH+c92dxOWpH3ypVrOtZ8gwHmAOfq
        76upeC0+2h60nUe3Ana3OAOLugD1oKOfEyrvG7C9pO6tkLKmwIYShPY86nPAX3IN
        RrFsgSzLNkoKdAGP7Fbk1J5BKDS1LO29Wx8IQokjIgu/ZZuM0Geu3R9CxJQwkgRa
        du7M48GnahsA1welzf9WGUQISCrNBOltuls0pwo4iVbsjDZzBeGiwkPRAmQEYySa
        Dj7iA9eXeT3kVIyx73Zx4DG9Vawj2Q51l4iR8X27y6B5LPDRzZ/MS9OkTA4um+7Q
        ==
X-ME-Sender: <xms:BWg8XnVwhMg2hgIMoyy1zpAuceG7y36_wRuart3qqJK88BbbRC6IOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheefgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:BWg8XmIJ75Q_pEgowcMEFSrpcEoJCiwHqQ4i4lyfjWM-0ot4VUWBfw>
    <xmx:BWg8XlFocONg73AsgfuLjNtn76QZuzU09-_7Y0F0hemzEnEnnJ6i3w>
    <xmx:BWg8XryCMO877YupcW1gB7MrzhVeyL1z19XDywQT7GaWlAgI9_wIqw>
    <xmx:Bmg8XiVlxZOyeG0zKs0uOhaMDMzqwKywIR4mlAyLu7sgTCn_PnINmg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A27FD3280059;
        Thu,  6 Feb 2020 14:24:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci: Update the tuning failed messages to pr_debug" failed to apply to 4.4-stable tree
To:     faiz_abbas@ti.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 06 Feb 2020 20:08:27 +0100
Message-ID: <1581016107113159@kroah.com>
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

