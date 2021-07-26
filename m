Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D79F3D628B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhGZPgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:36:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235438AbhGZPfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94CDC60F9F;
        Mon, 26 Jul 2021 16:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316175;
        bh=8kFvXiH+MRFQu8oQ1tz6ELHHooexvaGVK+t+tZixmRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azJDZoDkIkj8rmnGy8EQAZZINw/riBBSeym0ijXXMd0xo6XNJu5yfL3jd0Eth55ai
         19ji13bnrYQEazsxFNfeRJSp6R4LvNUMh6FRu2EfsW+t/19+3rWQMGh40/UhlW68/Q
         n+EP76NZxfcKRfK4sC1cxYKfHGhWzKai3u1bY+dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ojaswin Mujoo <ojaswin98@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.13 217/223] ARM: multi_v7_defconfig: Make NOP_USB_XCEIV driver built-in
Date:   Mon, 26 Jul 2021 17:40:09 +0200
Message-Id: <20210726153853.277559698@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

commit ab37a7a890c1176144a4c66ff3d51ef2c20ed486 upstream.

The usage of usb-nop-xceiv PHY on Raspberry Pi boards with BCM283x has
been a "regression source" a lot of times. The last case is breakage of
USB mass storage boot has been commit e590474768f1 ("driver core: Set
fw_devlink=on by default") for multi_v7_defconfig. As long as
NOP_USB_XCEIV is configured as module, the dwc2 USB driver defer probing
endlessly and prevent booting from USB mass storage device. So make
the driver built-in as in bcm2835_defconfig and arm64/defconfig.

Fixes: e590474768f1 ("driver core: Set fw_devlink=on by default")
Reported-by: Ojaswin Mujoo <ojaswin98@gmail.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/1625915095-23077-1-git-send-email-stefan.wahren@i2se.com'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/configs/multi_v7_defconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -821,7 +821,7 @@ CONFIG_USB_ISP1760=y
 CONFIG_USB_HSIC_USB3503=y
 CONFIG_AB8500_USB=y
 CONFIG_KEYSTONE_USB_PHY=m
-CONFIG_NOP_USB_XCEIV=m
+CONFIG_NOP_USB_XCEIV=y
 CONFIG_AM335X_PHY_USB=m
 CONFIG_TWL6030_USB=m
 CONFIG_USB_GPIO_VBUS=y


