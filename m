Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D456817FB44
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbgCJNMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731390AbgCJNMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:12:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DCC52468C;
        Tue, 10 Mar 2020 13:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845939;
        bh=MlNBLwr1dbqlWfEkM5BJ3r6BVjeDzhTjUj6paYm6zqw=;
        h=From:To:Cc:Subject:Date:From;
        b=ClHJ2BLe3+JZR938s/XiKj1Aq9wvSI2mjUfXW0eXjOMGBR/ZBjZY0gAKfYTQYBn9O
         y+WqWg2pZNduCMlk4cMrHlgkOtSknFx0DagNOwjwt3zJBgdEwvqUbupaqu1acPUd0d
         geIlfX5ZeLjH/ccDdxCo/BUl7RD03LxtCt1aHDfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/86] 4.19.109-stable review
Date:   Tue, 10 Mar 2020 13:44:24 +0100
Message-Id: <20200310124530.808338541@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.109-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.109-rc1
X-KernelTest-Deadline: 2020-03-12T12:45+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.109 release.
There are 86 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 Mar 2020 12:45:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.109-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.109-rc1

Deepak Ukey <deepak.ukey@microchip.com>
    scsi: pm80xx: Fixed kernel panic during error recovery for SATA drive

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix a deadlock due to offloading to an incorrect workqueue

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Handle by-ref arguments covering multiple pages in mixed mode

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Align GUIDs to their size in the mixed mode runtime wrapper

Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
    powerpc: fix hardware PMU exception bug on PowerVM compatibility mode systems

Dan Carpenter <dan.carpenter@oracle.com>
    dmaengine: coh901318: Fix a double lock bug in dma_tc_handle()

Dan Carpenter <dan.carpenter@oracle.com>
    hwmon: (adt7462) Fix an error return in ADT7462_REG_VOLT()

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ARM: dts: imx7-colibri: Fix frequency for sd/mmc

Johan Hovold <johan@kernel.org>
    ARM: dts: imx6dl-colibri-eval-v3: fix sram compatible properties

Suman Anna <s-anna@ti.com>
    ARM: dts: am437x-idk-evm: Fix incorrect OPP node names

Ahmad Fatoum <a.fatoum@pengutronix.de>
    ARM: imx: build v7_cpu_resume() unconditionally

Dennis Dalessandro <dennis.dalessandro@intel.com>
    IB/hfi1, qib: Ensure RCU is locked when accessing list

Jason Gunthorpe <jgg@ziepe.ca>
    RMDA/cm: Fix missing ib_cm_destroy_id() in ib_cm_insert_listen()

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/iwcm: Fix iwcm work deallocation

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: imx6: phycore-som: fix emmc supply

Tony Lindgren <tony@atomide.com>
    phy: mapphone-mdm6600: Fix write timeouts with shorter GPIO toggle interval

Tony Lindgren <tony@atomide.com>
    phy: mapphone-mdm6600: Fix timeouts by adding wake-up handling

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: de2/de3: Remove unsupported VI layer formats

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: Fix DE2 VI layer format support

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: dapm: Correct DAPM handling of active widgets during shutdown

Matthias Reichl <hias@horus.com>
    ASoC: pcm512x: Fix unbalanced regulator enable call in probe error path

Takashi Iwai <tiwai@suse.de>
    ASoC: pcm: Fix possible buffer overflow in dpcm state sysfs output

Vinod Koul <vkoul@kernel.org>
    dmaengine: imx-sdma: remove dma_slave_config direction usage and leave sdma_event_enable()

Takashi Iwai <tiwai@suse.de>
    ASoC: intel: skl: Fix possible buffer overflow in debug outputs

Takashi Iwai <tiwai@suse.de>
    ASoC: intel: skl: Fix pin debug prints

Dragos Tarcatu <dragos_tarcatu@mentor.com>
    ASoC: topology: Fix memleak in soc_tplg_manifest_load()

Dragos Tarcatu <dragos_tarcatu@mentor.com>
    ASoC: topology: Fix memleak in soc_tplg_link_elems_load()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: bcm63xx-hsspi: Really keep pll clk enabled

Vladimir Oltean <olteanv@gmail.com>
    ARM: dts: ls1021a: Restore MDIO compatible to gianfar

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: verify watermark during resume

Mikulas Patocka <mpatocka@redhat.com>
    dm: report suspended device during destroy

Mikulas Patocka <mpatocka@redhat.com>
    dm cache: fix a crash due to incorrect work item cancelling

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Prevent race conditions of tasklet vs free list

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Fix use-after-free

