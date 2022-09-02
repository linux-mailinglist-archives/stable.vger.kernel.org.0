Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14ABC5AAFDB
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbiIBMoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237436AbiIBMni (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:43:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62E4E9A9D;
        Fri,  2 Sep 2022 05:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7658FB82A71;
        Fri,  2 Sep 2022 12:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745F3C433D6;
        Fri,  2 Sep 2022 12:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121931;
        bh=TYn5xNj1+u/y1/C0FtNglHlJQAGkda7XdlvO94xulw0=;
        h=From:To:Cc:Subject:Date:From;
        b=1gxotqm23qQqpfKoxMyAGgx/6PHBQnTghrIL9CCMwWeoFCJ9fIUbi10/Y7wRbRcTs
         jlgh1O3oLGbvdhoN0PTq4wfvW7Ix/wX6ON1XlZbae8YN/PeJzzGEr3W8EUbTcVEI7z
         xLBUIESXSxxARQ15CphPmLM9w1BIKG52jsR+A0Dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 00/73] 5.15.65-rc1 review
Date:   Fri,  2 Sep 2022 14:18:24 +0200
Message-Id: <20220902121404.435662285@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.65-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.65-rc1
X-KernelTest-Deadline: 2022-09-04T12:14+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.65 release.
There are 73 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.65-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.65-rc1

Yang Yingliang <yangyingliang@huawei.com>
    net: neigh: don't call kfree_skb() under spin_lock_irqsave()

Zhengchao Shao <shaozhengchao@huawei.com>
    net/af_packet: check len when min_header_len equals to 0

Liam Howlett <liam.howlett@oracle.com>
    android: binder: fix lockdep check on clearing vma

Omar Sandoval <osandov@fb.com>
    btrfs: fix space cache corruption and potential double allocations

Kuniyuki Iwashima <kuniyu@amazon.com>
    kprobes: don't call disarm_kprobe() for disabled kprobes

Josef Bacik <josef@toxicpanda.com>
    btrfs: tree-checker: check for overlapping extent items

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix lockdep splat with reloc root extent buffers

Josef Bacik <josef@toxicpanda.com>
    btrfs: move lockdep class helpers to locking.c

Florian Westphal <fw@strlen.de>
    testing: selftests: nft_flowtable.sh: use random netns names

Geert Uytterhoeven <geert@linux-m68k.org>
    netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: avoid doing vm_init multiple time

Dusica Milinkovic <Dusica.Milinkovic@amd.com>
    drm/amdgpu: Increase tlb flush timeout for sriov

Ilya Bakoulin <Ilya.Bakoulin@amd.com>
    drm/amd/display: Fix pixel clock programming

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: add missing ->fini_microcode interface for Sienna Cichlid

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: don't remove dos attribute xattr on O_TRUNC open

Juergen Gross <jgross@suse.com>
    s390/hypfs: avoid error message under KVM

Denis V. Lunev <den@openvz.org>
    neigh: fix possible DoS due to net iface start/stop loop

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return STATUS_BAD_NETWORK_NAME error status if share is not configured

Fudong Wang <Fudong.Wang@amd.com>
    drm/amd/display: clear optc underflow before turn off odm clock

Alvin Lee <alvin.lee2@amd.com>
    drm/amd/display: For stereo keep "FLIP_ANY_FRAME"

Leo Ma <hanghong.ma@amd.com>
    drm/amd/display: Fix HDMI VSIF V3 incorrect issue

Josip Pavic <Josip.Pavic@amd.com>
    drm/amd/display: Avoid MPC infinite loop

Biju Das <biju.das.jz@bp.renesas.com>
    ASoC: sh: rz-ssi: Improve error handling in rz_ssi_probe() error path

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix work with fragmented xattr

Filipe Manana <fdmanana@suse.com>
    btrfs: fix warning during log replay when bumping inode link count

Filipe Manana <fdmanana@suse.com>
    btrfs: add and use helper for unlinking inode during log replay

Filipe Manana <fdmanana@suse.com>
    btrfs: remove no longer needed logic for replaying directory deletes

Filipe Manana <fdmanana@suse.com>
    btrfs: remove root argument from btrfs_unlink_inode()

