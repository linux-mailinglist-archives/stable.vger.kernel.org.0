Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13A6F159CE0
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 00:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgBKXIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 18:08:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727613AbgBKXIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Feb 2020 18:08:39 -0500
Received: from localhost (unknown [104.133.9.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0E6420714;
        Tue, 11 Feb 2020 23:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581462516;
        bh=XUcGjovXw2to7ywLz+txefRKiwGfV73bpBaIUk1aRcI=;
        h=Date:From:To:Cc:Subject:From;
        b=wzpErE3b9UXVYrhzHJlGfNQENAAYErZk8UqwvMJp0s1ALWaSG15JNq5hb+yyczkVS
         dF3EG8YKFjjBhsET/t+m5s5m9YrTG00VSnn94zeQgHjj2eooUihuHcqi4jAVBoeec1
         OX9W15qEWjNOLa3zWNjmzZYKtADx/oIbjF95l+MA=
Date:   Tue, 11 Feb 2020 15:08:36 -0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.19
Message-ID: <20200211230836.GA2260401@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.19 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 MAINTAINERS                                                      |    6=20
 Makefile                                                         |    2=20
 arch/Kconfig                                                     |    3=20
 arch/arm/include/asm/kvm_emulate.h                               |   22=20
 arch/arm/include/asm/kvm_mmio.h                                  |    2=20
 arch/arm/mach-tegra/sleep-tegra30.S                              |   11=20
 arch/arm/mm/dma-mapping.c                                        |    2=20
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi                         |    1=20
 arch/arm64/crypto/ghash-ce-glue.c                                |    2=20
 arch/arm64/include/asm/daifflags.h                               |   11=20
 arch/arm64/include/asm/kvm_emulate.h                             |   37=20
 arch/arm64/include/asm/kvm_mmio.h                                |    6=20
 arch/arm64/include/asm/ptrace.h                                  |    1=20
 arch/arm64/include/uapi/asm/ptrace.h                             |    1=20
 arch/arm64/kernel/acpi.c                                         |    2=20
 arch/arm64/kvm/inject_fault.c                                    |   70 +
 arch/mips/Makefile.postlink                                      |    2=20
 arch/mips/boot/Makefile                                          |    2=20
 arch/mips/kernel/syscalls/Makefile                               |    2=20
 arch/powerpc/Kconfig                                             |    4=20
 arch/powerpc/boot/4xx.c                                          |    2=20
 arch/powerpc/include/asm/book3s/32/kup.h                         |   22=20
 arch/powerpc/include/asm/book3s/32/pgalloc.h                     |    8=20
 arch/powerpc/include/asm/book3s/64/kup-radix.h                   |   14=20
 arch/powerpc/include/asm/book3s/64/pgalloc.h                     |    2=20
 arch/powerpc/include/asm/futex.h                                 |   10=20
 arch/powerpc/include/asm/kup.h                                   |   36=20
 arch/powerpc/include/asm/nohash/32/kup-8xx.h                     |    7=20
 arch/powerpc/include/asm/nohash/pgalloc.h                        |    8=20
 arch/powerpc/include/asm/tlb.h                                   |   11=20
 arch/powerpc/include/asm/uaccess.h                               |    4=20
 arch/powerpc/kernel/entry_32.S                                   |    3=20
 arch/powerpc/kvm/book3s_hv.c                                     |    4=20
 arch/powerpc/kvm/book3s_pr.c                                     |    4=20
 arch/powerpc/kvm/book3s_xive_native.c                            |    2=20
 arch/powerpc/mm/book3s64/pgtable.c                               |    7=20
 arch/powerpc/mm/fault.c                                          |    2=20
 arch/powerpc/mm/ptdump/ptdump.c                                  |    4=20
 arch/powerpc/platforms/pseries/hotplug-memory.c                  |    4=20
 arch/powerpc/xmon/xmon.c                                         |    9=20
 arch/riscv/net/bpf_jit_comp.c                                    |   13=20
 arch/s390/include/asm/page.h                                     |    2=20
 arch/s390/kvm/kvm-s390.c                                         |    6=20
 arch/s390/mm/hugetlbpage.c                                       |  100 ++
 arch/sparc/Kconfig                                               |    1=20
 arch/sparc/include/asm/tlb_64.h                                  |    9=20
 arch/sparc/include/uapi/asm/ipcbuf.h                             |   22=20
 arch/x86/include/asm/apic.h                                      |   10=20
 arch/x86/include/asm/kvm_host.h                                  |   13=20
 arch/x86/include/asm/x86_init.h                                  |    2=20
 arch/x86/kernel/apic/apic.c                                      |   23=20
 arch/x86/kernel/apic/msi.c                                       |  128 ++
 arch/x86/kernel/cpu/tsx.c                                        |   13=20
 arch/x86/kernel/time.c                                           |   12=20
 arch/x86/kernel/x86_init.c                                       |    1=20
 arch/x86/kvm/cpuid.c                                             |    4=20
 arch/x86/kvm/emulate.c                                           |   66 +
 arch/x86/kvm/hyperv.c                                            |   10=20
 arch/x86/kvm/i8259.c                                             |    6=20
 arch/x86/kvm/ioapic.c                                            |   15=20
 arch/x86/kvm/lapic.c                                             |   13=20
 arch/x86/kvm/mmu.c                                               |  107 +-
 arch/x86/kvm/mmutrace.h                                          |   12=20
 arch/x86/kvm/mtrr.c                                              |    8=20
 arch/x86/kvm/paging_tmpl.h                                       |   25=20
 arch/x86/kvm/pmu.h                                               |   18=20
 arch/x86/kvm/svm.c                                               |    6=20
 arch/x86/kvm/vmx/capabilities.h                                  |    5=20
 arch/x86/kvm/vmx/nested.c                                        |    4=20
 arch/x86/kvm/vmx/pmu_intel.c                                     |   24=20
 arch/x86/kvm/vmx/vmx.c                                           |    3=20
 arch/x86/kvm/x86.c                                               |  196 ++=
+-
 arch/x86/kvm/x86.h                                               |    2=20
 arch/x86/xen/enlighten_pv.c                                      |    1=20
 crypto/algapi.c                                                  |   46 -
 crypto/api.c                                                     |    7=20
 crypto/internal.h                                                |    1=20
 crypto/pcrypt.c                                                  |   37=20
 drivers/acpi/battery.c                                           |   75 +
 drivers/acpi/video_detect.c                                      |   13=20
 drivers/base/power/main.c                                        |   42=20
 drivers/bluetooth/btusb.c                                        |    6=20
 drivers/clk/tegra/clk-tegra-periph.c                             |    6=20
 drivers/cpufreq/cppc_cpufreq.c                                   |    2=20
 drivers/cpufreq/cpufreq-nforce2.c                                |    2=20
 drivers/cpufreq/cpufreq.c                                        |  147 +--
 drivers/cpufreq/freq_table.c                                     |    4=20
 drivers/cpufreq/gx-suspmod.c                                     |    2=20
 drivers/cpufreq/intel_pstate.c                                   |   38=20
 drivers/cpufreq/longrun.c                                        |    6=20
 drivers/cpufreq/pcc-cpufreq.c                                    |    2=20
 drivers/cpufreq/sh-cpufreq.c                                     |    2=20
 drivers/cpufreq/unicore2-cpufreq.c                               |    2=20
 drivers/crypto/atmel-aes.c                                       |   37=20
 drivers/crypto/ccp/ccp-dev-v3.c                                  |    1=20
 drivers/crypto/ccree/cc_aead.c                                   |    2=20
 drivers/crypto/ccree/cc_cipher.c                                 |   48 +
 drivers/crypto/ccree/cc_driver.h                                 |    1=20
 drivers/crypto/ccree/cc_pm.c                                     |   30=20
 drivers/crypto/ccree/cc_request_mgr.c                            |   51 -
 drivers/crypto/ccree/cc_request_mgr.h                            |    8=20
 drivers/crypto/hisilicon/Kconfig                                 |    1=20
 drivers/crypto/hisilicon/zip/zip.h                               |    4=20
 drivers/crypto/hisilicon/zip/zip_crypto.c                        |   92 --
 drivers/crypto/picoxcell_crypto.c                                |   15=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c        |   13=20
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c                   |   18=20
 drivers/gpu/drm/drm_dp_mst_topology.c                            |   12=20
 drivers/gpu/drm/drm_rect.c                                       |    7=20
 drivers/gpu/drm/msm/disp/mdp4/mdp4_dsi_encoder.c                 |    2=20
 drivers/hv/hv_balloon.c                                          |   13=20
 drivers/infiniband/core/umem_odp.c                               |    2=20
 drivers/infiniband/hw/mlx5/gsi.c                                 |    3=20
 drivers/md/bcache/bcache.h                                       |    3=20
 drivers/md/bcache/request.c                                      |   17=20
 drivers/md/bcache/sysfs.c                                        |   22=20
 drivers/md/dm-crypt.c                                            |   12=20
 drivers/md/dm-thin-metadata.c                                    |   10=20
 drivers/md/dm-writecache.c                                       |   42=20
 drivers/md/dm-zoned-metadata.c                                   |   23=20
 drivers/md/dm.c                                                  |    9=20
 drivers/md/persistent-data/dm-space-map-common.c                 |   27=20
 drivers/md/persistent-data/dm-space-map-common.h                 |    2=20
 drivers/md/persistent-data/dm-space-map-disk.c                   |    6=20
 drivers/md/persistent-data/dm-space-map-metadata.c               |    5=20
 drivers/media/rc/iguanair.c                                      |    2=20
 drivers/media/rc/rc-main.c                                       |   27=20
 drivers/media/usb/uvc/uvc_driver.c                               |   12=20
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c                    |  148 +--
 drivers/media/v4l2-core/videobuf-dma-sg.c                        |    5=20
 drivers/mfd/axp20x.c                                             |    2=20
 drivers/mfd/da9062-core.c                                        |    2=20
 drivers/mfd/dln2.c                                               |   13=20
 drivers/mfd/rn5t618.c                                            |    1=20
 drivers/mmc/host/mmc_spi.c                                       |   11=20
 drivers/mmc/host/sdhci-of-at91.c                                 |    9=20
 drivers/mmc/host/sdhci-pci-core.c                                |    2=20
 drivers/mtd/spi-nor/spi-nor.c                                    |    9=20
 drivers/mtd/ubi/fastmap.c                                        |   23=20
 drivers/net/bonding/bond_alb.c                                   |   44 -
 drivers/net/dsa/b53/b53_common.c                                 |    2=20
 drivers/net/dsa/bcm_sf2.c                                        |    4=20
 drivers/net/dsa/microchip/ksz9477_spi.c                          |    6=20
 drivers/net/ethernet/broadcom/bcmsysport.c                       |    3=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                        |   25=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c                |    1=20
 drivers/net/ethernet/cadence/macb_main.c                         |   14=20
 drivers/net/ethernet/dec/tulip/dmfe.c                            |    7=20
 drivers/net/ethernet/dec/tulip/uli526x.c                         |    4=20
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c                   |   14=20
 drivers/net/ethernet/marvell/mvneta.c                            |   27=20
 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h              |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c      |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c             |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c                |   15=20
 drivers/net/ethernet/mellanox/mlx5/core/fw.c                     |    2=20
 drivers/net/ethernet/pensando/ionic/ionic_if.h                   |    2=20
 drivers/net/ethernet/qlogic/qed/qed_ptp.c                        |    4=20
 drivers/net/ethernet/smsc/smc911x.c                              |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c          |    1=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                |    4=20
 drivers/net/gtp.c                                                |    4=20
 drivers/net/netdevsim/dev.c                                      |    2=20
 drivers/net/ppp/ppp_async.c                                      |   18=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c           |    1=20
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                     |   10=20
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c                 |    1=20
 drivers/nfc/pn544/pn544.c                                        |    2=20
 drivers/nvme/target/fabrics-cmd.c                                |   15=20
 drivers/nvmem/core.c                                             |    8=20
 drivers/of/Kconfig                                               |    4=20
 drivers/of/address.c                                             |    6=20
 drivers/pci/controller/dwc/pci-keystone.c                        |    6=20
 drivers/pci/controller/pci-tegra.c                               |    2=20
 drivers/phy/qualcomm/phy-qcom-apq8064-sata.c                     |    2=20
 drivers/platform/x86/intel_scu_ipc.c                             |   21=20
 drivers/power/supply/axp20x_ac_power.c                           |   31=20
 drivers/power/supply/ltc2941-battery-gauge.c                     |    2=20
 drivers/regulator/helpers.c                                      |   14=20
 drivers/scsi/csiostor/csio_scsi.c                                |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c                        |    3=20
 drivers/scsi/megaraid/megaraid_sas_fusion.c                      |    3=20
 drivers/scsi/megaraid/megaraid_sas_fusion.h                      |    1=20
 drivers/scsi/qla2xxx/qla_dbg.c                                   |    6=20
 drivers/scsi/qla2xxx/qla_dbg.h                                   |    6=20
 drivers/scsi/qla2xxx/qla_def.h                                   |    5=20
 drivers/scsi/qla2xxx/qla_init.c                                  |   34=20
 drivers/scsi/qla2xxx/qla_isr.c                                   |   12=20
 drivers/scsi/qla2xxx/qla_mbx.c                                   |    3=20
 drivers/scsi/qla2xxx/qla_nx.c                                    |    7=20
 drivers/scsi/qla2xxx/qla_target.c                                |    1=20
 drivers/scsi/qla4xxx/ql4_os.c                                    |    2=20
 drivers/scsi/ufs/ufshcd.c                                        |    3=20
 drivers/usb/dwc3/core.h                                          |    2=20
 drivers/usb/dwc3/ep0.c                                           |    4=20
 drivers/usb/dwc3/gadget.c                                        |   17=20
 drivers/usb/gadget/function/f_ecm.c                              |   16=20
 drivers/usb/gadget/function/f_fs.c                               |    2=20
 drivers/usb/gadget/function/f_ncm.c                              |   17=20
 drivers/usb/gadget/legacy/cdc2.c                                 |    2=20
 drivers/usb/gadget/legacy/g_ffs.c                                |    2=20
 drivers/usb/gadget/legacy/multi.c                                |    2=20
 drivers/usb/gadget/legacy/ncm.c                                  |    2=20
 drivers/usb/typec/tcpm/tcpci.c                                   |    6=20
 drivers/virtio/virtio_balloon.c                                  |   19=20
 drivers/virtio/virtio_pci_common.c                               |    2=20
 drivers/watchdog/watchdog_core.c                                 |   35=20
 drivers/watchdog/watchdog_dev.c                                  |   36=20
 drivers/xen/xen-balloon.c                                        |    2=20
 fs/aio.c                                                         |   20=20
 fs/attr.c                                                        |   23=20
 fs/btrfs/ctree.c                                                 |    8=20
 fs/btrfs/ctree.h                                                 |    6=20
 fs/btrfs/delayed-ref.c                                           |    8=20
 fs/btrfs/disk-io.c                                               |   22=20
 fs/btrfs/extent_io.c                                             |   55 -
 fs/btrfs/ioctl.c                                                 |    3=20
 fs/btrfs/tests/btrfs-tests.c                                     |    1=20
 fs/btrfs/tests/extent-io-tests.c                                 |    9=20
 fs/btrfs/transaction.c                                           |   30=20
 fs/btrfs/tree-log.c                                              |  432 ++=
+-------
 fs/btrfs/volumes.c                                               |   17=20
 fs/cifs/smb2pdu.c                                                |   10=20
 fs/configfs/inode.c                                              |    9=20
 fs/crypto/keyring.c                                              |   15=20
 fs/erofs/decompressor.c                                          |   22=20
 fs/eventfd.c                                                     |   15=20
 fs/ext2/super.c                                                  |    6=20
 fs/ext4/dir.c                                                    |    9=20
 fs/ext4/page-io.c                                                |   19=20
 fs/f2fs/dir.c                                                    |   11=20
 fs/f2fs/file.c                                                   |   18=20
 fs/f2fs/super.c                                                  |   14=20
 fs/fs-writeback.c                                                |    2=20
 fs/fuse/file.c                                                   |    5=20
 fs/gfs2/file.c                                                   |   72 -
 fs/gfs2/lops.c                                                   |    2=20
 fs/jbd2/journal.c                                                |    1=20
 fs/nfs/dir.c                                                     |   47 -
 fs/nfsd/filecache.c                                              |    6=20
 fs/nfsd/nfs4layouts.c                                            |    2=20
 fs/nfsd/nfs4state.c                                              |    2=20
 fs/nfsd/state.h                                                  |    2=20
 fs/nfsd/vfs.c                                                    |    1=20
 fs/ntfs/inode.c                                                  |   18=20
 fs/ocfs2/file.c                                                  |   14=20
 fs/overlayfs/file.c                                              |    2=20
 fs/overlayfs/readdir.c                                           |    8=20
 fs/read_write.c                                                  |   10=20
 fs/ubifs/dir.c                                                   |    2=20
 fs/ubifs/file.c                                                  |   22=20
 fs/ubifs/ioctl.c                                                 |    3=20
 fs/ubifs/sb.c                                                    |    2=20
 fs/ubifs/super.c                                                 |    2=20
 fs/utimes.c                                                      |    4=20
 include/asm-generic/tlb.h                                        |   22=20
 include/linux/backing-dev.h                                      |   10=20
 include/linux/cpufreq.h                                          |   32=20
 include/linux/eventfd.h                                          |   14=20
 include/linux/irq.h                                              |   18=20
 include/linux/irqdomain.h                                        |    7=20
 include/linux/kvm_host.h                                         |   13=20
 include/linux/kvm_types.h                                        |    9=20
 include/linux/mfd/rohm-bd70528.h                                 |    2=20
 include/linux/mlx5/mlx5_ifc.h                                    |    7=20
 include/linux/padata.h                                           |   34=20
 include/linux/percpu-defs.h                                      |    3=20
 include/linux/regulator/consumer.h                               |    7=20
 include/media/v4l2-rect.h                                        |    8=20
 include/net/ipx.h                                                |    5=20
 include/sound/hdaudio.h                                          |   77 +
 include/trace/events/writeback.h                                 |   37=20
 ipc/msg.c                                                        |   19=20
 kernel/bpf/devmap.c                                              |    3=20
 kernel/events/core.c                                             |   10=20
 kernel/irq/debugfs.c                                             |    1=20
 kernel/irq/irqdomain.c                                           |    1=20
 kernel/irq/msi.c                                                 |    5=20
 kernel/padata.c                                                  |  275 ++=
++--
 kernel/rcu/srcutree.c                                            |    7=20
 kernel/rcu/tree_exp.h                                            |   19=20
 kernel/rcu/tree_plugin.h                                         |   13=20
 kernel/time/alarmtimer.c                                         |    8=20
 kernel/time/clocksource.c                                        |   11=20
 kernel/trace/ftrace.c                                            |   15=20
 kernel/trace/trace.h                                             |   29=20
 kernel/trace/trace_events_hist.c                                 |   53 -
 kernel/trace/trace_probe.c                                       |    6=20
 kernel/trace/trace_sched_switch.c                                |    4=20
 lib/test_kasan.c                                                 |    1=20
 mm/backing-dev.c                                                 |    1=20
 mm/memcontrol.c                                                  |   18=20
 mm/memory_hotplug.c                                              |    9=20
 mm/migrate.c                                                     |   25=20
 mm/mmu_gather.c                                                  |   16=20
 mm/page_alloc.c                                                  |   14=20
 mm/sparse.c                                                      |    2=20
 net/core/devlink.c                                               |    6=20
 net/core/drop_monitor.c                                          |    4=20
 net/hsr/hsr_slave.c                                              |    2=20
 net/ipv4/tcp.c                                                   |    6=20
 net/ipv6/addrconf.c                                              |    3=20
 net/l2tp/l2tp_core.c                                             |    7=20
 net/netfilter/ipset/ip_set_core.c                                |   41=20
 net/rxrpc/af_rxrpc.c                                             |    2=20
 net/rxrpc/ar-internal.h                                          |   11=20
 net/rxrpc/call_object.c                                          |    4=20
 net/rxrpc/conn_client.c                                          |    3=20
 net/rxrpc/conn_event.c                                           |   30=20
 net/rxrpc/conn_object.c                                          |    3=20
 net/rxrpc/input.c                                                |    6=20
 net/rxrpc/local_object.c                                         |   23=20
 net/rxrpc/output.c                                               |   27=20
 net/rxrpc/peer_event.c                                           |   42=20
 net/sched/cls_rsvp.h                                             |    6=20
 net/sched/cls_tcindex.c                                          |   43=20
 net/sched/sch_taprio.c                                           |   92 +-
 net/sunrpc/auth_gss/svcauth_gss.c                                |    4=20
 samples/bpf/Makefile                                             |    2=20
 samples/bpf/xdp_redirect_cpu_user.c                              |   59 +
 scripts/find-unused-docs.sh                                      |    2=20
 security/smack/smack_lsm.c                                       |   41=20
 sound/drivers/dummy.c                                            |    2=20
 sound/pci/hda/hda_intel.c                                        |    4=20
 sound/pci/hda/hda_tegra.c                                        |    1=20
 sound/pci/hda/patch_hdmi.c                                       |    1=20
 sound/soc/codecs/sgtl5000.c                                      |    3=20
 sound/soc/intel/boards/skl_hda_dsp_common.c                      |   21=20
 sound/soc/meson/axg-fifo.c                                       |   27=20
 sound/soc/meson/axg-fifo.h                                       |    6=20
 sound/soc/meson/axg-frddr.c                                      |   24=20
 sound/soc/meson/axg-toddr.c                                      |   21=20
 sound/soc/sof/core.c                                             |   87 +-
 sound/soc/sof/intel/hda-loader.c                                 |    1=20
 sound/soc/sof/intel/hda.c                                        |    4=20
 sound/soc/sof/ipc.c                                              |   17=20
 sound/soc/sof/loader.c                                           |   19=20
 sound/soc/sof/pm.c                                               |   25=20
 sound/soc/sof/sof-priv.h                                         |   11=20
 sound/usb/mixer_scarlett_gen2.c                                  |   46 -
 sound/usb/validate.c                                             |    6=20
 tools/kvm/kvm_stat/kvm_stat                                      |    8=20
 tools/lib/bpf/libbpf.c                                           |    4=20
 tools/objtool/sync-check.sh                                      |    2=20
 tools/power/cpupower/lib/cpufreq.c                               |   78 +
 tools/power/cpupower/lib/cpufreq.h                               |   20=20
 tools/power/cpupower/utils/cpufreq-info.c                        |   12=20
 tools/testing/selftests/bpf/prog_tests/attach_probe.c            |    7=20
 tools/testing/selftests/bpf/prog_tests/perf_buffer.c             |   29=20
 tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c |    8=20
 tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c   |    6=20
 tools/testing/selftests/bpf/test_sockmap.c                       |   15=20
 tools/testing/selftests/tc-testing/plugin-lib/buildebpfPlugin.py |    2=20
 virt/kvm/arm/aarch32.c                                           |  117 ++
 virt/kvm/arm/mmio.c                                              |    6=20
 virt/kvm/async_pf.c                                              |   10=20
 virt/kvm/kvm_main.c                                              |  117 ++
 357 files changed, 3987 insertions(+), 2197 deletions(-)

Abhi Das (1):
      gfs2: fix gfs2_find_jhead that returns uninitialized jhead with seq 0

Alexander Lobakin (3):
      MIPS: syscalls: fix indentation of the 'SYSNR' message
      MIPS: fix indentation of the 'RELOCS' message
      MIPS: boot: fix typo in 'vmlinux.lzma.its' target

Alexei Starovoitov (1):
      selftests/bpf: Fix test_attach_probe

Amir Goldstein (2):
      utimes: Clamp the timestamps in notify_change()
      ovl: fix wrong WARN_ON() in ovl_cache_update_ino()

Amol Grover (3):
      tracing: Annotate ftrace_graph_hash pointer with __rcu
      tracing: Annotate ftrace_graph_notrace_hash pointer with __rcu
      bpf, devmap: Pass lockdep expression to RCU lists

Anand Jain (1):
      btrfs: use bool argument in free_root_pointers()

Anand Lodnoor (1):
      scsi: megaraid_sas: Do not initiate OCR if controller is not in ready=
 state

Andreas Gruenbacher (1):
      gfs2: fix O_SYNC write handling

Andreas Kemnade (1):
      mfd: rn5t618: Mark ADC control register volatile

Andrii Nakryiko (2):
      selftests/bpf: Fix perf_buffer test on systems w/ offline CPUs
      libbpf: Fix realloc usage in bpf_core_find_cands

Aneesh Kumar K.V (1):
      powerpc/mmu_gather: enable RCU_TABLE_FREE even for !SMP case

Ard Biesheuvel (2):
      crypto: ccp - set max RSA modulus size for v3 platform devices as well
      crypto: arm64/ghash-neon - bump priority to 150

Arnd Bergmann (4):
      sparc32: fix struct ipc64_perm type definition
      media: v4l2-core: compat: ignore native command codes
      nfsd: fix delay timer on 32-bit architectures
      nfsd: fix jiffies/time_t mixup in LRU list

Arun Easi (1):
      scsi: qla2xxx: Fix unbound NVME response length

Asutosh Das (1):
      scsi: ufs: Recheck bkops level if bkops is disabled

Bart Van Assche (1):
      scsi: qla2xxx: Fix the endianness of the qla82xx_get_fw_size() return=
 type

Bitan Biswas (1):
      nvmem: core: fix memory abort in cleanup path

Bj=C3=B6rn T=C3=B6pel (1):
      riscv, bpf: Fix broken BPF tail calls

Boris Ostrovsky (5):
      x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit
      x86/kvm: Introduce kvm_(un)map_gfn()
      x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not missed
      x86/kvm: Cache gfn to pfn translation
      x86/KVM: Clean up host's steal time structure

Brian Norris (1):
      mwifiex: fix unbalanced locking in mwifiex_process_country_ie()

Bryan O'Donoghue (2):
      usb: gadget: f_ncm: Use atomic_t to track in-flight request
      usb: gadget: f_ecm: Use atomic_t to track in-flight request

Casey Schaufler (1):
      broken ping to ipv6 linklocal addresses on debian buster

Cezary Rojewski (1):
      ASoC: Intel: skl_hda_dsp_common: Fix global-out-of-bounds bug

Chen-Yu Tsai (1):
      ARM: dma-api: fix max_pfn off-by-one error in __dma_supported()

Chengguang Xu (3):
      f2fs: choose hardlimit when softlimit is larger than hardlimit in f2f=
s_statfs_project()
      f2fs: fix miscounted block limit in f2fs_statfs_project()
      f2fs: code cleanup for f2fs_statfs_project()

Christian Borntraeger (1):
      KVM: s390: do not clobber registers during guest reset/store status

Christoffer Dall (1):
      KVM: arm64: Only sign-extend MMIO up to register width

Christoph Hellwig (1):
      gfs2: move setting current->backing_dev_info

Christophe Leroy (4):
      powerpc/ptdump: Fix W+X verification
      powerpc/32s: Fix bad_kuap_fault()
      powerpc/32s: Fix CPU wake-up from sleep mode
      powerpc/kuap: Fix set direction in allow/prevent_user_access()

Chuhong Yuan (1):
      crypto: picoxcell - adjust the position of tasklet_init and fix misse=
d tasklet_kill

Claudiu Beznea (2):
      drm: atmel-hlcdc: use double rate for pixel clock only if supported
      drm: atmel-hlcdc: enable clock before configuring timing engine

Colin Ian King (1):
      Bluetooth: btusb: fix memory leak on fw

Coly Li (1):
      bcache: add readahead cache policy options via sysfs interface

Cong Wang (2):
      net_sched: fix an OOB access in cls_tcindex
      net_sched: fix a resource leak in tcindex_set_parms()

Dan Carpenter (1):
      ubi: Fix an error pointer dereference in error handling code

Dan Williams (1):
      mm/memory_hotplug: fix remove_memory() lockdep splat

Daniel Verkamp (2):
      virtio-balloon: initialize all vq callbacks
      virtio-pci: check name when counting MSI-X vectors

David Engraf (1):
      PCI: tegra: Fix return value check of pm_runtime_get_sync()

David Hildenbrand (3):
      mm/page_alloc.c: fix uninitialized memmaps on a partially populated l=
ast section
      virtio-balloon: Fix memory leak when unloading while hinting is in pr=
ogress
      virtio_balloon: Fix memory leaks on errors in virtballoon_probe()

David Howells (5):
      rxrpc: Fix use-after-free in rxrpc_put_local()
      rxrpc: Fix insufficient receive notification generation
      rxrpc: Fix missing active use pinning of rxrpc_local object
      rxrpc: Fix NULL pointer deref due to call->conn being cleared on disc=
onnect
      rxrpc: Fix service call disconnection

Davide Caratti (1):
      tc-testing: fix eBPF tests failure on linux fresh clones

Dejin Zheng (1):
      net: stmmac: fix a possible endless loop

Dmitry Fomichev (1):
      dm zoned: support zone sizes smaller than 128MiB

Erdem Aktas (1):
      percpu: Separate decrypted varaibles anytime encryption can be enabled

Eric Biggers (7):
      fscrypt: don't print name of busy file when removing key
      ubifs: don't trigger assertion on invalid no-key filename
      ubifs: Fix FS_IOC_SETFLAGS unexpectedly clearing encrypt flag
      f2fs: fix dcache lookup of !casefolded directories
      f2fs: fix race conditions in ->d_compare() and ->d_hash()
      ext4: fix deadlock allocating crypto bounce page from mempool
      ext4: fix race conditions in ->d_compare() and ->d_hash()

Eric Dumazet (9):
      cls_rsvp: fix rsvp_policy
      net: hsr: fix possible NULL deref in hsr_handle_frame()
      tcp: clear tp->total_retrans in tcp_disconnect()
      tcp: clear tp->delivered in tcp_disconnect()
      tcp: clear tp->data_segs{in|out} in tcp_disconnect()
      tcp: clear tp->segs_{in|out} in tcp_disconnect()
      rcu: Avoid data-race in rcu_gp_fqs_check_wake()
      bonding/alb: properly access headers in bond_alb_xmit()
      ipv6/addrconf: fix potential NULL deref in inet6_set_link_af()

Filipe Manana (5):
      fs: allow deduplication of eof block into the end of the destination =
file
      Btrfs: fix missing hole after hole punching and fsync when using NO_H=
OLES
      Btrfs: make deduplication with range including the last block work
      Btrfs: fix infinite loop during fsync after rename operations
      Btrfs: fix race between adding and putting tree mod seq elements and =
nodes

Florian Fainelli (3):
      net: dsa: b53: Always use dev->vlan_enabled in b53_configure_vlan()
      net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP port
      net: systemport: Avoid RBUF stuck in Wake-on-LAN mode

Gang He (1):
      ocfs2: fix oops when writing cloned file

Gao Xiang (1):
      erofs: fix out-of-bound read for shifted uncompressed block

Gavin Shan (1):
      tools/kvm_stat: Fix kvm_exit filter name

Geert Uytterhoeven (1):
      scripts/find-unused-docs: Fix massive false positives

Gerald Schaefer (1):
      s390/mm: fix dynamic pagetable upgrade for hugetlbfs

Gilad Ben-Yossef (4):
      crypto: ccree - fix backlog memory leak
      crypto: ccree - fix AEAD decrypt auth fail
      crypto: ccree - fix pm wrongful error reporting
      crypto: ccree - fix PM race condition

Greg Kroah-Hartman (1):
      Linux 5.4.19

Gustavo A. R. Silva (1):
      lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()

Hangbin Liu (1):
      selftests/bpf: Skip perf hw events test if the setup disabled it

Hans de Goede (5):
      ALSA: hda: Add Clevo W65_67SB the power_save blacklist
      ACPI: video: Do not export a non working backlight interface on MSI M=
S-7721 boards
      ACPI / battery: Deal with design or full capacity being reported as -1
      ACPI / battery: Use design-cap for capacity calculations if full-cap =
is not available
      ACPI / battery: Deal better with neither design nor full capacity not=
 being reported

Harini Katakam (2):
      net: macb: Remove unnecessary alignment check for TSO
      net: macb: Limit maximum GEM TX length in TSO

Helen Koike (1):
      media: v4l2-rect.h: fix v4l2_rect_map_inside() top/left adjustments

Herbert Xu (6):
      crypto: api - Check spawn->alg under lock in crypto_drop_spawn
      padata: Remove broken queue flushing
      crypto: pcrypt - Avoid deadlock by using per-instance padata queues
      crypto: api - fix unexpectedly getting generic implementation
      crypto: pcrypt - Do not clear MAY_SLEEP flag in original request
      crypto: api - Fix race condition in crypto_spawn_alg

Ido Schimmel (1):
      drop_monitor: Do not cancel uninitialized work item

Israel Rukshin (2):
      nvmet: Fix error print message at nvmet_install_queue function
      nvmet: Fix controller use after free

Jacob Keller (1):
      devlink: report 0 after hitting end in region read

Jens Axboe (2):
      eventfd: track eventfd_signal() recursion depth
      aio: prevent potential eventfd recursion on poll

Jerome Brunet (1):
      ASoC: meson: axg-fifo: fix fifo threshold setup

Jesper Dangaard Brouer (1):
      samples/bpf: Xdp_redirect_cpu fix missing tracepoint attach

Joe Thornber (1):
      dm space map common: fix to ensure new block isn't already in use

Johan Hovold (1):
      media: iguanair: fix endpoint sanity check

John Allen (1):
      kvm/svm: PKU not currently supported

John Hubbard (1):
      media/v4l2-core: set pages dirty upon releasing DMA buffers

Jonathan Cameron (1):
      crypto: hisilicon - Use the offset fields in sqe to avoid need to spl=
it scatterlists

Josef Bacik (5):
      btrfs: fix improper setting of scanned for range cyclic write cache p=
ages
      btrfs: set trans->drity in btrfs_commit_transaction
      btrfs: drop log root for dropped roots
      btrfs: flush write bio if we loop in extent_write_cache_pages
      btrfs: free block groups after free'ing fs trees

Juergen Gross (1):
      xen/balloon: Support xend-based toolstack take two

Jun Li (1):
      usb: typec: tcpci: mask event interrupts when remove driver

Kadlecsik J=C3=B3zsef (1):
      netfilter: ipset: fix suspicious RCU usage in find_set_and_id

Kai-Heng Feng (1):
      Bluetooth: btusb: Disable runtime suspend on Realtek devices

Kevin Hao (1):
      irqdomain: Fix a memory leak in irq_domain_push_irq()

Kishon Vijay Abraham I (1):
      PCI: keystone: Fix error handling when "num-viewport" DT property is =
not populated

Konstantin Khlebnikov (1):
      clocksource: Prevent double add_timer_on() for watchdog_timer

Linus Walleij (1):
      mmc: spi: Toggle SPI polarity, do not hardcode it

Lorenz Bauer (2):
      selftests: bpf: Use a temporary file in test_sockmap
      selftests: bpf: Ignore FIN packets for reuseport tests

Lorenzo Bianconi (1):
      net: mvneta: move rx_dropped and rx_errors in per-cpu stats

Lu Shuaibing (1):
      ipc/msg.c: consolidate all xxxctl_down() functions

Luca Coelho (1):
      iwlwifi: don't throw error when trying to remove IGTK

Lukas Bulwahn (1):
      MAINTAINERS: correct entries for ISDN/mISDN section

Lyude Paul (1):
      drm/amd/dm/mst: Ignore payload update failures

Madalin Bucur (1):
      dpaa_eth: support all modes with rate adapting PHYs

Maor Gottlieb (1):
      net/mlx5: Fix deadlock in fs_core

Marco Felsch (1):
      mfd: da9062: Fix watchdog compatible string

Marek Vasut (2):
      regulator: core: Add regulator_is_equal() helper
      ASoC: sgtl5000: Fix VDDA and VDDIO comparison

Marios Pomonis (12):
      KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF attacks
      KVM: x86: Refactor prefix decoding to prevent Spectre-v1/L1TF attacks
      KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks
      KVM: x86: Protect DR-based index computations from Spectre-v1/L1TF at=
tacks
      KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF attacks
      KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data() from Spectre-v1/L=
1TF attacks
      KVM: x86: Protect ioapic_write_indirect() from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations in pmu.h from Spectre-=
v1/L1TF attacks
      KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations from Spectre-v1/L1TF a=
ttacks in x86.c
      KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations in fixed_msr_to_seg_un=
it() from Spectre-v1/L1TF attacks

Mark Rutland (4):
      arm64: acpi: fix DAIF manipulation with pNMI
      KVM: arm64: Correct PSTATE on exception entry
      KVM: arm/arm64: Correct CPSR on exception entry
      KVM: arm/arm64: Correct AArch32 SPSR on exception entry

Mathieu Desnoyers (1):
      tracing: Fix sched switch start/stop refcount racy updates

Matti Vaittinen (1):
      mfd: bd70528: Fix hour register mask

Miaohe Lin (1):
      KVM: nVMX: vmread should not set rflags to specify success in case of=
 #PF

Michael Chan (1):
      bnxt_en: Fix TC queue mapping.

Michael Ellerman (2):
      of: Add OF_DMA_DEFAULT_COHERENT & select it on powerpc
      powerpc/futex: Fix incorrect user access blocking

Micha=C5=82 Miros=C5=82aw (1):
      mmc: sdhci-of-at91: fix memleak on clk_get failure

Mika Westerberg (1):
      platform/x86: intel_scu_ipc: Fix interrupt support

Mike Snitzer (2):
      dm thin metadata: use pool locking at end of dm_pool_metadata_close
      dm: fix potential for q->make_request_fn NULL pointer

Miklos Szeredi (2):
      ovl: fix lseek overflow on 32bit
      fix up iter on short count in fuse_direct_io()

Mikulas Patocka (2):
      dm writecache: fix incorrect flush sequence when doing SSD mode commit
      dm crypt: fix GFP flags passed to skcipher_request_alloc()

Milan Broz (1):
      dm crypt: fix benbi IV constructor crash if used in authenticated mode

Nathan Chancellor (10):
      scsi: csiostor: Adjust indentation in csio_device_reset
      scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free
      phy: qualcomm: Adjust indentation in read_poll_timeout
      ext2: Adjust indentation in ext2_fill_super
      powerpc/44x: Adjust indentation in ibm4xx_denali_fixup_memsize
      drm: msm: mdp4: Adjust indentation in mdp4_dsi_encoder_enable
      NFC: pn544: Adjust indentation in pn544_hci_check_presence
      ppp: Adjust indentation into ppp_async_input
      net: smc911x: Adjust indentation in smc911x_phy_configure
      net: tulip: Adjust indentation in {dmfe, uli526x}_init_module

Navid Emamdoost (1):
      brcmfmac: Fix memory leak in brcmf_usbdev_qinit

Nicolin Chen (1):
      net: stmmac: Delete txtimer in suspend()

Niklas Cassel (1):
      arm64: dts: qcom: qcs404-evb: Set vdd_apc regulator in high power mode

Nikolay Borisov (2):
      btrfs: Handle another split brain scenario with metadata uuid feature
      btrfs: Correctly handle empty trees in find_first_clear_extent_bit

Ofir Drang (1):
      crypto: ccree - fix FDE descriptor sequence

Oliver Neukum (1):
      mfd: dln2: More sanity checking for endpoints

Olof Johansson (1):
      objtool: Silence build output

Paolo Bonzini (2):
      KVM: x86: use CPUID to locate host page table reserved bits
      KVM: x86: fix overlap between SPTE_MMIO_MASK and generation

Paul E. McKenney (3):
      rcu: Use *_ONCE() to protect lockless ->expmask accesses
      srcu: Apply *_ONCE() to ->srcu_last_gp_end
      rcu: Use READ_ONCE() for ->expmask in rcu_read_unlock_special()

Pawan Gupta (1):
      x86/cpu: Update cached HLE state on write to TSX_CTRL_CPUID_CLEAR

Peter Chen (1):
      usb: gadget: f_fs: set req->num_sgs as 0 for non-sg transfer

Peter Rosin (1):
      drm: atmel-hlcdc: prefer a lower pixel-clock than requested

Peter Zijlstra (1):
      mm/mmu_gather: invalidate TLB correctly on batch allocation failure a=
nd flush

Pierre-Louis Bossart (2):
      ASoC: SOF: core: free trace on errors
      ASoC: SOF: core: release resources on errors in probe_continue

Pingfan Liu (2):
      mm/sparse.c: reset section's mem_map when fully deactivated
      powerpc/pseries: Advance pfn if section is not present in lmb_is_remo=
vable()

Prabhath Sajeepa (1):
      IB/mlx5: Fix outstanding_pi index for GSI qps

Quanyang Wang (1):
      ubifs: Fix memory leak from c->sup_node

Quinn Tran (2):
      scsi: qla2xxx: Fix mtcp dump collection failure
      scsi: qla2xxx: Fix stuck login session using prli_pend_timer

Raed Salem (2):
      net/mlx5: IPsec, Fix esp modify function attribute
      net/mlx5: IPsec, fix memory leak at mlx5_fpga_ipsec_delete_sa_ctx

Rafael J. Wysocki (2):
      PM: core: Fix handling of devices deleted during system-wide resume
      cpufreq: Avoid creating excessively large stack frames

Ranjani Sridharan (1):
      ASoC: SOF: Introduce state machine for FW boot

Razvan Stefanescu (1):
      net: dsa: microchip: enable module autoprobe

Ridge Kennedy (1):
      l2tp: Allow duplicate session creation with UDP

Roberto Bergantinos Corpas (1):
      sunrpc: expiry_time should be seconds not timeval

Roger Quadros (1):
      usb: gadget: legacy: set max_speed to super-speed

Ronnie Sahlberg (1):
      cifs: fail i/o on soft mounts if sessionsetup errors out

Samuel Holland (2):
      mfd: axp20x: Mark AXP20X_VBUS_IPSOUT_MGMT as volatile
      power: supply: axp20x_ac_power: Fix reporting online status

Sascha Hauer (2):
      ubifs: Fix wrong memory allocation
      ubi: fastmap: Fix inverted logic in seen selfcheck

Sean Christopherson (13):
      KVM: x86: Fix potential put_fpu() w/o load_fpu() on MPX platform
      KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails
      KVM: PPC: Book3S PR: Free shared page if mmu initialization fails
      KVM: VMX: Add non-canonical check on writes to RTIT address MSRs
      KVM: x86: Don't let userspace set host-reserved cr4 bits
      KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails
      KVM: x86: Handle TIF_NEED_FPU_LOAD in kvm_{load,put}_guest_fpu()
      KVM: x86: Ensure guest's FPU state is loaded when accessing for emula=
tion
      KVM: x86: Revert "KVM: X86: Fix fpu state crash in kvm guest"
      KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM
      KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM
      KVM: Use vcpu-specific gva->hva translation when querying host page s=
ize
      KVM: Play nice with read-only memslots when querying host page size

Sean Young (1):
      media: rc: ensure lirc is initialized before registering input device

Shannon Nelson (1):
      ionic: fix rxq comp packet type mask

Song Liu (1):
      perf/core: Fix mlock accounting in perf_mmap()

Stephen Boyd (1):
      alarmtimer: Unregister wakeup source when module get fails

Stephen Rothwell (1):
      regulator fix for "regulator: core: Add regulator_is_equal() helper"

Stephen Warren (2):
      ARM: tegra: Enable PLLP bypass during Tegra124 LP1
      clk: tegra: Mark fuse clock as critical

Steven Rostedt (VMware) (3):
      tracing/kprobes: Have uname use __get_str() in print_fmt
      ftrace: Add comment to why rcu_dereference_sched() is open coded
      ftrace: Protect ftrace_graph_hash with ftrace_sync

Sudarsana Reddy Kalluru (1):
      qed: Fix timestamping issue for L2 unicast ptp packets.

Sukadev Bhattiprolu (1):
      powerpc/xmon: don't access ASDR in VMs

Sven Van Asbroeck (1):
      power: supply: ltc2941-battery-gauge: fix use-after-free

Taehee Yoo (2):
      gtp: use __GFP_NOWARN to avoid memalloc warning
      netdevsim: fix stack-out-of-bounds in nsim_dev_debugfs_init()

Takashi Iwai (4):
      ALSA: usb-audio: Fix endianess in descriptor validation
      ALSA: usb-audio: Annotate endianess in Scarlett gen2 quirk
      ALSA: dummy: Fix PCM format loop in proc output
      ALSA: hda: Apply aligned MMIO access only conditionally

Tariq Toukan (1):
      net/mlx5: Deprecate usage of generic TLS HW capability bit

Theodore Ts'o (1):
      memcg: fix a crash in wb_workfn when a device disappears

Thinh Nguyen (2):
      usb: dwc3: gadget: Check END_TRANSFER completion
      usb: dwc3: gadget: Delay starting transfer

Thomas Gleixner (2):
      x86/timer: Don't skip PIT setup when APIC is disabled or in legacy mo=
de
      x86/apic/msi: Plug non-maskable MSI affinity race

Thomas Renninger (1):
      cpupower: Revert library ABI changes from commit ae2917093fb60bdc1ed3e

Tianyu Lan (1):
      hv_balloon: Balloon up according to request page number

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      samples/bpf: Don't try to remove user's homedir on clean

Tom Zanussi (1):
      tracing: Fix now invalid var_ref_vals assumption in trace action

Trond Myklebust (4):
      NFS: Fix memory leaks and corruption in readdir
      NFS: Directory page cache pages need to be locked when read
      nfsd: fix filecache lookup
      nfsd: Return the correct number of bytes written to the file

Tudor Ambarus (1):
      crypto: atmel-aes - Fix counter overflow in CTR mode

Vasily Averin (1):
      jbd2_seq_info_next should increase position index

Vasundhara Volam (2):
      bnxt_en: Move devlink_register before registering netdev
      bnxt_en: Fix logic that disables Bus Master during firmware reset.

Vignesh Raghavendra (1):
      mtd: spi-nor: Split mt25qu512a (n25q512a) entry into two

Ville Syrj=C3=A4l=C3=A4 (1):
      drm/rect: Avoid division by zero

Vinicius Costa Gomes (5):
      taprio: Fix enabling offload with wrong number of traffic classes
      taprio: Fix still allowing changing the flags during runtime
      taprio: Add missing policy validation for flags
      taprio: Use taprio_reset_tc() to reset Traffic Classes configuration
      taprio: Fix dropping packets when using taprio + ETF offloading

Vladis Dronov (1):
      watchdog: fix UAF in reboot notifier handling in watchdog core code

Wayne Lin (1):
      drm/dp_mst: Remove VCPI while disabling topology mgr

Wei Yang (1):
      mm: thp: don't need care deferred split queue in memcg charge move pa=
th

Will Deacon (1):
      media: uvcvideo: Avoid cyclic entity chains due to malformed USB desc=
riptors

Yang Shi (1):
      mm: move_pages: report the number of non-attempted pages

Yishai Hadas (1):
      IB/core: Fix ODP get user pages flow

Yong Zhi (1):
      ALSA: hda: Add JasperLake PCI ID and codec vid

Yurii Monakov (2):
      PCI: keystone: Fix outbound region mapping
      PCI: keystone: Fix link training retries initiation

Zhihao Cheng (1):
      ubifs: Fix deadlock in concurrent bulk-read and writepage

zhengbin (1):
      mmc: sdhci-pci: Make function amd_sdhci_reset static


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5DM/MACgkQONu9yGCS
aT49ig/8Cb1yvq+O1N//Zd0cNh98dSDoWwAcPASNZAr+7bR0AW8w63weEZC/1yut
OCW5Sqyo95/Ru+ca8G8kriICllY48NJ9yNKCcXd7v8t82HSBVJ4CcLJ2WEQAOr1b
8wnjQbStQPMdVnsjvILG43OoniDV9GSrUWtMjNUGarsWVVNtl/e99bYP91IIAmqY
QWj84gasQr5N1SRgIgRIKmfmgw++Lp3HoT9re7ue8E4cd5MtKhXAc41W+S97cgKt
ASN2XJCOWyRHeBVi2aj+X6Yh7QM2CrfejFZgMszktRTQXoAP1K4FqWCpPrmgAMGu
GP3Q9EJh3GcOsO2z6Qa2dWsjKrC/fBC0j5LE6x4Ezx4rBEeLWmkVwzJazcicfNLC
pvKTX3/mqFoyMVvuRKmoivX7BE2+L7xceR3+riDD4tZ2Sp4NtlAxAnI/jlmWFzqC
DLDZ8zLS7pY6vfyMyRUxC4GxCeW+8JHJtqcb9jN9Ri86t2uABY5PhMYcPjkGu4XP
YnvdOWShA4Aq+ONKY2ZNvATuLZ1a0zGOXyid2AWoIJ2tOu/55wHeLw+NFUgTCs18
fQhL0783aZjViEmsZOyacsohjWzEpX4YJGTYXoGF/yu0KUGwTa2aBiyBgAnwmYh0
LpADljcgTDtDCi6uilBoolXPVYQ12tToX1/utXyLxSUBGXv7ppk=
=pUcr
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
