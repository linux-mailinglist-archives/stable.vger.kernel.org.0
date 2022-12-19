Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408CA650E55
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 16:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbiLSPJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 10:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiLSPJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 10:09:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC31B8A
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 07:09:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 730B5B80DF2
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 15:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4869C433D2;
        Mon, 19 Dec 2022 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671462594;
        bh=Kdx9PFlOzvlbL/6ao3zi/XtSD+7ofCoz1GlcTC7xetg=;
        h=Subject:To:Cc:From:Date:From;
        b=bjkNWoXQ4/lPjJauWM5wGwnTNha8vEsZ3mnYXoEgpIUzcj9DYqH5P73+LZeS21dw8
         GHcjF1MlruMFDI2zcnrP7T0lNbIAiUdCjfjfFAeU4tHfej5Qdn3e4xIC3FDgDE+NO5
         sa8mOi71HZe4YtwHgJD+WFgIlCrypO6BDSP6WwL4=
Subject: FAILED: patch "[PATCH] staging: r8188eu: fix led register settings" failed to apply to 5.15-stable tree
To:     martin@kaiser.cx, gregkh@linuxfoundation.org,
        philipp.g.hortmann@gmail.com, straube.linux@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 19 Dec 2022 16:09:43 +0100
Message-ID: <167146258315768@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

12c6223fc180 ("staging: r8188eu: fix led register settings")
647085006beb ("staging: r8188eu: don't check bSurpriseRemoved in SwLedOff")
8f60cb9534e4 ("staging: r8188eu: remove duplicate bSurpriseRemoved check")
857fe9e5efc0 ("staging: r8188eu: add error handling of rtw_read8")
5e080cd771e8 ("staging: r8188eu: improve timeout handling in efuse_read_phymap_from_txpktbuf")
efe20b73c5ca ("staging: r8188eu: improve timeout handling in iol_execute")
1060ec636d8b ("staging: r8188eu: improve timeout handling in rtl8188e_firmware_download")
26209855c3ed ("staging: r8188eu: remove HW_VAR_MLME_JOIN")
6b58692032c1 ("staging: r8188eu: remove SetHalDefVar8188EUsb()")
09ff203cb0c5 ("staging: r8188eu: remove GetHalDefVar8188EUsb()")
72b304d013e9 ("staging: r8188eu: remove HAL_DEF_CURRENT_ANTENNA")
0b465150b322 ("staging: r8188eu: remove HAL_DEF_IS_SUPPORT_ANT_DIV")
e665487795a6 ("staging: r8188eu: remove HW_VAR_AMPDU_MIN_SPACE from SetHwReg8188EU()")
7c1972941ad3 ("staging: r8188eu: remove HW_VAR_BSSID from SetHwReg8188EU()")
d8a130d13497 ("staging: r8188eu: remove GetHwReg8188EU()")
61f514799bea ("staging: r8188eu: remove HW_VAR_FWLPS_RF_ON from GetHwReg8188EU()")
9494dba5d734 ("staging: r8188eu: remove HW_VAR_CHK_HI_QUEUE_EMPTY from GetHwReg8188EU()")
ae3d0470ab57 ("staging: r8188eu: remove HW_VAR_BCN_VALID from GetHwReg8188EU()")
db975705cbbe ("staging: r8188eu: rename clear_bacon_valid_bit()")
f6ca689d12df ("staging: r8188eu: remove the "dump tx packet" fragments")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 12c6223fc1804fd9295dc50d358294539b4a4184 Mon Sep 17 00:00:00 2001
From: Martin Kaiser <martin@kaiser.cx>
Date: Sat, 15 Oct 2022 17:11:06 +0200
Subject: [PATCH] staging: r8188eu: fix led register settings

Using an InterTech DMG-02 dongle, the led remains on when the system goes
into standby mode. After wakeup, it's no longer possible to control the
led.

It turned out that the register settings to enable or disable the led were
not correct. They worked for some dongles like the Edimax V2 but not for
others like the InterTech DMG-02.

This patch fixes the register settings. Bit 3 in the led_cfg2 register
controls the led status, bit 5 must always be set to be able to control
the led, bit 6 has no influence on the led. Setting the mac_pinmux_cfg
register is not necessary.

These settings were tested with Edimax V2 and InterTech DMG-02.

Cc: stable@vger.kernel.org
Fixes: 8cd574e6af54 ("staging: r8188eu: introduce new hal dir for RTL8188eu driver")
Suggested-by: Michael Straube <straube.linux@gmail.com>
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Tested-by: Michael Straube <straube.linux@gmail.com> # InterTech DMG-02,
Tested-by: Philipp Hortmann <philipp.g.hortmann@gmail.com> # Edimax N150
Link: https://lore.kernel.org/r/20221015151115.232095-2-martin@kaiser.cx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/r8188eu/core/rtw_led.c b/drivers/staging/r8188eu/core/rtw_led.c
index 2527c252c3e9..5b214488571b 100644
--- a/drivers/staging/r8188eu/core/rtw_led.c
+++ b/drivers/staging/r8188eu/core/rtw_led.c
@@ -31,40 +31,19 @@ static void ResetLedStatus(struct led_priv *pLed)
 
 static void SwLedOn(struct adapter *padapter, struct led_priv *pLed)
 {
-	u8	LedCfg;
-	int res;
-
 	if (padapter->bDriverStopped)
 		return;
 
-	res = rtw_read8(padapter, REG_LEDCFG2, &LedCfg);
-	if (res)
-		return;
-
-	rtw_write8(padapter, REG_LEDCFG2, (LedCfg & 0xf0) | BIT(5) | BIT(6)); /*  SW control led0 on. */
+	rtw_write8(padapter, REG_LEDCFG2, BIT(5)); /*  SW control led0 on. */
 	pLed->bLedOn = true;
 }
 
 static void SwLedOff(struct adapter *padapter, struct led_priv *pLed)
 {
-	u8	LedCfg;
-	int res;
-
 	if (padapter->bDriverStopped)
 		goto exit;
 
-	res = rtw_read8(padapter, REG_LEDCFG2, &LedCfg);/* 0x4E */
-	if (res)
-		goto exit;
-
-	LedCfg &= 0x90; /*  Set to software control. */
-	rtw_write8(padapter, REG_LEDCFG2, (LedCfg | BIT(3)));
-	res = rtw_read8(padapter, REG_MAC_PINMUX_CFG, &LedCfg);
-	if (res)
-		goto exit;
-
-	LedCfg &= 0xFE;
-	rtw_write8(padapter, REG_MAC_PINMUX_CFG, LedCfg);
+	rtw_write8(padapter, REG_LEDCFG2, BIT(5) | BIT(3));
 exit:
 	pLed->bLedOn = false;
 }

