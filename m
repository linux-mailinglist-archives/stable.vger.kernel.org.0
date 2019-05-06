Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 407C114DE1
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfEFOz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbfEFOpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:45:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B73BC2087F;
        Mon,  6 May 2019 14:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153931;
        bh=RGf2htzquB7U46U+J6SaQ3lwqmBdns/wPMEA8Vu62x0=;
        h=From:To:Cc:Subject:Date:From;
        b=wZDp94ajkwxIFZ94HKxJxSys50orAbbS/HYjq7LceSitsJXr2s1cbsxNOneDT3q+Q
         hDKUErEHWjpDdLHC9EZ1KbHbtuKBnBOGW/XiwaKkJSIZn6fd1YC1M6iKipmu+5MrXc
         w3yz9Y8CbGexE/ev9bRHcC+Y5gG/+q9HW/QPu2Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/75] 4.14.117-stable review
Date:   Mon,  6 May 2019 16:32:08 +0200
Message-Id: <20190506143053.287515952@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.117-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.117-rc1
X-KernelTest-Deadline: 2019-05-08T14:31+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.117 release.
There are 75 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 08 May 2019 02:29:19 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.117-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.117-rc1

Jacopo Mondi <jacopo+renesas@jmondi.org>
    media: v4l2: i2c: ov7670: Fix PLL bypass register values

Nicolas Le Bayon <nicolas.le.bayon@st.com>
    i2c: i2c-stm32f7: Fix SDADEL minimum formula

David Müller <dave.mueller@gmx.ch>
    clk: x86: Add system specific quirk to mark clocks as critical

Tony Luck <tony.luck@intel.com>
    x86/mce: Improve error message when kernel cannot recover, p2

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm/hash: Handle mmap_min_addr correctly in get_unmapped_area topdown search

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: never allow relabeling on context mounts

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: stmfts - acknowledge that setting brightness is a blocking call

Anson Huang <anson.huang@nxp.com>
    Input: snvs_pwrkey - initialize necessary driver data before enabling IRQ

Yuval Avnery <yuvalav@mellanox.com>
    IB/core: Destroy QP if XRC QP fails

Daniel Jurgens <danielj@mellanox.com>
    IB/core: Fix potential memory leak while creating MAD agents

Daniel Jurgens <danielj@mellanox.com>
    IB/core: Unregister notifier before freeing MAD security

Arnaud Pouliquen <arnaud.pouliquen@st.com>
    ASoC: stm32: fix sai driver name initialisation

Bart Van Assche <bvanassche@acm.org>
    scsi: RDMA/srpt: Fix a credit leak for aborted commands

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: fix the dac write calculation

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: fix the dac read calculation

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: allow adt751x to use internal vref for all dacs

Brian Norris <briannorris@chromium.org>
    Bluetooth: btusb: request wake pin with NOAUTOEN

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd: Update generic hardware cache events for Family 17h

Arnd Bergmann <arnd@arndb.de>
    ARM: iop: don't use using 64-bit DMA masks

Arnd Bergmann <arnd@arndb.de>
    ARM: orion: don't use using 64-bit DMA masks

Guenter Roeck <linux@roeck-us.net>
    xsysace: Fix error handling in ace_setup

Randy Dunlap <rdunlap@infradead.org>
    sh: fix multiple function definition build errors

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: fix memory leak for resv_map

Catalin Marinas <catalin.marinas@arm.com>
    kmemleak: powerpc: skip scanning holes in the .bss section

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Fix WARNING when remove HNS driver with SMMU enabled

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: fix ICMP6 neighbor solicitation messages discard problem

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Fix probabilistic memory overwrite when HNS driver initialized

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Use NAPI_POLL_WEIGHT for hns driver

Liubin Shu <shuliubin@huawei.com>
    net: hns: fix KASAN: use-after-free in hns_nic_net_xmit_hw()

Michael Kelley <mikelley@microsoft.com>
    scsi: storvsc: Fix calculation of sub-channel count

Xose Vazquez Perez <xose.vazquez@gmail.com>
    scsi: core: add new RDAC LENOVO/DE_Series device

Louis Taylor <louis@kragniz.eu>
    vfio/pci: use correct format characters

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: add mapping for Assistant key

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: da9063: set uie_unsupported when relevant

Al Viro <viro@zeniv.linux.org.uk>
    debugfs: fix use-after-free on symlink traversal

