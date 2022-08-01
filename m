Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4829586A19
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiHAMMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbiHAMLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:11:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5121B6E89C;
        Mon,  1 Aug 2022 04:57:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 305B0601CE;
        Mon,  1 Aug 2022 11:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EDAC433D6;
        Mon,  1 Aug 2022 11:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355019;
        bh=QEyf2QBUtvWNnyImhwuKGZd6dYCuBT6jUmlgh3C8VGg=;
        h=From:To:Cc:Subject:Date:From;
        b=rWBI9ZcF4jl3yGpIL3sxHBMJFeAo0AmA1cq3Af9i5Slrsh7y5TgQg2OyYkCO5buMd
         5uh686JJLFIY08OTq3VtSjM2BqVACHj7CXaJRwAHshxfTNKs0o+ZajMd/AZTTqlvr2
         FOUXsXShxcjhI5NMpDgYpgI9ZOnng7FeJs7iiakk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.18 00/88] 5.18.16-rc1 review
Date:   Mon,  1 Aug 2022 13:46:14 +0200
Message-Id: <20220801114138.041018499@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.18.16-rc1
X-KernelTest-Deadline: 2022-08-03T11:41+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.18.16 release.
There are 88 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.16-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.18.16-rc1

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    x86/bugs: Do not enable IBPB at firmware entry when IBPB is not available

Waiman Long <longman@redhat.com>
    locking/rwsem: Allow slowpath writer to ignore handoff bit if not set by first waiter

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    docs/kernel-parameters: Update descriptions for "mitigations=" param with retbleed

Sherry Sun <sherry.sun@nxp.com>
    EDAC/synopsys: Re-enable the error interrupts on v3 hw

Sherry Sun <sherry.sun@nxp.com>
    EDAC/synopsys: Use the correct register to disable the error interrupt on v3 hw

Toshi Kani <toshi.kani@hpe.com>
    EDAC/ghes: Set the DIMM label unconditionally

Florian Fainelli <f.fainelli@gmail.com>
    ARM: 9216/1: Fix MAX_DMA_ADDRESS overflow

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_workaround_signed_windows.

Jaewon Kim <jaewon31.kim@samsung.com>
    page_alloc: fix invalid watermark check on a negative value

Ralph Campbell <rcampbell@nvidia.com>
    mm/hmm: fault non-owner device private entries

Dan Carpenter <dan.carpenter@oracle.com>
    stmmac: dwmac-mediatek: fix resource leak in probe

Dimitris Michailidis <d.michailidis@fungible.com>
    net/funeth: Fix fun_xdp_tx() and XDP packet reclaim

Xin Long <lucien.xin@gmail.com>
    sctp: leave the err path free in sctp_stream_init to sctp_stream_free

Alejandro Lucero <alejandro.lucero-palau@amd.com>
    sfc: disable softirqs for ptp TX

Leo Yan <leo.yan@linaro.org>
    perf symbol: Correct address for bss symbols

Jason Wang <jasowang@redhat.com>
    virtio-net: fix the race between refill work and close

Geliang Tang <geliang.tang@suse.com>
    mptcp: don't send RST for single subflow

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Fix a race condition related to device management

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Support clearing multiple commands at once

Florian Westphal <fw@strlen.de>
    netfilter: nf_queue: do not allow packet truncation below transport header offset

Sunil Goutham <sgoutham@marvell.com>
    octeontx2-pf: cn10k: Fix egress ratelimit configuration

Duoming Zhou <duoming@zju.edu.cn>
    sctp: fix sleep in atomic context bug in timer handlers

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix reference counting for LAG FDBs

Michal Maloszewski <michal.maloszewski@intel.com>
    i40e: Fix interface init with MSI interrupts (no MSI-X)

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Fix data-races around sysctl_fib_notify_on_flag_change.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_reflect_tos.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_comp_sack_nr.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_comp_sack_slack_ns.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_comp_sack_delay_ns.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around sysctl_[rw]mem(_offset)?.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sk_pacing_rate.

Taehee Yoo <ap420073@gmail.com>
    net: mld: fix reference count leak in mld_{query | report}_work()

Jianglei Nie <niejianglei2021@163.com>
    net: macsec: fix potential resource leak in macsec_add_rxsa() and macsec_add_txsa()

Sabrina Dubroca <sd@queasysnail.net>
    macsec: always read MACSEC_SA_ATTR_PN as a u64

Sabrina Dubroca <sd@queasysnail.net>
    macsec: limit replay window size with XPN

