Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3F61AAD96
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 18:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406394AbgDOQPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 12:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2410312AbgDOQPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 12:15:39 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A6CC061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 09:15:39 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id j16so13935822oih.10
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 09:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EhXgBm3jI1egFOrYdSGW8hDQb64kaf5tSWrfTw3VZfI=;
        b=LuubDDMnoveDzlYS8jWHhSyLfCtg4JuAXE2d+24VjPOzSnVzs/zkS8WXLvi9ETT8da
         zR8060szhx1Pqn7ZUQNocq6b/WxloBIP89tyUUyv7SbRmUvdqTXfT54DH3I+DAazujA7
         a683Dd4TIYg43BuZuM5A5vReNO2d3jz+1RJ0qiT/dWSzMlXRXBlcXKZ9zY1XTv+aijkq
         BNY4zHgr1A7uXuc8OeCkUC4yg77Ey1gXRv+PgseR8gJWGxoKOKN1RuWJV1kgx63j2e0T
         CcqDMoGgwbZYSFJFQKI9K5MIc3DcmJBIfsKa4goNIkgf00+8OsAZ6e2lr3GaMSCpPMxF
         vBCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EhXgBm3jI1egFOrYdSGW8hDQb64kaf5tSWrfTw3VZfI=;
        b=R9f1GOZqnNivHMZGKih7dVk8PHHwJkpp6jYJ0UvVg6F5bk+LkrqZ3oyhZp8ZOKsU4o
         vjJsHMXFTCvWnxI7K+hGkfu4xeQGMsj9N29gu75uuJR55bK3V/y3WDD0iv0haVblzOep
         KTVDj6NF9qw3H9XvWVHuO6oM7N68lMnWy+NgJ2y/2n8HlbL2+EFl6lHxrYmVk87rcXyi
         IpjYl0LmYmLUgwNxLZy8z6pvdiEvoAV2wGWAgAmve+qEvEXKhw/Be0MfQ6NfVRti2S5v
         WM1CjwlRQ4g66DIsZao5x30P6okjubQ3Yp6BY9TF50o8DXQHS25Bn1gLQXjI5cec7cDl
         nyjg==
X-Gm-Message-State: AGi0PuYjvR4Mvd2nVHVg6VlStDd6KuNLT5nKIrzDxbtqfrwddOTLZac4
        7Rk5ulD6UbwadlVDXHjfEywZwaPF
X-Google-Smtp-Source: APiQypJqZB/O5/wIo8zfCYUC8oM8SeUyoyS7k45IHer//BUo0XF0ui+ZglqU/NDAksfy0GCkMbleyg==
X-Received: by 2002:aca:f50e:: with SMTP id t14mr10931895oih.156.1586967338382;
        Wed, 15 Apr 2020 09:15:38 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::3])
        by smtp.gmail.com with ESMTPSA id b2sm6507080oii.20.2020.04.15.09.15.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Apr 2020 09:15:37 -0700 (PDT)
Date:   Wed, 15 Apr 2020 09:15:36 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     courbet@google.com, mpe@ellerman.id.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc: Make setjmp/longjmp signature
 standard" failed to apply to 5.4-stable tree
