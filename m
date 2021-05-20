Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F8438A1C3
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhETJe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231616AbhETJdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:33:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 901BF613D4;
        Thu, 20 May 2021 09:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502914;
        bh=LZX7igwLb3n601fe1x2RK30MoEDSgyNGoxA49uqjKXE=;
        h=From:To:Cc:Subject:Date:From;
        b=ApftATbdBSAsQMT/Ua7t4+bGoEuAY30hPJKSvjNsqDaf+/E403mhu2+72QiVPq52l
         R2u6tBIbG6Zs5eL0fS2gSmmbpU+rV2jp4L4aKOFuJjeQn7OPIe3jvqqh+wYsRIoTm4
         MQ1Hxvs9KsGU7V6mJI1s87iGaFDffFDRpIGUfdao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/37] 5.4.121-rc1 review
Date:   Thu, 20 May 2021 11:22:21 +0200
Message-Id: <20210520092052.265851579@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.121-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.121-rc1
X-KernelTest-Deadline: 2021-05-22T09:20+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.121 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.121-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.121-rc1

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    scripts: switch explicitly to Python 3

Finn Behrens <me@kloenk.de>
    tweewide: Fix most Shebang lines

Alexandru Elisei <alexandru.elisei@arm.com>
    KVM: arm64: Initialize VCPU mdcr_el2 before loading it

Eric Dumazet <edumazet@google.com>
    ipv6: remove extra dev_hold() for fallback tunnels

Eric Dumazet <edumazet@google.com>
    ip6_tunnel: sit: proper dev_{hold|put} in ndo_[un]init methods

Eric Dumazet <edumazet@google.com>
    sit: proper dev_{hold|put} in ndo_[un]init methods

Eric Dumazet <edumazet@google.com>
    ip6_gre: proper dev_{hold|put} in ndo_[un]init methods

Yannick Vignon <yannick.vignon@nxp.com>
    net: stmmac: Do not enable RX FIFO overflow interrupts

Zqiang <qiang.zhang@windriver.com>
    lib: stackdepot: turn depot_lock spinlock to raw_spinlock

yangerkun <yangerkun@huawei.com>
    block: reexpand iov_iter after read/write

Hui Wang <hui.wang@canonical.com>
    ALSA: hda: generic: change the DAC ctl name for LO+SPK or LO+HP

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Add quirk to ignore EC wakeups on Dell Venue 10 Pro 5055

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Fix two cursor duplication when using overlay

Zhang Zhengming <zhangzhengming@huawei.com>
    bridge: Fix possible races between assigning rx_handler_data and setting IFF_BRIDGE_PORT bit

Bodo Stroesser <bostroesser@gmail.com>
    scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found

Jeff Layton <jlayton@kernel.org>
    ceph: fix fscache invalidation

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix illegal memory access on Abort IOCBs

Nathan Chancellor <nathan@kernel.org>
    riscv: Workaround mcount name prior to clang-13

Nathan Chancellor <nathan@kernel.org>
    scripts/recordmcount.pl: Fix RISC-V regex for clang

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    ARM: 9075/1: kernel: Fix interrupted SMC calls

Johannes Berg <johannes.berg@intel.com>
    um: Disable CONFIG_GCOV with MODULES

Johannes Berg <johannes.berg@intel.com>
    um: Mark all kernel symbols as local

Hans de Goede <hdegoede@redhat.com>
    Input: silead - add workaround for x86 BIOS-es which bring the chip up in a stuck state

Hans de Goede <hdegoede@redhat.com>
    Input: elants_i2c - do not bind to i2c-hid compatible ACPI instantiated devices

Feilong Lin <linfeilong@huawei.com>
    ACPI / hotplug / PCI: Fix reference count leak in enable_slot()

louis.wang <liang26812@gmail.com>
    ARM: 9066/1: ftrace: pause/unpause function graph tracer in cpu_suspend()

Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>
    dmaengine: dw-edma: Fix crash on loading/unloading driver

Arnd Bergmann <arnd@arndb.de>
    PCI: thunder: Fix compile testing

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9058/1: cache-v7: refactor v7_invalidate_l1 to avoid clobbering r5/r6

Eric Dumazet <edumazet@google.com>
    virtio_net: Do not pull payload in skb->head

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Simplify detection of empty and full rings

Josh Poimboeuf <jpoimboe@redhat.com>
    pinctrl: ingenic: Improve unreachable code generation

Arnd Bergmann <arnd@arndb.de>
    isdn: capi: fix mismatched prototypes

Kaixu Xia <kaixuxia@tencent.com>
    cxgb4: Fix the -Wmisleading-indentation warning

Arnd Bergmann <arnd@arndb.de>
    usb: sl811-hcd: improve misleading indentation

Arnd Bergmann <arnd@arndb.de>
    kgdb: fix gcc-11 warning on indentation

Arnd Bergmann <arnd@arndb.de>
    x86/msr: Fix wr/rdmsr_safe_regs_on_cpu() prototypes


-------------

Diffstat:

 Documentation/sphinx/parse-headers.pl              |  2 +-
 Documentation/target/tcm_mod_builder.py            |  2 +-
 Documentation/trace/postprocess/decode_msr.py      |  2 +-
 .../postprocess/trace-pagealloc-postprocess.pl     |  2 +-
 .../trace/postprocess/trace-vmscan-postprocess.pl  |  2 +-
 Makefile                                           |  4 +-
 arch/arm/include/asm/kvm_host.h                    |  1 +
 arch/arm/kernel/asm-offsets.c                      |  3 +
 arch/arm/kernel/smccc-call.S                       | 11 ++-
 arch/arm/kernel/suspend.c                          | 19 ++++-
 arch/arm/mm/cache-v7.S                             | 51 ++++++-------
 arch/arm64/include/asm/kvm_host.h                  |  1 +
 arch/arm64/kvm/debug.c                             | 88 +++++++++++++++-------
 arch/ia64/scripts/unwcheck.py                      |  2 +-
 arch/riscv/include/asm/ftrace.h                    | 14 +++-
 arch/riscv/kernel/mcount.S                         | 10 +--
 arch/um/Kconfig.debug                              |  1 +
 arch/um/kernel/Makefile                            |  1 -
 arch/um/kernel/dyn.lds.S                           |  6 ++
 arch/um/kernel/gmon_syms.c                         | 16 ----
 arch/um/kernel/uml.lds.S                           |  6 ++
 arch/x86/lib/msr-smp.c                             |  4 +-
 drivers/dma/dw-edma/dw-edma-core.c                 | 11 ++-
 drivers/gpio/gpiolib-acpi.c                        | 14 ++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 51 +++++++++++++
 drivers/input/touchscreen/elants_i2c.c             | 44 ++++++++++-
 drivers/input/touchscreen/silead.c                 | 44 ++++++++++-
 drivers/isdn/capi/kcapi.c                          |  4 +-
 drivers/misc/kgdbts.c                              | 26 +++----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |  7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 14 +---
 drivers/net/virtio_net.c                           | 10 ++-
 drivers/pci/controller/pci-thunder-ecam.c          |  2 +-
 drivers/pci/controller/pci-thunder-pem.c           | 13 ++--
 drivers/pci/hotplug/acpiphp_glue.c                 |  1 +
 drivers/pci/pci.h                                  |  6 ++
 drivers/pinctrl/pinctrl-ingenic.c                  |  3 +-
 drivers/scsi/lpfc/lpfc_sli.c                       | 11 ++-
 drivers/target/target_core_user.c                  |  4 +-
 drivers/usb/host/sl811-hcd.c                       |  9 +--
 fs/block_dev.c                                     | 20 ++++-
 fs/ceph/caps.c                                     |  1 +
 fs/ceph/inode.c                                    |  1 +
 include/linux/virtio_net.h                         | 14 ++--
 lib/stackdepot.c                                   |  6 +-
 net/bridge/br_netlink.c                            |  5 +-
 net/ipv6/ip6_gre.c                                 |  7 +-
 net/ipv6/ip6_tunnel.c                              |  3 +-
 net/ipv6/ip6_vti.c                                 |  1 -
 net/ipv6/sit.c                                     |  5 +-
 net/xdp/xsk_queue.h                                |  7 +-
 scripts/bloat-o-meter                              |  2 +-
 scripts/config                                     |  2 +-
 scripts/diffconfig                                 |  2 +-
 scripts/get_abi.pl                                 |  2 +-
 scripts/recordmcount.pl                            |  2 +-
 scripts/show_delta                                 |  2 +-
 scripts/sphinx-pre-install                         |  2 +-
 scripts/split-man.pl                               |  2 +-
 scripts/tracing/draw_functrace.py                  |  2 +-
 sound/pci/hda/hda_generic.c                        | 16 ++--
 tools/perf/python/tracepoint.py                    |  2 +-
 tools/perf/python/twatch.py                        |  2 +-
 .../x86/intel_pstate_tracer/intel_pstate_tracer.py |  2 +-
 tools/testing/ktest/compare-ktest-sample.pl        |  2 +-
 tools/testing/selftests/bpf/test_offload.py        |  2 +-
 tools/testing/selftests/kselftest/prefix.pl        |  2 +-
 tools/testing/selftests/tc-testing/tdc_batch.py    |  2 +-
 .../testing/selftests/tc-testing/tdc_multibatch.py |  2 +-
 virt/kvm/arm/arm.c                                 |  2 +
 71 files changed, 441 insertions(+), 205 deletions(-)


