Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7542169F3DE
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 13:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjBVMDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 07:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjBVMDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 07:03:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD18337556;
        Wed, 22 Feb 2023 04:03:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63A6161388;
        Wed, 22 Feb 2023 12:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5F1C433D2;
        Wed, 22 Feb 2023 12:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677067418;
        bh=UfrOluPm4//1v8dSrTi6Fl9Ay9jKIBSki5FRs+3+ehY=;
        h=From:To:Cc:Subject:Date:From;
        b=vpNVHeDzENJT58+0YXoRmxR5y5R7xi8K+V9+oMZsm++O7T+b+yZaJn2HXAyJbZ5AS
         6Rn8Lvgb07GU/J4+v11jbn20IiFx9gyO2BxBr9xIcgwrwFuuLX8qRYCcsYaR0K49nv
         aXb6yakcvsyPCR0kdGmOBFciVPdnckBCeaSvf+6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.306
Date:   Wed, 22 Feb 2023 13:03:34 +0100
Message-Id: <167706741359197@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.306 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 -
 arch/parisc/kernel/firmware.c                         |    5 +-
 arch/parisc/kernel/ptrace.c                           |   15 +++++++-
 arch/x86/kernel/fpu/init.c                            |    7 ++-
 arch/x86/kvm/x86.c                                    |    3 -
 drivers/bus/sunxi-rsb.c                               |    8 +++-
 drivers/firewire/core-cdev.c                          |    4 +-
 drivers/firmware/efi/memattr.c                        |    2 -
 drivers/iio/accel/hid-sensor-accel-3d.c               |    1 
 drivers/iio/adc/berlin2-adc.c                         |    4 +-
 drivers/iio/adc/twl6030-gpadc.c                       |   32 ++++++++++++++++++
 drivers/mmc/core/sdio_bus.c                           |   17 +++++++--
 drivers/mmc/core/sdio_cis.c                           |   12 ------
 drivers/net/ethernet/broadcom/bgmac-bcma.c            |    6 +--
 drivers/net/ethernet/intel/i40e/i40e_main.c           |    4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |    2 -
 drivers/net/usb/kalmia.c                              |    8 ++--
 drivers/net/usb/plusb.c                               |    4 --
 drivers/nvme/target/fc.c                              |    4 +-
 drivers/pinctrl/aspeed/pinctrl-aspeed.c               |    2 -
 drivers/pinctrl/pinctrl-single.c                      |    2 +
 drivers/scsi/iscsi_tcp.c                              |    9 +++--
 drivers/target/target_core_tmr.c                      |    4 +-
 drivers/tty/serial/8250/8250_dma.c                    |   26 ++++++++++++--
 drivers/usb/core/quirks.c                             |    3 +
 drivers/usb/gadget/function/f_fs.c                    |    4 +-
 drivers/video/fbdev/core/fbcon.c                      |    7 ++-
 drivers/watchdog/diag288_wdt.c                        |   15 ++++++--
 fs/aio.c                                              |    4 ++
 fs/btrfs/volumes.c                                    |    6 ++-
 fs/nilfs2/ioctl.c                                     |    7 +++
 fs/nilfs2/super.c                                     |    9 +++++
 fs/nilfs2/the_nilfs.c                                 |    8 +++-
 fs/proc/task_mmu.c                                    |    4 --
 fs/squashfs/squashfs_fs.h                             |    2 -
 fs/squashfs/squashfs_fs_sb.h                          |    2 -
 fs/squashfs/xattr.h                                   |    4 +-
 fs/squashfs/xattr_id.c                                |    2 -
 include/linux/hugetlb.h                               |   18 +++++++++-
 include/net/sock.h                                    |   13 +++++++
 mm/mempolicy.c                                        |    3 +
 mm/swapfile.c                                         |    1 
 net/dccp/ipv6.c                                       |    7 +--
 net/ipv6/datagram.c                                   |    2 -
 net/ipv6/tcp_ipv6.c                                   |   11 ++----
 net/mpls/af_mpls.c                                    |    4 ++
 net/netrom/af_netrom.c                                |    5 ++
 net/openvswitch/datapath.c                            |   12 +++---
 net/rose/af_rose.c                                    |    8 ++++
 net/sctp/transport.c                                  |    4 --
 net/x25/af_x25.c                                      |    6 +++
 sound/pci/hda/patch_conexant.c                        |    1 
 sound/pci/hda/patch_via.c                             |    3 +
 sound/pci/lx6464es/lx_core.c                          |   11 ++----
 sound/synth/emux/emux_nrpn.c                          |    3 +
 tools/virtio/linux/bug.h                              |    8 +---
 tools/virtio/linux/build_bug.h                        |    7 +++
 tools/virtio/linux/cpumask.h                          |    7 +++
 tools/virtio/linux/gfp.h                              |    7 +++
 tools/virtio/linux/kernel.h                           |    1 
 tools/virtio/linux/kmsan.h                            |   12 ++++++
 tools/virtio/linux/scatterlist.h                      |    1 
 tools/virtio/linux/topology.h                         |    7 +++
 63 files changed, 321 insertions(+), 101 deletions(-)

