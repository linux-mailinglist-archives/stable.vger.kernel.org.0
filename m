Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143E91FCBD
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 01:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfEOXYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 19:24:10 -0400
Received: from mail-eopbgr1320125.outbound.protection.outlook.com ([40.107.132.125]:59200
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726393AbfEOXWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 19:22:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=palnoUETd6/OVUQN4BZQ3lKCQVXv/GoFWaYTc8QFGR6F0ehhCCDeqT9qZMPz7N9+JtXVKzbeCQizT+bo71Z6V8XhRqP6KEcJnl+pG6JdmwZKUpNfRDr1fXUCi/SExfUaYBCsagLBnYAIb2zeQmNe73NgyAKSMTd+qF5BKKgK7Q4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKpDiL1+ry1/6Vx/UvD/Nbn7pIN/EuVm2IhzSY/rxis=;
 b=uMy3JLESsTc6A7lJxveap33zG8I7/ypeRLTiUjsj08CZMVjAjlzLP32LAJWQR2bYaXoMv06JaQrYWsZo0S+f0XS0KBC5/8CyL2fvteiU6em4TGjb1RVUs0N85npkzXEWjQOCCDPCgfrmW62mOVp4FyvZDmZQhSQKySFRWHdPUgY=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKpDiL1+ry1/6Vx/UvD/Nbn7pIN/EuVm2IhzSY/rxis=;
 b=jaMrh7x+Ft/M90QJeBbzW+x3DV4OBIiGNx8oAwbK3umSGm9aiNaK8NXUd+RC8xN+5pp/a3ANslxB/fF08XMjx3NobATRHgRt+itovdh5Uxf94J95PiC49lOv0VYX43EmexWORz4VZJT75faE1NeIYQ7t3/UASHv+GAatJ2C7n88=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0201.APCP153.PROD.OUTLOOK.COM (10.170.190.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.3; Wed, 15 May 2019 23:18:57 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564%4]) with mapi id 15.20.1922.002; Wed, 15 May 2019
 23:18:57 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] PCI: hv: Fix a memory leak in
 hv_eject_device_work()" failed to apply to 4.14-stable tree
Thread-Topic: FAILED: patch "[PATCH] PCI: hv: Fix a memory leak in
 hv_eject_device_work()" failed to apply to 4.14-stable tree
Thread-Index: AQHVCvkJaDgNxZ8BEkOcR/891njmX6Zs0ssw
Date:   Wed, 15 May 2019 23:18:56 +0000
Message-ID: <PU1P153MB0169D8FF719D8718F6B3157ABF090@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <1557909270643@kroah.com>
In-Reply-To: <1557909270643@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-15T23:18:53.4778051Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=dbefc56e-9be0-413d-8eb6-b5b012af403d;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:3901:5c9:f1fc:42c6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d398e2ee-c20a-4556-475b-08d6d98bb474
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(49563074)(7193020);SRVR:PU1P153MB0201;
x-ms-traffictypediagnostic: PU1P153MB0201:
x-microsoft-antispam-prvs: <PU1P153MB0201A8E829A500EEE01E38D9BF090@PU1P153MB0201.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(346002)(366004)(136003)(199004)(189003)(5024004)(1511001)(305945005)(256004)(7696005)(71190400001)(71200400001)(9686003)(10290500003)(5660300002)(74316002)(11346002)(8676002)(446003)(33656002)(7736002)(8990500004)(476003)(2501003)(55016002)(6436002)(6506007)(10090500001)(68736007)(4326008)(25786009)(229853002)(6246003)(186003)(6116002)(46003)(102836004)(22452003)(316002)(76176011)(66446008)(66556008)(66476007)(66616009)(86362001)(478600001)(14454004)(81156014)(81166006)(53546011)(99936001)(53936002)(110136005)(8936002)(486006)(66946007)(73956011)(99286004)(76116006)(2906002)(52536014)(86612001)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0201;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SbYUzTmk4+9Nuk2lhweFd3Ua5TdaW6thHH4pGEKS0+SE90c+ul/e4oN4y/SVjYt5n4Y458DFM6pqm2eLYkESJtuoMXYReRHTkDiSRbY6cG0uUkeXnDCrRZt/t4hpqh0i/rwARmw/zTr1q3CGBIYb5BEKFVcTxuyWYiP5ZYkHTutHFmg1urhVuGWobikaDGQvbnEw+WEws1kyu3PS3EWcgniIr64wZ2mGxLDu/jkoImoLvyCsQU0p9Xs/F4uCj3aKy6j57ATKUgKQelsPszvH3+E30NP2zu90ReSrxxhrc68fM9YbAmqgIQRoP09ApirlOOErsATvlH0eK1UM+yRDU1v+fMRwURNej8Sd/+tzI5WJRxyk7FobVyGA1gm4ZaRO5tziBRQjYFBzQy5FwYaWyjbmfpgczi72hDFzofgtoGk=
Content-Type: multipart/mixed;
        boundary="_002_PU1P153MB0169D8FF719D8718F6B3157ABF090PU1P153MB0169APCP_"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d398e2ee-c20a-4556-475b-08d6d98bb474
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 23:18:56.6746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0201
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_PU1P153MB0169D8FF719D8718F6B3157ABF090PU1P153MB0169APCP_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Wednesday, May 15, 2019 1:35 AM
> To: Dexuan Cui <decui@microsoft.com>; lorenzo.pieralisi@arm.com; Michael
> Kelley <mikelley@microsoft.com>; stephen@networkplumber.org
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] PCI: hv: Fix a memory leak in
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
> From 05f151a73ec2b23ffbff706e5203e729a995cdc2 Mon Sep 17 00:00:00
> 2001
> From: Dexuan Cui <decui@microsoft.com>
> Date: Mon, 4 Mar 2019 21:34:48 +0000
> Subject: [PATCH] PCI: hv: Fix a memory leak in hv_eject_device_work()
>=20
> When a device is created in new_pcichild_device(), hpdev->refs is set
> to 2 (i.e. the initial value of 1 plus the get_pcichild()).
>=20
> When we hot remove the device from the host, in a Linux VM we first call
> hv_pci_eject_device(), which increases hpdev->refs by get_pcichild() and
> then schedules a work of hv_eject_device_work(), so hpdev->refs becomes
> 3 (let's ignore the paired get/put_pcichild() in other places). But in
> hv_eject_device_work(), currently we only call put_pcichild() twice,
> meaning the 'hpdev' struct can't be freed in put_pcichild().
>=20
> Add one put_pcichild() to fix the memory leak.
>=20
> The device can also be removed when we run "rmmod pci-hyperv". On this
> path (hv_pci_remove() -> hv_pci_bus_exit() -> hv_pci_devices_present()),
> hpdev->refs is 2, and we do correctly call put_pcichild() twice in
> pci_devices_present_work().
>=20
> Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsof=
t
> Hyper-V VMs")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> [lorenzo.pieralisi@arm.com: commit log rework]
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
> Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
> Cc: stable@vger.kernel.org
>=20
> diff --git a/drivers/pci/controller/pci-hyperv.c
> b/drivers/pci/controller/pci-hyperv.c
> index 95441a35eceb..30f16b882746 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -1900,6 +1900,9 @@ static void hv_eject_device_work(struct work_struct
> *work)
>  			 sizeof(*ejct_pkt), (unsigned long)&ctxt.pkt,
>  			 VM_PKT_DATA_INBAND, 0);
>=20
> +	/* For the get_pcichild() in hv_pci_eject_device() */
> +	put_pcichild(hpdev);
> +	/* For the two refs got in new_pcichild_device() */
>  	put_pcichild(hpdev);
>  	put_pcichild(hpdev);
>  	put_hvpcibus(hpdev->hbus);


