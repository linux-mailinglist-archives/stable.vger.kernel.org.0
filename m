Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631635987B8
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 17:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343833AbiHRPo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 11:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343738AbiHRPoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 11:44:23 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953E898A72;
        Thu, 18 Aug 2022 08:44:21 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id y13so3932101ejp.13;
        Thu, 18 Aug 2022 08:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Ec3feK6zKsC+98ovkMATqjfc9Z/8JYfrz7WWBe9hbu0=;
        b=n1L41zYEotNz+sRGLeQHeg0o4rLhip/SSEh8KtQLtgj6dKL4Io0jXGLDn4lpUo8pnA
         ZeWuoyhBX5NuCVJ7jhGxZS7P3Ij2OxCAvS4te5Oo8wvX0TwYtu6QraE1LL/5lbrJi5qR
         UAvfIznRBpwbr0h+tVaMWfO5OhwBKeeWqLw610pjzCV/J0Kx86oDNGkDmOJMarhenfem
         9iIwQ5afmIK8sxdokaypNM6d2GtQUkueaxq07cges7dJz9mbqjjaGrCLbySIX4xjEmy8
         D9OR1x5mEQPihesnD/0wHCufDL0SS+agooQXhEBSAVL75iJ9EqwddmKsSbO+CHILQ29M
         KkEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Ec3feK6zKsC+98ovkMATqjfc9Z/8JYfrz7WWBe9hbu0=;
        b=iBBl4S7/glIQa+ZTJmTSY7b/KG59XqBQXzyfk38tzORkTYya4dEEgcFd8BnNm6DM3V
         +txenW7tCXR3Qume4CfN6T9RAILeIXb7pYqiS4f09uUCPRwuSrr9IEgSxXesXwSXje8O
         RR/o7OhyFEzE5EQMGkKuf4lI94t9TIKm5IC4/ejfHhoE+1iwS9xcwcI9Q23rmrIqhAqq
         DsSZzVJSQ8NiRGkim+p7MdBbEuiXgDhsUYSwkhBqubAZj9aVceamkH2OuKbfi2uraj6n
         mn5f40wy5+wV+7A/3+T2GgvSvmv5hUO7ASzc76opjkYcgLxWzfdTzNuqGYzaaBHiTqsO
         2cHQ==
X-Gm-Message-State: ACgBeo14a8wwld9akek+U7wDtNAAJeWnlmN7coSVnepDnuf8FkoBEJj7
        xtftd5xGhkqzsyODsP8W5ZCYwoZuechOMw==
X-Google-Smtp-Source: AA6agR7bv9A5h1FXBZGLz9hoeqqDOqBD00nwlatN4sVaPOMCBXCMWy9JRGmrXAUB3/EMMBP03jGwmg==
X-Received: by 2002:a17:907:2848:b0:730:cab8:3ce5 with SMTP id el8-20020a170907284800b00730cab83ce5mr2224448ejc.718.1660837459629;
        Thu, 18 Aug 2022 08:44:19 -0700 (PDT)
Received: from deepwhite.fritz.box ([2001:9e8:220d:e00:f78b:3e64:f8af:69ef])
        by smtp.gmail.com with ESMTPSA id v1-20020a170906292100b0073a62f3b447sm997486ejd.44.2022.08.18.08.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 08:44:19 -0700 (PDT)
From:   Pavel Rojtberg <rojtberg@gmail.com>
X-Google-Original-From: Pavel Rojtberg < rojtberg@gmail.com >
To:     linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        gregkh@linuxfoundation.org
Cc:     Pavel Rojtberg <rojtberg@gmail.com>, stable@vger.kernel.org,
        Jasper Poppe <jgpoppe@gmail.com>,
        Jeremy Palmer <jpalmer@linz.govt.nz>,
        Ruineka <ruinairas1992@gmail.com>,
        Cleber de Mattos Casali <clebercasali@gmail.com>,
        Kyle Gospodnetich <me@kylegospodneti.ch>
Subject: [PATCH v2 1/4] Input: xpad - add supported devices as contributed on github
Date:   Thu, 18 Aug 2022 17:44:08 +0200
Message-Id: <20220818154411.510308-2-rojtberg@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818154411.510308-1-rojtberg@gmail.com>
References: <20220818154411.510308-1-rojtberg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Rojtberg <rojtberg@gmail.com>

This is based on multiple commits at https://github.com/paroj/xpad

