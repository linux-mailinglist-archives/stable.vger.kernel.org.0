Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376E256A7C7
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 18:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236012AbiGGQKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 12:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbiGGQJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 12:09:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8DB326CD;
        Thu,  7 Jul 2022 09:09:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E86F6623A1;
        Thu,  7 Jul 2022 16:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2581C3411E;
        Thu,  7 Jul 2022 16:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657210143;
        bh=2T4/e9CMpYdCGqZOqqE2prHu+J7DT7Rd+FEAfU0ydNA=;
        h=From:To:Cc:Subject:Date:From;
        b=wG2PPXxpfJPoay5fiRBhO7iplt/Ixjto7dyr0cAJGEbCTHbXXxRRtWfiXMqZRLf7C
         pxEEMHitagb1sffVO0kTtHXDDWW3zrg/AEVAIWN3mlefzv7BxrTTdnQfWX9CavafHN
         TWGnDoF4re+J4Hsovkh7HDxh8PB/qwLySc+25ZkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.18.10
Date:   Thu,  7 Jul 2022 18:08:46 +0200
Message-Id: <1657210126209251@kroah.com>
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

I'm announcing the release of the 5.18.10 kernel.

All users of the 5.18 kernel series must upgrade.

The updated 5.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.18.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    2 
 arch/arm/xen/p2m.c                                       |    6 
 arch/parisc/kernel/asm-offsets.c                         |    5 
 arch/parisc/kernel/unaligned.c                           |    2 
 arch/powerpc/Kconfig                                     |    4 
 arch/powerpc/include/asm/bpf_perf_event.h                |    9 
 arch/powerpc/include/uapi/asm/bpf_perf_event.h           |    9 
 arch/powerpc/kernel/prom_init_check.sh                   |    2 
 arch/powerpc/mm/mem.c                                    |   33 ++
 arch/powerpc/mm/nohash/book3e_pgtable.c                  |    6 
 arch/s390/Kconfig                                        |    1 
 arch/s390/crypto/arch_random.c                           |  217 ---------------
 arch/s390/include/asm/archrandom.h                       |   14 
 arch/s390/kernel/setup.c                                 |    5 
 drivers/acpi/acpi_video.c                                |   13 
 drivers/block/xen-blkfront.c                             |   56 ++-
 drivers/cpufreq/amd-pstate.c                             |   24 +
 drivers/cpufreq/qcom-cpufreq-hw.c                        |    6 
 drivers/cpufreq/qoriq-cpufreq.c                          |    1 
 drivers/devfreq/event/exynos-ppmu.c                      |    8 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c               |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c               |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c                  |    1 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c        |    3 
 drivers/gpu/drm/i915/gem/i915_gem_context.c              |    5 
 drivers/gpu/drm/i915/i915_driver.c                       |   34 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c              |    3 
 drivers/gpu/drm/msm/msm_gem_submit.c                     |    2 
 drivers/hwmon/ibmaem.c                                   |   12 
 drivers/hwmon/occ/common.c                               |    5 
 drivers/hwmon/occ/common.h                               |    3 
 drivers/hwmon/occ/p8_i2c.c                               |   13 
 drivers/hwmon/occ/p9_sbe.c                               |    7 
 drivers/infiniband/core/cm.c                             |    4 
 drivers/infiniband/hw/qedr/qedr.h                        |    1 
 drivers/infiniband/hw/qedr/verbs.c                       |    4 
 drivers/md/dm-raid.c                                     |   34 +-
 drivers/md/raid5.c                                       |    1 
 drivers/net/bonding/bond_3ad.c                           |    3 
 drivers/net/bonding/bond_alb.c                           |    2 
 drivers/net/caif/caif_virtio.c                           |   10 
 drivers/net/dsa/bcm_sf2.c                                |    5 
 drivers/net/dsa/hirschmann/hellcreek_ptp.c               |    1 
 drivers/net/dsa/ocelot/felix_vsc9959.c                   |    4 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c    |   14 
 drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c |   18 +
 drivers/net/ethernet/smsc/epic100.c                      |    4 
 drivers/net/phy/ax88796b.c                               |    6 
 drivers/net/phy/dp83822.c                                |    4 
 drivers/net/phy/phy.c                                    |   23 +
 drivers/net/phy/phy_device.c                             |   23 +
 drivers/net/tun.c                                        |   15 -
 drivers/net/usb/asix.h                                   |    3 
 drivers/net/usb/asix_common.c                            |    1 
 drivers/net/usb/ax88179_178a.c                           |  101 +++++-
 drivers/net/usb/usbnet.c                                 |    4 
 drivers/net/virtio_net.c                                 |    8 
 drivers/net/xen-netfront.c                               |   56 +++
 drivers/nfc/nfcmrvl/i2c.c                                |    6 
 drivers/nfc/nfcmrvl/spi.c                                |    6 
 drivers/nfc/nxp-nci/i2c.c                                |    3 
 drivers/nvdimm/bus.c                                     |    4 
 drivers/nvme/host/pci.c                                  |    5 
 drivers/nvme/target/configfs.c                           |   20 +
 drivers/nvme/target/core.c                               |    6 
 drivers/nvme/target/nvmet.h                              |    1 
 drivers/nvme/target/passthru.c                           |   55 +++
 drivers/nvme/target/tcp.c                                |   23 -
 drivers/platform/x86/Kconfig                             |    2 
 drivers/platform/x86/ideapad-laptop.c                    |   29 +-
 drivers/platform/x86/panasonic-laptop.c                  |   84 ++++-
 drivers/platform/x86/thinkpad_acpi.c                     |    1 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                        |    2 
 fs/ceph/caps.c                                           |    1 
 fs/cifs/connect.c                                        |    2 
 fs/io_uring.c                                            |    4 
 fs/ksmbd/smb2pdu.c                                       |   43 ++
 fs/ksmbd/vfs.c                                           |   12 
 fs/nfs/nfs4proc.c                                        |   19 -
 fs/nfs/nfs4state.c                                       |    1 
 fs/nfsd/vfs.c                                            |   11 
 fs/notify/fanotify/fanotify_user.c                       |   34 +-
 fs/read_write.c                                          |   77 +++--
 include/linux/dim.h                                      |    2 
 include/linux/fanotify.h                                 |    4 
 include/linux/netdevice.h                                |    2 
 include/linux/phy.h                                      |    6 
 include/uapi/drm/drm_fourcc.h                            |    4 
 include/uapi/linux/mptcp.h                               |    9 
 lib/sbitmap.c                                            |    5 
 net/ipv4/ip_tunnel_core.c                                |    2 
 net/ipv4/tcp_ipv4.c                                      |    6 
 net/ipv6/addrconf.c                                      |    8 
 net/ipv6/route.c                                         |    9 
 net/ipv6/seg6_hmac.c                                     |    1 
 net/ipv6/sit.c                                           |    8 
 net/mptcp/protocol.c                                     |    5 
 net/mptcp/protocol.h                                     |    2 
 net/mptcp/subflow.c                                      |   52 +++
 net/netfilter/nft_set_hash.c                             |    2 
 net/rose/rose_timer.c                                    |   34 +-
 net/sched/act_api.c                                      |   22 -
 net/sunrpc/xdr.c                                         |    2 
 net/tipc/node.c                                          |   41 +-
 tools/testing/selftests/net/bpf/Makefile                 |    2 
 tools/testing/selftests/net/mptcp/diag.sh                |   48 ++-
 tools/testing/selftests/net/mptcp/mptcp_connect.c        |    2 
 tools/testing/selftests/net/mptcp/mptcp_inq.c            |    2 
 tools/testing/selftests/net/mptcp/mptcp_sockopt.c        |    2 
 tools/testing/selftests/net/udpgso_bench.sh              |    2 
 110 files changed, 1012 insertions(+), 588 deletions(-)

