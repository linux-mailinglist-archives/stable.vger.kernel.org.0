Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD09E41A0FE
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 23:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbhI0VEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 17:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237162AbhI0VEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 17:04:34 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1A3C061765;
        Mon, 27 Sep 2021 14:02:55 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 203so16997925pfy.13;
        Mon, 27 Sep 2021 14:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RE9qlrpj4A/Ec+OQwHI70Yn7GuZgbAKhGWX1AXM0xpo=;
        b=YGIjvwZhzsw6kAJhvVIiI9MDxv37kl5ErlyrkQ13GaONqGwh0yiCHq//mbwy4GPRLy
         KCcGzVRCCGg+qqu2o8ruWMmo4dt/GrlIN6bVL0Dg1a6G4YCLKXxoaAR3Hp5+194OAfNh
         7XQkPXin7pQ6XCeZicyfwIZlRpa95H8QpepQ/2csWhlVJbr5Ngr256VALL3Zdnp+hHqk
         rTJs5J7NmOzLeEjpLciBGdv+QqfaZvnDzr+/URMqkQPuBnSd/hVr+ADaHOXnk5gHW+0S
         r6WjVZo6nVQuvWhny9qCd36xHhin3o6JhATvEEsMoiTmoIIW9phihEomQJy1N87iUYxN
         hjFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RE9qlrpj4A/Ec+OQwHI70Yn7GuZgbAKhGWX1AXM0xpo=;
        b=Zs0Wb8fSXKNSvJI3a+WE+tLvjq8LyF4aUbiXZc6O689EKnrqE5255VN4mlnGbGI9fu
         uM2v4awWVpqEDro0Uwy0OqEhTDimJIFfn3i7bTOGCI+CLMHr8TeOMO0ZwLe+sI4ZgpjM
         qjlBKPuqPFazSoBPoI5K4AGafXaDOwqxzQ4DkCkjBog0d4uY/q+08rH0Ysbhtl2gJ36I
         HblAeYJs+Ru97nGbd/nuRbD+CAHPkV0sBFtx2s59/MafZv6AfD2RV49LeB6PUjVeiuFA
         z/gHRhYlhf1e/D7x3U5aK4Z4/vNkv/d4nnuJKXH9r4A0R6Z1fuQx1bGyo+vwCfDAbCYx
         HbqA==
X-Gm-Message-State: AOAM532/oF7z6lw3aqZHVdM/BWcJmpc+BG2lWTu4RZpL4DV/QURcKXDB
        NEiJ50/LSq94wCMIP+9M7TfWTyXNTwE=
X-Google-Smtp-Source: ABdhPJx6hoxRVEppF7KGqLUzy5SoNLDY8id4zgbAM0Ptx1ftU6lMOOb3aXp9wu+6o8q6W/bHIaR68w==
X-Received: by 2002:a05:6a00:8b:b0:44b:9710:52bd with SMTP id c11-20020a056a00008b00b0044b971052bdmr1912122pfj.76.1632776574995;
        Mon, 27 Sep 2021 14:02:54 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y3sm310537pjg.7.2021.09.27.14.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 14:02:54 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Alex Sverdlin <alexander.sverdlin@nokia.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 4.19 v3 1/4] ARM: 9077/1: PLT: Move struct plt_entries definition to header
Date:   Mon, 27 Sep 2021 14:02:43 -0700
Message-Id: <20210927210246.3216892-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927210246.3216892-1-f.fainelli@gmail.com>
References: <20210927210246.3216892-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sverdlin <alexander.sverdlin@nokia.com>

commit 4e271701c17dee70c6e1351c4d7d42e70405c6a9 upstream

No functional change, later it will be re-used in several files.

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/include/asm/module.h | 9 +++++++++
 arch/arm/kernel/module-plts.c | 9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/include/asm/module.h b/arch/arm/include/asm/module.h
index 9e81b7c498d8..56d4c97e578a 100644
--- a/arch/arm/include/asm/module.h
+++ b/arch/arm/include/asm/module.h
@@ -19,6 +19,15 @@ enum {
 };
 #endif
 
+#define PLT_ENT_STRIDE		L1_CACHE_BYTES
+#define PLT_ENT_COUNT		(PLT_ENT_STRIDE / sizeof(u32))
+#define PLT_ENT_SIZE		(sizeof(struct plt_entries) / PLT_ENT_COUNT)
+
+struct plt_entries {
+	u32	ldr[PLT_ENT_COUNT];
+	u32	lit[PLT_ENT_COUNT];
+};
+
 struct mod_plt_sec {
 	struct elf32_shdr	*plt;
 	int			plt_count;
diff --git a/arch/arm/kernel/module-plts.c b/arch/arm/kernel/module-plts.c
index 3d0c2e4dda1d..f272711c411f 100644
--- a/arch/arm/kernel/module-plts.c
+++ b/arch/arm/kernel/module-plts.c
@@ -14,10 +14,6 @@
 #include <asm/cache.h>
 #include <asm/opcodes.h>
 
-#define PLT_ENT_STRIDE		L1_CACHE_BYTES
-#define PLT_ENT_COUNT		(PLT_ENT_STRIDE / sizeof(u32))
-#define PLT_ENT_SIZE		(sizeof(struct plt_entries) / PLT_ENT_COUNT)
-
 #ifdef CONFIG_THUMB2_KERNEL
 #define PLT_ENT_LDR		__opcode_to_mem_thumb32(0xf8dff000 | \
 							(PLT_ENT_STRIDE - 4))
@@ -26,11 +22,6 @@
 						    (PLT_ENT_STRIDE - 8))
 #endif
 
-struct plt_entries {
-	u32	ldr[PLT_ENT_COUNT];
-	u32	lit[PLT_ENT_COUNT];
-};
-
 static bool in_init(const struct module *mod, unsigned long loc)
 {
 	return loc - (u32)mod->init_layout.base < mod->init_layout.size;
-- 
2.25.1

