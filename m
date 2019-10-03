Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6E9CABAA
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfJCP5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729537AbfJCP5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:57:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90A3820700;
        Thu,  3 Oct 2019 15:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118263;
        bh=Ui6AaSraK1/UCtiGfk+FXIRayIxoS9FPoB/0XAkaSi8=;
        h=From:To:Cc:Subject:Date:From;
        b=YCLCuy/nAtmwmQMULo18EnUBvxIaCySSMYcJu06KgetciiB4Komq5UuHLxmGP32SE
         ud5b7V/bVgRukNO18jgtUZJWYAitL9EtgDj4f3r84kR1GVbuLnIPGqThRYXDSQxe0P
         GGIpm+8DrfcT30lf3zG30wpG5cX794YXDuLppIYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/99] 4.4.195-stable review
Date:   Thu,  3 Oct 2019 17:52:23 +0200
Message-Id: <20191003154252.297991283@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.195-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.195-rc1
X-KernelTest-Deadline: 2019-10-05T15:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.195 release.
There are 99 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.195-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.195-rc1

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race setting up and completing qgroup rescan workers

Nikolay Borisov <nborisov@suse.com>
    btrfs: Relinquish CPUs in btrfs_compare_trees

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix use-after-free when using the tree modification log

Mark Salyzyn <salyzyn@android.com>
    ovl: filter of trusted xattr results in audit

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix oplock handling for SMB 2.1+ protocols

Chris Brandt <chris.brandt@renesas.com>
    i2c: riic: Clear NACK in tend isr

Laurent Vivier <lvivier@redhat.com>
    hwrng: core - don't wait on add_early_randomness()

Chao Yu <yuchao0@huawei.com>
    quota: fix wrong condition in is_quota_modification()

Theodore Ts'o <tytso@mit.edu>
    ext4: fix punch hole for inline_data file systems

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    /dev/mem: Bail out upon SIGKILL.

Denis Kenzior <denkenz@gmail.com>
    cfg80211: Purge frame registrations on iftype change

Xiao Ni <xni@redhat.com>
    md/raid6: Set R5_ReadError when there is read failure on parity disk

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP

Luis Araneda <luaraneda@gmail.com>
    ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up

Amadeusz Sławiński <amadeuszx.slawinski@intel.com>
    ASoC: Intel: Fix use of potentially uninitialized variable

Hans de Goede <hdegoede@redhat.com>
    media: sn9c20x: Add MSI MS-1039 laptop to flip_dmi_table

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Manually calculate reserved bits when loading PDPTRS

Jan Dakinevich <jan.dakinevich@virtuozzo.com>
    KVM: x86: set ctxt->have_exception in x86_decode_insn()

Jan Dakinevich <jan.dakinevich@virtuozzo.com>
    KVM: x86: always stop emulation on page fault

Helge Deller <deller@gmx.de>
    parisc: Disable HP HSC-PCI Cards to prevent kernel crash

Vasily Averin <vvs@virtuozzo.com>
    fuse: fix missing unlock_page in fuse_writepage()

Vincent Whitchurch <vincent.whitchurch@axis.com>
    printk: Do not lose last line in kmsg buffer dump

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-tascam: check intermediate state of clock status and retry

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-tascam: handle error code when getting current source of clock

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: omap3isp: Set device on omap3isp subdevs

Qu Wenruo <wqu@suse.com>
    btrfs: extent-tree: Make sure we only allocate extents from block groups with the same type

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Blacklist PC beep for Lenovo ThinkCentre M73/93

Tomas Bortoli <tomasbortoli@gmail.com>
    media: ttusb-dec: Fix info-leak in ttusb_dec_send_command()

Kevin Easton <kevin@guarana.org>
    libertas: Add missing sentinel at end of if_usb.c fw_table

Al Cooper <alcooperx@gmail.com>
    mmc: sdhci: Fix incorrect switch to HS mode

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: dmaengine: Make the pcm->name equal to pcm->id if the name is not set

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Prohibit probing on BUG() and WARN() address

Peter Ujfalusi <peter.ujfalusi@ti.com>
    dmaengine: ti: edma: Do not reset reserved paRAM slots

Yufen Yu <yuyufen@huawei.com>
    md/raid1: fail run raid1 array when active disk less than one

Wang Shenran <shenran268@gmail.com>
    hwmon: (acpi_power_meter) Change log level for 'unsafe software power cap'

Wenwen Wang <wenwen@cs.uga.edu>
    ACPI: custom_method: fix memory leaks

Tzvetomir Stoyanov <tstoyanov@vmware.com>
    libtraceevent: Change users plugin directory

Al Stone <ahs3@redhat.com>
    ACPI / CPPC: do not require the _PSD method

Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
    media: ov9650: add a sanity check

