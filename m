Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F283A0E21
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 09:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236743AbhFIH4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 03:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234750AbhFIH4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 03:56:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F43A6128A;
        Wed,  9 Jun 2021 07:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623225268;
        bh=yK/iicqS3zh4YEz1/GrtBJ/BIAlHNzlc8pwAjCLeDTc=;
        h=From:To:Cc:Subject:Date:From;
        b=0+jc1bEoyoYltensdH+dF6a9Ma5Y+q1DDPw/Nnc5CHdx7A1AzliPXY6yDqN5QuwEq
         CM2doLuiK/G3J7RRh1Rn2mCQ4tu0SohxJE2BobgqHemL/YSg3wX7SW4BLtbvOz613B
         0NnEOji9HG1V3HsP9B8roOUItO82oK364ugXRCf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/57] 4.19.194-rc2 review
Date:   Wed,  9 Jun 2021 09:54:26 +0200
Message-Id: <20210609062858.532803536@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.194-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.194-rc2
X-KernelTest-Deadline: 2021-06-11T06:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.194 release.
There are 57 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 11 Jun 2021 06:28:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.194-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.194-rc2

Jan Beulich <jbeulich@suse.com>
    xen-pciback: redo VF placement in the virtual topology

Cheng Jian <cj.chengjian@huawei.com>
    sched/fair: Optimize select_idle_cpu

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Look for ECDT EC after calling acpi_load_tables()

Erik Schmauss <erik.schmauss@intel.com>
    ACPI: probe ECDT before loading AML tables regardless of module-level code flag

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix debug register indexing

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Truncate GPR value for DR and CR accesses in !64-bit mode

Anand Jain <anand.jain@oracle.com>
    btrfs: fix unmountable seed device after fstrim

Song Liu <songliubraving@fb.com>
    perf/core: Fix corner case in perf_rotate_context()

Ian Rogers <irogers@google.com>
    perf/cgroups: Don't rotate events for cgroups unnecessarily

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Remove the setting of dev_port.

Björn Töpel <bjorn.topel@gmail.com>
    selftests/bpf: Avoid running unprivileged tests with alignment requirements

Björn Töpel <bjorn.topel@gmail.com>
    selftests/bpf: add "any alignment" annotation for some tests

David S. Miller <davem@davemloft.net>
    bpf: Apply F_NEEDS_EFFICIENT_UNALIGNED_ACCESS to more ACCEPT test cases.

David S. Miller <davem@davemloft.net>
    bpf: Make more use of 'any' alignment in test_verifier.c

David S. Miller <davem@davemloft.net>
    bpf: Adjust F_NEEDS_EFFICIENT_UNALIGNED_ACCESS handling in test_verifier.c

David S. Miller <davem@davemloft.net>
    bpf: Add BPF_F_ANY_ALIGNMENT.

Joe Stringer <joe@wand.net.nz>
    selftests/bpf: Generalize dummy program types

Daniel Borkmann <daniel@iogearbox.net>
    bpf: test make sure to run unpriv test cases in test_verifier

Daniel Borkmann <daniel@iogearbox.net>
    bpf: fix test suite to enable all unpriv program types

Mina Almasry <almasrymina@google.com>
    mm, hugetlb: fix simple resv_huge_pages underflow on UFFDIO_COPY

Josef Bacik <josef@toxicpanda.com>
    btrfs: fixup error handling in fixup_inode_link_counts

Josef Bacik <josef@toxicpanda.com>
    btrfs: return errors from btrfs_del_csums in cleanup_ref_head

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix error handling in btrfs_del_csums

Josef Bacik <josef@toxicpanda.com>
    btrfs: mark ordered extent and inode with error if we fail to finish

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Mark _all_ legacy interrupts when IO/APIC is missing

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: fix NULL ptr dereference in llcp_sock_getname() after failed connect

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: fix data corruption by fallocate

Mark Rutland <mark.rutland@arm.com>
    pid: take a reference when initializing `cad_pid`

Phil Elwell <phil@raspberrypi.com>
    usb: dwc2: Fix build in periphal-only mode

Ye Bin <yebin10@huawei.com>
    ext4: fix bug on in ext4_es_cache_extent as ext4_split_extent_at failed

Carlos M <carlos.marr.pz@gmail.com>
    ALSA: hda: Fix for mute key LED for HP Pavilion 15-CK0xx

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Fix master timer notification

Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
    HID: multitouch: require Finger field to mark Win8 reports as MT

Pavel Skripkin <paskripkin@gmail.com>
    net: caif: fix memory leak in cfusbl_device_notify

Pavel Skripkin <paskripkin@gmail.com>
    net: caif: fix memory leak in caif_device_notify

Pavel Skripkin <paskripkin@gmail.com>
    net: caif: add proper error handling

Pavel Skripkin <paskripkin@gmail.com>
    net: caif: added cfserl_release function

Lin Ma <linma@zju.edu.cn>
    Bluetooth: use correct lock to prevent UAF of hdev object

Lin Ma <linma@zju.edu.cn>
    Bluetooth: fix the erroneous flush_work() order

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix unique bearer names sanity check

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: add extack messages for bearer/media failure

Magnus Karlsson <magnus.karlsson@intel.com>
    ixgbevf: add correct exception tracing for XDP

