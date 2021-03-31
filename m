Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817D4350630
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 20:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbhCaSVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 14:21:47 -0400
Received: from a27-222.smtp-out.us-west-2.amazonses.com ([54.240.27.222]:46081
        "EHLO a27-222.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234707AbhCaSVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 14:21:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zzmz6pik4loqlrvo6grmnyszsx3fszus; d=nh6z.net; t=1617214905;
        h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
        bh=Wvrl+PGUFFhmFetmW+Bc4xwTyMmhO79JmMYv9SYxDKo=;
        b=KaWY2pytdH1cZ+/ddUPbcDrp4tCX5+PNS+vxK0sh8tpT/9ItOAJEQ1ASf2UKVngb
        IbF0BjEN86LYuNtD/PcwL26oCHGBEbwd7AHTWK50WKzoRqc8k1nSBMYzFLoXU5NiN0O
        w3LCLaONr464/zth+8yA16IPacP8UeEkZgbFR0Eo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=7v7vs6w47njt4pimodk5mmttbegzsi6n; d=amazonses.com; t=1617214905;
        h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
        bh=Wvrl+PGUFFhmFetmW+Bc4xwTyMmhO79JmMYv9SYxDKo=;
        b=dw9PAgmFNGeFKIEou25DTGwftO+ropuNBQAlNY9XaYlYxnqAJPqEK0RAmmtiGHp3
        jw24+my18L2wi7A3xCWNohYOXEfbaf1jIe3o+yNnuVDLxow2fvY2eaUnSFearxG5cXg
        Hq6148QozvI6NM1c6xfASujgxFTeGleD8nlhqgQU=
Subject: [PATCH v2 1/2] ASoC: tlv320aic32x4: Increase maximum register in
 regmap
From:   =?UTF-8?Q?Annaliese_McDermond?= <nh6z@nh6z.net>
To:     =?UTF-8?Q?alsa-devel=40alsa-project=2Eorg?= 
        <alsa-devel@alsa-project.org>,
        =?UTF-8?Q?broonie=40kernel=2Eorg?= <broonie@kernel.org>,
        =?UTF-8?Q?lgirdwood=40gmail=2Ecom?= <lgirdwood@gmail.com>,
        =?UTF-8?Q?perex=40perex=2Ecz?= <perex@perex.cz>,
        =?UTF-8?Q?tiwai=40suse=2E?= =?UTF-8?Q?com?= <tiwai@suse.com>
Cc:     =?UTF-8?Q?Annaliese_McDermond?= <nh6z@nh6z.net>,
        =?UTF-8?Q?team=40nwdigitalradio=2Ecom?= <team@nwdigitalradio.com>,
        =?UTF-8?Q?stable=40vger=2Ekernel=2Eorg?= <stable@vger.kernel.org>
Date:   Wed, 31 Mar 2021 18:21:45 +0000
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210331182125.413693-1-nh6z@nh6z.net>
References: <20210331182125.413693-1-nh6z@nh6z.net> 
 <20210331182125.413693-2-nh6z@nh6z.net>
X-Mailer: Amazon WorkMail
Thread-Index: AQHXJlqutU2ZzEf5Tk+l1YBnPdSJ8wAAAFVe
Thread-Topic: [PATCH v2 1/2] ASoC: tlv320aic32x4: Increase maximum register
 in regmap
X-Original-Mailer: git-send-email 2.27.0
X-Wm-Sent-Timestamp: 1617214904
Message-ID: <0101017889851cab-ce60cfdb-d88c-43d8-bbd2-7fbf34a0c912-000000@us-west-2.amazonses.com>
X-SES-Outgoing: 2021.03.31-54.240.27.222
Feedback-ID: 1.us-west-2.An468LAV0jCjQDrDLvlZjeAthld7qrhZr+vow8irkvU=:AmazonSES
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

AIC32X4_REFPOWERUP was added as a register, but the maximum register valu=
e=0D=0Ain the regmap and regmap range was not correspondingly increased. =
 This=0D=0Acaused an error when this register was attempted to be written=
=2E=0D=0A=0D=0AFixes: ec96690de82c ("ASoC: tlv320aic32x4: Enable fast cha=
rge")=0D=0ACc: stable@vger.kernel.org=0D=0ASigned-off-by: Annaliese McDer=
mond <nh6z@nh6z.net>=0D=0A---=0D=0A sound/soc/codecs/tlv320aic32x4.c | 4 =
++--=0D=0A 1 file changed, 2 insertions(+), 2 deletions(-)=0D=0A=0D=0Adif=
f --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32=
x4.c=0D=0Aindex f04f88c8d425..1ac3b3b12dc6 100644=0D=0A--- a/sound/soc/co=
decs/tlv320aic32x4.c=0D=0A+++ b/sound/soc/codecs/tlv320aic32x4.c=0D=0A@@ =
-577,12 +577,12 @@ static const struct regmap_range_cfg aic32x4_regmap_pa=
ges[] =3D {=0D=0A =09=09.window_start =3D 0,=0D=0A =09=09.window_len =3D =
128,=0D=0A =09=09.range_min =3D 0,=0D=0A-=09=09.range_max =3D AIC32X4_RMI=
CPGAVOL,=0D=0A+=09=09.range_max =3D AIC32X4_REFPOWERUP,=0D=0A =09},=0D=0A=
 };=0D=0A=20=0D=0A const struct regmap_config aic32x4_regmap_config =3D {=
=0D=0A-=09.max_register =3D AIC32X4_RMICPGAVOL,=0D=0A+=09.max_register =3D=
 AIC32X4_REFPOWERUP,=0D=0A =09.ranges =3D aic32x4_regmap_pages,=0D=0A =09=
=2Enum_ranges =3D ARRAY_SIZE(aic32x4_regmap_pages),=0D=0A };=0D=0A--=20=0D=
=0A2.27.0=0D=0A=0D=0A
