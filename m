Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BD66ECBB2
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 13:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjDXL72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 07:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjDXL70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 07:59:26 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38734F1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 04:59:25 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f09b4a1584so28744415e9.2
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 04:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682337563; x=1684929563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d4NMcU+HPYOFJcc88ZkgRvpd7Vkaq/ltuMTc9jzZ0w4=;
        b=X8yRX5sooTjmQ/5nhDRFL2WefKhmxH5V7+2VQ20zNagD/mJZi9Zft9xkdgbM1MipXk
         6IJguYEeJTxGfmR/T5QTOVCiSvA1XuQL4rYKLFpXxoGPh+8Wo563lJiwwkPEbyoou6k5
         e3optz7/RotaHAdZqyuxve+7aZ+C5552Cjanu3iegoEBnaK0Wb2QlxIpff2a/BbI2eHy
         PBQgCcB2Dv25QaXbGi6B2ccyNMrfT7zO/6LoGQJ/miPbsCw8ubDKirLrFhsdBpP17fmW
         4NxggghJcc5mH6A4C8iTKa3TBW/pC6KYhT4V4vkc2yvEMFbp8iyzjmA3+NEySvwd/noB
         4YAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682337563; x=1684929563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d4NMcU+HPYOFJcc88ZkgRvpd7Vkaq/ltuMTc9jzZ0w4=;
        b=ZKaljJOythainF9RjZY591BuxDpxnspEtJFx3MKg58mxvRf2TS427ictN61/ngcEH8
         z7zfaG7zfFKRkRBQ+fhktIywlHfgLf9kR81SXDna2R7g7f4+1OIG9XurUfZgry2uYs4n
         +l1YgDLVV5H3kJ08GXsCUHN63JuX0C6TncIvLtadC0VLDf5klSwXDjP93S/P9eSFPYjF
         chnRPECBNJmuzcGI0CKY/MinlD7KC3vtcG2f3kULYJ5F5+PvZ81cZ/iDv/Qage6YW+hZ
         oFv/WQP/QuGPq5XcI3mGIrtLj9q8AmIuDiMf2lwZNmnFPssioDmBcZCLlF/tijpxGyN0
         /GdQ==
X-Gm-Message-State: AAQBX9elNR7WRUa7veRG7oepLPK+NVBmkHrMVjLPaItgITdJj7CGu8ow
        XShMXwj0dCjmWKk8SmjzW/dJg9Oc96TfEUKHDl0=
X-Google-Smtp-Source: AKy350YMO3HoJ8yWfFqbci4aQqq/F4Xh3w3zBzoPmW0DIqM8FEerIJ+18zh883j2Yw3Xfj9K0tllaw==
X-Received: by 2002:a7b:cbcb:0:b0:3f1:6faa:d94c with SMTP id n11-20020a7bcbcb000000b003f16faad94cmr6937817wmi.16.1682337563338;
        Mon, 24 Apr 2023 04:59:23 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c181000b003f046ad52efsm15330968wmp.31.2023.04.24.04.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 04:59:23 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     stable@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 5.15.108 3/3] [ Upstream commit 1b50f956c8fe ]
Date:   Mon, 24 Apr 2023 13:56:18 +0200
Message-Id: <20230424115618.185321-4-alexghiti@rivosinc.com>
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

riscv: No need to relocate the dtb as it lies in the fixmap region

We used to access the dtb via its linear mapping address but now that the
dtb early mapping was moved in the fixmap region, we can keep using this
address since it is present in swapper_pg_dir, and remove the dtb
relocation.

Note that the relocation was wrong anyway since early_memremap() is
restricted to 256K whereas the maximum fdt size is 2MB.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: <stable@vger.kernel.org> # 5.15.x
---
 arch/riscv/mm/init.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 3f62ff02efc4..e800d7981e99 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -229,25 +229,8 @@ static void __init setup_bootmem(void)
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

