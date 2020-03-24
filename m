Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26393190E6C
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgCXNMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbgCXNMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:12:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35C05208CA;
        Tue, 24 Mar 2020 13:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055526;
        bh=b8sF1DJoj4+NblVqbuuh1qjtIfhscqNcyDJmdizSDa4=;
        h=From:To:Cc:Subject:Date:From;
        b=ptDXWWyVPW+3nYuulzeGmqZ7/I2hAeOHqKHP5ZRktnkl3oyJhnxETM/BUYF2bxlIH
         62xJfHAswZEIkBT+7Ju86N0ccVMcAO2s1NvYlyOpW+APhE3uUf3O04WpzEy2dvsrTu
         T4GKr4VgSdbq2xHqMi4yPIo3dcHzbZOEwvUnQ3io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/65] 4.19.113-rc1 review
Date:   Tue, 24 Mar 2020 14:10:21 +0100
Message-Id: <20200324130756.679112147@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.113-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.113-rc1
X-KernelTest-Deadline: 2020-03-26T13:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.113 release.
There are 65 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 26 Mar 2020 13:06:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.113-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.113-rc1

Johan Hovold <johan@kernel.org>
    staging: greybus: loopback_test: fix potential path truncations

Johan Hovold <johan@kernel.org>
    staging: greybus: loopback_test: fix potential path truncation

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/bridge: dw-hdmi: fix AVI frame colorimetry

Cristian Marussi <cristian.marussi@arm.com>
    arm64: smp: fix crash_smp_send_stop() behaviour

Cristian Marussi <cristian.marussi@arm.com>
    arm64: smp: fix smp_send_stop() behaviour

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Fix pop noise on ALC225

Sasha Levin <sashal@kernel.org>
    Revert "ipv6: Fix handling of LLA with VRF and sockets bound to VRF"

Sasha Levin <sashal@kernel.org>
    Revert "vrf: mark skb for multicast or link-local as enslaved to VRF"

Thomas Gleixner <tglx@linutronix.de>
    futex: Unbreak futex hashing

Peter Zijlstra <peterz@infradead.org>
    futex: Fix inode life-time issue

Nathan Chancellor <natechancellor@gmail.com>
    kbuild: Disable -Wpointer-to-enum-cast

Tomas Novotny <tomas@novotny.cz>
    iio: light: vcnl4000: update sampling periods for vcnl4200

Anthony Mallet <anthony.mallet@laas.fr>
    USB: cdc-acm: fix rounding error in TIOCSSERIAL

Anthony Mallet <anthony.mallet@laas.fr>
    USB: cdc-acm: fix close_delay and closing_wait units in TIOCSSERIAL

Joerg Roedel <jroedel@suse.de>
    x86/mm: split vmalloc_sync_all()

Qian Cai <cai@lca.pw>
    page-flags: fix a crash at SetPageError(THP_SWAP)

Vlastimil Babka <vbabka@suse.cz>
    mm, slub: prevent kmalloc_node crashes and memory leaks

Linus Torvalds <torvalds@linux-foundation.org>
    mm: slub: be more careful about the double cmpxchg of freelist

Chunguang Xu <brookxu@tencent.com>
    memcg: fix NULL pointer dereference in __mem_cgroup_usage_unregister_event

Qiujun Huang <hqjagain@gmail.com>
    drm/lease: fix WARNING in idr_destroy

Tom St Denis <tom.stdenis@amd.com>
    drm/amd/amdgpu: Fix GPR read from debugfs (v2)

Filipe Manana <fdmanana@suse.com>
    btrfs: fix log context list corruption after rename whiteout error

Steven Rostedt (VMware) <rostedt@goodmis.org>
    xhci: Do not open code __print_symbolic() in xhci trace events

Corentin Labbe <clabbe@baylibre.com>
    rtc: max8907: add missing select REGMAP_IRQ

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Elkhart Lake CPU support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: Fix user-visible error codes

Samuel Thibault <samuel.thibault@ens-lyon.org>
    staging/speakup: fix get_word non-space look-ahead

