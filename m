Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBB04357B7
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhJUA2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232608AbhJUA0l (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:26:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07044613A1;
        Thu, 21 Oct 2021 00:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775866;
        bh=IC7UlV2w1e4Ip96/SdkIQOlu48Mr5j18fgcS+51QB6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMB7RYOMiaNaE2k42a5lR+zA6OuL4FkwiWud4oSt5QrQ0oo6CosxqGUwm2SI1Ma8+
         ARXSkCbuhF72/tVMwo1RLiX+iPfSGi7N4s7967hsNpRquNb9W1EExj5nWGCY/atyKF
         mcS8eWAxEfcDcemqeachJxMuzKXclsBEDYSpdRk4cJQCEZ247IM1U7BwgbKVE0FBQH
         mkY5ArfFwtjwhjr7orFm5Q4I97ITIJ6UlTF4psMeKqIp+4/nfMj6REcAkHivD/xyEA
         Vtdqv7xkrdGL64+i/o14vK4XvsL+softhpKMJWVlWZqWuNMqNyo3uIBcxdpiw5s3ov
         U86ua03MlnFVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Cullen <michael@michaelcullen.name>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, mattreynolds@chromium.org,
        lzye@google.com, hcutts@chromium.org, lee.jones@linaro.org,
        olivier.crete@ocrete.ca, sanjay.govind9@gmail.com,
        benpicco@googlemail.com, andrzej.p@collabora.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 7/7] Input: xpad - add support for another USB ID of Nacon GC-100
Date:   Wed, 20 Oct 2021 20:24:03 -0400
Message-Id: <20211021002404.1129946-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002404.1129946-1-sashal@kernel.org>
References: <20211021002404.1129946-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Cullen <michael@michaelcullen.name>

[ Upstream commit 3378a07daa6cdd11e042797454c706d1c69f9ca6 ]

The Nacon GX100XF is already mapped, but it seems there is a Nacon
GC-100 (identified as NC5136Wht PCGC-100WHITE though I believe other
colours exist) with a different USB ID when in XInput mode.

Signed-off-by: Michael Cullen <michael@michaelcullen.name>
Link: https://lore.kernel.org/r/20211015192051.5196-1-michael@michaelcullen.name
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 4168ed0ef187..f8f6bd92e314 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -348,6 +348,7 @@ static const struct xpad_device {
 	{ 0x24c6, 0x5b03, "Thrustmaster Ferrari 458 Racing Wheel", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5d04, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0xfafe, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
+	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0000, 0x0000, "Generic X-Box pad", 0, XTYPE_UNKNOWN }
@@ -464,6 +465,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOXONE_VENDOR(0x24c6),		/* PowerA Controllers */
 	XPAD_XBOXONE_VENDOR(0x2e24),		/* Hyperkin Duke X-Box One pad */
 	XPAD_XBOX360_VENDOR(0x2f24),		/* GameSir Controllers */
+	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
 	{ }
 };
 
-- 
2.33.0

