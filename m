Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16023A0289
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235951AbhFHTGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235050AbhFHTDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:03:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EB0761921;
        Tue,  8 Jun 2021 18:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177937;
        bh=0STs/e1VopGpqHn6C/OmWFEUta8MnkTSUVphmyuaq1E=;
        h=From:To:Cc:Subject:Date:From;
        b=iAU+GXdN189b+vfu4cLF3ndhMK/4IDREusTeHxQtX2fd1P5S/p8FwGdN+3t45bMSs
         FEhIowUznkPcRvCTqzHITHwgLcQeD7T9+2jkNCOWDu97xOYzekbVgwhxlmgXWQijjm
         I9um9SLFx3ydxFF0UwkHmfSwkdatpU392fFhDoMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.12 000/161] 5.12.10-rc1 review
Date:   Tue,  8 Jun 2021 20:25:30 +0200
Message-Id: <20210608175945.476074951@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.10-rc1
X-KernelTest-Deadline: 2021-06-10T17:59+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.12.10 release.
There are 161 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.12.10-rc1

David Ahern <dsahern@kernel.org>
    neighbour: allow NUD_NOARP entries to be forced GCed

Roger Pau Monne <roger.pau@citrix.com>
    xen-netback: take a reference to the RX task thread

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: missing error reporting for not selected expressions

Jiashuo Liang <liangjs@pku.edu.cn>
    x86/fault: Don't send SIGSEGV twice on SEGV_PKUERR

Roja Rani Yarubandi <rojay@codeaurora.org>
    i2c: qcom-geni: Suspend and resume the bus during SYSTEM_SLEEP_PM ops

Maciej Falkowski <maciej.falkowski9@gmail.com>
    ARM: OMAP1: isp1301-omap: Add missing gpiod_add_lookup_table function

Zenghui Yu <yuzenghui@huawei.com>
    KVM: arm64: Resolve all pending PC updates before immediate exit

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Commit pending PC adjustemnts before returning to userspace

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86/kvm: Disable all PV features on crash

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86/kvm: Disable kvmclock on all CPUs on shutdown

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86/kvm: Teardown PV features on boot CPU as well

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Truncate GPR value for DR and CR accesses in !64-bit mode

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: always use mdp device to scale bandwidth

Mina Almasry <almasrymina@google.com>
    mm, hugetlb: fix simple resv_huge_pages underflow on UFFDIO_COPY

Filipe Manana <fdmanana@suse.com>
    btrfs: fix deadlock when cloning inline extents and low on available space

Josef Bacik <josef@toxicpanda.com>
    btrfs: abort in rename_exchange if we fail to insert the second ref

Josef Bacik <josef@toxicpanda.com>
    btrfs: fixup error handling in fixup_inode_link_counts

Josef Bacik <josef@toxicpanda.com>
    btrfs: check error value from btrfs_update_inode in tree log

Filipe Manana <fdmanana@suse.com>
    btrfs: fix fsync failure and transaction abort after writes to prealloc extents

Josef Bacik <josef@toxicpanda.com>
    btrfs: return errors from btrfs_del_csums in cleanup_ref_head

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix error handling in btrfs_del_csums

Josef Bacik <josef@toxicpanda.com>
    btrfs: mark ordered extent and inode with error if we fail to finish

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/kprobes: Fix validation of prefixed instructions across page boundary

Borislav Petkov <bp@suse.de>
    x86/thermal: Fix LVT thermal setup for SMI delivery mode

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Mark _all_ legacy interrupts when IO/APIC is missing

Nirmoy Das <nirmoy.das@amd.com>
    drm/amdgpu: make sure we unpin the UVD BO

Luben Tuikov <luben.tuikov@amd.com>
    drm/amdgpu: Don't query CE and UE errors

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: fix NULL ptr dereference in llcp_sock_getname() after failed connect

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S HV: Save host FSCR in the P7/8 path

Pu Wen <puwen@hygon.cn>
    x86/sev: Check SME/SEV support in CPUID first

Borislav Petkov <bp@suse.de>
    dmaengine: idxd: Use cpu_feature_enabled()

