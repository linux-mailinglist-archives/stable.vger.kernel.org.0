Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D113E2582
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244177AbhHFIUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244273AbhHFITc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:19:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC216120D;
        Fri,  6 Aug 2021 08:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237955;
        bh=RTwdxbk2mr34Wy0D5fjScpdzoBJPiMGygSsvcwUxzBQ=;
        h=From:To:Cc:Subject:Date:From;
        b=A1Tpf/a3HmUDCa4uvgb20iPRMv83JFoAks+k3EfzUK5HUC34uLsaxvPVC+Q3k/jEI
         n/G2IIGUDfoJzeQr/BeRiEnfLFFWCQorZ/nj6h2yxwneQHcAR3F/9Qa6P/WORi8Jif
         zGzJQaIdIuhNQaZlgw9elShja60ZPIWprJJXwF6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/30] 5.10.57-rc1 review
Date:   Fri,  6 Aug 2021 10:16:38 +0200
Message-Id: <20210806081113.126861800@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.57-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.57-rc1
X-KernelTest-Deadline: 2021-08-08T08:11+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.57 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.57-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.57-rc1

Andrei Matei <andreimatei1@gmail.com>
    selftest/bpf: Verifier tests for var-off access

Daniel Borkmann <daniel@iogearbox.net>
    bpf, selftests: Adjust few selftest outcomes wrt unreachable code

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Update selftests to reflect new error states

Daniel Borkmann <daniel@iogearbox.net>
    bpf, selftests: Adjust few selftest result_unpriv outcomes

Andrei Matei <andreimatei1@gmail.com>
    selftest/bpf: Adjust expected verifier errors

Yonghong Song <yhs@fb.com>
    selftests/bpf: Add a test for ptr_to_map_value on stack for helper access

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Add delayed response status check

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: Ensure drivers provide a probe function

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "spi: mediatek: fix fifo rx mode"

Linus Torvalds <torvalds@linux-foundation.org>
    ACPI: fix NULL pointer dereference

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
    r8152: Fix potential PM refcount imbalance

Kyle Russell <bkylerussell@gmail.com>
    ASoC: tlv320aic31xx: fix reversed bclk/wclk master bits

Alain Volmat <alain.volmat@foss.st.com>
    spi: stm32h7: fix full duplex irq handler handling

Axel Lin <axel.lin@ingics.com>
    regulator: rt5033: Fix n_voltages settings for BUCK and LDO

ChiYuan Huang <cy_huang@richtek.com>
    regulator: rtmv20: Fix wrong mask for strobe-polarity-high

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost inode on log replay after mix of fsync, rename and inode eviction

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race causing unnecessary inode logging during link and rename

Jason Ekstrand <jason@jlekstrand.net>
    Revert "drm/i915: Propagate errors on awaiting already signaled fences"

Jason Ekstrand <jason@jlekstrand.net>
    drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"


-------------

Diffstat:

 Makefile                                           |   4 +-
 drivers/firmware/arm_scmi/bus.c                    |   3 +
 drivers/firmware/arm_scmi/driver.c                 |   8 +-
 drivers/firmware/efi/mokvar-table.c                |   5 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   6 +-
 .../amd/display/dc/dml/dcn21/display_mode_vba_21.c |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     | 164 ++-------------------
 drivers/gpu/drm/i915/i915_cmd_parser.c             |  28 ++--
 drivers/gpu/drm/i915/i915_request.c                |   8 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |  23 ++-
 drivers/net/usb/r8152.c                            |   3 +-
 drivers/nvme/host/trace.h                          |   6 +-
 drivers/regulator/rtmv20-regulator.c               |   2 +-
 drivers/spi/spi-mt65xx.c                           |  16 +-
 drivers/spi/spi-stm32.c                            |  15 +-
 drivers/watchdog/iTCO_wdt.c                        |  12 +-
 fs/btrfs/tree-log.c                                |   5 +-
 include/acpi/acpi_bus.h                            |   3 +-
 include/linux/mfd/rt5033-private.h                 |   4 +-
 net/bluetooth/hci_core.c                           |  16 +-
 net/core/skbuff.c                                  |   5 +-
 sound/soc/codecs/rt5682.c                          |   8 +-
 sound/soc/codecs/tlv320aic31xx.h                   |   4 +-
 sound/soc/ti/j721e-evm.c                           |  18 ++-
 tools/testing/selftests/bpf/progs/bpf_iter_task.c  |   3 +-
 tools/testing/selftests/bpf/test_verifier.c        |   2 +-
 tools/testing/selftests/bpf/verifier/and.c         |   2 +
 tools/testing/selftests/bpf/verifier/basic_stack.c |   2 +-
 tools/testing/selftests/bpf/verifier/bounds.c      |  19 ++-
 .../selftests/bpf/verifier/bounds_deduction.c      |  21 +--
 .../bpf/verifier/bounds_mix_sign_unsign.c          |  13 --
 tools/testing/selftests/bpf/verifier/calls.c       |   4 +-
 tools/testing/selftests/bpf/verifier/const_or.c    |   4 +-
 tools/testing/selftests/bpf/verifier/dead_code.c   |   2 +
 .../selftests/bpf/verifier/helper_access_var_len.c |  12 +-
 tools/testing/selftests/bpf/verifier/int_ptr.c     |   6 +-
 tools/testing/selftests/bpf/verifier/jmp32.c       |  22 +++
 tools/testing/selftests/bpf/verifier/jset.c        |  10 +-
 tools/testing/selftests/bpf/verifier/map_ptr.c     |   4 +-
 tools/testing/selftests/bpf/verifier/raw_stack.c   |  10 +-
 tools/testing/selftests/bpf/verifier/stack_ptr.c   |  22 +--
 tools/testing/selftests/bpf/verifier/unpriv.c      |   9 +-
 .../selftests/bpf/verifier/value_ptr_arith.c       |  17 +--
 tools/testing/selftests/bpf/verifier/var_off.c     | 115 +++++++++++++--
 44 files changed, 331 insertions(+), 336 deletions(-)


