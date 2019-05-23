Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 682B2289B2
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389993AbfEWTUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389984AbfEWTUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:20:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F61520863;
        Thu, 23 May 2019 19:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639215;
        bh=CNgSOeITwMBnAtYQN1F/c5UY2qBd6qyrbbIpxaACiEI=;
        h=From:To:Cc:Subject:Date:From;
        b=ZBN85LBhDxA7zwRFLaJq1dEdEyJShmfGvtUuLxRQnPkNh0wicTbsW6S983CY6GAwD
         5jkYW5wY7l3zdbBYBUc8bsjBQsRYGZEQOmqVLYDVTZL1DkmILqPrgjR4maBN0Kgkws
         8ZjAgtUwbftOF9Yp6gXCgH1SYYcoE0EirtONPywA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.0 000/139] 5.0.19-stable review
Date:   Thu, 23 May 2019 21:04:48 +0200
Message-Id: <20190523181720.120897565@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.0.19-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.0.19-rc1
X-KernelTest-Deadline: 2019-05-25T18:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.0.19 release.
There are 139 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 25 May 2019 06:14:53 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.19-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.0.19-rc1

Daniel Borkmann <daniel@iogearbox.net>
    bpf, lru: avoid messing with eviction heuristics upon syscall lookup

Daniel Borkmann <daniel@iogearbox.net>
    bpf: add map_lookup_elem_sys_only for lookups from syscall side

Chenbo Feng <fengc@google.com>
    bpf: relax inode permission check for retrieving bpf program

John Garry <john.garry@huawei.com>
    driver core: Postpone DMA tear-down until after devres release for probe failure

Nigel Croxon <ncroxon@redhat.com>
    md/raid: raid5 preserve the writeback action after the parity check

Song Liu <songliubraving@fb.com>
    Revert "Don't jump to compute_result state from check_result state"

Jiri Olsa <jolsa@kernel.org>
    perf/x86/intel: Fix race in intel_pmu_disable_event()

Leo Yan <leo.yan@linaro.org>
    perf cs-etm: Always allocate memory for cs_etm_queue::prev_packet

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bench numa: Add define for RUSAGE_THREAD if not present

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: designware: ratelimit 'transfer when suspended' errors

Al Viro <viro@zeniv.linux.org.uk>
    ufs: fix braino in ufs_get_inode_gid() for solaris UFS flavour

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: selftests: make hyperv_cpuid test pass on AMD

Paolo Bonzini <pbonzini@redhat.com>
    KVM: fix KVM_CLEAR_DIRTY_LOG for memory slots of unaligned size

Gary Hook <Gary.Hook@amd.com>
    x86/mm/mem_encrypt: Disable all instrumentation for early SME setup

Tobin C. Harding <tobin@kernel.org>
    sched/cpufreq: Fix kobject memleak

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: check for length correctness in iwl_mvm_create_skb()

Bjørn Mork <bjorn@mork.no>
    qmi_wwan: new Wistron, ZTE and D-Link devices

Peter Zijlstra <peterz@infradead.org>
    bpf: Fix preempt_enable_no_resched() abuse

Alban Crequy <alban@kinvolk.io>
    tools: bpftool: fix infinite loop in map create

Andrey Smirnov <andrew.smirnov@gmail.com>
    power: supply: sysfs: prevent endless uevent loop with CONFIG_POWER_SUPPLY_DEBUG

Andrew Jones <drjones@redhat.com>
    KVM: arm/arm64: Ensure vcpu target is unset on reset failure

Kangjie Lu <kjlu@umn.edu>
    net: ieee802154: fix missing checks for regmap_update_bits

Bhagavathi Perumal S <bperumal@codeaurora.org>
    mac80211: Fix kernel panic due to use of txq after free

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86: kvm: hyper-v: deal with buggy TLB flush requests from WS2012

Logan Gunthorpe <logang@deltatee.com>
    PCI: Fix issue with "pci=disable_acs_redir" parameter being ignored

Al Viro <viro@zeniv.linux.org.uk>
    apparmorfs: fix use-after-free on symlink traversal

