Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F255133B6AC
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhCON62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231484AbhCON54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54E7264EEA;
        Mon, 15 Mar 2021 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816676;
        bh=uLkrePozKOyrE/YJ1N/vKPU0M+1yughcrwOXvhjE1Fw=;
        h=From:To:Cc:Subject:Date:From;
        b=cCYTqVprcPn0gdTEEuHW5Rq9II9iS8t//1id1JLfhV35MjYBNArFnsYbdDWlWZHNH
         EyAXhiY3wenoErKohH93zifahxCOCmFQCnTgsZ/OuYrfx8XRJqQ+pt2NxedkyRmur/
         Ie2N/2JbrVekjw0jiHC9pIcpjo+5vEQV6ytQra6g=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 000/120] 4.19.181-rc1 review
Date:   Mon, 15 Mar 2021 14:55:51 +0100
Message-Id: <20210315135720.002213995@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.181-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.181-rc1
X-KernelTest-Deadline: 2021-03-17T13:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 4.19.181 release.
There are 120 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 17 Mar 2021 13:57:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.181-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.181-rc1

Juergen Gross <jgross@suse.com>
    xen/events: avoid handling the same event on two cpus at the same time

Juergen Gross <jgross@suse.com>
    xen/events: don't unmask an event channel when an eoi is pending

Juergen Gross <jgross@suse.com>
    xen/events: reset affinity of 2-level event when tearing it down

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix exclusive limit for IPA size

Boyang Yu <byu@arista.com>
    hwmon: (lm90) Fix max6658 sporadic wrong temperature reading

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind/orc: Disable KASAN checking in the ORC unwinder, part 2

Lior Ribak <liorribak@gmail.com>
    binfmt_misc: fix possible deadlock in bm_register_write

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/64s: Fix instruction encoding for lis in ppc_function_entry()

Alexey Dobriyan <adobriyan@gmail.com>
    prctl: fix PR_SET_MM_AUXV kernel stack leak

Matthew Wilcox (Oracle) <willy@infradead.org>
    include/linux/sched/mm.h: use rcu_dereference in in_vfork()

Arnd Bergmann <arnd@arndb.de>
    stop_machine: mark helpers __always_inline

Anna-Maria Behnsen <anna-maria@linutronix.de>
    hrtimer: Update softirq_expires_next correctly after __hrtimer_get_next_event()

Daiyue Zhang <zhangdaiyue1@huawei.com>
    configfs: fix a use-after-free in __configfs_open_file

Jia-Ju Bai <baijiaju1990@gmail.com>
    block: rsxx: fix error return code of rsxx_pci_probe()

Ondrej Mosnacek <omosnace@redhat.com>
    NFSv4.2: fix return value of _nfs4_get_security_label()

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

Forest Crossman <cyrozap@gmail.com>
    usb: xhci: Fix ASMedia ASM1042A and ASM3242 DMA addressing

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Improve detection of device initiated wake signal.

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: renesas_usbhs: Clear PIPECFG for re-enabling pipe with other EPNUM

Pete Zaitcev <zaitcev@redhat.com>
    USB: usblp: fix a hang in poll() if disconnected

Matthias Kaehlcke <mka@chromium.org>
    usb: dwc3: qcom: Honor wakeup enabled/disabled state

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

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix hanging IO request during DASD driver unbind

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix hanging DASD driver unbind

Eric W. Biederman <ebiederm@xmission.com>
    Revert 95ebabde382c ("capabilities: Don't allow writing ambiguous v3 file capabilities")

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Apply the control quirk to Plantronics headsets

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix "cannot get freq eq" errors on Dell AE515 sound bar

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Avoid spurious unsol event handling during S3/S4

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Drop the BATCH workaround for AMD controllers

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

Heiko Carstens <hca@linux.ibm.com>
    s390/smp: __smp_rescan_cpus() - move cpumask away from stack

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    i40e: Fix memory leak in i40e_probe

Geert Uytterhoeven <geert+renesas@glider.be>
    PCI: Fix pci_register_io_range() memory leak

Krzysztof Wilczyński <kw@linux.com>
    PCI: mediatek: Add missing of_node_put() to fix reference leak

Martin Kaiser <martin@kaiser.cx>
    PCI: xgene-msi: Fix race in installing chained irq handler

Khalid Aziz <khalid.aziz@oracle.com>
    sparc64: Use arch_validate_flags() to validate ADI flag

Andreas Larsson <andreas@gaisler.com>
    sparc32: Limit memblock allocation to low memory

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Record counter overflow always if SAMPLE_IP is unset

Nicholas Piggin <npiggin@gmail.com>
    powerpc: improve handling of unrecoverable system reset

Oliver O'Halloran <oohall@gmail.com>
    powerpc/pci: Add ppc_md.discover_phbs()

Chaotian Jing <chaotian.jing@mediatek.com>
    mmc: mediatek: fix race condition between msdc_request_timeout and irq

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: mxs-mmc: Fix a resource leak in an error handling path in 'mxs_mmc_probe()'

