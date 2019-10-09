Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0850ED0A52
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 10:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfJIIyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 04:54:36 -0400
Received: from mail-eopbgr1400109.outbound.protection.outlook.com ([40.107.140.109]:31684
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725903AbfJIIyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 04:54:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOwZ6SQZIab/ZQwE2IhMiSOCGw3VFmZrQcXp3ApEY12O4RDZKXo7m+rX3bO7OjswkX6ZlSY2EVr/PMdnzON9m9DriKU59P9RUaKv3Q57wrClGOkM9lnhAqd/sY9fxezzrlym4ch9/O5p0e5lXxYE64AWGXETkDzSc9o2Ooi1Wb3x5VsmeSo+0Rdbij8GCsb+UqiVBNgMPJfM2uhKbcS+ikq7Q62g6O7fu1Jf+8vGRH1HwYXd7fXZltWvHIT2Rx/JxW+xoKUtoEz/UcWf9uO+oXEU7kzS40Kw0IONEHePFCenDxjcEfkldWG75iZPnWossy1cfIjCW38mb9lCRy9wQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fowgbbffj7wXXOv7cDcsf0I79i/sR3n9mRvkrTsmc1I=;
 b=nxuDV6Fg8KtQ5s4FYZLqbScyZyNqsRYRjJ1eAP8wDKrHi1VvQcf5Bv7VbsLqf/oIYESBzkyJYAVavjWfvkMhwhVj+0QSJKjPeu2q84GofwH69Ulr0tiIhdBtXInox2oMNwm2kfa+eTl0Mv3n25BwYRyTQUkOWvwTUqnemjqcz+BEYV6uSMfVv96bCWdzJwbmIjHqzmXwSrshdWZAjGWDd1egtwNdtTl0bWZKinwE+0jzBZ77KGSFohtmGNnTrXh/56wRcwlif+8yhNLuQlmRimVOomy8slqEbTn1rRx081veQOaz8QYiIu/mEY6nlvXItMmWzNw0EKX4VB37irozDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fowgbbffj7wXXOv7cDcsf0I79i/sR3n9mRvkrTsmc1I=;
 b=jWqikyDdA7CrsCm7plY91bLDnrq08YfgxxA34JjZv4V+xKWn/OrrsZ3dMYUJXTGR/je/RJ5FovX7QNBCmvyFRcuMBRG/6hAyPoPrE4tsp06KczE4zdYdAifLaR/h181B4eVatGOGQyqplhf1h7pqHNEelnaSe/3fR91zWKsBMwU=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB3567.jpnprd01.prod.outlook.com (20.178.137.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 08:54:32 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947%4]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 08:54:32 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC:     "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] PCI: rcar: Fix writing the MACCTLR register value
Thread-Topic: [PATCH v2] PCI: rcar: Fix writing the MACCTLR register value
Thread-Index: AQHVflZ5pjTfDr6TFku09vCbhMul/KdSABuAgAAA8CA=
Date:   Wed, 9 Oct 2019 08:54:32 +0000
Message-ID: <TYAPR01MB4544EABC75926292D3D80C0AD8950@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1570593791-6958-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <2b0f09cd-323d-864d-09df-40d431693f19@cogentembedded.com>
In-Reply-To: <2b0f09cd-323d-864d-09df-40d431693f19@cogentembedded.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cba1489-2d1a-4e63-e569-08d74c964d9b
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: TYAPR01MB3567:
x-microsoft-antispam-prvs: <TYAPR01MB35676988D742FF87B30467C8D8950@TYAPR01MB3567.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(39860400002)(136003)(366004)(346002)(189003)(199004)(8936002)(55016002)(6436002)(102836004)(6506007)(11346002)(476003)(486006)(446003)(256004)(7696005)(99286004)(4326008)(6246003)(76176011)(8676002)(9686003)(81156014)(66066001)(316002)(81166006)(110136005)(54906003)(25786009)(478600001)(66476007)(66946007)(66446008)(64756008)(66556008)(53546011)(52536014)(305945005)(76116006)(2906002)(5660300002)(186003)(33656002)(86362001)(6116002)(26005)(229853002)(2201001)(2501003)(71200400001)(71190400001)(14454004)(74316002)(4744005)(3846002)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3567;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IIeFCewxLXvCmU+Fjgg2B4F4EB16z7aeGMb71gNBG895kijAuZ3Pbr5mlvnPb3R1oFu1ehYp9G9WWdqsvMxGz1o2lWND40bPUdjxIOqD5mEyoh51Qqbqw/e/YeoYRPKiKuDHvwp2pD35lhWUF4GmBqG/zmUXKexm016xhGV9ARHL/J8DNOtB/Hr7Mrq4RaOARxsWx2KJWC5sc99aQAAAWRsMiZvud9zGMUXE/mW1SzeHdratLF/PGQKsaBEn0zX29hUCgw0VybPV32ExTZz+nI3F5prKuAnXkNIl0iJK49wlChxzeyt1YFwZ7vdCW/Bp3/+ruYvoddSRyNbvpYVtfozz4adxHmoBfI8k6FVXGvaL57phySx0GDaMroQE2hNQ6WG4yRGjC3Z6DALtVE9DdmIoumjpfvpqsl0pHGX1f5w=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cba1489-2d1a-4e63-e569-08d74c964d9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 08:54:32.5573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DaoDIx9jowsv/MAHfefsytsJodeked3NDo0C3vS4lnvAsv/yC9dNN3NoPqORmQ2JjzU2c1scpfYaDwyc97xf/1wFPzkzeoHURB4yCMc9FwjGErQo1MouybkA/sKnQJgf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3567
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgU2VyZ2VpLXNhbiwNCg0KPiBGcm9tOiBTZXJnZWkgU2h0eWx5b3YsIFNlbnQ6IFdlZG5lc2Rh
eSwgT2N0b2JlciA5LCAyMDE5IDU6NDkgUE0NCj4gDQo+IE9uIDA5LjEwLjIwMTkgNzowMywgWW9z
aGloaXJvIFNoaW1vZGEgd3JvdGU6DQo+IA0KPiA+IEFjY29yZGluZyB0byB0aGUgUi1DYXIgR2Vu
Mi8zIG1hbnVhbCwgdGhlIGJpdCAwIG9mIE1BQ0NUTFIgcmVnaXN0ZXINCj4gPiBzaG91bGQgYmUg
d3JpdHRlbiB0byAwIGJlY2F1c2UgdGhlIHJlZ2lzdGVyIGlzIHNldCB0byAxIG9uIHJlc2V0Lg0K
PiANCj4gICAgIFRoZSBiaXQgMCBzZXQgdG8gMSwgbm90IHRoZSB3aG9sZSByZWdpc3RlciAoaXQg
aGFzIDFzIGFsc28gaW4gdGhlDQo+IGJpdHMgMTYtMjMpLg0KDQpUaGFuayB5b3UgZm9yIHRoZSBj
b21tZW50LiBTbywgSSdsbCBmaXggdGhlIGNvbW1pdCBsb2cgYXMgZm9sbG93aW5nLg0KSXMgaXQg
YWNjZXB0YWJsZT8NCg0KLS0tDQpBY2NvcmRpbmcgdG8gdGhlIFItQ2FyIEdlbjIvMyBtYW51YWws
IHRoZSBiaXQgMCBvZiBNQUNDVExSIHJlZ2lzdGVyDQpzaG91bGQgYmUgd3JpdHRlbiB0byAwIGJl
Y2F1c2UgdGhlIGJpdCAwIGlzIHNldCB0byAxIG9uIHJlc2V0Lg0KVG8gYXZvaWQgdW5leHBlY3Rl
ZCBiZWhhdmlvcnMgZnJvbSB0aGlzIGluY29ycmVjdCBzZXR0aW5nLCB0aGlzDQpwYXRjaCBmaXhl
cyBpdC4NCi0tLQ0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hpbW9kYQ0KDQo=
