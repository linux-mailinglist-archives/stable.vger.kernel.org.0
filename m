Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590AF203CB3
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 18:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbgFVQh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 12:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729519AbgFVQh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 12:37:26 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B87BC061573
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 09:37:26 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b4so16050674qkn.11
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 09:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=277V84yXSoEV2wgNb4aslJUPXXhRIdet/MVXa+1/uCM=;
        b=dp5KJbRZ9y8m5vK/Dtw7km9MSd/nh0/8+ZBCYVGP47amXpk1DfDfvyeRiLQgpB8Ct0
         ZMmFnzdpOHPaj8UndNXXWJ+dbibhMCzvc7IfIjlpzA++OBfRi+UJTJXoxgoo9lwj5LWV
         nv8OW3ngUoUgPcaLR54inVkhC1SHRQUQHaHaMPGkKFDQKQ6HOdT9tJVrNupromy65lPZ
         8ivLwB7UhvRS3llVQczXRIXjrBj2zo659PWn0SkU2/eBjYW5LRlptZRvIV9ZYe27ABZd
         0TV9zFCXLTeCG3p2rQvPJ6DEXIZ1UB7F9VjYWsNSBZpZ/J+xnZzBvTnaASbRDecARHJ3
         pENQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=277V84yXSoEV2wgNb4aslJUPXXhRIdet/MVXa+1/uCM=;
        b=I7vA557u0clKxrL/OUx/aQyWYL+UkQ22uacXsgBUSWW61VP1mhrotVflUUazcJjAs0
         xB4IE3L1poHXvWLTN+vxeNYoAGHxxuDB2mMeW+ZLcDCr1BTDMjT2NguP3lq0jeuVnAh3
         4ir51sFDbWG9Nj3LchkBwmc01f6K0JkxoLeZ+MpPleW/+muGc0CkED8QeL867IqEgDFd
         vPBDeEpTSCX4/07IGtfhWWhnyfXVH0SQ6nck3iOHJmGvNszqJvg9FITIZded50UqiPIe
         CenidIk3bNF+Duld16o6AIYhAMbDkrniChy0tpZvVOjaLszrnBp8hClggrQffOzNezjn
         hfcw==
X-Gm-Message-State: AOAM530G5Unx2gLFqfnY6cXhqNqi/1oHUKZc4Lpeega0GJgYb5JT98HK
        mVaktPx7G7K4TN7LcLdRHzmNpEhW
X-Google-Smtp-Source: ABdhPJyFZtFtjC5DJeMN/xYRH0QBryJ0sdpCZ9+tfbvjHEaJ1XFnGkBkAG4ppUZsK5F2LpEXH76+ww==
X-Received: by 2002:a37:8d4:: with SMTP id 203mr17106802qki.11.1592843845264;
        Mon, 22 Jun 2020 09:37:25 -0700 (PDT)
Received: from localhost.localdomain ([71.219.51.205])
        by smtp.gmail.com with ESMTPSA id i3sm13953641qkf.39.2020.06.22.09.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 09:37:24 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Harry Wentland <harry.wentland@amd.com>,
        Alexander Monakov <amonakov@ispras.ru>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Michael Chiu <Michael.Chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Subject: [PATCH] Revert "drm/amd/display: disable dcn20 abm feature for bring up"
Date:   Mon, 22 Jun 2020 12:37:06 -0400
Message-Id: <20200622163706.906713-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harry Wentland <harry.wentland@amd.com>

This reverts commit 96cb7cf13d8530099c256c053648ad576588c387.

This change was used for DCN2 bringup and is no longer desired.
In fact it breaks backlight on DCN2 systems.

Cc: Alexander Monakov <amonakov@ispras.ru>
Cc: Hersen Wu <hersenxs.wu@amd.com>
Cc: Anthony Koo <Anthony.Koo@amd.com>
Cc: Michael Chiu <Michael.Chiu@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reported-and-tested-by: Alexander Monakov <amonakov@ispras.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
(cherry picked from commit 14ed1c908a7a623cc0cbf0203f8201d1b7d31d16)
---

Fixed up to apply cleanly on 5.7 and older kernels.

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 7fc15b82fe48..f9f02e08054b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1334,7 +1334,7 @@ static int dm_late_init(void *handle)
 	unsigned int linear_lut[16];
 	int i;
 	struct dmcu *dmcu = adev->dm.dc->res_pool->dmcu;
-	bool ret = false;
+	bool ret;
 
 	for (i = 0; i < 16; i++)
 		linear_lut[i] = 0xFFFF * i / 15;
@@ -1350,13 +1350,10 @@ static int dm_late_init(void *handle)
 	 */
 	params.min_abm_backlight = 0x28F;
 
-	/* todo will enable for navi10 */
-	if (adev->asic_type <= CHIP_RAVEN) {
-		ret = dmcu_load_iram(dmcu, params);
+	ret = dmcu_load_iram(dmcu, params);
 
-		if (!ret)
-			return -EINVAL;
-	}
+	if (!ret)
+		return -EINVAL;
 
 	return detect_mst_link_for_all_connectors(adev->ddev);
 }
-- 
2.25.4

