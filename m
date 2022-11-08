Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B648621339
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbiKHNsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbiKHNsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:48:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C8F60E89;
        Tue,  8 Nov 2022 05:48:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D7F4B81AF2;
        Tue,  8 Nov 2022 13:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618BDC433D6;
        Tue,  8 Nov 2022 13:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915286;
        bh=a+c4QQlBB/Q+Ynf6PCCd5YckR1Jyflz251X2wL60TH0=;
        h=From:To:Cc:Subject:Date:From;
        b=QtogS3jUfP/tFwA2JaIWHI7zENWSXKDtJ7c93M14lbN3oO25MTpofcRN3j/AL4gGC
         fcJHYZPiFdt/M1oQcnB1xXFBY4Qaufjf095ThVFpoYTl5Z/C+khqyYnLAGzzdsLTSm
         XzgTKZ5dusCqsrBxUpERCrJJUJmFMhIyVxJ5FNGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: [PATCH 5.4 00/74] 5.4.224-rc1 review
Date:   Tue,  8 Nov 2022 14:38:28 +0100
Message-Id: <20221108133333.659601604@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.224-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.224-rc1
X-KernelTest-Deadline: 2022-11-10T13:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.224 release.
There are 74 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.224-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.224-rc1

Vasily Averin <vvs@virtuozzo.com>
    ipc: remove memcg accounting for sops objects in do_semtimedop()

Dokyung Song <dokyung.song@gmail.com>
    wifi: brcmfmac: Fix potential buffer overflow in brcmf_fweh_event_worker()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/sdvo: Setup DDC fully before output init

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/sdvo: Filter out invalid outputs more sensibly

Brian Norris <briannorris@chromium.org>
    drm/rockchip: dsi: Force synchronous probe

Sascha Hauer <s.hauer@pengutronix.de>
    mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on program/erase times

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: update the emulation mode after CR0 write

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: introduce emulator_recalc_and_set_mode

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: em_sysexit should update ctxt->mode

Jim Mattson <jmattson@google.com>
    KVM: x86: Mask off reserved bits in CPUID.80000008H

Jim Mattson <jmattson@google.com>
    KVM: x86: Mask off reserved bits in CPUID.8000001AH

Luís Henriques <lhenriques@suse.de>
    ext4: fix BUG_ON() when directory entry has invalid rec_len

Ye Bin <yebin10@huawei.com>
    ext4: fix warning in 'ext4_da_release_space'

Helge Deller <deller@gmx.de>
    parisc: Avoid printing the hardware path twice

Helge Deller <deller@gmx.de>
    parisc: Export iosapic_serial_irq() symbol for serial port driver

Helge Deller <deller@gmx.de>
    parisc: Make 8250_gsc driver dependend on CONFIG_PARISC

John Veness <john-linux@pelago.org.uk>
    ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106 devices

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Add Cooper Lake stepping to isolation_ucodes[]

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix pebs event constraints for ICL

Ard Biesheuvel <ardb@kernel.org>
    efi: random: reduce seed size to 32 bytes

Miklos Szeredi <mszeredi@redhat.com>
    fuse: add file_modified() to fallocate

Gaosheng Cui <cuigaosheng1@huawei.com>
    capabilities: fix potential memleak on error path from vfs_getxattr_alloc()

Zheng Yejian <zhengyejian1@huawei.com>
    tracing/histogram: Update document for KEYS_MAX size

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    tools/nolibc/string: Fix memcmp() implementation

Li Qiang <liq3ea@163.com>
    kprobe: reverse kp->flags when arm_kprobe failed

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/udp: Make early_demux back namespacified.

David Sterba <dsterba@suse.com>
    btrfs: fix type of parameter generation in btrfs_get_dentry

Carlos Llamas <cmllamas@google.com>
    binder: fix UAF of alloc->vma in race with munmap()

Vasily Averin <vvs@virtuozzo.com>
    memcg: enable accounting of ipc resources

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/udp: Fix memory leak in ipv6_renew_options().

Yu Kuai <yukuai3@huawei.com>
    block, bfq: protect 'bfqd->queued' by 'bfqd->lock'

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix attempting to access uninitialized memory

Chuhong Yuan <hslester96@gmail.com>
    xfs: Add the missed xfs_perag_put() for xfs_ifree_cluster()

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: don't fail unwritten extent conversion on writeback due to edquot

Eric Sandeen <sandeen@redhat.com>
    xfs: group quota should return EDQUOT when prj quota enabled

