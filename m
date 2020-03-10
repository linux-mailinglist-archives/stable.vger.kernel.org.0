Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 218E417F97E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgCJM5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729445AbgCJM5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:57:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4F2620674;
        Tue, 10 Mar 2020 12:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845037;
        bh=Ys1nvjW14E3z+9jyiyu38WjMu6AaQgqIikYi5F9h/6o=;
        h=From:To:Cc:Subject:Date:From;
        b=MuRCaFJTBUKK75aeeDNIezkGEdM7lvWTnGHNT3kq1+52I+ZoLPVnTNpgzvPWh0Eu2
         wY19Bj+WPDKImjEGhwUzCSsnRWWA2FSY0gtsjxsbHNds3AVxQiVoTg9EbxoHpdKMD2
         KZhD2VRbkzyR3V9oIkknYkiKtvd0Tpf8l0m+TFaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.5 000/189] 5.5.9-stable review
Date:   Tue, 10 Mar 2020 13:37:17 +0100
Message-Id: <20200310123639.608886314@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.5.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.5.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.5.9-rc1
X-KernelTest-Deadline: 2020-03-12T12:36+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.5.9 release.
There are 189 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 Mar 2020 12:34:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.5.9-rc1

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: fix notifier registration

Jason A. Donenfeld <Jason@zx2c4.com>
    efi: READ_ONCE rng seed size before munmap

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Handle by-ref arguments covering multiple pages in mixed mode

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Align GUIDs to their size in the mixed mode runtime wrapper

Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
    powerpc: fix hardware PMU exception bug on PowerVM compatibility mode systems

Sherry Sun <sherry.sun@nxp.com>
    EDAC/synopsys: Do not print an error with back-to-back snprintf() calls

Sébastien Szymanski <sebastien.szymanski@armadeus.com>
    dt-bindings: arm: fsl: fix APF6Dev compatible

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix 1-wire reset quirk

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson: fix gxm-khadas-vim2 wifi

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix statistics for find_idlest_group()

Dan Carpenter <dan.carpenter@oracle.com>
    dmaengine: coh901318: Fix a double lock bug in dma_tc_handle()

Cong Wang <xiyou.wangcong@gmail.com>
    dma-buf: free dmabuf->name in dma_buf_release()

Dan Carpenter <dan.carpenter@oracle.com>
    hwmon: (adt7462) Fix an error return in ADT7462_REG_VOLT()

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ARM: dts: imx7-colibri: Fix frequency for sd/mmc

Johan Hovold <johan@kernel.org>
    ARM: dts: imx6dl-colibri-eval-v3: fix sram compatible properties

Suman Anna <s-anna@ti.com>
    ARM: dts: dra7xx-clocks: Fixup IPU1 mux clock parent source

Suman Anna <s-anna@ti.com>
    ARM: dts: am437x-idk-evm: Fix incorrect OPP node names

Peng Fan <peng.fan@nxp.com>
    ARM: dts: imx7d: fix opp-supported-hw

Ahmad Fatoum <a.fatoum@pengutronix.de>
    ARM: imx: build v7_cpu_resume() unconditionally

Dennis Dalessandro <dennis.dalessandro@intel.com>
    IB/hfi1, qib: Ensure RCU is locked when accessing list

Artemy Kovalyov <artemyko@mellanox.com>
    IB/mlx5: Fix implicit ODP race

Jason Gunthorpe <jgg@ziepe.ca>
    RMDA/cm: Fix missing ib_cm_destroy_id() in ib_cm_insert_listen()

Petr Vorel <petr.vorel@gmail.com>
    regulator: qcom_spmi: Fix docs for PM8004

Fabrice Gasnier <fabrice.gasnier@st.com>
    regulator: stm32-vrefbuf: fix a possible overshoot when re-enabling

Maor Gottlieb <maorg@mellanox.com>
    RDMA/core: Fix protection fault in ib_mr_pool_destroy

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/iwcm: Fix iwcm work deallocation

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix failure handling during device creation

Mark Zhang <markz@mellanox.com>
    RDMA/nldev: Fix crash when set a QP to a new counter but QPN is missing

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/odp: Ensure the mm is still alive before creating an implicit child

