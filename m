Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB636ECBB0
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 13:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjDXL60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 07:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjDXL6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 07:58:25 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C87DB
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 04:58:24 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-2febac9cacdso2585025f8f.1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 04:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682337502; x=1684929502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFHzMsMW76DSl9C2dyTdzN582hf5x6HPrVYtej5rH58=;
        b=hyzrTnZpZyHmEoRMAiyNuMGUFhm9K1I9gGScYMinHU4HlbHqQ+2sFf/J9L2CH/e3Kg
         JYf46T8dL4KurjdNv/puxUPvU+rnildgKGnuyrbzd2Tjcq7Rgnvef8fpCL2SNuwhQL2q
         WBbisz97/0GEQadSmxhJ3//rlC4CgeeKGKHiszfeI3R5DfE1m95wU1KbJv7WaQ12bxTq
         RE0T/jHom+Qg/sz2PpFTstIVTn2EKxbZxW8kD1PDAIefaIZKkSuj1bpem6u3f7FfKT42
         hFMVacjuIc9pAoRneUixGOrVyEtYcrFqPGuKDQkSjI9C5BMA1zkcolfoweY70OVuFg0y
         OP0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682337502; x=1684929502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mFHzMsMW76DSl9C2dyTdzN582hf5x6HPrVYtej5rH58=;
        b=HPV0dHiRtmbmFUtu1yAsCg+l2MPrcmzPR3im5YDEP7wnRnmi+WTAXF1jEUjnk0gnQc
         ZdnXU34ycb3fvm2GDDwQ2+x+8h1NURZPJTV/kwvPzvzfXqsW5c9d8bPu0h/uYJdntRE6
         xzftuhNMiIKyG6wwJuHXEVSlr17N6cYCMRxUWenoL89gHk1FAIFZdd2bSQSU86Ai/mXf
         yvSNk8kwtbWqYD6aupTiM+e4ORrxgjTXZFdqkcM/R2erEVZLHP3EAl8IfoGaMom+XzGY
         hncynrf6s5jhvI/oWc3AVtYsodTq/Ixie+2bC7fKs9X3GUTQjSkn7vJKhY+cLlQ8HuQ9
         R2HA==
X-Gm-Message-State: AAQBX9ekxpRpZYydJaxn7tLMYn3uTjpDGHu+o1x/1+fYdmm7hvuGFskG
        w/4JkMEYEF3BNQTMc2wNVrB1w90uON+SeVbT4aw=
X-Google-Smtp-Source: AKy350aGzqVF26xJZkNFO/ac4nANoidAfjayniTNjsqVJK1USAkDC1jzI9WO3OAipBo16a5x+/v8jQ==
X-Received: by 2002:adf:f3d0:0:b0:2cf:efc7:19ad with SMTP id g16-20020adff3d0000000b002cfefc719admr10283660wrp.53.1682337502620;
        Mon, 24 Apr 2023 04:58:22 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id e14-20020a5d500e000000b002cff0e213ddsm10588097wrt.14.2023.04.24.04.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 04:58:22 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     stable@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 5.15.108 2/3] [ Upstream commit f1581626071c ]
Date:   Mon, 24 Apr 2023 13:56:17 +0200
Message-Id: <20230424115618.185321-3-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230424115618.185321-1-alexghiti@rivosinc.com>
References: <20230424115618.185321-1-alexghiti@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

riscv: Do not set initial_boot_params to the linear address of the dtb

early_init_dt_verify() is already called in parse_dtb() and since the dtb
address does not change anymore (it is now in the fixmap region), no need
to reset initial_boot_params by calling early_init_dt_verify() again.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: <stable@vger.kernel.org> # 5.15.x
---
 arch/riscv/kernel/setup.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index f874fe07fb78..8cc147491c67 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -286,10 +286,7 @@ void __init setup_arch(char **cmdline_p)
 #if IS_ENABLED(CONFIG_BUILTIN_DTB)
 	unflatten_and_copy_device_tree();
 #else
-	if (early_init_dt_verify(__va(XIP_FIXUP(dtb_early_pa))))
-		unflatten_device_tree();
-	else
-		pr_err("No DTB found in kernel mappings\n");
+	unflatten_device_tree();
 #endif
 	misc_mem_init();
 
-- 
2.37.2

