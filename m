Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735DC117195
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 17:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfLIQ1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 11:27:10 -0500
Received: from mail-eopbgr1400131.outbound.protection.outlook.com ([40.107.140.131]:47072
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726477AbfLIQ1K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 11:27:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlRbQegtVViMrVDZeIgg7O5mLWgyB5rj1fEPNT2Pvah4LVoRXJXClIErK2rIm8f9OzxUQ1ke9SONqUsrh6IvQdLIAWzOliSWWd8mxXfBhNXaf69PeQOtBnzUbx1RQzzI5j7ulu30YUMfNf82H9Kay8kTchGJ/mM7NXmZ4X9ogrD+JMnzX3TwLMSSmz1m/sQ+4DhOv/p3zknSUozpGPuTYRlR05U3vx+fMMsYDdCFSJ/YeqrIAZ+KzOUD1o3kTSJYEQEslAnE3sUhnKXD7crdg5KvOWO2yc68NhMzNt5FlILKs7dBsPzdRBf7ottY5NRimFeJH6KRdfpir4iij49bUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0u/LFUrfF+oQzi6o6Vfb5FVmFFJ77Mssgaiw/kLRJo=;
 b=Yh4lUmctSTaHw3rkHKuoswRYCp6v85wKAEpl8MXxlGYHk0EKjurODv1YLM39wAvaZ3FbR7w5k4QFYBQHOuY6zigBtd1SryF84I/9RXW7B2yO2fqX5iAfCgQWzs3PTkST7XHjqeGenjKjoUH4Hxd4l1jw+raY5mBybMTQdThwdoaQHgoFl/CEpIC89dXMizzmfOO8Ij8+Zn7BSXaU3zxkK+LjGRN7L+icoahzoDbrcp4xejLvYsENV3UbpparrNUpd46QXUqIgfW+OAtuNB/4X8og32S3tjYhYwFQwxty7SCKSNN41Xb+owhiNH78MseICxcmsMXPu6nxZp8D3txtTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0u/LFUrfF+oQzi6o6Vfb5FVmFFJ77Mssgaiw/kLRJo=;
 b=MTJf2MsgnhBgwPR+8d20CpOKBbyJkaQ7VXoYZ2daWYvistLwcJ5/kZAfNbPrVIIUyhzwrpKcwLpfEu9KQr3EAUtrAC5vRV0Nmrb1G/+vhuj5vaFD5+VLkRIvsSmAT5RCf5AWKPo1JvOr4oIQwtX+ttQ/itnToqvv7IIgGoRlx6E=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB5166.jpnprd01.prod.outlook.com (20.179.173.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.16; Mon, 9 Dec 2019 16:27:07 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1%5]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 16:27:06 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: Latest stable-review releases?
Thread-Topic: Latest stable-review releases?
Thread-Index: AdWujqTrZLhelHs0Rwe1wAvCU9PFAgABknAAAAVfbzA=
Date:   Mon, 9 Dec 2019 16:27:06 +0000
Message-ID: <TYAPR01MB2285138128BD03F7B5530D2AB7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <TYAPR01MB22853B1C228C3D7A0C35B064B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191209133116.GA1276687@kroah.com>
In-Reply-To: <20191209133116.GA1276687@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0ca8563f-e0b8-44b6-c19c-08d77cc4a205
x-ms-traffictypediagnostic: TYAPR01MB5166:
x-microsoft-antispam-prvs: <TYAPR01MB51665166B3812E16710BCCFEB7580@TYAPR01MB5166.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(189003)(199004)(186003)(6506007)(76116006)(81166006)(3480700005)(5660300002)(316002)(305945005)(26005)(6916009)(66476007)(66946007)(66556008)(71190400001)(71200400001)(52536014)(7696005)(86362001)(9686003)(55016002)(478600001)(2906002)(33656002)(66446008)(64756008)(4326008)(81156014)(8676002)(8936002)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB5166;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jRSS7FwMRFPdnJy/xK/yfxB1GScmvJdwSZQOue5I9TwU2d7pHhricXsQFcCTbqv2Q4xXVmAaBsJHINsUyfHYG1eV/RvGsSDsyDxyO9WRUA3VkN/vtXwZehbJPymaL7hTveWaW/zAUjACbhjxt3bbzZaeLwHRr7gpurLJwsZ1a+VOJ74aO75xlc/+/xdkP36DtVtqSO/TTHwtZTMw97vb6HiDno7v0zS3SqlLxEBqChINwZ35Ej9zV7HhJMRSIFoyT7sTEp9hwZTHLT1DaAnwS7rYJSrssWDOSevKpKMpe2kPtUcFdjlq3EPm+4xPFptuv0gOlnVYV34WuUjoFzR7IbIx8qax6YafuqqWs2YccoUrGt+IDkA9+qoo1sFRuTbve1PB3bbiCpMbazw5jTNq/0k8qRkYRZ6yxLklUPkeAGxm6Ub6NRCj+zhUkboMTCK/
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ca8563f-e0b8-44b6-c19c-08d77cc4a205
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 16:27:06.7956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /zpF4S/NFvcyVoCtTAnuE/Ke2BqqTmgoWjNfC/sh/qTHIertqJeqwdWrdguUiGhxv7KhDm5pLPFzmuFRLLY5xW8f1lZyzVY9EY+ZAV3vFig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5166
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 09 December 2019 13:31
>=20
> On Mon, Dec 09, 2019 at 01:00:59PM +0000, Chris Paterson wrote:
> > Hi Greg,
> >
> > I see that you pushed 4.4.207-rc1 and 4.19.89-rc1 commits on
> > linux-stable-rc at the weekend, but I haven't seen your usual "stable
> > review" emails to the stable mailing list.
> >
> > Am I just failing to find them or have you not got around to sending th=
em
> yet?
> >
> > I ask as I've seen some build issues, but didn't want to make noise in
> > case the next 4.4/4.19 rc releases aren't ready yet.
>=20
> I push things out to the -rc tree when I am at a stopping point, not
> only when I am doing a "real" release.
>=20
> So please, feel free to report errors that you see there, as it usually
> means I think all is good for the moment so I generated the tree.

Thanks. I'll send another email once I've had a chance to investigate a bit=
 further.

>=20
> We are working on making the tree auto-generated, like it is in the
> stable-queue branches at the moment, that will make it a bit easier to
> test with instead of having to wait for me to auto-generate it.

Great.

Thanks, Chris

>=20
> thanks,
>=20
> greg k-h
