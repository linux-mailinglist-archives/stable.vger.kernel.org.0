Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1B240C135
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 10:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236735AbhIOIIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 04:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236757AbhIOIIm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 04:08:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31AE3608FB;
        Wed, 15 Sep 2021 08:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631693243;
        bh=fahoGb6nKXmdv+eac3BX1oKs8veW/WBAUW6TQ0FV/rI=;
        h=From:To:Cc:Subject:Date:From;
        b=U8vzWVJaZGwGeXXIGiaJmFIdqIUFrhBGQ15qcqcUmO/QNdQxdJCOSpOBjDLaQKBTC
         /qyJRyhiPL8R+1OcS6XRi+i4kRs1lOQjaqcrBBU5HoQanoQef2zchlrOIcGC406fxc
         ny2+Vk+eUIXD+hXX0/e4XaDgvzfnHLANztShqXNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.146
Date:   Wed, 15 Sep 2021 10:07:14 +0200
Message-Id: <16316932341313@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.146 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                   |    2 
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi                   |    4 
 arch/arm/boot/dts/meson8.dtsi                              |    5 
 arch/arm/boot/dts/meson8b-ec100.dts                        |    4 
 arch/arm/boot/dts/meson8b-mxq.dts                          |    4 
 arch/arm/boot/dts/meson8b-odroidc1.dts                     |    4 
 arch/arm/net/bpf_jit_32.c                                  |    3 
 arch/arm64/boot/dts/exynos/exynos7.dtsi                    |    2 
 arch/arm64/boot/dts/renesas/r8a77995-draak.dts             |    4 
 arch/arm64/net/bpf_jit_comp.c                              |   13 
 arch/m68k/emu/nfeth.c                                      |    4 
 arch/mips/net/ebpf_jit.c                                   |    3 
 arch/powerpc/net/bpf_jit_comp64.c                          |    6 
 arch/riscv/net/bpf_jit_comp.c                              |    4 
 arch/s390/include/asm/kvm_host.h                           |    1 
 arch/s390/kernel/debug.c                                   |  102 +++----
 arch/s390/kvm/interrupt.c                                  |   12 
 arch/s390/kvm/kvm-s390.c                                   |    2 
 arch/s390/kvm/kvm-s390.h                                   |    2 
 arch/s390/mm/kasan_init.c                                  |   41 +-
 arch/s390/net/bpf_jit_comp.c                               |    5 
 arch/sparc/net/bpf_jit_comp_64.c                           |    3 
 arch/x86/events/amd/ibs.c                                  |    1 
 arch/x86/kernel/cpu/resctrl/monitor.c                      |    6 
 arch/x86/kvm/vmx/nested.c                                  |    7 
 arch/x86/kvm/x86.c                                         |    4 
 arch/x86/net/bpf_jit_comp.c                                |    7 
 arch/x86/net/bpf_jit_comp32.c                              |    6 
 certs/Makefile                                             |    8 
 drivers/ata/libata-core.c                                  |    2 
 drivers/base/regmap/regmap.c                               |    2 
 drivers/bcma/main.c                                        |    6 
 drivers/block/nbd.c                                        |   10 
 drivers/clk/mvebu/kirkwood.c                               |    1 
 drivers/clocksource/sh_cmt.c                               |   30 +-
 drivers/counter/104-quad-8.c                               |    5 
 drivers/crypto/mxs-dcp.c                                   |   45 ++-
 drivers/crypto/omap-sham.c                                 |    2 
 drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c       |    4 
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c         |    4 
 drivers/crypto/qat/qat_common/adf_common_drv.h             |    8 
 drivers/crypto/qat/qat_common/adf_init.c                   |    5 
 drivers/crypto/qat/qat_common/adf_isr.c                    |    7 
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c              |    3 
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c              |   12 
 drivers/crypto/qat/qat_common/adf_vf_isr.c                 |    7 
 drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c |    4 
 drivers/edac/i10nm_base.c                                  |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c                    |   54 +--
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c                 |   10 
 drivers/gpu/drm/msm/dsi/dsi.c                              |    6 
 drivers/gpu/drm/panfrost/panfrost_device.c                 |    3 
 drivers/i2c/busses/i2c-highlander.c                        |    2 
 drivers/i2c/busses/i2c-iop3xx.c                            |    6 
 drivers/i2c/busses/i2c-mt65xx.c                            |    2 
 drivers/i2c/busses/i2c-s3c2410.c                           |    2 
 drivers/leds/leds-lt3593.c                                 |    5 
 drivers/leds/trigger/ledtrig-audio.c                       |   37 ++
 drivers/md/bcache/super.c                                  |   16 -
 drivers/media/i2c/tda1997x.c                               |    1 
 drivers/media/platform/coda/coda-bit.c                     |   18 -
 drivers/media/platform/qcom/venus/venc.c                   |    2 
 drivers/media/spi/cxd2880-spi.c                            |    7 
 drivers/media/usb/dvb-usb/dvb-usb-i2c.c                    |    9 
 drivers/media/usb/dvb-usb/dvb-usb-init.c                   |    2 
 drivers/media/usb/dvb-usb/nova-t-usb2.c                    |    6 
 drivers/media/usb/dvb-usb/vp702x.c                         |   12 
 drivers/media/usb/em28xx/em28xx-input.c                    |    1 
 drivers/media/usb/go7007/go7007-driver.c                   |   26 -
 drivers/mmc/host/dw_mmc.c                                  |    1 
 drivers/mmc/host/moxart-mmc.c                              |    1 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c        |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h            |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c            |   10 
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c      |   18 -
 drivers/net/ethernet/qualcomm/qca_spi.c                    |    2 
 drivers/net/ethernet/qualcomm/qca_uart.c                   |    2 
 drivers/net/wireless/ath/ath6kl/wmi.c                      |    4 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    2 
 drivers/net/wireless/rsi/rsi_91x_hal.c                     |    4 
 drivers/net/wireless/rsi/rsi_91x_usb.c                     |    1 
 drivers/nvme/host/rdma.c                                   |    4 
 drivers/nvme/host/tcp.c                                    |    4 
 drivers/nvme/target/fabrics-cmd.c                          |    9 
 drivers/pci/pci.c                                          |   25 +
 drivers/power/supply/axp288_fuel_gauge.c                   |    4 
 drivers/power/supply/max17042_battery.c                    |    2 
 drivers/regulator/vctrl-regulator.c                        |   73 +++--
 drivers/s390/cio/css.c                                     |   17 +
 drivers/soc/qcom/rpmhpd.c                                  |    5 
 drivers/soc/qcom/smsm.c                                    |   11 
 drivers/soc/rockchip/Kconfig                               |    4 
 drivers/spi/spi-fsl-dspi.c                                 |    1 
 drivers/spi/spi-pic32.c                                    |    1 
 drivers/spi/spi-sprd-adi.c                                 |    2 
 drivers/spi/spi-zynq-qspi.c                                |    8 
 drivers/tty/serial/fsl_lpuart.c                            |    2 
 drivers/tty/tty_io.c                                       |    4 
 drivers/usb/gadget/udc/at91_udc.c                          |    4 
 drivers/usb/gadget/udc/bdc/bdc_core.c                      |    3 
 drivers/usb/gadget/udc/mv_u3d_core.c                       |   19 -
 drivers/usb/gadget/udc/renesas_usb3.c                      |   17 -
 drivers/usb/host/ehci-orion.c                              |    8 
 drivers/usb/host/ohci-tmio.c                               |    3 
 drivers/usb/phy/phy-fsl-usb.c                              |    2 
 drivers/usb/phy/phy-tahvo.c                                |    4 
 drivers/usb/phy/phy-twl6030-usb.c                          |    5 
 drivers/video/backlight/pwm_bl.c                           |   54 +--
 drivers/video/fbdev/core/fbmem.c                           |    6 
 fs/cifs/cifs_unicode.c                                     |    9 
 fs/debugfs/file.c                                          |    8 
 fs/fcntl.c                                                 |    5 
 fs/fuse/file.c                                             |    9 
 fs/iomap/swapfile.c                                        |    6 
 fs/isofs/inode.c                                           |   27 -
 fs/isofs/isofs.h                                           |    1 
 fs/isofs/joliet.c                                          |    4 
 fs/lockd/svclock.c                                         |    2 
 fs/nfsd/nfs4state.c                                        |    4 
 fs/udf/misc.c                                              |   13 
 fs/udf/super.c                                             |   75 ++---
 fs/udf/udf_sb.h                                            |    2 
 fs/udf/unicode.c                                           |    4 
 include/linux/bpf_verifier.h                               |   11 
 include/linux/energy_model.h                               |   16 +
 include/linux/filter.h                                     |   15 +
 include/linux/hrtimer.h                                    |    5 
 include/linux/power/max17042_battery.h                     |    2 
 include/linux/time64.h                                     |    9 
 include/uapi/linux/bpf.h                                   |    2 
 kernel/bpf/core.c                                          |   18 +
 kernel/bpf/disasm.c                                        |   16 -
 kernel/bpf/verifier.c                                      |  183 +++++--------
 kernel/cgroup/cpuset.c                                     |    7 
 kernel/irq/timings.c                                       |    2 
 kernel/locking/mutex.c                                     |   15 -
 kernel/power/energy_model.c                                |    4 
 kernel/rcu/tree_stall.h                                    |   18 +
 kernel/sched/core.c                                        |   25 +
 kernel/sched/deadline.c                                    |    8 
 kernel/sched/sched.h                                       |    2 
 kernel/time/hrtimer.c                                      |   92 ++++--
 kernel/time/posix-cpu-timers.c                             |    2 
 kernel/time/tick-internal.h                                |    3 
 lib/mpi/mpiutil.c                                          |    2 
 net/6lowpan/debugfs.c                                      |    3 
 net/bluetooth/cmtp/cmtp.h                                  |    2 
 net/bluetooth/hci_core.c                                   |   14 
 net/bluetooth/sco.c                                        |   11 
 net/core/net_namespace.c                                   |   28 -
 net/ipv4/route.c                                           |   48 ++-
 net/ipv4/tcp_ipv4.c                                        |    5 
 net/ipv6/route.c                                           |    5 
 net/mac80211/tx.c                                          |    4 
 net/netlabel/netlabel_cipso_v4.c                           |    8 
 net/sched/sch_cbq.c                                        |    2 
 security/integrity/ima/Kconfig                             |    1 
 security/integrity/ima/ima_mok.c                           |    2 
 sound/soc/codecs/wcd9335.c                                 |   23 +
 sound/soc/intel/skylake/skl-topology.c                     |   25 -
 tools/include/uapi/linux/bpf.h                             |    2 
 161 files changed, 1104 insertions(+), 719 deletions(-)

