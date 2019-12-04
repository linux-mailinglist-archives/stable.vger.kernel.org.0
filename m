Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4757A1131D5
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfLDSDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:03:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbfLDSDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:03:00 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3868320675;
        Wed,  4 Dec 2019 18:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482578;
        bh=aw3k3fH7noxVt0BK8H270jAS0htr7gUdM4SGNgwgovs=;
        h=From:To:Cc:Subject:Date:From;
        b=l/Gt8QWnpixccRp1VCyXxDEuHW3UFEwzxn7lYO/yhyn5+au+oIKZygM5TNw1pRtaf
         98NQqA3/hKQ1ymydtijUlFGidsUE0zGR9S8DU81s455xd9AjZeVSbqhRlDLdaFPSMp
         /lNUUdwGNQD8KQaMm+yDht5NqruLLBwB6PAQTIF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/209] 4.14.158-stable review
Date:   Wed,  4 Dec 2019 18:53:32 +0100
Message-Id: <20191204175321.609072813@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.158-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.158-rc1
X-KernelTest-Deadline: 2019-12-06T17:53+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.158 release.
There are 209 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 06 Dec 2019 17:50:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.158-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.158-rc1

Chuhong Yuan <hslester96@gmail.com>
    net: fec: fix clock count mis-match

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Fix ACPI errors caused by passing 0 as input size

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: i2s: fix IRQ clearing

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: i2s: fix 16 bit format support

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: i2s: fix dma configuration

Alexandre Torgue <alexandre.torgue@st.com>
    pinctrl: stm32: fix memory leak issue

Fabien Dessenne <fabien.dessenne@st.com>
    mailbox: mailbox-test: fix null pointer if no mmio

Lionel Debieve <lionel.debieve@st.com>
    hwrng: stm32 - fix unbalanced pm_runtime_enable

Hugues Fruchet <hugues.fruchet@st.com>
    media: stm32-dcmi: fix DMA corruption when stopping streaming

Lionel Debieve <lionel.debieve@st.com>
    crypto: stm32/hash - Fix hmac issue more than 256 bytes

Candle Sun <candle.sun@unisoc.com>
    HID: core: check whether Usage Page item is after Usage ID items

Thomas Gleixner <tglx@linutronix.de>
    futex: Prevent exit livelock

Thomas Gleixner <tglx@linutronix.de>
    futex: Provide distinct return value when owner is exiting

Thomas Gleixner <tglx@linutronix.de>
    futex: Add mutex around futex exit

Thomas Gleixner <tglx@linutronix.de>
    futex: Provide state handling for exec() as well

Thomas Gleixner <tglx@linutronix.de>
    futex: Sanitize exit state handling

Thomas Gleixner <tglx@linutronix.de>
    futex: Mark the begin of futex exit explicitly

Thomas Gleixner <tglx@linutronix.de>
    futex: Set task::futex_state to DEAD right after handling futex exit

Thomas Gleixner <tglx@linutronix.de>
    futex: Split futex_mm_release() for exit/exec

Thomas Gleixner <tglx@linutronix.de>
    exit/exec: Seperate mm_release()

Thomas Gleixner <tglx@linutronix.de>
    futex: Replace PF_EXITPIDONE with a state

Thomas Gleixner <tglx@linutronix.de>
    futex: Move futex exit handling into futex code

Yang Tao <yang.tao172@zte.com.cn>
    futex: Prevent robust futex exit race

Arnd Bergmann <arnd@arndb.de>
    y2038: futex: Move compat implementation into futex.c

huijin.park <huijin.park@samsung.com>
    mtd: spi-nor: cast to u64 to avoid uint overflows

Wen Yang <yellowriver2010@hotmail.com>
    mtd: rawnand: atmel: fix possible object reference leak

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: atmel: Fix spelling mistake in error message

Paul Thomas <pthomas8589@gmail.com>
    net: macb driver, check for SKBTX_HW_TSTAMP

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Fix SUBNS increment and increase resolution

