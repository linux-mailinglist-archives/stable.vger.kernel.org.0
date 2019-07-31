Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE817BD86
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfGaJm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:42:56 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39253 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbfGaJm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 05:42:56 -0400
Received: by mail-pf1-f193.google.com with SMTP id f17so27566017pfn.6;
        Wed, 31 Jul 2019 02:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c8Q0WVR04L4vKeyBg47WnZwbvGWhrNEKS+9mNHevBek=;
        b=NKPscoFcayom0/HLZKqspbm22BIrMdFIPpf6+ymRsk9Hddcnzd+TNinlbAAoDJnPqn
         G66BM4bVaauJI/PPnxwsWHtqhSHZRcuFsgEBW+NpIMpu2CRs9/XeSEnJs99xyFyOWaSw
         zg9SNMxppnERTaf9QmJFjJ7q8k8VCMvohKOSvMXCPLBqXKwm1e/CJAOWBj6hAa8doSHl
         EtcmSbZTlaoL2p8v32277D12zI1DtRwDG2aUsVULry3LiKBob2mcQnOt0PcQ/LSnYIGt
         lHiBZNYVU14Imw5lqmn7Y5i6pI8kNQHjaMnDGINeoM2JdkO52mT0tv0JKJij+MVH67ev
         Qtkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c8Q0WVR04L4vKeyBg47WnZwbvGWhrNEKS+9mNHevBek=;
        b=s7uLKVPyifrnkee7Mxq0soUBV3fRgDwYaI8xm0A/N0WqGBkaXB5C762v0eEVKMWEoH
         8G2HGLrnm+Py47u5X9tf+qyEy1QlNI0g4Y0a57R9G+xYeXUpH6KZB8TuooYy9/Z2mFTt
         4HFMEQPTDP7aB98Pj+I2TAeykEaKauk0JewMoiERli2Bvt/KpaXAj9opUS96uYqXjklV
         ZlDk6L+iEjiuT1L0DFQcmDnmbHGG+di7kjAnPDkGlFyW+3svbU4egrviy6nvpqLyHXFi
         7RP4F5NRtmJTd17+1ZHMmNp+EdHPz9x6101bAFt+e6f+2QGyahjGXfAhVFWthbbS0I9E
         OBtw==
X-Gm-Message-State: APjAAAUYhOjbL3p9lxERL4v0Gme5bP1GW/FW6Turt3PtUlpk1QNJizgX
        bRz8Zrn2a27PDCk2MA5gQbjRt3IA74HfJQ==
X-Google-Smtp-Source: APXvYqzr/PQjpQs+SuBXaIIukHaaBcwVq6LCzVragL0SO6+cFaohusWGnFpWZXZCsNjPVwkazaDGKw==
X-Received: by 2002:a17:90a:290b:: with SMTP id g11mr2038578pjd.122.1564566174631;
        Wed, 31 Jul 2019 02:42:54 -0700 (PDT)
Received: from debian ([103.231.90.171])
        by smtp.gmail.com with ESMTPSA id h6sm64894650pfb.20.2019.07.31.02.42.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 02:42:53 -0700 (PDT)
Date:   Wed, 31 Jul 2019 15:12:40 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.2.5
Message-ID: <20190731094237.GA26819@debian>
References: <20190731092148.GA16970@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <20190731092148.GA16970@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Thanks, a bunch Greg! :)


On 11:21 Wed 31 Jul 2019, Greg KH wrote:
>I'm announcing the release of the 5.2.5 kernel.
>
>All users of the 5.2 kernel series must upgrade.
>
>The updated 5.2.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.2.y
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
> Documentation/devicetree/bindings/display/panel/armadeus,st0700-adapt.txt=
 |    9
> Documentation/devicetree/bindings/leds/backlight/lm3630a-backlight.yaml  =
 |   21
> Documentation/devicetree/bindings/usb/usb251xb.txt                       =
 |    6
> Makefile                                                                 =
 |    3
> arch/arm64/include/asm/assembler.h                                       =
 |    4
> arch/powerpc/Kconfig                                                     =
 |    1
> arch/powerpc/boot/xz_config.h                                            =
 |   20
> arch/powerpc/include/asm/cacheflush.h                                    =
 |    7
> arch/powerpc/include/asm/pmc.h                                           =
 |    5
> arch/powerpc/kernel/Makefile                                             =
 |    3
> arch/powerpc/kernel/dma-common.c                                         =
 |   17
> arch/powerpc/kernel/eeh.c                                                =
 |   15
> arch/powerpc/kernel/hw_breakpoint.c                                      =
 |    7
> arch/powerpc/kernel/irq.c                                                =
 |    6
> arch/powerpc/kernel/pci_of_scan.c                                        =
 |    2
> arch/powerpc/kernel/rtas.c                                               =
 |    7
> arch/powerpc/kernel/signal_32.c                                          =
 |    3
> arch/powerpc/kernel/signal_64.c                                          =
 |    5
> arch/powerpc/kvm/book3s_hv.c                                             =
 |   13
> arch/powerpc/kvm/book3s_xive.c                                           =
 |    4
