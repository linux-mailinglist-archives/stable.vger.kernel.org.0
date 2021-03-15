Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D0533B61D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhCON5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhCON4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4944864DAD;
        Mon, 15 Mar 2021 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816605;
        bh=H/nfAk8hahJLQAZfoM/kVvZJc/O7/EnZrPWJc4dISjc=;
        h=From:To:Cc:Subject:Date:From;
        b=iBiq5eTR9v5vpb5UBqwYI6JxnZVJBuIu+aztaDYOJdjJ9ot5WJqrv3uE9ar5529G4
         h+G3fU8dvIaztvXHFbp8IO1U8ZYFuCO49X3AWftjnSGiEWEk9xa11X+wAxdKJrHHSR
         WNbBMSn6Cf21ZQ7QbWAgtXDJ2zfu89PfBhAtsvII=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 000/168] 5.4.106-rc1 review
Date:   Mon, 15 Mar 2021 14:53:52 +0100
Message-Id: <20210315135550.333963635@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.106-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.106-rc1
X-KernelTest-Deadline: 2021-03-17T13:55+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 5.4.106 release.
There are 168 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 17 Mar 2021 13:55:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.106-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.106-rc1

Juergen Gross <jgross@suse.com>
    xen/events: avoid handling the same event on two cpus at the same time

Juergen Gross <jgross@suse.com>
    xen/events: don't unmask an event channel when an eoi is pending

Juergen Gross <jgross@suse.com>
    xen/events: reset affinity of 2-level event when tearing it down

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Reject VM creation when the default IPA size is unsupported

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Ensure I-cache isolation between vcpus of a same VM

Keith Busch <kbusch@kernel.org>
    nvme: release namespace head reference on error

Keith Busch <kbusch@kernel.org>
    nvme: unlink head after removing last namespace

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix exclusive limit for IPA size

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind/orc: Disable KASAN checking in the ORC unwinder, part 2

Lior Ribak <liorribak@gmail.com>
    binfmt_misc: fix possible deadlock in bm_register_write

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/64s: Fix instruction encoding for lis in ppc_function_entry()

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    sched/membarrier: fix missing local execution of ipi_sync_rq_state()

Minchan Kim <minchan@kernel.org>
    zram: fix return value on writeback_store

Alexey Dobriyan <adobriyan@gmail.com>
    prctl: fix PR_SET_MM_AUXV kernel stack leak

Matthew Wilcox (Oracle) <willy@infradead.org>
    include/linux/sched/mm.h: use rcu_dereference in in_vfork()

Arnd Bergmann <arnd@arndb.de>
    stop_machine: mark helpers __always_inline

Anna-Maria Behnsen <anna-maria@linutronix.de>
    hrtimer: Update softirq_expires_next correctly after __hrtimer_get_next_event()

Ard Biesheuvel <ardb@kernel.org>
    arm64: mm: use a 48-bit ID map when possible on 52-bit VA builds

Daiyue Zhang <zhangdaiyue1@huawei.com>
    configfs: fix a use-after-free in __configfs_open_file

Jia-Ju Bai <baijiaju1990@gmail.com>
    block: rsxx: fix error return code of rsxx_pci_probe()

Ondrej Mosnacek <omosnace@redhat.com>
    NFSv4.2: fix return value of _nfs4_get_security_label()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't gratuitously clear the inode cache when lookup failed

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't revalidate the directory permissions on a lookup failure

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Set memalloc_nofs_save() for sync tasks

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: Fix pfn_valid() for ZONE_DEVICE based memory

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    sh_eth: fix TRSCER mask for R7S72100

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: pcl818: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: pcl711: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: me4000: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: dmm32at: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: das800: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: das6402: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: adv_pci1710: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1500: Fix endian problem for command sample

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1032: Fix endian problem for COS sample

Lee Gibson <leegib@gmail.com>
    staging: rtl8192e: Fix possible buffer overflow in _rtl92e_wx_set_scan

Lee Gibson <leegib@gmail.com>
    staging: rtl8712: Fix possible buffer overflow in r8712_sitesurvey_cmd

Dan Carpenter <dan.carpenter@oracle.com>
    staging: ks7010: prevent buffer overflow in ks_wlan_set_scan()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8188eu: fix potential memory corruption in rtw_check_beacon_data()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8712: unterminated string leads to read overflow

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8188eu: prevent ->ssid overflow in rtw_wx_set_scan()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8192u: fix ->ssid overflow in r8192_wx_set_scan()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    misc: fastrpc: restrict user apps from sending kernel RPC messages

