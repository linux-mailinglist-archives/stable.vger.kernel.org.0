Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C00E1E2EB9
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390441AbgEZS66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390433AbgEZS64 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:58:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E2262084C;
        Tue, 26 May 2020 18:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519535;
        bh=kZ9mboQE3/aQsUhpCHZB6N4PwuNWxmxxb5lYCPPbQYI=;
        h=From:To:Cc:Subject:Date:From;
        b=WwM4WHXENvMfqM5ld4T7DABp05p8liSP2mIfITmpU0dw/9rs/erc5KRZCh56j2GuT
         u4TSiq3lfA7K3Cdeo0ba1nwhnq35KhukA+KhILV1uPbpOJR7+QgOYym8VWusG+YUvV
         vR3L/CKQ1jscDxm3wgwUjR6gRpWdOvEDBuxneJ5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/64] 4.9.225-rc1 review
Date:   Tue, 26 May 2020 20:52:29 +0200
Message-Id: <20200526183913.064413230@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.225-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.225-rc1
X-KernelTest-Deadline: 2020-05-28T18:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.225 release.
There are 64 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.225-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.225-rc1

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: sca3000: Remove an erroneous 'get_device()'

John Hubbard <jhubbard@nvidia.com>
    rapidio: fix an error in get_user_pages_fast() error handling

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: release me_cl object reference

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: dac: vf610: Fix an error handling path in 'vf610_dac_probe()'

Oscar Carter <oscar.carter@gmx.com>
    staging: greybus: Fix uninitialized scalar variable

Dragos Bogdan <dragos.bogdan@analog.com>
    staging: iio: ad2s1210: Fix SPI reading

Bob Peterson <rpeterso@redhat.com>
    Revert "gfs2: Don't demote a glock until its revokes are written"

Arjun Vynipadath <arjun@chelsio.com>
    cxgb4/cxgb4vf: Fix mac_hlist initialization and free

Arjun Vynipadath <arjun@chelsio.com>
    cxgb4: free mac_hlist properly

Vishal Verma <vishal.l.verma@intel.com>
    libnvdimm/btt: Remove unnecessary code in btt_freelist_init

Colin Ian King <colin.king@canonical.com>
    platform/x86: alienware-wmi: fix kfree on potentially uninitialized pointer

Arnd Bergmann <arnd@arndb.de>
    ubsan: build ubsan.c more conservatively

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess, ubsan: Fix UBSAN vs. SMAP

R. Parameswaran <parameswaran.r7@gmail.com>
    l2tp: device MTU setup, tunnel socket needs a lock

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: tegra210-adma: Fix an error handling path in 'tegra_adma_probe()'

Brent Lu <brent.lu@intel.com>
    ALSA: pcm: fix incorrect hw_base increase

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: initialise PPP sessions before registering them

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: protect sock pointer of struct pppol2tp_session with RCU

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: initialise l2tp_eth sessions before registering them

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: don't register sessions in l2tp_session_create()

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: fix l2tp_eth module loading

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: pass tunnel pointer to ->session_create()

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: prevent creation of sessions on terminated tunnels

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: hold tunnel used while creating sessions with netlink

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: hold tunnel while handling genl TUNNEL_GET commands

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: hold tunnel while handling genl tunnel updates

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: hold tunnel while processing genl delete command

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: hold tunnel while looking up sessions in l2tp_netlink

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: initialise session's refcount before making it reachable

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: define parameters of l2tp_tunnel_find*() as "const"

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: define parameters of l2tp_session_get*() as "const"

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: remove l2tp_session_find()

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: remove useless duplicate session detection in l2tp_netlink

R. Parameswaran <parameswaran.r7@gmail.com>
    L2TP:Adjust intf MTU, add underlay L3, L2 hdrs.

R. Parameswaran <parameswaran.r7@gmail.com>
    New kernel function to get IP overhead on a socket.

Asbjørn Sloth Tønnesen <asbjorn@asbjorn.st>
    net: l2tp: ppp: change PPPOL2TP_MSG_* => L2TP_MSG_*

Asbjørn Sloth Tønnesen <asbjorn@asbjorn.st>
    net: l2tp: deprecate PPPOL2TP_MSG_* in favour of L2TP_MSG_*

Asbjørn Sloth Tønnesen <asbjorn@asbjorn.st>
    net: l2tp: export debug flags to UAPI

Kevin Hao <haokexin@gmail.com>
    watchdog: Fix the race between the release of watchdog_core_data and cdev

Christoph Hellwig <hch@lst.de>
    arm64: fix the flush_icache_range arguments in machine_kexec

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: purge get_cpu and reorder_via_wq from padata_do_serial

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: initialize pd->cpu with effective cpumask

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Replace delayed timer with immediate workqueue in padata_reorder

Mathias Krause <minipli@googlemail.com>
    padata: set cpu_index of unused CPUs to -1

