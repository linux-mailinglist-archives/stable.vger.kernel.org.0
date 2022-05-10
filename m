Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC67521627
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241544AbiEJNEX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 10 May 2022 09:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235608AbiEJNEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:04:21 -0400
Received: from mail4.swissbit.com (mail4.swissbit.com [176.95.1.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF99725B07E
        for <stable@vger.kernel.org>; Tue, 10 May 2022 06:00:24 -0700 (PDT)
Received: from mail4.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id C89601234EE;
        Tue, 10 May 2022 15:00:22 +0200 (CEST)
Received: from mail4.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id B71C2121C66;
        Tue, 10 May 2022 15:00:22 +0200 (CEST)
X-TM-AS-ERS: 10.149.2.84-127.5.254.253
X-TM-AS-SMTP: 1.0 ZXguc3dpc3NiaXQuY29t Y2xvZWhsZUBoeXBlcnN0b25lLmNvbQ==
X-DDEI-TLS-USAGE: Used
Received: from ex.swissbit.com (SBDEEX02.sbitdom.lan [10.149.2.84])
        by mail4.swissbit.com (Postfix) with ESMTPS;
        Tue, 10 May 2022 15:00:22 +0200 (CEST)
Received: from sbdeex02.sbitdom.lan (10.149.2.84) by sbdeex02.sbitdom.lan
 (10.149.2.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 10 May
 2022 15:00:22 +0200
Received: from sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74]) by
 sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74%8]) with mapi id
 15.02.0986.022; Tue, 10 May 2022 15:00:22 +0200
From:   =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ricky WU <ricky_wu@realtek.com>
Subject: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
Thread-Topic: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
Thread-Index: AQHYZG2+SMidSc50iEW8Aq37+2MmcA==
Date:   Tue, 10 May 2022 13:00:22 +0000
Message-ID: <d569393619d54d8789a223a9db6d455e@hyperstone.com>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.153.3.143]
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TMASE-Version: DDEI-5.1-9.0.1002-26884.007
X-TMASE-Result: 10--5.071000-10.000000
X-TMASE-MatchedRID: u8usGLXufdgus6wjYQDwl8Yv//yaWh0DegIHHX2L4YxUjspoiX02Fy7+
        Od83THd8keCxmeCiEeMdZVZzCCDtivVACeiFsAcyPPov5T+l6PGSiza26cvwNMC5DTEMxpeQfiq
        1gj2xET/vAkvb7xTgsf0bVLkspps2obdjeDI8cBGp3Btb1bH20Pvx3a8g6f5KoT/LvysjYBjx8o
        GSM8+Ok14xYg+HJKi6oHK7awNYapYt/kLmlQjFmhmCYUYerLHrfS0Ip2eEHnycUrtUT/EvSfoLR
        4+zsDTteLhcSg9d5zH61ekaKEGu/FLGqMN505FTBLTFEV+VR5IVfOuw3z90UQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-TMASE-XGENCLOUD: bdbc90b4-a32d-4ae8-8301-d7648b0f0619-0-0-200-0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1f311c94aabd ("mmc: rtsx: add 74 Clocks in power on flow") upstream.
backport note: removed unavailable power_delay_ms 5ms as 10ms is fine, too.

SD spec definition:
"Host provides at least 74 Clocks before issuing first command"
After 1ms for the voltage stable then start issuing the Clock signals

if POWER STATE is
MMC_POWER_OFF to MMC_POWER_UP to issue Clock signal to card
MMC_POWER_UP to MMC_POWER_ON to stop issuing signal to card

Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 9de6a32f0c9f..0b1d4f2b5862 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -49,10 +49,7 @@ struct realtek_pci_sdmmc {
 	bool			double_clk;
 	bool			eject;
 	bool			initial_mode;
-	int			power_state;
-#define SDMMC_POWER_ON		1
-#define SDMMC_POWER_OFF		0
-
+	int			prev_power_state;
 	int			sg_count;
 	s32			cookie;
 	int			cookie_sg_count;
@@ -913,14 +910,21 @@ static int sd_set_bus_width(struct realtek_pci_sdmmc *host,
 	return err;
 }
 
-static int sd_power_on(struct realtek_pci_sdmmc *host)
+static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode)
 {
 	struct rtsx_pcr *pcr = host->pcr;
 	int err;
 
-	if (host->power_state == SDMMC_POWER_ON)
+	if (host->prev_power_state == MMC_POWER_ON)
 		return 0;
 
+	if (host->prev_power_state == MMC_POWER_UP) {
+		rtsx_pci_write_register(pcr, SD_BUS_STAT, SD_CLK_TOGGLE_EN, 0);
+		goto finish;
+	}
+
+	msleep(100);
+
 	rtsx_pci_init_cmd(pcr);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_SELECT, 0x07, SD_MOD_SEL);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_SHARE_MODE,
@@ -939,11 +943,17 @@ static int sd_power_on(struct realtek_pci_sdmmc *host)
 	if (err < 0)
 		return err;
 
+	mdelay(1);
+
 	err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
 	if (err < 0)
 		return err;
 
-	host->power_state = SDMMC_POWER_ON;
+	/* send at least 74 clocks */
+	rtsx_pci_write_register(pcr, SD_BUS_STAT, SD_CLK_TOGGLE_EN, SD_CLK_TOGGLE_EN);
+
+finish:
+	host->prev_power_state = power_mode;
 	return 0;
 }
 
@@ -952,7 +962,7 @@ static int sd_power_off(struct realtek_pci_sdmmc *host)
 	struct rtsx_pcr *pcr = host->pcr;
 	int err;
 
-	host->power_state = SDMMC_POWER_OFF;
+	host->prev_power_state = MMC_POWER_OFF;
 
 	rtsx_pci_init_cmd(pcr);
 
@@ -978,7 +988,7 @@ static int sd_set_power_mode(struct realtek_pci_sdmmc *host,
 	if (power_mode == MMC_POWER_OFF)
 		err = sd_power_off(host);
 	else
-		err = sd_power_on(host);
+		err = sd_power_on(host, power_mode);
 
 	return err;
 }
@@ -1416,7 +1426,7 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 	host->mmc = mmc;
 	host->pdev = pdev;
 	host->cookie = -1;
-	host->power_state = SDMMC_POWER_OFF;
+	host->prev_power_state = MMC_POWER_OFF;
 	INIT_WORK(&host->work, sd_request);
 	platform_set_drvdata(pdev, host);
 	pcr->slots[RTSX_SD_CARD].p_dev = pdev;
-- 
2.34.1=
Hyperstone GmbH | Reichenaustr. 39a  | 78467 Konstanz
Managing Director: Dr. Jan Peter Berns.
Commercial register of local courts: Freiburg HRB381782

