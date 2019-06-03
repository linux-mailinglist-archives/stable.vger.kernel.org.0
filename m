Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4816232E0D
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 12:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfFCKxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 06:53:01 -0400
Received: from mail-eopbgr740087.outbound.protection.outlook.com ([40.107.74.87]:60416
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbfFCKxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 06:53:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8VD8sLHFRZxWQ/rXbydR+W6u0o+b0oyqc5mKxaRCAI0=;
 b=XyC8u8cjnaQ43oNB+F8JHYzrnDr5RYhvriLRQSnkchJ53WjUfAV0dDZM0azRRGhxtQoLpA3tdZqg7SCeiHhMY9TXaigyNSWuDhzy7MlcG48UwzOvXurmJgR0m/GyOb1e79uuMeNe9bzIZR4QGc8HhzDmot7lOwMOswr7CYQtIGw=
Received: from BN8PR10MB3540.namprd10.prod.outlook.com (20.179.78.205) by
 BN8PR10MB3249.namprd10.prod.outlook.com (20.179.138.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 10:52:59 +0000
Received: from BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::a460:e299:c4c:4ba8]) by BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::a460:e299:c4c:4ba8%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 10:52:59 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: "tipc: fix modprobe tipc failed after switch order of device
 registration" broke firefox
Thread-Topic: "tipc: fix modprobe tipc failed after switch order of device
 registration" broke firefox
Thread-Index: AQHVGeKNKp1Lkiq9lkmy5ArDCci9z6aJoa8AgAAfjYA=
Date:   Mon, 3 Jun 2019 10:52:58 +0000
Message-ID: <d8218c374d97124f8cf52e6bf3e016bf14059af9.camel@infinera.com>
References: <1b1dba03a69d70553827a972fa7058562dcd13be.camel@infinera.com>
         <20190603090002.GA8096@kroah.com>
