Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F60972CE4
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 13:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfGXLJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 07:09:45 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17262 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfGXLJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 07:09:45 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d383c7c0001>; Wed, 24 Jul 2019 04:09:50 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 24 Jul 2019 04:09:42 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 24 Jul 2019 04:09:42 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 24 Jul
 2019 11:09:40 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 24 Jul
 2019 11:09:38 +0000
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (104.47.41.56) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 24 Jul 2019 11:09:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckP0nL0YDzXe0DcPvyin++hfpn3JNDcY2KSJ8psP6Szbp/LcvqkG7ywca18Bxt9o9BoopK4mMuZ+HhmA1aYlhLj0mYCvKpFI07kpfJWcKGn/ldXeGX7ItfYeMJwkZVbogKeMexyYMhxs+w6iMH+qaFyh+9A57dWjz2bwDOdghZFcIrrSHQzn+xHxpmHs6iDuNPpg0VmHx+TzSgeWiVCtaVyGcwSZp7scFyuOD82lBxs/L54gmZEHiIyrqvblCOW4Z0h5OQQnMY4RP8P6UeFCjykDtIN2fOMfJqCKvFUt815hRhGUqtiZLkfY5Se/S0DbHI+Gh6GzwjBluPtVTkOH0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64pvQAzngqMk7AG89Gc1hIlBoPRTyU24GqBquAM9mAA=;
 b=cGJYo3slFbCeUI6WgEsAKXkJhwxFsNJrjG32foGf091RlFN37aKtHXthnbRdp8u9ywBI2Jqy3nT1AHFcdmKljhb+So8R+D6lUg7DulW2b2HBx12mXPb4qn9Q/5V9YKZBdZHuBrirF9A8fw9QcYqGG1YVrWMpbJ0Eqt405QnScS0IGq+5bYKlxJsSPGPcEL48vtuS98c70kO8irts9liuIt9PIypvKTTIAkQikCsnDs1fPeISp8vDkelL9Jl80MHBsycJ31eGTy5sqtn7nDO+QCsMg4SCriqRgOSPxtxPa1//k80qxnJSR1rJB0JP3wXLoGI2LZxCaPH0NqtvOwXGdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nvidia.com;dmarc=pass action=none
 header.from=nvidia.com;dkim=pass header.d=nvidia.com;arc=none
Received: from MN2PR12MB3134.namprd12.prod.outlook.com (20.178.241.79) by
 MN2PR12MB3662.namprd12.prod.outlook.com (10.255.86.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.12; Wed, 24 Jul 2019 11:09:19 +0000
Received: from MN2PR12MB3134.namprd12.prod.outlook.com
 ([fe80::dc51:e88a:6b19:84e6]) by MN2PR12MB3134.namprd12.prod.outlook.com
 ([fe80::dc51:e88a:6b19:84e6%6]) with mapi id 15.20.2094.013; Wed, 24 Jul 2019
 11:09:19 +0000
From:   Viswanath L <viswanathl@nvidia.com>
To:     Dmitry Osipenko <digetx@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>
CC:     "airlied@linux.ie" <airlied@linux.ie>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3] drm/tegra: sor: Enable HDA interrupts at plug-in
Thread-Topic: [PATCH v3] drm/tegra: sor: Enable HDA interrupts at plug-in
Thread-Index: AQHVQVPTsv4j3faqzkWrVfHN7h03fqbZgXuAgAAcNvA=
Date:   Wed, 24 Jul 2019 11:09:18 +0000
Message-ID: <MN2PR12MB313403F2CB9F8105C1DDFD39ADC60@MN2PR12MB3134.namprd12.prod.outlook.com>
References: <1563885610-27198-1-git-send-email-viswanathl@nvidia.com>
 <0ba35efb-44ec-d56c-b559-59f1daa3e6e4@gmail.com>
