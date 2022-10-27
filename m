Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A9360FED5
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237068AbiJ0RIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237075AbiJ0RIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:08:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F0B19E028;
        Thu, 27 Oct 2022 10:08:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61FD362401;
        Thu, 27 Oct 2022 17:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E89C433D6;
        Thu, 27 Oct 2022 17:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890526;
        bh=Lq7LJZcP5Yu8aPY3o8VXESbwFbv3YfFz670zINCrEVQ=;
        h=From:To:Cc:Subject:Date:From;
        b=COd72wvErQsc5+7B7KPqc0+/ylYnjqiFEDTyfhu3N/auJtiGXWHNHzOrGEWczAWK4
         F91CWEcfX20useeOa6Dka6qTmdXtaqecZ56gz2DVE+GXLJsz8qLMNCF+wPjKv6RqLl
         i9GLNPgsi443YnPzJ9E8encabruS2jyE5NOOE2M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: [PATCH 5.4 00/53] 5.4.221-rc1 review
Date:   Thu, 27 Oct 2022 18:55:48 +0200
Message-Id: <20221027165049.817124510@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.221-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.221-rc1
X-KernelTest-Deadline: 2022-10-29T16:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.221 release.
There are 53 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.221-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.221-rc1

Seth Jenkins <sethjenkins@google.com>
    mm: /proc/pid/smaps_rollup: fix no vma's null-deref

Gaurav Kohli <gauravkohli@linux.microsoft.com>
    hv_netvsc: Fix race between VF offering and VF association message from host

Nick Desaulniers <ndesaulniers@google.com>
    Makefile.debug: re-enable debug info for .S files

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Force backlight native for more TongFang devices

Conor Dooley <conor.dooley@microchip.com>
    riscv: topology: fix default topology reporting

Conor Dooley <conor.dooley@microchip.com>
    arm64: topology: move store_cpu_topology() to shared code

Jerry Snitselaar <jsnitsel@redhat.com>
    iommu/vt-d: Clean up si_domain in the init_dmars() error path

Yang Yingliang <yangyingliang@huawei.com>
    net: hns: fix possible memory leak in hnae_ae_register()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: sched: cake: fix null pointer access issue when cake_init() fails

Harini Katakam <harini.katakam@amd.com>
    net: phy: dp83867: Extend RX strap quirk for SGMII mode

Xiaobo Liu <cppcoffee@gmail.com>
    net/atm: fix proc_mpc_write incorrect return value

José Expósito <jose.exposito89@gmail.com>
    HID: magicmouse: Do not set BTN_MOUSE on double report

Alexander Potapenko <glider@google.com>
    tipc: fix an information leak in tipc_topsrv_kern_subscr

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    tipc: Fix recognition of trial period

Tony Luck <tony.luck@intel.com>
    ACPI: extlog: Handle multiple records

Filipe Manana <fdmanana@suse.com>
    btrfs: fix processing of delayed tree block refs during backref walking

Filipe Manana <fdmanana@suse.com>
    btrfs: fix processing of delayed data refs during backref walking

Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
    r8152: add PID for the Lenovo OneLink+ Dock

James Morse <james.morse@arm.com>
    arm64: errata: Remove AES hwcap for COMPAT tasks

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: venus: dec: Handle the case where find_format fails

Eric Ren <renzhengeek@gmail.com>
    KVM: arm64: vgic: Fix exit condition in scan_its_table()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ata: ahci: Match EM_MAX_SLOTS with SATA_PMP_MAX_PORTS

Alexander Stein <alexander.stein@ew.tq-group.com>
    ata: ahci-imx: Fix MODULE_ALIAS

Zhang Rui <rui.zhang@intel.com>
    hwmon/coretemp: Handle large core ID value

Borislav Petkov <bp@suse.de>
    x86/microcode/AMD: Apply the patch early on every logical thread

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix BUG when iput after ocfs2_mknod fails

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: clear dinode links count in case of error

Dave Chinner <dchinner@redhat.com>
    xfs: fix use-after-free on CIL context on shutdown

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: move inode flush to the sync workqueue

Christoph Hellwig <hch@lst.de>
    xfs: reflink should force the log out if mounted with wsync

Christoph Hellwig <hch@lst.de>
    xfs: factor out a new xfs_log_force_inode helper

Brian Foster <bfoster@redhat.com>
    xfs: trylock underlying buffer on dquot flush

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: don't write a corrupt unmount record to force summary counter recalc

Dave Chinner <dchinner@redhat.com>
    xfs: tail updates only need to occur when LSN changes

Dave Chinner <dchinner@redhat.com>
    xfs: factor common AIL item deletion code

Dave Chinner <dchinner@redhat.com>
    xfs: Throttle commits on delayed background CIL push

Dave Chinner <dchinner@redhat.com>
    xfs: Lower CIL flush limit for large logs

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: preserve default grace interval during quotacheck

Brian Foster <bfoster@redhat.com>
    xfs: fix unmount hang and memory leak on shutdown during quotaoff

Brian Foster <bfoster@redhat.com>
    xfs: factor out quotaoff intent AIL removal and memory free

Pavel Reichl <preichl@redhat.com>
    xfs: Replace function declaration by actual definition

Pavel Reichl <preichl@redhat.com>
    xfs: remove the xfs_qoff_logitem_t typedef

Pavel Reichl <preichl@redhat.com>
    xfs: remove the xfs_dq_logitem_t typedef

Pavel Reichl <preichl@redhat.com>
    xfs: remove the xfs_disk_dquot_t and xfs_dquot_t

Takashi Iwai <tiwai@suse.de>
    xfs: Use scnprintf() for avoiding potential buffer overflow

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: check owner of dir3 blocks

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: check owner of dir3 data blocks

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix buffer corruption reporting when xfs_dir3_free_header_check fails

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: xfs_buf_corruption_error should take __this_address

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: add a function to deal with corrupt buffers post-verifiers

