Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E824EDF58
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 19:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbiCaRIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 13:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240491AbiCaRH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 13:07:59 -0400
Received: from hall.aurel32.net (hall.aurel32.net [IPv6:2001:bc8:30d7:100::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABC71E3749;
        Thu, 31 Mar 2022 10:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
        ; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
        Subject:Content-ID:Content-Description:X-Debbugs-Cc;
        bh=3f2eMNjxuItbWlnls7ORiJd9i6hYLVgkXpyx1xRUb2w=; b=ASbLG4Ldhwj8OC8VYiMxB+fAOJ
        0zPi2gq2b8M/dPFp6bnhHhws3EeV4kFx716cPnkDuyvS7jeSJJa3wxV1Xx0e6RoiourFdP659/OJ/
        j9csR+WdDyzCIKnbtQ1e2wVrRgEhgnH8PV0qTdFcTb0YOoPP6wLXZeLUlNuKHpc6LTVMMi2pOgsJ7
        3s1N9Ejdm+2cEnfjiQxiUVchj0RCVW0xQs33M89ORD64m737Pe1Quw4ttaSAXsxcdxr91+PmsxDwH
        gNH71MoCQmfx7Pn/X+J+XeV0DxeP4IJlkftDg9f50VVJp0ledKFABE0MIFFbM1kFqTyMPhg6Pcm+o
        jSTHJwvw==;
Received: from [2a01:e34:ec5d:a741:527b:9dff:fe6e:1e10] (helo=ohm.rr44.fr)
        by hall.aurel32.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <aurelien@aurel32.net>)
        id 1nZyFF-003XcN-Jo; Thu, 31 Mar 2022 19:06:01 +0200
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.95)
        (envelope-from <aurelien@aurel32.net>)
        id 1nZyFD-000mux-8S;
        Thu, 31 Mar 2022 19:05:59 +0200
Date:   Thu, 31 Mar 2022 19:05:59 +0200
From:   Aurelien Jarno <aurelien@aurel32.net>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kito Cheng <kito.cheng@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
        linux-sparse@vger.kernel.org, ukl@pengutronix.de,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: Re: [PATCH] riscv: fix build with binutils 2.38
Message-ID: <YkXfdyDISV6S6+kY@aurel32.net>
Mail-Followup-To: Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kito Cheng <kito.cheng@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
        linux-sparse@vger.kernel.org, ukl@pengutronix.de,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
References: <20220126171442.1338740-1-aurelien@aurel32.net>
 <20220331103247.y33wvkxk5vfbqohf@pengutronix.de>
 <20220331103913.2vlneq6clnheuty6@pengutronix.de>
 <20220331105112.7t3qgtilhortkiq4@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="skiiiUAPxBLzLTT4"