Max Gurtovoy <maxg@mellanox.com>
    RDMA/rw: Fix error flow during RDMA context initialization

Parav Pandit <parav@mellanox.com>
    Revert "RDMA/cma: Simplify rdma_resolve_addr() error flow"

Leonard Crestez <leonard.crestez@nxp.com>
    soc: imx-scu: Align imx sc msg structs to 4

Leonard Crestez <leonard.crestez@nxp.com>
    firmware: imx: Align imx_sc_msg_req_cpu_start to 4

Leonard Crestez <leonard.crestez@nxp.com>
    firmware: imx: scu-pd: Align imx sc msg structs to 4

Leonard Crestez <leonard.crestez@nxp.com>
    firmware: imx: misc: Align imx sc msg structs to 4

Fabio Estevam <festevam@gmail.com>
    arm64: dts: imx8qxp-mek: Remove unexisting Ethernet PHY

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: imx6: phycore-som: fix emmc supply

Tony Lindgren <tony@atomide.com>
    phy: mapphone-mdm6600: Fix write timeouts with shorter GPIO toggle interval

Tony Lindgren <tony@atomide.com>
    phy: mapphone-mdm6600: Fix timeouts by adding wake-up handling

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/perf: Reintroduce wait on OA configuration completion

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i915/selftests: Fix return in assert_mmap_offset()

Matt Roper <matthew.d.roper@intel.com>
    drm/i915: Program MBUS with rmw during initialization

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: de2/de3: Remove unsupported VI layer formats

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: Fix DE2 VI layer format support

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: Add separate DE3 VI layer formats

John Stultz <john.stultz@linaro.org>
    drm: kirin: Revert "Fix for hikey620 display offset problem"

Ahzo <Ahzo@tutanota.com>
    drm/ttm: fix leaking fences via ttm_buffer_object_transfer

Phong LE <ple@baylibre.com>
    drm/mediatek: Handle component type MTK_DISP_OVL_2L correctly

Tomeu Vizoso <tomeu.vizoso@collabora.com>
    drm/panfrost: Don't try to map on error faults

Tudor Ambarus <tudor.ambarus@microchip.com>
    spi: atmel-quadspi: fix possible MMIO window size overrun

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-component: tidyup snd_soc_pcm_component_sync_stop()

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: dapm: Correct DAPM handling of active widgets during shutdown

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: Skylake: Fix available clock counter incrementation

Matthias Reichl <hias@horus.com>
    ASoC: pcm512x: Fix unbalanced regulator enable call in probe error path

Takashi Iwai <tiwai@suse.de>
    ASoC: pcm: Fix possible buffer overflow in dpcm state sysfs output

Takashi Iwai <tiwai@suse.de>
    ASoC: intel: skl: Fix possible buffer overflow in debug outputs

Takashi Iwai <tiwai@suse.de>
    ASoC: intel: skl: Fix pin debug prints

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: SOF: Fix snd_sof_ipc_stream_posn()

Dragos Tarcatu <dragos_tarcatu@mentor.com>
    ASoC: topology: Fix memleak in soc_tplg_manifest_load()

Dragos Tarcatu <dragos_tarcatu@mentor.com>
    ASoC: topology: Fix memleak in soc_tplg_link_elems_load()

John Bates <jbates@chromium.org>
    drm/virtio: fix resource id creation race

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: bcm63xx-hsspi: Really keep pll clk enabled

Vladimir Oltean <olteanv@gmail.com>
    ARM: dts: ls1021a: Restore MDIO compatible to gianfar

Guillaume La Roque <glaroque@baylibre.com>
    arm64: dts: meson-sm1-sei610: add missing interrupt-names

Hou Tao <houtao1@huawei.com>
    dm: fix congested_fn for request-based device

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    dm zoned: Fix reference counter initial value of chunk works

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: verify watermark during resume

Mikulas Patocka <mpatocka@redhat.com>
    dm: report suspended device during destroy

Mikulas Patocka <mpatocka@redhat.com>
    dm cache: fix a crash due to incorrect work item cancelling

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix invalid table returned due to argument count mismatch

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix a deadlock due to offloading to an incorrect workqueue

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix recalculation when moving from journal mode to bitmap mode

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Prevent race conditions of tasklet vs free list

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Fix use-after-free

