Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9595F1DBA9C
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 19:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgETREY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 13:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727975AbgETREX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 13:04:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A293207D4;
        Wed, 20 May 2020 17:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589994262;
        bh=U8/x4sYQw5hgWUZEPb7jTELVqeog2HR4mdgQom/nwt0=;
        h=Subject:To:Cc:From:Date:From;
        b=nGsP9wBfm32MIpxxHEJbfpEAWNTAPFxzDOcK92LnRVuulUTX/Ws88Nsw/5D/B8oCz
         oXUYIQZ2Ao0gC5Lroc2R1DMTmVpSIi2BbTBganYOXI3Zp1mx+TVvzghB4bO2oMzreK
         8FYDLnkXVXFiEZO4oQQfxVYuPDTACjgzuE7t0kik=
Subject: Linux 5.6.14
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed, 20 May 2020 19:03:57 +0200
Message-ID: <158999423720233@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.6.14 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/core-api/printk-formats.rst                        |   14 
 Documentation/devicetree/bindings/dma/fsl-edma.txt               |    3 
 Makefile                                                         |   18 
 arch/arm/boot/dts/dra7.dtsi                                      |    4 
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts                 |    4 
 arch/arm/boot/dts/imx6dl-yapp4-ursa.dts                          |    2 
 arch/arm/boot/dts/r8a73a4.dtsi                                   |    9 
 arch/arm/boot/dts/r8a7740.dtsi                                   |    2 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi                |    2 
 arch/arm64/boot/dts/amlogic/meson-g12b-khadas-vim3.dtsi          |    4 
 arch/arm64/boot/dts/amlogic/meson-g12b-ugoos-am6.dts             |    2 
 arch/arm64/boot/dts/freescale/imx8mn.dtsi                        |    2 
 arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi                     |    4 
 arch/arm64/boot/dts/renesas/r8a77980.dtsi                        |    2 
 arch/arm64/boot/dts/rockchip/rk3328-evb.dts                      |    2 
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts                   |    2 
 arch/arm64/boot/dts/rockchip/rk3399.dtsi                         |    4 
 arch/arm64/kernel/machine_kexec.c                                |    1 
 arch/powerpc/include/asm/book3s/32/kup.h                         |    2 
 arch/powerpc/include/asm/uaccess.h                               |   49 +-
 arch/powerpc/kernel/ima_arch.c                                   |    6 
 arch/powerpc/kernel/vdso32/gettimeofday.S                        |    6 
 arch/riscv/include/asm/perf_event.h                              |    8 
 arch/riscv/kernel/Makefile                                       |    2 
 arch/riscv/kernel/vdso/Makefile                                  |    6 
 arch/x86/include/asm/ftrace.h                                    |    6 
 arch/x86/include/asm/kvm_host.h                                  |    1 
 arch/x86/include/asm/stackprotector.h                            |    7 
 arch/x86/kernel/ftrace.c                                         |   29 +
 arch/x86/kernel/smpboot.c                                        |    8 
 arch/x86/kernel/unwind_orc.c                                     |   16 
 arch/x86/kvm/vmx/nested.c                                        |   19 -
 arch/x86/kvm/vmx/vmx.c                                           |   18 
 arch/x86/kvm/x86.c                                               |   19 -
 arch/x86/mm/init_64.c                                            |    3 
 arch/x86/xen/smp_pv.c                                            |    1 
 crypto/lrw.c                                                     |    4 
 crypto/xts.c                                                     |    4 
 drivers/acpi/ec.c                                                |   24 -
 drivers/acpi/internal.h                                          |    1 
 drivers/acpi/sleep.c                                             |   14 
 drivers/block/virtio_blk.c                                       |   86 ++++
 drivers/clk/clk.c                                                |    3 
 drivers/clk/rockchip/clk-rk3228.c                                |   17 
 drivers/clk/ti/clkctrl.c                                         |    1 
 drivers/cpufreq/intel_pstate.c                                   |    2 
 drivers/dma/mmp_tdma.c                                           |    5 
 drivers/dma/pch_dma.c                                            |    2 
 drivers/dma/xilinx/xilinx_dma.c                                  |   20 -
 drivers/firmware/efi/tpm.c                                       |    2 
 drivers/gpio/gpio-pca953x.c                                      |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c                           |    3 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                            |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                |   26 +
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c                 |   12 
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c                  |   28 -
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c               |    3 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c            |    2 
 drivers/gpu/drm/amd/powerplay/amd_powerplay.c                    |    6 
 drivers/gpu/drm/i915/display/intel_ddi.c                         |   14 
 drivers/gpu/drm/i915/display/intel_display_power.c               |   12 
 drivers/gpu/drm/i915/display/intel_dp.c                          |    5 
 drivers/gpu/drm/i915/display/intel_fbc.c                         |    3 
 drivers/gpu/drm/i915/display/intel_sprite.c                      |   17 
 drivers/gpu/drm/i915/gem/i915_gem_domain.c                       |    7 
 drivers/gpu/drm/i915/gt/intel_engine.h                           |    9 
 drivers/gpu/drm/i915/gt/intel_engine_types.h                     |   18 
 drivers/gpu/drm/i915/gt/intel_lrc.c                              |    8 
 drivers/gpu/drm/i915/gvt/scheduler.c                             |    6 
 drivers/gpu/drm/i915/i915_drv.h                                  |    2 
 drivers/gpu/drm/i915/i915_gem_evict.c                            |   26 -
 drivers/gpu/drm/i915/i915_irq.c                                  |   16 
 drivers/gpu/drm/i915/i915_request.c                              |    8 
 drivers/gpu/drm/i915/i915_scheduler.c                            |    6 
 drivers/gpu/drm/i915/i915_scheduler.h                            |    3 
 drivers/gpu/drm/i915/i915_scheduler_types.h                      |    1 
 drivers/gpu/drm/i915/intel_pm.c                                  |    2 
 drivers/gpu/drm/qxl/qxl_image.c                                  |    3 
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c                           |    2 
 drivers/gpu/drm/tegra/drm.c                                      |    3 
 drivers/gpu/host1x/dev.c                                         |   13 
 drivers/hwmon/da9052-hwmon.c                                     |    4 
 drivers/hwmon/drivetemp.c                                        |    2 
 drivers/infiniband/core/cache.c                                  |    7 
 drivers/infiniband/core/nldev.c                                  |    3 
 drivers/infiniband/core/rdma_core.c                              |    3 
 drivers/infiniband/core/uverbs.h                                 |    4 
 drivers/infiniband/core/uverbs_main.c                            |   12 
 drivers/infiniband/core/uverbs_std_types_async_fd.c              |   30 +
 drivers/infiniband/hw/cxgb4/cm.c                                 |    7 
 drivers/infiniband/hw/hfi1/user_sdma.c                           |    4 
 drivers/infiniband/hw/i40iw/i40iw_hw.c                           |    2 
 drivers/infiniband/hw/mlx4/qp.c                                  |   14 
 drivers/infiniband/sw/rxe/rxe_mmap.c                             |    2 
 drivers/infiniband/sw/rxe/rxe_queue.c                            |   11 
 drivers/iommu/amd_iommu.c                                        |  175 +++++++--
 drivers/iommu/amd_iommu_types.h                                  |    9 
 drivers/mmc/core/block.c                                         |    3 
 drivers/mmc/core/queue.c                                         |   16 
 drivers/mmc/host/alcor.c                                         |    6 
 drivers/mmc/host/sdhci-acpi.c                                    |   10 
 drivers/mmc/host/sdhci-pci-gli.c                                 |   23 +
 drivers/net/dsa/dsa_loop.c                                       |    1 
 drivers/net/dsa/ocelot/felix.c                                   |    1 
 drivers/net/dsa/ocelot/felix.h                                   |    1 
 drivers/net/dsa/ocelot/felix_vsc9959.c                           |    1 
 drivers/net/ethernet/broadcom/Kconfig                            |    1 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c                 |   29 -
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h                 |    1 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c             |    2 
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c                |   16 
 drivers/net/ethernet/huawei/hinic/hinic_main.c                   |   16 
 drivers/net/ethernet/moxa/moxart_ether.c                         |    2 
 drivers/net/ethernet/mscc/ocelot.c                               |   17 
 drivers/net/ethernet/mscc/ocelot_regs.c                          |    1 
 drivers/net/ethernet/natsemi/jazzsonic.c                         |    6 
 drivers/net/ethernet/netronome/nfp/abm/main.c                    |    4 
 drivers/net/ethernet/realtek/r8169_main.c                        |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c          |   17 
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c                     |    2 
 drivers/net/hyperv/netvsc_drv.c                                  |    3 
 drivers/net/phy/microchip_t1.c                                   |  171 +++++++++
 drivers/net/phy/phy.c                                            |    8 
 drivers/net/ppp/pppoe.c                                          |    3 
 drivers/net/virtio_net.c                                         |    6 
 drivers/pinctrl/intel/pinctrl-baytrail.c                         |    1 
 drivers/pinctrl/intel/pinctrl-cherryview.c                       |    4 
 drivers/pinctrl/intel/pinctrl-sunrisepoint.c                     |   15 
 drivers/pinctrl/qcom/pinctrl-msm.c                               |    2 
 drivers/s390/net/ism_drv.c                                       |    4 
 drivers/usb/cdns3/gadget.c                                       |    2 
 drivers/usb/core/devio.c                                         |   19 -
 drivers/usb/core/hub.c                                           |    6 
 drivers/usb/dwc3/gadget.c                                        |    3 
 drivers/usb/gadget/configfs.c                                    |    3 
 drivers/usb/gadget/legacy/audio.c                                |    4 
 drivers/usb/gadget/legacy/cdc2.c                                 |    4 
 drivers/usb/gadget/legacy/ncm.c                                  |    4 
 drivers/usb/gadget/udc/net2272.c                                 |    2 
 drivers/usb/gadget/udc/tegra-xudc.c                              |    8 
 drivers/usb/host/xhci-plat.c                                     |    4 
 drivers/usb/host/xhci-ring.c                                     |    4 
 fs/cachefiles/rdwr.c                                             |   10 
 fs/cifs/cifssmb.c                                                |    2 
 fs/eventpoll.c                                                   |   48 +-
 fs/exec.c                                                        |    4 
 fs/gfs2/bmap.c                                                   |   16 
 fs/gfs2/lops.c                                                   |   19 -
 fs/io_uring.c                                                    |    4 
 fs/ioctl.c                                                       |    8 
 fs/iomap/fiemap.c                                                |    5 
 fs/nfs/fscache.c                                                 |   39 --
 fs/nfs/mount_clnt.c                                              |    3 
 fs/nfs/nfs4state.c                                               |    2 
 fs/nfs/super.c                                                   |    1 
 fs/notify/fanotify/fanotify.c                                    |   11 
 include/linux/compiler.h                                         |    6 
 include/linux/fs.h                                               |    2 
 include/linux/ftrace.h                                           |   23 +
 include/linux/host1x.h                                           |    3 
 include/linux/memcontrol.h                                       |    2 
 include/linux/pnp.h                                              |   29 -
 include/linux/skmsg.h                                            |    1 
 include/linux/sunrpc/gss_api.h                                   |    3 
 include/linux/sunrpc/gss_krb5.h                                  |    6 
 include/linux/sunrpc/xdr.h                                       |    1 
 include/linux/tty.h                                              |    2 
 include/net/netfilter/nf_conntrack.h                             |    2 
 include/net/sch_generic.h                                        |    1 
 include/net/tcp.h                                                |   13 
 include/soc/mscc/ocelot.h                                        |    1 
 include/sound/rawmidi.h                                          |    1 
 include/trace/events/rpcrdma.h                                   |   12 
 init/Kconfig                                                     |   18 
 init/initramfs.c                                                 |    2 
 init/main.c                                                      |   75 +++-
 ipc/util.c                                                       |   12 
 kernel/bpf/arraymap.c                                            |    7 
 kernel/bpf/syscall.c                                             |    4 
 kernel/bpf/verifier.c                                            |   16 
 kernel/fork.c                                                    |   13 
 kernel/trace/Kconfig                                             |    1 
 kernel/trace/bpf_trace.c                                         |   94 +++--
 kernel/trace/ftrace_internal.h                                   |   22 -
 kernel/trace/preemptirq_delay_test.c                             |   12 
 kernel/umh.c                                                     |    6 
 lib/vsprintf.c                                                   |   12 
 mm/shmem.c                                                       |    7 
 net/core/dev.c                                                   |    4 
 net/core/drop_monitor.c                                          |   11 
 net/core/filter.c                                                |    2 
 net/core/netprio_cgroup.c                                        |    2 
 net/ipv4/cipso_ipv4.c                                            |    6 
 net/ipv4/route.c                                                 |    2 
 net/ipv4/tcp.c                                                   |   27 +
 net/ipv4/tcp_bpf.c                                               |   10 
 net/ipv4/tcp_input.c                                             |    3 
 net/ipv6/calipso.c                                               |    3 
 net/ipv6/route.c                                                 |    6 
 net/mptcp/subflow.c                                              |   10 
 net/netfilter/nf_conntrack_core.c                                |   17 
 net/netfilter/nf_flow_table_core.c                               |    8 
 net/netfilter/nft_set_rbtree.c                                   |   11 
 net/netlabel/netlabel_kapi.c                                     |    6 
 net/rds/message.c                                                |   19 -
 net/rds/rdma.c                                                   |   12 
 net/rds/rds.h                                                    |    3 
 net/rds/send.c                                                   |    6 
 net/sched/cls_api.c                                              |    8 
 net/sunrpc/auth_gss/auth_gss.c                                   |   12 
 net/sunrpc/auth_gss/gss_krb5_crypto.c                            |    8 
 net/sunrpc/auth_gss/gss_krb5_wrap.c                              |   44 +-
 net/sunrpc/auth_gss/gss_mech_switch.c                            |    3 
 net/sunrpc/auth_gss/svcauth_gss.c                                |   10 
 net/sunrpc/clnt.c                                                |    5 
 net/sunrpc/xdr.c                                                 |   41 ++
 net/sunrpc/xprtrdma/backchannel.c                                |    2 
 net/sunrpc/xprtrdma/frwr_ops.c                                   |   14 
 net/sunrpc/xprtrdma/transport.c                                  |    2 
 net/sunrpc/xprtrdma/verbs.c                                      |   15 
 net/sunrpc/xprtrdma/xprt_rdma.h                                  |    5 
 scripts/kallsyms.c                                               |    2 
 sound/core/rawmidi.c                                             |   31 +
 sound/firewire/amdtp-stream-trace.h                              |    3 
 sound/pci/hda/patch_hdmi.c                                       |    2 
 sound/pci/hda/patch_realtek.c                                    |   41 ++
 sound/usb/quirks.c                                               |    9 
 tools/testing/selftests/bpf/prog_tests/mmap.c                    |    9 
 tools/testing/selftests/bpf/progs/test_overhead.c                |    4 
 tools/testing/selftests/ftrace/ftracetest                        |   22 +
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_type.tc |    2 
 virt/kvm/arm/vgic/vgic-mmio-v2.c                                 |   10 
 virt/kvm/arm/vgic/vgic-mmio-v3.c                                 |   12 
 virt/kvm/arm/vgic/vgic-mmio.c                                    |  187 ++++++----
 virt/kvm/arm/vgic/vgic-mmio.h                                    |   11 
 235 files changed, 1920 insertions(+), 830 deletions(-)

