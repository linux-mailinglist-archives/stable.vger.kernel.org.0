Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E652EDA6
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfE3DkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:40:08 -0400
Received: from mail-eopbgr00047.outbound.protection.outlook.com ([40.107.0.47]:56994
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728807AbfE3DkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:40:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKwAFgywkH+FauUPh6gweA96RNgwmnsZdlMeA0QJyQk=;
 b=KHS9djjAzs3cT12G1OOyoH/rtScyUINZdRKpWmUqd8AWEexRJ9GvF/WiQd4PXq6GrXshVx4lLd/28ggIaqEOxJoRGVMwoi7Itve3EUgLAGSDuP0Wz7oWVPG9NxJXVMQ7KdUs9cPY3i4Zx//3KV8BRUkat0iHa08FLmhTY+dN0BM=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2462.eurprd05.prod.outlook.com (10.168.136.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.17; Thu, 30 May 2019 03:40:04 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0%6]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 03:40:04 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: Patch "RDMA/cma: Consider scope_id while binding to ipv6 ll
 address" has been added to the 4.4-stable tree
Thread-Topic: Patch "RDMA/cma: Consider scope_id while binding to ipv6 ll
 address" has been added to the 4.4-stable tree
Thread-Index: AQHVFnrdojY27MvgW0iSfMZmKZw+NqaC6KlQgAASZwCAAASRYA==
Date:   Thu, 30 May 2019 03:40:04 +0000
Message-ID: <VI1PR0501MB22718F564B8EDE567F1BD8FED1180@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190530000140.C90462054F@mail.kernel.org>
 <VI1PR0501MB22711EFC034FE4C57C62C6B8D1180@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190530030144.GA6051@kroah.com>
In-Reply-To: <20190530030144.GA6051@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [122.179.25.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98b255f3-20ac-403d-80d3-08d6e4b0809b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2462;
x-ms-traffictypediagnostic: VI1PR0501MB2462:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0501MB24624D6A4E1BF9FDC368CA72D1180@VI1PR0501MB2462.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(366004)(376002)(346002)(13464003)(189003)(199004)(2906002)(54906003)(966005)(26005)(186003)(478600001)(14454004)(99286004)(102836004)(76176011)(53546011)(7696005)(6506007)(5660300002)(3846002)(6116002)(74316002)(52536014)(86362001)(446003)(8936002)(6916009)(476003)(486006)(11346002)(66066001)(229853002)(68736007)(66946007)(73956011)(76116006)(316002)(66446008)(64756008)(66556008)(66476007)(256004)(8676002)(81166006)(81156014)(6436002)(53936002)(9686003)(6306002)(25786009)(4326008)(6246003)(33656002)(7736002)(71200400001)(71190400001)(305945005)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2462;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: J0Ozy3eUazuyg/WRS1MdJTcP5LgikbAZzTBQx3u+xeeSCQx7eK5Szr3xqW/QafCRwsktd1cL7Q3r3crqLxO7LtT0LJfhrpWiOfqRw+lT5ZxDSqJxkDot6yC9QJJ5Tts7gvPqSS9sJ2sFbj0yCOEYJUwDrH5apCPhBtA/yByPk4oyRfPMWQRqBeS/C0NBBhETYIegq/qYAdyJii3vdxJHz3KjYy6dxMU60OAR2QVMl55ZzRWl4n99fUYthOtlSeuxKqkQXmCsZFGzBE4jM9GpfE6++o/p2VlG5wzqAVItuMuJ4zuR0h+rYh5cfgd56jcV+p9PpOTee2ITdqOvqrr/WrymuVFA+6rx1orhFm6b1Zj4YdnLU+8jYPj5xB0D8lSZOKnebodcfuTVvz1YqURG4rocdkvVo3xGAOj+yDiXhXo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b255f3-20ac-403d-80d3-08d6e4b0809b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 03:40:04.1444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2462
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Thursday, May 30, 2019 8:32 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Sasha Levin <sashal@kernel.org>; stable@vger.kernel.org
> Subject: Re: Patch "RDMA/cma: Consider scope_id while binding to ipv6 ll
> address" has been added to the 4.4-stable tree
>=20
> On Thu, May 30, 2019 at 02:01:59AM +0000, Parav Pandit wrote:
> > Hi Sasha,
> >
> > > -----Original Message-----
> > > From: Sasha Levin <sashal@kernel.org>
> > > Sent: Thursday, May 30, 2019 5:32 AM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: stable-commits@vger.kernel.org
> > > Subject: Patch "RDMA/cma: Consider scope_id while binding to ipv6 ll
> address"
> > > has been added to the 4.4-stable tree
> > >
> > > This is a note to let you know that I've just added the patch titled
> > >
> > >     RDMA/cma: Consider scope_id while binding to ipv6 ll address
> > >
> > > to the 4.4-stable tree which can be found at:
> > >     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-
> > > queue.git;a=3Dsummary
> > >
> > > The filename of the patch is:
> > >      rdma-cma-consider-scope_id-while-binding-to-ipv6-ll-.patch
> > > and it can be found in the queue-4.4 subdirectory.
> > >
> > > If you, or anyone else, feels it should not be added to the stable
> > > tree, please let <stable@vger.kernel.org> know about it.
> > >
> > This patch depends on another patch [1] in same series.
> >
> > However, these two patches only make sense on the kernels which has
> commit [2].
> > Patch [2] is not available in 4.4, 4.9 and 4.14 kernels.
> >
> > Therefore, patch in this email should not be applied to 4.4, 4.9 and 4.=
14
> kernel trees.
>=20
> Now dropped from all of those trees, thanks.
>=20
> > [1] commit 823b23da71132b80d9f41ab667c68b112455f3b6 ("IB/core: Allow
> > vlan link local address based RoCE GIDs")
>=20
> Note this patch is only in 5.2-rc1, and not in any stable tree.  is that =
ok?
>=20
This feature ('support of VLAN link local GIDs') is practically is getting =
added to 5.2 kernel using these two patches.
So I think its ok to not include in older kernels.

> thanks,
>=20
> greg k-h
