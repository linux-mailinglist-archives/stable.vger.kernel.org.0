Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E56213535D
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 07:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgAIGyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 01:54:46 -0500
Received: from mail-mw2nam10on2085.outbound.protection.outlook.com ([40.107.94.85]:6241
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726541AbgAIGyq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jan 2020 01:54:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYE0vKGYt2W5hioBwsoTer5FcFK91ObaOlFom9DCC94ozKew2Td15aT25MjRgNm6SrIQVABIEuH0oDFOlbngzHG10kP6PgNJgIOizvQVcv+6SAHlKUufhSLTCncGFAnKts6af6MBNP4FX+d0k+XoTrH6MgWzZ+WS7cr2WgYdfnLJ+ghB90Ovc6V4y5qPROcZnUkLbO4XUatATu753n2tpRI7vn/OW0S98Og65yTUWXwJ1XBKDSlciABiIdGtUg++5vumYuFZxLzKbie9PZixl7WszfSdFz+IkUAAfFjpr7V4yruldvmvHKK0tzAiySok1Lnx8zFKnGCdnIoFLK+w8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V94WOmX6yiMrJHHZsQhQX6mBNH1sJ9LoxkqvFNyDCXg=;
 b=ZdqHYrUsNxj4DeGmg6X35IT2L0m9+NDaNe/gwVJvGXjPARucgMa0Eg/8J+jiMLZU7LI4wNw4CviEfCwQhwnFE+jFSi0hrQGsDKcMmEa3+r4EsbkQSIsU/yh9W5o2ldweRF7mRKmxehVIzxBMAq7NVivoYt9dfnMtAmM4OtQVeCf8YsJuZC8RAZmZvl8WdkYNXj03kOiEFVrL8tqczM3Laa/dqSTVrV87YT4Cf20ETKv06DSYyuqjFgwpcmHnvHpR9aU7anBSenOXRlwlqNRw3XbXgB5omdbX9wjxZNlDX8o67N/y+cazFqPA5Re7SoHd7LzBiJi+HVMm/gzI0FF5VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V94WOmX6yiMrJHHZsQhQX6mBNH1sJ9LoxkqvFNyDCXg=;
 b=lgBiYjVJ3fTs36VmFz4tzbw6w+gYVKFkt9ddp+VUCPVLTI0pYQBbfo0aZtbTkCFf7yf4yLCTUcpG+rwGzw/yAwPZFN14tbpie/HYB0oe7EgXlPuJoF5oJrMAgeCsdjrRFs+rLT9xUBGM9QS7meS9ByrvCPvWUP1qkHz8C5Md0kM=
Received: from MN2PR02MB5727.namprd02.prod.outlook.com (20.179.85.153) by
 MN2PR02MB5998.namprd02.prod.outlook.com (20.179.99.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Thu, 9 Jan 2020 06:54:43 +0000
Received: from MN2PR02MB5727.namprd02.prod.outlook.com
 ([fe80::e09d:a160:5349:8ed0]) by MN2PR02MB5727.namprd02.prod.outlook.com
 ([fe80::e09d:a160:5349:8ed0%6]) with mapi id 15.20.2623.008; Thu, 9 Jan 2020
 06:54:43 +0000
From:   Naga Sureshkumar Relli <nagasure@xilinx.com>
To:     Naga Sureshkumar Relli <nagasure@xilinx.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [LINUX PATCH] ubifs: Fix wrong memory allocation
Thread-Topic: [LINUX PATCH] ubifs: Fix wrong memory allocation
Thread-Index: AQHVxrl5brpQ6ciucEyV8kg+Y3JOOafh5aqQ
Date:   Thu, 9 Jan 2020 06:54:43 +0000
Message-ID: <MN2PR02MB5727089A2B3BCF8FD49B9FF7AF390@MN2PR02MB5727.namprd02.prod.outlook.com>
References: <20200109065259.4772-1-naga.sureshkumar.relli@xilinx.com>
In-Reply-To: <20200109065259.4772-1-naga.sureshkumar.relli@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=nagasure@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9195b9c7-775b-4354-11d0-08d794d0ce81
x-ms-traffictypediagnostic: MN2PR02MB5998:|MN2PR02MB5998:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR02MB5998A5B090439610B8C130C3AF390@MN2PR02MB5998.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:378;
x-forefront-prvs: 02778BF158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(13464003)(189003)(199004)(6636002)(55016002)(9686003)(71200400001)(86362001)(478600001)(316002)(76116006)(6506007)(26005)(64756008)(66556008)(4326008)(66446008)(66476007)(7696005)(53546011)(6862004)(186003)(33656002)(52536014)(66946007)(2906002)(5660300002)(8676002)(81166006)(81156014)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB5998;H:MN2PR02MB5727.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QBAQtiC614CIdNLCpJ9j1N0cOGPa6Vis9NQZKgYX9gNKnA/CyWgY5/ZLSVlQjT4BEqFtpn/WyLyKoS184BiPY2RMYI60mc1nJsEFgumMFtGvIix9v99w6kagmMrj+kv+DUq7ypUBiyW+OuRrzv7SIy7JFhDLQM09GLboV/voT8T+aeX/lmns5biEkBKe4w+scv1q8GyY7OwL+WnuJa/FDPTjYgqB0q96Db4THgk0FNZMNqN73QogZ7esCeBBclvc50DDYJ22xSt3wfoj2FB+QHq48BopbVkZmA1T11CdRos71vHlUEJnDVke2o3ZJytN6Db2veiKpW26sDeFMJpma8XgNogur5KutUYGs8rc4lqF7jowO4ggklum8VpM/1q8UQIOYbbgOGGncfTNr3KrJi+90vNiostRHLtUIUIk8/810m0lT+h1d1gT4rQVBReCN2OHqKOhvvpAyy9BwWf7cyaASESFM6F0kEdj0pfMe47JQl0GX1gd+eIh1LiiYw+S
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9195b9c7-775b-4354-11d0-08d794d0ce81
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2020 06:54:43.3588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S8IOxpF3HbpT4pb9uSWgN3wFUmm/twq8HcCqXRXj65Rl1cQHsClTYArlXE6qW20YZq7n1BxRwz9Ba57DjPH4JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB5998
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please ignore this.

Thanks,
Naga Sureshkumar Relli

> -----Original Message-----
> From: Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>
> Sent: Thursday, January 9, 2020 12:23 PM
> To: Naga Sureshkumar Relli <nagasure@xilinx.com>
> Cc: stable@vger.kernel.org
> Subject: [LINUX PATCH] ubifs: Fix wrong memory allocation
>=20
> From: Sascha Hauer <s.hauer@pengutronix.de>
>=20
> In create_default_filesystem() when we allocate the idx node we must use =
the idx_node_size we
> calculated just one line before, not tmp, which contains completely other=
 data.
>=20
> Fixes: c4de6d7e4319 ("ubifs: Refactor create_default_filesystem()")
> Cc: stable@vger.kernel.org # v4.20+
> Reported-by: Naga Sureshkumar Relli <nagasure@xilinx.com>
> Tested-by: Naga Sureshkumar Relli <nagasure@xilinx.com>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  fs/ubifs/sb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c index a551eb3e9b89..6681c18e52=
b8 100644
> --- a/fs/ubifs/sb.c
> +++ b/fs/ubifs/sb.c
> @@ -161,7 +161,7 @@ static int create_default_filesystem(struct ubifs_inf=
o *c)
>  	sup =3D kzalloc(ALIGN(UBIFS_SB_NODE_SZ, c->min_io_size), GFP_KERNEL);
>  	mst =3D kzalloc(c->mst_node_alsz, GFP_KERNEL);
>  	idx_node_size =3D ubifs_idx_node_sz(c, 1);
> -	idx =3D kzalloc(ALIGN(tmp, c->min_io_size), GFP_KERNEL);
> +	idx =3D kzalloc(ALIGN(idx_node_size, c->min_io_size), GFP_KERNEL);
>  	ino =3D kzalloc(ALIGN(UBIFS_INO_NODE_SZ, c->min_io_size), GFP_KERNEL);
>  	cs =3D kzalloc(ALIGN(UBIFS_CS_NODE_SZ, c->min_io_size), GFP_KERNEL);
>=20
> --
> 2.17.1

