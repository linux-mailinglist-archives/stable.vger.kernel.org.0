Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE28F113139
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 18:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbfLDR5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:57:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:58268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728244AbfLDR5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:57:30 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B5E720675;
        Wed,  4 Dec 2019 17:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482248;
        bh=XEqpM9cdYfrr4p/VpjjyN+0Zvnnml/Z6xGEroPToKLE=;
        h=From:To:Cc:Subject:Date:From;
        b=C31pAvaUvxTX9RWffJUUHFUP/L2icUbxG0PRQuhygFZaxOYBLqBbNc/XqULskt0Vg
         knhwII0fpdWqzWly9ll5kZY3oKrVL3QCV6x7g0PzkLl15p72Ef127rjHRbVmiGLPow
         UpNX2LR2iVBJZWQB0KEhgtNHNXOPv9y6QSi4BwdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/92] 4.4.206-stable review
Date:   Wed,  4 Dec 2019 18:49:00 +0100
Message-Id: <20191204174327.215426506@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.206-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.206-rc1
X-KernelTest-Deadline: 2019-12-06T17:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.206 release.
There are 92 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 06 Dec 2019 17:42:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.206-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.206-rc1

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer

Lionel Debieve <lionel.debieve@st.com>
    hwrng: stm32 - fix unbalanced pm_runtime_enable

Candle Sun <candle.sun@unisoc.com>
    HID: core: check whether Usage Page item is after Usage ID items

Dust Li <dust.li@linux.alibaba.com>
    net: sched: fix `tc -s class show` no bstats on class with nolock subqueues

John Rutherford <john.rutherford@dektech.com.au>
    tipc: fix link name length check

Paolo Abeni <pabeni@redhat.com>
    openvswitch: remove another BUG_ON()

Paolo Abeni <pabeni@redhat.com>
    openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()

Jouni Hogander <jouni.hogander@unikie.com>
    slip: Fix use-after-free Read in slip_open

Paolo Abeni <pabeni@redhat.com>
    openvswitch: fix flow command message size

Menglong Dong <dong.menglong@zte.com.cn>
    macvlan: schedule bc_work even if error

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: Clear chip_data in pwm_put()

Luca Ceresoli <luca@lucaceresoli.net>
    net: macb: fix error format in dev_err()

Eugen Hristev <eugen.hristev@microchip.com>
    media: v4l2-ctrl: fix flags for DO_WHITE_BALANCE

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus: prefix device names on bus with the bus name

Fabio D'Urso <fabiodurso@hotmail.it>
    USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P

Pan Bian <bianpan2016@163.com>
    staging: rtl8192e: fix potential use after free

Boris Brezillon <bbrezillon@kernel.org>
    mtd: Remove a debug trace in mtdpart.c

Gen Zhang <blackgod016574@gmail.com>
    powerpc/pseries/dlpar: Fix a missing check in dlpar_parse_cc_property()

John Garry <john.garry@huawei.com>
    scsi: libsas: Check SMP PHY control function result

James Morse <james.morse@arm.com>
    ACPI / APEI: Switch estatus pool to use vmalloc memory

John Garry <john.garry@huawei.com>
    scsi: libsas: Support SATA PHY connection rate unmatch fixing during discovery

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    net: dev: Use unsigned integer as an argument to left-shift

Eric Dumazet <edumazet@google.com>
    net: fix possible overflow in __sk_mem_raise_allocated()

Bert Kenward <bkenward@solarflare.com>
    sfc: initialise found bitmap in efx_ef10_mtd_probe

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix skb may be leaky in tipc_link_input

Johannes Berg <johannes.berg@intel.com>
    decnet: fix DN_IFREQ_SIZE

Edward Cree <ecree@solarflare.com>
    sfc: suppress duplicate nvmem partition types in efx_ef10_mtd_probe

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    net/core/neighbour: fix kmemleak minimal reference count for hash tables

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    net/core/neighbour: tell kmemleak about hash tables

