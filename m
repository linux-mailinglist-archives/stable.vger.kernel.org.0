Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F2517FC83
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbgCJNFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730192AbgCJNFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:05:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EDA02468C;
        Tue, 10 Mar 2020 13:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845550;
        bh=uRZKMVcZlxw9oQGKEno0kgD6gaUMPNVnA0vr0mqxtgg=;
        h=From:To:Cc:Subject:Date:From;
        b=HgSxd5xbK7r1L5khTFYo7WRcLuIsseHpjMUO1vexp+jyuTXoattEZosMc7PT8+njK
         +Zbxl4L5ujjIeX/6wdsMC5wyxqxaEe1aLLaRgyqEg31xPQDpWvWQ3H1uA4ChsyrSpm
         Qo5DZK2GU7jPLIjL3RsAmZiycdU8+x41hWwHTZYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/126] 4.14.173-stable review
Date:   Tue, 10 Mar 2020 13:40:21 +0100
Message-Id: <20200310124203.704193207@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.173-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.173-rc1
X-KernelTest-Deadline: 2020-03-12T12:42+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.173 release.
There are 126 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 Mar 2020 12:41:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.173-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.173-rc1

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: handle port status events for removed USB3 hcd

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix a deadlock due to offloading to an incorrect workqueue

Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
    powerpc: fix hardware PMU exception bug on PowerVM compatibility mode systems

Dan Carpenter <dan.carpenter@oracle.com>
    dmaengine: coh901318: Fix a double lock bug in dma_tc_handle()

Dan Carpenter <dan.carpenter@oracle.com>
    hwmon: (adt7462) Fix an error return in ADT7462_REG_VOLT()

Johan Hovold <johan@kernel.org>
    ARM: dts: imx6dl-colibri-eval-v3: fix sram compatible properties

Ahmad Fatoum <a.fatoum@pengutronix.de>
    ARM: imx: build v7_cpu_resume() unconditionally

Dennis Dalessandro <dennis.dalessandro@intel.com>
    IB/hfi1, qib: Ensure RCU is locked when accessing list

Jason Gunthorpe <jgg@mellanox.com>
    RMDA/cm: Fix missing ib_cm_destroy_id() in ib_cm_insert_listen()

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/iwcm: Fix iwcm work deallocation

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: dapm: Correct DAPM handling of active widgets during shutdown

Matthias Reichl <hias@horus.com>
    ASoC: pcm512x: Fix unbalanced regulator enable call in probe error path

Takashi Iwai <tiwai@suse.de>
    ASoC: pcm: Fix possible buffer overflow in dpcm state sysfs output

Takashi Iwai <tiwai@suse.de>
    ASoC: intel: skl: Fix possible buffer overflow in debug outputs

Takashi Iwai <tiwai@suse.de>
    ASoC: intel: skl: Fix pin debug prints

Dragos Tarcatu <dragos_tarcatu@mentor.com>
    ASoC: topology: Fix memleak in soc_tplg_link_elems_load()

Vladimir Oltean <olteanv@gmail.com>
    ARM: dts: ls1021a: Restore MDIO compatible to gianfar

Mikulas Patocka <mpatocka@redhat.com>
    dm cache: fix a crash due to incorrect work item cancelling

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Prevent race conditions of tasklet vs free list

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Fix use-after-free

Sean Christopherson <sean.j.christopherson@intel.com>
    x86/pkeys: Manually set X86_FEATURE_OSPKE to preserve existing changes

Jiri Slaby <jslaby@suse.cz>
    vt: selection, push sel_lock up

Jiri Slaby <jslaby@suse.cz>
    vt: selection, push console lock down

Jiri Slaby <jslaby@suse.cz>
    vt: selection, close sel_buffer race

Jay Dolan <jay.dolan@accesio.com>
    serial: 8250_exar: add support for ACCES cards

tangbin <tangbin@cmss.chinamobile.com>
    tty:serial:mvebu-uart:fix a wrong return

Faiz Abbas <faiz_abbas@ti.com>
    arm: dts: dra76x: Fix mmc3 max-frequency

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: fix uninit-memory access for partial initialized inode

Mel Gorman <mgorman@techsingularity.net>
    mm, numa: fix bad pmd by atomically check for pmd_trans_huge when marking page tables prot_numa

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    vgacon: Fix a UAF in vgacon_invert_region

