Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B40A101912
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfKSFWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:22:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbfKSFWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:22:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CFAC21939;
        Tue, 19 Nov 2019 05:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140969;
        bh=k4n1Sn7Yz/qI06AB99aZP0Ht/DjmH8rd8hLfj7todRY=;
        h=From:To:Cc:Subject:Date:From;
        b=RRd3y47u7WhqNP2j4Aol7GByJNM3wBJrS6idk0A9LysY5F2n4xjGgcu5Hs6Cz/ojo
         o+BMg/EeTT3Iq5491h4/PALOFKfvegRVwO9JMNchA7Y2/Chs4+nAEjaTeenwP5k7qz
         v9yHwLAmleFZ632gdVEOU4wMubCJg9uDX5airGTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 00/48] 5.3.12-stable review
Date:   Tue, 19 Nov 2019 06:19:20 +0100
Message-Id: <20191119050946.745015350@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.12-rc1
X-KernelTest-Deadline: 2019-11-21T05:10+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.12 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.12-rc1

Eugen Hristev <eugen.hristev@microchip.com>
    mmc: sdhci-of-at91: fix quirk2 overwrite

Vinayak Menon <vinmenon@codeaurora.org>
    mm/page_io.c: do not free shared swap slots

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: fix try_offline_node()

Laura Abbott <labbott@redhat.com>
    mm: slub: really fix slab walking for init_on_free

Roman Gushchin <guro@fb.com>
    mm: hugetlb: switch to css_tryget() in hugetlb_cgroup_charge_cgroup()

Roman Gushchin <guro@fb.com>
    mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()

Yang Shi <yang.shi@linux.alibaba.com>
    mm: mempolicy: fix the wrong return value and potential pages leak of mbind

Eric Auger <eric.auger@redhat.com>
    iommu/vt-d: Fix QI_DEV_IOTLB_PFSID and QI_DEV_EIOTLB_PFSID macros

Corentin Labbe <clabbe@baylibre.com>
    net: ethernet: dwmac-sun8i: Use the correct function in exit path

Arnd Bergmann <arnd@arndb.de>
    ntp/y2038: Remove incorrect time_t truncation

Matt Roper <matthew.d.roper@intel.com>
    Revert "drm/i915/ehl: Update MOCS table for EHL"

Jani Nikula <jani.nikula@intel.com>
    drm/i915: update rawclk also on resume

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure registered buffer import returns the IO length

Al Viro <viro@zeniv.linux.org.uk>
    ecryptfs_lookup_interpose(): lower_dentry->d_parent is not stable either

Al Viro <viro@zeniv.linux.org.uk>
    ecryptfs_lookup_interpose(): lower_dentry->d_inode is not stable

Kai-Heng Feng <kai.heng.feng@canonical.com>
    x86/quirks: Disable HPET on Intel Coffe Lake platforms

Hans de Goede <hdegoede@redhat.com>
    i2c: acpi: Force bus speed to 400KHz if a Silead touchscreen is present

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Use a common pad buffer for 9B and 16B packets

James Erwin <james.erwin@intel.com>
    IB/hfi1: Ensure full Gen3 speed in a Gen4 system

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: TID RDMA WRITE should not return IB_WC_RNR_RETRY_EXC_ERR

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Calculate flow weight based on QP MTU for TID RDMA

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Ensure r_tid_ack is valid before building TID RDMA ACK packet

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved

Chuhong Yuan <hslester96@gmail.com>
    Input: synaptics-rmi4 - destroy F54 poller workqueue when removing

Lucas Stach <l.stach@pengutronix.de>
    Input: synaptics-rmi4 - clear IRQ enables for F54

Andrew Duggan <aduggan@synaptics.com>
    Input: synaptics-rmi4 - do not consume more data than we have (F11, F12)

Andrew Duggan <aduggan@synaptics.com>
    Input: synaptics-rmi4 - disable the relative position IRQ in the F12 driver

Lucas Stach <l.stach@pengutronix.de>
    Input: synaptics-rmi4 - fix video buffer size

Oliver Neukum <oneukum@suse.com>
    Input: ff-memless - kill timer in destroy()

Oleg Nesterov <oleg@redhat.com>
    cgroup: freezer: call cgroup_enter_frozen() with preemption disabled in ptrace_stop()

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix log context list corruption after rename exchange operation

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix incorrect size check for processing/extension units

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix incorrect NULL check in create_yamaha_midi_quirk()

Henry Lin <henryl@nvidia.com>
    ALSA: usb-audio: not submit urb for stopped endpoint

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix missing error check at mixer resolution test

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: fix refcount non-blocking connect() -part 2