Ahmad Fatoum (1):
      brcmfmac: pcie: fix oops on failure to resume and reprobe

Alexander Gordeev (1):
      s390/kasan: fix large PMD pages address alignment check

Amit Engel (1):
      nvmet: pass back cntlid on successful completion

Anand Moon (3):
      ARM: dts: meson8b: odroidc1: Fix the pwm regulator supply properties
      ARM: dts: meson8b: mxq: Fix the pwm regulator supply properties
      ARM: dts: meson8b: ec100: Fix the pwm regulator supply properties

Andrey Ignatov (1):
      bpf: Fix possible out of bound write in narrow load handling

Andy Duan (1):
      tty: serial: fsl_lpuart: fix the wrong mapbase value

Andy Shevchenko (1):
      leds: lt3593: Put fwnode in any case during ->probe()

Austin Kim (1):
      IMA: remove -Wmissing-prototypes warning

Babu Moger (1):
      x86/resctrl: Fix a maybe-uninitialized build warning treated as error

Benjamin Coddington (1):
      lockd: Fix invalid lockowner cast after vfs_test_lock

Bjorn Andersson (1):
      soc: qcom: rpmhpd: Use corner in power_off

Cezary Rojewski (2):
      ASoC: Intel: Skylake: Leave data as is when invoking TLV IPCs
      ASoC: Intel: Skylake: Fix module resource and format selection

