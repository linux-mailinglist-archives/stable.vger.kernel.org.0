Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C0C111F4C
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbfLCWrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:47:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729156AbfLCWrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:47:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17E7320656;
        Tue,  3 Dec 2019 22:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413226;
        bh=nh/XXXBm8+0siNaFoGgFQ8gce6d7cQzmZaJ0a33uaDs=;
        h=From:To:Cc:Subject:Date:From;
        b=axeqqBU8m60BC1dW3D1pebhOGd3Hj87WLXdTeJqPviyzVMX33hDO/M7Bd9kHXZ3Yl
         xxX0+Te8oSfqas8z0lzikmz1L/5Olxu6ViQIp6Ltvsqjmlw/BW0UKIxQPA5r1C0Gup
         g5n27y0WA2z4Gu8KmqDzLpUS5WdEj8/4ELTiGKWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/321] 4.19.88-stable review
Date:   Tue,  3 Dec 2019 23:31:06 +0100
Message-Id: <20191203223427.103571230@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.88-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.88-rc1
X-KernelTest-Deadline: 2019-12-05T22:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.88 release.
There are 321 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 05 Dec 2019 22:30:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.88-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.88-rc1

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Fix ACPI errors caused by passing 0 as input size

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer

Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
    dmaengine: stm32-dma: check whether length is aligned on FIFO threshold

Wen Yang <yellowriver2010@hotmail.com>
    ASoC: stm32: sai: add missing put_device()

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

Gabriel Fernandez <gabriel.fernandez@st.com>
    clk: stm32mp1: parent clocks update

Gabriel Fernandez <gabriel.fernandez@st.com>
    clk: stm32mp1: add CLK_SET_RATE_NO_REPARENT to Kernel clocks

Gabriel Fernandez <gabriel.fernandez@st.com>
    clk: stm32mp1: fix mcu divider table

Gabriel Fernandez <gabriel.fernandez@st.com>
    clk: stm32mp1: fix HSI divider flag

Lionel Debieve <lionel.debieve@st.com>
    hwrng: stm32 - fix unbalanced pm_runtime_enable

Hugues Fruchet <hugues.fruchet@st.com>
    media: stm32-dcmi: fix check of pm_runtime_get_sync return value

Hugues Fruchet <hugues.fruchet@st.com>
    media: stm32-dcmi: fix DMA corruption when stopping streaming

Lionel Debieve <lionel.debieve@st.com>
    crypto: stm32/hash - Fix hmac issue more than 256 bytes

Candle Sun <candle.sun@unisoc.com>
    HID: core: check whether Usage Page item is after Usage ID items

Yuchung Cheng <ycheng@google.com>
    tcp: exit if nothing to retransmit on RTO timeout

Arnaud Pouliquen <arnaud.pouliquen@st.com>
    mailbox: stm32_ipcc: add spinlock to fix channels concurrent access

Claudiu Beznea <claudiu.beznea@microchip.com>
    drm/atmel-hlcdc: revert shift by 8

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

Chuhong Yuan <hslester96@gmail.com>
    net: macb: add missed tasklet_kill

Dust Li <dust.li@linux.alibaba.com>
    net: sched: fix `tc -s class show` no bstats on class with nolock subqueues

Xin Long <lucien.xin@gmail.com>
    sctp: cache netns in sctp_ep_common

John Rutherford <john.rutherford@dektech.com.au>
    tipc: fix link name length check

Jakub Kicinski <jakub.kicinski@netronome.com>
    selftests: bpf: test_sockmap: handle file creation failures gracefully

Paolo Abeni <pabeni@redhat.com>
    openvswitch: remove another BUG_ON()

Paolo Abeni <pabeni@redhat.com>
    openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()

Jouni Hogander <jouni.hogander@unikie.com>
    slip: Fix use-after-free Read in slip_open

Navid Emamdoost <navid.emamdoost@gmail.com>
    sctp: Fix memory leak in sctp_sf_do_5_2_4_dupcook

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

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Power cycle the router if NVM authentication fails

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add comet point V device id

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

Mathias Kresin <dev@kresin.me>
    usb: dwc2: use a longer core rest timeout in dwc2_core_reset()

Alexandre Belloni <alexandre.belloni@bootlin.com>
    clk: at91: generated: set audio_pll_allowed in at91_clk_register_generated()

Eugen Hristev <eugen.hristev@microchip.com>
    clk: at91: fix update bit maps on CFG_MOR write

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: assimilate nested_vmx_entry_failure() into nested_vmx_enter_non_root_mode()

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: rename enter_vmx_non_root_mode to nested_vmx_enter_non_root_mode

Vlastimil Babka <vbabka@suse.cz>
    mm, gup: add missing refcount overflow checks on s390

Boris Brezillon <bbrezillon@kernel.org>
    mtd: Remove a debug trace in mtdpart.c

Jesper Dangaard Brouer <brouer@redhat.com>
    xdp: fix cpumap redirect SKB creation bug

Gen Zhang <blackgod016574@gmail.com>
    powerpc/pseries/dlpar: Fix a missing check in dlpar_parse_cc_property()

Hui Wang <hui.wang@canonical.com>
    ASoC: rt5645: Headphone Jack sense inverts on the LattePanda board

YueHaibing <yuehaibing@huawei.com>
    RDMA/hns: Use GFP_ATOMIC in hns_roce_v2_modify_qp

Yixian Liu <liuyixian@huawei.com>
    RDMA/hns: Fix the state of rereg mr

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Bugfix for the scene without receiver queue

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Fix the bug with updating rq head pointer when flush cqe

John Garry <john.garry@huawei.com>
    scsi: libsas: Check SMP PHY control function result

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: hisi_sas: shutdown axi bus to avoid exception CQ returned

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

Peng Li <lipeng321@huawei.com>
    net: hns3: fix an issue for hns3_update_new_int_gl

Peng Li <lipeng321@huawei.com>
    net: hns3: fix an issue for hclgevf_ae_get_hdev

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: fix PFC not setting problem for DCB module

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: Change fw error code NOT_EXEC to NOT_SUPPORTED