Liming Sun <limings@nvidia.com>
    mmc: sdhci-of-dwcmshc: Re-enable support for the BlueField-3 SoC

Sebastian Reichel <sebastian.reichel@collabora.com>
    mmc: sdhci-of-dwcmshc: rename rk3568 to rk35xx

Yifeng Zhao <yifeng.zhao@rock-chips.com>
    mmc: sdhci-of-dwcmshc: add reset call back for rockchip Socs

Wenbin Mei <wenbin.mei@mediatek.com>
    mmc: mtk-sd: Clear interrupts when cqe off/disable

Chris Wilson <chris.p.wilson@intel.com>
    drm/i915/gt: Skip TLB invalidations once wedged

Michael Hübner <michaelh.95@t-online.de>
    HID: thrustmaster: Add sparco wheel and fix array length

Josh Kilmer <srjek2@gmail.com>
    HID: asus: ROG NKey: Ignore portion of 0x5a report

Akihiko Odaki <akihiko.odaki@gmail.com>
    HID: AMD_SFH: Add a DMI quirk entry for Chromebooks

Steev Klimaszewski <steev@kali.org>
    HID: add Lenovo Yoga C630 battery quirk

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add quirk for LH Labs Geek Out HD Audio 1V5

Jann Horn <jannh@google.com>
    mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse

Zhengchao Shao <shaozhengchao@huawei.com>
    bpf: Don't redirect packets with invalid pkt_len

Yang Jihong <yangjihong1@huawei.com>
    ftrace: Fix NULL pointer dereference in is_ftrace_trampoline when ftrace is dead

Letu Ren <fantasquex@gmail.com>
    fbdev: fb_pm2fb: Avoid potential divide by zero error

Hawkins Jiawei <yin31149@gmail.com>
    net: fix refcount bug in sk_psock_get (2)

Karthik Alapati <mail@karthek.com>
    HID: hidraw: fix memory leak in hidraw_release()

Dongliang Mu <mudongliangabcd@gmail.com>
    media: pvrusb2: fix memory leak in pvr_probe

Vivek Kasireddy <vivek.kasireddy@intel.com>
    udmabuf: Set the DMA mask for the udmabuf device (v2)

Lee Jones <lee.jones@linaro.org>
    HID: steam: Prevent NULL pointer dereference in steam_{recv,send}_report

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "PCI/portdrv: Don't disable AER reporting in get_port_device_capability()"

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix build errors in some archs

Jing Leng <jleng@ambarella.com>
    kbuild: Fix include path in scripts/Makefile.modpost

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix UAF due to missing POLLFREE handling

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix wrong arm_poll error handling

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fail links when poll fails

Jens Axboe <axboe@kernel.dk>
    io_uring: bump poll refs to full 31-bits

Jens Axboe <axboe@kernel.dk>
    io_uring: remove poll entry from list when canceling all

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    io_uring: Remove unused function req_ref_put

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: poll rework

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: inline io_poll_complete

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: kill poll linking optimisation

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: move common poll bits

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: refactor poll update

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: clean cqe filling functions

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: correct fill events helpers types

James Morse <james.morse@arm.com>
    arm64: errata: Add Cortex-A510 to the repeat tlbi list

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: avoid corrupting page->mapping in hugetlb_mcopy_atomic_pte

Boqun Feng <boqun.feng@gmail.com>
    Drivers: hv: balloon: Support status report for larger page sizes

Eric Biggers <ebiggers@google.com>
    crypto: lib - remove unneeded selection of XOR_BLOCKS

Timo Alho <talho@nvidia.com>
    firmware: tegra: bpmp: Do only aligned access to IPC memory area

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Depends on CONFIG_PM

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Rework power up

Adam Borowski <kilobyte@angband.pl>
    ACPI: thermal: drop an always true check

Maxime Ripard <maxime@cerno.tech>
    drm/bridge: Add stubs for devm_drm_of_get_bridge when OF is disabled

Jann Horn <jannh@google.com>
    mm: Force TLB flush for PFNMAP mappings before unlink_file_vma()


-------------

