Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C41673857
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 13:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjASM1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 07:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjASM04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 07:26:56 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2040.outbound.protection.outlook.com [40.107.8.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516A648A1C;
        Thu, 19 Jan 2023 04:26:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RKC+REdhoRhZkrZUVcZr+lNp+GII810IUXHgSql55YcuPbu5zUp0Qm2Pn6qBey7Qjj7flNhi01ZmV30d6OER5ClKQ0br+6QLi2W8UYlLpFlTwqO3jASNBndRIOI6VFn92xHPProx9hrmHOvgB/Mpppxeo0qdd0FUm6yp+cEaN/9Lb+lRWxugHnyHacqgZ0FvDxMSMR76sU6Ww1/sRFg1HXU/sf/Yp3Dsb/nlO+eK81LE4S5zKTnwCGGUNo6+XxnZVTVVp5n71VDXWv22h7WPuyT6K74YaxNNi9HnysDAmHOLH+2ZHZaCs43RWKarhADNCzU4KN/oNC2zXTHX8vgJew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WqsjS++UKenO5cZF5ZNBkMX+PMwSA8iDhgaymMj3fdA=;
 b=d6NvcrAHHmiSX1sauO1PkguphEM1XVuC9Y5jodskZXok1sOp0wRztl1yHLuZfcM/qw7tkWoT9VfFxgnXnl5QuSLN3zldgrJmuRasVAKPMdlRvJ50iHs62kcsMF8rQcYV3YGVsp3XYKkfcTmtyXHESZp7gkO1qGvs2U5hwgLn+tBPbTFXzBG0E/fuDJMUYWEUfrDkBFaiu9Kp0JXv0ZUrOYbMNmSsHm795WcVqRYRGa6oz8576dOyboh7FgkRHFmawUxMzWSBdU0htIqBGo5YP+ajBzQ/8ip+l5pVsuITtasAhj3Kk+T2NT1qof4vv5kgHBI3K01/4jDRM3DZvRFX9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqsjS++UKenO5cZF5ZNBkMX+PMwSA8iDhgaymMj3fdA=;
 b=s9wNEm33GcdPGUR7p/J3N41ai7y20TtHwBcr++5az+NDPkk4T0iTEuxKf5l6jC1RBZwRFYVNY4tWK8XLSNc2fUaV2hynvABULASdX45dCQVFroYkLLJYLdzeINF9g1qvn90lOLCOiml2U63tex7aUkibGO0Q3yLRvPK+Wz4h47RXq5kL8QuGyjFLfGcWgIiO7RNhcZcp+rcU9fgal1UD4tIiMCnKH7voHCnZcOeG51Y331XeWCi/VW+AfJrdCqPTA5LPtVrrljDm9oLrt12N7S5HU0DmIcrg5JDeUhm8u8oNzUGQVvJ9/hLhY2qMZ7gf1WG322HWzjZ+zzWIJ/qC2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR0402MB3395.eurprd04.prod.outlook.com
 (2603:10a6:208:1a::16) by PAXPR04MB8944.eurprd04.prod.outlook.com
 (2603:10a6:102:20f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 12:26:51 +0000
Received: from AM0PR0402MB3395.eurprd04.prod.outlook.com
 ([fe80::8f8e:a358:3bc6:48d1]) by AM0PR0402MB3395.eurprd04.prod.outlook.com
 ([fe80::8f8e:a358:3bc6:48d1%7]) with mapi id 15.20.6002.013; Thu, 19 Jan 2023
 12:26:51 +0000
Message-ID: <34fc4221-bb17-ab42-282c-e82f344c8a7c@suse.com>
Date:   Thu, 19 Jan 2023 13:26:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Petr Mladek <pmladek@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org> <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
 <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
 <Y8g9lTBnCgB7g08/@bombadil.infradead.org>
From:   Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <Y8g9lTBnCgB7g08/@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0015.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::25)
 To AM0PR0402MB3395.eurprd04.prod.outlook.com (2603:10a6:208:1a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3395:EE_|PAXPR04MB8944:EE_
X-MS-Office365-Filtering-Correlation-Id: cbb9ceb4-c3dc-45f3-dc4a-08dafa18708d
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QPp0coCP6EQq0CkKel/WZnITkFupvQFgDS2t6E+db5t+GwDNJzgyFO45nBiwtx1l1VW/9nHwsK/IJR9C5TkqnmAu2eQzfnDlphCJeBUE7qOsFpEk7iqW06iJmpC5eN4OBzjfETQHCnU3fF/fGEkXQLcSUXn4j880C0iB0AX83RBRdhVjTToU5jL6nIg+PCTojT1HVa1moh+LyXkTb+KdmLx4v5EFF8/G0LHCp652RsynYVkMG+k2kkoJ3UXPIp0SshsUs5wOfC415GQl5GGYnJeJtPQLlfvsv3CRQiFnFwibIKVJo39GBoeB7tD4k9BH0DEZ0At8Q/vOBmtpi6ohnw7eqZ4FxgHrH7uJHoMZdpIqKSfvCPFlrPzWO/XGZB5KQ/54pr0If/2t7SAV0/34D5nDogWoOIdtFAZaaogMyEiIuQDn4YeuAo8MVCQd/kpfoU8V+J2nm49e9K92S4H7b3nulbvKSQpK0YEqpTJ7DDDjK0M0U0O4R5i+xmcm3LpkqSxodyWXkjvVwO7EGlleSc/w9zCyfenG2rghcRecbP1Ht7KILGrXsjxYWBEmYA9sz1YuhS8/bDZd3xe/U2ejZNFp6GIiWDd4I9DqqcqwH0uHo7on6lWzt7evWF6lmH06xX0qG/AMqRBnNjoUdF+YvHoMlqgFe5WHJyAp/JQVscJgf4qRatUUmsvw+uTl6gstSBYhXoaCiNK3/uR0qMo4t1klfGk6+o19W7/Y6u1GQZ0HYj8ciDO+uY+w7dNL1WqE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3395.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199015)(31686004)(2906002)(31696002)(38100700002)(36756003)(2616005)(54906003)(316002)(86362001)(44832011)(83380400001)(41300700001)(5660300002)(6916009)(66556008)(4326008)(66946007)(8676002)(66476007)(53546011)(966005)(55236004)(6506007)(6486002)(6666004)(8936002)(26005)(186003)(6512007)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzZZT0RyUklDWHMwbkVDWkZrRlNqa3JRcktZZUlHQy9sc2hWejc3TVdzVXpD?=
 =?utf-8?B?SS9ndytYakpKY2htaXl5cG91YUhYeXpNZTk1bGlhUmp1MkNZSitGWUF5azhX?=
 =?utf-8?B?OGdUYndsSDJyejZkN0Y3SXZQZVduT0g3YzhnemVMckg4azllV012R3JGNk53?=
 =?utf-8?B?VWp5cmlGZ1BHRG5LbmowYWI0SXhsU2t2cnNsdTJXVCtXQTdDcnJUTm1aSUg3?=
 =?utf-8?B?a0E1cGhCU1p5UlNJY0MwRkhmSVlUckd4ZGFvSVRsaXdISGFBaU1YcU50aER2?=
 =?utf-8?B?dzlWV3BiUDhhMWZaQnZoVEhHQWFZb1UvbktBQXV4c0lPSDlSZ3cvSWpuc01O?=
 =?utf-8?B?ZkNMeGlWdmlLT2NyOU1UTzBwTDg5TUVZcGVXTWlydEo0Y0VzbHhveStXNlBW?=
 =?utf-8?B?ZERvY3JybnhBdkIzbmp0Y3V1WURzbEcwY2VxQnh6ZDl4Y2x1TGk3SEVpSkN3?=
 =?utf-8?B?ZkFRandWMGpHQjNqU1VQNHFuWWdaUGVIUCt4cXdPOHoyMnpmOXZGYzFRbS9z?=
 =?utf-8?B?L2ZFYm1aTGsrQXdXS1F2TEJUWWo5ZzczV2VCZGp6WGhWZVMvV3RlVXJ6eUgr?=
 =?utf-8?B?R0lEamNxS3ZBNmR5dU9Iam9oTUJZMGMzb1hVRUZHM0pUL2hKVDVRdWRoRnJS?=
 =?utf-8?B?YXRnbW0wQTBWdG1sMVFxcFBoU3UrQ3JodGVVYmlUR1VjZERBV2htYmU1U21k?=
 =?utf-8?B?SkMyTDRCRkJISWZGWkJYemZ0aHR5T2lTNnExQjdKSTJjeWdpQ25PSldOVlBa?=
 =?utf-8?B?dnhLT2dlNlpwU2dzREYyeWo2VkdtV24yTDZwRy9xL1FYU0ZaM1lNMzVFNldr?=
 =?utf-8?B?WU9PWkJZVm43YWVlUUxjMllyNzFKakxxZTVxemxiMjFhWUlzbThpamQrVSt2?=
 =?utf-8?B?dmV6aGh1T1VwbEhjTXZmUUFHanRhZVVCTlRZalJGNU0yQ3R2NUxmd05mTk8r?=
 =?utf-8?B?azFrSTdPei9SK2Y2OUhGMmNaNFV2M25iZzUzeVEyM2w3WjdWNE9QV2pTMjUv?=
 =?utf-8?B?ZmdoVkRhUlM2aDkyNnFDTlY5RXY1U2phd054bTh2YTdHSnZnYXlZWkovOW83?=
 =?utf-8?B?WkdxeG9xTzFKOHI3aytVZnRQU1lXb0VOVEZCNHFiaUs3bHR6dVNPdWNQQ21v?=
 =?utf-8?B?N01YaDBScnVOTGpENjhvSWJ0NDdyVXcwYm5YeVpTZzRJSHZhTVRON3JnTGh0?=
 =?utf-8?B?UUpSVkdncDgzZ3E5SEF3OTJDcFJPOVM2QW9uWXZsVC8zTG1RN244OWhVNytB?=
 =?utf-8?B?a1JVTDJtaFp2b3IvNE9MalE0VS91SWZzTWRJQkhna0VSTDdXOWRrRHZBaVhX?=
 =?utf-8?B?b2hvMkpNTC9EcFhPY0t4OXBuWjc4QlBwdG5kZ3F6WmFCY1I3Yy9mUCtKMjlp?=
 =?utf-8?B?ZkFYSmNmWUhHOW5pcVBJbjR2WmtoS2tRYTR3dlZmUzdXOWdkTlZ3R2Zwczdz?=
 =?utf-8?B?RGc5Z2Z2SGRreVZSMVFndHgrdEFJWmx2L3plZjRzbHFVSjl1WjdxcTJwaXJS?=
 =?utf-8?B?WmhFS3hqbkFhUFZsVG95T2t1QXBNbTJSVlYrQmRtUWlNZEhaaHJsNEFrRlow?=
 =?utf-8?B?cXdqQ3FqdE11dU9VNjhGVnRMODU0VDFRVHNVTFB4empRejZWSkJNRmJEa1Ez?=
 =?utf-8?B?NFBaOU1QN1FReHpNb3FxQnJidkZXSXRiRHRValdlTE1SWkJRZlVFUU4xM3po?=
 =?utf-8?B?VmVKdDJyVTRWU2FKQ3RhS3Y5K1k2OSt0bTlDQ2hLaEtGZ25ob0V1SEdIN003?=
 =?utf-8?B?eU5aOW12bW5ESFJ3WjR2bzRac2VRQTZPSU9TYkRsbFg4NFQrR2FFZ2lRbi9X?=
 =?utf-8?B?LzA3UEJuM1doWlZiM2ZUbU84KzdCdlZJY1hoekdxaXZWdEdkU2oxc0xUYTE5?=
 =?utf-8?B?aWdHakVrOTVlaTQrZTdYeG9GTFBtaEVjcXQwUGtjblpGZmJVOUlOZUxOWE9q?=
 =?utf-8?B?ank1a28wS0NtaFB3WFQ2V2dQUFdaNHZSdEMxZ0Foa1J3RjFKTXlETlhYTWJL?=
 =?utf-8?B?SXBqUWFuOTQ3dytQR2tDd3pUV1pwKzJUK0Q1dElkQWZCWjZqTldSRWJRM055?=
 =?utf-8?B?a001dzIyZUh0dXEzN0RVN3NZQ0NEY2VjZDhPWWNSZTZqaUZCUTdsV2VpQ0pv?=
 =?utf-8?Q?M8AatqZ4Mz5KkfhWLWNR2otbu?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb9ceb4-c3dc-45f3-dc4a-08dafa18708d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3395.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 12:26:50.8818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uyx7JFuWrdvLGMLg01sHgBunVlgqDJPXZ7qGIwvZNqhAerRwDUNHY8sTQWEd7pJUBt6dEWpfiuXui749LQawBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8944
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/18/23 19:42, Luis Chamberlain wrote:
> On Wed, Jan 18, 2023 at 04:12:05PM +0100, Petr Pavlu wrote:
>> On 1/18/23 01:04, Luis Chamberlain wrote:
>>> The rationale for making a regression fix with a new userspace return value
>>> is fair given the old fix made things even much worse the point some kernel
>>> boots would fail. So the rationale to suggest we *must* short-cut
>>> parallel loads as effectively as possible seems sensible *iff* that
>>> could not make things worse too but sadly I've found an isssue
>>> proactively with this fix, or at least that this issue is also not fixed:
>>>
>>> ./tools/testing/selftests/kmod/kmod.sh -t 0006
>>> Tue Jan 17 23:18:13 UTC 2023
>>> Running test: kmod_test_0006 - run #0
>>> kmod_test_0006: OK! - loading kmod test
>>> kmod_test_0006: FAIL, test expects SUCCESS (0) - got -EINVAL (-22)
>>> ----------------------------------------------------
>>> Custom trigger configuration for: test_kmod0
>>> Number of threads:      50
>>> Test_case:      TEST_KMOD_FS_TYPE (2)
>>> driver: test_module
>>> fs:     xfs
>>> ----------------------------------------------------
>>> Test completed
>>>
>>> When can multiple get_fs_type() calls be issued on a system? When
>>> mounting a large number of filesystems. Sadly though this issue seems
>>> to have gone unnoticed for a while now. Even reverting commit
>>> 6e6de3dee51a doesn't fix it, and I've run into issues with trying
>>> to bisect, first due to missing Kees' patch which fixes a compiler
>>> failure on older kernel [0] and now I'm seeing this while trying to
>>> build v5.1:
>>>
>>> ld: arch/x86/boot/compressed/pgtable_64.o:(.bss+0x0): multiple definition of `__force_order';
>>> arch/x86/boot/compressed/kaslr_64.o:(.bss+0x0): first defined here
>>> ld: warning: arch/x86/boot/compressed/efi_thunk_64.o: missing .note.GNU-stack section implies executable stack
>>> ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
>>> ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-only section `.head.text'
>>> ld: warning: arch/x86/boot/compressed/vmlinux has a LOAD segment with RWX permissions
>>> ld: warning: creating DT_TEXTREL in a PIE
>>> make[2]: *** [arch/x86/boot/compressed/Makefile:118: arch/x86/boot/compressed/vmlinux] Error 1
>>> make[1]: *** [arch/x86/boot/Makefile:112: arch/x86/boot/compressed/vmlinux] Error 2
>>> make: *** [arch/x86/Makefile:283: bzImage] Error 2
>>>
>>> [0] http://lore.kernel.org/lkml/20220213182443.4037039-1-keescook@chromium.org
>>>
>>> But we should try to bisect to see what cauased the above kmod test 0006
>>> to start failing.
>>
>> It is not clear to me from your description if the observed failure of
>> kmod_test_0006 is related to the fix in this thread.
> 
> The issue happens with and without the patch in this thread, I'd just hate to
> exacerbate the issue further.
> 
>> The problem was not possible for me to reproduce on my system. My test was on
>> an 8-CPU x86_64 machine using v6.2-rc4 with "defconfig + kvm_guest.config +
>> tools/testing/selftests/kmod/config".
> 
> With the patch?

It is same for me without and with the patch. The test doesn't produce any
failure on my test system. The complete kmod.sh selftest passes too.

Cheers,
Petr
