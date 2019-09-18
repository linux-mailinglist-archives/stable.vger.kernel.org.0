Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72545B5C97
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbfIRG1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbfIRG1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:27:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C698B21925;
        Wed, 18 Sep 2019 06:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788072;
        bh=d4yD91ADl544vrJ6Eea/cuMH4wfMBHfq2yQvkY5yNMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkPZQeJoI7oVp3jfxvBp347peVfZIOrgIDhzR2HaF5vZQpLXy+/ErRS/a6Bn91heT
         EqmqGDJuqtsVV1gcfVgEZSLW6HjBXw7xAv5TxXnRSHVks3ooSCcBZWRWZ+jjTT/MGz
         HrQ2quGxi/G4oj3pt5UA2sSCBUpsgOCYCFNnvUGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Enrico Weigelt <info@metux.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.2 83/85] platform/x86: pcengines-apuv2: use KEY_RESTART for front button
Date:   Wed, 18 Sep 2019 08:19:41 +0200
Message-Id: <20190918061237.997258176@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

commit f14312a93b34b9350dc33ff0b4215c24f4c82617 upstream.

The keycode KEY_RESTART is more appropriate for the front button,
as most people use it for things like restart or factory reset.

Signed-off-by: Enrico Weigelt <info@metux.net>
Fixes: f8eb0235f659 ("x86: pcengines apuv2 gpio/leds/keys platform driver")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/pcengines-apuv2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/pcengines-apuv2.c
+++ b/drivers/platform/x86/pcengines-apuv2.c
@@ -93,7 +93,7 @@ struct gpiod_lookup_table gpios_led_tabl
 
 static struct gpio_keys_button apu2_keys_buttons[] = {
 	{
-		.code			= KEY_SETUP,
+		.code			= KEY_RESTART,
 		.active_low		= 1,
 		.desc			= "front button",
 		.type			= EV_KEY,