Chen-Yu Tsai (2):
      regulator: vctrl: Use locked regulator_get_voltage in probe path
      regulator: vctrl: Avoid lockdep warning in enable/disable ops

Chih-Kang Chang (1):
      mac80211: Fix insufficient headroom issue for AMSDU

Christoph Hellwig (1):
      bcache: add proper error unwinding in bcache_device_init

Christophe JAILLET (6):
      media: cxd2880-spi: Fix an error handling path
      drm/msm/dsi: Fix some reference counted resource leaks
      usb: bdc: Fix an error handling path in 'bdc_probe()' when no suitable DMA config is available
      ASoC: wcd9335: Fix a double irq free in the remove function
      ASoC: wcd9335: Fix a memory leak in the error handling path of the probe function
      ASoC: wcd9335: Disable irq on slave ports in the remove function

Chunyan Zhang (1):
      spi: sprd: Fix the wrong WDG_LOAD_VAL

Colin Ian King (3):
      6lowpan: iphc: Fix an off-by-one check of array index
      media: venus: venc: Fix potential null pointer dereference on pointer fmt
      Bluetooth: increase BTNAMSIZ to 21 chars to fix potential buffer overflow

Damien Le Moal (1):
      libata: fix ata_host_start()

Dan Carpenter (4):
      Bluetooth: sco: prevent information leak in sco_conn_defer_accept()
      rsi: fix error code in rsi_load_9116_firmware()
      rsi: fix an error code in rsi_probe()
      ath6kl: wmi: fix an error code in ath6kl_wmi_sync_point()