Shile Zhang <shile.zhang@linux.alibaba.com>
    misc/pvpanic: Export module FDT device table

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix vudc usbip_sockfd_store races leading to gpf

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix vhci_hcd attach_store() races leading to gpf

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix stub_dev usbip_sockfd_store() races leading to gpf

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix vudc to check for stream socket

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix vhci_hcd to check for stream socket

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix stub_dev to check for stream socket

Sebastian Reichel <sebastian.reichel@collabora.com>
    USB: serial: cp210x: add some more GE USB IDs

Karan Singhal <karan.singhal@acuitybrands.com>
    USB: serial: cp210x: add ID for Acuity Brands nLight Air Adapter

Niv Sardi <xaiki@evilgiggle.com>
    USB: serial: ch341: add new Product ID

Pavel Skripkin <paskripkin@gmail.com>
    USB: serial: io_edgeport: fix memory leak in edge_startup

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix repeated xhci wake after suspend due to uncleared internal wake state

Forest Crossman <cyrozap@gmail.com>
    usb: xhci: Fix ASMedia ASM1042A and ASM3242 DMA addressing

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Improve detection of device initiated wake signal.

Stanislaw Gruszka <stf_xl@wp.pl>
    usb: xhci: do not perform Soft Retry for some xHCI hosts

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: renesas_usbhs: Clear PIPECFG for re-enabling pipe with other EPNUM

Pete Zaitcev <zaitcev@redhat.com>
    USB: usblp: fix a hang in poll() if disconnected

Matthias Kaehlcke <mka@chromium.org>
    usb: dwc3: qcom: Honor wakeup enabled/disabled state

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    usb: dwc3: qcom: Add missing DWC3 OF node refcount decrement

Ruslan Bilovol <ruslan.bilovol@gmail.com>
    usb: gadget: f_uac1: stop playback on function disable

Ruslan Bilovol <ruslan.bilovol@gmail.com>
    usb: gadget: f_uac2: always increase endpoint max_packet_size by one audio slot

Dan Carpenter <dan.carpenter@oracle.com>
    USB: gadget: u_ether: Fix a configfs return code

Yorick de Wid <ydewid@gmail.com>
    Goodix Fingerprint device is not a modem

Frank Li <lznuaa@gmail.com>
    mmc: cqhci: Fix random crash when remove mmc module/card

Adrian Hunter <adrian.hunter@intel.com>
    mmc: core: Fix partition switch time for eMMC

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    software node: Fix node registration

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix hanging IO request during DASD driver unbind

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix hanging DASD driver unbind

Andrey Konovalov <andreyknvl@google.com>
    arm64: kasan: fix page_alloc tagging with DEBUG_VIRTUAL

Eric W. Biederman <ebiederm@xmission.com>
    Revert 95ebabde382c ("capabilities: Don't allow writing ambiguous v3 file capabilities")

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Apply the control quirk to Plantronics headsets

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix "cannot get freq eq" errors on Dell AE515 sound bar

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Avoid spurious unsol event handling during S3/S4

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Flush pending unsolicited events before suspend

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Drop the BATCH workaround for AMD controllers

Simeon Simeonoff <sim.simeonoff@gmail.com>
    ALSA: hda/ca0132: Add Sound BlasterX AE-5 Plus support

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Cancel pending works before suspend

John Ernberg <john.ernberg@actia.se>
    ALSA: usb: Add Plantronics C320-M USB ctrl msg delay quirk

Aleksandr Miloserdov <a.miloserdov@yadro.com>
    scsi: target: core: Prevent underflow for service actions

Aleksandr Miloserdov <a.miloserdov@yadro.com>
    scsi: target: core: Add cmd length set before cmd complete

Mike Christie <michael.christie@oracle.com>
    scsi: libiscsi: Fix iscsi_prep_scsi_cmd_pdu() error handling

Lin Feng <linf@wangsu.com>
    sysctl.c: fix underflow value setting risk in vm_table

Heiko Carstens <hca@linux.ibm.com>
    s390/smp: __smp_rescan_cpus() - move cpumask away from stack

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    i40e: Fix memory leak in i40e_probe

Geert Uytterhoeven <geert+renesas@glider.be>
    PCI: Fix pci_register_io_range() memory leak

Sasha Levin <sashal@kernel.org>
    kbuild: clamp SUBLEVEL to 255

