Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D643738D57C
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 13:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhEVLFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 07:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230236AbhEVLFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 May 2021 07:05:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA2CC61151;
        Sat, 22 May 2021 11:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621681438;
        bh=79DT08rzUQHJQdOgTxXzqE/kcb49oHOVxJkd9yG/Juk=;
        h=From:To:Cc:Subject:Date:From;
        b=2KcvtR8yz2oKXXutMsI/Q+UsuhKfU+4c9t5H4bo0FxucpUWRSKi00+hyEAPrvVoD9
         7J7ob/eKE8O9zTMIob6wgHmhaEcLWSiHS1agQG3szIpSXEP7Ts7cAdhLNr6Qt6DEEC
         eA17CPej2QgVL2rGoPIysKQeynO+/zEsSTuv0UGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.121
Date:   Sat, 22 May 2021 13:03:54 +0200
Message-Id: <1621681435147149@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.121 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/sphinx/parse-headers.pl                          |    2 
 Documentation/target/tcm_mod_builder.py                        |    2 
 Documentation/trace/postprocess/decode_msr.py                  |    2 
 Documentation/trace/postprocess/trace-pagealloc-postprocess.pl |    2 
 Documentation/trace/postprocess/trace-vmscan-postprocess.pl    |    2 
 Makefile                                                       |    2 
 arch/arm/include/asm/kvm_host.h                                |    1 
 arch/arm/kernel/asm-offsets.c                                  |    3 
 arch/arm/kernel/smccc-call.S                                   |   11 +
 arch/arm/kernel/suspend.c                                      |   19 ++
 arch/arm64/include/asm/kvm_host.h                              |    1 
 arch/arm64/kvm/debug.c                                         |   88 ++++++----
 arch/ia64/scripts/unwcheck.py                                  |    2 
 arch/riscv/include/asm/ftrace.h                                |   14 +
 arch/riscv/kernel/mcount.S                                     |   10 -
 arch/um/Kconfig.debug                                          |    1 
 arch/um/kernel/Makefile                                        |    1 
 arch/um/kernel/dyn.lds.S                                       |    6 
 arch/um/kernel/gmon_syms.c                                     |   16 -
 arch/um/kernel/uml.lds.S                                       |    6 
 arch/x86/lib/msr-smp.c                                         |    4 
 drivers/dma/dw-edma/dw-edma-core.c                             |   11 -
 drivers/gpio/gpiolib-acpi.c                                    |   14 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c              |   51 +++++
 drivers/input/touchscreen/elants_i2c.c                         |   44 ++++-
 drivers/input/touchscreen/silead.c                             |   44 ++++-
 drivers/isdn/capi/kcapi.c                                      |    4 
 drivers/misc/kgdbts.c                                          |   26 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c             |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c               |    7 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c              |   14 -
 drivers/net/virtio_net.c                                       |   10 -
 drivers/pci/controller/pci-thunder-ecam.c                      |    2 
 drivers/pci/controller/pci-thunder-pem.c                       |   13 -
 drivers/pci/hotplug/acpiphp_glue.c                             |    1 
 drivers/pci/pci.h                                              |    6 
 drivers/pinctrl/pinctrl-ingenic.c                              |    3 
 drivers/scsi/lpfc/lpfc_sli.c                                   |   11 +
 drivers/target/target_core_user.c                              |    4 
 drivers/usb/host/sl811-hcd.c                                   |    9 -
 fs/block_dev.c                                                 |   20 +-
 fs/ceph/caps.c                                                 |    1 
 fs/ceph/inode.c                                                |    1 
 include/linux/virtio_net.h                                     |   14 +
 lib/stackdepot.c                                               |    6 
 net/bridge/br_netlink.c                                        |    5 
 net/ipv6/ip6_gre.c                                             |    7 
 net/ipv6/ip6_tunnel.c                                          |    3 
 net/ipv6/ip6_vti.c                                             |    1 
 net/ipv6/sit.c                                                 |    5 
 net/xdp/xsk_queue.h                                            |    7 
 scripts/bloat-o-meter                                          |    2 
 scripts/config                                                 |    2 
 scripts/diffconfig                                             |    2 
 scripts/get_abi.pl                                             |    2 
 scripts/recordmcount.pl                                        |    2 
 scripts/show_delta                                             |    2 
 scripts/sphinx-pre-install                                     |    2 
 scripts/split-man.pl                                           |    2 
 scripts/tracing/draw_functrace.py                              |    2 
 sound/pci/hda/hda_generic.c                                    |   16 +
 tools/perf/python/tracepoint.py                                |    2 
 tools/perf/python/twatch.py                                    |    2 
 tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py     |    2 
 tools/testing/ktest/compare-ktest-sample.pl                    |    2 
 tools/testing/selftests/bpf/test_offload.py                    |    2 
 tools/testing/selftests/kselftest/prefix.pl                    |    2 
 tools/testing/selftests/tc-testing/tdc_batch.py                |    2 
 tools/testing/selftests/tc-testing/tdc_multibatch.py           |    2 
 virt/kvm/arm/arm.c                                             |    2 
 70 files changed, 415 insertions(+), 178 deletions(-)