Alan Adamson (1):
      nvmet: add a clear_ids attribute for passthru targets

Alex Deucher (2):
      drm/amdgpu: fix adev variable used in amdgpu_device_gpu_recover()
      Revert "drm/amdgpu/display: set vblank_disable_immediate for DC"

Alexey Khoroshilov (1):
      NFSD: restore EINVAL error translation in nfsd_commit()

Amir Goldstein (2):
      vfs: fix copy_file_range() regression in cross-fs copies
      fanotify: refine the validation checks on non-dir inode mask

Aneesh Kumar K.V (1):
      powerpc/memhotplug: Add add_pages override for PPC

Anshuman Gupta (1):
      drm/i915/dgfx: Disable d3cold at gfx root port

Carlos Llamas (1):
      drm/fourcc: fix integer type usage in uapi header

Casper Andersson (2):
      net: sparx5: Add handling of host MDB entries
      net: sparx5: mdb add/del handle non-sparx5 devices

Chris Ye (1):
      nvdimm: Fix badblocks clear off-by-one error

Christophe Leroy (1):
      powerpc/book3e: Fix PUD allocation size in map_kernel_page()

Chuck Lever (1):
      SUNRPC: Fix READ_PLUS crasher

Coleman Dietsch (1):
      selftests net: fix kselftest net fatal error

