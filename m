Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F09045E4F9
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358233AbhKZCiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:38:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343705AbhKZCgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:36:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16F04611AE;
        Fri, 26 Nov 2021 02:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893950;
        bh=viddXTknhOgEXWS6LJy1v976ezvP6bEIsfD9x355hVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGOjAR1zncCV2QkvXfx6UiiM1wP1ljNgU7v0VjJPFbjoPDADiWPgHp/MTFZYV4NgW
         +CgU0DINOh+iZfir1Vw0k7R8D3hE3CdKDl4zY05rbnAAQbtTqdo2+cNUHuTBrlqABP
         X4NCdfCN1LKOrxlndtA+jD2pmu3VCu0GOh9D4xwB8JoyYTM9/Lh62hDeLnYgWwn72v
         vTgLlkY/BoHBwK/pbP2yHhVWMiED423Q5zs4q2ArGuyuqhabcnAYXMvZK68Kh3WHwS
         wa/7EbnegxCcW7EgjV5dgxJI3WpHFm3KFHGpRB1e3owG1Pp133OQCvDkW00gl6/IOe
         pRNrLjh5wDHJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        andriy.shevchenko@linux.intel.com, rdunlap@infradead.org,
        mario.limonciello@dell.com, markpearson@lenovo.com,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/39] platform/x86: dell-wmi-descriptor: disable by default
Date:   Thu, 25 Nov 2021 21:31:32 -0500
Message-Id: <20211126023156.441292-15-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 0f07c023dcd08ca49b6d3dd018abc7cd56301478 ]

dell-wmi-descriptor only provides symbols to other drivers.
These drivers already select dell-wmi-descriptor when needed.

This fixes an issue where dell-wmi-descriptor is compiled as a module
with localyesconfig on a non-Dell machine.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20211113080551.61860-1-linux@weissschuh.net
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell/Kconfig b/drivers/platform/x86/dell/Kconfig
index 2fffa57e596e4..fe224a54f24c0 100644
--- a/drivers/platform/x86/dell/Kconfig
+++ b/drivers/platform/x86/dell/Kconfig
@@ -187,7 +187,7 @@ config DELL_WMI_AIO
 
 config DELL_WMI_DESCRIPTOR
 	tristate
-	default m
+	default n
 	depends on ACPI_WMI
 
 config DELL_WMI_LED
-- 
2.33.0

