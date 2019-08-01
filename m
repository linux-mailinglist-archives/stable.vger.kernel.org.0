Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220907E01D
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 18:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731486AbfHAQY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 12:24:28 -0400
Received: from mail-eopbgr1320137.outbound.protection.outlook.com ([40.107.132.137]:7168
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727024AbfHAQY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 12:24:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbHVJS0NLPbJE1jiy0aorNiRMWl6uijt5CleS35BSs0Jv4YOa8+2uAii6TMm71LS1NQy8Ks1rg7IiUylkg4H62lJ2ISI46yqHPTI/XbzlDHKsN7v3sbdOVyghRdrcoIsFoeUxPzEtF0g7wExNV/HeloqYu7jCmn/HdyYcaeTLGrdh9WBMt2KYTQ7Dtlehy+ypAeauJ7apshpBJ4AgJUf7KINqZFB7gs0lI+Zz7yZQcp2xaU5XrA6V9FjMLe/i4ATsirr5wNokde8m0wpD7/DSu061UqxtVqeqb7q49glaqFc14X1GQUItYClcDthPGUFMEARqnZOVsk51DWvxMzU/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Shw4srQVUNKeRFMpKTf06N6wPFzL7+iqFI8zKBI+xFE=;
 b=aUk2uKuBv42ymh7t9gOeYjN6WbCwLgEHEX99X/8zrkxyQeGuCWIgSQK5Eow4NX7TZfnU2gtNSUNge/PK3nEpsdrXb2qu1OZ3dX3juAjbOxeyODfOSLohQQUC9CkKTwY7CGqJm3vmeShsmQvyhXZ5zc1ZV8uFWpiKDqjJD/LwV4FZprP3ODK4Y7qaDe0b6UyNR/Ul6Y1WqiuYS2M/XZ36gaw4JjMbAKbR5KlvQndagN68kWIRCy/pzp4zEENgzfsOO4fIj8rEDBMCYBNk71cyVPpdyp1m+BQJSg+k7C7fCTAJUJgCIWBNpsfX4DvnJvYQF6s0VizrJClY+PjLkDpOow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Shw4srQVUNKeRFMpKTf06N6wPFzL7+iqFI8zKBI+xFE=;
 b=l5mq+7gwvidB2mO/KQqfVpVCURa8lHlLcfZUqyD1v9QcZwBt6bGkd0GqLvtLZjgxW8dqK3MgF1+NEoXkwsCw0vgbj5hz4sJ+czpqUx3LMcMO2t277RjUcakLx6Z0MvB+WeRFEcNVf+OwsFEPFYS077iD+xV66AYlnssW9lKWrGQ=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0153.APCP153.PROD.OUTLOOK.COM (10.170.188.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.2; Thu, 1 Aug 2019 16:24:07 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c%7]) with mapi id 15.20.2157.001; Thu, 1 Aug 2019
 16:24:07 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: RE: Request vsock and hv_sock patches to be backported for
 linux-5.2.y, linux-4.19.y and linux-4.14.y
Thread-Topic: Request vsock and hv_sock patches to be backported for
 linux-5.2.y, linux-4.19.y and linux-4.14.y
Thread-Index: AdVHaAlBhKMGz6x7RwyqqOSVvoXnvQAGpomAABXrVWAAFcINAAAU+zSA
Date:   Thu, 1 Aug 2019 16:24:07 +0000
Message-ID: <PU1P153MB0169AC6D8E46BC6DB7B28C01BFDE0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB0169AD4EB10548EACCED82C2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <20190731093049.GC18269@kroah.com>
 <PU1P153MB0169EE57A6C3022A05C8DCF7BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <20190801062126.GC4338@kroah.com>