Adam Ford (2):
      gpio: pca953x: Fix pca953x_gpio_set_config
      arm64: dts: imx8mn: Change SDMA1 ahb clock for imx8mn

Adam McCoy (1):
      cifs: fix leaked reference on requeued write

Adrian Hunter (1):
      mmc: block: Fix request completion in the CQE timeout path

Alan Maguire (1):
      ftrace/selftests: workaround cgroup RT scheduling issues

Alex Deucher (1):
      drm/amdgpu: force fbdev into vram

Amir Goldstein (1):
      fanotify: fix merging marks masks with FAN_ONDIR

Andreas Gruenbacher (2):
      gfs2: Another gfs2_walk_metadata fix
      gfs2: More gfs2_find_jhead fixes

Andy Shevchenko (2):
      pinctrl: sunrisepoint: Fix PAD lock register offset for SPT-H
      pinctrl: baytrail: Enable pin configuration setting for GPIO chip

Ansuel Smith (1):
      pinctrl: qcom: fix wrong write in update_dual_edge

Arnd Bergmann (3):
      drop_monitor: work around gcc-10 stringop-overflow warning
      sun6i: dsi: fix gcc-4.8
      netfilter: conntrack: avoid gcc-10 zero-length-bounds warning

Babu Moger (1):
      KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c

