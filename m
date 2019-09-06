Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC87AB9A7
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 15:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfIFNrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 09:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbfIFNrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 09:47:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74547206B8;
        Fri,  6 Sep 2019 13:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567777673;
        bh=/mUzqHOsjKjC4QyYlgBGl1FkWk18r7P6pxnMfk/6Cqo=;
        h=Date:From:To:Cc:Subject:From;
        b=qgzfUeGi0ap6H0pQe6ZKPm/f4Mg6UImSj/YnOsZjN33oxxeQIWwla9CjnPVk2rOCb
         Sr5RkXD19goqjL7DiiSMl5s+sgpyrAErDPvK/w0R/HPeRioKKn3dnypjcBzz0n5gbB
         BAmFws90WjipAf7mPszmeBOsBLFh/fkn03flsorU=
Date:   Fri, 6 Sep 2019 15:47:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.2.12
Message-ID: <20190906134750.GA7349@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.2.12 kernel.

All users of the 5.2 kernel series must upgrade.

The updated 5.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                            |    2=20
 arch/arm64/kernel/cpufeature.c                      |   14 -
 arch/powerpc/kvm/book3s_64_vio.c                    |    6=20
 arch/powerpc/kvm/book3s_64_vio_hv.c                 |    6=20
 arch/riscv/include/asm/tlbflush.h                   |   11=20
 arch/x86/kernel/apic/apic.c                         |    4=20
 arch/x86/kernel/apic/bigsmp_32.c                    |   24 -
 arch/x86/kernel/ptrace.c                            |    3=20
 arch/x86/kernel/uprobes.c                           |   17 -
 arch/x86/kvm/hyperv.c                               |    5=20
 arch/x86/kvm/lapic.c                                |    5=20
 arch/x86/kvm/svm.c                                  |    8=20
 arch/x86/kvm/vmx/vmx.c                              |    1=20
 arch/x86/kvm/x86.c                                  |    9=20
 arch/x86/mm/pageattr.c                              |   26 +
 drivers/auxdisplay/panel.c                          |    2=20
 drivers/block/xen-blkback/xenbus.c                  |    6=20
 drivers/bus/hisi_lpc.c                              |   47 +++
 drivers/crypto/ccp/ccp-dev.c                        |    8=20
 drivers/dma/ste_dma40.c                             |    4=20
 drivers/dma/stm32-mdma.c                            |    2=20
 drivers/dma/ti/omap-dma.c                           |    4=20
 drivers/fsi/fsi-scom.c                              |    8=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c    |    1=20
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c               |   14 -
 drivers/gpu/drm/ast/ast_main.c                      |    5=20
 drivers/gpu/drm/ast/ast_mode.c                      |    2=20
 drivers/gpu/drm/ast/ast_post.c                      |    2=20
 drivers/gpu/drm/bridge/ti-tfp410.c                  |    7=20
 drivers/gpu/drm/i915/i915_drv.c                     |    6=20
 drivers/gpu/drm/i915/i915_vgpu.c                    |    3=20
 drivers/gpu/drm/i915/intel_dp_mst.c                 |   10=20
 drivers/gpu/drm/i915/intel_vdsc.c                   |    2=20
 drivers/gpu/drm/scheduler/sched_entity.c            |    4=20
 drivers/hid/hid-logitech-hidpp.c                    |    2=20
 drivers/hwtracing/intel_th/pci.c                    |   10=20
 drivers/hwtracing/stm/core.c                        |    1=20
 drivers/i2c/busses/i2c-emev2.c                      |   16 -
 drivers/i2c/busses/i2c-piix4.c                      |   12=20
 drivers/i2c/busses/i2c-rcar.c                       |   11=20
 drivers/infiniband/core/umem_odp.c                  |    4=20
 drivers/infiniband/hw/mlx5/odp.c                    |   24 -
 drivers/iommu/dma-iommu.c                           |    2=20
 drivers/media/platform/omap/omap_vout_vrfb.c        |    3=20
 drivers/misc/habanalabs/goya/goya.c                 |   72 +++--
 drivers/misc/habanalabs/goya/goyaP.h                |    2=20
 drivers/misc/habanalabs/habanalabs.h                |    9=20
 drivers/misc/habanalabs/hw_queue.c                  |   14 -
 drivers/misc/habanalabs/include/goya/goya_packets.h |   13=20
 drivers/misc/habanalabs/irq.c                       |   27 --
 drivers/misc/habanalabs/memory.c                    |    2=20
 drivers/misc/lkdtm/bugs.c                           |    4=20
 drivers/misc/mei/hw-me-regs.h                       |    2=20
 drivers/misc/mei/pci-me.c                           |    2=20
 drivers/misc/vmw_vmci/vmci_doorbell.c               |    6=20
 drivers/mmc/core/sd.c                               |    6=20
 drivers/mmc/host/sdhci-cadence.c                    |    1=20
 drivers/mmc/host/sdhci-of-at91.c                    |    3=20
 drivers/mmc/host/sdhci-sprd.c                       |   37 ++
 drivers/mmc/host/sdhci-tegra.c                      |   14 +
 drivers/net/ethernet/ti/cpsw.c                      |    2=20
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c      |  221 ++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h     |   23 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h        |    2=20
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c       |  268 +++++++++++----=
-----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c     |    9=20
 drivers/net/wireless/mediatek/mt76/mt76.h           |    1=20
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c     |    8=20
 drivers/net/wireless/mediatek/mt76/usb.c            |   46 ++-
 drivers/nvme/host/core.c                            |   15 +
 drivers/nvme/host/multipath.c                       |   76 +++++
 drivers/nvme/host/nvme.h                            |   21 +
 drivers/nvme/host/pci.c                             |    3=20
 drivers/nvme/host/rdma.c                            |   16 -
 drivers/nvme/target/configfs.c                      |    1=20
 drivers/nvme/target/core.c                          |   15 +
 drivers/nvme/target/loop.c                          |    8=20
 drivers/nvme/target/nvmet.h                         |    3=20
 drivers/soundwire/cadence_master.c                  |    8=20
 drivers/usb/chipidea/udc.c                          |   32 +-
 drivers/usb/class/cdc-wdm.c                         |   16 -
 drivers/usb/class/usbtmc.c                          |    3=20
 drivers/usb/core/hcd-pci.c                          |   30 --
 drivers/usb/gadget/composite.c                      |    1=20
 drivers/usb/gadget/function/f_mass_storage.c        |   28 +-
 drivers/usb/host/fotg210-hcd.c                      |    4=20
 drivers/usb/host/ohci-hcd.c                         |   15 -
 drivers/usb/host/xhci-rcar.c                        |    2=20
 drivers/usb/storage/realtek_cr.c                    |   15 -
 drivers/usb/storage/unusual_devs.h                  |    2=20
 drivers/usb/typec/tcpm/tcpm.c                       |    2=20
 drivers/watchdog/bcm2835_wdt.c                      |    1=20
 fs/afs/cmservice.c                                  |   10=20
 fs/afs/dir.c                                        |   89 +++++-
 fs/afs/file.c                                       |   12=20
 fs/afs/vlclient.c                                   |   11=20
 fs/btrfs/extent-tree.c                              |   14 -
 fs/nfs/direct.c                                     |   27 +-
 fs/nfs/flexfilelayout/flexfilelayout.c              |   17 -
 fs/nfs/pagelist.c                                   |   17 -
 include/linux/logic_pio.h                           |    1=20
 include/linux/sunrpc/sched.h                        |    1=20
 include/net/addrconf.h                              |    2=20
 kernel/bpf/syscall.c                                |   30 +-
 kernel/dma/direct.c                                 |    3=20
 kernel/locking/rwsem-xadd.c                         |    6=20
 kernel/trace/ftrace.c                               |   17 +
 lib/logic_pio.c                                     |   73 ++++-
 mm/memcontrol.c                                     |   18 -
 mm/zsmalloc.c                                       |    2=20
 net/core/stream.c                                   |   16 -
 net/hsr/hsr_device.c                                |   15 -
 net/hsr/hsr_framereg.c                              |   11=20
 net/hsr/hsr_framereg.h                              |    3=20
 net/ipv4/icmp.c                                     |    8=20
 net/ipv4/igmp.c                                     |    4=20
 net/ipv6/addrconf.c                                 |    3=20
 net/mac80211/cfg.c                                  |    9=20
 net/mac80211/rx.c                                   |    6=20
 net/mpls/mpls_iptunnel.c                            |    8=20
 net/openvswitch/conntrack.c                         |   13=20
 net/smc/smc_tx.c                                    |    6=20
 net/sunrpc/clnt.c                                   |   35 +-
 net/sunrpc/xprt.c                                   |    7=20
 net/wireless/reg.c                                  |    2=20
 net/wireless/util.c                                 |   23 +
 net/xfrm/xfrm_policy.c                              |    4=20
 sound/core/seq/seq_clientmgr.c                      |    3=20
 sound/core/seq/seq_fifo.c                           |   17 +
 sound/core/seq/seq_fifo.h                           |    2=20
 sound/pci/hda/patch_ca0132.c                        |    1=20
 sound/pci/hda/patch_conexant.c                      |   17 -
 sound/soc/soc-core.c                                |    7=20
 sound/usb/line6/pcm.c                               |   18 -
 sound/usb/mixer.c                                   |   36 ++
 sound/usb/mixer_quirks.c                            |    8=20
 sound/usb/pcm.c                                     |    1=20
 tools/hv/hv_kvp_daemon.c                            |    2=20
 tools/hv/hv_vss_daemon.c                            |    2=20
 tools/hv/lsvmbus                                    |   75 +++--
 tools/power/x86/turbostat/turbostat.c               |    2=20
 tools/testing/selftests/bpf/Makefile                |    3=20
 virt/kvm/arm/vgic/vgic-mmio.c                       |   18 +
 virt/kvm/arm/vgic/vgic-v2.c                         |    5=20
 virt/kvm/arm/vgic/vgic-v3.c                         |    5=20
 virt/kvm/arm/vgic/vgic.c                            |    7=20
 146 files changed, 1557 insertions(+), 669 deletions(-)

