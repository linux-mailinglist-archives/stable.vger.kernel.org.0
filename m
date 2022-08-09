Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9464D58DDB3
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245720AbiHISEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344492AbiHISDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:03:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0809C275CC;
        Tue,  9 Aug 2022 11:01:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F739B81717;
        Tue,  9 Aug 2022 18:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD88AC433B5;
        Tue,  9 Aug 2022 18:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068116;
        bh=+FqkR+GNwO8WzU+AMoVFB/pDiBtIJK6YbTFImLEr4T4=;
        h=From:To:Cc:Subject:Date:From;
        b=kQ/NjrHVGMq7GtSOD9xxWfBaZ9dXZo4lYo/3UsuCsFBsFIXJkblBblogcN9G20L0Y
         XWFMC+DRiFZYn0tIS9XkeIqwJ09HfhDv4wbKOQx/rUmN76QXEx/NUDVssU0OMHqu0O
         EHvMYHkxMpR/6jNGrXjTOA6kqDPF/zXff0FdR5WQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/32] 4.19.255-rc1 review
Date:   Tue,  9 Aug 2022 19:59:51 +0200
Message-Id: <20220809175513.082573955@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.255-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.255-rc1
X-KernelTest-Deadline: 2022-08-11T17:55+00:00
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

This is the start of the stable review cycle for the 4.19.255 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.255-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.255-rc1

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Add LFENCE to RSB fill sequence

Daniel Sneddon <daniel.sneddon@linux.intel.com>
    x86/speculation: Add RSB VM Exit protections

Ning Qiang <sohu0106@126.com>
    macintosh/adb: fix oob read in do_adb_query() function

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Shortening quirk list by identifying Clevo by board_name only

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Force backlight native for some TongFang devices

Ming Lei <ming.lei@redhat.com>
    scsi: core: Fix race between handling STS_RESOURCE and completion

Wei Mingzhi <whistler@member.fsf.org>
    mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ARM: crypto: comment out gcc warning that breaks clang builds

Leo Yan <leo.yan@linaro.org>
    perf symbol: Correct address for bss symbols

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

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: ping6: Fix memleak in ipv6_renew_options().

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_challenge_ack_limit.

Liang He <windhl@126.com>
    scsi: ufs: host: Hold reference returned by of_parse_phandle()

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

 Documentation/admin-guide/hw-vuln/spectre.rst |  8 ++++
 Documentation/networking/ip-sysctl.txt        |  9 +++-
 Makefile                                      |  4 +-
 arch/arm/lib/xor-neon.c                       |  3 +-
 arch/s390/include/asm/archrandom.h            |  9 ++--
 arch/x86/include/asm/cpufeatures.h            |  2 +
 arch/x86/include/asm/msr-index.h              |  4 ++
 arch/x86/include/asm/nospec-branch.h          | 19 ++++++++-
 arch/x86/kernel/cpu/bugs.c                    | 61 ++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/common.c                  | 12 +++++-
 arch/x86/kvm/vmx.c                            |  6 +--
 drivers/acpi/video_detect.c                   | 55 +++++++++++++++---------
 drivers/macintosh/adb.c                       |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  4 ++
 drivers/net/sungem_phy.c                      |  1 +
 drivers/net/wireless/mediatek/mt7601u/usb.c   |  1 +
 drivers/scsi/scsi_lib.c                       |  3 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c              | 15 ++++++-
 fs/ntfs/attrib.c                              |  8 +++-
 include/net/bluetooth/l2cap.h                 |  1 +
 include/net/tcp.h                             |  2 +-
 net/bluetooth/l2cap_core.c                    | 61 +++++++++++++++++++++------
 net/ipv4/igmp.c                               | 24 ++++++-----
 net/ipv4/tcp.c                                |  2 +-
 net/ipv4/tcp_input.c                          | 20 +++++----
 net/ipv4/tcp_metrics.c                        |  2 +-
 net/ipv4/tcp_output.c                         |  2 +-
 net/ipv6/ping.c                               |  6 +++
 net/netfilter/nfnetlink_queue.c               |  7 ++-
 net/sctp/stream_sched.c                       |  2 +-
 tools/perf/util/symbol-elf.c                  | 45 ++++++++++++++++++--
 31 files changed, 316 insertions(+), 84 deletions(-)


