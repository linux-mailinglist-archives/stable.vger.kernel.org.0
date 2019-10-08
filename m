Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8456CF2D8
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 08:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbfJHGh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 02:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730090AbfJHGhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 02:37:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B632D206BB;
        Tue,  8 Oct 2019 06:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570516644;
        bh=UsqBz0tZqS/Xwre7lv0iWnswxwuFkFUfdS/YNPCydNU=;
        h=Date:From:To:Cc:Subject:From;
        b=wLOyi9kIATQ7yRoXRpCL9cQZuVFmPpmdJu0AlstJ4M0u/ZJJ7AGjDiWt8sc/zogI5
         ud0l0fWnl21MAsuO2b4LNmsXjcXIBxUURidGZjb5bTzFiQG3+b1FhzRWKH8zVCBBaU
         Q/AowwM54SvIfZKd5cUNhwx36LPg+0jWlBjH819U=
Date:   Tue, 8 Oct 2019 08:37:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.78
Message-ID: <20191008063721.GA2467189@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.78 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                               |    2=20
 arch/arm/Kconfig                                       |    5=20
 arch/arm/mm/fault.c                                    |    4=20
 arch/arm/mm/fault.h                                    |    1=20
 arch/arm/mm/mmap.c                                     |   16 +
 arch/arm/mm/mmu.c                                      |   16 +
 arch/arm64/include/asm/cmpxchg.h                       |    6=20
 arch/arm64/mm/mmap.c                                   |    6=20
 arch/mips/include/asm/mipsregs.h                       |    4=20
 arch/mips/kernel/cpu-probe.c                           |    7=20
 arch/mips/mm/mmap.c                                    |   14 +
 arch/mips/mm/tlbex.c                                   |    2=20
 arch/powerpc/include/asm/futex.h                       |    3=20
 arch/powerpc/kernel/eeh_driver.c                       |   11=20
 arch/powerpc/kernel/exceptions-64s.S                   |    4=20
 arch/powerpc/kernel/rtas.c                             |   11=20
 arch/powerpc/kernel/traps.c                            |    1=20
 arch/powerpc/platforms/powernv/pci-ioda-tce.c          |   20 -
 arch/powerpc/platforms/powernv/pci.h                   |    2=20
 arch/powerpc/platforms/pseries/mobility.c              |    9=20
 arch/powerpc/platforms/pseries/setup.c                 |    3=20
 arch/powerpc/xmon/xmon.c                               |   15 -
 arch/s390/hypfs/inode.c                                |    9=20
 block/mq-deadline.c                                    |   23 +-
 drivers/base/regmap/Kconfig                            |    2=20
 drivers/block/pktcdvd.c                                |    1=20
 drivers/char/ipmi/ipmi_si_intf.c                       |   24 +-
 drivers/char/tpm/tpm-chip.c                            |    5=20
 drivers/char/tpm/tpm-sysfs.c                           |  134 +++++++-----
 drivers/clk/actions/owl-common.c                       |    5=20
 drivers/clk/at91/clk-main.c                            |   10=20
 drivers/clk/clk-qoriq.c                                |    2=20
 drivers/clk/qcom/gcc-sdm845.c                          |    4=20
 drivers/clk/renesas/clk-mstp.c                         |    3=20
 drivers/clk/renesas/renesas-cpg-mssr.c                 |    3=20
 drivers/clk/sirf/clk-common.c                          |   12 -
 drivers/clk/sprd/common.c                              |    5=20
 drivers/clk/sprd/pll.c                                 |    2=20
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c                   |    3=20
 drivers/clk/zte/clk-zx296718.c                         |  109 ++++-----
 drivers/crypto/hisilicon/sec/sec_algs.c                |   13 -
 drivers/dma-buf/sw_sync.c                              |   16 -
 drivers/gpu/drm/amd/amdgpu/si.c                        |    6=20
 drivers/gpu/drm/amd/display/dc/core/dc.c               |    8=20
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c      |   17 -
 drivers/gpu/drm/amd/display/dc/dce/dce_audio.c         |    4=20
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c |    3=20
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c     |    9=20
 drivers/gpu/drm/bridge/tc358767.c                      |    2=20
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/volt.c        |    2=20
 drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c  |   13 +
 drivers/gpu/drm/panel/panel-simple.c                   |    6=20
 drivers/gpu/drm/radeon/radeon_connectors.c             |    2=20
 drivers/gpu/drm/radeon/radeon_drv.c                    |    8=20
 drivers/gpu/drm/stm/ltdc.c                             |    2=20
 drivers/hid/hid-apple.c                                |   49 ++--
 drivers/hid/wacom_sys.c                                |    7=20
 drivers/hid/wacom_wac.c                                |    4=20
 drivers/i2c/busses/i2c-cht-wc.c                        |   46 ++++
 drivers/mailbox/qcom-apcs-ipc-mailbox.c                |    8=20
 drivers/mfd/intel-lpss-pci.c                           |    2=20
 drivers/net/dsa/rtl8366.c                              |   11=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c         |    9=20
 drivers/net/ethernet/qlogic/qla3xxx.c                  |    1=20
 drivers/net/usb/hso.c                                  |   12 -
 drivers/net/usb/qmi_wwan.c                             |    1=20
 drivers/net/xen-netfront.c                             |   17 -
 drivers/pci/controller/dwc/pci-exynos.c                |    2=20
 drivers/pci/controller/dwc/pci-imx6.c                  |    4=20
 drivers/pci/controller/dwc/pcie-histb.c                |    4=20
 drivers/pci/controller/pci-tegra.c                     |   22 +
 drivers/pci/controller/pcie-rockchip-host.c            |   16 -
 drivers/pci/hotplug/rpaphp_core.c                      |   18 -
 drivers/pinctrl/meson/pinctrl-meson-gxbb.c             |   12 -
 drivers/pinctrl/pinctrl-amd.c                          |   12 -
 drivers/pinctrl/tegra/pinctrl-tegra.c                  |    4=20
 drivers/rtc/rtc-pcf85363.c                             |    7=20
 drivers/rtc/rtc-snvs.c                                 |   11=20
 drivers/scsi/scsi_logging.c                            |   48 ----
 drivers/soundwire/Kconfig                              |    9=20
 drivers/soundwire/Makefile                             |    2=20
 drivers/soundwire/intel.c                              |   10=20
 drivers/vfio/pci/vfio_pci.c                            |   17 +
 drivers/video/fbdev/ssd1307fb.c                        |    2=20
 fs/9p/cache.c                                          |    2=20
 fs/ext4/block_validity.c                               |  189 ++++++++++++=
