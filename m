Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579743DD8D7
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhHBNzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235839AbhHBNy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:54:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEB6A60EBB;
        Mon,  2 Aug 2021 13:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912367;
        bh=z/P6boWjCh18Vuhu8/ZqliiIjaIa1UPxY0wRJCyAFzY=;
        h=From:To:Cc:Subject:Date:From;
        b=GMmBpaw3yNjLD1f3U3yGCq8EvTJm+mRqM6dB+CX4kVadfBV/xvYvB+NL9EKNG+x7K
         +ravFRla94Aca7KQWYUBEOWSunMFuiQjF9U6gCzoQjZTILrKCDWRk0ZWmvZrMvPP4O
         W262/vHPN79FuZ+TPK90uQ7yULmqyHhFJD7WdkbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/67] 5.10.56-rc1 review
Date:   Mon,  2 Aug 2021 15:44:23 +0200
Message-Id: <20210802134339.023067817@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.56-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.56-rc1
X-KernelTest-Deadline: 2021-08-04T13:43+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.56 release.
There are 67 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.56-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.56-rc1

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: j1939_session_deactivate(): clarify lifetime of session object

Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
    i40e: Add additional info to PHY type error

Arnaldo Carvalho de Melo <acme@redhat.com>
    Revert "perf map: Fix dso->nsinfo refcounting"

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc/pseries: Fix regression while building external modules

Steve French <stfrench@microsoft.com>
    SMB3: fix readpage for large swap cache

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix pointer arithmetic mask tightening under state pruning

Lorenz Bauer <lmb@cloudflare.com>
    bpf: verifier: Allocate idmap scratch in verifier env

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Remove superfluous aux sanitation on subprog rejection

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix leakage due to insufficient speculative store bypass mitigation

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Introduce BPF nospec instruction for mitigating Spectre v4

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

Cong Wang <cong.wang@bytedance.com>
    skmsg: Make sk_psock_destroy() static

Bjorn Andersson <bjorn.andersson@linaro.org>
    drm/msm/dp: Initialize the INTF_CONFIG register

Robert Foss <robert.foss@linaro.org>
    drm/msm/dpu: Fix sm8250_mdp register length

Pavel Skripkin <paskripkin@gmail.com>
    net: llc: fix skb_over_panic

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Check the right feature bit for MSR_KVM_ASYNC_PF_ACK access

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    mlx4: Fix missing error code in mlx4_load_one()

Geetha sowjanya <gakula@marvell.com>
    octeontx2-pf: Fix interface down flag on error

Xin Long <lucien.xin@gmail.com>
    tipc: do not write skb_shinfo frags when doing decrytion

Shannon Nelson <snelson@pensando.io>
    ionic: count csum_none when offload enabled

Shannon Nelson <snelson@pensando.io>
    ionic: fix up dim accounting for tx and rx

Shannon Nelson <snelson@pensando.io>
    ionic: remove intr coalesce update from napi

Pavel Skripkin <paskripkin@gmail.com>
    net: qrtr: fix memory leaks

Gilad Naaman <gnaaman@drivenets.com>
    net: Set true network header for ECN decapsulation

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix sleeping in tipc accept routine

Xin Long <lucien.xin@gmail.com>
    tipc: fix implicit-connect for SYN+

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

Felix Fietkau <nbd@nbd.name>
    mac80211: fix enabling 4-address mode on a sta vif after assoc

Lorenz Bauer <lmb@cloudflare.com>
    bpf: Fix OOB read when printing XDP link fdinfo

Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
    RDMA/bnxt_re: Fix stats counters

Nguyen Dinh Phi <phind.uet@gmail.com>
    cfg80211: Fix possible memory leak in function cfg80211_bss_update

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: nfcsim: fix use after free during module unload

Tejun Heo <tj@kernel.org>
    blk-iocost: fix operation ordering in iocg_wake_fn()

Jiri Kosina <jkosina@suse.cz>
    drm/amdgpu: Fix resource leak on probe error path

Jiri Kosina <jkosina@suse.cz>
    drm/amdgpu: Avoid printing of stack contents on firmware load error

Dale Zhao <dale.zhao@amd.com>
    drm/amd/display: ensure dentist display clock update finished in DCN20

Paul Jakma <paul@jakma.org>
    NIU: fix incorrect error return, missed in previous revert

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Re-enable touch by default for Cintiq 24HDT / 27QHDT

Mike Rapoport <rppt@kernel.org>
    alpha: register early reserved memory in memblock

Pavel Skripkin <paskripkin@gmail.com>
    can: esd_usb2: fix memory leak

Pavel Skripkin <paskripkin@gmail.com>
    can: ems_usb: fix memory leak

Pavel Skripkin <paskripkin@gmail.com>
    can: usb_8dev: fix memory leak

Pavel Skripkin <paskripkin@gmail.com>
    can: mcba_usb_start(): add missing urb->transfer_dma initialization

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: pcan_usb_handle_bus_evt(): fix reading rxerr/txerr values

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

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    ACPI: DPTF: Fix reading of attributes

