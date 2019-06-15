Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A725470F5
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 17:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfFOPkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 11:40:09 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39227 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFOPkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 11:40:09 -0400
Received: by mail-pl1-f195.google.com with SMTP id b7so2269604pls.6;
        Sat, 15 Jun 2019 08:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=b6qEMUsliFYJpXmj+ClxU4zd0v4p9wxpupiDOt2fo+4=;
        b=JNgcVeXbdNz+0KQ7sJWphYau6a/c//JoRWlntw3nEGDC/xvZ3qiZScyvZ26DaXr1EH
         WuMEq6Wulj+iQDm3EsY/djWhpE1wyIZyco5qXo/lqz5u3nZWdT3iVYdQiLWCFQFoPHaP
         0uNTqM0oJaJ/KkqlnRh0KDkYWwUzHcPQWsapqGgS++hhEFh69+/SpmxhTJz4EFecQ9ip
         aYTM7W+s7s3HEXLYDAaKqwMdZ5q7wYIwAEeqElvFkwhx7duy21MEGCemQDR7uCPWjbII
         nLiX9Msxb3bff5WgzjEaPJhHaodksIBhv9ktYwIYIWtAgD+/OyNb8q3y5WiJ7EK0K6UX
         mPvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=b6qEMUsliFYJpXmj+ClxU4zd0v4p9wxpupiDOt2fo+4=;
        b=kTEJ0SOC08YiFIMC3xmp38GPGgrALEIgwkWTJvo7JygRR+PYy3o8hiTTYL8crGYC98
         Hzt/bATpBzyqFRORq7JBTFZjqr9Qg1jJvDu8oRufVTF+a5FruPRh4PS/xf+UG45VULzR
         rtrAwv/HSt3nBh/KihW4uNF+De0jRpZAkwsyFcqs5CbNv38uzfru+RR4Nrjs6A2byXC/
         IqhtgX4nMkKNmcZhzgBgDEygfvD3PIDQL7LSa8OXaqK3huTZ/kOsbrZuqo/xShnw9OBI
         2zk/+vhwIptp88zGedyVwZ1XE+c0uK1+xzkqe3MHq4sAMy113bKVZ2/MmgK1ShudcwcW
         IlKQ==
X-Gm-Message-State: APjAAAURn8zFYjSNgRpYnO9JHzjcIZGL16g70HwmpGW1E8yjjOYWCcHl
        jYanX/zIpnkeGpIlS1qwFM4=
X-Google-Smtp-Source: APXvYqx140hKxEjodnB0qrAVpimbj2ethahHbGNWNqC6xnWhfyH/JTiSOE+Oy1imuDTY7Of3mWKX2A==
X-Received: by 2002:a17:902:760f:: with SMTP id k15mr74630893pll.125.1560613208042;
        Sat, 15 Jun 2019 08:40:08 -0700 (PDT)
Received: from Gentoo ([103.231.90.171])
        by smtp.gmail.com with ESMTPSA id m1sm5797829pjv.22.2019.06.15.08.40.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 08:40:06 -0700 (PDT)
Date:   Sat, 15 Jun 2019 21:09:51 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.10
Message-ID: <20190615153951.GA11573@Gentoo>
References: <20190615150914.GA2174@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <20190615150914.GA2174@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thanks, a bunch Greg! :)

