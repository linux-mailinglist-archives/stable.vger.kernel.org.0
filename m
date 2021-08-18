Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF843F03C9
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 14:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhHRMfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 08:35:13 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:43710
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233833AbhHRMfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 08:35:13 -0400
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id D30FE40670
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 12:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629290075;
        bh=/t/uqJt7RQhhBx9NNywyLv0LU3GBSqHVKNoST+16uFA=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=VC91Hsm78CZ8HzcWrfEa28IrQv4win2PnKvIWKJBsEUC6KpmQjqCtZMEajMtN3NSf
         5F639BoHr6OzGNToF+QX8dR4MSmOVBH8+fgsTTiHC/geHjIuPbOKWZgGdcLuiS2Vas
         dnK8iuPPwOckUOf4bOScCHk4agt5el9YaKbuvsw0+7wFYOnEK0j+nclmHBekGt0IdZ
         12Innxh5/SEcLXeNBvARjNt1ktOw2+E/fe3V/yQu/ugCIMBFuGPnECk1kgdFU+r/f2
         6NLIanBgBQJWoMyE6AWpUzY3T8a4akTjN0gSb8JKpk3EXxw9rS6Sxx3f2XMVzfwdQ8
         SDTsWOjJ2gQYQ==
Received: by mail-pf1-f197.google.com with SMTP id f22-20020a056a0022d6b02903c1c4cac83cso1197524pfj.16
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 05:34:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/t/uqJt7RQhhBx9NNywyLv0LU3GBSqHVKNoST+16uFA=;
        b=mQGDENgCC2XYdp23HnlJaZajXm95s+jnCarD8Mt5GCL4dwOmG8tEyjOwHSl7mzna7i
         xb9r5znd2Bba/PmwXqTuUOz+rdrJJ9sYTkFNFRIwDc8+CgVPrTeAQu94p3X2SM8x/lAL
         J1eO0QHGIqcRZ+ITLtIb+aJTrf/Eqv+BDW4PjYvcwku8f0SlR0fcdjlJtZrE8dFN4tks
         17EXVfL3W0NBWT8TWhv1PmXW0FuOReU4gyPfJR6VUfMYFNiY5lXDiogpQbvhyBr82dl8
         7lzRkISDnpSKULqsuUmf7pfveSfy24MifVYx2lVS034v4T4y0uRsy4EMcnkhvAKil9S6
         k3XA==
X-Gm-Message-State: AOAM533HOXftxaBs2eU16qo687WiPHwko6g4XhYDfeuPLTML41Gg9wk6
        K/zCrbyYK6m/fbLWsDujly188eG4L/ZZOv0aJyTm1QKb/8eaxCGIdVbx6j6NOmEumGRUnLy5nzs
        IyFsxkzX5NaBH/q7kK7qS3+rQyghGEYwoZA==
X-Received: by 2002:a17:90a:cc12:: with SMTP id b18mr9374320pju.192.1629290074296;
        Wed, 18 Aug 2021 05:34:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxB0KPhpaZ5Zr50KiDrsEgj18yKQ+lkR3uAdRWVRouu/QOW1qpt2Oe61+SMmiksivwnP5uNZg==
X-Received: by 2002:a17:90a:cc12:: with SMTP id b18mr9374303pju.192.1629290073942;
        Wed, 18 Aug 2021 05:34:33 -0700 (PDT)
Received: from localhost ([2a01:4b00:85fd:d700:1397:609:e787:2244])
        by smtp.gmail.com with ESMTPSA id fa21sm5223597pjb.20.2021.08.18.05.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 05:34:31 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     stable@vger.kernel.org
Cc:     Guo Ren <guoren@linux.alibaba.com>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10.y 2/2] riscv: Fixup patch_text panic in ftrace
Date:   Wed, 18 Aug 2021 13:34:06 +0100
Message-Id: <20210818123406.197638-3-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818123406.197638-1-dimitri.ledkov@canonical.com>
References: <20210818123406.197638-1-dimitri.ledkov@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

commit 5ad84adf5456313e285734102367c861c436c5ed upstream.

Just like arm64, we can't trace the function in the patch_text path.

Here is the bug log:

