Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4D928B975
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390155AbgJLOAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731406AbgJLNjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:39:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD0142222A;
        Mon, 12 Oct 2020 13:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509974;
        bh=LzpFmVtt6mTGrmV7k01CSNzZcLEQddKSNFUEvFcRbNI=;
        h=From:To:Cc:Subject:Date:From;
        b=MtS2X5oqYfFPQ/ySdtHV7RC0xrBzCuswzGWClP2GemBdNWsCZVkw/gxaOaZrw1zJt
         PLJ+TZ+2gWLaA1rJfKgOUfNsIQvdm3QtD2zv2q74Uihf+escYOFz5dM4zxw3eyPic5
         ncxLXv147l8KOONtJnxpORWm66/ljfukRRob6LyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/49] 4.19.151-rc1 review
Date:   Mon, 12 Oct 2020 15:26:46 +0200
Message-Id: <20201012132629.469542486@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.151-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.151-rc1
X-KernelTest-Deadline: 2020-10-14T13:26+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.151 release.
There are 49 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.151-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.151-rc1

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    net: usb: rtl8150: set random MAC address when set_ethernet_addr() fails

Vijay Balakrishna <vijayb@linux.microsoft.com>
    mm: khugepaged: recalculate min_free_kbytes after memory hotplug as expected by khugepaged

Coly Li <colyli@suse.de>
    mmc: core: don't set limits.discard_granularity as 0

Kajol Jain <kjain@linux.ibm.com>
    perf: Fix task_function_call() error handling

David Howells <dhowells@redhat.com>
    rxrpc: Fix server keyring leak

David Howells <dhowells@redhat.com>
    rxrpc: Fix some missing _bh annotations on locking conn->state_lock

David Howells <dhowells@redhat.com>
    rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()

Marc Dionne <marc.dionne@auristor.com>
    rxrpc: Fix rxkad token xdr encoding

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix VLAN create flow

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix VLAN cleanup flow

Wilken Gottwalt <wilken.gottwalt@mailbox.org>
    net: usb: ax88179_178a: fix missing stop entry in driver_info

Randy Dunlap <rdunlap@infradead.org>
    mdio: fix mdio-thunder.c dependency & build error

Eric Dumazet <edumazet@google.com>
    bonding: set dev->needed_headroom in bond_setup_by_slave()

Herbert Xu <herbert@gondor.apana.org.au>
    xfrm: Use correct address family in xfrm_state_find

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    platform/x86: fix kconfig dependency warning for FUJITSU_LAPTOP

Voon Weifeng <weifeng.voon@intel.com>
    net: stmmac: removed enabling eee in EEE set callback

Antony Antony <antony.antony@secunet.com>
    xfrm: clone whole liftime_cur structure in xfrm_do_migrate

Antony Antony <antony.antony@secunet.com>
    xfrm: clone XFRMA_SEC_CTX in xfrm_do_migrate

Antony Antony <antony.antony@secunet.com>
    xfrm: clone XFRMA_REPLAY_ESN_VAL in xfrm_do_migrate

Antony Antony <antony.antony@secunet.com>
    xfrm: clone XFRMA_SET_MARK in xfrm_do_migrate

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: prevent double kfree ttm->sg

Dumitru Ceara <dceara@redhat.com>
    openvswitch: handle DNAT tuple collision

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    net: team: fix memory leak in __team_options_register

Eric Dumazet <edumazet@google.com>
    team: set dev->needed_headroom in team_setup_by_port()

Eric Dumazet <edumazet@google.com>
    sctp: fix sctp_auth_init_hmacs() error path

Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
    i2c: owl: Clear NACK and BUS error bits

Nicolas Belin <nbelin@baylibre.com>
    i2c: meson: fixup rate calculation with filter delay

Jerome Brunet <jbrunet@baylibre.com>
    i2c: meson: fix clock setting overwrite

Vladimir Zapolskiy <vladimir@tuxera.com>
    cifs: Fix incomplete memory allocation on setxattr path

Sabrina Dubroca <sd@queasysnail.net>
    xfrmi: drop ignore_df check before updating pmtu

Hugh Dickins <hughd@google.com>
    mm/khugepaged: fix filemap page_to_pgoff(page) != offset

Eric Dumazet <edumazet@google.com>
    macsec: avoid use-after-free in macsec_handle_frame()

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvme-core: put ctrl ref when module ref get fail

