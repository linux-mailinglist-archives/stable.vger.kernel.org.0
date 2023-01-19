Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F3667375B
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 12:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjASLtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 06:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjASLtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 06:49:12 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C7D4DE10;
        Thu, 19 Jan 2023 03:49:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIa2P9ZD2GHNJx0VxBB5oTWHygTThkJxK5NdF0Wo8Wlp6Get2ATlt20Ee4YmEmGKnsmHFzeIQhxFcnqjbcCzsfDL7VSElMvAjwvT6hG/jHrqH/n0o1C40GIAtuqTJ2umeJRtjZb69GKBEtrOO/PIWucXFdZEvnx7UrF272tmKmAHfMX1lRnCvMBKQ24nfgmtEkrwpRz667MFeM9eS9h0f4xWA/P0G6LHOrzvy2lN9Arahf4G0dIeJdwA5UBXrF4DnSO5m+0UmkMtsaEAyErYi9EHvzJT7G8Ve/kvnb1hL6WQpVkoaBxMHCjryhXUD/yOcw5oYlbdfxH4L8AsMChE2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Bej5mzsZGOprl+cn2cWhz4KWkxsw9DrNwid9mH6yrM=;
 b=B00JaJj9o9oZU6UNeWoD2Y//arSV26LfbbfXiC6O9CXhyBgnEOuK5ou9y0gm72Pjn2u5ODKIF+IC0wqtAdk3ZlbHBjphe1GOB3YyeN68S/n047yWbRn5iFH+C5g0DHX40LXJUoxQcPCeXcYQoeufRmGgZ/kB67IvZmeKe9MnbIYwnhG4ZQzWhxtHne8N/xvcIoiU+rnGpK8b/Cr8yW3m9uQEoxZYJResMw1q+qneIyhXqmwOd9K5KwVfvbEBND4J96Y/ZCtwCUITkCLZAUqWkVon1JuKL+XDdjseCIEgd9GVt9jAWTDAolBpbQRbmvwKTyV8yThkWCX8JJciN5GdkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Bej5mzsZGOprl+cn2cWhz4KWkxsw9DrNwid9mH6yrM=;
 b=dbVkQvRsW3xVNah1FA8/Pgjb73kI8NX8eBpMfhIRfCUzm4nJGMVDm/1um9iHz65n8R8Bx7ut85AaOLLTCw+td8AwZ6px9vftdrO150wB5skU7gg4ibwGlQe4qpIevRxg8XZ7K4bxJX7aDomGsmh3JVQI949Qx9NlyeD5zxTvdug=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by CH2PR12MB4229.namprd12.prod.outlook.com (2603:10b6:610:a5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 11:49:08 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::80d8:934f:caa7:67b0]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::80d8:934f:caa7:67b0%3]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 11:49:08 +0000
Message-ID: <25814d03-182b-a2ca-2d5f-1cb5290f5656@amd.com>
Date:   Thu, 19 Jan 2023 12:49:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 1/1] drm/amdkfd: Check for null pointer after calling
 kmemdup
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Dragos-Marian Panait <dragos.panait@windriver.com>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Kent Russell <kent.russell@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
References: <20230104175633.1420151-1-dragos.panait@windriver.com>
 <20230104175633.1420151-2-dragos.panait@windriver.com>
 <Y8ABeXQLzWdoaGAY@kroah.com>
 <CAKMK7uEgzJU8ukgR3sQtSUB5+wrD9VyMwCHOA-SReFWd0tKzzw@mail.gmail.com>
 <Y8A5NgtGLDJv4sON@kroah.com> <Y8ka2khSlK6E/XbF@phenom.ffwll.local>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <Y8ka2khSlK6E/XbF@phenom.ffwll.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::14) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|CH2PR12MB4229:EE_