> arch/powerpc/kvm/book3s_xive_native.c                                    =
 |    4
> arch/powerpc/mm/book3s64/hash_native.c                                   =
 |    2
> arch/powerpc/mm/book3s64/hash_utils.c                                    =
 |    9
> arch/powerpc/mm/book3s64/radix_tlb.c                                     =
 |   32 -
> arch/powerpc/mm/hugetlbpage.c                                            =
 |    8
> arch/powerpc/platforms/4xx/uic.c                                         =
 |    1
> arch/powerpc/platforms/pseries/mobility.c                                =
 |    9
> arch/powerpc/sysdev/xive/common.c                                        =
 |    7
> arch/powerpc/xmon/xmon.c                                                 =
 |    6
> arch/sh/include/asm/io.h                                                 =
 |    6
> arch/um/include/asm/mmu_context.h                                        =
 |    2
> arch/x86/include/uapi/asm/vmx.h                                          =
 |    1
> arch/x86/kernel/cpu/bugs.c                                               =
 |    2
> arch/x86/kernel/stacktrace.c                                             =
 |    2
> arch/x86/kernel/sysfb_efi.c                                              =
 |   46 +
> arch/x86/kvm/vmx/nested.c                                                =
 |   87 +--
> arch/x86/kvm/vmx/nested.h                                                =
 |    2
> arch/x86/kvm/vmx/vmcs_shadow_fields.h                                    =
 |    4
> arch/x86/kvm/vmx/vmx.c                                                   =
 |    3
> arch/x86/kvm/x86.c                                                       =
 |    9
> block/bio-integrity.c                                                    =
 |    8
> block/blk-core.c                                                         =
 |    1
> drivers/android/binder.c                                                 =
 |    5
> drivers/base/core.c                                                      =
 |   27
> drivers/char/hpet.c                                                      =
 |    3
> drivers/char/ipmi/ipmi_si_platform.c                                     =
 |    6
> drivers/char/ipmi/ipmi_ssif.c                                            =
 |    5
> drivers/fpga/Kconfig                                                     =
 |    1
> drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                         =
 |    4
> drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c                                    =
 |    3
> drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c                    =
 |   21
> drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c                          =
 |    5
> drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                        =
 |   30 -
> drivers/gpu/drm/amd/display/dc/core/dc.c                                 =
 |   14
> drivers/gpu/drm/amd/display/dc/core/dc_link.c                            =
 |    6
> drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c                         =
 |    9
> drivers/gpu/drm/amd/display/dc/dce/dce_abm.c                             =
 |    2
> drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c                            =
 |    3
> drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.h                            =
 |    2
> drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c              =
 |    3
> drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c                =
 |    1
> drivers/gpu/drm/amd/display/modules/color/color_gamma.c                  =
 |    3
> drivers/gpu/drm/bochs/bochs_drv.c                                        =
 |    2
> drivers/gpu/drm/bridge/sii902x.c                                         =
 |    5
> drivers/gpu/drm/bridge/tc358767.c                                        =
 |    7
> drivers/gpu/drm/bridge/ti-tfp410.c                                       =
 |    3
> drivers/gpu/drm/drm_debugfs_crc.c                                        =
 |    9
> drivers/gpu/drm/drm_edid_load.c                                          =
 |    2
> drivers/gpu/drm/i915/i915_request.c                                      =
 |    4
> drivers/gpu/drm/i915/intel_context.c                                     =
 |    1
> drivers/gpu/drm/i915/intel_context_types.h                               =
 |    2
> drivers/gpu/drm/i915/intel_engine_cs.c                                   =
 |    1
> drivers/gpu/drm/i915/intel_engine_types.h                                =
 |    2
> drivers/gpu/drm/lima/lima_pp.c                                           =
 |    8
> drivers/gpu/drm/msm/adreno/a6xx_gmu.c                                    =
 |   20
> drivers/gpu/drm/msm/adreno/a6xx_gmu.h                                    =
 |    1
> drivers/gpu/drm/msm/adreno/adreno_gpu.c                                  =
 |    8
> drivers/gpu/drm/msm/msm_drv.c                                            =
 |   14
> drivers/gpu/drm/omapdrm/omap_crtc.c                                      =
 |   18
> drivers/gpu/drm/panel/panel-simple.c                                     =
 |   38 +
> drivers/gpu/drm/rockchip/rockchip_drm_vop.c                              =
 |    3
> drivers/gpu/drm/virtio/virtgpu_drv.h                                     =
 |    1
> drivers/gpu/drm/virtio/virtgpu_fence.c                                   =
 |   17
> drivers/gpu/drm/virtio/virtgpu_ioctl.c                                   =
 |    3
> drivers/gpu/drm/virtio/virtgpu_vq.c                                      =
 |    2
> drivers/gpu/drm/vkms/vkms_crtc.c                                         =
 |   22
> drivers/gpu/host1x/bus.c                                                 =
 |    3
> drivers/i2c/busses/i2c-nvidia-gpu.c                                      =
 |   14
> drivers/i2c/busses/i2c-stm32f7.c                                         =
 |   26
