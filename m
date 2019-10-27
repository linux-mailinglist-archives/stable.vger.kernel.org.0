Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF2BFE648A
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 18:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfJ0RfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 13:35:20 -0400
Received: from mail-eopbgr680133.outbound.protection.outlook.com ([40.107.68.133]:47687
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727001AbfJ0RfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 13:35:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqZbQLD4DI6j1m0ngB4VVdVRehnO5N9KAKXfGgXqvRsaSk4BN+YsWReTE7+kV77BkMmONufWGZl5AJebMGo0iVSiAF7Q5wV5fNkcRWweLvkAIUa8hJfHxcVj9MbyLJVdFFj1VFMhCJwfU8cmrbbRreUlg6zVF1DhAaZAXYAfws7xgHksd5ULDkhR3mzDXS2m+nR5MOX9qMOpm1Y+Cl3ow8f5l2360BaKKmDEg6/TOT/sXxTm4rIB5C2LAMVKb1AjjXKuUto3gg3SBYDjR8aIEa/K//PtNUO92IrdwsSWZ11YlKaYI++qPD5hY1pDW2mnh4kEkJ/Opv9hR5exCP5m8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+rY8oaCqtuyEKweezaEwjReNdIybp84pwwLStGh6ws=;
 b=Ia/N7D8tGTqPbPR4p2qv61gw7mHQeEU0b6DWCkAeCSXkboz5oCXG6u8QRBIVjMMJokBcv64VImq+qk2+XrLBq5ExWtkXa0QGtflY43OY8Xs/SDUgDV9o6akTwc9uE2gAaWHkTyB8G2oKJvHdIEl87C1w/OdHtSWK5oSuvj5G5/8BCoDaMkT8ZgL3MoHmWKH/Lsey/XWRxuE/QiBTVCE6oJrYxS+EBEXpJHG3vmfeaxTKfunaWlDEpQJ4FsA7+kknOWkYpfh0PLi4lru0k8D+xTodATiyFTHFUFMMPPnqwtiP3jCSlR/1igGDEtJbdl6hGrPKOP6/3rK4YHBZFgAw5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+rY8oaCqtuyEKweezaEwjReNdIybp84pwwLStGh6ws=;
 b=L9NgXVDmqSrxTiFERXKryRRW1/9jigTvHmPViGaBTJH7OxN5SL+ijDRD65HBPYVbw1Z8rpUDDklQSn0YVGD6Ma4zXFJwJISBfmXRDYB1XOMet5cixRt3dsxRGOp/9ewJbkyZ/QhIeRSi4FQBWtWCJDCgOvYlYxrwGewVe9yvBYg=
Received: from DM5PR21MB0137.namprd21.prod.outlook.com (10.173.173.12) by
 DM5PR21MB0636.namprd21.prod.outlook.com (10.175.111.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.8; Sun, 27 Oct 2019 17:35:00 +0000
Received: from DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::9cc3:f167:bb63:799]) by DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::9cc3:f167:bb63:799%5]) with mapi id 15.20.2408.014; Sun, 27 Oct 2019
 17:35:00 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "20191010123258.16919-1-rkagan@virtuozzo.com" 
        <20191010123258.16919-1-rkagan@virtuozzo.com>,
        "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        vkuznets <vkuznets@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: RE: Patch "x86/hyperv: Make vapic support x2apic mode" has been added
 to the 4.19-stable tree
Thread-Topic: Patch "x86/hyperv: Make vapic support x2apic mode" has been
 added to the 4.19-stable tree
