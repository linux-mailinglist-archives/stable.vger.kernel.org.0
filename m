Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A26A30C140
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbhBBORs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:17:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234255AbhBBOO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:14:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0C0D65059;
        Tue,  2 Feb 2021 13:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612274018;
        bh=w7XUURTaXbNFcUNXLiN8nL2ms/dE2ZI1+DGYss5AN8A=;
        h=From:To:Cc:Subject:Date:From;
        b=JigxYu6M8v6lXyUWQ70F503XpkAJ0WQxyzL2ozcU76/VmwbS/OR0FZiAhoG87MDG/
         GQ+K78RpYteUGfWEIPRfwpZv4/tnKiFHLiJWPNWjp24n3Ecn/g8cOuZKczeevC2xJS
         B6mQHULMhjbnLZUFqgJ5A+H9y7XqitkaJ0ttPPdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/37] 4.19.173-rc1 review
Date:   Tue,  2 Feb 2021 14:38:43 +0100
Message-Id: <20210202132942.915040339@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.173-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.173-rc1
X-KernelTest-Deadline: 2021-02-04T13:29+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.173 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.173-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.173-rc1

Pengcheng Yang <yangpc@wangsu.com>
    tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN

Ivan Vecera <ivecera@redhat.com>
    team: protect features update by RCU to avoid deadlock

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

Dan Carpenter <dan.carpenter@oracle.com>
    can: dev: prevent potential information leak in can_fill_info()

Roi Dayan <roid@nvidia.com>
    net/mlx5: Fix memory leak on flow table creation error flow

Johannes Berg <johannes.berg@intel.com>
    mac80211: pause TX while changing interface type

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: reschedule in long-running memory reads

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: use jiffies for memory read spin time limit

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/NFSv4: Fix a layout segment leak in pnfs_layout_process()

Kamal Heib <kamalheib1@gmail.com>
    RDMA/cxgb4: Fix the reported max_recv_sge value

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

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: fix rx buffer refcounting

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: fix kernel crash unplugging the device

Andrea Righi <andrea.righi@canonical.com>
    leds: trigger: fix potential deadlock with libata

David Woodhouse <dwmw@amazon.co.uk>
    xen: Fix XenStore initialisation for XS_LOCAL

Jay Zhou <jianjay.zhou@huawei.com>
    KVM: x86: get smi pending status correctly

Like Xu <like.xu@linux.intel.com>
    KVM: x86/pmu: Fix HW_REF_CPU_CYCLES event pseudo-encoding in intel_arch_events[]

Claudiu Beznea <claudiu.beznea@microchip.com>
    drivers: soc: atmel: add null entry at the end of at91_soc_allowed_list[]

Sudeep Holla <sudeep.holla@arm.com>
    drivers: soc: atmel: Avoid calling at91_soc_init on non AT91 SoCs

Laurent Badel <laurentbadel@eaton.com>
    PM: hibernate: flush swap writer after marking

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

Roger Pau Monne <roger.pau@citrix.com>
    xen/privcmd: allow fetching resource sizes

Baoquan He <bhe@redhat.com>
    kernel: kexec: remove the lock operation of system_transition_mutex

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ACPI: sysfs: Prefer "compatible" modalias

Josef Bacik <josef@toxicpanda.com>
    nbd: freeze the queue while we're adding connections


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi             |  2 +-
 arch/arm/mach-imx/suspend-imx6.S                  |  1 +
 arch/x86/kvm/pmu_intel.c                          |  2 +-
 arch/x86/kvm/x86.c                                |  5 +++
 drivers/acpi/device_sysfs.c                       | 20 +++-------
 drivers/block/nbd.c                               |  8 ++++
 drivers/block/xen-blkfront.c                      | 20 ++++------
 drivers/infiniband/hw/cxgb4/qp.c                  |  2 +-
 drivers/iommu/dmar.c                              | 45 ++++++++++++++++-------
 drivers/leds/led-triggers.c                       | 10 +++--
 drivers/media/rc/rc-main.c                        |  4 +-
 drivers/net/can/dev.c                             |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |  1 +
 drivers/net/team/team.c                           |  6 +--
 drivers/net/usb/qmi_wwan.c                        |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   | 14 ++++---
 drivers/net/wireless/mediatek/mt7601u/dma.c       |  5 +--
 drivers/soc/atmel/soc.c                           | 13 +++++++
 drivers/xen/privcmd.c                             | 25 ++++++++++---
 drivers/xen/xenbus/xenbus_probe.c                 | 31 ++++++++++++++++
 fs/nfs/pnfs.c                                     |  1 +
 include/linux/intel-iommu.h                       |  2 +
 include/net/tcp.h                                 |  2 +-
 kernel/kexec_core.c                               |  2 -
 kernel/power/swap.c                               |  2 +-
 net/ipv4/tcp_input.c                              | 10 +++--
 net/ipv4/tcp_recovery.c                           |  5 ++-
 net/mac80211/ieee80211_i.h                        |  1 +
 net/mac80211/iface.c                              |  6 +++
 net/netfilter/nft_dynset.c                        |  4 +-
 net/nfc/netlink.c                                 |  1 +
 net/nfc/rawsock.c                                 |  2 +-
 net/rxrpc/call_accept.c                           |  1 +
 net/wireless/wext-core.c                          |  5 ++-
 net/xfrm/xfrm_input.c                             |  2 +-
 net/xfrm/xfrm_policy.c                            |  4 +-
 sound/pci/hda/patch_via.c                         |  2 +-
 38 files changed, 184 insertions(+), 89 deletions(-)


