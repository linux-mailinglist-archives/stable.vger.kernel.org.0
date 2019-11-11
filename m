Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC71F7EE9
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbfKKSg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:36:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727730AbfKKSg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:36:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3225120659;
        Mon, 11 Nov 2019 18:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497415;
        bh=zE4uy5GX7HpJr/Z1NEUUkoA5v55oUPEYaTIxFhxVC00=;
        h=From:To:Cc:Subject:Date:From;
        b=g7a9omt8myhoHjRmWr38n9jsELaJzB0RMyPtZ6DvTuRKS+/AbjNyb1K4cl3HRBYLJ
         l9EvnKrsvZEk2kNIkPv5gFkVMt4kIqXmeq6xuQzY80JK78C5wk5MSppgCvP/59ZhVo
         S1oQkUhIK8XCkcJ9Ady3K02qPDhn4KuKPKW0FsfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/105] 4.14.154-stable review
Date:   Mon, 11 Nov 2019 19:27:30 +0100
Message-Id: <20191111181421.390326245@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.154-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.154-rc1
X-KernelTest-Deadline: 2019-11-13T18:14+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.154 release.
There are 105 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.154-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.154-rc1

Tejun Heo <tj@kernel.org>
    cgroup,writeback: don't switch wbs immediately on dead wbs if the memcg is dead

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    mm/filemap.c: don't initiate writeback if mapping has no dirty pages

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: disable completely the ECC mechanism

Jan Beulich <jbeulich@suse.com>
    x86/apic/32: Avoid bogus LDR warnings

Dou Liyang <douly.fnst@cn.fujitsu.com>
    x86/apic: Drop logical_smp_processor_id() inline

Dou Liyang <douly.fnst@cn.fujitsu.com>
    x86/apic: Move pending interrupt check code into it's own function

Wenwen Wang <wenwen@cs.uga.edu>
    e1000: fix memory leaks

Manfred Rudigier <manfred.rudigier@omicronenergy.com>
    igb: Fix constant media auto sense switching when no cable is connected

Chuhong Yuan <hslester96@gmail.com>
    net: ethernet: arc: add the missed clk_disable_unprepare

Trond Myklebust <trondmy@gmail.com>
    NFSv4: Don't allow a cached open with a revoked delegation

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix error handling in netvsc_attach()

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: Fix "Trying to free already-free IRQ"

Will Deacon <will@kernel.org>
    fjes: Handle workqueue allocation failure

Nicholas Piggin <npiggin@gmail.com>
    scsi: qla2xxx: stop timer in shutdown path

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/iw_cxgb4: Avoid freeing skb twice in arp failure case

Johan Hovold <johan@kernel.org>
    USB: ldusb: use unsigned size format specifiers

Alan Stern <stern@rowland.harvard.edu>
    USB: Skip endpoints with 0 maxpacket length

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Handle erratum #420 only on the affected CPU family (10h)

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Fix reading of the IBS OpData register and thus precise RIP validity

Yinbo Zhu <yinbo.zhu@nxp.com>
    usb: dwc3: remove the call trace of USBx_GFLADJ

Peter Chen <peter.chen@nxp.com>
    usb: gadget: configfs: fix concurrent issue between composite APIs

Chandana Kishori Chiluveru <cchiluve@codeaurora.org>
    usb: gadget: composite: Fix possible double free memory bug

Cristian Birsan <cristian.birsan@microchip.com>
    usb: gadget: udc: atmel: Fix interrupt storm in FIFO mode.

Nikhil Badola <nikhil.badola@freescale.com>
    usb: fsl: Check memory resource before releasing it

Taehee Yoo <ap420073@gmail.com>
    macsec: fix refcnt leak in module exit routine

Taehee Yoo <ap420073@gmail.com>
    bonding: fix unexpected IFF_BONDING bit unset

Eric Dumazet <edumazet@google.com>
    ipvs: move old_secure_tcp into struct netns_ipvs

Davide Caratti <dcaratti@redhat.com>
    ipvs: don't ignore errors in case refcounting ip_vs module fails

Himanshu Madhani <hmadhani@marvell.com>
    scsi: qla2xxx: Initialized mailbox to prevent driver load failure

Daniel Wagner <dwagner@suse.de>
    scsi: lpfc: Honor module parameter lpfc_use_adisc

Hillf Danton <hdanton@sina.com>
    net: openvswitch: free vport unless register_netdevice() succeeds

Dan Carpenter <dan.carpenter@oracle.com>
    RDMA/uverbs: Prevent potential underflow

Hannes Reinecke <hare@suse.com>
    scsi: qla2xxx: fixup incorrect usage of host_byte

Navid Emamdoost <navid.emamdoost@gmail.com>
    net/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq

Kamal Heib <kamalheib1@gmail.com>
    RDMA/qedr: Fix reported firmware version

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: fix wrong error handling in ishtp_cl_alloc_tx_ring()

Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
    dmaengine: xilinx_dma: Fix control reg update in vdma_channel_set_config

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra: Enable Relaxed Ordering only for Tegra20 & Tegra30

Suwan Kim <suwan.kim027@gmail.com>
    usbip: Implement SG support to vhci-hcd and stub driver

Shuah Khan <shuah@kernel.org>
    usbip: stub_rx: fix static checker warning on unnecessary checks

Shuah Khan <shuah@kernel.org>
    usbip: Fix vhci_urb_enqueue() URB null transfer buffer error path

Bart Van Assche <bart.vanassche@wdc.com>
    lib/scatterlist: Introduce sgl_alloc() and sgl_free()

Qian Cai <cai@lca.pw>
    sched/fair: Fix -Wunused-but-set-variable warnings

Dave Chiluk <chiluk+linux@indeed.com>
    sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices

Roger Quadros <rogerq@ti.com>
    ARM: dts: dra7: Disable USB metastability workaround for USB2

Zumeng Chen <zumeng.chen@gmail.com>
    cpufreq: ti-cpufreq: add missing of_node_put()

Claudio Foellmi <claudio.foellmi@ergon.ch>
    i2c: omap: Trigger bus recovery in lockup case

Christophe Jaillet <christophe.jaillet@wanadoo.fr>
    ASoC: davinci-mcasp: Fix an error handling path in 'davinci_mcasp_probe()'

Takashi Iwai <tiwai@suse.de>
    ASoC: davinci: Kill BUG_ON() usage

Arvind Yadav <arvind.yadav.cs@gmail.com>
    ASoC: davinci-mcasp: Handle return value of devm_kasprintf

Gustavo A. R. Silva <garsilva@embeddedor.com>
    ASoC: tlv320dac31xx: mark expected switch fall-through

Sudeep Holla <sudeep.holla@arm.com>
    mailbox: reset txdone_method TXDONE_BY_POLL if client knows_txdone

Kishon Vijay Abraham I <kishon@ti.com>
    misc: pci_endpoint_test: Fix BUG_ON error during pci_disable_msi()

Keerthy <j-keerthy@ti.com>
    PCI: dra7xx: Add shutdown handler to cleanly turn off clocks

Dan Carpenter <dan.carpenter@oracle.com>
    misc: pci_endpoint_test: Prevent some integer overflows

Vignesh R <vigneshr@ti.com>
    mtd: spi-nor: cadence-quadspi: add a delay in write sequence

Roman Yeryomin <leroi.lists@gmail.com>
    mtd: spi-nor: enable 4B opcodes for mx66l51235l

Andrew F. Davis <afd@ti.com>
    ASoC: tlv320aic31xx: Handle inverted BCLK in non-DSP modes

Keerthy <j-keerthy@ti.com>
    mfd: palmas: Assign the right powerhold mask for tps65917

Roger Quadros <rogerq@ti.com>
    usb: dwc3: Allow disabling of metastability workaround

Al Viro <viro@zeniv.linux.org.uk>
    configfs: fix a deadlock in configfs_symlink()

Al Viro <viro@zeniv.linux.org.uk>
    configfs: provide exclusion between IO and removals

Al Viro <viro@zeniv.linux.org.uk>
    configfs: new object reprsenting tree fragments

Al Viro <viro@zeniv.linux.org.uk>
    configfs_register_group() shouldn't be (and isn't) called in rmdirable parts

Al Viro <viro@zeniv.linux.org.uk>
    configfs: stash the data we need into configfs_buffer at open time

Thomas Meyer <thomas@m3y3r.de>
    configfs: Fix bool initialization/comparison

Johan Hovold <johan@kernel.org>
    can: peak_usb: fix slab info leak

Johan Hovold <johan@kernel.org>
    can: mcba_usb: fix use-after-free on disconnect

Navid Emamdoost <navid.emamdoost@gmail.com>
    can: gs_usb: gs_can_open(): prevent memory leak

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rx-offload: can_rx_offload_queue_sorted(): fix error handling, avoid skb mem leak

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: fix a potential out-of-sync while decoding packets

Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
    can: c_can: c_can_poll(): only read status register after status IRQ

Johan Hovold <johan@kernel.org>
    can: usb_8dev: fix use-after-free on disconnect

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Jasper Lake PCH support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Comet Lake PCH support

Dan Carpenter <dan.carpenter@oracle.com>
    netfilter: ipset: Fix an error code in ip_set_sockfn_get()

Lukas Wunner <lukas@wunner.de>
    netfilter: nf_tables: Align nft_expr private data to 64-bit

