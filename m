Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658903CD258
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 12:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhGSJ66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 05:58:58 -0400
Received: from mail-eopbgr40066.outbound.protection.outlook.com ([40.107.4.66]:13799
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235272AbhGSJ64 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 05:58:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ablQCz5L0k+71DB6f3OaEgsBr2alF/g8k3IiGugLz9pgxnDa61nmQcAljXYF5oO+afiMSuPFGhvNCuPWm44iGUNtaRglLk9+NWMqQwls3RRVIesNbl7K+SUAclEWlc6EVkE3ZjEHbYCRy+5EaMMVvGn462JpdCussDQZjpx63gQ/jjka8SrdzK7ZZ3A94IOY0rlkid+oPsQDJWwb74srNPayfODyOMHGiwy/EA0J9jjseFS/s/O//hOp2tLTveNn9pL3rR+Yb6F/LOeb7ldbex2rORop7aGWrwW8GBvn+lGTM3JZjFScnLHmcVL+i7p12732JW/WbEl9mon/Hl+jrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ze02yv8aVb/tfWDV99b6CyQHy9i5xduN3Lsm0rxeFKs=;
 b=HrLrNetdsDdRMbqQLAMeCcSqZ6hqgBfyXZ0izXPpvdiH0GMBGQ7RzAIJh9ZCz2JXw+supBNBk86N+mjhCeOAWyLvW2uEC7NVklb5zCXHasymimPMCV8lr3QBxCMwAsmuj5J5LxvVfWj5RtLzdhFrgG3pScxsaDet6ok+Lg1mW0qM1+x1EsTJ6TVgklkrzmMEFfTi3rgD2MrOERIgoIh7YrruPeGhlz7XiRAE8R31gv1e72Yspu8VWvwhC0LqVUoOGblb47Kf39oTMmNrCbOMk/KqWmdJqrWFWsSG8+R7c1uBbYs9YpyjYdap7WGadXZlUWILAMB7oJXYfp4Pd6qskw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ze02yv8aVb/tfWDV99b6CyQHy9i5xduN3Lsm0rxeFKs=;
 b=Uje1Wu6cjouwUwC/lo4JGv9Pm1zm6UFy+o1fEnxqmx+0a/VOGADICg1j5EnbvXMn6s5yuZKg9usLHrLg3e6C4qZecCnBbknDNTZXCoUxVKJlK/L7wMV2l2lxEFKOYMQw3WyPlch+Uf/HRgMc+5U+mynifsge8BWwJtAORZNXkK0=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0401MB2559.eurprd04.prod.outlook.com (2603:10a6:800:57::8)
 by VI1PR04MB4270.eurprd04.prod.outlook.com (2603:10a6:803:3e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 10:39:32 +0000
Received: from VI1PR0401MB2559.eurprd04.prod.outlook.com
 ([fe80::1dc0:b737:bf34:46b]) by VI1PR0401MB2559.eurprd04.prod.outlook.com
 ([fe80::1dc0:b737:bf34:46b%3]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 10:39:32 +0000
Date:   Mon, 19 Jul 2021 13:39:31 +0300
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Dong Aisheng <aisheng.dong@nxp.com>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sboyd@kernel.org, dongas86@gmail.com, shawnguo@kernel.org,
        kernel@pengutronix.de, aford173@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] clk: imx6q: fix uart earlycon unwork
Message-ID: <YPVWY4h+nSP6IGZc@ryzen>
References: <20210702085438.1988087-1-aisheng.dong@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702085438.1988087-1-aisheng.dong@nxp.com>
X-ClientProxiedBy: VI1PR0902CA0055.eurprd09.prod.outlook.com
 (2603:10a6:802:1::44) To VI1PR0401MB2559.eurprd04.prod.outlook.com
 (2603:10a6:800:57::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ryzen (188.26.184.129) by VI1PR0902CA0055.eurprd09.prod.outlook.com (2603:10a6:802:1::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 10:39:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cd6d906-f25d-49ac-aeb6-08d94aa17ec6
X-MS-TrafficTypeDiagnostic: VI1PR04MB4270:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4270BC5F4BA99C825F19ABC9F6E19@VI1PR04MB4270.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:370;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b/MgZHCHTr6RCJXgfZNF2To9gFBplRgNdy6AZPfdjKB9wRbMwc4bnoqK8RS3OTdK/Uwpngg7Mgp2fiEFhhXzrAHp28RzVA+oy6Cwes7UvJFdkwx+BxfrNAZs+NnWRBF5+pfPbvsPDxTgg6cR1+lAJTs3U7vi9FaUdIn3gFHza7hq+sF+zjywS7Va9kzOVhPccnVWG1cVXrHp8a1pWbsofaMm58TUhwfbIYlfYZYynmxNXas8a7gx6HajHXsIFzeAxyLyrsjuadyZr7SYyFrKyyUELSOhmsrJGOPZ1kFQ4r/zOXwbiKbhlDmYhK9/T9caOgnUO887qG8qrSGoFc5MmFKS6cjztxo/UJ1+R5yxyYMJba/NlGI+ULySqBNclODaSGuVztEEp54SGnlLjWK3m6s62p6VqkmKZaUTvQ7WlODkpsYHja/AhTI+ux2ZE3z9Ac6o9o+DqXEa5oe7vjRDzyrmPcWjmDxfzDffxEaAqjmgtMuoi/3HL/9ZJOrUDJeK1FozlYiKm3phmu61ECPA4dgd746DznTkHN5C9l2Be71mxboLII2x/5Lrn67sXEKSAE5gcN7vT6Usiaap31kFFeuUPI3rATIGHeJIPbhdqawq+cVw97hxGNohrH5JUQdCVPPIUO+CrHku6+uQUarYiwggz/Yr0T0J6prPXE19bEVFGqobI7MCujaVHOi/9oi6h36yfrC9XrA8ELBWOlC5CFiKcOn2uiP9+ucNxwXbLgNQTbwi2qwCXlxbVal/by1J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2559.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(83380400001)(53546011)(4326008)(8676002)(33716001)(9686003)(44832011)(6496006)(55016002)(186003)(956004)(26005)(316002)(66556008)(86362001)(8936002)(66476007)(478600001)(9576002)(38350700002)(66946007)(38100700002)(110136005)(52116002)(5660300002)(2906002)(32563001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xbdgRjO7VhjI0r9ljRzRWs8soqQp3ktth/j3ahyqWU2Hm8T0wDDufqQI5E6F?=
 =?us-ascii?Q?E9c+zxCgtqVsw7cWMKWN6xCrq0BqqekGl4WBso+KQgEptlZyqt9aGqWSNoZW?=
 =?us-ascii?Q?jsKz8LElukEN0YIMFxgBsmJI7zPbmf/eMUsLivNyAZssdmyYs2ORbsXJPvFC?=
 =?us-ascii?Q?IBst6DRZFBIVzfNy5wTCyafOmqk17cO1fj48pE4jFuxI2KReL4l3DZTnYXQY?=
 =?us-ascii?Q?MyxMXZwojL1hIbDck1rh5bbJRV5diHf5vP21eWtbuf6VtbcU5d81vE7TwKD2?=
 =?us-ascii?Q?9lfk/lJ1sDiBZXoJP/tMPfdnccVADyKwVTSfp9RbYCKOKr1wexmfsM0Ol17D?=
 =?us-ascii?Q?Me3D+VmfSzxkK9SrmPcHh2PBQx1G7M6efyKRxJg6le101j+Ue9ry7YP/J5Hs?=
 =?us-ascii?Q?lwF7jpkddaWgGjQVq/CxPytxT6O/3QbrCXm8JO0la1wZ7OxEemA8j2IMgIVO?=
 =?us-ascii?Q?yvXBqZ2hsGnDBZiu1A88/BQKrvWJIwLHcBDopYuD0uDxDS+5AZbgdTENaTD3?=
 =?us-ascii?Q?+5Grjrxd+qvq6nXEgaqFnUXM/Ig+fSPAWwk4gYvR/21KEWiJpHpXSKaZAAZW?=
 =?us-ascii?Q?RNcrNJ4MiqCHMTH4e1X6TsJBHMGuYDLN1tCB60QTzk7M/56MboRhVSbMLYIS?=
 =?us-ascii?Q?PHWPvQNU92Lv4Jx4+XVj6OSsQGAcPYNMmA6Op89eT0whfK7/FtWd6QioGRg4?=
 =?us-ascii?Q?3Ng3xnZyYsC+v7+mEUyU8P/SHnASP9SELmi4RM+Fkan+gSjo7yEGqwxOoifU?=
 =?us-ascii?Q?PM1ZOPCgsjexQucsj+9UZN0IliRoTUif1mhHyMmRRYo9iPLdo4Ky+6bC0qy6?=
 =?us-ascii?Q?cKofoW4I1SmLlZuyOQjoK9ix3OwnyI4y5tebMA9WQCIWiTH6fwa0HTlo1FK5?=
 =?us-ascii?Q?zoCcmRGOhk5JPlTa3hkwdpsrv7MFuosMDF5iYBhKZvKBH+aBzmAznVSSfs2u?=
 =?us-ascii?Q?kactN5mIhh+gyiTt96S0jRfM3rlacVQgk1IIRzLOv1V9KVGbC3ve08Sy6XDJ?=
 =?us-ascii?Q?gQDL77+haroqjmdx7ZaW52xjtmNf+/lVeWLg1ZqeI2he8FNtwKnctG1Dl3Q+?=
 =?us-ascii?Q?DpfiRoLhtElI7ITYsWPi5y3H6tbQZiDswvsexf8tw94iV+x5G/F/7yoEFuvN?=
 =?us-ascii?Q?HpI2TDWvmCWs30TpeWic4irXpUSCkEyCE6wqnOzj3LDCYQEHHMqxAs3zgg0X?=
 =?us-ascii?Q?n5YxzNt7+MgguD7kj5YxNA0GFjwiyA/PkZLJcRGxtGYtmil+eOOwKieC7QjO?=
 =?us-ascii?Q?1OQeRfb7ed9MKLhtMUUsTy92wAegtliXU6YwOQcdVm5t8D6tQnGvMYAZh7Vx?=
 =?us-ascii?Q?0pLqc598CM6MhOQLQo4zPshJ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd6d906-f25d-49ac-aeb6-08d94aa17ec6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2559.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 10:39:32.8055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UPcS0TP2gH0OWEcpb9BHXlqL2uKbKlwJezp8tRT8JrfqRsA6oj8VC7V4TeOCqFUR8QF3uA6IDyzZW2l4LrhHkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4270
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-07-02 16:54:38, Dong Aisheng wrote:
> The earlycon depends on the bootloader setup UART clocks being retained.
> There're actually two uart clocks (ipg, per) on MX6QDL,
> but the 'Fixes' commit change to register only one which means
> another clock may be disabled during booting phase
> and result in the earlycon unwork.
> 
> Cc: stable@vger.kernel.org # v5.10+
> Fixes: 379c9a24cc23 ("clk: imx: Fix reparenting of UARTs not associated with stdout")
> Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>


Reviewed-by: Abel Vesa <abel.vesa@nxp.com>

Stephen, will you pick this up ?

> ---
>  drivers/clk/imx/clk-imx6q.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/imx/clk-imx6q.c b/drivers/clk/imx/clk-imx6q.c
> index 496900de0b0b..de36f58d551c 100644
> --- a/drivers/clk/imx/clk-imx6q.c
> +++ b/drivers/clk/imx/clk-imx6q.c
> @@ -974,6 +974,6 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  			       hws[IMX6QDL_CLK_PLL3_USB_OTG]->clk);
>  	}
>  
> -	imx_register_uart_clocks(1);
> +	imx_register_uart_clocks(2);
>  }
>  CLK_OF_DECLARE(imx6q, "fsl,imx6q-ccm", imx6q_clocks_init);
> -- 
> 2.25.1
> 
