Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C4A30C7F6
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237652AbhBBRg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:36:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234136AbhBBOMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:12:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F29476503F;
        Tue,  2 Feb 2021 13:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273940;
        bh=7e/aVsahmQoNFB8Pe/h7Yc+dRm8tI1iNWsH2VTPfrDc=;
        h=From:To:Cc:Subject:Date:From;
        b=iMzBSgsokxYK17IUbccV7pK0zgsFtf7yeX+BcBJ2SQkwnf4xZ8N1Z4RBmZq0Qv59q
         xTB/hPSKmRr+oalSGUTfyqevoxTtAdRI9h2VzggpPAp0TTouWYlcrTeRiUkcdPKvPf
         pl4T4czJL6bKZbhCxUTcfqw1Gu7F0ST63mh4bHMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/30] 4.14.219-rc1 review
Date:   Tue,  2 Feb 2021 14:38:41 +0100
Message-Id: <20210202132942.138623851@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.219-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.219-rc1
X-KernelTest-Deadline: 2021-02-04T13:29+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.219 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.219-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.219-rc1

Pengcheng Yang <yangpc@wangsu.com>
    tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN

Ivan Vecera <ivecera@redhat.com>
    team: protect features update by RCU to avoid deadlock

Pan Bian <bianpan2016@163.com>
    NFC: fix possible resource leak

Pan Bian <bianpan2016@163.com>
    NFC: fix resource leak when target index is invalid

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    iommu/vt-d: Don't dereference iommu_device if IOMMU_API is not built

David Woodhouse <dwmw@amazon.co.uk>
    iommu/vt-d: Gracefully handle DMAR units with no supported address widths

Andy Lutomirski <luto@kernel.org>
    x86/entry/64/compat: Fix "x86/entry/64/compat: Preserve r8-r11 in int $0x80"

Andy Lutomirski <luto@kernel.org>
    x86/entry/64/compat: Preserve r8-r11 in int $0x80

Dan Carpenter <dan.carpenter@oracle.com>
    can: dev: prevent potential information leak in can_fill_info()

Johannes Berg <johannes.berg@intel.com>
    mac80211: pause TX while changing interface type

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: reschedule in long-running memory reads

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: use jiffies for memory read spin time limit

Kamal Heib <kamalheib1@gmail.com>
    RDMA/cxgb4: Fix the reported max_recv_sge value

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

Giacinto Cifelli <gciofono@gmail.com>
    net: usb: qmi_wwan: added support for Thales Cinterion PLSx3 modem family

Johannes Berg <johannes.berg@intel.com>
    wext: fix NULL-ptr-dereference with cfg80211's lack of commit()

Koen Vandeputte <koen.vandeputte@citymesh.com>
    ARM: dts: imx6qdl-gw52xx: fix duplicate regulator naming

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ACPI: sysfs: Prefer "compatible" modalias

Josef Bacik <josef@toxicpanda.com>
    nbd: freeze the queue while we're adding connections


-------------

Diffstat:

 Makefile                                        |  4 +--
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi           |  2 +-
 arch/arm/mach-imx/suspend-imx6.S                |  1 +
 arch/x86/entry/entry_64_compat.S                |  8 ++---
 arch/x86/kvm/pmu_intel.c                        |  2 +-
 arch/x86/kvm/x86.c                              |  5 +++
 drivers/acpi/device_sysfs.c                     | 20 ++++-------
 drivers/block/nbd.c                             |  8 +++++
 drivers/block/xen-blkfront.c                    | 20 ++++-------
 drivers/infiniband/hw/cxgb4/qp.c                |  2 +-
 drivers/iommu/dmar.c                            | 45 +++++++++++++++++--------
 drivers/leds/led-triggers.c                     | 10 +++---
 drivers/net/can/dev.c                           |  2 +-
 drivers/net/team/team.c                         |  6 ++--
 drivers/net/usb/qmi_wwan.c                      |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 14 ++++----
 drivers/net/wireless/mediatek/mt7601u/dma.c     |  5 ++-
 drivers/soc/atmel/soc.c                         | 13 +++++++
 drivers/xen/xenbus/xenbus_probe.c               | 31 +++++++++++++++++
 include/linux/intel-iommu.h                     |  2 ++
 include/net/tcp.h                               |  2 +-
 net/ipv4/tcp_input.c                            | 10 +++---
 net/ipv4/tcp_recovery.c                         |  5 +--
 net/mac80211/ieee80211_i.h                      |  1 +
 net/mac80211/iface.c                            |  6 ++++
 net/netfilter/nft_dynset.c                      |  4 ++-
 net/nfc/netlink.c                               |  1 +
 net/nfc/rawsock.c                               |  2 +-
 net/wireless/wext-core.c                        |  5 +--
 net/xfrm/xfrm_input.c                           |  2 +-
 tools/testing/selftests/x86/test_syscall_vdso.c | 35 +++++++++++--------
 31 files changed, 181 insertions(+), 93 deletions(-)


