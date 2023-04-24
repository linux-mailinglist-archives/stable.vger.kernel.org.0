Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC476ED0A0
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 16:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjDXOuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 10:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjDXOuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 10:50:22 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBF672B9
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:50:05 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-2f58125b957so4112617f8f.3
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682347803; x=1684939803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2BeHkgxMwj45gGE0rtUO8ce65c54dqTUreoZahTRQ5E=;
        b=Q+zCCoWHm41Q8KX+19G+qttSdMT3bKT7MlQ6wCxB4yCGK52XuTGidNYgmh2gHhmQ7c
         qbNPtt/XylQ91GYqYmIDxJmpIk9m2D8d8AqLiVH3Fyqes1cumxWy8b/rigrK/N4/7tK+
         WhsCcbR3TGZAmnS/qjfNf7s3xwUKBFDsXCqwots2btpT+Y2hJoEh5CSXMwFIEKY58KRA
         qlH1tEzdwq8WHUOqGEhtrYkNpUNrMXmMJcUdFYMsbkOj+6cgJsP/WdFEzzIzJHRskgr5
         ojjNiSNxzZbnEZo3LoKjWC5VoOZN4sdmIv8yZXRx1PAbgdc6q7mkJz+7MBjwD8rSVJGH
         iCnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682347803; x=1684939803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2BeHkgxMwj45gGE0rtUO8ce65c54dqTUreoZahTRQ5E=;
        b=VCaqBpR2VhaWHNPtQ6AT5HXnojVxw8z1SXH4QzCQ1E87vsExr15hIWT9GdhdKDZvNu
         bMG08Lzt1SVXCA7YonGZW8QK93TwkWV1ttuM4PgLEpFhsA8CFKbAiu9oZcXWj62R3Mxp
         vAKQeyrGZx18MiFKd6fLA4QZJL3FxQu536HxTQuZ6qEBdX3BciYcxkmkcqVao74AtEAa
         yCAsGtSaz9WuZHXBH6e3mYmSJ9TSJ7jzflyG6FCcsPFeIRnK+TBC5W93kwpUfmIuQue5
         WOr/PKusqCB1Lm8retCXPuvy1mXPOeoRRE8yriWwvbJ3V1B+TJvRROWKKGU0m7w/LrzX
         8k+g==
X-Gm-Message-State: AAQBX9fJt6BZELUGhfXgdBSvHBW3S3UWKKW4OF1xP5vpzm4VhzBjRTkr
        H/697oDBzFiENzjgN5pUVqP21w==
X-Google-Smtp-Source: AKy350Y5KAQaSelRvarN1oRv8x7qxg0LKNRI8YCMD0BzExAkmRnQT99rdFoD7jgRsIhmRPLRUKGwtQ==
X-Received: by 2002:adf:e3c1:0:b0:2cf:ebaa:31a0 with SMTP id k1-20020adfe3c1000000b002cfebaa31a0mr9863812wrm.54.1682347803227;
        Mon, 24 Apr 2023 07:50:03 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id z18-20020adfe552000000b002f3e1122c1asm10970276wrm.15.2023.04.24.07.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 07:50:02 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     Conor Dooley <conor.dooley@microchip.com>, stable@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 5.15.108 v2 2/3] riscv: Do not set initial_boot_params to the linear address of the dtb
Date:   Mon, 24 Apr 2023 16:47:36 +0200
Message-Id: <20230424144737.194316-3-alexghiti@rivosinc.com>
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

commit f1581626071c8e37c58c5e8f0b4126b17172a211 upstream.

early_init_dt_verify() is already called in parse_dtb() and since the dtb
address does not change anymore (it is now in the fixmap region), no need
to reset initial_boot_params by calling early_init_dt_verify() again.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: <stable@vger.kernel.org> # 5.15.x
---
 arch/riscv/kernel/setup.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index f874fe07fb78..8cc147491c67 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -286,10 +286,7 @@ void __init setup_arch(char **cmdline_p)
 #if IS_ENABLED(CONFIG_BUILTIN_DTB)
 	unflatten_and_copy_device_tree();
 #else
-	if (early_init_dt_verify(__va(XIP_FIXUP(dtb_early_pa))))
-		unflatten_device_tree();
-	else
-		pr_err("No DTB found in kernel mappings\n");
+	unflatten_device_tree();
 #endif
 	misc_mem_init();
 
-- 
2.37.2

