Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9E61FCBC
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 01:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfEOXXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 19:23:40 -0400
Received: from mail-eopbgr1310114.outbound.protection.outlook.com ([40.107.131.114]:44880
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726218AbfEOXVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 19:21:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=I4GBQW1v57IhvQ8k8F3mFJ0F7qCbZH9dk09qgc3eGRe8BtvO0AABP3n/T8nCQuPfrMWYQ+MckN8RKpgxOkfyGf6aU6eu84ory/I72pXJYdRsoNW9od05sZa2HQEtH/BIs9lmAZyN4K4OPCqpH90I1vizmlPtn+RMM5KLfTW3jeY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/tDhEvnIe9SrdmOYCQBIekaD3rTG0sUi0ENfYWudP0=;
 b=mDl2cG34gUn1W+Et4zfr36IwoKiTYjCm+HxP8eb/kkOYkxXV+G8bHm8WMKItgYNyon1zFj/zh5nwUgqE5pvz5+AqVcSmczIaA2QWTRcaCU7n/x4rVRF64tdJz0ciNKf3xCp6nKgSzum7fB+3UkG7zpUK47e+6nIaz2xcAxYmhbc=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/tDhEvnIe9SrdmOYCQBIekaD3rTG0sUi0ENfYWudP0=;
 b=SxyMugzV1eAJl7fissSzKb1kQYNQXVk70xiJ7zRaaWHZUqi8sYYHmhzQ6PT8EO9x23mrep5M1P9jO6d8OkPLAA73Z1fCji4pLNx63i1UoO2HJC8V8GxpwBVzJsQOGoa+5WqoDX/IVWezGCY08+FTLmZ43V5P/VMRX061HPcj0ks=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0201.APCP153.PROD.OUTLOOK.COM (10.170.190.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.3; Wed, 15 May 2019 23:19:41 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564%4]) with mapi id 15.20.1922.002; Wed, 15 May 2019
 23:19:41 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] PCI: hv: Add hv_pci_remove_slots() when we
 unload the driver" failed to apply to 4.14-stable tree
Thread-Topic: FAILED: patch "[PATCH] PCI: hv: Add hv_pci_remove_slots() when
 we unload the driver" failed to apply to 4.14-stable tree
Thread-Index: AQHVCvklFdJlF4d8u0W/Jc6676IaGKZs00mQ
Date:   Wed, 15 May 2019 23:19:40 +0000
Message-ID: <PU1P153MB01696C8539CBD25904792049BF090@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <155790931816178@kroah.com>
In-Reply-To: <155790931816178@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-15T23:19:38.8050516Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a9836aad-fa7d-4b5a-8f23-1ff6ee24878c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:3901:5c9:f1fc:42c6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c10b9ca8-62a3-444a-0cd1-08d6d98bceb6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(49563074)(7193020);SRVR:PU1P153MB0201;
x-ms-traffictypediagnostic: PU1P153MB0201:
x-microsoft-antispam-prvs: <PU1P153MB02019590DE04300D3B33222ABF090@PU1P153MB0201.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(346002)(366004)(136003)(199004)(189003)(40224003)(5024004)(14444005)(1511001)(305945005)(256004)(7696005)(71190400001)(71200400001)(9686003)(10290500003)(5660300002)(74316002)(11346002)(8676002)(446003)(33656002)(7736002)(8990500004)(476003)(6636002)(2501003)(55016002)(6436002)(6506007)(10090500001)(68736007)(4326008)(25786009)(229853002)(6246003)(186003)(6116002)(46003)(102836004)(22452003)(316002)(76176011)(66446008)(66556008)(66476007)(66616009)(86362001)(478600001)(14454004)(81156014)(81166006)(53546011)(99936001)(53936002)(110136005)(8936002)(486006)(66946007)(73956011)(99286004)(76116006)(2906002)(52536014)(86612001)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0201;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ty1ZaiE7UcWEDGF6PXkg0OU+3+coUiJ57TqlTUvOsJwtmbTGIJh0nD1d/JcHvdAiqcTWLaxGmcoaxLAyz0prUQHaYRzjGIKyo4JD5pO+nje4uf91doUJubcHnRWXBjO2UAI+QvPS1r0btY4t3nBN54mgk5+/lbt0EDwTbSTkq09o3J7dhO62cvRQ7HZPvC32YLg/znEkUxozwhODjp96qKYjUhvUIBvOhWeVlZ3DEQJcZXI8wjjaI/jOGnu+x4tdmHxa7y+iPQd/zSZcaHJMtRDK/iwnMtE+oeLS5DbA+HfiK/pO4idVNeBHXhvNabsxCoi1md1FRP+93MDz7LdzvC9DxTDDzS+KnFHqtbSOOP9igGEYKzPjknhFuKqcJsCnhoKkCKsKOGkI9Y9K232ZOGl/HskvKDY2L0m5hxYvrQo=
Content-Type: multipart/mixed;
        boundary="_002_PU1P153MB01696C8539CBD25904792049BF090PU1P153MB0169APCP_"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c10b9ca8-62a3-444a-0cd1-08d6d98bceb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 23:19:40.7704
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

