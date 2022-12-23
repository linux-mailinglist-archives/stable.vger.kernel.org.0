Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7B8654FB3
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 12:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbiLWL2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 06:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235667AbiLWL2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 06:28:05 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D0D6332
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 03:28:03 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id gh17so11438187ejb.6
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 03:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rammhold-de.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lFeknuNwkrG7RSqHcx+1XNwP++s/iRA1VEaVxTgmg4g=;
        b=hBbGx/sx0Xtj3qyO2DnwolsWWeXvKKEA29FnQw2uFnuLWUqZyGEpIfLpeWpV5eFEyH
         HnvlBU4V1TXDCd5xvURIoA5VkDtmPHJRz7lpADizpMIQVg13g9TmNN0ynsnj2dvANv0r
         lFdto2x+Zx78dAFxjFeyokkwCapQ6p9krN0nzxWGqRkR+aOZIs+jlLlVPEKT4goFw2VS
         fOO+zEEeKYzFog9V1fNbWRx9i9doTd966dDU8OLs5Wwci0rCIOQbCLQIdpcOGYzvG41i
         n70HL3EZVXV998EVqgv/IBFVODy3wTN1a0neae1iRlrsQHoAZf09UrrBMPIc6oVlTV0a
         dwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lFeknuNwkrG7RSqHcx+1XNwP++s/iRA1VEaVxTgmg4g=;
        b=O9VOeOZZs94yVmSA8jUC3/wy/Pj+o/6t5CCUTv4VpHB4PuGd5/EABxKJgLSFO4Bu90
         MEC3TK1aq/i+g6EKumajms0qPATYCVN1T/H9w+J3izpastdCJR3kNfgNOogX7AsGDF0v
         cQ3ZYfZlcUrdsVgg3NB14Agy/BuG06RDlWpw8Zdb5+/XlLNYVJEFiQM54/RmITp3fTXD
         eE5VDqKDaVqdGPY4JqX9/1Rj056OGadfV6elNiOAKH63HpNoD+VwOkS77u7QIuLle0JA
         HmfHmiuTYzOoqB4i5nnwdwF3UPkR9jx7CQ0MKAK1I0Yq8NpKhVFwLmam8YYMxCH/Elon
         JWgQ==
X-Gm-Message-State: AFqh2kp0T0qQ0yf5T9GO0wYxR9sSTeIZGeEmwJZJutENLcNSXzwTpp2n
        Fh/5K4ob3NuFKjmj1HDerNuCng==
X-Google-Smtp-Source: AMrXdXvezyb09TyK7KItP1R8P9rE/8Gjzwdr9cT8Z3YJHnqevqYEgHk0QLQW1O9Ph7jpPT2nb1ImMA==
X-Received: by 2002:a17:906:5048:b0:7c0:b770:df94 with SMTP id e8-20020a170906504800b007c0b770df94mr7701482ejk.63.1671794881943;
        Fri, 23 Dec 2022 03:28:01 -0800 (PST)
Received: from localhost ([2a00:e67:3f2:a:a55e:fcc9:ef69:52ff])
        by smtp.gmail.com with ESMTPSA id q9-20020a170906770900b0078ddb518a90sm1267202ejm.223.2022.12.23.03.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 03:28:00 -0800 (PST)
From:   andreas@rammhold.de
To:     John Crispin <john@phrozen.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     Andreas Rammhold <andreas@rammhold.de>, stable@vger.kernel.org,
        Rob Herring <robh@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] of/fdt: run soc memory setup when early_init_dt_scan_memory fails
Date:   Fri, 23 Dec 2022 12:27:47 +0100
Message-Id: <20221223112748.2935235-1-andreas@rammhold.de>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Rammhold <andreas@rammhold.de>

If memory has been found early_init_dt_scan_memory now returns 1. If
it hasn't found any memory it will return 0, allowing other memory
setup mechanisms to carry on.

Previously early_init_dt_scan_memory always returned 0 without
distinguishing between any kind of memory setup being done or not. Any
code path after the early_init_dt_scan memory call in the ramips
plat_mem_setup code wouldn't be executed anymore. Making
early_init_dt_scan_memory the only way to initialize the memory.

Some boards, including my mt7621 based Cudy X6 board, depend on memory
initialization being done via the soc_info.mem_detect function
pointer. Those wouldn't be able to obtain memory and panic the kernel
during early bootup with the message "early_init_dt_alloc_memory_arch:
Failed to allocate 12416 bytes align=0x40".

Fixes: 1f012283e936 ("of/fdt: Rework early_init_dt_scan_memory() to call directly")
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Rammhold <andreas@rammhold.de>
---
 arch/mips/ralink/of.c | 2 +-
 drivers/of/fdt.c      | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/mips/ralink/of.c b/arch/mips/ralink/of.c
index ea8072acf8d94..6873b02634219 100644
--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -63,7 +63,7 @@ void __init plat_mem_setup(void)
 	dtb = get_fdt();
 	__dt_setup_arch(dtb);
 
-	if (!early_init_dt_scan_memory())
+	if (early_init_dt_scan_memory())
 		return;
 
 	if (soc_info.mem_detect)
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 7b571a6316397..4f88e8bbdd279 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1099,7 +1099,7 @@ u64 __init dt_mem_next_cell(int s, const __be32 **cellp)
  */
 int __init early_init_dt_scan_memory(void)
 {
-	int node;
+	int node, found_memory = 0;
 	const void *fdt = initial_boot_params;
 
 	fdt_for_each_subnode(node, fdt, 0) {
@@ -1139,6 +1139,8 @@ int __init early_init_dt_scan_memory(void)
 
 			early_init_dt_add_memory_arch(base, size);
 
+			found_memory = 1;
+
 			if (!hotpluggable)
 				continue;
 
@@ -1147,7 +1149,7 @@ int __init early_init_dt_scan_memory(void)
 					base, base + size);
 		}
 	}
-	return 0;
+	return found_memory;
 }
 
 int __init early_init_dt_scan_chosen(char *cmdline)
-- 
2.38.1

