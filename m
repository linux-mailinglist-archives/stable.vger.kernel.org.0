Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7027C6720F2
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 16:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbjARPRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 10:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbjARPQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 10:16:28 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2071.outbound.protection.outlook.com [40.107.105.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9448A4DE26;
        Wed, 18 Jan 2023 07:12:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UisT9C5n1f0ciDMw9mCCmJ9G1YVOSQ2eRnuZC1LM8CRQVeOFY8ln1t6QQTLrG9w37pRZ/z7oG79SaDMxMBBWilbOZ/96OJPm7e+kq+tOkevPYe8ovzlt2wDbNNkjOK+MS9dchBH9meW92COO0GlZ0mJE6K2q1HlTUYunRTaPd+3X8toc69tZTUAatvxDJmWmDk38eayieLW3uRyFStbJ97WZ16yFXs233q7tKim8HHq+rl/D9pekYUtmMl6hQExgC9/KhMRnPMduxOlvbfCY972QgCAxdVMfmpkuY8AIfS5JQcpb5wZ0UbLJPPquMi55W8YuoeKueoWTExUvOYvVNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EY4rgtE96ZQT/E0kBY4OIhkS/KVp7p6rmHI+KiiSNkU=;
 b=k1WOH6TP2KhiOX5XP30Mv4aMRP7s3j5kNRyxR5uy4ZMOVGGk9hTKxGJiFXMMv/6EUbivSzJIhUQBKvwRa68KKSjRxUuy1yTSEwbkmta+hhFUwnQ++Xieone7+IfichgSybq2R1ZHyCTMZVTD80c1BEMKgUdSm/tgcDdfeUjLUUx5LunCWs9U0NS+IeGWne6MgFARCU3PwdZ/uPat9SXA06Nnt1+tUAE8hFV2wT/B5X0EeDq5NMOjegKTLrRgSaqydpxGa3ukzH6ucjDKZcsVcm5QUtVyNEOKlRzfpaGbLlRg/GPDwEv3+2HszNwBqIUlGXpyR3pMWS5vAvhH36Il8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EY4rgtE96ZQT/E0kBY4OIhkS/KVp7p6rmHI+KiiSNkU=;
 b=oyhFCIW3yu/Nl7A6act7+1qIv51xOksyecvMUt0SQDgkxLRz3jBI06RZN6bIJpMFvO8s4+1USAmSM7TQR/+unkrPK+dbWDuv0Y37R8iwzOePf+3DfAPF+X7S1yeXV0z5X+HEkzk8uM2NI1hbf1CIKRdmdDWQnEh5fb/NrnnzCuSN/3CfRLRj27xlg+RCPLpgoML7kt6/GOAU8e4VS4JSOZYm95AMJLM35eMGctA43U1rr9MBRTsdffZwhkPuOru6+k3fC8OhEE+0b9UWPHTn3+mCU74f9vBv07TjHzLCbiNx/zuLefXlwyCOq8jGEsGHH3MTVvSIQvIz9vTolpWSyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR0402MB3395.eurprd04.prod.outlook.com
 (2603:10a6:208:1a::16) by DBBPR04MB7660.eurprd04.prod.outlook.com
 (2603:10a6:10:20f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 15:12:08 +0000
Received: from AM0PR0402MB3395.eurprd04.prod.outlook.com
 ([fe80::8f8e:a358:3bc6:48d1]) by AM0PR0402MB3395.eurprd04.prod.outlook.com
 ([fe80::8f8e:a358:3bc6:48d1%7]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 15:12:07 +0000
Message-ID: <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
Date:   Wed, 18 Jan 2023 16:12:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc:     david@redhat.com, mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org> <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
From:   Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0131.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::14) To AM0PR0402MB3395.eurprd04.prod.outlook.com
 (2603:10a6:208:1a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3395:EE_|DBBPR04MB7660:EE_
X-MS-Office365-Filtering-Correlation-Id: 4776f2f0-81b2-4cb1-e976-08daf9665d51
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EXxHPf+QV0ZspJpdEzGLyqSfGtED0gkbmCmw6V8HATr9MEnG1F1cFwmteaPZo4opi75Mo2MfPXA63Hv/cl/RDnUS2m/yMmz+OfCo0N0lkocmEsPUHlTKB4cav5+hiqq9b2j1YuKR4Zz8n+648lCwaQRdjv1fZwee1ZqV/aNY4dfyyX8lc9eNwg1a4Wu2tNxKFkumo6xOiJ6rKFpt2/VBwkZ1H8Jndq2vf99XPJWudfT9Kvda7ZtjKk9nm1O4s51BXngvsy5/zTwoXUues1MS0NzqPY+jBX99RywkUfEUs32asUka/8K/bkZ1QFO2Kkb8CnPSwGhQ6sNfyqWEVGxYweQJKlrM8mqkL8DX2M+W74LJpIkA3c6jnM6v/wFW8+ZiMk654UPeNzutwBvPAfb6NG57SBJpHkqqxwFL+Tr7nJtZ6NTZDP/EsXNRKiYzO2/HTnjrfZzf7qMFR4t9OvP2TBy34S3IxmHzLl+d1TWDa8g+3u3Quo4SNvEvWRisDO7AcDfd5OFgGgXyF5OgVhQCg+Hnabp4y0QI1arV9jhxIMN8SzVsePKUiTpXZs/V95Z0SaEspRnvJeZvKKjvFTCXqnWintBZfV6jp+ivjNsmFArsgH9iObPFmE83wvQBwcInM+IuOo72sRclh7+mY0tj7JkuTcPxUD85Ri6+/Q2GIMtZCqume8bqeGo15IRCkG8Jx0Ed1r5wDFIZA5M8Ltd/WyxDrpFMm7M3UUCR3XMsPJmp/pBVaIOONC6Dg0M7zBSx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3395.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199015)(66899015)(31686004)(44832011)(66946007)(2906002)(4001150100001)(66556008)(8936002)(5660300002)(66476007)(31696002)(38100700002)(6636002)(110136005)(53546011)(55236004)(316002)(6506007)(966005)(6486002)(86362001)(36756003)(478600001)(8676002)(4326008)(41300700001)(186003)(6512007)(83380400001)(26005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnpLQjk1U1RpZ09DamRCUHZqRVpUWEVRSUl5NXdEYzlUckRJVzNNdVpvY003?=
 =?utf-8?B?R0pOSUZNVWtmWS92aGs5RTV1YlV1RkU1TXlWSmFDUlV6UTROeHR5YzRlZDFC?=
 =?utf-8?B?b0tnSGk2bm5oU3AvRUY4RjhqeGZrcnI0UFoya1VLdHBKZkZXV1dkUXZlTnpi?=
 =?utf-8?B?YTNBNG1jWHR0aWg4Z0VMR1drME4wV1YzQ0pLTGhXcGNCYWhQUWZkTkYxYVJY?=
 =?utf-8?B?bm9EbFBrVkhNZGs5N2lwTDNxbXFIbW5SNEV0OWpRZGJxSUJQT1NJYzcxNTN0?=
 =?utf-8?B?bENQVU1wTk5hV3B0OXRRNTJMQndmNEc3WFRyZ3c0ckxEUlZqRktUNjhiRWcx?=
 =?utf-8?B?Zi84Y3hESGsxem9scXdZNVdKRHFsN05uMlN2N1hEOUdsOXJzUHNRbEhnTjVT?=
 =?utf-8?B?SEdPTU43OFA3MDZQWTV2T3hMZ2xYaDhQaDVLWUFZSEdzWEI1WGtweUJhTXdj?=
 =?utf-8?B?Lzl5RmtLbXdyVkR2RWQ3R0txVno2cXhyaHJCZThnOHNBR0ljV2dEQjA1QTBR?=
 =?utf-8?B?QmpRQ2MrZEs4aXVlSTdKek92T3NONFN5THYvUXBZWjVkWUd3M1UreVNaVDhO?=
 =?utf-8?B?T1pTRjljNWZmdzlOK1hvV2FhMGxpSUVHMzhoVkJtdXZnS01JcC9BUlNHeW8y?=
 =?utf-8?B?dGU1aWJyR1NXbGN1c0Y4NndQVE1ORjhVUmNGMDdtd1Z2dGVuVXlINnhZMll5?=
 =?utf-8?B?cVA2MWdOdjlxUzh4LyswZ1ZvQmF1VEU3TXQ3TzhYMnE3QUp6MmVkcnJuY2xR?=
 =?utf-8?B?LzdYcjBFdEZNd05kMWM3cy9hTVl3UEY3V3JmcXRhTmlIZkdzeU1qaFMzTzlF?=
 =?utf-8?B?endpVktBSWIvYjBBSXp4MnVLL2xzL2I0OWNZZkZzUnpyMVJKbjFWYlBoY2V0?=
 =?utf-8?B?UHRCYzFISm93Y203OFNXVnBvU3cwUHhKU0xTN25oaldoQXQrVndTT3JlV1RB?=
 =?utf-8?B?empUVU9LR0tHV29sSnRLRHc2TUQyQzBKY3hJMkh1NHkyZFY3TFhoUisyeHox?=
 =?utf-8?B?ZG92WURFbncvUGRubzNYaDNpUkJiUm03a3UrVWNWS3V0NDNtc1U4bEVVQnFR?=
 =?utf-8?B?Ym42SzEyQUUyNWdWbkcwRjVvNW02Uzc5N002MURkbUs1RmptWThRbElLeW9D?=
 =?utf-8?B?MEFTRnJPOVlTSHpXTnFvaTZRVmw3d1lIcGJMZ0p5ZFRsQlNIRTZNcFdtdVVY?=
 =?utf-8?B?U2hDb056cmJJRU9Hc1M3YVN4eWhzdHpNNXIxQTJPY3pqaEpPRXB3VmM1UDZ3?=
 =?utf-8?B?cm80QjVqVUwzSUx0Z0M1dEN6MU8yWnRTVzdWWk5Od0lGSW51aTM4SmlYWHhz?=
 =?utf-8?B?WE54Wkx5RXZ6YnFjZDJacWV3RVFiZkIxK0sxaHAwUEVZd0FwcnJWUzFrMzM4?=
 =?utf-8?B?ZklKUzZOWUpzWlNMdXNtUWtvb2ZBYU90RmY3clFsN0dsM1JrMXJMRXZUNlVB?=
 =?utf-8?B?SS84ZWp5YmRwSm1iMzJVWG51UVI1czcrVDFVdk5Rem55d1U0QklTdXlaOHN3?=
 =?utf-8?B?TGVDZnpkQnI4MFUrSm9DKytud2lteGlFSExocjkzUmlVWHU5YUhkUWJDdm9q?=
 =?utf-8?B?dkFycnhmY1RZaDFUZk9vZTNPdmhYY0U2QlIreXBoM21UbE9NVXpka0x6VmEw?=
 =?utf-8?B?UjVwVTE4UXF2N3VvRTRnb0pVRm1Mc1I2M0d3eHl0aTFMdDhhc3hUVjZvTnJi?=
 =?utf-8?B?QjV4eWNOTFVHWldIaHo0eHdldU96TlpxbjdxenRVa282bExxaGdna01hUGpL?=
 =?utf-8?B?VmRPaytuL3hlVWk3NWl4cXpoSlY4NytzQTd3bWd3N3I0aTlpeXhoN2oyTG5O?=
 =?utf-8?B?ZEVzYmpZcWFZNks0cUMrYWErR01LWmxNdDNWOUN1QzRWazBVKzE3b2Y5dER4?=
 =?utf-8?B?N1UwZXdHYm42QVROZ282WlhFVCtyZFA4MTZjV09LNk1tZi9TK003ZjZSK2xD?=
 =?utf-8?B?TGV2MXVnRjRLTTBCYVkvaWlWZGFvYXlYMjVYYm44alM3Y1RsY0NBQURLQncy?=
 =?utf-8?B?d2Fsdzh0UVIrbUo3OWJPalJrWE5YRjBhN3Nkdk9uTWZyQ2VkakZvTHlDY2U5?=
 =?utf-8?B?VjV5NjhJVURNZ0txOW5mOVJsVTl4TktqY0VjR1ZmRWQxeWkxUWtoRDJmRUJO?=
 =?utf-8?Q?R4xUudQtMhkS64H7/umKVimoR?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4776f2f0-81b2-4cb1-e976-08daf9665d51
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3395.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 15:12:07.6475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VmN1PHm0hasbx7CBu1b0UNovTDrZw2s+U45lHctgCnqmKSNKAXDw5uLrzbNsiU8AIAoLoBiu6zPu0v5FmNk5Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7660
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/18/23 01:04, Luis Chamberlain wrote:
> On Tue, Dec 13, 2022 at 11:17:42AM +0100, Petr Mladek wrote:
>> On Mon 2022-12-12 21:09:19, Luis Chamberlain wrote:
>>> 3) *Fixing* a kernel regression by adding new expected API for testing
>>> against -EBUSY seems not ideal.
>>
>> IMHO, the right solution is to fix the subsystems so that they send
>> only one uevent.
> 
> Makes sense, but that can take time and some folks are stuck on old kernels
> and perhaps porting fixes for this on subsystems may take time to land
> to some enterprisy kernels. And then there is also systemd that issues
> the requests too, at least that was reflected in commit 6e6de3dee51a
> ("kernel/module.c: Only return -EEXIST for modules that have finished loading")
> that commit claims it was systemd issueing the requests which I mean to
> interpret finit_module(), not calling modprobe.
> 
> The rationale for making a regression fix with a new userspace return value
> is fair given the old fix made things even much worse the point some kernel
> boots would fail. So the rationale to suggest we *must* short-cut
> parallel loads as effectively as possible seems sensible *iff* that
> could not make things worse too but sadly I've found an isssue
> proactively with this fix, or at least that this issue is also not fixed:
> 
> ./tools/testing/selftests/kmod/kmod.sh -t 0006
> Tue Jan 17 23:18:13 UTC 2023
> Running test: kmod_test_0006 - run #0
> kmod_test_0006: OK! - loading kmod test
> kmod_test_0006: FAIL, test expects SUCCESS (0) - got -EINVAL (-22)
> ----------------------------------------------------
> Custom trigger configuration for: test_kmod0
> Number of threads:      50
> Test_case:      TEST_KMOD_FS_TYPE (2)
> driver: test_module
> fs:     xfs
> ----------------------------------------------------
> Test completed
> 
> When can multiple get_fs_type() calls be issued on a system? When
> mounting a large number of filesystems. Sadly though this issue seems
> to have gone unnoticed for a while now. Even reverting commit
> 6e6de3dee51a doesn't fix it, and I've run into issues with trying
> to bisect, first due to missing Kees' patch which fixes a compiler
> failure on older kernel [0] and now I'm seeing this while trying to
> build v5.1:
> 
> ld: arch/x86/boot/compressed/pgtable_64.o:(.bss+0x0): multiple definition of `__force_order';
> arch/x86/boot/compressed/kaslr_64.o:(.bss+0x0): first defined here
> ld: warning: arch/x86/boot/compressed/efi_thunk_64.o: missing .note.GNU-stack section implies executable stack
> ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-only section `.head.text'
> ld: warning: arch/x86/boot/compressed/vmlinux has a LOAD segment with RWX permissions
> ld: warning: creating DT_TEXTREL in a PIE
> make[2]: *** [arch/x86/boot/compressed/Makefile:118: arch/x86/boot/compressed/vmlinux] Error 1
> make[1]: *** [arch/x86/boot/Makefile:112: arch/x86/boot/compressed/vmlinux] Error 2
> make: *** [arch/x86/Makefile:283: bzImage] Error 2
> 
> [0] http://lore.kernel.org/lkml/20220213182443.4037039-1-keescook@chromium.org
> 
> But we should try to bisect to see what cauased the above kmod test 0006
> to start failing.

It is not clear to me from your description if the observed failure of
kmod_test_0006 is related to the fix in this thread.

The problem was not possible for me to reproduce on my system. My test was on
an 8-CPU x86_64 machine using v6.2-rc4 with "defconfig + kvm_guest.config +
tools/testing/selftests/kmod/config".

Could you perhaps trace the test to determine where the EINVAL value comes
from?

>> The question is how the module loader would deal with "broken"
>> subsystems. Petr Pavlu, please, fixme. I think that there are
>> more subsystems doing this ugly thing.
>>
>> I personally thing that returning -EBUSY is better than serializing
>> all the loads. It makes eventual problem easier to reproduce and fix.
> 
> I agree with this assessment, however given the multiple get_fs_type()
> calls as an example, I am not sure if there are other areas which rely on the
> old busy-wait mechanism.
> 
> *If* we knew this issue was not so common I'd go so far as to say we
> should pr_warn_once() on failure, but at this point in time I think it'd
> be pretty chatty.
> 
> I don't yet have confidence that the new fast track to -EXIST or -EBUSY may
> not create regressions, so the below I think would be too chatty. If it
> wasn't true, I'd say we should keep record of these uses so we fix the
> callers.

A similar fast track logic was present prior to 6e6de3dee51a. The fix in this
thread doesn't bring a completely new behavior but rather restores the
previous one. The fix should have only two differences: a window when parallel
loads are detected is extended, the return code is -EBUSY instead of -EEXIST.

> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index d3be89de706d..d1ad0b510cb8 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -2589,13 +2589,6 @@ static int add_unformed_module(struct module *mod)
>  					      true);
>  		}
>  
> -		/*
> -		 * We are here only when the same module was being loaded. Do
> -		 * not try to load it again right now. It prevents long delays
> -		 * caused by serialized module load failures. It might happen
> -		 * when more devices of the same type trigger load of
> -		 * a particular module.
> -		 */
>  		if (old && old->state == MODULE_STATE_LIVE)
>  			err = -EEXIST;
>  		else
> @@ -2610,6 +2603,15 @@ static int add_unformed_module(struct module *mod)
>  out:
>  	mutex_unlock(&module_mutex);
>  out_unlocked:
> +	/*
> +	 * We get an error here only when there is an attempt to load the
> +	 * same module. Subsystems should strive to only issue one request
> +	 * for a needed module. Multiple requests might happen when more devices
> +	 * of the same type trigger load of a particular module.
> +	 */
> +	if (err)
> +		pr_warn_once("%: dropping duplicate module request, err: %d\n",
> +			     mod->name, err);
>  	return err;
>  }

I'm not sure if this would be the right thing to do.

What I think would be good to fix is the pattern utilized by some cpufreq (and
edac) modules. It is a combination of them being loaded per-CPU and using
a cooperative pattern to allow only one module of each such type on the
system. They can be viewed more as a whole-platform drivers that should be
attempted to be loaded only once. It is still on my todo list to post a patch
to cpufreq maintainers to start a discussion on this.

Another consideration on the kernel side could be to try grouping other
currently per-CPU loaded modules.

However, in general, a system can have many hardware pieces of the same type
and it looks correct to me that each is individually exposed in sysfs and via
uevents with their set of needed modules.

I would say that if this turns out to be a further issue in practice, udevd
could optimize its process and avoid same-module loads when it is bringing up
to life multiple devices.

Thanks,
Petr