In-Reply-To: <20190801062126.GC4338@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-01T16:24:04.8784638Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=edfbb18a-20c8-4f8a-ab1a-3306d88e085c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:0:bd98:1395:3c14:560a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9861371-5805-4289-fb7b-08d7169cad65
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:PU1P153MB0153;
x-ms-traffictypediagnostic: PU1P153MB0153:|PU1P153MB0153:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB01539B27ABC33AF61BA3B4A2BFDE0@PU1P153MB0153.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(189003)(199004)(66446008)(8936002)(66556008)(52536014)(64756008)(76116006)(81166006)(99286004)(8676002)(81156014)(5660300002)(66946007)(7696005)(33656002)(76176011)(7736002)(86362001)(25786009)(316002)(6916009)(4326008)(54906003)(66476007)(22452003)(6436002)(46003)(53936002)(9686003)(55016002)(476003)(486006)(446003)(10290500003)(11346002)(186003)(74316002)(6246003)(14454004)(478600001)(305945005)(256004)(14444005)(102836004)(5024004)(229853002)(6506007)(68736007)(8990500004)(71200400001)(6116002)(2906002)(71190400001)(10090500001)(72063004)(87944003);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0153;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bJVhrj/JSeZNdn85VlwESC2hc65GuUo/555xa0XUK9+4KTWHZdPO4qsTHpfaZl4cafR7CaTSHMvhVkIiyiinkEjZQ0pL70FIftTTx24XQQQZA41U03FLVnzs3zfPARyte+M5g4yQzTOo5KKL/ZNfMrBt9ap9tGaNdN9ej73dCBggLIj1i6UImSw1DTHbY8bFCK6B7MuODlF4fviFYDkdk1e8u7OhVYLco+RbfrhmUh2nGh4wVj29FqD54UEpNRJLrqrAR6JHg0LZ8DToJekwAYZpmMpoEh5biKiwzOOtXEbEJXCie7lPJ8gxJztvG0C8UyCIGT41aTcHVMrSZN17tizWPVpbJGdmaI64pUQ9OsytyR5BtcZGYHtR935yiVDans6EuXMH5AUS019dX0bq2u/oPQNgO4y+XyivYKPIwvg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9861371-5805-4289-fb7b-08d7169cad65
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 16:24:07.2677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9yc8/E8HSk897SJPowg5K9jf/aYhGKLUlAE2XkEgRh4FguaekIBWG/CgTqzmiQ6DzTu+ceVx2tXoaVYGPScOfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0153
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Wednesday, July 31, 2019 11:21 PM
>=20
> On Wed, Jul 31, 2019 at 08:13:24PM +0000, Dexuan Cui wrote:
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Sent: Wednesday, July 31, 2019 2:31 AM
> > > On Wed, Jul 31, 2019 at 06:41:10AM +0000, Dexuan Cui wrote:
> > > > For linux-4.14.y (currently it's v4.14.134), 4 patches are missing.
> > > > The mainline commit IDs are:
> > > >         cb359b604167 ("hvsock: fix epollout hang from race
> condition")
> > > >         3b4477d2dcf2 ("VSOCK: use TCP state constants for sk_state"=
)
> > > >         a9eeb998c28d ("hv_sock: Add support for delayed close")
> > > >         d5afa82c977e ("vsock: correct removal of socket from the li=
st")
> > > > The third patch (a9eeb998c28d) needs small manual adjustments, and
> please
> > > > use the attached backported patch for it; the other 3 patches can b=
e
> cleanly
> > > > cherry-picked from the mainline, in the listed order here.
> > > > Note: it looks the first commit (cb359b604167) has been queued.
> > >
> > > I have not taken 3b4477d2dcf2 ("VSOCK: use TCP state constants for
> > > sk_state") for 4.14.y as it doesn't look like you really needed it.  =
Are
> > > you sure you did?
> >
> > For linux-4.14.y:
> >   Without 3b4477d2dcf2, there would be a conflict when we apply
> a9eeb998c28d.
>=20
> Didn't happen, look at the tree for proof of that :)
>=20
> >   And, without 3b4477d2dcf2, I think actually we should not apply:
> >   c9d3fe9da094 ("VSOCK: fix outdated sk_state value in hvs_release()"),
> >   but c9d3fe9da094 was already applied into linux-4.14.y on Feb 25, 201=
8.
> >
> >   I just checked 4.14.136-rc1 and found 3b4477d2dcf2 is queued. This is
> great! :-)
> >
> >   So the only missing thing is: we need to cherry pick
> >     a9eeb998c28d ("hv_sock: Add support for delayed close")
> >   onto 4.14.136-rc1.
>=20
> Now queued up.
>=20
> Can you test all of these to verify I got it right?
> greg k-h

I checked today's linux-stable-rc.git and now we have all we need.

Thank you, Greg!

Thanks,
-- Dexuan