Eugeniu Rosca <erosca@de.adit-jv.com>
    usb: core: port: do error out if usb_autopm_get_interface() fails

Eugeniu Rosca <erosca@de.adit-jv.com>
    usb: core: hub: do error out if usb_autopm_get_interface() fails

Eugeniu Rosca <erosca@de.adit-jv.com>
    usb: core: hub: fix unhandled return by employing a void function

Dan Lazewatsky <dlaz@chromium.org>
    usb: quirks: add NO_LPM quirk for Logitech Screen Share

Jim Lin <jilin@nvidia.com>
    usb: storage: Add quirk for Samsung Fit flash

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: don't leak -EAGAIN for stat() during reconnect

Tim Harvey <tharvey@gateworks.com>
    net: thunderx: workaround BGX TX Underflow issue

Kees Cook <keescook@chromium.org>
    x86/xen: Distribute switch variables for initialization

Keith Busch <kbusch@kernel.org>
    nvme: Fix uninitialized-variable warning

H.J. Lu <hjl.tools@gmail.com>
    x86/boot/compressed: Don't declare __force_order in kaslr_64.c

Vasily Averin <vvs@virtuozzo.com>
    s390/cio: cio_ignore_proc_seq_next should increase position index

Marco Felsch <m.felsch@pengutronix.de>
    watchdog: da9062: do not ping the hw during stop()

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix 16-bit IO operation

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix 16-bit data access

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Remove 8-bit bus accessors

Harigovindan P <harigovi@codeaurora.org>
    drm/msm/dsi: save pll state before dsi host is powered off

John Stultz <john.stultz@linaro.org>
    drm: msm: Fix return type of dsi_mgr_connector_mode_valid for kCFI

Brian Masney <masneyb@onstation.org>
    drm/msm/mdp5: rate limit pp done timeout warnings

Sergey Organov <sorganov@gmail.com>
    usb: gadget: serial: fix Tx stall after buffer overflow

Lars-Peter Clausen <lars@metafoo.de>
    usb: gadget: ffs: ffs_aio_cancel(): Save/restore IRQ flags

Jack Pham <jackp@codeaurora.org>
    usb: gadget: composite: Support more than 500mA MaxPower

Jiri Benc <jbenc@redhat.com>
    selftests: fix too long argument

Daniel Golle <daniel@makrotopia.org>
    serial: ar933x_uart: set UART_CS_{RX,TX}_READY_ORIDE

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Fix optimize_kprobe()/unoptimize_kprobe() cancellation logic

Nathan Chancellor <natechancellor@gmail.com>
    RDMA/core: Fix use of logical OR in get_new_pps

Maor Gottlieb <maorg@mellanox.com>
    RDMA/core: Fix pkey and port assignment in get_new_pps

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Forcibly configure IMP port for 1Gb/sec

Yazen Ghannam <yazen.ghannam@amd.com>
    EDAC/amd64: Set grain per DIMM

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce: Handle varying MCA bank counts

Eugenio Pérez <eperezma@redhat.com>
    vhost: Check docket sk_family instead of call getname

Paul Moore <paul@paul-moore.com>
    audit: always check the netlink payload length in audit_receive_msg()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "char/random: silence a lockdep splat with printk()"

David Rientjes <rientjes@google.com>
    mm, thp: fix defrag setting if newline is not used

Wei Yang <richardw.yang@linux.intel.com>
    mm/huge_memory.c: use head to check huge zero page

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf hists browser: Restore ESC as "Zoom out" of DSO/thread/etc

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Set unoptimized flag after unoptimizing code

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drivers: net: xgene: Fix the order of the arguments of 'alloc_etherdev_mqs()'

Jason Wang <jasowang@redhat.com>
    tuntap: correctly set SOCKWQ_ASYNC_NOSPACE

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: Check for a bad hva before dropping into the ghc slow path

Tom Lendacky <thomas.lendacky@amd.com>
    KVM: SVM: Override default MMIO mask if memory encryption is enabled

Brian Norris <briannorris@chromium.org>
    mwifiex: drop most magic numbers from mwifiex_process_tdls_action_frame()

Aleksa Sarai <cyphar@cyphar.com>
    namei: only return -ECHILD from follow_dotdot_rcu()

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: make ena rxfh support ETH_RSS_HASH_NO_CHANGE

