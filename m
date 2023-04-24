Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E5F6ED0EA
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 17:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjDXPGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 11:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjDXPGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 11:06:03 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494A135AC
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 08:06:02 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f09b4a1527so47803205e9.0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 08:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682348761; x=1684940761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AumYUTgQi5/0TyrCWTguh6g+AWvJDtyTXDJH5oSt6gw=;
        b=oHB+K4j+YPxRUDOpm6px23MVXLXsTpenNzVjNh7+uH5+yK1KUQU7ObeDaImDLAOfK0
         uhFmhFpLRmZ85OhJ3I62HsAELI9+QTTNQ56gUZNXi5e4MjYTw3MXGYburpcgLH+7H84x
         IqENijSOj4rCsyb3pxmAz4At94osMozpqAmWQQgAQQiaHuolcwRO5VYFGH4DKh0QdueV
         L4eW0MQpGk6jEFr6+g4COL+XDO2VHTh9TbzLy+8d/n35ePEArkObCw4n2YpMotMf8spq
         wojVSOQAllaE1wNhn8L1A+TWVIgzdeE/zxGsUXUOxF8rSCEMIkg7yev1JXIFCixxzh9f
         PvVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682348761; x=1684940761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AumYUTgQi5/0TyrCWTguh6g+AWvJDtyTXDJH5oSt6gw=;
        b=bvJIxi4e1taa0wCWKLIrPPUJKgmNZ/8LrsOLBt4MZu2Ws+1CgOwgbTYol3+EWIgAgC
         GLdgZt/3oMVhFVKgwJPS6RnRaVeM7EJiTeMXFyKg+ABGOh0uj4Hdm2zC8kaP2Xb55SsG
         bli2ob53l2RI0VAb8X8Xm3G4FES3q/bxoAiHPTEVZsmb2jzFy8UUu4OCOndW+VzZjzDB
         L7Nn2R4S6CqrJHjxUB1S7rAtYf2QyLsITUEgsWYWUn60aBVJoS54iOzpqS/uzkbBAODn
         aUdpKH0Yt8jm/Qg2RqKqnrKdbqkw6saJGzSLa5QkxqbMefANLjZ23OrulFu+SvYXQlMs
         XMyw==
X-Gm-Message-State: AAQBX9eH5OQqNbJcB/J5eVgI6vAbsWQEebpGvCeE4o62DnmV7SsEGfqd
        YsqHbr+b5iDBDR5pWYMC5+6PHfujKkTjYpRYPPA=
X-Google-Smtp-Source: AKy350ZMPumT2JUvwfntx7LtUlIOjs6CeZ2t/oCx/rFHmiaZXkRwhrFo4OuVmAo+6OL/n9nMvZqPLA==
X-Received: by 2002:adf:df0e:0:b0:2fa:88f2:b04c with SMTP id y14-20020adfdf0e000000b002fa88f2b04cmr9950704wrl.20.1682348760701;
        Mon, 24 Apr 2023 08:06:00 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id f8-20020a5d4dc8000000b002f9e04459desm10893935wru.109.2023.04.24.08.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 08:06:00 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     Conor Dooley <conor.dooley@microchip.com>, stable@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 6.2.11 2/3] riscv: Do not set initial_boot_params to the linear address of the dtb
Date:   Mon, 24 Apr 2023 17:03:53 +0200
Message-Id: <20230424150354.195572-3-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230424150354.195572-1-alexghiti@rivosinc.com>
References: <20230424150354.195572-1-alexghiti@rivosinc.com>
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
Cc: <stable@vger.kernel.org> # 6.2.x
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

