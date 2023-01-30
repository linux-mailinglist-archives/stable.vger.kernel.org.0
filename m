Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2FE681684
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 17:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbjA3Qgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 11:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjA3Qgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 11:36:53 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2063.outbound.protection.outlook.com [40.92.52.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3114A35240
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 08:36:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHOUv0djVrpDzStuYjNMVERX9QsAhYtBxw+Q7XvMRi+oKgmIsasxqU9wUdoONQasNU9PFAMpMTYWCxX9m1AhyTGQbAleaUBoNbnr8YlAVGp66vpgDraPGRtagvWbXaF4yGmcc9UEef0RN5P0MRvkfT3/Whql3mwQB1LttSBckemhOszjs1u8Z/kRIsyR/UgOFveOU8Xn7hH8kSaBMaDzvVz28OqX+Ly43OzBMZvHsT6THSoKd2bJCTHn3K4+Zt8kIxhjZxu5AJusmwE5QBw4mqNh2p3wF7zx7NeNCFn89AOkaGBkYP4dJGpgPxq6rwCyLF9nZLY7evw5GDtqV9TQ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1/hHWjOMxLJee5EPKylnUTEnGOaPiX4op6Y4UrSy0I8=;
 b=duZZtE+fPrLK7HQzaELrn0lxwRKjHYyQzebxN2BXCeY8J0cnwcWg+Zhek6QxLDtjCX2hhchfYvH0j4ekr5aaO0L0LgI5RD+b0BJPdPJMu4ZQFJS2prc+F9WUY3kmZXdaTIlhyZp3BfMHHxuiz0ettUJKAE1bZSLO4yuv8TE4N7yDKxAIbz5XMFFu9i7IgWeixMst7Cvmke0lYAIGhz3Na8UL+PYOLPjcLWmSgg4ZHSH+7ob1M7aP6KP2hAnFKG5OgwatWpb4JgUTxne/RauZLsDV1RA4WRVE0k45+86J5aS8BJvXXTDtr6ya27ZOE73nhom2qu7+3UfS7+fOMuAJng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/hHWjOMxLJee5EPKylnUTEnGOaPiX4op6Y4UrSy0I8=;
 b=J15za2XNkVAD6dEoVBghvCCmPNL8fDlfcz3ERhAOXWWz9dagLA79wT9BPcLD3FGgYyZV7HA0flXG+CN+96CRd9BC0NKrs6iWzdyXRR9GzW1BLUkG15PyPhm3dqrF4kSaETshiqTnbdbv22DQDwctnwDp0+Wg+hvPMLECqV2EVA5x/s4wF/MgvHaLszu1U+USQL74anc1TWTQ8oWoselcAd1juamDCwGuzLLKy6pcQ/We5bQCK9pfiAbl3BOmLAc3WSoZanlKpQ3/2wn9o0D6dGApiPrGUtaMLPw4BMJ8sSXcGFuhqhb+cBbB/duqDNm5Jcr83F64esPapb8DLNhi0g==
Received: from OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:aa::11)
 by TYCP286MB1682.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:184::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 16:36:47 +0000
Received: from OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM
 ([fe80::202f:5bbf:ade5:e4f7]) by OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM
 ([fe80::202f:5bbf:ade5:e4f7%3]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 16:36:47 +0000
Message-ID: <OS0P286MB019398DDFF6011038AD841C0B4D39@OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM>
Date:   Tue, 31 Jan 2023 00:36:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
From:   Keyu Tao <taoky99@outlook.com>
Cc:     1029602@bugs.debian.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Bug report: kernel oops in vmw_fb_dirty_flush()
To:     zackr@vmware.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN:  [6TOE0ETlCSpS++jf7gGijK6f/Ltout01U8clFRdUYq2zP4MRlnbX+A==]
X-ClientProxiedBy: TY2PR06CA0039.apcprd06.prod.outlook.com
 (2603:1096:404:2e::27) To OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:aa::11)