Content-Disposition: inline
In-Reply-To: <20220331105112.7t3qgtilhortkiq4@pengutronix.de>
User-Agent: Mutt/2.1.4 (2021-12-11)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--skiiiUAPxBLzLTT4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On 2022-03-31 12:51, Marc Kleine-Budde wrote:
> Cc +=3D linux-sparse, Uwe, Luc Van Oostenryck
>=20
> tl;dr:
>=20
> A recent change in the kernel regarding the riscv -march handling breaks
> current sparse.
>=20
> On 31.03.2022 12:39:14, Marc Kleine-Budde wrote:
> > On 31.03.2022 12:32:47, Marc Kleine-Budde wrote:
> > > On 26.01.2022 18:14:42, Aurelien Jarno wrote:
> > > > From version 2.38, binutils default to ISA spec version 20191213. T=
his
> > > > means that the csr read/write (csrr*/csrw*) instructions and fence.i
> > > > instruction has separated from the `I` extension, become two standa=
lone
> > > > extensions: Zicsr and Zifencei. As the kernel uses those instructio=
n,
> > > > this causes the following build failure:
> > > >=20
> > > >   CC      arch/riscv/kernel/vdso/vgettimeofday.o
> > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assemble=
r messages:
> > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error=
: unrecognized opcode `csrr a5,0xc01'
> > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error=
: unrecognized opcode `csrr a5,0xc01'
> > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error=
: unrecognized opcode `csrr a5,0xc01'
> > > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error=
: unrecognized opcode `csrr a5,0xc01'
> > > >=20
> > > > The fix is to specify those extensions explicitely in -march. Howev=
er as
> > > > older binutils version do not support this, we first need to detect
> > > > that.
> > > >=20
> > > > Cc: stable@vger.kernel.org # 4.15+
> > > > Cc: Kito Cheng <kito.cheng@gmail.com>
> > > > Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> > > > ---
> > > >  arch/riscv/Makefile | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >=20
> > > > diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> > > > index 8a107ed18b0d..7d81102cffd4 100644
> > > > --- a/arch/riscv/Makefile
> > > > +++ b/arch/riscv/Makefile
> > > > @@ -50,6 +50,12 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:=3D rv32ima
> > > >  riscv-march-$(CONFIG_ARCH_RV64I)	:=3D rv64ima
> > > >  riscv-march-$(CONFIG_FPU)		:=3D $(riscv-march-y)fd
> > > >  riscv-march-$(CONFIG_RISCV_ISA_C)	:=3D $(riscv-march-y)c
> > > > +
> > > > +# Newer binutils versions default to ISA spec version 20191213 whi=
ch moves some
> > > > +# instructions from the I extension to the Zicsr and Zifencei exte=
nsions.
> > > > +toolchain-need-zicsr-zifencei :=3D $(call cc-option-yn, -march=3D$=
(riscv-march-y)_zicsr_zifencei)
> > > > +riscv-march-$(toolchain-need-zicsr-zifencei) :=3D $(riscv-march-y)=
_zicsr_zifencei
> > > > +
> > > >  KBUILD_CFLAGS +=3D -march=3D$(subst fd,,$(riscv-march-y))
> > > >  KBUILD_AFLAGS +=3D -march=3D$(riscv-march-y)
> > >=20
> > > I'm on current linus/master, this change breaks on current Debian
> > > testing with:
> > >=20
> > > | make: Leaving directory 'linux'
> > > |   SYNC    include/config/auto.conf.cmd
> > > |   GEN     Makefile
> > > |   GEN     Makefile
> > > |   CC      scripts/mod/empty.o
> > > |   CHECK   linux/scripts/mod/empty.c
> >       ^^^^^
> > It's actually "sparse" that breaks
> >      =20
> > > | invalid argument to '-march': '_zicsr_zifencei'
> >=20
> > | $ sparse --version
> > | 0.6.4 (Debian: 0.6.4-2)

I confirm the issue. To make things clear, it's not a Makefile issue,
sparse get passed the correct -march=3Drv64ima_zicsr_zifencei value, and
only display the part it can't parse.

On the medium/long term, sparse should get fixed to support those
extensions. On the short term, we need to find a way to get different
flags for sparse than for as/gcc.

--=20
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                 http://www.aurel32.net

--skiiiUAPxBLzLTT4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUryGlb40+QrX1Ay4E4jA+JnoM2sFAmJF33QACgkQE4jA+Jno
M2sqXA/+JZFawgBGA44DcdLHwmYpdemBwyO0wcocBTWOPT8gxXVkONxfrYiWfB6e
BF6P7Iesr+8u7qMNyurMcJTDx4XfHQIpQJ8SGQ5/jW/UU6I1JDctvortsmqcgNEq
LqAJ2tlkPhhoMcXzp+QjqsGxDMMqfsPiLBaQk2wL5VuFRCbYV+kZUk4puF1x1NV9
K5fnMzYD+A0KwsUmKnmcrfWrKep9bbuXtPo2shBuqaeW+pe/0NlAp/+BQUc21aJ4
L0f29kzQq2c789WEAhkjpRA7QAZF/3M0msd7PC+I5pDbKJuHSxtXGSkf7tTn8Hyh
VdWu7wyg+vCOvc/9IA6WLi05ipYIHKZpUkqRDz/4MuH5S19FoVr/0Gdjoq2Ck1mG
NcYeJgvnTOBJyOUQ7in60EDiWDigzuCVKWvFdkXePfwR50Hj4EH+oCoN1IFlgzkd
PDq67/pMmun2YzkAagswesdwDQ5DiZ7rPQZ4RiICdR5GWKhs/GZcpI8u0I9ozUXK
LtYLik/d12pFWjLYZ+s+OP0oigT2F40BuvF/Aua5WIaZ+fx7w0wp2HSYj9S0n9rT
IRB7npjqqjluMMsr7TQyRZHala38YN4arptBK49pDbvu3IBDiVXGeVxGq89cHhsv
QAobzMtiKzTIaZrfxvPfK31w33gBq2nz5fboIaRHefS+49FycjY=
=On2l
-----END PGP SIGNATURE-----

--skiiiUAPxBLzLTT4--
