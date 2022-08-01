Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CB25868F9
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiHALzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbiHALyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:54:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0792139BA7;
        Mon,  1 Aug 2022 04:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 623DACE13B8;
        Mon,  1 Aug 2022 11:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2371DC433C1;
        Mon,  1 Aug 2022 11:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354654;
        bh=Wtl4SQd3P1si710x0l+gZbM6UjJW72cNSjGWNZKoDxY=;
        h=From:To:Cc:Subject:Date:From;
        b=1lOv+TilIvkynfeWV/4Iu4CvLpkqLpqODBCRk9eurVZNPG/+SZH1EAaBA+FkwRspw
         RYEwIiqf7cwPozQ3V7F1//406hkq9QFNNlvbC18DuTj9sRxCKz6h02Dteo51qpQDpI
         +kpwjUT0joukuOL/KnLeuA628XnAdnYx8gjJiRAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/65] 5.10.135-rc1 review
Date:   Mon,  1 Aug 2022 13:46:17 +0200
Message-Id: <20220801114133.641770326@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.135-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.135-rc1
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

This is the start of the stable review cycle for the 5.10.135 release.
There are 65 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.135-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.135-rc1

Tianchen Ding <dtcccc@linux.alibaba.com>
    selftests: bpf: Don't run sk_lookup in verifier tests

Tianchen Ding <dtcccc@linux.alibaba.com>
    bpf: Add PROG_TEST_RUN support for sk_lookup programs

Tianchen Ding <dtcccc@linux.alibaba.com>
    bpf: Consolidate shared test timing code

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    x86/bugs: Do not enable IBPB at firmware entry when IBPB is not available

Dave Chinner <dchinner@redhat.com>
    xfs: Enforce attr3 buffer recovery order

Dave Chinner <dchinner@redhat.com>
    xfs: logging the on disk inode LSN can make it go backwards

Brian Foster <bfoster@redhat.com>
    xfs: remove dead stale buf unpin handling code

Brian Foster <bfoster@redhat.com>
    xfs: hold buffer across unpin and potential shutdown processing

Darrick J. Wong <djwong@kernel.org>
    xfs: force the log offline when log intent item recovery fails

Darrick J. Wong <djwong@kernel.org>
    xfs: fix log intent recovery ENOSPC shutdowns when inactivating inodes

Darrick J. Wong <djwong@kernel.org>
    xfs: prevent UAF in xfs_log_item_in_current_chkpt

Dave Chinner <dchinner@redhat.com>
    xfs: xfs_log_force_lsn isn't passed a LSN

Christoph Hellwig <hch@lst.de>
    xfs: refactor xfs_file_fsync

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    docs/kernel-parameters: Update descriptions for "mitigations=" param with retbleed

Toshi Kani <toshi.kani@hpe.com>
    EDAC/ghes: Set the DIMM label unconditionally

Florian Fainelli <f.fainelli@gmail.com>
    ARM: 9216/1: Fix MAX_DMA_ADDRESS overflow

Wei Mingzhi <whistler@member.fsf.org>
    mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.

Jaewon Kim <jaewon31.kim@samsung.com>
    page_alloc: fix invalid watermark check on a negative value

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ARM: crypto: comment out gcc warning that breaks clang builds

Xin Long <lucien.xin@gmail.com>
    sctp: leave the err path free in sctp_stream_init to sctp_stream_free

Alejandro Lucero <alejandro.lucero-palau@amd.com>
    sfc: disable softirqs for ptp TX

Leo Yan <leo.yan@linaro.org>
    perf symbol: Correct address for bss symbols

Jason Wang <jasowang@redhat.com>
    virtio-net: fix the race between refill work and close

Florian Westphal <fw@strlen.de>
    netfilter: nf_queue: do not allow packet truncation below transport header offset

Duoming Zhou <duoming@zju.edu.cn>
    sctp: fix sleep in atomic context bug in timer handlers

Michal Maloszewski <michal.maloszewski@intel.com>
    i40e: Fix interface init with MSI interrupts (no MSI-X)

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_reflect_tos.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_comp_sack_nr.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_comp_sack_slack_ns.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_comp_sack_delay_ns.

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
    tcp: Fix a data-race around sysctl_tcp_min_tso_segs.

Liang He <windhl@126.com>
    net: sungem_phy: Add of_node_put() for reference returned by of_get_parent()

Kuniyuki Iwashima <kuniyu@amazon.com>
    igmp: Fix data-races around sysctl_igmp_qrv.

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/tls: Remove the context from the list in tls_device_down

Ziyang Xuan <william.xuanziyang@huawei.com>
    ipv6/addrconf: fix a null-ptr-deref bug for ip6_ptr

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: ping6: Fix memleak in ipv6_renew_options().

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_challenge_ack_limit.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_limit_output_bytes.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_moderate_rcvbuf.

