Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168B02E905D
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 07:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbhADGOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 01:14:51 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:24207 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbhADGOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 01:14:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1609740889; x=1641276889;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2tDFzPKDsrB1ImoFTwqWRC2xbf/cBlstAJppQbqjGeY=;
  b=e73r/9jrApi+oOZ6tkEWdtr2tnuGNunUY66+aDD9ms2lMmWh0XY0nQNh
   9T9YLVUOK63nSXnDTl6/fybNgffMTl3sArIM1Qf9w0FnN+x9nelL21/I4
   DjgVqpbSyqNgENd3QqLzmja+yvl9t03kEZoZfH9d8YoEGXhiV0T9MHTyy
   MmdejM0+AEslcm53rHlcLhVf8i/QF0KNkaO1wAyBvxaDV2qpuj5xWZmU6
   BOAIWrgEIpt7fKIeR+2Pj2Rq1C7kX13+4G4/JC8yFkNFJCHZw7lmRCrqm
   EUuvmTC/HNXn2LO9d74gzWx3Uk/usf2s/HPGoQjf0k7syNw8zGasJFLJb
   w==;
IronPort-SDR: 3hAghJQp+DRB8QTA11Gbd6m9HZ5THRl/O4IhAT6JcCbV+69T50pHe/4bYy2LcoofMzEPlzNgCo
 0sunAmhiFGIEDevWOjbTfTthKVNL3b4YyonaoD/CrjTJzIHyf9HqhIj+AtCrgR35FvZKKwUD/0
 w+gtiGTdtqQaY8DOxofY2ZCNJWTdzAdNca5gXDCb+/3+VJAy0ZLBVU3GQAlJpXx8UJvlv3DhuP
 Z6xMr7kQdl5PvYdN2aYnW/lCpPJ3if98Dq0sonv7cs+l9ndln75+t/4GryabtN3rVWOYucEI1j
 5nA=
X-IronPort-AV: E=Sophos;i="5.78,473,1599494400"; 
   d="scan'208";a="156483689"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2021 14:13:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnyyJk6a4td8xd34kut0lqjwyZSQxcyUxEKChftapUAGw3mDCp/FF8oDjCntC/CDWQ0ttkysRwu1mgnpZbFCGRhVb3LvdhAynyGfxF3oSTPLZMdyWqmAkDCQaN5qqKOIMEZP6kcqOIMzKYRm/OgGJiYIaSeTKv2gjrN2opRjS/zBwIG93Xj6AE28JJTfEGuL/mvtFziNSibLtV3lGhnpoy9ECJRVnt5F4PbUabbDNcgs0YRfwo6BL9T1DCLm8ZlLEHeaS3NeMDxznDoJPEolWm1wpMh3S9Omh4Z2DJnErU4N9hM2i+8lLfiryNv7e04OKuFc2KWGHJsbRS3rSkQRzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tDFzPKDsrB1ImoFTwqWRC2xbf/cBlstAJppQbqjGeY=;
 b=Hk2bDOZXLzY3U4bFPLRb3/AgoQY1BJ0O+DhGKuWoAFoCda0FJCnE9kUWZocg5mcBFtRUoT2cnkMm2DxckoeLU+/gP2XN3ssZ4cKJgrhr/jy1Zr0DDZFb0M5vufB3qagTFdSYrK0DN1pPN9rOdyQzK/SSSEySqSb/ikrfu9LWPIpep5DbZrNTviA0/SFx5ShHK3ySzW0gGV6Y8rpDoSWHB7OJL8M3bf9Ic19FFzeIbqVRW7lwGaHO2OxwKiPbCAYcuxrt0UIzTcng9QyQSk2H6QyZxyPRA29n3zS0rHHds/GjlIzdqz0sljO+0SUQCqNMhqqzvm4LzkyFBgjAq7wsKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tDFzPKDsrB1ImoFTwqWRC2xbf/cBlstAJppQbqjGeY=;
 b=JMbW1iwBVj8wN/I1eOH0kr3wtJTYUOp3kL/HYbCE7aOnNYbV7Gkj4ATqW9LyMf4sAtWiOJUbu90p21ooTaKUkwMxCMf4M/hg9sIgeoaPWsUM9GXrKzEHeTLizV7t0XbisESANtODacdrww9lDnRSHQ9orBJGYWPsQ2SbZ4McEhQ=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6701.namprd04.prod.outlook.com (2603:10b6:208:1ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.21; Mon, 4 Jan
 2021 06:13:40 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0%9]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 06:13:40 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@lst.de" <hch@lst.de>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Naohiro Aota <Naohiro.Aota@wdc.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] null_blk: Fix zone size initialization"
 failed to apply to 5.4-stable tree