Johan Hovold <johan@kernel.org>
    staging: greybus: loopback_test: fix poll-mask build breakage

Michael Straube <straube.linux@gmail.com>
    staging: rtl8188eu: Add device id for MERCUSYS MW150US v2

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    mmc: sdhci-of-at91: fix cd-gpios for SAMA5D2

Ricky Wu <ricky_wu@realtek.com>
    mmc: rtsx_pci: Fix support for speed-modes that relies on tuning

Eugen Hristev <eugen.hristev@microchip.com>
    iio: adc: at91-sama5d2_adc: fix differential channels in triggered mode

Stephan Gerhold <stephan@gerhold.net>
    iio: magnetometer: ak8974: Fix negative raw values in sysfs

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: trigger: stm32-timer: disable master mode when stopping

Wen-chien Jesse Sung <jesse.sung@canonical.com>
    iio: st_sensors: remap SMO8840 to LIS2DH12

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Remove WARNING from snd_pcm_plug_alloc() checks

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Avoid plugin buffer overflow

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix running status after receiving sysex

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: virmidi: Fix running status after receiving sysex

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix endless MIDI read loop

Alberto Mattea <alberto@mattea.info>
    usb: xhci: apply XHCI_SUSPEND_DELAY to AMD XHCI controller 1022:145c

Scott Chen <scott@labau.com.tw>
    USB: serial: pl2303: add device-id for HP LD381

Ran Wang <ran.wang_1@nxp.com>
    usb: host: xhci-plat: add a shutdown

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add ME910G1 ECM composition 0x110b

Hans de Goede <hdegoede@redhat.com>
    usb: quirks: add NO_LPM quirk for RTL8153 based ethernet adapters

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: Disable LPM on WD19's Realtek Hub

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    parse-maintainers: Mark as executable

Carlo Nonato <carlo.nonato95@gmail.com>
    block, bfq: fix overwrite of bfq_group pointer in bfq_find_set_group()

Dongli Zhang <dongli.zhang@oracle.com>
    xenbus: req->err should be updated before req->state

Dongli Zhang <dongli.zhang@oracle.com>
    xenbus: req->body should be updated before req->state

Josip Pavic <Josip.Pavic@amd.com>
    drm/amd/display: fix dcc swath size calculations on dcn1

Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
    drm/amd/display: Clear link settings on MST disable connector

Vincent Chen <vincent.chen@sifive.com>
    riscv: avoid the PIC offset of static percpu data in module beyond 2G limits

Mike Snitzer <snitzer@redhat.com>
    dm integrity: use dm_bio_record and dm_bio_restore

Mike Snitzer <snitzer@redhat.com>
    dm bio record: save/restore bi_end_io and bi_integrity

Daniel Axtens <dja@axtens.net>
    altera-stapl: altera_get_note: prevent write beyond end of 'key'

luanshi <zhangliguang@linux.alibaba.com>
    drivers/perf: arm_pmu_acpi: Fix incorrect checking of gicc pointer

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: dsi: fix workaround for the legacy clock name

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: dsi: propagate error value and silence meaningless warning

Thommy Jakobsson <thommyj@gmail.com>
    spi/zynqmp: remove entry that causes a cs glitch

Evan Green <evgreen@chromium.org>
    spi: pxa2xx: Add CS control clock quirk

Kishon Vijay Abraham I <kishon@ti.com>
    ARM: dts: dra7: Add "dma-ranges" property to PCIe RC DT nodes

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc: Include .BTF section

Yuji Sasaki <sasakiy@chromium.org>
    spi: qup: call spi_qup_pm_resume_runtime before suspending

