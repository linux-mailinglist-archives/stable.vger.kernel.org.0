Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADA499C1F
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404517AbfHVRZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391878AbfHVRZv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:51 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E64332341D;
        Thu, 22 Aug 2019 17:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494750;
        bh=95urw0Uq+N7EEdAn7bHjsboW3JFHSjTtg2CLXPxALaU=;
        h=From:To:Cc:Subject:Date:From;
        b=rloW+ckf7q3NO7lcEIXmeEpijxKO/0RJTj9UyY5WwkAK/ZEHH+2mOl4ajhj+5/tsp
         bXorMKE9bVT9q27K6MmkjU/Ek8MIgxn4BU3J4WkBVqwrPMtgfe8SnlPYDq3ej5JmWm
         QTsZZvCCwZzuqdBBHnBOk6sJFuUyje91SQtaWdag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/85] 4.19.68-stable review
Date:   Thu, 22 Aug 2019 10:18:33 -0700
Message-Id: <20190822171731.012687054@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.68-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.68-rc1
X-KernelTest-Deadline: 2019-08-24T17:17+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.68 release.
There are 85 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 24 Aug 2019 05:15:49 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.68-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.68-rc1

Michal Simek <michal.simek@xilinx.com>
    mmc: sdhci-of-arasan: Do now show error message in case of deffered probe

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Use flow keys dissector to parse packets for ARFS

Huy Nguyen <huyn@mellanox.com>
    net/mlx5e: Only support tx/rx pause setting for port owner

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen/netback: Reset nr_frags before freeing skb

Chris Packham <chris.packham@alliedtelesis.co.nz>
    tipc: initialise addr_trail_end when setting node addresses

YueHaibing <yuehaibing@huawei.com>
    team: Add vlan tx offload to hw_enc_features

Xin Long <lucien.xin@gmail.com>
    sctp: fix the transport error_count check

zhengbin <zhengbin13@huawei.com>
    sctp: fix memleak in sctp_send_reset_streams

Eric Dumazet <edumazet@google.com>
    net/packet: fix race in tpacket_snd()

Wenwen Wang <wenwen@cs.uga.edu>
    net/mlx4_en: fix a memory leak bug

Chen-Yu Tsai <wens@csie.org>
    net: dsa: Check existence of .port_mdb_add callback before calling it

YueHaibing <yuehaibing@huawei.com>
    bonding: Add vlan tx offload to hw_enc_features

Manish Chopra <manishc@marvell.com>
    bnx2x: Fix VF's VLAN reconfiguration in reload.

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Move iommu_init_pci() to .init section

YueHaibing <yuehaibing@huawei.com>
    Input: psmouse - fix build error of multiple definition

Dirk Morris <dmorris@metaloft.com>
    netfilter: conntrack: Use consistent ct id hash calculation

Will Deacon <will@kernel.org>
    arm64: ftrace: Ensure module ftrace trampoline is coherent with I-side

Mike Snitzer <snitzer@redhat.com>
    dm: disable DISCARD if the underlying storage no longer supports it

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/i915/cfl: Add a new CFL PCI ID.

Tony Lindgren <tony@atomide.com>
    USB: serial: option: Add Motorola modem UARTs

Bob Ham <bob.ham@puri.sm>
    USB: serial: option: add the BroadMobi BM818 card

Yoshiaki Okamoto <yokamoto@allied-telesis.co.jp>
    USB: serial: option: Add support for ZTE MF871A

Rogan Dawes <rogan@dawes.za.net>
    USB: serial: option: add D-Link DWM-222 device ID

Oliver Neukum <oneukum@suse.com>
    USB: CDC: fix sanity checks in CDC union parser

Oliver Neukum <oneukum@suse.com>
    usb: cdc-acm: make sure a refcount is taken early enough

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: gadget: udc: renesas_usb3: Fix sysfs interface of "role"

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix races in character device registration and deregistraion

Jacopo Mondi <jacopo+renesas@jmondi.org>
    iio: adc: max9611: Fix temperature reading in probe

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: dt3000: Fix rounding up of timer divisor

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: dt3000: Fix signed integer overflow 'divider * base'

Marc Zyngier <maz@kernel.org>
    KVM: arm/arm64: Sync ICH_VMCR_EL2 back when about to block

Anders Roxell <anders.roxell@linaro.org>
    arm64: KVM: regmap: Fix unexpected switch fall-through

Qian Cai <cai@lca.pw>
    asm-generic: fix -Wtype-limits compiler warnings

YueHaibing <yuehaibing@huawei.com>
    ocfs2: remove set but not used variable 'last_hash'

Yang Shi <yang.shi@linux.alibaba.com>
    Revert "kmemleak: allow to coexist with fault injection"

Colin Ian King <colin.king@canonical.com>
    drm/exynos: fix missing decrement of retry counter

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    drm: msm: Fix add_gpu_components

Jack Morgenstein <jackm@dev.mellanox.co.il>
    IB/mad: Fix use-after-free in ib mad completion handling

Guy Levi <guyle@mellanox.com>
    IB/mlx5: Fix MR registration flow to use UMR properly

