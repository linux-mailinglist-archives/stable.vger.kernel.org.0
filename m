Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE28144AEA
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 05:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAVEtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 23:49:00 -0500
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:31878
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726811AbgAVEtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 23:49:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JjMkk12kzqxRkL5fVgZumXMLKxCNM2R7Zr/W1zuWhKnQjxIRuxVCEOpwv96lalW+YqV1wwZ7CCPvyl9LPnqCyarEakDKAveVEsYeZJQPUUdtG3Bac+hV+bWDjAJGBBSZnLZPTa6QDDh43uo59Da59k9Lx1SAEI00ApbbBMv/qG9rtu4jcgWL7xZLY/Ek9OLWdehAb8QgqXnqWbdlnzN+jCAS/sq2enNlW1/jBgCYxZoPmi2zEFbX1VIJR5Xck1/0pOjlHVv02z6h5AueKxZYkNNwGCqk57/KESHqoZ6hhQKiR28uN4v7x+dXcYxcE75TTdyj5ny32zDh1Blbw5bMBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4c4Cx+YEyJ6fMDdySGsvHDv6E5GIMeqFWgOg0zZ7wtU=;
 b=nFfLnYvshW5/iREVOQ8VmYGMc+EPeLddW/chNp8aENjvBmDIC1+jSl7Wyglynt5Oa+KjRfpSuIGF7asQSVSNCC3fXFHG0BR7UxMyMahRuMK3fxNq5jdR6GqeaVvpM9X7BiQgMDMoImxBcCy/CJXcmoV9GJ5J7OuseEmq8+WO/n5TblAscOBXS8RhVFPehhl3Iwhvv2HK94bRCFCpuHe8PDn1cqSu6UwF2XHyYED9+58yzlySysHs/5T85N7FULEXmX0II1mPdNe8r2KdcQqc1JkLpMF0SCBxtvIn1YUDBh7KYdMZ8CvZ3CMR4mz/+KBr8jnAUGE8balgeThWjPrQqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4c4Cx+YEyJ6fMDdySGsvHDv6E5GIMeqFWgOg0zZ7wtU=;
 b=b9CaY3CfsOsuMpautZXzGyUv1aRVQnstkfDBt01vQztNyv65UOLRUO43I5I5EL9zSQFakD2tOftrrGkA6o5kvBRaQfj/FRDjWPNTwVDQw482JZny3vWo3E288qsywM0iS041OoK1ydeBBrD45EbYNhARXkFFkhhCasGrdlMsIzc=
