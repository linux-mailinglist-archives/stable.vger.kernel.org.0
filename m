Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850E52F1AB1
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 17:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731411AbhAKQPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 11:15:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732839AbhAKQPG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 11:15:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F04F9225AB;
        Mon, 11 Jan 2021 16:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610381665;
        bh=HQaK/VQAEVoR7fcdis/W292WDTshvaor7b19PgZ4V88=;
        h=From:To:Cc:Subject:Date:From;
        b=UZLn35L7S51aYBjFert/dHhbvruOSu+MPXm0+sfuKiN5Ep3OZtllkIIi7Ff8EjiEo
         rSR5quSgRQLIrExF6TVCDZecP7HrH/be5ZfrW0agOMEHQlQCDRHhCeUw0GqPm8j4rr
         m+q8WY8ePYRRSomjOaYC5i0AAk6yrxbrQFiwm+ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.10 000/144] 5.10.7-rc2 review
Date:   Mon, 11 Jan 2021 17:15:35 +0100
Message-Id: <20210111161510.602817176@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.7-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.7-rc2
X-KernelTest-Deadline: 2021-01-13T16:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.7 release.
There are 144 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 13 Jan 2021 16:14:43 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.7-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.7-rc2

Ping-Ke Shih <pkshih@realtek.com>
    rtlwifi: rise completion at the last step of firmware callback

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Fix memory leak for failed bind

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix shift out of bounds reported by UBSAN

Ying-Tsun Huang <ying-tsun.huang@amd.com>
    x86/mtrr: Correct the range check before performing MTRR type lookups

Dan Carpenter <dan.carpenter@oracle.com>
    dmaengine: idxd: off by one in cleanup code

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_dynset: report EOPNOTSUPP on missing set feature

Florian Westphal <fw@strlen.de>
    netfilter: xt_RATEEST: reject non-null terminated string from userspace

Vasily Averin <vvs@virtuozzo.com>
    netfilter: ipset: fix shift-out-of-bounds in htable_bits()

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
    netfilter: x_tables: Update remaining dereference to RCU

Aaro Koskinen <aaro.koskinen@iki.fi>
    ARM: dts: OMAP3: disable AES on N950/N9

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5e: Fix SWP offsets when vlan inserted by driver

Coly Li <colyli@suse.de>
    bcache: introduce BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE for large bucket

Coly Li <colyli@suse.de>
    bcache: check unsupported feature sets for bcache register

Coly Li <colyli@suse.de>
    bcache: fix typo from SUUP to SUPP in features.h

Matthew Auld <matthew.auld@intel.com>
    drm/i915: clear the gpu reloc batch

Matthew Auld <matthew.auld@intel.com>
    drm/i915: clear the shadow batch

Nick Desaulniers <ndesaulniers@google.com>
    arm64: link with -z norelro for LLD or aarch64-elf

Charan Teja Reddy <charante@codeaurora.org>
    dmabuf: fix use-after-free of dmabuf's file->f_inode

Bard Liao <yung-chuan.liao@linux.intel.com>
    Revert "device property: Keep secondary firmware node secondary by type"

Filipe Manana <fdmanana@suse.com>
    btrfs: send: fix wrong file path when there is an inode with a pending rmdir

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: don't try to wait flushing if we're already holding a transaction

Liu Yi L <yi.l.liu@intel.com>
    iommu/vt-d: Move intel_iommu info from struct intel_svm to struct intel_svm_dev

PeiSen Hou <pshou@realtek.com>
    ALSA: hda/realtek: Add two "Intel Reference board" SSID in the ALC256.

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Enable mute and micmute LED on HP EliteBook 850 G7

Manuel Jiménez <mjbfm99@me.com>
    ALSA: hda/realtek: Add mute LED quirk for more HP laptops

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fix speaker volume control on Lenovo C940

bo liu <bo.liu@senarytech.com>
    ALSA: hda/conexant: add a new hda codec CX11970

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/via: Fix runtime PM for Clevo W35xSS

Tejun Heo <tj@kernel.org>
    blk-iocost: fix NULL iocg deref from racing against initialization

Fenghua Yu <fenghua.yu@intel.com>
    x86/resctrl: Don't move a task to the same resource group

