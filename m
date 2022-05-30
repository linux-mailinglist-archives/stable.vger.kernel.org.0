Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5CB538213
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237185AbiE3OVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240662AbiE3OQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:16:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7A4EBEBF;
        Mon, 30 May 2022 06:43:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E32960F47;
        Mon, 30 May 2022 13:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273C5C3411A;
        Mon, 30 May 2022 13:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918198;
        bh=CTn9HCUjXYHSwA99rQmy+i5tCftAg7PvxJaOxRnYJjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/yxXOBmAcAT8S9BICcwNH2sJCGTMm1xZXCZt3oTTTUcjpY9061Ri12L0rGiauuBx
         iV+bo3JVjKMzU76fW68kRsgieIDTT0LOzwicz2KXIoqe/FiRF4e9WzHrJk1XSIL3kF
         ggNYZWMl2vVn3C/a1QoqVzXt3MPAcpW0MqpcSc3XidXLQUtErtIiiKsbaINIveFa8B
         mpn2P6yMs4hmb3kRpNTEUMYoTohkENxi92RwA9DZe2OH9tozbvKR3UEqcwmMdJXXui
         DRqHV70WBsKejDSdXSvpwAevDepQvsXz5NLCeqKy93lb84DK0ntDkYEcQU99qIDorI
         Nswwugi7kGprQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kwanghoon Son <k.son@samsung.com>,
        kernel test robot <lkp@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@linaro.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 091/109] media: exynos4-is: Fix compile warning
Date:   Mon, 30 May 2022 09:38:07 -0400
Message-Id: <20220530133825.1933431-91-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kwanghoon Son <k.son@samsung.com>

[ Upstream commit e080f5c1f2b6d02c02ee5d674e0e392ccf63bbaf ]

Declare static on function 'fimc_isp_video_device_unregister'.

When VIDEO_EXYNOS4_ISP_DMA_CAPTURE=n, compiler warns about
warning: no previous prototype for function [-Wmissing-prototypes]

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Kwanghoon Son <k.son@samsung.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/fimc-isp-video.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.h b/drivers/media/platform/exynos4-is/fimc-isp-video.h
index edcb3a5e3cb9..2dd4ddbc748a 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.h
@@ -32,7 +32,7 @@ static inline int fimc_isp_video_device_register(struct fimc_isp *isp,
 	return 0;
 }
 
-void fimc_isp_video_device_unregister(struct fimc_isp *isp,
+static inline void fimc_isp_video_device_unregister(struct fimc_isp *isp,
 				enum v4l2_buf_type type)
 {
 }
-- 
2.35.1

