Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDCB60A1EB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiJXLgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiJXLf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:35:57 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF2E48EA2;
        Mon, 24 Oct 2022 04:35:01 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-13b6c1c89bdso5605137fac.13;
        Mon, 24 Oct 2022 04:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M5UZCFr57jSJwSGj5ycrkruVZLCd8UXEKFZXMqgDVks=;
        b=Psp+OumkznpHgLnHiwYw1sf7aYrjPL/PaHFRiGICufnccSw4s/W0nDvOmlyKc62du7
         YXWX5R/gNmEIxXhnywOAB37LcLDhGS0vTvsnSRcHiBXpqLg6p61frKpXRT65cqPqMViU
         KiYrs77nldrzFFyh8s0gPXh7e7AMOGyabsPE3NasIY8F14cVLczp60Ttfveo5WBxxpZw
         1oKr3NDgOfVJx8M/N+meVaUihFfwhMXZLT0/sS8MxDyTH/3bZjNPlyO74DIDk8TGjvdT
         CpbJQwEVgdW911yK/ZqlHW3zujwxb3GEL/73kSEd4d2OJAxnXuOOkvoqRIK67s2WSWvZ
         Ya0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M5UZCFr57jSJwSGj5ycrkruVZLCd8UXEKFZXMqgDVks=;
        b=RsYsGrn83yW9vLDjrnL14Kn0hTJAs7l0Iuoe17IgEcTxafjk8tqrlVZh827JirS2D/
         +F8jpxTTR/76k1pjBDxHs+vkWYlIT5k2HCXymIDcKH1oVhmiil32m7AJy8S/hif+dnCX
         x/NepulphZGt7bxsC7Nuf3bX4xgn0Aiz/oleIkt2hpWxair3L1clcwATcacXJbRqmfXn
         C4ZomYlWUurehy4JFFvA2qfbLqkVJn1rArMxoCZlFyLMVENidaH2G9Q5VN5wgp6sFCIH
         Eg1lE+XcqToVxtFzR8nyR90QF97hzynAPWi81H870wdRyH43fTjgm7DTYxzCSWdtLFuj
         YgTg==
X-Gm-Message-State: ACrzQf0I4p8CA470cMIYKGjnrqNi/YnkVB6Q7bh+u00gRPz7bBHj8C8m
        OnWL4fQffl/U+mcR9st926w=
X-Google-Smtp-Source: AMsMyM4HCOsEjlNPhwJeL0z0TQZEZazmrwv7DoO6SLiYtb/47ToNb4OWYAXijKmn6cFMZUl/a+Pq4g==
X-Received: by 2002:a05:6870:5804:b0:12a:f192:27de with SMTP id r4-20020a056870580400b0012af19227demr20359146oap.224.1666611246967;
        Mon, 24 Oct 2022 04:34:06 -0700 (PDT)
Received: from smeagol.fibertel.com.ar ([201.235.4.68])
        by smtp.gmail.com with ESMTPSA id a12-20020a056870618c00b0013b92b3ac64sm1996787oah.3.2022.10.24.04.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 04:34:06 -0700 (PDT)
From:   =?UTF-8?q?Joaqu=C3=ADn=20Ignacio=20Aramend=C3=ADa?= 
        <samsagax@gmail.com>
To:     bas@basnieuwenhuizen.nl
Cc:     Xinhui.Pan@amd.com, alexander.deucher@amd.com,
        amd-gfx@lists.freedesktop.org, christian.koenig@amd.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        rodrigo.siqueira@amd.com, samsagax@gmail.com, sunpeng.li@amd.com,
        stable@vger.kernel.org
Subject: [PATCH v2] drm/amd/display: Revert logic for plane modifiers
Date:   Mon, 24 Oct 2022 08:33:59 -0300
Message-Id: <20221024113359.5575-1-samsagax@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <CAP+8YyFUoFhh1+CEKrs48JV5CiorSSfe6qg90TyUrDoBtzcPhA@mail.gmail.com>
References: <CAP+8YyFUoFhh1+CEKrs48JV5CiorSSfe6qg90TyUrDoBtzcPhA@mail.gmail.com>
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

