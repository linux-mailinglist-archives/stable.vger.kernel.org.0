Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C47566D77
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbiGEMWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236367AbiGEMUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:20:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E501E3F9;
        Tue,  5 Jul 2022 05:16:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6B91619F6;
        Tue,  5 Jul 2022 12:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A516C341C7;
        Tue,  5 Jul 2022 12:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023388;
        bh=EzMHnLryiq3zOqZHlvxGFEIwtbfPQz5KdPogqW0tbqs=;
        h=From:To:Cc:Subject:Date:From;
        b=UGQqjk4xU9vinaC9nGV43o70WwV+M7RGJBVdLxpBYX/4jxZg0oJ2w6FVOG9YIckfb
         KSkTSTIpTAyAvki6/1uOXzS+1NBvxlXs2+Egrpk6a8cLYAVV0dnRvHFfbR/tmslYr/
         gnXVRbhv1pYAht6ociMc9nR5jDDPSq7M66t2MpXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.18 000/102] 5.18.10-rc1 review
Date:   Tue,  5 Jul 2022 13:57:26 +0200
Message-Id: <20220705115618.410217782@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.18.10-rc1
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

This is the start of the stable review cycle for the 5.18.10 release.
There are 102 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.18.10-rc1

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

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (ibmaem) don't call platform_device_del() if platform_device_add() fails

Casper Andersson <casper.casan@gmail.com>
    net: sparx5: mdb add/del handle non-sparx5 devices

Casper Andersson <casper.casan@gmail.com>
    net: sparx5: Add handling of host MDB entries

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

Anshuman Gupta <anshuman.gupta@intel.com>
    drm/i915/dgfx: Disable d3cold at gfx root port

katrinzhou <katrinzhou@tencent.com>
    drm/i915/gem: add missing else

Hans de Goede <hdegoede@redhat.com>
    platform/x86: ideapad-laptop: Add allow_v4_dytc module parameter

Stephen Boyd <swboyd@chromium.org>
    drm/msm/dpu: Increment vsync_cnt before waking up userspace

Steve French <stfrench@microsoft.com>
    cifs: fix minor compile warning

Jakub Kicinski <kuba@kernel.org>
    net: tun: avoid disabling NAPI twice

Petr Machata <petrm@nvidia.com>
    mlxsw: spectrum_router: Fix rollback in tunnel next hop init

Eric Dumazet <edumazet@google.com>
    ipv6: fix lockdep splat in in6_dump_addrs()

katrinzhou <katrinzhou@tencent.com>
    ipv6/sit: fix ipip6_tunnel_get_prl return value

Alan Adamson <alan.adamson@oracle.com>
    nvmet: add a clear_ids attribute for passthru targets

Amir Goldstein <amir73il@gmail.com>
    fanotify: refine the validation checks on non-dir inode mask

Eric Dumazet <edumazet@google.com>
    tunnels: do not assume mac header is set in skb_tunnel_check_pmtu()

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Change how we determine if brightness key-presses are handled

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: fix regression in data_digest calculation

Eric Dumazet <edumazet@google.com>
    tcp: add a missing nf_reset_ct() in 3WHS handling

Stephen Boyd <swboyd@chromium.org>
    cpufreq: qcom-hw: Don't do lmh things without a throttle interrupt

Tong Zhang <ztong0001@gmail.com>
    epic100: fix use after free on rmmod

Xin Long <lucien.xin@gmail.com>
    tipc: move bc link creation back to tipc_node_create

Michael Walle <michael@walle.cc>
    NFC: nxp-nci: Don't issue a zero length i2c_master_read()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    nfc: nfcmrvl: Fix irq_of_parse_and_map() return value

Hans de Goede <hdegoede@redhat.com>
    platform/x86: ideapad-laptop: Add Ideapad 5 15ITL05 to ideapad_dytc_v4_allow_table[]

Jean Delvare <jdelvare@suse.de>
    platform/x86: thinkpad_acpi: Fix a memory leak of EFCH MMIO resource

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/memhotplug: Add add_pages override for PPC

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: fix race between reading PSFP stats and port stats

Yevhen Orlov <yevhen.orlov@plvision.eu>
    net: bonding: fix use-after-free after 802.3ad slave unbind