Thomas Gleixner <tglx@linutronix.de>
    x86/cpufeatures: Force disable X86_FEATURE_ENQCMD and remove update_pasid()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix failure to transmit ABTS on FC link

Ding Hui <dinghui@sangfor.com.cn>
    mm/page_alloc: fix counting of free pages after take off from buddy

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    mm/debug_vm_pgtable: fix alignment for pmd/pud_advanced_tests()

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: fix data corruption by fallocate

Mark Rutland <mark.rutland@arm.com>
    pid: take a reference when initializing `cad_pid`

Marco Elver <elver@google.com>
    kfence: use TASK_IDLE when awaiting allocation

Marco Elver <elver@google.com>
    kfence: maximize allocation wait timeout duration

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    Revert "MIPS: make userspace mapping young by default"

Phil Elwell <phil@raspberrypi.com>
    usb: dwc2: Fix build in periphal-only mode

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: fix accessing uninit percpu counter variable with fast_commit

Phillip Potter <phil@philpotter.co.uk>
    ext4: fix memory leak in ext4_mb_init_backend on error path.

Harshad Shirwadkar <harshadshirwadkar@gmail.com>
    ext4: fix fast commit alignment issues

Ye Bin <yebin10@huawei.com>
    ext4: fix bug on in ext4_es_cache_extent as ext4_split_extent_at failed

Alexey Makhalov <amakhalov@vmware.com>
    ext4: fix memory leak in ext4_fill_super

Marek Vasut <marex@denx.de>
    ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators

Michal Vokáč <michal.vokac@ysoft.com>
    ARM: dts: imx6dl-yapp4: Fix RGMII connection to QCA8334 switch

Hui Wang <hui.wang@canonical.com>
    ALSA: hda: update the power_state during the direct-complete

Carlos M <carlos.marr.pz@gmail.com>
    ALSA: hda: Fix for mute key LED for HP Pavilion 15-CK0xx

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Fix master timer notification

Bob Peterson <rpeterso@redhat.com>
    gfs2: fix scheduling while atomic bug in glocks

Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
    HID: multitouch: require Finger field to mark Win8 reports as MT

Johan Hovold <johan@kernel.org>
    HID: magicmouse: fix NULL-deref on disconnect

Johnny Chuang <johnny.chuang.emc@gmail.com>
    HID: i2c-hid: Skip ELAN power-on command after reset

Pavel Skripkin <paskripkin@gmail.com>
    net: caif: fix memory leak in cfusbl_device_notify

Pavel Skripkin <paskripkin@gmail.com>
    net: caif: fix memory leak in caif_device_notify

Pavel Skripkin <paskripkin@gmail.com>
    net: caif: add proper error handling

Pavel Skripkin <paskripkin@gmail.com>
    net: caif: added cfserl_release function

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: allowedips: free empty intermediate nodes when removing single node

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: allowedips: allocate nodes in kmem_cache

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: allowedips: remove nodes in O(1)

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: allowedips: initialize list head in selftest

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: selftests: make sure rp_filter is disabled on vethc

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: selftests: remove old conntrack kconfig value

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: use synchronize_net rather than synchronize_rcu

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: peer: allocate in kmem_cache

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: do not use -O3

Lin Ma <linma@zju.edu.cn>
    Bluetooth: use correct lock to prevent UAF of hdev object

Lin Ma <linma@zju.edu.cn>
    Bluetooth: fix the erroneous flush_work() order

James Zhu <James.Zhu@amd.com>
    drm/amdgpu/jpeg3: add cancel_delayed_work_sync before power gate

James Zhu <James.Zhu@amd.com>
    drm/amdgpu/jpeg2.5: add cancel_delayed_work_sync before power gate

James Zhu <James.Zhu@amd.com>
    drm/amdgpu/vcn3: add cancel_delayed_work_sync before power gate

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix ltout double free on completion race

Jens Axboe <axboe@kernel.dk>
    io_uring: wrap io_kiocb reference count manipulation in helpers

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: use better types for cflags

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix link timeout refs

Simon Ser <contact@emersion.fr>
    amdgpu: fix GEM obj leak in amdgpu_display_user_framebuffer_create

