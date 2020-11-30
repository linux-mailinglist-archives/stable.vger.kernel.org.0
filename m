Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C162C7E2F
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 07:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgK3GZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 01:25:29 -0500
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:55945
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbgK3GZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Nov 2020 01:25:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OapZEhKME2X5mYQmXB9tZ+qpAxL/6wJ69z8FvVqvYFFaN2D1eopBODxVSwDs64xMK2Ae2mvMFKMCKxPVB07SiAn3T6ER4tOlvAMtepExQZxCQjH96oIzE1FxbDfZFGUM/y4f6eA1pmNB8pFr1rR7Q2MpO4iGydoITUD45Qzeq7u7/AbXvfeUjI9oIbw8ez42xyA0rNeIfBe/EJOxVTCDMkY/TbxC9KYLKzeDEV9X8rQI9VKaSMwm/waHTbOxw21duYxAFI4CaLsGUhXkKBHTqVkzkiuCp43NJ8jSR4MOfSwmu8S6Pp9+2TsGPAENSQoR1zgHl29iazjkoAUnOvz+6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKEEApliZUODyI2hPFgUFGHvp4T/8iP1dwSnHa+ir6M=;
 b=NE+eP2zJYGDwSLk61rzSBIrUXZcTMfdtbZf7n5vOH6PYA+XiFvJX1uUBBFp+XiNvNXZ5U5PfDLwU8NLN676NfWwZAP98y13cg59AaR2VNlEwx93CWOFUZDb65gGqjghj1BJFXRZwlz4BpWCOGvjujMUXKruROIhSkuqp8KnIiIaRciyLm16TBhpH4HV/U3jqq9u7j0Djn6EGR+w6hGi267CA6q04Iz8mepo5QxdHQ/4FCaWmhRWfqV++4sYmZzQySc3UkHOo40LsIzbcfBWzK/DUkEtzn9Rw4wdZv1FHxn7WAUmBbMXe6YImDb/QaC/7QV+y+iIcmYXb1dH+ifLyRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKEEApliZUODyI2hPFgUFGHvp4T/8iP1dwSnHa+ir6M=;
 b=aBeq16/4JLVEIf47Ch4cvfM1ROq4mXq6Hpv38obKg66Yvo9Oc8iG6xRzSCikjJE2O8P2pq6vx5L5IjPslh2UreFt6+9w+ZceXXJNZ1E8FDnGREmuzOLtbD8RvKxivp7PGLUNM8KaNv+SNdCfNBDOfmuEGgJBC22gQQrxySsEY38=
Received: from DBBPR04MB7979.eurprd04.prod.outlook.com (2603:10a6:10:1ec::9)
 by DB8PR04MB7177.eurprd04.prod.outlook.com (2603:10a6:10:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.21; Mon, 30 Nov
 2020 06:24:40 +0000
Received: from DBBPR04MB7979.eurprd04.prod.outlook.com
 ([fe80::c8c:888f:3e0c:8d5c]) by DBBPR04MB7979.eurprd04.prod.outlook.com
 ([fe80::c8c:888f:3e0c:8d5c%5]) with mapi id 15.20.3611.031; Mon, 30 Nov 2020
 06:24:40 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "balbi@kernel.org" <balbi@kernel.org>,
        "willmcvicker@google.com" <willmcvicker@google.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        EJ Hsu <ejh@nvidia.com>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] USB: gadget: f_rndis: fix bitrate for SuperSpeed
 and above
Thread-Topic: [PATCH v2 1/5] USB: gadget: f_rndis: fix bitrate for SuperSpeed
 and above
Thread-Index: AQHWxMZ2FbkfIsj42EaFiLZGH/Pe/angOUeA
Date:   Mon, 30 Nov 2020 06:24:40 +0000
Message-ID: <20201130062411.GB32154@b29397-desktop>
References: <20201127140559.381351-1-gregkh@linuxfoundation.org>
 <20201127140559.381351-2-gregkh@linuxfoundation.org>
