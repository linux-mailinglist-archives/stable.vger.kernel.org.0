Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557AD24FACE
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 12:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgHXKAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 06:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbgHXIcx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:32:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49D592074D;
        Mon, 24 Aug 2020 08:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598257971;
        bh=JNrSdZ71yGDba5KkpYOxYAzTTbNQW7o0hhzecmxlxw4=;
        h=From:To:Cc:Subject:Date:From;
        b=iQ1N2qxxYtd+pldXW4zEP5tQlG81/p+J3rxYT2bIXt1gtONnidMoCLBjI40RYqmK4
         VPs077+Cftzj/83DjS5iVxdD1aKXMZBOq/lQGwr8VM3kTIq//7Rs8ida1CYwpxiOLA
         UK4ym0kbvunSpjRGDk6LnJ83opFlvsTgDRySSrxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.8 000/148] 5.8.4-rc1 review
Date:   Mon, 24 Aug 2020 10:28:18 +0200
Message-Id: <20200824082413.900489417@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.8.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.8.4-rc1
X-KernelTest-Deadline: 2020-08-26T08:24+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.8.4 release.
There are 148 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Aug 2020 08:23:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.8.4-rc1

Al Viro <viro@zeniv.linux.org.uk>
    do_epoll_ctl(): clean the failure exits up a bit

Arvind Sankar <nivedita@alum.mit.edu>
    efi/libstub: Handle unterminated cmdline

Arvind Sankar <nivedita@alum.mit.edu>
    efi/libstub: Handle NULL cmdline

Arvind Sankar <nivedita@alum.mit.edu>
    efi/libstub: Stop parsing arguments at "--"

Li Heng <liheng40@huawei.com>
    efi: add missed destroy_workqueue when efisubsys_init fails

Arvind Sankar <nivedita@alum.mit.edu>
    efi/x86: Mark kernel rodata non-executable for mixed mode

Tony Luck <tony.luck@intel.com>
    EDAC/{i7core,sb,pnd2,skx}: Fix error event severity

Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
    powerpc/pseries: Do not initiate shutdown when system is running on UPS

Michael Neuling <mikey@neuling.org>
    powerpc: Fix P10 PVR revision in /proc/cpuinfo for SMT4 cores

Marc Zyngier <maz@kernel.org>
    epoll: Keep a reference on files added to the check list

Tom Rix <trix@redhat.com>
    net: dsa: b53: check for timeout

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix the queue_mapping in netvsc_vf_xmit()

Veronika Kabatova <vkabatov@redhat.com>
    selftests/bpf: Remove test_align leftovers

Wang Hai <wanghai38@huawei.com>
    net: gemini: Fix missing free_netdev() in error path of gemini_ethernet_port_probe()

Shay Agroskin <shayagr@amazon.com>
    net: ena: Change WARN_ON expression in ena_del_napi_in_range()

Shay Agroskin <shayagr@amazon.com>
    net: ena: Prevent reset after device destruction

Jiri Wiesner <jwiesner@suse.com>
    bonding: fix active-backup failover for current ARP slave

Michael Roth <mdroth@linux.vnet.ibm.com>
    powerpc/pseries/hotplug-cpu: wait indefinitely for vCPU death

Yonghong Song <yhs@fb.com>
    bpf: Use get_file_rcu() instead of get_file() for task_file iterator

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/fixmap: Fix the size of the early debug area

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc: Add POWER10 raw mode cputable entry

Stephen Boyd <swboyd@chromium.org>
    ARM64: vdso32: Install vdso32 from vdso_install

David Howells <dhowells@redhat.com>
    afs: Fix NULL deref in afs_dynroot_depopulate()

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: qconf: remove qInfo() to get back Qt4 support

David Howells <dhowells@redhat.com>
    afs: Fix key ref leak in afs_put_operation()

Weihang Li <liweihang@huawei.com>
    Revert "RDMA/hns: Reserve one sge in order to avoid local length error"

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Do not add user qps to flushlist

Randy Dunlap <rdunlap@infradead.org>
    Fix build error when CONFIG_ACPI is not set/enabled:

Juergen Gross <jgross@suse.com>
    efi: avoid error message when booting under Xen

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: qconf: fix signal connection to invalid slots

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: qconf: do not limit the pop-up menu to the first row

Quinn Tran <qutran@marvell.com>
    Revert "scsi: qla2xxx: Disable T10-DIF feature with FC-NVMe during probe"

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: Fix interrupt error message for shared interrupts

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs-pci: Add quirk for broken auto-hibernate for Intel EHL

Kiwoong Kim <kwmad.kim@samsung.com>
    scsi: ufs: Add quirk to fix abnormal ocs fatal error

Alim Akhtar <alim.akhtar@samsung.com>
    scsi: ufs: Introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk

Alim Akhtar <alim.akhtar@samsung.com>
    scsi: ufs: Add quirk to enable host controller without hce

Alim Akhtar <alim.akhtar@samsung.com>
    scsi: ufs: Add quirk to disallow reset of interrupt aggregation

Alim Akhtar <alim.akhtar@samsung.com>
    scsi: ufs: Add quirk to fix mishandling utrlclr/utmrlclr

Jing Xiangfeng <jingxiangfeng@huawei.com>
    scsi: ufs: ti-j721e-ufs: Fix error return in ti_j721e_ufs_probe()

Colin Ian King <colin.king@canonical.com>
    of/address: check for invalid range.cpu_addr

Jim Mattson <jmattson@google.com>
    kvm: x86: Toggling CR4.PKE does not load PDPTEs in PAE mode

Jim Mattson <jmattson@google.com>
    kvm: x86: Toggling CR4.SMAP does not load PDPTEs in PAE mode

Jessica Clarke <jrtc27@jrtc27.com>
    arch/ia64: Restore arch-specific pgd_offset_k implementation

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Add proper error unwind for vfio_iommu_replay()

Alex Williamson <alex.williamson@redhat.com>
    vfio-pci: Avoid recursive read-lock usage

David Howells <dhowells@redhat.com>
    watch_queue: Limit the number of watches a user can hold

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ASoC: intel: Fix memleak in sst_media_open

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: msm8916-wcd-analog: fix register Interrupt offset

Heiko Carstens <hca@linux.ibm.com>
    s390/ptrace: fix storage key handling

Heiko Carstens <hca@linux.ibm.com>
    s390/runtime_instrumentation: fix storage key handling

Mahesh Bandewar <maheshb@google.com>
    ipvlan: fix device features

Cong Wang <xiyou.wangcong@gmail.com>
    bonding: fix a potential double-unregister

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: add rxtimer for multipacket broadcast session

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: abort multipacket broadcast session when timeout occurs

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: cancel rxtimer on multipacket broadcast session complete

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: fix support for multipacket broadcast message

Jarod Wilson <jarod@redhat.com>
    bonding: show saner speed for broadcast mode

Fugang Duan <fugang.duan@nxp.com>
    net: fec: correct the error path for regulator disable in probe

Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
    i40e: Fix crash during removing i40e driver

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    i40e: Set RX_ONLY mode for unicast promiscuous on VLAN

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igc: Fix PTP initialization

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: transport: add j1939_session_skb_find_by_offset() function

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: transport: j1939_simple_recv(): ignore local J1939 messages send not by J1939 stack

Eric Dumazet <edumazet@google.com>
    can: j1939: fix kernel-infoleak in j1939_sk_sock2sockaddr_can()

Andrii Nakryiko <andriin@fb.com>
    libbpf: Fix BTF-defined map-in-map initialization on 32-bit host arches

John Fastabend <john.fastabend@gmail.com>
    bpf: sock_ops sk access may stomp registers when dst_reg = src_reg

John Fastabend <john.fastabend@gmail.com>
    bpf: sock_ops ctx access may stomp registers in corner case

Andrii Nakryiko <andriin@fb.com>
    tools/bpftool: Make skeleton code C++17-friendly by dropping typeof()

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: q6routing: add dummy register read/write function

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: q6afe-dai: mark all widgets registers as SND_SOC_NOPM

Amelie Delaunay <amelie.delaunay@st.com>
    spi: stm32: fixes suspend/resume management

