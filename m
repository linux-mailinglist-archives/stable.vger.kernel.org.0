Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE6226261C
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 06:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgIIENJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 00:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgIIENH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 00:13:07 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A5BC061573;
        Tue,  8 Sep 2020 21:13:07 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w7so1011293pfi.4;
        Tue, 08 Sep 2020 21:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=XzIHZWt2HYfGowYCGtpQwOBOC/dkBmXOrAaPYS4zz6s=;
        b=N6qLuUdmz+eiJHazrwzzfIdSWnYqNf4Ge05muiq9VFvcC2G+fmR7eu6Vla7tNVlK1J
         JxQl7mDa2vJ1OeWcfKixoTdku5qiIgO+42pBttTqwj0FtLZPtX870zZH6XiWLHswIMWE
         x48npqgigj6e8fc1sck5yTxwmpslOsmlXkbUfKLvbxpvuRFUB6CVhjEUHe6TAam+WlhP
         zqnZ0OBKCl2pLdW5el8cHgRU8WC76o7lGu5QwHLvEYjwJdlZlu+mGvvU9bZ4XQVG1ZpF
         ZUUogFDlpRiF+f/vmy2QHI3T92p0meLPKm7TvLOkghV+3OnS3I7dhESP75uTN3r+eODC
         Qp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=XzIHZWt2HYfGowYCGtpQwOBOC/dkBmXOrAaPYS4zz6s=;
        b=srhDH1zw47GP+TVRA+oi0Xy6/gCsY130eWC2+K938nhp92gLfAZPdJu/aESYjOWzhi
         7IJ+bubn7CMnl+zncKbf2x7b3xWTHZXkMTYXfB+/GEg5UPHgok57ckQ4fibSGCE3Lk/s
         +BVyfgq09zfdfSsujRLJyVeLB2XlVqtoSV6HrJVsYxBrqnWmc3vfclTy51bM975xlqgj
         Ev25T8c6UaCAmDuiBxdrbplai6rXlb6MLYB2iPsZg3VDdf3pVzL8wtRnbxGeA5sfT+nO
         VAb8bfp59Td494nRk8W04HW55xr8w+zAoezQxYzsYp1demTsow7SlU3E7fOWDhdW5zoS
         FGSw==
X-Gm-Message-State: AOAM531arlzF5AmTM9cisGKkiQsKYjt6kRddyKgaWtW8+4YBI7Z7x4tq
        8/cGeOvRV5pkCb+YcfsYMBY=
X-Google-Smtp-Source: ABdhPJw5OChy82hNuF8yGMYXJ5qh0GDYnQrIGmpewueDV+LjrGdTlBYtG84eru/xf/1cXe2QtXyewg==
X-Received: by 2002:a63:7018:: with SMTP id l24mr1491858pgc.55.1599624786706;
        Tue, 08 Sep 2020 21:13:06 -0700 (PDT)
Received: from software.domain.org ([45.77.13.216])
        by smtp.gmail.com with ESMTPSA id m7sm901436pfm.31.2020.09.08.21.13.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2020 21:13:06 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] MIPS: Loongson64: Increase NR_IRQS to 320
Date:   Wed,  9 Sep 2020 12:09:10 +0800
Message-Id: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Modernized Loongson64 uses a hierarchical organization for interrupt
controllers (INTCs), all INTC nodes (not only leaf nodes) need some IRQ
numbers. This means 280 (i.e., NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 256)
is not enough to represent all interrupts, so let's increase NR_IRQS to
320.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/include/asm/mach-loongson64/irq.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/mach-loongson64/irq.h b/arch/mips/include/asm/mach-loongson64/irq.h
index f5e362f7..0da3017 100644
--- a/arch/mips/include/asm/mach-loongson64/irq.h
+++ b/arch/mips/include/asm/mach-loongson64/irq.h
@@ -7,7 +7,7 @@
 /* cpu core interrupt numbers */
 #define NR_IRQS_LEGACY		16
 #define NR_MIPS_CPU_IRQS	8
-#define NR_IRQS			(NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 256)
+#define NR_IRQS			320
 
 #define MIPS_CPU_IRQ_BASE 	NR_IRQS_LEGACY
 
-- 
2.7.0

