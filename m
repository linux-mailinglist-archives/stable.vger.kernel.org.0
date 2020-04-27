Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E119F1BADAB
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 21:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgD0TPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 15:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgD0TPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 15:15:12 -0400
X-Greylist: delayed 407 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 27 Apr 2020 12:15:12 PDT
Received: from orthanc.universe-factory.net (orthanc.universe-factory.net [IPv6:2001:19f0:6c01:100::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389A2C0610D5
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 12:15:12 -0700 (PDT)
Received: from [IPv6:2001:19f0:6c01:100::2] (unknown [IPv6:2001:19f0:6c01:100::2])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by orthanc.universe-factory.net (Postfix) with ESMTPSA id 9512E21DEF;
        Mon, 27 Apr 2020 21:08:21 +0200 (CEST)
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Sven Eckelmann <sven@narfation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20200426070617.14575-1-sven@narfation.org>
 <20200426231426.GM13035@sasha-vm> <11030934.sCltEm0ppq@bentobox>
 <5500acc3-e691-ffae-1a59-6331de07f606@suse.cz>
From:   Matthias Schiffer <mschiffer@universe-factory.net>
Autocrypt: addr=mschiffer@universe-factory.net; prefer-encrypt=mutual;
 keydata=
 mQINBFLNIUUBEADtyPGKZY/BVjqAp68oV5xpY557+KDgXN4jDrdtANDDMjIDakbXAD1A1zqX
 LUREvXMsKA/vacGF2I4/0kwsQhNeOzhGPsBa8y785WFQjxq4LsBJpC4QfDvcheIl4BeKoHzf
 UYDp4hgPBrKcaRRoBODMwp1FZmJxhRVtiQ2m6piemksF1Wpx+6wZlcw4YhQdEnw7QZByYYgA
 Bv7ZoxSQZzyeR/Py0G5/zg9ABLcTF56UWq+ZkiLEMg/5K5hzUKLYC4h/xNV58mNHBho0k/D4
 jPmCjXy7bouDzKZjnu+CIsMoW9RjGH393GNCc+F3Xuo35g3L4lZ89AdNhZ0zeMLJCTx5uYOQ
 N5YZP2eHW2PlVZpwtDOR0zWoy1c0q6DniYtn0HGStVLuP+MQxuRe2RloJE7fDRfz7/OfOU6m
 BVkRyMCCPwWYXyEs2y8m4akXDvBCPTNMMEPRIy3qcAN4HnOrmnc24qfQzYp9ajFt1YrXMqQy
 SQgcTzuVYkYVnEMFBhN6P2EKoKU+6Mee01UFb7Ww8atiqG3U0oxsXbOIVLrrno6JONdYeAvy
 YuZbAxJivU3/RkGLSygZV53EUCfyoNldDuUL7Gujtn/R2/CsBPM+RH8oOVuh3od2Frf0PP8p
 9yYoa2RD7PfX4WXdNfYv0OWgFgpz0leup9xhoUNE9RknpbLlUwARAQABtDJNYXR0aGlhcyBT
 Y2hpZmZlciA8bXNjaGlmZmVyQHVuaXZlcnNlLWZhY3RvcnkubmV0PokCVwQTAQoAQQIbAwUL
 CQgHAwUVCgkICwUWAwIBAAIeAQIXgAIZARYhBGZk572mtmmIHsUudRbvP2TLIB2cBQJeg6hL
 BQkPeO4GAAoJEBbvP2TLIB2ch6QQAOLGn9jN9hk96V1F+qJjaeOT2BPxgqYvSv8se4M8BOzE
 EzSKwaNZha/Yqo2lSK1M8V6vaXQwXyliJML6ABIJe7lezSvmv16Z4P6tCgk44ErCkVty+jat
 al8uzBruo0Vh4n5KE4EqvLDknOsNb8hO927ATEYfJnjzIVq3nCLWdzqSzvLdpauXlwHWlN1n
 xi6HzMNfWIGSRlAb0Ci5vIVMohBMLSJqd4M2eWdWC8e9ba/O6yonTe6YOq0HvMPKSPErT10V
 O/4ndPdsI8OgZjwqq9bp5Yp00R8SkPwFeMGSD8Yo197Gx1Oe4XOCpAr4ODBxdq7tYJrbN19Z
 S/XWXIn8Uewc5/i9StvwunwiBwixZY/G5iIpafd8BecN+eT33zHD7uQLshoovOB/4pm2cah7
 1KtrDOv0hWEinFbBjoJZIB6L+jellsVA640CvyQunIbuYk5SJedslDHWEi9kGY6ORqxvbpJw
 9K6DKsQxwebb3wERgoaiK2DcIto7va6AIjg689Mjki5f8A7ebnmP/TfMRwiAH3n5zGDZpi78
 jpWgmHe6zyQsh7NQT542/3f/ZZ8FBsAb76l8neabItNP7Q5T2ue+hmonW0XZmQD0hGIFVrrR
 Lz24fg2ANICZ10tYgwOgo2MyNa6Hm3SxnguB1CqpEaq22SRCHg66Qer1FuLVr3khuQINBFLN
 IUUBEADCFlCWLGQmnKkb1DvWbyIPcTuy7ml07G5VhCcRKrYD9GAasvGwb1FafSHxZ1k0JeWx
 FOT02TEMmjVUqals2rINUfu3YXaALq8R0aQ/TjZ8X+jI6Q6HsHwOdFTBL4zD4pKs43iRWd+g
 x8xYBb8aUBY+KiRKP70XCzQMdrEG1x6FABbUX9651hN20Qt/GKNixHVy3vaD3PzteH/jugqf
 tNu98XQ2h4BJBG4gZ0gwjpexu/LjP2t0IOULSsFSf6S8Nat6bPgMW3CrEdTOGklAP9sqjbby
 i8GAbsxZhjx7YDkl1MpFGxlC2g0kFC0MMLue9pSsT5nwDl230IxZgkS7joLSfmjTWj1tyEry
 kiWV7ta3rx27NtXYnHtGrHy+yubTsBygt2uZbL9l2OR4zsc9+hLftF6Up/2D09nFzmLKKcd5
 1bDrb+SMsWull0DjAv73IRF9zrHPJoaVesaTzUGfXlXGxsOqpQ9U2NjUUJg3B/9ijKGM3z9E
 6PF/0Xmc5gG3C4XzT0xJVfsKZcZoWuPl++QQA7nHJMbexyruKOMqzS273vAKnTzvOD0chIvU
 0DZ/FfJBqNdRfv3cUwgQwsBU6BGsGCnM0ofFMg7m0xnCAQeXe9hxAoH1vgGjX0M5U5sJarJA
 +E6o5Kmqtyo0g5R0NBiAxJnhUB0eHJPAElFrR7u1zQARAQABiQI8BBgBCgAmAhsMFiEEZmTn
 vaa2aYgexS51Fu8/ZMsgHZwFAl6DqEsFCQ947gYACgkQFu8/ZMsgHZySkxAA2/UbAd2IDxvi
 Nz6o4ERidVyoX6+ijv2ewefrtcKXs7UjOnSqVfKF3IcjSJCrIqjFT1KdlEVaAyuIIa2JRqT/
 SzM5WvB30TcMxIsC5vDYXQXFiDotPxzxfU+eSDq3uYKZM5axZebtm7/JeJmXBBRzHLOEq2D6
 GYcwQjedxoGn8VnkYUZSFjEQkrzhGGvMo9FsJ8OQRq/3Q0dQdaV9az5SQ/cg5vyvEiYSJGOe
 KbTTt/1zqgKcC/qkZ5+5oKhgI0Hpubd8MAFIQ/eNugUcfa0SVuiwaZZmrT07ksU4CykigYLw
 pPQtg3P+NnvpyZzhPFIw7EGcji/iTgMakNSK2l4TLeWSTUC6UxJFy/qTJs9kUf7X3Z3aWHIY
 1LSr/sasSueExRAM1nGYj+LzkjFvmp7wkihmSoClw8yfQJInsXImG/rvf2nIguJq44TG8E8T
 1xNdvRuSgi9r2hs223SQwfaVwDZh4OiKd/nTNd7hPcFO1vjU4Ndcus8S9TeZfv+gJ1TS+aUF
 wiKnegYKtQueVRGLPZ09TAJjW/dTyqt/szzlLX2G1RBzUCqvl1qlC/hmJagRrt/tDNqpXs0Z
 m6T3S5sCUTynGJLguMDHIcXTx5+9Xl/diUkbxefxkj507jhxcPjraQhqqId+SSLSj2W8u7Ix
 PlNzGv4274ZWmcxbhGx8ZaE=
Subject: Re: [PATCH 4.14] mm, slub: restore the original intention of
 prefetch_freepointer()
Message-ID: <44815f1e-6fcd-6e03-79dc-423898dfe162@universe-factory.net>
Date:   Mon, 27 Apr 2020 21:08:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <5500acc3-e691-ffae-1a59-6331de07f606@suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="RoAHjuWMiGqxC2cebdJUvHTK0JkOgRMiX"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RoAHjuWMiGqxC2cebdJUvHTK0JkOgRMiX
Content-Type: multipart/mixed; boundary="mhZ0VIge9fuGuNLW20BLKEqRE6V9e61nu";
 protected-headers="v1"
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Sven Eckelmann <sven@narfation.org>, Sasha Levin <sashal@kernel.org>,
 stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
 Daniel Micay <danielmicay@gmail.com>, Eric Dumazet <edumazet@google.com>,
 Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <44815f1e-6fcd-6e03-79dc-423898dfe162@universe-factory.net>
Subject: Re: [PATCH 4.14] mm, slub: restore the original intention of
 prefetch_freepointer()
References: <20200426070617.14575-1-sven@narfation.org>
 <20200426231426.GM13035@sasha-vm> <11030934.sCltEm0ppq@bentobox>
 <5500acc3-e691-ffae-1a59-6331de07f606@suse.cz>
In-Reply-To: <5500acc3-e691-ffae-1a59-6331de07f606@suse.cz>

--mhZ0VIge9fuGuNLW20BLKEqRE6V9e61nu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: quoted-printable

On 4/27/20 10:45 AM, Vlastimil Babka wrote:
> On 4/27/20 9:01 AM, Sven Eckelmann wrote:
>> On Monday, 27 April 2020 01:14:26 CEST Sasha Levin wrote:
>>> On Sun, Apr 26, 2020 at 09:06:17AM +0200, Sven Eckelmann wrote:
>>>> From: Vlastimil Babka <vbabka@suse.cz>
>>>>
>>>> commit 0882ff9190e3bc51e2d78c3aadd7c690eeaa91d5 upstream.
>> [...]
>>>> ---
>>>> The original problem is explained in the patch description as
>>>> performance problem. And maybe this could also be one reason why it =
was
>>>> never submitted for a stable kernel.
>>>>
>>>> But tests on mips ath79 (OpenWrt ar71xx target) showed that it most =
likely
>>>> related to "random" data bus errors. At least applying this patch se=
emed to
>>>> have solved it for Matthias Schiffer <mschiffer@universe-factory.net=
> and
>>>> some other persons who where debugging/testing this problem with him=
=2E
>>>>
>>>> More details about it can be found in
>>>> https://github.com/freifunk-gluon/gluon/issues/1982
>=20
> Hmm, doesn't explain much how the fix was eventually found, but nevermi=
nd, good job.

The fact that the location of the data bus error was so imprecise made me=

suspect that no regular load could be the cause - therefore I looked at
that prefetch in detail and eventually found your patch.

>=20
>>>
>>> Interesting... I wonder why this issue has started only now.
>>
>> Unfortunately, I don't know the details. So I (actually we) would love=
 to get=20
>> some feedback from the slub experts. Not that there is another problem=
 which=20
>> we just don't grasp yet.
>=20
> I think the prefetch my go to an address that would cause a real fetch =
to page
> fault. Under normal circumstances that could be only the NULL pointer t=
hat
> terminates a freelist, otherwise the address should be valid.

For further analysis, I just replaced the prefetch as implemented in 4.14=

(i.e. before applying the patch in question) with a regular load (excludi=
ng
NULL, which would lead to an immediate fault on boot). With the test
program, I quickly hit a fault, at an address that looks completely bogus=

(i.e. neither NULL nor an address looking like it might be mapped to
anything). Is this expected with the incorrect prefetch_freepointer()
implementation of 4.14? Is it possible that prefetch_freepointer() of 4.1=
4
is even more broken than suspected before? Note that we hit this issue wi=
th
the "names_cache" slab, which has page-sized objects, if that might provi=
de
any clue...

In any case, it seems like the "pref" instruction should not be used on
bogus addresses on the ath79 platform... The exact behaviour is also
hardware-dependent: On some SoCs, the error would be visible as a data bu=
s
error, while others just reset without any way to find out what was going=

wrong.

Matthias

>=20
> So that could mean:
> 1) prefetch() on mips is implemented/compiled wrong?
> 2) the CPU really has issues with prefetch causing a page fault
> 3) the prefetch gets reordered between LL/SC and there's some bug simil=
ar to
> this one described in arch/mips/include/asm/sync.h:
>=20
> /*
>  * Some Loongson 3 CPUs have a bug wherein execution of a memory access=
 (load,
>  * store or prefetch) in between an LL & SC can cause the SC instructio=
n to
>  * erroneously succeed, breaking atomicity. Whilst it's unusual to writ=
e code
>  * containing such sequences, this bug bites harder than we might other=
wise
>  * expect due to reordering & speculation:
>=20
>=20
>> Just some background information about the "why" from freifunk-gluon's=
=20
>> perspective:
>>
>> OpenWrt 19.07 was released (despite its name) at the beginning of 2020=
=2E And it=20
>> was the first release using kernel 4.14 on the most used target: ar71x=
x=20
>> (ath79). The wireless community network firmware projects (freifunk-gl=
uon in=20
>> this example) updated their frameworks to this OpenWrt release in the =
last=20
>> months and just now started to roll it out on their networks.
>>
>> And while the wireless community networks around here usually don't tr=
ack the=20
>> connected clients, the health of the APs is often tracked on some cent=
ral=20
>> system. And some people then just noticed a sudden spike of reboots on=
 their=20
>> APs. Since ar71xx is (often) the most used architecture at the moment,=
 this=20
>> could be spotted rather easily if you spend some time looking at graph=
s.
>>
>> Kind regards,
>> 	Sven
>>
>=20



--mhZ0VIge9fuGuNLW20BLKEqRE6V9e61nu--

--RoAHjuWMiGqxC2cebdJUvHTK0JkOgRMiX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEZmTnvaa2aYgexS51Fu8/ZMsgHZwFAl6nLaQACgkQFu8/ZMsg
HZy0ng/+KAS3SeNGZtIKrJAl/ssaXAz9YGSV+Y1lZoQvqNxp9osp1TxgLdlxE7z7
n2reFBL0jfRbY8newN0aPdZ1jGORcYPJPMABhbGQazuDJ7EUP6/U8Fsuqrj3sdgl
4j90hRdtIQ2bwmXeZFlOvKAF7lm9NLyEfE68t7Mz9XjGJ2Zpcb6RqorJ1BCH7MAq
4xL6eE0dTQ52utRZu0TNbYcWy+7KOXVpXWWh6L15FYsJryn2ctC4bRB7NU6hvubh
nlcVP1PVjUbKKfWIQs4jXJtgiOuncpgijM2Fy2BG8TWeU1/3/v7eVimHcvFba01D
3z/J91F4UfE03M6nBARUCc5MYD9SZOsSVWqQGjlLm2KQzRMlE5Wt1joWxkY0XuwO
SiDV2GXiwtLd1e8VuRUSDT+J75CdE6bcJApnjmAVuJP2HRIgsnEcb7iwtfSSpLkJ
PilhqXP1C4MI30PTlSnNNGob6hxrkCdywRTV3XSEUqabyB0Qxi7gUN/CRFWotgek
J9zp5vfEzhGPm3sIpR/NN+eKI08G6zwuD1hizK3ix14t5iFjBdRepQtzo8xrmw/o
3FNyvkd7tZhxFym2958SvI+qFrRfzFiRsjFsRs71oTmY0fBxSMSCulVe90+RtURI
pUK1E7fc2cLiIDy4Sasokc8mnaU9nIzoKKvKhy7i5jqn7sAiero=
=H3z6
-----END PGP SIGNATURE-----

--RoAHjuWMiGqxC2cebdJUvHTK0JkOgRMiX--
