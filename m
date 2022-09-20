Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBCA5BD934
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 03:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiITBLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 21:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiITBLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 21:11:31 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140083.outbound.protection.outlook.com [40.107.14.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBD352FF7;
        Mon, 19 Sep 2022 18:10:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6WcWTzNlVERUt82hW5GsEYfAIM4PyboTjZQh/MKb/Oqj5BK6o9y1P0GSATzPRb9fubMaJhvwjS1qJse8BrSHx6+V5eSWL7t5ZQtsSBA3B/6D3bWHckQ8CEQe4TEHGvOR2KoKT1IN4JO9MwlDqVWyjq8jFjlPljSiu70CXuQm7qV2wEWKhrwDEc3uG7KJ+zG3w70HzuvwepEjEgHCeXOOOd99s6ndIj3nAYH5A4f8pRq61I6YlI8WVnDFNHtRkMj6N7GupYOZBsz8N6n6O5xjPQ79pn9Pd/j/XkzjnyDVehT8sinUG6mKA4CVaniyKwj+enGJzw6xHh2YlgM3A70Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFUOfM7M5eHiwg+MUqf0WAu35sW6vkZJDFaiUQmHRYM=;
 b=POAS7RBf9eg00x0yVGtR3aADQ9VRb6M2kjfiKskmJTHffQKRLh1mFwCZXBA7pzcQ/l8QcqryUuxBnOzSVCPOpomiDOzCtSDoNgq+82Y/EjTbsO8u4pBFxzJbIJB8PcvkAzpMZZbmV+AR3VxxHry0Y5kD3VHIs/FQRhkHj4fR3ONsyqAd1kGWwa1M626aZPRGulPcWqEOehifOifeI/m69gMbB0dlSfVOE3MwDwjP9Cjapbv+dutv/h28rf+tkjQbicPQjllIxTCoAdwStIwZltsOLPWEch4dQ42ogZfVMUSJS1nyWejWvt0HoGKL8RibncVRfMaK/20qce0yA+jL+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFUOfM7M5eHiwg+MUqf0WAu35sW6vkZJDFaiUQmHRYM=;
 b=pmecf3pyH0kMNnY4yQiLYn2hX+IW5ARr4lrivNAPPRjMFaauNexoCeCk79g/qkZculH/f2PE2K7iMIAFLoMzimXC6MSfLN50vMLstZN8x/TuLVdvnirs4bPsqBn/Mvvr99S/bUctSbSa++78zX/rKh/0eghMMeaLEzDXTDP9u9Y=
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DBAPR04MB7448.eurprd04.prod.outlook.com (2603:10a6:10:1a6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 01:10:34 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::1eb:dcf:8fd7:867]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::1eb:dcf:8fd7:867%5]) with mapi id 15.20.5632.018; Tue, 20 Sep 2022
 01:10:34 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Dien Pham <dien.pham.ry@renesas.com>,
        Gaku Inami <gaku.inami.xh@renesas.com>,
        Nicolas Pitre <npitre@baylibre.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] Revert "firmware: arm_scmi: Add clock management to the
 SCMI power domain"
Thread-Topic: [PATCH] Revert "firmware: arm_scmi: Add clock management to the
 SCMI power domain"