Krzysztof Wilczyński <kw@linux.com>
    PCI: mediatek: Add missing of_node_put() to fix reference leak

Martin Kaiser <martin@kaiser.cx>
    PCI: xgene-msi: Fix race in installing chained irq handler

Ronald Tschalär <ronald@innovation.ch>
    Input: applespi - don't wait for responses to commands indefinitely.

Khalid Aziz <khalid.aziz@oracle.com>
    sparc64: Use arch_validate_flags() to validate ADI flag

Andreas Larsson <andreas@gaisler.com>
    sparc32: Limit memblock allocation to low memory

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Fix performance counter initialization

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64: Fix stack trace not displaying final frame

Filipe Laíns <lains@riseup.net>
    HID: logitech-dj: add support for the new lightspeed connection iteration

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Record counter overflow always if SAMPLE_IP is unset

Nicholas Piggin <npiggin@gmail.com>
    powerpc: improve handling of unrecoverable system reset

Alain Volmat <alain.volmat@foss.st.com>
    spi: stm32: make spurious and overrun interrupts visible

Oliver O'Halloran <oohall@gmail.com>
    powerpc/pci: Add ppc_md.discover_phbs()

Lubomir Rintel <lkundrak@v3.sk>
    Platform: OLPC: Fix probe error handling

Chaotian Jing <chaotian.jing@mediatek.com>
    mmc: mediatek: fix race condition between msdc_request_timeout and irq

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: mxs-mmc: Fix a resource leak in an error handling path in 'mxs_mmc_probe()'

Steven J. Magnani <magnani@ieee.org>
    udf: fix silent AED tagLocation corruption

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: optimize cacheline to minimize HW race condition

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: faster irq code to minimize HW race condition

Guangbin Huang <huangguangbin2@huawei.com>
    net: phy: fix save wrong speed and duplex problem if autoneg is on

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: initialize RFS/RSS memories for unused ports too

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix error mask definition of flow director

Hans Verkuil <hverkuil@xs4all.nl>
    media: rc: compile rc-cec.c into rc-core

Biju Das <biju.das.jz@bp.renesas.com>
    media: v4l: vsp1: Fix bru null pointer access

Biju Das <biju.das.jz@bp.renesas.com>
    media: v4l: vsp1: Fix uif null pointer access

Maxim Mikityanskiy <maxtram95@gmail.com>
    media: usbtv: Fix deadlock on suspend

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    sh_eth: fix TRSCER mask for R7S9210

Colin Ian King <colin.king@canonical.com>
    qxl: Fix uninitialised struct field head.surface_id

Wang Qing <wangqing@vivo.com>
    s390/crypto: return -EFAULT if copy_to_user() fails

Eric Farman <farman@linux.ibm.com>
    s390/cio: return -EFAULT if copy_to_user() fails

Artem Lapkin <art@khadas.com>
    drm: meson_drv add shutdown function

Neil Roberts <nroberts@igalia.com>
    drm/shmem-helper: Don't remove the offset in vm_area_struct pgoff

Neil Roberts <nroberts@igalia.com>
    drm/shmem-helper: Check for purged buffers in fault handler

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/compat: Clear bounce structures

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: reliably allocate IRQ table on reset to avoid crash

Wang Qing <wangqing@vivo.com>
    s390/cio: return -EFAULT if copy_to_user() fails again

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix bug when calculating the TCAM table info

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix query vlan mask value error for flow director

Ian Rogers <irogers@google.com>
    perf traceevent: Ensure read cmdlines are null terminated.

Danielle Ratson <danieller@nvidia.com>
    selftests: forwarding: Fix race condition in mirror installation

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: fix watchdog timeout during suspend/resume stress test

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: stop each tx channel independently

Antony Antony <antony@phenome.org>
    ixgbe: fail to create xfrm offload of IPsec tunnel mode SA

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: qrtr: fix error return code of qrtr_sendmsg()

Paul Cercueil <paul@crapouillou.net>
    net: davicom: Fix regulator not turned off on driver removal

Paul Cercueil <paul@crapouillou.net>
    net: davicom: Fix regulator not turned off on failed probe

Xie He <xie.he.0141@gmail.com>
    net: lapbether: Remove netif_start_queue / netif_stop_queue

Paul Moore <paul@paul-moore.com>
    cipso,calipso: resolve a number of problems with the DOI refcounts

