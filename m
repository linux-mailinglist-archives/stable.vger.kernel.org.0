Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFDA69CC6B
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjBTNkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbjBTNkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:40:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04041C7F0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:40:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10A1F60E03
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF6DC433D2;
        Mon, 20 Feb 2023 13:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900403;
        bh=sxgSfA1i2cTOt1jlI9pwIPaZUJgX8V76Y+0rQ35juww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btlRGHnIVwRsgcaL/hwn5VtJZh6JPuUuwJDfzZeYHmGZilAyDHNuksuRKijQAQ50X
         WJl8qvcFnfcIm3dn7MIXEEyz12qh1yD2Y+XEjO6z4JEJkoxkwtvZJLUw3ITU7RrKsT
         4S6wumFDfx0ohB/mfpcydz9kBy5YozOqWGpQEer4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/89] iio: adc: stm32-dfsdm: fill module aliases
Date:   Mon, 20 Feb 2023 14:35:11 +0100
Message-Id: <20230220133553.532897423@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 1c492a7f4587..bb90b22b809c 100644
--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -1099,6 +1099,7 @@ static const struct of_device_id stm32_dfsdm_adc_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, stm32_dfsdm_adc_match);
 
 static int stm32_dfsdm_adc_probe(struct platform_device *pdev)
 {
-- 
2.39.0



