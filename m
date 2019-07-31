Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A453B7CDFA
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 22:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfGaUNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 16:13:49 -0400
Received: from mail-eopbgr1300098.outbound.protection.outlook.com ([40.107.130.98]:9065
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726350AbfGaUNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 16:13:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=deq9Pt/3j3U2kROzoApAXRAoNiHQJd0BS0s47Ugm82U6KcJ2WK3zpgYBZMDlCXej5YBKMTW6W5npkIxry8buBp0rqKAlmJEu5xsNlujyjlLmFoTgIQ2Ufobr7OQcs4JZRRS1gfQpm44qqmPvkcD9bWqaND42XHrTM2vnT0nkFjtRCIzxc4z3yIHaLcz9xw3VRrcP1AefySLEZgbwxbRgB9k+muIHKh4ZtJHzJJP+nJswxTlAuH5RUgzitWzNLswrVfraZwWY70nOE73AtNKjQVh28kwskK0tj3EnwQAA//6rlflbkNx87rnN3qa5dWynu2bdHouXcIncsxvpGTrvFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qosWRERbK26k8jhKbGcZwq+UG2vLwMYruYW45FO/UXA=;
 b=h8250N09aZKnvrtryg0EpeMxIm2tsLR5TF+pKBYm1puFza5H67mlpAVH5ikan70n6epZfDGHiCU1hy+TYZwiVpN5a0SKP5lUuFs3ayBSS4YijdueqUd93lWAsTONhqvVV7ix0DNoNMu4pslXiR6QleJKXcicy4jqb+LRdYgzgUWjmII51XvPLEqOBjMrykO4CBYSIjhmv8h7yVbe9FSUm/5iXJ4sWEO7Ph95cyjuaUidbux1THI1EtkOdkJNWiK3Y7IaqfrPZLp7keNxePrkF5dx7Qy0IWXDYozUrTWmVBE/2eOBqjDt4WyRjU0zC897EZxc3heMOVkr8pQJipi+Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qosWRERbK26k8jhKbGcZwq+UG2vLwMYruYW45FO/UXA=;
 b=a/ak2kAUayy8sKXIqCAVu8VDKSM0k3we7MckcoAQSZDNI6uXqBR9f9lTH0MrHiZMOFdqZByTgzgc2g33hLZBbHaqh6KN368B/sIawSxJsdOLv+DVkyGhUFK0M7Mp8GFzRqmqmU/wLe8gGLrKyZXuLBHV9yLpNvgVJITQ19jJ6IM=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0105.APCP153.PROD.OUTLOOK.COM (10.170.188.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.2; Wed, 31 Jul 2019 20:13:25 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c%8]) with mapi id 15.20.2157.001; Wed, 31 Jul 2019
 20:13:25 +0000
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
Thread-Index: AdVHaAlBhKMGz6x7RwyqqOSVvoXnvQAGpomAABXrVWA=
Date:   Wed, 31 Jul 2019 20:13:24 +0000
Message-ID: <PU1P153MB0169EE57A6C3022A05C8DCF7BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB0169AD4EB10548EACCED82C2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <20190731093049.GC18269@kroah.com>
In-Reply-To: <20190731093049.GC18269@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-07-31T20:13:22.8665625Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=914006ba-277c-47c3-864c-37da956ddf6e;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:a:f5f3:9fbf:7c84:318e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ad29961-f077-47ed-a39d-08d715f38b1d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:PU1P153MB0105;
x-ms-traffictypediagnostic: PU1P153MB0105:|PU1P153MB0105:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB010573C37407101CBBB6F40DBFDF0@PU1P153MB0105.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(189003)(199004)(71190400001)(6246003)(256004)(22452003)(5024004)(74316002)(316002)(229853002)(81156014)(33656002)(54906003)(14444005)(6436002)(68736007)(86362001)(446003)(486006)(478600001)(46003)(71200400001)(66446008)(66556008)(53936002)(66476007)(55016002)(76176011)(9686003)(7696005)(476003)(66946007)(186003)(6116002)(81166006)(14454004)(2906002)(99286004)(10090500001)(7736002)(5660300002)(6916009)(305945005)(64756008)(4326008)(6506007)(11346002)(25786009)(52536014)(102836004)(8990500004)(76116006)(8676002)(8936002)(10290500003)(72063004)(87944003);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0105;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: F+zOSQAtB45eb+wEG65LeoMPid0k3SosqcQBHt5WQZrM8eR/beCb6VkkOwtEfMFGQs3aoJyJGQtCKBTU2wje4evvhjWpIhuYJeiOrOBt0+PpdU+RCo9ywCau0lcNWBwo5hOIE4r7lQF5Bk56o23rQPQHkxq1mqYhMh4E+Y1SgW8Bm+QG4wNGsvpbrvI2oV9NBojazruMPX2OpzIYnsie1QEH9YystT1vBxKjGeGKwzWk4fiQJTEC6YGiWUhCTfCqKSP+oz8EfOC6pqMGvDFx6OJGGYlTqEw1djSnLTHpTtfiDpnNLcXiZpJvwoXismjT/JU8tKLy3nEdpOFHakrUB6I5DqV4LtYZo/GlI9tT/JV2JX2vYROFTQ8DYX1qbxs45zo75uOjgCzbGS3x8+n9QWmFdePxrtAEa77i16WNsbY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ad29961-f077-47ed-a39d-08d715f38b1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 20:13:24.7838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S3lGldg+cWPBmu/9WjaA6cAjssGSQRDz083um8LzUPLbvNXHJenUKBJ3sEk32IAmR30eczpMnO1zGDZeZp/c7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0105
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Wednesday, July 31, 2019 2:31 AM
> On Wed, Jul 31, 2019 at 06:41:10AM +0000, Dexuan Cui wrote:
> > For linux-4.14.y (currently it's v4.14.134), 4 patches are missing.
> > The mainline commit IDs are:
> >         cb359b604167 ("hvsock: fix epollout hang from race condition")
> >         3b4477d2dcf2 ("VSOCK: use TCP state constants for sk_state")
> >         a9eeb998c28d ("hv_sock: Add support for delayed close")
> >         d5afa82c977e ("vsock: correct removal of socket from the list")
> > The third patch (a9eeb998c28d) needs small manual adjustments, and plea=
se
> > use the attached backported patch for it; the other 3 patches can be cl=
eanly
> > cherry-picked from the mainline, in the listed order here.
> > Note: it looks the first commit (cb359b604167) has been queued.
>=20
> I have not taken 3b4477d2dcf2 ("VSOCK: use TCP state constants for
> sk_state") for 4.14.y as it doesn't look like you really needed it.  Are
> you sure you did?

For linux-4.14.y:
  Without 3b4477d2dcf2, there would be a conflict when we apply a9eeb998c28=
d.

  And, without 3b4477d2dcf2, I think actually we should not apply:
  c9d3fe9da094 ("VSOCK: fix outdated sk_state value in hvs_release()"),=20
  but c9d3fe9da094 was already applied into linux-4.14.y on Feb 25, 2018.

  I just checked 4.14.136-rc1 and found 3b4477d2dcf2 is queued. This is gre=
at! :-)

  So the only missing thing is: we need to cherry pick=20
    a9eeb998c28d ("hv_sock: Add support for delayed close")
  onto 4.14.136-rc1.
=09
> The other ones are now queued up, please let me know if I have messed
> anythign up.
>=20
> greg k-h

Thanks a lot, Greg!

Thanks,
-- Dexuan
