Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FACC19B0E8
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387716AbgDAQaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388125AbgDAQaU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:30:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17F0A20658;
        Wed,  1 Apr 2020 16:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758619;
        bh=VVO8ooKUgx1VGA2YiMwrGCz0OE1xUWuETPb1nWb86O8=;
        h=From:To:Cc:Subject:Date:From;
        b=YzHl5poTZSGLEcx8V9T1ujoAJoJHaq+5KtNT41aciCx721SkM/kkdlOn1yCChFmPu
         tW15t0BMXhQIzvh8w0MZybzLAJZ0D1amIYWqqM3TaFhKL1/pZJ6+MuOValhsE03t1d
         fNYQjpe0wWiX2sbQPVouYBmEKn6u4cz5e3vmpEs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/91] 4.4.218-rc1 review
Date:   Wed,  1 Apr 2020 18:16:56 +0200
Message-Id: <20200401161512.917494101@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.218-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.218-rc1
X-KernelTest-Deadline: 2020-04-03T16:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.218 release.
There are 91 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.218-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.218-rc1

disconnect3d <dominik.b.czarnota@gmail.com>
    perf map: Fix off by one in strncpy() size argument

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix IO operations, again

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    bpf: Explicitly memset the bpf_attr structure

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: fix use-after-free in vt_in_use()

Peter Zijlstra <peterz@infradead.org>
    locking/atomic, kref: Add kref_read()

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: remove unnecessary console allocation checks

Jiri Slaby <jslaby@suse.cz>
    vt: switch vt_dont_switch to bool

Jiri Slaby <jslaby@suse.cz>
    vt: ioctl, switch VT_IS_IN_USE and VT_BUSY to inlines

Jiri Slaby <jslaby@suse.cz>
    vt: selection, introduce vc_is_sel

Johan Hovold <johan@kernel.org>
    media: xirlink_cit: add missing descriptor sanity checks

Johan Hovold <johan@kernel.org>
    media: stv06xx: add missing descriptor sanity checks

Johan Hovold <johan@kernel.org>
    media: dib0700: fix rc endpoint lookup

Johan Hovold <johan@kernel.org>
    media: ov519: add missing endpoint sanity checks

Eric Biggers <ebiggers@google.com>
    libfs: fix infoleak in simple_attr_read()

Qiujun Huang <hqjagain@gmail.com>
    staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback

Larry Finger <Larry.Finger@lwfinger.net>
    staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table

Johan Hovold <johan@kernel.org>
    media: usbtv: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: flexcop-usb: fix endpoint sanity check

Mans Rullgard <mans@mansr.com>
    usb: musb: fix crash with highmen PIO and usbmon

Qiujun Huang <hqjagain@gmail.com>
    USB: serial: io_edgeport: fix slab-out-of-bounds read in edge_interrupt_callback

Matthias Reichl <hias@horus.com>
    USB: cdc-acm: restore capability check order

Pawel Dembicki <paweldembicki@gmail.com>
    USB: serial: option: add Wistron Neweb D19Q1

Pawel Dembicki <paweldembicki@gmail.com>
    USB: serial: option: add BroadMobi BM806U

Pawel Dembicki <paweldembicki@gmail.com>
    USB: serial: option: add support for ASKEY WWHC050

Masami Hiramatsu <mhiramat@kernel.org>
    tools: Let O= makes handle a relative path with -C option

Torsten Hilbrich <torsten.hilbrich@secunet.com>
    vti6: Fix memory leak of skb if input policy check fails

YueHaibing <yuehaibing@huawei.com>
    xfrm: policy: Fix doulbe free in xfrm_policy_timer

Xin Long <lucien.xin@gmail.com>
    xfrm: add the missing verify_sec_ctx_len check in xfrm_add_acquire

Xin Long <lucien.xin@gmail.com>
    xfrm: fix uctx len check in verify_sec_ctx_len

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    vti[6]: fix packet tx through bpf_redirect() in XinY cases