Wei Wang <weiwan@google.com>
    Revert "tcp: change pingpong threshold to 3"

Liang He <windhl@126.com>
    scsi: ufs: host: Hold reference returned by of_parse_phandle()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: do not setup vlan for loopback VSI

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: check (DD | EOF) bits on Rx descriptor rather than (EOP | RS)

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

Alistair Popple <apopple@nvidia.com>
    nouveau/svm: Fix to migrate all requested pages

Harald Freudenberger <freude@linux.ibm.com>
    s390/archrandom: prevent CPACF trng invocations in interrupt context

ChenXiaoSong <chenxiaosong2@huawei.com>
    ntfs: fix use-after-free in ntfs_ucsncmp()

Junxiao Bi <ocfs2-devel@oss.oracle.com>
    Revert "ocfs2: mount shared volume without ha stack"

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   2 +
 Documentation/networking/ip-sysctl.rst             |   9 +-
 Makefile                                           |   4 +-
 arch/arm/include/asm/dma.h                         |   2 +-
 arch/arm/lib/xor-neon.c                            |   3 +-
 arch/s390/include/asm/archrandom.h                 |   9 +-
 arch/x86/kernel/cpu/bugs.c                         |   1 +
 drivers/edac/ghes_edac.c                           |  11 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c             |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   4 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   3 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   8 +-
 drivers/net/ethernet/sfc/ptp.c                     |  22 ++
 drivers/net/macsec.c                               |  33 ++-
 drivers/net/sungem_phy.c                           |   1 +
 drivers/net/virtio_net.c                           |  37 +++-
 drivers/net/wireless/mediatek/mt7601u/usb.c        |   1 +
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  15 +-
 fs/ntfs/attrib.c                                   |   8 +-
 fs/ocfs2/ocfs2.h                                   |   4 +-
 fs/ocfs2/slot_map.c                                |  46 ++--
 fs/ocfs2/super.c                                   |  21 --
 fs/xfs/libxfs/xfs_log_format.h                     |  11 +-
 fs/xfs/libxfs/xfs_types.h                          |   1 +
 fs/xfs/xfs_buf_item.c                              |  60 ++---
 fs/xfs/xfs_buf_item_recover.c                      |   1 +
 fs/xfs/xfs_dquot_item.c                            |   2 +-
 fs/xfs/xfs_file.c                                  |  81 ++++---
 fs/xfs/xfs_inode.c                                 |  10 +-
 fs/xfs/xfs_inode_item.c                            |   4 +-
 fs/xfs/xfs_inode_item.h                            |   2 +-
 fs/xfs/xfs_inode_item_recover.c                    |  39 +++-
 fs/xfs/xfs_log.c                                   |  30 +--
 fs/xfs/xfs_log.h                                   |   4 +-
 fs/xfs/xfs_log_cil.c                               |  32 +--
 fs/xfs/xfs_log_priv.h                              |  15 +-
 fs/xfs/xfs_log_recover.c                           |   5 +-
 fs/xfs/xfs_mount.c                                 |  10 +-
 fs/xfs/xfs_trans.c                                 |   6 +-
 fs/xfs/xfs_trans.h                                 |   4 +-
 include/linux/bpf.h                                |  10 +
 include/net/addrconf.h                             |   3 +
 include/net/bluetooth/l2cap.h                      |   1 +
 include/net/inet_connection_sock.h                 |  10 +-
 include/net/tcp.h                                  |   2 +-
 include/uapi/linux/bpf.h                           |   5 +-
 kernel/watch_queue.c                               |  58 +++--
 mm/page_alloc.c                                    |  12 +-
 net/bluetooth/l2cap_core.c                         |  61 ++++--
 net/bpf/test_run.c                                 | 243 +++++++++++++++------
 net/core/filter.c                                  |   1 +
 net/ipv4/igmp.c                                    |  24 +-
 net/ipv4/tcp.c                                     |   2 +-
 net/ipv4/tcp_input.c                               |  24 +-
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv4/tcp_metrics.c                             |  10 +-
 net/ipv4/tcp_output.c                              |  19 +-
 net/ipv6/ping.c                                    |   6 +
 net/ipv6/tcp_ipv6.c                                |   4 +-
 net/mptcp/protocol.c                               |   2 +-
 net/netfilter/nfnetlink_queue.c                    |   7 +-
 net/sctp/associola.c                               |   5 +-
 net/sctp/stream.c                                  |  19 +-
 net/sctp/stream_sched.c                            |   2 +-
 net/tls/tls_device.c                               |   7 +-
 tools/include/uapi/linux/bpf.h                     |   5 +-
 tools/perf/util/symbol-elf.c                       |  45 +++-
 tools/testing/selftests/bpf/test_verifier.c        |   4 +-
 .../testing/selftests/bpf/verifier/ctx_sk_lookup.c |   1 +
 69 files changed, 755 insertions(+), 408 deletions(-)