Tony Luck <tony.luck@intel.com>
    IB/core: Add mitigation for Spectre V1

Qian Cai <cai@lca.pw>
    arm64/mm: fix variable 'pud' set but not used

Masami Hiramatsu <mhiramat@kernel.org>
    arm64: unwind: Prohibit probing on return_address()

Qian Cai <cai@lca.pw>
    arm64/efi: fix variable 'si' set but not used

Stephen Boyd <swboyd@chromium.org>
    kbuild: Check for unknown options with cc-option usage in Kconfig and clang

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: modpost: handle KBUILD_EXTRA_SYMBOLS only for external modules

Miquel Raynal <miquel.raynal@bootlin.com>
    ata: libahci: do not complain in case of deferred probe

Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
    drm/amdgpu: fix a potential information leaking bug

Jia-Ju Bai <baijiaju1990@gmail.com>
    scsi: qla2xxx: Fix possible fcport null-pointer dereferences

Don Brace <don.brace@microsemi.com>
    scsi: hpsa: correct scsi command status issue after reset

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix deadlock between fiemap and transaction commits

YueHaibing <yuehaibing@huawei.com>
    drm/bridge: lvds-encoder: Fix build error while CONFIG_DRM_KMS_HELPER=m

Kees Cook <keescook@chromium.org>
    libata: zpodd: Fix small read overflow in zpodd_get_mech_type()

Numfor Mbiziwo-Tiapo <nums@google.com>
    perf header: Fix use of unitialized value warning

Vince Weaver <vincent.weaver@maine.edu>
    perf header: Fix divide by zero error if f_header.attr_size==0

Lucas Stach <l.stach@pengutronix.de>
    irqchip/irq-imx-gpcv2: Forward irq type to parent

Nianyao Tang <tangnianyao@huawei.com>
    irqchip/gic-v3-its: Free unused vpt_page when alloc vpe table fail

YueHaibing <yuehaibing@huawei.com>
    xen/pciback: remove set but not used variable 'old_state'

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: cpg-mssr: Fix reset control race condition

Chunyan Zhang <chunyan.zhang@unisoc.com>
    clk: sprd: Select REGMAP_MMIO to avoid compile errors

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    clk: at91: generated: Truncate divisor to GENERATED_MAX_DIV + 1

Vincent Chen <vincent.chen@sifive.com>
    riscv: Make __fstate_clean() work correctly.

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: also count base chain policies

Denis Kirjanov <kda@linux-powerpc.org>
    net: usb: pegasus: fix improper read if get_registers() fail

Oliver Neukum <oneukum@suse.com>
    Input: iforce - add sanity checks

Oliver Neukum <oneukum@suse.com>
    Input: kbtab - sanity check for endpoint type

Hillf Danton <hdanton@sina.com>
    HID: hiddev: do cleanup in failure of opening a device

Hillf Danton <hdanton@sina.com>
    HID: hiddev: avoid opening a disconnected device

Oliver Neukum <oneukum@suse.com>
    HID: holtek: test for sanity of intfdata

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - Let all conexant codec enter D3 when rebooting

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - Add a generic reboot_notify

Wenwen Wang <wenwen@cs.uga.edu>
    ALSA: hda - Fix a memory leak bug

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Apply workaround for another AMD chip 1022:1487

Hui Peng <benquike@gmail.com>
    ALSA: usb-audio: Fix an OOB bug in parse_audio_mixer_unit

Hui Peng <benquike@gmail.com>
    ALSA: usb-audio: Fix a stack buffer overflow bug in check_input_term

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Add quirk for HP Envy x360

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: add missing isync to the cpu_reset TLB code

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: schedutil: Don't skip freq update when limits change

Fabrice Gasnier <fabrice.gasnier@st.com>
    Revert "pwm: Set class for exported channels in sysfs"

Isaac J. Manjarres <isaacm@codeaurora.org>
    mm/usercopy: use memory range to be accessed for wraparound check

Miles Chen <miles.chen@mediatek.com>
    mm/memcontrol.c: fix use after free in mem_cgroup_iter()

Yang Shi <yang.shi@linux.alibaba.com>
    mm: mempolicy: handle vma with unmovable pages mapped correctly in mbind

Yang Shi <yang.shi@linux.alibaba.com>
    mm: mempolicy: make the behavior consistent when MPOL_MF_MOVE* and MPOL_MF_STRICT were specified

Ralph Campbell <rcampbell@nvidia.com>
    mm/hmm: fix bad subpage pointer in try_to_unmap_one

NeilBrown <neilb@suse.com>
    seq_file: fix problem when seeking mid-record

