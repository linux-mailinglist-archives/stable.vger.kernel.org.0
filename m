Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A1A3A9755
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 12:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhFPKdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 06:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232307AbhFPKdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 06:33:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2615A6101B;
        Wed, 16 Jun 2021 10:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623839508;
        bh=cU+z0z6+Ly/g4gxpIbjVWnM443O7NC5y1ZG5lQReTOY=;
        h=From:To:Cc:Subject:Date:From;
        b=gPQNFwSaJ8S3zVdhOdYK6Z/C3YAVNXQzH8Uqc4BJvKEM9BgmUI5Pl9+obxZIv8LLn
         Gf5IoeLEZ31kcbllOqFPrxcUxghmlOcSZdgCfEXk6KWsgmFnrGVLL/kRNnTVzSukUo
         gpmncy0xYVzRc/o85eEqbM3O1419mA7NQQwgqyR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.273
Date:   Wed, 16 Jun 2021 12:31:44 +0200
Message-Id: <1623839504188131@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.273 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/mips/lib/mips-atomic.c                       |   12 +-
 arch/powerpc/boot/dts/fsl/p1010si-post.dtsi       |    8 +
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi       |   16 +++
 drivers/i2c/busses/i2c-mpc.c                      |   95 +++++++++++++++++++++-
 drivers/isdn/hardware/mISDN/netjet.c              |    1 
 drivers/net/appletalk/cops.c                      |    4 
 drivers/net/bonding/bond_main.c                   |    2 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c |    4 
 drivers/net/ethernet/cadence/macb.c               |    3 
 drivers/net/ethernet/qlogic/qla3xxx.c             |    2 
 drivers/net/phy/mdio_bus.c                        |    3 
 drivers/scsi/hosts.c                              |    2 
 drivers/scsi/qla2xxx/qla_target.c                 |    2 
 drivers/scsi/vmw_pvscsi.c                         |    8 +
 drivers/usb/dwc3/ep0.c                            |    3 
 drivers/usb/gadget/function/f_eem.c               |    4 
 drivers/usb/gadget/function/f_ncm.c               |    2 
 drivers/usb/serial/ftdi_sio.c                     |    1 
 drivers/usb/serial/ftdi_sio_ids.h                 |    1 
 drivers/usb/serial/omninet.c                      |    2 
 drivers/usb/serial/quatech2.c                     |    6 -
 fs/btrfs/file.c                                   |    4 
 fs/nfs/client.c                                   |    2 
 fs/nfs/nfs4proc.c                                 |    8 +
 fs/proc/base.c                                    |   11 ++
 include/linux/kvm_host.h                          |   11 ++
 kernel/cgroup.c                                   |    4 
 kernel/events/core.c                              |    2 
 kernel/trace/ftrace.c                             |    8 +
 net/netlink/af_netlink.c                          |    6 -
 net/nfc/rawsock.c                                 |    2 
 sound/soc/codecs/sti-sas.c                        |    1 
 tools/perf/util/session.c                         |    1 
 34 files changed, 210 insertions(+), 33 deletions(-)

Alexander Kuznetsov (1):
      cgroup1: don't allow '\n' in renaming

Alexandre GRIVEAUX (1):
      USB: serial: omninet: add device id for Zyxel Omni 56K Plus

Chris Packham (4):
      powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P2041 i2c controllers
      powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P1010 i2c controllers
      i2c: mpc: Make use of i2c_recover_bus()
      i2c: mpc: implement erratum A-004447 workaround

Dai Ngo (1):
      NFSv4: nfs4_proc_set_acl needs to restore NFS_CAP_UIDGID_NOMAP on error.

Dan Carpenter (2):
      net: mdiobus: get rid of a BUG_ON()
      NFS: Fix a potential NULL dereference in nfs_get_client()

Dmitry Bogdanov (1):
      scsi: target: qla2xxx: Wait for stop_phase1 at WWN removal

George McCollister (1):
      USB: serial: ftdi_sio: add NovaTech OrionMX product ID

Greg Kroah-Hartman (1):
      Linux 4.4.273

Jeimon (1):
      net/nfc/rawsock.c: fix a permission check bug

Jiapeng Chong (1):
      bnx2x: Fix missing error code in bnx2x_iov_init_one()

Johan Hovold (1):
      USB: serial: quatech2: fix control-request directions

Johannes Berg (2):
      bonding: init notify_work earlier to avoid uninitialized use
      netlink: disable IRQs for netlink_lock_table()

Kees Cook (1):
      proc: Track /proc/$pid/attr/ opener mm_struct

Leo Yan (1):
      perf session: Correct buffer copying when peeking events

Linus Torvalds (1):
      proc: only require mm_struct for writing

Linyu Yuan (1):
      usb: gadget: eem: fix wrong eem header operation

Maciej Żenczykowski (1):
      USB: f_ncm: ncm_bitrate (speed) is unsigned

Marco Elver (1):
      perf: Fix data race between pin_count increment/decrement

Marian-Cristian Rotariu (1):
      usb: dwc3: ep0: fix NULL pointer exception

Matt Wang (1):
      scsi: vmw_pvscsi: Set correct residual data length

Ming Lei (1):
      scsi: core: Only put parent device if host state differs from SHOST_CREATED

Paolo Bonzini (2):
      kvm: avoid speculation-based attacks from out-of-range memslot accesses
      kvm: fix previous commit for 32-bit builds

Ritesh Harjani (1):
      btrfs: return value from btrfs_mark_extent_written() in case of error

Saubhik Mukherjee (1):
      net: appletalk: cops: Fix data race in cops_probe1

Steven Rostedt (VMware) (1):
      ftrace: Do not blindly read the ip address in ftrace_bug()

Tiezhu Yang (1):
      MIPS: Fix kernel hang under FUNCTION_GRAPH_TRACER and PREEMPT_TRACER

Zheyu Ma (2):
      isdn: mISDN: netjet: Fix crash in nj_probe:
      net/qla3xxx: fix schedule while atomic in ql_sem_spinlock

Zong Li (1):
      net: macb: ensure the device is available before accessing GEMGXL control registers

Zou Wei (1):
      ASoC: sti-sas: add missing MODULE_DEVICE_TABLE

