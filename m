Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0D81D30F0
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 20:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfJJSyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 14:54:46 -0400
Received: from mail-eopbgr820099.outbound.protection.outlook.com ([40.107.82.99]:35770
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726007AbfJJSyq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 14:54:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HbixM2Sz+XAibzqkHNeoDp2jPIbSTwoMAPoGa4U6G7fDRzeCzEZUw9wKCBob6WvTksL8T7tFJNnnV9Mmvfd2wUHiPqoUBHhMGYMKgkN6hH214AKS7adCrAUQO+XTSWxQQhruj7jwt6VbMHIx8W4xiFhaeMeFgPouvQxND18H+W8KcZnQx5kXiVSjhnEep+tScH/1yVhwsXESeJ7amlOiWLNG00pOUfi1tM2PnWjJh9X2z0t4r+dfl504STEy/QNgYscLmYBsNJbm4bqlauCuZnmdLestsq2KD+I1TKlIqb4Q/v6jLoiFVgK0IEzlItPYKE4+JyeQWs/f3FmBp+m6zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+zRRoOihCScYNAIeakXbn3H+4ZnILFawPE4L8qPneQ=;
 b=EhW2OCULXKIkc0EK4HrYmVnTifWNwJ9uU6M2qAHGkX15egmjlb9uM/ClfFcaCAeMEAOVXe7udeUgz3m+OT3ShPx8BNVkwBvkPoLiovlmpdaJY7c60QUvByZseqsWJFXQ9F7CcDPCumjqJvBuilvFQCSa+hrpDZbrHSYbweo5Ds7wjIh95KfIGJTkVxmIdWfEidfwfF8nrUOD/alGbig0uICuYJj06g5/FmhhlDAQrZLpvf+kGvwij2YCxkNPz4RwbEY/7L+l004HNDLK2/rQQHB0zfBFDm03FeyV8izO+XJhXM/eb9OkR4vFDh35E3PhnGGQh+UWASY5urkWpEde2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wavecomp.com; dmarc=pass action=none header.from=mips.com;
 dkim=pass header.d=mips.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wavecomp.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+zRRoOihCScYNAIeakXbn3H+4ZnILFawPE4L8qPneQ=;
 b=WexqWdJ6jdmvw91Im7Iw3ZJM/RhgsC5mczyPLLDlV7U/M0uU1DYkmrWIiK2PQOO8PLxvt9LaRs3p/M7KKjXVjsySS7qylbj6QVEMeOIGlXwSilttuqCFn/uBMgrGPHD2Mb9+ppfW9urLCHal4XF2tnIoPwFPFNMXqiEuFTgxTJw=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1726.namprd22.prod.outlook.com (10.164.206.156) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Thu, 10 Oct 2019 18:54:03 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::c1dc:dba3:230c:e7f0]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::c1dc:dba3:230c:e7f0%8]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 18:54:03 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
CC:     Paul Burton <pburton@wavecomp.com>,
        Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] MIPS: Disable Loongson MMI instructions for kernel build
