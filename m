Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644534445A2
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 17:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbhKCQQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 12:16:52 -0400
Received: from mail-eopbgr20088.outbound.protection.outlook.com ([40.107.2.88]:5774
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232709AbhKCQQv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 12:16:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWTsyfdDuntUaK8HsDmjxCf/8fDcZyfNXQ4yNaIIcBe/1O4IsEFafW6c1ZTitQ1FZQf2dYNbIlbzvF+2a0HGTuqP11d/9FkNIf2Zn5Dv1juyWltf/6lxv790gHVGKPw6oSDkoh7U10N/SO89pL2JNwzO4HF133QtAhLeijtg7JKvHc2eSeYyLq6V0ZuTzx/q1wNOH5S1wBbcEs53xDfYpY3g6ElUGDRCMC5+fvUcVCb0nU2f8L0ESLgZ4zsE1mk5siW9ImxT/mqjWvjCDKFQpwoSsH1RzZnLtE0KXCjpyEYDCbHYKAeyyh50cuQRZPw4yfE2U+3Ff+ZjjsxuOKdkEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=smj0YdzkGW/Rgn9aYPiZqoFdbNr7ClzU78rSjGJprk0=;
 b=aeZDrVuLop3C9TrqA9d7w75kQkujMO825sUOdECySzxB7INDU2s/BSmaHEeF2DHN0plTy+ZchCmkGLZEhi4hns/fN3TpUAZSsj+OCt2nZo2iD8eC9UD0KpllgTGpT3Xz2BgOZv0+F5aufJnaHKjGDCSvr5yBTEjc6S18IEQbTavv59HBArYq3sd9B4PpUyHb/ArcDNMsxw06sdv+s5MOShLnA/N5+7BqCA4ozMWEeesoJeNolL2WMwbE1pzjRrCY6d7c2BozqIfNANACSnus24WNBhpgYjZ2hz4orIHoxTZmcjp7Abs9crAY1SRdgA7I6u/Kuq6F9vd/O78CrLCvjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smj0YdzkGW/Rgn9aYPiZqoFdbNr7ClzU78rSjGJprk0=;
 b=lA3bdbryDKMXlh9eWrzf8CIUtmfigfKkcZR/4VlBSMLPuQBXd07NLs2DeiXBzxotsj2KVH4EVqPgv3utJqqTaYOxcf8jbc7eWdDH1QVdqzqNAaoq8gWcx70cOWGQ+pfvrGliP5ErtUmB5M5i5x+FHzXsmrUkNUIcqe7fznJiZnk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DU2PR04MB8774.eurprd04.prod.outlook.com (2603:10a6:10:2e1::21)
 by DU0PR04MB9273.eurprd04.prod.outlook.com (2603:10a6:10:354::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Wed, 3 Nov
 2021 16:14:12 +0000
Received: from DU2PR04MB8774.eurprd04.prod.outlook.com
 ([fe80::f96e:198:8fae:c59]) by DU2PR04MB8774.eurprd04.prod.outlook.com
 ([fe80::f96e:198:8fae:c59%9]) with mapi id 15.20.4669.011; Wed, 3 Nov 2021
 16:14:12 +0000
Date:   Wed, 3 Nov 2021 11:14:06 -0500
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
Subject: Re: [PATCH 2/2] gpmi-nand: Add ERR007117 protection for
 nfc_apply_timings
Message-ID: <20211103161406.w4mk6rqhnajakstc@umbrella>
References: <20211102202022.15551-1-ceggers@arri.de>
 <20211102202022.15551-2-ceggers@arri.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102202022.15551-2-ceggers@arri.de>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: SA0PR11CA0119.namprd11.prod.outlook.com
 (2603:10b6:806:d1::34) To DU2PR04MB8774.eurprd04.prod.outlook.com
 (2603:10a6:10:2e1::21)
MIME-Version: 1.0
Received: from localhost (70.112.23.252) by SA0PR11CA0119.namprd11.prod.outlook.com (2603:10b6:806:d1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Wed, 3 Nov 2021 16:14:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d2a3be1-7922-4566-cace-08d99ee4f978
X-MS-TrafficTypeDiagnostic: DU0PR04MB9273:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <DU0PR04MB9273CE20B9F462C0686E708A978C9@DU0PR04MB9273.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iC6uW/vqcB5DLQx8zBtCocvx4FWcOi1wolnFb1/bWA66rgadfve3RTmHSBDDEPTFRhedTNcggnWt4C11uyYrmQpWVloQKzOahVa9AiVb/Yh1xSC43oSTEj2N/NDzUXboTPM4j3BBdDBX8OYqCus6X6kbR18sS5TpdMs18uEmhGB1KvvlUFKli7xQcbw0xPJuwzXGrGSGQ5g/7lXPTWbvZQs8NC9QMz49ZD7cc3Yh2Xzsir1yeU4Ctl66KTtDySwGYrUrlb/jv3EMa0LqQmILZ8d4lIAimCc3jKiEoZMcSqKV7BdWGWu9HjIYzG+Ylr75LrA/Z+6q7Pc0FMHZ8ukdtj+oHyNUoV5H3GW7D1/F0dg3nFdI7AywxZTNAoyLgMXtRP2zxLk6yM6bwTYhf4XM89ZiW3Hd9c8HZYjYkJ7mRqfgt0s/e/oTEzBIATGjkj88gzNb8nB5/iN1UUSzZQWImyPGas54l7r6EYrQ8t3kX/QcTCF9YRb/tkoz/1p1onxxmwNybLSHE7ZveHoUYbvRugI09koxatnb+z32sBSU5gSyp8hCpiNFxmd+n50jqBD9Y9Vh5kwBjQfKBrivSmbsenGYjMj+/UTbngTRbz1pJZroborDzEJg/3NDqsJbq0IPWxrkj4LGD6XCjwvLjeJ7MGjqvO64tiT3TFWTHJBxHGoHG0ycbFtc+H/A0TsYlKkF+3mWf9Sp+8kSCo8NRbJXpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8774.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(33716001)(86362001)(66556008)(8676002)(83380400001)(956004)(38350700002)(38100700002)(1076003)(186003)(44832011)(6496006)(2906002)(52116002)(66476007)(316002)(4326008)(66946007)(508600001)(7416002)(6666004)(5660300002)(26005)(9686003)(8936002)(6916009)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GBuU/KcLy+8XwAYCWXfzTw/885O3pF+8f4zX4Cl2+hFfd9sWgu1/NBGGvNfq?=
 =?us-ascii?Q?fa32a0XJ0BYTyq9GjddEqP6w03QRm4w7kEIzfbvQzx3kOH+SSEJZ3I3NrYzy?=
 =?us-ascii?Q?CITOMfLt56Y+oNNbwlUwUTUeVjm1azhrkl+7rv5HwXOXT/yRQyyONUVgiksr?=
 =?us-ascii?Q?9WYrYGocIKr59f2PBmoDwXNAIxQjkG4vi8kyXzMUxdR6B6Lhz1qquDhFyYL0?=
 =?us-ascii?Q?i0PULMz+jwMCl85gtIZVc+19IJ5Cedxf5ue5AjS8sIi1DFiwBPokxnA1I2Is?=
 =?us-ascii?Q?8pFWpgcs9Lk5r2YW2kXxPpLVdPzBEqyP5uxpKzVavuQnoMVBdUa0bJ+jCc2M?=
 =?us-ascii?Q?EZb9QyeS1dz44WiP/qpqBOBbm94owr9dbxdTlWRiAMyDSgUdErZ0pj1bpJQS?=
 =?us-ascii?Q?cIxndfmiAqCYKrZ/Gt4hE+k+0teRHP0R+YkIyRMqmNUCiHPvgdxrf+PMEriW?=
 =?us-ascii?Q?1X5Hqc/5Aoxqqlj/1d0HQidnEFbbffFRKGcKA8WH5DImV3bwUUexf3vgSZXy?=
 =?us-ascii?Q?80Y+nszct7IWneufu1MVh2yoPsZkEsrvirnV+6Blqgis/8gozs7TzYQWRZaK?=
 =?us-ascii?Q?CXsxO2jRFm8T4RFarEE7hvb16ZpVkxEFUqWhjPSR3EMhT+L/F/j7Fiqk3TCG?=
 =?us-ascii?Q?fb+7vKuji0f19rkuHCmncqEX6qglHbeIvcLEimZGUz5GyZr+9qiakXJZ1HcD?=
 =?us-ascii?Q?3FQiwz2XflXoCFscsK+sh9Wt7ftfGkZrW9EevU1nj2k2yPzuFSX5nq2KpvXO?=
 =?us-ascii?Q?99I4h4UqTD/crjywEMYDHqVJLBoPspDbG3tyCp2/t228fQIlXUL/OQ/BYx//?=
 =?us-ascii?Q?i4G6XagnwSmBr5jjDy7+RCZBVZw/98WbFLSLypT4AoEeQ85RkhShlklXLIoY?=
 =?us-ascii?Q?yKWt6Ayzz7w/P++wum7XJLfsRlXNfm9O1vV8O2tbYSaPwJXqZJw5nutArEIt?=
 =?us-ascii?Q?qwgdrIrMZ8Bd2jBJSz26oFvSEd0+w7dsIDEeo7iZafo9ygxlDf+feVEeMl4r?=
 =?us-ascii?Q?AyT2wqtHaMFzwh8gbtWo+VlqKkwpjLHMuR0hs5CgIuw136fTYUaj1yPlUdW2?=
 =?us-ascii?Q?3AjBiSTykPFORFWaSeYHeEfmKBeWpEwsYHMqdZyU5XJ+Vkk5T3H6l+unXp+M?=
 =?us-ascii?Q?Z+6QGK04cCGbCjzK/+U3svPv3KTTmhyoPgyXh8kNo7shH5eiYlOzeF2zu/t/?=
 =?us-ascii?Q?lZD7xmz+HJdrE+W+6od93r9ANb6+YPhNNe8vOkWWFkoF941GPzSv13pM107J?=
 =?us-ascii?Q?N2EUVGRRHUGX0k3DOAz5KhLgJYfQb6HK/tiw0xtJvXlouJJyw+nroAk3BV55?=
 =?us-ascii?Q?bTbbwdE5awh+tGyLJniSZ4anv0DGn6wjBlSMoeAEEfUdV/BSWbG7wa1siIQg?=
 =?us-ascii?Q?oLuXt0up9MbBQAgNWT90HJUCfGb6FkO4mOFHxov/pL8xwYJy9FY5g/JnMd0N?=
 =?us-ascii?Q?zGCR38hNsFhEPi3RUhe7TW+O4/IkTQuiGW5CM28echuvgcQM7YI62xc0YLJs?=
 =?us-ascii?Q?duaxPaS/SCPV/0hjN1CFtS5l5PGxvphPzcHJTmJaAb/pHXOVEKg0/pMMZTnN?=
 =?us-ascii?Q?ED7BQHwmpK0GBFZxnFI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d2a3be1-7922-4566-cace-08d99ee4f978
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8774.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 16:14:12.6085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MCAERhwvWE1a2FvgDZmIBQee3b7jeCXIY9mahUFelbFYZWNwh/Iwn6OZGroj0+Tp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9273
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/11/02 09:20PM, Christian Eggers wrote:
> gpmi_io clock needs to be gated off when changing the parent/dividers of
> enfc_clk_root (i.MX6Q/i.MX6UL) respectively qspi2_clk_root (i.MX6SX).
> Otherwise this rate change can lead to an unresponsive GPMI core which
> results in DMA timeouts and failed driver probe:
> 
> [    4.072318] gpmi-nand 112000.gpmi-nand: DMA timeout, last DMA
> ...
> [    4.370355] gpmi-nand 112000.gpmi-nand: Chip: 0, Error -110
> ...
> [    4.375988] gpmi-nand 112000.gpmi-nand: Chip: 0, Error -22
> [    4.381524] gpmi-nand 112000.gpmi-nand: Error in ECC-based read: -22
> [    4.387988] gpmi-nand 112000.gpmi-nand: Chip: 0, Error -22
> [    4.393535] gpmi-nand 112000.gpmi-nand: Chip: 0, Error -22
> ...
> 
> Other than stated in i.MX 6 erratum ERR007117, it should be sufficient
> to gate only gpmi_io because all other bch/nand clocks are derived from
> different clock roots.
> 
> The i.MX6 reference manuals state that changing clock muxers can cause
> glitches but are silent about changing dividers. But tests showed that
> these glitches can definitely happen on i.MX6ULL. For i.MX7D/8MM in turn,
> the manual guarantees that no glitches can happen when changing
> dividers.
> 
> Co-developed-by: Stefan Riedmueller <s.riedmueller@phytec.de>
> Signed-off-by: Stefan Riedmueller <s.riedmueller@phytec.de>
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org
> ---
> Changelog:
> -----------
> RFC --> v1
> - added comment about clock divider behavior on the different i.MX series
> - perform clock gating also on i.MX6SX
> - only gate gpmi_io clock. Other GPMI/BCH clocks are not affected when
>   ENFC_CLK_ROOT divides are changes
> - add error checking for clk_set_rate()
> - Cc: stable@vger.kernel.org
> 
>  drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 28 +++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> index a1f7000f033e..6e9f7d80ef8b 100644
> --- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> +++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> @@ -713,14 +713,32 @@ static void gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
>  			      (use_half_period ? BM_GPMI_CTRL1_HALF_PERIOD : 0);
>  }
>  
> -static void gpmi_nfc_apply_timings(struct gpmi_nand_data *this)
> +static int gpmi_nfc_apply_timings(struct gpmi_nand_data *this)
>  {
>  	struct gpmi_nfc_hardware_timing *hw = &this->hw;
>  	struct resources *r = &this->resources;
>  	void __iomem *gpmi_regs = r->gpmi_regs;
>  	unsigned int dll_wait_time_us;
> +	int ret;
> +
> +	/* Clock dividers do NOT guarantee a clean clock signal on its output
> +	 * during the change of the divide factor on i.MX6Q/UL/SX. On i.MX7/8,
> +	 * all clock dividers provide these guarantee.
> +	 */
> +	if (GPMI_IS_MX6Q(this) || GPMI_IS_MX6SX(this))
> +		clk_disable_unprepare(r->clock[0]);
> +
> +	ret = clk_set_rate(r->clock[0], hw->clk_rate);
> +	if (ret) {
> +		dev_err(this->dev, "cannot set clock rate to %lu Hz: %d\n", hw->clk_rate, ret);
> +		return ret;
> +	}
>  
> -	clk_set_rate(r->clock[0], hw->clk_rate);
> +	if (GPMI_IS_MX6Q(this) || GPMI_IS_MX6SX(this)) {
> +		ret = clk_prepare_enable(r->clock[0]);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	writel(hw->timing0, gpmi_regs + HW_GPMI_TIMING0);
>  	writel(hw->timing1, gpmi_regs + HW_GPMI_TIMING1);
> @@ -739,6 +757,8 @@ static void gpmi_nfc_apply_timings(struct gpmi_nand_data *this)
>  
>  	/* Wait for the DLL to settle. */
>  	udelay(dll_wait_time_us);
> +
> +	return 0;
>  }
>  
>  static int gpmi_setup_interface(struct nand_chip *chip, int chipnr,
> @@ -2271,7 +2291,9 @@ static int gpmi_nfc_exec_op(struct nand_chip *chip,
>  	 */
>  	if (this->hw.must_apply_timings) {
>  		this->hw.must_apply_timings = false;
> -		gpmi_nfc_apply_timings(this);
> +		ret = gpmi_nfc_apply_timings(this);
> +		if (ret)
> +			return ret;
>  	}
>  
>  	dev_dbg(this->dev, "%s: %d instructions\n", __func__, op->ninstrs);

Acked-by: Han Xu <han.xu@nxp.com>

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
