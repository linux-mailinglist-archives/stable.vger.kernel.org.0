Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0666F35AD11
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 13:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbhDJLvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 07:51:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234667AbhDJLvr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 07:51:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5F44610F9;
        Sat, 10 Apr 2021 11:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618055493;
        bh=JMzEGEEm8NvWbFDv9n7ssqkBdomP2/kIu5LUEn8H74A=;
        h=From:To:Cc:Subject:Date:From;
        b=YdYAozHF4LVX7feA1jWO8FLuOpUlN2YBhcXZgRnDIZpMqCk0bCDURg+Ir1jCzXgan
         pLyWBCCqHU2kVX5K5ewJUGmy/mJ63eIW7gw/UAU3sfOS899xZICdbthgPIT6RDYf2Y
         Ef7rx339sRGfa8goP9D6lvIsq/D2sIsPl536EOYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.13
Date:   Sat, 10 Apr 2021 13:51:24 +0200
Message-Id: <1618055484188244@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.11.13 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.rst            |    3 
 Makefile                                          |   15 +++-
 arch/arm/boot/dts/am33xx.dtsi                     |    3 
 arch/arm64/Kconfig                                |   10 ++
 arch/arm64/include/asm/cpucaps.h                  |    3 
 arch/arm64/kernel/cpu_errata.c                    |    8 ++
 arch/arm64/kernel/cpufeature.c                    |    5 +
 arch/ia64/kernel/err_inject.c                     |   22 +++---
 arch/ia64/kernel/mca.c                            |    2 
 arch/x86/Makefile                                 |    2 
 arch/x86/net/bpf_jit_comp.c                       |   15 +++-
 arch/x86/net/bpf_jit_comp32.c                     |   11 ++-
 drivers/bus/ti-sysc.c                             |    4 -
 drivers/gpu/drm/msm/adreno/a5xx_power.c           |    2 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c             |   77 ++++++++++++++++++----
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c           |   12 ++-
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_7nm.c         |    2 
 drivers/gpu/drm/msm/msm_fence.c                   |    2 
 drivers/isdn/hardware/mISDN/mISDNipac.c           |    2 
 drivers/net/arcnet/com20020-pci.c                 |   34 +++++----
 drivers/net/can/usb/Kconfig                       |    1 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c  |    4 -
 drivers/net/ethernet/marvell/pxa168_eth.c         |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    5 -
 drivers/net/ipa/ipa_cmd.c                         |   50 +++++++++-----
 drivers/platform/x86/intel-hid.c                  |    7 ++
 drivers/platform/x86/intel_pmc_core.c             |   50 ++++++++++----
 drivers/platform/x86/intel_pmt_class.c            |    2 
 drivers/platform/x86/thinkpad_acpi.c              |    8 ++
 drivers/ptp/ptp_qoriq.c                           |   13 ++-
 drivers/target/target_core_pscsi.c                |    8 ++
 fs/block_dev.c                                    |    4 -
 fs/cifs/file.c                                    |    1 
 fs/cifs/smb2misc.c                                |    4 -
 fs/io_uring.c                                     |    8 +-
 init/Kconfig                                      |    3 
 lib/math/div64.c                                  |    1 
 net/mac80211/aead_api.c                           |    5 -
 net/mac80211/aes_gmac.c                           |    5 -
 net/mac80211/main.c                               |   13 +++
 net/netfilter/nf_conntrack_proto_gre.c            |    3 
 net/netfilter/nf_tables_api.c                     |    3 
 tools/bpf/resolve_btfids/.gitignore               |    3 
 tools/bpf/resolve_btfids/Makefile                 |   44 ++++++------
 tools/testing/kunit/kunit_config.py               |    2 
 tools/testing/selftests/arm64/fp/sve-test.S       |   22 ++++--
 tools/testing/selftests/vm/Makefile               |    4 -
 47 files changed, 356 insertions(+), 153 deletions(-)

Alban Bedel (1):
      platform/x86: intel-hid: Support Lenovo ThinkPad X1 Tablet Gen 2

