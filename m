Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32A761EE86
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731261AbfEOLWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:32934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731249AbfEOLWo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:22:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6109A21473;
        Wed, 15 May 2019 11:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919361;
        bh=+QbHoVQd6/OiiFA6/ZwyYyB3rIWA0cyURmo0bqM37rA=;
        h=From:To:Cc:Subject:Date:From;
        b=0hi3gLl0UWHPo+aW1uo62GvR+pS8Db3fsnrczb/dfMgyiRNJMjNEmpzd8yGdWTM3u
         zMJO2DJAq0MZkAb8+0jrjK9VtKhhuKPMxVe9CSBOGFskXqsHMGuZdj+qsI2aWiOclJ
         V7DOKKBjIo+4o/x1KHv3+npXavwYqUCDqrMdeb5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/113] 4.19.44-stable review
Date:   Wed, 15 May 2019 12:54:51 +0200
Message-Id: <20190515090652.640988966@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.44-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.44-rc1
X-KernelTest-Deadline: 2019-05-17T09:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.44 release.
There are 113 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 17 May 2019 09:04:35 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.44-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.44-rc1

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Add pci_destroy_slot() in pci_devices_present_work(), if necessary

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Add hv_pci_remove_slots() when we unload the driver

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Fix a memory leak in hv_eject_device_work()

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    powerpc/booke64: set RI in default MSR

Russell Currey <ruscur@russell.cc>
    powerpc/powernv/idle: Restore IAMR after idle

Rick Lindsley <ricklind@linux.vnet.ibm.com>
    powerpc/book3s/64: check for NULL pointer in pgd_alloc()

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl

Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>
    tipc: fix hanging clients using poll with EPOLLOUT flag

Paul Bolle <pebolle@tiscali.nl>
    isdn: bas_gigaset: use usb_fill_int_urb() properly

Jason Wang <jasowang@redhat.com>
    tuntap: synchronize through tfiles array instead of tun->numqueues

Jason Wang <jasowang@redhat.com>
    tuntap: fix dividing by zero in ebpf queue selection

Stephen Suryaputra <ssuryaextr@gmail.com>
    vrf: sit mtu should not be updated when vrf netdev is the link

Hangbin Liu <liuhangbin@gmail.com>
    vlan: disable SIOCSHWTSTAMP in container

Paolo Abeni <pabeni@redhat.com>
    selinux: do not report error on connect(AF_UNSPEC)

YueHaibing <yuehaibing@huawei.com>
    packet: Fix error path in packet_init

Christophe Leroy <christophe.leroy@c-s.fr>
    net: ucc_geth - fix Oops when changing number of buffers in the ring

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    net: seeq: fix crash caused by not set dev.parent

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Change interrupt and napi enable order in open

Corentin Labbe <clabbe@baylibre.com>
    net: ethernet: stmmac: dwmac-sun8i: enable support of unicast filtering

YueHaibing <yuehaibing@huawei.com>
    net: dsa: Fix error cleanup path in dsa_init_module

David Ahern <dsahern@gmail.com>
    ipv4: Fix raw socket lookup for local traffic

Hangbin Liu <liuhangbin@gmail.com>
    fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    dpaa_eth: fix SG frame cleanup

Tobin C. Harding <tobin@kernel.org>
    bridge: Fix error path for kobject_init_and_add()

Jarod Wilson <jarod@redhat.com>
    bonding: fix arp_validate toggling in active-backup mode

Breno Leitao <leitao@debian.org>
    powerpc/64s: Include cpu header

Ritesh Raj Sarraf <rrs@debian.org>
    um: Don't hardcode path as it is architecture dependent

Nigel Croxon <ncroxon@redhat.com>
    Don't jump to compute_result state from check_result state

Gustavo A. R. Silva <gustavo@embeddedor.com>
    rtlwifi: rtl8723ae: Fix missing break in switch statement

Petr Štetiar <ynezz@true.cz>
    mwl8k: Fix rate_idx underflow

