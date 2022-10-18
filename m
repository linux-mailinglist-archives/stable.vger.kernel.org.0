Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2639602026
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 03:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiJRBHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 21:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiJRBHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 21:07:54 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2BD303E3
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 18:07:54 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id q196so10591095iod.8
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 18:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=axgOJD7gUJLWncY0SkfScMfFy0OM1pSvja+Frnrc+5E=;
        b=GFftaHMMmUxj3xkXKrCfhWdqb+oQdlnJjW7CU7cV94sLQccmKbI5FARHyT8b8JoJaI
         DmAoQ29tJ2IHFOWuFcimgsZqKpZVwb3QEdxq4AjUl9Iv2L2nLRjHWVtW+7+Pau35Q+oE
         xqa1nryIolqgjeuNCdo6RPEottpP7qcxul8x4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=axgOJD7gUJLWncY0SkfScMfFy0OM1pSvja+Frnrc+5E=;
        b=pTkiDE2bnQbdcqx0sl2yCXUvbCIEz+Fk5IGXl0/uqD29Hs+3prNTrKYpNLFMqu+PEo
         90v43Yj/JTPO2ostUmI+Fen+KeqJc0gU9i0uv4jh8Z6eWyIUGkiec7iFI2lDA81sLjM4
         MsqBT8Y2FSaELNgP2REyynMSrPcpbzdhP9QEm/aoff/VP+vl4x9VM5f5IjecpU8Vabar
         dWvBNXkjzgAcY+j3Om4QmTKIN1Rrb4Me0AikkxPCK/iFQI6bsETJo8yeOCAEEJu5nRFK
         eM+U7gipAMkYR4Zi30rwDypSoyCOFXudSkMS+gjgruIr6f2Z6dmYH6yyP1XTfSplNh8Q
         PHsg==
X-Gm-Message-State: ACrzQf3dHBN7BQhMxvDMp2QMbELZAZ9fuznDXviDCzfW7+cEDfPfdl8M
        e6/E0TbzMpXZ0uBzAXLAiKtg/sbzNg9nDg==
X-Google-Smtp-Source: AMsMyM5natxuKTgl0+9M8ndE3V5po0rKmMoUOGViP+Xpu7uSNVXwg3Cc6CMRhhmt6/yVDa5GZ8Q6xg==
X-Received: by 2002:a05:6638:14cb:b0:363:ed95:ce4c with SMTP id l11-20020a05663814cb00b00363ed95ce4cmr559798jak.308.1666055273505;
        Mon, 17 Oct 2022 18:07:53 -0700 (PDT)
Received: from localhost.localdomain ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id e6-20020a022106000000b0036377aa5a35sm529499jaa.100.2022.10.17.18.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 18:07:53 -0700 (PDT)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, alexander.deucher@amd.com,
        hamza.mahfooz@amd.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] Revert "drm/amdgpu: use dirty framebuffer helper"
Date:   Mon, 17 Oct 2022 19:07:46 -0600
Message-Id: <20221018010746.603662-2-skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018010746.603662-1-skhan@linuxfoundation.org>
References: <20221018010746.603662-1-skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 867b2b2b6802fb3995a0065fc39e0e7e20d8004d.

With this commit, dmesg fills up with the following messages and drm
initialization takes a very long time. This commit has bee reverted
from 5.4

[drm] Fence fallback timer expired on ring sdma0
[drm] Fence fallback timer expired on ring gfx
[drm] Fence fallback timer expired on ring sdma0
[drm] Fence fallback timer expired on ring gfx
[drm] Fence fallback timer expired on ring sdma0
[drm] Fence fallback timer expired on ring sdma0
[drm] Fence fallback timer expired on ring sdma0
[drm] Fence fallback timer expired on ring gfx

Cc: <stable@vger.kernel.org>    # 5.10
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 947f50e402ba..7cc7af2a6822 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -35,7 +35,6 @@
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 #include <drm/drm_crtc_helper.h>
-#include <drm/drm_damage_helper.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_fb_helper.h>
@@ -499,7 +498,6 @@ bool amdgpu_display_ddc_probe(struct amdgpu_connector *amdgpu_connector,
 static const struct drm_framebuffer_funcs amdgpu_fb_funcs = {
 	.destroy = drm_gem_fb_destroy,
 	.create_handle = drm_gem_fb_create_handle,
-	.dirty = drm_atomic_helper_dirtyfb,
 };
 
 uint32_t amdgpu_display_supported_domains(struct amdgpu_device *adev,
-- 
2.34.1

