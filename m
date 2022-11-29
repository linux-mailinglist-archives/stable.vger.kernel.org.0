Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2276B63C8E6
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 21:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237185AbiK2UC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 15:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237181AbiK2UC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 15:02:58 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F2E1583E;
        Tue, 29 Nov 2022 12:02:57 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id h28so1170667pfq.9;
        Tue, 29 Nov 2022 12:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVxl8G3vAtq5mJZNn3p6Nl5YUEEXKLYUFCsxfarFtXc=;
        b=F+s++DaJ4sldRIEiCojdUgWz6k5RPsplDj4ODUo5IlwzxOaMDu8AUzcf3JB1x2rIUq
         kh9aAlbhS7FVhtzEaeirIpbhlmSKXAXGWQrj7B+kZbDGgOX6HcXMl4gjrmSqLFT2btgJ
         YDJpmHR1ggBLhYY29kYmk5fLIwON13iTgpQg2dQj/l9F32E0v2fAJ+nd1bT+we0CgqFV
         5x85SiAPV4QHcXqAppCO/TH0Ap6/JE3vWw4Me3FbxVO11B61vrafxNrNWb5xd1Kanjrs
         cDCdq2/hTrJmIoyaBC1oZYMgUjy2LpnGiVuN/9KOzkBzgXLF9chgpjtCUKCBVeyU5Yyi
         0XiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oVxl8G3vAtq5mJZNn3p6Nl5YUEEXKLYUFCsxfarFtXc=;
        b=G4c+fkXRBw7KIAUeGFv9UzSLNIkVovC+lTvkYqHhyBdKbAqzau52uwroXFVyOJsvIx
         PN1vTGjJ8VT4xOtys9c0Xn3ZirmSzGyfMsiFeO9n5+q5hWF8CFXdaV29nAgIcuM4zQm3
         4PUs7fSgaCEOsqwoMbOsCcBYJ9jmw871i4VwUGSIuggHrQR3NE4oExPy5oWodS+yfY2Y
         23opTAPjWIgbkZCzXEFxsknAi4f8B5uKIthk4xE94QHZreCN8+ZL5fCZkerHJroSHQqL
         MH1h1UuYp2qzVHenJ19aB877ZqCfEEh49H/pPT4gSciRIrWZjSREfZkorv9fe+J0mOJO
         5yaw==
X-Gm-Message-State: ANoB5plIsNzfdYdk6BWYcesoC+xpZb+Ekn2OrbV2IiYAX3lE+Dhw5b/2
        a+n28hkbSF6cZiMBtcwypjo=
X-Google-Smtp-Source: AA0mqf4ecb3iEcndqk8sTt5tbiiiy6NU4qulFX8rCv8viufcaHtiTxFmnJS+pEfXfrkiCbx/9tLSGw==
X-Received: by 2002:a63:cc48:0:b0:477:5515:8a9c with SMTP id q8-20020a63cc48000000b0047755158a9cmr33292439pgi.256.1669752176739;
        Tue, 29 Nov 2022 12:02:56 -0800 (PST)
Received: from localhost ([2a00:79e1:abd:4a00:2703:3c72:eb1a:cffd])
        by smtp.gmail.com with ESMTPSA id c10-20020a170902d48a00b00188a7bce192sm11269560plg.264.2022.11.29.12.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 12:02:56 -0800 (PST)
From:   Rob Clark <robdclark@gmail.com>
To:     dri-devel@lists.freedesktop.org
Cc:     Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@chromium.org>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Eric Anholt <eric@anholt.net>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Rob Herring <robh@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] drm/shmem-helper: Remove errant put in error path
Date:   Tue, 29 Nov 2022 12:02:41 -0800
Message-Id: <20221129200242.298120-2-robdclark@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221129200242.298120-1-robdclark@gmail.com>
References: <20221129200242.298120-1-robdclark@gmail.com>
MIME-Version: 1.0
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

From: Rob Clark <robdclark@chromium.org>

drm_gem_shmem_mmap() doesn't own this reference!

Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
Cc: stable@vger.kernel.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 35138f8a375c..110a9eac2af8 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -623,7 +623,6 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
 
 	ret = drm_gem_shmem_get_pages(shmem);
 	if (ret) {
-		drm_gem_vm_close(vma);
 		return ret;
 	}
 
-- 
2.38.1

