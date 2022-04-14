Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C478C500DB2
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 14:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238384AbiDNMie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 08:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243680AbiDNMib (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 08:38:31 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B958F9A2;
        Thu, 14 Apr 2022 05:36:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mP1L8m6KoJQ5dReX64tBDEPI3x9HkPGFbult+jYXKrBHEN5w2lPwBny9VVR5hTNqMfGat/Q3YbIJk2oX0EUf/1zasZ1A5wUbXM2lXpheZ4TVvZQrDcwhcgl4mh9AhPzuuVnPgK3WTyy5rS99LvQWflxkRu1eanLsE/vXm4wAAVFCF9kFbBhr+PGOLHqKihIz4P8Bm6PKiZRs6HPaBJk1n9hulYRa498MShRGzXsqF01Pu4DplFPzrs9twfpHl823SpOetC0v/inhdhO2RB6sLCoif4Gxg4q6nVmPxUGmSzwX26+qE6s0coHxABZDBL7WUEv1FeSnZdnfKafxLM613g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnv2HOG9rKDYTjjEfYXcJL7sa/vSK5jyjbgi9a3PaVI=;
 b=ek/ZLUN6o54NahXwfhMv8P6uL+NHNyBDFa5V5OLvYXvgNcEUZB/uFp6qqDUuXlORnmlzG9n1DxjYv/0lcgwGG/wm5A1yJ5a7SazuF9aFSt1kLviEuv9TpdTCWPm2wZhwki2DM8M3bUNZpLjOSfuFeSIJyfapjWXahSq0CKfqqQtpQyayd67WUpfDSEZVyCEfoODJue7NhW9enIc13kZvJunCRZgrHfdFHc72ASgsviawyZ7wnPiKmPBnz5jHso/nGNrXDc0b6CigQp7RrLv1BWYRU3iIT3pGd1OOa1Li5SWBwT+e/yEH7d4lyp8z4A5yZ4XwLvk3jXOLpEqAc5GGow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnv2HOG9rKDYTjjEfYXcJL7sa/vSK5jyjbgi9a3PaVI=;
 b=Q6H5yU++yhx0fV1PhwWKo/wcJmVzmHEihUOlEgWZRjszHa+3cRICzzYqJEXVD8oCmcmxQflTW+F/vvD0NGScSG298VdKUJnON0GQ3vjMfLhHajrLn+8iEp6J7foq+0m3AadOmSVyxUZIJi4N4OGJk3XEmKu29JeWUmslL5rYp24=
Received: from DS7PR03CA0248.namprd03.prod.outlook.com (2603:10b6:5:3b3::13)
 by BN0PR02MB7872.namprd02.prod.outlook.com (2603:10b6:408:14b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 12:36:04 +0000
Received: from DM3NAM02FT061.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::9b) by DS7PR03CA0248.outlook.office365.com
 (2603:10b6:5:3b3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Thu, 14 Apr 2022 12:36:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT061.mail.protection.outlook.com (10.13.4.230) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Thu, 14 Apr 2022 12:36:04 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 14 Apr 2022 05:36:03 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 14 Apr 2022 05:36:03 -0700
Envelope-to: linux-edac@vger.kernel.org,
 bp@alien8.de,
 mchehab@kernel.org,
 tony.luck@intel.com,
 stable@vger.kernel.org
Received: from [10.254.241.50] (port=40216)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1neyhe-0008TZ-Sw; Thu, 14 Apr 2022 05:36:03 -0700
Message-ID: <1cf1b21f-6fbb-6f2c-3a54-862a18f6a771@xilinx.com>
Date:   Thu, 14 Apr 2022 14:36:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3] edac: synopsys: Fix the issue in reporting of the
 error count
Content-Language: en-US
To:     Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        <linux-edac@vger.kernel.org>
CC:     <michal.simek@xilinx.com>, <bp@alien8.de>, <mchehab@kernel.org>,
        <tony.luck@intel.com>, <stable@vger.kernel.org>
References: <20220414102813.4468-1-shubhrajyoti.datta@xilinx.com>
From:   Michal Simek <michal.simek@xilinx.com>
In-Reply-To: <20220414102813.4468-1-shubhrajyoti.datta@xilinx.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a3803af-f5dd-45fb-b2ad-08da1e13574a
X-MS-TrafficTypeDiagnostic: BN0PR02MB7872:EE_
X-Microsoft-Antispam-PRVS: <BN0PR02MB7872BA6FC55B6005EF730163C6EF9@BN0PR02MB7872.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W6NafAaUyff/Uh3GoqA/9pOguEciTexza81r2GKjvOpfbSSDzTI5JBhmuCs89A1gTimJEralmfoXiQJlguWFfpSg3MrbZrKIAMF1qp74o2MBr0kKwtOB6WYJuA4HGGbw5KFutZvucI0Lp9VTpEyJ4TqswR18ili6mpyuoj5rTg6dBBKHSFXRBg0e2DrdjYLCknlDPFM3y+ZtFiaIB13r5NUeebICwXf8ZEOBR5sqOQkIlpkxypyqO29MlzNi5xr5H0UE0cEzaqPO9AxKeZVA/hhIea+aVdBlLY4XwwzLkCW9l3cfq5pVjqYAKYFeR/zdGppbwrrW41EJRnevwuFqIM3dMviXEeTJyYw+mkgIblbLec2UkK75WHNz00TJKVxeCfzXsW+tjnBd7WRyA2PjF9fztEOcYZzfU4b7ItB71eZQzLUwEeK3o81NsqN+Hbg8KOqoyXO8r3+ZhtibMu3Lw2zAqVSIQxzrIDXxrdfJuhPp50+EB6Y5PzdpGY71bYMzmwVT8gEw+W+o8DedXIH3yW5mgNjt0K1q8AlKG7zjRNtS8a82I3/yQbXjr7z+XXiOyVlJ7LwASPOZqhH/+/fyLnAJB+zlL83SXzI1Gv9tXmgJf9n1/mIL4R0DOxQ2VX63QTpIMJlokHdEAXBoXWZbKTAAdIBkLOVsJ07RABcpa+UODXbmfboDqNNVoovOEgriKY3MjftirMUi0ERJaNTDRxodvQ8pZc7X8bDhwITAqVE=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(186003)(36756003)(2906002)(110136005)(40460700003)(31696002)(31686004)(54906003)(82310400005)(2616005)(508600001)(26005)(47076005)(336012)(426003)(8936002)(8676002)(7636003)(53546011)(356005)(316002)(36860700001)(83380400001)(5660300002)(9786002)(44832011)(70586007)(4326008)(70206006)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 12:36:04.3134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a3803af-f5dd-45fb-b2ad-08da1e13574a
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT061.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB7872
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/14/22 12:28, Shubhrajyoti Datta wrote:
> Currently the error count from status register is being read which
> is not correct. Fix the issue by reading the count from the
> error count register(ERRCNT).
> 
> Fixes: b500b4a029d5 ("EDAC, synopsys: Add ECC support for ZynqMP DDR controller")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
> ---
> v2:
> Remove the cumulative count change
> v3:
> Add the fixes and stable tag
> 
>   drivers/edac/synopsys_edac.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
> index f05ff02c0656..1a9a5b886903 100644
> --- a/drivers/edac/synopsys_edac.c
> +++ b/drivers/edac/synopsys_edac.c
> @@ -164,6 +164,11 @@
>   #define ECC_STAT_CECNT_SHIFT		8
>   #define ECC_STAT_BITNUM_MASK		0x7F
>   
> +/* ECC error count register definitions */
> +#define ECC_ERRCNT_UECNT_MASK		0xFFFF0000
> +#define ECC_ERRCNT_UECNT_SHIFT		16
> +#define ECC_ERRCNT_CECNT_MASK		0xFFFF
> +
>   /* DDR QOS Interrupt register definitions */
>   #define DDR_QOS_IRQ_STAT_OFST		0x20200
>   #define DDR_QOSUE_MASK			0x4
> @@ -423,14 +428,16 @@ static int zynqmp_get_error_info(struct synps_edac_priv *priv)
>   	base = priv->baseaddr;
>   	p = &priv->stat;
>   
> +	regval = readl(base + ECC_ERRCNT_OFST);
> +	p->ce_cnt = regval & ECC_ERRCNT_CECNT_MASK;
> +	p->ue_cnt = (regval & ECC_ERRCNT_UECNT_MASK) >> ECC_ERRCNT_UECNT_SHIFT;
> +	if (!p->ce_cnt)
> +		goto ue_err;
> +
>   	regval = readl(base + ECC_STAT_OFST);
>   	if (!regval)
>   		return 1;
>   
> -	p->ce_cnt = (regval & ECC_STAT_CECNT_MASK) >> ECC_STAT_CECNT_SHIFT;
> -	p->ue_cnt = (regval & ECC_STAT_UECNT_MASK) >> ECC_STAT_UECNT_SHIFT;
> -	if (!p->ce_cnt)
> -		goto ue_err;
>   
>   	p->ceinfo.bitpos = (regval & ECC_STAT_BITNUM_MASK);
>   

Acked-by: Michal Simek <michal.simek@xilinx.com>

M
