Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D516E6212
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjDRM3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbjDRM3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:29:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601EB5596;
        Tue, 18 Apr 2023 05:29:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF27C631D6;
        Tue, 18 Apr 2023 12:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68D8C433EF;
        Tue, 18 Apr 2023 12:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820964;
        bh=wg0UV6H2Vd9CuxPHAGOaj4QG5JeDKEVWeZFyNQi7bnU=;
        h=From:To:Cc:Subject:Date:From;
        b=lLHpYr6fgQrBVCylFXybHakS37ygdhXmeYsWLgzsntcuepVQlHMA6lIKXDnv/ABV9
         EHkm8PLaa7g7Vb+YZ3t8IfUD1Y/1gMmzXuXKkLAFzC11OC3yhLQqm4iTpFswzLmb9r
         e4dAzRISAYUNMru4vqsbNIl9JGOdf0sGWJcxP05g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.4 00/92] 5.4.241-rc1 review
Date:   Tue, 18 Apr 2023 14:20:35 +0200
Message-Id: <20230418120304.658273364@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.241-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.241-rc1
X-KernelTest-Deadline: 2023-04-20T12:03+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.241 release.
There are 92 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.241-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.241-rc1

Darrick J. Wong <djwong@kernel.org>
    xfs: force log and push AIL to clear pinned inodes when aborting mount

Brian Foster <bfoster@redhat.com>
    xfs: don't reuse busy extents on extent trim

Brian Foster <bfoster@redhat.com>
    xfs: consider shutdown in bmapbt cursor delete assert

Darrick J. Wong <djwong@kernel.org>
    xfs: shut down the filesystem if we screw up quota reservation

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: report corruption only as a regular error

Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
    xfs: set inode size after creating symlink

Christoph Hellwig <hch@lst.de>
    xfs: fix up non-directory creation in SGID directories

Christoph Hellwig <hch@lst.de>
    xfs: remove the di_version field from struct icdinode

Christoph Hellwig <hch@lst.de>
    xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize

Christoph Hellwig <hch@lst.de>
    xfs: simplify di_flags2 inheritance in xfs_ialloc

Christoph Hellwig <hch@lst.de>
    xfs: only check the superblock version for dinode size calculation

Christoph Hellwig <hch@lst.de>
    xfs: add a new xfs_sb_version_has_v3inode helper

Christoph Hellwig <hch@lst.de>
    xfs: remove the kuid/kgid conversion wrappers

Christoph Hellwig <hch@lst.de>
    xfs: remove the icdinode di_uid/di_gid members

Christoph Hellwig <hch@lst.de>
    xfs: ensure that the inode uid/gid match values match the icdinode ones

Christoph Hellwig <hch@lst.de>
    xfs: merge the projid fields in struct xfs_icdinode

Kaixu Xia <kaixuxia@tencent.com>
    xfs: show the proper user quota options

Steve Clevenger <scclevenger@os.amperecomputing.com>
    coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug

George Cherian <george.cherian@marvell.com>
    watchdog: sbsa_wdog: Make sure the timeout programming is within the limits

Gregor Herburger <gregor.herburger@tq-group.com>
    i2c: ocores: generate stop condition after timeout in polling mode

ZhaoLong Wang <wangzhaolong1@huawei.com>
    ubi: Fix deadlock caused by recursively holding work_sem

Lee Jones <lee.jones@linaro.org>
    mtd: ubi: wl: Fix a couple of kernel-doc issues

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size

Robbie Harwood <rharwood@redhat.com>
    asymmetric_keys: log on fatal failures in PE/pkcs7

Robbie Harwood <rharwood@redhat.com>
    verify_pefile: relax wrapper length check

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Book X90F

Hans de Goede <hdegoede@redhat.com>
    efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L

Alexander Stein <alexander.stein@ew.tq-group.com>
    i2c: imx-lpi2c: clean rx/tx buffers upon new message

Grant Grundler <grundler@chromium.org>
    power: supply: cros_usbpd: reclassify "default case!" as debug

Roman Gushchin <roman.gushchin@linux.dev>
    net: macb: fix a memory corruption in extended buffer descriptor mode