Stephen Suryaputra <ssuryaextr@gmail.com>
    netfilter: nf_tables: nft_exthdr: the presence return value should be little-endian

Jan Kara <jack@suse.cz>
    ext4: check journal inode extents more carefully

Jan Kara <jack@suse.cz>
    ext4: don't allow overlapping system zones

Qi Liu <liuqi.16@bytedance.com>
    drm/virtio: fix missing dma_fence_put() in virtio_gpu_execbuffer_ioctl()

Eric Sandeen <sandeen@redhat.com>
    ext4: fix potential negative array index in do_split()

Helge Deller <deller@gmx.de>
    fs/signalfd.c: fix inconsistent return codes for signalfd4

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: fix fat_ra_init() for data clusters == 0

Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
    alpha: fix annotation of io{read,write}{16,32}be()

Eiichi Tsukata <devel@etsukata.com>
    xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init

Gaurav Singh <gaurav1086@gmail.com>
    tools/testing/selftests/cgroup/cgroup_util.c: cg_read_strcmp: fix null pointer dereference

Evgeny Novikov <novikov@ispras.ru>
    media: camss: fix memory leaks on error handling paths in probe

Mao Wenan <wenan.mao@linux.alibaba.com>
    virtio_ring: Avoid loop when vq is broken in virtqueue_poll

Javed Hasan <jhasan@marvell.com>
    scsi: libfc: Free skb in fc_disc_gpn_id_resp() for valid cases

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    cpufreq: intel_pstate: Fix cpuinfo_max_freq when MSR_TURBO_RATIO_LIMIT is 0

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    swiotlb-xen: use vmalloc_to_page on vmalloc virt addresses

Xiubo Li <xiubli@redhat.com>
    ceph: fix use-after-free for fsc->mdsc

Zhe Li <lizhe67@huawei.com>
    jffs2: fix UAF problem

Guo Ren <guoren@linux.alibaba.com>
    riscv: Fixup static_obj() fail

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/ttm: fix offset in VMAs with a pg_offs in ttm_bo_vm_access

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix inode quota reservation checks

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Fix another Receive buffer leak

Greg Ungerer <gerg@linux-m68k.org>
    m68knommu: fix overwriting of bits in ColdFire V3 cache control

Jinyang He <hejinyang@loongson.cn>
    MIPS: Fix unable to reserve memory for Crash kernel

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    Input: psmouse - add a newline when printing 'proto' by sysfs

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: should avoid inode eviction in synchronous path

Evgeny Novikov <novikov@ispras.ru>
    media: vpss: clean up resources in init

Huacai Chen <chenhc@lemote.com>
    rtc: goldfish: Enable interrupt in set_alarm() when necessary

Chao Yu <chao@kernel.org>
    f2fs: fix to check page dirty status before writeback

Chen Zhou <chenzhou10@huawei.com>
    media: coda: jpeg: add NULL check after kmalloc

Chuhong Yuan <hslester96@gmail.com>
    media: budget-core: Improve exception handling in budget_register()

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range on ARM

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Add DELAY_BEFORE_LPM quirk for Micron devices

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Provide the perf pmu.module

Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
    drm/i915/pmu: Prefer drm_WARN_ON over WARN_ON

Krunoslav Kovac <Krunoslav.Kovac@amd.com>
    drm/amd/display: fix pow() crashing when given base 0

Paul Hsieh <paul.hsieh@amd.com>
    drm/amd/display: Fix DFPstate hang due to view port changed

Jaehyun Chung <jaehyun.chung@amd.com>
    drm/amd/display: Blank stream before destroying HDCP session

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Fix EDID parsing after resume from suspend

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: Fix incorrect backlight register offset for DCN

Daniel Kolesa <daniel@octaforge.org>
    drm/amdgpu/display: use GFP_ATOMIC in dcn20_validate_bandwidth_internal

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm: amdgpu: Use the correct size when allocating memory

Yang Shi <shy828301@gmail.com>
    mm/memory.c: skip spurious TLB flush for retried page fault

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: ignore stale configuration request event

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: fix PF/VF linking on hot plug

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: re-introduce zpci_remove_device()

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: fix zpci_bus_link_virtfn()