Al Viro <viro@zeniv.linux.org.uk>
    securityfs: fix use-after-free on symlink traversal

Tony Lindgren <tony@atomide.com>
    power: supply: cpcap-battery: Fix division by zero

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Book3S: Protect memslots while validating user address

Suraj Jitindar Singh <sjitindarsingh@gmail.com>
    KVM: PPC: Book3S HV: Perserve PSSCR FAKE_SUSPEND bit on guest exit

Jernej Skrabec <jernej.skrabec@siol.net>
    clk: sunxi-ng: nkmp: Avoid GENMASK(-1, 0)

Vineet Gupta <vgupta@synopsys.com>
    ARC: PAE40: don't panic and instead turn off hw ioc

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm4: Fix uninitialized memory read in _decode_session4

Martin Willi <martin@strongswan.org>
    xfrm: Honor original L3 slave device in xfrmi policy lookup

Sabrina Dubroca <sd@queasysnail.net>
    esp4: add length check for UDP encapsulation

Cong Wang <xiyou.wangcong@gmail.com>
    xfrm: clean up xfrm protocol checks

Jeremy Sowden <jeremy@azazel.net>
    vti4: ipip tunnel deregistration fixes.

Su Yanjun <suyj.fnst@cn.fujitsu.com>
    xfrm6_tunnel: Fix potential panic when unloading xfrm6_tunnel module

Myungho Jung <mhjungk@gmail.com>
    xfrm: Reset secpath in xfrm failure

YueHaibing <yuehaibing@huawei.com>
    xfrm: policy: Fix out-of-bound array accesses in __xfrm_policy_unlink

Kirill Smelkov <kirr@nexedi.com>
    fuse: Add FOPEN_STREAM to use stream_open()

Martin Wilck <mwilck@suse.com>
    dm mpath: always free attached_handler_name in parse_path()

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: correctly calculate the size of metadata area

Milan Broz <gmazyland@gmail.com>
    dm crypt: move detailed message into debug level

Mikulas Patocka <mpatocka@redhat.com>
    dm delay: fix a crash when invalid device is specified

Damien Le Moal <damien.lemoal@wdc.com>
    dm zoned: Fix zone report handling

Nikos Tsironis <ntsironis@arrikto.com>
    dm cache metadata: Fix loading discard bitset

Stefan Mätje <stefan.maetje@esd.eu>
    PCI: Work around Pericom PCIe-to-PCI bridge Retrain Link erratum

Stefan Mätje <stefan.maetje@esd.eu>
    PCI: Factor out pcie_retrain_link() function

Kazufumi Ikeda <kaz-ikeda@xc.jp.nec.com>
    PCI: rcar: Add the initialization of PCIe link in resume_noirq()

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    PCI/AER: Change pci_aer_init() stub to return void

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    PCI: Init PCIe feature bits for managed host bridge alloc

Lyude Paul <lyude@redhat.com>
    PCI: Reset Lenovo ThinkPad P50 nvgpu at boot if necessary

James Prestwood <james.prestwood@linux.intel.com>
    PCI: Mark Atheros AR9462 to avoid bus reset

Nikolai Kostrigin <nickel@altlinux.org>
    PCI: Mark AMD Stoney Radeon R7 GPU ATS as broken

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix crashes and garbled display during DPMS modesetting

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: use 1024x768 by default on non-MIPS, fix garbled display

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix support for 1024x768-16 mode

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix crashes during framebuffer writes by correctly mapping VRAM

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix boot screen glitch when sm712fb replaces VGA

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix white screen of death on reboot, don't set CR3B-CR3F

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix VRAM detection, don't set SR70/71/74/75

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix brightness control on reboot, don't set SR30

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    fbdev/efifb: Ignore framebuffer memmap entries that lack any memory types

Dave Hansen <dave.hansen@linux.intel.com>
    x86/mpx, mm/core: Fix recursive munmap() corruption

