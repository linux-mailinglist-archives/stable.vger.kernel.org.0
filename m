Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1820C275EF8
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 19:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgIWRpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 13:45:43 -0400
Received: from sonic309-25.consmr.mail.ir2.yahoo.com ([77.238.179.83]:41709
        "EHLO sonic309-25.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgIWRpm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 13:45:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1600883140; bh=YiBnr4Uk8siI0dhikjlKOiXekrwpOWZKz+TPVjgu4sY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=QHnxb7ZOSm0U9umnapHLiVYBvwPoFXX54zrX49DtHM8vi3y1qzZa/b/X+BFGSmbO+8tHIRalJzLFNrXFJiFbmvH4lYylLWqYnIrs73zkb5Us1Oh76IxfikgCHfvrc4F5qrYBUNU8TSS7XkzPMiK8+Gc1GXCB23B5nt2tyJGdX5hMMXCzybr2t2D10BnKSISIHhm1OPlKdNA+qxd7BQgdUUcdCDE5AlOwrmbQHe4s3oj2p4IRMbsx9l4lkakv1PFm9ZC5UTjIRO16qwGwg1OgCTbKm+ZSaRFe00DbEFLLVjFC/wzeZoiTkYK7Z83GpRmrg4OV0Nz2GUNr0uuOIio1PQ==
X-YMail-OSG: kHkgzTIVM1majjkvNPnL5VnL9caCL5gDT0f9_xqzxTSQYoHbRrnVRYE7J.aHVZk
 lKSNnE9Ox1Ek.f__bq3lV3O2oA1CiNUj5Wbxnhxc_tU2kXMPdLt9znVgD0l7yRH4frUbkIKZmZeA
 Ru6Hbcp5kHsbFA.b3QYFbxFs.FlbGn12WWkZaL9WRa.2I6GrXyL0rAT4ESQjs9cYJ0WF.UtnZyZ0
 uL7xLOga5J_9_U4dmGnzs_Hoc1aYybmAigIKYQ_1bB9aaqxAdSEWp69s4b1RDZjmp6nJ4jdUr_nl
 Bzrr.b8wHeUDbDuTvCGrcdA0SisAzX_NIkxGaDoMvNvvhXrSg9tuzm4kAfWOvQzaelbFRbrcvC3D
 eLpk1fx4DJZeGwlBcroeCkQ0.dpdnn3RuSmTcLhYQLC1sDgbqTB.JpqznbaW7ECsGKIaUyexJ.ET
 yqkv87yQ3lD0jd8nDPN88fyEda6muP2ohOCtHJW5apchMQk_XkMwYvpneUOoIilk6RNkUVwLXdan
 kimte5bAAXFjaRQzxBpVCma9IURwe_8ezqMbqPPDHPxsOK7BD__BozhcAcMOgnKVSbxBoiM0utpq
 pX9.BSKIX2iPc51Wvu.p4Xs3EWPOgR24LSiAXTny2zd_Pc9uLI9uUnvPrz4h.vZpIe2iq7xhyOu9
 N125ha_AXHHgiHaYSUO6RX0yafhiFx.DrMO.tq6exGq62wkA6AHCKqkUkvVi2I3XtY5itRVNkr7i
 nLb9oVQb95rMaN3ZNz3JvDVV3x8dEvkTGrkAzN0PzIKCAvggmjGroHa_hXt9vAAvA7nEhnCUvTll
 anudeCdwyRwSAaVt6._0H_RXrwHG6AweaxfhoaSx9_ThuXYH2dqBSJ2BwHAmUQpNkucUiLZzWk4s
 huM3.R6gYwnG_7tava3nMRfR0XxRdyq2u45bVyPxx2hgwGGYGFer8Ik1LrrCZvo4QCXtqZWcUqDp
 Y_9Bv2Y6X_yRcbhoeP.C4ZyAc3Sdox_Ccn1g_SN49HQaNrRhfu.1IL8rD1WhaWSXV7nukHpYG_ey
 8kDmzoq8C4YCxVXWTrczRpW6tapIUcGd.51tjX9rW7XTMhR.h12aKOOKN3K_KX6vDKfEc7uX2neb
 XcymxpLUCvM9xZvjIua6wbFiqyJPlNrbTC2ORd2skFOLw1eybSYflUiSkqL3SV7195JTcNu62A1d
 R_3i8L3FqN9hDmSQxmInlhvLSxvwO9WCbKsD6TvEM.4s.OIH6wojF29lN_Mh5yfNKZ4ZrvCOUcvb
 ewTgCaRzrlKEB8YiihhIUBhxwlZcGjG8bVvvrMY3jbcll8KjFa1hvLJVDT8AI9iBJCUbGW93et1t
 vtWzFMH_h8EcoFRoKjalI6sbdOLmQtrkBjM.Hmj6_vTVz4DW5SSPwc6N.uvQNzKz3jr8SkjMN3.z
 pINv0iQFtMxtf4ttCX0UxREjTezqOlxIxTU4ji1UODGE5Gsq8dIblTXgQbK1W9_i2dHrqs5rVgyw
 wN3Bk1b8l0KyQ4g--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ir2.yahoo.com with HTTP; Wed, 23 Sep 2020 17:45:40 +0000
Date:   Wed, 23 Sep 2020 17:45:35 +0000 (UTC)
From:   " MRS. MARYAM COMPAORE" <mrscompaoremary2222@gmail.com>
Reply-To: mrscompaoremary2222@gmail.com
Message-ID: <1328407275.4708406.1600883135571@mail.yahoo.com>
Subject: FORM.MRS.MARYAM C. RICHARD.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1328407275.4708406.1600883135571.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16583 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My Beloved Friend In The Lord.

Greetings in the name of our Lord Jesus  Christ. I am Mrs. Maryam C. Richar=
d, From Poland, a widow to late (MR.RICHARD BURSON from Florida , U.S.A) l =
am 51 years old and I am a converted born again Christian, suffering from l=
ong term  Cancer of the KIDNEY, from all indication my condition is really =
deteriorating and it is quite obvious that I might not live more than two (=
2) months, according to my Doctor because the cancer has gotten to a very w=
orst / dangerous stage.

My late husband and my only child died last five years ago, his death was p=
olitically motivated. My late husband was a very rich and wealthy business =
man who was running his Gold/Diamond Business here in Burkina Faso. After h=
is death, I inherited all his business and wealth. My doctors have advised =
me that I may not live for more than two (2) months, so I now decided to di=
vide the part of this wealth, to contribute to the development of the churc=
hes in Africa, America, Asia, and Europe. I got your email id from your cou=
ntry guestbook, and I prayed over it and the spirit our Lord Jesus directed=
 me to you as an honest person who can assist me to fulfill my wish here on=
 earth before I give up in live.

My late husband, have an account deposited the sum of $5.3 Million Dollars =
in BANK OF AFRICA Burkina Faso where he do his business projects before his=
 death, So I want the Sum $5.3 Million Dollars in BANK OF AFRICA Burkina Fa=
so to be release/transfer to you as the less privileged because I cannot ta=
ke this money to the grave. Please I want you to note that this fund is lod=
ged in a Bank Of Africa in Burkina Faso.

Once I hear from you, I will forward to you all the information's you will =
use to get this fund released from the bank of Africa and to be transferred=
 to your bank account. I honestly pray that this money when transferred to =
you will be used for the said purpose on Churches and Orphanage because l h=
ave come to find out that wealth acquisition without Christ is vanity. May =
the grace of our lord Jesus the love of God and the fellowship of God be wi=
th you and your family as you will use part of this sum for Churches and Or=
phanage for my soul to rest in peace when I die.

Urgently Reply with the information=E2=80=99s bellow to this My Private E-m=
ail bellow:=20

( mrscompaoremary392@gmail.com )

1. YOUR FULL NAME..........

2. NATIONALITY.................

3. YOUR AGE......................

4. OCCUPATION.................

5. PHONE NUMBER.............

BEST REGARD.
MRS.MARYAM C. RICHARD.

