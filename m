Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D523DD964
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbhHBOAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235214AbhHBN5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:57:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 331FB60F41;
        Mon,  2 Aug 2021 13:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912502;
        bh=kqKB3KoJIwDnCX+kZjAEbxnDRcnDiiTcsNMgHo3cDaY=;
        h=From:To:Cc:Subject:Date:From;
        b=S6ijHeJTdgv9XvAvzwDsOC+VLQXUvOPLFUiz7nloya8VkYnmBmgXrjQmvphWdLhgJ
         anNr2UEB2xLSjIzQqzh1XRDVje6nYhqT0R7LmHCOwHoJPaNEibbBpK8623ttTE5R9A
         pp2nZCqCATMP7xzfe5NNMjsahqhWT8S26MJsDhiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.13 000/104] 5.13.8-rc1 review
Date:   Mon,  2 Aug 2021 15:43:57 +0200
Message-Id: <20210802134344.028226640@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.8-rc1
X-KernelTest-Deadline: 2021-08-04T13:43+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.13.8 release.
There are 104 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.13.8-rc1

Sunil Goutham <sgoutham@marvell.com>
    octeontx2-af: Remove unnecessary devm_kfree

John Garry <john.garry@huawei.com>
    perf pmu: Fix alias matching

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: j1939_session_deactivate(): clarify lifetime of session object

Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
    i40e: Add additional info to PHY type error

Jens Axboe <axboe@kernel.dk>
    io_uring: fix race in unified task_work running

Arnaldo Carvalho de Melo <acme@redhat.com>
    Revert "perf map: Fix dso->nsinfo refcounting"

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc/pseries: Fix regression while building external modules

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/vdso: Don't use r30 to avoid breaking Go lang

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

Christoph Hellwig <hch@lst.de>
    block: delay freeing the gendisk

Chris Mi <cmi@nvidia.com>
    net/mlx5: Fix mlx5_vport_tbl_attr chain from u16 to u32

Dima Chumak <dchumak@nvidia.com>
    net/mlx5e: Fix nullptr in mlx5e_hairpin_get_mdev()

Aya Levin <ayal@nvidia.com>
    net/mlx5: Unload device upon firmware fatal error

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix page allocation failure for ptp-RQ over SF

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix page allocation failure for trap-RQ over SF

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Add NETIF_F_HW_TC to hw_features when HTB offload is available

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5e: RX, Avoid possible data corruption when relaxed ordering and LRO combined

Roi Dayan <roid@nvidia.com>
    net/mlx5: E-Switch, handle devcom events only for ports on the same device

Maor Dickman <maord@nvidia.com>
    net/mlx5: E-Switch, Set destination vport vhca id only when merged eswitch is supported

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Disable Rx ntuple offload for uplink representor

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix flow table chaining

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Zap ingress queues after stopping strparser

David Matlack <dmatlack@google.com>
    KVM: selftests: Fix missing break in dirty_log_perf_test arg parsing

Bjorn Andersson <bjorn.andersson@linaro.org>
    drm/msm/dp: Initialize the INTF_CONFIG register

Kuogee Hsieh <khsieh@codeaurora.org>
    drm/msm/dp: use dp_ctrl_off_link_stream during PHY compliance test run

Robert Foss <robert.foss@linaro.org>
    drm/msm/dpu: Fix sm8250_mdp register length

Pavel Skripkin <paskripkin@gmail.com>
    net: llc: fix skb_over_panic

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Check the right feature bit for MSR_KVM_ASYNC_PF_ACK access

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/i915/bios: Fix ports mask

Jagan Teki <jagan@amarulasolutions.com>
    drm/panel: panel-simple: Fix proper bpc for ytc700tlag_05_201c

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    mlx4: Fix missing error code in mlx4_load_one()

Kevin Lo <kevlo@kevlo.org>
    net: phy: broadcom: re-add check for PHY_BRCM_DIS_TXCRXC_NOENRGY on the BCM54811 PHY

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-pf: Dont enable backpressure on LBK links

Geetha sowjanya <gakula@marvell.com>
    octeontx2-pf: Fix interface down flag on error

Xin Long <lucien.xin@gmail.com>
    tipc: do not write skb_shinfo frags when doing decrytion

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_irq(): stop timestamping worker in case error in IRQ

