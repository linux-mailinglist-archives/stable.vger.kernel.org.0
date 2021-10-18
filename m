Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AF7431AE1
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhJRN3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231788AbhJRN3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:29:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7992661077;
        Mon, 18 Oct 2021 13:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563558;
        bh=97Bl2w8k6t+KF/0Fghoko3xAG4ySwYScghWGfLjGblY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7nnZd1FmufTmnS9/f3ak9zYjUgKCFIsQ2f6tMe1o8f/gL0puJ+uM60W741yi+5q7
         zHPa5RfQKpK8j4HXbiZgTV1z1O1Y7qVQSxGVCajZqSh6IW3tCED9PbolFl8csv70Nv
         QRZk4li115Kq1B1ZJ+2se18wbJ+7Pk9hnYN7lg5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Cullen <michael@michaelcullen.name>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 13/39] Input: xpad - add support for another USB ID of Nacon GC-100
Date:   Mon, 18 Oct 2021 15:24:22 +0200
Message-Id: <20211018132325.885939934@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132325.426739023@linuxfoundation.org>
References: <20211018132325.426739023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Cullen <michael@michaelcullen.name>

commit 3378a07daa6cdd11e042797454c706d1c69f9ca6 upstream.

The Nacon GX100XF is already mapped, but it seems there is a Nacon
GC-100 (identified as NC5136Wht PCGC-100WHITE though I believe other
colours exist) with a different USB ID when in XInput mode.

Signed-off-by: Michael Cullen <michael@michaelcullen.name>
Link: https://lore.kernel.org/r/20211015192051.5196-1-michael@michaelcullen.name
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 file changed, 2 insertions(+)

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
@@ -464,6 +465,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOXONE_VENDOR(0x24c6),		/* PowerA Controllers */
 	XPAD_XBOXONE_VENDOR(0x2e24),		/* Hyperkin Duke X-Box One pad */
 	XPAD_XBOX360_VENDOR(0x2f24),		/* GameSir Controllers */
+	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
 	{ }
 };
 


