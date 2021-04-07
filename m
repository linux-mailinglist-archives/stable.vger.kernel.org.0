Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7D735648F
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 08:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345908AbhDGGyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 02:54:33 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:26616 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhDGGyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 02:54:33 -0400
X-Greylist: delayed 65459 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2021 02:54:32 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1617778439; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=aDBhyX2qyfqn9yRvJbRwgrKZ9ZLt7qXSd5mmCJIeV09gLLdQz9zm49CxY+Z+7VqVbL
    aww0YUQEsACQAoM2unyedhXlzQ9U4/H3GmfUZMW2QuF3S82XMDET049vb3y2TW7cbMz0
    BVAUlrbxkA0+ic/7GBZKYL4mNsSZlmobvlZogzTh7c6IcDszgoiFiCRrkluhmqOGeGfB
    9+9YINc5n1u37I8JJCaAj318FKpFkxi9cX2yy3tA1LwfiyI3xteFIvKdc7WgqpC/8xsc
    7Xl4oGDjAXbNhGlgF9F0op7e52HmsrgLkx2atNoButClUSRG6XsfoRP5ZGGWiM6a1T6Z
    tEKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1617778439;
    s=strato-dkim-0002; d=strato.com;
    h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=P5hGny6peY1W3q+ENDdnrLLrGMO9JUwOh6qT+B3s6/c=;
    b=mFsp9+PJvbyzgpBlFzoweX1kos26ZLrGLElcnQXlbS/d3BtN7L2TIg60FL1egIw9fP
    vWZgk6WgWOG4jekCjr2YrovXjiKQYtszBdRpSw1iQS/S0geb2RyuQjUbCs0ap9WmSAOK
    WEttz1w56tAhsELoKRWJJWHLc6tziYjglmw67e6vzSGmzUkwzdmQxNstFo/+amt525ek
    XmX65HIlaEFgga8NMULRc2Regv8P+3LjEZl+BdUbSZ/kIX1oJXOQtgR6iT3C2Z1zA/+B
    lgzRlGQvAY4f27qY7p6OQhP/df+jx4SeVqyP6Ba7IZ2gPcZW3ZQZRI5hwYOLNdVx+dXo
    rHMA==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1617778439;
    s=strato-dkim-0002; d=goldelico.com;
    h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=P5hGny6peY1W3q+ENDdnrLLrGMO9JUwOh6qT+B3s6/c=;
    b=R3RWWamNaoVyX6T+OX8JvB6YpGEjz/kGCDW1AZWFAUqV/ZyRmfjYSbXhrz7gSNL/e/
    d8knMIsA2eFilkLgSSVQ3VDN05PXkmyJA5aKYjePlAFjbPGvJT84+7FFl5tviLB5Wk2M
    GtEOlY0edaNZc8G3iA5TRhwcxB0MxV/l5NyQYalO+NZobEMBsJ3ByJfjylWUOGYNeydh
    A+Hl7i6WJDNAMAfumRkAqOit2TjW0A7N249ioWb8juOT8wajJURBq+VZ3Q6YUV0teBCr
    HrNZfpcF2znJxLc3YaR1OBkyjjojxv/VfWUoQHpa3PqDEBld3cfQgg4MsG8r/vS6AiqP
    9oVA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj4Qpw9iZeHmMmw43sSFQ="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
    by smtp.strato.de (RZmta 47.23.1 DYNA|AUTH)
    with ESMTPSA id h03350x376rxkLX
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Wed, 7 Apr 2021 08:53:59 +0200 (CEST)
Subject: Re: [PATCH V2] MIPS: Fix longstanding errors in div64.h
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20210407062916.3465459-1-chenhuacai@loongson.cn>
Date:   Wed, 7 Apr 2021 08:53:59 +0200
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <62DEADA1-E599-4909-84B3-5EF5FF144874@goldelico.com>
References: <20210407062916.3465459-1-chenhuacai@loongson.cn>
To:     Huacai Chen <chenhuacai@kernel.org>
X-Mailer: Apple Mail (2.3124)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Am 07.04.2021 um 08:29 schrieb Huacai Chen <chenhuacai@kernel.org>:
>=20
> There are three errors in div64.h caused by commit =
c21004cd5b4cb7d479514
> ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0."):
>=20
> 1, Only 32bit kernel need __div64_32(), but the above commit makes it
> depend on 64bit kernel by mistake.
>=20
> 2, asm-generic/div64.h should be included after __div64_32() =
definition.
>=20
> 3, __n should be initialized as *n before use (and "*__n >> 32" should
> be "__n >> 32") in __div64_32() definition.
>=20
> Fixes: c21004cd5b4cb7d479514 ("MIPS: Rewrite <asm/div64.h> to work =
with gcc 4.4.0.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
> arch/mips/include/asm/div64.h | 10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/mips/include/asm/div64.h =
b/arch/mips/include/asm/div64.h
> index dc5ea5736440..3be2318f8e0e 100644
> --- a/arch/mips/include/asm/div64.h
> +++ b/arch/mips/include/asm/div64.h
> @@ -9,9 +9,7 @@
> #ifndef __ASM_DIV64_H
> #define __ASM_DIV64_H
>=20
> -#include <asm-generic/div64.h>
> -
> -#if BITS_PER_LONG =3D=3D 64
> +#if BITS_PER_LONG =3D=3D 32
>=20
> #include <linux/types.h>
>=20
> @@ -24,9 +22,9 @@
> 	unsigned long __cf, __tmp, __tmp2, __i;				=
\
> 	unsigned long __quot32, __mod32;				=
\
> 	unsigned long __high, __low;					=
\
> -	unsigned long long __n;						=
\
> +	unsigned long long __n =3D *n;					=
\
> 									=
\
> -	__high =3D *__n >> 32;						=
\
> +	__high =3D __n >> 32;						=
\
> 	__low =3D __n;							=
\
> 	__asm__(							=
\
> 	"	.set	push					\n"	=
\
> @@ -65,4 +63,6 @@
>=20
> #endif /* BITS_PER_LONG =3D=3D 64 */

IMHO these #if/else/endif comments should also be fixed.

>=20
> +#include <asm-generic/div64.h>
> +
> #endif /* __ASM_DIV64_H */
> --=20
> 2.27.0
>=20

compiles fine now. But I still get a linker issue:

fs/ubifs/budget.o: In function `div_u64_rem':
fs/ubifs/budget.c:(.text+0x1fc): undefined reference to `__div64_32'
fs/ubifs/lpt.o: In function `div_u64_rem':
fs/ubifs/lpt.c:(.text+0x8fc): undefined reference to `__div64_32'
make[2]: *** [vmlinux] Error 1
make[1]: *** [__build_one_by_one] Error 2
make: *** [__sub-make] Error 2

BR and thanks,
Nikolaus Schaller