Eric Dumazet <edumazet@google.com>
    udp6: fix potential access to stale information

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/core: Fix GID entry ref leak when create_ah fails

Xin Long <lucien.xin@gmail.com>
    sctp: fix a potential overflow in sctp_ifwdtsn_skip

Denis Plotnikov <den-plotnikov@yandex-team.ru>
    qlcnic: check pci_reset_function result

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    niu: Fix missing unwind goto in niu_alloc_channels()

Zheng Wang <zyytlz.wz@163.com>
    9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: remove unsupported EDO mode

Arseniy Krasnov <avkrasnov@sberdevices.ru>
    mtd: rawnand: meson: fix bitmask for length in command word

Bang Li <libang.linuxer@gmail.com>
    mtdblock: tolerate corrected bit-flips

Christoph Hellwig <hch@lst.de>
    btrfs: fix fast csum implementation detection

David Sterba <dsterba@suse.com>
    btrfs: print checksum type and implementation at mount time

Min Li <lm0963hack@gmail.com>
    Bluetooth: Fix race condition in hidp_session_thread

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: hda/sigmatel: fix S/PDIF out on Intel D*45* motherboards

Xu Biang <xubiang@hust.edu.cn>
    ALSA: firewire-tascam: add missing unwind goto in snd_tscm_stream_start_duplex()

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: i2c/cs8427: fix iec958 mixer control deactivation

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: hda/sigmatel: add pin overrides for Intel DP45SG motherboard

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emu10k1: fix capture interrupt handler unlinking

Kornel Dulęba <korneld@chromium.org>
    Revert "pinctrl: amd: Disable and mask interrupts on resume"

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Fix mapping-creation race

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Refactor __irq_domain_alloc_irqs()

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Look for existing mapping only once

Rongwei Wang <rongwei.wang@linux.alibaba.com>
    mm/swap: fix swap_info_struct race between swapoff and get_swap_pages()

Zheng Yejian <zhengyejian1@huawei.com>
    ring-buffer: Fix race while reader and writer are on the same page

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Fix the panfrost_mmu_map_fault_addr() error path

Pratyush Yadav <ptyadav@amazon.de>
    net_sched: prevent NULL dereference if default qdisc setup failed

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Free error logs of tracing instances

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: j1939_tp_tx_dat_new(): fix out-of-bounds memory access

John Keeping <john@metanate.com>
    ftrace: Mark get_lock_parent_ip() __always_inline

Kan Liang <kan.liang@linux.intel.com>
    perf/core: Fix the same task check in perf_event_set_output

Jeremy Soller <jeremy@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo X370SNW

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix sysfs interface lifetime

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: avoid checking for transfer complete when UARTCTRL_SBK is asserted in lpuart32_tx_empty

Biju Das <biju.das.jz@bp.renesas.com>
    tty: serial: sh-sci: Fix Rx on RZ/G2L SCI

Biju Das <biju.das.jz@bp.renesas.com>
    tty: serial: sh-sci: Fix transmit end interrupt handler

William Breathitt Gray <william.gray@linaro.org>
    iio: dac: cio-dac: Fix max DAC write value check for 12-bit

Lars-Peter Clausen <lars@metafoo.de>
    iio: adc: ti-ads7950: Set `can_sleep` flag for GPIO chip

Bjørn Mork <bjorn@mork.no>
    USB: serial: option: add Quectel RM500U-CN modem

Enrico Sau <enrico.sau@gmail.com>
    USB: serial: option: add Telit FE990 compositions

RD Babiera <rdbabiera@google.com>
    usb: typec: altmodes/displayport: Fix configure initial pin assignment

Kees Jan Koster <kjkoster@kjkoster.org>
    USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs

D Scott Phillips <scott@os.amperecomputing.com>
    xhci: also avoid the XHCI_ZERO_64B_REGS quirk with a passthrough iommu

Dai Ngo <dai.ngo@oracle.com>
    NFSD: callback request does not use correct credential for AUTH_SYS

