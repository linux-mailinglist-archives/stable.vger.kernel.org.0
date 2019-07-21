Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827EC6F3BD
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 16:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfGUOrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 10:47:23 -0400
Received: from mail-eopbgr680077.outbound.protection.outlook.com ([40.107.68.77]:49435
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726366AbfGUOrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 10:47:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8wi7+XnywQ7gbo6U4kndIxZy7LbEKECaXSJB05seUiFnmQ/CfU6KPlr6xALrF0zr3EAAfQALow8LgEGDUHBhgUSJgQLkY6GwXV9lB2Tz8ayfHLB2u0r1f1eNQ2LSDw5P3hSfKK1oB1CR14TVx/0Wf3YdyVWc93/+E2tYwM8gP3SlVLnc/8UUhCPrGZV1RoKQiByahZxRTa/sTvVlfyreOfdj0iCDjY2u1itRlmn8U4cgE431BnUtaMgq/GlTU2GJ4JssObLHDu5uX/Mbdw628lpV9wjz6hjuQm0pEXmYndoR/gq5GtkKWQUfZRlWxDv5MrDR+46jH6N9lpAsDtLIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7uhnz7omswWVhe/h3gDN1dETxsMBiJxz+7j97EmF0I=;
 b=hyViYBCEg9pI4JpVY1CozhKAClkK46xfT+MCSESNwylJnJM6pPqwS9WJ4oQypQ9ckU8ihBxPbeMePixObV0q99lrLx+qrvkP7jnnIDPxUoH7u/DxbSCjSye8IAlntBsOAE8QcE9h/UbYR9IRYDs1ITwZuJPAmWdehrVMi+SOj3Qfuj0Uy6x6Ax9Coiu0ihvrs+vX9fN+wW9wfkmWawPWo7rgHMIYJqZCb2+rcZRTdOIBVWT5E26tMu6MoMY8Yw4Z3uqEp52K7vvbce8E7EN91zBCuUF7r8WOJSUX+8vYhIOIZkEyg0aijSX+bPMotNIzM0pKRqOgJldPI1Am8rN9iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7uhnz7omswWVhe/h3gDN1dETxsMBiJxz+7j97EmF0I=;
 b=HOPbPs5AY4Xz0+PWRlIl2sP8p+ELOc1hQggus9cIx8Hci2KffSeJFIsuy4c1L8/mn/tX32sPBCsf6i4Gn+tfwMeZnY62bV220CB6XpTxCFeFFdmlEdjrENUBXTkxgfpyxDO1NhCFzgyjlOSFudMeFLDjU7Ao+4baAEgqckMy+cQ=
Received: from DM5PR12MB1546.namprd12.prod.outlook.com (10.172.36.23) by
 DM5PR12MB1788.namprd12.prod.outlook.com (10.175.86.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.15; Sun, 21 Jul 2019 14:47:17 +0000
Received: from DM5PR12MB1546.namprd12.prod.outlook.com
 ([fe80::cda7:cfc1:ce62:bcb7]) by DM5PR12MB1546.namprd12.prod.outlook.com
 ([fe80::cda7:cfc1:ce62:bcb7%10]) with mapi id 15.20.2094.013; Sun, 21 Jul
 2019 14:47:17 +0000
From:   "Koenig, Christian" <Christian.Koenig@amd.com>
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] PCI: set BAR size bits correctly in Resize BAR control
 register
Thread-Topic: [PATCH] PCI: set BAR size bits correctly in Resize BAR control
 register
Thread-Index: AQHVPltJCBYDKLYuBESFwx9euJUhdabVKaMA
Date:   Sun, 21 Jul 2019 14:47:17 +0000
Message-ID: <90cdfa16-5fdf-e9a4-4e5d-e4b7651f181b@amd.com>
References: <20190716180940.17828-1-sumit.saxena@broadcom.com>
 <CAL2rwxpc-Ub7ufs1SEEmnNaxtZg2KtY-QAuQnu95kXVPN8Z02Q@mail.gmail.com>
In-Reply-To: <CAL2rwxpc-Ub7ufs1SEEmnNaxtZg2KtY-QAuQnu95kXVPN8Z02Q@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-originating-ip: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
x-clientproxiedby: AM6P191CA0012.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8b::25) To DM5PR12MB1546.namprd12.prod.outlook.com
 (2603:10b6:4:8::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Christian.Koenig@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71586b74-9cc2-48d5-8894-08d70dea5380
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM5PR12MB1788;
x-ms-traffictypediagnostic: DM5PR12MB1788:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM5PR12MB17884F6272B2A7B7102066B683C50@DM5PR12MB1788.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0105DAA385
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(199004)(189003)(14454004)(53546011)(54906003)(6506007)(386003)(2501003)(2906002)(99286004)(2616005)(11346002)(102836004)(446003)(76176011)(52116002)(31686004)(186003)(8676002)(476003)(46003)(68736007)(81156014)(8936002)(6116002)(316002)(58126008)(81166006)(110136005)(71200400001)(36756003)(71190400001)(966005)(6512007)(6306002)(6246003)(53936002)(229853002)(478600001)(65806001)(65956001)(66946007)(66446008)(66476007)(66556008)(64756008)(5660300002)(4326008)(14444005)(256004)(486006)(6486002)(64126003)(86362001)(31696002)(7736002)(25786009)(65826007)(6436002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1788;H:DM5PR12MB1546.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ms/rLkxJYt4USbwYVStCtzdm3kYwujxw0H2kJshBbMkSIdrBrhagpZULEpE3gCgzj67IUjKkz7KgGROZYYV5oZZZFapAqsxxaQrg8DspGMt+cxqX/CdyXnxGHeQ09iidok8FadUvn3mIFd3rsmq49bam6I9kaVCd9CBQ4OL5hz4Co7eYZmJJxfF/CRLlNQfhOzMjJ0TXWmmSrmmUI8XUxBKEgBk9/+NxCgYYHVyHESIWHwWOLaQnqC8ujK7901+7bAK58C6WA1VmNEfdBCUZRqJ5IZUIOnyEXvgbVwgRGNf/SyNlaQfP/NX1w+uoKtxqICAounwS+r+nEsQ1zWAQ1/ziYTrMrpqNlyrFYP/tyWrDRY8EqFgCbTY7kBAV8CrPmFNZp9gF5NU/i8R0etex15pcIIRBYSxIw0Ii2uh6RJY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F96729AE0AD0D43AEBC130F9FBB5056@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71586b74-9cc2-48d5-8894-08d70dea5380
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2019 14:47:17.3167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ckoenig@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1788
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

QW0gMTkuMDcuMTkgdW0gMTk6NTYgc2NocmllYiBTdW1pdCBTYXhlbmE6DQo+ICtDaHJpc3RpYW4g
S29lbmlnDQo+DQo+IE9uIFR1ZSwgSnVsIDE2LCAyMDE5IGF0IDM6NDEgUE0gU3VtaXQgU2F4ZW5h
IDxzdW1pdC5zYXhlbmFAYnJvYWRjb20uY29tPiB3cm90ZToNCj4+IEluIFJlc2l6ZSBCQVIgY29u
dHJvbCByZWdpc3RlciwgYml0c1s4OjEyXSByZXByZXNlbnRzIHNpemUgb2YgQkFSLg0KPj4gQXMg
cGVyIFBDSWUgc3BlY2lmaWNhdGlvbiwgYmVsb3cgaXMgZW5jb2RlZCB2YWx1ZXMgaW4gcmVnaXN0
ZXIgYml0cw0KPj4gdG8gYWN0dWFsIEJBUiBzaXplIHRhYmxlOg0KPj4NCj4+IEJpdHMgIEJBUiBz
aXplDQo+PiAwICAgICAxIE1CDQo+PiAxICAgICAyIE1CDQo+PiAyICAgICA0IE1CDQo+PiAzICAg
ICA4IE1CDQo+PiAtLQ0KPj4NCj4+IEZvciAxIE1CIEJBUiBzaXplLCBCQVIgc2l6ZSBiaXRzIHNo
b3VsZCBiZSBzZXQgdG8gMCBidXQgaW5jb3JyZWN0bHkNCj4+IHRoZXNlIGJpdHMgYXJlIHNldCB0
byAiMWYiLg0KPj4gTGF0ZXN0IG1lZ2FyYWlkX3NhcyBhbmQgbXB0M3NhcyBhZGFwdGVycyB3aGlj
aCBzdXBwb3J0IFJlc2l6YWJsZSBCQVINCj4+IHdpdGggMSBNQiBCQVIgc2l6ZSBmYWlscyB0byBp
bml0aWFsaXplIGR1cmluZyBzeXN0ZW0gcmVzdW1lIGZyb20gUzMgc2xlZXAuDQo+Pg0KPj4gRml4
OiBDb3JyZWN0bHkgc2V0IEJBUiBzaXplIGJpdHMgdG8gIjAiIGZvciAxTUIgQkFSIHNpemUuDQo+
Pg0KPj4gQ0M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyB2NC4xNisNCj4+IEJ1Z3ppbGxhOiBo
dHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIwMzkzOQ0KPj4gRml4
ZXM6IGQzMjUyYWNlMGJjNjUyYTFhMjQ0NDU1NTU2YjZhNTQ5Zjk2OWJmOTkgKCJQQ0k6IFJlc3Rv
cmUgcmVzaXplZCBCQVIgc3RhdGUgb24gcmVzdW1lIikNCj4+IFNpZ25lZC1vZmYtYnk6IFN1bWl0
IFNheGVuYSA8c3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbT4NCj4+IC0tLQ0KPj4gICBkcml2ZXJz
L3BjaS9wY2kuYyB8IDUgKysrLS0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9wY2kvcGNpLmMg
Yi9kcml2ZXJzL3BjaS9wY2kuYw0KPj4gaW5kZXggOGFiYzg0My4uYjY1MWYzMiAxMDA2NDQNCj4+
IC0tLSBhL2RyaXZlcnMvcGNpL3BjaS5jDQo+PiArKysgYi9kcml2ZXJzL3BjaS9wY2kuYw0KPj4g
QEAgLTE0MTcsMTIgKzE0MTcsMTMgQEAgc3RhdGljIHZvaWQgcGNpX3Jlc3RvcmVfcmViYXJfc3Rh
dGUoc3RydWN0IHBjaV9kZXYgKnBkZXYpDQo+Pg0KPj4gICAgICAgICAgZm9yIChpID0gMDsgaSA8
IG5iYXJzOyBpKyssIHBvcyArPSA4KSB7DQo+PiAgICAgICAgICAgICAgICAgIHN0cnVjdCByZXNv
dXJjZSAqcmVzOw0KPj4gLSAgICAgICAgICAgICAgIGludCBiYXJfaWR4LCBzaXplOw0KPj4gKyAg
ICAgICAgICAgICAgIGludCBiYXJfaWR4LCBzaXplLCBvcmRlcjsNCj4+DQo+PiAgICAgICAgICAg
ICAgICAgIHBjaV9yZWFkX2NvbmZpZ19kd29yZChwZGV2LCBwb3MgKyBQQ0lfUkVCQVJfQ1RSTCwg
JmN0cmwpOw0KPj4gICAgICAgICAgICAgICAgICBiYXJfaWR4ID0gY3RybCAmIFBDSV9SRUJBUl9D
VFJMX0JBUl9JRFg7DQo+PiAgICAgICAgICAgICAgICAgIHJlcyA9IHBkZXYtPnJlc291cmNlICsg
YmFyX2lkeDsNCj4+IC0gICAgICAgICAgICAgICBzaXplID0gb3JkZXJfYmFzZV8yKChyZXNvdXJj
ZV9zaXplKHJlcykgPj4gMjApIHwgMSkgLSAxOw0KPj4gKyAgICAgICAgICAgICAgIG9yZGVyID0g
b3JkZXJfYmFzZV8yKChyZXNvdXJjZV9zaXplKHJlcykgPj4gMjApIHwgMSk7DQo+PiArICAgICAg
ICAgICAgICAgc2l6ZSA9IG9yZGVyID8gb3JkZXIgLSAxIDogMDsNCg0KVGhhdCBhY3R1YWxseSBk
b2Vzbid0IGxvb2tzIGxpa2UgaXQgaXMgY29ycmVjdCBvciBhdCBsZWFzdCBpdCdzIA0KdW5uZWNl
c3NhcnkgY29tcGxleC4NCg0KVGhlICIgPj4gMjApIHwgMSIgc2VlbXMgbGlrZSBhIGNvcHkgJiBw
YXN0ZSBlcnJvciBmcm9tIHRoZSBjb2RlIGluIA0KYW1kZ3B1IHdoZXJlIHRoZSBCQVIgbmVlZHMg
dG8gbGFyZ2VyIHRoYW4gdGhlIFZSQU0gc2l6ZSAod2hpY2ggaXMgbm90IGEgDQpwb3dlciBvZiB0
d28pLg0KDQpTbyBqdXN0IHVzaW5nICJzaXplID0gb3JkZXJfYmFzZV8yKHJlc291cmNlX3NpemUo
cmVzKSA+PiAyMCk7IiBzaG91bGQgYmUgDQpzdWZmaWNpZW50IGhlcmUuDQoNClJlZ2FyZHMsDQpD
aHJpc3RpYW4uDQoNCj4+ICAgICAgICAgICAgICAgICAgY3RybCAmPSB+UENJX1JFQkFSX0NUUkxf
QkFSX1NJWkU7DQo+PiAgICAgICAgICAgICAgICAgIGN0cmwgfD0gc2l6ZSA8PCBQQ0lfUkVCQVJf
Q1RSTF9CQVJfU0hJRlQ7DQo+PiAgICAgICAgICAgICAgICAgIHBjaV93cml0ZV9jb25maWdfZHdv
cmQocGRldiwgcG9zICsgUENJX1JFQkFSX0NUUkwsIGN0cmwpOw0KPj4gLS0NCj4+IDEuOC4zLjEN
Cj4+DQoNCg==
