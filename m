Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BA6190FC3
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgCXNW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729420AbgCXNW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:22:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C712A206F6;
        Tue, 24 Mar 2020 13:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056175;
        bh=8N44fSKHs/7fF7wrVWGOSX1QqKu6n2Mdwy8xtHlrHEw=;
        h=From:To:Cc:Subject:Date:From;
        b=t+cPB2bVLBLf/fXbdcXWLtMoatUTpl4x1xBidpHrSLCrUu7oXuaDekvatPtRR4tVe
         LhPXfOZSc/9AyAhlrHPY6UTVAqEXKP+Z9jO0yLKRW4GZ4dYCsruJEFDFfdv+/U9IYR
         hPg2TK+TQi9P8PXqhnwzXdwJ6DnqLC9VscD0qSLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.5 000/119] 5.5.12-rc1 review
Date:   Tue, 24 Mar 2020 14:09:45 +0100
Message-Id: <20200324130808.041360967@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.5.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.5.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.5.12-rc1
X-KernelTest-Deadline: 2020-03-26T13:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.5.12 release.
There are 119 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 26 Mar 2020 13:06:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.5.12-rc1

Masahiro Yamada <masahiroy@kernel.org>
    int128: fix __uint128_t compiler test in Kconfig

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: introduce m32-flag and m64-flag

Johan Hovold <johan@kernel.org>
    staging: greybus: loopback_test: fix potential path truncations

Johan Hovold <johan@kernel.org>
    staging: greybus: loopback_test: fix potential path truncation

Matt Roper <matthew.d.roper@intel.com>
    drm/i915: Handle all MCR ranges

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/execlists: Track active elements during dequeue

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/bridge: dw-hdmi: fix AVI frame colorimetry

Caz Yokoyama <caz.yokoyama@intel.com>
    Revert "drm/i915/tgl: Add extra hdc flush workaround"

Filipe Manana <fdmanana@suse.com>
    btrfs: fix removal of raid[56|1c34} incompat flags after removing block group

Xiao Yang <yangx.jy@cn.fujitsu.com>
    modpost: Get proper section index by get_secindex() instead of st_shndx

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: set MSG_MORE only if we actually have more to send

Cristian Marussi <cristian.marussi@arm.com>
    arm64: smp: fix crash_smp_send_stop() behaviour

Cristian Marussi <cristian.marussi@arm.com>
    arm64: smp: fix smp_send_stop() behaviour

Dan Carpenter <dan.carpenter@oracle.com>
    thunderbolt: Fix error code in tb_port_is_width_supported()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Fix pop noise on ALC225

Thomas Gleixner <tglx@linutronix.de>
    futex: Unbreak futex hashing

Peter Zijlstra <peterz@infradead.org>
    futex: Fix inode life-time issue

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}

Joerg Roedel <jroedel@suse.de>
    x86/mm: split vmalloc_sync_all()

Qian Cai <cai@lca.pw>
    page-flags: fix a crash at SetPageError(THP_SWAP)

Vlastimil Babka <vbabka@suse.cz>
    mm, slub: prevent kmalloc_node crashes and memory leaks

Linus Torvalds <torvalds@linux-foundation.org>
    mm: slub: be more careful about the double cmpxchg of freelist

Roman Penyaev <rpenyaev@suse.de>
    epoll: fix possible lost wakeup on epoll_ctl() path

Michal Hocko <mhocko@suse.com>
    mm: do not allow MADV_PAGEOUT for CoW pages

Baoquan He <bhe@redhat.com>
    mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case

Chris Down <chris@chrisdown.name>
    mm, memcg: throttle allocators based on ancestral memory.high

Chris Down <chris@chrisdown.name>
    mm, memcg: fix corruption on 64-bit divisor in memory.high throttling

Chunguang Xu <brookxu@tencent.com>
    memcg: fix NULL pointer dereference in __mem_cgroup_usage_unregister_event

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    stm class: sys-t: Fix the use of time_after()

Qiujun Huang <hqjagain@gmail.com>
    drm/lease: fix WARNING in idr_destroy

