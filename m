Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE45114B595
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 14:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgA1N6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 08:58:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgA1N6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 08:58:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABF2E24691;
        Tue, 28 Jan 2020 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580219926;
        bh=uthAP0MDuwUFeHHH/Y4h57UbLH+kOnjJ8oWss2mj8uU=;
        h=From:To:Cc:Subject:Date:From;
        b=f0By4RDetnkz3sB5/9SI+L8qQGTp25unJFXp0nAil/aaZpixPURMzPVD22uGI0F53
         qgGY87s6UnDGTxG7sPv2x3jvWDgDa6bnckDvf7Zzg4HoGUPrVBsRckcU8ooFLyoYVk
         ZiveMdzVVBnj7kQZQRmYq23ZtTcP+OK6zF1GM/W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/46] 4.14.169-stable review
Date:   Tue, 28 Jan 2020 14:57:34 +0100
Message-Id: <20200128135749.822297911@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.169-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.169-rc1
X-KernelTest-Deadline: 2020-01-30T13:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.169 release.
There are 46 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.169-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.169-rc1

Martin Schiller <ms@dev.tdt.de>
    net/x25: fix nonblocking connect

Kadlecsik József <kadlec@blackhole.kfki.hu>
    netfilter: ipset: use bitmap infrastructure completely

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    md: Avoid namespace collision with bitmap API

Bo Wu <wubo40@huawei.com>
    scsi: iscsi: Avoid potential deadlock in iscsi_if_rx func

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-ioctl.c: zero reserved fields for S/TRY_FMT

Wen Huang <huangwenabc@gmail.com>
    libertas: Fix two buffer overflows at parsing bss descriptor

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: tmc-etf: Do not call smp_processor_id from preemptible

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etb10: Do not call smp_processor_id from preemptible

Masato Suzuki <masato.suzuki@wdc.com>
    sd: Fix REQ_OP_ZONE_REPORT completion handling

Al Viro <viro@zeniv.linux.org.uk>
    do_last(): fetch directory ->i_mode and ->i_uid before it's too late

Changbin Du <changbin.du@gmail.com>
    tracing: xen: Ordered comparison of function pointers

Bart Van Assche <bvanassche@acm.org>
    scsi: RDMA/isert: Fix a recently introduced regression related to logout

Gilles Buloz <gilles.buloz@kontron.com>
    hwmon: (nct7802) Fix voltage limits to wrong registers

Chuhong Yuan <hslester96@gmail.com>
    Input: sun4i-ts - add a check for devm_thermal_zone_of_sensor_register

Johan Hovold <johan@kernel.org>
    Input: pegasus_notetaker - fix endpoint sanity check

Johan Hovold <johan@kernel.org>
    Input: aiptek - fix endpoint sanity check

Johan Hovold <johan@kernel.org>
    Input: gtco - fix endpoint sanity check

Johan Hovold <johan@kernel.org>
    Input: sur40 - fix interface sanity checks

Stephan Gerhold <stephan@gerhold.net>
    Input: pm8xxx-vib - fix handling of separate enable register

Jeremy Linton <jeremy.linton@arm.com>
    Documentation: Document arm64 kpti control

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    mmc: sdhci: fix minimum clock rate for v3 controller

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    mmc: tegra: fix SDR50 tuning override

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 8950/1: ftrace/recordmcount: filter relocation types

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    Revert "Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers"

Johan Hovold <johan@kernel.org>
    Input: keyspan-remote - fix control-message timeouts

Guenter Roeck <linux@roeck-us.net>
    hwmon: (core) Do not use device managed functions for memory allocations

Dmitry Osipenko <digetx@gmail.com>
    hwmon: (core) Fix double-free in __hwmon_device_register()

Linus Walleij <linus.walleij@linaro.org>
    hwmon: Deal with errors from the thermal subsystem

Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
    hwmon: (adt7475) Make volt2reg return same reg as reg2volt input

Eric Dumazet <edumazet@google.com>
    net: rtnetlink: validate IFLA_MTU attribute in rtnl_create_link()

Wen Yang <wenyang@linux.alibaba.com>
    tcp_bbr: improve arithmetic division in bbr_update_bw()

James Hughes <james.hughes@raspberrypi.org>
    net: usb: lan78xx: Add .ndo_features_check

Jouni Hogander <jouni.hogander@unikie.com>
    net-sysfs: Fix reference count leak

Jouni Hogander <jouni.hogander@unikie.com>
    net-sysfs: Call dev_hold always in rx_queue_add_kobject