Wei Yongjun <weiyongjun1@huawei.com>
    cw1200: fix missing unlock on error in cw1200_hw_scan()

Masami Hiramatsu <mhiramat@kernel.org>
    x86/kprobes: Avoid kretprobe recursion bug

Dan Carpenter <dan.carpenter@oracle.com>
    nfc: nci: Potential off by one in ->pipes[] array

Dan Carpenter <dan.carpenter@oracle.com>
    NFC: nci: Add some bounds checking in nci_hci_cmd_received()

Jakub Kicinski <jakub.kicinski@netronome.com>
    net: strparser: partially revert "strparser: Call skb_unclone conditionally"

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: fix the IV leaks

Ido Schimmel <idosch@mellanox.com>
    mlxsw: core: Do not use WQ_MEM_RECLAIM for mlxsw workqueue

Ido Schimmel <idosch@mellanox.com>
    mlxsw: core: Do not use WQ_MEM_RECLAIM for mlxsw ordered workqueue

Ido Schimmel <idosch@mellanox.com>
    mlxsw: core: Do not use WQ_MEM_RECLAIM for EMAD workqueue

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_switchdev: Add MDB entries in prepare phase

Andy Duan <fugang.duan@nxp.com>
    net: fec: manage ahb clock in runtime pm

Taehee Yoo <ap420073@gmail.com>
    netfilter: nf_tables: add missing ->release_ops() in error path of newrule()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: use-after-free in dynamic operations

Gustavo A. R. Silva <gustavo@embeddedor.com>
    usb: typec: Fix unchecked return value

Jan Kara <jack@suse.cz>
    mm/memory.c: fix modifying of page protection by insert_pfn()

Heiner Kallweit <hkallweit1@gmail.com>
    net: dsa: mv88e6xxx: fix few issues in mv88e6390x_port_set_cmode

Nicholas Piggin <npiggin@gmail.com>
    powerpc/smp: Fix NMI IPI xmon timeout

Nicholas Piggin <npiggin@gmail.com>
    powerpc/smp: Fix NMI IPI timeout

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug.c: drop memory device reference after find_memory_block()

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Bugfix for mapping user db

Pan Bian <bianpan2016@163.com>
    Input: synaptics-rmi4 - fix possible double free

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    drm/sun4i: Unbind components before releasing DRM and memory

Daniel Gomez <dagmcr@gmail.com>
    spi: ST ST95HF NFC: declare missing of table

Daniel Gomez <dagmcr@gmail.com>
    spi: Micrel eth switch: declare missing of table

Tigran Tadevosyan <tigran.tadevosyan@arm.com>
    ARM: 8856/1: NOMMU: Fix CCR register faulty initialization when MPU is disabled

Lucas Stach <l.stach@pengutronix.de>
    drm/imx: don't skip DP channel disable for background plane

Lucas Stach <l.stach@pengutronix.de>
    gpu: ipu-v3: dp: fix CSC handling

Andrei Vagin <avagin@gmail.com>
    netfilter: fix nf_l4proto_log_invalid to log invalid packets

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests/net: correct the return value for run_netsocktests

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    drm/sun4i: Fix component unbinding and component master deletion

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    drm/sun4i: Set device driver data at bind time for use in unbind

Arnd Bergmann <arnd@arndb.de>
    s390: ctcm: fix ctcm_new_device error return code

Petr Štetiar <ynezz@true.cz>
    MIPS: perf: ath79: Fix perfcount IRQ assignment

Dan Carpenter <dan.carpenter@oracle.com>
    netfilter: nf_tables: prevent shift wrap in nft_chain_parse_hook()

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: don't use conntrack/expect object addresses as id

Julian Anastasov <ja@ssi.bg>
    ipvs: do not schedule icmp errors from tunnels

Florian Westphal <fw@strlen.de>
    selftests: netfilter: check icmp pkttoobig errors are set as related

Dan Williams <dan.j.williams@intel.com>
    init: initialize jump labels before command line option parsing

Johannes Weiner <hannes@cmpxchg.org>
    mm: fix inactive list balancing between NUMA nodes and cgroups

Christoph Hellwig <hch@lst.de>
    scsi: aic7xxx: fix EISA support

Claudiu Manoil <claudiu.manoil@nxp.com>
    ocelot: Don't sleep in atomic context (irqs_disabled())

Tony Camuso <tcamuso@redhat.com>
    ipmi: ipmi_si_hardcode.c: init si_type array to fix a crash

Rikard Falkeborn <rikard.falkeborn@gmail.com>
    tools lib traceevent: Fix missing equality check for strcmp

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: avoid misreporting level-triggered irqs as edge-triggered in tracing

Paolo Bonzini <pbonzini@redhat.com>
    KVM: fix spectrev1 gadgets

Jian-Hong Pan <jian-hong@endlessm.com>
    x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T

Sami Tolvanen <samitolvanen@google.com>
    x86/build/lto: Fix truncated .bss with -fdata-sections

Harald Freudenberger <freude@linux.ibm.com>
    s390/pkey: add one more argument space for debug feature entry

David Francis <David.Francis@amd.com>
    drm/amd/display: If one stream full updates, full update all planes

Marc Dionne <marc.dionne@auristor.com>
    afs: Unlock pages for __pagevec_release()

Colin Ian King <colin.king@canonical.com>
    qede: fix write to free'd pointer error and double free of ptp

Colin Ian King <colin.king@canonical.com>
    vxge: fix return of a free'd memblock on a failed dma mapping

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    mISDN: Check address length before reading address family

David Ahern <dsahern@gmail.com>
    selftests: fib_tests: Fix 'Command line is not complete' errors

Neil Armstrong <narmstrong@baylibre.com>
    clocksource/drivers/oxnas: Fix OX820 compatible

Arnd Bergmann <arnd@arndb.de>
    clocksource/drivers/npcm: select TIMER_OF

Martin Leung <martin.leung@amd.com>
    drm/amd/display: extending AUX SW Timeout

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/3270: fix lockdep false positive on view->lock

Li RongQing <lirongqing@baidu.com>
    libnvdimm/pmem: fix a possible OOB access when read and write pmem

Sunil Dutt <usdutt@codeaurora.org>
    nl80211: Add NL80211_FLAG_CLEAR_SKB flag for other NL commands

Felix Fietkau <nbd@nbd.name>
    mac80211: fix memory accounting with A-MSDU aggregation

Ilan Peer <ilan.peer@intel.com>
    cfg80211: Handle WMM rules in regulatory domain intersection

Andrei Otcheretianski <andrei.otcheretianski@intel.com>
    mac80211: Increase MAX_MSG_LEN

Felix Fietkau <nbd@nbd.name>
    mac80211: fix unaligned access in mesh table hash function

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/dasd: Fix capacity calculation for large volumes

Aditya Pakki <pakki001@umn.edu>
    libnvdimm/btt: Fix a kmemdup failure check

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: add mapping for "Toggle Display" key

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: add mapping for keyboard Brightness Up/Down/Toggle keys

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: add mapping for Expose/Overview key

Kangjie Lu <kjlu@umn.edu>
    libnvdimm/namespace: Fix a potential NULL pointer dereference

Dan Williams <dan.j.williams@intel.com>
    acpi/nfit: Always dump _DSM output payload

Sven Van Asbroeck <thesven73@gmail.com>
    iio: adc: xilinx: prevent touching unclocked h/w on remove

Sven Van Asbroeck <thesven73@gmail.com>
    iio: adc: xilinx: fix potential use-after-free on probe

Sven Van Asbroeck <thesven73@gmail.com>
    iio: adc: xilinx: fix potential use-after-free on remove

Johan Hovold <johan@kernel.org>
    USB: serial: fix unthrottle races

