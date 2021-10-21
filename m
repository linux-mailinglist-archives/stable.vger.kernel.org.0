Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989C543571A
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhJUAY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:24:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231801AbhJUAYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 942916138B;
        Thu, 21 Oct 2021 00:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775713;
        bh=Y+yqv2JvzxbbdN9YDSDJ3LpkmTzZ7TQTvrIdeg/uV/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUim4BzklRylouVcxtFOcKrCMclw6qeYe3ryghvFYKaZ0FM2eMeysdH6GTgmw8+PL
         TKVJ7D0ZD9sVVFX12KPBChszsz/GzztGMiOqtO/O3OngoHM/A3hknyC51Z+QrvljCy
         z74O02V91jhRiyN4IePE3JxXtVlGqDk6KG6M2SBe9BdinSv2BnNd0yi39c8GryTlR8
         BKa76fSluq6enobubfe+sSdA6k92XyhN6FjXMoe6MyCacjlHXaKi5PkBREGsxUv+Ud
         yUwPpfxIjLOYJ/EZqczLZt7x6TxVJe9uWOmSaeqyaFIXkuqXIx0R00pIQf81OCyoSf
         jLcSi59N8w/9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Cullen <michael@michaelcullen.name>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, lee.jones@linaro.org,
        sanjay.govind9@gmail.com, mattreynolds@chromium.org,
        benpicco@googlemail.com, olivier.crete@ocrete.ca, lzye@google.com,
        andrzej.p@collabora.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 26/26] Input: xpad - add support for another USB ID of Nacon GC-100
Date:   Wed, 20 Oct 2021 20:20:23 -0400
Message-Id: <20211021002023.1128949-26-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
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
index 29de8412e416..4c914f75a902 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -334,6 +334,7 @@ static const struct xpad_device {
 	{ 0x24c6, 0x5b03, "Thrustmaster Ferrari 458 Racing Wheel", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5d04, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0xfafe, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
+	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0000, 0x0000, "Generic X-Box pad", 0, XTYPE_UNKNOWN }
@@ -451,6 +452,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOXONE_VENDOR(0x24c6),		/* PowerA Controllers */
 	XPAD_XBOXONE_VENDOR(0x2e24),		/* Hyperkin Duke X-Box One pad */
 	XPAD_XBOX360_VENDOR(0x2f24),		/* GameSir Controllers */
+	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
 	{ }
 };
 
-- 
2.33.0

