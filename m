Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B57216DDB
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 15:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgGGNgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 09:36:37 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:41465 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728197AbgGGNgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 09:36:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9B30F194296A;
        Tue,  7 Jul 2020 09:36:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 07 Jul 2020 09:36:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=cJWg/7
        PsDvKnL0q+A6F2fDCEXjsnh6QQCpDVEU5Jxnk=; b=cpfvcc0qXM8IxFKmUGO08D
        FtKLLj9+GDcwduDWVPl3xfNla7pdyG6o2KN0fOxFK69+W1R+MiuUaJTE+EEMS+0t
        NX5hb1QAqMWQs2v7Rl7Ahc7Ce5wQSnon3hTfv5VflB8K1i4wLgxS+JtM++DgJSLQ
        ThiM9CoRh38K7P3zPnZ/ebEu3bTTeHbtyoWC+OZRei+XdOWau125WEBW0sEiAn6g
        Vkah56pmnGqRPF7gt5rrd6DRM3fw9PSdSeT8wX3KQRnSwl2+w36d5ru+2/Rms7dP
        ILbNQfVWxn6OfQpfl0BX7Hc2L5TkGwJIGV4yWUlD+lNyASQZAEObhTF/CJuCYxsg
        ==
X-ME-Sender: <xms:ZHoEX7anlL1P7PejI2KF3FUVuUWm2ul3dPPQbr7XfEA65Y_2swAoFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ZHoEX6YIt_4FvK40f0NYQRPQny4mT-pPCfc-f4OSTeJSuRsiJA1s7w>
    <xmx:ZHoEX98qHMqAsiQ55vKaIrV9qzGpUBA-MhPUu9Azs9HB-QjwBZXaMA>
    <xmx:ZHoEXxoH-ohAH575hNty-KGMLfVc2nJOXgNkfculNfAkdK-M9OmKvA>
    <xmx:ZHoEX7AbvTqpVu2q7kUI9PXn0zYktt-p5awtiQC2xTqGf3R3mP18PA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 209E2328005E;
        Tue,  7 Jul 2020 09:36:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] thermal/drivers/cpufreq_cooling: Fix wrong frequency" failed to apply to 4.14-stable tree
To:     finley.xiao@rock-chips.com, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, stable@vger.kernel.org,
        viresh.kumar@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Jul 2020 15:36:26 +0200
Message-ID: <1594128986175103@kroah.com>
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

From 371a3bc79c11b707d7a1b7a2c938dc3cc042fffb Mon Sep 17 00:00:00 2001
From: Finley Xiao <finley.xiao@rock-chips.com>
Date: Fri, 19 Jun 2020 17:08:25 +0800
Subject: [PATCH] thermal/drivers/cpufreq_cooling: Fix wrong frequency
 converted from power

The function cpu_power_to_freq is used to find a frequency and set the
cooling device to consume at most the power to be converted. For example,
if the power to be converted is 80mW, and the em table is as follow.
struct em_cap_state table[] = {
	/* KHz     mW */
	{ 1008000, 36, 0 },
	{ 1200000, 49, 0 },
	{ 1296000, 59, 0 },
	{ 1416000, 72, 0 },
	{ 1512000, 86, 0 },
};
The target frequency should be 1416000KHz, not 1512000KHz.

Fixes: 349d39dc5739 ("thermal: cpu_cooling: merge frequency and power tables")
Cc: <stable@vger.kernel.org> # v4.13+
Signed-off-by: Finley Xiao <finley.xiao@rock-chips.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200619090825.32747-1-finley.xiao@rock-chips.com

diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
index 9e124020519f..6c0e1b053126 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -123,12 +123,12 @@ static u32 cpu_power_to_freq(struct cpufreq_cooling_device *cpufreq_cdev,
 {
 	int i;
 
-	for (i = cpufreq_cdev->max_level - 1; i >= 0; i--) {
-		if (power > cpufreq_cdev->em->table[i].power)
+	for (i = cpufreq_cdev->max_level; i >= 0; i--) {
+		if (power >= cpufreq_cdev->em->table[i].power)
 			break;
 	}
 
-	return cpufreq_cdev->em->table[i + 1].frequency;
+	return cpufreq_cdev->em->table[i].frequency;
 }
 
 /**

