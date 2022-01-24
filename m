Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AEE499343
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355394AbiAXUck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:32:40 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:53524 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381728AbiAXUWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:22:46 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0F6B41C0B76; Mon, 24 Jan 2022 21:22:35 +0100 (CET)
Date:   Mon, 24 Jan 2022 21:22:34 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/563] 5.10.94-rc1 review
Message-ID: <20220124202234.GC16782@duo.ucw.cz>
References: <20220124184024.407936072@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nmemrqcdn5VTmUEE"
Content-Disposition: inline
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nmemrqcdn5VTmUEE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.94 release.
> There are 563 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Our tests are unhappy, and it is more than gmp.h problem:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

arm64_ctj:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/201007=
0033

arch/arm64/mm/extable.c: In function 'fixup_exception':
1095arch/arm64/mm/extable.c:17:6: error: implicit declaration of function '=
in_bpf_jit' [-Werror=3Dimplicit-function-declaration]
1096  if (in_bpf_jit(regs))
1097      ^~~~~~~~~~
1098cc1: some warnings being treated as errors
1099scripts/Makefile.build:280: recipe for target 'arch/arm64/mm/extable.o'=
 failed
1100make[2]: *** [arch/arm64/mm/extable.o] Error 1
1101make[2]: *** Waiting for unfinished jobs....
1102  CC      kernel/sched/loadavg.o
1103  CC      arch/arm64/kernel/entry-common.o
1104

arm64_defconfig:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/201007=
0044

arch/arm64/mm/extable.c: In function 'fixup_exception':
1129arch/arm64/mm/extable.c:17:6: error: implicit declaration of function '=
in_bpf_jit' [-Werror=3Dimplicit-function-declaration]
1130  if (in_bpf_jit(regs))
1131      ^~~~~~~~~~
1132  CC      arch/arm64/crypto/ghash-ce-glue.o
1133cc1: some warnings being treated as errors
1134scripts/Makefile.build:280: recipe for target 'arch/arm64/mm/extable.o'=
 failed
1135make[2]: *** [arch/arm64/mm/extable.o] Error 1
1136make[2]: *** Waiting for unfinished jobs....
1137  CC      arch/arm64/kvm/hyp/vhe/sysreg-sr.o
1138

Best regards,
									Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--nmemrqcdn5VTmUEE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYe8KigAKCRAw5/Bqldv6
8vwdAJ9DYr0MICHQaJW/2sq7Lc9vQCg6cgCgu3gXmPmjdfD78dlYcFxP1V2xOTY=
=0YOT
-----END PGP SIGNATURE-----

--nmemrqcdn5VTmUEE--
