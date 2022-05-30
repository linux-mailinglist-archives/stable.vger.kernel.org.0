Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4732D53836C
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240229AbiE3OdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242703AbiE3Ob3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:31:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FAB12C940;
        Mon, 30 May 2022 06:53:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB55BB80DBB;
        Mon, 30 May 2022 13:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AC7C341C5;
        Mon, 30 May 2022 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918786;
        bh=RuUJURyxugcuc59iK03LZ8W2uZus1jLgTQH7goDPaHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IE8VMiYXzwauNM/yrmZIreHuedc/E4kfjM9H+kMjfm3P22AJNm4Qy9PSWUPJwHl59
         rRV/f/SIBC9uHzdq+P6Bv62dZeWcuxR45mSTNlXRc0qJyoiOrepkpuVPB2dfQDLzix
         wY4GEY/CIfRAKyA4YYjj8QzG+R2LW3x/tmUUwDkX/MmPz0YgbZNAwTKV0cGragV6dM
         QCukYeCrt26SPEhu7WioVGhQba4KhOqGszm5vQub0T/hAn4vJxTRB2BySsZeF7JW/3
         m1LTFEIVHxnlH8BtdUFPmkUyvK7t7+TwW0065bVrReDmn/8+KXjUYQfaBfF9xCwt0b
         cX3vHXyzKgK6w==
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
Subject: [PATCH AUTOSEL 4.9 21/24] media: exynos4-is: Fix compile warning
Date:   Mon, 30 May 2022 09:52:08 -0400
Message-Id: <20220530135211.1937674-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530135211.1937674-1-sashal@kernel.org>
References: <20220530135211.1937674-1-sashal@kernel.org>
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
index f79a1b348aa6..67ef85249912 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.h
@@ -35,7 +35,7 @@ static inline int fimc_isp_video_device_register(struct fimc_isp *isp,
 	return 0;
 }
 
-void fimc_isp_video_device_unregister(struct fimc_isp *isp,
+static inline void fimc_isp_video_device_unregister(struct fimc_isp *isp,
 				enum v4l2_buf_type type)
 {
 }
-- 
2.35.1

