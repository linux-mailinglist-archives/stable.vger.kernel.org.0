Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6F33CAE60
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 23:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhGOVQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 17:16:00 -0400
Received: from mout.gmx.net ([212.227.15.15]:50951 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhGOVP6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 17:15:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626383578;
        bh=UaOK20gJEjadF8wLwylmxnXCll7IKWSwFLcRatRYL3w=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=Bra9MbANHVHc8JLRiVRT24O74i9ZzFoeVXNIoJULKvWyjo8fCuB9N1KUCLj6CerAn
         PzXeJV/BJiYsGRtnxsk/j92MaTgDMTUlv5aRQuQJ5Nct0WUO4lW83T91hwv2HxHhYJ
         t83Pm1aVH8MREqNURHBsUNEVAZH/XKpxVAbAgUb4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mir ([94.31.86.21]) by mail.gmx.net (mrgmx005 [212.227.17.190])
 with ESMTPSA (Nemesis) id 1MbAh0-1lX0ld4BlQ-00bZqp; Thu, 15 Jul 2021 23:12:58
 +0200
Date:   Thu, 15 Jul 2021 23:12:55 +0200
From:   Stefan Lippers-Hollmann <s.l-h@gmx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.13 106/266] drm/amd/display: Cover edge-case when
 changing DISPCLK WDIVIDER
Message-ID: <20210715231255.38f8442b@mir>
In-Reply-To: <20210715182632.619513356@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
        <20210715182632.619513356@linuxfoundation.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/sJaXVH=V8dO53BoZF8MiZz6";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Provags-ID: V03:K1:PAf/42bBMYLOAANFXPQRRZ6TxHYWmMMl5EOVQLwCeOPPR0T8M5x
 9ZnEfDL896VH4rDl4KLkUNFBOR8qohsFHsezvwn4p+2tAUSWcN3d7u39gREPyyotyJ2pWlG
 kGPs6XWrjgCrrRhTMjpyPL1WeSMEl+evq8m2UwbL0iiAnoUujghPpL7ngKfvLTAt8YwkAeo
 sLHR7zufwFrS5hR6/Zbvw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jyeHK8dgNbk=:rhHXnPm4hBsbJrZa8jlOGH
 gBuiGS75WWkxbiUXt337UVy18Y6u/Y37DPSaGI6Xy4/JT/em6Kx1u1rQltv15wghLy6Ll2DY0
 6KPHC2eIOu2AIJsSY1LVGD4FGll5LQaZ33e7BuTD0pfrAzsOA7x42e5TezXe34iHQrD0my8fJ
 15MEYSrrUXSLHdSN9POTBvMGfH+0AK9iKCCOyOn7cWGw5Zyg711TOlAoFtb66tMD585ApF2gH
 hYi+vTOmhDz324xjB5zVR7oET57VT9Te9Z99QIRDD3iHxIlheHHcyud+TvmSziU1stah4jkhn
 +nju4OXOkLdCMxvSCKyZrvbZBRe16JAcvkOAMhipeZdxWaXCiPxFXHDL4khgwPsDtOAhpJibD
 DA5vBOSVIK5GGwdulJHcdouKNmMKHBPMsWD/kmwJsydNWLA0H51Bv/m+Inx0buVmsLjb2O7HV
 T7g32HHoPpf7lI/VSGCegiRp1Zds9/XDSsnJh84Wl1zLoyuhxafSZZAp35JOzvJzRHfRZHT+H
 TK4CIYeqW3JGzDQ9XkJq40UKnf4MFickUsCbkJXbldBtV9oN8hELwiQEBpVkWWeFFy2zVrTJA
 ysj19Sh6BSmIUBr2ciieT8CIfTVKaI1j8DOAYIsAy0876wOyWrchXN6E4Zni+Kq8rRc9UA1FJ
 /jDJdJGT1+jNyrzrC2r5aRhCEXUIAOrBNB0+y/m20yVLAi6qUhTrSxBl57yoD/3scPW1B8mxT
 u2jE+jJPTrfRkcnzw6cLHHi3qXVucmqYNnhStqJIAVU9GGeRgxOmyO6ciuGVZ8AHpSHREs0wz
 hgTO7MFBWxQgcs3aDb4OezXuLm0/qT5Mc62+6KFAjJ+t843iknE2tcMq2dHgpavXNRtU2/N1K
 N6jZl5o2l1zD6XmOUbu4sD1R4Yev+KsssIilC+1LrFrNLReYDCknSTUhVEFUbiURfHr11XNTn
 s+euYHggpSQ70lXhsSvbl5A9+hrkyAI9lO7/caljydSTQ/SLrwKNXLelWUyFCoebALSoH1L2+
 YS4Ni0E2ehkIDYOZQCrxtp+SBBLmp8P4sR9e6rIKbbD2fIMjSwk1MxoexmCSkH9Q87J3i8pSd
 wMjKm8/oEJ7Csl/btVXHaOP/NCS0OSFLYfI
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/sJaXVH=V8dO53BoZF8MiZz6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi

On 2021-07-15, Greg Kroah-Hartman wrote:
> From: Wesley Chalmers <Wesley.Chalmers@amd.com>
>=20
> [ Upstream commit 78ebca321999699f30ea19029726d1a3908b395f ]
>=20
> [WHY]
> When changing the DISPCLK_WDIVIDER value from 126 to 127, the change in
> clock rate is too great for the FIFOs to handle. This can cause visible
> corruption during clock change.
>=20
> HW has handed down this register sequence to fix the issue.
>=20
> [HOW]
> The sequence, from HW:
> a.	127 -> 126
> Read  DIG_FIFO_CAL_AVERAGE_LEVEL
> FIFO level N =3D DIG_FIFO_CAL_AVERAGE_LEVEL / 4
> Set DCCG_FIFO_ERRDET_OVR_EN =3D 1
> Write 1 to OTGx_DROP_PIXEL for (N-4) times
> Set DCCG_FIFO_ERRDET_OVR_EN =3D 0
> Write DENTIST_DISPCLK_RDIVIDER =3D 126
>=20
> Because of frequency stepping, sequence a can be executed to change the
> divider from 127 to any other divider value.
>=20
> b.	126 -> 127
> Read  DIG_FIFO_CAL_AVERAGE_LEVEL
> FIFO level N =3D DIG_FIFO_CAL_AVERAGE_LEVEL / 4
> Set DCCG_FIFO_ERRDET_OVR_EN =3D 1
> Write 1 to OTGx_ADD_PIXEL for (12-N) times
> Set DCCG_FIFO_ERRDET_OVR_EN =3D 0
> Write DENTIST_DISPCLK_RDIVIDER =3D 127
>=20
> Because of frequency stepping, divider must first be set from any other
> divider value to 126 before executing sequence b.
[...]

This patch seem to introduce a build regression for x86_64:

  CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_=
mgr.o
/build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dc=
n20_clk_mgr.c: In function 'dcn20_update_clocks_update_dentist':
/build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dc=
n20_clk_mgr.c:154:26: error: 'const struct stream_encoder_funcs' has no mem=
ber named 'get_fifo_cal_average_level'
  154 |    if (!stream_enc->funcs->get_fifo_cal_average_level)
      |                          ^~