Dan Carpenter (1):
      net: fix IFF_TX_SKB_NO_LINEAR definition

Dimitris Michailidis (1):
      selftests/net: pass ipv6_args to udpgso_bench's IPv6 TCP test

Doug Berger (1):
      net: dsa: bcm_sf2: force pause link settings

Duoming Zhou (1):
      net: rose: fix UAF bugs caused by timer handler

Eddie James (1):
      hwmon: (occ) Prevent power cap command overwriting poll response

Eli Cohen (1):
      vdpa/mlx5: Update Control VQ callback information

Enguerrand de Ribaucourt (2):
      net: dp83822: disable false carrier interrupt
      net: dp83822: disable rx error interrupt

Eric Dumazet (4):
      net: bonding: fix possible NULL deref in rlb code
      tcp: add a missing nf_reset_ct() in 3WHS handling
      tunnels: do not assume mac header is set in skb_tunnel_check_pmtu()
      ipv6: fix lockdep splat in in6_dump_addrs()

Greg Kroah-Hartman (1):
      Linux 5.18.10

Hans de Goede (7):
      platform/x86: ideapad-laptop: Add Ideapad 5 15ITL05 to ideapad_dytc_v4_allow_table[]
      ACPI: video: Change how we determine if brightness key-presses are handled
      platform/x86: ideapad-laptop: Add allow_v4_dytc module parameter
      platform/x86: panasonic-laptop: sort includes alphabetically
      platform/x86: panasonic-laptop: revert "Resolve hotkey double trigger bug"
      platform/x86: panasonic-laptop: don't report duplicate brightness key-presses
      platform/x86: panasonic-laptop: filter out duplicate volume up/down/mute keypresses

Heinz Mauelshagen (1):
      dm raid: fix accesses beyond end of raid member array

Helge Deller (2):
      parisc: Fix vDSO signal breakage on 32-bit kernel
      parisc/unaligned: Fix emulate_ldw() breakage

Jakub Kicinski (3):
      net: tun: unlink NAPI from device on destruction
      net: tun: stop NAPI when detaching queues
      net: tun: avoid disabling NAPI twice

Jan Beulich (1):
      xen-netfront: restore __skb_queue_tail() positioning in xennet_get_responses()

Jason A. Donenfeld (2):
      ksmbd: use vfs_llseek instead of dereferencing NULL
      s390/archrandom: simplify back to earlier design and initialize earlier

Jason Wang (2):
      virtio-net: fix race between ndo_open() and virtio_device_ready()
      caif_virtio: fix race between virtio_device_ready() and ndo_open()

Jean Delvare (1):
      platform/x86: thinkpad_acpi: Fix a memory leak of EFCH MMIO resource

Jeff Layton (1):
      ceph: wait on async create before checking caps for syncfs

Jens Axboe (1):
      io_uring: ensure that send/sendmsg and recv/recvmsg check sqe->ioprio

Jinzhou Su (1):
      cpufreq: amd-pstate: Add resume and suspend callbacks

Jose Alonso (1):
      net: usb: ax88179_178a: Fix packet receiving

Kamal Heib (1):
      RDMA/qedr: Fix reporting QP timeout attribute

Krzysztof Kozlowski (1):
      nfc: nfcmrvl: Fix irq_of_parse_and_map() return value

