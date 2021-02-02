Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F9530CB6B
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbhBBTXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:23:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233585AbhBBOAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:00:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 247F464FF6;
        Tue,  2 Feb 2021 13:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273595;
        bh=3UkQYoZljW/RNBu7w35hE4nkonkP3JqBZOsdEkiKNao=;
        h=From:To:Cc:Subject:Date:From;
        b=Zb4VpJhM60S6tY9ov6oh6yGgQB32rc4XK7NS9MHXYmca3zESTbmMXQg2pjQJKwAWt
         lrtUbhJ4XTFaKXjLR32jthDzJfEfiMQa/uzkuJmsh3Sm4tjXiXpJ3XhKzI3BMujOAJ
         rAy088oGBjbN4CdDrFjN1+em91RAD7xm9cu4JLWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/61] 5.4.95-rc1 review
Date:   Tue,  2 Feb 2021 14:37:38 +0100
Message-Id: <20210202132946.480479453@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.95-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.95-rc1
X-KernelTest-Deadline: 2021-02-04T13:29+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.95 release.
There are 61 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.95-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.95-rc1

Pengcheng Yang <yangpc@wangsu.com>
    tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN

Ivan Vecera <ivecera@redhat.com>
    team: protect features update by RCU to avoid deadlock

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: topology: Fix memory corruption in soc_tplg_denum_create_values()

Pan Bian <bianpan2016@163.com>
    NFC: fix possible resource leak

Pan Bian <bianpan2016@163.com>
    NFC: fix resource leak when target index is invalid

Takeshi Misawa <jeliantsurux@gmail.com>
    rxrpc: Fix memory leak in rxrpc_lookup_local

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    iommu/vt-d: Don't dereference iommu_device if IOMMU_API is not built

David Woodhouse <dwmw@amazon.co.uk>
    iommu/vt-d: Gracefully handle DMAR units with no supported address widths

Danielle Ratson <danieller@nvidia.com>
    selftests: forwarding: Specify interface when invoking mausezahn

Daniel Wagner <dwagner@suse.de>
    nvme-multipath: Early exit if no path is available

Dan Carpenter <dan.carpenter@oracle.com>
    can: dev: prevent potential information leak in can_fill_info()

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Reduce tc unsupported key print level

Parav Pandit <parav@nvidia.com>
    net/mlx5e: E-switch, Fix rate calculation for overflow

Roi Dayan <roid@nvidia.com>
    net/mlx5: Fix memory leak on flow table creation error flow

Corinna Vinschen <vinschen@redhat.com>
    igc: fix link speed advertising

Stefan Assmann <sassmann@kpanic.de>
    i40e: acquire VSI pointer only after VF is initialized

Johannes Berg <johannes.berg@intel.com>
    mac80211: pause TX while changing interface type

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: reschedule in long-running memory reads

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: use jiffies for memory read spin time limit

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/NFSv4: Fix a layout segment leak in pnfs_layout_process()

Ricardo Ribalda <ribalda@chromium.org>
    ASoC: Intel: Skylake: skl-topology: Fix OOPs ib skl_tplg_complete

Kamal Heib <kamalheib1@gmail.com>
    RDMA/cxgb4: Fix the reported max_recv_sge value

Randy Dunlap <rdunlap@infradead.org>
    firmware: imx: select SOC_BUS to fix firmware build

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: imx6qdl-kontron-samx6i: fix i2c_lcd/cam default status

Michael Walle <michael@walle.cc>
    arm64: dts: ls1028a: fix the offset of the reset register

Visa Hankala <visa@hankala.org>
    xfrm: Fix wraparound in xfrm_policy_addr_delta()

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: xfrm: fix test return value override issue in xfrm_policy.sh

Eyal Birger <eyal.birger@gmail.com>
    xfrm: fix disable_xfrm sysctl when used on xfrm interfaces

Shmulik Ladkani <shmulik@metanetworks.com>
    xfrm: Fix oops in xfrm_replay_advance_bmp

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_dynset: add timeout extension to template

Max Krummenacher <max.oss.09@gmail.com>
    ARM: imx: build suspend-imx6.S with arm instruction set

Roger Pau Monne <roger.pau@citrix.com>
    xen-blkfront: allow discard-* nodes to be optional

Rouven Czerwinski <r.czerwinski@pengutronix.de>
    tee: optee: replace might_sleep with cond_resched

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    drm/i915: Check for all subplatform bits

Karol Herbst <kherbst@redhat.com>
    drm/nouveau/svm: fail NOUVEAU_SVM_INIT ioctl on unsupported devices

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: fix rx buffer refcounting

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: fix kernel crash unplugging the device

Bharat Gooty <bharat.gooty@broadcom.com>
    arm64: dts: broadcom: Fix USB DMA address translation for Stingray

Andrea Righi <andrea.righi@canonical.com>
    leds: trigger: fix potential deadlock with libata

David Woodhouse <dwmw@amazon.co.uk>
    xen: Fix XenStore initialisation for XS_LOCAL

Marc Zyngier <maz@kernel.org>
    KVM: Forbid the use of tagged userspace addresses for memslots

Jay Zhou <jianjay.zhou@huawei.com>
    KVM: x86: get smi pending status correctly

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: nVMX: Sync unsync'd vmcs02 state to vmcs12 on migration

Like Xu <like.xu@linux.intel.com>
    KVM: x86/pmu: Fix UBSAN shift-out-of-bounds warning in intel_pmu_refresh()

Like Xu <like.xu@linux.intel.com>
    KVM: x86/pmu: Fix HW_REF_CPU_CYCLES event pseudo-encoding in intel_arch_events[]

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix possible free space tree corruption with online conversion

