Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3B329A82D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 10:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895951AbgJ0Js7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 05:48:59 -0400
Received: from mail-eopbgr70041.outbound.protection.outlook.com ([40.107.7.41]:49119
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2895946AbgJ0Js6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 05:48:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZO8eOL1dLy935witw/MnCgyLoiHhLfL9LKJAArzl5Ffhr6h5qf7Ly0QWbiTQd7+mBCQNwKLRDHBTIz1KV7hSbtNmN5W+lD35rMYjOGtwJIXbPxfM/JWSPyaWZ5iBWq2SlFTROIP1MIjG2Dkj1mWeGeLO6+Pm+SRtM/Dvr7T0pNVphTvANzlVimKJguLm3ZLvm8xAwiEmQidotzNMXJtjT8NLsc4W9Z+G0pUEHV2Leh3p/zEwrDq5EMti53bU9s4avSmEr0fERLuF8rHiGVQJSieKX8JLvDSOwbC/kr9YyGYUYana/wF2+HcM2xe+GNVeYjCS/taFDjKJdJiLeo45Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/w6wJRhD8dy4hEb5N1qxURd+6Td063abdU27TyJ6Lg=;
 b=bQZhdfzYneIZrnofAekEkJ783hnRRfhpNd/rkdmkRzufPMAvnM+Bvjt2jESX37Uz0Ei9z6cr7OCwqw/D1rL4wdJjj7/c2LTQIip26rEbRPker8DW9Lxzxtg5A/TAVXVPimvV+Yn8tfKUeCNNyisdDGI+nhaLs/BCjWl/6czITNMnLPqaC8FtBtz3/bQWxp5c+z9A8C2QWhl06N6SIBj8/DGqP5DoPtjebZtqG7SCyIr8p8xqaZ7hz3P4AAU9SxBjXd55eHi688/2JYL/GZNc+iwG2Qf4eDJxuH0XfJtOOhTFpQFJdGWcmMgdH/ED3FhvECi28nw52wNmCv09TfGjsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/w6wJRhD8dy4hEb5N1qxURd+6Td063abdU27TyJ6Lg=;
 b=dm3wKw39V862WKTSbuRpSCUDQqUj4H7QP8fAqCTriiwSOZKFCDrsA2+Gg1E5hqT6HA33yCHJFUXACJ+tEY7HNkD0+J89Ec4DwDBFn5TONENNIQTFtn8Nl34phWXcBxRwWFMLBnJxgR2zPSRUxdNN3RDgE1VxBszDW91ubAf28yI=
Received: from AM8PR04MB7300.eurprd04.prod.outlook.com (2603:10a6:20b:1c7::12)
 by AM0PR04MB6852.eurprd04.prod.outlook.com (2603:10a6:208:18c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24; Tue, 27 Oct
 2020 09:48:54 +0000
Received: from AM8PR04MB7300.eurprd04.prod.outlook.com
 ([fe80::b902:6be0:622b:26c2]) by AM8PR04MB7300.eurprd04.prod.outlook.com
 ([fe80::b902:6be0:622b:26c2%4]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 09:48:54 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Felipe Balbi <balbi@kernel.org>
CC:     "pawell@cadence.com" <pawell@cadence.com>,
        "rogerq@ti.com" <rogerq@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jun Li <jun.li@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb: cdns3: gadget: suspicious implicit sign
 extension
Thread-Topic: [PATCH 1/3] usb: cdns3: gadget: suspicious implicit sign
 extension
Thread-Index: AQHWo6WTaRKfd0hXEU6nD+tea3QI1qmrOMeAgAAMjoA=
Date:   Tue, 27 Oct 2020 09:48:54 +0000
Message-ID: <20201027094825.GA5940@b29397-desktop>
References: <20201016101659.29482-1-peter.chen@nxp.com>
 <20201016101659.29482-2-peter.chen@nxp.com> <871rhkdori.fsf@kernel.org>
In-Reply-To: <871rhkdori.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: efeb8599-78de-480b-067e-08d87a5d8496
x-ms-traffictypediagnostic: AM0PR04MB6852:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB685290991AA011FC8C753BB68B160@AM0PR04MB6852.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HY66AJgMx7izoMhAp7Syw8jDUcg1bUrfjj8DgMmx5d93jYhrkHGnMf0RLGG3ni4dfOyxCpY2vnF3a+DY4+fFRQt5EpIDaptgXqAHmcAJbkgKySJgh4RbIwxJY4N1ydoQSlcpQeaXqnbcmQy02eis/S5q2hUZZotAsAk+W/KwsQ7oUpcOtoo8bl3zJXiJaU1iEURgB1He8mQTPQ4cjgxLSx7eh/tbSZqlJlvdyzuHfJQmqR6QVfI8V+0pji5eagMbRKTeyuPH3GOlz7aXsK5EX0jgCt+SUgrhC8iSyvpKUkRvt+EPzizvtAqbHH0bnKCEVpLCFgcC1ISr3sD+XNEB4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7300.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(66946007)(186003)(53546011)(91956017)(6916009)(76116006)(83380400001)(8936002)(66476007)(64756008)(66446008)(2906002)(8676002)(6512007)(71200400001)(66556008)(4326008)(9686003)(478600001)(6506007)(86362001)(6486002)(54906003)(44832011)(33716001)(33656002)(1076003)(5660300002)(316002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: bTJU23FIS9Hk2lDNKpOeoqc6xuXdbNuFYQ05wdFAlTIDM9bTh0UP7jXoZkVrnTBFcFzvSrjvHlmkyn0AB1qVKLd4oZoUcYokcrtKQw/IyBCjvL4ok79tPRLB0IQAFrLlqrSsdrsOeJ0kl5YfFxygaG4fYqeXKwRkp2hn3TQOmSvQHrPMWvG4lcsCaCBTBQPuzqiZmP3QUvXw4XJvQn0noyEb/tEQK4JPwoimU901NGXxSuyY3XAKRt//aYDBP2TAj11gkoTPGJpW/UHADI4gEREXFcybvSTte6BQOosJjNxYy7WpyZlSw0aZjeHITtloCl3Bow18PcNFkMtHwSB4UvuXlXU+zZfsGOFI+an2H36XcYdGxz64AWXrxDxLTBSzxvj3DoTk+9Q1z/29l+YNGaxe8EFgdmMkT8dE1vIownTsZ40LO/ejhXc6NBoYNsziguN+RpJL/zvbMgvxh0YZPN23MWa9Ben2DN/9CVcTppuy/NXtn0KqXIWagT22JEfR/jqXd47KwEHXla+LUZeRUYycV+aK1PSQvxTTZPonrHqmXYLf9LeKsqvszhWEsi1nET4SXQXJFIRAt7CazxaCPdX8ZQEctLAO8kpnh2dW3yN4ZHnce3TYMWU9ZZY9cwkRYdLTDIMlmv/Y0Y3MkAMxWQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <55B0B3B87C12E947BBC4C66002572A37@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7300.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efeb8599-78de-480b-067e-08d87a5d8496
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 09:48:54.7060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zOhiPUu63yZt3/C2PZLvrrgz7HKjwyNMJq50LpmmvojYlEYCW3KaxEGpNGreEIW2E/AwlWmLx8/XQwLifnGvzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6852
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20-10-27 11:03:29, Felipe Balbi wrote:
>=20
> Hi,
>=20
> Peter Chen <peter.chen@nxp.com> writes:
> > For code:
> > trb->length =3D cpu_to_le32(TRB_BURST_LEN(priv_ep->trb_burst_size)
> > 	       	| TRB_LEN(length));
> >
> > TRB_BURST_LEN(priv_ep->trb_burst_size) may be overflow for int 32 if
> > priv_ep->trb_burst_size is equal or larger than 0x80;
> >
> > Below is the Coverity warning:
> > sign_extension: Suspicious implicit sign extension: priv_ep->trb_burst_=
size
> > with type u8 (8 bits, unsigned) is promoted in priv_ep->trb_burst_size =
<< 24
> > to type int (32 bits, signed), then sign-extended to type unsigned long
> > (64 bits, unsigned). If priv_ep->trb_burst_size << 24 is greater than 0=
x7FFFFFFF,
> > the upper bits of the result will all be 1.
>=20
> looks like a false positive...
>=20
> > Cc: <stable@vger.kernel.org> #v5.8+
> > Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> > Signed-off-by: Peter Chen <peter.chen@nxp.com>
> > ---
> >  drivers/usb/cdns3/gadget.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/usb/cdns3/gadget.h b/drivers/usb/cdns3/gadget.h
> > index 1ccecd237530..020936cb9897 100644
> > --- a/drivers/usb/cdns3/gadget.h
> > +++ b/drivers/usb/cdns3/gadget.h
> > @@ -1072,7 +1072,7 @@ struct cdns3_trb {
> >  #define TRB_TDL_SS_SIZE_GET(p)	(((p) & GENMASK(23, 17)) >> 17)
> > =20
> >  /* transfer_len bitmasks - bits 31:24 */
> > -#define TRB_BURST_LEN(p)	(((p) << 24) & GENMASK(31, 24))
> > +#define TRB_BURST_LEN(p)	(unsigned int)(((p) << 24) & GENMASK(31, 24))
>=20
> ... because TRB_BURST_LEN() is used to intialize a __le32 type. Even if
> it ends up being sign extended, the top 32-bits will be ignored.
>=20
> I'll apply, but it looks like a pointless fix. We shouldn't need it for s=
table
>=20
At my v2:

It is:
#define TRB_BURST_LEN(p)	((unsigned int)((p) << 24) & GENMASK(31, 24))

It is not related to high 32-bits issue, it is sign extended issue for
32 bits. If p is a unsigned char data, the compiler will consider
(p) << 24 is int, but not unsigned int. So, if the p is larger than
0x80, the (p) << 24 will be overflow.=20

If you compile the code:

unsigned int k =3D 0x80 << 24 + 0x81;

It will report build warning:
warning: left shift count >=3D width of type [-Wshift-count-overflow]

--=20

Thanks,
Peter Chen=