Hillf Danton <hdanton@sina.com>
    netdevsim: init u64 stats for 32bit hardware

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: allow qmimux add/del with master up

Maximilian Heyne <mheyne@amazon.de>
    net: sched: avoid duplicates in classes dump

Ido Schimmel <idosch@nvidia.com>
    nexthop: Do not flush blackhole nexthops when loopback goes down

Ong Boon Leong <boon.leong.ong@intel.com>
    net: stmmac: fix incorrect DMA channel intr enable setting of EQoS v4.10

Kevin(Yudong) Yang <yyd@google.com>
    net/mlx4_en: update moderation when config reset

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: don't overwrite the RSS indirection table when initializing

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "mm, slub: consider rest of partial list if acquire_slab() fails"

Paulo Alcantara <pc@cjr.nz>
    cifs: return proper error code in statfs(2)

Christian Brauner <christian.brauner@ubuntu.com>
    mount: fix mounting of detached mounts onto targets that reside on shared mounts

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/603: Fix protection of user pages mapped with PROT_NONE

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: dma: do not report truncated frames to mac80211

Jiri Wiesner <jwiesner@suse.com>
    ibmvnic: always store valid MAC address

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    samples, bpf: Add missing munmap in xdpsock

Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
    selftests/bpf: Mask bpf_csum_diff() return value to 16 bits in test_verifier

Hangbin Liu <liuhangbin@gmail.com>
    selftests/bpf: No need to drop the packet when there is no geneve opt

Vasily Averin <vvs@virtuozzo.com>
    netfilter: x_tables: gpf inside xt_find_revision()

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat: undo erroneous tcp edemux lookup

Eric Dumazet <edumazet@google.com>
    tcp: add sanity tests to TCP_QUEUE_SEQ

Torin Cooper-Bennun <torin@maxiluxsystems.com>
    can: tcan4x5x: tcan4x5x_init(): fix initialization - clear MRAM before entering Normal Mode

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: invoke flexcan_chip_freeze() to enter freeze mode

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: enable RX FIFO after FRZ/HALT valid

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: assert FRZ bit in flexcan_chip_freeze()

Oleksij Rempel <linux@rempel-privat.de>
    can: skb: can_skb_set_owner(): fix ref counting if socket was closed before setting skb ownership

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    sh_eth: fix TRSCER mask for SH771x

Balazs Nemeth <bnemeth@redhat.com>
    net: avoid infinite loop in mpls_gso_segment when mpls_hlen == 0

Balazs Nemeth <bnemeth@redhat.com>
    net: check if protocol extracted by virtio_net_hdr_set_proto is correct

Daniel Borkmann <daniel@iogearbox.net>
    net: Fix gro aggregation for udp encaps with zero csum

Felix Fietkau <nbd@nbd.name>
    ath9k: fix transmitting to stations in dynamic SMPS mode

Jakub Kicinski <kuba@kernel.org>
    ethernet: alx: fix order of calls on resume

Greg Kurz <groug@kaod.org>
    powerpc/pseries: Don't enforce MSI affinity with kdump

Dmitry V. Levin <ldv@altlinux.org>
    uapi: nfnetlink_cthelper.h: fix userspace compilation error


-------------

