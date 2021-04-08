Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A44357C0B
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 07:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhDHF6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 01:58:15 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:54564 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229769AbhDHF6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 01:58:15 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E4502C09A6;
        Thu,  8 Apr 2021 05:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1617861484; bh=6mTn6DuRfc5MKos4BtyE6MQc4ZlSZrkTuhYpsWE+/4o=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=VuWQiCuCIN2VBUPH9V0NI1PhNpsTi9q9HrX8HpsDNgk1w4XUyu+ufi0xl/XfFlAJi
         8ZvVDr/dZKXEp+lmsmkGqsCC1JEHOlVxayM2iQ3EcgtHTPkXtLVHmsrU8gwlIQO7yb
         3iBvMlyQBSFdid29/c5z6THafMnMwTQnQtPxsi/thgTuvKV0kMFs1w0/g37MnzSTUY
         LCrqclaTN9Y3S/eKfG9Pz1pirhM5UjJwGCpZ/BviTjD7pReYMN/t4fwDdo58zjInKd
         xSh306DHs0ueLhSn6756jci36Tf8gGSXEAUXOCdCGMHf0nNj0TrKu3fgmVc+tVvMT1
         CpobKXnOuDYzg==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 51453A0099;
        Thu,  8 Apr 2021 05:58:03 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 20A0080129;
        Thu,  8 Apr 2021 05:58:00 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=arturp@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="s/6QD49c";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4yqcBa76xgMO3EkCvIGj5dOwVAva4kIDFqEFlnhro3oIep8fyNqj3MyoCImIRxLtlSsP3i4m/mEgtwzJo7bQ9xFXrADTUmRXJ+D9T0O9OfGP8JtBdrCBHB7ByhKNVtj7BusFqwsno8jhOkcytyas/8xDbRgnTw+m05DW2Q9u+5H5wMgqw06r1UwlBv+JNu93T8L1NmcqeaEBdD2JO06Jeh+3X+m8G3x1CmnYNx1jFWgVwIfn5B4sAjzJ8gCBgInyVweD+9WAVdckf0554J+pK7WuXyjSgNpDr3hRxAWpSp1dCAuqMVhX8Qk3PUUTmXNGIpNHvroAhJ+UF1MFZokyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mTn6DuRfc5MKos4BtyE6MQc4ZlSZrkTuhYpsWE+/4o=;
 b=LeZ10DhSmdrj67QoW0uiF1rb0BFMfR02RpDeIuiLpN+zLKF+Cen1pj4VWAPUK167ft42wvtnp15OON5ZPw6L4O8Ur9cqa4DoBZALWHUt0JHJK3XlkF55pN82Tm01dOf/qMnXyBicFtQmR43yhgP0gtrABCDfgKQfryr7NDhrMkQliFOuXuxqy3Gjn1vDiE1cgCMkLhRFc5gqn97iCxj8Q8mfPJ6WeIr1UIJ+q1VpspxOB1NF0VOg+3n959Th9CdFf8Th81bZIq3GksEgWA00Q4QCgqfSjDlZLrzWTGV4M/7+GiI9SocqIwxMcVs0zlKb3jdq8YWMYmavc7JLXnGjAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mTn6DuRfc5MKos4BtyE6MQc4ZlSZrkTuhYpsWE+/4o=;
 b=s/6QD49cMDSqfOO5fV6TKiYGDXXY7bxn8s3YS0hdEbYeKHZKJWXDxhRkXITxb/SuN3X11dGBth0XGr8kcW1gAp0pOzxbvNIaXMzyD/5rJnKe4wzj7VAVifuUqquLz4P1NmJokinfjzjqrHIZeA6HleqYAu1DhRUq9kxDa2BoweQ=