Coleman Dietsch <dietschc@csp.edu>
    selftests net: fix kselftest net fatal error

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

wuchi <wuchi.zero@gmail.com>
    lib/sbitmap: Fix invalid loop in __sbitmap_queue_get_batch()

Miaoqian Lin <linmq006@gmail.com>
    PM / devfreq: exynos-ppmu: Fix refcount leak in of_get_devfreq_events

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure that send/sendmsg and recv/recvmsg check sqe->ioprio

Jason Wang <jasowang@redhat.com>
    caif_virtio: fix race between virtio_device_ready() and ndo_open()

Amir Goldstein <amir73il@gmail.com>
    vfs: fix copy_file_range() regression in cross-fs copies

Scott Mayhew <smayhew@redhat.com>
    NFSv4: Add an fattr allocation to _nfs4_discover_trunking()

Alexey Khoroshilov <khoroshilov@ispras.ru>
    NFSD: restore EINVAL error translation in nfsd_commit()

NeilBrown <neilb@suse.de>
    NFS: restore module put when manager exits.

YueHaibing <yuehaibing@huawei.com>
    net: ipv6: unexport __init-annotated seg6_hmac_net_init()

Eddie James <eajames@linux.ibm.com>
    hwmon: (occ) Prevent power cap command overwriting poll response

Mat Martineau <mathew.j.martineau@linux.intel.com>
    selftests: mptcp: Initialize variables to quiet gcc 12 warnings

Ossama Othman <ossama.othman@intel.com>
    mptcp: fix conflict with <netinet/in.h>

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: more stable diag tests

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix race on unaccepted mptcp sockets

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

Dan Carpenter <dan.carpenter@oracle.com>
    net: fix IFF_TX_SKB_NO_LINEAR definition

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

Mikulas Patocka <mpatocka@redhat.com>
    dm raid: fix KASAN warning in raid5_add_disks

Heinz Mauelshagen <heinzm@redhat.com>
    dm raid: fix accesses beyond end of raid member array

Jinzhou Su <Jinzhou.Su@amd.com>
    cpufreq: amd-pstate: Add resume and suspend callbacks

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Fix use of user_pt_regs in uapi

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/book3e: Fix PUD allocation size in map_kernel_page()

Liam Howlett <liam.howlett@oracle.com>
    powerpc/prom_init: Fix kernel config grep

Helge Deller <deller@gmx.de>
    parisc/unaligned: Fix emulate_ldw() breakage

Helge Deller <deller@gmx.de>
    parisc: Fix vDSO signal breakage on 32-bit kernel

Jeff Layton <jlayton@kernel.org>
    ceph: wait on async create before checking caps for syncfs

Chris Ye <chris.ye@intel.com>
    nvdimm: Fix badblocks clear off-by-one error

Lamarque Vieira Souza <lamarque@petrosoftdesign.com>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA IM2P33F8ABR1

Pablo Greco <pgreco@centosproject.org>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG SX6000LNP (AKA SPECTRIX S40G)

