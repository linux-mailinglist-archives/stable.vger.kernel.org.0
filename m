Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBB56E6E25
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 23:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbjDRV1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 17:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbjDRV1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 17:27:48 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4977DB2;
        Tue, 18 Apr 2023 14:27:46 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 298571C0AB3; Tue, 18 Apr 2023 23:27:44 +0200 (CEST)
Date:   Tue, 18 Apr 2023 23:27:43 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH 5.10 000/124] 5.10.178-rc1 review
Message-ID: <ZD8LT95DKIT0PKmC@duo.ucw.cz>
References: <20230418120309.539243408@linuxfoundation.org>
 <CA+G9fYsA+CzsxVYgQEN3c2pOV6F+1EOqY1vQrhj8yt1t-EYs7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TQZ0e1oGHiPq7BSO"
Content-Disposition: inline
In-Reply-To: <CA+G9fYsA+CzsxVYgQEN3c2pOV6F+1EOqY1vQrhj8yt1t-EYs7g@mail.gmail.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TQZ0e1oGHiPq7BSO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 5.10.178 release.
> > There are 124 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.10.178-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>=20
> Following build errors noticed on 5.15 and 5.10.,
>=20
>=20
> > Waiman Long <longman@redhat.com>
> >     cgroup/cpuset: Change references of cpuset_mutex to cpuset_rwsem
>=20
> kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
> kernel/cgroup/cpuset.c:2941:30: error: 'cgroup_mutex' undeclared
> (first use in this function); did you mean 'cgroup_put'?
>  2941 |         lockdep_assert_held(&cgroup_mutex);
>       |                              ^~~~~~~~~~~~

For the record, we can see the same failure in CIP testing.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
40769270

And it is the only build error I can see in a quick search.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--TQZ0e1oGHiPq7BSO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZD8LTwAKCRAw5/Bqldv6
8ojdAJ94Tx88lz9vazlcV37F4csfMvZRDACdHCUBoLiiaDK17WwQY99HSxqb4Ew=
=IUAC
-----END PGP SIGNATURE-----

--TQZ0e1oGHiPq7BSO--