Aaron Liu (1):
      drm/amdgpu: fix GFXOFF on Picasso and Raven2

Adrian Vladu (2):
      tools: hv: fixed Python pep8/flake8 warnings for lsvmbus
      tools: hv: fix KVP and VSS daemons exit code

Alexander Shishkin (2):
      intel_th: pci: Add support for another Lewisburg PCH
      intel_th: pci: Add Tiger Lake support

Alexander Wetzel (1):
      cfg80211: Fix Extended Key ID key install checks

Alexey Kardashevskiy (1):
      KVM: PPC: Book3S: Fix incorrect guest-to-user-translation error handl=
ing

Alexey Kodanev (1):
      ipv4: mpls: fix mpls_xmit for iptunnel

Anders Roxell (1):
      selftests/bpf: install files test_xdp_vlan.sh

Andrew Cooks (1):
      i2c: piix4: Fix port selection for AMD Family 16h Model 30h

Andrew Morton (1):
      mm/zsmalloc.c: fix build when CONFIG_COMPACTION=3Dn

Anthony Iliopoulos (1):
      nvme-multipath: revalidate nvme_ns_head gendisk in nvme_validate_ns

Antoine Tenart (1):
      net: cpsw: fix NULL pointer exception in the probe error path

Arnd Bergmann (1):
      dmaengine: ste_dma40: fix unneeded variable warning

