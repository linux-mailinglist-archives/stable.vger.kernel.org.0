Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7079A59CEF9
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 05:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239523AbiHWDBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 23:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239808AbiHWDBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 23:01:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C5A5A839;
        Mon, 22 Aug 2022 20:01:10 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pm13so3884503pjb.5;
        Mon, 22 Aug 2022 20:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=8LTvgu3eG+no37lZJ/vGjO+POGUS+yqe3hYSH8LxyPU=;
        b=cXk8C7OwZaBQd+i8rei7z+/fU39R4PhBoSP8Pi3KcSjWGDA/IJGdOvu9hPlBIiZgFX
         /8todvatRo5NUGNkTaOpOmav8df1vaVyMQhPCsaeXzzERVhrGpsZaq9rxrw2ejKWUQb3
         q06unBvArEWW7Uzs9NFsMfFdimLDQXR8cFOJN5za0t7nNXwFRvB1RqlU1plvc7HGGZlu
         IV9/KfNH32gHsNvAMtK8QP6HO34DQ2h0vAOt4USTmnQfBPg/ir8LlQXQbBszRc5HPzqA
         pDBhAgBJr/sv1VomKkxn81CyZvaqSwlps8Zk1kp7G4QLYIhrFKWMw/m6tRoJ9vN3AaRA
         KQpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=8LTvgu3eG+no37lZJ/vGjO+POGUS+yqe3hYSH8LxyPU=;
        b=u4T6PLgZgI4eg4lUzXTMxBg0i93B8hSzWXXM7On6lOsRV0AaUvpmDVYZAUmx09RKuv
         TUz5VGynfZPEZH9PfNxeueF04NZA3xabx2hbj99t30lm2PSO/X+MaH2dWCe6I8c+c0g7
         yXIiXZPN5G8eW9L1H6fyO0cUxl52p41olTR2pXrmsjhp/sbil26x3gZ7C+Fsvm6JglBz
         5Os1b4eiFLqrcK0lk5/UVcF4ONZ9Heb5K/5vrKZa/IWvPtO06pl7vqIiQrDX2gu2/HbR
         NR37eSuEGx6yCZNz9S6l/QtpawXt0XoE8/g6NmzQu4qWCYKbINCvJ7Ri+ej7oFPcLTKo
         hJDA==
X-Gm-Message-State: ACgBeo2j6fOwleKxDigSzXqD2wbt0pOAq1xVcz0sqZfSDOlCKZmlCJ+W
        W60VLvd+GHyKBulOCM561OnxMLn3ByM=
X-Google-Smtp-Source: AA6agR7Usq8qO39CF0GcXSfNd0l5Or2tQdeC7/Iij2PzNR0XtTPxPmItyEpe5w6lRlbd/EiJu2LcTA==
X-Received: by 2002:a17:90a:bc83:b0:1fa:d302:928 with SMTP id x3-20020a17090abc8300b001fad3020928mr1260281pjr.91.1661223669945;
        Mon, 22 Aug 2022 20:01:09 -0700 (PDT)
Received: from debian.. (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id c3-20020a170903234300b00172f1256590sm2385305plh.281.2022.08.22.20.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 20:01:09 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Aditya Srivastava <yashsri421@gmail.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: [PATCH] mips: pci: remove extraneous asterisk from top level comment of ar2315 PCI driver
Date:   Tue, 23 Aug 2022 10:00:56 +0700
Message-Id: <20220823030056.123709-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <202208221854.8ASrzjKa-lkp@intel.com>
References: <202208221854.8ASrzjKa-lkp@intel.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1723; i=bagasdotme@gmail.com; h=from:subject; bh=grs6Phzy0fj8UUZxS8TxEqELiZEA9kf5e2WhfxsdBrY=; b=owGbwMvMwCH2bWenZ2ig32LG02pJDMksTi8W7Jks8z4wVYK/MbF/5ZzU0rL3DFasC488v9BYarb0 V9PujlIWBjEOBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAExE+CPDf9e0GYfmnIgIkvvaN/XX4U kNl0I3L0pgiDYKfzCfZ9M3/iaGv0LGWzQvFFfPC/JdGMC1Zu7BMz1b44xDZsiuEYuovy6YzgMA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

kernel test robot reported kernel-doc warning:

arch/mips/pci/pci-ar2315.c:6: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * Both AR2315 and AR2316 chips have PCI interface unit, which supports DMA

The warning above is caused by an extraneous asterisk on the top level
(description) comment of pci-ar2315.c, for which the comment is confused as
kernel-doc comment instead.

Remove the asterisk.

Link: https://lore.kernel.org/linux-doc/202208221854.8ASrzjKa-lkp@intel.com/
Fixes: 3ed7a2a702dc0f ("MIPS: ath25: add AR2315 PCI host controller driver")
Fixes: 3e58e839150db0 ("scripts: kernel-doc: add warning for comment not following kernel-doc syntax")
Reported-by: kernel test robot <lkp@intel.com>
Cc: stable@vger.kernel.org # v5.15, v5.19
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 The second Fixes: commit exposes the kernel-doc warning, which the
 culprit is actually the first Fixes: commit, so it make sense to apply
 this patch to supported stable branches after the second commit one.

 arch/mips/pci/pci-ar2315.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/pci/pci-ar2315.c b/arch/mips/pci/pci-ar2315.c
index 30e0922f4ceaec..e17d862cfa4c6a 100644
--- a/arch/mips/pci/pci-ar2315.c
+++ b/arch/mips/pci/pci-ar2315.c
@@ -2,7 +2,7 @@
 /*
  */
 
-/**
+/*
  * Both AR2315 and AR2316 chips have PCI interface unit, which supports DMA
  * and interrupt. PCI interface supports MMIO access method, but does not
  * seem to support I/O ports.

base-commit: 072e51356cd5a4a1c12c1020bc054c99b98333df
-- 
An old man doll... just what I always wanted! - Clara

