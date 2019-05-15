Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8775E1FCC0
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 01:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfEOXYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 19:24:50 -0400
Received: from mail-eopbgr1310091.outbound.protection.outlook.com ([40.107.131.91]:6029
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726540AbfEOXWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 19:22:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=BV3Dtac1JGMDkWaDDFR7z2iS08WPdtidzuVMyS3cjfGNDaTlYBfFzqReX5i3YOXVuSb+T8ttv8wIKc1Om6SXaYnsSik75rmSKuKSkgE9uknkhJjABINAgAvK0/sldpgfxqyCSbYGpKoqhbDShm+FfiqPl0YxIShU+A231bszWVg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pwDthkFADOsuaAjn33F51oaSkXAd7IepM+FjL9IqMY=;
 b=xdjcPWNsya4JOZyukq9hAkY2v+fQO/eFZGtEkgWqcHZtpCkRjQzM316t3oW/Z207eXEGyE4LjJa5LzKii8TdAQjJWj/SjXgGhLpylzk+uLcMzyMDUVp4lIHeU3mfivbKfHK8KnNGIh16umVfsz6yJ4ksJYp1WLPoUk4quKFK3wA=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pwDthkFADOsuaAjn33F51oaSkXAd7IepM+FjL9IqMY=;
 b=jm2CIYhOyg0A2ws/8j0BYbuv2tHJ0cfM/JILtV1ZfB483dU4i1epDs+g9GtLSxKqPcchb5zZ7bOP4W144h3xd+n6WYWso9mhqEoAbTuMQeZMXMzl8WGqxZVwT4RlHqxiR50R/IyLNyzwuRseZSxphi0sMu/iVsjzWNDF1H9er/g=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0201.APCP153.PROD.OUTLOOK.COM (10.170.190.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.3; Wed, 15 May 2019 23:20:45 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564%4]) with mapi id 15.20.1922.002; Wed, 15 May 2019
 23:20:45 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] PCI: hv: Add pci_destroy_slot() in" failed
 to apply to 4.14-stable tree
Thread-Topic: FAILED: patch "[PATCH] PCI: hv: Add pci_destroy_slot() in"
 failed to apply to 4.14-stable tree
Thread-Index: AQHVCvkvuJde2JXkCEya4HK/uN9kQKZs03Yg
Date:   Wed, 15 May 2019 23:20:45 +0000
Message-ID: <PU1P153MB0169997D3F2274F83391D297BF090@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <155790933699245@kroah.com>
In-Reply-To: <155790933699245@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-15T23:20:42.8922337Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=aa880ce6-4bdc-4f4f-9303-c41ee2b2b5f9;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:3901:5c9:f1fc:42c6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 061d32e3-af81-4324-b5ed-08d6d98bf535
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(49563074)(7193020);SRVR:PU1P153MB0201;
x-ms-traffictypediagnostic: PU1P153MB0201:
x-microsoft-antispam-prvs: <PU1P153MB0201C4BD38F05B2CC53632A6BF090@PU1P153MB0201.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(346002)(366004)(136003)(199004)(189003)(40224003)(5024004)(1511001)(305945005)(256004)(7696005)(71190400001)(71200400001)(9686003)(10290500003)(5660300002)(74316002)(11346002)(8676002)(446003)(33656002)(7736002)(8990500004)(476003)(2501003)(55016002)(6436002)(6506007)(10090500001)(68736007)(4326008)(25786009)(229853002)(6246003)(186003)(6116002)(46003)(102836004)(22452003)(316002)(76176011)(66446008)(66556008)(66476007)(66616009)(86362001)(478600001)(14454004)(81156014)(81166006)(53546011)(99936001)(53936002)(110136005)(8936002)(486006)(66946007)(73956011)(99286004)(76116006)(2906002)(52536014)(86612001)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0201;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8jeG48pAoNfDyGk4zwinxkKsZFshojYNC1G7ewTSZUsAny/9CYcvozMaYJpqLBEqV4LRoTTIRBh177Fzf+d8PDILEwW2dj/W9YUhtU98WVrTR3e2e0etwB/zGW+cmRZDAI4WiuXX8nHvEqH7JOFpHRoOIwoIlKpZJ/i7W2x+GPlAx4e66BrDoE+oE0ZbwV2DdEIwRsJrakS7lE/+YpCkSfF5HEiaAYWMmF6gz7s5+KVaTEJrAwAAj7AfVXLN9/LwadQojcyoNlMnEFjJF0LEf6QmmZG7b70KlH5Xl1EDQHReRc76JGN71AEOMzWjfBcL2wk671e6Mhcvs/tA4aiIJVYsqb3PDbunGZC4Qu8TYz0dU7T+0OU5wf4zPZgi0qKjkYfpvZH2UNcJla3fdzCk6fbO18aKcam2kHaeMtV5B5M=
Content-Type: multipart/mixed;
        boundary="_002_PU1P153MB0169997D3F2274F83391D297BF090PU1P153MB0169APCP_"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 061d32e3-af81-4324-b5ed-08d6d98bf535
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 23:20:45.3035
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

