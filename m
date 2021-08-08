Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98653E395C
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhHHHQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231159AbhHHHQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 03:16:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ACF36024A;
        Sun,  8 Aug 2021 07:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628406969;
        bh=w0AkOpNKNlzXVNTr2GLqZ9j/aGc+o/YCMbxnogbWfRo=;
        h=From:To:Cc:Subject:Date:From;
        b=G0psXzL0omX+nqf0QEFvNr+mAUi0Waz4g3vft4nTEIgPntUMn1wVIh4Pd/YK0Xi0I
         zDJ62KU8gRNmwqxTInkSP58ZqiC6h/VCcG/JC1fjd3zwqxV/A4x7sSwsVUwkoQ9noo
         2k38/0JmThXbGP5zCDVi2BH29U8M3JqCFGj2wvsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.13.9
Date:   Sun,  8 Aug 2021 09:15:56 +0200
Message-Id: <16284069568597@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.13.9 kernel.

All users of the 5.13 kernel series must upgrade.

The updated 5.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.13.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 drivers/firmware/efi/mokvar-table.c                            |    5 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c               |    3 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c          |    6 
 drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c |    2 
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c                 |  227 ----------
 drivers/gpu/drm/i915/gem/selftests/i915_gem_execbuffer.c       |    4 
 drivers/gpu/drm/i915/i915_cmd_parser.c                         |  118 +++--
 drivers/gpu/drm/i915/i915_drv.h                                |    7 
 drivers/gpu/drm/i915/i915_request.c                            |    8 
 drivers/net/dsa/sja1105/sja1105_clocking.c                     |    3 
 drivers/net/dsa/sja1105/sja1105_flower.c                       |    9 
 drivers/net/dsa/sja1105/sja1105_main.c                         |   75 +--
 drivers/net/dsa/sja1105/sja1105_spi.c                          |    4 
 drivers/net/dsa/sja1105/sja1105_tas.c                          |   14 
 drivers/net/ethernet/qlogic/qed/qed_mcp.c                      |   23 -
 drivers/net/usb/r8152.c                                        |   30 -
 drivers/nvme/host/trace.h                                      |    6 
 drivers/power/supply/ab8500_btemp.c                            |    7 
 drivers/power/supply/ab8500_fg.c                               |    6 
 drivers/power/supply/abx500_chargalg.c                         |    7 
 drivers/regulator/mtk-dvfsrc-regulator.c                       |    3 
 drivers/regulator/rtmv20-regulator.c                           |    2 
 drivers/spi/spi-mt65xx.c                                       |   19 
 drivers/spi/spi-stm32.c                                        |   15 
 drivers/watchdog/iTCO_wdt.c                                    |   12 
 fs/cifs/fs_context.c                                           |   31 +
 fs/cifs/fs_context.h                                           |    1 
 fs/io-wq.c                                                     |    7 
 fs/io_uring.c                                                  |   25 -
 include/linux/mfd/rt5033-private.h                             |    4 
 net/bluetooth/hci_core.c                                       |   16 
 net/core/skbuff.c                                              |    5 
 net/core/skmsg.c                                               |   68 ++
 sound/soc/codecs/rt5682.c                                      |    8 
 sound/soc/codecs/tlv320aic31xx.h                               |    4 
 sound/soc/intel/boards/Kconfig                                 |   18 
 sound/soc/intel/boards/Makefile                                |   28 -
 sound/soc/intel/boards/bxt_da7219_max98357a.c                  |    1 
 sound/soc/intel/boards/bxt_rt298.c                             |    1 
 sound/soc/intel/boards/cml_rt1011_rt5682.c                     |    1 
 sound/soc/intel/boards/ehl_rt5660.c                            |    1 
 sound/soc/intel/boards/glk_rt5682_max98357a.c                  |    1 
 sound/soc/intel/boards/hda_dsp_common.c                        |    5 
 sound/soc/intel/boards/skl_hda_dsp_generic.c                   |    1 
 sound/soc/intel/boards/sof_da7219_max98373.c                   |    1 
 sound/soc/intel/boards/sof_maxim_common.c                      |   24 -
 sound/soc/intel/boards/sof_maxim_common.h                      |    6 
 sound/soc/intel/boards/sof_pcm512x.c                           |    1 
 sound/soc/intel/boards/sof_rt5682.c                            |    6 
 sound/soc/intel/boards/sof_sdw.c                               |    2 
 sound/soc/intel/boards/sof_sdw_max98373.c                      |   81 ++-
 sound/soc/ti/j721e-evm.c                                       |   18 
 53 files changed, 482 insertions(+), 500 deletions(-)

Alain Volmat (1):
      spi: stm32h7: fix full duplex irq handler handling

Axel Lin (2):
      regulator: rt5033: Fix n_voltages settings for BUCK and LDO
      regulator: mtk-dvfsrc: Fix wrong dev pointer for devm_regulator_register

Borislav Petkov (1):
      efi/mokvar: Reserve the table only if it is in boot services data

ChiYuan Huang (1):
      regulator: rtmv20: Fix wrong mask for strobe-polarity-high

Cong Wang (2):
      skmsg: Increase sk->sk_drops when dropping packets
      skmsg: Pass source psock to sk_psock_skb_redirect()

Greg Kroah-Hartman (3):
      Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"
      Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"
      Linux 5.13.9

Guenter Roeck (1):
      spi: mediatek: Fix fifo transfer

Jason Ekstrand (2):
      drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
      Revert "drm/i915: Propagate errors on awaiting already signaled fences"

Jens Axboe (2):
      io_uring: never attempt iopoll reissue from release path
      io_uring: explicitly catch any illegal async queue attempt

Jia He (1):
      qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()

John Fastabend (1):
      bpf, sockmap: On cleanup we additionally need to remove cached skb

Keith Busch (1):
      nvme: fix nvme_setup_command metadata trace event

Kyle Russell (1):
      ASoC: tlv320aic31xx: fix reversed bclk/wclk master bits

Linus Walleij (1):
      power: supply: ab8500: Call battery population once

Nicholas Kazlauskas (1):
      drm/amd/display: Fix max vstartup calculation for modes with borders

Oder Chiou (1):
      ASoC: rt5682: Fix the issue of garbled recording after powerd_dbus_suspend

Peter Ujfalusi (2):
      ASoC: ti: j721e-evm: Fix unbalanced domain activity tracking during startup
      ASoC: ti: j721e-evm: Check for not initialized parent_clk_id

Pierre-Louis Bossart (2):
      ASoC: Intel: boards: handle hda-dsp-common as a module
      ASoC: Intel: boards: create sof-maxim-common module

Pravin B Shelar (1):
      net: Fix zero-copy head len calculation.

Rander Wang (1):
      ASoC: Intel: boards: fix xrun issue on platform with max98373

Ronnie Sahlberg (2):
      cifs: use helpers when parsing uid/gid mount options and validate them
      cifs: add missing parsing of backupuid

Stylon Wang (1):
      drm/amd/display: Fix ASSR regression on embedded panels

Takashi Iwai (2):
      r8152: Fix potential PM refcount imbalance
      r8152: Fix a deadlock by doubly PM resume

Victor Lu (1):
      drm/amd/display: Fix comparison error in dcn21 DML

Vladimir Oltean (2):
      net: dsa: sja1105: parameterize the number of ports
      net: dsa: sja1105: fix address learning getting disabled on the CPU port