-----
 fs/ext4/ext4.h                                         |   10=20
 fs/fat/dir.c                                           |   13 -
 fs/fat/fatent.c                                        |    3=20
 fs/ocfs2/dlm/dlmunlock.c                               |   23 +-
 fs/pstore/ram.c                                        |    2=20
 include/scsi/scsi_dbg.h                                |    2=20
 include/trace/events/rxrpc.h                           |    2=20
 kernel/bpf/syscall.c                                   |   28 +-
 kernel/kexec_core.c                                    |    2=20
 kernel/livepatch/core.c                                |    1=20
 lib/Kconfig.debug                                      |    2=20
 net/core/sock.c                                        |   11=20
 net/ipv4/ip_gre.c                                      |    1=20
 net/ipv4/route.c                                       |    5=20
 net/ipv4/udp.c                                         |   11=20
 net/ipv6/addrconf.c                                    |   17 +
 net/ipv6/ip6_input.c                                   |   10=20
 net/ipv6/udp.c                                         |    9=20
 net/nfc/llcp_sock.c                                    |    7=20
 net/nfc/netlink.c                                      |    6=20
 net/rds/ib.c                                           |    6=20
 net/sched/sch_cbq.c                                    |   40 ++-
 net/sched/sch_dsmark.c                                 |    2=20
 net/tipc/link.c                                        |   29 +-
 net/tipc/msg.c                                         |    5=20
 net/vmw_vsock/af_vsock.c                               |   16 +
 net/vmw_vsock/hyperv_transport.c                       |    2=20
 net/vmw_vsock/virtio_transport_common.c                |    2=20
 security/smack/smack_access.c                          |    6=20
 security/smack/smack_lsm.c                             |    7=20
 tools/testing/selftests/net/udpgso.c                   |   16 -
 usr/Makefile                                           |    3=20
 118 files changed, 964 insertions(+), 522 deletions(-)

Ahmad Fatoum (1):
      drm/stm: attach gem fence to atomic state