> drivers/iio/accel/adxl372.c                                              =
 |   27
> drivers/iio/adc/stm32-dfsdm-adc.c                                        =
 |    6
> drivers/iio/adc/stm32-dfsdm-core.c                                       =
 |    8
> drivers/infiniband/core/addr.c                                           =
 |    2
> drivers/infiniband/hw/i40iw/i40iw_verbs.c                                =
 |    2
> drivers/infiniband/hw/mlx5/mad.c                                         =
 |   60 +-
> drivers/infiniband/sw/rxe/rxe_resp.c                                     =
 |    5
> drivers/infiniband/sw/rxe/rxe_verbs.h                                    =
 |    1
> drivers/infiniband/ulp/ipoib/ipoib_main.c                                =
 |   34 -
> drivers/iommu/intel-iommu.c                                              =
 |    3
> drivers/iommu/iova.c                                                     =
 |   23
> drivers/mailbox/mailbox.c                                                =
 |    6
> drivers/media/platform/coda/Makefile                                     =
 |    4
> drivers/memstick/core/memstick.c                                         =
 |   13
> drivers/mfd/arizona-core.c                                               =
 |    2
> drivers/mfd/cros_ec_dev.c                                                =
 |   13
> drivers/mfd/hi655x-pmic.c                                                =
 |    2
> drivers/mfd/madera-core.c                                                =
 |    1
> drivers/mfd/mfd-core.c                                                   =
 |    1
> drivers/misc/eeprom/Kconfig                                              =
 |    3
> drivers/misc/mei/hw-me-regs.h                                            =
 |    3
> drivers/misc/mei/pci-me.c                                                =
 |    3
> drivers/mmc/host/sdhci-pci-o2micro.c                                     =
 |   12
> drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c                           =
 |   19
> drivers/nvdimm/bus.c                                                     =
 |  121 ++--
> drivers/nvdimm/nd-core.h                                                 =
 |    3
> drivers/nvdimm/region.c                                                  =
 |   22
> drivers/nvme/host/core.c                                                 =
 |    5
> drivers/nvme/host/pci.c                                                  =
 |   17
> drivers/nvme/host/tcp.c                                                  =
 |    9
> drivers/pci/controller/dwc/pci-dra7xx.c                                  =
 |    1
> drivers/pci/controller/pcie-mobiveil.c                                   =
 |   22
> drivers/pci/controller/pcie-xilinx-nwl.c                                 =
 |   11
> drivers/pci/endpoint/functions/pci-epf-test.c                            =
 |    8
> drivers/pci/pci-driver.c                                                 =
 |   13
> drivers/pci/pci-sysfs.c                                                  =
 |    2
> drivers/phy/amlogic/phy-meson-g12a-usb3-pcie.c                           =
 |    2
> drivers/phy/renesas/phy-rcar-gen2.c                                      =
 |    2
> drivers/phy/renesas/phy-rcar-gen3-usb2.c                                 =
 |   19
> drivers/pinctrl/pinctrl-rockchip.c                                       =
 |    1
> drivers/platform/x86/Kconfig                                             =
 |    2
> drivers/platform/x86/asus-wmi.c                                          =
 |   10
> drivers/regulator/88pm800-regulator.c                                    =
 |  286 ++++++++++
> drivers/regulator/88pm800.c                                              =
 |  286 ----------
> drivers/regulator/Makefile                                               =
 |    2
> drivers/staging/kpc2000/TODO                                             =
 |    1
> drivers/staging/kpc2000/kpc2000/cell_probe.c                             =
 |    3
> drivers/staging/kpc2000/kpc_spi/spi_driver.c                             =
 |    8
> drivers/staging/vt6656/main_usb.c                                        =
 |   42 -
> drivers/tty/serial/8250/8250_port.c                                      =
 |    3
> drivers/tty/serial/cpm_uart/cpm_uart_core.c                              =
 |   17
> drivers/tty/serial/digicolor-usart.c                                     =
 |    6
> drivers/tty/serial/imx.c                                                 =
 |   23
> drivers/tty/serial/max310x.c                                             =
 |   51 +
> drivers/tty/serial/msm_serial.c                                          =
 |    4
> drivers/tty/serial/serial_core.c                                         =
 |    7
> drivers/tty/serial/serial_mctrl_gpio.c                                   =
 |   14
> drivers/tty/serial/sh-sci.c                                              =
 |   33 -
> drivers/tty/serial/sunhv.c                                               =
 |    2
> drivers/tty/serial/xilinx_uartps.c                                       =
 |    5
> drivers/usb/core/hub.c                                                   =
 |   28
> drivers/usb/dwc3/core.c                                                  =
 |   12
> drivers/usb/gadget/function/f_fs.c                                       =
 |    6
> drivers/usb/host/hwa-hc.c                                                =
 |    2
> drivers/usb/host/pci-quirks.c                                            =
 |   31 -
> drivers/usb/host/xhci.h                                                  =
 |    3
> drivers/usb/misc/usb251xb.c                                              =
 |   15
> drivers/usb/storage/scsiglue.c                                           =
 |   11
> fs/9p/vfs_addr.c                                                         =
 |    6
