Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D9E428E2C
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhJKNkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:40:55 -0400
Received: from bluehome.net ([96.66.250.149]:53004 "EHLO bluehome.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235602AbhJKNkz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:40:55 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Oct 2021 09:40:55 EDT
Received: from bellevue.lan (unknown [162.249.178.188])
        by bluehome.net (Postfix) with ESMTPSA id 6382E4B4066D
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 06:30:46 -0700 (PDT)
Date:   Mon, 11 Oct 2021 06:30:40 -0700
From:   Jason Self <jason@bluehome.net>
To:     stable@vger.kernel.org
Subject: Re: Linux 5.14.11
Message-ID: <20211011063040.7ab8c623@bellevue.lan>
In-Reply-To: <163378600110591@kroah.com>
References: <163378600110591@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/b2ZYKzHm6Zep1GhtZjyHweJ";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/b2ZYKzHm6Zep1GhtZjyHweJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat,  9 Oct 2021 15:26:41 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> I'm announcing the release of the 5.14.11 kernel.

Starting with 5.14.10 I get this when doing make bindeb-pkg when
compiling for MIPS, for the Loongson 2F. I do have a sufficient
version of binutils installed (2.37), which was working well until
until 5.14.10 came out.

  OBJCOPY arch/mips/boot/compressed/vmlinux.bin
  GZIP    arch/mips/boot/compressed/vmlinux.bin.z
  OBJCOPY arch/mips/boot/compressed/piggy.o
  HOSTCC  arch/mips/boot/compressed/calc_vmlinuz_load_addr
  LD      vmlinuz
  STRIP   vmlinuz
make KERNELRELEASE=3D5.14.11-gnu.loongson-2f ARCH=3Dmips
  KBUILD_BUILD_VERSION=3D1.0 -f ./Makefile intdeb-pkg sh
  ./scripts/package/builddeb arch/mips/loongson2ef//Platform:36: ***
  only binutils >=3D 2.20.2 have needed option -mfix-loongson2f-nop.
  Stop. cp: cannot stat '': No such file or directory
  scripts/Makefile.package:87: recipe for target 'intdeb-pkg' failed
  make[4]: *** [intdeb-pkg] Error 1 Makefile:1576: recipe for target
  'intdeb-pkg' failed make[3]: *** [intdeb-pkg] Error 2
debian/rules:13: recipe for target 'binary-arch' failed
make[2]: *** [binary-arch] Error 2
dpkg-buildpackage: error: debian/rules binary subprocess returned exit
  status 2 scripts/Makefile.package:82: recipe for target 'bindeb-pkg'
  failed make[1]: *** [bindeb-pkg] Error 2
Makefile:1576: recipe for target 'bindeb-pkg' failed
make: *** [bindeb-pkg] Error 2

--Sig_/b2ZYKzHm6Zep1GhtZjyHweJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmFkPIAACgkQnQ2zG1Ra
MZhcjw//Rbx+koLm0BUBok9PNBZXrPt9E5We48qZSvoLo5BTz1WKglqcLaE5xP9O
7IkEDdhC5HHlzEyceJgexxaMfPvecnv4I+qvA0zdN14C6Cv7lqscECg4T28TlZpb
EFZCUS9n9U1eoqR4WBvdozfamh2t7P7Hdn32JBNCRVJ0CfisVMzNNSyvWv7v1mKH
W+K5SZRQh27xU1J4HeL7VLNOSHBBnmOzeYCpO5OuNdYCTMvg2rruzhY2QzX9r+Eu
qmChWHw+PP2rWe8SN56gXpsZhaX5Qbn38JvD+a0zRfZ/ELxs19lhRSKyelz/mZcW
Xpzb/BwtfjF1wQgaeLAOPoYFJrpDPrn0qt1VApouMZumGP3iZMUX1aJUv1RWz5yY
dTlylw/lZ91LHjCpUzmkpEKUzZFeC2/oRjn383FwCfn/O90S8shzgCM5fF4HcoQp
62wZf8/2HY1dIYvnUlmyyoAEdYUQK5DV40MlrFn0U3kaO65Q6zNTXtceu6+73Qap
2P/boiZ6lCaSpHcuTp6kZY5lU3e7zZeGHZygCW79ViPNifwz7FNz3bfizM2+3znP
nzAxTX8Dgtw5zoPVA093AfUC4E1AOEpGfeDGEBEXKqZudR5C8aUqZYxv3j+7vnHl
+VOar3s+Oo0H915Y+EQ/U3DHibRPpLk1w0BCF6PukzwzRXHGans=
=zYpX
-----END PGP SIGNATURE-----

--Sig_/b2ZYKzHm6Zep1GhtZjyHweJ--
