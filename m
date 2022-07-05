Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563D4566C9A
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbiGEMQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbiGEMPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:15:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1DB1901E;
        Tue,  5 Jul 2022 05:11:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDFB2619AF;
        Tue,  5 Jul 2022 12:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB878C341C7;
        Tue,  5 Jul 2022 12:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023108;
        bh=wR48YsLrOf2RbcxPcGmKVvmrNiScEzMYaV3Q3txNhtw=;
        h=From:To:Cc:Subject:Date:From;
        b=K0t1ADh+r+br3b9JL4hXLcRE24k6A/Tf0/If6FPEjCiPjxp6CitHFH4RDXZKvQE3i
         wwa1BPXgtEH9kFDHHpOfFcFzkC1MObQpe+xk18xDQv3PHR3nsIuQGJKvOB9U4/9e52
         b6M99lPykBKWpxcaHzBOJhp6Q7GlOympgtUQeT4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 00/98] 5.15.53-rc1 review
Date:   Tue,  5 Jul 2022 13:57:18 +0200
Message-Id: <20220705115617.568350164@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.53-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.53-rc1
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

This is the start of the stable review cycle for the 5.15.53 release.
There are 98 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.53-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.53-rc1

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (ibmaem) don't call platform_device_del() if platform_device_add() fails

Eddie James <eajames@linux.ibm.com>
    hwmon: (occ) Prevent power cap command overwriting poll response

Eddie James <eajames@linux.ibm.com>
    hwmon: (occ) Remove sequence numbering and checksum calculation

Carlos Llamas <cmllamas@google.com>
    drm/fourcc: fix integer type usage in uapi header

Hans de Goede <hdegoede@redhat.com>
    platform/x86: panasonic-laptop: filter out duplicate volume up/down/mute keypresses

Hans de Goede <hdegoede@redhat.com>
    platform/x86: panasonic-laptop: don't report duplicate brightness key-presses

Hans de Goede <hdegoede@redhat.com>
    platform/x86: panasonic-laptop: revert "Resolve hotkey double trigger bug"

Hans de Goede <hdegoede@redhat.com>
    platform/x86: panasonic-laptop: sort includes alphabetically

Stefan Seyfried <seife+kernel@b1-systems.com>
    platform/x86: panasonic-laptop: de-obfuscate button codes

Liang He <windhl@126.com>
    drivers: cpufreq: Add missing of_node_put() in qoriq-cpufreq.c

Rob Clark <robdclark@chromium.org>
    drm/msm/gem: Fix error return on fence id alloc fail

katrinzhou <katrinzhou@tencent.com>
    drm/i915/gem: add missing else

Dan Carpenter <dan.carpenter@oracle.com>
    net: fix IFF_TX_SKB_NO_LINEAR definition

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    clocksource/drivers/ixp4xx: remove EXPORT_SYMBOL_GPL from ixp4xx_timer_setup()

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit 0x1070 composition

Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
    xen/arm: Fix race in RB-tree based P2M accounting

Jan Beulich <jbeulich@suse.com>
    xen-netfront: restore __skb_queue_tail() positioning in xennet_get_responses()

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

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    selftests/bpf: Add test_verifier support to fixup kfunc call insns

Eric Dumazet <edumazet@google.com>
    tcp: add a missing nf_reset_ct() in 3WHS handling

Leah Rumancik <leah.rumancik@gmail.com>
    MAINTAINERS: add Leah as xfs maintainer for 5.15.y

Jakub Kicinski <kuba@kernel.org>
    net: tun: avoid disabling NAPI twice

Petr Machata <petrm@nvidia.com>
    mlxsw: spectrum_router: Fix rollback in tunnel next hop init

Eric Dumazet <edumazet@google.com>
    ipv6: fix lockdep splat in in6_dump_addrs()

katrinzhou <katrinzhou@tencent.com>
    ipv6/sit: fix ipip6_tunnel_get_prl return value

Eric Dumazet <edumazet@google.com>
    tunnels: do not assume mac header is set in skb_tunnel_check_pmtu()

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Change how we determine if brightness key-presses are handled

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure that send/sendmsg and recv/recvmsg check sqe->ioprio

Tong Zhang <ztong0001@gmail.com>
    epic100: fix use after free on rmmod

Xin Long <lucien.xin@gmail.com>
    tipc: move bc link creation back to tipc_node_create

Michael Walle <michael@walle.cc>
    NFC: nxp-nci: Don't issue a zero length i2c_master_read()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    nfc: nfcmrvl: Fix irq_of_parse_and_map() return value

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/memhotplug: Add add_pages override for PPC

Yevhen Orlov <yevhen.orlov@plvision.eu>
    net: bonding: fix use-after-free after 802.3ad slave unbind

Oleksij Rempel <linux@rempel-privat.de>
    net: phy: ax88772a: fix lost pause advertisement configuration

