Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0E31C0C85
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 05:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgEADVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 23:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgEADVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 23:21:02 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891E5C035494;
        Thu, 30 Apr 2020 20:21:02 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w65so1027791pfc.12;
        Thu, 30 Apr 2020 20:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=7HcFBMjFrcWXcaxPCvfiay+8yWpZ9NZg39Yk9Jl8op0=;
        b=TF5Vs1fwPQOCnlfaNvn4W0v54ALE0gsIf2jWbByFcOhcRjcv+8g9PdxdnaQiJD3cGn
         L9/EaHQ3l0ZDngMKA1wKsT6r7oY9BL9D5Kejf1gAOEmLTIUEU/SVD2aVAtwXomEARLLU
         jVEiKYe0ZF573PUViQST43ljHjC6z0OUIX7g4rDgvJMgERV2L+UAkOeZLO3FJNqFXdAs
         CMJiuJNBUzNym93HNWg4GKoiQKBvKKOAUVO1dTSl5FpNd+RfeISYQjRUVkLV3iIg5C9X
         hZ9Yq3e56k4IAEd6TLcvTlaNsOruaWrcDkC6xoSYcbTB745Gso5XQCLlJI1LONT6fOLZ
         HTUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=7HcFBMjFrcWXcaxPCvfiay+8yWpZ9NZg39Yk9Jl8op0=;
        b=svq9U+ERQJOUzgzyTz/NOR5A+mYbDtQcrW7W8ETGX0OGkGBPb4xZv+0cMG3jzqG8Mw
         kKbMscJD0lrYfrj8KaBcZjgIqGB+6ubMDf/nfqfdfvJ22zVWUhWo2Vt77Rszc8j6Qxr/
         XxwyeyDy57hsz7uTyCO3OHNlxSek+U6DRJc/Q65O8fcHMs6oK3yekodwV6X86XPsSCxz
         stjfVOuoKfRxovI8Q/K97mMXLgjJomrcwgc3OLyXPb+h+17zTMy//8Qi5EapoBZ0Ww2A
         TPaDRzew6qMMklnaiBTgMO3qaOXVz5o6jBHvOCICvCQZLzPRvJwEw2J6SG72M6sGl0Jo
         emIw==
X-Gm-Message-State: AGi0PuZnMKD6UpgVhvQ8MRkXS//s7eTgpo/0zxweygYJFuErCgYSWvNw
        pH42LmXZj3qEZFm/Yw3NSg2LA9qM
X-Google-Smtp-Source: APiQypLfb1YXmzbFRiuEgKV/Fek4g9O8acitGrv3m5ooOwF6yHNTgnBCT+REDBRFFZew8D4hpKxPYA==
X-Received: by 2002:a63:e503:: with SMTP id r3mr2339270pgh.106.1588303261729;
        Thu, 30 Apr 2020 20:21:01 -0700 (PDT)
Received: from udknight.localhost ([59.57.158.27])
        by smtp.gmail.com with ESMTPSA id s199sm994550pfs.124.2020.04.30.20.21.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Apr 2020 20:21:00 -0700 (PDT)
Received: from udknight.localhost (localhost [127.0.0.1])
        by udknight.localhost (8.14.9/8.14.4) with ESMTP id 0413Jq3P004819;
        Fri, 1 May 2020 11:19:52 +0800
Received: (from root@localhost)
        by udknight.localhost (8.14.9/8.14.9/Submit) id 0413JorC004818;
        Fri, 1 May 2020 11:19:50 +0800
Date:   Fri, 1 May 2020 11:19:50 +0800
From:   Wang YanQing <udknight@gmail.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, lukenels@cs.washington.edu,
        ast@kernel.org, luke.r.nels@gmail.com, udknight@gmail.com,
        xi.wang@gmail.com, daniel@iogearbox.net, bpf@vger.kernel.org
Subject: [PATCH] bpf, x86_32: Fix clobbering of dst for BPF_JSET
Message-ID: <20200501031950.GA4782@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.7.1 (2016-10-04)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 50fe7ebb6475711c15b3397467e6424e20026d94 upstream.

The current JIT clobbers the destination register for BPF_JSET BPF_X
and BPF_K by using "and" and "or" instructions. This is fine when the
destination register is a temporary loaded from a register stored on
the stack but not otherwise.

This patch fixes the problem (for both BPF_K and BPF_X) by always loading
the destination register into temporaries since BPF_JSET should not
modify the destination register.

This bug may not be currently triggerable as BPF_REG_AX is the only
register not stored on the stack and the verifier uses it in a limited
way.

Fixes: 03f5781be2c7b ("bpf, x86_32: add eBPF JIT compiler for ia32")
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Wang YanQing <udknight@gmail.com>
Link: https://lore.kernel.org/bpf/20200422173630.8351-2-luke.r.nels@gmail.com
Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 arch/x86/net/bpf_jit_comp32.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 24d573b..7e7ca5d 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1968,8 +1968,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			goto emit_cond_jmp_signed;
 		}
 		case BPF_JMP | BPF_JSET | BPF_X: {
-			u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
-			u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
+			u8 dreg_lo = IA32_EAX;
+			u8 dreg_hi = IA32_EDX;
 			u8 sreg_lo = sstk ? IA32_ECX : src_lo;
 			u8 sreg_hi = sstk ? IA32_EBX : src_hi;
 
@@ -1978,6 +1978,12 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 				      STACK_VAR(dst_lo));
 				EMIT3(0x8B, add_2reg(0x40, IA32_EBP, IA32_EDX),
 				      STACK_VAR(dst_hi));
+			} else {
+				/* mov dreg_lo,dst_lo */
+				EMIT2(0x89, add_2reg(0xC0, dreg_lo, dst_lo));
+				/* mov dreg_hi,dst_hi */
+				EMIT2(0x89,
+				      add_2reg(0xC0, dreg_hi, dst_hi));
 			}
 
 			if (sstk) {
@@ -1996,8 +2002,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		}
 		case BPF_JMP | BPF_JSET | BPF_K: {
 			u32 hi;
-			u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
-			u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
+			u8 dreg_lo = IA32_EAX;
+			u8 dreg_hi = IA32_EDX;
 			u8 sreg_lo = IA32_ECX;
 			u8 sreg_hi = IA32_EBX;
 
@@ -2006,6 +2012,12 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 				      STACK_VAR(dst_lo));
 				EMIT3(0x8B, add_2reg(0x40, IA32_EBP, IA32_EDX),
 				      STACK_VAR(dst_hi));
+			} else {
+				/* mov dreg_lo,dst_lo */
+				EMIT2(0x89, add_2reg(0xC0, dreg_lo, dst_lo));
+				/* mov dreg_hi,dst_hi */
+				EMIT2(0x89,
+				      add_2reg(0xC0, dreg_hi, dst_hi));
 			}
 			hi = imm32 & (1<<31) ? (u32)~0 : 0;
 
-- 
1.8.5.6.2.g3d8a54e.dirty