Steven J. Magnani <magnani@ieee.org>
    udf: fix silent AED tagLocation corruption

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: optimize cacheline to minimize HW race condition

Guangbin Huang <huangguangbin2@huawei.com>
    net: phy: fix save wrong speed and duplex problem if autoneg is on

Biju Das <biju.das.jz@bp.renesas.com>
    media: v4l: vsp1: Fix bru null pointer access

Biju Das <biju.das.jz@bp.renesas.com>
    media: v4l: vsp1: Fix uif null pointer access

Maxim Mikityanskiy <maxtram95@gmail.com>
    media: usbtv: Fix deadlock on suspend

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    sh_eth: fix TRSCER mask for R7S9210

Eric Farman <farman@linux.ibm.com>
    s390/cio: return -EFAULT if copy_to_user() fails

Artem Lapkin <art@khadas.com>
    drm: meson_drv add shutdown function

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/compat: Clear bounce structures

Wang Qing <wangqing@vivo.com>
    s390/cio: return -EFAULT if copy_to_user() fails again

Ian Rogers <irogers@google.com>
    perf traceevent: Ensure read cmdlines are null terminated.

Danielle Ratson <danieller@nvidia.com>
    selftests: forwarding: Fix race condition in mirror installation

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: fix watchdog timeout during suspend/resume stress test

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: stop each tx channel independently

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

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: allow qmimux add/del with master up

Maximilian Heyne <mheyne@amazon.de>
    net: sched: avoid duplicates in classes dump

Ong Boon Leong <boon.leong.ong@intel.com>
    net: stmmac: fix incorrect DMA channel intr enable setting of EQoS v4.10

Kevin(Yudong) Yang <yyd@google.com>
    net/mlx4_en: update moderation when config reset

Balazs Nemeth <bnemeth@redhat.com>
    net: avoid infinite loop in mpls_gso_segment when mpls_hlen == 0

Balazs Nemeth <bnemeth@redhat.com>
    net: check if protocol extracted by virtio_net_hdr_set_proto is correct

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    sh_eth: fix TRSCER mask for SH771x

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "mm, slub: consider rest of partial list if acquire_slab() fails"

Joe Lawrence <joe.lawrence@redhat.com>
    scripts/recordmcount.{c,pl}: support -ffunction-sections .text.* section names

Paulo Alcantara <pc@cjr.nz>
    cifs: return proper error code in statfs(2)

Eric Dumazet <edumazet@google.com>
    tcp: add sanity tests to TCP_QUEUE_SEQ

Eric Dumazet <edumazet@google.com>
    tcp: annotate tp->write_seq lockless reads

Eric Dumazet <edumazet@google.com>
    tcp: annotate tp->copied_seq lockless reads

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: dma: do not report truncated frames to mac80211

Vasily Averin <vvs@virtuozzo.com>
    netfilter: x_tables: gpf inside xt_find_revision()

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: enable RX FIFO after FRZ/HALT valid

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: assert FRZ bit in flexcan_chip_freeze()

Oleksij Rempel <o.rempel@pengutronix.de>
    can: skb: can_skb_set_owner(): fix ref counting if socket was closed before setting skb ownership

Maxim Mikityanskiy <maximmi@mellanox.com>
    net: Introduce parse_protocol header_ops callback

Daniel Borkmann <daniel@iogearbox.net>
    net: Fix gro aggregation for udp encaps with zero csum

Felix Fietkau <nbd@nbd.name>
    ath9k: fix transmitting to stations in dynamic SMPS mode

Jakub Kicinski <kuba@kernel.org>
    ethernet: alx: fix order of calls on resume

