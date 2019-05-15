Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E53F1F195
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbfEOLP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729708AbfEOLP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:15:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 185E721473;
        Wed, 15 May 2019 11:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918956;
        bh=Gqdk1g8da+IkuUYrarJyn1kU1yz/pLpJOEnHKIuH7XQ=;
        h=From:To:Cc:Subject:Date:From;
        b=rXA1Btwmd4EYc2iDkDrCHmfaBrbqZyB4Az/naNRC90Z9CkAmoiN26X5hlKGdK9MBg
         InB1kgBHHdbUJuUXHMVTmWifgWFVesHlu/Ylc+kv4f+nbtp3+/ravhG0eZABnuUyQG
         tWaOQnq7kixxqpmlJqUhD33pbZXZH1ybEfo55/dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/115] 4.14.120-stable review
Date:   Wed, 15 May 2019 12:54:40 +0200
Message-Id: <20190515090659.123121100@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.120-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.120-rc1
X-KernelTest-Deadline: 2019-05-17T09:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.120 release.
There are 115 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 17 May 2019 09:04:39 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.120-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.120-rc1

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    powerpc/booke64: set RI in default MSR

Russell Currey <ruscur@russell.cc>
    powerpc/powernv/idle: Restore IAMR after idle

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl

Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>
    tipc: fix hanging clients using poll with EPOLLOUT flag

Stephen Suryaputra <ssuryaextr@gmail.com>
    vrf: sit mtu should not be updated when vrf netdev is the link

Hangbin Liu <liuhangbin@gmail.com>
    vlan: disable SIOCSHWTSTAMP in container

YueHaibing <yuehaibing@huawei.com>
    packet: Fix error path in packet_init

Christophe Leroy <christophe.leroy@c-s.fr>
    net: ucc_geth - fix Oops when changing number of buffers in the ring

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    net: seeq: fix crash caused by not set dev.parent

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

Jan Kara <jack@suse.cz>
    mm/memory.c: fix modifying of page protection by insert_pfn()

Jun Xiao <xiaojun2@hisilicon.com>
    net: hns: Fix WARNING when hns modules installed

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    x86/fpu: Don't export __kernel_fpu_{begin,end}()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix memory leak in SMB2_read

Damian Kos <dkos@cadence.com>
    drm/rockchip: fix for mailbox read validation.

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: warn when expr implements only one of activate/deactivate

KT Liao <kt.liao@emc.com.tw>
    Input: elan_i2c - add hardware ID for multiple Lenovo laptops

Erik Schmauss <erik.schmauss@intel.com>
    ACPICA: Namespace: remove address node from global list after method termination

Matteo Croce <mcroce@redhat.com>
    gtp: change NET_UDP_TUNNEL dependency to select

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix two more memory leaks in cls_tcindex

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: xtfpga.dtsi: fix dtc warnings about SPI

Alexey Brodkin <alexey.brodkin@synopsys.com>
    devres: Align data[] to ARCH_KMALLOC_MINALIGN

Nicolas Pitre <nicolas.pitre@linaro.org>
    vt: always call notifier with the console lock held

Heinrich Schuchardt <xypron.glpk@gmx.de>
    arm64: dts: marvell: armada-ap806: reserve PSCI area

Adit Ranadive <aditr@vmware.com>
    RDMA/vmw_pvrdma: Return the correct opcode when creating WR

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    drm/rockchip: psr: do not dereference encoder before it is null checked.

Jerome Brunet <jbrunet@baylibre.com>
    leds: pwm: silently error out on EPROBE_DEFER

Nicholas Piggin <npiggin@gmail.com>
    powerpc: remove old GCC version checks

Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
    crypto: testmgr - add AES-CFB tests

Marc Zyngier <marc.zyngier@arm.com>
    arm64: KVM: Make VHE Stage-2 TLB invalidation operations non-interruptible

Martin Schwidefsky <schwidefsky@de.ibm.com>
    mm: introduce mm_[p4d|pud|pmd]_folded

Alistair Strachan <astrachan@google.com>
    x86/vdso: Pass --eh-frame-hdr to the linker