Eugen Hristev <eugen.hristev@microchip.com>
    watchdog: sama5d4: fix WDD value to be always set to max

Theodore Ts'o <tytso@mit.edu>
    ext4: add more paranoia checking in ext4_expand_extra_isize handling

Dust Li <dust.li@linux.alibaba.com>
    net: sched: fix `tc -s class show` no bstats on class with nolock subqueues

Xin Long <lucien.xin@gmail.com>
    sctp: cache netns in sctp_ep_common

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

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: psample: fix skb_over_panic

Menglong Dong <dong.menglong@zte.com.cn>
    macvlan: schedule bc_work even if error

Eugen Hristev <eugen.hristev@microchip.com>
    media: atmel: atmel-isc: fix INIT_WORK misplacement

Eugen Hristev <eugen.hristev@microchip.com>
    media: atmel: atmel-isc: fix asd memory allocation

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: Clear chip_data in pwm_put()

Luca Ceresoli <luca@lucaceresoli.net>
    net: macb: fix error format in dev_err()

Eugen Hristev <eugen.hristev@microchip.com>
    media: v4l2-ctrl: fix flags for DO_WHITE_BALANCE

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix memleak on xfrm state destroy

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus: prefix device names on bus with the bus name

Fabio D'Urso <fabiodurso@hotmail.it>
    USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P

Hans de Goede <hdegoede@redhat.com>
    staging: rtl8723bs: Add 024c:0525 to the list of SDIO device-ids

Hans de Goede <hdegoede@redhat.com>
    staging: rtl8723bs: Drop ACPI device ids

Pan Bian <bianpan2016@163.com>
    staging: rtl8192e: fix potential use after free

Alexandre Belloni <alexandre.belloni@bootlin.com>
    clk: at91: generated: set audio_pll_allowed in at91_clk_register_generated()

Eugen Hristev <eugen.hristev@microchip.com>
    clk: at91: fix update bit maps on CFG_MOR write

Vlastimil Babka <vbabka@suse.cz>
    mm, gup: add missing refcount overflow checks on s390

Boris Brezillon <bbrezillon@kernel.org>
    mtd: Remove a debug trace in mtdpart.c

Gen Zhang <blackgod016574@gmail.com>
    powerpc/pseries/dlpar: Fix a missing check in dlpar_parse_cc_property()

John Garry <john.garry@huawei.com>
    scsi: libsas: Check SMP PHY control function result

James Morse <james.morse@arm.com>
    ACPI / APEI: Switch estatus pool to use vmalloc memory

James Morse <james.morse@arm.com>
    ACPI / APEI: Don't wait to serialise with oops messages when panic()ing

John Garry <john.garry@huawei.com>
    scsi: libsas: Support SATA PHY connection rate unmatch fixing during discovery

Chris Coulson <chris.coulson@canonical.com>
    apparmor: delete the dentry in aafs_remove() to avoid a leak

Aaron Ma <aaron.ma@canonical.com>
    iommu/amd: Fix NULL dereference bug in match_hid_uid

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: Change fw error code NOT_EXEC to NOT_SUPPORTED

Peng Sun <sironhide0null@gmail.com>
    bpf: drop refcount if bpf_map_new_fd() fails in map_create()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kvm: properly check debugfs dentry before using it

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    net: dev: Use unsigned integer as an argument to left-shift

Peng Sun <sironhide0null@gmail.com>
    bpf: decrease usercnt if bpf_map_new_fd() fails in bpf_map_get_fd_by_id()

Maciej Kwiecien <maciej.kwiecien@nokia.com>
    sctp: don't compare hb_timer expire date before starting it

Eric Dumazet <edumazet@google.com>
    net: fix possible overflow in __sk_mem_raise_allocated()

Bert Kenward <bkenward@solarflare.com>
    sfc: initialise found bitmap in efx_ef10_mtd_probe

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix skb may be leaky in tipc_link_input

Jan Kara <jack@suse.cz>
    blktrace: Show requests without sector

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: prevent races between smc_lgr_terminate() and smc_conn_free()