Shannon Nelson <snelson@pensando.io>
    ionic: count csum_none when offload enabled

Shannon Nelson <snelson@pensando.io>
    ionic: fix up dim accounting for tx and rx

Shannon Nelson <snelson@pensando.io>
    ionic: remove intr coalesce update from napi

Shannon Nelson <snelson@pensando.io>
    ionic: catch no ptp support earlier

Shannon Nelson <snelson@pensando.io>
    ionic: make all rx_mode work threadsafe

Pavel Skripkin <paskripkin@gmail.com>
    net: qrtr: fix memory leaks

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    loop: reintroduce global lock for safe loop_validate_file() traversal

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: silently accept the deletion of VID 0 too

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

Dongliang Mu <mudongliangabcd@gmail.com>
    netfilter: nf_tables: fix audit memory leak in nf_tables_commit

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix memory leak in error path code

Yang Yingliang <yangyingliang@huawei.com>
    platform/x86: amd-pmc: Fix missing unlock on error in amd_pmc_send_cmd()

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86: amd-pmc: Fix SMU firmware reporting mechanism

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86: amd-pmc: Fix command completion code

Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
    RDMA/bnxt_re: Fix stats counters

Nguyen Dinh Phi <phind.uet@gmail.com>
    cfg80211: Fix possible memory leak in function cfg80211_bss_update

Hao Xu <haoxu@linux.alibaba.com>
    io_uring: fix poll requests leaking second poll entries

Jens Axboe <axboe@kernel.dk>
    io_uring: don't block level reissue off completion path

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix io_prep_async_link locking

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: nfcsim: fix use after free during module unload

Tejun Heo <tj@kernel.org>
    blk-iocost: fix operation ordering in iocg_wake_fn()

Jiri Kosina <jkosina@suse.cz>
    drm/amdgpu: Fix resource leak on probe error path

Jiri Kosina <jkosina@suse.cz>
    drm/amdgpu: Avoid printing of stack contents on firmware load error

Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>
    drm/amdgpu: Check pmops for desired suspend state

Dale Zhao <dale.zhao@amd.com>
    drm/amd/display: ensure dentist display clock update finished in DCN20

Paul Jakma <paul@jakma.org>
    NIU: fix incorrect error return, missed in previous revert

Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
    net: stmmac: add est_irq_status callback function for GMAC 4.10 and 5.10

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

Wang Hai <wanghai38@huawei.com>
    mm/memcg: fix NULL pointer dereference in memcg_slab_free_hook()

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcontrol: fix blocking rstat function called from atomic cgroup1 thresholding code

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

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost inode on log replay after mix of fsync, rename and inode eviction

Javier Pello <javier.pello@urjc.es>
    fs/ext2: Avoid page_address on pages returned by ext2_get_page

