Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D857144F81
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbgAVJig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:38:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:55456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733083AbgAVJif (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:38:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A10F72467E;
        Wed, 22 Jan 2020 09:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685914;
        bh=8YE+uXXGH28R+nZ8IPP/mSBdmvE3LreIzuX+rK2gvjk=;
        h=From:To:Cc:Subject:Date:From;
        b=jMzYwoNC6VtgXxE2gimMloEDFt8yAMkTIxLiGS2gWPqISnEktxQ8Uc7drTT0zLzls
         ZaUQMoE39dqnA7CNx5DrapasXQX+R3YPe5mueZwWv/Jhf6o65a7puKddY7bIsQqNsh
         gmQIJOcdNOAUFI3wJidPkJFZHNKRfZhQN6Z3W1Y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/65] 4.14.167-stable review
Date:   Wed, 22 Jan 2020 10:28:45 +0100
Message-Id: <20200122092750.976732974@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.167-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.167-rc1
X-KernelTest-Deadline: 2020-01-24T09:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.167 release.
There are 65 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.167-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.167-rc1

Stephan Gerhold <stephan@gerhold.net>
    regulator: ab8500: Remove SYSCLKREQ from enum ab8505_regulator_id

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

Sudeep Holla <sudeep.holla@arm.com>
    Revert "arm64: dts: juno: add dma-ranges property"

Eric Dumazet <edumazet@google.com>
    tick/sched: Annotate lockless access to last_jiffies_update

Johannes Berg <johannes.berg@intel.com>
    cfg80211: check for set_wiphy_params

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-gxl-s905x-khadas-vim: fix gpio-keys-polled node

Dan Carpenter <dan.carpenter@oracle.com>
    cw1200: Fix a signedness bug in cw1200_load_firmware()

Nathan Chancellor <natechancellor@gmail.com>
    xen/blkfront: Adjust indentation in xlvbd_alloc_gendisk

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
    netfilter: arp_tables: init netns pointer in xt_tgdtor_param struct

Cong Wang <xiyou.wangcong@gmail.com>
    netfilter: fix a use-after-free in mtype_destroy()

Felix Fietkau <nbd@nbd.name>
    cfg80211: fix page refcount issue in A-MSDU decap

Dinh Nguyen <dinguyen@kernel.org>
    arm64: dts: agilex/stratix10: fix pmu interrupt numbers

Kirill A. Shutemov <kirill@shutemov.name>
    mm/huge_memory.c: thp: fix conflict of above-47bit hint address and PMD alignment

Bharath Vedartham <linux.bhar@gmail.com>
    mm/huge_memory.c: make __thp_get_unmapped_area static

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

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: fix memory leak in qgroup accounting

Kirill A. Shutemov <kirill@shutemov.name>
    mm/shmem.c: thp, shmem: fix conflict of above-47bit hint address and PMD alignment

Jin Yao <yao.jin@linux.intel.com>
    perf report: Fix incorrectly added dimensions as switch perf data file

Yuya Fujita <fujita.yuya@fujitsu.com>
    perf hists: Fix variable name's inconsistency in hists__for_each() macro

Ard Biesheuvel <ardb@kernel.org>
    x86/efistub: Disable paging at mixed mode entry

Qian Cai <cai@lca.pw>
    x86/resctrl: Fix an imbalance in domain_remove_cpu()

Keiya Nobuta <nobuta.keiya@fujitsu.com>
    usb: core: hub: Improved device recognition on remote wakeup

Christian Brauner <christian.brauner@ubuntu.com>
    ptrace: reintroduce usage of subjective credentials in ptrace_has_cap()

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

Kishon Vijay Abraham I <kishon@ti.com>
    ARM: dts: am571x-idk: Fix gpios property to have the correct gpio number

Mikulas Patocka <mpatocka@redhat.com>
    block: fix an integer overflow in logical block size

Jari Ruusu <jari.ruusu@gmail.com>
    Fix built-in early-load Intel microcode alignment

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix racy access for queue timer in proc read

Stephan Gerhold <stephan@gerhold.net>
    ASoC: msm8916-wcd-analog: Fix selected events for MIC BIAS External1

Guenter Roeck <linux@roeck-us.net>
    clk: Don't try to enable critical clocks if prepare failed

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    dt-bindings: reset: meson8b: fix duplicate reset IDs


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/am571x-idk.dts                   |   2 +-
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi  |   8 +-
 .../dts/amlogic/meson-gxl-s905x-khadas-vim.dts     |   4 +-
 arch/arm64/boot/dts/arm/juno-base.dtsi             |   1 -
 arch/x86/boot/compressed/head_64.S                 |   5 +
 arch/x86/kernel/cpu/intel_rdt.c                    |   2 +-
 block/blk-settings.c                               |   2 +-
 drivers/block/xen-blkfront.c                       |   4 +-
 drivers/clk/clk.c                                  |  10 +-
 drivers/iio/industrialio-buffer.c                  |   6 +-
 drivers/md/dm-snap-persistent.c                    |   2 +-
 drivers/md/raid0.c                                 |   2 +-
 drivers/message/fusion/mptctl.c                    | 213 +++++----------------
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |   4 +-
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
 drivers/usb/serial/io_edgeport.c                   |  33 ++--
 drivers/usb/serial/keyspan.c                       |   4 +
 drivers/usb/serial/opticon.c                       |   2 +-
 drivers/usb/serial/option.c                        |   6 +
 drivers/usb/serial/quatech2.c                      |   6 +
 drivers/usb/serial/usb-serial-simple.c             |   2 +
 drivers/usb/serial/usb-serial.c                    |   3 +
 firmware/Makefile                                  |   2 +-
 fs/btrfs/qgroup.c                                  |   6 +-
 fs/reiserfs/xattr.c                                |   8 +-
 include/dt-bindings/reset/amlogic,meson8b-reset.h  |   6 +-
 include/linux/blkdev.h                             |   8 +-
 include/linux/regulator/ab8500.h                   |   2 -
 kernel/ptrace.c                                    |  15 +-
 kernel/time/tick-sched.c                           |  14 +-
 mm/huge_memory.c                                   |  38 ++--
 mm/page-writeback.c                                |   4 +-
 mm/shmem.c                                         |   7 +-
 net/batman-adv/distributed-arp-table.c             |   4 +-
 net/dsa/tag_qca.c                                  |   3 -
 net/ipv4/netfilter/arp_tables.c                    |  19 +-
 net/ipv4/tcp_input.c                               |   7 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   2 +-
 net/wireless/rdev-ops.h                            |   4 +
 net/wireless/util.c                                |   2 +-
 sound/core/seq/seq_timer.c                         |  14 +-
 sound/soc/codecs/msm8916-wcd-analog.c              |   4 +-
 tools/perf/builtin-report.c                        |   5 +-
 tools/perf/util/hist.h                             |   4 +-
 tools/perf/util/probe-finder.c                     |  32 +---
 65 files changed, 320 insertions(+), 409 deletions(-)


