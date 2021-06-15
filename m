Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BAD3A83D0
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhFOPWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbhFOPWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 11:22:11 -0400
X-Greylist: delayed 1153 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Jun 2021 08:20:06 PDT
Received: from mail.manjaro.org (mail.manjaro.org [IPv6:2a01:4f8:150:448b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD27C06175F
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 08:20:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.manjaro.org (Postfix) with ESMTP id 6D30E3FA0416;
        Tue, 15 Jun 2021 17:00:51 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at manjaro.org
Received: from mail.manjaro.org ([127.0.0.1])
        by localhost (manjaro.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jeguB8p5bEJG; Tue, 15 Jun 2021 17:00:48 +0200 (CEST)
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
From:   =?UTF-8?Q?Philip_M=c3=bcller?= <philm@manjaro.org>
Organization: Manjaro Community
Subject: [systemd] v248.2 and later won't boot 4.19 kernel series
Message-ID: <a53e11ac-b2af-4410-9a7b-59a6ba8efca5@manjaro.org>
Date:   Tue, 15 Jun 2021 16:59:27 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="x7s0T1lUks7XvK0FUiz5gHmsp0FAE7nCj"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x7s0T1lUks7XvK0FUiz5gHmsp0FAE7nCj
Content-Type: multipart/mixed; boundary="8ZgZqfAnH3vfbbgpmZIb6uuJR9YoUehDH";
 protected-headers="v1"
From: =?UTF-8?Q?Philip_M=c3=bcller?= <philm@manjaro.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>
Message-ID: <a53e11ac-b2af-4410-9a7b-59a6ba8efca5@manjaro.org>
Subject: [systemd] v248.2 and later won't boot 4.19 kernel series

--8ZgZqfAnH3vfbbgpmZIb6uuJR9YoUehDH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hello all,

with commit "mount-util: shortcut things after generating top-level bind
mount" c2c331056a7c331a5478124b3cd6a34c9f539839
(5c5753b9ea5cc012586ae90d357d460dec4301a4 in master) systemd 248.2 and
later won't boot 4.19 kernel series. I tested 4.19.194 so far.

Lennart's  guess is that this is the mount table brokeness on old
kernels, that newer libmount worked around. i.e. /proc/self/mountinfo on
old kernels showed partially old data and partially new data, and
confused the heck out of everyone. "proc on 20" with mount options
"(rw,25)" doesn't look right at all.

If we look at 4.14 and 4.4 kernel series, those boot. 4.9 I've still to
test, as that one didn't boot either for me.

So an idea what is missing in 4.19 kernel series? Other kernels work.

Systemd issue is this one: https://github.com/systemd/systemd/issues/1992=
6

--=20
Best, Philip


--8ZgZqfAnH3vfbbgpmZIb6uuJR9YoUehDH--

--x7s0T1lUks7XvK0FUiz5gHmsp0FAE7nCj
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEE5M3+UKLahdWMioxwyqallhHH8H4FAmDIwE8FAwAAAAAACgkQyqallhHH8H4l
UAf/eEHylg+xL3mWHk1UKSbZaTPbOf3TCJUNYA96PSlglpSznFkcs5NqRoGeFXTuR08MVi6mQ/+a
/QGJjO04KOGlULV+WpwUzHDojHfTQCixELD1MY8GxQQ6FduP26fmCrM3O0pqd+MEQTjXoE6A9Fyb
9ko2R1x6rEqT54WxXAm6tlhZPvEq+DC0UI3x42YPQUxQVNcXb/Jz/3sAIxZzFeu9u8asVdcBHscu
y1At7suaWq1mJzFmT81bCYLVHn7roq7C7oydZlyK3DtwSZF8Z7Xifv2aOzvzmdo9x3KnqsIXO4F5
aoVRqEQfeWzuO8UQaTMUDjw0fGyBX2sQ6HtD6/oSZg==
=CLto
-----END PGP SIGNATURE-----

--x7s0T1lUks7XvK0FUiz5gHmsp0FAE7nCj--