Daniel Borkmann (3):
      bpf: Introduce BPF nospec instruction for mitigating Spectre v4
      bpf: Fix leakage due to insufficient speculative store bypass mitigation
      bpf: Fix pointer arithmetic mask tightening under state pruning

Daniel Thompson (1):
      backlight: pwm_bl: Improve bootloader/kernel device handover

Desmond Cheong Zhi Xi (2):
      fcntl: fix potential deadlock for &fasync_struct.fa_lock
      Bluetooth: fix repeated calls to sco_sock_kill

Dietmar Eggemann (1):
      sched/deadline: Fix missing clock update in migrate_task_rq_dl()

Dmitry Baryshkov (1):
      drm/msm/dpu: make dpu_hw_ctl_clear_all_blendstages clear necessary LMs

Dongliang Mu (4):
      media: dvb-usb: fix uninit-value in dvb_usb_adapter_dvb_init
      media: dvb-usb: fix uninit-value in vp702x_read_mac_addr
      media: dvb-usb: Fix error handling in dvb_usb_i2c_init
      media: em28xx-input: fix refcount bug in em28xx_usb_disconnect

Dylan Hung (1):
      ARM: dts: aspeed-g6: Fix HVI3C function-group in pinctrl dtsi

Eric Dumazet (3):
      ipv6: make exception cache less predictible
      ipv4: make exception cache less predictible
      ipv4: fix endianness issue in inet_rtm_getroute_build_skb()

Evgeny Novikov (1):
      usb: ehci-orion: Handle errors of clk_prepare_enable() in probe

Frederic Weisbecker (1):
      posix-cpu-timers: Force next expiration recalc after itimer reset

Geert Uytterhoeven (3):
      soc: rockchip: ROCKCHIP_GRF should not default to y, unconditionally
      arm64: dts: renesas: r8a77995: draak: Remove bogus adv7511w properties
      usb: gadget: udc: renesas_usb3: Fix soc_device_match() abuse

