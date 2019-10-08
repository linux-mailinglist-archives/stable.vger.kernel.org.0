Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA18CD03FC
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 01:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfJHXSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 19:18:43 -0400
Received: from mail-eopbgr1300114.outbound.protection.outlook.com ([40.107.130.114]:63904
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbfJHXSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 19:18:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSqGriGoWc230CkXzaxG07q29mE+FcGwFL8IcyTWxi3CDTVzo20r8wb8q8qJoo/fYcssdDfNVIcSAxclhdsOTWSol12x5Twi0HIPpC9kkcHMA8zaQJq+h5SlTZZDNKqf19inaFcpz7yR91X+r2MljvEW+PrlOxin5rXYEmZ6qa11txSRW28n+Kghhd0P7/vyuXq4DN4RUavDXAVyR+arxgg12135/cw1GbhUu+ZDir4juXFZ9jzyzxaLN9MDhcfOHvKfMAUt8Hnt6yUAY0lkp3e8LJlI66Yp4A1Iem5lVA9Rn7kbOcRcYwvvMSDfEdzFAcrNFWqMJJ1BSWPGYATB8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TtCE3UhXdlBp1j8TGhNmnLBoMXxUrBRIXaXPTSqbQs=;
 b=VfjM7sYV5rc6v9A9S9YYxeoX8yciR/RjZJfUvFK4SNjNlnht5A6YuVztnp2Cayam87g+bzTXquUN5RdfJRonqksS5QQPF9Z5Oqs87vNb3hp9OXLrxiu7wJ7YOcflPfjK9x3w8YCrlBm91r3w7FNBLQbAp6ft/QyLZbmZZs09JgLu7CGXZW3Kz8wplkqZ2L0AdTZvMH22id3L9bbBiL3XJ6GjJP6LHe7gHKsLAQRTuuyjEmdWydaHuyKbYQEcBCbWflW/0N322ETLi9XpIPfzdg/Fs6JznyeBY0kQJiR5C577JJzEPXwfL4oJoj43MpwK4ubpcmsn3i58yRKH+4AWHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TtCE3UhXdlBp1j8TGhNmnLBoMXxUrBRIXaXPTSqbQs=;
 b=AuDfcPvQceZQBUDVEYv5jInDcgoo5woEJmnYW3Pxbxhh8c8ZuMzV3zYJei3bRVF9R0Ub8TqATMg0eFQE7Nfokmx/cO2t4BQfz/tjp0xS0w9l7kqyZ0NesR+rDn4SiRViEami5/9rtKdtrm3X4DvTdBuYZlFwGEi/7xHVFh0cBs4=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0108.APCP153.PROD.OUTLOOK.COM (10.170.188.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.2; Tue, 8 Oct 2019 23:17:58 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2%7]) with mapi id 15.20.2367.004; Tue, 8 Oct 2019
 23:17:58 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] PCI: hv: Avoid use of hv_pci_dev->pci_slot
 after freeing it" failed to apply to 4.19-stable tree
Thread-Topic: FAILED: patch "[PATCH] PCI: hv: Avoid use of
 hv_pci_dev->pci_slot after freeing it" failed to apply to 4.19-stable tree