Peng Sun <sironhide0null@gmail.com>
    bpf: drop refcount if bpf_map_new_fd() fails in map_create()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kvm: properly check debugfs dentry before using it

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    net: dev: Use unsigned integer as an argument to left-shift

Ming Lei <ming.lei@redhat.com>
    mmc: core: align max segment size with logical block size

Peng Sun <sironhide0null@gmail.com>
    bpf: decrease usercnt if bpf_map_new_fd() fails in bpf_map_get_fd_by_id()

Maciej Kwiecien <maciej.kwiecien@nokia.com>
    sctp: don't compare hb_timer expire date before starting it

Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
    net: ip6_gre: do not report erspan_ver for ip6gre or ip6gretap

Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
    net: ip_gre: do not report erspan_ver for gre or gretap

Eric Dumazet <edumazet@google.com>
    net: fix possible overflow in __sk_mem_raise_allocated()

Matteo Croce <mcroce@redhat.com>
    geneve: change NET_UDP_TUNNEL dependency to select

Bert Kenward <bkenward@solarflare.com>
    sfc: initialise found bitmap in efx_ef10_mtd_probe

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ASoC: samsung: i2s: Fix prescaler setting for the secondary DAI

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix skb may be leaky in tipc_link_input

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: fix byte_order for rx_curs_confirmed

Jan Kara <jack@suse.cz>
    blktrace: Show requests without sector

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: fix sender_free computation

Brian Foster <bfoster@redhat.com>
    xfs: end sync buffer I/O properly on shutdown error

Qian Cai <cai@lca.pw>
    mm/hotplug: invalid PFNs from pfn_to_online_page()

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: don't wait for send buffer space when data was already sent

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

Miquel Raynal <miquel.raynal@bootlin.com>
    ata: ahci: mvebu: do Armada 38x configuration only on relevant SoCs

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

James Morse <james.morse@arm.com>
    firmware: arm_sdei: Fix DT platform device creation

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    firmware: arm_sdei: fix wrong of_node_put() in init function

Aditya Pakki <pakki001@umn.edu>
    infiniband/qedr: Potential null ptr dereference of qp

Aditya Pakki <pakki001@umn.edu>
    infiniband: bnxt_re: qplib: Check the return value of send_message

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Prevent leak of rpcrdma_rep objects

Kangjie Lu <kjlu@umn.edu>
    netfilter: nf_tables: fix a missing check of nla_put_failure

Anthony Yznaga <anthony.yznaga@oracle.com>
    tools/vm/page-types.c: fix "kpagecount returned fewer pages than expected" failures

Wentao Wang <witallwang@gmail.com>
    mm/page_alloc.c: deduplicate __memblock_free_early() and memblock_free()

Aaron Lu <aaron.lu@intel.com>
    mm/page_alloc.c: use a single function to free page

Aaron Lu <aaron.lu@intel.com>
    mm/page_alloc.c: free order-0 pages through PCP in page_frag_free()

Wei Yang <richard.weiyang@gmail.com>
    vmscan: return NODE_RECLAIM_NOSCAN in node_reclaim() when CONFIG_NUMA is n

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: clear journal dirty flag after shutdown journal

Wen Yang <wen.yang99@zte.com.cn>
    net/wan/fsl_ucc_hdlc: Avoid double free in ucc_hdlc_probe()

Kangjie Lu <kjlu@umn.edu>
    net: marvell: fix a missing check of acpi_match_device

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

Richard Weinberger <richard@nod.at>
    um: Include sys/uio.h to have writev()

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to dirty inode synchronously

Qiuyang Sun <sunqiuyang@huawei.com>
    f2fs: fix block address for __check_sit_bitmap

Aditya Pakki <pakki001@umn.edu>
    net/net_namespace: Check the return value of register_pernet_subsys()

Aditya Pakki <pakki001@umn.edu>
    net/netlink_compat: Fix a missing check of nla_parse_nested

Alexander Shiyan <shc_work@mail.ru>
    pwm: clps711x: Fix period calculation

Fabio Estevam <festevam@gmail.com>
    crypto: mxc-scc - fix build warnings on ARM64

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc: Fix HMIs on big-endian with CONFIG_RELOCATABLE=y

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Fix node leak in update_lmb_associativity_index()

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/83xx: handle machine check caused by watchdog timer

Kangjie Lu <kjlu@umn.edu>
    regulator: tps65910: fix a missing check of return value

Jesper Dangaard Brouer <brouer@redhat.com>
    bpf/cpumap: make sure frame_size for build_skb is aligned if headroom isn't

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

Joel Stanley <joel@jms.id.au>
    powerpc/32: Avoid unsupported flags with clang

Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
    powerpc/perf: Fix unit_sel/cache_sel checks

Kyle Roeschley <kyle.roeschley@ni.com>
    ath6kl: Fix off by one error in scan completion

Kyle Roeschley <kyle.roeschley@ni.com>
    ath6kl: Only use match sets when firmware supports it

Stefan Wahren <stefan.wahren@i2se.com>
    brcmfmac: Fix access point mode

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

Heinz Mauelshagen <heinzm@redhat.com>
    dm raid: fix false -EBUSY when handling check/repair message

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

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a77990: Fix MOD_SEL0 SEL_I2C1 field width

Michael Mueller <mimu@linux.ibm.com>
    KVM: s390: unregister debug feature on failing arch init

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: query force speeds before disabling autoneg mode.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Save ring statistics before reset.

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Return linux standard errors in bnxt_ethtool.c

Al Viro <viro@zeniv.linux.org.uk>
    exofs_mount(): fix leaks on failure exits

Alin Nastac <alin.nastac@gmail.com>
    netfilter: nf_nat_sip: fix RTP/RTCP source port translations

Leon Romanovsky <leon@kernel.org>
    net/mlx5: Continue driver initialization despite debugfs failure

Martin Schiller <ms@dev.tdt.de>
    pinctrl: xway: fix gpio-hog related boot issues

