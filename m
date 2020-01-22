Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B94751450C9
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbgAVJsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:48:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387497AbgAVJk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:40:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1911924684;
        Wed, 22 Jan 2020 09:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686058;
        bh=RZK9G8Q77rUhw9fgEAU8MtSnmwXAWFAtqWXOjUo87MI=;
        h=From:To:Cc:Subject:Date:From;
        b=mdkF/ao2PFDu7tG719kQKLEo67bx0BzXzBgq74icD4pxr7akbQAWrD9HR9jUXLeNq
         wg2OycjSBgqpj4lS5reDxkV0rz5c0E3kWw4jOLxZHf6Axm2iB9yyCRL9SLw4IXvliw
         xQ13qv17zpQYw4+qXHLz806u91lG5wiFVJAZOZr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/103] 4.19.98-stable review
Date:   Wed, 22 Jan 2020 10:28:16 +0100
Message-Id: <20200122092803.587683021@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.98-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.98-rc1
X-KernelTest-Deadline: 2020-01-24T09:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.98 release.
There are 103 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.98-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.98-rc1

Eddie James <eajames@linux.ibm.com>
    hwmon: (pmbus/ibm-cffps) Switch LEDs to blocking brightness call

Stephan Gerhold <stephan@gerhold.net>
    regulator: ab8500: Remove SYSCLKREQ from enum ab8505_regulator_id

Baolin Wang <baolin.wang@linaro.org>
    clk: sprd: Use IS_ERR() to validate the return value of syscon_regmap_lookup_by_phandle()

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix wrong address verification

Bart Van Assche <bvanassche@acm.org>
    scsi: core: scsi_trace: Use get_unaligned_be*()

Martin Wilck <mwilck@suse.com>
    scsi: qla2xxx: fix rports not being mark as lost in sync fabric scan

Huacai Chen <chenhc@lemote.com>
    scsi: qla2xxx: Fix qla2x00_request_irqs() for MSI

Bart Van Assche <bvanassche@acm.org>
    scsi: target: core: Fix a pr_debug() argument

Pan Bian <bianpan2016@163.com>
    scsi: bnx2i: fix potential use after free

Pan Bian <bianpan2016@163.com>
    scsi: qla4xxx: fix double free bug

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: esas2r: unlock on error in esas2r_nvram_read_direct()

Jeff Mahoney <jeffm@suse.com>
    reiserfs: fix handling of -EOPNOTSUPP in reiserfs_for_each_xattr

Jon Derrick <jonathan.derrick@intel.com>
    drm/nouveau/mmu: qualify vmm during dtor

Jon Derrick <jonathan.derrick@intel.com>
    drm/nouveau/bar/gf100: ensure BAR is mapped

Jon Derrick <jonathan.derrick@intel.com>
    drm/nouveau/bar/nv50: check bar1 vmm return value

Angelo Dureghello <angelo.dureghello@timesys.com>
    mtd: devices: fix mchp23k256 read and write

Sudeep Holla <sudeep.holla@arm.com>
    Revert "arm64: dts: juno: add dma-ranges property"

Miquel Raynal <miquel.raynal@bootlin.com>
    arm64: dts: marvell: Fix CP110 NAND controller node multi-line comment alignment

Eric Dumazet <edumazet@google.com>
    tick/sched: Annotate lockless access to last_jiffies_update

Johannes Berg <johannes.berg@intel.com>
    cfg80211: check for set_wiphy_params

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-gxl-s905x-khadas-vim: fix gpio-keys-polled node

Dan Carpenter <dan.carpenter@oracle.com>
    cw1200: Fix a signedness bug in cw1200_load_firmware()

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    irqchip: Place CONFIG_SIFIVE_PLIC into the menu

Eric Dumazet <edumazet@google.com>
    tcp: refine rule to allow EPOLLOUT generation under mem pressure

Nathan Chancellor <natechancellor@gmail.com>
    xen/blkfront: Adjust indentation in xlvbd_alloc_gendisk

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum_qdisc: Include MC TCs in Qdisc counters

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum: Wipe xstats.backlog of down ports

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    sh_eth: check sh_eth_cpu_data::dual_port when dumping registers

Pengcheng Yang <yangpc@wangsu.com>
    tcp: fix marked lost packets not being retransmitted

Johan Hovold <johan@kernel.org>
    r8152: add missing endpoint sanity check

Vladis Dronov <vdronov@redhat.com>
    ptp: free ptp device pin descriptors properly

Colin Ian King <colin.king@canonical.com>
    net/wan/fsl_ucc_hdlc: fix out of bounds write on array utdm_info