Hans de Goede <hdegoede@redhat.com>
    virt: vbox: Sanity-check parameter types for hgcm-calls coming from userspace

Andrea Parri <andrea.parri@amarulasolutions.com>
    kernfs: fix barrier usage in __kernfs_new_node()

Stefan Wahren <stefan.wahren@i2se.com>
    hwmon: (pwm-fan) Disable PWM if fetching cooling data fails

Mario Limonciello <mario.limonciello@dell.com>
    platform/x86: dell-laptop: fix rfkill functionality

Jiaxun Yang <jiaxun.yang@flygoat.com>
    platform/x86: thinkpad_acpi: Disable Bluetooth for some machines

Gustavo A. R. Silva <gustavo@embeddedor.com>
    platform/x86: sony-laptop: Fix unintentional fall-through

Jens Axboe <axboe@kernel.dk>
    bfq: update internal depth state when queue depth changes


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/kernel/head-nommu.S                       |   2 +-
 arch/mips/ath79/setup.c                            |   6 -
 arch/powerpc/include/asm/book3s/64/pgalloc.h       |   3 +
 arch/powerpc/include/asm/reg_booke.h               |   2 +-
 arch/powerpc/kernel/idle_book3s.S                  |  20 ++
 arch/powerpc/kernel/security.c                     |   1 +
 arch/powerpc/kernel/smp.c                          |  90 ++-----
 arch/um/drivers/port_user.c                        |   2 +-
 arch/x86/kernel/kprobes/core.c                     |  22 +-
 arch/x86/kernel/reboot.c                           |  21 ++
 arch/x86/kernel/vmlinux.lds.S                      |   2 +-
 arch/x86/kvm/lapic.c                               |   4 +-
 arch/x86/kvm/trace.h                               |   4 +-
 block/bfq-iosched.c                                |   8 +-
 block/blk-mq.c                                     |   2 +
 drivers/acpi/nfit/core.c                           |  12 +-
 drivers/char/ipmi/ipmi_si_hardcode.c               |   2 +
 drivers/clocksource/Kconfig                        |   1 +
 drivers/clocksource/timer-oxnas-rps.c              |   2 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  19 ++
 drivers/gpu/drm/amd/display/dc/dc.h                |   3 +
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.c       |   9 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.h       |   6 +-
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |   2 +-
 drivers/gpu/drm/sun4i/sun4i_drv.c                  |   7 +
 drivers/gpu/ipu-v3/ipu-dp.c                        |  12 +-
 drivers/hid/hid-input.c                            |  14 +
 drivers/hwmon/pwm-fan.c                            |   2 +-
 drivers/iio/adc/xilinx-xadc-core.c                 |   3 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   2 +-
 drivers/input/rmi4/rmi_driver.c                    |   6 +-
 drivers/irqchip/irq-ath79-misc.c                   |  11 +
 drivers/isdn/gigaset/bas-gigaset.c                 |   9 +-
 drivers/isdn/mISDN/socket.c                        |   4 +-
 drivers/md/raid5.c                                 |  19 +-
 drivers/net/bonding/bond_options.c                 |   7 -
 drivers/net/dsa/mv88e6xxx/port.c                   |  24 +-
 drivers/net/ethernet/cadence/macb_main.c           |   6 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |  30 ++-
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c  |   8 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   6 +-
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |   2 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   2 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.c   |   1 +
 drivers/net/ethernet/qlogic/qede/qede_ptp.c        |   7 +-
 drivers/net/ethernet/seeq/sgiseeq.c                |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   2 +
 drivers/net/phy/spi_ks8995.c                       |   9 +
 drivers/net/tun.c                                  |  14 +-
 drivers/net/wireless/marvell/mwl8k.c               |  13 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |   1 +
 drivers/net/wireless/st/cw1200/scan.c              |   5 +-
 drivers/nfc/st95hf/core.c                          |   7 +
 drivers/nvdimm/btt_devs.c                          |  18 +-
 drivers/nvdimm/namespace_devs.c                    |   5 +-
 drivers/nvdimm/pmem.c                              |   8 +-
 drivers/pci/controller/pci-hyperv.c                |  23 ++
 drivers/platform/x86/dell-laptop.c                 |   6 +-
 drivers/platform/x86/sony-laptop.c                 |   8 +-
 drivers/platform/x86/thinkpad_acpi.c               |  72 +++++-
 drivers/s390/block/dasd_eckd.c                     |   6 +-
 drivers/s390/char/con3270.c                        |   2 +-
 drivers/s390/char/fs3270.c                         |   3 +-
 drivers/s390/char/raw3270.c                        |   3 +-
 drivers/s390/char/raw3270.h                        |   4 +-
 drivers/s390/char/tty3270.c                        |   3 +-
 drivers/s390/crypto/pkey_api.c                     |   3 +-
 drivers/s390/net/ctcm_main.c                       |   1 +
 drivers/scsi/aic7xxx/aic7770_osm.c                 |   1 +
 drivers/scsi/aic7xxx/aic7xxx.h                     |   1 +
 drivers/scsi/aic7xxx/aic7xxx_osm.c                 |  10 +-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c             |   1 +
 drivers/usb/serial/generic.c                       |  39 ++-
 drivers/usb/typec/typec_wcove.c                    |   9 +-
 drivers/virt/fsl_hypervisor.c                      |  29 ++-
 drivers/virt/vboxguest/vboxguest_core.c            |  31 +++
 fs/afs/write.c                                     |   1 +
 fs/kernfs/dir.c                                    |   5 +-
 include/linux/efi.h                                |   7 +-
 include/linux/elevator.h                           |   1 +
 include/linux/kvm_host.h                           |  10 +-
 include/net/netfilter/nf_conntrack.h               |   2 +
 include/net/nfc/nci_core.h                         |   2 +-
 init/main.c                                        |   4 +-
 mm/memory.c                                        |  11 +-
 mm/memory_hotplug.c                                |   1 +
 mm/vmscan.c                                        |  29 +--
 net/8021q/vlan_dev.c                               |   4 +-
 net/bridge/br_if.c                                 |  13 +-
 net/core/fib_rules.c                               |   6 +-
 net/dsa/dsa.c                                      |  11 +-
 net/ipv4/raw.c                                     |   4 +-
 net/ipv6/sit.c                                     |   2 +-
 net/mac80211/mesh_pathtbl.c                        |   2 +-
 net/mac80211/trace_msg.h                           |   7 +-
 net/mac80211/tx.c                                  |   3 +
 net/netfilter/ipvs/ip_vs_core.c                    |   2 +-
 net/netfilter/nf_conntrack_core.c                  |  35 +++
 net/netfilter/nf_conntrack_netlink.c               |  34 ++-
 net/netfilter/nf_conntrack_proto.c                 |   2 +-
 net/netfilter/nf_tables_api.c                      |  11 +-
 net/nfc/nci/hci.c                                  |   8 +
 net/packet/af_packet.c                             |  25 +-
 net/strparser/strparser.c                          |  12 +-
 net/tipc/socket.c                                  |   4 +-
 net/tls/tls_device.c                               |   5 +-
 net/wireless/nl80211.c                             |  18 +-
 net/wireless/reg.c                                 |  39 +++
 security/selinux/hooks.c                           |   8 +-
 tools/lib/traceevent/event-parse.c                 |   2 +-
 tools/testing/selftests/net/fib_tests.sh           |  94 +++----
 tools/testing/selftests/net/run_netsocktests       |   2 +-
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 .../selftests/netfilter/conntrack_icmp_related.sh  | 283 +++++++++++++++++++++
 virt/kvm/irqchip.c                                 |   5 +-
 virt/kvm/kvm_main.c                                |   6 +-
 118 files changed, 1113 insertions(+), 380 deletions(-)


