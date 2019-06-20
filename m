Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDF234DD1A
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 23:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfFTVyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 17:54:12 -0400
Received: from mail-eopbgr770137.outbound.protection.outlook.com ([40.107.77.137]:33199
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726002AbfFTVyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 17:54:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mg6LQlRUVs1Ph4+1270epZhz28gtsLSnMAgnGMSyj/I=;
 b=XJBLTS+qFmRH78Tq4ix3uie3PpvD5WTE4T/JWvXPO+WVgNU3zB2k67FQlZAFAHiLjqbcGcTYjiq20UkSkWyFAcHB1rCuFRcEaJSXKNn+BTUe62/ExzRQnRTz6PfJubEjj4fqRQgI3/JK94kIl0ndVdXsCHrlpsjZ4IDyT/JXn/s=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1423.namprd22.prod.outlook.com (10.172.63.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 20 Jun 2019 21:54:10 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40%2]) with mapi id 15.20.2008.007; Thu, 20 Jun 2019
 21:54:10 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Cedric Hombourger <Cedric_Hombourger@mentor.com>
CC:     Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH] MIPS: have "plain" make calls build dtbs for selected
  platforms
Thread-Topic: [PATCH] MIPS: have "plain" make calls build dtbs for selected
  platforms
Thread-Index: AQHVJ7KwLVsZO8gtyUWWMLZV//6qfw==
Date:   Thu, 20 Jun 2019 21:54:10 +0000
Message-ID: <MWHPR2201MB127738C76667BAA17DCA8BC3C1E40@MWHPR2201MB1277.namprd22.prod.outlook.com>
References: <1560415970-844-1-git-send-email-Cedric_Hombourger@mentor.com>
In-Reply-To: <1560415970-844-1-git-send-email-Cedric_Hombourger@mentor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0061.namprd02.prod.outlook.com
 (2603:10b6:a03:54::38) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.93.153.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e05931b2-dbee-4472-bb7d-08d6f5c9d33f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1423;
x-ms-traffictypediagnostic: MWHPR2201MB1423:
x-microsoft-antispam-prvs: <MWHPR2201MB1423C2015BFEC6A75BDAA9D4C1E40@MWHPR2201MB1423.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39850400004)(366004)(396003)(376002)(199004)(189003)(66476007)(6916009)(33656002)(66446008)(8676002)(8936002)(2906002)(54906003)(81156014)(64756008)(4744005)(66066001)(81166006)(446003)(6246003)(256004)(5660300002)(71190400001)(71200400001)(6436002)(9686003)(3846002)(42882007)(11346002)(6116002)(55016002)(316002)(53936002)(25786009)(7696005)(102836004)(52116002)(386003)(6506007)(52536014)(4326008)(66946007)(76176011)(7736002)(305945005)(68736007)(74316002)(476003)(73956011)(14454004)(44832011)(229853002)(66556008)(186003)(99286004)(478600001)(486006)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1423;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CMq6DoP790WC71JvdlevelZ/JXrMufK8q36FLXR2v09nZ/PETkUhCEVyzD3DxIRzMDOsI8ZWemvuK+ysq/OBf9rIRJz+mg3S6L9PkYc4LQ0vdJhJBAEWInNiTepaP8WPdkRoMPZuHrhO1RmPzjuQGBApnp4iqvIea5ZahbMvAACA3cvoaJjdDhwNc3b/EeaYhVtdMI6nOMqX1Le0ZfFDEdYULeNROSZIUKL+exMY0bYuLStswhzJE0szply4pta9lUwXjlTGozdAE59UCMH9khl1r7a0oSfvplinRklFkqz6zbu2Yvqemro3vtdi9djxFYu7Fmdrd6CSsWVpJJclNiZ4UFSuQFuenZNjfVW4R1L/EuxrFCqOW4eFm3YHxEcwudJ1si2/O2big/rXOG4U2ZxhLOnM47YtHmeqZaMryts=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e05931b2-dbee-4472-bb7d-08d6f5c9d33f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 21:54:10.4387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1423
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8sDQoNCkNlZHJpYyBIb21ib3VyZ2VyIHdyb3RlOg0KPiBzY3JpcHRzL3BhY2thZ2UvYnVp
bGRkZXAgY2FsbHMgIm1ha2UgZHRic19pbnN0YWxsIiBhZnRlciBleGVjdXRpbmcNCj4gYSBwbGFp
biBtYWtlIChpLmUuIG5vIGJ1aWxkIHRhcmdldHMgc3BlY2lmaWVkKS4gSXQgd2lsbCBmYWlsIGlm
IGR0YnMNCj4gd2VyZSBub3QgYnVpbHQgYmVmb3JlaGFuZC4gTWF0Y2ggdGhlIGFybTY0IGFyY2hp
dGVjdHVyZSB3aGVyZSBEVEJzIGdldA0KPiBidWlsdCBieSB0aGUgImFsbCIgdGFyZ2V0Lg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogQ2VkcmljIEhvbWJvdXJnZXIgPENlZHJpY19Ib21ib3VyZ2VyQG1l
bnRvci5jb20+DQo+IENjOiBsaW51eC1taXBzQHZnZXIua2VybmVsLm9yZw0KPiBDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZw0KDQpBcHBsaWVkIHRvIG1pcHMtZml4ZXMuDQoNClRoYW5rcywNCiAg
ICBQYXVsDQoNClsgVGhpcyBtZXNzYWdlIHdhcyBhdXRvLWdlbmVyYXRlZDsgaWYgeW91IGJlbGll
dmUgYW55dGhpbmcgaXMgaW5jb3JyZWN0DQogIHRoZW4gcGxlYXNlIGVtYWlsIHBhdWwuYnVydG9u
QG1pcHMuY29tIHRvIHJlcG9ydCBpdC4gXQ0K