Eric Dumazet <edumazet@google.com>
    net: usb: lan78xx: limit size of local TSO packets

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: fix soft lockup when there is not enough memory

Alexander Lobakin <alobakin@dlink.ru>
    net: dsa: tag_qca: fix doubled Tx statistics

Mohammed Gamal <mgamal@redhat.com>
    hv_netvsc: Fix memory leak when removing rndis device

Eric Dumazet <edumazet@google.com>
    macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix DAT candidate selection on little endian systems

Johan Hovold <johan@kernel.org>
    NFC: pn533: fix bulk-message timeout

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix flowtable list del corruption

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: store transaction list locally while requesting module

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: remove WARN and add NLA_STRING upper limits

Florian Westphal <fw@strlen.de>
    netfilter: nft_tunnel: fix null-attribute check

Florian Westphal <fw@strlen.de>
    netfilter: arp_tables: init netns pointer in xt_tgdtor_param struct

Cong Wang <xiyou.wangcong@gmail.com>
    netfilter: fix a use-after-free in mtype_destroy()

Felix Fietkau <nbd@nbd.name>
    cfg80211: fix page refcount issue in A-MSDU decap

Felix Fietkau <nbd@nbd.name>
    cfg80211: fix memory leak in cfg80211_cqm_rssi_update

Markus Theil <markus.theil@tu-ilmenau.de>
    cfg80211: fix deadlocks in autodisconnect work

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix incorrect verifier simulation of ARSH under ALU32

Dinh Nguyen <dinguyen@kernel.org>
    arm64: dts: agilex/stratix10: fix pmu interrupt numbers

Kirill A. Shutemov <kirill@shutemov.name>
    mm/huge_memory.c: thp: fix conflict of above-47bit hint address and PMD alignment

Bharath Vedartham <linux.bhar@gmail.com>
    mm/huge_memory.c: make __thp_get_unmapped_area static

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Enable 16KB buffer size

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: 16KB buffer must be 16 byte aligned

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: dts: imx7: Fix Toradex Colibri iMX7S 256MB NAND flash support

Jagan Teki <jagan@amarulasolutions.com>
    ARM: dts: imx6q-icore-mipi: Use 1.5 version of i.Core MX6DL

Jacopo Mondi <jacopo@jmondi.org>
    ARM: dts: imx6qdl: Add Engicam i.Core 1.5 MX6

Wen Yang <wenyang@linux.alibaba.com>
    mm/page-writeback.c: avoid potential division by zero in wb_min_max_ratio()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: fix memory leak in qgroup accounting

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not delete mismatched root refs

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix invalid removal of root ref

Josef Bacik <josef@toxicpanda.com>
    btrfs: rework arguments of btrfs_unlink_subvol

Adrian Huang <ahuang12@lenovo.com>
    mm: memcg/slab: call flush_memcg_workqueue() only if memcg workqueue is valid

Kirill A. Shutemov <kirill@shutemov.name>
    mm/shmem.c: thp, shmem: fix conflict of above-47bit hint address and PMD alignment

Jin Yao <yao.jin@linux.intel.com>
    perf report: Fix incorrectly added dimensions as switch perf data file

Yuya Fujita <fujita.yuya@fujitsu.com>
    perf hists: Fix variable name's inconsistency in hists__for_each() macro

Shakeel Butt <shakeelb@google.com>
    x86/resctrl: Fix potential memory leak

YueHaibing <yuehaibing@huawei.com>
    drm/i915: Add missing include file <linux/math64.h>

Ard Biesheuvel <ardb@kernel.org>
    x86/efistub: Disable paging at mixed mode entry

Tom Lendacky <thomas.lendacky@amd.com>
    x86/CPU/AMD: Ensure clearing of SME/SEV features is maintained

Qian Cai <cai@lca.pw>
    x86/resctrl: Fix an imbalance in domain_remove_cpu()

Keiya Nobuta <nobuta.keiya@fujitsu.com>
    usb: core: hub: Improved device recognition on remote wakeup

Christian Brauner <christian.brauner@ubuntu.com>
    ptrace: reintroduce usage of subjective credentials in ptrace_has_cap()

Micah Morton <mortonm@chromium.org>
    LSM: generalize flag passing to security_capable

Kishon Vijay Abraham I <kishon@ti.com>
    ARM: dts: am571x-idk: Fix gpios property to have the correct gpio number

Mikulas Patocka <mpatocka@redhat.com>
    block: fix an integer overflow in logical block size

Jari Ruusu <jari.ruusu@gmail.com>
    Fix built-in early-load Intel microcode alignment

