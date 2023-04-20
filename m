Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B00B6E902F
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 12:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbjDTK2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 06:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbjDTK11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 06:27:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE53A7EE3;
        Thu, 20 Apr 2023 03:26:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20FE864707;
        Thu, 20 Apr 2023 10:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AB4C4339C;
        Thu, 20 Apr 2023 10:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681986374;
        bh=MqBHVIN2pTzjzhjF9jGCWkFaaxaskLk4UY04oHRd8Uk=;
        h=From:To:Cc:Subject:Date:From;
        b=vgMcFis8cXGjaCR782jm1u+nMpnSYAwxO6PVC3Qvbt78Z4C6rOicH5pbYVc39fI+d
         bu7P3s9vc1f3WTCB+z7of04BBQVJGKt0gIUNPQTKwM0zaKGE0IhdDGw3JD1rnK8W+K
         5bBi2qLTE6nt8XkqbvUpaT7IQ56R/lhTCZiCHjt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.241
Date:   Thu, 20 Apr 2023 12:26:07 +0200
Message-Id: <2023042007-monstrous-promenade-9328@gregkh>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
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

I'm announcing the release of the 5.4.241 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/sound/hd-audio/models.rst         |    2 
 Makefile                                        |    2 
 arch/mips/lasat/picvue_proc.c                   |    2 
 arch/x86/kernel/sysfb_efi.c                     |    8 +
 arch/x86/pci/fixup.c                            |   21 ++
 crypto/asymmetric_keys/pkcs7_verify.c           |   10 -
 crypto/asymmetric_keys/verify_pefile.c          |   32 ++--
 drivers/gpio/gpio-davinci.c                     |    2 
 drivers/gpu/drm/drm_panel_orientation_quirks.c  |   13 +
 drivers/gpu/drm/panfrost/panfrost_mmu.c         |    1 
 drivers/hwtracing/coresight/coresight-etm4x.c   |    2 
 drivers/i2c/busses/i2c-imx-lpi2c.c              |    2 
 drivers/i2c/busses/i2c-ocores.c                 |   35 ++--
 drivers/iio/adc/ti-ads7950.c                    |    1 
 drivers/iio/dac/cio-dac.c                       |    4 
 drivers/infiniband/core/verbs.c                 |    2 
 drivers/mtd/mtdblock.c                          |   12 +
 drivers/mtd/nand/raw/meson_nand.c               |    6 
 drivers/mtd/nand/raw/stm32_fmc2_nand.c          |    3 
 drivers/mtd/ubi/build.c                         |   21 +-
 drivers/mtd/ubi/wl.c                            |    5 
 drivers/net/ethernet/cadence/macb_main.c        |    4 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c |    8 -
 drivers/net/ethernet/sun/niu.c                  |    2 
 drivers/pinctrl/pinctrl-amd.c                   |   52 +++++-
 drivers/power/supply/cros_usbpd-charger.c       |    2 
 drivers/pwm/pwm-cros-ec.c                       |    1 
 drivers/pwm/pwm-sprd.c                          |    1 
 drivers/scsi/ses.c                              |   20 +-
 drivers/tty/serial/fsl_lpuart.c                 |    8 -
 drivers/tty/serial/sh-sci.c                     |    9 +
 drivers/usb/host/xhci.c                         |    6 
 drivers/usb/serial/cp210x.c                     |    1 
 drivers/usb/serial/option.c                     |   10 +
 drivers/usb/typec/altmodes/displayport.c        |    6 
 drivers/watchdog/sbsa_gwdt.c                    |    1 
 fs/btrfs/disk-io.c                              |   17 ++
 fs/btrfs/super.c                                |    2 
 fs/cifs/cifsproto.h                             |    2 
 fs/cifs/smb2ops.c                               |    2 
 fs/nfsd/nfs4callback.c                          |    4 
 fs/nilfs2/segment.c                             |    3 
 fs/nilfs2/super.c                               |    2 
 fs/nilfs2/the_nilfs.c                           |   12 -
 fs/xfs/libxfs/xfs_attr_leaf.c                   |    5 
 fs/xfs/libxfs/xfs_bmap.c                        |   10 -
 fs/xfs/libxfs/xfs_btree.c                       |   30 +--
 fs/xfs/libxfs/xfs_format.h                      |   33 +++-
 fs/xfs/libxfs/xfs_ialloc.c                      |    6 
 fs/xfs/libxfs/xfs_inode_buf.c                   |   54 ++-----
 fs/xfs/libxfs/xfs_inode_buf.h                   |    8 -
 fs/xfs/libxfs/xfs_inode_fork.c                  |    2 
 fs/xfs/libxfs/xfs_inode_fork.h                  |    9 -
 fs/xfs/libxfs/xfs_log_format.h                  |   10 -
 fs/xfs/libxfs/xfs_trans_resv.c                  |    2 
 fs/xfs/xfs_acl.c                                |   12 +
 fs/xfs/xfs_bmap_util.c                          |   16 +-
 fs/xfs/xfs_buf_item.c                           |    2 
 fs/xfs/xfs_dquot.c                              |    6 
 fs/xfs/xfs_error.c                              |    2 
 fs/xfs/xfs_extent_busy.c                        |   14 -
 fs/xfs/xfs_icache.c                             |    8 -
 fs/xfs/xfs_inode.c                              |   61 ++------
 fs/xfs/xfs_inode.h                              |   21 --
 fs/xfs/xfs_inode_item.c                         |   20 +-
 fs/xfs/xfs_ioctl.c                              |   22 +-
 fs/xfs/xfs_iops.c                               |   11 -
 fs/xfs/xfs_itable.c                             |    8 -
 fs/xfs/xfs_linux.h                              |   32 ----
 fs/xfs/xfs_log_recover.c                        |    6 
 fs/xfs/xfs_mount.c                              |   90 +++++------
 fs/xfs/xfs_qm.c                                 |   43 +++--
 fs/xfs/xfs_qm_bhv.c                             |    2 
 fs/xfs/xfs_quota.h                              |    4 
 fs/xfs/xfs_super.c                              |   10 -
 fs/xfs/xfs_symlink.c                            |    7 
 fs/xfs/xfs_trans_dquot.c                        |   16 +-
 include/linux/ftrace.h                          |    2 
 kernel/cgroup/cpuset.c                          |    6 
 kernel/events/core.c                            |    2 
 kernel/irq/irqdomain.c                          |  182 ++++++++++++++----------
 kernel/trace/ring_buffer.c                      |   13 +
 kernel/trace/trace.c                            |    1 
 mm/swapfile.c                                   |    3 
 net/9p/trans_xen.c                              |    4 
 net/bluetooth/hidp/core.c                       |    2 
 net/bluetooth/l2cap_core.c                      |   24 ---
 net/can/j1939/transport.c                       |    5 
 net/core/netpoll.c                              |   19 ++
 net/ipv4/icmp.c                                 |    5 
 net/ipv6/ip6_output.c                           |    7 
 net/ipv6/udp.c                                  |    8 -
 net/mac80211/sta_info.c                         |    3 
 net/sched/sch_generic.c                         |    1 
 net/sctp/socket.c                               |    4 
 net/sctp/stream_interleave.c                    |    3 
 net/sunrpc/svcauth_unix.c                       |   17 +-
 sound/firewire/tascam/tascam-stream.c           |    2 
 sound/i2c/cs8427.c                              |    7 
 sound/pci/emu10k1/emupcm.c                      |    4 
 sound/pci/hda/patch_realtek.c                   |    1 
 sound/pci/hda/patch_sigmatel.c                  |   10 +
 102 files changed, 730 insertions(+), 548 deletions(-)

