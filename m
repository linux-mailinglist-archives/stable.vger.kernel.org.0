Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5CC1FCB6
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 01:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbfEOXOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 19:14:39 -0400
Received: from mail-eopbgr1300100.outbound.protection.outlook.com ([40.107.130.100]:60768
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbfEOXOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 19:14:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=gG/G5yNJkt2B7vO8VPBRtBaJwTmDBULydvBE9W9EBdgEzmWyGpYLBbW5h9+m2gYZOldtg/war6XVDu8yaugUAfJNka2XeKvTbPxTkW7/KL3COhuTMwDp3Tk2lfEkcS4SIHhU7eQKQWuejZunMZvnaA6ukY/9vXsgn9PXSBxpm9w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MXs9vVRJOl51I8Bp7WHekoRbvPl/ePUzlrKd6PwhSds=;
 b=WQNswnEDUeUGp48LXvz1ovKPggFOtY5L7WIwOqiyMnBZ84a1n+FYmKwTqwPtRXg8n14yn6OaY3NnLPpl+jEhORu+T1VSWQLhF75ic+I4CwN69PPIcfwrt013MEscn06FFpT0R56q6MqLafJ9ARo4Bed4SkxXcgew+qZa9UuyAqU=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MXs9vVRJOl51I8Bp7WHekoRbvPl/ePUzlrKd6PwhSds=;
 b=lnnmY9C1YdcGM2GFcA4iEkGH5VOrJ0GrucRegWsfTo+7ngEGfcmRALp8LPbtXE6U5vo9rgFZvSCz0cX+uISmAKo3uZRTys7B1iVgbCyqPvNnMbTU8LxW1oZTv0ZFyfU6dRSai+to7Wz839wezG9gNpDAo4DX/6sNsfeBaQyiNhQ=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0155.APCP153.PROD.OUTLOOK.COM (10.170.189.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.6; Wed, 15 May 2019 23:14:32 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564%4]) with mapi id 15.20.1922.002; Wed, 15 May 2019
 23:14:32 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] PCI: hv: Fix a memory leak in
 hv_eject_device_work()" failed to apply to 4.9-stable tree
Thread-Topic: FAILED: patch "[PATCH] PCI: hv: Fix a memory leak in
 hv_eject_device_work()" failed to apply to 4.9-stable tree
Thread-Index: AQHVCvkOP8f2OJajjk63Md5iErUKJaZs0TcQ
Date:   Wed, 15 May 2019 23:14:31 +0000
Message-ID: <PU1P153MB0169E1485667016EAE6EDB84BF090@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <1557909271235151@kroah.com>
In-Reply-To: <1557909271235151@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-15T23:14:29.6442995Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b7be6d5a-77c9-4784-a462-0cdb865580e3;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:3901:5c9:f1fc:42c6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cbd0a721-681b-4c15-11a4-08d6d98b167d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(49563074)(7193020);SRVR:PU1P153MB0155;
x-ms-traffictypediagnostic: PU1P153MB0155:
x-microsoft-antispam-prvs: <PU1P153MB015595D04602104CF95437A7BF090@PU1P153MB0155.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(396003)(39860400002)(136003)(346002)(376002)(366004)(199004)(189003)(53936002)(110136005)(22452003)(73956011)(6246003)(316002)(6436002)(7736002)(55016002)(9686003)(86362001)(14454004)(229853002)(99286004)(305945005)(186003)(5660300002)(486006)(10290500003)(5024004)(71200400001)(71190400001)(46003)(66616009)(66476007)(86612001)(446003)(66946007)(76116006)(11346002)(476003)(478600001)(66556008)(64756008)(66446008)(256004)(33656002)(81166006)(81156014)(8676002)(2501003)(10090500001)(7696005)(53546011)(68736007)(76176011)(6506007)(102836004)(99936001)(1511001)(74316002)(2906002)(6116002)(4326008)(8936002)(8990500004)(25786009)(52536014)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0155;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 012ilsvePtcDQFIDVxqSqaSXkJBvrIJfhPghq2pGIs7sWWW+tLOChj72ARCrDPT1X8hhssIc5BVYaL/CyKED5EWt5tRx9nxFxSYYijUPIAklvcyNIIumtCCdygPyZanmvTJ+Tcu0pPLLZJbRdGXuFt6SorZfyyFr7BIckSqB6031PEEm4zD0344iTzupqzlzBRHKoK1ycf17/vsbWk+lAh9vdhrJpZ5dpITOA7jdkoSwHSm+DEg6ZbPa+6bwARIXtbpespyT99NEyNKIKQxoULxCiSLq8GJpKi5BD2e4W+d/ViqrbLcggHVQAZ98rXFmBoodA0CuV4GTvrlfkntudSrlive+9HkfMZ++/bBEct0ai+pfy61p16SxeQrv5OnrkpmOVQ/oCrU7wNMp42mY+TaUfRQsqhKEeNB8r+J1X9A=
Content-Type: multipart/mixed;
        boundary="_002_PU1P153MB0169E1485667016EAE6EDB84BF090PU1P153MB0169APCP_"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd0a721-681b-4c15-11a4-08d6d98b167d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 23:14:31.7372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0155
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_PU1P153MB0169E1485667016EAE6EDB84BF090PU1P153MB0169APCP_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Wednesday, May 15, 2019 1:35 AM
> To: Dexuan Cui <decui@microsoft.com>; lorenzo.pieralisi@arm.com; Michael
> Kelley <mikelley@microsoft.com>; stephen@networkplumber.org
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] PCI: hv: Fix a memory leak in
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
I backported the patch for linux-4.9.y. Please use the attached patch.