Sabrina Dubroca <sd@queasysnail.net>
    macsec: fix error message in macsec_add_rxsa and _txsa

Sabrina Dubroca <sd@queasysnail.net>
    macsec: fix NULL deref in macsec_add_rxsa

Xin Long <lucien.xin@gmail.com>
    Documentation: fix sctp_wmem in ip-sysctl.rst

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_invalid_ratelimit.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_autocorking.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_min_rtt_wlen.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_tso_rtt_log.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_min_tso_segs.

Tom Rix <trix@redhat.com>
    mlxsw: spectrum_router: simplify list unwinding

Liang He <windhl@126.com>
    net: sungem_phy: Add of_node_put() for reference returned by of_get_parent()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: pcs: xpcs: propagate xpcs_read error to xpcs_get_state_c37_sgmii

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/tls: Remove the context from the list in tls_device_down

Ziyang Xuan <william.xuanziyang@huawei.com>
    ipv6/addrconf: fix a null-ptr-deref bug for ip6_ptr

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: ping6: Fix memleak in ipv6_renew_options().

David Jeffery <djeffery@redhat.com>
    scsi: mpt3sas: Stop fw fault watchdog work item during system shutdown

Jason Yan <yanaijie@huawei.com>
    scsi: core: Fix warning in scsi_alloc_sgtables()

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_challenge_ack_limit.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_limit_output_bytes.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_moderate_rcvbuf.

Eric Dumazet <edumazet@google.com>
    tcp: md5: fix IPv4-mapped support

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-pf: Fix UDP/TCP src and dst port tc filters

Wei Wang <weiwan@google.com>
    Revert "tcp: change pingpong threshold to 3"

Liang He <windhl@126.com>
    scsi: ufs: host: Hold reference returned by of_parse_phandle()

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Fix VSIs unable to share unicast MAC

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: do not setup vlan for loopback VSI

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: check (DD | EOF) bits on Rx descriptor rather than (EOP | RS)

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    ice: Fix max VLANs available for VF

Benjamin Poirier <bpoirier@nvidia.com>
    bridge: Do not send empty IFLA_AF_SPEC attribute

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_no_ssthresh_metrics_save.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_nometrics_save.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_frto.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_adv_win_scale.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_app_win.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_dsack.

Linus Torvalds <torvalds@linux-foundation.org>
    watch_queue: Fix missing locking in add_watch_to_object()

David Howells <dhowells@redhat.com>
    watch_queue: Fix missing rcu annotation

Nathan Chancellor <nathan@kernel.org>
    drm/simpledrm: Fix return type of simpledrm_simple_display_pipe_mode_valid()

Alistair Popple <apopple@nvidia.com>
    nouveau/svm: Fix to migrate all requested pages

Waiman Long <longman@redhat.com>
    intel_idle: Fix false positive RCU splats due to incorrect hardirqs state

Harald Freudenberger <freude@linux.ibm.com>
    s390/archrandom: prevent CPACF trng invocations in interrupt context

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    asm-generic: remove a broken and needless ifdef conditional

Miaohe Lin <linmiaohe@huawei.com>
    hugetlb: fix memoryleak in hugetlb_mcopy_atomic_pte

Muchun Song <songmuchun@bytedance.com>
    mm: fix missing wake-up event for FSDAX pages

Josef Bacik <josef@toxicpanda.com>
    mm: fix page leak with multiple threads mapping the same page

Mike Rapoport <rppt@kernel.org>
    secretmem: fix unhandled fault in truncate

Andrei Vagin <avagin@gmail.com>
    fs: sendfile handles O_NONBLOCK of out_fd

ChenXiaoSong <chenxiaosong2@huawei.com>
    ntfs: fix use-after-free in ntfs_ucsncmp()

Nadav Amit <namit@vmware.com>
    userfaultfd: provide properly masked address for huge-pages

Junxiao Bi <ocfs2-devel@oss.oracle.com>
    Revert "ocfs2: mount shared volume without ha stack"

Linus Walleij <linus.walleij@linaro.org>
    ARM: pxa2xx: Fix GPIO descriptor tables

