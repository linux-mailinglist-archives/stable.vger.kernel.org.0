Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3BA2197D9
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 07:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgGIF2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 01:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgGIF2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 01:28:19 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0FBC08C5CE
        for <stable@vger.kernel.org>; Wed,  8 Jul 2020 22:28:18 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id o4so428704lfi.7
        for <stable@vger.kernel.org>; Wed, 08 Jul 2020 22:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ySh/t8XZUjOZrmEcXjkptrMTpbE4Je11LRVJDLN5IEE=;
        b=p2zQgEeF6kNJ77j+HMCUgTM+UoHtHIb5KA0OzCSlRnP3tlsY9L+xNSqno+croGPWAr
         aKoP83P1v2VvtGn+vQDVxQONzdNBliINjF4UZdVwV+LgOVvAEu2pQmk6eec/I4vJvi4Q
         x2volSWV2N2Bx/ZGnjpTlu79tad7d6ux3iF3Njc/w5R+HuZKI7QyuxVRdorSY35ZX3JK
         yXvu2ppwaWFPMJhd+/lutNhu2FpTtwum0Ti6HFjMSIUYxHYwKMpdHW3GEFhL6kznPhCa
         HV466S7gmBe2VYJfgv1duOZVEH9KsYsWluooEGCBy3kzhShNMkA9pVj4pp5C9N0wTvwy
         UCDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ySh/t8XZUjOZrmEcXjkptrMTpbE4Je11LRVJDLN5IEE=;
        b=lkNisA70dpLHXWx8dZ/UzW8y06vHJfbPnU9GTpvn25VIZ0RZakTalRMdNC/5mE4kdT
         NWcX2jfyWImVle+Pq03ZDJEPcQJSnpNvX5PEq7Lt1AUg8pQ3WDFJLMopa4NG9kpJi2kR
         NefRlAkD8Db0I8Jtzvrd5RQgTv3gQ8BgAwIi4COV6ZWlOS7IJ1Z0w8FqZX+vRlBH1TeR
         hP2apLZjsVqFf3mfBJ8WPfCRvXTV5sUAXbTpqxMyRyXPGmOm78vntYUzOJTOo9exbldi
         +RNgrDzQVVY5IFkZenkdSwnO4xOJQogKncSI26wOnv1AnBPTLkjHjo2+NSg29RYFqbLs
         fIxg==
X-Gm-Message-State: AOAM533GK0Gy2NT7+lxAWD4Dubba1j6YUDa34Za5x+h0bo7VNGu+1CkO
        spRFGFbciZLvOj8J9VQJOGiHk1z/CN082wkaHYzqz606xm9zRQ==
X-Google-Smtp-Source: ABdhPJxwPQqJg6UTdhORivgztr+NJ/dO+PwFNFNn0RtE1ZcUTtMCahpJsDzAqvh5olNrlAm4yg+WFKdntd0GHJhRSTM=
X-Received: by 2002:a05:6512:74f:: with SMTP id c15mr28440301lfs.26.1594272496260;
 Wed, 08 Jul 2020 22:28:16 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 9 Jul 2020 10:58:04 +0530
Message-ID: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
Subject: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>,
        lkft-triage@lists.linaro.org, Chris Down <chris@chrisdown.name>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Fan_Yang@sjtu.edu.cn,
        bgeffon@google.com, anshuman.khandual@arm.com,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, pugaowei@gmail.com,
        jglisse@redhat.com, Joel Fernandes <joel@joelfernandes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While running LTP mm test suite on i386 or qemu_i386 this kernel warning
has been noticed from stable 5.4 to stable 5.7 branches and mainline 5.8.0-rc4
and linux next.

metadata:
  git branch: master
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  git commit: dcb7fd82c75ee2d6e6f9d8cc71c52519ed52e258
  kernel-config:
https://builds.tuxbuild.com/zFkvGKyEbfYdZOMzwrbl-w/kernel.config
  vmlinux: https://builds.tuxbuild.com/zFkvGKyEbfYdZOMzwrbl-w/vmlinux.xz
  system.map: https://builds.tuxbuild.com/zFkvGKyEbfYdZOMzwrbl-w/System.map

steps to reproduce:
- boot i386 kernel or qemu_i386 device
- cd /opt/ltp
- ./runltp -f mm