Johannes Berg <johannes.berg@intel.com>
    decnet: fix DN_IFREQ_SIZE

wenxu <wenxu@ucloud.cn>
    ip_tunnel: Make none-tunnel-dst tunnel port work with lwtunnel

Edward Cree <ecree@solarflare.com>
    sfc: suppress duplicate nvmem partition types in efx_ef10_mtd_probe

Lucas Stach <l.stach@pengutronix.de>
    gpu: ipu-v3: pre: don't trigger update if buffer address doesn't change

He Zhe <zhe.he@windriver.com>
    serial: 8250: Fix serial8250 initialization crash

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    net/core/neighbour: fix kmemleak minimal reference count for hash tables

Ming Lei <ming.lei@redhat.com>
    PCI/MSI: Return -ENOSPC from pci_alloc_irq_vectors_affinity()

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    net/core/neighbour: tell kmemleak about hash tables

Gustavo A. R. Silva <gustavo@embeddedor.com>
    tipc: fix memory leak in tipc_nl_compat_publ_dump

Boris Brezillon <bbrezillon@kernel.org>
    mtd: Check add_mtd_device() ret code

Olof Johansson <olof@lixom.net>
    lib/genalloc.c: include vmalloc.h

Qian Cai <cai@gmx.us>
    drivers/base/platform.c: kmemleak ignore a known leak

Yi Wang <wang.yi59@zte.com.cn>
    fork: fix some -Wmissing-prototypes warnings

Huang Shijie <sjhuang@iluvatar.ai>
    lib/genalloc.c: use vzalloc_node() to allocate the bitmap

Alexey Skidanov <alexey.skidanov@intel.com>
    lib/genalloc.c: fix allocation of aligned buffer from non-aligned chunk

Wei Yang <richard.weiyang@gmail.com>
    vmscan: return NODE_RECLAIM_NOSCAN in node_reclaim() when CONFIG_NUMA is n

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: clear journal dirty flag after shutdown journal

Wen Yang <wen.yang99@zte.com.cn>
    net/wan/fsl_ucc_hdlc: Avoid double free in ucc_hdlc_probe()

Kangjie Lu <kjlu@umn.edu>
    tipc: fix a missing check of genlmsg_put

Kangjie Lu <kjlu@umn.edu>
    atl1e: checking the status of atl1e_write_phy_reg

Kangjie Lu <kjlu@umn.edu>
    net: dsa: bcm_sf2: Propagate error value from mdio_write

Kangjie Lu <kjlu@umn.edu>
    net: stmicro: fix a missing check of clk_prepare

Kangjie Lu <kjlu@umn.edu>
    net: (cpts) fix a missing check of clk_prepare

Richard Weinberger <richard@nod.at>
    um: Make GCOV depend on !KCOV

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to dirty inode synchronously

Aditya Pakki <pakki001@umn.edu>
    net/net_namespace: Check the return value of register_pernet_subsys()

Aditya Pakki <pakki001@umn.edu>
    net/netlink_compat: Fix a missing check of nla_parse_nested

Alexander Shiyan <shc_work@mail.ru>
    pwm: clps711x: Fix period calculation

Fabio Estevam <festevam@gmail.com>
    crypto: mxc-scc - fix build warnings on ARM64

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Fix node leak in update_lmb_associativity_index()

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/83xx: handle machine check caused by watchdog timer

Kangjie Lu <kjlu@umn.edu>
    regulator: tps65910: fix a missing check of return value

Parav Pandit <parav@mellanox.com>
    IB/rxe: Make counters thread safe

Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
    drbd: fix print_st_err()'s prototype to match the definition

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: do not block when adjusting "disk-options" while IO is frozen

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: reject attach of unsuitable uuids even if connected

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: ignore "all zero" peer volume sizes in handshake

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/powernv/eeh/npu: Fix uninitialized variables in opal_pci_eeh_freeze_status