Nathan Chancellor <natechancellor@gmail.com>
    objtool: Allow AR to be overridden with HOSTAR

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: perf: Fix build with CONFIG_CPU_BMIPS5000 enabled

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix sample timestamp wrt non-taken branches

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix improved sample timestamp

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix instructions sampling rate

Dmitry Osipenko <digetx@gmail.com>
    memory: tegra: Fix integer overflow on tick value calculation

Masami Hiramatsu <mhiramat@kernel.org>
    tracing: probeevent: Fix to make the type of $comm string

Elazar Leibovich <elazar@lightbitslabs.com>
    tracing: Fix partial reading of trace event's id file

Peter Zijlstra <peterz@infradead.org>
    ftrace/x86_64: Emulate call function while updating in breakpoint handler

Peter Zijlstra <peterz@infradead.org>
    x86_64: Allow breakpoints to emulate call instructions

Josh Poimboeuf <jpoimboe@redhat.com>
    x86_64: Add gap to int3 to allow for call emulation

Jeff Layton <jlayton@kernel.org>
    ceph: flush dirty inodes before proceeding with remount

Dmitry Osipenko <digetx@gmail.com>
    iommu/tegra-smmu: Fix invalid ASID bits on Tegra30/114

Chris Packham <chris.packham@alliedtelesis.co.nz>
    gcc-plugins: arm_ssp_per_task_plugin: Fix for older GCC < 6

Amir Goldstein <amir73il@gmail.com>
    ovl: fix missing upper fs freeze protection on copy up for ioctl

Liu Bo <bo.liu@linux.alibaba.com>
    fuse: honor RLIMIT_FSIZE in fuse_file_fallocate

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix writepages on 32bit

Mikulas Patocka <mpatocka@redhat.com>
    udlfb: introduce a rendering mutex

Mikulas Patocka <mpatocka@redhat.com>
    udlfb: fix sleeping inside spinlock

Mikulas Patocka <mpatocka@redhat.com>
    udlfb: delete the unused parameter for dlfb_handle_damage

Jonas Karlman <jonas@kwiboo.se>
    clk: rockchip: fix wrong clock definitions for rk3328

Owen Chen <owen.chen@mediatek.com>
    clk: mediatek: Disable tuner_en before change PLL rate

Dmitry Osipenko <digetx@gmail.com>
    clk: tegra: Fix PLLM programming on Tegra124+ when PMC overrides divider

Leo Yan <leo.yan@linaro.org>
    clk: hi3660: Mark clk_gate_ufs_subsys as critical

Olga Kornievskaia <kolga@netapp.com>
    PNFS fallback to MDS if no deviceid found

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    NFS4: Fix v4.0 client state corruption when mount

Leon Romanovsky <leon@kernel.org>
    RDMA/ipoib: Allow user space differentiate between valid dev_port

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Use get_zeroed_page() for clock_info

Steve Longerbeam <slongerbeam@gmail.com>
    media: imx: Clear fwnode link struct for each endpoint iteration

Steve Longerbeam <slongerbeam@gmail.com>
    media: imx: csi: Allow unknown nearest upstream entities

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix sensor possibly not detected on probe

Colin Ian King <colin.king@canonical.com>
    phy: ti-pipe3: fix missing bit-wise or operator when assigning val

Christoph Probst <kernel@probst.it>
    cifs: fix strcat buffer overflow and reduce raciness in smb21_set_oplock_level()

Hans de Goede <hdegoede@redhat.com>
    brcmfmac: Add DMI nvram filename quirk for ACEPC T8 and T11 mini PCs

Phong Tran <tranmanphong@gmail.com>
    of: fix clang -Wunsequenced for be32_to_cpu()

Pan Bian <bianpan2016@163.com>
    p54: drop device reference count if fails to enable device

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: msu: Fix single mode with IOMMU

Al Viro <viro@zeniv.linux.org.uk>
    dcache: sort the freeing-without-RCU-delay mess for good.

Christoph Hellwig <hch@lst.de>
    md: add a missing endianness conversion in check_sb_changes

Yufen Yu <yuyufen@huawei.com>
    md: add mddev->pers to avoid potential NULL pointer dereference