Ben Chuang (2):
      mmc: sdhci-pci-gli: Fix no irq handler from suspend
      mmc: sdhci-pci-gli: Fix can not access GL9750 after reboot from Windows 10

Bjorn Andersson (1):
      arm64: dts: qcom: msm8996: Reduce vdd_apc voltage

Borislav Petkov (1):
      x86: Fix early boot crash on gcc-10, third try

Chen-Yu Tsai (2):
      arm64: dts: rockchip: Replace RK805 PMIC node name with "pmic" on rk3328 boards
      arm64: dts: rockchip: Rename dwc3 device nodes on rk3399 to make dtc happy

Chris Wilson (5):
      cpufreq: intel_pstate: Only mention the BIOS disabling turbo mode once
      drm/i915/gt: Make timeslicing an explicit engine property
      drm/i915/gem: Remove object_is_locked assertion from unpin_from_display_plane
      drm/i915: Mark concurrent submissions with a weak-dependency
      drm/i915: Handle idling during i915_gem_evict_something busy loops

Christian Brauner (1):
      fork: prevent accidental access to clone3 features

Christoph Hellwig (1):
      arm64: fix the flush_icache_range arguments in machine_kexec

Christophe JAILLET (5):
      net/sonic: Fix a resource leak in an error handling path in 'jazz_sonic_probe()'
      net: moxa: Fix a potential double 'free_irq()'
      mmc: alcor: Fix a resource leak in the error path for ->probe()
      usb: gadget: net2272: Fix a memory leak in an error handling path in 'net2272_plat_probe()'
      usb: gadget: audio: Fix a missing error return value in audio_bind()