Alexandru Elisei (1):
      KVM: arm64: Initialize VCPU mdcr_el2 before loading it

Andy Shevchenko (1):
      scripts: switch explicitly to Python 3

Arnd Bergmann (5):
      x86/msr: Fix wr/rdmsr_safe_regs_on_cpu() prototypes
      kgdb: fix gcc-11 warning on indentation
      usb: sl811-hcd: improve misleading indentation
      isdn: capi: fix mismatched prototypes
      PCI: thunder: Fix compile testing

Bodo Stroesser (1):
      scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found

Eric Dumazet (5):
      virtio_net: Do not pull payload in skb->head
      ip6_gre: proper dev_{hold|put} in ndo_[un]init methods
      sit: proper dev_{hold|put} in ndo_[un]init methods
      ip6_tunnel: sit: proper dev_{hold|put} in ndo_[un]init methods
      ipv6: remove extra dev_hold() for fallback tunnels

Feilong Lin (1):
      ACPI / hotplug / PCI: Fix reference count leak in enable_slot()

Finn Behrens (1):
      tweewide: Fix most Shebang lines

Greg Kroah-Hartman (1):
      Linux 5.4.121

Gustavo Pimentel (1):
      dmaengine: dw-edma: Fix crash on loading/unloading driver

Hans de Goede (3):
      Input: elants_i2c - do not bind to i2c-hid compatible ACPI instantiated devices
      Input: silead - add workaround for x86 BIOS-es which bring the chip up in a stuck state
      gpiolib: acpi: Add quirk to ignore EC wakeups on Dell Venue 10 Pro 5055

Hui Wang (1):
      ALSA: hda: generic: change the DAC ctl name for LO+SPK or LO+HP

James Smart (1):
      scsi: lpfc: Fix illegal memory access on Abort IOCBs

Jeff Layton (1):
      ceph: fix fscache invalidation

Johannes Berg (2):
      um: Mark all kernel symbols as local
      um: Disable CONFIG_GCOV with MODULES

Josh Poimboeuf (1):
      pinctrl: ingenic: Improve unreachable code generation

Kaixu Xia (1):
      cxgb4: Fix the -Wmisleading-indentation warning

Magnus Karlsson (1):
      xsk: Simplify detection of empty and full rings

Manivannan Sadhasivam (1):
      ARM: 9075/1: kernel: Fix interrupted SMC calls

Nathan Chancellor (2):
      scripts/recordmcount.pl: Fix RISC-V regex for clang
      riscv: Workaround mcount name prior to clang-13

Rodrigo Siqueira (1):
      drm/amd/display: Fix two cursor duplication when using overlay

Yannick Vignon (1):
      net: stmmac: Do not enable RX FIFO overflow interrupts

Zhang Zhengming (1):
      bridge: Fix possible races between assigning rx_handler_data and setting IFF_BRIDGE_PORT bit

Zqiang (1):
      lib: stackdepot: turn depot_lock spinlock to raw_spinlock

louis.wang (1):
      ARM: 9066/1: ftrace: pause/unpause function graph tracer in cpu_suspend()

yangerkun (1):
      block: reexpand iov_iter after read/write