Fenghua Yu <fenghua.yu@intel.com>
    x86/resctrl: Use an IPI instead of task_work_add() to update PQR_ASSOC MSR

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Ensure TDP MMU roots are freed after yield

Lai Jiangshan <laijs@linux.alibaba.com>
    kvm: check tlbs_dirty directly

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Get root level from walkers when retrieving MMIO SPTE

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Use -1 to flag an undefined spte in get_mmio_spte()

Dan Williams <dan.j.williams@intel.com>
    x86/mm: Fix leak of pmd ptlock

Linus Torvalds <torvalds@linux-foundation.org>
    mm: make wait_on_page_writeback() wait for multiple pending writebacks

David Arcari <darcari@redhat.com>
    hwmon: (amd_energy) fix allocation of hwmon_channel_info config

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: remove unused variable

Eddie Hung <eddie.hung@mediatek.com>
    usb: gadget: configfs: Fix use-after-free issue with udc_name

Chandana Kishori Chiluveru <cchiluve@codeaurora.org>
    usb: gadget: configfs: Preserve function ordering after bind failure

Sriharsha Allenki <sallenki@codeaurora.org>
    usb: gadget: Fix spinlock lockup on usb_function_deactivate

Yang Yingliang <yangyingliang@huawei.com>
    USB: gadget: legacy: fix return error code in acm_ms_bind()

Manish Narani <manish.narani@xilinx.com>
    usb: gadget: u_ether: Fix MTU size mismatch with RX packet size

Zqiang <qiang.zhang@windriver.com>
    usb: gadget: function: printer: Fix a memory leak for interface descriptor

Jerome Brunet <jbrunet@baylibre.com>
    usb: gadget: f_uac2: reset wMaxPacketSize

Alan Stern <stern@rowland.harvard.edu>
    USB: Gadget: dummy-hcd: Fix shift-out-of-bounds bug

Arnd Bergmann <arnd@arndb.de>
    usb: gadget: select CONFIG_CRC32

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix UBSAN warnings for MIDI jacks

Johan Hovold <johan@kernel.org>
    USB: usblp: fix DMA to stack

Johan Hovold <johan@kernel.org>
    USB: yurex: fix control-URB timeout handling

Bjørn Mork <bjorn@mork.no>
    USB: serial: option: add Quectel EM160R-GL

Daniel Palmer <daniel@0x0f.com>
    USB: serial: option: add LongSung M5710 module support

Johan Hovold <johan@kernel.org>
    USB: serial: iuu_phoenix: fix DMA from stack

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: uas: Add PNY USB Portable SSD to unusual_uas

Randy Dunlap <rdunlap@infradead.org>
    usb: usbip: vhci_hcd: protect shift size

Michael Grzeschik <m.grzeschik@pengutronix.de>
    USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set

Yu Kuai <yukuai3@huawei.com>
    usb: chipidea: ci_hdrc_imx: add missing put_device() call in usbmisc_get_init_data()

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    usb: dwc3: ulpi: Fix USB2.0 HS/FS/LS PHY suspend regression

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    usb: dwc3: ulpi: Replace CPU-based busyloop with Protocol-based one

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    usb: dwc3: ulpi: Use VStsDone to detect PHY regs access completion

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Clear wait flag on dequeue

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup

Zheng Zengkai <zhengzengkai@huawei.com>
    usb: dwc3: meson-g12a: disable clk on error handling path in probe

Madhusudanarao Amara <madhusudanarao.amara@intel.com>
    usb: typec: intel_pmc_mux: Configure HPD first for HPD+IRQ request

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    USB: cdc-wdm: Fix use after free in service_outstanding_interrupt().

Sean Young <sean@mess.org>
    USB: cdc-acm: blacklist another IR Droid device

taehyun.cho <taehyun.cho@samsung.com>
    usb: gadget: enable super speed plus

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    staging: mt7621-dma: Fix a resource leak in an error handling path

Dan Carpenter <dan.carpenter@oracle.com>
    Staging: comedi: Return -EFAULT if copy_to_user() fails

