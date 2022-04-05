Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82B74F2C19
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239188AbiDEIos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241181AbiDEIcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A7B17059;
        Tue,  5 Apr 2022 01:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43BDAB81BD9;
        Tue,  5 Apr 2022 08:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97604C385A1;
        Tue,  5 Apr 2022 08:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147346;
        bh=eRoIBT6yVxk5Kw2rAwc2pHO00vfMhz2KtHakSKtwxjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ptytqvI3t2z5i72nefjJ8+CbUyd/S7EfkZKTFf0l6ZniSt9Sa7uQnrDZdaCbQgJYC
         QrvgUDzMwGEokWAcyc0H+zOpLcE2HndswrxnJmhBq3evjPOzxwOF0JpHF8stdeh0Ft
         vdiT2HP+PeLfr2E/RLaRH9Ng+w7VDg8qmSh7dMqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.17 1043/1126] pinctrl: nuvoton: npcm7xx: Rename DS() macro to DSTR()
Date:   Tue,  5 Apr 2022 09:29:50 +0200
Message-Id: <20220405070438.087620555@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

commit 603501c16431c56f74eaef1ee1390f60a30c2187 upstream.

The name "DS" is defined in arch/x86/um/shared/sysdep/ptrace_64.h,
which results in a compiler warning when build-testing on ARCH=um.
Rename this driver's "DS" macro to DSTR so avoid this collision.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 3b588e43ee5c7 ("pinctrl: nuvoton: add NPCM7xx pinctrl and GPIO driver")
Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220205155332.1308899-3-j.neuschaefer@gmx.net
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c |  156 +++++++++++++++---------------
 1 file changed, 78 insertions(+), 78 deletions(-)

--- a/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
@@ -904,7 +904,7 @@ static struct npcm7xx_func npcm7xx_funcs
 #define DRIVE_STRENGTH_HI_SHIFT		12
 #define DRIVE_STRENGTH_MASK		0x0000FF00
 
-#define DS(lo, hi)	(((lo) << DRIVE_STRENGTH_LO_SHIFT) | \
+#define DSTR(lo, hi)	(((lo) << DRIVE_STRENGTH_LO_SHIFT) | \
 			 ((hi) << DRIVE_STRENGTH_HI_SHIFT))
 #define DSLO(x)		(((x) >> DRIVE_STRENGTH_LO_SHIFT) & 0xF)
 #define DSHI(x)		(((x) >> DRIVE_STRENGTH_HI_SHIFT) & 0xF)
