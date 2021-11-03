Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D7944459B
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 17:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhKCQP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 12:15:59 -0400
Received: from mail-eopbgr20061.outbound.protection.outlook.com ([40.107.2.61]:7229
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231586AbhKCQP6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 12:15:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwNlulj1JOFZn9lXWTuUFXh9FuPKSpJVvmqaJRnsCTlmGXcqsJntmw3AokYs2dSuOTRIMBkyOpeXiswFvw6WBB9CGqLy7k35mlHvAJ0ozGL3giaziQcQBYtBwMlFUA7ifApU49f8RNzzS3gutzdtKpO0TU+r7KhF3aDJADmkz2Uinbw+yPJFMfHrdcTNwC/f7bg4fTmcLkh4gNFNJD2e4Z50hTXoQqke9HHbVt0tz9krBwtmQaf9C73GGDCj4aO9BNnfi63Hs7LVe9i6+V+snbGV16Yiu5KdwuYnTLDwcToue+jufmbV//+QinIoXZTynMm7hgm2CgNMo6UMkrSw+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LYAv+MPAXIkvEvBpFkpxu3Rga+Nqj7/37uRV+kx0+B4=;
 b=ZQQXvYQBVjmZurX1IjufVpCGV604A2wTbrvZW9BFYV+097Mdlin+/uyVeoEvsBJVmBTxHzURDlu0Krkj5VLeqKtJXKFHLWJodDhwT9R3zfK+2/3nK/BChQyMiPwM7WPZuZkZuFB8n5hVKRWARBbubWI2um3Ghesixk4vkBHMOw9Wr4hTQmai9sRvO5pRZMU8VgBEWEGRVXkAh2ER+A/3g17p5S9s8NXibLQdvCobVYriw+Nvabae1whFGmOE5WYei78tMn6ri7Pn3B1PkddWMDc0rnQS7WPSENisiCv7sxvlYKDuOQIWKWJC4ucFCi+iLZRuhkiyQRLaOh/vOIfXyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LYAv+MPAXIkvEvBpFkpxu3Rga+Nqj7/37uRV+kx0+B4=;
 b=RDGxzqEhOsCgZAiaJEPS3mgN4NQ75k+SqY9hHXzvo7trVd8H5CaJ/8dcyNWI2Z9qrnKx4emWSmijXu9tYkRBlrzKtpzSg4vxOHv+sEimu2mbIoR/ha4EmtoJ6PY1FY4z3Vhz0Xz67N47SkQFMl2ar3qw2YINKUlvVO9upvXw7eo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DU2PR04MB8774.eurprd04.prod.outlook.com (2603:10a6:10:2e1::21)
 by DU0PR04MB9273.eurprd04.prod.outlook.com (2603:10a6:10:354::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Wed, 3 Nov
 2021 16:13:19 +0000
Received: from DU2PR04MB8774.eurprd04.prod.outlook.com
 ([fe80::f96e:198:8fae:c59]) by DU2PR04MB8774.eurprd04.prod.outlook.com
 ([fe80::f96e:198:8fae:c59%9]) with mapi id 15.20.4669.011; Wed, 3 Nov 2021
 16:13:18 +0000
Date:   Wed, 3 Nov 2021 11:13:08 -0500
From:   Han Xu <han.xu@nxp.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Michael Trimarchi <michael@amarulasolutions.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Stefan Riedmueller <S.Riedmueller@phytec.de>,
        Greg Ungerer <gerg@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Christian Hemp <C.Hemp@phytec.de>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mtd: rawnand: gpmi: Remove explicit default gpmi
 clock setting for i.MX6
Message-ID: <20211103161308.n5vxrllgil3ntpxs@umbrella>
References: <20211102202022.15551-1-ceggers@arri.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102202022.15551-1-ceggers@arri.de>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: SN4PR0501CA0021.namprd05.prod.outlook.com
 (2603:10b6:803:40::34) To DU2PR04MB8774.eurprd04.prod.outlook.com
 (2603:10a6:10:2e1::21)
MIME-Version: 1.0
Received: from localhost (70.112.23.252) by SN4PR0501CA0021.namprd05.prod.outlook.com (2603:10b6:803:40::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Wed, 3 Nov 2021 16:13:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0972bc5d-5367-4484-7189-08d99ee4d957
X-MS-TrafficTypeDiagnostic: DU0PR04MB9273:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <DU0PR04MB92734C8E23053B7774DA7FE1978C9@DU0PR04MB9273.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:240;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T0/SbqP7v5UGIQMHMzSMLtWS6PHtD3uII/sQQh8s+we91PEeES4Sny0NpnkAgd3Mw69wdtAV6X0gsNxfBXMaFT7Y1Cy9PDEHIVAW/uM6TM/cEdtY1pJ0Sbxbg4Er27xgk2lAAfHhNHM4EBoJ/BVp1KBtwavJls9HDF8idCXdZyHdO9Brjxhx/LSClM3gEwqJ/Hgpx7UuOaP/RRa3uKJ7FNWUO/jR/koUkS3icUXxOxkJ5DK603CA8o1u3YEMUEO3kAghiYbdsTJZHkk23pbrs504Z74Sjr+SdtGxJJXUk02doouYUHKuauQT4cZxwuIL6oWqEi40y5VkgxBfUfROreZs0Sre2dLvZzM6Ekm6uMqm50c5qCrtAnGlWCqq470f70yHB42yn7qzhL6ZTEqH4y1kuLHrxb836GwsHwK1cyiBP9XL2d8rBZ6l1G7pv6dtY5xnXKOmQ6SJXi2aeSbvYabPGj3upMGmtmfV3N6X8lypsCtWQyv+Dne4Rzv1g5CyA2p0jFXW6RsHN4o3CORBDKrzpobgCUuCC/0yjORhnWJ6a+2b3Z6C1/ZT2XFDubdYBqWyAg4ThrtQiWdhxzJLRIDllTexxm4ZndIBr9yeXH4qfAVBKRdrTjdwQQ9H01gCk+ne5X6fd3RqEuF70P/UUNDYH58k4xf7xTFnRjqoNLNZDZ8dAPiY45r99sNQt6wwv794sgS0F2E6AqgBuwwV6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8774.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(33716001)(86362001)(66556008)(8676002)(83380400001)(956004)(38350700002)(38100700002)(1076003)(186003)(44832011)(6496006)(2906002)(52116002)(66476007)(316002)(4326008)(66946007)(508600001)(7416002)(6666004)(5660300002)(26005)(9686003)(8936002)(6916009)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z8nysXbA5W+341JYyh3JXXD4jNnqr3+t6tBGRV85k7MMGinpI4Bf0krQFw0Z?=
 =?us-ascii?Q?GGpr/NHltR/ARrjY9eceUn8HRadM/BfmmmHjFwJTMlIo2l2Yy/6BqJMj3LH3?=
 =?us-ascii?Q?kZn39pdHcqXcPkItAA1/+Yw8/2EknpVgMGqBv8Ft67kc2T6YBkdxHdbloPiT?=
 =?us-ascii?Q?wHBvSYXR6BZjEKQEOwBpDCJK+C+n9tmjn7rrB0F6sO9stuMxE9sIVoRVgzac?=
 =?us-ascii?Q?E8eG5BUOnSGzycrgbru2RZGSZ6tI2mFX+mFcAg7cFNomQ3akFXWJVs2FeO3f?=
 =?us-ascii?Q?8A8CfkdXutmRCqoTh5zoh8eHrKmro862v/dLBFomCFIV56BRUT7vDC0vNb2e?=
 =?us-ascii?Q?Ld5Mp2IQkhcl+uZSpLzbFzKlF4qOVHegK7kArkwo8QOFGJc1gwCIszYFSXIq?=
 =?us-ascii?Q?CZ1ckfzhdm+SH99LseAaGIAh9YokOKxGZRBI7x77rHB+PSINbgONJJpH3bIr?=
 =?us-ascii?Q?WEE2S1pj8BLuT7qQc9EDCyyno9/RETaxsD7rZ9WD0RE8UKjx0FNe4bnV3cK1?=
 =?us-ascii?Q?HM63DlfDj9h2NZhcrhIm+iWYFYmfwuDrDKrbZ82vaxxzzWnMZsvpl3B3MEa8?=
 =?us-ascii?Q?8uHNL++7VcxEMpYYD9+2oC7f+l8S8W58SDq2sivxH25Y4aqrwnFpbL/Ga/hD?=
 =?us-ascii?Q?xjjT+IyZP7KW0Z+7DKNkNX17TNJMwcTWzeoMs4EYz4jYhpnI88NxvuFlcFxI?=
 =?us-ascii?Q?6jtCVXAgqzWOlJfeFWqbHs6MGF9k2n7YH+B7bmjXhmz+J4851jpMecFVrAvv?=
 =?us-ascii?Q?dAWCdiyRKxwRGcwn5HCZRweUdDINN9jHmk7HtnZkiTBrQI7E9NBkTXvJkHku?=
 =?us-ascii?Q?i5IqxBYxpq7jmAv5H9CSTXHG4V7SApynYALM3niQUC4zqEL2x6Vd8nEPNDte?=
 =?us-ascii?Q?5CO7+wTrmGp4nfD9UxbBaYLoWN6bssalQ5dmqn394lOmwqHdHtLFrPKtaXYu?=
 =?us-ascii?Q?qy8p2fCZWBTUPWypN5KAcfCwiRhXv0g/JulnTQVWh/htM60IIDQ/WW5xNyVk?=
 =?us-ascii?Q?tblOxPMc9J1stUJPYX199xhDR/h9asqQuF5JEja20c14gnKZxIvkeM8bxB4R?=
 =?us-ascii?Q?olzZkr6ZmTtSq9Ds4FUCba/lc/D1p3Trq0B/bnQzrti0hzEXRpSkmmH3rhGB?=
 =?us-ascii?Q?aqUFgk3FZ591F+nfQg4Hzqj1EvM9XlPWbiOyVk6MhdvMZS+MBjH9JdfpUka5?=
 =?us-ascii?Q?Z/KkPdJr4kXB+i4wQr5nbudo3NHNr/iKnwCeUhU4UpfdphvoM+Z7mc1itnrD?=
 =?us-ascii?Q?UNjNCKDdsCpWTF/0p5dYictWKVXGLGh7M5inPbFzScswNx07rK3V1hqw6HJu?=
 =?us-ascii?Q?WMtJIv8pk8/TcnvyySljrXU+nv4T9V/QYv29vxCCducgtDT1QlVAiPyYzVN0?=
 =?us-ascii?Q?WRE4kPAPxc3++ugOSvIzTeCjL69fZSEsNXGVx9b3WGvd5Rd4yKpheJt8M/BZ?=
 =?us-ascii?Q?uNkVy31eNDAuXMgxnhTegJh1cXW6LPbiuvzX3OnMzAQTlmgIFpLmrUtYGEHI?=
 =?us-ascii?Q?F/fYWcF3W0sXl8nAecI0EPTjCob9vbLF82zzWoycR80yE+Q/J7rP/afXruKm?=
 =?us-ascii?Q?zUT65i6kbw7+btHEqMU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0972bc5d-5367-4484-7189-08d99ee4d957
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8774.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 16:13:18.8641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QQwR5ulbS52UyTrGUCMyldOGB9oPcJWtMrmEDRxp8IV3o+HN0GLXQcEuM83hu21O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9273
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/11/02 09:20PM, Christian Eggers wrote:
> From: Stefan Riedmueller <s.riedmueller@phytec.de>
> 
> There is no need to explicitly set the default gpmi clock rate during
> boot for the i.MX 6 since this is done during nand_detect anyway.
> 
> Signed-off-by: Stefan Riedmueller <s.riedmueller@phytec.de>
> Cc: stable@vger.kernel.org
> ---
> @stable: This patch fixes a bug because this (superfluous) call to
>          clk_set_rate() misses the required clock gating. The resulting
>          clock glitches can prevent the system from booting.
> 
> Changelog:
> -----------
> RFC --> v1
> - Cc: stable@vger.kernel.org
> 
>  drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> index 4d08e4ab5c1b..a1f7000f033e 100644
> --- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> +++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> @@ -1034,15 +1034,6 @@ static int gpmi_get_clks(struct gpmi_nand_data *this)
>  		r->clock[i] = clk;
>  	}
>  
> -	if (GPMI_IS_MX6(this))
> -		/*
> -		 * Set the default value for the gpmi clock.
> -		 *
> -		 * If you want to use the ONFI nand which is in the
> -		 * Synchronous Mode, you should change the clock as you need.
> -		 */
> -		clk_set_rate(r->clock[0], 22000000);
> -

Acked-by: Han Xu <han.xu@nxp.com>

>  	return 0;
>  
>  err_clock:
> -- 
> Christian Eggers
> Embedded software developer
> 
> Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
> Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
> Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
> Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
> Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler
> 
