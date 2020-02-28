Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1C8173204
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 08:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgB1HrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 02:47:07 -0500
Received: from mail-db8eur05on2105.outbound.protection.outlook.com ([40.107.20.105]:5345
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726740AbgB1HrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 02:47:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hGHHlHnCGX1bLvyjvSvjK1ltkRD6ttEjLatiwMycRpPUDimwtBV4nPRwpbhLBfuuuX+q+xCZRl3kZSsoIkK4p0YCfMbVKcH5PAlzB6/G9lM3TYcxgudLj8K+4Hlb0ElSfADOgESUx6Clr1TndKLc1RzkrjAxepfx1fP5tYNKphUrM+dTw3lvwZB2ZiwF49+PWTk0SUykOpwWZHLrWLtuNrxjabi5o4pGci3mFjGwHwuAVPsF2TbFfigskaeZAbhkp/KfwXqoTSoCsfCbGrHTiSxJtTWkAyJpiKI5sBWDtPvwopWnO2lGBP9Lk/9SWMKmDegjY0UUwL6u2RIWAekVWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoVQtPxD/EcCSjDmboQFmn0zmWFBkmyNSN7YLbodweg=;
 b=nCi6466wJoeNWcxcfQumE8uqFdf2FisjlOeXsSLtEiWXNZqwdbMJqG/U7Q5oQM+Ba97+oGtUEJOu+FtoiysTUH7N8Y4FQYD37ujEf2tX+SysDQJJtPS13ZdIn4APpNKyoOeQkfr9J9pFBkyHD6fg0p06WPy9AF1NOJ8EP2f7egy+xvTgR7IFtSYO6p5FMqSgM9enKYXRWNKo0i9MqnVcrv1TjRD4Z535BETdxn9al3RVCIww7QWMiLv4oE0iGf+hrwuBzYiEbK2S2S9BtQJ7FjAJOeLM0dteQGw5Vd2aXtOe3cURQnY6Jh5TcpmTlV3f9IKS+vfPL8PDi+b4Upkc+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoVQtPxD/EcCSjDmboQFmn0zmWFBkmyNSN7YLbodweg=;
 b=N3/RaNpwSACU2SBc2PlbmRz1FposqTYzko9EziMsc12LTBljH6UL5SIOsshz+COP2PPnFIh6lz0IbHEUJbzQxlNY8i/Y3IVsrZeFx4ZypDK1uze9wMHG9g4QCjFgLSlr74WQXRAC+IJuN7hiXoWmOpM7v0s0yLhZ3JwUjy7CYWA=
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com (10.167.127.12) by
 HE1PR0702MB3707.eurprd07.prod.outlook.com (10.167.126.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.9; Fri, 28 Feb 2020 07:47:04 +0000
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87]) by HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87%5]) with mapi id 15.20.2793.003; Fri, 28 Feb 2020
 07:47:04 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "ravi.bangoria@linux.ibm.com" <ravi.bangoria@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 4.19 "perf stat: Fix shadow stats for clock events"