Alexandre Ghiti (4):
      arm64: consider stack randomization for mmap base only when necessary
      mips: properly account for stack randomization and stack guard gap
      arm: properly account for stack randomization and stack guard gap
      arm: use STACK_TOP when computing mmap base address

Alexey Kardashevskiy (1):
      powerpc/powernv/ioda2: Allocate TCE table levels on demand for defaul=
t DMA window

Andrey Konovalov (1):
      NFC: fix attrs checks in netlink interface

Andrey Smirnov (1):
      drm/bridge: tc358767: Increase AUX transfer length limit

Anson Huang (1):
      rtc: snvs: fix possible race condition

Anthony Koo (1):
      drm/amd/display: fix issue where 252-255 values are clipped

Arnd Bergmann (1):
      arm64: fix unreachable code issue with cmpxchg

Bart Van Assche (1):
      scsi: core: Reduce memory required for SCSI logging

Bharath Vedartham (1):
      9p/cache.c: Fix memory leak in v9fs_cache_session_get_cookie

Biwen Li (1):
      rtc: pcf85363/pcf85263: fix regmap error in set_time

Changwei Ge (1):
      ocfs2: wait for recovering done after direct unlock request

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

Damien Le Moal (1):
      block: mq-deadline: Fix queue restart handling

Daniel Borkmann (1):
      bpf: fix use after free in prog symbol exposure

Daniel Drake (1):
      pinctrl: amd: disable spurious-firing GPIO IRQs

David Ahern (1):
      ipv6: Handle missing host route in __ipv6_ifa_notify

David Howells (2):
      hypfs: Fix error number left in struct pointer member
      rxrpc: Fix rxrpc_recvmsg tracepoint

Deepa Dinamani (1):
      pstore: fs superblock limits

Dexuan Cui (1):
      vsock: Fix a lockdep warning in __vsock_release()

Dongli Zhang (1):
      xen-netfront: do not use ~0U as error return value for xennet_fill_fr=
ags()

Dotan Barak (1):
      net/rds: Fix error handling in rds_ib_add_one()

Eric Biggers (1):
      smack: use GFP_NOFS while holding inode_smack::smk_lock

Eric Dumazet (4):
      ipv6: drop incoming packets having a v4mapped source address
      nfc: fix memory leak in llcp_sock_bind()
      sch_dsmark: fix potential NULL deref in dsmark_init()
      sch_cbq: validate TCA_CBQ_WRROPT to avoid crash

Eugen Hristev (1):
      clk: at91: select parent if main oscillator or bypass is enabled

Ganesh Goudar (1):
      powerpc: dump kernel log before carrying out fadump or kdump

Geert Uytterhoeven (2):
      clk: renesas: mstp: Set GENPD_FLAG_ALWAYS_ON for clock domain
      clk: renesas: cpg-mssr: Set GENPD_FLAG_ALWAYS_ON for clock domain

Greg Kroah-Hartman (1):
      Linux 4.19.78

Greg Thelen (1):
      kbuild: clean compressed initramfs image

Haishuang Yan (1):
      erspan: remove the incorrect mtu limit for erspan

Hans de Goede (1):
      i2c-cht-wc: Fix lockdep warning

Icenowy Zheng (1):
      clk: sunxi-ng: v3s: add missing clock slices for MMC2 module clocks

Jann Horn (1):
      Smack: Don't ignore other bprm->unsafe flags if LSM_UNSAFE_PTRACE is =
set

Jarkko Sakkinen (1):
      tpm: use tpm_try_get_ops() in tpm-sysfs.c.

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

Miroslav Benes (1):
      livepatch: Nullify obj->mod in klp_module_coming()'s error path

Nathan Chancellor (2):
      PCI: rpaphp: Avoid a sometimes-uninitialized warning
      MIPS: tlbex: Explicitly cast _PAGE_NO_EXEC to a boolean

Nathan Huckleberry (1):
      clk: qoriq: Fix -Wunused-const-variable

Nathan Lynch (3):
      powerpc/rtas: use device model APIs and serialization during LPM
      powerpc/pseries/mobility: use cond_resched when updating device tree
      powerpc/pseries: correctly track irq state in default idle

Navid Emamdoost (2):
      drm/panel: check failure cases in the probe func
      net: qlogic: Fix memory leak in ql_alloc_large_buffers

Nicholas Piggin (1):
      powerpc/64s/exception: machine check use correct cfar for late handler