Nathan Chancellor <natechancellor@gmail.com>
    powerpc: Handle .text.{hot,unlikely}.* in linker script

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    crypto: asym_tpm: correct zero out potential secrets

Ard Biesheuvel <ardb@kernel.org>
    crypto: ecdh - avoid buffer overflow in ecdh_set_secret()

Alan Stern <stern@rowland.harvard.edu>
    scsi: block: Do not accept any requests while suspended

Bart Van Assche <bvanassche@acm.org>
    scsi: block: Remove RQF_PREEMPT and BLK_MQ_REQ_PREEMPT

Hans de Goede <hdegoede@redhat.com>
    Bluetooth: revert: hci_h5: close serdev device and free hu in h5_close

Dominique Martinet <asmadeus@codewreck.org>
    kbuild: don't hardcode depmod path

Jaegeuk Kim <jaegeuk@kernel.org>
    scsi: ufs: Clear UAC for FFU and RPMB LUNs

Linus Torvalds <torvalds@linux-foundation.org>
    depmod: handle the case of /sbin/depmod without /sbin in PATH

Huang Shijie <sjhuang@iluvatar.ai>
    lib/genalloc: fix the overflow when size is too big

Randy Dunlap <rdunlap@infradead.org>
    local64.h: make <asm/local64.h> mandatory

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Only process PM requests if rpm_status != RPM_ACTIVE

Bart Van Assche <bvanassche@acm.org>
    scsi: scsi_transport_spi: Set RQF_PM for domain validation commands

Bart Van Assche <bvanassche@acm.org>
    scsi: ide: Mark power management requests with RQF_PM instead of RQF_PREEMPT

Bart Van Assche <bvanassche@acm.org>
    scsi: ide: Do not set the RQF_PREEMPT flag for sense requests

Bart Van Assche <bvanassche@acm.org>
    scsi: block: Introduce BLK_MQ_REQ_PM

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs-pci: Enable UFSHCD_CAP_RPM_AUTOSUSPEND for Intel controllers

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs-pci: Fix recovery from hibernate exit errors for Intel controllers

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs-pci: Ensure UFS device is in PowerDown mode for suspend-to-disk ->poweroff()

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs-pci: Fix restore from S4 for Intel controllers

Randall Huang <huangrandall@google.com>
    scsi: ufs: Clear UAC for RPMB after ufshcd resets

Bean Huo <beanhuo@micron.com>
    scsi: ufs: Fix wrong print message in dev_err()

Yunfeng Ye <yeyunfeng@huawei.com>
    workqueue: Kick a worker based on the actual activation of delayed works

Andres Freund <andres@anarazel.de>
    block: add debugfs stanza for QUEUE_FLAG_NOWAIT

Harish <harish@linux.ibm.com>
    selftests/vm: fix building protection keys test

Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
    stmmac: intel: Add PCI IDs for TGL-H platform

Ido Schimmel <idosch@nvidia.com>
    selftests: mlxsw: Set headroom size of correct port

Bjørn Mork <bjorn@mork.no>
    net: usb: qmi_wwan: add Quectel EM160R-GL

YANG LI <abaci-bugfix@linux.alibaba.com>
    ibmvnic: fix: NULL pointer dereference.

Roland Dreier <roland@kernel.org>
    CDC-NCM: remove "connected" log message

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: dsa: lantiq_gswip: Fix GSWIP_MII_CFG(p) register access

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: dsa: lantiq_gswip: Enable GSWIP_MII_CFG_EN also for internal PHYs

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: work around power-saving bug on some chip versions

Yunjian Wang <wangyunjian@huawei.com>
    vhost_net: fix ubuf refcount incorrectly when sendmsg fails

Taehee Yoo <ap420073@gmail.com>
    bareudp: Fix use of incorrect min_headroom size

Taehee Yoo <ap420073@gmail.com>
    bareudp: set NETIF_F_LLTX flag

Xie He <xie.he.0141@gmail.com>
    net: hdlc_ppp: Fix issues when mod_timer is called while timer is running

Cong Wang <cong.wang@bytedance.com>
    erspan: fix version 1 check in gre_parse_header()

Yunjian Wang <wangyunjian@huawei.com>
    net: hns: fix return value check in __lb_other_process()

