Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887E0A8FF5
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388911AbfIDSGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388774AbfIDSGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:06:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EEE3208E4;
        Wed,  4 Sep 2019 18:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620411;
        bh=v5fh3tUyDKGFxttnKG4vpt9jHAD57QDbCUAtrZi5RCA=;
        h=From:To:Cc:Subject:Date:From;
        b=RYr97OfBWChmzC6C7SDPi0oaqMuMleA+ZYClb7sQRzRSM/ohjJnmceLDQQTP21V+0
         UQR3d+jUzo+VGG6/NT7WQOps9NxCaF5WMhW69F/PUqR7mRw9cTlmfHRPMl/QvJJDZb
         H29Yeq1m0gv9Anx6nUCNyO3g4d4jDKYGr7xYktxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/93] 4.19.70-stable review
Date:   Wed,  4 Sep 2019 19:53:02 +0200
Message-Id: <20190904175302.845828956@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.70-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.70-rc1
X-KernelTest-Deadline: 2019-09-06T17:53+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.70 release.
There are 93 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.70-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.70-rc1

Stanislaw Gruszka <sgruszka@redhat.com>
    mt76: mt76x0u: do not reset radio on resume

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    x86/ptrace: fix up botched merge of spectrev1 fix

Andrew Cooks <andrew.cooks@opengear.com>
    i2c: piix4: Fix port selection for AMD Family 16h Model 30h

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Ensure O_DIRECT reports an error if the bytes read/written is 0

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Pass error information to the pgio error cleanup routine

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pnfs: Fix a page lock leak in nfs_pageio_resend()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Clean up list moves of struct nfs_page

Marc Zyngier <maz@kernel.org>
    KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0 as WI

Heyi Guo <guoheyi@huawei.com>
    KVM: arm/arm64: vgic: Fix potential deadlock when ap_list is long

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Book3S: Fix incorrect guest-to-user-translation error handling

Denis Kenzior <denkenz@gmail.com>
    mac80211: Correctly set noencrypt for PAE frames

Denis Kenzior <denkenz@gmail.com>
    mac80211: Don't memset RXCB prior to PAE intercept

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix possible sta leak

Hodaszi, Robert <Robert.Hodaszi@digi.com>
    Revert "cfg80211: fix processing world regdomain when non modular"

Gary R Hook <gary.hook@amd.com>
    crypto: ccp - Ignore unconfigured CCP device on suspend/resume

Nadav Amit <namit@vmware.com>
    VMCI: Release resource if the work is already queued

John Garry <john.garry@huawei.com>
    bus: hisi_lpc: Add .remove method to avoid driver unbind crash

John Garry <john.garry@huawei.com>
    bus: hisi_lpc: Unregister logical PIO range to avoid potential use-after-free

Lyude Paul <lyude@redhat.com>
    drm/i915: Call dma_set_max_seg_size() in i915_driver_hw_probe()

Xiong Zhang <xiong.y.zhang@intel.com>
    drm/i915: Don't deballoon unused ggtt drm_mm_node in linux guest

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/amdgpu: Add APTX quirk for Dell Latitude 5495

John Garry <john.garry@huawei.com>
    lib: logic_pio: Add logic_pio_unregister_range()

John Garry <john.garry@huawei.com>
    lib: logic_pio: Avoid possible overlap for unregistering regions

John Garry <john.garry@huawei.com>
    lib: logic_pio: Fix RCU usage

Eddie James <eajames@linux.ibm.com>
    fsi: scom: Don't abort operations for minor errors

Colin Ian King <colin.king@canonical.com>
    typec: tcpm: fix a typo in the comparison of pdo_max_voltage

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Tiger Lake support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add support for another Lewisburg PCH

Ding Xiang <dingxiang@cmss.chinamobile.com>
    stm class: Fix a double free of stm_source_device

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Fix init of SD cards reporting an invalid VDD range

Eugen Hristev <eugen.hristev@microchip.com>
    mmc: sdhci-of-at91: add quirk for broken HS200

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: add Tiger Lake point LP device ID

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: storage: ums-realtek: Whitelist auto-delink support

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: storage: ums-realtek: Update module parameter description for auto_delink_en

