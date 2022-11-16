Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F2662B4DD
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 09:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238722AbiKPIRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 03:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238363AbiKPIRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 03:17:36 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2094.outbound.protection.outlook.com [40.107.249.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F44E0F5;
        Wed, 16 Nov 2022 00:17:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cr+bkeTZ7a+WfiWmFL4/chWPCn0roNgH1kARPVA4Wk+tx7+2R3g2A8c/yDbhrIonGWf3viXchSfJH292FOvA00eoiJgEV1ToYb1WpP63MPxWAXBwc5hw+kWK5+CtdLmwtUGAcpPlo9vaTS/AakC5RqRbN7TxwlHsjwyaOB17jDCEoXtoBh2YFoAKAgkifOnS8PjufT1K5xvkino6lh3v4d1BL4gZINPDsa6w7v//KqtEmtFKt/7czX3BZvRtIujXlhsohnzSp191H5WNzrwIdcWTY1Xd+5JVqVrZpW9/0h/fhQWJ9uH6zKs1fW+mUHAOKWLc7p/JBwK4AUgUOo+EWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRo+6C47oxqu8g1OFU2RfNaimkATMdTyJXNW30CqXz4=;
 b=Uat7GlVTumX/JxjOCuqZQd3X7YXKu+AnY4BR6BdwgAM+BZNJsiSInENo3pUHdkt7RHGreK3CCrflaEUbINpKfaicrDGHi3qUKMnuHi2TC3ByiSJD8Sx3I0XH5yAtJ05XmSMpc1e9KlNp23gl5qfdH4MJzTbR95WJRi/rF0wEG9C/93neWDSSi/9rMlkW7NdYqQqa84xGaAd8Y0w0FNHq5RvOmkQQltB8RGCCGJp6oEcq+KdxkYjCvPRJ2g7yZQAiAlfdcWzu53jGKmSc4KpFp3gQD3+RdCEup88qkwnEhxu8TRsPKHV5U52cob/L81C64J5hJcRr7442OGFeDMhS1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRo+6C47oxqu8g1OFU2RfNaimkATMdTyJXNW30CqXz4=;
 b=n47sMKQbn4rTclv9/y3nBglIphPSg+4urmgu4O7T82z9PVZAwP3rblD46clk3EgEmktL5OIeAQe63h+omMFS2S486v0D5hLALiw9mdNk066j2hJAWbDrtfoP6xTP7oXT6zKXYxStqyGKvJUa9PX400NOOFy/6w7FR4CCB7OOsJk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kontron.de;
Received: from PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:263::10)
 by DB5PR10MB7842.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:4a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Wed, 16 Nov
 2022 08:17:26 +0000
Received: from PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::f209:bc86:3574:2ae6]) by PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::f209:bc86:3574:2ae6%5]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 08:17:26 +0000
Message-ID: <01bce6c9-7825-2995-44fb-ddebbbd7b482@kontron.de>
Date:   Wed, 16 Nov 2022 09:17:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3] spi: spi-imx: Fix spi_bus_clk if requested clock is
 higher than input clock
To:     Marek Vasut <marex@denx.de>, Frieder Schrempf <frieder@fris.de>,
        David Jander <david@protonic.nl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Baruch Siach <baruch.siach@siklu.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20221115181002.2068270-1-frieder@fris.de>
 <7b31dd4d-a74c-1013-491f-81538001917e@denx.de>
