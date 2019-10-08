Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B851DCF2DE
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 08:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbfJHGiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 02:38:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730112AbfJHGiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 02:38:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0F63206BB;
        Tue,  8 Oct 2019 06:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570516686;
        bh=09cMhtRV9mi4Y4oPmunVmdxosbYsnGW5HcgLcjbdT6w=;
        h=Date:From:To:Cc:Subject:From;
        b=SuUBbxJu0x1yItUi67o5yVahfQud609NhEch72n8fYgHtLQL3Gr8kJUv71zhwGWBW
         qFOCzIiIdyE6kXt7NJ+B0wF+O6NtBxfo6KdF/GiA1rnTIQrUkBt3WBtggdaWHbuB+4
         AvBdMDCWk6Ny2BXL8lcvqtdF7UyNCJe7yDpjswZ8=
Date:   Tue, 8 Oct 2019 08:38:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.2.20
Message-ID: <20191008063803.GA2467314@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.2.20 kernel.

All users of the 5.2 kernel series must upgrade.

Note, this is the LAST 5.2 kernel to be released, it is now end-of-life.
You must move to the 5.3.y kernel series at this point in time.

The updated 5.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                |    2=20
 arch/arm/Kconfig                                        |    7=20
 arch/arm/Makefile                                       |    4=20
 arch/arm/mm/fault.c                                     |    4=20
 arch/arm/mm/fault.h                                     |    1=20
 arch/arm/mm/mmap.c                                      |   16 +
 arch/arm/mm/mmu.c                                       |   16 +
 arch/arm64/include/asm/cmpxchg.h                        |    6=20
 arch/arm64/mm/mmap.c                                    |    6=20
 arch/mips/include/asm/atomic.h                          |   19 -
 arch/mips/include/asm/barrier.h                         |   44 ++-
 arch/mips/include/asm/bitops.h                          |   47 ++-
 arch/mips/include/asm/cmpxchg.h                         |   11=20
 arch/mips/include/asm/mipsregs.h                        |    4=20
 arch/mips/kernel/branch.c                               |    2=20
 arch/mips/kernel/cpu-probe.c                            |    7=20
 arch/mips/kernel/syscall.c                              |    1=20
 arch/mips/mm/mmap.c                                     |   14 +
 arch/mips/mm/tlbex.c                                    |    2=20
 arch/powerpc/include/asm/futex.h                        |    3=20
 arch/powerpc/kernel/eeh_driver.c                        |   47 +++
 arch/powerpc/kernel/eeh_event.c                         |    8=20
 arch/powerpc/kernel/eeh_pe.c                            |   23 +
 arch/powerpc/kernel/exceptions-64s.S                    |    4=20
 arch/powerpc/kernel/rtas.c                              |   11=20
 arch/powerpc/kernel/traps.c                             |    1=20
 arch/powerpc/mm/book3s64/radix_pgtable.c                |    2=20
 arch/powerpc/perf/imc-pmu.c                             |   29 +-
 arch/powerpc/platforms/powernv/pci-ioda-tce.c           |   20 -
 arch/powerpc/platforms/powernv/pci.h                    |    2=20
 arch/powerpc/platforms/pseries/mobility.c               |    9=20
 arch/powerpc/platforms/pseries/setup.c                  |    3=20
 arch/powerpc/xmon/xmon.c                                |   17 -
 arch/s390/hypfs/inode.c                                 |    9=20
 arch/x86/kvm/hyperv.c                                   |   12 -
 drivers/base/regmap/Kconfig                             |    2=20
 drivers/block/pktcdvd.c                                 |    1=20
 drivers/char/ipmi/ipmi_si_intf.c                        |   24 +-
 drivers/clk/actions/owl-common.c                        |    5=20
 drivers/clk/at91/clk-main.c                             |   10=20
 drivers/clk/clk-bulk.c                                  |    5=20
 drivers/clk/clk-qoriq.c                                 |    2=20
 drivers/clk/imx/clk-imx8mq.c                            |    3=20
 drivers/clk/imx/clk-pll14xx.c                           |   27 ++
 drivers/clk/meson/axg-audio.c                           |    7=20
 drivers/clk/qcom/gcc-sdm845.c                           |    4=20
 drivers/clk/renesas/clk-mstp.c                          |    3=20
 drivers/clk/renesas/renesas-cpg-mssr.c                  |    3=20
 drivers/clk/sirf/clk-common.c                           |   12 -
 drivers/clk/sprd/common.c                               |    5=20
 drivers/clk/sprd/pll.c                                  |    2=20
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c                    |    3=20
 drivers/clk/zte/clk-zx296718.c                          |  109 ++++-----
 drivers/crypto/hisilicon/sec/sec_algs.c                 |   13 -
 drivers/dma-buf/sw_sync.c                               |   16 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c                  |    7=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c                 |    3=20
 drivers/gpu/drm/amd/amdgpu/si.c                         |    6=20
 drivers/gpu/drm/amd/display/dc/core/dc.c                |    8=20
 drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c      |    4=20
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c       |   17 -
 drivers/gpu/drm/amd/display/dc/dc_types.h               |    1=20
 drivers/gpu/drm/amd/display/dc/dce/dce_audio.c          |    4=20
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c  |    3=20
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c |   27 +-
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c      |    9=20
 drivers/gpu/drm/bridge/tc358767.c                       |    2=20
 drivers/gpu/drm/nouveau/dispnv50/wndw.c                 |    4=20
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/volt.c         |    2=20
 drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c   |   13 +
 drivers/gpu/drm/panel/panel-simple.c                    |    6=20
 drivers/gpu/drm/radeon/radeon_connectors.c              |    2=20
 drivers/gpu/drm/radeon/radeon_drv.c                     |    8=20
 drivers/gpu/drm/stm/ltdc.c                              |    2=20
 drivers/gpu/drm/tinydrm/Kconfig                         |    8=20
 drivers/gpu/drm/vkms/vkms_crc.c                         |   27 +-
 drivers/gpu/drm/vkms/vkms_crtc.c                        |    9=20
 drivers/gpu/drm/vkms/vkms_drv.c                         |    2=20
 drivers/gpu/drm/vkms/vkms_drv.h                         |    6=20
 drivers/gpu/drm/vkms/vkms_output.c                      |    6=20
 drivers/gpu/drm/vkms/vkms_plane.c                       |    4=20
 drivers/hid/hid-apple.c                                 |   49 ++--
 drivers/hid/wacom_sys.c                                 |    7=20
 drivers/hid/wacom_wac.c                                 |    4=20
 drivers/i2c/busses/i2c-cht-wc.c                         |   46 +++
 drivers/mailbox/mtk-cmdq-mailbox.c                      |    5=20
 drivers/mailbox/qcom-apcs-ipc-mailbox.c                 |    8=20
 drivers/md/dm-raid.c                                    |   10=20
 drivers/mfd/intel-lpss-pci.c                            |    2=20
 drivers/net/dsa/rtl8366.c                               |   11=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c          |    9=20
 drivers/net/ethernet/qlogic/qla3xxx.c                   |    1=20
 drivers/net/usb/hso.c                                   |   12 -
 drivers/net/usb/qmi_wwan.c                              |    1=20
 drivers/net/xen-netfront.c                              |   17 -
 drivers/pci/Kconfig                                     |    2=20
 drivers/pci/controller/dwc/pci-exynos.c                 |    2=20
 drivers/pci/controller/dwc/pci-imx6.c                   |    4=20
 drivers/pci/controller/dwc/pci-layerscape-ep.c          |    1=20
 drivers/pci/controller/dwc/pcie-histb.c                 |    4=20
 drivers/pci/controller/pci-tegra.c                      |   22 +
 drivers/pci/controller/pcie-rockchip-host.c             |   16 -
 drivers/pci/hotplug/rpaphp_core.c                       |   18 -
 drivers/pci/pci-bridge-emul.c                           |    4=20
 drivers/pci/pci.c                                       |    4=20
 drivers/pinctrl/meson/pinctrl-meson-gxbb.c              |   12 -
 drivers/pinctrl/pinctrl-amd.c                           |   12 -
 drivers/pinctrl/pinctrl-stmfx.c                         |   24 +-
 drivers/pinctrl/tegra/pinctrl-tegra.c                   |    4=20
 drivers/ptp/ptp_qoriq.c                                 |    3=20
 drivers/rtc/rtc-pcf85363.c                              |    7=20
 drivers/rtc/rtc-snvs.c                                  |   11=20
 drivers/scsi/scsi_logging.c                             |   48 ----
 drivers/soundwire/Kconfig                               |    7=20
 drivers/soundwire/Makefile                              |    2=20
 drivers/soundwire/intel.c                               |   10=20
 drivers/vfio/pci/vfio_pci.c                             |   17 +
 drivers/video/fbdev/ssd1307fb.c                         |    2=20
 fs/9p/cache.c                                           |    2=20
 fs/ext4/block_validity.c                                |  189 +++++++++++=