X-Microsoft-Original-Message-ID: <e7b6cf7a-9de5-24d6-5ea4-7b85be758e73@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS0P286MB0193:EE_|TYCP286MB1682:EE_
X-MS-Office365-Filtering-Correlation-Id: 09433eb3-c23b-4ed1-aaf3-08db02e02e18
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IHGHyCisN3dPkLTe532YVkdTBT0lLh5unWE6AxkeIaoW9sz8kvmitjPMuAYafycLxS/d0LIp5PkveR+H7Qo2ODDqKdmHGbwmZ4+qNDhO38Y/S6ddgaQKM5OO2rPdLaOiy+dhPeXyXRYfhQ1WDMiD+87kHr0ovPxUjKQRFSAF0TwF+Ty9/hxoEQj1cUPu/5H6zTBVGM7wLipnECHAipRGUxKZgwGupnNUKGb/HuLtHB0utuq2Z2lurrTisCfUpqawFb3+kCzrJg5d23P/LWmzUjGHNJ3nLS/71WJvMf4C3aO+PBbUbc4NB+IZSDXIOdxbwYVZI7rn3ElRPRcqVV7j+BURcjR5/vEg9aUqukUlhPU1xPPRLZIXlkR4qGzLnHofiQtB0xTDB1FFIojlD78dxEwfL4xwMMIiwyKNWa0m/2F+NwRB54wgeh3vNCTEXURUcTcbNAqKbGpSzugqS0tJ55Kgar86g9BfOJU0nzM21HTlCu8j7m5kJ55+7kjpkjr46JKmzVX+x+6bCczec3RvEhL8qOmg8YsIiTuxn1mz7i9oZsfnFPLeWidjUgjkEbJiwvjhuKCl7wsvEb4jBr+M8A==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlNMQy9pNUIrRGdqRXphbTRaaWZUTFVycXkrY2VjMnU5YmVtMnFUdDE2UERO?=
 =?utf-8?B?Sjc1bEdzOFF4RWZ3aWY1ZmtMa3ZEdVREMmN1VENTVGd4WnVleGQzU3VRU1NI?=
 =?utf-8?B?VGpBdHpjUXQyNVVTUGNjUmE1SStKYlI4Qzl2YTgvRVdTOFFiNmYySW9mSUNn?=
 =?utf-8?B?SFN5Z3ViYVlCbUZUTWpQQ212Z3RiWFdHY1ZKUkQrNzZBZnVrVWlXRDJCL0t0?=
 =?utf-8?B?YzJxcmpZTjh3aXVINXl5NmFnY0d5UGdQRFB2YUNXZHpIRnRqNVVGZmUxRE0r?=
 =?utf-8?B?cUlNZWRNQ2VBTk5BSmFWK1d4V05PQlJkSzBlU011Tml1Q1FBdXQ5ZVNxd0ta?=
 =?utf-8?B?V3RWczRFRnJvUmd4djg5MC9xRHYydms2Z0JQb09Weit3VnZKL1hDSDJVRlFa?=
 =?utf-8?B?QmtSekVFdjA1akd5eVFmbW9tTnlqTWh4OGpTeDcxWS9ocmxYM3JpQ2V2emQz?=
 =?utf-8?B?UmI5dURNWFZqQmRRdTZLNitYMjZxc1JRNGZ3RWlaNHp3aGh2blBid3EvNHhm?=
 =?utf-8?B?WkJhYmJnSXgyK1dnY05abWR2ZnZiRGMrNGFEdlJhb0tzd0ErajZaemp2Q0ls?=
 =?utf-8?B?dlVRVTZrNWs1MGREREdTZkZiVHF1VjN3eHVqdHdlMXhhNU82bUo1NzA1b1pr?=
 =?utf-8?B?QUZuczJRSWZqUnI3ZUtjR0oyMXZMQ2RaSXV0NzVMT3JDMGJQc0FuQU5jdklw?=
 =?utf-8?B?QklCR2g0Z0Z3aW93eHJwRTdBalJObmZpekxYMEw4ajMyMko5OURFRWhCWC9V?=
 =?utf-8?B?M0N4NlBYVnNzMjQvS253VVRZWDJ3K2pxcHFhMUlLYnlZWDRpYnlyZEpSbTlS?=
 =?utf-8?B?bFV3ZGZaU0VUdytmZ0ZuWGVJMVpMYklJelRHZGp5Nk55MGVXcHVKczl6eS9N?=
 =?utf-8?B?WjNiamUrSllFSE4zQjJKOGdLcmVTVnkzNlhFbVRIMG40STJqaGVkejhUTXYz?=
 =?utf-8?B?V2tYcGdzbnRQMFNORHgxL0FQdXZnSE5aT21acGVTMEQzZFd2RWMrbHJFdTln?=
 =?utf-8?B?eXFzeHUzMCtHSzZTTUlYa29Nd1gyTXdFTHQyUWwwbnI4TU1JWDV1NGJ2TTJ3?=
 =?utf-8?B?bTh6VDZGRFpQUHZlQ0VIanBVZWNtUlpIQkNZM29KYyt5RDRmS2tQZVU2Y2Nw?=
 =?utf-8?B?NXJHenlKanR6SUJlKzM4UFRNRkdObHFNZm1tSVN5ZmVYck1UV3VtVWI2WERx?=
 =?utf-8?B?eUJtQ0IrOXN5R3pzMEpPVDI2YVM5TzdvR1hxSlJMTG5DRTd5VFVvNU5DUnQ2?=
 =?utf-8?B?RWZaUWZYakM0YnhkUi8ybDlhSVh5YW5DSmM5T0VFRDhZQlQyTVVnYm9OWEUy?=
 =?utf-8?B?ZDhvaVZoYW01N1U0YlNXb2I0eE9Ec2xmdWRHWU53dmpIVCtxWXRsd2R3VDZB?=
 =?utf-8?B?ZUJBWnNBY0t5TEN6NXpVZitySFIwUVpKTEI2dWVjOXVYQyt6Z240TlUrU1ZH?=
 =?utf-8?B?WWpNZHhQYnNpWk9CTkVkaHNJWWc2dVBjQU9zSU55OFZ5cmtSRENWa2psS1lG?=
 =?utf-8?B?ZU1jQytCYmhOR1FueElGSjdid2l1eVB1Y0UvdGJ5V0ozN0dqZU4xS1Z0ck94?=
 =?utf-8?B?Nkg4dXdGRmVORkFMOWd2Sk5iVFNaUVVEeXZXUDdreGNCd0RyRWdkRjdxU3pD?=
 =?utf-8?B?V0dzdnBPK2xjb2JBQ1ZwdGFvbGNFMXNFTE5oeFBTZ1dEZXlTLzdVWmgvWVlO?=
 =?utf-8?B?TnZhSmRzNklnRzlmVDZSR0N3Q0VUTWZvWDBsZEhNTmJ4Zy9wMTllWndhTTh2?=
 =?utf-8?Q?9Vg8nQKvgZFG+TTByg=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09433eb3-c23b-4ed1-aaf3-08db02e02e18
