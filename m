Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5DB5B63D2
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 00:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiILWsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 18:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiILWsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 18:48:52 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2974C4BD11
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 15:48:50 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n23-20020a7bc5d7000000b003a62f19b453so12106427wmk.3
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 15:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=conchuod.ie; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=9KCdo9lEuUaqKqwMXjhpto5xxER15Dg2P7AblY4ZDe0=;
        b=cQaD9eD54KsMjT0fZLrz+25LvzBtE5KCcQjubrd/mdty2QdT54ynOutS3DpnJguXd1
         RYT7Zu33ADETg1FnC4tSIrz0oMCff+1qD1M6C3nt2YjBGeY1zuPLW1tDgBzazf9qGuAH
         2/VgY7r7DqOZlHQ2Us1cCgaxZMUk+tb0Y/AOwZOIpmKKQn6+5nizrSV5PwPvbA4OqEkx
         O+BGdUtdp6fKwM2Bw8AyMqMTmK9bMup9VjymS9SMegUU1bLgom6P5UggtgE0hlIgaEmB
         sV1i8LJ1tkD0LAqshEhiY0a9E7ge/ImKs0BVwOW2zxCfCYi+reOxt9Avi3G/ivlLc1Sn
         CDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=9KCdo9lEuUaqKqwMXjhpto5xxER15Dg2P7AblY4ZDe0=;
        b=U6Yist9xFNMUbppbXvHX96/KPZD/CkCxW0pNAjsRAJs//8N6Jd4QHcAtCFe2S4kq1R
         rBjV0FXV1SRYvTO5DLqxMc+tofXZAHsK2++AVGdEgy0kvaFkCee89VE8NjWzWqzPpRws
         IXeUDSW8MW5oVWzZ0X8dfXM1luw66626J9HU3RzqHgkk8yvq4Y1lCj4RA6w4G8j4MOvp
         oo8jCjxFpYz0x15TZZxacudcbo1qK4cb55P3SDnowXhjDp/p5fIFWcW0aUnElu9tJ/ew
         ZvwQux8Rj+8+h5A3Iy7mOXlVPsL1P4jJZuKIK2KpDwXRVuY1jKlh2arAX1YoavwItq7m
         Ui/Q==
X-Gm-Message-State: ACgBeo2uYVDCy3TtgJC6Xf1qm5zDu8BAwPy8LYpDHQmguJBQ/1oUMFwx
        cPvg5KM3yIET/Rbi6LewnHPIJA==
X-Google-Smtp-Source: AA6agR6N2w1b2dEfdlAV62nft6Zg0kHrtmttCBacmNAjiXFQe1Zt6oPGKzrGkW47+GTfSvhM/Q+58A==
X-Received: by 2002:a05:600c:1549:b0:3b4:8fd7:af4 with SMTP id f9-20020a05600c154900b003b48fd70af4mr348969wmg.100.1663022928645;
        Mon, 12 Sep 2022 15:48:48 -0700 (PDT)
Received: from henark71.. ([109.76.158.112])
        by smtp.gmail.com with ESMTPSA id f12-20020a05600c154c00b003a5f3f5883dsm12596876wmg.17.2022.09.12.15.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 15:48:48 -0700 (PDT)
From:   Conor Dooley <mail@conchuod.ie>
To:     atishp@atishpatra.org
Cc:     ajones@ventanamicro.com, anup@brainfault.org,
        conor.dooley@microchip.com, heiko@sntech.de, jrtc27@jrtc27.com,
        linux-riscv@lists.infradead.org, lkp@intel.com,
        mchitale@ventanamicro.com, nathan@kernel.org, palmer@rivosinc.com,
        stable@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v4] RISC-V: Clean up the Zicbom block size probing
Date:   Mon, 12 Sep 2022 23:48:01 +0100
Message-Id: <20220912224800.998121-1-mail@conchuod.ie>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmer@rivosinc.com>

This fixes two issues: I truncated the warning's hart ID when porting to
the 64-bit hart ID code, and the original code's warning handling could
fire on an uninitialized hart ID.

The biggest change here is that riscv_cbom_block_size is no longer
initialized, as IMO the default isn't sane: there's nothing in the ISA
that mandates any specific cache block size, so falling back to one will
just silently produce the wrong answer on some systems.  This also
changes the probing order so the cache block size is known before
enabling Zicbom support.

