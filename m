Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2855B32727E
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 14:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhB1NwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 08:52:11 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:35391 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229715AbhB1NwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 08:52:10 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 86C2019407B0;
        Sun, 28 Feb 2021 08:51:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 28 Feb 2021 08:51:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=dtjGQl
        Dsh2NAGimE6qFKK7M53CHvgHh9NvBgSdt2u9w=; b=UF7NOkS8f05r0qncwjID/I
        ub3aNqdoWPVruuQ/wJT6z6vCNO0kGkXOqhNaYO0v6AGcvCtDH4QGysS1wFqlzyUr
        M0I/JmpbwWD8A3hKb9U6f+SNCmag+M8MFGa6a6Iq9Q/5JiJ8PMuUGyskh3E3AU6x
        ShFtpYbobLGJb3v/royS2IPof0+WvUw/E67CgQxAPhFfemskhNwNeN/m7pc0Nyu8
        NkBTNA5Tpb+mPjrGRwYEInumcu6UrkyT6nSxFW7FFbhEgNEgj95QYD0jmSc1ZQEA
        fHw0/SELNOFk9A+2P6bX8rUtAmaa5fn3V4O3c2cpVtt9Lcic0RC1nyTH7uuZ0wkg
        ==
X-ME-Sender: <xms:3J87YNF8o1VkVvHNXfgH7lsml7Ya82dJf6jAxJU7_wDt6iT1n7pLdQ>
    <xme:3J87YCUHYu_TBMOci-wF1k7oaWqgbH7pfSXhnEuEWciugD4wSMX2fK5K2XTHUBEWh
    aeUPR7qxUm4Tw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleeigdehkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:3J87YPKgpKJyFeTWvTUITkFWeggju-F9mQCBmC9m2EGKcpk5380aOQ>
    <xmx:3J87YDFfraioFftYTBXgKPYsq5xf9B3E5iKGzJz497YqYDHN676xzg>
    <xmx:3J87YDVSxxDpBGC8tXe3GiCH4jatQKC5HXYz-7zyljsXqTnSMHHtfw>
    <xmx:3J87YOT5DRYb-pyOD7f7my6jJpWBm_MhoamWR3jZUayNS6NwXmzvkA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BFE971080059;
        Sun, 28 Feb 2021 08:51:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] coresight: etm4x: Handle accesses to TRCSTALLCTLR" failed to apply to 5.11-stable tree
To:     suzuki.poulose@arm.com, gregkh@linuxfoundation.org,
        leo.yan@linaro.org, mathieu.poirier@linaro.org,
        mike.leach@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Feb 2021 14:51:20 +0100
Message-ID: <161452028074223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f72896063396b0cb205cbf0fd76ec6ab3ca11c8a Mon Sep 17 00:00:00 2001
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Date: Mon, 1 Feb 2021 11:13:51 -0700
Subject: [PATCH] coresight: etm4x: Handle accesses to TRCSTALLCTLR

TRCSTALLCTLR register is only implemented if

   TRCIDR3.STALLCTL == 0b1

Make sure the driver touches the register only it is implemented.

Link: https://lore.kernel.org/r/20210127184617.3684379-1-suzuki.poulose@arm.com
Cc: stable@vger.kernel.org
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20210201181351.1475223-32-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 473ab7480a36..5017d33ba4f5 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -306,7 +306,8 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 	etm4x_relaxed_write32(csa, 0x0, TRCAUXCTLR);
 	etm4x_relaxed_write32(csa, config->eventctrl0, TRCEVENTCTL0R);
 	etm4x_relaxed_write32(csa, config->eventctrl1, TRCEVENTCTL1R);
-	etm4x_relaxed_write32(csa, config->stall_ctrl, TRCSTALLCTLR);
+	if (drvdata->stallctl)
+		etm4x_relaxed_write32(csa, config->stall_ctrl, TRCSTALLCTLR);
 	etm4x_relaxed_write32(csa, config->ts_ctrl, TRCTSCTLR);
 	etm4x_relaxed_write32(csa, config->syncfreq, TRCSYNCPR);
 	etm4x_relaxed_write32(csa, config->ccctlr, TRCCCCTLR);
@@ -1463,7 +1464,8 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	state->trcauxctlr = etm4x_read32(csa, TRCAUXCTLR);
 	state->trceventctl0r = etm4x_read32(csa, TRCEVENTCTL0R);
 	state->trceventctl1r = etm4x_read32(csa, TRCEVENTCTL1R);
-	state->trcstallctlr = etm4x_read32(csa, TRCSTALLCTLR);
+	if (drvdata->stallctl)
+		state->trcstallctlr = etm4x_read32(csa, TRCSTALLCTLR);
 	state->trctsctlr = etm4x_read32(csa, TRCTSCTLR);
 	state->trcsyncpr = etm4x_read32(csa, TRCSYNCPR);
 	state->trcccctlr = etm4x_read32(csa, TRCCCCTLR);
@@ -1575,7 +1577,8 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	etm4x_relaxed_write32(csa, state->trcauxctlr, TRCAUXCTLR);
 	etm4x_relaxed_write32(csa, state->trceventctl0r, TRCEVENTCTL0R);
 	etm4x_relaxed_write32(csa, state->trceventctl1r, TRCEVENTCTL1R);
-	etm4x_relaxed_write32(csa, state->trcstallctlr, TRCSTALLCTLR);
+	if (drvdata->stallctl)
+		etm4x_relaxed_write32(csa, state->trcstallctlr, TRCSTALLCTLR);
 	etm4x_relaxed_write32(csa, state->trctsctlr, TRCTSCTLR);
 	etm4x_relaxed_write32(csa, state->trcsyncpr, TRCSYNCPR);
 	etm4x_relaxed_write32(csa, state->trcccctlr, TRCCCCTLR);
diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
index b646d53a3133..0995a10790f4 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
@@ -389,7 +389,7 @@ static ssize_t mode_store(struct device *dev,
 		config->eventctrl1 &= ~BIT(12);
 
 	/* bit[8], Instruction stall bit */
-	if (config->mode & ETM_MODE_ISTALL_EN)
+	if ((config->mode & ETM_MODE_ISTALL_EN) && (drvdata->stallctl == true))
 		config->stall_ctrl |= BIT(8);
 	else
 		config->stall_ctrl &= ~BIT(8);

