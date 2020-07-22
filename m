Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41779229B10
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 17:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgGVPLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 11:11:43 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:39016 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgGVPLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 11:11:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595430713; x=1626966713;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sauSL6Kc1n8rZC8xoeJPVciON/cOvy1jR8KwM5ASwvA=;
  b=ftYvFZZfvVNDaqdhhiH96xB/q3AbisS8FL48znev8Z7sZkupe3iem5+Y
   V4nLaOwVGHVZlHPaDxb0PE5B5lERhoISaakAGlM8OFqYKqO9fFVVoUIdW
   n+Sg2mryZdnm9GLgBSD0uE4uajfMIkyIiF2nQlAaXrw29Hm/6y8Av4GYp
   npHzHGvMKgcY6Juss3ysNseqQrVXrFRbrVxvXXVIVK5kg0ATyp50/Clat
   tKW++HAQFkSkzD8fS7DBBGOg8EiSjry0rApHUerWvNIZa1D6VgWHW6lmv
   v1qLuAwKT5MnKZlk/2Zjv7YMTKphOcpXy6+SsSHrqzFDjP5i+VaA7jJc/
   Q==;
IronPort-SDR: WHdu3hpjnjc1VEnbDPfenQh865Im17+QkAB2ZzftWixsyluY3CkYdDIm9LM6KB0qiF2Jx/JOTr
 ezPltu6ZrWoXbIwppAPAPt287vGMrQH3A/jzFnAzt5K23WYYBTjzg7CoYN4Nne8uPOe5m6cJJg
 MEAH+200c8ENmoXdQBrboyuJk6D1eHmpaMUts5E4LbU0aq7QYXg6n8L/tN0pvzgxt/sU+l5nBf
 Uaf8H5rJGKz/zBo06qgOCAG11JzyGZnJG1D/XYib3ObOUVp8AftPSWlfTrbuQ2xe7S+8WmGUIu
 KcM=
X-IronPort-AV: E=Sophos;i="5.75,383,1589212800"; 
   d="scan'208";a="246168579"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jul 2020 23:11:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4NbVIJT3qvJhaxVqCtgKK4o8aF/ucun6Emp3arq6MEB/7ZSNLylEJ8CP9O6QBxXq689mplTPE6Ic2k2wEHGZG9ha1e8gxFSoCADcXlK6UImNH93eMj22KVKHTI4q93IhhGb+rwVquay3BDUqOE+/D8G9ykxhdVOimTUAOQTHoqx3icncOt8i6kcZNauvIuVN3r/GE3kxIkAAsBW6VHIaUQS1m0UBe3PIX2PsnRp60Do3grRnE9pDum0CMtPIQB6BYugrPvObtWpgDDXebcUdVeb7ORozAHwCROQ3qLpXmewyCfIK3Po6+xe3ALn/LxetN35LZVec3akeE1j1HVwYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sauSL6Kc1n8rZC8xoeJPVciON/cOvy1jR8KwM5ASwvA=;
 b=K9EGhhtuAlpsGdJsHQJx9ltQnTZzRk3RtlAyNCjOKa6SO6Pi1WenpzivTA6wPifEccm5oBJAPkuND4izpcM1GQsZGDreAXm2gChMZKriRuRDRi0gXtL65FsZ6Qka0H54gf/kb01YAHelz9lgvQh1D5KquJ6lzWCP2/smeRte2pnBi9Z9+1eO95ijc+HX8K7W3A2rdWSoCuO0SFAlka3BlYCJNaoJzDy5ky4HwdYauBNCpt+dwFimi/AflUWEEhazj2Xoy4P0gR1mCzlVXeXCj8OhoaWXDsdJ+7XkrYyhT/H3aEKZvRlzMBdXTKODbDvMLR3yz95Zp61z+Lwyl25+5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sauSL6Kc1n8rZC8xoeJPVciON/cOvy1jR8KwM5ASwvA=;
 b=SJlmL4a+2KjMnCIMpIAZCEBLbAR/GK1hWREBRlR4mq1DQpNemypIIrg0k0+Z171uVZqiOBOmq16UWV4eNE5gLQc+Sui0iDAaKVF21q1AYJUzTS2Kyzb0XHnt1brRFuvAFZxjqy3hXYywJuhS64j3H7UCk1YHWFNJX4ELEYjvGPQ=