Linus Walleij <linus.walleij@linaro.org>
    memory: omap-gpmc: Get the header of the enum

Nathan Chancellor <natechancellor@gmail.com>
    vfio-mdev/samples: Use u8 instead of char for handle functions

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes/x86: Show x86-64 specific blacklisted symbols correctly

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Blacklist symbols in arch-defined prohibited area

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen/pciback: Check dev_data before using it

Andrea Righi <righi.andrea@gmail.com>
    kprobes/x86/xen: blacklist non-attachable xen interrupt functions

Darwin Dingel <darwin.dingel@alliedtelesis.co.nz>
    serial: 8250: Rate limit serial port rx interrupts during input overruns

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    gpio: raspberrypi-exp: decrease refcount on firmware dt node

Pan Bian <bianpan2016@163.com>
    HID: intel-ish-hid: fixes incorrect error handling

Geert Uytterhoeven <geert+renesas@glider.be>
    serial: sh-sci: Fix crash in rx_timer_fn() on PIO fallback

Josef Bacik <jbacik@fb.com>
    btrfs: only track ref_heads in delayed_ref_updates

Filipe Manana <fdmanana@suse.com>
    Btrfs: allow clear_extent_dirty() to receive a cached extent state record

Anand Jain <anand.jain@oracle.com>
    btrfs: dev-replace: set result code of cancel by status of scrub

Hans van Kranenburg <hans.van.kranenburg@mendix.com>
    btrfs: fix ncopies raid_attr for RAID56

Nikolay Borisov <nborisov@suse.com>
    btrfs: Check for missing device before bio submission in btrfs_map_bio

Roger Quadros <rogerq@ti.com>
    usb: ehci-omap: Fix deferred probe for phy handling

Boris Brezillon <boris.brezillon@bootlin.com>
    mtd: rawnand: sunxi: Write pageprog related opcodes to WCMD_SET

Jerome Brunet <jbrunet@baylibre.com>
    mmc: meson-gx: make sure the descriptor is stopped on errors

Lepton Wu <ytht.net@gmail.com>
    VSOCK: bind to random port for VMADDR_PORT_ANY

Atul Gupta <atul.gupta@chelsio.com>
    crypto/chelsio/chtls: listen fails with multiadapt

Jim Mattson <jmattson@google.com>
    kvm: vmx: Set IA32_TSC_AUX for legacy mode guests

Krzysztof Kozlowski <krzk@kernel.org>
    gpiolib: Fix return value of gpio_to_desc() stub if !GPIOLIB

Marek Vasut <marek.vasut@gmail.com>
    gpio: pca953x: Fix AI overflow on PCAL6524

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: pcie: set cmd_len in the correct place

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: pcie: fix erroneous print

Avraham Stern <avraham.stern@intel.com>
    iwlwifi: mvm: force TCM re-evaluation on TCM resume

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: move iwl_nvm_check_version() into dvm

Masahiro Yamada <yamada.masahiro@socionext.com>
    microblaze: fix multiple bugs in arch/microblaze/boot/Makefile

Masahiro Yamada <yamada.masahiro@socionext.com>
    microblaze: move "... is ready" messages to arch/microblaze/Makefile

Masahiro Yamada <yamada.masahiro@socionext.com>
    microblaze: adjust the help to the real behavior

Pan Bian <bianpan2016@163.com>
    ubi: Do not drop UBI device reference before using

Pan Bian <bianpan2016@163.com>
    ubi: Put MTD device after it is not used

Gabor Juhos <juhosg@openwrt.org>
    ubifs: Fix default compression selection in ubifs

Sagi Grimberg <sagi@grimberg.me>
    nvme: fix kernel paging oops

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: require both realtime inodes to mount

Shenghui Wang <shhuiw@foxmail.com>
    bcache: do not mark writeback_running too early

Shenghui Wang <shhuiw@foxmail.com>
    bcache: do not check if debug dentry is ERR or NULL explicitly on remove

Pan Bian <bianpan2016@163.com>
    rtl818x: fix potential use after free

Madhan Mohan R <MadhanMohan.R@cypress.com>
    brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373

Wright Feng <wright.feng@cypress.com>
    brcmfmac: set F2 watermark to 256 for 4373

Brian Norris <briannorris@chromium.org>
    mwifiex: debugfs: correct histogram spacing, formatting

Pan Bian <bianpan2016@163.com>
    mwifiex: fix potential NULL dereference and use after free

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    arm64: dts: renesas: draak: Fix CVBS input

Eric Biggers <ebiggers@google.com>
    crypto: user - support incremental algorithm dumps

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: make sysfs reset attribute trigger queue reset

Jens Axboe <axboe@kernel.dk>
    nvme: provide fallback for discard alloc failure

Giridhar Malavali <gmalavali@marvell.com>
    scsi: qla2xxx: Fix for FC-NVMe discovery for NPIV port

Himanshu Madhani <hmadhani@marvell.com>
    scsi: qla2xxx: Fix NPIV handling for FC-NVMe

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Enable Management features for IF_TYPE=6

Hans de Goede <hdegoede@redhat.com>
    ACPI / LPSS: Ignore acpi_device_fix_up_power() return value

Arnd Bergmann <arnd@arndb.de>
    ARM: ks8695: fix section mismatch warning

Dave Chinner <dchinner@redhat.com>
    xfs: zero length symlinks are not valid

Thomas Meyer <thomas@m3y3r.de>
    PM / AVS: SmartReflex: NULL check before some freeing functions is not needed

Gal Pressman <galpress@amazon.com>
    RDMA/vmw_pvrdma: Use atomic memory allocation in create AH

Will Deacon <will.deacon@arm.com>
    arm64: preempt: Fix big-endian when checking preempt count in assembly

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Fix the bug while use multi-hop of pbl

Aaro Koskinen <aaro.koskinen@iki.fi>
    ARM: OMAP1: fix USB configuration for device-only setups

Vadim Pasternak <vadimp@mellanox.com>
    platform/x86: mlx-platform: Fix LED configuration

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Check for no-reset and no-idle flags at the child level

