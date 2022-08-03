Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B4B588EA9
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 16:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbiHCO14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 10:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbiHCO1z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 10:27:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A2B21E3FE
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 07:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659536871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jMDeq5W3wuzFQptZuNbKzVBS/9VCgpXFXC4FBRH7hbo=;
        b=hhQV1T5917ME0kT1jYWolL2heT1ix+djeIEgdUGUpmB0NG9jPE8CC/lXEAiYigLUPk2QCb
        6/k8H3V5wpJ68SmzlHDyshQETRtWIuqRa5ksb6Gt+BG3T0Wd/C0N/2scAZacXSs4eOPbTP
        DVaKtrcHszwymOMKVXM9BC1MVKPc6YE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-uEeoFjf1P7qE9hIkssUi0Q-1; Wed, 03 Aug 2022 10:27:49 -0400
X-MC-Unique: uEeoFjf1P7qE9hIkssUi0Q-1
Received: by mail-qk1-f197.google.com with SMTP id i15-20020a05620a404f00b006b55998179bso13581107qko.4
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 07:27:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jMDeq5W3wuzFQptZuNbKzVBS/9VCgpXFXC4FBRH7hbo=;
        b=nj/il8ecKuu4+je8XzwpgMEoZtcZA2ty5bwW4XigsPkarUgRytTKF6KrAQ6FY6xUj6
         t0qIWVV23iv2letVYGDI9e3zRYO3LihQEPagGXjmWTXFE90vVsstCVIaUtsfxLkvQZAO
         eg5yviEnRa7izRoZCY/2siFW7maEl0QigFv5ymdJV2Zir/EfoQHJoK+yl4dsbCWl0HJE
         aO8j/+I3qO0FEelEQ1RzO+bvT4Y7RRaAZ4nUrg+2On/s0XACfkbHzcVZWur5Cx4X+URZ
         JCZUwK2JXydQYMCdjVp+Bj8pVQ1Vb2RUK16aUXdC6IITacSiMZBxgSyBQG7AFCFUiIZO
         l39Q==
X-Gm-Message-State: ACgBeo2WhhORNj1lZBQE5oT5n9tZZKwJjBmxeGkicxqFQlt5OWNBwTiE
        VCOuHJ9CwmHsL9obPTEgQEPsvpVspynhBz8anWolT8ZQ8J67TLi/i7XjfTyhUM03t/lt/QHzv7I
        7ebq01bbvG0zM796P
X-Received: by 2002:a05:6214:b6c:b0:476:8321:db81 with SMTP id ey12-20020a0562140b6c00b004768321db81mr12651661qvb.100.1659536868577;
        Wed, 03 Aug 2022 07:27:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7IlwlhOPpAaKuzndenntMKIemsZndWQNZCHgv70HCa/VmiEGcfUdUOkdlm30gAkODQ8TtTAg==
X-Received: by 2002:a05:6214:b6c:b0:476:8321:db81 with SMTP id ey12-20020a0562140b6c00b004768321db81mr12651642qvb.100.1659536868321;
        Wed, 03 Aug 2022 07:27:48 -0700 (PDT)
Received: from kherbst.pingu.com (ip1f10bb48.dynamic.kabel-deutschland.de. [31.16.187.72])
        by smtp.gmail.com with ESMTPSA id q31-20020a05620a2a5f00b006b8e8c657ccsm1121040qkp.117.2022.08.03.07.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 07:27:47 -0700 (PDT)
From:   Karol Herbst <kherbst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     nouveau@lists.freedesktop.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] drm/nouveau: recognise GA103
Date:   Wed,  3 Aug 2022 16:27:45 +0200
Message-Id: <20220803142745.2679510-1-kherbst@redhat.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Appears to be ok with general GA10x code.

Signed-off-by: Karol Herbst <kherbst@redhat.com>
Cc: <stable@vger.kernel.org> # v5.15+
---
 .../gpu/drm/nouveau/nvkm/engine/device/base.c | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
index 62efbd0f3846..b7246b146e51 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -2605,6 +2605,27 @@ nv172_chipset = {
 	.fifo     = { 0x00000001, ga102_fifo_new },
 };
 
+static const struct nvkm_device_chip
+nv173_chipset = {
+	.name = "GA103",
+	.bar      = { 0x00000001, tu102_bar_new },
+	.bios     = { 0x00000001, nvkm_bios_new },
+	.devinit  = { 0x00000001, ga100_devinit_new },
+	.fb       = { 0x00000001, ga102_fb_new },
+	.gpio     = { 0x00000001, ga102_gpio_new },
+	.i2c      = { 0x00000001, gm200_i2c_new },
+	.imem     = { 0x00000001, nv50_instmem_new },
+	.mc       = { 0x00000001, ga100_mc_new },
+	.mmu      = { 0x00000001, tu102_mmu_new },
+	.pci      = { 0x00000001, gp100_pci_new },
+	.privring = { 0x00000001, gm200_privring_new },
+	.timer    = { 0x00000001, gk20a_timer_new },
+	.top      = { 0x00000001, ga100_top_new },
+	.disp     = { 0x00000001, ga102_disp_new },
+	.dma      = { 0x00000001, gv100_dma_new },
+	.fifo     = { 0x00000001, ga102_fifo_new },
+};
+
 static const struct nvkm_device_chip
 nv174_chipset = {
 	.name = "GA104",
@@ -3092,6 +3113,7 @@ nvkm_device_ctor(const struct nvkm_device_func *func,
 		case 0x167: device->chip = &nv167_chipset; break;
 		case 0x168: device->chip = &nv168_chipset; break;
 		case 0x172: device->chip = &nv172_chipset; break;
+		case 0x173: device->chip = &nv173_chipset; break;
 		case 0x174: device->chip = &nv174_chipset; break;
 		case 0x176: device->chip = &nv176_chipset; break;
 		case 0x177: device->chip = &nv177_chipset; break;
-- 
2.37.1