Frieder Schrempf <frieder.schrempf@kontron.de>
    dmaengine: imx-sdma: Fix the event id check to include RX event for UART6

Martin Fuzzey <martin.fuzzey@flowbird.group>
    dmaengine: imx-sdma: fix context cache

Prike Liang <Prike.Liang@amd.com>
    drm/amd/powerplay: fix pre-check condition for setting clock range

Tianci.Yin <tianci.yin@amd.com>
    drm/amdgpu: disable 3D pipe 1 on Navi1x

Gerd Hoffmann <kraxel@redhat.com>
    drm/shmem: add support for per object caching flags.

Gerd Hoffmann <kraxel@redhat.com>
    drm/virtio: fix mmap page attributes

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/mm: Fix missing KUAP disable in flush_coherent_icache()

Christophe Leroy <christophe.leroy@c-s.fr>
    selftests: pidfd: Add pidfd_fdinfo_test in .gitignore

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/mm: fix panic in gup_fast on large pud

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix unexpected write combine on resource

Sean Christopherson <sean.j.christopherson@intel.com>
    x86/pkeys: Manually set X86_FEATURE_OSPKE to preserve existing changes

Juergen Gross <jgross@suse.com>
    x86/ioperm: Add new paravirt function update_io_bitmap()

Lukas Wunner <lukas@wunner.de>
    spi: spidev: Fix CS polarity if GPIO descriptors are used

Adrian Hunter <adrian.hunter@intel.com>
    perf arm-spe: Fix endless record after being terminated

Wei Li <liwei391@huawei.com>
    perf cs-etm: Fix endless record after being terminated

Wei Li <liwei391@huawei.com>
    perf intel-bts: Fix endless record after being terminated

Wei Li <liwei391@huawei.com>
    perf intel-pt: Fix endless record after being terminated

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-mem2mem.c: fix broken links

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vicodec: process all 4 components for RGB32 formats

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: mc-entity.c: use & to check pad flags, not ==

Ezequiel Garcia <ezequiel@collabora.com>
    media: hantro: Fix broken media controller links

Jiri Slaby <jslaby@suse.cz>
    vt: selection, push sel_lock up

Jiri Slaby <jslaby@suse.cz>
    vt: selection, push console lock down

Jiri Slaby <jslaby@suse.cz>
    vt: selection, close sel_buffer race

Ronald Tschalär <ronald@innovation.ch>
    serdev: Fix detection of UART devices on Apple machines.

Jay Dolan <jay.dolan@accesio.com>
    serial: 8250_exar: add support for ACCES cards

Michael Walle <michael@walle.cc>
    tty: serial: fsl_lpuart: free IDs allocated by IDA

tangbin <tangbin@cmss.chinamobile.com>
    tty:serial:mvebu-uart:fix a wrong return

Rikard Falkeborn <rikard.falkeborn@gmail.com>
    phy: allwinner: Fix GENMASK misuse

Faiz Abbas <faiz_abbas@ti.com>
    arm: dts: dra76x: Fix mmc3 max-frequency

Ley Foon Tan <ley.foon.tan@intel.com>
    arm64: dts: socfpga: agilex: Fix gmac compatible

Omar Sandoval <osandov@fb.com>
    btrfs: fix RAID direct I/O reads with alternate csums

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: fix uninit-memory access for partial initialized inode

Vlastimil Babka <vbabka@suse.cz>
    mm, hotplug: fix page online with DEBUG_PAGEALLOC compiled but not enabled

Kirill A. Shutemov <kirill@shutemov.name>
    mm: avoid data corruption on CoW fault into PFN-mapped VMA

Huang Ying <ying.huang@intel.com>
    mm: fix possible PMD dirty bit lost in set_pmd_migration_entry()

Mel Gorman <mgorman@techsingularity.net>
    mm, numa: fix bad pmd by atomically check for pmd_trans_huge when marking page tables prot_numa

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    vgacon: Fix a UAF in vgacon_invert_region