Bandan Das (2):
      x86/apic: Do not initialize LDR and DFR for bigsmp
      x86/apic: Include the LDR when clearing out APIC registers

Baolin Wang (1):
      mmc: sdhci-sprd: Implement the get_max_timeout_count() interface

Ben Segal (3):
      habanalabs: fix endianness handling for packets from user
      habanalabs: fix completion queue handling when host is BE
      habanalabs: fix device IRQ unmasking for BE host

Benjamin Herrenschmidt (2):
      usb: gadget: composite: Clear "suspended" on reset/disconnect
      usb: gadget: mass_storage: Fix races between fsg_disable and fsg_set_=
alt

Benjamin Tissoires (1):
      HID: logitech-hidpp: remove support for the G700 over USB

Christian K=C3=B6nig (1):
      drm/scheduler: use job count instead of peek

Chunyan Zhang (5):
      mmc: sdhci-sprd: fixed incorrect clock divider
      mmc: sdhci-sprd: add SDHCI_QUIRK2_PRESET_VALUE_BROKEN
      mms: sdhci-sprd: add SDHCI_QUIRK_BROKEN_CARD_DETECTION
      mmc: sdhci-sprd: clear the UHS-I modes read from registers
      mmc: sdhci-sprd: add get_ro hook function

Colin Ian King (1):
      typec: tcpm: fix a typo in the comparison of pdo_max_voltage

