Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43585201091
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404859AbgFSPbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404857AbgFSPbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:31:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 594AA20786;
        Fri, 19 Jun 2020 15:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580692;
        bh=weOuWtfn6nT0MnIi8mNlyVJD7ZvXbBB6BvY525BbmuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/X69lpfXanhiZuEqUxDnvs+AwVRpTETPql+X+a5VPSam4xuxYQSqMeJvsY8zwaNd
         W/0C0haw1Kq3oa2KhHIFzpL1wCWehFcFE2pw72BLOE0NGCEt0Fxy3+dq7jTFiktaTm
         9wtukS70hnI2sazEuFFBy2sm1JPxk6d18MFMH4WI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.7 316/376] power: supply: core: fix HWMON temperature labels
Date:   Fri, 19 Jun 2020 16:33:54 +0200
Message-Id: <20200619141725.294018925@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
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
 