X-MS-Office365-Filtering-Correlation-Id: 411f0393-f169-454c-dc1b-08dafa132c46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CO68MydRCvIGMWN7G3ld/rmNNKyHe9FU+pFJ0TycQipTcs9ZGvdnl/XGOyWUPT6m1SY+MPT1IUTv6TePrJDGPT7SqYPlpRJbfDhio7nYTqwOLVtTV3+sCqtxos/zr5EebWvDhr0iaYdW39pTgek61GH3FUZSnIoWoqQSmJAjeruhPFTJO+Ln4Vourdn29DsGys+crrguqadqhZw+hM4o7z/4AfEikxwIY06kp3NJJWMbKJWiC6J/dEjs9VWGi/xaqNvptNYvTEvJwrCPeEeObqX8HcOwSy1+siYKmMPX8q4ZrVpqBG6DcY1qrDvxxoQPqAeTOlPkRWFyEIUzTkNImcKALwsuLVFVFPmERdHQnDMDMPDc3WNwVHBy1ohKSfDjPonUZM1mNS/P5FOqlNWFinmjZm4TkHInnHwAgN3YmLZnvQXCUQICpDNaAYOAYtyPzR0/tNNNZVR375RbWIjUrxgvenHy2KNn3Jdc4dWl06W9pe1i99ZuukhEYcLP3lOj8VSOCKXBUukHj13CjhbjBUxKmIa6Of1Ycv+0+YIX9gX7If2HcPMbgxiRmkvCqzMqDoE6FZ0fWGOnZb+wGO5s+SQzu8gxKe10ja9pAShTPkBxhK8tcZQcD/3T2z4tm5ZZHyugQj+yw6UmHQIPXXWU0O9ex9BMjwr/5EFTxI4/Jfej/Ac2Tc6BPqQZD0tVMLMclrv1EtZxKUXjsEZ0b3O68nQ0XLoK+9ol96YbUitKjJYYnYRAmWH/NUCWiGaele3b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(451199015)(41300700001)(31686004)(6666004)(8676002)(66476007)(8936002)(66556008)(66946007)(36756003)(2616005)(2906002)(5660300002)(110136005)(316002)(26005)(6486002)(31696002)(86362001)(186003)(478600001)(6512007)(921005)(4744005)(6506007)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlU4N1J0MXJtWC9YVTk1dFhhcHhSeHczUitYVjhVVTluOTl4eE5pZ3VCdi9H?=
 =?utf-8?B?dXNMckVXSTNEby9QU1hWeSsyMlFVeUNITXNlb3hUZVFucHpvSWpUL2tqQzh1?=
 =?utf-8?B?TjJPeFg5ZVN3OE16NFhDRjYzK0VabkhQUmdyZTVaSWxjUnhibHlNeWoxQ21t?=
 =?utf-8?B?eTJsekhJNThtOTRvN1NJZHRMK01CZ1ZvcWpQaVRpd3BmS0tlL0xBQ1dyRnp6?=
 =?utf-8?B?OVZrZGF4OTNnQXM3ekRLcGptcHQ4U0RxWHlBUU1PeVJiMG9ma01jYVdEQzVE?=
 =?utf-8?B?T3JERmVCRWNadFlPbTdjWU9qQmkwTTY0SWV1VXFmZHloOFhXWks0bUFIeVRT?=
 =?utf-8?B?UVRjdXEwTG9zYUR0MlNUNE9hR1plRXc0RmljVXV2dUZLV0duV0c2VDIrcjZt?=
 =?utf-8?B?Y2k1L0Z6SFR1NU9uMWJFeDg4MVdyM2s2U2tXWmNra1p6VXlRc2hsMC9sSGlJ?=
 =?utf-8?B?ZVJzY1h0dU9xYnA1YWIrdi9HM0hLZllHaXRwT1hIYlpMbmE0d2JZbmhibEFk?=
 =?utf-8?B?YnI0TWk3eGFPWkZhYy81ZnJ5QU5PN2Z0VDFaVkFLUHVTTURsYjEwZTlZUVRj?=
 =?utf-8?B?ZE5pVWR3UXdIUDVQWm1IUTBndUJUbjhLQjZKRnR6QTE3RzNNdWdCcGk2NWIr?=
 =?utf-8?B?S2RCczdMb3ZFdUtiRVJqYXlyQ1V4QkUxQTJJRGJFV3c3bFpqaDBXbm9DQUVE?=
 =?utf-8?B?djZBVFhONU1QQTBmYlV5U0x6UUJNMXBDZDdCU0IzK2RkdGt0M0tCRkFZQlE0?=
 =?utf-8?B?RFpma3kvTzBOY0JhVUFaU2JQdTVHQVE3ZEppWU5Fcml2eUlCK1RFZ081Q2Ey?=
 =?utf-8?B?cllxMmlpNVZMZmRSaFlNTWVMdmRWUCsvTUd1WUl1aDhXSk5Ra3NhWmpVcWk4?=
 =?utf-8?B?ano0ZW9RQW5tN25oSEc2bUZiY2RCNmo3WkNVeS9YQnA1V214ZnlIK0lidVMv?=
 =?utf-8?B?M1QxK0c3UldFY0p2b3JveGJOVDlyYXpYTlNmQkpZQWNiVkxNWjN0bkJkU2gx?=
 =?utf-8?B?U1MybER4RGoveUVtSXFQVTZHcGRvek1PdDhtVExyMUF6bFdLc09XdGlYY25C?=
 =?utf-8?B?VzF4UWNJNE16Y1luWm81YXJzVmc4cnNLaEx4NTg2S09ETmhoeklRMklQakpP?=
 =?utf-8?B?WTJlSTl1NW5WbU8rMG11Y0xjVERmLzg1MTRPRmF6UHpSbnpwMUtaOE1PV0lw?=
 =?utf-8?B?dVcyYjB0RDJoVjZhVGxpQmJYTWtJd0NPZUVEbE5JL3pQQUxvL1hGLzBaYU4y?=
 =?utf-8?B?bDIrK25Xa01xN1V6ZmJyRDVqVGFhUmNsakd4eS9BeC9qaTNUQWJwSzZidTNi?=
 =?utf-8?B?R29NT2JzT1VaS05oc2ZWQURjaHVYNE54QmlnRjFzRWttM0hJYXF4YXF6SUJp?=
 =?utf-8?B?bUpNUGdDVnRSalVmNm9VTEZYanlzdzNVeVk5aHJ1bGl2Z3F6SHVmSUFRcTNm?=
 =?utf-8?B?ZkZRLzk4eko5bzlnSitUbUxuZVdzYkUvSkFGR0kyMjRqY1lBRWUxWldFWHZm?=
 =?utf-8?B?YnJxaVk5dVZDeTlqTm1wdEFQSGdaeWxveS9vQlk3bTAzendXa004T1lkZ3oz?=
 =?utf-8?B?S1RhM3Q3eU9tTlZHeHB5NVNReG8zNXhVWk43NFZZaVVPL2RiTmlQdGhzdTZP?=
 =?utf-8?B?TkNUaVQrNkx1bGpRajArUTNNeU1zeWZaRXFQRFRXaGtXTXpyOTVZaUwwbnN4?=
 =?utf-8?B?Um5NM3pydEdIYmJPYmhSa3pMVjRxeGdPdHc0ZExjdXlINUM1bFhIaWVhKytz?=
 =?utf-8?B?aUhZVkVUa05iWmZ3ZmdNR2k2aU9mbEx6ZXRNZmFyQStUQUpXbEs2dWNDSjla?=
 =?utf-8?B?Q0JJcjVTZUEwRVZGU2lhMHVNQitEZUFsdW5zL2RLNEp5cW8xOXo4V0RMSkZO?=
 =?utf-8?B?dUYrWEtFSkM5a1Q1MGRZNXliWjBUM1FXTzlhZ3lVL01JUEU0eHk4RmcyT0hE?=
 =?utf-8?B?K1BOdFZlRWc0azQzbTdETXRPc3ZQY2xEU3JxQWFvN1owR1dBbWdpSktvUUVj?=
 =?utf-8?B?TUxKSXRVcSs2dmdQU3lDTDJ1RzF3a1FOTGFQbzhWYWY5RkJpa0RGRjVPSUdB?=
 =?utf-8?B?eWtPYnlpd3lvMjZxWXhhY1hBM1NrYWdrRjlWck5tbVVzWk1tT3orb1RBWDdu?=
 =?utf-8?Q?x05k2gVAeDo6fV80AXSWTzSk0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 411f0393-f169-454c-dc1b-08dafa132c46
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 11:49:08.2854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F6sm+CLt7wqDHMiM7RKd8lr5XKgK457HMscVOP2pipFeUSYysaSP9+SwfQExkDBQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4229
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 19.01.23 um 11:26 schrieb Daniel Vetter:
> [SNIP]
> I guess next step is that people will use chatgpt to write the patches for
> these bugs.

To be honest I think that would result in quite some improvement in the 
average patch quality.

That guessing this AI does has at least a statistically proven chance to 
be correct.

Cheers,
Christian.
