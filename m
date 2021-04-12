Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F5435C93E
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 16:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242174AbhDLOxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 10:53:46 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:28205 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237526AbhDLOxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 10:53:44 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1618239187; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=MLuI3MKguIFD8aMO98EqIV6tT+xPd/xbMFTlhykqHuoNswAI0NZQT/wob0gH4P0wTE
    BiQxLn4KrAKpiIZ4aCZYKSAJLu+AKYqcq2YWbk3ol/zFeL2a8ahsOKHUFt5dhEZn2uUr
    EFaDA9FAgZaylBaGElqnggHMoUSl+72mV7X6DyfyQPTqNyXNdLD4WB1ebKHrqNjicQG1
    hvWtWwy0pLCno9wF8PaF784dI9fF0V1WYis+54M4NGMCYDJ9w6tqp+Bo1xJuclkUVfAT
    t54e1C3VrurqW4Q0KB0AQ7D/IcA7dTzc4S4jaVUEpp2bxoQo5yBtdz1/THkndTVEDPsL
    MeXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1618239187;
    s=strato-dkim-0002; d=strato.com;
    h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=xVwpMOFSi8bUIQk5SsNGaQQ3DMFn8l93o0bZv8mK5Qg=;
    b=SLH9aXpLVKWxXnGyl/yoWQtqOLuDeOKwSIEkSmBEH9l9g/NvdGdcWIXzqG6mGY5dwP
    GFFAeIl8iwSXFVnHnzaC6sqqG9N+/efEUp7rhxbNFG/TQb7lGKIvJOlnzvzMpjDDF3qy
    AtpPHuU4LoawNAdcYCuVrVYGIyOoVHxMRePfbzPdX2L+qFweAGK41klkWzGGN9IsCpuG
    ZWwtn/eVCznMdfKzFOv7Cq7/g6CWrOBjogHioLhKb920L0t+iq7NzCZ09zwqPc2jwbSr
    zzZ9TMHeHRknduAzqRzHNAU3VRnI8IcLmkLtVbdw01DVgySiU199yWqVHKt8TezseXLs
    il1w==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1618239187;
    s=strato-dkim-0002; d=goldelico.com;
    h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=xVwpMOFSi8bUIQk5SsNGaQQ3DMFn8l93o0bZv8mK5Qg=;
    b=THpGn9VO689MNcKvfh0d6eS6CyZoWg9+4B84KXgcUBrqihwArml4Wz1JqHklIQwyWi
    JOzTvnuYHJtge0rxw3J3p4EbneGJVYZ2VVvcDO8WQBKUZmDEvtVMziVZII3mwRCAeUQl
    L162Ns+7Sv+X61McNpylc08HLys3RRj2L6HIo2+jV5e2Qvlrp3gNh8GyTG+X2YGu6+Ay
    YiI4l3Hz/Bp1CVHCY6epP/h1s3PyzGMp+EeIRQCaQEXw5WfrNCfYU3jtiO0QcecQ5jKb
    mSh3Pu718EPxQGQKka8+oiaYhwFj967RGB/E+b+8WWvj3Q2fLZ45cZC32m0cLpPfaU53
    wkeA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj4Qpw9iZeHmMlw47o5n4="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
    by smtp.strato.de (RZmta 47.24.0 DYNA|AUTH)
    with ESMTPSA id Z028d1x3CEr6K3F
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Mon, 12 Apr 2021 16:53:06 +0200 (CEST)
Subject: Re: [PATCH] MIPS: Remove unused and erroneous div64.h
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20210412033451.215379-1-chenhuacai@loongson.cn>
Date:   Mon, 12 Apr 2021 16:53:06 +0200
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <91DBD35C-6282-4B24-B8DE-5E52DFFE29D1@goldelico.com>
References: <20210412033451.215379-1-chenhuacai@loongson.cn>
To:     Huacai Chen <chenhuacai@kernel.org>
X-Mailer: Apple Mail (2.3124)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> Am 12.04.2021 um 05:34 schrieb Huacai Chen <chenhuacai@kernel.org>:
>=20
> There are many errors in div64.h caused by commit =
c21004cd5b4cb7d479514
> ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0."):
>=20
> 1, Only 32bit kernel need __div64_32(), but the above commit makes it
>   depend on 64bit kernel by mistake. So div64.h is unused in fact.
>=20
> 2, asm-generic/div64.h should be included after __div64_32() =
definition.
>=20
> 3, __n should be initialized as *n before use (and "*__n >> 32" should
>   be "__n >> 32") in __div64_32() definition.
>=20
> 4, linux/types.h should be included at the first place, otherwise =
BITS_
>   PER_LONG is not defined.
>=20
> 5, As Nikolaus, Yunqiang Su and Yanjie Zhou said, the MIPS-specific

s/Nikolaus/Nikolaus Schaller/

