Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABE068D7DA
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbjBGNDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbjBGNDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:03:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE9620D27
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:03:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E9DEB81990
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C0FC433D2;
        Tue,  7 Feb 2023 13:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775024;
        bh=p+nTreZJOEvTMCXLh1VqS5FkE6rkX+0h/IQAUqXfrgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgLOGfon2AmWEjwZkCis/bDjBq+IxD8Ue0w8tYTLCi2+sU1aFRiDdDjbop7R7X2hN
         9h8AA03uzZ+WgsMzDvluXz+7Acsg3bnCuZRc/DNCz0TNadwpikJgEBaL7Exv4X7Auf
         j+bsueGo73uixEWGWbMIyUYkxM8u5YY84L7WXACo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/208] iio: adc: stm32-dfsdm: fill module aliases
Date:   Tue,  7 Feb 2023 13:56:05 +0100
Message-Id: <20230207125639.399556179@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit cc3304052a89ab6ac887ed9224420a27e3d354e1 ]

When STM32 DFSDM driver is built as module, no modalias information
is available. This prevents module to be loaded by udev.
Add MODULE_DEVICE_TABLE() to fill module aliases.

Fixes: e2e6771c6462 ("IIO: ADC: add STM32 DFSDM sigma delta ADC support")
Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://lore.kernel.org/r/20221202152848.45585-1-olivier.moysan@foss.st.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-dfsdm-adc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/stm32-dfsdm-adc.c b/drivers/iio/adc/stm32-dfsdm-adc.c
index 6d21ea84fa82..a428bdb567d5 100644
--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -1520,6 +1520,7 @@ static const struct of_device_id stm32_dfsdm_adc_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, stm32_dfsdm_adc_match);
 
 static int stm32_dfsdm_adc_probe(struct platform_device *pdev)
 {
-- 
2.39.0



