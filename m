Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C366C13A5D1
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgANKDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:03:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729619AbgANKDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:03:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9B692467C;
        Tue, 14 Jan 2020 10:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996222;
        bh=3XsOTJrVvKglDmBQbPJB2HD6lKqdyH+zb8JyzeMaBxw=;
        h=From:To:Cc:Subject:Date:From;
        b=epa7BxEBQRyL7AbxfDeP5mVFhg/iLDqmcQyztv0CkgQEznCoAetvb3MbZKzoreGJd
         GLTHRO98CZaWaAF+8SFW/snt1oRjQX7jT8LFRf+IqTv+96B0yNCYveGJjWDtZmPnPM
         Gv0wVqrr7p5CvrvsaBjCeK685/DgH6LhHOhXBe9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/78] 5.4.12-stable review
Date:   Tue, 14 Jan 2020 11:00:34 +0100
Message-Id: <20200114094352.428808181@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.12-rc1
X-KernelTest-Deadline: 2020-01-16T09:44+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.12 release.
There are 78 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.12-rc1

Florian Westphal <fw@strlen.de>
    netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: dccp, sctp: handle null timeout argument

Florian Westphal <fw@strlen.de>
    netfilter: arp_tables: init netns pointer in xt_tgchk_param struct

Tony Lindgren <tony@atomide.com>
    phy: cpcap-usb: Fix flakey host idling and enumerating of devices

Tony Lindgren <tony@atomide.com>
    phy: cpcap-usb: Fix error path when no host driver is loaded

Alan Stern <stern@rowland.harvard.edu>
    USB: Fix: Don't skip endpoint descriptors with maxpacket=0

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: hiddev: fix mess in hiddev_open()

Navid Emamdoost <navid.emamdoost@gmail.com>
    ath10k: fix memory leak

Navid Emamdoost <navid.emamdoost@gmail.com>
    rtl8xxxu: prevent leaking urb

Navid Emamdoost <navid.emamdoost@gmail.com>
    scsi: bfa: release allocated memory in case of error

Navid Emamdoost <navid.emamdoost@gmail.com>
    rpmsg: char: release allocated memory

Navid Emamdoost <navid.emamdoost@gmail.com>
    mwifiex: pcie: Fix memory leak in mwifiex_pcie_alloc_cmdrsp_buf

Ganapathi Bhat <gbhat@marvell.com>
    mwifiex: fix possible heap overflow in mwifiex_process_country_ie()

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: remove bool from vnt_radio_power_on ret

Amanieu d'Antras <amanieu@gmail.com>
    um: Implement copy_thread_tls

Amanieu d'Antras <amanieu@gmail.com>
    clone3: ensure copy_thread_tls is implemented

Amanieu d'Antras <amanieu@gmail.com>
    xtensa: Implement copy_thread_tls

Amanieu d'Antras <amanieu@gmail.com>
    riscv: Implement copy_thread_tls

Amanieu d'Antras <amanieu@gmail.com>
    parisc: Implement copy_thread_tls

Amanieu d'Antras <amanieu@gmail.com>
    arm: Implement copy_thread_tls

Amanieu d'Antras <amanieu@gmail.com>
    arm64: Implement copy_thread_tls

Amanieu d'Antras <amanieu@gmail.com>
    arm64: Move __ARCH_WANT_SYS_CLONE3 definition to uapi headers

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    tty: always relink the port

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    tty: link tty and port before configuring it as console

Patrick Steinhardt <ps@pks.im>
    iommu/vt-d: Fix adding non-PCI devices to Intel IOMMU

Punit Agrawal <punit1.agrawal@toshiba.co.jp>
    serdev: Don't claim unsupported ACPI serial devices

Michael Straube <straube.linux@gmail.com>
    staging: rtl8188eu: Add device code for TP-Link TL-WN727N v5.21

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: limit reg output to block size

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: correct return of vnt_init_registers.

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: adv_pci1710: fix AI channels 16-31 for PCI-1713

Paul Cercueil <paul@crapouillou.net>
    usb: musb: dma: Correct parameter passed to IRQ handler

Paul Cercueil <paul@crapouillou.net>
    usb: musb: Disable pullup at init

Tony Lindgren <tony@atomide.com>
    usb: musb: fix idling for suspend after disconnect interrupt

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add ZLP support for 0x1bc7/0x9010

Douglas Gilbert <dgilbert@interlog.com>
    USB-PD tcpm: bad warning+size, PPS adapters

Colin Ian King <colin.king@canonical.com>
    usb: ohci-da8xx: ensure error return on variable error is set

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: should not use the same dev_id for shared interrupt handler

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix non zero logical return of, usb_control_msg

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: set usb_set_intfdata on driver fail.