Thread-Index: AQHVffxztOM6Ia/KwUiXWoQc4TiKeKdRX2dw
Date:   Tue, 8 Oct 2019 23:17:58 +0000
Message-ID: <PU1P153MB0169270D001F43783901D7E3BF9A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <157055512417249@kroah.com>
In-Reply-To: <157055512417249@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-08T23:17:56.8949783Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2acd5a1c-ac28-4991-9e2d-fca7ca24a965;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [167.220.2.148]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8564a52-d063-45d3-3808-08d74c45c217
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: PU1P153MB0108:
x-microsoft-antispam-prvs: <PU1P153MB0108E573A861DA329C282AB7BF9A0@PU1P153MB0108.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(189003)(199004)(13464003)(7696005)(33656002)(229853002)(99286004)(6506007)(9686003)(478600001)(6436002)(8676002)(3846002)(8936002)(14454004)(6116002)(55016002)(10290500003)(81166006)(110136005)(66446008)(64756008)(25786009)(66556008)(76176011)(81156014)(316002)(14444005)(256004)(66476007)(6246003)(22452003)(2906002)(66946007)(76116006)(186003)(4326008)(10090500001)(71200400001)(7736002)(52536014)(86362001)(102836004)(8990500004)(71190400001)(74316002)(446003)(476003)(11346002)(486006)(53546011)(66066001)(26005)(5660300002)(2501003)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0108;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ueIdmm5DtEeNZYWdRVUBFqc6SuJmNaaWAR0jNnwVUpughnT/knjGDCAlc8Sy4zvMXmRqnrD1BBTYCmd7c50xboadN3jM4cKkgz9uax5IcSy2k2qqzf32t+YO15Bm2izxE9cOGzJOA6I7KiW5xXKirkQvtwtOAtWXsedmO3v6M8//xyZyxrErAkrI49rnh5MxFnhwrfu4qpolm8hYMiBWSUmOXki0I2DnJ2prBLvJOj5AMh47gj8Cts0zKrZ5pf+TDrLEOJLbcBtdxuRA8eLdsGazxNgv1wNdNWPF0GjtUuXRG6KKCt1qz7pAwXg/0H7562NbC7LTQj22F46OzyvZjkwtJJwbWf+nRJ8kvwL3kukgHQzJXFrVvOxrQyQui6aIZ6E+ojO+pecCxwdoF0v+hlfDttu+CKoI/mF7WsxymhY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8564a52-d063-45d3-3808-08d74c45c217
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 23:17:58.5462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NiP1mbV38PR69niS6zqmSv3oGx6YxVApOD10KF3CI6vDtylk7TuHo30d2shxhO/R9O83O4KPhkfjLGhdmHkS8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0108
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Tuesday, October 8, 2019 10:19 AM
> To: Dexuan Cui <decui@microsoft.com>; lorenzo.pieralisi@arm.com
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] PCI: hv: Avoid use of hv_pci_dev->pci_slo=
t
> after freeing it" failed to apply to 4.19-stable tree
>=20
>=20
> The patch below does not apply to the 4.19-stable tree.
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
> From 533ca1feed98b0bf024779a14760694c7cb4d431 Mon Sep 17 00:00:00
> 2001
> From: Dexuan Cui <decui@microsoft.com>
> Date: Fri, 2 Aug 2019 22:50:20 +0000
> Subject: [PATCH] PCI: hv: Avoid use of hv_pci_dev->pci_slot after freeing=
 it
>=20
> The slot must be removed before the pci_dev is removed, otherwise a panic
> can happen due to use-after-free.
>=20
> Fixes: 15becc2b56c6 ("PCI: hv: Add hv_pci_remove_slots() when we unload t=
he
> driver")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: stable@vger.kernel.org
>=20
> diff --git a/drivers/pci/controller/pci-hyperv.c
> b/drivers/pci/controller/pci-hyperv.c
> index 40b625458afa..2b53976cd9f9 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -2701,8 +2701,8 @@ static int hv_pci_remove(struct hv_device *hdev)
>  		/* Remove the bus from PCI's point of view. */
>  		pci_lock_rescan_remove();
>  		pci_stop_root_bus(hbus->pci_bus);
> -		pci_remove_root_bus(hbus->pci_bus);
>  		hv_pci_remove_slots(hbus);
> +		pci_remove_root_bus(hbus->pci_bus);
>  		pci_unlock_rescan_remove();
>  		hbus->state =3D hv_pcibus_removed;
>  	}

I can't understand why the mail is generated, because v4.19.78 has already =
included=20
the commit 533ca1feed98 ("PCI: hv: Avoid use of hv_pci_dev->pci_slot after =
freeing it")
by
commit 08fdaee2d97bdd55e03308b563783b2612670e8b
Author: Dexuan Cui <decui@microsoft.com>
Date:   Fri Aug 2 22:50:20 2019 +0000

    PCI: hv: Avoid use of hv_pci_dev->pci_slot after freeing it

    [ Upstream commit 533ca1feed98b0bf024779a14760694c7cb4d431 ]

    The slot must be removed before the pci_dev is removed, otherwise a pan=
ic
    can happen due to use-after-free.

    Fixes: 15becc2b56c6 ("PCI: hv: Add hv_pci_remove_slots() when we unload=
 the driver")
    Signed-off-by: Dexuan Cui <decui@microsoft.com>
    Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Sasha Levin <sashal@kernel.org>

Looks I can ignore the mail.

Thanks,
Dexuan
