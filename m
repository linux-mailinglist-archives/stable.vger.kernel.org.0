Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC6962391
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732569AbfGHPct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390201AbfGHPcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:32:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E514721743;
        Mon,  8 Jul 2019 15:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599966;
        bh=+9EvKprk7c9xYIKwOtMfHsIx5U0Lmwsn8V6zZinyUmY=;
        h=From:To:Cc:Subject:Date:From;
        b=zHao7nggxndlbWtpuqc2WlDizkNDmvY+9pt6o4Mf5bh11YR87WLExbxS9VQeXWPsl
         kn51kZLkqL4XFbQJXZAYGJD3K82S1j77Zo2END0Kmx+ikaMpgxT8bOmqfP+vMAlAhJ
         /k3NO2+Mo8mS4iiDyM7j1y2XKeYLQWPtZ1lTEmto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.1 00/96] 5.1.17-stable review
Date:   Mon,  8 Jul 2019 17:12:32 +0200
Message-Id: <20190708150526.234572443@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.1.17-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.1.17-rc1
X-KernelTest-Deadline: 2019-07-10T15:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.1.17 release.
There are 96 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.17-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.1.17-rc1

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: target/iblock: Fix overrun in WRITE SAME emulation

Geert Uytterhoeven <geert@linux-m68k.org>
    fs: VALIDATE_FS_PARSER should default to n

Dan Carpenter <dan.carpenter@oracle.com>
    dmaengine: jz4780: Fix an endian bug in IRQ handler

Robin Gong <yibin.gong@nxp.com>
    dmaengine: imx-sdma: remove BD_INTR for channel0

Sricharan R <sricharan@codeaurora.org>
    dmaengine: qcom: bam_dma: Fix completed descriptors count

Cedric Hombourger <Cedric_Hombourger@mentor.com>
    MIPS: have "plain" make calls build dtbs for selected platforms

Dmitry Korotin <dkorotin@wavecomp.com>
    MIPS: Add missing EHB in mtc0 -> mfc0 sequence.

Hauke Mehrtens <hauke@hauke-m.de>
    MIPS: Fix bounds check virt_addr_valid

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Ignore source port when computing DRC hash

Paul Menzel <pmenzel@molgen.mpg.de>
    nfsd: Fix overflow causing non-working mounts on 1 TB machines

Wanpeng Li <wanpengli@tencent.com>
    KVM: LAPIC: Fix pending interrupt in IRR blocked by software disable LAPIC

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: degrade WARN to pr_warn_ratelimited

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/mm: fix pxd_bad with folded page tables

Linus Torvalds <torvalds@linux-foundation.org>
    tty: rocket: fix incorrect forward declaration of 'rp_init()'

Nikolay Borisov <nborisov@suse.com>
    btrfs: Ensure replaced device doesn't have pending chunk allocation

Shakeel Butt <shakeelb@google.com>
    mm/vmscan.c: prevent useless kswapd loops

Petr Mladek <pmladek@suse.com>
    ftrace/x86: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()

Robert Beckett <bob.beckett@collabora.com>
    drm/imx: only send event on crtc disable if kept disabled

Robert Beckett <bob.beckett@collabora.com>
    drm/imx: notify drm core before sending event during crtc disable

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: add missing failure path to destroy suballoc

Gerd Hoffmann <kraxel@redhat.com>
    drm/virtio: move drm_connector_update_edid_property() call

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9: use reset default for PA_SC_FIFO_SIZE

Lyude Paul <lyude@redhat.com>
    drm/amdgpu: Don't skip display settings in hwmgr_resume()

Evan Quan <evan.quan@amd.com>
    drm/amd/powerplay: use hardware fan control if no powerplay fan table

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/ringbuffer: EMIT_INVALIDATE *before* switch context

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    arm64: kaslr: keep modules inside module region when KASAN is enabled

Joshua Scott <joshua.scott@alliedtelesis.co.nz>
    ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart serial node

Eiichi Tsukata <devel@etsukata.com>
    tracing/snapshot: Resize spare buffer if size changed

Oleg Nesterov <oleg@redhat.com>
    swap_readpage(): avoid blk_wake_io_task() if !synchronous

Eric Biggers <ebiggers@google.com>
    fs/userfaultfd.c: disable irqs for fault_pending and event locks

