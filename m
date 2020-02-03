Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C8D150DBF
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgBCQ23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:40054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729586AbgBCQ20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:28:26 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1BAA2086A;
        Mon,  3 Feb 2020 16:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747306;
        bh=yMmzY+xO9X6dnzA77KfXr48cVIU5KP9AVO1G9YWzt/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLQZ1UmfR0Mteu/rFM87cMb8muSsg8rNRmn2NZ89WpqNYTaSfLLzACAbtWaBRIIlf
         XT8+3bsXXiaJZvuMV+omBwLRB+Qg+A0ZL136sJIM2g3GkJvefsEvO8FstDYF4g7kkY
         12171gSYxsDbVmuTXITp7ckVAB0ygNCnz8sQzY4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Engraf <david.engraf@sysgo.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 21/89] watchdog: max77620_wdt: fix potential build errors
Date:   Mon,  3 Feb 2020 16:19:06 +0000
Message-Id: <20200203161919.772674335@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
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
index f55328a316298..fa15a683ae2d4 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -563,6 +563,7 @@ config MAX63XX_WATCHDOG
 config MAX77620_WATCHDOG
 	tristate "Maxim Max77620 Watchdog Timer"
 	depends on MFD_MAX77620 || COMPILE_TEST
+	select WATCHDOG_CORE
 	help
 	 This is the driver for the Max77620 watchdog timer.
 	 Say 'Y' here to enable the watchdog timer support for
-- 
2.20.1



