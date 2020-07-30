Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA3F232DC6
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgG3IOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:14:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730025AbgG3IMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:12:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79EF32070B;
        Thu, 30 Jul 2020 08:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096736;
        bh=tiDWxRC1I1hx8YlDjESiIGAqBa/bGMCeb/zr3RL/lgo=;
        h=From:To:Cc:Subject:Date:From;
        b=X+o4VOmNWhq43wDW2KmqT+DN0p5SVOG1orKbQN9wqRhiRGm7rWKtYCyoR93zzG+hc
         f1CGWc0hzqsQYZ/q1ztl1/PHdWubzwv77DvXP1L9gHrPdhU1GLYxPH9MPtdf2S9nup
         2A3z7wIeQbkMwjfbIiHdBvKGY1Hh2a5rkz7NeBJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/54] 4.4.232-rc1 review
Date:   Thu, 30 Jul 2020 10:04:39 +0200
Message-Id: <20200730074421.203879987@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.232-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.232-rc1
X-KernelTest-Deadline: 2020-08-01T07:44+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.232 release.
There are 54 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.232-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.232-rc1

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to check blacklist address correctly

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate: Use asprintf when formatting objdump command line

Jiri Olsa <jolsa@kernel.org>
    perf tools: Fix snprint warnings for gcc 8

Changbin Du <changbin.du@gmail.com>
    perf: Make perf able to build with latest libbfd

Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
    tools/lib/subcmd/pager.c: do not alias select() params

Eric Sandeen <sandeen@redhat.com>
    xfs: set format back to extents if xfs_bmap_extents_to_btree

Peng Fan <peng.fan@nxp.com>
    regmap: debugfs: check count when read regmap file

Fangrui Song <maskray@google.com>
    Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross compilation

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/x25_asy: Fix to make it work

Wei Yongjun <weiyongjun1@huawei.com>
    ip6_gre: fix null-ptr-deref in ip6gre_init_net()

David Howells <dhowells@redhat.com>
    rxrpc: Fix sendmsg() returning EPIPE due to recvmsg() returning ENODATA

Yuchung Cheng <ycheng@google.com>
    tcp: allow at most one TLP probe per flight

Dan Carpenter <dan.carpenter@oracle.com>
    AX.25: Prevent integer overflows in connect and sendmsg

Miaohe Lin <linmiaohe@huawei.com>
    net: udp: Fix wrong clean up for IS_UDPLITE macro

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    net-sysfs: add a newline when printing 'tx_timeout' by sysfs

Peilin Ye <yepeilin.cs@gmail.com>
    AX.25: Prevent out-of-bounds read in ax25_sendmsg()

Peilin Ye <yepeilin.cs@gmail.com>
    AX.25: Fix out-of-bounds read in ax25_connect()

Mark O'Donovan <shiftee@posteo.net>
    ath9k: Fix regression with Atheros 9271

Qiujun Huang <hqjagain@gmail.com>
    ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

John David Anglin <dave.anglin@bell.net>
    parisc: Add atomic64_set_release() define to avoid CPU soft lockups

Hugh Dickins <hughd@google.com>
    mm/memcg: fix refcount error while moving and swapping

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    serial: 8250_mtk: Fix high-speed baud rates clamping

Yang Yingliang <yangyingliang@huawei.com>
    serial: 8250: fix null-ptr-deref in serial8250_start_tx()

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1564: check INSN_CONFIG_DIGITAL_TRIG shift

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1500: check INSN_CONFIG_DIGITAL_TRIG shift

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_6527: fix INSN_CONFIG_DIGITAL_TRIG support

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1032: check INSN_CONFIG_DIGITAL_TRIG shift

Rustam Kovhaev <rkovhaev@gmail.com>
    staging: wlan-ng: properly check endpoint types

Steve French <stfrench@microsoft.com>
    Revert "cifs: Fix the target file was deleted when rename failed."

Arnd Bergmann <arnd@arndb.de>
    x86: math-emu: Fix up 'cmp' insn for clang ias

Will Deacon <will@kernel.org>
    arm64: Use test_tsk_thread_flag() for checking TIF_SINGLESTEP

Evgeny Novikov <novikov@ispras.ru>
    usb: gadget: udc: gr_udc: fix memleak on error handling path in gr_ep_init()

Marc Kleine-Budde <mkl@pengutronix.de>
    regmap: dev_get_regmap_match(): fix string comparison

Pi-Hsun Shih <pihsun@chromium.org>
    scripts/decode_stacktrace: strip basepath from all paths

Wang Hai <wanghai38@huawei.com>
    net: smc91x: Fix possible memory leak in smc_drv_probe()

Sergey Organov <sorganov@gmail.com>
    net: dp83640: fix SIOCSHWTSTAMP to update the struct with actual configuration

George Kennedy <george.kennedy@oracle.com>
    ax88172a: fix ax88172a_unbind() failures

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    hippi: Fix a size used in a 'pci_free_consistent()' in an error handling path

Boris Burkov <boris@bur.io>
    btrfs: fix mount failure caused by race with umount

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    x86/fpu: Disable bottom halves while loading FPU registers

Filipe Manana <fdmanana@suse.com>
    btrfs: fix double free on ulist after backref resolution failure

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5670: Correct RT5670_LDO_SEL_MASK

