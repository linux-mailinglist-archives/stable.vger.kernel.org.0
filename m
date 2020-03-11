Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327B9181416
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 10:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgCKJIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 05:08:06 -0400
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:51978 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgCKJIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 05:08:06 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 02B97qMd027659; Wed, 11 Mar 2020 18:07:52 +0900
X-Iguazu-Qid: 2wHHmtTgkJMFNf1O55
X-Iguazu-QSIG: v=2; s=0; t=1583917671; q=2wHHmtTgkJMFNf1O55; m=T9pvUaVtdcXlXHk1fcGilXOCfKr3Ua0poicjzHbiQpU=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1111) id 02B97npe011116;
        Wed, 11 Mar 2020 18:07:50 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 02B97nLH025918;
        Wed, 11 Mar 2020 18:07:49 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 02B97m4h031782;
        Wed, 11 Mar 2020 18:07:49 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BV2HWEuqqL48ASDpQY+SxDJ8Ms6L/8cwjNfDpxJ/X971wLuB029bEj8kxkyTDnuiUziCK25e+zc+x8fo+/Z4BmlDELa9yWrFkUWqiEwBOwQ/Lk1AucE1Q2GcoWK+FoqBE1h8YJVDhouJRYNWOqRHRDuvaV17zks2EvnmMikaktVDTdsYt7HpdKTTU4Fy0ipJorWQeRAyalR+hoC1ww6/KXBb8NrmSuTWpM7bcTVMsDDtia+IanP6cOfaPKGWDEDB1Dov3b2sxcRkD3PHjr2m/vCOtzGM3yN4XgoCtwpMAO31LGaMFaHCCYr893BLQbFq4Rql/azQOvSV0Ij9oyz1jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OT+B0f7zv561z/TGLZQ6jI3pa1GkubxrsQXlhdLAL4Y=;
 b=iO6WyDwLGrlJtfq/l1pfAE3yMVXpTQ+W+TNAOE613Vr8tgY0k8KABiKo5jRFemYeQ/O1qa//eQE2yYD54CETJHWq7vd/DObSRobYXWpFmCgXvcpywx6sdVy8SjDSks4ZQZDEBJ8kCia7QvdUdZRIVL/NfboiQXUnQqNyqsQgVbRqwN1G5u9C09RPUEdfoBpnAu0k95hihtfYebu1QydwjVhZgjNbNeVjI3sTvPk/tbJd/8nIWYMqMlq8OBIkCDvdvxhn8hVBV+fn0Kljumnmj84XCzUWh9+Q7XqQXMTsfNkSDvLldsFs6DUmkgqDV8TRkt4rrz0nzW5pZ+ssgRy0Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toshiba.co.jp; dmarc=pass action=none
 header.from=toshiba.co.jp; dkim=pass header.d=toshiba.co.jp; arc=none
From:   <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, <yukuai3@huawei.com>,
        <alexander.deucher@amd.com>, <sashal@kernel.org>
Subject: RE: [PATCH 4.4 035/113] drm/amdgpu: remove 4 set but not used
 variable in amdgpu_atombios_get_connector_info_from_object_table
Thread-Topic: [PATCH 4.4 035/113] drm/amdgpu: remove 4 set but not used
 variable in amdgpu_atombios_get_connector_info_from_object_table
Thread-Index: AQHV7X0fLU36CVqEc0iwb5hJdrkUP6hDK5tQ
Date:   Wed, 11 Mar 2020 09:07:47 +0000
X-TSB-HOP: ON
Message-ID: <OSAPR01MB3667601BEAABB5AF95FB799592FC0@OSAPR01MB3667.jpnprd01.prod.outlook.com>
References: <20200227132211.791484803@linuxfoundation.org>
 <20200227132217.325886959@linuxfoundation.org>