code snippet:
file: mm/mremap.c
#ifdef CONFIG_HAVE_MOVE_PMD
static bool move_normal_pmd(struct vm_area_struct *vma, unsigned long old_addr,
...
/*
* The destination pmd shouldn't be established, free_pgtables()
* should have release it.
*/
if (WARN_ON(!pmd_none(*new_pmd)))
return false;


------------[ cut here ]------------
[  720.642524] WARNING: CPU: 3 PID: 27091 at mm/mremap.c:211
move_page_tables+0x6ef/0x720
[  720.650437] Modules linked in: x86_pkg_temp_thermal
[  720.655314] CPU: 3 PID: 27091 Comm: true Not tainted 5.8.0-rc4 #1
[  720.661408] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[  720.668886] EIP: move_page_tables+0x6ef/0x720
[  720.673245] Code: 85 0c ff ff ff 8b 45 08 8b 4d d4 05 00 00 40 00
25 00 00 c0 ff 2b 45 08 39 c1 0f 46 c1 89 45 d4 01 f0 89 45 cc e9 d6
fa ff ff <0f> 0b 80 7d be 00 0f 84 80 fd ff ff e9 02 fe ff ff a8 80 0f
84 4d
[  720.691990] EAX: f3250bf8 EBX: f3250bfc ECX: 8c46a067 EDX: 000002fe
[  720.698249] ESI: bfc00000 EDI: f3250bf8 EBP: eea31dd4 ESP: eea31d74
[  720.704514] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010282
[  720.711353] CR0: 80050033 CR2: b7d9e3b0 CR3: 33250000 CR4: 003406d0
[  720.717634] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  720.723952] DR6: fffe0ff0 DR7: 00000400
[  720.727843] Call Trace:
[  720.730325]  setup_arg_pages+0x22b/0x310
[  720.734277]  ? get_random_u32+0x49/0x70
[  720.738167]  ? get_random_u32+0x49/0x70
[  720.742006]  load_elf_binary+0x30e/0x10e0
[  720.746019]  __do_execve_file+0x4c3/0x9f0
[  720.750031]  __ia32_sys_execve+0x25/0x30
[  720.753959]  do_syscall_32_irqs_on+0x3d/0x250
[  720.758317]  ? do_user_addr_fault+0x1a0/0x3c0
[  720.762701]  ? __prepare_exit_to_usermode+0x50/0x1a0
[  720.767703]  ? prepare_exit_to_usermode+0x8/0x20
[  720.772349]  do_fast_syscall_32+0x39/0xb0
[  720.776361]  do_SYSENTER_32+0x15/0x20
[  720.780028]  entry_SYSENTER_32+0x9f/0xf2
[  720.783951] EIP: 0xb7f1d549
[  720.786741] Code: Bad RIP value.
[  720.789965] EAX: ffffffda EBX: bfbbc7c0 ECX: 08067420 EDX: bfbbc9f4
[  720.796225] ESI: 08058a14 EDI: bfbbc7c9 EBP: bfbbc868 ESP: bfbbc798
[  720.802489] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292
[  720.809276] ---[ end trace bc662e76cba2d081 ]---
[  724.934902] ------------[ cut here ]------------
------------[ cut here ]------------
[  738.099993] WARNING: CPU: 1 PID: 29339 at mm/mremap.c:211
move_page_tables+0x6ef/0x720
[  738.107928] Modules linked in: x86_pkg_temp_thermal
[  738.112860] CPU: 1 PID: 29339 Comm: true Tainted: G        W
 5.8.0-rc4 #1
