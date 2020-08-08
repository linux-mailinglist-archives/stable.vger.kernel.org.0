Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C500923F7A4
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 14:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgHHMsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 08:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgHHMsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Aug 2020 08:48:05 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E1BC061756;
        Sat,  8 Aug 2020 05:48:05 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m34so2398182pgl.11;
        Sat, 08 Aug 2020 05:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=VeTKxr8w7VLVr4PGx0bAYjFSbETGJkL04gDai2o4qs4=;
        b=U5CvQ/2Cnvhn7c6MOZlq7QCryWur+muKFaIQcI4LrT4XcYibOrpe8G/L+GO091zjeJ
         FPxWh6HfuUcjO5icElHQhTK6rt03FgKfwaMz2DPDgXdibBViPLJI5h9Xkk1kGXDNXnip
         9wRtjiMv6fxak8aeKsSbqth4OGZGT8a6P60vYdAYNdCz6mrRNlPvhsgUbeQN8KwIwBUZ
         lTarmCI5MVKr/1/QvBOMj1o2ryOzc/BCYXvlBfIiDvNwGeqfpIUwt2O6hVB+SZVoHYUF
         RYMNO3Dd4ifXPSDwTbqtwTtUud2ZI4dm0ReMGCUZVSa+M0fRwfrd59W1463IzyusXAXt
         zoUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=VeTKxr8w7VLVr4PGx0bAYjFSbETGJkL04gDai2o4qs4=;
        b=ay6+gGoiAAu7wFqa9sBeGkHZ6tFUIn6pySykOqri/TQLgB1beidPayMDlpcNsqGIXs
         wk08Iilm8lAcVOMe2DE7MPLcgwHgwhb8Nn82KBYnR6q2xZYnOleIBau6Kt9kH3Y0pQ6q
         KL79f9X0TOdiFMV/RaR+2xX59YdNhqFZe2zohOj+lQW+JFUfH67GsC0aRwh/LkuOf8Vv
         YKPAKkwQTdfuRA/PSqLCf96XOf7+St786WvFvDJ31oNypQuEZy19XrrbmO6vRzfpgwpi
         Rx/cctKdZRBxQaMKz+I3rRT28F3xl3jNEfF5vSM3Zk+F2Vl9L8cOFiT+M2l6Wb9fZLru
         vUkw==
X-Gm-Message-State: AOAM530Dbxab4tiyBAYGQplnwESpBWdCvaVO8RnMXToXcLsW4BGy3r7K
        a8P7UNGjIxppdkKK9wZcO0M=
X-Google-Smtp-Source: ABdhPJxhzrk/tqVULXH30q6hg12JI5TtBQTTTXXABv1XWrscmxSMa2C+RDwJcctCkcGojQ5FGR80lw==
X-Received: by 2002:a63:1a49:: with SMTP id a9mr15391246pgm.110.1596890884864;
        Sat, 08 Aug 2020 05:48:04 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id k12sm14023458pjp.38.2020.08.08.05.48.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Aug 2020 05:48:04 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
Subject: [PATCH] MIPS: VZ: Only include loongson_regs.h for CPU_LOONGSON64
Date:   Sat,  8 Aug 2020 20:50:52 +0800
Message-Id: <1596891052-24052-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Only Loongson64 platform has and needs loongson_regs.h, including it
unconditionally will cause build errors.

Fixes: 7f2a83f1c2a941ebfee5 ("KVM: MIPS: Add CPUCFG emulation for Loongson-3")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/kvm/vz.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 3932f76..a474578 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -29,7 +29,9 @@
 #include <linux/kvm_host.h>
 
 #include "interrupt.h"
+#ifdef CONFIG_CPU_LOONGSON64
 #include "loongson_regs.h"
+#endif
 
 #include "trace.h"
 
-- 
2.7.0