-----
 fs/ext4/ext4.h                                          |   10=20
 fs/f2fs/super.c                                         |   14 +
 fs/fat/dir.c                                            |   13 -
 fs/fat/fatent.c                                         |    3=20
 fs/fs_context.c                                         |    4=20
 fs/ocfs2/dlm/dlmunlock.c                                |   23 +
 fs/pstore/ram.c                                         |    2=20
 include/linux/mailbox/mtk-cmdq-mailbox.h                |    3=20
 include/linux/pci.h                                     |    3=20
 include/linux/soc/mediatek/mtk-cmdq.h                   |    3=20
 include/scsi/scsi_dbg.h                                 |    2=20
 include/trace/events/rxrpc.h                            |    2=20
 kernel/kexec_core.c                                     |    2=20
 kernel/livepatch/core.c                                 |    1=20
 lib/Kconfig.debug                                       |    2=20
 net/core/sock.c                                         |   11=20
 net/ipv4/ip_gre.c                                       |    1=20
 net/ipv4/route.c                                        |    5=20
 net/ipv4/tcp_timer.c                                    |    9=20
 net/ipv4/udp.c                                          |   11=20
 net/ipv6/addrconf.c                                     |   17 +
 net/ipv6/ip6_input.c                                    |   10=20
 net/ipv6/udp.c                                          |    9=20
 net/nfc/llcp_sock.c                                     |    7=20
 net/nfc/netlink.c                                       |    6=20
 net/rds/ib.c                                            |    6=20
 net/sched/sch_cbq.c                                     |   43 ++-
 net/sched/sch_cbs.c                                     |    2=20
 net/sched/sch_dsmark.c                                  |    2=20
 net/sched/sch_taprio.c                                  |    5=20
 net/tipc/link.c                                         |   29 +-
 net/tipc/msg.c                                          |    5=20
 net/vmw_vsock/af_vsock.c                                |   16 +
 net/vmw_vsock/hyperv_transport.c                        |    2=20
 net/vmw_vsock/virtio_transport_common.c                 |    2=20
 security/selinux/hooks.c                                |    2=20
 security/selinux/include/objsec.h                       |   20 -
 security/smack/smack_access.c                           |    6=20
 security/smack/smack_lsm.c                              |    7=20
 tools/testing/selftests/net/udpgso.c                    |   16 -
 tools/testing/selftests/powerpc/tm/tm.h                 |    3=20
 usr/Makefile                                            |    3=20
 162 files changed, 1200 insertions(+), 610 deletions(-)