Hui Wang <hui.wang@canonical.com>
    Revert "ACPI: resources: Add checks for ACPI IRQ override"

Goldwyn Rodrigues <rgoldwyn@suse.de>
    btrfs: mark compressed range uptodate only if all bio succeed

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    btrfs: fix rw device counting in __btrfs_free_extra_devids

Linus Torvalds <torvalds@linux-foundation.org>
    pipe: make pipe writes always wake up readers

Jan Kiszka <jan.kiszka@siemens.com>
    x86/asm: Ensure asm/proto.h can be included stand-alone

Yang Yingliang <yangyingliang@huawei.com>
    io_uring: fix null-ptr-deref in io_sq_offload_start()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/kernel/setup.c                          |  13 +-
 arch/arm/net/bpf_jit_32.c                          |   3 +
 arch/arm64/net/bpf_jit_comp.c                      |  13 ++
 arch/mips/net/ebpf_jit.c                           |   3 +
 arch/powerpc/net/bpf_jit_comp64.c                  |   6 +
 arch/powerpc/platforms/pseries/setup.c             |   2 +-
 arch/riscv/net/bpf_jit_comp32.c                    |   4 +
 arch/riscv/net/bpf_jit_comp64.c                    |   4 +
 arch/s390/net/bpf_jit_comp.c                       |   5 +
 arch/sparc/net/bpf_jit_comp_64.c                   |   3 +
 arch/x86/include/asm/proto.h                       |   2 +
 arch/x86/kvm/ioapic.c                              |   2 +-
 arch/x86/kvm/ioapic.h                              |   4 +-
 arch/x86/kvm/x86.c                                 |   4 +-
 arch/x86/net/bpf_jit_comp.c                        |   7 +
 arch/x86/net/bpf_jit_comp32.c                      |   6 +
 block/blk-iocost.c                                 |  11 +-
 drivers/acpi/dptf/dptf_pch_fivr.c                  |  51 +++++-
 drivers/acpi/resource.c                            |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   8 +-
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c             |   7 +-
 .../amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c   |   2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c     |   2 +-
 drivers/gpu/drm/msm/dp/dp_catalog.c                |   1 +
 drivers/hid/wacom_wac.c                            |   2 +-
 drivers/infiniband/hw/bnxt_re/main.c               |   4 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |  10 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.h          |   1 +
 drivers/net/can/spi/hi311x.c                       |   2 +-
 drivers/net/can/usb/ems_usb.c                      |  14 +-
 drivers/net/can/usb/esd_usb2.c                     |  16 +-
 drivers/net/can/usb/mcba_usb.c                     |   2 +
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  10 +-
 drivers/net/can/usb/usb_8dev.c                     |  15 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c       |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  61 ++++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  50 ++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |   2 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   7 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   5 +
 drivers/net/ethernet/mellanox/mlx4/main.c          |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  33 +++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  10 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  14 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |  41 +++--
 drivers/net/ethernet/sis/sis900.c                  |   7 +-
 drivers/net/ethernet/sun/niu.c                     |   3 +-
 drivers/nfc/nfcsim.c                               |   3 +-
 fs/btrfs/compression.c                             |   2 +-
 fs/btrfs/volumes.c                                 |   1 +
 fs/cifs/file.c                                     |   2 +-
 fs/io_uring.c                                      |   2 +-
 fs/ocfs2/file.c                                    | 103 +++++++-----
 fs/pipe.c                                          |  10 +-
 include/linux/bpf_types.h                          |   1 +
 include/linux/bpf_verifier.h                       |  11 +-
 include/linux/filter.h                             |  15 ++
 include/linux/skmsg.h                              |   1 -
 include/net/llc_pdu.h                              |  31 +++-
 kernel/bpf/core.c                                  |  19 ++-
 kernel/bpf/disasm.c                                |  16 +-
 kernel/bpf/verifier.c                              | 186 +++++++--------------
 net/can/j1939/transport.c                          |  11 +-
 net/can/raw.c                                      |  20 ++-
 net/core/skmsg.c                                   |   3 +-
 net/ipv4/ip_tunnel.c                               |   2 +-
 net/llc/af_llc.c                                   |  10 +-
 net/llc/llc_s_ac.c                                 |   2 +-
 net/mac80211/cfg.c                                 |  19 +++
 net/mac80211/ieee80211_i.h                         |   2 +
 net/mac80211/mlme.c                                |   4 +-
 net/netfilter/nf_conntrack_core.c                  |   7 +-
 net/netfilter/nft_nat.c                            |   4 +-
 net/qrtr/qrtr.c                                    |   6 +-
 net/sctp/input.c                                   |   2 +-
 net/tipc/crypto.c                                  |  14 +-
 net/tipc/socket.c                                  |  30 ++--
 net/wireless/scan.c                                |   6 +-
 tools/perf/util/map.c                              |   2 -
 virt/kvm/kvm_main.c                                |  28 ++++
 82 files changed, 707 insertions(+), 367 deletions(-)