In-Reply-To: <0ba35efb-44ec-d56c-b559-59f1daa3e6e4@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Enabled=True;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SiteId=43083d15-7273-40c1-b7db-39efd9ccc17a;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Owner=viswanathl@nvidia.com;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SetDate=2019-07-24T11:09:15.9077751Z;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Name=Unrestricted;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_ActionId=78b9a304-82b9-40b2-8a59-ce2eaa89d11e;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=viswanathl@nvidia.com; 
x-originating-ip: [121.244.166.165]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb1920a6-23bc-4a97-73b4-08d710275fce
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR12MB3662;
x-ms-traffictypediagnostic: MN2PR12MB3662:
x-microsoft-antispam-prvs: <MN2PR12MB366286E244EE8371921F3329ADC60@MN2PR12MB3662.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(136003)(39860400002)(396003)(199004)(189003)(13464003)(33656002)(76116006)(2501003)(86362001)(5660300002)(25786009)(54906003)(52536014)(316002)(110136005)(478600001)(8936002)(81166006)(81156014)(68736007)(76176011)(8676002)(14454004)(66066001)(7696005)(99286004)(66446008)(64756008)(66556008)(66476007)(66946007)(102836004)(53936002)(26005)(2906002)(6436002)(6506007)(53546011)(7736002)(305945005)(6246003)(186003)(74316002)(71200400001)(71190400001)(6636002)(55016002)(229853002)(256004)(14444005)(9686003)(486006)(11346002)(476003)(4326008)(6116002)(3846002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB3662;H:MN2PR12MB3134.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nvidia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RjE2SGH3f2a/ndjwTxvkEDwp9DwGAkZvhL/Lx4LwL4pt4d9rp35ig5jEQmUB+zPHSxGoeE7+/SZlMLRAuBovTenP6zHQ/h8gtdKu+HEaDvKVQSbXQYxZoDiAesYazg3Oaq7F0lFPSszmcAgo9lWRO4LepFgz3mTsJ/Zrq4NWbRrKoXOtnMA62/wiULcxFppny/an70nbSt1s03rHQa7cz1BGNymggSQnITso1fnru4XeERzWLiI+nNM866aKEkKshvaan4ssi0T0wK/Awe3ngaxp/gYtegTzbxfSdtZMgP6A0JQcaL5nLMqAyLcDZKqrl/oXSaAUMW0IfWe9OBeW5AnwxxZ/I3GtFBTIiULE8aurEaLGfFzSgOxbF8WR6D9z4C+G4J5jQutRg4xOgeQt0qHcAiw6n/E8kqb2tEz4crA=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fb1920a6-23bc-4a97-73b4-08d710275fce
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 11:09:19.2339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: viswanathl@nvidia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3662
X-OriginatorOrg: Nvidia.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563966590; bh=64pvQAzngqMk7AG89Gc1hIlBoPRTyU24GqBquAM9mAA=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-forefront-prvs:
         x-forefront-antispam-report:received-spf:
         x-ms-exchange-senderadcheck:x-microsoft-antispam-message-info:
         MIME-Version:X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg:
         Content-Language:Content-Type:Content-Transfer-Encoding;
        b=KDCBOWKwk7+x8KwMecRJ8kdlxQYBwGmHmUsTHqVLdQWoQDYMxuWuXm4khoEBCzMjU
         Zr4OK6EieWav5bWcWpsYni+LWsSvq0w/uVJrLxo4Um/T3AQXcU2uEQrYj2dtQdagfz
         29Zr3kc8RRaNxgzf95sclAWg4WhUr5jv4YfpwVFZ/NPF8zvu4L6iUGvO3XKqK+7ODL
         vYQGnsd+/5VxHRE6rLFLB+pVxTJeXG+IQvk9Zrf8b/RFNQtmpKFAK3wVxVWxy2yGnV
         i4DjpP4oTu58cek4rjiA7aHPZG7EZiLtiFNQ2BkVq39Y0TbMYkTPpG5vGqzQ9wRA7F
         Gs2ONLuy2lODg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhhbmtzIHZlcnkgbXVjaCBmb3IgdGhlIHJldmlldywgRG1pdHJ5IQ0KDQotLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KRnJvbTogRG1pdHJ5IE9zaXBlbmtvIDxkaWdldHhAZ21haWwuY29tPiAN
ClNlbnQ6IFdlZG5lc2RheSwgSnVseSAyNCwgMjAxOSAyOjU4IFBNDQpUbzogVmlzd2FuYXRoIEwg
PHZpc3dhbmF0aGxAbnZpZGlhLmNvbT47IHRoaWVycnkucmVkaW5nQGdtYWlsLmNvbTsgSm9uYXRo
YW4gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNvbT4NCkNjOiBhaXJsaWVkQGxpbnV4LmllOyBk
YW5pZWxAZmZ3bGwuY2g7IGRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmc7IGxpbnV4LXRl
Z3JhQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgc3RhYmxl
QHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogUmU6IFtQQVRDSCB2M10gZHJtL3RlZ3JhOiBzb3I6
IEVuYWJsZSBIREEgaW50ZXJydXB0cyBhdCBwbHVnLWluDQoNCjIzLjA3LjIwMTkgMTU6NDAsIFZp
c3dhbmF0aCBMINC/0LjRiNC10YI6DQo+IEhETUkgcGx1Z291dCBjYWxscyBydW50aW1lIHN1c3Bl
bmQsIHdoaWNoIGNsZWFycyBpbnRlcnJ1cHQgcmVnaXN0ZXJzIA0KPiBhbmQgY2F1c2VzIGF1ZGlv
IGZ1bmN0aW9uYWxpdHkgdG8gYnJlYWsgb24gc3Vic2VxdWVudCBwbHVnLWluOyBzZXR0aW5nIA0K
PiBpbnRlcnJ1cHQgcmVnaXN0ZXJzIGluIHNvcl9hdWRpb19wcmVwYXJlKCkgc29sdmVzIHRoZSBp
c3N1ZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFZpc3dhbmF0aCBMIDx2aXN3YW5hdGhsQG52aWRp
YS5jb20+DQoNCllvdXJzIHNpZ25lZC1vZmYtYnkgYWx3YXlzIHNob3VsZCBiZSB0aGUgbGFzdCBs
aW5lIG9mIHRoZSBjb21taXQncyBtZXNzYWdlIGJlY2F1c2UgdGhlIHRleHQgYmVsb3cgaXQgYmVs
b25ncyB0byBhIHBlcnNvbiB3aG8gYXBwbGllcyB0aGlzIHBhdGNoLCBUaGllcnJ5IGluIHRoaXMg
Y2FzZS4gVGhpcyBpcyBub3QgYSBiaWcgZGVhbCBhdCBhbGwgYW5kIFRoaWVycnkgY291bGQgbWFr
ZSBhIGZpeHVwIHdoaWxlIGFwcGx5aW5nIHRoZSBwYXRjaCBpZiB3aWxsIGRlZW0gdGhhdCBhcyBu
ZWNlc3NhcnkuDQoNClNlY29uZGx5LCB0aGVyZSBpcyBubyBuZWVkIHRvIGFkZCAic3RhYmxlQHZn
ZXIua2VybmVsLm9yZyIgdG8gdGhlIGVtYWlsJ3MgcmVjaXBpZW50cyBiZWNhdXNlIHRoZSBwYXRj
aCB3aWxsIGZsb3cgaW50byBzdGFibGUga2VybmVsIHZlcnNpb25zIGZyb20gdGhlIG1haW5saW5l
IG9uY2UgaXQgd2lsbCBnZXQgYXBwbGllZC4gVGhhdCBoYXBwZW5zIGJhc2VkIG9uIHRoZSBzdGFi
bGUgdGFnIHByZXNlbmNlLCBoZW5jZSBpdCdzIGVub3VnaCB0byBhZGQgdGhlICdDYycgdGFnIHRv
IHRoZSBjb21taXQncyBtZXNzYWdlIGluIG9yZGVyIHRvIGdldCBwYXRjaCBiYWNrcG9ydGVkLg0K
DQpMYXN0bHksIG5leHQgdGltZSBwbGVhc2UgYWRkIGV2ZXJ5b25lIHRvIHRoZSBlbWFpbCdzIHJl
Y2lwaWVudHMgd2hvbSB5b3UncmUgZXhwZWN0aW5nIHRvIGdldCBhIHJlcGx5LiBPdGhlcndpc2Ug
dGhlcmUgaXMgYSBjaGFuY2UgdGhhdCBwYXRjaCB3aWxsIGJlIGxlZnQgdW5ub3RpY2VkLg0KDQpF
dmVyeXRoaW5nIGVsc2UgbG9va3MgZ29vZCB0byBtZSwgdGhhbmtzIQ0KDQpSZXZpZXdlZC1ieTog
RG1pdHJ5IE9zaXBlbmtvIDxkaWdldHhAZ21haWwuY29tPg0KDQo+IEZpeGVzOiA4ZTI5ODhhNzZj
MjYgKCJkcm0vdGVncmE6IHNvcjogU3VwcG9ydCBmb3IgYXVkaW8gb3ZlciBIRE1JIikNCj4gQ2M6
IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMvZ3B1L2RybS90ZWdy
YS9zb3IuYyB8IDE4ICsrKysrKysrKy0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDkgaW5z
ZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2dw
dS9kcm0vdGVncmEvc29yLmMgYi9kcml2ZXJzL2dwdS9kcm0vdGVncmEvc29yLmMgDQo+IGluZGV4
IDViZTVhMDguLjA0NzBjZmUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS90ZWdyYS9z
b3IuYw0KPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vdGVncmEvc29yLmMNCj4gQEAgLTIxNjQsNiAr
MjE2NCwxNSBAQCBzdGF0aWMgdm9pZCB0ZWdyYV9zb3JfYXVkaW9fcHJlcGFyZShzdHJ1Y3QgDQo+
IHRlZ3JhX3NvciAqc29yKQ0KPiAgDQo+ICAJdmFsdWUgPSBTT1JfQVVESU9fSERBX1BSRVNFTlNF
X0VMRFYgfCBTT1JfQVVESU9fSERBX1BSRVNFTlNFX1BEOw0KPiAgCXRlZ3JhX3Nvcl93cml0ZWwo
c29yLCB2YWx1ZSwgU09SX0FVRElPX0hEQV9QUkVTRU5TRSk7DQo+ICsNCj4gKwkvKg0KPiArCSAq
IEVuYWJsZSBhbmQgdW5tYXNrIHRoZSBIREEgY29kZWMgU0NSQVRDSDAgcmVnaXN0ZXIgaW50ZXJy
dXB0LiBUaGlzDQo+ICsJICogaXMgdXNlZCBmb3IgaW50ZXJvcGVyYWJpbGl0eSBiZXR3ZWVuIHRo
ZSBIREEgY29kZWMgZHJpdmVyIGFuZCB0aGUNCj4gKwkgKiBIRE1JL0RQIGRyaXZlci4NCj4gKwkg
Ki8NCj4gKwl2YWx1ZSA9IFNPUl9JTlRfQ09ERUNfU0NSQVRDSDEgfCBTT1JfSU5UX0NPREVDX1ND
UkFUQ0gwOw0KPiArCXRlZ3JhX3Nvcl93cml0ZWwoc29yLCB2YWx1ZSwgU09SX0lOVF9FTkFCTEUp
Ow0KPiArCXRlZ3JhX3Nvcl93cml0ZWwoc29yLCB2YWx1ZSwgU09SX0lOVF9NQVNLKTsNCj4gIH0N
Cj4gIA0KPiAgc3RhdGljIHZvaWQgdGVncmFfc29yX2F1ZGlvX3VucHJlcGFyZShzdHJ1Y3QgdGVn
cmFfc29yICpzb3IpIEBAIA0KPiAtMjkxMywxNSArMjkyMiw2IEBAIHN0YXRpYyBpbnQgdGVncmFf
c29yX2luaXQoc3RydWN0IGhvc3QxeF9jbGllbnQgKmNsaWVudCkNCj4gIAlpZiAoZXJyIDwgMCkN
Cj4gIAkJcmV0dXJuIGVycjsNCj4gIA0KPiAtCS8qDQo+IC0JICogRW5hYmxlIGFuZCB1bm1hc2sg
dGhlIEhEQSBjb2RlYyBTQ1JBVENIMCByZWdpc3RlciBpbnRlcnJ1cHQuIFRoaXMNCj4gLQkgKiBp
cyB1c2VkIGZvciBpbnRlcm9wZXJhYmlsaXR5IGJldHdlZW4gdGhlIEhEQSBjb2RlYyBkcml2ZXIg
YW5kIHRoZQ0KPiAtCSAqIEhETUkvRFAgZHJpdmVyLg0KPiAtCSAqLw0KPiAtCXZhbHVlID0gU09S
X0lOVF9DT0RFQ19TQ1JBVENIMSB8IFNPUl9JTlRfQ09ERUNfU0NSQVRDSDA7DQo+IC0JdGVncmFf
c29yX3dyaXRlbChzb3IsIHZhbHVlLCBTT1JfSU5UX0VOQUJMRSk7DQo+IC0JdGVncmFfc29yX3dy
aXRlbChzb3IsIHZhbHVlLCBTT1JfSU5UX01BU0spOw0KPiAtDQo+ICAJcmV0dXJuIDA7DQo+ICB9
DQo+ICANCj4gDQoNCg==
