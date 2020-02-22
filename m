Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509E4168D47
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 08:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgBVHku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 02:40:50 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56628 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgBVHku (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Feb 2020 02:40:50 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 474A11C1CBB; Sat, 22 Feb 2020 08:40:48 +0100 (CET)
Date:   Sat, 22 Feb 2020 08:40:47 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 009/191] KVM: nVMX: Use correct root level for
 nested EPT shadow page tables
Message-ID: <20200222074047.GA21289@amd>
References: <20200221072250.732482588@linuxfoundation.org>
 <20200221072252.173149129@linuxfoundation.org>
 <20200221102949.GA14608@duo.ucw.cz>
 <20200221150512.GB12665@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20200221150512.GB12665@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Hardcode the EPT page-walk level for L2 to be 4 levels, as KVM's MMU
> > > currently also hardcodes the page walk level for nested EPT to be 4
> > > levels.  The L2 guest is all but guaranteed to soft hang on its first
> > > instruction when L1 is using EPT, as KVM will construct 4-level page
> > > tables and then tell hardware to use 5-level page tables.
> >=20
> > I don't get it. 7/191 reverts the patch, then 9/191 reverts the
> > revert. Can we simply drop both 7 and 9, for exactly the same result?
> >
> > (Patch 8 is a unused file, so it does not change the picture).
>=20
> Patch 07 is reverting this patch from the same unused file,=20
> arch/x86/kvm/vmx/vmx.c[*].  The reason patch 07 looks like a normal diff =
is
> that a prior patch in 4.19.105 created the unused file (which is what's
> reverted by patch 08 here).
>=20
> Patch 09 reintroduces the fix for the correct file, arch/x86/kvm/vmx.c.

Aha, thanks, I checked content few times but missed difference in
filename. Now it makes sense.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl5Q2v8ACgkQMOfwapXb+vJzRwCfQQ19/SrBDH/PvDONs3aDKxfy
7ugAn2ig/hR6tIHKVraop7RE5m8NTm5f
=LtIB
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