Message-ID: <20200415161536.GA45363@ubuntu-s3-xlarge-x86>
References: <15869565475638@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <15869565475638@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 15, 2020 at 03:15:47PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From c17eb4dca5a353a9dbbb8ad6934fe57af7165e91 Mon Sep 17 00:00:00 2001
> From: Clement Courbet <courbet@google.com>
> Date: Mon, 30 Mar 2020 10:03:56 +0200
> Subject: [PATCH] powerpc: Make setjmp/longjmp signature standard
> 
> Declaring setjmp()/longjmp() as taking longs makes the signature
> non-standard, and makes clang complain. In the past, this has been
> worked around by adding -ffreestanding to the compile flags.
> 
> The implementation looks like it only ever propagates the value
> (in longjmp) or sets it to 1 (in setjmp), and we only call longjmp
> with integer parameters.
> 
> This allows removing -ffreestanding from the compilation flags.
> 
> Fixes: c9029ef9c957 ("powerpc: Avoid clang warnings around setjmp and longjmp")
> Cc: stable@vger.kernel.org # v4.14+
> Signed-off-by: Clement Courbet <courbet@google.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20200330080400.124803-1-courbet@google.com
> 
> diff --git a/arch/powerpc/include/asm/setjmp.h b/arch/powerpc/include/asm/setjmp.h
> index e9f81bb3f83b..f798e80e4106 100644
> --- a/arch/powerpc/include/asm/setjmp.h
> +++ b/arch/powerpc/include/asm/setjmp.h
> @@ -7,7 +7,9 @@
>  
>  #define JMP_BUF_LEN    23
>  
> -extern long setjmp(long *) __attribute__((returns_twice));
> -extern void longjmp(long *, long) __attribute__((noreturn));
> +typedef long jmp_buf[JMP_BUF_LEN];
> +
> +extern int setjmp(jmp_buf env) __attribute__((returns_twice));
> +extern void longjmp(jmp_buf env, int val) __attribute__((noreturn));
>  
>  #endif /* _ASM_POWERPC_SETJMP_H */
> diff --git a/arch/powerpc/kexec/Makefile b/arch/powerpc/kexec/Makefile
> index 378f6108a414..86380c69f5ce 100644
> --- a/arch/powerpc/kexec/Makefile
> +++ b/arch/powerpc/kexec/Makefile
> @@ -3,9 +3,6 @@
>  # Makefile for the linux kernel.
>  #
>  
> -# Avoid clang warnings around longjmp/setjmp declarations
> -CFLAGS_crash.o += -ffreestanding
> -
>  obj-y				+= core.o crash.o core_$(BITS).o
>  
>  obj-$(CONFIG_PPC32)		+= relocate_32.o
> diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
> index c3842dbeb1b7..6f9cccea54f3 100644
> --- a/arch/powerpc/xmon/Makefile
> +++ b/arch/powerpc/xmon/Makefile
> @@ -1,9 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Makefile for xmon
>  
> -# Avoid clang warnings around longjmp/setjmp declarations
> -subdir-ccflags-y := -ffreestanding
> -
>  GCOV_PROFILE := n
>  KCOV_INSTRUMENT := n
>  UBSAN_SANITIZE := n
> 

5.4 backport attached.

Cheers,
Nathan

--pf9I7BMVVzbSWLtt
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-powerpc-Make-setjmp-longjmp-signature-standard.patch"

From 1de31c805515171f5bfb1022e32ff1f491050162 Mon Sep 17 00:00:00 2001
From: Clement Courbet <courbet@google.com>
Date: Mon, 30 Mar 2020 10:03:56 +0200
Subject: [PATCH 5.4] powerpc: Make setjmp/longjmp signature standard

commit c17eb4dca5a353a9dbbb8ad6934fe57af7165e91 upstream.

Declaring setjmp()/longjmp() as taking longs makes the signature
non-standard, and makes clang complain. In the past, this has been
worked around by adding -ffreestanding to the compile flags.

The implementation looks like it only ever propagates the value
(in longjmp) or sets it to 1 (in setjmp), and we only call longjmp
with integer parameters.

This allows removing -ffreestanding from the compilation flags.

Fixes: c9029ef9c957 ("powerpc: Avoid clang warnings around setjmp and longjmp")
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Clement Courbet <courbet@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200330080400.124803-1-courbet@google.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 arch/powerpc/include/asm/setjmp.h | 6 ++++--
 arch/powerpc/kernel/Makefile      | 3 ---
 arch/powerpc/xmon/Makefile        | 3 ---
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/setjmp.h b/arch/powerpc/include/asm/setjmp.h
index e9f81bb3f83b0..f798e80e41061 100644
--- a/arch/powerpc/include/asm/setjmp.h
+++ b/arch/powerpc/include/asm/setjmp.h
@@ -7,7 +7,9 @@
 
 #define JMP_BUF_LEN    23
 
-extern long setjmp(long *) __attribute__((returns_twice));
-extern void longjmp(long *, long) __attribute__((noreturn));
+typedef long jmp_buf[JMP_BUF_LEN];
+
+extern int setjmp(jmp_buf env) __attribute__((returns_twice));
+extern void longjmp(jmp_buf env, int val) __attribute__((noreturn));
 
 #endif /* _ASM_POWERPC_SETJMP_H */
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 3c02445cf0865..dc0780f930d5b 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -5,9 +5,6 @@
 
 CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
 
-# Avoid clang warnings around longjmp/setjmp declarations
-CFLAGS_crash.o += -ffreestanding
-
 ifdef CONFIG_PPC64
 CFLAGS_prom_init.o	+= $(NO_MINIMAL_TOC)
 endif
diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
index c3842dbeb1b75..6f9cccea54f3b 100644
--- a/arch/powerpc/xmon/Makefile
+++ b/arch/powerpc/xmon/Makefile
@@ -1,9 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for xmon
 
-# Avoid clang warnings around longjmp/setjmp declarations
-subdir-ccflags-y := -ffreestanding
-
 GCOV_PROFILE := n
 KCOV_INSTRUMENT := n
 UBSAN_SANITIZE := n

base-commit: bc844d58f697dff3ded4b410094ee89f5cedc04c
-- 
2.26.1


--pf9I7BMVVzbSWLtt--