Thanks,
-- Dexuan

--_002_PU1P153MB0169E1485667016EAE6EDB84BF090PU1P153MB0169APCP_
Content-Type: application/octet-stream;
	name="For-linux-4.9.y_v4.9.176_PCI-hv-Fix-a-memory-leak-in-hv_eject_device_work.patch"
Content-Description:
 For-linux-4.9.y_v4.9.176_PCI-hv-Fix-a-memory-leak-in-hv_eject_device_work.patch
Content-Disposition: attachment;
	filename="For-linux-4.9.y_v4.9.176_PCI-hv-Fix-a-memory-leak-in-hv_eject_device_work.patch";
	size=1004; creation-date="Wed, 15 May 2019 23:12:16 GMT";
	modification-date="Wed, 15 May 2019 23:12:16 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxNTFmMmJjMmFmY2M3MWRkYmE3YjE5NzhjYjczNmNmMTNjNGVlZmYwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPgpEYXRl
OiBXZWQsIDE1IE1heSAyMDE5IDE1OjQyOjA3IC0wNzAwClN1YmplY3Q6IFtQQVRDSF1bRm9yIHY0
LjkuMTc2XSBQQ0k6IGh2OiBGaXggYSBtZW1vcnkgbGVhayBpbiBodl9lamVjdF9kZXZpY2Vfd29y
aygpCgpUaGlzIHBhdGNoIGlzIGJhY2twb3J0ZWQgZm9yIHY0LjkuMTc2IGZyb20gdGhlIG1haW5s
aW5lCmNvbW1pdCAwNWYxNTFhNzNlYzIgKCJQQ0k6IGh2OiBGaXggYSBtZW1vcnkgbGVhayBpbiBo
dl9lamVjdF9kZXZpY2Vfd29yaygpIikKClNpZ25lZC1vZmYtYnk6IERleHVhbiBDdWkgPGRlY3Vp
QG1pY3Jvc29mdC5jb20+Ci0tLQogZHJpdmVycy9wY2kvaG9zdC9wY2ktaHlwZXJ2LmMgfCAxICsK
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNp
L2hvc3QvcGNpLWh5cGVydi5jIGIvZHJpdmVycy9wY2kvaG9zdC9wY2ktaHlwZXJ2LmMKaW5kZXgg
YjRkOGNjZmQ5ZjdjLi4yMDBiNDE1NzY1MjYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNpL2hvc3Qv
cGNpLWh5cGVydi5jCisrKyBiL2RyaXZlcnMvcGNpL2hvc3QvcGNpLWh5cGVydi5jCkBAIC0xNjIw
LDYgKzE2MjAsNyBAQCBzdGF0aWMgdm9pZCBodl9lamVjdF9kZXZpY2Vfd29yayhzdHJ1Y3Qgd29y
a19zdHJ1Y3QgKndvcmspCiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaHBkZXYtPmhidXMtPmRl
dmljZV9saXN0X2xvY2ssIGZsYWdzKTsKIAogCXB1dF9wY2ljaGlsZChocGRldiwgaHZfcGNpZGV2
X3JlZl9jaGlsZGxpc3QpOworCXB1dF9wY2ljaGlsZChocGRldiwgaHZfcGNpZGV2X3JlZl9pbml0
aWFsKTsKIAlwdXRfcGNpY2hpbGQoaHBkZXYsIGh2X3BjaWRldl9yZWZfcG5wKTsKIAlwdXRfaHZw
Y2lidXMoaHBkZXYtPmhidXMpOwogfQotLSAKMi4xNy4xCgo=

--_002_PU1P153MB0169E1485667016EAE6EDB84BF090PU1P153MB0169APCP_--
