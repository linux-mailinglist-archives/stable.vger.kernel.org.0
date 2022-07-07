Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A442156A785
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 18:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbiGGQJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 12:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbiGGQJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 12:09:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E69C5070D;
        Thu,  7 Jul 2022 09:08:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E751EB82124;
        Thu,  7 Jul 2022 16:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305B7C3411E;
        Thu,  7 Jul 2022 16:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657210130;
        bh=53+9lI0HiTe8k37yOsxeaYdZ3knHZsx+TmdU5TVyY4g=;
        h=From:To:Cc:Subject:Date:From;
        b=kzXdIgX7okMZ5nvR9vvU0CpifgrTvVj0Jpx+cAW11owib+yAbxwiUb6EWuK9kHgF2
         uTDT4Cm6Wse7433wVwQ6mZDEHWGfSy5Kv4s3wTF5TTCKEB0IH5PajJZtbNnSeo430C
         6X1DR/6pEHOPtDPtaBQ9Ig6rHsjyCyFZmUO1KwKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.129
Date:   Thu,  7 Jul 2022 18:08:34 +0200
Message-Id: <16572101145372@kroah.com>
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

I'm announcing the release of the 5.10.129 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
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
 arch/powerpc/mm/nohash/book3e_pgtable.c                    |    6 
 arch/s390/Kconfig                                          |    1 
 arch/s390/crypto/arch_random.c                             |  111 -------
 arch/s390/include/asm/archrandom.h                         |   13 
 arch/s390/kernel/setup.c                                   |    5 
 drivers/block/xen-blkfront.c                               |   56 ++-
 drivers/clocksource/timer-ixp4xx.c                         |    1 
 drivers/cpufreq/qoriq-cpufreq.c                            |    1 
 drivers/devfreq/event/exynos-ppmu.c                        |    8 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c                 |    3 
 drivers/hwmon/ibmaem.c                                     |   12 
 drivers/infiniband/core/cm.c                               |    4 
 drivers/infiniband/hw/qedr/qedr.h                          |    1 
 drivers/infiniband/hw/qedr/verbs.c                         |    4 
 drivers/md/dm-raid.c                                       |   34 +-
 drivers/md/raid5.c                                         |    1 
 drivers/net/bonding/bond_3ad.c                             |    3 
 drivers/net/bonding/bond_alb.c                             |    2 
 drivers/net/caif/caif_virtio.c                             |   10 
 drivers/net/dsa/bcm_sf2.c                                  |    5 
 drivers/net/ethernet/smsc/epic100.c                        |    4 
 drivers/net/phy/dp83822.c                                  |    4 
 drivers/net/tun.c                                          |   15 
 drivers/net/usb/ax88179_178a.c                             |  101 ++++--
 drivers/net/usb/qmi_wwan.c                                 |    2 
 drivers/net/usb/usbnet.c                                   |    4 
 drivers/net/virtio_net.c                                   |    8 
 drivers/net/xen-netfront.c                                 |   56 +++
 drivers/nfc/nfcmrvl/i2c.c                                  |    6 
 drivers/nfc/nfcmrvl/spi.c                                  |    6 
 drivers/nfc/nxp-nci/i2c.c                                  |    3 
 drivers/nvdimm/bus.c                                       |    4 
 drivers/nvme/host/pci.c                                    |    3 
 drivers/xen/gntdev-common.h                                |    7 
 drivers/xen/gntdev.c                                       |  140 ++++++---
 fs/io_uring.c                                              |    4 
 fs/iomap/buffered-io.c                                     |    7 
 fs/nfsd/vfs.c                                              |    3 
 fs/xfs/libxfs/xfs_btree.c                                  |   12 
 fs/xfs/libxfs/xfs_sb.c                                     |   16 -
 fs/xfs/xfs_aops.c                                          |   17 -
 fs/xfs/xfs_error.c                                         |    2 
 fs/xfs/xfs_reflink.c                                       |    3 
 fs/xfs/xfs_super.c                                         |  120 ++++---
 fs/xfs/xfs_trans.c                                         |   23 -
 fs/xfs/xfs_trans.h                                         |   30 +
 include/linux/dim.h                                        |    2 
 net/ipv4/ip_tunnel_core.c                                  |    2 
 net/ipv4/tcp_ipv4.c                                        |    4 
 net/ipv6/addrconf.c                                        |    4 
 net/ipv6/route.c                                           |    9 
 net/ipv6/seg6_hmac.c                                       |    1 
 net/ipv6/sit.c                                             |   10 
 net/netfilter/nft_set_hash.c                               |    2 
 net/rose/rose_timer.c                                      |   34 +-
 net/sched/act_api.c                                        |   22 -
 net/sunrpc/xdr.c                                           |    2 
 net/tipc/node.c                                            |   41 +-
 tools/testing/selftests/net/udpgso_bench.sh                |    2 
 tools/testing/selftests/rseq/Makefile                      |    2 
 tools/testing/selftests/rseq/basic_percpu_ops_test.c       |    5 
 tools/testing/selftests/rseq/compiler.h                    |   30 +
 tools/testing/selftests/rseq/param_test.c                  |    8 
 tools/testing/selftests/rseq/rseq-abi.h                    |  151 +++++++++
 tools/testing/selftests/rseq/rseq-arm.h                    |  110 +++----
 tools/testing/selftests/rseq/rseq-arm64.h                  |   79 +++--
 tools/testing/selftests/rseq/rseq-generic-thread-pointer.h |   25 +
 tools/testing/selftests/rseq/rseq-mips.h                   |   71 +---
 tools/testing/selftests/rseq/rseq-ppc-thread-pointer.h     |   30 +
 tools/testing/selftests/rseq/rseq-ppc.h                    |  128 +++++---
 tools/testing/selftests/rseq/rseq-s390.h                   |   55 ++-
 tools/testing/selftests/rseq/rseq-skip.h                   |    2 
 tools/testing/selftests/rseq/rseq-thread-pointer.h         |   19 +
 tools/testing/selftests/rseq/rseq-x86-thread-pointer.h     |   40 ++
 tools/testing/selftests/rseq/rseq-x86.h                    |  200 ++++++++-----
 tools/testing/selftests/rseq/rseq.c                        |  165 +++++-----
 tools/testing/selftests/rseq/rseq.h                        |   30 +
 82 files changed, 1426 insertions(+), 768 deletions(-)

