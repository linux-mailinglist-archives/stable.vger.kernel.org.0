Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2010050871E
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 13:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiDTLhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 07:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbiDTLhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 07:37:18 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130078.outbound.protection.outlook.com [40.107.13.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD78419B8;
        Wed, 20 Apr 2022 04:34:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1z8FmpOGYr5o4UEVD+FfEvkxUTz0QQ70MMgvkXILN5v1DlmUWN0bjNZ53TAVjfm3lxXws8FpgsZRx2rKZXpCwzM2r94kzZkZOs4uxWcqsVmNSg76tm+bRBmw0PK2m8HYSelPyQjWVZ/QqgzWIX5Z8d6mukz1LZSj/qZ1INSinK68k7rwFbMmAQ1wjJuspAEWOz/SR+OBxcPOh5j0uDAdSWp/gqEuatSdzd62vJDRej1BujiMsHXQNT/D4COYrlQtABpYxrJky9eUg4KxWYbocpQ3EmmfzDHCKAi5Qyzn9cHSVObrp6thpb1zHSz+b2U4LeZC8BF6f75tMl7Ma73PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9R0dl68rCIA+3vm4LU/Z4NJWmlmJxVLoiOZJbJBF2kw=;
 b=B4GqlTQmSshTCxojCxXinGWG5GheC9nFrpoqC52TMm23IntS3TzjuZWnRx1QtM41i6PkkO5rIFtKNBpwWi9gXnia6NZVP0cRp018sKEsnagJHU9JXusVOY7onPrKd0TyZA0zksBgUpbTKM1HSdrggDpBugnWx/wre7AGHTaSImW96jLWZURWriNZ+1Nv605wk+5f5puXdhs7NU52N0oA+SRtE82twmxzHHA6Mc5NTP0097uGrdvXpqeuFqoKA+oGzMRKGaGr5p9YUHAN9igMLeXG3mek2yP1Hxrobx2pMOVHAGblf4zWnaq6SyrveSZov3Gb1nS/ceG19LjeI5Xjmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9R0dl68rCIA+3vm4LU/Z4NJWmlmJxVLoiOZJbJBF2kw=;
 b=KvtANCuLuXuqWND5CIwqLHNO3HVL6utokIo82ukPW3btsNOpHMz276aVgUn4bjjWIoCNuSQhAGOF7KV6bIQODd/c+2pFktbE8rxKRBUjmClDgrS4rr4xCURZ5NbBSKGwzPh+rza7Wa/3As+6hG0emGPtE3ph7VaRwM27UiyLhO0=
Received: from AS8PR04MB8948.eurprd04.prod.outlook.com (2603:10a6:20b:42f::17)
 by AM0PR0402MB3362.eurprd04.prod.outlook.com (2603:10a6:208:26::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 11:34:28 +0000
Received: from AS8PR04MB8948.eurprd04.prod.outlook.com
 ([fe80::5023:4927:e3ef:3c44]) by AS8PR04MB8948.eurprd04.prod.outlook.com
 ([fe80::5023:4927:e3ef:3c44%2]) with mapi id 15.20.5186.014; Wed, 20 Apr 2022
 11:34:28 +0000
From:   Vabhav Sharma <vabhav.sharma@nxp.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Fabio Estevam <festevam@gmail.com>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [EXT] [PATCH v4] crypto: caam - fix i.MX6SX entropy delay value
Thread-Topic: [EXT] [PATCH v4] crypto: caam - fix i.MX6SX entropy delay value
Thread-Index: AQHYU+LsYV+G5+/ss0KzziVmGUYIJqz4PoFQgABfLYA=
Date:   Wed, 20 Apr 2022 11:34:28 +0000
Message-ID: <AS8PR04MB8948B99965ECED11AEE35D2FF3F59@AS8PR04MB8948.eurprd04.prod.outlook.com>
References: <20220419114444.586113-1-festevam@gmail.com>
 <VI1PR04MB5342FB22BDAF3163C7C8ECD9E7F59@VI1PR04MB5342.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB5342FB22BDAF3163C7C8ECD9E7F59@VI1PR04MB5342.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 394a0f1d-b86e-413a-9677-08da22c1baf1
x-ms-traffictypediagnostic: AM0PR0402MB3362:EE_
x-microsoft-antispam-prvs: <AM0PR0402MB33624D2145C6C793B866ECF6F3F59@AM0PR0402MB3362.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /DpTLOvtQY37H/cnhi4d526MwZLAH/xomHxjcV/m57bnV0dBa7w1kbZG7yerCO5y+f004gbNpzbu36surSdrohghZRfwqwPl/wb+RgDX+UI9cw1BwIwY63iud6hPlyv6kxvefwI1XRjwu54BUG2XT9p0BTEMhe9grRxVAUiNmkUWydhhvWiOy8kT8YmpFjJeJdJNjn8IoaHuHqTeE85jQdDgAiDsF5ttkVg1E9F4IFuZ2BJHHoND0W6FYo3qKYY0yq+IlMwQ2Os5lHJ/WRIpp81cIZe7q80onmjZ8Ey086eo+3lZgnPW08EGW0+8io9P1zbyXSJLLTKTtxlBgtt/pKU2jtnDLcBp+jK130S0Zqv1L/evEkU2uDVOn3Z3sjxqDRXSyEZvhMAKeMcOsSrL8/7SahUZ8UlGaCQ96B8KrUh6ofNiXPyfTc0UbMK6ZFruJKzrWgBg0uh5VTuqHqVvo33+B2KQ7WtkmkZBuhEOnB6MJ2YJ+ZjDCM86qjPiZLu03OO4aRbWlKxQNDA3K6TDAboRztGNodydi0AA3vCTVegC77CBLQXt7szQIwcPDGouKEIbkl2s11tYesjvPg4FEvWiptRuXXYkfDL4HGvKbKWx5oQ9V9FNx4L/6Gal2i+QzlW5s4eQiZwF66G2KGGYVNzWOl37u+PI6dpkfxJ11/sTKSZbC99TxeHEOyFzWRMRSO/O7hGKTwOr4OCLoH6IEJf3VELWxkZYChFFdqPgM11yFK0vihrB4u3sxyU6vWfijv/SAM3gGYi1WCkl1OSPj3KUJ5dDCSCQufZ1q1x8Vic=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8948.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(6506007)(38100700002)(966005)(122000001)(45080400002)(71200400001)(26005)(7696005)(508600001)(186003)(33656002)(2906002)(316002)(5660300002)(53546011)(83380400001)(86362001)(9686003)(55236004)(54906003)(38070700005)(44832011)(8676002)(66446008)(52536014)(8936002)(55016003)(4326008)(66946007)(76116006)(64756008)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gzle7OtJ8n7QzEzbi1loKhgvb+zncEwt99V+DnYVcqs+GhHyDsys1j072ezH?=
 =?us-ascii?Q?JN8WfuyrnwrKPN3dtSb3v5mqcEfYRTkPQKSFe4GEwu+YjzUdoom5KwzmJCHF?=
 =?us-ascii?Q?TgrxlQoGSnXFjYLCRxuL4y/79oQEhZjjvzZeZF/onijWMRYVcdeJ3JKeZ4gp?=
 =?us-ascii?Q?vqQcyLgSEbVAQ2vUlNAv197+2X7+pB7b3iTJ/haj/lL0VYoA7h6mZ/SMa8+0?=
 =?us-ascii?Q?I8MWaqFzROCqkGBuM0UcwhAdlsZjmdX01cgAK9P9PLGSldiojXXnDXdUlPdF?=
 =?us-ascii?Q?qnw5DaFKHDtHPwSDqsLwa5QriwWMrpFFVT+G1N2vyubMNMdAdiiVssFfX7LO?=
 =?us-ascii?Q?6D/vTgKN97N+DO15175JDuiUCWNFuKrw65yo8E/ElfI+dHkAbfQiD7jMYLYK?=
 =?us-ascii?Q?rf0rqt8uVbmjrVYixbBOLTQp+gfr642S6MTfe4R6GhEMIm6u5bFicBljESyE?=
 =?us-ascii?Q?c3AXHPySxmIUECPvoOydMlwhb12YyvRDrApyidBjPVOci8XmY/3ZLZeS/bGS?=
 =?us-ascii?Q?ZywOaUUcyDWAKaBB9ztnKFn1TRwiQORLD0/pgHr5pppE5WJJDb5Qgw8v7Yk4?=
 =?us-ascii?Q?1HUuAOu3QBwB5mVLvoS49fRB5qc7b5pECX0lNzPMYy6ngF4Y5azbnca4JHpA?=
 =?us-ascii?Q?k7FW/9UJ5/BRBiGP/+UGkdQ2YycaXo12JIx8O1K8h61Hz/uKhPCEdjL5ZU8h?=
 =?us-ascii?Q?WvX/m/Qdm1jzNOqWIxWyZjlc3ZRE19MrphGZZa9YwlFCc6adEKE0W8xsDlMa?=
 =?us-ascii?Q?kMKBmSHcwvonA3Ri4Kzki5BnuuMgBzTk9QvrQ6nTwVvQOxzzGzHzppLLGI11?=
 =?us-ascii?Q?1Tt3d3qYREzlodQzMiD8L096H7squCEY8p4N/7bzFqRxAV0TtNGuouV4/2Ha?=
 =?us-ascii?Q?IWSrSqzGLkh+WvllAnpb8rEg2lNoYyhXJGnddrHILWLL1cUEdCukKEATAwu1?=
 =?us-ascii?Q?yCXoEo6RLXzHoOuQ0UTHvwORz9JRYfpLVbHmvi82DuCry0c+stUNm0Z5dfnN?=
 =?us-ascii?Q?5cCVY/zoSrenzHe2Grbc8UFc+SEVLzyTLoI09lZ2KTgS8I5a59CsXoEJld6G?=
 =?us-ascii?Q?KmWcFYXc9WRJZCLszAYiBvP+4uE4LZt+Y1SBZtH4AGaE78JjJloQt7SizlVZ?=
 =?us-ascii?Q?TJiKSsmsFz+fMarxzVyMEjSIXFvsM2ZFxmFW0/16az21RJkTRrepBzro5CqH?=
 =?us-ascii?Q?CFjMoujXphEijXon7NTn8Cw4LpzyLdJoDDLCTHagZCsSR02/ODSRejfAJxqR?=
 =?us-ascii?Q?7HH0ySE1zhtuoRuras9Yo8szz1X1fVKOJNzpbvkb39ii1w/3YQROOyFn1t+4?=
 =?us-ascii?Q?wfWb/9CzF6CHYwREuMDXuOcDM9Hj5I5b8brjGoSrUrdxQ2MvThclYOWUlWaV?=
 =?us-ascii?Q?4DflpdG6tnujebdHxH92ySejIQnc/0FfQ+ik0V0x5rHVHBdac499D5Se0wMF?=
 =?us-ascii?Q?nSTwR7F/lZrOjCg3sFobFukuJtb/RGUhg50zPSpjqv6CyPcrcmW5RGxIAFZe?=
 =?us-ascii?Q?rdmPpHfMfru/l+IdMjEmgjICX18f8Nz+b8zwyPoPp/J5qXKOCQ05jmfpmq/u?=
 =?us-ascii?Q?QfOFIfESXsJ5Hq/8KIENuuWQf8ngXPX0lr4wTm3nP7UP8/FyTCrmLD8fB6sd?=
 =?us-ascii?Q?4yhfQ08Eq5UKUU9f9zz7/zbkWcwYC/qU+PSCFSKLZh7BJiTgaeIYqLpxHuM0?=
 =?us-ascii?Q?Dl2SYr5BQEG/vyqomv7ms8jGdJi+01j+OnRiFZpF1NoaKlrJ5HRi1os2CZpW?=
 =?us-ascii?Q?W8xpp3+dxA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8948.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 394a0f1d-b86e-413a-9677-08da22c1baf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 11:34:28.6461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KS5T0QwFSOnqZkg+fWr5zeMCSoADLX+9jLCe4qjIeO+5PdDnJrCOa6IwSorPv2ld7azvJ2bxFtrvc2Fj3ID98Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3362
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Fabio Estevam <festevam@gmail.com>
> Sent: Tuesday, April 19, 2022 5:15 PM
> To: herbert@gondor.apana.org.au
> Cc: Horia Geanta <horia.geanta@nxp.com>; Gaurav Jain
> <gaurav.jain@nxp.com>; Varun Sethi <V.Sethi@nxp.com>; linux-
> crypto@vger.kernel.org; Fabio Estevam <festevam@denx.de>;
> stable@vger.kernel.org
> Subject: [EXT] [PATCH v4] crypto: caam - fix i.MX6SX entropy delay value
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
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpatch
> work.ozlabs.org%2Fproject%2Fuboot%2Fpatch%2F20220415111049.2565744-
> 1-
> gaurav.jain%40nxp.com%2F&amp;data=3D05%7C01%7Cgaurav.jain%40nxp.co
> m%7C9016fe4b6bb8402de08f08da21fa0703%7C686ea1d3bc2b4c6fa92cd99c5c
> 301635%7C0%7C0%7C637859655100732358%7CUnknown%7CTWFpbGZsb3d8
> eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
> D%7C3000%7C%7C%7C&amp;sdata=3DwglpvZBmQUKn7sLRx5xpdwdgFMOc6LE
> qIMqUU0h4UZE%3D&amp;reserved=3D0
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: 358ba762d9f1 ("crypto: caam - enable prediction resistance in HRWN=
G")
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> ---
> Changes since v3:
> - Add a needs_extended_entropy_delay() function
> - Assign the 'ent_delay' inside the the RNG initialization area. (Horia)
> - Change the terminology as per Horia's explanation.
>=20
>  drivers/crypto/caam/ctrl.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c inde=
x
> ca0361b2dbb0..5b989a842ee9 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -609,6 +609,13 @@ static bool check_version(struct fsl_mc_version
> *mc_version, u32 major,  }  #endif
>=20
> +static bool needs_extended_entropy_delay(void)
> +{
> +       if (of_machine_is_compatible("fsl,imx6sx"))
> +               return true;
> +       return false;
> +}
> +
>  /* Probe routine for CAAM top (controller) level */  static int
> caam_probe(struct platform_device *pdev)  { @@ -855,6 +862,8 @@ static
> int caam_probe(struct platform_device *pdev)
>                          * Also, if a handle was instantiated, do not cha=
nge
>                          * the TRNG parameters.
>                          */
> +                       if (needs_extended_entropy_delay())
> +                               ent_delay =3D 12000;
>                         if (!(ctrlpriv->rng4_sh_init || inst_handles)) {
Please note if TRNG state handles are already instantiated e.g. by U-Boot b=
ootloader, It is assumed that entropy is set correctly and kick_trng() will=
 be skipped
Kindly pick the U-Boot changes as detailed in commit message.
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
> +                       if (needs_extended_entropy_delay())
There is nothing like extended entropy delay and function name seems to be =
incorrect, The software test were run offline across ranges of temperature,=
 voltage and process to determine the correct entropy delay.
However, value of 12000 is determined by running said test across voltage a=
nd temperature only for iMX6SX.
> +                               break;
>                         if (ret =3D=3D -EAGAIN)
>                                 /*
>                                  * if here, the loop will rerun,
> --
> 2.25.1

