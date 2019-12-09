Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD78D1166A2
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 06:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfLIF4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 00:56:54 -0500
Received: from mail-eopbgr680054.outbound.protection.outlook.com ([40.107.68.54]:54446
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726132AbfLIF4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 00:56:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2REQZ6zPz8UcCD9vN00E8zMND/RlIK4wblmiXcfufoIPhub32DzdtvoW/2uU/THehxX6+9KWs5GkFr2+h1GEX0jMzN72AUP24BIxfiLE2D14iswFJ/ZhDWf8kpYy8H7jwPsMWSbVSXS/2AS3r7V49ZSDbPdE5Z6tkXpSmV1Dop5mgqg1oZuI5gyFkYlYxgKPSgm5RNW45BZJDMaXy4zc1+FNROkCcUkcW4oiQzteQxQcIYqS8ahJNjDTY2aXhK00Q53yUYuFvS3DGA2EAfnV663GhlyNZGCMyiwZWj9NMNUUtZvwUG+W46w61v88ZHAt0hQhkf8k1BgMC9itKeycQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6n5pb+Gxdlo51IFzXdhqId4wwFRZ9wCjOjjg+wJsuA=;
 b=Oz9SkKNT5VwB55axP6Y+jz3aIDWsPeiZJaOmL05uCEyc5q0psl3cpBRyTS6R3MXxVHprExRcglDlnhko7G0a9UKCIQ2j5X2JC5hl3h5aqQHdSx8xpv13DcRq4rPwEekZ6RSa6ipfKWqKhPqh737lFraLzhDR/LpiHNUUC4PGwb5cgxnDU03y22Qn7t0Huo+wZzyIm0vGHR34fH8YPTlyfxNvhm9o9CQLK1lk6yc9wGPFfcLq4QjzbEa19+h4HcGs8zZFZmbYqOGt6OcokLSwjvYdr77hetcqfyGsD2cosE48CkebGcuy5xLK4ynjLgXfjGPkysCB5+LWRw4FHHIqng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6n5pb+Gxdlo51IFzXdhqId4wwFRZ9wCjOjjg+wJsuA=;
 b=Y7Kvnzb+J0w6IDou8tpw4Ei7uKpTXFBA0aHQN5au7Mt5nsq5VjzdlAnzZcV2EGzjKCiFuxH9lbdd9lhadngtetEqJIAw+X7mMHSDQFrtj48MWy1sBqajushPZLuR8UK5QbwmYGrKro69ah92rJLqjUXXKg9VAHZaII93cgSzPvM=
Received: from DM6PR12MB4137.namprd12.prod.outlook.com (10.141.186.21) by
 DM6PR12MB3964.namprd12.prod.outlook.com (10.255.173.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Mon, 9 Dec 2019 05:56:48 +0000
Received: from DM6PR12MB4137.namprd12.prod.outlook.com
 ([fe80::f06d:7ff3:2a22:99d4]) by DM6PR12MB4137.namprd12.prod.outlook.com
 ([fe80::f06d:7ff3:2a22:99d4%3]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 05:56:48 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     Lyude Paul <lyude@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
CC:     "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] drm/dp_mst: Remove VCPI while disabling topology mgr
Thread-Topic: [PATCH v2] drm/dp_mst: Remove VCPI while disabling topology mgr
Thread-Index: AQHVq0qRoQ6K6PHdDEyQOTgxkWsmjKetfuSAgAAJLICAA8wjgA==
Date:   Mon, 9 Dec 2019 05:56:48 +0000
Message-ID: <DM6PR12MB41371AC4B0EC24E84AB0C84DFC580@DM6PR12MB4137.namprd12.prod.outlook.com>
References: <20191205090043.7580-1-Wayne.Lin@amd.com>
         <a6c4db964da7e00a6069d40abcb3aa887ef5522b.camel@redhat.com>
 <ec3e020798d99ce638c05b0f3eb00ebf53c3bd7c.camel@redhat.com>
In-Reply-To: <ec3e020798d99ce638c05b0f3eb00ebf53c3bd7c.camel@redhat.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wayne.Lin@amd.com; 
x-originating-ip: [165.204.68.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 091252b6-0535-48ea-a32d-08d77c6c9482
x-ms-traffictypediagnostic: DM6PR12MB3964:|DM6PR12MB3964:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3964B0D9DF765DC5B46186C2FC580@DM6PR12MB3964.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(13464003)(189003)(52314003)(199004)(5660300002)(53546011)(55016002)(8936002)(305945005)(52536014)(102836004)(74316002)(81156014)(76116006)(9686003)(6506007)(71190400001)(71200400001)(81166006)(64756008)(66556008)(66476007)(66446008)(8676002)(66946007)(4326008)(86362001)(33656002)(316002)(186003)(478600001)(2906002)(110136005)(26005)(229853002)(54906003)(7696005)(99286004)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3964;H:DM6PR12MB4137.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v/9O4sjPhIZ3a99yh/YxWMVX1FkvuB8yL7kBQb1R1fzifCcowxGaSQDGCf02i4PhdmESxlP3txqWeruMs2TgWAg7ElgEJGh9N7XcY5R3KgdVdNz1XL+toWJ+xZOnr6MhoPXq1FF1gTWOOs+5ZKY5TbQ3Y9YVvXfvvcZLiDcCK5+vaLUJ3uukngmYfTbUpVd+CmCwyAN4onAICsV3fjtptt8Bi0tWZqxWaZzaXt4kEM75ImsjmPhfBVpw0+4LdAK13fLIsQyUwaRrnYR8rrrcdstbFwN1dYramGuTAgqUb6WxE5AChMMAsgk95HQ5xPrp676zOL9BTVUVXV2dC7jPKxqKU7tPlASbEDLNB0KhAbZJjEal7yC2/0qOB6eYYzZFjgbEa4knMMnSpNSLYeHsHnfVSutULengySHPLNR/kYzYjChdWZI/q83yOsJursivRRu2HNz4MW6etsBVMSsfVOy4xP2Hsyx4BqTgc18Vm/QzZmu/7Cjm4VDxO4DeSnvGQkTwc2HRf7HUYAJVB+LIng==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 091252b6-0535-48ea-a32d-08d77c6c9482
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 05:56:48.4582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TefwIFumnz1MmO860RDv2X28LEa3W7+8fp0m6nVrM6kMLiwkRKD14wFHfPYHPbOlnKZpmQTVXUMPdemMh4hbMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3964
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTHl1ZGUgUGF1bCA8bHl1
ZGVAcmVkaGF0LmNvbT4NCj4gU2VudDogU2F0dXJkYXksIERlY2VtYmVyIDcsIDIwMTkgMzo1NyBB
TQ0KPiBUbzogTGluLCBXYXluZSA8V2F5bmUuTGluQGFtZC5jb20+OyBkcmktZGV2ZWxAbGlzdHMu
ZnJlZWRlc2t0b3Aub3JnOw0KPiBhbWQtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZw0KPiBDYzog
S2F6bGF1c2thcywgTmljaG9sYXMgPE5pY2hvbGFzLkthemxhdXNrYXNAYW1kLmNvbT47IFdlbnRs
YW5kLCBIYXJyeQ0KPiA8SGFycnkuV2VudGxhbmRAYW1kLmNvbT47IFp1bywgSmVycnkgPEplcnJ5
Llp1b0BhbWQuY29tPjsNCj4gc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIHYyXSBkcm0vZHBfbXN0OiBSZW1vdmUgVkNQSSB3aGlsZSBkaXNhYmxpbmcgdG9wb2xv
Z3kNCj4gbWdyDQo+IA0KPiBPbiBGcmksIDIwMTktMTItMDYgYXQgMTQ6MjQgLTA1MDAsIEx5dWRl
IFBhdWwgd3JvdGU6DQo+ID4gUmV2aWV3ZWQtYnk6IEx5dWRlIFBhdWwgPGx5dWRlQHJlZGhhdC5j
b20+DQo+ID4NCj4gPiBJJ2xsIGdvIGFoZWFkIGFuZCBwdXNoIHRoaXMgdG8gZHJtLW1pc2MtbmV4
dC1maXhlcyByaWdodCBub3csIHRoYW5rcyENCj4gDQo+IFdob29wcy1tZWFudCB0byBzYXkgZHJt
LW1pc2MtbmV4dCBoZXJlLCBhbnl3YXksIHB1c2hlZCENClRoYW5rcyBmb3IgeW91ciB0aW1lIQ0K
DQo+ID4NCj4gPiBPbiBUaHUsIDIwMTktMTItMDUgYXQgMTc6MDAgKzA4MDAsIFdheW5lIExpbiB3
cm90ZToNCj4gPiA+IFtXaHldDQo+ID4gPg0KPiA+ID4gVGhpcyBwYXRjaCBpcyB0cnlpbmcgdG8g
YWRkcmVzcyB0aGUgaXNzdWUgb2JzZXJ2ZWQgd2hlbiBob3RwbHVnIERQDQo+ID4gPiBkYWlzeSBj
aGFpbiBtb25pdG9ycy4NCj4gPiA+DQo+ID4gPiBlLmcuDQo+ID4gPiBzcmMtbXN0Yi1tc3RiLXNz
dCAtPiBzcmMgKHVucGx1ZykgbXN0Yi1tc3RiLXNzdCAtPiBzcmMtbXN0Yi1tc3RiLXNzdA0KPiA+
ID4gKHBsdWcgaW4gYWdhaW4pDQo+ID4gPg0KPiA+ID4gT25jZSB1bnBsdWcgYSBEUCBNU1QgY2Fw
YWJsZSBkZXZpY2UsIGRyaXZlciB3aWxsIGNhbGwNCj4gPiA+IGRybV9kcF9tc3RfdG9wb2xvZ3lf
bWdyX3NldF9tc3QoKSB0byBkaXNhYmxlIE1TVC4gSW4gdGhpcyBmdW5jdGlvbiwNCj4gPiA+IGl0
IGNsZWFucyBkYXRhIG9mIHRvcG9sb2d5IG1hbmFnZXIgd2hpbGUgZGlzYWJsaW5nIG1zdF9zdGF0
ZS4NCj4gPiA+IEhvd2V2ZXIsIGl0IGRvZXNuJ3QgY2xlYW4gdXAgdGhlIHByb3Bvc2VkX3ZjcGlz
IG9mIHRvcG9sb2d5IG1hbmFnZXIuDQo+ID4gPiBJZiBwcm9wb3NlZF92Y3BpIGlzIG5vdCByZXNl
dCwgb25jZSBwbHVnIGluIE1TVCBkYWlzeSBjaGFpbiBtb25pdG9ycw0KPiA+ID4gbGF0ZXIsIGNv
ZGUgd2lsbCBmYWlsIGF0IGNoZWNraW5nIHBvcnQgdmFsaWRhdGlvbiB3aGlsZSB0cnlpbmcgdG8N
Cj4gPiA+IGFsbG9jYXRlIHBheWxvYWRzLg0KPiA+ID4NCj4gPiA+IFdoZW4gTVNUIGNhcGFibGUg
ZGV2aWNlIGlzIHBsdWdnZWQgaW4gYWdhaW4gYW5kIHRyeSB0byBhbGxvY2F0ZQ0KPiA+ID4gcGF5
bG9hZHMgYnkgY2FsbGluZyBkcm1fZHBfdXBkYXRlX3BheWxvYWRfcGFydDEoKSwgdGhpcyBmdW5j
dGlvbg0KPiA+ID4gd2lsbCBpdGVyYXRlIG92ZXIgYWxsIHByb3Bvc2VkIHZpcnR1YWwgY2hhbm5l
bHMgdG8gc2VlIGlmIGFueQ0KPiA+ID4gcHJvcG9zZWQgVkNQSSdzIG51bV9zbG90cyBpcyBncmVh
dGVyIHRoYW4gMC4gSWYgYW55IHByb3Bvc2VkIFZDUEkncw0KPiA+ID4gbnVtX3Nsb3RzIGlzIGdy
ZWF0ZXIgdGhhbiAwIGFuZCB0aGUgcG9ydCB3aGljaCB0aGUgc3BlY2lmaWMgdmlydHVhbA0KPiA+
ID4gY2hhbm5lbCBkaXJlY3RlZCB0byBpcyBub3QgaW4gdGhlIHRvcG9sb2d5LCBjb2RlIHRoZW4g
ZmFpbHMgYXQgdGhlDQo+ID4gPiBwb3J0IHZhbGlkYXRpb24uIFNpbmNlIHRoZXJlIGFyZSBzdGFs
ZSBWQ1BJIGFsbG9jYXRpb25zIGZyb20gdGhlDQo+ID4gPiBwcmV2aW91cyB0b3BvbG9neSBlbmFi
bGVtZW50IGluIHByb3Bvc2VkX3ZjcGlbXSwgY29kZSB3aWxsIGZhaWwgYXQNCj4gPiA+IHBvcnQg
dmFsaWRhdGlvbiBhbmQgcmV1cm4gRUlOVkFMLg0KPiA+ID4NCj4gPiA+IFtIb3ddDQo+ID4gPg0K
PiA+ID4gQ2xlYW4gdXAgdGhlIGRhdGEgb2Ygc3RhbGUgcHJvcG9zZWRfdmNwaVtdIGFuZCByZXNl
dA0KPiA+ID4gbWdyLT5wcm9wb3NlZF92Y3BpcyB0byBOVUxMIHdoaWxlIGRpc2FibGluZyBtc3Qg
aW4NCj4gZHJtX2RwX21zdF90b3BvbG9neV9tZ3Jfc2V0X21zdCgpLg0KPiA+ID4NCj4gPiA+IENo
YW5nZXMgc2luY2UgdjE6DQo+ID4gPiAqQWRkIG9uIG1vcmUgZGV0YWlscyBpbiBjb21taXQgbWVz
c2FnZSB0byBkZXNjcmliZSB0aGUgaXNzdWUgd2hpY2gNCj4gPiA+IHRoZSBwYXRjaCBpcyB0cnlp
bmcgdG8gZml4DQo+ID4gPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogV2F5bmUgTGluIDxXYXluZS5M
aW5AYW1kLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGRyaXZlcnMvZ3B1L2RybS9kcm1fZHBfbXN0
X3RvcG9sb2d5LmMgfCAxMiArKysrKysrKysrKysNCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTIg
aW5zZXJ0aW9ucygrKQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0v
ZHJtX2RwX21zdF90b3BvbG9neS5jDQo+ID4gPiBiL2RyaXZlcnMvZ3B1L2RybS9kcm1fZHBfbXN0
X3RvcG9sb2d5LmMNCj4gPiA+IGluZGV4IGFlNTgwOWExZjE5YS4uYmY0Zjc0NWE0ZWRiIDEwMDY0
NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2RybV9kcF9tc3RfdG9wb2xvZ3kuYw0KPiA+
ID4gKysrIGIvZHJpdmVycy9ncHUvZHJtL2RybV9kcF9tc3RfdG9wb2xvZ3kuYw0KPiA+ID4gQEAg
LTMzODYsNiArMzM4Niw3IEBAIHN0YXRpYyBpbnQgZHJtX2RwX2dldF92Y19wYXlsb2FkX2J3KHU4
DQo+ID4gPiBkcF9saW5rX2J3LA0KPiA+ID4gdTggIGRwX2xpbmtfY291bnQpDQo+ID4gPiAgaW50
IGRybV9kcF9tc3RfdG9wb2xvZ3lfbWdyX3NldF9tc3Qoc3RydWN0DQo+IGRybV9kcF9tc3RfdG9w
b2xvZ3lfbWdyDQo+ID4gPiAqbWdyLCBib29sIG1zdF9zdGF0ZSkgIHsNCj4gPiA+ICAJaW50IHJl
dCA9IDA7DQo+ID4gPiArCWludCBpID0gMDsNCj4gPiA+ICAJc3RydWN0IGRybV9kcF9tc3RfYnJh
bmNoICptc3RiID0gTlVMTDsNCj4gPiA+DQo+ID4gPiAgCW11dGV4X2xvY2soJm1nci0+bG9jayk7
DQo+ID4gPiBAQCAtMzQ0NiwxMCArMzQ0NywyMSBAQCBpbnQNCj4gZHJtX2RwX21zdF90b3BvbG9n
eV9tZ3Jfc2V0X21zdChzdHJ1Y3QNCj4gPiA+IGRybV9kcF9tc3RfdG9wb2xvZ3lfbWdyICptZ3Is
IGJvb2wgbXMNCj4gPiA+ICAJCS8qIHRoaXMgY2FuIGZhaWwgaWYgdGhlIGRldmljZSBpcyBnb25l
ICovDQo+ID4gPiAgCQlkcm1fZHBfZHBjZF93cml0ZWIobWdyLT5hdXgsIERQX01TVE1fQ1RSTCwg
MCk7DQo+ID4gPiAgCQlyZXQgPSAwOw0KPiA+ID4gKwkJbXV0ZXhfbG9jaygmbWdyLT5wYXlsb2Fk
X2xvY2spOw0KPiA+ID4gIAkJbWVtc2V0KG1nci0+cGF5bG9hZHMsIDAsIG1nci0+bWF4X3BheWxv
YWRzICogc2l6ZW9mKHN0cnVjdA0KPiA+ID4gZHJtX2RwX3BheWxvYWQpKTsNCj4gPiA+ICAJCW1n
ci0+cGF5bG9hZF9tYXNrID0gMDsNCj4gPiA+ICAJCXNldF9iaXQoMCwgJm1nci0+cGF5bG9hZF9t
YXNrKTsNCj4gPiA+ICsJCWZvciAoaSA9IDA7IGkgPCBtZ3ItPm1heF9wYXlsb2FkczsgaSsrKSB7
DQo+ID4gPiArCQkJc3RydWN0IGRybV9kcF92Y3BpICp2Y3BpID0gbWdyLT5wcm9wb3NlZF92Y3Bp
c1tpXTsNCj4gPiA+ICsNCj4gPiA+ICsJCQlpZiAodmNwaSkgew0KPiA+ID4gKwkJCQl2Y3BpLT52
Y3BpID0gMDsNCj4gPiA+ICsJCQkJdmNwaS0+bnVtX3Nsb3RzID0gMDsNCj4gPiA+ICsJCQl9DQo+
ID4gPiArCQkJbWdyLT5wcm9wb3NlZF92Y3Bpc1tpXSA9IE5VTEw7DQo+ID4gPiArCQl9DQo+ID4g
PiAgCQltZ3ItPnZjcGlfbWFzayA9IDA7DQo+ID4gPiArCQltdXRleF91bmxvY2soJm1nci0+cGF5
bG9hZF9sb2NrKTsNCj4gPiA+ICAJfQ0KPiA+ID4NCj4gPiA+ICBvdXRfdW5sb2NrOg0KPiAtLQ0K
PiBDaGVlcnMsDQo+IAlMeXVkZSBQYXVsDQoNCi0tDQpSZWdhcmRzLA0KV2F5bmUgTGluDQo=