Suzuki K Poulose <Suzuki.Poulose@arm.com>
    arm64: smp: Handle errors reported by the firmware

Steve Capper <steve.capper@arm.com>
    arm64: mm: Prevent mismatched 52-bit VA support

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix hsi gdd range for omap4

Helge Deller <deller@gmx.de>
    parisc: Fix HP SDC hpa address output

Helge Deller <deller@gmx.de>
    parisc: Fix serio address output

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx53-voipac-dmm-668: Fix memory node duplication

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx25: Fix memory node duplication

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx27: Fix memory node duplication

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx1: Fix memory node duplication

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx23: Fix memory node duplication

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx50: Fix memory node duplication

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6sl: Fix memory node duplication

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6sx: Fix memory node duplication

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6ul: Fix memory node duplication

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx7: Fix memory node duplication

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx35: Fix memory node duplication

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx31: Fix memory node duplication

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx53: Fix memory node duplication

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx51: Fix memory node duplication

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    ARM: debug-imx: only define DEBUG_IMX_UART_PORT if needed

Masami Hiramatsu <mhiramat@kernel.org>
    tracing: Lock event_mutex before synth_event_mutex

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: Fix up SQ201 flash access

Ding Tao <miyatsu@qq.com>
    arm64: dts: marvell: armada-37xx: Enable emmc on espressobin

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix dif and first burst use in write commands

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix kernel Oops due to null pring pointers

Bart Van Assche <bvanassche@acm.org>
    scsi: target/tcmu: Fix queue_cmd_ring() declaration

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: bcm-iproc: Prevent unloading the driver module while in use

Dan Carpenter <dan.carpenter@oracle.com>
    block: drbd: remove a stray unlock in __drbd_send_protocol()

Ahmed Zaki <anzaki@gmail.com>
    mac80211: fix station inactive_time shortly after boot

Toke Høiland-Jørgensen <toke@redhat.com>
    net/fq_impl: Switch to kvmalloc() for memory allocation

Jeff Layton <jlayton@kernel.org>
    ceph: return -EINVAL if given fsc mount option on kernel w/o support

Vladimir Oltean <olteanv@gmail.com>
    net: mscc: ocelot: fix __ocelot_rmw_ix prototype

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: reapply manual settings to the PHY

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: use RGMII loopback for MAC reset

Ilya Leoshkevich <iii@linux.ibm.com>
    scripts/gdb: fix debugging modules compiled with hot/cold partitioning

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: sai: add restriction on mmap support

Xingyu Chen <xingyu.chen@amlogic.com>
    watchdog: meson: Fix the wrong value of left time

Timo Schlüßler <schluessler@krause.de>
    can: mcp251x: mcp251x_restart_work_handler(): Fix potential force_quit race condition

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: increase error counters if skb enqueueing via can_rx_offload_queue_sorted() fails

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

Tony Lindgren <tony@atomide.com>
    clk: ti: clkctrl: Fix failed to enable error with double udelay timeout

Peter Ujfalusi <peter.ujfalusi@ti.com>
    clk: ti: dra7-atl-clock: Remove ti_clk_add_alias call

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Prevent NULL pointer dereference when reading mondata

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr: Fix idr_alloc_u32 on 32-bit systems

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr: Fix integer overflow in idr_for_each_entry

Eric Dumazet <edumazet@google.com>
    powerpc/bpf: Fix tail call implementation

Björn Töpel <bjorn.topel@intel.com>
    samples/bpf: fix build by setting HAVE_ATTR_TEST to zero

Ondrej Jirman <megous@megous.com>
    ARM: dts: sun8i-a83t-tbs-a711: Fix WiFi resume from suspend

Colin Ian King <colin.king@canonical.com>
    clk: sunxi-ng: a80: fix the zero'ing of bits 16 and 18

Nathan Chancellor <natechancellor@gmail.com>
    clk: sunxi: Fix operator precedence in sunxi_divs_clk_setup

Alexandre Belloni <alexandre.belloni@bootlin.com>
    clk: at91: avoid sleeping early

Randy Dunlap <rdunlap@infradead.org>
    reset: fix reset_control_ops kerneldoc comment

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6qdl-sabreauto: Fix storm of accelerometer interrupts

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: cherryview: Allocate IRQ chip dynamic

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos5420: Preserve PLL configuration during suspend/resume

Russell King <rmk+kernel@armlinux.org.uk>
    ASoC: kirkwood: fix device remove ordering

Russell King <rmk+kernel@armlinux.org.uk>
    ASoC: kirkwood: fix external clock probe defer

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos5433: Fix error paths

Kishon Vijay Abraham I <kishon@ti.com>
    reset: Fix memory leak in reset_control_array_put()

Xiaojun Sang <xsang@codeaurora.org>
    ASoC: compress: fix unsigned integer overflow check

Stephan Gerhold <stephan@gerhold.net>
    ASoC: msm8916-wcd-analog: Fix RX1 selection in RDAC2 MUX

Fabien Parent <fparent@baylibre.com>
    clocksource/drivers/mediatek: Fix error handling

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: gxbb: let sar_adc_clk_div set the parent clock rate


-------------