--_002_PU1P153MB01696C8539CBD25904792049BF090PU1P153MB0169APCP_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Wednesday, May 15, 2019 1:35 AM
> To: Dexuan Cui <decui@microsoft.com>; lorenzo.pieralisi@arm.com; Michael
> Kelley <mikelley@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] PCI: hv: Add hv_pci_remove_slots() when w=
e
> unload the driver" failed to apply to 4.14-stable tree
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
> From 15becc2b56c6eda3d9bf5ae993bafd5661c1fad1 Mon Sep 17 00:00:00
> 2001
> From: Dexuan Cui <decui@microsoft.com>
> Date: Mon, 4 Mar 2019 21:34:48 +0000
> Subject: [PATCH] PCI: hv: Add hv_pci_remove_slots() when we unload the
> driver
>=20
> When we unload the pci-hyperv host controller driver, the host does not
> send us a PCI_EJECT message.
>=20
> In this case we also need to make sure the sysfs PCI slot directory is
> removed, otherwise a command on a slot file eg:
>=20
> "cat /sys/bus/pci/slots/2/address"
>=20
> will trigger a
>=20
> "BUG: unable to handle kernel paging request"
>=20
> and, if we unload/reload the driver several times we would end up with
> stale slot entries in PCI slot directories in /sys/bus/pci/slots/
>=20
> root@localhost:~# ls -rtl  /sys/bus/pci/slots/
> total 0
> drwxr-xr-x 2 root root 0 Feb  7 10:49 2
> drwxr-xr-x 2 root root 0 Feb  7 10:49 2-1
> drwxr-xr-x 2 root root 0 Feb  7 10:51 2-2
>=20
> Add the missing code to remove the PCI slot and fix the current
> behaviour.
>=20
> Fixes: a15f2c08c708 ("PCI: hv: support reporting serial number as slot
> information")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> [lorenzo.pieralisi@arm.com: reformatted the log]
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Reviewed-by: Stephen Hemminger <sthemmin@microsoft.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Cc: stable@vger.kernel.org
>=20
> diff --git a/drivers/pci/controller/pci-hyperv.c
> b/drivers/pci/controller/pci-hyperv.c
> index 30f16b882746..b489412e3502 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -1486,6 +1486,21 @@ static void hv_pci_assign_slots(struct
> hv_pcibus_device *hbus)
>  	}
>  }
>=20
> +/*
> + * Remove entries in sysfs pci slot directory.
> + */
> +static void hv_pci_remove_slots(struct hv_pcibus_device *hbus)
> +{
> +	struct hv_pci_dev *hpdev;
> +
> +	list_for_each_entry(hpdev, &hbus->children, list_entry) {
> +		if (!hpdev->pci_slot)
> +			continue;
> +		pci_destroy_slot(hpdev->pci_slot);
> +		hpdev->pci_slot =3D NULL;
> +	}
> +}
> +
>  /**
>   * create_root_hv_pci_bus() - Expose a new root PCI bus
>   * @hbus:	Root PCI bus, as understood by this driver
> @@ -2680,6 +2695,7 @@ static int hv_pci_remove(struct hv_device *hdev)
>  		pci_lock_rescan_remove();
>  		pci_stop_root_bus(hbus->pci_bus);
>  		pci_remove_root_bus(hbus->pci_bus);
> +		hv_pci_remove_slots(hbus);
>  		pci_unlock_rescan_remove();
>  		hbus->state =3D hv_pcibus_removed;
>  	}

Hi,
I backported the patch for linux-4.14.y.

Please use the attached patch, which is [PATCH 2/3]

Thanks,
-- Dexuan

--_002_PU1P153MB01696C8539CBD25904792049BF090PU1P153MB0169APCP_
Content-Type: application/octet-stream;
	name="For_v4.14.119-0002-PCI-hv-Add-hv_pci_remove_slots-when-we-unload-the-dr.patch"
Content-Description:
 For_v4.14.119-0002-PCI-hv-Add-hv_pci_remove_slots-when-we-unload-the-dr.patch
Content-Disposition: attachment;
	filename="For_v4.14.119-0002-PCI-hv-Add-hv_pci_remove_slots-when-we-unload-the-dr.patch";
	size=1543; creation-date="Wed, 15 May 2019 23:19:18 GMT";
	modification-date="Wed, 15 May 2019 23:19:18 GMT"
Content-Transfer-Encoding: base64

RnJvbSA5NDZlM2Q0M2I0Mzc4ZTA0MDU5M2FjNWEzYTQ4ZWU0NmQ4ZjNjZDc3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPgpEYXRl
OiBXZWQsIDE1IE1heSAyMDE5IDE1OjU5OjE1IC0wNzAwClN1YmplY3Q6IFtQQVRDSCBmb3IgdjQu
MTQuMTE5IDIvM10gUENJOiBodjogQWRkIGh2X3BjaV9yZW1vdmVfc2xvdHMoKSB3aGVuIHdlCiB1
bmxvYWQgdGhlIGRyaXZlcgoKVGhpcyBwYXRjaCBpcyBiYWNrcG9ydGVkIGZvciB2NC4xNC4xMTkg
ZnJvbSB0aGUgbWFpbmxpbmUKY29tbWl0IDE1YmVjYzJiNTZjNiAoIlBDSTogaHY6IEFkZCBodl9w
Y2lfcmVtb3ZlX3Nsb3RzKCkgd2hlbiB3ZSB1bmxvYWQgdGhlIGRyaXZlciIpCgpTaWduZWQtb2Zm
LWJ5OiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPgotLS0KIGRyaXZlcnMvcGNpL2hv
c3QvcGNpLWh5cGVydi5jIHwgMTYgKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDE2
IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3BjaS9ob3N0L3BjaS1oeXBlcnYu
YyBiL2RyaXZlcnMvcGNpL2hvc3QvcGNpLWh5cGVydi5jCmluZGV4IDI5MjQ1MGM3ZGE2Mi4uYTU4
MjViYmNkZWQ3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3BjaS9ob3N0L3BjaS1oeXBlcnYuYworKysg
Yi9kcml2ZXJzL3BjaS9ob3N0L3BjaS1oeXBlcnYuYwpAQCAtMTUxMyw2ICsxNTEzLDIxIEBAIHN0
YXRpYyB2b2lkIGh2X3BjaV9hc3NpZ25fc2xvdHMoc3RydWN0IGh2X3BjaWJ1c19kZXZpY2UgKmhi
dXMpCiAJfQogfQogCisvKgorICogUmVtb3ZlIGVudHJpZXMgaW4gc3lzZnMgcGNpIHNsb3QgZGly
ZWN0b3J5LgorICovCitzdGF0aWMgdm9pZCBodl9wY2lfcmVtb3ZlX3Nsb3RzKHN0cnVjdCBodl9w
Y2lidXNfZGV2aWNlICpoYnVzKQoreworCXN0cnVjdCBodl9wY2lfZGV2ICpocGRldjsKKworCWxp
c3RfZm9yX2VhY2hfZW50cnkoaHBkZXYsICZoYnVzLT5jaGlsZHJlbiwgbGlzdF9lbnRyeSkgewor
CQlpZiAoIWhwZGV2LT5wY2lfc2xvdCkKKwkJCWNvbnRpbnVlOworCQlwY2lfZGVzdHJveV9zbG90
KGhwZGV2LT5wY2lfc2xvdCk7CisJCWhwZGV2LT5wY2lfc2xvdCA9IE5VTEw7CisJfQorfQorCiAv
KioKICAqIGNyZWF0ZV9yb290X2h2X3BjaV9idXMoKSAtIEV4cG9zZSBhIG5ldyByb290IFBDSSBi
dXMKICAqIEBoYnVzOglSb290IFBDSSBidXMsIGFzIHVuZGVyc3Rvb2QgYnkgdGhpcyBkcml2ZXIK
QEAgLTI3MTksNiArMjczNCw3IEBAIHN0YXRpYyBpbnQgaHZfcGNpX3JlbW92ZShzdHJ1Y3QgaHZf
ZGV2aWNlICpoZGV2KQogCQlwY2lfbG9ja19yZXNjYW5fcmVtb3ZlKCk7CiAJCXBjaV9zdG9wX3Jv
b3RfYnVzKGhidXMtPnBjaV9idXMpOwogCQlwY2lfcmVtb3ZlX3Jvb3RfYnVzKGhidXMtPnBjaV9i
dXMpOworCQlodl9wY2lfcmVtb3ZlX3Nsb3RzKGhidXMpOwogCQlwY2lfdW5sb2NrX3Jlc2Nhbl9y
ZW1vdmUoKTsKIAkJaGJ1cy0+c3RhdGUgPSBodl9wY2lidXNfcmVtb3ZlZDsKIAl9Ci0tIAoyLjE3
LjEKCg==

--_002_PU1P153MB01696C8539CBD25904792049BF090PU1P153MB0169APCP_--
