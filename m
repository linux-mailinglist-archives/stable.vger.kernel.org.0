Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4613A8EC8
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387925AbfIDSAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388329AbfIDSAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:00:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E493021883;
        Wed,  4 Sep 2019 17:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619999;
        bh=KowfV80c378ZM6ZFEtrYED1oUcQ2/MbWHPIk9Bv2Qzg=;
        h=From:To:Cc:Subject:Date:From;
        b=QK4F9b21aop/0MzXgNBIIHAy/O5htdwI3YIAM8uW54mzC0jeoemTAPA5T+GheU4GS
         LsCqLcCf4lmq4x9XdD9JggFVjGcV6Rucaw6UtGpBWZOVDGVEmW+kIZouoT7PFZ4IVp
         SSYvvC80UFK13yHZY1/oxDzRQzxr+USPl7YSwClM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/83] 4.9.191-stable review
Date:   Wed,  4 Sep 2019 19:52:52 +0200
Message-Id: <20190904175303.488266791@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.191-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.191-rc1
X-KernelTest-Deadline: 2019-09-06T17:53+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.191 release.
There are 83 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.191-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.191-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    x86/ptrace: fix up botched merge of spectrev1 fix

Andrew Cooks <andrew.cooks@opengear.com>
    i2c: piix4: Fix port selection for AMD Family 16h Model 30h

Marc Zyngier <maz@kernel.org>
    KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0 as WI

Heyi Guo <guoheyi@huawei.com>
    KVM: arm/arm64: vgic: Fix potential deadlock when ap_list is long

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix possible sta leak

Hodaszi, Robert <Robert.Hodaszi@digi.com>
    Revert "cfg80211: fix processing world regdomain when non modular"

Nadav Amit <namit@vmware.com>
    VMCI: Release resource if the work is already queued

Ding Xiang <dingxiang@cmss.chinamobile.com>
    stm class: Fix a double free of stm_source_device

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Fix init of SD cards reporting an invalid VDD range

Eugen Hristev <eugen.hristev@microchip.com>
    mmc: sdhci-of-at91: add quirk for broken HS200

Sebastian Mayr <me@sam.st>
    uprobes/x86: Fix detection of 32-bit user mode

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    ptrace,x86: Make user_64bit_mode() available to 32-bit builds

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: storage: ums-realtek: Whitelist auto-delink support

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: storage: ums-realtek: Update module parameter description for auto_delink_en

Geert Uytterhoeven <geert+renesas@glider.be>
    usb: host: xhci: rcar: Fix typo in compatible string matching

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: host: ohci: fix a race condition between shutdown and irq

Peter Chen <peter.chen@nxp.com>
    usb: chipidea: udc: don't do hardware access if gadget has stopped

Oliver Neukum <oneukum@suse.com>
    USB: cdc-wdm: fix race between write and disconnect due to flag abuse

Henk van der Laan <opensource@henkvdlaan.com>
    usb-storage: Add new JMS567 revision to unusual_devs

Henry Burns <henryburns@google.com>
    mm/zsmalloc.c: fix race condition in zs_destroy_pool

Bandan Das <bsd@redhat.com>
    x86/apic: Include the LDR when clearing out APIC registers

Bandan Das <bsd@redhat.com>
    x86/apic: Do not initialize LDR and DFR for bigsmp

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Don't update RIP or do single-step on faulting emulation

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix potential concurrent access to the deleted pool

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix memory leak at line6_init_pcm() error path

Eric Dumazet <edumazet@google.com>
    tcp: make sure EPOLLOUT wont be missed

Hui Peng <benquike@gmail.com>
    ALSA: usb-audio: Fix an OOB bug in parse_audio_mixer_unit

Hui Peng <benquike@gmail.com>
    ALSA: usb-audio: Fix a stack buffer overflow bug in check_input_term

Tim Froidcoeur <tim.froidcoeur@tessares.net>
    tcp: fix tcp_rtx_queue_tail in case of empty retransmit queue

Pedro Sousa <sousa@synopsys.com>
    scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE define value

Stefan Wahren <wahrenst@gmx.net>
    watchdog: bcm2835_wdt: Fix module autoload

Adrian Vladu <avladu@cloudbasesolutions.com>
    tools: hv: fix KVP and VSS daemons exit code

Hans Ulli Kroll <ulli.kroll@googlemail.com>
    usb: host: fotg2: restart hcd after port reset

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: emev2: avoid race when unregistering slave client

Wenwen Wang <wenwen@cs.uga.edu>
    xen/blkback: fix memory leaks

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    usb: gadget: composite: Clear "suspended" on reset/disconnect

Robin Murphy <robin.murphy@arm.com>
    iommu/dma: Handle SG length overflow better

Arnd Bergmann <arnd@arndb.de>
    dmaengine: ste_dma40: fix unneeded variable warning

