Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 357CD111BCF
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfLCWhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:37:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727774AbfLCWhn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:37:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D58AC20684;
        Tue,  3 Dec 2019 22:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412662;
        bh=j1s6Vxfz6TgoRKDLJJA32TTXRQmC3xnfYT4jXsZap+o=;
        h=From:To:Cc:Subject:Date:From;
        b=2uniq2ROeMoF8Q+ZT0xIkWlf3zaRkq8m0CqVprbrZTL+B9Ck0EHXdAVC+1ziKcOAr
         6cUmj0M0cOZnKFUGaGVTvUDGjQ5CpDbIzPKMpkvUJbWT8MO6+L9KnDiMGVgzpZcIX4
         A7/Vt/ETZO1iD4rcvDjcXhN2uxbCGDjpIASEPhH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/46] 5.4.2-stable review
Date:   Tue,  3 Dec 2019 23:35:20 +0100
Message-Id: <20191203212705.175425505@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.2-rc1
X-KernelTest-Deadline: 2019-12-05T21:28+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.2 release.
There are 46 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 05 Dec 2019 21:20:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.2-rc1

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Fix ACPI errors caused by passing 0 as input size

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer

Candle Sun <candle.sun@unisoc.com>
    HID: core: check whether Usage Page item is after Usage ID items

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: talitos - Fix build error by selecting LIB_DES

Joel Stanley <joel@jms.id.au>
    Revert "jffs2: Fix possible null-pointer dereferences in jffs2_add_frag_to_fragtree()"

Theodore Ts'o <tytso@mit.edu>
    ext4: add more paranoia checking in ext4_expand_extra_isize handling

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix resume on cable plug-in

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix jumbo configuration for RTL8168evl

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    selftests: pmtu: use -oneline for ip route list cache

John Rutherford <john.rutherford@dektech.com.au>
    tipc: fix link name length check

Jakub Kicinski <jakub.kicinski@netronome.com>
    selftests: bpf: correct perror strings

Jakub Kicinski <jakub.kicinski@netronome.com>
    selftests: bpf: test_sockmap: handle file creation failures gracefully

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: use sg_next() to walk sg entries

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: remove the dead inplace_crypto code

Jakub Kicinski <jakub.kicinski@netronome.com>
    selftests/tls: add a test for fragmented messages

Jakub Kicinski <jakub.kicinski@netronome.com>
    net: skmsg: fix TLS 1.3 crash with full sk_msg

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: free the record on encryption error

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: take into account that bpf_exec_tx_verdict() may free the record

Paolo Abeni <pabeni@redhat.com>
    openvswitch: remove another BUG_ON()

Paolo Abeni <pabeni@redhat.com>
    openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()

Xin Long <lucien.xin@gmail.com>
    sctp: cache netns in sctp_ep_common

Jouni Hogander <jouni.hogander@unikie.com>
    slip: Fix use-after-free Read in slip_open

Navid Emamdoost <navid.emamdoost@gmail.com>
    sctp: Fix memory leak in sctp_sf_do_5_2_4_dupcook

Paolo Abeni <pabeni@redhat.com>
    openvswitch: fix flow command message size

Dust Li <dust.li@linux.alibaba.com>
    net: sched: fix `tc -s class show` no bstats on class with nolock subqueues

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: psample: fix skb_over_panic

Chuhong Yuan <hslester96@gmail.com>
    net: macb: add missed tasklet_kill

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: sja1105: fix sja1105_parse_rgmii_delays()

David Bauer <mail@david-bauer.net>
    mdio_bus: don't use managed reset-controller

Menglong Dong <dong.menglong@zte.com.cn>
    macvlan: schedule bc_work even if error

Jeroen de Borst <jeroendb@google.com>
    gve: Fix the queue page list allocated pages count

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    x86/fpu: Don't cache access to fpu_fpregs_owner_ctx

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Power cycle the router if NVM authentication fails

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add comet point V device id

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus: prefix device names on bus with the bus name

Fabio D'Urso <fabiodurso@hotmail.it>
    USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P

Hans de Goede <hdegoede@redhat.com>
    staging: rtl8723bs: Add 024c:0525 to the list of SDIO device-ids