Jason A. Donenfeld <Jason@zx2c4.com>
    s390/archrandom: simplify back to earlier design and initialize earlier

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

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix adev variable used in amdgpu_device_gpu_recover()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/xen/p2m.c                                 |   6 +-
 arch/parisc/kernel/asm-offsets.c                   |   5 +
 arch/parisc/kernel/unaligned.c                     |   2 +-
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
 drivers/cpufreq/amd-pstate.c                       |  24 +++
 drivers/cpufreq/qcom-cpufreq-hw.c                  |   6 +
 drivers/cpufreq/qoriq-cpufreq.c                    |   1 +
 drivers/devfreq/event/exynos-ppmu.c                |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |   1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   3 -
 drivers/gpu/drm/i915/gem/i915_gem_context.c        |   5 +-
 drivers/gpu/drm/i915/i915_driver.c                 |  34 ++--
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   3 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |   2 +-
 drivers/hwmon/ibmaem.c                             |  12 +-
 drivers/hwmon/occ/common.c                         |   5 +-
 drivers/hwmon/occ/common.h                         |   3 +-
 drivers/hwmon/occ/p8_i2c.c                         |  13 +-
 drivers/hwmon/occ/p9_sbe.c                         |   7 +-
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
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   4 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  14 +-
 .../ethernet/microchip/sparx5/sparx5_switchdev.c   |  18 ++
 drivers/net/ethernet/smsc/epic100.c                |   4 +-
 drivers/net/phy/ax88796b.c                         |   6 +-
 drivers/net/phy/dp83822.c                          |   4 +-
 drivers/net/phy/phy.c                              |  23 +++
 drivers/net/phy/phy_device.c                       |  23 +++
 drivers/net/tun.c                                  |  15 +-
 drivers/net/usb/asix.h                             |   3 +-
 drivers/net/usb/asix_common.c                      |   1 +
 drivers/net/usb/ax88179_178a.c                     | 101 +++++++---
 drivers/net/usb/usbnet.c                           |   4 +-
 drivers/net/virtio_net.c                           |   8 +-
 drivers/net/xen-netfront.c                         |  56 +++++-
 drivers/nfc/nfcmrvl/i2c.c                          |   6 +-
 drivers/nfc/nfcmrvl/spi.c                          |   6 +-
 drivers/nfc/nxp-nci/i2c.c                          |   3 +
 drivers/nvdimm/bus.c                               |   4 +-
 drivers/nvme/host/pci.c                            |   5 +-
 drivers/nvme/target/configfs.c                     |  20 ++
 drivers/nvme/target/core.c                         |   6 +
 drivers/nvme/target/nvmet.h                        |   1 +
 drivers/nvme/target/passthru.c                     |  55 ++++++
 drivers/nvme/target/tcp.c                          |  23 +--
 drivers/platform/x86/Kconfig                       |   2 +
 drivers/platform/x86/ideapad-laptop.c              |  29 ++-
 drivers/platform/x86/panasonic-laptop.c            |  84 ++++++--
 drivers/platform/x86/thinkpad_acpi.c               |   1 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   2 +
 fs/ceph/caps.c                                     |   1 +
 fs/cifs/connect.c                                  |   2 +
 fs/io_uring.c                                      |   4 +-
 fs/ksmbd/smb2pdu.c                                 |  43 ++--
 fs/ksmbd/vfs.c                                     |  12 +-
 fs/nfs/nfs4proc.c                                  |  19 +-
 fs/nfs/nfs4state.c                                 |   1 +
 fs/nfsd/vfs.c                                      |  11 +-
 fs/notify/fanotify/fanotify_user.c                 |  34 ++--
 fs/read_write.c                                    |  77 ++++----
 include/linux/dim.h                                |   2 +-
 include/linux/fanotify.h                           |   4 +
 include/linux/netdevice.h                          |   2 +-
 include/linux/phy.h                                |   6 +
 include/uapi/drm/drm_fourcc.h                      |   4 +-
 include/uapi/linux/mptcp.h                         |   9 +-
 lib/sbitmap.c                                      |   5 +-
 net/ipv4/ip_tunnel_core.c                          |   2 +-
 net/ipv4/tcp_ipv4.c                                |   6 +-
 net/ipv6/addrconf.c                                |   8 +-
 net/ipv6/route.c                                   |   9 +-
 net/ipv6/seg6_hmac.c                               |   1 -
 net/ipv6/sit.c                                     |   8 +-
 net/mptcp/protocol.c                               |   5 +
 net/mptcp/protocol.h                               |   2 +
 net/mptcp/subflow.c                                |  52 +++++
 net/netfilter/nft_set_hash.c                       |   2 +
 net/rose/rose_timer.c                              |  34 ++--
 net/sched/act_api.c                                |  22 ++-
 net/sunrpc/xdr.c                                   |   2 +-
 net/tipc/node.c                                    |  41 ++--
 tools/testing/selftests/net/bpf/Makefile           |   2 +-
 tools/testing/selftests/net/mptcp/diag.sh          |  48 ++++-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_inq.c      |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_sockopt.c  |   2 +-
 tools/testing/selftests/net/udpgso_bench.sh        |   2 +-
 110 files changed, 1013 insertions(+), 589 deletions(-)


