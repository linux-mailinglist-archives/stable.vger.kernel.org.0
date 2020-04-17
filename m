Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5EAA1AE037
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 16:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgDQOwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 10:52:06 -0400
Received: from mail-eopbgr1410112.outbound.protection.outlook.com ([40.107.141.112]:10668
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727850AbgDQOwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 10:52:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVdDPiuRLKT1gR8uL1mJ8ZgEcwMvpfUOA8UWi4/3z4jx4c8AagiGsuCzrt4volXpMg5fncJdFrLRT5HKjgcGyqBvwfcXTpJsrHKr9HL7g9NL8t5obP1zzf3MUwtcQqq9ZTbpe1FFvSYieRbkGiRH1hovSGnse/cvopsf08Ms0yDyfS9rNsl/dBcr2CJCwNanOsvQvc5isxBR6f5h0D1u8P3ly1M9/j4hk4V8aoDblMWWtbCwsE3jQT3HQTjQJ5udxgz42gq9V58UJD6V+BSWlmFS/diLn0Z1hQY0VC6iHeulzQ9BT1YfQ7kUroIwzXMTiQHcPPR865N3uv1wjUNtwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1fdMoDGB6F8qIilzAYbbvOc98a74UE7aYfSg0DBOSo=;
 b=nQ4WRVBwX0BO0QGjYeW2/jwiGls46BVyB6eVRMWaJCKiEbAbAjVKTQ5Pvv1nCNRi2vfxRvimZnoQI0IyFPiZR8wCAp6m+kid398UMOfxwGypQLVIZFmj3XAk8l/fX2QwWxde7UhpWlGnUYX/5zQnB6JQ/Iol/8A7G8/u5t83swsZn2mOGmpt2e4YLlVmLPbTSXDxsgFY/6gRHdUUC4ZINL4cGRi7I7grptdsGPcvYi3ODdrvgAVcdWdp0qyRN58Xvm4jtCxTn1+Nyuya5rufRaiS5+Ys1cDVq5z7lmKS0oWKm0ufFqtJaU1fMguT3Pwp+5NaXCkUsx5LWh8KtLJaCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1fdMoDGB6F8qIilzAYbbvOc98a74UE7aYfSg0DBOSo=;
 b=BNAFCp5yulmS82rkRLjdVhnolpYLMmqqwhHg78yx8fUe1hkefuA/Sl54n57GIssDtC6bCT7IkZXlQ90xgGs/oPTo0BiUCvcmBG+IUHELEFz30pTKWtOu2FHDmdemUlek8bfA82aPgzJ/J0QYX+DH/9Izc30CDMxcE/CADzblxdw=
Received: from OSBPR01MB2280.jpnprd01.prod.outlook.com (52.134.243.13) by
 OSBPR01MB5095.jpnprd01.prod.outlook.com (20.179.184.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.26; Fri, 17 Apr 2020 14:52:02 +0000
Received: from OSBPR01MB2280.jpnprd01.prod.outlook.com
 ([fe80::c9a6:9735:12fc:ae04]) by OSBPR01MB2280.jpnprd01.prod.outlook.com
 ([fe80::c9a6:9735:12fc:ae04%2]) with mapi id 15.20.2878.028; Fri, 17 Apr 2020
 14:52:02 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     =?utf-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>,
        Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        linux- stable <stable@vger.kernel.org>
Subject: RE: [PATCH 4.19 000/146] 4.19.116-rc1 review
Thread-Topic: [PATCH 4.19 000/146] 4.19.116-rc1 review
Thread-Index: AQHWE/IP8ULaCXtnbUepDpc5x6N8O6h9QXmAgAARcACAABIXkA==
Date:   Fri, 17 Apr 2020 14:52:02 +0000
Message-ID: <OSBPR01MB2280A113A45560747ECFE791B7D90@OSBPR01MB2280.jpnprd01.prod.outlook.com>
References: <20200416131242.353444678@linuxfoundation.org>
 <20200417123531.GA19028@duo.ucw.cz>
 <CAEUSe7-CBJsB6Kpsg52rjywN7jNeQRu4fU7tWSeJn0zF7xA2zQ@mail.gmail.com>
In-Reply-To: <CAEUSe7-CBJsB6Kpsg52rjywN7jNeQRu4fU7tWSeJn0zF7xA2zQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [151.224.220.27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0a0bfa58-ce89-4304-448f-08d7e2dee39c
x-ms-traffictypediagnostic: OSBPR01MB5095:
x-microsoft-antispam-prvs: <OSBPR01MB5095827A7889366A96C84789B7D90@OSBPR01MB5095.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0376ECF4DD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB2280.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(33656002)(54906003)(478600001)(186003)(81156014)(966005)(66574012)(71200400001)(8936002)(7696005)(6506007)(2906002)(26005)(110136005)(64756008)(55016002)(66946007)(8676002)(76116006)(86362001)(66446008)(66476007)(316002)(66556008)(9686003)(7416002)(5660300002)(4326008)(52536014);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LPiho8ekFM4GM8+IZ+82mSsVYeNS3+TWRCvjwREqt5txvV1j9AQBDr3NZyotG/8traqZ7p/aseJqX8wtomkpcUBAGBOotLNHU1WqPdGhPkHoARd5oAv7XubDpMDYDu4q6n71C0Jms3HKF/RIrfZzcxvnVP6N/ClkKj9ozuF8Dh4lk1fLZNcx4hmktV7whRPfr8RtUQE/t7YoveK4qoWsY3VicSupcnpcvQgQ9qOew3ah9mF+WeHZVvPi1ghUOPYJ2Wbej4JCzMo3SfQiPZ6eumMoab2BonukNzWwP/4A/RLtrn1o+3AGJrd4clISsDj6mHIUtz+AqeF1IcmymCe0R51KoyzItn+76Sj+M0I/nS9oglMZ+/ve3z78TCREi8NZqRdcknKwpWwgyCLkZaH18eMUNuAVKBUwsNHrOZNroSrAbp0dB67PVLMGTS2LLpeMznNMviWt+rD0K6S/epliD6Mjh9vCHRjuQEDaNaL6PmId2tQOR1rZHE3sMHVr6rFBr6Wqges/aj+JECUnTT9oGA==
x-ms-exchange-antispam-messagedata: U49MuHcBod+zKL2lZ4oX4gs8vK1EE3GhZJXq8fsgELX33MNvkaHPUtgdInyqVdlong31NH4GZfV4WUvLx6vbVobDWFtdga9LfM6xEDE7gE/D6GX/6gXlqIRzH6oAGDwK7XXed9uv+I1Fab/zmwHD6A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0bfa58-ce89-4304-448f-08d7e2dee39c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2020 14:52:02.3621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KTdXISOj1cEGsJcyxoB5c8dfovFehErXmiuqu+F8QhpocKnnttnYu1hjZp3eKNLlI0kCLecfopNg8iBxxvXAsn9QH+s5qq3oXlmvx88avQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB5095
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gUGF2ZWwsDQoNCj4gRnJvbTogRGFuaWVsIETDrWF6IDxkYW5pZWwuZGlhekBsaW5hcm8u
b3JnPg0KPiBTZW50OiAxNyBBcHJpbCAyMDIwIDE0OjM4DQo+IA0KPiBIZWxsbyENCj4gDQo+IE9u
IEZyaSwgMTcgQXByIDIwMjAgYXQgMDc6MzUsIFBhdmVsIE1hY2hlayA8cGF2ZWxAZGVueC5kZT4g
d3JvdGU6DQo+ID4NCj4gPiBIaSENCj4gPg0KPiA+ID4gVGhpcyBpcyB0aGUgc3RhcnQgb2YgdGhl
IHN0YWJsZSByZXZpZXcgY3ljbGUgZm9yIHRoZSA0LjE5LjExNiByZWxlYXNlLg0KPiA+ID4gVGhl
cmUgYXJlIDE0NiBwYXRjaGVzIGluIHRoaXMgc2VyaWVzLCBhbGwgd2lsbCBiZSBwb3N0ZWQgYXMg
YSByZXNwb25zZQ0KPiA+ID4gdG8gdGhpcyBvbmUuICBJZiBhbnlvbmUgaGFzIGFueSBpc3N1ZXMg
d2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UNCj4gPiA+IGxldCBtZSBrbm93Lg0KPiA+
ID4NCj4gPiA+IFJlc3BvbnNlcyBzaG91bGQgYmUgbWFkZSBieSBTYXQsIDE4IEFwciAyMDIwIDEz
OjExOjIwICswMDAwLg0KPiA+ID4gQW55dGhpbmcgcmVjZWl2ZWQgYWZ0ZXIgdGhhdCB0aW1lIG1p
Z2h0IGJlIHRvbyBsYXRlLg0KPiA+ID4NCj4gPiA+IFRoZSB3aG9sZSBwYXRjaCBzZXJpZXMgY2Fu
IGJlIGZvdW5kIGluIG9uZSBwYXRjaCBhdDoNCj4gPiA+ICAgICAgIGh0dHBzOi8vd3d3Lmtlcm5l
bC5vcmcvcHViL2xpbnV4L2tlcm5lbC92NC54L3N0YWJsZS1yZXZpZXcvcGF0Y2gtDQo+IDQuMTku
MTE2LXJjMS5neg0KPiA+ID4gb3IgaW4gdGhlIGdpdCB0cmVlIGFuZCBicmFuY2ggYXQ6DQo+ID4g
PiAgICAgICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvc3Rh
YmxlL2xpbnV4LXN0YWJsZS1yYy5naXQNCj4gbGludXgtNC4xOS55DQo+ID4gPiBhbmQgdGhlIGRp
ZmZzdGF0IGNhbiBiZSBmb3VuZCBiZWxvdy4NCj4gPg0KPiA+IENJUCBwcm9qZWN0IHJhbiB0ZXN0
cyBvbiB0aGlzIG9uZSwgYW5kIHdlIGhhdmUgZGUwLW5hbm8gZmFpbHVyZToNCj4gPg0KPiA+IGh0
dHBzOi8vZ2l0bGFiLmNvbS9jaXAtcHJvamVjdC9jaXAtdGVzdGluZy9saW51eC1zdGFibGUtcmMt
DQo+IGNpL3BpcGVsaW5lcy8xMzY3MDcwMjkNCj4gPg0KPiA+IERldGFpbGVkIHJlc3VsdHMgc2hv
dWxkIGJlIGF0Og0KPiA+DQo+ID4gaHR0cHM6Ly9sYXZhLmNpcGxhdGZvcm0ub3JnL3NjaGVkdWxl
ci9qb2IvMTQ3MTYNCj4gPiBodHRwczovL2xhdmEuY2lwbGF0Zm9ybS5vcmcvc2NoZWR1bGVyL2pv
Yi8xNDcxNw0KPiA+DQo+ID4gLi5idXQgdGhvc2UgcmVzdWx0cyBkbyBub3QgbG9hZCBmb3IgbWUg
KD8pLg0KPiANCj4gTG9va3MgbGlrZSB0aGUgZGV2aWNlIGZhaWxlZCBpdHMgaGVhbHRoIGpvYiBh
bmQgd2VudCBpbnRvIGJhZCBzdGF0ZS4NCj4gSm9icyBzdWJtaXR0ZWQgZm9yIHRoYXQgZGV2aWNl
IGFyZSBzdGlsbCBxdWV1ZWQsIGhlbmNlIHRoZSB0aW1lIG91dC4NCg0KRXhhY3RseSB0aGF0ICh0
aGFua3MgRGFuaWVsKS4NCg0KVGhlIGJvYXJkIGlzIG5vdyBiYWNrIG9ubGluZSBhbmQgdGhlIHN1
Ym1pdHRlZCBqb2JzIGhhdmUgcGFzc2VkLg0KDQpLaW5kIHJlZ2FyZHMsIENocmlzDQoNCj4gDQo+
IEdyZWV0aW5ncyENCj4gDQo+IERhbmllbCBEw61heg0KPiBkYW5pZWwuZGlhekBsaW5hcm8ub3Jn
DQo=