[  738.120374] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[  738.127904] EIP: move_page_tables+0x6ef/0x720
[  738.132316] Code: 85 0c ff ff ff 8b 45 08 8b 4d d4 05 00 00 40 00
25 00 00 c0 ff 2b 45 08 39 c1 0f 46 c1 89 45 d4 01 f0 89 45 cc e9 d6
fa ff ff <0f> 0b 80 7d be 00 0f 84 80 fd ff ff e9 02 fe ff ff a8 80 0f
84 4d
[  738.151112] EAX: e0f3bbf8 EBX: e0f3bbfc ECX: 8c4b8067 EDX: 000002fe
[  738.157422] ESI: bfc00000 EDI: e0f3bbf8 EBP: f3809dd4 ESP: f3809d74
[  738.163756] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010282
[  738.170587] CR0: 80050033 CR2: b7d9e3b0 CR3: 20f3b000 CR4: 003406d0
[  738.176895] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  738.183179] DR6: fffe0ff0 DR7: 00000400
[  738.187019] Call Trace:
[  738.189489]  setup_arg_pages+0x22b/0x310
[  738.193423]  ? get_random_u32+0x49/0x70
[  738.197280]  ? get_random_u32+0x49/0x70
[  738.201119]  load_elf_binary+0x30e/0x10e0
[  738.205159]  __do_execve_file+0x4c3/0x9f0
[  738.209198]  __ia32_sys_execve+0x25/0x30
[  738.213122]  do_syscall_32_irqs_on+0x3d/0x250
[  738.217484]  ? do_user_addr_fault+0x1a0/0x3c0
[  738.221841]  ? __prepare_exit_to_usermode+0x50/0x1a0
[  738.226808]  ? prepare_exit_to_usermode+0x8/0x20
[  738.231427]  do_fast_syscall_32+0x39/0xb0
[  738.235438]  do_SYSENTER_32+0x15/0x20
[  738.239107]  entry_SYSENTER_32+0x9f/0xf2
[  738.243030] EIP: 0xb7f1d549
[  738.245830] Code: Bad RIP value.
[  738.249067] EAX: ffffffda EBX: bfbbc7c0 ECX: 08067420 EDX: bfbbc9f4
[  738.255331] ESI: 08058a14 EDI: bfbbc7c9 EBP: bfbbc868 ESP: bfbbc798
[  738.261595] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292
[  738.268382] ---[ end trace bc662e76cba2d083 ]---
[  770.832465] true (1218) used greatest stack depth: 5252 bytes left
[  781.451530] ------------[ cut here ]------------
------------[ cut here ]------------
[  784.798244] WARNING: CPU: 3 PID: 3053 at mm/mremap.c:211
move_page_tables+0x6ef/0x720
[  784.806090] Modules linked in: x86_pkg_temp_thermal
[  784.811007] CPU: 3 PID: 3053 Comm: true Tainted: G        W
5.8.0-rc4 #1
[  784.818449] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[  784.825928] EIP: move_page_tables+0x6ef/0x720
[  784.830341] Code: 85 0c ff ff ff 8b 45 08 8b 4d d4 05 00 00 40 00
25 00 00 c0 ff 2b 45 08 39 c1 0f 46 c1 89 45 d4 01 f0 89 45 cc e9 d6
fa ff ff <0f> 0b 80 7d be 00 0f 84 80 fd ff ff e9 02 fe ff ff a8 80 0f
84 4d
[  784.849138] EAX: e0663bf8 EBX: e0663bfc ECX: 8c463067 EDX: 000002fe
[  784.855456] ESI: bfc00000 EDI: e0663bf8 EBP: f3e39dd4 ESP: f3e39d74
[  784.861750] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010282
[  784.868532] CR0: 80050033 CR2: b7d9e3b0 CR3: 20663000 CR4: 003406d0
[  784.874843] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  784.881160] DR6: fffe0ff0 DR7: 00000400
[  784.885053] Call Trace:
[  784.887522]  setup_arg_pages+0x22b/0x310
[  784.891483]  ? get_random_u32+0x49/0x70
[  784.895347]  ? get_random_u32+0x49/0x70
[  784.899232]  load_elf_binary+0x30e/0x10e0
[  784.903295]  __do_execve_file+0x4c3/0x9f0
[  784.907359]  __ia32_sys_execve+0x25/0x30
[  784.911339]  do_syscall_32_irqs_on+0x3d/0x250
[  784.915750]  ? do_user_addr_fault+0x1a0/0x3c0
[  784.920161]  ? __prepare_exit_to_usermode+0x50/0x1a0
[  784.925180]  ? prepare_exit_to_usermode+0x8/0x20
[  784.929799]  do_fast_syscall_32+0x39/0xb0
[  784.933862]  do_SYSENTER_32+0x15/0x20
[  784.937580]  entry_SYSENTER_32+0x9f/0xf2
[  784.941557] EIP: 0xb7f1d549
[  784.944399] Code: Bad RIP value.
[  784.947624] EAX: ffffffda EBX: bfbbc7c0 ECX: 08067420 EDX: bfbbc9f4
[  784.953944] ESI: 08058a14 EDI: bfbbc7c9 EBP: bfbbc868 ESP: bfbbc798
[  784.960261] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292
[  784.967097] ---[ end trace bc662e76cba2d085 ]---
[  792.443236] ------------[ cut here ]------------


full test log,
https://lkft.validation.linaro.org/scheduler/job/1541788#L9308

--
Linaro LKFT
https://lkft.linaro.org
