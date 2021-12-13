Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521C847284A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhLMKKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239696AbhLMKGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:06:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AE6C0A88A3;
        Mon, 13 Dec 2021 01:51:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78C1EB80E0B;
        Mon, 13 Dec 2021 09:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F8EC00446;
        Mon, 13 Dec 2021 09:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389073;
        bh=JFKatAFNgT/e+blSmBB3M63gzodfwlWxwaBrt75AvLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvWs48BGivOKoZkl96YVNT8ydfA1oIg+nVcVpGiP9VQYfT4lJNgU61HT3XG+JN9Dj
         WM2PpmHBhqhGVr48rGPXsNp9Jzo9J9AlyZ1ZLb2YK5wG5DzJ6C0Xjuqy9RFZK7MmZp
         It5DjFQDaA0SKtsf2TIOUD195nGEbsLDuHWAAEww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alyssa Ross <hi@alyssa.is>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 108/132] iio: trigger: stm32-timer: fix MODULE_ALIAS
Date:   Mon, 13 Dec 2021 10:30:49 +0100
Message-Id: <20211213092942.811305221@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
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


