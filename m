Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A972A16D9
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgJaLlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727498AbgJaLk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:40:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAD4920731;
        Sat, 31 Oct 2020 11:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144458;
        bh=55G2cAWKKc6e1oEh3HBW+15I+qOJxIYYyVt2NGy7h4A=;
        h=From:To:Cc:Subject:Date:From;
        b=gKwVKeQpaIGURL6S5t0n5z4l0Wtlt+NY5qsqnW+MRcKcfew4HxmpAgStp8ZL+FiTG
         s7953UaGk+B0A/DlfkM5KmW0kVv53BUVtcO+RW08ELmFkYawFAhEY3mZJZSDKdDYrl
         QrguDnf/znAhM6IxgfBldE6E0aOVjCB1/XixRMnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.8 00/70] 5.8.18-rc1 review
Date:   Sat, 31 Oct 2020 12:35:32 +0100
Message-Id: <20201031113459.481803250@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.8.18-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.8.18-rc1
X-KernelTest-Deadline: 2020-11-02T11:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-------------------------
Note, this is going to be the LAST 5.8.y kernel release.  After this
one, this branch is now end-of-life.  Please move to the 5.9.y branch at
this point in time.
-------------------------

This is the start of the stable review cycle for the 5.8.18 release.
There are 70 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 02 Nov 2020 11:34:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.18-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.8.18-rc1

Pali Rohár <pali@kernel.org>
    phy: marvell: comphy: Convert internal SMCC firmware return codes to errno

Ricky Wu <ricky_wu@realtek.com>
    misc: rtsx: do not setting OC_POWER_DOWN reg in rtsx_pci_init_ocp()

Stafford Horne <shorne@gmail.com>
    openrisc: Fix issue with get_user for 64-bit values

Souptick Joarder <jrdr.linux@gmail.com>
    xen/gntdev.c: Mark pages as dirty

Geert Uytterhoeven <geert+renesas@glider.be>
    ata: sata_rcar: Fix DMA boundary mask

Grygorii Strashko <grygorii.strashko@ti.com>
    PM: runtime: Fix timer_expires data type on 32-bit arches

Peter Zijlstra <peterz@infradead.org>
    serial: pl011: Fix lockdep splat when handling magic-sysrq interrupt

Paras Sharma <parashar@codeaurora.org>
    serial: qcom_geni_serial: To correct QUP Version detection logic

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gem: Serialise debugfs i915_gem_objects with ctx->mutex

Gustavo A. R. Silva <gustavo@embeddedor.com>
    mtd: lpddr: Fix bad logic in print_drs_error

Jason Gunthorpe <jgg@nvidia.com>
    RDMA/addr: Fix race with netevent_callback()/rdma_addr_cancel()

Frederic Barrat <fbarrat@linux.ibm.com>
    cxl: Rework error message for incompatible slots

Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
    p54: avoid accessing the data mapped to streaming DMA

Roberto Sassu <roberto.sassu@huawei.com>
    evm: Check size of security.evm before using it

Song Liu <songliubraving@fb.com>
    bpf: Fix comment for helper bpf_current_task_under_cgroup()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix page dereference after free

Pali Rohár <pali@kernel.org>
    ata: ahci: mvebu: Make SATA PHY optional for Armada 3720

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix initialization with old Marvell's Arm Trusted Firmware

Juergen Gross <jgross@suse.com>
    x86/xen: disable Firmware First mode for correctable memory errors

Thomas Gleixner <tglx@linutronix.de>
    x86/traps: Fix #DE Oops message regression

Kim Phillips <kim.phillips@amd.com>
    arch/x86/amd/ibs: Fix re-arming IBS Fetch

Gao Xiang <hsiangkao@redhat.com>
    erofs: avoid duplicated permission check for "trusted." xattrs

Leon Romanovsky <leonro@nvidia.com>
    net: protect tcf_block_unbind with block lock

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix memory leak caused by tipc_buf_append()

Arjun Roy <arjunroy@google.com>
    tcp: Prevent low rmem stalls with SO_RCVLOWAT.

Andrew Gabbasov <andrew_gabbasov@mentor.com>
    ravb: Fix bit fields checking in ravb_hwtstamp_get()

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix issue with forced threading in combination with shared interrupts

Guillaume Nault <gnault@redhat.com>
    net/sched: act_mpls: Add softdep on mpls_gso.ko

Alex Elder <elder@linaro.org>
    net: ipa: command payloads already mapped

Zenghui Yu <yuzenghui@huawei.com>
    net: hns3: Clear the CMDQ registers before unmapping BAR region

Aleksandr Nogikh <nogikh@google.com>
    netem: fix zero division in tabledist

Ido Schimmel <idosch@nvidia.com>
    mlxsw: core: Fix memory leak on module removal

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: fix ibmvnic_set_mac

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    ibmveth: Fix use of ibmveth in a bridge.

