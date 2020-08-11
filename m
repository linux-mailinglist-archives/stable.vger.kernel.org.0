Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AA4241838
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 10:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgHKI2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 04:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728178AbgHKI2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 04:28:17 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4CEC06174A
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 01:28:17 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id g19so11785466ioh.8
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 01:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eo2L93RRdI84FxyH7GVcLy69tN4zbbbp3YsbGWN8W5I=;
        b=ovrImObt5hFzeUHg8X9Ivfh3lAA7VBIl9LCNEjyZ+T5wLui90H+gv3jxG8DHDLkPAx
         DLytiwMEw7Vw7kbtHS6SocODZ1+imZr/4PHHlykhwsMFBIWV+Z6O3upXU2haehmDs93k
         VGvY3om8WRG/bqfYQfYwMa6bHJGlvNOT/BjTp1JNnEmdzryc+MreDyBkDt5FMYrrsk1d
         b4bKf3fqedm6Ff0LUtd6FYjdXBNa/+LnSFZ6nfwuXAtCxuSJOaBrfILnL5d/9xoVoV1/
         j4YoVgvW6ioUJwSYNHYPEVuoDJBLFLE7SNIxvCBC5zulRQGg24R5jahQ4ghMbLL8I8sU
         y64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eo2L93RRdI84FxyH7GVcLy69tN4zbbbp3YsbGWN8W5I=;
        b=NIwMAaUCbFk9Qjn4nu0vbqJheXWjl65PdS+eBcqpGqlL/0LNf9zq705EojFJTF53ks
         MQk3jhrlFiX5WzW7x9Kjy9SB6a4P9QiVDdok4ruG3bHcYTAAFUHVhOUBDRfYCfyKA9w3
         jRFmNYfVApZEpdVpaUAz+ALQvtc7hcpz3YIOruUZ0WeiANhBe5MXTqmLRQsSENMigwzn
         fSeVI/TN5nZlThLM/0N3sxFLBQv456Nz7W7sMLRJK5wSbw5lKfQvCJWsfGlD8dL+iU+d
         ybZpt+H5/Ev4bJegrH0h0j1vYhj7KmZMI4nTUOY+xECix5hBeooluPo782CZrZ+ilRGi
         Bn4g==
X-Gm-Message-State: AOAM5321RISwIlq2PQ8XbJS2BRUlP0TufSkwt8D8uAmVdUxRKyWx7Kv4
        dsoLcQ46aDCx8nx39Mii1/3IG9kiHgFsF0YFrGgjew==
X-Google-Smtp-Source: ABdhPJw8lJUpnFEPPL5OFUHqYYnO3+VCUnRb4InhMNNIoUVe4NPoNSm8G+RDmsolpVU/P08BFJzLbidP1QTMOjqgN5s=
X-Received: by 2002:a6b:144d:: with SMTP id 74mr21503920iou.49.1597134496103;
 Tue, 11 Aug 2020 01:28:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200810151804.199494191@linuxfoundation.org>
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 Aug 2020 13:58:04 +0530
Message-ID: <CA+G9fYsZs6u8LH6gJ=bnc8UWrNzLZXnaq2oMY+psNCQPzyPxdQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/48] 4.19.139-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>, zanussi@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Aug 2020 at 21:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.139 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.139-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions on x86_64.

We have added LTP tracing test suite this week and started noticing
kernel BUG on x86_64 KASAN enabled kernel. Which means this issue might not=
 be
specific to this release candidate.

