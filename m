Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3646ED0B2
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 16:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjDXOvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 10:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjDXOv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 10:51:29 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04E67A8F
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:51:05 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f196e8e2c6so27823815e9.1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682347864; x=1684939864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGQUzEQ096BATi1D4ce79kUz4IIA6PFwxKUkUtGSYxI=;
        b=t66T013/2oQzQC/Y3JGKIkmIwDNxfc4f2wQu+fMk0jZ0Z6xVMdzp2YXE7Cnc8fYiz9
         ef/7Ym5Ove9UAXFzDiFRZNl+R7IeWKARiVYTvaLPz26G6rlQnnXRB+NsdHUghi67yR86
         xcUW/qlY/FhtEVPDTTUarjq6F9lFf4+B0RKXqB4oARitM4OJDYxmgZvNsp5hRvzM27c5
         GEZelYutifvF6SHxlBxJt0DY4/ONttVp+JsqhocBSQ7jTmhSyWeKCIjNvdoPQER+ZSLA
         LK3IobCDcdX+kMTspckLW5VACT+9Tbz8UsmKIrCXBfwJTGYszyP57YsAl5fhh6ED2F8X
         KqBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682347864; x=1684939864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rGQUzEQ096BATi1D4ce79kUz4IIA6PFwxKUkUtGSYxI=;
        b=b7YpZA09vwbOhaQv7G2by9cWvqzVtV+eqf+fbwSW412aau7jZs38qDYypFW2PtCK/X
         sD4PdLsGSKqLCvcxgbVskA/oXgS5Sb5Rv+LDr3Ot/pKsnQ/SrwXXoY3IKrGyLDqvyo1k
         mM7gyi4QCs9ZqgHapVM7yL9BJb9GVS8sttPlG1wIFFvWRS6s9xNzdjKuNJmlV5HJ1cf9
         AvjLyOZ3TskQm7mDHdBOvvHj3D8TNyJl6PXG8tiKXqU1gcfcSrJ+7kAO2Jp/LZASBYkN
         RYdbFO1uawkqpGVvf32Hl6qIrB3TTs4LuPA/UV43L2sFKWwy+NrCq4wkFZEIYCfmeK9l
         uatg==
X-Gm-Message-State: AAQBX9eo5waNN6a75aV6xzexQRMQdYL9eQjG/MvKo5J20BzE+6oXjpsy
        cVGdExtofOGyHEig3ML7byxDJA==
X-Google-Smtp-Source: AKy350bfkocrg1wyp4C0wqz/KX926XwNOS5FQ2Wq673DzFdy8zhmBP8ua+ZSyXjR+9Yu7HMwQivFpg==
X-Received: by 2002:a5d:69d0:0:b0:2f7:63f9:6cd3 with SMTP id s16-20020a5d69d0000000b002f763f96cd3mr9271114wrw.33.1682347864114;
        Mon, 24 Apr 2023 07:51:04 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id v17-20020a5d43d1000000b003047ea78b42sm1571087wrr.43.2023.04.24.07.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 07:51:03 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     Conor Dooley <conor.dooley@microchip.com>, stable@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 5.15.108 v2 3/3] riscv: No need to relocate the dtb as it lies in the fixmap region
Date:   Mon, 24 Apr 2023 16:47:37 +0200
Message-Id: <20230424144737.194316-4-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230424144737.194316-1-alexghiti@rivosinc.com>
References: <20230424144737.194316-1-alexghiti@rivosinc.com>
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