Geert Uytterhoeven <geert+renesas@glider.be>
    usb: host: xhci: rcar: Fix typo in compatible string matching

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: host: ohci: fix a race condition between shutdown and irq

Peter Chen <peter.chen@nxp.com>
    usb: chipidea: udc: don't do hardware access if gadget has stopped

Schmid, Carsten <Carsten_Schmid@mentor.com>
    usb: hcd: use managed device resources

Oliver Neukum <oneukum@suse.com>
    USB: cdc-wdm: fix race between write and disconnect due to flag abuse

Henk van der Laan <opensource@henkvdlaan.com>
    usb-storage: Add new JMS567 revision to unusual_devs

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Check for empty hash and comment the race with registering probes

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    ftrace: Check for successful allocation of hash

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    ftrace: Fix NULL pointer dereference in t_probe_next()

Bandan Das <bsd@redhat.com>
    x86/apic: Include the LDR when clearing out APIC registers

Bandan Das <bsd@redhat.com>
    x86/apic: Do not initialize LDR and DFR for bigsmp

Sebastian Mayr <me@sam.st>
    uprobes/x86: Fix detection of 32-bit user mode

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Don't update RIP or do single-step on faulting emulation

Radim Krcmar <rkrcmar@redhat.com>
    kvm: x86: skip populating logical dest map if apic is not sw enabled

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add implicit fb quirk for Behringer UFX1604

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix invalid NULL check in snd_emuusb_set_samplerate()

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix potential concurrent access to the deleted pool

Jeronimo Borque <jeronimo@borque.com.ar>
    ALSA: hda - Fixes inverted Conexant GPIO mic mute led

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix memory leak at line6_init_pcm() error path

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Check mixer unit bitmap yet more strictly

Andrew Morton <akpm@linux-foundation.org>
    mm/zsmalloc.c: fix build when CONFIG_COMPACTION=n

Hangbin Liu <liuhangbin@gmail.com>
    ipv4/icmp: fix rt dst dev null pointer dereference

Eric Dumazet <edumazet@google.com>
    tcp: make sure EPOLLOUT wont be missed

Jason Baron <jbaron@akamai.com>
    net/smc: make sure EPOLLOUT is raised

David Ahern <dsahern@gmail.com>
    ipv6: Default fib6_type to RTN_UNICAST when not set

Hangbin Liu <liuhangbin@gmail.com>
    ipv6/addrconf: allow adding multicast addr if IFA_F_MCAUTOJOIN is set

John Fastabend <john.fastabend@gmail.com>
    net: tls, fix sk_write_space NULL write when tx disabled

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: swap sk_write_space on close

Vakul Garg <vakul.garg@nxp.com>
    net/tls: Fixed return value when tls_complete_pending_work() fails

Jyri Sarha <jsarha@ti.com>
    drm/tilcdc: Register cpufreq notifier after we have initialized crtc

Pedro Sousa <sousa@synopsys.com>
    scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE define value

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/bridge: tfp410: fix memleak in get_modes()

Stefan Wahren <wahrenst@gmx.net>
    watchdog: bcm2835_wdt: Fix module autoload

Lionel Landwerlin <lionel.g.landwerlin@intel.com>
    drm/i915: fix broadwell EU computation

Adrian Vladu <avladu@cloudbasesolutions.com>
    tools: hv: fix KVP and VSS daemons exit code

Adrian Vladu <avladu@cloudbasesolutions.com>
    tools: hv: fixed Python pep8/flake8 warnings for lsvmbus

Hans Ulli Kroll <ulli.kroll@googlemail.com>
    usb: host: fotg2: restart hcd after port reset

Y.C. Chen <yc_chen@aspeedtech.com>
    drm/ast: Fixed reboot test may cause system hanged

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: emev2: avoid race when unregistering slave client

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: avoid race when unregistering slave client

Will Deacon <will@kernel.org>
    arm64: cpufeature: Don't treat granule sizes as strict