Takashi Iwai <tiwai@suse.de>
    ALSA: info: Drop WARN_ON() from buffer NULL sanity check

Oleg Nesterov <oleg@redhat.com>
    uprobes: Change handle_swbp() to send SIGTRAP with si_code=SI_KERNEL, to fix GDB regression

Jiri Olsa <jolsa@kernel.org>
    perf/core: Fix locking for children siblings group read

Olga Kornievskaia <kolga@netapp.com>
    SUNRPC reverting d03727b248d0 ("NFSv4 fix CLOSE not waiting for direct IO compeletion")

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/i2c/g94-: increase NV_PMGR_DP_AUXCTL_TRANSACTREQ timeout

Tom Rix <trix@redhat.com>
    net: sky2: initialize return of gm_phy_read

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/lapbether: Fixed the value of hard_header_len

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: update *pos in cpuinfo_op.next

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix __sync_fetch_and_{and,or}_4 declarations

Tom Rix <trix@redhat.com>
    scsi: scsi_transport_spi: Fix function pointer check

Markus Theil <markus.theil@tu-ilmenau.de>
    mac80211: allow rx of mesh eapol frames with default rx key

Jacky Hu <hengqing.hu@gmail.com>
    pinctrl: amd: fix npins for uart0 in kerncz_groups


-------------

Diffstat:

 Makefile                                           |  6 +--
 arch/arm64/kernel/debug-monitors.c                 |  4 +-
 arch/parisc/include/asm/atomic.h                   |  2 +
 arch/x86/kernel/fpu/signal.c                       |  4 +-
 arch/x86/math-emu/wm_sqrt.S                        |  2 +-
 arch/xtensa/kernel/setup.c                         |  3 +-
 arch/xtensa/kernel/xtensa_ksyms.c                  |  4 +-
 drivers/base/regmap/regmap-debugfs.c               |  6 +++
 drivers/base/regmap/regmap.c                       |  2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxg94.c   |  4 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm204.c |  4 +-
 drivers/net/ethernet/marvell/sky2.c                |  2 +-
 drivers/net/ethernet/smsc/smc91x.c                 |  4 +-
 drivers/net/hippi/rrunner.c                        |  2 +-
 drivers/net/phy/dp83640.c                          |  4 ++
 drivers/net/usb/ax88172a.c                         |  1 +
 drivers/net/wan/lapbether.c                        |  9 +++-
 drivers/net/wan/x25_asy.c                          | 21 ++++++---
 drivers/net/wireless/ath/ath9k/hif_usb.c           | 52 +++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/hif_usb.h           |  5 +++
 drivers/pinctrl/pinctrl-amd.h                      |  2 +-
 drivers/scsi/scsi_transport_spi.c                  |  2 +-
 drivers/staging/comedi/drivers/addi_apci_1032.c    | 20 ++++++---
 drivers/staging/comedi/drivers/addi_apci_1500.c    | 24 +++++++---
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 20 ++++++---
 drivers/staging/comedi/drivers/ni_6527.c           |  2 +-
 drivers/staging/wlan-ng/prism2usb.c                | 16 ++++++-
 drivers/tty/serial/8250/8250_core.c                |  2 +-
 drivers/tty/serial/8250/8250_mtk.c                 | 18 ++++++++
 drivers/usb/gadget/udc/gr_udc.c                    |  7 ++-
 fs/btrfs/backref.c                                 |  1 +
 fs/btrfs/volumes.c                                 |  8 ++++
 fs/cifs/inode.c                                    | 10 +----
 fs/nfs/direct.c                                    | 13 ++----
 fs/nfs/file.c                                      |  1 -
 fs/xfs/libxfs/xfs_bmap.c                           |  2 +
 include/linux/tcp.h                                |  5 ++-
 kernel/events/core.c                               |  5 +++
 kernel/events/uprobes.c                            |  2 +-
 mm/memcontrol.c                                    |  4 +-
 net/ax25/af_ax25.c                                 | 10 ++++-
 net/core/net-sysfs.c                               |  2 +-
 net/ipv4/tcp_input.c                               | 11 ++---
 net/ipv4/tcp_output.c                              | 13 +++---
 net/ipv4/udp.c                                     |  2 +-
 net/ipv6/ip6_gre.c                                 | 11 ++---
 net/ipv6/udp.c                                     |  2 +-
 net/mac80211/rx.c                                  | 26 +++++++++++
 net/rxrpc/ar-output.c                              |  2 +-
 net/rxrpc/ar-recvmsg.c                             |  2 +-
 scripts/decode_stacktrace.sh                       |  4 +-
 sound/core/info.c                                  |  4 +-
 sound/soc/codecs/rt5670.h                          |  2 +-
 tools/perf/builtin-script.c                        | 24 +++++-----
 tools/perf/tests/attr.c                            |  4 +-
 tools/perf/tests/pmu.c                             |  2 +-
 tools/perf/util/annotate.c                         | 14 ++++--
 tools/perf/util/cgroup.c                           |  2 +-
 tools/perf/util/pager.c                            |  5 ++-
 tools/perf/util/parse-events.c                     |  4 +-
 tools/perf/util/pmu.c                              |  2 +-
 tools/perf/util/probe-event.c                      | 21 ++++++---
 tools/perf/util/srcline.c                          | 16 ++++++-
 63 files changed, 347 insertions(+), 143 deletions(-)