@@ -924,31 +924,31 @@ struct npcm7xx_pincfg {
 static const struct npcm7xx_pincfg pincfg[] = {
 	/*		PIN	  FUNCTION 1		   FUNCTION 2		  FUNCTION 3	    FLAGS */
 	NPCM7XX_PINCFG(0,	 iox1, MFSEL1, 30,	  none, NONE, 0,	none, NONE, 0,	     0),
-	NPCM7XX_PINCFG(1,	 iox1, MFSEL1, 30,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12)),
-	NPCM7XX_PINCFG(2,	 iox1, MFSEL1, 30,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12)),
+	NPCM7XX_PINCFG(1,	 iox1, MFSEL1, 30,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12)),
+	NPCM7XX_PINCFG(2,	 iox1, MFSEL1, 30,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12)),
 	NPCM7XX_PINCFG(3,	 iox1, MFSEL1, 30,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(4,	 iox2, MFSEL3, 14,	 smb1d, I2CSEGSEL, 7,	none, NONE, 0,	     SLEW),
 	NPCM7XX_PINCFG(5,	 iox2, MFSEL3, 14,	 smb1d, I2CSEGSEL, 7,	none, NONE, 0,	     SLEW),
 	NPCM7XX_PINCFG(6,	 iox2, MFSEL3, 14,	 smb2d, I2CSEGSEL, 10,  none, NONE, 0,       SLEW),
 	NPCM7XX_PINCFG(7,	 iox2, MFSEL3, 14,	 smb2d, I2CSEGSEL, 10,  none, NONE, 0,       SLEW),
-	NPCM7XX_PINCFG(8,      lkgpo1, FLOCKR1, 4,        none, NONE, 0,	none, NONE, 0,	     DS(8, 12)),
-	NPCM7XX_PINCFG(9,      lkgpo2, FLOCKR1, 8,        none, NONE, 0,	none, NONE, 0,	     DS(8, 12)),
-	NPCM7XX_PINCFG(10,	 ioxh, MFSEL3, 18,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12)),
-	NPCM7XX_PINCFG(11,	 ioxh, MFSEL3, 18,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12)),
+	NPCM7XX_PINCFG(8,      lkgpo1, FLOCKR1, 4,        none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12)),
+	NPCM7XX_PINCFG(9,      lkgpo2, FLOCKR1, 8,        none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12)),
+	NPCM7XX_PINCFG(10,	 ioxh, MFSEL3, 18,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12)),
+	NPCM7XX_PINCFG(11,	 ioxh, MFSEL3, 18,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12)),
 	NPCM7XX_PINCFG(12,	 gspi, MFSEL1, 24,	 smb5b, I2CSEGSEL, 19,  none, NONE, 0,	     SLEW),
 	NPCM7XX_PINCFG(13,	 gspi, MFSEL1, 24,	 smb5b, I2CSEGSEL, 19,  none, NONE, 0,	     SLEW),
 	NPCM7XX_PINCFG(14,	 gspi, MFSEL1, 24,	 smb5c, I2CSEGSEL, 20,	none, NONE, 0,	     SLEW),
 	NPCM7XX_PINCFG(15,	 gspi, MFSEL1, 24,	 smb5c, I2CSEGSEL, 20,	none, NONE, 0,	     SLEW),