Christophe Leroy (2):
      powerpc/vdso32: Fallback on getres syscall when clock is unknown
      powerpc/32s: Fix build failure with CONFIG_PPC_KUAP_DEBUG

Chuck Lever (6):
      xprtrdma: Clean up the post_send path
      xprtrdma: Fix trace point use-after-free race
      SUNRPC: Add "@len" parameter to gss_unwrap()
      SUNRPC: Fix GSS privacy computation of auth->au_ralign
      SUNRPC: Signalled ASYNC tasks need to exit
      SUNRPC: Revert 241b1f419f0e ("SUNRPC: Remove xdr_buf_trim()")

Colin Ian King (1):
      net: stmmac: gmac5+: fix potential integer overflow on 32 bit multiply

Cong Wang (2):
      net_sched: fix tcm_parent in tc filter dump
      net: fix a potential recursive NETDEV_FEAT_CHANGE

Dan Carpenter (2):
      dpaa2-eth: prevent array underflow in update_cls_rule()
      i40iw: Fix error handling in i40iw_manage_arp_cache()

Daniel Borkmann (1):
      bpf: Restrict bpf_trace_printk()'s %s usage and add %pks, %pus specifier

Dave Wysochanski (3):
      NFS: Fix fscache super_cookie index_key from changing after umount
      NFS: Fix fscache super_cookie allocation
      NFSv4: Fix fscache cookie aux_data to ensure change_attr is included