Content-Language: en-US
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
In-Reply-To: <7b31dd4d-a74c-1013-491f-81538001917e@denx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE0P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::14) To PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:102:263::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR10MB5681:EE_|DB5PR10MB7842:EE_
X-MS-Office365-Filtering-Correlation-Id: 9490b2d9-c10f-499e-53b9-08dac7aafef6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /foWHjWGJJjyuzsFlM3KOOOkOHzQZIx+kcrRnzYI/J5IqQX6n26Pgi9GPcsYaxnmLoW6TIRDi2AS3TwTdouqP69mVTJaJOfV7Y6ltDO8hnksh4RSC7O7hciExNkU55O+fTJ25eI/TMoMTaiPB0j/pMUSFl+W+i9OmtD6KW2dVVt5JCUJIBrAyFXJGo4eWJ8cwllLIqIN6DfV/1xBgaZjDJi9DO2R4gV2bcEA0afWwrhbT5f/xd8gr1/LTRKKB6+AOVvRZFyU4vL9JkdiCJzaB9I/VFHKcBrjYhTV5kY4rqsp6DA4z0bdIg/P0FT7Vfg96g0SNGa3a0rvBe6itCEP4qtcY+yd7xss05YU0MVJmAkL0gfNq9r/o+087dQRprNpAKIRgiGX2m0EKXdtmekov44LEPd+xmBXxWg6VQwQ3oU+jClunqLEuHHUXMjUC9WsbLQBTe6qKOb+euXELN+kW8wTmZ7aLWz+z6CoObMa7iimh86KS39Iy8VX3rzWef4T4ubjFH+0NB29Cyv2n0tGtrZd/ty5PEcXpX14WvmBJbO+DiQhVmY5Psh6Va1aPF8flpFJgNuHAQu723FZ9IqNZUHJ7cM/bssyTNxI5Sqwi3aLTA5iEjSxp/bAuoHsgZ7+f3GdZ04HOdZcN03lT6D+6xHGmQvqG+/3rs3X77Y2NL+ko80mYUPStPTVndt66ThdbsYhlp4qMJNWDmEZh1eozKxYkdMiv5Ib6tCqnsd0wp5gUJITDixunKDkQLD0QiQXaqTuCoWTrS3+XMG/et0xbwKoyZh5wUTeMNvp0EJk9LV2Elnruqpcwfacj6F7ap4z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(451199015)(478600001)(110136005)(6506007)(36756003)(53546011)(6512007)(44832011)(66556008)(186003)(921005)(41300700001)(8676002)(5660300002)(6486002)(7416002)(66476007)(66946007)(4326008)(83380400001)(8936002)(316002)(2616005)(2906002)(31696002)(54906003)(38100700002)(86362001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWdSL2NxTUowc1JJd1l4Wm5vaXJUN200d05Td09ockxkQ2Z5VlFWZGUxZW1O?=
 =?utf-8?B?ZjVvSXoxRG8zWloxTit4bEtWUFRNcGJaR08xQytYNkxhM2VxYTRJSnJrNnRs?=
 =?utf-8?B?dFZRS0ljVlVoOTVRK2ZUS05obERCMERpMmcvN2p4elFUbTBPNEtDM1ZBbE5O?=
 =?utf-8?B?bVRQQjFrcnhKLzdtV0I2U2NaQzVoWGQ0WXMyNEZ1cUlGWE9OSWYyN0VKayt4?=
 =?utf-8?B?aGQzbXExK1RmaVlDOG8xUVF1U3lYZTczL0Vha3RSQWd1OHRPOUN6ZVJpVnlk?=
 =?utf-8?B?N3BYSkhXOWlCN1Ztc1E4ZDkrQThSbldnVFh6a1h4ZndwQ0dBbHBJOEJNTlMv?=
 =?utf-8?B?MzIyQys3NmJCQlVLaU5MTlMvWUFQOUJxZXNDeVJJYnRJdFhPNHJTSVlUc2Rq?=
 =?utf-8?B?SUpnNzZINms2SzZnUnIrbVF4WFFRRTRzY1lhcDJiSDNQa2laeEZQWGFLY2Jp?=
 =?utf-8?B?SDFxaStBQVc3a3B3a1N5L2dNWHc2eGdvbW9YUThsUVBhaXViSDArVGJJa0Yy?=
 =?utf-8?B?ZU1jUDBselpsdk52a3djWFlMYXh0ZmhMUnAxSDJoNFFoTHZiN1Q3alNHODFQ?=
 =?utf-8?B?cnBOdDhXQkw1b3JYc2pwUjl6ZjU2MVVRMlBYTWcydWFlOTZDVXN3dHcxZWJi?=
 =?utf-8?B?eUdJeko2MFpnSkE4b2tjTTM4eEFpOS9ObU9KajlIbnFMTWd0UGhxdWtvOUVB?=
 =?utf-8?B?U3p6WkFIaE9CSFFhWFB1NVJJMWozWXFmVTJReW0vU0pGYjJuVGhDVHUzQmQr?=
 =?utf-8?B?SzhPcWpJVUJiL2MzT1FSQzd3T25CM0c0YVJ3U1VrUEFGdDEvcFQyMVVGUTVW?=
 =?utf-8?B?QjJ4QTErS0RsdG9jaDlDSUthTHAxRlBST09yejgxcTBQa01ZWVkvRjVMKzF5?=
 =?utf-8?B?VDJzemNLcEFyM1F5NFpTL0JCQ3JPQm5NbGgyNUpndkNrTXkwdGNFSmhvQ2s2?=
 =?utf-8?B?UjA3bC9saS8zRDg5NDAvYkV6VisyU0dzUzRPd1RPeUMrb0Z3K0Y2ekdxcjBP?=
 =?utf-8?B?Q0s3eE80b1Q0Um0rMlJINTlUUTZjZk1kb016alBXQ1o2NkRVM0ExeTNoY2xQ?=
 =?utf-8?B?WE1DUm8vN3Nrd1pORFlGWmZERHFJbUs3S2N5WjFPc3NHZGx4S2VCamhzUVAy?=
 =?utf-8?B?SHNhbm1uVzlCa2R1SUZIdWFnWGd3OUhNY1k1S2xRRWw5VERlTU9kRy9jKzBR?=
 =?utf-8?B?blVxZUI4M1NEMXdWMVdlaVNXbEFjWGl2UGt2WXFYNzVielhieW9rbjJoMmlY?=
 =?utf-8?B?Y2NSOFlGcjU2Qzd1djBySklhNlp6bURBSXU0eWRxQnhrL2FaMG93N0JnWFVx?=
 =?utf-8?B?YmQ2eFFoR2FqQXNUK0ljdzNraHVIeVpvK2VIK2FSeFpReU9NUHBNTURhTkwv?=
 =?utf-8?B?SFhtT1R0azVjRm5BaFFVUElwSURwbkdLK2NnQ0lzZGlsWCtPRG5XRmlOUGl0?=
 =?utf-8?B?VFVZaVlCcUFISnBNSDlGdDBhejUybThMRWVFVGpRbkVzbXNaSEptc3EvWG84?=
 =?utf-8?B?aGFaWm1yZlduTjluZk84TWdRbjcycGM0SG9SQkNGQjBNRytITFNRcTdMYkhq?=
 =?utf-8?B?SDB2d3h2R0ZCcVpoeVFWS1RXTEtwTEl1T2JPVlZQcWNkZEN2NFRUN051aUpW?=
 =?utf-8?B?Y016ZE1pQy9FTVgraHRKcDU3R3VUUDUwaXdyWHc5VFhPMHFmMnB4aUZpbDVl?=
 =?utf-8?B?YlJZWWV1SExHRitXVDVvUDdrbi9MKzlZcUJlRStnSkhzNDI4dnRYR2YzRy9P?=
 =?utf-8?B?VW9lT0pFbDcvRHpLOE12UVpLWjlEMlNFaTdYbGQ2V1hjejQ1aitJZ1owUTBX?=
 =?utf-8?B?OTBFQVZ3cGFYcjM4U0hINTlKaDg1MkFWRDZmQjNHWE5iS29WMnd6dWpCcklQ?=
 =?utf-8?B?N0lyMHJCMXR2eWRnb2dObVQ0eW5nbjYvMnErQ2dxZmRoN1dJVitzV3liV245?=
 =?utf-8?B?ZC9BSFJEWC9DQy9qVG54SFB3Q3I1NGpQWVI2OFlJeEliZnpEck9sQUJNUk81?=
 =?utf-8?B?UDB3NUZNWEdlTFVEKzViWEtzMUlDUmkvREVDKzBsbzlGWFIwN2VPYnZaa2s4?=
 =?utf-8?B?WTg3bi80SlNJTTBTZDZXVEVJbGVRWjBtOE93V2VyeElnZVpaRnJlcGE0OGZi?=
 =?utf-8?B?ZG4ycHhzN1FGY1FPTTdrYUZFeHhRS3BpazFTRUE5YUdVbUt4UHU2elcyempy?=
 =?utf-8?Q?uoVzgtgLF23CeB2Vh2z8e1UyWpwIKRcA7tssy5wDxPmE?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 9490b2d9-c10f-499e-53b9-08dac7aafef6
X-MS-Exchange-CrossTenant-AuthSource: PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 08:17:26.4145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O/LEVqRhP0/tykRQYFnBVjULu6uuOrAjNhiL3HDC3l0XB1n49jUxQdzwdG0c+F1f9UYzqGXWhY70doN6R5AWWKfqTNwUG0lwWxM9DyS7K98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR10MB7842
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.11.22 00:49, Marek Vasut wrote:
> On 11/15/22 19:10, Frieder Schrempf wrote:
>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>
>> In case the requested bus clock is higher than the input clock, the
>> correct
>> dividers (pre = 0, post = 0) are returned from mx51_ecspi_clkdiv(), but
>> *fres is left uninitialized and therefore contains an arbitrary value.
>>
>> This causes trouble for the recently introduced PIO polling feature as
>> the
>> value in spi_imx->spi_bus_clk is used there to calculate for which
>> transfers to enable PIO polling.
>>
>> Fix this by setting *fres even if no clock dividers are in use.
>>
>> This issue was observed on Kontron BL i.MX8MM with an SPI peripheral
>> clock set
>> to 50 MHz by default and a requested SPI bus clock of 80 MHz for the
>> SPI NOR
>> flash.
>>
>> With the fix applied the debug message from mx51_ecspi_clkdiv() now
>> prints the
>> following:
>>
>> spi_imx 30820000.spi: mx51_ecspi_clkdiv: fin: 50000000, fspi: 50000000,
>> post: 0, pre: 0
>>
>> Fixes: 6fd8b8503a0d ("spi: spi-imx: Fix out-of-order CS/SCLK operation
>> at low speeds")
>> Fixes: 07e759387788 ("spi: spi-imx: add PIO polling support")
>> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
>> Cc: David Jander <david@protonic.nl>
>> Cc: Fabio Estevam <festevam@gmail.com>
>> Cc: Mark Brown <broonie@kernel.org>
>> Cc: Marek Vasut <marex@denx.de>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
>> Tested-by: Fabio Estevam <festevam@gmail.com>
>> ---
>>
>> Changes for v3:
>>
>> * Add back the Fixes tag for commit 6fd8b8503a0d
>> * Add Fabio's Tested-by (Thanks!)
>>
>> Changes for v2:
>>
>> * Remove the reference and the Fixes tag for commit 6fd8b8503a0d as it is
>>    incorrect.
>> ---
>>   drivers/spi/spi-imx.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
>> index 30d82cc7300b..468ce0a2b282 100644
>> --- a/drivers/spi/spi-imx.c
>> +++ b/drivers/spi/spi-imx.c
>> @@ -444,8 +444,7 @@ static unsigned int mx51_ecspi_clkdiv(struct
>> spi_imx_data *spi_imx,
>>       unsigned int pre, post;
>>       unsigned int fin = spi_imx->spi_clk;
>>   -    if (unlikely(fspi > fin))
>> -        return 0;
>> +    fspi = min(fspi, fin);
>>         post = fls(fin) - fls(fspi);
>>       if (fin > fspi << post)
> 
> Can you also test the SPI flash at some 100 kHz, just to see whether it
> still works properly ? (to retain behavior fixed first in 6fd8b8503a0dc
> ("spi: spi-imx: Fix out-of-order CS/SCLK operation at low speeds") )
> 
> The fix here does look fine by me however.

I successfully tested at 100 kHZ SPI bus clock. As in this case fspi is
lower than fin, the patch doesn't change anything in the code path and
therefore the behavior introduced in 6fd8b8503a0dc stays the same as
without the patch.
