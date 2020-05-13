Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63571D10A0
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 13:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgEMLIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 07:08:17 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:34628
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728101AbgEMLIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 07:08:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwX1rxKeY0rCcydqCh+7df2UKLVRB6vQ29sYgVHGOp6rvglyM676RsTZP20XTEx3eJccWGMHzCcaFjhGFJhydsMoat8IJ3w17WsIgLK4laShfunzjuFXwUtlGAYMcuBPCTtr9JAMjk6itn7WCuwDDaFyh6Lk4/zl+NL0B8gLoKjtDRChnhtaYdQdhyBQYHF5NkCT7aYa967R1c0ixz/6AnBKhfbkoyCZ6e0Yw08/lKTOlsvQO2RnMba/aFBPUF/iQbuaSnwOrngPCVh8gkZRL6Xsvsiqucw3fjXP4GSVHr2Al/FwiHh8qkfLuWNmO5D7d6U8GbGSHZEG5Ye7Bhoq2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3K+FW8pbyQoFgHIiIpSycmacT27vvfwvZsfw+6mE+g0=;
 b=LgujdSdgXnjWzQ+hRPMkuHyGxlpdxsRyLv0FU9rZ0C02ujPYTWN7Pc9qchoRS15NJHiR55GJmMe8CvcAGQRRgfHIoM/YBC77LSQEIdM+FehWVE71JPRNMDobN1d7f72JUpC9HEPwRCSkYnDse8khRZvE1p2mwTgJTMf5kJMzOFR7EeB7w96d831xTNa35k5pYIN9Gh+aXiHBSdCWEycLWyhCh1YCM040CU3DUj3xKLW1xBnQTg5MVRlVUdcubAeQKTxo1A45olqyGy5Nv4Xefr1w9vSzbxC1s+vB3lnXUgDW0fQ6DXhSEBntnpikaB18IWpBJzYZMh6lnpmnWhSH8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3K+FW8pbyQoFgHIiIpSycmacT27vvfwvZsfw+6mE+g0=;
 b=FVusPtsikIdmZuj5kXteJm/dyvEJzXcVLNQ76Mp2qvkyLUpb8LzxXST4+wPEll/d8h2unjnE64UIPky8356W7Q+IHrTCqSMYKz5fqhoPqXmCCgFiO/pses+rwMYyOk1CzVic/EfE4Z8jh0NPq1/mI/Oqztd4osOtv5PiBiq2sBg=
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM7PR04MB7093.eurprd04.prod.outlook.com (2603:10a6:20b:11d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Wed, 13 May
 2020 11:08:13 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::7c34:7ade:17d0:b792]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::7c34:7ade:17d0:b792%9]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 11:08:13 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Alan Stern <stern@rowland.harvard.edu>
CC:     "mathias.nyman@intel.com" <mathias.nyman@intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        dl-linux-imx <linux-imx@nxp.com>, Jun Li <jun.li@nxp.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] usb: host: xhci-plat: keep runtime active when remove
 host
Thread-Topic: [PATCH 1/1] usb: host: xhci-plat: keep runtime active when
 remove host
