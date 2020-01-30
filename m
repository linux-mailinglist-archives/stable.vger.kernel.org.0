Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94EB414E1F5
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731435AbgA3Sru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:47:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:58622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731431AbgA3Sru (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:47:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46D6B20674;
        Thu, 30 Jan 2020 18:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410069;
        bh=Xx6NspAId0wP+mlZ4mJIqcrWJ7K8o+uHRjuJ9rUmNos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fBkBYGmzeDrZQX3y/MQZgWGXoHYQnn84OaCZHZo0ePJG7lxyra2EOCpc4UH6jVIm
         e9qLYGIETMSI9kkaK4UT1gailbZ8AKRRsmUrAxEAnu262nzalFExrqclAiJKF3H012
         Cbts43a7lcFsOxRkbBKDgG51z0lKrGejnsz0WFF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/55] watchdog: rn5t618_wdt: fix module aliases
Date:   Thu, 30 Jan 2020 19:39:15 +0100
Message-Id: <20200130183614.794969088@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
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
index e60f55702ab79..d2e79cf70e774 100644
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