In-Reply-To: <20201127140559.381351-2-gregkh@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.9.4 (2018-02-28)
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aaf6b7ff-761a-49d5-c889-08d894f89e9e
x-ms-traffictypediagnostic: DB8PR04MB7177:
x-microsoft-antispam-prvs: <DB8PR04MB7177AC785ED0AC4194EEEE558BF50@DB8PR04MB7177.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:556;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZapMmQ9Q+zrKpf9xYQgBOJhle1QJESth9lJkYGGpbKiGlSR9lvUGQPiGfoXRKQGC4njzuNyoENoXulXdJqEQcVn8u3WFCtkGlkPY8+nY9ULsUTrI7iEYUemZYcCg0oIp8hWxADeGUHZOLrinon2innQjyJAb9OVjFo0a+5pMJfCcyUaVYvs2xPKAi3XjcJFsPB/co3iQn1QRpzwmMPXxTfHeFyvekhaY2Z50TRyEB9g8EQphbhPem+W8pelLVzreTM9/2/pNtqITMDlNKtlany+WRWJlk+kxgLKrVT8CQr6rgVVuSICAoiU7I04B9Z+i3CFYAsfDLWTbHXi9Re+6rg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7979.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(396003)(376002)(136003)(346002)(39860400002)(1076003)(86362001)(4326008)(33656002)(6916009)(316002)(6486002)(54906003)(6506007)(66446008)(66946007)(66476007)(76116006)(66556008)(91956017)(478600001)(8676002)(44832011)(5660300002)(33716001)(83380400001)(9686003)(6512007)(8936002)(71200400001)(2906002)(26005)(186003)(64756008)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hvkOlt8c/3WRk3VD7EPcb8BO1VLHCXPBPrSBDgZR4/yh/aqYD+mA0rmY7zN6?=
 =?us-ascii?Q?Rjgtnfc5XpjVku8PQTiHXOCw4in3QtRyCyqSN3OXBal+FK9ViRtCpW/jBBPo?=
 =?us-ascii?Q?CDhQvKoR94d8UZhS9EL+uNO4qftk57yTvELs+k6ivRLCAKQxkMV4pkC8Avz5?=
 =?us-ascii?Q?w/f/W3xlF88zqmcd7kQzz4N0EuCBzMnT9uRSvi6mI8wHUPDgQPfqCQ2ZZC5l?=
 =?us-ascii?Q?qkTKXtmVYO+SzBo8NXulUFw56FV+DdMeg47KnaVzSbi9eKmYqjnKT8kOA33o?=
 =?us-ascii?Q?RR0MTWO5B8ebCgKRsOXhpDNOW08gPyw5ioCjziZztDoEVotxBAmjfgiq8z2u?=
 =?us-ascii?Q?ZLOsq5S+XVRaPjTSCr0WF8GUGZNzDuE2ejOaZlvf3cQVkqamX9eqa3lu169M?=
 =?us-ascii?Q?q51d0ix6mv1cKslXjSkf/QU77e6oJcs3cQlFZdRqWX1qzjX9jbi0+We2z2hA?=
 =?us-ascii?Q?5JVfseUWlRbHzz2sPD8yU3dw04K8bZdCguRmPrUpQU3xtJmCmfwByhDTD0hL?=
 =?us-ascii?Q?Ng5TAPu0bbTTxMqA+lJyN5eQud2SRmU0fP6v/TWuXzbxMok3+rUlSQ3lWVro?=
 =?us-ascii?Q?k8+GaZg8TGOoU8Rj6cFqhDfo0sCAR+bJQLj448OK9P+YtBXYWfHOShvNShpg?=
 =?us-ascii?Q?/a0IGRL9U66wDgMn7MMVaSqAgeUW8HazcOMAYb/f+ahhHUf3E4hDeG+4j0uS?=
 =?us-ascii?Q?za/JOIlhVsDTLYMj7iXFrMuBsfVv16lHBxbcPFU2+1dxfihAJQTuyDSF+Rds?=
 =?us-ascii?Q?PuQV6eEw2Svvm4Lfsf7noPTyWwTbooee81pIj4ae9lWDBDXN9PBHnqv+EITh?=
 =?us-ascii?Q?8wAy5zB6FmNvoGlvHIy/MZ2tOjABZ2XHdOJ2+RATptWE7F3fGbCfQaniikZl?=
 =?us-ascii?Q?TvcDzWJOqDn1EiwrPERkOjjmqIYapPWjCNgZbq0Z6nVPK32QPwNZZKNcFXA+?=
 =?us-ascii?Q?V7iKtns62g9DDpnpHZ/adKYVElWe0pcQ7dILSkP6wBdCMY96fsOmwkoWWrkH?=
 =?us-ascii?Q?6vCe?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7A93E39BFC70454E8B3A1866F5497B56@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7979.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf6b7ff-761a-49d5-c889-08d894f89e9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 06:24:40.5736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A6L8K2ekdRQcI6u0hgjx4Y4QMKCSMlZ+0ptXRMyLB/aDaV15wRjn2g9LWfd/iPG2M0ZLdKPVOZrgodqe1h1Jpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7177
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20-11-27 15:05:55, Greg Kroah-Hartman wrote:
> From: Will McVicker <willmcvicker@google.com>
>=20
> Align the SuperSpeed Plus bitrate for f_rndis to match f_ncm's ncm_bitrat=
e
> defined by commit 1650113888fe ("usb: gadget: f_ncm: add SuperSpeed descr=
iptors
> for CDC NCM").
>=20
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: EJ Hsu <ejh@nvidia.com>
> Cc: Peter Chen <peter.chen@nxp.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Will McVicker <willmcvicker@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/usb/gadget/function/f_rndis.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/gadget/function/f_rndis.c b/drivers/usb/gadget/f=
unction/f_rndis.c
> index 9534c8ab62a8..0739b05a0ef7 100644
> --- a/drivers/usb/gadget/function/f_rndis.c
> +++ b/drivers/usb/gadget/function/f_rndis.c
> @@ -87,8 +87,10 @@ static inline struct f_rndis *func_to_rndis(struct usb=
_function *f)
>  /* peak (theoretical) bulk transfer rate in bits-per-second */
>  static unsigned int bitrate(struct usb_gadget *g)
>  {
> +	if (gadget_is_superspeed(g) && g->speed >=3D USB_SPEED_SUPER_PLUS)
> +		return 4250000000U;

Is tested value or spec defined value?

>  	if (gadget_is_superspeed(g) && g->speed =3D=3D USB_SPEED_SUPER)
> -		return 13 * 1024 * 8 * 1000 * 8;
> +		return 3750000000U;

13 * 1024 * 8 * 1000 * 8 =3D 851,968,000, how 3750000000U is calculated?

>  	else if (gadget_is_dualspeed(g) && g->speed =3D=3D USB_SPEED_HIGH)
>  		return 13 * 512 * 8 * 1000 * 8;
>  	else
> --=20
> 2.29.2
>=20

--=20

Thanks,
Peter Chen=
