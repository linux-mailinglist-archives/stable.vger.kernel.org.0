Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411AC2886E
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390302AbfEWT0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391273AbfEWT0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:26:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64DB12054F;
        Thu, 23 May 2019 19:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639564;
        bh=e4z/RochkftYJQTADzin+d7vnbuj1hs0jbmOjVdjtZ4=;
        h=From:To:Cc:Subject:Date:From;
        b=QekyoVPRljofAiq1+HW4bvwDlaAZcItBfq40nYXr0R7Z2zCOrQyFBHnFj/I27eyvF
         bj/QcGTlid3tthdfuGqGyzzXom4vptLZLe7eByeQQyE04l5l8UmvK/4xr56Ej+xgNs
         PUvNdaQV56nHO3Lyz7hIVu8OOvFRiL6N6oS+iD9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.1 000/122] 5.1.5-stable review
Date:   Thu, 23 May 2019 21:05:22 +0200
Message-Id: <20190523181705.091418060@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.1.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.1.5-rc1
X-KernelTest-Deadline: 2019-05-25T18:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.1.5 release.
There are 122 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 25 May 2019 06:14:44 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.1.5-rc1

Adam Ford <aford173@gmail.com>
    ARM: dts: imx6q-logicpd: Reduce inrush current on start

Adam Ford <aford173@gmail.com>
    ARM: dts: imx6q-logicpd: Reduce inrush current on USBH1

Qu Wenruo <wqu@suse.com>
    btrfs: reloc: Fix NULL pointer dereference due to expanded reloc_root lifespan

Arnd Bergmann <arnd@arndb.de>
    y2038: Make CONFIG_64BIT_TIME unconditional

Daniel Borkmann <daniel@iogearbox.net>
    bpf, lru: avoid messing with eviction heuristics upon syscall lookup

Daniel Borkmann <daniel@iogearbox.net>
    bpf: add map_lookup_elem_sys_only for lookups from syscall side

Chenbo Feng <fengc@google.com>
    bpf: relax inode permission check for retrieving bpf program

John Garry <john.garry@huawei.com>
    driver core: Postpone DMA tear-down until after devres release for probe failure

Angus Ainslie (Purism) <angus@akkea.ca>
    dmaengine: imx-sdma: Only check ratio on parts that support 1:1

Nigel Croxon <ncroxon@redhat.com>
    md/raid: raid5 preserve the writeback action after the parity check

Song Liu <songliubraving@fb.com>
    Revert "Don't jump to compute_result state from check_result state"

Michael Lass <bevan@bi-co.net>
    dm: make sure to obey max_io_len_target_boundary

Kirill Smelkov <kirr@nexedi.com>
    fuse: Add FOPEN_STREAM to use stream_open()

Martin Wilck <mwilck@suse.com>
    dm mpath: always free attached_handler_name in parse_path()

Helen Koike <helen.koike@collabora.com>
    dm ioctl: fix hang in early create error condition

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: correctly calculate the size of metadata area

Milan Broz <gmazyland@gmail.com>
    dm crypt: move detailed message into debug level

Mikulas Patocka <mpatocka@redhat.com>
    dm delay: fix a crash when invalid device is specified

Helen Koike <helen.koike@collabora.com>
    dm init: fix max devices/targets checks

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
    fsnotify: fix unlink performance regression

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
    media: imx: Don't register IPU subdevs/links if CSI port missing

Steve Longerbeam <slongerbeam@gmail.com>
    media: imx: Rename functions that add IPU-internal subdevs

Steve Longerbeam <slongerbeam@gmail.com>
    media: imx: Clear fwnode link struct for each endpoint iteration

Steve Longerbeam <slongerbeam@gmail.com>
    media: imx: csi: Allow unknown nearest upstream entities

Arnd Bergmann <arnd@arndb.de>
    media: seco-cec: fix building with RC_CORE=m

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix sensor possibly not detected on probe

Colin Ian King <colin.king@canonical.com>
    phy: ti-pipe3: fix missing bit-wise or operator when assigning val

Christoph Probst <kernel@probst.it>
    cifs: fix strcat buffer overflow and reduce raciness in smb21_set_oplock_level()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix credits leak for SMB1 oplock breaks

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

Bodong Wang <bodong@mellanox.com>
    net/mlx5: Fix peer pf disable hca command

Jianbo Liu <jianbol@mellanox.com>
    net/mlx5e: Fix calling wrong function to get inner vlan key and mask

Edward Cree <ecree@solarflare.com>
    flow_offload: support CVLAN match

Vadim Pasternak <vadimp@mellanox.com>
    mlxsw: core: Prevent reading unsupported slave address from SFP EEPROM

Vadim Pasternak <vadimp@mellanox.com>
    mlxsw: core: Prevent QSFP module initialization for old hardware

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
 Makefile                                           |   4 +-
 arch/Kconfig                                       |   2 +-
 arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi      |   2 +
 arch/mips/kernel/perf_event_mipsxx.c               |  21 +-
 arch/parisc/boot/compressed/head.S                 |   6 +-
 arch/parisc/include/asm/assembly.h                 |   6 +-
 arch/parisc/include/asm/cache.h                    |  10 +-
 arch/parisc/kernel/head.S                          |   4 +-
 arch/parisc/kernel/process.c                       |   1 +
 arch/parisc/kernel/syscall.S                       |   2 +-
 arch/parisc/mm/init.c                              |   2 +-
 arch/powerpc/include/asm/mmu_context.h             |   1 -
 arch/um/include/asm/mmu_context.h                  |   1 -
 arch/unicore32/include/asm/mmu_context.h           |   1 -
 arch/x86/entry/entry_64.S                          |  18 +-
 arch/x86/include/asm/mmu_context.h                 |   6 +-
 arch/x86/include/asm/mpx.h                         |  15 +-
 arch/x86/include/asm/text-patching.h               |  28 +++
 arch/x86/kernel/ftrace.c                           |  32 ++-
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
 drivers/clk/tegra/clk-pll.c                        |   4 +-
 drivers/dma/imx-sdma.c                             |  15 +-
 drivers/hwtracing/intel_th/msu.c                   |  35 ++-
 drivers/hwtracing/stm/core.c                       |   9 +-
 drivers/infiniband/hw/mlx5/main.c                  |   5 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  13 +-
 drivers/iommu/tegra-smmu.c                         |  25 ++-
 drivers/md/dm-cache-metadata.c                     |   9 +-
 drivers/md/dm-crypt.c                              |   9 +-
 drivers/md/dm-delay.c                              |   3 +-
 drivers/md/dm-init.c                               |   8 +-
 drivers/md/dm-integrity.c                          |   4 +-
 drivers/md/dm-ioctl.c                              |   6 +-
 drivers/md/dm-mpath.c                              |   2 +-
 drivers/md/dm-zoned-metadata.c                     |   5 +
 drivers/md/dm.c                                    |   4 +-
 drivers/md/md.c                                    | 180 +++++++--------
 drivers/md/md.h                                    |  25 +--
 drivers/md/raid5.c                                 |  29 ++-
 drivers/media/i2c/ov6650.c                         |   2 +
 drivers/media/platform/Kconfig                     |   2 +-
 drivers/memory/tegra/mc.c                          |   2 +-
 drivers/net/Makefile                               |   2 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   2 +
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  30 +--
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   6 +
 drivers/net/ethernet/mellanox/mlxsw/core.h         |   2 +
 drivers/net/ethernet/mellanox/mlxsw/core_env.c     |  18 +-
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   |   3 +
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |   6 +
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |  17 +-
 drivers/net/ppp/ppp_deflate.c                      |  20 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |  26 +++
 drivers/net/wireless/intersil/p54/p54pci.c         |   3 +-
 drivers/parisc/led.c                               |   3 +
 drivers/pci/controller/pcie-rcar.c                 |  21 ++
 drivers/pci/pci.h                                  |   2 +-
 drivers/pci/pcie/aspm.c                            |  49 +++--
 drivers/pci/probe.c                                |  23 +-
 drivers/pci/quirks.c                               |  77 +++++++
 drivers/phy/ti/phy-ti-pipe3.c                      |   2 +-
 drivers/regulator/core.c                           |  11 +-
 drivers/staging/media/imx/imx-ic-common.c          |   2 +-
 drivers/staging/media/imx/imx-media-csi.c          |  18 +-
 drivers/staging/media/imx/imx-media-dev.c          |  11 +-
 drivers/staging/media/imx/imx-media-internal-sd.c  |  32 +--
 drivers/staging/media/imx/imx-media-of.c           |  73 ++++---
 drivers/staging/media/imx/imx-media-vdic.c         |   2 +-
 drivers/staging/media/imx/imx-media.h              |   7 +-
 drivers/staging/media/imx/imx7-media-csi.c         |   2 +-
 drivers/video/fbdev/efifb.c                        |   8 +-
 drivers/video/fbdev/sm712.h                        |  12 +-
 drivers/video/fbdev/sm712fb.c                      | 242 +++++++++++++++++----
 drivers/video/fbdev/udlfb.c                        | 114 ++++++++--
 fs/btrfs/relocation.c                              |  12 +-
 fs/ceph/super.c                                    |   7 +
 fs/cifs/cifsglob.h                                 |   1 +
 fs/cifs/cifssmb.c                                  |   2 +-
 fs/cifs/smb2ops.c                                  |  14 +-
 fs/cifs/transport.c                                |  10 +-
 fs/dcache.c                                        |  24 +-
 fs/fuse/file.c                                     |  13 +-
 fs/nfs/filelayout/filelayout.c                     |   2 +-
 fs/nfs/nfs4state.c                                 |   4 +
 fs/notify/fsnotify.c                               |  41 ++++
 fs/nsfs.c                                          |   3 +-
 fs/overlayfs/copy_up.c                             |   6 +-
 fs/overlayfs/file.c                                |   5 +-
 fs/overlayfs/overlayfs.h                           |   2 +-
 fs/proc/base.c                                     |   5 +
 include/asm-generic/mm_hooks.h                     |   1 -
 include/linux/bpf.h                                |   1 +
 include/linux/dcache.h                             |   2 +-
 include/linux/fsnotify.h                           |  33 ---
 include/linux/fsnotify_backend.h                   |   4 +
 include/linux/mlx5/driver.h                        |   1 -
 include/linux/of.h                                 |   4 +-
 include/linux/pci.h                                |   2 +
 include/linux/skbuff.h                             |   9 +-
 include/net/flow_offload.h                         |   2 +
 include/net/ip6_fib.h                              |   3 +-
 include/uapi/linux/fuse.h                          |   2 +
 include/video/udlfb.h                              |   7 +
 kernel/bpf/hashtab.c                               |  23 +-
 kernel/bpf/inode.c                                 |   2 +-
 kernel/bpf/syscall.c                               |   5 +-
 kernel/trace/trace_events.c                        |   3 -
 kernel/trace/trace_probe.c                         |  13 +-
 mm/mmap.c                                          |  15 +-
 net/core/dev.c                                     |   2 +-
 net/core/flow_offload.c                            |   7 +
 net/core/rtnetlink.c                               |  16 +-
 net/ipv6/ip6_fib.c                                 |  12 +-
 net/ipv6/route.c                                   |  58 +++--
 net/tipc/core.c                                    |  14 +-
 net/vmw_vsock/virtio_transport.c                   |  13 +-
 net/vmw_vsock/virtio_transport_common.c            |   7 +
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c      |   2 +-
 tools/objtool/Makefile                             |   3 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |  31 ++-
 137 files changed, 1366 insertions(+), 649 deletions(-)


