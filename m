Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1FD56A777
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 18:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbiGGQJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 12:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235915AbiGGQI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 12:08:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6F128E36;
        Thu,  7 Jul 2022 09:08:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4BC9B8229A;
        Thu,  7 Jul 2022 16:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162AFC3411E;
        Thu,  7 Jul 2022 16:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657210124;
        bh=1EkNfHvqoCIjhJ25F6isv7orxtnEbwmvS6KKDcbXic0=;
        h=From:To:Cc:Subject:Date:From;
        b=QI7xvJfipkADu9H5R+bGQ3+MChtxkSKLlRZF+a6iZaTv9xmWzOehemVH72gHMCoyP
         LQWzJ/NBGuH/9VbxVUUf4vckJM7nJENPskLfN9nEb9QtOB/VSpNrxponwRZLEG8Al6
         EjvVxu04cc7my3dcEFZ8ThmWdzSRvfH+0OAMNjw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.204
Date:   Thu,  7 Jul 2022 18:08:29 +0200
Message-Id: <1657210109104219@kroah.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.204 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                   |    2 
 arch/arm/xen/p2m.c                                         |    6 
 arch/powerpc/include/asm/bpf_perf_event.h                  |    9 
 arch/powerpc/include/uapi/asm/bpf_perf_event.h             |    9 
 arch/powerpc/kernel/prom_init_check.sh                     |    2 
 arch/s390/Kconfig                                          |    1 
 arch/s390/crypto/arch_random.c                             |  111 -----
 arch/s390/include/asm/archrandom.h                         |   21 -
 arch/s390/kernel/setup.c                                   |    5 
 drivers/block/xen-blkfront.c                               |   56 ++
 drivers/clocksource/timer-ixp4xx.c                         |    1 
 drivers/devfreq/event/exynos-ppmu.c                        |    8 
 drivers/hwmon/ibmaem.c                                     |   12 
 drivers/infiniband/hw/qedr/qedr.h                          |    1 
 drivers/infiniband/hw/qedr/verbs.c                         |    4 
 drivers/md/dm-raid.c                                       |   34 -
 drivers/md/raid5.c                                         |    1 
 drivers/net/bonding/bond_3ad.c                             |    3 
 drivers/net/bonding/bond_alb.c                             |    2 
 drivers/net/caif/caif_virtio.c                             |   10 
 drivers/net/dsa/bcm_sf2.c                                  |    5 
 drivers/net/tun.c                                          |   15 
 drivers/net/usb/ax88179_178a.c                             |  101 ++++-
 drivers/net/usb/qmi_wwan.c                                 |    2 
 drivers/net/usb/usbnet.c                                   |    4 
 drivers/net/virtio_net.c                                   |    8 
 drivers/net/xen-netfront.c                                 |   52 ++
 drivers/nfc/nfcmrvl/i2c.c                                  |    6 
 drivers/nfc/nfcmrvl/spi.c                                  |    6 
 drivers/nfc/nxp-nci/i2c.c                                  |    3 
 drivers/nvdimm/bus.c                                       |    4 
 drivers/xen/gntdev-common.h                                |    8 
 drivers/xen/gntdev.c                                       |  147 +++++--
 include/linux/dim.h                                        |    2 
 net/ipv6/addrconf.c                                        |    4 
 net/ipv6/route.c                                           |    9 
 net/ipv6/seg6_hmac.c                                       |    1 
 net/ipv6/sit.c                                             |   10 
 net/netfilter/nft_set_hash.c                               |    2 
 net/rose/rose_timer.c                                      |   34 +
 net/sched/act_api.c                                        |   22 -
 net/sunrpc/xdr.c                                           |    2 
 tools/testing/selftests/net/udpgso_bench.sh                |    2 
 tools/testing/selftests/rseq/Makefile                      |    2 
 tools/testing/selftests/rseq/basic_percpu_ops_test.c       |    5 
 tools/testing/selftests/rseq/compiler.h                    |   30 +
 tools/testing/selftests/rseq/param_test.c                  |    8 
 tools/testing/selftests/rseq/rseq-abi.h                    |  151 +++++++
 tools/testing/selftests/rseq/rseq-arm.h                    |  110 ++---
 tools/testing/selftests/rseq/rseq-arm64.h                  |   79 ++--
 tools/testing/selftests/rseq/rseq-generic-thread-pointer.h |   25 +
 tools/testing/selftests/rseq/rseq-mips.h                   |   71 ---
 tools/testing/selftests/rseq/rseq-ppc-thread-pointer.h     |   30 +
 tools/testing/selftests/rseq/rseq-ppc.h                    |  128 ++++--
 tools/testing/selftests/rseq/rseq-s390.h                   |   55 ++
 tools/testing/selftests/rseq/rseq-skip.h                   |    2 
 tools/testing/selftests/rseq/rseq-thread-pointer.h         |   19 +
 tools/testing/selftests/rseq/rseq-x86-thread-pointer.h     |   40 ++
 tools/testing/selftests/rseq/rseq-x86.h                    |  247 +++++++++----
 tools/testing/selftests/rseq/rseq.c                        |  165 ++++----
 tools/testing/selftests/rseq/rseq.h                        |   30 +
 61 files changed, 1289 insertions(+), 655 deletions(-)

