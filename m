Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64B9314E266
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgA3Sv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:51:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730791AbgA3SoO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:44:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEB80214AF;
        Thu, 30 Jan 2020 18:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409854;
        bh=VowLuk2K+luDJz7dwmIIDAHycgX1yz4Y/RRQAU+DonU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdrpgIhj5JthqxStEUT+AIYTNb54YUc5hyqTF7I0UOeqwb8OzrDCG414nGEWd2aA7
         hqUBnbM21IWIduWNtVIjF+N/8qg9p2lndtmfFugp+8sh4fL7ds2sL04TEs5o4I4DzV
         +dH0gS2bBHvqXerVHcDtHJ8fSu10QNfYbgl5wM4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Engraf <david.engraf@sysgo.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/110] watchdog: max77620_wdt: fix potential build errors
Date:   Thu, 30 Jan 2020 19:38:36 +0100
Message-Id: <20200130183622.096206213@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Engraf <david.engraf@sysgo.com>

[ Upstream commit da9e3f4e30a53cd420cf1e6961c3b4110f0f21f0 ]

max77620_wdt uses watchdog core functions. Enable CONFIG_WATCHDOG_CORE
to fix potential build errors.

Signed-off-by: David Engraf <david.engraf@sysgo.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20191127084617.16937-1-david.engraf@sysgo.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 4c761abc56883..e2745f6861960 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -687,6 +687,7 @@ config MAX63XX_WATCHDOG
 config MAX77620_WATCHDOG
 	tristate "Maxim Max77620 Watchdog Timer"
 	depends on MFD_MAX77620 || COMPILE_TEST
+	select WATCHDOG_CORE
 	help
 	 This is the driver for the Max77620 watchdog timer.
 	 Say 'Y' here to enable the watchdog timer support for
-- 
2.20.1