Yang Weijiang <weijiang.yang@intel.com>
    selftests: kvm: Use a shorter encoding to clear RAX

Will Deacon <will@kernel.org>
    KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: Fix use-after-free in request timeout handlers

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: add the missing unlock_buffer() in the error path of jbd2_write_superblock()

Jan Kara <jack@suse.cz>
    ext4: fix checking of directory entry validity for inline directories

Jan Kara <jack@suse.cz>
    ext4: do not block RWF_NOWAIT dio write on unallocated space

Stephen Boyd <swboyd@chromium.org>
    opp: Put opp table in dev_pm_opp_set_rate() if _set_opp_bw() fails

Stephen Boyd <swboyd@chromium.org>
    opp: Put opp table in dev_pm_opp_set_rate() for empty tables

Rajendra Nayak <rnayak@codeaurora.org>
    opp: Enable resources again if they were disabled earlier

Kaike Wan <kaike.wan@intel.com>
    RDMA/hfi1: Correct an interlock issue for TID RDMA WRITE request

Hui Wang <hui.wang@canonical.com>
    ASoC: amd: renoir: restore two more registers during resume

Charan Teja Reddy <charante@codeaurora.org>
    mm, page_alloc: fix core hung in free_pcppages_bulk()

Doug Berger <opendmb@gmail.com>
    mm: include CMA pages in lowmem_reserve at boot

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: avoid bio_alloc() failure with 1Mbyte blocks

Hugh Dickins <hughd@google.com>
    uprobes: __replace_page() avoid BUG in munlock_vma_page()

Wei Yongjun <weiyongjun1@huawei.com>
    kernel/relay.c: fix memleak on destroy relay channel

Jann Horn <jannh@google.com>
    romfs: fix uninitialized memory leak in romfs_dev_read()

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    mm/vunmap: add cond_resched() in vunmap_pmd_range

Jens Axboe <axboe@kernel.dk>
    io_uring: find and cancel head link async work on files exit

Lukas Wunner <lukas@wunner.de>
    spi: Prevent adding devices below an unregistering controller

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: socket: j1939_sk_bind(): make sure ml_priv is allocated

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: transport: j1939_session_tx_dat(): fix use-after-free read in j1939_tp_txtimer()

Mike Pozulp <pozulp.kernel@gmail.com>
    ALSA: hda/realtek: Add quirk for Samsung Galaxy Book Ion

Mike Pozulp <pozulp.kernel@gmail.com>
    ALSA: hda/realtek: Add quirk for Samsung Galaxy Flex Book

Sameer Pujar <spujar@nvidia.com>
    ALSA: hda: avoid reset of sdo_limit

Hugh Dickins <hughd@google.com>
    khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Initialize DRAM type before posting GPU

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Remove unused code paths for AST 1180

Paul Cercueil <paul@crapouillou.net>
    drm/panel-simple: Fix inverted V/H SYNC for Frida FRD350H54004 panel

