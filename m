Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF75D3881
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 06:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfJKEdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 00:33:33 -0400
Received: from mail-eopbgr1400091.outbound.protection.outlook.com ([40.107.140.91]:34659
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbfJKEdc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 00:33:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hzpz50km6IO+RBqGHAC43vSwUx/fqJrcTCEYsT1DK3M7LAWx6uc0qHLXa3S4/HIewydn82AWhgrzZGrvWnkf+9DRbJ3wWWoazS/km2eav90aUDawe80GiqLp49enrizeqhVgG/4JFXQ4o4MvOzRSx17GOS6lQ68lEs5NrBvJEe6NJo/KnBye4AG2AA9ssjwq/p6b8JvJAhRXjK9q3Kn4N3+0ki6mUqTJaiQvb7g9wcEmbH+0THspQ/K05ybh+aTGkR4QBlo0PFhNMSL4HqLvcHb9ii0a16EtlaylfQC57D0VILfOO5m8OerTOmt/tP4GVyefvyZwMGpY+X4RZ5Cn3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAIcWsdgm2Sz/TdbgleiReEVlpOHSpDWur+/J04h9T4=;
 b=LixeM+9MVPB+C2M8w/GiN/SBBntQ/hevNDNmQ1pu7O4PetaaBDlTmc2CUp7nfK23UK3ljciMOWaGJ5lG0IVWb8qGXl7VvxLobHWK+6MSpnPzFYVW0oSWYevlSzbJ9Vs3uf2WntpRTXsDiWnWe6UjDfK3tClE2fElSI5n5IRai6dhWouTCb3LZ/+102NQW7G/mwXIajajDnEhMdcTFzpIoOs9XKlrKvCuMSHX3ujc9Tx43/+LohvlcROreBQu1DDw41VfcRCTq/tTMpb7G8M4pfnqNpnekMhWuPTtVjvttEOhanU66kyIvZy2qgJX+I8REmzm/TK34MNoU4vk2WvNOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAIcWsdgm2Sz/TdbgleiReEVlpOHSpDWur+/J04h9T4=;
 b=oUw30EK/k7VBbcmA4NtEsrE0kUScZ5j5qlUFx50cki+fbqGkpgh0iyriNzqp8LUxiW3/Pbe0SfZWjcWZmBi/EPqXNJo9AaHOsdu1AZyXb8rNS2DAjnj70qxoDXOgqxYcXSp4099J/AykUJbxfB6J1Vx9BvQuYVR4EZu4TnENcyM=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB4255.jpnprd01.prod.outlook.com (20.178.140.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 11 Oct 2019 04:33:29 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947%4]) with mapi id 15.20.2347.016; Fri, 11 Oct 2019
 04:33:29 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Simon Horman <horms@verge.net.au>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: RE: [PATCH v3] PCI: rcar: Fix missing MACCTLR register setting in
 rcar_pcie_hw_init()
Thread-Topic: [PATCH v3] PCI: rcar: Fix missing MACCTLR register setting in
 rcar_pcie_hw_init()