Alexander Stein (1):
      i2c: imx-lpi2c: clean rx/tx buffers upon new message

Arseniy Krasnov (1):
      mtd: rawnand: meson: fix bitmask for length in command word

Bang Li (1):
      mtdblock: tolerate corrected bit-flips

Basavaraj Natikar (1):
      x86/PCI: Add quirk for AMD XHCI controller that loses MSI-X state in D3hot

Biju Das (2):
      tty: serial: sh-sci: Fix transmit end interrupt handler
      tty: serial: sh-sci: Fix Rx on RZ/G2L SCI

Bjørn Mork (1):
      USB: serial: option: add Quectel RM500U-CN modem

Boris Brezillon (1):
      drm/panfrost: Fix the panfrost_mmu_map_fault_addr() error path

Brian Foster (2):
      xfs: consider shutdown in bmapbt cursor delete assert
      xfs: don't reuse busy extents on extent trim

Christoph Hellwig (11):
      btrfs: fix fast csum implementation detection
      xfs: merge the projid fields in struct xfs_icdinode
      xfs: ensure that the inode uid/gid match values match the icdinode ones
      xfs: remove the icdinode di_uid/di_gid members
      xfs: remove the kuid/kgid conversion wrappers
      xfs: add a new xfs_sb_version_has_v3inode helper
      xfs: only check the superblock version for dinode size calculation
      xfs: simplify di_flags2 inheritance in xfs_ialloc
      xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
      xfs: remove the di_version field from struct icdinode
      xfs: fix up non-directory creation in SGID directories

Christophe Kerello (1):
      mtd: rawnand: stm32_fmc2: remove unsupported EDO mode

D Scott Phillips (1):
      xhci: also avoid the XHCI_ZERO_64B_REGS quirk with a passthrough iommu

Dai Ngo (1):
      NFSD: callback request does not use correct credential for AUTH_SYS

Darrick J. Wong (3):
      xfs: report corruption only as a regular error
      xfs: shut down the filesystem if we screw up quota reservation
      xfs: force log and push AIL to clear pinned inodes when aborting mount

David Sterba (1):
      btrfs: print checksum type and implementation at mount time

Denis Plotnikov (1):
      qlcnic: check pci_reset_function result

Dhruva Gole (1):
      gpio: davinci: Add irq chip flag to skip set wake