Cc: stable@vger.kernel.org
Signed-off-by: Jasper Poppe <jgpoppe@gmail.com>
Signed-off-by: Jeremy Palmer <jpalmer@linz.govt.nz>
Signed-off-by: Ruineka <ruinairas1992@gmail.com>
Signed-off-by: Cleber de Mattos Casali <clebercasali@gmail.com>
Signed-off-by: Kyle Gospodnetich <me@kylegospodneti.ch>
Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
---
 drivers/input/joystick/xpad.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 53126d9..629646b 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -113,6 +113,8 @@ static const struct xpad_device {
 	u8 xtype;
 } xpad_device[] = {
 	{ 0x0079, 0x18d4, "GPD Win 2 X-Box Controller", 0, XTYPE_XBOX360 },
+	{ 0x03eb, 0xff01, "Wooting One (Legacy)", 0, XTYPE_XBOX360 },
+	{ 0x03eb, 0xff02, "Wooting Two (Legacy)", 0, XTYPE_XBOX360 },
 	{ 0x044f, 0x0f00, "Thrustmaster Wheel", 0, XTYPE_XBOX },
 	{ 0x044f, 0x0f03, "Thrustmaster Wheel", 0, XTYPE_XBOX },
 	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", 0, XTYPE_XBOX },
@@ -244,6 +246,7 @@ static const struct xpad_device {
 	{ 0x0f0d, 0x0063, "Hori Real Arcade Pro Hayabusa (USA) Xbox One", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x0f0d, 0x0067, "HORIPAD ONE", 0, XTYPE_XBOXONE },
 	{ 0x0f0d, 0x0078, "Hori Real Arcade Pro V Kai Xbox One", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
+	{ 0x0f0d, 0x00c5, "Hori Fighting Commander ONE", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x0f30, 0x010b, "Philips Recoil", 0, XTYPE_XBOX },
 	{ 0x0f30, 0x0202, "Joytech Advanced Controller", 0, XTYPE_XBOX },
 	{ 0x0f30, 0x8888, "BigBen XBMiniPad Controller", 0, XTYPE_XBOX },
@@ -260,6 +263,7 @@ static const struct xpad_device {
 	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x1430, 0xf801, "RedOctane Controller", 0, XTYPE_XBOX360 },
 	{ 0x146b, 0x0601, "BigBen Interactive XBOX 360 Controller", 0, XTYPE_XBOX360 },
+	{ 0x146b, 0x0604, "Bigben Interactive DAIJA Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1532, 0x0037, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x1532, 0x0a00, "Razer Atrox Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x1532, 0x0a03, "Razer Wildcat", 0, XTYPE_XBOXONE },
@@ -325,6 +329,7 @@ static const struct xpad_device {
 	{ 0x24c6, 0x5502, "Hori Fighting Stick VX Alt", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5503, "Hori Fighting Edge", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5506, "Hori SOULCALIBUR V Stick", 0, XTYPE_XBOX360 },
+	{ 0x24c6, 0x5510, "Hori Fighting Commander ONE (Xbox 360/PC Mode)", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x24c6, 0x550d, "Hori GEM Xbox controller", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0x550e, "Hori Real Arcade Pro V Kai 360", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x24c6, 0x551a, "PowerA FUSION Pro Controller", 0, XTYPE_XBOXONE },
@@ -334,6 +339,14 @@ static const struct xpad_device {
 	{ 0x24c6, 0x5b03, "Thrustmaster Ferrari 458 Racing Wheel", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5d04, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0xfafe, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
+	{ 0x2563, 0x058d, "OneXPlayer Gamepad", 0, XTYPE_XBOX360 },
+	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
+	{ 0x31e3, 0x1100, "Wooting One", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1200, "Wooting Two", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1210, "Wooting Lekker", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1220, "Wooting Two HE", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1300, "Wooting 60HE (AVR)", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
@@ -419,6 +432,7 @@ static const signed short xpad_abs_triggers[] = {
 static const struct usb_device_id xpad_table[] = {
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
 	XPAD_XBOX360_VENDOR(0x0079),		/* GPD Win 2 Controller */
+	XPAD_XBOX360_VENDOR(0x03eb),		/* Wooting Keyboards (Legacy) */
 	XPAD_XBOX360_VENDOR(0x044f),		/* Thrustmaster X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x045e),		/* Microsoft X-Box One controllers */
@@ -429,6 +443,7 @@ static const struct usb_device_id xpad_table[] = {
 	{ USB_DEVICE(0x0738, 0x4540) },		/* Mad Catz Beat Pad */
 	XPAD_XBOXONE_VENDOR(0x0738),		/* Mad Catz FightStick TE 2 */
 	XPAD_XBOX360_VENDOR(0x07ff),		/* Mad Catz GamePad */
+	XPAD_XBOX360_VENDOR(0x0c12),		/* Zeroplus X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x0e6f),		/* 0x0e6f X-Box 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x0e6f),		/* 0x0e6f X-Box One controllers */
 	XPAD_XBOX360_VENDOR(0x0f0d),		/* Hori Controllers */
@@ -450,8 +465,12 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOXONE_VENDOR(0x20d6),		/* PowerA Controllers */
 	XPAD_XBOX360_VENDOR(0x24c6),		/* PowerA Controllers */
 	XPAD_XBOXONE_VENDOR(0x24c6),		/* PowerA Controllers */
+	XPAD_XBOX360_VENDOR(0x2563),		/* OneXPlayer Gamepad */
+	XPAD_XBOX360_VENDOR(0x260d),		/* Dareu H101 */
+	XPAD_XBOXONE_VENDOR(0x2dc8),		/* 8BitDo Pro 2 Wired Controller for Xbox */
 	XPAD_XBOXONE_VENDOR(0x2e24),		/* Hyperkin Duke X-Box One pad */
 	XPAD_XBOX360_VENDOR(0x2f24),		/* GameSir Controllers */
+	XPAD_XBOX360_VENDOR(0x31e3),		/* Wooting Keyboards */
 	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
 	{ }
 };
-- 
2.34.1