-	NPCM7XX_PINCFG(16,     lkgpo0, FLOCKR1, 0,        none, NONE, 0,	none, NONE, 0,	     DS(8, 12)),
-	NPCM7XX_PINCFG(17,      pspi2, MFSEL3, 13,     smb4den, I2CSEGSEL, 23,  none, NONE, 0,       DS(8, 12)),
-	NPCM7XX_PINCFG(18,      pspi2, MFSEL3, 13,	 smb4b, I2CSEGSEL, 14,  none, NONE, 0,	     DS(8, 12)),
-	NPCM7XX_PINCFG(19,      pspi2, MFSEL3, 13,	 smb4b, I2CSEGSEL, 14,  none, NONE, 0,	     DS(8, 12)),
+	NPCM7XX_PINCFG(16,     lkgpo0, FLOCKR1, 0,        none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12)),
+	NPCM7XX_PINCFG(17,      pspi2, MFSEL3, 13,     smb4den, I2CSEGSEL, 23,  none, NONE, 0,       DSTR(8, 12)),
+	NPCM7XX_PINCFG(18,      pspi2, MFSEL3, 13,	 smb4b, I2CSEGSEL, 14,  none, NONE, 0,	     DSTR(8, 12)),
+	NPCM7XX_PINCFG(19,      pspi2, MFSEL3, 13,	 smb4b, I2CSEGSEL, 14,  none, NONE, 0,	     DSTR(8, 12)),
 	NPCM7XX_PINCFG(20,	smb4c, I2CSEGSEL, 15,    smb15, MFSEL3, 8,      none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(21,	smb4c, I2CSEGSEL, 15,    smb15, MFSEL3, 8,      none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(22,      smb4d, I2CSEGSEL, 16,	 smb14, MFSEL3, 7,      none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(23,      smb4d, I2CSEGSEL, 16,	 smb14, MFSEL3, 7,      none, NONE, 0,	     0),
-	NPCM7XX_PINCFG(24,	 ioxh, MFSEL3, 18,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12)),
-	NPCM7XX_PINCFG(25,	 ioxh, MFSEL3, 18,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12)),
+	NPCM7XX_PINCFG(24,	 ioxh, MFSEL3, 18,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12)),
+	NPCM7XX_PINCFG(25,	 ioxh, MFSEL3, 18,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12)),
 	NPCM7XX_PINCFG(26,	 smb5, MFSEL1, 2,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(27,	 smb5, MFSEL1, 2,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(28,	 smb4, MFSEL1, 1,	  none, NONE, 0,	none, NONE, 0,	     0),
@@ -964,12 +964,12 @@ static const struct npcm7xx_pincfg pincf
 	NPCM7XX_PINCFG(39,	smb3b, I2CSEGSEL, 11,	  none, NONE, 0,	none, NONE, 0,	     SLEW),
 	NPCM7XX_PINCFG(40,	smb3b, I2CSEGSEL, 11,	  none, NONE, 0,	none, NONE, 0,	     SLEW),
 	NPCM7XX_PINCFG(41,  bmcuart0a, MFSEL1, 9,         none, NONE, 0,	none, NONE, 0,	     0),
-	NPCM7XX_PINCFG(42,  bmcuart0a, MFSEL1, 9,         none, NONE, 0,	none, NONE, 0,	     DS(2, 4) | GPO),
+	NPCM7XX_PINCFG(42,  bmcuart0a, MFSEL1, 9,         none, NONE, 0,	none, NONE, 0,	     DSTR(2, 4) | GPO),
 	NPCM7XX_PINCFG(43,      uart1, MFSEL1, 10,	 jtag2, MFSEL4, 0,  bmcuart1, MFSEL3, 24,    0),
 	NPCM7XX_PINCFG(44,      uart1, MFSEL1, 10,	 jtag2, MFSEL4, 0,  bmcuart1, MFSEL3, 24,    0),
 	NPCM7XX_PINCFG(45,      uart1, MFSEL1, 10,	 jtag2, MFSEL4, 0,	none, NONE, 0,	     0),
-	NPCM7XX_PINCFG(46,      uart1, MFSEL1, 10,	 jtag2, MFSEL4, 0,	none, NONE, 0,	     DS(2, 8)),
-	NPCM7XX_PINCFG(47,      uart1, MFSEL1, 10,	 jtag2, MFSEL4, 0,	none, NONE, 0,	     DS(2, 8)),
+	NPCM7XX_PINCFG(46,      uart1, MFSEL1, 10,	 jtag2, MFSEL4, 0,	none, NONE, 0,	     DSTR(2, 8)),
+	NPCM7XX_PINCFG(47,      uart1, MFSEL1, 10,	 jtag2, MFSEL4, 0,	none, NONE, 0,	     DSTR(2, 8)),
 	NPCM7XX_PINCFG(48,	uart2, MFSEL1, 11,   bmcuart0b, MFSEL4, 1,      none, NONE, 0,	     GPO),
 	NPCM7XX_PINCFG(49,	uart2, MFSEL1, 11,   bmcuart0b, MFSEL4, 1,      none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(50,	uart2, MFSEL1, 11,	  none, NONE, 0,        none, NONE, 0,	     0),
@@ -979,8 +979,8 @@ static const struct npcm7xx_pincfg pincf
 	NPCM7XX_PINCFG(54,	uart2, MFSEL1, 11,	  none, NONE, 0,        none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(55,	uart2, MFSEL1, 11,	  none, NONE, 0,        none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(56,	r1err, MFSEL1, 12,	  none, NONE, 0,	none, NONE, 0,	     0),
-	NPCM7XX_PINCFG(57,       r1md, MFSEL1, 13,        none, NONE, 0,        none, NONE, 0,       DS(2, 4)),
-	NPCM7XX_PINCFG(58,       r1md, MFSEL1, 13,        none, NONE, 0,	none, NONE, 0,	     DS(2, 4)),
+	NPCM7XX_PINCFG(57,       r1md, MFSEL1, 13,        none, NONE, 0,        none, NONE, 0,       DSTR(2, 4)),
+	NPCM7XX_PINCFG(58,       r1md, MFSEL1, 13,        none, NONE, 0,	none, NONE, 0,	     DSTR(2, 4)),
 	NPCM7XX_PINCFG(59,	smb3d, I2CSEGSEL, 13,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(60,	smb3d, I2CSEGSEL, 13,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(61,      uart1, MFSEL1, 10,	  none, NONE, 0,	none, NONE, 0,     GPO),
@@ -1003,19 +1003,19 @@ static const struct npcm7xx_pincfg pincf
 	NPCM7XX_PINCFG(77,    fanin13, MFSEL2, 13,        none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(78,    fanin14, MFSEL2, 14,        none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(79,    fanin15, MFSEL2, 15,        none, NONE, 0,	none, NONE, 0,	     0),
-	NPCM7XX_PINCFG(80,	 pwm0, MFSEL2, 16,        none, NONE, 0,	none, NONE, 0,	     DS(4, 8)),
-	NPCM7XX_PINCFG(81,	 pwm1, MFSEL2, 17,        none, NONE, 0,	none, NONE, 0,	     DS(4, 8)),
-	NPCM7XX_PINCFG(82,	 pwm2, MFSEL2, 18,        none, NONE, 0,	none, NONE, 0,	     DS(4, 8)),
-	NPCM7XX_PINCFG(83,	 pwm3, MFSEL2, 19,        none, NONE, 0,	none, NONE, 0,	     DS(4, 8)),
-	NPCM7XX_PINCFG(84,         r2, MFSEL1, 14,        none, NONE, 0,        none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(85,         r2, MFSEL1, 14,        none, NONE, 0,        none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(86,         r2, MFSEL1, 14,        none, NONE, 0,        none, NONE, 0,	     DS(8, 12) | SLEW),
+	NPCM7XX_PINCFG(80,	 pwm0, MFSEL2, 16,        none, NONE, 0,	none, NONE, 0,	     DSTR(4, 8)),
+	NPCM7XX_PINCFG(81,	 pwm1, MFSEL2, 17,        none, NONE, 0,	none, NONE, 0,	     DSTR(4, 8)),
+	NPCM7XX_PINCFG(82,	 pwm2, MFSEL2, 18,        none, NONE, 0,	none, NONE, 0,	     DSTR(4, 8)),
+	NPCM7XX_PINCFG(83,	 pwm3, MFSEL2, 19,        none, NONE, 0,	none, NONE, 0,	     DSTR(4, 8)),
+	NPCM7XX_PINCFG(84,         r2, MFSEL1, 14,        none, NONE, 0,        none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(85,         r2, MFSEL1, 14,        none, NONE, 0,        none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(86,         r2, MFSEL1, 14,        none, NONE, 0,        none, NONE, 0,	     DSTR(8, 12) | SLEW),
 	NPCM7XX_PINCFG(87,         r2, MFSEL1, 14,        none, NONE, 0,        none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(88,         r2, MFSEL1, 14,        none, NONE, 0,        none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(89,         r2, MFSEL1, 14,        none, NONE, 0,        none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(90,      r2err, MFSEL1, 15,        none, NONE, 0,        none, NONE, 0,       0),
-	NPCM7XX_PINCFG(91,       r2md, MFSEL1, 16,	  none, NONE, 0,        none, NONE, 0,	     DS(2, 4)),
-	NPCM7XX_PINCFG(92,       r2md, MFSEL1, 16,	  none, NONE, 0,        none, NONE, 0,	     DS(2, 4)),
+	NPCM7XX_PINCFG(91,       r2md, MFSEL1, 16,	  none, NONE, 0,        none, NONE, 0,	     DSTR(2, 4)),
+	NPCM7XX_PINCFG(92,       r2md, MFSEL1, 16,	  none, NONE, 0,        none, NONE, 0,	     DSTR(2, 4)),
 	NPCM7XX_PINCFG(93,    ga20kbc, MFSEL1, 17,	 smb5d, I2CSEGSEL, 21,  none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(94,    ga20kbc, MFSEL1, 17,	 smb5d, I2CSEGSEL, 21,  none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(95,	  lpc, NONE, 0,		  espi, MFSEL4, 8,      gpio, MFSEL1, 26,    0),
@@ -1061,34 +1061,34 @@ static const struct npcm7xx_pincfg pincf
 	NPCM7XX_PINCFG(133,	smb10, MFSEL4, 13,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(134,	smb11, MFSEL4, 14,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(135,	smb11, MFSEL4, 14,	  none, NONE, 0,	none, NONE, 0,	     0),
-	NPCM7XX_PINCFG(136,	  sd1, MFSEL3, 12,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(137,	  sd1, MFSEL3, 12,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(138,	  sd1, MFSEL3, 12,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(139,	  sd1, MFSEL3, 12,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(140,	  sd1, MFSEL3, 12,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
+	NPCM7XX_PINCFG(136,	  sd1, MFSEL3, 12,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(137,	  sd1, MFSEL3, 12,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(138,	  sd1, MFSEL3, 12,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(139,	  sd1, MFSEL3, 12,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(140,	  sd1, MFSEL3, 12,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
 	NPCM7XX_PINCFG(141,	  sd1, MFSEL3, 12,	  none, NONE, 0,	none, NONE, 0,	     0),
-	NPCM7XX_PINCFG(142,	  sd1, MFSEL3, 12,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
+	NPCM7XX_PINCFG(142,	  sd1, MFSEL3, 12,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
 	NPCM7XX_PINCFG(143,       sd1, MFSEL3, 12,      sd1pwr, MFSEL4, 5,      none, NONE, 0,       0),
-	NPCM7XX_PINCFG(144,	 pwm4, MFSEL2, 20,	  none, NONE, 0,	none, NONE, 0,	     DS(4, 8)),
-	NPCM7XX_PINCFG(145,	 pwm5, MFSEL2, 21,	  none, NONE, 0,	none, NONE, 0,	     DS(4, 8)),
-	NPCM7XX_PINCFG(146,	 pwm6, MFSEL2, 22,	  none, NONE, 0,	none, NONE, 0,	     DS(4, 8)),
-	NPCM7XX_PINCFG(147,	 pwm7, MFSEL2, 23,	  none, NONE, 0,	none, NONE, 0,	     DS(4, 8)),
-	NPCM7XX_PINCFG(148,	 mmc8, MFSEL3, 11,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(149,	 mmc8, MFSEL3, 11,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(150,	 mmc8, MFSEL3, 11,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(151,	 mmc8, MFSEL3, 11,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(152,	  mmc, MFSEL3, 10,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
+	NPCM7XX_PINCFG(144,	 pwm4, MFSEL2, 20,	  none, NONE, 0,	none, NONE, 0,	     DSTR(4, 8)),
+	NPCM7XX_PINCFG(145,	 pwm5, MFSEL2, 21,	  none, NONE, 0,	none, NONE, 0,	     DSTR(4, 8)),
+	NPCM7XX_PINCFG(146,	 pwm6, MFSEL2, 22,	  none, NONE, 0,	none, NONE, 0,	     DSTR(4, 8)),
+	NPCM7XX_PINCFG(147,	 pwm7, MFSEL2, 23,	  none, NONE, 0,	none, NONE, 0,	     DSTR(4, 8)),
+	NPCM7XX_PINCFG(148,	 mmc8, MFSEL3, 11,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(149,	 mmc8, MFSEL3, 11,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(150,	 mmc8, MFSEL3, 11,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(151,	 mmc8, MFSEL3, 11,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(152,	  mmc, MFSEL3, 10,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
 	NPCM7XX_PINCFG(153,     mmcwp, FLOCKR1, 24,       none, NONE, 0,	none, NONE, 0,	     0),  /* Z1/A1 */
-	NPCM7XX_PINCFG(154,	  mmc, MFSEL3, 10,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
+	NPCM7XX_PINCFG(154,	  mmc, MFSEL3, 10,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
 	NPCM7XX_PINCFG(155,     mmccd, MFSEL3, 25,      mmcrst, MFSEL4, 6,      none, NONE, 0,       0),  /* Z1/A1 */
-	NPCM7XX_PINCFG(156,	  mmc, MFSEL3, 10,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(157,	  mmc, MFSEL3, 10,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(158,	  mmc, MFSEL3, 10,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(159,	  mmc, MFSEL3, 10,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-
-	NPCM7XX_PINCFG(160,    clkout, MFSEL1, 21,        none, NONE, 0,        none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(161,	  lpc, NONE, 0,		  espi, MFSEL4, 8,      gpio, MFSEL1, 26,    DS(8, 12)),
-	NPCM7XX_PINCFG(162,    serirq, NONE, 0,           gpio, MFSEL1, 31,	none, NONE, 0,	     DS(8, 12)),
+	NPCM7XX_PINCFG(156,	  mmc, MFSEL3, 10,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(157,	  mmc, MFSEL3, 10,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(158,	  mmc, MFSEL3, 10,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(159,	  mmc, MFSEL3, 10,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+
+	NPCM7XX_PINCFG(160,    clkout, MFSEL1, 21,        none, NONE, 0,        none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(161,	  lpc, NONE, 0,		  espi, MFSEL4, 8,      gpio, MFSEL1, 26,    DSTR(8, 12)),
+	NPCM7XX_PINCFG(162,    serirq, NONE, 0,           gpio, MFSEL1, 31,	none, NONE, 0,	     DSTR(8, 12)),
 	NPCM7XX_PINCFG(163,	  lpc, NONE, 0,		  espi, MFSEL4, 8,      gpio, MFSEL1, 26,    0),
 	NPCM7XX_PINCFG(164,	  lpc, NONE, 0,		  espi, MFSEL4, 8,      gpio, MFSEL1, 26,    SLEWLPC),
 	NPCM7XX_PINCFG(165,	  lpc, NONE, 0,		  espi, MFSEL4, 8,      gpio, MFSEL1, 26,    SLEWLPC),
@@ -1101,25 +1101,25 @@ static const struct npcm7xx_pincfg pincf
 	NPCM7XX_PINCFG(172,	 smb6, MFSEL3, 1,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(173,	 smb7, MFSEL3, 2,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(174,	 smb7, MFSEL3, 2,	  none, NONE, 0,	none, NONE, 0,	     0),
-	NPCM7XX_PINCFG(175,	pspi1, MFSEL3, 4,       faninx, MFSEL3, 3,      none, NONE, 0,	     DS(8, 12)),
-	NPCM7XX_PINCFG(176,     pspi1, MFSEL3, 4,       faninx, MFSEL3, 3,      none, NONE, 0,	     DS(8, 12)),
-	NPCM7XX_PINCFG(177,     pspi1, MFSEL3, 4,       faninx, MFSEL3, 3,      none, NONE, 0,	     DS(8, 12)),
-	NPCM7XX_PINCFG(178,	   r1, MFSEL3, 9,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(179,	   r1, MFSEL3, 9,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(180,	   r1, MFSEL3, 9,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
+	NPCM7XX_PINCFG(175,	pspi1, MFSEL3, 4,       faninx, MFSEL3, 3,      none, NONE, 0,	     DSTR(8, 12)),
+	NPCM7XX_PINCFG(176,     pspi1, MFSEL3, 4,       faninx, MFSEL3, 3,      none, NONE, 0,	     DSTR(8, 12)),
+	NPCM7XX_PINCFG(177,     pspi1, MFSEL3, 4,       faninx, MFSEL3, 3,      none, NONE, 0,	     DSTR(8, 12)),
+	NPCM7XX_PINCFG(178,	   r1, MFSEL3, 9,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(179,	   r1, MFSEL3, 9,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(180,	   r1, MFSEL3, 9,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
 	NPCM7XX_PINCFG(181,	   r1, MFSEL3, 9,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(182,	   r1, MFSEL3, 9,	  none, NONE, 0,	none, NONE, 0,	     0),
-	NPCM7XX_PINCFG(183,     spi3, MFSEL4, 16,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(184,     spi3, MFSEL4, 16,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW | GPO),
-	NPCM7XX_PINCFG(185,     spi3, MFSEL4, 16,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW | GPO),
-	NPCM7XX_PINCFG(186,     spi3, MFSEL4, 16,	  none, NONE, 0,	none, NONE, 0,	     DS(8, 12)),
-	NPCM7XX_PINCFG(187,   spi3cs1, MFSEL4, 17,        none, NONE, 0,	none, NONE, 0,	     DS(8, 12)),
-	NPCM7XX_PINCFG(188,  spi3quad, MFSEL4, 20,     spi3cs2, MFSEL4, 18,     none, NONE, 0,    DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(189,  spi3quad, MFSEL4, 20,     spi3cs3, MFSEL4, 19,     none, NONE, 0,    DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(190,      gpio, FLOCKR1, 20,   nprd_smi, NONE, 0,	none, NONE, 0,	     DS(2, 4)),
-	NPCM7XX_PINCFG(191,	 none, NONE, 0,		  none, NONE, 0,	none, NONE, 0,	     DS(8, 12)),  /* XX */
+	NPCM7XX_PINCFG(183,     spi3, MFSEL4, 16,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(184,     spi3, MFSEL4, 16,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW | GPO),
+	NPCM7XX_PINCFG(185,     spi3, MFSEL4, 16,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW | GPO),
+	NPCM7XX_PINCFG(186,     spi3, MFSEL4, 16,	  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12)),
+	NPCM7XX_PINCFG(187,   spi3cs1, MFSEL4, 17,        none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12)),
+	NPCM7XX_PINCFG(188,  spi3quad, MFSEL4, 20,     spi3cs2, MFSEL4, 18,     none, NONE, 0,    DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(189,  spi3quad, MFSEL4, 20,     spi3cs3, MFSEL4, 19,     none, NONE, 0,    DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(190,      gpio, FLOCKR1, 20,   nprd_smi, NONE, 0,	none, NONE, 0,	     DSTR(2, 4)),
+	NPCM7XX_PINCFG(191,	 none, NONE, 0,		  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12)),  /* XX */
 
-	NPCM7XX_PINCFG(192,	 none, NONE, 0,		  none, NONE, 0,	none, NONE, 0,	     DS(8, 12)),  /* XX */
+	NPCM7XX_PINCFG(192,	 none, NONE, 0,		  none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12)),  /* XX */
 	NPCM7XX_PINCFG(193,	   r1, MFSEL3, 9,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(194,	smb0b, I2CSEGSEL, 0,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(195,	smb0b, I2CSEGSEL, 0,	  none, NONE, 0,	none, NONE, 0,	     0),
@@ -1130,11 +1130,11 @@ static const struct npcm7xx_pincfg pincf
 	NPCM7XX_PINCFG(200,        r2, MFSEL1, 14,        none, NONE, 0,        none, NONE, 0,       0),
 	NPCM7XX_PINCFG(201,	   r1, MFSEL3, 9,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(202,	smb0c, I2CSEGSEL, 1,	  none, NONE, 0,	none, NONE, 0,	     0),
-	NPCM7XX_PINCFG(203,    faninx, MFSEL3, 3,         none, NONE, 0,	none, NONE, 0,	     DS(8, 12)),
+	NPCM7XX_PINCFG(203,    faninx, MFSEL3, 3,         none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12)),
 	NPCM7XX_PINCFG(204,	  ddc, NONE, 0,           gpio, MFSEL3, 22,	none, NONE, 0,	     SLEW),
 	NPCM7XX_PINCFG(205,	  ddc, NONE, 0,           gpio, MFSEL3, 22,	none, NONE, 0,	     SLEW),
-	NPCM7XX_PINCFG(206,	  ddc, NONE, 0,           gpio, MFSEL3, 22,	none, NONE, 0,	     DS(4, 8)),
-	NPCM7XX_PINCFG(207,	  ddc, NONE, 0,           gpio, MFSEL3, 22,	none, NONE, 0,	     DS(4, 8)),
+	NPCM7XX_PINCFG(206,	  ddc, NONE, 0,           gpio, MFSEL3, 22,	none, NONE, 0,	     DSTR(4, 8)),
+	NPCM7XX_PINCFG(207,	  ddc, NONE, 0,           gpio, MFSEL3, 22,	none, NONE, 0,	     DSTR(4, 8)),
 	NPCM7XX_PINCFG(208,       rg2, MFSEL4, 24,         ddr, MFSEL3, 26,     none, NONE, 0,       0),
 	NPCM7XX_PINCFG(209,       rg2, MFSEL4, 24,         ddr, MFSEL3, 26,     none, NONE, 0,       0),
 	NPCM7XX_PINCFG(210,       rg2, MFSEL4, 24,         ddr, MFSEL3, 26,     none, NONE, 0,       0),
@@ -1146,20 +1146,20 @@ static const struct npcm7xx_pincfg pincf
 	NPCM7XX_PINCFG(216,   rg2mdio, MFSEL4, 23,         ddr, MFSEL3, 26,     none, NONE, 0,       0),
 	NPCM7XX_PINCFG(217,   rg2mdio, MFSEL4, 23,         ddr, MFSEL3, 26,     none, NONE, 0,       0),
 	NPCM7XX_PINCFG(218,     wdog1, MFSEL3, 19,        none, NONE, 0,	none, NONE, 0,	     0),
-	NPCM7XX_PINCFG(219,     wdog2, MFSEL3, 20,        none, NONE, 0,	none, NONE, 0,	     DS(4, 8)),
+	NPCM7XX_PINCFG(219,     wdog2, MFSEL3, 20,        none, NONE, 0,	none, NONE, 0,	     DSTR(4, 8)),
 	NPCM7XX_PINCFG(220,	smb12, MFSEL3, 5,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(221,	smb12, MFSEL3, 5,	  none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(222,     smb13, MFSEL3, 6,         none, NONE, 0,	none, NONE, 0,	     0),
 	NPCM7XX_PINCFG(223,     smb13, MFSEL3, 6,         none, NONE, 0,	none, NONE, 0,	     0),
 
 	NPCM7XX_PINCFG(224,	 spix, MFSEL4, 27,        none, NONE, 0,	none, NONE, 0,	     SLEW),
-	NPCM7XX_PINCFG(225,	 spix, MFSEL4, 27,        none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW | GPO),
-	NPCM7XX_PINCFG(226,	 spix, MFSEL4, 27,        none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW | GPO),
-	NPCM7XX_PINCFG(227,	 spix, MFSEL4, 27,        none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(228,   spixcs1, MFSEL4, 28,        none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(229,	 spix, MFSEL4, 27,        none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(230,	 spix, MFSEL4, 27,        none, NONE, 0,	none, NONE, 0,	     DS(8, 12) | SLEW),
-	NPCM7XX_PINCFG(231,    clkreq, MFSEL4, 9,         none, NONE, 0,        none, NONE, 0,	     DS(8, 12)),
+	NPCM7XX_PINCFG(225,	 spix, MFSEL4, 27,        none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW | GPO),
+	NPCM7XX_PINCFG(226,	 spix, MFSEL4, 27,        none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW | GPO),
+	NPCM7XX_PINCFG(227,	 spix, MFSEL4, 27,        none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(228,   spixcs1, MFSEL4, 28,        none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(229,	 spix, MFSEL4, 27,        none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(230,	 spix, MFSEL4, 27,        none, NONE, 0,	none, NONE, 0,	     DSTR(8, 12) | SLEW),
+	NPCM7XX_PINCFG(231,    clkreq, MFSEL4, 9,         none, NONE, 0,        none, NONE, 0,	     DSTR(8, 12)),
 	NPCM7XX_PINCFG(253,	 none, NONE, 0,		  none, NONE, 0,	none, NONE, 0,	     GPI), /* SDHC1 power */
 	NPCM7XX_PINCFG(254,	 none, NONE, 0,		  none, NONE, 0,	none, NONE, 0,	     GPI), /* SDHC2 power */
 	NPCM7XX_PINCFG(255,	 none, NONE, 0,		  none, NONE, 0,	none, NONE, 0,	     GPI), /* DACOSEL */


