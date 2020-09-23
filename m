Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775A627600D
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 20:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgIWSgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 14:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbgIWSgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Sep 2020 14:36:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA1DB235F7;
        Wed, 23 Sep 2020 18:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600886195;
        bh=adq6BfUjn6PRKAjsUELt/HSO1pQygL3N58fBDcG1qAg=;
        h=From:To:Cc:Subject:Date:From;
        b=nfvGuPvz6vBEiUpHAEqoesupRtkVY2rt/aBWpJV/eEPgoljcAp05FGi9emeVyXR5U
         lwlxkZ5U8ALfmhng6qf3FrPU/o0iv6oz7MpiHcOvQz+24HzAP9mX3LxOErm6sawgjM
         tbfuT4Z71jxDnvzfFcQhjPQIRooCqdGPAsNNpftM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.147
Date:   Wed, 23 Sep 2020 20:36:46 +0200
Message-Id: <16008862069225@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.147 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 arch/mips/Kconfig                        |    1 
 arch/mips/kvm/mips.c                     |    2 
 arch/mips/sni/a20r.c                     |    9 ++
 arch/openrisc/mm/cache.c                 |    2 
 arch/powerpc/kernel/dma-iommu.c          |    3 
 arch/x86/boot/compressed/Makefile        |    2 
 arch/x86/configs/i386_defconfig          |    1 
 arch/x86/configs/x86_64_defconfig        |    1 
 drivers/clk/davinci/pll.c                |    2 
 drivers/clk/rockchip/clk-rk3228.c        |    2 
 drivers/gpu/drm/mediatek/mtk_drm_drv.c   |    7 +-
 drivers/gpu/drm/mediatek/mtk_hdmi.c      |   26 +++++--
 drivers/hv/channel_mgmt.c                |    7 +-
 drivers/i2c/algos/i2c-algo-pca.c         |   35 +++++++---
 drivers/i2c/busses/i2c-i801.c            |   21 ++++--
 drivers/infiniband/hw/bnxt_re/qplib_sp.c |    2 
 drivers/infiniband/hw/bnxt_re/qplib_sp.h |    1 
 drivers/input/mouse/trackpoint.c         |   10 +--
 drivers/input/mouse/trackpoint.h         |   10 +--
 drivers/input/serio/i8042-x86ia64io.h    |   16 ++++
 drivers/net/hyperv/netvsc_drv.c          |    2 
 drivers/nvme/host/fc.c                   |    1 
 drivers/nvme/host/rdma.c                 |    1 
 drivers/rapidio/Kconfig                  |    2 
 drivers/regulator/pwm-regulator.c        |    2 
 drivers/scsi/libfc/fc_disc.c             |    2 
 drivers/scsi/lpfc/lpfc_els.c             |    4 -
 drivers/scsi/pm8001/pm8001_sas.c         |    2 
 drivers/scsi/qla2xxx/qla_def.h           |   10 +--
 drivers/scsi/qla2xxx/qla_gbl.h           |    5 -
 drivers/scsi/qla2xxx/qla_gs.c            |   30 +++++----
 drivers/scsi/qla2xxx/qla_init.c          |  101 +++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c            |   29 +++++---
 drivers/scsi/qla2xxx/qla_target.c        |   85 +++++++++++++++++++++-----
 drivers/spi/spi-loopback-test.c          |    2 
 drivers/spi/spi.c                        |    9 ++
 drivers/tty/serial/8250/8250_pci.c       |   11 +++
 drivers/usb/class/usblp.c                |    5 +
 drivers/usb/core/quirks.c                |    4 +
 drivers/usb/host/ehci-hcd.c              |    1 
 drivers/usb/host/ehci-hub.c              |    1 
 drivers/usb/storage/uas.c                |   14 +++-
 drivers/video/fbdev/core/fbcon.c         |    2 
 fs/f2fs/data.c                           |    3 
 fs/f2fs/node.c                           |    3 
 fs/gfs2/glops.c                          |    2 
 fs/gfs2/log.c                            |    2 
 fs/gfs2/trans.c                          |    2 
 fs/nfs/nfs4proc.c                        |   11 ++-
 include/linux/i2c-algo-pca.h             |   15 ++++
 include/uapi/linux/kvm.h                 |    5 -
 mm/percpu.c                              |    2 
 net/core/skbuff.c                        |   10 ++-
 net/dsa/tag_edsa.c                       |   37 ++++++++++-
 net/sunrpc/rpcb_clnt.c                   |    4 -
 sound/pci/hda/patch_realtek.c            |    1 
 sound/soc/qcom/apq8016_sbc.c             |    1 
 sound/soc/qcom/apq8096.c                 |    1 
 sound/soc/qcom/sdm845.c                  |    1 
 sound/soc/qcom/storm.c                   |    1 
 tools/perf/tests/bp_signal.c             |    5 +
 tools/perf/tests/pmu.c                   |    1 
 tools/perf/util/pmu.c                    |   11 +++
 tools/perf/util/pmu.h                    |    1 
 65 files changed, 457 insertions(+), 149 deletions(-)