Sean Christopherson <sean.j.christopherson@intel.com>
    x86/pkeys: Manually set X86_FEATURE_OSPKE to preserve existing changes

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-mem2mem.c: fix broken links

Jiri Slaby <jslaby@suse.cz>
    vt: selection, push sel_lock up

Jiri Slaby <jslaby@suse.cz>
    vt: selection, push console lock down

Jiri Slaby <jslaby@suse.cz>
    vt: selection, close sel_buffer race

Jay Dolan <jay.dolan@accesio.com>
    serial: 8250_exar: add support for ACCES cards

tangbin <tangbin@cmss.chinamobile.com>
    tty:serial:mvebu-uart:fix a wrong return

Faiz Abbas <faiz_abbas@ti.com>
    arm: dts: dra76x: Fix mmc3 max-frequency

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: fix uninit-memory access for partial initialized inode

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

Pratham Pratap <prathampratap@codeaurora.org>
    usb: dwc3: gadget: Update chain bit correctly when using sg list

Dan Lazewatsky <dlaz@chromium.org>
    usb: quirks: add NO_LPM quirk for Logitech Screen Share

Jim Lin <jilin@nvidia.com>
    usb: storage: Add quirk for Samsung Fit flash

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: don't leak -EAGAIN for stat() during reconnect

Christian Lachner <gladiac@gmail.com>
    ALSA: hda/realtek - Fix silent output on Gigabyte X570 Aorus Master

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add Headset Mic supported

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

Masahiro Yamada <masahiroy@kernel.org>
    s390: make 'install' not depend on vmlinux

Vasily Averin <vvs@virtuozzo.com>
    s390/cio: cio_ignore_proc_seq_next should increase position index

Marco Felsch <m.felsch@pengutronix.de>
    watchdog: da9062: do not ping the hw during stop()

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix 16-bit IO operation

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix 16-bit data access

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Remove 8-bit bus accessors

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Ensure the default VID is untagged

Hangbin Liu <liuhangbin@gmail.com>
    selftests: forwarding: use proto icmp for {gretap, ip6gretap}_mac testing

Harigovindan P <harigovi@codeaurora.org>
    drm/msm/dsi/pll: call vco set rate explicitly

Harigovindan P <harigovi@codeaurora.org>
    drm/msm/dsi: save pll state before dsi host is powered off

Tomas Henzl <thenzl@redhat.com>
    scsi: megaraid_sas: silence a warning

John Stultz <john.stultz@linaro.org>
    drm: msm: Fix return type of dsi_mgr_connector_mode_valid for kCFI

Brian Masney <masneyb@onstation.org>
    drm/msm/mdp5: rate limit pp done timeout warnings

Sergey Organov <sorganov@gmail.com>
    usb: gadget: serial: fix Tx stall after buffer overflow

Lars-Peter Clausen <lars@metafoo.de>
    usb: gadget: ffs: ffs_aio_cancel(): Save/restore IRQ flags

Jack Pham <jackp@codeaurora.org>
    usb: gadget: composite: Support more than 500mA MaxPower

Jiri Benc <jbenc@redhat.com>
    selftests: fix too long argument

Daniel Golle <daniel@makrotopia.org>
    serial: ar933x_uart: set UART_CS_{RX,TX}_READY_ORIDE

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: do not override bus codec_mask in link_get()

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Fix optimize_kprobe()/unoptimize_kprobe() cancellation logic

Nathan Chancellor <natechancellor@gmail.com>
    RDMA/core: Fix use of logical OR in get_new_pps

Maor Gottlieb <maorg@mellanox.com>
    RDMA/core: Fix pkey and port assignment in get_new_pps

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Forcibly configure IMP port for 1Gb/sec

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - Fix a regression for mute led on Lenovo Carbon X1

