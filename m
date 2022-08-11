Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6883D58FB4C
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 13:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbiHKLaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 07:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234905AbiHKLak (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 07:30:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BB817047;
        Thu, 11 Aug 2022 04:30:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B602B8204F;
        Thu, 11 Aug 2022 11:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD95CC433D6;
        Thu, 11 Aug 2022 11:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660217437;
        bh=P6gcwTORrPLUuleZc3Rmcp5aU0rCCI9qhXQdrjPWCEw=;
        h=From:To:Cc:Subject:Date:From;
        b=X4yqB9xrWFwvf216R59M7yKp3KQxprXXkj53xCD7kmeYmPX8xgiBFO9zfYlgwIPx8
         wV1GgJSNaf15HwS4MEvdMu7xAVTxXhfBcVbBgPVBi0LNpa/B7Da3r02flPZ5SEiWpD
         A0GAn49HfjD7aajtzf3EocYJw5+IXHHrn+iFb+Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.255
Date:   Thu, 11 Aug 2022 13:30:32 +0200
Message-Id: <1660217431160199@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.255 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst |    8 +++
 Documentation/networking/ip-sysctl.txt        |    9 +++
 Makefile                                      |    2 
 arch/arm/lib/xor-neon.c                       |    3 -
 arch/s390/include/asm/archrandom.h            |    9 ++-
 arch/x86/include/asm/cpufeatures.h            |    2 
 arch/x86/include/asm/msr-index.h              |    4 +
 arch/x86/include/asm/nospec-branch.h          |   19 +++++++-
 arch/x86/kernel/cpu/bugs.c                    |   61 +++++++++++++++++++++++++-
 arch/x86/kernel/cpu/common.c                  |   12 ++++-
 arch/x86/kvm/vmx.c                            |    6 +-
 drivers/acpi/video_detect.c                   |   55 ++++++++++++++---------
 drivers/macintosh/adb.c                       |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c   |    4 +
 drivers/net/sungem_phy.c                      |    1 
 drivers/net/wireless/mediatek/mt7601u/usb.c   |    1 
 drivers/scsi/scsi_lib.c                       |    3 -
 drivers/scsi/ufs/ufshcd-pltfrm.c              |   15 +++++-
 fs/ntfs/attrib.c                              |    8 ++-
 include/net/bluetooth/l2cap.h                 |    1 
 include/net/tcp.h                             |    2 
 net/bluetooth/l2cap_core.c                    |   61 ++++++++++++++++++++------
 net/ipv4/igmp.c                               |   24 +++++-----
 net/ipv4/tcp.c                                |    2 
 net/ipv4/tcp_input.c                          |   20 ++++----
 net/ipv4/tcp_metrics.c                        |    2 
 net/ipv4/tcp_output.c                         |    2 
 net/ipv6/ping.c                               |    6 ++
 net/netfilter/nfnetlink_queue.c               |    7 ++
 net/sctp/stream_sched.c                       |    2 
 tools/perf/util/symbol-elf.c                  |   45 +++++++++++++++++--
 31 files changed, 315 insertions(+), 83 deletions(-)

ChenXiaoSong (1):
      ntfs: fix use-after-free in ntfs_ucsncmp()

Daniel Sneddon (1):
      x86/speculation: Add RSB VM Exit protections

Duoming Zhou (1):
      sctp: fix sleep in atomic context bug in timer handlers

Florian Westphal (1):
      netfilter: nf_queue: do not allow packet truncation below transport header offset

Greg Kroah-Hartman (2):
      ARM: crypto: comment out gcc warning that breaks clang builds
      Linux 4.19.255

Harald Freudenberger (1):
      s390/archrandom: prevent CPACF trng invocations in interrupt context

Kuniyuki Iwashima (14):
      tcp: Fix data-races around sysctl_tcp_dsack.
      tcp: Fix a data-race around sysctl_tcp_app_win.
      tcp: Fix a data-race around sysctl_tcp_adv_win_scale.
      tcp: Fix a data-race around sysctl_tcp_frto.
      tcp: Fix a data-race around sysctl_tcp_nometrics_save.
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

Michal Maloszewski (1):
      i40e: Fix interface init with MSI interrupts (no MSI-X)

Ming Lei (1):
      scsi: core: Fix race between handling STS_RESOURCE and completion

Ning Qiang (1):
      macintosh/adb: fix oob read in do_adb_query() function

Pawan Gupta (1):
      x86/speculation: Add LFENCE to RSB fill sequence

Wei Mingzhi (1):
      mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.

Werner Sembach (2):
      ACPI: video: Force backlight native for some TongFang devices
      ACPI: video: Shortening quirk list by identifying Clevo by board_name only

Xin Long (1):
      Documentation: fix sctp_wmem in ip-sysctl.rst

