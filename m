Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3995455134
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 00:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241634AbhKQXlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 18:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240222AbhKQXlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 18:41:03 -0500
X-Greylist: delayed 324 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 17 Nov 2021 15:38:03 PST
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8899C061570;
        Wed, 17 Nov 2021 15:38:03 -0800 (PST)
Received: from tux.applied-asynchrony.com (p5ddd7948.dip0.t-ipconnect.de [93.221.121.72])
        by mail.itouring.de (Postfix) with ESMTPSA id 67D96124F91;
        Thu, 18 Nov 2021 00:32:34 +0100 (CET)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 0EA7BF01601;
        Thu, 18 Nov 2021 00:32:34 +0100 (CET)
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
To:     Justin Forbes <jmforbes@linuxtx.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
Date:   Thu, 18 Nov 2021 00:32:33 +0100
MIME-Version: 1.0
In-Reply-To: <YZV02RCRVHIa144u@fedora64.linuxtx.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-11-17 22:32, Justin Forbes wrote:
> On Wed, Nov 17, 2021 at 11:19:15AM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.3 release.
>> There are 923 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 19 Nov 2021 10:14:52 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc3.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>> and the diffstat can be found below.
>>
> 
> I replied to Bruno's original message to lkml which has CKI artifacts
> for the issue, but I am still seeing it with rc3 on x86:
> 
> [    4.435551] BUG: unable to handle page fault for address: ffffb381402d7de0
> [    4.437498] #PF: supervisor read access in kernel mode
> [    4.438937] #PF: error_code(0x0000) - not-present page
> [    4.440373] PGD 100000067 P4D 100000067 PUD 1001d7067 PMD 100a1f067 PTE 0
> [    4.442269] Oops: 0000 [#1] SMP PTI
> [    4.443256] CPU: 1 PID: 1 Comm: systemd Not tainted 5.15.3-0.rc3.1.fc35.x86_64 #1
> [    4.445230] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-3.fc34 04/01/2014
> [    4.447514] RIP: 0010:__unwind_start+0x10b/0x1e0
> [    4.448749] Code: af fb ff 85 c0 75 d2 eb c0 65 48 8b 04 25 c0 fb 01 00 48 39 c6 0f 84 86 00 00 00 48 8b 86 98 23 00 00 48 8d 78 38 48 89 7d 38 <48> 8b 50 28 48 89 55 40 48 8b 40 30 48 89 45 48 48 3d 80 43 00 a1
> [    4.453406] RSP: 0018:ffffb38140017c18 EFLAGS: 00010006
> [    4.454672] RAX: ffffb381402d7db8 RBX: ffffb381402d7db8 RCX: 0000000000000000
> [    4.456370] RDX: 0000000000000000 RSI: ffff9b5080c08000 RDI: ffffb381402d7df0
> [    4.458065] RBP: ffffb38140017c38 R08: 0000000000000040 R09: 0000000000005000
> [    4.459689] R10: 8000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [    4.461306] R13: ffff9b5080c08c74 R14: 000000000000024b R15: 0000000000000001
> [    4.462857] FS:  00007f8d7729c340(0000) GS:ffff9b51f7d00000(0000) knlGS:0000000000000000
> [    4.464613] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    4.465825] CR2: ffffb381402d7de0 CR3: 0000000100244004 CR4: 0000000000770ee0
> [    4.467301] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    4.468789] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [    4.470217] PKRU: 55555554
> [    4.470777] Call Trace:
> [    4.471280]  <TASK>
> [    4.471718]  __get_wchan+0x35/0x80
> [    4.472415]  get_wchan+0x65/0x80
> [    4.473085]  do_task_stat+0xcd9/0xde0
> [    4.473821]  proc_single_show+0x4d/0xb0
> [    4.474583]  seq_read_iter+0x120/0x4b0
> [    4.475327]  seq_read+0xed/0x120
> [    4.475973]  ? cap_convert_nscap+0x160/0x1b0
> [    4.476832]  vfs_read+0x95/0x190
> [    4.477472]  ksys_read+0x4f/0xc0
> [    4.478115]  do_syscall_64+0x3b/0x90
> [    4.478830]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [    4.479823] RIP: 0033:0x7f8d77e2c31c
> [    4.480537] Code: ec 28 48 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 f9 49 f9 ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 34 44 89 c7 48 89 44 24 08 e8 4f 4a f9 ff 48
> [    4.484140] RSP: 002b:00007ffc2434e8c0 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> [    4.485608] RAX: ffffffffffffffda RBX: 000055aa6dc4f650 RCX: 00007f8d77e2c31c
> [    4.486991] RDX: 0000000000000400 RSI: 000055aa6dcaf960 RDI: 0000000000000005
> [    4.488376] RBP: 00007f8d77f00300 R08: 0000000000000000 R09: 0000000000000001
> [    4.489761] R10: 0000000000001000 R11: 0000000000000246 R12: 00007f8d7729c0f8
> [    4.491159] R13: 0000000000000d68 R14: 00007f8d77eff700 R15: 0000000000000d68
> [    4.492545]  </TASK>
> [    4.492982] Modules linked in: xfs crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel serio_raw virtio_console virtio_blk virtio_net net_failover failover qemu_fw_cfg pkcs8_key_parser
> [    4.496354] CR2: ffffb381402d7de0
> [    4.497010] ---[ end trace dc5691b47f8ba15b ]---
> [    4.497913] RIP: 0010:__unwind_start+0x10b/0x1e0
> [    4.498822] Code: af fb ff 85 c0 75 d2 eb c0 65 48 8b 04 25 c0 fb 01 00 48 39 c6 0f 84 86 00 00 00 48 8b 86 98 23 00 00 48 8d 78 38 48 89 7d 38 <48> 8b 50 28 48 89 55 40 48 8b 40 30 48 89 45 48 48 3d 80 43 00 a1
> [    4.502401] RSP: 0018:ffffb38140017c18 EFLAGS: 00010006
> [    4.503418] RAX: ffffb381402d7db8 RBX: ffffb381402d7db8 RCX: 0000000000000000
> [    4.504803] RDX: 0000000000000000 RSI: ffff9b5080c08000 RDI: ffffb381402d7df0
> [    4.506185] RBP: ffffb38140017c38 R08: 0000000000000040 R09: 0000000000005000
> [    4.507582] R10: 8000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [    4.508956] R13: ffff9b5080c08c74 R14: 000000000000024b R15: 0000000000000001
> [    4.510339] FS:  00007f8d7729c340(0000) GS:ffff9b51f7d00000(0000) knlGS:0000000000000000
> [    4.511914] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    4.513032] CR2: ffffb381402d7de0 CR3: 0000000100244004 CR4: 0000000000770ee0
> [    4.514420] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    4.515803] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [    4.517182] PKRU: 55555554
> [    4.517724] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
> [    4.519317] Kernel Offset: 0x20000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [    4.521398] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009 ]---
> 

This is great! Several people (incl. me) have seen the _exact same_ trace, but with
BMQ/PDS (custom CPU schedulers) so we suspected a locking issue/incompatibility in
get_wchan()'s spinlocking & task diddling compared to CFS. The fact that this happens
with vanilla means it's a generic problem with either: "sched: Add wrapper for get_wchan()
to keep task blocked" or "x86: Fix get_wchan() to support the ORC unwinder" or both.
I have been running with a dummy implementation of get_wchan that just returns 0
(effectively disabling wchan) and 5.15.3-rc3 has been rock-solid again.

Maybe just revert all the wchan stuff and let it stew in mainline a bit longer?

-h
