Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 000521F05A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732176AbfEOL1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732190AbfEOL1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:27:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F3C720862;
        Wed, 15 May 2019 11:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919631;
        bh=jCJXHcoMEcOub8yAFkPPoCvLawOu3qj1HVX3rzQhquI=;
        h=From:To:Cc:Subject:Date:From;
        b=Y7DHMvtPdGmzJPGC+je8/zOvrdxbiuq5aKR+1R54NxOKM04NMXgSQwGuW1nKh72dc
         +Sq7ZMKwzjRF2WXWczX91gIQUFLx1tlGwvyKmhwyMg/33eXZsQO69JjroQkn9ce9td
         acEtYBH+lL6t1I/7qD9KyHKaPn4rR1YeQdBkMAEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.0 000/137] 5.0.17-stable review
Date:   Wed, 15 May 2019 12:54:41 +0200
Message-Id: <20190515090651.633556783@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.0.17-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.0.17-rc1
X-KernelTest-Deadline: 2019-05-17T09:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.0.17 release.
There are 137 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 17 May 2019 09:04:31 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.17-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.0.17-rc1

Damien Le Moal <damien.lemoal@wdc.com>
    f2fs: Fix use of number of devices

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Add pci_destroy_slot() in pci_devices_present_work(), if necessary

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Add hv_pci_remove_slots() when we unload the driver

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Fix a memory leak in hv_eject_device_work()

YueHaibing <yuehaibing@huawei.com>
    virtio_ring: Fix potential mem leak in virtqueue_add_indirect_packed

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

Paul Bolle <pebolle@tiscali.nl>
    isdn: bas_gigaset: use usb_fill_int_urb() properly

Eric Dumazet <edumazet@google.com>
    flow_dissector: disable preemption around BPF calls

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fix phy_validate_pause

Jason Wang <jasowang@redhat.com>
    tuntap: synchronize through tfiles array instead of tun->numqueues

Jason Wang <jasowang@redhat.com>
    tuntap: fix dividing by zero in ebpf queue selection

Oliver Neukum <oneukum@suse.com>
    aqc111: fix double endianness swap on BE

Oliver Neukum <oneukum@suse.com>
    aqc111: fix writing to the phy on BE

Oliver Neukum <oneukum@suse.com>
    aqc111: fix endianness issue in aqc111_change_mtu

Stephen Suryaputra <ssuryaextr@gmail.com>
    vrf: sit mtu should not be updated when vrf netdev is the link

Hangbin Liu <liuhangbin@gmail.com>
    vlan: disable SIOCSHWTSTAMP in container

Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>
    tipc: fix hanging clients using poll with EPOLLOUT flag

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

Nigel Croxon <ncroxon@redhat.com>
    Don't jump to compute_result state from check_result state

Gustavo A. R. Silva <gustavo@embeddedor.com>
    rtlwifi: rtl8723ae: Fix missing break in switch statement

Petr Štetiar <ynezz@true.cz>
    mwl8k: Fix rate_idx underflow

Wei Yongjun <weiyongjun1@huawei.com>
    cw1200: fix missing unlock on error in cw1200_hw_scan()

Damian Kos <dkos@cadence.com>
    drm/rockchip: fix for mailbox read validation.

Antoine Tenart <antoine.tenart@bootlin.com>
    net: mvpp2: fix validate for PPv2.1

John Hurley <john.hurley@netronome.com>
    net: sched: fix cleanup NULL pointer exception in act_mirr

Willem de Bruijn <willemb@google.com>
    bpf: only test gso type on gso packets

Andrey Ryabinin <aryabinin@virtuozzo.com>
    mm/page_alloc.c: avoid potential NULL pointer dereference

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug.c: drop memory device reference after find_memory_block()

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Bugfix for mapping user db

Geert Uytterhoeven <geert+renesas@glider.be>
    gpio: Fix gpiochip_add_data_with_key() error path

Miaohe Lin <linmiaohe@huawei.com>
    net: vrf: Fix operation not supported when set vrf mac