Dinh Nguyen <dinguyen@kernel.org>
    arm64: dts: stratix10: add status to qspi dts node

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: sunxi: Fix the probe error path

Jean Delvare <jdelvare@suse.de>
    i2c: i801: Exclude device from suspend direct complete optimization

Tommi Rantala <tommi.t.rantala@nokia.com>
    perf top: Fix stdio interface input handling with glibc 2.28+

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    driver core: Fix probe_count imbalance in really_probe()

Aaron Ma <aaron.ma@canonical.com>
    platform/x86: thinkpad_acpi: re-initialize ACPI buffer size when reuse

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel-vbtn: Switch to an allow-list for SW_TABLET_MODE reporting

Tom Rix <trix@redhat.com>
    platform/x86: thinkpad_acpi: initialize tp_nvram_state variable

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel-vbtn: Fix SW_TABLET_MODE always reporting 1 on the HP Pavilion 11 x360

Linus Torvalds <torvalds@linux-foundation.org>
    usermodehelper: reset umask to default before executing user process

Karol Herbst <kherbst@redhat.com>
    drm/nouveau/mem: guard against NULL pointer access in mem_del

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    net: wireless: nl80211: fix out-of-bounds access in nl80211_del_key()

Geert Uytterhoeven <geert+renesas@glider.be>
    Revert "ravb: Fixed to be able to unload modules"

Peilin Ye <yepeilin.cs@gmail.com>
    fbcon: Fix global-out-of-bounds read in fbcon_get_font()

Peilin Ye <yepeilin.cs@gmail.com>
    Fonts: Support FONT_EXTRA_WORDS macros for built-in fonts

Peilin Ye <yepeilin.cs@gmail.com>
    fbdev, newport_con: Move FONT_EXTRA_WORDS macros into linux/font.h


-------------

Diffstat:

 Makefile                                           |   4 +-
 .../boot/dts/altera/socfpga_stratix10_socdk.dts    |   1 +
 drivers/base/dd.c                                  |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   1 +
 drivers/gpu/drm/nouveau/nouveau_mem.c              |   2 +
 drivers/i2c/busses/i2c-i801.c                      |   1 +
 drivers/i2c/busses/i2c-meson.c                     |  42 +++++---
 drivers/i2c/busses/i2c-owl.c                       |   6 ++
 drivers/mmc/core/queue.c                           |   2 +-
 drivers/mtd/nand/raw/sunxi_nand.c                  |   2 +-
 drivers/net/bonding/bond_main.c                    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  14 ++-
 drivers/net/ethernet/renesas/ravb_main.c           | 110 ++++++++++-----------
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  15 +--
 drivers/net/macsec.c                               |   4 +-
 drivers/net/phy/Kconfig                            |   1 +
 drivers/net/team/team.c                            |   3 +-
 drivers/net/usb/ax88179_178a.c                     |   1 +
 drivers/net/usb/rtl8150.c                          |  16 ++-
 drivers/nvme/host/core.c                           |   4 +-
 drivers/platform/x86/Kconfig                       |   1 +
 drivers/platform/x86/intel-vbtn.c                  |  64 +++++++++---
 drivers/platform/x86/thinkpad_acpi.c               |   6 +-
 drivers/video/console/newport_con.c                |   7 +-
 drivers/video/fbdev/core/fbcon.c                   |  12 +++
 drivers/video/fbdev/core/fbcon.h                   |   7 --
 drivers/video/fbdev/core/fbcon_rotate.c            |   1 +
 drivers/video/fbdev/core/tileblit.c                |   1 +
 fs/cifs/smb2ops.c                                  |   2 +-
 include/linux/font.h                               |  13 +++
 include/linux/khugepaged.h                         |   5 +
 include/net/xfrm.h                                 |  16 ++-
 kernel/events/core.c                               |   5 +-
 kernel/umh.c                                       |   9 ++
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
 mm/khugepaged.c                                    |  25 ++++-
 mm/page_alloc.c                                    |   3 +
 net/openvswitch/conntrack.c                        |  22 +++--
 net/rxrpc/conn_event.c                             |   6 +-
 net/rxrpc/key.c                                    |  18 +++-
 net/sctp/auth.c                                    |   1 +
 net/wireless/nl80211.c                             |   3 +
 net/xfrm/xfrm_interface.c                          |   2 +-
 net/xfrm/xfrm_state.c                              |  42 +++++++-
 tools/perf/builtin-top.c                           |   4 +-
 55 files changed, 395 insertions(+), 211 deletions(-)


