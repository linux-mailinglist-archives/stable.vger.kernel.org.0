Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20AC7D3329
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 23:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfJJVE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 17:04:57 -0400
Received: from mail-eopbgr760132.outbound.protection.outlook.com ([40.107.76.132]:53380
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726986AbfJJVE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 17:04:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQSPKMakHNzlkq4uZ568zJxHWiBrUnoBEdJScnz5VRC5Sd7PUJTRKgRo5bpoPjhw9mqf6d2lXm+k+J8UGD+vmvNaP3sVS2+2F6/f10rbBuY+wesURSa1oe1IPCSqIEUnCM8lkIRArJDUvIsv/cyo7zMwV4bXWXsGs+YfYrgqBbOpyYm4aDxqsWYBp95k8QbbI6B2ERyi6w7leNz5+C3sLeshdz3hKihZR/s1pZNOpuif96nkPZ1euEad/1zJ8i5jJ/IKS9Orbwu8ju5E4n9kKf6oHDr5hl3txBcLCdRWN9GXWDyl/V6BYRmWLX3X05jt1lQXFEMTZg+MQlyNrRZh+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=of1tjHC8QdAJCEzUz05xnqkU77Tv9TwgwfgD/0yw/Q0=;
 b=nQEplTn+F/DVIlfhCRYDajxLj7FEzRK1onKf4lxjscrDEKdZy969+tNL2B5DMUQ14BMBqHMIECxAwdbLfIeErxl2MDStOnxy0JSpuXVEXKHK1aQublNeZc3nSuCD+cRFhn5n7MTJPSzukrjTqeAcZVytMWLqFF0YMY17kHIFQLzfiVIHHzoUfUPfnGu+5EXeaWVfS+HIl44vHgHEivCPY8J51VK/Rcq3w/ZPB1hipHDbIW72NaFCymgrlZfDVIdKr/R0xMSYFVT4hDKBkL9QI1/yp+HdIqi/i0cj2hNqgjkIZG8iiW05UHGkmypuqFrIVsboRn3C/O3YSDueUHNDnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wavecomp.com; dmarc=pass action=none header.from=mips.com;
 dkim=pass header.d=mips.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wavecomp.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=of1tjHC8QdAJCEzUz05xnqkU77Tv9TwgwfgD/0yw/Q0=;
 b=Dq+8vHizzIwmbGjAOnsUz+8v56eHnRHvCON/IZxjU52mL5DKo60E1dcgzdY4ye12nZX7YGjKm4Tz3cks6FC7SwmhUNEtzUzjmGyxtukR6v4osIDn2CgwQpMIKVwFmf1Lb+ERs+pAgB0hg9KnSBXQfs/9MtXEZvsVr/OsQkODjRk=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1408.namprd22.prod.outlook.com (10.172.61.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 10 Oct 2019 21:04:54 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::c1dc:dba3:230c:e7f0]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::c1dc:dba3:230c:e7f0%8]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 21:04:54 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Paul Burton <pburton@wavecomp.com>
CC:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Paul Burton <pburton@wavecomp.com>,
        Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH] MIPS: Disable Loongson MMI instructions for kernel build