Kees Cook <keescook@chromium.org>
    pstore/ram: Regularize prz label allocation lifetime

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Add honor_wakeup module-option + quirk mechanism

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Turn dmi_system_id table into a generic quirk table

Oliver Hartkopp <socketcan@hartkopp.net>
    can: can_dropped_invalid_skb(): ensure an initialized headroom in outgoing CAN sk_buffs

Florian Faber <faber@faberman.de>
    can: mscan: mscan_rx_poll(): fix rx path lockup when returning from polling to irq mode

Sean Nyekjaer <sean@geanix.com>
    can: tcan4x5x: tcan4x5x_can_probe(): get the device out of standby before register access

Johan Hovold <johan@kernel.org>
    can: gs_usb: gs_usb_probe(): use descriptors of current altsetting

Johan Hovold <johan@kernel.org>
    can: kvaser_usb: fix interface sanity check

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Adjust flow PSN with the correct resync_psn

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Mark up virtual engine uabi_instance

Matt Roper <matthew.d.roper@intel.com>
    drm/i915: Add Wa_1407352427:icl,ehl

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: correct the shifting in DP_REMOTE_I2C_READ

Geert Uytterhoeven <geert+renesas@glider.be>
    drm/fb-helper: Round up bits_per_pixel if possible

Chen-Yu Tsai <wens@csie.org>
    drm/sun4i: tcon: Set RGB DCLK min. divider based on hardware model

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amdgpu: Set no-retry as default."

Chunming Zhou <david1.zhou@amd.com>
    drm/amdgpu: add DRIVER_SYNCOBJ_TIMELINE to amdgpu

Matt Roper <matthew.d.roper@intel.com>
    drm/i915: Add Wa_1408615072 and Wa_1407596294 to icl,ehl

Arnd Bergmann <arnd@arndb.de>
    Input: input_event - fix struct padding on sparc64

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: add safety guards to input_set_keycode()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: hid-input: clear unmapped usages

Marcel Holtmann <marcel@holtmann.org>
    HID: hidraw: Fix returning EPOLLOUT from hidraw_poll

Marcel Holtmann <marcel@holtmann.org>
    HID: uhid: Fix returning EPOLLOUT from uhid_char_poll

Alan Stern <stern@rowland.harvard.edu>
    HID: Fix slab-out-of-bounds read in hid_field_extract

Joel Fernandes (Google) <joel@joelfernandes.org>
    tracing: Change offset type to s32 in preempt/irq tracepoints

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Have stack tracer compile when MCOUNT_INSN_SIZE is not defined

Kaitao Cheng <pilgrimtao@gmail.com>
    kernel/trace: Fix do not unregister tracepoints when register sched_migrate_task fail

Chen-Yu Tsai <wens@csie.org>
    rtc: sun6i: Add support for RTC clocks on R40

Tadeusz Struk <tadeusz.struk@intel.com>
    tpm: Handle negative priv->response_len in tpm_common_read()

Stefan Berger <stefanb@linux.ibm.com>
    tpm: Revert "tpm_tis_core: Turn on the TPM before probing IRQ's"

Stefan Berger <stefanb@linux.ibm.com>
    tpm: Revert "tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts"

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
    tpm: Revert "tpm_tis: reserve chip for duration of tpm_tis_core_init"

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add quirk for the bass speaker on Lenovo Yoga X1 7th gen

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Set EAPD control to default for ALC222

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add new codec supported for ALCS1200A

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Apply the sample rate quirk for Bose Companion 5

Guenter Roeck <linux@roeck-us.net>
    usb: chipidea: host: Disable port power only if previously enabled

Harry Pan <harry.pan@intel.com>
    powercap: intel_rapl: add NULL pointer check to rapl_mmio_cpu_online()

Russell King <rmk+kernel@armlinux.org.uk>
    i2c: fix bus recovery stop mode timing

