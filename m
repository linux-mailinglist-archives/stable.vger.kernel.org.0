Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC13F6F9A4
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 08:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfGVGsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 02:48:06 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:18138 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725874AbfGVGsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 02:48:06 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6M6lXar022665;
        Mon, 22 Jul 2019 02:47:51 -0400
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2059.outbound.protection.outlook.com [104.47.37.59])
        by mx0b-00128a01.pphosted.com with ESMTP id 2tuvq9n9tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jul 2019 02:47:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8qkkUrwjfhH7zCzwLfShOdNZ1dn9VnGjNHo1kJZer0/SwfrC5rSSBH2FRqKam39eYFmU3axDW1l5wFEwWgrtRPHT8igTWAeQGe4XEMrk0myDArzaBD1bcu2+eT1igQV2uq1tchrWox75jxJfvmTcgCBLE2PZlS507S03Xa+ZiC6ctY225VqNCC06aQjVRQHzyAOyuCZi/7mJbTSxe3WkS5KZ5aaRn4t28n/xyPf7ejAQRxw3vnWN0RJdIF2/nCghP7ppPHm4+6koUtLUF2z/36Z4qRV0F6gQQsJz+um+704h4O6J/UF3MPrzrV7XEVHxYJfoC5ZFpmf4GuoGsA09g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcE9CkIG676lAIE1ElmDeEgy+2q7MpRS7Z3MFuo0czQ=;
 b=JeTtKgOjWZjh1nDXDB3r4lVMUnrEqFs+VXaugRdrhgdWyK4nAP1Q9fUJ5hQwb/R8u/TWSku2j5AG2837RkKS263CLXiKFxd6I7qm5yhX6MpB7bwlK7GXZzGjHG9eGeG3vHKDvoJaDivLjaD5zn0MasIwt8E7BWjBIu2p6W94PioTqoEquGsjacuBmfoWE+C9dRdqYRBMp62PrG3xBF/HdNASexiI82/alGdcpiwcUGhg3nfmw8OZObKHSgB4N298qoArOT+hH+wBNMaa1TQdkOD2hEs4bwboZ4QMLRzErs+hoqmWDoGcr2cI8dLzSY9BPQ/p0DkUczWm3AHaKYYRbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcE9CkIG676lAIE1ElmDeEgy+2q7MpRS7Z3MFuo0czQ=;
 b=kRsqRRa5VBeyX9H222ikhc74+EBjnP3lUUGFRJR072MxS8UMWi8E7jkAD+XKuk/1pLTXFrJkRYAOg+HTANmYhK0fGFWJTyI58fOqH1+fmeVA3lcEvXEnMIMZmSwepIwXF8FFSjkEME2hg+t1pj4Iubiba4yKCLUGpuYKjNYBsc8=
Received: from BY5PR03CA0016.namprd03.prod.outlook.com (10.255.217.26) by
 BYAPR03MB3829.namprd03.prod.outlook.com (20.176.254.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Mon, 22 Jul 2019 06:47:50 +0000
Received: from SN1NAM02FT036.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::203) by BY5PR03CA0016.outlook.office365.com
 (2603:10b6:a03:1e0::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2094.16 via Frontend
 Transport; Mon, 22 Jul 2019 06:47:49 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT036.mail.protection.outlook.com (10.152.72.149) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2052.25
 via Frontend Transport; Mon, 22 Jul 2019 06:47:49 +0000
Received: from NWD2HUBCAS9.ad.analog.com (nwd2hubcas9.ad.analog.com [10.64.69.109])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x6M6lmBA008890
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sun, 21 Jul 2019 23:47:48 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS9.ad.analog.com ([fe80::44a2:871b:49ab:ea47%12]) with mapi id
 14.03.0415.000; Mon, 22 Jul 2019 02:47:48 -0400
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "jic23@kernel.org" <jic23@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "denis.ciocca@st.com" <denis.ciocca@st.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.4 17/35] iio: st_accel: fix
 iio_triggered_buffer_{pre,post}enable positions
Thread-Topic: [PATCH AUTOSEL 4.4 17/35] iio: st_accel: fix
 iio_triggered_buffer_{pre,post}enable positions
Thread-Index: AQHVPeiLNGlVOh1tKU63Jh5NIo2PrabVmS8AgADgx4A=
Date:   Mon, 22 Jul 2019 06:47:47 +0000
Message-ID: <1fcd1ef5f55de84c2b8c58492cd5fac9b8acf7ee.camel@analog.com>
References: <20190719041423.19322-1-sashal@kernel.org>
         <20190719041423.19322-17-sashal@kernel.org>
         <20190721182256.70ab6692@archlinux>