Eugeniu Rosca <erosca@de.adit-jv.com>
    usb: core: port: do error out if usb_autopm_get_interface() fails

Eugeniu Rosca <erosca@de.adit-jv.com>
    usb: core: hub: do error out if usb_autopm_get_interface() fails

Eugeniu Rosca <erosca@de.adit-jv.com>
    usb: core: hub: fix unhandled return by employing a void function

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: gadget: toggle cycle bit before reset endpoint

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: gadget: link trb should point to next request

Pratham Pratap <prathampratap@codeaurora.org>
    usb: dwc3: gadget: Update chain bit correctly when using sg list

Dan Lazewatsky <dlaz@chromium.org>
    usb: quirks: add NO_LPM quirk for Logitech Screen Share

Marco Felsch <m.felsch@pengutronix.de>
    usb: usb251xb: fix regulator probe and error handling

Jim Lin <jilin@nvidia.com>
    usb: storage: Add quirk for Samsung Fit flash

Aurelien Aptel <aaptel@suse.com>
    cifs: fix rename() by ensuring source handle opened with DELETE bit

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: don't leak -EAGAIN for stat() during reconnect

Saravana Kannan <saravanak@google.com>
    driver core: Call sync_state() even if supplier has no consumers

Jian-Hong Pan <jian-hong@endlessm.com>
    ALSA: hda/realtek - Enable the headset of ASUS B9450FA with ALC294

Christian Lachner <gladiac@gmail.com>
    ALSA: hda/realtek - Fix silent output on Gigabyte X570 Aorus Master

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - Fix a regression for mute led on Lenovo Carbon X1

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add Headset Button supported for ThinkPad X1

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add Headset Mic supported

Christian Brauner <christian.brauner@ubuntu.com>
    binder: prevent UAF for binderfs devices II

Christian Brauner <christian.brauner@ubuntu.com>
    binder: prevent UAF for binderfs devices

Leonard Crestez <leonard.crestez@nxp.com>
    firmware: imx: scu: Ensure sequential TX

Hangbin Liu <liuhangbin@gmail.com>
    selftests: forwarding: vxlan_bridge_1d: use more proper tos value

Randy Dunlap <rdunlap@infradead.org>
    arch/csky: fix some Kconfig typos

Guo Ren <guoren@linux.alibaba.com>
    csky: Fixup compile warning for three unimplemented syscalls

Guo Ren <guoren@linux.alibaba.com>
    csky: Fixup ftrace modify panic

Guo Ren <guoren@linux.alibaba.com>
    csky/smp: Fixup boot failed when CONFIG_SMP

Guo Ren <guoren@linux.alibaba.com>
    csky: Set regs->usp to kernel sp, when the exception is from kernel

Guo Ren <guoren@linux.alibaba.com>
    csky/mm: Fixup export invalid_pte_table symbol

Tim Harvey <tharvey@gateworks.com>
    net: thunderx: workaround BGX TX Underflow issue

Kees Cook <keescook@chromium.org>
    x86/xen: Distribute switch variables for initialization

Michal Swiatkowski <michal.swiatkowski@intel.com>
    ice: Don't tell the OS that link is going down

Keith Busch <kbusch@kernel.org>
    nvme: Fix uninitialized-variable warning

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: fill SL with absolute addresses

H.J. Lu <hjl.tools@gmail.com>
    x86/boot/compressed: Don't declare __force_order in kaslr_64.c

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    nvme-pci: Use single IRQ vector for old Apple models

Shyjumon N <shyjumon.n@intel.com>
    nvme/pci: Add sleep quirk for Samsung and Toshiba drives

Kai-Heng Feng <kai.heng.feng@canonical.com>
    iommu/amd: Disable IOMMU on Stoney Ridge systems

Hamdan Igbaria <hamdani@mellanox.com>
    net/mlx5: DR, Fix matching on vport gvmi

Javier Martinez Canillas <javierm@redhat.com>
    efi: Only print errors about failing to get certs if EFI vars are found

Masahiro Yamada <masahiroy@kernel.org>
    s390: make 'install' not depend on vmlinux

Vasily Averin <vvs@virtuozzo.com>
    s390/cio: cio_ignore_proc_seq_next should increase position index