Alexey Kardashevskiy <aik@ozlabs.ru>
    vfio/spapr_tce: Get rid of possible infinite loop

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/44x/bamboo: Fix PCI range

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/mm: Make NULL pointer deferences explicit on bad page faults.

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/prom: fix early DEBUG messages

Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
    powerpc/perf: Fix unit_sel/cache_sel checks

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

Jonathan Bakker <xc-racer2@live.ca>
    Bluetooth: hci_bcm: Handle specific unknown packets after firmware loading

Kangjie Lu <kjlu@umn.edu>
    drivers/regulator: fix a missing check of return value

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/xmon: fix dump_segments()

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/book3s/32: fix number of bats in p/v_block_mapped()

Petr Machata <petrm@mellanox.com>
    vxlan: Fix error path in __vxlan_dev_create()

Tao Ren <taoren@fb.com>
    clocksource/drivers/fttmr010: Fix invalid interrupt register access

Dan Carpenter <dan.carpenter@oracle.com>
    IB/qib: Fix an error code in qib_sdma_verbs_send()

Nick Bowler <nbowler@draconx.ca>
    xfs: Fix bulkstat compat ioctls on x32 userspace.

Nick Bowler <nbowler@draconx.ca>
    xfs: Align compat attrlist_by_handle with native implementation.

Bob Peterson <rpeterso@redhat.com>
    gfs2: take jdata unstuff into account in do_grow

Sweet Tea <sweettea@redhat.com>
    dm flakey: Properly corrupt multi-page bios.

Peter Hutterer <peter.hutterer@who-t.net>
    HID: doc: fix wrong data structure reference for UHID_OUTPUT

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7734: Fix shifted values in IPSR10

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7264: Fix PFCR3 and PFCR0 register configuration

Michael Mueller <mimu@linux.ibm.com>
    KVM: s390: unregister debug feature on failing arch init

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: query force speeds before disabling autoneg mode.

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Return linux standard errors in bnxt_ethtool.c

Al Viro <viro@zeniv.linux.org.uk>
    exofs_mount(): fix leaks on failure exits

Leon Romanovsky <leonro@mellanox.com>
    net/mlx5: Continue driver initialization despite debugfs failure

Martin Schiller <ms@dev.tdt.de>
    pinctrl: xway: fix gpio-hog related boot issues

Nathan Chancellor <natechancellor@gmail.com>
    vfio-mdev/samples: Use u8 instead of char for handle functions

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen/pciback: Check dev_data before using it

Andrea Righi <righi.andrea@gmail.com>
    kprobes/x86/xen: blacklist non-attachable xen interrupt functions

Darwin Dingel <darwin.dingel@alliedtelesis.co.nz>
    serial: 8250: Rate limit serial port rx interrupts during input overruns

Pan Bian <bianpan2016@163.com>
    HID: intel-ish-hid: fixes incorrect error handling

Josef Bacik <jbacik@fb.com>
    btrfs: only track ref_heads in delayed_ref_updates

Boris Brezillon <boris.brezillon@bootlin.com>
    mtd: rawnand: sunxi: Write pageprog related opcodes to WCMD_SET

Jerome Brunet <jbrunet@baylibre.com>
    mmc: meson-gx: make sure the descriptor is stopped on errors

Lepton Wu <ytht.net@gmail.com>
    VSOCK: bind to random port for VMADDR_PORT_ANY

Jim Mattson <jmattson@google.com>
    kvm: vmx: Set IA32_TSC_AUX for legacy mode guests

Krzysztof Kozlowski <krzk@kernel.org>
    gpiolib: Fix return value of gpio_to_desc() stub if !GPIOLIB

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: move iwl_nvm_check_version() into dvm

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

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Enable Management features for IF_TYPE=6

Hans de Goede <hdegoede@redhat.com>
    ACPI / LPSS: Ignore acpi_device_fix_up_power() return value

Arnd Bergmann <arnd@arndb.de>
    ARM: ks8695: fix section mismatch warning

Thomas Meyer <thomas@m3y3r.de>
    PM / AVS: SmartReflex: NULL check before some freeing functions is not needed