In-Reply-To: <20190721182256.70ab6692@archlinux>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.145]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F9215B38DA74941B319437A3A8DB773@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39860400002)(346002)(396003)(136003)(2980300002)(199004)(189003)(47776003)(23676004)(2906002)(478600001)(7696005)(336012)(5660300002)(316002)(106002)(26005)(4326008)(36756003)(54906003)(356004)(110136005)(7636002)(7736002)(6246003)(6116002)(118296001)(86362001)(2501003)(126002)(102836004)(486006)(70586007)(8676002)(476003)(76176011)(246002)(186003)(14454004)(50466002)(8936002)(5024004)(14444005)(305945005)(2616005)(446003)(436003)(2486003)(11346002)(3846002)(229853002)(70206006)(426003)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB3829;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d41b172e-9d56-4780-bc69-08d70e708340
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BYAPR03MB3829;
X-MS-TrafficTypeDiagnostic: BYAPR03MB3829:
X-Microsoft-Antispam-PRVS: <BYAPR03MB3829AE1D9A44AE45725C4F3BF9C40@BYAPR03MB3829.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 01068D0A20
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: bRwFw5q3onY72BpnW7NX9KDNUdVjyZv6LjOD3Y9bkxRO6n2gEA9woS5HqAy3PRifzqMhQUjxX8KvqkDzazxNvnP2w2v8AHCgR7kBrPOrFLywy7X+ASdErtDhe/mUxSttJTMMjv31TKMBjxsLGT7N2d0bD+ytb3zmZUmf+YRgSpm2F9JCxfcpggoENXSM8tcxJHkJRAZj072loL5uryOIMcvzRsHrxDLCRoHFHkbPSkyOXMp7bQ83Mo1R3R0bYS7YGEgvyv8rVPaqeBLnp+rqnHYBb9sKXVdIJKXF/f5G7TeMyVLspHEgGUknZCqFro34BTNmJlR2DFRlI/8g6HXuf613QDIhteQh9KHg7oAmF9fawKdqn7N+gtz0dohzt+0B8Qyneuc/NctzDhdNv1NL4hvzN1MsOCNSSUgy7cZbGpU=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2019 06:47:49.4005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d41b172e-9d56-4780-bc69-08d70e708340
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB3829
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-22_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1031 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907220081
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU3VuLCAyMDE5LTA3LTIxIGF0IDE4OjIzICswMTAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBbRXh0ZXJuYWxdDQo+IA0KPiBPbiBGcmksIDE5IEp1bCAyMDE5IDAwOjE0OjA1IC0wNDAw
DQo+IFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiA+IEZyb206
IEFsZXhhbmRydSBBcmRlbGVhbiA8YWxleGFuZHJ1LmFyZGVsZWFuQGFuYWxvZy5jb20+DQo+ID4g
DQo+ID4gWyBVcHN0cmVhbSBjb21taXQgMDViOGJjYzk2Mjc4YzllZjkyN2E2ZjI1YTk4ZTIzM2U1
NWRlNDJlMSBdDQo+ID4gDQo+ID4gVGhlIGlpb190cmlnZ2VyZWRfYnVmZmVyX3twcmVkaXNhYmxl
LHBvc3RlbmFibGV9IGZ1bmN0aW9ucyBhdHRhY2gvZGV0YWNoDQo+ID4gdGhlIHBvbGwgZnVuY3Rp
b25zLg0KPiA+IA0KPiA+IEZvciB0aGUgcHJlZGlzYWJsZSBob29rLCB0aGUgZGlzYWJsZSBjb2Rl
IHNob3VsZCBvY2N1ciBiZWZvcmUgZGV0YWNoaW5nDQo+ID4gdGhlIHBvbGwgZnVuYywgYW5kIGZv
ciB0aGUgcG9zdGVuYWJsZSBob29rLCB0aGUgcG9sbCBmdW5jIHNob3VsZCBiZQ0KPiA+IGF0dGFj
aGVkIGJlZm9yZSB0aGUgZW5hYmxlIGNvZGUuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQWxl
eGFuZHJ1IEFyZGVsZWFuIDxhbGV4YW5kcnUuYXJkZWxlYW5AYW5hbG9nLmNvbT4NCj4gPiBBY2tl
ZC1ieTogRGVuaXMgQ2lvY2NhIDxkZW5pcy5jaW9jY2FAc3QuY29tPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEpvbmF0aGFuIENhbWVyb24gPEpvbmF0aGFuLkNhbWVyb25AaHVhd2VpLmNvbT4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBTYXNoYSBMZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+DQo+IEhpIFNhc2hh
LA0KPiANCj4gVGhpcyBzaG91bGQgZG8gYW55IGhhcm0sIGJ1dCBJIGRlbGliZXJhdGVseSBkaWRu
J3QgY2Mgc3RhYmxlIG9uDQo+IHRoaXMgb25lLg0KPiANCj4gQWxleCwgbXkgYXNzdW1wdGlvbiBv
biB0aGlzIG9uZSBpcyB0aGF0IGl0IHdhcyBmaXhpbmcgYSBsb2dpY2FsDQo+IG9yZGVyaW5nIHBy
b2JsZW0sIGJ1dCBvbmUgdGhhdCBoYWQgbm8gdmlzaWJsZSBpbXBhY3QuDQo+IFdoaWxzdCB0aGUg
cG9sbGZ1bmMgd2lsbCBiZSBhdHRhY2hlZCB0b28gZWFybHksIHRoZSB0cmlnZ2VyDQo+IHdpbGwg
YmUgZGlzYWJsZWQgZm9yIHRoZSB3aG9sZSBvZiB0aGlzIGZ1bmN0aW9uIGFueXdheSBzbw0KPiBp
dCBzaG91bGRuJ3QgY2F1c2UgYW55IHZpc2libGUgcHJvYmxlbS4gIElzIHRoYXQgYSBjb3JyZWN0
IGludGVycHJldGF0aW9uPw0KDQpZZXMuDQpUaGF0IGlzIGNvcnJlY3QuDQoNCk1heWJlIEknbGwg
Y2hhbmdlIHRoZSBjb21taXQgdGl0bGUgZm9ybWF0IHNvIHRoYXQgdGhlcmUgaXMgbm8gY29uZnVz
aW9uLg0KSXQncyBhIGZpeCwgYnV0IG5vdCBpbiB0aGUgc2Vuc2UgdGhhdCBzb21ldGhpbmcgd2Fz
IGJyb2tlbi4NCkp1c3Qgc29tZXRoaW5nIHRoYXQgaXMgdGhlIHJlYWxtIG9mIGNsZWFuaW5nIHVw
Lg0KDQpUaGFua3MNCkFsZXgNCg0KPiBUaGVyZSBhcmUgZ29pbmcgdG8gYmUgYSBmZXcgbW9yZSBz
aW1pbGFyIGZpeGVzIGluIHRoZSBuZWFyIGZ1dHVyZQ0KPiBhcyBBbGV4IGlzIHRyeWluZyB0byB0
aWR5IHVwIHZhcmlvdXMgcGF0aHMgc28gd2UgY2FuIGRvIGEgZ2VuZXJhbA0KPiBiaXQgb2YgcmVm
YWN0b3JpbmcuDQo+IA0KPiBJZiBJJ20gdG9vIGxhdGUgZm9yIHRoaXMsIHRoZW4gbm90IGEgcHJv
YmxlbSwganVzdCBub2lzZQ0KPiBpbiB0aGUgc3RhYmxlIHJlbGVhc2UuDQo+IA0KPiBKb25hdGhh
bg0KPiANCj4gDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvaWlvL2FjY2VsL3N0X2FjY2VsX2J1ZmZl
ci5jIHwgMjIgKysrKysrKysrKysrKy0tLS0tLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTMg
aW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9paW8vYWNjZWwvc3RfYWNjZWxfYnVmZmVyLmMgYi9kcml2ZXJzL2lpby9hY2NlbC9zdF9h
Y2NlbF9idWZmZXIuYw0KPiA+IGluZGV4IGExZTY0MmVlMTNkNi4uNGY4MzgyNzcxODRhIDEwMDY0
NA0KPiA+IC0tLSBhL2RyaXZlcnMvaWlvL2FjY2VsL3N0X2FjY2VsX2J1ZmZlci5jDQo+ID4gKysr
IGIvZHJpdmVycy9paW8vYWNjZWwvc3RfYWNjZWxfYnVmZmVyLmMNCj4gPiBAQCAtNDYsMTcgKzQ2
LDE5IEBAIHN0YXRpYyBpbnQgc3RfYWNjZWxfYnVmZmVyX3Bvc3RlbmFibGUoc3RydWN0IGlpb19k
ZXYgKmluZGlvX2RldikNCj4gPiAgCQlnb3RvIGFsbG9jYXRlX21lbW9yeV9lcnJvcjsNCj4gPiAg
CX0NCj4gPiAgDQo+ID4gLQllcnIgPSBzdF9zZW5zb3JzX3NldF9heGlzX2VuYWJsZShpbmRpb19k
ZXYsDQo+ID4gLQkJCQkJKHU4KWluZGlvX2Rldi0+YWN0aXZlX3NjYW5fbWFza1swXSk7DQo+ID4g
KwllcnIgPSBpaW9fdHJpZ2dlcmVkX2J1ZmZlcl9wb3N0ZW5hYmxlKGluZGlvX2Rldik7DQo+ID4g
IAlpZiAoZXJyIDwgMCkNCj4gPiAgCQlnb3RvIHN0X2FjY2VsX2J1ZmZlcl9wb3N0ZW5hYmxlX2Vy
cm9yOw0KPiA+ICANCj4gPiAtCWVyciA9IGlpb190cmlnZ2VyZWRfYnVmZmVyX3Bvc3RlbmFibGUo
aW5kaW9fZGV2KTsNCj4gPiArCWVyciA9IHN0X3NlbnNvcnNfc2V0X2F4aXNfZW5hYmxlKGluZGlv
X2RldiwNCj4gPiArCQkJCQkodTgpaW5kaW9fZGV2LT5hY3RpdmVfc2Nhbl9tYXNrWzBdKTsNCj4g
PiAgCWlmIChlcnIgPCAwKQ0KPiA+IC0JCWdvdG8gc3RfYWNjZWxfYnVmZmVyX3Bvc3RlbmFibGVf
ZXJyb3I7DQo+ID4gKwkJZ290byBzdF9zZW5zb3JzX3NldF9heGlzX2VuYWJsZV9lcnJvcjsNCj4g
PiAgDQo+ID4gIAlyZXR1cm4gZXJyOw0KPiA+ICANCj4gPiArc3Rfc2Vuc29yc19zZXRfYXhpc19l
bmFibGVfZXJyb3I6DQo+ID4gKwlpaW9fdHJpZ2dlcmVkX2J1ZmZlcl9wcmVkaXNhYmxlKGluZGlv
X2Rldik7DQo+ID4gIHN0X2FjY2VsX2J1ZmZlcl9wb3N0ZW5hYmxlX2Vycm9yOg0KPiA+ICAJa2Zy
ZWUoYWRhdGEtPmJ1ZmZlcl9kYXRhKTsNCj4gPiAgYWxsb2NhdGVfbWVtb3J5X2Vycm9yOg0KPiA+
IEBAIC02NSwyMCArNjcsMjIgQEAgc3RhdGljIGludCBzdF9hY2NlbF9idWZmZXJfcG9zdGVuYWJs
ZShzdHJ1Y3QgaWlvX2RldiAqaW5kaW9fZGV2KQ0KPiA+ICANCj4gPiAgc3RhdGljIGludCBzdF9h
Y2NlbF9idWZmZXJfcHJlZGlzYWJsZShzdHJ1Y3QgaWlvX2RldiAqaW5kaW9fZGV2KQ0KPiA+ICB7
DQo+ID4gLQlpbnQgZXJyOw0KPiA+ICsJaW50IGVyciwgZXJyMjsNCj4gPiAgCXN0cnVjdCBzdF9z
ZW5zb3JfZGF0YSAqYWRhdGEgPSBpaW9fcHJpdihpbmRpb19kZXYpOw0KPiA+ICANCj4gPiAtCWVy
ciA9IGlpb190cmlnZ2VyZWRfYnVmZmVyX3ByZWRpc2FibGUoaW5kaW9fZGV2KTsNCj4gPiAtCWlm
IChlcnIgPCAwKQ0KPiA+IC0JCWdvdG8gc3RfYWNjZWxfYnVmZmVyX3ByZWRpc2FibGVfZXJyb3I7
DQo+ID4gLQ0KPiA+ICAJZXJyID0gc3Rfc2Vuc29yc19zZXRfYXhpc19lbmFibGUoaW5kaW9fZGV2
LCBTVF9TRU5TT1JTX0VOQUJMRV9BTExfQVhJUyk7DQo+ID4gIAlpZiAoZXJyIDwgMCkNCj4gPiAg
CQlnb3RvIHN0X2FjY2VsX2J1ZmZlcl9wcmVkaXNhYmxlX2Vycm9yOw0KPiA+ICANCj4gPiAgCWVy
ciA9IHN0X3NlbnNvcnNfc2V0X2VuYWJsZShpbmRpb19kZXYsIGZhbHNlKTsNCj4gPiArCWlmIChl
cnIgPCAwKQ0KPiA+ICsJCWdvdG8gc3RfYWNjZWxfYnVmZmVyX3ByZWRpc2FibGVfZXJyb3I7DQo+
ID4gIA0KPiA+ICBzdF9hY2NlbF9idWZmZXJfcHJlZGlzYWJsZV9lcnJvcjoNCj4gPiArCWVycjIg
PSBpaW9fdHJpZ2dlcmVkX2J1ZmZlcl9wcmVkaXNhYmxlKGluZGlvX2Rldik7DQo+ID4gKwlpZiAo
IWVycikNCj4gPiArCQllcnIgPSBlcnIyOw0KPiA+ICsNCj4gPiAgCWtmcmVlKGFkYXRhLT5idWZm
ZXJfZGF0YSk7DQo+ID4gIAlyZXR1cm4gZXJyOw0KPiA+ICB9DQo=