Linus Torvalds <torvalds@linux-foundation.org>
    pipe: make pipe writes always wake up readers


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/kernel/setup.c                          |  13 +-
 arch/arm/net/bpf_jit_32.c                          |   3 +
 arch/arm64/net/bpf_jit_comp.c                      |  13 ++
 arch/mips/net/ebpf_jit.c                           |   3 +
 arch/powerpc/kernel/vdso64/Makefile                |   7 +
 arch/powerpc/net/bpf_jit_comp32.c                  |   6 +
 arch/powerpc/net/bpf_jit_comp64.c                  |   6 +
 arch/powerpc/platforms/pseries/setup.c             |   2 +-
 arch/riscv/net/bpf_jit_comp32.c                    |   4 +
 arch/riscv/net/bpf_jit_comp64.c                    |   4 +
 arch/s390/net/bpf_jit_comp.c                       |   5 +
 arch/sparc/net/bpf_jit_comp_64.c                   |   3 +
 arch/x86/kvm/ioapic.c                              |   2 +-
 arch/x86/kvm/ioapic.h                              |   4 +-
 arch/x86/kvm/x86.c                                 |   4 +-
 arch/x86/net/bpf_jit_comp.c                        |   7 +
 arch/x86/net/bpf_jit_comp32.c                      |   6 +
 block/blk-iocost.c                                 |  11 +-
 block/genhd.c                                      |   3 +-
 drivers/acpi/dptf/dptf_pch_fivr.c                  |  51 +++++-
 drivers/acpi/resource.c                            |   9 +-
 drivers/block/loop.c                               | 128 +++++++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   8 +-
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c             |   7 +-
 .../amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c   |   2 +-
 drivers/gpu/drm/i915/display/intel_bios.c          |   3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c     |   2 +-
 drivers/gpu/drm/msm/dp/dp_catalog.c                |   1 +
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |   2 +-
 drivers/gpu/drm/panel/panel-simple.c               |   2 +-
 drivers/hid/wacom_wac.c                            |   2 +-
 drivers/infiniband/hw/bnxt_re/main.c               |   4 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |  10 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.h          |   1 +
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  27 +--
 drivers/net/can/spi/hi311x.c                       |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   1 +
 drivers/net/can/usb/ems_usb.c                      |  14 +-
 drivers/net/can/usb/esd_usb2.c                     |  16 +-
 drivers/net/can/usb/mcba_usb.c                     |   2 +
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  10 +-
 drivers/net/can/usb/usb_8dev.c                     |  15 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c       |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  61 ++++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  50 ++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |   2 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   1 -
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  14 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   7 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   5 +
 drivers/net/ethernet/mellanox/mlx4/main.c          |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  34 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  33 +++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  12 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    | 197 ++++++++++-----------
 drivers/net/ethernet/pensando/ionic/ionic_lif.h    |  11 +-
 drivers/net/ethernet/pensando/ionic/ionic_phc.c    |  10 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |  41 +++--
 drivers/net/ethernet/sis/sis900.c                  |   7 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +
 drivers/net/ethernet/sun/niu.c                     |   3 +-
 drivers/net/phy/broadcom.c                         |   2 +-
 drivers/nfc/nfcsim.c                               |   3 +-
 drivers/platform/x86/amd-pmc.c                     |  50 ++++--
 fs/block_dev.c                                     |   2 +
 fs/btrfs/compression.c                             |   2 +-
 fs/btrfs/tree-log.c                                |   4 +-
 fs/btrfs/volumes.c                                 |   1 +
 fs/cifs/file.c                                     |   2 +-
 fs/ext2/dir.c                                      |  12 +-
 fs/ext2/ext2.h                                     |   3 +-
 fs/ext2/namei.c                                    |   4 +-
 fs/io_uring.c                                      |  29 ++-
 fs/ocfs2/file.c                                    | 103 ++++++-----
 fs/pipe.c                                          |  10 +-
 include/linux/bpf_types.h                          |   1 +
 include/linux/bpf_verifier.h                       |  11 +-
 include/linux/filter.h                             |  15 ++
 include/net/llc_pdu.h                              |  31 +++-
 kernel/bpf/core.c                                  |  19 +-
 kernel/bpf/disasm.c                                |  16 +-
 kernel/bpf/verifier.c                              | 186 +++++++------------
 mm/memcontrol.c                                    |   3 +-
 mm/slab.h                                          |   2 +-
 net/can/j1939/transport.c                          |  11 +-
 net/can/raw.c                                      |  20 ++-
 net/core/skmsg.c                                   |   4 +-
 net/ipv4/ip_tunnel.c                               |   2 +-
 net/llc/af_llc.c                                   |  10 +-
 net/llc/llc_s_ac.c                                 |   2 +-
 net/mac80211/cfg.c                                 |  19 ++
 net/mac80211/ieee80211_i.h                         |   2 +
 net/mac80211/mlme.c                                |   4 +-
 net/netfilter/nf_conntrack_core.c                  |   7 +-
 net/netfilter/nf_tables_api.c                      |  12 ++
 net/netfilter/nft_nat.c                            |   4 +-
 net/qrtr/qrtr.c                                    |   6 +-
 net/sctp/input.c                                   |   2 +-
 net/tipc/crypto.c                                  |  14 +-
 net/tipc/socket.c                                  |  30 ++--
 net/wireless/scan.c                                |   6 +-
 tools/perf/util/map.c                              |   2 -
 tools/perf/util/pmu.c                              |  33 +++-
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |   1 +
 virt/kvm/kvm_main.c                                |  28 +++
 117 files changed, 1115 insertions(+), 597 deletions(-)


