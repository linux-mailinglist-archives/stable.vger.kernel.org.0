Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9F12F412C
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 02:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbhAMB2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 20:28:31 -0500
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:51680
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726407AbhAMB22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 20:28:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8cTzRaGtX4umKBKGSju4O3qYYnd23thnoNPNdmggMDR3QkzpAZVwHpL+FYnhuee7Egspeby8pHVDTBznXnUNYXbeJowyaN+tiCGPxwwyyrHftcxzzEOH27Z9S5TsEeQr4wRkdDOgSHbU7RalcETHVEdO2fjJk7n/wdBsVl6ytO5GOycoUNIt7nbYMF3A/8lhpPnfYrbpbjJU9S1SP3lwS1Dgiasqsr8+VIAnsFqDCWR+tvvrLvWviJHmA8iyyz0P9o/5dbiHbF1al+u9RJx1teAC7azmAwKQQKrlR0CRIl7O26bMjZ8RFMB70n6zsy1xgTAjUNklfc4CQ7twV6ATA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSwrFm1P5G0qVZM9EpCK+ClAjgj7K0VPmlznypgwTi4=;
 b=Y7+jLW4B5rOjOxS94NK0p74fIu1gr/3rXOYtlBu52utDoXvAyfQ9aAoN49dUU6frnh1GFFP3eqn6cIzJUjiGKZ33C4BCpoVvlmZ/RMvzGOy3d+Q035DqruzB+w6b+iFAMafqq9sW3inLv+O8nFXqaKQSUf+JjapvD6ETK1TsU9zaUee51mAWGSR+mZfCsl53NEshBxV5i+xXbFRpgoCU5fRiFq9vU3cTgw7O1wP4FAAK8HIUICMP40aCEtGLHwaBWJgcKiiZtWhC6fUTcDqUI0ZB/VWySMcs2Uqadg1J2iVrfeSZ9oPHWFCn2r7xBl/xGLaK7Oum6yYz9tv8N4hO2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSwrFm1P5G0qVZM9EpCK+ClAjgj7K0VPmlznypgwTi4=;
 b=ep4MUp1H+4B5+XbOGxni8I3tdqNIUsv2gNF+oqTCyH8f4EraJ6c5qZN4ZzFZS2sZWd/L4RRW2TNyv6pgce/iEdfc5PRsYSAewNcXw7QG4I3NHs7TVx2MzbKkqjnUHJoyTFzmiFtmQN37EY2hTeATlc9deZcezknoH1z0z6W2oxo=
