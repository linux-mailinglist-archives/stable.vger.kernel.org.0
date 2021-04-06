Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8864235544B
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 14:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242174AbhDFMzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 08:55:12 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:21914 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhDFMzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 08:55:12 -0400
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2021 08:55:11 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1617712980; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Y78HonEAaha70sgYDGvWOD4+Kenu7QUyZa+36BOrN2VOCW2QcwJKRkPWV86G0wlGEd
    pc1fKJECCzCzCTAzoS9EfnO8ATqq1Nv4WXq7j4VTf+Tz1KW7r1LzgQlCZVOsiSi3GD2o
    wSJemJaf+GeHB74Kt/gF1/DGnK0NZ2MwYUh6Jbso2YIkuY1UgnK8JGOY8MTPrXu14NxY
    0pzSvpQGKr1OWqyIGBryIPXa+ZPYaz1uQrvllDPF+tI5B5CchIgCMXKQnSaNGBigEMxe
    9OZAGv0kIZthgjzvGD0Ux1GpygMcFsPrCsfWsiUxnUSbUPStL1ccxv6X3FfPG3nVBtEW
    Xiqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1617712980;
    s=strato-dkim-0002; d=strato.com;
    h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=+JRkNZWJdvpS0lwSChZeG8R/ziyRjOEOnXVswiuBtao=;
    b=Z1rM3x0Qpv87kNJINDbOqSvg5zxSPW9EIwUj2fCCFYnnuVyyEsbxqp+1/MAOYXgZtQ
    a9uk5gJ87FOjPmTFArRTSWnjW1kIVgjX8Ip1ksxmWiA6W53vgxUM7iy3+Zy3QJzGOfwW
    o+mdT74ZFINEPzZWc9Hm/VGxTw26Ihe/zDPx+JTmDU6yqZDAozChGqIReSngEafI6a42
    1ywwLLLzHVwkZeg9ZWaqqEaz5SLZTDtXCOsS+ntPL1rEKici/AyytpPIzgl7jrQzI+Lt
    2tgiU5+aqEiNzCi1dDhgCxDw0W6M1IFsAXJCUIp8ZFMSjNpP0bbcE1SIpG0bQCQV12jJ
    Dz+Q==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1617712980;
    s=strato-dkim-0002; d=goldelico.com;
    h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=+JRkNZWJdvpS0lwSChZeG8R/ziyRjOEOnXVswiuBtao=;
    b=K1xnkP5ZnBejsBaLDo+v2iCQRkQFlDpoWIICkoqtLFJQsi7VUTpbTSDmE4Rf5rea6J
    4cGMdp+0ta7tWmsRbLCu9VQG+Yi+sjrP1pj9w2y+0Nz8aBAJSr50tFWnzRvEoip7rhKT
    RKyBWWnCm2+F6/SOSHF7nET6gPE7Rs3nAGsAcGWpfdAyVBPef+wvievb+AEjuy97MuFW
    r/f8RiJJ8P2Yh4XBJr49/0hidmsQYYzldQ+fcgfL04IWAyP2c+S+HT/4sHplnIFKxepb
    rY3N3YScC1mX/DTWs46b7Xj00xNE2GvAxzPp1KflWDpPOSWG+5MtgY5zJhq44jZXjU82
    aR5w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj5Qpw97WFDlaYXA0OGUo="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
    by smtp.strato.de (RZmta 47.23.1 DYNA|AUTH)
    with ESMTPSA id h03350x36CgxhXr
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Tue, 6 Apr 2021 14:42:59 +0200 (CEST)
Subject: Re: [PATCH] MIPS: Fix a longstanding error in div64.h
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20210406112404.2671507-1-chenhuacai@loongson.cn>
Date:   Tue, 6 Apr 2021 14:42:59 +0200
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>, stable@vger.kernel.org,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0338A250-3BF9-4B96-B9DE-61BE573CBB4C@goldelico.com>
References: <20210406112404.2671507-1-chenhuacai@loongson.cn>
To:     Huacai Chen <chenhuacai@kernel.org>
X-Mailer: Apple Mail (2.3124)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Am 06.04.2021 um 13:24 schrieb Huacai Chen <chenhuacai@kernel.org>:
>=20
> Only 32bit kernel need __div64_32(), but commit =
c21004cd5b4cb7d479514d4
> ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.") makes it =
depend
> on 64bit kernel by mistake. This patch fix this longstanding error.
>=20
> Fixes: c21004cd5b4cb7d479514d4 ("MIPS: Rewrite <asm/div64.h> to work =
with gcc 4.4.0.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
> arch/mips/include/asm/div64.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/mips/include/asm/div64.h =
b/arch/mips/include/asm/div64.h
> index dc5ea5736440..d199fe36eb46 100644
> --- a/arch/mips/include/asm/div64.h
> +++ b/arch/mips/include/asm/div64.h
> @@ -11,7 +11,7 @@
>=20
> #include <asm-generic/div64.h>
>=20
> -#if BITS_PER_LONG =3D=3D 64
> +#if BITS_PER_LONG =3D=3D 32
>=20
> #include <linux/types.h>

Hm.

Ingenic jz4780/CI20 build attempt on top ov v5.12-rc6:

In file included from ./include/linux/math64.h:7:0,
                 from ./include/linux/time.h:6,
                 from ./include/linux/compat.h:10,
                 from arch/mips/kernel/asm-offsets.c:12:
./include/linux/math64.h: In function 'div_u64_rem':
./arch/mips/include/asm/div64.h:29:11: error: invalid type argument of =
unary '*' (have 'long long unsigned int')
  __high =3D *__n >> 32;      \
           ^
./include/asm-generic/div64.h:243:11: note: in expansion of macro =
'__div64_32'
   __rem =3D __div64_32(&(n), __base); \
           ^
./include/linux/math64.h:91:15: note: in expansion of macro 'do_div'
  *remainder =3D do_div(dividend, divisor);
               ^

Or does it just reveal an unknown bug in my compiler?

