Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD451AAD81
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 18:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415233AbgDOQOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 12:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1415386AbgDOQOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 12:14:09 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1C9C061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 09:14:09 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id m14so13951934oic.0
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 09:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uoNqpc8keq5UGcRaLYeTCah1iCs1GN7aUPDHgNBgqOQ=;
        b=J4x3eax5wueM5tDWF9X++NG6MM7juPL2Mxya0yxW9NC0ZEaam0aJLgM6azlCRMzkGh
         v/qqk1pw2fwXqUnQsmpO638P5o2OjODNZ6ZSl0CAeICYqDd7YcmAs9kjKFBATrZSQOhQ
         pYB6AeNufiho5uTRhmhEh8binjmZy592lFn9aCUyJ9tLFejXKQg3dASLgAHdK2dLtj+O
         6AkC7tNpQ7hgjKFuOWu/cI/ZCigX8v4jtaS1qQF230fBYFuvzZOSmldKjybXJOMit90v
         lwJUJpdPSDVvi+GWU6Rf3oOTkthXXN+L9rkaNSw0ggQefGAaDOuC6CcTnIDSzqWzxhD1
         deiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uoNqpc8keq5UGcRaLYeTCah1iCs1GN7aUPDHgNBgqOQ=;
        b=ILxfoe8uOOofiJPXUC/8kQEBBlFnedyqutdhN23HBTUBokHUTMUpBxrg2zIyZ+uDqr
         42Avdxs44s1cDq+eFlJxvNVwAJqMs7Idr+NAVWsDg7a8GMKd/g61Fp28nevnc20qFs81
         AvVAxkzIm3MW+keIls//qnfczWDjFeZ0bbvUBTXg0DOlPXYSdG9BKK94w3bGaeUmSBxN
         OnfdIk3kDOQyxpmO4pc0IheSmkDQn5w9xlUZ+YrSzx5andBJPuOqwopPV7TpTjH8UwoC
         kox6MMZjtEPRaQLHR7KDRzpgVNxnQkVUJDAsyQ6N2+h4tDUYDrj+tbhGu9Krkf3YylLv
         jBDg==
X-Gm-Message-State: AGi0Pua3f7ccgg+CD2eZcljb3W5rVMSYT/G+0zYKMv/s0l6Xvf3CZdW6
        EOwnsSXqfWFQOOGMz2WPtPE=
X-Google-Smtp-Source: APiQypLQgCBjoBinLtgrcFky+8SGKyEc7HBSsU4Ywvn8k1JOhkap0Dj2ksG6PdSqfw07GSKqa2ubug==
X-Received: by 2002:a05:6808:651:: with SMTP id z17mr8730395oih.73.1586967248981;
        Wed, 15 Apr 2020 09:14:08 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::3])
        by smtp.gmail.com with ESMTPSA id c24sm4669938otn.40.2020.04.15.09.14.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Apr 2020 09:14:07 -0700 (PDT)
Date:   Wed, 15 Apr 2020 09:14:05 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     courbet@google.com, mpe@ellerman.id.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc: Make setjmp/longjmp signature
 standard" failed to apply to 4.19-stable tree
Message-ID: <20200415161405.GB44996@ubuntu-s3-xlarge-x86>
References: <158695654686139@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
In-Reply-To: <158695654686139@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 15, 2020 at 03:15:46PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
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

Attached is a backport for 4.19 (that patch plus a prerequisite one).

Cheers,
Nathan

--gatW/ieO32f1wygP
Content-Type: application/mbox
Content-Disposition: attachment; filename="4.19.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 8b71a12e884cc8a041d01ead29205c372e55a632 Mon Sep 17 00:00:00 2001=0A=
=46rom: Segher Boessenkool <segher@kernel.crashing.org>=0ADate: Wed, 4 Sep =
2019 14:11:07 +0000=0ASubject: [PATCH 4.19 1/2] powerpc: Add attributes for=
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
C_SETJMP_H */=0A=0Abase-commit: 6dd0e32665e591e9debe3edaf73c2f8135bf047e=0A=
-- =0A2.26.1=0A=0A=0AFrom e5d8b78d545df82bcd22e44a3e560d5a91516830 Mon Sep =
17 00:00:00 2001=0AFrom: Clement Courbet <courbet@google.com>=0ADate: Mon, =
30 Mar 2020 10:03:56 +0200=0ASubject: [PATCH 4.19 2/2] powerpc: Make setjmp=
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
akefile b/arch/powerpc/kernel/Makefile=0Aindex d450280e5c29c..1e64cfe22a83e=
 100644=0A--- a/arch/powerpc/kernel/Makefile=0A+++ b/arch/powerpc/kernel/Ma=
kefile=0A@@ -5,9 +5,6 @@=0A =0A CFLAGS_ptrace.o		+=3D -DUTS_MACHINE=3D'"$(U=
TS_MACHINE)"'=0A =0A-# Avoid clang warnings around longjmp/setjmp declarati=
ons=0A-CFLAGS_crash.o +=3D -ffreestanding=0A-=0A subdir-ccflags-$(CONFIG_PP=
C_WERROR) :=3D -Werror=0A =0A ifdef CONFIG_PPC64=0Adiff --git a/arch/powerp=
c/xmon/Makefile b/arch/powerpc/xmon/Makefile=0Aindex 365e711bebabb..ab193cd=
7dbf90 100644=0A--- a/arch/powerpc/xmon/Makefile=0A+++ b/arch/powerpc/xmon/=
Makefile=0A@@ -1,9 +1,6 @@=0A # SPDX-License-Identifier: GPL-2.0=0A # Makef=
ile for xmon=0A =0A-# Avoid clang warnings around longjmp/setjmp declaratio=
ns=0A-subdir-ccflags-y :=3D -ffreestanding=0A-=0A subdir-ccflags-$(CONFIG_P=
PC_WERROR) +=3D -Werror=0A =0A GCOV_PROFILE :=3D n=0A-- =0A2.26.1=0A=0A
--gatW/ieO32f1wygP--