Aya Levin <ayal@mellanox.com>
    devlink: Add method for time-stamp on reporter's dump

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-eth: free already allocated channels on probe defer

Tony Lu <tonylu@linux.alibaba.com>
    tcp: remove redundant new line from tcp_event_sk_skb

Jouni Hogander <jouni.hogander@unikie.com>
    slip: Fix memory leak in slip_open error path

Aleksander Morgado <aleksander@aleksander.es>
    net: usb: qmi_wwan: add support for Foxconn T77W968 LTE modules

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: fix fastopen for non-blocking connect()

Chuhong Yuan <hslester96@gmail.com>
    net: gemini: add missed free_netdev

Jiri Pirko <jiri@mellanox.com>
    mlxsw: core: Enable devlink reload only on probe

Guillaume Nault <gnault@redhat.com>
    ipmr: Fix skb headroom in ipmr_get_route().

Jiri Pirko <jiri@mellanox.com>
    devlink: disallow reload operation during device cleanup

Oliver Neukum <oneukum@suse.com>
    ax88172a: fix information leak on short answers

Michael Schmitz <schmitzmic@gmail.com>
    scsi: core: Handle drivers which set sg_tablesize to zero


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/x86/kernel/early-quirks.c                     |  2 +
 arch/x86/kvm/mmu.c                                 |  8 +--
 drivers/base/memory.c                              | 36 ++++++++++++++
 drivers/gpu/drm/i915/display/intel_display_power.c |  3 ++
 drivers/gpu/drm/i915/gt/intel_mocs.c               |  8 ---
 drivers/gpu/drm/i915/i915_drv.c                    |  3 --
 drivers/i2c/i2c-core-acpi.c                        | 28 ++++++++++-
 drivers/infiniband/hw/hfi1/init.c                  |  1 -
 drivers/infiniband/hw/hfi1/pcie.c                  |  4 +-
 drivers/infiniband/hw/hfi1/rc.c                    | 16 +++---
 drivers/infiniband/hw/hfi1/sdma.c                  |  5 +-
 drivers/infiniband/hw/hfi1/tid_rdma.c              | 57 ++++++++++++----------
 drivers/infiniband/hw/hfi1/tid_rdma.h              |  3 +-
 drivers/infiniband/hw/hfi1/verbs.c                 | 10 ++--
 drivers/input/ff-memless.c                         |  9 ++++
 drivers/input/rmi4/rmi_f11.c                       |  4 +-
 drivers/input/rmi4/rmi_f12.c                       | 32 ++++++++++--
 drivers/input/rmi4/rmi_f54.c                       |  5 +-
 drivers/mmc/host/sdhci-of-at91.c                   |  2 +-
 drivers/net/ethernet/cortina/gemini.c              |  1 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 10 +++-
 drivers/net/ethernet/mellanox/mlx4/main.c          |  3 ++
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  5 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |  2 +-
 drivers/net/netdevsim/dev.c                        |  2 +
 drivers/net/slip/slip.c                            |  1 +
 drivers/net/usb/ax88172a.c                         |  2 +-
 drivers/net/usb/qmi_wwan.c                         |  2 +
 drivers/scsi/scsi_lib.c                            |  3 +-
 fs/btrfs/inode.c                                   | 15 ++++++
 fs/ecryptfs/inode.c                                | 19 +++++---
 fs/io_uring.c                                      |  2 +-
 include/linux/intel-iommu.h                        |  6 ++-
 include/linux/kvm_host.h                           |  1 +
 include/linux/memory.h                             |  1 +
 include/net/devlink.h                              |  3 ++
 include/trace/events/tcp.h                         |  2 +-
 include/uapi/linux/devlink.h                       |  1 +
 kernel/signal.c                                    |  2 +-
 kernel/time/ntp.c                                  |  2 +-
 mm/hugetlb_cgroup.c                                |  2 +-
 mm/memcontrol.c                                    |  2 +-
 mm/memory_hotplug.c                                | 43 ++++++++++------
 mm/mempolicy.c                                     | 14 ++++--
 mm/page_io.c                                       |  6 +--
 mm/slub.c                                          | 39 ++++-----------
 net/core/devlink.c                                 | 45 ++++++++++++++++-
 net/ipv4/ipmr.c                                    |  3 +-
 net/smc/af_smc.c                                   |  3 +-
 sound/usb/endpoint.c                               |  3 ++
 sound/usb/mixer.c                                  |  4 +-
 sound/usb/quirks.c                                 |  4 +-
 sound/usb/validate.c                               |  6 +--
 virt/kvm/kvm_main.c                                | 26 ++++++++--
 55 files changed, 369 insertions(+), 156 deletions(-)