David Howells (1):
      cachefiles: Fix corruption of the return value in cachefiles_read_or_alloc_pages()

Dmytro Laktyushkin (1):
      drm/amd/display: check if REFCLK_CNTL register is present

Eric Dumazet (2):
      tcp: fix error recovery in tcp_zerocopy_receive()
      tcp: fix SO_RCVLOWAT hangs with fat skbs

Eric W. Biederman (1):
      exec: Move would_dump into flush_old_exec

Eugeniu Rosca (1):
      usb: core: hub: limit HUB_QUIRK_DISABLE_AUTOSUSPEND to USB5534B

Fabio Estevam (1):
      ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1 pinctrl entries

Florian Fainelli (2):
      net: dsa: loop: Add module soft dependency
      net: broadcom: Select BROADCOM_PHY for BCMGENET

Florian Westphal (1):
      netfilter: conntrack: fix infinite loop on rmmod

Geert Uytterhoeven (2):
      ARM: dts: r8a73a4: Add missing CMT1 interrupts
      ARM: dts: r8a7740: Add missing extal2 to CPG node

Grace Kao (1):
      pinctrl: cherryview: Add missing spinlock usage in chv_gpio_irq_handler

Greg Kroah-Hartman (2):
      USB: usbfs: fix mmap dma mismatch
      Linux 5.6.14

