Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3F3275332
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 10:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgIWI0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 04:26:30 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:65297 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgIWI0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 04:26:30 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2020 04:26:29 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1600849590; x=1632385590;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=xBKncXJfs7jkT9IKyaGYpfbkEAdQ3l0RzchMk4OXCiA=;
  b=yL5Oakh2kkeJprjXFnGSwRy2h+Kfjz24oJBn/QxTDxXQYxujRAa0CU1g
   0jpAIqX6hft3qqOrtRcGwXBFfE7KVBZNaSzkSqygPXPzsNlXkCNJ46vjI
   mZC/5K0LeJXLlX1vDttnATLTr7ljZB58q+XCvrcupiFt2stFx+ytVWmsC
   BFCmWDUMzzSMHylikUGApkVMGSach2qNW/znJoQe+SdZjqMp5Fg8dq7Dr
   k5YetCJfiJTpvvR9xMTbk2U932VvaO1nHjYA5K94IxM+S5ptils1yClvL
   VMk5Uk8d56BR2sGnSQZ0KX1Eew8CzO4w5jNIRIX7/dEtlRmYxPIMtFuOu
   Q==;
IronPort-SDR: TFgnsiDJhQVAuYOODZqk+U5TzaASoooneeMOjsSby6bcYjwOFgkOp8EImo9cupxgU32tWgrghV
 yKBiLmfxMQVXulucKYWJ9UHO2Bemf+v4bvw4soW10o1LgvCZ1XLcDwD2Sh/IzmZYet6r/XTHEo
 CwQ4jEFxWPtcV2KVP2F2OoQ7EGGga15Cd31RSBUK26UpptbQ6qkxDowN0KRo0oCsrCvDrQ0gtM
 U84dR1BiS1v9cKcITicjGlHS7RmlxUOru8ivTIBtfSqHB94m++IMPn6TeQx4CSnk09XRm49Rlj
 WKY=
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="92045906"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Sep 2020 01:19:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 01:19:05 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 23 Sep 2020 01:19:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1mx4wvb6hCvb3J7WataYrS0TPmuZulqzj8wfE+QzEEY7ZmuLxPmxMw5q/87kEby1L2fYVvr7xKKzo3TkXDwiCyh7YTWWFBccIEMHQg0uJ+H3Kl4RKz7OqomazcMGmAmmNeoTqvkj7oGYP4SWR1Agw6V0Ng5tCisABFxosedaAtbvJk5gef62VVM5dfD9PUDci+4z6m5UFbg/Zl65KCkkCR81LNOUAQ/s5rU7tDbG/VRseqOV4qcCg86pqiNABJuFWLEpl2bynYaW+8prmnInaXrgh6xDp1VFEyIGYBu4N48+i+IQUZOM0Nvr3mF0UmtGFfV2DcnqM56aVg5M++lwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBKncXJfs7jkT9IKyaGYpfbkEAdQ3l0RzchMk4OXCiA=;
 b=fII8GyvknHCd9LXRHUSwHY+PpvrSh2yFBOmP/lx0vUlHJc/6nvNyjbTN1I+DE1XVOdF7ywRTz1HcRzNLocVmnFPUIxyiakIwJsuG8Lo0Aoiw5mft5/MQu836+BZMg7Ka1KXcAJq5LHWpvKA3EldffxlHTsnjDby1VcQRuVC+lvHIyAMUoqRB8Ba54si4xPBOKNf+44V1cPhrrKAzMP282+NGAjlWosdhD7e+8wa0nP+JfRdo6XmNzmiiFf2h8yIV2TZIe3yXYsODvQ1t1D9Ox6WgJf5DFO8EVc5bromEBaW5dpYkpQb1rx4qNbo8b7EMbYNz0fXFMoDy3epTnMX89g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBKncXJfs7jkT9IKyaGYpfbkEAdQ3l0RzchMk4OXCiA=;
 b=kCVoSNdrv260vSlNvOtRnxxL1MXyxk3bKGRmenXIv+OgcDNeRG30SE2pZX5GBckd3vqULfGA3hPxaFGH4C0U2B+tBuropei8pV9BVluWwQOZ8KtnZM5uLeaIzshiZ9GquEKIQYi0NkSIGBiZrhhLOsbJ184x/ATpL5MVwj1p1z4=