X-MS-Exchange-CrossTenant-AuthSource: OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 16:36:47.4073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCP286MB1682
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi vmwgfx maintainers,

An out-of-bound access in vmwgfx specific framebuffer implementation can 
be easily triggered by fbterm (a framebuffer terminal emulator) when it 
is going to scroll screen.

With some debugging, it seems that vmw_fb_dirty_flush() cannot handle 
the vinfo.yoffset correctly after calling `ioctl(fbdev_fd, 
FBIOPAN_DISPLAY, &vinfo);`, and then subsequent access to the mapped 
memory area causes the oops.

As current mainline vmwgfx implementation (in Linux 6.2-rc) has removed 
this framebuffer implementation, this bug can be triggered only in Linux 
stable. I have tested it with vanilla 6.1.8 and 5.10.165 and they all oops.

This bug is reported in 
<https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1029602> first, and 
the maintainer there suggests me to report this issue to upstream :)

Relevant information (for self-compiled Linux 6.1.8):

- /proc/version: Linux version 6.1.8 (tao@mira) (gcc (Debian 10.2.1-6) 
10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2) #7 SMP 
PREEMPT_DYNAMIC Mon Jan 30 21:09:02 CST 2023

- Linux distribution: Debian GNU/Linux 11 (bullseye)

- Architecture (uname -mi): x86_64 unknown

- Virtualization software: VMware Fusion 13 Player

- How to reproduce:
   1. Install (or compile) fbterm
   2. Run fbterm under a tty (by a user with read & write permission to 
/dev/fb0, usually users in video group), and try to make it scroll (for 
example by pressing Enter for a few seconds)
   3. The graphics hang and it oops.

- decoded oops message:

[   31.519514] BUG: unable to handle page fault for address: 
ffffa7c5019d6000
[   31.519843] #PF: supervisor write access in kernel mode
[   31.520149] #PF: error_code(0x0002) - not-present page
[   31.520453] PGD 1000067 P4D 1000067 PUD 11bc067 PMD 31f0d067 PTE 0
[   31.520784] Oops: 0002 [#1] PREEMPT SMP PTI
[   31.521022] CPU: 0 PID: 7 Comm: kworker/0:0 Kdump: loaded Not tainted 
6.1.8 #7
[   31.521266] Hardware name: VMware, Inc. VMware Virtual Platform/440BX 
Desktop Reference Platform, BIOS 6.00 11/12/2020
[   31.521796] Workqueue: events vmw_fb_dirty_flush [vmwgfx]
[   31.522080] RIP: 0010:memcpy_orig 
(/home/tao/Downloads/linux-6.1.8/arch/x86/lib/memcpy_64.S:85)
[ 31.522396] Code: 00 48 89 f8 48 83 fa 20 72 7e 40 38 fe 7c 35 48 83 ea 
20 48 83 ea 20 4c 8b 06 4c 8b 4e 08 4c 8b 56 10 4c 8b 5e 18 48 8d 76 20 
<4c> 89 07 4c 89 4f 08 4c 89 57 10 4c 89 5f 18 48 8d 7f 20 73 d4 83
All code
========
    0:	00 48 89             	add    %cl,-0x77(%rax)
    3:	f8                   	clc
    4:	48 83 fa 20          	cmp    $0x20,%rdx
    8:	72 7e                	jb     0x88
    a:	40 38 fe             	cmp    %dil,%sil
    d:	7c 35                	jl     0x44
    f:	48 83 ea 20          	sub    $0x20,%rdx
   13:	48 83 ea 20          	sub    $0x20,%rdx
   17:	4c 8b 06             	mov    (%rsi),%r8
   1a:	4c 8b 4e 08          	mov    0x8(%rsi),%r9
   1e:	4c 8b 56 10          	mov    0x10(%rsi),%r10
   22:	4c 8b 5e 18          	mov    0x18(%rsi),%r11
   26:	48 8d 76 20          	lea    0x20(%rsi),%rsi
   2a:*	4c 89 07             	mov    %r8,(%rdi)		<-- trapping instruction
   2d:	4c 89 4f 08          	mov    %r9,0x8(%rdi)
   31:	4c 89 57 10          	mov    %r10,0x10(%rdi)
   35:	4c 89 5f 18          	mov    %r11,0x18(%rdi)
   39:	48 8d 7f 20          	lea    0x20(%rdi),%rdi
   3d:	73 d4                	jae    0x13
   3f:	83                   	.byte 0x83

Code starting with the faulting instruction
===========================================
    0:	4c 89 07             	mov    %r8,(%rdi)
    3:	4c 89 4f 08          	mov    %r9,0x8(%rdi)
    7:	4c 89 57 10          	mov    %r10,0x10(%rdi)
    b:	4c 89 5f 18          	mov    %r11,0x18(%rdi)
    f:	48 8d 7f 20          	lea    0x20(%rdi),%rdi
   13:	73 d4                	jae    0xffffffffffffffe9
   15:	83                   	.byte 0x83
[   31.523208] RSP: 0018:ffffa7c50005be10 EFLAGS: 00010202
[   31.523555] RAX: ffffa7c5019d5c00 RBX: 0000000000000c80 RCX: 
0000000000000c80
[   31.523841] RDX: 0000000000000840 RSI: ffffa7c500e73a20 RDI: 
ffffa7c5019d6000
[   31.524071] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000000
[   31.524299] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffffa7c500e73600
[   31.524525] R13: ffff97ba70af4cd8 R14: ffff97ba70b40000 R15: 
ffff97ba70af4800
[   31.524753] FS:  0000000000000000(0000) GS:ffff97ba91800000(0000) 
knlGS:0000000000000000
[   31.524981] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   31.525209] CR2: ffffa7c5019d6000 CR3: 0000000037a10002 CR4: 
00000000003706f0
[   31.525440] Call Trace:
[   31.525670]  <TASK>
[   31.525900] vmw_fb_dirty_flush 
(/home/tao/Downloads/linux-6.1.8/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c:244) 
vmwgfx
[   31.526162] process_one_work 
(/home/tao/Downloads/linux-6.1.8/kernel/workqueue.c:2289)
[   31.526399] worker_thread 
(/home/tao/Downloads/linux-6.1.8/./include/linux/list.h:292 
/home/tao/Downloads/linux-6.1.8/kernel/workqueue.c:2437)
[   31.526623] ? rescuer_thread 
(/home/tao/Downloads/linux-6.1.8/kernel/workqueue.c:2379)
[   31.526843] kthread 
(/home/tao/Downloads/linux-6.1.8/kernel/kthread.c:376)
[   31.527058] ? kthread_complete_and_exit 
(/home/tao/Downloads/linux-6.1.8/kernel/kthread.c:331)
[   31.527273] ret_from_fork 
(/home/tao/Downloads/linux-6.1.8/arch/x86/entry/entry_64.S:306)
[   31.527490]  </TASK>
[   31.527748] Modules linked in: xt_conntrack xt_MASQUERADE 
nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo xt_addrtype 
iptable_filter iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 
nf_defrag_ipv4 br_netfilter bridge stp llc intel_rapl_msr 
intel_rapl_common intel_pmc_core kvm_intel kvm irqbypass rapl 
vmw_balloon joydev serio_raw pcspkr snd_ens1371 snd_ac97_codec ac97_bus 
gameport snd_rawmidi snd_seq_device snd_pcm snd_timer snd soundcore sg 
overlay vsock_loopback vmw_vsock_virtio_transport_common 
vmw_vsock_vmci_transport vsock vmw_vmci evdev ac binfmt_misc parport_pc 
nfsd ppdev fuse auth_rpcgss nfs_acl lp lockd grace parport configfs 
sunrpc ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 btrfs 
blake2b_generic xor raid6_pq zstd_compress libcrc32c crc32c_generic 
dm_mirror dm_region_hash dm_log dm_mod hid_generic usbhid hid sd_mod 
t10_pi crc64_rocksoft_generic crc64_rocksoft crc_t10dif 
crct10dif_generic crc64 crct10dif_pclmul crct10dif_common crc32_pclmul 
crc32c_intel
[   31.527816]  ghash_clmulni_intel sha512_ssse3 sha512_generic sr_mod 
cdrom aesni_intel crypto_simd ata_generic cryptd vmwgfx xhci_pci 
ata_piix drm_ttm_helper ttm mptspi psmouse mptscsih ehci_pci mptbase 
drm_kms_helper uhci_hcd xhci_hcd ehci_hcd scsi_transport_spi libata 
scsi_mod drm e1000 usbcore usb_common i2c_piix4 scsi_common button
[   31.531626] CR2: ffffa7c5019d6000
[   31.531892] ---[ end trace 0000000000000000 ]---
[   31.532289] RIP: 0010:memcpy_orig 
(/home/tao/Downloads/linux-6.1.8/arch/x86/lib/memcpy_64.S:85)
[ 31.532536] Code: 00 48 89 f8 48 83 fa 20 72 7e 40 38 fe 7c 35 48 83 ea 
20 48 83 ea 20 4c 8b 06 4c 8b 4e 08 4c 8b 56 10 4c 8b 5e 18 48 8d 76 20 
<4c> 89 07 4c 89 4f 08 4c 89 57 10 4c 89 5f 18 48 8d 7f 20 73 d4 83
All code
========
    0:	00 48 89             	add    %cl,-0x77(%rax)
    3:	f8                   	clc
    4:	48 83 fa 20          	cmp    $0x20,%rdx
    8:	72 7e                	jb     0x88
    a:	40 38 fe             	cmp    %dil,%sil
    d:	7c 35                	jl     0x44
    f:	48 83 ea 20          	sub    $0x20,%rdx
   13:	48 83 ea 20          	sub    $0x20,%rdx
   17:	4c 8b 06             	mov    (%rsi),%r8
   1a:	4c 8b 4e 08          	mov    0x8(%rsi),%r9
   1e:	4c 8b 56 10          	mov    0x10(%rsi),%r10
   22:	4c 8b 5e 18          	mov    0x18(%rsi),%r11
   26:	48 8d 76 20          	lea    0x20(%rsi),%rsi
   2a:*	4c 89 07             	mov    %r8,(%rdi)		<-- trapping instruction
   2d:	4c 89 4f 08          	mov    %r9,0x8(%rdi)
   31:	4c 89 57 10          	mov    %r10,0x10(%rdi)
   35:	4c 89 5f 18          	mov    %r11,0x18(%rdi)
   39:	48 8d 7f 20          	lea    0x20(%rdi),%rdi
   3d:	73 d4                	jae    0x13
   3f:	83                   	.byte 0x83