Giovanni Cabiddu (4):
      crypto: qat - do not ignore errors from enable_vf2pf_comms()
      crypto: qat - handle both source of interrupt in VF ISR
      crypto: qat - do not export adf_iov_putmsg()
      crypto: qat - use proper type for vf_mask

Greg Kroah-Hartman (1):
      Linux 5.4.146

Guillaume Nault (1):
      netns: protect netns ID lookups with RCU

Halil Pasic (1):
      KVM: s390: index kvm->arch.idle_mask by vcpu_idx

Hans de Goede (2):
      power: supply: axp288_fuel_gauge: Report register-address on readb / writeb errors
      leds: trigger: audio: Add an activate callback to ensure the initial brightness is set

He Fengqing (1):
      bpf: Fix potential memleak and UAF in the verifier.

Hongbo Li (1):
      lib/mpi: use kcalloc in mpi_resize

J. Bruce Fields (1):
      nfsd4: Fix forced-expiry locking

Jan Kara (1):
      udf: Check LVID earlier

Jeongtae Park (1):
      regmap: fix the offset of register error log

Kai-Heng Feng (2):
      drm/amdgpu/acp: Make PM domain really work
      Bluetooth: Move shutdown callback before flushing tx and rx queue

Kim Phillips (1):
      perf/x86/amd/ibs: Extend PERF_PMU_CAP_NO_EXCLUDE to IBS Op

Krzysztof Hałasa (1):
      media: TDA1997x: enable EDID support

Krzysztof Kozlowski (1):
      arm64: dts: exynos: correct GIC CPU interfaces address range on Exynos7

Kuniyuki Iwashima (1):
      bpf: Fix a typo of reuseport map in bpf.h.

Len Baker (1):
      CIFS: Fix a potencially linear read overflow

Linus Walleij (1):
      clk: kirkwood: Fix a clocking boot regression

Lorenz Bauer (1):
      bpf: verifier: Allocate idmap scratch in verifier env

Lukas Hannen (1):
      time: Handle negative seconds correctly in timespec64_to_ns()

Lukasz Luba (1):
      PM: EM: Increase energy calculation precision

Marco Chiappero (2):
      crypto: qat - fix reuse of completion variable
      crypto: qat - fix naming for init/shutdown VF to PF notifications

Martin Blumenstingl (1):
      ARM: dts: meson8: Use a higher default GPU clock frequency

Martin KaFai Lau (1):
      tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos

Maxim Mikityanskiy (1):
      net/mlx5e: Prohibit inner indir TIRs in IPoIB

Miklos Szeredi (2):
      fuse: truncate pagecache on atomic_o_trunc
      fuse: flush extending writes

Nadezda Lutovinova (1):
      usb: gadget: mv_u3d: request_irq() after initializing UDC

Nguyen Dinh Phi (1):
      tty: Fix data race between tiocsti() and flush_to_ldisc()

Pali Rohár (2):
      udf: Fix iocharset=utf8 mount option
      isofs: joliet: Fix iocharset=utf8 mount option

Pavel Skripkin (5):
      m68k: emu: Fix invalid free in nfeth_cleanup()
      block: nbd: add sanity check for first_minor
      media: go7007: remove redundant initialization
      net: cipso: fix warnings in netlbl_cipsov4_add_std
      Bluetooth: add timeout sanity check to hci_inquiry

Peter Oberparleiter (1):
      s390/debug: fix debug area life cycle

Peter Zijlstra (1):
      locking/mutex: Fix HANDOFF condition

Philipp Zabel (1):
      media: coda: fix frame_mem_ctrl for YUV420 and YVU420 formats

Phong Hoang (1):
      clocksource/drivers/sh_cmt: Fix wrong setting if don't request IRQ for clock source channel