Gal Pressman <galpress@amazon.com>
    RDMA/vmw_pvrdma: Use atomic memory allocation in create AH

Aaro Koskinen <aaro.koskinen@iki.fi>
    ARM: OMAP1: fix USB configuration for device-only setups

Suzuki K Poulose <Suzuki.Poulose@arm.com>
    arm64: smp: Handle errors reported by the firmware

Steve Capper <steve.capper@arm.com>
    arm64: mm: Prevent mismatched 52-bit VA support

Helge Deller <deller@gmx.de>
    parisc: Fix HP SDC hpa address output

Helge Deller <deller@gmx.de>
    parisc: Fix serio address output

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx53-voipac-dmm-668: Fix memory node duplication

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    ARM: debug-imx: only define DEBUG_IMX_UART_PORT if needed

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: Fix up SQ201 flash access

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix dif and first burst use in write commands

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix kernel Oops due to null pring pointers

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: bcm-iproc: Prevent unloading the driver module while in use

Dan Carpenter <dan.carpenter@oracle.com>
    block: drbd: remove a stray unlock in __drbd_send_protocol()

Ahmed Zaki <anzaki@gmail.com>
    mac80211: fix station inactive_time shortly after boot

Jeff Layton <jlayton@kernel.org>
    ceph: return -EINVAL if given fsc mount option on kernel w/o support

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: reapply manual settings to the PHY

Ilya Leoshkevich <iii@linux.ibm.com>
    scripts/gdb: fix debugging modules compiled with hot/cold partitioning

Xingyu Chen <xingyu.chen@amlogic.com>
    watchdog: meson: Fix the wrong value of left time

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rx-offload: can_rx_offload_irq_offload_fifo(): continue on error

Jeroen Hofstee <jhofstee@victronenergy.com>
    can: rx-offload: can_rx_offload_irq_offload_timestamp(): continue on error

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rx-offload: can_rx_offload_offload_one(): use ERR_PTR() to propagate error value in case of errors

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rx-offload: can_rx_offload_offload_one(): increment rx_fifo_errors on queue overflow or OOM

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rx-offload: can_rx_offload_offload_one(): do not increase the skb_queue beyond skb_queue_len_max

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rx-offload: can_rx_offload_queue_tail(): fix error handling, avoid skb mem leak

Jeroen Hofstee <jhofstee@victronenergy.com>
    can: c_can: D_CAN: c_can_chip_config(): perform a sofware reset on open

Jeroen Hofstee <jhofstee@victronenergy.com>
    can: peak_usb: report bus recovery as well

Florian Westphal <fw@strlen.de>
    bridge: ebtables: don't crash when using dnat target in output chains

Chuhong Yuan <hslester96@gmail.com>
    net: fec: add missed clk_disable_unprepare in remove

Peter Ujfalusi <peter.ujfalusi@ti.com>
    clk: ti: dra7-atl-clock: Remove ti_clk_add_alias call

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Prevent NULL pointer dereference when reading mondata

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr: Fix idr_alloc_u32 on 32-bit systems

Colin Ian King <colin.king@canonical.com>
    clk: sunxi-ng: a80: fix the zero'ing of bits 16 and 18

Alexandre Belloni <alexandre.belloni@bootlin.com>
    clk: at91: avoid sleeping early

Randy Dunlap <rdunlap@infradead.org>
    reset: fix reset_control_ops kerneldoc comment

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos5420: Preserve PLL configuration during suspend/resume

Russell King <rmk+kernel@armlinux.org.uk>
    ASoC: kirkwood: fix external clock probe defer

Kishon Vijay Abraham I <kishon@ti.com>
    reset: Fix memory leak in reset_control_array_put()

Xiaojun Sang <xsang@codeaurora.org>
    ASoC: compress: fix unsigned integer overflow check

Stephan Gerhold <stephan@gerhold.net>
    ASoC: msm8916-wcd-analog: Fix RX1 selection in RDAC2 MUX

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: gxbb: let sar_adc_clk_div set the parent clock rate


