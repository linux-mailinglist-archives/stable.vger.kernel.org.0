Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8429D040E
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 01:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfJHXYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 19:24:01 -0400
Received: from mail-eopbgr1310093.outbound.protection.outlook.com ([40.107.131.93]:24137
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725908AbfJHXYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 19:24:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZoNWUudUR4ucAw/wD28MvzCraj/gYQGlmwxRXV+EkGT8uVSmCsXPWGc0KImb58Tsh79opODwzTHhC5Ai7++bnOcoQQoyfxCtEkOAJtCQFu7bX+fqEYGJvxWDmxkuU24M0Zs2LlawgqsVeDSktvgdqN8YUyZXV707WDbaSX92Iz864TvySW02uU9/vxn1udgPRJ6SDI34ZBF3KQV70kgzOfEj/9towPUOsnwpealNH4FIaxmEwDrZ0QHTwjqwFGnONTfLc3dlMjNuhkXAfHrGSymiHqWqo+ntQkPmPn95ZNI985nAWtAr7Ystpjte+/chnE2N5yZOCeFRmHEvESEPfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxd8iflb2jZa/h2dgRJHXiiSzy7jdpNCC1lFwq4bd9s=;
 b=FD/4K1slNWNYV1StMq/1xdDhwXbCFDhFVV8EBYJWFQPXU2A8HsIIwLZxKe/nJuYtahsEDtqNo21X9lyQ5u8QYz+kqTPUHFzhADVgXg+kMYO3gyUAYUDpenrStXZ94QvCpmKBWNqaIlmQm+ymtQrU5nIg1ZllCTpYaa9NOM4MppSi8+6NtkeQEW7mYi6g8K4+VP3Kg+XtlqlSEytBNR3m/rtiKuRdgFgtMoWbHcevJUeDkTrmYCMHD443QRcvSEWZoHkhXyE8wgqzW2zxRPPpDignyKr8CPiVhzWCV9f3J1oq+La+w1C235E/tVzUhDV8RBddXY2VLAqplxtQODzfUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxd8iflb2jZa/h2dgRJHXiiSzy7jdpNCC1lFwq4bd9s=;
 b=T3zXL8H/oEK2iYf9oH1DNk/ng0C6kgxp7Q/RKorIUocL6ADahFYA/nVMlJOSAVmedrdz0YMDQXBoJXwN5b35NPkxX/it3xiAT6B7viuiMu1+Z2r2j+NbZZdrmD2QiDehJ/nHQWZ1vjNoEFaWXhbMsFhqlQTIzzVsY9XExKfp3Mc=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0171.APCP153.PROD.OUTLOOK.COM (10.170.189.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.2; Tue, 8 Oct 2019 23:23:54 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2%7]) with mapi id 15.20.2367.004; Tue, 8 Oct 2019
 23:23:54 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] PCI: hv: Avoid use of hv_pci_dev->pci_slot
 after freeing it" failed to apply to 4.14-stable tree
Thread-Topic: FAILED: patch "[PATCH] PCI: hv: Avoid use of
 hv_pci_dev->pci_slot after freeing it" failed to apply to 4.14-stable tree
Thread-Index: AQHVffx5RZmATKTtz0KM2bJwCvpDqadRYpFA
Date:   Tue, 8 Oct 2019 23:23:53 +0000
Message-ID: <PU1P153MB0169B5DB9E380324F1E139C4BF9A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <15705551249325@kroah.com>
In-Reply-To: <15705551249325@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-08T23:23:52.2485670Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c9b84378-a495-480e-86b4-28e1308c8257;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [167.220.2.148]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da3da919-7d89-4d47-49bf-08d74c4695e8
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: PU1P153MB0171:
x-microsoft-antispam-prvs: <PU1P153MB0171FBB36A01AEB2B9081308BF9A0@PU1P153MB0171.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(199004)(189003)(71200400001)(71190400001)(26005)(6506007)(10290500003)(66946007)(53546011)(66476007)(66556008)(14454004)(66446008)(64756008)(9686003)(4326008)(76116006)(76176011)(256004)(14444005)(478600001)(186003)(7696005)(55016002)(6436002)(6246003)(229853002)(2906002)(33656002)(99286004)(102836004)(81156014)(8936002)(81166006)(8676002)(66066001)(316002)(22452003)(486006)(10090500001)(74316002)(25786009)(86362001)(52536014)(5660300002)(8990500004)(2501003)(110136005)(6116002)(3846002)(7736002)(446003)(476003)(305945005)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0171;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y5BGddFsRsAhaM2/1uOUgvOC5h8+7jSoVORRq52eDKYQDdUZEGYx9SEXWGgq7351FGVpENLvsvjX0kZ7WJHNL2ims4ARq9q2lpG16tyhXZ1QSjPCa2McdvrsDTCFprd5v16Imo8zVwGl6h75AmWE0Qba6jAz7OXmpWw0CPZkomZg7JezvmHGad6fUlb9sZfVEOSQFhD+2eoasjXHlIIUKRUwhPc3VvnVV9ObOFB5N+D7T+OiJZkyQ/vkkrpTI41Az/eRFQZHhpAoRSjykedmrpZv5bnT1NYBgtc83Re0GZBCK6qAvUs2Jg6ui2V62l0pZNrEAyBvVtEwTFaSgym836nJR3fd3EhYy5QnE9wOHlIs1ajBFm57sAxZ2eHowEMMNxm1ucA4EEm22hd7uXf7ovFXtBiTBS92YAjlGasbw4M=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da3da919-7d89-4d47-49bf-08d74c4695e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 23:23:53.8327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zDtPJfZ4BOBHafaasnVQvEYg40/sWgPqyRCaRC7T+Gw+H0GvoVbN4+bYro2fO2DZMF0NGKl/9ovK/VOnRiq/jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0171
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Tuesday, October 8, 2019 10:19 AM
> To: Dexuan Cui <decui@microsoft.com>; lorenzo.pieralisi@arm.com
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] PCI: hv: Avoid use of hv_pci_dev->pci_slo=
t
> after freeing it" failed to apply to 4.14-stable tree
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

It looks this mail is also generated in error, because the commit
533ca1feed98b0bf024779a14760694c7cb4d431 has already been in
v4.14.148.

Thanks,
Dexuan