Pan Bian <bianpan2016@163.com>
    Input: synaptics-rmi4 - fix possible double free

Jacky Bai <ping.bai@nxp.com>
    Input: snvs_pwrkey - make it depend on ARCH_MXC

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    drm/sun4i: Unbind components before releasing DRM and memory

Dave Airlie <airlied@redhat.com>
    Revert "drm/virtio: drop prime import/export callbacks"

Jeff Layton <jlayton@kernel.org>
    ceph: handle the case where a dentry has been renamed on outstanding req

Daniel Gomez <dagmcr@gmail.com>
    spi: ST ST95HF NFC: declare missing of table

Daniel Gomez <dagmcr@gmail.com>
    spi: Micrel eth switch: declare missing of table

Tigran Tadevosyan <tigran.tadevosyan@arm.com>
    ARM: 8856/1: NOMMU: Fix CCR register faulty initialization when MPU is disabled

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: fix function graph tracer and unwinder dependencies

Lucas Stach <l.stach@pengutronix.de>
    drm/imx: don't skip DP channel disable for background plane

Lucas Stach <l.stach@pengutronix.de>
    gpu: ipu-v3: dp: fix CSC handling

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    arm64/module: ftrace: deal with place relative nature of PLTs

Stefan Wahren <stefan.wahren@i2se.com>
    dmaengine: bcm2835: Avoid GFP_KERNEL in device_prep_slave_sg

Andrei Vagin <avagin@gmail.com>
    netfilter: fix nf_l4proto_log_invalid to log invalid packets

Florian Westphal <fw@strlen.de>
    netfilter: never get/set skb->tstamp

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests/net: correct the return value for run_afpackettests

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests/net: correct the return value for run_netsocktests

Petr Štetiar <ynezz@true.cz>
    of_net: Fix residues after of_get_nvmem_mac_address removal

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    drm/sun4i: Fix component unbinding and component master deletion

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    drm/sun4i: Set device driver data at bind time for use in unbind

Arnd Bergmann <arnd@arndb.de>
    s390: ctcm: fix ctcm_new_device error return code

Guy Levi <guyle@mellanox.com>
    IB/mlx5: Fix scatter to CQE in DCT QP creation

Petr Štetiar <ynezz@true.cz>
    MIPS: perf: ath79: Fix perfcount IRQ assignment

Florian Westphal <fw@strlen.de>
    netfilter: nat: fix icmp id randomization

Dan Carpenter <dan.carpenter@oracle.com>
    netfilter: nf_tables: prevent shift wrap in nft_chain_parse_hook()

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: don't use conntrack/expect object addresses as id

Julian Anastasov <ja@ssi.bg>
    ipvs: do not schedule icmp errors from tunnels

Florian Westphal <fw@strlen.de>
    selftests: netfilter: check icmp pkttoobig errors are set as related

Jonas Karlman <jonas@kwiboo.se>
    drm: bridge: dw-hdmi: Fix overflow workaround for Rockchip SoCs

Dan Williams <dan.j.williams@intel.com>
    init: initialize jump labels before command line option parsing

Johannes Weiner <hannes@cmpxchg.org>
    mm: fix inactive list balancing between NUMA nodes and cgroups

Qian Cai <cai@lca.pw>
    mm/hotplug: treat CMA pages as unmovable

Qian Cai <cai@lca.pw>
    slab: store tagged freelist for off-slab slabmgmt

Christoph Hellwig <hch@lst.de>
    scsi: aic7xxx: fix EISA support

Jiri Olsa <jolsa@kernel.org>
    perf tools: Fix map reference counting

Claudiu Manoil <claudiu.manoil@nxp.com>
    ocelot: Don't sleep in atomic context (irqs_disabled())

Tony Camuso <tcamuso@redhat.com>
    ipmi: ipmi_si_hardcode.c: init si_type array to fix a crash

Jiri Olsa <jolsa@kernel.org>
    perf top: Always sample time to satisfy needs of use of ordered queuing