Evan Benn <evanbenn@chromium.org>
    drm/mediatek: Find the cursor plane instead of hard coding it


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/dra7.dtsi                        |  2 +
 arch/arm64/kernel/smp.c                            | 25 ++++--
 arch/powerpc/kernel/vmlinux.lds.S                  |  6 ++
 arch/riscv/kernel/module.c                         | 16 ++++
 arch/x86/mm/fault.c                                | 26 +++++-
 block/bfq-cgroup.c                                 |  9 ++-
 drivers/acpi/apei/ghes.c                           |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |  6 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  1 +
 .../gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c    |  4 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          | 46 ++++++-----
 drivers/gpu/drm/drm_lease.c                        |  3 +-
 drivers/gpu/drm/exynos/exynos_drm_dsi.c            | 12 +--
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            | 18 +++--
 drivers/hwtracing/intel_th/msu.c                   |  6 +-
 drivers/hwtracing/intel_th/pci.c                   |  5 ++
 drivers/iio/accel/st_accel_i2c.c                   |  2 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 | 15 ++++
 drivers/iio/light/vcnl4000.c                       |  7 +-
 drivers/iio/magnetometer/ak8974.c                  |  2 +-
 drivers/iio/trigger/stm32-timer-trigger.c          | 11 ++-
 drivers/md/dm-bio-record.h                         | 15 ++++
 drivers/md/dm-integrity.c                          | 32 +++-----
 drivers/misc/altera-stapl/altera.c                 | 12 +--
 drivers/misc/cardreader/rts5227.c                  |  2 +-
 drivers/misc/cardreader/rts5249.c                  |  2 +
 drivers/misc/cardreader/rts5260.c                  |  2 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  | 13 +--
 drivers/mmc/host/sdhci-of-at91.c                   |  8 +-
 drivers/net/vrf.c                                  | 19 ++---
 drivers/perf/arm_pmu_acpi.c                        |  7 +-
 drivers/rtc/Kconfig                                |  1 +
 drivers/spi/spi-pxa2xx.c                           | 23 ++++++
 drivers/spi/spi-qup.c                              | 11 ++-
 drivers/spi/spi-zynqmp-gqspi.c                     |  3 -
 drivers/staging/greybus/tools/loopback_test.c      | 21 ++---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |  1 +
 drivers/staging/speakup/main.c                     |  2 +-
 drivers/usb/class/cdc-acm.c                        | 34 +++++---
 drivers/usb/core/quirks.c                          |  6 ++
 drivers/usb/host/xhci-pci.c                        |  3 +-
 drivers/usb/host/xhci-plat.c                       |  1 +
 drivers/usb/host/xhci-trace.h                      | 23 ++----
 drivers/usb/serial/option.c                        |  2 +
 drivers/usb/serial/pl2303.c                        |  1 +
 drivers/usb/serial/pl2303.h                        |  1 +
 drivers/xen/xenbus/xenbus_comms.c                  |  4 +
 drivers/xen/xenbus/xenbus_xs.c                     |  9 ++-
 fs/btrfs/inode.c                                   |  4 +
 fs/inode.c                                         |  1 +
 include/linux/fs.h                                 |  1 +
 include/linux/futex.h                              | 17 ++--
 include/linux/page-flags.h                         |  2 +-
 include/linux/vmalloc.h                            |  5 +-
 kernel/futex.c                                     | 93 +++++++++++++---------
 kernel/notifier.c                                  |  2 +-
 mm/memcontrol.c                                    | 10 ++-
 mm/nommu.c                                         | 10 ++-
 mm/slub.c                                          | 32 +++++---
 mm/vmalloc.c                                       | 11 ++-
 net/ipv6/tcp_ipv6.c                                |  3 +-
 scripts/Makefile.extrawarn                         |  1 +
 scripts/parse-maintainers.pl                       |  0
 sound/core/oss/pcm_plugin.c                        | 12 ++-
 sound/core/seq/oss/seq_oss_midi.c                  |  1 +
 sound/core/seq/seq_virmidi.c                       |  1 +
 sound/pci/hda/patch_realtek.c                      |  2 +
 sound/usb/line6/driver.c                           |  2 +-
 sound/usb/line6/midibuf.c                          |  2 +-
 70 files changed, 458 insertions(+), 240 deletions(-)