[   90.134426] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   90.141651] BUG: KASAN: use-after-free in trace_stack_print+0x133/0x150
[   90.148264] Read of size 8 at addr ffff888228015ffc by task cat/3569
[   90.154613]
[   90.156106] CPU: 3 PID: 3569 Comm: cat Not tainted 4.19.139-rc1 #1
[   90.162278] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[   90.169669] Call Trace:
[   90.172115]  dump_stack+0x7d/0xaa
[   90.175463]  print_address_description+0x67/0x229
[   90.180165]  ? trace_stack_print+0x133/0x150
[   90.184460]  kasan_report.cold+0xae/0x2fe
[   90.188469]  __asan_load8+0x54/0x90
[   90.191959]  trace_stack_print+0x133/0x150
[   90.196051]  print_trace_line+0x3c7/0x930
[   90.200063]  ? tracing_buffers_read+0x310/0x310
[   90.204589]  tracing_read_pipe+0x2db/0x530
[   90.208687]  __vfs_read+0xe5/0x3c0
[   90.212093]  ? __x64_sys_copy_file_range+0x360/0x360
[   90.217059]  ? fsnotify+0x7cb/0x7f0
[   90.220550]  ? _cond_resched+0x14/0x30
[   90.224296]  ? __inode_security_revalidate+0x5d/0x70
[   90.229262]  ? avc_policy_seqno+0x21/0x30
[   90.233273]  ? security_file_permission+0xc6/0xf0
[   90.237970]  ? security_file_permission+0xc6/0xf0
[   90.242667]  ? rw_verify_area+0x73/0x140
[   90.246584]  vfs_read+0xc8/0x1d0
[   90.249808]  ksys_read+0xbb/0x170
[   90.253120]  ? kernel_write+0xa0/0xa0
[   90.256786]  ? __audit_syscall_exit+0x3bb/0x430
[   90.261320]  __x64_sys_read+0x3e/0x50
[   90.264985]  do_syscall_64+0x63/0x160
[   90.268649]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   90.273693] RIP: 0033:0x7f9596d9e071
[   90.277266] Code: fe ff ff 48 8d 3d 3f 71 09 00 48 83 ec 08 e8 26
ee 01 00 66 0f 1f 44 00 00 48 8d 05 91 e8 2c 00 8b 00 85 c0 75 13 31
c0 0f 05 <48> 3d 00 f0 ff ff 77 57 c3 66 0f 1f 44 00 00 41 54 49 89 d4
55 48
[   90.296011] RSP: 002b:00007ffee5028688 EFLAGS: 00000246 ORIG_RAX:
0000000000000000
[   90.303575] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f9596d=
9e071
[   90.310699] RDX: 0000000000020000 RSI: 00007f9597269000 RDI: 00000000000=
00006
[   90.317823] RBP: 0000000000020000 R08: 00000000ffffffff R09: 00000000000=
00000
[   90.324947] R10: 00000000000008c6 R11: 0000000000000246 R12: 00007f95972=
69000
[   90.332071] R13: 0000000000000006 R14: 0000000000000f8e R15: 00000000000=
20000
[   90.339194]
[   90.340684] The buggy address belongs to the page:
[   90.345470] page:ffffea0008a00540 count:1 mapcount:0
mapping:0000000000000000 index:0x0
[   90.353461] flags: 0x200000000000000()
[   90.357215] raw: 0200000000000000 dead000000000100 dead000000000200
0000000000000000
[   90.364952] raw: 0000000000000000 0000000000000000 00000001ffffffff
0000000000000000
[   90.372681] page dumped because: kasan: bad access detected
[   90.378245]
[   90.379736] Memory state around the buggy address:
[   90.384523]  ffff888228015f00: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[   90.391741]  ffff888228015f80: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[   90.398951] >ffff888228016000: fb fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[   90.406161]                    ^
[   90.409407]  ffff888228016080: fc fc fc fc fc fc fc fc fb fb fb fb
fb fb fb fb
[   90.416665]  ffff888228016100: fb fb fb fb fb fb fb fb fc fc fc fc
fc fc fc fc
[   90.423876] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   90.431095] Disabling lock debugging due to kernel taint


steps to reproduce:
- boot x86_64 with kasan enabled 4.19 stable kernel
- cd /opt/ltp
- ./runltp -f tracing

Full test log link,
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/build/v4.19.138-=
49-gb0e1bc72f7dd/testrun/3050053/suite/linux-log-parser/test/check-kernel-b=
ug-1656536/log

kernel-config link,
https://builds.tuxbuild.com/BDfU1nbOpLG7hFIf-nv5dQ/kernel.config

Summary
------------------------------------------------------------------------

kernel: 4.19.139-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: b0e1bc72f7ddff40c7c5b68313d3ac76495d678d
git describe: v4.19.138-49-gb0e1bc72f7dd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.138-49-gb0e1bc72f7dd

No fixes (compared to build v4.19.138)


Ran 34683 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kvm-unit-tests
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* v4l2-compliance
* ltp-commands-tests
* ltp-controllers-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-math-tests
* network-basic-tests
* perf
* libhugetlbfs
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org
