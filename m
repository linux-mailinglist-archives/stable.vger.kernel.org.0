Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43AD6F27B1
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 07:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfKGGg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 01:36:57 -0500
Received: from mail-eopbgr30073.outbound.protection.outlook.com ([40.107.3.73]:49474
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725763AbfKGGg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 01:36:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LAuI5Bu0tvj3jgkq6Q5oqwk5nKxm3jaVGi6euptC5Xm1JGPvhwPz5vJvTK4Q0AUNkAWrYTQbbd64yqo6OzxeEU8TePj/NiOeU4wLxbT/BBs5Joa7xPeL5az9Y8imBjAykk1e9gHzRTAG5EFlf2QCNHMdd3zc1jWdFS79j2tgIgBJ+zoV1IfFif/ROw+JZ2Bgomy7OCy4VDqKGTYK3rYGEDVbltF3Sd4bUP0C1lOjgbPI4ls68xpaO1GsZjaif1UczlYRX9EOSDXyy4i8V7I74DqKa18WSBOxTWA4zBUYZ1qZcwWAUCPiyexP0TOqwLArIbx7FSkvNt6OPPR08daWnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSnGdMNHEUvKj6lC+s8Aqsw2IbOhrzb8BJg5V2UqlOc=;
 b=eRH0x3X2HwnaMLWb+mz0pVHWnO3nf2il232e2suOzVxOIPpmTGEptgoOtspmXGRhunH36QA9z0WsSZCs9RrU/LXqp7bsjNNzFhzEj1f0YiXke0uvi5G5uOsw894iBF1mnDqIzSBtP5Yxe+hZ8AC1prg0zAhJj9St3cQJYoABCrGGX9BmTQH2DYIF6yeX05YzkLonnoXKtxG1QtnYGe2zxylC18pRG/j/bzyodx23cpwiVa5PoCTUp8cUREPGh/7ESh/5JnQXmzfNfTMf0iDtHgMb1mgkxk5ZYMHm466dQ9RAh73ASXFCR5wmRjsbXaPShrEQQh77ewgALD+JZ5C6zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSnGdMNHEUvKj6lC+s8Aqsw2IbOhrzb8BJg5V2UqlOc=;
 b=Rrv3XhZ6tzPHvSO3jWOZp2aegRFo7PEk5o9aoOjjBjr+sDoYA+tYfPKo9p2+Hun2QSPaKSCxA+0M1dso67JQT/spTjVf00jq6DK4T2+YdffMviYgONFeAJVFYG/jth4xypFlov+5lfi0eMz1z+OKmkwYVr7+HMtehEtcfd3rGZ0=
Received: from DB7PR04MB4490.eurprd04.prod.outlook.com (52.135.138.150) by
 DB7PR04MB4108.eurprd04.prod.outlook.com (52.135.128.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Thu, 7 Nov 2019 06:36:52 +0000
Received: from DB7PR04MB4490.eurprd04.prod.outlook.com
 ([fe80::115f:1e4f:9ceb:2a2c]) by DB7PR04MB4490.eurprd04.prod.outlook.com
 ([fe80::115f:1e4f:9ceb:2a2c%7]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 06:36:52 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.com" <jslaby@suse.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "festevam@gmail.com" <festevam@gmail.com>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Duan <fugang.duan@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH V2] tty: serial: fsl_lpuart: use the sg count from
 dma_map_sg
Thread-Topic: [PATCH V2] tty: serial: fsl_lpuart: use the sg count from
 dma_map_sg
Thread-Index: AQHVlRYSjb10LGdSBU+AJ5B7rW7xA6d/QS9A
Date:   Thu, 7 Nov 2019 06:36:52 +0000
Message-ID: <DB7PR04MB4490FC1A30F476F876D99D2788780@DB7PR04MB4490.eurprd04.prod.outlook.com>
References: <1573094911-448-1-git-send-email-peng.fan@nxp.com>
In-Reply-To: <1573094911-448-1-git-send-email-peng.fan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 85afdbe5-0f06-476b-560f-08d7634ce02d
x-ms-traffictypediagnostic: DB7PR04MB4108:|DB7PR04MB4108:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB41081E73706CCFADCB05812B88780@DB7PR04MB4108.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(189003)(199004)(102836004)(110136005)(2201001)(66066001)(8676002)(64756008)(229853002)(99286004)(6246003)(86362001)(26005)(71200400001)(76176011)(66476007)(7696005)(66446008)(9686003)(256004)(55016002)(6436002)(6506007)(66946007)(76116006)(66556008)(44832011)(8936002)(25786009)(486006)(11346002)(3846002)(446003)(476003)(81156014)(81166006)(4326008)(52536014)(71190400001)(2906002)(54906003)(186003)(7736002)(6116002)(478600001)(14454004)(5660300002)(74316002)(316002)(305945005)(33656002)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4108;H:DB7PR04MB4490.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b+RJrLOQT0li735avcV5C7/J3RYMVRLkhjR97KdMiegG9nHx7rxvUgThlANDEq7ebAgDGwh0GQVKR3+o0WaiAX5vkXCno1ncrx8s4KlvFiVM4kgTN4z+BW+OKPtPtIU6r761spAhmZqYeYUzkI36F6TwfPBk8KV/33ZAvbxhEGTnysT/aAIJHkISc88jVFs/5iQH1zDHR/nlqwwD2rAqtHGMYcrwtrVoz9d2/ingQ8YP0j78o20rpqC0XqzxAKvahEwcV2Nhio4WV8YWD1FKeG53W9T10nAvxKGNHQ7P0qHkJbhailnZxrvL7cZM/ecsK9za43P+jveDP5UZhIrLXs8pNQ3lbhVd2A3BfavCIrMuOIgCm7ZoGvAYMgTGToxYgxTGszvmgHcIiBzDuJ45HCbH3SYgs4Hm9Sl83hbCkNdZKJ4a3+W7+2xGuIWdEAPf
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85afdbe5-0f06-476b-560f-08d7634ce02d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 06:36:52.5586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7dne+H+3uBUiLaR5lBza/fQUfQtf9xq0WrQ89gpGhyJ4hB4LkrmrJgVIEuP41ytJBhpwOJnlWLriqkFr4REM6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4108
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Subject: [PATCH V2] tty: serial: fsl_lpuart: use the sg count from dma_ma=
p_sg

Ignore this patch. Keep v1.

Thanks,
Peng.

>=20
> From: Peng Fan <peng.fan@nxp.com>
>=20
> The dmaengine_prep_slave_sg needs to use sg count returned by
> dma_map_sg, not use sport->dma_tx_nents, because the return value of
> dma_map_sg is not always same with "nents".
>=20
> When enabling iommu for lpuart + edma, iommu framework may concatenate
> two sgs into one.
>=20
> Fixes: 6250cc30c4c4e ("tty: serial: fsl_lpuart: Use scatter/gather DMA fo=
r Tx")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
>=20
> V2:
>  Assign ret to sport->dma_tx_nents, then we no need to fix dma_unmap_sg
> Hi Greg,
>   I saw v1 patch merged to tty-next, please help to replace with V2 if th=
is
>   is ok for you, or you need I have a follow up fix for v1.
>=20
>  drivers/tty/serial/fsl_lpuart.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpu=
art.c index
> 3e17bb8a0b16..ec5ea098669e 100644
> --- a/drivers/tty/serial/fsl_lpuart.c
> +++ b/drivers/tty/serial/fsl_lpuart.c
> @@ -436,6 +436,7 @@ static void lpuart_dma_tx(struct lpuart_port *sport)
>  		return;
>  	}
>=20
> +	sport->dma_tx_nents =3D ret;
>  	sport->dma_tx_desc =3D dmaengine_prep_slave_sg(sport->dma_tx_chan,
> sgl,
>  					sport->dma_tx_nents,
>  					DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
> --
> 2.16.4