Tom Lendacky <thomas.lendacky@amd.com>
    x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h

Sasha Levin <sashal@kernel.org>
    Revert "perf test 6: Fix missing kvm module load for s390"

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix missing ILOCK unlock when xfs_setattr_nonsize fails due to EDQUOT

Henry Burns <henryburns@google.com>
    mm/zsmalloc.c: migration can leave pages in ZS_EMPTY indefinitely

Vlastimil Babka <vbabka@suse.cz>
    mm, page_owner: handle THP splits correctly

Michael Kelley <mikelley@microsoft.com>
    genirq: Properly pair kobject_del() with kobject_add()

Mikulas Patocka <mpatocka@redhat.com>
    dm table: fix invalid memory accesses with too high sector number

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    dm space map metadata: fix missing store of apply_bops() return value

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    dm btree: fix order of block initialization in btree_split_beneath

John Hubbard <jhubbard@nvidia.com>
    x86/boot: Fix boot regression caused by bootparam sanitizing

John Hubbard <jhubbard@nvidia.com>
    x86/boot: Save fields explicitly, zero out everything else

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Handle missing global clockevent gracefully

Sean Christopherson <sean.j.christopherson@intel.com>
    x86/retpoline: Don't clobber RFLAGS during CALL_NOSPEC on i386

Oleg Nesterov <oleg@redhat.com>
    userfaultfd_release: always remove uffd flags and clear vm_userfaultfd_ctx

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    gpiolib: never report open-drain/source lines as 'input' to user-space

Mikulas Patocka <mpatocka@redhat.com>
    Revert "dm bufio: fix deadlock with loop device"

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Correct distance scale for 2nd-gen Intuos devices

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: correct misreported EKR ring values

Naresh Kamboju <naresh.kamboju () linaro ! org>
    selftests: kvm: Adding config fragments

Jin Yao <yao.jin@linux.intel.com>
    perf pmu-events: Fix missing "cpu_clk_unhalted.core" event

Colin Ian King <colin.king@canonical.com>
    drm/vmwgfx: fix memory leak when too many retries have occurred

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    x86/lib/cpu: Address missing prototypes warning

Jens Axboe <axboe@kernel.dk>
    libata: add SG safety checks in SFF pio transfers

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: Fix dma_map_single failed on arm64

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: fix hip04-xmit never return TX_BUSY

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: make hip04_tx_reclaim non-reentrant

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: cxgb3_main: Fix a resource leak in a error path in 'init_one()'

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    HID: input: fix a4tech horizontal wheel custom usage

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a potential sleep while atomic in nfs4_do_reclaim()

Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
    can: peak_usb: force the string buffer NULL-terminated

Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
    can: sja1000: force the string buffer NULL-terminated

Jiri Olsa <jolsa@kernel.org>
    perf bench numa: Fix cpu0 binding

Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
    isdn: hfcsusb: Fix mISDN driver crash caused by transfer buffer on the stack

Jia-Ju Bai <baijiaju1990@gmail.com>
    isdn: mISDN: hfcsusb: Fix possible null-pointer dereferences in start_isoc_chain()

Bob Ham <bob.ham@puri.sm>
    net: usb: qmi_wwan: Add the BroadMobi BM818 card

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: ti: davinci-mcasp: Correct slot_width posed constraint

Navid Emamdoost <navid.emamdoost@gmail.com>
    st_nci_hci_connectivity_event_received: null check the allocation

Navid Emamdoost <navid.emamdoost@gmail.com>
    st21nfca_connectivity_event_received: null check the allocation

Ricard Wanderlof <ricard.wanderlof@axis.com>
    ASoC: Fail card instantiation if DAI format setup fails

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    can: dev: call netif_carrier_off() in register_candev()

Thomas Falcon <tlfalcon@linux.ibm.com>
    bonding: Force slave speed check after link state recovery for 802.3ad

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: dapm: Fix handling of custom_stop_condition on DAPM graph walks

Wenwen Wang <wenwen@cs.uga.edu>
    netfilter: ebtables: fix a memory leak bug in compat

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: kernel: only use i8253 clocksource with periodic clockevent

Ilya Trukhanov <lahvuun@gmail.com>
    HID: Add 044f:b320 ThrustMaster, Inc. 2 in 1 DT


-------------

