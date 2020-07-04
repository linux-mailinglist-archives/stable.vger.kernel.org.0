Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A2C2145D2
	for <lists+stable@lfdr.de>; Sat,  4 Jul 2020 14:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgGDMaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jul 2020 08:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgGDMaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jul 2020 08:30:01 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC7CC061794;
        Sat,  4 Jul 2020 05:30:00 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 49zWPL2cTLzKm7m;
        Sat,  4 Jul 2020 14:29:58 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id 2tMOKgQRuV5z; Sat,  4 Jul 2020 14:29:55 +0200 (CEST)
Subject: Re: [PATCH] MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>, tsbogend@alpha.franken.de,
        linux-mips@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20200702225334.32414-1-hauke@hauke-m.de>
 <b9aa9a88-2e87-5317-f828-fc27d9f2221e@hauke-m.de>
 <c41d9deb-4532-6903-38c6-9f27c3c97854@flygoat.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Autocrypt: addr=hauke@hauke-m.de; keydata=
 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
Message-ID: <7c39a5f8-3e8b-78c8-1d51-faae78e94fa5@hauke-m.de>
Date:   Sat, 4 Jul 2020 14:29:31 +0200
MIME-Version: 1.0
In-Reply-To: <c41d9deb-4532-6903-38c6-9f27c3c97854@flygoat.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="dGxWwnPnN3234JDpMf1vdAAAlRvZ0Nari"
X-MBO-SPAM-Probability: 0
X-Rspamd-Score: -7.86 / 15.00 / 15.00
X-Rspamd-Queue-Id: 4E6451807
X-Rspamd-UID: 1834ac
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dGxWwnPnN3234JDpMf1vdAAAlRvZ0Nari
Content-Type: multipart/mixed; boundary="zwOz7fgZDInLAzNxp8bxnYkFB8tGgd3Eg"

