Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E6133C99E
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 00:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbhCOXEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 19:04:35 -0400
Received: from bluehome.net ([96.66.250.149]:48380 "EHLO bluehome.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232656AbhCOXE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 19:04:29 -0400
Received: from pc.lan (pc.lan [10.0.0.51])
        by bluehome.net (Postfix) with ESMTPSA id A31884B40CC8;
        Mon, 15 Mar 2021 15:57:17 -0700 (PDT)
Date:   Mon, 15 Mar 2021 15:57:16 -0700
From:   Jason Self <jason@bluehome.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/306] 5.11.7-rc1 review
Message-ID: <20210315155716.399f720d@pc.lan>
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/pld0toNAWnH_h5lnYFu4_+Y"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/pld0toNAWnH_h5lnYFu4_+Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Mar 2021 14:51:03 +0100
gregkh@linuxfoundation.org wrote:

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> This is the start of the stable review cycle for the 5.11.7 release.

Tested on amd64, arm64, armhf, i386, m68k, or1k, powerpc, ppc64,
ppc64el, riscv64, s390x, sparc64. No problems detected.

Tested-by: Jason Self <jason@bluehome.net>

--Sig_/pld0toNAWnH_h5lnYFu4_+Y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmBP5kwACgkQnQ2zG1Ra
MZgDQA/+MoiKjN5LmadIGZU5XjPiZ44zp7B6czGzw+VzFq1JFOlqOrEPGhqml8Vk
rwB8BsAnOyhxrf5tN0dsxO54a6a3wG3RNyi4NkbYrDj2yHuxa/N2SIPXL7itzm4y
1GHCjUP9wB+9OHieqtI1J1KNt6ySraxZuspaCL3Be6ItOGegOMZbhIXSIBGLl9fq
ah69M/IBUjZ2Uqy7/GN/Govv1TH5VZuCwQkkrRr0wqTFtyAacm3YIh94qhBv6JfN
lXm5i+UWk9wn+0dskdNXdJlE22/H7+H4vuLSfi+67ZEk8D25uKgoz/FSypRKbCEY
Fh30N3xBslWyvUQxSAgiWJSJRMGCtRbhe0Ba1tSwBp5061R8an9Is54uJqw86fgL
Z3PJk/nkhmHf0WcSyv2nV/UkY2nKWSrAQJ6CLfGJHLjl4Y7Av8eX4k8ulOPLdyXE
9X/3k5Ns4fFshmghDGU9QameuCcd4J6aO1gs8XiNfUPCwD4zQIUg3akodbROnVN3
C0GCxlDDm3kXRsvfc9D924V65JUk93tE2a9TxdkTnZ+6TV7PkoHFtiMgPBdNMvYv
mNGMPx5w3UxtPMxy+Cs338zvw1djx2BIBPaRGA7TNQcjm+Ebb61B4V/w0eUUmYJJ
lOWfV5TK4VqSna2EMijEb45Rhv5G2K2Imva3o0WUFVD92BUqTpY=
=YP+r
-----END PGP SIGNATURE-----

--Sig_/pld0toNAWnH_h5lnYFu4_+Y--
