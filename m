Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9434428B65B
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388830AbgJLNdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388569AbgJLNcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:32:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14E5A20678;
        Mon, 12 Oct 2020 13:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509551;
        bh=Fx1GPuyoFQU+MbXL6xlwyGdAbQHq+/mkiA5mgN2eSv8=;
        h=From:To:Cc:Subject:Date:From;
        b=s5MUlwPnGCpzDNvQolllSOk2Z5t8IA2qQYURlJ0TqzpMizaYp4mZBcuh5KjseDtAB
         tJB1IIMfoDX4JiNPMwMPMlLEg8zSfJaSrXEB6KgsrpPV4KikWa8YSQKtUQroTG6XGf
         RkJAwoiC9xUulyBhQaB8lY0QyR1gaPJcqgc9q2JU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.4 00/39] 4.4.239-rc1 review
Date:   Mon, 12 Oct 2020 15:26:30 +0200
Message-Id: <20201012132628.130632267@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.239-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.239-rc1
X-KernelTest-Deadline: 2020-10-14T13:26+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.239 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.239-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.239-rc1

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    net: usb: rtl8150: set random MAC address when set_ethernet_addr() fails

David Howells <dhowells@redhat.com>
    rxrpc: Fix server keyring leak

David Howells <dhowells@redhat.com>
    rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()

Marc Dionne <marc.dionne@auristor.com>
    rxrpc: Fix rxkad token xdr encoding

Eric Dumazet <edumazet@google.com>
    bonding: set dev->needed_headroom in bond_setup_by_slave()

Herbert Xu <herbert@gondor.apana.org.au>
    xfrm: Use correct address family in xfrm_state_find

Voon Weifeng <weifeng.voon@intel.com>
    net: stmmac: removed enabling eee in EEE set callback

Antony Antony <antony.antony@secunet.com>
    xfrm: clone whole liftime_cur structure in xfrm_do_migrate

Antony Antony <antony.antony@secunet.com>
    xfrm: clone XFRMA_REPLAY_ESN_VAL in xfrm_do_migrate

Richard Weinberger <richard@nod.at>
    mtd: nand: Provide nand_cleanup() function to free NAND related resources

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    net: team: fix memory leak in __team_options_register

Eric Dumazet <edumazet@google.com>
    team: set dev->needed_headroom in team_setup_by_port()

Eric Dumazet <edumazet@google.com>
    sctp: fix sctp_auth_init_hmacs() error path

Tommi Rantala <tommi.t.rantala@nokia.com>
    perf top: Fix stdio interface input handling with glibc 2.28+

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    driver core: Fix probe_count imbalance in really_probe()

Aaron Ma <aaron.ma@canonical.com>
    platform/x86: thinkpad_acpi: re-initialize ACPI buffer size when reuse

Tom Rix <trix@redhat.com>
    platform/x86: thinkpad_acpi: initialize tp_nvram_state variable

Linus Torvalds <torvalds@linux-foundation.org>
    usermodehelper: reset umask to default before executing user process

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    net: wireless: nl80211: fix out-of-bounds access in nl80211_del_key()

Peilin Ye <yepeilin.cs@gmail.com>
    fbcon: Fix global-out-of-bounds read in fbcon_get_font()

Geert Uytterhoeven <geert+renesas@glider.be>
    Revert "ravb: Fixed to be able to unload modules"

Peilin Ye <yepeilin.cs@gmail.com>
    Fonts: Support FONT_EXTRA_WORDS macros for built-in fonts

Peilin Ye <yepeilin.cs@gmail.com>
    fbdev, newport_con: Move FONT_EXTRA_WORDS macros into linux/font.h

Will McVicker <willmcvicker@google.com>
    netfilter: ctnetlink: add a range check for l3/l4 protonum

Al Viro <viro@zeniv.linux.org.uk>
    ep_create_wakeup_source(): dentry name can change under you...

Al Viro <viro@zeniv.linux.org.uk>
    epoll: EPOLL_CTL_ADD: close the race in decision to take fast path

Al Viro <viro@zeniv.linux.org.uk>
    epoll: replace ->visited/visited_list with generation count

Al Viro <viro@zeniv.linux.org.uk>
    epoll: do not insert into poll queues until all sanity checks are done

