Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7250CE63E
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 16:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfJGO7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 10:59:06 -0400
Received: from mail-eopbgr40082.outbound.protection.outlook.com ([40.107.4.82]:30455
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726334AbfJGO7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 10:59:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bxe9KF2nf6t75aMhLVhIiTOgUjbpxFZQcKR5BhguRqb3eR49Vd1HlFHhseYRTjkXdcpjbZ8QlkJcsCNt/ZdLpNGqgfZgQs8lMuQI5hmd70MHKiWv5ybKtlec5xesm54Y7r8sLhKK1FeKysGoB5K/T8yLKAzqHMkD44P5r9piEB3CM0bQoqKe32p9uxh6M3AlaPh29ezGhdw2YKkfsHfz5TbML5Die5xNoB3Ovef9wlM4j/eIZiIVcfOeS+eMz2enENh6TL4qpdgJ9KQ7c6Y5nT5x2N6ranFHgk6dMDE5S8tvURcsM6dlcMgb8+I/2XD9L3SjWkvD4IxUrK3bYsbeIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWdd98POPn68UBeKmGzOmqZw5GX25tz8WIgB7Ch68lo=;
 b=FQLK2I1o2bDEB4etnrLslGqYTkGgMcunEcF5NXob6DDD4rNmp1Mj9Acwb5hLKBcjC3Vhhq87fT2kCfBTom7MzOXdx8aIGrDZb7KPJiLWEoRuC7FNlUXwlQTMpIyojM9kmCGEeZC70TOIpKk178l7m/QPLdroP4xGJTzfr0Yz+gTmEly3c4gMDwQo1BhVla1rJi/nlTfydZ3/gNTa44nHvqYquiJKaTzrliR6jsNS4JSOUTr8ckDUL9QNoNlRYdofuXHhtYY/IAn4u8WRWd5HGC5S+Z8zNND/Re7o96MmtKv+GP+mzCpxJRnDU33NzIbigzULZVUWNrkFmsdYGnetMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWdd98POPn68UBeKmGzOmqZw5GX25tz8WIgB7Ch68lo=;
 b=Wpy/0qmuoOBrfXhwU/R8NTQrhUTWccb1pweXeORy05iyAQh1P8yDq/2lVem73PfAwheYmu2LAvT2haQPUOd5G+LNODpxSK376vH5uPYZ8hGetWwaJnDPyRx8Vj1A7IK5QcV4nIfqh81Kiy330WHpOAb87wJvTrOUjYKTt9lMltA=
Received: from AM6PR04MB4967.eurprd04.prod.outlook.com (20.177.34.75) by
 AM6PR04MB6135.eurprd04.prod.outlook.com (20.179.7.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Mon, 7 Oct 2019 14:58:58 +0000
Received: from AM6PR04MB4967.eurprd04.prod.outlook.com
 ([fe80::550b:474a:d86a:1967]) by AM6PR04MB4967.eurprd04.prod.outlook.com
 ([fe80::550b:474a:d86a:1967%7]) with mapi id 15.20.2305.023; Mon, 7 Oct 2019
 14:58:58 +0000
From:   Han Xu <han.xu@nxp.com>
To:     Schrempf Frieder <frieder.schrempf@kontron.de>,
        Mark Brown <broonie@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] spi: spi-fsl-qspi: Clear TDH bits in FLSHCR
 register
Thread-Topic: [EXT] [PATCH] spi: spi-fsl-qspi: Clear TDH bits in FLSHCR
 register
Thread-Index: AQHVfOAOADpafN6rX02KBDhfRCqXY6dPRXuA
Date:   Mon, 7 Oct 2019 14:58:57 +0000
Message-ID: <AM6PR04MB4967AA90DEDA889FE721F158979B0@AM6PR04MB4967.eurprd04.prod.outlook.com>
References: <20191007071933.26786-1-frieder.schrempf@kontron.de>
In-Reply-To: <20191007071933.26786-1-frieder.schrempf@kontron.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=han.xu@nxp.com; 
x-originating-ip: [64.157.242.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97b95a3b-d561-485d-f5ec-08d74b36e18a
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM6PR04MB6135:
x-microsoft-antispam-prvs: <AM6PR04MB6135DDE7E362FB09902728DF979B0@AM6PR04MB6135.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(13464003)(199004)(189003)(3846002)(26005)(6116002)(25786009)(66066001)(76116006)(66946007)(33656002)(71190400001)(71200400001)(66446008)(66476007)(66556008)(64756008)(6506007)(99286004)(11346002)(7736002)(53546011)(7696005)(76176011)(86362001)(81156014)(102836004)(8676002)(81166006)(8936002)(486006)(446003)(476003)(110136005)(44832011)(2906002)(186003)(305945005)(14444005)(14454004)(74316002)(54906003)(316002)(52536014)(478600001)(5660300002)(9686003)(6436002)(55016002)(4326008)(6246003)(256004)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB6135;H:AM6PR04MB4967.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PDSzueugOvwy3OFE8wI2mlelRvrWq1SYDZ9yPsPy02QcMAPoIqEm9zPcbsTjQTZRyVE8trmsVt1iTgEZEz986wpsUc7eYPH1nW/64LrN41oXWhQWfo4bw+nKdMGfY8lAXuM91FJxJprYc5/W+yhHMgsELK4FZxJV/m2/OQXxRbLMKQo/MVNZmCS30ThEnD1oh8QWJlO5fUNNQnlNIkCx+SipR8FTUY6rjNAJO7A7us0pSQWuvAnF0KOi5Ryx7gZYEMS27yioZdizCyhpm4C586Eo8KVT/BlO8uRgfpXHJiCzxx1OC5trORpUfBvqyIOVrX+wr28EQ/nhEU0iRvZqI4R+zG8KPEkkfSaT2JYbLSzgV8dclYB5G67K1UgHjuXT+kNviNkYFO2MNf87SQGlImV0hRgBt1IUGsf1tzO2EHM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97b95a3b-d561-485d-f5ec-08d74b36e18a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2019 14:58:57.9482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sv8h6danI8S2cv5B7XpTqL+Y0rDJeo7gfoMcZfx5N7Zxn5XCSUXvjU83iDZl8Mbk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6135
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Schrempf Frieder <frieder.schrempf@kontron.de>
> Sent: Monday, October 7, 2019 2:23 AM
> To: Han Xu <han.xu@nxp.com>; Mark Brown <broonie@kernel.org>
> Cc: Schrempf Frieder <frieder.schrempf@kontron.de>; stable@vger.kernel.or=
g;
> linux-spi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [EXT] [PATCH] spi: spi-fsl-qspi: Clear TDH bits in FLSHCR regist=
er
>=20
> Caution: EXT Email
>=20
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>=20
> Later versions of the QSPI controller (e.g. in i.MX6UL/ULL and i.MX7) see=
m to have
> an additional TDH setting in the FLSHCR register, that needs to be set in=
 accordance
> with the access mode that is used (DDR or SDR).
>=20
> Previous bootstages such as BootROM or bootloader might have used the DDR
> mode to access the flash. As we currently only use SDR mode, we need to m=
ake
> sure the TDH bits are cleared upon initialization.
>=20
> Fixes: 84d043185dbe ("spi: Add a driver for the Freescale/NXP QuadSPI con=
troller")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> ---
>  drivers/spi/spi-fsl-qspi.c | 38 +++++++++++++++++++++++++++++++++-----
>  1 file changed, 33 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/spi/spi-fsl-qspi.c b/drivers/spi/spi-fsl-qspi.c inde=
x
> c02e24c01136..63c9f7edaf6c 100644
> --- a/drivers/spi/spi-fsl-qspi.c
> +++ b/drivers/spi/spi-fsl-qspi.c
> @@ -63,6 +63,11 @@
>  #define QUADSPI_IPCR                   0x08
>  #define QUADSPI_IPCR_SEQID(x)          ((x) << 24)
>=20
> +#define QUADSPI_FLSHCR                 0x0c
> +#define QUADSPI_FLSHCR_TCSS_MASK       GENMASK(3, 0)
> +#define QUADSPI_FLSHCR_TCSH_MASK       GENMASK(11, 8)
> +#define QUADSPI_FLSHCR_TDH_MASK                GENMASK(17, 16)
> +
>  #define QUADSPI_BUF3CR                 0x1c
>  #define QUADSPI_BUF3CR_ALLMST_MASK     BIT(31)
>  #define QUADSPI_BUF3CR_ADATSZ(x)       ((x) << 8)
> @@ -95,6 +100,9 @@
>  #define QUADSPI_FR                     0x160
>  #define QUADSPI_FR_TFF_MASK            BIT(0)
>=20
> +#define QUADSPI_RSER                   0x164
> +#define QUADSPI_RSER_TFIE              BIT(0)
> +
>  #define QUADSPI_SPTRCLR                        0x16c
>  #define QUADSPI_SPTRCLR_IPPTRC         BIT(8)
>  #define QUADSPI_SPTRCLR_BFPTRC         BIT(0)
> @@ -112,9 +120,6 @@
>  #define QUADSPI_LCKER_LOCK             BIT(0)
>  #define QUADSPI_LCKER_UNLOCK           BIT(1)
>=20
> -#define QUADSPI_RSER                   0x164
> -#define QUADSPI_RSER_TFIE              BIT(0)
> -
>  #define QUADSPI_LUT_BASE               0x310
>  #define QUADSPI_LUT_OFFSET             (SEQID_LUT * 4 * 4)
>  #define QUADSPI_LUT_REG(idx) \
> @@ -181,6 +186,12 @@
>   */
>  #define QUADSPI_QUIRK_BASE_INTERNAL    BIT(4)
>=20
> +/*
> + * Controller uses TDH bits in register QUADSPI_FLSHCR.
> + * They need to be set in accordance with the DDR/SDR mode.
> + */
> +#define QUADSPI_QUIRK_USE_TDH_SETTING  BIT(5)
> +
>  struct fsl_qspi_devtype_data {
>         unsigned int rxfifo;
>         unsigned int txfifo;
> @@ -209,7 +220,8 @@ static const struct fsl_qspi_devtype_data imx7d_data =
=3D {
>         .rxfifo =3D SZ_128,
>         .txfifo =3D SZ_512,
>         .ahb_buf_size =3D SZ_1K,
> -       .quirks =3D QUADSPI_QUIRK_TKT253890 | QUADSPI_QUIRK_4X_INT_CLK,
> +       .quirks =3D QUADSPI_QUIRK_TKT253890 | QUADSPI_QUIRK_4X_INT_CLK |
> +                 QUADSPI_QUIRK_USE_TDH_SETTING,
>         .little_endian =3D true,
>  };
>=20
> @@ -217,7 +229,8 @@ static const struct fsl_qspi_devtype_data imx6ul_data=
 =3D {
>         .rxfifo =3D SZ_128,
>         .txfifo =3D SZ_512,
>         .ahb_buf_size =3D SZ_1K,
> -       .quirks =3D QUADSPI_QUIRK_TKT253890 | QUADSPI_QUIRK_4X_INT_CLK,
> +       .quirks =3D QUADSPI_QUIRK_TKT253890 | QUADSPI_QUIRK_4X_INT_CLK |
> +                 QUADSPI_QUIRK_USE_TDH_SETTING,
>         .little_endian =3D true,
>  };
>=20
> @@ -275,6 +288,11 @@ static inline int needs_amba_base_offset(struct fsl_=
qspi *q)
>         return !(q->devtype_data->quirks & QUADSPI_QUIRK_BASE_INTERNAL); =
 }
>=20
> +static inline int needs_tdh_setting(struct fsl_qspi *q) {
> +       return q->devtype_data->quirks & QUADSPI_QUIRK_USE_TDH_SETTING;
> +}
> +
>  /*
>   * An IC bug makes it necessary to rearrange the 32-bit data.
>   * Later chips, such as IMX6SLX, have fixed this bug.
> @@ -710,6 +728,16 @@ static int fsl_qspi_default_setup(struct fsl_qspi *q=
)
>         qspi_writel(q, QUADSPI_MCR_MDIS_MASK |
> QUADSPI_MCR_RESERVED_MASK,
>                     base + QUADSPI_MCR);
>=20
> +       /*
> +        * Previous boot stages (BootROM, bootloader) might have used DDR
> +        * mode and did not clear the TDH bits. As we currently use SDR m=
ode
> +        * only, clear the TDH bits if necessary.
> +        */
> +       if (needs_tdh_setting(q))
> +               qspi_writel(q, qspi_readl(q, base + QUADSPI_FLSHCR) &
> +                           ~QUADSPI_FLSHCR_TDH_MASK,
> +                           base + QUADSPI_FLSHCR);
> +
>         reg =3D qspi_readl(q, base + QUADSPI_SMPR);
>         qspi_writel(q, reg & ~(QUADSPI_SMPR_FSDLY_MASK
>                         | QUADSPI_SMPR_FSPHS_MASK
> --

Acked-by: Han Xu <han.xu@nxp.com>

> 2.17.1
