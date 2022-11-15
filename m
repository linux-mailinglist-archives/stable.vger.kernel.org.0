Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F6762A00E
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 18:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiKOROq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 12:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiKOROp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 12:14:45 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2114.outbound.protection.outlook.com [40.107.22.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3096513D3E;
        Tue, 15 Nov 2022 09:14:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+pY7dk/J1IJQLTOfVTvMKou+bcxyQsTobQVlF4cYvSOYNfr9f8D7iz3ZrpQvYona5xZGS46hbwSgJUfi1rQg5L7QonUQlzFamW5L4iH0AxseLTwdXQxkwYdKL5H7y0wVPebOA/kBSslJ/Fv4r0CPPTBhLK6y/CIMMGSbzWm0KO9N2Y0eMDtFlePBF5Cm0OnoBNtpbL1dYV2yB4fzqb1JyaKQP85UPSYlJ/x5G/4K8hRNomWe1AilTL4o4VZ3G0Oxg/lNIk2pZyGkHC06npMBpjcq2y0HoWHouXdhRzA3QWnl8SX9vM8hc7tvnNWXuSwDWaR9RIv4cS2aQF6LL1aEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+JLxNMulTW1c/B9J/1LLMjJHEIYS/WVkcry59E7cI0M=;
 b=GFXIE5i14fIJMYQyYFwgZTNpoXKR3e1qDnV3gT7CAHgbaseqN9zzWAKDaDCh2j1/dYulNhVVgh+IjmMXalyS/H9MWSeuihWXbGpqWIXToaeTyVttV1tnAOuUAvjUh+v6xqBWoqHHcsK089htvdJ/H9amCpUcp8mrOZK9auyG6Rbvm3DzaK/78BQLoYC5xAOR8QKrx7VeNDLauTNE3E6MXUXFAd9av7j1nArNLwOBWpNM2+MZF6y5fYUg1KmyjlDoV04fNjpGhSBrjyULII8ymZoJfd6Uiml6qfG14TnamAdcB/r0RkUP9uGyvfEPfDSYBn8RpSScXL7TSCeo9+1LZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JLxNMulTW1c/B9J/1LLMjJHEIYS/WVkcry59E7cI0M=;
 b=ZqdBFRZarA6CP7Pbz0uiU/yNFYjuxVI7weOtPq6l6FhJ5VSNhnh9JnWFNL8BekQ8iuhA4mcWqDqL1QEYS6geQyADbFw9pDNQAjYqIo3rGeL90u1BqM87GMPNBG7AJ8T79E3E7VDCBDe03ZvPlhw1taQT87ngAnckIR4rpMrXOr8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kontron.de;
Received: from PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:263::10)
 by AS8PR10MB6868.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5b5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Tue, 15 Nov
 2022 17:14:41 +0000
Received: from PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::f209:bc86:3574:2ae6]) by PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::f209:bc86:3574:2ae6%5]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 17:14:41 +0000
Message-ID: <06f8339c-4be1-159f-9374-ef8e6031da1e@kontron.de>
Date:   Tue, 15 Nov 2022 18:14:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] spi: spi-imx: Fix spi_bus_clk if requested clock is
 higher than input clock
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Frieder Schrempf <frieder@fris.de>
Cc:     David Jander <david@protonic.nl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, Marek Vasut <marex@denx.de>,
        NXP Linux Team <linux-imx@nxp.com>, stable@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Baruch Siach <baruch.siach@siklu.com>,
        Fabio Estevam <festevam@gmail.com>,
        Minghao Chi <chi.minghao@zte.com.cn>
References: <20221115162654.2016820-1-frieder@fris.de>
 <20221115165413.4tvmhiv64gdmctml@pengutronix.de>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