Kevin Hao <haokexin@gmail.com>
    i2c: dev: Fix the race between the release of i2c_dev and cdev

Thomas Gleixner <tglx@linutronix.de>
    ARM: futex: Address build warning

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-nb-wmi: Do not load on Asus T100TA and T200TA

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix misleading driver bug report

Wu Bo <wubo40@huawei.com>
    ceph: fix double unlock in handle_cap_export()

Yoshiyuki Kurauchi <ahochauwaaaaa@gmail.com>
    gtp: set NLM_F_MULTI flag in gtp_genl_dump_pdp()

James Hilliard <james.hilliard1@gmail.com>
    component: Silence bind error on -EPROBE_DEFER

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    configfs: fix config_item refcnt leak in configfs_rmdir()

Sebastian Reichel <sebastian.reichel@collabora.com>
    HID: multitouch: add eGalaxTouch P80H84 support

Frédéric Pierret (fepitre) <frederic.pierret@qubes-os.org>
    gcc-common.h: Update for GCC 10

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: mux: demux-pinctrl: Fix an error handling path in 'i2c_demux_pinctrl_probe()'

Alexander Monakov <amonakov@ispras.ru>
    iommu/amd: Fix over-read of ACPI UID from IVRS table

Al Viro <viro@zeniv.linux.org.uk>
    fix multiplication overflow in copy_fdtable()

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Fix return value of ima_write_policy()

Roberto Sassu <roberto.sassu@huawei.com>
    evm: Check also if *tfm is an error pointer in init_desc()

Mathias Krause <minipli@googlemail.com>
    padata: ensure padata_do_serial() runs on the correct CPU

Mathias Krause <minipli@googlemail.com>
    padata: ensure the reorder timer callback runs on the correct CPU

Jason A. Donenfeld <Jason@zx2c4.com>
    padata: get_next is never NULL

Tobias Klauser <tklauser@distanz.ch>
    padata: Remove unused but set variables

Cao jin <caoj.fnst@cn.fujitsu.com>
    igb: use igb_adapter->io_addr instead of e1000_hw->hw_addr


-------------

Diffstat:

 Documentation/networking/l2tp.txt                  |   8 +-
 Makefile                                           |   4 +-
 arch/arm/include/asm/futex.h                       |   9 +-
 arch/arm64/kernel/machine_kexec.c                  |   3 +-
 drivers/base/component.c                           |   8 +-
 drivers/dma/tegra210-adma.c                        |   2 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-multitouch.c                       |   3 +
 drivers/i2c/i2c-dev.c                              |  48 ++--
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |   1 +
 drivers/iio/dac/vf610_dac.c                        |   1 +
 drivers/iommu/amd_iommu_init.c                     |   9 +-
 drivers/misc/mei/client.c                          |   2 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  13 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   6 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   4 +-
 drivers/net/gtp.c                                  |   9 +-
 drivers/nvdimm/btt.c                               |   8 +-
 drivers/platform/x86/alienware-wmi.c               |  17 +-
 drivers/platform/x86/asus-nb-wmi.c                 |  24 ++
 drivers/rapidio/devices/rio_mport_cdev.c           |   5 +
 drivers/staging/greybus/uart.c                     |   4 +-
 drivers/staging/iio/accel/sca3000_ring.c           |   2 +-
 drivers/staging/iio/resolver/ad2s1210.c            |  17 +-
 drivers/usb/core/message.c                         |   4 +-
 drivers/watchdog/watchdog_dev.c                    |  67 ++---
 fs/ceph/caps.c                                     |   1 +
 fs/configfs/dir.c                                  |   1 +
 fs/file.c                                          |   2 +-
 fs/gfs2/glock.c                                    |   3 -
 include/linux/net.h                                |   3 +
 include/linux/padata.h                             |  13 +-
 include/uapi/linux/if_pppol2tp.h                   |  13 +-
 include/uapi/linux/l2tp.h                          |  17 +-
 kernel/padata.c                                    |  88 +++---
 lib/Makefile                                       |   2 +
 net/l2tp/l2tp_core.c                               | 174 ++++--------
 net/l2tp/l2tp_core.h                               |  46 +--
 net/l2tp/l2tp_eth.c                                | 216 ++++++++------
 net/l2tp/l2tp_netlink.c                            |  79 +++---
 net/l2tp/l2tp_ppp.c                                | 309 ++++++++++++---------
 net/socket.c                                       |  46 +++
 scripts/gcc-plugins/Makefile                       |   1 +
 scripts/gcc-plugins/gcc-common.h                   |   4 +
 security/integrity/evm/evm_crypto.c                |   2 +-
 security/integrity/ima/ima_fs.c                    |   3 +-
 sound/core/pcm_lib.c                               |   1 +
 47 files changed, 734 insertions(+), 569 deletions(-)