Stefan Mavrodiev <stefan@olimex.com>
    arm64: dts: allwinner: a64: olinuxino: Fix SDIO supply regulator

Johan Hovold <johan@kernel.org>
    ALSA: usb-audio: fix sync-ep altsetting sanity check

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix racy access for queue timer in proc read

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: dice: fix fallback from protocol extension into limited functionality

Marek Vasut <marex@denx.de>
    ARM: dts: imx6q-dhcom: Fix SGTL5000 VDDIO regulator connection

Stephan Gerhold <stephan@gerhold.net>
    ASoC: msm8916-wcd-analog: Fix MIC BIAS Internal1

Stephan Gerhold <stephan@gerhold.net>
    ASoC: msm8916-wcd-analog: Fix selected events for MIC BIAS External1

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: mptfusion: Fix double fetch bug in ioctl

Arnd Bergmann <arnd@arndb.de>
    scsi: fnic: fix invalid stack access

Johan Hovold <johan@kernel.org>
    USB: serial: quatech2: handle unbound ports

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan: handle unbound ports

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: add missing active-port sanity check

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: handle unbound ports on URB completion

Johan Hovold <johan@kernel.org>
    USB: serial: ch341: handle unbound port at reset_resume

Johan Hovold <johan@kernel.org>
    USB: serial: suppress driver bind attributes

Reinhard Speyerer <rspmn@arcor.de>
    USB: serial: option: add support for Quectel RM500Q in QDL mode

Johan Hovold <johan@kernel.org>
    USB: serial: opticon: fix control-message timeouts

Kristian Evensen <kristian.evensen@gmail.com>
    USB: serial: option: Add support for Quectel RM500Q

Jerónimo Borque <jeronimo@borque.com.ar>
    USB: serial: simple: Add Motorola Solutions TETRA MTP3xxx and MTP85xx

Lars Möllendorf <lars.moellendorf@plating.de>
    iio: buffer: align the size of scan bytes to size of the largest element

Stephan Gerhold <stephan@gerhold.net>
    ASoC: msm8916-wcd-digital: Reset RX interpolation path after use

Guenter Roeck <linux@roeck-us.net>
    clk: Don't try to enable critical clocks if prepare failed

Alexandre Belloni <alexandre.belloni@bootlin.com>
    ARM: dts: imx6q-dhcom: fix rtc compatible

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    dt-bindings: reset: meson8b: fix duplicate reset IDs