Jeff Layton <jlayton@kernel.org>
    sunrpc: only free unix grouplist after RCU settles

Dhruva Gole <d-gole@ti.com>
    gpio: davinci: Add irq chip flag to skip set wake

Ziyang Xuan <william.xuanziyang@huawei.com>
    ipv6: Fix an uninit variable access bug in __ip6_make_skb()

Xin Long <lucien.xin@gmail.com>
    sctp: check send stream number after wait_for_sndbuf

Jakub Kicinski <kuba@kernel.org>
    net: don't let netpoll invoke NAPI if in xmit context

Eric Dumazet <edumazet@google.com>
    icmp: guard against too small mtu

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sprd: Explicitly set .polarity in .get_state()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: cros-ec: Explicitly set .polarity in .get_state()

Kornel Dulęba <korneld@chromium.org>
    pinctrl: amd: Disable and mask interrupts on resume

Sachi King <nakato@nakato.io>
    pinctrl: amd: disable and mask interrupts on probe

Linus Walleij <linus.walleij@linaro.org>
    pinctrl: amd: Use irqchip template

Steve French <stfrench@microsoft.com>
    smb3: fix problem with null cifs super block with previous patch

Kees Cook <keescook@chromium.org>
    treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()

Tom Saeger <tom.saeger@oracle.com>
    Revert "treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()"

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    x86/PCI: Add quirk for AMD XHCI controller that loses MSI-X state in D3hot

Jiri Kosina <jkosina@suse.cz>
    scsi: ses: Handle enclosure with just a primary component gracefully


-------------

