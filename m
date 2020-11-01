Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CDB2A21F9
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 22:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgKAV7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 16:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgKAV7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 16:59:16 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B246AC0617A6;
        Sun,  1 Nov 2020 13:59:15 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CPVLl2DcHz9sVH;
        Mon,  2 Nov 2020 08:59:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1604267952;
        bh=XxWzEyhflaFZdHjzdNZEHJ4Grda9zZ7dEFuzFls3d9Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oq268t8+r7FDhsVrSIp9lh5MY0mobvpzgmBURPi43FrQv44OUPdw9lPQqg8E2Y6+q
         ghQPp1kk9703PsJlSWHdiTO5xehYXep2oE6q9FIQK7WNDerr29+7xEdD4PpjCHFa+n
         rr75fj63QPMtetV9u4jdrnxa4KdDOGpHtrl0yAG4oSbFV9z3tHlzkdVWnsDGGNpPXg
         +0akzybKhj4VAHy5zSTxATRhNiDyjouB+xUQSEQ4oTI/ZiBqGDBA83UCQNBCyxl5rm
         8q+j7UXVDr6Rhz7dZEpsoryj1zJu+BrXqDlhf/eLjTCoC9LCDsze2vlldCoT/n89S3
         DJEyKhkEaTjbg==
Date:   Mon, 2 Nov 2020 08:59:10 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        kernel test robot <lkp@intel.com>,
        linux-next@vger.kernel.org, kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH] compiler.h: Move barrier() back into compiler-*.h
Message-ID: <20201102085910.4aff6608@canb.auug.org.au>
In-Reply-To: <eff5fa5f-2eec-81a9-c6d9-7ec45df61e80@infradead.org>
References: <202010312104.Dk9VQJYb-lkp@intel.com>
 <20201101173105.1723648-1-nivedita@alum.mit.edu>
 <20201101173835.GC27442@casper.infradead.org>
 <20201101195110.GA1751707@rani.riverdale.lan>
 <20201101195215.GE27442@casper.infradead.org>
 <20201101195948.GA1760144@rani.riverdale.lan>
 <eff5fa5f-2eec-81a9-c6d9-7ec45df61e80@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/TTcl7cgwM8udqdk2gpD0A+y";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/TTcl7cgwM8udqdk2gpD0A+y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Sun, 1 Nov 2020 12:40:19 -0800 Randy Dunlap <rdunlap@infradead.org> wrot=
e:
>
> On 11/1/20 11:59 AM, Arvind Sankar wrote:
> > On Sun, Nov 01, 2020 at 07:52:15PM +0000, Matthew Wilcox wrote: =20
> >> On Sun, Nov 01, 2020 at 02:51:10PM -0500, Arvind Sankar wrote: =20
> >>> Ok. So I still send it as a separate patch and he does the folding, or
> >>> should I send a revised patch that replaces the original one? =20
> >>
> >> I think Randy's patch should be merged instead of this patch. =20
> >=20
> > Ok, if that one works then it's better I agree.
> >  =20
>=20
> Do I need to resend it to Andrew?

Well, his SOB is on the original patch (as is mine) ... so, yes, please.

--=20
Cheers,
Stephen Rothwell

--Sig_/TTcl7cgwM8udqdk2gpD0A+y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+fL64ACgkQAVBC80lX
0GyeEAgAh0xrrhec+3wILiBHRO89DBqAQsaP+9ZdElw7wkFc5mC2A72/fRbFFgMs
k69ctkVANG8aGUXLFSgeyEorJMR0BNwSEnLtRG489mehelnuU/0118qyvS6pnxBn
E3eLmNcysu2c3uhKHWStgtEGzMbJIRBCAJmf5Wt5ig9T68uPqbfALpoNo9vo7SvZ
tZfFVN/yPncyn5ku5IPG8TxtPVnauyTVlL7bn7HvKDfXmAe1RUjfueGVrfWaCof7
j0RFikx4cf6nKux+TmB/poL5nM/5QNOTae+2Qkokvkw/aa4hWyQ+6Nt3GQMB+xom
+q6eeWugt1HZFxIYFqPFoUq4Kz0Rmg==
=allx
-----END PGP SIGNATURE-----

--Sig_/TTcl7cgwM8udqdk2gpD0A+y--