NeilBrown <neilb@suse.com>
    md: batch flush requests.

NeilBrown <neilb@suse.com>
    Revert "MD: fix lock contention for flush bios"

Paul Moore <paul@paul-moore.com>
    proc: prevent changes to overridden credentials

Hou Tao <houtao1@huawei.com>
    brd: re-enable __GFP_HIGHMEM in brd_insert_page()

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    stm class: Fix channel bitmap on 32-bit systems

Tingwei Zhang <tingwei@codeaurora.org>
    stm class: Fix channel free in stm output free path

Helge Deller <deller@gmx.de>
    parisc: Rename LEVEL to PA_ASM_LEVEL to avoid name clash with DRBD code

Helge Deller <deller@gmx.de>
    parisc: Use PA_ASM_LEVEL in boot code

Helge Deller <deller@gmx.de>
    parisc: Allow live-patching of __meminit functions

Helge Deller <deller@gmx.de>
    parisc: Add memory barrier to asm pdc and sync instructions

Helge Deller <deller@gmx.de>
    parisc: Skip registering LED when running in QEMU

John David Anglin <dave.anglin@bell.net>
    parisc: Add memory clobber to TLB purges

Helge Deller <deller@gmx.de>
    parisc: Export running_on_qemu symbol for modules

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: core: fix error path for regulator_set_voltage_unlocked

Ming Lei <ming.lei@redhat.com>
    blk-mq: free hw queue's resource in hctx's release handler

Ira Weiny <ira.weiny@intel.com>
    mm/gup: Remove the 'write' parameter from gup_fast_permitted()

Saeed Mahameed <saeedm@mellanox.com>
    net/mlx5e: Fix ethtool rxfh commands when CONFIG_MLX5_EN_RXNFC is disabled

Saeed Mahameed <saeedm@mellanox.com>
    net/mlx5: Imply MLXFW in mlx5_core

Dmytro Linkin <dmitrolin@mellanox.com>
    net/mlx5e: Additional check for flow destination comparison

Dmytro Linkin <dmitrolin@mellanox.com>
    net/mlx5e: Add missing ethtool driver info for representors

Jorge E. Moreira <jemoreira@google.com>
    vsock/virtio: Initialize core virtio vsock before registering the driver

Junwei Hu <hujunwei4@huawei.com>
    tipc: fix modprobe tipc failed after switch order of device registration

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: free packets during the socket release

Junwei Hu <hujunwei4@huawei.com>
    tipc: switch order of device registration to fix a crash

Sabrina Dubroca <sd@queasysnail.net>
    rtnetlink: always put IFLA_LINK for links with a link-netnsid

YueHaibing <yuehaibing@huawei.com>
    ppp: deflate: Fix possible crash in deflate_init

Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
    nfp: flower: add rcu locks when accessing netdev for tunnels

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit 0x1260 and 0x1261 compositions

Willem de Bruijn <willemb@google.com>
    net: test nouarg before dereferencing zerocopy pointers

Yunjian Wang <wangyunjian@huawei.com>
    net/mlx4_core: Change the error print to info print

Eric Dumazet <edumazet@google.com>
    net: avoid weird emergency message

Florian Fainelli <f.fainelli@gmail.com>
    net: Always descend into dsa/

Eric Dumazet <edumazet@google.com>
    ipv6: prevent possible fib6 leaks

Wei Wang <weiwan@google.com>
    ipv6: fix src addr routing with the exception table


-------------

