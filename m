Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BC538971F
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 21:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhEST6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 15:58:15 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55054 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbhEST6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 15:58:15 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3996E1C0B7F; Wed, 19 May 2021 21:56:54 +0200 (CEST)
Date:   Wed, 19 May 2021 21:56:52 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yu Zhang <yu.c.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.10 005/289] KVM: x86/mmu: Remove the defunct
 update_pte() paging hook
Message-ID: <20210519195651.GA14212@amd>
References: <20210517140305.140529752@linuxfoundation.org>
 <20210517140305.340027792@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20210517140305.340027792@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Sean Christopherson <seanjc@google.com>
>=20
> commit c5e2184d1544f9e56140791eff1a351bea2e63b9 upstream.
>=20
> Remove the update_pte() shadow paging logic, which was obsoleted by
> commit 4731d4c7a077 ("KVM: MMU: out of sync shadow core"), but never
> removed.  As pointed out by Yu, KVM never write protects leaf page

First, this is cleanup, not a bugfix.

Second, AFAICT 4731d4c7a077 ("KVM: MMU: out of sync shadow core") is
not in 5.10, so this will break stuff according to the changelog.

Best regards,
								Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmClbYMACgkQMOfwapXb+vLpFwCeOaRAeJp3IbirLorw+F54prgw
neUAn1emxKbXZw83UCscWvzI81CZ1G4t
=sREA
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