Rikard Falkeborn <rikard.falkeborn@gmail.com>
    tools lib traceevent: Fix missing equality check for strcmp

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: avoid misreporting level-triggered irqs as edge-triggered in tracing

Paolo Bonzini <pbonzini@redhat.com>
    KVM: fix spectrev1 gadgets

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: always use early vmcs check when EPT is disabled

Jian-Hong Pan <jian-hong@endlessm.com>
    x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T

Thomas Gleixner <tglx@linutronix.de>
    x86/mm: Prevent bogus warnings with "noexec=off"

Sami Tolvanen <samitolvanen@google.com>
    x86/build/lto: Fix truncated .bss with -fdata-sections

Harald Freudenberger <freude@linux.ibm.com>
    s390/pkey: add one more argument space for debug feature entry

David Francis <David.Francis@amd.com>
    drm/amd/display: If one stream full updates, full update all planes

Denis Bolotin <dbolotin@marvell.com>
    qed: Fix the DORQ's attentions handling

Denis Bolotin <dbolotin@marvell.com>
    qed: Fix missing DORQ attentions

Denis Bolotin <dbolotin@marvell.com>
    qed: Fix the doorbell address sanity check

Denis Bolotin <dbolotin@marvell.com>
    qed: Delete redundant doorbell recovery types

David Howells <dhowells@redhat.com>
    afs: Fix in-progess ops to ignore server-level callback invalidation

Marc Dionne <marc.dionne@auristor.com>
    afs: Unlock pages for __pagevec_release()

Colin Ian King <colin.king@canonical.com>
    qede: fix write to free'd pointer error and double free of ptp

Colin Ian King <colin.king@canonical.com>
    vxge: fix return of a free'd memblock on a failed dma mapping

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    mISDN: Check address length before reading address family

wentalou <Wentao.Lou@amd.com>
    drm/amdgpu: shadow in shadow_list without tbo.mem.start cause page fault in sriov TDR

David Ahern <dsahern@gmail.com>
    selftests: fib_tests: Fix 'Command line is not complete' errors

Neil Armstrong <narmstrong@baylibre.com>
    clocksource/drivers/oxnas: Fix OX820 compatible

Arnd Bergmann <arnd@arndb.de>
    clocksource/drivers/npcm: select TIMER_OF

Martin Leung <martin.leung@amd.com>
    drm/amd/display: extending AUX SW Timeout

Lin Yi <teroincn@163.com>
    drm/ttm: fix dma_fence refcount imbalance on error path

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/3270: fix lockdep false positive on view->lock

Dave Jiang <dave.jiang@intel.com>
    tools/testing/nvdimm: Retain security state after overwrite

Li RongQing <lirongqing@baidu.com>
    libnvdimm/pmem: fix a possible OOB access when read and write pmem

Dave Jiang <dave.jiang@intel.com>
    libnvdimm/security: provide fix for secure-erase to use zero-key

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

Kees Cook <keescook@chromium.org>
    selftests/seccomp: Handle namespace failures gracefully

