Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C02D327F3E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235171AbhCANPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:15:45 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:33001 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235532AbhCANPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:15:00 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 31E551941D6B;
        Mon,  1 Mar 2021 08:13:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:13:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=znVrUw
        pLl8JLX4bcMdhr6dAd4p/8HIuLBhB0O+bBi0w=; b=iE07nigmfC916mT/ODsoG5
        SDNOOmgLOtmRqP1sfm+sNGNIk0BLZgHmCIT9UEicCuIt9Ak8QwJEp6GxUZCz6pkN
        QMHwrlKxe3uk6upqaEXBKN3RLEkUzNHr/s4V/iNIPJyF4O7TnTr+dfAZtv4Ud2po
        PdKBYB8A1hVnHjs3rRa+Cmxt7WELIx45FRXhslEupFv26ZE2I6+qKx5sIaICgfMj
        RnJx7kMkmmUjJZCQUXaNTrQRO9plpWIbOXE2NK5ScjDkYrAdOqAS0eDV8Hm67tOj
        +fUHghDwshS64Vg1if39FXf9M1pfuFXxoxVKCmUt89MyT9wcqLo6tFCFcqtRhkOg
        ==
X-ME-Sender: <xms:jug8YPqRBjUowD7F1iutS2wuVcxIK4Oty5FGYRZIeGTMEqlvJWNQOg>
    <xme:jug8YJrfYCF7CaHCk78zz6B4nr_Q84pjUM_P2vRYO99omdAij0K9NNfYluWG7IRaL
    z-1FUWpmqGfKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:jug8YMPoe-SCL22-qxhvvq02hBb09cIC80dBnDKmf6GtDnjKe05d2g>
    <xmx:jug8YC65iI5kfWbSMjDPPQN6H5zWYAOG4ILSFOgZYBblVaYdJ6QFTA>
    <xmx:jug8YO7wQV3fO5fLKSM7ThIkaYzDqymV7qDr9_dsKk4a8xHlcmwmxg>
    <xmx:j-g8YDg7BlMzyinK2obtsgb6-y93khcbvLHZCcH3lakKXLu3ydzgsA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6811A108005C;
        Mon,  1 Mar 2021 08:13:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci-esdhc-imx: fix kernel panic when remove module" failed to apply to 4.4-stable tree
To:     Frank.Li@nxp.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:13:48 +0100
Message-ID: <161460442816997@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From a56f44138a2c57047f1ea94ea121af31c595132b Mon Sep 17 00:00:00 2001
From: Frank Li <Frank.Li@nxp.com>
Date: Wed, 10 Feb 2021 12:19:33 -0600
Subject: [PATCH] mmc: sdhci-esdhc-imx: fix kernel panic when remove module

In sdhci_esdhc_imx_remove() the SDHCI_INT_STATUS in read. Under some
circumstances, this may be done while the device is runtime suspended,
triggering the below splat.

Fix the problem by adding a pm_runtime_get_sync(), before reading the
register, which will turn on clocks etc making the device accessible again.

[ 1811.323148] mmc1: card aaaa removed
[ 1811.347483] Internal error: synchronous external abort: 96000210 [#1] PREEMPT SMP
[ 1811.354988] Modules linked in: sdhci_esdhc_imx(-) sdhci_pltfm sdhci cqhci mmc_block mmc_core [last unloaded: mmc_core]
[ 1811.365726] CPU: 0 PID: 3464 Comm: rmmod Not tainted 5.10.1-sd-99871-g53835a2e8186 #5
[ 1811.373559] Hardware name: Freescale i.MX8DXL EVK (DT)
[ 1811.378705] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
[ 1811.384723] pc : sdhci_esdhc_imx_remove+0x28/0x15c [sdhci_esdhc_imx]
[ 1811.391090] lr : platform_drv_remove+0x2c/0x50
[ 1811.395536] sp : ffff800012c7bcb0
[ 1811.398855] x29: ffff800012c7bcb0 x28: ffff00002c72b900
[ 1811.404181] x27: 0000000000000000 x26: 0000000000000000
[ 1811.409497] x25: 0000000000000000 x24: 0000000000000000
[ 1811.414814] x23: ffff0000042b3890 x22: ffff800009127120
[ 1811.420131] x21: ffff00002c4c9580 x20: ffff0000042d0810
[ 1811.425456] x19: ffff0000042d0800 x18: 0000000000000020
[ 1811.430773] x17: 0000000000000000 x16: 0000000000000000
[ 1811.436089] x15: 0000000000000004 x14: ffff000004019c10
[ 1811.441406] x13: 0000000000000000 x12: 0000000000000020
[ 1811.446723] x11: 0101010101010101 x10: 7f7f7f7f7f7f7f7f
[ 1811.452040] x9 : fefefeff6364626d x8 : 7f7f7f7f7f7f7f7f
[ 1811.457356] x7 : 78725e6473607372 x6 : 0000000080808080
[ 1811.462673] x5 : 0000000000000000 x4 : 0000000000000000
[ 1811.467990] x3 : ffff800011ac1cb0 x2 : 0000000000000000
[ 1811.473307] x1 : ffff8000091214d4 x0 : ffff8000133a0030
[ 1811.478624] Call trace:
[ 1811.481081]  sdhci_esdhc_imx_remove+0x28/0x15c [sdhci_esdhc_imx]
[ 1811.487098]  platform_drv_remove+0x2c/0x50
[ 1811.491198]  __device_release_driver+0x188/0x230
[ 1811.495818]  driver_detach+0xc0/0x14c
[ 1811.499487]  bus_remove_driver+0x5c/0xb0
[ 1811.503413]  driver_unregister+0x30/0x60
[ 1811.507341]  platform_driver_unregister+0x14/0x20
[ 1811.512048]  sdhci_esdhc_imx_driver_exit+0x1c/0x3a8 [sdhci_esdhc_imx]
[ 1811.518495]  __arm64_sys_delete_module+0x19c/0x230
[ 1811.523291]  el0_svc_common.constprop.0+0x78/0x1a0
[ 1811.528086]  do_el0_svc+0x24/0x90
[ 1811.531405]  el0_svc+0x14/0x20
[ 1811.534461]  el0_sync_handler+0x1a4/0x1b0
[ 1811.538474]  el0_sync+0x174/0x180
[ 1811.541801] Code: a9025bf5 f9403e95 f9400ea0 9100c000 (b9400000)
[ 1811.547902] ---[ end trace 3fb1a3bd48ff7be5 ]---

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org # v4.0+
Link: https://lore.kernel.org/r/20210210181933.29263-1-Frank.Li@nxp.com
[Ulf: Clarified the commit message a bit]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 16ed19f47939..a20459744d21 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1666,9 +1666,10 @@ static int sdhci_esdhc_imx_remove(struct platform_device *pdev)
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
-	int dead = (readl(host->ioaddr + SDHCI_INT_STATUS) == 0xffffffff);
+	int dead;
 
 	pm_runtime_get_sync(&pdev->dev);
+	dead = (readl(host->ioaddr + SDHCI_INT_STATUS) == 0xffffffff);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 