Pavel Belous <pbelous@marvell.com>
    net: atlantic: fix potential error handling

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: netlink: cap max groups which will be considered in netlink_bind()

Chris Wilson <chris@chris-wilson.co.uk>
    include/linux/bitops.h: introduce BITS_PER_TYPE

Nathan Chancellor <natechancellor@gmail.com>
    ecryptfs: Fix up bad backport of fe2e082f5da5b4a0a92ae32978f81507ef37ec66

Peter Chen <peter.chen@nxp.com>
    usb: charger: assign specific number for enum value

Tina Zhang <tina.zhang@intel.com>
    drm/i915/gvt: Separate display reset from ALL_ENGINES reset

Wolfram Sang <wsa@the-dreams.de>
    i2c: jz4780: silence log flood on txabrt

Gustavo A. R. Silva <gustavo@embeddedor.com>
    i2c: altera: Fix potential integer overflow

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    MIPS: VPE: Fix a double free and a memory leak in 'release_vpe()'

dan.carpenter@oracle.com <dan.carpenter@oracle.com>
    HID: hiddev: Fix race in in hiddev_disconnect()

Orson Zhai <orson.unisoc@gmail.com>
    Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Disable trace_printk() on post poned tests

Johan Korsnes <jkorsnes@cisco.com>
    HID: core: increase HID report buffer size to 8KiB

Johan Korsnes <jkorsnes@cisco.com>
    HID: core: fix off-by-one memset in hid_report_raw_event()

Hans de Goede <hdegoede@redhat.com>
    HID: ite: Only bind to keyboard USB interface on Acer SW5-012 keyboard dock

Oliver Upton <oupton@google.com>
    KVM: VMX: check descriptor table exits on instruction emulation

Mika Westerberg <mika.westerberg@linux.intel.com>
    ACPI: watchdog: Fix gas->access_width usage

Mika Westerberg <mika.westerberg@linux.intel.com>
    ACPICA: Introduce ACPI_ACCESS_BYTE_WIDTH() macro

Paul Moore <paul@paul-moore.com>
    audit: fix error handling in audit_data_to_entry()

Dan Carpenter <dan.carpenter@oracle.com>
    ext4: potential crash on allocation error in ext4_alloc_flex_bg_array()

Jason Baron <jbaron@akamai.com>
    net: sched: correct flower port blocking

Michal Kalderon <michal.kalderon@marvell.com>
    qede: Fix race between rdma destroy workqueue and link change event

Benjamin Poirier <bpoirier@cumulusnetworks.com>
    ipv6: Fix route replacement with dev-only route

Benjamin Poirier <bpoirier@cumulusnetworks.com>
    ipv6: Fix nlmsg_flags when splitting a multipath route

Xin Long <lucien.xin@gmail.com>
    sctp: move the format error check out of __sctp_sf_do_9_1_abort

Dmitry Osipenko <digetx@gmail.com>
    nfc: pn544: Fix occasional HW initialization failure

Arun Parameswaran <arun.parameswaran@broadcom.com>
    net: phy: restore mdio regs in the iproc mdio driver

Jethro Beekman <jethro@fortanix.com>
    net: fib_rules: Correctly set table field when table number exceeds 8 bits

Petr Mladek <pmladek@suse.com>
    sysrq: Remove duplicated sysrq message

Petr Mladek <pmladek@suse.com>
    sysrq: Restore original console_loglevel when sysrq disabled

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE

Frank Sorenson <sorenson@redhat.com>
    cifs: Fix mode output in debugging statements

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: ena-com.c: prevent NULL pointer dereference

Sameeh Jubran <sameehj@amazon.com>
    net: ena: ethtool: use correct value for crc32 hash

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix incorrectly saving queue numbers when setting RSS indirection table

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: rss: store hash function as values and not bits

Sameeh Jubran <sameehj@amazon.com>
    net: ena: rss: fix failure to get indirection table

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix incorrect default RSS key

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: add missing ethtool TX timestamping indication

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix uses of round_jiffies()

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix potential crash when rxfh key is NULL

Bjørn Mork <bjorn@mork.no>
    qmi_wwan: unconditionally reject 2 ep interfaces