Omar Sandoval <osandov@fb.com>
    Btrfs: fix missing delayed iputs on unmount

Thierry Reding <treding@nvidia.com>
    net: stmmac: Move debugfs init/exit to ->probe()/->remove()

Lubomir Rintel <lkundrak@v3.sk>
    staging: olpc_dcon: add a missing dependency

Arnd Bergmann <arnd@arndb.de>
    scsi: raid_attrs: fix unused variable warning

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Downgrade Gen9 Plane WM latency error

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing/fgraph: Fix set_graph_function from showing interrupts

Paolo Abeni <pabeni@redhat.com>
    net: don't keep lonely packets forever in the gro hash

Hugues Fruchet <hugues.fruchet@st.com>
    media: ov5640: fix auto controls values when switching to manual mode

Hugues Fruchet <hugues.fruchet@st.com>
    media: ov5640: fix wrong binning value in exposure calculation

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Disable LP3 watermarks on all SNB machines

Vignesh R <vigneshr@ti.com>
    i2c: omap: Enable for ARCH_K3

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix possibly missed wake-up after abort

Hans Verkuil <hans.verkuil@cisco.com>
    media: adv7842: when the EDID is cleared, unconfigure CEC as well

Hans Verkuil <hans.verkuil@cisco.com>
    media: adv7604: when the EDID is cleared, unconfigure CEC as well

Hans Verkuil <hans.verkuil@cisco.com>
    media: cec: integrate cec_validate_phys_addr() in cec-api.c

Hans Verkuil <hans.verkuil@cisco.com>
    media: cec: make cec_get_edid_spa_location() an inline function

Punit Agrawal <punit.agrawal@arm.com>
    KVM: arm/arm64: Ensure only THP is candidate for adjustment

Goldwyn Rodrigues <rgoldwyn@suse.de>
    ima: open a new file instance if no read permissions

Jason Gunthorpe <jgg@mellanox.com>
    IB/rxe: Revise the ib_wr_opcode enum

Erik Schmauss <erik.schmauss@intel.com>
    ACPICA: AML interpreter: add region addresses in global list during initialization

Tang Junhui <tang.junhui.linux@gmail.com>
    bcache: correct dirty data statistics

Huacai Chen <chenhc@lemote.com>
    MIPS: VDSO: Reduce VDSO_RANDOMIZE_SIZE to 64MB for 64bit

David Miller <davem@redhat.com>
    sparc64: Make corrupted user stacks more debuggable.

David S. Miller <davem@davemloft.net>
    sparc64: Export __node_distance.

Pan Bian <bianpan2016@163.com>
    Input: synaptics-rmi4 - fix possible double free

Daniel Gomez <dagmcr@gmail.com>
    spi: ST ST95HF NFC: declare missing of table

Daniel Gomez <dagmcr@gmail.com>
    spi: Micrel eth switch: declare missing of table

Lucas Stach <l.stach@pengutronix.de>
    drm/imx: don't skip DP channel disable for background plane

Lucas Stach <l.stach@pengutronix.de>
    gpu: ipu-v3: dp: fix CSC handling

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests/net: correct the return value for run_netsocktests

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    drm/sun4i: Set device driver data at bind time for use in unbind

Arnd Bergmann <arnd@arndb.de>
    s390: ctcm: fix ctcm_new_device error return code

Petr Štetiar <ynezz@true.cz>
    MIPS: perf: ath79: Fix perfcount IRQ assignment

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

Rikard Falkeborn <rikard.falkeborn@gmail.com>
    tools lib traceevent: Fix missing equality check for strcmp

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: avoid misreporting level-triggered irqs as edge-triggered in tracing

Paolo Bonzini <pbonzini@redhat.com>
    KVM: fix spectrev1 gadgets

Jian-Hong Pan <jian-hong@endlessm.com>
    x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T

Harald Freudenberger <freude@linux.ibm.com>
    s390/pkey: add one more argument space for debug feature entry

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    mISDN: Check address length before reading address family