Ilya Dryomov <idryomov@gmail.com>
    libceph: don't set global_id until we get an auth ticket

Jisheng Zhang <jszhang@kernel.org>
    riscv: vdso: fix and clean-up Makefile

Johan Hovold <johan@kernel.org>
    serial: stm32: fix threaded interrupt handling

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix unique bearer names sanity check

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: add extack messages for bearer/media failure

Jerome Brunet <jbrunet@baylibre.com>
    arm64: meson: select COMMON_CLK

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix flakey idling of uarts and stop using swsup_sidle_act

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: imx: emcon-avari: Fix nxp,pca8574 #gpio-cells

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx7d-pico: Fix the 'tuning-step' property

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx7d-meerkat96: Fix the 'tuning-step' property

Michael Walle <michael@walle.cc>
    arm64: dts: freescale: sl28: var1: fix RGMII clock and voltage

Michael Walle <michael@walle.cc>
    arm64: dts: freescale: sl28: var4: fix RGMII clock and voltage

Lucas Stach <l.stach@pengutronix.de>
    arm64: dts: zii-ultra: fix 12V_MAIN voltage

Lucas Stach <l.stach@pengutronix.de>
    arm64: dts: zii-ultra: remove second GEN_3V3 regulator instance

Michael Walle <michael@walle.cc>
    arm64: dts: ls1028a: fix memory node

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix am335x resume hang for usb otg module

Jens Wiklander <jens.wiklander@linaro.org>
    optee: use export_uuid() to copy client UUID

Vignesh Raghavendra <vigneshr@ti.com>
    arm64: dts: ti: j7200-main: Mark Main NAVSS as dma-coherent

Magnus Karlsson <magnus.karlsson@intel.com>
    ixgbe: add correct exception tracing for XDP

Magnus Karlsson <magnus.karlsson@intel.com>
    ixgbe: optimize for XDP_REDIRECT in xsk path

Magnus Karlsson <magnus.karlsson@intel.com>
    ice: add correct exception tracing for XDP

Magnus Karlsson <magnus.karlsson@intel.com>
    ice: optimize for XDP_REDIRECT in xsk path

Magnus Karlsson <magnus.karlsson@intel.com>
    i40e: add correct exception tracing for XDP

Magnus Karlsson <magnus.karlsson@intel.com>
    i40e: optimize for XDP_REDIRECT in xsk path

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: avoid link re-train during TC-MQPRIO configuration

Yunjian Wang <wangyunjian@huawei.com>
    sch_htb: fix refcount leak in htb_parent_to_leaf_offload

Roja Rani Yarubandi <rojay@codeaurora.org>
    i2c: qcom-geni: Add shutdown callback for i2c

Dave Ertman <david.m.ertman@intel.com>
    ice: Allow all LLDP packets from PF to Tx

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: report supported and advertised autoneg using PHY capabilities

Haiyue Wang <haiyue.wang@intel.com>
    ice: handle the VF VSI rebuild failure

Brett Creeley <brett.creeley@intel.com>
    ice: Fix VFR issues for AVF drivers that expect ATQLEN cleared

Brett Creeley <brett.creeley@intel.com>
    ice: Fix allowing VF to request more/less queues via virtchnl

Coco Li <lixiaoyan@google.com>
    ipv6: Fix KASAN: slab-out-of-bounds Read in fib6_nh_flush_exceptions

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix regression with HASH tc prio value update

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: track AF_XDP ZC enabled queues in bitmap

Magnus Karlsson <magnus.karlsson@intel.com>
    ixgbevf: add correct exception tracing for XDP

Magnus Karlsson <magnus.karlsson@intel.com>
    igb: add correct exception tracing for XDP

Kurt Kanzenbach <kurt@linutronix.de>
    igb: Fix XDP with PTP enabled

Wei Yongjun <weiyongjun1@huawei.com>
    ieee802154: fix error return code in ieee802154_llsec_getparams()

Zhen Lei <thunder.leizhen@huawei.com>
    ieee802154: fix error return code in ieee802154_add_iface()

Daniel Borkmann <daniel@iogearbox.net>
    bpf, lockdown, audit: Fix buggy SELinux lockdown permission checks

