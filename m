Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D87ED0BF7
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 11:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbfJIJ5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 05:57:47 -0400
Received: from mail-eopbgr1400134.outbound.protection.outlook.com ([40.107.140.134]:6122
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726765AbfJIJ5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 05:57:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHVbwUa5l2s0jMelA0y6rlRV3BKbeBp70NO4WsJpRK2PHmhrGjgX0MmBa03uYtpKuwLz+6O/tpP0r7fUIiRBxQXqTtu+SLmO9X4QpBhbKwEBxxtHyajgI1Wx9RRyD355yIOI8+V5YFQvwE3xZsDhS4yP9/I7qW/bkIMX21k0BNcKwHJACUGjXw4r2+lt77TATu5xlRqCq0a45CLdeYgtDpAJT8a+zzW/PS6fJiIkxw44plOYj1DGFFjYc6tlaRmvFIhZgc05oYB5KqtFaXvndllxHG5n0LSTzli6O1RCwezct0sFR2caJWYfXsPwv+9X0d4Q2RVrjghAzeggKgzSjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dc3G19ts4IwJyVkHJG3NPNl66rMX8fG84gjGBn96MCA=;
 b=EYLuqA+BpicjTQr8Vd486fmSRAn3BKGGEOa7Bdi8gwmKJS0QgTIGC/N5hqAj6UZOhqD2S7J8NVFNvn3KWYyMme3FczEuhZeuinM5TMO9vq0A8QgNoPbeh6HtFie3GQmBbvUSVez56uMFGl3dPAPRjo8bXEfifpImiQxiHZJ9Rw6E+BLJ9WW78k2lxP+3/6cQGLoiGkdlMZr71t3Y45/XOhR+X38GXZeNUQCaVV7/9p4pZMZWtB0rz1T1haB+eaTGP4DtJ4MqneVp3ftp2kseJjM+geojEWl2n2RbWEe9DfqW1mQqWpsNQMYIrRczuuKjPQ3Ec0sR+mMGubN26lWCNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dc3G19ts4IwJyVkHJG3NPNl66rMX8fG84gjGBn96MCA=;
 b=OKv2Ks1OwUu0BHLSxcenfUr/y7AAVVBNYS9I+HvE/G0VOfjtfZIf/U5iyUBhpnEOfJqdd/g5bRDTJWzRNLQOH7gmemUu8PALSZT/rbCBGc+Ko8SgQx/NIfP8xepWW1rXcZSBWmhaqaY573s3kgonKYk2gxgrvC7gPdcYO2UanUw=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB2256.jpnprd01.prod.outlook.com (52.133.178.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Wed, 9 Oct 2019 09:57:27 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947%4]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 09:57:27 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Simon Horman <horms@verge.net.au>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Marek Vasut <marek.vasut+renesas@gmail.com>
Subject: RE: [PATCH v2] PCI: rcar: Fix writing the MACCTLR register value
Thread-Topic: [PATCH v2] PCI: rcar: Fix writing the MACCTLR register value
Thread-Index: AQHVflZ5pjTfDr6TFku09vCbhMul/KdSAruAgAANPwA=
Date:   Wed, 9 Oct 2019 09:57:27 +0000
Message-ID: <TYAPR01MB454428DF53E58A034E9A5128D8950@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1570593791-6958-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <CAMuHMdV5N=JrVi3EwfFV4wgXo-xDQL0ptaqmauvzzQbDfWq+CQ@mail.gmail.com>
In-Reply-To: <CAMuHMdV5N=JrVi3EwfFV4wgXo-xDQL0ptaqmauvzzQbDfWq+CQ@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2a92241-2f33-4dd3-8a59-08d74c9f17bf
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: TYAPR01MB2256:
x-microsoft-antispam-prvs: <TYAPR01MB225630519A68409A7C677446D8950@TYAPR01MB2256.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:538;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(199004)(189003)(6116002)(6246003)(14454004)(3846002)(476003)(486006)(316002)(478600001)(54906003)(9686003)(4326008)(5660300002)(71190400001)(71200400001)(25786009)(52536014)(6506007)(66446008)(256004)(76116006)(55016002)(53546011)(33656002)(26005)(66476007)(7696005)(102836004)(66556008)(64756008)(186003)(66946007)(8936002)(8676002)(2906002)(76176011)(81156014)(81166006)(446003)(11346002)(74316002)(229853002)(66066001)(6436002)(6916009)(86362001)(305945005)(7736002)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB2256;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i+GErZ7zYVol6i1zCirJYydpSn9GvymVFK7V7sTneP+meSmTyftQqqM1eg0smhuQmgZpPClCocuZvEW1Qt0144aKWkMQ63N6489g7e1WFtP+l2EVc9A3nxbjZOCXkfiBlxujSgxBkni3gYFBbzKx5F8Y0lZQxxJwbdoYXXvb/uZBmGQQx6PEo+XTHgeFv/tgzLuya5ety7nrX/qmKGmruCTvsGdMTzzkwVMLYV5jT1WxJjXHtNVJcgVMeDDpmO89MhQltmINXgfr9U7ko7t8UC/jwbltzhiAykJRv2XaPIBZq31fBrZdBUT6nSna/+Wewk3QhiVhjDobANrI0rRQOt9yUAMRZnpzpc0Yvevu0PgAvBFbqomEeDwLs/PjOonHWNKFrudtw6aw9ThJCV1NPIZk+OrPdoz2FFOTA/tvCIQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a92241-2f33-4dd3-8a59-08d74c9f17bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 09:57:27.4656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nikNkcf1/B57hSilN0ghzDiOlkbS+o1cenqlusKpxCd0aBi+UG5KqbfgJnFOGPAsl+CXZj12OU8oBithcdFSXxvzGsh7WO1+YbCfFt5RWUU0qqRdTNnrNt6e5Z+nvGWa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2256
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR2VlcnQtc2FuLg0KDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogV2VkbmVz
ZGF5LCBPY3RvYmVyIDksIDIwMTkgNTo1OCBQTQ0KPiANCj4gSGkgU2hpbW9kYS1zYW4sDQo+IA0K
PiBPbiBXZWQsIE9jdCA5LCAyMDE5IGF0IDY6MDMgQU0gWW9zaGloaXJvIFNoaW1vZGENCj4gPHlv
c2hpaGlyby5zaGltb2RhLnVoQHJlbmVzYXMuY29tPiB3cm90ZToNCj4gPiBBY2NvcmRpbmcgdG8g
dGhlIFItQ2FyIEdlbjIvMyBtYW51YWwsIHRoZSBiaXQgMCBvZiBNQUNDVExSIHJlZ2lzdGVyDQo+
ID4gc2hvdWxkIGJlIHdyaXR0ZW4gdG8gMCBiZWNhdXNlIHRoZSByZWdpc3RlciBpcyBzZXQgdG8g
MSBvbiByZXNldC4NCj4gPiBUbyBhdm9pZCB1bmV4cGVjdGVkIGJlaGF2aW9ycyBmcm9tIHRoaXMg
aW5jb3JyZWN0IHNldHRpbmcsIHRoaXMNCj4gPiBwYXRjaCBmaXhlcyBpdC4NCj4gPg0KPiA+IEZp
eGVzOiBiMzMyN2Y3ZmFlNjYgKCJQQ0k6IHJjYXI6IFRyeSBpbmNyZWFzaW5nIFBDSWUgbGluayBz
cGVlZCB0byA1IEdUL3MgYXQgYm9vdCIpDQo+ID4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3Jn
PiAjIHY0LjkrDQo+ID4gU2lnbmVkLW9mZi1ieTogWW9zaGloaXJvIFNoaW1vZGEgPHlvc2hpaGly
by5zaGltb2RhLnVoQHJlbmVzYXMuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBTZXJnZWkgU2h0eWx5
b3YgPHNlcmdlaS5zaHR5bHlvdkBjb2dlbnRlbWJlZGRlZC5jb20+DQo+IA0KPiBUaGFua3MgZm9y
IHlvdXIgcGF0Y2ghDQo+IA0KPiBUaGlzIHBhdGNoIGZpeGVzIHRoZSBpc3N1ZSB3aGVyZSB0aGUg
cmVnaXN0ZXIgaXMgd3JpdHRlbiwgc28NCj4gUmV2aWV3ZWQtYnk6IEdlZXJ0IFV5dHRlcmhvZXZl
biA8Z2VlcnQrcmVuZXNhc0BnbGlkZXIuYmU+DQoNClRoYW5rIHlvdSBmb3IgeW91ciByZXZpZXch
DQoNCj4gSG93ZXZlciwgYWNjb3JkaW5nIHRvIHRoZSBSLUNhciBIMSwgR2VuMiwgYW5kIEdlbjMg
SGFyZHdhcmUgVXNlcidzDQo+IE1hbnVhbHMsIHRoaXMgcmVzZXJ2ZWQgYml0IHNob3VsZCBiZSBj
bGVhcmVkIG9uIGluaXRpYWxpemF0aW9uLg0KPiBBcmUgd2Ugc3VyZSB0aGF0IGlzIGd1YXJhbnRl
ZWQgdG8gaGFwcGVuPyBJZiB0aGUgY2hlY2tzIGF0IHRoZSB0b3Agb2YNCj4gcmNhcl9wY2llX2Zv
cmNlX3NwZWVkdXAoKSB0cmlnZ2VyLCB0aGUgcmVnaXN0ZXIgaXMgbmV2ZXIgd3JpdHRlbiB0bywN
Cj4gYW5kIHRoZSBiaXQgbWF5IHN0aWxsIGJlIHNldD8NCg0KVGhhbmsgeW91IGZvciB0aGUgcG9p
bnRlZCBpdCBvdXQhIEFzIHlvdSBzYWlkLCB0aGlzIGRyaXZlciBzaG91bGQgc2V0DQp0aGUgYml0
IDAgb2YgcmVnaXN0ZXIgb24gcmNhcl9wY2llX2h3X2luaXQoKSwgbm90IHJjYXJfcGNpZV9mb3Jj
ZV9zcGVlZHVwKCkuDQpJIGNoZWNrZWQgdGhhdCB0aGUgYml0IDB0IG9mIHJlZ2lzdGVyIGtlZXAg
dG8gYmUgMCBhZnRlciB0aGUgZHJpdmVyDQpjbGVhcmVkIHRoZSBiaXQuIFNvLCBjbGVhcmluZyB0
aGUgYml0IDAgb24gcmNhcl9wY2llX2h3X2luaXQoKSBvbmx5DQppcyBlbm91Z2gsIEkgdGhpbmsu
IFNvLCBJJ2xsIHNlbmQgdjMgcGF0Y2guDQoNCkJlc3QgcmVnYXJkcywNCllvc2hpaGlybyBTaGlt
b2RhDQoNCg0KPiBHcntvZXRqZSxlZXRpbmd9cywNCj4gDQo+ICAgICAgICAgICAgICAgICAgICAg
ICAgIEdlZXJ0DQo+IA0KPiAtLQ0KPiBHZWVydCBVeXR0ZXJob2V2ZW4gLS0gVGhlcmUncyBsb3Rz
IG9mIExpbnV4IGJleW9uZCBpYTMyIC0tIGdlZXJ0QGxpbnV4LW02OGsub3JnDQo+IA0KPiBJbiBw
ZXJzb25hbCBjb252ZXJzYXRpb25zIHdpdGggdGVjaG5pY2FsIHBlb3BsZSwgSSBjYWxsIG15c2Vs
ZiBhIGhhY2tlci4gQnV0DQo+IHdoZW4gSSdtIHRhbGtpbmcgdG8gam91cm5hbGlzdHMgSSBqdXN0
IHNheSAicHJvZ3JhbW1lciIgb3Igc29tZXRoaW5nIGxpa2UgdGhhdC4NCj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAtLSBMaW51cyBUb3J2YWxkcw0K
