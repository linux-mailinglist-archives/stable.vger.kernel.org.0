Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B1334D27C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 16:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhC2Oii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 10:38:38 -0400
Received: from a27-226.smtp-out.us-west-2.amazonses.com ([54.240.27.226]:43947
        "EHLO a27-226.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230415AbhC2OiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 10:38:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zzmz6pik4loqlrvo6grmnyszsx3fszus; d=nh6z.net; t=1617028687;
        h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
        bh=q/tgUKyQ/gdmr80BB/z/FJzNAF8dyaLAhP9BdaSIoVk=;
        b=U3HsH0eitV8UA9568k9X5kVEoQAJeur3ouabKP2q2N0J0V6vu4VXAV5SuYx+RRh5
        MtfAgRCsg/n2B+gVSPM/MjjkDvPrROQ3FP+X8LLDq8hm7MAlkEggz12I9BAaPv1sQJl
        N5qB6j1HHWI7md/KHC3zDS0pN2fSKX5EMKpbSVH0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=7v7vs6w47njt4pimodk5mmttbegzsi6n; d=amazonses.com; t=1617028687;
        h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
        bh=q/tgUKyQ/gdmr80BB/z/FJzNAF8dyaLAhP9BdaSIoVk=;
        b=BCdBWzD16dTcTxxbO/+Xnun0+l/704ah/7pWM/vDEJMZKFrOE3hZ7YUfSgWBSjGS
        qKbS9bA0LENOebdrya9Mu88V3FbVXF+wa2KDbrgIHkK4FKawa0Nykl7D7YQ3ikroZKK
        immRcyd19Ldd05ss8X7w4gCfGQn61uwHJs/bbHls=
Subject: [PATCH 1/2] ASoC: tlv320aic32x4: Increase maximum register in regmap
From:   =?UTF-8?Q?Annaliese_McDermond?= <nh6z@nh6z.net>
To:     =?UTF-8?Q?alsa-devel=40alsa-project=2Eorg?= 
        <alsa-devel@alsa-project.org>
Cc:     =?UTF-8?Q?Annaliese_McDermond?= <nh6z@nh6z.net>,
        =?UTF-8?Q?team=40nwdigitalradio=2Ecom?= <team@nwdigitalradio.com>,
        =?UTF-8?Q?stable=40vger=2Ekernel=2Eorg?= <stable@vger.kernel.org>
Date:   Mon, 29 Mar 2021 14:38:07 +0000
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210329143756.408604-1-nh6z@nh6z.net>
References: <20210329143756.408604-1-nh6z@nh6z.net> 
 <20210329143756.408604-2-nh6z@nh6z.net>
X-Mailer: Amazon WorkMail
Thread-Index: AQHXJKkg/ojtMl+8SNWm7v/u1huSVgAAADAz
Thread-Topic: [PATCH 1/2] ASoC: tlv320aic32x4: Increase maximum register in
 regmap
X-Original-Mailer: git-send-email 2.27.0
X-Wm-Sent-Timestamp: 1617028686
Message-ID: <010101787e6ba6f9-2c1aebbf-9224-4305-a52b-3c03d4434e8e-000000@us-west-2.amazonses.com>
X-SES-Outgoing: 2021.03.29-54.240.27.226
Feedback-ID: 1.us-west-2.An468LAV0jCjQDrDLvlZjeAthld7qrhZr+vow8irkvU=:AmazonSES
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

AIC32X4_REFPOWERUP was added as a register, but the maximum register valu=
e=0D=0Ain the regmap and regmap range was not correspondingly increased. =
 This=0D=0Acaused an error when this register was attempted to be written=
=2E=0D=0A=0D=0AFixes: ec96690 ("ASoC: tlv320aic32x4: Enable fast charge")=
=0D=0ACc: stable@vger.kernel.org=0D=0ASigned-off-by: Annaliese McDermond =
<nh6z@nh6z.net>=0D=0A---=0D=0A sound/soc/codecs/tlv320aic32x4.c | 4 ++--=0D=
=0A 1 file changed, 2 insertions(+), 2 deletions(-)=0D=0A=0D=0Adiff --git=
 a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c=0D=
=0Aindex f04f88c8d425..1ac3b3b12dc6 100644=0D=0A--- a/sound/soc/codecs/tl=
v320aic32x4.c=0D=0A+++ b/sound/soc/codecs/tlv320aic32x4.c=0D=0A@@ -577,12=
 +577,12 @@ static const struct regmap_range_cfg aic32x4_regmap_pages[] =3D=
 {=0D=0A =09=09.window_start =3D 0,=0D=0A =09=09.window_len =3D 128,=0D=0A=
 =09=09.range_min =3D 0,=0D=0A-=09=09.range_max =3D AIC32X4_RMICPGAVOL,=0D=
=0A+=09=09.range_max =3D AIC32X4_REFPOWERUP,=0D=0A =09},=0D=0A };=0D=0A=20=
=0D=0A const struct regmap_config aic32x4_regmap_config =3D {=0D=0A-=09.m=
ax_register =3D AIC32X4_RMICPGAVOL,=0D=0A+=09.max_register =3D AIC32X4_RE=
FPOWERUP,=0D=0A =09.ranges =3D aic32x4_regmap_pages,=0D=0A =09.num_ranges=
 =3D ARRAY_SIZE(aic32x4_regmap_pages),=0D=0A };=0D=0A--=20=0D=0A2.27.0=0D=
=0A=0D=0A