Tom St Denis <tom.stdenis@amd.com>
    drm/amd/amdgpu: Fix GPR read from debugfs (v2)

Filipe Manana <fdmanana@suse.com>
    btrfs: fix log context list corruption after rename whiteout error

Steven Rostedt (VMware) <rostedt@goodmis.org>
    xhci: Do not open code __print_symbolic() in xhci trace events

Vincenzo Frascino <vincenzo.frascino@arm.com>
    arm64: compat: Fix syscall number of compat_clock_getres

Corentin Labbe <clabbe@baylibre.com>
    rtc: max8907: add missing select REGMAP_IRQ

Jessica Yu <jeyu@kernel.org>
    modpost: move the namespace field in Module.symvers last

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Elkhart Lake CPU support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: Fix user-visible error codes

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: msu: Fix the unexpected state warning

Samuel Thibault <samuel.thibault@ens-lyon.org>
    staging/speakup: fix get_word non-space look-ahead

Johan Hovold <johan@kernel.org>
    staging: greybus: loopback_test: fix poll-mask build breakage

Michael Straube <straube.linux@gmail.com>
    staging: rtl8188eu: Add device id for MERCUSYS MW150US v2

Nathan Chancellor <natechancellor@gmail.com>
    kbuild: Disable -Wpointer-to-enum-cast

Murphy Zhou <jencce.kernel@gmail.com>
    CIFS: fiemap: do not return EINVAL if get nothing

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-acpi: Disable write protect detection on Acer Aspire Switch 10 (SW5-012)

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-acpi: Switch signal voltage back to 3.3V on suspend on external microSD on Lenovo Miix 320

Masahiro Yamada <yamada.masahiro@socionext.com>
    mmc: sdhci-cadence: set SDHCI_QUIRK2_PRESET_VALUE_BROKEN for UniPhier

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    mmc: sdhci-of-at91: fix cd-gpios for SAMA5D2

Ricky Wu <ricky_wu@realtek.com>
    mmc: rtsx_pci: Fix support for speed-modes that relies on tuning

Tomas Novotny <tomas@novotny.cz>
    iio: light: vcnl4000: update sampling periods for vcnl4040

Tomas Novotny <tomas@novotny.cz>
    iio: light: vcnl4000: update sampling periods for vcnl4200

Eugen Hristev <eugen.hristev@microchip.com>
    iio: adc: at91-sama5d2_adc: fix differential channels in triggered mode

Olivier Moysan <olivier.moysan@st.com>
    iio: adc: stm32-dfsdm: fix sleep in atomic context

Stephan Gerhold <stephan@gerhold.net>
    iio: magnetometer: ak8974: Fix negative raw values in sysfs

Alexandru Tachici <alexandru.tachici@analog.com>
    iio: accel: adxl372: Set iio_chan BE

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: trigger: stm32-timer: disable master mode when stopping

Wen-chien Jesse Sung <jesse.sung@canonical.com>
    iio: st_sensors: remap SMO8840 to LIS2DH12

Petr Štetiar <ynezz@true.cz>
    iio: chemical: sps30: fix missing triggered buffer dependency

Eric Biggers <ebiggers@google.com>
    tty: fix compat TIOCGSERIAL checking wrong function ptr

Eric Biggers <ebiggers@google.com>
    tty: fix compat TIOCGSERIAL leaking uninitialized memory

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Remove WARNING from snd_pcm_plug_alloc() checks

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Avoid plugin buffer overflow

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix running status after receiving sysex

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: virmidi: Fix running status after receiving sysex

Jian-Hong Pan <jian-hong@endlessm.com>
    ALSA: hda/realtek - Enable the headset of Acer N50-600 with ALC662

Jian-Hong Pan <jian-hong@endlessm.com>
    ALSA: hda/realtek - Enable headset mic of Acer X2660G with ALC662

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix endless MIDI read loop

Anthony Mallet <anthony.mallet@laas.fr>
    USB: cdc-acm: fix rounding error in TIOCSSERIAL

Anthony Mallet <anthony.mallet@laas.fr>
    USB: cdc-acm: fix close_delay and closing_wait units in TIOCSSERIAL

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: displayport: Fix a potential race during registration

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: displayport: Fix NULL pointer dereference

