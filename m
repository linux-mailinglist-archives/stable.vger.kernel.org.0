Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AFD485288
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 13:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240071AbiAEMex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 07:34:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40668 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240079AbiAEMee (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 07:34:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 387DE6170E;
        Wed,  5 Jan 2022 12:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CA9C36AE9;
        Wed,  5 Jan 2022 12:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641386073;
        bh=cljrjcFsRRQhv7CNsG5t8UPlWQl8cIH8RV8ZwJ/w/A8=;
        h=From:To:Cc:Subject:Date:From;
        b=OH5szH407byi5gQdqkS0EQSvpKTA/uFbk4tAe8AuRb52hKAsTI1n7Ci5ybmuzG35l
         Ezy+HRjkOeV+pMa8neCneB7FOyOjiW7xDvfMXzOl3I0qrvfMIoMC9aoGDYTBRJGjli
         WAMEjO1YQgXYDgFKCRJIBozA8d/f9wOzgCgEv1UY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.13
Date:   Wed,  5 Jan 2022 13:34:23 +0100
Message-Id: <164138606435252@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.13 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt              |    2 
 Makefile                                                     |    2 
 arch/arm/include/asm/efi.h                                   |    1 
 arch/arm64/include/asm/efi.h                                 |    1 
 arch/parisc/kernel/traps.c                                   |    2 
 arch/powerpc/mm/ptdump/ptdump.c                              |    2 
 arch/riscv/include/asm/efi.h                                 |    1 
 arch/x86/include/asm/efi.h                                   |    2 
 drivers/android/binder_alloc.c                               |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c                |   76 +++++++----
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c                        |    7 +
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c |    1 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c        |    2 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c        |    2 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c        |    2 
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c      |    2 
 drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c      |    2 
 drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c      |    2 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c            |    1 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c        |    2 
 drivers/gpu/drm/amd/include/discovery.h                      |   49 +++++++
 drivers/gpu/drm/nouveau/nouveau_fence.c                      |   28 ++--
 drivers/i2c/i2c-dev.c                                        |    3 
 drivers/input/joystick/spaceball.c                           |   11 +
 drivers/input/mouse/appletouch.c                             |    4 
 drivers/input/serio/i8042-x86ia64io.h                        |   21 +++
 drivers/input/serio/i8042.c                                  |   54 +++++--
 drivers/net/ethernet/atheros/ag71xx.c                        |   23 +--
 drivers/net/ethernet/freescale/fman/fman_port.c              |   12 +
 drivers/net/ethernet/intel/igc/igc_main.c                    |    6 
 drivers/net/ethernet/intel/igc/igc_ptp.c                     |   15 ++
 drivers/net/ethernet/lantiq_xrx200.c                         |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en.h                 |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en/health.h          |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c          |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c     |   35 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c     |   10 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h       |   27 +++
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c       |   16 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c            |   48 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c              |   29 ----
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c      |    3 
 drivers/net/ethernet/mellanox/mlx5/core/main.c               |   11 -
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c            |    4 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c |    5 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c              |    2 
 drivers/net/usb/pegasus.c                                    |    4 
 drivers/nfc/st21nfca/i2c.c                                   |   29 ++--
 drivers/platform/mellanox/mlxbf-pmc.c                        |    4 
 drivers/platform/x86/apple-gmux.c                            |    2 
 drivers/scsi/lpfc/lpfc_debugfs.c                             |    4 
 drivers/scsi/vmw_pvscsi.c                                    |    7 -
 drivers/usb/gadget/function/f_fs.c                           |    9 -
 drivers/usb/host/xhci-pci.c                                  |    5 
 drivers/usb/mtu3/mtu3_gadget.c                               |    8 +
 drivers/usb/mtu3/mtu3_qmu.c                                  |    7 -
 drivers/virt/nitro_enclaves/ne_misc_dev.c                    |    5 
 fs/namespace.c                                               |    9 -
 include/linux/efi.h                                          |    6 
 include/linux/memblock.h                                     |    4 
 include/net/pkt_sched.h                                      |   15 ++
 include/net/sch_generic.h                                    |    2 
 include/net/sctp/sctp.h                                      |    6 
 include/net/sctp/structs.h                                   |    3 
 include/uapi/linux/nfc.h                                     |    6 
 mm/damon/dbgfs.c                                             |    8 +
 net/bridge/br_multicast.c                                    |   32 ++++
 net/bridge/br_netlink.c                                      |    4 
 net/bridge/br_private.h                                      |   12 +
 net/bridge/br_sysfs_br.c                                     |    4 
 net/bridge/br_vlan_options.c                                 |    4 
 net/core/dev.c                                               |    8 -
 net/ipv4/af_inet.c                                           |   10 -
 net/ipv6/udp.c                                               |    2 
 net/ncsi/ncsi-netlink.c                                      |    6 
 net/sched/act_ct.c                                           |   14 +-
 net/sched/cls_api.c                                          |    6 
 net/sched/cls_flower.c                                       |    3 
 net/sched/sch_frag.c                                         |    3 
 net/sctp/diag.c                                              |   12 -
 net/sctp/endpointola.c                                       |   23 ++-
 net/sctp/socket.c                                            |   23 ++-
 net/smc/smc.h                                                |    5 
 net/smc/smc_cdc.c                                            |   52 +++----
 net/smc/smc_cdc.h                                            |    2 
 net/smc/smc_core.c                                           |   27 +++
 net/smc/smc_core.h                                           |    6 
 net/smc/smc_ib.c                                             |    4 
 net/smc/smc_ib.h                                             |    1 
 net/smc/smc_llc.c                                            |    2 
 net/smc/smc_wr.c                                             |   51 +------
 net/smc/smc_wr.h                                             |    5 
 scripts/recordmcount.pl                                      |    2 
 security/selinux/hooks.c                                     |    2 
 security/tomoyo/util.c                                       |   31 ++--
 sound/hda/intel-sdw-acpi.c                                   |   13 +
 tools/perf/builtin-script.c                                  |    2 
 tools/perf/scripts/python/intel-pt-events.py                 |   23 +--
 tools/perf/util/intel-pt.c                                   |    1 
 tools/testing/selftests/net/udpgro_fwd.sh                    |    6 
 tools/testing/selftests/net/udpgso.c                         |   12 -
 tools/testing/selftests/net/udpgso_bench_tx.c                |    8 +
 102 files changed, 733 insertions(+), 372 deletions(-)

Adrian Hunter (3):
      perf intel-pt: Fix parsing of VM time correlation arguments
      perf script: Fix CPU filtering of a script's switch events
      perf scripts python: intel-pt-events.py: Fix printing of switch events

Aleksander Jan Bajkowski (1):
      net: lantiq_xrx200: fix statistics of received bytes

Alex Deucher (1):
      drm/amdgpu: add support for IP discovery gc_info table v2

Alexey Makhalov (1):
      scsi: vmw_pvscsi: Set residual data length conditionally

Amir Tzin (1):
      net/mlx5e: Wrap the tx reporter dump callback to extract the sq

Andra Paraschiv (1):
      nitro_enclaves: Use get_user_pages_unlocked() call to handle mmap assert

Angus Wang (1):
      drm/amd/display: Changed pipe split policy to allow for multi-display pipe split

Chris Mi (2):
      net/mlx5: Fix tc max supported prio for nic mode
      net/mlx5e: Delete forward rule for ct or sample action

Christian Brauner (1):
      fs/mount_setattr: always cleanup mount_kattr

Christian König (1):
      drm/nouveau: wait for the exclusive fence after the shared ones v2

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
      Linux 5.15.13

Heiko Carstens (1):
      recordmcount.pl: fix typo in s390 mcount regex

Helge Deller (1):
      parisc: Clear stale IIR value on instruction access rights trap

Jackie Liu (1):
      memblock: fix memblock_phys_alloc() section mismatch error

James McLaughlin (1):
      igc: Fix TX timestamp support for non-MSI-X platforms

Javier Martinez Canillas (1):
      efi: Move efifb_setup_from_dmi() prototype from arch headers

Jianguo Wu (2):
      selftests: net: Fix a typo in udpgro_fwd.sh
      selftests: net: using ping6 for IPv6 in udpgro_fwd.sh

Jiasheng Jiang (1):
      net/ncsi: check for error return from call to nla_put_u32

Karsten Graul (1):
      net/smc: fix using of uninitialized completions

Krzysztof Kozlowski (1):
      nfc: uapi: use kernel size_t to fix user-space builds

Leo L. Schwab (1):
      Input: spaceball - fix parsing of movement data packets

Libin Yang (2):
      ALSA: hda: intel-sdw-acpi: harden detection of controller
      ALSA: hda: intel-sdw-acpi: go through HDAS ACPI at max depth of 2

Mathias Nyman (1):
      xhci: Fresco FL1100 controller should not have BROKEN_MSI quirk set.

Matthias-Christian Ott (1):
      net: usb: pegasus: Do not drop long Ethernet frames

Maxim Mikityanskiy (2):
      net/mlx5e: Fix interoperability between XSK and ICOSQ recovery flow
      net/mlx5e: Fix ICOSQ recovery flow for XSK

Miaoqian Lin (3):
      platform/mellanox: mlxbf-pmc: Fix an IS_ERR() vs NULL bug in mlxbf_pmc_map_counters
      net/mlx5: DR, Fix NULL vs IS_ERR checking in dr_domain_init_resources
      fsl/fman: Fix missing put_device() call in fman_port_probe

Michael Ellerman (1):
      powerpc/ptdump: Fix DEBUG_WX since generic ptdump conversion

Moshe Shemesh (1):
      net/mlx5: Fix SF health recovery flow

Muchun Song (1):
      net: fix use-after-free in tw_timer_handler

Nicholas Kazlauskas (2):
      drm/amd/display: Send s0i2_rdy in stream_count == 0 optimization
      drm/amd/display: Set optimize_pwr_state for DCN31

Nikolay Aleksandrov (3):
      net: bridge: mcast: add and enforce query interval minimum
      net: bridge: mcast: add and enforce startup query interval minimum
      net: bridge: mcast: fix br_multicast_ctx_vlan_global_disabled helper

Paul Blakey (1):
      net/sched: Extend qdisc control block with tc control block

Pavel Skripkin (2):
      i2c: validate user data in compat ioctl
      Input: appletouch - initialize work before device registration

Roi Dayan (1):
      net/mlx5e: Use tc sample stubs instead of ifdefs in source file

Samuel Čavoj (1):
      Input: i8042 - enable deferred probe quirk for ASUS UM325UA

SeongJae Park (1):
      mm/damon/dbgfs: fix 'struct pid' leaks in 'dbgfs_target_ids_write()'

Shay Drory (1):
      net/mlx5: Fix error print in case of IRQ request failed

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

Vinicius Costa Gomes (1):
      igc: Do not enable crosstimestamping for i225-V models

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