Received: from DM5PR11MB1914.namprd11.prod.outlook.com (2603:10b6:3:112::12)
 by DM6PR11MB3242.namprd11.prod.outlook.com (2603:10b6:5:5b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 23 Sep
 2020 08:19:18 +0000
Received: from DM5PR11MB1914.namprd11.prod.outlook.com
 ([fe80::a8e8:d0bc:8b3c:d385]) by DM5PR11MB1914.namprd11.prod.outlook.com
 ([fe80::a8e8:d0bc:8b3c:d385%11]) with mapi id 15.20.3391.027; Wed, 23 Sep
 2020 08:19:18 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <pavel@ucw.cz>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <dan.j.williams@intel.com>,
        <vkoul@kernel.org>, <Ludovic.Desroches@microchip.com>,
        <stable@vger.kernel.org>, <greg@kroah.com>
Subject: Re: [PATCH 4.19] dmaengine: at_hdmac: Fix memory leak
Thread-Topic: [PATCH 4.19] dmaengine: at_hdmac: Fix memory leak
Thread-Index: AQHWkYFbVNgbQZmRd0SqW2sKLrUKIKl14XKA
Date:   Wed, 23 Sep 2020 08:19:18 +0000
Message-ID: <d3a6fa19-0852-92d9-c434-40297edc625a@microchip.com>
References: <20200920082838.GA813@amd>
 <80065eac-7dce-aadf-51ef-9a290973b9ec@microchip.com>
In-Reply-To: <80065eac-7dce-aadf-51ef-9a290973b9ec@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: ucw.cz; dkim=none (message not signed)
 header.d=none;ucw.cz; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.77.80.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e72b6452-8d86-40a6-55fe-08d85f995e43
x-ms-traffictypediagnostic: DM6PR11MB3242:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3242F24D167BA8AFD1792E2FF0380@DM6PR11MB3242.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /YQIOIG80Dt69gf6VK3lPGUWLldar9Oa+4jvhXyR9T7OwjeSQFCpeOgtAKJV1Tzjs8Ix0rQ2MfEtd7c0z7pzGVIGMqPzX8+4atGnyP82B3Je5DpO9odR1YCDe746nlVUUgnsW8Cgoo11dG0GR9bld72OiaKHKayoQwc22EbCAYwsRPvVq4L5C9CcIfT1l+lYwybDco19EipmXWY9EYFCPg7DfD2P4L4QbbAjrj4FMEt940rW6kJUdwqXPKPyJNsn5Nl/k45ZYixpTKS0r4u+020itNyq3Y9xajPRRwWlsE76nQ20ZReEM6lPbl9hO+HRyZvVbWUb+FiNzqUWHmJAcyyPkRvARhaHzmB41iRXVZTClvFEAw8DaHuzc+NVeyBip74u5h/hjTrC43TAKmG8SPpG6+kYBQD9eVULRYR1Ie/Ia8hqSseggj6HRIyGgDv9+3PaKCL+c5iK9ZSSRaVOXgNRrKb4R5QidC3nip+BpZh5rsLzhNKCY09vUI/F/kA8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(136003)(39860400002)(316002)(76116006)(91956017)(83380400001)(6486002)(6506007)(53546011)(31696002)(966005)(66556008)(66476007)(66446008)(66946007)(64756008)(26005)(2616005)(5660300002)(31686004)(186003)(6512007)(478600001)(71200400001)(8936002)(110136005)(2906002)(8676002)(36756003)(86362001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NcpsxQBE+TYOG5a6+ggywucfDRIDzqfTDIFTRCtoUmlIMuoZK2YSjX+nDrqoyNV8u0cS9dKxqntcU2gOEEvzCHJVviSOuf3ctZ7WVdFZOc/ey3pb73K0W6XLyMCK0ueS+ZNzLM9K+2Q2jiekKiFiLpL2P8DrXPe4SithxkT3uwmBkpX68WYnUVsPCz7MXS2KP77KljjJ4pbEGZ34j0wMJPHVvoFY7YM4XylMrcnMrV1rnqz3id4i722CGXIT/L4j/nBozmn5dc+gfGR6yxReJOiZN+mtdqm+JNYoDQyg8hoP2Pr1N+FBo74DC7qbxPbUE9yKn30FNl+cwVDn3O0VCVULRDG+ooBRaPSdsSlRSYbmNUBpPLHam/vm1Zjf44e+zWL6GxCp/sKQQIc4Zxz3YjyKnQNJj/xAyoy+n14eM6MsbsYvoqYwVv9Ylobo9fu/N0jjUWBagx2DgM4PILxE0AIJ8WOrEWrWPfMr/6mAD5bwI+ITAoS3egwwDYMA2kGPIeo3J97O4l1QBMVsSHPpiZwcbr4tWB5a70AFEJvruRwc8yEnJuMhUz8QIVZaI6WfZ2lIKmnIejsHXmBglNbY/g9hQMTPvX+cAGNQwVYgbLvlk5ZpBXB1i/D1M5bQB34Ou+n1GH+5a5fgyY8xa9vhFA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <6AA6864DB4269345923148A64EA6C76C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e72b6452-8d86-40a6-55fe-08d85f995e43
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 08:19:18.7192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jY2r74yss+lwBhUy/uV8zP0eehRpdCqKK15IZycdcq7E/UpArI7QQYKe6/thiv8nQBBq/cS3MWxwQxLQKeRMcevtGA2UieFYOnBp+EzVdck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3242
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gOS8yMy8yMCAxMToxMyBBTSwgVHVkb3IuQW1iYXJ1c0BtaWNyb2NoaXAuY29tIHdyb3RlOg0K
PiBIaSwgUGF2ZWwsDQo+IA0KPiBPbiA5LzIwLzIwIDExOjI4IEFNLCBQYXZlbCBNYWNoZWsgd3Jv
dGU6DQo+PiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNo
bWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4+DQo+PiBUaGlzIGZp
eGVzIG1lbW9yeSBsZWFrIGluIGF0X2hkbWFjLiBNYWlubGluZSBkb2VzIG5vdCBoYXZlIHRoZSBz
YW1lDQo+PiBwcm9ibGVtLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IFBhdmVsIE1hY2hlayAoQ0lQ
KSA8cGF2ZWxAZGVueC5kZT4NCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9kbWEvYXRfaGRt
YWMuYyBiL2RyaXZlcnMvZG1hL2F0X2hkbWFjLmMNCj4+IGluZGV4IDg2NDI3ZjZiYTc4Yy4uMDg0
N2IyMDU1ODU3IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9kbWEvYXRfaGRtYWMuYw0KPj4gKysr
IGIvZHJpdmVycy9kbWEvYXRfaGRtYWMuYw0KPj4gQEAgLTE3MTQsOCArMTcxNCwxMCBAQCBzdGF0
aWMgc3RydWN0IGRtYV9jaGFuICphdF9kbWFfeGxhdGUoc3RydWN0IG9mX3BoYW5kbGVfYXJncyAq
ZG1hX3NwZWMsDQo+PiAgICAgICAgIGF0c2xhdmUtPmRtYV9kZXYgPSAmZG1hY19wZGV2LT5kZXY7
DQo+Pg0KPj4gICAgICAgICBjaGFuID0gZG1hX3JlcXVlc3RfY2hhbm5lbChtYXNrLCBhdF9kbWFf
ZmlsdGVyLCBhdHNsYXZlKTsNCj4+IC0gICAgICAgaWYgKCFjaGFuKQ0KPj4gKyAgICAgICBpZiAo
IWNoYW4pIHsNCj4+ICsgICAgICAgICAgICAgICBrZnJlZShhdHNsYXZlKTsNCj4+ICAgICAgICAg
ICAgICAgICByZXR1cm4gTlVMTDsNCj4+ICsgICAgICAgfQ0KPiANCj4gVGhhbmtzIGZvciBzdWJt
aXR0aW5nIHRoaXMgdG8gc3RhYmxlLiBXaGlsZSB0aGUgZml4IGlzIGdvb2QsIHlvdSBjYW4gaW5z
dGVhZA0KPiBjaGVycnktcGljayB0aGUgY29tbWl0IHRoYXQgaGl0IHVwc3RyZWFtLiBJbiBvcmRl
ciB0byBkbyB0aGF0IGNsZWFubHkgb24gdG9wDQo+IG9mIHY0LjE5LjE0NSwgeW91IGhhdmUgdG8g
cGljayB0d28gb3RoZXIgZml4ZXM6DQo+IA0KPiBjb21taXQgYTZlN2YxOWM5MTAwICgiZG1hZW5n
aW5lOiBhdF9oZG1hYzogU3Vic3RpdHV0ZSBremFsbG9jIHdpdGgga21hbGxvYyIpDQo+IGNvbW1p
dCAzODMyYjc4YjNlYzIgKCJkbWFlbmdpbmU6IGF0X2hkbWFjOiBhZGQgbWlzc2luZyBwdXRfZGV2
aWNlKCkgY2FsbCBpbiBhdF9kbWFfeGxhdGUoKSIpDQo+IGNvbW1pdCBhNmU3ZjE5YzkxMDAgKCJk
bWFlbmdpbmU6IGF0X2hkbWFjOiBTdWJzdGl0dXRlIGt6YWxsb2Mgd2l0aCBrbWFsbG9jIikNCg0K
dGhpcyBsYXN0IGNvbW1pdCBzaG91bGQgaGF2ZSBiZWVuDQpjb21taXQgZTA5N2ViNzQ3M2Q5ICgi
ZG1hZW5naW5lOiBhdF9oZG1hYzogYWRkIG1pc3Npbmcga2ZyZWUoKSBjYWxsIGluIGF0X2RtYV94
bGF0ZSgpIikNCg0KYmFkIGNvcHkgYW5kIHBhc3RlIDopDQoNCj4gDQo+IFRoZXJlIGFyZSBhbHNv
IHNvbWUgbG9ja2luZy9kZWFkbG9jayBmaXhlcyBpbiBtYWlubGluZSBmb3IgdGhpcyBkcml2ZXIs
DQo+IGRlcGVuZGluZyBvbiB0aGUgdGltZSB5b3UgY2FuIGFsbG9jYXRlIGZvciB0aGlzLCB0aGUg
bGlzdCBvZiBwYXRjaGVzIGNhbiBpbmNyZWFzZS4NCj4gSSBzaG91bGQgaGF2ZSBDYydlZCBzdGFi
bGVAdmdlci5rZXJuZWwub3JnIGluIHRoZSBmaXJzdCBwbGFjZSwgbXkgYmFkLg0KPiANCj4gQWxz
byBpdCBtYXkgd29ydGggdG8gcmVhZCB0aGUgcnVsZXMgZm9yIHN1Ym1pdHRpbmcgdG8gc3RhYmxl
IGF0Og0KPiBodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL2xhdGVzdC9wcm9jZXNzL3N0
YWJsZS1rZXJuZWwtcnVsZXMuaHRtbA0KPiANCj4gQ2hlZXJzLA0KPiB0YQ0KPiANCj4gX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCj4gbGludXgtYXJtLWtl
cm5lbCBtYWlsaW5nIGxpc3QNCj4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3Jn
DQo+IGh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtYXJt
LWtlcm5lbA0KPiANCg0K