Alan Stern (1):
      net: USB: Fix wrong-direction WARNING in plusb.c

Alexander Egorenkov (2):
      watchdog: diag288_wdt: do not use stack buffers for hardware data
      watchdog: diag288_wdt: fix __diag288() inline assembly

Amit Engel (1):
      nvme-fc: fix a missing queue put in nvmet_fc_ls_create_association

Andreas Kemnade (1):
      iio:adc:twl6030: Enable measurements of VUSB, VBAT and others

Andrew Morton (1):
      revert "squashfs: harden sanity check in squashfs_read_xattr_id_table"

Ard Biesheuvel (1):
      efi: Accept version 2 of memory attributes table

Artemii Karasev (2):
      ALSA: hda/via: Avoid potential array out-of-bound in add_secret_dac_path()
      ALSA: emux: Avoid potential array out-of-bound in snd_emux_xg_control()

Bo Liu (1):
      ALSA: hda/conexant: add a new hda codec SN6180

Cristian Ciocaltea (1):
      net: stmmac: Restrict warning on disabling DMA store and fwd mode

Dan Carpenter (1):
      ALSA: pci: lx6464es: fix a debug loop

Dmitry Perchanov (1):
      iio: hid: fix the retval in accel_3d_capture_sample

Fedor Pchelkin (2):
      squashfs: harden sanity check in squashfs_read_xattr_id_table
      net: openvswitch: fix flow memory leak in ovs_flow_cmd_new

Greg Kroah-Hartman (3):
      Revert "x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN"
      kvm: initialize all of the kvm_debugregs structure before sending it to userspace
      Linux 4.14.306

Guillaume Nault (2):
      ipv6: Fix datagram socket connection with DSCP.
      ipv6: Fix tcp socket connection with DSCP.

Helge Deller (2):
      parisc: Fix return code of pdc_iodc_print()
      parisc: Wire up PTRACE_GETREGS/PTRACE_SETREGS for compat case

Hyunwoo Kim (3):
      netrom: Fix use-after-free caused by accept on already connected socket
      net/x25: Fix to not accept on connected socket
      net/rose: Fix to not accept on connected socket

Ilpo Järvinen (2):
      serial: 8250_dma: Fix DMA Rx completion race
      serial: 8250_dma: Fix DMA Rx rearm race

Jakub Kicinski (1):
      net: mpls: fix stale pointer if allocation fails during device rename

Jason Xing (1):
      i40e: add double of VLAN header when computing the max MTU

Joel Stanley (1):
      pinctrl: aspeed: Fix confusing types in return value

Josef Bacik (1):
      btrfs: limit device extents to the device size

Kuniyuki Iwashima (1):
      dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.

Longlong Xia (1):
      mm/swapfile: add cond_resched() in get_swap_pages()

Mark Pearson (1):
      usb: core: add quirk for Alcor Link AK9563 smartcard reader

Maurizio Lombardi (1):
      scsi: target: core: Fix warning on RT kernels

Maxim Korotkov (1):
      pinctrl: single: fix potential NULL dereference

Mike Christie (1):
      scsi: iscsi_tcp: Fix UAF during login when accessing the shost ipaddress

Mike Kravetz (3):
      mm: hugetlb: proc: check for hugetlb shared PMD in /proc/PID/smaps
      migrate: hugetlb: check for hugetlb shared PMD in node migration
      hugetlb: check for undefined shift on 32 bit architectures

Miko Larsson (1):
      net/usb: kalmia: Don't pass act_len in usb_bulk_msg error path

Natalia Petrova (1):
      i40e: Add checking for null for nlmsg_find_attr()

Phillip Lougher (1):
      Squashfs: fix handling and sanity checking of xattr_ids count

Rafał Miłecki (1):
      net: bgmac: fix BCM5358 support by setting correct flags

Ryusuke Konishi (1):
      nilfs2: fix underflow in second superblock position calculations

Samuel Thibault (1):
      fbcon: Check font dimension limits

Seth Jenkins (1):
      aio: fix mremap after fork null-deref

Shunsuke Mie (1):
      tools/virtio: fix the vringh test for virtio ring changes

Takashi Sakamoto (1):
      firewire: fix memory leak for payload of request subaction to IEC 61883-1 FCP region

Udipto Goswami (1):
      usb: gadget: f_fs: Fix unbalanced spinlock in __ffs_ep0_queue_wait

Xin Long (1):
      sctp: do not check hb_timer.expires when resetting hb_timer

Xiongfeng Wang (1):
      iio: adc: berlin2-adc: Add missing of_node_put() in error path

Yang Yingliang (1):
      mmc: sdio: fix possible resource leaks in some error paths

Yuan Can (1):
      bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()

