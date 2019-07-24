Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5642572390
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 03:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfGXBCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 21:02:49 -0400
Received: from mail-eopbgr1310135.outbound.protection.outlook.com ([40.107.131.135]:51936
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725601AbfGXBCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 21:02:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EsShyJrq6a5b1kTeOVLAWbYjnFIZwb/mGr8XSl3qeGTPSmIVFQ+vOsOwcc6a5QRuG4XXv0sySKfyLlT3514D/gIeuaHr6vm26WDEwb7CUAvYLdz5+Fjidh8yRqe4BVgSxCBvmkpdDw18tA3gv7K2y+m8l4e1ciCKBUDU+Qxawywmylrunu8kKSGgWIFE+NFVpfl9w6Z2VTdThtoXNCBf7YW40ZKFWBtGMjaLoKeD2T47eE8SoxViNllR27JOkN2f+7kniNJ0Zbcs17MkI+HEJr9DHUFSftSeYK0dPILWcmYsy0f/a1JYHnd9+rQHAGq4yd4wgShzYNUWkjer18oKUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GBY486O/MtY58gYl12X0g95vCGjR7+8xcEUsDwP3+N0=;
 b=WvzdUe6098NYGztyE3HOi96pbh2FqwJdSZpjjlDW9D6J/EgH5sxukpgJk6qvYUlnjJS7BCMGnnMANyJaWhWKVNwsJgNtfPjOzXiklczF8Gbmf8ujeF0ap0OtLK3t/r8xWrW7GyGmH10GvyjA3s5t9OX835e1UVS4rmlnR+g/2l/lbW7oCLUqtH0qzDMVrBpe/EENOChmlPN0ncs1kXSIOIK5vTSZJ679zg/nlRrg1KQ8TGgNsNR/9vT/doVAkc20y75J2LJovVcA5eRIeQp7kxndPlqi5RBNzdR+aEbiTH1HPxne/amrL4vxVZXWQTxy4KbmWrk8Oo9imdoumYsN9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=microsoft.com;dmarc=pass action=none
 header.from=microsoft.com;dkim=pass header.d=microsoft.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GBY486O/MtY58gYl12X0g95vCGjR7+8xcEUsDwP3+N0=;
 b=Jh0QGvvgNGAoIp1+lb5bfb9WqZr8XgbIs9doZkV91ZVv990AP7N6Bt5Mb3/d9mFAFDs91rweZZaTpBUoXrx32Pkjc3Ucc+ND+E36nsLRAYvDD+fBZTCPUqYFHNgNBguh2MJcbr+hX7Z6Ux6yVzabO+4qz/d4i6gLrOFXHIDQt0M=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0156.APCP153.PROD.OUTLOOK.COM (10.170.189.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.1; Wed, 24 Jul 2019 01:01:18 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::383c:3887:faf8:650a]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::383c:3887:faf8:650a%6]) with mapi id 15.20.2136.000; Wed, 24 Jul 2019
 01:01:18 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: RE: FAILED: patch "[PATCH] PCI: hv: Fix a use-after-free bug in
 hv_eject_device_work()" failed to apply to 4.14-stable tree
Thread-Topic: FAILED: patch "[PATCH] PCI: hv: Fix a use-after-free bug in
 hv_eject_device_work()" failed to apply to 4.14-stable tree
