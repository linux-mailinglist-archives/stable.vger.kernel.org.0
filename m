Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4A514517B
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgAVJeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:34:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:48306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730736AbgAVJeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:34:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B075824672;
        Wed, 22 Jan 2020 09:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685643;
        bh=QO7uD8qauAFkHbPKYCJrVtMpZrxLeqysyYcEG2HVyQ0=;
        h=From:To:Cc:Subject:Date:From;
        b=M4Aq+gIRA0tEQDUMPSJd55/nye4ztpmQZJ0KJqgE2Nz9gHx8hF0YQwsvg9Bav1Owf
         AcS2/+rAv7oMR7AMl5IDc8Fbk4DWC0EC6DrTgnorAU5nyYE/AYPDuKOWDSVFD5n04z
         qC8DFtvPu015JqX+RGSw9LLBX/xdHQ08nwYFpGnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/97] 4.9.211-stable review
Date:   Wed, 22 Jan 2020 10:28:04 +0100
Message-Id: <20200122092755.678349497@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.211-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.211-rc1
X-KernelTest-Deadline: 2020-01-24T09:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.211 release.
There are 97 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.211-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.211-rc1

Stephan Gerhold <stephan@gerhold.net>
    regulator: ab8500: Remove SYSCLKREQ from enum ab8505_regulator_id

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix wrong address verification

Bart Van Assche <bvanassche@acm.org>
    scsi: core: scsi_trace: Use get_unaligned_be*()

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

Johannes Berg <johannes.berg@intel.com>
    cfg80211: check for set_wiphy_params

Dan Carpenter <dan.carpenter@oracle.com>
    cw1200: Fix a signedness bug in cw1200_load_firmware()

Nathan Chancellor <natechancellor@gmail.com>
    xen/blkfront: Adjust indentation in xlvbd_alloc_gendisk

Eric Dumazet <edumazet@google.com>
    net: usb: lan78xx: limit size of local TSO packets

Pengcheng Yang <yangpc@wangsu.com>
    tcp: fix marked lost packets not being retransmitted

Johan Hovold <johan@kernel.org>
    r8152: add missing endpoint sanity check

Colin Ian King <colin.king@canonical.com>
    net/wan/fsl_ucc_hdlc: fix out of bounds write on array utdm_info

Alexander Lobakin <alobakin@dlink.ru>
    net: dsa: tag_qca: fix doubled Tx statistics

Eric Dumazet <edumazet@google.com>
    macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix DAT candidate selection on little endian systems

Florian Westphal <fw@strlen.de>
    netfilter: arp_tables: init netns pointer in xt_tgdtor_param struct

Cong Wang <xiyou.wangcong@gmail.com>
    netfilter: fix a use-after-free in mtype_destroy()

Felix Fietkau <nbd@nbd.name>
    cfg80211: fix page refcount issue in A-MSDU decap

Dinh Nguyen <dinguyen@kernel.org>
    arm64: dts: agilex/stratix10: fix pmu interrupt numbers

Arnd Bergmann <arnd@arndb.de>
    scsi: fnic: fix invalid stack access

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    scsi: fnic: use kernel's '%pM' format option to print MAC

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan: handle unbound ports

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: handle unbound ports on URB completion

John Ogness <john.ogness@linutronix.de>
    USB: serial: io_edgeport: use irqsave() in USB's complete callback

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Enable 16KB buffer size

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: 16KB buffer must be 16 byte aligned

Wen Yang <wenyang@linux.alibaba.com>
    mm/page-writeback.c: avoid potential division by zero in wb_min_max_ratio()

Jin Yao <yao.jin@linux.intel.com>
    perf report: Fix incorrectly added dimensions as switch perf data file

Yuya Fujita <fujita.yuya@fujitsu.com>
    perf hists: Fix variable name's inconsistency in hists__for_each() macro

Ard Biesheuvel <ardb@kernel.org>
    x86/efistub: Disable paging at mixed mode entry

Keiya Nobuta <nobuta.keiya@fujitsu.com>
    usb: core: hub: Improved device recognition on remote wakeup

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: mptfusion: Fix double fetch bug in ioctl