Dmitry V. Levin <ldv@altlinux.org>
    uapi: nfnetlink_cthelper.h: fix userspace compilation error


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/powerpc/include/asm/code-patching.h           |   2 +-
 arch/powerpc/include/asm/machdep.h                 |   3 +
 arch/powerpc/kernel/pci-common.c                   |  10 ++
 arch/powerpc/kernel/traps.c                        |   5 +-
 arch/powerpc/perf/core-book3s.c                    |  19 ++-
 arch/s390/kernel/smp.c                             |   2 +-
 arch/sparc/include/asm/mman.h                      |  54 +++++----
 arch/sparc/mm/init_32.c                            |   3 +
 arch/x86/kernel/unwind_orc.c                       |  12 +-
 drivers/block/rsxx/core.c                          |   1 +
 drivers/gpu/drm/drm_ioc32.c                        |  11 ++
 drivers/gpu/drm/meson/meson_drv.c                  |  11 ++
 drivers/hwmon/lm90.c                               |  42 ++++++-
 drivers/i2c/busses/i2c-rcar.c                      |   2 +-
 drivers/media/platform/vsp1/vsp1_drm.c             |   6 +-
 drivers/media/usb/usbtv/usbtv-audio.c              |   2 +-
 drivers/mmc/core/bus.c                             |  11 +-
 drivers/mmc/core/mmc.c                             |  15 ++-
 drivers/mmc/host/mtk-sd.c                          |  18 +--
 drivers/mmc/host/mxs-mmc.c                         |   2 +-
 drivers/net/can/flexcan.c                          |  12 +-
 drivers/net/ethernet/atheros/alx/main.c            |   7 +-
 drivers/net/ethernet/davicom/dm9000.c              |  21 +++-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   2 +
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   2 +
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   1 +
 drivers/net/ethernet/renesas/sh_eth.c              |   7 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |  19 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   |   4 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +
 drivers/net/phy/phy.c                              |   7 +-
 drivers/net/usb/qmi_wwan.c                         |  14 ---
 drivers/net/wan/lapbether.c                        |   3 -
 drivers/net/wireless/ath/ath9k/ath9k.h             |   3 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   6 +
 drivers/net/wireless/mediatek/mt76/dma.c           |  11 +-
 drivers/pci/controller/pci-xgene-msi.c             |  10 +-
 drivers/pci/controller/pcie-mediatek.c             |   7 +-
 drivers/pci/pci.c                                  |   4 +
 drivers/s390/block/dasd.c                          |   6 +-
 drivers/s390/cio/vfio_ccw_ops.c                    |   6 +-
 drivers/scsi/libiscsi.c                            |  11 +-
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
 drivers/usb/dwc3/dwc3-qcom.c                       |   7 +-
 drivers/usb/gadget/function/f_uac1.c               |   1 +
 drivers/usb/gadget/function/f_uac2.c               |   2 +-
 drivers/usb/gadget/function/u_ether_configfs.h     |   5 +-
 drivers/usb/host/xhci-pci.c                        |   8 +-
 drivers/usb/host/xhci.c                            |  16 ++-
 drivers/usb/renesas_usbhs/pipe.c                   |   2 +
 drivers/usb/serial/ch341.c                         |   1 +
 drivers/usb/serial/cp210x.c                        |   3 +
 drivers/usb/serial/io_edgeport.c                   |  26 ++--
 drivers/usb/usbip/stub_dev.c                       |  42 +++++--
 drivers/usb/usbip/vhci_sysfs.c                     |  39 +++++-
 drivers/usb/usbip/vudc_sysfs.c                     |  50 ++++++--
 drivers/xen/events/events_2l.c                     |  22 ++--
 drivers/xen/events/events_base.c                   | 132 +++++++++++++++------
 drivers/xen/events/events_fifo.c                   |   7 --
 drivers/xen/events/events_internal.h               |  22 ++--
 fs/binfmt_misc.c                                   |  29 +++--
 fs/cifs/cifsfs.c                                   |   2 +-
 fs/configfs/file.c                                 |   6 +-
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/udf/inode.c                                     |   9 +-
 include/linux/can/skb.h                            |   8 +-
 include/linux/netdevice.h                          |  10 ++
 include/linux/sched/mm.h                           |   3 +-
 include/linux/stop_machine.h                       |  11 +-
 include/linux/virtio_net.h                         |   7 +-
 include/net/tcp.h                                  |   2 +-
 include/target/target_core_backend.h               |   1 +
 include/uapi/linux/netfilter/nfnetlink_cthelper.h  |   2 +-
 kernel/sys.c                                       |   2 +-
 kernel/time/hrtimer.c                              |  60 ++++++----
 lib/logic_pio.c                                    |   3 +
 mm/slub.c                                          |   2 +-
 net/ipv4/cipso_ipv4.c                              |  11 +-
 net/ipv4/tcp.c                                     |  59 +++++----
 net/ipv4/tcp_diag.c                                |   5 +-
 net/ipv4/tcp_input.c                               |   6 +-
 net/ipv4/tcp_ipv4.c                                |  23 ++--
 net/ipv4/tcp_minisocks.c                           |   4 +-
 net/ipv4/tcp_output.c                              |   6 +-
 net/ipv4/udp_offload.c                             |   2 +-
 net/ipv6/calipso.c                                 |  14 +--
 net/ipv6/tcp_ipv6.c                                |  15 +--
 net/mpls/mpls_gso.c                                |   3 +
 net/netfilter/x_tables.c                           |   6 +-
 net/netlabel/netlabel_cipso_v4.c                   |   3 +
 net/qrtr/qrtr.c                                    |   4 +-
 net/sched/sch_api.c                                |   8 +-
 scripts/recordmcount.c                             |   2 +-
 scripts/recordmcount.pl                            |  13 ++
 security/commoncap.c                               |  12 +-
 sound/pci/hda/hda_bind.c                           |   4 +
 sound/pci/hda/hda_controller.c                     |   7 --
 sound/pci/hda/patch_hdmi.c                         |  13 ++
 sound/usb/quirks.c                                 |   9 ++
 tools/perf/util/trace-event-read.c                 |   1 +
 .../net/forwarding/mirror_gre_bridge_1d_vlan.sh    |   9 ++
 virt/kvm/arm/mmu.c                                 |   2 +-
 123 files changed, 892 insertions(+), 428 deletions(-)