--zwOz7fgZDInLAzNxp8bxnYkFB8tGgd3Eg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/4/20 9:37 AM, Jiaxun Yang wrote:
>=20
>=20
> =E5=9C=A8 2020/7/4 =E4=B8=8A=E5=8D=886:31, Hauke Mehrtens =E5=86=99=E9=81=
=93:
>> On 7/3/20 12:53 AM, Hauke Mehrtens wrote:
>>> This resolves the hazard between the mtc0 in the change_c0_status() a=
nd
>>> the mfc0 in configure_exception_vector(). Without resolving this haza=
rd
>>> configure_exception_vector() could read an old value and would restor=
e
>>> this old value again. This would revert the changes change_c0_status(=
)
>>> did. I checked this by printing out the read_c0_status() at the end o=
f
>>> per_cpu_trap_init() and the ST0_MX is not set without this patch.
>>>
>>> The hazard is documented in the MIPS Architecture Reference Manual Vo=
l.
>>> III: MIPS32/microMIPS32 Privileged Resource Architecture (MD00088), r=
ev
>>> 6.03 table 8.1 which includes:
>>>
>>> =C2=A0=C2=A0=C2=A0 Producer | Consumer | Hazard
>>> =C2=A0=C2=A0 ----------|----------|----------------------------
>>> =C2=A0=C2=A0=C2=A0 mtc0=C2=A0=C2=A0=C2=A0=C2=A0 | mfc0=C2=A0=C2=A0=C2=
=A0=C2=A0 | any coprocessor 0 register
>>>
>>> I saw this hazard on an Atheros AR9344 rev 2 SoC with a MIPS 74Kc CPU=
=2E
>>> There the change_c0_status() function would activate the DSPen by
>>> setting ST0_MX in the c0_status register. This was reverted and then =
the
>>> system got a DSP exception when the DSP registers were saved in
>>> save_dsp() in the first process switch. The crash looks like this:
>>>
>>> [=C2=A0=C2=A0=C2=A0 0.089999] Mount-cache hash table entries: 1024 (o=
rder: 0, 4096
>>> bytes, linear)
>>> [=C2=A0=C2=A0=C2=A0 0.097796] Mountpoint-cache hash table entries: 10=
24 (order: 0,
>>> 4096 bytes, linear)
>>> [=C2=A0=C2=A0=C2=A0 0.107070] Kernel panic - not syncing: Unexpected =
DSP exception
>>> [=C2=A0=C2=A0=C2=A0 0.113470] Rebooting in 1 seconds..
>>>
>>> We saw this problem in OpenWrt only on the MIPS 74Kc based Atheros So=
Cs,
>>> not on the 24Kc based SoCs. We only saw it with kernel 5.4 not with
>>> kernel 4.19, in addition we had to use GCC 8.4 or 9.X, with GCC 8.3 i=
t
>>> did not happen.
>>>
>>> In the kernel I bisected this problem to commit 9012d011660e ("compil=
er:
>>> allow all arches to enable CONFIG_OPTIMIZE_INLINING"), but when this =
was
>>> reverted it also happened after commit 172dcd935c34b ("MIPS: Always
>>> allocate exception vector for MIPSr2+").
>>>
>>> Commit 0b24cae4d535 ("MIPS: Add missing EHB in mtc0 -> mfc0 sequence.=
")
>>> does similar changes to a different file. I am not sure if there are
>>> more places affected by this problem.
>>>
>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>> =C2=A0 arch/mips/kernel/traps.c | 1 +
>>> =C2=A0 1 file changed, 1 insertion(+)
>>>
>>> diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
>>> index 7c32c956156a..1234ea21dd8f 100644
>>> --- a/arch/mips/kernel/traps.c
>>> +++ b/arch/mips/kernel/traps.c
>>> @@ -2169,6 +2169,7 @@ static void configure_status(void)
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
>>> change_c0_status(ST0_CU|ST0_MX|ST0_RE|ST0_FR|ST0_BEV|ST0_TS|ST0_KX|ST=
0_SX|ST0_UX,
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 status_set);
>>> +=C2=A0=C2=A0=C2=A0 back_to_back_c0_hazard();
>>> =C2=A0 }
>>> =C2=A0 =C2=A0 unsigned int hwrena;
>>>
>> The MIPS InterAptiv system software user manual suggests to put this
>> back_to_back_c0_hazard() close to the consumer. Should I move it there=
?
> I assume the suggestion was for performance concern.
> I'd prefer just put it after c0 write, so we can easily trace missing
> barriers.

Yes, I also think this is for performance reasons, but this is not in a
hotpath. I would leave it as is now and do not plan to change this patch.=


>> Should I also add a back_to_back_c0_hazard() close to the other places=

>> which could be affected by similar problems even when I do not see the=
m
>> at runtime?
> That's preventing us from potential risks. Please do so.

I will send separate patches for these later.

Hauke


--zwOz7fgZDInLAzNxp8bxnYkFB8tGgd3Eg--

--dGxWwnPnN3234JDpMf1vdAAAlRvZ0Nari
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEyz0/uAcd+JwXmwtD8bdnhZyy68cFAl8AdisACgkQ8bdnhZyy
68dHUQf9EbrvlhcZxkNUSAlKjcXPE1q+SE96zj1bpww5kmAcdTi4f4FYL3Gd91nT
iantlz9O5hgK5MeBU0yZNl8CE56No1+3Cy1MMWSL7ilywcIpHFe5t/TMRjAG7KJQ
6lvisxHjqkUYej0bOcl7iDFpREyTIizpC7bdNCyiSx1oH/L7fbXXBxwVJBKvmtVd
mAWsYVtEzVm0n/z68HqsCtbqGxCxVfxqEm0AW6Te2l94itSuLjbS8OiD7ChSSz4B
A78HUVdWmOY+5q8yKI4eHlPXw0tyOAlUPlyK73CLVjPcZNSy9tm11RJMno1DKJq8
EpEcp5RP1HNxTC1m6v8kM4+m6sEEJA==
=X00O
-----END PGP SIGNATURE-----

--dGxWwnPnN3234JDpMf1vdAAAlRvZ0Nari--
