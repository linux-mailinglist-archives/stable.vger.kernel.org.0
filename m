Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B2A66C4ED
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbjAPQAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjAPP7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:59:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E626623860
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:59:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86C626102D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9870BC433D2;
        Mon, 16 Jan 2023 15:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884775;
        bh=95MzELXbmXfwUuEQQ2+CW4+v+lrHNXwiM9pIXIcxov4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMlqwft/06ENNdReKQo+bdV2llE92+BgkFaOK5c/WvmA/n7XEcFw0PKE5yY6PfUu4
         Q4oj9SmGuk6uJhEhviiJ18EkYRj3bFXCpbixFnnIDnNL5RgxGpQ9FMDzYodmfnxZ5L
         npT9/mHoZjeq3mb/nJwlxDXwCPxbSIKM6OuiICSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/183] drm/msm/dpu: Fix some kernel-doc comments
Date:   Mon, 16 Jan 2023 16:50:27 +0100
Message-Id: <20230116154807.771286596@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 1bdeb321d1f856346fe0078af09c9e7ffbd2ca7a ]

Make the description of @init to @p in dpu_encoder_phys_wb_init()
and remove @wb_roi in dpu_encoder_phys_wb_setup_fb() to clear the below
warnings:

drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c:139: warning: Excess function parameter 'wb_roi' description in 'dpu_encoder_phys_wb_setup_fb'
drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c:699: warning: Function parameter or member 'p' not described in 'dpu_encoder_phys_wb_init'
drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c:699: warning: Excess function parameter 'init' description in 'dpu_encoder_phys_wb_init'

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3067
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Fixes: d7d0e73f7de3 ("drm/msm/dpu: introduce the dpu_encoder_phys_* for writeback")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/511605/
Link: https://lore.kernel.org/r/20221115014902.45240-1-yang.lee@linux.alibaba.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
index 7cbcef6efe17..62f6ff6abf41 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
@@ -132,7 +132,6 @@ static void dpu_encoder_phys_wb_set_qos(struct dpu_encoder_phys *phys_enc)
  * dpu_encoder_phys_wb_setup_fb - setup output framebuffer
  * @phys_enc:	Pointer to physical encoder
  * @fb:		Pointer to output framebuffer
- * @wb_roi:	Pointer to output region of interest
  */
 static void dpu_encoder_phys_wb_setup_fb(struct dpu_encoder_phys *phys_enc,
 		struct drm_framebuffer *fb)
@@ -692,7 +691,7 @@ static void dpu_encoder_phys_wb_init_ops(struct dpu_encoder_phys_ops *ops)
 
 /**
  * dpu_encoder_phys_wb_init - initialize writeback encoder
- * @init:	Pointer to init info structure with initialization params
+ * @p:	Pointer to init info structure with initialization params
  */
 struct dpu_encoder_phys *dpu_encoder_phys_wb_init(
 		struct dpu_enc_phys_init_params *p)
-- 
2.35.1



