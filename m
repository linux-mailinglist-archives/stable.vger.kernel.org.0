Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C6E29BF33
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814926AbgJ0RAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755298AbgJ0PIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:08:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87BCA206F4;
        Tue, 27 Oct 2020 15:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811328;
        bh=HsMses8PpoHYK+jDdQveb7EZ8eGzvNjnqamAlKSyMTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4xUk/bh7X6S8Fs2dsFfvYUagMSQW5fj8La2dOhultgD3bSFSmC4CzSgm1FGKv4iW
         nrQ1raH2M6kclM8QZqii96b+RCizwarBzZsaYHSHPmwvUIxmn066Q9Xhz+D0XLO/l3
         nosPivMsgUCxwla8efAKIGluJSll0eb1ttUpd99w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 455/633] watchdog: sp5100: Fix definition of EFCH_PM_DECODEEN3
Date:   Tue, 27 Oct 2020 14:53:18 +0100
Message-Id: <20201027135544.058942052@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 08c619b4923056b5dd2d5045757468c76ad0e3fe ]

EFCH_PM_DECODEEN3 is supposed to access DECODEEN register bits 24..31,
in other words the register at byte offset 3.

Cc: Jan Kiszka <jan.kiszka@siemens.com>
Fixes: 887d2ec51e34b ("watchdog: sp5100_tco: Add support for recent FCH versions")
Tested-by: Jan Kiszka <jan.kiszka@siemens.com>
Link: https://lore.kernel.org/r/20200910163109.235136-1-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sp5100_tco.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/sp5100_tco.h b/drivers/watchdog/sp5100_tco.h
index 87eaf357ae01f..adf015aa4126f 100644
--- a/drivers/watchdog/sp5100_tco.h
+++ b/drivers/watchdog/sp5100_tco.h
@@ -70,7 +70,7 @@
 #define EFCH_PM_DECODEEN_WDT_TMREN	BIT(7)
 
 
-#define EFCH_PM_DECODEEN3		0x00
+#define EFCH_PM_DECODEEN3		0x03
 #define EFCH_PM_DECODEEN_SECOND_RES	GENMASK(1, 0)
 #define EFCH_PM_WATCHDOG_DISABLE	((u8)GENMASK(3, 2))
 
-- 
2.25.1