Bjørn Mork <bjorn@mork.no>
    qmi_wwan: re-add DW5821e pre-production variant

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    cfg80211: check wiphy driver existence for drvinfo report

Johannes Berg <johannes.berg@intel.com>
    mac80211: consider more elements in parsing CRC

Jeff Moyer <jmoyer@redhat.com>
    dax: pass NOWAIT flag to iomap_apply

Sean Paul <seanpaul@chromium.org>
    drm/msm: Set dma maximum segment size for mdss

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Handle a possible NULL pointer reference

Suraj Jitindar Singh <surajjs@amazon.com>
    ext4: fix potential race between s_group_info online resizing and access

Suraj Jitindar Singh <surajjs@amazon.com>
    ext4: fix potential race between s_flex_groups online resizing and access

Theodore Ts'o <tytso@mit.edu>
    ext4: fix potential race between online resizing and write operations

Martynas Pumputis <martynas@weave.works>
    netfilter: nf_conntrack: resolve clash for matching conntracks

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: fix rb_allocator workqueue allocation


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/arm/boot/dts/dra76x.dtsi                     |   5 ++
 arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts      |   4 +-
 arch/arm/boot/dts/ls1021a.dtsi                    |   4 +-
 arch/arm/mach-imx/Makefile                        |   2 +
 arch/arm/mach-imx/common.h                        |   4 +-
 arch/arm/mach-imx/resume-imx6.S                   |  24 +++++
 arch/arm/mach-imx/suspend-imx6.S                  |  14 ---
 arch/mips/kernel/vpe.c                            |   2 +-
 arch/powerpc/kernel/cputable.c                    |   4 +-
 arch/x86/boot/compressed/pagetable.c              |   3 -
 arch/x86/kernel/cpu/common.c                      |   2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c           |  14 +--
 arch/x86/kernel/cpu/mcheck/mce.c                  |  22 ++---
 arch/x86/kvm/svm.c                                |  43 +++++++++
 arch/x86/kvm/vmx.c                                |  15 ++++
 arch/x86/xen/enlighten_pv.c                       |   7 +-
 drivers/acpi/acpi_watchdog.c                      |   3 +-
 drivers/char/ipmi/ipmi_ssif.c                     |  10 ++-
 drivers/char/random.c                             |   5 +-
 drivers/devfreq/devfreq.c                         |   4 +-
 drivers/dma/coh901318.c                           |   4 -
 drivers/dma/tegra20-apb-dma.c                     |   6 +-
 drivers/edac/amd64_edac.c                         |   1 +
 drivers/gpu/drm/i915/gvt/vgpu.c                   |   2 +-
 drivers/gpu/drm/msm/dsi/dsi_manager.c             |   7 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c             |   4 -
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c          |   4 +-
 drivers/gpu/drm/msm/msm_drv.c                     |   8 ++
 drivers/hid/hid-core.c                            |   4 +-
 drivers/hid/hid-ite.c                             |   5 +-
 drivers/hid/usbhid/hiddev.c                       |   2 +-
 drivers/hwmon/adt7462.c                           |   2 +-
 drivers/i2c/busses/i2c-altera.c                   |   2 +-
 drivers/i2c/busses/i2c-jz4780.c                   |  36 +-------
 drivers/infiniband/core/cm.c                      |   1 +
 drivers/infiniband/core/iwcm.c                    |   4 +-
 drivers/infiniband/core/security.c                |  14 +--
 drivers/infiniband/hw/hfi1/verbs.c                |   4 +-
 drivers/infiniband/hw/qib/qib_verbs.c             |   2 +
 drivers/md/dm-cache-target.c                      |   4 +-
 drivers/md/dm-integrity.c                         |  15 +++-
 drivers/net/dsa/bcm_sf2.c                         |   3 +-
 drivers/net/ethernet/amazon/ena/ena_com.c         |  48 ++++++++--
 drivers/net/ethernet/amazon/ena/ena_com.h         |   9 ++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c     |  46 +++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c      |   6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.h      |   2 +
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c  |   2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c   |   4 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c |  62 ++++++++++++-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.h |   9 ++
 drivers/net/ethernet/micrel/ks8851_mll.c          |  53 ++---------
 drivers/net/ethernet/qlogic/qede/qede.h           |   2 +
 drivers/net/ethernet/qlogic/qede/qede_rdma.c      |  29 +++++-
 drivers/net/phy/mdio-bcm-iproc.c                  |  20 +++++
 drivers/net/tun.c                                 |  19 +++-
 drivers/net/usb/qmi_wwan.c                        |  43 ++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   |  15 +++-
 drivers/net/wireless/marvell/mwifiex/tdls.c       |  75 ++++++----------
 drivers/nfc/pn544/i2c.c                           |   1 +
 drivers/nvme/host/core.c                          |   2 +-
 drivers/s390/cio/blacklist.c                      |   5 +-
 drivers/tty/serial/8250/8250_exar.c               |  33 +++++++
 drivers/tty/serial/ar933x_uart.c                  |   8 ++
 drivers/tty/serial/mvebu-uart.c                   |   2 +-
 drivers/tty/sysrq.c                               |   8 +-
 drivers/tty/vt/selection.c                        |  26 +++++-
 drivers/tty/vt/vt.c                               |   2 -
 drivers/usb/core/hub.c                            |   8 +-
 drivers/usb/core/port.c                           |  10 ++-
 drivers/usb/core/quirks.c                         |   3 +
 drivers/usb/gadget/composite.c                    |  24 +++--
 drivers/usb/gadget/function/f_fs.c                |   5 +-
 drivers/usb/gadget/function/u_serial.c            |   4 +-
 drivers/usb/host/xhci-ring.c                      |   6 ++
 drivers/usb/storage/unusual_devs.h                |   6 ++
 drivers/vhost/net.c                               |  13 +--
 drivers/video/console/vgacon.c                    |   3 +
 drivers/watchdog/da9062_wdt.c                     |   7 --
 drivers/watchdog/wdat_wdt.c                       |   2 +-
 fs/cifs/cifsacl.c                                 |   4 +-
 fs/cifs/connect.c                                 |   2 +-
 fs/cifs/inode.c                                   |   8 +-
 fs/dax.c                                          |   3 +
 fs/ecryptfs/keystore.c                            |   4 +-
 fs/ext4/balloc.c                                  |  14 ++-
 fs/ext4/ext4.h                                    |  30 +++++--
 fs/ext4/ialloc.c                                  |  23 +++--
 fs/ext4/mballoc.c                                 |  61 ++++++++-----
 fs/ext4/resize.c                                  |  62 ++++++++++---
 fs/ext4/super.c                                   | 103 +++++++++++++++-------
 fs/fat/inode.c                                    |  19 ++--
 fs/namei.c                                        |   2 +-
 include/acpi/actypes.h                            |   3 +-
 include/linux/bitops.h                            |   3 +-
 include/linux/hid.h                               |   2 +-
 include/net/flow_dissector.h                      |   9 ++
 include/uapi/linux/usb/charger.h                  |  16 ++--
 kernel/audit.c                                    |  40 +++++----
 kernel/auditfilter.c                              |  71 ++++++++-------
 kernel/kprobes.c                                  |  71 +++++++++------
 kernel/trace/trace.c                              |   2 +
 mm/huge_memory.c                                  |  26 ++----
 mm/mprotect.c                                     |  38 +++++++-
 net/core/fib_rules.c                              |   2 +-
 net/ipv6/ip6_fib.c                                |   7 +-
 net/ipv6/route.c                                  |   1 +
 net/mac80211/util.c                               |  18 ++--
 net/netfilter/nf_conntrack_core.c                 |  30 +++++--
 net/netlink/af_netlink.c                          |   5 +-
 net/sched/cls_flower.c                            |   1 +
 net/sctp/sm_statefuns.c                           |  29 ++++--
 net/wireless/ethtool.c                            |   8 +-
 net/wireless/nl80211.c                            |   1 +
 sound/soc/codecs/pcm512x.c                        |   8 +-
 sound/soc/intel/skylake/skl-debug.c               |  32 +++----
 sound/soc/soc-dapm.c                              |   2 +-
 sound/soc/soc-pcm.c                               |  16 ++--
 sound/soc/soc-topology.c                          |   5 +-
 tools/perf/ui/browsers/hists.c                    |   1 +
 tools/testing/selftests/lib.mk                    |  23 ++---
 virt/kvm/kvm_main.c                               |  12 +--
 123 files changed, 1159 insertions(+), 609 deletions(-)


