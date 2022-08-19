Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FB25995C2
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 09:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242670AbiHSHIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 03:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243562AbiHSHIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 03:08:23 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7CF2CC88;
        Fri, 19 Aug 2022 00:08:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EA9bUOOTmdb5/yHD6+qkTeiwtK1o8yFoTA0dld/py31z4U6l1rFmAz7bfXt6iKye2Hq3uETmztQXN3uXt4RpmRtNqBOpZ7lpRyt3e1jQFGeE09z8QsZJWLUuz7DAavxkmjrFyqpxuLpjK92D7VRB/aVsRnGrQQSERTuxO42ENA+fvUB1LxRMtChbqc50bDJFrpdH5dnbKM6D6vTXu8ih4nmaqYT8VMgsFZ1tVudJWqIDhCaskf2hxoJ+MdDMsKq7pVGD8EpGQDS5a1oe4z5qtdC8M3+niGlEX/B4TGqo+3mXpbx9w9MW++/zdzo/+2T2hXxmuqFub0pMuxlkMjECVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dQGh5JRPBQabco0LRtz74NH6Q+/ogDdoH0vswusc+Uk=;
 b=LzDF+jNKfqhWsglTGFRe/T8QHlTzq8oC8i9lEyQH8fSyUGrfIDJsl0FKrEUn7COdFpwodcWGzCfDsqTrq59oeMEdMUeqOEzcOdK4NUPquVY2y7VwQl+AeqO9X8qZfuryJiztgsCl8u3JFcZfJ9hqL4eJ+d1OOqAl22sbas+/OI0P/7Np2iD9GyLVO3IOpAuyMvevZoOrX2iJjtrF3/NGFpGZCFBJpFzCp6dz6sJD09AWqOZ2RloiWDs+W1OSczRB3XCWjUq4yi+9eG5MVMaB38VCeeEAQ+Apl8DDMBn0DeOip69bVrCVZn7N/Oblncu8BsAdGHKp5ZX4ZWpcD9EdPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQGh5JRPBQabco0LRtz74NH6Q+/ogDdoH0vswusc+Uk=;
 b=1J55MlX2zd2Hflr7yDclzLPTgbpcxl9nfoeL/zf1I+1VUZ28AROk/SI7TwKEgoOLzFEvOeuPFVOrAdvz7Q5s9FDYZgLjzhrkXkkJEd7GH4KEzx8EEf/FlGJ0yZcTM5IX5vKWEYgQfj+KzJrXwiwl6pp2Bv9eTpoZ//0qspK7rOfeeprPUsYGCtjennczlUNO43E7jQ7uvGp98urDglcji2HWQ4IRKM6bHrYrHDL3Z/jX7AM/rNn0wryhqCP5s0PsDlAdLN5pA7cty/LTA27f7i7HCl3Cyg6iCIuRRdmSQByp1M+uDRAr0iU0uEiuPp1qOBcjpI18NR1kR2CR1UcPvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS8PR04MB8465.eurprd04.prod.outlook.com (2603:10a6:20b:348::19)
 by DBBPR04MB7498.eurprd04.prod.outlook.com (2603:10a6:10:20b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 19 Aug
 2022 07:08:17 +0000
Received: from AS8PR04MB8465.eurprd04.prod.outlook.com
 ([fe80::c4b3:5f3a:8bf5:f6e9]) by AS8PR04MB8465.eurprd04.prod.outlook.com
 ([fe80::c4b3:5f3a:8bf5:f6e9%9]) with mapi id 15.20.5546.018; Fri, 19 Aug 2022
 07:08:17 +0000
Message-ID: <ee7c8476-7c93-100d-a0ff-441b71f61e6a@suse.com>
Date:   Fri, 19 Aug 2022 15:08:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH STABLE 5.19 0/2] btrfs: raid56: backports to reduce
 corruption
