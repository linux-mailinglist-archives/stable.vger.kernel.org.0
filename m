Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABBD414230
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 08:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbhIVGzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 02:55:17 -0400
Received: from mail-eopbgr50117.outbound.protection.outlook.com ([40.107.5.117]:31394
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232835AbhIVGzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 02:55:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LY6QQMfpCn6MAzhpyF2MFOcBmPV1nE0nchtrF+6DjAkJh8NUsvyx2tdCiqI8MXQHTYd9CRIzXVRUK0071BHtkLTvGK1CLcBSxnWdWZACpmvwLAmrg1smLh2oo2IU2iYrVWDMfYiKjcC/hFOpauM/jPrAhPwN11d2xSzaFUNUXlhJlEmoegaPcO1uNmOdNT1J+jVqTadylK8yDIFUMg/7SqlCMrlywsyPZH9YGACJAuOKVs6Hf/cwgDPlEuBArZbElPLudKb9mpG/LBXBsICpHL5a56KLr1fYbwlJZTU2Y6cw1Ecgske9HwOtc1p63HLn73R9OEFBFVP4RXvb6vO/tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=yRiDd2ep5TavunwtYTo3STxP1A1NQwSMl6+b+hrOuhA=;
 b=Eqf3kWWzinqZuel7bQOb/ZI8bf/I5TWdalPj3ouQOk+5GZYxXdRepOO6tyIzvPrmcJPiV/+pRfQi0wtylIT/JyJa0bbFMmJhs5/VoTO8ejq+ljcZ+UOBxY8dCCwNDMDcuWuUA1thB5vPMOLO8hjYCm8SmOLJCkob7ksxPynb0D0IAj1GyQ2l+QEdt0QHXuCTY7t+H3LknefIKOeUI/Hwqh9wslFcxJXKvSyF/sMJRr9TByJ8tOIHXydIm+QfzmhzH69F/pXvQD/cnFh4hbmSufPd9c83lORO+gNF2oAjt108hVmzLPjaRA06qbi1RaoppVHJ3rkO/nEr1qOu66kRMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRiDd2ep5TavunwtYTo3STxP1A1NQwSMl6+b+hrOuhA=;
 b=bkinCCFMjNeRS/y4DeDchdIPlvJ5pzBJ+7zboPrXQm2bHTjNYZfFNHAdMJ6VJSgP0yAFk/V2MbvoZ1VrxwbHjCJkew25egBPQ2bA+LRKVooNZuNIUi1EiRw1XAm8Vl0SYgUY/sic+UR+Dup/i0q3Kp4Q0Cbcpp942dHyhw9r+dQ=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=nokia.com;
Received: from VI1PR07MB4542.eurprd07.prod.outlook.com (2603:10a6:803:6a::21)
 by VI1PR07MB6512.eurprd07.prod.outlook.com (2603:10a6:800:179::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7; Wed, 22 Sep
 2021 06:53:44 +0000
Received: from VI1PR07MB4542.eurprd07.prod.outlook.com
 ([fe80::bd06:69c3:98cf:327c]) by VI1PR07MB4542.eurprd07.prod.outlook.com
 ([fe80::bd06:69c3:98cf:327c%5]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 06:53:44 +0000
Subject: Re: [PATCH stable 5.10 3/3] ARM: 9079/1: ftrace: Add MODULE_PLTS
 support
To:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
References: <20210922023947.59636-1-f.fainelli@gmail.com>
 <20210922023947.59636-4-f.fainelli@gmail.com>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <d374a9ae-2dd0-3b11-d5f8-211ef3a6f991@nokia.com>
Date:   Wed, 22 Sep 2021 08:53:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210922023947.59636-4-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P195CA0019.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:102:b6::24) To VI1PR07MB4542.eurprd07.prod.outlook.com
 (2603:10a6:803:6a::21)
MIME-Version: 1.0
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.167) by PR3P195CA0019.EURP195.PROD.OUTLOOK.COM (2603:10a6:102:b6::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 06:53:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcfcbcd4-1fef-40ca-00eb-08d97d95b854
X-MS-TrafficTypeDiagnostic: VI1PR07MB6512:
X-Microsoft-Antispam-PRVS: <VI1PR07MB6512885BC3C151E34E84082C88A29@VI1PR07MB6512.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:428;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x7/3yve1HLqPTJjMsmyVtH8yLDTasREskwP+aTMttR0naClc5rA7oqO9OO96MXSgIh5Xnyr2Nn9o2fJnabGOZA3f7a3bTa5ehtRErkzqArWwVzANuqYvHHhE6P6Rzq5BLOYMtTAGm/U3Da59Lsh1Dpdyag9QC0gjKJI/uc9LD2djXFINow2Ew1KRsFQqhU+3j28nXbVzoZktxNYj4u7lOr2BEe15lRihK+Rcft8rfSyPzfq8YasrYMA1HhOC7LEleXHeyJp6n38qoskkCeu5ynIAfWmfbBGBaXISky5FrOqMqY5399LVbeo/rMFuEtxKqL9nypMoEmgv4jnuJ+BFyBtC1AMK+Gt0SD7ODeEJ2IkyNXhi3YaA7jH+jlx0c5sLLLSoNczGmflPMFMKuIxNpoc7TLkSTjW9SpxlQPzKo8pcJ0dMo/pqDYR1G80ZvWth1D3AA6qP2VoLodyMeMQlygROrCmZOjsQFlU2xKH424oBaz2umekZCTJ5cnBCJqoKEIzqnU8yylYeG37XwxfubL+D/ggGpV5cxMVhZVo/L0J7wpkbGBGFvSQTIXVwun8554BV8tRZGjhpxqBFSSNOeZd/a367lITuWGn+QGF55vsYp91iDV2HQJAyDl3J7S0CF6D6gyQN6TMXjR/T5WF9UVLQkZHbkSNcgC449RRXhlwJdS1SSDK4rhxNBP6La3Vh4C+tXccRpKgxg7G/FgAoN8UPl/BIc8mebu09Jd+NwwXDDT9OtsCqVhl7sOgpq07/xnUZ62Yq9dcRTn+RM8IZFgT2huj19+s3OpzafIL99OBmsGooEsKX6ZjwPGWFuLjN0UL+DiJpoKWS3PM8EbKeW/sZZojul+S04GVP5hwuWPc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB4542.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(44832011)(508600001)(2906002)(4326008)(86362001)(31696002)(316002)(36756003)(5660300002)(6666004)(7416002)(6512007)(52116002)(53546011)(38350700002)(38100700002)(6506007)(31686004)(8936002)(26005)(8676002)(966005)(956004)(66946007)(186003)(66476007)(66556008)(6486002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXhuU2U2RzljVVdSck1ZV0JaSHVvSDkraXdFUXAzWnVXdk9ITDJIdVlaczE4?=
 =?utf-8?B?K2pMRkNUbXZkUDdHdUQ4ekxJaDhlUUZzVFVMVkVLcDZOSE1kdGxNVkZ1cmkr?=
 =?utf-8?B?WnB0Z3JFdkhwSm5TeFdaK0VaOEVYZFlvTzV5ZkczUnQ0QW13WHdaL2c2TkNB?=
 =?utf-8?B?TWZaMDFxd2E2NkhVbVNIZ3VwMDZDRFZlL1IzZzRqZFBubWNNSDhlMXJsV3Az?=
 =?utf-8?B?RlA1bVdoakhqTXF1bUtoOUlLZHZJQ1d2bFo1cHJNamRtVjVCbHZHZnNLaE5R?=
 =?utf-8?B?WDBVaU12d2xhbnQ0Slp3b3B5WUx5cDgveXM4TUFtcGtaTlhwY0ZlMVRRY1p4?=
 =?utf-8?B?T1FZY0dKNlFCM0hxa1pwMVpyalFzdEpPcjlFeXZZSXVhSGlUT2dLTklzU2F0?=
 =?utf-8?B?RmFjWmJXT0JtMzczMVBjUFhzelovT1M3dThiQWpwRFhsZnljY0Fuajh5c2N5?=
 =?utf-8?B?RThDMFQ3M24zYjRkYlhGOFBjRmU1eit1bEU2Q3FQYlE5UGExUHZkZDI4Q2xY?=
 =?utf-8?B?MEk1K0o3cjRNZGw0bU1BUHJJZklzaWl0cGxuTHkxWmZmNTRUTUQ4bitmMjJn?=
 =?utf-8?B?WmM3S29DVGFVYU4yS2pOUDFrVndBVFZPZEU0c21IMEVBU1Q5TzlaMlUwVTMy?=
 =?utf-8?B?NlYrb0NQM1BWem9DWmU0MG04dTBaUWJPckdlY294bHBqaTBJOEZOcXcyQ2xM?=
 =?utf-8?B?MG5iaVFaQS85aEhTSmpaZjFZazJkSUFNam5mNitxczROTlowdXZrNHJrV1ZY?=
 =?utf-8?B?SUpmaVlIMmRSaENlSzF1blFjY2E5Uk9SYmJIcGxvQVR3UUVnTGZ4bzU2R04x?=
 =?utf-8?B?emhXQ3dhcCt6M29EcVlqQU1IY1g3ZGVxWDFuWUFxQ2xydXBlcHowakFLVTVT?=
 =?utf-8?B?SkFRWkIyTng5V0s5UVI1OWEvbER3emN2SUg4SnE3bXZ6TkllcGNUYk9ETXZN?=
 =?utf-8?B?WEttbHF3T2tsTjdNa1F1bUUxWnFEQVdyVUdUMXdSMHdEeVVHUWovMFpibXo1?=
 =?utf-8?B?ckxmQ2VtWENJd29leFlGUGZkSGZkS3AxZzN1N0FMc1ZDTnNYK2FLOU9YTEZj?=
 =?utf-8?B?RXBhRHVBNW0zRmV1bmJmMmJLTnNhcXVSYnYvbHRMWjM0QU9RWUFlZDE1cHFt?=
 =?utf-8?B?WERSNmZVNmFjRUJKa0NvTVlkSGpqVEt6cFV1UW5RbGxWa2hENDV5cHo2S3l5?=
 =?utf-8?B?NEludzFIOUlVS0NhY1dlajQ2V2VUdHVJUWYzYUVzNDNqcU5NWWZWcjRDQWtL?=
 =?utf-8?B?cDAwOXZXNXNjMkphSXRqZEE3WDFKRGZERTcyMFhwQnhCQm1jdlpQOS90Tk1L?=
 =?utf-8?B?K3U4Q3V6TVcyS3FPT0RSTmZBZldQVjY0MUM5RXl6TUhJL0NLUHY4b2tjQWtY?=
 =?utf-8?B?cjBHRFMzKzdMTzU0VjViWmJvVEtTS3QzbjRKWERYOHhpRUQ0Nm81UjQwcWFP?=
 =?utf-8?B?aC9LMnJVbzFsY1VydkIyZlY1K1hpZmFzNzRoKy8vU3ZlZklPWFV3Tlh0TTFa?=
 =?utf-8?B?ank3ZmY2VVpvencyTjkveGNSa3dxUmpqTFhpUTlBVTl6c0hXWkhsNDlLempx?=
 =?utf-8?B?UXB3N0psTnY0aVIwdlVTWTBKSmtjamRCWWJVdlQ3T01VSHh0MXFScEdxRHgz?=
 =?utf-8?B?NVh0VW9iNHhoSE1CZ255S3BKTWkwRnVUQ3Y1dnZDM3YzOWUrTys1NFVFcUdz?=
 =?utf-8?B?bkgxWUpRUlF2anFCOGp4RFM5Z0tHT3FTWVdCZm5ZWis0K3c5Y2Z1Y043M1BT?=
 =?utf-8?Q?6FUIN51MbIFz+cQeZYqn6m+ZBzNfTyUt6wjWdyx?=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcfcbcd4-1fef-40ca-00eb-08d97d95b854
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB4542.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 06:53:44.6877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hIMOQ2Wlen5s0gMYSObx7aDkfZNjEFdL5x9mRzoiO8Ga+gmklOH+b8V9K7iJbkYPfAYpC4xLCvtIyd6eHnd7S8/reEcSl4D6NWpcMuIuMQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB6512
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Florian,

On 22/09/2021 04:39, Florian Fainelli wrote:
> From: Alex Sverdlin <alexander.sverdlin@nokia.com>
> 
> commit 79f32b221b18c15a98507b101ef4beb52444cc6f upstream
> 
> Teach ftrace_make_call() and ftrace_make_nop() about PLTs.
> Teach PLT code about FTRACE and all its callbacks.

sorry for inconvenience, but I'd propose to add 6fa630bf473827ae
"ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE"
to all series on this topic, because of the below chunk which might
lead to build issues on some exotic configurations.

Link: https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/ZUVCQBHDMFVR7CCB7JPESLJEWERZDJ3T/

> --- a/arch/arm/kernel/module-plts.c
> +++ b/arch/arm/kernel/module-plts.c
> @@ -20,19 +21,52 @@
>  						    (PLT_ENT_STRIDE - 8))
>  #endif
>  
> +static const u32 fixed_plts[] = {
> +#ifdef CONFIG_FUNCTION_TRACER
> +	FTRACE_ADDR,
> +	MCOUNT_ADDR,
> +#endif
> +};
> +
>  static bool in_init(const struct module *mod, unsigned long loc)
>  {
>  	return loc - (u32)mod->init_layout.base < mod->init_layout.size;

-- 
Best regards,
Alexander Sverdlin.
