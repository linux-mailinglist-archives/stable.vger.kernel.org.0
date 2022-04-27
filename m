Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE38B5110DC
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 08:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358054AbiD0GJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 02:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357983AbiD0GIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 02:08:48 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2070.outbound.protection.outlook.com [40.107.104.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961902E9CE;
        Tue, 26 Apr 2022 23:05:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfapkodUkFIsJ45vouf3S7J8k8oi/ipI2Hx/E4Gf5+n0ObSWUCde+tmPVLa3QdN6O8D9fQ66TbE62aPZWYNQlX9ULIhKek7hXS0drk6dHaOUnsqsz/Sm6Iqw7vDraPzSjCzPWOlPl8BPUwWFwxFdwGIiIvEB2bjDCIq4TEOX7MOVJhQO4JliR6+ZGXoaMd+uoR/UHMEs/VfFgAyKa0xS+GpY1ncFAifuMSqoE2eUlyELZMoWA4TxrEges3CY5NW6yq5rzQwjkQLD6fRQh0IpmQyUliJAuvQVN5sW7dhCkurGIhgi9MTuMGGsQ4YWqBTYqSEoKXhJISiz2XRPkdbT+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uj3jddqsEEhrNu0MJV4BTOAwEFeCX/4OEgR7HNnOIFw=;
 b=W3uJRh4e4BmhjJwuLkhThU7at/oYS9a4d7rWL2A3jvEslT8YjVTttOwiYKDo3vioPrsB2dU8yhBv5ldLUbuBcTghuZdtFK7J+qWo0TDXBkP0BOZFNKNxEt8ourXQnRzr+1WP3cmlizeMf1EmqyXZsyfB0+5UisEEMaXY+TsLe6uH376d6k65bNPfccZZU2pY/bx6oHUyhQbUGD3baXOuna8r0ax+S999Y8STNWRBQx/BYurgomRJoSmn+2v1bjfE1Ni8G2rUlT6+5GB4NwIBmC9NU4hNVA7yVU10ubjhml7pU9hqPYzJDFtr9+DoR4H3vNX2vG9bKrOUTGZy6pnJGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uj3jddqsEEhrNu0MJV4BTOAwEFeCX/4OEgR7HNnOIFw=;
 b=Zi8EN9JcyQji0XtbUppZ7Rx//692wPEHW+jzBSJgzh6zEyHP+rQEQlZ1rXQEKpXk7GC4ulEOrx0SHbGo/+a7IS3GYnnGrFLPXqJUAuVs2wUaXm5mPNkl6V0h0qaAPJ/sRD5Z+LhaFRKxoyqeDblSjyqRFAJxoHi1oOJkZ78+OYc=
Received: from VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16)
 by DB9PR04MB9474.eurprd04.prod.outlook.com (2603:10a6:10:368::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Wed, 27 Apr
 2022 06:05:34 +0000
Received: from VI1PR04MB5342.eurprd04.prod.outlook.com
 ([fe80::c587:139c:5129:6d02]) by VI1PR04MB5342.eurprd04.prod.outlook.com
 ([fe80::c587:139c:5129:6d02%7]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 06:05:34 +0000
From:   Gaurav Jain <gaurav.jain@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Horia Geanta <horia.geanta@nxp.com>, Varun Sethi <V.Sethi@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [EXT] [PATCH v5] crypto: caam - fix i.MX6SX entropy delay value
Thread-Topic: [EXT] [PATCH v5] crypto: caam - fix i.MX6SX entropy delay value
Thread-Index: AQHYVK8LYCW3iW5VH0qQv7JnGk4nDK0DT/Iw
Date:   Wed, 27 Apr 2022 06:05:34 +0000
Message-ID: <VI1PR04MB534277533EFD2F2C6AD32C81E7FA9@VI1PR04MB5342.eurprd04.prod.outlook.com>
References: <20220420120601.1015362-1-festevam@gmail.com>
In-Reply-To: <20220420120601.1015362-1-festevam@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3a34898-87f5-4533-2031-08da2813f144
x-ms-traffictypediagnostic: DB9PR04MB9474:EE_
x-microsoft-antispam-prvs: <DB9PR04MB94747A3C649DE3485782B24AE7FA9@DB9PR04MB9474.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e/wGessfFOnvAosbo15sQDPlNZzLE+utTNY/SkUBfp2jor+xBd1dnJdaKvLFHrI9MiAVDKPlxmsNCU4u4THEGxwc0AUNXChREXSp4WGDa0g9BdrG32NroIXvwCiyeLOn8KtWI2F7k1Hzmco0fzu61WPzwin+YPG9/ZqfDbJ11a7Vmu+fMciBmFZU2FsrzSoxLdAF6EfbAPgQ4+qlg9fLAllbjyIR3LMbj+hksHLtxG597yG661eZBSNp0deP3LSOEBdIeTyTOUCjJQkYLIoIRvoVUthtwQCDtDPnTbr5CRswW9pdlErXKpHusXHgxkKCCLW7svJiKnvdWou0RVxLQSGzdwpVXUrbMWyURXPNin1W2jIzofa9Tov6jNDp/j3wcvSZ9k++CHYr5uoRrsU+j0o2cB96ZUyRt28IJl/1p62hLUBrcKGfQ3gYHt2gZ6/4cRPZ9X0yofwT366OgiFUR3ygu3SkR0aHkYALABzLasQY+v4L0gc87a/2cesi319I/p4XanbfPByphtjzX6RhjIOo9YFqwBpO6Z5KRE9an5gTPMkW1i0V2zVMYVSO0lVeNH/k0pel0yjiX62rXLoOReW7ox/FjIFEoYVt0x+/fbiSWRWclD8Up4f3WBV1XCj/Ghx6EbHfR98mcWbZa1DX2nw1dv8Zbiwer/twqpD/ISlepci0GIODRQ4gdueVhNgxGaT60v0o/qMxK16UIZiX489G0ML5glEZKJDxUHbaDqndCQIut44rM5SZS2gDtiJrDDu+ozEx47sGB3/bkGdVN3lx8gP/vYJgJmlTcCfJPps=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5342.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(45080400002)(86362001)(508600001)(83380400001)(71200400001)(38100700002)(966005)(55236004)(316002)(186003)(54906003)(55016003)(110136005)(8936002)(122000001)(7696005)(6506007)(5660300002)(26005)(44832011)(52536014)(8676002)(33656002)(4326008)(2906002)(9686003)(38070700005)(53546011)(66556008)(76116006)(66476007)(64756008)(66446008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?T6fddDneO9gKRi3Ia+EEtzm+Gbm3/4o8AlKyoFoSWLZh7ILwVjyj8w9Di7?=
 =?iso-8859-2?Q?Oex3/LWsD2LTXQm3ygP64ny64a+S3rgM5jkwyFTB4BycHjix/DjU+Y45GP?=
 =?iso-8859-2?Q?sZiLCh5C10aRJW2qH4rOhQqbszoGvZhGM+xQ5A51A/bs6P6WiP77Hxy/IM?=
 =?iso-8859-2?Q?DKhHzxWle48126VvtNv+KsJLz5lbveWXf1y3oDSkow0sxX3J/TxeA2luDh?=
 =?iso-8859-2?Q?PdybFSwGv5fuV5Tl1EUiwIypz4YHA5XepoziBO+0iAb2yBkIo19QkU5Hc7?=
 =?iso-8859-2?Q?fBMgp0/xg6WAaiFCrkKVmxyMUfbEUgGp4QvIpEuewB4win+RefMJGzUlP4?=
 =?iso-8859-2?Q?ewYS2tnU/6hsZIv2S6Gq5eP9Bqnk5/QAN4TnOuqNvhOB7lnBNsRYi29kYr?=
 =?iso-8859-2?Q?jx7KjnAXGOX0PrJkxcS9GcwraL41qA3+vjDrrLDc1HF9rjoP2EQaumIwIK?=
 =?iso-8859-2?Q?Ql49GF0pAdl4MP/whs25+L+kekQMwXHXTX05Pg9PA0xZ5W2Ila3iGbcSrN?=
 =?iso-8859-2?Q?CONoKN/m4+LOxQWQv5GkL7XFq36ead1/Yhum1Dar9LJiucFEh05eiA1ZIt?=
 =?iso-8859-2?Q?XClOWlr2HU7oQZDPzdCq6jDcDV/UQFX1h8SurUxD5RFmjQrASW/T8wJ34f?=
 =?iso-8859-2?Q?2q3rahwmV/fPgtLrHZwMCOjU4NLxh8b7H8AC5cPvkLWSf0h2gruJXtnxOS?=
 =?iso-8859-2?Q?X/M+VCwBj4HMZnzbNXdsxqUn5HpoCCfeFaipDmQgS+eWeoonTX7Om2g+oh?=
 =?iso-8859-2?Q?Dh5zfF9q8Qu4iYCS7OyP11nNQgi49kWC4anW99H9ezmIokYxA5i2y+AeV9?=
 =?iso-8859-2?Q?2jQNVUGq3mbVYjRvLWaTBzBDwBiUoyFoNXPRSFsH7kyFTj4yaRu43PbMl0?=
 =?iso-8859-2?Q?ATmhrg0ipjdfSpyKcGl27LxyyrKKv/8wO6xaS/7F1ztqVv5oIUB2iE7LB+?=
 =?iso-8859-2?Q?xtYgMXC5DNyX6F5VKwLSUgJRw3b9nDk9S5yjJOZy0Fb9od8JJ38MLPi/yf?=
 =?iso-8859-2?Q?gUJE6KGXFh+7eUefH33qbcY2TDVPRXIDhrgkcVPAibf6fHVIq4bqpFOSuB?=
 =?iso-8859-2?Q?qpGhwCP2ta2smyFnDayEjwfGmAvnGiGMZYI1lGMdV1c3BhmvNDVtW2Hprg?=
 =?iso-8859-2?Q?+yYukQz0xdNE7yD9n+qbRZh5gYyP9bH6wgGIV37kqq+Nzluwh1dxZQUKtL?=
 =?iso-8859-2?Q?HV1ZWaQ1iEcrj4+TY8QG0+eeVHt1ovQObOM/eVj9LIennC8tpKCE6xVPXv?=
 =?iso-8859-2?Q?sihNfZ6yko6sM0a3TB2zFSifzRlRUPCpc21RvilbyeFjptTppZ/StPqzEo?=
 =?iso-8859-2?Q?LHyPcpEgjd/74VyVlPRahrt/xENwle6YfQigy8eb3OlnMaNPjlA90fzTnG?=
 =?iso-8859-2?Q?qpuPYVZOx0BQKPNM3uFUSjE42+pg5OEb8SI6P4/hY1z5wFucaljCTFlajY?=
 =?iso-8859-2?Q?EEhJr/y5R+HVRwKQeUFNICg0iN2eDIq4WjSQ/4E4mRtkYPTJXG2ch3KO+V?=
 =?iso-8859-2?Q?Fipw2PxS+EEM0U77SxUn5lZe+UIfwIgzp9Y5OR3cV04IxkdZkNF6T92buB?=
 =?iso-8859-2?Q?ZrRDyWkiw+hMl0Kt11gi7uyVtcP8+i+ptH/RKARNsyqwZPnw3k0lraouGn?=
 =?iso-8859-2?Q?lVChWOuh/vU5m/NSefpv20jlueZIfZqCjO05F9ciu8x9eDxG8Qu26q2NX2?=
 =?iso-8859-2?Q?hN6n613XSgFA2FZzMyXQr9jew2bABze9ny93pAr7iThVQ6lI64XNHAKKvw?=
 =?iso-8859-2?Q?Kd1c6aCTOVnnFKwTd0YVl4xTGS0OBKRlMZ+6oImQPLPLsqq4UgyoIGRwt8?=
 =?iso-8859-2?Q?0FS+GjHp0w=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5342.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a34898-87f5-4533-2031-08da2813f144
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2022 06:05:34.3453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kBm2nfVTw8zm+T92slKJOSEBF27kTQrUgJoEL+usIxG9TKk/GE2ma4QLpz3xwDkodGhacQu6xW9tmy4RSkR93g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9474
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Gaurav Jain <gaurav.jain@nxp.com>

> -----Original Message-----
> From: Fabio Estevam <festevam@gmail.com>
> Sent: Wednesday, April 20, 2022 5:36 PM
> To: herbert@gondor.apana.org.au
> Cc: Horia Geanta <horia.geanta@nxp.com>; Gaurav Jain
> <gaurav.jain@nxp.com>; Varun Sethi <V.Sethi@nxp.com>; linux-
> crypto@vger.kernel.org; Fabio Estevam <festevam@denx.de>;
> stable@vger.kernel.org
> Subject: [EXT] [PATCH v5] crypto: caam - fix i.MX6SX entropy delay value
>=20
> Caution: EXT Email
>=20
> From: Fabio Estevam <festevam@denx.de>
>=20
> Since commit 358ba762d9f1 ("crypto: caam - enable prediction resistance i=
n
> HRWNG") the following CAAM errors can be seen on i.MX6SX:
>=20
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> hwrng: no data available
>=20
> This error is due to an incorrect entropy delay for i.MX6SX.
>=20
> Fix it by increasing the minimum entropy delay for i.MX6SX as done in U-B=
oot:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpatch=
wo
> rk.ozlabs.org%2Fproject%2Fuboot%2Fpatch%2F20220415111049.2565744-1-
> gaurav.jain%40nxp.com%2F&amp;data=3D05%7C01%7Cgaurav.jain%40nxp.com%
> 7Cc2f2316c0db64170b59e08da22c62c4d%7C686ea1d3bc2b4c6fa92cd99c5c301
> 635%7C0%7C0%7C637860531804367821%7CUnknown%7CTWFpbGZsb3d8eyJ
> WIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C
> 3000%7C%7C%7C&amp;sdata=3DOTgUAquesUW39%2F0bhSnXHDe4UpCU8dQN%
> 2B7P0hlE6oiE%3D&amp;reserved=3D0
>=20
> As explained in the U-Boot patch:
>=20
> "RNG self tests are run to determine the correct entropy delay.
> Such tests are executed with different voltages and temperatures to ident=
ify the
> worst case value for the entropy delay. For i.MX6SX, it was determined th=
at
> after adding a margin value of 1000 the minimum entropy delay should be a=
t
> least 12000."
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: 358ba762d9f1 ("crypto: caam - enable prediction resistance in HRWN=
G")
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>
> ---
> Changes since v4:
> - Change the function name to needs_entropy_delay_adjustment() - Vabhav
> - Improve the commit log by adding the explanation from the U-Boot patch =
-
> Vabhav
>=20
>  drivers/crypto/caam/ctrl.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c inde=
x
> ca0361b2dbb0..f87aa2169e5f 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -609,6 +609,13 @@ static bool check_version(struct fsl_mc_version
> *mc_version, u32 major,  }  #endif
>=20
> +static bool needs_entropy_delay_adjustment(void)
> +{
> +       if (of_machine_is_compatible("fsl,imx6sx"))
> +               return true;
> +       return false;
> +}
> +
>  /* Probe routine for CAAM top (controller) level */  static int caam_pro=
be(struct
> platform_device *pdev)  { @@ -855,6 +862,8 @@ static int caam_probe(struc=
t
> platform_device *pdev)
>                          * Also, if a handle was instantiated, do not cha=
nge
>                          * the TRNG parameters.
>                          */
> +                       if (needs_entropy_delay_adjustment())
> +                               ent_delay =3D 12000;
>                         if (!(ctrlpriv->rng4_sh_init || inst_handles)) {
>                                 dev_info(dev,
>                                          "Entropy delay =3D %u\n", @@ -87=
1,6 +880,15 @@ static
> int caam_probe(struct platform_device *pdev)
>                          */
>                         ret =3D instantiate_rng(dev, inst_handles,
>                                               gen_sk);
> +                       /*
> +                        * Entropy delay is determined via TRNG character=
ization.
> +                        * TRNG characterization is run across different =
voltages
> +                        * and temperatures.
> +                        * If worst case value for ent_dly is identified,
> +                        * the loop can be skipped for that platform.
> +                        */
> +                       if (needs_entropy_delay_adjustment())
> +                               break;
>                         if (ret =3D=3D -EAGAIN)
>                                 /*
>                                  * if here, the loop will rerun,
> --
> 2.25.1