Maciej S. Szmigiero <mail@maciej.szmigiero.name>
    media: saa7134: fix terminology around saa7134_i2c_eeprom_md7134_gate()

Wenwen Wang <wenwen@cs.uga.edu>
    media: cpia2_usb: fix memory leaks

Wenwen Wang <wenwen@cs.uga.edu>
    media: saa7146: add cleanup in hexium_attach()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: hdpvr: add terminating 0 at end of string

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: radio/si470x: kill urb on error

Arnd Bergmann <arnd@arndb.de>
    net: lpc-enet: fix printk format strings

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: omap3isp: Don't set streaming state on random subdevs

Arnd Bergmann <arnd@arndb.de>
    dmaengine: iop-adma: use correct printk format strings

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: gspca: zero usb_buf on error

Xiaofei Tan <tanxiaofei@huawei.com>
    efi: cper: print AER info of PCIe fatal error

Guoqing Jiang <jgq516@gmail.com>
    md: don't set In_sync if array is frozen

Guoqing Jiang <jgq516@gmail.com>
    md: don't call spare_active in md_reap_sync_thread if all member devices can't work

chenzefeng <chenzefeng2@huawei.com>
    ia64:unwind: fix double free for mod->arch.init_unw_table

Ard van Breemen <ard@kwaak.net>
    ALSA: usb-audio: Skip bSynchAddress endpoint check if it is invalid

Vinod Koul <vkoul@kernel.org>
    base: soc: Export soc_device_register/unregister APIs

Oliver Neukum <oneukum@suse.com>
    media: iguanair: add sanity checks

Jia-Ju Bai <baijiaju1990@gmail.com>
    ALSA: i2c: ak4xxx-adda: Fix a possible null pointer dereference in build_adc_controls()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Show the fatal CORB/RIRB error more clearly

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Soft disable APIC before initializing it

Grzegorz Halat <ghalat@redhat.com>
    x86/reboot: Always use NMI fallback when shutdown via reboot vector IPI fails

Juri Lelli <juri.lelli@redhat.com>
    sched/core: Fix CPU controller for !RT_GROUP_SCHED

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix imbalance due to CPU affinity

Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
    media: hdpvr: Add device num check and handling

Arnd Bergmann <arnd@arndb.de>
    media: dib0700: fix link error for dibx000_i2c_set_speed

Nick Stoughton <nstoughton@logitech.com>
    leds: leds-lp5562 allow firmware files up to the maximum length

Stefan Wahren <wahrenst@gmx.net>
    dmaengine: bcm2835: Print error in case setting DMA mask fails

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ASoC: sgtl5000: Fix charge pump source assignment

Chris Wilson <chris@chris-wilson.co.uk>
    ALSA: hda: Flush interrupts on disabling

Ori Nimron <orinimron123@gmail.com>
    nfc: enforce CAP_NET_RAW for raw sockets

Ori Nimron <orinimron123@gmail.com>
    ieee802154: enforce CAP_NET_RAW for raw sockets

Ori Nimron <orinimron123@gmail.com>
    ax25: enforce CAP_NET_RAW for raw sockets

Ori Nimron <orinimron123@gmail.com>
    appletalk: enforce CAP_NET_RAW for raw sockets

Ori Nimron <orinimron123@gmail.com>
    mISDN: enforce CAP_NET_RAW for raw sockets

Oliver Neukum <oneukum@suse.com>
    usbnet: sanity checking of packet sizes and device mtu

Bjørn Mork <bjorn@mork.no>
    usbnet: ignore endpoints with invalid wMaxPacketSize

Stephen Hemminger <stephen@networkplumber.org>
    skge: fix checksum byte order

Eric Dumazet <edumazet@google.com>
    sch_netem: fix a divide by zero in tabledist()

Li RongQing <lirongqing@baidu.com>
    openvswitch: change type of UPCALL_PID attribute to NLA_UNSPEC

Peter Mamonov <pmamonov@gmail.com>
    net/phy: fix DP83865 10 Mbps HDX loopback disable function

Bjørn Mork <bjorn@mork.no>
    cdc_ncm: fix divide-by-zero caused by invalid wMaxPacketSize

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    arcnet: provide a buffer big enough to actually receive packets

Jian-Hong Pan <jian-hong@endlessm.com>
    Bluetooth: btrtl: Additional Realtek 8822CE Bluetooth devices

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Flush output polling on shutdown

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to do sanity check on segment bitmap of LFS curseg

Chao Yu <yuchao0@huawei.com>
    Revert "f2fs: avoid out-of-range memory access"

Surbhi Palande <f2fsnewbie@gmail.com>
    f2fs: check all the data segments against all node ones

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3-its: Fix LPI release for Multi-MSI devices