In-Reply-To: <20190603090002.GA8096@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Joakim.Tjernlund@infinera.com; 
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0c259d9-87cf-4ead-58e2-08d6e811a477
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN8PR10MB3249;
x-ms-traffictypediagnostic: BN8PR10MB3249:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BN8PR10MB32491126BECF3BE0BB36BA09F4140@BN8PR10MB3249.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(376002)(39850400004)(366004)(346002)(189003)(199004)(52314003)(14454004)(2906002)(7736002)(186003)(99286004)(81156014)(966005)(45080400002)(76176011)(71200400001)(26005)(8676002)(1730700003)(71190400001)(64756008)(73956011)(66946007)(81166006)(6506007)(8936002)(66556008)(66476007)(66446008)(256004)(305945005)(76116006)(91956017)(5024004)(36756003)(102836004)(478600001)(72206003)(486006)(476003)(2616005)(66066001)(4326008)(5660300002)(53936002)(118296001)(316002)(6306002)(5640700003)(6916009)(6512007)(229853002)(2501003)(11346002)(2351001)(6246003)(6436002)(86362001)(446003)(6486002)(25786009)(68736007)(3846002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR10MB3249;H:BN8PR10MB3540.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: infinera.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KUGfm77ShTkttXFo31KTOEygDdVmcS8mvqxU+jNtMXbYiDMWsfdm9+EtsjgLg/mcKLOPDjeYVMW8LW42im2upa0pUO+kWmf8GSe9Os2aDGJyPMFr69oj30Ck+TSvRaospyqvbD6fEY2Kv8wKRyzl5stLBchdzJiqcRUGwFgFO7Ku2Q677kb3m5brcd44CCEud9WpLWIUgwfXNsL9t9gJ6SsO3FqQDUVp7wicAI5X+Ax+ZObcpO3Ho4WnRKB/afiorGyY7zK7+AQzig1jDp2xzhrvPPriAfQC15GeT/HATS4n8pczelIA+m5+C2MBm7diYIqg7d1b8CSnjQpLBgg28G0BcdeCgBjFYhNXLmDPZJicCn8R18T4ewOlMA18Rbr2CcavOdzqZ7xawXdZP+yTOjbrpKO4TkQAuw8ATokEQsw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEB14C34C2F1474C9C289CD76590FF4B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0c259d9-87cf-4ead-58e2-08d6e811a477
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 10:52:58.9697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jocke@infinera.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3249
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTAzIGF0IDExOjAwICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiBDQVVU
SU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRp
b24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgcmVj
b2duaXplIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4gDQo+IA0K
PiBPbiBNb24sIEp1biAwMywgMjAxOSBhdCAwODowMTozMUFNICswMDAwLCBKb2FraW0gVGplcm5s
dW5kIHdyb3RlOg0KPiA+IENvbW1pdCBodHRwczovL25hbTAzLnNhZmVsaW5rcy5wcm90ZWN0aW9u
Lm91dGxvb2suY29tLz91cmw9aHR0cHMlM0ElMkYlMkZnaXQua2VybmVsLm9yZyUyRnB1YiUyRnNj
bSUyRmxpbnV4JTJGa2VybmVsJTJGZ2l0JTJGc3RhYmxlJTJGbGludXguZ2l0JTJGY29tbWl0JTJG
JTNGaCUzRGxpbnV4LTQuMTQueSUyNmlkJTNEYWY0YWY2OGRmM2U0OGY0OWEwM2MyMjEzYjhlNDM4
YWM0NzE0MzEzNSZhbXA7ZGF0YT0wMiU3QzAxJTdDSm9ha2ltLlRqZXJubHVuZCU0MGluZmluZXJh
LmNvbSU3QzZkZTQwMDVhNzAzZjRjZTA1YmQ5MDhkNmU4MDFkZWVlJTdDMjg1NjQzZGU1ZjViNGIw
M2ExNTMwYWUyZGM4YWFmNzclN0MxJTdDMCU3QzYzNjk1MTQ5MjA2OTc4NzkwNSZhbXA7c2RhdGE9
VWFtMWExTmF1dEQ1N0c0TU1wZlJVd3hSNWdtbDdrRmlZY2ZFUEhFbzY3VSUzRCZhbXA7cmVzZXJ2
ZWQ9MA0KPiA+IGJyb2tlIHN0YWJsZSA0LjE0LzQuMTkNCj4gPiBVcHN0cmVhbSByZXZlcnRlZCB0
aGF0IGNvbW1pdCBhbmQgcmVwbGFjZWQgaXQgd2l0aCBhIG5ldyB2ZXJzaW9uOg0KPiA+IGh0dHBz
Oi8vbmFtMDMuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUy
RiUyRmdpdC5rZXJuZWwub3JnJTJGcHViJTJGc2NtJTJGbGludXglMkZrZXJuZWwlMkZnaXQlMkZz
dGFibGUlMkZsaW51eC5naXQlMkZjb21taXQlMkZuZXQlMkZ0aXBjJTJGY29yZS5jJTNGaWQlM0Q1
MjZmNWI4NTFhOTY1NjY4MDNlZTRiZWU2MGQwYTM0ZGY1NmM3N2Y4JmFtcDtkYXRhPTAyJTdDMDEl
N0NKb2FraW0uVGplcm5sdW5kJTQwaW5maW5lcmEuY29tJTdDNmRlNDAwNWE3MDNmNGNlMDViZDkw
OGQ2ZTgwMWRlZWUlN0MyODU2NDNkZTVmNWI0YjAzYTE1MzBhZTJkYzhhYWY3NyU3QzElN0MwJTdD
NjM2OTUxNDkyMDY5Nzg3OTA1JmFtcDtzZGF0YT1YeSUyQjg0OENUNXhHNDdkUUhtOUdIJTJGd3Uy
Sk9XazVUJTJGME9xU0dudXpNZ0h3JTNEJmFtcDtyZXNlcnZlZD0wDQo+IA0KPiBJIGhhdmUgbm8g
aWRlYSBob3cgdGhpcyBicm9rZSBmaXJlZm94LCBvZGQuDQo+IA0KPiBBbnl3YXksIEkgdGhpbmsg
SSd2ZSBub3cgZml4ZWQgdGhpcyBhbGwgdXAsIHNob3VsZCBiZSBpbiB0aGUgbmV4dCBzdGFibGUN
Cj4gcmVsZWFzZXMsIHRoYW5rcy4NCg0KVGhhbmtzLCBmb3IgcmVmZXJlbmNlIHdlIHN0YXJ0ZWQg
dG8gc2VlICIndGlwYyc6IEFkZHJlc3MgZmFtaWx5IG5vdCBzdXBwb3J0ZWQgYnkgcHJvdG9jb2wu
Ig0Kd2l0aCBDT05GSUdfVElQQz15IGluIGtlcm5lbC4NCg0KIEpvY2tlDQoNCg==
