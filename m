Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA8B413FA9
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 04:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhIVCnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 22:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbhIVCnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 22:43:13 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0393C061575;
        Tue, 21 Sep 2021 19:41:44 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n2so748572plk.12;
        Tue, 21 Sep 2021 19:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I3c7+1FjEQVvXK/8I+aPaOJMr2BWsGKNeLa7wMBIJNU=;
        b=pxLLzy4ZdmVkgfQn9Ah8dHr9O1A1IAgpb6SDHOQtdFM+CZidZO7OYbYXGr9I3UyeDR
         Wyr7l7T31YLvftKNJNwKA43v1+mJ52NOX1fG7VQzybdhAnG/GbSWj0YX1vjsZUS/9gcL
         ThP54ODaQc9dYr3eCX8d+LcxR0n1/P0XfwjXhk2DSgUTtCMH9pA8a7ueNt9dCSdwnAuS
         aYG+Bw7ToNHA+Kc0pfPvuwYSFnkexTxUUtXFs0RjMZa6d1DEVGURqUoG/AGskRGqg0ZA
         tmw0Tcx06M4Nv/rM52OVtujzLM1khKH7cP2a1ALtULQe2u3m1lYTEjLBi2OK9sMNgCnE
         Waew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I3c7+1FjEQVvXK/8I+aPaOJMr2BWsGKNeLa7wMBIJNU=;
        b=jMKFf4tIoWmAkoHLQ0d5FIw7x9bggdggtMWsViEKOzmIeGFEZFZUPCE6cxNuftl1Jq
         yrKGQ0qJh+W8YNbiwTtF3U9KKxI64zvblN3Tw8dAJZDxWAgMSNmWbuAuqBZ7Xr3Nodlb
         6Gv3L3WT8ChDDNBfQl4a23HrZr+asNJyfw7H+fZ0ED7pBRKFVS6CW9H79Xk56bVrMkr0
         NzjKXeMLIYBRi6QPKBGzweCCGKDgQ88L+Ls1r14D8c69jURZMLldrCcnvyY2pRXe2dJt
         19muyRNTMHAkuRKaAFGLanmf4rHd6ckjorHniIig1/pSlI40uqP8GxSG/DqWWFMKI/dQ
         XIsA==
X-Gm-Message-State: AOAM533wEwGutNOfM0NxnQYCGAXxFEzafZTx0054GeFQSBamlIoHn7/z
        ajNiO8yUZRv9qwfvwNSHgz5zcdIjD8M=
X-Google-Smtp-Source: ABdhPJwiK+HOfm7NF6jjWH97bs95oPH/VccAqwt0FzwSb1pQWwzkox0ZTTvQcKOS1Zgi3NHUn8M7yw==
X-Received: by 2002:a17:902:684c:b0:13a:709b:dfaa with SMTP id f12-20020a170902684c00b0013a709bdfaamr30030531pln.61.1632278503926;
        Tue, 21 Sep 2021 19:41:43 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u25sm440360pfh.9.2021.09.21.19.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 19:41:43 -0700 (PDT)
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
Subject: [PATCH stable 4.14 1/3] ARM: 9077/1: PLT: Move struct plt_entries definition to header
Date:   Tue, 21 Sep 2021 19:41:26 -0700
Message-Id: <20210922024128.59910-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922024128.59910-1-f.fainelli@gmail.com>
References: <20210922024128.59910-1-f.fainelli@gmail.com>
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
index 89ad0596033a..6996405770f9 100644
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