Waiman Long <longman@redhat.com>
    locking/lockdep: Add debug_locks check in __lock_downgrade()

Yu Wang <yyuwang@codeaurora.org>
    mac80211: handle deauthentication/disassociation from TDLS peer

Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
    mac80211: Print text for disassociation reason

Shih-Yuan Lee (FourDollars) <fourdollars@debian.org>
    ALSA: hda - Add laptop imic fixup for ASUS M9V laptop

Takashi Iwai <tiwai@suse.de>
    ASoC: fsl: Fix of-node refcount unbalance in fsl_ssi_probe_from_dt()

Mao Wenan <maowenan@huawei.com>
    net: rds: Fix NULL ptr use in rds_tcp_kill_sock

Gustavo A. R. Silva <gustavo@embeddedor.com>
    crypto: talitos - fix missing break in switch statement

Tokunori Ikegami <ikegami.t@gmail.com>
    mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()

Alan Stern <stern@rowland.harvard.edu>
    HID: hidraw: Fix invalid read in hidraw_ioctl

Alan Stern <stern@rowland.harvard.edu>
    HID: logitech: Fix general protection fault caused by Logitech driver

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: lg: make transfer buffers DMA capable

Alan Stern <stern@rowland.harvard.edu>
    HID: prodikeys: Fix general protection fault during probe

Marcel Holtmann <marcel@holtmann.org>
    Revert "Bluetooth: validate BLE connection interval updates"


-------------

