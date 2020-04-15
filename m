Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9151D1AAD70
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 18:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415270AbgDOQNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 12:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1415265AbgDOQNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 12:13:02 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87025C061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 09:13:02 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id t199so10540564oif.7
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 09:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ncrv9jd36+qCkwrIBKA/ruUTxwR7AD9bxDQOgRKdvF4=;
        b=iVyd52XAEXxN+nk6ruavvz6YwiCJUrB6A5WzmVy0LuQOPOlEgzNcn9WW3GBVU+TMqF
         TVPTTbEUDPr7rCyF6a0nlD9bDbBjWYlUJSBvBs1YNlQUtbkFSiIMvjfqWTrVRONkv0J3
         3hrr8DCDzVsl9KMQylLIfOExLuY83gsp/yyU3TvYl7COl0wFEQ49wLn556eeXlHaNVbq
         8KSWkjfmlDARGmojXdhdCLlKU1F/zPHHJ+JJO+xGjApN3ej55t7z6Kcblp6XvI3Vejy9
         76vrP577i931hN2DoygT6wnPvwg7Nmd7q1DHcu8cTUVS1e5iKA5D2cwlpMjmowTRXGmK
         omIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ncrv9jd36+qCkwrIBKA/ruUTxwR7AD9bxDQOgRKdvF4=;
        b=p4SOAX59uvkSbSavFUcS/tcpHpGPaPg3XimS30Mtu2DErplvGBQWDE7EtPMuKfjkuE
         rgLFdzunNNTHs9xUQj1AIytiL5hrW+t30Nr0d8LgCYUEAMAqJZdLKR2oYFAE9ukIxHaN
         2HzLOcIfhIazhELdgNH0WRRDiFVC6a6YWfmtcAok+xFBv+ElAT8yGZlS/AP7naQxDSSn
         xpeDIXIQkzlLAkWh/L59G4YvIxfSmVnQIp78z1+H67VX6uuOEntPhIQrhiVsRXmYXDR8
         ZQWFWVRuRSB65fjqOctBmkIw26hKIV7+xPCZUhQTGPYoBVdoNctZKXtrwRBwqpEOn+4M
         QsSw==
X-Gm-Message-State: AGi0PubyejLDUoKHjuIEWVMX0FAxUvR4kWw/P4ykWN6RiR7Yjm0m3w+A
        jRNXm4WWR1GvtrNkIUnVCuc=
X-Google-Smtp-Source: APiQypLGMQj9s+WyQ6lAScyLrA8nXFEJXs9kk4dFcwQ4luJAd8FMPvnmaQsVGBK1t7XcS70QU6t6yw==
X-Received: by 2002:aca:f541:: with SMTP id t62mr5080232oih.148.1586967181807;
        Wed, 15 Apr 2020 09:13:01 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::3])
        by smtp.gmail.com with ESMTPSA id a131sm6450242oii.30.2020.04.15.09.13.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Apr 2020 09:13:00 -0700 (PDT)
Date:   Wed, 15 Apr 2020 09:12:59 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     courbet@google.com, mpe@ellerman.id.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc: Make setjmp/longjmp signature
 standard" failed to apply to 4.14-stable tree
Message-ID: <20200415161259.GA44996@ubuntu-s3-xlarge-x86>
References: <15869565461129@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <15869565461129@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 15, 2020 at 03:15:46PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
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

Attached is a backport for 4.14 (that patch plus a prerequisite one).

Cheers,
Nathan

--LZvS9be/3tNcYl/X
Content-Type: application/mbox
Content-Disposition: attachment; filename="4.14.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom ba153be99f3771f0a14ab251a94a6640d7045294 Mon Sep 17 00:00:00 2001=0A=
=46rom: Segher Boessenkool <segher@kernel.crashing.org>=0ADate: Wed, 4 Sep =
2019 14:11:07 +0000=0ASubject: [PATCH 4.14 1/2] powerpc: Add attributes for=
 setjmp/longjmp=0A=0Acommit aa497d4352414aad22e792b35d0aaaa12bbc37c5 upstre=
am.=0A=0AThe setjmp function should be declared as "returns_twice", or bad=
=0Athings can happen[1]. This does not actually change generated code in=0A=
my testing.=0A=0AThe longjmp function should be declared as "noreturn", so =
that the=0Acompiler can optimise calls to it better. This makes the generat=
ed=0Acode a little shorter.=0A=0A1: https://gcc.gnu.org/onlinedocs/gcc/Comm=
on-Function-Attributes.html#index-returns_005ftwice-function-attribute=0A=
=0ASigned-off-by: Segher Boessenkool <segher@kernel.crashing.org>=0ASigned-=
off-by: Michael Ellerman <mpe@ellerman.id.au>=0ALink: https://lore.kernel.o=
rg/r/c02ce4a573f3bac907e2c70957a2d1275f910013.1567605586.git.segher@kernel.=
crashing.org=0ASigned-off-by: Nathan Chancellor <natechancellor@gmail.com>=
=0A---=0A arch/powerpc/include/asm/setjmp.h | 4 ++--=0A 1 file changed, 2 i=
nsertions(+), 2 deletions(-)=0A=0Adiff --git a/arch/powerpc/include/asm/set=
jmp.h b/arch/powerpc/include/asm/setjmp.h=0Aindex 279d03a1eec62..d930f5607e=
f25 100644=0A--- a/arch/powerpc/include/asm/setjmp.h=0A+++ b/arch/powerpc/i=
nclude/asm/setjmp.h=0A@@ -12,7 +12,7 @@=0A =0A #define JMP_BUF_LEN    23=0A=
 =0A-extern long setjmp(long *);=0A-extern void longjmp(long *, long);=0A+e=
