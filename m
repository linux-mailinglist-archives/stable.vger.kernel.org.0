Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8BC319BF4E
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 12:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387610AbgDBK15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 06:27:57 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:30163 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgDBK15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 06:27:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1585823277; x=1617359277;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ndhSa4x9PpFHoaUU3O7E6t0UEEy1BOQvQPSKWiyPvW0=;
  b=tVdsT15122olGc/8AJqL5S0jiQwR6fFGQ9okGHfLDiP9Y5jM5JrZR0nj
   4mj6yCAkf3JYbIlFbTtHxropQBwilk7zq26VbduK0TuGm7LT0X8GGbPWu
   DQFXHcQtxYHi3TpzL+nbxFSVy1ZNPldeUZwnedfX4cQHDLEX3pHQ/YrJb
   t+C/oo1GhRxpKrIpuBuJPU5McV5yoolFDj7T8i0+uIfgy1NXD3I9Go9dP
   B+5ZVR31vywNMI5lEelkNjx583B+ZKZsTN1tTIj5+7e4BWU0FIaUmmVcS
   afL+3BLs04YbDnPJ9xsMpUyRHYvvKoUVrYEL6zn1/DDejxfMN0QLttVVt
   Q==;
IronPort-SDR: anqNssSy6CjzTHTjzZEQx2slPSZk112NoICjk1SLgJIy/EEXIJuWevUdhkQ/Q2dGty7SqtzViW
 CW6ytT5VMKYv/xMYy/s8evZTku2ocUhlbCEtO+9d7c+dlzBK4UB6dWEqX0Ch5F87LxquTv12pf
 u9DZnx4aX6lvwtVMGCyFQqodBfWWFwFE1sujE4YWhva95ZSInWfwBX5qNmY3wLRjOew3KsXAiy
 h2JaIVvLXAyOWqPUBKQdioEvhhtNQ/Hmv5MTUOT0vtlfJyj4v8kNfj5VGlKL8voAGUH6G0Zgh/
 rBs=
X-IronPort-AV: E=Sophos;i="5.72,335,1580799600"; 
   d="scan'208";a="71184908"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Apr 2020 03:27:57 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 2 Apr 2020 03:28:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 2 Apr 2020 03:27:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zj+4w+M4cyTAVNx8Bn7oTg2Z4g8e4tBWIWgjG+48Ot/NM7Zqow88fFcFuSsWQBhdSH5/Exf8MMFa+N8ial7Jgtx4M3ZqMgoVHaXNFhhVnpDKPHcKjkaKjp+ze9EyBzeRxo+/Cz4ppOfRJLeFMK81qCm53TmuPmqFmNkzY5Kwr57J+xxufxqb8JWFSrhNs7TlK35gdG42d1DrDZv/8iBx6wZYSpnVM7W7JKFRxYVC7GwqzPoNsmmOD9UAO1bj+Vh0Z+1Vs3WEe2DJH+HwPSzG4geg3ZmITdCQN03SsdHqpHC26qZjtiZWVnT1NqhjhA8FArAAFS+ojxbUsR6fhwEklw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndhSa4x9PpFHoaUU3O7E6t0UEEy1BOQvQPSKWiyPvW0=;
 b=QdQA2nuP3ZOAUWgS8K3LIgo0JSxpUwoXnASf41/dDJfzRVGpdXRVqCPlTMtmz3/H9AL5F64oUTysmmfcjMpIo5IaOh1Yp0tyVJmbobCprCQQU9EvhSiJqntQ9/duV9t07c5qytbXIhueCTro8ic05yxN2pubcwKFFgkhN7wDJowuPjP3mGLGPVAEzKkH3lKW32YLjCEE+0n4FeIQjnCaQttt9S+PbuGugoCQy3TXQEy/pI6P4rJd2jcKZmbgM2C8Ik7qbljbCC4Ca0ennMjEwVzXR4YjwHaCIidgqc9vlPXQozPNBORPvy9vgIfKO10KhhNpgvdlupvlNoD662c0cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndhSa4x9PpFHoaUU3O7E6t0UEEy1BOQvQPSKWiyPvW0=;
 b=sDcfnAZ85+Yfn/zH8aLXUizxP1MlP1fx23VWtTQf/zYXjFOGEk/nQ8rlnr35LjWfEN19FBhCzvQrdYGDDWPWcJ0Ftbt8X3pFzYF12M9TWreMB46HJZHJIgTsLME6ZbUNeviGPkNjfEAHcqWVdpo3YpecVqacitawb0Bk9pTSk0o=
