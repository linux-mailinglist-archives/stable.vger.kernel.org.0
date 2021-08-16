Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E219C3ED495
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbhHPNEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:04:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236352AbhHPNEM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:04:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE11C6328A;
        Mon, 16 Aug 2021 13:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119021;
        bh=+YI/CsJO+NzpBEjesm7lPy+vWkqSusWVDLejrpAoQNI=;
        h=From:To:Cc:Subject:Date:From;
        b=2aKkT6aucblulfw/RsZJ/dlY83F8kMroYYNTHNjyT9v08bEMcp1mhj0k8mcsCeHbZ
         7FX0PGPgPU/7evKKOZzp4WDcAfdl12xooSlhf280oySripO8kZVJwDc+mK9325tKkw
         YsJffZGf4fkxDZPbh7klmSyrgfphQQVq+nsC/cus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/62] 5.4.142-rc1 review
Date:   Mon, 16 Aug 2021 15:01:32 +0200
Message-Id: <20210816125428.198692661@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.142-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.142-rc1
X-KernelTest-Deadline: 2021-08-18T12:54+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.142 release.
There are 62 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 Aug 2021 12:54:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.142-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.142-rc1

Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
    iommu/vt-d: Fix agaw for a supported 48 bit guest address width

Nathan Chancellor <nathan@kernel.org>
    vmlinux.lds.h: Handle clang's module.{c,d}tor sections

Jeff Layton <jlayton@kernel.org>
    ceph: take snap_empty_lock atomically with snaprealm refcount change

Jeff Layton <jlayton@kernel.org>
    ceph: clean up locking annotation for ceph_get_snap_realm and __lookup_snap_realm

Jeff Layton <jlayton@kernel.org>
    ceph: add some lockdep assertions around snaprealm handling

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Use current VMCS to query WAITPKG support for MSR emulation

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Protect msi_desc::masked for multi-MSI

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Use msi_mask_irq() in pci_msi_shutdown()

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Correct misleading comments

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Do not set invalid bits in MSI mask

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Enforce MSI[X] entry updates to be visible

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Enforce that MSI-X table entry is masked for update

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Mask all unused MSI-X entries

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Enable and mask MSI-X early

Ben Dai <ben.dai@unisoc.com>
    genirq/timings: Prevent potential array overflow in __irq_timings_store()

Bixuan Cui <cuibixuan@huawei.com>
    genirq/msi: Ensure deactivation on teardown

Babu Moger <Babu.Moger@amd.com>
    x86/resctrl: Fix default monitoring groups reporting

Thomas Gleixner <tglx@linutronix.de>
    x86/ioapic: Force affinity setup before startup

Thomas Gleixner <tglx@linutronix.de>
    x86/msi: Force affinity setup before startup

Thomas Gleixner <tglx@linutronix.de>
    genirq: Provide IRQCHIP_AFFINITY_PRE_STARTUP

Randy Dunlap <rdunlap@infradead.org>
    x86/tools: Fix objdump version check again

Pu Lehui <pulehui@huawei.com>
    powerpc/kprobes: Fix kprobe Oops happens in booke

Xie Yongji <xieyongji@bytedance.com>
    nbd: Aovid double completion of a request

Longpeng(Mike) <longpeng2@huawei.com>
    vsock/virtio: avoid potential deadlock when vsock device remove

Maximilian Heyne <mheyne@amazon.de>
    xen/events: Fix race in set_evtchn_to_irq

Eric Dumazet <edumazet@google.com>
    net: igmp: increase size of mr_ifc_count

Neal Cardwell <ncardwell@google.com>
    tcp_bbr: fix u32 wrap bug in round logic if bbr_init() called after 2B packets

Willy Tarreau <w@1wt.eu>
    net: linkwatch: fix failure to restore device state across suspend/resume

Yang Yingliang <yangyingliang@huawei.com>
    net: bridge: fix memleak in br_add_if()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: fix broken backpressure in .port_fdb_dump

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: lantiq: fix broken backpressure in .port_fdb_dump

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: lan9303: fix broken backpressure in .port_fdb_dump

Eric Dumazet <edumazet@google.com>
    net: igmp: fix data-race in igmp_ifc_timer_expire()

Takeshi Misawa <jeliantsurux@gmail.com>
    net: Fix memory leak in ieee802154_raw_deliver

Ben Hutchings <ben.hutchings@mind.be>
    net: dsa: microchip: Fix ksz_read64()

Christian Hewitt <christianshewitt@gmail.com>
    drm/meson: fix colour distortion from HDR set during vendor u-boot

Aya Levin <ayal@nvidia.com>
    net/mlx5: Fix return value from tracer initialization

Roi Dayan <roid@nvidia.com>
    psample: Add a fwd declaration for skbuff

Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>
    iavf: Set RSS LUT and key in reset handle path

Hangbin Liu <liuhangbin@gmail.com>
    net: sched: act_mirred: Reset ct info when mirror/redirect skb

Pali Rohár <pali@kernel.org>
    ppp: Fix generating ifname when empty IFLA_IFNAME is specified

Ben Hutchings <ben.hutchings@mind.be>
    net: phy: micrel: Fix link detection on ksz87xx switch"

