Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287296ED0CE
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 16:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjDXO6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 10:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjDXO6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 10:58:22 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A48EA
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:58:21 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f19ab994ccso23475645e9.2
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682348300; x=1684940300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TidUDDdUKAUYvYjHcJ5ZX2inr8rKWBrXmkLzNnyVUPg=;
        b=a4l07CV716xR19lJMn/Ake3d6dKilDwHyxYJnidZ9gqJj/5Zepvu1yMegw0X7YdyQz
         GHpuZ7RZdr/F2WcZPxOno7vl0PxG9YF8ydXwSAh/sCPeFcD0m/vAGtyKfaP2kyewwprk
         EXEl1hsTWPiKVxe6bc2SqQ1OvsGHrYMc+QyGAfJrl4McjVw8H99fX+dV5yKBw04Qh12P
         2RMbQtEInNc2m8XTunSS+NoSBxflriCUE79sz1pIbHYCRrrP3iUxKX7VtIfIRtqMPNR/
         /ozaSRSsLnDVDmNvJgQq67iwutUvUWRHpr/7dAqYK8MJ+AAgU7I67+S9wRTjk3GUA/zi
         f2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682348300; x=1684940300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TidUDDdUKAUYvYjHcJ5ZX2inr8rKWBrXmkLzNnyVUPg=;
        b=H1KZQNYX0w0WYpPKxiqEUnqK7EjV2L1Zpum/lchcaf3oYxB4oxDx7VWHohp1Abu8tW
         yc0h8DpUoSJ6CM/O6fgHWVdJAE9l9dt1uZikDMzL5clq6VGbazCHRLXWnSWlzCoyFun5
         UGIfQdCZEAcXtbdRygQ1/s3ztqLAC/B7FCy6E0zZ28pUkSA0uOVPL8er96xI/LZg9UAr
         avtylfD+kbJKN4eVu3ptanEqXQicaeFLXVdfvObRHJGAN5R7dJItDLtMWFKBR1fuOhaK
         XnCP7bFz1REANxBseSymzRG+GUc3nflUzJVytbvl671YYNBY2+q0GohffKkC4X+HWPYr
         zzyw==
X-Gm-Message-State: AAQBX9ftLqzwaAN+y3eWKfEu7bXBy1d22/+cieTA89O7Vxv79XPf+Xq8
        Taobp5rqzBjN93muWACf+hjTnaXIhRPFGaN5lxc=
X-Google-Smtp-Source: AKy350bfAlUuUdCv7erGIkgs3B5S2luX9qi6XYQ8YG/jgu5ap4B261vkQOLd9+JJFjioKE8BJcgxHg==
X-Received: by 2002:a7b:c4d9:0:b0:3f1:969f:c9d0 with SMTP id g25-20020a7bc4d9000000b003f1969fc9d0mr5886489wmk.4.1682348300176;
        Mon, 24 Apr 2023 07:58:20 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm21408772wmq.1.2023.04.24.07.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 07:58:19 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     Conor Dooley <conor.dooley@microchip.com>, stable@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 6.1.24 3/3] riscv: No need to relocate the dtb as it lies in the fixmap region
Date:   Mon, 24 Apr 2023 16:55:02 +0200
Message-Id: <20230424145502.194770-4-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230424145502.194770-1-alexghiti@rivosinc.com>
References: <20230424145502.194770-1-alexghiti@rivosinc.com>
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
Cc: <stable@vger.kernel.org> # 6.1.x
---
 arch/riscv/mm/init.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 5570c52deb0b..6f47ced3175b 100644
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

