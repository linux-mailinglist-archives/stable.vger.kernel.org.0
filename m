Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618CB4C6581
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 10:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbiB1JNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 04:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiB1JNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 04:13:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B631132041
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 01:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646039584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9iIrm7jUNpWbOi4sKM9xr95M8UqXaHC8CNPDjaA3Rd4=;
        b=fmqzgiI1u3D4FJp9KxAXQAXbyp03ppZAzXzXRB9fTkB/ZDqpSv27PbKXfqNrn4AFdD/lE9
        OxuBltAf9xQ7JXziOrlKimU7TzoybNhY8dmVL5ApmRBR/4fUKxAqtadJayF/AHUEbv5PIB
        BzD7GAkjykdcFi0lXnlPW7Y3baXw20A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-MBlMiBNLOgureUyUX6qb2g-1; Mon, 28 Feb 2022 04:13:03 -0500
X-MC-Unique: MBlMiBNLOgureUyUX6qb2g-1
Received: by mail-wr1-f71.google.com with SMTP id p9-20020adf9589000000b001e333885ac1so1807211wrp.10
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 01:13:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9iIrm7jUNpWbOi4sKM9xr95M8UqXaHC8CNPDjaA3Rd4=;
        b=Alca5T9QCgH6IOOVClldc6YJuHiNS1iBLsSljgr3D/w5YurawiyA84Rhf05UhE13su
         5cP2hS5Z/PdPp4oWbFjfT16XSl1XEiI2noOXDHcUbZDrDhHNU/4Tex+N7g2IKaNq95Tj
         fXUuZCeMQmxI9ymV3brTIPSdXWhVi6cRyCxzNaxl9FZspwqLaRnWh7AOee4376dYA0pg
         YfuweeyIGAUIdx6ZM4Nj96KRb1gCxxdoMu8kwZyao5KqRhm8PHlLzi+EU1eClJklfeNw
         FvPF+rkoUFNViyvbXAMoq4tmL+JxBuuEBzvc6RRKbqkjHwnjqwG0jtVRKpSrtYCu1yIj
         JC/w==
X-Gm-Message-State: AOAM533R+K1PUecYd2jPbf6ru2LkjzWk0tm7kEcYb+fN5732uYfohHQC
        PwOiEpmHkkm9mvqmJVm6/2MCzfSN/Y/Y7K0AfMfPnIv16c8aejhceY8mT2mWhzt+KxbXy/yzVcz
        cOohF2M8n/GU3vkMpTbcd0roQ7y1CoI6C1x+AkVNIhykL/nx9aJ9vRs2R6YHEVl5EtPQ=
X-Received: by 2002:a5d:47a5:0:b0:1e8:88b3:16b7 with SMTP id 5-20020a5d47a5000000b001e888b316b7mr15358800wrb.417.1646039582304;
        Mon, 28 Feb 2022 01:13:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwyiC6VdfBtJFx/nf7vo5YK6s31W+jtjjwm+T+JxE7pWjeW+95YY22Xj5xB5kG+PadYBUTN2w==
X-Received: by 2002:a5d:47a5:0:b0:1e8:88b3:16b7 with SMTP id 5-20020a5d47a5000000b001e888b316b7mr15358782wrb.417.1646039582044;
        Mon, 28 Feb 2022 01:13:02 -0800 (PST)
Received: from kherbst.pingu.com (ip1f10bb48.dynamic.kabel-deutschland.de. [31.16.187.72])
        by smtp.gmail.com with ESMTPSA id u25-20020a05600c211900b003817667ab55sm1192630wml.33.2022.02.28.01.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 01:13:01 -0800 (PST)
From:   Karol Herbst <kherbst@redhat.com>
To:     stable@vger.kernel.org
Cc:     Karol Herbst <kherbst@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH] Revert "drm/nouveau/pmu/gm200-: avoid touching PMU outside of DEVINIT/PREOS/ACR"
Date:   Mon, 28 Feb 2022 10:12:59 +0100
Message-Id: <20220228091259.996188-1-kherbst@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit c9ec3d85c0eef7c71cdc68db758e0f0e378132c0.

This commit causes a regression if 4cdd2450bf739bada353e82d27b00db9af8c3001
is not applied as well. This was fixed for 5.16, 5.15 and 5.10.

On older stable branches backporting this commit is complicated as relevant
code changed quite a bit. Furthermore most of the affected hardware barely
works on those and users would want to use the newer kernels anyway.

Cc: stable@vger.kernel.org # 5.4 4.19 and 4.14
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Link: https://gitlab.freedesktop.org/drm/nouveau/-/issues/149
Signed-off-by: Karol Herbst <kherbst@redhat.com>
---
 .../gpu/drm/nouveau/nvkm/subdev/pmu/base.c    | 37 ++++++++-----------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c
index 105b4be467a3..ea2e11771bca 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c
@@ -88,13 +88,20 @@ nvkm_pmu_fini(struct nvkm_subdev *subdev, bool suspend)
 	return 0;
 }
 
-static void
+static int
 nvkm_pmu_reset(struct nvkm_pmu *pmu)
 {
 	struct nvkm_device *device = pmu->subdev.device;
 
 	if (!pmu->func->enabled(pmu))
-		return;
+		return 0;
+
+	/* Inhibit interrupts, and wait for idle. */
+	nvkm_wr32(device, 0x10a014, 0x0000ffff);
+	nvkm_msec(device, 2000,
+		if (!nvkm_rd32(device, 0x10a04c))
+			break;
+	);
 
 	/* Reset. */
 	if (pmu->func->reset)
@@ -105,37 +112,25 @@ nvkm_pmu_reset(struct nvkm_pmu *pmu)
 		if (!(nvkm_rd32(device, 0x10a10c) & 0x00000006))
 			break;
 	);
+
+	return 0;
 }
 
 static int
 nvkm_pmu_preinit(struct nvkm_subdev *subdev)
 {
 	struct nvkm_pmu *pmu = nvkm_pmu(subdev);
-	nvkm_pmu_reset(pmu);
-	return 0;
+	return nvkm_pmu_reset(pmu);
 }
 
 static int
 nvkm_pmu_init(struct nvkm_subdev *subdev)
 {
 	struct nvkm_pmu *pmu = nvkm_pmu(subdev);
-	struct nvkm_device *device = pmu->subdev.device;
-
-	if (!pmu->func->init)
-		return 0;
-
-	if (pmu->func->enabled(pmu)) {
-		/* Inhibit interrupts, and wait for idle. */
-		nvkm_wr32(device, 0x10a014, 0x0000ffff);
-		nvkm_msec(device, 2000,
-			if (!nvkm_rd32(device, 0x10a04c))
-				break;
-		);
-
-		nvkm_pmu_reset(pmu);
-	}
-
-	return pmu->func->init(pmu);
+	int ret = nvkm_pmu_reset(pmu);
+	if (ret == 0 && pmu->func->init)
+		ret = pmu->func->init(pmu);
+	return ret;
 }
 
 static int
-- 
2.35.1

