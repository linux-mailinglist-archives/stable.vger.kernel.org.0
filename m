Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86748493CBC
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 16:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355623AbiASPNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 10:13:12 -0500
Received: from mail-co1nam11on2069.outbound.protection.outlook.com ([40.107.220.69]:23881
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355614AbiASPMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jan 2022 10:12:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MX31tLnGTccSmg8VWSMbfSS8zNwX8bn0C0979aVI+jGsaIbM2M51PUgcL4OmZ5g9xN77Rz3sZWeFAUFa0CWP5EVc8Nvn+em2vVMkxG5etHrwiXNBx4fpjPJsc4n7iI2SXe4HfxAqB1VMxBwXnElTDWfgbCOkX4vz0nRCoRKdm5OCssVxn0vzdtnHQ87044DLy6WzkMDVOoG20T3jk+wxoTAFO3xwaV0BLfbOT7JY6z4IdWc3pDvGzP7Lt7PgOj2CjDygMeHhvxkdLf3/1yZjb1Rto6HGNKJTYMGn7jYN6C5mQ/N1pr97/3R1DvRyRsItggqaJYP/rt1lFXmqsY8s1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wPTOhaEsoMyXjQXUuQUKBARHFmax3w1LsS8CvZWMi6I=;
 b=Nb0MYOQjUhWo6rypoD70MYFvbeEtM5hZjoBkG8NIPyOOe5R1IcKfeQe+FnQcs7US60hqR99qMuyOAKtubYgEQ7qnfF45qJlZ0iy4fgwlaoO+clkeRg6gCGj+pSzV4v+PxLfb5/qelNWVC86iCLbbL5erfmkFcyr7fzCbj2DX1IbSItuksxDrBQyjmEz5O4R0sEoGpfBDClebjUJ3jAtWC3soVlMPgG8wRLDipoEyfyOnRllR9W2Xd559gIaoiyuo4Iwnl1A173X9fb3ba1WyPQggWVHumdOt76p6o0oAkKMh6+vEZtu7Pw3zFyVc+M9NS3kx9n7atdi8AYKsmKzrig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPTOhaEsoMyXjQXUuQUKBARHFmax3w1LsS8CvZWMi6I=;
 b=QVqbIpKQXDkkDEGhTfIRrQA+XCN/djtQLkdJ4XTbA91y4MyMa/qyJk6IjKPYVQp580y32t6mIMobuDbrTSAhI1Tii9lVPKlcAI/+S5ch2Ssor4x+XuCHlYVqKvixW083FVpJoeVk+eyDTBA4haefULgFEzjxR/DLyEKyOV+zzlA=
Received: from MN2PR05MB6624.namprd05.prod.outlook.com (2603:10b6:208:d8::18)
 by BYAPR05MB6117.namprd05.prod.outlook.com (2603:10b6:a03:aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 19 Jan
 2022 15:12:44 +0000
Received: from MN2PR05MB6624.namprd05.prod.outlook.com
 ([fe80::3de2:ebe0:8c9:c112]) by MN2PR05MB6624.namprd05.prod.outlook.com
 ([fe80::3de2:ebe0:8c9:c112%5]) with mapi id 15.20.4930.004; Wed, 19 Jan 2022
 15:12:44 +0000
From:   Zack Rusin <zackr@vmware.com>
To:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "javierm@redhat.com" <javierm@redhat.com>,
        "tzimmermann@suse.de" <tzimmermann@suse.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Thread-Topic: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Thread-Index: AQHYC8yinmr5RRCrG02Gv/mSECQCTKxpI6WAgAB5uACAAHSWgIAAUE4AgAAUKgA=
Date:   Wed, 19 Jan 2022 15:12:44 +0000
Message-ID: <80fc6b88d659dd7281364daccfed1fd294e785dc.camel@vmware.com>
References: <20220117180359.18114-1-zack@kde.org>
         <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
         <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
         <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
         <afc4c659-b92e-3227-634f-7c171b7a74b3@suse.de>
In-Reply-To: <afc4c659-b92e-3227-634f-7c171b7a74b3@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51049ecd-4885-44e4-50b6-08d9db5e2550
x-ms-traffictypediagnostic: BYAPR05MB6117:EE_
x-microsoft-antispam-prvs: <BYAPR05MB6117A0960CD983E3447208F3CE599@BYAPR05MB6117.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9kcLIEeyPEORj/GL7BbDSwQgx1XH//cyJo+hxdo8eZI/ORDqgKS1x16tFQvKjAw889eKt+ImyezwosjxneKYgd3FOPDFhoO0XEI3lbqlMaMYhybg0Jfs+VGZH2tT2wyOEm6GOS0RUFb1qVmHJYoCswIvCxncmNYr6kebRnd8ruoAfsMSGTjrnBrE69dtfiF7qPXdpYzOx1/tl7XfQHkI/zlPCedJ2oUNhInoOCd+owcBCsa94MuZhSq9W9Slid9cC05oKFQK1p+T3tnDpI8GXmqI+taFT9U4boUK/kWC22MqPEppBwaaa9jpNMjDR+6XhkIVXQDVH2JaRWyTsBmViy0d6GMg4KsBiOcbXbsq5XgeVWoBxajYmhCjzijafYmpPgtRtpWiy1IzaTuC34/0Ib6XJpPKxjAj+lEfTw8O7DXJLss7hT/cYToOLOqYOi+oDcTSBvFpYnWcRFWfWgENXiJeSQEU0bbH2Z0/FruAHnfXoLgrq0O7BsWubC1rnEnRDwIMOz9Wvbi5umNWmJgWjvwjeu7EYktBWLK22NOZ0b8KOV6Ic896ydehjs6r374jMrJ4Z+TaHNMD5KtZauZ+YkKrHWXSzi0zwVf/7PzZWcZivFyRMM59XVV+CZHetrq9LXN/+ctV/+4PY2f2GpHlZ6town6llrEv1iiy5KA3/FnEglsQ2Eek12EbYzJZ9q2zj84dvAW/Cz9B1sSzuciQDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR05MB6624.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(2906002)(186003)(26005)(2616005)(38100700002)(122000001)(107886003)(83380400001)(38070700005)(316002)(66946007)(53546011)(64756008)(8936002)(66446008)(66476007)(6506007)(8676002)(66556008)(508600001)(4326008)(71200400001)(6486002)(110136005)(86362001)(76116006)(54906003)(36756003)(6512007)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEhPUjM1ZHQ2c0d3Sms4bXpJbWF0S0ZBWUhnK3VXbytCZXhOTi9HUUYrbzQy?=
 =?utf-8?B?Zzd1QjE2UDBNbHhxSklFWFJMUFJ5SEdNdkZudVEvREdBa2trdFRNOVZSRnhF?=
 =?utf-8?B?MGxMN1ZHaUg0RFZaeHVTanJLcUhKNzNUeU8xRkdnZmxoT1ZhOHJia0orZmhG?=
 =?utf-8?B?VDNnS21yRU5kQ3ZDdFNaSVRPWVhSRCtkOTFHTmQxM1dVSHVYQjF3a0JEUGhW?=
 =?utf-8?B?QnROb2ovZ214TTBBMU1xMG9hUVpqU21FVWRBRVJPNWdtUXJIZDBvZnB6SCtp?=
 =?utf-8?B?bU1FOVJoYXN2ZGlrQmVVNlh0a1RkVlZ0dlBwQmUyM2Q5WUtsWlVjaUdZSWhG?=
 =?utf-8?B?VHp5YzlwRDdXTmZ0RzFFdUJ0Z0lOd2NSazNzUGNTRThKZGJOZkYwOVRSOVRy?=
 =?utf-8?B?RG5HWEZvOTVUeThtSDlMeTJubjdweC9yV2ZvNklneWEvU1puTGVldlpVMDNJ?=
 =?utf-8?B?QU5aYTFKRVZ0TjlYeFRrZElvTEllNnZ3YTlHTUk4dG1WamdXK0x0SUVNYUI0?=
 =?utf-8?B?YjFqenp2V09XQmsxLzA2SWpEZTU0b2NjZHg3VGxXaDR6ZEdaY2lENVRiWHR4?=
 =?utf-8?B?V09lQlQrUE9scDdxOVVlcEs3WVRNaGV5L3ZKRE9KWkltTjE1ZEovM24vem5Y?=
 =?utf-8?B?TFU1NmUrRVZlRlJmREVLcE1YOXAyK3c5MDl6QktlUlNXdE96dXFDczl2U1NH?=
 =?utf-8?B?WVBGMHZDVHR1c2FQZUNTUDhXU0NXWHIvOFJtZXVLU0ZOYzBESjFQczMxcDM4?=
 =?utf-8?B?b1hWRXNaWkdxcksyN1h6eEZ5ODJxMFl1T3FiMXVHSU5BejRQWDMvVE5tS3hj?=
 =?utf-8?B?SHBvcjVZUUloRnQ4ZGVxb1YraElwU3lKc21wNzZKRmxJUVBCR2F5UU13UTEr?=
 =?utf-8?B?OWJrTUt3RHQ0dWdJaStabEFLRDdXSDMyOVFQeTdSeW91T0xqb3R6STNjR2Rn?=
 =?utf-8?B?UnphYnFZSVBxRW9UT2Y1RjlQTTFRdjhLV1pHZS9Hdmk3TVh2cEpXeVg5WVBG?=
 =?utf-8?B?anJaYmJ1WnpkQWd5Q3F5NTNMTXVhdENOd2owV1U1SWtRbDJ5VHFXK0I1WGpB?=
 =?utf-8?B?ZkJ2WmYrc2gzUE02VFZHMnFIOThHRUhNVmtxemIvWmtSVkMyWmpKUkpuUG1Y?=
 =?utf-8?B?L1c1TWVrVGh6Wi9CdTBWdUF1ajZLRXlqWlF2ckNrNUZCTEV2L1N6YnZEZERy?=
 =?utf-8?B?emJhZEVxRFN0QXFKY1hXTDlLVmlEUnllWkxJNHo2OC9panhCTHdTUEJHODY2?=
 =?utf-8?B?Qmd2b3ZPVmlXekVIM1R5SG9lWGlKNFMzRGtQMjlZNTdYNjBFZkdwS2lSV0V6?=
 =?utf-8?B?OFl3b3lIZHlPM05SYkQ2R2d4dFZpeGF6K3ZRaytIS0VQRWY1MTRMR2d1VkQ5?=
 =?utf-8?B?UHR3azBwend0YkpmcnlIU1I0UnVXVHZkTXNUNjZkWUJMakl6Zzg5d0NodHpw?=
 =?utf-8?B?OVI3YzY4QXpDQUFLNitxUDAxeS9qajhrWHJDeURqT292b2JTMVlSV3ZGYzhs?=
 =?utf-8?B?OTg0Q2VHTUUyMEJmTzBvRlR4dGF6bEk5TG5OUk4yUmdWV201cVhEUHJoUTJo?=
 =?utf-8?B?TWVGMVlqRzJGOW9uT1RjbjJxUnk1Si9lQ3ZuMnRxU2ZkVHpOWTF3bmdiSnEz?=
 =?utf-8?B?c21SRGF2M0llV2VsUFRUZkFkVzN2anEzdHEyT0Y2ck4wdW4zUVIybStLNk1a?=
 =?utf-8?B?eUdEcURUZ3k3NGRDalArczZXaVdnckkzOXlidnFlQ2tQWTZWN2N2a0I4ZVJ2?=
 =?utf-8?B?Wjk1NmxycXB6UjhKeGZjOWFTYlVYeEtVUEtONmpQYjVyazRjbVB4ZTU5TmVT?=
 =?utf-8?B?NXkxME1WNWNJZUlwM0ZrYTgzU2M3UTV6QzhoNm5oNkRMS01xWi9QbVUxeVNT?=
 =?utf-8?B?dEI1TjdHTm1CZGVJaWRBb1M4SHh3QnAzNFczc3RSK05tRXA1QzBibTc3eTFL?=
 =?utf-8?B?ZzVCeDJ1V0ptMHQrY1BUWkJoVDVYYUFIa2Y2V045RmxORHl5Y1Yrbm8vSm9K?=
 =?utf-8?B?QmRPaFZwYy9ucEJ2QlloYWtGUkFpVFozNGhBM1VMeWdlRkZxclgxOXc2czFL?=
 =?utf-8?B?djE3M25PRDE2cjQwM25nOTZGN0FQamNnaXMzY2ZGYVRLekx4bUhJRHNKN2dy?=
 =?utf-8?B?bUlqTUpFbGNrYjBETlEzVm5YVmRTem05dS9ZK0ptNk1WSkZKK1F3YzJ3K0Nu?=
 =?utf-8?Q?HKeNpLz2iGupdkgk2hb5jLQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21E50B15B5805144B301B6F779828C7A@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR05MB6624.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51049ecd-4885-44e4-50b6-08d9db5e2550
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 15:12:44.7502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x4VecD8rrrxftoRqYDEdfT8cO9eyBRKN++xyR/XtgqxKUInXcdjApj+gr+rUmWGqKti6f76kPQvrBUBwThNZ8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6117
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIyLTAxLTE5IGF0IDE1OjAwICswMTAwLCBUaG9tYXMgWmltbWVybWFubiB3cm90
ZToNCj4gSGkgWmFjaw0KPiANCj4gQW0gMTkuMDEuMjIgdW0gMTA6MTMgc2NocmllYiBUaG9tYXMg
WmltbWVybWFubjoNCj4gPiBIaQ0KPiA+IA0KPiA+IEFtIDE5LjAxLjIyIHVtIDAzOjE1IHNjaHJp
ZWIgWmFjayBSdXNpbjoNCj4gPiA+IE9uIFR1ZSwgMjAyMi0wMS0xOCBhdCAyMDowMCArMDEwMCwg
SmF2aWVyIE1hcnRpbmV6IENhbmlsbGFzIHdyb3RlOg0KPiA+ID4gPiBIZWxsbyBaYWNrLA0KPiA+
ID4gPiANCj4gPiA+ID4gT24gMS8xNy8yMiAxOTowMywgWmFjayBSdXNpbiB3cm90ZToNCj4gPiA+
ID4gPiBGcm9tOiBaYWNrIFJ1c2luIDx6YWNrckB2bXdhcmUuY29tPg0KPiA+ID4gPiA+IA0KPiA+
ID4gPiA+IFdoZW4gc3lzZmJfc2ltcGxlIGlzIGVuYWJsZWQgbG9hZGluZyB2bXdnZnggZmFpbHMg
YmVjYXVzZSB0aGUNCj4gPiA+ID4gPiByZWdpb25zDQo+ID4gPiA+ID4gYXJlIGhlbGQgYnkgdGhl
IHBsYXRmb3JtLiBJbiB0aGF0IGNhc2UNCj4gPiA+ID4gPiByZW1vdmVfY29uZmxpY3RpbmcqX2Zy
YW1lYnVmZmVycw0KPiA+ID4gPiA+IG9ubHkgcmVtb3ZlcyB0aGUgc2ltcGxlZmIgYnV0IG5vdCB0
aGUgcmVnaW9ucyBoZWxkIGJ5IHN5c2ZiLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4g
SW5kZWVkLCB0aGF0J3MgYW4gaXNzdWUuIEkgd29uZGVyIGlmIHdlIHNob3VsZCBkcm9wIHRoZQ0K
PiA+ID4gPiBJT1JFU09VUkNFX0JVU1kNCj4gPiA+ID4gZmxhZyBmcm9tIHRoZSBtZW1vcnkgcmVz
b3VyY2UgYWRkZWQgdG8gdGhlICJzaW1wbGUtZnJhbWVidWZmZXIiDQo+ID4gPiA+IGRldmljZQ0K
PiA+ID4gPiA/DQo+ID4gPiANCj4gPiA+IEkgdGhpbmsgdGhpcyBpcyBvbmUgb2YgdGhvc2UgY2Fz
ZXMgd2hlcmUgaXQgZGVwZW5kcyBvbiB3aGF0IHdlIHBsYW4NCj4gPiA+IHRvDQo+ID4gPiBkbyBh
ZnRlciB0aGF0LiBTZW1lbnRpY2FsbHkgaXQgbWFrZXMgc2Vuc2UgdG8gaGF2ZSBpdCBpbiB0aGVy
ZSAtDQo+ID4gPiB0aGUNCj4gPiA+IGZyYW1lYnVmZmVyIG1lbW9yeSBpcyBjbGFpbWVkIGJ5IHRo
ZSAic2ltcGxlLWZyYW1lYnVmZmVyIiBhbmQgaXQncw0KPiA+ID4gYnVzeSwgaXQncyBqdXN0IHRo
YXQgaXQgY3JlYXRlcyBpc3N1ZXMgZm9yIGRyaXZlcnMgYWZ0ZXIgdW5sb2FkaW5nLg0KPiA+ID4g
SQ0KPiA+ID4gdGhpbmsgcmVtb3ZpbmcgaXQsIHdoaWxlIG1ha2luZyB0aGluZ3MgZWFzaWVyIGZv
ciBkcml2ZXJzLCB3b3VsZCBiZQ0KPiA+ID4gY29uZnVzaW5nIGZvciBwZW9wbGUgcmVhZGluZyB0
aGUgY29kZSBsYXRlciwgdW5sZXNzIHRoZXJlJ3Mgc29tZQ0KPiA+ID4ga2luZA0KPiA+ID4gb2Yg
Y2xlYW51cCB0aGF0IHdvdWxkIGhhcHBlbiB3aXRoIGl0IChlLmcuIHJlbW92aW5nIElPUkVTT1VS
Q0VfQlVTWQ0KPiA+ID4gYWx0b2dldGhlciBhbmQgbWFraW5nIHRoZSBkcm0gZHJpdmVycyBwcm9w
ZXJseSByZXF1ZXN0IHRoZWlyDQo+ID4gPiByZXNvdXJjZXMpLsKgQXQgbGVhc3QgYnkgaXRzZWxm
IGl0IGRvZXNuJ3Qgc2VlbSB0byBiZSBtdWNoIGJldHRlcg0KPiA+ID4gc29sdXRpb24gdGhhbiBo
YXZpbmcgdGhlIGRybSBkcml2ZXJzIG5vdCBjYWxsDQo+ID4gPiBwY2lfcmVxdWVzdF9yZWdpb25b
c10sDQo+ID4gPiB3aGljaCBhcGFydCBmcm9tIGh5cGVydiBhbmQgY2lycnVzIChpaXJjIGJvY2hz
IGRvZXMgaXQgZm9yDQo+ID4gPiByZXNvdXJjZXMNCj4gPiA+IG90aGVyIHRoYW4gZmIgd2hpY2gg
d291bGRuJ3QgaGF2ZSBiZWVuIGNsYWltZWQgYnkgInNpbXBsZS0NCj4gPiA+IGZyYW1lYnVmZmVy
IikNCj4gPiA+IGlzIGFscmVhZHkgdGhlIGNhc2UuDQo+ID4gPiANCj4gPiA+IEkgZG8gdGhpbmsg
d2Ugc2hvdWxkIGRvIG9uZSBvZiB0aGVtIHRvIG1ha2UgdGhlIGNvZGViYXNlIGNvaGVyZW50Og0K
PiA+ID4gZWl0aGVyIHJlbW92ZSBJT1JFU09VUkNFX0JVU1kgZnJvbSAic2ltcGxlLWZyYW1lYnVm
ZmVyIiBvciByZW1vdmUNCj4gPiA+IHBjaV9yZXF1ZXN0X3JlZ2lvbltzXSBmcm9tIGh5cGVydiBh
bmQgY2lycnVzLg0KPiA+IA0KPiA+IEkganVzdCBkaXNjdXNzZWQgdGhpcyBhIGJpdCB3aXRoIEph
dmllci4gSXQncyBhIHByb2JsZW0gd2l0aCB0aGUgDQo+ID4gc2ltcGxlLWZyYW1lYnVmZmVyIGNv
ZGUsIHJhdGhlciB0aGVuIHZtd2dmeC4NCj4gPiANCj4gPiBJTUhPIHRoZSBiZXN0IHNvbHV0aW9u
IGlzIHRvIGRyb3AgSU9SRVNPVVJDRV9CVVNZIGZyb20gc3lzZmIgYW5kIGhhdmUNCj4gPiBkcml2
ZXJzIHJlZ2lzdGVyL3JlbGVhc2UgdGhlIHJhbmdlIHdpdGggX0JVU1kuIFRoYXQgd291bGQgc2ln
bmFsIHRoZSANCj4gPiBtZW1vcnkgYmVsb25ncyB0byB0aGUgc3lzZmIgZGV2aWNlIGJ1dCBpcyBu
b3QgYnVzeSB1bmxlc3MgYSBkcml2ZXINCj4gPiBoYXMgDQo+ID4gYmVlbiBib3VuZC4gQWZ0ZXIg
c2ltcGxlZmIgcmVsZWFzZWQgdGhlIHJhbmdlLCBpdCBzaG91bGQgYmUgJ25vbi0NCj4gPiBidXN5
JyANCj4gPiBhZ2FpbiBhbmQgYXZhaWxhYmxlIGZvciB2bXdnZnguIFNpbXBsZWRybSBkb2VzIGEg
aG90LXVucGx1ZyBvZiB0aGUNCj4gPiBzeXNmYiANCj4gPiBkZXZpY2UsIHNvIHRoZSBtZW1vcnkg
cmFuZ2UgZ2V0cyByZWxlYXNlZCBlbnRpcmVseS4gSWYgeW91IHdhbnQsIEknbGwNCj4gPiBwcmVw
YXJlIHNvbWUgcGF0Y2hlcyBmb3IgdGhpcyBzY2VuYXJpby4NCj4gDQo+IEF0dGFjaGVkIGlzIGEg
cGF0Y2ggdGhhdCBpbXBsZW1lbnRzIHRoaXMuIERvaW5nDQo+IA0KPiDCoCBjYXQgL3Byb2MvaW9t
ZW0NCj4gwqDCoCAuLi4NCj4gwqDCoCBlMDAwMDAwMC1lZmZmZmZmZiA6IDAwMDA6MDA6MDIuMA0K
PiANCj4gwqDCoMKgwqAgZTAwMDAwMDAtZTA3ZThmZmYgOiBCT09URkINCj4gDQo+IMKgwqDCoMKg
wqDCoCBlMDAwMDAwMC1lMDdlOGZmZiA6IHNpbXBsZWZiDQo+IA0KPiDCoMKgIC4uLg0KPiANCj4g
c2hvd3MgdGhlIG1lbW9yeS4gJ0JPT1RGQicgaXMgdGhlIHNpbXBsZS1mcmFtZWJ1ZmZlciBkZXZp
Y2UgYW5kIA0KPiAnc2ltcGxlZmInIGlzIHRoZSBkcml2ZXIuIE9ubHkgdGhlIGxhdHRlciB1c2Vz
IF9CVVNZLiBTYW1lIGZvciANCj4gYW5kIHRoZSBtZW1vcnkgY2FuYmUgYWNxdWlyZWQgYnkgdm13
Z2Z4Lg0KPiANCj4gWmFjaywgcGxlYXNlIHRlc3QgdGhpcyBwYXRjaC4gSWYgaXQgd29ya3MsIEkn
bGwgc2VuZCBvdXQgdGhlIHJlYWwNCj4gcGF0Y2hzZXQuDQoNCkhtbSwgdGhlIHBhdGNoIGxvb2tz
IGdvb2QgYnV0IGl0IGRvZXNuJ3Qgd29yay4gQWZ0ZXIgYm9vdDogL3Byb2MvaW9tZW0NCjUwMDAw
MDAwLTdmZmZmZmZmIDogcGNpZUAweDQwMDAwMDAwDQogIDc4MDAwMDAwLTdmZmZmZmZmIDogMDAw
MDowMDowZi4wDQogICAgNzgwMDAwMDAtNzgyZmZmZmYgOiBCT09URkINCg0KYW5kIHZtd2dmeCBm
YWlscyBvbiBwY2lfcmVxdWVzdF9yZWdpb25zOg0KDQprZXJuZWw6IGZiMDogc3dpdGNoaW5nIHRv
IHZtd2dmeCBmcm9tIHNpbXBsZQ0Ka2VybmVsOiBDb25zb2xlOiBzd2l0Y2hpbmcgdG8gY29sb3Vy
IGR1bW15IGRldmljZSA4MHgyNQ0Ka2VybmVsOiB2bXdnZnggMDAwMDowMDowZi4wOiBCQVIgMjog
Y2FuJ3QgcmVzZXJ2ZSBbbWVtIDB4NzgwMDAwMDAtDQoweDdmZmZmZmZmIDY0Yml0IHByZWZdDQpr
ZXJuZWw6IHZtd2dmeDogcHJvYmUgb2YgMDAwMDowMDowZi4wIGZhaWxlZCB3aXRoIGVycm9yIC0x
Ng0KDQpsZWF2aW5nIHRoZSBzeXN0ZW0gd2l0aG91dCBhIGZiIGRyaXZlci4NCg0Keg0K
