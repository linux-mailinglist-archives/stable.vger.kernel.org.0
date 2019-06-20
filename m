Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 431934D0BA
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 16:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731943AbfFTOsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 10:48:23 -0400
Received: from mail-eopbgr20089.outbound.protection.outlook.com ([40.107.2.89]:32771
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726551AbfFTOsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 10:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBbZIeA/XEPZCqAoBDVPKDME8hRssu/w4IpL9O/IYr0=;
 b=mJQ+UdbXN2a2kUDD0LmT18T6EBC8uIwAuEQqDhyBn1ALScCbk9c0PauWlipaUkkwHl0AxpPHrZRq8+5NoS+aPJx987FE7Djbok8FMKsyh9v+xAwEfB24a8XvoQpm5wfmX1o+7ul52kJjfdmmG8oO9jNncSh3BSqggh2v+XmPNAM=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2765.eurprd04.prod.outlook.com (10.175.20.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Thu, 20 Jun 2019 14:48:18 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188%3]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 14:48:18 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Subject: RE: Patch "net: phylink: set the autoneg state in phylink_phy_change"
 has been added to the 5.1-stable tree
Thread-Topic: Patch "net: phylink: set the autoneg state in
 phylink_phy_change" has been added to the 5.1-stable tree
Thread-Index: AQHVJp7GvtUQ454g10e1mAYmttBZM6akoBlQ
Date:   Thu, 20 Jun 2019 14:48:18 +0000
Message-ID: <VI1PR0402MB28004F08C06FAEC6FADD7DEAE0E40@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <156094908410230@kroah.com>
In-Reply-To: <156094908410230@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [188.26.252.192]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea64fbcb-5436-4bc5-475e-08d6f58e5591
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2765;
x-ms-traffictypediagnostic: VI1PR0402MB2765:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR0402MB27656B48A2623F34E86BD015E0E40@VI1PR0402MB2765.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(366004)(39850400004)(136003)(53754006)(189003)(199004)(64756008)(53936002)(68736007)(305945005)(9686003)(66476007)(186003)(76176011)(4326008)(76116006)(256004)(73956011)(26005)(476003)(6506007)(71190400001)(2501003)(53546011)(5660300002)(66446008)(71200400001)(14454004)(229853002)(14444005)(86362001)(52536014)(3846002)(102836004)(55016002)(6306002)(81156014)(316002)(966005)(66066001)(81166006)(446003)(110136005)(99286004)(25786009)(66946007)(33656002)(486006)(2906002)(6436002)(54906003)(7736002)(44832011)(8936002)(66556008)(11346002)(74316002)(478600001)(6246003)(8676002)(7696005)(6116002)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2765;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: V+onCdZmDu5i7X2uuEdnV9VHEgXfiWyQTCm5QpuQqDGJWiqI1dSoYY/XGdnWBdWlW2YF5RpnXGlxwQ6LF9aCpQ+rlLXF2ta7RPKKubqqtWhjK1NCgtZnt+uLebrV+GdLzmJbojxUe5oRv595HzD8vvYVtUi1W96lan3X2WE3FnnwWRFlHtDFObcUSpz+alYxINcgUAwswW3vTa6/OS6OS3a5y0meqDmcwEYggbb7nhTwil8forScx4BcKw0NUj4ZeNruhJ+hlXDV8to/F67X/wBY/ZB5WqdHlM95JYz2TOAFENPGEcHkA/zCKgRcA/V3+vSlim9M46Ea/lJ0v6HQDe9bOgg36e0wJ3KG3vfYn3BvCPpJObhuqcMaKwGnnXISdngwqK8d3sQq6B541duCmTbsJqbkkiA55O7SfT1lb2k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea64fbcb-5436-4bc5-475e-08d6f58e5591
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 14:48:18.8248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2765
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Subject: Patch "net: phylink: set the autoneg state in phylink_phy_change=
" has
> been added to the 5.1-stable tree
>=20
>=20
> This is a note to let you know that I've just added the patch titled
>=20
>     net: phylink: set the autoneg state in phylink_phy_change
>=20
> to the 5.1-stable tree which can be found at:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git=20
>=20
> The filename of the patch is:
>      net-phylink-set-the-autoneg-state-in-phylink_phy_change.patch
> and it can be found in the queue-5.1 subdirectory.
>=20
> If you, or anyone else, feels it should not be added to the stable tree, =
please let
> <stable@vger.kernel.org> know about it.

Hi all,

Sorry for the late response but this patch should not be added to stables t=
rees since it was already reverted in net-next.
More information can be found at: https://marc.info/?l=3Dlinux-netdev&m=3D1=
56104162206869&w=3D2

Thanks,
Ioana

>=20
>=20
> From foo@baz Wed 19 Jun 2019 02:33:45 PM CEST
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> Date: Thu, 13 Jun 2019 09:37:51 +0300
> Subject: net: phylink: set the autoneg state in phylink_phy_change
>=20
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
>=20
> [ Upstream commit ef7bfa84725d891bbdb88707ed55b2cbf94942bb ]
>=20
> The phy_state field of phylink should carry only valid information especi=
ally
> when this can be passed to the .mac_config callback.
> Update the an_enabled field with the autoneg state in the phylink_phy_cha=
nge
> function.
>=20
> Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/phy/phylink.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -638,6 +638,7 @@ static void phylink_phy_change(struct ph
>  		pl->phy_state.pause |=3D MLO_PAUSE_ASYM;
>  	pl->phy_state.interface =3D phydev->interface;
>  	pl->phy_state.link =3D up;
> +	pl->phy_state.an_enabled =3D phydev->autoneg;
>  	mutex_unlock(&pl->state_mutex);
>=20
>  	phylink_run_resolve(pl);
>=20
>=20
> Patches currently in stable-queue which might be from ioana.ciornei@nxp.c=
om
> are
>=20
> queue-5.1/net-phylink-set-the-autoneg-state-in-phylink_phy_change.patch