Herbert Xu <herbert@gondor.apana.org.au>
    lib/mpi: Fix karactx leak in mpi_powm

Jan Kara <jack@suse.cz>
    dax: Fix xarray entry association for mixed mappings

Dennis Wassenberg <dennis.wassenberg@secunet.com>
    ALSA: hda/realtek - Change front mic location for Lenovo M710q

Richard Sailer <rs@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirks for several Clevo notebook barebones

Colin Ian King <colin.king@canonical.com>
    ALSA: usb-audio: fix sign unintended sign extension on left shifts

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix write on zero-sized buffer

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-lib/fireworks: fix miss detection of received MIDI messages

Colin Ian King <colin.king@canonical.com>
    ALSA: seq: fix incorrect order of dest_client/dest_ports arguments

Vincent Whitchurch <vincent.whitchurch@axis.com>
    crypto: cryptd - Fix skcipher instance memory leak

Eric Biggers <ebiggers@google.com>
    crypto: user - prevent operating on larval algorithms

Jann Horn <jannh@google.com>
    ptrace: Fix ->ptracer_cred handling for PTRACE_TRACEME

Wei Li <liwei391@huawei.com>
    ftrace: Fix NULL pointer dereference in free_ftrace_func_mapper()

Josh Poimboeuf <jpoimboe@redhat.com>
    module: Fix livepatch/ftrace module text permissions race

Vasily Gorbik <gor@linux.ibm.com>
    tracing: avoid build warning with HAVE_NOP_MCOUNT

swkhack <swkhack@gmail.com>
    mm/mlock.c: change count_mm_mlocked_page_nr return type

Manuel Traut <manut@linutronix.de>
    scripts/decode_stacktrace.sh: prefix addr2line with $CROSS_COMPILE

Joel Savitz <jsavitz@redhat.com>
    cpuset: restore sanity to cpuset_cpus_allowed_fallback()

Will Deacon <will.deacon@arm.com>
    arm64: tlbflush: Ensure start/end of address range are aligned to stride

Linus Walleij <linus.walleij@linaro.org>
    i2c: pca-platform: Fix GPIO lookup code

Vadim Pasternak <vadimp@mellanox.com>
    platform/mellanox: mlxreg-hotplug: Add devm_free_irq call to remove flow

Vadim Pasternak <vadimp@mellanox.com>
    platform/x86: mlx-platform: Fix parent device in i2c-mux-reg device registration

Mathew King <mathewk@chromium.org>
    platform/x86: intel-vbtn: Report switch events when event wakes device

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-wmi: Only Tell EC the OS will handle display hotkeys from asus_nb_wmi

Alex Levin <levinale@chromium.org>
    ASoC: Intel: sst: fix kmalloc call with wrong flags

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: core: Fix deadlock in snd_soc_instantiate_card()

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for GPD MicroPC

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for GPD pocket2

H. Nikolaus Schaller <hns@goldelico.com>
    gpio: pca953x: hack to fix 24 bit gpio expanders

Don Brace <don.brace@microsemi.com>
    scsi: hpsa: correct ioaccel2 chaining

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    SoC: rt274: Fix internal jack assignment in set_jack callback

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ALSA: hdac: fix memory release for SST and SOF drivers

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: core: move DAI pre-links initiation to snd_soc_instantiate_card

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: cht_bsw_rt5672: fix kernel oops with platform_name override

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: cht_bsw_nau8824: fix kernel oops with platform_name override

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: bytcht_es8316: fix kernel oops with platform_name override

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: cht_bsw_max98090: fix kernel oops with platform_name override

Andrzej Pietrasiewicz <andrzej.p@collabora.com>
    usb: gadget: dwc2: fix zlp handling

Alexandre Belloni <alexandre.belloni@bootlin.com>
    usb: gadget: udc: lpc32xx: allocate descriptor with GFP_ATOMIC

Young Xiao <92siuyang@gmail.com>
    usb: gadget: fusb300_udc: Fix memory leak of fusb300->ep[i]

Kan Liang <kan.liang@linux.intel.com>
    x86/CPU: Add more Icelake model numbers

Marcus Cooper <codekipper@gmail.com>
    ASoC: sun4i-i2s: Add offset to RX channel select

Marcus Cooper <codekipper@gmail.com>
    ASoC: sun4i-i2s: Fix sun8i tx channel offset mask