Alexey Khoroshilov (1):
      NFSD: restore EINVAL error translation in nfsd_commit()

Anthony Iliopoulos (1):
      xfs: fix xfs_trans slab cache name

Carlo Lobrano (1):
      net: usb: qmi_wwan: add Telit 0x1060 composition

Chris Ye (1):
      nvdimm: Fix badblocks clear off-by-one error

Christophe Leroy (1):
      powerpc/book3e: Fix PUD allocation size in map_kernel_page()

Chuck Lever (1):
      SUNRPC: Fix READ_PLUS crasher

Daniele Palmas (1):
      net: usb: qmi_wwan: add Telit 0x1070 composition

Darrick J. Wong (1):
      xfs: fix xfs_reflink_unshare usage of filemap_write_and_wait_range

Dave Chinner (2):
      xfs: use current->journal_info for detecting transaction recursion
      xfs: update superblock counters correctly for !lazysbcount

Demi Marie Obenour (1):
      xen/gntdev: Avoid blocking in unmap_grant_pages()

Dimitris Michailidis (1):
      selftests/net: pass ipv6_args to udpgso_bench's IPv6 TCP test

Doug Berger (1):
      net: dsa: bcm_sf2: force pause link settings

Duoming Zhou (1):
      net: rose: fix UAF bugs caused by timer handler

Enguerrand de Ribaucourt (2):
      net: dp83822: disable false carrier interrupt
      net: dp83822: disable rx error interrupt

Eric Dumazet (3):
      net: bonding: fix possible NULL deref in rlb code
      tunnels: do not assume mac header is set in skb_tunnel_check_pmtu()
      tcp: add a missing nf_reset_ct() in 3WHS handling

Gao Xiang (1):
      xfs: ensure xfs_errortag_random_default matches XFS_ERRTAG_MAX

Greg Kroah-Hartman (2):
      clocksource/drivers/ixp4xx: remove EXPORT_SYMBOL_GPL from ixp4xx_timer_setup()
      Linux 5.10.129

Heinz Mauelshagen (1):
      dm raid: fix accesses beyond end of raid member array

Jakub Kicinski (3):
      net: tun: unlink NAPI from device on destruction
      net: tun: stop NAPI when detaching queues
      net: tun: avoid disabling NAPI twice

Jan Beulich (1):
      xen-netfront: restore __skb_queue_tail() positioning in xennet_get_responses()

Jason A. Donenfeld (1):
      s390/archrandom: simplify back to earlier design and initialize earlier

Jason Wang (2):
      virtio-net: fix race between ndo_open() and virtio_device_ready()
      caif_virtio: fix race between virtio_device_ready() and ndo_open()

Jens Axboe (1):
      io_uring: ensure that send/sendmsg and recv/recvmsg check sqe->ioprio

Jose Alonso (1):
      net: usb: ax88179_178a: Fix packet receiving

Kamal Heib (1):
      RDMA/qedr: Fix reporting QP timeout attribute

Krzysztof Kozlowski (1):
      nfc: nfcmrvl: Fix irq_of_parse_and_map() return value

Liam Howlett (1):
      powerpc/prom_init: Fix kernel config grep

Liang He (1):
      drivers: cpufreq: Add missing of_node_put() in qoriq-cpufreq.c

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

Miaoqian Lin (2):
      RDMA/cm: Fix memory leak in ib_cm_insert_listen
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

Pablo Greco (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG SX6000LNP (AKA SPECTRIX S40G)

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: restore set element counter when failing to update

Pavel Reichl (2):
      xfs: rename variable mp to parsing_mp
      xfs: Skip repetitive warnings about mount options

Roger Pau Monne (4):
      xen/blkfront: fix leaking data in shared pages
      xen/netfront: fix leaking data in shared pages
      xen/netfront: force data bouncing when backend is untrusted
      xen/blkfront: force data bouncing when backend is untrusted

Ruili Ji (1):
      drm/amdgpu: To flush tlb for MMHUB of RAVEN series

Shuah Khan (1):
      selftests/rseq: remove ARRAY_SIZE define from individual tests

Tao Liu (1):
      linux/dim: Fix divide by 0 in RDMA DIM

Tong Zhang (1):
      epic100: fix use after free on rmmod

Victor Nogueira (1):
      net/sched: act_api: Notify user space if any actions were flushed before error

Xin Long (1):
      tipc: move bc link creation back to tipc_node_create

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

