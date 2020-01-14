Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2781813AC56
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 15:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgANOba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 09:31:30 -0500
Received: from mail-bn8nam12on2084.outbound.protection.outlook.com ([40.107.237.84]:2528
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726106AbgANOba (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 09:31:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgLy0sExbzTgvwqLG5tCMm8M5Nbq2HeRwoq2LqHNijsSSJuNsJNr+7of0VBQccRwf5QbySo1hZGAsCpY8bBpO4k6MG4F+2uq7J2GcUYFXQXl512pS9dbNcN3cNusvsI2B3meukABsOW2C8t5+hqYho+d22a62rlVdNTkcVgql9v1iTnMB49lOQcq/L6iky5CW5MUHM6LyILJb8WvfNIJIMsZd61U/gVm7LR5zF4hcoCBIR/mTplQJKzPpG533KjzQHfwX2+JxSSKAwBqPwP3bA2ZiZEhEM5x4ZjYv+mU3JyNCmHLLh3HRMX1IqN8wawROxANj5kKmDv44KWPPkHoIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88mtFDR2RiQLZAV13ioiV2tbrLECDCRfWlfjEZpGbso=;
 b=RdQEBh5L6Oq0lbtVZdP2oz511GwsNyqdMrkgG3epQ3s63kPM/g1bjNHm63/DTGjOX18Xy/IKsh9n7TIPhNDcQNorkPiM/HmrB7AeqSGJGjdUxmhBlET9F5AWFDIpTwfTQal8dASZlLQsbnb9RipaBp5RskN+sMUiic/j9QgsgDKAkWnwGUpCWCbRV8OLKND7DGGM2mUAKklBc5wQ15imD/UbztLfv79MuHsZISWkfzt8J4RUoq81De3Y5VN6n2Cy9oaeI3Qjsk2Ioa/CwTRM9KdbV+wwBFJmby828GjJefFBdX0+VIPo40EDr09ruCsHyS4OrTGhg5mdGY7IbjZ0NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88mtFDR2RiQLZAV13ioiV2tbrLECDCRfWlfjEZpGbso=;
 b=Oc0uGlYiZLCXfmVBS+sm3pBA6KdSiRXVQaXXBZgFMbutmKNQxQxItMvl5CkDMNdm8F/1u/Puar1hiXWx592xPRkz9dzfOY0tgf6bFPktOiRMlVRPPCz2YG04EbeoLzU6+HWeYiAyRNI1fd/G7bjaGmTCH7iQpO8/rrtsxNdK28U=
Received: from CH2PR12MB3912.namprd12.prod.outlook.com (52.132.246.86) by
 CH2PR12MB4213.namprd12.prod.outlook.com (20.180.5.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Tue, 14 Jan 2020 14:31:27 +0000
Received: from CH2PR12MB3912.namprd12.prod.outlook.com
 ([fe80::35e4:f61:8c42:333d]) by CH2PR12MB3912.namprd12.prod.outlook.com
 ([fe80::35e4:f61:8c42:333d%6]) with mapi id 15.20.2644.015; Tue, 14 Jan 2020
 14:31:27 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Zhou, David(ChunMing)" <David1.Zhou@amd.com>,
        "Cui, Flora" <Flora.Cui@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: RE: [PATCH 5.4 24/78] drm/amdgpu: add DRIVER_SYNCOBJ_TIMELINE to
 amdgpu
Thread-Topic: [PATCH 5.4 24/78] drm/amdgpu: add DRIVER_SYNCOBJ_TIMELINE to
 amdgpu
Thread-Index: AQHVysHskg2OUSoaPkincySA9Liam6fqOMJw
Date:   Tue, 14 Jan 2020 14:31:26 +0000
Message-ID: <CH2PR12MB3912AB5EEE1BBD2B20D71424F7340@CH2PR12MB3912.namprd12.prod.outlook.com>
References: <20200114094352.428808181@linuxfoundation.org>
 <20200114094356.995503791@linuxfoundation.org>
In-Reply-To: <20200114094356.995503791@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2020-01-14T14:30:25Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=2396163b-7c39-428b-b203-00009c9424c1;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_enabled: true
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_setdate: 2020-01-14T14:31:24Z
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_method: Privileged
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_name: Public_0
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_actionid: 1db5f1b5-6296-4e1c-a457-000050483eb5
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_contentbits: 0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Alexander.Deucher@amd.com; 
x-originating-ip: [165.204.84.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 700cd1e3-bbca-4afa-88c6-08d798fe7066
x-ms-traffictypediagnostic: CH2PR12MB4213:|CH2PR12MB4213:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB4213B01D0C80D15FE7503465F7340@CH2PR12MB4213.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(199004)(189003)(81166006)(81156014)(9686003)(8936002)(110136005)(71200400001)(66574012)(5660300002)(52536014)(8676002)(316002)(54906003)(2906002)(76116006)(53546011)(66476007)(7696005)(86362001)(6506007)(66556008)(64756008)(66946007)(186003)(26005)(55016002)(33656002)(66446008)(4326008)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR12MB4213;H:CH2PR12MB3912.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Px42Q3fRSSSlyDunqbIQ3b/VKIdOVN/x6qQQGbU4qLUPDq5/pLo+Nwm8wo9BZLMK/SHAc9QUCzplTNbEDBDTcVyUf7TkfXCK1CP+YolBBlwt6J3WBvxvKqrCJBnGxqGu/hPpsslf13tHdUm4xgRcw0TdaFbtIv9CEtFrfkWuvkRTfM6aDWmBW6HDcWMkZK8IfrxSyUEJxGKK2ilQto/1/VmGRQrjHqT6GuRLUR8Goe4lHqzgY1PzyZBm2I45XAXkudKawYdeuoQENBwfeXV/GvkvVP2wlxujrKZ0hHEmA8kekTWY2Qr7Y94+12bNb2ctScTZrjJgJ6sqUpwUgeYU9RWhlOck5Q/xzKbhH5sDDgij/YNbMFROlMRFWBffhQN/xn/kJcH1wpbnvnYdSlXrRW9zXDAP3mFk8T+znvDu37zWAHBhScsowMGGBzHpUk2e
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 700cd1e3-bbca-4afa-88c6-08d798fe7066
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 14:31:26.9538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EV3zFv9Clxq23fM4huTY5cEnAiOamnVK/6aULN96JdgegI1pZCrQxt1E8XmJ4FNlDFvNAqSj7j5/WMqvf3D7VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4213
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W0FNRCBQdWJsaWMgVXNlXQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206
IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQo+IFNlbnQ6
IFR1ZXNkYXksIEphbnVhcnkgMTQsIDIwMjAgNTowMSBBTQ0KPiBUbzogbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZw0KPiBDYzogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3Vu
ZGF0aW9uLm9yZz47DQo+IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IFpob3UsIERhdmlkKENodW5N
aW5nKSA8RGF2aWQxLlpob3VAYW1kLmNvbT47DQo+IEN1aSwgRmxvcmEgPEZsb3JhLkN1aUBhbWQu
Y29tPjsgS29lbmlnLCBDaHJpc3RpYW4NCj4gPENocmlzdGlhbi5Lb2VuaWdAYW1kLmNvbT47IERl
dWNoZXIsIEFsZXhhbmRlcg0KPiA8QWxleGFuZGVyLkRldWNoZXJAYW1kLmNvbT4NCj4gU3ViamVj
dDogW1BBVENIIDUuNCAyNC83OF0gZHJtL2FtZGdwdTogYWRkIERSSVZFUl9TWU5DT0JKX1RJTUVM
SU5FIHRvDQo+IGFtZGdwdQ0KPiANCj4gRnJvbTogQ2h1bm1pbmcgWmhvdSA8ZGF2aWQxLnpob3VA
YW1kLmNvbT4NCj4gDQo+IGNvbW1pdCBkYjRmZjQyM2NkMTY1OTU4MGU1NDFhMmQ0MzYzMzQyZjE1
YzE0MjMwIHVwc3RyZWFtLg0KPiANCj4gQ2FuIGV4cG9zZSBpdCBub3cgdGhhdCB0aGUga2hyb25v
cyBoYXMgZXhwb3NlZCB0aGUgdmxrIGV4dGVuc2lvbi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENo
dW5taW5nIFpob3UgPGRhdmlkMS56aG91QGFtZC5jb20+DQo+IFJldmlld2VkLWJ5OiBGbG9yYSBD
dWkgPEZsb3JhLkN1aUBhbWQuY29tPg0KPiBSZXZpZXdlZC1ieTogQ2hyaXN0aWFuIEvDtm5pZyA8
Y2hyaXN0aWFuLmtvZW5pZ0BhbWQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIg
PGFsZXhhbmRlci5kZXVjaGVyQGFtZC5jb20+DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3Jn
DQo+IFNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRh
dGlvbi5vcmc+DQo+IA0KDQpUaGlzIGNhbiBiZSBkcm9wcGVkIGZvciA1LjQuICBBY2NvcmRpbmcg
dG8gQ2h1bk1pbmcsIHRoZXJlIGlzIG1pc3NpbmcgZnVuY3Rpb25hbGl0eSBpbiA1LjQgc28gaXQn
cyBub3QgcmVxdWlyZWQuDQoNClRoYW5rcywNCg0KQWxleA0KDQo+IC0tLQ0KPiAgZHJpdmVycy9n
cHUvZHJtL2FtZC9hbWRncHUvYW1kZ3B1X2Rydi5jIHwgICAgMyArKy0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IC0tLSBhL2RyaXZlcnMv
Z3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV9kcnYuYw0KPiArKysgYi9kcml2ZXJzL2dwdS9kcm0v
YW1kL2FtZGdwdS9hbWRncHVfZHJ2LmMNCj4gQEAgLTE0MjIsNyArMTQyMiw4IEBAIHN0YXRpYyBz
dHJ1Y3QgZHJtX2RyaXZlciBrbXNfZHJpdmVyID0gew0KPiAgCS5kcml2ZXJfZmVhdHVyZXMgPQ0K
PiAgCSAgICBEUklWRVJfVVNFX0FHUCB8IERSSVZFUl9BVE9NSUMgfA0KPiAgCSAgICBEUklWRVJf
R0VNIHwNCj4gLQkgICAgRFJJVkVSX1JFTkRFUiB8IERSSVZFUl9NT0RFU0VUIHwgRFJJVkVSX1NZ
TkNPQkosDQo+ICsJICAgIERSSVZFUl9SRU5ERVIgfCBEUklWRVJfTU9ERVNFVCB8IERSSVZFUl9T
WU5DT0JKIHwNCj4gKwkgICAgRFJJVkVSX1NZTkNPQkpfVElNRUxJTkUsDQo+ICAJLmxvYWQgPSBh
bWRncHVfZHJpdmVyX2xvYWRfa21zLA0KPiAgCS5vcGVuID0gYW1kZ3B1X2RyaXZlcl9vcGVuX2tt
cywNCj4gIAkucG9zdGNsb3NlID0gYW1kZ3B1X2RyaXZlcl9wb3N0Y2xvc2Vfa21zLA0KPiANCg==
