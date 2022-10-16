Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9801C5FFE83
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 11:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJPJuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 05:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJPJuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 05:50:37 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E94631211;
        Sun, 16 Oct 2022 02:50:35 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0C6F91C0016; Sun, 16 Oct 2022 11:50:32 +0200 (CEST)
Date:   Sun, 16 Oct 2022 11:50:31 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.10 0/4] 5.10.149-rc1 review
Message-ID: <20221016095031.GA3626@duo.ucw.cz>
References: <20221016064454.382206984@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20221016064454.382206984@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.149 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.10.149-rc1
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: fix MBSSID parsing use-after-free
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: don't parse mbssid in assoc response
>=20
> Johannes Berg <johannes.berg@intel.com>
>     mac80211: mlme: find auth challenge directly
>=20
> Sasha Levin <sashal@kernel.org>
>     Revert "fs: check FMODE_LSEEK to control internal pipe splicing"

But I'm confused. Queue seems to contain different stuff, and I see
these patches only in origin/linux-5.10.y.

43e0669893b3a57024beab4348b1038cf7b98af8 (origin/queue/5.10) regulator: qco=
m_rpm: Fix circular deferral regression
50af1850d6adaccd414656e51e66aa2192f7786a hwmon: (gsc-hwmon) Call of_node_ge=
t() before of_find_xxx API
7c8b9726479b0ee1275969c6e7b66bf0f6f701eb ASoC: wcd934x: fix order of Slimbu=
s unprepare/disable
f010aef6ae5b81511f57f71175f2f46e98e22f42 ASoC: wcd9335: fix order of Slimbu=
s unprepare/disable
ee39e253def995ca56788c767aba109070cec058 platform/chrome: cros_ec_proto: Up=
date version on GET_NEXT_EVENT failure
daa9a833bc179da7a759b35f70e3bd594d5dab5a quota: Check next/prev free block =
number after reading from quota file
d76384203c14e0afef7730a2a3016aac60ca8a79 HID: multitouch: Add memory barrie=
rs
=2E.
79994c46b1cb8efd35211d95dbdf79c21173b17a ALSA: rawmidi: Drop register_mutex=
 in snd_rawmidi_free()
65cb91292340d565b98fa6f661cdb7465f4c9d67 ALSA: oss: Fix potential deadlock =
at unregistration
3783e64fee4a624f3ed1d7d6ae630890922edb7b (tag: v5.10.148) Linux 5.10.148

Best regards,
							Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY0vT5wAKCRAw5/Bqldv6
8mikAJ9L3+814OLLMIz7phZidkOZTZZ2ZwCeM8PhMI1YRZyt6I/vudect+l5yDg=
=oSNT
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