Alberto Mattea <alberto@mattea.info>
    usb: xhci: apply XHCI_SUSPEND_DELAY to AMD XHCI controller 1022:145c

Scott Chen <scott@labau.com.tw>
    USB: serial: pl2303: add device-id for HP LD381

Ran Wang <ran.wang_1@nxp.com>
    usb: host: xhci-plat: add a shutdown

Peter Chen <peter.chen@nxp.com>
    usb: chipidea: udc: fix sleeping function called from invalid context

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add ME910G1 ECM composition 0x110b

Hans de Goede <hdegoede@redhat.com>
    usb: quirks: add NO_LPM quirk for RTL8153 based ethernet adapters

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: Disable LPM on WD19's Realtek Hub

Sasha Levin <sashal@kernel.org>
    Revert "drm/fbdev: Fallback to non tiled mode if all tiles not present"

Christian Brauner <christian.brauner@ubuntu.com>
    binderfs: use refcount for binder control devices too

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix lockup with timeouts

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    parse-maintainers: Mark as executable

Tycho Andersen <tycho@tycho.ws>
    riscv: fix seccomp reject syscall code path

Dongli Zhang <dongli.zhang@oracle.com>
    xenbus: req->err should be updated before req->state

Dongli Zhang <dongli.zhang@oracle.com>
    xenbus: req->body should be updated before req->state

Josip Pavic <Josip.Pavic@amd.com>
    drm/amd/display: fix dcc swath size calculations on dcn1

Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
    drm/amd/display: Clear link settings on MST disable connector

Yintian Tao <yttao@amd.com>
    drm/amdgpu: clean wptr on wb when gpu recovery

Alexandre Ghiti <alex@ghiti.fr>
    riscv: Fix range looking for kernel image memblock

Damien Le Moal <damien.lemoal@wdc.com>
    riscv: Force flat memory model with no-mmu

Aaro Koskinen <aaro.koskinen@nokia.com>
    spi: spi_register_controller(): free bus id on error paths

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: sai: manage rebind issue

Vincent Chen <vincent.chen@sifive.com>
    riscv: avoid the PIC offset of static percpu data in module beyond 2G limits

Mike Snitzer <snitzer@redhat.com>
    dm integrity: use dm_bio_record and dm_bio_restore

Mike Snitzer <snitzer@redhat.com>
    dm bio record: save/restore bi_end_io and bi_integrity

Daniel Axtens <dja@axtens.net>
    altera-stapl: altera_get_note: prevent write beyond end of 'key'

Stefan Wahren <stefan.wahren@i2se.com>
    ARM: bcm2835_defconfig: Explicitly restore CONFIG_DEBUG_FS

Pavel Begunkov <asml.silence@gmail.com>
    io-wq: fix IO_WQ_WORK_NO_CANCEL cancellation

luanshi <zhangliguang@linux.alibaba.com>
    drivers/perf: arm_pmu_acpi: Fix incorrect checking of gicc pointer

Joakim Zhang <qiangqing.zhang@nxp.com>
    drivers/perf: fsl_imx8_ddr: Correct the CLEAR bit definition

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: hdmi: don't leak enable HDMI_EN regulator if probe fails

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: dsi: fix workaround for the legacy clock name

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: dsi: propagate error value and silence meaningless warning

Stefan Wahren <stefan.wahren@i2se.com>
    ARM: dts: bcm283x: Add missing properties to the PWR LED

Thommy Jakobsson <thommyj@gmail.com>
    spi/zynqmp: remove entry that causes a cs glitch

Evan Green <evgreen@chromium.org>
    spi: pxa2xx: Add CS control clock quirk

Kishon Vijay Abraham I <kishon@ti.com>
    ARM: dts: dra7: Add "dma-ranges" property to PCIe RC DT nodes

Steve French <stfrench@microsoft.com>
    cifs: add missing mount option to /proc/mounts

Paulo Alcantara (SUSE) <pc@cjr.nz>
    cifs: fix potential mismatch of UNC paths

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc: Include .BTF section