Andreas Klinger <ak@it-klinger.de>
    iio: srf04: fix wrong limitation in distance measuring

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: imu: adis16480: make sure provided frequency is positive

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: adc: stm32-adc: fix stopping dma

Al Viro <viro@zeniv.linux.org.uk>
    ceph: add missing check in d_revalidate snapdir handling

Luis Henriques <lhenriques@suse.com>
    ceph: fix use-after-free in __ceph_remove_cap()

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Do not mask out PTE_RDONLY in pte_same()

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: generic: Treat serial number and related fields as unsigned

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix si_enable_smc_cac() failed issue

Jiri Olsa <jolsa@kernel.org>
    perf tools: Fix time sorting

Shuah Khan <skhan@linuxfoundation.org>
    tools: gpio: Use !building_out_of_srctree to determine srctree

Kevin Hao <haokexin@gmail.com>
    dump_stack: avoid the livelock of the dump_lock

Michal Hocko <mhocko@suse.com>
    mm, vmstat: hide /proc/pagetypeinfo from normal users

Yang Shi <yang.shi@linux.alibaba.com>
    mm: thp: handle page cache THP correctly in PageTransCompoundMap

Mel Gorman <mgorman@techsingularity.net>
    mm, meminit: recalculate pcpu batch and high limits after init completes

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132 - Fix possible workqueue stall

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob: fix to detect configured source of sampling clock for Focusrite Saffire Pro i/o series

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Fix incorrectly assigned timer instance

Manish Chopra <manishc@marvell.com>
    qede: fix NULL pointer deref in __qede_remove()

Pan Bian <bianpan2016@163.com>
    NFC: st21nfca: fix double free

Pan Bian <bianpan2016@163.com>
    nfc: netlink: fix double device reference drop

Pan Bian <bianpan2016@163.com>
    NFC: fdp: fix incorrect free object

Aleksander Morgado <aleksander@aleksander.es>
    net: usb: qmi_wwan: add support for DW5821e with eSIM support

Sean Tranchetti <stranche@codeaurora.org>
    net: qualcomm: rmnet: Fix potential UAF when unregistering

Eric Dumazet <edumazet@google.com>
    net: fix data-race in neigh_event_send()

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    net: ethernet: octeon_mgmt: Account for second possible VLAN header

David Ahern <dsahern@kernel.org>
    ipv4: Fix table id reference in fib_sync_down_addr

Oliver Neukum <oneukum@suse.com>
    CDC-NCM: handle incomplete transfer of MTU

Jay Vosburgh <jay.vosburgh@canonical.com>
    bonding: fix state transition issue in link monitoring


-------------