Diffstat:

 Documentation/virt/kvm/api.txt                     |   3 +
 Makefile                                           |  16 ++-
 arch/arm/include/asm/kvm_asm.h                     |   2 +-
 arch/arm/kvm/hyp/tlb.c                             |   3 +-
 arch/arm64/include/asm/kvm_asm.h                   |   2 +-
 arch/arm64/include/asm/memory.h                    |   5 +
 arch/arm64/include/asm/mmu_context.h               |   5 +-
 arch/arm64/kernel/head.S                           |   2 +-
 arch/arm64/kvm/hyp/tlb.c                           |   3 +-
 arch/arm64/kvm/reset.c                             |  11 +-
 arch/arm64/mm/init.c                               |  12 ++
 arch/arm64/mm/mmu.c                                |   2 +-
 arch/powerpc/include/asm/code-patching.h           |   2 +-
 arch/powerpc/include/asm/machdep.h                 |   3 +
 arch/powerpc/include/asm/ptrace.h                  |   3 +
 arch/powerpc/kernel/asm-offsets.c                  |   2 +-
 arch/powerpc/kernel/head_32.S                      |   9 +-
 arch/powerpc/kernel/pci-common.c                   |  10 ++
 arch/powerpc/kernel/process.c                      |   2 +-
 arch/powerpc/kernel/traps.c                        |   5 +-
 arch/powerpc/perf/core-book3s.c                    |  19 ++-
 arch/powerpc/platforms/pseries/msi.c               |  25 +++-
 arch/s390/kernel/smp.c                             |   2 +-
 arch/sparc/include/asm/mman.h                      |  54 +++++----
 arch/sparc/mm/init_32.c                            |   3 +
 arch/x86/kernel/unwind_orc.c                       |  12 +-
 drivers/base/swnode.c                              |   3 +
 drivers/block/rsxx/core.c                          |   1 +
 drivers/block/zram/zram_drv.c                      |  11 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |  25 ++--
 drivers/gpu/drm/drm_ioc32.c                        |  11 ++
 drivers/gpu/drm/meson/meson_drv.c                  |  11 ++
 drivers/gpu/drm/qxl/qxl_display.c                  |   1 +
 drivers/hid/hid-logitech-dj.c                      |   7 +-
 drivers/i2c/busses/i2c-rcar.c                      |  13 +-
 drivers/input/keyboard/applespi.c                  |  21 +++-
 drivers/iommu/amd_iommu_init.c                     |  45 +++++--
 drivers/media/platform/vsp1/vsp1_drm.c             |   6 +-
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/keymaps/Makefile                  |   1 -
 drivers/media/rc/keymaps/rc-cec.c                  |  28 ++---
 drivers/media/rc/rc-main.c                         |   6 +
 drivers/media/usb/usbtv/usbtv-audio.c              |   2 +-
 drivers/misc/fastrpc.c                             |   5 +
 drivers/misc/pvpanic.c                             |   1 +
 drivers/mmc/core/bus.c                             |  11 +-
 drivers/mmc/core/mmc.c                             |  15 ++-
 drivers/mmc/host/mtk-sd.c                          |  18 +--
 drivers/mmc/host/mxs-mmc.c                         |   2 +-
 drivers/net/can/flexcan.c                          |  24 ++--
 drivers/net/can/m_can/tcan4x5x.c                   |   6 +-
 drivers/net/ethernet/atheros/alx/main.c            |   7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  14 ++-
 drivers/net/ethernet/davicom/dm9000.c              |  21 +++-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  19 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h       |   5 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  40 ++++++-
 drivers/net/ethernet/freescale/enetc/enetc_vf.c    |   7 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   7 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |   5 +
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |   5 +
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   2 +
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   1 +
 drivers/net/ethernet/renesas/sh_eth.c              |   7 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |  19 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   |   4 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +
 drivers/net/netdevsim/netdev.c                     |   1 +
 drivers/net/phy/phy.c                              |   7 +-
 drivers/net/usb/qmi_wwan.c                         |  14 ---
 drivers/net/wan/lapbether.c                        |   3 -
 drivers/net/wireless/ath/ath9k/ath9k.h             |   3 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   6 +
 drivers/net/wireless/mediatek/mt76/dma.c           |  11 +-
 drivers/nvme/host/core.c                           |   8 +-
 drivers/pci/controller/pci-xgene-msi.c             |  10 +-
 drivers/pci/controller/pcie-mediatek.c             |   7 +-
 drivers/pci/pci.c                                  |   4 +
 drivers/platform/olpc/olpc-ec.c                    |  15 +--
 drivers/s390/block/dasd.c                          |   6 +-
 drivers/s390/cio/vfio_ccw_ops.c                    |   6 +-
 drivers/s390/crypto/vfio_ap_ops.c                  |   2 +-
 drivers/scsi/libiscsi.c                            |  11 +-
 drivers/spi/spi-stm32.c                            |  15 +--
 drivers/staging/comedi/drivers/addi_apci_1032.c    |   4 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c    |  18 +--
 drivers/staging/comedi/drivers/adv_pci1710.c       |  10 +-
 drivers/staging/comedi/drivers/das6402.c           |   2 +-
 drivers/staging/comedi/drivers/das800.c            |   2 +-
 drivers/staging/comedi/drivers/dmm32at.c           |   2 +-
 drivers/staging/comedi/drivers/me4000.c            |   2 +-
 drivers/staging/comedi/drivers/pcl711.c            |   2 +-
 drivers/staging/comedi/drivers/pcl818.c            |   2 +-
 drivers/staging/ks7010/ks_wlan_net.c               |   6 +-
 drivers/staging/rtl8188eu/core/rtw_ap.c            |   5 +
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |   6 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c         |   7 +-
 drivers/staging/rtl8192u/r8192U_wx.c               |   6 +-
 drivers/staging/rtl8712/rtl871x_cmd.c              |   6 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |   2 +-
 drivers/target/target_core_pr.c                    |  15 ++-
 drivers/target/target_core_transport.c             |  15 ++-
 drivers/usb/class/cdc-acm.c                        |   5 +
 drivers/usb/class/usblp.c                          |  16 ++-
 drivers/usb/dwc3/dwc3-qcom.c                       |  16 ++-
 drivers/usb/gadget/function/f_uac1.c               |   1 +
 drivers/usb/gadget/function/f_uac2.c               |   2 +-
 drivers/usb/gadget/function/u_ether_configfs.h     |   5 +-
 drivers/usb/host/xhci-pci.c                        |  13 +-
 drivers/usb/host/xhci-ring.c                       |   3 +-
 drivers/usb/host/xhci.c                            |  78 ++++++------
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/renesas_usbhs/pipe.c                   |   2 +
 drivers/usb/serial/ch341.c                         |   1 +
 drivers/usb/serial/cp210x.c                        |   3 +
 drivers/usb/serial/io_edgeport.c                   |  26 ++--
 drivers/usb/usbip/stub_dev.c                       |  42 +++++--
 drivers/usb/usbip/vhci_sysfs.c                     |  39 +++++-
 drivers/usb/usbip/vudc_sysfs.c                     |  49 ++++++--
 drivers/xen/events/events_2l.c                     |  22 ++--
 drivers/xen/events/events_base.c                   | 132 +++++++++++++++------
 drivers/xen/events/events_fifo.c                   |   7 --
 drivers/xen/events/events_internal.h               |  22 ++--
 fs/binfmt_misc.c                                   |  29 +++--
 fs/cifs/cifsfs.c                                   |   2 +-
 fs/configfs/file.c                                 |   6 +-
 fs/nfs/dir.c                                       |  40 ++++---
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/pnode.h                                         |   2 +-
 fs/udf/inode.c                                     |   9 +-
 include/linux/can/skb.h                            |   8 +-
 include/linux/sched/mm.h                           |   3 +-
 include/linux/stop_machine.h                       |  11 +-
 include/linux/virtio_net.h                         |   7 +-
 include/media/rc-map.h                             |   7 ++
 include/target/target_core_backend.h               |   1 +
 include/uapi/linux/netfilter/nfnetlink_cthelper.h  |   2 +-
 kernel/sched/membarrier.c                          |   4 +-
 kernel/sys.c                                       |   2 +-
 kernel/sysctl.c                                    |   8 +-
 kernel/time/hrtimer.c                              |  60 ++++++----
 lib/logic_pio.c                                    |   3 +
 mm/slub.c                                          |   2 +-
 net/ipv4/cipso_ipv4.c                              |  11 +-
 net/ipv4/nexthop.c                                 |  10 +-
 net/ipv4/tcp.c                                     |  23 ++--
 net/ipv4/udp_offload.c                             |   2 +-
 net/ipv6/calipso.c                                 |  14 +--
 net/mpls/mpls_gso.c                                |   3 +
 net/netfilter/nf_nat_proto.c                       |  25 +++-
 net/netfilter/x_tables.c                           |   6 +-
 net/netlabel/netlabel_cipso_v4.c                   |   3 +
 net/qrtr/qrtr.c                                    |   4 +-
 net/sched/sch_api.c                                |   8 +-
 net/sunrpc/sched.c                                 |   5 +-
 samples/bpf/xdpsock_user.c                         |   2 +
 security/commoncap.c                               |  12 +-
 sound/pci/hda/hda_bind.c                           |   4 +
 sound/pci/hda/hda_controller.c                     |   7 --
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_ca0132.c                       |   1 +
 sound/pci/hda/patch_hdmi.c                         |  13 ++
 sound/usb/quirks.c                                 |   9 ++
 tools/perf/util/trace-event-read.c                 |   1 +
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |   6 +-
 .../testing/selftests/bpf/verifier/array_access.c  |   3 +-
 .../net/forwarding/mirror_gre_bridge_1d_vlan.sh    |   9 ++
 virt/kvm/arm/arm.c                                 |   8 +-
 virt/kvm/arm/mmu.c                                 |   3 +-
 173 files changed, 1213 insertions(+), 587 deletions(-)