Adam Borowski (1):
      x86/defconfig: Enable CONFIG_USB_XHCI_HCD=y

Alexey Kardashevskiy (1):
      powerpc/dma: Fix dma_map_ops::get_required_mask

Arvind Sankar (1):
      x86/boot/compressed: Disable relocation relaxation

Bob Peterson (1):
      gfs2: initialize transaction tr_ailX_lists earlier

Christophe JAILLET (1):
      clk: davinci: Use the correct size when allocating memory

Chuck Lever (1):
      NFS: Zero-stateid SETATTR should first return delegation

Daniel Mack (1):
      dsa: Allow forwarding of redirected IGMP traffic

David Milburn (2):
      nvme-fc: cancel async events before freeing event struct
      nvme-rdma: cancel async events before freeing event struct

Dinghao Liu (1):
      scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort

Evan Nimmo (1):
      i2c: algo: pca: Reapply i2c bus settings after reset

Gabriel Krisman Bertazi (1):
      f2fs: Return EOF on unaligned end of file DIO read

Greg Kroah-Hartman (2):
      Revert "ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO"
      Linux 4.19.147

Gustav Wiklander (1):
      spi: Fix memory leak on splited transfers

Haiyang Zhang (1):
      hv_netvsc: Remove "unlikely" from netvsc_select_queue

Hans de Goede (1):
      Input: i8042 - add Entroware Proteus EL07R4 to nomux and reset lists

Huacai Chen (1):
      KVM: MIPS: Change the definition of kvm type

J. Bruce Fields (1):
      SUNRPC: stop printk reading past end of string

James Smart (1):
      scsi: lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery

Javed Hasan (1):
      scsi: libfc: Fix for double free()

Jiri Olsa (1):
      perf test: Fix the "signal" test inline assembly

Laurent Pinchart (1):
      rapidio: Replace 'select' DMAENGINES 'with depends on'

Miaohe Lin (1):
      net: handle the return value of pskb_carve_frag_list() correctly

Michael Kelley (1):
      Drivers: hv: vmbus: Add timeout to vmbus_wait_for_unload

Namhyung Kim (1):
      perf test: Free formats for perf pmu parse test

Naresh Kumar PBS (1):
      RDMA/bnxt_re: Restrict the max_gids to 256

Nathan Chancellor (1):
      clk: rockchip: Fix initialization of mux_pll_src_4plls_p

Olga Kornievskaia (1):
      NFSv4.1 handle ERR_DELAY error reclaiming locking state on delegation recall

Oliver Neukum (2):
      USB: UAS: fix disconnect by unplugging a hub
      usblp: fix race between disconnect() and read()

Penghao (1):
      USB: quirks: Add USB_QUIRK_IGNORE_REMOTE_WAKEUP quirk for BYD zhaoxin notebook

Quentin Perret (1):
      ehci-hcd: Move include to keep CRC stable

Quinn Tran (3):
      scsi: qla2xxx: Update rscn_rcvd field to more meaningful scan_needed
      scsi: qla2xxx: Move rport registration out of internal work_list
      scsi: qla2xxx: Reduce holding sess_lock to prevent CPU lock-up

Sahitya Tummala (1):
      f2fs: fix indefinite loop scanning for free nid

Stafford Horne (1):
      openrisc: Fix cache API compile issue when not inlining

Stephan Gerhold (1):
      ASoC: qcom: Set card->owner to avoid warnings

Sunghyun Jin (1):
      percpu: fix first chunk size calculation for populated bitmap

Tetsuo Handa (1):
      fbcon: Fix user font detection test at fbcon_resize().

Thomas Bogendoerfer (2):
      MIPS: SNI: Fix MIPS_L1_CACHE_SHIFT
      MIPS: SNI: Fix spurious interrupts

Tobias Diedrich (1):
      serial: 8250_pci: Add Realtek 816a and 816b

Vincent Huang (1):
      Input: trackpoint - add new trackpoint variant IDs

Vincent Whitchurch (2):
      regulator: pwm: Fix machine constraints application
      spi: spi-loopback-test: Fix out-of-bounds read

Volker Rümelin (1):
      i2c: i801: Fix resume bug

Yu Kuai (2):
      drm/mediatek: Add exception handing in mtk_drm_probe() if component init fail
      drm/mediatek: Add missing put_device() call in mtk_hdmi_dt_parse_pdata()