Abel Vesa (1):
      clk: imx8mq: Mark AHB clock as critical

Ahmad Fatoum (1):
      drm/stm: attach gem fence to atomic state

Alexandre Ghiti (4):
      arm64: consider stack randomization for mmap base only when necessary
      mips: properly account for stack randomization and stack guard gap
      arm: properly account for stack randomization and stack guard gap
      arm: use STACK_TOP when computing mmap base address

Alexandre Torgue (1):
      pinctrl: stmfx: update pinconf settings

Alexey Kardashevskiy (1):
      powerpc/powernv/ioda2: Allocate TCE table levels on demand for defaul=
t DMA window

Andrey Grodzovsky (1):
      drm/amdgpu: Fix hard hang for S/G display BOs.

Andrey Konovalov (1):
      NFC: fix attrs checks in netlink interface

Andrey Smirnov (1):
      drm/bridge: tc358767: Increase AUX transfer length limit

Anson Huang (1):
      rtc: snvs: fix possible race condition

Anthony Koo (2):
      drm/amd/display: add monitor patch to add T7 delay
      drm/amd/display: fix issue where 252-255 values are clipped

Arnd Bergmann (1):
      arm64: fix unreachable code issue with cmpxchg

Bart Van Assche (1):
      scsi: core: Reduce memory required for SCSI logging