Thread-Index: AQHVfpFdRHmeqz22zkmqv5PYLRrv/KdSLNIAgAKv07A=
Date:   Fri, 11 Oct 2019 04:33:29 +0000
Message-ID: <TYAPR01MB4544C2196B87E0D4A38C347BD8970@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1570619086-30088-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <CAMuHMdWpxCwOL4Ewd_CQOMMXq9vKQ0zJCW0A0ume_XtsdEtwJA@mail.gmail.com>
In-Reply-To: <CAMuHMdWpxCwOL4Ewd_CQOMMXq9vKQ0zJCW0A0ume_XtsdEtwJA@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1122bac9-870b-4488-4db9-08d74e042aa0
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: TYAPR01MB4255:
x-microsoft-antispam-prvs: <TYAPR01MB4255A4893262E909FC766BCAD8970@TYAPR01MB4255.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(199004)(189003)(6436002)(102836004)(8676002)(53546011)(186003)(7736002)(2906002)(55016002)(99286004)(25786009)(6506007)(305945005)(81156014)(81166006)(74316002)(33656002)(14444005)(476003)(26005)(66066001)(76176011)(3846002)(7696005)(54906003)(86362001)(6116002)(256004)(229853002)(9686003)(486006)(6916009)(316002)(6246003)(4326008)(52536014)(5660300002)(71190400001)(64756008)(66476007)(71200400001)(14454004)(446003)(11346002)(478600001)(8936002)(76116006)(66446008)(66946007)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB4255;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z2bpnce9a1Irqqnq6AeWFuMWn6x8ccgs4o9lPRdK/qN3jeO+0wTF+SaahQAmeRT2aPFXA4C+1kIw72f/HyaXcYiUU8OD/xYvx5vYa7A2tgXKnuq0EMvAqrsjr4q4U/JJyDqeZyrf21L68pzXR6ec7zrIXZWGV1cnmwcNjObuiLG2zSLth6q4gyDH/ziv2UcGhEkoMX0P7G8N+AJ0fdloEF/wqdJ4Mg4Cbp2DCWQqCOpZ7F3PVak3P8HGHjZRN8ozzj+OAajriIOmoAo7sfyIdbHuKtUWGBymWxjndnxUR87OkTjus3Xbb3x13iUn67q2hwEdUTjA25uiPIIqnJJEoZzF618BhcWWVqHpI+LyZMX5qbjh0xqOF0c8P3OAkM7pq2j5ZvQgJesG3RV6aJNLjEFzrrzpCSzyifOMXsIW4qQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1122bac9-870b-4488-4db9-08d74e042aa0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 04:33:29.6749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Iq1M4K9QkFQ0Kfu2cOq1CJ+gQ4NuRZrWpLEq8lz1KCKZmlFjWGquKKT/wsVuX28TLkQ2ASft79e2Z6RYMLc4cWYa6tk80lD2rI99HpeR6fJTPEh5K5cqoHh5qN5tlDgX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4255
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR2VlcnQtc2FuLA0KDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogV2VkbmVz
ZGF5LCBPY3RvYmVyIDksIDIwMTkgODozMSBQTQ0KPiANCj4gSGkgU2hpbW9kYS1zYW4sDQo+IA0K
PiBPbiBXZWQsIE9jdCA5LCAyMDE5IGF0IDE6MDUgUE0gWW9zaGloaXJvIFNoaW1vZGENCj4gPHlv
c2hpaGlyby5zaGltb2RhLnVoQHJlbmVzYXMuY29tPiB3cm90ZToNCjxzbmlwPg0KPiA+IEBAIC02
MTUsNiArNjE2LDggQEAgc3RhdGljIGludCByY2FyX3BjaWVfaHdfaW5pdChzdHJ1Y3QgcmNhcl9w
Y2llICpwY2llKQ0KPiA+ICAgICAgICAgaWYgKElTX0VOQUJMRUQoQ09ORklHX1BDSV9NU0kpKQ0K
PiA+ICAgICAgICAgICAgICAgICByY2FyX3BjaV93cml0ZV9yZWcocGNpZSwgMHg4MDFmMDAwMCwg
UENJRU1TSVRYUik7DQo+ID4NCj4gPiArICAgICAgIHJjYXJfcm13MzIocGNpZSwgTUFDQ1RMUiwg
TUFDQ1RMUl9SRVNFUlZFRCwgMCk7DQo+ID4gKw0KPiA+ICAgICAgICAgLyogRmluaXNoIGluaXRp
YWxpemF0aW9uIC0gZXN0YWJsaXNoIGEgUENJIEV4cHJlc3MgbGluayAqLw0KPiA+ICAgICAgICAg
cmNhcl9wY2lfd3JpdGVfcmVnKHBjaWUsIENGSU5JVCwgUENJRVRDVExSKTsNCj4gDQo+IEkgZ3Vl
c3MgdGhlIHNhbWUgc2hvdWxkIGJlIGFkZGVkIHRvIHJjYXJfcGNpZV9yZXN1bWVfbm9pcnEoKSwN
Cj4gYXMgczJyYW0gb24gUi1DYXIgR2VuMyBwb3dlcnMgZG93biB0aGUgU29DPw0KDQpUaGFuayB5
b3UgZm9yIHRoZSBwb2ludGVkIGl0IG91dCEgWW91J3JlIGNvcnJlY3QuIFNvLCBJJ2xsIHVwZGF0
ZQ0KdGhlIHBhdGNoLg0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hpbW9kYQ0KDQo+IEdy
e29ldGplLGVldGluZ31zLA0KPiANCj4gICAgICAgICAgICAgICAgICAgICAgICAgR2VlcnQNCj4g
DQo+IC0tDQo+IEdlZXJ0IFV5dHRlcmhvZXZlbiAtLSBUaGVyZSdzIGxvdHMgb2YgTGludXggYmV5
b25kIGlhMzIgLS0gZ2VlcnRAbGludXgtbTY4ay5vcmcNCj4gDQo+IEluIHBlcnNvbmFsIGNvbnZl
cnNhdGlvbnMgd2l0aCB0ZWNobmljYWwgcGVvcGxlLCBJIGNhbGwgbXlzZWxmIGEgaGFja2VyLiBC
dXQNCj4gd2hlbiBJJ20gdGFsa2luZyB0byBqb3VybmFsaXN0cyBJIGp1c3Qgc2F5ICJwcm9ncmFt
bWVyIiBvciBzb21ldGhpbmcgbGlrZSB0aGF0Lg0KPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIC0tIExpbnVzIFRvcnZhbGRzDQo=
