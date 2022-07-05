Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE39566B61
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbiGEMGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbiGEMFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:05:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811BA18E0F;
        Tue,  5 Jul 2022 05:04:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D229B817CE;
        Tue,  5 Jul 2022 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C011C341CB;
        Tue,  5 Jul 2022 12:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022690;
        bh=IgdAu0DTL/CHQU0fiW+/GmDI85ccLgARxPTUIIbkMy8=;
        h=From:To:Cc:Subject:Date:From;
        b=iWL1l2KAOlPqB/D2f6GUo0lEnX3nMIzaf8gCa7R79I2DlAwQepwVsuN9bHXDdEM5P
         6f9GGrquYUk+usGdGVZIan6Fmba0ZRFSPBmB7FGnGE0BEPqeUrSEKladhHMiShaQWF
         71M9UalnGHamO9p+f/XiXpR+L10Rac9lfdnWthWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/58] 5.4.204-rc1 review
Date:   Tue,  5 Jul 2022 13:57:36 +0200
Message-Id: <20220705115610.236040773@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.204-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.204-rc1
X-KernelTest-Deadline: 2022-07-07T11:56+00:00
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

This is the start of the stable review cycle for the 5.4.204 release.
There are 58 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.204-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.204-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    clocksource/drivers/ixp4xx: remove EXPORT_SYMBOL_GPL from ixp4xx_timer_setup()

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit 0x1070 composition

Carlo Lobrano <c.lobrano@gmail.com>
    net: usb: qmi_wwan: add Telit 0x1060 composition

Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
    xen/arm: Fix race in RB-tree based P2M accounting

Roger Pau Monne <roger.pau@citrix.com>
    xen/blkfront: force data bouncing when backend is untrusted

Roger Pau Monne <roger.pau@citrix.com>
    xen/netfront: force data bouncing when backend is untrusted

Roger Pau Monne <roger.pau@citrix.com>
    xen/netfront: fix leaking data in shared pages

Roger Pau Monne <roger.pau@citrix.com>
    xen/blkfront: fix leaking data in shared pages

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: Change type of rseq_offset to ptrdiff_t

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: x86-32: use %gs segment selector for accessing rseq thread area

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: x86-64: use %fs segment selector for accessing rseq thread area

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: Fix: work-around asm goto compiler bugs

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: Remove arm/mips asm goto compiler work-around

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: Fix warnings about #if checks of undefined tokens

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: Fix ppc32 offsets by using long rather than off_t

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: Fix ppc32 missing instruction selection "u" and "x" for load/store

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: Fix ppc32: wrong rseq_cs 32-bit field pointer on big endian

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: Uplift rseq selftests for compatibility with glibc-2.35

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: Introduce thread pointer getters

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: Introduce rseq_get_abi() helper

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: Remove volatile from __rseq_abi

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: Remove useless assignment to cpu variable

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: introduce own copy of rseq uapi header

Shuah Khan <skhan@linuxfoundation.org>
    selftests/rseq: remove ARRAY_SIZE define from individual tests

Peter Oskolkov <posk@google.com>
    rseq/selftests,x86_64: Add rseq_offset_deref_addv()

katrinzhou <katrinzhou@tencent.com>
    ipv6/sit: fix ipip6_tunnel_get_prl return value

kernel test robot <lkp@intel.com>
    sit: use min

Doug Berger <opendmb@gmail.com>
    net: dsa: bcm_sf2: force pause link settings

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (ibmaem) don't call platform_device_del() if platform_device_add() fails

Demi Marie Obenour <demi@invisiblethingslab.com>
    xen/gntdev: Avoid blocking in unmap_grant_pages()

Jakub Kicinski <kuba@kernel.org>
    net: tun: avoid disabling NAPI twice

Michael Walle <michael@walle.cc>
    NFC: nxp-nci: Don't issue a zero length i2c_master_read()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    nfc: nfcmrvl: Fix irq_of_parse_and_map() return value

Yevhen Orlov <yevhen.orlov@plvision.eu>
    net: bonding: fix use-after-free after 802.3ad slave unbind

Eric Dumazet <edumazet@google.com>
    net: bonding: fix possible NULL deref in rlb code

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: Notify user space if any actions were flushed before error

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_dynset: restore set element counter when failing to update

Masahiro Yamada <masahiroy@kernel.org>
    s390: remove unneeded 'select BUILD_BIN2C'

Miaoqian Lin <linmq006@gmail.com>
    PM / devfreq: exynos-ppmu: Fix refcount leak in of_get_devfreq_events

Jason Wang <jasowang@redhat.com>
    caif_virtio: fix race between virtio_device_ready() and ndo_open()

YueHaibing <yuehaibing@huawei.com>
    net: ipv6: unexport __init-annotated seg6_hmac_net_init()

Oliver Neukum <oneukum@suse.com>
    usbnet: fix memory allocation in helpers

Tao Liu <thomas.liu@ucloud.cn>
    linux/dim: Fix divide by 0 in RDMA DIM

Kamal Heib <kamalheib1@gmail.com>
    RDMA/qedr: Fix reporting QP timeout attribute

Jakub Kicinski <kuba@kernel.org>
    net: tun: stop NAPI when detaching queues

Jakub Kicinski <kuba@kernel.org>
    net: tun: unlink NAPI from device on destruction