Johan Hovold <johan@kernel.org>
    USB: serial: quatech2: handle unbound ports

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: add missing active-port sanity check

Johan Hovold <johan@kernel.org>
    USB: serial: ch341: handle unbound port at reset_resume

Johan Hovold <johan@kernel.org>
    USB: serial: suppress driver bind attributes

Johan Hovold <johan@kernel.org>
    USB: serial: opticon: fix control-message timeouts

Jerónimo Borque <jeronimo@borque.com.ar>
    USB: serial: simple: Add Motorola Solutions TETRA MTP3xxx and MTP85xx

Lars Möllendorf <lars.moellendorf@plating.de>
    iio: buffer: align the size of scan bytes to size of the largest element

Mikulas Patocka <mpatocka@redhat.com>
    block: fix an integer overflow in logical block size

Jari Ruusu <jari.ruusu@gmail.com>
    Fix built-in early-load Intel microcode alignment

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix racy access for queue timer in proc read

Guenter Roeck <linux@roeck-us.net>
    clk: Don't try to enable critical clocks if prepare failed

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    dt-bindings: reset: meson8b: fix duplicate reset IDs

Kai Li <li.kai4@h3c.com>
    ocfs2: call journal flush to mark journal as empty after journal recovery when mount

Nick Desaulniers <ndesaulniers@google.com>
    hexagon: work around compiler crash

Nick Desaulniers <ndesaulniers@google.com>
    hexagon: parenthesize registers in asm predicates

Alexander.Barabash@dell.com <Alexander.Barabash@dell.com>
    ioat: ioat_alloc_ring() failure handling.

Jouni Hogander <jouni.hogander@unikie.com>
    MIPS: Prevent link failure with kcov instrumentation

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    rseq/selftests: Turn off timeout setting

Varun Prakash <varun@chelsio.com>
    scsi: libcxgbi: fix NULL pointer dereference in cxgbi_device_destroy()

Johnson CH Chen (陳昭勳) <JohnsonCH.Chen@moxa.com>
    gpio: mpc8xxx: Add platform device to gpiochip->parent

Kars de Jong <jongk@linux-m68k.org>
    rtc: msm6242: Fix reading of 10-hour digit

Chao Yu <yuchao0@huawei.com>
    f2fs: fix potential overflow

Nathan Chancellor <natechancellor@gmail.com>
    rtlwifi: Remove unnecessary NULL check in rtl_regd_init

Mans Rullgard <mans@mansr.com>
    spi: atmel: fix handling of cs_change set on non-last xfer

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    mtd: spi-nor: fix silent truncation in spi_nor_read()

Seung-Woo Kim <sw0312.kim@samsung.com>
    media: exynos4-is: Fix recursive locking in isp_video_release()

Peng Fan <peng.fan@nxp.com>
    tty: serial: pch_uart: correct usage of dma_unmap_sg

Peng Fan <peng.fan@nxp.com>
    tty: serial: imx: use the sg count from dma_map_sg

Oliver O'Halloran <oohall@gmail.com>
    powerpc/powernv: Disable native PCIe port management

Bjorn Helgaas <bhelgaas@google.com>
    PCI/PTM: Remove spurious "d" from granularity message

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: handle SIOCOUTQNSD

Marian Mihailescu <mihailescu2m@gmail.com>
    clk: samsung: exynos5420: Preserve CPU clocks configuration during suspend/resume

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: fix modalias documentation

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: imu: adis16480: assign bias value only if operation succeeded

Jian-Hong Pan <jian-hong@endlessm.com>
    platform/x86: asus-wmi: Fix keyboard brightness cannot be set to 0

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: sd: Clear sdkp->protection_type if disk is reformatted without PI

James Bottomley <James.Bottomley@HansenPartnership.com>
    scsi: enclosure: Fix stale device oops with hot replug

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Report the SCSI residual to the initiator

Nathan Chancellor <natechancellor@gmail.com>
    cifs: Adjust indentation in smb2_open_file

Taehee Yoo <ap420073@gmail.com>
    hsr: reset network header when supervision frame is created

Geert Uytterhoeven <geert+renesas@glider.be>
    gpio: Fix error message on out-of-range GPIO in lookup table

