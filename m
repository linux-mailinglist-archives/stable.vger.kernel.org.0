Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D513DF5FF
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 21:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240294AbhHCTul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 15:50:41 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54646 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240286AbhHCTuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 15:50:39 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6985E1C0B76; Tue,  3 Aug 2021 21:50:27 +0200 (CEST)
Date:   Tue, 3 Aug 2021 21:50:27 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/67] 5.10.56-rc1 review
Message-ID: <20210803195026.GA16178@duo.ucw.cz>
References: <20210802134339.023067817@linuxfoundation.org>
 <20210803192607.GA14540@duo.ucw.cz>
 <c1d12ff5-06d5-075c-e01f-5184ffb09e69@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <c1d12ff5-06d5-075c-e01f-5184ffb09e69@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2021-08-03 12:37:29, Guenter Roeck wrote:
> On 8/3/21 12:26 PM, Pavel Machek wrote:
> > Hi!
> >=20
> > > This is the start of the stable review cycle for the 5.10.56 release.
> > > There are 67 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> > Not sure what went wrong, but 50 or so patches disappeared from the que=
ue:
> >=20
> > 48156f3dce81b215b9d6dd524ea34f7e5e029e6b (origin/queue/5.10) btrfs: fix=
 lost inode on log replay after mix of fsync, rename and inode eviction
> > 474a423936753742c112e265b5481dddd8c02f33 btrfs: fix race causing unnece=
ssary inode logging during link and rename
> > 2fb9fc485825505e31b634b68d4c05e193a224da Revert "drm/i915: Propagate er=
rors on awaiting already signaled fences"
> > b1c92988bfcb7aa46bdf8198541f305c9ff2df25 drm/i915: Revert "drm/i915/gem=
: Asynchronous cmdparser"
> > 11fe69a17195cf58eff523f26f90de50660d0100 (tag: v5.10.55) Linux 5.10.55
> > 984e93b8e20731f83e453dd056f8a3931b4a66e5 ipv6: ip6_finish_output2: set
> > sk into newly allocated nskb
>=20
> FWIW, the git repository matches the shortlog and summary.

git log --pretty=3Doneline origin/linux-5.10.y

seems to match shortlog/summary.

git log --pretty=3Doneline origin/queue/5.10

is unexpectedly short. Short changelog can also be seen on the web:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
log/?h=3Dqueue/5.10

(and 4.19/ 4.4 repositories have same problem, it is even more visible
there.)

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYQmeAgAKCRAw5/Bqldv6
8ghVAJ0VlPMDvINjJnbUASgZCsjtl9njWQCfau/5hcbmAp5MxRjf3dGrLZe+3wI=
=L0DM
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
