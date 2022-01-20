Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64AD4955F4
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 22:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377891AbiATV2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 16:28:34 -0500
Received: from mail-bn8nam12on2071.outbound.protection.outlook.com ([40.107.237.71]:30689
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1377896AbiATV2d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jan 2022 16:28:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDmTqWWYJtPBwT5obB4txAETC009yA1i2+sFk2rv0KSSfnYc0BY/EOmqxxo5ooXP7PKdTJ3UTxuyJt8yR7NpDr8SUhEWjlrkNAJso0ZWd90bwxgM2eZTjvurAT0H/6i0dkBXZFxafTdii8p9fCEQ+eL8jSPkZNYSitP5/yQXiO5S4ynI1AP0qIkR2vULev1QQuA9g66jScBYQl11BJgOsxrEUP3RIY1sK4aKgXB1+YxuG4ApClWg8L1M8hidFckoBqznMLahwHoZa1qdkfUvXpnarT5I5192plyEbcZt3dqrqVETlTYQetFhWPb77BZQubQo5a5SzTj56Wcj2cjxZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qUWGFgydJWcKCnkajy5QKsInb8gCApc8qgdoTrqBAp8=;
 b=U00uoG6+fryOILyYd+FB2xdxYe9MR+XFeySXsUsjnMrfOheOTpqbkOKpTWCvWyYkbvde2fsSM8okHr2N5SK8xAgj+eoxHHJ7KyDmAPIVEVsAz59P9JRgsWiFBrZc8GY0wbaGxakjMRudC5kYxvhMzqYoFvjsY6ibM0kFMNrkK8VkpRW+1giiOr+vC9uzoeU1LbeXEYBOni+BDJIkbHGUzB//x1N8J22aFA8VSsfwr22kaBXGfOL7zMpltaSSs32qczyt5cDuiS6YMFiE5WDmb+a8iepVhEcygjDAShhv220BW/vEEylqDrKxzfZ8MhQrx5xhT9IV5VZ9S/A7ehWdIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUWGFgydJWcKCnkajy5QKsInb8gCApc8qgdoTrqBAp8=;
 b=c3zmReSluI8n38iWQCD7vK2rlRI0RAYK0NSQoOIV6/IzqWr3hlK1TXGAS5uOcifMVbb7wWEPYL2eZZXp2n2Xkn8pQz9aG7Eq508eSJcBwJ1waZyx+uHBb1dAuEf2wQYRdeAYq6eB8KAgZrYeUOvX5X1G4dTfFNB7PJMnhATPn18=
Received: from BN8PR05MB6611.namprd05.prod.outlook.com (2603:10b6:408:57::15)
 by DM6PR05MB5932.namprd05.prod.outlook.com (2603:10b6:5:10d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.6; Thu, 20 Jan
 2022 21:28:30 +0000
Received: from BN8PR05MB6611.namprd05.prod.outlook.com
 ([fe80::11ef:953e:9ca:71f0]) by BN8PR05MB6611.namprd05.prod.outlook.com
 ([fe80::11ef:953e:9ca:71f0%5]) with mapi id 15.20.4930.006; Thu, 20 Jan 2022
 21:28:30 +0000
From:   Zack Rusin <zackr@vmware.com>
To:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "javierm@redhat.com" <javierm@redhat.com>,
        "tzimmermann@suse.de" <tzimmermann@suse.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Thread-Topic: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Thread-Index: AQHYC8yinmr5RRCrG02Gv/mSECQCTKxpI6WAgAB5uACAAHSWgIAAUE4AgAAUKgCAAAqSAIAAzYgAgABjAACAAMA2gA==
Date:   Thu, 20 Jan 2022 21:28:30 +0000
Message-ID: <9f9b9417d04e4ca7157b03a1e4430e2ce374d97a.camel@vmware.com>
References: <20220117180359.18114-1-zack@kde.org>
         <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
         <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
         <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
         <afc4c659-b92e-3227-634f-7c171b7a74b3@suse.de>
         <80fc6b88d659dd7281364daccfed1fd294e785dc.camel@vmware.com>
         <89f1b9df-6ace-d59c-86a4-571cd92d0a4c@suse.de>
         <e9f42f83d7966952c8c0ff78be7e510a2aebdf01.camel@vmware.com>
         <14b3043a-2569-f4fb-a73d-d67ee1feaee4@suse.de>
In-Reply-To: <14b3043a-2569-f4fb-a73d-d67ee1feaee4@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa4755dd-824b-4e17-82d8-08d9dc5bcdcd
x-ms-traffictypediagnostic: DM6PR05MB5932:EE_
x-microsoft-antispam-prvs: <DM6PR05MB5932D6DCBBA6D2A7070CFE3DCE5A9@DM6PR05MB5932.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CfhyO51e0r4kjVNcPmlCL1GA1eY12uYTawTRYCOFFKk1LxH6+OfcHDw6h2tnhitorsum7BlWEmmge9g1ogHw72Rs/BffGlG4isZ3bCT/0uFak/+g9vs6AG6ax2Xu6L9A2JD5Wm6lynZebfIO4vUeRThkvhbJizx1iAEfdOS71pLcCirRqYxqrma/wPRDog0nH6pNYZKkdtzWSwmqDxyfmhBeAq+RXqjRk0wUWRivPKmW3SZ2dYZdU1pswBVoXqGKC06Q3WkBrevQA6gbyzm3nJZaflmKQzx/xyvvslqGlwQ2mAx/uQjtP+wUrfYQ96RxEWsi1Y6ABRc6vkRd7ykHzT6j6tKokOg76gnFng1X/holJBSQUI1dqLkRy3bmi9+BYhVa8k/P7yv0DR3xGrazo1iyubNvAs78ArYkO+v+IRKP6hSg6FGtyhhTtdr0Md9uhoChP5P3/l1vzOUdx/FGgQ2kpVTXyEUQWP0mmkcqcF7c+5MHRmsKp85ZjeK2rOGh5zyWWweE/Oex/qJhPiAZgAOlnbtWMQAh699bno3iq2O8/dDFzFMFgBCiDeEzdjwUny8s0kO57RqL3qkGoISmqiZuenohn+zo+k5dhlqmSwIaW4Sg1KLovkfO5lYE/pMmjcEani5ZH9jUb0FmaZ1Z2AYW/nw6pddwEA9NSEv/O+2UBT+4Y4vQbXyCfdi6G5UMWK2d4NB1X7lPjkbY/etq9kkSd2h5Cs3eK3pkDajSU7F6BV2Etuw0+2V9uoExiMkA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR05MB6611.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(26005)(2906002)(508600001)(6486002)(122000001)(186003)(36756003)(107886003)(4744005)(86362001)(2616005)(66946007)(38070700005)(5660300002)(54906003)(316002)(8936002)(8676002)(4326008)(110136005)(6512007)(91956017)(76116006)(71200400001)(66556008)(66476007)(66446008)(64756008)(83380400001)(6506007)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmQvdzBNaGI3dnlsNFpDMUwxd1hvcGRqSlltdTAvdmhLNmlpeTNna1llL0cr?=
 =?utf-8?B?SWJoU24vRVBnWTd5NUphRThubFg0TGNKRzVjbC9oRWVwMVo5d3VURFl0aXJt?=
 =?utf-8?B?U1hQcmFQWUY4Y1J2Z2k5ZkUzeWEwdUovRmpUUWl5U2NBZkJzOWI1cEhHRXpN?=
 =?utf-8?B?UW5NYXJNUGgrTWMrd0s3bFR2ckNrTis5SnNkdGo2UENPb0dNU2RmcXd0OWNG?=
 =?utf-8?B?Y2lNNlYyT3dkbnA4ZndTcXVlbUVOK0hNWW5KVVhpQjVoNTEzc29LYmhlZDNZ?=
 =?utf-8?B?OFVBT3ZLejBQVXU5L28wZXNYZTJFcEcvZk1CMGcxdUh4bEZSTlVrVFJIMy9B?=
 =?utf-8?B?aERWT0hOek9ZRUFFRkRlZURkWjVyb1NrRlkwYzkvOWs1bUtGSkNVZ3Z2OHlt?=
 =?utf-8?B?R1NhZTRhVU5OVDVvTWhXNUltTjNsS1NjeVhKOXk5RnMzaEo3ZjY4QXJvQ3dj?=
 =?utf-8?B?bTNSR2VXTTRpb3o0YVNYdkUxeHhQWVF3U2FrRVEwUW52UGRQYVRhM054b1VO?=
 =?utf-8?B?Q0lqWUpSZjR3L0QvaFB3bjRzY3V6Tnp4TlNEUjNON3JuSTlnbUN5WDNLNFVO?=
 =?utf-8?B?Mk5uS1ZQMXZjWmJjOVlBVnJHVWYzYnd5RlFUR0t6WXV4cmltK3Z5U0tJWEp5?=
 =?utf-8?B?a1QvNnlYR3lCTExaN1Rad3V3OWxzc3o4UmVZVEIvOGpTdWMzNkpLQTROUGpo?=
 =?utf-8?B?QXJsVzB3OFFWMnNGMWRpY0JIWHhaNXFOSFMrZUtqL2VjUkMrZUpwTzNSeDVB?=
 =?utf-8?B?NkY2NUNXazdoSVJpYjZvQk5ZRXNycGEvZWJ4dnpyVDlSZTVsOTBxbVhLVDBm?=
 =?utf-8?B?alhRTjZoYkZYWlZiME5acjNTZVFTa2E3aVpGSGFsOHFiS3pUYlhTdDg1Wk8z?=
 =?utf-8?B?VWlHcUhSbU52N2FjTWZhcmxzeFhPNUQzcUtkZWpQemRqL1dZTktvVjVWSXNt?=
 =?utf-8?B?azJsM3RIK1BWQXFZcjIyQzNLNjQ5Y1pNT2crMGt3dGVBRU0ycFFKd1dLOXRz?=
 =?utf-8?B?RUdUbEE5T1lXVUVWOFBnclNIRUZocG1aQWRzdExnMFpLNmJyZHE3LzcwRkVi?=
 =?utf-8?B?cGxnR2FwSGxYUDdrakRleEdHTU5wRVdpWWNpT0c3UXJsc1Vnb0NHcEd3MU1q?=
 =?utf-8?B?cjJBNUhyUzZUSWNCamp3QUlERWpPVVF5YTV3RzRJUVNSSHc4eTN6OC9UNFVx?=
 =?utf-8?B?Y3BoNG9KMHRWdC9DcmhlOXJXR2RZUG5MVkJRendTbXFtK2FodS9NdSs1N2FT?=
 =?utf-8?B?S3dxTVk2MVE1ZHVxaG1mZDl5dTJCNStmSUQvMDFRNE56SWVpWW1hRXhVbXVL?=
 =?utf-8?B?Q3dla01zdUpLenpNbXZCVGtYaVpMOUcxd1JNRUJYQ0Y3MTBzVW9xWUUxUUNm?=
 =?utf-8?B?cUJhUklJU3RGd1ZWQ3FlR29zOU1nSExRemJSODhzc1Q5TDc3ZDNVS3FITy9Y?=
 =?utf-8?B?UjArOWZ0aEJIU1U5c3RQcXNBWUY3V1J2VmJsY0tEYjJxcEJqR2JlcFJ6cEhP?=
 =?utf-8?B?RmxMTDlhalY1MDVCRGdCTVRRS2ZqMlljV25DNnB3MEZmaS83SVhmY01oQVZQ?=
 =?utf-8?B?VWJwZ2NtRDJYV2ZTLzZUVVEyMnBRVmZtTmpHN1BoYXQ5dWRoMFFyc2tMeE4y?=
 =?utf-8?B?SWx2Tm01VExNU0hZY0tSZDlMdTI0WFEwZGRhWXpqUEwzWW9ycTRiRkNKblN2?=
 =?utf-8?B?MVhCQjBOT3VKbG41eVRRcUhsQ1pqNFZzZjBqdkF5UXVWK1UrYlJaVjB6MGts?=
 =?utf-8?B?Y1k1OEd1NUFpVXhQZytzY2VkK1Z6RU96cjZ6T0ZBenJXOUp6czJ4TmF5MjRO?=
 =?utf-8?B?NFB1NzhQNDFNbmphdGJ2Y3g3U3RJa1FsYmZqbnhMaXdQVlhVd3Jwei9iL2tn?=
 =?utf-8?B?WklCOEdJWVB2RGdzNzhQbkpoNTdOWXhNSmpuQ3RqaGRib0w0ajViSmlXNVk1?=
 =?utf-8?B?UFhwYlhKZHJFREhWY0NwRjM1cklCa1U5TGhkL2ZNUlRVWXJFVk9Ndy9zQWR1?=
 =?utf-8?B?SytqU3hSN3pwZkMzQmRySnRvb2JjRFFhb0srRHNqWXdkaUtsR3ltbExUaFZF?=
 =?utf-8?B?SDRVS3c0Zmw0azlPYlBaa2NjRjJsaVBDTGV6YXhPN0NsaGV0cVgxMXlOTnZI?=
 =?utf-8?B?VFkrOExnZVVXYUpqWlMzMnRzS1Y4OVEvdHZLTkZtWU5Ibmlpa0RQYys4RTlr?=
 =?utf-8?Q?ab+N1peFYUxgE/sng6kPkN0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <336D392393CBA74DBE2552FD319BDDBD@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR05MB6611.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4755dd-824b-4e17-82d8-08d9dc5bcdcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 21:28:30.1474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ya4cE4BrVH1IEEIviz1MoPUBbUxtHqGmEQaJ0QiIeoxFB9d3BMf2LwVOdpRweDzJgldbzpaprvfj5D5OZ8AfFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB5932
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIyLTAxLTIwIGF0IDExOjAwICswMTAwLCBUaG9tYXMgWmltbWVybWFubiB3cm90
ZToNCj4gPiA+IA0KPiA+ID4gSWYgdGhhdCB3b3Jrcywgd291bGQgeW91IGNvbnNpZGVyIHByb3Rl
Y3RpbmcgcGNpX3JlcXVlc3RfcmVnaW9uKCkNCj4gPiA+IHdpdGgNCj4gPiA+IMKgwqAgI2lmIG5v
dCBkZWZpbmVkKENPTkZJR19GQl9TSU1QTEUpDQo+ID4gPiDCoMKgICNlbmRpZg0KPiA+ID4gDQo+
ID4gPiB3aXRoIGEgRklYTUUgY29tbWVudD8NCj4gPiANCj4gPiBZZXMsIEkgdGhpbmsgdGhhdCdz
IGEgZ29vZCBjb21wcm9taXNlLiBJJ2xsIHJlc3BpbiB0aGUgcGF0Y2ggd2l0aA0KPiA+IHRoYXQu
DQo+IA0KPiBCZWZvcmUgeW91IGRvIHRoYXQsIEkgaGF2ZSBvbmUgbW9yZSBwYXRjaCBmb3IgeW91
IHRvIHRyeS4gSXQncyBhbGwNCj4gdGhlIA0KPiBjaGFuZ2VzIGFzIGJlZm9yZSwgYnV0IG5vdyBm
YmRldiBob3QtdW5wbHVncyB0aGUgdW5kZXJseWluZyBwbGF0Zm9ybSANCj4gZGV2aWNlIGZyb20g
dGhlIGRldmljZSBoaWVyYXJjaHkuIFRoZSBCT09URkIgd2lsbCBub3QgY29uc3VtZSBwYXJ0cw0K
PiBvZiANCj4gdm13Z2Z4J3MgZGlzcGxheSBtZW1vcnkgcmFuZ2UgYW55IGxvbmdlci4gSXQncyBu
b3cgdGhlIHNhbWUgYmVoYXZpb3INCj4gYXMgDQo+IHdpdGggc2ltcGxlZHJtLg0KPiANCj4gVGhp
cyB3b3JrcyBmb3IgbWUgd2l0aCBzaW1wbGVmYiBhbmQgZWZpZmIgb24gaTkxNSBoYXJkd2FyZS4N
Cg0KWWVhLCB0aGF0IHdvcmtzIGZvciBtZSB0b28uIEJvdGggd2l0aCBzaW1wbGVkcm0gYW5kIHNp
bXBsZWZiLiBUaGUgcGF0Y2gNCmxvb2tzIGdvb2QgdG9vLg0KDQpEbyB5b3UgdGhpbmsgeW91J2xs
IGJlIGFibGUgdG8gZ2V0IHRoaXMgaW4gc3RhYmxlIGtlcm5lbHM/IElmIG5vdCBJJ2xsDQpzdGls
bCBuZWVkIHNvbWV0aGluZyBmb3Igdm13Z2Z4IHRvIG1ha2Uga2VybmVscyBiZXR3ZWVuIDUuMTUg
YW5kDQp3aGVuZXZlciB0aGlzIHBhdGNoIGdldHMgaW4gYm9vdCB3aXRoIGZiLg0KDQp6DQo=
