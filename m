Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301C36242B0
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 14:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiKJNAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 08:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiKJNAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 08:00:15 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C4818350
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 05:00:14 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so1113381wmb.0
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 05:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7bY2rgwP3tMrluPXwz06V76dXD+NISw13BpQ3yCDFRk=;
        b=BnnobZvNewjr5VhLps+zWMZtse0VCHRiRZQLEIyA5VwZfO/Ogz20+5Ydbw0mRuF1QJ
         1VoGgLaBjs/QYOhYIoTOeigk1aR5UPhz1FSC/YsRBpLSz88dmWN5qcwKExoDDOcHHoH8
         mGR/MWYM38/QLnyNzn8SW+zGB7Ua++y71ZvKDN8ctNYH2BNyR2XiNRyrQkdEmrOkxbl4
         YGvUdTlSw9gDe+GsGZake7o5Nc2Y8UBm7yFsteiMMnm2jLh1+3CuiHRulh5oG9lQ4wAO
         aznPCrfNnfLQaMyHfVGW5Ny3FVuBIJsneZ2odrZqjo5NmnloU25qG8FqljdTqiPpjhr4
         4ltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7bY2rgwP3tMrluPXwz06V76dXD+NISw13BpQ3yCDFRk=;
        b=ejpVeMjGlO3VsRErl12lQTHvZjhRikNRnYFWzVFJmahHGln+QVy5HIM8NiSOoM6GhN
         9qjl8xwb1vR2BBhGGIchFObEdT+ikiRByJkNoUS/HU98c6Qe5azZksI13pBGJ4rPdbYY
         NuKkwTaCKeag61YzGXT31ecaJvQpZFw1dhNu+yyMHmqnQ8lxHQwyod9teVyhr4P2Un9a
         gPl5eLJqQLrtzCCv6naD43X4gf8iFoa1Xew1qiBBD2ucD+TmTrVzVnP37L1knexDCS2k
         tE12gLu0nRz/9PhJVrUycLWjzp/MR383BWs4nMxTl8MKLdnQeipY5hsTN6zB8I9vOnhf
         TLZQ==
X-Gm-Message-State: ACrzQf0u21UEDXs4QEaevOBzVY+0mjz97+CtF8BQmJe+aRKnj4hANu1o
        BpF45/s/ZRE9KSnJIfI9I6elSavbrfI=
X-Google-Smtp-Source: AMsMyM7yrmZ+jGewpT32veAFwT9/G51cRYK5secWqDoO3i2ktgY4aalhQGKrQjPhbEPl7GhSdRXi9Q==
X-Received: by 2002:a05:600c:3b9e:b0:3cf:93de:14b1 with SMTP id n30-20020a05600c3b9e00b003cf93de14b1mr22934388wms.148.1668085212656;
        Thu, 10 Nov 2022 05:00:12 -0800 (PST)
Received: from able.fritz.box (p5b0ea229.dip0.t-ipconnect.de. [91.14.162.41])
        by smtp.gmail.com with ESMTPSA id az11-20020a05600c600b00b003b4cba4ef71sm5318965wmb.41.2022.11.10.05.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 05:00:11 -0800 (PST)
From:   "=?UTF-8?q?Christian=20K=C3=B6nig?=" 
        <ckoenig.leichtzumerken@gmail.com>
X-Google-Original-From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
To:     felix.kuehling@amd.com, Philip.Yang@amd.com,
        amd-gfx@lists.freedesktop.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] drm/amdgpu: always register an MMU notifier for userptr
Date:   Thu, 10 Nov 2022 14:00:06 +0100
Message-Id: <20221110130009.1835-1-christian.koenig@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since switching to HMM we always need that because we no longer grab
references to the pages.

Signed-off-by: Christian König <christian.koenig@amd.com>
CC: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index 8ef31d687ef3..111484ceb47d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -413,11 +413,9 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
 	if (r)
 		goto release_object;
 
-	if (args->flags & AMDGPU_GEM_USERPTR_REGISTER) {
-		r = amdgpu_mn_register(bo, args->addr);
-		if (r)
-			goto release_object;
-	}
+	r = amdgpu_mn_register(bo, args->addr);
+	if (r)
+		goto release_object;
 
 	if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE) {
 		r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);
-- 
2.34.1