Edward Cree <ecree@solarflare.com>
    genirq: Fix reference leaks on irq affinity notifiers

Johannes Berg <johannes.berg@intel.com>
    mac80211: mark station unauthorized before key removal

Martin K. Petersen <martin.petersen@oracle.com>
    scsi: sd: Fix optimal I/O size for devices that change reported values

Dirk Mueller <dmueller@suse.com>
    scripts/dtc: Remove redundant YYLOC global declaration

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Do not depend on dwfl_module_addrsym()

Chuhong Yuan <hslester96@gmail.com>
    i2c: hix5hd2: add missed clk_disable_unprepare in remove

Dominik Czarnota <dominik.b.czarnota@gmail.com>
    sxgbe: Fix off by one in samsung driver strncpy size arg

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    mac80211: Do not send mesh HWMP PREQ if HWMP is disabled

Wen Xiong <wenxiong@linux.vnet.ibm.com>
    scsi: ipr: Fix softlockup when rescanning devices in petitboot

Madalin Bucur <madalin.bucur@nxp.com>
    dt-bindings: net: FMan erratum A050385

Mike Gilbert <floppym@gentoo.org>
    cpupower: avoid multiple definition with gcc -fno-common

Sabrina Dubroca <sd@queasysnail.net>
    net: ipv4: don't let PMTU updates increase route MTU

Matthew Wilcox <willy@linux.intel.com>
    drivers/hwspinlock: use correct radix tree API

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Do not allow reexecute_instruction() when skipping MMIO instr

Jonas Gorski <jonas.gorski@gmail.com>
    uapi glibc compat: fix outer guard of net device flags enum

Alaa Hleihel <alaa@mellanox.com>
    IB/ipoib: Do not warn if IPoIB debugfs doesn't exist

Eugenio Pérez <eperezma@redhat.com>
    vhost: Check docket sk_family instead of call getname

Taehee Yoo <ap420073@gmail.com>
    hsr: set .netnsok flag

Taehee Yoo <ap420073@gmail.com>
    hsr: add restart routine into hsr_get_node_list()

Taehee Yoo <ap420073@gmail.com>
    hsr: use rcu_read_lock() in hsr_get_node_{list/status}()

Taehee Yoo <ap420073@gmail.com>
    vxlan: check return value of gro_cells_init()

Oliver Hartkopp <socketcan@hartkopp.net>
    slcan: not call free_netdev before rtnl_unlock in slcan_open

Dan Carpenter <dan.carpenter@oracle.com>
    NFC: fdp: Fix a signedness bug in fdp_nci_send_patch()

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: keep alloc_hash updated after hash allocation

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: cls_route: remove the right filter from hashtable

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: Fix duplicate frames flooded by learning

Taehee Yoo <ap420073@gmail.com>
    hsr: fix general protection fault in hsr_addr_is_self()

Lyude Paul <lyude@redhat.com>
    Revert "drm/dp_mst: Skip validating ports during destruction, just ref"

Cristian Marussi <cristian.marussi@arm.com>
    arm64: smp: fix smp_send_stop() behaviour

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Fix pop noise on ALC225

Thomas Gleixner <tglx@linutronix.de>
    futex: Unbreak futex hashing

Peter Zijlstra <peterz@infradead.org>
    futex: Fix inode life-time issue

Nathan Chancellor <natechancellor@gmail.com>
    kbuild: Disable -Wpointer-to-enum-cast

Anthony Mallet <anthony.mallet@laas.fr>
    USB: cdc-acm: fix rounding error in TIOCSSERIAL

Anthony Mallet <anthony.mallet@laas.fr>
    USB: cdc-acm: fix close_delay and closing_wait units in TIOCSSERIAL

Joerg Roedel <jroedel@suse.de>
    x86/mm: split vmalloc_sync_all()

Vlastimil Babka <vbabka@suse.cz>
    mm, slub: prevent kmalloc_node crashes and memory leaks