Received: from BY5PR04MB6724.namprd04.prod.outlook.com (2603:10b6:a03:219::15)
 by BYAPR04MB5013.namprd04.prod.outlook.com (2603:10b6:a03:4b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Wed, 22 Jul
 2020 15:11:35 +0000
Received: from BY5PR04MB6724.namprd04.prod.outlook.com
 ([fe80::90f3:1abd:2ec8:a91a]) by BY5PR04MB6724.namprd04.prod.outlook.com
 ([fe80::90f3:1abd:2ec8:a91a%9]) with mapi id 15.20.3216.022; Wed, 22 Jul 2020
 15:11:35 +0000
From:   Atish Patra <Atish.Patra@wdc.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "palmerdabbelt@google.com" <palmerdabbelt@google.com>
CC:     "walken@google.com" <walken@google.com>,
        "naresh.kamboju@linaro.org" <naresh.kamboju@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zong.li@sifive.com" <zong.li@sifive.com>,
        "shorne@gmail.com" <shorne@gmail.com>
Subject: Re: [PATCH 5.7 233/244] RISC-V: Acquire mmap lock before invoking
 walk_page_range
Thread-Topic: [PATCH 5.7 233/244] RISC-V: Acquire mmap lock before invoking
 walk_page_range
Thread-Index: AQHWXrETjDxZGeRGbk6/4QyqHlR0zKkQvJIAgAATOoCAAAaugIABztSAgADqJ4CAACfuAA==
Date:   Wed, 22 Jul 2020 15:11:35 +0000
Message-ID: <0fcbb91ab6dc49807dcca953c5dca673ad403045.camel@wdc.com>
References: <20200720191403.GB1529125@kroah.com>
         <mhng-903745bf-c5df-4e70-ade8-c1e596265fc4@palmerdabbelt-glaptop1>
         <20200722124839.GB3155653@kroah.com>
In-Reply-To: <20200722124839.GB3155653@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [98.248.240.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c148eb98-c05f-4588-6e01-08d82e518666
x-ms-traffictypediagnostic: BYAPR04MB5013:
x-microsoft-antispam-prvs: <BYAPR04MB50133B71A2AC251EC5F064FCFA790@BYAPR04MB5013.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CglGTPIG31vVvXYQB5VwLXF5oiIWi6u2NSiNBBItBGgYTKgWUTffgrWH0kqfYa3D8D85fOvHw2uDUCWpy8YXd5UKRozJmB4QIVq/rEW/usoAO8KQk6fnQ+t6kQiNc2Jyq6yQS7W2VM5uSum2Bja5BOlWUEm3y+0S9aFhAFPhLPl0rEgZDE17PSeF6CY5O4YpiMpDA7JQHfuDdC/266il19b6bSbKP/5A05JijeAKzhfB9qIDS/8pEYJDwlqVw/zX5Z3Yia+ooOIZAG/6McLIMiGxKPTRJSco3YB309uPSNFz/RWDP0iRGdT8iqDqkmn/QFQnrLzsXG3wY2ufdM1T9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6724.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(54906003)(110136005)(86362001)(71200400001)(478600001)(2906002)(5660300002)(4326008)(6486002)(8936002)(8676002)(6506007)(83380400001)(36756003)(316002)(66446008)(6512007)(66946007)(66556008)(66476007)(64756008)(2616005)(26005)(186003)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 6GqMQqYuAJpqOn7EpFMik0ShIpjXQCYk/7+64lll83y5JXHcib4r2zfg1adiQSKlw74acdX6cHSSTPQxeJ8crmaKZvIUO01nuhaU5WOdR5KHzxyGMFLU4wfZ5GMl+ZjF5DboGxo/33X9cd99gZUw1nS32569uhTya0t4Rj5fo8lCdPjDQkxGGaISnqS8Jy3AODDs67tabFZszACKiciEpPsujPNzIb0LNIRd53L/1KBfCzFAbHaejUN5LjazeJOXrVl7B8swTu9e0GXIRcgJNa9Bm7yLai0RjToLGlOMGnVoDqzukGmMjogMlWBB7emupjSIaZnz/AmMoJzA1aEAFd8v5/LKvagsDp+EUarBhuWBJPacz8+gu5ud+H2ABKHru74NAmHxcRHgHnXZ+8WEAWhN/WkK93qiVQAWOgCQfEC6bZAiSNfmnC+Nhh4q+d9XIjs8OH4XvEnKOnzvhafO//DkAHvdzBPnpZnI/3nH5pA7Iti3T4YiQg9EVVkODL+T
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5262CAE7228935419C02A9151E3D37BD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6724.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c148eb98-c05f-4588-6e01-08d82e518666
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 15:11:35.3788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 71lKTEypL8tpYtqAiOVJWRaarnmMcisevWHyqM0I1OzGw7ZDFEBV25kFXw2DDte6+iqy/66tDsZAVwAL1ConXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5013
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIwLTA3LTIyIGF0IDE0OjQ4ICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBU
dWUsIEp1bCAyMSwgMjAyMCBhdCAwMzo1MDozNVBNIC0wNzAwLCBQYWxtZXIgRGFiYmVsdCB3cm90
ZToNCj4gPiBPbiBNb24sIDIwIEp1bCAyMDIwIDEyOjE0OjAzIFBEVCAoLTA3MDApLCBHcmVnIEtI
IHdyb3RlOg0KPiA+ID4gT24gTW9uLCBKdWwgMjAsIDIwMjAgYXQgMDY6NTA6MTBQTSArMDAwMCwg
QXRpc2ggUGF0cmEgd3JvdGU6DQo+ID4gPiA+IE9uIE1vbiwgMjAyMC0wNy0yMCBhdCAyMzoxMSAr
MDUzMCwgTmFyZXNoIEthbWJvanUgd3JvdGU6DQo+ID4gPiA+ID4gUklTQy1WIGJ1aWxkIGJyZWFr
cyBvbiBzdGFibGUtcmMgNS43IGJyYW5jaC4NCj4gPiA+ID4gPiBidWlsZCBmYWlsZWQgd2l0aCBn
Y2MtOCwgZ2NjLTkgYW5kIGdjYy05Lg0KPiA+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gU29y
cnkgZm9yIHRoZSBjb21waWxhdGlvbiBpc3N1ZS4NCj4gPiA+ID4gDQo+ID4gPiA+IG1tYXBfcmVh
ZF9sb2NrIHdhcyBpbnRyZG91Y2VkIGluIHRoZSBmb2xsb3dpbmcgY29tbWl0Lg0KPiA+ID4gPiAN
Cj4gPiA+ID4gY29tbWl0IDk3NDBjYTRlOTViNA0KPiA+ID4gPiBBdXRob3I6IE1pY2hlbCBMZXNw
aW5hc3NlIDx3YWxrZW5AZ29vZ2xlLmNvbT4NCj4gPiA+ID4gRGF0ZTogICBNb24gSnVuIDggMjE6
MzM6MTQgMjAyMCAtMDcwMA0KPiA+ID4gPiANCj4gPiA+ID4gICAgIG1tYXAgbG9ja2luZyBBUEk6
IGluaXRpYWwgaW1wbGVtZW50YXRpb24gYXMgcndzZW0gd3JhcHBlcnMNCj4gPiA+ID4gDQo+ID4g
PiA+IFRoZSBmb2xsb3dpbmcgdHdvIGNvbW1pdHMgcmVwbGFjZWQgdGhlIHVzYWdlIG9mIG1tYXBf
c2VtIHJ3c2VtDQo+ID4gPiA+IGNhbGxzDQo+ID4gPiA+IHdpdGggbW1hcF9sb2NrLg0KPiA+ID4g
PiANCj4gPiA+ID4gZDhlZDQ1YzVkY2Q0IChtbWFwIGxvY2tpbmcgQVBJOiB1c2UgY29jY2luZWxs
ZSB0byBjb252ZXJ0DQo+ID4gPiA+IG1tYXBfc2VtDQo+ID4gPiA+IHJ3c2VtIGNhbGwgc2l0ZXMp
DQo+ID4gPiA+IDg5MTU0ZGQ1MzEzZiAobW1hcCBsb2NraW5nIEFQSTogY29udmVydCBtbWFwX3Nl
bSBjYWxsIHNpdGVzDQo+ID4gPiA+IG1pc3NlZCBieQ0KPiA+ID4gPiBjb2NjaW5lbGxlKQ0KPiA+
ID4gPiANCj4gPiA+ID4gVGhlIGZpcnN0IGNvbW1pdCBpcyBub3QgcHJlc2VudCBpbiBzdGFsZSA1
LjcteSBmb3Igb2J2aW91cw0KPiA+ID4gPiByZWFzb25zLg0KPiA+ID4gPiANCj4gPiA+ID4gRG8g
d2UgbmVlZCB0byBzZW5kIGEgc2VwYXJhdGUgcGF0Y2ggb25seSBmb3Igc3RhYmxlIGJyYW5jaCB3
aXRoDQo+ID4gPiA+IG1tYXBfc2VtID8gSSBhbSBub3Qgc3VyZSBpZiB0aGF0IHdpbGwgY2F1c2Ug
YSBjb25mbGljdCBhZ2FpbiBpbg0KPiA+ID4gPiBmdXR1cmUuDQo+ID4gPiANCj4gPiA+IEkgZG8g
bm90IGxpa2UgdGFraW5nIG9kZCBiYWNrcG9ydHMsIGFuZCB3b3VsZCByYXRoZXIgdGFrZSB0aGUN
Cj4gPiA+IHJlYWwgcGF0Y2gNCj4gPiA+IHRoYXQgaXMgdXBzdHJlYW0uDQo+ID4gDQo+ID4gSSBn
dWVzcyBJJ20gYSBiaXQgbmV3IHRvIHN0YWJsZSBiYWNrcG9ydHMgc28gSSdtIG5vdCBzdXJlIHdo
YXQncw0KPiA+IGV4cGVjdGVkIGhlcmUuDQo+ID4gVGhlIGZhaWxpbmcgcGF0Y2ggZml4ZXMgYSBi
dWcgYnkgdXNpbmcgYSBuZXcgaW50ZXJmYWNlLiAgVGhlDQo+ID4gc21hbGxlc3QgZGlmZiBmaXgN
Cj4gPiBmb3IgdGhlIHN0YWJsZSBrZXJuZWxzIHdvdWxkIGJlIHRvIGNvbnN0cnVjdCBhIHNpbWls
YXIgZml4IHdpdGhvdXQNCj4gPiB0aGUgbmV3DQo+ID4gaW50ZXJmYWNlLCB3aGljaCBpbiB0aGlz
IGNhc2UgaXMgdmVyeSBlYXN5IGFzIHRoZSBuZXcgaW50ZXJmYWNlDQo+ID4ganVzdCBjb252ZXJ0
ZWQNCj4gPiBzb21lIGdlbmVyaWMgbG9ja2luZyBjYWxscyB0byBvbmUtbGluZSBmdW5jdGlvbnMu
ICBJdCBzZWVtcw0KPiA+IHNvbWV3aGF0IGNpcmN1aXRvdXMNCj4gPiB0byBsYW5kIHRoYXQgaW4g
TGludXMnIHRyZWUsIHRob3VnaCwgYXMgaXQgd291bGQgcmVxdWlyZSBicmVha2luZw0KPiA+IG91
ciBwb3J0DQo+ID4gYmVmb3JlIGZpeGluZyBpdCB0byB1c2UgdGhlIG9sZCBpbnRlcmZhY2VzIGFu
ZCB0aGVuIGNsZWFuaW5nIGl0IHVwDQo+ID4gdG8gdXNlIHRoZQ0KPiA+IG5ldyBpbnRlcmZhY2Vz
Lg0KPiA+IA0KPiA+IEFyZSB3ZSBleHBlY3RlZCB0byBwdWxsIHRoZSBuZXcgaW50ZXJmYWNlIG9u
dG8gc3RhYmxlIGluIGFkZGl0aW9uDQo+ID4gdG8gdGhpcyBmaXg/DQo+IA0KPiBJZiBpdCByZWFs
bHkgZG9lcyBmaXggYSBiaWcgaXNzdWUsIHllcywgdGhhdCBpcyBmaW5lIHRvIGRvLg0KPiANCg0K
VGhlIG9yaWdpbmFsIGlzc3VlIHdhcyBtYW5pZmVzdHMgb25seSBmb3IgY2VydGFpbiByb290ZnMg
d2l0aA0KQ09ORklHX0RFQlVHX1ZNIGVuYWJsZWQgaW4ga2VybmVsLiBJIGFtIG5vdCBzdXJlIGlm
IHRoYXQgcXVhbGZpZXMgZm9yIGENCmJpZyBpc3N1ZSA6KS4gQnV0IHRoZXJlIHdhcyBhIHNpbWls
YXIgZml4IGZvciBPcGVuUklTQyBhcyB3ZWxsLg0KDQorc3RhZmZvcmQgKHdobyBmaXhlZCB0aGUg
aXNzdWUgZm9yIE9wZW5SSVNDKQ0KDQpAc3RhZmZvcmQgV2FzIHRoZXJlIGEgcmVxdWVzdCB0byBi
YWNrcG9ydCB0aGUgZml4IHRvIHN0YWJsZSA/DQoNCkkgY2FuIGNvbWJpbmUgYWxsIHRoZSBnaXQg
aWRzIHRoYXQgbmVlZHMgdG8gYmUgcHVsbGVkIGluLg0KDQo+ID4gVGhlIG5ldyBpbnRlcmZhY2Ug
ZG9lc24ndCBhY3R1YWxseSBmaXggYW55dGhpbmcgaXRzZWxmLCBidXQgaXQNCj4gPiB3b3VsZCBh
bGxvdyBhDQo+ID4gZnVuY3Rpb25hbCBrZXJuZWwgdG8gYmUgY29uc3RydWN0ZWQgdGhhdCBjb25z
aXN0ZWQgb2Ygb25seQ0KPiA+IGJhY2twb3J0cyBmcm9tDQo+ID4gTGludXMnIHRyZWUgKHdoaWNo
IHdvdWxkIGFsc28gbWFrZSBmdXJ0aGVyIGZpeGVzIGVhc2llcikuDQo+IA0KPiBUaGF0J3MgZmlu
ZS4NCj4gDQo+ID4gSXQgc2VlbXMgc2FmZSB0bw0KPiA+IGp1c3QgcHVsbCBpbiA5NzQwY2E0ZTk1
YjQgKCJtbWFwIGxvY2tpbmcgQVBJOiBpbml0aWFsDQo+ID4gaW1wbGVtZW50YXRpb24gYXMgcndz
ZW0NCj4gPiB3cmFwcGVycyIpIGJlZm9yZSB0aGlzIGZhaWxpbmcgcGF0Y2gsIGFzIGluIHRoaXMg
Y2FzZSB0aGUgbmV3DQo+ID4gaW50ZXJmYWNlIHdpbGwNCj4gPiBmdW5jdGlvbiBjb3JyZWN0bHkg
d2l0aCBvbmx5IGEgc3Vic2V0IG9mIGNhbGxlcnMgaGF2aW5nIGJlZW4NCj4gPiBjb252ZXJ0ZWQu
ICBPZg0KPiA+IGNvdXJzZSB0aGF0J3Mgbm90IGEgZ2VuZXJhbGx5IHRydWUgc3RhdGVtZW50IHNv
IEkgZG9uJ3Qga25vdyBpZg0KPiA+IGZ1dHVyZSBjb2RlDQo+ID4gd2lsbCBiZWhhdmUgdGhhdCB3
YXksIGJ1dCBwdWxsaW5nIGluIHRob3NlIGNvbnZlcnNpb24gcGF0Y2hlcyBpcw0KPiA+IGRlZmlu
aXRlbHkNCj4gPiB1bm5lY2Vzc2FyeSBkaWZmIHJpZ2h0IG5vdy4NCj4gDQo+IElmIHNvbWVvbmUg
d2FudHMgdG8gc2VuZCBtZSBhIGZ1bGwgc2V0IG9mIHRoZSBnaXQgaWRzIHRoYXQgbmVlZCB0byBi
ZQ0KPiBwdWxsZWQgaW4sIEkgd2lsbCBiZSBnbGFkIHRvIGRvIHNvLg0KPiANCj4gdGhhbmtzLA0K
PiANCj4gZ3JlZyBrLWgNCg0KLS0gDQpSZWdhcmRzLA0KQXRpc2gNCg==
