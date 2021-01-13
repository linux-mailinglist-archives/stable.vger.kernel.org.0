Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8C92F4E7B
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 16:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbhAMPY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 10:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbhAMPY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 10:24:58 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F8FC061794
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 07:24:17 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id z9so1302886qtn.4
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 07:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c38Z3i7wyqZ2AoBI7tMokj5G+FD83lVpzKyX+ujthQE=;
        b=FK2GjKpSfz0g7Vf79H4YtLu6Lbmp5KXq3ElRfpnYA3K3pD79Rm008OTv0sr2R7zdxD
         f4dVCpUo2L0BKcw/2Z/sOmL8ziLQFcuLN+NVkLeswOfva4jBPLrrk1DrEd0miCxFNNue
         wIk+Q7sFxYcIiUyyxg2rnTqYs5wvv1AOmwo8Xg2mpq/VegOj6ah/bhZNPm1aLG9aq3dD
         4mYYBhUE208bIAV8VxQLaBAVVQzEsxAiM9NVWYWKai/vNvcNfWlEjewAjE2O+CQqiECJ
         JlKFlkvhH8Ed7IeGJQZDi8ZpjTt9UO7crKN6sCVHtXKlw6OYeMfCXBCVbuUXHd/UobSu
         HoTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c38Z3i7wyqZ2AoBI7tMokj5G+FD83lVpzKyX+ujthQE=;
        b=i8Vf8pfZ4DOWbS+8sMfHdQCAQjr+Z2Sfiacso/oIJ3puu4ZLdvMEqh4b+r3UuLz7lY
         6gg8hN78q9DAAHg4CVT8elqotIVVwJpBRe9UVtLTSfjiuDGxED9NcO4jHLGgueXro6KI
         Ob2IHZGcNivBO9qSN2hHQUq67hxnjcKoTSNipNz9Ijmoy1WX8lKnhLOtm26kI7Ai16ms
         yQ+tCbvGvcSBC0AhgL4GCFG2P2tzoaVoIl0vpYn21M+PXh2LMbptxnfJUzmcrxcp+0mg
         i7QSd7q5y4Xsczjs5BGEp4318f63GWGfbNklSJ2nmuew0nxQWM9G9nrrnChW5gqT8HSh
         i/Ew==
X-Gm-Message-State: AOAM533DDVI6gj9AhTLYmfn/yIQzq9Bx0Hkc+ioDRNagSWB5vzlhjQZo
        x66baqLzQ1sdxdlRJ98TYTo=
X-Google-Smtp-Source: ABdhPJxog0RY4/gPFi5VrfiXtsBLniSRb6PidBca+m21BM7BmqTgRdl+TKedjJGIlD2fLztsz/qYlA==
X-Received: by 2002:ac8:2a8f:: with SMTP id b15mr2685491qta.33.1610551456984;
        Wed, 13 Jan 2021 07:24:16 -0800 (PST)
Received: from localhost.localdomain ([192.161.78.241])
        by smtp.gmail.com with ESMTPSA id i3sm1159827qkd.119.2021.01.13.07.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 07:24:16 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     mengwang <mengbing.wang@amd.com>, Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] drm/amdgpu: add new device id for Renior
Date:   Wed, 13 Jan 2021 10:24:04 -0500
Message-Id: <20210113152404.1307212-2-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113152404.1307212-1-alexander.deucher@amd.com>
References: <20210113152404.1307212-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: mengwang <mengbing.wang@amd.com>

add DID 0x164C into pciidlist under CHIP_RENOIR family.

Signed-off-by: mengwang <mengbing.wang@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.10.x
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 1 +
 drivers/gpu/drm/amd/amdgpu/soc15.c      | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 6a402d8b5573..3f0f3ce2611c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1086,6 +1086,7 @@ static const struct pci_device_id pciidlist[] = {
 	/* Renoir */
 	{0x1002, 0x1636, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
 	{0x1002, 0x1638, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
+	{0x1002, 0x164C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
 
 	/* Navi12 */
 	{0x1002, 0x7360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI12},
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 9a25accd48a3..2396be16c28e 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1204,7 +1204,8 @@ static int soc15_common_early_init(void *handle)
 		break;
 	case CHIP_RENOIR:
 		adev->asic_funcs = &soc15_asic_funcs;
-		if (adev->pdev->device == 0x1636)
+		if ((adev->pdev->device == 0x1636) ||
+		    (adev->pdev->device == 0x164c))
 			adev->apu_flags |= AMD_APU_IS_RENOIR;
 		else
 			adev->apu_flags |= AMD_APU_IS_GREEN_SARDINE;
-- 
2.29.2

