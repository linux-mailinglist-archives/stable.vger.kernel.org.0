Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18AEB98154
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 19:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfHURdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 13:33:55 -0400
Received: from mail-eopbgr810059.outbound.protection.outlook.com ([40.107.81.59]:11295
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726530AbfHURdz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 13:33:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cwy0ocXiVUTwqXSdywKfZ0dbbhIKQcaUPo8PAVFzmkWHNdnmRb8LYNuhjcpw4nTuvZNp2GR42vWkWVjNH9w0Bc5bWy/CHOTz2p3smcuSfsbLuYKqlnRA0zZOh2scxZ6fYP3kw+SIAAE1HVXZMdJtlV3aqvObG0HX4QPZ1s63KHSNtQFAbuoiN+AReGo20ynC+1zu5pnPfHFZrrazdewp/mxDsMc0L7JjZ+LYmNR+auRIwOQMlQ4nEWqYqkqJPdsw9r96VuuN7YMXjh1+EB22kWwWbTXT4XeJlXa74FcOFD82Oyoh8FZCUjTgOB0hCLUWXOhMVIxaODPtU3i7VGZQfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSA5EPQNyFq9NZfMRdAGYCZOhFS7vuGJ/9T5ypzq/zI=;
 b=PxFjP7nVsmu9TTmoUTf94CfOEWlWQrt11FiLPcEelzbWXEj/hSFBTIq5xmUymBxZX7+Rb4Qb9ILCaUdL/SQaFHXV6m1LoomfTWO8rsfOHqeQNG4+ihlxKyw2NojleQ6tPdAbFIyiigM27laH1O6dktNNdvkQ+371SgARYuBDplRTt4YVodoXl2ZRRR+Cw8KEZTp1kxXqdzwunZZGlnFMIpDPImq9gmNg81iEJPrCkC/4ne3n+frsmSfSzlPn4Vl+9225zIaZzp0h9jPgFhdkaL3Fgdy3yZXYckrpCb4huhjY2Mx+/HPKPiC6OaZW4ux9QdvjGMng+2OhpSN1LXsMIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSA5EPQNyFq9NZfMRdAGYCZOhFS7vuGJ/9T5ypzq/zI=;
 b=BUwJo38LyEXoH113k0VlQhdJzGr+9giywQ/hjHxKQjNcO755VfJEyMNuLoBGrq8KMwZtVcJyBRqya4VE+vct5qO/+Aw8J5+UeeLTzSwKalXcbZyHo6BhjBFH3+FFfgQ63046o28W/Ub5axToueKJaTsI6hsPfLgZCPqCkiF5aFI=
Received: from DM6PR12MB2603.namprd12.prod.outlook.com (20.176.116.84) by
 DM6PR12MB3754.namprd12.prod.outlook.com (10.255.172.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Wed, 21 Aug 2019 17:33:51 +0000
Received: from DM6PR12MB2603.namprd12.prod.outlook.com
 ([fe80::c90f:5f8:954c:e663]) by DM6PR12MB2603.namprd12.prod.outlook.com
 ([fe80::c90f:5f8:954c:e663%7]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 17:33:51 +0000
From:   "Li, Sun peng (Leo)" <Sunpeng.Li@amd.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lyude Paul <lyude@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <sean@poorly.run>
Subject: Re: [PATCH] drm/i915: Do not create a new max_bpc prop for MST
 connectors
Thread-Topic: [PATCH] drm/i915: Do not create a new max_bpc prop for MST
 connectors
Thread-Index: AQHVV3KzIqBXZmVtEkGYuBe/HG5746cF3kmA
Date:   Wed, 21 Aug 2019 17:33:50 +0000
Message-ID: <bc6eeeb2-5f84-47bb-95c6-322b24a4cee6@amd.com>
References: <20190820161657.9658-1-ville.syrjala@linux.intel.com>
In-Reply-To: <20190820161657.9658-1-ville.syrjala@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YT1PR01CA0031.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::44)
 To DM6PR12MB2603.namprd12.prod.outlook.com (2603:10b6:5:49::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Sunpeng.Li@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.55.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5b82897-189e-43e4-881f-08d7265dbaef
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3754;
x-ms-traffictypediagnostic: DM6PR12MB3754:
x-microsoft-antispam-prvs: <DM6PR12MB3754F4E0AE88C0195F31164682AA0@DM6PR12MB3754.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(189003)(199004)(478600001)(31696002)(5660300002)(256004)(5024004)(26005)(14454004)(186003)(316002)(2906002)(14444005)(54906003)(66574012)(102836004)(110136005)(53936002)(86362001)(81166006)(6246003)(8676002)(229853002)(31686004)(3846002)(71190400001)(71200400001)(66476007)(66556008)(64756008)(66446008)(476003)(2616005)(7736002)(4326008)(486006)(8936002)(81156014)(66946007)(11346002)(99286004)(66066001)(305945005)(6116002)(53546011)(6506007)(386003)(36756003)(6512007)(52116002)(6486002)(6436002)(2501003)(76176011)(446003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3754;H:DM6PR12MB2603.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2dt2xyCUeU/lWOukzqece55p6VLxqD4XoZTwpVPYZqMouxjA1Leq5Hwipjd3DBO9hVbrOBI2HVmfUDZDcskYPBRatlP3cxpRi86zDa4END8UUX3ZNCnXILUe3o/aYw7pjVcZC2qjUifsgshEt5eXseLJJZlBHIwr04m/vXsN0kCYGzeTbKA4TlDT1uO/r52O6nOqJiPzJeCYhBl0KiGJvIgXNVOGjNKYCzBuuSKj5jB5fBYp52C/J+j6YudWqxixs1Zmm4PEs4sKwnsppUAzZnNhY0v9Q9lAI33bAaXCloBU93Tp0QeaW92DgvKpvNCEgELcig8rmuqog0wB7WpnBjEzUdD6UPPq8PUP/MTf7EEmKBkEyV3JuWlvmP99eveziqvEku5KZJR/LoSzfX/+D3hucBUzdxoK9BCuxSDRH2g=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <44A354A7C5EFBE4794E8707C45443DBB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b82897-189e-43e4-881f-08d7265dbaef
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 17:33:50.9077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1ffcLyGlIZesV6gpTSVVLRgr6nVdEWIgRINZxYmEpNWaSS10fzLdvtCF387fACz0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3754
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCk9uIDIwMTktMDgtMjAgMTI6MTYgcC5tLiwgVmlsbGUgU3lyamFsYSB3cm90ZToNCj4gRnJv
bTogVmlsbGUgU3lyasOkbMOkIDx2aWxsZS5zeXJqYWxhQGxpbnV4LmludGVsLmNvbT4NCj4gDQo+
IFdlJ3JlIG5vdCBhbGxvd2VkIHRvIGNyZWF0ZSBuZXcgcHJvcGVydGllcyBhZnRlciBkZXZpY2Ug
cmVnaXN0cmF0aW9uDQo+IHNvIGZvciBNU1QgY29ubmVjdG9ycyB3ZSBuZWVkIHRvIGVpdGhlciBj
cmVhdGUgdGhlIG1heF9icGMgcHJvcGVydHkNCj4gZWFybGllciwgb3Igd2UgcmV1c2Ugb25lIHdl
IGFscmVhZHkgaGF2ZS4gTGV0J3MgZG8gdGhlIGxhdHRlciBhcHBvcmFjaA0KPiBzaW5jZSB0aGUg
Y29ycmVzcG9uZGluZyBTU1QgY29ubmVjdG9yIGFscmVhZHkgaGFzIHRoZSBwcm9wIGFuZCBpdHMN
Cj4gbWluL21heCBhcmUgY29ycmVjdCBhbHNvIGZvciB0aGUgTVNUIGNvbm5lY3Rvci4NCj4gDQo+
IFRoZSBwcm9ibGVtIHdhcyBoaWdobGlnaHRlZCBieSBjb21taXQgNGY1MzY4YjU1NDFhICgiZHJt
L2ttczoNCj4gQ2F0Y2ggbW9kZV9vYmplY3QgbGlmZXRpbWUgZXJyb3JzIikgd2hpY2ggcmVzdWx0
cyBpbiB0aGUgZm9sbG93aW5nDQo+IHNwZXc6DQo+IFsgMTMzMC44Nzg5NDFdIFdBUk5JTkc6IENQ
VTogMiBQSUQ6IDE1NTQgYXQgZHJpdmVycy9ncHUvZHJtL2RybV9tb2RlX29iamVjdC5jOjQ1IF9f
ZHJtX21vZGVfb2JqZWN0X2FkZCsweGEwLzB4YjAgW2RybV0NCj4gLi4uDQo+IFsgMTMzMC44Nzkw
MDhdIENhbGwgVHJhY2U6DQo+IFsgMTMzMC44NzkwMjNdICBkcm1fcHJvcGVydHlfY3JlYXRlKzB4
YmEvMHgxODAgW2RybV0NCj4gWyAxMzMwLjg3OTAzNl0gIGRybV9wcm9wZXJ0eV9jcmVhdGVfcmFu
Z2UrMHgxNS8weDMwIFtkcm1dDQo+IFsgMTMzMC44NzkwNDhdICBkcm1fY29ubmVjdG9yX2F0dGFj
aF9tYXhfYnBjX3Byb3BlcnR5KzB4NjIvMHg4MCBbZHJtXQ0KPiBbIDEzMzAuODc5MDg2XSAgaW50
ZWxfZHBfYWRkX21zdF9jb25uZWN0b3IrMHgxMWYvMHgxNDAgW2k5MTVdDQo+IFsgMTMzMC44Nzkw
OTRdICBkcm1fZHBfYWRkX3BvcnQuaXNyYS4yMCsweDIwYi8weDQ0MCBbZHJtX2ttc19oZWxwZXJd
DQo+IC4uLg0KPiANCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IEx5dWRlIFBh
dWwgPGx5dWRlQHJlZGhhdC5jb20+DQo+IENjOiBzdW5wZW5nLmxpQGFtZC5jb20NCj4gQ2M6IERh
bmllbCBWZXR0ZXIgPGRhbmllbC52ZXR0ZXJAZmZ3bGwuY2g+DQo+IENjOiBTZWFuIFBhdWwgPHNl
YW5AcG9vcmx5LnJ1bj4NCj4gRml4ZXM6IDVjYTBlZjhhNTZiOCAoImRybS9pOTE1OiBBZGQgbWF4
X2JwYyBwcm9wZXJ0eSBmb3IgRFAgTVNUIikNCj4gU2lnbmVkLW9mZi1ieTogVmlsbGUgU3lyasOk
bMOkIDx2aWxsZS5zeXJqYWxhQGxpbnV4LmludGVsLmNvbT4NCg0KVGhhbmtzIGZvciBmb2xsb3dp
bmcgdXAsIEkgaGFkIGZvcmdvdHRlbiBhYm91dCB0aGlzIGlzc3VlLg0KUmV2aWV3ZWQtYnk6IExl
byBMaSA8c3VucGVuZy5saUBhbWQuY29tPg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9ncHUvZHJtL2k5
MTUvZGlzcGxheS9pbnRlbF9kcF9tc3QuYyB8IDEwICsrKysrKysrKy0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCA5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL2dwdS9kcm0vaTkxNS9kaXNwbGF5L2ludGVsX2RwX21zdC5jIGIvZHJpdmVycy9ncHUv
ZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9kcF9tc3QuYw0KPiBpbmRleCA4M2ZhYTI0NmUzNjEuLjk3
NDg1ODFjMWQ2MiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9p
bnRlbF9kcF9tc3QuYw0KPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9kaXNwbGF5L2ludGVs
X2RwX21zdC5jDQo+IEBAIC01MzYsNyArNTM2LDE1IEBAIHN0YXRpYyBzdHJ1Y3QgZHJtX2Nvbm5l
Y3RvciAqaW50ZWxfZHBfYWRkX21zdF9jb25uZWN0b3Ioc3RydWN0IGRybV9kcF9tc3RfdG9wb2xv
DQo+ICANCj4gIAlpbnRlbF9hdHRhY2hfZm9yY2VfYXVkaW9fcHJvcGVydHkoY29ubmVjdG9yKTsN
Cj4gIAlpbnRlbF9hdHRhY2hfYnJvYWRjYXN0X3JnYl9wcm9wZXJ0eShjb25uZWN0b3IpOw0KPiAt
CWRybV9jb25uZWN0b3JfYXR0YWNoX21heF9icGNfcHJvcGVydHkoY29ubmVjdG9yLCA2LCAxMik7
DQo+ICsNCj4gKwkvKg0KPiArCSAqIFJldXNlIHRoZSBwcm9wIGZyb20gdGhlIFNTVCBjb25uZWN0
b3IgYmVjYXVzZSB3ZSdyZQ0KPiArCSAqIG5vdCBhbGxvd2VkIHRvIGNyZWF0ZSBuZXcgcHJvcHMg
YWZ0ZXIgZGV2aWNlIHJlZ2lzdHJhdGlvbi4NCj4gKwkgKi8NCj4gKwljb25uZWN0b3ItPm1heF9i
cGNfcHJvcGVydHkgPQ0KPiArCQlpbnRlbF9kcC0+YXR0YWNoZWRfY29ubmVjdG9yLT5iYXNlLm1h
eF9icGNfcHJvcGVydHk7DQo+ICsJaWYgKGNvbm5lY3Rvci0+bWF4X2JwY19wcm9wZXJ0eSkNCj4g
KwkJZHJtX2Nvbm5lY3Rvcl9hdHRhY2hfbWF4X2JwY19wcm9wZXJ0eShjb25uZWN0b3IsIDYsIDEy
KTsNCj4gIA0KPiAgCXJldHVybiBjb25uZWN0b3I7DQo+ICANCj4gDQo=