Brian Foster <bfoster@redhat.com>
    xfs: rework collapse range into an atomic operation

Brian Foster <bfoster@redhat.com>
    xfs: rework insert range into an atomic operation

Brian Foster <bfoster@redhat.com>
    xfs: open code insert range extent split helper


-------------

Diffstat:

 Documentation/arm64/silicon-errata.rst    |   4 +
 Makefile                                  |   8 +-
 arch/arm64/Kconfig                        |  16 ++++
 arch/arm64/include/asm/cpucaps.h          |   3 +-
 arch/arm64/kernel/cpu_errata.c            |  16 ++++
 arch/arm64/kernel/cpufeature.c            |  13 ++-
 arch/arm64/kernel/topology.c              |  40 ---------
 arch/riscv/Kconfig                        |   2 +-
 arch/riscv/kernel/smpboot.c               |   4 +-
 arch/x86/kernel/cpu/microcode/amd.c       |  16 +++-
 drivers/acpi/acpi_extlog.c                |  33 ++++---
 drivers/acpi/video_detect.c               |  64 ++++++++++++++
 drivers/ata/ahci.h                        |   2 +-
 drivers/ata/ahci_imx.c                    |   2 +-
 drivers/base/arch_topology.c              |  19 ++++
 drivers/hid/hid-magicmouse.c              |   2 +-
 drivers/hwmon/coretemp.c                  |  56 ++++++++----
 drivers/iommu/intel-iommu.c               |   5 ++
 drivers/media/platform/qcom/venus/vdec.c  |   2 +
 drivers/net/ethernet/hisilicon/hns/hnae.c |   4 +-
 drivers/net/hyperv/hyperv_net.h           |   3 +
 drivers/net/hyperv/netvsc.c               |   4 +
 drivers/net/hyperv/netvsc_drv.c           |  20 +++++
 drivers/net/phy/dp83867.c                 |   8 ++
 drivers/net/usb/cdc_ether.c               |   7 ++
 drivers/net/usb/r8152.c                   |   1 +
 fs/btrfs/backref.c                        |  46 ++++++----
 fs/ocfs2/namei.c                          |  23 +++--
 fs/proc/task_mmu.c                        |   2 +-
 fs/xfs/libxfs/xfs_alloc.c                 |   2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c             |   6 +-
 fs/xfs/libxfs/xfs_bmap.c                  |  32 +------
 fs/xfs/libxfs/xfs_bmap.h                  |   3 +-
 fs/xfs/libxfs/xfs_btree.c                 |   2 +-
 fs/xfs/libxfs/xfs_da_btree.c              |  10 +--
 fs/xfs/libxfs/xfs_dir2_block.c            |  33 ++++++-
 fs/xfs/libxfs/xfs_dir2_data.c             |  32 ++++++-
 fs/xfs/libxfs/xfs_dir2_leaf.c             |   2 +-
 fs/xfs/libxfs/xfs_dir2_node.c             |   8 +-
 fs/xfs/libxfs/xfs_dquot_buf.c             |   8 +-
 fs/xfs/libxfs/xfs_format.h                |  10 +--
 fs/xfs/libxfs/xfs_trans_resv.c            |   6 +-
 fs/xfs/xfs_attr_inactive.c                |   6 +-
 fs/xfs/xfs_attr_list.c                    |   2 +-
 fs/xfs/xfs_bmap_util.c                    |  57 ++++++------
 fs/xfs/xfs_buf.c                          |  22 +++++
 fs/xfs/xfs_buf.h                          |   2 +
 fs/xfs/xfs_dquot.c                        |  26 +++---
 fs/xfs/xfs_dquot.h                        |  98 +++++++++++----------
 fs/xfs/xfs_dquot_item.c                   |  47 +++++++---
 fs/xfs/xfs_dquot_item.h                   |  35 ++++----
 fs/xfs/xfs_error.c                        |   7 +-
 fs/xfs/xfs_error.h                        |   2 +-
 fs/xfs/xfs_export.c                       |  14 +--
 fs/xfs/xfs_file.c                         |  16 ++--
 fs/xfs/xfs_inode.c                        |  23 ++++-
 fs/xfs/xfs_inode.h                        |   1 +
 fs/xfs/xfs_inode_item.c                   |  28 +++---
 fs/xfs/xfs_log.c                          |  26 +++---
 fs/xfs/xfs_log_cil.c                      |  39 ++++++--
 fs/xfs/xfs_log_priv.h                     |  53 +++++++++--
 fs/xfs/xfs_log_recover.c                  |   5 +-
 fs/xfs/xfs_mount.h                        |   5 ++
 fs/xfs/xfs_qm.c                           |  64 ++++++++------
 fs/xfs/xfs_qm_bhv.c                       |   6 +-
 fs/xfs/xfs_qm_syscalls.c                  | 142 +++++++++++++++---------------
 fs/xfs/xfs_stats.c                        |  10 +--
 fs/xfs/xfs_super.c                        |  28 ++++--
 fs/xfs/xfs_trace.h                        |   1 +
 fs/xfs/xfs_trans_ail.c                    |  88 +++++++++++-------
 fs/xfs/xfs_trans_dquot.c                  |  54 ++++++------
 fs/xfs/xfs_trans_priv.h                   |   6 +-
 net/atm/mpoa_proc.c                       |   3 +-
 net/sched/sch_cake.c                      |   4 +
 net/tipc/discover.c                       |   2 +-
 net/tipc/topsrv.c                         |   2 +-
 virt/kvm/arm/vgic/vgic-its.c              |   5 +-
 77 files changed, 973 insertions(+), 535 deletions(-)


