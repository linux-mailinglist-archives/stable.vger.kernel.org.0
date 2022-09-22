Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF075E68DC
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 18:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiIVQyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 12:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbiIVQym (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 12:54:42 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420A91DA42;
        Thu, 22 Sep 2022 09:54:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJfDl7Xu1/dmJHQjbkbCjbMDtKP4OduDwf4N/1b4IsIa38CF6+96bnzY0kPJ8SmiHqNWCJr3NVTHfU3YLPsMZRKqTlc1mSgKsGG8z6GJQ356l85w6aCUFSvUf3vtNTb82G9iBvz9+sIq6++BpiEMYiuASVSGh5A8nGJKV8GyfVFzjxw7Jf3O9SxXUW+ZgRb8SmrYkpxbQF+fu5UiSkMX81bXFlpY10D0LXD+mSkjuIALF4yOfJCQX78gdbV7qFJjO5HVBEuiL6OOLKKD6wOkZSnr2HzQxmG5JZh5he2mXQ1KTZKLZvgkGB6J+RHbQSR3y+caFMUa95W8iy27icPN4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wGxZMFEAITamQZVSgPvgXVXqbTwY6hEoHULaR3dSJxo=;
 b=KoGXFSAUvXd1ZIm2JoOo9K5iKTmnehkLTmPDA/uvaQOzFdMi8KtK7Lm4yAVClVMpEP+RPR7XO9Ey4fKi36leK7ykBqxauGZ8TYjN0a2y8jn39+RGuQwN9Lx2alph1OHBnQaTLK/ya9gE4gVlnTzX5FpGOG7XIz+BYUgQrjZnlONHRXpOS1qdQk9zvy2bgW+49DF8GF+z6ZZMpXnUmWNq5bJBaU7We1YKKsoKea+yCWrU98gnp0MBYp0+IdFtQQ0Ux3tfRLS6q7LGH0h0m/NgW1ukvFF68M1qLUlzcEvj/RoqE7+olRPKAxRvH+CDsLkHOXmLcsUc2daxhT8I0DcaNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wGxZMFEAITamQZVSgPvgXVXqbTwY6hEoHULaR3dSJxo=;
 b=VIFbN8/tkXg8wnkpyL2oZHMwppJ+wiFJUnTGz3IuFNdQ9QRzecEEN3rQngWFP1E69ZI75CTeCGmm6uUxR6BJlz2X7UITRDRP7ApSswfhfyYHqP9g+V2CIco/ow1EnGSdDOZN7FFTH93sYrQ0zu1grIit3oosJ2qPyxqglcxGN40=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2381.namprd12.prod.outlook.com (2603:10b6:802:2f::13)
 by DM6PR12MB4450.namprd12.prod.outlook.com (2603:10b6:5:28e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 16:54:37 +0000
Received: from SN1PR12MB2381.namprd12.prod.outlook.com
 ([fe80::c534:ae1c:f7a1:1f33]) by SN1PR12MB2381.namprd12.prod.outlook.com
 ([fe80::c534:ae1c:f7a1:1f33%4]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 16:54:37 +0000
Message-ID: <0885eecb-042f-3b74-2965-7d657de59953@amd.com>
Date:   Thu, 22 Sep 2022 22:24:21 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org
Cc:     rafael@kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, dave.hansen@linux.intel.com,
        bp@alien8.de, tglx@linutronix.de, andi@lisas.de, puwen@hygon.cn,
        mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <20e78a49-25df-c83d-842e-1d624655cfd7@intel.com>
From:   K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20e78a49-25df-c83d-842e-1d624655cfd7@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0050.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::11) To SN1PR12MB2381.namprd12.prod.outlook.com
 (2603:10b6:802:2f::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PR12MB2381:EE_|DM6PR12MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: f5ad3b44-3d6e-4d89-c9dd-08da9cbb21c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sha5A006vRpdIXSQRgZrcArWZxLKUANDKtIdsN+4bRT4Rmk6ZLeURcjNktzmT7k52PmslGeLeEeKOZMzMoD9WeZn9GLtKvshaAdzAy7M1+oDBfK3j7Nvz7EnCpRI/lvooTeYnYArl9tGGU5XQ6QAKtH981NiDaQ5dwwVulOJkV8k1at5QgkUDdifAIIBgcUu82b9lF2hj0Y7Fy/JcYFhlU+tU5NLfw0LTmmcD/7Cyehar7Xeb6C32btk8EQN/CevACJ5jt0txkip/2mGahKpjjIWmWirXNs1Y9lGrNcuvK7dgzcLhprMyh+W6s4dOjg/oTtqXn6M6Z8oBjqItmQUEAdDi7siGjVcqfjBxxyUy9LlTT2H70FGblqEmjInn/8EQbvPdkhTAYHCBkoMBsR3XedYDLFVOjGrywlDc8K9Mln+OPBlnOO42wmdaxMQs04/8d4udQ+grM0Mo672b5uTgeqjU3dC7IJv66f0Fr4RITXv97hKDfgQY+B5bTtFmfnzQh3I4PhPeUX9Rae9u7OLtvGfdwBcWycwlt5x6OSolEAc4jMYf5Xt6R/uUjzEF2H6UNKy1FmFl3qDd5N8fUUf/U4uhsbIwsyrIx2LcLY9/BehBC0iD6Zx3kIIiL/gmJz5nA4S6I1idvLINK5am4hotLDKJnVNzJ7TfSJTs1IR0MR79K7UZXuxJVKGAUnknd/kB0SqAV3FmnXBtWL1Ym1RXqb6zKJj14yktUq9H6UIhZ7miPJ61tk91vYqr9ht3X2kdUldgCVRgDzA+02pADkArj4F405WBzUvwNzW3uxrvLc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2381.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199015)(66476007)(31686004)(2906002)(7416002)(186003)(5660300002)(38100700002)(2616005)(8936002)(6506007)(26005)(53546011)(6512007)(41300700001)(36756003)(4326008)(66946007)(6666004)(8676002)(478600001)(66556008)(6486002)(31696002)(558084003)(316002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2ZOUitqNWhrNndzVzFuc2o2MlBEblA4M3F2a004c2lZWEVWQUVicWt5djdB?=
 =?utf-8?B?RFFWQWZORjRseFMyRmtZSVpJNFVVRFR5YXRoNzlvTU9ZM3hDOVhBNVI2UDMx?=
 =?utf-8?B?akdOM3NLMHc0TlcrRG0vZ3VxVEdmUUVKdUo2WmI4aXJQQUEvM1ZjWjI3K1Jh?=
 =?utf-8?B?dWEvWThtbkFaTEN6RENiMEJpeDcrTk1sNDY0UHVTalNta1A4TTBqS0x2V2tt?=
 =?utf-8?B?eCtFNCtyK1ozRGlGMUIxSS8vd05yRys3bVdUUnVEdjBUZE4vdVRxWitlc1Qw?=
 =?utf-8?B?cmlqak5Hd3FXczgwZ0h3T1NndlZoR3pLWFoxWERzeTB0MFFJcjdoaXVKSjFF?=
 =?utf-8?B?N3U2SjVsNTNpSVdNOEVMK3dqbkNOcW5kczFXTE9HMjY0MW5zQzdaK2ZkVFpl?=
 =?utf-8?B?bSszOXpGdkZjL2RoTm9Lc0lEYkFLSHpXeVdQdHFLQU9DcUFCUGRNU280QXVS?=
 =?utf-8?B?RmJPZVA0d1YwWlAzRW1HT1dqYWFYTlQ5R1FlUUlKb085ZU1XcFN0ay9TZkZM?=
 =?utf-8?B?ZjFKTFMvUU5sYnNnSW8wSjNyNDltODZmQmkrTlkxWGNTM01MSUtycTNkais3?=
 =?utf-8?B?YzgyMmQyTEhBc0U2aGF3WmZMKyt0bGkxOWZEdFVsbitUenRrcGpXVVJmRU9p?=
 =?utf-8?B?Y1dicENFWnVDdVljUm94R2huT2Q2YUdpS0NEbHN5Q08xcWd0bHpKWHU4RmFZ?=
 =?utf-8?B?eHlPT1BtVjhKUGpqdEFEbE16cUtEbEtmWGp6Z0tvLzBDODNIaXUyQ2NBdGVa?=
 =?utf-8?B?UXpETlVnMUYwdzY2eW1wWklJSHJRRFQrK0Y4dkpVZE5jVml4TmZTNXMxZHdM?=
 =?utf-8?B?aVV3K0t2SHcwZnNQVHNLRVZ2TjEwV3ludnlZWnRzUDI4MC9mMnlmdlJ1Y0Zp?=
 =?utf-8?B?LzFHTUV4Z1N0TmdlSkxuY2hLcUdicXFDUFNuVzdmak5QWWEya0dtVUlDSkNm?=
 =?utf-8?B?cndXNVQrWU51cWdQM25NbGR3VnZMQXVJTlBhY25ienNxNThNWmUzNy96RW02?=
 =?utf-8?B?OVdFSkF3RTI0TWs5RjM1K3lCdzJxUThiTnFQS2I1Y3JHcTM4K2ZEQXBEQ3B2?=
 =?utf-8?B?WXplaDA4MldnL1h2RERCZGtSZ2h6bHFUWTUyelMyMWYycWRHMFBDaDdWdFNr?=
 =?utf-8?B?RUlzZjE5THN1eW5Idit0MHNLczk4YWFHYlhxb2FGZHB6d2MxWUxtNWYrTlNX?=
 =?utf-8?B?UkloLzFFdUZiRFdCQ3pDVHpjUXp0M1R6TkZBRGw5akJnZnNCM2FEcldSUDJF?=
 =?utf-8?B?MFdzVU5uUVlPVlpSbFpEamZPWG1DMnNMRlY3VlRHT0NiK2FKcFRnTWJrcEo4?=
 =?utf-8?B?K2txVTZlREZKaHB2dytEVjhOWFJkZXhLdlJsM2ZYdThob2tqRFRITmdET0FJ?=
 =?utf-8?B?S1ZhbDFqajRzRlBCMHlkWGE1b1JwRWZDbVlrQzZVYkwyd1VKUUhaUHRRRXVW?=
 =?utf-8?B?NXhyWWp4NG1aNnZSZjFNQ2J5T0J2NXlyeDUwdis0cmx2ZWYyYndZdHJVQ1NQ?=
 =?utf-8?B?RjhUZ3V5dlRXZDNpSkZOVTFpQWpqbXBrZi9TNkxlUEVnUXlaSWJPMEpvcys1?=
 =?utf-8?B?NlpoZllPa2R5UjRCOU42U3ZuQ1orM0Yxa2orOGN6NWxrOTBQZlJabmthMG10?=
 =?utf-8?B?VnRZSkVxVnNFY3N3KzRWbER6aVBtZlgzeFBiMXNnZkp5bFhSY1VqVEdBek5Z?=
 =?utf-8?B?aWdnOWt4bENOZVJYSWdNR0l6M2krZDNKa3pXRXlacmRiZy9RZ2JzNnplTkt3?=
 =?utf-8?B?dVRLTlFpbERjWGtJTWZ3WmZJbmdZUlNRSDYrdFJLZEJtKzFBU0pwY3BqOVk3?=
 =?utf-8?B?L0xwVzNIWDB2MDk3NnRCR3lZUEc1emZBWk1jWjNLaldMMStaeFRadm1VVlNE?=
 =?utf-8?B?S0EvbnZCYXBSVGFrakl1MGhUUDFaVStPYm13MUNsZzJsdExSYzgxSTQ4Tzd4?=
 =?utf-8?B?VisrcEQwd3lhTHI3UGRIa2FNTjE5cE1rTkFzUmlMUXk5MGxiUW1mZS8ra1lu?=
 =?utf-8?B?MVRzMTNGVVRwN0V0NVhsQUJnNjNEOXJ2RnJEb2tFR0JCbXFwbTBuay9sYjh4?=
 =?utf-8?B?Y0E0VHM0cGk1SlVGcXJNd1ZRL09OS2ZDRFdkRjdNelMxR05wSUoybVBSM0Ux?=
 =?utf-8?Q?m/1JG8QpKyOLXuSc7HImc4gbs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5ad3b44-3d6e-4d89-c9dd-08da9cbb21c4
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2381.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 16:54:37.0239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gm8l4J0+IBPvKvAmb2FFKph7xPkjCON9foDSfuGg53E6HoeGdvDPgeEFRfEW7rCjGRZ6VCaVAsppM8/C0I+EIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4450
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dave,

On 9/22/2022 10:14 PM, Dave Hansen wrote:
> On 9/20/22 23:36, K Prateek Nayak wrote:
>> Cc: stable@vger.kernel.org
>> Cc: regressions@lists.linux.dev
> 
> *Is* this a regression?

On second thought, it is not a regression.
Will remove the tag on v2.
--
Thanks and Regards,
Prateek