Enrico Sau (1):
      USB: serial: option: add Telit FE990 compositions

Eric Dumazet (2):
      icmp: guard against too small mtu
      udp6: fix potential access to stale information

Felix Fietkau (1):
      wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta

George Cherian (1):
      watchdog: sbsa_wdog: Make sure the timeout programming is within the limits

Grant Grundler (1):
      power: supply: cros_usbpd: reclassify "default case!" as debug

Greg Kroah-Hartman (1):
      Linux 5.4.241

Gregor Herburger (1):
      i2c: ocores: generate stop condition after timeout in polling mode

Hans de Goede (2):
      efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L
      drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Book X90F

Harshit Mogalapalli (1):
      niu: Fix missing unwind goto in niu_alloc_channels()

Jakub Kicinski (1):
      net: don't let netpoll invoke NAPI if in xmit context

Jeff Layton (1):
      sunrpc: only free unix grouplist after RCU settles

Jeffrey Mitchell (1):
      xfs: set inode size after creating symlink

Jeremy Soller (1):
      ALSA: hda/realtek: Add quirk for Clevo X370SNW

Jiri Kosina (1):
      scsi: ses: Handle enclosure with just a primary component gracefully

Johan Hovold (3):
      irqdomain: Look for existing mapping only once
      irqdomain: Refactor __irq_domain_alloc_irqs()
      irqdomain: Fix mapping-creation race

John Keeping (1):
      ftrace: Mark get_lock_parent_ip() __always_inline

Kaixu Xia (1):
      xfs: show the proper user quota options

Kan Liang (1):
      perf/core: Fix the same task check in perf_event_set_output

Kees Cook (1):
      treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()

Kees Jan Koster (1):
      USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs

Kornel Dulęba (2):
      pinctrl: amd: Disable and mask interrupts on resume
      Revert "pinctrl: amd: Disable and mask interrupts on resume"

Lars-Peter Clausen (1):
      iio: adc: ti-ads7950: Set `can_sleep` flag for GPIO chip

Lee Jones (1):
      mtd: ubi: wl: Fix a couple of kernel-doc issues

Linus Walleij (1):
      pinctrl: amd: Use irqchip template

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}

Min Li (1):
      Bluetooth: Fix race condition in hidp_session_thread

Oleksij Rempel (1):
      can: j1939: j1939_tp_tx_dat_new(): fix out-of-bounds memory access

Oswald Buddenhagen (4):
      ALSA: emu10k1: fix capture interrupt handler unlinking
      ALSA: hda/sigmatel: add pin overrides for Intel DP45SG motherboard
      ALSA: i2c/cs8427: fix iec958 mixer control deactivation
      ALSA: hda/sigmatel: fix S/PDIF out on Intel D*45* motherboards

Pratyush Yadav (1):
      net_sched: prevent NULL dereference if default qdisc setup failed

RD Babiera (1):
      usb: typec: altmodes/displayport: Fix configure initial pin assignment

Robbie Harwood (2):
      verify_pefile: relax wrapper length check
      asymmetric_keys: log on fatal failures in PE/pkcs7

Roman Gushchin (1):
      net: macb: fix a memory corruption in extended buffer descriptor mode

Rongwei Wang (1):
      mm/swap: fix swap_info_struct race between swapoff and get_swap_pages()

Ryusuke Konishi (2):
      nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()
      nilfs2: fix sysfs interface lifetime

Sachi King (1):
      pinctrl: amd: disable and mask interrupts on probe

Saravanan Vajravel (1):
      RDMA/core: Fix GID entry ref leak when create_ah fails

Sherry Sun (1):
      tty: serial: fsl_lpuart: avoid checking for transfer complete when UARTCTRL_SBK is asserted in lpuart32_tx_empty

Steve Clevenger (1):
      coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug

Steve French (1):
      smb3: fix problem with null cifs super block with previous patch

Steven Rostedt (Google) (1):
      tracing: Free error logs of tracing instances

Tom Saeger (1):
      Revert "treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()"

Uwe Kleine-König (2):
      pwm: cros-ec: Explicitly set .polarity in .get_state()
      pwm: sprd: Explicitly set .polarity in .get_state()

Waiman Long (1):
      cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()

William Breathitt Gray (1):
      iio: dac: cio-dac: Fix max DAC write value check for 12-bit

Xin Long (2):
      sctp: check send stream number after wait_for_sndbuf
      sctp: fix a potential overflow in sctp_ifwdtsn_skip

Xu Biang (1):
      ALSA: firewire-tascam: add missing unwind goto in snd_tscm_stream_start_duplex()

ZhaoLong Wang (1):
      ubi: Fix deadlock caused by recursively holding work_sem

Zheng Wang (1):
      9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition

Zheng Yejian (1):
      ring-buffer: Fix race while reader and writer are on the same page

Zhihao Cheng (1):
      ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size

Ziyang Xuan (1):
      ipv6: Fix an uninit variable access bug in __ip6_make_skb()