Diffstat:

 Documentation/hid/uhid.txt                         |  2 +-
 Makefile                                           |  4 +-
 arch/arm/Kconfig.debug                             | 28 +++----
 arch/arm/boot/dts/gemini-sq201.dts                 | 37 ++-------
 arch/arm/boot/dts/imx1-ads.dts                     |  1 +
 arch/arm/boot/dts/imx1-apf9328.dts                 |  1 +
 arch/arm/boot/dts/imx1.dtsi                        |  2 -
 arch/arm/boot/dts/imx23-evk.dts                    |  1 +
 arch/arm/boot/dts/imx23-olinuxino.dts              |  1 +
 arch/arm/boot/dts/imx23-sansa.dts                  |  1 +
 arch/arm/boot/dts/imx23-stmp378x_devb.dts          |  1 +
 arch/arm/boot/dts/imx23-xfi3.dts                   |  1 +
 arch/arm/boot/dts/imx23.dtsi                       |  2 -
 arch/arm/boot/dts/imx25-eukrea-cpuimx25.dtsi       |  1 +
 arch/arm/boot/dts/imx25-karo-tx25.dts              |  1 +
 arch/arm/boot/dts/imx25-pdk.dts                    |  1 +
 arch/arm/boot/dts/imx25.dtsi                       |  2 -
 arch/arm/boot/dts/imx27-apf27.dts                  |  1 +
 arch/arm/boot/dts/imx27-eukrea-cpuimx27.dtsi       |  1 +
 arch/arm/boot/dts/imx27-pdk.dts                    |  1 +
 arch/arm/boot/dts/imx27-phytec-phycard-s-som.dtsi  |  1 +
 arch/arm/boot/dts/imx27-phytec-phycore-som.dtsi    |  1 +
 arch/arm/boot/dts/imx27.dtsi                       |  2 -
 arch/arm/boot/dts/imx31-bug.dts                    |  1 +
 arch/arm/boot/dts/imx31-lite.dts                   |  1 +
 arch/arm/boot/dts/imx31.dtsi                       |  2 -
 arch/arm/boot/dts/imx35-eukrea-cpuimx35.dtsi       |  1 +
 arch/arm/boot/dts/imx35-pdk.dts                    |  1 +
 arch/arm/boot/dts/imx35.dtsi                       |  2 -
 arch/arm/boot/dts/imx50-evk.dts                    |  1 +
 arch/arm/boot/dts/imx50.dtsi                       |  2 -
 arch/arm/boot/dts/imx51-apf51.dts                  |  1 +
 arch/arm/boot/dts/imx51-babbage.dts                |  1 +
 arch/arm/boot/dts/imx51-digi-connectcore-som.dtsi  |  1 +
 arch/arm/boot/dts/imx51-eukrea-cpuimx51.dtsi       |  1 +
 arch/arm/boot/dts/imx51-ts4800.dts                 |  1 +
 arch/arm/boot/dts/imx51-zii-rdu1.dts               |  1 +
 arch/arm/boot/dts/imx51-zii-scu2-mezz.dts          |  1 +
 arch/arm/boot/dts/imx51-zii-scu3-esb.dts           |  1 +
 arch/arm/boot/dts/imx51.dtsi                       |  2 -
 arch/arm/boot/dts/imx53-ard.dts                    |  1 +
 arch/arm/boot/dts/imx53-cx9020.dts                 |  1 +
 arch/arm/boot/dts/imx53-m53.dtsi                   |  1 +
 arch/arm/boot/dts/imx53-qsb-common.dtsi            |  1 +
 arch/arm/boot/dts/imx53-smd.dts                    |  1 +
 arch/arm/boot/dts/imx53-tqma53.dtsi                |  1 +
 arch/arm/boot/dts/imx53-tx53.dtsi                  |  1 +
 arch/arm/boot/dts/imx53-usbarmory.dts              |  1 +
 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi        |  8 +-
 arch/arm/boot/dts/imx53.dtsi                       |  2 -
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |  8 ++
 arch/arm/boot/dts/imx6sl-evk.dts                   |  1 +
 arch/arm/boot/dts/imx6sl-warp.dts                  |  1 +
 arch/arm/boot/dts/imx6sl.dtsi                      |  2 -
 arch/arm/boot/dts/imx6sll-evk.dts                  |  1 +
 arch/arm/boot/dts/imx6sx-nitrogen6sx.dts           |  1 +
 arch/arm/boot/dts/imx6sx-sabreauto.dts             |  1 +
 arch/arm/boot/dts/imx6sx-sdb.dtsi                  |  1 +
 arch/arm/boot/dts/imx6sx-softing-vining-2000.dts   |  1 +
 arch/arm/boot/dts/imx6sx-udoo-neo-basic.dts        |  1 +
 arch/arm/boot/dts/imx6sx-udoo-neo-extended.dts     |  1 +
 arch/arm/boot/dts/imx6sx-udoo-neo-full.dts         |  1 +
 arch/arm/boot/dts/imx6sx.dtsi                      |  2 -
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi            |  1 +
 arch/arm/boot/dts/imx6ul-geam.dts                  |  1 +
 arch/arm/boot/dts/imx6ul-isiot.dtsi                |  1 +
 arch/arm/boot/dts/imx6ul-litesom.dtsi              |  1 +
 arch/arm/boot/dts/imx6ul-opos6ul.dtsi              |  1 +
 arch/arm/boot/dts/imx6ul-pico-hobbit.dts           |  1 +
 arch/arm/boot/dts/imx6ul-tx6ul.dtsi                |  1 +
 arch/arm/boot/dts/imx6ul.dtsi                      |  2 -
 arch/arm/boot/dts/imx6ull-colibri-nonwifi.dtsi     |  1 +
 arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi        |  1 +
 arch/arm/boot/dts/imx7d-cl-som-imx7.dts            |  3 +-
 arch/arm/boot/dts/imx7d-colibri-emmc.dtsi          |  1 +
 arch/arm/boot/dts/imx7d-colibri.dtsi               |  1 +
 arch/arm/boot/dts/imx7d-nitrogen7.dts              |  1 +
 arch/arm/boot/dts/imx7d-pico.dtsi                  |  1 +
 arch/arm/boot/dts/imx7d-sdb.dts                    |  1 +
 arch/arm/boot/dts/imx7s-colibri.dtsi               |  1 +
 arch/arm/boot/dts/imx7s-warp.dts                   |  1 +
 arch/arm/boot/dts/imx7s.dtsi                       |  2 -
 arch/arm/boot/dts/omap4-l4.dtsi                    |  4 +-
 arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts          |  1 +
 arch/arm/mach-ks8695/board-acs5k.c                 |  2 +-
 arch/arm/mach-omap1/Makefile                       |  2 +-
 arch/arm/mach-omap1/include/mach/usb.h             |  2 +-
 .../boot/dts/marvell/armada-3720-espressobin.dts   | 22 +++++
 arch/arm64/boot/dts/renesas/r8a77995-draak.dts     |  2 +-
 arch/arm64/include/asm/assembler.h                 |  8 +-
 arch/arm64/kernel/entry.S                          |  6 +-
 arch/arm64/kernel/head.S                           | 26 ++++++
 arch/arm64/kernel/smp.c                            |  6 ++
 arch/microblaze/Makefile                           | 14 ++--
 arch/microblaze/boot/Makefile                      | 23 ++----
 arch/openrisc/kernel/entry.S                       |  2 +-
 arch/openrisc/kernel/head.S                        |  2 +-
 arch/powerpc/Makefile                              |  9 +-
 arch/powerpc/boot/dts/bamboo.dts                   |  4 +-
 arch/powerpc/include/asm/cputable.h                |  1 +
 arch/powerpc/include/asm/reg.h                     |  2 +
 arch/powerpc/kernel/cputable.c                     | 10 ++-
 arch/powerpc/kernel/exceptions-64s.S               |  2 +-
 arch/powerpc/kernel/prom.c                         |  6 +-
 arch/powerpc/mm/fault.c                            | 17 ++--
 arch/powerpc/mm/ppc_mmu_32.c                       |  4 +-
 arch/powerpc/net/bpf_jit_comp64.c                  | 13 +++
 arch/powerpc/perf/isa207-common.c                  | 25 ++++--
 arch/powerpc/perf/isa207-common.h                  |  4 +-
 arch/powerpc/platforms/83xx/misc.c                 | 17 ++++
 arch/powerpc/platforms/powernv/eeh-powernv.c       |  8 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |  4 +-
 arch/powerpc/platforms/powernv/pci.c               |  4 +-
 arch/powerpc/platforms/pseries/dlpar.c             |  4 +
 arch/powerpc/platforms/pseries/hotplug-memory.c    |  1 +
 arch/powerpc/xmon/xmon.c                           |  2 +-
 arch/s390/kvm/kvm-s390.c                           | 17 +++-
 arch/s390/mm/gup.c                                 |  9 +-
 arch/um/Kconfig.debug                              |  1 +
 arch/um/drivers/vector_user.c                      |  1 +
 arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c        |  4 +
 arch/x86/kernel/kprobes/core.c                     |  6 ++
 arch/x86/kvm/vmx.c                                 | 86 +++++++++----------
 arch/x86/xen/xen-asm_64.S                          |  2 +
 crypto/crypto_user.c                               | 37 +++++----
 drivers/acpi/acpi_lpss.c                           |  7 +-
 drivers/acpi/apei/ghes.c                           | 32 ++++----
 drivers/ata/ahci_mvebu.c                           | 68 +++++++++++----
 drivers/base/platform.c                            |  3 +
 drivers/block/drbd/drbd_main.c                     |  1 -
 drivers/block/drbd/drbd_nl.c                       | 43 +++++++---
 drivers/block/drbd/drbd_receiver.c                 | 52 +++++++++++-
 drivers/block/drbd/drbd_state.h                    |  2 +-
 drivers/bluetooth/hci_bcm.c                        | 22 +++++
 drivers/bus/ti-sysc.c                              | 32 ++++++--
 drivers/char/hw_random/stm32-rng.c                 |  8 ++
 drivers/clk/at91/clk-generated.c                   | 28 +++----
 drivers/clk/at91/clk-main.c                        |  7 +-
 drivers/clk/at91/sckc.c                            | 20 ++++-
 drivers/clk/clk-stm32mp1.c                         | 28 ++++---
 drivers/clk/meson/gxbb.c                           |  1 +
 drivers/clk/samsung/clk-exynos5420.c               |  6 ++
 drivers/clk/samsung/clk-exynos5433.c               | 14 +++-
 drivers/clk/sunxi-ng/ccu-sun9i-a80.c               |  2 +-
 drivers/clk/sunxi/clk-sunxi.c                      |  4 +-
 drivers/clk/ti/clk-dra7-atl.c                      |  6 --
 drivers/clk/ti/clkctrl.c                           |  5 +-
 drivers/clocksource/timer-fttmr010.c               | 73 +++++++++-------
 drivers/clocksource/timer-mediatek.c               | 10 +--
 drivers/crypto/chelsio/chtls/chtls.h               |  5 ++
 drivers/crypto/chelsio/chtls/chtls_main.c          | 50 ++++++-----
 drivers/crypto/mxc-scc.c                           | 12 +--
 drivers/crypto/stm32/stm32-hash.c                  |  2 +-
 drivers/dma/stm32-dma.c                            | 20 ++---
 drivers/firmware/arm_sdei.c                        |  6 --
 drivers/gpio/gpio-pca953x.c                        |  2 +-
 drivers/gpio/gpio-raspberrypi-exp.c                |  1 +
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c    |  2 +-
 drivers/gpu/ipu-v3/ipu-pre.c                       |  6 ++
 drivers/hid/hid-core.c                             | 51 ++++++++++--
 drivers/hid/intel-ish-hid/ishtp-hid.c              |  2 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |  5 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         | 15 +++-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  4 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  3 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            |  2 +
 drivers/infiniband/hw/qib/qib_sdma.c               |  4 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c    |  2 +-
 drivers/infiniband/sw/rxe/rxe_hw_counters.c        |  2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |  6 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |  1 +
 drivers/input/serio/gscps2.c                       |  4 +-
 drivers/input/serio/hp_sdc.c                       |  4 +-
 drivers/iommu/amd_iommu.c                          |  8 +-
 drivers/mailbox/mailbox-test.c                     | 14 ++--
 drivers/mailbox/stm32-ipcc.c                       | 37 ++++++---
 drivers/md/bcache/debug.c                          |  3 +-
 drivers/md/bcache/super.c                          |  3 +-
 drivers/md/bcache/writeback.c                      |  3 +-
 drivers/md/dm-flakey.c                             | 33 +++++---
 drivers/md/dm-raid.c                               |  3 +-
 drivers/media/platform/atmel/atmel-isc.c           | 12 ++-
 drivers/media/platform/stm32/stm32-dcmi.c          | 23 +++++-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  1 +
 drivers/memory/omap-gpmc.c                         |  1 +
 drivers/misc/mei/bus.c                             |  9 +-
 drivers/misc/mei/hw-me-regs.h                      |  1 +
 drivers/misc/mei/pci-me.c                          |  1 +
 drivers/mmc/core/block.c                           |  6 --
 drivers/mmc/core/queue.c                           |  9 +-
 drivers/mmc/host/meson-gx-mmc.c                    | 73 +++++++++++++---
 drivers/mtd/mtdcore.h                              |  2 +-
 drivers/mtd/mtdpart.c                              | 35 ++++++--
 drivers/mtd/nand/raw/atmel/nand-controller.c       |  2 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 | 21 +++--
 drivers/mtd/nand/raw/sunxi_nand.c                  |  2 +-
 drivers/mtd/spi-nor/spi-nor.c                      |  2 +-
 drivers/mtd/ubi/build.c                            |  2 +-
 drivers/mtd/ubi/kapi.c                             |  2 +-
 drivers/net/Kconfig                                |  4 +-
 drivers/net/can/c_can/c_can.c                      | 26 ++++++
 drivers/net/can/flexcan.c                          | 10 ++-
 drivers/net/can/rx-offload.c                       | 96 ++++++++++++++++++----
 drivers/net/can/spi/mcp251x.c                      |  2 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            | 15 ++--
 drivers/net/dsa/bcm_sf2.c                          |  7 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |  4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 57 +++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 78 ++++++++++++++----
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  7 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       | 33 ++++++++
 drivers/net/ethernet/cadence/macb.h                |  6 +-
 drivers/net/ethernet/cadence/macb_main.c           | 19 +++--
 drivers/net/ethernet/cadence/macb_ptp.c            |  5 +-
 drivers/net/ethernet/freescale/fec_main.c          |  2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  7 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  7 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  8 +-
 drivers/net/ethernet/mscc/ocelot.h                 |  2 +-
 drivers/net/ethernet/sfc/ef10.c                    | 29 +++++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  |  4 +-
 drivers/net/ethernet/ti/cpts.c                     |  4 +-
 drivers/net/macvlan.c                              |  3 +-
 drivers/net/slip/slip.c                            |  1 +
 drivers/net/vxlan.c                                | 13 ++-
 drivers/net/wan/fsl_ucc_hdlc.c                     |  1 -
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  4 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 10 +++
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 29 ++++++-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  9 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      | 17 ++++
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  | 19 -----
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |  5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 14 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 24 +++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 10 +--
 drivers/net/wireless/marvell/mwifiex/debugfs.c     | 14 ++--
 drivers/net/wireless/marvell/mwifiex/scan.c        | 18 ++--
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |  3 +-
 drivers/nvme/host/core.c                           | 41 +++++++--
 drivers/nvme/host/nvme.h                           |  3 +
 drivers/pci/msi.c                                  | 22 +++--
 drivers/pinctrl/intel/pinctrl-cherryview.c         | 24 +++---
 drivers/pinctrl/pinctrl-xway.c                     | 39 ++++++---
 drivers/pinctrl/sh-pfc/pfc-r8a77990.c              |  2 +-
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                |  9 +-
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                | 16 ++--
 drivers/pinctrl/stm32/pinctrl-stm32.c              | 26 +++---
 drivers/platform/x86/hp-wmi.c                      | 10 +--
 drivers/platform/x86/mlx-platform.c                |  4 +-
 drivers/power/avs/smartreflex.c                    |  3 +-
 drivers/pwm/core.c                                 |  1 +
 drivers/pwm/pwm-bcm-iproc.c                        |  1 +
 drivers/pwm/pwm-berlin.c                           |  1 -
 drivers/pwm/pwm-clps711x.c                         |  4 +-
 drivers/pwm/pwm-pca9685.c                          |  1 -
 drivers/pwm/pwm-samsung.c                          |  1 -
 drivers/regulator/palmas-regulator.c               |  5 +-
 drivers/regulator/tps65910-regulator.c             |  4 +-
 drivers/reset/core.c                               |  1 +
 drivers/s390/crypto/ap_queue.c                     | 23 +++++-
 drivers/scsi/csiostor/csio_init.c                  |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             | 12 +++
 drivers/scsi/libsas/sas_expander.c                 | 29 ++++++-
 drivers/scsi/lpfc/lpfc.h                           |  6 ++
 drivers/scsi/lpfc/lpfc_attr.c                      |  4 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |  6 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  4 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  7 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      | 18 ++++
 drivers/scsi/lpfc/lpfc_sli.c                       |  2 +
 drivers/scsi/qla2xxx/qla_attr.c                    |  2 +
 drivers/scsi/qla2xxx/qla_init.c                    | 10 +--
 drivers/scsi/qla2xxx/qla_nvme.c                    | 16 +---
 drivers/scsi/qla2xxx/qla_os.c                      |  2 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 | 48 ++---------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h                 |  3 -
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |  5 +-
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |  7 +-
 drivers/target/target_core_user.c                  |  2 +-
 drivers/thunderbolt/switch.c                       | 54 +++++++++---
 drivers/tty/serial/8250/8250_core.c                | 26 ++++++
 drivers/tty/serial/8250/8250_fsl.c                 | 23 +++++-
 drivers/tty/serial/8250/8250_of.c                  |  5 ++
 drivers/tty/serial/max310x.c                       |  7 +-
 drivers/tty/serial/sh-sci.c                        |  2 +-
 drivers/usb/dwc2/core.c                            |  2 +-
 drivers/usb/host/ehci-omap.c                       |  7 +-
 drivers/usb/serial/ftdi_sio.c                      |  3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |  7 ++
 drivers/vfio/vfio_iommu_spapr_tce.c                | 10 +--
 drivers/watchdog/meson_gxbb_wdt.c                  |  4 +-
 drivers/watchdog/sama5d4_wdt.c                     |  4 +-
 drivers/xen/xen-pciback/pci_stub.c                 |  3 +-
 fs/btrfs/delayed-ref.c                             |  3 -
 fs/btrfs/dev-replace.c                             | 21 +++--
 fs/btrfs/disk-io.c                                 |  7 +-
 fs/btrfs/extent-tree.c                             |  7 +-
 fs/btrfs/extent_io.h                               |  4 +-
 fs/btrfs/volumes.c                                 | 13 +--
 fs/ceph/super.c                                    | 11 ++-
 fs/exofs/super.c                                   | 37 +++++++--
 fs/ext4/inode.c                                    | 15 ++++
 fs/ext4/super.c                                    | 21 +++--
 fs/f2fs/file.c                                     |  2 +-
 fs/f2fs/segment.c                                  |  2 +-
 fs/gfs2/bmap.c                                     |  2 +
 fs/ocfs2/journal.c                                 |  6 +-
 fs/ubifs/sb.c                                      | 13 ++-
 fs/xfs/libxfs/xfs_symlink_remote.c                 | 14 +++-
 fs/xfs/xfs_buf.c                                   |  3 +-
 fs/xfs/xfs_ioctl32.c                               | 40 ++++++++-
 fs/xfs/xfs_rtalloc.c                               |  4 +-
 fs/xfs/xfs_symlink.c                               | 33 ++++----
 include/linux/blktrace_api.h                       |  8 +-
 include/linux/genalloc.h                           | 13 +--
 include/linux/gpio/consumer.h                      |  2 +-
 include/linux/idr.h                                |  2 +-
 include/linux/kprobes.h                            |  3 +
 include/linux/memory_hotplug.h                     | 18 ++--
 include/linux/netdevice.h                          |  2 +-
 include/linux/reset-controller.h                   |  2 +-
 include/linux/sched/task.h                         |  2 +
 include/linux/serial_8250.h                        |  4 +
 include/linux/swap.h                               |  6 --
 include/linux/trace_events.h                       |  2 +
 include/net/fq_impl.h                              |  4 +-
 include/net/sctp/structs.h                         |  3 +
 include/net/sock.h                                 |  2 +-
 include/trace/events/rpcrdma.h                     | 28 +++++++
 init/main.c                                        |  1 -
 kernel/bpf/cpumap.c                                | 13 ++-
 kernel/bpf/syscall.c                               |  6 +-
 kernel/fork.c                                      |  5 --
 kernel/kprobes.c                                   | 67 +++++++++++----
 kernel/trace/trace_events.c                        | 34 ++++++--
 kernel/trace/trace_events_hist.c                   | 24 +++---
 lib/genalloc.c                                     | 25 +++---
 lib/radix-tree.c                                   |  2 +-
 mm/internal.h                                      | 10 +++
 mm/memblock.c                                      |  7 +-
 mm/page_alloc.c                                    | 29 +++----
 net/bridge/netfilter/ebt_dnat.c                    | 19 ++++-
 net/core/neighbour.c                               | 13 ++-
 net/core/net_namespace.c                           |  3 +-
 net/core/sock.c                                    |  2 +-
 net/decnet/dn_dev.c                                |  2 +-
 net/ipv4/ip_gre.c                                  | 33 ++++----
 net/ipv4/ip_tunnel.c                               |  8 +-
 net/ipv4/tcp_timer.c                               |  6 +-
 net/ipv6/ip6_gre.c                                 | 36 ++++----
 net/mac80211/sta_info.c                            |  3 +-
 net/netfilter/nf_nat_sip.c                         | 39 ++++++++-
 net/netfilter/nf_tables_api.c                      |  2 +
 net/openvswitch/datapath.c                         | 17 +++-
 net/psample/psample.c                              |  2 +-
 net/sched/sch_mq.c                                 |  3 +-
 net/sched/sch_mqprio.c                             |  4 +-
 net/sched/sch_multiq.c                             |  2 +-
 net/sched/sch_prio.c                               |  2 +-
 net/sctp/associola.c                               |  1 +
 net/sctp/endpointola.c                             |  1 +
 net/sctp/input.c                                   |  4 +-
 net/sctp/sm_statefuns.c                            |  4 +-
 net/sctp/transport.c                               |  3 +-
 net/smc/smc_cdc.c                                  |  7 +-
 net/smc/smc_cdc.h                                  | 45 +++++++---
 net/smc/smc_core.c                                 |  4 +
 net/smc/smc_tx.c                                   | 10 +--
 net/sunrpc/xprtrdma/rpc_rdma.c                     |  4 +
 net/tipc/link.c                                    |  2 +-
 net/tipc/netlink_compat.c                          | 15 +++-
 net/vmw_vsock/af_vsock.c                           |  7 +-
 net/xfrm/xfrm_state.c                              |  2 +
 samples/bpf/Makefile                               |  1 +
 samples/vfio-mdev/mtty.c                           | 26 +++---
 scripts/gdb/linux/symbols.py                       |  3 +-
 security/apparmor/apparmorfs.c                     |  1 +
 sound/core/compress_offload.c                      |  2 +-
 sound/soc/codecs/msm8916-wcd-analog.c              |  4 +-
 sound/soc/codecs/rt5645.c                          | 14 ++++
 sound/soc/kirkwood/kirkwood-i2s.c                  | 11 +--
 sound/soc/samsung/i2s.c                            |  8 +-
 sound/soc/stm/stm32_i2s.c                          | 29 ++++---
 sound/soc/stm/stm32_sai.c                          | 11 ++-
 sound/soc/stm/stm32_sai_sub.c                      | 12 ++-
 tools/testing/selftests/bpf/test_sockmap.c         |  9 ++
 tools/vm/page-types.c                              |  2 +-
 virt/kvm/kvm_main.c                                |  2 +-
 398 files changed, 2626 insertions(+), 1216 deletions(-)