Neil Armstrong <narmstrong@baylibre.com>
    clocksource/drivers/oxnas: Fix OX820 compatible

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/3270: fix lockdep false positive on view->lock

Sunil Dutt <usdutt@codeaurora.org>
    nl80211: Add NL80211_FLAG_CLEAR_SKB flag for other NL commands

Felix Fietkau <nbd@nbd.name>
    mac80211: fix memory accounting with A-MSDU aggregation

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

Sven Van Asbroeck <thesven73@gmail.com>
    iio: adc: xilinx: fix potential use-after-free on remove

Johan Hovold <johan@kernel.org>
    USB: serial: fix unthrottle races

Andrea Parri <andrea.parri@amarulasolutions.com>
    kernfs: fix barrier usage in __kernfs_new_node()

Stefan Wahren <stefan.wahren@i2se.com>
    hwmon: (pwm-fan) Disable PWM if fetching cooling data fails

Jiaxun Yang <jiaxun.yang@flygoat.com>
    platform/x86: thinkpad_acpi: Disable Bluetooth for some machines

Gustavo A. R. Silva <gustavo@embeddedor.com>
    platform/x86: sony-laptop: Fix unintentional fall-through

Francesco Ruggeri <fruggeri@arista.com>
    netfilter: compat: initialize all fields in xt_init


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/marvell/armada-ap806.dtsi      |  17 ++
 arch/arm64/kvm/hyp/tlb.c                           |  35 ++-
 arch/mips/ath79/setup.c                            |   6 -
 arch/mips/include/asm/processor.h                  |   2 +-
 arch/powerpc/Makefile                              |  31 +--
 arch/powerpc/include/asm/reg_booke.h               |   2 +-
 arch/powerpc/kernel/idle_book3s.S                  |  20 ++
 arch/powerpc/kernel/security.c                     |   1 +
 arch/sparc/include/asm/switch_to_64.h              |   3 +-
 arch/sparc/kernel/process_64.c                     |  25 +-
 arch/sparc/kernel/rtrap_64.S                       |   1 +
 arch/sparc/kernel/signal32.c                       |  12 +-
 arch/sparc/kernel/signal_64.c                      |   6 +-
 arch/sparc/mm/init_64.c                            |   1 +
 arch/x86/entry/vdso/Makefile                       |   3 +-
 arch/x86/include/asm/efi.h                         |   6 +-
 arch/x86/include/asm/fpu/api.h                     |  15 +-
 arch/x86/kernel/fpu/core.c                         |   6 +-
 arch/x86/kernel/kprobes/core.c                     |  22 +-
 arch/x86/kernel/reboot.c                           |  21 ++
 arch/x86/kvm/lapic.c                               |   4 +-
 arch/x86/kvm/trace.h                               |   4 +-
 arch/xtensa/boot/dts/xtfpga.dtsi                   |   2 +-
 crypto/tcrypt.c                                    |   5 +
 crypto/testmgr.c                                   |   7 +
 crypto/testmgr.h                                   |  76 ++++++
 drivers/acpi/acpica/dsopcode.c                     |   4 +
 drivers/acpi/acpica/nsobject.c                     |   4 +
 drivers/base/devres.c                              |  10 +-
 drivers/clocksource/timer-oxnas-rps.c              |   2 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  45 +++-
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |   2 +-
 drivers/gpu/drm/rockchip/cdn-dp-reg.c              |   2 +-
 drivers/gpu/drm/rockchip/rockchip_drm_psr.c        |   4 +-
 drivers/gpu/drm/sun4i/sun4i_drv.c                  |   2 +
 drivers/gpu/ipu-v3/ipu-dp.c                        |  12 +-
 drivers/hid/hid-input.c                            |  14 +
 drivers/hwmon/pwm-fan.c                            |   2 +-
 drivers/i2c/busses/Kconfig                         |   2 +-
 drivers/iio/adc/xilinx-xadc-core.c                 |   2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h          |  35 ++-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c       |   6 +
 drivers/input/mouse/elan_i2c_core.c                |  25 ++
 drivers/input/rmi4/rmi_driver.c                    |   6 +-
 drivers/irqchip/irq-ath79-misc.c                   |  11 +
 drivers/isdn/mISDN/socket.c                        |   4 +-
 drivers/leds/leds-pwm.c                            |   5 +-
 drivers/md/bcache/super.c                          |   3 +-
 drivers/md/raid5.c                                 |  19 +-
 drivers/media/cec/cec-api.c                        |  19 +-
 drivers/media/cec/cec-edid.c                       |  60 -----
 drivers/media/i2c/adv7604.c                        |   4 +-
 drivers/media/i2c/adv7842.c                        |   4 +-
 drivers/media/i2c/ov5640.c                         |  12 +-
 drivers/net/Kconfig                                |   4 +-
 drivers/net/bonding/bond_options.c                 |   7 -
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |  30 ++-
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c  |   8 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |  15 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   6 +-
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |   2 +-
 drivers/net/ethernet/seeq/sgiseeq.c                |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  23 +-
 drivers/net/phy/spi_ks8995.c                       |   9 +
 drivers/net/wireless/marvell/mwl8k.c               |  13 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |   1 +
 drivers/net/wireless/st/cw1200/scan.c              |   5 +-
 drivers/nfc/st95hf/core.c                          |   7 +
 drivers/nvdimm/btt_devs.c                          |  18 +-
 drivers/nvdimm/namespace_devs.c                    |   5 +-
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
 drivers/scsi/raid_class.c                          |   4 +-
 drivers/staging/olpc_dcon/Kconfig                  |   1 +
 drivers/tty/vt/vt.c                                |   2 +-
 drivers/usb/serial/generic.c                       |  39 ++-
 drivers/virt/fsl_hypervisor.c                      |  29 ++-
 fs/btrfs/disk-io.c                                 |  51 ++--
 fs/cifs/smb2pdu.c                                  |   1 +
 fs/fuse/dev.c                                      |  12 +-
 fs/kernfs/dir.c                                    |   5 +-
 include/asm-generic/pgtable.h                      |  16 ++
 include/linux/efi.h                                |   7 +-
 include/linux/kvm_host.h                           |  10 +-
 include/media/cec.h                                |  70 +++++
 include/net/netfilter/nf_conntrack.h               |   2 +
 include/net/nfc/nci_core.h                         |   2 +-
 include/rdma/ib_verbs.h                            |  34 ++-
 include/uapi/rdma/ib_user_verbs.h                  |  20 +-
 include/uapi/rdma/vmw_pvrdma-abi.h                 |   1 +
 init/main.c                                        |   4 +-
 kernel/trace/trace.h                               |  57 ++++-
 kernel/trace/trace_functions_graph.c               |   4 +
 kernel/trace/trace_irqsoff.c                       |   2 +
 kernel/trace/trace_sched_wakeup.c                  |   2 +
 mm/memory.c                                        |  11 +-
 mm/vmscan.c                                        |  29 +--
 net/8021q/vlan_dev.c                               |   4 +-
 net/bridge/br_if.c                                 |  13 +-
 net/core/dev.c                                     |   7 +-
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
 net/netfilter/nf_tables_api.c                      |  19 ++
 net/netfilter/x_tables.c                           |   2 +-
 net/nfc/nci/hci.c                                  |   8 +
 net/packet/af_packet.c                             |  25 +-
 net/sched/cls_tcindex.c                            |  16 +-
 net/tipc/socket.c                                  |   4 +-
 net/wireless/nl80211.c                             |  18 +-
 security/integrity/ima/ima_crypto.c                |  54 ++--
 tools/lib/traceevent/event-parse.c                 |   2 +-
 tools/testing/selftests/net/run_netsocktests       |   2 +-
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 .../selftests/netfilter/conntrack_icmp_related.sh  | 283 +++++++++++++++++++++
 virt/kvm/arm/mmu.c                                 |   8 +-
 virt/kvm/irqchip.c                                 |   5 +-
 virt/kvm/kvm_main.c                                |   6 +-
 136 files changed, 1457 insertions(+), 462 deletions(-)