Hans de Goede <hdegoede@redhat.com>
    platform/x86: pcengines-apuv2: Add missing terminating entries to gpio-lookup tables

Florian Eckert <fe@dev.tdt.de>
    platform/x86: pcengines-apuv2: revert wiring up simswitch GPIO as LED

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: add the missing RxUnicast MIB counter

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Fix LRCLK frame start edge

Yajun Deng <yajun.deng@linux.dev>
    netfilter: nf_conntrack_bridge: Fix memory leak when error

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Remove duplicate control for WNF filter frequency

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Fix inversion of ADC Notch Switch control

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Don't allow SND_SOC_DAIFMT_LEFT_J

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Correct definition of ADC Volume control

Dongliang Mu <mudongliangabcd@gmail.com>
    ieee802154: hwsim: fix GPF in hwsim_new_edge_nl

Dongliang Mu <mudongliangabcd@gmail.com>
    ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/region: Fix label activation vs errors

Dan Williams <dan.j.williams@intel.com>
    ACPI: NFIT: Fix support for virtual SPA ranges

Luis Henriques <lhenriques@suse.de>
    ceph: reduce contention in ceph_check_delayed_caps()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    i2c: dev: zero out array used for i2c reads from userspace

Takashi Iwai <tiwai@suse.de>
    ASoC: intel: atom: Fix reference to PCM buffer address

Takashi Iwai <tiwai@suse.de>
    ASoC: xilinx: Fix reference to PCM buffer address

Colin Ian King <colin.king@canonical.com>
    iio: adc: Fix incorrect exit of for-loop

Chris Lesiak <chris.lesiak@licor.com>
    iio: humidity: hdc100x: Add margin to the conversion time

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    iio: adc: ti-ads7950: Ensure CS is deasserted after reading channels


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/powerpc/kernel/kprobes.c                      |   3 +-
 arch/x86/kernel/apic/io_apic.c                     |   6 +-
 arch/x86/kernel/apic/msi.c                         |  13 ++-
 arch/x86/kernel/cpu/resctrl/monitor.c              |  27 +++--
 arch/x86/kvm/vmx/vmx.h                             |   2 +-
 arch/x86/tools/chkobjdump.awk                      |   1 +
 drivers/acpi/nfit/core.c                           |   3 +
 drivers/base/core.c                                |   1 +
 drivers/block/nbd.c                                |  14 ++-
 drivers/gpu/drm/meson/meson_registers.h            |   5 +
 drivers/gpu/drm/meson/meson_viu.c                  |   7 +-
 drivers/i2c/i2c-dev.c                              |   5 +-
 drivers/iio/adc/palmas_gpadc.c                     |   4 +-
 drivers/iio/adc/ti-ads7950.c                       |   1 -
 drivers/iio/humidity/hdc100x.c                     |   6 +-
 drivers/iommu/intel-iommu.c                        |   7 +-
 drivers/net/dsa/lan9303-core.c                     |  34 +++---
 drivers/net/dsa/lantiq_gswip.c                     |  14 ++-
 drivers/net/dsa/microchip/ksz_common.h             |   8 +-
 drivers/net/dsa/mt7530.c                           |   1 +
 drivers/net/dsa/sja1105/sja1105_main.c             |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  13 ++-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  11 +-
 drivers/net/ieee802154/mac802154_hwsim.c           |   6 +-
 drivers/net/phy/micrel.c                           |   2 -
 drivers/net/ppp/ppp_generic.c                      |   2 +-
 drivers/nvdimm/namespace_devs.c                    |  17 ++-
 drivers/pci/msi.c                                  | 125 +++++++++++++--------
 drivers/platform/x86/pcengines-apuv2.c             |   5 +-
 drivers/xen/events/events_base.c                   |  20 +++-
 fs/ceph/caps.c                                     |  17 ++-
 fs/ceph/mds_client.c                               |  25 +++--
 fs/ceph/snap.c                                     |  54 +++++----
 fs/ceph/super.h                                    |   2 +-
 include/asm-generic/vmlinux.lds.h                  |   1 +
 include/linux/device.h                             |   1 +
 include/linux/inetdevice.h                         |   2 +-
 include/linux/irq.h                                |   2 +
 include/linux/msi.h                                |   2 +-
 include/net/psample.h                              |   2 +
 kernel/irq/chip.c                                  |   5 +-
 kernel/irq/msi.c                                   |  13 ++-
 kernel/irq/timings.c                               |   5 +
 net/bridge/br_if.c                                 |   2 +
 net/bridge/netfilter/nf_conntrack_bridge.c         |   6 +
 net/core/link_watch.c                              |   5 +-
 net/ieee802154/socket.c                            |   7 +-
 net/ipv4/igmp.c                                    |  21 ++--
 net/ipv4/tcp_bbr.c                                 |   2 +-
 net/sched/act_mirred.c                             |   3 +
 net/vmw_vsock/virtio_transport.c                   |   7 +-
 sound/soc/codecs/cs42l42.c                         |  39 +++----
 sound/soc/intel/atom/sst-mfld-platform-pcm.c       |   3 +-
 sound/soc/xilinx/xlnx_formatter_pcm.c              |   4 +-
 55 files changed, 382 insertions(+), 219 deletions(-)


