Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE043E25D8
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244373AbhHFIW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238391AbhHFIV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:21:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C00C061212;
        Fri,  6 Aug 2021 08:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238074;
        bh=FnPpRy0TBAzoOI1gtROqWQrgwOXv42vRnoZO8dfgunQ=;
        h=From:To:Cc:Subject:Date:From;
        b=uXDqd3zkS+FouQf+BwYoNXeKOY0EFLzIycK4uzGnVelsvXbG8oWyw078o1MSwBbp/
         oUjaiZT2pm/y3yTsfgFs4QIE+TrcNH4geGu7pO1NG7rG3tT7wpXyChSScaYZ7RM1xM
         2S00+WooYcKJ0r/nHAH7+B5JFADKT942oAT9WRAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.13 00/35] 5.13.9-rc1 review
Date:   Fri,  6 Aug 2021 10:16:43 +0200
Message-Id: <20210806081113.718626745@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.9-rc1
X-KernelTest-Deadline: 2021-08-08T08:11+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.13.9 release.
There are 35 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.13.9-rc1

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Fix ASSR regression on embedded panels

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "spi: mediatek: fix fifo rx mode"

Jens Axboe <axboe@kernel.dk>
    io_uring: explicitly catch any illegal async queue attempt

Jens Axboe <axboe@kernel.dk>
    io_uring: never attempt iopoll reissue from release path

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Fix max vstartup calculation for modes with borders

Victor Lu <victorchengchi.lu@amd.com>
    drm/amd/display: Fix comparison error in dcn21 DML

Keith Busch <kbusch@kernel.org>
    nvme: fix nvme_setup_command metadata trace event

Borislav Petkov <bp@suse.de>
    efi/mokvar: Reserve the table only if it is in boot services data

Peter Ujfalusi <peter.ujfalusi@gmail.com>
    ASoC: ti: j721e-evm: Check for not initialized parent_clk_id

Peter Ujfalusi <peter.ujfalusi@gmail.com>
    ASoC: ti: j721e-evm: Fix unbalanced domain activity tracking during startup

Pravin B Shelar <pshelar@ovn.org>
    net: Fix zero-copy head len calculation.

Oder Chiou <oder_chiou@realtek.com>
    ASoC: rt5682: Fix the issue of garbled recording after powerd_dbus_suspend

Jia He <justin.he@arm.com>
    qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()

Takashi Iwai <tiwai@suse.de>
    r8152: Fix a deadlock by doubly PM resume

Takashi Iwai <tiwai@suse.de>
    r8152: Fix potential PM refcount imbalance

Axel Lin <axel.lin@ingics.com>
    regulator: mtk-dvfsrc: Fix wrong dev pointer for devm_regulator_register

Kyle Russell <bkylerussell@gmail.com>
    ASoC: tlv320aic31xx: fix reversed bclk/wclk master bits

Alain Volmat <alain.volmat@foss.st.com>
    spi: stm32h7: fix full duplex irq handler handling

Axel Lin <axel.lin@ingics.com>
    regulator: rt5033: Fix n_voltages settings for BUCK and LDO

ChiYuan Huang <cy_huang@richtek.com>
    regulator: rtmv20: Fix wrong mask for strobe-polarity-high

Rander Wang <rander.wang@intel.com>
    ASoC: Intel: boards: fix xrun issue on platform with max98373

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: boards: create sof-maxim-common module

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: boards: handle hda-dsp-common as a module

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: fix address learning getting disabled on the CPU port

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: parameterize the number of ports

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: add missing parsing of backupuid

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: use helpers when parsing uid/gid mount options and validate them

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: On cleanup we additionally need to remove cached skb

Cong Wang <cong.wang@bytedance.com>
    skmsg: Pass source psock to sk_psock_skb_redirect()

Cong Wang <cong.wang@bytedance.com>
    skmsg: Increase sk->sk_drops when dropping packets