Jouni Hogander <jouni.hogander@unikie.com>
    net-sysfs: Call dev_hold always in netdev_queue_add_kobject

Eric Dumazet <edumazet@google.com>
    net-sysfs: fix netdev_queue_add_kobject() breakage

Jouni Hogander <jouni.hogander@unikie.com>
    net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix datalen for ematch

William Dauchy <w.dauchy@criteo.com>
    net, ip_tunnel: fix namespaces move

William Dauchy <w.dauchy@criteo.com>
    net, ip6_tunnel: fix namespaces move

Michael Ellerman <mpe@ellerman.id.au>
    net: cxgb3_main: Add CAP_NET_ADMIN check to CHELSIO_GET_MEM

Yuki Taguchi <tagyounit@gmail.com>
    ipv6: sr: remove SKB_GSO_IPXIP6 on End.D* actions

Eric Dumazet <edumazet@google.com>
    gtp: make sure only SOCK_DGRAM UDP sockets are accepted

Wenwen Wang <wenwen@cs.uga.edu>
    firestream: fix memory leaks

Richard Palethorpe <rpalethorpe@suse.com>
    can, slip: Protect tty->disc_data in write_wakeup and close with RCU


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt |  6 ++
 Makefile                                        |  4 +-
 drivers/atm/firestream.c                        |  3 +
 drivers/hwmon/adt7475.c                         |  5 +-
 drivers/hwmon/hwmon.c                           | 83 ++++++++++++++++---------
 drivers/hwmon/nct7802.c                         |  4 +-
 drivers/hwtracing/coresight/coresight-etb10.c   |  4 +-
 drivers/hwtracing/coresight/coresight-tmc-etf.c |  4 +-
 drivers/infiniband/ulp/isert/ib_isert.c         | 12 ----
 drivers/input/misc/keyspan_remote.c             |  9 ++-
 drivers/input/misc/pm8xxx-vibrator.c            |  2 +-
 drivers/input/rmi4/rmi_smbus.c                  |  2 +
 drivers/input/tablet/aiptek.c                   |  6 +-
 drivers/input/tablet/gtco.c                     | 10 +--
 drivers/input/tablet/pegasus_notetaker.c        |  2 +-
 drivers/input/touchscreen/sun4i-ts.c            |  6 +-
 drivers/input/touchscreen/sur40.c               |  2 +-
 drivers/md/bitmap.c                             | 10 +--
 drivers/md/bitmap.h                             |  2 +-
 drivers/md/md-cluster.c                         |  6 +-
 drivers/media/v4l2-core/v4l2-ioctl.c            | 24 +++----
 drivers/mmc/host/sdhci-tegra.c                  |  2 +-
 drivers/mmc/host/sdhci.c                        | 10 +--
 drivers/net/can/slcan.c                         | 12 +++-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c |  2 +
 drivers/net/gtp.c                               | 10 +--
 drivers/net/slip/slip.c                         | 12 +++-
 drivers/net/usb/lan78xx.c                       | 15 +++++
 drivers/net/wireless/marvell/libertas/cfg.c     | 16 ++++-
 drivers/scsi/scsi_transport_iscsi.c             |  7 +++
 drivers/scsi/sd.c                               |  8 ++-
 drivers/target/iscsi/iscsi_target.c             |  6 +-
 fs/namei.c                                      | 17 ++---
 include/linux/bitmap.h                          |  8 +++
 include/linux/netdevice.h                       |  1 +
 include/linux/netfilter/ipset/ip_set.h          |  7 ---
 include/trace/events/xen.h                      |  6 +-
 lib/bitmap.c                                    | 20 ++++++
 net/core/dev.c                                  | 36 +++++++----
 net/core/net-sysfs.c                            | 39 +++++++-----
 net/core/rtnetlink.c                            | 13 +++-
 net/ipv4/ip_tunnel.c                            |  4 +-
 net/ipv4/tcp_bbr.c                              |  3 +-
 net/ipv6/ip6_tunnel.c                           |  4 +-
 net/ipv6/seg6_local.c                           |  4 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h         |  2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c          |  6 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c       |  6 +-
 net/netfilter/ipset/ip_set_bitmap_port.c        |  6 +-
 net/sched/ematch.c                              |  2 +-
 net/x25/af_x25.c                                |  6 +-
 scripts/recordmcount.c                          | 17 +++++
 52 files changed, 336 insertions(+), 177 deletions(-)


