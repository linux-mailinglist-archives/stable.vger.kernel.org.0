Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F926ED0CA
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 16:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjDXO5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 10:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjDXO5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 10:57:35 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D0576B3
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:57:20 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f178da219bso45631135e9.1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682348239; x=1684940239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Dztm3ViKMiKo1PWDxKtd+TANJS40LHhsxDolGC3BjA=;
        b=SRP+TsM7wt/cHmjHweZSr5ucZDGAw0zZYGUAtXN0CgNb0abOn+Hxd7ajv1UIK7xAp7
         PelF3TvF8k0RoQg+/9DWTCaDQ46zKZTpwinfd5X2L4ltOEjJ/AAgQGq3flYCSzXvJDQ2
         /FlJMDXdFZTwPjz8w7Iyfc7u5g1JmTfVpAu8D8uBafhQJA78Q5MdQ89RTnYGYKA5YStK
         J0M9uu0ZFzvY541785zzJoUT7807m+CYII1zP595mXtJ4xMA3Bn9IdbmHw227tUMJXAC
         nvnt8ulbeERwuU9AyY9hmUW3aLOtzHTxsJr6KEulEEBuUGwA/PB5xEBd/MhdAyLbokCq
         zGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682348239; x=1684940239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Dztm3ViKMiKo1PWDxKtd+TANJS40LHhsxDolGC3BjA=;
        b=dwrtB2N17vtIn3BCdPnwmPtWU58MTrs9OUatdKoqv9MuB7ww4huOqtpQce4deiRwnZ
         ih5NnI7Rt4Rmom1bqvMCHH24DkwoCXNjBfNz9pETMP7p4aKDzLfacIInSnUZXMmh9+sA
         mhRO/vDS+te9c0zZEj0Ru5RDyfF1TksyrQrlAY6yBO2gT4/z1SyFvPs6Y+/boEW8LxZy
         NHIPobqUoV9J7giU7oGKPW1kGSgIvCT3f1DcvrVyiP1jynTfNoF4b1b5YM+JO3PYjKUK
         vsaDRPph4DE3Rvrk5t0FRgMxBjKaEdkJud/FGjysRCHRYhr/2ZjkI4WsAvZmBqtQkwOh
         HXWQ==
X-Gm-Message-State: AAQBX9e259Y7KEcI8Ex/zW+sbAS9iORyaStOcdWp/bgOm6K1ab2duCKk
        z1bLz5AkPXIANMpJE+PEKmUQuQ==
X-Google-Smtp-Source: AKy350afyY+mmIYxvQiswhLdObW6MMEhNsv03XSRfWstFOqIs9hhcutoOKWLLmYuC7Po9/rERTLcnA==
X-Received: by 2002:a7b:cbd7:0:b0:3f1:9be0:b39f with SMTP id n23-20020a7bcbd7000000b003f19be0b39fmr4774850wmi.8.1682348239215;
        Mon, 24 Apr 2023 07:57:19 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id h15-20020a05600c314f00b003f1978bbcd6sm10061508wmo.3.2023.04.24.07.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 07:57:18 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     Conor Dooley <conor.dooley@microchip.com>, stable@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 6.1.24 2/3] riscv: Do not set initial_boot_params to the linear address of the dtb
Date:   Mon, 24 Apr 2023 16:55:01 +0200
Message-Id: <20230424145502.194770-3-alexghiti@rivosinc.com>
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

commit f1581626071c8e37c58c5e8f0b4126b17172a211 upstream.

early_init_dt_verify() is already called in parse_dtb() and since the dtb
address does not change anymore (it is now in the fixmap region), no need
to reset initial_boot_params by calling early_init_dt_verify() again.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: <stable@vger.kernel.org> # 6.1.x
---
 arch/riscv/kernel/setup.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index ef98db2826fc..2acf51c23567 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -278,10 +278,7 @@ void __init setup_arch(char **cmdline_p)
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