Marco Felsch <m.felsch@pengutronix.de>
    watchdog: da9062: do not ping the hw during stop()

Paul Cercueil <paul@crapouillou.net>
    net: ethernet: dm9000: Handle -EPROBE_DEFER in dm9000_parse_dt()

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix 16-bit IO operation

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix 16-bit data access

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Remove 8-bit bus accessors

Egor Pomozov <epomozov@marvell.com>
    net: atlantic: ptp gpio adjustments

Igor Russkikh <irusskikh@marvell.com>
    net: atlantic: check rpc result and wait for rpc address

Hangbin Liu <liuhangbin@gmail.com>
    selftests: forwarding: vxlan_bridge_1d: fix tos value

Hangbin Liu <liuhangbin@gmail.com>
    selftests: forwarding: use proto icmp for {gretap, ip6gretap}_mac testing

Harigovindan P <harigovi@codeaurora.org>
    drm/msm/dsi/pll: call vco set rate explicitly

Harigovindan P <harigovi@codeaurora.org>
    drm/msm/dsi: save pll state before dsi host is powered off

Tomas Henzl <thenzl@redhat.com>
    scsi: megaraid_sas: silence a warning

Stephan Gerhold <stephan@gerhold.net>
    drm/modes: Allow DRM_MODE_ROTATE_0 when applying video mode parameters

Stephan Gerhold <stephan@gerhold.net>
    drm/modes: Make sure to parse valid rotation value from cmdline

John Stultz <john.stultz@linaro.org>
    drm: msm: Fix return type of dsi_mgr_connector_mode_valid for kCFI

Brian Masney <masneyb@onstation.org>
    drm/msm/mdp5: rate limit pp done timeout warnings

Oded Gabbay <oded.gabbay@gmail.com>
    habanalabs: patched cb equals user cb in device memset

Omer Shpigelman <oshpigelman@habana.ai>
    habanalabs: do not halt CoreSight during hard reset

Oded Gabbay <oded.gabbay@gmail.com>
    habanalabs: halt the engines before hard-reset

Sergey Organov <sorganov@gmail.com>
    usb: gadget: serial: fix Tx stall after buffer overflow

Lars-Peter Clausen <lars@metafoo.de>
    usb: gadget: ffs: ffs_aio_cancel(): Save/restore IRQ flags

Jack Pham <jackp@codeaurora.org>
    usb: gadget: composite: Support more than 500mA MaxPower

Jiri Benc <jbenc@redhat.com>
    selftests: fix too long argument

Nikita Sobolev <Nikita.Sobolev@synopsys.com>
    Kernel selftests: tpm2: check for tpm support

Daniel Golle <daniel@makrotopia.org>
    serial: ar933x_uart: set UART_CS_{RX,TX}_READY_ORIDE

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: do not override bus codec_mask in link_get()

Cong Wang <xiyou.wangcong@gmail.com>
    netfilter: xt_hashlimit: unregister proc file before releasing mutex

Florian Westphal <fw@strlen.de>
    netfilter: hashlimit: do not use indirect calls during gc

Cengiz Can <cengiz@kernel.wtf>
    blktrace: fix dereference after null check

Nathan Chancellor <natechancellor@gmail.com>
    RDMA/core: Fix use of logical OR in get_new_pps

Maor Gottlieb <maorg@mellanox.com>
    RDMA/core: Fix pkey and port assignment in get_new_pps

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Forcibly configure IMP port for 1Gb/sec

Theodore Ts'o <tytso@mit.edu>
    dm thin metadata: fix lockdep complaint

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: do not insert oom queue into position tree

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: get extra ref to prevent a queue from being freed during a group move

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: get a ref to a group when adding it to a service tree

Jaroslav Kysela <perex@perex.cz>
    ASoC: intel/skl/hda - export number of digital microphones via control components


-------------