Thread-Topic: [PATCH] MIPS: Disable Loongson MMI instructions for kernel build
Thread-Index: AQHVf5wVKW7vpQ4uykW+vlSY7qdKradUXYCA
Date:   Thu, 10 Oct 2019 21:04:54 +0000
Message-ID: <MWHPR2201MB1277F28B1657BBA7821883A9C1940@MWHPR2201MB1277.namprd22.prod.outlook.com>
References: <20191010185324.2407578-1-paul.burton@mips.com>
In-Reply-To: <20191010185324.2407578-1-paul.burton@mips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18c93e24-7b05-47b9-86fb-08d74dc57f88
x-ms-traffictypediagnostic: MWHPR2201MB1408:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR2201MB140822D729215CDAB9DAD863C1940@MWHPR2201MB1408.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(366004)(39840400004)(136003)(189003)(199004)(52314003)(66066001)(52536014)(6862004)(55016002)(9686003)(4326008)(5660300002)(6436002)(6116002)(66446008)(2906002)(3846002)(64756008)(66556008)(66476007)(8936002)(4744005)(66946007)(6246003)(7736002)(74316002)(305945005)(81156014)(81166006)(33656002)(8676002)(6306002)(14444005)(7696005)(476003)(256004)(52116002)(76176011)(71200400001)(71190400001)(99286004)(44832011)(42882007)(11346002)(229853002)(26005)(386003)(966005)(14454004)(478600001)(6506007)(486006)(102836004)(446003)(186003)(25786009)(316002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1408;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NhBwtQyCGsRiS6yYdz2LW53lMEgeVa6+iI6Lj/v/dNGLdc7QZtPbjSslvwCLonm+pf492+IBUnxC6oDW3JGkmQem3RmuQhh+MyhfhSILmP4Lw8Fz0KAY4yu3a7BCPGzQevPoAohaxU9qcac5geIfoO+K33LH3I4DLLSqoB5AWzySbY1VSOCmnS/guITPDycBRsaF5VL6uk5h8Cr28j7d4TOwtddrxC6vlPox8KLAifRYEvc2+m7YabqrcWSRODagyDQa9a0o5+BBSFoOSSZWNCLLUbRHBvW6lFA4paFeL/Ve67d68sSHKD5QJqObORZgmJyi8bWdVU6cIIdaGNG0pAGHNLj+4+sQ0XNPuyP5EPlwD6uQXudSIBLMhFQ2qiGl08tX4hsXRG59vCxBjaWSxm4ciC8aezz+05Fm/8bXzjgXR+bsfyfQuCZ3eCD+ZEELkdQ51ZhvLjDzQ7oecUviuw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c93e24-7b05-47b9-86fb-08d74dc57f88
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 21:04:54.2353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dCu+5IJhBeJzwqeBkIOTX/2QP2SllPHZGYJa3LWyPLlTMLfjrWEAaI7AxeW1uKRDqZe3t/MhSWukLMGTkl+Bdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1408
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8sDQoNClBhdWwgQnVydG9uIHdyb3RlOg0KPiBHQ0MgOS54IGF1dG9tYXRpY2FsbHkgZW5h
YmxlcyBzdXBwb3J0IGZvciBMb29uZ3NvbiBNTUkgaW5zdHJ1Y3Rpb25zIHdoZW4NCj4gdXNpbmcg
c29tZSAtbWFyY2g9IGZsYWdzLCBhbmQgdGhlbiBlcnJvcnMgb3V0IHdoZW4gLW1zb2Z0LWZsb2F0
IGlzDQo+IHNwZWNpZmllZCB3aXRoOg0KPiANCj4gICBjYzE6IGVycm9yOiDigJgtbWxvb25nc29u
LW1taeKAmSBtdXN0IGJlIHVzZWQgd2l0aCDigJgtbWhhcmQtZmxvYXTigJkNCj4gDQo+IFRoZSBr
ZXJuZWwgc2hvdWxkbid0IGJlIHVzaW5nIHRoZXNlIE1NSSBpbnN0cnVjdGlvbnMgYW55d2F5LCBq
dXN0IGFzIGl0DQo+IGRvZXNuJ3QgdXNlIGZsb2F0aW5nIHBvaW50IGluc3RydWN0aW9ucy4gRXhw
bGljaXRseSBkaXNhYmxlIHRoZW0gaW4NCj4gb3JkZXIgdG8gZml4IHRoZSBidWlsZCB3aXRoIEdD
QyA5LnguDQoNCkFwcGxpZWQgdG8gbWlwcy1maXhlcy4NCg0KPiBjb21taXQgMmYyYjRmZDY3NGNh
DQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvbWlwcy9jLzJmMmI0ZmQ2NzRjYQ0KPiANCj4gU2ln
bmVkLW9mZi1ieTogUGF1bCBCdXJ0b24gPHBhdWwuYnVydG9uQG1pcHMuY29tPg0KPiBGaXhlczog
MzcwMmJiYTVlYjRmICgiTUlQUzogTG9vbmdzb246IEFkZCBHQ0MgNC40IHN1cHBvcnQgZm9yIExv
b25nc29uMkUiKQ0KPiBGaXhlczogNmY3YTI1MWEyNTllICgiTUlQUzogTG9vbmdzb246IEFkZCBi
YXNpYyBMb29uZ3NvbiAyRiBzdXBwb3J0IikNCj4gRml4ZXM6IDUxODgxMjliOGM5ZiAoIk1JUFM6
IExvb25nc29uLTM6IEltcHJvdmUgLW1hcmNoIG9wdGlvbiBhbmQgbW92ZSBpdCB0byBQbGF0Zm9y
bSIpDQoNClRoYW5rcywNCiAgICBQYXVsDQoNClsgVGhpcyBtZXNzYWdlIHdhcyBhdXRvLWdlbmVy
YXRlZDsgaWYgeW91IGJlbGlldmUgYW55dGhpbmcgaXMgaW5jb3JyZWN0DQogIHRoZW4gcGxlYXNl
IGVtYWlsIHBhdWwuYnVydG9uQG1pcHMuY29tIHRvIHJlcG9ydCBpdC4gXQ0K
