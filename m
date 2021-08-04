Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF2A3E0117
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 14:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbhHDMZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 08:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237049AbhHDMYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 08:24:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5F1160F25;
        Wed,  4 Aug 2021 12:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628079859;
        bh=evNloNhFsb2VMGVlUK9YUtQ7ZyQWv5/jFuXOJdCZPH8=;
        h=From:To:Cc:Subject:Date:From;
        b=cxfeuykD9CjkTLnNS2EyHZ6UkHbZ1LLp9CPlYcgsJWJmtRuVixr4D4G490BdV0JPu
         7jaW5L62bowqXQ4u9RdDUSNfaFqSYje/BkVAcEf5cHbq1sUOdP4Kc07rbUbVC2gyLv
         i8vO1s3TX16NzERMCMzT1qFbeC4pmXozholhdbJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.56
Date:   Wed,  4 Aug 2021 14:24:04 +0200
Message-Id: <16280798441565@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.56 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                     |    2 
 arch/alpha/kernel/setup.c                                    |   13 
 arch/arm/net/bpf_jit_32.c                                    |    3 
 arch/arm64/net/bpf_jit_comp.c                                |   13 
 arch/mips/net/ebpf_jit.c                                     |    3 
 arch/powerpc/net/bpf_jit_comp64.c                            |    6 
 arch/powerpc/platforms/pseries/setup.c                       |    2 
 arch/riscv/net/bpf_jit_comp32.c                              |    4 
 arch/riscv/net/bpf_jit_comp64.c                              |    4 
 arch/s390/net/bpf_jit_comp.c                                 |    5 
 arch/sparc/net/bpf_jit_comp_64.c                             |    3 
 arch/x86/include/asm/proto.h                                 |    2 
 arch/x86/kvm/ioapic.c                                        |    2 
 arch/x86/kvm/ioapic.h                                        |    4 
 arch/x86/kvm/x86.c                                           |    4 
 arch/x86/net/bpf_jit_comp.c                                  |    7 
 arch/x86/net/bpf_jit_comp32.c                                |    6 
 block/blk-iocost.c                                           |   11 
 drivers/acpi/dptf/dptf_pch_fivr.c                            |   51 ++-
 drivers/acpi/resource.c                                      |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                   |    8 
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c                       |    7 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c |    2 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c               |    2 
 drivers/gpu/drm/msm/dp/dp_catalog.c                          |    1 
 drivers/hid/wacom_wac.c                                      |    2 
 drivers/infiniband/hw/bnxt_re/main.c                         |    4 
 drivers/infiniband/hw/bnxt_re/qplib_res.c                    |   10 
 drivers/infiniband/hw/bnxt_re/qplib_res.h                    |    1 
 drivers/net/can/spi/hi311x.c                                 |    2 
 drivers/net/can/usb/ems_usb.c                                |   14 
 drivers/net/can/usb/esd_usb2.c                               |   16 
 drivers/net/can/usb/mcba_usb.c                               |    2 
 drivers/net/can/usb/peak_usb/pcan_usb.c                      |   10 
 drivers/net/can/usb/usb_8dev.c                               |   15 
 drivers/net/ethernet/dec/tulip/winbond-840.c                 |    7 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c               |    6 
 drivers/net/ethernet/intel/i40e/i40e_main.c                  |   61 ++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                  |   50 ++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h                  |    2 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c    |    7 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c         |    5 
 drivers/net/ethernet/mellanox/mlx4/main.c                    |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c              |   33 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c            |   10 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c              |   14 
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c             |   41 +-
 drivers/net/ethernet/sis/sis900.c                            |    7 
 drivers/net/ethernet/sun/niu.c                               |    3 
 drivers/nfc/nfcsim.c                                         |    3 
 fs/btrfs/compression.c                                       |    2 
 fs/btrfs/volumes.c                                           |    1 
 fs/cifs/file.c                                               |    2 
 fs/io_uring.c                                                |    2 
 fs/ocfs2/file.c                                              |  103 +++---
 fs/pipe.c                                                    |   10 
 include/linux/bpf_types.h                                    |    1 
 include/linux/bpf_verifier.h                                 |   11 
 include/linux/filter.h                                       |   15 
 include/linux/skmsg.h                                        |    1 
 include/net/llc_pdu.h                                        |   31 +
 kernel/bpf/core.c                                            |   19 +
 kernel/bpf/disasm.c                                          |   16 
 kernel/bpf/verifier.c                                        |  186 +++--------
 net/can/j1939/transport.c                                    |   11 
 net/can/raw.c                                                |   20 +
 net/core/skmsg.c                                             |    3 
 net/ipv4/ip_tunnel.c                                         |    2 
 net/llc/af_llc.c                                             |   10 
 net/llc/llc_s_ac.c                                           |    2 
 net/mac80211/cfg.c                                           |   19 +
 net/mac80211/ieee80211_i.h                                   |    2 
 net/mac80211/mlme.c                                          |    4 
 net/netfilter/nf_conntrack_core.c                            |    7 
 net/netfilter/nft_nat.c                                      |    4 
 net/qrtr/qrtr.c                                              |    6 
 net/sctp/input.c                                             |    2 
 net/tipc/crypto.c                                            |   14 
 net/tipc/socket.c                                            |   30 +
 net/wireless/scan.c                                          |    6 
 tools/perf/util/map.c                                        |    2 
 tools/testing/selftests/vm/userfaultfd.c                     |    2 
 virt/kvm/kvm_main.c                                          |   28 +
 83 files changed, 707 insertions(+), 367 deletions(-)