Gustavo A. R. Silva <gustavo@embeddedor.com>
    sh: kernel: hw_breakpoint: Fix missing break in switch statement


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/efi.h                       |   6 +-
 arch/arm64/include/asm/pgtable.h                   |   4 +-
 arch/arm64/kernel/ftrace.c                         |  21 +++--
 arch/arm64/kernel/return_address.c                 |   3 +
 arch/arm64/kernel/stacktrace.c                     |   3 +
 arch/arm64/kvm/regmap.c                            |   5 ++
 arch/riscv/include/asm/switch_to.h                 |   2 +-
 arch/sh/kernel/hw_breakpoint.c                     |   1 +
 arch/xtensa/kernel/setup.c                         |   1 +
 drivers/ata/libahci_platform.c                     |   3 +
 drivers/ata/libata-zpodd.c                         |   2 +-
 drivers/clk/at91/clk-generated.c                   |   2 +
 drivers/clk/renesas/renesas-cpg-mssr.c             |  16 +---
 drivers/clk/sprd/Kconfig                           |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   2 +-
 drivers/gpu/drm/bridge/Kconfig                     |   1 +
 drivers/gpu/drm/exynos/exynos_drm_scaler.c         |   4 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   3 +-
 drivers/hid/hid-holtek-kbd.c                       |   9 +-
 drivers/hid/usbhid/hiddev.c                        |  12 +++
 drivers/iio/adc/max9611.c                          |   2 +-
 drivers/infiniband/core/mad.c                      |  20 ++---
 drivers/infiniband/core/user_mad.c                 |   6 +-
 drivers/infiniband/hw/mlx5/mr.c                    |  27 ++----
 drivers/input/joystick/iforce/iforce-usb.c         |   5 ++
 drivers/input/mouse/trackpoint.h                   |   3 +-
 drivers/input/tablet/kbtab.c                       |   6 +-
 drivers/iommu/amd_iommu_init.c                     |   2 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   2 +-
 drivers/irqchip/irq-imx-gpcv2.c                    |   1 +
 drivers/md/dm-core.h                               |   1 +
 drivers/md/dm-rq.c                                 |  11 ++-
 drivers/md/dm.c                                    |  20 ++++-
 drivers/mmc/host/sdhci-of-arasan.c                 |   3 +-
 drivers/net/bonding/bond_main.c                    |   2 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   7 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    |   2 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  17 ++--
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |  97 +++++++-------------
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   3 +
 drivers/net/team/team.c                            |   2 +
 drivers/net/usb/pegasus.c                          |   2 +-
 drivers/net/xen-netback/netback.c                  |   2 +
 drivers/pwm/sysfs.c                                |   1 -
 drivers/scsi/hpsa.c                                |  12 ++-
 drivers/scsi/qla2xxx/qla_init.c                    |   2 +-
 drivers/staging/comedi/drivers/dt3000.c            |   8 +-
 drivers/usb/class/cdc-acm.c                        |  12 +--
 drivers/usb/core/file.c                            |  10 +--
 drivers/usb/core/message.c                         |   4 +-
 drivers/usb/gadget/udc/renesas_usb3.c              |   5 +-
 drivers/usb/serial/option.c                        |  10 +++
 drivers/xen/xen-pciback/conf_space_capability.c    |   3 +-
 fs/btrfs/backref.c                                 |   2 +-
 fs/btrfs/transaction.c                             |  22 ++++-
 fs/btrfs/transaction.h                             |   3 +
 fs/ocfs2/xattr.c                                   |   3 -
 fs/seq_file.c                                      |   2 +-
 include/asm-generic/getorder.h                     |  50 +++++------
 include/drm/i915_pciids.h                          |   1 +
 include/kvm/arm_vgic.h                             |   1 +
 kernel/sched/cpufreq_schedutil.c                   |  14 ++-
 mm/kmemleak.c                                      |   2 +-
 mm/memcontrol.c                                    |  39 +++++---
 mm/mempolicy.c                                     | 100 +++++++++++++++------
 mm/rmap.c                                          |   8 ++
 mm/usercopy.c                                      |   2 +-
 net/bridge/netfilter/ebtables.c                    |  28 +++---
 net/dsa/switch.c                                   |   3 +
 net/netfilter/nf_conntrack_core.c                  |  16 ++--
 net/packet/af_packet.c                             |   7 ++
 net/sctp/sm_sideeffect.c                           |   2 +-
 net/sctp/stream.c                                  |   1 +
 net/tipc/addr.c                                    |   1 +
 scripts/Kconfig.include                            |   2 +-
 scripts/Makefile.modpost                           |   2 +-
 sound/pci/hda/hda_generic.c                        |  21 ++++-
 sound/pci/hda/hda_generic.h                        |   1 +
 sound/pci/hda/hda_intel.c                          |   3 +
 sound/pci/hda/patch_conexant.c                     |  15 +---
 sound/pci/hda/patch_realtek.c                      |  12 +--
 sound/usb/mixer.c                                  |  37 ++++++--
 tools/perf/util/header.c                           |   9 +-
 virt/kvm/arm/arm.c                                 |  11 +++
 virt/kvm/arm/vgic/vgic-v2.c                        |   9 +-
 virt/kvm/arm/vgic/vgic-v3.c                        |   7 +-
 virt/kvm/arm/vgic/vgic.c                           |  11 +++
 virt/kvm/arm/vgic/vgic.h                           |   2 +
 90 files changed, 551 insertions(+), 316 deletions(-)


