Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F11B1E2A4F
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388740AbgEZSys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387398AbgEZSys (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:54:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3050B2070A;
        Tue, 26 May 2020 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519285;
        bh=ssOmdl1lUrDtEdA5qUxSUznE0A4vCxEVmtL3rZu3ZLU=;
        h=From:To:Cc:Subject:Date:From;
        b=D+X3P467u/KLpQwVfUBFaKSpT4QYNBQW6dqHyjZUhyE6V89z60nGyL4LRNviiJyhr
         c0DAasfZ/Ny7/+sJH3tjICPZO9foagNRd4O5TwgxblxEfes+RUCRp33tesb96YV1io
         OGPz47ztZbtM5EWGKb6Lr7ZYQ8mLrc84o72FwdXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/65] 4.4.225-rc1 review
Date:   Tue, 26 May 2020 20:52:19 +0200
Message-Id: <20200526183905.988782958@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.225-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.225-rc1
X-KernelTest-Deadline: 2020-05-28T18:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.225 release.
There are 65 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.225-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.225-rc1

R. Parameswaran <parameswaran.r7@gmail.com>
    l2tp: device MTU setup, tunnel socket needs a lock

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: sca3000: Remove an erroneous 'get_device()'

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: release me_cl object reference

Dragos Bogdan <dragos.bogdan@analog.com>
    staging: iio: ad2s1210: Fix SPI reading

Bob Peterson <rpeterso@redhat.com>
    Revert "gfs2: Don't demote a glock until its revokes are written"

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

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: don't use l2tp_tunnel_find() in l2tp_ip and l2tp_ip6

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: take a reference on sessions used in genetlink handlers

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: hold session while sending creation notifications

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: fix racy socket lookup in l2tp_ip and l2tp_ip6 bind()

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: lock socket before checking flags in connect()

Vishal Verma <vishal.l.verma@intel.com>
    libnvdimm/btt: Remove unnecessary code in btt_freelist_init

Colin Ian King <colin.king@canonical.com>
    platform/x86: alienware-wmi: fix kfree on potentially uninitialized pointer

Theodore Ts'o <tytso@mit.edu>
    ext4: lock the xattr block before checksuming it

Brent Lu <brent.lu@intel.com>
    ALSA: pcm: fix incorrect hw_base increase

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: purge get_cpu and reorder_via_wq from padata_do_serial

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: initialize pd->cpu with effective cpumask

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Replace delayed timer with immediate workqueue in padata_reorder

Peter Zijlstra <peterz@infradead.org>
    sched/fair, cpumask: Export for_each_cpu_wrap()

Mathias Krause <minipli@googlemail.com>
    padata: set cpu_index of unused CPUs to -1

Kevin Hao <haokexin@gmail.com>
    i2c: dev: Fix the race between the release of i2c_dev and cdev

viresh kumar <viresh.kumar@linaro.org>
    i2c-dev: don't get i2c adapter via i2c_dev

Dan Carpenter <dan.carpenter@oracle.com>
    i2c: dev: use after free in detach

Wolfram Sang <wsa@the-dreams.de>
    i2c: dev: don't start function name with 'return'

Erico Nunes <erico.nunes@datacom.ind.br>
    i2c: dev: switch from register_chrdev to cdev API

Shuah Khan <shuahkh@osg.samsung.com>
    media: fix media devnode ioctl/syscall and unregister race

Shuah Khan <shuahkh@osg.samsung.com>
    media: fix use-after-free in cdev_put() when app exits after driver unbind

Mauro Carvalho Chehab <mchehab@osg.samsung.com>
    media-device: dynamically allocate struct media_devnode

Mauro Carvalho Chehab <mchehab@osg.samsung.com>
    media-devnode: fix namespace mess

Max Kellermann <max@duempel.org>
    media-devnode: add missing mutex lock in error handler

Max Kellermann <max@duempel.org>
    drivers/media/media-devnode: clear private_data before put_device()

Shuah Khan <shuahkh@osg.samsung.com>
    media: Fix media_open() to clear filp->private_data in error leg

Thomas Gleixner <tglx@linutronix.de>
    ARM: futex: Address build warning

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-nb-wmi: Do not load on Asus T100TA and T200TA

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix misleading driver bug report

Wu Bo <wubo40@huawei.com>
    ceph: fix double unlock in handle_cap_export()

Sebastian Reichel <sebastian.reichel@collabora.com>
    HID: multitouch: add eGalaxTouch P80H84 support

Al Viro <viro@zeniv.linux.org.uk>
    fix multiplication overflow in copy_fdtable()

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

 Documentation/networking/l2tp.txt         |   8 +-
 Makefile                                  |   4 +-
 arch/arm/include/asm/futex.h              |   9 +-
 drivers/hid/hid-ids.h                     |   1 +
 drivers/hid/hid-multitouch.c              |   3 +
 drivers/i2c/i2c-dev.c                     |  60 +++---
 drivers/media/media-device.c              |  43 +++--
 drivers/media/media-devnode.c             | 168 +++++++++-------
 drivers/media/usb/uvc/uvc_driver.c        |   2 +-
 drivers/misc/mei/client.c                 |   2 +
 drivers/net/ethernet/intel/igb/igb_main.c |   4 +-
 drivers/nvdimm/btt.c                      |   8 +-
 drivers/platform/x86/alienware-wmi.c      |  17 +-
 drivers/platform/x86/asus-nb-wmi.c        |  24 +++
 drivers/staging/iio/accel/sca3000_ring.c  |   2 +-
 drivers/staging/iio/resolver/ad2s1210.c   |  17 +-
 drivers/usb/core/message.c                |   4 +-
 fs/ceph/caps.c                            |   1 +
 fs/ext4/xattr.c                           |  66 ++++---
 fs/file.c                                 |   2 +-
 fs/gfs2/glock.c                           |   3 -
 include/linux/cpumask.h                   |  17 ++
 include/linux/net.h                       |   3 +
 include/linux/padata.h                    |  13 +-
 include/media/media-device.h              |   5 +-
 include/media/media-devnode.h             |  32 +++-
 include/net/ipv6.h                        |   2 +
 include/uapi/linux/if_pppol2tp.h          |  13 +-
 include/uapi/linux/l2tp.h                 |  17 +-
 kernel/padata.c                           |  88 ++++-----
 lib/cpumask.c                             |  32 ++++
 net/ipv6/datagram.c                       |   4 +-
 net/l2tp/l2tp_core.c                      | 181 ++++++-----------
 net/l2tp/l2tp_core.h                      |  47 +++--
 net/l2tp/l2tp_eth.c                       | 216 +++++++++++++--------
 net/l2tp/l2tp_ip.c                        |  68 ++++---
 net/l2tp/l2tp_ip6.c                       |  82 ++++----
 net/l2tp/l2tp_netlink.c                   | 124 +++++++-----
 net/l2tp/l2tp_ppp.c                       | 309 ++++++++++++++++++------------
 net/socket.c                              |  46 +++++
 security/integrity/evm/evm_crypto.c       |   2 +-
 sound/core/pcm_lib.c                      |   1 +
 42 files changed, 1014 insertions(+), 736 deletions(-)