Al Viro <viro@zeniv.linux.org.uk>
    jffs2: fix use-after-free on symlink traversal

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: don't log oversized frames

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: fix dropping of multi-descriptor RX frames

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: don't overwrite discard_frame status

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: ratelimit RX error logs

Konstantin Khorenko <khorenko@virtuozzo.com>
    bonding: show full hw address in sysfs for slave entries

Omri Kahalon <omrik@mellanox.com>
    net/mlx5: E-Switch, Fix esw manager vport indication for more vport commands

Arvind Sankar <niveditas98@gmail.com>
    igb: Fix WARN_ONCE on runtime suspend

Douglas Anderson <dianders@chromium.org>
    ARM: dts: rockchip: Fix gpu opp node names for rk3288

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce tt_global hash refcnt only for removed entry

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce tt_local hash refcnt only for removed entry

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce claim hash refcnt only for removed entry

Geert Uytterhoeven <geert+renesas@glider.be>
    rtc: sh: Fix invalid alarm warning for non-enabled alarm

He, Bo <bo.he@intel.com>
    HID: debug: fix race condition with between rdesc_show() and device removal

Kangjie Lu <kjlu@umn.edu>
    HID: logitech: check the return value of create_singlethread_workqueue

Yufen Yu <yuyufen@huawei.com>
    nvme-loop: init nvmet_ctrl fatal_err_work when allocate

Minchan Kim <minchan@kernel.org>
    mm: do not stall register_shrinker()

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix bug caused by duplicate interface PM usage counter

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix unterminated string returned by usb_string()

Malte Leip <malte@leip.net>
    usb: usbip: fix isoc packet num validation in get_pipe

Alan Stern <stern@rowland.harvard.edu>
    USB: w1 ds2490: Fix bug caused by improper use of altsetting array

Alan Stern <stern@rowland.harvard.edu>
    USB: yurex: Fix protection fault after device removal

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed Dell AIO speaker noise

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add new Dell platform for headset mode

Arnd Bergmann <arnd@arndb.de>
    caif: reduce stack size with KASAN

Mark Rutland <mark.rutland@arm.com>
    arm64: only advance singlestep for user instruction traps

Julien Thierry <julien.thierry@arm.com>
    arm64: Fix single stepping in kernel traps

Andrey Konovalov <andreyknvl@google.com>
    kasan: prevent compiler from optimizing away memset in tests

Colin Ian King <colin.king@canonical.com>
    kasan: remove redundant initialization of variable 'real_size'

Dan Carpenter <dan.carpenter@oracle.com>
    net: dsa: bcm_sf2: fix buffer overflow doing set_rxnfc

Andrew Lunn <andrew@lunn.ch>
    net: phy: marvell: Fix buffer overrun with stats counters

David Howells <dhowells@redhat.com>
    rxrpc: Fix net namespace cleanup

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Free short FW command HWRM memory in error path in bnxt_init_one()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Improve multicast address setup logic.

Willem de Bruijn <willemb@google.com>
    packet: validate msg_namelen in send directly

Xin Long <lucien.xin@gmail.com>
    sctp: avoid running the sctp state machine recursively

Willem de Bruijn <willemb@google.com>
    ipv6: invert flowlabel sharing check in process and user mode

Eric Dumazet <edumazet@google.com>
    ipv6/flowlabel: wait rcu grace period before put_pid()

Shmulik Ladkani <shmulik@metanetworks.com>
    ipv4: ip_do_fragment: Preserve skb_iif during fragmentation

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ALSA: line6: use dynamic buffers


-------------