In-Reply-To: <20221115165413.4tvmhiv64gdmctml@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE0P281CA0021.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::8) To PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:102:263::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR10MB5681:EE_|AS8PR10MB6868:EE_
X-MS-Office365-Filtering-Correlation-Id: 8810e158-1eac-41fa-a30d-08dac72ce1df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZNncG6ZPimCTAIh3e8XcCwPIv4OLZT1BGnj9sbiijZxeFdgtzAt3vK4FywsWI016E0tdyzHcyyshfzem+maZL+4VZ9eVkCgtJ8t2oRrfWmZrFvcL3pT/ksk+xwFo51irSNHmrPm2/z4uHKLtEWfAw/j3hxpmQNvTwZfWk8qGzTsZbwJeRfcLgucni/ecfmY1iSCl1mmw7IZV4F4NYzP2HOhhvXiV0Tp+VQloGcuTFJHxGO2J1e2fixMpOlFeatO6n4jr4pNDUJSgDEA8SPDQvJytxvlcHwvRH620v6gHbaeEWMQF8Y9r01+0bhy45Xdg7wpqJsql8regrkJCVC88xOZRvt9BH1eOqpTWyfyvvXO8owcxiAdqYRm1+DST9jzCyI0Z4iMEEzp/VEj3OI8qsYOkDbcMJBi1EWxFCotn69P5d1jMB5Jx78U6SVD0m9Cw/sRBghoeuXmpEnbsJirV/FEURa4wSKDeFZy+WEOt9tLBcOGenoMXjnj4Lzbniavr4loRnq2ZAasDMc6EARoPJ3sGnKgBOMi0jtoQE1B/EM5H48+6pftKyi555ZJ75soogfnDvrM7rqD7FzGLxUmOuXGDzWNhTQ2nFiUawnYF4POQRnWc8DnUYoAUvUwsxTvfFjybF/PDE5z1engwLoK7rhQXKZFXhS/ynGWCFV8UmsWkXlNfZf9/2/MSmDmaV4d+N0Z8W/W642ZwqNTi3FWKo8bSXYSvUuve/tQ4KMXRz6F24QLDNdEc/cgTQEfqmzJZLPAHfnDBuxN/R9sebNqbRIjAFnq5c/CJ5ABPinflO8w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199015)(86362001)(31696002)(6512007)(38100700002)(316002)(53546011)(66476007)(44832011)(83380400001)(41300700001)(2906002)(8676002)(66946007)(4326008)(66556008)(186003)(8936002)(36756003)(5660300002)(7416002)(2616005)(478600001)(31686004)(6486002)(6506007)(110136005)(6666004)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzUrU0FtVnowdmRtRm1MZEpXRkZCM2pVbmt3SDlpT0NZQ1pGY0VmclhkSkYw?=
 =?utf-8?B?SUFWMFl5cnNybXhEQUZ1clhRYjB1SnNyT3ZtOGdhWU5RNGtoc3l2UWsyVGVY?=
 =?utf-8?B?d0hGM1l3ZldqbnpSVWNZZlhha3BqMHovcHA0NU5IOXI3a0tlZ1l1T2xvaHJT?=
 =?utf-8?B?NG9lRmdTN2xrR3Y2QW5BZkpQN2wyRzNuYlRVMDFWQVNRaW44Nmp0a0xVYXg0?=
 =?utf-8?B?SmphRkNwUCtnQUNRNE1PaWYvNEhNMXhsZzVnZE40YS9Zc05hbDdLMVNhb1VC?=
 =?utf-8?B?UFB5MC9oREJEbVNQcktITjlPRTd1dktrTGZQME5Qcis1elhQWXc2Yk01cEpJ?=
 =?utf-8?B?dU5ZMzZ3L1pBeWNVdEErODVLeTNaMmJnSWVyZkxjYjJDYzFZVkluak43TUd3?=
 =?utf-8?B?RXRISnFFUlZXWDJaQmlucVpJUkhmWGYrN05ValhCV0VIQVRMZllDTG04eThk?=
 =?utf-8?B?Q0M2WnlIbmgzdDBaUkNEYnQ1SUZIL0RSS0hHN2hXdW9saEhSd2t1ald3cDJP?=
 =?utf-8?B?WGlLcHNTbnNNVmF5czJtRjJMR0tCeWNUMlBWYS81dVlYUmlRNzRKQUhwRVR2?=
 =?utf-8?B?VzlMc1V4S09iUG52eG1iNm1WQ0ZKVWVEMll2YlJxeHB4SFBZSzRGZStZMTda?=
 =?utf-8?B?VzZSQmpZVnJ2bEpaTzE3NGc0Y3dWdlphaFFma1BxWnV5NTZjaXV1a0VIZjdr?=
 =?utf-8?B?SnYwb0JhRHZqbjBkUEhtalBScUVnR1ViVUhUU0psNkxrTGQ3UjJ1SnpZdjIz?=
 =?utf-8?B?cE1wcHJWTGdiMVNzRTNlVFVLaVgweHo1R3RSZWw5S1FKbjVpa3A0aUwyaGky?=
 =?utf-8?B?S0VHdStNMk55VmZ0czFkVERkS3JKM3FwcWViOGVBUHZyWFNaZ1hXRFJvcDhp?=
 =?utf-8?B?N2dEZXlTLzQ3RHBhMzFIZ3grRE9jTjBzTXNzdVJBQjdGbjhBOCtMalVYdGpF?=
 =?utf-8?B?STJ0NS9ETmJFdGhYQ3E4VW9MNzVLT3BDWXBsOWptYkdHV09EczFyTkFSRTVI?=
 =?utf-8?B?SHozaHl3MXhTWTdQdk9lV21qQW0wQi9TYnNwRzQ5OVh2MG4rSW52WWJqNllC?=
 =?utf-8?B?TnJraEVQdXdJQ01GQ0dPNWtlcjVKV0QwU0hZZ0RkcHFhdWNXa2VEUktOUDFY?=
 =?utf-8?B?bU5xelVPN0tnKzlMY0hVTzZjRGxrYmZZbFFma2R2VERHYjBJa1VpaU1Ya0ZW?=
 =?utf-8?B?TCtvd09Wd2lHaWFxOEt5R1VGM0ZQNFh0YUFBeVdjQ0hxTVUzL1dTUHdaS2g3?=
 =?utf-8?B?bVJ0ZlVGWW45ODVCTWJtVVNQeGEzRUVyMDRtK2NKcmI4N1kvZHcwdm9CZ2R1?=
 =?utf-8?B?bHhBUk5hRXFHK2FBNDZVS09lbUROazRYYzNyTFViNFNIK2pIK3hMSitvemRK?=
 =?utf-8?B?Ymlnd1dXRFJMbzMvK0NNRkpGWHliWlpPQzcvMGVVRW9UTEZ0MjZSajVpM1Bk?=
 =?utf-8?B?YkpSTkR5WTdNdFQ5c2NhcUhYVmVZcVZ3TzFMeHB2RCtzZmZnQkxTeGNCdVFH?=
 =?utf-8?B?b2s4UmVraVV6VGxHVGZLcnlLeVJrUHZBUzhvNUpTL0JLbjRDUDI3VjBXbUdy?=
 =?utf-8?B?c1cyWnhhZFU4M09IcTBXUktUY28rS3dsZHFIMXdEejk0VjR5UnBZaC9XWTBo?=
 =?utf-8?B?cWRYMW56Y3BLT3lZUjFxQnNtcCthS1RDMlg4emZwaXoxQ3lOZEZQMThWWkdm?=
 =?utf-8?B?UDVoYXBpTC9jTjZKWHg0RnZ3N1E2ekd2djAyK3ZHNUpjSCsrNGo4UUppYXMv?=
 =?utf-8?B?ZzByaEhwdE8rd2FNZjdnNFp3VmhkZXFxc2U5bHdpM2huQXBjcFAwUzN4RFlL?=
 =?utf-8?B?SDdLUTI3RkNXeEVFSlVPa3hLSkdvdEVUZjNDNG5pOXZaSlZCTWF1QTlvSXo3?=
 =?utf-8?B?Tng3RDBtNFVDTUc4Mm5LcFJKditPSTlISktlNjNzTmNSR1cyR2xjcWZTUmFa?=
 =?utf-8?B?djZPeUFCOXVNcGZEa2JHc1F5VEhWaHBhZHJRdDdwZ21meVZwbHhjZEdwMWpX?=
 =?utf-8?B?Z2tvbjNSUzJDK2RNeVBEZEg5TmthVHhPUUtFN3lkd2l5RUlIUWlhVXVPdHdM?=
 =?utf-8?B?N1RjeitiMm1ueUxCWHEvSHRSemV6dkFiT0NzSjFWajEzbTR0V3dhWFo5QVQ0?=
 =?utf-8?B?eTArQTVGZmZDL0x2RUx3Y2Z6UUVScjdTb3Fqa1dBR1pLNDBUY1BuMTZ5THJw?=
 =?utf-8?Q?RGbMYSMnKyFOg1+WPeLahYHu0mOYkWtjSz23A9B1QvjL?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 8810e158-1eac-41fa-a30d-08dac72ce1df
