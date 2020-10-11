Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B6628A776
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 15:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387846AbgJKNHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 09:07:41 -0400
Received: from sonic315-13.consmr.mail.bf2.yahoo.com ([74.6.134.123]:35197
        "EHLO sonic315-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387844AbgJKNHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 09:07:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602421660; bh=YzMicpeOqHGp2b9I92q3icR4x4Pnp8tD38qutAqyfYI=; h=Date:From:Reply-To:Subject:References:From:Subject; b=td3Aqcwp9NLwLc8R/IjAvXvzqok73VeecPOlDiSuhsBkljJDgVW72WGkZjcsicFzBkRgrXyiXJPARO1cGyHzx5cYJJhQY7ncqfHfh894fhCGBj3TKUHFCwM2g5ieU/hvobBrBoa8sTtRcOEjLFVc07wQTMnOwbZBLErT11/R55caiC7aDleKYytbGDqtPmerh+D6BSKimKIOk6LMl+ZLfvPSQCpkjzk6lntOUYNgWX2HCFOMvSOgWMXpH5+9T7i1gDJTVXt6o/HjxKRyMhcmPzb3Y51q0j8IdItsAnOwIPE/QSqJKHQoLKExIRBZYm5nUcSpDQoOIGEloqnTEgxiSA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602421660; bh=Fn9YYoWrrZ2Q+OrXBpFTOQdyPzfcoan6y5t81pii4fm=; h=Date:From:Subject; b=hp1PzXoGQDaZyRKZl6VO3MzndBQt4XNUYl8vZe0VwZbXpIYHAeJwEdrMLKsnulBnz5TzMX0dLte6rlft0YKEVpDpi13G0kYOxmLS+joqsrJgSZAlBs3drQtTCBRArQ/z+eh/RPDSft7V6qec2iPxr24qb2/47HL6tYFwi04a64M75v5nVp/eQV9CAXGb83vGsrUrpxEvTvWI3I2kILT/IT3go9B9ErNCK8XjeM5WpRPzYbz6oqwWLcmULrbngld0sTpw1l2uOSpdCUsgs+JxESmmlO7ARCdzKM/Bs8XwLPlZAPpwAnRWd/gsXeDm3jpC0+FoUelvind+hejbOml3Ug==
X-YMail-OSG: xVkWQb4VM1lvGmragyClmI4yRJb6jdvNId6o2fZ5eOR_8gkXO0uxv3Iz1fxxUXy
 i0k36BWNGYyXZ45CPmWqdBDeB3O.TVTNfTM6aUu83aO0aNPr5QaYoYNGXLKckq6m9dyC4d7kN8OC
 Z0mfwUxy3JCa5A2mr8Vc7sS9OmKDX_pze.8a3eD.tVJCNfcltIhidmOAdZkeXB5HRnPUVwSRIdyC
 vj7iplbM0SnLMQ7LORQSCk1u.cIeOJ_OQZ2_0ts9IkR.jopq9KOZ_XlxMhku3KSI7vUaQGWCeL7z
 tSoEt_vKw6xIwhaDhj_ML_DUCQtChqUQzMhQmM1_XA5UQIut6tewvuKDhzFQWA7pg6hFsIHwZYN8
 fiYGfxaDLzd_6WMLvvBbkOkl4U1waN.Oq.cnOVVcewR5DBvaxZY3rSLHT6zA7z8eZC2Qa8JC7_EH
 8fvZOjz6j5pYXxx8tOlsiP7D.K_TuYV0_ECMK2UeyaHFf_O3EJg5GaTembdeu5Q1HGfKPuSzyS4c
 wbF0KWW8VAOwLxicz3PHoblGCywszqDbfIAnxXMmOw2Xc0gFsj4uIuXZU7TykGJsJq2mgk2P0yQe
 0uvc0_n2l5s2HmP7D_C9Yc2jQOUDMVwEyikHtJ31eb8XLRIUyrV_zbJKHDIqwReCWWt6Qp8g0w9u
 cZutBFNTxL8LohJLMpqzxYm9LTjctjYFCX0gy5MEySpcqLTe_PARHrXUqu3Hc3n31cQV6oVgXjK8
 z2uPpLSjoWRYavOemd1NNzfUOJTkDyQ0nlUxgu7Um8twdrixR.JKPSFNoVQVrtJOWbGvTugWKRN0
 HTShwTiJdYOm1kjHYCVugcyObN8HD3IrTgRX8P4coKqQpFMEFnPo0onbL_AT0yEz8fhCY8tnmeC7
 ZItqikHk1ucLyZSLt8GlWBRbkMMv9JOas8AbdpyAnlYtrMTZRO5C05LV6a6VnOXnJEzUR9YjVywh
 GN5xGONC5D4ybasuh0wVtrY3AMDChoyhZIGv14s5xqLKR1gCs82VUNZuXgD9MZm8TjlsyB3_C3yC
 ZHhmYHKpd1zLlCBw7T3wb.OLVahEUXR7WIYIS_i_6rtDcUEWJkYKGCWm8Ly.xzidagQDXbgxzU2N
 9iWeqUpM0cHYLDi.Ar6qni4g4xNULAc4ZTOpBM.7m2WJFos5e4Pp.ozeNKnVB2NsYdyNjruhxJ3Z
 HcipaoJ4mDlwZwp2IEiI3tIlWXgIEVlfpVuVanmLvGN_X2895Ebo.2BlWKrdfmZX.EeGYl2Fqkmt
 SL8y4DQJI_Bb5yeGa6UaV4etnlXRLuE7aT6iT3hjFac9TguVhJO5mGOrd4J..C4i1Q2UQIckXGVK
 ySzhdsTnJ3fym_WsuGlhhLF2d12LMktoRT2OB043PEj9tb254o080.cLX5zuDzGNmFMcrUdo6Emn
 9MNPBJSLNOQ8h97ukLsHI4y0zB_8DUDQlMD74zPBTFBo-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Sun, 11 Oct 2020 13:07:40 +0000
Date:   Sun, 11 Oct 2020 13:07:37 +0000 (UTC)
From:   "Mrs. Caroline Manon" <mrscarolinemanon01@gmail.com>
Reply-To: mrscarolinemanon02@gmail.com
Message-ID: <639550071.196894.1602421657739@mail.yahoo.com>
Subject: Greetings from Mrs. Caroline Manon.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <639550071.196894.1602421657739.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16795 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings from Mrs. Caroline Manon.

Dearest,

I assume that this message will reach you in good health. Though I did not =
know you in person or have i seen you before, but due to the reliable revel=
ation, I decided to share this lucrative opportunity with you, so kindly co=
nsider this message as vital, believing that you will never regret anything=
 at the end.

First and foremost, I have to introduce myself to you, I am Mrs. Caroline M=
anon. the wife of late Mr. Micheal Manon. Director of High River Gold Mines=
 Ltd Burkina Faso West Africa. Presently I am suffering from breast cancer =
and from all indication; I understand that I am not going to survive this s=
ickness.

Therefore i have decided to donate the sum of Twenty Five Million Two Hundr=
ed Thousand United State Dollars ($25,200,000.00) to Charity Organizations =
or to support the Orphans, Motherless Babies, Less privileged and free Medi=
cal & Medicine for Poor People around the World since I don't have any chil=
d and do not want the bank to take over my fund. So i want you to handle th=
is project accordingly, accomplish my heart desire and utilize this fund, I=
 assured you honesty and reliability to champion this business opportunity.

If you are ready to handle this transaction, =C2=A0i will guide you on how =
you will apply for the claim, so that the fund will be release into your ow=
n account and you will take 30% from the fund and the rest 70% =C2=A0will u=
se to Charity Organizations, Further information will be given to you as so=
on as I receive your reply.

Remain blessed in the name of the Lord.

Regards
Mrs. Caroline Manon.