Diffstat:

 Documentation/devicetree/bindings/usb/dwc3.txt     |   2 +
 Documentation/scheduler/sched-bwc.txt              |  45 ++++
 Makefile                                           |   4 +-
 arch/arm/boot/dts/dra7.dtsi                        |   1 +
 arch/arm64/include/asm/pgtable.h                   |  17 --
 arch/x86/events/amd/ibs.c                          |   8 +-
 arch/x86/include/asm/smp.h                         |  10 -
 arch/x86/kernel/apic/apic.c                        | 122 +++++----
 drivers/cpufreq/ti-cpufreq.c                       |   1 +
 drivers/dma/xilinx/xilinx_dma.c                    |   7 +
 drivers/gpu/drm/radeon/si_dpm.c                    |   1 +
 drivers/hid/intel-ish-hid/ishtp/client-buffers.c   |   2 +-
 drivers/hid/wacom.h                                |  15 ++
 drivers/hid/wacom_wac.c                            |  10 +-
 drivers/hwtracing/intel_th/pci.c                   |  10 +
 drivers/i2c/busses/i2c-omap.c                      |  25 +-
 drivers/iio/adc/stm32-adc.c                        |   4 +-
 drivers/iio/imu/adis16480.c                        |   5 +-
 drivers/iio/proximity/srf04.c                      |  29 +-
 drivers/infiniband/core/uverbs.h                   |   2 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   2 -
 drivers/infiniband/hw/qedr/main.c                  |   2 +-
 drivers/mailbox/mailbox.c                          |   4 +-
 drivers/mailbox/pcc.c                              |   4 +-
 drivers/mfd/palmas.c                               |  10 +-
 drivers/misc/pci_endpoint_test.c                   |  17 ++
 drivers/mtd/spi-nor/cadence-quadspi.c              |  27 +-
 drivers/mtd/spi-nor/spi-nor.c                      |   2 +-
 drivers/net/bonding/bond_main.c                    |  47 ++--
 drivers/net/can/c_can/c_can.c                      |  25 +-
 drivers/net/can/c_can/c_can.h                      |   1 +
 drivers/net/can/flexcan.c                          |   1 +
 drivers/net/can/rx-offload.c                       |   6 +-
 drivers/net/can/usb/gs_usb.c                       |   1 +
 drivers/net/can/usb/mcba_usb.c                     |   3 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  17 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
 drivers/net/can/usb/usb_8dev.c                     |   3 +-
 drivers/net/ethernet/arc/emac_rockchip.c           |   3 +
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |   2 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |   1 -
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |   7 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   3 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  12 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |   4 +-
 drivers/net/fjes/fjes_main.c                       |  15 +-
 drivers/net/hyperv/netvsc_drv.c                    |   9 +-
 drivers/net/macsec.c                               |   4 -
 drivers/net/usb/cdc_ncm.c                          |   6 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/nfc/fdp/i2c.c                              |   2 +-
 drivers/nfc/st21nfca/core.c                        |   1 +
 drivers/pci/dwc/pci-dra7xx.c                       |  17 ++
 drivers/pci/host/pci-tegra.c                       |   7 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   4 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |   6 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   3 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   4 +
 drivers/usb/core/config.c                          |   5 +
 drivers/usb/dwc3/core.c                            |   6 +-
 drivers/usb/dwc3/core.h                            |   3 +
 drivers/usb/dwc3/gadget.c                          |   6 +-
 drivers/usb/gadget/composite.c                     |   4 +
 drivers/usb/gadget/configfs.c                      | 110 +++++++-
 drivers/usb/gadget/udc/atmel_usba_udc.c            |   6 +-
 drivers/usb/gadget/udc/fsl_udc_core.c              |   2 +-
 drivers/usb/misc/ldusb.c                           |   7 +-
 drivers/usb/usbip/Kconfig                          |   1 +
 drivers/usb/usbip/stub.h                           |   7 +-
 drivers/usb/usbip/stub_main.c                      |  57 ++--
 drivers/usb/usbip/stub_rx.c                        | 213 ++++++++++-----
 drivers/usb/usbip/stub_tx.c                        |  99 +++++--
 drivers/usb/usbip/usbip_common.c                   |  59 +++--
 drivers/usb/usbip/vhci_hcd.c                       |  16 +-
 drivers/usb/usbip/vhci_rx.c                        |   3 +
 drivers/usb/usbip/vhci_tx.c                        |  66 ++++-
 fs/ceph/caps.c                                     |  10 +-
 fs/ceph/inode.c                                    |   1 +
 fs/configfs/configfs_internal.h                    |  15 +-
 fs/configfs/dir.c                                  | 137 +++++++---
 fs/configfs/file.c                                 | 294 ++++++++++-----------
 fs/configfs/symlink.c                              |  33 ++-
 fs/fs-writeback.c                                  |   9 +-
 fs/nfs/delegation.c                                |  10 +
 fs/nfs/delegation.h                                |   1 +
 fs/nfs/nfs4proc.c                                  |   7 +-
 include/linux/mfd/palmas.h                         |   3 +
 include/linux/mm.h                                 |   5 -
 include/linux/mm_types.h                           |   5 +
 include/linux/page-flags.h                         |  20 +-
 include/linux/scatterlist.h                        |  10 +
 include/net/bonding.h                              |   3 +-
 include/net/ip_vs.h                                |   1 +
 include/net/neighbour.h                            |   4 +-
 include/net/netfilter/nf_tables.h                  |   3 +-
 include/rdma/ib_verbs.h                            |   2 +-
 kernel/sched/fair.c                                |  85 +-----
 kernel/sched/sched.h                               |   4 -
 lib/Kconfig                                        |   4 +
 lib/dump_stack.c                                   |   7 +-
 lib/scatterlist.c                                  | 105 ++++++++
 mm/filemap.c                                       |   3 +-
 mm/page_alloc.c                                    |  10 +-
 mm/vmstat.c                                        |   2 +-
 net/ipv4/fib_semantics.c                           |   2 +-
 net/netfilter/ipset/ip_set_core.c                  |   8 +-
 net/netfilter/ipvs/ip_vs_app.c                     |  12 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  29 +-
 net/netfilter/ipvs/ip_vs_pe.c                      |   3 +-
 net/netfilter/ipvs/ip_vs_sched.c                   |   3 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |  13 +-
 net/nfc/netlink.c                                  |   2 -
 net/openvswitch/vport-internal_dev.c               |  11 +-
 sound/core/timer.c                                 |   6 +-
 sound/firewire/bebob/bebob_focusrite.c             |   3 +
 sound/pci/hda/patch_ca0132.c                       |   2 +-
 sound/soc/codecs/tlv320aic31xx.c                   |  30 ++-
 sound/soc/davinci/davinci-mcasp.c                  |  21 +-
 tools/gpio/Makefile                                |   6 +-
 tools/perf/util/hist.c                             |   2 +-
 121 files changed, 1532 insertions(+), 693 deletions(-)


