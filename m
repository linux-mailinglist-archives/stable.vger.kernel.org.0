Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE041FD63A
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfKOGWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbfKOGWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:43 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB9A920801;
        Fri, 15 Nov 2019 06:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798962;
        bh=CgAhgakrXfD1X5gqGHUYuXq/VOonmV1rMSWMQeGDTSw=;
        h=From:To:Cc:Subject:Date:From;
        b=Z+L0s4dQqNCCKm/CUUG2G+nIghcge0DFORPusAQ553ta5k0QRTSKI5FbNVdOFwWEP
         jEGmIYD9xAZfK4fkBzsPNYAIbO3/hjQovUOi4r8FJJMY88yvmF1xN2R+dkcTvDTmuM
         Y9q/8vTlaYdkiweXM6k78RgppQPEPzjJruE2gHYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/31] 4.9.202-stable review
Date:   Fri, 15 Nov 2019 14:20:29 +0800
Message-Id: <20191115062009.813108457@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.202-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.202-rc1
X-KernelTest-Deadline: 2019-11-17T06:20+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.202 release.
There are 31 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 Nov 2019 06:18:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.202-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.202-rc1

Gomez Iglesias, Antonio <antonio.gomez.iglesias@intel.com>
    Documentation: Add ITLB_MULTIHIT documentation

Junaid Shahid <junaids@google.com>
    kvm: x86: mmu: Recovery of shattered NX large pages

Junaid Shahid <junaids@google.com>
    kvm: Add helper function for creating VM worker threads

Paolo Bonzini <pbonzini@redhat.com>
    kvm: mmu: ITLB_MULTIHIT mitigation

Tyler Hicks <tyhicks@canonical.com>
    cpu/speculation: Uninline and export CPU mitigations helpers

Vineela Tummalapalli <vineela.tummalapalli@intel.com>
    x86/bugs: Add ITLB_MULTIHIT bug infrastructure

Paolo Bonzini <pbonzini@redhat.com>
    KVM: vmx, svm: always run with EFER.NXE=1 when shadow paging is active

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: add tracepoints around __direct_map and FNAME(fetch)

Ben Hutchings <ben@decadent.org.uk>
    KVM: x86: Add is_executable_pte()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: change kvm_mmu_page_get_gfn BUG_ON to WARN_ON

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: remove now unneeded hugepage gfn adjustment

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: make FNAME(fetch) and __direct_map more similar

Junaid Shahid <junaids@google.com>
    kvm: x86: Do not release the page inside mmu_set_spte()

Junaid Shahid <junaids@google.com>
    kvm: Convert kvm_lock to a mutex

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: extend usage of RET_MMIO_PF_* constants

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: simplify ept_misconfig

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation/taa: Fix printing of TAA_MSG_SMT on IBRS_ALL CPUs

Michal Hocko <mhocko@suse.com>
    x86/tsx: Add config options to set tsx=on|off|auto

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation/taa: Add documentation for TSX Async Abort

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/tsx: Add "auto" option to the tsx= cmdline parameter

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    kvm/x86: Export MDS_NO=0 to guests when TSX is enabled

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation/taa: Add sysfs reporting for TSX Async Abort

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation/taa: Add mitigation for TSX Async Abort

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/cpu: Add a "tsx=" cmdline option with TSX disabled by default

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/cpu: Add a helper function x86_read_arch_cap_msr()

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/msr: Add the IA32_TSX_CTRL MSR

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: use Intel speculation bugs and features as derived in generic x86 code

Jack Pham <jackp@codeaurora.org>
    usb: gadget: core: unmap request from DMA only if previously mapped

Jonas Gorski <jonas.gorski@gmail.com>
    MIPS: BCM63XX: fix switch core reset on BCM6368

Kefeng Wang <wangkefeng.wang@huawei.com>
    Bluetooth: hci_ldisc: Postpone HCI_UART_PROTO_READY bit set in hci_uart_set_proto()

Junaid Shahid <junaids@google.com>
    kvm: mmu: Don't read PDPTEs when paging is not enabled


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |   2 +
 Documentation/hw-vuln/index.rst                    |   2 +
 Documentation/hw-vuln/multihit.rst                 | 163 ++++++++
 Documentation/hw-vuln/tsx_async_abort.rst          | 276 +++++++++++++
 Documentation/kernel-parameters.txt                |  92 +++++
 Documentation/virtual/kvm/locking.txt              |   6 +-
 Documentation/x86/index.rst                        |   1 +
 Documentation/x86/tsx_async_abort.rst              | 117 ++++++
 Makefile                                           |   4 +-
 arch/mips/bcm63xx/reset.c                          |   2 +-
 arch/s390/kvm/kvm-s390.c                           |   4 +-
 arch/x86/Kconfig                                   |  45 ++
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/include/asm/kvm_host.h                    |   6 +
 arch/x86/include/asm/msr-index.h                   |  16 +
 arch/x86/include/asm/nospec-branch.h               |   4 +-
 arch/x86/include/asm/processor.h                   |   7 +
 arch/x86/kernel/cpu/Makefile                       |   2 +-
 arch/x86/kernel/cpu/bugs.c                         | 161 +++++++-
 arch/x86/kernel/cpu/common.c                       |  93 +++--
 arch/x86/kernel/cpu/cpu.h                          |  18 +
 arch/x86/kernel/cpu/intel.c                        |   5 +
 arch/x86/kernel/cpu/tsx.c                          | 140 +++++++
 arch/x86/kvm/cpuid.c                               |   8 +
 arch/x86/kvm/mmu.c                                 | 452 +++++++++++++++++----
 arch/x86/kvm/mmu.h                                 |  21 +-
 arch/x86/kvm/mmutrace.h                            |  59 +++
 arch/x86/kvm/paging_tmpl.h                         |  79 ++--
 arch/x86/kvm/svm.c                                 |  10 +-
 arch/x86/kvm/vmx.c                                 |  27 +-
 arch/x86/kvm/x86.c                                 |  61 ++-
 drivers/base/cpu.c                                 |  17 +
 drivers/bluetooth/hci_ldisc.c                      |   3 +-
 drivers/usb/gadget/udc/core.c                      |   5 +-
 include/linux/cpu.h                                |  30 +-
 include/linux/kvm_host.h                           |   8 +-
 include/linux/usb/gadget.h                         |   2 +
 kernel/cpu.c                                       |  27 +-
 virt/kvm/kvm_main.c                                | 132 +++++-
 39 files changed, 1855 insertions(+), 254 deletions(-)