Dave Chinner <david@fromorbit.com>
    xfs: gut error handling in xfs_trans_unreserve_and_mod_sb()

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: use ordered buffers to initialize dquot buffers during quotacheck

Brian Foster <bfoster@redhat.com>
    xfs: don't fail verifier on empty attr3 leaf block

Martin Tůma <martin.tuma@digiteqautomotive.com>
    i2c: xiic: Add platform module alias

Samuel Bailey <samuel.bailey1@gmail.com>
    HID: saitek: add madcatz variant of MMO7 mouse device ID

Uday Shankar <ushankar@purestorage.com>
    scsi: core: Restrict legal sdev_state transitions via sysfs

Hangyu Hua <hbh25y@gmail.com>
    media: meson: vdec: fix possible refcount leak in vdec_probe()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: dvb-frontends/drxk: initialize err to 0

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cros-ec-cec: limit msg.len to CEC_MAX_MSG_SIZE

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: s5p_cec: limit msg.len to CEC_MAX_MSG_SIZE

Zhengchao Shao <shaozhengchao@huawei.com>
    ipv6: fix WARNING in ip6_route_net_exit_late()

Chen Zhongjin <chenzhongjin@huawei.com>
    net, neigh: Fix null-ptr-deref in neigh_table_clear()

Gaosheng Cui <cuigaosheng1@huawei.com>
    net: mdio: fix undefined behavior in bit shift for __mdiobus_register

Zhengchao Shao <shaozhengchao@huawei.com>
    Bluetooth: L2CAP: fix use-after-free in l2cap_conn_del()

Maxim Mikityanskiy <maxtram95@gmail.com>
    Bluetooth: L2CAP: Fix use-after-free caused by l2cap_reassemble_sdu

Filipe Manana <fdmanana@suse.com>
    btrfs: fix ulist leaks in error paths of qgroup self tests

Filipe Manana <fdmanana@suse.com>
    btrfs: fix inode list leak during backref walking at find_parent_nodes()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix inode list leak during backref walking at resolve_indirect_refs()

Yang Yingliang <yangyingliang@huawei.com>
    isdn: mISDN: netjet: fix wrong check of device registration

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: fix possible memory leak in mISDN_register_device()

Zhang Qilong <zhangqilong3@huawei.com>
    rose: Fix NULL pointer dereference in rose_send_frame()

Zhengchao Shao <shaozhengchao@huawei.com>
    ipvs: fix WARNING in ip_vs_app_net_cleanup()

Zhengchao Shao <shaozhengchao@huawei.com>
    ipvs: fix WARNING in __ip_vs_cleanup_batch()

Jason A. Donenfeld <Jason@zx2c4.com>
    ipvs: use explicitly signed chars

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: release flow rule object from commit path

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: tun: fix bugs for oversize packet when napi frags enabled

Dan Carpenter <dan.carpenter@oracle.com>
    net: sched: Fix use after free in red_enqueue()

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: pata_legacy: fix pdc20230_set_piomode()

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: fec: fix improper use of NETDEV_TX_BUSY

Shang XiaoJing <shangxiaojing@huawei.com>
    nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()

Shang XiaoJing <shangxiaojing@huawei.com>
    nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()

Dan Carpenter <dan.carpenter@oracle.com>
    RDMA/qedr: clean up work queue on failure in qedr_alloc_resources()

Chen Zhongjin <chenzhongjin@huawei.com>
    RDMA/core: Fix null-ptr-deref in ib_core_cleanup()

Chen Zhongjin <chenzhongjin@huawei.com>
    net: dsa: Fix possible memory leaks in dsa_loop_init()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    nfs4: Fix kmemleak when allocate slot failed

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.1: We must always send RECLAIM_COMPLETE after a reboot

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.1: Handle RECLAIM_COMPLETE trunking errors

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Correctly move list in sc_disable()

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/cma: Use output interface for net_dev check


-------------

