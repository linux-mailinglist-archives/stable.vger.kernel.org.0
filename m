Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D91472601
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbhLMJsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:48:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbhLMJqA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:46:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9523C08EB30;
        Mon, 13 Dec 2021 01:41:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 419B2CE0AE2;
        Mon, 13 Dec 2021 09:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EDFC00446;
        Mon, 13 Dec 2021 09:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388465;
        bh=pbGKeqSyT3S8vgeYSj2aiYLj+pRwBYeHLrr1VfZCNvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2Oz0iAzEjHX4oMtfC2U2T+JBeBMgjYkAQax9g2caFf117HNX6MANyGxsSjOUiaBm
         Tkc8SfL9BmCggC8l7PaEz1kxxZX8TUUVKeTHkyf0GiaKifTWlfdqr32ZBYzzpEJEYg
         MmQJHHHZWCmBosvf/qKsKK4+G1VASqfIAORkbrnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alyssa Ross <hi@alyssa.is>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 58/74] iio: trigger: stm32-timer: fix MODULE_ALIAS
Date:   Mon, 13 Dec 2021 10:30:29 +0100
Message-Id: <20211213092932.737429494@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
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
@@ -884,6 +884,6 @@ static struct platform_driver stm32_time
 };
 module_platform_driver(stm32_timer_trigger_driver);
 
-MODULE_ALIAS("platform: stm32-timer-trigger");
+MODULE_ALIAS("platform:stm32-timer-trigger");
 MODULE_DESCRIPTION("STMicroelectronics STM32 Timer Trigger driver");
 MODULE_LICENSE("GPL v2");


