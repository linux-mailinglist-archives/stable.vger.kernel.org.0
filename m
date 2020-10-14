Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4898028E182
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 15:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbgJNNmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 09:42:23 -0400
Received: from sonic302-2.consmr.mail.bf2.yahoo.com ([74.6.135.41]:35443 "EHLO
        sonic302-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727421AbgJNNmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 09:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602682942; bh=imVSmPuahrcxieDYfbhDsp86JDAVdcxLnEllSMcQGDU=; h=Date:From:Reply-To:Subject:References:From:Subject; b=a+vMfJ4Xr7HW7mfpylnEnSAIbVkpghv2j/y07s1XUKquU9GvJ3eMT+6ZyG5YmYaBLHUXz8BNra9kx8fttBgH1dL3HpnX9RA2FDbvPlc2wWXIJi9pE4MVbgx3mZKQ1qhUAc49xUZJLJWrWqRKIBdT1JTY8F8T7K/1nU5ApidjKiFzxh/wq+EcVq+MmpTWk9jg2t86cAC6g3kQNM48isnX2O5SfKGjZ+yzcQMXROT1JP2r2oS21CQG/7tAd5TCGfKPzveRLb2ZUXo9LtaclNINvu7VgvLmfGMY1GbtEh8zewxmUpmmYXXZ1z6E6PKTM2MroyXXi3qbYCqEG5fPgygvCA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602682942; bh=lbt0+bwR8No6bldysjuBn1jjdkhc6LZwwx4gr1lNO9p=; h=Date:From:Subject; b=MUoDy8w+Md8OR0hFUgiAjxmNXYfuD2dLPoIVQ47x01NkAuOfZfYz9aMUUUV9int3taa90NMGrUNNbsR0dsGkY6m2uojrumWiWFTiMzZIPKs1NAyEdW27hR2Aq+4fHy/ApcnMNQm5LXk1avbPBWIgiBbnvSzOmpVyVeo8SJ5DUO5+UbHTjXeNdEvEDEsCMDT0ibdfMglExA4r0eAXzQxtMoZ2xrupRGaRa9G0voRNc1YkYXrQ0FLdnR6rsIH67n4JIyE/YPlCSqtosRG/6pEEIhCAd+UuQDnqOdlKu5OGKtIKR5FvV3oYaDMDcAz00s1YiIxLWwG0p6OWCTQa4ZoncQ==
X-YMail-OSG: Kfrr_uEVM1mHum5.1uydO3jZW99yK1AXJvZh7iSQYGfmmUztUh2I989ijFaOtml
 twOKU7Z7D4NVm_YFUfSceig_.C61.ogxTHfWsKF7CgNT0w.G3qjwd4MDDBrQNW4fohGjjsCchxmi
 G5EF_jehGK6fvBVh1zr6hfM9FIYy_3_0bsq8auo8Xfi4N6L1cEri3Vgd8i5Qxs1a_wooYuvW3rms
 kGO2suWtxprEdL2jchzkf5ziT21I6UCF5G3nuYQlAN2gbx5xtFD2gW2idPXGv5yGNud.dkixUKny
 RSkkn0Sw.bQEQ.zbAlatYJZo5Sqlg2s.jm0.RDtjX7kyg68lDx8sc7bi5FDkiEaPoYOmOmn9l73o
 PKRPm1eZaZc4f6JYS5N7E6ndwJIMvVv.Azg1idO8jWVzzlAY6rqnyaMyLmiiK0UINaFxqAqZ7IOE
 jZ2HKePfGGMc3ZJmvpHPkLbTB5igs0sRQjG4sC.t1q3j39GaLjnDE4lL6myLCBLtMxmhTJfFQLrg
 6sKluNGbXoeGMLH47xJwxDL1ziHW2S2W2T4kEnXnPjOqebptbBwFh6zD.g0OQJ1XLjtCIO9ifJDq
 dSHvxo78w_JBF41IVHpy6JuYzO73dO_PZ8U.IUQVVHJfHpmiKolTcQi1.aOQi6O73zMsOFHw1T1a
 UvXyRK5rPbalCmz7G16_YakDi6HApGEHvyUxONl7_tK7cch3.p2.FpCrYr4dQcGrtnKoYTCgXsKi
 qHX_cr2k3uM8uEmyKDFBrzFhzgurW5ot3koqSlCacqPMhtC0TSdCbxPx9TJeXgKeqMsMzY5sG5LF
 0513ZQlrZs.ekPGBBFHSCy_6hHNTfSpbOZmWC8iBPRlSz2X1loKHMv.wnJ34TID4J0HOXWSVV2fK
 jR36DwdfTy2Xje.gnrSyLGZQgwroh6P1.8505afwfzgxdIKW3jt7S_5VpqQpO8H_iRx6gVisKg7o
 c.5PYwKT.oAM8Rw5j4kBgZJRAtvq0h7g4dn5_SqVyREin5EVIep6QIdWineXVZFKGkS_aCEhCkaj
 KYzofuhryFhuSxXDultDVtdLfBGQb4vuC6X2jYP48CGQfnYe.KgpEQCK6aLWD3gLJtdYHiLANGn7
 icj6KDHJe8UJHWGWlJS3GyaYv.Q3SI6pJIZVfuNaW0fjX7FvCQ4tzpvNHkoYbyhR3NzIv0abUeL9
 dolSp15oF_L66wGQY_w8XX50YKlLOTjxxAKk2nOokHPhkS0nAvaPhjt7LwjZxCC9CQj87t30TbV6
 rUVir9elYr7uRjsxvstJfrKN1SheVuOut3lQRRoW_wzK0W31wa9kTcnqzddBIKrUYwVYAzurIayA
 KsEtebouRpFj1IxoZ9Dq8o0kAsAGbQDxU1XE3Gpza_uvsTaoxpMVn8_dcCPl5ZIWhTeur_hY9cXA
 e33DEh8BDEkA1FwVRmRSxY4gtuZjzT_UTLd7TFDAZIVgLuD20dsBHBA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.bf2.yahoo.com with HTTP; Wed, 14 Oct 2020 13:42:22 +0000
Date:   Wed, 14 Oct 2020 13:42:21 +0000 (UTC)
From:   "Mrs. Caroline Manon" <mrscarolinemanon01@gmail.com>
Reply-To: mrscarolinemanon02@gmail.com
Message-ID: <457544712.402143.1602682941264@mail.yahoo.com>
Subject: Greetings from Mrs. Caroline Manon.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <457544712.402143.1602682941264.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16845 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings=C2=A0from=C2=A0Mrs.=C2=A0Caroline=C2=A0Manon.

Dearest,

I=C2=A0assume=C2=A0that=C2=A0this=C2=A0message=C2=A0will=C2=A0reach=C2=A0yo=
u=C2=A0in=C2=A0good=C2=A0health.=C2=A0Though=C2=A0I=C2=A0did=C2=A0not=C2=A0=
know=C2=A0you=C2=A0in=C2=A0person=C2=A0or=C2=A0have=C2=A0i=C2=A0seen=C2=A0y=
ou=C2=A0before,=C2=A0but=C2=A0due=C2=A0to=C2=A0the=C2=A0reliable=C2=A0revel=
ation,=C2=A0I=C2=A0decided=C2=A0to=C2=A0share=C2=A0this=C2=A0lucrative=C2=
=A0opportunity=C2=A0with=C2=A0you,=C2=A0so=C2=A0kindly=C2=A0consider=C2=A0t=
his=C2=A0message=C2=A0as=C2=A0vital,=C2=A0believing=C2=A0that=C2=A0you=C2=
=A0will=C2=A0never=C2=A0regret=C2=A0anything=C2=A0at=C2=A0the=C2=A0end.

First=C2=A0and=C2=A0foremost,=C2=A0I=C2=A0have=C2=A0to=C2=A0introduce=C2=A0=
myself=C2=A0to=C2=A0you,=C2=A0I=C2=A0am=C2=A0Mrs.=C2=A0Caroline=C2=A0Manon.=
=C2=A0the=C2=A0wife=C2=A0of=C2=A0late=C2=A0Mr.=C2=A0Micheal=C2=A0Manon.=C2=
=A0Director=C2=A0of=C2=A0High=C2=A0River=C2=A0Gold=C2=A0Mines=C2=A0Ltd=C2=
=A0Burkina=C2=A0Faso=C2=A0West=C2=A0Africa.=C2=A0Presently=C2=A0I=C2=A0am=
=C2=A0suffering=C2=A0from=C2=A0breast=C2=A0cancer=C2=A0and=C2=A0from=C2=A0a=
ll=C2=A0indication;=C2=A0I=C2=A0understand=C2=A0that=C2=A0I=C2=A0am=C2=A0no=
t=C2=A0going=C2=A0to=C2=A0survive=C2=A0this=C2=A0sickness.

Therefore=C2=A0i=C2=A0have=C2=A0decided=C2=A0to=C2=A0donate=C2=A0the=C2=A0s=
um=C2=A0of=C2=A0Twenty=C2=A0Five=C2=A0Million=C2=A0Two=C2=A0Hundred=C2=A0Th=
ousand=C2=A0United=C2=A0State=C2=A0Dollars=C2=A0($25,200,000.00)=C2=A0to=C2=
=A0Charity=C2=A0Organizations=C2=A0or=C2=A0to=C2=A0support=C2=A0the=C2=A0Or=
phans,=C2=A0Motherless=C2=A0Babies,=C2=A0Less=C2=A0privileged=C2=A0and=C2=
=A0free=C2=A0Medical=C2=A0&=C2=A0Medicine=C2=A0for=C2=A0Poor=C2=A0People=C2=
=A0around=C2=A0the=C2=A0World=C2=A0since=C2=A0I=C2=A0don't=C2=A0have=C2=A0a=
ny=C2=A0child=C2=A0and=C2=A0do=C2=A0not=C2=A0want=C2=A0the=C2=A0bank=C2=A0t=
o=C2=A0take=C2=A0over=C2=A0my=C2=A0fund.=C2=A0So=C2=A0i=C2=A0want=C2=A0you=
=C2=A0to=C2=A0handle=C2=A0this=C2=A0project=C2=A0accordingly,=C2=A0accompli=
sh=C2=A0my=C2=A0heart=C2=A0desire=C2=A0and=C2=A0utilize=C2=A0this=C2=A0fund=
,=C2=A0I=C2=A0assured=C2=A0you=C2=A0honesty=C2=A0and=C2=A0reliability=C2=A0=
to=C2=A0champion=C2=A0this=C2=A0business=C2=A0opportunity.

If=C2=A0you=C2=A0are=C2=A0ready=C2=A0to=C2=A0handle=C2=A0this=C2=A0transact=
ion,=C2=A0=C2=A0i=C2=A0will=C2=A0guide=C2=A0you=C2=A0on=C2=A0how=C2=A0you=
=C2=A0will=C2=A0apply=C2=A0for=C2=A0the=C2=A0claim,=C2=A0so=C2=A0that=C2=A0=
the=C2=A0fund=C2=A0will=C2=A0be=C2=A0release=C2=A0into=C2=A0your=C2=A0own=
=C2=A0account=C2=A0and=C2=A0you=C2=A0will=C2=A0take=C2=A030%=C2=A0from=C2=
=A0the=C2=A0fund=C2=A0and=C2=A0the=C2=A0rest=C2=A070%=C2=A0=C2=A0will=C2=A0=
use=C2=A0to=C2=A0Charity=C2=A0Organizations,=C2=A0Further=C2=A0information=
=C2=A0will=C2=A0be=C2=A0given=C2=A0to=C2=A0you=C2=A0as=C2=A0soon=C2=A0as=C2=
=A0I=C2=A0receive=C2=A0your=C2=A0reply.

Remain=C2=A0blessed=C2=A0in=C2=A0the=C2=A0name=C2=A0of=C2=A0the=C2=A0Lord.

Regards
Mrs.=C2=A0Caroline=C2=A0Manon.
