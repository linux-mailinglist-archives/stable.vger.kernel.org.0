Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB987238F
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 03:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfGXBAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 21:00:39 -0400
Received: from mail-eopbgr1310121.outbound.protection.outlook.com ([40.107.131.121]:43136
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725601AbfGXBAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 21:00:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmFQXhujcA2xY/ycXo35v/yn3eszg8Plw8u1aqwkbc/+kTODAV48tjbqBkBI8zk4Pjjd+vdzNjM3aykvlr+LuncHMeXL4uRIoBlZYVoOWpysNcaCTRRKsM3wG2iedWOdJtbp0qN6coYUC2XmDaOHhsbIt9g8ywSlp3PVf3XIwgIi0rm+/X9bZXhxrxaMaiH5bMGGds0aVvD5TjFi8TCaE+kG/iqOECtORQpVEnY6gN/eHhQmY5cD3DmeD8WZek4xOxWoj5tKEq9ruqGsI94rgbpfX2f7g2oxh81Y8eeXnN+3FLSe0fmK6mkyddHUWqQRBL6YyiVn5OB8jQICECa0ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gN+5cLaxfC9nTUEKdPvxCneyDppU7mX/iPzuFzl9tsI=;
 b=mL3CBxRri+pa/tKmUI0xtXqg5Z/qFYFTuLdRksAJHje41x6WS46OC8z4ZU1Lv+Feu8UMzfrisQK/OyTFD7Eskj1B2Kgk99Jcfv92MIxQ0t6K3yhzvc3ZZZXfHzipQJXb8vRLeLB+IR5vL0IOYdd+hVk66mz8/oXVvD3kTfcQ0fG4qiwyjUIevC8fW8T10uMrwnlF7Bfzh7aAM5ApMBt109R2aAsO8mF8HCVY7InFoDiYS8WMBDRlJGYJzZshfk1b/lVJB+6MJ/nxBs9mRkUqMBfac0skMek7rkrcppwJCTndoBm6CVj/zMQWPHPKvG8K6GkWmYBzhBijGdfmviKnrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=microsoft.com;dmarc=pass action=none
 header.from=microsoft.com;dkim=pass header.d=microsoft.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gN+5cLaxfC9nTUEKdPvxCneyDppU7mX/iPzuFzl9tsI=;
 b=k3pHeEBHF37Jkxecy3LOYCvS+d7aszNA1pLZ4SHgdm23YaPR60QcGLr9Ihnbew9jL+alzKn8rWTzlPSibn1M5GmWijQOme6zGYJGkLE5YpOh6eGKXcenAVBogWClsU44IjsHRbQRuA8kAnioxHOQSxbgnCl+T039zYPYJrELG5E=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0156.APCP153.PROD.OUTLOOK.COM (10.170.189.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.1; Wed, 24 Jul 2019 00:59:01 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::383c:3887:faf8:650a]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::383c:3887:faf8:650a%6]) with mapi id 15.20.2136.000; Wed, 24 Jul 2019
 00:59:01 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: RE: FAILED: patch "[PATCH] PCI: hv: Fix a use-after-free bug in
 hv_eject_device_work()" failed to apply to 4.9-stable tree
Thread-Topic: FAILED: patch "[PATCH] PCI: hv: Fix a use-after-free bug in
 hv_eject_device_work()" failed to apply to 4.9-stable tree
