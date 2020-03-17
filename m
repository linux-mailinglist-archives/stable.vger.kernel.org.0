Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB84F187AA1
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 08:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgCQHp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 03:45:56 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:42813 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgCQHp4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 03:45:56 -0400
Received: by mail-lf1-f49.google.com with SMTP id t21so16304454lfe.9
        for <stable@vger.kernel.org>; Tue, 17 Mar 2020 00:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=vs60LH3coDU/G583V0oax4DANniSeCRsFOzDHxjS2/I=;
        b=VD7FvoGMbpcVA/mT+vDg4+K0a/hVm6FOQ0rimtBc+X38Xx11xuKyrySevJG6Rrixw9
         dM5ndQGygywVqE5pDILq7Iq/SE9h+UtBOUzfJMP8Khx0CWk5gGqi7En4r7SSrscNGBpj
         ECjS/ydwVDbVO2nHnNuwHA7R7JgA5IOmgp0wuBbzsQ53Realzu4TDqUn9pOlhfAc24tK
         m+i1jvlkI35IstExqmtWwdcVzBcFNq11jwbyDRD8lKEOxLoF9Lg7PtOKZqO157MybvM4
         eWzP33dTG+odpONTtvIsN6bgII7irX6Q4OcwgsmriRmgGt757bro2yjlmB+Hm8S6Fzd1
         iDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=vs60LH3coDU/G583V0oax4DANniSeCRsFOzDHxjS2/I=;
        b=EbMgjSt485hXgy+Q78q5IJ3KHkWiOphLZuUGBKqm0V9DMCiAPKBNKn8fNQ8vDFwfai
         LY95DOwaJMRVbw97RoV4dsOQau5Ve/WDmkNvUtELbwV3Xx4yeOlBENFY37uT8DIA5a+A
         yjgKa+bIjVoHYMp66srnplBbOCIj82BxBKO05M1IsEuSmwBZJM2tfFzWi6n/+tVFTvYv
         2RqIjhWEXtNCV7uwcwZdMQR1qupA7fZkFAYh+fz0H/0IXkYkXTGjhR6T79VQBTzrknkH
         NaqMCK7PhUFWtFlrZozOeSebb802nRQLq5etjBXNRSmW/W/U/4+VDTgENOLRHz3up1Y5
         LSeA==
X-Gm-Message-State: ANhLgQ0/ZzU1499Q4u1WTaUJWWcXl3c/Klz79xZ+rGdibAnuKBGfarFr
        lqtH/dB+5bcnhIvsQJyvuqceDltOTo114jW0GLuEg5jXcAY1gQ==
X-Google-Smtp-Source: ADFU+vtcsO5pokvCVx3QxsusodoDyFnEMJg/zVI/XgUPyMI9XKa92yXHJE/hzm7hsS15MYnL1OpwjZIq4WSkoyAUNu0=
X-Received: by 2002:ac2:43a8:: with SMTP id t8mr2085415lfl.82.1584431152269;
 Tue, 17 Mar 2020 00:45:52 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 Mar 2020 13:15:40 +0530
Message-ID: <CA+G9fYu06RPexAK-4huCSwYC4=FkuH2QduVpxOgG43ojX2jyBA@mail.gmail.com>
Subject: [stable-rc-5.4 and 5.5 ] WARNING: CPU: 3 PID: 2548 at
 /usr/src/kernel/lib/refcount.c:28 refcount_warn_saturate
To:     linux- stable <stable@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        open list <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Todd Kjos <tkjos@google.com>, Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, tkjos@android.com,
        ardb@kernel.org, Kees Cook <keescook@chromium.org>,
        lkft-triage@lists.linaro.org, Basil Eljuse <Basil.Eljuse@arm.com>,
        YongQin Liu <yongqin.liu@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While running selftests binderfs_test on stable rc 5.4 and 5.5
branches the following
warning on arm64, arm, x86_64 and i386.

This warning was noticed on Linus's tree and reported [1] and then
Christian Brauner investigated this problem.

FYI, We are running selftests source from stable rc 5.5 branch.