Diffstat:

 Documentation/trace/histogram.rst                  |   2 +-
 Makefile                                           |   4 +-
 arch/parisc/include/asm/hardware.h                 |  12 +-
 arch/parisc/kernel/drivers.c                       |  14 +-
 arch/x86/events/intel/core.c                       |   1 +
 arch/x86/events/intel/ds.c                         |   9 +-
 arch/x86/kvm/cpuid.c                               |   4 +
 arch/x86/kvm/emulate.c                             | 102 +++++++++----
 block/bfq-iosched.c                                |   4 +-
 drivers/android/binder_alloc.c                     |   6 +-
 drivers/ata/pata_legacy.c                          |   5 +-
 drivers/firmware/efi/efi.c                         |   2 +-
 drivers/gpu/drm/i915/display/intel_sdvo.c          |  58 +++++---
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c    |   6 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-saitek.c                           |   2 +
 drivers/i2c/busses/i2c-xiic.c                      |   1 +
 drivers/infiniband/core/cma.c                      |   2 +-
 drivers/infiniband/core/device.c                   |  10 +-
 drivers/infiniband/core/nldev.c                    |   2 +-
 drivers/infiniband/hw/hfi1/pio.c                   |   3 +-
 drivers/infiniband/hw/qedr/main.c                  |   9 +-
 drivers/isdn/hardware/mISDN/netjet.c               |   2 +-
 drivers/isdn/mISDN/core.c                          |   5 +-
 drivers/media/dvb-frontends/drxk_hard.c            |   2 +-
 drivers/media/platform/cros-ec-cec/cros-ec-cec.c   |   2 +
 drivers/media/platform/s5p-cec/s5p_cec.c           |   2 +
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |   6 +-
 drivers/net/dsa/dsa_loop.c                         |  25 +++-
 drivers/net/ethernet/freescale/fec_main.c          |   4 +-
 drivers/net/phy/mdio_bus.c                         |   2 +-
 drivers/net/tun.c                                  |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |   4 +
 drivers/nfc/nfcmrvl/i2c.c                          |   7 +-
 drivers/nfc/s3fwrn5/core.c                         |   8 +-
 drivers/parisc/iosapic.c                           |   1 +
 drivers/scsi/scsi_sysfs.c                          |   8 +
 drivers/staging/media/meson/vdec/vdec.c            |   2 +
 drivers/tty/serial/8250/Kconfig                    |   2 +-
 fs/btrfs/backref.c                                 |  54 ++++---
 fs/btrfs/export.c                                  |   2 +-
 fs/btrfs/export.h                                  |   2 +-
 fs/btrfs/tests/qgroup-tests.c                      |  20 ++-
 fs/ext4/migrate.c                                  |   3 +-
 fs/ext4/namei.c                                    |  10 +-
 fs/fuse/file.c                                     |   4 +
 fs/nfs/nfs4client.c                                |   1 +
 fs/nfs/nfs4state.c                                 |   2 +
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   8 -
 fs/xfs/libxfs/xfs_defer.c                          |  10 +-
 fs/xfs/xfs_dquot.c                                 |  56 +++++--
 fs/xfs/xfs_inode.c                                 |   4 +-
 fs/xfs/xfs_iomap.c                                 |   2 +-
 fs/xfs/xfs_trans.c                                 | 163 +++------------------
 fs/xfs/xfs_trans_dquot.c                           |   3 +-
 include/linux/efi.h                                |   2 +-
 include/net/protocol.h                             |   4 -
 include/net/tcp.h                                  |   2 +
 include/net/udp.h                                  |   1 +
 ipc/msg.c                                          |   2 +-
 ipc/sem.c                                          |   6 +-
 ipc/shm.c                                          |   2 +-
 kernel/kprobes.c                                   |   5 +-
 net/bluetooth/l2cap_core.c                         |  52 ++++++-
 net/core/neighbour.c                               |   2 +-
 net/ipv4/af_inet.c                                 |  14 +-
 net/ipv4/ip_input.c                                |  37 +++--
 net/ipv4/sysctl_net_ipv4.c                         |  59 +-------
 net/ipv6/ip6_input.c                               |  26 ++--
 net/ipv6/ipv6_sockglue.c                           |   7 +
 net/ipv6/route.c                                   |  14 +-
 net/ipv6/tcp_ipv6.c                                |   9 +-
 net/ipv6/udp.c                                     |   9 +-
 net/netfilter/ipvs/ip_vs_app.c                     |  10 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |  30 +++-
 net/netfilter/nf_tables_api.c                      |   6 +-
 net/rose/rose_link.c                               |   3 +
 net/sched/sch_red.c                                |   4 +-
 security/commoncap.c                               |   6 +-
 sound/usb/quirks-table.h                           |  58 ++++++++
 sound/usb/quirks.c                                 |   1 +
 tools/include/nolibc/nolibc.h                      |   4 +-
 83 files changed, 611 insertions(+), 453 deletions(-)