Thread-Topic: [PATCH] MIPS: Disable Loongson MMI instructions for kernel build
Thread-Index: AQHVf5wVKW7vpQ4uykW+vlSY7qdKrQ==
Date:   Thu, 10 Oct 2019 18:54:03 +0000
Message-ID: <20191010185324.2407578-1-paul.burton@mips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To MWHPR2201MB1277.namprd22.prod.outlook.com (2603:10b6:301:18::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.23.0
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac950004-7d04-4c7d-908a-08d74db33814
x-ms-traffictypediagnostic: MWHPR2201MB1726:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR2201MB1726D0429B7C6281A12B02ECC1940@MWHPR2201MB1726.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:510;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(39840400004)(366004)(396003)(136003)(52314003)(199004)(189003)(6436002)(99286004)(102836004)(52116002)(316002)(42882007)(26005)(186003)(6506007)(386003)(3846002)(6512007)(36756003)(5640700003)(6116002)(4326008)(476003)(44832011)(486006)(2906002)(2616005)(305945005)(7736002)(6916009)(66066001)(2501003)(2351001)(8676002)(81156014)(81166006)(8936002)(71200400001)(66946007)(64756008)(66556008)(66446008)(6486002)(66476007)(478600001)(5660300002)(50226002)(25786009)(1076003)(14444005)(71190400001)(14454004)(54906003)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1726;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8lSEk9lsrjQ/C9D5UKSw2rmj298NEAlezOOrx5DM9e8q7gvK6P2o8MNYTKkYJcaqYSXj5qMrlYvF8QZHaj6V85BEw0KOT48rFMk2SVdLe7WNFxbRtViy95IRe32yzxP/2IEx/eO4drHoihkIKn610MvvdCxA1tL0Jyvvt9fB9M/JwKeAd/U7aUyFMXgVj3dq+ZNnqy39daOfv8TK6C/xA20WHJtVspK53MCq78xuDhPd1cs0eHRcuTS4EnSKnpge2qT+Y+Ed+FFj/5GSfC2bGg/E+8m8MIhuyg7flHVWbY4YlFHHrOh6anqRnv8szJbDF6VupGPZUGaWR0LViiXLjG9/Z4mMJNWfnbTu6xEXcq6KC3Knt/CF+Ql4XucGeB74jYFMKanFuER1xo5V5ObS7DyV2TrIAhBsId6Fy+4T6Qk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <036097482928BD46A3209E9254A65042@namprd22.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac950004-7d04-4c7d-908a-08d74db33814
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 18:54:03.3840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h+9GuZHn1AJkRBMJlBEKSMJ4iFOSaiSIcelE8+BjDPM8SW/dxuvYD2k9s/v+7G02psn6dF8Vlak21WM4RaVs8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1726
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

R0NDIDkueCBhdXRvbWF0aWNhbGx5IGVuYWJsZXMgc3VwcG9ydCBmb3IgTG9vbmdzb24gTU1JIGlu
c3RydWN0aW9ucyB3aGVuDQp1c2luZyBzb21lIC1tYXJjaD0gZmxhZ3MsIGFuZCB0aGVuIGVycm9y
cyBvdXQgd2hlbiAtbXNvZnQtZmxvYXQgaXMNCnNwZWNpZmllZCB3aXRoOg0KDQogIGNjMTogZXJy
b3I6IOKAmC1tbG9vbmdzb24tbW1p4oCZIG11c3QgYmUgdXNlZCB3aXRoIOKAmC1taGFyZC1mbG9h
dOKAmQ0KDQpUaGUga2VybmVsIHNob3VsZG4ndCBiZSB1c2luZyB0aGVzZSBNTUkgaW5zdHJ1Y3Rp
b25zIGFueXdheSwganVzdCBhcyBpdA0KZG9lc24ndCB1c2UgZmxvYXRpbmcgcG9pbnQgaW5zdHJ1
Y3Rpb25zLiBFeHBsaWNpdGx5IGRpc2FibGUgdGhlbSBpbg0Kb3JkZXIgdG8gZml4IHRoZSBidWls
ZCB3aXRoIEdDQyA5LnguDQoNClNpZ25lZC1vZmYtYnk6IFBhdWwgQnVydG9uIDxwYXVsLmJ1cnRv
bkBtaXBzLmNvbT4NCkZpeGVzOiAzNzAyYmJhNWViNGYgKCJNSVBTOiBMb29uZ3NvbjogQWRkIEdD
QyA0LjQgc3VwcG9ydCBmb3IgTG9vbmdzb24yRSIpDQpGaXhlczogNmY3YTI1MWEyNTllICgiTUlQ
UzogTG9vbmdzb246IEFkZCBiYXNpYyBMb29uZ3NvbiAyRiBzdXBwb3J0IikNCkZpeGVzOiA1MTg4
MTI5YjhjOWYgKCJNSVBTOiBMb29uZ3Nvbi0zOiBJbXByb3ZlIC1tYXJjaCBvcHRpb24gYW5kIG1v
dmUgaXQgdG8gUGxhdGZvcm0iKQ0KQ2M6IEh1YWNhaSBDaGVuIDxjaGVuaGNAbGVtb3RlLmNvbT4N
CkNjOiBKaWF4dW4gWWFuZyA8amlheHVuLnlhbmdAZmx5Z29hdC5jb20+DQpDYzogc3RhYmxlQHZn
ZXIua2VybmVsLm9yZyAjIHYyLjYuMzIrDQotLS0NCg0KIGFyY2gvbWlwcy9sb29uZ3NvbjY0L1Bs
YXRmb3JtIHwgNCArKysrDQogYXJjaC9taXBzL3Zkc28vTWFrZWZpbGUgICAgICAgfCAxICsNCiAy
IGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvYXJjaC9taXBz
L2xvb25nc29uNjQvUGxhdGZvcm0gYi9hcmNoL21pcHMvbG9vbmdzb242NC9QbGF0Zm9ybQ0KaW5k
ZXggMjgxNzI1MDBmOTVhLi4yODU1ZGFmOTJmZTggMTAwNjQ0DQotLS0gYS9hcmNoL21pcHMvbG9v
bmdzb242NC9QbGF0Zm9ybQ0KKysrIGIvYXJjaC9taXBzL2xvb25nc29uNjQvUGxhdGZvcm0NCkBA
IC02Niw2ICs2NiwxMCBAQCBlbHNlDQogICAgICAgJChjYWxsIGNjLW9wdGlvbiwtbWFyY2g9bWlw
czY0cjIsLW1pcHM2NHIyIC1VX01JUFNfSVNBIC1EX01JUFNfSVNBPV9NSVBTX0lTQV9NSVBTNjQp
DQogZW5kaWYNCiANCisjIFNvbWUgLW1hcmNoPSBmbGFncyBlbmFibGUgTU1JIGluc3RydWN0aW9u
cywgYW5kIEdDQyBjb21wbGFpbnMgYWJvdXQgdGhhdA0KKyMgc3VwcG9ydCBiZWluZyBlbmFibGVk
IGFsb25nc2lkZSAtbXNvZnQtZmxvYXQuIFRodXMgZXhwbGljaXRseSBkaXNhYmxlIE1NSS4NCitj
ZmxhZ3MteSArPSAkKGNhbGwgY2Mtb3B0aW9uLC1tbm8tbG9vbmdzb24tbW1pKQ0KKw0KICMNCiAj
IExvb25nc29uIE1hY2hpbmVzJyBTdXBwb3J0DQogIw0KZGlmZiAtLWdpdCBhL2FyY2gvbWlwcy92
ZHNvL01ha2VmaWxlIGIvYXJjaC9taXBzL3Zkc28vTWFrZWZpbGUNCmluZGV4IDgwN2YwZjc4MmY3
NS4uOTk2YTkzNGVjZTdkIDEwMDY0NA0KLS0tIGEvYXJjaC9taXBzL3Zkc28vTWFrZWZpbGUNCisr
KyBiL2FyY2gvbWlwcy92ZHNvL01ha2VmaWxlDQpAQCAtMTUsNiArMTUsNyBAQCBjY2ZsYWdzLXZk
c28gOj0gXA0KIAkkKGZpbHRlciAtbW1pY3JvbWlwcywkKEtCVUlMRF9DRkxBR1MpKSBcDQogCSQo
ZmlsdGVyIC1tYXJjaD0lLCQoS0JVSUxEX0NGTEFHUykpIFwNCiAJJChmaWx0ZXIgLW0lLWZsb2F0
LCQoS0JVSUxEX0NGTEFHUykpIFwNCisJJChmaWx0ZXIgLW1uby1sb29uZ3Nvbi0lLCQoS0JVSUxE
X0NGTEFHUykpIFwNCiAJLURfX1ZEU09fXw0KIA0KIGlmZGVmIENPTkZJR19DQ19JU19DTEFORw0K
LS0gDQoyLjIzLjANCg0K