Hans de Goede <hdegoede@redhat.com>
    staging: rtl8723bs: Drop ACPI device ids

Pan Bian <bianpan2016@163.com>
    staging: rtl8192e: fix potential use after free

Ajay Singh <ajay.kathat@microchip.com>
    staging: wilc1000: fix illegal memory access in wilc_parse_join_bss_param()

Mathias Kresin <dev@kresin.me>
    usb: dwc2: use a longer core rest timeout in dwc2_core_reset()

Sami Tolvanen <samitolvanen@google.com>
    driver core: platform: use the correct callback type for bus_find_device

Pascal van Leeuwen <pascalvanl@gmail.com>
    crypto: inside-secure - Fix stability issue with Macchiatobin

Jens Axboe <axboe@kernel.dk>
    net: disallow ancillary data for __sys_{send,recv}msg_file()

Jens Axboe <axboe@kernel.dk>
    net: separate out the msghdr copy from ___sys_{send,recv}msg()

Jens Axboe <axboe@kernel.dk>
    io_uring: async workers should inherit the user creds


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/x86/include/asm/fpu/internal.h          |   2 +-
 drivers/base/platform.c                      |   7 +-
 drivers/crypto/Kconfig                       |   1 +
 drivers/crypto/inside-secure/safexcel.c      |   4 +-
 drivers/hid/hid-core.c                       |  51 +++++++-
 drivers/misc/mei/bus.c                       |   9 +-
 drivers/misc/mei/hw-me-regs.h                |   1 +
 drivers/misc/mei/pci-me.c                    |   1 +
 drivers/net/dsa/sja1105/sja1105_main.c       |  10 +-
 drivers/net/ethernet/cadence/macb_main.c     |   1 +
 drivers/net/ethernet/google/gve/gve_main.c   |   3 +-
 drivers/net/ethernet/realtek/r8169_main.c    |   3 +-
 drivers/net/macvlan.c                        |   3 +-
 drivers/net/phy/mdio_bus.c                   |   6 +-
 drivers/net/slip/slip.c                      |   1 +
 drivers/platform/x86/hp-wmi.c                |  10 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c |   5 +-
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c |   7 +-
 drivers/staging/wilc1000/wilc_hif.c          |  25 ++--
 drivers/thunderbolt/switch.c                 |  54 ++++++--
 drivers/usb/dwc2/core.c                      |   2 +-
 drivers/usb/serial/ftdi_sio.c                |   3 +
 drivers/usb/serial/ftdi_sio_ids.h            |   7 +
 fs/ext4/inode.c                              |  15 +++
 fs/ext4/super.c                              |  21 +--
 fs/io_uring.c                                |  23 +++-
 fs/jffs2/nodelist.c                          |   2 +-
 include/linux/skmsg.h                        |  26 ++--
 include/net/sctp/structs.h                   |   3 +
 include/net/tls.h                            |   3 +-
 net/core/filter.c                            |   8 +-
 net/core/skmsg.c                             |   2 +-
 net/ipv4/tcp_bpf.c                           |   2 +-
 net/openvswitch/datapath.c                   |  17 ++-
 net/psample/psample.c                        |   2 +-
 net/sched/sch_mq.c                           |   3 +-
 net/sched/sch_mqprio.c                       |   4 +-
 net/sched/sch_multiq.c                       |   2 +-
 net/sched/sch_prio.c                         |   2 +-
 net/sctp/associola.c                         |   1 +
 net/sctp/endpointola.c                       |   1 +
 net/sctp/input.c                             |   4 +-
 net/sctp/sm_statefuns.c                      |   4 +-
 net/socket.c                                 | 184 +++++++++++++++++++--------
 net/tipc/netlink_compat.c                    |   4 +-
 net/tls/tls_main.c                           |  13 +-
 net/tls/tls_sw.c                             |  32 +++--
 tools/testing/selftests/bpf/test_sockmap.c   |  47 ++++---
 tools/testing/selftests/bpf/xdping.c         |   2 +-
 tools/testing/selftests/net/pmtu.sh          |   5 +-
 tools/testing/selftests/net/tls.c            |  60 +++++++++
 52 files changed, 505 insertions(+), 207 deletions(-)


