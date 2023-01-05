Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A711165E81F
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 10:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjAEJox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 04:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbjAEJow (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 04:44:52 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5025470E
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 01:44:51 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id i185so4054939vsc.6
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 01:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3toQXUWWPCcvltIO7u9Wn10hSBHJoQ6TUMDeTDfT/fc=;
        b=atep7uUtb+zxhTBJ+hGEP68PwdoXUqeZB4/OWzzhkITRaOAGHztYd/QfoWt4G3mMBj
         9+vICojJnySUJ6qaCESiryRM6KhFqr6KD+SZKvCa25Lf8QBt1b5395RC98SeWEbmfGOH
         8HNzrxcgYh+hyrvfSUN+sEAneaBosYOuk/x0vM5zsQOE7TN+XJgCYcPGHrkhO69sSmQH
         eJfHhnc8xlXyqHjio6E1gPcS/koqkrqbAXj+wK0N9opPEB5L1/K+axw7O0NF81oCau+6
         BPs6XcJR/qrbmMjs3zkQqVF8DL9PAMdXgkiKCIGSm14vGVm02IrR+51HSFMvCGwesOo0
         mLSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3toQXUWWPCcvltIO7u9Wn10hSBHJoQ6TUMDeTDfT/fc=;
        b=yyovsPcmloQkxZwtknRw12nx5dy1y9gPnNvDWMu7RVgf8OGzclIVLqja8C2WWG0IZw
         KdbNPsr7LgN/AdU6iBW7I/NIW4EYAJStFEtWY8nUxW1p53goNfDOzoz01h6zNvh32ytF
         lujb36YwQmTLnLLhVj+/sSkLSu/16pdb8OWAH9lJcGf+gs6Y5ddw2tUdd8V+8omUOmQ1
         AQMjQYlx4AE9nf+oykJdNsAlLMgMZyZAjxPCJZ0ElQRHIXCSCln/O7akceRFmd4Nv6Vc
         qKl+3BeUb6+8yJ34qc4QfEoGiH9q7xpy72qY9JsbPDVbuvt2ipdEZ2yvXM66KfF4SvbS
         jA1g==
X-Gm-Message-State: AFqh2kqGkW2dBsDREPUB6gpsd5cQWByPOP/N12JeMYxQ88Jz+sRlyrAP
        LBUnH0gIsoRsFNGJyF/x8FuxtJY+DVubaqnLoR0MVhgYKkzjttoY
X-Google-Smtp-Source: AMrXdXt3n/sZhnaK52Jh5rEIWCW4sc9q839sYD5svAgMfQxgJC/9Tev5bANJTmfvz3NKHbT00zIOXp19WY5MVtAvpyY=
X-Received: by 2002:a05:6102:c4e:b0:3c8:c513:197 with SMTP id
 y14-20020a0561020c4e00b003c8c5130197mr3877679vss.9.1672911890351; Thu, 05 Jan
 2023 01:44:50 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 5 Jan 2023 15:14:39 +0530
Message-ID: <CA+G9fYuei_Tr-vN9GS7SfFyU1y9hNysnf=PB7kT0=yv4MiPgVg@mail.gmail.com>
Subject: selftests: memfd: run_hugetlbfs_test.sh - invalid opcode: 0000 [#1]
 PREEMPT SMP
To:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Jeff Xu <jeffxu@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Pranith Kumar <bobby.prani@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While running selftests: memfd: run_hugetlbfs_test.sh on qemu_i386 and i386 the
following invalid opcode was noticed on stable-rc 6.1 and  6.0.

This is always reproducible on stable-rc 6.1 and  6.0 with qemu_i386 and i386.
Build, config and test log details provided in the below links [1].

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

# selftests: memfd: run_hugetlbfs_test.sh
[  111.866742] run_hugetlbfs_t (1023): drop_caches: 3
[  111.892484] invalid opcode: 0000 [#1] PREEMPT SMP
[  111.893089] CPU: 2 PID: 1026 Comm: memfd_test Tainted: G
     N 6.1.4-rc1 #1
[  111.894015] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[  111.895048] EIP: hugetlb_file_setup.cold+0x0/0x33
[  111.895597] Code: ff e9 07 f3 26 ff 0f 0b c7 04 24 c8 ee dd c9 e8
25 47 ff ff b8 ea ff ff ff e9 ac f8 26 ff 0f 0b 0f 0b 0f 0b 0f 0b 0f
0b 0f 0b <0f> 0b 64 a1 98 48 3a ca c6 05 f3 42 22 ca 01 8b 90 d4 03 00
00 05
[  111.897716] EAX: c4957128 EBX: 00000000 ECX: 00000020 EDX: 00000000
[  111.898431] ESI: 80000004 EDI: 00000005 EBP: c552bf04 ESP: c552bee4
[  111.899218] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010212
[  111.899991] CR0: 80050033 CR2: 00000000 CR3: 0528b000 CR4: 003506d0
[  111.900774] Call Trace:
[  111.901072]  __ia32_sys_memfd_create+0x196/0x220
[  111.901616]  __do_fast_syscall_32+0x77/0xd0
[  111.902119]  do_fast_syscall_32+0x32/0x70
[  111.902620]  do_SYSENTER_32+0x15/0x20
[  111.903134]  entry_SYSENTER_32+0x98/0xf6
[  111.903701] EIP: 0xb7ef1549
[  111.904034] Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01
10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[  111.906124] EAX: ffffffda EBX: 0804b486 ECX: 80000004 EDX: 080493de
[  111.906902] ESI: b7ccf220 EDI: b7dc58e0 EBP: bfe56cf8 ESP: bfe56c8c
[  111.907637] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292
[  111.908502] Modules linked in: sch_fq_codel fuse configfs [last
unloaded: test_strscpy(N)]
[  111.909502] ---[ end trace 0000000000000000 ]---
[  111.910064] EIP: hugetlb_file_setup.cold+0x0/0x33
[  111.910638] Code: ff e9 07 f3 26 ff 0f 0b c7 04 24 c8 ee dd c9 e8
25 47 ff ff b8 ea ff ff ff e9 ac f8 26 ff 0f 0b 0f 0b 0f 0b 0f 0b 0f
0b 0f 0b <0f> 0b 64 a1 98 48 3a ca c6 05 f3 42 22 ca 01 8b 90 d4 03 00
00 05
[  111.912785] EAX: c4957128 EBX: 00000000 ECX: 00000020 EDX: 00000000
[  111.913518] ESI: 80000004 EDI: 00000005 EBP: c552bf04 ESP: c552bee4
[  111.914259] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010212
[  111.915104] CR0: 80050033 CR2: 00000000 CR3: 0528b000 CR4: 003506d0
# ./run_hugetlbfs_test.sh: line 60:  1026 Segmentation fault
./memfd_test hugetlbfs
# opening: ./mnt/memfd
# fuse: DONE
ok 3 selftests: memfd: run_hugetlbfs_test.sh

[1]
https://lkft.validation.linaro.org/scheduler/job/6022150#L2079
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.3-208-ga31425cbf493/testrun/13974189/suite/log-parser-test/tests/
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.3-208-ga31425cbf493/testrun/13974189/suite/log-parser-test/test/check-kernel-invalid-opcode/details/

metadata:
  git_ref: linux-6.1.y
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git_sha: a31425cbf493ef8bc7f7ce775a1028b1e0612f32
  git_describe: v6.1.3-208-ga31425cbf493
  kernel_version: 6.1.4-rc1
  kernel-config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzvZc223pctlAxVhCIebJ8q0w/config
  build-url: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/pipelines/738268273
  artifact-location:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzvZc223pctlAxVhCIebJ8q0w
  toolchain: gcc-11
  vmlinux: https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzvZc223pctlAxVhCIebJ8q0w/vmlinux.xz
  System.map: https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzvZc223pctlAxVhCIebJ8q0w/System.map

--
Linaro LKFT
https://lkft.linaro.org
