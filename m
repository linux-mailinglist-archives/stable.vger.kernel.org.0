Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFAF15C57F
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgBMPWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728129AbgBMPWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:48 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5FBE20848;
        Thu, 13 Feb 2020 15:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607367;
        bh=SreRQhHSqcIYopXsz/O5ppSA86D6+Wdr7qSmaLyvUf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLkI2Zy3ER9PkGFhoa8gdWaLiUrT2qzNuLqvtM54CKUlpMIiHGCKXXQREyX+IFXQK
         UKcSyawZFYiOScRnqNNFYIBbw0RH7V6L/+2gPknPj4eg8jiRHNHPJ69COpIYnbwxtE
         Wahf4KwBJjobuW/f/jzE5rax2iTAnJF733yfrkHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 56/91] mfd: da9062: Fix watchdog compatible string
Date:   Thu, 13 Feb 2020 07:20:13 -0800
Message-Id: <20200213151843.437731657@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

commit 1112ba02ff1190ca9c15a912f9269e54b46d2d82 upstream.

The watchdog driver compatible is "dlg,da9062-watchdog" and not
"dlg,da9062-wdt". Therefore the mfd-core can't populate the of_node and
fwnode. As result the watchdog driver can't parse the devicetree.

Fixes: 9b40b030c4ad ("mfd: da9062: Supply core driver")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/da9062-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/da9062-core.c
+++ b/drivers/mfd/da9062-core.c
@@ -142,7 +142,7 @@ static const struct mfd_cell da9062_devs
 		.name		= "da9062-watchdog",
 		.num_resources	= ARRAY_SIZE(da9062_wdt_resources),
 		.resources	= da9062_wdt_resources,
-		.of_compatible  = "dlg,da9062-wdt",
+		.of_compatible  = "dlg,da9062-watchdog",
 	},
 	{
 		.name		= "da9062-thermal",