Nick Desaulniers (1):
      ARM: 8875/1: Kconfig: default to AEABI w/ Clang

Nicolas Boichat (1):
      kmemleak: increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE default to 16K

Nishka Dasgupta (1):
      PCI: tegra: Fix OF node reference leak

OGAWA Hirofumi (1):
      fat: work around race with userspace's read via blockdev while mounti=
ng

Otto Meier (1):
      pinctrl: meson-gxbb: Fix wrong pinning definition for uart_c

Paolo Abeni (1):
      net: ipv4: avoid mixed n_redirects and rate_tokens usage

Pierre-Louis Bossart (3):
      soundwire: intel: fix channel number reported by hardware
      soundwire: Kconfig: fix help format
      soundwire: fix regmap dependencies and align with other serial links

Reinhard Speyerer (1):
      qmi_wwan: add support for Cinterion CLS8 devices

Sam Bobroff (1):
      powerpc/eeh: Clear stale EEH_DEV_NO_HANDLER flag

Sean Paul (1):
      drm/rockchip: Check for fast link training before enabling psr

Sowjanya Komatineni (1):
      pinctrl: tegra: Fix write barrier placement in pmx_writel

Stephen Boyd (5):
      clk: actions: Don't reference clk_init_data after registration
      clk: sirf: Don't reference clk_init_data after registration
      clk: sprd: Don't reference clk_init_data after registration
      clk: zx296718: Don't reference clk_init_data after registration
      clk: qcom: gcc-sdm845: Use floor ops for sdcc clks

Tetsuo Handa (1):
      kexec: bail out upon SIGKILL when allocating memory.

Thierry Reding (4):
      PCI: rockchip: Propagate errors for optional regulators
      PCI: histb: Propagate errors for optional regulators
      PCI: imx6: Propagate errors for optional regulators
      PCI: exynos: Propagate errors for optional PHYs

Tuong Lien (1):
      tipc: fix unlimited bundling of small messages

Vadim Sukhomlinov (1):
      tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM operations

Vishal Kulkarni (1):
      cxgb4:Fix out-of-bounds MSI-X info array access

Will Deacon (1):
      ARM: 8898/1: mm: Don't treat faults reported from cache maintenance a=
s writes

Yunfeng Ye (1):
      crypto: hisilicon - Fix double free in sec_free_hw_sgl()

Zhou Yanjie (1):
      MIPS: Ingenic: Disable broken BTB lookup optimization.

hexin (1):
      vfio_pci: Restore original state on release

zhangyi (F) (1):
      ext4: fix potential use after free after remounting with noblock_vali=
dity


--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2cLqEACgkQONu9yGCS
aT7MlA//cMa3QC27KFXSlhU+1F1VMSkex7ueI0F/w0DI5NamMfNdS8LZRdBLTKKD
zIozZCNmtu0JCeFRRVqIMDc5Ah7p3Uu79nef5sbjyNHsebFLp/Rdd2zTGKfClgFC
1Z3ZramPM0MOKMKG5mDF5gw0vcDK3dyVR0Q2xjA1iDRsE11slaDd2f+CQ1GHqUDp
VSrLSevFmxkjyxwTOurAwghwxOaMiTjNH/QWTiuQ5V+8K9XDBQ5gtWlazIDV2inJ
tjYfWbNL/cVzuUsfmUeOuRdjmbWetohAMb7GDRdhmQo1sk4+aXYNhu4II7qL26E/
OB6VFl25DSkbvataf6LSbMgtAPIf9c7xm81F2vqJ/sWQkqiJg5XTZUrivh2bVCDj
VdDDockhz6AzkcDy6TLQXiMtS543gqDUoB0mZmT+ZzUjlB3Kz5994sBLEIPxdWfA
OXxJN6uH5sxqpkUcd+EFjBXRspg4TXWwOM/MqRf3yTEi+dtA+p78OzkHAquT2A/L
S5bRPPJ+P1LICUajnpoHZhZD2Utb8D1oxyNOmn53MeSACODOoPbohPWIsBTsZWaZ
l+fXCUt9RlQ9gJnaF96QuKvcmzd3j4iG6Tl1oUUeRpaqzm1X7h0wq/Ib+L0LTa+y
ScBJU9pBkhwIKLfkxny+r7zIvgnD4RF4Pi+cElbY/1KZXsVd3dY=
=AFTL
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