Eric Dumazet <edumazet@google.com>
    net: bonding: fix possible NULL deref in rlb code

Oleksij Rempel <linux@rempel-privat.de>
    net: asix: fix "can't send until first packet is send" issue

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: Notify user space if any actions were flushed before error

Liang He <windhl@126.com>
    net/dsa/hirschmann: Add missing of_node_get() in hellcreek_led_setup()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_dynset: restore set element counter when failing to update

Masahiro Yamada <masahiroy@kernel.org>
    s390: remove unneeded 'select BUILD_BIN2C'

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Update Control VQ callback information

Miaoqian Lin <linmq006@gmail.com>
    PM / devfreq: exynos-ppmu: Fix refcount leak in of_get_devfreq_events

Jason Wang <jasowang@redhat.com>
    caif_virtio: fix race between virtio_device_ready() and ndo_open()

Amir Goldstein <amir73il@gmail.com>
    vfs: fix copy_file_range() regression in cross-fs copies

Alexey Khoroshilov <khoroshilov@ispras.ru>
    NFSD: restore EINVAL error translation in nfsd_commit()

YueHaibing <yuehaibing@huawei.com>
    net: ipv6: unexport __init-annotated seg6_hmac_net_init()

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: more stable diag tests

Oliver Neukum <oneukum@suse.com>
    usbnet: fix memory allocation in helpers

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: asix: do not force pause frames support

Tao Liu <thomas.liu@ucloud.cn>
    linux/dim: Fix divide by 0 in RDMA DIM

Miaoqian Lin <linmq006@gmail.com>
    RDMA/cm: Fix memory leak in ib_cm_insert_listen

Kamal Heib <kamalheib1@gmail.com>
    RDMA/qedr: Fix reporting QP timeout attribute

Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
    net: dp83822: disable rx error interrupt

Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
    net: dp83822: disable false carrier interrupt

Jakub Kicinski <kuba@kernel.org>
    net: tun: stop NAPI when detaching queues

Jakub Kicinski <kuba@kernel.org>
    net: tun: unlink NAPI from device on destruction

Doug Berger <opendmb@gmail.com>
    net: dsa: bcm_sf2: force pause link settings

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

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/book3e: Fix PUD allocation size in map_kernel_page()

Liam Howlett <liam.howlett@oracle.com>
    powerpc/prom_init: Fix kernel config grep

Chris Ye <chris.ye@intel.com>
    nvdimm: Fix badblocks clear off-by-one error

Lamarque Vieira Souza <lamarque@petrosoftdesign.com>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA IM2P33F8ABR1

Pablo Greco <pgreco@centosproject.org>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG SX6000LNP (AKA SPECTRIX S40G)

Lukas Wunner <lukas@wunner.de>
    net: phy: Don't trigger state machine while in suspend

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: take care of disable_policy when restoring routes

Jason A. Donenfeld <Jason@zx2c4.com>
    ksmbd: use vfs_llseek instead of dereferencing NULL

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: check invalid FileOffset and BeyondFinalZero in FSCTL_ZERO_DATA

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: set the range of bytes to zero without extending file size in FSCTL_ZERO_DATA

Ruili Ji <ruiliji2@amd.com>
    drm/amdgpu: To flush tlb for MMHUB of RAVEN series

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amdgpu/display: set vblank_disable_immediate for DC"


-------------

