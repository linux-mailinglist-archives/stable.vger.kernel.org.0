Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14BE658EB1
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 17:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiL2QAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 11:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiL2QA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 11:00:29 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2070.outbound.protection.outlook.com [40.107.104.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545F6D52
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 08:00:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEtQdxDUXrVpjF52mT8wodAlPFUjGwTpj5mxGWIvKj7rS1TwoTL3HM/DpOOP0CZ4Mo+hC7G19+RWayQJIIldmSIundx6KnG71wvjyYVSLlc3t22FinrHCIjWptQowovkDocPfngBZjsv5Dpa0o+nxFcIl3KNtRB2Z3NdWzyFYUpfbZK3NMy6xdHDvKfSPHJvWzIju6h+VLcOtF9LNwHlbBBGua7nbnjFMF4txjyHvKzm3k2siJOmteLy3EuS9/XE/Qc8SpWixOWEV+8mg8SaKi1k4IfkuVbFtrup6vP+s8BEG2ORvgFmYt9lPJ2yfyOf69C9aFdZ/zmXu5mdmP5rAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cxA1dewoEQYsBBIfqqg+pBAzR2DlA1j9ZrcSXi2VvHA=;
 b=BaVIPt44SobX/DLfnGOK9nLTDbCm65Au9Ca0BggL81qsIJOrhM8OwJyMhKce/dZfiCbcmFNE2AZDhEqG3F6BiJjPzN+/8FwPoNQOcF8GhcYZCd3w4pJwBQsE36paQWx/mcoy4Eklr/GQfqrDyAS5UlJSNLl6xBjP0qwJMYagFYMKrbixOfJAznWtsi/pqOh7HJMeDl/5vUJDiIcbvbBdwZr1jl8ZNbcvN27bQ4ekfSzds4yLyVmgEvoZxxUFBQcUS9dTLjkHitej7vPLZT5ccZRNho8KMP7HHFeGr4XGpNytjYHtb6Z47js1T/G8f13KqA023hyeOrDdurAn2ojL0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxA1dewoEQYsBBIfqqg+pBAzR2DlA1j9ZrcSXi2VvHA=;
 b=wSW1gMg+JK3TBTAqOlNo700BVMK+N1td7rVP7ciMwRlEdjMCfX/rWvARc078W/hqB8cjBm2+JsmMIgJdep1Sg6khJQyEaIoN3jk0XemqgTYaNB4VNqiCe9mTKoLTEBpXLY9MAJqIVbiQVdNfSyRZIV/rpflkJmvOriTr7jXq8QuoOzlHwtX5fVnR2g2AvUdwvfB/JvfRAQM1VwnKTTMHPoDD0gwIj075xGeynTeQfZE2brzG5QNAHAmHdef9W+uRf06XHSSyFYGUEbXeTVJK0Loa/UVTEv5Kxg0uQTcHnRK6QD0Z81J0YosPVNWNumZqVaC4fjLPe9BUFwGXY2Gf6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PA4PR03MB7391.eurprd03.prod.outlook.com (2603:10a6:102:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 16:00:25 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 16:00:25 +0000
Message-ID: <c46e40a7-d110-0968-e331-987e77c565a5@seco.com>
Date:   Thu, 29 Dec 2022 11:00:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 5.15 152/731] powerpc: dts: t208x: Mark MAC1 and MAC2 as
 10G
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
References: <20221228144256.536395940@linuxfoundation.org>
 <20221228144300.959873542@linuxfoundation.org>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221228144300.959873542@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0433.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::18) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PA4PR03MB7391:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ff640f9-1021-4866-0656-08dae9b5cc3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0nHF3NcYTudgwEAMf0Uz6rOO3H1oMPITJYFvYP41Hrul2NeKDi5H8KIurNwixUosu/uOe1FUFriAZOlbk3fc+MHrcDGQ0ySvYxoi2+6MbcGATahfPFpCErUgIfDLDVbI+kB1pOfWE7geAyOOoyUZXxllxFV8AwaNhZvhQsMhCB9CHyNXkUtstyDOTpll6zlSqyTsUALo9A1qzIcXr2xSCJjeF8EHkGTLB0fp1s3XcI58znmA6ZZdE7phydZOw7EPTKGl0sFLLU0qiQCP3WX1SJvWwnksCkrUNzFg3Uz3s39K2pgMdzWeBPp0OvF4sn7BalRVYIZQXC4JWCL+4J7/aYjmH/hWoZeZTlpYknNQdTk+p/PTEV2Gm2g/mriK/i9jmsxvNCrjaAnUTbm8TP7rMtgbUaGszOMpp3nCQQqtJQ09lLUACzpEURKAQUV6yGPo5QnpKrOnn23l6UAVeM04bNpEFEPjlIH2px4VIiOd+kuJ2cpoW3PxfkCqMpGki0+okmyuYTobNml45DndYpX6BFvG+NA5h6tqcy0RpZ+SDzsQmSDRMnlSRpDh2HCCm8c0Owb8YM4VQaBa8HwQ005Af57iM1RjTyRECTANMz7CuA5DLW+P6ywqRWa3/3/ubZ7LW3Kv7WXseqD/1oQtYQzAJR6VASslabsdNAgcK0bmzNl6MaJafeaVRmRkZYZFlvvgHo3yWoD+AFiDWJBPJavyJBsMeu9apoXO+FsBSAemFRZ7Q7lab9JtfUCOWpylFPRkX5qxAqit9vsBtxVJYAvemJs/UnyUQyntpRz/3+sIRn4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39850400004)(376002)(346002)(451199015)(83380400001)(52116002)(966005)(2616005)(36756003)(6486002)(6512007)(478600001)(26005)(53546011)(6666004)(6506007)(86362001)(31696002)(38350700002)(5660300002)(31686004)(38100700002)(186003)(66946007)(8936002)(44832011)(2906002)(54906003)(316002)(4326008)(66556008)(8676002)(41300700001)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTRCbGo3dGJzMU5ycVhBK21tTjQwTEZUT2NxNFVmV2wzdnU3SzdzNmV1bU1q?=
 =?utf-8?B?ZFNsM3hjRTF6ODFuSXhNYTJlYkwwWjZ0SGhRdmJZT3IwZVBsd3dWQkwxOTll?=
 =?utf-8?B?QWtPdUR6V1lsb2VocGsveVVEOW5oNmdYYUVCZkpZZ1Fzc21sc1YxL0dSSEJm?=
 =?utf-8?B?VVo4TVdpSjhpaURJd3A1T09Wc1gvYnhIUzI4eklTa0dDbmUzeFZ4L3JPdUpv?=
 =?utf-8?B?aFZSYTdlbHFjeGsyaW5ya09PbEVGTHprbXRyVEJ4QjB1SUVWc3Vpck1WTGNT?=
 =?utf-8?B?WTVmWGtjS00rVHVRcUtMWHoxdGgrbWMrR2dORlk3bUUzczNldmN6UVBsaC8w?=
 =?utf-8?B?emgyaXFqWWY0ajZnRENkUUU3amRTSmp5RzlwczRVTk9QV0lIV2ZoL3VmaERN?=
 =?utf-8?B?aGZzVXA1NS9TMTE2N2swUDExOXFYa0MyTkR6b0d6Ri91cUU3N0dFSXNaMTkx?=
 =?utf-8?B?WVhZTWFobnE1RUUwbWpnaW9McC9KT0h4NnBwSEdhS1hoc04yaDdoR3JKamVP?=
 =?utf-8?B?SHVUQWY4VEFoNXV0VDhJTVZ2RW8zTjlGVkp3L1BXTnVubFlPeFZuMGNlRG8w?=
 =?utf-8?B?WDBaWUFneURCQ2tuOUgrR2pHSEYvVlpqUXk2RkFRUjI3YktDU0lEZlJRa3Mv?=
 =?utf-8?B?L1FwZnkrY1ZwVDRkSjZubHFjWjl6Q1JkOHRkQ3ltOFZBRXpWc2dKUFRBZW8v?=
 =?utf-8?B?Zm4xclV2RFZ6dHZGcHJ0Rm9XTWt4cE1kR2pEaitxWDZRVGZZVkxTUEVLalBX?=
 =?utf-8?B?N3FlU0lUK3VIeTFYbmxJNzVuVmthYnVRV08rSHdtR0lIK0hhMkJ2WTVUNFQr?=
 =?utf-8?B?QTV4L0JtWHl1cHUra3E0N3NWcENpU216b0dwMzlMaXFWQXlKMUtRODkwYVdn?=
 =?utf-8?B?cU45RWM2ak95S0VQMTBLNmIwNTljMDJGV3FGR2x3SHg5dktOMUM0a1lVTHZN?=
 =?utf-8?B?RGdXellpMVBpNFZvWUFTaEpWYTVrb1hzWDhsUWVyTWNyZ2RBcWlBNHh3NGNL?=
 =?utf-8?B?QXRHTlV0YVVqOHFWa0RINU5VSVora3hSNlB1WFNiRWw4OTdUR2pmbGkrMXVw?=
 =?utf-8?B?QXVjT2NwUHgybitZcTdxQVI3a0FFakFGNE5FaWRFdXRpOFlEWUV3S0tCNE9p?=
 =?utf-8?B?VkFRczBEL0ZiTURMOURNeVhCMFpGa0NUcGpXQVpWQ1RocEhWT00vOHV5c0VG?=
 =?utf-8?B?bVQzNU5QT1FzeHlGWUFadjZZV2JQZTIvVnpTdjBEdy9DTFBXREc1NjVOVDVt?=
 =?utf-8?B?ZkI2eTdqb3RRbWlsNnByb2d2MnVJZHIvSzhxclVPbU13Zk9ZdVNhak1raVF4?=
 =?utf-8?B?TEtnZzVCbEZ4OE8vK0FEbUtmT284N3Nvc0doemdpRVFiTVk1QTN0dXZKcklI?=
 =?utf-8?B?cDB5Qko3QnBXWiszRzNDM2FGY3lrYVhFNXZPTm9UR2VML1Z4TjZOYzhoR0Yv?=
 =?utf-8?B?ODBOL2NWOUtsdUtaMWhTS0FEZ0NIRkR2TjlMb20zMGFkTjBqMWZ3ZTVkZHR0?=
 =?utf-8?B?bEFnamtpUU9ZbFo4SmRNVjZhRno2WFVNcVNpTDMxOFJZOHVVdERjak03U2or?=
 =?utf-8?B?eFZoQTNlU0ppTnZoVHJPeG9raUlPTFBtY0ZsYkxKZGlseFFrZXYwZXN0ckpp?=
 =?utf-8?B?RWVZaU9HdUNiZU85cXFKWVllVWNMZ082OEZWcVdndUhTS3lTeDVnNUhVaU5r?=
 =?utf-8?B?SlJxWFVONHVuKzlwOXY1QUJ4Y0x4Z3VIU2puaG5NS2x0cUdBZSt1Z24rTC9C?=
 =?utf-8?B?Q0hTRVBmSllmRnhtNmUzbnlRSldCMlg3Z252cGRIM0NLdkZJRUZ0VGErYm9S?=
 =?utf-8?B?aWhwTkFOTHJYaHJ6Tlc2NVUzRUdXMUpiUVcwYXY5S3ZiY2NyaC9BeDJXSFRF?=
 =?utf-8?B?R2t3NkFYTFowOWxxZFRNeFAveEJvQUcrQ3JFUCs4bEFwN01Ib1BDcGNRVFYx?=
 =?utf-8?B?L1BmV2NTdlpDRnN6SmRCRVJISTArQVFOS3pQSkhWbzlsUjFrMWlVeFQwSEE4?=
 =?utf-8?B?U25zcmxGU015YUQ3MDBFenRjWm1rMkg3S0YzbTdWeVkxQnp5YXVCVGpuQ2VX?=
 =?utf-8?B?MG45dTFvLzNPdVI2TFlCSDUwRXhRWWE2TVJhMUhWZFJWVnFMU3JzcmRCeldx?=
 =?utf-8?B?VW84dlhZSUpTdk0vTjZBMTZnSXFCd0lkaEI0KzluNWY2Z041b2FKckl4bmJU?=
 =?utf-8?B?MFE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ff640f9-1021-4866-0656-08dae9b5cc3e
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 16:00:25.2877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +clcYhdYfuXaJbueenkJz8AHbJjQ8l01bZmcF/kLjLdj3yze2yBDVmcmyF9QAe5QMt6E6+4eYM8h3l0G9OTfBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7391
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 12/28/22 09:34, Greg Kroah-Hartman wrote:
> From: Sean Anderson <sean.anderson@seco.com>
> 
> [ Upstream commit 36926a7d70c2d462fca1ed85bfee000d17fd8662 ]
> 
> On the T208X SoCs, MAC1 and MAC2 support XGMII. Add some new MAC dtsi
> fragments, and mark the QMAN ports as 10G.
> 
> Fixes: da414bb923d9 ("powerpc/mpc85xx: Add FSL QorIQ DPAA FMan support to the SoC device tree(s)")
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This shouldn't be backported without [1].