Linus Torvalds <torvalds@linux-foundation.org>
    mm: slub: be more careful about the double cmpxchg of freelist

Chunguang Xu <brookxu@tencent.com>
    memcg: fix NULL pointer dereference in __mem_cgroup_usage_unregister_event

Corentin Labbe <clabbe@baylibre.com>
    rtc: max8907: add missing select REGMAP_IRQ

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: Fix user-visible error codes

Samuel Thibault <samuel.thibault@ens-lyon.org>
    staging/speakup: fix get_word non-space look-ahead

Michael Straube <straube.linux@gmail.com>
    staging: rtl8188eu: Add device id for MERCUSYS MW150US v2

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Remove WARNING from snd_pcm_plug_alloc() checks

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Avoid plugin buffer overflow

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix running status after receiving sysex

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: virmidi: Fix running status after receiving sysex

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix endless MIDI read loop

Scott Chen <scott@labau.com.tw>
    USB: serial: pl2303: add device-id for HP LD381

Ran Wang <ran.wang_1@nxp.com>
    usb: host: xhci-plat: add a shutdown

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add ME910G1 ECM composition 0x110b

Hans de Goede <hdegoede@redhat.com>
    usb: quirks: add NO_LPM quirk for RTL8153 based ethernet adapters

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: Disable LPM on WD19's Realtek Hub

Daniel Axtens <dja@axtens.net>
    altera-stapl: altera_get_note: prevent write beyond end of 'key'

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: dsi: fix workaround for the legacy clock name

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: dsi: propagate error value and silence meaningless warning

Thommy Jakobsson <thommyj@gmail.com>
    spi/zynqmp: remove entry that causes a cs glitch

Kishon Vijay Abraham I <kishon@ti.com>
    ARM: dts: dra7: Add "dma-ranges" property to PCIe RC DT nodes

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc: Include .BTF section

Yuji Sasaki <sasakiy@chromium.org>
    spi: qup: call spi_qup_pm_resume_runtime before suspending


-------------