Claudiu Beznea <claudiu.beznea@microchip.com>
    drivers: soc: atmel: add null entry at the end of at91_soc_allowed_list[]

Sudeep Holla <sudeep.holla@arm.com>
    drivers: soc: atmel: Avoid calling at91_soc_init on non AT91 SoCs

Laurent Badel <laurentbadel@eaton.com>
    PM: hibernate: flush swap writer after marking

Tony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: No need to disable IRQ after queue reset

Giacinto Cifelli <gciofono@gmail.com>
    net: usb: qmi_wwan: added support for Thales Cinterion PLSx3 modem family

Johannes Berg <johannes.berg@intel.com>
    wext: fix NULL-ptr-dereference with cfg80211's lack of commit()

Koen Vandeputte <koen.vandeputte@citymesh.com>
    ARM: dts: imx6qdl-gw52xx: fix duplicate regulator naming

Sean Young <sean@mess.org>
    media: rc: ensure that uevent can be read directly after rc device register

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/via: Apply the workaround generically for Clevo machines

Jian-Hong Pan <jhp@endlessos.org>
    ALSA: hda/realtek: Enable headset of ASUS B1400CEPE with ALC256

Baoquan He <bhe@redhat.com>
    kernel: kexec: remove the lock operation of system_transition_mutex

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ACPI: sysfs: Prefer "compatible" modalias

Josef Bacik <josef@toxicpanda.com>
    nbd: freeze the queue while we're adding connections

Hangbin Liu <liuhangbin@gmail.com>
    IPv6: reply ICMP error if the first fragment don't include all headers

Hangbin Liu <liuhangbin@gmail.com>
    ICMPv6: Add ICMPv6 Parameter Problem, code 3 definition


-------------

Diffstat:

 Documentation/virt/kvm/api.txt                     |   3 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi              |   2 +-
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi      |   4 +-
 arch/arm/mach-imx/suspend-imx6.S                   |   1 +
 .../boot/dts/broadcom/stingray/stingray-usb.dtsi   |   7 +-
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi     |   2 +-
 arch/x86/kvm/vmx/nested.c                          |  13 +--
 arch/x86/kvm/vmx/pmu_intel.c                       |   6 +-
 arch/x86/kvm/x86.c                                 |   5 ++
 drivers/acpi/device_sysfs.c                        |  20 ++---
 drivers/block/nbd.c                                |   8 ++
 drivers/block/xen-blkfront.c                       |  20 ++---
 drivers/firmware/imx/Kconfig                       |   1 +
 drivers/gpu/drm/i915/i915_drv.h                    |   2 +-
 drivers/gpu/drm/nouveau/nouveau_svm.c              |   4 +
 drivers/infiniband/hw/cxgb4/qp.c                   |   2 +-
 drivers/iommu/dmar.c                               |  45 +++++++---
 drivers/leds/led-triggers.c                        |  10 ++-
 drivers/media/rc/rc-main.c                         |   4 +-
 drivers/net/can/dev.c                              |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  11 +--
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |  24 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  15 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   1 +
 drivers/net/team/team.c                            |   6 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  14 +--
 drivers/net/wireless/mediatek/mt7601u/dma.c        |   5 +-
 drivers/nvme/host/multipath.c                      |   2 +-
 drivers/s390/crypto/vfio_ap_drv.c                  |   6 +-
 drivers/s390/crypto/vfio_ap_ops.c                  | 100 +++++++++++++--------
 drivers/s390/crypto/vfio_ap_private.h              |  12 +--
 drivers/soc/atmel/soc.c                            |  13 +++
 drivers/tee/optee/call.c                           |   4 +-
 drivers/xen/xenbus/xenbus_probe.c                  |  31 +++++++
 fs/btrfs/block-group.c                             |  10 ++-
 fs/btrfs/ctree.h                                   |   3 +
 fs/btrfs/free-space-tree.c                         |  10 ++-
 fs/nfs/pnfs.c                                      |   1 +
 include/linux/intel-iommu.h                        |   2 +
 include/net/tcp.h                                  |   2 +-
 include/uapi/linux/icmpv6.h                        |   1 +
 kernel/kexec_core.c                                |   2 -
 kernel/power/swap.c                                |   2 +-
 net/ipv4/tcp_input.c                               |  10 ++-
 net/ipv4/tcp_recovery.c                            |   5 +-
 net/ipv6/icmp.c                                    |   8 +-
 net/ipv6/reassembly.c                              |  33 ++++++-
 net/mac80211/ieee80211_i.h                         |   1 +
 net/mac80211/iface.c                               |   6 ++
 net/netfilter/nft_dynset.c                         |   4 +-
 net/nfc/netlink.c                                  |   1 +
 net/nfc/rawsock.c                                  |   2 +-
 net/rxrpc/call_accept.c                            |   1 +
 net/wireless/wext-core.c                           |   5 +-
 net/xfrm/xfrm_input.c                              |   2 +-
 net/xfrm/xfrm_policy.c                             |  30 ++++---
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/pci/hda/patch_via.c                          |   2 +-
 sound/soc/intel/skylake/skl-topology.c             |  13 +--
 sound/soc/soc-topology.c                           |   2 +-
 .../selftests/net/forwarding/router_mpath_nh.sh    |   2 +-
 .../selftests/net/forwarding/router_multipath.sh   |   2 +-
 tools/testing/selftests/net/xfrm_policy.sh         |  45 +++++++++-
 virt/kvm/kvm_main.c                                |   1 +
 66 files changed, 435 insertions(+), 184 deletions(-)