[  224.520090] ------------[ cut here ]------------
[  224.521202] refcount_t: underflow; use-after-free.
[  224.522284] WARNING: CPU: 3 PID: 2548 at
/usr/src/kernel/lib/refcount.c:28 refcount_warn_saturate+0x93/0x100
[  224.523215] Modules linked in: cls_bpf sch_fq sch_ingress
algif_hash af_alg fuse [last unloaded: test_bpf]
[  224.523215] CPU: 3 PID: 2548 Comm: binderfs_test Not tainted 5.5.10-rc1 #1
[  224.526771] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[  224.526771] RIP: 0010:refcount_warn_saturate+0x93/0x100
[  224.526771] Code: 38 73 62 01 01 e8 3d c2 b6 ff 0f 0b 5d c3 80 3d
2a 73 62 01 00 75 ab 48 c7 c7 70 b0 00 92 c6 05 1a 73 62 01 01 e8 1d
c2 b6 ff <0f> 0b 5d c3 80 3d 0d 73 62 01 00 75 8b 48 c7 c7 f8 af 00 92
c6 05
[  224.526771] RSP: 0018:ffffaaa081417c58 EFLAGS: 00010286
[  224.526771] RAX: 0000000000000000 RBX: ffff9e77f1ed2c40 RCX: 0000000000000000
[  224.526771] RDX: 0000000000000001 RSI: ffff9e77fbd98d48 RDI: ffff9e77fbd98d48
[  224.526771] RBP: ffffaaa081417c58 R08: 0000000000000000 R09: 0000000000000000
[  224.526771] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9e77fa99f400
[  224.526771] R13: ffff9e77ee42bbc0 R14: ffff9e77f1ed2cc8 R15: ffffffff92400300
[  224.526771] FS:  00007f9e5d8824c0(0000) GS:ffff9e77fbd80000(0000)
knlGS:0000000000000000
[  224.526771] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  224.526771] CR2: 00007f9e5d41ff7c CR3: 000000012cbc2000 CR4: 00000000003406e0
[  224.526771] Call Trace:
[  224.526771]  binderfs_evict_inode+0x9b/0xc0
[  224.526771]  evict+0xc8/0x190
[  224.526771]  iput+0x19c/0x2a0
[  224.526771]  ? shrink_dentry_list+0x29/0x210
[  224.526771]  dentry_unlink_inode+0x104/0x110
[  224.526771]  __dentry_kill+0xda/0x180
[  224.526771]  shrink_dentry_list+0xe3/0x210
[  224.526771]  shrink_dcache_parent+0x11c/0x200
[  224.526771]  do_one_tree+0x12/0x40
[  224.526771]  shrink_dcache_for_umount+0x2d/0x90
[  224.526771]  generic_shutdown_super+0x1f/0x120
[  224.526771]  kill_anon_super+0x12/0x30
[  224.526771]  kill_litter_super+0x23/0x30
[  224.526771]  binderfs_kill_super+0x16/0x40
[  224.526771]  deactivate_locked_super+0x43/0x70
[  224.526771]  deactivate_super+0x40/0x60
[  224.526771]  cleanup_mnt+0xbd/0x150
[  224.526771]  __cleanup_mnt+0x12/0x20
[  224.526771]  task_work_run+0x90/0xc0
[  224.526771]  exit_to_usermode_loop+0xf0/0x100
[  224.526771]  do_syscall_64+0x1bf/0x200
[  224.526771]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  224.526771] RIP: 0033:0x7f9e5d3a30c7
[  224.526771] Code: ad 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f
44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a1 ad 2b 00 f7 d8 64 89
01 48
[  224.526771] RSP: 002b:00007ffc35189ee8 EFLAGS: 00000206 ORIG_RAX:
00000000000000a6
[  224.526771] RAX: 0000000000000000 RBX: 00007f9e5d882440 RCX: 00007f9e5d3a30c7
[  224.526771] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000000040192c
[  224.526771] RBP: 0000000000000002 R08: 0000000000000001 R09: 00007f9e5d3e23e0
[  224.526771] R10: 000000000000079a R11: 0000000000000206 R12: 0000000000000001
[  224.526771] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  224.526771] irq event stamp: 1776
[  224.526771] hardirqs last  enabled at (1775): [<ffffffff909751b8>]
console_unlock+0x458/0x5c0
[  224.526771] hardirqs last disabled at (1776): [<ffffffff90801e9b>]
trace_hardirqs_off_thunk+0x1a/0x1c
[  224.526771] softirqs last  enabled at (1772): [<ffffffff91a00338>]
__do_softirq+0x338/0x43a
[  224.526771] softirqs last disabled at (1761): [<ffffffff90902b28>]
irq_exit+0xb8/0xc0
[  224.526771] ---[ end trace a9ce2ef5cd0b3086 ]---

ref:
https://lkft.validation.linaro.org/scheduler/job/1294041#L8703
https://lkft.validation.linaro.org/scheduler/job/1294145#L9569
https://lkft.validation.linaro.org/scheduler/job/1294086#L11063
https://lkft.validation.linaro.org/scheduler/job/1293967#L9551

[1] https://lore.kernel.org/linux-kselftest/CA+G9fYusdfg7PMfC9Xce-xLT7NiyKSbgojpK35GOm=Pf9jXXrA@mail.gmail.com/
--
Linaro LKFT
https://lkft.linaro.org
