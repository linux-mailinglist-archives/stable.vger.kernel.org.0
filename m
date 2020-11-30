Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF412C7E3F
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 07:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgK3Ge1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 01:34:27 -0500
Received: from mail-vi1eur05on2053.outbound.protection.outlook.com ([40.107.21.53]:35681
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726275AbgK3Ge0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Nov 2020 01:34:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5HSeK66nOEgrOVJf4YJOLQn3/4raG4usWnoJ3QLQrJ0DMayANwwBXcnE8tP52oKbWvF2JZlnB/5nB2ZXe/ln7FqfVUzRm/MwaIJWhK8Tq77zmHEQz3B4M7O0ZLb2jk3NxHOIrhZUzwuSpia33BroqtEa2M3Fgbo+mLE1SRbMUrzyiSjjgE1EfET5uFLIA+SPlsgD64eNE7m5flix/5/8/TKuJcTLtTMXc7xaJQxfX6xupuMTOrD5CB+aE1j0JcUpFPlw+p+Fn3tHf8741zj07QUqsN2iynwQJKSMWMLfeuQPG5uFDvBmVoDwD3nQUUT8SpTZZuXb1rwWyhrkURBVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBgxiL/hfHG+RhtAIU1sM8f62uwACp4PHpGZLO+bvMs=;
 b=hrsP2x07IZhJGSTGwJmY8TgXiu41UM4eMTUOCbWm/4f2xJR80QL4bXpJfiVlZf4VYBvqzLiSyuAhZek+uHzRacvn/2fAZiUA33vh7bkNWIZCmr4uRK0IJlOFUE6WCCg+TjimCs1wiDjyp3M+TlONrckUXLsZvamaKSw7UoDwH3ZLahN7YgaFuGMZ6Wl2rvJJGBz6FZGui4klDAFnn6Y1J/7yIW/aOODBC1RuGILYrSWReC1Heer+2//fUFpohS7SnkJJs3V3cZxHWhcnofxmheOptfL1y+nthixXKj3cMD4tMtE01NM7gYjtdCe6pDdTvVSwSbSqMNjErTaQDJgFVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBgxiL/hfHG+RhtAIU1sM8f62uwACp4PHpGZLO+bvMs=;
 b=rTQCjMLosrOLv7eJz4t/kpfrg9JUpLDk63xwydN5MhjngyEWr0S12Riek6bWLQOOMwWJt4tJi52WDLuUWDzSxD+KgqJ14fNUPlvES5rP5rnzg2wyaeDgrhtvJ+BQsVBaq4J8WHEOFVSkO65tkMCriBcifspx7g3ofbO2CsYYR60=
Received: from DBBPR04MB7979.eurprd04.prod.outlook.com (2603:10a6:10:1ec::9)
 by DB8PR04MB7179.eurprd04.prod.outlook.com (2603:10a6:10:124::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Mon, 30 Nov
 2020 06:33:38 +0000
Received: from DBBPR04MB7979.eurprd04.prod.outlook.com
 ([fe80::c8c:888f:3e0c:8d5c]) by DBBPR04MB7979.eurprd04.prod.outlook.com
 ([fe80::c8c:888f:3e0c:8d5c%5]) with mapi id 15.20.3611.031; Mon, 30 Nov 2020
 06:33:37 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: chipidea: ci_hdrc_imx: Pass DISABLE_STREAMING flag
 to imx6ul
Thread-Topic: [PATCH] usb: chipidea: ci_hdrc_imx: Pass DISABLE_STREAMING flag
 to imx6ul
Thread-Index: AQHWxNywQVNJTpK6MUaLg0lItrUzHqngO5sA
Date:   Mon, 30 Nov 2020 06:33:37 +0000
Message-ID: <20201130063308.GC32154@b29397-desktop>
References: <20201127164452.3830-1-festevam@gmail.com>
In-Reply-To: <20201127164452.3830-1-festevam@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.9.4 (2018-02-28)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d41565ba-6075-4a91-e694-08d894f9dedb
x-ms-traffictypediagnostic: DB8PR04MB7179:
x-microsoft-antispam-prvs: <DB8PR04MB7179260745F202A6F1DC596D8BF50@DB8PR04MB7179.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: npZgrYmUCTM2LuwassXI4m0e95YvrsMcTfodmq+O6aAaiGQotMjb6E+BiDamynbYnKTjtIXM9MQv3U4DkkaUio4jmE0uIAnAzwdxNHilJm4EisDqYtsc9WYgEn3sSTaCx/U9ERz5F+yK15e6qboZFmIvADRNXwIvJJLKrs1i0w8hmPOIBqds1E1vFaqv6erITpymCR9MMY+VZgpLMegIkPHzsRYeJpE6ChwILcaymErPCvckue0TEUEe9R10R8sqbpF6kBLJKGv0NrM/FhIP8r+WemWEvpz2A5QkbAccA/lJkMPNpipZ+BpfEGLN15ukbvVvM0O65rd5WPRgeUUXpWsY0h9QLnuOqe/I2Hko/uAWzYCpdrML72eBuIfZ3g9VeEQwwIbYCGRFtA+cWqyyml17QV18GWtful5bqmypz5CJit02qVwI6VXSJWmW+Xv95Qxv+t4f/ivgeBz7UtTFyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7979.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(346002)(39860400002)(136003)(396003)(366004)(6506007)(71200400001)(1076003)(8676002)(66476007)(26005)(6486002)(33716001)(186003)(966005)(66556008)(6916009)(64756008)(53546011)(44832011)(76116006)(478600001)(45080400002)(33656002)(66446008)(66946007)(5660300002)(6512007)(9686003)(86362001)(316002)(4326008)(54906003)(8936002)(2906002)(83380400001)(91956017)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?FR7nOH1t53MDUkijJlFefX8SVB0b+qxpY9Or/n2frLmfo5IAeFR+zulVtLwL?=
 =?us-ascii?Q?/EHugQtbKxLgGhz947jVymHndA/0g+vPKB3qooovDnVpVYCslZa0gSWPfhsL?=
 =?us-ascii?Q?Br5zHa0+0nWiPACFA58PEUH3zG+gY5Ethiua+OcjFMe7wig3jldeXeiiBmTH?=
 =?us-ascii?Q?x4qZ3H5u0DTZRW7M5o8PJ9NL5TstR21pBDmr84pwbSMS11Yu/BUXQ2VHCabe?=
 =?us-ascii?Q?pzFwLliAY1hX8cAwe5lrzQwyPcidBWPRdd/DUF283J0NbvIvpxlUMKCaJ9Mh?=
 =?us-ascii?Q?yQnE41d89YcMSGa+PQK98a1I1m7vtx/KYtBfOMDUsRu33Mno7BuO8orlBo5U?=
 =?us-ascii?Q?yMDRd2mRaXhoZue8qfDAg1CwkBDvrkUGHysPG+XF4yYzwrjsNoyON+dIL2ZL?=
 =?us-ascii?Q?ml8EVCbHlRTQd8tYr5wI02Jbxr2NeEAoN5Trwtc6bckfbZ8NJa+oqTrkxnQk?=
 =?us-ascii?Q?mKgEEymQStGL5BlPoucVZLSTXKmEwxZIVQyKL+VgV8va0gW76j+GL+Z745E4?=
 =?us-ascii?Q?u20EIJkDFcqNM+R3rw+V686Uoq3ydYuV7R1hZX8/w8hzvrpV1H4EbhuChxLL?=
 =?us-ascii?Q?6V177fak2UKNICiRmUmQGV3cLt+jGdpUumIZlWoJMno7susn2rCBEZa+4nN1?=
 =?us-ascii?Q?2/gXdLmZuqLcwWn73kr+TlMSneeBjYVzeLDqgmU5IPP3F0I7y6e+JIXu6Vgd?=
 =?us-ascii?Q?zuose7Fs60CwS+phpF1jgiIcpAwUBVO0zyEa6kdKilYP4HmLsDkR2EMqksC2?=
 =?us-ascii?Q?JrwUyP14V37Ef3m7nmxOP6PnLceBCNwABBiRuvgCbdMdwoOnvEQ5peVIb5p1?=
 =?us-ascii?Q?ESxXcfG92MpOqwoS79p5NvkAzeaUbWYsS2E8mexdCN2YUI4hIlZvtPBs8E8O?=
 =?us-ascii?Q?hM6Z6yqnD2zvdYsjgFgtf+asfhBY1Uls46+XK0DAmJgo2EpN7NpPtC2nzPYg?=
 =?us-ascii?Q?bCFQtPo5a42ZaHQOIuFx0MXUtIBZB79b4eM+B5eeG7DEREFfCzsL1LQzw0wh?=
 =?us-ascii?Q?Rlqq?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DC25311B2DF6CC4AA98BBBB1D0979BA2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7979.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d41565ba-6075-4a91-e694-08d894f9dedb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 06:33:37.8789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rk/XRn6aZ2iCGzG66hQqAKZU4HVXRhMQwHWFE2m6HCR/E2MXkEoAQTL1Z8YbxeSxtIGOrOTgJEb4OR8D5sGZSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7179
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20-11-27 13:44:52, Fabio Estevam wrote:
> According to the i.MX6UL Errata document:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.n=
xp.com%2Fdocs%2Fen%2Ferrata%2FIMX6ULCE.pdf&amp;data=3D04%7C01%7CPeter.Chen%=
40nxp.com%7C335258a1babc49be430c08d892f3d299%7C686ea1d3bc2b4c6fa92cd99c5c30=
1635%7C0%7C1%7C637420923191179142%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwM=
DAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C2000&amp;sdata=3DFep8ea=
hQfHYpVv7l4fv%2BnwQxyoKl5E0qKmr61Joqm1A%3D&amp;reserved=3D0
>=20
> ERR007881 also affects i.MX6UL, so pass the CI_HDRC_DISABLE_STREAMING
> flag to workaround the issue.
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: 52fe568e5d71 ("usb: chipidea: imx: add imx6ul usb support")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
>  drivers/usb/chipidea/ci_hdrc_imx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci=
_hdrc_imx.c
> index 25c65accf089..e111009cc49e 100644
> --- a/drivers/usb/chipidea/ci_hdrc_imx.c
> +++ b/drivers/usb/chipidea/ci_hdrc_imx.c
> @@ -57,7 +57,8 @@ static const struct ci_hdrc_imx_platform_flag imx6sx_us=
b_data =3D {
> =20
>  static const struct ci_hdrc_imx_platform_flag imx6ul_usb_data =3D {
>  	.flags =3D CI_HDRC_SUPPORTS_RUNTIME_PM |
> -		CI_HDRC_TURN_VBUS_EARLY_ON,
> +		CI_HDRC_TURN_VBUS_EARLY_ON |
> +		CI_HDRC_DISABLE_STREAMING,
>  };
> =20
>  static const struct ci_hdrc_imx_platform_flag imx7d_usb_data =3D {
> --=20

Hi Fabio,

Does the customer really meet this issue? If it does, please use
CI_HDRC_DISABLE_DEVICE_STREAMING instead of CI_HDRC_DISABLE_STREAMING,
since the latter will disable stream mode for host as well.

--=20

Thanks,
Peter Chen=