/build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dc=
n20_clk_mgr.c:156:34: error: 'const struct stream_encoder_funcs' has no mem=
ber named 'get_fifo_cal_average_level'
  156 |    fifo_level =3D stream_enc->funcs->get_fifo_cal_average_level(
      |                                  ^~
/build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dc=
n20_clk_mgr.c:159:15: error: 'const struct dccg_funcs' has no member named =
'set_fifo_errdet_ovr_en'
  159 |    dccg->funcs->set_fifo_errdet_ovr_en(
      |               ^~
/build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dc=
n20_clk_mgr.c:163:16: error: 'const struct dccg_funcs' has no member named =
'otg_drop_pixel'
  163 |     dccg->funcs->otg_drop_pixel(
      |                ^~
/build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dc=
n20_clk_mgr.c:166:15: error: 'const struct dccg_funcs' has no member named =
'set_fifo_errdet_ovr_en'
  166 |    dccg->funcs->set_fifo_errdet_ovr_en(
      |               ^~
/build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dc=
n20_clk_mgr.c:185:26: error: 'const struct stream_encoder_funcs' has no mem=
ber named 'get_fifo_cal_average_level'
  185 |    if (!stream_enc->funcs->get_fifo_cal_average_level)
      |                          ^~
/build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dc=
n20_clk_mgr.c:187:34: error: 'const struct stream_encoder_funcs' has no mem=
ber named 'get_fifo_cal_average_level'
  187 |    fifo_level =3D stream_enc->funcs->get_fifo_cal_average_level(
      |                                  ^~
/build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dc=
n20_clk_mgr.c:190:15: error: 'const struct dccg_funcs' has no member named =
'set_fifo_errdet_ovr_en'
  190 |    dccg->funcs->set_fifo_errdet_ovr_en(dccg, true);
      |               ^~
/build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dc=
n20_clk_mgr.c:192:16: error: 'const struct dccg_funcs' has no member named =
'otg_add_pixel'
  192 |     dccg->funcs->otg_add_pixel(dccg,
      |                ^~
/build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dc=
n20_clk_mgr.c:194:15: error: 'const struct dccg_funcs' has no member named =
'set_fifo_errdet_ovr_en'
  194 |    dccg->funcs->set_fifo_errdet_ovr_en(dccg, false);
      |               ^~
make[5]: *** [/build/linux-aptosid-5.13/scripts/Makefile.build:273: drivers=
/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.o] Error 1
make[4]: *** [/build/linux-aptosid-5.13/scripts/Makefile.build:516: drivers=
/gpu/drm/amd/amdgpu] Error 2
make[3]: *** [/build/linux-aptosid-5.13/scripts/Makefile.build:516: drivers=
/gpu/drm] Error 2
make[2]: *** [/build/linux-aptosid-5.13/scripts/Makefile.build:516: drivers=
/gpu] Error 2
make[1]: *** [/build/linux-aptosid-5.13/Makefile:1864: drivers] Error 2
make: *** [/build/linux-aptosid-5.13/Makefile:215: __sub-make] Error 2

Regards
	Stefan Lippers-Hollmann

--Sig_/sJaXVH=V8dO53BoZF8MiZz6
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEMQMcJCzZm4GSqVV4v+AtZbHRQu0FAmDwpNcACgkQv+AtZbHR
Qu27EQ//WEqe/zmh7ICj7Ofq6/ZcQ7/TZhS//5oJM/SyaI8RGsWhJMQFWow5NYLA
lWKC5/VsIlNFywbh2XCdvXA491ZzY6zfDrZXpi8P76/2Js0aptKohAnFosJ6PMD1
+8TVlaJOjlEPjXe44V7EfAtIdTGKS+epGyKUX61ZH1v5ls3pbQzChcGleoe2x/kp
J9YYFWxfZ7+mPj/bWwjmH6ikmjs7oigAUEQmDEqzM0FU0o/HaY/Rr9sU3rxWbjLZ
3oVrcxIkiQCSDu8VdUvqtkg1yiUvGpqQ0Nl3D8NkNwsrLid2/N9K+jEbxuadnhLJ
01lIudzZ50Z6Eeg5IwyIajICNmk+pU8aSr6+m7J9J6YaBO24HGteIcOvRLhMRK66
66VFMsQZLW0jypdqSzFB+/Qi7+AQL5swTQY0zwG57bBy6FvGSzyq+DlEgg61RSo+
0ZR27v73QWBOuXwlnrBpQ0TtKPj8FDyeDWOVkwFKyc4hwpXMkDzHUbSQSjo/cRTH
6DVaqCiuZbP+Atd37UZlCibsiHBulKeNdqc656ikcJiABjQY2BetPOTM1xkPzNzV
cVwJ+S8qLfQPufbWCdtlum5qFNVOxKC9bEoNT+aaAEHU/O5cD9a1eunIEVvHs7P4
OCy0pTtB1EiuyRYOf82qO5tf6peHEZpc6bMmOrUDol4UujQrAuE=
=vYSO
-----END PGP SIGNATURE-----

--Sig_/sJaXVH=V8dO53BoZF8MiZz6--