Michael Walle <michael@walle.cc>
    ARM: dts: lan966x: fix sys_clk frequency

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put

Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
    Bluetooth: Always set event mask on suspend


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   2 +
 Documentation/networking/ip-sysctl.rst             |   9 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/lan966x.dtsi                     |   2 +-
 arch/arm/include/asm/dma.h                         |   2 +-
 arch/arm/mach-pxa/corgi.c                          |   2 +-
 arch/arm/mach-pxa/hx4700.c                         |   2 +-
 arch/arm/mach-pxa/icontrol.c                       |   4 +-
 arch/arm/mach-pxa/littleton.c                      |   2 +-
 arch/arm/mach-pxa/magician.c                       |   2 +-
 arch/arm/mach-pxa/spitz.c                          |   2 +-
 arch/arm/mach-pxa/z2.c                             |   4 +-
 arch/s390/include/asm/archrandom.h                 |   9 +-
 arch/x86/kernel/cpu/bugs.c                         |   1 +
 drivers/edac/ghes_edac.c                           |  11 ++-
 drivers/edac/synopsys_edac.c                       |  44 +++++----
 drivers/gpu/drm/nouveau/nouveau_dmem.c             |   6 +-
 drivers/gpu/drm/tiny/simpledrm.c                   |   2 +-
 drivers/idle/intel_idle.c                          |   8 +-
 drivers/net/ethernet/fungible/funeth/funeth_rx.c   |   5 +-
 drivers/net/ethernet/fungible/funeth/funeth_tx.c   |  20 ++--
 drivers/net/ethernet/fungible/funeth/funeth_txrx.h |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   4 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   3 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  10 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |  40 --------
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |   3 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   | 106 ++++++++++++++-------
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  20 ++--
 drivers/net/ethernet/sfc/ptp.c                     |  22 +++++
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |   9 +-
 drivers/net/macsec.c                               |  33 ++++---
 drivers/net/pcs/pcs-xpcs.c                         |   2 +-
 drivers/net/sungem_phy.c                           |   1 +
 drivers/net/virtio_net.c                           |  37 ++++++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   1 +
 drivers/scsi/scsi_ioctl.c                          |   2 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  15 ++-
 drivers/scsi/ufs/ufshcd.c                          |  98 +++++++++++++------
 fs/ntfs/attrib.c                                   |   8 +-
 fs/ocfs2/ocfs2.h                                   |   4 +-
 fs/ocfs2/slot_map.c                                |  46 ++++-----
 fs/ocfs2/super.c                                   |  21 ----
 fs/read_write.c                                    |   3 +
 fs/userfaultfd.c                                   |  12 ++-
 include/asm-generic/io.h                           |   2 -
 include/linux/mm.h                                 |  14 ++-
 include/net/addrconf.h                             |   3 +
 include/net/bluetooth/l2cap.h                      |   1 +
 include/net/inet_connection_sock.h                 |  10 +-
 include/net/sock.h                                 |   8 +-
 include/net/tcp.h                                  |   2 +-
 kernel/locking/rwsem.c                             |  30 ++++--
 kernel/watch_queue.c                               |  58 ++++++-----
 mm/gup.c                                           |   6 +-
 mm/hmm.c                                           |  19 ++--
 mm/hugetlb.c                                       |   1 +
 mm/memory.c                                        |   7 +-
 mm/memremap.c                                      |   6 +-
 mm/page_alloc.c                                    |  12 ++-
 mm/secretmem.c                                     |  33 +++++--
 net/bluetooth/hci_sync.c                           |   6 +-
 net/bluetooth/l2cap_core.c                         |  61 +++++++++---
 net/bridge/br_netlink.c                            |   8 +-
 net/decnet/af_decnet.c                             |   4 +-
 net/dsa/switch.c                                   |   1 +
 net/ipv4/fib_trie.c                                |   7 +-
 net/ipv4/tcp.c                                     |  23 +++--
 net/ipv4/tcp_input.c                               |  41 ++++----
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv4/tcp_metrics.c                             |  10 +-
 net/ipv4/tcp_output.c                              |  27 +++---
 net/ipv6/mcast.c                                   |  14 +--
 net/ipv6/ping.c                                    |   6 ++
 net/ipv6/tcp_ipv6.c                                |   4 +-
 net/mptcp/protocol.c                               |   8 +-
 net/mptcp/subflow.c                                |  10 +-
 net/netfilter/nfnetlink_queue.c                    |   7 +-
 net/sctp/associola.c                               |   5 +-
 net/sctp/stream.c                                  |  19 +---
 net/sctp/stream_sched.c                            |   2 +-
 net/tipc/socket.c                                  |   2 +-
 net/tls/tls_device.c                               |   7 +-
 tools/perf/util/symbol-elf.c                       |  45 ++++++++-
 84 files changed, 727 insertions(+), 455 deletions(-)


