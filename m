Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FD8413FB1
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 04:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhIVCnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 22:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhIVCnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 22:43:43 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC19C061757;
        Tue, 21 Sep 2021 19:42:14 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id n18so1063272pgm.12;
        Tue, 21 Sep 2021 19:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LD4E/5hLdNRTgpMyWmZjQRAYo/s/OzJ4lOWM5dEi//E=;
        b=JyK0jxzXQnUMVissHt22VtTl3JomN9tQrsK9yWMZMRUS3DPZiLPvOPaEV/fyvFu3di
         aPWeUWWdjIjw7ke7VPLEwlgkRKPmvzq48x9k4fY5NMHT3nMr4mlOoGYkLTfguRnUdbTo
         PGVo3emnDhW0scGelLfQtiYhLkGBQzhx5fgvhzp1jr/UC9BVXrmiuoNi38t8e3KA4Foa
         iiDFiL6dIiiGpQZ1hIUuKXtFN+WmsrkUIHf4Z0gk67O0bkKWMeh46H/ZLy1VHzCxDStL
         qnoVHFDI7QYRYvHJuyygZQrHLNW5Z1pVQMiPblMyTUDY8Hbw0BWLFPVVstYWvzyJuC5P
         OPBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LD4E/5hLdNRTgpMyWmZjQRAYo/s/OzJ4lOWM5dEi//E=;
        b=qPf2VyMaiuqXZkwAbUosvHuFOJ/4gnkzXnNknLTtKJlre2Q4rZLz2BkWm9cso5yQom
         Ax1DXuezcTFE3QyKvZIo1b2yRbWmmU/nTIQbUnuJR+uW2nfi8D4HbJ5YRuQ4ttBMc9UA
         TyxcUSNNFspapGz4vb4zHVKIOJWqifNry8QXhnjEM9VvxoYALwoPtKalwzXXeVInokOF
         +1SYtXg+uePIIJ6jts3wCNxptCKCSmmDa5N0KXIcpBMig2StuGfcQ6bB1EJCbNqBiWi4
         SfhtknL0owYZvPnB4EQDfDusij814hP3R1RoaWYQrsdbqWdayBtKmlIStHpokXlGcses
         DuIw==
X-Gm-Message-State: AOAM532yMGM04Hh7V23zBCjDADNIszq1NtvqyF2dUH5/MiTgdxF4Lfn4
        LyTindgkxoESv2yulqr0I7Ybco/SVgQ=
X-Google-Smtp-Source: ABdhPJzxIhmnmf+gj4PT0+Sd8HQvuC9BTN9woOlXRc9f/bKtW6XykqvSLnrkvkk35H0UNKYBawGFWA==
X-Received: by 2002:aa7:95a1:0:b0:43d:dbc5:c0af with SMTP id a1-20020aa795a1000000b0043ddbc5c0afmr33252872pfk.37.1632278533905;
        Tue, 21 Sep 2021 19:42:13 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 23sm445798pfw.97.2021.09.21.19.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 19:42:13 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 4.9 1/3] ARM: 9077/1: PLT: Move struct plt_entries definition to header
Date:   Tue, 21 Sep 2021 19:41:55 -0700
Message-Id: <20210922024157.60001-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922024157.60001-1-f.fainelli@gmail.com>
References: <20210922024157.60001-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

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
index ed2319663a1e..2e9872a22359 100644
--- a/arch/arm/include/asm/module.h
+++ b/arch/arm/include/asm/module.h
@@ -18,6 +18,15 @@ enum {
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