On 17:09 Sat 15 Jun , Greg KH wrote:
>I'm announcing the release of the 5.1.10 kernel.
>
>All users of the 5.1 kernel series must upgrade.
>
>The updated 5.1.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.1.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3D=
summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Documentation/devicetree/bindings/input/touchscreen/goodix.txt |    1
> Makefile                                                       |    2
> arch/arm/boot/dts/exynos5420-arndale-octa.dts                  |    2
> arch/arm/boot/dts/imx50.dtsi                                   |    2
> arch/arm/boot/dts/imx51.dtsi                                   |    2
> arch/arm/boot/dts/imx53.dtsi                                   |    2
> arch/arm/boot/dts/imx6qdl.dtsi                                 |    2
> arch/arm/boot/dts/imx6sl.dtsi                                  |    2
> arch/arm/boot/dts/imx6sll.dtsi                                 |    2
> arch/arm/boot/dts/imx6sx.dtsi                                  |    2
> arch/arm/boot/dts/imx6ul.dtsi                                  |    2
> arch/arm/boot/dts/imx7s.dtsi                                   |    4
> arch/arm/include/asm/hardirq.h                                 |    1
> arch/arm/kernel/smp.c                                          |    6
> arch/arm/mach-exynos/suspend.c                                 |   19 +
> arch/arm/mach-omap2/pm33xx-core.c                              |    8
> arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c             |    6
> arch/arm64/boot/dts/freescale/imx8mq.dtsi                      |    2
> arch/arm64/boot/dts/qcom/qcs404-evb.dtsi                       |   28 +-
> arch/arm64/configs/defconfig                                   |    6
> arch/mips/kernel/prom.c                                        |   14 +
> arch/powerpc/include/asm/drmem.h                               |   21 +
> arch/powerpc/mm/drmem.c                                        |    6
> arch/powerpc/platforms/pseries/hotplug-memory.c                |   17 -
> arch/um/kernel/time.c                                          |    2
> arch/x86/events/intel/core.c                                   |    2
> arch/x86/pci/irq.c                                             |   10
> block/bfq-iosched.c                                            |    2
> block/blk-core.c                                               |    1
> block/blk-mq.c                                                 |    2
> drivers/clk/rockchip/clk-rk3288.c                              |   11
> drivers/dma/idma64.c                                           |    6
> drivers/dma/idma64.h                                           |    2
> drivers/edac/Kconfig                                           |    4
> drivers/gpio/gpio-omap.c                                       |   53 ++--
> drivers/gpio/gpio-vf610.c                                      |   26 --
> drivers/gpu/drm/amd/display/dc/core/dc_link.c                  |    9
> drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp.c               |    6
> drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c      |    2
> drivers/gpu/drm/bridge/adv7511/adv7511_drv.c                   |    6
> drivers/gpu/drm/drm_ioctl.c                                    |   20 -
> drivers/gpu/drm/msm/msm_gem.c                                  |    3
> drivers/gpu/drm/nouveau/Kconfig                                |   13 -
> drivers/gpu/drm/nouveau/dispnv50/disp.h                        |    1
> drivers/gpu/drm/nouveau/dispnv50/head.c                        |    3
> drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c                    |    1
> drivers/gpu/drm/nouveau/dispnv50/wndw.c                        |    2
> drivers/gpu/drm/nouveau/nouveau_drm.c                          |    7
> drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c                  |   11
> drivers/gpu/drm/pl111/pl111_display.c                          |    5
> drivers/input/touchscreen/goodix.c                             |    2
> drivers/iommu/arm-smmu-v3.c                                    |   10
> drivers/iommu/intel-iommu.c                                    |   19 +
> drivers/mailbox/stm32-ipcc.c                                   |   13 -
> drivers/media/platform/atmel/atmel-isc.c                       |    8
> drivers/media/v4l2-core/v4l2-ctrls.c                           |   18 -
> drivers/media/v4l2-core/v4l2-fwnode.c                          |    6
> drivers/mfd/intel-lpss.c                                       |    3
> drivers/mfd/tps65912-spi.c                                     |    1
> drivers/mfd/twl6040.c                                          |   13 -
> drivers/misc/pci_endpoint_test.c                               |    1
> drivers/mmc/host/mmci.c                                        |    5
> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c        |    7
> drivers/net/ethernet/intel/i40e/i40e_main.c                    |    3
> drivers/net/ethernet/intel/ice/ice_main.c                      |    3
> drivers/net/ethernet/intel/ice/ice_switch.c                    |   36 ++
> drivers/net/thunderbolt.c                                      |    3
> drivers/nvme/host/pci.c                                        |   10
> drivers/nvmem/core.c                                           |   15 -
> drivers/nvmem/sunxi_sid.c                                      |    2
> drivers/pci/controller/dwc/pci-keystone.c                      |    8
> drivers/pci/controller/dwc/pcie-designware-ep.c                |    7
> drivers/pci/controller/dwc/pcie-designware-host.c              |   45 ++-
> drivers/pci/controller/dwc/pcie-designware.h                   |    1
> drivers/pci/controller/pcie-rcar.c                             |   10
> drivers/pci/controller/pcie-xilinx.c                           |   12
> drivers/pci/hotplug/rpadlpar_core.c                            |    4
> drivers/pci/switch/switchtec.c                                 |    3
> drivers/pinctrl/intel/pinctrl-intel.c                          |    8
> drivers/pinctrl/intel/pinctrl-intel.h                          |   11
> drivers/platform/chrome/cros_ec_proto.c                        |   11
> drivers/platform/x86/intel_pmc_ipc.c                           |    6
> drivers/power/supply/cpcap-battery.c                           |   11
> drivers/power/supply/max14656_charger_detector.c               |   14 -
> drivers/pwm/core.c                                             |   10
> drivers/pwm/pwm-meson.c                                        |   25 +
> drivers/pwm/pwm-tiehrpwm.c                                     |    2
> drivers/pwm/sysfs.c                                            |   14 -
> drivers/rapidio/rio_cm.c                                       |    8
> drivers/scsi/qla2xxx/qla_gs.c                                  |    3
> drivers/soc/mediatek/mtk-pmic-wrap.c                           |    2
> drivers/soc/renesas/renesas-soc.c                              |    3
> drivers/soc/rockchip/grf.c                                     |    2
> drivers/soc/tegra/pmc.c                                        |    5
> drivers/spi/spi-pxa2xx.c                                       |    7
> drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c          |   10
> drivers/thermal/qcom/tsens.c                                   |    3
> drivers/thermal/rcar_gen3_thermal.c                            |    3
> drivers/tty/serial/8250/8250_dw.c                              |    4
> drivers/usb/host/ohci-da8xx.c                                  |   22 +
> drivers/usb/typec/tcpm/fusb302.c                               |    2
> drivers/vfio/pci/vfio_pci_nvlink2.c                            |    2
> drivers/vfio/vfio.c                                            |   30 --
> drivers/video/fbdev/core/fbcon.c                               |    2
> drivers/video/fbdev/hgafb.c                                    |    2
> drivers/video/fbdev/imsttfb.c                                  |    5
> drivers/watchdog/Kconfig                                       |    1
> drivers/watchdog/imx2_wdt.c                                    |    4
> fs/configfs/dir.c                                              |   17 -
> fs/dax.c                                                       |    2
> fs/f2fs/checkpoint.c                                           |    6
> fs/f2fs/data.c                                                 |    3
> fs/f2fs/f2fs.h                                                 |   30 +-
> fs/f2fs/gc.c                                                   |    1
> fs/f2fs/inline.c                                               |   17 +
> fs/f2fs/inode.c                                                |    5
> fs/f2fs/node.c                                                 |   20 +
> fs/f2fs/recovery.c                                             |   25 +
> fs/f2fs/segment.c                                              |    9
> fs/f2fs/segment.h                                              |    3
> fs/fat/file.c                                                  |   11
> fs/fuse/dev.c                                                  |    2
> fs/io_uring.c                                                  |    5
> fs/nfsd/nfs4xdr.c                                              |    4
> fs/nfsd/vfs.h                                                  |    5
> fs/overlayfs/file.c                                            |  130 +++=
+++++--
> include/linux/pwm.h                                            |    5
> include/media/v4l2-ctrls.h                                     |    2
> include/net/bluetooth/hci_core.h                               |    3
> init/initramfs.c                                               |   14 -
> ipc/mqueue.c                                                   |   10
> ipc/msgutil.c                                                  |    6
> kernel/bpf/verifier.c                                          |    2
> kernel/sys.c                                                   |    2
> kernel/sysctl.c                                                |    6
> kernel/time/ntp.c                                              |    2
> mm/Kconfig                                                     |    2
> mm/cma.c                                                       |   23 +
> mm/cma_debug.c                                                 |    2
> mm/compaction.c                                                |    4
> mm/hugetlb.c                                                   |   21 +
> mm/memory_hotplug.c                                            |   37 +-
> mm/mprotect.c                                                  |    5
> mm/page_alloc.c                                                |    6
> mm/percpu.c                                                    |    9
> mm/rmap.c                                                      |    2
> mm/slab.c                                                      |    6
> net/batman-adv/distributed-arp-table.c                         |   24 +
> net/bluetooth/hci_conn.c                                       |    8
> net/netfilter/nf_conntrack_h323_asn1.c                         |    2
> net/netfilter/nf_flow_table_core.c                             |   25 +
> net/netfilter/nf_flow_table_ip.c                               |    6
> net/netfilter/nf_tables_api.c                                  |    9
> net/netfilter/nft_flow_offload.c                               |    1
> sound/core/seq/seq_ports.c                                     |    2
> sound/pci/hda/hda_intel.c                                      |    6
> tools/objtool/check.c                                          |    8
> 157 files changed, 963 insertions(+), 461 deletions(-)
>
>Adam Ludkiewicz (1):
>      i40e: Queues are reserved despite "Invalid argument" error
>
>Amir Goldstein (2):
>      ovl: do not generate duplicate fsnotify events for "fake" path
>      ovl: support stacked SEEK_HOLE/SEEK_DATA
>
>Amit Kucheria (1):
>      drivers: thermal: tsens: Don't print error message on -EPROBE_DEFER
>
>Andreas Schwab (1):
>      fbcon: Don't reset logo_shown when logo is currently shown
>
>Andrey Smirnov (11):
>      arm64: dts: imx8mq: Mark iomuxc_gpr as i.MX6Q compatible
>      ARM: dts: imx51: Specify IMX5_CLK_IPG as "ahb" clock to SDMA
>      ARM: dts: imx50: Specify IMX5_CLK_IPG as "ahb" clock to SDMA
>      ARM: dts: imx53: Specify IMX5_CLK_IPG as "ahb" clock to SDMA
>      ARM: dts: imx6sx: Specify IMX6SX_CLK_IPG as "ahb" clock to SDMA
>      ARM: dts: imx6sll: Specify IMX6SLL_CLK_IPG as "ipg" clock to SDMA
>      ARM: dts: imx7d: Specify IMX7D_CLK_IPG as "ipg" clock to SDMA
>      ARM: dts: imx6ul: Specify IMX6UL_CLK_IPG as "ipg" clock to SDMA
>      ARM: dts: imx6sx: Specify IMX6SX_CLK_IPG as "ipg" clock to SDMA
>      ARM: dts: imx6qdl: Specify IMX6QDL_CLK_IPG as "ipg" clock to SDMA
>      gpio: vf610: Do not share irq_chip
>
>Andy Shevchenko (1):
>      dmaengine: idma64: Use actual device for DMA transfers
>
>Aneesh Kumar K.V (1):
>      mm: page_mkclean vs MADV_DONTNEED race
>
>Anthony Koo (1):
>      drm/amd/display: disable link before changing link settings
>
>Arnd Bergmann (2):
>      ARM: prevent tracing IPI_CPU_BACKTRACE
>      nfsd: avoid uninitialized variable warning
>
>Baoquan He (1):
>      mm/memory_hotplug.c: fix the wrong usage of N_HIGH_MEMORY
>
>Bartosz Golaszewski (1):
>      usb: ohci-da8xx: disable the regulator if the overcurrent irq fired
>
>Ben Skeggs (3):
>      drm/nouveau/disp/dp: respect sink limits when selecting failsafe lin=
k configuration
>      drm/nouveau/kms/gf119-gp10x: push HeadSetControlOutputResource() mth=
d when encoders change
>      drm/nouveau/kms/gv100-: fix spurious window immediate interlocks
>
>Binbin Wu (2):
>      mfd: intel-lpss: Set the device in reset state when init
>      pinctrl: pinctrl-intel: move gpio suspend/resume to noirq phase
>
>Bjorn Andersson (1):
>      arm64: dts: qcom: qcs404: Fix regulator supply names
>
>Brett Creeley (1):
>      ice: Add missing case in print_link_msg for printing flow control
>
>Brian Masney (1):
>      drm/msm: correct attempted NULL pointer dereference in debugfs
>
>Chao Yu (14):
>      f2fs: fix to avoid panic in do_recover_data()
>      f2fs: fix to avoid panic in f2fs_inplace_write_data()
>      f2fs: fix error path of recovery
>      f2fs: fix to avoid panic in f2fs_remove_inode_page()
>      f2fs: fix to do sanity check on free nid
>      f2fs: fix to clear dirty inode in error path of f2fs_iget()
>      f2fs: fix to avoid panic in dec_valid_block_count()
>      f2fs: fix to use inline space only if inline_xattr is enable
>      f2fs: fix to avoid panic in dec_valid_node_count()
>      f2fs: fix to do sanity check on valid block count of segment
>      f2fs: fix to avoid deadloop in foreground GC
>      f2fs: fix to retrieve inline xattr space
>      f2fs: fix to do checksum even if inode page is uptodate
>      f2fs: fix potential recursive call when enabling data_flush
>
>Chen-Yu Tsai (1):
>      nvmem: sunxi_sid: Support SID on A83T and H5
>
>Christian Brauner (1):
>      sysctl: return -EINVAL if val violates minmax
>
>Christoph Hellwig (1):
>      initramfs: free initrd memory if opening /initrd.image fails
>
>Christoph Vogtl=C3=A4nder (1):
>      pwm: tiehrpwm: Update shadow register for disabling PWMs
>
>Christopher N Bednarz (1):
>      ice: Do not set LB_EN for prune switch rules
>
>Cyrill Gorcunov (1):
>      kernel/sys.c: prctl: fix false positive in validate_prctl_map()
>
>Dafna Hirschfeld (1):
>      media: v4l2-ctrl: v4l2_ctrl_request_setup returns with error upon fa=
ilure
>
>Daniel Gomez (1):
>      mfd: tps65912-spi: Add missing of table registration
>
>Dave Airlie (1):
>      Revert "drm: allow render capable master with DRM_AUTH ioctls"
>
>David Hildenbrand (1):
>      mm/memory_hotplug: release memory resource after arch_remove_memory()
>
>Dennis Zhou (1):
>      percpu: do not search past bitmap when allocating an area
>
>Douglas Anderson (2):
>      clk: rockchip: Turn on "aclk_dmac1" for suspend on rk3288
>      soc: rockchip: Set the proper PWM for rk3288
>
>Enrico Granata (1):
>      platform/chrome: cros_ec_proto: check for NULL transfer function
>
>Eugen Hristev (1):
>      media: atmel: atmel-isc: fix asd memory allocation
>
>Fabien Dessenne (1):
>      mailbox: stm32-ipcc: check invalid irq
>
>Farhan Ali (1):
>      vfio: Fix WARNING "do not call blocking ops when !TASK_RUNNING"
>
>Florian Westphal (1):
>      netfilter: nf_tables: fix base chain stat rcu_dereference usage
>
>Georg Hofmann (1):
>      watchdog: imx2_wdt: Fix set_timeout for big timeout values
>
>Giridhar Malavali (1):
>      scsi: qla2xxx: Reset the FCF_ASYNC_{SENT|ACTIVE} flags
>
>Greg Kroah-Hartman (3):
>      Revert "Bluetooth: Align minimum encryption key size for LE and BR/E=
DR connections"
>      Revert "drm/nouveau: add kconfig option to turn off nouveau legacy c=
ontexts. (v3)"
>      Linux 5.1.10
>
>Greg Kurz (1):
>      vfio-pci/nvlink2: Fix potential VMA leak
>
>Guenter Roeck (1):
>      drm/pl111: Initialize clock spinlock early
>
>Hans de Goede (1):
>      usb: typec: fusb302: Check vconn is off when we start toggling
>
>Hou Tao (1):
>      fs/fat/file.c: issue flush after the writeback of FAT
>
>J. Bruce Fields (1):
>      nfsd: allow fh_want_write to be called twice
>
>Jagan Teki (1):
>      Input: goodix - add GT5663 CTP support
>
>Jakub Jankowski (1):
>      netfilter: nf_conntrack_h323: restore boundary check correctness
>
>Jens Axboe (1):
>      io_uring: fix failure to verify SQ_AFF cpu
>
>Jiada Wang (1):
>      thermal: rcar_gen3_thermal: disable interrupt in .remove
>
>Jisheng Zhang (2):
>      PCI: dwc: Free MSI in dw_pcie_host_init() error path
>      PCI: dwc: Free MSI IRQ page in dw_pcie_free_msi()
>
>Jiufei Xue (1):
>      ovl: check the capability before cred overridden
>
>John Sperbeck (1):
>      percpu: remove spurious lock dependency between percpu and sched
>
>Jon Hunter (1):
>      soc/tegra: pmc: Remove reset sysfs entries on error
>
>Jonas Karlman (2):
>      media: rockchip/vpu: Fix/re-order probe-error/remove path
>      media: rockchip/vpu: Add missing dont_use_autosuspend() calls
>
>Jorge Ramirez-Ortiz (1):
>      nvmem: core: fix read buffer in place
>
>Josh Poimboeuf (1):
>      objtool: Don't use ignore flag for fake jumps
>
>Junxiao Chang (1):
>      platform/x86: intel_pmc_ipc: adding error handling
>
>J=C3=A9r=C3=B4me Glisse (1):
>      mm/hmm: select mmu notifier when selecting HMM
>
>Kabir Sahane (1):
>      ARM: OMAP2+: pm33xx-core: Do not Turn OFF CEFUSE as PPA may be using=
 it