Dimitris Michailidis <d.michailidis@fungible.com>
    selftests/net: pass ipv6_args to udpgso_bench's IPv6 TCP test

Jason Wang <jasowang@redhat.com>
    virtio-net: fix race between ndo_open() and virtio_device_ready()

Jose Alonso <joalonsof@gmail.com>
    net: usb: ax88179_178a: Fix packet receiving

Duoming Zhou <duoming@zju.edu.cn>
    net: rose: fix UAF bugs caused by timer handler

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix READ_PLUS crasher

Jason A. Donenfeld <Jason@zx2c4.com>
    s390/archrandom: simplify back to earlier design and initialize earlier

Mikulas Patocka <mpatocka@redhat.com>
    dm raid: fix KASAN warning in raid5_add_disks

Heinz Mauelshagen <heinzm@redhat.com>
    dm raid: fix accesses beyond end of raid member array

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Fix use of user_pt_regs in uapi

Liam Howlett <liam.howlett@oracle.com>
    powerpc/prom_init: Fix kernel config grep

Chris Ye <chris.ye@intel.com>
    nvdimm: Fix badblocks clear off-by-one error

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: take care of disable_policy when restoring routes


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/xen/p2m.c                                 |   6 +-
 arch/powerpc/include/asm/bpf_perf_event.h          |   9 +
 arch/powerpc/include/uapi/asm/bpf_perf_event.h     |   9 -
 arch/powerpc/kernel/prom_init_check.sh             |   2 +-
 arch/s390/Kconfig                                  |   1 -
 arch/s390/crypto/arch_random.c                     | 111 +--------
 arch/s390/include/asm/archrandom.h                 |  21 +-
 arch/s390/kernel/setup.c                           |   5 +
 drivers/block/xen-blkfront.c                       |  56 +++--
 drivers/clocksource/timer-ixp4xx.c                 |   1 -
 drivers/devfreq/event/exynos-ppmu.c                |   8 +-
 drivers/hwmon/ibmaem.c                             |  12 +-
 drivers/infiniband/hw/qedr/qedr.h                  |   1 +
 drivers/infiniband/hw/qedr/verbs.c                 |   4 +-
 drivers/md/dm-raid.c                               |  34 +--
 drivers/md/raid5.c                                 |   1 +
 drivers/net/bonding/bond_3ad.c                     |   3 +-
 drivers/net/bonding/bond_alb.c                     |   2 +-
 drivers/net/caif/caif_virtio.c                     |  10 +-
 drivers/net/dsa/bcm_sf2.c                          |   5 +
 drivers/net/tun.c                                  |  15 +-
 drivers/net/usb/ax88179_178a.c                     | 101 ++++++---
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/usb/usbnet.c                           |   4 +-
 drivers/net/virtio_net.c                           |   8 +-
 drivers/net/xen-netfront.c                         |  52 ++++-
 drivers/nfc/nfcmrvl/i2c.c                          |   6 +-
 drivers/nfc/nfcmrvl/spi.c                          |   6 +-
 drivers/nfc/nxp-nci/i2c.c                          |   3 +
 drivers/nvdimm/bus.c                               |   4 +-
 drivers/xen/gntdev-common.h                        |   8 +
 drivers/xen/gntdev.c                               | 147 ++++++++----
 include/linux/dim.h                                |   2 +-
 net/ipv6/addrconf.c                                |   4 -
 net/ipv6/route.c                                   |   9 +-
 net/ipv6/seg6_hmac.c                               |   1 -
 net/ipv6/sit.c                                     |  10 +-
 net/netfilter/nft_set_hash.c                       |   2 +
 net/rose/rose_timer.c                              |  34 +--
 net/sched/act_api.c                                |  22 +-
 net/sunrpc/xdr.c                                   |   2 +-
 tools/testing/selftests/net/udpgso_bench.sh        |   2 +-
 tools/testing/selftests/rseq/Makefile              |   2 +-
 .../testing/selftests/rseq/basic_percpu_ops_test.c |   5 +-
 tools/testing/selftests/rseq/compiler.h            |  30 +++
 tools/testing/selftests/rseq/param_test.c          |   8 +-
 tools/testing/selftests/rseq/rseq-abi.h            | 151 +++++++++++++
 tools/testing/selftests/rseq/rseq-arm.h            | 110 ++++-----
 tools/testing/selftests/rseq/rseq-arm64.h          |  79 +++++--
 .../selftests/rseq/rseq-generic-thread-pointer.h   |  25 +++
 tools/testing/selftests/rseq/rseq-mips.h           |  71 ++----
 .../selftests/rseq/rseq-ppc-thread-pointer.h       |  30 +++
 tools/testing/selftests/rseq/rseq-ppc.h            | 128 +++++++----
 tools/testing/selftests/rseq/rseq-s390.h           |  55 +++--
 tools/testing/selftests/rseq/rseq-skip.h           |   2 +-
 tools/testing/selftests/rseq/rseq-thread-pointer.h |  19 ++
 .../selftests/rseq/rseq-x86-thread-pointer.h       |  40 ++++
 tools/testing/selftests/rseq/rseq-x86.h            | 247 ++++++++++++++++-----
 tools/testing/selftests/rseq/rseq.c                | 165 +++++++-------
 tools/testing/selftests/rseq/rseq.h                |  30 ++-
 61 files changed, 1290 insertions(+), 656 deletions(-)


