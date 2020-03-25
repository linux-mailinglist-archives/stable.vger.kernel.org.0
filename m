Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF0C1930BC
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 19:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgCYS5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 14:57:19 -0400
Received: from mail-eopbgr640117.outbound.protection.outlook.com ([40.107.64.117]:61344
        "EHLO NAM06-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727174AbgCYS5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 14:57:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARBryghX9/ZVsg4QeyaXxIKyu6HjDKnaiPXJ1sC/HHOBYKnkPCvpVTU7R/p1dCN8YW3UKkHax/XGsMEJeWM7zi5nItK60r/h6ERe4TSYwz5+jyynAZUNRLtoF0als0vlLmGxGzNNVYNjy8/uJtm+krSzxt7jPzxBWttE6/jU6bji9ww0o1KT/mztjsJ0jPtLu++d19hf1P/5VdVxsYE2Kzh+huVhyQD1tDLT63U+vNKVmwp+F9waPagvyWr0heN7+Yh5SIR3RVrzcCBJYggpOZe7+TxU6MofKL7pxzNqybhAuPt3eTtHbWQGzLmAslKvh7VXU8w0uQsGhu0Bj5QLwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3xQMZjgnXIoznaTQ2ZjFwI9qzbGqPiKDFlnvoCavqU=;
 b=Gel4eWE6LqMBERrA766t5uH1+KS2O8O3ffX9Wqe1fwKaoHQcUWCWmJY8m3QHZ0JZxFdWv8GQ5xnCA1uKCGI6f7pMhnGfKSFp6gs/fQOvaZhpNj+G424Msdl1LDgffHQuw84xZ2I+L+NSnXNUh2IP3nn0oGwv0KLGe8j+0Lz+i0HcU+URV47ZxPnxg5rWxBnSaVpe3kDr0STZFh5jylIHzjkFohjWR2cHyBEVcHiJKLR8qdMS7hzPaVy8dUkB3a3YJ/ET8Y4GkTfEeM/WZDaOX+7+2zRfg0FwtIVcj6/A3z/VFDjIrdHWy6TF3p2lwyYKqklhRLBdWKbWe2PBg22sXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3xQMZjgnXIoznaTQ2ZjFwI9qzbGqPiKDFlnvoCavqU=;
 b=PU2azbUl3glTHjHPu6r8T465bQVVwy9bW4w381XNzAR2rGzS74WjbbDHPtMfCh8BltHBlOvDfFc4pG1cPBBXzxQ9EbT69MV5C2KYrnwPdIx3HEQsgVtAf2vABtqIBcemikvpibWOA2dIeyLV+Z4kcLXoQWFYUgrSAM0FBWvRTJ4=
Received: from DM5PR00MB0424.namprd00.prod.outlook.com (52.132.129.36) by
 DM5PR00MB0374.namprd00.prod.outlook.com (52.132.129.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2897.0; Wed, 25 Mar 2020 18:57:14 +0000
Received: from DM5PR00MB0424.namprd00.prod.outlook.com
 ([fe80::f922:ae66:e64:e8]) by DM5PR00MB0424.namprd00.prod.outlook.com
 ([fe80::f922:ae66:e64:e8%8]) with mapi id 15.20.2897.000; Wed, 25 Mar 2020
 18:57:14 +0000
From:   Yubo Xie <yuboxie@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>, Yubo Xie <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <liuwe@microsoft.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Michael Kelley <mikelley@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: RE: [PATCH] x86/Hyper-V: Fix hv sched clock function return wrong
 time unit
Thread-Topic: [PATCH] x86/Hyper-V: Fix hv sched clock function return wrong
 time unit
Thread-Index: AQHWAtWohpE1hUqs8UCHxUmnqp3mpqhZpyww
Date:   Wed, 25 Mar 2020 18:57:14 +0000
Message-ID: <DM5PR00MB0424FA0EC96382D3B6D2D269B4CE0@DM5PR00MB0424.namprd00.prod.outlook.com>
References: <20200324151935.15814-1-yuboxie@microsoft.com>
 <HK0P153MB0273AEB3D64694E8DF31C0B0BFCE0@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <HK0P153MB0273AEB3D64694E8DF31C0B0BFCE0@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-03-25T18:46:05.1806297Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5f141aee-3c29-4a29-a518-1eaaf4ed75fb;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yuboxie@microsoft.com; 
x-originating-ip: [75.172.59.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3ad7d72d-1c37-434e-22a1-08d7d0ee551e
x-ms-traffictypediagnostic: DM5PR00MB0374:|DM5PR00MB0374:|DM5PR00MB0374:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR00MB03745532233037DA05417E04B4CE0@DM5PR00MB0374.namprd00.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR00MB0424.namprd00.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(71200400001)(107886003)(110136005)(9686003)(33656002)(54906003)(66946007)(4326008)(66446008)(64756008)(66556008)(66476007)(76116006)(7696005)(6506007)(53546011)(8990500004)(2906002)(26005)(4744005)(81166006)(10290500003)(86362001)(52536014)(5660300002)(6636002)(186003)(8936002)(478600001)(55016002)(8676002)(316002)(81156014);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 31KFDhsa2O0CnGFjxi2JmYr/bfe2tKdZa9xF4f6maFNZTvqZMxv9i+uxpOtUx2P352wWGvdz83/sq5XIlV11ERBh90N3IcAQwK5Khtp6GnUOHtcOsZ5eLt5x0dLLVWULNqL9IYiFVdU6DfGBvABWJnX7MMw7YuIE7xhqj9mYCZ3e/ao34XRdPVxHwO2Xqe/zRiuPBGeHB5d+byV0KflPxrRPLj6L1G4t95IvPIVMACPQw0dUKz5z29U7/bx540xU45QBS+JpbkCH23zaw+my0mIpx9xFZFCCtN4sm/Dm7VIAZRNkMftuwGqZwuk/Uo71bjHmw6rOBdyc4GrmBps1CS6B21G543HEi6tGpWoteKxkfanu8+pgasGuE12s1C+hvhg8Hz4rvPAsWa/qkv3NzUx60inGfunWRfnWoswqvr/QiCWpcaW3CU+8zWVXHDM+
x-ms-exchange-antispam-messagedata: 3pI+SWMgZms1UtEpH7bpUUKj2DfPUZDNMPjSMm1oViEz/j7RRN66noQojyLLfBAVRDXH79a7Aba39JCjNMf9fSD2YxQxAt1M0kwVM749iPe9ZL2ijuEOU87ycQIEW8mZeE6XkfZXgw8h2aOMEQHg2g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad7d72d-1c37-434e-22a1-08d7d0ee551e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 18:57:14.3787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3SE85t9Yp+R4gbOBmDZBv0RZmE1HinfGmgg2/J2YvI6yl4duFWjv0TR7Fli9diG//pQHn4ObzNWFtAkzYhi97w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR00MB0374
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I use "time" to run some performance tests in our project under WSL2, but t=
he result looks weird:  the value of "real" is far from the sum of "user" +=
 "sys".

-----Original Message-----
From: Dexuan Cui <decui@microsoft.com>=20
Sent: Wednesday, March 25, 2020 11:46 AM
To: Yubo Xie <ltykernel@gmail.com>; KY Srinivasan <kys@microsoft.com>; Haiy=
ang Zhang <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.c=
om>; Wei Liu <liuwe@microsoft.com>; daniel.lezcano@linaro.org; tglx@linutro=
nix.de; Michael Kelley <mikelley@microsoft.com>
Cc: Yubo Xie <yuboxie@microsoft.com>; linux-hyperv@vger.kernel.org; linux-k=
ernel@vger.kernel.org; vkuznets <vkuznets@redhat.com>; stable@vger.kernel.o=
rg; Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: RE: [PATCH] x86/Hyper-V: Fix hv sched clock function return wrong =
time unit

> From: linux-hyperv-owner@vger.kernel.org
> <linux-hyperv-owner@vger.kernel.org> On Behalf Of Yubo Xie
> Sent: Tuesday, March 24, 2020 8:20 AM
> ...
> sched clock callback should return time with nano second as unit but=20
> current hv callback returns time with 100ns. Fix it.

Hi Yubo,
I'm curious how you found the bug? :-) Did you notice some kind of symtom?

Thanks,
-- Dexuan
