Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA963421F5
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 17:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhCSQdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 12:33:09 -0400
Received: from mail-db8eur05on2088.outbound.protection.outlook.com ([40.107.20.88]:65280
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229936AbhCSQcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 12:32:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0Rq3i9snEaNsWW+y6X1Mgrcr8i10NS5kKjjZWGg/IG2Jdn32li7jQTSzmrv1RjRbPn3zliPUQY3Yxn/ahxJ/VH+u/mV3UGUk6Jzr6EMMK/9E6PMqTXa0yxh//bMmNGK8evdC3Qh9Ea7fKFk9w2Kzgd7vpe7xDMyA66+fOLsa5vWTW7Lrd6xNvDRHm5DbvXC1T7YLBru4/bBfNzypsBS3G9C5vKjXXfY01C9izIOTP/yklAZAZE5Bold+RCosyarYWgCbDGVGMHYv34Zada1L/zRlpiMsRAgQAFvsbAkcMHNFs4EAJbaH/0g+mtxX3gyLiML4bn22Rg3vv7aW45uwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xUxkN2foFoJ3jPRYqb3AiD7siQPl+POhG1XR7MPxQA=;
 b=RtFRm6tJGDaC+qbE5J44DWU1wsuAYnOLVIA8/f3eyBJVkhY2dP7aE7pV5wOvqxlcuNCR25W0TKUnskW9auSikI+eVSXqGtoxjuI226zVLQ698AOH6bhV/iYp1fprwPeIxJZ1D1a60m0HOhufhacbziDlfWKb/w+FWw9/61GvQKRBhLkUUJj8owejld4D5B4i4GB2WKIqAgBUPIHW7LBJuXRrZ1F93AudbfTe3FqdRo2+M7Xva0uNPVbleP68l5Odp4Tn3Y8u/juuRP8pex43rg2L75O22RTTDYEEis9Tur16A8LWa0rYRcQ+HfM5x3d6ShoNa30OdE9c+WHqm2UIPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=diasemi.com; dmarc=pass action=none header.from=diasemi.com;
 dkim=pass header.d=diasemi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=dialogsemiconductor.onmicrosoft.com;
 s=selector1-dialogsemiconductor-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xUxkN2foFoJ3jPRYqb3AiD7siQPl+POhG1XR7MPxQA=;
 b=x73bZd9Gto4PrVKI6+1V6Z+qvdC39CrixjVzAqRqZw2NRLL2FljTUyXh38KKyFv0HxqKlG6EvikSqz7ttwFOEApR+Pe1B1zgDFQonPv5Eb+r/T5+IZWNZsdY7UedohI1GcTSomQzm78iirCd09oRKUNJ1s9LvyEuOVXcinQuwtQ=
Received: from PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:ac::5)
 by PA4PR10MB4527.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:10f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 16:32:45 +0000
Received: from PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::7040:2788:a951:5f6]) by PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::7040:2788:a951:5f6%6]) with mapi id 15.20.3955.023; Fri, 19 Mar 2021
 16:32:44 +0000
From:   Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
To:     Badhri Jagan Sridharan <badhri@google.com>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
CC:     Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] usb: typec: tcpm: Invoke power_supply_changed for
 tcpm-source-psy-
Thread-Topic: [PATCH v2] usb: typec: tcpm: Invoke power_supply_changed for
 tcpm-source-psy-
Thread-Index: AQHXG1kn097VtujeWkiKnVEPJK+rvKqJ3XWAgABZmYCAAU0PEA==
Date:   Fri, 19 Mar 2021 16:32:44 +0000
Message-ID: <PR3PR10MB4142450638A8E07A33E475B080689@PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM>
References: <20210317181249.1062995-1-badhri@google.com>
 <PR3PR10MB41420951E2867C2E0E5272B980699@PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM>
 <CAPTae5J_GdHsGQvNxgpffk5otyGhY8D48vddvin3A4fkz3KWUA@mail.gmail.com>
