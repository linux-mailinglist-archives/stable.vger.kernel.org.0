Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92FC41B840
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 22:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242669AbhI1UVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 16:21:11 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:53509 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbhI1UVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 16:21:10 -0400
Received: from relay6-d.mail.gandi.net (unknown [217.70.183.198])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 0AE38D2C64;
        Tue, 28 Sep 2021 20:11:37 +0000 (UTC)
Received: (Authenticated sender: thomas.perrot@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id A34F8C0002;
        Tue, 28 Sep 2021 20:11:13 +0000 (UTC)
Message-ID: <5e1c5979b7fd35aa5715ed9b25ca3a59b7b259f4.camel@bootlin.com>
Subject: Re: [PATCH] bus: mhi: pci_generic: increase timeout value for
 operations to 24000ms
From:   Thomas Perrot <thomas.perrot@bootlin.com>
To:     linux-arm-msm@vger.kernel.org
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        hemantk@codeaurora.org, loic.poulain@linaro.org,
        stable@vger.kernel.org
Date:   Tue, 28 Sep 2021 22:11:12 +0200
In-Reply-To: <20210816042206.GA3637@thinkpad>
References: <20210805140231.268273-1-thomas.perrot@bootlin.com>
         <20210816042206.GA3637@thinkpad>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-+0L0MOBcfzP8BlPB1d/S"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-+0L0MOBcfzP8BlPB1d/S
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Manivannan,

I just saw that this patch seems not yet been merged, is there a issue
with it?

Best regards,
Thomas

On Mon, 2021-08-16 at 09:52 +0530, Manivannan Sadhasivam wrote:
> On Thu, Aug 05, 2021 at 04:02:31PM +0200, Thomas Perrot wrote:
> > Otherwise, the waiting time was too short to use a Sierra Wireless
> > EM919X
> > connected to an i.MX6 through the PCIe bus.
> >=20
> > Signed-off-by: Thomas Perrot <thomas.perrot@bootlin.com>
>=20
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>=20
> Thanks,
> Mani
>=20
> > ---
> > =C2=A0drivers/bus/mhi/pci_generic.c | 2 +-
> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/bus/mhi/pci_generic.c
> > b/drivers/bus/mhi/pci_generic.c
> > index 4dd1077354af..e08ed6e5031b 100644
> > --- a/drivers/bus/mhi/pci_generic.c
> > +++ b/drivers/bus/mhi/pci_generic.c
> > @@ -248,7 +248,7 @@ static struct mhi_event_config
> > modem_qcom_v1_mhi_events[] =3D {
> > =C2=A0
> > =C2=A0static const struct mhi_controller_config
> > modem_qcom_v1_mhiv_config =3D {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.max_channels =3D 128,
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.timeout_ms =3D 8000,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.timeout_ms =3D 24000,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.num_channels =3D ARRAY=
_SIZE(modem_qcom_v1_mhi_channels),
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.ch_cfg =3D modem_qcom_=
v1_mhi_channels,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.num_events =3D ARRAY_S=
IZE(modem_qcom_v1_mhi_events),
> > --=20
> > 2.31.1
> >=20

--=20
Thomas Perrot, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com


--=-+0L0MOBcfzP8BlPB1d/S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQGzBAABCAAdFiEEh0B3xqajCiMDqBIhn8ALBXH+Cu0FAmFTduAACgkQn8ALBXH+
Cu33nQwAs8zG3VKh9pWXs3sGavgBzl6meKlz7wh6FZKl4wpbOlpaBhtt7H9wHqyt
9vk+xrgkljYqTM7CEAm15LLUPjh0jKT1IJ4dkqozWGZhxq5O4FhguBWf/YpdROd3
lXDbh21z7A92L/yQR0IZCrVDDzYQsTw+Fh9h8IBC2dsCWgjD2DhHuGvWrQxn4KP7
0v7Ic+PIHZXgO4/8wppWi2DYYCJPD5rq1oL2LbI9/IUF9E/vmDfzGXA4FfLsX+V8
kKXv5kNI5MkZDzpzftuSvDWAZ28RTdcjTiYQQuoK8P7wOUKtIN67n79W0L65DteK
OyVZmT6O/v6t+SIdYlzs45LYVxfjfIfOJ6q2SDRk1pcWWvTXaoOw6iTiUMZkdPBp
1OZHi1E5wGEiwd6ZhXJSe15sU+RLb7FcSPO83SjA50xfEKDSnM9O7oY3y4fAaFfN
RAHerf7tWPMQY6hbSnnt6CxM6wnwDm9VVNEb4LyPWwke7spTa+EauMYJZJf3oZ9I
la4m5o5q
=G2lD
-----END PGP SIGNATURE-----

--=-+0L0MOBcfzP8BlPB1d/S--

