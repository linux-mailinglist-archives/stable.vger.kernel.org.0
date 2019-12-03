Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E0F111C3E
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfLCWmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:42:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728626AbfLCWmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:42:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDA532084B;
        Tue,  3 Dec 2019 22:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412923;
        bh=+8IZ96EPLEmXUSJ8lwICHSsmY2hTvpHusQvnP8QJU2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZT+7aFAmD4aD5ccGltf+H11KPanO+y9c7pNDU8KtTJt2hYebMrrcvQ8L62zr/jCv
         jDIQkjQhR3vV941e+MQDax6eL4c6O773ue4Zxg8UJIYhg/5j9XqWcd7YtM5FSjmG45
         vtjthgxaNn/QfMeVh7CH+2EcjUUU03gAvTKRGIps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 068/135] watchdog: bd70528: Add MODULE_ALIAS to allow module auto loading
Date:   Tue,  3 Dec 2019 23:35:08 +0100
Message-Id: <20191203213025.805669276@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit 81363f248aecd2b5f10547af268a4dfaf8963489 ]

The bd70528 watchdog driver is probed by MFD driver. Add MODULE_ALIAS
in order to allow udev to load the module when MFD sub-device cell for
watchdog is added.

Fixes: bbc88a0ec9f37 ("watchdog: bd70528: Initial support for ROHM BD70528 watchdog block")
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/bd70528_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/bd70528_wdt.c b/drivers/watchdog/bd70528_wdt.c
index b0152fef4fc7e..bc60e036627af 100644
--- a/drivers/watchdog/bd70528_wdt.c
+++ b/drivers/watchdog/bd70528_wdt.c
@@ -288,3 +288,4 @@ module_platform_driver(bd70528_wdt);
 MODULE_AUTHOR("Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>");
 MODULE_DESCRIPTION("BD70528 watchdog driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:bd70528-wdt");
-- 
2.20.1



