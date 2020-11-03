Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E982D2A4B78
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgKCQ3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgKCQ3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 11:29:18 -0500
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7E6C0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 08:29:18 -0800 (PST)
Received: by mail-qv1-xf43.google.com with SMTP id da2so5812162qvb.0
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 08:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6ZTXmbzCHTTNMxJqUXLM8Rt2JD8dq42dHryRV9BUDaU=;
        b=JTuUfafLEcXzQOdp/ZZ9YoL576cBK/O0mibt8m90HczwMPzhTqNn1NoDHW5qSLD5mT
         ND2noWUK5hGWb1d6IpsTvYS/2byQZ8EqyGhJtz09YiIowv+wkFpfbd8D0cv5aIlcTemZ
         xEl3cJ9qg6mN1/h2Mdzx62DdCXUqvYJNXuPUO3AMrvbZf41Y4/yj/hf/JHLOaEcgBoyk
         77NLY77/HgbLWgiOkHtz5A9KEw+ONmzUdHSJ58jY8V9E58WL5GtN7qezsH/a4nC0lFIf
         +HnIVfeYion8NZLwvx7Wl9fa4fryuS57KTOPRmKo2ncB+zxgjBkC8eyHO9pfhFSqX30s
         EQtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6ZTXmbzCHTTNMxJqUXLM8Rt2JD8dq42dHryRV9BUDaU=;
        b=D2/C4a+v4g9AwuNt0kyQOCzSN+EQM4qAhv9E1jMYsNulp/X9rVqOxRYe5h32lbmQbG
         aQSfIKXPrYYNYV1c/fZkbpm33l+m1tP6GaOkCLRlwH0v9JkG5ZRqlC01g12O59mk7VCs
         xtrm3UlRQmx8CifEE0nYDQjxtBi7udL1a9R49BUPj2gzaZWSJSY/vPFfpulRhL9lOJV+
         up8/cUf7H54tamG5EfnRDRWRnEkfXpTtFxoMLSNYo5mUtPN9zol3ZJ80Sysc5lnp1Rvm
         OkxO1kBP2nYpom9ub2eQFYK3R1csoNCQTr1DkByYKDynG1M+Zq+pclbU+cvCS8nRT4Ed
         OiJQ==
X-Gm-Message-State: AOAM530GTL46vpzC/nSUrFGCMmcKFrA3dlqRD+0k5BITg1pEo1xM7EIH
        umOVnaPMzyvykPag5whosIYhMkSFKOc=
X-Google-Smtp-Source: ABdhPJy4tZdu7kCCuGLe8fZhcGhJphsl9Ssfua+oyN+HaV5EPx/mmR4iRKH7t36UOc+hYMyDOUYWJw==
X-Received: by 2002:a0c:ba85:: with SMTP id x5mr27570355qvf.7.1604420957247;
        Tue, 03 Nov 2020 08:29:17 -0800 (PST)
Received: from localhost.localdomain ([71.219.66.138])
        by smtp.gmail.com with ESMTPSA id d48sm10171434qta.26.2020.11.03.08.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 08:29:16 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Kevin Wang <kevin1.wang@amd.com>, Likun Gao <Likun.Gao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4/7] drm/amd/swsmu: add missing feature map for sienna_cichlid
Date:   Tue,  3 Nov 2020 11:29:00 -0500
Message-Id: <20201103162903.687752-6-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103162903.687752-1-alexander.deucher@amd.com>
References: <20201103162903.687752-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Wang <kevin1.wang@amd.com>

it will cause smu sysfs node of "pp_features" show error.

Signed-off-by: Kevin Wang <kevin1.wang@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
(cherry picked from commit d48d7484d8dca1d4577fc53f1f826e68420d00eb)
---
 drivers/gpu/drm/amd/powerplay/inc/smu_types.h      | 1 +
 drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/powerplay/inc/smu_types.h b/drivers/gpu/drm/amd/powerplay/inc/smu_types.h
index 7b585e205a5a..3b868f2adc12 100644
--- a/drivers/gpu/drm/amd/powerplay/inc/smu_types.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/smu_types.h
@@ -217,6 +217,7 @@ enum smu_clk_type {
        __SMU_DUMMY_MAP(DPM_MP0CLK),                    	\
        __SMU_DUMMY_MAP(DPM_LINK),                      	\
        __SMU_DUMMY_MAP(DPM_DCEFCLK),                   	\
+       __SMU_DUMMY_MAP(DPM_XGMI),			\
        __SMU_DUMMY_MAP(DS_GFXCLK),                     	\
        __SMU_DUMMY_MAP(DS_SOCCLK),                     	\
        __SMU_DUMMY_MAP(DS_LCLK),                       	\
diff --git a/drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c
index f2844943f6b7..8f41496630a5 100644
--- a/drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c
@@ -150,14 +150,17 @@ static struct cmn2asic_mapping sienna_cichlid_feature_mask_map[SMU_FEATURE_COUNT
 	FEA_MAP(DPM_GFXCLK),
 	FEA_MAP(DPM_GFX_GPO),
 	FEA_MAP(DPM_UCLK),
+	FEA_MAP(DPM_FCLK),
 	FEA_MAP(DPM_SOCCLK),
 	FEA_MAP(DPM_MP0CLK),
 	FEA_MAP(DPM_LINK),
 	FEA_MAP(DPM_DCEFCLK),
+	FEA_MAP(DPM_XGMI),
 	FEA_MAP(MEM_VDDCI_SCALING),
 	FEA_MAP(MEM_MVDD_SCALING),
 	FEA_MAP(DS_GFXCLK),
 	FEA_MAP(DS_SOCCLK),
+	FEA_MAP(DS_FCLK),
 	FEA_MAP(DS_LCLK),
 	FEA_MAP(DS_DCEFCLK),
 	FEA_MAP(DS_UCLK),
-- 
2.25.4