In-Reply-To: <CAPTae5J_GdHsGQvNxgpffk5otyGhY8D48vddvin3A4fkz3KWUA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=diasemi.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [147.161.166.124]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf14345c-eacb-4251-201a-08d8eaf49ff8
x-ms-traffictypediagnostic: PA4PR10MB4527:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PA4PR10MB4527CF901FB63A042041C847A7689@PA4PR10MB4527.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hdnbUmccDZ2QZ4t7sQFtYU5cZo6F9VrRcaBUcA77ivjxVTgPusxhsqtOaaQx2JAi9bWwRp61u7Mpzn1mGv0/+EVxm61tW0vQr9ncmDbdoKKKq19LtI1KsJ4XfBRreNz6EIcrw0+vKMdAqVeY8KN1BnwdX8XFh55/k3gx2inTERHK/IbQEmNYJt4hF/6LVf/iJMzk+gP8IPH2hnHhvMlNydJIqW6jUN6GemcPbhiiKv/5ROX1ZL75WLpeFNrxeB9mNafUd/s6F8vMGok7/RL0fXLw1J/UHxU6GLt1l59qLRdORz/NJX6Q0/fBz+xCWCmLYP8yH/nduqpT7G1JyNQxAaZRobXY8+dFCl/N737Xg++nx94X3K5065eOtPdGCXewwjdSgIHq0zW5i3gm2ZUc21iB7cQUYttUfg7eOWe3ySUZpUWy29FEwQigo0KMyKxnLW3frIcxbLu/+m00IOKNSbYSit6GutdMOMu/xpZiY+ds8BLcrzAPPvtTGD1UfaAdgVRSOWgWyiZKqKpOuRSfMBK4mP0x1teD03RZix4BWLp0d92OQFYzPpZjtf+/6TqiP1iGMMex2F34c+HRzt9qdhkQa27SYx28oWUJowaVg63weIMsag2PvV0p4eoGz/uubkc47AwylgPiBTPmM6ustoGJDTKLsm4eZTvkc131HW8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39850400004)(136003)(376002)(8676002)(316002)(110136005)(4326008)(8936002)(33656002)(2906002)(83380400001)(52536014)(76116006)(54906003)(64756008)(66446008)(5660300002)(26005)(86362001)(7696005)(71200400001)(66556008)(66946007)(6506007)(53546011)(478600001)(66476007)(9686003)(186003)(38100700001)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?KzhIQ1RuSlMvckl6SnRhSGRZMjZBS0VET1RyWHNNbm5oYmZ6d3BXeGg1Y0JT?=
 =?utf-8?B?MmU4NnZGaUVudnlwME1TaWVJNFFzdUt6NWRyZkl3UHVIc3FobFVxMi9XcVRI?=
 =?utf-8?B?cFJTRDdvVFVKYjhJbGlqQmRUVEJUeTlCUFd0Zi9sa2R0bVVFYjZQMVdSY0R6?=
 =?utf-8?B?cjFXd1UxdSswanpwR1BiMFdMNEVhTnRUMWZiMGlnSzEvSGlXRUlOOFBack15?=
 =?utf-8?B?Y3hGUXJpM3RsUWRlU2tBTnQyNlg2ZE1iUTFleDBzOFBFbktEYzNic0RJQ1RI?=
 =?utf-8?B?bFBnMVVaWTAxU1RiZVZBUUNzNjM5TVVHR0prQ3B6WkxIN0RqZjNJeU5NdVB4?=
 =?utf-8?B?NTFLL1VSb2VkYnNTUWh1SlVZOVhEUExqUWJvbDNrUll5aHlmZXZnRGFwMzhW?=
 =?utf-8?B?Y0J5MnQ1aVdBY3E3eW04NnZKVkFFZEtnY3dnYlV6ODNpbzVTVFJ1WWJqQmQ2?=
 =?utf-8?B?UUdWZi92dVZmMHJiYWxneG5aZDhLK2pYcUNQNTBMY09xZWluU0ZJV0plSCty?=
 =?utf-8?B?VEQ4c3kxVDVYcE5iMDNjbTZqbXVtLzRnTVo5eGRCdlZjbkk5bWU4THZYZFF5?=
 =?utf-8?B?c0h1aUhEakx5NUVSaDFHQXB1SmFyTEJvTHhsOVNac25VYVpFcmFlN1lWR1Z3?=
 =?utf-8?B?N0EvUFREV1BmemNnNSt0TExHMFg2WngyVVc3TjFsUUhqdnh5NFZxcWtYNTVk?=
 =?utf-8?B?MUY0RHdiSUpveEp1ZFN0dzdid3VsOExub2pYeGZyQ09zT0Q3bnVDRlZHS0dw?=
 =?utf-8?B?VzVGN3JzUTg5WCt0T1ZJYWhuTXRsaXo5bC9uWng0dTFIN3h0eFlTQ3Y0MlJL?=
 =?utf-8?B?UmFzN0Y2TXA0U08vOEJ5QUlpRHFLK1dEVitQMGcvLzJ0c1piRkE0ZWIvRlJq?=
 =?utf-8?B?VDVkQkxCendqRCtoRXpwQTlIbDErT1RxSU9jS0IwTmY1UG1nVFArbDlCUHBU?=
 =?utf-8?B?ZDBUL1NGWkhDQk50bXJIOTM0elNVY1hKaTdNMDVSSG9HUjVmNkFubVJOQmp2?=
 =?utf-8?B?amR4RDZmRVBxcmtkQTc0RWZyclFqcXJ3aWZxNEJqc1J5QW9ScmpQWDd2cDJE?=
 =?utf-8?B?blRxWHhNa1NpbmJZeS9jWnFEOURwbnB0WDJRNk1ha2ZDWEpUYkpmTG51bGRy?=
 =?utf-8?B?WGJIVEI3clJFY09GSWpGUkNhczR3RUltRGF2NGlIYWtxZGY3ZGFtYklhdklD?=
 =?utf-8?B?THVaUkZXSU1DTTJkRjVIMkNkZnZIUFM4bXNlZEdpZEVhZExYeitPTDBhNnkz?=
 =?utf-8?B?bGg2TE00N3FjckttZ1ozYWZyeXVLRmZTMHVJSkJQazU4di9vcWF0bHpFYml3?=
 =?utf-8?B?VmpIVUxuaGlhWG43aEJQNmI5czBpQlc4dEF0TzNYMnlrVTk1MlJRSWtMcGdT?=
 =?utf-8?B?QjNqTFc3ZVJGL05WcjFhUHJraThGMWEvd2RoZ1I4Y2ovWmNVZkJ5aUJrc0dh?=
 =?utf-8?B?b0pGMmFXZjRVdlhQem5YWHdTMTNrTnJSL0Z6T3R6c3ZKSndLV0N5UDRQbVRo?=
 =?utf-8?B?am0yYVFkV1daUCtMb1lGcmtKUU5MTlVrelNoNFpTQkpJR2drRXV3N3RaZjND?=
 =?utf-8?B?ZU1rSEttOEF3YVMxQ1BIV05ZMXBpS1Z1Ti9HVXdVaWU1bmZ1Qkd2SWNTMG0v?=
 =?utf-8?B?di9hK21iMXZERFF1MkpWdTJ5em9VSFZqVnRpU2hRczRzQlUzWHFzTGxJSVRQ?=
 =?utf-8?B?bEpFK0dua1dTeWxPUzRZSTdjbjg4dHBaQXBsRG1qRno0TUhzOE56QmhKNDVa?=
 =?utf-8?Q?4+wSx5mPzvwEqFMiF7jhb8tzpM3OCgRUFWmJXD8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: diasemi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: cf14345c-eacb-4251-201a-08d8eaf49ff8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2021 16:32:44.9036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 511e3c0e-ee96-486e-a2ec-e272ffa37b7c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WXG3hsMx1Kt3IoB8wKT/NxOGwtm3VLX2gJpHZeiF9wwTqm9KmMjf7nAMkIsmxmv3hN2MUX3T5E3lara43z7TQROjiIbR3E9sHJ5+NONB6cU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR10MB4527
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTggTWFyY2ggMjAyMSAyMDo0MCwgQmFkaHJpIEphZ2FuIFNyaWRoYXJhbiB3cm90ZToNCg0K
PiA+IFJlZ2FyZGluZyBzZWxlY3RpbmcgUERPcyBvciBQUFMgQVBET3MsIHN1cmVseSB3ZSBzaG91
bGQgb25seSBub3RpZnkgb2YgYQ0KPiBjaGFuZ2UNCj4gPiB3aGVuIHdlIHJlYWNoIFNOS19SRUFE
WSB3aGljaCBtZWFucyBhIG5ldyBjb250cmFjdCBoYXMgYmVlbiBlc3RhYmxpc2hlZD8NCj4gVW50
aWwNCj4gPiB0aGF0IHBvaW50IGl0J3MgcG9zc2libGUgYW55IHJlcXVlc3RlZCBjaGFuZ2UgY291
bGQgYmUgcmVqZWN0ZWQgc28gd2h5IGluZm9ybQ0KPiA+IGNsaWVudHMgYmVmb3JlIHdlIGtub3cg
dGhlIHNldHRpbmdzIGhhdmUgdGFrZW4gZWZmZWN0PyBJIGNvdWxkIGJlIG1pc3NpbmcNCj4gPiBz
b21ldGhpbmcgaGVyZSBhcyBpdCdzIGJlZW4gYSBsaXR0bGUgd2hpbGUgc2luY2UgSSBkZWx2ZWQg
aW50byB0aGlzLCBidXQgdGhpcw0KPiA+IGRvZXNuJ3Qgc2VlbSB0byBtYWtlIHNlbnNlIHRvIG1l
Lg0KPiANCj4gSSB3YXMgdHJ5aW5nIHRvIGtlZXAgdGhlIHBvd2VyX3N1cHBseV9jaGFuZ2VkIGNh
bGwgY2xvc2UgdG8gdGhlDQo+IHZhcmlhYmxlcyB3aGljaCBhcmUgdXNlZCB0byBpbmZlciB0aGUg
cG93ZXIgc3VwcGx5IHByb3BlcnR5IHZhbHVlcy4NCj4gU2luY2UgcG9ydC0+cHBzX2RhdGEubWF4
X2N1cnIgaXMgYWxyZWFkeSB1cGRhdGVkIGhlcmUgYW5kIHRoYXQncyB1c2VkDQo+IHRvIGluZmVy
IHRoZSBDVVJSRU5UX01BWCBhIGNsaWVudCBjb3VsZCBzdGlsbCByZWFkIHRoaXMgYmVmb3JlIHRo
ZQ0KPiByZXF1ZXN0IGdvZXMgdGhyb3VnaCByaWdodCA/DQoNCkFjdHVhbGx5IHRoYXQncyBmYWly
IGJ1dCBJIHRoaW5rIHRoZSBwcm9ibGVtIGhlcmUgcmVsYXRlcyB0byAnbWF4X2N1cnInIG5vdA0K
YmVpbmcgcmVzZXQgaWYgdGhlIFNSQyByZWplY3RzIG91ciByZXF1ZXN0IHdoZW4gd2UncmUgc3dh
cHBpbmcgYmV0d2VlbiBvbmUgUFBTDQpBUERPIGFuZCBhbm90aGVyIFBQUyBBUERPLiBJIHRoaW5r
IHRoZSAnbWF4X2N1cnInIHZhbHVlIHNob3VsZCBiZSByZXZlcnRlZCBiYWNrDQp0byB0aGUgdmFs
dWUgZm9yIHRoZSBleGlzdGluZyBQUFMgQVBETyB3ZSB3ZXJlIGFscmVhZHkgdXNpbmcuIEkgc3Vz
cGVjdCB0aGUgc2FtZQ0KbWlnaHQgYmUgdHJ1ZSBvZiAnbWluX3ZvbHQnIGFuZCAnbWF4X3ZvbHQn
IGFzIHdlbGwsIG5vdyBJIGxvb2sgYXQgaXQuIEl0IG1pZ2h0DQphY3R1YWxseSBiZSBwcnVkZW50
IHRvIGhhdmUgcGVuZGluZyBQUFMgZGF0YSBiYXNlZCBvbiBhIHJlcXVlc3QsIHdoaWNoIGlzIG9u
bHkNCmNvbW1pdHRlZCBhcyBhY3RpdmUgb25jZSBBQ0NFUFQgaGFzIGJlZW4gcmVjZWl2ZWQuDQoN
ClJlZ2FyZGluZyBwb3dlcl9zdXBwbHlfY2hhbmdlZCgpIHRob3VnaCwgSSBzdGlsbCB0aGluayB3
ZSBzaG91bGQgb25seSBub3RpZnkgb2YNCmEgY2hhbmdlIHdoZW4gdGhlIHJlcXVlc3RlZCBjaGFu
Z2UgaGFzIGJlZW4gYWNjZXB0ZWQgYnkgdGhlIHNvdXJjZSwgaW4gcmVsYXRpb24NCnRvIHRoZXNl
IHZhbHVlcyBhcyB0aGV5IHNob3VsZCByZWZsZWN0IHRoZSByZWFsLCBpbi11c2Ugdm9sdGFnZSBh
bmQgY3VycmVudA0KdmFsdWVzLg0KDQo=
