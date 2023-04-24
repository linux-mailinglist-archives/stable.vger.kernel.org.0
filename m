Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6F56ED0EE
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 17:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbjDXPHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 11:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjDXPHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 11:07:04 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D73F35AC
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 08:07:03 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-2f27a9c7970so4151995f8f.2
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 08:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682348821; x=1684940821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rvf0IP74Mz14efTiO3Gyrkowe8HF32ADbh3NFmcnePo=;
        b=mNrBcpmhFRAXhs2iUEVXD3t6L784GLu6+8+T9J+x/hn13F/EPaP0gTSEGE6hUdGYHO
         3QKs8TBW2KEsPzCn3mVALeVoAecVHNPLTpdLpFGFrFlWrYrcigxV+mFrmyzcBCijFXkA
         AEVPKjpTcSxmwP1BjAAX/gq0Go2yNOPqwn6HwMiqpQ4b5DhcLccDIydqB6nfqFTnevCq
         OnJv4A/PUPspVaXa/pWiSFvu7C6GeHLNibG+cwTrh/UQyHkjsid2ZH0vbG6iXmyyIPLJ
         /qxv+MAuKWB9ogwy3HTkrmKKPRzAWMRbTlJClGY1ERV1uBSzfbpQnD63oMhjzUE6Y2y8
         Uozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682348821; x=1684940821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rvf0IP74Mz14efTiO3Gyrkowe8HF32ADbh3NFmcnePo=;
        b=IReIsN7FjyyCRHEnQX//9fHzWiA+Gxgbk3fAxw2MNlFSWThYQPnkfRIjDf8XAUG/Pq
         cTV49KjCk0bwPipdt02rljDIUUzX2JLoCjLDm59WUkQpcG6cA9r0J40fzVkAXtIl+SUc
         LzVKYVw+/EcQ5k5wPl9YKIemsTUQAIiwYBvS3d0/UVEaslGrEY0b6OU+Hc56Zy8HwtfZ
         FAAo7FgHtY1EoPaquloWniCZJ1S6pHXJhOZY4P9tUfxt8HXL8h4zYNDibH9HmqOUYMOa
         74riB4jeW40g3QXDNr3N0vROpHk/wInBup2T0wZ4fScTp6OJCOs/Ems856IgxX2Ag56r
         akCg==
X-Gm-Message-State: AAQBX9f8786XRVogP7SuTAgn2qiXh4s1Q7M5AKda8XLVffElyT7Wvt06
        bSl7yXrNyKxmzK0FY1gzNjMXFg==
X-Google-Smtp-Source: AKy350Zvf57lVfPflPWoMgVEp2nen4Ii1Q9g8gPUpY1oRnXmApm1mjKK8fW5l4JaB1/6/8kquvzi5A==
X-Received: by 2002:adf:f7c7:0:b0:2d8:708a:d84 with SMTP id a7-20020adff7c7000000b002d8708a0d84mr10322679wrq.19.1682348821707;
        Mon, 24 Apr 2023 08:07:01 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id t10-20020a05600001ca00b002fab755e10bsm10943614wrx.68.2023.04.24.08.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 08:07:01 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     Conor Dooley <conor.dooley@microchip.com>, stable@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 6.2.11 3/3] riscv: No need to relocate the dtb as it lies in the fixmap region
Date:   Mon, 24 Apr 2023 17:03:54 +0200
Message-Id: <20230424150354.195572-4-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230424150354.195572-1-alexghiti@rivosinc.com>
References: <20230424150354.195572-1-alexghiti@rivosinc.com>
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

commit 1b50f956c8fe9082bdee4a9cfd798149c52f7043 upstream.

We used to access the dtb via its linear mapping address but now that the
dtb early mapping was moved in the fixmap region, we can keep using this
address since it is present in swapper_pg_dir, and remove the dtb
relocation.

Note that the relocation was wrong anyway since early_memremap() is
restricted to 256K whereas the maximum fdt size is 2MB.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: <stable@vger.kernel.org> # 6.2.x
---
 arch/riscv/mm/init.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index fb78d6bbabae..0f14f4a8d179 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -249,25 +249,8 @@ static void __init setup_bootmem(void)
 	 * early_init_fdt_reserve_self() since __pa() does
 	 * not work for DTB pointers that are fixmap addresses
 	 */
-	if (!IS_ENABLED(CONFIG_BUILTIN_DTB)) {
-		/*
-		 * In case the DTB is not located in a memory region we won't
-		 * be able to locate it later on via the linear mapping and
-		 * get a segfault when accessing it via __va(dtb_early_pa).
-		 * To avoid this situation copy DTB to a memory region.
-		 * Note that memblock_phys_alloc will also reserve DTB region.
-		 */
-		if (!memblock_is_memory(dtb_early_pa)) {
-			size_t fdt_size = fdt_totalsize(dtb_early_va);
-			phys_addr_t new_dtb_early_pa = memblock_phys_alloc(fdt_size, PAGE_SIZE);
-			void *new_dtb_early_va = early_memremap(new_dtb_early_pa, fdt_size);
-
-			memcpy(new_dtb_early_va, dtb_early_va, fdt_size);
-			early_memunmap(new_dtb_early_va, fdt_size);
-			_dtb_early_pa = new_dtb_early_pa;
-		} else
-			memblock_reserve(dtb_early_pa, fdt_totalsize(dtb_early_va));
-	}
+	if (!IS_ENABLED(CONFIG_BUILTIN_DTB))
+		memblock_reserve(dtb_early_pa, fdt_totalsize(dtb_early_va));
 
 	dma_contiguous_reserve(dma32_phys_limit);
 	if (IS_ENABLED(CONFIG_64BIT))
-- 
2.37.2

