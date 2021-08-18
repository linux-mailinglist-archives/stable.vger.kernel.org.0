Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2612D3EFE0F
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 09:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239122AbhHRHo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 03:44:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238978AbhHRHo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 03:44:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 012236108B;
        Wed, 18 Aug 2021 07:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629272664;
        bh=vdbL1fZZcvuIS+Bt9YIx3PjQsLsk58AAsGksSiPvATY=;
        h=From:To:Cc:Subject:Date:From;
        b=1yAdgfjYrWu6WcSWg/P8Z3dHsNjsMDZxytigGqSQCHImm2vtJUCpAEZp2Nh60in0p
         oEkALO3zeQe3uM79zm3deaACAK9l0hu07JvYBpTvcJuIRvdoHSw0QO6avSzsjKTNLc
         hAs6sc0lBOBmIZMzJGXIAYjze5QA5L7de1U4oPUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.142
Date:   Wed, 18 Aug 2021 09:44:21 +0200
Message-Id: <162927266123958@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.142 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    2 
 arch/powerpc/kernel/kprobes.c                            |    3 
 arch/x86/include/asm/svm.h                               |    2 
 arch/x86/kernel/apic/io_apic.c                           |    6 
 arch/x86/kernel/apic/msi.c                               |   13 +
 arch/x86/kernel/cpu/resctrl/monitor.c                    |   27 +--
 arch/x86/kvm/svm.c                                       |   18 +-
 arch/x86/kvm/vmx/vmx.h                                   |    2 
 arch/x86/tools/chkobjdump.awk                            |    1 
 drivers/acpi/nfit/core.c                                 |    3 
 drivers/base/core.c                                      |    1 
 drivers/block/nbd.c                                      |   14 +
 drivers/gpu/drm/meson/meson_registers.h                  |    5 
 drivers/gpu/drm/meson/meson_viu.c                        |    7 
 drivers/i2c/i2c-dev.c                                    |    5 
 drivers/iio/adc/palmas_gpadc.c                           |    4 
 drivers/iio/adc/ti-ads7950.c                             |    1 
 drivers/iio/humidity/hdc100x.c                           |    6 
 drivers/iommu/intel-iommu.c                              |    7 
 drivers/net/dsa/lan9303-core.c                           |   34 ++--
 drivers/net/dsa/lantiq_gswip.c                           |   14 +
 drivers/net/dsa/microchip/ksz_common.h                   |    8 
 drivers/net/dsa/mt7530.c                                 |    1 
 drivers/net/dsa/sja1105/sja1105_main.c                   |    4 
 drivers/net/ethernet/intel/iavf/iavf_main.c              |   13 -
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c |   11 +
 drivers/net/ieee802154/mac802154_hwsim.c                 |    6 
 drivers/net/phy/micrel.c                                 |    2 
 drivers/net/ppp/ppp_generic.c                            |    2 
 drivers/nvdimm/namespace_devs.c                          |   17 +-
 drivers/pci/msi.c                                        |  125 +++++++++------
 drivers/platform/x86/pcengines-apuv2.c                   |    5 
 drivers/xen/events/events_base.c                         |   20 +-
 fs/ceph/caps.c                                           |   17 +-
 fs/ceph/mds_client.c                                     |   25 +--
 fs/ceph/snap.c                                           |   54 ++++--
 fs/ceph/super.h                                          |    2 
 include/asm-generic/vmlinux.lds.h                        |    1 
 include/linux/device.h                                   |    1 
 include/linux/inetdevice.h                               |    2 
 include/linux/irq.h                                      |    2 
 include/linux/msi.h                                      |    2 
 include/net/psample.h                                    |    2 
 kernel/irq/chip.c                                        |    5 
 kernel/irq/msi.c                                         |   13 -
 kernel/irq/timings.c                                     |    5 
 net/bridge/br_if.c                                       |    2 
 net/bridge/netfilter/nf_conntrack_bridge.c               |    6 
 net/core/link_watch.c                                    |    5 
 net/ieee802154/socket.c                                  |    7 
 net/ipv4/igmp.c                                          |   21 +-
 net/ipv4/tcp_bbr.c                                       |    2 
 net/sched/act_mirred.c                                   |    3 
 net/vmw_vsock/virtio_transport.c                         |    7 
 sound/soc/codecs/cs42l42.c                               |   39 +---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c             |    3 
 sound/soc/xilinx/xlnx_formatter_pcm.c                    |    4 
 57 files changed, 394 insertions(+), 225 deletions(-)

Aya Levin (1):
      net/mlx5: Fix return value from tracer initialization

Babu Moger (1):
      x86/resctrl: Fix default monitoring groups reporting

Ben Dai (1):
      genirq/timings: Prevent potential array overflow in __irq_timings_store()

Ben Hutchings (2):
      net: phy: micrel: Fix link detection on ksz87xx switch"
      net: dsa: microchip: Fix ksz_read64()

Bixuan Cui (1):
      genirq/msi: Ensure deactivation on teardown