Received: from DM6PR12MB4137.namprd12.prod.outlook.com (10.141.186.21) by
 DM6PR12MB3612.namprd12.prod.outlook.com (20.178.30.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 22 Jan 2020 04:48:55 +0000
Received: from DM6PR12MB4137.namprd12.prod.outlook.com
 ([fe80::cd1d:def3:d2df:3882]) by DM6PR12MB4137.namprd12.prod.outlook.com
 ([fe80::cd1d:def3:d2df:3882%7]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 04:48:55 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     Lyude Paul <lyude@redhat.com>, Sean Paul <sean@poorly.run>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] drm/dp_mst: Remove VCPI while disabling topology mgr
Thread-Topic: [PATCH v2] drm/dp_mst: Remove VCPI while disabling topology mgr
Thread-Index: AQHVq0qRoQ6K6PHdDEyQOTgxkWsmjKetfuSAgAAJLICAA8wjgIA9+RMAgABFHwCAAASDgIAAAJwAgAbPEhA=
Date:   Wed, 22 Jan 2020 04:48:54 +0000
Message-ID: <DM6PR12MB4137A84B694D85E26F8050D8FC0C0@DM6PR12MB4137.namprd12.prod.outlook.com>
References: <20191205090043.7580-1-Wayne.Lin@amd.com>
         <a6c4db964da7e00a6069d40abcb3aa887ef5522b.camel@redhat.com>
         <ec3e020798d99ce638c05b0f3eb00ebf53c3bd7c.camel@redhat.com>
         <DM6PR12MB41371AC4B0EC24E84AB0C84DFC580@DM6PR12MB4137.namprd12.prod.outlook.com>
         <CAMavQK+pS40SQibFuirjLAmjmy8NbOcXWvNsFP8PanS6dEcXWw@mail.gmail.com>
         <31d9eabe57a25ff8f4df22e645494d57715cdc0b.camel@redhat.com>
         <CAMavQK+pOtQ62mp4DSRDW7nHDz4doW3LA5AV1NML-wFa3s3cQA@mail.gmail.com>
 <cfae7fec779bd8fa4da0ad0e7664cf797a1700ab.camel@redhat.com>
In-Reply-To: <cfae7fec779bd8fa4da0ad0e7664cf797a1700ab.camel@redhat.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2020-01-22T04:44:15Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=9263d1b0-1c41-482b-9c0a-000099e3ecf2;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_enabled: true
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_setdate: 2020-01-22T04:48:52Z
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_method: Privileged
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_name: Public_0
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_actionid: a19d6335-c614-4168-aff3-0000dfa3b4ca
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_contentbits: 0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wayne.Lin@amd.com; 
x-originating-ip: [165.204.68.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d64ac712-b8b9-421f-13ce-08d79ef662a4
x-ms-traffictypediagnostic: DM6PR12MB3612:|DM6PR12MB3612:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3612155A7327FECC00235B24FC0C0@DM6PR12MB3612.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(199004)(189003)(64756008)(86362001)(26005)(6506007)(2906002)(186003)(8676002)(81156014)(4326008)(53546011)(66946007)(66446008)(66476007)(478600001)(5660300002)(55016002)(9686003)(66556008)(52536014)(110136005)(76116006)(316002)(8936002)(54906003)(7696005)(33656002)(71200400001)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3612;H:DM6PR12MB4137.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GL+ggOhw8+O48V0vFMfX8nNLR//UBz16cRoNf3WQGOn6ba/ZtcG3/ptJTN2QPHcVuOA2hNCIyTyBG1rGxjmKZFoXEQwNjMJYYJiTtipRKJ6W8v8Lt4leJgzcyg3cIdO4igeEkXxdk4PSmMenPt0wSYhUXmJ7b5OVGMy0eMJs3CSvzt2b/30k5rPiCks+ID6iQktMGUaGsg9Wu2QfJR9/iuKyhIioFOwwVIM1996cO7r6J7Zd/KtMxDJ7E2v3iEOZTiGU7oEq+xR+fVtsTFf8mHoTRrLobjY7Q5FKPGUG1ivxXgV4KGhRBp7bwF5bVj1cyrVbDmPaghaMOSg0yAb9pkFd5aFmoIlgEpiWXYrViYpgl1qLgzaDS/88l7zFGlFBNpqquSiK9OR901k3MpcHmLBTvjDqNV8734YIoDxvw7Qn32UZnX283zZQ77kdM0Ye
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d64ac712-b8b9-421f-13ce-08d79ef662a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 04:48:54.8625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R2BKQpqaW/f2U/UX6VysZk+Gk7k/wO99qZGmJAWIyteng0QnJ/9lHpW9kE0317r3NbEBjXzvtGR90Yqew/39aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3612
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W0FNRCBQdWJsaWMgVXNlXQ0KDQpTb3JyeSBmb3IgYW55IGluY29udmVuaWVuY2UgSSBicm91Z2h0
Lg0KVGhhbmsgeW91IHNvIG11Y2ggTHl1ZGUsIEkgd2lsbCBoYXZlIGEgbG9vayBvbiB0aGF0IGZp
eCBwYXRjaCBsYXRlci4NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBM
eXVkZSBQYXVsIDxseXVkZUByZWRoYXQuY29tPg0KPiBTZW50OiBTYXR1cmRheSwgSmFudWFyeSAx
OCwgMjAyMCA0OjQ1IEFNDQo+IFRvOiBTZWFuIFBhdWwgPHNlYW5AcG9vcmx5LnJ1bj4NCj4gQ2M6
IExpbiwgV2F5bmUgPFdheW5lLkxpbkBhbWQuY29tPjsgZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNr
dG9wLm9yZzsNCj4gYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmc7IFp1bywgSmVycnkgPEpl
cnJ5Llp1b0BhbWQuY29tPjsgS2F6bGF1c2thcywNCj4gTmljaG9sYXMgPE5pY2hvbGFzLkthemxh
dXNrYXNAYW1kLmNvbT47IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2Ml0gZHJtL2RwX21zdDogUmVtb3ZlIFZDUEkgd2hpbGUgZGlzYWJsaW5nIHRvcG9sb2d5
DQo+IG1ncg0KPiANCj4gWWVhaCB0aGF0J3MgZmluZSB3aXRoIG1lLCBJJ2xsIHNlbmQgb3V0IGEg
cmV2ZXJ0IGZvciB0aGlzIGluIGp1c3QgYSBtb21lbnQNCj4gDQo+IE9uIEZyaSwgMjAyMC0wMS0x
NyBhdCAxNTo0MyAtMDUwMCwgU2VhbiBQYXVsIHdyb3RlOg0KPiA+IE9uIEZyaSwgSmFuIDE3LCAy
MDIwIGF0IDM6MjcgUE0gTHl1ZGUgUGF1bCA8bHl1ZGVAcmVkaGF0LmNvbT4gd3JvdGU6DQo+ID4g
PiBPbiBGcmksIDIwMjAtMDEtMTcgYXQgMTE6MTkgLTA1MDAsIFNlYW4gUGF1bCB3cm90ZToNCj4g
PiA+ID4gT24gTW9uLCBEZWMgOSwgMjAxOSBhdCAxMjo1NiBBTSBMaW4sIFdheW5lIDxXYXluZS5M
aW5AYW1kLmNvbT4NCj4gd3JvdGU6DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IC0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQo+ID4gPiA+ID4gPiBGcm9tOiBMeXVkZSBQYXVsIDxseXVkZUByZWRo
YXQuY29tPg0KPiA+ID4gPiA+ID4gU2VudDogU2F0dXJkYXksIERlY2VtYmVyIDcsIDIwMTkgMzo1
NyBBTQ0KPiA+ID4gPiA+ID4gVG86IExpbiwgV2F5bmUgPFdheW5lLkxpbkBhbWQuY29tPjsNCj4g
PiA+ID4gPiA+IGRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmc7IGFtZC1nZnhAbGlzdHMu
ZnJlZWRlc2t0b3Aub3JnDQo+ID4gPiA+ID4gPiBDYzogS2F6bGF1c2thcywgTmljaG9sYXMgPE5p
Y2hvbGFzLkthemxhdXNrYXNAYW1kLmNvbT47DQo+ID4gPiA+ID4gPiBXZW50bGFuZCwgSGFycnkg
PEhhcnJ5LldlbnRsYW5kQGFtZC5jb20+OyBadW8sIEplcnJ5DQo+ID4gPiA+ID4gPiA8SmVycnku
WnVvQGFtZC5jb20+OyBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gPiA+ID4gPiBTdWJqZWN0
OiBSZTogW1BBVENIIHYyXSBkcm0vZHBfbXN0OiBSZW1vdmUgVkNQSSB3aGlsZQ0KPiA+ID4gPiA+
ID4gZGlzYWJsaW5nIHRvcG9sb2d5IG1ncg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IE9uIEZy
aSwgMjAxOS0xMi0wNiBhdCAxNDoyNCAtMDUwMCwgTHl1ZGUgUGF1bCB3cm90ZToNCj4gPiA+ID4g
PiA+ID4gUmV2aWV3ZWQtYnk6IEx5dWRlIFBhdWwgPGx5dWRlQHJlZGhhdC5jb20+DQo+ID4gPiA+
ID4gPiA+DQo+ID4gPiA+ID4gPiA+IEknbGwgZ28gYWhlYWQgYW5kIHB1c2ggdGhpcyB0byBkcm0t
bWlzYy1uZXh0LWZpeGVzIHJpZ2h0DQo+ID4gPiA+ID4gPiA+IG5vdywgdGhhbmtzIQ0KPiA+ID4g
PiA+ID4NCj4gPiA+ID4gPiA+IFdob29wcy1tZWFudCB0byBzYXkgZHJtLW1pc2MtbmV4dCBoZXJl
LCBhbnl3YXksIHB1c2hlZCENCj4gPiA+ID4gPiBUaGFua3MgZm9yIHlvdXIgdGltZSENCj4gPiA+
ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiBJJ20gZ2V0dGluZyB0aGUgZm9sbG93aW5nIHdhcm5pbmcg
b24gdW5wbHVnIHdpdGggdGhpcyBwYXRjaDoNCj4gPiA+ID4NCj4gPg0KPiA+IFxzbmlwDQo+ID4N
Cj4gPiA+IEkgdGhpbmsgSSd2ZSBnb3QgYSBiZXR0ZXIgZml4IGZvciB0aGlzIHRoYXQgc2hvdWxk
IGF2b2lkIHRoYXQNCj4gPiA+IHByb2JsZW0sIEknbGwgd3JpdGUgdXAgYSBwYXRjaCBhbmQgc2Vu
ZCBpdCBvdXQgaW4gYSBiaXQNCj4gPg0KPiA+IFRoYW5rcyBMeXVkZSEgU2hvdWxkIHdlIHJldmVy
dCB0aGlzIHBhdGNoIGZvciB0aGUgdGltZSBiZWluZz8NCj4gPg0KPiA+ID4gLS0NCj4gPiA+IENo
ZWVycywNCj4gPiA+ICAgICAgICAgTHl1ZGUgUGF1bA0KPiA+ID4NCj4gLS0NCj4gQ2hlZXJzLA0K
PiAJTHl1ZGUgUGF1bA0KLS0NCkJlc3QgcmVnYXJkcywNCldheW5lDQo=