Jon Derrick <jonathan.derrick@intel.com>
    iommu: Remove device link to group on failure

Ran Bi <ran.bi@mediatek.com>
    rtc: mt6397: fix alarm register overwrite

YueHaibing <yuehaibing@huawei.com>
    dccp: Fix memleak in __feat_register_sp

Theodore Ts'o <tytso@mit.edu>
    ext4: add more paranoia checking in ext4_expand_extra_isize handling

Barret Rhoden <brho@google.com>
    ext4: fix use-after-free race with debug_want_extra_isize

Navid Emamdoost <navid.emamdoost@gmail.com>
    wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle

Navid Emamdoost <navid.emamdoost@gmail.com>
    wimax: i2400: fix memory leak

Vandana BN <bnvandana@gmail.com>
    media: usb:zr364xx:Fix KASAN:null-ptr-deref Read in zr364xx_vidioc_querycap

Jouni Malinen <jouni@codeaurora.org>
    mac80211: Do not send Layer 2 Update frame before authorization

Dedy Lansky <dlansky@codeaurora.org>
    cfg80211/mac80211: make ieee80211_send_layer2_update a public function

Laura Abbott <labbott@redhat.com>
    arm64: Make sure permission updates happen for pmd/pud

Will Deacon <will.deacon@arm.com>
    arm64: Enforce BBM for huge IO/VMAP mappings

Ben Hutchings <ben.hutchings@codethink.co.uk>
    arm64: mm: Change page table pointer name in p[md]_set_huge()

Kristina Martsenko <kristina.martsenko@arm.com>
    arm64: don't open code page table entry creation

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    arm64: mm: BUG on unsupported manipulations of live kernel mappings

Sanjay Konduri <sanjay.konduri@redpinesignals.com>
    rsi: add fix for crash during assertions

Arnd Bergmann <arnd@arndb.de>
    fs/select: avoid clang stack usage warning

Arnd Bergmann <arnd@arndb.de>
    ethtool: reduce stack usage with clang

Jiri Kosina <jkosina@suse.cz>
    HID: hidraw, uhid: Always report EPOLLOUT

Marcel Holtmann <marcel@holtmann.org>
    HID: hidraw: Fix returning EPOLLOUT from hidraw_poll

