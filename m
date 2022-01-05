Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E83485285
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 13:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240069AbiAEMec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 07:34:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40606 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240058AbiAEMe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 07:34:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 056906171B;
        Wed,  5 Jan 2022 12:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2816C36AE9;
        Wed,  5 Jan 2022 12:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641386065;
        bh=G5Ki+2AvLKVNBBERiTn2QcGuM7t9rLzNByzb5UFfT/4=;
        h=From:To:Cc:Subject:Date:From;
        b=BJ3vfAF64n5KFY17y6ItJeD3C5JGALAZswQwmOAyqvxtQ/8ikcP6Tq6TUJlWtJYYe
         qeDP7RIRhFDCKo74oGRSJOrCW2g6Loowcwn5SPrYMSI30GZZoIShfyZf/MKyUqh5UI
         /rG+cs+92jJuscKg2X6eycrzLx3XgvKVSX/ZeuRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.90
Date:   Wed,  5 Jan 2022 13:34:18 +0100
Message-Id: <164138605832170@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.90 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt              |    2 
 Documentation/admin-guide/sysctl/kernel.rst                  |   17 ++
 Makefile                                                     |    2 
 arch/parisc/kernel/traps.c                                   |    2 
 drivers/android/binder_alloc.c                               |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c                |   76 +++++++----
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c                        |    7 +
 drivers/gpu/drm/amd/include/discovery.h                      |   49 +++++++
 drivers/i2c/i2c-dev.c                                        |    3 
 drivers/input/joystick/spaceball.c                           |   11 +
 drivers/input/mouse/appletouch.c                             |    4 
 drivers/input/serio/i8042-x86ia64io.h                        |   21 +++
 drivers/input/serio/i8042.c                                  |   54 +++++--
 drivers/net/ethernet/atheros/ag71xx.c                        |   23 +--
 drivers/net/ethernet/freescale/fman/fman_port.c              |   12 +
 drivers/net/ethernet/intel/igc/igc_main.c                    |    6 
 drivers/net/ethernet/lantiq_xrx200.c                         |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en.h                 |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c     |   10 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c            |   41 +++--
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c |    5 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c              |    2 
 drivers/net/usb/pegasus.c                                    |    4 
 drivers/nfc/st21nfca/i2c.c                                   |   29 ++--
 drivers/platform/x86/apple-gmux.c                            |    2 
 drivers/scsi/lpfc/lpfc_debugfs.c                             |    4 
 drivers/scsi/vmw_pvscsi.c                                    |    7 -
 drivers/usb/gadget/function/f_fs.c                           |    9 -
 drivers/usb/host/xhci-pci.c                                  |    5 
 drivers/usb/mtu3/mtu3_gadget.c                               |    8 +
 drivers/usb/mtu3/mtu3_qmu.c                                  |    7 -
 include/linux/memblock.h                                     |    4 
 include/net/sctp/sctp.h                                      |    6 
 include/net/sctp/structs.h                                   |    3 
 include/uapi/linux/nfc.h                                     |    6 
 init/Kconfig                                                 |   10 +
 kernel/bpf/syscall.c                                         |    3 
 kernel/sysctl.c                                              |   29 +++-
 net/ipv4/af_inet.c                                           |   10 -
 net/ipv6/udp.c                                               |    2 
 net/ncsi/ncsi-netlink.c                                      |    6 
 net/sctp/diag.c                                              |   12 -
 net/sctp/endpointola.c                                       |   23 ++-
 net/sctp/socket.c                                            |   23 ++-
 net/smc/smc.h                                                |    5 
 net/smc/smc_cdc.c                                            |   59 ++++----
 net/smc/smc_cdc.h                                            |    2 
 net/smc/smc_core.c                                           |   47 ++++--
 net/smc/smc_core.h                                           |    6 
 net/smc/smc_ib.c                                             |    4 
 net/smc/smc_ib.h                                             |    1 
 net/smc/smc_llc.c                                            |   65 +++++++--
 net/smc/smc_tx.c                                             |   22 ---
 net/smc/smc_wr.c                                             |   51 +------
 net/smc/smc_wr.h                                             |   17 ++
 scripts/recordmcount.pl                                      |    2 
 security/selinux/hooks.c                                     |    2 
 security/tomoyo/util.c                                       |   31 ++--
 tools/perf/builtin-script.c                                  |    2 
 tools/testing/selftests/net/udpgso.c                         |   12 -
 tools/testing/selftests/net/udpgso_bench_tx.c                |    8 +
 61 files changed, 594 insertions(+), 308 deletions(-)