Diffstat:

 Makefile                                      |  4 +--
 arch/arm/mach-zynq/platsmp.c                  |  2 +-
 arch/ia64/kernel/module.c                     |  8 +++--
 arch/x86/kernel/apic/apic.c                   |  8 +++++
 arch/x86/kernel/smp.c                         | 46 ++++++++++++++++-----------
 arch/x86/kvm/emulate.c                        |  2 ++
 arch/x86/kvm/x86.c                            | 21 +++++++++---
 drivers/acpi/cppc_acpi.c                      |  6 ++--
 drivers/acpi/custom_method.c                  |  5 ++-
 drivers/base/soc.c                            |  2 ++
 drivers/bluetooth/btusb.c                     |  3 ++
 drivers/char/hw_random/core.c                 |  2 +-
 drivers/char/mem.c                            | 21 ++++++++++++
 drivers/crypto/talitos.c                      |  1 +
 drivers/dma/bcm2835-dma.c                     |  4 ++-
 drivers/dma/edma.c                            |  9 ++++--
 drivers/dma/iop-adma.c                        | 18 +++++------
 drivers/firmware/efi/cper.c                   | 15 +++++++++
 drivers/gpu/drm/drm_probe_helper.c            |  9 +++++-
 drivers/hid/hid-lg.c                          | 22 +++++++++----
 drivers/hid/hid-lg4ff.c                       |  1 -
 drivers/hid/hid-prodikeys.c                   | 12 +++++--
 drivers/hid/hidraw.c                          |  2 +-
 drivers/hwmon/acpi_power_meter.c              |  4 +--
 drivers/i2c/busses/i2c-riic.c                 |  1 +
 drivers/irqchip/irq-gic-v3-its.c              |  9 +++---
 drivers/isdn/mISDN/socket.c                   |  2 ++
 drivers/leds/leds-lp5562.c                    |  6 +++-
 drivers/md/md.c                               | 14 ++++++--
 drivers/md/raid1.c                            | 13 +++++++-
 drivers/md/raid5.c                            |  4 ++-
 drivers/media/i2c/ov9650.c                    |  5 +++
 drivers/media/pci/saa7134/saa7134-i2c.c       | 12 ++++---
 drivers/media/pci/saa7146/hexium_gemini.c     |  3 ++
 drivers/media/platform/omap3isp/isp.c         |  8 +++++
 drivers/media/platform/omap3isp/ispccdc.c     |  1 +
 drivers/media/platform/omap3isp/ispccp2.c     |  1 +
 drivers/media/platform/omap3isp/ispcsi2.c     |  1 +
 drivers/media/platform/omap3isp/isppreview.c  |  1 +
 drivers/media/platform/omap3isp/ispresizer.c  |  1 +
 drivers/media/platform/omap3isp/ispstat.c     |  2 ++
 drivers/media/radio/si470x/radio-si470x-usb.c |  5 ++-
 drivers/media/rc/iguanair.c                   | 15 ++++-----
 drivers/media/usb/cpia2/cpia2_usb.c           |  4 +++
 drivers/media/usb/dvb-usb/dib0700_devices.c   |  8 +++++
 drivers/media/usb/gspca/konica.c              |  5 +++
 drivers/media/usb/gspca/nw80x.c               |  5 +++
 drivers/media/usb/gspca/ov519.c               | 10 ++++++
 drivers/media/usb/gspca/ov534.c               |  5 +++
 drivers/media/usb/gspca/ov534_9.c             |  1 +
 drivers/media/usb/gspca/se401.c               |  5 +++
 drivers/media/usb/gspca/sn9c20x.c             | 12 +++++++
 drivers/media/usb/gspca/sonixb.c              |  5 +++
 drivers/media/usb/gspca/sonixj.c              |  5 +++
 drivers/media/usb/gspca/spca1528.c            |  5 +++
 drivers/media/usb/gspca/sq930x.c              |  5 +++
 drivers/media/usb/gspca/sunplus.c             |  5 +++
 drivers/media/usb/gspca/vc032x.c              |  5 +++
 drivers/media/usb/gspca/w996Xcf.c             |  5 +++
 drivers/media/usb/hdpvr/hdpvr-core.c          | 13 +++++++-
 drivers/media/usb/ttusb-dec/ttusb_dec.c       |  2 +-
 drivers/mmc/host/sdhci.c                      |  4 ++-
 drivers/mtd/chips/cfi_cmdset_0002.c           | 18 +++++++----
 drivers/net/arcnet/arcnet.c                   | 31 ++++++++++--------
 drivers/net/ethernet/marvell/skge.c           |  2 +-
 drivers/net/ethernet/nxp/lpc_eth.c            | 13 ++++----
 drivers/net/phy/national.c                    |  9 ++++--
 drivers/net/usb/cdc_ncm.c                     |  6 +++-
 drivers/net/usb/usbnet.c                      |  8 +++++
 drivers/net/wireless/libertas/if_usb.c        |  3 +-
 drivers/parisc/dino.c                         | 24 ++++++++++++++
 fs/btrfs/ctree.c                              |  5 ++-
 fs/btrfs/extent-tree.c                        |  8 +++++
 fs/btrfs/qgroup.c                             | 33 +++++++++++--------
 fs/cifs/smb2ops.c                             |  5 +++
 fs/ext4/inode.c                               |  9 ++++++
 fs/f2fs/segment.c                             | 44 ++++++++++++++++++++++---
 fs/f2fs/super.c                               |  4 +--
 fs/fuse/file.c                                |  1 +
 fs/overlayfs/inode.c                          |  3 +-
 include/linux/bug.h                           |  5 +++
 include/linux/quotaops.h                      |  2 +-
 kernel/kprobes.c                              |  3 +-
 kernel/locking/lockdep.c                      |  3 ++
 kernel/printk/printk.c                        |  2 +-
 kernel/sched/core.c                           |  4 ---
 kernel/sched/fair.c                           |  5 +--
 kernel/time/alarmtimer.c                      |  4 +--
 net/appletalk/ddp.c                           |  5 +++
 net/ax25/af_ax25.c                            |  2 ++
 net/bluetooth/hci_event.c                     |  5 ---
 net/bluetooth/l2cap_core.c                    |  9 +-----
 net/ieee802154/socket.c                       |  3 ++
 net/mac80211/ieee80211_i.h                    |  3 ++
 net/mac80211/mlme.c                           | 17 ++++++++--
 net/mac80211/tdls.c                           | 23 ++++++++++++++
 net/nfc/llcp_sock.c                           |  7 ++--
 net/openvswitch/datapath.c                    |  2 +-
 net/rds/tcp.c                                 |  8 +++--
 net/sched/sch_netem.c                         |  2 +-
 net/wireless/util.c                           |  1 +
 sound/firewire/tascam/tascam-pcm.c            |  3 ++
 sound/firewire/tascam/tascam-stream.c         | 42 ++++++++++++++++--------
 sound/hda/hdac_controller.c                   |  2 ++
 sound/i2c/other/ak4xxx-adda.c                 |  7 ++--
 sound/pci/hda/hda_controller.c                |  5 ++-
 sound/pci/hda/hda_intel.c                     |  2 +-
 sound/pci/hda/patch_analog.c                  |  1 +
 sound/pci/hda/patch_realtek.c                 |  3 ++
 sound/soc/codecs/sgtl5000.c                   | 15 ++++++---
 sound/soc/fsl/fsl_ssi.c                       |  5 ++-
 sound/soc/intel/common/sst-ipc.c              |  2 ++
 sound/soc/soc-generic-dmaengine-pcm.c         |  6 ++++
 sound/usb/pcm.c                               |  1 +
 tools/lib/traceevent/Makefile                 |  6 ++--
 tools/lib/traceevent/event-plugin.c           |  2 +-
 116 files changed, 679 insertions(+), 204 deletions(-)


