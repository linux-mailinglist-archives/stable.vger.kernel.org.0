Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC261150B2C
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgBCQZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:25:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728217AbgBCQZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:25:15 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 078B821582;
        Mon,  3 Feb 2020 16:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747114;
        bh=q8E44Y+HeWBDgmDA0JoDWmyJ0l7+apXBWUL+o0tRAJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJdHekLydrV8EzfcfVk+5Z6FLal5Abq5ZG+h5eLSJtsHmYYp6Y9xTLdTSS+XhPJ66
         0U5imQfKO7BmwTLgIb6vFSimMytsGp0PS9PLwV3I1eOOa8olXDMJEGgBW22BuU2L7z
         87Fbst6XxKxv7edVj5FTi8F1t2wHpGvyzsinFooI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 18/68] watchdog: rn5t618_wdt: fix module aliases
Date:   Mon,  3 Feb 2020 16:19:14 +0000
Message-Id: <20200203161908.046906940@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit a76dfb859cd42df6e3d1910659128ffcd2fb6ba2 ]

Platform device aliases were missing so module autoloading
did not work.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20191213214802.22268-1-andreas@kemnade.info
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rn5t618_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/rn5t618_wdt.c b/drivers/watchdog/rn5t618_wdt.c
index 0805ee2acd7a9..7aa8bf2d0f917 100644
--- a/drivers/watchdog/rn5t618_wdt.c
+++ b/drivers/watchdog/rn5t618_wdt.c
@@ -193,6 +193,7 @@ static struct platform_driver rn5t618_wdt_driver = {
 
 module_platform_driver(rn5t618_wdt_driver);
 
+MODULE_ALIAS("platform:rn5t618-wdt");
 MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
 MODULE_DESCRIPTION("RN5T618 watchdog driver");
 MODULE_LICENSE("GPL v2");
-- 
2.20.1