Guenter Roeck (1):
      hwmon: (drivetemp) Fix SCT support if SCT data tables are not supported

Guillaume Nault (1):
      pppoe: only process PADT targeted at local interfaces

Heiner Kallweit (2):
      net: phy: fix aneg restart in phy_ethtool_set_eee
      r8169: re-establish support for RTL8401 chip version

Hugh Dickins (1):
      shmem: fix possible deadlocks on shmlock_user_lock

Ilie Halip (1):
      riscv: fix vdso build with lld

Imre Deak (1):
      drm/i915/tgl+: Fix interrupt handling for DP AUX transactions

Ioana Ciornei (1):
      dpaa2-eth: properly handle buffer size restrictions

J. Bruce Fields (1):
      nfs: fix NULL deference in nfs4_get_valid_delegation

Jack Morgenstein (2):
      IB/mlx4: Test return value of calls to ib_get_cached_pkey
      IB/core: Fix potential NULL pointer dereference in pkey cache

Jason Gunthorpe (4):
      pnp: Use list_for_each_entry() instead of open coding
      net/rds: Use ERR_PTR for rds_message_alloc_sgs()
      RDMA/uverbs: Do not discard the IB_EVENT_DEVICE_FATAL event
      RDMA/uverbs: Move IB_EVENT_DEVICE_FATAL to destroy_uobj

Jeremy Linton (1):
      usb: usbfs: correct kernel->user page attribute mismatch

Jesus Ramos (1):
      ALSA: usb-audio: Add control message quirk delay for Kingston HyperX headset

Jim Mattson (1):
      KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce

Joerg Roedel (2):
      iommu/amd: Fix race in increase_address_space()/fetch_pte()
      iommu/amd: Update Device Table in increase_address_space()

John Fastabend (2):
      bpf, sockmap: msg_pop_data can incorrecty set an sge length
      bpf, sockmap: bpf_tcp_ingress needs to subtract bytes from sg.size

John Stultz (1):
      dwc3: Remove check for HWO flag in dwc3_gadget_ep_reclaim_trb_sg()

Josh Poimboeuf (1):
      x86/unwind/orc: Fix error handling in __unwind_start()

José Roberto de Souza (1):
      drm/i915/display: Load DP_TP_CTL/STATUS offset before use it

Justin Swartz (1):
      clk: rockchip: fix incorrect configuration of rk3228 aclk_gpu* clocks

Kai Vehmanen (1):
      ALSA: hda/hdmi: fix race in monitor detection during probe

Kai-Heng Feng (2):
      ALSA: hda/realtek - Fix S3 pop noise on Dell Wyse
      Revert "ALSA: hda/realtek: Fix pop noise on ALC225"

Kefeng Wang (1):
      riscv: perf: RISCV_BASE_PMU should be independent

Kelly Littlepage (1):
      net: tcp: fix rx timestamp behavior for tcp_recvmsg

Kishon Vijay Abraham I (1):
      ARM: dts: dra7: Fix bus_dma_limit for PCIe

Kyungtae Kim (1):
      USB: gadget: fix illegal array access in binding with UDC

Li Jun (1):
      usb: host: xhci-plat: keep runtime active when removing host