Nicolas VINCENT <nicolas.vincent@vossloh.com>
    i2c: cpm: Fix i2c_ram structure

Yu Kuai <yukuai3@huawei.com>
    iommu/exynos: add missing put_device() call in exynos_iommu_of_xlate()

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos4: mark 'chipid' clock as CLK_IGNORE_UNUSED

Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
    nfs: Fix security label length not being reset

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/hdlc: Set skb->protocol before transmitting

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/lapbether: Make skb->protocol consistent with the header

Olympia Giannou <ogiannou@gmail.com>
    rndis_host: increase sleep time in the query-response loop

Lucy Yan <lucyyan@google.com>
    net: dec: de2104x: Increase receive ring size for Tulip

Jean Delvare <jdelvare@suse.de>
    drm/amdgpu: restore proper ref count in amdgpu_display_crtc_set_config

Jiri Kosina <jkosina@suse.cz>
    Input: i8042 - add nopnp quirk for Acer Aspire 5 A515

dillon min <dillon.minfei@gmail.com>
    gpio: tc35894: fix up tc35894 interrupt configuration


-------------

Diffstat:

 Makefile                                           |   4 +-
 drivers/base/dd.c                                  |   5 +-
 drivers/clk/samsung/clk-exynos4.c                  |   4 +-
 drivers/gpio/gpio-tc3589x.c                        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |   2 +-
 drivers/i2c/busses/i2c-cpm.c                       |   3 +
 drivers/input/serio/i8042-x86ia64io.h              |   7 ++
 drivers/iommu/exynos-iommu.c                       |   8 +-
 drivers/mtd/nand/nand_base.c                       |  22 +++--
 drivers/net/bonding/bond_main.c                    |   1 +
 drivers/net/ethernet/dec/tulip/de2104x.c           |   2 +-
 drivers/net/ethernet/renesas/ravb_main.c           | 110 ++++++++++-----------
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  15 +--
 drivers/net/team/team.c                            |   3 +-
 drivers/net/usb/rndis_host.c                       |   2 +-
 drivers/net/usb/rtl8150.c                          |  16 ++-
 drivers/net/wan/hdlc_cisco.c                       |   1 +
 drivers/net/wan/hdlc_fr.c                          |   3 +
 drivers/net/wan/hdlc_ppp.c                         |   1 +
 drivers/net/wan/lapbether.c                        |   4 +-
 drivers/platform/x86/thinkpad_acpi.c               |   6 +-
 drivers/video/console/fbcon.c                      |  12 +++
 drivers/video/console/fbcon.h                      |   7 --
 drivers/video/console/fbcon_rotate.c               |   1 +
 drivers/video/console/newport_con.c                |   7 +-
 drivers/video/console/tileblit.c                   |   1 +
 fs/eventpoll.c                                     |  71 ++++++-------
 fs/nfs/dir.c                                       |   3 +
 include/linux/font.h                               |  13 +++
 include/linux/mtd/nand.h                           |   6 +-
 include/net/xfrm.h                                 |  16 ++-
 kernel/kmod.c                                      |   9 ++
 lib/fonts/font_10x18.c                             |   9 +-
 lib/fonts/font_6x10.c                              |   9 +-
 lib/fonts/font_6x11.c                              |   9 +-
 lib/fonts/font_7x14.c                              |   9 +-
 lib/fonts/font_8x16.c                              |   9 +-
 lib/fonts/font_8x8.c                               |   9 +-
 lib/fonts/font_acorn_8x8.c                         |   9 +-
 lib/fonts/font_mini_4x6.c                          |   8 +-
 lib/fonts/font_pearl_8x8.c                         |   9 +-
 lib/fonts/font_sun12x22.c                          |   9 +-
 lib/fonts/font_sun8x16.c                           |   7 +-
 net/netfilter/nf_conntrack_netlink.c               |   2 +
 net/rxrpc/ar-key.c                                 |  16 ++-
 net/sctp/auth.c                                    |   1 +
 net/wireless/nl80211.c                             |   3 +
 net/xfrm/xfrm_state.c                              |  13 ++-
 tools/perf/builtin-top.c                           |   4 +-
 49 files changed, 284 insertions(+), 218 deletions(-)