Diffstat:

 Documentation/kernel-parameters.txt                |  7 ++
 Makefile                                           |  4 +-
 arch/mips/kernel/i8253.c                           |  3 +-
 arch/x86/include/asm/bootparam_utils.h             | 60 +++++++++++----
 arch/x86/include/asm/msr-index.h                   |  1 +
 arch/x86/include/asm/nospec-branch.h               |  2 +-
 arch/x86/include/asm/ptrace.h                      |  6 +-
 arch/x86/kernel/apic/apic.c                        | 72 ++++++++++++++----
 arch/x86/kernel/apic/bigsmp_32.c                   | 24 +-----
 arch/x86/kernel/cpu/amd.c                          | 66 +++++++++++++++++
 arch/x86/kernel/ptrace.c                           |  3 +-
 arch/x86/kernel/uprobes.c                          | 17 +++--
 arch/x86/kvm/x86.c                                 |  9 ++-
 arch/x86/lib/cpu.c                                 |  1 +
 arch/x86/power/cpu.c                               | 86 ++++++++++++++++++----
 drivers/ata/libata-sff.c                           |  6 ++
 drivers/block/xen-blkback/xenbus.c                 |  6 +-
 drivers/dma/ste_dma40.c                            |  4 +-
 drivers/gpio/gpiolib.c                             |  6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                |  4 +-
 drivers/hid/hid-a4tech.c                           | 30 +++++++-
 drivers/hid/hid-tmff.c                             | 12 +++
 drivers/hid/wacom_wac.c                            |  4 +-
 drivers/hwtracing/stm/core.c                       |  1 -
 drivers/i2c/busses/i2c-emev2.c                     | 16 +++-
 drivers/i2c/busses/i2c-piix4.c                     | 12 ++-
 drivers/iommu/dma-iommu.c                          |  2 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              | 13 +++-
 drivers/md/dm-bufio.c                              |  4 +-
 drivers/md/dm-table.c                              |  5 +-
 drivers/md/persistent-data/dm-btree.c              | 31 ++++----
 drivers/md/persistent-data/dm-space-map-metadata.c |  2 +-
 drivers/misc/vmw_vmci/vmci_doorbell.c              |  6 +-
 drivers/mmc/core/sd.c                              |  6 ++
 drivers/mmc/host/sdhci-of-at91.c                   |  3 +
 drivers/net/bonding/bond_main.c                    |  9 +++
 drivers/net/can/dev.c                              |  2 +
 drivers/net/can/sja1000/peak_pcmcia.c              |  2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |  5 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         | 28 ++++---
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/nfc/st-nci/se.c                            |  2 +
 drivers/nfc/st21nfca/se.c                          |  2 +
 drivers/scsi/ufs/unipro.h                          |  2 +-
 drivers/usb/chipidea/udc.c                         | 32 ++++++--
 drivers/usb/class/cdc-wdm.c                        | 16 +++-
 drivers/usb/gadget/composite.c                     |  1 +
 drivers/usb/host/fotg210-hcd.c                     |  4 +
 drivers/usb/host/ohci-hcd.c                        | 15 +++-
 drivers/usb/host/xhci-rcar.c                       |  2 +-
 drivers/usb/storage/realtek_cr.c                   | 15 ++--
 drivers/usb/storage/unusual_devs.h                 |  2 +-
 drivers/watchdog/bcm2835_wdt.c                     |  1 +
 fs/nfs/nfs4_fs.h                                   |  3 +-
 fs/nfs/nfs4client.c                                |  5 +-
 fs/nfs/nfs4state.c                                 | 27 +++++--
 fs/userfaultfd.c                                   | 25 ++++---
 fs/xfs/xfs_iops.c                                  |  1 +
 include/net/tcp.h                                  |  4 +
 kernel/irq/irqdesc.c                               | 15 +++-
 mm/huge_memory.c                                   |  4 +
 mm/zsmalloc.c                                      | 78 ++++++++++++++++++--
 net/bridge/netfilter/ebtables.c                    |  4 +-
 net/core/stream.c                                  | 16 ++--
 net/mac80211/cfg.c                                 |  9 ++-
 net/wireless/reg.c                                 |  2 +-
 sound/core/seq/seq_clientmgr.c                     |  3 +-
 sound/core/seq/seq_fifo.c                          | 17 +++++
 sound/core/seq/seq_fifo.h                          |  2 +
 sound/soc/davinci/davinci-mcasp.c                  | 43 ++++++++---
 sound/soc/soc-core.c                               |  7 +-
 sound/soc/soc-dapm.c                               |  8 +-
 sound/usb/line6/pcm.c                              | 18 ++---
 sound/usb/mixer.c                                  | 30 ++++++--
 tools/hv/hv_kvp_daemon.c                           |  2 +
 tools/hv/hv_vss_daemon.c                           |  2 +
 tools/perf/bench/numa.c                            |  6 +-
 tools/perf/pmu-events/jevents.c                    |  1 +
 tools/perf/tests/parse-events.c                    | 27 -------
 tools/testing/selftests/kvm/config                 |  3 +
 virt/kvm/arm/vgic/vgic-mmio.c                      | 18 +++++
 virt/kvm/arm/vgic/vgic-v2.c                        |  5 +-
 virt/kvm/arm/vgic/vgic-v3.c                        |  5 +-
 virt/kvm/arm/vgic/vgic.c                           |  7 ++
 85 files changed, 808 insertions(+), 266 deletions(-)