Linus Torvalds (8):
      Stop the ad-hoc games with -Wno-maybe-initialized
      gcc-10: disable 'zero-length-bounds' warning for now
      gcc-10: disable 'array-bounds' warning for now
      gcc-10: disable 'stringop-overflow' warning for now
      gcc-10: disable 'restrict' warning for now
      gcc-10 warnings: fix low-hanging fruit
      gcc-10: mark more functions __init to avoid section mismatch warnings
      gcc-10: avoid shadowing standard library 'free()' in crypto

Lubomir Rintel (2):
      dmaengine: mmp_tdma: Do not ignore slave config validation errors
      dmaengine: mmp_tdma: Reset channel error on release

Luo bin (1):
      hinic: fix a bug of ndo_stop

Maciej Żenczykowski (1):
      Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"

Madhuparna Bhowmik (1):
      dmaengine: pch_dma.c: Avoid data race between probe and irq handler

Maor Gottlieb (1):
      RDMA/core: Fix double put of resource

Marc Zyngier (3):
      KVM: arm: vgic: Synchronize the whole guest on GIC{D,R}_I{S,C}ACTIVER read
      KVM: arm: vgic-v2: Only use the virtual state when userspace accesses pending bits
      clk: Unlink clock if failed to prepare or enable

Masami Hiramatsu (2):
      bootconfig: Fix to remove bootconfig data from initrd while boot
      bootconfig: Fix to prevent warning message if no bootconfig option

Matt Roper (2):
      drm/i915/tgl: Add Wa_14010477008:tgl
      drm/i915/tgl: TBT AUX should use TC power well ops

Michael S. Tsirkin (1):
      virtio_net: fix lockdep warning on 32 bit

Michael Walle (1):
      dt-bindings: dma: fsl-edma: fix ls1028a-edma compatible

Michal Vokáč (1):
      ARM: dts: imx6dl-yapp4: Fix Ursa board Ethernet connection

Mike Marciniszyn (1):
      IB/hfi1: Fix another case where pq is left on waitlist

Nathan Chancellor (1):
      hv_netvsc: Fix netvsc_start_xmit's return type

Nayna Jain (1):
      powerpc/ima: Fix secure boot rules in ima arch policy

Neil Armstrong (3):
      arm64: dts: meson-g12b-ugoos-am6: fix usb vbus-supply
      arm64: dts: meson-g12b-khadas-vim3: add missing frddr_a status property
      arm64: dts: meson-g12-common: fix dwc2 clock names

Nicholas Kazlauskas (1):
      drm/amd/display: Defer cursor update around VUPDATE for all ASIC

Nicholas Piggin (1):
      powerpc/uaccess: Evaluate macro arguments once, before user access is allowed

Olga Kornievskaia (1):
      NFSv3: fix rpc receive buffer size for MOUNT call

Oliver Upton (2):
      KVM: nVMX: Consolidate nested MTF checks to helper function
      kvm: nVMX: reflect MTF VM-exits if injected by L1

Pablo Neira Ayuso (1):
      netfilter: flowtable: set NF_FLOW_TEARDOWN flag on entry expiration

Paolo Abeni (3):
      mptcp: set correct vfs info for subflows
      netlabel: cope with NULL catmap
      net: ipv4: really enforce backoff for redirects

Pavel Begunkov (1):
      io_uring: check non-sync defer_list carefully

Peter Chen (1):
      usb: cdns3: gadget: prev_req->trb is NULL for ep0

Peter Jones (1):
      Make the "Reducing compressed framebufer size" message be DRM_INFO_ONCE()

Phil Sutter (1):
      netfilter: nft_set_rbtree: Add missing expired checks

Potnuri Bharat Teja (1):
      RDMA/iw_cxgb4: Fix incorrect function parameters

Rafael J. Wysocki (1):
      ACPI: EC: PM: Avoid premature returns from acpi_s2idle_wake()

Raul E Rangel (1):
      mmc: sdhci-acpi: Add SDHCI_QUIRK2_BROKEN_64_BIT_DMA for AMDI0040

Ritesh Harjani (1):
      fibmap: Warn and return an error in case of block > INT_MAX

Roman Penyaev (1):
      epoll: call final ep_events_available() check under the lock

Samu Nuutamo (1):
      hwmon: (da9052) Synchronize access with mfd

Sarthak Garg (1):
      mmc: core: Fix recursive locking issue in CQE recovery path