Code starting with the faulting instruction
===========================================
    0:	4c 89 07             	mov    %r8,(%rdi)
    3:	4c 89 4f 08          	mov    %r9,0x8(%rdi)
    7:	4c 89 57 10          	mov    %r10,0x10(%rdi)
    b:	4c 89 5f 18          	mov    %r11,0x18(%rdi)
    f:	48 8d 7f 20          	lea    0x20(%rdi),%rdi
   13:	73 d4                	jae    0xffffffffffffffe9
   15:	83                   	.byte 0x83
[   31.533338] RSP: 0018:ffffa7c50005be10 EFLAGS: 00010202
[   31.533561] RAX: ffffa7c5019d5c00 RBX: 0000000000000c80 RCX: 
0000000000000c80
[   31.533784] RDX: 0000000000000840 RSI: ffffa7c500e73a20 RDI: 
ffffa7c5019d6000
[   31.534008] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000000
[   31.534229] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffffa7c500e73600
[   31.534447] R13: ffff97ba70af4cd8 R14: ffff97ba70b40000 R15: 
ffff97ba70af4800
[   31.534664] FS:  0000000000000000(0000) GS:ffff97ba91800000(0000) 
knlGS:0000000000000000
[   31.534884] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   31.535105] CR2: ffffa7c5019d6000 CR3: 0000000037a10002 CR4: 
00000000003706f0