[   45.234334] Unable to handle kernel paging request at virtual address ffffffd38ae80900
[   45.242313] Oops [#1]
[   45.244600] Modules linked in:
[   45.247678] CPU: 0 PID: 11 Comm: migration/0 Not tainted 5.9.0-00025-g9b7db83-dirty #215
[   45.255797] epc: ffffffe00021689a ra : ffffffe00021718e sp : ffffffe01afabb58
[   45.262955]  gp : ffffffe00136afa0 tp : ffffffe01af94d00 t0 : 0000000000000002
[   45.270200]  t1 : 0000000000000000 t2 : 0000000000000001 s0 : ffffffe01afabc08
[   45.277443]  s1 : ffffffe0013718a8 a0 : 0000000000000000 a1 : ffffffe01afabba8
[   45.284686]  a2 : 0000000000000000 a3 : 0000000000000000 a4 : c4c16ad38ae80900
[   45.291929]  a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000052464e43
[   45.299173]  s2 : 0000000000000001 s3 : ffffffe000206a60 s4 : ffffffe000206a60
[   45.306415]  s5 : 00000000000009ec s6 : ffffffe0013718a8 s7 : c4c16ad38ae80900
[   45.313658]  s8 : 0000000000000004 s9 : 0000000000000001 s10: 0000000000000001
[   45.320902]  s11: 0000000000000003 t3 : 0000000000000001 t4 : ffffffffd192fe79
[   45.328144]  t5 : ffffffffb8f80000 t6 : 0000000000040000
[   45.333472] status: 0000000200000100 badaddr: ffffffd38ae80900 cause: 000000000000000f
[   45.341514] ---[ end trace d95102172248fdcf ]---
[   45.346176] note: migration/0[11] exited with preempt_count 1

(gdb) x /2i $pc
=> 0xffffffe00021689a <__do_proc_dointvec+196>: sd      zero,0(s7)
   0xffffffe00021689e <__do_proc_dointvec+200>: li      s11,0

(gdb) bt
0  __do_proc_dointvec (tbl_data=0x0, table=0xffffffe01afabba8,
write=0, buffer=0x0, lenp=0x7bf897061f9a0800, ppos=0x4, conv=0x0,
data=0x52464e43) at kernel/sysctl.c:581
1  0xffffffe00021718e in do_proc_dointvec (data=<optimized out>,
conv=<optimized out>, ppos=<optimized out>, lenp=<optimized out>,
buffer=<optimized out>, write=<optimized out>, table=<optimized out>)
at kernel/sysctl.c:964
2  proc_dointvec_minmax (ppos=<optimized out>, lenp=<optimized out>,
buffer=<optimized out>, write=<optimized out>, table=<optimized out>)
at kernel/sysctl.c:964
3  proc_do_static_key (table=<optimized out>, write=1, buffer=0x0,
lenp=0x0, ppos=0x7bf897061f9a0800) at kernel/sysctl.c:1643
4  0xffffffe000206792 in ftrace_make_call (rec=<optimized out>,
addr=<optimized out>) at arch/riscv/kernel/ftrace.c:109
5  0xffffffe0002c9c04 in __ftrace_replace_code
(rec=0xffffffe01ae40c30, enable=3) at kernel/trace/ftrace.c:2503
6  0xffffffe0002ca0b2 in ftrace_replace_code (mod_flags=<optimized
out>) at kernel/trace/ftrace.c:2530
7  0xffffffe0002ca26a in ftrace_modify_all_code (command=5) at
kernel/trace/ftrace.c:2677
8  0xffffffe0002ca30e in __ftrace_modify_code (data=<optimized out>)
at kernel/trace/ftrace.c:2703
9  0xffffffe0002c13b0 in multi_cpu_stop (data=0x0) at kernel/stop_machine.c:224
10 0xffffffe0002c0fde in cpu_stopper_thread (cpu=<optimized out>) at
kernel/stop_machine.c:491
11 0xffffffe0002343de in smpboot_thread_fn (data=0x0) at kernel/smpboot.c:165
12 0xffffffe00022f8b4 in kthread (_create=0xffffffe01af0c040) at
kernel/kthread.c:292
13 0xffffffe000201fac in handle_exception () at arch/riscv/kernel/entry.S:236

   0xffffffe00020678a <+114>:   auipc   ra,0xffffe
   0xffffffe00020678e <+118>:   jalr    -118(ra) # 0xffffffe000204714 <patch_text_nosync>
   0xffffffe000206792 <+122>:   snez    a0,a0

(gdb) disassemble patch_text_nosync
Dump of assembler code for function patch_text_nosync:
   0xffffffe000204714 <+0>:     addi    sp,sp,-32
   0xffffffe000204716 <+2>:     sd      s0,16(sp)
   0xffffffe000204718 <+4>:     sd      ra,24(sp)
   0xffffffe00020471a <+6>:     addi    s0,sp,32
   0xffffffe00020471c <+8>:     auipc   ra,0x0
   0xffffffe000204720 <+12>:    jalr    -384(ra) # 0xffffffe00020459c <patch_insn_write>
   0xffffffe000204724 <+16>:    beqz    a0,0xffffffe00020472e <patch_text_nosync+26>
   0xffffffe000204726 <+18>:    ld      ra,24(sp)
   0xffffffe000204728 <+20>:    ld      s0,16(sp)
   0xffffffe00020472a <+22>:    addi    sp,sp,32
   0xffffffe00020472c <+24>:    ret
   0xffffffe00020472e <+26>:    sd      a0,-24(s0)
   0xffffffe000204732 <+30>:    auipc   ra,0x4
   0xffffffe000204736 <+34>:    jalr    -1464(ra) # 0xffffffe00020817a <flush_icache_all>
   0xffffffe00020473a <+38>:    ld      a0,-24(s0)
   0xffffffe00020473e <+42>:    ld      ra,24(sp)
   0xffffffe000204740 <+44>:    ld      s0,16(sp)
   0xffffffe000204742 <+46>:    addi    sp,sp,32
   0xffffffe000204744 <+48>:    ret

(gdb) disassemble flush_icache_all-4
Dump of assembler code for function flush_icache_all:
   0xffffffe00020817a <+0>:     addi    sp,sp,-8
   0xffffffe00020817c <+2>:     sd      ra,0(sp)
   0xffffffe00020817e <+4>:     auipc   ra,0xfffff
   0xffffffe000208182 <+8>:     jalr    -1822(ra) # 0xffffffe000206a60 <ftrace_caller>
   0xffffffe000208186 <+12>:    ld      ra,0(sp)
   0xffffffe000208188 <+14>:    addi    sp,sp,8
   0xffffffe00020818a <+0>:     addi    sp,sp,-16
   0xffffffe00020818c <+2>:     sd      s0,0(sp)
   0xffffffe00020818e <+4>:     sd      ra,8(sp)
   0xffffffe000208190 <+6>:     addi    s0,sp,16
   0xffffffe000208192 <+8>:     li      a0,0
   0xffffffe000208194 <+10>:    auipc   ra,0xfffff
   0xffffffe000208198 <+14>:    jalr    -410(ra) # 0xffffffe000206ffa <sbi_remote_fence_i>
   0xffffffe00020819c <+18>:    ld      s0,0(sp)
   0xffffffe00020819e <+20>:    ld      ra,8(sp)
   0xffffffe0002081a0 <+22>:    addi    sp,sp,16
   0xffffffe0002081a2 <+24>:    ret

(gdb) frame 5
(rec=0xffffffe01ae40c30, enable=3) at kernel/trace/ftrace.c:2503
2503                    return ftrace_make_call(rec, ftrace_addr);
(gdb) p /x rec->ip
$2 = 0xffffffe00020817a -> flush_icache_all !

When we modified flush_icache_all's patchable-entry with ftrace_caller:
 - Insert ftrace_caller at flush_icache_all prologue.
 - Call flush_icache_all to sync I/Dcache, but flush_icache_all is
just we modified by half.

Link: https://lore.kernel.org/linux-riscv/CAJF2gTT=oDWesWe0JVWvTpGi60-gpbNhYLdFWN_5EbyeqoEDdw@mail.gmail.com/T/#t
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Reviewed-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
---
 arch/riscv/kernel/Makefile | 1 +
 arch/riscv/mm/Makefile     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index 27f10eb28bd3..62de075fc60c 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -6,6 +6,7 @@
 ifdef CONFIG_FTRACE
 CFLAGS_REMOVE_ftrace.o	= $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_patch.o	= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_sbi.o	= $(CC_FLAGS_FTRACE)
 endif
 
 extra-y += head.o
diff --git a/arch/riscv/mm/Makefile b/arch/riscv/mm/Makefile
index 6b4b7ec1bda2..7ebaef10ea1b 100644
--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -3,6 +3,7 @@
 CFLAGS_init.o := -mcmodel=medany
 ifdef CONFIG_FTRACE
 CFLAGS_REMOVE_init.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_cacheflush.o = $(CC_FLAGS_FTRACE)
 endif
 
 KCOV_INSTRUMENT_init.o := n
-- 
2.30.2

