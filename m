Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF6C4727B9
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241476AbhLMKEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:04:40 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48546 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238532AbhLMKAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:00:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4F56FCE0F12;
        Mon, 13 Dec 2021 10:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9CAC34600;
        Mon, 13 Dec 2021 10:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389610;
        bh=JFKatAFNgT/e+blSmBB3M63gzodfwlWxwaBrt75AvLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYMuWOHsca00cSXAGaGs0PH5ZNA5fphH71WQ1bVudLwWee/4k0m5WlHIycCoIsQEq
         Yv2/K4bSwbbekpQUWlmq4mnUPpf30xDa0WyJ3PAzMXxKgPqqT8QMqRLzrI18KyNcA2
         HStfXTNEGVWOKM4ayzlu1IjOW5rbq22G8riw9mZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alyssa Ross <hi@alyssa.is>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 145/171] iio: trigger: stm32-timer: fix MODULE_ALIAS
Date:   Mon, 13 Dec 2021 10:31:00 +0100
Message-Id: <20211213092949.900701448@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alyssa Ross <hi@alyssa.is>

commit 893621e0606747c5bbefcaf2794d12c7aa6212b7 upstream.

modprobe can't handle spaces in aliases.

Fixes: 93fbe91b5521 ("iio: Add STM32 timer trigger driver")
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Link: https://lore.kernel.org/r/20211125182850.2645424-1-hi@alyssa.is
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/trigger/stm32-timer-trigger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/trigger/stm32-timer-trigger.c
+++ b/drivers/iio/trigger/stm32-timer-trigger.c
@@ -912,6 +912,6 @@ static struct platform_driver stm32_time
 };
 module_platform_driver(stm32_timer_trigger_driver);
 
-MODULE_ALIAS("platform: stm32-timer-trigger");
+MODULE_ALIAS("platform:stm32-timer-trigger");
 MODULE_DESCRIPTION("STMicroelectronics STM32 Timer Trigger driver");
 MODULE_LICENSE("GPL v2");