--_002_PU1P153MB0169997D3F2274F83391D297BF090PU1P153MB0169APCP_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Wednesday, May 15, 2019 1:36 AM
> To: Dexuan Cui <decui@microsoft.com>; lorenzo.pieralisi@arm.com; Michael
> Kelley <mikelley@microsoft.com>; stephen@networkplumber.org
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] PCI: hv: Add pci_destroy_slot() in" faile=
d to
> apply to 4.14-stable tree
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
> From 340d455699400f2c2c0f9b3f703ade3085cdb501 Mon Sep 17 00:00:00
> 2001
> From: Dexuan Cui <decui@microsoft.com>
> Date: Mon, 4 Mar 2019 21:34:49 +0000
> Subject: [PATCH] PCI: hv: Add pci_destroy_slot() in
>  pci_devices_present_work(), if necessary
>=20
> When we hot-remove a device, usually the host sends us a PCI_EJECT messag=
e,
> and a PCI_BUS_RELATIONS message with bus_rel->device_count =3D=3D 0.
>=20
> When we execute the quick hot-add/hot-remove test, the host may not send
> us the PCI_EJECT message if the guest has not fully finished the
> initialization by sending the PCI_RESOURCES_ASSIGNED* message to the
> host, so it's potentially unsafe to only depend on the
> pci_destroy_slot() in hv_eject_device_work() because the code path
>=20
> create_root_hv_pci_bus()
>  -> hv_pci_assign_slots()
>=20
> is not called in this case. Note: in this case, the host still sends the
> guest a PCI_BUS_RELATIONS message with bus_rel->device_count =3D=3D 0.
>=20
> In the quick hot-add/hot-remove test, we can have such a race before
> the code path
>=20
> pci_devices_present_work()
>  -> new_pcichild_device()
>=20
> adds the new device into the hbus->children list, we may have already
> received the PCI_EJECT message, and since the tasklet handler
>=20
> hv_pci_onchannelcallback()
>=20
> may fail to find the "hpdev" by calling
>=20
> get_pcichild_wslot(hbus, dev_message->wslot.slot)
>=20
> hv_pci_eject_device() is not called; Later, by continuing execution
>=20
> create_root_hv_pci_bus()
>  -> hv_pci_assign_slots()
>=20
> creates the slot and the PCI_BUS_RELATIONS message with
> bus_rel->device_count =3D=3D 0 removes the device from hbus->children, an=
d
> we end up being unable to remove the slot in
>=20
> hv_pci_remove()
>  -> hv_pci_remove_slots()
>=20
> Remove the slot in pci_devices_present_work() when the device
> is removed to address this race.
>=20
> pci_devices_present_work() and hv_eject_device_work() run in the
> singled-threaded hbus->wq, so there is not a double-remove issue for the
> slot.
>=20
> We cannot offload hv_pci_eject_device() from hv_pci_onchannelcallback()
> to the workqueue, because we need the hv_pci_onchannelcallback()
> synchronously call hv_pci_eject_device() to poll the channel
> ringbuffer to work around the "hangs in hv_compose_msi_msg()" issue
> fixed in commit de0aa7b2f97d ("PCI: hv: Fix 2 hang issues in
> hv_compose_msi_msg()")
>=20
> Fixes: a15f2c08c708 ("PCI: hv: support reporting serial number as slot
> information")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> [lorenzo.pieralisi@arm.com: rewritten commit log]
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
> Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
> Cc: stable@vger.kernel.org
>=20
> diff --git a/drivers/pci/controller/pci-hyperv.c
> b/drivers/pci/controller/pci-hyperv.c
> index b489412e3502..82acd6155adf 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -1776,6 +1776,10 @@ static void pci_devices_present_work(struct
> work_struct *work)
>  		hpdev =3D list_first_entry(&removed, struct hv_pci_dev,
>  					 list_entry);
>  		list_del(&hpdev->list_entry);
> +
> +		if (hpdev->pci_slot)
> +			pci_destroy_slot(hpdev->pci_slot);
> +
>  		put_pcichild(hpdev);
>  	}
>=20

Hi,
I backported the patch for linux-4.14.y.

Please use the attached patch, which is [PATCH 3/3]

Thanks,
-- Dexuan

--_002_PU1P153MB0169997D3F2274F83391D297BF090PU1P153MB0169APCP_
Content-Type: application/octet-stream;
	name="For_v4.14.119-0003-PCI-hv-Add-pci_destroy_slot-in-pci_devices_present_w.patch"
Content-Description:
 For_v4.14.119-0003-PCI-hv-Add-pci_destroy_slot-in-pci_devices_present_w.patch
Content-Disposition: attachment;
	filename="For_v4.14.119-0003-PCI-hv-Add-pci_destroy_slot-in-pci_devices_present_w.patch";
	size=1053; creation-date="Wed, 15 May 2019 23:20:08 GMT";
	modification-date="Wed, 15 May 2019 23:20:08 GMT"
Content-Transfer-Encoding: base64

RnJvbSBkZWMzOTE1NDY2MDdlMDBjM2M4ZDdkNzJlYWQ5ZmY3ZjU5NjZhOTMyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPgpEYXRl
OiBXZWQsIDE1IE1heSAyMDE5IDE2OjA2OjIyIC0wNzAwClN1YmplY3Q6IFtQQVRDSCBmb3IgdjQu
MTQuMTE5IDMvM10gUENJOiBodjogQWRkIHBjaV9kZXN0cm95X3Nsb3QoKSBpbgogcGNpX2Rldmlj
ZXNfcHJlc2VudF93b3JrKCksIGlmIG5lY2Vzc2FyeQoKVGhpcyBwYXRjaCBpcyBiYWNrcG9ydGVk
IGZvciB2NC4xNC4xMTkgZnJvbSB0aGUgbWFpbmxpbmUKMzQwZDQ1NTY5OTQwICgiUENJOiBodjog
QWRkIHBjaV9kZXN0cm95X3Nsb3QoKSBpbiBwY2lfZGV2aWNlc19wcmVzZW50X3dvcmsoKSwgaWYg
bmVjZXNzYXJ5IikKClNpZ25lZC1vZmYtYnk6IERleHVhbiBDdWkgPGRlY3VpQG1pY3Jvc29mdC5j
b20+Ci0tLQogZHJpdmVycy9wY2kvaG9zdC9wY2ktaHlwZXJ2LmMgfCA0ICsrKysKIDEgZmlsZSBj
aGFuZ2VkLCA0IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3BjaS9ob3N0L3Bj
aS1oeXBlcnYuYyBiL2RyaXZlcnMvcGNpL2hvc3QvcGNpLWh5cGVydi5jCmluZGV4IGE1ODI1YmJj
ZGVkNy4uZjU5MWRlMjNmM2QzIDEwMDY0NAotLS0gYS9kcml2ZXJzL3BjaS9ob3N0L3BjaS1oeXBl
cnYuYworKysgYi9kcml2ZXJzL3BjaS9ob3N0L3BjaS1oeXBlcnYuYwpAQCAtMTgyNCw2ICsxODI0
LDEwIEBAIHN0YXRpYyB2b2lkIHBjaV9kZXZpY2VzX3ByZXNlbnRfd29yayhzdHJ1Y3Qgd29ya19z
dHJ1Y3QgKndvcmspCiAJCWhwZGV2ID0gbGlzdF9maXJzdF9lbnRyeSgmcmVtb3ZlZCwgc3RydWN0
IGh2X3BjaV9kZXYsCiAJCQkJCSBsaXN0X2VudHJ5KTsKIAkJbGlzdF9kZWwoJmhwZGV2LT5saXN0
X2VudHJ5KTsKKworCQlpZiAoaHBkZXYtPnBjaV9zbG90KQorCQkJcGNpX2Rlc3Ryb3lfc2xvdCho
cGRldi0+cGNpX3Nsb3QpOworCiAJCXB1dF9wY2ljaGlsZChocGRldiwgaHZfcGNpZGV2X3JlZl9p
bml0aWFsKTsKIAl9CiAKLS0gCjIuMTcuMQoK

--_002_PU1P153MB0169997D3F2274F83391D297BF090PU1P153MB0169APCP_--