Randy Dunlap <rdunlap@infradead.org>
    net: sched: prevent invalid Scell_log shift count

Guillaume Nault <gnault@redhat.com>
    ipv4: Ignore ECN bits for fib lookups in fib_compute_spec_dst()

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix AER recovery.

Stefan Chulski <stefanc@marvell.com>
    net: mvpp2: fix pkt coalescing int-threshold configuration

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Check TQM rings for maximum supported value.

Mario Limonciello <mario.limonciello@dell.com>
    e1000e: Export S0ix flags to ethtool

Mario Limonciello <mario.limonciello@dell.com>
    Revert "e1000e: disable s0ix entry and exit flows for ME systems"

Mario Limonciello <mario.limonciello@dell.com>
    e1000e: bump up timeout to wait when ME un-configures ULP mode

Mario Limonciello <mario.limonciello@dell.com>
    e1000e: Only run S0ix flows if shutdown succeeded

Yunjian Wang <wangyunjian@huawei.com>
    tun: fix return value when the number of iovs exceeds MAX_SKB_FRAGS

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: cpts: fix ethtool output when no ptp_clock registered

Antoine Tenart <atenart@kernel.org>
    net-sysfs: take the rtnl lock when accessing xps_rxqs_map and num_tc

Antoine Tenart <atenart@kernel.org>
    net-sysfs: take the rtnl lock when storing xps_rxqs

Antoine Tenart <atenart@kernel.org>
    net-sysfs: take the rtnl lock when accessing xps_cpus_map and num_tc

Antoine Tenart <atenart@kernel.org>
    net-sysfs: take the rtnl lock when storing xps_cpus

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net: ethernet: Fix memleak in ethoc_probe

John Wang <wangzhiqiang.bj@bytedance.com>
    net/ncsi: Use real net-device for response handler

Petr Machata <me@pmachata.org>
    net: dcb: Validate netlink message in DCB handler

Jeff Dike <jdike@akamai.com>
    virtio_net: Fix recursive call to cpus_read_lock()

Manish Chopra <manishc@marvell.com>
    qede: fix offload for IPIP tunnel packets

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net: ethernet: mvneta: Fix error handling in mvneta_probe

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: continue fatal error reset after passive init

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: fix login buffer memory leak

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: stmmac: dwmac-meson8b: ignore the second clock input

Stefan Chulski <stefanc@marvell.com>
    net: mvpp2: Fix GoP port 3 Networking Complex Control configurations

Dan Carpenter <dan.carpenter@oracle.com>
    atm: idt77252: call pci_disable_device() on error path

Shannon Nelson <snelson@pensando.io>
    ionic: account for vlan tag len in rx buffer len

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    ethernet: ucc_geth: set dev->max_mtu to 1518

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: set dev->max_mtu to UMAC_MAX_MTU_SIZE

Stefan Chulski <stefanc@marvell.com>
    net: mvpp2: prs: fix PPPoE with ipv6 packet parse

Stefan Chulski <stefanc@marvell.com>
    net: mvpp2: Add TCAM entry to drop flow control pause frames

Davide Caratti <dcaratti@redhat.com>
    net/sched: sch_taprio: ensure to reset/destroy all child qdiscs

Jakub Kicinski <kuba@kernel.org>
    iavf: fix double-release of rtnl_lock

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix Error I40E_AQ_RC_EINVAL when removing VFs


-------------