Yazen Ghannam <yazen.ghannam@amd.com>
    EDAC/amd64: Set grain per DIMM


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/am437x-idk-evm.dts               |  4 +-
 arch/arm/boot/dts/dra76x.dtsi                      |  5 ++
 arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts       |  4 +-
 arch/arm/boot/dts/imx6qdl-phytec-phycore-som.dtsi  |  1 -
 arch/arm/boot/dts/imx7-colibri.dtsi                |  1 -
 arch/arm/boot/dts/ls1021a.dtsi                     |  4 +-
 arch/arm/mach-imx/Makefile                         |  2 +
 arch/arm/mach-imx/common.h                         |  4 +-
 arch/arm/mach-imx/resume-imx6.S                    | 24 ++++++++
 arch/arm/mach-imx/suspend-imx6.S                   | 14 -----
 arch/powerpc/kernel/cputable.c                     |  4 +-
 arch/s390/Makefile                                 |  2 +-
 arch/s390/boot/Makefile                            |  2 +-
 arch/s390/include/asm/qdio.h                       |  2 +-
 arch/x86/boot/compressed/kaslr_64.c                |  3 -
 arch/x86/kernel/cpu/common.c                       |  2 +-
 arch/x86/platform/efi/efi_64.c                     | 70 +++++++++++++++-------
 arch/x86/xen/enlighten_pv.c                        |  7 ++-
 drivers/dma/coh901318.c                            |  4 --
 drivers/dma/imx-sdma.c                             | 56 +++++++++++------
 drivers/dma/tegra20-apb-dma.c                      |  6 +-
 drivers/edac/amd64_edac.c                          |  1 +
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |  4 +-
 drivers/gpu/drm/msm/dsi/dsi_manager.c              |  7 ++-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c              |  4 --
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c         |  6 ++
 drivers/gpu/drm/sun4i/sun8i_mixer.c                | 68 +++++++++++++++++----
 drivers/gpu/drm/sun4i/sun8i_vi_layer.c             | 24 ++++----
 drivers/hwmon/adt7462.c                            |  2 +-
 drivers/infiniband/core/cm.c                       |  1 +
 drivers/infiniband/core/iwcm.c                     |  4 +-
 drivers/infiniband/core/security.c                 | 14 +++--
 drivers/infiniband/hw/hfi1/verbs.c                 |  4 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |  2 +
 drivers/md/dm-cache-target.c                       |  4 +-
 drivers/md/dm-integrity.c                          | 27 ++++++---
 drivers/md/dm-writecache.c                         | 14 ++++-
 drivers/md/dm.c                                    |  1 +
 drivers/media/v4l2-core/v4l2-mem2mem.c             |  4 +-
 drivers/net/dsa/b53/b53_common.c                   |  3 +
 drivers/net/dsa/bcm_sf2.c                          |  3 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  | 62 ++++++++++++++++++-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.h  |  9 +++
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  7 ---
 drivers/net/ethernet/micrel/ks8851_mll.c           | 53 +++-------------
 drivers/nvme/host/core.c                           |  2 +-
 drivers/phy/motorola/phy-mapphone-mdm6600.c        | 27 ++++++++-
 drivers/s390/cio/blacklist.c                       |  5 +-
 drivers/s390/cio/qdio_setup.c                      |  3 +-
 drivers/s390/net/qeth_core_main.c                  | 23 ++++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |  5 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |  6 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.h                   |  2 +
 drivers/spi/spi-bcm63xx-hsspi.c                    |  1 -
 drivers/tty/serial/8250/8250_exar.c                | 33 ++++++++++
 drivers/tty/serial/ar933x_uart.c                   |  8 +++
 drivers/tty/serial/mvebu-uart.c                    |  2 +-
 drivers/tty/vt/selection.c                         | 26 +++++++-
 drivers/tty/vt/vt.c                                |  2 -
 drivers/usb/core/hub.c                             |  8 ++-
 drivers/usb/core/port.c                            | 10 +++-
 drivers/usb/core/quirks.c                          |  3 +
 drivers/usb/dwc3/gadget.c                          |  9 ++-
 drivers/usb/gadget/composite.c                     | 24 ++++++--
 drivers/usb/gadget/function/f_fs.c                 |  5 +-
 drivers/usb/gadget/function/u_serial.c             |  4 +-
 drivers/usb/storage/unusual_devs.h                 |  6 ++
 drivers/video/console/vgacon.c                     |  3 +
 drivers/watchdog/da9062_wdt.c                      |  7 ---
 fs/cifs/inode.c                                    |  6 +-
 fs/fat/inode.c                                     | 19 +++---
 kernel/kprobes.c                                   | 67 +++++++++++++--------
 mm/huge_memory.c                                   |  3 +-
 mm/mprotect.c                                      | 38 +++++++++++-
 sound/hda/ext/hdac_ext_controller.c                |  9 ++-
 sound/pci/hda/patch_realtek.c                      |  5 ++
 sound/soc/codecs/pcm512x.c                         |  8 ++-
 sound/soc/intel/skylake/skl-debug.c                | 32 +++++-----
 sound/soc/soc-dapm.c                               |  2 +-
 sound/soc/soc-pcm.c                                | 16 ++---
 sound/soc/soc-topology.c                           | 17 +++---
 tools/testing/selftests/lib.mk                     | 23 +++----
 .../testing/selftests/net/forwarding/mirror_gre.sh | 25 ++++----
 85 files changed, 700 insertions(+), 349 deletions(-)