Cong Wang (3):
      hsr: implement dellink to clean up resources
      hsr: fix a NULL pointer deref in hsr_dev_xmit()
      hsr: switch ->dellink() to ->ndo_uninit()

Daniel Borkmann (1):
      bpf: fix use after free in prog symbol exposure

David Howells (4):
      afs: Fix the CB.ProbeUuid service handler to reply correctly
      afs: Fix off-by-one in afs_rename() expected data version calculation
      afs: Only update d_fsdata if different in afs_d_revalidate()
      afs: Fix missing dentry data version updating

Denis Kenzior (2):
      mac80211: Don't memset RXCB prior to PAE intercept
      mac80211: Correctly set noencrypt for PAE frames

Ding Xiang (1):
      stm class: Fix a double free of stm_source_device

Dmitry Osipenko (1):
      Revert "mmc: sdhci-tegra: drop ->get_ro() implementation"

Eddie James (1):
      fsi: scom: Don't abort operations for minor errors

Eric Dumazet (1):
      tcp: make sure EPOLLOUT wont be missed

Eugen Hristev (1):
      mmc: sdhci-of-at91: add quirk for broken HS200

Gary R Hook (1):
      crypto: ccp - Ignore unconfigured CCP device on suspend/resume

Geert Uytterhoeven (1):
      usb: host: xhci: rcar: Fix typo in compatible string matching

Greg Kroah-Hartman (3):
      x86/ptrace: fix up botched merge of spectrev1 fix
      Revert "ASoC: Fail card instantiation if DAI format setup fails"
      Linux 5.2.12

Hangbin Liu (3):
      ipv6/addrconf: allow adding multicast addr if IFA_F_MCAUTOJOIN is set
      ipv4/icmp: fix rt dst dev null pointer dereference
      xfrm/xfrm_policy: fix dst dev null pointer dereference in collect_md =
mode

Hans Ulli Kroll (1):
      usb: host: fotg2: restart hcd after port reset

Hans Verkuil (1):
      omap-dma/omap_vout_vrfb: fix off-by-one fi value

Henk van der Laan (1):
      usb-storage: Add new JMS567 revision to unusual_devs

Heyi Guo (1):
      KVM: arm/arm64: vgic: Fix potential deadlock when ap_list is long

Hodaszi, Robert (1):
      Revert "cfg80211: fix processing world regdomain when non modular"

Ihab Zhaika (4):
      iwlwifi: add new cards for 22000 and fix struct name
      iwlwifi: add new cards for 22000 and change wrong structs
      iwlwifi: add new cards for 9000 and 20000 series
      iwlwifi: change 0x02F0 fw from qu to quz

Jan Stancek (1):
      locking/rwsem: Add missing ACQUIRE to read_slowpath exit when queue i=
s empty

Jason Baron (1):
      net/smc: make sure EPOLLOUT is raised

Jeronimo Borque (1):
      ALSA: hda - Fixes inverted Conexant GPIO mic mute led

Jia-Ju Bai (2):
      fs: afs: Fix a possible null-pointer dereference in afs_put_read()
      dmaengine: stm32-mdma: Fix a possible null-pointer dereference in stm=
32_mdma_irq_handler()

Johannes Berg (1):
      mac80211: fix possible sta leak

John Garry (5):
      lib: logic_pio: Fix RCU usage
      lib: logic_pio: Avoid possible overlap for unregistering regions
      lib: logic_pio: Add logic_pio_unregister_range()
      bus: hisi_lpc: Unregister logical PIO range to avoid potential use-af=
ter-free
      bus: hisi_lpc: Add .remove method to avoid driver unbind crash

Kai-Heng Feng (3):
      USB: storage: ums-realtek: Update module parameter description for au=
to_delink_en
      USB: storage: ums-realtek: Whitelist auto-delink support
      drm/amdgpu: Add APTX quirk for Dell Latitude 5495