Yu-Hsuan Hsu <yuhsuan@chromium.org>
    ASoC: max98090: remove 24-bit format support if RJ is 0

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: call mtk_dsi_stop() after mtk_drm_crtc_atomic_disable()

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: clear num_pipes when unbind driver

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: call drm_atomic_helper_shutdown() when unbinding driver

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: unbind components in mtk_drm_unbind()

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: fix unbind functions

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: hda: fix unbalanced codec dev refcount for HDA_DEV_ASOC

Kovács Tamás <kepszlok@zohomail.eu>
    ASoC: Intel: Baytrail: add quirk for Aegex 10 (RU2) tablet

Błażej Szczygieł <spaz16@wp.pl>
    HID: a4tech: fix horizontal scrolling

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Set the right field for Page Walk Snoop

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: core: lock client_mutex while removing link components

YueHaibing <yuehaibing@huawei.com>
    spi: bitbang: Fix NULL pointer dereference in spi_unregister_master

Viorel Suman <viorel.suman@nxp.com>
    ASoC: ak4458: rstn_control - return a non-zero on error only

Libin Yang <libin.yang@intel.com>
    ASoC: soc-pcm: BE dai needs prepare when pause release after resume

Viorel Suman <viorel.suman@nxp.com>
    ASoC: ak4458: add return value for ak4458_probe

Matt Flax <flatmax@flatmax.org>
    ASoC : cs4265 : readable register too low

Kai-Heng Feng <kai.heng.feng@canonical.com>
    HID: i2c-hid: add iBall Aer3 to descriptor override

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr: Fix idr_get_next race with idr_remove

Florian Westphal <fw@strlen.de>
    netfilter: nft_flow_offload: IPCB is only valid for ipv4 family

Florian Westphal <fw@strlen.de>
    netfilter: nft_flow_offload: don't offload when sequence numbers need adjustment

Florian Westphal <fw@strlen.de>
    netfilter: nft_flow_offload: set liberal tracking mode for tcp

Florian Westphal <fw@strlen.de>
    netfilter: nf_flow_table: ignore DF bit setting

Oleg Nesterov <oleg@redhat.com>
    signal: remove the wrong signal_pending() check in restore_user_sigmask()