Lamarque Vieira Souza (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA IM2P33F8ABR1

Liam Howlett (1):
      powerpc/prom_init: Fix kernel config grep

Liang He (2):
      net/dsa/hirschmann: Add missing of_node_get() in hellcreek_led_setup()
      drivers: cpufreq: Add missing of_node_put() in qoriq-cpufreq.c

Lukas Wunner (1):
      net: phy: Don't trigger state machine while in suspend

Masahiro Yamada (1):
      s390: remove unneeded 'select BUILD_BIN2C'

Mat Martineau (1):
      selftests: mptcp: Initialize variables to quiet gcc 12 warnings

Miaoqian Lin (2):
      RDMA/cm: Fix memory leak in ib_cm_insert_listen
      PM / devfreq: exynos-ppmu: Fix refcount leak in of_get_devfreq_events

Michael Walle (1):
      NFC: nxp-nci: Don't issue a zero length i2c_master_read()

Mikulas Patocka (1):
      dm raid: fix KASAN warning in raid5_add_disks

Namjae Jeon (2):
      ksmbd: set the range of bytes to zero without extending file size in FSCTL_ZERO_DATA
      ksmbd: check invalid FileOffset and BeyondFinalZero in FSCTL_ZERO_DATA

Naveen N. Rao (1):
      powerpc/bpf: Fix use of user_pt_regs in uapi

NeilBrown (1):
      NFS: restore module put when manager exits.

Nicolas Dichtel (1):
      ipv6: take care of disable_policy when restoring routes

Oleksandr Tyshchenko (1):
      xen/arm: Fix race in RB-tree based P2M accounting

Oleksij Rempel (3):
      net: usb: asix: do not force pause frames support
      net: asix: fix "can't send until first packet is send" issue
      net: phy: ax88772a: fix lost pause advertisement configuration

Oliver Neukum (1):
      usbnet: fix memory allocation in helpers

Ossama Othman (1):
      mptcp: fix conflict with <netinet/in.h>

Pablo Greco (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG SX6000LNP (AKA SPECTRIX S40G)

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: restore set element counter when failing to update

Paolo Abeni (2):
      mptcp: fix race on unaccepted mptcp sockets
      selftests: mptcp: more stable diag tests

Petr Machata (1):
      mlxsw: spectrum_router: Fix rollback in tunnel next hop init

Rob Clark (1):
      drm/msm/gem: Fix error return on fence id alloc fail

Roger Pau Monne (4):
      xen/blkfront: fix leaking data in shared pages
      xen/netfront: fix leaking data in shared pages
      xen/netfront: force data bouncing when backend is untrusted
      xen/blkfront: force data bouncing when backend is untrusted

Ruili Ji (1):
      drm/amdgpu: To flush tlb for MMHUB of RAVEN series

Sagi Grimberg (1):
      nvmet-tcp: fix regression in data_digest calculation

Scott Mayhew (1):
      NFSv4: Add an fattr allocation to _nfs4_discover_trunking()

Stefan Seyfried (1):
      platform/x86: panasonic-laptop: de-obfuscate button codes

Stephen Boyd (2):
      cpufreq: qcom-hw: Don't do lmh things without a throttle interrupt
      drm/msm/dpu: Increment vsync_cnt before waking up userspace

Steve French (1):
      cifs: fix minor compile warning

Tao Liu (1):
      linux/dim: Fix divide by 0 in RDMA DIM

Tong Zhang (1):
      epic100: fix use after free on rmmod

Victor Nogueira (1):
      net/sched: act_api: Notify user space if any actions were flushed before error

Vladimir Oltean (1):
      net: dsa: felix: fix race between reading PSFP stats and port stats

Xin Long (1):
      tipc: move bc link creation back to tipc_node_create

Yang Yingliang (1):
      hwmon: (ibmaem) don't call platform_device_del() if platform_device_add() fails

Yevhen Orlov (1):
      net: bonding: fix use-after-free after 802.3ad slave unbind

YueHaibing (1):
      net: ipv6: unexport __init-annotated seg6_hmac_net_init()

katrinzhou (2):
      ipv6/sit: fix ipip6_tunnel_get_prl return value
      drm/i915/gem: add missing else

wuchi (1):
      lib/sbitmap: Fix invalid loop in __sbitmap_queue_get_batch()

