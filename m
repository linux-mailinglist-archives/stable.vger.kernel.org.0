Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C7A3A8611
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 18:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhFOQJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 12:09:02 -0400
Received: from mail.manjaro.org ([176.9.38.148]:34950 "EHLO mail.manjaro.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhFOQJB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 12:09:01 -0400
X-Greylist: delayed 3960 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jun 2021 12:09:00 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.manjaro.org (Postfix) with ESMTP id 65E203FA0447;
        Tue, 15 Jun 2021 18:06:54 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at manjaro.org
Received: from mail.manjaro.org ([127.0.0.1])
        by localhost (manjaro.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YxR01crYKHPU; Tue, 15 Jun 2021 18:06:52 +0200 (CEST)
Subject: Re: [systemd] v248.2 and later won't boot 4.19 kernel series
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
References: <a53e11ac-b2af-4410-9a7b-59a6ba8efca5@manjaro.org>
 <YMjJocK3UcCLVl8H@kroah.com>
From:   =?UTF-8?Q?Philip_M=c3=bcller?= <philm@manjaro.org>
Organization: Manjaro Community
Message-ID: <165856f8-4a42-cdf3-e9cd-5fac51e8d168@manjaro.org>
Date:   Tue, 15 Jun 2021 18:05:30 +0200
MIME-Version: 1.0
In-Reply-To: <YMjJocK3UcCLVl8H@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sjCwwrSjkzc1U1x8qZATxfCxhlwykiXam"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sjCwwrSjkzc1U1x8qZATxfCxhlwykiXam
Content-Type: multipart/mixed; boundary="nfh6fAsTnMkbKz5HLWnYNtgi6gGZUpHzl";
 protected-headers="v1"
From: =?UTF-8?Q?Philip_M=c3=bcller?= <philm@manjaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Message-ID: <165856f8-4a42-cdf3-e9cd-5fac51e8d168@manjaro.org>
Subject: Re: [systemd] v248.2 and later won't boot 4.19 kernel series
References: <a53e11ac-b2af-4410-9a7b-59a6ba8efca5@manjaro.org>
 <YMjJocK3UcCLVl8H@kroah.com>
In-Reply-To: <YMjJocK3UcCLVl8H@kroah.com>

--nfh6fAsTnMkbKz5HLWnYNtgi6gGZUpHzl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 15.06.21 17:39, Greg Kroah-Hartman wrote:
> Do newer kernels work?
>=20
> Any chance you can run 'git bisect' to find the offending kernel patch?=

>=20
> 4.19 is really old, is this a stable-update-issue, or a "something
> changed since 4.19 was released" type of issue?

Older and newer kernel series work. So 4.4, 4.14, 5.10 and 5.13 I've
tested so far. No issues with 248.3 of Systemd. Have to see if any 4.19
kernel boot with that version ...

--=20
Best, Philip


--nfh6fAsTnMkbKz5HLWnYNtgi6gGZUpHzl--

--sjCwwrSjkzc1U1x8qZATxfCxhlwykiXam
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEE5M3+UKLahdWMioxwyqallhHH8H4FAmDIz8oFAwAAAAAACgkQyqallhHH8H7M
mQgAwzs5eYaIRuZKuAJ3bjXeNm9uqULQQ76U8rq1KXZFU+qumSp9Q6hQ861DQoguvMmW1ry7PziH
0jcsL4cGJdaNo46Lxh6JkutmR3zn4mYmrRWPH1WTJY8N3eWaLu/Mm+SH+dfc1Z+eL8gxuVyYx8XI
Kd1aQlBr0WaFgmMSrP77B+G6xCVvMjrC117O4F+fBdBbZ70WTWjvKkcW8/pbSKPufm5j1NzZvw5Q
qpByscvW3NBuMC1woAxXj3A1qmmeqAoJl9QMZJmF+FXpmWz14YPlDSs0Fx30r1lHsUGNt8kOqZnc
P6IKyRX2wJqDb9gHmWRjv8rZsYG9xvFukw2fsme00A==
=+bi1
-----END PGP SIGNATURE-----

--sjCwwrSjkzc1U1x8qZATxfCxhlwykiXam--
