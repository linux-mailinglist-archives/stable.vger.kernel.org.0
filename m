Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B772A6E7593
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 10:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbjDSIof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 04:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbjDSIof (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 04:44:35 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76ACE7EDD;
        Wed, 19 Apr 2023 01:44:33 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 843F81C0AB3; Wed, 19 Apr 2023 10:44:31 +0200 (CEST)
Date:   Wed, 19 Apr 2023 10:44:30 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Yu Zhao <yuzhao@google.com>, Bagas Sanjaya <bagasdotme@gmail.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Waiman Long <longman@redhat.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, Tejun Heo <tj@kernel.org>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
Message-ID: <ZD+p7rQoYoOa0e+T@duo.ucw.cz>
References: <20230418120305.520719816@linuxfoundation.org>
 <CA+G9fYs9sHnfhn4hSFP=AmOfgj-zvoK9vmBejRvzKPj4uXx+VA@mail.gmail.com>
 <bd46521c-a167-2872-fecb-2b0f32855a24@oracle.com>
 <20230418165105.q5s77yew2imkamsb@oracle.com>
 <ZD9rfsteIrXIwezR@debian.me>
 <CAOUHufa9-AKwwx7oVpQkV355TTmVSfi8roBKEsRjRNbeuGUkbw@mail.gmail.com>
 <2023041918-gravitate-reformat-9a34@gregkh>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Os7mj2m62qSU4dtk"
Content-Disposition: inline
In-Reply-To: <2023041918-gravitate-reformat-9a34@gregkh>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Os7mj2m62qSU4dtk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I'm just going to drop all of these patches from the queues now, and let
> the original submitter resend them after they are fixed up properly.

Build errors are gone in 5.10.178-rc2:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
41747700

and 5.15108-rc2 is okay too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
41747822

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Os7mj2m62qSU4dtk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZD+p7gAKCRAw5/Bqldv6
8oz4AKDCesRM3AuO3l/WpQixZiluQjiW2ACfYbZAZja+eQ7wWdDWkc/bREMynp8=
=V96E
-----END PGP SIGNATURE-----

--Os7mj2m62qSU4dtk--