This file was split in commit 5d945cbcd4b16a29d6470a80dfb19738f9a4319f
("drm/amd/display: Create a file dedicated to planes") and the logic in
dm_plane_format_mod_supported() function got changed by a switch logic.
That change broke drm_plane modifiers setting on series 5000 APUs
(tested on OXP mini AMD 5800U and HP Dev One 5850U PRO)
leading to Gamescope not working as reported on GitHub[1]

To reproduce the issue, enter a TTY and run:

$ gamescope -- vkcube

With said commit applied it will abort. This one restores the old logic,
fixing the issue that affects Gamescope.

[1](https://github.com/Plagman/gamescope/issues/624)

Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: Joaquín Ignacio Aramendía <samsagax@gmail.com>
Reviewed-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
---
Removed asic_id and excess newlines. Resend with correct Cc line.
---
 .../amd/display/amdgpu_dm/amdgpu_dm_plane.c   | 50 +++----------------
 1 file changed, 7 insertions(+), 43 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index dfd3be49eac8..e6854f7270a6 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1369,7 +1369,7 @@ static bool dm_plane_format_mod_supported(struct drm_plane *plane,
 {
 	struct amdgpu_device *adev = drm_to_adev(plane->dev);
 	const struct drm_format_info *info = drm_format_info(format);
-	struct hw_asic_id asic_id = adev->dm.dc->ctx->asic_id;
+	int i;

 	enum dm_micro_swizzle microtile = modifier_gfx9_swizzle_mode(modifier) & 3;

@@ -1386,49 +1386,13 @@ static bool dm_plane_format_mod_supported(struct drm_plane *plane,
 		return true;
 	}

-	/* check if swizzle mode is supported by this version of DCN */
-	switch (asic_id.chip_family) {
-	case FAMILY_SI:
-	case FAMILY_CI:
-	case FAMILY_KV:
-	case FAMILY_CZ:
-	case FAMILY_VI:
-		/* asics before AI does not have modifier support */
-		return false;
-	case FAMILY_AI:
-	case FAMILY_RV:
-	case FAMILY_NV:
-	case FAMILY_VGH:
-	case FAMILY_YELLOW_CARP:
-	case AMDGPU_FAMILY_GC_10_3_6:
-	case AMDGPU_FAMILY_GC_10_3_7:
-		switch (AMD_FMT_MOD_GET(TILE, modifier)) {
-		case AMD_FMT_MOD_TILE_GFX9_64K_R_X:
-		case AMD_FMT_MOD_TILE_GFX9_64K_D_X:
-		case AMD_FMT_MOD_TILE_GFX9_64K_S_X:
-		case AMD_FMT_MOD_TILE_GFX9_64K_D:
-			return true;
-		default:
-			return false;
-		}
-		break;
-	case AMDGPU_FAMILY_GC_11_0_0:
-	case AMDGPU_FAMILY_GC_11_0_1:
-		switch (AMD_FMT_MOD_GET(TILE, modifier)) {
-		case AMD_FMT_MOD_TILE_GFX11_256K_R_X:
-		case AMD_FMT_MOD_TILE_GFX9_64K_R_X:
-		case AMD_FMT_MOD_TILE_GFX9_64K_D_X:
-		case AMD_FMT_MOD_TILE_GFX9_64K_S_X:
-		case AMD_FMT_MOD_TILE_GFX9_64K_D:
-			return true;
-		default:
-			return false;
-		}
-		break;
-	default:
-		ASSERT(0); /* Unknown asic */
-		break;
+	/* Check that the modifier is on the list of the plane's supported modifiers. */
+	for (i = 0; i < plane->modifier_count; i++) {
+		if (modifier == plane->modifiers[i])
+			break;
 	}
+	if (i == plane->modifier_count)
+		return false;

 	/*
 	 * For D swizzle the canonical modifier depends on the bpp, so check
--
2.38.1