Masahiro Fujiwara <fujiwara.masahiro@gmail.com>
    gtp: fix an use-before-init in gtp_newlink()

Raju Rangoju <rajur@chelsio.com>
    cxgb4: set up filter action after rewrites

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix tls record info to user

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix memory leaks in CPL handlers

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix deadlock issue

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Send HWRM_FUNC_RESET fw command unconditionally.

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Re-write PCI BARs after PCI fatal error.

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Invoke cancel_delayed_work_sync() for PFs also.

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix regression in workqueue cleanup logic in bnxt_remove_one().

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Check abort error state in bnxt_open_nic().

Michael Schaller <misch@google.com>
    efivarfs: Replace invalid slashes with exclamation marks in dentries.

Dan Williams <dan.j.williams@intel.com>
    x86/copy_mc: Introduce copy_mc_enhanced_fast_string()

Dan Williams <dan.j.williams@intel.com>
    x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()

Randy Dunlap <rdunlap@infradead.org>
    x86/PCI: Fix intel_mid_pci.c build error when ACPI is not enabled

Nick Desaulniers <ndesaulniers@google.com>
    arm64: link with -z norelro regardless of CONFIG_RELOCATABLE

Marc Zyngier <maz@kernel.org>
    arm64: Run ARCH_WORKAROUND_2 enabling code on all CPUs

Marc Zyngier <maz@kernel.org>
    arm64: Run ARCH_WORKAROUND_1 enabling code on all CPUs

Kees Cook <keescook@chromium.org>
    fs/kernel_read_file: Remove FIRMWARE_EFI_EMBEDDED enum

Ard Biesheuvel <ardb@kernel.org>
    efi/arm64: libstub: Deal gracefully with EFI_RNG_PROTOCOL failure

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    scripts/setlocalversion: make git describe output more reliable

Matthew Wilcox (Oracle) <willy@infradead.org>
    io_uring: Convert advanced XArray uses to the normal API

Matthew Wilcox (Oracle) <willy@infradead.org>
    io_uring: Fix XArray usage in io_uring_add_task_file

Matthew Wilcox (Oracle) <willy@infradead.org>
    io_uring: Fix use of XArray in __io_uring_files_cancel

Jens Axboe <axboe@kernel.dk>
    io_uring: no need to call xa_destroy() on empty xarray

Hillf Danton <hdanton@sina.com>
    io-wq: fix use-after-free in io_wq_worker_running

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    io_wq: Make io_wqe::lock a raw_spinlock_t

Jens Axboe <axboe@kernel.dk>
    io_uring: reference ->nsproxy for file table commands

Jens Axboe <axboe@kernel.dk>
    io_uring: don't rely on weak ->files references

Jens Axboe <axboe@kernel.dk>
    io_uring: enable task/files specific overflow flushing

Jens Axboe <axboe@kernel.dk>
    io_uring: return cancelation status from poll/timeout/files handlers

Jens Axboe <axboe@kernel.dk>
    io_uring: unconditionally grab req->task

Jens Axboe <axboe@kernel.dk>
    io_uring: stash ctx task reference for SQPOLL

Jens Axboe <axboe@kernel.dk>
    io_uring: move dropping of files into separate helper

Jens Axboe <axboe@kernel.dk>
    io_uring: allow timeout/poll/files killing to take task into account