>
>Kangjie Lu (5):
>      rapidio: fix a NULL pointer dereference when create_workqueue() fails
>      PCI: rcar: Fix a potential NULL pointer dereference
>      video: hgafb: fix potential NULL pointer dereference
>      video: imsttfb: fix potential NULL pointer dereferences
>      PCI: xilinx: Check for __get_free_pages() failure
>
>Keith Busch (2):
>      nvme-pci: unquiesce admin queue on shutdown
>      nvme-pci: shutdown on timeout during deletion
>
>Kirill Smelkov (1):
>      fuse: retrieve: cap requested size to negotiated max_write
>
>Kishon Vijay Abraham I (5):
>      misc: pci_endpoint_test: Fix test_reg_bar to be updated in pci_endpo=
int_test
>      PCI: designware-ep: Use aligned ATU window for raising MSI interrupts
>      PCI: keystone: Invoke phy_reset() API before enabling PHY
>      PCI: keystone: Prevent ARM32 specific code to be compiled for ARM64
>      PCI: dwc: Remove default MSI initialization for platform specific MS=
I chips
>
>Krzesimir Nowak (1):
>      bpf: fix undefined behavior in narrow load handling
>
>Krzysztof Kozlowski (1):
>      ARM: dts: exynos: Always enable necessary APIO_1V8 and ABB_1V8 regul=
ators on Arndale Octa
>
>Li Rongqing (1):
>      ipc: prevent lockup on alloc_msg and free_msg
>
>Linxu Fang (1):
>      mem-hotplug: fix node spanned pages when we have a node with only ZO=
NE_MOVABLE
>
>Lu Baolu (3):
>      iommu/vt-d: Set intel_iommu_gfx_mapped correctly
>      iommu/vt-d: Don't request page request irq under dmar_global_lock
>      iommu/vt-d: Flush IOTLB for untrusted device in time
>
>Ludovic Barre (1):
>      mmc: mmci: Prevent polling for busy detection in IRQ context
>
>Maciej =C5=BBenczykowski (1):
>      uml: fix a boot splat wrt use of cpu_all_mask
>
>Marek Szyprowski (1):
>      ARM: exynos: Fix undefined instruction during Exynos5422 resume
>
>Marek Vasut (2):
>      PCI: rcar: Fix 64bit MSI message address handling
>      ARM: shmobile: porter: enable R-Car Gen2 regulator quirk
>
>Martin Blumenstingl (1):
>      pwm: meson: Use the spin-lock only to protect register modifications
>
>Matt Redfearn (1):
>      drm/bridge: adv7511: Fix low refresh rate selection
>
>Michael Ellerman (1):
>      EDAC/mpc85xx: Prevent building as a module
>
>Mika Westerberg (1):
>      net: thunderbolt: Unregister ThunderboltIP protocol handler when sus=
pending
>
>Mike Kravetz (1):
>      hugetlbfs: on restore reserve error path retain subpool reservation
>
>Mike Rapoport (1):
>      mm/mprotect.c: fix compilation warning because of unused 'mm' variab=
le
>
>Ming Lei (1):
>      blk-mq: move cancel of requeue_work into blk_mq_release
>
>Miroslav Lichvar (1):
>      ntp: Allow TAI-UTC offset to be set to zero
>
>Nathan Chancellor (1):
>      soc: mediatek: pwrap: Zero initialize rdata in pwrap_init_cipher
>
>Nathan Fontenot (1):
>      powerpc/pseries: Track LMB nid instead of using device tree
>
>Nicholas Kazlauskas (1):
>      drm/amd/display: Use plane->color_space for dpp if specified
>
>Paolo Valente (1):
>      block, bfq: increase idling for weight-raised queues
>
>Peng Li (1):
>      net: hns3: return 0 and print warning when hit duplicate MAC
>
>Peteris Rudzusiks (1):
>      drm/nouveau: fix duplication of nv50_head_atom struct
>
>Phong Hoang (1):
>      pwm: Fix deadlock warning when removing PWM device
>
>Qian Cai (2):
>      mm/compaction.c: fix an undefined behaviour
>      mm/slab.c: fix an infinite loop in leaks_show()
>
>Sakari Ailus (1):
>      media: v4l2-fwnode: Defaults may not override endpoint configuration=
 in firmware