CC: stable@vger.kernel.org
CC: Andrew Jones <ajones@ventanamicro.com>
CC: Heiko Stuebner <heiko@sntech.de>
CC: Atish Patra <atishp@rivosinc.com>
Fixes: 3aefb2ee5bdd ("riscv: implement Zicbom-based CMO instructions + the t-head variant")
Fixes: 1631ba1259d6 ("riscv: Add support for non-coherent devices using zicbom extension")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
[Conor: fixed the redefinition errors]
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
Hey Palmer,
w/ LPC etc I figure it's highly unlikely you'd have this respun
in time to have it applied this week. I dropped all the tested
and reviewed -by tags since this patch has been changed a fair
bit back and forth since the tags were left. Checked it on my
D1 to make sure nothing blew up.. if this could make this weeks
rc, that'd be great so that the clang allmodconfig builds are
working again.
Conor.
---
 arch/riscv/errata/thead/errata.c    |  1 +
 arch/riscv/include/asm/cacheflush.h |  1 +
 arch/riscv/kernel/setup.c           |  2 +-
 arch/riscv/mm/dma-noncoherent.c     | 23 +++++++++++++----------
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/errata/thead/errata.c b/arch/riscv/errata/thead/errata.c
index 202c83f677b2..96648c176f37 100644
--- a/arch/riscv/errata/thead/errata.c
+++ b/arch/riscv/errata/thead/errata.c
@@ -37,6 +37,7 @@ static bool errata_probe_cmo(unsigned int stage,
 	if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
 		return false;
 
+	riscv_cbom_block_size = L1_CACHE_BYTES;
 	riscv_noncoherent_supported();
 	return true;
 #else
diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
index a60acaecfeda..a89c005b4bbf 100644
--- a/arch/riscv/include/asm/cacheflush.h
+++ b/arch/riscv/include/asm/cacheflush.h
@@ -43,6 +43,7 @@ void flush_icache_mm(struct mm_struct *mm, bool local);
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_RISCV_ISA_ZICBOM
+extern unsigned int riscv_cbom_block_size;
 void riscv_init_cbom_blocksize(void);
 #else
 static inline void riscv_init_cbom_blocksize(void) { }
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 95ef6e2bf45c..2dfc463b86bb 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -296,8 +296,8 @@ void __init setup_arch(char **cmdline_p)
 	setup_smp();
 #endif
 
-	riscv_fill_hwcap();
 	riscv_init_cbom_blocksize();
+	riscv_fill_hwcap();
 	apply_boot_alternatives();
 }
 
diff --git a/arch/riscv/mm/dma-noncoherent.c b/arch/riscv/mm/dma-noncoherent.c
index cd2225304c82..e3f9bdf47c5f 100644
--- a/arch/riscv/mm/dma-noncoherent.c
+++ b/arch/riscv/mm/dma-noncoherent.c
@@ -12,7 +12,7 @@
 #include <linux/of_device.h>
 #include <asm/cacheflush.h>
 
-static unsigned int riscv_cbom_block_size = L1_CACHE_BYTES;
+unsigned int riscv_cbom_block_size;
 static bool noncoherent_supported;
 
 void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
@@ -79,38 +79,41 @@ void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 void riscv_init_cbom_blocksize(void)
 {
 	struct device_node *node;
+	unsigned long cbom_hartid;
+	u32 val, probed_block_size;
 	int ret;
-	u32 val;
 
+	probed_block_size = 0;
 	for_each_of_cpu_node(node) {
 		unsigned long hartid;
-		int cbom_hartid;
 
 		ret = riscv_of_processor_hartid(node, &hartid);
 		if (ret)
 			continue;
 
-		if (hartid < 0)
-			continue;
-
 		/* set block-size for cbom extension if available */
 		ret = of_property_read_u32(node, "riscv,cbom-block-size", &val);
 		if (ret)
 			continue;
 
-		if (!riscv_cbom_block_size) {
-			riscv_cbom_block_size = val;
+		if (!probed_block_size) {
+			probed_block_size = val;
 			cbom_hartid = hartid;
 		} else {
-			if (riscv_cbom_block_size != val)
-				pr_warn("cbom-block-size mismatched between harts %d and %lu\n",
+			if (probed_block_size != val)
+				pr_warn("cbom-block-size mismatched between harts %lu and %lu\n",
 					cbom_hartid, hartid);
 		}
 	}
+
+	if (probed_block_size)
+		riscv_cbom_block_size = probed_block_size;
 }
 #endif
 
 void riscv_noncoherent_supported(void)
 {
+	WARN(!riscv_cbom_block_size,
+	     "Non-coherent DMA support enabled without a block size\n");
 	noncoherent_supported = true;
 }
-- 
2.37.1

