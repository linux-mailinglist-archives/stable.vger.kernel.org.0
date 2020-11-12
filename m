Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B8B2B0DD5
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 20:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgKLTYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 14:24:37 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56054 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgKLTYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 14:24:37 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DDE511C0BA2; Thu, 12 Nov 2020 20:24:32 +0100 (CET)
Date:   Thu, 12 Nov 2020 20:24:32 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jarkko.sakkinen@linux.intel.com
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Linux 4.19.157 -- fixing SGX problem?
Message-ID: <20201112192432.GA10247@amd>
References: <160504197091230@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <160504197091230@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I'm announcing the release of the 4.19.157 kernel.
>=20
> Please see the 5.9.8 announcement if you are curious if you should
> upgrade or not:
> 	https://lore.kernel.org/lkml/1605041246232108@kroah.com/

Quoting:

# Hint, if you are using SGX, then upgrade.  And then possibly
# reconsider
# the decisions you have recently made that caused you to write special
# code to use that crazy thing.  Personally, it still feels like a
# solution in search of a problem.

I agree with you that SGX is "crazy", but this makes no sense.

SGX is expected to protect enclave even from root. How does making
interface root-only solve that?

Plus, SGX is not in 4.19. I don't believe it is in mainline, either,
as the patches are still reposted. We are at v40 now...

Date: Wed,  4 Nov 2020 16:54:06 +0200
=46rom: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v40 00/24] Intel SGX foundations

ls arch/x86/kernel/cpu/sgx shows nothing in mainline. It shows nothing
in -next, either.

Confused,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+ti/AACgkQMOfwapXb+vK8rACgwnhKH9Rx+2tPuLAPkKSIMAdS
WGAAoL/OaYF0YgJoJzFM2aSCarp7sjNs
=Azbt
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
