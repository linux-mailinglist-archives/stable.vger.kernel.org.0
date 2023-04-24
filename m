Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F9D6ED0BE
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 16:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjDXOzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 10:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjDXOzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 10:55:21 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D0635AC
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:55:18 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f196e8e2c6so27883365e9.1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682348117; x=1684940117;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j/JJmwBfem8sB5BTe30hGcIYmtYjEiWiy90QA3NV9M0=;
        b=tU4ANUUui5eQwOUFhJQ6MY8FPLru1YOwrkwtpG6SI+9xB1shOVCDdFjhYPpu+/fH0B
         ggKJuGuEs+qHH0AVws4il5XWMdPahBcS4K7KmhZZyL2pHI7VZLLOwqX50U89A/Kzg9xe
         mJyg9ID5AgeDH2rV5cTZGnn+eX1FeA+rLmLhsIg5ES4ex+qXwmQPKHqowNQWSJtTWGfP
         E5aJ7QnWgQjd0rrYsbNj8ncgxce9xiRkgzKrrjVzkTUrrYhGn6HSz4Wo/4UDPC6OzRm/
         OZOSrfCRtLYRQVvFFh8VZ2UVoKVEc400ng58DZ0XOOTdSoO4FTo46Xa4OVeeFGwgqaDe
         yQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682348117; x=1684940117;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j/JJmwBfem8sB5BTe30hGcIYmtYjEiWiy90QA3NV9M0=;
        b=Gv/dpaanthTt/1u3cAT00peCS3MxGu3ufltdNjFeZKMYfhEB52qEJ3/eaLBnvnS6yc
         b0uB3mvg4wOXcJ9izDfoh6ZaMroXZlyiDV6bFfw+cZmjFVGrnsw2LbVMkx5R9fLXjNRW
         iNzm1wOBX9rGH/FjhTGjrhkU729lssxmQoCR5cgafaqtKnl1sv3MdcRCicBuaiKIONiw
         t7YvXfDSj+iuhvfNUTctBYelNET3LmNJvIL3+3EjPcAMqVMWuTLP0b4HPcJWfO/fNLCq
         nINm/SHc61TkG8Y+IAxMxwJgY+hq1ddvR3GybyXs4vkf7ozlyqSFSqMtCp1NrY02TF8U
         UFtA==
X-Gm-Message-State: AAQBX9exXO/Td0SIixt4D6FE2vcFsgZfUnDe4xSLuasjkUlzPSxyfMeh
        rISiDYle9Pz1F0TnoXv/YMMylHx/D+h3BlMNHGQ=
X-Google-Smtp-Source: AKy350ZbWmI4wQD5g0Mv/LWUveLdWuul18zvA/yItOQVa05UZFCYBAJ8LuDlK2w9eGtX4fxE4+t7zg==
X-Received: by 2002:a1c:4b05:0:b0:3f1:6757:6245 with SMTP id y5-20020a1c4b05000000b003f167576245mr7914075wma.7.1682348117259;
        Mon, 24 Apr 2023 07:55:17 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id q10-20020a05600c46ca00b003f1957ace1fsm8394321wmo.13.2023.04.24.07.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 07:55:16 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     Conor Dooley <conor.dooley@microchip.com>, stable@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 6.1.24 0/3] Fixes for dtb mapping
Date:   Mon, 24 Apr 2023 16:54:59 +0200
Message-Id: <20230424145502.194770-1-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.37.2
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

We used to map the dtb differently between early_pg_dir and
swapper_pg_dir which caused issues when we referenced addresses from
the early mapping with swapper_pg_dir (reserved_mem): move the dtb mapping
to the fixmap region in patch 1, which allows to simplify dtb handling in
patch 2.

base-commit-tag: v6.1.24

Alexandre Ghiti (3):
  riscv: Move early dtb mapping into the fixmap region
  riscv: Do not set initial_boot_params to the linear address of the dtb
  riscv: No need to relocate the dtb as it lies in the fixmap region

 Documentation/riscv/vm-layout.rst |  4 +-
 arch/riscv/include/asm/fixmap.h   |  8 +++
 arch/riscv/include/asm/pgtable.h  |  8 ++-
 arch/riscv/kernel/setup.c         |  6 +--
 arch/riscv/mm/init.c              | 82 ++++++++++++++-----------------
 5 files changed, 53 insertions(+), 55 deletions(-)

-- 
2.37.2