Thread-Index: AQHVQU4cjh8dnyTcPUuztqKiYJvL5qbY82/g
Date:   Wed, 24 Jul 2019 01:01:18 +0000
Message-ID: <PU1P153MB0169E0984244BDEF657CC0CCBFC60@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <156388316686177@kroah.com>
In-Reply-To: <156388316686177@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-07-24T01:01:14.9580443Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3547048c-132a-4241-bd6b-8ceb55f14da3;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:1:a959:15fc:60f5:bfe3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0cd219ef-732c-4d34-0a08-08d70fd26f7d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(49563074)(7193020);SRVR:PU1P153MB0156;
x-ms-traffictypediagnostic: PU1P153MB0156:|PU1P153MB0156:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB01564B759687E0D52B749B38BFC60@PU1P153MB0156.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(189003)(199004)(68736007)(102836004)(8936002)(74316002)(6506007)(53546011)(2501003)(6116002)(7736002)(186003)(86362001)(8676002)(76176011)(14454004)(4326008)(256004)(2906002)(99286004)(6246003)(46003)(107886003)(5024004)(486006)(25786009)(5660300002)(55016002)(229853002)(22452003)(53936002)(476003)(71200400001)(33656002)(99936001)(316002)(1730700003)(81166006)(446003)(11346002)(5640700003)(81156014)(52536014)(6916009)(54906003)(2351001)(7696005)(305945005)(10090500001)(71190400001)(8990500004)(66946007)(478600001)(66446008)(64756008)(66556008)(66476007)(66616009)(10290500003)(9686003)(6436002)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0156;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nGEjpiLabqweTeJNF2gbGjQ62/+fsj5BUip/ZJRQCD4rSDAcDvmorXPiPuN0AiHoGW1cpRdivthwvIUSkV8thsqW+7ZyeUwWSyRtmtUyP0vXss+jr5MAgjubf1FIkX1LCwOEJhUEh2RzjDHnKfONMGIpf5xZS3zNohzTpf1b8xsFxVAiMDULFG4uFq1ix89+O6DvV1nV7JSNQ41yeDsYU9f85GBlNcC0on2ogxH4vpyKOS69XjW0l0Bu7Cry4yPeslaInMfHxt0Tba2fi4F53+1O6p0lCFl6shTYUuW6BciiHvBGVlAW4su07gSDsBxquP96xjlS34AgdDMBXodvOjLijPR5mPaFBmU6TBqVUq438npMygs7ZHdQ52LIdWLnGPtZ2K7g6K5DYT895nCpdT4z4j7SBSMvK4yMYHjl8Ds=
Content-Type: multipart/mixed;
        boundary="_002_PU1P153MB0169E0984244BDEF657CC0CCBFC60PU1P153MB0169APCP_"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cd219ef-732c-4d34-0a08-08d70fd26f7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 01:01:18.0570
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

--_002_PU1P153MB0169E0984244BDEF657CC0CCBFC60PU1P153MB0169APCP_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Tuesday, July 23, 2019 4:59 AM
> To: Dexuan Cui <decui@microsoft.com>; lorenzo.pieralisi@arm.com; Michael
> Kelley <mikelley@microsoft.com>
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] PCI: hv: Fix a use-after-free bug in
> hv_eject_device_work()" failed to apply to 4.14-stable tree
>=20
>=20
> The patch below does not apply to the 4.14-stable tree.
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
>=20
> Fix a use-after-free in hv_eject_device_work().
>=20
> Fixes: 05f151a73ec2 ("PCI: hv: Fix a memory leak in hv_eject_device_work(=
)")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Cc: stable@vger.kernel.org

Hi,
I backported this commit for v4.14.134.=20
Please see the attachment.

Thanks,
-- Dexuan

--_002_PU1P153MB0169E0984244BDEF657CC0CCBFC60PU1P153MB0169APCP_
Content-Type: application/octet-stream;
	name="for-4.14.134-0001-PCI-hv-Fix-a-use-after-free-bug-in-hv_eject_device_w.patch"
Content-Description:
 for-4.14.134-0001-PCI-hv-Fix-a-use-after-free-bug-in-hv_eject_device_w.patch
Content-Disposition: attachment;
	filename="for-4.14.134-0001-PCI-hv-Fix-a-use-after-free-bug-in-hv_eject_device_w.patch";
	size=3117; creation-date="Wed, 24 Jul 2019 00:59:40 GMT";
	modification-date="Wed, 24 Jul 2019 00:59:40 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxMDljYjRmNDY1YjAzMzVjYjMyZjg5Nzc2OTI5M2RlZmNmMWMyZDBmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPgpEYXRl
OiBUdWUsIDIzIEp1bCAyMDE5IDE3OjAwOjI0IC0wNzAwClN1YmplY3Q6IFtQQVRDSCBmb3ItNC4x
NC4xMzRdIFBDSTogaHY6IEZpeCBhIHVzZS1hZnRlci1mcmVlIGJ1ZyBpbgogaHZfZWplY3RfZGV2
aWNlX3dvcmsoKQpSZXBseS1UbzogZGVjdWlAbWljcm9zb2Z0LmNvbQoKWyBVcHN0cmVhbSBjb21t
aXQgNGRmNTkxYjIwYjgwY2I3NzkyMDk1MzgxMmQ4OTRkYjI1OWQ4NWJkNyBdCgpGaXggYSB1c2Ut
YWZ0ZXItZnJlZSBpbiBodl9lamVjdF9kZXZpY2Vfd29yaygpLgoKRml4ZXM6IDA1ZjE1MWE3M2Vj
MiAoIlBDSTogaHY6IEZpeCBhIG1lbW9yeSBsZWFrIGluIGh2X2VqZWN0X2RldmljZV93b3JrKCki
KQpTaWduZWQtb2ZmLWJ5OiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPgpTaWduZWQt
b2ZmLWJ5OiBMb3JlbnpvIFBpZXJhbGlzaSA8bG9yZW56by5waWVyYWxpc2lAYXJtLmNvbT4KUmV2
aWV3ZWQtYnk6IE1pY2hhZWwgS2VsbGV5IDxtaWtlbGxleUBtaWNyb3NvZnQuY29tPgpDYzogc3Rh
YmxlQHZnZXIua2VybmVsLm9yZwoKU2lnbmVkLW9mZi1ieTogRGV4dWFuIEN1aSA8ZGVjdWlAbWlj
cm9zb2Z0LmNvbT4KLS0tCiBkcml2ZXJzL3BjaS9ob3N0L3BjaS1oeXBlcnYuYyB8IDE1ICsrKysr
KysrKy0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3BjaS9ob3N0L3BjaS1oeXBlcnYuYyBiL2RyaXZlcnMv
cGNpL2hvc3QvcGNpLWh5cGVydi5jCmluZGV4IGY1OTFkZTIuLjVhOWQ5NDUgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvcGNpL2hvc3QvcGNpLWh5cGVydi5jCisrKyBiL2RyaXZlcnMvcGNpL2hvc3QvcGNp
LWh5cGVydi5jCkBAIC0xOTEyLDYgKzE5MTIsNyBAQCBzdGF0aWMgdm9pZCBodl9wY2lfZGV2aWNl
c19wcmVzZW50KHN0cnVjdCBodl9wY2lidXNfZGV2aWNlICpoYnVzLAogc3RhdGljIHZvaWQgaHZf
ZWplY3RfZGV2aWNlX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogewogCXN0cnVjdCBw
Y2lfZWplY3RfcmVzcG9uc2UgKmVqY3RfcGt0OworCXN0cnVjdCBodl9wY2lidXNfZGV2aWNlICpo
YnVzOwogCXN0cnVjdCBodl9wY2lfZGV2ICpocGRldjsKIAlzdHJ1Y3QgcGNpX2RldiAqcGRldjsK
IAl1bnNpZ25lZCBsb25nIGZsYWdzOwpAQCAtMTkyMiw2ICsxOTIzLDcgQEAgc3RhdGljIHZvaWQg
aHZfZWplY3RfZGV2aWNlX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCX0gY3R4dDsK
IAogCWhwZGV2ID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCBodl9wY2lfZGV2LCB3cmspOwor
CWhidXMgPSBocGRldi0+aGJ1czsKIAogCWlmIChocGRldi0+c3RhdGUgIT0gaHZfcGNpY2hpbGRf
ZWplY3RpbmcpIHsKIAkJcHV0X3BjaWNoaWxkKGhwZGV2LCBodl9wY2lkZXZfcmVmX3BucCk7CkBA
IC0xOTM1LDggKzE5MzcsNyBAQCBzdGF0aWMgdm9pZCBodl9lamVjdF9kZXZpY2Vfd29yayhzdHJ1
Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJICogYmVjYXVzZSBoYnVzLT5wY2lfYnVzIG1heSBub3Qg
ZXhpc3QgeWV0LgogCSAqLwogCXdzbG90ID0gd3Nsb3RfdG9fZGV2Zm4oaHBkZXYtPmRlc2Mud2lu
X3Nsb3Quc2xvdCk7Ci0JcGRldiA9IHBjaV9nZXRfZG9tYWluX2J1c19hbmRfc2xvdChocGRldi0+
aGJ1cy0+c3lzZGF0YS5kb21haW4sIDAsCi0JCQkJCSAgIHdzbG90KTsKKwlwZGV2ID0gcGNpX2dl
dF9kb21haW5fYnVzX2FuZF9zbG90KGhidXMtPnN5c2RhdGEuZG9tYWluLCAwLCB3c2xvdCk7CiAJ
aWYgKHBkZXYpIHsKIAkJcGNpX2xvY2tfcmVzY2FuX3JlbW92ZSgpOwogCQlwY2lfc3RvcF9hbmRf
cmVtb3ZlX2J1c19kZXZpY2UocGRldik7CkBAIC0xOTQ0LDkgKzE5NDUsOSBAQCBzdGF0aWMgdm9p
ZCBodl9lamVjdF9kZXZpY2Vfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJCXBjaV91
bmxvY2tfcmVzY2FuX3JlbW92ZSgpOwogCX0KIAotCXNwaW5fbG9ja19pcnFzYXZlKCZocGRldi0+
aGJ1cy0+ZGV2aWNlX2xpc3RfbG9jaywgZmxhZ3MpOworCXNwaW5fbG9ja19pcnFzYXZlKCZoYnVz
LT5kZXZpY2VfbGlzdF9sb2NrLCBmbGFncyk7CiAJbGlzdF9kZWwoJmhwZGV2LT5saXN0X2VudHJ5
KTsKLQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZocGRldi0+aGJ1cy0+ZGV2aWNlX2xpc3RfbG9j
aywgZmxhZ3MpOworCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhidXMtPmRldmljZV9saXN0X2xv
Y2ssIGZsYWdzKTsKIAogCWlmIChocGRldi0+cGNpX3Nsb3QpCiAJCXBjaV9kZXN0cm95X3Nsb3Qo
aHBkZXYtPnBjaV9zbG90KTsKQEAgLTE5NTUsMTQgKzE5NTYsMTYgQEAgc3RhdGljIHZvaWQgaHZf
ZWplY3RfZGV2aWNlX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCWVqY3RfcGt0ID0g
KHN0cnVjdCBwY2lfZWplY3RfcmVzcG9uc2UgKikmY3R4dC5wa3QubWVzc2FnZTsKIAllamN0X3Br
dC0+bWVzc2FnZV90eXBlLnR5cGUgPSBQQ0lfRUpFQ1RJT05fQ09NUExFVEU7CiAJZWpjdF9wa3Qt
PndzbG90LnNsb3QgPSBocGRldi0+ZGVzYy53aW5fc2xvdC5zbG90OwotCXZtYnVzX3NlbmRwYWNr
ZXQoaHBkZXYtPmhidXMtPmhkZXYtPmNoYW5uZWwsIGVqY3RfcGt0LAorCXZtYnVzX3NlbmRwYWNr
ZXQoaGJ1cy0+aGRldi0+Y2hhbm5lbCwgZWpjdF9wa3QsCiAJCQkgc2l6ZW9mKCplamN0X3BrdCks
ICh1bnNpZ25lZCBsb25nKSZjdHh0LnBrdCwKIAkJCSBWTV9QS1RfREFUQV9JTkJBTkQsIDApOwog
CiAJcHV0X3BjaWNoaWxkKGhwZGV2LCBodl9wY2lkZXZfcmVmX2NoaWxkbGlzdCk7CiAJcHV0X3Bj
aWNoaWxkKGhwZGV2LCBodl9wY2lkZXZfcmVmX2luaXRpYWwpOwogCXB1dF9wY2ljaGlsZChocGRl
diwgaHZfcGNpZGV2X3JlZl9wbnApOwotCXB1dF9odnBjaWJ1cyhocGRldi0+aGJ1cyk7CisKKwkv
KiBocGRldiBoYXMgYmVlbiBmcmVlZC4gRG8gbm90IHVzZSBpdCBhbnkgbW9yZS4gKi8KKwlwdXRf
aHZwY2lidXMoaGJ1cyk7CiB9CiAKIC8qKgotLSAKMS44LjMuMQoK

--_002_PU1P153MB0169E0984244BDEF657CC0CCBFC60PU1P153MB0169APCP_--