Sasha Levin (1):
      bpf: Fix bug in mmap() implementation for BPF array map

Sebastian von Ohr (1):
      dmaengine: xilinx_dma: Add missing check for empty list

Sergei Trofimovich (1):
      Makefile: disallow data races on gcc-10 as well

Simon Ser (1):
      drm/amd/display: add basic atomic check for cursor plane

Sriharsha Allenki (1):
      usb: xhci: Fix NULL pointer dereference when enqueuing trbs from urb sg list

Stefan Hajnoczi (1):
      virtio-blk: handle block_device_operations callbacks after hot unplug

Steven Rostedt (VMware) (2):
      tracing: Wait for preempt irq delay thread to execute
      x86/ftrace: Have ftrace trampolines turn read-only at the end of system boot up

Sudip Mukherjee (1):
      RDMA/rxe: Always return ERR_PTR from rxe_create_mmap_info()

Sultan Alsawaf (1):
      drm/i915: Don't enable WaIncreaseLatencyIPCEnabled when IPC is disabled

Sung Lee (1):
      drm/amd/display: Update downspread percent to match spreadsheet for DCN2.1

Takashi Iwai (3):
      ALSA: hda/realtek - Limit int mic boost for Thinkpad T530
      ALSA: hda/realtek - Add COEF workaround for ASUS ZenBook UX431DA
      ALSA: rawmidi: Fix racy buffer resize under concurrent accesses

Takashi Sakamoto (1):
      ALSA: firewire-lib: fix 'function sizeof not defined' error of tracepoints format

Tero Kristo (1):
      clk: ti: clkctrl: Fix Bad of_node_put within clkctrl_get_name

Thierry Reding (2):
      drm/tegra: Fix SMMU support on Tegra124 and Tegra210
      usb: gadget: tegra-xudc: Fix idle suspend/resume

Tiecheng Zhou (1):
      drm/amd/powerplay: avoid using pm_en before it is initialized revised

Tom St Denis (1):
      drm/amd/amdgpu: add raven1 part to the gfxoff quirk list

Vasily Averin (2):
      drm/qxl: lost qxl_bo_kunmap_atomic_page in qxl_image_init_helper()
      ipc/util.c: sysvipc_find_ipc() incorrectly updates position index

Veerabhadrarao Badiganti (1):
      mmc: core: Check request type before completing the request

Vincent Minet (1):
      umh: fix memory leak on execve failure

Vinod Koul (1):
      net: stmmac: fix num_por initialization

Vladimir Oltean (2):
      net: dsa: ocelot: the MAC table on Felix is twice as large
      net: mscc: ocelot: ANA_AUTOAGE_AGE_PERIOD holds a value in seconds, not ms

Wei Yongjun (5):
      nfp: abm: fix error return code in nfp_abm_vnic_alloc()
      bpf: Fix error return code in map_lookup_and_delete_elem()
      s390/ism: fix error return code in ism_probe()
      usb: gadget: legacy: fix error return code in gncm_bind()
      usb: gadget: legacy: fix error return code in cdc_bind()

Xiao Yang (1):
      selftests/ftrace: Check the first record for kprobe_args_type.tc

Xiaodong Yan (1):
      drm/amd/display: blank dp stream before re-train the link

Xiaoguang Wang (1):
      io_uring: use cond_resched() in io_ring_ctx_wait_and_kill()

Xiyu Yang (1):
      bpf: Fix sk_psock refcnt leak when receiving message

Yafang Shao (1):
      mm, memcg: fix inconsistent oom event behavior

Yonghong Song (2):
      bpf: Enforce returning 0 for fentry/fexit progs
      selftests/bpf: Enforce returning 0 for fentry/fexit programs

Yoshihiro Shimoda (1):
      arm64: dts: renesas: r8a77980: Fix IPMMU VIP[01] nodes

Yuiko Oshino (1):
      net: phy: microchip_t1: add lan87xx_phy_init to initialize the lan87xx phy.

Zefan Li (1):
      netprio_cgroup: Fix unlimited memory leak of v2 cgroups

Zhenyu Wang (1):
      drm/i915/gvt: Fix kernel oops for 3-level ppgtt guest