Gustavo A. R. Silva <gustavo@embeddedor.com>
    tipc: fix memory leak in tipc_nl_compat_publ_dump

Boris Brezillon <bbrezillon@kernel.org>
    mtd: Check add_mtd_device() ret code

Olof Johansson <olof@lixom.net>
    lib/genalloc.c: include vmalloc.h

Huang Shijie <sjhuang@iluvatar.ai>
    lib/genalloc.c: use vzalloc_node() to allocate the bitmap

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: clear journal dirty flag after shutdown journal

Kangjie Lu <kjlu@umn.edu>
    tipc: fix a missing check of genlmsg_put

Kangjie Lu <kjlu@umn.edu>
    atl1e: checking the status of atl1e_write_phy_reg

Kangjie Lu <kjlu@umn.edu>
    net: stmicro: fix a missing check of clk_prepare

Richard Weinberger <richard@nod.at>
    um: Make GCOV depend on !KCOV

Aditya Pakki <pakki001@umn.edu>
    net/net_namespace: Check the return value of register_pernet_subsys()

Kangjie Lu <kjlu@umn.edu>
    regulator: tps65910: fix a missing check of return value

Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
    drbd: fix print_st_err()'s prototype to match the definition

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: reject attach of unsuitable uuids even if connected

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/44x/bamboo: Fix PCI range

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/mm: Make NULL pointer deferences explicit on bad page faults.

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/prom: fix early DEBUG messages

Kyle Roeschley <kyle.roeschley@ni.com>
    ath6kl: Fix off by one error in scan completion

Kyle Roeschley <kyle.roeschley@ni.com>
    ath6kl: Only use match sets when firmware supports it

Varun Prakash <varun@chelsio.com>
    scsi: csiostor: fix incorrect dma device in case of vport

Anatoliy Glagolev <glagolig@gmail.com>
    scsi: qla2xxx: deadlock by configfs_depend_item

Bart Van Assche <bvanassche@acm.org>
    RDMA/srp: Propagate ib_post_send() failures to the SCSI mid-layer

Geert Uytterhoeven <geert@linux-m68k.org>
    openrisc: Fix broken paths to arch/or32

Alexander Shiyan <shc_work@mail.ru>
    serial: max310x: Fix tx_empty() callback

Kangjie Lu <kjlu@umn.edu>
    drivers/regulator: fix a missing check of return value

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/xmon: fix dump_segments()

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/book3s/32: fix number of bats in p/v_block_mapped()

Dan Carpenter <dan.carpenter@oracle.com>
    IB/qib: Fix an error code in qib_sdma_verbs_send()

Nick Bowler <nbowler@draconx.ca>
    xfs: Align compat attrlist_by_handle with native implementation.

Bob Peterson <rpeterso@redhat.com>
    gfs2: take jdata unstuff into account in do_grow

Peter Hutterer <peter.hutterer@who-t.net>
    HID: doc: fix wrong data structure reference for UHID_OUTPUT

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7734: Fix shifted values in IPSR10

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7264: Fix PFCR3 and PFCR0 register configuration

Michael Mueller <mimu@linux.ibm.com>
    KVM: s390: unregister debug feature on failing arch init

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen/pciback: Check dev_data before using it

Josef Bacik <jbacik@fb.com>
    btrfs: only track ref_heads in delayed_ref_updates

Lepton Wu <ytht.net@gmail.com>
    VSOCK: bind to random port for VMADDR_PORT_ANY

Krzysztof Kozlowski <krzk@kernel.org>
    gpiolib: Fix return value of gpio_to_desc() stub if !GPIOLIB

Masahiro Yamada <yamada.masahiro@socionext.com>
    microblaze: move "... is ready" messages to arch/microblaze/Makefile

Masahiro Yamada <yamada.masahiro@socionext.com>
    microblaze: adjust the help to the real behavior

Pan Bian <bianpan2016@163.com>
    ubi: Do not drop UBI device reference before using

Pan Bian <bianpan2016@163.com>
    ubi: Put MTD device after it is not used

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: require both realtime inodes to mount

