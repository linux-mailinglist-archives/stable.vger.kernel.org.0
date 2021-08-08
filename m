Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8E03E3955
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhHHHQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231151AbhHHHQP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 03:16:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FB8B6024A;
        Sun,  8 Aug 2021 07:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628406957;
        bh=x1d+ygPAABTdLmLfGX+Bxpw8O2yGxlRpRgBzxFGPrXQ=;
        h=From:To:Cc:Subject:Date:From;
        b=NXfkWFizBhznMtZhQ+7svpKYYgzpvbR8S8wzBCfKrEFBgd0sEhkOozKstMl9FaQ+M
         ISNgsPAA7IX/h7IZtpTSq/87xwt8geGDlfrdJQrfMBpOxV0Xpiwt4FQEWGxE4Hcs6y
         ehfV8mgpmrDl4U53gaPK+pOCK/hcH4eRwql8oS8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.57
Date:   Sun,  8 Aug 2021 09:15:50 +0200
Message-Id: <162840695072108@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.57 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 drivers/firmware/arm_scmi/bus.c                                |    3 
 drivers/firmware/arm_scmi/driver.c                             |    8 
 drivers/firmware/efi/mokvar-table.c                            |    5 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c          |    6 
 drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c |    2 
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c                 |  164 ----------
 drivers/gpu/drm/i915/i915_cmd_parser.c                         |   28 -
 drivers/gpu/drm/i915/i915_request.c                            |    8 
 drivers/net/ethernet/qlogic/qed/qed_mcp.c                      |   23 +
 drivers/net/usb/r8152.c                                        |    3 
 drivers/nvme/host/trace.h                                      |    6 
 drivers/regulator/rtmv20-regulator.c                           |    2 
 drivers/spi/spi-mt65xx.c                                       |   19 -
 drivers/spi/spi-stm32.c                                        |   15 
 drivers/watchdog/iTCO_wdt.c                                    |   12 
 fs/btrfs/tree-log.c                                            |    5 
 include/acpi/acpi_bus.h                                        |    3 
 include/linux/mfd/rt5033-private.h                             |    4 
 net/bluetooth/hci_core.c                                       |   16 
 net/core/skbuff.c                                              |    5 
 sound/soc/codecs/rt5682.c                                      |    8 
 sound/soc/codecs/tlv320aic31xx.h                               |    4 
 sound/soc/ti/j721e-evm.c                                       |   18 -
 tools/testing/selftests/bpf/progs/bpf_iter_task.c              |    3 
 tools/testing/selftests/bpf/test_verifier.c                    |    2 
 tools/testing/selftests/bpf/verifier/and.c                     |    2 
 tools/testing/selftests/bpf/verifier/basic_stack.c             |    2 
 tools/testing/selftests/bpf/verifier/bounds.c                  |   19 -
 tools/testing/selftests/bpf/verifier/bounds_deduction.c        |   21 -
 tools/testing/selftests/bpf/verifier/bounds_mix_sign_unsign.c  |   13 
 tools/testing/selftests/bpf/verifier/calls.c                   |    4 
 tools/testing/selftests/bpf/verifier/const_or.c                |    4 
 tools/testing/selftests/bpf/verifier/dead_code.c               |    2 
 tools/testing/selftests/bpf/verifier/helper_access_var_len.c   |   12 
 tools/testing/selftests/bpf/verifier/int_ptr.c                 |    6 
 tools/testing/selftests/bpf/verifier/jmp32.c                   |   22 +
 tools/testing/selftests/bpf/verifier/jset.c                    |   10 
 tools/testing/selftests/bpf/verifier/map_ptr.c                 |    4 
 tools/testing/selftests/bpf/verifier/raw_stack.c               |   10 
 tools/testing/selftests/bpf/verifier/stack_ptr.c               |   22 -
 tools/testing/selftests/bpf/verifier/unpriv.c                  |    9 
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c         |   17 -
 tools/testing/selftests/bpf/verifier/var_off.c                 |  115 ++++++-
 44 files changed, 332 insertions(+), 336 deletions(-)

Alain Volmat (1):
      spi: stm32h7: fix full duplex irq handler handling

Andrei Matei (2):
      selftest/bpf: Adjust expected verifier errors
      selftest/bpf: Verifier tests for var-off access

Axel Lin (1):
      regulator: rt5033: Fix n_voltages settings for BUCK and LDO

Borislav Petkov (1):
      efi/mokvar: Reserve the table only if it is in boot services data

ChiYuan Huang (1):
      regulator: rtmv20: Fix wrong mask for strobe-polarity-high

Cristian Marussi (1):
      firmware: arm_scmi: Add delayed response status check

Daniel Borkmann (3):
      bpf, selftests: Adjust few selftest result_unpriv outcomes
      bpf: Update selftests to reflect new error states
      bpf, selftests: Adjust few selftest outcomes wrt unreachable code

Filipe Manana (2):
      btrfs: fix race causing unnecessary inode logging during link and rename
      btrfs: fix lost inode on log replay after mix of fsync, rename and inode eviction

Greg Kroah-Hartman (3):
      Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"
      Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"
      Linux 5.10.57

Guenter Roeck (1):
      spi: mediatek: Fix fifo transfer

Jason Ekstrand (2):
      drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
      Revert "drm/i915: Propagate errors on awaiting already signaled fences"

Jia He (1):
      qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()

Keith Busch (1):
      nvme: fix nvme_setup_command metadata trace event

Kyle Russell (1):
      ASoC: tlv320aic31xx: fix reversed bclk/wclk master bits

Linus Torvalds (1):
      ACPI: fix NULL pointer dereference

Nicholas Kazlauskas (1):
      drm/amd/display: Fix max vstartup calculation for modes with borders

Oder Chiou (1):
      ASoC: rt5682: Fix the issue of garbled recording after powerd_dbus_suspend

Peter Ujfalusi (2):
      ASoC: ti: j721e-evm: Fix unbalanced domain activity tracking during startup
      ASoC: ti: j721e-evm: Check for not initialized parent_clk_id

Pravin B Shelar (1):
      net: Fix zero-copy head len calculation.

Sudeep Holla (1):
      firmware: arm_scmi: Ensure drivers provide a probe function

Takashi Iwai (1):
      r8152: Fix potential PM refcount imbalance

Victor Lu (1):
      drm/amd/display: Fix comparison error in dcn21 DML

Yonghong Song (1):
      selftests/bpf: Add a test for ptr_to_map_value on stack for helper access

