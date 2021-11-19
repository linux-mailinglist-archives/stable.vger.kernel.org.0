Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D76457351
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 17:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbhKSQrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 11:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbhKSQrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 11:47:46 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78796C061574
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 08:44:44 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id o4so9801045pfp.13
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 08:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding:cc:from:to;
        bh=5ChM9rojwfVZwb854uhoQhujli+NJle96xwmBErH+IU=;
        b=DaCfNGu+rNT7plyiOhA2fSQzYoF3ErJeSq6lLAt9u7p5aRck5wu/2q8lyTSKC9FwL7
         8mt3lmeZ6OpVHgLgtMAyDz44a78JkOoCWTRVB65syJhyKhGddI9tWRbuaIqKuryMM0cZ
         qpq20nC50jElNtQrUfuJwwqeLesDO6dbKe1Tk0VUFmW5xpDzSVEDztR9ZFBBxGRk+1sN
         hCav4BtrNRiyAnus7AcC4kWfXf+7Fo34FkZdSuFFCy1/QvGiXIm54hcm8YKlUrHoMpWH
         fO8FTlpHAJZMFYf3dPqlwJFPtUlHBygsGhK2YhmcMHN6plY73ISQXSDvOHtdnu2inQoR
         dLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding:cc:from:to;
        bh=5ChM9rojwfVZwb854uhoQhujli+NJle96xwmBErH+IU=;
        b=RWUR7Bf3QWLcnJuoVzl6nRZ80vfzIitYiWZFyyent6yE12w6oHJYMU767G5DnSBqGt
         QYwbMifA1+AACXGYHgx8Pgu0iUekYwnhTOUkMnOY+8MjLHM92/PBYvOEt+YRVbhVjxQk
         nwdV+0+J4Gb2o7AP/N3a3OidQ++BoWp4GBeYdB9JtmdPWXZVeIP0fzeobthkufcr8OsP
         EWryFQOJxt9dtbwOeiHesMfQt9AQY3takTIOBZW8KC4u6FiDEpZdCVZHwWgNmTmYjFK3
         IFOyFGNLbseQDsNaUwC6UPRC4/PGoCGxsL50DKnAdzOAi2Nm4NSbuBHFkiZeXcp7fneF
         CemA==
X-Gm-Message-State: AOAM531M+u3+Dhz+tzZ7v6rhW0crQGLSB5mZFlS1tTOtysfqSb+YAZLv
        N4OwOke4AYAjyC10PYZ1OCAMvA==
X-Google-Smtp-Source: ABdhPJyf466y1OSj6NIxhcvh6K8TQYHu4W9tg//KV4Y0C3o/44ZnxTLiwoKCUqKKG8aX01yCdYyQZw==
X-Received: by 2002:a63:ce54:: with SMTP id r20mr18197963pgi.95.1637340284094;
        Fri, 19 Nov 2021 08:44:44 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id i76sm194874pgd.69.2021.11.19.08.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 08:44:43 -0800 (PST)
Subject: [PATCH 01/12] RISC-V: defconfigs: Set CONFIG_FB=y, for FB console
Date:   Fri, 19 Nov 2021 08:44:02 -0800
Message-Id: <20211119164413.29052-2-palmer@rivosinc.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211119164413.29052-1-palmer@rivosinc.com>
References: <20211119164413.29052-1-palmer@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, aou@eecs.berkeley.edu,
        anup.patel@wdc.com, heinrich.schuchardt@canonical.com,
        atish.patra@wdc.com, bin.meng@windriver.com,
        sagar.kadam@sifive.com, damien.lemoal@wdc.com, axboe@kernel.dk,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Palmer Dabbelt <palmer@rivosinc.com>, stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:         linux-riscv@lists.infradead.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmer@rivosinc.com>

We have CONFIG_FRAMEBUFFER_CONSOLE=y in the defconfigs, but that depends
on CONFIG_FB so it's not actually getting set.  I'm assuming most users
on real systems want a framebuffer console, so this enables CONFIG_FB to
allow that to take effect.

Fixes: 33c57c0d3c67 ("RISC-V: Add a basic defconfig")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
---
 arch/riscv/configs/defconfig      | 1 +
 arch/riscv/configs/rv32_defconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index ef473e2f503b..11de2ab9ed6e 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -78,6 +78,7 @@ CONFIG_DRM=m
 CONFIG_DRM_RADEON=m
 CONFIG_DRM_NOUVEAU=m
 CONFIG_DRM_VIRTIO_GPU=m
+CONFIG_FB=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_USB=y
 CONFIG_USB_XHCI_HCD=y
diff --git a/arch/riscv/configs/rv32_defconfig b/arch/riscv/configs/rv32_defconfig
index 6e9f12ff968a..05b6f17adbc1 100644
--- a/arch/riscv/configs/rv32_defconfig
+++ b/arch/riscv/configs/rv32_defconfig
@@ -73,6 +73,7 @@ CONFIG_POWER_RESET=y
 CONFIG_DRM=y
 CONFIG_DRM_RADEON=y
 CONFIG_DRM_VIRTIO_GPU=y
+CONFIG_FB=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_USB=y
 CONFIG_USB_XHCI_HCD=y
-- 
2.32.0