xtern long setjmp(long *) __attribute__((returns_twice));=0A+extern void lo=
ngjmp(long *, long) __attribute__((noreturn));=0A =0A #endif /* _ASM_POWERP=
C_SETJMP_H */=0A=0Abase-commit: c10b57a567e4333b9fdf60b5ec36de9859263ca2=0A=
-- =0A2.26.1=0A=0A=0AFrom ec90a96bf0278d54902c766ab8d05334b7f99eb5 Mon Sep =
17 00:00:00 2001=0AFrom: Clement Courbet <courbet@google.com>=0ADate: Mon, =
30 Mar 2020 10:03:56 +0200=0ASubject: [PATCH 4.14 2/2] powerpc: Make setjmp=
/longjmp signature standard=0A=0Acommit c17eb4dca5a353a9dbbb8ad6934fe57af71=
65e91 upstream.=0A=0ADeclaring setjmp()/longjmp() as taking longs makes the=
 signature=0Anon-standard, and makes clang complain. In the past, this has =
been=0Aworked around by adding -ffreestanding to the compile flags.=0A=0ATh=
e implementation looks like it only ever propagates the value=0A(in longjmp=
) or sets it to 1 (in setjmp), and we only call longjmp=0Awith integer para=
meters.=0A=0AThis allows removing -ffreestanding from the compilation flags=
=2E=0A=0AFixes: c9029ef9c957 ("powerpc: Avoid clang warnings around setjmp =
and longjmp")=0ACc: stable@vger.kernel.org # v4.14+=0ASigned-off-by: Clemen=
t Courbet <courbet@google.com>=0AReviewed-by: Nathan Chancellor <natechance=
llor@gmail.com>=0ATested-by: Nathan Chancellor <natechancellor@gmail.com>=
=0ASigned-off-by: Michael Ellerman <mpe@ellerman.id.au>=0ALink: https://lor=
e.kernel.org/r/20200330080400.124803-1-courbet@google.com=0ASigned-off-by: =
Nathan Chancellor <natechancellor@gmail.com>=0A---=0A arch/powerpc/include/=
asm/setjmp.h | 6 ++++--=0A arch/powerpc/kernel/Makefile      | 3 ---=0A arc=
h/powerpc/xmon/Makefile        | 3 ---=0A 3 files changed, 4 insertions(+),=
 8 deletions(-)=0A=0Adiff --git a/arch/powerpc/include/asm/setjmp.h b/arch/=
powerpc/include/asm/setjmp.h=0Aindex d930f5607ef25..6941fe202bc82 100644=0A=
--- a/arch/powerpc/include/asm/setjmp.h=0A+++ b/arch/powerpc/include/asm/se=
tjmp.h=0A@@ -12,7 +12,9 @@=0A =0A #define JMP_BUF_LEN    23=0A =0A-extern l=
ong setjmp(long *) __attribute__((returns_twice));=0A-extern void longjmp(l=
ong *, long) __attribute__((noreturn));=0A+typedef long jmp_buf[JMP_BUF_LEN=
];=0A+=0A+extern int setjmp(jmp_buf env) __attribute__((returns_twice));=0A=
+extern void longjmp(jmp_buf env, int val) __attribute__((noreturn));=0A =
=0A #endif /* _ASM_POWERPC_SETJMP_H */=0Adiff --git a/arch/powerpc/kernel/M=
akefile b/arch/powerpc/kernel/Makefile=0Aindex 5607ce67d178b..681f966b7211d=
 100644=0A--- a/arch/powerpc/kernel/Makefile=0A+++ b/arch/powerpc/kernel/Ma=
kefile=0A@@ -5,9 +5,6 @@=0A =0A CFLAGS_ptrace.o		+=3D -DUTS_MACHINE=3D'"$(U=
TS_MACHINE)"'=0A =0A-# Avoid clang warnings around longjmp/setjmp declarati=
ons=0A-CFLAGS_crash.o +=3D -ffreestanding=0A-=0A subdir-ccflags-$(CONFIG_PP=
C_WERROR) :=3D -Werror=0A =0A ifeq ($(CONFIG_PPC64),y)=0Adiff --git a/arch/=
powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile=0Aindex a60c44b4a3e50..9=
3974b0a5a99e 100644=0A--- a/arch/powerpc/xmon/Makefile=0A+++ b/arch/powerpc=
/xmon/Makefile=0A@@ -1,9 +1,6 @@=0A # SPDX-License-Identifier: GPL-2.0=0A #=
 Makefile for xmon=0A =0A-# Avoid clang warnings around longjmp/setjmp decl=
arations=0A-subdir-ccflags-y :=3D -ffreestanding=0A-=0A subdir-ccflags-$(CO=
NFIG_PPC_WERROR) +=3D -Werror=0A =0A GCOV_PROFILE :=3D n=0A-- =0A2.26.1=0A=
=0A
--LZvS9be/3tNcYl/X--