Content-Language: en-US
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
References: <cover.1660891713.git.wqu@suse.com>
In-Reply-To: <cover.1660891713.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::29) To AS8PR04MB8465.eurprd04.prod.outlook.com
 (2603:10a6:20b:348::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 910361c0-6e89-4292-19af-08da81b19707
X-MS-TrafficTypeDiagnostic: DBBPR04MB7498:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0rDCBFprO/xA3l4nqv9dA7PFXCwAKNHcU9e6WfBNIcHtGeVruQzDiJgJ9zdYCDb06R5Bo71ehBfTeWA1TWuK7/dYjcOYu1ITXVsVEKIwSxOD9bajqj6MlgYzqTdTgefy1VuNtce0AA7Cu1/lhGbHEhN2nvxqkOgN6a/pwrqH9rG/z4fRgjH9FKce6kKxT6T/R7ln2uDiu7xOWwYeTNxv4QEQ8mXNems6YNOXBnG0OWJxJGcw0K1RJywWo4naeWVOOGl7luUkVqc6FEjwiP1TgLuKRpO1qlLHuxNJztgy+5JH1hMxumP/u8swDMnlswRdDgEjfzcPWsdK3rGBNulSfc9CPMPGsNUZO88QoYqYjKBO8EDwzjZH01lgCdHx3vSjXm9SEiWmnNVSpz9gB3QfmyHxqvgJmexttzTRkovXeQagPon9+DNtANGsDuAjopuKgt5U85vwaF63f54Ec9rMT6yf+Mfk7+ObnGU2vtc6U5v0xVQwU3iL0S2emfDfIpvVm3/fcvvB6haUa1agaU8vD6s0bhn8xr9dXALocBuIgrKq4bps40oN5LSvfyGnWqYDjBq1r4sfRi2xCxccep+ncP8MpuHZfQSwynUEJgtS2qKmmz7lVkQ+621vzBYfGGHZ3xDG77Mq+kWuNz0dE6V1LW0NTW9Oc6TCnkkRO0uEhYZxbw8xbYYDAcilQ/EsI7UC9tXbW2EpSj+g4xHy2NH7fEjlY8O1Mi+uy9vpziaWjnWCwKwChjyhfyDiITFo08q4xK1D6COZm5lON6IxG8XKZY0COSucO894B5JJ7K0UbKMk9IrhPMboC6sJ2he9+W5cFfjZBB9eAVK1srJYtxBP5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8465.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(376002)(39860400002)(346002)(396003)(2616005)(38100700002)(186003)(83380400001)(5660300002)(8936002)(450100002)(66946007)(66556008)(66476007)(4326008)(2906002)(41300700001)(478600001)(8676002)(6512007)(6506007)(107886003)(53546011)(6486002)(6666004)(316002)(31686004)(31696002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zi90SkVMVzZHNmVzd1Vvd0RKSUw1YmlySGMxblI3K3hUYjN4R1k3Si9mZ0Rh?=
 =?utf-8?B?UUQveGpJVHJxTXlPSG12dU83cTVPaFVDVm5aQ1FQNVgrZEJ2cXIxSnZNZmNz?=
 =?utf-8?B?d1VWQUhhSDBDd3JzNUFPdE1MdEIvTTYxY2V2WGk3dzRwcUUwNW1xSkMzaHZP?=
 =?utf-8?B?YUZZUlg0T3h4OWtrMUNBTmdSNE8wT0NmNmU3cTJobE1JR0xPdW5hUGEwZFU3?=
 =?utf-8?B?bHgrVEdpMm1UNi8wcDlrN2NLc2lRRUV2QldxWnFwMXMxdEVRNW1CYWpCdzZp?=
 =?utf-8?B?eUUwVnhPVkJVbDNqamZ0RmJpdXYxUU9UUnBnWDlwZUMvSEpxeWw0d3lyME1F?=
 =?utf-8?B?T3VMaEQyb3pMbks1Ky96QjNjNU1LbTdzRnRYSmNPY25BWkRpTjVhOThWRzZs?=
 =?utf-8?B?NnRXU2VBcVhYUnE5bFN5RjZrbVNEVWROcUM2cG5mbDNzMEdiaUozMUdoZG9Y?=
 =?utf-8?B?OWh5Q0FJZUkyekVZSWdnSkhWNklKY1FYWXozTkkrTmNjT1c1ZlBwNlM1QTFh?=
 =?utf-8?B?WEtSbDhlczZ4ZWlGSGJkeUhmQXZ3MklYakVKSXhRQzVWNi8zMjZZTHUzeU4r?=
 =?utf-8?B?Q29nK1Fhc3BYV2lhbGVEM3k5QW1RYTZMRTdEMkNXeVFmOE04WnA2OUtEWnBE?=
 =?utf-8?B?dkFaUlRsN08vNU0xendxRFlXblRKWUVFcHFrSGZ6eUJpajlsNjhkWnVFT3Mx?=
 =?utf-8?B?Q2lPQXNUbXZKUTBpYnFUdmo1RU52bHBISEsyOWx0eFM3MzZ6RHk3bnVxNitU?=
 =?utf-8?B?S2FQT3ZXWmM4NWJ5cisrbEFHdEVXeU83SmFYNWVXczFqb0VHL3puRjI5L3BZ?=
 =?utf-8?B?Y0tIMy8wazMyM2NlN0tOY2hkeG5YSVljTHhWVTBxRDQwZytHUUxCRERYMTU1?=
 =?utf-8?B?MW1xdFRtYlZQYWpSQmpCZU03dnh0dWJIZkRMN1NHWmFJZGUrMlIxd2ZPeGtS?=
 =?utf-8?B?NER5b1kzNTFuUk0wVzRwWENSV1NRQzdwYytCRlprUzlrQ3graGphYmZJR0hV?=
 =?utf-8?B?ekNEZGgzS1g4ZS9rM29UcVZRUjNsTFRCd2ZBL2lOdnpnQzRkQVNGT0FSUVFG?=
 =?utf-8?B?MU5ub0h6ZnE0WE0xM2Ria21Ea0NSNzlRMmoybDdTVGp6THlMSUFtVkdvU2o3?=
 =?utf-8?B?UXFvQzRDb0RoTElncGhyRlBvMmRLd2M5WTdaR0lmaUw3VkVTc0x4WkxReUpr?=
 =?utf-8?B?d3M5ZXd2S0Y0dExjRlhtZ05sNGs0WDVPQXNXQ0hqOGxOMWpDZk1ZQloyN3RM?=
 =?utf-8?B?dldRZDBBQ0lNTml4NnlzMm96RTdwMVFvdnZpbmh5b2tCdjNpYWxraWE2QmNt?=
 =?utf-8?B?SlMzQ1hoeXNIbk9aNFpEZ0FkTjdMSlowbXFXSDBFV0lENzd2elI4aVplQVlF?=
 =?utf-8?B?QVdUeFg0M2NDOFRZZWF3UkEvSTdweWlSdnJrMjdPcVRWUGFpSkdtWXJJbWt4?=
 =?utf-8?B?TGNnTlZIa0UvdU9TYTNnZVdHeE0zQy9SdGdQZFhicEFaU25zUzM3US9xWXJw?=
 =?utf-8?B?aTBUZGZYcmxCTXVYbk9FM3owVmM3Q0JLeElQa2s4THdXNDdibGpGMFk3UHlP?=
 =?utf-8?B?VWcxUXB6Q2pjbEltTm5WbkdhZ2hPcDVHd2Z3UVU3dGZzMXBmdUdKMmFndGpk?=
 =?utf-8?B?cXlSRklWR0FyTjVQNVNmU2tBc1F2ZWtITlNhdEZLeS93SE1RRko1RldiQ3Uy?=
 =?utf-8?B?SU0xM3UwaXBpZS9Lckl0N1Q1RlF3RU5uSDEwdG1YeXVsZzA2U3hXWUliNHNx?=
 =?utf-8?B?OFVaK0wrNW1aWS83WTNJNm9lK1NMV1dXZDczaDhVMjlybzd1S09GRHZiMzVE?=
 =?utf-8?B?YTdwZzlCK2pnT0NSZjVvYXI4aGVPbTlodEZuV3JBTjU5UUYxN0tBUEtPa3A4?=
 =?utf-8?B?T25iRWxxSEZBYzdTUjdOU2JVVXdnWUZ6S2ZBd3JmYTFGcnZUR2M5aU5KR3Zy?=
 =?utf-8?B?L3QrN0tzV2YybUE1NjllcWg5S2Y4MGs5ZW4rRkl3QldPVXc2bS93NkhXSk5O?=
 =?utf-8?B?UEI1VUFiMUxPUTh4L2F6MUVxdXpCNmVPQ1l5cWd5QllZMXB4cVpTWUxrTHhy?=
 =?utf-8?B?Q2lBSVYwdmdxYnErb0dwK3VLUCtQcGVQU0xObTVldFRjM0Q0ZERlcVc5c3Fk?=
 =?utf-8?B?NU9RenpkTEdQUVNCQmpnUXJvTmpObW1UMzJBUHBOOENhR0VrYzdrRGtpRmtN?=
 =?utf-8?Q?103NS+doNzAfRWBG9l4kY8g=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 910361c0-6e89-4292-19af-08da81b19707
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8465.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 07:08:17.1866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OaW/VQNsQVNdYpCdhSKAhWRLF2DI4b1Ja17FDkHwePKt0JuriCPN71YvbxTfaznY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7498
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

BTW, since I have to re-run all the tests for every stable branch, for 
the stable branches and 5.18.x backports may be delayed a little.

In that case, I guess I should submit backports in the most recent 
stable branches first?

Thanks,
Qu

On 2022/8/19 15:01, Qu Wenruo wrote:
> This backport is going to address the following possible corruption for
> btrfs RAID56:
> 
> - RMW always writes the full P/Q stripe
>    This happens even only some vertical stripes are dirty.
> 
>    If some data sectors are corrupted in the clean vertical stripes,
>    then such unnecessary P/Q updates will wipe the chance or recovery,
>    as the P/Q will be calculated using corrupted data.
> 
>    This will be addressed by the first backport patch.
> 
> - Don't trust any cached sector when doing recovery
>    Although above patch will avoid unnecessary P/Q writes, the full P/Q
>    stripe will still be updated in the in-memory only RAID56 cache.
> 
>    To properly recovery data stripes, we should not trust any cached
>    sector, and always read data from disk, which will avoid corrupted
>    P/Q sectors.
> 
>    This will be addressed by the second backport patch.
> 
> This would make some previously always-fail test cases, like btrfs/125,
> to pass, and end users have a lower chance to corrupt their RAID56 data.
> 
> Since this is a data corruption related fix, these backport patches are
> needed for all stable branches.
> 
> Unfortunately due to the new cleanups in v6.0-rc, these backport patches
> have quite some conflicts (even for 5.19), and have to be manually resolved.
> Almost every stable branch will need their own backports.
> 
> Acked-by: David Sterba <dsterba@suse.com>
> 
> Qu Wenruo (2):
>    btrfs: only write the sectors in the vertical stripe which has data
>      stripes
>    btrfs: raid56: don't trust any cached sector in
>      __raid56_parity_recover()
> 
>   fs/btrfs/raid56.c | 68 ++++++++++++++++++++++++++++++++++++++---------
>   1 file changed, 55 insertions(+), 13 deletions(-)
> 
