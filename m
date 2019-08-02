Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35FE47F5AE
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 13:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392272AbfHBLDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 07:03:19 -0400
Received: from mail-eopbgr40124.outbound.protection.outlook.com ([40.107.4.124]:61829
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729311AbfHBLDT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 07:03:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=beolhqq434iEcZuvYtKxGVBMJQr/7FMBHfb9Fire2ZFTMLoObmdX3J1zZSwWPx0daq1VSdQQ+5H6/hxDIp3+udV6LjH1SifRnhkfzGUgHuZcvyGz8h2FCD36ihOs122n6xgPw32ufum2/O0RmYEkljBzW9+Ad9B5w81oyjomriG7hnT8M0I+h9c6muGo91KDf01kKbBaiFvUj6xGwTtpeMkqUi+4kyXlCjC1HaWsMZRicDsTqF8S3xuhi7aftobSdZ0iP/COG6AiUVSmtPHMB8QhVy2XZ6JoRzv69q0lmvLxPcVDBNM0Sf86J0zn5UnuO/83zffxxgiMtFvPN6lCFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3Wvn93P2G2RxATzXAkQFRuzQWQXzzhf8Ip15GzXj6s=;
 b=iXdsV35pAY7x2O8DRyQhV/mKvo0sOERPiuni73QX6rGGXchjcQyuDLtQa7SzNbb2nST/JoXp+SGo0Z4UjaExAkZ7+Mf1b8m/lGysRzD2qHf3KSdpa+O5OclCDseREpQkib7USsVbsL/RdBlt6kguZCcV7pNvpJomKg39fX3J5i/hwUaaQ7p6hNQBt/BDoPntwrojX+jr1lu+GdfwHeq4S9fHjVFIJuDxh+m14g3wxz7QDoHThhV67yCSTRY03RgdWi6DQqvB1LM/a3oA1Nv6eeEuIwQ74gb0YMgsxYeqccRS8y/VVzDSLQsFbHTVIvTP7/PTU0CLJ/uX0V1RnjW5ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nokia.com;dmarc=pass action=none
 header.from=nokia.com;dkim=pass header.d=nokia.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3Wvn93P2G2RxATzXAkQFRuzQWQXzzhf8Ip15GzXj6s=;
 b=Vxg/Q6NTCI6LmKum1KpYW6FL7HOf9BXoFfwL+C/qUtZfQ3yRc4k9ILugAPvzqVexBgAV7krDpZtZKaWtwtnVPY1mvAP47aI70OkgcRVNqBZFEJqjTtm2e4kz+74LRNBPlnD39guhMwXlw6cmN/bV3PmOg7X/dS3T2jQ6twCMUBY=
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com (52.133.6.141) by
 HE1PR0702MB3772.eurprd07.prod.outlook.com (52.133.7.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.10; Fri, 2 Aug 2019 11:03:15 +0000
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::d90c:c96:8d6a:362d]) by HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::d90c:c96:8d6a:362d%6]) with mapi id 15.20.2157.001; Fri, 2 Aug 2019
 11:03:15 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "lucien.xin@gmail.com" <lucien.xin@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "syzbot+a43d8d4e7e8a7a9e149e@syzkaller.appspotmail.com" 
        <syzbot+a43d8d4e7e8a7a9e149e@syzkaller.appspotmail.com>,
        "syzbot+c4c4b2bb358bb936ad7e@syzkaller.appspotmail.com" 
        <syzbot+c4c4b2bb358bb936ad7e@syzkaller.appspotmail.com>,
        "syzbot+a47c5f4c6c00fc1ed16e@syzkaller.appspotmail.com" 
        <syzbot+a47c5f4c6c00fc1ed16e@syzkaller.appspotmail.com>,
        "syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com" 
        <syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzbot+0290d2290a607e035ba1@syzkaller.appspotmail.com" 
        <syzbot+0290d2290a607e035ba1@syzkaller.appspotmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+9d4c12bfd45a58738d0a@syzkaller.appspotmail.com" 
        <syzbot+9d4c12bfd45a58738d0a@syzkaller.appspotmail.com>
Subject: Re: [PATCH 4.14 43/43] tipc: pass tunnel dev as NULL to
 udp_tunnel(6)_xmit_skb
Thread-Topic: [PATCH 4.14 43/43] tipc: pass tunnel dev as NULL to
 udp_tunnel(6)_xmit_skb
Thread-Index: AQHVMK2k4G4Q5DhZpEC+QWpFsSOawKbmQ0kAgAFjJACAADv5gA==
Date:   Fri, 2 Aug 2019 11:03:15 +0000
Message-ID: <88c88ec44e93c07170891bdf391d2b6251c7041a.camel@nokia.com>
References: <20190702080123.904399496@linuxfoundation.org>
         <20190702080126.138655706@linuxfoundation.org>
         <0f105a3696611dc10aa4d7c5c22ffac031b3c098.camel@nokia.com>
         <20190802072834.GC26174@kroah.com>
