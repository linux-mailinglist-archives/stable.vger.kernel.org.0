Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4674111786A
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 22:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfLIV0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 16:26:00 -0500
Received: from mail-eopbgr1410115.outbound.protection.outlook.com ([40.107.141.115]:45515
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726354AbfLIVZ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 16:25:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWNO78e0fqp+svQK/zD37KuHTENCJSmurreBJI7Y9TcUujK4leZjcTjP2ZRc8WBrdxXgJlsnmlp+P5rIhFbgp3NXH8q5z3ZdZ2x1XKXluN7M5Kl38ov9s0omi9mKEi/IBNWST/Tr3FMygylTViooo4KsmC+Zi4vSuGUgryULOdc7so/g0WpspXk0XbvMShqOO/oTHOOGdGf7vtl1BierpTGA0fw83K9e0skGpWlrDoekLbdx+cymUR/ZdrUbqGlkKXSfCyeX7x9KBRAu3tukPexwxxGlSPwT0Px5aGyf3Yet35IlUDRQS0Ty13Ro+qWljEXT5mjvLAqdLv5vXi86cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0vcjQK9dWCaxOl36tnEWn/hs8q46Kt7bhJRiQAN0Qb0=;
 b=G4NbmEhnPX/MpN8jR3FAl7cadS4wA8vAwnzjNRAIuGLGinVd2CDCk0K9Foy8iM8ZhPNB8UxfQZV37eOWOVYWBKzXW0FLhLf82xOlheDbWrzAt4wvHTw9OFqLavuPWATX9TKPprcBrewN1czNsMwgoYDh+iPteYbGqL14E0HN+ICIMK6C4Zv3D0PCmMahFsAnlUpaKF623GE2JcQITtIsMZmm9eaXIasBa9PWy+MDGp4Yts5FDwFVpKXQ2zjCVTDW4sVA7noeFtJDUiIxRZF8xJqriKnX1UiIm2RbAoZy2q02MqkP5Wg9B2ixvQQEdsYp8PKPnvsdWMHKHrbFjtcVvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0vcjQK9dWCaxOl36tnEWn/hs8q46Kt7bhJRiQAN0Qb0=;
 b=et5d0NmtE7UKX9Adb0FfdaFVMAHeNr36Yyzzz5b90OeYSa0/oGpI7AeWy/7z0RnjHsBZXJfjUIzapw9qDStxgENAhH0khRMB1hctqKzh8LUIQBBNCJQ/jBlYbxgYLWg1wxlEzZHW4tTZLe2ztQC9AUZBdJZPhntuLyqerbCuNDg=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB5216.jpnprd01.prod.outlook.com (20.179.174.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Mon, 9 Dec 2019 21:25:57 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1%5]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 21:25:57 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Subject: RE: Linux 4.4.207-rc1 8dbad6fe errors
Thread-Topic: Linux 4.4.207-rc1 8dbad6fe errors
Thread-Index: AdWurgt7utNWvBqZQ+ynUVtGfdoeNgABCgaAAAk5SjA=
Date:   Mon, 9 Dec 2019 21:25:56 +0000
Message-ID: <TYAPR01MB2285A8A7863EA1C8DB01E256B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <TYAPR01MB22854300E93B9F6D02232982B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191209170047.GC1290729@kroah.com>
In-Reply-To: <20191209170047.GC1290729@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [90.218.76.176]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aa129bb1-33c2-4ef7-43e5-08d77cee6129
x-ms-traffictypediagnostic: TYAPR01MB5216:
x-microsoft-antispam-prvs: <TYAPR01MB521676F630799902B93973B6B7580@TYAPR01MB5216.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(199004)(189003)(8676002)(66556008)(66946007)(66446008)(81166006)(26005)(4326008)(55016002)(4744005)(33656002)(229853002)(186003)(54906003)(66476007)(64756008)(71190400001)(305945005)(2906002)(71200400001)(966005)(6916009)(498600001)(86362001)(7696005)(6506007)(76116006)(5660300002)(55236004)(81156014)(8936002)(9686003)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB5216;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vW6rIRKu9QvdtDA6ER5dPqskMRAUyoWKcRrgWlujsZ7IuJ6SMaRoNuZB5/dHEc7O9khDWkQs63dP/05i8nKsPhOsjnKBgSw75OwgHO/yac3pOF9bXQ56MB/oGXgjblJPTjeqDb/59y+YylaWo0d21/I/RPRoFxnnjkXe97+DnMU5L5rbD8htjP6zgyWfs5v//qet2Ntci1Vdh3wtjmduX4F2m27d7xX9pKCEK43i1iTaONXFP3Gh3I9FoOw4MiNKRNyHIcid6rYESA9UXKxw+8NWkjUgU8a9tx+w75myg/kUJasVR2cuctVvF8K15L2+W70KBkQkqp66B7N3Pu6H6qpoWXjguEGB3J61EACZt6tNbkzz6FEtwbH35C722OE3dDf8TEVzDsi2k/WKTJrP0uv9eDSyxgkCjk+Vt3CFcYX9lCpHGZyRLD1hLUptVBKBMrRjC5IrN5XzAd8bGj0k5YnEfc+FuUgi3WCG0YON6i4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa129bb1-33c2-4ef7-43e5-08d77cee6129
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 21:25:56.8390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QpGW5nw+P0nO30HjyDEQx/r2z3JqPRiiDVc3dxLcRmJuRl5gV81OZyCI24vK3IpA1PVxy6PrM+VVgkwYoT+7f/LTShkZHE2OmWSb9mnqCP0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5216
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 09 December 2019 17:01
>=20
> On Mon, Dec 09, 2019 at 04:33:17PM +0000, Chris Paterson wrote:
> > Hello Greg, all,
> >
> > I've seen an error with 4.4.207-rc1 (8dbad6fe).
> >
> > 1)
> > Config: arm multi_v7_defconfig
> > Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> /jobs/373483706#L3649
> > Probable culprit: bc15f46a10dc ("serial: pl011: Fix DMA ->flush_buffer(=
)")
> > Issue log:
> > 3649 drivers/tty/serial/amba-pl011.c: In function 'pl011_dma_flush_buff=
er':
> > 3650 drivers/tty/serial/amba-pl011.c:697:2: error: implicit declaration=
 of
> function 'dmaengine_terminate_async'; did you mean
> 'dmaengine_terminate_all'? [-Werror=3Dimplicit-function-declaration]
> > 3651   dmaengine_terminate_async(uap->dmatx.chan);
> > 3652   ^~~~~~~~~~~~~~~~~~~~~~~~~
>=20
> I'll go drop the offending patch now, thanks for letting me know.

Thanks Greg, building okay for me now.

Regards, Chris

>=20
> greg k-h