Georgi Djakov <georgi.djakov@linaro.org>
    clk: qcom: gcc-sdm845: Add missing flag to votable GDSCs

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson8: fix the size of the PMU registers


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/am571x-idk.dts                   |   2 +-
 arch/arm/boot/dts/imx6dl-icore-mipi.dts            |   2 +-
 arch/arm/boot/dts/imx6q-dhcom-pdk2.dts             |   2 +-
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi             |   2 +-
 arch/arm/boot/dts/imx6qdl-icore-1.5.dtsi           |  34 ++++
 arch/arm/boot/dts/imx7s-colibri.dtsi               |   4 +
 arch/arm/boot/dts/meson8.dtsi                      |   2 +-
 .../boot/dts/allwinner/sun50i-a64-olinuxino.dts    |   2 +-
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi  |   8 +-
 .../dts/amlogic/meson-gxl-s905x-khadas-vim.dts     |   4 +-
 arch/arm64/boot/dts/arm/juno-base.dtsi             |   1 -
 arch/arm64/boot/dts/marvell/armada-cp110.dtsi      |   8 +-
 arch/x86/boot/compressed/head_64.S                 |   5 +
 arch/x86/kernel/cpu/amd.c                          |   4 +-
 arch/x86/kernel/cpu/intel_rdt.c                    |   2 +-
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c           |   6 +-
 block/blk-settings.c                               |   2 +-
 drivers/block/xen-blkfront.c                       |   4 +-
 drivers/clk/clk.c                                  |  10 +-
 drivers/clk/qcom/gcc-sdm845.c                      |   7 +
 drivers/clk/sprd/common.c                          |   2 +-
 drivers/gpu/drm/i915/selftests/i915_random.h       |   1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/bar/gf100.c    |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c     |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c      |   2 +-
 drivers/hwmon/pmbus/ibm-cffps.c                    |  10 +-
 drivers/iio/industrialio-buffer.c                  |   6 +-
 drivers/irqchip/Kconfig                            |   4 +-
 drivers/md/dm-snap-persistent.c                    |   2 +-
 drivers/md/raid0.c                                 |   2 +-
 drivers/message/fusion/mptctl.c                    | 213 +++++----------------
 drivers/mtd/devices/mchp23k256.c                   |  20 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  13 ++
 .../net/ethernet/mellanox/mlxsw/spectrum_qdisc.c   |  30 ++-
 drivers/net/ethernet/renesas/sh_eth.c              |  38 ++--
 drivers/net/ethernet/stmicro/stmmac/common.h       |   5 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 drivers/net/hyperv/rndis_filter.c                  |   2 -
 drivers/net/macvlan.c                              |   5 +-
 drivers/net/usb/lan78xx.c                          |   1 +
 drivers/net/usb/r8152.c                            |   3 +
 drivers/net/wan/fsl_ucc_hdlc.c                     |   2 +-
 drivers/net/wireless/st/cw1200/fwio.c              |   6 +-
 drivers/nfc/pn533/usb.c                            |   2 +-
 drivers/ptp/ptp_clock.c                            |   4 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |   2 +-
 drivers/scsi/esas2r/esas2r_flash.c                 |   1 +
 drivers/scsi/fnic/vnic_dev.c                       |  20 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   6 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   6 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |   3 -
 drivers/scsi/scsi_trace.c                          | 113 ++++-------
 drivers/target/target_core_fabric_lib.c            |   2 +-
 drivers/usb/core/hub.c                             |   1 +
 drivers/usb/serial/ch341.c                         |   6 +-
 drivers/usb/serial/io_edgeport.c                   |  16 +-
 drivers/usb/serial/keyspan.c                       |   4 +
 drivers/usb/serial/opticon.c                       |   2 +-
 drivers/usb/serial/option.c                        |   6 +
 drivers/usb/serial/quatech2.c                      |   6 +
 drivers/usb/serial/usb-serial-simple.c             |   2 +
 drivers/usb/serial/usb-serial.c                    |   3 +
 firmware/Makefile                                  |   2 +-
 fs/btrfs/inode.c                                   |  73 +++----
 fs/btrfs/qgroup.c                                  |   6 +-
 fs/btrfs/root-tree.c                               |  10 +-
 fs/reiserfs/xattr.c                                |   8 +-
 include/dt-bindings/reset/amlogic,meson8b-reset.h  |   6 +-
 include/linux/blkdev.h                             |   8 +-
 include/linux/lsm_hooks.h                          |   8 +-
 include/linux/regulator/ab8500.h                   |   2 -
 include/linux/security.h                           |  28 +--
 include/linux/tnum.h                               |   2 +-
 kernel/bpf/tnum.c                                  |   9 +-
 kernel/bpf/verifier.c                              |  13 +-
 kernel/capability.c                                |  22 ++-
 kernel/ptrace.c                                    |  15 +-
 kernel/seccomp.c                                   |   4 +-
 kernel/time/tick-sched.c                           |  14 +-
 mm/huge_memory.c                                   |  38 ++--
 mm/page-writeback.c                                |   4 +-
 mm/shmem.c                                         |   7 +-
 mm/slab_common.c                                   |   3 +-
 net/batman-adv/distributed-arp-table.c             |   4 +-
 net/dsa/tag_qca.c                                  |   3 -
 net/ipv4/netfilter/arp_tables.c                    |  19 +-
 net/ipv4/tcp.c                                     |   6 +-
 net/ipv4/tcp_input.c                               |   7 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   2 +-
 net/netfilter/nf_tables_api.c                      |  38 ++--
 net/netfilter/nft_tunnel.c                         |   2 +-
 net/wireless/nl80211.c                             |   1 +
 net/wireless/rdev-ops.h                            |   4 +
 net/wireless/sme.c                                 |   6 +-
 net/wireless/util.c                                |   2 +-
 security/apparmor/capability.c                     |  14 +-
 security/apparmor/include/capability.h             |   2 +-
 security/apparmor/ipc.c                            |   3 +-
 security/apparmor/lsm.c                            |   4 +-
 security/apparmor/resource.c                       |   2 +-
 security/commoncap.c                               |  17 +-
 security/security.c                                |  14 +-
 security/selinux/hooks.c                           |  18 +-
 security/smack/smack_access.c                      |   2 +-
 sound/core/seq/seq_timer.c                         |  14 +-
 sound/firewire/dice/dice-extension.c               |   5 +-
 sound/soc/codecs/msm8916-wcd-analog.c              |  20 +-
 sound/soc/codecs/msm8916-wcd-digital.c             |   6 +
 sound/usb/pcm.c                                    |   2 +-
 tools/perf/builtin-report.c                        |   5 +-
 tools/perf/util/hist.h                             |   4 +-
 tools/perf/util/probe-finder.c                     |  32 +---
 114 files changed, 644 insertions(+), 595 deletions(-)