Bayan Zabihiyan (1):
      drm/amd/display: Fix frames_to_insert math

Ben Skeggs (1):
      drm/nouveau/kms/tu102-: disable input lut when input is already FP16

Bharath Vedartham (1):
      9p/cache.c: Fix memory leak in v9fs_cache_session_get_cookie

Bibby Hsieh (1):
      mailbox: mediatek: cmdq: clear the event in cmdq initial flow

Biwen Li (1):
      rtc: pcf85363/pcf85263: fix regmap error in set_time

Bjorn Andersson (1):
      clk: Make clk_bulk_get_all() return a valid "id"

Changwei Ge (1):
      ocfs2: wait for recovering done after direct unlock request

Chao Yu (1):
      f2fs: fix to drop meta/node pages during umount

Charlene Liu (1):
      drm/amd/display: support spdif

Chris Wilson (1):
      dma-buf/sw_sync: Synchronize signal vs syncpt free

Christophe Leroy (1):
      powerpc/futex: Fix warning: 'oldval' may be used uninitialized in thi=
s function

Chunyan Zhang (1):
      clk: sprd: add missing kfree

Corey Minyard (1):
      ipmi_si: Only schedule continuously in the thread in maintenance mode

C=E9dric Le Goater (1):
      powerpc/xmon: Check for HV mode when dumping XIVE info from OPAL

Daniel Drake (1):
      pinctrl: amd: disable spurious-firing GPIO IRQs

Daniel Vetter (1):
      drm/vkms: Fix crc worker races

David Ahern (1):
      ipv6: Handle missing host route in __ipv6_ifa_notify

David Howells (2):
      rxrpc: Fix rxrpc_recvmsg tracepoint
      hypfs: Fix error number left in struct pointer member

Deepa Dinamani (1):
      pstore: fs superblock limits

Dexuan Cui (1):
      vsock: Fix a lockdep warning in __vsock_release()

Dongli Zhang (1):
      xen-netfront: do not use ~0U as error return value for xennet_fill_fr=
ags()

Dotan Barak (1):
      net/rds: Fix error handling in rds_ib_add_one()

Eric Biggers (2):
      smack: use GFP_NOFS while holding inode_smack::smk_lock
      vfs: set fs_context::user_ns for reconfigure

Eric Dumazet (5):
      ipv6: drop incoming packets having a v4mapped source address
      nfc: fix memory leak in llcp_sock_bind()
      sch_cbq: validate TCA_CBQ_WRROPT to avoid crash
      sch_dsmark: fix potential NULL deref in dsmark_init()
      tcp: adjust rto_base in retransmits_timed_out()

Eugen Hristev (1):
      clk: at91: select parent if main oscillator or bypass is enabled

Ganesh Goudar (1):
      powerpc: dump kernel log before carrying out fadump or kdump

Geert Uytterhoeven (2):
      clk: renesas: mstp: Set GENPD_FLAG_ALWAYS_ON for clock domain
      clk: renesas: cpg-mssr: Set GENPD_FLAG_ALWAYS_ON for clock domain

Greg Kroah-Hartman (1):
      Linux 5.2.20

Greg Thelen (1):
      kbuild: clean compressed initramfs image

Gustavo Romero (1):
      selftests/powerpc: Retry on host facility unavailable

Haishuang Yan (1):
      erspan: remove the incorrect mtu limit for erspan

Hans de Goede (1):
      i2c-cht-wc: Fix lockdep warning

Icenowy Zheng (1):
      clk: sunxi-ng: v3s: add missing clock slices for MMC2 module clocks

Jann Horn (1):
      Smack: Don't ignore other bprm->unsafe flags if LSM_UNSAFE_PTRACE is =
set

Jason Gerecke (1):
      HID: wacom: Fix several minor compiler warnings

Jean Delvare (1):
      drm/amdgpu/si: fix ASIC tests

Jens Axboe (1):
      pktcdvd: remove warning on attempting to register non-passthrough dev

Jia-Ju Bai (2):
      gpu: drm: radeon: Fix a possible null-pointer dereference in radeon_c=
onnector_set_property()
      security: smack: Fix possible null-pointer dereferences in smack_sock=