Diffstat:

 .../devicetree/bindings/powerpc/fsl/fman.txt       |  7 ++
 Makefile                                           |  4 +-
 arch/arm/boot/dts/dra7.dtsi                        |  2 +
 arch/arm64/kernel/smp.c                            | 17 +++-
 arch/powerpc/kernel/vmlinux.lds.S                  |  6 ++
 arch/x86/kvm/vmx.c                                 |  4 +-
 arch/x86/mm/fault.c                                | 26 +++++-
 drivers/acpi/apei/ghes.c                           |  2 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              | 15 +---
 drivers/gpu/drm/exynos/exynos_drm_dsi.c            | 12 +--
 drivers/hwspinlock/hwspinlock_core.c               |  2 +-
 drivers/hwtracing/intel_th/msu.c                   |  6 +-
 drivers/i2c/busses/i2c-hix5hd2.c                   |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_fs.c            |  2 -
 drivers/media/usb/b2c2/flexcop-usb.c               |  6 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |  4 +-
 drivers/media/usb/gspca/ov519.c                    | 10 +++
 drivers/media/usb/gspca/stv06xx/stv06xx.c          | 19 ++++-
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c   |  4 +
 drivers/media/usb/gspca/xirlink_cit.c              | 18 ++++-
 drivers/media/usb/usbtv/usbtv-core.c               |  2 +-
 drivers/misc/altera-stapl/altera.c                 | 12 +--
 drivers/net/can/slcan.c                            |  3 +
 drivers/net/ethernet/micrel/ks8851_mll.c           | 56 ++++++++++++-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |  2 +-
 drivers/net/vxlan.c                                | 11 ++-
 drivers/nfc/fdp/fdp.c                              |  5 +-
 drivers/rtc/Kconfig                                |  1 +
 drivers/scsi/ipr.c                                 |  3 +-
 drivers/scsi/ipr.h                                 |  1 +
 drivers/scsi/sd.c                                  |  4 +-
 drivers/spi/spi-qup.c                              |  5 ++
 drivers/spi/spi-zynqmp-gqspi.c                     |  3 -
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |  2 +
 drivers/staging/speakup/main.c                     |  3 +-
 drivers/staging/wlan-ng/hfa384x_usb.c              |  2 +
 drivers/tty/vt/selection.c                         |  5 ++
 drivers/tty/vt/vt.c                                | 30 ++++++-
 drivers/tty/vt/vt_ioctl.c                          | 80 ++++++++++---------
 drivers/usb/class/cdc-acm.c                        | 20 +++--
 drivers/usb/core/quirks.c                          |  6 ++
 drivers/usb/host/xhci-plat.c                       |  1 +
 drivers/usb/musb/musb_host.c                       | 17 ++--
 drivers/usb/serial/io_edgeport.c                   |  2 +-
 drivers/usb/serial/option.c                        |  8 ++
 drivers/usb/serial/pl2303.c                        |  1 +
 drivers/usb/serial/pl2303.h                        |  1 +
 drivers/vhost/net.c                                | 13 +--
 fs/inode.c                                         |  1 +
 fs/libfs.c                                         |  8 +-
 include/linux/fs.h                                 |  1 +
 include/linux/futex.h                              | 17 ++--
 include/linux/kref.h                               |  5 ++
 include/linux/selection.h                          |  4 +-
 include/linux/vmalloc.h                            |  5 +-
 include/linux/vt_kern.h                            |  2 +-
 include/uapi/linux/if.h                            |  4 +-
 kernel/bpf/syscall.c                               |  3 +-
 kernel/futex.c                                     | 93 +++++++++++++---------
 kernel/irq/manage.c                                | 11 ++-
 kernel/notifier.c                                  |  2 +-
 mm/memcontrol.c                                    | 10 ++-
 mm/nommu.c                                         | 10 ++-
 mm/slub.c                                          | 32 +++++---
 mm/vmalloc.c                                       | 11 ++-
 net/dsa/tag_brcm.c                                 |  2 +
 net/hsr/hsr_framereg.c                             | 10 +--
 net/hsr/hsr_netlink.c                              | 74 +++++++++--------
 net/hsr/hsr_slave.c                                |  8 +-
 net/ipv4/Kconfig                                   |  1 +
 net/ipv4/ip_vti.c                                  | 38 +++++++--
 net/ipv4/route.c                                   |  7 +-
 net/ipv6/ip6_vti.c                                 | 34 ++++++--
 net/mac80211/mesh_hwmp.c                           |  3 +-
 net/mac80211/sta_info.c                            |  6 ++
 net/sched/cls_route.c                              |  4 +-
 net/sched/cls_tcindex.c                            |  1 +
 net/xfrm/xfrm_policy.c                             |  2 +
 net/xfrm/xfrm_user.c                               |  6 +-
 scripts/Makefile.extrawarn                         |  1 +
 scripts/dtc/dtc-lexer.l                            |  1 -
 sound/core/oss/pcm_plugin.c                        | 12 ++-
 sound/core/seq/oss/seq_oss_midi.c                  |  1 +
 sound/core/seq/seq_virmidi.c                       |  1 +
 sound/pci/hda/patch_realtek.c                      |  2 +
 sound/usb/line6/driver.c                           |  2 +-
 sound/usb/line6/midibuf.c                          |  2 +-
 tools/perf/Makefile                                |  2 +-
 tools/perf/util/map.c                              |  2 +-
 tools/perf/util/probe-finder.c                     | 11 ++-
 .../cpupower/utils/idle_monitor/amd_fam14h_idle.c  |  2 +-
 .../cpupower/utils/idle_monitor/cpuidle_sysfs.c    |  2 +-
 .../cpupower/utils/idle_monitor/cpupower-monitor.c |  2 +
 .../cpupower/utils/idle_monitor/cpupower-monitor.h |  2 +-
 tools/scripts/Makefile.include                     |  4 +-
 95 files changed, 632 insertions(+), 298 deletions(-)


