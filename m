Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64811541A9C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376412AbiFGVgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380845AbiFGVgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:36:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E93522E6B2;
        Tue,  7 Jun 2022 12:04:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE4F0617CC;
        Tue,  7 Jun 2022 19:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59E7C385A5;
        Tue,  7 Jun 2022 19:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628681;
        bh=VtHAmwGWq2JmA7+s917yXycdVl/6usKdMAWjj8/uqLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sK4XaoeEOu/kRxtpS7k0GbJCS7lAGZxw+urVen3xUnLNJxmZXpVs9QdzxDtSDCE4w
         4qRXI7MSjznobAWRf0I/i+w/l49XUq4D1vGd+ry7YE+Mzv2txw8gGP3C0PwmKtTHu3
         ZuuH8fAkBQFy9waefnyP1gRcTzREoRbT8KsrE5KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 376/879] drm/msm: add missing include to msm_drv.c
Date:   Tue,  7 Jun 2022 18:58:14 +0200
Message-Id: <20220607165013.784905114@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 8123fe83c3a3448bbfa5b5b1cacfdfe7d076fca6 ]

Add explicit include of drm_bridge.h to the msm_drv.c to fix the
following warning:

drivers/gpu/drm/msm/msm_drv.c:236:17: error: implicit declaration of function 'drm_bridge_remove'; did you mean 'drm_bridge_detach'? [-Werror=implicit-function-declaration]

Fixes: d28ea556267c ("drm/msm: properly add and remove internal bridges")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/484310/
Link: https://lore.kernel.org/r/20220430180917.3819294-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 71e1b7393f6f..e3d83963ad54 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -11,6 +11,7 @@
 #include <linux/uaccess.h>
 #include <uapi/linux/sched/types.h>
 
+#include <drm/drm_bridge.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_file.h>
 #include <drm/drm_ioctl.h>
-- 
2.35.1



