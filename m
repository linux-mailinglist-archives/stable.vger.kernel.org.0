Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FC23DD86F
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbhHBNwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234439AbhHBNvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22D0260FC4;
        Mon,  2 Aug 2021 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912247;
        bh=A0gN0i7TEOHU9iBr6HXiXezP2HKrZAFNyKmPjen9ajM=;
        h=From:To:Cc:Subject:Date:From;
        b=R9nD4OQfjP+IGBlnYk263vcURrNI8qRdaHyf2VKBOy4RHJeJcrEpl8nOo3QubpDoG
         4UteS96wVMwghzQcbY++21opNe8NgTh9rrbycwx8BpaHq2JV5x936D0iuuOc/Vi/Nh
         gaVV7MtX4y0M3iLPqahivsTgm32DBk7nQItCbMWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/40] 5.4.138-rc1 review
Date:   Mon,  2 Aug 2021 15:44:40 +0200
Message-Id: <20210802134335.408294521@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.138-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.138-rc1
X-KernelTest-Deadline: 2021-08-04T13:43+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.138 release.
There are 40 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.138-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.138-rc1

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: j1939_session_deactivate(): clarify lifetime of session object

Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
    i40e: Add additional info to PHY type error

Arnaldo Carvalho de Melo <acme@redhat.com>
    Revert "perf map: Fix dso->nsinfo refcounting"

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc/pseries: Fix regression while building external modules

Shmuel Hazan <sh@tkos.co.il>
    PCI: mvebu: Setup BAR0 in order to fix MSI

Dan Carpenter <dan.carpenter@oracle.com>
    can: hi311x: fix a signedness bug in hi3110_cmd()

Wang Hai <wanghai38@huawei.com>
    sis900: Fix missing pci_disable_device() in probe and remove

Wang Hai <wanghai38@huawei.com>
    tulip: windbond-840: Fix missing pci_disable_device() in probe and remove

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: fix return value check in __sctp_rcv_asconf_lookup

Dima Chumak <dchumak@nvidia.com>
    net/mlx5e: Fix nullptr in mlx5e_hairpin_get_mdev()

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix flow table chaining

Pavel Skripkin <paskripkin@gmail.com>
    net: llc: fix skb_over_panic

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    mlx4: Fix missing error code in mlx4_load_one()

Gilad Naaman <gnaaman@drivenets.com>
    net: Set true network header for ECN decapsulation

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix sleeping in tipc accept routine

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Fix log TC creation failure when max num of queues is exceeded

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Fix queue-to-TC mapping on Tx

Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    i40e: Fix firmware LLDP agent related warning

Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    i40e: Fix logic of disabling queues

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_nat: allow to specify layer 4 protocol NAT only

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: adjust stop timestamp to real expiry value

Nguyen Dinh Phi <phind.uet@gmail.com>
    cfg80211: Fix possible memory leak in function cfg80211_bss_update

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: nfcsim: fix use after free during module unload

Paul Jakma <paul@jakma.org>
    NIU: fix incorrect error return, missed in previous revert

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Re-enable touch by default for Cintiq 24HDT / 27QHDT

Pavel Skripkin <paskripkin@gmail.com>
    can: esd_usb2: fix memory leak

Pavel Skripkin <paskripkin@gmail.com>
    can: ems_usb: fix memory leak

Pavel Skripkin <paskripkin@gmail.com>
    can: usb_8dev: fix memory leak

Pavel Skripkin <paskripkin@gmail.com>
    can: mcba_usb_start(): add missing urb->transfer_dma initialization

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_xtp_rx_dat_one(): fix rxtimer value between consecutive TP.DT to 750ms

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: issue zeroout to EOF blocks

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: fix zero out valid data

Paolo Bonzini <pbonzini@redhat.com>
    KVM: add missing compat KVM_CLEAR_DIRTY_LOG

Juergen Gross <jgross@suse.com>
    x86/kvm: fix vcpu-id indexed array sizes

Hui Wang <hui.wang@canonical.com>
    Revert "ACPI: resources: Add checks for ACPI IRQ override"

Goldwyn Rodrigues <rgoldwyn@suse.de>
    btrfs: mark compressed range uptodate only if all bio succeed

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    btrfs: fix rw device counting in __btrfs_free_extra_devids

Jan Kiszka <jan.kiszka@siemens.com>
    x86/asm: Ensure asm/proto.h can be included stand-alone

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: check error pointer in tcf_dump_walker()


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/powerpc/platforms/pseries/setup.c            |   2 +-
 arch/x86/include/asm/proto.h                      |   2 +
 arch/x86/kvm/ioapic.c                             |   2 +-
 arch/x86/kvm/ioapic.h                             |   4 +-
 drivers/acpi/resource.c                           |   9 +-
 drivers/hid/wacom_wac.c                           |   2 +-
 drivers/net/can/spi/hi311x.c                      |   2 +-
 drivers/net/can/usb/ems_usb.c                     |  14 ++-
 drivers/net/can/usb/esd_usb2.c                    |  16 +++-
 drivers/net/can/usb/mcba_usb.c                    |   2 +
 drivers/net/can/usb/usb_8dev.c                    |  15 +++-
 drivers/net/ethernet/dec/tulip/winbond-840.c      |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c    |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c       |  61 ++++++++-----
 drivers/net/ethernet/intel/i40e/i40e_txrx.c       |  50 +++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h       |   2 +
 drivers/net/ethernet/mellanox/mlx4/main.c         |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c   |  33 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |  10 ++-
 drivers/net/ethernet/sis/sis900.c                 |   7 +-
 drivers/net/ethernet/sun/niu.c                    |   3 +-
 drivers/nfc/nfcsim.c                              |   3 +-
 drivers/pci/controller/pci-mvebu.c                |  16 +++-
 fs/btrfs/compression.c                            |   2 +-
 fs/btrfs/volumes.c                                |   1 +
 fs/ocfs2/file.c                                   | 103 +++++++++++++---------
 include/net/llc_pdu.h                             |  31 +++++--
 net/can/j1939/transport.c                         |  11 ++-
 net/can/raw.c                                     |  20 ++++-
 net/ipv4/ip_tunnel.c                              |   2 +-
 net/llc/af_llc.c                                  |  10 ++-
 net/llc/llc_s_ac.c                                |   2 +-
 net/netfilter/nf_conntrack_core.c                 |   7 +-
 net/netfilter/nft_nat.c                           |   4 +-
 net/sched/act_api.c                               |   2 +
 net/sctp/input.c                                  |   2 +-
 net/tipc/socket.c                                 |   9 +-
 net/wireless/scan.c                               |   6 +-
 tools/perf/util/map.c                             |   2 -
 virt/kvm/kvm_main.c                               |  28 ++++++
 41 files changed, 375 insertions(+), 140 deletions(-)