Thread-Topic: 4.19 "perf stat: Fix shadow stats for clock events"
Thread-Index: AQHV7gtEBHNsBWH66E6Id4iZ5KeqKA==
Date:   Fri, 28 Feb 2020 07:47:04 +0000
Message-ID: <191de78a6356926ed080b67be0b79398c5f57915.camel@nokia.com>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tommi.t.rantala@nokia.com; 
x-originating-ip: [131.228.2.19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4a57a83e-0bfe-4bb3-b3c3-08d7bc226757
x-ms-traffictypediagnostic: HE1PR0702MB3707:
x-microsoft-antispam-prvs: <HE1PR0702MB3707FD78920DEB63D5543EE0B4E80@HE1PR0702MB3707.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0327618309
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(189003)(199004)(66556008)(66476007)(4744005)(2906002)(66446008)(64756008)(71200400001)(5660300002)(4326008)(76116006)(36756003)(66946007)(81166006)(110136005)(26005)(6506007)(86362001)(81156014)(8676002)(8936002)(6486002)(478600001)(6512007)(186003)(2616005)(316002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3707;H:HE1PR0702MB3675.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jp9bhWFKWSQPWg3azUhEvqf8Mo4LaJVM/uvHvrYX9O31YY7Gmep6h/7F0xa+ZBaevRHoHadzi0eZ7A1nEgT9DKUEzyjeY3khHcJcUoRSJoKqlbQWFg1SMDEaZfvCpokxG+wGkBSILSXmIU16buzd5eB8FsP58H5cExIgztt9Fs/Vk8of6XpACoN2WDAsywIyMvvN7AyEY1KHoAVveu6aflXJTC0YqDFBVNycAeh51U95CkQC+NSN/jtcrmGZKxgE+ACGpxkprAMOiVw7ZD7SbkICy96hd/iLQHEuyMhlW6UykFoUp55kLzilKa94w6j5Y9maHMxXln+JoSt1uxN2rbJgKRoQpOM2ExPif3COChQTwZf4A6psetKgnrypjiPVOOhVYCbKC21Ro2R7/ooqcIAe5FxEUcR83lOwCU57Hgk0Sqrorfo7NiSZCOBofGOa
x-ms-exchange-antispam-messagedata: YXti1NQbUcDAAdE3QQ/Z8rD8AIDYA3pZCblE2s7BA4x4KVdM+bRz5J/+tSXo6eJ9y2Bsw714sL/fR8soHnVa6ZTWaufUuquOfHdLb/FrQrER6Pmv7UJhwAy4XiiuyCdLyC1V5o1Fdie8RCkrSCmsKg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <44CBBB85855AFD45835E5BEEE9FC4BE3@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a57a83e-0bfe-4bb3-b3c3-08d7bc226757
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2020 07:47:04.3905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rgrnPSKIFrfhTxeYYFpQE9xHK0fKRGowR01lrjIkjx5hmsDGXETiGsHoEGSIW3LLO7bgZ2jnwNeO9HEPoqXL6DySD7EUmIEPWUCrVMf7TnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3707
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywgU2FzaGEsDQoNCkNhbiB5b3UgcGxlYXNlIGluY2x1ZGUgdGhpcyBwZXJmIHN0YXQg
Zml4IHRvIDQuMTk/DQpUaGVzZSB0d28gY29tbWl0cyBuZWVkZWQ6DQoNCg0KY29tbWl0IGViMDhk
MDA2MDU0ZTdlMzc0NTkyMDY4OTE5ZTMyNTc5OTg4NjAyZDQNCkF1dGhvcjogUmF2aSBCYW5nb3Jp
YSA8cmF2aS5iYW5nb3JpYUBsaW51eC5pYm0uY29tPg0KRGF0ZTogICBUaHUgTm92IDE1IDE1OjI1
OjMyIDIwMTggKzA1MzANCg0KICAgIHBlcmYgc3RhdDogVXNlIHBlcmZfZXZzZWxfX2lzX2Nsb2Nr
aSgpIGZvciBjbG9jayBldmVudHMNCg0KDQpjb21taXQgNTdkZGYwOTE3M2MxZTdkMDUxMWVhZDg5
MjQ2NzVjNzE5OGU1NjU0NQ0KQXV0aG9yOiBSYXZpIEJhbmdvcmlhIDxyYXZpLmJhbmdvcmlhQGxp
bnV4LmlibS5jb20+DQpEYXRlOiAgIEZyaSBOb3YgMTYgMDk6NTg6NDMgMjAxOCArMDUzMA0KDQog
ICAgcGVyZiBzdGF0OiBGaXggc2hhZG93IHN0YXRzIGZvciBjbG9jayBldmVudHMNCg0KDQotVG9t
bWkNCg0K