et_sock_rcv_skb()

Joao Moreno (1):
      HID: apple: Fix stuck function keys when using FN

Johan Hovold (1):
      hso: fix NULL-deref on tty open

Jorge Ramirez-Ortiz (1):
      mbox: qcom: add APCS child device for QCS404

Josh Hunt (2):
      udp: fix gso_segs calculations
      udp: only do GSO if # of segs > 1

Kai-Heng Feng (1):
      mfd: intel-lpss: Remove D3cold delay

Krzysztof Wilczynski (2):
      PCI: Add pci_info_ratelimited() to ratelimit PCI separately
      PCI: Use static const struct, not const static struct

KyleMahlkuch (1):
      drm/radeon: Fix EEH during kexec

Lewis Huang (1):
      drm/amd/display: reprogram VM config when system resume

Linus Walleij (1):
      net: dsa: rtl8366: Check VLAN ID and not ports

Lucas Stach (1):
      drm/panel: simple: fix AUO g185han01 horizontal blanking

Mark Menzynski (1):
      drm/nouveau/volt: Fix for some cards having 0 maximum voltage

Marko Kohtala (1):
      video: ssd1307fb: Start page range at page_offset

Martin KaFai Lau (1):
      net: Unpublish sk from sk_reuseport_cb before call_rcu

Mike Rapoport (1):
      ARM: 8903/1: ensure that usable memory in bank 0 starts from a PMD-al=
igned address

Ming Lei (1):
      dm raid: fix updating of max_discard_sectors limit

Miroslav Benes (1):
      livepatch: Nullify obj->mod in klp_module_coming()'s error path

Nathan Chancellor (4):
      PCI: rpaphp: Avoid a sometimes-uninitialized warning
      MIPS: Don't use bc_false uninitialized in __mm_isBranchInstr
      MIPS: tlbex: Explicitly cast _PAGE_NO_EXEC to a boolean
      ARM: 8905/1: Emit __gnu_mcount_nc when using Clang 10.0.0 or newer

Nathan Huckleberry (1):
      clk: qoriq: Fix -Wunused-const-variable

Nathan Lynch (3):
      powerpc/rtas: use device model APIs and serialization during LPM
      powerpc/pseries/mobility: use cond_resched when updating device tree
      powerpc/pseries: correctly track irq state in default idle

Navid Emamdoost (2):
      net: qlogic: Fix memory leak in ql_alloc_large_buffers
      drm/panel: check failure cases in the probe func

Nicholas Piggin (3):
      powerpc/64s/radix: Fix memory hotplug section page table creation
      powerpc/perf: fix imc allocation failure handling
      powerpc/64s/exception: machine check use correct cfar for late handler

Nick Desaulniers (1):
      ARM: 8875/1: Kconfig: default to AEABI w/ Clang

Nicolas Boichat (1):
      kmemleak: increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE default to 16K

Nishka Dasgupta (1):
      PCI: tegra: Fix OF node reference leak

Noralf Tr=F8nnes (1):
      drm/tinydrm/Kconfig: drivers: Select BACKLIGHT_CLASS_DEVICE

OGAWA Hirofumi (1):
      fat: work around race with userspace's read via blockdev while mounti=
ng

Oliver O'Halloran (1):
      powerpc/eeh: Clean up EEH PEs after recovery finishes

Otto Meier (1):
      pinctrl: meson-gxbb: Fix wrong pinning definition for uart_c

Paolo Abeni (1):
      net: ipv4: avoid mixed n_redirects and rate_tokens usage

Peng Fan (2):
      clk: imx: pll14xx: avoid glitch when set rate
      clk: imx: clk-pll14xx: unbypass PLL by default

Peter Zijlstra (2):
      mips/atomic: Fix loongson_llsc_mb() wreckage
      mips/atomic: Fix smp_mb__{before,after}_atomic()

Pierre-Louis Bossart (2):
      soundwire: intel: fix channel number reported by hardware
      soundwire: fix regmap dependencies and align with other serial links

Randy Dunlap (1):
      PCI: pci-hyperv: Fix build errors on non-SYSFS config

Reinhard Speyerer (1):
      qmi_wwan: add support for Cinterion CLS8 devices

Rodrigo Siqueira (1):
      drm/vkms: Avoid assigning 0 for possible_crtc