X-MS-Exchange-CrossTenant-AuthSource: PA4PR10MB5681.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 17:14:40.9301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cCXQHb7qmY8xyR/zBCgjTXkbx6Gd2qb6NY6AFdPnfrPnbtKY+pyvVSlsyL7IdV8StYleobI6I761oRNOko4OqjIj+f0rv4S1WXq/HUxVSJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR10MB6868
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.11.22 17:54, Marc Kleine-Budde wrote:
> On 15.11.2022 17:26:53, Frieder Schrempf wrote:
>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>
>> In case the requested bus clock is higher than the input clock, the correct
>> dividers (pre = 0, post = 0) are returned from mx51_ecspi_clkdiv(), but
>> *fres is left uninitialized and therefore contains an arbitrary value.
>>
>> This causes trouble for the recently introduced PIO polling feature as the
>> value in spi_imx->spi_bus_clk is used there to calculate for which
>> transfers to enable PIO polling.
>>
>> Fix this by setting *fres even if no clock dividers are in use.
>>
>> This issue was observed on Kontron BL i.MX8MM with an SPI peripheral clock set
>> to 50 MHz by default and a requested SPI bus clock of 80 MHz for the SPI NOR
>> flash.
>>
>> With the fix applied the debug message from mx51_ecspi_clkdiv() now prints the
>> following:
>>
>> spi_imx 30820000.spi: mx51_ecspi_clkdiv: fin: 50000000, fspi: 50000000,
>> post: 0, pre: 0
>>
>> Fixes: 07e759387788 ("spi: spi-imx: add PIO polling support")

You want me to remove this tag?

> The *fres parameter was introduced in:
> 
> | Fixes: 6fd8b8503a0d ("spi: spi-imx: Fix out-of-order CS/SCLK operation at low speeds")

and instead add back this tag? I wasn't really sure about that.

> 
> The exiting code:
> 
> |	if (unlikely(fspi > fin))
> |		return 0;
> 
> was not sufficient any more and should be fixed.

You want me to add this in the description? Or is this just the
explanation for why 6fd8b8503a0d should be in the Fixes tag?