Diffstat:

 Documentation/devicetree/bindings/arm/fsl.yaml     |   2 +-
 .../bindings/regulator/qcom,spmi-regulator.txt     |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/am437x-idk-evm.dts               |   4 +-
 arch/arm/boot/dts/dra76x.dtsi                      |   5 +
 arch/arm/boot/dts/dra7xx-clocks.dtsi               |  12 +--
 arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts       |   4 +-
 arch/arm/boot/dts/imx6qdl-phytec-phycore-som.dtsi  |   1 -
 arch/arm/boot/dts/imx7-colibri.dtsi                |   1 -
 arch/arm/boot/dts/imx7d.dtsi                       |   6 +-
 arch/arm/boot/dts/ls1021a.dtsi                     |   4 +-
 arch/arm/mach-imx/Makefile                         |   2 +
 arch/arm/mach-imx/common.h                         |   4 +-
 arch/arm/mach-imx/resume-imx6.S                    |  24 +++++
 arch/arm/mach-imx/suspend-imx6.S                   |  14 ---
 .../boot/dts/amlogic/meson-gxm-khadas-vim2.dts     |   2 +-
 arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts   |   1 +
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts      |   5 -
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi      |   6 +-
 arch/csky/Kconfig                                  |   2 +-
 arch/csky/abiv1/inc/abi/entry.h                    |  19 +++-
 arch/csky/abiv2/inc/abi/entry.h                    |  11 +++
 arch/csky/include/uapi/asm/unistd.h                |   3 +
 arch/csky/kernel/atomic.S                          |   8 +-
 arch/csky/kernel/smp.c                             |   2 +-
 arch/csky/mm/Makefile                              |   2 +
 arch/csky/mm/init.c                                |   1 +
 arch/powerpc/kernel/cputable.c                     |   4 +-
 arch/powerpc/mm/mem.c                              |   2 +
 arch/s390/Makefile                                 |   2 +-
 arch/s390/boot/Makefile                            |   2 +-
 arch/s390/include/asm/pgtable.h                    |   6 ++
 arch/s390/include/asm/qdio.h                       |   2 +-
 arch/s390/pci/pci.c                                |   4 +-
 arch/x86/boot/compressed/kaslr_64.c                |   3 -
 arch/x86/include/asm/io_bitmap.h                   |   9 +-
 arch/x86/include/asm/paravirt.h                    |   7 ++
 arch/x86/include/asm/paravirt_types.h              |   4 +
 arch/x86/kernel/cpu/common.c                       |   2 +-
 arch/x86/kernel/paravirt.c                         |   5 +
 arch/x86/kernel/process.c                          |   2 +-
 arch/x86/platform/efi/efi_64.c                     |  70 +++++++++-----
 arch/x86/xen/enlighten_pv.c                        |  32 ++++++-
 block/bfq-cgroup.c                                 |  10 +-
 block/bfq-iosched.c                                |   4 +
 block/bfq-iosched.h                                |   1 +
 block/bfq-wf2q.c                                   |  12 ++-
 drivers/android/binder.c                           |   9 ++
 drivers/android/binder_internal.h                  |   2 +
 drivers/android/binderfs.c                         |   7 +-
 drivers/base/core.c                                |  23 +++--
 drivers/bus/ti-sysc.c                              |   4 +-
 drivers/dma-buf/dma-buf.c                          |   1 +
 drivers/dma/coh901318.c                            |   4 -
 drivers/dma/imx-sdma.c                             |   5 +-
 drivers/dma/tegra20-apb-dma.c                      |   6 +-
 drivers/edac/synopsys_edac.c                       |  22 ++---
 drivers/firmware/efi/efi.c                         |   4 +-
 drivers/firmware/imx/imx-scu.c                     |  27 ++++++
 drivers/firmware/imx/misc.c                        |   8 +-
 drivers/firmware/imx/scu-pd.c                      |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  97 ++++++++++---------
 drivers/gpu/drm/amd/powerplay/amdgpu_smu.c         |   2 +-
 drivers/gpu/drm/amd/powerplay/smu_v12_0.c          |   3 -
 drivers/gpu/drm/drm_client_modeset.c               |   3 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |  15 ++-
 drivers/gpu/drm/drm_modes.c                        |   7 ++
 drivers/gpu/drm/hisilicon/kirin/kirin_ade_reg.h    |   1 -
 drivers/gpu/drm/hisilicon/kirin/kirin_drm_ade.c    |  20 ----
 drivers/gpu/drm/i915/display/intel_display_power.c |  16 +++-
 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c |   2 +-
 drivers/gpu/drm/i915/i915_perf.c                   |  58 ++++++++----
 drivers/gpu/drm/i915/i915_perf_types.h             |   3 +-
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c        |   1 +
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |   4 +-
 drivers/gpu/drm/msm/dsi/dsi_manager.c              |   7 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c              |   4 -
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c         |   6 ++
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |  44 ++++-----
 drivers/gpu/drm/selftests/drm_cmdline_selftests.h  |   1 +
 .../gpu/drm/selftests/test-drm_cmdline_parser.c    |  15 ++-
 drivers/gpu/drm/sun4i/sun8i_mixer.c                | 104 ++++++++++++++++++---
 drivers/gpu/drm/sun4i/sun8i_mixer.h                |  11 +++
 drivers/gpu/drm/sun4i/sun8i_vi_layer.c             |  66 +++++++++++--
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |   1 +
 drivers/gpu/drm/virtio/virtgpu_object.c            |   5 +-
 drivers/hwmon/adt7462.c                            |   2 +-
 drivers/infiniband/core/cm.c                       |   1 +
 drivers/infiniband/core/cma.c                      |  15 ++-
 drivers/infiniband/core/core_priv.h                |  15 +++
 drivers/infiniband/core/iwcm.c                     |   4 +-
 drivers/infiniband/core/nldev.c                    |   2 +
 drivers/infiniband/core/rw.c                       |  31 +++---
 drivers/infiniband/core/security.c                 |  14 ++-
 drivers/infiniband/core/umem_odp.c                 |  24 ++++-
 drivers/infiniband/core/uverbs_cmd.c               |  10 --
 drivers/infiniband/core/verbs.c                    |  10 --
 drivers/infiniband/hw/hfi1/verbs.c                 |   4 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   1 +
 drivers/infiniband/hw/mlx5/odp.c                   |  17 ++--
 drivers/infiniband/hw/qib/qib_verbs.c              |   2 +
 drivers/infiniband/sw/siw/siw_main.c               |   6 +-
 drivers/iommu/amd_iommu_init.c                     |  13 ++-
 drivers/md/dm-cache-target.c                       |   4 +-
 drivers/md/dm-integrity.c                          |  50 ++++++----
 drivers/md/dm-thin-metadata.c                      |   2 +-
 drivers/md/dm-writecache.c                         |  14 ++-
 drivers/md/dm-zoned-target.c                       |   8 +-
 drivers/md/dm.c                                    |  22 ++---
 drivers/media/mc/mc-entity.c                       |   4 +-
 drivers/media/platform/vicodec/codec-v4l2-fwht.c   |  34 ++-----
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   4 +-
 drivers/misc/habanalabs/device.c                   |   5 +-
 drivers/misc/habanalabs/goya/goya.c                |  44 ++++++++-
 drivers/net/dsa/bcm_sf2.c                          |   3 +-
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h     |   2 +
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |   4 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c        |  19 +++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c   |  12 +++
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |  62 +++++++++++-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.h  |   9 ++
 drivers/net/ethernet/davicom/dm9000.c              |   2 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   7 --
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |   5 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |  53 ++---------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  13 ++-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/host/pci.c                            |  15 ++-
 drivers/phy/allwinner/phy-sun50i-usb3.c            |   2 +-
 drivers/phy/motorola/phy-mapphone-mdm6600.c        |  27 +++++-
 drivers/regulator/stm32-vrefbuf.c                  |   3 +-
 drivers/s390/cio/blacklist.c                       |   5 +-
 drivers/s390/cio/qdio_setup.c                      |   3 +-
 drivers/s390/net/qeth_core_main.c                  |  23 +++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   5 +-
 drivers/soc/imx/soc-imx-scu.c                      |   2 +-
 drivers/spi/atmel-quadspi.c                        |  11 +++
 drivers/spi/spi-bcm63xx-hsspi.c                    |   1 -
 drivers/spi/spidev.c                               |   5 +
 drivers/staging/media/hantro/hantro_drv.c          |   4 +-
 drivers/staging/speakup/selection.c                |   2 -
 drivers/tty/serdev/core.c                          |  10 ++
 drivers/tty/serial/8250/8250_exar.c                |  33 +++++++
 drivers/tty/serial/ar933x_uart.c                   |   8 ++
 drivers/tty/serial/fsl_lpuart.c                    |  39 +++++---
 drivers/tty/serial/mvebu-uart.c                    |   2 +-
 drivers/tty/vt/selection.c                         |  26 +++++-
 drivers/tty/vt/vt.c                                |   2 -
 drivers/usb/cdns3/gadget.c                         |  19 +++-
 drivers/usb/core/hub.c                             |   8 +-
 drivers/usb/core/port.c                            |  10 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc3/gadget.c                          |   9 +-
 drivers/usb/gadget/composite.c                     |  24 +++--
 drivers/usb/gadget/function/f_fs.c                 |   5 +-
 drivers/usb/gadget/function/u_serial.c             |   4 +-
 drivers/usb/misc/usb251xb.c                        |  20 +++-
 drivers/usb/storage/unusual_devs.h                 |   6 ++
 drivers/video/console/vgacon.c                     |   3 +
 drivers/watchdog/da9062_wdt.c                      |   7 --
 fs/btrfs/inode.c                                   |   4 +-
 fs/cifs/cifsglob.h                                 |   7 ++
 fs/cifs/cifsproto.h                                |   5 +-
 fs/cifs/cifssmb.c                                  |   3 +-
 fs/cifs/file.c                                     |  19 ++--
 fs/cifs/inode.c                                    |  12 ++-
 fs/cifs/smb1ops.c                                  |   2 +-
 fs/cifs/smb2inode.c                                |   4 +-
 fs/cifs/smb2ops.c                                  |   3 +-
 fs/cifs/smb2pdu.c                                  |   1 +
 fs/fat/inode.c                                     |  19 ++--
 include/drm/drm_gem_shmem_helper.h                 |   5 +
 include/linux/mm.h                                 |   4 +
 kernel/sched/fair.c                                |   2 +
 kernel/trace/blktrace.c                            |   5 +-
 mm/huge_memory.c                                   |   3 +-
 mm/memory.c                                        |  35 +++++--
 mm/memory_hotplug.c                                |   8 +-
 mm/mprotect.c                                      |  38 +++++++-
 net/netfilter/xt_hashlimit.c                       |  36 ++-----
 security/integrity/platform_certs/load_uefi.c      |  40 +++++---
 sound/hda/ext/hdac_ext_controller.c                |   9 +-
 sound/pci/hda/patch_realtek.c                      |  31 +++++-
 sound/soc/codecs/pcm512x.c                         |   8 +-
 sound/soc/intel/boards/skl_hda_dsp_generic.c       |   8 ++
 sound/soc/intel/skylake/skl-debug.c                |  32 ++++---
 sound/soc/intel/skylake/skl-ssp-clk.c              |   4 +-
 sound/soc/soc-component.c                          |   2 +-
 sound/soc/soc-dapm.c                               |   2 +-
 sound/soc/soc-pcm.c                                |  16 ++--
 sound/soc/soc-topology.c                           |  17 ++--
 sound/soc/sof/intel/hda.c                          |   3 +-
 sound/soc/sof/ipc.c                                |   2 +-
 tools/perf/arch/arm/util/cs-etm.c                  |   5 +-
 tools/perf/arch/arm64/util/arm-spe.c               |   5 +-
 tools/perf/arch/x86/util/intel-bts.c               |   5 +-
 tools/perf/arch/x86/util/intel-pt.c                |   5 +-
 tools/testing/selftests/lib.mk                     |  23 +++--
 .../testing/selftests/net/forwarding/mirror_gre.sh |  25 ++---
 .../selftests/net/forwarding/vxlan_bridge_1d.sh    |   6 +-
 tools/testing/selftests/pidfd/.gitignore           |   1 +
 tools/testing/selftests/tpm2/test_smoke.sh         |  13 ++-
 tools/testing/selftests/tpm2/test_space.sh         |   9 +-
 203 files changed, 1602 insertions(+), 739 deletions(-)


