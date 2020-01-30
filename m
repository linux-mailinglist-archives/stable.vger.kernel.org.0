Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B891914E16A
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgA3SoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:44:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730801AbgA3SoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:44:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20F5A205F4;
        Thu, 30 Jan 2020 18:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409856;
        bh=l/54tbrLAeoXmLygfmCUMy7nlKmDi4RKwGSnm2fHF3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OD+FJ/vvtqvsoQx16cw7Hz4wEdbxOkr6QoKBSjwoLuXgq7sZhnwhJIIGfPNLtbVTZ
         i1Nh9NKHX8IqHftHaQ7Zj2U9Li8aPGSO2ZZI6tVtrkQHvbebLrS7Vd3tXZlZMEENHs
         gxHOPbithv6EtbbUGTPf2Z26D+ytZbM1P/bf7TQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/110] watchdog: rn5t618_wdt: fix module aliases
Date:   Thu, 30 Jan 2020 19:38:37 +0100
Message-Id: <20200130183622.170030070@linuxfoundation.org>
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
index 2348760474317..6e524c8e26a8f 100644
--- a/drivers/watchdog/rn5t618_wdt.c
+++ b/drivers/watchdog/rn5t618_wdt.c
@@ -188,6 +188,7 @@ static struct platform_driver rn5t618_wdt_driver = {
 
 module_platform_driver(rn5t618_wdt_driver);
 
+MODULE_ALIAS("platform:rn5t618-wdt");
 MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
 MODULE_DESCRIPTION("RN5T618 watchdog driver");
 MODULE_LICENSE("GPL v2");
-- 
2.20.1