Will Deacon <will@kernel.org>
    chardev: Avoid potential use-after-free in 'chrdev_open()'


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/Kconfig                                   |  1 +
 arch/arm/kernel/process.c                          |  6 +-
 arch/arm64/Kconfig                                 |  1 +
 arch/arm64/include/asm/unistd.h                    |  1 -
 arch/arm64/include/uapi/asm/unistd.h               |  1 +
 arch/arm64/kernel/process.c                        | 10 +--
 arch/parisc/Kconfig                                |  1 +
 arch/parisc/kernel/process.c                       |  8 +-
 arch/riscv/Kconfig                                 |  1 +
 arch/riscv/kernel/process.c                        |  6 +-
 arch/um/Kconfig                                    |  1 +
 arch/um/include/asm/ptrace-generic.h               |  2 +-
 arch/um/kernel/process.c                           |  6 +-
 arch/x86/um/tls_32.c                               |  6 +-
 arch/x86/um/tls_64.c                               |  7 +-
 arch/xtensa/Kconfig                                |  1 +
 arch/xtensa/kernel/process.c                       |  8 +-
 drivers/char/tpm/tpm-dev-common.c                  |  2 +-
 drivers/char/tpm/tpm-dev.h                         |  2 +-
 drivers/char/tpm/tpm_tis_core.c                    | 34 ++++----
 drivers/gpio/gpiolib-acpi.c                        | 51 ++++++++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  7 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  2 +-
 drivers/gpu/drm/drm_fb_helper.c                    |  7 +-
 drivers/gpu/drm/i915/gt/intel_lrc.c                |  2 +
 drivers/gpu/drm/i915/i915_reg.h                    |  8 +-
 drivers/gpu/drm/i915/intel_pm.c                    | 11 +++
 drivers/gpu/drm/sun4i/sun4i_tcon.c                 | 15 +++-
 drivers/gpu/drm/sun4i/sun4i_tcon.h                 |  1 +
 drivers/hid/hid-core.c                             |  6 ++
 drivers/hid/hid-input.c                            | 16 +++-
 drivers/hid/hidraw.c                               |  4 +-
 drivers/hid/uhid.c                                 |  2 +-
 drivers/hid/usbhid/hiddev.c                        | 97 ++++++++++------------
 drivers/i2c/i2c-core-base.c                        | 13 ++-
 drivers/infiniband/hw/hfi1/tid_rdma.c              |  9 ++
 drivers/input/evdev.c                              | 14 ++--
 drivers/input/input.c                              | 26 +++---
 drivers/input/misc/uinput.c                        | 14 ++--
 drivers/iommu/intel-iommu.c                        |  9 +-
 drivers/net/can/m_can/tcan4x5x.c                   |  4 +
 drivers/net/can/mscan/mscan.c                      | 21 +++--
 drivers/net/can/usb/gs_usb.c                       |  4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |  2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |  2 +-
 drivers/net/wireless/ath/ath10k/usb.c              |  1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        |  4 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   | 13 ++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  1 +
 drivers/phy/motorola/phy-cpcap-usb.c               | 35 ++++----
 drivers/powercap/intel_rapl_common.c               |  3 +
 drivers/rpmsg/rpmsg_char.c                         |  6 +-
 drivers/rtc/rtc-sun6i.c                            | 16 ++++
 drivers/scsi/bfa/bfad_attr.c                       |  4 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |  4 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |  1 +
 drivers/staging/vt6656/baseband.c                  |  4 +-
 drivers/staging/vt6656/card.c                      |  2 +-
 drivers/staging/vt6656/device.h                    |  1 +
 drivers/staging/vt6656/main_usb.c                  |  3 +-
 drivers/staging/vt6656/usbpipe.c                   | 25 +++++-
 drivers/staging/vt6656/usbpipe.h                   |  5 ++
 drivers/staging/vt6656/wcmd.c                      |  1 +
 drivers/tty/serdev/core.c                          | 10 +++
 drivers/tty/serial/serial_core.c                   |  1 +
 drivers/usb/cdns3/gadget.c                         | 14 ++--
 drivers/usb/chipidea/host.c                        |  4 +-
 drivers/usb/core/config.c                          | 12 ++-
 drivers/usb/host/ohci-da8xx.c                      |  8 +-
 drivers/usb/musb/musb_core.c                       | 11 +++
 drivers/usb/musb/musbhsdma.c                       |  2 +-
 drivers/usb/serial/option.c                        |  8 ++
 drivers/usb/serial/usb-wwan.h                      |  1 +
 drivers/usb/serial/usb_wwan.c                      |  4 +
 drivers/usb/typec/tcpm/tcpci.c                     | 20 +++--
 fs/char_dev.c                                      |  2 +-
 fs/pstore/ram.c                                    |  4 +-
 fs/pstore/ram_core.c                               |  2 +-
 include/linux/can/dev.h                            | 34 ++++++++
 include/trace/events/preemptirq.h                  |  8 +-
 include/uapi/linux/input.h                         |  1 +
 kernel/fork.c                                      | 10 +++
 kernel/trace/trace_sched_wakeup.c                  |  4 +-
 kernel/trace/trace_stack.c                         |  5 ++
 net/ipv4/netfilter/arp_tables.c                    | 27 +++---
 net/netfilter/ipset/ip_set_core.c                  |  3 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |  3 +
 net/netfilter/nf_conntrack_proto_sctp.c            |  3 +
 sound/pci/hda/patch_realtek.c                      |  5 ++
 sound/usb/quirks.c                                 |  1 +
 91 files changed, 547 insertions(+), 245 deletions(-)


