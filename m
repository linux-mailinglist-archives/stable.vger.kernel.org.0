Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B4E3A887F
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 20:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhFOS0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 14:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhFOS0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 14:26:18 -0400
Received: from mail.manjaro.org (mail.manjaro.org [IPv6:2a01:4f8:150:448b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0004C061574
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 11:24:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.manjaro.org (Postfix) with ESMTP id 381B13FA049C;
        Tue, 15 Jun 2021 20:24:12 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at manjaro.org
Received: from mail.manjaro.org ([127.0.0.1])
        by localhost (manjaro.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GczPLuDlwuet; Tue, 15 Jun 2021 20:24:08 +0200 (CEST)
Subject: Re: [systemd] v248.2 and later won't boot 4.19 kernel series
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
References: <a53e11ac-b2af-4410-9a7b-59a6ba8efca5@manjaro.org>
 <YMjJocK3UcCLVl8H@kroah.com>
 <165856f8-4a42-cdf3-e9cd-5fac51e8d168@manjaro.org>
 <YMjRy0Wm+iNHRo+D@kroah.com>
From:   =?UTF-8?Q?Philip_M=c3=bcller?= <philm@manjaro.org>
Organization: Manjaro Community
Message-ID: <1c7ba739-d33e-1faa-61c1-712f2cf79ab8@manjaro.org>
Date:   Tue, 15 Jun 2021 20:22:47 +0200
MIME-Version: 1.0
In-Reply-To: <YMjRy0Wm+iNHRo+D@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="N3URzMc2iq4ug7iruv3QDQwBJnLZdTc2n"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N3URzMc2iq4ug7iruv3QDQwBJnLZdTc2n
Content-Type: multipart/mixed; boundary="6kEq3jSq1DAVlpCd8ZLotdiwcOdLUB4Zb";
 protected-headers="v1"
From: =?UTF-8?Q?Philip_M=c3=bcller?= <philm@manjaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Message-ID: <1c7ba739-d33e-1faa-61c1-712f2cf79ab8@manjaro.org>
Subject: Re: [systemd] v248.2 and later won't boot 4.19 kernel series
References: <a53e11ac-b2af-4410-9a7b-59a6ba8efca5@manjaro.org>
 <YMjJocK3UcCLVl8H@kroah.com>
 <165856f8-4a42-cdf3-e9cd-5fac51e8d168@manjaro.org>
 <YMjRy0Wm+iNHRo+D@kroah.com>
In-Reply-To: <YMjRy0Wm+iNHRo+D@kroah.com>

--6kEq3jSq1DAVlpCd8ZLotdiwcOdLUB4Zb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 15.06.21 18:14, Greg Kroah-Hartman wrote:
> Please always be specific as to what .y version of the above kernels yo=
u
> are testing, as there have been thousands of changes from the "first"

I tested the latest available point releases of each series.

Seems it boils down to an aufs4 patch, which was added by mistake 10
months ago on our end. After removing proc_mount.patch [1] it all worked.=


Sorry for the noise.

[1]
https://gitlab.manjaro.org/packages/core/linux419/-/blob/1f7a4bbdfdc5962e=
80210042f57e1b22d7fa90eb/proc_mounts.patch

--=20
Best, Philip


--6kEq3jSq1DAVlpCd8ZLotdiwcOdLUB4Zb--

--N3URzMc2iq4ug7iruv3QDQwBJnLZdTc2n
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEE5M3+UKLahdWMioxwyqallhHH8H4FAmDI7/cFAwAAAAAACgkQyqallhHH8H5E
QQf/TgM/iRPa+nGtMj3A+9PvbNMiFS9efbKQgZJmpGRXpXig9MapkPL1SYrFbhv0vMqR7bb1xDPy
QBos+ub7I6ma/0DQNqeH1I6iWp2GjXDQ7p6MXd6+mMksLMEXSFYErZawLyYvXqSrIUJDmsQJ3i+B
FCGVJgPeuFBmuuRhP1thFDoqGvHxEg6q01dkp7JEx7WE8JHdslhGUuYrDWLQpXFnWrlIGR+F4wfy
9S/6CrksJWjwq4E0/bcEfvzFz5eAY6giFp4iBWrEV+ZU4jc7vu1fWTNp13JjvSDYI/IWVNFBgCsb
gvyW9RRoSRTVlvMNAEhjKrEp78NwKROf2k3qy0+9Jg==
=G6vg
-----END PGP SIGNATURE-----

--N3URzMc2iq4ug7iruv3QDQwBJnLZdTc2n--