Pan Bian <bianpan2016@163.com>
    rtl818x: fix potential use after free

Brian Norris <briannorris@chromium.org>
    mwifiex: debugfs: correct histogram spacing, formatting

Pan Bian <bianpan2016@163.com>
    mwifiex: fix potential NULL dereference and use after free

Eric Biggers <ebiggers@google.com>
    crypto: user - support incremental algorithm dumps

Hans de Goede <hdegoede@redhat.com>
    ACPI / LPSS: Ignore acpi_device_fix_up_power() return value

Arnd Bergmann <arnd@arndb.de>
    ARM: ks8695: fix section mismatch warning

Thomas Meyer <thomas@m3y3r.de>
    PM / AVS: SmartReflex: NULL check before some freeing functions is not needed

Suzuki K Poulose <Suzuki.Poulose@arm.com>
    arm64: smp: Handle errors reported by the firmware

Helge Deller <deller@gmx.de>
    parisc: Fix HP SDC hpa address output

Helge Deller <deller@gmx.de>
    parisc: Fix serio address output

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx53-voipac-dmm-668: Fix memory node duplication

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    ARM: debug-imx: only define DEBUG_IMX_UART_PORT if needed

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix dif and first burst use in write commands

Dan Carpenter <dan.carpenter@oracle.com>
    block: drbd: remove a stray unlock in __drbd_send_protocol()

Ilya Leoshkevich <iii@linux.ibm.com>
    scripts/gdb: fix debugging modules compiled with hot/cold partitioning

Jeroen Hofstee <jhofstee@victronenergy.com>
    can: c_can: D_CAN: c_can_chip_config(): perform a sofware reset on open

Jeroen Hofstee <jhofstee@victronenergy.com>
    can: peak_usb: report bus recovery as well

Randy Dunlap <rdunlap@infradead.org>
    reset: fix reset_control_ops kerneldoc comment

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos5420: Preserve PLL configuration during suspend/resume

Russell King <rmk+kernel@armlinux.org.uk>
    ASoC: kirkwood: fix external clock probe defer

Xiaojun Sang <xsang@codeaurora.org>
    ASoC: compress: fix unsigned integer overflow check


-------------