Diffstat:

 Documentation/arm64/silicon-errata.rst             |   2 +
 Makefile                                           |   4 +-
 arch/arm64/Kconfig                                 |  17 +
 arch/arm64/kernel/cpu_errata.c                     |   8 +-
 arch/s390/hypfs/hypfs_diag.c                       |   2 +-
 arch/s390/hypfs/inode.c                            |   2 +-
 drivers/acpi/thermal.c                             |   2 -
 drivers/android/binder_alloc.c                     |   9 +-
 drivers/dma-buf/udmabuf.c                          |  18 +-
 drivers/firmware/tegra/bpmp.c                      |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c             |   3 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |   3 +-
 .../gpu/drm/amd/display/dc/dce/dce_clock_source.c  |   2 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c   |   6 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c  |   5 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c   |   6 +
 .../gpu/drm/amd/display/dc/dcn21/dcn21_hubbub.c    |   8 +-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c  |   2 +-
 .../drm/amd/display/modules/freesync/freesync.c    |  15 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |   1 +
 drivers/gpu/drm/i915/gt/intel_gt.c                 |   3 +
 drivers/gpu/drm/vc4/Kconfig                        |   1 +
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  17 +-
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |  18 +
 drivers/hid/hid-asus.c                             |   7 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-input.c                            |   2 +
 drivers/hid/hid-steam.c                            |  10 +
 drivers/hid/hid-thrustmaster.c                     |   3 +-
 drivers/hid/hidraw.c                               |   3 +
 drivers/hv/hv_balloon.c                            |  13 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   1 +
 drivers/mmc/host/mtk-sd.c                          |   6 +
 drivers/mmc/host/sdhci-of-dwcmshc.c                |  88 ++-
 drivers/pci/pcie/portdrv_core.c                    |   9 +-
 drivers/video/fbdev/pm2fb.c                        |   5 +
 fs/btrfs/block-group.c                             |  47 +-
 fs/btrfs/block-group.h                             |   4 +-
 fs/btrfs/ctree.c                                   |   3 +
 fs/btrfs/ctree.h                                   |   4 +-
 fs/btrfs/disk-io.c                                 |  82 ---
 fs/btrfs/disk-io.h                                 |  10 -
 fs/btrfs/extent-tree.c                             |  48 +-
 fs/btrfs/extent_io.c                               |  11 +-
 fs/btrfs/inode.c                                   |  25 +-
 fs/btrfs/locking.c                                 |  91 +++
 fs/btrfs/locking.h                                 |  14 +
 fs/btrfs/relocation.c                              |   2 +
 fs/btrfs/tree-checker.c                            |  25 +-
 fs/btrfs/tree-log.c                                | 221 +++---
 fs/io_uring.c                                      | 746 ++++++++++-----------
 fs/ksmbd/mgmt/tree_connect.c                       |   2 +-
 fs/ksmbd/smb2pdu.c                                 |  21 +-
 fs/ntfs3/xattr.c                                   |   7 +-
 include/drm/drm_bridge.h                           |  13 +-
 include/linux/rmap.h                               |   7 +-
 include/linux/skbuff.h                             |   8 +
 include/linux/skmsg.h                              |   3 +-
 include/net/sock.h                                 |  68 +-
 include/uapi/linux/btrfs_tree.h                    |   4 +-
 kernel/kprobes.c                                   |   9 +-
 kernel/trace/ftrace.c                              |  10 +
 lib/crypto/Kconfig                                 |   1 -
 mm/hugetlb.c                                       |   2 +-
 mm/mmap.c                                          |  12 +
 mm/rmap.c                                          |  29 +-
 net/bluetooth/l2cap_core.c                         |  10 +-
 net/bpf/test_run.c                                 |   3 +
 net/core/dev.c                                     |   1 +
 net/core/neighbour.c                               |  27 +-
 net/core/skmsg.c                                   |   4 +-
 net/netfilter/Kconfig                              |   1 -
 net/packet/af_packet.c                             |   4 +-
 scripts/Makefile.modpost                           |   3 +-
 sound/soc/sh/rz-ssi.c                              |  26 +-
 sound/usb/quirks.c                                 |   2 +
 tools/testing/selftests/netfilter/nft_flowtable.sh | 246 +++----
 78 files changed, 1195 insertions(+), 971 deletions(-)