Zhihao Cheng <chengzhihao1@huawei.com>
    drm/i915/selftests: Fix return value check in live_breadcrumbs_smoketest()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_ct: skip expectations for confirmed conntrack

Max Gurtovoy <mgurtovoy@nvidia.com>
    nvmet: fix freeing unallocated p2pmem

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: DR, Create multi-destination flow table with level less than 64

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Fix adding encap rules to slow path

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Check for needed capability for cvlan matching

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Check firmware sync reset requested is set before trying to abort it

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix incompatible casting

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/tls: Fix use-after-free after the TLS device goes down and up

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/tls: Replace TLS_RX_SYNC_RUNNING with RCU

Alexander Aring <aahringo@redhat.com>
    net: sock: fix in-kernel mark setting

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_8021q: fix the VLAN IDs used for encoding sub-VLANs

Li Huafei <lihuafei1@huawei.com>
    perf probe: Fix NULL pointer dereference in convert_variable_location()

Erik Kaneda <erik.kaneda@intel.com>
    ACPICA: Clean up context mutex during object deletion

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: fix in-casule data send for chained sgls

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not reset MP_CAPABLE subflow on mapping errors

Paolo Abeni <pabeni@redhat.com>
    mptcp: always parse mptcp options for MPC reqsk

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix sk_forward_memory corruption on retransmission

Ariel Levkovich <lariel@nvidia.com>
    net/sched: act_ct: Fix ct template allocation for zone 0

Paul Blakey <paulb@nvidia.com>
    net/sched: act_ct: Offload connections with commit action

Parav Pandit <parav@nvidia.com>
    devlink: Correct VIRTUAL port to not have phys_port attributes

Javier Martinez Canillas <javierm@redhat.com>
    kbuild: Quote OBJCOPY var to avoid a pahole call break the build

Arnd Bergmann <arnd@arndb.de>
    HID: i2c-hid: fix format string mismatch

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Fix memory leak in amd_sfh_work

Zhen Lei <thunder.leizhen@huawei.com>
    HID: pidff: fix error return code in hid_pidff_init()

Tom Rix <trix@redhat.com>
    HID: logitech-hidpp: initialize level variable

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

Dan Carpenter <dan.carpenter@oracle.com>
    efi/libstub: prevent read overflow in find_file_option()

Heiner Kallweit <hkallweit1@gmail.com>
    efi: Allow EFI_MEMORY_XP and EFI_MEMORY_RO both to be cleared

Changbin Du <changbin.du@intel.com>
    efi/fdt: fix panic when no valid fdt found

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: unregister ipv4 sockopts on error unwind

