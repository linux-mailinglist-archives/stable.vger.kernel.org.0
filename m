Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8222BBD33
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 22:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388505AbfIWUi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 16:38:57 -0400
Received: from mail-eopbgr00042.outbound.protection.outlook.com ([40.107.0.42]:36848
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387586AbfIWUi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Sep 2019 16:38:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oO2LYJUWnWWGa6CIMNTYzGZCWjQ/FCWbOlRQ/MBSnW2QeIXiGELImjhxMxJngQDWbad2lh1SzfZCWahWgguakMTOUxiAFDOz6Cfgz6RnqHoojTSlokI1Z6S1kSk52m36D97up72XxtzSATEqyTCpFHrbwR9jvHWO+KW9H9SkWUZQq2AOiseSFhd7K4aOUL9RYNraqTf7+eawj0rXXAFY2jeSVwGSah45gCMbdE/2vVKcuri2O42W3Sg6d+Y5ebuI1CCt44ibZHCdmGbw3rRLGWmwMX0BnTsrEmurlHsNLHiWcE7RbgPMrAbyVD8mO60Ipu3higk9TdiB7VEgE285kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSI+6iEGC4A2yaFehDZuygNUSUB7NWuwAdVNqPZEAq4=;
 b=RsqgGG/TeNJRvhACBwRB3xd9f4SygscG9QPhtHkxV5WyZanacHciUZFnsKC4jyNQZe2JQK0Wa9Qmz001OYnhUFHbHhazSMGVHkP9/9sYdm9Dkm5k5QGpeeDdzR1Kcfn5Rz/TKlbZAAU9dJVICH4wJzS7JWgfjzAgRwzFAA6zv3qPd/MIicIphGRoE9qKZbXDFuORf7Sw7yk/X6IAffrda6drZy49M2Ew0t7noMiMkd46j15s5fW26lKFEbi16zz0tyLXstG/9zHDz2kjkGBUr46M28J2vC/iCWf/+7NBPrE7LfpeOGQ4TsR64kHX1u4GnpfWepWH45SRLYOSGl6Xhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSI+6iEGC4A2yaFehDZuygNUSUB7NWuwAdVNqPZEAq4=;
 b=NRq5SN2psgbvlMxVS+MdX+KF5BvqQbi5BgJlZG+n1OiGOYjghMb4BH1yQ8cDetaerHZC1Azz7LIRqT84vbgXwX7IelBFK1240kfB1AR05fKZ+6z/f2FuJZqsQjwrE9bfWFKpfgvKGLFlEU3igC/Hl0wZ0urGUDWDzh/sJqFU4oM=
Received: from VI1PR04MB7023.eurprd04.prod.outlook.com (10.186.159.144) by
 VI1PR04MB5856.eurprd04.prod.outlook.com (20.178.204.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.18; Mon, 23 Sep 2019 20:38:53 +0000
Received: from VI1PR04MB7023.eurprd04.prod.outlook.com
 ([fe80::15cd:b6e7:5016:ae8]) by VI1PR04MB7023.eurprd04.prod.outlook.com
 ([fe80::15cd:b6e7:5016:ae8%2]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 20:38:53 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     Sasha Levin <sashal@kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.19 075/128] PM / devfreq: passive: Use non-devm
 notifiers
Thread-Topic: [PATCH AUTOSEL 4.19 075/128] PM / devfreq: passive: Use non-devm
 notifiers
Thread-Index: AQHVcXdiqSlNsnfqLkGLrgtGWZnq9w==
Date:   Mon, 23 Sep 2019 20:38:53 +0000
Message-ID: <VI1PR04MB7023BD0451C047D6A59D986EEE850@VI1PR04MB7023.eurprd04.prod.outlook.com>
References: <20190922185418.2158-1-sashal@kernel.org>
 <20190922185418.2158-75-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2d2cc4b-1bd1-4ffa-14aa-08d740660c58
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5856;
x-ms-traffictypediagnostic: VI1PR04MB5856:
x-microsoft-antispam-prvs: <VI1PR04MB58566D6F50F01286E397F62FEE850@VI1PR04MB5856.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:17;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(189003)(199004)(81156014)(71190400001)(186003)(81166006)(52536014)(8676002)(4326008)(54906003)(33656002)(66946007)(64756008)(44832011)(91956017)(66556008)(66446008)(229853002)(446003)(8936002)(110136005)(66066001)(99286004)(14454004)(25786009)(76176011)(7696005)(26005)(76116006)(486006)(66476007)(316002)(478600001)(55016002)(6246003)(5660300002)(476003)(6116002)(7736002)(9686003)(86362001)(6436002)(305945005)(102836004)(3846002)(53546011)(256004)(14444005)(74316002)(2906002)(6506007)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5856;H:VI1PR04MB7023.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DD139zQMylr6wv8zflxZnvTU1lajReey12ktQd/D/YaszY/OBfOK6B5+5sik7DjqA5CVEd50L6ZbcvXief1nxlMHT6bbS0T7tVJEWMjLir/koJzGwkPFVY+jr9OKd0RMKh6Ix5tPsiA0YjBMyE0yeME6mnKvUY5UJACkbqBi88S6nVR030uV9jj3M09yo/DSYiKkpq4hLIuwpOXcPeiv9wwh/KFlh/oimBh/kX+Opy3eIQr8Spz1uHSSu1GEndiHIoNyP08x1OqlCyKIhWgoRMZCGyFrIsiHXxUGtK6raMrdEAhi1dDRVzPgBOb0B/hyqKWcbtduPEFZ9Il2mDB6TG7Qe5BZs4bNWEEjxaohkkLkhpGuly9SU7oIByfSApuy847X/ecSXRM5Vs2FCnD/BnVQEt61DxyYwCr6Rdr6lFY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d2cc4b-1bd1-4ffa-14aa-08d740660c58
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 20:38:53.3705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2pHGZM46SviTd0IHjP3ECxNNYSo2T2IvZM08e77dvMo2VuGS3H0w3jHO/gQNvEcrkQfUD2XIB3yIjfZ+4IhFiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5856
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.09.2019 21:56, Sasha Levin wrote:=0A=
> From: Leonard Crestez <leonard.crestez@nxp.com>=0A=
> =0A=
> [ Upstream commit 0ef7c7cce43f6ecc2b96d447e69b2900a9655f7c ]=0A=
=0A=
This will introduce an "unused variable warning" unless you also =0A=
cherry-pick commit 0465814831a9 ("PM / devfreq: passive: fix compiler =0A=
warning").=0A=
=0A=
> The devfreq passive governor registers and unregisters devfreq=0A=
> transition notifiers on DEVFREQ_GOV_START/GOV_STOP using devm wrappers.=
=0A=
> =0A=
> If devfreq itself is registered with devm then a warning is triggered on=
=0A=
> rmmod from devm_devfreq_unregister_notifier. Call stack looks like this:=
=0A=
> =0A=
> 	devm_devfreq_unregister_notifier+0x30/0x40=0A=
> 	devfreq_passive_event_handler+0x4c/0x88=0A=
> 	devfreq_remove_device.part.8+0x6c/0x9c=0A=
> 	devm_devfreq_dev_release+0x18/0x20=0A=
> 	release_nodes+0x1b0/0x220=0A=
> 	devres_release_all+0x78/0x84=0A=
> 	device_release_driver_internal+0x100/0x1c0=0A=
> 	driver_detach+0x4c/0x90=0A=
> 	bus_remove_driver+0x7c/0xd0=0A=
> 	driver_unregister+0x2c/0x58=0A=
> 	platform_driver_unregister+0x10/0x18=0A=
> 	imx_devfreq_platdrv_exit+0x14/0xd40 [imx_devfreq]=0A=
> =0A=
> This happens because devres_release_all will first remove all the nodes=
=0A=
> into a separate todo list so the nested devres_release from=0A=
> devm_devfreq_unregister_notifier won't find anything.=0A=
> =0A=
> Fix the warning by calling the non-devm APIS for frequency notification.=
=0A=
> Using devm wrappers is not actually useful for a governor anyway: it=0A=
> relies on the devfreq core to correctly match the GOV_START/GOV_STOP=0A=
> notifications.=0A=
> =0A=
> Fixes: 996133119f57 ("PM / devfreq: Add new passive governor")=0A=
> Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>=0A=
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>=0A=
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>=0A=
> Signed-off-by: Sasha Levin <sashal@kernel.org>=0A=
> ---=0A=
>   drivers/devfreq/governor_passive.c | 6 +++---=0A=
>   1 file changed, 3 insertions(+), 3 deletions(-)=0A=
> =0A=
> diff --git a/drivers/devfreq/governor_passive.c b/drivers/devfreq/governo=
r_passive.c=0A=
> index 3bc29acbd54e8..22fd41b4c1098 100644=0A=
> --- a/drivers/devfreq/governor_passive.c=0A=
> +++ b/drivers/devfreq/governor_passive.c=0A=
> @@ -168,12 +168,12 @@ static int devfreq_passive_event_handler(struct dev=
freq *devfreq,=0A=
>   			p_data->this =3D devfreq;=0A=
>   =0A=
>   		nb->notifier_call =3D devfreq_passive_notifier_call;=0A=
> -		ret =3D devm_devfreq_register_notifier(dev, parent, nb,=0A=
> +		ret =3D devfreq_register_notifier(parent, nb,=0A=
>   					DEVFREQ_TRANSITION_NOTIFIER);=0A=
>   		break;=0A=
>   	case DEVFREQ_GOV_STOP:=0A=
> -		devm_devfreq_unregister_notifier(dev, parent, nb,=0A=
> -					DEVFREQ_TRANSITION_NOTIFIER);=0A=
> +		WARN_ON(devfreq_unregister_notifier(parent, nb,=0A=
> +					DEVFREQ_TRANSITION_NOTIFIER));=0A=
>   		break;=0A=
>   	default:=0A=
>   		break;=0A=
> =0A=
=0A=