Thread-Index: AQHYzCJH938Lnv+sGUKY2h9ELO/QXq3ngw9A
Date:   Tue, 20 Sep 2022 01:10:34 +0000
Message-ID: <DU0PR04MB9417DDE0914ECA41B3800511884C9@DU0PR04MB9417.eurprd04.prod.outlook.com>
References: <20220919122033.86126-1-ulf.hansson@linaro.org>
In-Reply-To: <20220919122033.86126-1-ulf.hansson@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR04MB9417:EE_|DBAPR04MB7448:EE_
x-ms-office365-filtering-correlation-id: ae8bfef5-e6be-4b87-fa1b-08da9aa4ebb3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sGiuMwsswTphOEz2h7hFdDrLRD1wWli2e1Z0KMsLaJzKLkfm6DKvzVAZOJDmJruvM3L22TXDE2yoxZbwgqyOrzrfPxhb0QBb9QLJqGpRUJ8i3nN11xAiZZcmvJ6QFW/j+nxh+jXcqk3QQJ9SavUj4CNZCkj6+hCz9QbNI/oTuhIx4wifO2DE+jCPs7k8zFT05V2tCIybU2fQCYDvqdGn6pFuJjZaURpNegh1SoNnxBgTsBqU1qMULqu/7JcUqjf5XTHUca5rCHvxNzvmFB1616f7sxbCJglgHkIaTLh9nN2w5hdlGBksoCOLoRtk66dYknmTNcbHzyU2blqY/UrfvoIsLaE2F5zSi5e9XBXi9cIvGcSOgHjzVmy8TBprFTrzcGs+Jrp9sjTci0EHocEReMV7AWDUXsnIio4n1Ek4Ad1DJ74SFcicrGPXCjFqz6hMb/OWedbrFnTV/AeiCKfNDhPTXG7MXchDTmU0psIAsGG20yOAqlhhwImTuZ94KDxfEKOoXPFi3oINOGYSQJSUqqE+JqMq+bDGXuiIqmOYxdjDb+6/nyA3qv39RtwJFRec71A9TX1DFCdof9OfFzxk0sMSpvmwUj47Somrsiw6/PN2Qg5dze885qqmPxZ77pQ95Kq5xHtOmCkFve8UcPe4iRMaP0C2wyNHaSF3oR0QO34Hqg6emXCvOKcUORhuKKSo7+rFoKXkJeVuXJU5KCIMma0AQkOpo11rcYboRWtYiJz70iDqodSkjP71jv5EXMn4x0dlfLjQYPgiO4HaimN+JqOrmdtpcx8B7qH6thdsxq8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199015)(66556008)(5660300002)(66946007)(64756008)(4326008)(66476007)(7416002)(66446008)(76116006)(54906003)(110136005)(86362001)(8936002)(45080400002)(316002)(33656002)(122000001)(8676002)(38100700002)(83380400001)(6506007)(41300700001)(7696005)(966005)(71200400001)(52536014)(478600001)(186003)(9686003)(26005)(38070700005)(55016003)(44832011)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WySGlBt/ti7czy1Vh77iRb5H61uGFrM8y/FfqQML804qI75Y1MHB2mbLg6Es?=
 =?us-ascii?Q?MJOUa2KpmeGQ6ZUNAclT77Zete2zxU2dVijYFutEhWHV5Foo91bCMG7gRTue?=
 =?us-ascii?Q?6RumzZ5pvgA+RdHMFIvXVAYSyufpztCijvshEtcyEWEtjnGuB9RqRekKiaOD?=
 =?us-ascii?Q?ReD1B+SMcS9xsdJ2bjOn9tvtZ7i0jiEpnMSgCXanAv0TAPes5eVyQEywBOHg?=
 =?us-ascii?Q?IF8GgWEL73ffOtj+xMXhxzjNM0Vxzsv2psG7rywBdH/B8DPH1mkG+fWykGnJ?=
 =?us-ascii?Q?iOycXu0rUtbdAvfiW3r4O/GAil/NkLMa7yD4g16Zhwn4bX7KfRM1Rdxu4+A7?=
 =?us-ascii?Q?RXGdwHUYNGzoQ+GXBLofUp4Hp57WtsZ/lBllfHkEX0NQPa9Yrm0KtX32ueUw?=
 =?us-ascii?Q?gYBQVdcI8Swpe7+7ycFff77SxyN44XUrjF4ovFrDjMR5t94eB3Li/Oa6d9Cg?=
 =?us-ascii?Q?qHMV+28C3hm5pCBwryB+X+IjyySzBcn6Orx1h1k4YYkbfNryIed5WtHCNRVS?=
 =?us-ascii?Q?MXXYn5LmmWW9nw9cd29fINW6UfayMU9RwvFeCP9FNdXsK1L5EqEeMiXf0npo?=
 =?us-ascii?Q?in/CHehxDdO8+YYq/P2fWHBWFpv6Yi/7CUtoQbJaWP7qgmNJgqeXaTDPHDb0?=
 =?us-ascii?Q?iHzm8Mud21jhqRwySXSzHCExDthnfeevUbRfQSr86msJMMORdWGULJsSdsfo?=
 =?us-ascii?Q?8QZ0o7iK70WYHBKZNg4gUwQcCHEYjGjOfJ7A25DdeqYO/QKdzFWGyomzoXVR?=
 =?us-ascii?Q?ZTMHylubSgJ8ToAspPXU59gsrHK9tmVRNgzEZtDN2pMMRL2WpbYxnUa5tiKA?=
 =?us-ascii?Q?JZRZmG00lAmK9t7NoiddsyCoCdvr2tJ5S0oIiB7zTHEaUV36iAZC52Khe2px?=
 =?us-ascii?Q?UvX7YqPg1iw3wiWeanP8TSDdx2hda1RRpfTHg7FtW9T3Zw52vQRYc9wYciaY?=
 =?us-ascii?Q?+5VhLHxTd5aCdnIRoaKL7W5XNcvqq4JO3gLXzyZeyhKLfUYJssRb/bbG6zR4?=
 =?us-ascii?Q?U6Y+mHSMBEDT06XokJBFQtlOdc9iNwuiJk7tKSJm9pelWFUK3yW6RoLWpVic?=
 =?us-ascii?Q?ENm6EOQDE5GhbaFvJ7NX/95/XIIxSyP6FoDAhIkxu5tFHAHJj0NYZrHXr0Pn?=
 =?us-ascii?Q?sYLpzQ7UDjBt5oyNXwjhluFWkGYuVqudgXzhh1zaC889NzMmUrXbGImK/qyW?=
 =?us-ascii?Q?FKLWG3lW/pt30Yyp1UYoN8j8+2dfTuZPb+Z3Ae6Lo5pN1XuGzb+Sotp+9KXt?=
 =?us-ascii?Q?P+SX5UojcoFbFIB/NV0iUQthcBBOhkMhkKwUrDYo3tsncJogD3zYqS16n4hC?=
 =?us-ascii?Q?Oqf5NdOsBNvICRqlFanpmJsheDZmdz9gH4RdIJFI04BS+48S9zKQ+FHWBzLH?=
 =?us-ascii?Q?D6eM+yp/9nriU9fDhzmamDCo/1CH6yOMWghLPL7Wl0TXm3Kf5CstuoJ3UREn?=
 =?us-ascii?Q?8fBM8glKuQMy39za+DZjHzec3Xgo1AXkIja2IYSLvKXXxDPAuMDzJxw69lDN?=
 =?us-ascii?Q?OH3EYp9I8mzun7mby4Y7nzKbHviXB5TYW1bdwWnB+4r2ynmunJvHQGTOi2g7?=
 =?us-ascii?Q?fj6shN6mtRBUWObhMII=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae8bfef5-e6be-4b87-fa1b-08da9aa4ebb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 01:10:34.5632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IO4JK7FODMqFf2KftaprgP+F/pls5vCWiz3Hkj+01igXdV1NmsBS45ZqJFGF3uBlfJyuSBxgx6NVjeoCXBzHjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7448
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Subject: [PATCH] Revert "firmware: arm_scmi: Add clock management to
> the SCMI power domain"
>=20
> This reverts commit a3b884cef873 ("firmware: arm_scmi: Add clock
> management to the SCMI power domain").
>=20
> Using the GENPD_FLAG_PM_CLK tells genpd to gate/ungate the consumer
> device's clock(s) during runtime suspend/resume through the PM clock API.
> More precisely, in genpd_runtime_resume() the clock(s) for the consumer
> device would become ungated prior to the driver-level ->runtime_resume()
> callbacks gets invoked.
>=20
> This behaviour isn't a good fit for all platforms/drivers. For example, a
> driver may need to make some preparations of its device in its
> ->runtime_resume() callback, like calling clk_set_rate() before the
> clock(s) should be ungated. In these cases, it's easier to let the clock(=
s) to be
> managed solely by the driver, rather than at the PM domain level.
>=20
> For these reasons, let's drop the use GENPD_FLAG_PM_CLK for the SCMI PM
> domain, as to enable it to be more easily adopted across ARM platforms.
>=20
> Fixes: a3b884cef873 ("firmware: arm_scmi: Add clock management to the
> SCMI power domain")
> Cc: Nicolas Pitre <npitre@baylibre.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Tested-by: Peng Fan <peng.fan@nxp.com>

Thanks,
Peng.

> ---
>=20
> To get some more background to $subject patch, please have a look at the
> lore-link below.
>=20
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fall%2FDU0PR04MB94173B45A2CFEE3BF1BD313A88409%40D
> U0PR04MB9417.eurprd04.prod.outlook.com%2F&amp;data=3D05%7C01%7Cp
> eng.fan%40nxp.com%7C05437bc19cb14760450a08da9a3968c0%7C686ea1d
> 3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637991868616277658%7CUnkn
> own%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik
> 1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DQpQfK8lTApY
> qhYj80lUudQJMCujYyN9j1RNB4Q00wrM%3D&amp;reserved=3D0
>=20
> Kind regards
> Ulf Hansson
>=20
> ---
>  drivers/firmware/arm_scmi/scmi_pm_domain.c | 26 ----------------------
>  1 file changed, 26 deletions(-)
>=20
> diff --git a/drivers/firmware/arm_scmi/scmi_pm_domain.c
> b/drivers/firmware/arm_scmi/scmi_pm_domain.c
> index 581d34c95769..d5dee625de78 100644
> --- a/drivers/firmware/arm_scmi/scmi_pm_domain.c
> +++ b/drivers/firmware/arm_scmi/scmi_pm_domain.c
> @@ -8,7 +8,6 @@
>  #include <linux/err.h>
>  #include <linux/io.h>
>  #include <linux/module.h>
> -#include <linux/pm_clock.h>
>  #include <linux/pm_domain.h>
>  #include <linux/scmi_protocol.h>
>=20
> @@ -53,27 +52,6 @@ static int scmi_pd_power_off(struct
> generic_pm_domain *domain)
>  	return scmi_pd_power(domain, false);
>  }
>=20
> -static int scmi_pd_attach_dev(struct generic_pm_domain *pd, struct devic=
e
> *dev) -{
> -	int ret;
> -
> -	ret =3D pm_clk_create(dev);
> -	if (ret)
> -		return ret;
> -
> -	ret =3D of_pm_clk_add_clks(dev);
> -	if (ret >=3D 0)
> -		return 0;
> -
> -	pm_clk_destroy(dev);
> -	return ret;
> -}
> -
> -static void scmi_pd_detach_dev(struct generic_pm_domain *pd, struct
> device *dev) -{
> -	pm_clk_destroy(dev);
> -}
> -
>  static int scmi_pm_domain_probe(struct scmi_device *sdev)  {
>  	int num_domains, i;
> @@ -124,10 +102,6 @@ static int scmi_pm_domain_probe(struct
> scmi_device *sdev)
>  		scmi_pd->genpd.name =3D scmi_pd->name;
>  		scmi_pd->genpd.power_off =3D scmi_pd_power_off;
>  		scmi_pd->genpd.power_on =3D scmi_pd_power_on;
> -		scmi_pd->genpd.attach_dev =3D scmi_pd_attach_dev;
> -		scmi_pd->genpd.detach_dev =3D scmi_pd_detach_dev;
> -		scmi_pd->genpd.flags =3D GENPD_FLAG_PM_CLK |
> -				       GENPD_FLAG_ACTIVE_WAKEUP;
>=20
>  		pm_genpd_init(&scmi_pd->genpd, NULL,
>  			      state =3D=3D SCMI_POWER_STATE_GENERIC_OFF);
> --
> 2.34.1

