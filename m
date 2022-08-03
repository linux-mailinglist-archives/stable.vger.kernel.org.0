Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8E0588A93
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 12:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbiHCKbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 06:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237638AbiHCKbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 06:31:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9BEB4A;
        Wed,  3 Aug 2022 03:30:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FB6E60B7E;
        Wed,  3 Aug 2022 10:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5936AC433D6;
        Wed,  3 Aug 2022 10:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659522609;
        bh=BUTY/ZE4rdLAgkqRzYs6PemlaaBpfWNR9K3mVNOrRoU=;
        h=From:To:Cc:Subject:Date:From;
        b=ndosvxEQKOAHUIMmcRfar4jTdXlrCfREWwvB1x2mQOm+gAF1FWAOIR67jsu4E0NHf
         yNWrXDOw2gyT+4vWUA2TbZFQV5dFLYS9uNjm55Di5G4SJcqaefWKIACv90oPwVId8k
         uzzt1o1kqA/gjMvtfr0ngIfB0X6aWJ9+KsJbckMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.59
Date:   Wed,  3 Aug 2022 12:30:02 +0200
Message-Id: <1659522603151223@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.59 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt      |    2 
 Documentation/networking/ip-sysctl.rst               |    9 +
 Makefile                                             |    2 
 arch/arm/include/asm/dma.h                           |    2 
 arch/arm/lib/xor-neon.c                              |    3 
 arch/s390/include/asm/archrandom.h                   |    9 +
 arch/x86/kernel/cpu/bugs.c                           |    1 
 drivers/edac/ghes_edac.c                             |   11 +
 drivers/gpu/drm/nouveau/nouveau_dmem.c               |    6 -
 drivers/gpu/drm/tiny/simpledrm.c                     |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c          |    4 
 drivers/net/ethernet/intel/ice/ice_ethtool.c         |    3 
 drivers/net/ethernet/intel/ice/ice_main.c            |    8 -
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c |  106 +++++++++++++------
 drivers/net/ethernet/sfc/ptp.c                       |   22 +++
 drivers/net/macsec.c                                 |   33 +++--
 drivers/net/pcs/pcs-xpcs.c                           |    2 
 drivers/net/sungem_phy.c                             |    1 
 drivers/net/virtio_net.c                             |   37 ++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                 |    1 
 drivers/scsi/scsi_ioctl.c                            |    2 
 drivers/scsi/ufs/ufshcd-pltfrm.c                     |   15 ++
 fs/ntfs/attrib.c                                     |    8 +
 fs/ocfs2/ocfs2.h                                     |    4 
 fs/ocfs2/slot_map.c                                  |   46 +++-----
 fs/ocfs2/super.c                                     |   21 ---
 fs/read_write.c                                      |    3 
 include/asm-generic/io.h                             |    2 
 include/net/addrconf.h                               |    3 
 include/net/bluetooth/l2cap.h                        |    1 
 include/net/inet_connection_sock.h                   |   10 -
 include/net/sock.h                                   |    8 -
 include/net/tcp.h                                    |    2 
 kernel/locking/rwsem.c                               |   30 +++--
 kernel/watch_queue.c                                 |   58 ++++++----
 mm/hmm.c                                             |   19 +--
 mm/hugetlb.c                                         |    1 
 mm/memory.c                                          |    7 -
 mm/page_alloc.c                                      |   12 +-
 mm/secretmem.c                                       |   33 ++++-
 net/bluetooth/l2cap_core.c                           |   61 ++++++++--
 net/decnet/af_decnet.c                               |    4 
 net/ipv4/fib_trie.c                                  |    7 -
 net/ipv4/igmp.c                                      |   24 ++--
 net/ipv4/tcp.c                                       |    8 -
 net/ipv4/tcp_input.c                                 |   41 +++----
 net/ipv4/tcp_ipv4.c                                  |    4 
 net/ipv4/tcp_metrics.c                               |   10 -
 net/ipv4/tcp_output.c                                |   21 +--
 net/ipv6/mcast.c                                     |   14 +-
 net/ipv6/ping.c                                      |    6 +
 net/ipv6/tcp_ipv6.c                                  |    4 
 net/mptcp/protocol.c                                 |    8 -
 net/netfilter/nfnetlink_queue.c                      |    7 +
 net/sctp/associola.c                                 |    5 
 net/sctp/stream.c                                    |   19 ---
 net/sctp/stream_sched.c                              |    2 
 net/tipc/socket.c                                    |    2 
 net/tls/tls_device.c                                 |    7 +
 tools/perf/util/symbol-elf.c                         |   45 +++++++-
 60 files changed, 546 insertions(+), 302 deletions(-)

Alejandro Lucero (1):
      sfc: disable softirqs for ptp TX

Alistair Popple (1):
      nouveau/svm: Fix to migrate all requested pages

Andrei Vagin (1):
      fs: sendfile handles O_NONBLOCK of out_fd

ChenXiaoSong (1):
      ntfs: fix use-after-free in ntfs_ucsncmp()

David Howells (1):
      watch_queue: Fix missing rcu annotation

David Jeffery (1):
      scsi: mpt3sas: Stop fw fault watchdog work item during system shutdown

Duoming Zhou (1):
      sctp: fix sleep in atomic context bug in timer handlers

Eiichi Tsukata (1):
      docs/kernel-parameters: Update descriptions for "mitigations=" param with retbleed

