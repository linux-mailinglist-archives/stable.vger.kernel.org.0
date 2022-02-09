Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A404AFE13
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 21:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiBIUQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 15:16:37 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiBIUQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 15:16:37 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE446E00E59C
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 12:16:38 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id k18so5936263wrg.11
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 12:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x2hpnS67b7Pd2Ec56U22LLJIvAsb9f2puADLliDF4yU=;
        b=QjbARCgbSm9TLNAwo1GkvPSey2adYdcSBp0Ii49NhLXX+jAVPf/BYyegEwmA/vgJRP
         e0MLEPQ9frUkD2h4gz9ke3CR2M5bGOZ1u2m/gtM5Kf0A1QktAN+Urq3wBzvl+PCFyQTj
         wZJJagkq28ZqNjga4a1ZWR38XO3zwHnKVxCK6IhWwUsfLJYl9Yy19vP4xcDPasCe9FEL
         9Uz7/HDSKREWuvwEB3w4eSBMSEbyYbN89JS85Pw2JszS0Ll3htxQud3MLxSeR/GwPANi
         wssB1HsfIvIuyhPDo8trON2nnH104XwXHM8Q5JYqnStRqYoYJwws1zZiGuJKSyJj5yxX
         hRgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=x2hpnS67b7Pd2Ec56U22LLJIvAsb9f2puADLliDF4yU=;
        b=FP+6y5JRTiJDAxrktU+5HEIjz+jrievhJMsqztPH0I3vlYB7xp+oosG679Yb7W9iJt
         q5NQBtv+E+izgL/TfLvGkToPPKGOgbxpcNZmL5wvgr/A5Me4iZoY/U3/ubG6La8EX3Y5
         qI2j793uMKT2z1xWhdeQ5n0Zazdcnk6RVxwPLYABMLAqEeXfpL4dGXIcQXl2MR9LUYUy
         6IrtuszbnUjsGwbJoeNb2AabOxBIYuaMdK6sU5EwA7kb1H18MNk0+znqt1VwAU+o9VHW
         rhAD9/72BLsfsInenMc1XQGFTV0ss33Vga0Vht0g0TVCJk5TG+ZXLzATu1QeOh3yslTH
         0hiA==
X-Gm-Message-State: AOAM533PHLQnfmArMsDdsu4Aiwlv68oUTPDQxJAcPrSG1y98rgehbGSX
        beRPXseB029g2N+Zpr0iE2JZEBpfRHsjoA==
X-Google-Smtp-Source: ABdhPJxoezUtv5Lv3uPqG3uTrEGenjvpfCfhHskJuRGqrspw29zLOakp1pZsjsQfTWCf7rBZGXyhLg==
X-Received: by 2002:adf:ce8f:: with SMTP id r15mr3508121wrn.543.1644437797326;
        Wed, 09 Feb 2022 12:16:37 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id a13sm3735126wmq.28.2022.02.09.12.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 12:16:36 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Rui Wang <wangr@lemote.com>,
        Huacai Chen <chenhc@lemote.com>,
        Xi Ruoyao <xry111@mengyan1223.wang>,
        =?UTF-8?q?Dan=20Hor=C3=A1k?= <dan@danny.cz>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Timothy Pearson <tpearson@raptorengineering.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH for-5.10] drm/amdgpu: Set a suitable dev_info.gart_page_size
Date:   Wed,  9 Feb 2022 21:16:24 +0100
Message-Id: <20220209201624.1234062-1-carnil@debian.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

commit f4d3da72a76a9ce5f57bba64788931686a9dc333 upstream.

In Mesa, dev_info.gart_page_size is used for alignment and it was
set to AMDGPU_GPU_PAGE_SIZE(4KB). However, the page table of AMDGPU
driver requires an alignment on CPU pages.  So, for non-4KB page system,
gart_page_size should be max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE).

Signed-off-by: Rui Wang <wangr@lemote.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Link: https://github.com/loongson-community/linux-stable/commit/caa9c0a1
[Xi: rebased for drm-next, use max_t for checkpatch,
     and reworded commit message.]
Signed-off-by: Xi Ruoyao <xry111@mengyan1223.wang>
BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1549
Tested-by: Dan Horák <dan@danny.cz>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[Salvatore Bonaccorso: Backport to 5.10.y which does not contain
a5a52a43eac0 ("drm/amd/amdgpu/amdgpu_kms: Remove 'struct
drm_amdgpu_info_device dev_info' from the stack") which removes dev_info
from the stack and places it on the heap.]
Tested-by: Timothy Pearson <tpearson@raptorengineering.com>
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index efda38349a03..917b94002f4b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -766,9 +766,9 @@ static int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file
 			dev_info.high_va_offset = AMDGPU_GMC_HOLE_END;
 			dev_info.high_va_max = AMDGPU_GMC_HOLE_END | vm_size;
 		}
-		dev_info.virtual_address_alignment = max((int)PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
+		dev_info.virtual_address_alignment = max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
 		dev_info.pte_fragment_size = (1 << adev->vm_manager.fragment_size) * AMDGPU_GPU_PAGE_SIZE;
-		dev_info.gart_page_size = AMDGPU_GPU_PAGE_SIZE;
+		dev_info.gart_page_size = max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
 		dev_info.cu_active_number = adev->gfx.cu_info.number;
 		dev_info.cu_ao_mask = adev->gfx.cu_info.ao_cu_mask;
 		dev_info.ce_ram_size = adev->gfx.ce_ram_size;
-- 
2.34.1