Keith Busch (1):
      nvme-pci: Fix async probe remove race

Li RongQing (1):
      net: fix __ip_mc_inc_group usage

Logan Gunthorpe (4):
      nvmet: Fix use-after-free bug when a port is removed
      nvmet-loop: Flush nvme_delete_wq when removing the port
      nvmet-file: fix nvmet_file_flush() always returning an error
      nvme-core: Fix extra device_put() call on error path

Lorenzo Bianconi (1):
      mt76: usb: fix rx A-MSDU support

Luca Coelho (3):
      iwlwifi: pcie: add support for qu c-step devices
      iwlwifi: pcie: don't switch FW to qnj when ax201 is detected
      iwlwifi: pcie: handle switching killer Qu B0 NICs to C0

Lucas Stach (1):
      dma-direct: don't truncate dma_required_mask to bus addressing capabi=
lities

Lyude Paul (1):
      drm/i915: Call dma_set_max_seg_size() in i915_driver_hw_probe()

Manasi Navare (1):
      drm/i915/dp: Fix DSC enable code to use cpu_transcoder instead of enc=
oder->type

Marc Dionne (1):
      afs: Fix loop index mixup in afs_deliver_vl_get_entry_by_name_u()

Marc Zyngier (1):
      KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0 as WI

Masahiro Yamada (1):
      mmc: sdhci-cadence: enable v4_mode to fix ADMA 64-bit addressing

Nadav Amit (1):
      VMCI: Release resource if the work is already queued

Naveen N. Rao (2):
      ftrace: Fix NULL pointer dereference in t_probe_next()
      ftrace: Check for successful allocation of hash

Oded Gabbay (1):
      habanalabs: fix endianness handling for internal QMAN submission

Oliver Neukum (2):
      usbtmc: more sanity checking for packet size
      USB: cdc-wdm: fix race between write and disconnect due to flag abuse

Paul Walmsley (1):
      riscv: fix flush_tlb_range() end address for flush_tlb_page()

Pawe=C5=82 Rekowski (1):
      ALSA: hda/ca0132 - Add new SBZ quirk

Peter Chen (1):
      usb: chipidea: udc: don't do hardware access if gadget has stopped

Peter Zijlstra (1):
      lcoking/rwsem: Add missing ACQUIRE to read_slowpath sleep loop

Pierre-Louis Bossart (2):
      soundwire: cadence_master: fix register definition for SLAVE_STATE
      soundwire: cadence_master: fix definitions for INTSTAT0/1

Pu Wen (1):
      tools/power turbostat: Fix caller parameter of get_tdp_amd()

Qu Wenruo (1):
      btrfs: trim: Check the range passed into to prevent overflow

Radim Krcmar (1):
      kvm: x86: skip populating logical dest map if apic is not sw enabled

Raul E Rangel (1):
      lkdtm/bugs: fix build error in lkdtm_EXHAUST_STACK

Robin Murphy (1):
      iommu/dma: Handle SG length overflow better

Roman Gushchin (1):
      mm, memcg: partially revert "mm/memcontrol.c: keep local VM counters =
in sync with the hierarchical ones"

Sagi Grimberg (3):
      nvme: fix a possible deadlock when passthru commands sent to a multip=
ath device
      nvme-rdma: fix possible use-after-free in connect error flow
      nvme: fix controller removal race with scan work

Schmid, Carsten (1):
      usb: hcd: use managed device resources

Sean Christopherson (1):
      KVM: x86: Don't update RIP or do single-step on faulting emulation

Sebastian Mayr (1):
      uprobes/x86: Fix detection of 32-bit user mode

Shakeel Butt (1):
      mm: memcontrol: fix percpu vmstats and vmevents flush

Stanislaw Gruszka (1):
      mt76: mt76x0u: do not reset radio on resume

Stefan Wahren (1):
      watchdog: bcm2835_wdt: Fix module autoload

Stefano Brivio (1):
      ipv6: Fix return value of ipv6_mc_may_pull() for malformed packets

Steven Rostedt (VMware) (1):
      ftrace: Check for empty hash and comment the race with registering pr=
obes