Chris Lesiak (1):
      iio: humidity: hdc100x: Add margin to the conversion time

Christian Hewitt (1):
      drm/meson: fix colour distortion from HDR set during vendor u-boot

Colin Ian King (1):
      iio: adc: Fix incorrect exit of for-loop

DENG Qingfang (1):
      net: dsa: mt7530: add the missing RxUnicast MIB counter

Dan Williams (2):
      ACPI: NFIT: Fix support for virtual SPA ranges
      libnvdimm/region: Fix label activation vs errors

Dongliang Mu (2):
      ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
      ieee802154: hwsim: fix GPF in hwsim_new_edge_nl

Eric Dumazet (2):
      net: igmp: fix data-race in igmp_ifc_timer_expire()
      net: igmp: increase size of mr_ifc_count

Florian Eckert (1):
      platform/x86: pcengines-apuv2: revert wiring up simswitch GPIO as LED

Greg Kroah-Hartman (2):
      i2c: dev: zero out array used for i2c reads from userspace
      Linux 5.4.142

Hangbin Liu (1):
      net: sched: act_mirred: Reset ct info when mirror/redirect skb

Hans de Goede (1):
      platform/x86: pcengines-apuv2: Add missing terminating entries to gpio-lookup tables

Jeff Layton (3):
      ceph: add some lockdep assertions around snaprealm handling
      ceph: clean up locking annotation for ceph_get_snap_realm and __lookup_snap_realm
      ceph: take snap_empty_lock atomically with snaprealm refcount change

Longpeng(Mike) (1):
      vsock/virtio: avoid potential deadlock when vsock device remove

Luis Henriques (1):
      ceph: reduce contention in ceph_check_delayed_caps()

Maxim Levitsky (2):
      KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl (CVE-2021-3653)
      KVM: nSVM: always intercept VMLOAD/VMSAVE when nested (CVE-2021-3656)

Maximilian Heyne (1):
      xen/events: Fix race in set_evtchn_to_irq

Md Fahad Iqbal Polash (1):
      iavf: Set RSS LUT and key in reset handle path

Nathan Chancellor (1):
      vmlinux.lds.h: Handle clang's module.{c,d}tor sections

Neal Cardwell (1):
      tcp_bbr: fix u32 wrap bug in round logic if bbr_init() called after 2B packets

Pali Rohár (1):
      ppp: Fix generating ifname when empty IFLA_IFNAME is specified

Pu Lehui (1):
      powerpc/kprobes: Fix kprobe Oops happens in booke

Randy Dunlap (1):
      x86/tools: Fix objdump version check again

Richard Fitzgerald (5):
      ASoC: cs42l42: Correct definition of ADC Volume control
      ASoC: cs42l42: Don't allow SND_SOC_DAIFMT_LEFT_J
      ASoC: cs42l42: Fix inversion of ADC Notch Switch control
      ASoC: cs42l42: Remove duplicate control for WNF filter frequency
      ASoC: cs42l42: Fix LRCLK frame start edge

Roi Dayan (1):
      psample: Add a fwd declaration for skbuff

Saeed Mirzamohammadi (1):
      iommu/vt-d: Fix agaw for a supported 48 bit guest address width

Sean Christopherson (1):
      KVM: VMX: Use current VMCS to query WAITPKG support for MSR emulation

Takashi Iwai (2):
      ASoC: xilinx: Fix reference to PCM buffer address
      ASoC: intel: atom: Fix reference to PCM buffer address

Takeshi Misawa (1):
      net: Fix memory leak in ieee802154_raw_deliver

Thomas Gleixner (11):
      genirq: Provide IRQCHIP_AFFINITY_PRE_STARTUP
      x86/msi: Force affinity setup before startup
      x86/ioapic: Force affinity setup before startup
      PCI/MSI: Enable and mask MSI-X early
      PCI/MSI: Mask all unused MSI-X entries
      PCI/MSI: Enforce that MSI-X table entry is masked for update
      PCI/MSI: Enforce MSI[X] entry updates to be visible
      PCI/MSI: Do not set invalid bits in MSI mask
      PCI/MSI: Correct misleading comments
      PCI/MSI: Use msi_mask_irq() in pci_msi_shutdown()
      PCI/MSI: Protect msi_desc::masked for multi-MSI

Uwe Kleine-König (1):
      iio: adc: ti-ads7950: Ensure CS is deasserted after reading channels

Vladimir Oltean (3):
      net: dsa: lan9303: fix broken backpressure in .port_fdb_dump
      net: dsa: lantiq: fix broken backpressure in .port_fdb_dump
      net: dsa: sja1105: fix broken backpressure in .port_fdb_dump

Willy Tarreau (1):
      net: linkwatch: fix failure to restore device state across suspend/resume

Xie Yongji (1):
      nbd: Aovid double completion of a request

Yajun Deng (1):
      netfilter: nf_conntrack_bridge: Fix memory leak when error

Yang Yingliang (1):
      net: bridge: fix memleak in br_add_if()