>
>Serge Semin (1):
>      mips: Make sure dt memory regions are valid
>
>Stephane Eranian (1):
>      perf/x86/intel: Allow PEBS multi-entry in watermark mode
>
>Sven Eckelmann (1):
>      batman-adv: Adjust name for batadv_dat_send_data
>
>Sven Van Asbroeck (1):
>      power: supply: max14656: fix potential use-before-alloc
>
>Taehee Yoo (3):
>      netfilter: nf_flow_table: fix missing error check for rhashtable_ins=
ert_fast
>      netfilter: nf_flow_table: check ttl value in flow offload data path
>      netfilter: nf_flow_table: fix netdev refcnt leak
>
>Takashi Iwai (2):
>      ALSA: hda - Register irq handler after the chip initialization
>      ALSA: seq: Cover unsubscribe_port() in list_mutex
>
>Takeshi Kihara (1):
>      soc: renesas: Identify R-Car M3-W ES1.3
>
>Tony Lindgren (4):
>      mfd: twl6040: Fix device init errors for ACCCTL register
>      power: supply: cpcap-battery: Fix signed counter sample register
>      gpio: gpio-omap: add check for off wake capable gpios
>      gpio: gpio-omap: limit errata 1.101 handling to wkup domain gpios on=
ly
>
>Tyrel Datwyler (1):
>      PCI: rpadlpar: Fix leaked device_node references in add/remove paths
>
>Valentin Schneider (1):
>      arm64: defconfig: Update UFSHCD for Hi3660 soc
>
>Vladimir Zapolskiy (1):
>      watchdog: fix compile time error of pretimeout governors
>
>Wenwen Wang (1):
>      x86/PCI: Fix PCI IRQ routing table memory leak
>
>Wesley Sheng (1):
>      switchtec: Fix unintended mask of MRPC event
>
>Will Deacon (1):
>      iommu/arm-smmu-v3: Don't disable SMMU in kdump kernel
>
>Yashaswini Raghuram Prathivadi Bhayankaram (1):
>      ice: Enable LAN_EN for the right recipes
>
>Yue Hu (3):
>      mm/cma.c: fix crash on CMA allocation if bitmap allocation fails
>      mm/cma.c: fix the bitmap status to show failed allocation reason
>      mm/cma_debug.c: fix the break condition in cma_maxchunk_get()
>
>YueHaibing (1):
>      configfs: fix possible use-after-free in configfs_register_group
>



--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl0FEUMACgkQsjqdtxFL
KRUmmAf/dJACc/vUMErRFpo4z/Pv+NNyzuxNJoeUksCIKtDvRECzJRtJWAYvwEVd
HsBI9WRcf31h+u5bCa9kbtNuHIppzGd1yxV+rruYKf6UKygIGzuOSqpmou7nhj8z
FpLHr12tqHTegnp82LLmP9qhLvP7VjuaMokqBcLbE6NLrXzJv0w7TOCEDwFnG13b
lTUburukQYUtLE09oh2V1xBID8tyNPLWVf0uHRBtybF35KgaFfHyuMUyjDFguCya
xDebQbdYoe36tVpYiZgXcbIFEXfjuIxhVTIpBIHI8DEi/KE87b5KiPyCFHGQPtTe
NtKFfmrxVkcpkvYuc0kAWxv70jsjVA==
=Cdfx
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