Chris Wilson <chris@chris-wilson.co.uk>
    drm/vgem: Replace opencoded version of drm_gem_dumb_map_offset()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/include/asm/io.h                        |   8 +-
 arch/arm64/Makefile                                |   1 +
 arch/arm64/include/asm/kvm_host.h                  |   2 +-
 arch/arm64/kernel/vdso32/Makefile                  |   2 +-
 arch/arm64/kvm/mmu.c                               |   2 +-
 arch/ia64/include/asm/pgtable.h                    |   9 +
 arch/m68k/include/asm/m53xxacr.h                   |   6 +-
 arch/mips/include/asm/kvm_host.h                   |   2 +-
 arch/mips/kernel/setup.c                           |   2 +-
 arch/mips/kvm/mmu.c                                |   3 +-
 arch/powerpc/include/asm/fixmap.h                  |   2 +-
 arch/powerpc/include/asm/kvm_host.h                |   3 +-
 arch/powerpc/kernel/cputable.c                     |  20 ++
 arch/powerpc/kernel/setup-common.c                 |   1 +
 arch/powerpc/kvm/book3s.c                          |   3 +-
 arch/powerpc/kvm/e500_mmu_host.c                   |   3 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |  18 +-
 arch/powerpc/platforms/pseries/ras.c               |   1 -
 arch/riscv/kernel/vmlinux.lds.S                    |   2 +-
 arch/s390/kernel/ptrace.c                          |   7 +-
 arch/s390/kernel/runtime_instr.c                   |   2 +-
 arch/s390/pci/pci.c                                |  22 ++-
 arch/s390/pci/pci_bus.c                            |  52 ++---
 arch/s390/pci/pci_bus.h                            |  13 ++
 arch/s390/pci/pci_event.c                          |   7 +-
 arch/x86/include/asm/kvm_host.h                    |   3 +-
 arch/x86/kvm/mmu/mmu.c                             |   3 +-
 arch/x86/kvm/x86.c                                 |   2 +-
 arch/x86/pci/xen.c                                 |   1 +
 arch/x86/platform/efi/efi_64.c                     |   2 +
 drivers/cpufreq/intel_pstate.c                     |   1 +
 drivers/edac/i7core_edac.c                         |   4 +-
 drivers/edac/pnd2_edac.c                           |   2 +-
 drivers/edac/sb_edac.c                             |   4 +-
 drivers/edac/skx_common.c                          |   4 +-
 drivers/firmware/efi/efi.c                         |   2 +
 drivers/firmware/efi/libstub/efi-stub-helper.c     |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   1 +
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   3 +-
 .../gpu/drm/amd/display/dc/dce/dce_panel_cntl.h    |   2 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   4 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   2 +-
 drivers/gpu/drm/amd/display/include/fixed31_32.h   |   3 +
 drivers/gpu/drm/ast/ast_drv.c                      |   1 -
 drivers/gpu/drm/ast/ast_drv.h                      |   2 -
 drivers/gpu/drm/ast/ast_main.c                     |  91 ++++-----
 drivers/gpu/drm/ast/ast_mode.c                     |  11 +-
 drivers/gpu/drm/ast/ast_post.c                     |  10 +-
 drivers/gpu/drm/i915/i915_pmu.c                    |  17 +-
 drivers/gpu/drm/panel/panel-simple.c               |   2 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |   4 +-
 drivers/gpu/drm/vgem/vgem_drv.c                    |  27 ---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |   1 +
 drivers/infiniband/hw/bnxt_re/main.c               |   3 +-
 drivers/infiniband/hw/hfi1/tid_rdma.c              |   1 +
 drivers/infiniband/hw/hns/hns_roce_device.h        |   2 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   9 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   4 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   5 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   2 +-
 drivers/input/mouse/psmouse-base.c                 |   2 +-
 drivers/media/pci/ttpci/budget-core.c              |  11 +-
 drivers/media/platform/coda/coda-jpeg.c            |   5 +-
 drivers/media/platform/davinci/vpss.c              |  20 +-
 drivers/media/platform/qcom/camss/camss.c          |  30 ++-
 drivers/net/bonding/bond_main.c                    |  42 ++++-
 drivers/net/dsa/b53/b53_common.c                   |   2 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  30 ++-
 drivers/net/ethernet/cortina/gemini.c              |   4 +-
 drivers/net/ethernet/freescale/fec_main.c          |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h  |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c      |  35 +++-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   3 +
 drivers/net/ethernet/intel/igc/igc_main.c          |   5 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |   2 -
 drivers/net/hyperv/netvsc_drv.c                    |   2 +-
 drivers/net/ipvlan/ipvlan_main.c                   |  27 ++-
 drivers/of/address.c                               |   5 +
 drivers/opp/core.c                                 |  19 +-
 drivers/pci/hotplug/s390_pci_hpc.c                 |  12 +-
 drivers/rtc/rtc-goldfish.c                         |   1 +
 drivers/s390/scsi/zfcp_fsf.c                       |   4 +-
 drivers/scsi/libfc/fc_disc.c                       |  12 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   4 -
 drivers/scsi/ufs/ti-j721e-ufs.c                    |   1 +
 drivers/scsi/ufs/ufs_quirks.h                      |   1 +
 drivers/scsi/ufs/ufshcd-pci.c                      |  16 +-
 drivers/scsi/ufs/ufshcd.c                          | 130 +++++++++++--
 drivers/scsi/ufs/ufshcd.h                          |  38 +++-
 drivers/spi/Kconfig                                |   3 +
 drivers/spi/spi-stm32.c                            |  27 ++-
 drivers/spi/spi.c                                  |  21 ++-
 drivers/target/target_core_user.c                  |   2 +-
 drivers/vfio/pci/vfio_pci_private.h                |   2 +
 drivers/vfio/pci/vfio_pci_rdwr.c                   | 120 +++++++++---
 drivers/vfio/vfio_iommu_type1.c                    |  71 ++++++-
 drivers/video/fbdev/efifb.c                        |   2 +-
 drivers/virtio/virtio_ring.c                       |   3 +
 drivers/xen/swiotlb-xen.c                          |   8 +-
 fs/afs/dynroot.c                                   |  20 +-
 fs/afs/fs_operation.c                              |   1 +
 fs/ceph/mds_client.c                               |   3 +-
 fs/eventpoll.c                                     |  26 +--
 fs/ext4/block_validity.c                           |  87 ++++-----
 fs/ext4/ext4.h                                     |   6 +-
 fs/ext4/extents.c                                  |  16 +-
 fs/ext4/file.c                                     |   4 +
 fs/ext4/indirect.c                                 |   6 +-
 fs/ext4/inode.c                                    |   5 +-
 fs/ext4/mballoc.c                                  |   4 +-
 fs/ext4/namei.c                                    |  22 ++-
 fs/f2fs/compress.c                                 |   6 +
 fs/f2fs/node.c                                     |  10 +-
 fs/fat/fatent.c                                    |   3 +
 fs/io_uring.c                                      |  33 +++-
 fs/jbd2/journal.c                                  |   4 +-
 fs/jffs2/dir.c                                     |   6 +-
 fs/romfs/storage.c                                 |   4 +-
 fs/signalfd.c                                      |  10 +-
 fs/squashfs/block.c                                |   6 +-
 fs/xfs/xfs_sysfs.h                                 |   6 +-
 fs/xfs/xfs_trans_dquot.c                           |   2 +-
 include/linux/pgtable.h                            |   2 +
 include/linux/sched/user.h                         |   3 +
 kernel/bpf/task_iter.c                             |   3 +-
 kernel/events/uprobes.c                            |   2 +-
 kernel/relay.c                                     |   1 +
 kernel/watch_queue.c                               |   8 +
 mm/khugepaged.c                                    |   2 +-
 mm/memory.c                                        |   3 +
 mm/page_alloc.c                                    |   7 +-
 mm/vmalloc.c                                       |   2 +
 net/can/j1939/socket.c                             |  14 ++
 net/can/j1939/transport.c                          |  89 +++++++--
 net/core/filter.c                                  |  75 ++++++--
 net/netfilter/nft_exthdr.c                         |   4 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |   2 +
 scripts/kconfig/qconf.cc                           |  72 ++++---
 sound/hda/hdac_bus.c                               |  12 ++
 sound/hda/hdac_controller.c                        |  11 --
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/amd/renoir/acp3x-pdm-dma.c               |  29 +--
 sound/soc/codecs/msm8916-wcd-analog.c              |   4 +-
 sound/soc/intel/atom/sst-mfld-platform-pcm.c       |   5 +-
 sound/soc/qcom/qdsp6/q6afe-dai.c                   | 210 ++++++++++-----------
 sound/soc/qcom/qdsp6/q6routing.c                   |  16 ++
 tools/bpf/bpftool/gen.c                            |   8 +-
 tools/lib/bpf/libbpf.c                             |  16 +-
 tools/testing/selftests/bpf/.gitignore             |   1 -
 tools/testing/selftests/bpf/Makefile               |   2 +-
 tools/testing/selftests/cgroup/cgroup_util.c       |   2 +-
 tools/testing/selftests/kvm/x86_64/debug_regs.c    |   4 +-
 virt/kvm/kvm_main.c                                |   3 +-
 155 files changed, 1385 insertions(+), 693 deletions(-)