Thread-Index: AQHWKAYIb9tWY8B1fk+YJlcdJaEypKikdFkAgAClcRA=
Date:   Wed, 13 May 2020 11:08:13 +0000
Message-ID: <AM7PR04MB7157DA1F920529E2D59AA4B28BBF0@AM7PR04MB7157.eurprd04.prod.outlook.com>
References: <20200512023547.31164-1-peter.chen@nxp.com>
 <Pine.LNX.4.44L0.2005120931060.21033-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.2005120931060.21033-100000@netrider.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: rowland.harvard.edu; dkim=none (message not signed)
 header.d=none;rowland.harvard.edu; dmarc=none action=none
 header.from=nxp.com;
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6d4193e2-5884-43b1-4ec6-08d7f72deded
x-ms-traffictypediagnostic: AM7PR04MB7093:|AM7PR04MB7093:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB7093E144F128D0D8F22890378BBF0@AM7PR04MB7093.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0402872DA1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bfc9nIlqsL6xZ79T4XbGT/RC/amUwCYKg88u9ETX92iDTTOTbW5w+/KJxOEmu8DEh+WHgU/3rzNzkehsqEU3QGheU3Ss/Lvywv1mR/RP2/XrgevjaCG+tf95Kc90LG97QFDSr7X7F2vjxMnuyehRjPTbegaY5/vgSHc9zfw5wqARlgT9ZDUSqg3nQCFTQnupL6xoNCPtuYKbGY59JXvWZcmVuA3uHQgOqHp4JWQU92XWMLkuEMosu/FCynU/uWcrsDXQFkExptQvT9Rq33fztMhqWpLrlqdNJOIhQCo1KDtmhSB4/GTuNjiJLW8CiCNLPtYMl0FzA/WzBj3C4wmao7DtXlePh2ivsTazVMFL/hAd+RXqDac+5UupcussuaV7Co7A/eMdOSm/K4pIlbSuYrPCzeqQa2heL4i1ckBhy4UXZExjbRhkv1NpBaMEisw1Hn+Noynf67wyHjXyAcpyNuL7U+9IcvMgqoFJlLNE4ni022zf/C7rbIvJqUvotXGRVj911cgB+x/u7zUn2a+Sag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(33430700001)(316002)(186003)(478600001)(2906002)(54906003)(26005)(71200400001)(4326008)(33656002)(9686003)(8936002)(55016002)(33440700001)(6506007)(6916009)(44832011)(5660300002)(8676002)(66476007)(76116006)(64756008)(66446008)(52536014)(86362001)(7696005)(66946007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: b86sc+bArcvdRIbgXvqWTK1W2M8MhUNpfMtQFv2qxh+8laJkWePwoBTjN4PqK8bRXhSauhwVtY/FU9wJkmUEo9H2L+pGmBtAWmxOWn0E1xL9GB2+/SJ4O827avOxeGiFLAlF9RBLi4Q2VV/Hw9hIZuN3MBgcnAzbMlH8N0Yn5osa33T0v9QBbzRAHve5a6/kMoDvOwMKeMcO/IxUmcEWFsMg5njxRXec4pdzVX/fRe+GK0KeGSdxLERkwnDTiq/Ah4/J3JDJpgdbM5bGuxVqZp2+eg0SU5K775NnrtbWKG6rLfidPVf5IB5VEAyJMKzW9bl6a/WlN7fxOY/SzGXT3eKwMzbYtb0t4TwjUlFjLTlBIy3Iz+pYfYZhKHQnJ3ePZA0Iv2/pVwYrtdcAkj2HfwXU4qhSW99gPvjO+dSixKiGmtR18DoE5CHCqr0CY31/+MXEBH4GFTHz03DCa730T8pxRSuYlEEU0kjfIqGLBrk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d4193e2-5884-43b1-4ec6-08d7f72deded
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2020 11:08:13.2580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fTfIn8E+h2AY4kzegKB7SIxxA/OrOlDS/Yuste/YbQkty36gE9MhIXqePGzKim4UhQ0mtZ/v2kUbnwfeeLHUxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7093
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=20
=20
> > diff --git a/drivers/usb/host/xhci-plat.c
> > b/drivers/usb/host/xhci-plat.c index 1d4f6f85f0fe..f38d53528c96 100644
> > --- a/drivers/usb/host/xhci-plat.c
> > +++ b/drivers/usb/host/xhci-plat.c
> > @@ -362,6 +362,7 @@ static int xhci_plat_remove(struct platform_device =
*dev)
> >  	struct clk *reg_clk =3D xhci->reg_clk;
> >  	struct usb_hcd *shared_hcd =3D xhci->shared_hcd;
> >
> > +	pm_runtime_get_sync(&dev->dev);
> >  	xhci->xhc_state |=3D XHCI_STATE_REMOVING;
> >
> >  	usb_remove_hcd(shared_hcd);
>=20
> You mustn't add a pm_runtime_get call without a corresponding pm_runtime_=
put
> call.
>=20
> With just this one call, if the role switched from host to device and the=
n back to host,
> then the host would never be able to go into runtime suspend.
>=20

I may not consider carefully for other cases, for my case, the xhci-plat de=
vice
will be removed, and re-created. But if we remove the driver using modprobe=
,
it may have issues.

> In this case the correspondence between the get's and the put's will prob=
ably be
> obscure; some comments would help.
>=20

I explained at the reply for Mathias's, but I am not 100% it is the root ca=
use.

Peter