Received: from DM6PR11MB4123.namprd11.prod.outlook.com (2603:10b6:5:196::12)
 by DM6PR11MB3563.namprd11.prod.outlook.com (2603:10b6:5:13e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Thu, 2 Apr
 2020 10:27:54 +0000
Received: from DM6PR11MB4123.namprd11.prod.outlook.com
 ([fe80::f42c:82b3:ecda:5ff4]) by DM6PR11MB4123.namprd11.prod.outlook.com
 ([fe80::f42c:82b3:ecda:5ff4%6]) with mapi id 15.20.2878.017; Thu, 2 Apr 2020
 10:27:54 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <Ludovic.Desroches@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <robh+dt@kernel.org>
CC:     <devicetree@vger.kernel.org>, <Tudor.Ambarus@microchip.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <Codrin.Ciubotariu@microchip.com>, <Cristian.Birsan@microchip.com>
Subject: Re: [PATCH 1/5] ARM: dts: at91: sama5d2_ptc_ek: fix sdmmc0 node
 description
Thread-Topic: [PATCH 1/5] ARM: dts: at91: sama5d2_ptc_ek: fix sdmmc0 node
 description
Thread-Index: AQHWCHMUVzqU8dzz1022okz8VD+yc6hljvCAgAANQ4CAAAWggA==
Date:   Thu, 2 Apr 2020 10:27:54 +0000
Message-ID: <8f7194a7-ad9e-5d27-7db1-d41a88d909de@microchip.com>
References: <20200401221504.41196-1-ludovic.desroches@microchip.com>
 <b4fe14af-a812-8798-187e-704541a6a75f@microchip.com>
 <5f762bdc-fe07-adbc-af8d-7670b5b4b286@microchip.com>
In-Reply-To: <5f762bdc-fe07-adbc-af8d-7670b5b4b286@microchip.com>
Accept-Language: en-US, ro-RO
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-originating-ip: [86.120.188.33]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb655fed-4239-42c8-d482-08d7d6f0812f
x-ms-traffictypediagnostic: DM6PR11MB3563:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3563085B8950BB31DF5FA401E8C60@DM6PR11MB3563.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0361212EA8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4123.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(136003)(396003)(39860400002)(376002)(346002)(86362001)(66446008)(316002)(53546011)(6506007)(91956017)(66476007)(76116006)(6486002)(64756008)(6512007)(107886003)(66946007)(31696002)(4326008)(2616005)(66556008)(478600001)(8676002)(36756003)(81156014)(2906002)(186003)(54906003)(5660300002)(81166006)(110136005)(8936002)(26005)(31686004)(71200400001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HiGmLWTpRmbhlUOVvrI6aSAF52lnpfUCHe1r5I8kHQV7KFraY5uHMd57uU2Ly9BAkWi7SAMrdCs0IhuOSFBgjEoR6jxFmSTkHbzFXFPvgmj3eD6TNq81Kvjr+7j1oPYl75JwDNVlZzGYsncpbXF33OVaAU6HeumY+OwlJY37rzDg2FBZnj9T3W9dZ+D9Y/dlttZB5GRTjpbtOYigG/GBkUWr8ipTI9K3qvdqNorqdSqHcHgKWQnPOinsZuZ7KBMElOBXJ48szVUMKKpySeWkTcsOhjPK0IlsQQW82O8C/SC4HNXkKkhREzBWhKvNbWKmIYimiPIAwUPA/ae8Rj3h55434vZsQ7jMZiDStyZHR2jKHxIazyqx6TXNbPWmfhLGN1k1deG0eWebljN7maisX8ZnwJ/A0FfcsQTJ+2CWvpoX6p3GXLpsXg9CYNPOHqB6
x-ms-exchange-antispam-messagedata: naprie2a2C9mfdXykOh4E3eEgTki9ZWbaA4bRgWDgqb2jve/pWJXbfPQnquMNfyIF/Tn9ynV3otkIjvspX6QuqQYJrSClbiIHL9vIAoiU/lncSfG+n4mA66Qmpy8vQxoc9ZxIDZtjplOGZYPI6VOag==
Content-Type: text/plain; charset="utf-8"
Content-ID: <ECB0E1658EBC484598C5826C7D7C9C41@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bb655fed-4239-42c8-d482-08d7d6f0812f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2020 10:27:54.2745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oHIRzvScbYAGkMW+SxutsXErCjxMhzxwfvQHsvcQJSjNrCV2YP/sD4UQ9evJO4UuSl+J+1UCsxGr86jGb5u80GeZ/WvnW0Q/fJ+z9tUbuXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3563
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMDIuMDQuMjAyMCAxMzowNywgTHVkb3ZpYyBEZXNyb2NoZXMgLSBNNDMyMTggd3JvdGU6DQo+
IE9uIDQvMi8yMDIwIDExOjIwIEFNLCBFdWdlbiBIcmlzdGV2IC0gTTE4MjgyIHdyb3RlOg0KPj4g
T24gMDIuMDQuMjAyMCAwMToxNSwgTHVkb3ZpYyBEZXNyb2NoZXMgd3JvdGU6DQo+Pj4gUmVtb3Zl
IG5vbi1yZW1vdmFibGUgYW5kIG1tYy1kZHItMV84diBwcm9wZXJ0aWVzIGZyb20gdGhlIHNkbW1j
MA0KPj4+IG5vZGUgd2hpY2ggY29tZSBwcm9iYWJseSBmcm9tIGFuIHVuY2hlY2tlZCBjb3B5L3Bh
c3RlLg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogTHVkb3ZpYyBEZXNyb2NoZXMgPGx1ZG92aWMu
ZGVzcm9jaGVzQG1pY3JvY2hpcC5jb20+DQo+Pj4gRml4ZXM6NDJlZDUzNTU5NWVjICJBUk06IGR0
czogYXQ5MTogaW50cm9kdWNlIHRoZSBzYW1hNWQyIHB0YyBlayBib2FyZCINCj4+PiBDYzogc3Rh
YmxlQHZnZXIua2VybmVsLm9yZyAjIDQuMTkgYW5kIGxhdGVyDQo+Pj4gLS0tDQo+Pj4gICAgIGFy
Y2gvYXJtL2Jvb3QvZHRzL2F0OTEtc2FtYTVkMl9wdGNfZWsuZHRzIHwgMiAtLQ0KPj4+ICAgICAx
IGZpbGUgY2hhbmdlZCwgMiBkZWxldGlvbnMoLSkNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9hcmNo
L2FybS9ib290L2R0cy9hdDkxLXNhbWE1ZDJfcHRjX2VrLmR0cyBiL2FyY2gvYXJtL2Jvb3QvZHRz
L2F0OTEtc2FtYTVkMl9wdGNfZWsuZHRzDQo+Pj4gaW5kZXggMWMyNGFjODAxOWJhNy4uNzcyODA5
YzU0YzFmMyAxMDA2NDQNCj4+PiAtLS0gYS9hcmNoL2FybS9ib290L2R0cy9hdDkxLXNhbWE1ZDJf
cHRjX2VrLmR0cw0KPj4+ICsrKyBiL2FyY2gvYXJtL2Jvb3QvZHRzL2F0OTEtc2FtYTVkMl9wdGNf
ZWsuZHRzDQo+Pj4gQEAgLTEyNSw4ICsxMjUsNiBAQCBzZG1tYzA6IHNkaW8taG9zdEBhMDAwMDAw
MCB7DQo+Pj4gICAgIAkJCWJ1cy13aWR0aCA9IDw4PjsNCj4+PiAgICAgCQkJcGluY3RybC1uYW1l
cyA9ICJkZWZhdWx0IjsNCj4+PiAgICAgCQkJcGluY3RybC0wID0gPCZwaW5jdHJsX3NkbW1jMF9k
ZWZhdWx0PjsNCj4+PiAtCQkJbm9uLXJlbW92YWJsZTsNCj4+PiAtCQkJbW1jLWRkci0xXzh2Ow0K
Pj4NCj4+IEhpIEx1ZG92aWMsDQo+Pg0KPj4gSSBhbSBub3Qgc3VyZSBhYm91dCB0aGUgcmVtb3Zh
bCBvZiBtbWMtZGRyLTFfOHY7IHRoaXMgbWVhbnMgZU1NQ3MNCj4+IGNvbm5lY3RlZCBvbiB0aGlz
IHNsb3Qgd29uJ3Qgd29yayBpbiBoaWdoIHNwZWVkIG1vZGUsIHNvbWUgcGVvcGxlIHVzZQ0KPj4g
ZU1NQyB0byBTRC1DYXJkIGFkYXB0ZXJzIGFuZCBzdGljayB0aGVtIGludG8gU0QtQ2FyZCBzbG90
cy4NCj4+IFdvdWxkIGl0IGJlIGEgcHJvYmxlbSB0byBrZWVwIHRoaXMgcHJvcGVydHkgaGVyZSA/
DQo+IA0KPiBIaSBFdWdlbiwNCj4gDQo+IEl0J3Mgbm90IGEgcHJvYmxlbSB0byBrZWVwIGl0LCBi
dXQgSSBkb24ndCB0aGluayBpdCBtYWtlcyBzZW5zZS4gSW4gdGhpcw0KPiBjYXNlIG1tYy1kZHIt
M18zdiBzaG91bGQgYmUgYWRkZWQgdG9vLg0KPiANCj4gV2lsbCBpdCB3b3JrICdvdXQgb2YgdGhl
IGJveCcgd2l0aCBhbnkgZU1NQyB0byBTRC1DYXJkIGFkYXB0ZXJzIGFuZA0KPiBlTU1Dcz8gSSBy
ZW1lbWJlciBkaXNjdXNzaW9ucyB3aGVyZSB3ZSBzYWlkIEhXIGNoYW5nZXMgd2VyZSBuZWVkZWQg
dG8gYmUNCj4gYWJsZSB0byBzZWxlY3QgdGhlIHZvbHRhZ2UgZm9yIHRoZSBJT3Mgb3RoZXIgdGhh
biB1c2luZyB0aGUgVkREU0VMDQo+IHNpZ25hbCBvZiB0aGUgY29udHJvbGxlci4NCg0KWWVzIGlu
ZGVlZCAsIGRkci0zXzN2IHdvdWxkIGJlIG5lZWRlZCBmb3IgdGhvc2UuIEkgY2FuIGZvbGxvdyB1
cCBsYXRlciANCndpdGggYSBwYXRjaCB0byBhZGQgdGhhdCBpZiByZXF1aXJlZC4NCg0KVGhhbmtz
ICENCg0KPiANCj4gUmVnYXJkcw0KPiANCj4gTHVkb3ZpYw0KPiANCj4gDQo+Pg0KPj4gVGhhbmtz
LA0KPj4gRXVnZW4NCj4+DQo+Pj4gICAgIAkJCXN0YXR1cyA9ICJva2F5IjsNCj4+PiAgICAgCQl9
Ow0KPj4+ICAgICANCj4+Pg0KPj4NCj4gDQoNCg==
