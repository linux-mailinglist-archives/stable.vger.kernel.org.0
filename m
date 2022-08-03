Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E23588A8D
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 12:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237973AbiHCKb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 06:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238045AbiHCKbM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 06:31:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53455C944;
        Wed,  3 Aug 2022 03:29:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59B02B8211D;
        Wed,  3 Aug 2022 10:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97578C433D6;
        Wed,  3 Aug 2022 10:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659522591;
        bh=7onbPMfgpINp4aMtTKW3PBu453wnLyM8pTO0tU3XyJI=;
        h=From:To:Cc:Subject:Date:From;
        b=nj70CGiL1JmkHhd9ow2uRrNCONAAtI0ybj6ShBXKprC3bEZPM79kenudQErjjQpmb
         0DM66virrOTyFgpItRWdGX/N+LxORyrDPZtVoJBOhVDo1rC6wDk7IrGbot8/wjVAoO
         wA0DZH2GOdYd0M6wnz2rTMrBYW6RTok2S8JDEpXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.209
Date:   Wed,  3 Aug 2022 12:29:47 +0200
Message-Id: <1659522587229206@kroah.com>
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

I'm announcing the release of the 5.4.209 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/ip-sysctl.txt       |    9 +++
 Makefile                                     |    2 
 arch/arm/lib/xor-neon.c                      |    3 -
 arch/s390/include/asm/archrandom.h           |    9 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c  |    4 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c |    3 -
 drivers/net/ethernet/intel/ice/ice_main.c    |    8 ++-
 drivers/net/ethernet/sfc/ptp.c               |   22 +++++++++
 drivers/net/sungem_phy.c                     |    1 
 drivers/net/virtio_net.c                     |   37 +++++++++++++++-
 drivers/net/wireless/mediatek/mt7601u/usb.c  |    1 
 drivers/scsi/scsi_lib.c                      |    3 -
 drivers/scsi/ufs/ufshcd-pltfrm.c             |   15 +++++-
 fs/ntfs/attrib.c                             |    8 ++-
 include/net/addrconf.h                       |    3 +
 include/net/bluetooth/l2cap.h                |    1 
 include/net/tcp.h                            |    2 
 net/bluetooth/l2cap_core.c                   |   61 +++++++++++++++++++++------
 net/ipv4/igmp.c                              |   24 +++++-----
 net/ipv4/tcp.c                               |    2 
 net/ipv4/tcp_input.c                         |   20 ++++----
 net/ipv4/tcp_metrics.c                       |    2 
 net/ipv4/tcp_output.c                        |    4 -
 net/ipv6/ping.c                              |    6 ++
 net/netfilter/nfnetlink_queue.c              |    7 ++-
 net/sctp/associola.c                         |    5 --
 net/sctp/stream.c                            |   19 +-------
 net/sctp/stream_sched.c                      |    2 
 tools/perf/util/symbol-elf.c                 |   45 ++++++++++++++++++-
 29 files changed, 246 insertions(+), 82 deletions(-)

Alejandro Lucero (1):
      sfc: disable softirqs for ptp TX

ChenXiaoSong (1):
      ntfs: fix use-after-free in ntfs_ucsncmp()

Duoming Zhou (1):
      sctp: fix sleep in atomic context bug in timer handlers

Florian Westphal (1):
      netfilter: nf_queue: do not allow packet truncation below transport header offset

Greg Kroah-Hartman (2):
      ARM: crypto: comment out gcc warning that breaks clang builds
      Linux 5.4.209

Harald Freudenberger (1):
      s390/archrandom: prevent CPACF trng invocations in interrupt context

Jason Wang (1):
      virtio-net: fix the race between refill work and close

Kuniyuki Iwashima (15):
      tcp: Fix data-races around sysctl_tcp_dsack.
      tcp: Fix a data-race around sysctl_tcp_app_win.
      tcp: Fix a data-race around sysctl_tcp_adv_win_scale.
      tcp: Fix a data-race around sysctl_tcp_frto.
      tcp: Fix a data-race around sysctl_tcp_nometrics_save.
      tcp: Fix a data-race around sysctl_tcp_limit_output_bytes.
      tcp: Fix a data-race around sysctl_tcp_challenge_ack_limit.
      net: ping6: Fix memleak in ipv6_renew_options().
      igmp: Fix data-races around sysctl_igmp_qrv.
      tcp: Fix a data-race around sysctl_tcp_min_tso_segs.
      tcp: Fix a data-race around sysctl_tcp_min_rtt_wlen.
      tcp: Fix a data-race around sysctl_tcp_autocorking.
      tcp: Fix a data-race around sysctl_tcp_invalid_ratelimit.
      tcp: Fix a data-race around sysctl_tcp_comp_sack_delay_ns.
      tcp: Fix a data-race around sysctl_tcp_comp_sack_nr.

Leo Yan (1):
      perf symbol: Correct address for bss symbols

Liang He (2):
      scsi: ufs: host: Hold reference returned by of_parse_phandle()
      net: sungem_phy: Add of_node_put() for reference returned by of_get_parent()

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put

Maciej Fijalkowski (2):
      ice: check (DD | EOF) bits on Rx descriptor rather than (EOP | RS)
      ice: do not setup vlan for loopback VSI

Michal Maloszewski (1):
      i40e: Fix interface init with MSI interrupts (no MSI-X)

Ming Lei (1):
      scsi: core: Fix race between handling STS_RESOURCE and completion

Wei Mingzhi (1):
      mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.

Xin Long (2):
      Documentation: fix sctp_wmem in ip-sysctl.rst
      sctp: leave the err path free in sctp_stream_init to sctp_stream_free

Ziyang Xuan (1):
      ipv6/addrconf: fix a null-ptr-deref bug for ip6_ptr