> fs/btrfs/inode.c                                                         =
 |   24
> fs/btrfs/props.c                                                         =
 |    2
> fs/dlm/lowcomms.c                                                        =
 |   18
> fs/f2fs/checkpoint.c                                                     =
 |   11
> fs/f2fs/data.c                                                           =
 |    3
> fs/f2fs/f2fs.h                                                           =
 |   18
> fs/f2fs/segment.c                                                        =
 |   21
> fs/f2fs/super.c                                                          =
 |   10
> fs/io_uring.c                                                            =
 |   60 +-
> fs/notify/fanotify/fanotify.c                                            =
 |    5
> fs/notify/inotify/inotify_fsnotify.c                                     =
 |    8
> fs/open.c                                                                =
 |   19
> fs/proc/base.c                                                           =
 |   28
> fs/proc/task_mmu.c                                                       =
 |   23
> fs/proc/task_nommu.c                                                     =
 |    6
> include/linux/cred.h                                                     =
 |    8
> include/linux/device.h                                                   =
 |    1
> include/linux/hmm.h                                                      =
 |    1
> include/linux/host1x.h                                                   =
 |    2
> include/linux/iova.h                                                     =
 |    6
> include/linux/swap.h                                                     =
 |   13
> include/uapi/linux/videodev2.h                                           =
 |    8
> kernel/cred.c                                                            =
 |   21
> kernel/dma/remap.c                                                       =
 |    3
> kernel/locking/lockdep_proc.c                                            =
 |    8
> mm/gup.c                                                                 =
 |   12
> mm/hmm.c                                                                 =
 |   23
> mm/kmemleak.c                                                            =
 |    2
> mm/memory.c                                                              =
 |    6
> mm/mincore.c                                                             =
 |   12
> mm/mmu_notifier.c                                                        =
 |    2
> mm/nommu.c                                                               =
 |    3
> mm/swap.c                                                                =
 |   13
> mm/swap_state.c                                                          =
 |   16
> mm/swapfile.c                                                            =
 |  154 ++++-
> net/rds/rdma_transport.c                                                 =
 |    5
> scripts/basic/fixdep.c                                                   =
 |   51 +
> scripts/genksyms/keywords.c                                              =
 |    4
> scripts/genksyms/parse.y                                                 =
 |    2
> scripts/kallsyms.c                                                       =
 |    3
> scripts/recordmcount.h                                                   =
 |    3
> security/Kconfig.hardening                                               =
 |    7
> security/selinux/ss/sidtab.c                                             =
 |    5
> sound/ac97/bus.c                                                         =
 |   13
> sound/core/pcm_native.c                                                  =
 |    9
> sound/pci/hda/hda_intel.c                                                =
 |    5
> sound/pci/hda/patch_conexant.c                                           =
 |    1
> sound/usb/line6/podhd.c                                                  =
 |    2
> tools/iio/iio_utils.c                                                    =
 |    4
> tools/pci/pcitest.c                                                      =
 |    6
> tools/perf/builtin-stat.c                                                =
 |    2
> tools/perf/builtin-top.c                                                 =
 |    8
> tools/perf/builtin-trace.c                                               =
 |    6
> tools/perf/tests/mmap-thread-lookup.c                                    =
 |    2
> tools/perf/ui/browsers/hists.c                                           =
 |   15
> tools/perf/util/annotate.c                                               =
 |    6
> tools/perf/util/intel-bts.c                                              =
 |    5
> tools/perf/util/map.c                                                    =
 |    7
> tools/perf/util/session.c                                                =
 |    3
> tools/testing/selftests/rseq/rseq-arm.h                                  =
 |   61 +-