Grant Peltier <grantpeltier93@gmail.com>
    hwmon: (pmbus/isl68137) remove READ_TEMPERATURE_3 for RAA228228

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm-hwmon) Fix index values

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt76x0e: fix device hang during suspend/resume

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: fix possible AOOB issue in mt7921_mcu_tx_rate_report

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: add rcu section in mt7921_mcu_tx_rate_report


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6dl-yapp4-common.dtsi         |   6 +-
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi             |  12 ++
 arch/arm/boot/dts/imx6qdl-emcon-avari.dtsi         |   2 +-
 arch/arm/boot/dts/imx7d-meerkat96.dts              |   2 +-
 arch/arm/boot/dts/imx7d-pico.dtsi                  |   2 +-
 arch/arm/mach-omap1/board-h2.c                     |   4 +-
 arch/arm64/Kconfig.platforms                       |   1 +
 .../freescale/fsl-ls1028a-kontron-sl28-var1.dts    |   3 +-
 .../freescale/fsl-ls1028a-kontron-sl28-var4.dts    |   5 +-
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi     |   4 +-
 .../boot/dts/freescale/imx8mq-zii-ultra-rmb3.dts   |  10 +-
 .../arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi |  23 +--
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi          |   2 +
 arch/arm64/include/asm/kvm_asm.h                   |   1 +
 arch/arm64/kvm/arm.c                               |  20 ++-
 arch/arm64/kvm/hyp/exception.c                     |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   8 +
 arch/mips/mm/cache.c                               |  30 ++--
 arch/powerpc/kernel/kprobes.c                      |   4 +-
 arch/powerpc/kvm/book3s_hv.c                       |   1 -
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |   7 +
 arch/riscv/kernel/vdso/Makefile                    |   4 +-
 arch/x86/include/asm/apic.h                        |   1 +
 arch/x86/include/asm/disabled-features.h           |   7 +-
 arch/x86/include/asm/fpu/api.h                     |   6 +-
 arch/x86/include/asm/fpu/internal.h                |   7 -
 arch/x86/include/asm/kvm_para.h                    |  10 +-
 arch/x86/include/asm/thermal.h                     |   4 +-
 arch/x86/kernel/apic/apic.c                        |   1 +
 arch/x86/kernel/apic/vector.c                      |  20 +++
 arch/x86/kernel/fpu/xstate.c                       |  57 -------
 arch/x86/kernel/kvm.c                              |  92 +++++++---
 arch/x86/kernel/kvmclock.c                         |  26 +--
 arch/x86/kernel/setup.c                            |   9 +
 arch/x86/kvm/svm/svm.c                             |   8 +-
 arch/x86/mm/fault.c                                |   4 +-
 arch/x86/mm/mem_encrypt_identity.c                 |  11 +-
 drivers/acpi/acpica/utdelete.c                     |   8 +
 drivers/bus/ti-sysc.c                              |  57 ++++++-
 drivers/dma/idxd/init.c                            |   4 +-
 drivers/firmware/efi/cper.c                        |   4 +-
 drivers/firmware/efi/fdtparams.c                   |   3 +
 drivers/firmware/efi/libstub/file.c                |   2 +-
 drivers/firmware/efi/memattr.c                     |   5 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |  16 --
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |   1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c              |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |   5 +-
 drivers/gpu/drm/i915/selftests/i915_request.c      |   4 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |   3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_mdss.c           |  51 +-----
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |   1 +
 drivers/hid/hid-logitech-hidpp.c                   |   1 +
 drivers/hid/hid-magicmouse.c                       |   2 +-
 drivers/hid/hid-multitouch.c                       |  10 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  13 +-
 drivers/hid/usbhid/hid-pidff.c                     |   1 +
 drivers/hwmon/dell-smm-hwmon.c                     |   4 +-
 drivers/hwmon/pmbus/isl68137.c                     |   4 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |  21 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |   2 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   4 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |  14 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c   |   9 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   6 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  15 +-
 drivers/net/ethernet/intel/ice/ice.h               |   8 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  51 +-----
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h    |   1 +
 drivers/net/ethernet/intel/ice/ice_lib.c           |  12 ++
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  17 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  19 ++-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  19 ++-
 drivers/net/ethernet/intel/igb/igb.h               |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  55 +++---
 drivers/net/ethernet/intel/igb/igb_ptp.c           |  23 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  16 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  21 ++-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   9 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   3 +
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.h    |   5 +
 .../ethernet/mellanox/mlx5/core/steering/dr_fw.c   |   3 +-
 drivers/net/wireguard/Makefile                     |   3 +-
 drivers/net/wireguard/allowedips.c                 | 189 +++++++++++----------
 drivers/net/wireguard/allowedips.h                 |  14 +-
 drivers/net/wireguard/main.c                       |  17 +-
 drivers/net/wireguard/peer.c                       |  27 ++-
 drivers/net/wireguard/peer.h                       |   3 +
 drivers/net/wireguard/selftest/allowedips.c        | 165 +++++++++---------
 drivers/net/wireguard/socket.c                     |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |  81 ++++++++-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  24 ++-
 drivers/net/xen-netback/interface.c                |   6 +
 drivers/nvme/host/rdma.c                           |   5 +-
 drivers/nvme/target/core.c                         |  33 ++--
 drivers/scsi/lpfc/lpfc_sli.c                       |   4 +-
 drivers/tee/optee/call.c                           |   6 +-
 drivers/tee/optee/optee_msg.h                      |   6 +-
 drivers/thermal/intel/therm_throt.c                |  15 +-
 drivers/tty/serial/stm32-usart.c                   |  22 +--
 drivers/usb/dwc2/core_intr.c                       |   4 +
 drivers/vfio/pci/Kconfig                           |   1 +
 drivers/vfio/pci/vfio_pci_config.c                 |   2 +-
 drivers/vfio/platform/vfio_platform_common.c       |   2 +-
 fs/btrfs/extent-tree.c                             |   2 +-
 fs/btrfs/file-item.c                               | 108 +++++++++---
 fs/btrfs/inode.c                                   |  19 ++-
 fs/btrfs/reflink.c                                 |  38 +++--
 fs/btrfs/tree-log.c                                |  21 ++-
 fs/ext4/extents.c                                  |  43 ++---
 fs/ext4/fast_commit.c                              | 170 +++++++++---------
 fs/ext4/fast_commit.h                              |  19 ---
 fs/ext4/ialloc.c                                   |   6 +-
 fs/ext4/mballoc.c                                  |   2 +-
 fs/ext4/super.c                                    |  11 +-
 fs/gfs2/glock.c                                    |   2 +
 fs/io_uring.c                                      |  66 ++++---
 fs/ocfs2/file.c                                    |  55 +++++-
 include/linux/mlx5/mlx5_ifc.h                      |   2 +
 include/linux/pgtable.h                            |   8 +
 include/linux/platform_data/ti-sysc.h              |   1 +
 include/net/caif/caif_dev.h                        |   2 +-
 include/net/caif/cfcnfg.h                          |   2 +-
 include/net/caif/cfserl.h                          |   1 +
 include/net/tls.h                                  |  10 +-
 init/main.c                                        |   2 +-
 kernel/bpf/helpers.c                               |   7 +-
 kernel/trace/bpf_trace.c                           |  32 ++--
 mm/debug_vm_pgtable.c                              |   4 +-
 mm/hugetlb.c                                       |  14 +-
 mm/kfence/core.c                                   |  12 +-
 mm/memory.c                                        |   4 +
 mm/page_alloc.c                                    |   2 +
 net/bluetooth/hci_core.c                           |   7 +-
 net/bluetooth/hci_sock.c                           |   4 +-
 net/caif/caif_dev.c                                |  13 +-
 net/caif/caif_usb.c                                |  14 +-
 net/caif/cfcnfg.c                                  |  16 +-
 net/caif/cfserl.c                                  |   5 +
 net/ceph/auth.c                                    |  36 ++--
 net/core/devlink.c                                 |   4 +-
 net/core/neighbour.c                               |   1 +
 net/core/sock.c                                    |  16 +-
 net/dsa/tag_8021q.c                                |   2 +-
 net/ieee802154/nl-mac.c                            |   4 +-
 net/ieee802154/nl-phy.c                            |   4 +-
 net/ipv6/route.c                                   |   8 +-
 net/mptcp/protocol.c                               |  16 +-
 net/mptcp/subflow.c                                |  76 ++++-----
 net/netfilter/ipvs/ip_vs_ctl.c                     |   2 +-
 net/netfilter/nf_conntrack_proto.c                 |   2 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nfnetlink_cthelper.c                 |   8 +-
 net/netfilter/nft_ct.c                             |   2 +-
 net/nfc/llcp_sock.c                                |   2 +
 net/sched/act_ct.c                                 |  10 +-
 net/sched/sch_htb.c                                |   8 +-
 net/tipc/bearer.c                                  |  94 +++++++---
 net/tls/tls_device.c                               |  60 +++++--
 net/tls/tls_device_fallback.c                      |   7 +
 net/tls/tls_main.c                                 |   1 +
 samples/vfio-mdev/mdpy-fb.c                        |  13 +-
 scripts/Makefile.modfinal                          |   2 +-
 scripts/link-vmlinux.sh                            |   2 +-
 sound/core/timer.c                                 |   3 +-
 sound/pci/hda/hda_codec.c                          |   5 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 tools/perf/util/dwarf-aux.c                        |   8 +-
 tools/perf/util/probe-finder.c                     |   3 +
 tools/testing/selftests/wireguard/netns.sh         |   1 +
 .../testing/selftests/wireguard/qemu/kernel.config |   1 -
 179 files changed, 1677 insertions(+), 1069 deletions(-)