In-Reply-To: <20200227132217.325886959@linuxfoundation.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=nobuhiro1.iwamatsu@toshiba.co.jp; 
x-originating-ip: [209.137.146.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3ed348a-01d8-463a-3f58-08d7c59baadd
x-ms-traffictypediagnostic: OSAPR01MB4548:
x-microsoft-antispam-prvs: <OSAPR01MB4548FC64F48834922659023292FC0@OSAPR01MB4548.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:49;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(199004)(26005)(7696005)(71200400001)(66556008)(52536014)(64756008)(66946007)(5660300002)(8936002)(54906003)(316002)(110136005)(53546011)(33656002)(6506007)(76116006)(66476007)(66574012)(2906002)(81166006)(8676002)(81156014)(9686003)(478600001)(55016002)(186003)(66446008)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:OSAPR01MB4548;H:OSAPR01MB3667.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: toshiba.co.jp does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8G+ZyUTMME+0QnS4tju188Vkd08fXFbaYoeMi6eO7E31XzXSEOg3iMs69tpSDeqSB5KwxKRy6caluyA34VerqEJRpATspocAzHm+74ZsWSH15Ru7DlKe2WcyM//GQu9GOfG4oKoYsB2+A2WTXxOl+FoT0nGMYKga5NY4NUpmb6S1ns7kWe5wjPSVB5cJrk8hKEeVTDbr+Yhy0T5hbYZoTAJspujjFVLTEaHif5BXg2Q6BTQ1c0CsjAZ+QcuYTJvFOe2l144T7586cq10JPAN8TQ7SOc/y3SqKOF5Z5y+apyUbEQh8R2CouoeZQ05NvnGSXILq0KuWOKDwYFlOrcL6WsqlDaIkpkiThs+NyFB5xa4fC2+mctoGjNuu96KOJERMtfsKwP24iL/dZ5fk3Rif6LPZtlQHgQxJgTOZ7COMBhW2Dm/f/tFBTtSdp7fv/ig
x-ms-exchange-antispam-messagedata: Dvxl1GohIhWhPK51KxqCtq6C+sUCVsWBkLq/0TrwYAigbr8VuInS41ZXcaiD4AAUCXfWqJc/RrHeDOggOuFlYW+SS64RC9w0+Z4dQUZJSKMJZalmagWZvi0Er2YlHv/Goxsxbt0UWglxxtazFtbi4w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ed348a-01d8-463a-3f58-08d7c59baadd
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 09:07:47.2354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ybAai5/7YWpHq6q0u1vH+4TlgeeAC/Jp05Q+mzQs1x65WK8Qm4WrC1Nd9Sp++wrj0d7nI0LGjvhk7hFrPVOAvhUBE+ZMve+CcXiyLjb7eLkSijPLNbUq4goYnFyKlX2P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4548
X-OriginatorOrg: toshiba.co.jp
MSSCP.TransferMailToMossAgent: 103
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNClRoaXMgY29tbWl0IGhhcyBhIGlzc3VlIHdpdGggZHVwbGljYXRlIGdycGhfb2JqX3R5
cGUgZGVjbGFyYXRpb25zLg0KQW5kIHRoaXMgaGFzIGJlZW4gZml4ZWQgaW4gY29tbWl0OmQ3ODU0
NzZjNjA4YzYyMWIzNDVkZDkzOTZlOGIyMWU5MDM3NWNiMC4NCg0KLS0tLQ0KY29tbWl0IGQ3ODU0
NzZjNjA4YzYyMWIzNDVkZDkzOTZlOGIyMWU5MDM3NWNiMGUNCkF1dGhvcjogQ29saW4gSWFuIEtp
bmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCkRhdGU6ICAgRnJpIE5vdiA4IDE0OjQ1OjI3
IDIwMTkgKzAwMDANCg0KICAgIGRybS9hbWQvZGlzcGxheTogcmVtb3ZlIGR1cGxpY2F0ZWQgYXNz
aWdubWVudCB0byBncnBoX29ial90eXBlDQogICAgDQogICAgVmFyaWFibGUgZ3JwaF9vYmpfdHlw
ZSBpcyBiZWluZyBhc3NpZ25lZCB0d2ljZSwgb25lIG9mIHRoZXNlIGlzDQogICAgcmVkdW5kYW50
IHNvIHJlbW92ZSBpdC4NCiAgICANCiAgICBBZGRyZXNzZXMtQ292ZXJpdHk6ICgiRXZhbHVhdGlv
biBvcmRlciB2aW9sYXRpb24iKQ0KICAgIFNpZ25lZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxj
b2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQogICAgU2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVy
IDxhbGV4YW5kZXIuZGV1Y2hlckBhbWQuY29tPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQotLS0tDQoNClBsZWFzZSBhcHBseSB0byBh
bGwgTFRTIHdpdGhvdXQgMy4xNi55Lg0KDQpCZXN0IHJlZ2FyZHMsDQogIE5vYnVoaXJvDQoNCj4g
LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogc3RhYmxlLW93bmVyQHZnZXIua2Vy
bmVsLm9yZw0KPiBbbWFpbHRvOnN0YWJsZS1vd25lckB2Z2VyLmtlcm5lbC5vcmddIE9uIEJlaGFs
ZiBPZiBHcmVnIEtyb2FoLUhhcnRtYW4NCj4gU2VudDogVGh1cnNkYXksIEZlYnJ1YXJ5IDI3LCAy
MDIwIDEwOjM2IFBNDQo+IFRvOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IENjOiBH
cmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsNCj4gc3RhYmxl
QHZnZXIua2VybmVsLm9yZzsgeXUga3VhaSA8eXVrdWFpM0BodWF3ZWkuY29tPjsgQWxleCBEZXVj
aGVyDQo+IDxhbGV4YW5kZXIuZGV1Y2hlckBhbWQuY29tPjsgU2FzaGEgTGV2aW4gPHNhc2hhbEBr
ZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBbUEFUQ0ggNC40IDAzNS8xMTNdIGRybS9hbWRncHU6IHJl
bW92ZSA0IHNldCBidXQgbm90IHVzZWQNCj4gdmFyaWFibGUgaW4gYW1kZ3B1X2F0b21iaW9zX2dl
dF9jb25uZWN0b3JfaW5mb19mcm9tX29iamVjdF90YWJsZQ0KPiANCj4gRnJvbTogeXUga3VhaSA8
eXVrdWFpM0BodWF3ZWkuY29tPg0KPiANCj4gWyBVcHN0cmVhbSBjb21taXQgYmFlMDI4ZTNlNTIx
ZThjYjhjYWYyY2MxNmE0NTVjZTRjNTVmMjMzMiBdDQo+IA0KPiBGaXhlcyBnY2MgJy1XdW51c2Vk
LWJ1dC1zZXQtdmFyaWFibGUnIHdhcm5pbmc6DQo+IA0KPiBkcml2ZXJzL2dwdS9kcm0vYW1kL2Ft
ZGdwdS9hbWRncHVfYXRvbWJpb3MuYzogSW4gZnVuY3Rpb24NCj4gJ2FtZGdwdV9hdG9tYmlvc19n
ZXRfY29ubmVjdG9yX2luZm9fZnJvbV9vYmplY3RfdGFibGUnOg0KPiBkcml2ZXJzL2dwdS9kcm0v
YW1kL2FtZGdwdS9hbWRncHVfYXRvbWJpb3MuYzozNzY6MjY6IHdhcm5pbmc6DQo+IHZhcmlhYmxl
ICdncnBoX29ial9udW0nIHNldCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFi
bGVdDQo+IGRyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV9hdG9tYmlvcy5jOjM3Njox
Mzogd2FybmluZzoNCj4gdmFyaWFibGUgJ2dycGhfb2JqX2lkJyBzZXQgYnV0IG5vdCB1c2VkIFst
V3VudXNlZC1idXQtc2V0LXZhcmlhYmxlXQ0KPiBkcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9h
bWRncHVfYXRvbWJpb3MuYzozNDE6Mzc6IHdhcm5pbmc6DQo+IHZhcmlhYmxlICdjb25fb2JqX3R5
cGUnIHNldCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGVdDQo+IGRyaXZl
cnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV9hdG9tYmlvcy5jOjM0MToyNDogd2FybmluZzoN
Cj4gdmFyaWFibGUgJ2Nvbl9vYmpfbnVtJyBzZXQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1idXQt
c2V0LXZhcmlhYmxlXQ0KPiANCj4gVGhleSBhcmUgbmV2ZXIgdXNlZCwgc28gY2FuIGJlIHJlbW92
ZWQuDQo+IA0KPiBGaXhlczogZDM4Y2VhZjk5ZWQwICgiZHJtL2FtZGdwdTogYWRkIGNvcmUgZHJp
dmVyICh2NCkiKQ0KPiBTaWduZWQtb2ZmLWJ5OiB5dSBrdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+
DQo+IFNpZ25lZC1vZmYtYnk6IEFsZXggRGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPg0KPiAt
LS0NCj4gIGRyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV9hdG9tYmlvcy5jIHwgMTkg
KystLS0tLS0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MTcgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2FtZC9h
bWRncHUvYW1kZ3B1X2F0b21iaW9zLmMNCj4gYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9h
bWRncHVfYXRvbWJpb3MuYw0KPiBpbmRleCAzZTkwZGRjYmIyNGE3Li5kNzk5OTI3ZDNhNWRlIDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfYXRvbWJpb3Mu
Yw0KPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfYXRvbWJpb3MuYw0K
PiBAQCAtMzE5LDE3ICszMTksOSBAQCBib29sDQo+IGFtZGdwdV9hdG9tYmlvc19nZXRfY29ubmVj
dG9yX2luZm9fZnJvbV9vYmplY3RfdGFibGUoc3RydWN0DQo+IGFtZGdwdV9kZXZpY2UgKg0KPiAg
CQlwYXRoX3NpemUgKz0gbGUxNl90b19jcHUocGF0aC0+dXNTaXplKTsNCj4gDQo+ICAJCWlmIChk
ZXZpY2Vfc3VwcG9ydCAmIGxlMTZfdG9fY3B1KHBhdGgtPnVzRGV2aWNlVGFnKSkgew0KPiAtCQkJ
dWludDhfdCBjb25fb2JqX2lkLCBjb25fb2JqX251bSwgY29uX29ial90eXBlOw0KPiAtDQo+IC0J
CQljb25fb2JqX2lkID0NCj4gKwkJCXVpbnQ4X3QgY29uX29ial9pZCA9DQo+ICAJCQkgICAgKGxl
MTZfdG9fY3B1KHBhdGgtPnVzQ29ubk9iamVjdElkKSAmDQo+IE9CSkVDVF9JRF9NQVNLKQ0KPiAg
CQkJICAgID4+IE9CSkVDVF9JRF9TSElGVDsNCj4gLQkJCWNvbl9vYmpfbnVtID0NCj4gLQkJCSAg
ICAobGUxNl90b19jcHUocGF0aC0+dXNDb25uT2JqZWN0SWQpICYNCj4gRU5VTV9JRF9NQVNLKQ0K
PiAtCQkJICAgID4+IEVOVU1fSURfU0hJRlQ7DQo+IC0JCQljb25fb2JqX3R5cGUgPQ0KPiAtCQkJ
ICAgIChsZTE2X3RvX2NwdShwYXRoLT51c0Nvbm5PYmplY3RJZCkgJg0KPiAtCQkJICAgICBPQkpF
Q1RfVFlQRV9NQVNLKSA+PiBPQkpFQ1RfVFlQRV9TSElGVDsNCj4gDQo+ICAJCQkvKiBTa2lwIFRW
L0NWIHN1cHBvcnQgKi8NCj4gIAkJCWlmICgobGUxNl90b19jcHUocGF0aC0+dXNEZXZpY2VUYWcp
ID09IEBADQo+IC0zNTQsMTQgKzM0Niw3IEBAIGJvb2wNCj4gYW1kZ3B1X2F0b21iaW9zX2dldF9j
b25uZWN0b3JfaW5mb19mcm9tX29iamVjdF90YWJsZShzdHJ1Y3QNCj4gYW1kZ3B1X2RldmljZSAq
DQo+ICAJCQlyb3V0ZXIuZGRjX3ZhbGlkID0gZmFsc2U7DQo+ICAJCQlyb3V0ZXIuY2RfdmFsaWQg
PSBmYWxzZTsNCj4gIAkJCWZvciAoaiA9IDA7IGogPCAoKGxlMTZfdG9fY3B1KHBhdGgtPnVzU2l6
ZSkgLSA4KQ0KPiAvIDIpOyBqKyspIHsNCj4gLQkJCQl1aW50OF90IGdycGhfb2JqX2lkLCBncnBo
X29ial9udW0sDQo+IGdycGhfb2JqX3R5cGU7DQo+IC0NCj4gLQkJCQlncnBoX29ial9pZCA9DQo+
IC0NCj4gKGxlMTZfdG9fY3B1KHBhdGgtPnVzR3JhcGhpY09iaklkc1tqXSkgJg0KPiAtCQkJCSAg
ICAgT0JKRUNUX0lEX01BU0spID4+DQo+IE9CSkVDVF9JRF9TSElGVDsNCj4gLQkJCQlncnBoX29i
al9udW0gPQ0KPiAtDQo+IChsZTE2X3RvX2NwdShwYXRoLT51c0dyYXBoaWNPYmpJZHNbal0pICYN
Cj4gLQkJCQkgICAgIEVOVU1fSURfTUFTSykgPj4gRU5VTV9JRF9TSElGVDsNCj4gKwkJCQl1aW50
OF90IGdycGhfb2JqX3R5cGU9DQo+ICAJCQkJZ3JwaF9vYmpfdHlwZSA9DQo+IA0KPiAobGUxNl90
b19jcHUocGF0aC0+dXNHcmFwaGljT2JqSWRzW2pdKSAmDQo+ICAJCQkJICAgICBPQkpFQ1RfVFlQ
RV9NQVNLKSA+Pg0KPiBPQkpFQ1RfVFlQRV9TSElGVDsNCj4gLS0NCj4gMi4yMC4xDQo+IA0KPiAN
Cg0K