Diffstat:

 Documentation/sound/hd-audio/models.rst         |   2 +-
 Makefile                                        |   4 +-
 arch/mips/lasat/picvue_proc.c                   |   2 +-
 arch/x86/kernel/sysfb_efi.c                     |   8 ++
 arch/x86/pci/fixup.c                            |  21 +++
 crypto/asymmetric_keys/pkcs7_verify.c           |  10 +-
 crypto/asymmetric_keys/verify_pefile.c          |  32 +++--
 drivers/gpio/gpio-davinci.c                     |   2 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c  |  13 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c         |   1 +
 drivers/hwtracing/coresight/coresight-etm4x.c   |   2 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c              |   2 +
 drivers/i2c/busses/i2c-ocores.c                 |  35 ++---
 drivers/iio/adc/ti-ads7950.c                    |   1 +
 drivers/iio/dac/cio-dac.c                       |   4 +-
 drivers/infiniband/core/verbs.c                 |   2 +
 drivers/mtd/mtdblock.c                          |  12 +-
 drivers/mtd/nand/raw/meson_nand.c               |   6 +-
 drivers/mtd/nand/raw/stm32_fmc2_nand.c          |   3 +
 drivers/mtd/ubi/build.c                         |  21 ++-
 drivers/mtd/ubi/wl.c                            |   5 +-
 drivers/net/ethernet/cadence/macb_main.c        |   4 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c |   8 +-
 drivers/net/ethernet/sun/niu.c                  |   2 +-
 drivers/pinctrl/pinctrl-amd.c                   |  52 +++++--
 drivers/power/supply/cros_usbpd-charger.c       |   2 +-
 drivers/pwm/pwm-cros-ec.c                       |   1 +
 drivers/pwm/pwm-sprd.c                          |   1 +
 drivers/scsi/ses.c                              |  20 ++-
 drivers/tty/serial/fsl_lpuart.c                 |   8 +-
 drivers/tty/serial/sh-sci.c                     |   9 +-
 drivers/usb/host/xhci.c                         |   6 +-
 drivers/usb/serial/cp210x.c                     |   1 +
 drivers/usb/serial/option.c                     |  10 ++
 drivers/usb/typec/altmodes/displayport.c        |   6 +-
 drivers/watchdog/sbsa_gwdt.c                    |   1 +
 fs/btrfs/disk-io.c                              |  17 +++
 fs/btrfs/super.c                                |   2 -
 fs/cifs/cifsproto.h                             |   2 +-
 fs/cifs/smb2ops.c                               |   2 +-
 fs/nfsd/nfs4callback.c                          |   4 +-
 fs/nilfs2/segment.c                             |   3 +-
 fs/nilfs2/super.c                               |   2 +
 fs/nilfs2/the_nilfs.c                           |  12 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                   |   5 +-
 fs/xfs/libxfs/xfs_bmap.c                        |  10 +-
 fs/xfs/libxfs/xfs_btree.c                       |  30 ++--
 fs/xfs/libxfs/xfs_format.h                      |  33 +++--
 fs/xfs/libxfs/xfs_ialloc.c                      |   6 +-
 fs/xfs/libxfs/xfs_inode_buf.c                   |  54 +++----
 fs/xfs/libxfs/xfs_inode_buf.h                   |   8 +-
 fs/xfs/libxfs/xfs_inode_fork.c                  |   2 +-
 fs/xfs/libxfs/xfs_inode_fork.h                  |   9 +-
 fs/xfs/libxfs/xfs_log_format.h                  |  10 +-
 fs/xfs/libxfs/xfs_trans_resv.c                  |   2 +-
 fs/xfs/xfs_acl.c                                |  12 +-
 fs/xfs/xfs_bmap_util.c                          |  16 +--
 fs/xfs/xfs_buf_item.c                           |   2 +-
 fs/xfs/xfs_dquot.c                              |   6 +-
 fs/xfs/xfs_error.c                              |   2 +-
 fs/xfs/xfs_extent_busy.c                        |  14 --
 fs/xfs/xfs_icache.c                             |   8 +-
 fs/xfs/xfs_inode.c                              |  61 +++-----
 fs/xfs/xfs_inode.h                              |  21 +--
 fs/xfs/xfs_inode_item.c                         |  20 ++-
 fs/xfs/xfs_ioctl.c                              |  22 ++-
 fs/xfs/xfs_iops.c                               |  11 +-
 fs/xfs/xfs_itable.c                             |   8 +-
 fs/xfs/xfs_linux.h                              |  32 +----
 fs/xfs/xfs_log_recover.c                        |   6 +-
 fs/xfs/xfs_mount.c                              |  90 ++++++------
 fs/xfs/xfs_qm.c                                 |  43 +++---
 fs/xfs/xfs_qm_bhv.c                             |   2 +-
 fs/xfs/xfs_quota.h                              |   4 +-
 fs/xfs/xfs_super.c                              |  10 +-
 fs/xfs/xfs_symlink.c                            |   7 +-
 fs/xfs/xfs_trans_dquot.c                        |  16 ++-
 include/linux/ftrace.h                          |   2 +-
 kernel/cgroup/cpuset.c                          |   6 +-
 kernel/events/core.c                            |   2 +-
 kernel/irq/irqdomain.c                          | 182 +++++++++++++++---------
 kernel/trace/ring_buffer.c                      |  13 +-
 kernel/trace/trace.c                            |   1 +
 mm/swapfile.c                                   |   3 +-
 net/9p/trans_xen.c                              |   4 +
 net/bluetooth/hidp/core.c                       |   2 +-
 net/bluetooth/l2cap_core.c                      |  24 +---
 net/can/j1939/transport.c                       |   5 +-
 net/core/netpoll.c                              |  19 ++-
 net/ipv4/icmp.c                                 |   5 +
 net/ipv6/ip6_output.c                           |   7 +-
 net/ipv6/udp.c                                  |   8 +-
 net/mac80211/sta_info.c                         |   3 +-
 net/sched/sch_generic.c                         |   1 +
 net/sctp/socket.c                               |   4 +
 net/sctp/stream_interleave.c                    |   3 +-
 net/sunrpc/svcauth_unix.c                       |  17 ++-
 sound/firewire/tascam/tascam-stream.c           |   2 +-
 sound/i2c/cs8427.c                              |   7 +-
 sound/pci/emu10k1/emupcm.c                      |   4 +-
 sound/pci/hda/patch_realtek.c                   |   1 +
 sound/pci/hda/patch_sigmatel.c                  |  10 ++
 102 files changed, 731 insertions(+), 549 deletions(-)


