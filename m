Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A332BA847
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbgKTLGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728326AbgKTLGC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:06:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B20622264;
        Fri, 20 Nov 2020 11:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870361;
        bh=AWAuIYhE1zGzfLeJ/1upsbAjHCIpSIOmKhsYOqfDqqw=;
        h=From:To:Cc:Subject:Date:From;
        b=RIb6PmvrxDVi/sn0Yo2mIhLryDBvi7672tBgZ9kEHufR0j9IBDLEbVq1hpa+eeAIf
         TpGxEyQedoPXmMp+4ZTtYTGi0J2yRwDB9AG7IZC90xIioaE1RgTCwKQWeJjo6160oF
         zXVfsu9Rcc8WwV302zxukVxYHqUh4+dyOoWUfKTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/14] 4.19.159-rc1 review
Date:   Fri, 20 Nov 2020 12:03:21 +0100
Message-Id: <20201120104539.806156260@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.159-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.159-rc1
X-KernelTest-Deadline: 2020-11-22T10:45+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.159 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.159-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.159-rc1

Nick Desaulniers <ndesaulniers@google.com>
    ACPI: GED: fix -Wformat

David Edmondson <david.edmondson@oracle.com>
    KVM: x86: clflushopt should be treated as a no-op by emulation

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: proc: can_remove_proc(): silence remove_proc_entry warning

Johannes Berg <johannes.berg@intel.com>
    mac80211: always wind down STA state

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: sunkbd - avoid use-after-free in teardown paths

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: Always fault when _PAGE_ACCESSED is not set

Salvatore Bonaccorso <carnil@debian.org>
    Revert "perf cs-etm: Move definition of 'traceid_list' global variable from header file"

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: flush L1D after user accesses

Nicholas Piggin <npiggin@gmail.com>
    powerpc/uaccess: Evaluate macro arguments once, before user access is allowed

Andrew Donnellan <ajd@linux.ibm.com>
    powerpc: Fix __clear_user() with KUAP enabled

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc: Implement user_access_begin and friends

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc: Add a framework for user access tracking

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: flush L1D on kernel entry

Daniel Axtens <dja@axtens.net>
    powerpc/64s: move some exception handlers out of line


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt |   7 ++
 Makefile                                        |   4 +-
 arch/powerpc/include/asm/book3s/64/kup-radix.h  |  22 ++++
 arch/powerpc/include/asm/exception-64s.h        |   9 +-
 arch/powerpc/include/asm/feature-fixups.h       |  19 +++
 arch/powerpc/include/asm/futex.h                |   4 +
 arch/powerpc/include/asm/kup.h                  |  40 +++++++
 arch/powerpc/include/asm/security_features.h    |   7 ++
 arch/powerpc/include/asm/setup.h                |   4 +
 arch/powerpc/include/asm/uaccess.h              | 147 +++++++++++++++++++-----
 arch/powerpc/kernel/exceptions-64s.S            |  96 +++++++++-------
 arch/powerpc/kernel/head_8xx.S                  |   8 +-
 arch/powerpc/kernel/setup_64.c                  | 122 +++++++++++++++++++-
 arch/powerpc/kernel/vmlinux.lds.S               |  14 +++
 arch/powerpc/lib/checksum_wrappers.c            |   4 +
 arch/powerpc/lib/feature-fixups.c               | 104 +++++++++++++++++
 arch/powerpc/lib/string_32.S                    |   4 +-
 arch/powerpc/lib/string_64.S                    |   6 +-
 arch/powerpc/platforms/powernv/setup.c          |  17 +++
 arch/powerpc/platforms/pseries/setup.c          |   8 ++
 arch/x86/kvm/emulate.c                          |   8 +-
 drivers/acpi/evged.c                            |   2 +-
 drivers/input/keyboard/sunkbd.c                 |  41 +++++--
 net/can/proc.c                                  |   6 +-
 net/mac80211/sta_info.c                         |  18 +++
 tools/perf/util/cs-etm.c                        |   3 -
 tools/perf/util/cs-etm.h                        |   3 +
 27 files changed, 623 insertions(+), 104 deletions(-)


