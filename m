Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E4E422EB6
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 19:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbhJERI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 13:08:56 -0400
Received: from mail-eopbgr130101.outbound.protection.outlook.com ([40.107.13.101]:35303
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235238AbhJERIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 13:08:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dkdWnymBgekb6aircnYZ6HoOFlu9+iaCPPw2w/CFsJQzvUGcqH5UBc9E7Q0DKt0DLBxNlf0azYjl7iXq/q4uz/tyOScVw4ZGFeR2kyjXOBZD1nL1ItANFuXrGaBEujnooRwdI/mHRJf3rzWli0vOH/1+eWrtQMINAmiKV/HxS2D5TyTEzXzrmH5kqeO3XyY4ogW1DJ2sHHlpbJR3Q1Q4vq6Ssj+up9SzoLXTIHTnlozanv081mS//4WQkX8fhql8R/gAh3loGx4Lo2Ubuh3D5x7rdbl+DHD+K0079PijqeNwZcTA6At3SD3xSQ+GQ74dumh+OVlCilbmASlPHYCZ9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SQjFcE8j23JULq9dg8h1e1w29f6YS7iHzyO1RTBpUtM=;
 b=PR1tAQRPu8vuRaTc1D3Ej582SsLwn1R7C9LeHg+SRhPYx5GnjO6oMVglMx0Pj+n0sVwOd6bC2RHGxS49A8G2Q4E31CPym7c2TJX1dSqqhgGl2FCJV5r9yQrz4bB39T7qVV5e9p2/UA0afr6DTrMLEO7n5qW+qxYjN3L4zwZsjb4SOuB9Rk7SKBljCvVFLN57OC+TJjTN/bUgvWU5ARbZ1W334Wrea9JMhRNTDnlhC9XRUy4loJyf83KB4K+q5GvU+4RvU984KLgSTGawYBIwNXZi+bme742hY1rue37kR05FJOybsql1c7Rh/rN39kfyRLutp7jnHV7mGl9PmsS6RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SQjFcE8j23JULq9dg8h1e1w29f6YS7iHzyO1RTBpUtM=;
 b=NOfn6BGttKykdDiOTVexnVyS2yEOI5SVOcIHqB294qC0M8WG4iwC1YMYIcU8EoVluBUGW+7GBg8vktTXN214FjgOySiEgMRUB064MokNdVqAdxu+pBspA76T3mf9Gw3n0HFgUA+SVqTk7ly+Y2EmLAjxo2CBiTK//V8260EhHk4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM9PR10MB4054.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1f0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 17:07:00 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::216b:62be:3272:2560]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::216b:62be:3272:2560%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 17:07:00 +0000
Message-ID: <725cc24e-f264-60ea-e30c-c50a61f7fe88@kontron.de>
Date:   Tue, 5 Oct 2021 19:06:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Subject: Re: [PATCH 4/8] arm64: dts: imx8mm-kontron: Fix reg_rst_eth2 and
 reg_vdd_5v regulators
To:     Shawn Guo <shawnguo@kernel.org>, Frieder Schrempf <frieder@fris.de>
Cc:     devicetree@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20210930155633.2745201-1-frieder@fris.de>
 <20210930155633.2745201-5-frieder@fris.de> <20211005070949.GB20743@dragon>
Content-Language: en-US
In-Reply-To: <20211005070949.GB20743@dragon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0501CA0064.eurprd05.prod.outlook.com
 (2603:10a6:200:68::32) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
Received: from [192.168.10.40] (88.130.78.70) by AM4PR0501CA0064.eurprd05.prod.outlook.com (2603:10a6:200:68::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 17:06:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0839451-50a1-48e0-5c25-08d988228bb4
X-MS-TrafficTypeDiagnostic: AM9PR10MB4054:
X-Microsoft-Antispam-PRVS: <AM9PR10MB40549E67892E2084A230B252E9AF9@AM9PR10MB4054.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7hJ8ifpNbovLOLayMWFltLPzG8ZRRZ4eN0MyNUvjrRIBH9WQ7dnT0d2QqnZdxw5mmIbkzbPi3ZQpoElwCc5ddlDt/vQ4jzZXxYNhItQVbFNxs1PgB75zwKhEHlRxNBPSTdDzvKgcH1MXHM9n7bZLX56/Q1YaGv68XfnbI+A2PrPTM0WvXZosbhMoayv1fEofmYXPiyPut+dpF760I5iW9OTmNcp8leRUKii0fsdloFIxvsXngCPt+9VbJm/1swuJRER5kPQVeSXFoEgIWuLJ9BYPHW9PZCJ5SurwTa3tB81yY0coTlMLSn/ZhEATgGS/07QxrBsz5rFUDpdaiSig4BwBrY2wJYKcYSrhSdy/cAOywsBh0ZSWPtZMrnjC/IlTlkmheisqaCW/SJP5HGFDrbEoUB5Nr8gsjSBs41HWvD203qnzrOs9jpJiaITbgV907sA6Ijelw4po8+JCWjtGdt//MKGZoLhiq2cpf2khqKlMBbm1WI54HRm5n8CRWvdI9ufA+O+SWitSzJLJPZe7ybBRPkhIkb0ZiGQFagmuviQkT7iMpC3dR31RRz5z+bCdTBYXIBg0oaMc2QTRvSp6ayVdDIrUL3+z+PDDk4Bqpiz+9RvyWkRa8m341JAC2xY5ztr4+SSaAEFam8DgOdz/Y+A25qs2m60OaBXtzo4ycR1u2tdl/MUpfRnLaiB7Cdpbevu2E9MZFEo28VPeIQjVBLcI2FKidQTvVsaMGQjbzRUQGH++5OynJNeOVaqB5/bykJiNiOtnnautTfomKX0u3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(36756003)(8936002)(31686004)(86362001)(66556008)(26005)(6486002)(956004)(2616005)(2906002)(186003)(508600001)(5660300002)(54906003)(53546011)(83380400001)(66476007)(8676002)(4326008)(7416002)(44832011)(316002)(16576012)(66946007)(38100700002)(110136005)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzJwSUV4ZWFFd2kxanN5UlM4TGRvVEw5UGd4Z1NWcVpTYWk3QVl5RnFFblpX?=
 =?utf-8?B?NG1OWnNHeHduZDVwTko1NDlFNUZpT0RhZ1ZmYzV0S2FaakZWT2d4ampJQWpT?=
 =?utf-8?B?VXUwNnQ4RG1sUXpLU2xGRk9EZVV1NElMVExnQW9uaFE2ZE4xaVZaU0ZpREVZ?=
 =?utf-8?B?MCtTUzhMYW9kc2wwd2c2cGRQcmVFVk1jY09JZXhMdm14MlByVmxTZnEyRnIx?=
 =?utf-8?B?RWZlWHdOT2Y4ME1BOHBBQ2Q1VGFmemZzVmNRbUtBcThYN0ZoSElYQjB5NTY1?=
 =?utf-8?B?aXduZ01lOUp3WFg4OUpsSUxQNWp1dXc0YThJczFIUDh6a0EzSWVLdjgvZ3ky?=
 =?utf-8?B?K1lxemJqWCtEQ3ljWGdlNkhHdTU0d1ZuSWhVak5FanlzSWp3elprR3FCcnda?=
 =?utf-8?B?eHJkZUU1dHlxdHlQQXFkRVBvUzRVZ2ErYWkvMSs1azVxZVRYUVd6RVJ6M2Vw?=
 =?utf-8?B?RUVuZ2dZY2NWUEhjYStNL3QreTYrU255ZlZRMnBMbXNXdXBpK2s0eE1QYkRn?=
 =?utf-8?B?aktrNmkwYm9MZlZ1WUQzY1pPdmhJS0JGMFVJdHdUL3E0TUNIRVMvWHIxaHg2?=
 =?utf-8?B?cTNyYm05aUZWeWVIUTJRaHlnRk9CZmFhV0lIOStKQjlBR2RtSlQ5cmJxcVBq?=
 =?utf-8?B?ck9OV252NHZCamtVNjM4dDJzWE1WdmhlZVM2ay9NRE4reXorT1FEQVdjTy9J?=
 =?utf-8?B?SlVmRDVKRlA2TVBPckNWMnB5UVZ2RDB4R2MvWEg4SXd1TTFmQ2Qxc0ZKTkxn?=
 =?utf-8?B?VnhIdHZ5UGdYTUQrZ3VtbTNma3BuUnN2eWR5WVcweG5URDBFdWFqK0NVOWpZ?=
 =?utf-8?B?U3FFY2oxSzI1N3E0YTZha0ZqcmFHakZyM2s3c3djcTZkaWpJRGxYVlVEcWE5?=
 =?utf-8?B?MkUyQTNJSHMyaUgwclpsWEtBR043a08vSUxRRlBISjJvblZaQkFSQkZRMVlT?=
 =?utf-8?B?ZEUvMCtKdkJ3djZYdFI5a0lzeHRuY1crOXEzbXhsMHFxRFpjOFphZDRzeEVD?=
 =?utf-8?B?ZkRacm9ybnN5UW9Kcll1R0ZzZ1JIT0R2d2FMb2tXVFdER2RaVkhjaElYZGE3?=
 =?utf-8?B?ayttODdjeGN0UzE3bzFkOGRaazRHemxZR1ZmNnptVjVwbjhHaW9XRENVMFdV?=
 =?utf-8?B?V2k4OENDbmNqZkNxN2NKSHhveVVpcW9XaURadUhBUGluZGxiY0pkWnJwdFhS?=
 =?utf-8?B?VFhlV0NTaW01N1o5VGFTSW85TzNOaVlhMnNZTzhidUtJMDZPb2JYcXphNWVn?=
 =?utf-8?B?eG5vRFkrZzFucEtiNzlOZVA1dlhKUGZVeG5xRG9BQzRSQkZ5Qjd4TkRXbWt1?=
 =?utf-8?B?T2orUDY0aHFhTnFKOSt6SS9DVm5ERDEzdjhzOXFaTnZOQXNBOE94Tk9MYjF1?=
 =?utf-8?B?eXRCN05xazduZ3hSZS9nYUZLdmxLZWQ2bUF2blN5c0ZZM2J4Lzd5cVFPQm9u?=
 =?utf-8?B?aGNyTGF0WmZnbTd0UEdOeXlXV1FoY2E4d216WlN0NStEZEx2T3RBN0FXSEFB?=
 =?utf-8?B?VGtDN1grREhMdUIxVG9vby9haEMyeUV6NUdlN1B2VWhPRzlYTi9qY0ZtWWxz?=
 =?utf-8?B?QWhHZkhEV3F0eVZUV2dNL29NSGhwcWV3RDVqTTdLNXgwL0tNTzNVTC9Dc2or?=
 =?utf-8?B?bFFGQThDSWdrWjRUU3JLV1Y5aytTdWhXeTBncXRHVFg1ajlSemdBbjhyclo0?=
 =?utf-8?B?ZWl5a1ZuMkREbk13VVJGRFkrZVFZNXJQWk5rQUpzd1p6WU5waS9pZWh6VStR?=
 =?utf-8?Q?1PiliqpjAgUrrGzpEo3fYoE1ofIVF66+oDepHj2?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: a0839451-50a1-48e0-5c25-08d988228bb4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 17:07:00.5273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WzaVHWGfeJCSScrw73NBkNQAZy0mfxfWDSZMgQdAC5PnNyC+RZr4VFYRkEsT1cQfCT0dwTVl5DP4YhML4mnigr4rXrb1zYGkylzS0pdrmqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4054
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.10.21 09:09, Shawn Guo wrote:
> On Thu, Sep 30, 2021 at 05:56:27PM +0200, Frieder Schrempf wrote:
>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>
>> The regulator reg_vdd_5v represents the fixed 5V supply on the board which
>> can't be switched off. Mark it as always-on.
>>
>> The regulator reg_rst_eth2 should keep the reset signal of the USB ethernet
>> adapter deassertet anytime. Fix the polarity and mark it as always-on.
> 
> It seems to be wrong from the beginning that the reset is modelled by a
> regulator.

Right, but at least at the time when I upstreamed this, there was no way
to pass the reset GPIO to a USB device driver and using a regulator
seems to be an accepted workaround as far as I understand.

> 
>>
>> Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
>> ---
>>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
>> index 62ba3bd08a0c..f2c8ccefd1bf 100644
>> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
>> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
>> @@ -70,7 +70,9 @@ reg_rst_eth2: regulator-rst-eth2 {
>>  		regulator-name = "rst-usb-eth2";
>>  		pinctrl-names = "default";
>>  		pinctrl-0 = <&pinctrl_usb_eth2>;
>> -		gpio = <&gpio3 2 GPIO_ACTIVE_LOW>;
>> +		gpio = <&gpio3 2 GPIO_ACTIVE_HIGH>;
>> +		enable-active-high;
>> +		regulator-always-on;
>>  	};
>>  
>>  	reg_vdd_5v: regulator-5v {
>> @@ -78,6 +80,7 @@ reg_vdd_5v: regulator-5v {
>>  		regulator-name = "vdd-5v";
>>  		regulator-min-microvolt = <5000000>;
>>  		regulator-max-microvolt = <5000000>;
>> +		regulator-always-on;
> 
> You do not have any on/off control over the regulator.  So how does this
> always-on property make any difference?

Right, this doesn't make a difference and is definitely not a fix, I
will drop it. Anyway, this regulator is just there for completeness of
the hardware description.

> 
>>  	};
>>  };
>>  
>> -- 
>> 2.33.0
>>