Florian Fainelli (1):
      ARM: 9216/1: Fix MAX_DMA_ADDRESS overflow

Florian Westphal (1):
      netfilter: nf_queue: do not allow packet truncation below transport header offset

Greg Kroah-Hartman (2):
      ARM: crypto: comment out gcc warning that breaks clang builds
      Linux 5.15.59

Harald Freudenberger (1):
      s390/archrandom: prevent CPACF trng invocations in interrupt context

Jaewon Kim (1):
      page_alloc: fix invalid watermark check on a negative value

Jason Wang (1):
      virtio-net: fix the race between refill work and close

Jason Yan (1):
      scsi: core: Fix warning in scsi_alloc_sgtables()

Jianglei Nie (1):
      net: macsec: fix potential resource leak in macsec_add_rxsa() and macsec_add_txsa()

Josef Bacik (1):
      mm: fix page leak with multiple threads mapping the same page

Junxiao Bi (1):
      Revert "ocfs2: mount shared volume without ha stack"

Kuniyuki Iwashima (22):
      tcp: Fix data-races around sysctl_tcp_dsack.
      tcp: Fix a data-race around sysctl_tcp_app_win.
      tcp: Fix a data-race around sysctl_tcp_adv_win_scale.
      tcp: Fix a data-race around sysctl_tcp_frto.
      tcp: Fix a data-race around sysctl_tcp_nometrics_save.
      tcp: Fix data-races around sysctl_tcp_no_ssthresh_metrics_save.
      tcp: Fix data-races around sysctl_tcp_moderate_rcvbuf.
      tcp: Fix a data-race around sysctl_tcp_limit_output_bytes.
      tcp: Fix a data-race around sysctl_tcp_challenge_ack_limit.
      net: ping6: Fix memleak in ipv6_renew_options().
      igmp: Fix data-races around sysctl_igmp_qrv.
      tcp: Fix a data-race around sysctl_tcp_min_tso_segs.
      tcp: Fix a data-race around sysctl_tcp_min_rtt_wlen.
      tcp: Fix a data-race around sysctl_tcp_autocorking.
      tcp: Fix a data-race around sysctl_tcp_invalid_ratelimit.
      tcp: Fix data-races around sk_pacing_rate.
      net: Fix data-races around sysctl_[rw]mem(_offset)?.
      tcp: Fix a data-race around sysctl_tcp_comp_sack_delay_ns.
      tcp: Fix a data-race around sysctl_tcp_comp_sack_slack_ns.
      tcp: Fix a data-race around sysctl_tcp_comp_sack_nr.
      tcp: Fix data-races around sysctl_tcp_reflect_tos.
      ipv4: Fix data-races around sysctl_fib_notify_on_flag_change.

Leo Yan (1):
      perf symbol: Correct address for bss symbols

Liang He (2):
      scsi: ufs: host: Hold reference returned by of_parse_phandle()
      net: sungem_phy: Add of_node_put() for reference returned by of_get_parent()

Linus Torvalds (1):
      watch_queue: Fix missing locking in add_watch_to_object()

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put

Lukas Bulwahn (1):
      asm-generic: remove a broken and needless ifdef conditional

Maciej Fijalkowski (2):
      ice: check (DD | EOF) bits on Rx descriptor rather than (EOP | RS)
      ice: do not setup vlan for loopback VSI

Maxim Mikityanskiy (1):
      net/tls: Remove the context from the list in tls_device_down

Miaohe Lin (1):
      hugetlb: fix memoryleak in hugetlb_mcopy_atomic_pte

Michal Maloszewski (1):
      i40e: Fix interface init with MSI interrupts (no MSI-X)

Mike Rapoport (1):
      secretmem: fix unhandled fault in truncate

Nathan Chancellor (1):
      drm/simpledrm: Fix return type of simpledrm_simple_display_pipe_mode_valid()

Ralph Campbell (1):
      mm/hmm: fault non-owner device private entries

Sabrina Dubroca (4):
      macsec: fix NULL deref in macsec_add_rxsa
      macsec: fix error message in macsec_add_rxsa and _txsa
      macsec: limit replay window size with XPN
      macsec: always read MACSEC_SA_ATTR_PN as a u64

Subbaraya Sundeep (1):
      octeontx2-pf: Fix UDP/TCP src and dst port tc filters

Sunil Goutham (1):
      octeontx2-pf: cn10k: Fix egress ratelimit configuration

Taehee Yoo (1):
      net: mld: fix reference count leak in mld_{query | report}_work()

Thadeu Lima de Souza Cascardo (1):
      x86/bugs: Do not enable IBPB at firmware entry when IBPB is not available

Toshi Kani (1):
      EDAC/ghes: Set the DIMM label unconditionally

Vladimir Oltean (1):
      net: pcs: xpcs: propagate xpcs_read error to xpcs_get_state_c37_sgmii

Waiman Long (1):
      locking/rwsem: Allow slowpath writer to ignore handoff bit if not set by first waiter

Wei Wang (1):
      Revert "tcp: change pingpong threshold to 3"

Xin Long (2):
      Documentation: fix sctp_wmem in ip-sysctl.rst
      sctp: leave the err path free in sctp_stream_init to sctp_stream_free

Ziyang Xuan (1):
      ipv6/addrconf: fix a null-ptr-deref bug for ip6_ptr

