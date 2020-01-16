Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B4813FEDB
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391253AbgAPX3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:29:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387406AbgAPX3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:29:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A52E2072B;
        Thu, 16 Jan 2020 23:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217357;
        bh=kgF3Lq3jCupg2pyPZ+BwTCt0+02SSNL0yl3Lg0awJAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeMfpI2icL6Gs4ulkY7oKgugUthT83JgHYWEC0K0Co5Q3cuzVTHr0Fk4VdJ8rxrLL
         lQXRvAjzwvpz0eN3qGlBWfpIsNey7HUHxrLRlutMLdxRHPBC24nb915TE1PFnlydDZ
         46JIFebm/osCItjt/3eiaS9MMDJehFEjeMlTPGzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 49/84] pinctrl: lewisburg: Update pin list according to v1.1v6
Date:   Fri, 17 Jan 2020 00:18:23 +0100
Message-Id: <20200116231719.574549679@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e66ff71fd0dba36a53f91f39e4da6c7b84764f2e upstream.

Version 1.1v6 of pin list has some changes in pin names for Intel Lewisburg.

Update the driver accordingly.

Note, it reveals the bug in the driver that misses two pins in GPP_L and
has rather two extra ones. That's why the ordering of some groups is changed.

Fixes: e480b745386e ("pinctrl: intel: Add Intel Lewisburg GPIO support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20191120133739.54332-1-andriy.shevchenko@linux.intel.com
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/intel/pinctrl-lewisburg.c |  171 +++++++++++++++---------------
 1 file changed, 86 insertions(+), 85 deletions(-)

--- a/drivers/pinctrl/intel/pinctrl-lewisburg.c
+++ b/drivers/pinctrl/intel/pinctrl-lewisburg.c
@@ -31,6 +31,7 @@
 		.npins = ((e) - (s) + 1),		\
 	}
 