Fabian Henneke <fabian.henneke@gmail.com>
    hidraw: Return EPOLLOUT from hidraw_poll


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-mei            |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi  |   8 +-
 arch/arm64/include/asm/kvm_mmu.h                   |   5 +
 arch/arm64/include/asm/pgtable.h                   |   1 +
 arch/arm64/kernel/hibernate.c                      |   3 +-
 arch/arm64/mm/mmu.c                                | 102 ++++++----
 arch/hexagon/include/asm/atomic.h                  |   8 +-
 arch/hexagon/include/asm/bitops.h                  |   8 +-
 arch/hexagon/include/asm/cmpxchg.h                 |   2 +-
 arch/hexagon/include/asm/futex.h                   |   6 +-
 arch/hexagon/include/asm/spinlock.h                |  20 +-
 arch/hexagon/kernel/stacktrace.c                   |   4 +-
 arch/hexagon/kernel/vm_entry.S                     |   2 +-
 arch/mips/boot/compressed/Makefile                 |   3 +
 arch/powerpc/platforms/powernv/pci.c               |  17 ++
 arch/x86/boot/compressed/head_64.S                 |   5 +
 block/blk-settings.c                               |   2 +-
 drivers/block/xen-blkfront.c                       |   4 +-
 drivers/clk/clk.c                                  |  10 +-
 drivers/clk/samsung/clk-exynos5420.c               |   2 +
 drivers/dma/ioat/dma.c                             |   3 +-
 drivers/gpio/gpio-mpc8xxx.c                        |   1 +
 drivers/gpio/gpiolib.c                             |   5 +-
 drivers/hid/hidraw.c                               |   7 +-
 drivers/hid/uhid.c                                 |   5 +-
 drivers/iio/imu/adis16480.c                        |   6 +-
 drivers/iio/industrialio-buffer.c                  |   6 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  24 +++
 drivers/iommu/iommu.c                              |   1 +
 drivers/md/dm-snap-persistent.c                    |   2 +-
 drivers/md/raid0.c                                 |   2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   2 +-
 drivers/media/usb/zr364xx/zr364xx.c                |   3 +-
 drivers/message/fusion/mptctl.c                    | 213 +++++----------------
 drivers/misc/enclosure.c                           |   3 +-
 drivers/mtd/spi-nor/spi-nor.c                      |   2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 drivers/net/macvlan.c                              |   5 +-
 drivers/net/usb/lan78xx.c                          |   1 +
 drivers/net/usb/r8152.c                            |   3 +
 drivers/net/wan/fsl_ucc_hdlc.c                     |   2 +-
 drivers/net/wimax/i2400m/op-rfkill.c               |   1 +
 drivers/net/wireless/realtek/rtlwifi/regd.c        |   2 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   1 +
 drivers/net/wireless/st/cw1200/fwio.c              |   6 +-
 drivers/pci/pcie/ptm.c                             |   2 +-
 drivers/platform/x86/asus-wmi.c                    |   8 +-
 drivers/rtc/rtc-msm6242.c                          |   3 +-
 drivers/rtc/rtc-mt6397.c                           |  47 +++--
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |   2 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |   3 +-
 drivers/scsi/esas2r/esas2r_flash.c                 |   1 +
 drivers/scsi/fnic/vnic_dev.c                       |  30 ++-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |   3 -
 drivers/scsi/scsi_trace.c                          | 113 ++++-------
 drivers/scsi/sd.c                                  |   4 +-
 drivers/spi/spi-atmel.c                            |  10 +-
 drivers/target/target_core_fabric_lib.c            |   2 +-
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/tty/serial/pch_uart.c                      |   5 +-
 drivers/usb/core/hub.c                             |   1 +
 drivers/usb/serial/ch341.c                         |   6 +-
 drivers/usb/serial/io_edgeport.c                   |  33 ++--
 drivers/usb/serial/keyspan.c                       |   4 +
 drivers/usb/serial/opticon.c                       |   2 +-
 drivers/usb/serial/quatech2.c                      |   6 +
 drivers/usb/serial/usb-serial-simple.c             |   2 +
 drivers/usb/serial/usb-serial.c                    |   3 +
 firmware/Makefile                                  |   2 +-
 fs/cifs/smb2file.c                                 |   2 +-
 fs/ext4/inode.c                                    |  15 ++
 fs/ext4/super.c                                    |  60 +++---
 fs/f2fs/data.c                                     |   2 +-
 fs/f2fs/file.c                                     |   2 +-
 fs/ocfs2/journal.c                                 |   8 +
 fs/reiserfs/xattr.c                                |   8 +-
 include/dt-bindings/reset/amlogic,meson8b-reset.h  |   6 +-
 include/linux/blkdev.h                             |   8 +-
 include/linux/poll.h                               |   4 +
 include/linux/regulator/ab8500.h                   |   2 -
 include/net/cfg80211.h                             |  11 ++
 mm/page-writeback.c                                |   4 +-
 net/batman-adv/distributed-arp-table.c             |   4 +-
 net/core/ethtool.c                                 |  16 +-
 net/dccp/feat.c                                    |   7 +-
 net/dsa/tag_qca.c                                  |   3 -
 net/hsr/hsr_device.c                               |   2 +
 net/ipv4/netfilter/arp_tables.c                    |  19 +-
 net/ipv4/tcp_input.c                               |   7 +-
 net/mac80211/cfg.c                                 |  55 +-----
 net/mac80211/sta_info.c                            |   4 +
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   2 +-
 net/socket.c                                       |   1 +
 net/wireless/rdev-ops.h                            |   4 +
 net/wireless/util.c                                |  47 ++++-
 sound/core/seq/seq_timer.c                         |  14 +-
 tools/perf/builtin-report.c                        |   5 +-
 tools/perf/util/hist.h                             |   4 +-
 tools/perf/util/probe-finder.c                     |  32 +---
 tools/testing/selftests/rseq/settings              |   1 +
 102 files changed, 620 insertions(+), 565 deletions(-)