Arkadiusz Kubalewski (2):
      i40e: Fix logic of disabling queues
      i40e: Fix firmware LLDP agent related warning

Arnaldo Carvalho de Melo (1):
      Revert "perf map: Fix dso->nsinfo refcounting"

Bjorn Andersson (1):
      drm/msm/dp: Initialize the INTF_CONFIG register

Cong Wang (1):
      skmsg: Make sk_psock_destroy() static

Dale Zhao (1):
      drm/amd/display: ensure dentist display clock update finished in DCN20

Dan Carpenter (1):
      can: hi311x: fix a signedness bug in hi3110_cmd()

Daniel Borkmann (4):
      bpf: Introduce BPF nospec instruction for mitigating Spectre v4
      bpf: Fix leakage due to insufficient speculative store bypass mitigation
      bpf: Remove superfluous aux sanitation on subprog rejection
      bpf: Fix pointer arithmetic mask tightening under state pruning

Desmond Cheong Zhi Xi (1):
      btrfs: fix rw device counting in __btrfs_free_extra_devids

Dima Chumak (1):
      net/mlx5e: Fix nullptr in mlx5e_hairpin_get_mdev()

Felix Fietkau (1):
      mac80211: fix enabling 4-address mode on a sta vif after assoc

Florian Westphal (1):
      netfilter: conntrack: adjust stop timestamp to real expiry value

Geetha sowjanya (1):
      octeontx2-pf: Fix interface down flag on error

Gilad Naaman (1):
      net: Set true network header for ECN decapsulation

Goldwyn Rodrigues (1):
      btrfs: mark compressed range uptodate only if all bio succeed

Greg Kroah-Hartman (2):
      selftest: fix build error in tools/testing/selftests/vm/userfaultfd.c
      Linux 5.10.56

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

Jiri Kosina (2):
      drm/amdgpu: Avoid printing of stack contents on firmware load error
      drm/amdgpu: Fix resource leak on probe error path

Juergen Gross (1):
      x86/kvm: fix vcpu-id indexed array sizes

Junxiao Bi (2):
      ocfs2: fix zero out valid data
      ocfs2: issue zeroout to EOF blocks

Krzysztof Kozlowski (1):
      nfc: nfcsim: fix use after free during module unload

Linus Torvalds (1):
      pipe: make pipe writes always wake up readers

Lorenz Bauer (2):
      bpf: Fix OOB read when printing XDP link fdinfo
      bpf: verifier: Allocate idmap scratch in verifier env

Lukasz Cieplicki (1):
      i40e: Add additional info to PHY type error

Maor Gottlieb (1):
      net/mlx5: Fix flow table chaining

Marcelo Ricardo Leitner (1):
      sctp: fix return value check in __sctp_rcv_asconf_lookup

Mike Rapoport (1):
      alpha: register early reserved memory in memblock

Naresh Kumar PBS (1):
      RDMA/bnxt_re: Fix stats counters

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

Pavel Skripkin (6):
      can: mcba_usb_start(): add missing urb->transfer_dma initialization
      can: usb_8dev: fix memory leak
      can: ems_usb: fix memory leak
      can: esd_usb2: fix memory leak
      net: qrtr: fix memory leaks
      net: llc: fix skb_over_panic

Robert Foss (1):
      drm/msm/dpu: Fix sm8250_mdp register length

Shannon Nelson (3):
      ionic: remove intr coalesce update from napi
      ionic: fix up dim accounting for tx and rx
      ionic: count csum_none when offload enabled

Srikar Dronamraju (1):
      powerpc/pseries: Fix regression while building external modules

Srinivas Pandruvada (1):
      ACPI: DPTF: Fix reading of attributes

Stephane Grosjean (1):
      can: peak_usb: pcan_usb_handle_bus_evt(): fix reading rxerr/txerr values

Steve French (1):
      SMB3: fix readpage for large swap cache

Tejun Heo (1):
      blk-iocost: fix operation ordering in iocg_wake_fn()

Vitaly Kuznetsov (1):
      KVM: x86: Check the right feature bit for MSR_KVM_ASYNC_PF_ACK access

Wang Hai (2):
      tulip: windbond-840: Fix missing pci_disable_device() in probe and remove
      sis900: Fix missing pci_disable_device() in probe and remove

Xin Long (2):
      tipc: fix implicit-connect for SYN+
      tipc: do not write skb_shinfo frags when doing decrytion

Yang Yingliang (1):
      io_uring: fix null-ptr-deref in io_sq_offload_start()

Zhang Changzhong (1):
      can: j1939: j1939_xtp_rx_dat_one(): fix rxtimer value between consecutive TP.DT to 750ms

Ziyang Xuan (1):
      can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF

