Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5728D226E8C
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 20:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgGTSuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 14:50:16 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:41268 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGTSuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 14:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595271013; x=1626807013;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=P/W1J3hZS+8w0MkBh/RR0ZB6VOf4WFLeddvFV49hxfA=;
  b=VyB8AgUvpg8SXDD24L/50o3b2okrjmaO0tvMcGyx7ej/mnEu42ndmlhf
   CuJOMIHTPFrpnFcp4CJsr229vKsM4EDmCbeIpojavNXmH/pFgCjcJ8ybR
   C4MkE/k197PeqqiT1BBw1Ws1g36t5+C/Ns2NkIlP/HquOnxcwXA7WJ4lj
   PYs8s/bmo1PD257aRN4oL/qkMoMV1TS5toW8cNQi+Oczs+ZFWFUXnBVsQ
   rBuBgdBK0yvKNsvKJ6cHutlIb74yBvUSyV3ZjmmMTuwA+wUo13+i7ahWV
   gKeCPXig6z+OUKvMMvo+im33SpWUxKLIxYvrtAbuwogPYG9HGZzS1cggW
   Q==;
IronPort-SDR: PKIJsneeEsAZIZJW9AV4xE3CG8Cgo8BLk4JcNyZw7rLW6xYb9oyNw0TAqfK8MigS4ObuhYw2BL
 r2TJfu2e1LPUKNRf3dCPirpOTMdHLZQ7K6GOobS2y202YFfhNh4fkLEGeRCVXm9BgKD5Grp1av
 Hn7sWKfAVLJsKs+XV7f71TCkGBm6TcWs4zr+tcQtE0n142LyhTr8mzzgCdfKTIcxFu3geoJXif
 Yn33ucGX5gyfajXBGMzkPNfAV0i49H+P8y3QbvWMDGf82bKSjeB181oyx++gUNQB3RPJmlV5vy
 pmE=
X-IronPort-AV: E=Sophos;i="5.75,375,1589212800"; 
   d="scan'208";a="142943759"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 02:50:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWJu8UGd8s9xsYiFOHUNziTy0Ly6Des8UhPX/EWuv6lvfVz2wddRNzN0+unwtmZBajigRoT7fiLukfR0sibB+o4untafUSGR1CBzS2sWbfHLzZt6W+xdfSIzr98fZVLob6M0nvr+ySqEXb34Ixwmz7ks9fA4d8w5+iqg5iC6QZ+jGmtLCn/e+u7HAFPS/4CUmGcRO1ULUXq03yrKvvR8kjHdRj8DC6+v00/sNrna3GEqxTypsNbC9pxwCs04WPemfbJEuXr6/1yhwMVaNHqJeIXl08HJWeBIpRe7TdkIcWIdbsVHVf2mjOfYpelJXjY9jttiaUOiRoUk3NnQJw5L+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/W1J3hZS+8w0MkBh/RR0ZB6VOf4WFLeddvFV49hxfA=;
 b=Lrs3PqQ7NG7lpdpOGwfkT5qWApWHeIj4Xba5QOPvmh7sgcLFk0wSOOHDjzfvv8unkGRnU+KV0eZdAGLUPZRpWUhfwJFtqelMmWkFaxhmfd5hmxIpX8scEOukSVQrjy6NeAe8E/eRMMHRdeO0cWTeN98h8AaLBVed6c7wfBsikogdkAsIeewIXcmvhrWzR/1S/Q1D6YFVay0OWVnrc6K74Lk9t7+VpVB8nc+RRENlOKercNIIjx+vFTrEBrs+JgZVsXxT5vUs6bLeEGeil/dv/wATHnNGHJJBpNtiIj29N6fGyJxvdjXBAM1dj23JgSOKK9HLi+NNS00KqY207pL99w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/W1J3hZS+8w0MkBh/RR0ZB6VOf4WFLeddvFV49hxfA=;
 b=EjmR6ik1GBY65pEO/fKEZg4tNeRUb0V5Tg2jQRL/artNKLKCp0HEezQNe+ktymvLSZbtLxy63ibCQsAySF+kS5NgU+xly/hthSMYY81/MjU17OzYOIPqergJh8BcH4dXIZMmnKeZ0uHBZSARCczwhLznDBNm5IPKSACpP36St4c=