Diffstat:

 Makefile                                           |   6 +-
 arch/alpha/include/asm/local64.h                   |   1 -
 arch/arc/include/asm/Kbuild                        |   1 -
 arch/arm/boot/dts/omap3-n950-n9.dtsi               |   8 ++
 arch/arm/include/asm/Kbuild                        |   1 -
 arch/arm64/Makefile                                |  10 +-
 arch/arm64/include/asm/Kbuild                      |   1 -
 arch/csky/include/asm/Kbuild                       |   1 -
 arch/h8300/include/asm/Kbuild                      |   1 -
 arch/hexagon/include/asm/Kbuild                    |   1 -
 arch/ia64/include/asm/local64.h                    |   1 -
 arch/m68k/include/asm/Kbuild                       |   1 -
 arch/microblaze/include/asm/Kbuild                 |   1 -
 arch/mips/include/asm/Kbuild                       |   1 -
 arch/nds32/include/asm/Kbuild                      |   1 -
 arch/parisc/include/asm/Kbuild                     |   1 -
 arch/powerpc/include/asm/Kbuild                    |   1 -
 arch/powerpc/kernel/vmlinux.lds.S                  |   2 +-
 arch/riscv/include/asm/Kbuild                      |   1 -
 arch/s390/include/asm/Kbuild                       |   1 -
 arch/sh/include/asm/Kbuild                         |   1 -
 arch/sparc/include/asm/Kbuild                      |   1 -
 arch/x86/include/asm/local64.h                     |   1 -
 arch/x86/kernel/cpu/mtrr/generic.c                 |   6 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             | 117 +++++++++------------
 arch/x86/kvm/mmu.h                                 |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  22 ++--
 arch/x86/kvm/mmu/tdp_mmu.c                         | 111 ++++++++++---------
 arch/x86/kvm/mmu/tdp_mmu.h                         |   4 +-
 arch/x86/mm/pgtable.c                              |   2 +
 arch/xtensa/include/asm/Kbuild                     |   1 -
 block/blk-core.c                                   |  13 +--
 block/blk-iocost.c                                 |  16 ++-
 block/blk-mq-debugfs.c                             |   2 +-
 block/blk-mq.c                                     |   4 +-
 block/blk-pm.h                                     |  14 ++-
 crypto/asymmetric_keys/asym_tpm.c                  |   2 +-
 crypto/ecdh.c                                      |   3 +-
 drivers/atm/idt77252.c                             |   2 +-
 drivers/base/core.c                                |   2 +-
 drivers/bluetooth/hci_h5.c                         |   8 +-
 drivers/dma-buf/dma-buf.c                          |  21 +++-
 drivers/dma/idxd/sysfs.c                           |   4 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   4 +-
 drivers/gpu/drm/i915/i915_cmd_parser.c             |  27 ++---
 drivers/hwmon/amd_energy.c                         |   3 +-
 drivers/ide/ide-atapi.c                            |   1 -
 drivers/ide/ide-io.c                               |   7 +-
 drivers/ide/ide-pm.c                               |   2 +-
 drivers/iommu/intel/svm.c                          |   9 +-
 drivers/md/bcache/features.c                       |   2 +-
 drivers/md/bcache/features.h                       |  30 +++++-
 drivers/md/bcache/super.c                          |  36 ++++++-
 drivers/net/bareudp.c                              |   3 +-
 drivers/net/dsa/lantiq_gswip.c                     |  27 ++---
 drivers/net/ethernet/broadcom/bcmsysport.c         |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  38 +++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   7 +-
 drivers/net/ethernet/ethoc.c                       |   3 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |   3 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |   4 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  10 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |   1 +
 drivers/net/ethernet/intel/e1000e/ethtool.c        |  46 ++++++++
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  17 ++-
 drivers/net/ethernet/intel/e1000e/netdev.c         |  59 ++---------
 drivers/net/ethernet/intel/i40e/i40e.h             |   3 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  10 ++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   4 +-
 drivers/net/ethernet/marvell/mvneta.c              |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  13 +--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     |  38 ++++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h     |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   9 ++
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   9 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |   2 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   5 +
 drivers/net/ethernet/realtek/r8169_main.c          |   6 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   4 +
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |   2 +-
 drivers/net/ethernet/ti/cpts.c                     |   2 +
 drivers/net/tun.c                                  |   2 +-
 drivers/net/usb/cdc_ncm.c                          |   3 -
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/virtio_net.c                           |  12 ++-
 drivers/net/wan/hdlc_ppp.c                         |   7 ++
 drivers/net/wireless/realtek/rtlwifi/core.c        |   8 +-
 drivers/scsi/scsi_lib.c                            |  27 ++---
 drivers/scsi/scsi_transport_spi.c                  |  27 +++--
 drivers/scsi/ufs/ufshcd-pci.c                      |  73 ++++++++++++-
 drivers/scsi/ufs/ufshcd.c                          |  86 ++++++++++++---
 drivers/scsi/ufs/ufshcd.h                          |   1 +
 drivers/staging/comedi/comedi_fops.c               |   4 +-
 drivers/staging/mt7621-dma/mtk-hsdma.c             |   4 +-
 drivers/usb/chipidea/ci_hdrc_imx.c                 |   6 +-
 drivers/usb/class/cdc-acm.c                        |   4 +
 drivers/usb/class/cdc-wdm.c                        |  16 ++-
 drivers/usb/class/usblp.c                          |  21 +++-
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/dwc3/dwc3-meson-g12a.c                 |   2 +-
 drivers/usb/dwc3/gadget.c                          |  16 +--
 drivers/usb/dwc3/ulpi.c                            |  38 ++++---
 drivers/usb/gadget/Kconfig                         |   2 +
 drivers/usb/gadget/composite.c                     |  10 +-
 drivers/usb/gadget/configfs.c                      |  19 ++--
 drivers/usb/gadget/function/f_printer.c            |   1 +
 drivers/usb/gadget/function/f_uac2.c               |  69 +++++++++---
 drivers/usb/gadget/function/u_ether.c              |   9 +-
 drivers/usb/gadget/legacy/acm_ms.c                 |   4 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  35 +++---
 drivers/usb/host/xhci.c                            |  24 ++---
 drivers/usb/misc/yurex.c                           |   3 +
 drivers/usb/serial/iuu_phoenix.c                   |  20 +++-
 drivers/usb/serial/keyspan_pda.c                   |   2 -
 drivers/usb/serial/option.c                        |   3 +
 drivers/usb/storage/unusual_uas.h                  |   7 ++
 drivers/usb/typec/mux/intel_pmc_mux.c              |  11 ++
 drivers/usb/usbip/vhci_hcd.c                       |   2 +
 drivers/vhost/net.c                                |   6 +-
 fs/btrfs/qgroup.c                                  |  30 ++++--
 fs/btrfs/send.c                                    |  49 +++++----
 include/asm-generic/Kbuild                         |   1 +
 include/linux/blk-mq.h                             |   4 +-
 include/linux/blkdev.h                             |  18 +++-
 include/linux/intel-iommu.h                        |   2 +-
 include/net/red.h                                  |   4 +-
 include/uapi/linux/bcache.h                        |   2 +-
 kernel/workqueue.c                                 |  13 ++-
 lib/genalloc.c                                     |  25 ++---
 mm/page-writeback.c                                |   2 +-
 net/core/net-sysfs.c                               |  65 +++++++++---
 net/dcb/dcbnl.c                                    |   2 +
 net/ipv4/fib_frontend.c                            |   2 +-
 net/ipv4/gre_demux.c                               |   2 +-
 net/ipv4/netfilter/arp_tables.c                    |   2 +-
 net/ipv4/netfilter/ip_tables.c                     |   2 +-
 net/ipv6/netfilter/ip6_tables.c                    |   2 +-
 net/ncsi/ncsi-rsp.c                                |   2 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |  20 +---
 net/netfilter/nft_dynset.c                         |   6 +-
 net/netfilter/xt_RATEEST.c                         |   3 +
 net/sched/sch_choke.c                              |   2 +-
 net/sched/sch_gred.c                               |   2 +-
 net/sched/sch_red.c                                |   2 +-
 net/sched/sch_sfq.c                                |   2 +-
 net/sched/sch_taprio.c                             |   7 +-
 net/xdp/xsk.c                                      |   4 +
 net/xdp/xsk_buff_pool.c                            |   2 -
 scripts/depmod.sh                                  |   2 +
 sound/pci/hda/hda_intel.c                          |   2 -
 sound/pci/hda/patch_conexant.c                     |   1 +
 sound/pci/hda/patch_realtek.c                      |  10 ++
 sound/pci/hda/patch_via.c                          |  13 +++
 sound/usb/midi.c                                   |   4 +
 .../testing/selftests/drivers/net/mlxsw/qos_pfc.sh |   2 +-
 tools/testing/selftests/vm/Makefile                |  10 +-
 virt/kvm/kvm_main.c                                |   3 +-
 159 files changed, 1148 insertions(+), 628 deletions(-)


