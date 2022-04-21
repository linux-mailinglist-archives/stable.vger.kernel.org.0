Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4745C50A00A
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 14:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383558AbiDUMyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 08:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356778AbiDUMyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 08:54:40 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2040.outbound.protection.outlook.com [40.107.22.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239A231DE6;
        Thu, 21 Apr 2022 05:51:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KElpgfQaHw6tu9+av/TYWmf5K0yxn130i4NMVVMmkMks5ZQEiz1kUznzrfawIBgTKKvUxi40v//4BXnC1hOrx80WUdO9a9C5XpElaIpZwylRglbiyLvVJYglrwUMn7fz0LPTJ+q3qebUk8zB6i/UKhOHRAK7LEag/lTh0rvz3O/m2PoaIai9xDfSV7StO4qiW7njukaSJCiB+MI3ETPkVZe1ZsMtlFrfXHsBe4sbQ1V4xvN70cPW5IcOeUfhB32j9uUUoricj9+LODd5DnATEZIHiMWAPNGHnTUEDWou1FGVDlWYq1oT255Zwz3qZN2Mf+l5uzftM1+NChKlhPRULg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f24lj0AwpP/hbI5KOhvg/vku+JNaSjGbzA8j+4LqvGI=;
 b=iWPoaOZRFdoD5VNGeoB7jAvO63+ReTMyyiuEEx4stU+uQbj86+inXm3VFf+Dx1SNggTdIRlMUQ8RVfkS/dC2qk/iTAP1cRDQsMiOrt6t5OWmrZezt3B4vWw0Zc6sWJUFcdbDe7QNrzVJE/x1kukYGZfM9hlmKY+xCie8hwiXolhJ9J9uh0p+R2wrCDDJNAUoayErZYnyfzfPKM/FOm4x+TWZHWkN+ZU/0VoaJwAgAYeGMvoQ9j8YsUu9Gss7dc8YL4/VivMI8dWb/NxhEoHjbW39pdL0ZVbSrslhgaj/5jbiVKcnNQLU73AYwQTOnzTgEyHTSzI3gHyQ943U/ZrbnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f24lj0AwpP/hbI5KOhvg/vku+JNaSjGbzA8j+4LqvGI=;
 b=VgXov8Sr0NSG/Mn1y2+zSG2Qe4UYmbxRVG/WziyOoKy255HLxsRnPonMYPKmUIvoBItyNLoSYVpln7cAXY0gotDicEEiZ3M37eVuIVJdXicaofIV2rWvo2TNJawqxVJe0SipOFnj6q/JylF5lK6QT5eq3gAD7z0ND3nPAiwJrF4=
Received: from AS8PR04MB8948.eurprd04.prod.outlook.com (2603:10a6:20b:42f::17)
 by PA4PR04MB9294.eurprd04.prod.outlook.com (2603:10a6:102:2a5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.25; Thu, 21 Apr
 2022 12:51:48 +0000
Received: from AS8PR04MB8948.eurprd04.prod.outlook.com
 ([fe80::5023:4927:e3ef:3c44]) by AS8PR04MB8948.eurprd04.prod.outlook.com
 ([fe80::5023:4927:e3ef:3c44%2]) with mapi id 15.20.5186.014; Thu, 21 Apr 2022
 12:51:48 +0000
From:   Vabhav Sharma <vabhav.sharma@nxp.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Fabio Estevam <festevam@gmail.com>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v5] crypto: caam - fix i.MX6SX entropy delay value
Thread-Topic: [PATCH v5] crypto: caam - fix i.MX6SX entropy delay value
Thread-Index: AQHYVK9m3zqP4sIQMUeYfZzjEtnCmaz6NsWggAAZwPA=
Date:   Thu, 21 Apr 2022 12:51:48 +0000
Message-ID: <AS8PR04MB8948CBB1A838399D6F4E2FD6F3F49@AS8PR04MB8948.eurprd04.prod.outlook.com>
References: <20220420120601.1015362-1-festevam@gmail.com>
 <HE1PR04MB29711AB352AE20A4A51B4C598EF49@HE1PR04MB2971.eurprd04.prod.outlook.com>
In-Reply-To: <HE1PR04MB29711AB352AE20A4A51B4C598EF49@HE1PR04MB2971.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77aa70e5-d043-4bb4-3f65-08da2395b30f
x-ms-traffictypediagnostic: PA4PR04MB9294:EE_
x-microsoft-antispam-prvs: <PA4PR04MB9294B3358899E16DA990AAA0F3F49@PA4PR04MB9294.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JL/HsdWUFmOt2SOUPopLIO4+rIMhxJ8tEhM8iMJ7ykGMZI/ERY+zP2vVw7+QiXSZgK/dp/IMoKyT3MiBXl9oJBh949a8n9CqZ5yi+qzSElvLlfNBlJdGOPt8q1RScY4rbls1gm4vgrat0ds6S3SmBI29zE2v6w+y5JqYg6ebwjiSa0SrUO7ljzxsgsGT0q0R//rLDiL5/dm8IsaRTMfV4dNacvjyf4d1X179aBY+hZLeivH0L6QIAD0eFOTO4WFtRMfE6CPo5fJwID23fKalevHvvfyRwIfdFnLyA6hmnAd1Bf7/zcXo1rEhyOLV5Pqi/yyQJDVo6PWyZjsXSNsxi/WTYpc+n1UzH34Ep71zGAibE5WoY0Acu2b32/knHMa9rGgrB5ImsU/LXSwnTOIWsZSUzyWDzEquKXN6oTkdtmUnsZL3GJ4UCTidNWmDWufaXFwBtCg5+JYOAGkU+QS9KQuEvObsTaz9NNswqbQm435f2z4kNXn4TCwpxHLQBJj4iKWKlMShOQES7vk/J0mhuP8oBtpFnjvEE/5/J9eMHS5nrwXpMNLn9BOVjJxVF2o3uTPV85zEvf0XpKDOY+46l66tKU1Kzt1DK9QxaNynZkb4WA4IlMiV9+RkbsasTeU+CUc2gI8XBapt7QqFOFAJk+1rphNFpN87UGH42G4LBhsKPBRL4MzEy2bNKc40rKdFiaSpZZD//vpmcNsW+19CwMKqLLUqjP2APbCOgRg521KJ7UtkomiIXQyDsOFsySXtBPCd2+jG89bpxlRmu7TA+EoB4fQRmZGyufHWJLDjZwU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8948.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(2906002)(7696005)(86362001)(83380400001)(966005)(53546011)(44832011)(55236004)(66446008)(26005)(9686003)(66476007)(64756008)(66946007)(316002)(38070700005)(71200400001)(76116006)(508600001)(6506007)(66556008)(110136005)(52536014)(122000001)(54906003)(8936002)(45080400002)(186003)(38100700002)(33656002)(55016003)(8676002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?4MnI91KlMFOcyCjmqboa/coMKJZtR0+V4s1u2AxH6EgRkqqznymAsx6X6P?=
 =?iso-8859-2?Q?+ETdja+/LpchZWnQ3spQ1+n36w6F766CNj6C/ly4O68l/Gph69Bx6O6dz+?=
 =?iso-8859-2?Q?o2yQiLVrgdQjBmKf60CPj34T4mDxtrEdB5XMRPIktb7vLvTLuO5hMrLt2v?=
 =?iso-8859-2?Q?9YwqjDgNPnbVhPbI6w3Z2kGhaqhSyDW5yPRyt4H5Jyf1DCU2UXNDUIiNLt?=
 =?iso-8859-2?Q?RT4a5Ss+hZv2ldpEKCbYRKHVZuhnQ/BACNB82Wdyo9LFduq1Y+nAnithIn?=
 =?iso-8859-2?Q?P8rNsn6r8d8o45uQOQwhObHhSPRuTRzffZUtQKSXKAvzU3UFgtSrZI57R4?=
 =?iso-8859-2?Q?cY0nGpJGKIUa/FegjsyiOUuYDMCvDVtztMYemxdOJgacwO4YuYtF0tMu4U?=
 =?iso-8859-2?Q?aexssJGeSjwnQZXsJ1myTjel3glelCKIDpoWHwhnLyonGgRhykAkqXUwuD?=
 =?iso-8859-2?Q?esu5GqOgI53hg/sczkCxsMC8tgfFzY4BuWdWgkdYFyGYwLJ8uUjevCSFXV?=
 =?iso-8859-2?Q?EIe9sNlCzFJjTELSveHarP+i4dhKvNXTADqcPvG6tcr7S6z7mdZrm1g7jA?=
 =?iso-8859-2?Q?p2gTW3XjTHkSATUnBg7y1w0nNnNOGw3vceWoQgvPXOZachD6CHHjDajZy/?=
 =?iso-8859-2?Q?Oe6UBivUVilcvkMLvwW1UxYv2QABANC0nxtpzmqpR7zGxBT2TdrPmgWRFx?=
 =?iso-8859-2?Q?UVVTASc8Hlm/+GsSnVbPl5asRuH98A1Yi1O1Og9hf6bhrnztXdD1YTag6y?=
 =?iso-8859-2?Q?1Tklsdw1aLRFJeOJvajVtnFYK19+i237I0lGQcWeWASq2TIEhKto2hD3fK?=
 =?iso-8859-2?Q?DzfL89dJfo0QoIXVBeRGLkhIMGqbUbDM08nlB1SRnc42L5pVPEmxbtjEE3?=
 =?iso-8859-2?Q?jUx8+cSun4ckTZYhYIn0pQpIc0/+deHsr61OGqFRUQW2GYkUWwLNi6Yp+h?=
 =?iso-8859-2?Q?4ITpQ9poHN9XGV26i1iaaDFgSsWqIuG/PHpJm9fw6kIkMp93Qeqz+E+LjM?=
 =?iso-8859-2?Q?6HxeS3qqt4L2+4oWtQgkKJT1+rCBFNefLQtspswJLGvXSjDYJJcG/13eYu?=
 =?iso-8859-2?Q?bROs1mixZN1w3RnAW4rsCZ57g3Wi1LTO5qaxsQx09lxI1/2C0gA0vw4Teq?=
 =?iso-8859-2?Q?qc3o6lf8dIDexOmB4aXC256glROE901/mBkH27Rlua3yPEQAiYqHvhtPsz?=
 =?iso-8859-2?Q?T25E7A0aK/qHpsoqsYlAZabzEABQQbD+2G2xtj2LL6opbwbSBCrjPcCpbn?=
 =?iso-8859-2?Q?P6RWv75A9yKy9rhpq4yBhU9JfHTbhrCyN/WIRDjfRI7XPlAxvrCf9edfRo?=
 =?iso-8859-2?Q?A5czQrd/tdx+snzNpthKZ6cByltujAHuDt/nj8iIgouOHYne9lVbb4brBb?=
 =?iso-8859-2?Q?aQ4evxGldcEgNc+rG+CGm/uBb3Jp4jnracTSEV6l4GLaltSwQ58WtFfHgB?=
 =?iso-8859-2?Q?7ZwEoJ5wrF8r6IqVbGw3IjEQTT3Kx/rYRNmT7vFqoENE5rcgTgfLAdEqIM?=
 =?iso-8859-2?Q?qnKAvkzul1HUBJDKuw6HgWA0vwdLw5EWmp11jo35DuruZqr+5+DjCaPQf/?=
 =?iso-8859-2?Q?gm26Fpg2znsp9iQVTQ4edK36TvKDH/u5rfi8+U8+1/czj9+3Ovxf9DmLOo?=
 =?iso-8859-2?Q?5RbDcs/I0KBBUzwvlUoY96TVFDsHwnt1NQHhim+igkcX039k76KkF3+LtF?=
 =?iso-8859-2?Q?eVsVBKRKZMcL8AhMSiwlZ7bP5DNxiBpNR61xuNKTny43jEjfQeK5pn/3gQ?=
 =?iso-8859-2?Q?D/fg6ZKIXbMmBdwqMMHFlYhybeiaAFaZtdE3plZrEaxOvvAiwrD/o2JvrF?=
 =?iso-8859-2?Q?UCZwvylIew=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8948.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77aa70e5-d043-4bb4-3f65-08da2395b30f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2022 12:51:48.7254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JQJPNbez1bXQcpEYQ9A+H6tcHvIMpAen7Q1b1eT9e9SWkcBfLwHQCIea2owIpdOsdFahU4uFPTx1nZceFGllLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9294
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Vabhav Sharma <vabhav.sharma@nxp.com>

> -----Original Message-----
> From: Fabio Estevam <festevam@gmail.com>
> Sent: Wednesday, April 20, 2022 5:36 PM
> To: herbert@gondor.apana.org.au
> Cc: Horia Geanta <horia.geanta@nxp.com>; Gaurav Jain
> <gaurav.jain@nxp.com>; Varun Sethi <V.Sethi@nxp.com>; linux-
> crypto@vger.kernel.org; Fabio Estevam <festevam@denx.de>;
> stable@vger.kernel.org
> Subject: [PATCH v5] crypto: caam - fix i.MX6SX entropy delay value
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
> gaurav.jain%40nxp.com%2F&amp;data=3D05%7C01%7Cmeenakshi.aggarwal%4
> 0nxp.com%7Caf57d0186dde479aa9cf08da22c687d0%7C686ea1d3bc2b4c6fa92
> cd99c5c301635%7C0%7C0%7C637860533324307730%7CUnknown%7CTWFpb
> GZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI
> 6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DUhqjgESpgMhOhJS%2BT4ghI6y
> NIvyybOI8yEv5%2FjKNcDE%3D&amp;reserved=3D0
>=20
> As explained in the U-Boot patch:
>=20
> "RNG self tests are run to determine the correct entropy delay.
> Such tests are executed with different voltages and temperatures to ident=
ify
> the worst case value for the entropy delay. For i.MX6SX, it was determine=
d
> that after adding a margin value of 1000 the minimum entropy delay should
> be at least 12000."
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: 358ba762d9f1 ("crypto: caam - enable prediction resistance in HRWN=
G")
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>
> ---
> Changes since v4:
> - Change the function name to needs_entropy_delay_adjustment() -
> Vabhav
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
> +	if (of_machine_is_compatible("fsl,imx6sx"))
> +		return true;
> +	return false;
> +}
> +
>  /* Probe routine for CAAM top (controller) level */  static int
> caam_probe(struct platform_device *pdev)  { @@ -855,6 +862,8 @@ static
> int caam_probe(struct platform_device *pdev)
>  			 * Also, if a handle was instantiated, do not change
>  			 * the TRNG parameters.
>  			 */
> +			if (needs_entropy_delay_adjustment())
> +				ent_delay =3D 12000;
>  			if (!(ctrlpriv->rng4_sh_init || inst_handles)) {
>  				dev_info(dev,
>  					 "Entropy delay =3D %u\n",
> @@ -871,6 +880,15 @@ static int caam_probe(struct platform_device *pdev)
>  			 */
>  			ret =3D instantiate_rng(dev, inst_handles,
>  					      gen_sk);
> +			/*
> +			 * Entropy delay is determined via TRNG
> characterization.
> +			 * TRNG characterization is run across different
> voltages
> +			 * and temperatures.
> +			 * If worst case value for ent_dly is identified,
> +			 * the loop can be skipped for that platform.
> +			 */
> +			if (needs_entropy_delay_adjustment())
> +				break;
>  			if (ret =3D=3D -EAGAIN)
>  				/*
>  				 * if here, the loop will rerun,
> --
> 2.25.1