Received: from CH2PR04MB6725.namprd04.prod.outlook.com (2603:10b6:610:94::15)
 by CH2PR04MB6999.namprd04.prod.outlook.com (2603:10b6:610:91::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Mon, 20 Jul
 2020 18:50:11 +0000
Received: from CH2PR04MB6725.namprd04.prod.outlook.com
 ([fe80::cc92:ebd4:685c:7f1]) by CH2PR04MB6725.namprd04.prod.outlook.com
 ([fe80::cc92:ebd4:685c:7f1%3]) with mapi id 15.20.3195.025; Mon, 20 Jul 2020
 18:50:10 +0000
From:   Atish Patra <Atish.Patra@wdc.com>
To:     "naresh.kamboju@linaro.org" <naresh.kamboju@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "walken@google.com" <walken@google.com>,
        "palmerdabbelt@google.com" <palmerdabbelt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zong.li@sifive.com" <zong.li@sifive.com>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>
Subject: Re: [PATCH 5.7 233/244] RISC-V: Acquire mmap lock before invoking
 walk_page_range
Thread-Topic: [PATCH 5.7 233/244] RISC-V: Acquire mmap lock before invoking
 walk_page_range
Thread-Index: AQHWXrETjDxZGeRGbk6/4QyqHlR0zKkQvJIAgAATOoA=
Date:   Mon, 20 Jul 2020 18:50:10 +0000
Message-ID: <194a70d4428b96b59594efc5cae7ed26f6da45b3.camel@wdc.com>
References: <20200720152825.863040590@linuxfoundation.org>
         <20200720152836.926007002@linuxfoundation.org>
         <CA+G9fYteJs0X1Ctjbt-51Q9J2JHM--cOpYg+02jSdfnbWbwr2g@mail.gmail.com>
In-Reply-To: <CA+G9fYteJs0X1Ctjbt-51Q9J2JHM--cOpYg+02jSdfnbWbwr2g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [98.248.240.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 12570b70-3c73-47a2-2108-08d82cddbaf6
x-ms-traffictypediagnostic: CH2PR04MB6999:
x-microsoft-antispam-prvs: <CH2PR04MB699987C696F5060F3386B6DBFA7B0@CH2PR04MB6999.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P5IyxX0Vmc2dNjdi3JDN/pWfFDHOD2rFQKn9fzOIMWZj0uKQS/WT9vPZKyQ4nghuQ9NK+9xhbNOmVOIlrmu+ixzbD/918RPXFAV2KkA3N9Cm78z9SE1hKKvJtqDLzp8xIx/3npjLnYu9LeiDRJTSTkd4oL7W+0m4bzLZdro+G9gdNVb57YnjgCZfgC1AMmfBbzv+fVlBBE9QfcUon+O6pzt04LyaqWX2c8wRlO+EorRAVe68MwXPAvHRRLzFxH0IUU+kX/deW/5SqZhEjqABWAqHcSnEO0CZXcDXTMcKQskaFLCAmleJsvhBLMMGhbjNUDhPhsxpECnq3vlm+IbDQt+bEXl0NQ8MDIV7BpYostYFre1xLC8fow6pIj/roIwqzBU1+h4h8gTDeLjqKI6M2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB6725.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(316002)(110136005)(83380400001)(186003)(54906003)(4326008)(2616005)(966005)(71200400001)(8676002)(6506007)(5660300002)(66946007)(66556008)(66446008)(6486002)(26005)(478600001)(2906002)(8936002)(36756003)(66476007)(76116006)(91956017)(86362001)(64756008)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: rPsiLD95ygDzM4RR3oeF7lCh/IdthXeCCJqbvI7jImoIAB+DkXQSrrf+76WFRiqNFMp3imoEHbp0x/SFwmGxH+9q7EL4etZGAZInIcgUImq4nVUjFB9NZ+OsGOKT+kgA/OEAlwL6FJTSHCwISvRvqZrTmHUwwW68byt4Wiyzq5WUtbYmw8Fs5T+CcRrLmVpXpUQkhm9wVkMQRtofW/J/A8zu373hUqnFx954x3y6/I4JhX7nPjRfqwnx6R50Zr6UZFmezUXAl1lBbU9s04MkTKMRADHlgivO43n26MF4B9ayGPn4iU+DVOcxVQNq6gjaZ+36wiYVbTzR0Fe+Yzb9OhZtYA052Q8L6rhkw0lPB2oclvyKOPZ4Q5QFuI+hn373A2Wu0Y8sRnNW/S6vtxDIiz6mMlXWoEd/JeYEbes3YUDRisobo8TqZs7Fms9VkYtTY1lT3jfjAZqStFFcIfvZUV8yLtQeNyDY/iWeZzL3elyeKFf6tZj90s+9R+aapQWh
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB17025FCBE89143BFE321E38BA8BA97@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6725.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12570b70-3c73-47a2-2108-08d82cddbaf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 18:50:10.8409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tPxDot96IV9MO9tBEKog6eJkm7swDjecmX1m3wl0un74YjKsgAkaKZTA6kjFWfHSh09g3msec8v4Ml9CHyAsWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6999
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDIwLTA3LTIwIGF0IDIzOjExICswNTMwLCBOYXJlc2ggS2FtYm9qdSB3cm90ZToN
Cj4gUklTQy1WIGJ1aWxkIGJyZWFrcyBvbiBzdGFibGUtcmMgNS43IGJyYW5jaC4NCj4gYnVpbGQg
ZmFpbGVkIHdpdGggZ2NjLTgsIGdjYy05IGFuZCBnY2MtOS4NCj4gDQoNClNvcnJ5IGZvciB0aGUg
Y29tcGlsYXRpb24gaXNzdWUuDQoNCm1tYXBfcmVhZF9sb2NrIHdhcyBpbnRyZG91Y2VkIGluIHRo
ZSBmb2xsb3dpbmcgY29tbWl0Lg0KDQpjb21taXQgOTc0MGNhNGU5NWI0DQpBdXRob3I6IE1pY2hl
bCBMZXNwaW5hc3NlIDx3YWxrZW5AZ29vZ2xlLmNvbT4NCkRhdGU6ICAgTW9uIEp1biA4IDIxOjMz
OjE0IDIwMjAgLTA3MDANCg0KICAgIG1tYXAgbG9ja2luZyBBUEk6IGluaXRpYWwgaW1wbGVtZW50
YXRpb24gYXMgcndzZW0gd3JhcHBlcnMNCg0KVGhlIGZvbGxvd2luZyB0d28gY29tbWl0cyByZXBs
YWNlZCB0aGUgdXNhZ2Ugb2YgbW1hcF9zZW0gcndzZW0gY2FsbHMNCndpdGggbW1hcF9sb2NrLg0K
DQpkOGVkNDVjNWRjZDQgKG1tYXAgbG9ja2luZyBBUEk6IHVzZSBjb2NjaW5lbGxlIHRvIGNvbnZl
cnQgbW1hcF9zZW0NCnJ3c2VtIGNhbGwgc2l0ZXMpDQo4OTE1NGRkNTMxM2YgKG1tYXAgbG9ja2lu
ZyBBUEk6IGNvbnZlcnQgbW1hcF9zZW0gY2FsbCBzaXRlcyBtaXNzZWQgYnkNCmNvY2NpbmVsbGUp
DQoNClRoZSBmaXJzdCBjb21taXQgaXMgbm90IHByZXNlbnQgaW4gc3RhbGUgNS43LXkgZm9yIG9i
dmlvdXMgcmVhc29ucy4NCg0KRG8gd2UgbmVlZCB0byBzZW5kIGEgc2VwYXJhdGUgcGF0Y2ggb25s
eSBmb3Igc3RhYmxlIGJyYW5jaCB3aXRoDQptbWFwX3NlbSA/IEkgYW0gbm90IHN1cmUgaWYgdGhh
dCB3aWxsIGNhdXNlIGEgY29uZmxpY3QgYWdhaW4gaW4gZnV0dXJlLg0KDQo+IE9uIE1vbiwgMjAg
SnVsIDIwMjAgYXQgMjE6NDYsIEdyZWcgS3JvYWgtSGFydG1hbg0KPiA8Z3JlZ2toQGxpbnV4Zm91
bmRhdGlvbi5vcmc+IHdyb3RlOg0KPiA+IEZyb206IEF0aXNoIFBhdHJhIDxhdGlzaC5wYXRyYUB3
ZGMuY29tPg0KPiA+IA0KPiA+IGNvbW1pdCAwZTJjMDkwMTFkNGRlNDE2MWY2MTVmZjg2MGE2MDVh
OTE4NmNmNjJhIHVwc3RyZWFtLg0KPiA+IA0KPiA+IEFzIHBlciB3YWxrX3BhZ2VfcmFuZ2UgZG9j
dW1lbnRhdGlvbiwgbW1hcCBsb2NrIHNob3VsZCBiZSBhY3F1aXJlZA0KPiA+IGJ5IHRoZQ0KPiA+
IGNhbGxlciBiZWZvcmUgaW52b2tpbmcgd2Fsa19wYWdlX3JhbmdlLiBtbWFwX2Fzc2VydF9sb2Nr
ZWQgZ2V0cw0KPiA+IHRyaWdnZXJlZA0KPiA+IHdpdGhvdXQgdGhhdC4gVGhlIGRldGFpbHMgY2Fu
IGJlIGZvdW5kIGhlcmUuDQo+ID4gDQo+ID4gaHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvcGlw
ZXJtYWlsL2xpbnV4LXJpc2N2LzIwMjAtSnVuZS8wMTAzMzUuaHRtbA0KPiA+IA0KPiA+IEZpeGVz
OiAzOTVhMjFmZjg1OWMocmlzY3Y6IGFkZCBBUkNIX0hBU19TRVRfRElSRUNUX01BUCBzdXBwb3J0
KQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEF0aXNoIFBhdHJhIDxhdGlzaC5wYXRyYUB3ZGMuY29tPg0K
PiA+IFJldmlld2VkLWJ5OiBNaWNoZWwgTGVzcGluYXNzZSA8d2Fsa2VuQGdvb2dsZS5jb20+DQo+
ID4gUmV2aWV3ZWQtYnk6IFpvbmcgTGkgPHpvbmcubGlAc2lmaXZlLmNvbT4NCj4gPiBTaWduZWQt
b2ZmLWJ5OiBQYWxtZXIgRGFiYmVsdCA8cGFsbWVyZGFiYmVsdEBnb29nbGUuY29tPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5v
cmc+DQo+ID4gDQo+ID4gLS0tDQo+ID4gIGFyY2gvcmlzY3YvbW0vcGFnZWF0dHIuYyB8ICAgMTQg
KysrKysrKysrKysrLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gLS0tIGEvYXJjaC9yaXNjdi9tbS9wYWdlYXR0ci5jDQo+
ID4gKysrIGIvYXJjaC9yaXNjdi9tbS9wYWdlYXR0ci5jDQo+ID4gQEAgLTE1MSw2ICsxNTEsNyBA
QCBpbnQgc2V0X21lbW9yeV9ueCh1bnNpZ25lZCBsb25nIGFkZHIsIGluDQo+ID4gDQo+ID4gIGlu
dCBzZXRfZGlyZWN0X21hcF9pbnZhbGlkX25vZmx1c2goc3RydWN0IHBhZ2UgKnBhZ2UpDQo+ID4g
IHsNCj4gPiArICAgICAgIGludCByZXQ7DQo+ID4gICAgICAgICB1bnNpZ25lZCBsb25nIHN0YXJ0
ID0gKHVuc2lnbmVkIGxvbmcpcGFnZV9hZGRyZXNzKHBhZ2UpOw0KPiA+ICAgICAgICAgdW5zaWdu
ZWQgbG9uZyBlbmQgPSBzdGFydCArIFBBR0VfU0laRTsNCj4gPiAgICAgICAgIHN0cnVjdCBwYWdl
YXR0cl9tYXNrcyBtYXNrcyA9IHsNCj4gPiBAQCAtMTU4LDExICsxNTksMTYgQEAgaW50IHNldF9k
aXJlY3RfbWFwX2ludmFsaWRfbm9mbHVzaChzdHJ1Yw0KPiA+ICAgICAgICAgICAgICAgICAuY2xl
YXJfbWFzayA9IF9fcGdwcm90KF9QQUdFX1BSRVNFTlQpDQo+ID4gICAgICAgICB9Ow0KPiA+IA0K
PiA+IC0gICAgICAgcmV0dXJuIHdhbGtfcGFnZV9yYW5nZSgmaW5pdF9tbSwgc3RhcnQsIGVuZCwg
JnBhZ2VhdHRyX29wcywNCj4gPiAmbWFza3MpOw0KPiA+ICsgICAgICAgbW1hcF9yZWFkX2xvY2so
JmluaXRfbW0pOw0KPiA+ICsgICAgICAgcmV0ID0gd2Fsa19wYWdlX3JhbmdlKCZpbml0X21tLCBz
dGFydCwgZW5kLCAmcGFnZWF0dHJfb3BzLA0KPiA+ICZtYXNrcyk7DQo+ID4gKyAgICAgICBtbWFw
X3JlYWRfdW5sb2NrKCZpbml0X21tKTsNCj4gDQo+IG1ha2UgLXNrIEtCVUlMRF9CVUlMRF9VU0VS
PVR1eEJ1aWxkIC1DL2xpbnV4IEFSQ0g9cmlzY3YNCj4gQ1JPU1NfQ09NUElMRT1yaXNjdjY0LWxp
bnV4LWdudS0gSE9TVENDPWdjYyBDQz0ic2NjYWNoZQ0KPiByaXNjdjY0LWxpbnV4LWdudS1nY2Mi
IE89YnVpbGQgZGVmY29uZmlnDQo+ICMNCj4gIw0KPiBtYWtlIC1zayBLQlVJTERfQlVJTERfVVNF
Uj1UdXhCdWlsZCAtQy9saW51eCAtajMyIEFSQ0g9cmlzY3YNCj4gQ1JPU1NfQ09NUElMRT1yaXNj
djY0LWxpbnV4LWdudS0gSE9TVENDPWdjYyBDQz0ic2NjYWNoZQ0KPiByaXNjdjY0LWxpbnV4LWdu
dS1nY2MiIE89YnVpbGQNCj4gIw0KPiAuLi9hcmNoL3Jpc2N2L21tL3BhZ2VhdHRyLmM6IEluIGZ1
bmN0aW9uDQo+IOKAmHNldF9kaXJlY3RfbWFwX2ludmFsaWRfbm9mbHVzaOKAmToNCj4gLi4vYXJj
aC9yaXNjdi9tbS9wYWdlYXR0ci5jOjE2MjoyOiBlcnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24g
b2YNCj4gZnVuY3Rpb24g4oCYbW1hcF9yZWFkX2xvY2vigJk7IGRpZCB5b3UgbWVhbiDigJhfcmF3
X3JlYWRfbG9ja+KAmT8NCj4gWy1XZXJyb3I9aW1wbGljaXQtZnVuY3Rpb24tZGVjbGFyYXRpb25d
DQo+ICAgMTYyIHwgIG1tYXBfcmVhZF9sb2NrKCZpbml0X21tKTsNCj4gICAgICAgfCAgXn5+fn5+
fn5+fn5+fn4NCj4gICAgICAgfCAgX3Jhd19yZWFkX2xvY2sNCj4gLi4vYXJjaC9yaXNjdi9tbS9w
YWdlYXR0ci5jOjE2NDoyOiBlcnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YNCj4gZnVuY3Rp
b24g4oCYbW1hcF9yZWFkX3VubG9ja+KAmTsgZGlkIHlvdSBtZWFuIOKAmF9yYXdfcmVhZF91bmxv
Y2vigJk/DQo+IFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KPiAgIDE2
NCB8ICBtbWFwX3JlYWRfdW5sb2NrKCZpbml0X21tKTsNCj4gICAgICAgfCAgXn5+fn5+fn5+fn5+
fn5+fg0KPiAgICAgICB8ICBfcmF3X3JlYWRfdW5sb2NrDQo+IGNjMTogc29tZSB3YXJuaW5ncyBi
ZWluZyB0cmVhdGVkIGFzIGVycm9ycw0KPiANCj4gPiArDQo+ID4gKyAgICAgICByZXR1cm4gcmV0
Ow0KPiA+ICB9DQo+ID4gDQo+ID4gIGludCBzZXRfZGlyZWN0X21hcF9kZWZhdWx0X25vZmx1c2go
c3RydWN0IHBhZ2UgKnBhZ2UpDQo+ID4gIHsNCj4gPiArICAgICAgIGludCByZXQ7DQo+ID4gICAg
ICAgICB1bnNpZ25lZCBsb25nIHN0YXJ0ID0gKHVuc2lnbmVkIGxvbmcpcGFnZV9hZGRyZXNzKHBh
Z2UpOw0KPiA+ICAgICAgICAgdW5zaWduZWQgbG9uZyBlbmQgPSBzdGFydCArIFBBR0VfU0laRTsN
Cj4gPiAgICAgICAgIHN0cnVjdCBwYWdlYXR0cl9tYXNrcyBtYXNrcyA9IHsNCj4gPiBAQCAtMTcw
LDcgKzE3NiwxMSBAQCBpbnQgc2V0X2RpcmVjdF9tYXBfZGVmYXVsdF9ub2ZsdXNoKHN0cnVjDQo+
ID4gICAgICAgICAgICAgICAgIC5jbGVhcl9tYXNrID0gX19wZ3Byb3QoMCkNCj4gPiAgICAgICAg
IH07DQo+ID4gDQo+ID4gLSAgICAgICByZXR1cm4gd2Fsa19wYWdlX3JhbmdlKCZpbml0X21tLCBz
dGFydCwgZW5kLCAmcGFnZWF0dHJfb3BzLA0KPiA+ICZtYXNrcyk7DQo+ID4gKyAgICAgICBtbWFw
X3JlYWRfbG9jaygmaW5pdF9tbSk7DQo+ID4gKyAgICAgICByZXQgPSB3YWxrX3BhZ2VfcmFuZ2Uo
JmluaXRfbW0sIHN0YXJ0LCBlbmQsICZwYWdlYXR0cl9vcHMsDQo+ID4gJm1hc2tzKTsNCj4gPiAr
ICAgICAgIG1tYXBfcmVhZF91bmxvY2soJmluaXRfbW0pOw0KPiA+ICsNCj4gPiArICAgICAgIHJl
dHVybiByZXQ7DQo+ID4gIH0NCj4gPiANCj4gPiAgdm9pZCBfX2tlcm5lbF9tYXBfcGFnZXMoc3Ry
dWN0IHBhZ2UgKnBhZ2UsIGludCBudW1wYWdlcywgaW50DQo+ID4gZW5hYmxlKQ0KPiA+IA0KPiAN
Cj4gcmVmOg0KPiBmdWxsIGJ1aWxkIGxvZyB3aXRoIGRlZmF1bHQgY29uZmlnLg0KPiBodHRwczov
L2dpdGxhYi5jb20vTGluYXJvL2xrZnQva2VybmVsLXJ1bnMvLS9qb2JzLzY0NzE1NDk1MA0KPiAN
Cg0KLS0gDQpSZWdhcmRzLA0KQXRpc2gNCg==