Jens Axboe <axboe@kernel.dk>
    io_uring: don't run task work on an exiting task

Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
    netfilter: nftables_offload: KASAN slab-out-of-bounds Read in nft_flow_rule_create


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/Makefile                                |   4 +-
 arch/arm64/kernel/cpu_errata.c                     |  15 +
 arch/openrisc/include/asm/uaccess.h                |  35 +-
 arch/powerpc/Kconfig                               |   2 +-
 arch/powerpc/include/asm/string.h                  |   2 -
 arch/powerpc/include/asm/uaccess.h                 |  40 +-
 arch/powerpc/lib/Makefile                          |   2 +-
 .../lib/{memcpy_mcsafe_64.S => copy_mc_64.S}       |   4 +-
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/Kconfig.debug                             |   2 +-
 arch/x86/events/amd/ibs.c                          |  15 +-
 arch/x86/include/asm/copy_mc_test.h                |  75 ++++
 arch/x86/include/asm/mce.h                         |   9 +
 arch/x86/include/asm/mcsafe_test.h                 |  75 ----
 arch/x86/include/asm/string_64.h                   |  32 --
 arch/x86/include/asm/uaccess.h                     |   9 +
 arch/x86/include/asm/uaccess_64.h                  |  20 -
 arch/x86/kernel/cpu/mce/core.c                     |   8 +-
 arch/x86/kernel/quirks.c                           |  10 +-
 arch/x86/kernel/traps.c                            |   2 +-
 arch/x86/lib/Makefile                              |   1 +
 arch/x86/lib/copy_mc.c                             |  96 +++++
 arch/x86/lib/copy_mc_64.S                          | 163 +++++++
 arch/x86/lib/memcpy_64.S                           | 115 -----
 arch/x86/lib/usercopy_64.c                         |  21 -
 arch/x86/pci/intel_mid_pci.c                       |   1 +
 arch/x86/xen/enlighten_pv.c                        |   9 +
 drivers/ata/ahci.h                                 |   2 +
 drivers/ata/ahci_mvebu.c                           |   2 +-
 drivers/ata/libahci_platform.c                     |   2 +-
 drivers/ata/sata_rcar.c                            |   2 +-
 drivers/base/firmware_loader/fallback_platform.c   |   2 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c            |  29 +-
 drivers/crypto/chelsio/chtls/chtls_io.c            |   7 +-
 drivers/firmware/efi/libstub/arm64-stub.c          |   8 +-
 drivers/firmware/efi/libstub/fdt.c                 |   4 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |   2 +
 drivers/infiniband/core/addr.c                     |  11 +-
 drivers/md/dm-writecache.c                         |  15 +-
 drivers/misc/cardreader/rtsx_pcr.c                 |   4 -
 drivers/misc/cxl/pci.c                             |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  49 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |  56 ++-
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h        |   4 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   2 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |   6 -
 drivers/net/ethernet/ibm/ibmvnic.c                 |   8 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   2 +
 drivers/net/ethernet/realtek/r8169_main.c          |   4 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  10 +-
 drivers/net/gtp.c                                  |  16 +-
 drivers/net/ipa/gsi_trans.c                        |  21 +-
 drivers/net/wireless/intersil/p54/p54pci.c         |   4 +-
 drivers/nvdimm/claim.c                             |   2 +-
 drivers/nvdimm/pmem.c                              |   6 +-
 drivers/pci/controller/pci-aardvark.c              |   4 +-
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c       |  14 +-
 drivers/phy/marvell/phy-mvebu-cp110-comphy.c       |  14 +-
 drivers/tty/serial/amba-pl011.c                    |  11 +-
 drivers/tty/serial/qcom_geni_serial.c              |   2 +-
 drivers/xen/gntdev.c                               |  17 +-
 fs/efivarfs/super.c                                |   3 +
 fs/erofs/xattr.c                                   |   2 -
 fs/exec.c                                          |   6 +
 fs/file.c                                          |   2 +
 fs/fuse/dev.c                                      |  28 +-
 fs/io-wq.c                                         | 172 ++++----
 fs/io-wq.h                                         |   1 +
 fs/io_uring.c                                      | 475 ++++++++++++++++-----
 include/linux/fs.h                                 |   1 -
 include/linux/io_uring.h                           |  53 +++
 include/linux/mtd/pfow.h                           |   2 +-
 include/linux/pm.h                                 |   2 +-
 include/linux/qcom-geni-se.h                       |   3 +
 include/linux/sched.h                              |   5 +
 include/linux/string.h                             |   9 +-
 include/linux/uaccess.h                            |  13 +
 include/linux/uio.h                                |  10 +-
 include/net/netfilter/nf_tables.h                  |   6 +
 include/uapi/linux/bpf.h                           |   4 +-
 init/init_task.c                                   |   3 +
 kernel/fork.c                                      |   6 +
 lib/Kconfig                                        |   7 +-
 lib/iov_iter.c                                     |  48 +--
 net/ipv4/tcp.c                                     |   2 +
 net/ipv4/tcp_input.c                               |   3 +-
 net/netfilter/nf_tables_api.c                      |   6 +-
 net/netfilter/nf_tables_offload.c                  |   4 +-
 net/sched/act_mpls.c                               |   1 +
 net/sched/cls_api.c                                |   4 +-
 net/sched/sch_netem.c                              |   9 +-
 net/tipc/msg.c                                     |   5 +-
 scripts/setlocalversion                            |  21 +-
 security/integrity/evm/evm_main.c                  |   6 +
 tools/arch/x86/include/asm/mcsafe_test.h           |  13 -
 tools/arch/x86/lib/memcpy_64.S                     | 115 -----
 tools/include/uapi/linux/bpf.h                     |   4 +-
 tools/objtool/check.c                              |   5 +-
 tools/perf/bench/Build                             |   1 -
 tools/perf/bench/mem-memcpy-x86-64-lib.c           |  24 --
 tools/testing/nvdimm/test/nfit.c                   |  49 +--
 .../testing/selftests/powerpc/copyloops/.gitignore |   2 +-
 tools/testing/selftests/powerpc/copyloops/Makefile |   6 +-
 .../selftests/powerpc/copyloops/copy_mc_64.S       | 242 +++++++++++
 106 files changed, 1595 insertions(+), 908 deletions(-)