Wenwen Wang <wenwen@cs.uga.edu>
    xen/blkback: fix memory leaks

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    usb: gadget: mass_storage: Fix races between fsg_disable and fsg_set_alt

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    usb: gadget: composite: Clear "suspended" on reset/disconnect

Robin Murphy <robin.murphy@arm.com>
    iommu/dma: Handle SG length overflow better

Hans Verkuil <hverkuil@xs4all.nl>
    omap-dma/omap_vout_vrfb: fix off-by-one fi value

Jia-Ju Bai <baijiaju1990@gmail.com>
    dmaengine: stm32-mdma: Fix a possible null-pointer dereference in stm32_mdma_irq_handler()

zhengbin <zhengbin13@huawei.com>
    auxdisplay: panel: need to delete scan_timer when misc_register fails in panel_attach

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: cadence_master: fix definitions for INTSTAT0/1

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: cadence_master: fix register definition for SLAVE_STATE

Keith Busch <kbusch@kernel.org>
    nvme-pci: Fix async probe remove race

Sagi Grimberg <sagi@grimberg.me>
    nvme: fix a possible deadlock when passthru commands sent to a multipath device

Logan Gunthorpe <logang@deltatee.com>
    nvmet-loop: Flush nvme_delete_wq when removing the port

David Howells <dhowells@redhat.com>
    afs: Only update d_fsdata if different in afs_d_revalidate()

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: afs: Fix a possible null-pointer dereference in afs_put_read()

Marc Dionne <marc.dionne@auristor.com>
    afs: Fix loop index mixup in afs_deliver_vl_get_entry_by_name_u()

David Howells <dhowells@redhat.com>
    afs: Fix the CB.ProbeUuid service handler to reply correctly

Anthony Iliopoulos <ailiopoulos@suse.com>
    nvme-multipath: revalidate nvme_ns_head gendisk in nvme_validate_ns

