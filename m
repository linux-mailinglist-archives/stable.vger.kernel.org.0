Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39863A023A
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 14:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfH1Mwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 08:52:31 -0400
Received: from mail-eopbgr740120.outbound.protection.outlook.com ([40.107.74.120]:45865
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726270AbfH1Mwb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 08:52:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gV599gjr3A2YMbHrgRAdPrU/yTMhDY6IckREUSooVMzqkT9DGoP+20jAxe97SjPryitoSZpnlAXDFDAmxeHHPGNdPmT4yIfH1HJiv031LHoYInqCVkFIpnt9k6dN2poJu5uQ+8bpILfGi48+KOXNamW8d+tFn/yEz+JoumsMqaIOXHCDSS2MZ73DYtskfvM8vgk3io11/F0nCOBmM20/xIaDlFLRXRl6AT74Dn1rxKgkxHfCwMqR/HrJ1HO3PIeJJheY0crugtDjiFhpwI0dkRv8EnPNi9+8oUJgmMKMDEmezjQbAEaXKzkwe6hJZYzq0noN42lw0MA7o0UPqPBoEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9MIHDMRoMz44LEOBX5QDjiXX73X+daZpQFl3XHlZpk=;
 b=ZxjsAwUFSuZpF6kGPOKJcRMv6L9nvZMo11dQfdClfb4kdeweRtf5b588rFXFph8BckOZ47DsGzTGFIABWZgsnXtmtnrdR9PdZGKILeEiojDmu9PLZ9fwROH/DzKPqwhlhN+yw6Rj511xyEKh3gyGIU2nv65PC7qIRKEIDPboG8rDbYUQrUkZ3cEV2ykl9ZKFYPSiBrOcjaqR1PKO4z+K5+LetYn5syW2hcyDRFo/7W2ya4dfXi2avd6C50gcLqTcW6mRyFnaLCk+f+neT0KRQhe0uw4FpvyxYzVAENsvqFvMkCdMQ0jyvETOtbOX2K1aob0eSNBZzNKYltOj0bvENQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9MIHDMRoMz44LEOBX5QDjiXX73X+daZpQFl3XHlZpk=;
 b=V2OPbXggnfOkO4flfZenpkPYiftpmK8XgjOcWc67zVTXfoPxXac7lI+RD8vgj66rFmAqpJKR3ibWbpOotu+SDioqi99ClVZayj7w/96DnlCUcJMNR3xRGrRGEIzIfjuaF13JyHMq6VAn2nxRa8ejnf96LIfpSeccNAXtIo621Y4=
Received: from DM5PR13MB1851.namprd13.prod.outlook.com (10.171.159.143) by
 DM5PR13MB0940.namprd13.prod.outlook.com (10.168.235.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.14; Wed, 28 Aug 2019 12:52:26 +0000
Received: from DM5PR13MB1851.namprd13.prod.outlook.com
 ([fe80::5d60:e645:84a2:be75]) by DM5PR13MB1851.namprd13.prod.outlook.com
 ([fe80::5d60:e645:84a2:be75%7]) with mapi id 15.20.2220.013; Wed, 28 Aug 2019
 12:52:26 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "pavel@denx.de" <pavel@denx.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "steved@redhat.com" <steved@redhat.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>
Subject: Re: [PATCH 4.19 35/98] NFS: Fix regression whereby fscache errors are
 appearing on nofsc mounts
Thread-Topic: [PATCH 4.19 35/98] NFS: Fix regression whereby fscache errors
 are appearing on nofsc mounts
Thread-Index: AQHVXKziyHqrtc8PHE+Fi6jwj3T596cQJjqAgABfTYA=
Date:   Wed, 28 Aug 2019 12:52:26 +0000
Message-ID: <ff035228b9fa6a332645124393a035ae80588243.camel@hammerspace.com>
References: <20190827072718.142728620@linuxfoundation.org>
         <20190827072720.043818271@linuxfoundation.org> <20190828071119.GA10462@amd>
In-Reply-To: <20190828071119.GA10462@amd>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=trondmy@hammerspace.com; 
x-originating-ip: [68.40.189.247]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b3bb7a5-8f1f-40e3-2983-08d72bb69438
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR13MB0940;
x-ms-traffictypediagnostic: DM5PR13MB0940:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM5PR13MB0940AB436BA9D5FD68485CB5B8A30@DM5PR13MB0940.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(136003)(39840400004)(376002)(189003)(199004)(25786009)(4326008)(256004)(6512007)(6506007)(6486002)(86362001)(14444005)(81166006)(99286004)(26005)(71200400001)(71190400001)(66446008)(53936002)(6436002)(476003)(5660300002)(486006)(2616005)(316002)(76176011)(6246003)(66476007)(11346002)(76116006)(91956017)(66946007)(446003)(66556008)(110136005)(2501003)(3846002)(6116002)(102836004)(186003)(14454004)(118296001)(8936002)(305945005)(7736002)(15974865002)(66066001)(478600001)(64756008)(229853002)(81156014)(8676002)(36756003)(54906003)(2906002)(3714002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR13MB0940;H:DM5PR13MB1851.namprd13.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: hammerspace.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GgW/yclxv7VIEGspKEWZO2prAndSYNNBYY+/iDagTBKS3MjcMNRjX3PWUzcSHSpXgRb8Nbs6o3OyMfDwPk73l+jy8vLyqwj7HKeXVhKOebwQ37Xls7UWNxXphHYvIpuCQ93/z4NQEHq+9pM05fsvZ/9t4waG2hw/aHlgz9fVADF3b6gWC1NSDlE1gmTeZgbFA9Igy8VNhCK5/peCimW2yYJg26ILOwxRt6PipuEJq8qF8bUbb9dklUnKFOCYHFixSZdgVKAiuRWN3pmU9LaTk3NFSi2D7h553ZF63FENB0y61yDoSOio4dnVScdg3T/GTW135RTcWMbIoa5rEzMzWi75xV/Ldp4Kb7cE2ogeMTF4LmXUn6GdPKV+TFA5k+N/3TAwoTD5Fprcd/8eVj8JEaDJsxsZuYMmI+eurl2Nv5w=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C31544B208EE442B1B3FD66A53C00C9@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3bb7a5-8f1f-40e3-2983-08d72bb69438
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 12:52:26.5605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CmQleDZUibva/6QfwUeYlpMiyg/N58W2f48pdk21keqxar96DT25NbOdt9alr9TGBndoi6GTLmmXb88Ibp42jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB0940
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDE5LTA4LTI4IGF0IDA5OjExICswMjAwLCBQYXZlbCBNYWNoZWsgd3JvdGU6DQo+
IE9uIFR1ZSAyMDE5LTA4LTI3IDA5OjUwOjE0LCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+
ID4gWyBVcHN0cmVhbSBjb21taXQgZGVhMWJiMzVjNWYzNWUwNTc3Y2ZjNjFmNzkyNjFkODBiODcx
NTIyMSBdDQo+ID4gDQo+ID4gUGVvcGxlIGFyZSByZXBvcmluZyBzZWVpbmcgZnNjYWNoZSBlcnJv
cnMgYmVpbmcgcmVwb3J0ZWQgY29uY2VybmluZw0KPiA+IGR1cGxpY2F0ZSBjb29raWVzIGV2ZW4g
aW4gY2FzZXMgd2hlcmUgdGhleSBhcmUgbm90IHNldHRpbmcgdXANCj4gPiBmc2NhY2hlDQo+ID4g
YXQgYWxsLiBUaGUgcnVsZSBuZWVkcyB0byBiZSB0aGF0IGlmIGZzY2FjaGUgaXMgbm90IGVuYWJs
ZWQsIHRoZW4NCj4gPiBpdA0KPiA+IHNob3VsZCBoYXZlIG5vIHNpZGUgZWZmZWN0cyBhdCBhbGwu
DQo+ID4gDQo+ID4gVG8gZW5zdXJlIHRoaXMgaXMgdGhlIGNhc2UsIHdlIGRpc2FibGUgZnNjYWNo
ZSBjb21wbGV0ZWx5IG9uIGFsbA0KPiA+IHN1cGVyYmxvY2tzDQo+ID4gZm9yIHdoaWNoIHRoZSAn
ZnNjJyBtb3VudCBvcHRpb24gd2FzIG5vdCBzZXQuIEluIG9yZGVyIHRvIGF2b2lkDQo+ID4gaXNz
dWVzDQo+ID4gd2l0aCAnLW9yZW1vdW50Jywgd2UgYWxzbyBkaXNhYmxlIHRoZSBhYmlsaXR5IHRv
IHR1cm4gZnNjYWNoZSBvbg0KPiA+IHZpYQ0KPiA+IHJlbW91bnQuDQo+IA0KPiBBY3R1YWxseSwg
dGhlIGNvZGUgc2VlbXMgdG8gc3VnZ2VzdCB0aGF0IHlvdSBkaXNhYmxlIHRoZSBhYmlsaXR5IHRv
DQo+IHR1cm4gZnNjYWNoZSBfb2ZmXyB2aWEgcmVtb3VudCwgdG9vLg0KPiANCj4gSXMgdGhhdCBp
bnRlbnRpb25hbD8NCj4gDQoNClllcy4gVGhhdCBpcyBpbnRlbnRpb25hbC4gT3RoZXJ3aXNlIHdl
IHdvdWxkIGhhdmUgdG8gY2xlYXIgYWxsIHRoZQ0KZnNjYWNoZSBjb29raWVzIGZyb20gdGhlIGlu
b2Rlcy4NCg0KPiBCZXN0IHJlZ2FyZHMsDQo+IAkJCQkJCQkJUGF2ZWwNCj4gDQo+ID4gQEAgLTIy
MzksNiArMjIzOSw3IEBAIG5mc19jb21wYXJlX3JlbW91bnRfZGF0YShzdHJ1Y3QgbmZzX3NlcnZl
cg0KPiA+ICpuZnNzLA0KPiA+ICAJICAgIGRhdGEtPmFjZGlybWluICE9IG5mc3MtPmFjZGlybWlu
IC8gSFogfHwNCj4gPiAgCSAgICBkYXRhLT5hY2Rpcm1heCAhPSBuZnNzLT5hY2Rpcm1heCAvIEha
IHx8DQo+ID4gIAkgICAgZGF0YS0+dGltZW8gIT0gKDEwVSAqIG5mc3MtPmNsaWVudC0+Y2xfdGlt
ZW91dC0+dG9faW5pdHZhbA0KPiA+IC8gSFopIHx8DQo+ID4gKwkgICAgKGRhdGEtPm9wdGlvbnMg
JiBORlNfT1BUSU9OX0ZTQ0FDSEUpICE9IChuZnNzLT5vcHRpb25zICYNCj4gPiBORlNfT1BUSU9O
X0ZTQ0FDSEUpIHx8DQo+ID4gIAkgICAgZGF0YS0+bmZzX3NlcnZlci5wb3J0ICE9IG5mc3MtPnBv
cnQgfHwNCj4gPiAgCSAgICBkYXRhLT5uZnNfc2VydmVyLmFkZHJsZW4gIT0gbmZzcy0+bmZzX2Ns
aWVudC0+Y2xfYWRkcmxlbiB8fA0KPiA+ICAJICAgICFycGNfY21wX2FkZHIoKHN0cnVjdCBzb2Nr
YWRkciAqKSZkYXRhLT5uZnNfc2VydmVyLmFkZHJlc3MsDQotLSANClRyb25kIE15a2xlYnVzdA0K
Q1RPLCBIYW1tZXJzcGFjZSBJbmMNCjQzMDAgRWwgQ2FtaW5vIFJlYWwsIFN1aXRlIDEwNQ0KTG9z
IEFsdG9zLCBDQSA5NDAyMg0Kd3d3LmhhbW1lci5zcGFjZQ0KDQoNCg==