Wei Yongjun <weiyongjun1@huawei.com>
    ieee802154: fix error return code in ieee802154_llsec_getparams()

Zhen Lei <thunder.leizhen@huawei.com>
    ieee802154: fix error return code in ieee802154_add_iface()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches

Arnd Bergmann <arnd@arndb.de>
    HID: i2c-hid: fix format string mismatch

Zhen Lei <thunder.leizhen@huawei.com>
    HID: pidff: fix error return code in hid_pidff_init()

Julian Anastasov <ja@ssi.bg>
    ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service

Max Gurtovoy <mgurtovoy@nvidia.com>
    vfio/platform: fix module_put call in error flow

Wei Yongjun <weiyongjun1@huawei.com>
    samples: vfio-mdev: fix error handing in mdpy_fb_probe()

Randy Dunlap <rdunlap@infradead.org>
    vfio/pci: zap_vma_ptes() needs MMU

Zhen Lei <thunder.leizhen@huawei.com>
    vfio/pci: Fix error return code in vfio_ecap_init()

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    efi: cper: fix snprintf() use in cper_dimm_err_location()

Heiner Kallweit <hkallweit1@gmail.com>
    efi: Allow EFI_MEMORY_XP and EFI_MEMORY_RO both to be cleared

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    nl80211: validate key indexes for cfg80211_registered_device

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: usb: update old-style static const declaration

Grant Grundler <grundler@chromium.org>
    net: usb: cdc_ncm: don't spew notifications


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/arm64/kvm/sys_regs.c                         |  42 ++--
 arch/x86/include/asm/apic.h                       |   1 +
 arch/x86/kernel/apic/apic.c                       |   1 +
 arch/x86/kernel/apic/vector.c                     |  20 ++
 arch/x86/kvm/svm.c                                |   8 +-
 drivers/acpi/bus.c                                |  42 ++--
 drivers/firmware/efi/cper.c                       |   4 +-
 drivers/firmware/efi/memattr.c                    |   5 -
 drivers/hid/hid-multitouch.c                      |  10 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                |   4 +-
 drivers/hid/usbhid/hid-pidff.c                    |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |   1 -
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |   3 +
 drivers/net/usb/cdc_ncm.c                         |  12 +-
 drivers/usb/dwc2/core_intr.c                      |   4 +
 drivers/vfio/pci/Kconfig                          |   1 +
 drivers/vfio/pci/vfio_pci_config.c                |   2 +-
 drivers/vfio/platform/vfio_platform_common.c      |   2 +-
 drivers/xen/xen-pciback/vpci.c                    |  14 +-
 fs/btrfs/extent-tree.c                            |  12 +-
 fs/btrfs/file-item.c                              |  10 +-
 fs/btrfs/inode.c                                  |  12 ++
 fs/btrfs/tree-log.c                               |  13 +-
 fs/ext4/extents.c                                 |  43 +++--
 fs/ocfs2/file.c                                   |  55 +++++-
 include/linux/perf_event.h                        |   5 +
 include/linux/usb/usbnet.h                        |   2 +
 include/net/caif/caif_dev.h                       |   2 +-
 include/net/caif/cfcnfg.h                         |   2 +-
 include/net/caif/cfserl.h                         |   1 +
 include/uapi/linux/bpf.h                          |  14 ++
 init/main.c                                       |   2 +-
 kernel/bpf/syscall.c                              |   7 +-
 kernel/bpf/verifier.c                             |   3 +
 kernel/events/core.c                              |  62 +++---
 kernel/sched/fair.c                               |   7 +-
 mm/hugetlb.c                                      |  14 +-
 net/bluetooth/hci_core.c                          |   7 +-
 net/bluetooth/hci_sock.c                          |   4 +-
 net/caif/caif_dev.c                               |  13 +-
 net/caif/caif_usb.c                               |  14 +-
 net/caif/cfcnfg.c                                 |  16 +-
 net/caif/cfserl.c                                 |   5 +
 net/ieee802154/nl-mac.c                           |   4 +-
 net/ieee802154/nl-phy.c                           |   4 +-
 net/netfilter/ipvs/ip_vs_ctl.c                    |   2 +-
 net/netfilter/nfnetlink_cthelper.c                |   8 +-
 net/nfc/llcp_sock.c                               |   2 +
 net/tipc/bearer.c                                 |  94 ++++++---
 net/wireless/core.h                               |   2 +
 net/wireless/nl80211.c                            |   7 +-
 net/wireless/util.c                               |  39 +++-
 samples/vfio-mdev/mdpy-fb.c                       |  13 +-
 sound/core/timer.c                                |   3 +-
 sound/pci/hda/patch_realtek.c                     |   1 +
 sound/usb/mixer_quirks.c                          |   2 +-
 tools/include/uapi/linux/bpf.h                    |  14 ++
 tools/lib/bpf/bpf.c                               |   8 +-
 tools/lib/bpf/bpf.h                               |   2 +-
 tools/testing/selftests/bpf/test_align.c          |   4 +-
 tools/testing/selftests/bpf/test_verifier.c       | 224 ++++++++++++++++------
 62 files changed, 664 insertions(+), 275 deletions(-)