Diffstat:

 Documentation/driver-api/usb/power-management.rst  |  14 ++-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/rk3288.dtsi                      |  12 +--
 arch/arm/mach-iop13xx/setup.c                      |   8 +-
 arch/arm/mach-iop13xx/tpmi.c                       |  10 +-
 arch/arm/plat-iop/adma.c                           |   6 +-
 arch/arm/plat-orion/common.c                       |   4 +-
 arch/arm64/include/asm/traps.h                     |   6 ++
 arch/arm64/kernel/armv8_deprecated.c               |   8 +-
 arch/arm64/kernel/cpufeature.c                     |   2 +-
 arch/arm64/kernel/traps.c                          |  22 +++-
 arch/powerpc/kernel/kvm.c                          |   7 ++
 arch/powerpc/mm/slice.c                            |  10 +-
 arch/sh/boards/of-generic.c                        |   4 +-
 arch/x86/events/amd/core.c                         | 111 ++++++++++++++++++++-
 arch/x86/kernel/cpu/mcheck/mce-severity.c          |   5 +
 drivers/block/xsysace.c                            |   2 +
 drivers/bluetooth/btusb.c                          |   2 +-
 drivers/clk/x86/clk-pmc-atom.c                     |  14 ++-
 drivers/hid/hid-debug.c                            |   5 +
 drivers/hid/hid-input.c                            |   1 +
 drivers/hid/hid-logitech-hidpp.c                   |   8 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |   2 +-
 drivers/infiniband/core/security.c                 |  11 +-
 drivers/infiniband/core/verbs.c                    |  41 ++++----
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  11 ++
 drivers/input/keyboard/snvs_pwrkey.c               |   6 +-
 drivers/input/touchscreen/stmfts.c                 |  30 +++---
 drivers/media/i2c/ov7670.c                         |  16 ++-
 drivers/net/bonding/bond_sysfs_slave.c             |   4 +-
 drivers/net/dsa/bcm_sf2_cfp.c                      |   6 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  10 +-
 drivers/net/ethernet/hisilicon/hns/hnae.c          |   4 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c |  33 ++++--
 .../net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c    |   2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |  12 +--
 drivers/net/ethernet/intel/igb/e1000_defines.h     |   2 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  57 ++---------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   6 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |  12 ++-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |   2 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  14 +--
 drivers/net/phy/marvell.c                          |   6 +-
 drivers/nvme/target/core.c                         |  20 ++--
 drivers/platform/x86/pmc_atom.c                    |  21 ++++
 drivers/rtc/rtc-da9063.c                           |   7 ++
 drivers/rtc/rtc-sh.c                               |   2 +-
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/scsi/scsi_dh.c                             |   1 +
 drivers/scsi/storvsc_drv.c                         |  13 ++-
 drivers/staging/iio/addac/adt7316.c                |  22 ++--
 drivers/usb/core/driver.c                          |  13 ---
 drivers/usb/core/message.c                         |   4 +-
 drivers/usb/misc/yurex.c                           |   1 +
 drivers/usb/storage/realtek_cr.c                   |  13 +--
 drivers/usb/usbip/stub_rx.c                        |  12 +--
 drivers/usb/usbip/usbip_common.h                   |   7 ++
 drivers/vfio/pci/vfio_pci.c                        |   4 +-
 drivers/w1/masters/ds2490.c                        |   6 +-
 fs/debugfs/inode.c                                 |  13 ++-
 fs/hugetlbfs/inode.c                               |  20 ++--
 fs/jffs2/readinode.c                               |   5 -
 fs/jffs2/super.c                                   |   5 +-
 include/linux/platform_data/x86/clk-pmc-atom.h     |   3 +
 include/linux/usb.h                                |   2 -
 include/net/caif/cfpkt.h                           |  27 +++++
 include/net/sctp/command.h                         |   1 -
 lib/Makefile                                       |   1 +
 lib/test_kasan.c                                   |   2 +-
 mm/kmemleak.c                                      |  16 ++-
 mm/vmscan.c                                        |   9 ++
 net/batman-adv/bridge_loop_avoidance.c             |  16 ++-
 net/batman-adv/translation-table.c                 |  32 ++++--
 net/caif/cfctrl.c                                  |  50 ++++------
 net/ipv4/ip_output.c                               |   1 +
 net/ipv6/ip6_flowlabel.c                           |  22 ++--
 net/packet/af_packet.c                             |  24 +++--
 net/rxrpc/call_object.c                            |  32 +++---
 net/sctp/sm_sideeffect.c                           |  29 ------
 net/sctp/sm_statefuns.c                            |  35 +++++--
 security/selinux/hooks.c                           |  40 ++++++--
 sound/pci/hda/patch_realtek.c                      |   9 ++
 sound/soc/stm/stm32_sai_sub.c                      |   2 +-
 sound/usb/line6/driver.c                           |  60 ++++++-----
 sound/usb/line6/podhd.c                            |  21 ++--
 sound/usb/line6/toneport.c                         |  24 +++--
 86 files changed, 778 insertions(+), 422 deletions(-)


