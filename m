Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9375493BE2
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 15:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355117AbiASOYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 09:24:20 -0500
Received: from mail-bn8nam11on2054.outbound.protection.outlook.com ([40.107.236.54]:32479
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355084AbiASOYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jan 2022 09:24:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INUCloRmxmQRp+QRJclwEuZKmx7ysz4WZXXy/vG7gDNy9QaCLk4dtqzN8X26swFYLUTJQEDUKms61d9rGUdfUp0gAHWw6wUoOJJTLZ7ICQObdIDZnXt60+QHD0ytR1oZgpbuaVdSkZvkqEh8i19x6ZAqkANB+BZklGfCZ7cJD9ZydnUYZIYv13m/iJ1Eajtxt/wVWbLveH+XqJiRS+lXjUsHXQ0c+uevnpRtZx8C4cLQYpQAFkt//x7YyVCnlUOxWzcvI6TVclbzhDX9/uvuIY809VCWVrO7duBqkmi2gPahhn4MsSU7LYknqPmqEOt+7PKw1+TYXZ18tYHQ5u2Xcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mVgOLTfSYaOhYnHLzA8Myo3B/z00xlSx7J1WbDBjqhM=;
 b=TtbuGTJeVFBVCmiNw+9GNaKqjReBqx0A+upIJvfDOhAYgi/5f+JiUvA5Uchddqn8Fu2jmkqsoGRK4h853ZEVvm8V5n1C+zrH5B0UjvbpL8OVpb4EYwAbktt3++42LmJt7e+hmYGuuw/C9mI8GxhlNc5hPlQiieDqQ+n0dqOJPowW+Aiki5atsU45tQgUFacS5sael6IDOHy6W5r6mePlxqHjmJeeR1qXxKpe3YFbDxAiODHwfyYQIkGisovxJNw/cOg7us/YLH3LvqjklzvmdGZfp9DOCu2hwE8k5QsT9w/vLOdqpOlymCk34P74PKTbSYdTiwHK3TxvTmVHKxfoKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mVgOLTfSYaOhYnHLzA8Myo3B/z00xlSx7J1WbDBjqhM=;
 b=ddjUNfCeFq844oS0eLI+U22eog3ECvy3CtNr796k16ThNztJ16hdaEOlFNIwBXR1OYD+7tvoqWx8thlvHlx8WQu8z55xYJAmbbN2/rienrEJyGiKpi20mitQWQ25Y2PqeYz+CgDEYeUeg7Q1IC2l0itgi6U9QB0YwfBJmWgdHQ0=
Received: from MN2PR05MB6624.namprd05.prod.outlook.com (2603:10b6:208:d8::18)
 by SN6PR05MB5312.namprd05.prod.outlook.com (2603:10b6:805:bf::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.4; Wed, 19 Jan
 2022 14:24:14 +0000
Received: from MN2PR05MB6624.namprd05.prod.outlook.com
 ([fe80::3de2:ebe0:8c9:c112]) by MN2PR05MB6624.namprd05.prod.outlook.com
 ([fe80::3de2:ebe0:8c9:c112%5]) with mapi id 15.20.4930.004; Wed, 19 Jan 2022
 14:24:14 +0000
From:   Zack Rusin <zackr@vmware.com>
To:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "javierm@redhat.com" <javierm@redhat.com>,
        "tzimmermann@suse.de" <tzimmermann@suse.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Thread-Topic: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Thread-Index: AQHYC8yinmr5RRCrG02Gv/mSECQCTKxpI6WAgAB5uACAAHSWgIAAVuqA
Date:   Wed, 19 Jan 2022 14:24:13 +0000
Message-ID: <d0f90d4cea4a137adb0b591ed9258540056a9813.camel@vmware.com>
References: <20220117180359.18114-1-zack@kde.org>
         <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
         <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
         <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
In-Reply-To: <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae19ca15-a236-4480-02bc-08d9db575e56
x-ms-traffictypediagnostic: SN6PR05MB5312:EE_
x-microsoft-antispam-prvs: <SN6PR05MB5312C08466AD0CAC1CF9F1ECCE599@SN6PR05MB5312.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uDlocsbIALqrGZR8kctwitm7hc1kE0ics4OTokKTH0Vl+CEq5ATSQsLrocmv0YpQg34iH9HXjF5m/FmAq8KJVfZ8x75ik0zlgZlKDVF8/aXC/KFXmuqHS5gexIRQnyI3MNHoJM75N+mn59MNyeE8tkkDit0hxGomjWD0ABg90le0ctEsWQndFsixVSjgkNTMW2o4flBjKO2SROranCfbWrQ570u+XrD+kwo1lpMYPGyd9OVqdsXaMM6IPrE0+NtK2MZOrlFKqwfEEu+J1NtzOBNU+/pZzbgxqwSeoTHvIvlZzG7dxMay9aCrBw7cg3bGAxOFpS4MSSvtUi63zAZbNlWuufLnEw138uWFnWhgo7zkEY7dqP0Uh1ee3xD6hI2NrfhxcKDuxojXFM+6OyqjZ35aNZl79FZ7vaVLCkC7qHnZd4vRwlobiaW7CEYx/8NrWY8vC0NiKArtcGwJylvKhZHhcVwpCn/UdwKmvZzS1kNON6aKGVdMLzJ7uGXVCRE2NCJPvj57mBgAD1a/n9bThlc+N0/vy+TR+mLTfFoCtCWI5LJ7SfF+NRSsCq/EjUGt2x0YNtYHRlUd9bs90+vsLkJJDJNL45KQqAeBs2HZj+uEbYM6EPWSEsJMUpxjnHy3bEPM6zccY0PQjYXRAv7/hmb0tWAF/5N5Ej/jmWFjFqn5cBOuxwA4cqxpklDOtrsx7YWQG1hCyGm1ZcTE2DqdzfpkYuHNlnZU95FqD94hgUYlXXnQmEmNdWF8eRzJMwke
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR05MB6624.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(66556008)(186003)(508600001)(26005)(71200400001)(66476007)(66446008)(4326008)(38070700005)(6486002)(122000001)(8676002)(6506007)(8936002)(53546011)(66946007)(64756008)(86362001)(316002)(6512007)(38100700002)(107886003)(54906003)(76116006)(83380400001)(2906002)(110136005)(36756003)(5660300002)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWt5S2dKWG9vY2dSeENlSGs5N21VYU5OTjhCeDZJSGdJN2l2cTBCUW9wRjYz?=
 =?utf-8?B?TWQvclAvVnMyUzFOSnlJd0lmcTVqZkYvOFBlSGthTjh5QjY1c0N5MmxCQ1Zn?=
 =?utf-8?B?andjcVFRMFVOSUVxRGpBekd3SCtSSEtsNWFQMnRhek9VY21yaXZabGVaeFho?=
 =?utf-8?B?SkZYN0dkNWdId3FDem5KMGp3bE1tbjEzS3hXK2tJa010bE96T3MrdWxsUEFr?=
 =?utf-8?B?R0VkNEYvemRXeEd1ZnY4SEt3eldqeEtiWnZmNmpPakRsYkdmdndOZlIwVXRu?=
 =?utf-8?B?c0hMQ0FETUFta28yUlNXNXdqTm5MeXkvTURwLytmZHNhV2xPdzVnUFlKbmda?=
 =?utf-8?B?TE5rdnJPUW5HRXBGMkUreWxGT1VTOXdsL0xaYk05SW94MTAwM2RkQmJjV0hB?=
 =?utf-8?B?UXIxdFhKaENIV1hBQ29Gb2VMTkNBaGszL2lJK0F3ek90dlk1WEpWQWxNUGpF?=
 =?utf-8?B?KytpMzRDaDVSYXNabGxvbkw0RllJUDlCdk1LcmgwSEhTekVjNC9PTTRodk5M?=
 =?utf-8?B?TSs2RFpZaUNTOWY3OTBnMkVjSlpScjVFZzVsWTNWTkFRYUx0enYrQ1U1Qm8y?=
 =?utf-8?B?ajA0WFhoMkJ6ZkpGV3VvWVpRTnpYV254V3plUDZ1alhMemcycHh0cDc4cUxx?=
 =?utf-8?B?NkFyK3pQN2FkaFI0R1hCRGw5L1Y2ZllFRkxOL1NyZ1gwR2NBRmNKeFVZcThp?=
 =?utf-8?B?MS9TZWdQWWE3amN6UVFFbEQ1MUVzM2hpYS9raDJGalVTWm9kMlZVZXB2V2ZW?=
 =?utf-8?B?dDlNSnVQUC80VFBzMzdvVGIzU0FENVB6b1l3WFU4NzBBTE1WaTBqOTNYWi90?=
 =?utf-8?B?Qng3RGZVeFJYYU15bDh5SG5mek1Qb2ZFWWplOUVPRjMzNllZU1QxaUw1TDhl?=
 =?utf-8?B?emNtRDgydUxOOHhZelpOWHJ3eWlDbWNqUzhpNVpzRXR1N01pNW50MFBRK1pM?=
 =?utf-8?B?bjhVaU5nRmVxNDVKUXg1Sk9oWGt1TnEyY2hFdkhCelJXemFSTTI5ZFVtNzFx?=
 =?utf-8?B?MWg3Vnp4TCtUcDh2bUcvd2pjc3ZIRE9TN0ZoMmY1Mk9aMERjNmVlUjMrbnlR?=
 =?utf-8?B?b1V2enJzbVV4bDh3cElQV1RNTExCbkdxYzJhSVo0WjlrcGhiR0Z0UnBZSllG?=
 =?utf-8?B?NUU1eXF0cXZkRzIrbVNjd3VoTVhaUEhxUW5lR0tIcnlmYVh2S3lxQXNMZ0Zx?=
 =?utf-8?B?ZlVkdnBQTW5CQzZCVloxclgxUVp3cnJkVERNajVHeW1zdURka3lmQzY5VjNn?=
 =?utf-8?B?d2Y0c0E3MEppU1luU1lGblREajRnb1lmcHduR0ptaDczM21PTFB0MGFRWTdo?=
 =?utf-8?B?T3N3U2lBbjhUSUIzeFNNN2xBcHh2OThYY0FEbE50NDZGSWU5NzNoRmZIdTV4?=
 =?utf-8?B?MTRtSkJ0UE5RNGRBaEtocWpVWnY4SjRscmM3RXBnRDNtR0p5SkgyU29TV0Nq?=
 =?utf-8?B?ak5kbkFzUGZub1YzcGtXQW9jcDVvWXBoOGZlUjNqdTl4RWhrWmRhRmt4cktG?=
 =?utf-8?B?K0RKRFl0bm8raFlRZlo0UnorZUtvMzd0cWRSOCtISmJjcXArUGduRjFZS3dq?=
 =?utf-8?B?UDdmVDRwcGdFaHl3amErdUp1VVN0Y1RiWTBMbmtEdzIwdXcrWWJTYXIwVjVC?=
 =?utf-8?B?UXF4RFpEckhIS3hZV1hZU1orcWUzaTBVVDRRb0VzQk1XNU14TVIxRnhSY1M3?=
 =?utf-8?B?QUcvUDBqWFl2ZGdKWkJCS2RmOGsxK0J6emo3dUVOaG9seCtKKzRpNm5CdzVV?=
 =?utf-8?B?THdISE1FdnA4SzBYYTFzOVM4UTNxbjZ2TjBTeDVoRWlFUkZDU3FmNTJQZDgv?=
 =?utf-8?B?ZzV1UlZmSFdwVmR1cGRxSG1CNXAxN3VsSHQvVFp6Q0Nsa1Q0UXhSVGt2YWo3?=
 =?utf-8?B?c0hQeFhvWG10Ty9ra1AyUkxaYUs0R05nWGVGb3RvQmxJY3I1elU4ZUlnakZZ?=
 =?utf-8?B?WmUvU29tQ1dSM2hUMm9UWEdGaGFaYnJyNmQ3MCtNcnVjcmV0RDB0N1ZxcXZ1?=
 =?utf-8?B?S0VwTEJVMy82UDdZTTh5bmwrcFgwYnNld3AvMUkxWVhldERpZWhIdjdzU21z?=
 =?utf-8?B?K3E5U0N6ZXZtT1FTdGRobmF4UjBIckI3dmhkM1dWSjcyY2ltM0cxeFF1ZnQy?=
 =?utf-8?B?ZUYydzN0YnhXSGYxZWZGT1g1cDZ6M2RRQnBpT0wwQ09rcm1jbTdmUm1mM1h6?=
 =?utf-8?Q?EGhHKvxLb0dcjDQFZLO3n/Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD44F5A29490FB4E8FF2A000F5C42031@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR05MB6624.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae19ca15-a236-4480-02bc-08d9db575e56
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 14:24:13.9874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wmnn32IMl59ZCN1Jq49bcct9MwYv/5gwsw4dVEhcLkGw8zIAkjGqE3D+8JV/lKcE1BmkVo5MeBdIA7WaoBAruA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB5312
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIyLTAxLTE5IGF0IDEwOjEzICswMTAwLCBUaG9tYXMgWmltbWVybWFubiB3cm90
ZToNCj4gSGkNCj4gDQo+IEFtIDE5LjAxLjIyIHVtIDAzOjE1IHNjaHJpZWIgWmFjayBSdXNpbjoN
Cj4gPiBPbiBUdWUsIDIwMjItMDEtMTggYXQgMjA6MDAgKzAxMDAsIEphdmllciBNYXJ0aW5leiBD
YW5pbGxhcyB3cm90ZToNCj4gPiA+IEhlbGxvIFphY2ssDQo+ID4gPiANCj4gPiA+IE9uIDEvMTcv
MjIgMTk6MDMsIFphY2sgUnVzaW4gd3JvdGU6DQo+ID4gPiA+IEZyb206IFphY2sgUnVzaW4gPHph
Y2tyQHZtd2FyZS5jb20+DQo+ID4gPiA+IA0KPiA+ID4gPiBXaGVuIHN5c2ZiX3NpbXBsZSBpcyBl
bmFibGVkIGxvYWRpbmcgdm13Z2Z4IGZhaWxzIGJlY2F1c2UgdGhlDQo+ID4gPiA+IHJlZ2lvbnMN
Cj4gPiA+ID4gYXJlIGhlbGQgYnkgdGhlIHBsYXRmb3JtLiBJbiB0aGF0IGNhc2UNCj4gPiA+ID4g
cmVtb3ZlX2NvbmZsaWN0aW5nKl9mcmFtZWJ1ZmZlcnMNCj4gPiA+ID4gb25seSByZW1vdmVzIHRo
ZSBzaW1wbGVmYiBidXQgbm90IHRoZSByZWdpb25zIGhlbGQgYnkgc3lzZmIuDQo+ID4gPiA+IA0K
PiA+ID4gDQo+ID4gPiBJbmRlZWQsIHRoYXQncyBhbiBpc3N1ZS4gSSB3b25kZXIgaWYgd2Ugc2hv
dWxkIGRyb3AgdGhlDQo+ID4gPiBJT1JFU09VUkNFX0JVU1kNCj4gPiA+IGZsYWcgZnJvbSB0aGUg
bWVtb3J5IHJlc291cmNlIGFkZGVkIHRvIHRoZSAic2ltcGxlLWZyYW1lYnVmZmVyIg0KPiA+ID4g
ZGV2aWNlDQo+ID4gPiA/DQo+ID4gDQo+ID4gSSB0aGluayB0aGlzIGlzIG9uZSBvZiB0aG9zZSBj
YXNlcyB3aGVyZSBpdCBkZXBlbmRzIG9uIHdoYXQgd2UgcGxhbg0KPiA+IHRvDQo+ID4gZG8gYWZ0
ZXIgdGhhdC4gU2VtZW50aWNhbGx5IGl0IG1ha2VzIHNlbnNlIHRvIGhhdmUgaXQgaW4gdGhlcmUg
LQ0KPiA+IHRoZQ0KPiA+IGZyYW1lYnVmZmVyIG1lbW9yeSBpcyBjbGFpbWVkIGJ5IHRoZSAic2lt
cGxlLWZyYW1lYnVmZmVyIiBhbmQgaXQncw0KPiA+IGJ1c3ksIGl0J3MganVzdCB0aGF0IGl0IGNy
ZWF0ZXMgaXNzdWVzIGZvciBkcml2ZXJzIGFmdGVyIHVubG9hZGluZy4NCj4gPiBJDQo+ID4gdGhp
bmsgcmVtb3ZpbmcgaXQsIHdoaWxlIG1ha2luZyB0aGluZ3MgZWFzaWVyIGZvciBkcml2ZXJzLCB3
b3VsZCBiZQ0KPiA+IGNvbmZ1c2luZyBmb3IgcGVvcGxlIHJlYWRpbmcgdGhlIGNvZGUgbGF0ZXIs
IHVubGVzcyB0aGVyZSdzIHNvbWUNCj4gPiBraW5kDQo+ID4gb2YgY2xlYW51cCB0aGF0IHdvdWxk
IGhhcHBlbiB3aXRoIGl0IChlLmcuIHJlbW92aW5nIElPUkVTT1VSQ0VfQlVTWQ0KPiA+IGFsdG9n
ZXRoZXIgYW5kIG1ha2luZyB0aGUgZHJtIGRyaXZlcnMgcHJvcGVybHkgcmVxdWVzdCB0aGVpcg0K
PiA+IHJlc291cmNlcykuwqBBdCBsZWFzdCBieSBpdHNlbGYgaXQgZG9lc24ndCBzZWVtIHRvIGJl
IG11Y2ggYmV0dGVyDQo+ID4gc29sdXRpb24gdGhhbiBoYXZpbmcgdGhlIGRybSBkcml2ZXJzIG5v
dCBjYWxsDQo+ID4gcGNpX3JlcXVlc3RfcmVnaW9uW3NdLA0KPiA+IHdoaWNoIGFwYXJ0IGZyb20g
aHlwZXJ2IGFuZCBjaXJydXMgKGlpcmMgYm9jaHMgZG9lcyBpdCBmb3INCj4gPiByZXNvdXJjZXMN
Cj4gPiBvdGhlciB0aGFuIGZiIHdoaWNoIHdvdWxkbid0IGhhdmUgYmVlbiBjbGFpbWVkIGJ5ICJz
aW1wbGUtDQo+ID4gZnJhbWVidWZmZXIiKQ0KPiA+IGlzIGFscmVhZHkgdGhlIGNhc2UuDQo+ID4g
DQo+ID4gSSBkbyB0aGluayB3ZSBzaG91bGQgZG8gb25lIG9mIHRoZW0gdG8gbWFrZSB0aGUgY29k
ZWJhc2UgY29oZXJlbnQ6DQo+ID4gZWl0aGVyIHJlbW92ZSBJT1JFU09VUkNFX0JVU1kgZnJvbSAi
c2ltcGxlLWZyYW1lYnVmZmVyIiBvciByZW1vdmUNCj4gPiBwY2lfcmVxdWVzdF9yZWdpb25bc10g
ZnJvbSBoeXBlcnYgYW5kIGNpcnJ1cy4NCj4gDQo+IEkganVzdCBkaXNjdXNzZWQgdGhpcyBhIGJp
dCB3aXRoIEphdmllci4gSXQncyBhIHByb2JsZW0gd2l0aCB0aGUgDQo+IHNpbXBsZS1mcmFtZWJ1
ZmZlciBjb2RlLCByYXRoZXIgdGhlbiB2bXdnZnguDQo+IA0KPiBJTUhPIHRoZSBiZXN0IHNvbHV0
aW9uIGlzIHRvIGRyb3AgSU9SRVNPVVJDRV9CVVNZIGZyb20gc3lzZmIgYW5kIGhhdmUNCj4gZHJp
dmVycyByZWdpc3Rlci9yZWxlYXNlIHRoZSByYW5nZSB3aXRoIF9CVVNZLiBUaGF0IHdvdWxkIHNp
Z25hbCB0aGUgDQo+IG1lbW9yeSBiZWxvbmdzIHRvIHRoZSBzeXNmYiBkZXZpY2UgYnV0IGlzIG5v
dCBidXN5IHVubGVzcyBhIGRyaXZlcg0KPiBoYXMgDQo+IGJlZW4gYm91bmQuIEFmdGVyIHNpbXBs
ZWZiIHJlbGVhc2VkIHRoZSByYW5nZSwgaXQgc2hvdWxkIGJlICdub24tDQo+IGJ1c3knIA0KPiBh
Z2FpbiBhbmQgYXZhaWxhYmxlIGZvciB2bXdnZnguIFNpbXBsZWRybSBkb2VzIGEgaG90LXVucGx1
ZyBvZiB0aGUNCj4gc3lzZmIgDQo+IGRldmljZSwgc28gdGhlIG1lbW9yeSByYW5nZSBnZXRzIHJl
bGVhc2VkIGVudGlyZWx5LiBJZiB5b3Ugd2FudCwgSSdsbA0KPiBwcmVwYXJlIHNvbWUgcGF0Y2hl
cyBmb3IgdGhpcyBzY2VuYXJpby4NCj4gDQo+IElmIHRoaXMgZG9lc24ndCB3b3JrLCBwdXNoaW5n
IGFsbCByZXF1ZXN0L3JlbGVhc2UgcGFpcnMgaW50byBkcml2ZXJzIA0KPiB3b3VsZCBiZSBteSBu
ZXh0IG9wdGlvbi4NCj4gDQo+IElmIG5vbmUgb2YgdGhpcyBpcyBmZWFzaWJsZSwgd2UgY2FuIHN0
aWxsIHJlbW92ZSBwY2lfcmVxdWVzdF9yZWdpb24oKQ0KPiBmcm9tIHZtd2dmeC4NCg0KDQpJIHRo
aW5rIHRoYXQncyBvcnRob2dvbmFsIHRvIHRoZSBmaXggYmVjYXVzZSBoYXZpbmcgcGNpX3JlcXVl
c3RfcmVnaW9uDQptYWtlcyB2bXdnZnggYmVoYXZlIGRpZmZlcmVudGx5IGZyb20gbWFqb3JpdHkg
b2YgRFJNIGRyaXZlcnMsIGUuZy4gb24NCnN5c3RlbXMgd2l0aCBzeXNmYiBlbmFibGVkIHdpdGgg
NS4xNSB2bXdnZnggZmFpbHMgdG8gYm9vdCBhbmQgbGVhdmVzDQp0aGUgc3lzdGVtIGJyb2tlbiB3
aXRob3V0IGFueSBmYiBkcml2ZXIgKGJlY2F1c2Ugd2hpbGUgd2UgaGF2ZQ0KKnJlbW92ZV9jb25m
bGljdGluZypfZnJhbWVidWZmZXJzIHdlIGRvbid0IGhhdmUgZHJtX3Jlc3RvcmVfc3lzdGVtX2Zi
DQpvciBzdWNoIHRvIGxvYWQgYmFjayB0aGUgYm9vdCBmYiBhZnRlciBkcm0gZHJpdmVyIGxvYWQg
ZmFpbHMpIGJ1dCBzaW5jZQ0KaXQncyBvbmUgb2YgdGhlIGZldyBkcml2ZXJzIHdoaWNoIGRvZXMg
cmVxdWVzdCByZWdpb25zIGl0IHRvb2sgYSBiaXQNCmZvciB1cyB0byBub3RpY2UuDQoNClNvIGlu
IHRoaXMgY2FzZSBJJ2QgbXVjaCByYXRoZXIgYmUgbGlrZSB0aGUgb3RoZXIgZHJpdmVycyByYXRo
ZXIgdGhhbg0KY29ycmVjdCBiZWNhdXNlIGl0IGxvd2VycyB0aGUgb2RkcyBvZiB2bXdnZnggYnJl
YWtpbmcgaW4gdGhlIGZ1dHVyZS4NCg0Keg0KDQo=