Qiuxu Zhuo (1):
      EDAC/i10nm: Fix NVDIMM detection

Quanyang Wang (1):
      spi: spi-zynq-qspi: use wait_for_completion_timeout to make zynq_qspi_exec_mem_op not interruptible

Quentin Perret (2):
      sched/deadline: Fix reset_on_fork reporting of DL tasks
      sched: Fix UCLAMP_FLAG_IDLE setting

Rafael J. Wysocki (2):
      PCI: PM: Avoid forcing PCI_D0 for wakeup reasons inconsistently
      PCI: PM: Enable PME if it can be signaled from D3cold

Ruozhu Li (2):
      nvme-tcp: don't update queue count when failing to set io queues
      nvme-rdma: don't update queue count when failing to set io queues

Sean Anderson (1):
      crypto: mxs-dcp - Check for DMA mapping errors

Sean Christopherson (1):
      KVM: nVMX: Unconditionally clear nested.pi_pending on nested VM-Enter

Sebastian Krzyszkowiak (1):
      power: supply: max17042_battery: fix typo in MAx17042_TOFF

Sergey Senozhatsky (1):
      rcu/tree: Handle VM stoppage in stall detection

Sergey Shtylyov (9):
      i2c: highlander: add IRQ check
      usb: gadget: udc: at91: add IRQ check
      usb: phy: fsl-usb: add IRQ check
      usb: phy: twl6030: add IRQ checks
      usb: host: ohci-tmio: add IRQ check
      usb: phy: tahvo: add IRQ check
      i2c: iop3xx: fix deferred probing
      i2c: s3c2410: fix IRQ check
      i2c: mt65xx: fix IRQ check

Stefan Berger (1):
      certs: Trigger creation of RSA module signing key if it's not an RSA key

Stefan Wahren (1):
      net: qualcomm: fix QCA7000 checksum handling

Stephan Gerhold (1):
      soc: qcom: smsm: Fix missed interrupts if state changes while masked

Stian Skjelstad (1):
      udf_get_extendedattr() had no boundary checks.

Subbaraya Sundeep (1):
      octeontx2-af: Fix loop in free and unmap counter

Sven Eckelmann (1):
      debugfs: Return error during {full/open}_proxy_open() on rmmod

THOBY Simon (1):
      IMA: remove the dependency on CRYPTO_MD5

Tetsuo Handa (1):
      fbmem: don't allow too huge resolutions

Thomas Gleixner (2):
      hrtimer: Avoid double reprogramming in __hrtimer_start_range_ns()
      hrtimer: Ensure timerfd notification for HIGHRES=n

Tony Lindgren (5):
      crypto: omap-sham - clear dma flags only after omap_sham_update_dma_stop()
      spi: spi-fsl-dspi: Fix issue with uninitialized dma_slave_config
      spi: spi-pic32: Fix issue with uninitialized dma_slave_config
      mmc: dw_mmc: Fix issue with uninitialized dma_slave_config
      mmc: moxart: Fix issue with uninitialized dma_slave_config

Vineeth Vijayan (1):
      s390/cio: add dev_busid sysfs entry for each subchannel

Waiman Long (1):
      cgroup/cpuset: Fix a partition bug with hotplug

Wei Yongjun (1):
      drm/panfrost: Fix missing clk_disable_unprepare() on error in panfrost_clk_init()

William Breathitt Gray (1):
      counter: 104-quad-8: Return error when invalid mode during ceiling_write

Xiyu Yang (1):
      net: sched: Fix qdisc_rate_table refcount leak when get tcf_block failed

Xu Yu (1):
      mm/swap: consider max pages in iomap_swapfile_add_extent

Zelin Deng (1):
      KVM: x86: Update vCPU's hv_clock before back to guest when tsc_offset is adjusted

Zenghui Yu (1):
      bcma: Fix memory leak for internally-handled cores

Zhen Lei (1):
      genirq/timings: Fix error return code in irq_timings_test_irqs()