>   __div64_32() sometimes produces wrong results, which makes 32bit
>   kernel boot fails.
>=20
> I have tried to fix theses errors but I have failed with the last one.
> Yunqiang's tests show that the MIPS-specific __div64_32() has no =
obvious
> advantage than the C version, so I just simply remove div64.h.

This version works on both, alpha400/jz4730 and ci20/jz4780 (both 32 =
bit).

I have cross-checked the tree for *div64* files and only found as mips
specific or lib files:

./arch/mips/include/generated/asm/div64.h	-> #include =
<asm-generic/div64.h>
./include/asm-generic/div64.h
./lib/math/div64.c

So there were no remains from earlier compile runs.

And since it seems to have no advantage over the C version, I agree
that we can remove the special code instead of wasting time to fix it.

>=20
> Fixes: c21004cd5b4cb7d479514 ("MIPS: Rewrite <asm/div64.h> to work =
with gcc 4.4.0.")
> Cc: stable@vger.kernel.org

Tested-by: H. Nikolaus Schaller <hns@goldelico.com>	# CI20/jz4780 =
and Alpha400/jz4730

BR and thanks,
Nikolaus Schaller


> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
> arch/mips/include/asm/div64.h | 68 -----------------------------------
> 1 file changed, 68 deletions(-)
> delete mode 100644 arch/mips/include/asm/div64.h
>=20
> diff --git a/arch/mips/include/asm/div64.h =
b/arch/mips/include/asm/div64.h
> deleted file mode 100644
> index dc5ea5736440..000000000000
> --- a/arch/mips/include/asm/div64.h
> +++ /dev/null
> @@ -1,68 +0,0 @@
> -/*
> - * Copyright (C) 2000, 2004  Maciej W. Rozycki
> - * Copyright (C) 2003, 07 Ralf Baechle (ralf@linux-mips.org)
> - *
> - * This file is subject to the terms and conditions of the GNU =
General Public
> - * License.  See the file "COPYING" in the main directory of this =
archive
> - * for more details.
> - */
> -#ifndef __ASM_DIV64_H
> -#define __ASM_DIV64_H
> -
> -#include <asm-generic/div64.h>
> -
> -#if BITS_PER_LONG =3D=3D 64
> -
> -#include <linux/types.h>
> -
> -/*
> - * No traps on overflows for any of these...
> - */
> -
> -#define __div64_32(n, base)						=
\
> -({									=
\
> -	unsigned long __cf, __tmp, __tmp2, __i;				=
\
> -	unsigned long __quot32, __mod32;				=
\
> -	unsigned long __high, __low;					=
\
> -	unsigned long long __n;						=
\
> -									=
\
> -	__high =3D *__n >> 32;						=
\
> -	__low =3D __n;							=
\
> -	__asm__(							=
\
> -	"	.set	push					\n"	=
\
> -	"	.set	noat					\n"	=
\
> -	"	.set	noreorder				\n"	=
\
> -	"	move	%2, $0					\n"	=
\
> -	"	move	%3, $0					\n"	=
\
> -	"	b	1f					\n"	=
\
> -	"	 li	%4, 0x21				\n"	=
\
> -	"0:							\n"	=
\
> -	"	sll	$1, %0, 0x1				\n"	=
\
> -	"	srl	%3, %0, 0x1f				\n"	=
\
> -	"	or	%0, $1, %5				\n"	=
\
> -	"	sll	%1, %1, 0x1				\n"	=
\
> -	"	sll	%2, %2, 0x1				\n"	=
\
> -	"1:							\n"	=
\
> -	"	bnez	%3, 2f					\n"	=
\
> -	"	 sltu	%5, %0, %z6				\n"	=
\
> -	"	bnez	%5, 3f					\n"	=
\
> -	"2:							\n"	=
\
> -	"	 addiu	%4, %4, -1				\n"	=
\
> -	"	subu	%0, %0, %z6				\n"	=
\
> -	"	addiu	%2, %2, 1				\n"	=
\
> -	"3:							\n"	=
\
> -	"	bnez	%4, 0b\n\t"					=
\
> -	"	 srl	%5, %1, 0x1f\n\t"				=
\
> -	"	.set	pop"						=
\
> -	: "=3D&r" (__mod32), "=3D&r" (__tmp),				=
\
> -	  "=3D&r" (__quot32), "=3D&r" (__cf),				=
\
> -	  "=3D&r" (__i), "=3D&r" (__tmp2)					=
\
> -	: "Jr" (base), "0" (__high), "1" (__low));			=
\
> -									=
\
> -	(__n) =3D __quot32;						=
\
> -	__mod32;							=
\
> -})
> -
> -#endif /* BITS_PER_LONG =3D=3D 64 */
> -
> -#endif /* __ASM_DIV64_H */
> --=20
> 2.27.0
>=20