Thread-Index: AQHVQU4Xm7GLdTrEfkOfnzjqQETpxabY8c0w
Date:   Wed, 24 Jul 2019 00:59:01 +0000
Message-ID: <PU1P153MB0169A3D78122369BE7320A96BFC60@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <1563883165157254@kroah.com>
In-Reply-To: <1563883165157254@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-07-24T00:58:57.6193416Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=adf1611c-4a6d-488e-8b14-e812b153b1cc;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:1:a959:15fc:60f5:bfe3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be8f1bb4-419f-4d4c-3f6f-08d70fd21de1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(49563074)(7193020);SRVR:PU1P153MB0156;
x-ms-traffictypediagnostic: PU1P153MB0156:|PU1P153MB0156:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB015666F5612695691648930BBFC60@PU1P153MB0156.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(189003)(199004)(68736007)(102836004)(8936002)(74316002)(6506007)(53546011)(2501003)(6116002)(7736002)(186003)(86362001)(8676002)(76176011)(14454004)(4326008)(14444005)(256004)(2906002)(99286004)(6246003)(46003)(107886003)(5024004)(486006)(25786009)(5660300002)(55016002)(229853002)(22452003)(53936002)(476003)(71200400001)(33656002)(99936001)(316002)(1730700003)(81166006)(446003)(11346002)(5640700003)(81156014)(52536014)(6916009)(54906003)(2351001)(66576008)(7696005)(305945005)(10090500001)(71190400001)(8990500004)(66946007)(478600001)(66446008)(64756008)(66556008)(66476007)(10290500003)(9686003)(6436002)(76116006)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0156;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 85QvAgmePVUzWT6dez8jTghxoEQkH0Vqec2++kpJ9oYOuiQsfEDh7JFYx/yY9q4RNOPBPWP2fggwTPKj97oSeT47zaqjrQlZSrBzVrjSkTS5yds/Xi2GDBilb0tCdHLEpsGP10GKFAkd29oVffptwi5OPF5+H2onwpMKGh1HSr4bgDMNP60zLfDQVpYE7qKca/o3YoPg8MRUPq1Ptkd+m5YSXZBXbKdPZprld0DKhFDu7UMaE+MmefH96kTjfIO/zPnzYS/BlkycmXdpKBerd5iuLJO1GQwUCegWnPhsIxW5cP+v9E8zkZ/vVdy9nzGabSUOtIpsLur3k3LZ3L1raEM2DLsNYj2OHMsj5PtUMiAPtfyYsYnc7KMCamvOKl62Ck64IzRPZKswvZQtJ+NsUow1meG0V1SCU97AATBcglw=
Content-Type: multipart/mixed;
        boundary="_003_PU1P153MB0169A3D78122369BE7320A96BFC60PU1P153MB0169APCP_"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be8f1bb4-419f-4d4c-3f6f-08d70fd21de1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 00:59:01.1276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0156
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_003_PU1P153MB0169A3D78122369BE7320A96BFC60PU1P153MB0169APCP_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Tuesday, July 23, 2019 4:59 AM
> To: Dexuan Cui <decui@microsoft.com>; lorenzo.pieralisi@arm.com; Michael
> Kelley <mikelley@microsoft.com>
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] PCI: hv: Fix a use-after-free bug in
> hv_eject_device_work()" failed to apply to 4.9-stable tree
>=20
>=20
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 4df591b20b80cb77920953812d894db259d85bd7 Mon Sep 17 00:00:00
> 2001
> From: Dexuan Cui <decui@microsoft.com>
> Date: Fri, 21 Jun 2019 23:45:23 +0000
> Subject: [PATCH] PCI: hv: Fix a use-after-free bug in hv_eject_device_wor=
k()