Linus Walleij <linus.walleij@linaro.org>
    power: supply: ab8500: Call battery population once

Jason Ekstrand <jason@jlekstrand.net>
    Revert "drm/i915: Propagate errors on awaiting already signaled fences"

Jason Ekstrand <jason@jlekstrand.net>
    drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"


-------------

Diffstat:

 Makefile                                           |   4 +-
 drivers/firmware/efi/mokvar-table.c                |   5 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   3 -
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   6 +-
 .../amd/display/dc/dml/dcn21/display_mode_vba_21.c |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     | 227 ++-------------------
 .../drm/i915/gem/selftests/i915_gem_execbuffer.c   |   4 +
 drivers/gpu/drm/i915/i915_cmd_parser.c             | 118 +++++++----
 drivers/gpu/drm/i915/i915_drv.h                    |   7 +-
 drivers/gpu/drm/i915/i915_request.c                |   8 +-
 drivers/net/dsa/sja1105/sja1105_clocking.c         |   3 +-
 drivers/net/dsa/sja1105/sja1105_flower.c           |   9 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |  75 ++++---
 drivers/net/dsa/sja1105/sja1105_spi.c              |   4 +-
 drivers/net/dsa/sja1105/sja1105_tas.c              |  14 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |  23 ++-
 drivers/net/usb/r8152.c                            |  30 ++-
 drivers/nvme/host/trace.h                          |   6 +-
 drivers/power/supply/ab8500_btemp.c                |   7 -
 drivers/power/supply/ab8500_fg.c                   |   6 -
 drivers/power/supply/abx500_chargalg.c             |   7 -
 drivers/regulator/mtk-dvfsrc-regulator.c           |   3 +-
 drivers/regulator/rtmv20-regulator.c               |   2 +-
 drivers/spi/spi-mt65xx.c                           |  16 +-
 drivers/spi/spi-stm32.c                            |  15 +-
 drivers/watchdog/iTCO_wdt.c                        |  12 +-
 fs/cifs/fs_context.c                               |  31 ++-
 fs/cifs/fs_context.h                               |   1 +
 fs/io-wq.c                                         |   7 +-
 fs/io_uring.c                                      |  25 ++-
 include/linux/mfd/rt5033-private.h                 |   4 +-
 net/bluetooth/hci_core.c                           |  16 +-
 net/core/skbuff.c                                  |   5 +-
 net/core/skmsg.c                                   |  68 ++++--
 sound/soc/codecs/rt5682.c                          |   8 +-
 sound/soc/codecs/tlv320aic31xx.h                   |   4 +-
 sound/soc/intel/boards/Kconfig                     |  18 ++
 sound/soc/intel/boards/Makefile                    |  28 ++-
 sound/soc/intel/boards/bxt_da7219_max98357a.c      |   1 +
 sound/soc/intel/boards/bxt_rt298.c                 |   1 +
 sound/soc/intel/boards/cml_rt1011_rt5682.c         |   1 +
 sound/soc/intel/boards/ehl_rt5660.c                |   1 +
 sound/soc/intel/boards/glk_rt5682_max98357a.c      |   1 +
 sound/soc/intel/boards/hda_dsp_common.c            |   5 +
 sound/soc/intel/boards/skl_hda_dsp_generic.c       |   1 +
 sound/soc/intel/boards/sof_da7219_max98373.c       |   1 +
 sound/soc/intel/boards/sof_maxim_common.c          |  24 ++-
 sound/soc/intel/boards/sof_maxim_common.h          |   6 +-
 sound/soc/intel/boards/sof_pcm512x.c               |   1 +
 sound/soc/intel/boards/sof_rt5682.c                |   6 +-
 sound/soc/intel/boards/sof_sdw.c                   |   2 +
 sound/soc/intel/boards/sof_sdw_max98373.c          |  81 +++++---
 sound/soc/ti/j721e-evm.c                           |  18 +-
 53 files changed, 481 insertions(+), 500 deletions(-)