Yuji Sasaki <sasakiy@chromium.org>
    spi: qup: call spi_qup_pm_resume_runtime before suspending

Grygorii Strashko <grygorii.strashko@ti.com>
    ARM: dts: dra7-l4: mark timer13-16 as pwm capable

Grygorii Strashko <grygorii.strashko@ti.com>
    phy: ti: gmii-sel: do not fail in case of gmii

Grygorii Strashko <grygorii.strashko@ti.com>
    phy: ti: gmii-sel: fix set of copy-paste errors

Sean Paul <seanpaul@chromium.org>
    drm/mediatek: Ensure the cursor plane is on top of other overlays

Evan Benn <evanbenn@chromium.org>
    drm/mediatek: Find the cursor plane instead of hard coding it

Vignesh Raghavendra <vigneshr@ti.com>
    spi: spi-omap2-mcspi: Support probe deferral for DMA channels

Linus Torvalds <torvalds@linux-foundation.org>
    locks: reinstate locks_delete_block optimization

yangerkun <yangerkun@huawei.com>
    locks: fix a potential use-after-free problem when wakeup a waiter


-------------

Diffstat:

 Documentation/kbuild/modules.rst                   |   4 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts              |   2 +
 arch/arm/boot/dts/bcm2837-rpi-3-a-plus.dts         |   2 +
 arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts         |   2 +
 arch/arm/boot/dts/dra7-l4.dtsi                     |   4 +
 arch/arm/boot/dts/dra7.dtsi                        |   2 +
 arch/arm/configs/bcm2835_defconfig                 |   1 +
 arch/arm64/include/asm/unistd.h                    |   2 +-
 arch/arm64/kernel/smp.c                            |  25 ++++-
 arch/powerpc/kernel/vmlinux.lds.S                  |   6 ++
 arch/riscv/Kconfig                                 |   1 +
 arch/riscv/include/asm/syscall.h                   |   7 --
 arch/riscv/kernel/entry.S                          |  11 +--
 arch/riscv/kernel/module.c                         |  16 ++++
 arch/riscv/kernel/ptrace.c                         |  11 +--
 arch/riscv/mm/init.c                               |   2 +-
 arch/x86/mm/fault.c                                |  26 +++++-
 drivers/acpi/apei/ghes.c                           |   2 +-
 drivers/android/binderfs.c                         |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   1 +
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   1 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   1 +
 .../gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c    |   4 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |  46 +++++----
 drivers/gpu/drm/drm_client_modeset.c               |  72 --------------
 drivers/gpu/drm/drm_lease.c                        |   3 +-
 drivers/gpu/drm/exynos/exynos_drm_dsi.c            |  12 ++-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  22 +++--
 drivers/gpu/drm/i915/gt/intel_lrc.c                |  52 +++--------
 drivers/gpu/drm/i915/gt/intel_workarounds.c        |  25 ++++-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |  26 ++++--
 drivers/hwtracing/intel_th/msu.c                   |  13 +--
 drivers/hwtracing/intel_th/pci.c                   |   5 +
 drivers/hwtracing/stm/p_sys-t.c                    |   6 +-
 drivers/iio/accel/adxl372.c                        |   1 +
 drivers/iio/accel/st_accel_i2c.c                   |   2 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |  15 +++
 drivers/iio/adc/stm32-dfsdm-adc.c                  |  43 ++-------
 drivers/iio/chemical/Kconfig                       |   2 +
 drivers/iio/light/vcnl4000.c                       |  15 +--
 drivers/iio/magnetometer/ak8974.c                  |   2 +-
 drivers/iio/trigger/stm32-timer-trigger.c          |  11 ++-
 drivers/md/dm-bio-record.h                         |  15 +++
 drivers/md/dm-integrity.c                          |  32 ++-----
 drivers/misc/altera-stapl/altera.c                 |  12 +--
 drivers/misc/cardreader/rts5227.c                  |   2 +-
 drivers/misc/cardreader/rts5249.c                  |   2 +
 drivers/misc/cardreader/rts5260.c                  |   2 +-
 drivers/misc/cardreader/rts5261.c                  |   2 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |  13 ++-
 drivers/mmc/host/sdhci-acpi.c                      |  84 ++++++++++++++++-
 drivers/mmc/host/sdhci-cadence.c                   |  18 +++-
 drivers/mmc/host/sdhci-of-at91.c                   |   8 +-
 drivers/nvme/target/tcp.c                          |  12 ++-
 drivers/perf/arm_pmu_acpi.c                        |   7 +-
 drivers/perf/fsl_imx8_ddr_perf.c                   |  10 +-
 drivers/phy/ti/phy-gmii-sel.c                      |  10 +-
 drivers/rtc/Kconfig                                |   1 +
 drivers/spi/spi-omap2-mcspi.c                      |  77 ++++++++-------
 drivers/spi/spi-pxa2xx.c                           |  23 +++++
 drivers/spi/spi-qup.c                              |  11 ++-
 drivers/spi/spi-zynqmp-gqspi.c                     |   3 -
 drivers/spi/spi.c                                  |  32 +++----
 drivers/staging/greybus/tools/loopback_test.c      |  21 +++--
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   1 +
 drivers/staging/speakup/main.c                     |   2 +-
 drivers/thunderbolt/switch.c                       |   2 +-
 drivers/tty/tty_io.c                               |   6 +-
 drivers/usb/chipidea/udc.c                         |   7 +-
 drivers/usb/class/cdc-acm.c                        |  34 ++++---
 drivers/usb/core/quirks.c                          |   6 ++
 drivers/usb/host/xhci-pci.c                        |   3 +-
 drivers/usb/host/xhci-plat.c                       |   1 +
 drivers/usb/host/xhci-trace.h                      |  23 ++---
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/serial/pl2303.c                        |   1 +
 drivers/usb/serial/pl2303.h                        |   1 +
 drivers/usb/typec/ucsi/displayport.c               |  12 ++-
 drivers/xen/xenbus/xenbus_comms.c                  |   4 +
 drivers/xen/xenbus/xenbus_xs.c                     |   9 +-
 fs/btrfs/block-group.c                             |   4 +-
 fs/btrfs/inode.c                                   |   4 +
 fs/cifs/cifs_dfs_ref.c                             |   2 +
 fs/cifs/cifsfs.c                                   |   2 +
 fs/cifs/file.c                                     |   3 +-
 fs/cifs/smb2ops.c                                  |   2 +-
 fs/eventpoll.c                                     |   8 +-
 fs/inode.c                                         |   1 +
 fs/io-wq.c                                         |  20 ++--
 fs/io_uring.c                                      |   9 ++
 fs/locks.c                                         |  60 ++++++++----
 include/linux/fs.h                                 |   1 +
 include/linux/futex.h                              |  17 ++--
 include/linux/page-flags.h                         |   2 +-
 include/linux/vmalloc.h                            |   5 +-
 init/Kconfig                                       |   3 +-
 kernel/futex.c                                     |  93 +++++++++++--------
 kernel/notifier.c                                  |   2 +-
 mm/madvise.c                                       |  12 ++-
 mm/memcontrol.c                                    | 103 +++++++++++++--------
 mm/nommu.c                                         |  10 +-
 mm/slub.c                                          |  32 ++++---
 mm/sparse.c                                        |   8 +-
 mm/vmalloc.c                                       |  11 ++-
 scripts/Kconfig.include                            |   7 ++
 scripts/Makefile.extrawarn                         |   1 +
 scripts/export_report.pl                           |   2 +-
 scripts/mod/modpost.c                              |  27 +++---
 scripts/parse-maintainers.pl                       |   0
 sound/core/oss/pcm_plugin.c                        |  12 ++-
 sound/core/seq/oss/seq_oss_midi.c                  |   1 +
 sound/core/seq/seq_virmidi.c                       |   1 +
 sound/pci/hda/patch_realtek.c                      |  25 +++++
 sound/soc/stm/stm32_sai_sub.c                      |  18 ++--
 sound/usb/line6/driver.c                           |   2 +-
 sound/usb/line6/midibuf.c                          |   2 +-
 118 files changed, 945 insertions(+), 595 deletions(-)