Hi,
To apply this patch to v4.9.186, we need to cherry-pick another patch first=
:
e74d2ebdda33 ("PCI: hv: Delete the device earlier from hbus->children for h=
ot-remove")

Then I backported this commit (4df591b20)

Please see the two attachments for the two patches.
They can be cleanly applied to v4.9.186.

Thanks,
-- Dexuan

--_003_PU1P153MB0169A3D78122369BE7320A96BFC60PU1P153MB0169APCP_
Content-Type: application/octet-stream;
	name="for-4.9.186-0001-PCI-hv-Delete-the-device-earlier-from-hbus-children-.patch"
Content-Description:
 for-4.9.186-0001-PCI-hv-Delete-the-device-earlier-from-hbus-children-.patch
Content-Disposition: attachment;
	filename="for-4.9.186-0001-PCI-hv-Delete-the-device-earlier-from-hbus-children-.patch";
	size=2416; creation-date="Wed, 24 Jul 2019 00:57:08 GMT";
	modification-date="Wed, 24 Jul 2019 00:57:08 GMT"
Content-Transfer-Encoding: base64

RnJvbSA3MDkxMzAzNGNkY2YwNjEwMjA1NzNkNjRkNDg5MGMzNzgxYzYzYjZiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPgpEYXRl
OiBUaHUsIDEwIE5vdiAyMDE2IDA3OjE5OjUyICswMDAwClN1YmplY3Q6IFtQQVRDSCBmb3ItNC45
LjE4NiAxLzJdIFBDSTogaHY6IERlbGV0ZSB0aGUgZGV2aWNlIGVhcmxpZXIgZnJvbQogaGJ1cy0+
Y2hpbGRyZW4gZm9yIGhvdC1yZW1vdmUKUmVwbHktVG86IGRlY3VpQG1pY3Jvc29mdC5jb20KClsg
VXBzdHJlYW0gY29tbWl0IGU3NGQyZWJkZGEzM2IzYmRkMTgyNmI1YjkyZTlhYTQ1YmRmOTJiYjMg
XQoKQWZ0ZXIgd2Ugc2VuZCBhIFBDSV9FSkVDVElPTl9DT01QTEVURSBtZXNzYWdlIHRvIHRoZSBo
b3N0LCB0aGUgaG9zdCB3aWxsCmltbWVkaWF0ZWx5IHNlbmQgdXMgYSBQQ0lfQlVTX1JFTEFUSU9O
UyBtZXNzYWdlIHdpdGgKcmVsYXRpb25zLT5kZXZpY2VfY291bnQgPT0gMCwgc28gcGNpX2Rldmlj
ZXNfcHJlc2VudF93b3JrKCksIHJ1bm5pbmcgb24KYW5vdGhlciB0aHJlYWQsIGNhbiBmaW5kIHRo
ZSBiZWluZy1lamVjdGVkIGRldmljZSwgbWFyayB0aGUKaHBkZXYtPnJlcG9ydGVkX21pc3Npbmcg
dG8gdHJ1ZSwgYW5kIHJ1biBsaXN0X21vdmVfdGFpbCgpL2xpc3RfZGVsKCkgZm9yCnRoZSBkZXZp
Y2UgLS0gdGhpcyByYWNlcyBodl9lamVjdF9kZXZpY2Vfd29yaygpIC0+IGxpc3RfZGVsKCkuCgpN
b3ZlIHRoZSBsaXN0X2RlbCgpIGluIGh2X2VqZWN0X2RldmljZV93b3JrKCkgdG8gYW4gZWFybGll
ciBwbGFjZSwgaS5lLiwKYmVmb3JlIHdlIHNlbmQgUENJX0VKRUNUSU9OX0NPTVBMRVRFLCBzbyBs
YXRlciB0aGUKcGNpX2RldmljZXNfcHJlc2VudF93b3JrKCkgY2FuJ3Qgc2VlIHRoZSBkZXZpY2Uu
CgpTaWduZWQtb2ZmLWJ5OiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPgpTaWduZWQt
b2ZmLWJ5OiBCam9ybiBIZWxnYWFzIDxiaGVsZ2Fhc0Bnb29nbGUuY29tPgpSZXZpZXdlZC1ieTog
SmFrZSBPc2hpbnMgPGpha2VvQG1pY3Jvc29mdC5jb20+CkFja2VkLWJ5OiBLLiBZLiBTcmluaXZh
c2FuIDxreXNAbWljcm9zb2Z0LmNvbT4KQ0M6IEhhaXlhbmcgWmhhbmcgPGhhaXlhbmd6QG1pY3Jv
c29mdC5jb20+CkNDOiBWaXRhbHkgS3V6bmV0c292IDx2a3V6bmV0c0ByZWRoYXQuY29tPgoKU2ln
bmVkLW9mZi1ieTogRGV4dWFuIEN1aSA8ZGVjdWlAbWljcm9zb2Z0LmNvbT4KLS0tCiBkcml2ZXJz
L3BjaS9ob3N0L3BjaS1oeXBlcnYuYyB8IDggKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA0IGlu
c2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wY2kvaG9z
dC9wY2ktaHlwZXJ2LmMgYi9kcml2ZXJzL3BjaS9ob3N0L3BjaS1oeXBlcnYuYwppbmRleCAyMDBi
NDE1Li40OTk0NjFjIDEwMDY0NAotLS0gYS9kcml2ZXJzL3BjaS9ob3N0L3BjaS1oeXBlcnYuYwor
KysgYi9kcml2ZXJzL3BjaS9ob3N0L3BjaS1oeXBlcnYuYwpAQCAtMTYwNyw2ICsxNjA3LDEwIEBA
IHN0YXRpYyB2b2lkIGh2X2VqZWN0X2RldmljZV93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29y
aykKIAkJcGNpX3VubG9ja19yZXNjYW5fcmVtb3ZlKCk7CiAJfQogCisJc3Bpbl9sb2NrX2lycXNh
dmUoJmhwZGV2LT5oYnVzLT5kZXZpY2VfbGlzdF9sb2NrLCBmbGFncyk7CisJbGlzdF9kZWwoJmhw
ZGV2LT5saXN0X2VudHJ5KTsKKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZocGRldi0+aGJ1cy0+
ZGV2aWNlX2xpc3RfbG9jaywgZmxhZ3MpOworCiAJbWVtc2V0KCZjdHh0LCAwLCBzaXplb2YoY3R4
dCkpOwogCWVqY3RfcGt0ID0gKHN0cnVjdCBwY2lfZWplY3RfcmVzcG9uc2UgKikmY3R4dC5wa3Qu
bWVzc2FnZTsKIAllamN0X3BrdC0+bWVzc2FnZV90eXBlLnR5cGUgPSBQQ0lfRUpFQ1RJT05fQ09N
UExFVEU7CkBAIC0xNjE1LDEwICsxNjE5LDYgQEAgc3RhdGljIHZvaWQgaHZfZWplY3RfZGV2aWNl
X3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCQkJIHNpemVvZigqZWpjdF9wa3QpLCAo
dW5zaWduZWQgbG9uZykmY3R4dC5wa3QsCiAJCQkgVk1fUEtUX0RBVEFfSU5CQU5ELCAwKTsKIAot
CXNwaW5fbG9ja19pcnFzYXZlKCZocGRldi0+aGJ1cy0+ZGV2aWNlX2xpc3RfbG9jaywgZmxhZ3Mp
OwotCWxpc3RfZGVsKCZocGRldi0+bGlzdF9lbnRyeSk7Ci0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9y
ZSgmaHBkZXYtPmhidXMtPmRldmljZV9saXN0X2xvY2ssIGZsYWdzKTsKLQogCXB1dF9wY2ljaGls
ZChocGRldiwgaHZfcGNpZGV2X3JlZl9jaGlsZGxpc3QpOwogCXB1dF9wY2ljaGlsZChocGRldiwg
aHZfcGNpZGV2X3JlZl9pbml0aWFsKTsKIAlwdXRfcGNpY2hpbGQoaHBkZXYsIGh2X3BjaWRldl9y
ZWZfcG5wKTsKLS0gCjEuOC4zLjEKCg==

--_003_PU1P153MB0169A3D78122369BE7320A96BFC60PU1P153MB0169APCP_
Content-Type: application/octet-stream;
	name="for-4.9.186-0002-PCI-hv-Fix-a-use-after-free-bug-in-hv_eject_device_w.patch"
Content-Description:
 for-4.9.186-0002-PCI-hv-Fix-a-use-after-free-bug-in-hv_eject_device_w.patch
Content-Disposition: attachment;
	filename="for-4.9.186-0002-PCI-hv-Fix-a-use-after-free-bug-in-hv_eject_device_w.patch";
	size=3012; creation-date="Wed, 24 Jul 2019 00:57:12 GMT";
	modification-date="Wed, 24 Jul 2019 00:57:12 GMT"
Content-Transfer-Encoding: base64

RnJvbSBlYzI0MTg1OGM1M2RkN2ZkYzk4YThmNGVlNDcxOWJmNjRlMDY3N2Y4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPgpEYXRl
OiBUdWUsIDIzIEp1bCAyMDE5IDE3OjMwOjQxIC0wNzAwClN1YmplY3Q6IFtQQVRDSCBmb3ItNC45
LjE4NiAyLzJdIFBDSTogaHY6IEZpeCBhIHVzZS1hZnRlci1mcmVlIGJ1ZyBpbgogaHZfZWplY3Rf
ZGV2aWNlX3dvcmsoKQpSZXBseS1UbzogZGVjdWlAbWljcm9zb2Z0LmNvbQoKWyBVcHN0cmVhbSBj
b21taXQgNGRmNTkxYjIwYjgwY2I3NzkyMDk1MzgxMmQ4OTRkYjI1OWQ4NWJkNyBdCgpGaXggYSB1
c2UtYWZ0ZXItZnJlZSBpbiBodl9lamVjdF9kZXZpY2Vfd29yaygpLgoKRml4ZXM6IDA1ZjE1MWE3
M2VjMiAoIlBDSTogaHY6IEZpeCBhIG1lbW9yeSBsZWFrIGluIGh2X2VqZWN0X2RldmljZV93b3Jr
KCkiKQpTaWduZWQtb2ZmLWJ5OiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPgpTaWdu
ZWQtb2ZmLWJ5OiBMb3JlbnpvIFBpZXJhbGlzaSA8bG9yZW56by5waWVyYWxpc2lAYXJtLmNvbT4K
UmV2aWV3ZWQtYnk6IE1pY2hhZWwgS2VsbGV5IDxtaWtlbGxleUBtaWNyb3NvZnQuY29tPgpDYzog
c3RhYmxlQHZnZXIua2VybmVsLm9yZwoKU2lnbmVkLW9mZi1ieTogRGV4dWFuIEN1aSA8ZGVjdWlA
bWljcm9zb2Z0LmNvbT4KLS0tCiBkcml2ZXJzL3BjaS9ob3N0L3BjaS1oeXBlcnYuYyB8IDE1ICsr
KysrKysrKy0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3BjaS9ob3N0L3BjaS1oeXBlcnYuYyBiL2RyaXZl
cnMvcGNpL2hvc3QvcGNpLWh5cGVydi5jCmluZGV4IDQ5OTQ2MWMuLmE1OTc2MTkgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvcGNpL2hvc3QvcGNpLWh5cGVydi5jCisrKyBiL2RyaXZlcnMvcGNpL2hvc3Qv
cGNpLWh5cGVydi5jCkBAIC0xNTc1LDYgKzE1NzUsNyBAQCBzdGF0aWMgdm9pZCBodl9wY2lfZGV2
aWNlc19wcmVzZW50KHN0cnVjdCBodl9wY2lidXNfZGV2aWNlICpoYnVzLAogc3RhdGljIHZvaWQg
aHZfZWplY3RfZGV2aWNlX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogewogCXN0cnVj
dCBwY2lfZWplY3RfcmVzcG9uc2UgKmVqY3RfcGt0OworCXN0cnVjdCBodl9wY2lidXNfZGV2aWNl
ICpoYnVzOwogCXN0cnVjdCBodl9wY2lfZGV2ICpocGRldjsKIAlzdHJ1Y3QgcGNpX2RldiAqcGRl
djsKIAl1bnNpZ25lZCBsb25nIGZsYWdzOwpAQCAtMTU4NSw2ICsxNTg2LDcgQEAgc3RhdGljIHZv
aWQgaHZfZWplY3RfZGV2aWNlX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCX0gY3R4
dDsKIAogCWhwZGV2ID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCBodl9wY2lfZGV2LCB3cmsp
OworCWhidXMgPSBocGRldi0+aGJ1czsKIAogCWlmIChocGRldi0+c3RhdGUgIT0gaHZfcGNpY2hp
bGRfZWplY3RpbmcpIHsKIAkJcHV0X3BjaWNoaWxkKGhwZGV2LCBodl9wY2lkZXZfcmVmX3BucCk7
CkBAIC0xNTk4LDggKzE2MDAsNyBAQCBzdGF0aWMgdm9pZCBodl9lamVjdF9kZXZpY2Vfd29yayhz
dHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJICogYmVjYXVzZSBoYnVzLT5wY2lfYnVzIG1heSBu
b3QgZXhpc3QgeWV0LgogCSAqLwogCXdzbG90ID0gd3Nsb3RfdG9fZGV2Zm4oaHBkZXYtPmRlc2Mu
d2luX3Nsb3Quc2xvdCk7Ci0JcGRldiA9IHBjaV9nZXRfZG9tYWluX2J1c19hbmRfc2xvdChocGRl
di0+aGJ1cy0+c3lzZGF0YS5kb21haW4sIDAsCi0JCQkJCSAgIHdzbG90KTsKKwlwZGV2ID0gcGNp
X2dldF9kb21haW5fYnVzX2FuZF9zbG90KGhidXMtPnN5c2RhdGEuZG9tYWluLCAwLCB3c2xvdCk7
CiAJaWYgKHBkZXYpIHsKIAkJcGNpX2xvY2tfcmVzY2FuX3JlbW92ZSgpOwogCQlwY2lfc3RvcF9h
bmRfcmVtb3ZlX2J1c19kZXZpY2UocGRldik7CkBAIC0xNjA3LDIyICsxNjA4LDI0IEBAIHN0YXRp
YyB2b2lkIGh2X2VqZWN0X2RldmljZV93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkJ
cGNpX3VubG9ja19yZXNjYW5fcmVtb3ZlKCk7CiAJfQogCi0Jc3Bpbl9sb2NrX2lycXNhdmUoJmhw
ZGV2LT5oYnVzLT5kZXZpY2VfbGlzdF9sb2NrLCBmbGFncyk7CisJc3Bpbl9sb2NrX2lycXNhdmUo
JmhidXMtPmRldmljZV9saXN0X2xvY2ssIGZsYWdzKTsKIAlsaXN0X2RlbCgmaHBkZXYtPmxpc3Rf
ZW50cnkpOwotCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhwZGV2LT5oYnVzLT5kZXZpY2VfbGlz
dF9sb2NrLCBmbGFncyk7CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaGJ1cy0+ZGV2aWNlX2xp
c3RfbG9jaywgZmxhZ3MpOwogCiAJbWVtc2V0KCZjdHh0LCAwLCBzaXplb2YoY3R4dCkpOwogCWVq
Y3RfcGt0ID0gKHN0cnVjdCBwY2lfZWplY3RfcmVzcG9uc2UgKikmY3R4dC5wa3QubWVzc2FnZTsK
IAllamN0X3BrdC0+bWVzc2FnZV90eXBlLnR5cGUgPSBQQ0lfRUpFQ1RJT05fQ09NUExFVEU7CiAJ
ZWpjdF9wa3QtPndzbG90LnNsb3QgPSBocGRldi0+ZGVzYy53aW5fc2xvdC5zbG90OwotCXZtYnVz
X3NlbmRwYWNrZXQoaHBkZXYtPmhidXMtPmhkZXYtPmNoYW5uZWwsIGVqY3RfcGt0LAorCXZtYnVz
X3NlbmRwYWNrZXQoaGJ1cy0+aGRldi0+Y2hhbm5lbCwgZWpjdF9wa3QsCiAJCQkgc2l6ZW9mKCpl
amN0X3BrdCksICh1bnNpZ25lZCBsb25nKSZjdHh0LnBrdCwKIAkJCSBWTV9QS1RfREFUQV9JTkJB
TkQsIDApOwogCiAJcHV0X3BjaWNoaWxkKGhwZGV2LCBodl9wY2lkZXZfcmVmX2NoaWxkbGlzdCk7
CiAJcHV0X3BjaWNoaWxkKGhwZGV2LCBodl9wY2lkZXZfcmVmX2luaXRpYWwpOwogCXB1dF9wY2lj
aGlsZChocGRldiwgaHZfcGNpZGV2X3JlZl9wbnApOwotCXB1dF9odnBjaWJ1cyhocGRldi0+aGJ1
cyk7CisKKwkvKiBocGRldiBoYXMgYmVlbiBmcmVlZC4gRG8gbm90IHVzZSBpdCBhbnkgbW9yZS4g
Ki8KKwlwdXRfaHZwY2lidXMoaGJ1cyk7CiB9CiAKIC8qKgotLSAKMS44LjMuMQoK

--_003_PU1P153MB0169A3D78122369BE7320A96BFC60PU1P153MB0169APCP_--