Diffstat:

 MAINTAINERS                                        |   1 +
 Makefile                                           |   4 +-
 arch/arm/xen/p2m.c                                 |   6 +-
 arch/powerpc/Kconfig                               |   4 +
 arch/powerpc/include/asm/bpf_perf_event.h          |   9 +
 arch/powerpc/include/uapi/asm/bpf_perf_event.h     |   9 -
 arch/powerpc/kernel/prom_init_check.sh             |   2 +-
 arch/powerpc/mm/mem.c                              |  33 +++-
 arch/powerpc/mm/nohash/book3e_pgtable.c            |   6 +-
 arch/s390/Kconfig                                  |   1 -
 arch/s390/crypto/arch_random.c                     | 217 ---------------------
 arch/s390/include/asm/archrandom.h                 |  14 +-
 arch/s390/kernel/setup.c                           |   5 +
 drivers/acpi/acpi_video.c                          |  13 +-
 drivers/block/xen-blkfront.c                       |  56 ++++--
 drivers/clocksource/timer-ixp4xx.c                 |   1 -
 drivers/cpufreq/qoriq-cpufreq.c                    |   1 +
 drivers/devfreq/event/exynos-ppmu.c                |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |   1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   3 -
 drivers/gpu/drm/i915/gem/i915_gem_context.c        |   5 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |   2 +-
 drivers/hwmon/ibmaem.c                             |  12 +-
 drivers/hwmon/occ/common.c                         |  31 ++-
 drivers/hwmon/occ/common.h                         |   4 +-
 drivers/hwmon/occ/p8_i2c.c                         |  26 +--
 drivers/hwmon/occ/p9_sbe.c                         |   9 +-
 drivers/infiniband/core/cm.c                       |   4 +-
 drivers/infiniband/hw/qedr/qedr.h                  |   1 +
 drivers/infiniband/hw/qedr/verbs.c                 |   4 +-
 drivers/md/dm-raid.c                               |  34 ++--
 drivers/md/raid5.c                                 |   1 +
 drivers/net/bonding/bond_3ad.c                     |   3 +-
 drivers/net/bonding/bond_alb.c                     |   2 +-
 drivers/net/caif/caif_virtio.c                     |  10 +-
 drivers/net/dsa/bcm_sf2.c                          |   5 +
 drivers/net/dsa/hirschmann/hellcreek_ptp.c         |   1 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  14 +-
 drivers/net/ethernet/smsc/epic100.c                |   4 +-
 drivers/net/phy/ax88796b.c                         |   6 +-
 drivers/net/phy/dp83822.c                          |   4 +-
 drivers/net/phy/phy.c                              |  23 +++
 drivers/net/phy/phy_device.c                       |  23 +++
 drivers/net/tun.c                                  |  15 +-
 drivers/net/usb/asix.h                             |   3 +-
 drivers/net/usb/asix_common.c                      |   1 +
 drivers/net/usb/ax88179_178a.c                     | 101 +++++++---
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/usbnet.c                           |   4 +-
 drivers/net/virtio_net.c                           |   8 +-
 drivers/net/xen-netfront.c                         |  56 +++++-
 drivers/nfc/nfcmrvl/i2c.c                          |   6 +-
 drivers/nfc/nfcmrvl/spi.c                          |   6 +-
 drivers/nfc/nxp-nci/i2c.c                          |   3 +
 drivers/nvdimm/bus.c                               |   4 +-
 drivers/nvme/host/pci.c                            |   5 +-
 drivers/platform/x86/Kconfig                       |   2 +
 drivers/platform/x86/panasonic-laptop.c            |  84 ++++++--
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   2 +
 fs/io_uring.c                                      |   4 +
 fs/ksmbd/smb2pdu.c                                 |  43 ++--
 fs/ksmbd/vfs.c                                     |  12 +-
 fs/nfsd/vfs.c                                      |  11 +-
 fs/read_write.c                                    |  77 ++++----
 include/linux/dim.h                                |   2 +-
 include/linux/netdevice.h                          |   2 +-
 include/linux/phy.h                                |   6 +
 include/uapi/drm/drm_fourcc.h                      |   4 +-
 net/ipv4/ip_tunnel_core.c                          |   2 +-
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv6/addrconf.c                                |   8 +-
 net/ipv6/route.c                                   |   9 +-
 net/ipv6/seg6_hmac.c                               |   1 -
 net/ipv6/sit.c                                     |   8 +-
 net/netfilter/nft_set_hash.c                       |   2 +
 net/rose/rose_timer.c                              |  34 ++--
 net/sched/act_api.c                                |  22 ++-
 net/sunrpc/xdr.c                                   |   2 +-
 net/tipc/node.c                                    |  41 ++--
 tools/testing/selftests/bpf/test_verifier.c        |  28 +++
 tools/testing/selftests/net/mptcp/diag.sh          |  48 ++++-
 tools/testing/selftests/net/udpgso_bench.sh        |   2 +-
 tools/testing/selftests/rseq/Makefile              |   2 +-
 .../testing/selftests/rseq/basic_percpu_ops_test.c |   5 +-
 tools/testing/selftests/rseq/compiler.h            |  30 +++
 tools/testing/selftests/rseq/param_test.c          |   8 +-
 tools/testing/selftests/rseq/rseq-abi.h            | 151 ++++++++++++++
 tools/testing/selftests/rseq/rseq-arm.h            | 110 ++++++-----
 tools/testing/selftests/rseq/rseq-arm64.h          |  79 +++++---
 .../selftests/rseq/rseq-generic-thread-pointer.h   |  25 +++
 tools/testing/selftests/rseq/rseq-mips.h           |  71 ++-----
 .../selftests/rseq/rseq-ppc-thread-pointer.h       |  30 +++
 tools/testing/selftests/rseq/rseq-ppc.h            | 128 +++++++-----
 tools/testing/selftests/rseq/rseq-s390.h           |  55 ++++--
 tools/testing/selftests/rseq/rseq-skip.h           |   2 +-
 tools/testing/selftests/rseq/rseq-thread-pointer.h |  19 ++
 .../selftests/rseq/rseq-x86-thread-pointer.h       |  40 ++++
 tools/testing/selftests/rseq/rseq-x86.h            | 200 +++++++++++++------
 tools/testing/selftests/rseq/rseq.c                | 165 ++++++++--------
 tools/testing/selftests/rseq/rseq.h                |  30 ++-
 101 files changed, 1559 insertions(+), 889 deletions(-)


