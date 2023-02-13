Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9C96949F8
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbjBMPDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbjBMPD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:03:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD8035BA
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:03:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C152DB8122D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DCCC4339B;
        Mon, 13 Feb 2023 15:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300591;
        bh=71iNlBL+XuH/eLkc5Yoh78ukUc4odthHKGnKPpcIj6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZVrjnIW7BZSKEbBeACP1GQF9DJBKuDbZ65bT8/pOUt13j/L/cwaziyu1gcRQPnJI
         dS9RW6sF0Uj1fz5peeOFtFIquyDa3U+Wp9mQyumOgTOVwCCYASdIK85usfnzWZfrhk
         2aXifdVOmWGJ54RXwQioS/nx9O3KIOrBAGjtSJhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/139] iio: adc: stm32-dfsdm: fill module aliases
Date:   Mon, 13 Feb 2023 15:49:50 +0100
Message-Id: <20230213144748.074470257@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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
index 9234f14167b7..171d73efb2f8 100644
--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -1521,6 +1521,7 @@ static const struct of_device_id stm32_dfsdm_adc_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, stm32_dfsdm_adc_match);
 
 static int stm32_dfsdm_adc_probe(struct platform_device *pdev)
 {
-- 
2.39.0