Diffstat:

 Documentation/filesystems/porting                  |   5 +
 Documentation/virtual/kvm/api.txt                  |   5 +-
 Makefile                                           |   4 +-
 arch/arc/mm/cache.c                                |  31 +--
 arch/mips/kernel/perf_event_mipsxx.c               |  21 +-
 arch/parisc/boot/compressed/head.S                 |   6 +-
 arch/parisc/include/asm/assembly.h                 |   6 +-
 arch/parisc/include/asm/cache.h                    |  10 +-
 arch/parisc/kernel/head.S                          |   4 +-
 arch/parisc/kernel/process.c                       |   1 +
 arch/parisc/kernel/syscall.S                       |   2 +-
 arch/parisc/mm/init.c                              |   2 +-
 arch/powerpc/include/asm/mmu_context.h             |   1 -
 arch/powerpc/kvm/book3s_64_vio.c                   |   6 +-
 arch/powerpc/kvm/book3s_hv.c                       |   4 +-
 arch/um/include/asm/mmu_context.h                  |   1 -
 arch/unicore32/include/asm/mmu_context.h           |   1 -
 arch/x86/entry/entry_64.S                          |  18 +-
 arch/x86/events/intel/core.c                       |  10 +-
 arch/x86/include/asm/mmu_context.h                 |   6 +-
 arch/x86/include/asm/mpx.h                         |  15 +-
 arch/x86/include/asm/pgtable_64.h                  |   3 +-
 arch/x86/include/asm/text-patching.h               |  28 +++
 arch/x86/kernel/ftrace.c                           |  32 ++-
 arch/x86/kvm/hyperv.c                              |  11 +-
 arch/x86/lib/Makefile                              |  12 +
 arch/x86/mm/mpx.c                                  |  10 +-
 block/blk-core.c                                   |   2 +-
 block/blk-mq-sysfs.c                               |   6 +
 block/blk-mq.c                                     |   8 +-
 block/blk-mq.h                                     |   2 +-
 drivers/base/dd.c                                  |   5 +-
 drivers/block/brd.c                                |   7 +-
 drivers/clk/hisilicon/clk-hi3660.c                 |   6 +-
 drivers/clk/mediatek/clk-pll.c                     |  48 ++--
 drivers/clk/rockchip/clk-rk3328.c                  |  18 +-
 drivers/clk/sunxi-ng/ccu_nkmp.c                    |  18 +-
 drivers/clk/tegra/clk-pll.c                        |   4 +-
 drivers/hwtracing/intel_th/msu.c                   |  35 ++-
 drivers/hwtracing/stm/core.c                       |   9 +-
 drivers/i2c/busses/i2c-designware-master.c         |   3 +-
 drivers/infiniband/hw/mlx5/main.c                  |   5 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  13 +-
 drivers/iommu/tegra-smmu.c                         |  25 ++-
 drivers/md/dm-cache-metadata.c                     |   9 +-
 drivers/md/dm-crypt.c                              |   9 +-
 drivers/md/dm-delay.c                              |   3 +-
 drivers/md/dm-integrity.c                          |   4 +-
 drivers/md/dm-mpath.c                              |   2 +-
 drivers/md/dm-zoned-metadata.c                     |   5 +
 drivers/md/md.c                                    | 180 +++++++--------
 drivers/md/md.h                                    |  25 +--
 drivers/md/raid5.c                                 |  29 ++-
 drivers/media/i2c/ov6650.c                         |   2 +
 drivers/memory/tegra/mc.c                          |   2 +-
 drivers/net/Makefile                               |   2 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   2 +
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  30 +--
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |  17 +-
 drivers/net/ieee802154/mcr20a.c                    |   6 +
 drivers/net/ppp/ppp_deflate.c                      |  20 +-
 drivers/net/usb/qmi_wwan.c                         |  12 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |  26 +++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  28 ++-
 drivers/net/wireless/intersil/p54/p54pci.c         |   3 +-
 drivers/parisc/led.c                               |   3 +
 drivers/pci/controller/pcie-rcar.c                 |  21 ++
 drivers/pci/pci.c                                  |  19 +-
 drivers/pci/pci.h                                  |   2 +-
 drivers/pci/pcie/aspm.c                            |  49 +++--
 drivers/pci/probe.c                                |  23 +-
 drivers/pci/quirks.c                               |  77 +++++++
 drivers/phy/ti/phy-ti-pipe3.c                      |   2 +-
 drivers/power/supply/cpcap-battery.c               |   3 +
 drivers/power/supply/power_supply_sysfs.c          |   6 -
 drivers/regulator/core.c                           |  11 +-
 drivers/staging/media/imx/imx-media-csi.c          |  18 +-
 drivers/staging/media/imx/imx-media-of.c           |  15 +-
 drivers/video/fbdev/efifb.c                        |   8 +-
 drivers/video/fbdev/sm712.h                        |  12 +-
 drivers/video/fbdev/sm712fb.c                      | 242 +++++++++++++++++----
 drivers/video/fbdev/udlfb.c                        | 114 ++++++++--
 fs/ceph/super.c                                    |   7 +
 fs/cifs/smb2ops.c                                  |  14 +-
 fs/dcache.c                                        |  24 +-
 fs/fuse/file.c                                     |  13 +-
 fs/nfs/filelayout/filelayout.c                     |   2 +-
 fs/nfs/nfs4state.c                                 |   4 +
 fs/nsfs.c                                          |   3 +-
 fs/overlayfs/copy_up.c                             |   6 +-
 fs/overlayfs/file.c                                |   5 +-
 fs/overlayfs/overlayfs.h                           |   2 +-
 fs/proc/base.c                                     |   5 +
 fs/ufs/util.h                                      |   2 +-
 include/asm-generic/mm_hooks.h                     |   1 -
 include/linux/bpf.h                                |   3 +-
 include/linux/dcache.h                             |   2 +-
 include/linux/mlx5/driver.h                        |   1 -
 include/linux/of.h                                 |   4 +-
 include/linux/pci.h                                |   2 +
 include/linux/skbuff.h                             |   9 +-
 include/net/ip6_fib.h                              |   3 +-
 include/net/xfrm.h                                 |  20 +-
 include/uapi/linux/fuse.h                          |   2 +
 include/video/udlfb.h                              |   7 +
 kernel/bpf/hashtab.c                               |  23 +-
 kernel/bpf/inode.c                                 |   2 +-
 kernel/bpf/syscall.c                               |   5 +-
 kernel/sched/cpufreq_schedutil.c                   |   1 +
 kernel/trace/trace_events.c                        |   3 -
 kernel/trace/trace_probe.c                         |  13 +-
 lib/Makefile                                       |  11 +
 mm/gup.c                                           |   6 +-
 mm/mmap.c                                          |  15 +-
 net/core/dev.c                                     |   2 +-
 net/core/rtnetlink.c                               |  16 +-
 net/ipv4/esp4.c                                    |  20 +-
 net/ipv4/esp4_offload.c                            |   8 +-
 net/ipv4/ip_vti.c                                  |   5 +-
 net/ipv4/xfrm4_policy.c                            |  24 +-
 net/ipv6/esp6_offload.c                            |   8 +-
 net/ipv6/ip6_fib.c                                 |  12 +-
 net/ipv6/route.c                                   |  58 +++--
 net/ipv6/xfrm6_tunnel.c                            |   6 +-
 net/key/af_key.c                                   |   4 +-
 net/mac80211/iface.c                               |   3 +
 net/tipc/core.c                                    |  14 +-
 net/vmw_vsock/virtio_transport.c                   |  13 +-
 net/vmw_vsock/virtio_transport_common.c            |   7 +
 net/xfrm/xfrm_interface.c                          |  17 +-
 net/xfrm/xfrm_policy.c                             |   2 +-
 net/xfrm/xfrm_state.c                              |   2 +-
 net/xfrm/xfrm_user.c                               |  16 +-
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c      |   2 +-
 security/apparmor/apparmorfs.c                     |  13 +-
 security/inode.c                                   |  13 +-
 tools/bpf/bpftool/map.c                            |   3 +
 tools/objtool/Makefile                             |   3 +-
 tools/perf/bench/numa.c                            |   4 +
 tools/perf/util/cs-etm.c                           |   8 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |  31 ++-
 tools/testing/selftests/kvm/dirty_log_test.c       |   9 +-
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c  |   9 +-
 virt/kvm/arm/arm.c                                 |  11 +-
 virt/kvm/kvm_main.c                                |   7 +-
 149 files changed, 1467 insertions(+), 653 deletions(-)