Thread-Topic: FAILED: patch "[PATCH] null_blk: Fix zone size initialization"
 failed to apply to 5.4-stable tree
Thread-Index: AQHW3Q9qht23fncPTkqy6K7MjXhvMKoXB12A
Date:   Mon, 4 Jan 2021 06:13:39 +0000
Message-ID: <7b36cdd244b905dc5cf3d80fbf7a3166b5c31feb.camel@wdc.com>
References: <160915617623242@kroah.com>
In-Reply-To: <160915617623242@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2 (3.38.2-1.fc33) 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:8d3e:27aa:85c2:44b5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 129bf076-00bf-4bbd-d4f8-08d8b077e18e
x-ms-traffictypediagnostic: MN2PR04MB6701:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB67019A52578A5D5D50503BD6E7D20@MN2PR04MB6701.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: scJTkZvaSOAQ91dPP9rJyZrWG0bX1ylxkh3MvOMmiEghYYHiSNXlCzkzrWLKxCRrDENbqPThgxNqdXzg6WqxioWo1QreZP7wDBB+CrNd6MsaiJe4Hx1gfQHaCUE1E24QpasyIMW8W12IOCbS/xsdLShcbMQqSaCvMxrkb2BF3QFTMNciRE3rde6rwBEISLuG86dK6MR1nq02IB6+3Sdj4VjOA3oZ/qfHc4eA/b1pV9/UuIwdN46H0PJq8edbphEqEZYlvOvOJ9eGXSVaaHWKXuoxzTa8UgRK5XaUOWwx5N0GdpgZEoRjUSsSZw/YbsOYOKPEhTxtmL/nC6yvPrHAj4uIktxKJMfy+BaOdGnaWb/Se3CfmjF/F/QWNAQFvmWOoBzv+5HU3CL0F1mrdkC16g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39860400002)(346002)(396003)(6512007)(86362001)(478600001)(6486002)(186003)(2616005)(76116006)(91956017)(66446008)(64756008)(66476007)(4001150100001)(6506007)(66556008)(4326008)(66946007)(53546011)(2906002)(8936002)(71200400001)(110136005)(316002)(36756003)(6636002)(83380400001)(8676002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WndsOWFEZFh0eXJuVG91N1NQV3o5Y1FIZnM3dkpnSmlldC9jTUdpQU0yeXNa?=
 =?utf-8?B?dk9xVnpjNW81K3ZvMVRJYmFrcVY4RGxKSE1sU2tockMxTjBYcGEwYUN4dXdX?=
 =?utf-8?B?STREVzVxMVN5eUgybzNOMFJXN3dvMmtJc3ZvTVN3MGxiK1BoNXhCOVRQZFI4?=
 =?utf-8?B?aVJCaVB5S1Fma2dqMTBtVkxQM3poMTRMa2ZoMU5LejVIRjhSd2dXdWUzWExK?=
 =?utf-8?B?dGFxazFuclBqTUo0ekRuUExZRm9OWFJpbkVPTjV5UWpYUk1JNG5tU21EU2J3?=
 =?utf-8?B?M1ZHMXkyT1RsbjFDT2hSM0JIbDUrbUh0TWlUcDF3aHNUODJONklCdmxDci9w?=
 =?utf-8?B?QWxGN0xQOThxcXRqNVFyaUZzUE81eWI2Z3oyY0x1SzlmNHBSWTNYV09sbXQz?=
 =?utf-8?B?RTc1TmF1RXloWkVyeGJWTDdWMmVtSHoxbGVaaFdvQklLcGhQYkt3Wk9VWlJK?=
 =?utf-8?B?VG1rSHl3ZGF6cjZwTWxlVHgzRWs5elRaK2tQTEI5SFR1ckZoWjZnTmM4eEwx?=
 =?utf-8?B?UUFqeEVPTWVJSUJmUmpnNXJUbVNNeDRkbmcxdFl1eE5nSk9xUCtOK25qUWwv?=
 =?utf-8?B?NkEzVGJGZ251M1FwUGRPbEFHeDBXS0cvUjVRd29ZQ2Q5YkREWmF0cmZkaWJZ?=
 =?utf-8?B?TGVscjluY09JcTdodWV2cTYvSGxKUWJJK0RzU1VmQktpWE9zV0FJaFVMa3ZN?=
 =?utf-8?B?eFEvUmRDRU54azE1THFYS0VPOTZVQXBVOVBWMHR4YVcvQ0krRmxVQ3BUM2FC?=
 =?utf-8?B?Q2RoSzhQSHJDSlJGM0MxUHFKQ2Z4Y2IwT21vT0tOWHhZWUpxRTk2RUdPNzBM?=
 =?utf-8?B?Y1NIZ2pjd0xUTTUvWlBuSFFwTHZSWFhOSlVqdUZSRDhCSDJMYk5KVG9yTXRI?=
 =?utf-8?B?b25NZHRLVFlnVUF2VUJ2Tmd3azlGb1Mrb3dnWndwYytkMG1ZNmNZRnlhM0lj?=
 =?utf-8?B?NzhGR3R5S0ZHdUZHaTQ1TG9UUjc4SFc3MlFGTG1nYXVrRzRGaGxpcmNtMUYy?=
 =?utf-8?B?a0lkcTZQZURwRjNVWGpPZ2tQeUEySTQyRXpTWEFXZEpJZy9LclpqYUlzdVZX?=
 =?utf-8?B?RHNJVWtuTGtuVFZTSXgzWksxMzJaY3VlY2lCbko1dlVxZXZRTEFvTmNmNWF1?=
 =?utf-8?B?eTlYdENEdENhUU9mZWNYemh1eHY1MWNXYUNienM5UWdlM3hXelVhUjI5UFJv?=
 =?utf-8?B?aFdCbEo1UmNhOXRIZ0RkaHd5aDA2YnUyWUFlNHNSME5VWGJDR1VoTWVtdUpL?=
 =?utf-8?B?LzBGVW5HcnlYcnljcE9NWHpMeHZKdXVuc2wwalhMS1BNWFJjaWczQjQwNHRj?=
 =?utf-8?B?aUpId05DbEFKSjlNVHNCQ1pQUWVJQkNPUStKU1R3L3ZBREtMa2Jyb1ZlYmtN?=
 =?utf-8?B?NXFMRjU1ZXJqeW93SHYwYU1PVzhpM0pmbXVhcWZJb0hTcjRocmY2dXFtQ3lY?=
 =?utf-8?Q?Kz7v+PYO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <270EB2B7CA3FB84E8F6C983B0055A6F1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 129bf076-00bf-4bbd-d4f8-08d8b077e18e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 06:13:40.3422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uklyQbOs5nwnaxrf+U6m3VettW6o15PGRmmeXdWBuTHHnDRry0Z5YcKs3I7/vkZse+l0tL00K4yv1XbZkqDCJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6701
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDIwLTEyLTI4IGF0IDEyOjQ5ICswMTAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gVGhlIHBhdGNoIGJlbG93IGRvZXMgbm90IGFwcGx5IHRvIHRoZSA1LjQt
c3RhYmxlIHRyZWUuDQo+IElmIHNvbWVvbmUgd2FudHMgaXQgYXBwbGllZCB0aGVyZSwgb3IgdG8g
YW55IG90aGVyIHN0YWJsZSBvciBsb25ndGVybQ0KPiB0cmVlLCB0aGVuIHBsZWFzZSBlbWFpbCB0
aGUgYmFja3BvcnQsIGluY2x1ZGluZyB0aGUgb3JpZ2luYWwgZ2l0IGNvbW1pdA0KPiBpZCB0byA8
c3RhYmxlQHZnZXIua2VybmVsLm9yZz4uDQo+IA0KPiB0aGFua3MsDQo+IA0KPiBncmVnIGstaA0K
DQpIaSBHcmVnLA0KDQpJIHNlbnQgYSBiYWNrLXBvcnRlZCBwYXRjaCBmb3IgNS40LXN0YWJsZSBp
biByZXBseSB0byB5b3VyIGVtYWlsLg0KVGhhbmtzLg0KDQoNCj4gDQo+IC0tLS0tLS0tLS0tLS0t
LS0tLSBvcmlnaW5hbCBjb21taXQgaW4gTGludXMncyB0cmVlIC0tLS0tLS0tLS0tLS0tLS0tLQ0K
PiANCj4gRnJvbSAwZWJjZGQ3MDJmNDlhZWIwYWQyZTJkODk0ZjhjMTI0YTBhY2M2ZTIzIE1vbiBT
ZXAgMTcgMDA6MDA6MDAgMjAwMQ0KPiBGcm9tOiBEYW1pZW4gTGUgTW9hbCA8ZGFtaWVuLmxlbW9h
bEB3ZGMuY29tPg0KPiBEYXRlOiBGcmksIDIwIE5vdiAyMDIwIDEwOjU1OjExICswOTAwDQo+IFN1
YmplY3Q6IFtQQVRDSF0gbnVsbF9ibGs6IEZpeCB6b25lIHNpemUgaW5pdGlhbGl6YXRpb24NCj4g
DQo+IEZvciBhIG51bGxfYmxrIGRldmljZSB3aXRoIHpvbmVkIG1vZGUgZW5hYmxlZCBpcyBjdXJy
ZW50bHkgaW5pdGlhbGl6ZWQNCj4gd2l0aCBhIG51bWJlciBvZiB6b25lcyBlcXVhbCB0byB0aGUg
ZGV2aWNlIGNhcGFjaXR5IGRpdmlkZWQgYnkgdGhlIHpvbmUNCj4gc2l6ZSwgd2l0aG91dCBjb25z
aWRlcmluZyBpZiB0aGUgZGV2aWNlIGNhcGFjaXR5IGlzIGEgbXVsdGlwbGUgb2YgdGhlDQo+IHpv
bmUgc2l6ZS4gSWYgdGhlIHpvbmUgc2l6ZSBpcyBub3QgYSBkaXZpc29yIG9mIHRoZSBjYXBhY2l0
eSwgdGhlIHpvbmVzDQo+IGVuZCB1cCBub3QgY292ZXJpbmcgdGhlIGVudGlyZSBjYXBhY2l0eSwg
cG90ZW50aWFsbHkgcmVzdWx0aW5nIGlzIG91dA0KPiBvZiBib3VuZHMgYWNjZXNzZXMgdG8gdGhl
IHpvbmUgYXJyYXkuDQo+IA0KPiBGaXggdGhpcyBieSBhZGRpbmcgb25lIGxhc3Qgc21hbGxlciB6
b25lIHdpdGggYSBzaXplIGVxdWFsIHRvIHRoZQ0KPiByZW1haW5kZXIgb2YgdGhlIGRpc2sgY2Fw
YWNpdHkgZGl2aWRlZCBieSB0aGUgem9uZSBzaXplIGlmIHRoZSBjYXBhY2l0eQ0KPiBpcyBub3Qg
YSBtdWx0aXBsZSBvZiB0aGUgem9uZSBzaXplLiBGb3Igc3VjaCBzbWFsbGVyIGxhc3Qgem9uZSwg
dGhlIHpvbmUNCj4gY2FwYWNpdHkgaXMgYWxzbyBjaGVja2VkIHNvIHRoYXQgaXQgZG9lcyBub3Qg
ZXhjZWVkIHRoZSBzbWFsbGVyIHpvbmUNCj4gc2l6ZS4NCj4gDQo+IFJlcG9ydGVkLWJ5OiBOYW9o
aXJvIEFvdGEgPG5hb2hpcm8uYW90YUB3ZGMuY29tPg0KPiBGaXhlczogY2E0YjJhMDExOTQ4ICgi
bnVsbF9ibGs6IGFkZCB6b25lIHN1cHBvcnQiKQ0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9y
Zw0KPiBTaWduZWQtb2ZmLWJ5OiBEYW1pZW4gTGUgTW9hbCA8ZGFtaWVuLmxlbW9hbEB3ZGMuY29t
Pg0KPiBSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IFJldmll
d2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRodW1zaGlybkB3ZGMuY29tPg0K
PiBTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+DQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9ibG9jay9udWxsX2Jsa196b25lZC5jIGIvZHJpdmVycy9ibG9jay9u
dWxsX2Jsa196b25lZC5jDQo+IGluZGV4IGJlYjM0YjRmNzZiMC4uMWQwMzcwZDkxZmU3IDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL2Jsb2NrL251bGxfYmxrX3pvbmVkLmMNCj4gKysrIGIvZHJpdmVy
cy9ibG9jay9udWxsX2Jsa196b25lZC5jDQo+IEBAIC02LDggKzYsNyBAQA0KPiDCoCNkZWZpbmUg
Q1JFQVRFX1RSQUNFX1BPSU5UUw0KPiDCoCNpbmNsdWRlICJudWxsX2Jsa190cmFjZS5oIg0KPiDC
oA0KPiANCj4gDQo+IA0KPiAtLyogem9uZV9zaXplIGluIE1CcyB0byBzZWN0b3JzLiAqLw0KPiAt
I2RlZmluZSBaT05FX1NJWkVfU0hJRlQJCTExDQo+ICsjZGVmaW5lIE1CX1RPX1NFQ1RTKG1iKSAo
KChzZWN0b3JfdCltYiAqIFNaXzFNKSA+PiBTRUNUT1JfU0hJRlQpDQo+IMKgDQo+IA0KPiANCj4g
DQo+IMKgc3RhdGljIGlubGluZSB1bnNpZ25lZCBpbnQgbnVsbF96b25lX25vKHN0cnVjdCBudWxs
Yl9kZXZpY2UgKmRldiwgc2VjdG9yX3Qgc2VjdCkNCj4gwqB7DQo+IEBAIC0xNiw3ICsxNSw3IEBA
IHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IG51bGxfem9uZV9ubyhzdHJ1Y3QgbnVsbGJfZGV2
aWNlICpkZXYsIHNlY3Rvcl90IHNlY3QpDQo+IMKgDQo+IA0KPiANCj4gDQo+IMKgaW50IG51bGxf
aW5pdF96b25lZF9kZXYoc3RydWN0IG51bGxiX2RldmljZSAqZGV2LCBzdHJ1Y3QgcmVxdWVzdF9x
dWV1ZSAqcSkNCj4gwqB7DQo+IC0Jc2VjdG9yX3QgZGV2X3NpemUgPSAoc2VjdG9yX3QpZGV2LT5z
aXplICogMTAyNCAqIDEwMjQ7DQo+ICsJc2VjdG9yX3QgZGV2X2NhcGFjaXR5X3NlY3RzLCB6b25l
X2NhcGFjaXR5X3NlY3RzOw0KPiDCoAlzZWN0b3JfdCBzZWN0b3IgPSAwOw0KPiDCoAl1bnNpZ25l
ZCBpbnQgaTsNCj4gwqANCj4gDQo+IA0KPiANCj4gQEAgLTM4LDkgKzM3LDEzIEBAIGludCBudWxs
X2luaXRfem9uZWRfZGV2KHN0cnVjdCBudWxsYl9kZXZpY2UgKmRldiwgc3RydWN0IHJlcXVlc3Rf
cXVldWUgKnEpDQo+IMKgCQlyZXR1cm4gLUVJTlZBTDsNCj4gwqAJfQ0KPiDCoA0KPiANCj4gDQo+
IA0KPiAtCWRldi0+em9uZV9zaXplX3NlY3RzID0gZGV2LT56b25lX3NpemUgPDwgWk9ORV9TSVpF
X1NISUZUOw0KPiAtCWRldi0+bnJfem9uZXMgPSBkZXZfc2l6ZSA+Pg0KPiAtCQkJCShTRUNUT1Jf
U0hJRlQgKyBpbG9nMihkZXYtPnpvbmVfc2l6ZV9zZWN0cykpOw0KPiArCXpvbmVfY2FwYWNpdHlf
c2VjdHMgPSBNQl9UT19TRUNUUyhkZXYtPnpvbmVfY2FwYWNpdHkpOw0KPiArCWRldl9jYXBhY2l0
eV9zZWN0cyA9IE1CX1RPX1NFQ1RTKGRldi0+c2l6ZSk7DQo+ICsJZGV2LT56b25lX3NpemVfc2Vj
dHMgPSBNQl9UT19TRUNUUyhkZXYtPnpvbmVfc2l6ZSk7DQo+ICsJZGV2LT5ucl96b25lcyA9IGRl
dl9jYXBhY2l0eV9zZWN0cyA+PiBpbG9nMihkZXYtPnpvbmVfc2l6ZV9zZWN0cyk7DQo+ICsJaWYg
KGRldl9jYXBhY2l0eV9zZWN0cyAmIChkZXYtPnpvbmVfc2l6ZV9zZWN0cyAtIDEpKQ0KPiArCQlk
ZXYtPm5yX3pvbmVzKys7DQo+ICsNCj4gwqAJZGV2LT56b25lcyA9IGt2bWFsbG9jX2FycmF5KGRl
di0+bnJfem9uZXMsIHNpemVvZihzdHJ1Y3QgYmxrX3pvbmUpLA0KPiDCoAkJCUdGUF9LRVJORUwg
fCBfX0dGUF9aRVJPKTsNCj4gwqAJaWYgKCFkZXYtPnpvbmVzKQ0KPiBAQCAtMTAxLDggKzEwNCwx
MiBAQCBpbnQgbnVsbF9pbml0X3pvbmVkX2RldihzdHJ1Y3QgbnVsbGJfZGV2aWNlICpkZXYsIHN0
cnVjdCByZXF1ZXN0X3F1ZXVlICpxKQ0KPiDCoAkJc3RydWN0IGJsa196b25lICp6b25lID0gJmRl
di0+em9uZXNbaV07DQo+IMKgDQo+IA0KPiANCj4gDQo+IMKgCQl6b25lLT5zdGFydCA9IHpvbmUt
PndwID0gc2VjdG9yOw0KPiAtCQl6b25lLT5sZW4gPSBkZXYtPnpvbmVfc2l6ZV9zZWN0czsNCj4g
LQkJem9uZS0+Y2FwYWNpdHkgPSBkZXYtPnpvbmVfY2FwYWNpdHkgPDwgWk9ORV9TSVpFX1NISUZU
Ow0KPiArCQlpZiAoem9uZS0+c3RhcnQgKyBkZXYtPnpvbmVfc2l6ZV9zZWN0cyA+IGRldl9jYXBh
Y2l0eV9zZWN0cykNCj4gKwkJCXpvbmUtPmxlbiA9IGRldl9jYXBhY2l0eV9zZWN0cyAtIHpvbmUt
PnN0YXJ0Ow0KPiArCQllbHNlDQo+ICsJCQl6b25lLT5sZW4gPSBkZXYtPnpvbmVfc2l6ZV9zZWN0
czsNCj4gKwkJem9uZS0+Y2FwYWNpdHkgPQ0KPiArCQkJbWluX3Qoc2VjdG9yX3QsIHpvbmUtPmxl
biwgem9uZV9jYXBhY2l0eV9zZWN0cyk7DQo+IMKgCQl6b25lLT50eXBlID0gQkxLX1pPTkVfVFlQ
RV9TRVFXUklURV9SRVE7DQo+IMKgCQl6b25lLT5jb25kID0gQkxLX1pPTkVfQ09ORF9FTVBUWTsN
Cj4gwqANCj4gDQo+IA0KPiANCj4gDQoNCi0tIA0KRGFtaWVuIExlIE1vYWwNCldlc3Rlcm4gRGln
aXRhbA0K