-------------

Diffstat:

 Documentation/hid/uhid.txt                         |   2 +-
 Makefile                                           |   4 +-
 arch/arm/Kconfig.debug                             |  28 +-
 arch/arm/boot/dts/gemini-sq201.dts                 |  37 +-
 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi        |   8 +-
 arch/arm/mach-ks8695/board-acs5k.c                 |   2 +-
 arch/arm/mach-omap1/Makefile                       |   2 +-
 arch/arm/mach-omap1/include/mach/usb.h             |   2 +-
 arch/arm64/kernel/head.S                           |  26 ++
 arch/arm64/kernel/smp.c                            |   6 +
 arch/microblaze/Makefile                           |  12 +-
 arch/microblaze/boot/Makefile                      |   4 -
 arch/openrisc/kernel/entry.S                       |   2 +-
 arch/openrisc/kernel/head.S                        |   2 +-
 arch/powerpc/boot/dts/bamboo.dts                   |   4 +-
 arch/powerpc/include/asm/cputable.h                |   1 +
 arch/powerpc/include/asm/reg.h                     |   2 +
 arch/powerpc/kernel/cputable.c                     |  10 +-
 arch/powerpc/kernel/prom.c                         |   6 +-
 arch/powerpc/mm/fault.c                            |  17 +-
 arch/powerpc/mm/ppc_mmu_32.c                       |   4 +-
 arch/powerpc/perf/isa207-common.c                  |  25 +-
 arch/powerpc/perf/isa207-common.h                  |   4 +-
 arch/powerpc/platforms/83xx/misc.c                 |  17 +
 arch/powerpc/platforms/powernv/eeh-powernv.c       |   8 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   4 +-
 arch/powerpc/platforms/powernv/pci.c               |   4 +-
 arch/powerpc/platforms/pseries/dlpar.c             |   4 +
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   1 +
 arch/powerpc/xmon/xmon.c                           |   2 +-
 arch/s390/kvm/kvm-s390.c                           |  17 +-
 arch/s390/mm/gup.c                                 |   9 +-
 arch/um/Kconfig.debug                              |   1 +
 arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c        |   4 +
 arch/x86/kvm/vmx.c                                 |   6 +-
 arch/x86/xen/xen-asm_64.S                          |   2 +
 crypto/crypto_user.c                               |  37 +-
 drivers/acpi/acpi_lpss.c                           |   7 +-
 drivers/acpi/apei/ghes.c                           |  32 +-
 drivers/base/platform.c                            |   3 +
 drivers/block/drbd/drbd_main.c                     |   1 -
 drivers/block/drbd/drbd_nl.c                       |  43 +-
 drivers/block/drbd/drbd_receiver.c                 |  52 ++-
 drivers/block/drbd/drbd_state.h                    |   2 +-
 drivers/bluetooth/hci_bcm.c                        |  22 +
 drivers/char/hw_random/stm32-rng.c                 |   8 +
 drivers/clk/at91/clk-generated.c                   |  28 +-
 drivers/clk/at91/clk-main.c                        |   7 +-
 drivers/clk/at91/sckc.c                            |  20 +-
 drivers/clk/meson/gxbb.c                           |   1 +
 drivers/clk/samsung/clk-exynos5420.c               |   6 +
 drivers/clk/sunxi-ng/ccu-sun9i-a80.c               |   2 +-
 drivers/clk/ti/clk-dra7-atl.c                      |   6 -
 drivers/clocksource/timer-fttmr010.c               |  73 +--
 drivers/crypto/mxc-scc.c                           |  12 +-
 drivers/crypto/stm32/stm32-hash.c                  |   2 +-
 drivers/gpu/ipu-v3/ipu-pre.c                       |   6 +
 drivers/hid/hid-core.c                             |  51 +-
 drivers/hid/intel-ish-hid/ishtp-hid.c              |   2 +-
 drivers/infiniband/hw/qib/qib_sdma.c               |   4 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c    |   2 +-
 drivers/infiniband/sw/rxe/rxe_hw_counters.c        |   2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |   6 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   1 +
 drivers/input/serio/gscps2.c                       |   4 +-
 drivers/input/serio/hp_sdc.c                       |   4 +-
 drivers/iommu/amd_iommu.c                          |   8 +-
 drivers/mailbox/mailbox-test.c                     |  14 +-
 drivers/md/dm-flakey.c                             |  33 +-
 drivers/media/platform/atmel/atmel-isc.c           |  12 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |  17 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |   1 +
 drivers/misc/mei/bus.c                             |   9 +-
 drivers/mmc/host/meson-gx-mmc.c                    |  73 ++-
 drivers/mtd/mtdcore.h                              |   2 +-
 drivers/mtd/mtdpart.c                              |  35 +-
 drivers/mtd/nand/atmel/nand-controller.c           |   2 +-
 drivers/mtd/nand/atmel/pmecc.c                     |  21 +-
 drivers/mtd/nand/sunxi_nand.c                      |   2 +-
 drivers/mtd/spi-nor/spi-nor.c                      |   2 +-
 drivers/mtd/ubi/build.c                            |   2 +-
 drivers/mtd/ubi/kapi.c                             |   2 +-
 drivers/net/can/c_can/c_can.c                      |  26 ++
 drivers/net/can/rx-offload.c                       |  96 +++-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  15 +-
 drivers/net/dsa/bcm_sf2.c                          |   7 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  78 +++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   5 +-
 drivers/net/ethernet/cadence/macb.h                |   6 +-
 drivers/net/ethernet/cadence/macb_main.c           |  18 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |   5 +-
 drivers/net/ethernet/freescale/fec_main.c          |  13 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   8 +-
 drivers/net/ethernet/sfc/ef10.c                    |  29 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  |   4 +-
 drivers/net/ethernet/ti/cpts.c                     |   4 +-
 drivers/net/macvlan.c                              |   3 +-
 drivers/net/slip/slip.c                            |   1 +
 drivers/net/vxlan.c                                |  13 +-
 drivers/net/wan/fsl_ucc_hdlc.c                     |   1 -
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |  17 +
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  |  19 -
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   4 +-
 drivers/net/wireless/marvell/mwifiex/debugfs.c     |  14 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |  18 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |   3 +-
 drivers/pci/msi.c                                  |  22 +-
 drivers/pinctrl/pinctrl-xway.c                     |  39 +-
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                |   9 +-
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                |  16 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |  26 +-
 drivers/platform/x86/hp-wmi.c                      |  10 +-
 drivers/power/avs/smartreflex.c                    |   3 +-
 drivers/pwm/core.c                                 |   1 +
 drivers/pwm/pwm-bcm-iproc.c                        |   1 +
 drivers/pwm/pwm-berlin.c                           |   1 -
 drivers/pwm/pwm-clps711x.c                         |   4 +-
 drivers/pwm/pwm-pca9685.c                          |   1 -
 drivers/pwm/pwm-samsung.c                          |   1 -
 drivers/regulator/palmas-regulator.c               |   5 +-
 drivers/regulator/tps65910-regulator.c             |   4 +-
 drivers/reset/core.c                               |   1 +
 drivers/scsi/csiostor/csio_init.c                  |   2 +-
 drivers/scsi/libsas/sas_expander.c                 |  29 +-
 drivers/scsi/lpfc/lpfc.h                           |   6 +
 drivers/scsi/lpfc/lpfc_attr.c                      |   4 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |   6 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   4 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   7 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  18 +
 drivers/scsi/lpfc/lpfc_sli.c                       |   2 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |  48 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.h                 |   3 -
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   5 +-
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |   7 +-
 drivers/tty/serial/8250/8250_core.c                |  26 ++
 drivers/tty/serial/8250/8250_fsl.c                 |  23 +-
 drivers/tty/serial/8250/8250_of.c                  |   5 +
 drivers/tty/serial/max310x.c                       |   7 +-
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   7 +
 drivers/vfio/vfio_iommu_spapr_tce.c                |  10 +-
 drivers/watchdog/meson_gxbb_wdt.c                  |   4 +-
 drivers/watchdog/sama5d4_wdt.c                     |   4 +-
 drivers/xen/xen-pciback/pci_stub.c                 |   3 +-
 fs/btrfs/delayed-ref.c                             |   3 -
 fs/ceph/super.c                                    |  11 +-
 fs/exec.c                                          |   2 +-
 fs/exofs/super.c                                   |  37 +-
 fs/ext4/inode.c                                    |  15 +
 fs/ext4/super.c                                    |  21 +-
 fs/f2fs/file.c                                     |   2 +-
 fs/gfs2/bmap.c                                     |   2 +
 fs/ocfs2/journal.c                                 |   6 +-
 fs/xfs/xfs_ioctl32.c                               |  40 +-
 fs/xfs/xfs_rtalloc.c                               |   4 +-
 include/linux/blktrace_api.h                       |   8 +-
 include/linux/compat.h                             |   2 -
 include/linux/futex.h                              |  44 +-
 include/linux/genalloc.h                           |  13 +-
 include/linux/gpio/consumer.h                      |   2 +-
 include/linux/netdevice.h                          |   2 +-
 include/linux/reset-controller.h                   |   2 +-
 include/linux/sched.h                              |   3 +-
 include/linux/sched/mm.h                           |   6 +-
 include/linux/sched/task.h                         |   2 +
 include/linux/serial_8250.h                        |   4 +
 include/linux/swap.h                               |   6 -
 include/net/sctp/structs.h                         |   3 +
 include/net/sock.h                                 |   2 +-
 init/main.c                                        |   1 -
 kernel/Makefile                                    |   3 -
 kernel/bpf/syscall.c                               |   6 +-
 kernel/exit.c                                      |  30 +-
 kernel/fork.c                                      |  45 +-
 kernel/futex.c                                     | 511 +++++++++++++++++++--
 kernel/futex_compat.c                              | 202 --------
 lib/genalloc.c                                     |  25 +-
 lib/radix-tree.c                                   |   2 +-
 mm/internal.h                                      |  10 +
 net/bridge/netfilter/ebt_dnat.c                    |  19 +-
 net/core/neighbour.c                               |  13 +-
 net/core/net_namespace.c                           |   3 +-
 net/core/sock.c                                    |   2 +-
 net/decnet/dn_dev.c                                |   2 +-
 net/ipv4/ip_tunnel.c                               |   8 +-
 net/mac80211/sta_info.c                            |   3 +-
 net/openvswitch/datapath.c                         |  17 +-
 net/psample/psample.c                              |   2 +-
 net/sched/sch_mq.c                                 |   3 +-
 net/sched/sch_mqprio.c                             |   4 +-
 net/sched/sch_multiq.c                             |   2 +-
 net/sched/sch_prio.c                               |   2 +-
 net/sctp/associola.c                               |   1 +
 net/sctp/endpointola.c                             |   1 +
 net/sctp/input.c                                   |   4 +-
 net/sctp/transport.c                               |   3 +-
 net/smc/smc_core.c                                 |   4 +
 net/tipc/link.c                                    |   2 +-
 net/tipc/netlink_compat.c                          |  15 +-
 net/vmw_vsock/af_vsock.c                           |   7 +-
 net/xfrm/xfrm_state.c                              |   2 +
 samples/vfio-mdev/mtty.c                           |  26 +-
 scripts/gdb/linux/symbols.py                       |   3 +-
 security/apparmor/apparmorfs.c                     |   1 +
 sound/core/compress_offload.c                      |   2 +-
 sound/soc/codecs/msm8916-wcd-analog.c              |   4 +-
 sound/soc/kirkwood/kirkwood-i2s.c                  |   8 +-
 sound/soc/stm/stm32_i2s.c                          |  29 +-
 virt/kvm/kvm_main.c                                |   2 +-
 216 files changed, 2019 insertions(+), 1025 deletions(-)