In-Reply-To: <20190802072834.GC26174@kroah.com>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tommi.t.rantala@nokia.com; 
x-originating-ip: [131.228.2.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb455002-29c2-445b-f47c-08d7173904ae
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:HE1PR0702MB3772;
x-ms-traffictypediagnostic: HE1PR0702MB3772:
x-microsoft-antispam-prvs: <HE1PR0702MB3772765DB81074B1AC6ECCFDB4D90@HE1PR0702MB3772.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(199004)(189003)(4744005)(66476007)(66556008)(64756008)(26005)(66446008)(71200400001)(71190400001)(76116006)(305945005)(68736007)(99286004)(66946007)(6116002)(8936002)(86362001)(446003)(3846002)(7736002)(11346002)(7416002)(476003)(2616005)(25786009)(36756003)(186003)(229853002)(8676002)(6486002)(316002)(486006)(2351001)(118296001)(4326008)(6436002)(256004)(6916009)(5640700003)(54906003)(1730700003)(81166006)(81156014)(6246003)(102836004)(6512007)(2906002)(53936002)(478600001)(6506007)(14454004)(2501003)(66066001)(76176011)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3772;H:HE1PR0702MB3675.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: f38mZP0OfrQGCfZuxL5zKerU1wFqtE+IKOX9dtf81//fVL6jTgbrNagfiWTF7wB3cY+uqaJnU6q5rTbkcwbPeoUdjDGodhaeDTznqbqi6P0UHUA1ww+xcwmqylQXhvp625fVLS6T7pKdz7rtrrCD8KnSNBTqfgplQElDP4tkK0w+LII0EHSQpbnYmM8vQ5MUxaX4V6iPWAZ5upXXSqM5Qo/uhyH6oyxEOEi9t/U2Ph6udgdOKE+gSym7eDmxZNAVrdf0RltHEB5PLtg3Ysjyl4p79luGQlcEmq9gzBv6ZXI21Iqzbn7wN99GCzavL1h4pzNnCpAOqU9yVdfgAjW+xsWf1r2nxl3SoW0tpELS1mHzNaek474NIkG3aymmN1kVRtbBuoQKsYkrrXXHOTFJQxl1C/pUy/7BDk6g7nx70T8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8A2C05A4250FF43B957BB76450D3871@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb455002-29c2-445b-f47c-08d7173904ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 11:03:15.3834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OWYrgl4djVM5uuvwUed73FbFgpomrAMWczDRcTBO9rTZbrzNYFk5hxeAaQnCKjDXQI4iCqZA1J45pAWGd1z7ftpp6QvReuFSfALZ/BhP1kc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3772
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDE5LTA4LTAyIGF0IDA5OjI4ICswMjAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gT24gVGh1LCBBdWcgMDEsIDIwMTkgYXQgMTA6MTc6MzBBTSArMDAwMCwg
UmFudGFsYSwgVG9tbWkgVC4gKE5va2lhIC0NCj4gRkkvRXNwb28pIHdyb3RlOg0KPiA+IEhpLA0K
PiA+IA0KPiA+IFRoaXMgdGlwYyBwYXRjaCBhZGRlZCBpbiA0LjE0LjEzMiBpcyB0cmlnZ2VyaW5n
IGEgY3Jhc2ggZm9yIG1lLA0KPiA+IHJldmVydA0KPiA+IGZpeGVzIGl0Lg0KPiA+IA0KPiA+IEFu
eW9uZSBoYXZlIGlkZWFzIGlmIHNvbWUgb3RoZXIgY29tbWl0cyBtaXNzaW5nIGluIDQuMTQueCB0
byBtYWtlDQo+ID4gdGhpcw0KPiA+IHdvcmsuLi4/DQo+IA0KPiBEbyB5b3UgYWxzbyBoYXYgYSBw
cm9ibGVtIHdpdGggNC4xOS55PyAgSG93IGFib3V0IDUuMi55PyAgSWYgbm90LCBjYW4NCj4geW91
IGRvICdnaXQgYmlzZWN0JyB0byBmaW5kIHRoZSBwYXRjaCB0aGF0IGZpeGVzIHRoZSBpc3N1ZT8N
Cj4gDQo+IHRoYW5rcywNCj4gDQo+IGdyZWcgay1oDQoNCkhpLCBwbGVhc2UgcGljayB0aGlzIHRv
IDQuMTQueSBhbmQgNC4xOS55LCB0ZXN0ZWQgdGhhdCBpdCBmaXhlcyB0aGUNCmNyYXNoIGluIGJv
dGg6DQoNCmNvbW1pdCA1Njg0YWJmNzAyMGRmYzVmMGI2YmExZDY4ZWRhMzY2Mzg3MWZjZTUyDQpB
dXRob3I6IFhpbiBMb25nIDxsdWNpZW4ueGluQGdtYWlsLmNvbT4NCkRhdGU6ICAgTW9uIEp1biAx
NyAyMTozNDoxMyAyMDE5ICswODAwDQoNCiAgICBpcF90dW5uZWw6IGFsbG93IG5vdCB0byBjb3Vu
dCBwa3RzIG9uIHRzdGF0cyBieSBzZXR0aW5nIHNrYidzIGRldg0KdG8gTlVMTA0KDQoNCkZvciA1
LjIueSBub3RoaW5nIGlzIG5lZWRlZCwgdGhlc2UgY29tbWl0cyB3ZXJlIGluIHY1LjItcmM2IGFs
cmVhZHkuDQoNCi1Ub21taQ0KDQo=