Sam Bobroff (1):
      powerpc/eeh: Clear stale EEH_DEV_NO_HANDLER flag

Sean Paul (1):
      drm/rockchip: Check for fast link training before enabling psr

Sowjanya Komatineni (1):
      pinctrl: tegra: Fix write barrier placement in pmx_writel

Stephen Boyd (6):
      clk: actions: Don't reference clk_init_data after registration
      clk: sirf: Don't reference clk_init_data after registration
      clk: meson: axg-audio: Don't reference clk_init_data after registrati=
on
      clk: sprd: Don't reference clk_init_data after registration
      clk: zx296718: Don't reference clk_init_data after registration
      clk: qcom: gcc-sdm845: Use floor ops for sdcc clks

Stephen Smalley (1):
      selinux: fix residual uses of current_security() for the SELinux blob

Tetsuo Handa (1):
      kexec: bail out upon SIGKILL when allocating memory.

Thierry Reding (4):
      PCI: rockchip: Propagate errors for optional regulators
      PCI: histb: Propagate errors for optional regulators
      PCI: imx6: Propagate errors for optional regulators
      PCI: exynos: Propagate errors for optional PHYs

Tuong Lien (1):
      tipc: fix unlimited bundling of small messages

Vishal Kulkarni (1):
      cxgb4:Fix out-of-bounds MSI-X info array access

Vladimir Oltean (4):
      net: sched: taprio: Fix potential integer overflow in taprio_set_pico=
s_per_byte
      ptp_qoriq: Initialize the registers' spinlock before calling ptp_qori=
q_settime
      net: sched: cbs: Avoid division by zero when calculating the port rate
      net: sched: taprio: Avoid division by zero on invalid link speed

Wanpeng Li (1):
      KVM: hyperv: Fix Direct Synthetic timers assert an interrupt w/o lapi=
c_in_kernel

Will Deacon (1):
      ARM: 8898/1: mm: Don't treat faults reported from cache maintenance a=
s writes

Xiaowei Bao (1):
      PCI: layerscape: Add the bar_fixed_64bit property to the endpoint dri=
ver

Yunfeng Ye (1):
      crypto: hisilicon - Fix double free in sec_free_hw_sgl()

Zhou Yanjie (1):
      MIPS: Ingenic: Disable broken BTB lookup optimization.

hexin (1):
      vfio_pci: Restore original state on release

zhangyi (F) (1):
      ext4: fix potential use after free after remounting with noblock_vali=
dity


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2cLssACgkQONu9yGCS
aT6tdBAAxNhUAW0OpClGOuTifSX4dXcmdCzNzva9BzK+UFgGeNM2K7DYPiUKPTl4
GMgfmNDvJBeoVoKsGZBG4oP60QEyMZAg4mCcaETpdWlgmhDFjHQMfFmCE4g6GcIj
o8Wui3k9iglZxhBAbNXoeq8X6D44QKHHqeMBizmGRRJNYI9uHHcu524CEBEU1/L1
cqVEWy/J/OLY0kO1LTVRayBg/lUpPc13OegqntFDaTFjAfmjvMNWkDSDSTrlLVcQ
BUtEKyonmvw4nj6sdyG4kg5eoFKF+SA8uj+XbvkSERM8F2A31aAHHsYfJP/T/vrS
JYpVZtD2nzN6ySIWexDt1N/6blQlZyIA4xBZFGI1mIEIqaCLhqZerPro9Sa22q9i
cabH2u85S8Wt9ysnxAeXTaa+alR9SxkDhj8P91n3bQRxQyedLCyrXDS7E8Fyrn7z
f2NP+Gu5+Ln6NsuQraw9Gf5JNiOcRSdaP3ui9L3d9qQxcY1tWXy7qb6c3tYy81bc
HppHuQhQbJxtDkPq+JM6vokRrKtQozLdWV418jAU9rPgCsLwegzyfUFGNTPlwWtZ
61BphJhZyVccl5/4IQh9Vzwte3qguZgiJEWqEiE6AJLBRxR0S+rHoLB6NIOCeqL/
t1I9NSU/dpzDrZDsIwIUL9AXCgd8qvUgCg8RFUgOphQ2x5l7rGI=
=dIHH
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