Carlo Lobrano (1):
      net: usb: qmi_wwan: add Telit 0x1060 composition

Chris Ye (1):
      nvdimm: Fix badblocks clear off-by-one error

Chuck Lever (1):
      SUNRPC: Fix READ_PLUS crasher

Daniele Palmas (1):
      net: usb: qmi_wwan: add Telit 0x1070 composition

Demi Marie Obenour (1):
      xen/gntdev: Avoid blocking in unmap_grant_pages()

Dimitris Michailidis (1):
      selftests/net: pass ipv6_args to udpgso_bench's IPv6 TCP test

Doug Berger (1):
      net: dsa: bcm_sf2: force pause link settings

Duoming Zhou (1):
      net: rose: fix UAF bugs caused by timer handler

Eric Dumazet (1):
      net: bonding: fix possible NULL deref in rlb code

Greg Kroah-Hartman (2):
      clocksource/drivers/ixp4xx: remove EXPORT_SYMBOL_GPL from ixp4xx_timer_setup()
      Linux 5.4.204

Heinz Mauelshagen (1):
      dm raid: fix accesses beyond end of raid member array

Jakub Kicinski (3):
      net: tun: unlink NAPI from device on destruction
      net: tun: stop NAPI when detaching queues
      net: tun: avoid disabling NAPI twice

Jason A. Donenfeld (1):
      s390/archrandom: simplify back to earlier design and initialize earlier

Jason Wang (2):
      virtio-net: fix race between ndo_open() and virtio_device_ready()
      caif_virtio: fix race between virtio_device_ready() and ndo_open()

Jose Alonso (1):
      net: usb: ax88179_178a: Fix packet receiving

Kamal Heib (1):
      RDMA/qedr: Fix reporting QP timeout attribute

Krzysztof Kozlowski (1):
      nfc: nfcmrvl: Fix irq_of_parse_and_map() return value

Liam Howlett (1):
      powerpc/prom_init: Fix kernel config grep

Masahiro Yamada (1):
      s390: remove unneeded 'select BUILD_BIN2C'

Mathieu Desnoyers (15):
      selftests/rseq: introduce own copy of rseq uapi header
      selftests/rseq: Remove useless assignment to cpu variable
      selftests/rseq: Remove volatile from __rseq_abi
      selftests/rseq: Introduce rseq_get_abi() helper
      selftests/rseq: Introduce thread pointer getters
      selftests/rseq: Uplift rseq selftests for compatibility with glibc-2.35
      selftests/rseq: Fix ppc32: wrong rseq_cs 32-bit field pointer on big endian
      selftests/rseq: Fix ppc32 missing instruction selection "u" and "x" for load/store
      selftests/rseq: Fix ppc32 offsets by using long rather than off_t
      selftests/rseq: Fix warnings about #if checks of undefined tokens
      selftests/rseq: Remove arm/mips asm goto compiler work-around
      selftests/rseq: Fix: work-around asm goto compiler bugs
      selftests/rseq: x86-64: use %fs segment selector for accessing rseq thread area
      selftests/rseq: x86-32: use %gs segment selector for accessing rseq thread area
      selftests/rseq: Change type of rseq_offset to ptrdiff_t

Miaoqian Lin (1):
      PM / devfreq: exynos-ppmu: Fix refcount leak in of_get_devfreq_events

Michael Walle (1):
      NFC: nxp-nci: Don't issue a zero length i2c_master_read()

Mikulas Patocka (1):
      dm raid: fix KASAN warning in raid5_add_disks

Naveen N. Rao (1):
      powerpc/bpf: Fix use of user_pt_regs in uapi

Nicolas Dichtel (1):
      ipv6: take care of disable_policy when restoring routes

Oleksandr Tyshchenko (1):
      xen/arm: Fix race in RB-tree based P2M accounting

Oliver Neukum (1):
      usbnet: fix memory allocation in helpers

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: restore set element counter when failing to update

Peter Oskolkov (1):
      rseq/selftests,x86_64: Add rseq_offset_deref_addv()

Roger Pau Monne (4):
      xen/blkfront: fix leaking data in shared pages
      xen/netfront: fix leaking data in shared pages
      xen/netfront: force data bouncing when backend is untrusted
      xen/blkfront: force data bouncing when backend is untrusted

Shuah Khan (1):
      selftests/rseq: remove ARRAY_SIZE define from individual tests

Tao Liu (1):
      linux/dim: Fix divide by 0 in RDMA DIM

Victor Nogueira (1):
      net/sched: act_api: Notify user space if any actions were flushed before error

Yang Yingliang (1):
      hwmon: (ibmaem) don't call platform_device_del() if platform_device_add() fails

Yevhen Orlov (1):
      net: bonding: fix use-after-free after 802.3ad slave unbind

YueHaibing (1):
      net: ipv6: unexport __init-annotated seg6_hmac_net_init()

katrinzhou (1):
      ipv6/sit: fix ipip6_tunnel_get_prl return value

kernel test robot (1):
      sit: use min

