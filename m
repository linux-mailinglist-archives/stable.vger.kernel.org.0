Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A7D5214D3
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 14:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240464AbiEJMMY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 10 May 2022 08:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241546AbiEJMMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 08:12:21 -0400
Received: from mail4.swissbit.com (mail4.swissbit.com [176.95.1.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360BF224A65
        for <stable@vger.kernel.org>; Tue, 10 May 2022 05:08:23 -0700 (PDT)
Received: from mail4.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id E2B7B122BFB;
        Tue, 10 May 2022 14:08:20 +0200 (CEST)
Received: from mail4.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id CF6E51227B2;
        Tue, 10 May 2022 14:08:20 +0200 (CEST)
X-TM-AS-ERS: 10.149.2.84-127.5.254.253
X-TM-AS-SMTP: 1.0 ZXguc3dpc3NiaXQuY29t Y2xvZWhsZUBoeXBlcnN0b25lLmNvbQ==
X-DDEI-TLS-USAGE: Used
Received: from ex.swissbit.com (SBDEEX02.sbitdom.lan [10.149.2.84])
        by mail4.swissbit.com (Postfix) with ESMTPS;
        Tue, 10 May 2022 14:08:20 +0200 (CEST)
Received: from sbdeex02.sbitdom.lan (10.149.2.84) by sbdeex02.sbitdom.lan
 (10.149.2.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 10 May
 2022 14:08:20 +0200
Received: from sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74]) by
 sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74%8]) with mapi id
 15.02.0986.022; Tue, 10 May 2022 14:08:20 +0200
From:   =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC:     Ricky WU <ricky_wu@realtek.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
Thread-Topic: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
Thread-Index: AQHYZGZMhUjOTqWzAEqaagAoxS9rFg==
Date:   Tue, 10 May 2022 12:08:20 +0000
Message-ID: <64c6a1e0131e4084960864d1f4a9f961@hyperstone.com>
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
X-TMASE-Result: 10--5.548200-10.000000
X-TMASE-MatchedRID: dwNgap4H9hgus6wjYQDwl8Yv//yaWh0DVr5aZRoV9oSvloAnGr4qhvnw
        L4uFGQTP6ob46L6ERwrERWdStx210EerW12mrTm5TuctSpiuWyUUi4Ehat05499RlPzeVuQQffw
        OGyRfzzP0zDekkY+mbuKlfjQbkskwa1gHxOm3EdwKnxSJyztfqipHfPRqh71JBQyuhmWECX3hDo
        h7wbP2f4SS38vwe0AngysCnw2u67BJI5ZUl647UBM0JxSxHjFJ3QfwsVk0UbtuRXh7bFKB7nEX6
        XjbP/95A3gJpbukcn36npSp4NlRqDKF95T+R8x+WClYJu9r4yY=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-TMASE-XGENCLOUD: 5a2e91d6-ab5e-44d9-bc4f-88059ca75781-0-0-200-0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1f311c94aabd ("mmc: rtsx: add 74 Clocks in power on flow") upstream.

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
 drivers/mmc/host/rtsx_pci_sdmmc.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index e00167bcfaf6..b5cb83bb9b85 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -37,10 +37,7 @@ struct realtek_pci_sdmmc {
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
@@ -902,14 +899,21 @@ static int sd_set_bus_width(struct realtek_pci_sdmmc *host,
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
@@ -928,11 +932,17 @@ static int sd_power_on(struct realtek_pci_sdmmc *host)
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
 
@@ -941,7 +951,7 @@ static int sd_power_off(struct realtek_pci_sdmmc *host)
 	struct rtsx_pcr *pcr = host->pcr;
 	int err;
 
-	host->power_state = SDMMC_POWER_OFF;
+	host->prev_power_state = MMC_POWER_OFF;
 
 	rtsx_pci_init_cmd(pcr);
 
@@ -967,7 +977,7 @@ static int sd_set_power_mode(struct realtek_pci_sdmmc *host,
 	if (power_mode == MMC_POWER_OFF)
 		err = sd_power_off(host);
 	else
-		err = sd_power_on(host);
+		err = sd_power_on(host, power_mode);
 
 	return err;
 }
@@ -1404,10 +1414,11 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 
 	host = mmc_priv(mmc);
 	host->pcr = pcr;
+	mmc->ios.power_delay_ms = 5;
 	host->mmc = mmc;
 	host->pdev = pdev;
 	host->cookie = -1;
-	host->power_state = SDMMC_POWER_OFF;
+	host->prev_power_state = MMC_POWER_OFF;
 	INIT_WORK(&host->work, sd_request);
 	platform_set_drvdata(pdev, host);
 	pcr->slots[RTSX_SD_CARD].p_dev = pdev;
-- 
2.34.1
Hyperstone GmbH | Reichenaustr. 39a  | 78467 Konstanz
Managing Director: Dr. Jan Peter Berns.
Commercial register of local courts: Freiburg HRB381782