> 218 files changed, 2070 insertions(+), 963 deletions(-)
>
>Ajay Gupta (1):
>      i2c: nvidia-gpu: resume ccgx i2c client
>
>Alan Mikhak (3):
>      tools: PCI: Fix broken pcitest compilation
>      PCI: endpoint: Allocate enough space for fixed size BAR
>      nvme-pci: check for NULL return from pci_alloc_p2pmem()
>
>Alex Williamson (1):
>      PCI: Return error if cannot probe VF
>
>Alexander Usyskin (1):
>      mei: me: add mule creek canyon (EHL) device ids
>
>Alexandru Ardelean (1):
>      iio: adxl372: fix iio_triggered_buffer_{pre,post}enable positions
>
>Alexey Kardashevskiy (1):
>      powerpc/pci/of: Fix OF flags parsing for 64bit BARs
>
>Anders Roxell (2):
>      regulator: 88pm800: fix warning same module names
>      media: drivers: media: coda: fix warning same module names
>
>Andrzej Pietrasiewicz (1):
>      usb: gadget: Zero ffs_io_data
>
>Andy Lutomirski (1):
>      mm/gup.c: remove some BUG_ONs from get_gate_page()
>
>Aneesh Kumar K.V (1):
>      powerpc/mm: Handle page table allocation failures
>
>Anthony Koo (1):
>      drm/amd/display: fix multi display seamless boot case
>
>Arnd Bergmann (5):
>      btrfs: shut up bogus -Wmaybe-uninitialized warning
>      mfd: arizona: Fix undefined behavior
>      cxgb4: reduce kernel stack usage in cudbg_collect_mem_region()
>      locking/lockdep: Hide unused 'class' variable
>      structleak: disable STRUCTLEAK_BYREF in combination with KASAN_STACK
>
>Arseny Solokha (1):
>      eeprom: make older eeprom drivers select NVMEM_SYSFS
>
>Axel Lin (1):
>      mfd: hi655x-pmic: Fix missing return value check for devm_regmap_ini=
t_mmio_clk
>
>Bastien Nocera (1):
>      iio: iio-utils: Fix possible incorrect mask calculation
>
>Bharat Kumar Gogada (1):
>      PCI: xilinx-nwl: Fix Multi MSI data programming
>
>Brian Masney (1):
>      dt-bindings: backlight: lm3630a: correct schema validation
>
>Chao Yu (2):
>      f2fs: fix to check layout on last valid checkpoint park
>      f2fs: fix to avoid deadloop if data_flush is on
>
>Chia-I Wu (1):
>      drm/virtio: set seqno for dma-fence
>
>Chris Wilson (2):
>      iommu/iova: Remove stale cached32_node
>      drm/i915: Make the semaphore saturation mask global
>
>Christian Lamparter (1):
>      powerpc/4xx/uic: clear pending interrupt after irq type/pol change
>
>Christoph Hellwig (2):
>      nvme-pci: limit max_hw_sectors based on the DMA max mapping size
>      9p: pass the correct prototype to read_cache_page
>
>Christophe Leroy (1):
>      tty: serial: cpm_uart - fix init when SMC is relocated
>
>C=E9dric Le Goater (1):
>      KVM: PPC: Book3S HV: XIVE: fix rollback when kvmppc_xive_create fails
>
>Dag Moxnes (1):
>      RDMA/core: Fix race when resolving IP address
>
>Dan Williams (4):
>      drivers/base: Introduce kill_device()
>      libnvdimm/bus: Prevent duplicate device_unregister() calls
>      libnvdimm/region: Register badblocks before namespaces
>      libnvdimm/bus: Stop holding nvdimm_bus_list_mutex over __nd_ioctl()
>
>Daniel Gomez (1):
>      mfd: madera: Add missing of table registration
>
>Daniel Rosenberg (2):
>      f2fs: Fix accounting for unusable blocks
>      f2fs: Lower threshold for disable_cp_again
>
>Daniel Vetter (3):
>      drm/crc-debugfs: User irqsafe spinlock in drm_crtc_add_crc_entry
>      drm/crc-debugfs: Also sprinkle irqrestore over early exits
>      drm/vkms: Forward timer right after drm_crtc_handle_vblank
>
>David Riley (1):
>      drm/virtio: Add memory barriers for capset cache.
>
>David Windsor (1):
>      dlm: check if workqueues are NULL before flushing/destroying
>
>Ding Xiang (1):
>      ALSA: ac97: Fix double free of ac97_codec_device
>
>Dmitry Safonov (1):
>      iommu/vt-d: Don't queue_iova() if there is no flush queue
>
>Dmitry Vyukov (1):
>      mm/kmemleak.c: fix check for softirq context
>
>Douglas Anderson (1):
>      drm/rockchip: Properly adjust to a true clock in adjusted_mode
>
>Eiichi Tsukata (1):
>      x86/stacktrace: Prevent access_ok() warnings in arch_stack_walk_user=
()
>
>Enric Balletbo i Serra (1):
>      usb: dwc3: Fix core validation in probe, move after clocks are enabl=
ed
>
>Eryk Brol (1):
>      drm/amd/display: Increase Backlight Gain Step Size
>
>Eugene Korenevsky (2):
>      kvm: vmx: fix limit checking in get_vmx_mem_address()
>      kvm: vmx: segment limit check: use access length
>
>Fabien Dessenne (2):
>      iio: adc: stm32-dfsdm: manage the get_irq error case
>      iio: adc: stm32-dfsdm: missing error case during probe
>
>Fabrice Gasnier (1):
>      i2c: stm32f7: fix the get_irq error cases
>
>Felix Kuehling (1):
>      drm/amdgpu: Reserve shared fence for eviction fence
>
>Florian Fainelli (1):
>      dma-remap: Avoid de-referencing NULL atomic_pool
>
>Gautham R. Shenoy (1):
>      powerpc/xive: Fix loop exit-condition in xive_find_target_in_mask()
>
>Geert Uytterhoeven (2):
>      serial: sh-sci: Terminate TX DMA during buffer flushing
>      serial: sh-sci: Fix TX DMA buffer flushing and workqueue races
>
>Gen Zhang (1):
>      drm/edid: Fix a missing-check bug in drm_load_edid_firmware()
>
>Gerd Rausch (1):
>      rds: Accept peer connection reject messages due to incompatible vers=
ion
>
>Greg Kroah-Hartman (1):
>      Linux 5.2.5
>
>Guenter Roeck (1):
>      mm/gup.c: mark undo_dev_pagemap as __maybe_unused
>
>Gwendal Grignou (1):
>      mfd: cros_ec: Register cros_ec_lid_angle driver when presented
>
>Hans Verkuil (1):
>      media: videodev2.h: change V4L2_PIX_FMT_BGRA444 define: fourcc was a=
lready in use
>
>Hans de Goede (1):
>      x86/sysfb_efi: Add quirks for some devices with swapped width and he=
ight
>
>Hariprasad Kelam (1):
>      drm/amd/display: fix compilation error
>
>Heng Xiao (1):
>      f2fs: fix to avoid long latency during umount
>
>Hou Zhiqiang (4):
>      PCI: mobiveil: Fix PCI base address in MEM/IO outbound windows
>      PCI: mobiveil: Fix the Class Code field
>      PCI: mobiveil: Initialize Primary/Secondary/Subordinate bus numbers
>      PCI: mobiveil: Use the 1st inbound window for MEM inbound transactio=
ns
>
>Hridya Valsaraju (1):
>      binder: prevent transactions to context manager from its own process.
>
>Huang Ying (2):
>      mm/mincore.c: fix race between swapoff and mincore
>      mm, swap: fix race between swapoff and some swap operations
>
>Hui Wang (1):
>      ALSA: hda - Add a conexant codec entry to let mute led work
>
>Ira Weiny (1):
>      mm/swap: fix release_pages() when releasing devmap pages
>
>Jackie Liu (1):
>      io_uring: fix io_sq_thread_stop running in front of io_sq_thread
>
>James Morse (1):
>      arm64: assembler: Switch ESB-instruction with a vanilla nop if !ARM6=
4_HAS_RAS
>
>Jason Gunthorpe (1):
>      mm/hmm: fix use after free with struct hmm in the mmu notifiers
>
>Jean-Philippe Brucker (1):
>      mm/mmu_notifier: use hlist_add_head_rcu()
>
>Jens Axboe (2):
>      io_uring: ensure ->list is initialized for poll commands
>      io_uring: don't use iov_iter_advance() for fixed buffers
>
>Jeremy Sowden (1):
>      staging: kpc2000: added missing clean-up to probe_core_uio.
>
>Joerg Roedel (1):
>      iommu/iova: Fix compilation error with !CONFIG_IOMMU_IOVA
>
>Johannes Berg (1):
>      um: Silence lockdep complaint about mmap_sem
>
>John Paul Adrian Glaubitz (1):
>      sunhv: Fix device naming inconsistency between sunhv_console and sun=
hv_reg
>
>Jordan Crouse (1):
>      drm/msm/adreno: Ensure that the zap shader region is big enough
>
>Jorge Ramirez-Ortiz (1):
>      tty: serial: msm_serial: avoid system lockup condition
>
>Josef Bacik (1):
>      block: init flush rq ref count to 1
>
>Jyri Sarha (1):
>      drm/bridge: sii902x: pixel clock unit is 10kHz instead of 1kHz
>
>Kai-Heng Feng (1):
>      ALSA: line6: Fix wrong altsetting for LINE6_PODHD500_1
>
>Kefeng Wang (4):
>      ipmi_si: fix unexpected driver unregister warning
>      ipmi_ssif: fix unexpected driver unregister warning
>      tty/serial: digicolor: Fix digicolor-usart already registered warning
>      hpet: Fix division by zero in hpet_time_div()
>
>Konstantin Khlebnikov (6):
>      proc: use down_read_killable mmap_sem for /proc/pid/smaps_rollup
>      proc: use down_read_killable mmap_sem for /proc/pid/pagemap
>      proc: use down_read_killable mmap_sem for /proc/pid/clear_refs
>      proc: use down_read_killable mmap_sem for /proc/pid/map_files
>      proc: use down_read_killable mmap_sem for /proc/pid/maps
>      mm: use down_read_killable for locking mmap_sem in access_remote_vm
>
>Konstantin Taranov (1):
>      RDMA/rxe: Fill in wc byte_len with IB_WC_RECV_RDMA_WITH_IMM
>
>Krunoslav Kovac (1):
>      drm/amd/display: CS_TFM_1D only applied post EOTF
>
>Leo Yan (8):
>      perf stat: Fix use-after-freed pointer detected by the smatch tool
>      perf top: Fix potential NULL pointer dereference detected by the sma=
tch tool
>      perf trace: Fix potential NULL pointer dereference found by the smat=
ch tool
>      perf session: Fix potential NULL pointer dereference found by the sm=
atch tool
>      perf map: Fix potential NULL pointer dereference found by smatch tool
>      perf annotate: Fix dereferencing freed memory found by the smatch to=
ol
>      perf hists browser: Fix potential NULL pointer dereference found by =
the smatch tool
>      perf intel-bts: Fix potential NULL pointer dereference found by the =
smatch tool
>
>Linus Torvalds (1):
>      access: avoid the RCU grace period for the temporary subjective cred=
entials
>
>Liu, Changcheng (1):
>      RDMA/i40iw: Set queue pair state when being queried
>
>Lucas Stach (3):
>      Revert "usb: usb251xb: Add US lanes inversion dts-bindings"
>      Revert "usb: usb251xb: Add US port lanes inversion property"
>      usb: usb251xb: Reallow swap-dx-lanes to apply to the upstream port
>
>Mao Wenan (1):
>      staging: kpc2000: report error status to spi core
>
>Marek Vasut (1):
>      PCI: sysfs: Ignore lockdep for remove attribute
>
>Martijn Coenen (1):
>      binder: Set end of SG buffer area properly.
>
>Masahiro Yamada (3):
>      fixdep: check return value of printf() and putchar()
>      powerpc/mm: mark more tlb functions as __always_inline
>      powerpc/boot: add {get, put}_unaligned_be32 to xz_config.h
>
>Mathias Nyman (1):
>      xhci: Fix crash if scatter gather is used with Immediate Data Transf=
er (IDT).
>
>Mathieu Desnoyers (1):
>      rseq/selftests: Fix Thumb mode build failure on arm32
>
>Mathieu Malaterre (1):
>      powerpc: silence a -Wcast-function-type warning in dawr_write_file_b=
ool
>
>Michael Ellerman (1):
>      powerpc/irq: Don't WARN continuously in arch_local_irq_restore()
>
>Michael Neuling (1):
>      powerpc/tm: Fix oops on sigreturn on systems without TM
>
>Mikhail Skorzhinskii (2):
>      nvme-tcp: don't use sendpage for SLAB pages
>      nvme-tcp: set the STABLE_WRITES flag when data digests are enabled
>
>Minwoo Im (1):
>      nvme: fix NULL deref for fabrics options
>
>Nathan Chancellor (1):
>      kbuild: Add -Werror=3Dunknown-warning-option to CLANG_FLAGS
>
>Nathan Lynch (2):
>      powerpc/pseries/mobility: prevent cpu hotplug during DT update
>      powerpc/rtas: retry when cpu offline races with suspend/migration
>
>Naveen N. Rao (2):
>      powerpc/xmon: Fix disabling tracing while in xmon
>      recordmcount: Fix spurious mcount entries on powerpc
>
>Neil Armstrong (1):
>      phy: meson-g12a-usb3-pcie: disable locking for cr_regmap
>
>Nicholas Kazlauskas (4):
>      drm/amd/display: Fill prescale_params->scale for RGB565
>      drm/amd/display: Disable cursor when offscreen in negative direction
>      drm/amd/display: Reset planes for color management changes
>      drm/amd/display: Always allocate initial connector state state
>
>Numfor Mbiziwo-Tiapo (1):
>      perf test mmap-thread-lookup: Initialize variable to suppress memory=
 sanitizer warning