Diffstat:

 Documentation/hid/uhid.txt                         |  2 +-
 Makefile                                           |  4 +-
 arch/arm/Kconfig.debug                             | 28 ++++++------
 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi        |  8 +---
 arch/arm/mach-ks8695/board-acs5k.c                 |  2 +-
 arch/arm64/kernel/smp.c                            |  1 +
 arch/microblaze/Makefile                           | 12 ++---
 arch/microblaze/boot/Makefile                      |  4 --
 arch/openrisc/kernel/entry.S                       |  2 +-
 arch/openrisc/kernel/head.S                        |  2 +-
 arch/powerpc/boot/dts/bamboo.dts                   |  4 +-
 arch/powerpc/kernel/prom.c                         |  6 +--
 arch/powerpc/mm/fault.c                            | 17 ++++----
 arch/powerpc/mm/ppc_mmu_32.c                       |  4 +-
 arch/powerpc/platforms/pseries/dlpar.c             |  4 ++
 arch/powerpc/xmon/xmon.c                           |  2 +-
 arch/s390/kvm/kvm-s390.c                           | 17 ++++++--
 arch/um/Kconfig.debug                              |  1 +
 crypto/crypto_user.c                               | 37 ++++++++--------
 drivers/acpi/acpi_lpss.c                           |  7 +--
 drivers/acpi/apei/ghes.c                           | 30 ++++++-------
 drivers/block/drbd/drbd_main.c                     |  1 -
 drivers/block/drbd/drbd_nl.c                       |  6 +--
 drivers/block/drbd/drbd_receiver.c                 | 19 ++++++++
 drivers/block/drbd/drbd_state.h                    |  2 +-
 drivers/char/hw_random/stm32-rng.c                 |  8 ++++
 drivers/clk/samsung/clk-exynos5420.c               |  6 +++
 drivers/hid/hid-core.c                             | 51 +++++++++++++++++++---
 drivers/infiniband/hw/qib/qib_sdma.c               |  4 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |  1 +
 drivers/input/serio/gscps2.c                       |  4 +-
 drivers/input/serio/hp_sdc.c                       |  4 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  1 +
 drivers/misc/mei/bus.c                             |  9 ++--
 drivers/mtd/mtdcore.h                              |  2 +-
 drivers/mtd/mtdpart.c                              | 35 ++++++++++++---
 drivers/mtd/ubi/build.c                            |  2 +-
 drivers/mtd/ubi/kapi.c                             |  2 +-
 drivers/net/can/c_can/c_can.c                      | 26 +++++++++++
 drivers/net/can/usb/peak_usb/pcan_usb.c            | 15 ++++---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |  4 +-
 drivers/net/ethernet/cadence/macb.c                | 12 ++---
 drivers/net/ethernet/sfc/ef10.c                    | 29 ++++++++----
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  |  4 +-
 drivers/net/macvlan.c                              |  3 +-
 drivers/net/slip/slip.c                            |  1 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  4 +-
 drivers/net/wireless/mwifiex/debugfs.c             | 14 +++---
 drivers/net/wireless/mwifiex/scan.c                | 18 ++++----
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |  3 +-
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                |  9 +++-
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                | 16 +++----
 drivers/platform/x86/hp-wmi.c                      |  6 +--
 drivers/power/avs/smartreflex.c                    |  3 +-
 drivers/pwm/core.c                                 |  1 +
 drivers/pwm/pwm-samsung.c                          |  1 -
 drivers/regulator/palmas-regulator.c               |  5 ++-
 drivers/regulator/tps65910-regulator.c             |  4 +-
 drivers/scsi/csiostor/csio_init.c                  |  2 +-
 drivers/scsi/libsas/sas_expander.c                 | 29 +++++++++++-
 drivers/scsi/lpfc/lpfc_scsi.c                      | 18 ++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 | 48 ++++----------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h                 |  3 --
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |  5 ++-
 drivers/tty/serial/max310x.c                       |  7 +--
 drivers/usb/serial/ftdi_sio.c                      |  3 ++
 drivers/usb/serial/ftdi_sio_ids.h                  |  7 +++
 drivers/xen/xen-pciback/pci_stub.c                 |  3 +-
 fs/btrfs/delayed-ref.c                             |  3 --
 fs/gfs2/bmap.c                                     |  2 +
 fs/ocfs2/journal.c                                 |  6 +--
 fs/xfs/xfs_ioctl32.c                               |  6 +++
 fs/xfs/xfs_rtalloc.c                               |  4 +-
 include/linux/gpio/consumer.h                      |  2 +-
 include/linux/netdevice.h                          |  2 +-
 include/linux/reset-controller.h                   |  2 +-
 include/net/sock.h                                 |  2 +-
 lib/genalloc.c                                     |  5 ++-
 net/core/neighbour.c                               | 13 ++++--
 net/core/net_namespace.c                           |  3 +-
 net/core/sock.c                                    |  2 +-
 net/decnet/dn_dev.c                                |  2 +-
 net/openvswitch/datapath.c                         | 17 ++++++--
 net/sched/sch_mq.c                                 |  2 +-
 net/sched/sch_mqprio.c                             |  3 +-
 net/sched/sch_multiq.c                             |  2 +-
 net/sched/sch_prio.c                               |  2 +-
 net/tipc/link.c                                    |  2 +-
 net/tipc/netlink_compat.c                          |  8 +++-
 net/vmw_vsock/af_vsock.c                           |  7 ++-
 scripts/gdb/linux/symbols.py                       |  3 +-
 sound/core/compress_offload.c                      |  2 +-
 sound/soc/kirkwood/kirkwood-i2s.c                  |  8 ++--
 93 files changed, 493 insertions(+), 271 deletions(-)