Adrian Hunter (1):
      perf script: Fix CPU filtering of a script's switch events

Aleksander Jan Bajkowski (1):
      net: lantiq_xrx200: fix statistics of received bytes

Alex Deucher (1):
      drm/amdgpu: add support for IP discovery gc_info table v2

Alexey Makhalov (1):
      scsi: vmw_pvscsi: Set residual data length conditionally

Amir Tzin (1):
      net/mlx5e: Wrap the tx reporter dump callback to extract the sq

Christophe JAILLET (2):
      net: ag71xx: Fix a potential double free in error handling paths
      ionic: Initialize the 'lif->dbid_inuse' bitmap

Chunfeng Yun (3):
      usb: mtu3: add memory barrier before set GPD's HWO
      usb: mtu3: fix list_head check warning
      usb: mtu3: set interval of FS intr and isoc endpoint

Coco Li (2):
      udp: using datalen to cap ipv6 udp max gso segments
      selftests: Calculate udpgso segment count without header adjustment

Dan Carpenter (1):
      scsi: lpfc: Terminate string in lpfc_debugfs_nvmeio_trc_write()

Daniel Borkmann (1):
      bpf: Add kconfig knob for disabling unpriv bpf by default

Dmitry V. Levin (1):
      uapi: fix linux/nfc.h userspace compilation errors

Dmitry Vyukov (1):
      tomoyo: Check exceeded quota early in tomoyo_domain_quota_is_ok().

Dust Li (2):
      net/smc: don't send CDC/LLC message if link not ready
      net/smc: fix kernel panic caused by race of smc_sock

Gal Pressman (1):
      net/mlx5e: Fix wrong features assignment in case of error

Greg Kroah-Hartman (1):
      Linux 5.10.90

Heiko Carstens (1):
      recordmcount.pl: fix typo in s390 mcount regex

Helge Deller (1):
      parisc: Clear stale IIR value on instruction access rights trap

Jackie Liu (1):
      memblock: fix memblock_phys_alloc() section mismatch error

James McLaughlin (1):
      igc: Fix TX timestamp support for non-MSI-X platforms

Jiasheng Jiang (1):
      net/ncsi: check for error return from call to nla_put_u32

Karsten Graul (2):
      net/smc: fix using of uninitialized completions
      net/smc: improved fix wait on already cleared link

Krzysztof Kozlowski (1):
      nfc: uapi: use kernel size_t to fix user-space builds

Leo L. Schwab (1):
      Input: spaceball - fix parsing of movement data packets

Mathias Nyman (1):
      xhci: Fresco FL1100 controller should not have BROKEN_MSI quirk set.

Matthias-Christian Ott (1):
      net: usb: pegasus: Do not drop long Ethernet frames

Maxim Mikityanskiy (1):
      net/mlx5e: Fix ICOSQ recovery flow for XSK

Miaoqian Lin (2):
      net/mlx5: DR, Fix NULL vs IS_ERR checking in dr_domain_init_resources
      fsl/fman: Fix missing put_device() call in fman_port_probe

Muchun Song (1):
      net: fix use-after-free in tw_timer_handler

Pavel Skripkin (2):
      i2c: validate user data in compat ioctl
      Input: appletouch - initialize work before device registration

Samuel Čavoj (1):
      Input: i8042 - enable deferred probe quirk for ASUS UM325UA

Takashi Iwai (1):
      Input: i8042 - add deferred probe support

Tetsuo Handa (1):
      tomoyo: use hwight16() in tomoyo_domain_quota_is_ok()

Todd Kjos (1):
      binder: fix async_free_space accounting for empty parcels

Tom Rix (1):
      selinux: initialize proto variable in selinux_ip_postroute_compat()

Vincent Pelletier (1):
      usb: gadget: f_fs: Clear ffs_eventfd in ffs_data_clear.

Wang Qing (1):
      platform/x86: apple-gmux: use resource_size() with res

Wei Yongjun (1):
      NFC: st21nfca: Fix memory leak in device probe and remove

Xin Long (1):
      sctp: use call_rcu to free endpoint

chen gong (1):
      drm/amdgpu: When the VCN(1.0) block is suspended, powergating is explicitly enabled

wujianguo (1):
      selftests/net: udpgso_bench_tx: fix dst ip argument