>
>Oak Zeng (2):
>      drm/amdkfd: Fix a potential memory leak
>      drm/amdkfd: Fix sdma queue map issue
>
>Ocean Chen (1):
>      f2fs: avoid out-of-range memory access
>
>Oliver O'Halloran (1):
>      powerpc/eeh: Handle hugepages in ioremap space
>
>Ondrej Mosnacek (1):
>      selinux: check sidtab limit before adding a new entry
>
>Parav Pandit (1):
>      IB/mlx5: Fixed reporting counters on 2nd port for Dual port RoCE
>
>Paul Hsieh (1):
>      drm/amd/display: Disable ABM before destroy ABM struct
>
>Peter Griffin (1):
>      drm/lima: handle shared irq case for lima_pp_bcast_irq_handler
>
>Peter Ujfalusi (1):
>      drm/panel: simple: Fix panel_simple_dsi_probe
>
>Phong Tran (1):
>      usb: wusbcore: fix unbalanced get/put cluster_id
>
>Qian Cai (1):
>      powerpc/cacheflush: fix variable set but not used
>
>Qu Wenruo (1):
>      btrfs: inode: Don't compress if NODATASUM or NODATACOW set
>
>Quentin Deslandes (1):
>      staging: vt6656: use meaningful error code during buffer allocation
>
>Raul E Rangel (1):
>      mmc: sdhci: sdhci-pci-o2micro: Check if controller supports 8-bit wi=
dth
>
>Rautkoski Kimmo EXT (1):
>      serial: 8250: Fix TX interrupt handling condition
>
>Robert Hancock (1):
>      mfd: core: Set fwnode for created devices
>
>Roman Li (1):
>      drm/amd/display: Fill plane attrs only for valid pxl format
>
>Ryan Kennedy (1):
>      usb: pci-quirks: Correct AMD PLL quirk detection
>
>Sahitya Tummala (1):
>      f2fs: fix is_idle() check for discard type
>
>Sam Bobroff (1):
>      drm/bochs: Fix connector leak during driver unload
>
>Sam Ravnborg (1):
>      sh: prevent warnings when using iounmap
>
>Samson Tam (1):
>      drm/amd/display: set link->dongle_max_pix_clk to 0 on a disconnect
>
>Sean Christopherson (2):
>      KVM: nVMX: Intercept VMWRITEs to GUEST_{CS,SS}_AR_BYTES
>      KVM: nVMX: Stash L1's CR3 in vmcs01.GUEST_CR3 on nested entry w/o EPT
>
>Sean Paul (3):
>      drm/msm/a6xx: Check for ERR or NULL before iounmap
>      drm/msm/a6xx: Avoid freeing gmu resources multiple times
>      drm/msm: Depopulate platform on probe failure
>
>Sebastian Reichel (1):
>      drm/omap: don't check dispc timings for DSI
>
>Serge Semin (2):
>      tty: max310x: Fix invalid baudrate divisors calculator
>      tty: serial_core: Set port active bit in uart_port_activate
>
>Sergey Organov (1):
>      serial: imx: fix locking in set_termios()
>
>Shakeel Butt (1):
>      memcg, fsnotify: no oom-kill for remote memcg charging
>
>Shawn Anastasio (1):
>      powerpc/dma: Fix invalid DMA mmap behavior
>
>Shubhrajyoti Datta (1):
>      serial: uartps: Use the same dynamic major number for all ports
>
>Stefan Roese (1):
>      serial: mctrl_gpio: Check if GPIO property exisits before requesting=
 it