Takashi Iwai (5):
      ALSA: usb-audio: Check mixer unit bitmap yet more strictly
      ALSA: line6: Fix memory leak at line6_init_pcm() error path
      ALSA: seq: Fix potential concurrent access to the deleted pool
      ALSA: usb-audio: Fix invalid NULL check in snd_emuusb_set_samplerate()
      ALSA: usb-audio: Add implicit fb quirk for Behringer UFX1604

Thomas Gleixner (1):
      x86/mm/cpa: Prevent large page split when ftrace flips RW on kernel t=
ext

Tomas Winkler (1):
      mei: me: add Tiger Lake point LP device ID

Tomer Tayar (1):
      habanalabs: fix DRAM usage accounting on context tear down

Tomi Valkeinen (1):
      drm/bridge: tfp410: fix memleak in get_modes()

Trond Myklebust (4):
      NFSv4/pnfs: Fix a page lock leak in nfs_pageio_resend()
      NFS: Ensure O_DIRECT reports an error if the bytes read/written is 0
      Revert "NFSv4/flexfiles: Abort I/O early if the layout segment was in=
validated"
      SUNRPC: Don't handle errors if the bind/connect succeeded

Ulf Hansson (1):
      mmc: core: Fix init of SD cards reporting an invalid VDD range

Ville Syrj=C3=A4l=C3=A4 (1):
      drm/i915: Do not create a new max_bpc prop for MST connectors

Vitaly Kuznetsov (1):
      KVM: x86: hyper-v: don't crash on KVM_GET_SUPPORTED_HV_CPUID when kvm=
_intel.nested is disabled

Wenwen Wang (1):
      xen/blkback: fix memory leaks

Will Deacon (1):
      arm64: cpufeature: Don't treat granule sizes as strict

Wolfram Sang (2):
      i2c: rcar: avoid race when unregistering slave client
      i2c: emev2: avoid race when unregistering slave client

Xiong Zhang (1):
      drm/i915: Don't deballoon unused ggtt drm_mm_node in linux guest

Y.C. Chen (1):
      drm/ast: Fixed reboot test may cause system hanged

Yi-Hung Wei (1):
      openvswitch: Fix conntrack cache with timeout

Yishai Hadas (1):
      IB/mlx5: Fix implicit MR release flow

Yoshihiro Shimoda (1):
      usb: host: ohci: fix a race condition between shutdown and irq

zhengbin (1):
      auxdisplay: panel: need to delete scan_timer when misc_register fails=
 in panel_attach


--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1yY4YACgkQONu9yGCS
aT4gZRAAqLUP3Qswt+hCQYuu59/4MorgBrZqGSlZaih44TL1CNW1efgZucZug6Gb
u/ByHZBEUpi0ICxkMaPH4OXOm2ZcUq86262c6G/Z8M+2HR8TcBqeyMKi03ybdwXH
Uc5Xm4y2ALvWssdCicXHgZel13aunVlnsIlL3AZOZ1ci9bZ1uP8aMSpBkCRseh54
f6Hz/WDTyu6wsTNRY4AW6nOK2ruff0/TocMiVotAAeZtA5zLqSUb+dI6VxL2cG30
kZvvGDaVTHQJfB6+Y+HDjf64nJUFedlNu5+xZSI+lU1c4SpIdAaRfYn9EQmAfdeU
+TfwZVwBIWNY+8gUA+LfL3eN6bzrxP6NJ8gZOC4jheH0GxCmoy65WBGcpE1EavdD
yP06m/NEzgEQr4GX/j7eCPIEvjwkb92BJu0dF0zhroeFclNA/ZVKjEvJ2pS8nVY9
/JfpNcdxu4k0niZF95SEWhxh8XN6dxI2gDUTL7BbKBRgk2HIO6X/VwMceuDCO5me
YOCnO/81hCu86Ji8bW84Rsa5zGnUpcA+ZniXOLgG2fVmIkYTM3kq7mFSW405q+Gq
aqXTp+1u7umtcz1gp0fXhZMIdpQmFkS8xK5O8jJPnZ5ZCcwbaKdRVvi8Gq9tl0N4
tPn4v5qYgsMhPDB1DJdAAcAUYW5YGJGNkA9xFuB0IPQgSqDvQyc=
=fien
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