That said, this fix isn't necessary for kernels which don't use phylink for this ethernet driver. 

--Sean

[1] https://lore.kernel.org/netdev/20221216172937.2960054-1-sean.anderson@seco.com/

> ---
>  .../boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     | 44 +++++++++++++++++++
>  .../boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     | 44 +++++++++++++++++++
>  arch/powerpc/boot/dts/fsl/t2081si-post.dtsi   |  4 +-
>  3 files changed, 90 insertions(+), 2 deletions(-)
>  create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>  create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
> 
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
> new file mode 100644
> index 000000000000..437dab3fc017
> --- /dev/null
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
> +/*
> + * QorIQ FMan v3 10g port #2 device tree stub [ controller @ offset 0x400000 ]
> + *
> + * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
> + * Copyright 2012 - 2015 Freescale Semiconductor Inc.
> + */
> +
> +fman@400000 {
> +	fman0_rx_0x08: port@88000 {
> +		cell-index = <0x8>;
> +		compatible = "fsl,fman-v3-port-rx";
> +		reg = <0x88000 0x1000>;
> +		fsl,fman-10g-port;
> +	};
> +
> +	fman0_tx_0x28: port@a8000 {
> +		cell-index = <0x28>;
> +		compatible = "fsl,fman-v3-port-tx";
> +		reg = <0xa8000 0x1000>;
> +		fsl,fman-10g-port;
> +	};
> +
> +	ethernet@e0000 {
> +		cell-index = <0>;
> +		compatible = "fsl,fman-memac";
> +		reg = <0xe0000 0x1000>;
> +		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
> +		ptp-timer = <&ptp_timer0>;
> +		pcsphy-handle = <&pcsphy0>;
> +	};
> +
> +	mdio@e1000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
> +		reg = <0xe1000 0x1000>;
> +		fsl,erratum-a011043; /* must ignore read errors */
> +
> +		pcsphy0: ethernet-phy@0 {
> +			reg = <0x0>;
> +		};
> +	};
> +};
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
> new file mode 100644
> index 000000000000..ad116b17850a
> --- /dev/null
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
> +/*
> + * QorIQ FMan v3 10g port #3 device tree stub [ controller @ offset 0x400000 ]
> + *
> + * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
> + * Copyright 2012 - 2015 Freescale Semiconductor Inc.
> + */
> +
> +fman@400000 {
> +	fman0_rx_0x09: port@89000 {
> +		cell-index = <0x9>;
> +		compatible = "fsl,fman-v3-port-rx";
> +		reg = <0x89000 0x1000>;
> +		fsl,fman-10g-port;
> +	};
> +
> +	fman0_tx_0x29: port@a9000 {
> +		cell-index = <0x29>;
> +		compatible = "fsl,fman-v3-port-tx";
> +		reg = <0xa9000 0x1000>;
> +		fsl,fman-10g-port;
> +	};
> +
> +	ethernet@e2000 {
> +		cell-index = <1>;
> +		compatible = "fsl,fman-memac";
> +		reg = <0xe2000 0x1000>;
> +		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
> +		ptp-timer = <&ptp_timer0>;
> +		pcsphy-handle = <&pcsphy1>;
> +	};
> +
> +	mdio@e3000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
> +		reg = <0xe3000 0x1000>;
> +		fsl,erratum-a011043; /* must ignore read errors */
> +
> +		pcsphy1: ethernet-phy@0 {
> +			reg = <0x0>;
> +		};
> +	};
> +};
> diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> index ecbb447920bc..74e17e134387 100644
> --- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> @@ -609,8 +609,8 @@ usb1: usb@211000 {
>  /include/ "qoriq-bman1.dtsi"
>  
>  /include/ "qoriq-fman3-0.dtsi"
> -/include/ "qoriq-fman3-0-1g-0.dtsi"
> -/include/ "qoriq-fman3-0-1g-1.dtsi"
> +/include/ "qoriq-fman3-0-10g-2.dtsi"
> +/include/ "qoriq-fman3-0-10g-3.dtsi"
>  /include/ "qoriq-fman3-0-1g-2.dtsi"
>  /include/ "qoriq-fman3-0-1g-3.dtsi"
>  /include/ "qoriq-fman3-0-1g-4.dtsi"