Received: from CH0PR12MB5265.namprd12.prod.outlook.com (2603:10b6:610:d0::22)
 by CH0PR12MB5106.namprd12.prod.outlook.com (2603:10b6:610:bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Thu, 8 Apr
 2021 05:57:58 +0000
Received: from CH0PR12MB5265.namprd12.prod.outlook.com
 ([fe80::b1a0:f306:3b5a:7f0c]) by CH0PR12MB5265.namprd12.prod.outlook.com
 ([fe80::b1a0:f306:3b5a:7f0c%7]) with mapi id 15.20.4020.016; Thu, 8 Apr 2021
 05:57:58 +0000
X-SNPS-Relay: synopsys.com
From:   Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
To:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mian Yousaf Kaukab <yousaf.kaukab@intel.com>,
        Gregory Herrero <gregory.herrero@intel.com>,
        Douglas Anderson <dianders@chromium.org>
CC:     Paul Zimmerman <paulz@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH 00/14] usb: dwc2: Fix Partial Power down issues.
Thread-Topic: [PATCH 00/14] usb: dwc2: Fix Partial Power down issues.
Thread-Index: AQHXK5TTc4hI4vho5ky9D/CRxiFoGqqqIRQA
Date:   Thu, 8 Apr 2021 05:57:57 +0000
Message-ID: <60f356b2-e465-48e7-ad37-f1021e3581ff@synopsys.com>
References: <cover.1617782102.git.Arthur.Petrosyan@synopsys.com>
In-Reply-To: <cover.1617782102.git.Arthur.Petrosyan@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: synopsys.com; dkim=none (message not signed)
 header.d=none;synopsys.com; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [46.162.196.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 337ac83e-2c0f-4fac-04e9-08d8fa5342ab
x-ms-traffictypediagnostic: CH0PR12MB5106:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH0PR12MB51068139E5DF886C53579CDDA7749@CH0PR12MB5106.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TfXLTy2PqnZMo8fVsLGxyW/AnmyKUZGfmBz+oynS3iMZdmYKGuOsRvaK7bTmIczI83jEpyZh7UvG8/n9blfBiYurVrd1Q2pKezRCvRz7Ic9LYZ5P5ybrxzoH9yBAKikn4wHUgqnLonPWz+KFm3Q+LwEAJK+rzW9HgH+7RjF7cayoIShoSnhh1RzcV1GsxWXgg0FA2gw6e/qKa3qKL7eU7TRjjVJEpqEqvKv444WJdSfbruM6rlov6Fy2zvuZl5SfnukMoqgftQXbkNGEYaoWQJSn7IeR1VXcn4OddLGmdquxqeGqRdOpoL+xjh2Kb55Rl/qPY3i5Oc1QoLwwvwuE+rKfqs7q4pG3AJYHfx86vW2fWQodgx7cgdPUBL05vs4Dmg+VpP6X91coCpy9+D5qiCixBWgI82zHCpkhdfrRkED5hJ/VILG4g5bwzfsSEe5/s42Bf0do0Bblg54s3HqjeKgrDCM0z+8elfwJQ9TY0MQQX3mW41TSueqMUc+exAV+6hTSjw7OfKnIIfI16igIJ3AW7qAxkSP2Dmz5LRs2pl0fudRIOOsr1AXtDcE8zHqjvBBfXOHo9m5HKBV396Tt7pwno/f8q5H0YoEfUzVPNi2pug+PkpvAfp27DEpqFmqug218y+2ue27sqDR3eyRDE8Lywl/JrmWAwZKf1DTs8laCsnCfxO355DABL3wIByCT08da45u5ITVoVGR0YNw2d2iPjI1vGli0x6KHGxVKGcy+r+NJWFBaX3pY59iHFS3woPlwLxopjTKS1FjYeAUXxSHMZhO42Z6gE0eHtZJjf6M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5265.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(8936002)(38100700001)(966005)(478600001)(66556008)(6486002)(6506007)(53546011)(5660300002)(8676002)(110136005)(36756003)(54906003)(316002)(86362001)(6512007)(186003)(31696002)(26005)(71200400001)(4326008)(2906002)(7416002)(2616005)(91956017)(66946007)(66446008)(66476007)(83380400001)(76116006)(64756008)(31686004)(45980500001)(6606295002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?c1ZEejYvSFp4aTNEVEJhVGJpNGYrQUZraUF5ZGhTS2pxdVRqdE1YV1RjaTZm?=
 =?utf-8?B?MmhwOVdLQk53UVlVS3F1T1ZKWTA0VnJUM3llWWd3THJ5bDh4bzFGVmtqSTFD?=
 =?utf-8?B?V1pkbTh4ZmM2b0o5TUs1UzEvb29WMkVlWTR6NVZqSTRyV1liVWhxeFpFLy9J?=
 =?utf-8?B?b0p6TGxuYlE1Rzd2eERyOHhOYTJSTDJBeXBjM3poR08wckRLSi9OLzExWUha?=
 =?utf-8?B?bVMvRm9pVmgwSnE0cXcyVzUrM1diYjZDMFBhMis1SW1wTVdRMWQzYWFGQU1T?=
 =?utf-8?B?ZUhBZG1xTDk4ellwWjBnOEt4b1d1dzZoNllMeGhLQVExaE9DOTBucnJnSU51?=
 =?utf-8?B?ODZiNXhMKzN3N3UzTWUrVUhXMS9NNWJHOFJTU1N4T2E2YjJFRFJ0YkV4M1JU?=
 =?utf-8?B?MnZ4eFE5UTQ0dkl4WVpoeGIrTWVyNDlSS3crZlNoMTBLZ2lBMlFyYml2VUFu?=
 =?utf-8?B?RCtOb3JSV1pXdjBUaklSQkdkVGJ5V1pFVy9VUGR2M0ZVM3ptbC9CU1p1TUE5?=
 =?utf-8?B?MHd4VFM2OFhuSko2REZqVDQrbHR1d1NQclJ1K25DdWs2ZkE4T0p1ei93dllo?=
 =?utf-8?B?TGhiWmhIZlMwaStrZ21SVE1ZVVNVR3diWW9DWFkzdVRPU0dIeVVrUVlkeUFv?=
 =?utf-8?B?bGVnSEw0QStkWFBxaW9mcmhQY3dGYXliZjNPQVNidWNiaVVNdFBDWTkyK0Vz?=
 =?utf-8?B?dGhoTG1mRGdNa3I1ZGxYd2YyNEIyVTZpS2Q3UlRib20zVlppbjM2bU4xSTdN?=
 =?utf-8?B?M3ZxdEdZZ3N5bVVVZmRPN2pQamdnWXBPSWwzbUgwZFVCM2RLNEFwRGUzcU9x?=
 =?utf-8?B?TStUa2tkUUY1QWVJVXM4dTNRR29PL2ozWnVDNDFpdzFOOHFhZjJVTVk3ZDJp?=
 =?utf-8?B?TEhObWxKRDVCU0h0L1UwUlI5QWdKTlBUQXhiZmt1S2cxbXQrcEhGOWYrR01L?=
 =?utf-8?B?Y1NaVEM4SlVpRUE1WXAyNkg1cUI3NmhFMlVnT1dlNWxXeVh4VXRHOXJ5bmNw?=
 =?utf-8?B?dzR6OXp0RGJOblNKVmF4U2R0SnpRYnkybVA0ZlBXeVA3UlFtTERRZ3l0YWNt?=
 =?utf-8?B?dVY1OHpOL2V3RWFzai9mTU9CWnBpK0hjVjBtNUl5aWtxTFdqZnBGZ1Z6N3RC?=
 =?utf-8?B?ZkFTVlM4dDF4cjBEN05QR3pJR2J1cTFhVTRjRFltNW5rMzBHTGQ4SStGTG5Q?=
 =?utf-8?B?dzJ1VFgzR0RXMXJJaEh0OWl2YjVnWElkK0tUMTM0dDd3TFhrckdET2RGZGZW?=
 =?utf-8?B?eDVWL2JRd3JvZzBXRjBCN0hDZm1WV1QzUkRmbkVNZjE5RnpIWEx1eHZyK2pH?=
 =?utf-8?B?TGFITUZncERPNEpkUjZjZE9vcGZ0cmJ5OHBuY3JSVWR3cTRyb0dpaWVhOFhx?=
 =?utf-8?B?cVZERHliaXJjdGlEQUxsTUxDdmhDcDZsMUcxdGYvWm9aWm56QlljekE3Ylht?=
 =?utf-8?B?S0FiTWNJZGpEQ0NBbFB6bE5ZUTZyak5Ebkl5emUvcExxU2V2bm5qTGliVmtX?=
 =?utf-8?B?WlZWVUQwWXh0OW1qRU52bnRHYkkxMlk3K1VhTDE2dm83VWxMUnA0QXVZTzNS?=
 =?utf-8?B?ZytYQjM2RTVVa1BRZVpiSnhaSGxiRDJkMXZnbklQVXNITzBUOU8zN3RNcEhm?=
 =?utf-8?B?UDV2SEd2NzRLSWdvNUp3YVhUZ3pxVTJVTUNlM09pOEsvcjg5T21sZWllMlZY?=
 =?utf-8?B?VFZJS3BOLytSaXFjU2k0di9QUTFxT3hFN25jVWp2TnluRU10SzFXTW5xSno2?=
 =?utf-8?Q?0SlGKEowjxjmuHwBI8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB33B54D9B9E814C9707C50E3AFF3F63@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5265.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 337ac83e-2c0f-4fac-04e9-08d8fa5342ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 05:57:57.8717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2M+4mdQm8YX+Xf71Ge3mxf99DIeJ0mSgTICf7YbBTq5aAz0KJYXY1dtJFVxYbCOtNyrzIpYczyOInEDGvaLSMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5106
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywNCg0KT24gNC83LzIwMjEgMTQ6MDAsIEFydHVyIFBldHJvc3lhbiB3cm90ZToNCj4g
VGhpcyBwYXRjaCBzZXQgZml4ZXMgYW5kIGltcHJvdmVzIHRoZSBQYXJ0aWFsIFBvd2VyIERvd24g
bW9kZSBmb3INCj4gZHdjMiBjb3JlLg0KPiBJdCBhZGRzIHN1cHBvcnQgZm9yIHRoZSBmb2xsb3dp
bmcgY2FzZXMNCj4gICAgICAxLiBFbnRlcmluZyBhbmQgZXhpdGluZyBwYXJ0aWFsIHBvd2VyIGRv
d24gd2hlbiBhIHBvcnQgaXMNCj4gICAgICAgICBzdXNwZW5kZWQsIHJlc3VtZWQsIHBvcnQgcmVz
ZXQgaXMgYXNzZXJ0ZWQuDQo+ICAgICAgMi4gRXhpdGluZyB0aGUgcGFydGlhbCBwb3dlciBkb3du
IG1vZGUgYmVmb3JlIHJlbW92aW5nIGRyaXZlci4NCj4gICAgICAzLiBFeGl0aW5nIHBhcnRpYWwg
cG93ZXIgZG93biBpbiB3YWtldXAgZGV0ZWN0ZWQgaW50ZXJydXB0IGhhbmRsZXIuDQo+ICAgICAg
NC4gRXhpdGluZyBmcm9tIHBhcnRpYWwgcG93ZXIgZG93biBtb2RlIHdoZW4gY29ubmVjdG9yIElE
Lg0KPiAgICAgICAgIHN0YXR1cyBjaGFuZ2VzIHRvICJjb25uSWQgQg0KPiANCj4gSXQgdXBkYXRl
cyBhbmQgZml4ZXMgdGhlIGltcGxlbWVudGF0aW9uIG9mIGR3YzIgZW50ZXJpbmcgYW5kDQo+IGV4
aXRpbmcgcGFydGlhbCBwb3dlciBkb3duIG1vZGUgd2hlbiB0aGUgc3lzdGVtIChQQykgaXMgc3Vz
cGVuZGVkLg0KPiANCj4gVGhlIHBhdGNoIHNldCBhbHNvIGltcHJvdmVzIHRoZSBpbXBsZW1lbnRh
dGlvbiBvZiBmdW5jdGlvbiBoYW5kbGVycw0KPiBmb3IgZW50ZXJpbmcgYW5kIGV4aXRpbmcgaG9z
dCBvciBkZXZpY2UgcGFydGlhbCBwb3dlciBkb3duLg0KPiANCj4gTk9URTogVGhpcyBpcyB0aGUg
c2Vjb25kIHBhdGNoIHNldCBpbiB0aGUgcG93ZXIgc2F2aW5nIG1vZGUgZml4ZXMNCj4gc2VyaWVz
Lg0KPiBUaGlzIHBhdGNoIHNldCBpcyBwYXJ0IG9mIG11bHRpcGxlIHNlcmllcyBhbmQgaXMgY29u
dGludWF0aW9uDQo+IG9mIHRoZSAidXNiOiBkd2MyOiBGaXggYW5kIGltcHJvdmUgcG93ZXIgc2F2
aW5nIG1vZGVzIiBwYXRjaCBzZXQuDQo+IChQYXRjaCBzZXQgbGluazogaHR0cHM6Ly9tYXJjLmlu
Zm8vP2w9bGludXgtdXNiJm09MTYwMzc5NjIyNDAzOTc1Jnc9MikuDQo+IFRoZSBwYXRjaGVzIHRo
YXQgd2VyZSBpbmNsdWRlZCBpbiB0aGUgInVzYjogZHdjMjoNCj4gRml4IGFuZCBpbXByb3ZlIHBv
d2VyIHNhdmluZyBtb2RlcyIgd2hpY2ggd2FzIHN1Ym1pdHRlZA0KPiBlYXJsaWVyIHdhcyB0b28g
bGFyZ2UgYW5kIG5lZWRlZCB0byBiZSBzcGxpdCB1cCBpbnRvDQo+IHNtYWxsZXIgcGF0Y2ggc2V0
cy4NCj4gDQo+IA0KPiBBcnR1ciBQZXRyb3N5YW4gKDE0KToNCj4gICAgdXNiOiBkd2MyOiBBZGQg
ZGV2aWNlIHBhcnRpYWwgcG93ZXIgZG93biBmdW5jdGlvbnMNCj4gICAgdXNiOiBkd2MyOiBBZGQg
aG9zdCBwYXJ0aWFsIHBvd2VyIGRvd24gZnVuY3Rpb25zDQo+ICAgIHVzYjogZHdjMjogVXBkYXRl
IGVudGVyIGFuZCBleGl0IHBhcnRpYWwgcG93ZXIgZG93biBmdW5jdGlvbnMNCj4gICAgdXNiOiBk
d2MyOiBBZGQgcGFydGlhbCBwb3dlciBkb3duIGV4aXQgZmxvdyBpbiB3YWtldXAgaW50ci4NCj4g
ICAgdXNiOiBkd2MyOiBVcGRhdGUgcG9ydCBzdXNwZW5kL3Jlc3VtZSBmdW5jdGlvbiBkZWZpbml0
aW9ucy4NCj4gICAgdXNiOiBkd2MyOiBBZGQgZW50ZXIgcGFydGlhbCBwb3dlciBkb3duIHdoZW4g
cG9ydCBpcyBzdXNwZW5kZWQNCj4gICAgdXNiOiBkd2MyOiBBZGQgZXhpdCBwYXJ0aWFsIHBvd2Vy
IGRvd24gd2hlbiBwb3J0IGlzIHJlc3VtZWQNCj4gICAgdXNiOiBkd2MyOiBBZGQgZXhpdCBwYXJ0
aWFsIHBvd2VyIGRvd24gd2hlbiBwb3J0IHJlc2V0IGlzIGFzc2VydGVkDQo+ICAgIHVzYjogZHdj
MjogQWRkIHBhcnQuIHBvd2VyIGRvd24gZXhpdCBmcm9tDQo+ICAgICAgZHdjMl9jb25uX2lkX3N0
YXR1c19jaGFuZ2UoKS4NCj4gICAgdXNiOiBkd2MyOiBBbGxvdyBleGl0IHBhcnRpYWwgcG93ZXIg
ZG93biBpbiB1cmIgZW5xdWV1ZQ0KPiAgICB1c2I6IGR3YzI6IEZpeCBzZXNzaW9uIHJlcXVlc3Qg
aW50ZXJydXB0IGhhbmRsZXINCj4gICAgdXNiOiBkd2MyOiBVcGRhdGUgcGFydGlhbCBwb3dlciBk
b3duIGVudGVyaW5nIGJ5IHN5c3RlbSBzdXNwZW5kDQo+ICAgIHVzYjogZHdjMjogRml4IHBhcnRp
YWwgcG93ZXIgZG93biBleGl0aW5nIGJ5IHN5c3RlbSByZXN1bWUNCj4gICAgdXNiOiBkd2MyOiBB
ZGQgZXhpdCBwYXJ0aWFsIHBvd2VyIGRvd24gYmVmb3JlIHJlbW92aW5nIGRyaXZlcg0KPiANCj4g
ICBkcml2ZXJzL3VzYi9kd2MyL2NvcmUuYyAgICAgIHwgMTEzICsrLS0tLS0tLQ0KPiAgIGRyaXZl
cnMvdXNiL2R3YzIvY29yZS5oICAgICAgfCAgMjcgKystDQo+ICAgZHJpdmVycy91c2IvZHdjMi9j
b3JlX2ludHIuYyB8ICA0NiArKy0tDQo+ICAgZHJpdmVycy91c2IvZHdjMi9nYWRnZXQuYyAgICB8
IDE0OCArKysrKysrKysrLQ0KPiAgIGRyaXZlcnMvdXNiL2R3YzIvaGNkLmMgICAgICAgfCA0NTgg
KysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0NCj4gICBkcml2ZXJzL3VzYi9kd2My
L2h3LmggICAgICAgIHwgICAxICsNCj4gICBkcml2ZXJzL3VzYi9kd2MyL3BsYXRmb3JtLmMgIHwg
IDExICstDQo+ICAgNyBmaWxlcyBjaGFuZ2VkLCA1NTggaW5zZXJ0aW9ucygrKSwgMjQ2IGRlbGV0
aW9ucygtKQ0KPiANCj4gDQo+IGJhc2UtY29tbWl0OiBlOWZjYjA3NzA0ZmNlZjZmYTZkMDMzM2Zk
MmIzYTYyNDQyZWFmNDViDQo+IA0KSSBoYXZlIHN1Ym1pdHRlZCB0aGlzIHBhdGNoIHNldCB5ZXN0
ZXJkYXkuIEl0IGNvbnRhaW5zIDE0IHBhdGNoZXMuIEJ1dCANCm9ubHkgMiBvZiB0aG9zZSBwYXRj
aGVzIHdlcmUgcmVjZWl2ZWQgYnkgTEtNTCBvbmx5IHRoZSBjb3ZlciBsZXR0ZXIgYW5kIA0KdGhl
IDEzdGggcGF0Y2guIA0KKGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXVzYi9jb3Zlci4x
NjE3NzgyMTAyLmdpdC5BcnRodXIuUGV0cm9zeWFuQHN5bm9wc3lzLmNvbS9ULyN0KQ0KDQpJIGNo
ZWNrZWQgaGVyZSBhdCBTeW5vcHN5cywgTWluYXMgZGlkIHJlY2VpdmUgYWxsIHRoZSBwYXRjaGVz
IGFzIGhpcyANCmVtYWlsIGlzIGluIFRvIGxpc3QuIENvdWxkIHRoaXMgYmUgYW4gaXNzdWUgb2Yg
dmdlci5rZXJuZWwub3JnIG1haWxpbmcgDQpzZXJ2ZXI/DQoNCkJlY2F1c2UgSSBjaGVja2VkIGV2
ZXJ5IGxvY2FsIHBvc3NpYmlsaXR5IHRoYXQgY291bGQgcmVzdWx0IHRvIHN1Y2ggDQpiZWhhdmlv
ci4gVGhlIHBhdGNoIDEzIHdoaWNoIHdhcyByZWNlaXZlZCBieSBMS01MIGhhcyB0aGUgc2ltaWxh
ciANCmNvbnRlbnQgYXMgdGhlIG90aGVyIHBhdGNoZXMuDQoNClRoZSBtYWlsaW5nIHRvb2wgdGhh
dCB3YXMgdXNlZCBpcyBzc210cCwgY2hlY2tlZCBhbGwgdGhlIGNvbmZpZ3VyYXRpb25zIA0KZXZl
cnl0aGluZyBpcyBmaW5lLg0KDQpDb3VsZCB5b3UgcGxlYXNlIHN1Z2dlc3Qgd2hhdCBzaG91bGQg
SSBkbyBpbiB0aGlzIHNpdHVhdGlvbj8NCg0KUmVnYXJkcywNCkFydHVyDQoNCg0KDQoNCg==
