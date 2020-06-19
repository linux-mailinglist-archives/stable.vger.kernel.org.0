Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153CA20135E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392307AbgFSPOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392301AbgFSPOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:14:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C06F62158C;
        Fri, 19 Jun 2020 15:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579644;
        bh=weOuWtfn6nT0MnIi8mNlyVJD7ZvXbBB6BvY525BbmuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6buZyX8weom8ZkXUGdYJJd1HD5nxjtpjbZ4j7g2OktPYWVNOmCKt85EOIx76tR0r
         +zCmiVJvLn3igdSh9ULk8ad5DolL7q+i2MTv2dgKZGGj03NjF+7oLOdE0Sbpyx22O6
         UAoNy/cdnua+sYgPKiGTlpl5yAPeELsqQx8VMIW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.4 212/261] power: supply: core: fix HWMON temperature labels
Date:   Fri, 19 Jun 2020 16:33:43 +0200
Message-Id: <20200619141700.050719511@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit 6b20464ad9fb5fd76ef6f219ce62156aa9639dcc upstream.

tempX_label files are swapped compared to what
power_supply_hwmon_temp_to_property() uses. Make them match.

Cc: stable@vger.kernel.org
Fixes: e67d4dfc9ff1 ("power: supply: Add HWMON compatibility layer")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/supply/power_supply_hwmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/power_supply_hwmon.c
+++ b/drivers/power/supply/power_supply_hwmon.c
@@ -144,7 +144,7 @@ static int power_supply_hwmon_read_strin
 					  u32 attr, int channel,
 					  const char **str)
 {
-	*str = channel ? "temp" : "temp ambient";
+	*str = channel ? "temp ambient" : "temp";
 	return 0;
 }
 