+/* Lewisburg */
 static const struct pinctrl_pin_desc lbg_pins[] = {
 	/* GPP_A */
 	PINCTRL_PIN(0, "RCINB"),
@@ -70,7 +71,7 @@ static const struct pinctrl_pin_desc lbg
 	PINCTRL_PIN(33, "SRCCLKREQB_4"),
 	PINCTRL_PIN(34, "SRCCLKREQB_5"),
 	PINCTRL_PIN(35, "GPP_B_11"),
-	PINCTRL_PIN(36, "GLB_RST_WARN_N"),
+	PINCTRL_PIN(36, "SLP_S0B"),
 	PINCTRL_PIN(37, "PLTRSTB"),
 	PINCTRL_PIN(38, "SPKR"),
 	PINCTRL_PIN(39, "GPP_B_15"),
@@ -183,96 +184,96 @@ static const struct pinctrl_pin_desc lbg
 	PINCTRL_PIN(141, "GBE_PCI_DIS"),
 	PINCTRL_PIN(142, "GBE_LAN_DIS"),
 	PINCTRL_PIN(143, "GPP_I_10"),
-	PINCTRL_PIN(144, "GPIO_RCOMP_3P3"),
 	/* GPP_J */
-	PINCTRL_PIN(145, "GBE_LED_0_0"),
-	PINCTRL_PIN(146, "GBE_LED_0_1"),
-	PINCTRL_PIN(147, "GBE_LED_1_0"),
-	PINCTRL_PIN(148, "GBE_LED_1_1"),
-	PINCTRL_PIN(149, "GBE_LED_2_0"),
-	PINCTRL_PIN(150, "GBE_LED_2_1"),
-	PINCTRL_PIN(151, "GBE_LED_3_0"),
-	PINCTRL_PIN(152, "GBE_LED_3_1"),
-	PINCTRL_PIN(153, "GBE_SCL_0"),
-	PINCTRL_PIN(154, "GBE_SDA_0"),
-	PINCTRL_PIN(155, "GBE_SCL_1"),
-	PINCTRL_PIN(156, "GBE_SDA_1"),
-	PINCTRL_PIN(157, "GBE_SCL_2"),
-	PINCTRL_PIN(158, "GBE_SDA_2"),
-	PINCTRL_PIN(159, "GBE_SCL_3"),
-	PINCTRL_PIN(160, "GBE_SDA_3"),
-	PINCTRL_PIN(161, "GBE_SDP_0_0"),
-	PINCTRL_PIN(162, "GBE_SDP_0_1"),
-	PINCTRL_PIN(163, "GBE_SDP_1_0"),
-	PINCTRL_PIN(164, "GBE_SDP_1_1"),
-	PINCTRL_PIN(165, "GBE_SDP_2_0"),
-	PINCTRL_PIN(166, "GBE_SDP_2_1"),
-	PINCTRL_PIN(167, "GBE_SDP_3_0"),
-	PINCTRL_PIN(168, "GBE_SDP_3_1"),
+	PINCTRL_PIN(144, "GBE_LED_0_0"),
+	PINCTRL_PIN(145, "GBE_LED_0_1"),
+	PINCTRL_PIN(146, "GBE_LED_1_0"),
+	PINCTRL_PIN(147, "GBE_LED_1_1"),
+	PINCTRL_PIN(148, "GBE_LED_2_0"),
+	PINCTRL_PIN(149, "GBE_LED_2_1"),
+	PINCTRL_PIN(150, "GBE_LED_3_0"),
+	PINCTRL_PIN(151, "GBE_LED_3_1"),
+	PINCTRL_PIN(152, "GBE_SCL_0"),
+	PINCTRL_PIN(153, "GBE_SDA_0"),
+	PINCTRL_PIN(154, "GBE_SCL_1"),
+	PINCTRL_PIN(155, "GBE_SDA_1"),
+	PINCTRL_PIN(156, "GBE_SCL_2"),
+	PINCTRL_PIN(157, "GBE_SDA_2"),
+	PINCTRL_PIN(158, "GBE_SCL_3"),
+	PINCTRL_PIN(159, "GBE_SDA_3"),
+	PINCTRL_PIN(160, "GBE_SDP_0_0"),
+	PINCTRL_PIN(161, "GBE_SDP_0_1"),
+	PINCTRL_PIN(162, "GBE_SDP_1_0"),
+	PINCTRL_PIN(163, "GBE_SDP_1_1"),
+	PINCTRL_PIN(164, "GBE_SDP_2_0"),
+	PINCTRL_PIN(165, "GBE_SDP_2_1"),
+	PINCTRL_PIN(166, "GBE_SDP_3_0"),
+	PINCTRL_PIN(167, "GBE_SDP_3_1"),
 	/* GPP_K */
-	PINCTRL_PIN(169, "GBE_RMIICLK"),
-	PINCTRL_PIN(170, "GBE_RMII_TXD_0"),
-	PINCTRL_PIN(171, "GBE_RMII_TXD_1"),
+	PINCTRL_PIN(168, "GBE_RMIICLK"),
+	PINCTRL_PIN(169, "GBE_RMII_RXD_0"),
+	PINCTRL_PIN(170, "GBE_RMII_RXD_1"),
+	PINCTRL_PIN(171, "GBE_RMII_CRS_DV"),
 	PINCTRL_PIN(172, "GBE_RMII_TX_EN"),
-	PINCTRL_PIN(173, "GBE_RMII_CRS_DV"),
-	PINCTRL_PIN(174, "GBE_RMII_RXD_0"),
-	PINCTRL_PIN(175, "GBE_RMII_RXD_1"),
-	PINCTRL_PIN(176, "GBE_RMII_RX_ER"),
-	PINCTRL_PIN(177, "GBE_RMII_ARBIN"),
-	PINCTRL_PIN(178, "GBE_RMII_ARB_OUT"),
-	PINCTRL_PIN(179, "PE_RST_N"),
-	PINCTRL_PIN(180, "GPIO_RCOMP_1P8_3P3"),
+	PINCTRL_PIN(173, "GBE_RMII_TXD_0"),
+	PINCTRL_PIN(174, "GBE_RMII_TXD_1"),
+	PINCTRL_PIN(175, "GBE_RMII_RX_ER"),
+	PINCTRL_PIN(176, "GBE_RMII_ARBIN"),
+	PINCTRL_PIN(177, "GBE_RMII_ARB_OUT"),
+	PINCTRL_PIN(178, "PE_RST_N"),
 	/* GPP_G */
-	PINCTRL_PIN(181, "FAN_TACH_0"),
-	PINCTRL_PIN(182, "FAN_TACH_1"),
-	PINCTRL_PIN(183, "FAN_TACH_2"),
-	PINCTRL_PIN(184, "FAN_TACH_3"),
-	PINCTRL_PIN(185, "FAN_TACH_4"),
-	PINCTRL_PIN(186, "FAN_TACH_5"),
-	PINCTRL_PIN(187, "FAN_TACH_6"),
-	PINCTRL_PIN(188, "FAN_TACH_7"),
-	PINCTRL_PIN(189, "FAN_PWM_0"),
-	PINCTRL_PIN(190, "FAN_PWM_1"),
-	PINCTRL_PIN(191, "FAN_PWM_2"),
-	PINCTRL_PIN(192, "FAN_PWM_3"),
-	PINCTRL_PIN(193, "GSXDOUT"),
-	PINCTRL_PIN(194, "GSXSLOAD"),
-	PINCTRL_PIN(195, "GSXDIN"),
-	PINCTRL_PIN(196, "GSXSRESETB"),
-	PINCTRL_PIN(197, "GSXCLK"),
-	PINCTRL_PIN(198, "ADR_COMPLETE"),
-	PINCTRL_PIN(199, "NMIB"),
-	PINCTRL_PIN(200, "SMIB"),
-	PINCTRL_PIN(201, "SSATA_DEVSLP_0"),
-	PINCTRL_PIN(202, "SSATA_DEVSLP_1"),
-	PINCTRL_PIN(203, "SSATA_DEVSLP_2"),
-	PINCTRL_PIN(204, "SSATAXPCIE0_SSATAGP0"),
+	PINCTRL_PIN(179, "FAN_TACH_0"),
+	PINCTRL_PIN(180, "FAN_TACH_1"),
+	PINCTRL_PIN(181, "FAN_TACH_2"),
+	PINCTRL_PIN(182, "FAN_TACH_3"),
+	PINCTRL_PIN(183, "FAN_TACH_4"),
+	PINCTRL_PIN(184, "FAN_TACH_5"),
+	PINCTRL_PIN(185, "FAN_TACH_6"),
+	PINCTRL_PIN(186, "FAN_TACH_7"),
+	PINCTRL_PIN(187, "FAN_PWM_0"),
+	PINCTRL_PIN(188, "FAN_PWM_1"),
+	PINCTRL_PIN(189, "FAN_PWM_2"),
+	PINCTRL_PIN(190, "FAN_PWM_3"),
+	PINCTRL_PIN(191, "GSXDOUT"),
+	PINCTRL_PIN(192, "GSXSLOAD"),
+	PINCTRL_PIN(193, "GSXDIN"),
+	PINCTRL_PIN(194, "GSXSRESETB"),
+	PINCTRL_PIN(195, "GSXCLK"),
+	PINCTRL_PIN(196, "ADR_COMPLETE"),
+	PINCTRL_PIN(197, "NMIB"),
+	PINCTRL_PIN(198, "SMIB"),
+	PINCTRL_PIN(199, "SSATA_DEVSLP_0"),
+	PINCTRL_PIN(200, "SSATA_DEVSLP_1"),
+	PINCTRL_PIN(201, "SSATA_DEVSLP_2"),
+	PINCTRL_PIN(202, "SSATAXPCIE0_SSATAGP0"),
 	/* GPP_H */
-	PINCTRL_PIN(205, "SRCCLKREQB_6"),
-	PINCTRL_PIN(206, "SRCCLKREQB_7"),
-	PINCTRL_PIN(207, "SRCCLKREQB_8"),
-	PINCTRL_PIN(208, "SRCCLKREQB_9"),
-	PINCTRL_PIN(209, "SRCCLKREQB_10"),
-	PINCTRL_PIN(210, "SRCCLKREQB_11"),
-	PINCTRL_PIN(211, "SRCCLKREQB_12"),
-	PINCTRL_PIN(212, "SRCCLKREQB_13"),
-	PINCTRL_PIN(213, "SRCCLKREQB_14"),
-	PINCTRL_PIN(214, "SRCCLKREQB_15"),
-	PINCTRL_PIN(215, "SML2CLK"),
-	PINCTRL_PIN(216, "SML2DATA"),
-	PINCTRL_PIN(217, "SML2ALERTB"),
-	PINCTRL_PIN(218, "SML3CLK"),
-	PINCTRL_PIN(219, "SML3DATA"),
-	PINCTRL_PIN(220, "SML3ALERTB"),
-	PINCTRL_PIN(221, "SML4CLK"),
-	PINCTRL_PIN(222, "SML4DATA"),
-	PINCTRL_PIN(223, "SML4ALERTB"),
-	PINCTRL_PIN(224, "SSATAXPCIE1_SSATAGP1"),
-	PINCTRL_PIN(225, "SSATAXPCIE2_SSATAGP2"),
-	PINCTRL_PIN(226, "SSATAXPCIE3_SSATAGP3"),
-	PINCTRL_PIN(227, "SSATAXPCIE4_SSATAGP4"),
-	PINCTRL_PIN(228, "SSATAXPCIE5_SSATAGP5"),
+	PINCTRL_PIN(203, "SRCCLKREQB_6"),
+	PINCTRL_PIN(204, "SRCCLKREQB_7"),
+	PINCTRL_PIN(205, "SRCCLKREQB_8"),
+	PINCTRL_PIN(206, "SRCCLKREQB_9"),
+	PINCTRL_PIN(207, "SRCCLKREQB_10"),
+	PINCTRL_PIN(208, "SRCCLKREQB_11"),
+	PINCTRL_PIN(209, "SRCCLKREQB_12"),
+	PINCTRL_PIN(210, "SRCCLKREQB_13"),
+	PINCTRL_PIN(211, "SRCCLKREQB_14"),
+	PINCTRL_PIN(212, "SRCCLKREQB_15"),
+	PINCTRL_PIN(213, "SML2CLK"),
+	PINCTRL_PIN(214, "SML2DATA"),
+	PINCTRL_PIN(215, "SML2ALERTB"),
+	PINCTRL_PIN(216, "SML3CLK"),
+	PINCTRL_PIN(217, "SML3DATA"),
+	PINCTRL_PIN(218, "SML3ALERTB"),
+	PINCTRL_PIN(219, "SML4CLK"),
+	PINCTRL_PIN(220, "SML4DATA"),
+	PINCTRL_PIN(221, "SML4ALERTB"),
+	PINCTRL_PIN(222, "SSATAXPCIE1_SSATAGP1"),
+	PINCTRL_PIN(223, "SSATAXPCIE2_SSATAGP2"),
+	PINCTRL_PIN(224, "SSATAXPCIE3_SSATAGP3"),
+	PINCTRL_PIN(225, "SSATAXPCIE4_SSATAGP4"),
+	PINCTRL_PIN(226, "SSATAXPCIE5_SSATAGP5"),
 	/* GPP_L */
+	PINCTRL_PIN(227, "GPP_L_0"),
+	PINCTRL_PIN(228, "EC_CSME_INTR_OUT"),
 	PINCTRL_PIN(229, "VISA2CH0_D0"),
 	PINCTRL_PIN(230, "VISA2CH0_D1"),
 	PINCTRL_PIN(231, "VISA2CH0_D2"),