Thread-Index: AQHVjOuKTpEe6XJyt0CvpteMqGgCWqduvksg
Date:   Sun, 27 Oct 2019 17:35:00 +0000
Message-ID: <DM5PR21MB01372C3085663526380961FDD7670@DM5PR21MB0137.namprd21.prod.outlook.com>
References: <15721920637928@kroah.com>
In-Reply-To: <15721920637928@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-27T17:34:54.5754120Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0b9dc670-2970-4660-bcf2-75c3d6547ce2;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 260ea6f9-6ea1-4f17-dc00-08d75b03fe37
x-ms-traffictypediagnostic: DM5PR21MB0636:|DM5PR21MB0636:
x-ms-exchange-purlcount: 1
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR21MB063695AEFA82389868135E43D7670@DM5PR21MB0636.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0203C93D51
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(366004)(376002)(396003)(136003)(199004)(189003)(76116006)(22452003)(66946007)(316002)(4326008)(966005)(110136005)(2501003)(66446008)(64756008)(66556008)(66476007)(256004)(6436002)(8936002)(478600001)(8990500004)(86362001)(66066001)(6246003)(10090500001)(10290500003)(14454004)(71200400001)(2201001)(71190400001)(476003)(9686003)(33656002)(486006)(6306002)(52536014)(446003)(8676002)(81156014)(81166006)(11346002)(74316002)(2906002)(305945005)(76176011)(7696005)(53546011)(102836004)(6506007)(229853002)(7736002)(55016002)(5660300002)(26005)(3846002)(186003)(25786009)(99286004)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0636;H:DM5PR21MB0137.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TkxXsq3H+Pr2/EueNn+N8mUFG1Q3fEDAYGZT838QXUey4AJRv1kl1mI1Pm/JV1o8P75ci2BxW+GlOMZNSX+Zds7INVYXp6gDc94YFAAK9H0IpGt+1taF2Q/++aKcW2pXVM5fs0Xu2UiHhYyPzfooiqSg7T6dPgKOsE2yp5AgJF2P0CDGsYlLoLgKOnYVJ2LmTUzWDr+keHqpAPI042QdpEejSw/zAAIQEjDiNk/Phtv+kAqFWzm51La0oFEWvZ3DMb7nUyHvgQ1KDV05fhRMkk3gXHJvZTwxUZcM8F7+kmq6NbFxy/Ad6R2FYEz3ayfSWobVDZglVFD7hOpWk9TC2rylGYMme4IE/AWRwa2nU/htxWHXCmYlkWLX7kKyYj39BQ11HUDMY6G9alIv4EZwmVzAm97FGE2s/aYeuaCB0kcJMi9H35fOv80WIaFxTq3w1AcLPO9AQoDvw3edeM+rwnrV62X2CIbq7DEQzWTqCgQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 260ea6f9-6ea1-4f17-dc00-08d75b03fe37
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2019 17:35:00.2598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QoOaxT69DJCrY8E36QyLeoj7JGMeJcGHrLkxuIUp4bTdWVrC5GxDsHR91TT7J9WzREpu5svyLacF09g5wqEHDF53vbY7cJdFf6sBqhpQK50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0636
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
>=20
> This is a note to let you know that I've just added the patch titled
>=20
>     x86/hyperv: Make vapic support x2apic mode
>=20
> to the 4.19-stable tree which can be found at:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
>=20
> The filename of the patch is:
>      x86-hyperv-make-vapic-support-x2apic-mode.patch
> and it can be found in the queue-4.19 subdirectory.
>=20
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
>=20
>=20
> From e211288b72f15259da86eed6eca680758dbe9e74 Mon Sep 17 00:00:00 2001
> From: Roman Kagan <rkagan@virtuozzo.com>
> Date: Thu, 10 Oct 2019 12:33:05 +0000
> Subject: x86/hyperv: Make vapic support x2apic mode
>=20
> From: Roman Kagan <rkagan@virtuozzo.com>
>=20
> commit e211288b72f15259da86eed6eca680758dbe9e74 upstream.
>=20
> Now that there's Hyper-V IOMMU driver, Linux can switch to x2apic mode
> when supported by the vcpus.
>=20

This patch should not go back to the 4.19 stable tree.  I don't think it wi=
ll
break anything, but there's no Hyper-V vIOMMU driver in 4.19 so
x2apic_enabled() is never true.

Michael
