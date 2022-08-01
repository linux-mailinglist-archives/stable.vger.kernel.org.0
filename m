Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677B35868AC
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbiHALwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiHALvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:51:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7193C41996;
        Mon,  1 Aug 2022 04:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B41BB81170;
        Mon,  1 Aug 2022 11:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D58C433D6;
        Mon,  1 Aug 2022 11:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354564;
        bh=fO1lx1xABXRdQqqW9forF2aYYrqiHWrRZn9jlSJ4i2o=;
        h=From:To:Cc:Subject:Date:From;
        b=apxDjz/EXESUWjh539iuHaEXJ/dtO6SpzIH5HJyIaZxRyu+GGuHhzI6mlKz8LR9fF
         DpuKdT1i8EqHOifT/F3Ko3enueQQSUaTHh4sppSliph/9pYGN0qUnPm2QIEXmO4j7x
         2eH46YfjT6k5QzHKivQgf/GV27hOVBW+jkomOj4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/34] 5.4.209-rc1 review
Date:   Mon,  1 Aug 2022 13:46:40 +0200
Message-Id: <20220801114128.025615151@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.209-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.209-rc1
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

This is the start of the stable review cycle for the 5.4.209 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.209-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.209-rc1

Ming Lei <ming.lei@redhat.com>
    scsi: core: Fix race between handling STS_RESOURCE and completion

Wei Mingzhi <whistler@member.fsf.org>
    mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.

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
    tcp: Fix a data-race around sysctl_tcp_comp_sack_nr.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_comp_sack_delay_ns.

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

Ziyang Xuan <william.xuanziyang@huawei.com>
    ipv6/addrconf: fix a null-ptr-deref bug for ip6_ptr

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: ping6: Fix memleak in ipv6_renew_options().

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_challenge_ack_limit.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_limit_output_bytes.

Liang He <windhl@126.com>
    scsi: ufs: host: Hold reference returned by of_parse_phandle()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: do not setup vlan for loopback VSI

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: check (DD | EOF) bits on Rx descriptor rather than (EOP | RS)

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

Harald Freudenberger <freude@linux.ibm.com>
    s390/archrandom: prevent CPACF trng invocations in interrupt context

ChenXiaoSong <chenxiaosong2@huawei.com>
    ntfs: fix use-after-free in ntfs_ucsncmp()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put


-------------

Diffstat:

 Documentation/networking/ip-sysctl.txt       |  9 +++-
 Makefile                                     |  4 +-
 arch/arm/lib/xor-neon.c                      |  3 +-
 arch/s390/include/asm/archrandom.h           |  9 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c  |  4 ++
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  3 +-
 drivers/net/ethernet/intel/ice/ice_main.c    |  8 ++--
 drivers/net/ethernet/sfc/ptp.c               | 22 ++++++++++
 drivers/net/sungem_phy.c                     |  1 +
 drivers/net/virtio_net.c                     | 37 +++++++++++++++--
 drivers/net/wireless/mediatek/mt7601u/usb.c  |  1 +
 drivers/scsi/scsi_lib.c                      |  3 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c             | 15 ++++++-
 fs/ntfs/attrib.c                             |  8 +++-
 include/net/addrconf.h                       |  3 ++
 include/net/bluetooth/l2cap.h                |  1 +
 include/net/tcp.h                            |  2 +-
 net/bluetooth/l2cap_core.c                   | 61 ++++++++++++++++++++++------
 net/ipv4/igmp.c                              | 24 ++++++-----
 net/ipv4/tcp.c                               |  2 +-
 net/ipv4/tcp_input.c                         | 20 +++++----
 net/ipv4/tcp_metrics.c                       |  2 +-
 net/ipv4/tcp_output.c                        |  4 +-
 net/ipv6/ping.c                              |  6 +++
 net/netfilter/nfnetlink_queue.c              |  7 +++-
 net/sctp/associola.c                         |  5 +--
 net/sctp/stream.c                            | 19 ++-------
 net/sctp/stream_sched.c                      |  2 +-
 tools/perf/util/symbol-elf.c                 | 45 ++++++++++++++++++--
 29 files changed, 247 insertions(+), 83 deletions(-)