Arnd Bergmann <arnd@arndb.de>
    dmaengine: ste_dma40: fix unneeded variable warning


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/kernel/cpufeature.c                     | 14 +++-
 arch/powerpc/kvm/book3s_64_vio.c                   |  6 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c                |  6 +-
 arch/x86/kernel/apic/apic.c                        |  4 ++
 arch/x86/kernel/apic/bigsmp_32.c                   | 24 +------
 arch/x86/kernel/ptrace.c                           |  3 +-
 arch/x86/kernel/uprobes.c                          | 17 +++--
 arch/x86/kvm/lapic.c                               |  5 ++
 arch/x86/kvm/x86.c                                 |  9 +--
 drivers/auxdisplay/panel.c                         |  2 +
 drivers/block/xen-blkback/xenbus.c                 |  6 +-
 drivers/bus/hisi_lpc.c                             | 47 ++++++++++++--
 drivers/crypto/ccp/ccp-dev.c                       |  8 +++
 drivers/dma/ste_dma40.c                            |  4 +-
 drivers/dma/stm32-mdma.c                           |  2 +-
 drivers/dma/ti/omap-dma.c                          |  4 +-
 drivers/fsi/fsi-scom.c                             |  8 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c   |  1 +
 drivers/gpu/drm/ast/ast_main.c                     |  5 +-
 drivers/gpu/drm/ast/ast_mode.c                     |  2 +-
 drivers/gpu/drm/ast/ast_post.c                     |  2 +-
 drivers/gpu/drm/bridge/ti-tfp410.c                 |  7 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  6 ++
 drivers/gpu/drm/i915/i915_vgpu.c                   |  3 +
 drivers/gpu/drm/i915/intel_device_info.c           |  2 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                | 34 +++++-----
 drivers/hwtracing/intel_th/pci.c                   | 10 +++
 drivers/hwtracing/stm/core.c                       |  1 -
 drivers/i2c/busses/i2c-emev2.c                     | 16 +++--
 drivers/i2c/busses/i2c-piix4.c                     | 12 ++--
 drivers/i2c/busses/i2c-rcar.c                      | 11 ++--
 drivers/iommu/dma-iommu.c                          |  2 +-
 drivers/media/platform/omap/omap_vout_vrfb.c       |  3 +-
 drivers/misc/mei/hw-me-regs.h                      |  2 +
 drivers/misc/mei/pci-me.c                          |  2 +
 drivers/misc/vmw_vmci/vmci_doorbell.c              |  6 +-
 drivers/mmc/core/sd.c                              |  6 ++
 drivers/mmc/host/sdhci-of-at91.c                   |  3 +
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  4 +-
 drivers/nvme/host/core.c                           |  6 ++
 drivers/nvme/host/multipath.c                      | 30 +++++++++
 drivers/nvme/host/nvme.h                           | 12 ++++
 drivers/nvme/host/pci.c                            |  3 +-
 drivers/nvme/target/loop.c                         |  8 +++
 drivers/scsi/ufs/unipro.h                          |  2 +-
 drivers/soundwire/cadence_master.c                 |  8 +--
 drivers/usb/chipidea/udc.c                         | 32 ++++++---
 drivers/usb/class/cdc-wdm.c                        | 16 +++--
 drivers/usb/core/hcd-pci.c                         | 30 +++------
 drivers/usb/gadget/composite.c                     |  1 +
 drivers/usb/gadget/function/f_mass_storage.c       | 28 +++++---
 drivers/usb/host/fotg210-hcd.c                     |  4 ++
 drivers/usb/host/ohci-hcd.c                        | 15 ++++-
 drivers/usb/host/xhci-rcar.c                       |  2 +-
 drivers/usb/storage/realtek_cr.c                   | 15 +++--
 drivers/usb/storage/unusual_devs.h                 |  2 +-
 drivers/usb/typec/tcpm.c                           |  2 +-
 drivers/watchdog/bcm2835_wdt.c                     |  1 +
 fs/afs/cmservice.c                                 | 10 +--
 fs/afs/dir.c                                       |  3 +-
 fs/afs/file.c                                      | 12 ++--
 fs/afs/vlclient.c                                  | 11 ++--
 fs/nfs/direct.c                                    | 34 ++++++----
 fs/nfs/pagelist.c                                  | 32 ++++-----
 fs/nfs/read.c                                      |  2 +-
 fs/nfs/write.c                                     | 11 +++-
 include/linux/logic_pio.h                          |  1 +
 include/linux/nfs_page.h                           | 10 +++
 include/linux/nfs_xdr.h                            |  2 +-
 kernel/trace/ftrace.c                              | 17 +++++
 lib/logic_pio.c                                    | 73 +++++++++++++++------
 mm/zsmalloc.c                                      |  2 +
 net/core/stream.c                                  | 16 +++--
 net/ipv4/icmp.c                                    |  8 ++-
 net/ipv6/addrconf.c                                |  3 +-
 net/ipv6/route.c                                   |  2 +-
 net/mac80211/cfg.c                                 |  9 +--
 net/mac80211/rx.c                                  |  6 +-
 net/smc/smc_tx.c                                   |  6 +-
 net/tls/tls_main.c                                 |  2 +
 net/tls/tls_sw.c                                   | 10 +--
 net/wireless/reg.c                                 |  2 +-
 sound/core/seq/seq_clientmgr.c                     |  3 +-
 sound/core/seq/seq_fifo.c                          | 17 +++++
 sound/core/seq/seq_fifo.h                          |  2 +
 sound/pci/hda/patch_conexant.c                     | 17 ++---
 sound/usb/line6/pcm.c                              | 18 +++---
 sound/usb/mixer.c                                  | 36 ++++++++---
 sound/usb/mixer_quirks.c                           |  8 +--
 sound/usb/pcm.c                                    |  1 +
 tools/hv/hv_kvp_daemon.c                           |  2 +
 tools/hv/hv_vss_daemon.c                           |  2 +
 tools/hv/lsvmbus                                   | 75 ++++++++++++----------
 virt/kvm/arm/vgic/vgic-mmio.c                      | 18 ++++++
 virt/kvm/arm/vgic/vgic-v2.c                        |  5 +-
 virt/kvm/arm/vgic/vgic-v3.c                        |  5 +-
 virt/kvm/arm/vgic/vgic.c                           |  7 ++
 100 files changed, 699 insertions(+), 337 deletions(-)