Hi,
I backported the patch for linux-4.14.y.

Please use the attached patch, which is [PATCH 1/3]

Thanks,
-- Dexuan

--_002_PU1P153MB0169D8FF719D8718F6B3157ABF090PU1P153MB0169APCP_
Content-Type: application/octet-stream;
	name="For_v4.14.119-0001-PCI-hv-Fix-a-memory-leak-in-hv_eject_device_work.patch"
Content-Description:
 For_v4.14.119-0001-PCI-hv-Fix-a-memory-leak-in-hv_eject_device_work.patch
Content-Disposition: attachment;
	filename="For_v4.14.119-0001-PCI-hv-Fix-a-memory-leak-in-hv_eject_device_work.patch";
	size=974; creation-date="Wed, 15 May 2019 23:17:33 GMT";
	modification-date="Wed, 15 May 2019 23:17:33 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxNmNjZTI4NmJlNWFmOGUzZDU5YzlhZmI3NGE0OTQ0OTMyNTRkY2QzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPgpEYXRl
OiBXZWQsIDE1IE1heSAyMDE5IDE1OjQyOjA3IC0wNzAwClN1YmplY3Q6IFtQQVRDSCBmb3IgdjQu
MTQuMTE5IDEvM10gUENJOiBodjogRml4IGEgbWVtb3J5IGxlYWsgaW4KIGh2X2VqZWN0X2Rldmlj
ZV93b3JrKCkKClRoaXMgcGF0Y2ggaXMgYmFja3BvcnRlZCBmb3IgdjQuMTQuMTE5IGZyb20gdGhl
IG1haW5saW5lCmNvbW1pdCAwNWYxNTFhNzNlYzIgKCJQQ0k6IGh2OiBGaXggYSBtZW1vcnkgbGVh
ayBpbiBodl9lamVjdF9kZXZpY2Vfd29yaygpIikKClNpZ25lZC1vZmYtYnk6IERleHVhbiBDdWkg
PGRlY3VpQG1pY3Jvc29mdC5jb20+Ci0tLQogZHJpdmVycy9wY2kvaG9zdC9wY2ktaHlwZXJ2LmMg
fCAxICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvcGNpL2hvc3QvcGNpLWh5cGVydi5jIGIvZHJpdmVycy9wY2kvaG9zdC9wY2ktaHlwZXJ2LmMK
aW5kZXggNTNkMWMwOGNlZjRkLi4yOTI0NTBjN2RhNjIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNp
L2hvc3QvcGNpLWh5cGVydi5jCisrKyBiL2RyaXZlcnMvcGNpL2hvc3QvcGNpLWh5cGVydi5jCkBA
IC0xOTQxLDYgKzE5NDEsNyBAQCBzdGF0aWMgdm9pZCBodl9lamVjdF9kZXZpY2Vfd29yayhzdHJ1
Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJCQkgVk1fUEtUX0RBVEFfSU5CQU5ELCAwKTsKIAogCXB1
dF9wY2ljaGlsZChocGRldiwgaHZfcGNpZGV2X3JlZl9jaGlsZGxpc3QpOworCXB1dF9wY2ljaGls
ZChocGRldiwgaHZfcGNpZGV2X3JlZl9pbml0aWFsKTsKIAlwdXRfcGNpY2hpbGQoaHBkZXYsIGh2
X3BjaWRldl9yZWZfcG5wKTsKIAlwdXRfaHZwY2lidXMoaHBkZXYtPmhidXMpOwogfQotLSAKMi4x
Ny4xCgo=

--_002_PU1P153MB0169D8FF719D8718F6B3157ABF090PU1P153MB0169APCP_--