Lei YU <mine260309@gmail.com>
    hwmon: (occ) Fix extended status bits

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

 .../devicetree/bindings/net/davinci_emac.txt       |   2 +
 Documentation/devicetree/bindings/net/ethernet.txt |   2 -
 Documentation/devicetree/bindings/net/macb.txt     |   4 +
 Makefile                                           |   4 +-
 arch/arm/Kconfig                                   |   2 +-
 arch/arm/Kconfig.debug                             |   6 +-
 arch/arm/kernel/head-nommu.S                       |   2 +-
 arch/arm64/kernel/ftrace.c                         |   9 +-
 arch/mips/ath79/setup.c                            |   6 -
 arch/powerpc/include/asm/book3s/64/pgalloc.h       |   3 +
 arch/powerpc/include/asm/reg_booke.h               |   2 +-
 arch/powerpc/kernel/idle_book3s.S                  |  20 ++
 arch/x86/include/uapi/asm/vmx.h                    |   1 +
 arch/x86/kernel/reboot.c                           |  21 ++
 arch/x86/kernel/vmlinux.lds.S                      |   2 +-
 arch/x86/kvm/lapic.c                               |   4 +-
 arch/x86/kvm/trace.h                               |   4 +-
 arch/x86/kvm/vmx/nested.c                          |  22 +-
 arch/x86/mm/dump_pagetables.c                      |   3 +-
 arch/x86/mm/ioremap.c                              |   2 +-
 block/bfq-iosched.c                                |   8 +-
 block/blk-mq.c                                     |   2 +
 drivers/acpi/nfit/core.c                           |  12 +-
 drivers/char/ipmi/ipmi_si_hardcode.c               |   2 +
 drivers/clocksource/Kconfig                        |   1 +
 drivers/clocksource/timer-oxnas-rps.c              |   2 +-
 drivers/dma/bcm2835-dma.c                          |   2 +-
 drivers/gpio/gpiolib.c                             |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   1 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  19 ++
 drivers/gpu/drm/amd/display/dc/dc.h                |   3 +
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.c       |   9 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.h       |   6 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |   4 +
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |   2 +-
 drivers/gpu/drm/rockchip/cdn-dp-reg.c              |   2 +-
 drivers/gpu/drm/sun4i/sun4i_drv.c                  |   7 +
 drivers/gpu/drm/ttm/ttm_bo.c                       |   4 +-
 drivers/gpu/drm/virtio/virtgpu_drv.c               |   4 +
 drivers/gpu/drm/virtio/virtgpu_drv.h               |   4 +
 drivers/gpu/drm/virtio/virtgpu_prime.c             |  12 +
 drivers/gpu/ipu-v3/ipu-dp.c                        |  12 +-
 drivers/hid/hid-input.c                            |  14 +
 drivers/hwmon/occ/sysfs.c                          |   8 +-
 drivers/hwmon/pwm-fan.c                            |   2 +-
 drivers/iio/adc/xilinx-xadc-core.c                 |   3 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   2 +-
 drivers/infiniband/hw/mlx5/main.c                  |   2 +
 drivers/infiniband/hw/mlx5/qp.c                    |  11 +-
 drivers/input/keyboard/Kconfig                     |   2 +-
 drivers/input/rmi4/rmi_driver.c                    |   6 +-
 drivers/irqchip/irq-ath79-misc.c                   |  11 +
 drivers/isdn/gigaset/bas-gigaset.c                 |   9 +-
 drivers/isdn/mISDN/socket.c                        |   4 +-
 drivers/md/raid5.c                                 |  19 +-
 drivers/net/bonding/bond_options.c                 |   7 -
 drivers/net/ethernet/cadence/macb_main.c           |   6 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   2 +-
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c  |   8 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   2 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.c   |   1 +
 drivers/net/ethernet/qlogic/qed/qed.h              |   7 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  85 +++----
 drivers/net/ethernet/qlogic/qed/qed_int.c          |  83 ++++--
 drivers/net/ethernet/qlogic/qed/qed_int.h          |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c         |   2 +-
 drivers/net/ethernet/qlogic/qede/qede_ptp.c        |   7 +-
 drivers/net/ethernet/seeq/sgiseeq.c                |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   2 +
 drivers/net/phy/phy_device.c                       |  11 +-
 drivers/net/phy/spi_ks8995.c                       |   9 +
 drivers/net/tun.c                                  |  14 +-
 drivers/net/usb/aqc111.c                           |  31 ++-
 drivers/net/vrf.c                                  |   2 +
 drivers/net/wireless/marvell/mwl8k.c               |  13 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |   1 +
 drivers/net/wireless/st/cw1200/scan.c              |   5 +-
 drivers/nfc/st95hf/core.c                          |   7 +
 drivers/nvdimm/btt_devs.c                          |  18 +-
 drivers/nvdimm/namespace_devs.c                    |   5 +-
 drivers/nvdimm/pmem.c                              |   8 +-
 drivers/nvdimm/security.c                          |  17 +-
 drivers/of/of_net.c                                |   1 -
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
 drivers/virt/fsl_hypervisor.c                      |  29 ++-
 drivers/virt/vboxguest/vboxguest_core.c            |  31 +++
 drivers/virtio/virtio_ring.c                       |   1 +
 fs/afs/callback.c                                  |   3 +-
 fs/afs/internal.h                                  |   4 +-
 fs/afs/server.c                                    |   1 -
 fs/afs/write.c                                     |   1 +
 fs/ceph/inode.c                                    |  16 +-
 fs/f2fs/data.c                                     |  17 +-
 fs/f2fs/f2fs.h                                     |  13 +-
 fs/f2fs/file.c                                     |   2 +-
 fs/f2fs/gc.c                                       |   2 +-
 fs/f2fs/segment.c                                  |  13 +-
 fs/kernfs/dir.c                                    |   5 +-
 include/linux/efi.h                                |   7 +-
 include/linux/elevator.h                           |   1 +
 include/linux/kvm_host.h                           |  10 +-
 include/linux/skbuff.h                             |   4 +-
 include/net/netfilter/nf_conntrack.h               |   2 +
 include/uapi/rdma/mlx5-abi.h                       |   1 +
 init/main.c                                        |   4 +-
 mm/memory_hotplug.c                                |   1 +
 mm/page_alloc.c                                    |  33 ++-
 mm/slab.c                                          |   1 -
 mm/vmscan.c                                        |  29 +--
 net/8021q/vlan_dev.c                               |   4 +-
 net/bridge/br_if.c                                 |  13 +-
 net/core/fib_rules.c                               |   6 +-
 net/core/filter.c                                  |   8 +-
 net/core/flow_dissector.c                          |   3 +
 net/dsa/dsa.c                                      |  11 +-
 net/ipv4/raw.c                                     |   4 +-
 net/ipv6/sit.c                                     |   2 +-
 net/mac80211/mesh_pathtbl.c                        |   2 +-
 net/mac80211/trace_msg.h                           |   7 +-
 net/mac80211/tx.c                                  |   3 +
 net/netfilter/ipvs/ip_vs_core.c                    |   2 +-
 net/netfilter/nf_conntrack_core.c                  |  42 ++-
 net/netfilter/nf_conntrack_netlink.c               |  34 ++-
 net/netfilter/nf_conntrack_proto.c                 |   2 +-
 net/netfilter/nf_nat_core.c                        |  11 +-
 net/netfilter/nf_tables_api.c                      |   2 +-
 net/netfilter/nfnetlink_log.c                      |   2 +-
 net/netfilter/nfnetlink_queue.c                    |   2 +-
 net/netfilter/xt_time.c                            |  23 +-
 net/packet/af_packet.c                             |  25 +-
 net/sched/act_mirred.c                             |   3 +
 net/tipc/socket.c                                  |   4 +-
 net/wireless/nl80211.c                             |  18 +-
 net/wireless/reg.c                                 |  39 +++
 security/selinux/hooks.c                           |   8 +-
 tools/lib/traceevent/event-parse.c                 |   2 +-
 tools/perf/builtin-top.c                           |   1 +
 tools/perf/util/map.c                              |   4 +-
 tools/testing/nvdimm/test/nfit.c                   |  17 +-
 tools/testing/selftests/net/fib_tests.sh           |  94 +++----
 tools/testing/selftests/net/run_afpackettests      |   5 +
 tools/testing/selftests/net/run_netsocktests       |   2 +-
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 .../selftests/netfilter/conntrack_icmp_related.sh  | 283 +++++++++++++++++++++
 tools/testing/selftests/netfilter/nft_nat.sh       |  36 ++-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |  43 ++--
 virt/kvm/irqchip.c                                 |   5 +-
 virt/kvm/kvm_main.c                                |   6 +-
 165 files changed, 1407 insertions(+), 495 deletions(-)