Received: from DBBPR04MB7979.eurprd04.prod.outlook.com (2603:10a6:10:1ec::9)
 by DB8PR04MB7177.eurprd04.prod.outlook.com (2603:10a6:10:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 01:27:37 +0000
Received: from DBBPR04MB7979.eurprd04.prod.outlook.com
 ([fe80::89de:bd7c:7245:f139]) by DBBPR04MB7979.eurprd04.prod.outlook.com
 ([fe80::89de:bd7c:7245:f139%5]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 01:27:37 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: udc: core: Use lock for soft_connect
Thread-Topic: [PATCH] usb: udc: core: Use lock for soft_connect
Thread-Index: AQHW6TpcZciGxo2qrk6g1T0cSEIUkaokw+AQ
Date:   Wed, 13 Jan 2021 01:27:37 +0000
Message-ID: <DBBPR04MB79790965BEC1A036A2048A088BA90@DBBPR04MB7979.eurprd04.prod.outlook.com>
References: <8262fabe3aa7c02981f3b9d302461804c451ea5a.1610493934.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <8262fabe3aa7c02981f3b9d302461804c451ea5a.1610493934.git.Thinh.Nguyen@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: synopsys.com; dkim=none (message not signed)
 header.d=none;synopsys.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [222.65.210.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ac43e190-8f9b-4d5b-6e10-08d8b7626941
x-ms-traffictypediagnostic: DB8PR04MB7177:
x-microsoft-antispam-prvs: <DB8PR04MB7177387D186AD3D46303C0808BA90@DB8PR04MB7177.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:186;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zwA+gFgtT5w1lvvtEkP0EpPk55PLm5tOmUj0m8dvVmLB7nzhlicUHlcyCQBiR62LNDgs+lQTB19NI5L/VeDcGHJwMQ0boT0SaXNG9Vupxm6MBMj8q+c9ygwKVqTPKYjUKwVUwIqM3e3VUOS+jkOhKy8D6QfZ3bCdKdyhl6zAHH6ekIBjy9D1XDKpGARtODn1ho+AYyYHvVPpLy3ntlI1wDswKQA+8GxphRZuMs4N8Ms7UdVFmjCToXI1ATxAsF8ttoudmu0/ORr9wXL8T+idwhuGRL89/L9zohsCZb439dTd5LahbTXSBgbPQ/yGdNbBEGk78bPn49GMl2S1tknBkX124qKPyltDZYxawHtPWza3oU73+3loIeEqwhoU+DdQpHh8pq4Y5ka+jT0jFICh+RoxAF8gOa0rqT2TJVk43QCK5IhWhVnUlAMvRcSPXXll
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7979.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(7416002)(478600001)(4326008)(7696005)(44832011)(33656002)(316002)(921005)(76116006)(9686003)(8676002)(66476007)(6506007)(55016002)(66446008)(86362001)(5660300002)(71200400001)(26005)(8936002)(64756008)(66556008)(83380400001)(186003)(52536014)(66946007)(2906002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?p9C06J9ykAyCTNriCvpDTJwxB1SkJBdKFaUGMLl9mok9s7fPzxu3bskULP7U?=
 =?us-ascii?Q?xdcfUYuOLww0NrvdFLelTPVrNQ31ZXwFOHimiC9e55TGqy+kQo8VBuDirfkB?=
 =?us-ascii?Q?CL3M3HYw5vNqJqiwvLdU/uguKv4D7s7A6ggivDox2af24+/41pn8FYzaCKBf?=
 =?us-ascii?Q?zwfUF7DM5QblsxsTEqe+c3XZ7sA7dxDSl/KIQ18A7NlEGH7bCjq7D2RzAdM7?=
 =?us-ascii?Q?tX/lwfSmFdRWI3lO8Ex6lgQFQ6lARuIS3h8azPuJoxVP7friQ5z5qdYAr+vx?=
 =?us-ascii?Q?yALRfJekUCMQjlPMH1kGWUD3DU5FKElUUXW1tSHrAXmIbP5vLa8AudEic4PG?=
 =?us-ascii?Q?zblVuOL8fiySTgtjhSzt89xOlY4Y0tIMWMxYiSjAKRHAOMsbonk0YAMBBqe6?=
 =?us-ascii?Q?kp/AAz97u+6F8wubmV8hixn1sBVGvBbXZmT7wPDiIPgzHfVBupdYXXfR89Gy?=
 =?us-ascii?Q?30paby1nRxcfo0Nz8wPY91/9uLz+iFBzPGWyL6s3KzzphrXmf8pgfcG0bIGP?=
 =?us-ascii?Q?0bNqBUr2yq651eBvXor9fwbY6gqqkz5TlL/BIqlULsP4S2TQdX33MDPXHjdY?=
 =?us-ascii?Q?1uV/avbksqbIuykH7SnsvtzKGwcRJvhHf+86TWivKtG1Auz9Dxrj+PFkm1EP?=
 =?us-ascii?Q?j5MmvJ/FYGpW1FvxOXrCQaAilAM629fQ1UyKNE5qZX5Yp55foPomPIOrfGWj?=
 =?us-ascii?Q?z9rZDFMDUBMKe9r+wPbH/kuCZH6fxCtRZl77+3uOEF4HEeOkD35/aQZjQ6lY?=
 =?us-ascii?Q?MCTpDdiQwUEIQPnwSD9qOwxKXZ1Ob26SVFACy7P0OHqjc/ZXJTV0F1+3IfuS?=
 =?us-ascii?Q?WPRcEZbtFuuFcI0N6xaU9UyyVOc+T52bNvfid5gONn8ShJpCl2WbhS+cYzyp?=
 =?us-ascii?Q?WikPqaM4WlKPEL79AHBvjm6Qwe+Y/EMDET4ePMuaX1cN2xgOpmiZtUSIeGWf?=
 =?us-ascii?Q?2v12Rdi24i8QjKV49v665rjuqUpmx7ufwt7PLLfOhQ4=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7979.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac43e190-8f9b-4d5b-6e10-08d8b7626941
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2021 01:27:37.2622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x+VwFE8Do6Kn/XSPoFJYD/CZ2zulAr/CtRcT+ruPkmzEe00wGyRpT9j30dFz+o1YqgrDSZU4Cs9AhGPqxqQH3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7177
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=20
> To: Felipe Balbi <balbi@kernel.org>; Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>; linux-usb@vger.kernel.org; Peter Chen
> <peter.chen@nxp.com>; Lee Jones <lee.jones@linaro.org>; Alan Stern
> <stern@rowland.harvard.edu>; Thomas Gleixner <tglx@linutronix.de>; Dejin
> Zheng <zhengdejin5@gmail.com>; Sebastian Andrzej Siewior
> <bigeasy@linutronix.de>; Ahmed S. Darwish <a.darwish@linutronix.de>;
> Marek Szyprowski <m.szyprowski@samsung.com>; Michal Nazarewicz
> <mina86@mina86.com>
> Cc: stable@vger.kernel.org
> Subject: [PATCH] usb: udc: core: Use lock for soft_connect
>=20
> Use lock to guard against concurrent access for soft-connect/disconnect
> operations when writing to soft_connect sysfs.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 2ccea03a8f7e ("usb: gadget: introduce UDC Class")
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

Reviewed-by: Peter Chen <peter.chen@kernel.org>

Peter

> ---
>  drivers/usb/gadget/udc/core.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.=
c
> index 6a62bbd01324..44c67e765167 100644
> --- a/drivers/usb/gadget/udc/core.c
> +++ b/drivers/usb/gadget/udc/core.c
> @@ -1530,7 +1530,9 @@ static ssize_t soft_connect_store(struct device *de=
v,
> {
>  	struct usb_udc		*udc =3D container_of(dev, struct usb_udc, dev);
>=20
> +	mutex_lock(&udc_lock);
>  	if (!udc->driver) {
> +		mutex_unlock(&udc_lock);
>  		dev_err(dev, "soft-connect without a gadget driver\n");
>  		return -EOPNOTSUPP;
>  	}
> @@ -1542,10 +1544,12 @@ static ssize_t soft_connect_store(struct device
> *dev,
>  		usb_gadget_disconnect(udc->gadget);
>  		usb_gadget_udc_stop(udc);
>  	} else {
> +		mutex_unlock(&udc_lock);
>  		dev_err(dev, "unsupported command '%s'\n", buf);
>  		return -EINVAL;
>  	}
>=20
> +	mutex_unlock(&udc_lock);
>  	return n;
>  }
>  static DEVICE_ATTR_WO(soft_connect);
>=20
> base-commit: 4e0dcf62ab4cf917d0cbe751b8bf229a065248d4
> --
> 2.28.0

