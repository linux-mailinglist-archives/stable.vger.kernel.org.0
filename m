Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F573092FC
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 10:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhA3JMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 04:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbhA3EQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 23:16:35 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC52C0617A7
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 19:45:39 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id a20so6787559pjs.1
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 19:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RLVEqQslVYjHN6/GcJQt+a0YkZ+s/rJ3wnnBKP9zCJs=;
        b=aVcISZ6U1WUb/MBfsNoMjDe01a+7Ze7PsO/fiIIYYp3q/anDbe/RPR9lp5PskAEJmn
         fQgG134PgkcMHy++VGVO6SYsJ3lzG5x9nPfxJBfqJWbdZ3MhUOrT+GKlUNqTzkPIzKIC
         0jLdDiBHmaPrhOSEhZwgUNcWNgoWQN/ce795lXEzMiZDX765sYzLZYscadXrdVTRfM6M
         +Wa0cmtJp9P06WMXrBN19wRJk5EawW4r/0ka9mklLHJ7P43kZjga/43NHEggOKESzq40
         oVFa5Zc46StXRtilvrEy/mqC6GKM9B3Y9P2svdjfrYyXC/GstmPPTlyFqsfHurvqaPj9
         dMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RLVEqQslVYjHN6/GcJQt+a0YkZ+s/rJ3wnnBKP9zCJs=;
        b=mawESxz5t2pMkgfWlva2PUE2w5GGYLdNdQ0iYzFAElYIujQkvVOyjIqSJ7iG1IoCl9
         1lyEcOMzP9RmrLwAoheo/nzfYS9PfChw2ckfVGN1XUgQfXLcMccEXS411Dczl7oTqA2b
         4tDtFj3hyd618VOlprolzYuQw9kBIHrUtJ0XlAacythQy9ES4/AwWzsBdoxNuyccelbD
         Ckz0u7Bbi5OPS51Rhmgs+dpWu5fhY3jsx5JLBT+9VksyOboItdAcxTFmi4sp5c4PAINA
         A3H+EPtqnR306OloYRDNSIr3Z1jA9QLag7vrO5aVH0PpuFpuvfaQbbiPyxvjwBxlal6v
         Bq+A==
X-Gm-Message-State: AOAM533K0tf4Ld/HouRW4EswYJsmtFmRvdfj3X90WsqvopkaSJuWlheS
        tWbDFOKlGYXDZStD7mnkV0w=
X-Google-Smtp-Source: ABdhPJy7dxNEh/s8aLVTOojEvzmD8hAb6UsK5wfhGDgHoKui+q3X1jaYRBCJTzk61S/biGE6vwofIA==
X-Received: by 2002:a17:90b:8d1:: with SMTP id ds17mr7259357pjb.194.1611978338548;
        Fri, 29 Jan 2021 19:45:38 -0800 (PST)
Received: from z640-arch.lan ([2602:61:7388:8f00::678])
        by smtp.gmail.com with ESMTPSA id b26sm10265928pfo.202.2021.01.29.19.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 19:45:37 -0800 (PST)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     devel@driverdev.osuosl.org, linux-mediatek@lists.infradead.org,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH] staging/mt7621-dma: mtk-hsdma.c->hsdma-mt7621.c
Date:   Fri, 29 Jan 2021 19:45:07 -0800
Message-Id: <20210130034507.2115280-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Also use KBUILD_MODNAME for module name.

This driver is only used by RALINK MIPS MT7621 SoCs. Tested by building
against that target using OpenWrt with Linux 5.10.10.

Fixes the following error:
error: the following would cause module name conflict:
  drivers/dma/mediatek/mtk-hsdma.ko
  drivers/staging/mt7621-dma/mtk-hsdma.ko

Cc: stable@vger.kernel.org
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/staging/mt7621-dma/Makefile                        | 2 +-
 drivers/staging/mt7621-dma/{mtk-hsdma.c => hsdma-mt7621.c} | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/staging/mt7621-dma/{mtk-hsdma.c => hsdma-mt7621.c} (99%)

diff --git a/drivers/staging/mt7621-dma/Makefile b/drivers/staging/mt7621-dma/Makefile
index 66da1bf10c32..23256d1286f3 100644
--- a/drivers/staging/mt7621-dma/Makefile
+++ b/drivers/staging/mt7621-dma/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_MTK_HSDMA) += mtk-hsdma.o
+obj-$(CONFIG_MTK_HSDMA) += hsdma-mt7621.o
 
 ccflags-y += -I$(srctree)/drivers/dma
diff --git a/drivers/staging/mt7621-dma/mtk-hsdma.c b/drivers/staging/mt7621-dma/hsdma-mt7621.c
similarity index 99%
rename from drivers/staging/mt7621-dma/mtk-hsdma.c
rename to drivers/staging/mt7621-dma/hsdma-mt7621.c
index bc4bb4374313..b0ed935de7ac 100644
--- a/drivers/staging/mt7621-dma/mtk-hsdma.c
+++ b/drivers/staging/mt7621-dma/hsdma-mt7621.c
@@ -749,7 +749,7 @@ static struct platform_driver mtk_hsdma_driver = {
 	.probe = mtk_hsdma_probe,
 	.remove = mtk_hsdma_remove,
 	.driver = {
-		.name = "hsdma-mt7621",
+		.name = KBUILD_MODNAME,
 		.of_match_table = mtk_hsdma_of_match,
 	},
 };
-- 
2.30.0