Matias Karhumaa <matias.karhumaa@gmail.com>
    Bluetooth: Fix faulty expression for minimum encryption key size check


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi          |  8 ++++
 arch/arm64/include/asm/tlbflush.h                  |  3 ++
 arch/arm64/kernel/module.c                         |  8 +++-
 arch/mips/Makefile                                 |  3 +-
 arch/mips/mm/mmap.c                                |  2 +-
 arch/mips/mm/tlbex.c                               | 29 +++++++++-----
 arch/s390/include/asm/pgtable.h                    | 33 +++++++++-------
 arch/x86/include/asm/intel-family.h                |  3 ++
 arch/x86/kernel/ftrace.c                           |  3 ++
 arch/x86/kvm/lapic.c                               |  2 +-
 arch/x86/kvm/x86.c                                 |  6 +--
 crypto/cryptd.c                                    |  1 +
 crypto/crypto_user_base.c                          |  3 ++
 drivers/dma/dma-jz4780.c                           |  5 ++-
 drivers/dma/imx-sdma.c                             |  4 +-
 drivers/dma/qcom/bam_dma.c                         |  3 ++
 drivers/gpio/gpio-pca953x.c                        |  3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              | 19 ---------
 drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c        |  2 +-
 .../amd/powerplay/hwmgr/process_pptables_v1_0.c    |  4 +-
 drivers/gpu/drm/amd/powerplay/inc/hwmgr.h          |  1 +
 .../drm/amd/powerplay/smumgr/polaris10_smumgr.c    |  4 ++
 drivers/gpu/drm/drm_panel_orientation_quirks.c     | 32 +++++++++++++++
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  7 +++-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  6 +--
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |  6 +--
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  8 ++--
 drivers/gpu/drm/mediatek/mtk_dsi.c                 | 12 +++++-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |  2 +-
 drivers/hid/hid-a4tech.c                           | 11 ++++--
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |  8 ++++
 drivers/i2c/busses/i2c-pca-platform.c              |  3 +-
 drivers/iommu/intel-pasid.c                        |  2 +-
 drivers/platform/mellanox/mlxreg-hotplug.c         |  1 +
 drivers/platform/x86/asus-nb-wmi.c                 |  8 ++++
 drivers/platform/x86/asus-wmi.c                    |  2 +-
 drivers/platform/x86/asus-wmi.h                    |  1 +
 drivers/platform/x86/intel-vbtn.c                  | 16 +++++++-
 drivers/platform/x86/mlx-platform.c                |  2 +-
 drivers/scsi/hpsa.c                                |  7 +++-
 drivers/scsi/hpsa_cmd.h                            |  1 +
 drivers/spi/spi-bitbang.c                          |  2 +-
 drivers/target/target_core_iblock.c                |  2 +-
 drivers/tty/rocket.c                               |  2 +-
 drivers/usb/dwc2/gadget.c                          | 20 ++++++----
 drivers/usb/gadget/udc/fusb300_udc.c               |  5 +++
 drivers/usb/gadget/udc/lpc32xx_udc.c               |  3 +-
 fs/Kconfig                                         |  1 -
 fs/aio.c                                           | 28 +++++++++----
 fs/btrfs/dev-replace.c                             | 26 +++++++-----
 fs/btrfs/volumes.c                                 |  5 ++-
 fs/btrfs/volumes.h                                 |  5 +++
 fs/dax.c                                           |  9 ++---
 fs/eventpoll.c                                     |  4 +-
 fs/io_uring.c                                      |  2 +-
 fs/nfsd/nfs4state.c                                |  2 +-
 fs/select.c                                        | 18 +++------
 fs/userfaultfd.c                                   | 42 ++++++++++++--------
 include/linux/signal.h                             |  2 +-
 kernel/cgroup/cpuset.c                             | 15 ++++++-
 kernel/livepatch/core.c                            |  6 +++
 kernel/ptrace.c                                    |  4 +-
 kernel/signal.c                                    |  5 ++-
 kernel/trace/ftrace.c                              | 12 +++---
 kernel/trace/trace.c                               | 10 +++--
 lib/idr.c                                          | 14 ++++++-
 lib/mpi/mpi-pow.c                                  |  6 +--
 mm/mlock.c                                         |  4 +-
 mm/page_io.c                                       | 13 +++---
 mm/vmscan.c                                        | 27 +++++++------
 net/bluetooth/l2cap_core.c                         |  2 +-
 net/netfilter/nf_flow_table_ip.c                   |  3 +-
 net/netfilter/nft_flow_offload.c                   | 31 ++++++++++-----
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  7 +++-
 scripts/decode_stacktrace.sh                       |  2 +-
 sound/core/seq/oss/seq_oss_ioctl.c                 |  2 +-
 sound/core/seq/oss/seq_oss_rw.c                    |  2 +-
 sound/firewire/amdtp-am824.c                       |  2 +-
 sound/hda/ext/hdac_ext_bus.c                       |  1 -
 sound/pci/hda/hda_codec.c                          |  9 ++++-
 sound/pci/hda/patch_realtek.c                      |  8 ++--
 sound/soc/codecs/ak4458.c                          | 18 +++++----
 sound/soc/codecs/cs4265.c                          |  2 +-
 sound/soc/codecs/max98090.c                        | 16 ++++++++
 sound/soc/codecs/rt274.c                           |  3 +-
 sound/soc/codecs/rt5670.c                          | 12 ++++++
 sound/soc/intel/atom/sst/sst_pvt.c                 |  4 +-
 sound/soc/intel/boards/bytcht_es8316.c             |  2 +-
 sound/soc/intel/boards/cht_bsw_max98090_ti.c       |  2 +-
 sound/soc/intel/boards/cht_bsw_nau8824.c           |  2 +-
 sound/soc/intel/boards/cht_bsw_rt5672.c            |  2 +-
 sound/soc/intel/common/soc-acpi-intel-byt-match.c  | 17 ++++++++
 sound/soc/soc-core.c                               | 29 ++++++--------
 sound/soc/soc-pcm.c                                |  3 +-
 sound/soc/sunxi/sun4i-i2s.c                        |  6 ++-
 sound/usb/line6/pcm.c                              |  5 +++
 sound/usb/mixer_quirks.c                           |  4 +-
 tools/testing/radix-tree/idr-test.c                | 46 ++++++++++++++++++++++
 99 files changed, 570 insertions(+), 254 deletions(-)


