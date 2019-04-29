Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881F7DFAC
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 11:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfD2JnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 05:43:05 -0400
Received: from mail-eopbgr30065.outbound.protection.outlook.com ([40.107.3.65]:39966
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727351AbfD2JnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 05:43:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGmhtoCInpdJc5w5MtO0/uyytlqI1v7l3X8nY4+Mtug=;
 b=CyWtDdwzjBcMS3ecvfS1gT9mi2FMEV3sr5a4wZQbrK7XZt1Zt29BY7l0Vj5wdfaZVO6JYW3hDEpPnWY3T0TyhWDuICLTt5RgQ0+g+iFZMZMSmQNtIPrdeFiD+rdL5g5Eb94mab7zRTMMe78zW0GscnKOojk8z91cmtj0TAkDIRA=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.186.14) by
 AM4PR05MB3508.eurprd05.prod.outlook.com (10.171.190.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Mon, 29 Apr 2019 09:43:01 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::edfd:88b8:1f9e:d5b1]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::edfd:88b8:1f9e:d5b1%7]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 09:43:01 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: Re: Patch "RDMA/ucontext: Fix regression with disassociate" has been
 added to the 5.0-stable tree
Thread-Topic: Patch "RDMA/ucontext: Fix regression with disassociate" has been
 added to the 5.0-stable tree
Thread-Index: AQHU/mutNqHW6rzKRUyj5tXmPMQ9VKZS3l+AgAAClICAAAIQAA==
Date:   Mon, 29 Apr 2019 09:43:01 +0000
Message-ID: <20190429094258.GV6705@mtr-leonro.mtl.com>
References: <15565291094471@kroah.com>
 <20190429092621.GU6705@mtr-leonro.mtl.com> <20190429093535.GA317@kroah.com>
In-Reply-To: <20190429093535.GA317@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR02CA0013.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::26) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.138.135.184]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 275253a5-2354-4f7b-79e9-08d6cc871196
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3508;
x-ms-traffictypediagnostic: AM4PR05MB3508:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <AM4PR05MB3508FDC4DF278335E711807EB0390@AM4PR05MB3508.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(39860400002)(366004)(346002)(376002)(396003)(189003)(199004)(1730700003)(81156014)(7736002)(8676002)(14454004)(6306002)(476003)(2501003)(97736004)(256004)(6246003)(86362001)(81166006)(66946007)(66476007)(66556008)(446003)(6436002)(9686003)(2351001)(99286004)(66446008)(64756008)(73956011)(966005)(76176011)(52116002)(305945005)(11346002)(4326008)(3846002)(53936002)(486006)(6916009)(478600001)(25786009)(6116002)(5660300002)(71190400001)(71200400001)(102836004)(66066001)(316002)(386003)(6512007)(6506007)(68736007)(186003)(229853002)(8936002)(1076003)(6486002)(54906003)(5640700003)(33656002)(26005)(2906002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3508;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BeXs86LTGmbQWQxj42SbhAbZJEYQFgvZW/BEUcOFq0rvIJpU0LzRdxzy+bbl/4W0Q6zEHOUmV/H0lUjIxb/2ytJN3GE0oK/oD4KD4jzD+vl4plMDcq3NRy8TNlK+llg0GrbWYrpXrAMZJYlXHNc8+i7aolBiD1yxxXg1DQEBX+ITT6ewOXVDQfwxzCv0tdhqXy0Ybok2UZDKLl/dt2n0BrJeFf3e6oNMBqV4gicWSPZU/qlheYgHdUzN0elijyP9+/2EunnqRHjqfZG9x9X6rzWqqf9z+QHi/SooUitnVTn5PBWwXAkzWPq7mcTzFU5NdVu7008uGkOXRo13QufESRBjvXF4o+N05NgEJBMGksUlTqMs9+YhP4PuCJ/dvXuccGYwED3nub8BNN+Zf6UXJgwDP4Vs+wwavN2+3R4GB+I=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9E63FBD8C60A7A4FB5F4FF1D0712E022@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 275253a5-2354-4f7b-79e9-08d6cc871196
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 09:43:01.0517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3508
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 11:35:35AM +0200, gregkh@linuxfoundation.org wrote:
> On Mon, Apr 29, 2019 at 09:26:24AM +0000, Leon Romanovsky wrote:
> > On Mon, Apr 29, 2019 at 11:11:49AM +0200, gregkh@linuxfoundation.org wr=
ote:
> > >
> > > This is a note to let you know that I've just added the patch titled
> > >
> > >     RDMA/ucontext: Fix regression with disassociate
> > >
> > > to the 5.0-stable tree which can be found at:
> > >     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-que=
ue.git;a=3Dsummary
> > >
> > > The filename of the patch is:
> > >      rdma-ucontext-fix-regression-with-disassociate.patch
> > > and it can be found in the queue-5.0 subdirectory.
> > >
> > > If you, or anyone else, feels it should not be added to the stable tr=
ee,
> > > please let <stable@vger.kernel.org> know about it.
> >
> > Greg,
> >
> > Please be aware that this patch has compilation issues on s390 platform=
.
> > https://patchwork.kernel.org/patch/10920895/#22610993
>
> Is there a fix for this in Linus's tree anywhere that I can pull in?

Not yet

>
> thanks,
>
> greg k-h
