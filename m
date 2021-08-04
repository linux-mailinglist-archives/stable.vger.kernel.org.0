Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EE73E0113
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 14:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238035AbhHDMYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 08:24:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238060AbhHDMYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 08:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D595A60F22;
        Wed,  4 Aug 2021 12:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628079850;
        bh=9rpxioJxjAuDbHc+7Kq9ILNH7uuckZuvP2H5PdyX7Us=;
        h=From:To:Cc:Subject:Date:From;
        b=HEIcBMv1UKhYiwHPOZ5bCrekMbF3igif1vo06en4fe4Ns799qteOu8tjcijwuBjfb
         Rd+umwko06gZnUDZu6w8Z60w0ZvrCOpP8VdpSsfmYzAhbrmjyhBNgsQ8EejocsFXHC
         Q4DtZk1iwvdCD60BlkepC8adi88L7L+nBg1VW5k0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.138
Date:   Wed,  4 Aug 2021 14:23:55 +0200
Message-Id: <162807983610824@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.138 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/powerpc/platforms/pseries/setup.c            |    2 
 arch/x86/include/asm/proto.h                      |    2 
 arch/x86/kvm/ioapic.c                             |    2 
 arch/x86/kvm/ioapic.h                             |    4 
 drivers/acpi/resource.c                           |    9 -
 drivers/hid/wacom_wac.c                           |    2 
 drivers/net/can/spi/hi311x.c                      |    2 
 drivers/net/can/usb/ems_usb.c                     |   14 ++
 drivers/net/can/usb/esd_usb2.c                    |   16 +++
 drivers/net/can/usb/mcba_usb.c                    |    2 
 drivers/net/can/usb/usb_8dev.c                    |   15 ++-
 drivers/net/ethernet/dec/tulip/winbond-840.c      |    7 -
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c    |    6 +
 drivers/net/ethernet/intel/i40e/i40e_main.c       |   61 +++++++------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c       |   50 ++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h       |    2 
 drivers/net/ethernet/mellanox/mlx4/main.c         |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c   |   33 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |   10 +-
 drivers/net/ethernet/sis/sis900.c                 |    7 -
 drivers/net/ethernet/sun/niu.c                    |    3 
 drivers/nfc/nfcsim.c                              |    3 
 drivers/pci/controller/pci-mvebu.c                |   16 ++-
 fs/btrfs/compression.c                            |    2 
 fs/btrfs/volumes.c                                |    1 
 fs/ocfs2/file.c                                   |  103 +++++++++++++---------
 include/net/llc_pdu.h                             |   31 ++++--
 net/can/j1939/transport.c                         |   11 +-
 net/can/raw.c                                     |   20 +++-
 net/ipv4/ip_tunnel.c                              |    2 
 net/llc/af_llc.c                                  |   10 +-
 net/llc/llc_s_ac.c                                |    2 
 net/netfilter/nf_conntrack_core.c                 |    7 +
 net/netfilter/nft_nat.c                           |    4 
 net/sched/act_api.c                               |    2 
 net/sctp/input.c                                  |    2 
 net/tipc/socket.c                                 |    9 -
 net/wireless/scan.c                               |    6 -
 tools/perf/util/map.c                             |    2 
 virt/kvm/kvm_main.c                               |   28 +++++
 41 files changed, 374 insertions(+), 139 deletions(-)

Arkadiusz Kubalewski (2):
      i40e: Fix logic of disabling queues
      i40e: Fix firmware LLDP agent related warning

Arnaldo Carvalho de Melo (1):
      Revert "perf map: Fix dso->nsinfo refcounting"

Cong Wang (1):
      net_sched: check error pointer in tcf_dump_walker()

Dan Carpenter (1):
      can: hi311x: fix a signedness bug in hi3110_cmd()

Desmond Cheong Zhi Xi (1):
      btrfs: fix rw device counting in __btrfs_free_extra_devids

Dima Chumak (1):
      net/mlx5e: Fix nullptr in mlx5e_hairpin_get_mdev()

Florian Westphal (1):
      netfilter: conntrack: adjust stop timestamp to real expiry value

Gilad Naaman (1):
      net: Set true network header for ECN decapsulation

Goldwyn Rodrigues (1):
      btrfs: mark compressed range uptodate only if all bio succeed

Greg Kroah-Hartman (1):
      Linux 5.4.138

Hoang Le (1):
      tipc: fix sleeping in tipc accept routine

Hui Wang (1):
      Revert "ACPI: resources: Add checks for ACPI IRQ override"

Jan Kiszka (1):
      x86/asm: Ensure asm/proto.h can be included stand-alone

Jason Gerecke (1):
      HID: wacom: Re-enable touch by default for Cintiq 24HDT / 27QHDT

Jedrzej Jagielski (2):
      i40e: Fix queue-to-TC mapping on Tx
      i40e: Fix log TC creation failure when max num of queues is exceeded

Jiapeng Chong (1):
      mlx4: Fix missing error code in mlx4_load_one()

Juergen Gross (1):
      x86/kvm: fix vcpu-id indexed array sizes

Junxiao Bi (2):
      ocfs2: fix zero out valid data
      ocfs2: issue zeroout to EOF blocks

Krzysztof Kozlowski (1):
      nfc: nfcsim: fix use after free during module unload

Lukasz Cieplicki (1):
      i40e: Add additional info to PHY type error

Maor Gottlieb (1):
      net/mlx5: Fix flow table chaining

Marcelo Ricardo Leitner (1):
      sctp: fix return value check in __sctp_rcv_asconf_lookup

Nguyen Dinh Phi (1):
      cfg80211: Fix possible memory leak in function cfg80211_bss_update

Oleksij Rempel (1):
      can: j1939: j1939_session_deactivate(): clarify lifetime of session object

Pablo Neira Ayuso (1):
      netfilter: nft_nat: allow to specify layer 4 protocol NAT only

Paolo Bonzini (1):
      KVM: add missing compat KVM_CLEAR_DIRTY_LOG

Paul Jakma (1):
      NIU: fix incorrect error return, missed in previous revert

Pavel Skripkin (5):
      can: mcba_usb_start(): add missing urb->transfer_dma initialization
      can: usb_8dev: fix memory leak
      can: ems_usb: fix memory leak
      can: esd_usb2: fix memory leak
      net: llc: fix skb_over_panic

Shmuel Hazan (1):
      PCI: mvebu: Setup BAR0 in order to fix MSI

Srikar Dronamraju (1):
      powerpc/pseries: Fix regression while building external modules

Wang Hai (2):
      tulip: windbond-840: Fix missing pci_disable_device() in probe and remove
      sis900: Fix missing pci_disable_device() in probe and remove

Zhang Changzhong (1):
      can: j1939: j1939_xtp_rx_dat_one(): fix rxtimer value between consecutive TP.DT to 750ms

Ziyang Xuan (1):
      can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF

