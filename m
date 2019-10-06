Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB0F4CD6AB
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbfJFRkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728276AbfJFRku (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:40:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B83E720700;
        Sun,  6 Oct 2019 17:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383647;
        bh=aVnepZ6qk/wTatWXrBULgstt+9DxjDgwxsG5ob4KilY=;
        h=From:To:Cc:Subject:Date:From;
        b=jOj9eC3BwPOD/mVQP1UvS8tz2NlXa3lOV5Fqee5j90aYJfdo7NY2Bx/4HVz81exof
         b7YHgvuPBMWxDlstv/j8oBAatbL+z+wxpowkwkunUtUowNYF4avUgGnbYLOi4gV5hq
         uuRb/Xz5/zVB+hvl4Yd6jtVOqTF6xOBHNyfl7jZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 000/166] 5.3.5-stable review
Date:   Sun,  6 Oct 2019 19:19:26 +0200
Message-Id: <20191006171212.850660298@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.5-rc1
X-KernelTest-Deadline: 2019-10-08T17:12+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.5 release.
There are 166 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.5-rc1

Eric Biggers <ebiggers@google.com>
    vfs: set fs_context::user_ns for reconfigure

Bharath Vedartham <linux.bhar@gmail.com>
    9p/cache.c: Fix memory leak in v9fs_cache_session_get_cookie

Wanpeng Li <wanpengli@tencent.com>
    KVM: hyperv: Fix Direct Synthetic timers assert an interrupt w/o lapic_in_kernel

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    kexec: bail out upon SIGKILL when allocating memory.

Andrey Konovalov <andreyknvl@google.com>
    NFC: fix attrs checks in netlink interface

Mikulas Patocka <mpatocka@redhat.com>
    dm zoned: fix invalid memory access

Ming Lei <ming.lei@redhat.com>
    dm raid: fix updating of max_discard_sectors limit

Eric Biggers <ebiggers@google.com>
    smack: use GFP_NOFS while holding inode_smack::smk_lock

Jann Horn <jannh@google.com>
    Smack: Don't ignore other bprm->unsafe flags if LSM_UNSAFE_PTRACE is set

Vladimir Oltean <olteanv@gmail.com>
    net: sched: taprio: Avoid division by zero on invalid link speed

Vladimir Oltean <olteanv@gmail.com>
    net: sched: cbs: Avoid division by zero when calculating the port rate

Lorenzo Bianconi <lorenzo@kernel.org>
    net: socionext: netsec: always grab descriptor lock

Navid Emamdoost <navid.emamdoost@gmail.com>
    net: dsa: sja1105: Prevent leaking memory

Vladimir Oltean <olteanv@gmail.com>
    net: dsa: sja1105: Ensure PTP time for rxtstamp reconstruction is not in the past

Vladimir Oltean <olteanv@gmail.com>
    ptp_qoriq: Initialize the registers' spinlock before calling ptp_qoriq_settime

Vladimir Oltean <olteanv@gmail.com>
    net: dsa: sja1105: Fix sleeping while atomic in .port_hwtstamp_set

Dongli Zhang <dongli.zhang@oracle.com>
    xen-netfront: do not use ~0U as error return value for xennet_fill_frags()

Vladimir Oltean <olteanv@gmail.com>
    net: dsa: sja1105: Initialize the meta_lock

Dotan Barak <dotanb@dev.mellanox.co.il>
    net/rds: Fix error handling in rds_ib_add_one()

Josh Hunt <johunt@akamai.com>
    udp: only do GSO if # of segs > 1

Eric Dumazet <edumazet@google.com>
    tcp: adjust rto_base in retransmits_timed_out()

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Check VLAN ID and not ports

Dexuan Cui <decui@microsoft.com>
    vsock: Fix a lockdep warning in __vsock_release()

Josh Hunt <johunt@akamai.com>
    udp: fix gso_segs calculations

Tuong Lien <tuong.t.lien@dektech.com.au>
    tipc: fix unlimited bundling of small messages

Eric Dumazet <edumazet@google.com>
    sch_dsmark: fix potential NULL deref in dsmark_init()

Eric Dumazet <edumazet@google.com>
    sch_cbq: validate TCA_CBQ_WRROPT to avoid crash

David Howells <dhowells@redhat.com>
    rxrpc: Fix rxrpc_recvmsg tracepoint

Reinhard Speyerer <rspmn@arcor.de>
    qmi_wwan: add support for Cinterion CLS8 devices

Eric Dumazet <edumazet@google.com>
    nfc: fix memory leak in llcp_sock_bind()

Martin KaFai Lau <kafai@fb.com>
    net: Unpublish sk from sk_reuseport_cb before call_rcu

Vladimir Oltean <olteanv@gmail.com>
    net: sched: taprio: Fix potential integer overflow in taprio_set_picos_per_byte

Navid Emamdoost <navid.emamdoost@gmail.com>
    net: qlogic: Fix memory leak in ql_alloc_large_buffers

Paolo Abeni <pabeni@redhat.com>
    net: ipv4: avoid mixed n_redirects and rate_tokens usage

David Ahern <dsahern@gmail.com>
    ipv6: Handle missing host route in __ipv6_ifa_notify

Eric Dumazet <edumazet@google.com>
    ipv6: drop incoming packets having a v4mapped source address

Johan Hovold <johan@kernel.org>
    hso: fix NULL-deref on tty open

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    erspan: remove the incorrect mtu limit for erspan

Vishal Kulkarni <vishal@chelsio.com>
    cxgb4:Fix out-of-bounds MSI-X info array access

Alexandre Ghiti <alex@ghiti.fr>
    arm: use STACK_TOP when computing mmap base address

Alexandre Ghiti <alex@ghiti.fr>
    arm: properly account for stack randomization and stack guard gap

Alexandre Ghiti <alex@ghiti.fr>
    mips: properly account for stack randomization and stack guard gap

Alexandre Ghiti <alex@ghiti.fr>
    arm64: consider stack randomization for mmap base only when necessary

Nicolas Boichat <drinkcat@chromium.org>
    kmemleak: increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE default to 16K

Changwei Ge <gechangwei@live.cn>
    ocfs2: wait for recovering done after direct unlock request

Greg Thelen <gthelen@google.com>
    kbuild: clean compressed initramfs image

Arnd Bergmann <arnd@arndb.de>
    mm: add dummy can_do_mlock() helper

Yunfeng Ye <yeyunfeng@huawei.com>
    crypto: hisilicon - Fix double free in sec_free_hw_sgl()

Youquan Song <youquan.song@intel.com>
    tools/power/x86/intel-speed-select: Fix high priority core mask over count

David Howells <dhowells@redhat.com>
    hypfs: Fix error number left in struct pointer member

Jens Axboe <axboe@kernel.dk>
    pktcdvd: remove warning on attempting to register non-passthrough dev

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: work around race with userspace's read via blockdev while mounting

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: push up injection only after setting service time

Jon Hunter <jonathanh@nvidia.com>
    i2c: tegra: Move suspend handling to NOIRQ phase

Mike Rapoport <mike.rapoport@gmail.com>
    ARM: 8903/1: ensure that usable memory in bank 0 starts from a PMD-aligned address

Nathan Chancellor <natechancellor@gmail.com>
    ARM: 8905/1: Emit __gnu_mcount_nc when using Clang 10.0.0 or newer

Krzysztof Wilczynski <kw@linux.com>
    PCI: Use static const struct, not const static struct

Jia-Ju Bai <baijiaju1990@gmail.com>
    security: smack: Fix possible null-pointer dereferences in smack_socket_sock_rcv_skb()

Thierry Reding <treding@nvidia.com>
    PCI: exynos: Propagate errors for optional PHYs

Thierry Reding <treding@nvidia.com>
    PCI: imx6: Propagate errors for optional regulators

Thierry Reding <treding@nvidia.com>
    PCI: histb: Propagate errors for optional regulators

Thierry Reding <treding@nvidia.com>
    PCI: rockchip: Propagate errors for optional regulators

Joao Moreno <mail@joaomoreno.com>
    HID: apple: Fix stuck function keys when using FN

Krzysztof Wilczynski <kw@linux.com>
    PCI: Add pci_info_ratelimited() to ratelimit PCI separately

Stephen Smalley <sds@tycho.nsa.gov>
    selinux: fix residual uses of current_security() for the SELinux blob

Romain Izard <romain.izard.pro@gmail.com>
    power: supply: register HWMON devices with valid names

Biwen Li <biwen.li@nxp.com>
    rtc: pcf85363/pcf85263: fix regmap error in set_time

Anson Huang <Anson.Huang@nxp.com>
    rtc: snvs: fix possible race condition

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 8875/1: Kconfig: default to AEABI w/ Clang

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: mobiveil: Fix the CPU base address setup in inbound window

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: intel: fix channel number reported by hardware

Will Deacon <will@kernel.org>
    ARM: 8898/1: mm: Don't treat faults reported from cache maintenance as writes

Peter Zijlstra <peterz@infradead.org>
    mips/atomic: Fix smp_mb__{before,after}_atomic()

Miroslav Benes <mbenes@suse.cz>
    livepatch: Nullify obj->mod in klp_module_coming()'s error path

Xiaowei Bao <xiaowei.bao@nxp.com>
    PCI: layerscape: Add the bar_fixed_64bit property to the endpoint driver

Randy Dunlap <rdunlap@infradead.org>
    PCI: pci-hyperv: Fix build errors on non-SYSFS config

Peter Zijlstra <peterz@infradead.org>
    mips/atomic: Fix loongson_llsc_mb() wreckage

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    rtc: bd70528: fix driver dependencies

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Fix several minor compiler warnings

Nishka Dasgupta <nishkadg.linux@gmail.com>
    PCI: tegra: Fix OF node reference leak

Kai-Heng Feng <kai.heng.feng@canonical.com>
    mfd: intel-lpss: Remove D3cold delay

Hans de Goede <hdegoede@redhat.com>
    i2c-cht-wc: Fix lockdep warning

Nathan Chancellor <natechancellor@gmail.com>
    MIPS: tlbex: Explicitly cast _PAGE_NO_EXEC to a boolean

Nathan Chancellor <natechancellor@gmail.com>
    MIPS: Don't use bc_false uninitialized in __mm_isBranchInstr

Zhou Yanjie <zhouyanjie@zoho.com>
    MIPS: Ingenic: Disable broken BTB lookup optimization.

zhangyi (F) <yi.zhang@huawei.com>
    ext4: fix potential use after free after remounting with noblock_validity

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to drop meta/node pages during umount

Chris Wilson <chris@chris-wilson.co.uk>
    dma-buf/sw_sync: Synchronize signal vs syncpt free

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Reduce memory required for SCSI logging

Chunyan Zhang <chunyan.zhang@unisoc.com>
    clk: sprd: add missing kfree

Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
    mbox: qcom: add APCS child device for QCS404

Ganesh Goudar <ganeshgr@linux.ibm.com>
    powerpc: dump kernel log before carrying out fadump or kdump

Bjorn Andersson <bjorn.andersson@linaro.org>
    clk: Make clk_bulk_get_all() return a valid "id"

Peng Fan <peng.fan@nxp.com>
    clk: imx: clk-pll14xx: unbypass PLL by default

Peng Fan <peng.fan@nxp.com>
    clk: imx: pll14xx: avoid glitch when set rate

Eugen Hristev <eugen.hristev@microchip.com>
    clk: at91: select parent if main oscillator or bypass is enabled

Arnd Bergmann <arnd@arndb.de>
    arm64: fix unreachable code issue with cmpxchg

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: dir685: Drop spi-cpol from the display

Bibby Hsieh <bibby.hsieh@mediatek.com>
    mailbox: mediatek: cmdq: clear the event in cmdq initial flow

Otto Meier <gf435@gmx.net>
    pinctrl: meson-gxbb: Fix wrong pinning definition for uart_c

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries: correctly track irq state in default idle

Stephen Boyd <swboyd@chromium.org>
    clk: qcom: gcc-sdm845: Use floor ops for sdcc clks

Oliver O'Halloran <oohall@gmail.com>
    powerpc/eeh: Clean up EEH PEs after recovery finishes

Deepa Dinamani <deepa.kernel@gmail.com>
    pstore: fs superblock limits

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/exception: machine check use correct cfar for late handler

Jean Delvare <jdelvare@suse.de>
    drm/amdgpu/si: fix ASIC tests

Nathan Chancellor <natechancellor@gmail.com>
    kbuild: Do not enable -Wimplicit-fallthrough for clang for now

Gustavo Romero <gromero@linux.vnet.ibm.com>
    selftests/powerpc: Retry on host facility unavailable

Yogesh Mohan Marimuthu <yogesh.mohanmarimuthu@amd.com>
    drm/amd/display: fix trigger not generated for freesync

Zi Yu Liao <ziyu.liao@amd.com>
    drm/amd/display: fix MPO HUBP underflow with Scatter Gather

Kevin Wang <kevin1.wang@amd.com>
    drm/amd/powerpaly: fix navi series custom peak level value error

Charlene Liu <charlene.liu@amd.com>
    drm/amd/display: support spdif

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: cpg-mssr: Set GENPD_FLAG_ALWAYS_ON for clock domain

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: mstp: Set GENPD_FLAG_ALWAYS_ON for clock domain

Daniel Drake <drake@endlessm.com>
    pinctrl: amd: disable spurious-firing GPIO IRQs

Mark Menzynski <mmenzyns@redhat.com>
    drm/nouveau/volt: Fix for some cards having 0 maximum voltage

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/kms/tu102-: disable input lut when input is already FP16

Xiaojie Yuan <xiaojie.yuan@amd.com>
    drm/amdgpu/sdma5: fix number of sdma5 trap irq types for navi1x

hexin <hexin.op@gmail.com>
    vfio_pci: Restore original state on release

Sam Bobroff <sbobroff@linux.ibm.com>
    powerpc/eeh: Clear stale EEH_DEV_NO_HANDLER flag

Sowjanya Komatineni <skomatineni@nvidia.com>
    pinctrl: tegra: Fix write barrier placement in pmx_writel

Nicholas Piggin <npiggin@gmail.com>
    powerpc/perf: fix imc allocation failure handling

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/mobility: use cond_resched when updating device tree

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/radix: Fix memory hotplug section page table creation

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/futex: Fix warning: 'oldval' may be used uninitialized in this function

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/ptdump: fix walk_pagetables() address mismatch

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: use device model APIs and serialization during LPM

Cédric Le Goater <clg@kaod.org>
    powerpc/xmon: Check for HV mode when dumping XIVE info from OPAL

Stephen Boyd <sboyd@kernel.org>
    clk: sunxi: Don't call clk_hw_get_name() on a hw that isn't registered

Stephen Boyd <sboyd@kernel.org>
    clk: zx296718: Don't reference clk_init_data after registration

Stephen Boyd <sboyd@kernel.org>
    clk: sprd: Don't reference clk_init_data after registration

Stephen Boyd <sboyd@kernel.org>
    clk: meson: axg-audio: Don't reference clk_init_data after registration

Stephen Boyd <sboyd@kernel.org>
    clk: sirf: Don't reference clk_init_data after registration

Stephen Boyd <sboyd@kernel.org>
    clk: actions: Don't reference clk_init_data after registration

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/powernv/ioda2: Allocate TCE table levels on demand for default DMA window

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Register VUPDATE_NO_LOCK interrupts for DCN2

Lewis Huang <Lewis.Huang@amd.com>
    drm/amd/display: reprogram VM config when system resume

Bayan Zabihiyan <bayan.zabihiyan@amd.com>
    drm/amd/display: Fix frames_to_insert math

Anthony Koo <Anthony.Koo@amd.com>
    drm/amd/display: fix issue where 252-255 values are clipped

Icenowy Zheng <icenowy@aosc.io>
    clk: sunxi-ng: v3s: add missing clock slices for MMC2 module clocks

Paul Cercueil <paul@crapouillou.net>
    clk: ingenic/jz4740: Fix "pll half" divider not read/written properly

Nathan Huckleberry <nhuck@google.com>
    clk: qoriq: Fix -Wunused-const-variable

Corey Minyard <cminyard@mvista.com>
    ipmi_si: Only schedule continuously in the thread in maintenance mode

Alexandre Torgue <alexandre.torgue@st.com>
    pinctrl: stmfx: update pinconf settings

Nathan Chancellor <natechancellor@gmail.com>
    PCI: rpaphp: Avoid a sometimes-uninitialized warning

Abel Vesa <abel.vesa@nxp.com>
    clk: imx8mq: Mark AHB clock as critical

Jia-Ju Bai <baijiaju1990@gmail.com>
    gpu: drm: radeon: Fix a possible null-pointer dereference in radeon_connector_set_property()

KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
    drm/radeon: Fix EEH during kexec

Nathan Chancellor <natechancellor@gmail.com>
    drm/amd/display: Use proper enum conversion functions

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/amdgpu: Fix hard hang for S/G display BOs.

Sean Paul <seanpaul@chromium.org>
    drm/rockchip: Check for fast link training before enabling psr

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/panel: check failure cases in the probe func

Olivier Moysan <olivier.moysan@st.com>
    drm/bridge: sii902x: fix missing reference to mclk clock

Ahmad Fatoum <a.fatoum@pengutronix.de>
    drm/stm: attach gem fence to atomic state

Noralf Trønnes <noralf@tronnes.org>
    drm/tinydrm/Kconfig: drivers: Select BACKLIGHT_CLASS_DEVICE

Marko Kohtala <marko.kohtala@okoko.fi>
    video: ssd1307fb: Start page range at page_offset

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Copy GSL groups when committing a new context

Nikola Cornij <nikola.cornij@amd.com>
    drm/amd/display: Clear FEC_READY shadow register if DPCD write fails

Su Sung Chung <Su.Chung@amd.com>
    drm/amd/display: fix not calling ppsmu to trigger PME

Nikola Cornij <nikola.cornij@amd.com>
    drm/amd/display: Power-gate all DSCs at driver init time

Anthony Koo <anthony.koo@amd.com>
    drm/amd/display: add monitor patch to add T7 delay

Lucas Stach <l.stach@pengutronix.de>
    drm/panel: simple: fix AUO g185han01 horizontal blanking

Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
    drm/vkms: Avoid assigning 0 for possible_crtc

Andrey Smirnov <andrew.smirnov@gmail.com>
    drm/bridge: tc358767: Increase AUX transfer length limit

Linus Walleij <linus.walleij@linaro.org>
    drm/mcde: Fix uninitialized variable

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/vkms: Fix crc worker races


-------------

Diffstat:

 Makefile                                           |  12 +-
 arch/arm/Kconfig                                   |   7 +-
 arch/arm/Makefile                                  |   4 +
 arch/arm/boot/dts/gemini-dlink-dir-685.dts         |   1 -
 arch/arm/mm/fault.c                                |   4 +-
 arch/arm/mm/fault.h                                |   1 +
 arch/arm/mm/mmap.c                                 |  16 +-
 arch/arm/mm/mmu.c                                  |  16 ++
 arch/arm64/include/asm/cmpxchg.h                   |   6 +-
 arch/arm64/mm/mmap.c                               |   6 +-
 arch/mips/include/asm/atomic.h                     |  19 ++-
 arch/mips/include/asm/barrier.h                    |  44 +++--
 arch/mips/include/asm/bitops.h                     |  47 +++--
 arch/mips/include/asm/cmpxchg.h                    |  11 +-
 arch/mips/include/asm/mipsregs.h                   |   4 +
 arch/mips/kernel/branch.c                          |   2 +-
 arch/mips/kernel/cpu-probe.c                       |   7 +
 arch/mips/kernel/syscall.c                         |   1 +
 arch/mips/mm/mmap.c                                |  14 +-
 arch/mips/mm/tlbex.c                               |   2 +-
 arch/powerpc/include/asm/futex.h                   |   3 +-
 arch/powerpc/kernel/eeh_driver.c                   |  47 ++++-
 arch/powerpc/kernel/eeh_event.c                    |   8 +
 arch/powerpc/kernel/eeh_pe.c                       |  23 ++-
 arch/powerpc/kernel/exceptions-64s.S               |   4 +
 arch/powerpc/kernel/rtas.c                         |  11 +-
 arch/powerpc/kernel/traps.c                        |   1 +
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   2 +-
 arch/powerpc/mm/ptdump/ptdump.c                    |   8 +-
 arch/powerpc/perf/imc-pmu.c                        |  29 ++--
 arch/powerpc/platforms/powernv/pci-ioda-tce.c      |  20 +--
 arch/powerpc/platforms/powernv/pci.h               |   2 +-
 arch/powerpc/platforms/pseries/mobility.c          |   9 +
 arch/powerpc/platforms/pseries/setup.c             |   3 +
 arch/powerpc/xmon/xmon.c                           |  17 +-
 arch/s390/hypfs/inode.c                            |   9 +-
 arch/x86/kvm/hyperv.c                              |  12 +-
 block/bfq-iosched.c                                |  12 +-
 drivers/block/pktcdvd.c                            |   1 -
 drivers/char/ipmi/ipmi_si_intf.c                   |  24 ++-
 drivers/clk/actions/owl-common.c                   |   5 +-
 drivers/clk/at91/clk-main.c                        |  10 +-
 drivers/clk/clk-bulk.c                             |   5 +-
 drivers/clk/clk-qoriq.c                            |   2 +-
 drivers/clk/imx/clk-imx8mq.c                       |   3 +-
 drivers/clk/imx/clk-pll14xx.c                      |  27 ++-
 drivers/clk/ingenic/jz4740-cgu.c                   |   9 +-
 drivers/clk/meson/axg-audio.c                      |   7 +-
 drivers/clk/qcom/gcc-sdm845.c                      |   4 +-
 drivers/clk/renesas/clk-mstp.c                     |   3 +-
 drivers/clk/renesas/renesas-cpg-mssr.c             |   3 +-
 drivers/clk/sirf/clk-common.c                      |  12 +-
 drivers/clk/sprd/common.c                          |   5 +-
 drivers/clk/sprd/pll.c                             |   2 +
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c               |   3 +
 drivers/clk/sunxi-ng/ccu_common.c                  |   5 +-
 drivers/clk/zte/clk-zx296718.c                     | 109 ++++++------
 drivers/crypto/hisilicon/sec/sec_algs.c            |  13 +-
 drivers/dma-buf/sw_sync.c                          |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c             |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |   3 +-
 drivers/gpu/drm/amd/amdgpu/si.c                    |   6 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c   |   4 +-
 .../amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c   |   2 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   8 +
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   2 +
 drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c |   4 +
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  17 +-
 drivers/gpu/drm/amd/display/dc/dc_types.h          |   1 +
 drivers/gpu/drm/amd/display/dc/dce/dce_audio.c     |   4 +-
 .../gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c |   3 +-
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c  |   3 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  19 +++
 .../amd/display/dc/irq/dcn20/irq_service_dcn20.c   |  28 +--
 .../drm/amd/display/modules/freesync/freesync.c    |  27 +--
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c         |   4 +
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |   9 +-
 drivers/gpu/drm/bridge/sii902x.c                   |   1 +
 drivers/gpu/drm/bridge/tc358767.c                  |   2 +-
 drivers/gpu/drm/mcde/mcde_drv.c                    |   6 +-
 drivers/gpu/drm/nouveau/dispnv50/wndw.c            |   4 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/volt.c    |   2 +
 .../gpu/drm/panel/panel-raspberrypi-touchscreen.c  |  13 ++
 drivers/gpu/drm/panel/panel-simple.c               |   6 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |   2 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |   8 +
 drivers/gpu/drm/stm/ltdc.c                         |   2 +
 drivers/gpu/drm/tinydrm/Kconfig                    |   8 +-
 drivers/gpu/drm/vkms/vkms_crc.c                    |  27 ++-
 drivers/gpu/drm/vkms/vkms_crtc.c                   |   9 +-
 drivers/gpu/drm/vkms/vkms_drv.c                    |   2 +-
 drivers/gpu/drm/vkms/vkms_drv.h                    |   6 +-
 drivers/gpu/drm/vkms/vkms_output.c                 |   6 +-
 drivers/gpu/drm/vkms/vkms_plane.c                  |   4 +-
 drivers/hid/hid-apple.c                            |  49 +++---
 drivers/hid/wacom_sys.c                            |   7 +-
 drivers/hid/wacom_wac.c                            |   4 +-
 drivers/i2c/busses/i2c-cht-wc.c                    |  46 +++++
 drivers/i2c/busses/i2c-tegra.c                     |  40 +++--
 drivers/mailbox/mtk-cmdq-mailbox.c                 |   5 +
 drivers/mailbox/qcom-apcs-ipc-mailbox.c            |   8 +-
 drivers/md/dm-raid.c                               |  10 +-
 drivers/md/dm-zoned-target.c                       |   2 -
 drivers/mfd/intel-lpss-pci.c                       |   2 +
 drivers/net/dsa/rtl8366.c                          |  11 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |  24 +--
 drivers/net/dsa/sja1105/sja1105_spi.c              |   6 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c     |   9 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |   1 +
 drivers/net/ethernet/socionext/netsec.c            |  30 +---
 drivers/net/usb/hso.c                              |  12 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/xen-netfront.c                         |  17 +-
 drivers/pci/Kconfig                                |   2 +-
 drivers/pci/controller/dwc/pci-exynos.c            |   2 +-
 drivers/pci/controller/dwc/pci-imx6.c              |   4 +-
 drivers/pci/controller/dwc/pci-layerscape-ep.c     |   1 +
 drivers/pci/controller/dwc/pcie-histb.c            |   4 +-
 drivers/pci/controller/pci-tegra.c                 |  22 ++-
 drivers/pci/controller/pcie-mobiveil.c             |  10 +-
 drivers/pci/controller/pcie-rockchip-host.c        |  16 +-
 drivers/pci/hotplug/rpaphp_core.c                  |  18 +-
 drivers/pci/pci-bridge-emul.c                      |   4 +-
 drivers/pci/pci.c                                  |   4 +-
 drivers/pinctrl/meson/pinctrl-meson-gxbb.c         |  12 +-
 drivers/pinctrl/pinctrl-amd.c                      |  12 +-
 drivers/pinctrl/pinctrl-stmfx.c                    |  24 +--
 drivers/pinctrl/tegra/pinctrl-tegra.c              |   4 +-
 drivers/power/supply/power_supply_hwmon.c          |  15 +-
 drivers/ptp/ptp_qoriq.c                            |   3 +-
 drivers/rtc/Kconfig                                |   1 +
 drivers/rtc/rtc-pcf85363.c                         |   7 +-
 drivers/rtc/rtc-snvs.c                             |  11 +-
 drivers/scsi/scsi_logging.c                        |  48 +-----
 drivers/soundwire/intel.c                          |  10 ++
 drivers/vfio/pci/vfio_pci.c                        |  17 +-
 drivers/video/fbdev/ssd1307fb.c                    |   2 +-
 fs/9p/cache.c                                      |   2 +
 fs/ext4/block_validity.c                           | 189 +++++++++++++++------
 fs/ext4/ext4.h                                     |  10 +-
 fs/f2fs/super.c                                    |  14 ++
 fs/fat/dir.c                                       |  13 +-
 fs/fat/fatent.c                                    |   3 +
 fs/fs_context.c                                    |   4 +-
 fs/ocfs2/dlm/dlmunlock.c                           |  23 ++-
 fs/pstore/ram.c                                    |   2 +
 include/linux/dsa/sja1105.h                        |   4 +-
 include/linux/mailbox/mtk-cmdq-mailbox.h           |   3 +
 include/linux/mm.h                                 |   4 +
 include/linux/pci.h                                |   3 +
 include/linux/soc/mediatek/mtk-cmdq.h              |   3 -
 include/scsi/scsi_dbg.h                            |   2 -
 include/trace/events/rxrpc.h                       |   2 +-
 kernel/kexec_core.c                                |   2 +
 kernel/livepatch/core.c                            |   1 +
 lib/Kconfig.debug                                  |   2 +-
 net/core/sock.c                                    |  11 +-
 net/dsa/tag_sja1105.c                              |  12 +-
 net/ipv4/ip_gre.c                                  |   1 +
 net/ipv4/route.c                                   |   5 +-
 net/ipv4/tcp_timer.c                               |   9 +-
 net/ipv4/udp.c                                     |  11 +-
 net/ipv6/addrconf.c                                |  17 +-
 net/ipv6/ip6_input.c                               |  10 ++
 net/ipv6/udp.c                                     |   9 +-
 net/nfc/llcp_sock.c                                |   7 +-
 net/nfc/netlink.c                                  |   6 +-
 net/rds/ib.c                                       |   6 +-
 net/sched/sch_cbq.c                                |  43 +++--
 net/sched/sch_cbs.c                                |   2 +-
 net/sched/sch_dsmark.c                             |   2 +
 net/sched/sch_taprio.c                             |   5 +-
 net/tipc/link.c                                    |  29 ++--
 net/tipc/msg.c                                     |   5 +-
 net/vmw_vsock/af_vsock.c                           |  16 +-
 net/vmw_vsock/hyperv_transport.c                   |   2 +-
 net/vmw_vsock/virtio_transport_common.c            |   2 +-
 security/selinux/hooks.c                           |   2 +-
 security/selinux/include/objsec.h                  |  20 +--
 security/smack/smack_access.c                      |   6 +-
 security/smack/smack_lsm.c                         |   7 +-
 tools/power/x86/intel-speed-select/isst-config.c   |   3 +
 tools/testing/selftests/net/udpgso.c               |  16 +-
 tools/testing/selftests/powerpc/tm/tm.h            |   3 +-
 usr/Makefile                                       |   3 +
 186 files changed, 1372 insertions(+), 695 deletions(-)