Alex Elder (1):
      net: ipa: fix init header command validation

Andre Przywara (1):
      kselftest/arm64: sve: Do not use non-canonical FFR register value

Arnd Bergmann (1):
      x86/build: Turn off -fcf-protection for realmode targets

Chris Chiu (1):
      block: clear GD_NEED_PART_SCAN later in bdev_disk_changed

Daniel Phan (1):
      mac80211: Check crypto_aead_encrypt for errors

David E. Box (2):
      platform/x86: intel_pmt_class: Initial resource to 0
      platform/x86: intel_pmc_core: Ignore GBE LTR on Tiger Lake platforms

David Gow (1):
      kunit: tool: Fix a python tuple typing error

David S. Miller (1):
      math: Export mul_u64_u64_div_u64

Dmitry Baryshkov (1):
      drm/msm/dsi_pll_7nm: Fix variable usage for pll_lockdet_rate

Esteve Varela Colominas (1):
      platform/x86: thinkpad_acpi: Allow the FnLock LED to change state

Greg Kroah-Hartman (1):
      Linux 5.11.13

Jimmy Assarsson (1):
      can: kvaser_usb: Add support for USBcan Pro 4xHS

Jiri Olsa (5):
      tools/resolve_btfids: Build libbpf and libsubcmd in separate directories
      tools/resolve_btfids: Check objects before removing
      tools/resolve_btfids: Set srctree variable unconditionally
      kbuild: Add resolve_btfids clean to root clean target
      kbuild: Do not clean resolve_btfids if the output does not exist

Jordan Crouse (1):
      drm/msm: a6xx: Make sure the SQE microcode is safe

Kalyan Thota (1):
      drm/msm/disp/dpu1: icc path needs to be set before dpu runtime resume

Karthikeyan Kathirvel (1):
      mac80211: choose first enabled channel for monitor

Konrad Dybcio (1):
      drm/msm/adreno: a5xx_power: Don't apply A540 lm_setup to other GPUs

Ludovic Senecaux (1):
      netfilter: conntrack: Fix gre tunneling over ipv6

Mans Rullgard (1):
      ARM: dts: am33xx: add aliases for mmc interfaces

Martin Wilck (1):
      scsi: target: pscsi: Clean up after failure in pscsi_map_sg()

Masahiro Yamada (1):
      init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM

Pablo Neira Ayuso (1):
      netfilter: nftables: skip hook overlap logic if flowtable is stale

Pavel Andrianov (1):
      net: pxa168_eth: Fix a potential data race in pxa168_eth_remove

Pavel Begunkov (1):
      io_uring: fix timeout cancel return code

Piotr Krysiuk (2):
      bpf, x86: Validate computation of branch displacements for x86-64
      bpf, x86: Validate computation of branch displacements for x86-32

Rich Wiley (1):
      arm64: kernel: disable CNP on Carmel

Rob Clark (1):
      drm/msm: Ratelimit invalid-fence message

Rong Chen (1):
      selftests/vm: fix out-of-tree build

Ronnie Sahlberg (1):
      cifs: revalidate mapping when we open files for SMB1 POSIX

Sergei Trofimovich (2):
      ia64: mca: allocate early mca with GFP_ATOMIC
      ia64: fix format strings for err_inject

Stanislav Fomichev (1):
      tools/resolve_btfids: Add /libbpf to .gitignore

Tariq Toukan (1):
      net/mlx5e: Enforce minimum value check for ICOSQ size

Tong Zhang (2):
      mISDN: fix crash in fritzpci
      net: arcnet: com20020 fix error handling

Tony Lindgren (1):
      bus: ti-sysc: Fix warning on unbind if reset is not deasserted

Vincent Whitchurch (1):
      cifs: Silently ignore unknown oplock break handle

Yangbo Lu (1):
      ptp_qoriq: fix overflow in ptp_qoriq_adjfine() u64 calcalation

Yonghong Song (1):
      bpf, x86: Use kvmalloc_array instead kmalloc_array in bpf_jit_comp