>
>Suraj Jitindar Singh (4):
>      KVM: PPC: Book3S HV: Always save guest pmu for guest capable of nest=
ing
>      KVM: PPC: Book3S HV: Save and restore guest visible PSSCR bits on ps=
eries
>      powerpc/mm: Limit rma_size to 1TB when running without HV mode
>      powerpc/pmu: Set pmcregs_in_use in paca when running as LPAR
>
>S=E9bastien Szymanski (1):
>      drm/panel: Add support for Armadeus ST0700 Adapt
>
>Takashi Iwai (2):
>      ALSA: pcm: Fix refcount_inc() on zero usage
>      ALSA: hda - Fix intermittent CORB/RIRB stall on Intel chips
>
>Thierry Reding (1):
>      gpu: host1x: Increase maximum DMA segment size
>
>Thinh Nguyen (1):
>      usb: core: hub: Disable hub-initiated U1/U2
>
>Tiecheng Zhou (1):
>      drm/amdgpu/sriov: Need to initialize the HDP_NONSURFACE_BAStE
>
>Tomi Valkeinen (2):
>      drm/bridge: tc358767: read display_props in get_modes()
>      drm/bridge: tfp410: fix use of cancel_delayed_work_sync
>
>Valentine Fatiev (1):
>      IB/ipoib: Add child to parent list only if device initialized
>
>Vasily Gorbik (1):
>      kallsyms: exclude kasan local symbols on s390
>
>Wang Hai (1):
>      memstick: Fix error cleanup path of memstick_init
>
>Wanpeng Li (1):
>      KVM: X86: Fix fpu state crash in kvm guest
>
>Wen Yang (1):
>      pinctrl: rockchip: fix leaked of_node references
>
>Wenwen Wang (1):
>      block/bio-integrity: fix a memory leak bug
>
>Wesley Chalmers (1):
>      drm/amd/display: Update link rate from DPCD 10
>
>Will Deacon (1):
>      genksyms: Teach parser about 128-bit built-in types
>
>Yoshihiro Shimoda (3):
>      phy: renesas: rcar-gen2: Fix memory leak at error paths
>      phy: renesas: rcar-gen3-usb2: fix imbalance powered flag
>      usb-storage: Add a limitation for blk_queue_max_hw_sectors()
>
>YueHaibing (3):
>      PCI: dwc: pci-dra7xx: Fix compilation when !CONFIG_GPIOLIB
>      platform/x86: Fix PCENGINES_APU2 Kconfig warning
>      fpga-manager: altera-ps-spi: Fix build error
>
>Yurii Pavlovskyi (1):
>      platform/x86: asus-wmi: Increase input buffer size of WMI methods
>
>Yuyang Du (1):
>      locking/lockdep: Fix lock used or unused stats error
>
>Zhengyuan Liu (3):
>      io_uring: fix the sequence comparison in io_sequence_defer
>      io_uring: add a memory barrier before atomic_read
>      io_uring: fix counter inc/dec mismatch in async_list
>
>Zhenzhong Duan (1):
>      x86/speculation/mds: Apply more accurate check on hypervisor platform
>
>morten petersen (1):
>      mailbox: handle failed named mailbox channel request
>



--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl1BYokACgkQsjqdtxFL
KRXjOggArvtCVQDOs+iCSlYKfN+lU7wH9HePFrLx0rJk7oy+W5Bup8ugEKeepRG1
IeFSMIjBbPmGKBua6sdeomlLC6hqUIB1zLxog7XRRsRzPD55qSCbNDnghA230jTA
XfbYIwpYJ/Ztjl/uqC9nKnTkKE9mYn9HUW/SvqJX5SkCGwcJTOcFq2Gjqfh98usg
Ck3Y7Rbsaai3AO53oJEyKGHzYa0zA1trAT8GxIxfMAkeb1gGYEFQ45Yd2TJDkBen
AVMgXabBAd7k/0xkgHA0JOBSk4WXDSBXexPE9PKka8WckYiKIWuPV/A5vMzlAsJE
gJlhRmZOWqY2wfnFxE7czeP4wIWzNg==
=uUHv
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
