Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3936670D7
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 12:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjALL2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 06:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjALL1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 06:27:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B3413F08;
        Thu, 12 Jan 2023 03:18:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A10F62005;
        Thu, 12 Jan 2023 11:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD6AC433EF;
        Thu, 12 Jan 2023 11:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673522291;
        bh=5QtZTvAtZ0GQxXpAgDAKCPmZ3TWacfbOpF+aNTw1jTg=;
        h=From:To:Cc:Subject:Date:From;
        b=2OvBUmQlGuxBRBM/DV2TH3rRFraO8AY94TbFnMdtNMgiQ4V8gzx4jl11l7pl5akah
         /pAW8/ExEIX30Y8hU2TeHnDTPJXELDeFEP1x2oOnjiEtetLB/Kg268UBiidqPTUGOH
         BBHGEvIv8CiFQEOrApLfGNGXalmBlb9XogR35auQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.87
Date:   Thu, 12 Jan 2023 12:18:06 +0100
Message-Id: <167352228525119@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.87 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arm/include/asm/thread_info.h                             |   13 
 arch/arm/nwfpe/Makefile                                        |    6 
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts                     |    5 
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts           |    6 
 arch/powerpc/kernel/rtas.c                                     |   20 
 arch/riscv/include/asm/mmu.h                                   |    2 
 arch/riscv/include/asm/pgtable.h                               |    2 
 arch/riscv/include/asm/tlbflush.h                              |   18 
 arch/riscv/include/asm/uaccess.h                               |    2 
 arch/riscv/kernel/probes/simulate-insn.h                       |    4 
 arch/riscv/kernel/stacktrace.c                                 |    2 
 arch/riscv/mm/context.c                                        |   10 
 arch/riscv/mm/tlbflush.c                                       |   28 
 arch/x86/events/intel/uncore.h                                 |    1 
 arch/x86/events/intel/uncore_snbep.c                           |   22 
 arch/x86/kernel/cpu/bugs.c                                     |    2 
 arch/x86/kernel/cpu/mce/amd.c                                  |   37 -
 arch/x86/kernel/cpu/mce/core.c                                 |   95 +--
 arch/x86/kernel/cpu/mce/internal.h                             |   12 
 arch/x86/kernel/cpu/microcode/intel.c                          |    8 
 arch/x86/kernel/crash.c                                        |    4 
 arch/x86/kernel/ftrace.c                                       |    2 
 arch/x86/kernel/kprobes/core.c                                 |   10 
 arch/x86/kernel/kprobes/opt.c                                  |   28 
 arch/x86/kvm/vmx/nested.c                                      |   47 +
 arch/x86/kvm/vmx/sgx.c                                         |    4 
 block/bfq-iosched.c                                            |    2 
 block/blk-merge.c                                              |   10 
 block/mq-deadline.c                                            |   84 ++
 drivers/acpi/resource.c                                        |   78 ++
 drivers/acpi/x86/s2idle.c                                      |   10 
 drivers/ata/ahci.c                                             |   32 -
 drivers/base/dd.c                                              |    6 
 drivers/char/ipmi/ipmi_msghandler.c                            |    4 
 drivers/char/ipmi/ipmi_si_intf.c                               |   27 
 drivers/char/tpm/eventlog/acpi.c                               |   12 
 drivers/char/tpm/tpm_crb.c                                     |   29 -
 drivers/char/tpm/tpm_tis.c                                     |    9 
 drivers/cpufreq/cpufreq.c                                      |    2 
 drivers/crypto/ccp/sp-pci.c                                    |   11 
 drivers/crypto/n2_core.c                                       |    6 
 drivers/devfreq/devfreq.c                                      |    6 
 drivers/devfreq/governor_userspace.c                           |   12 
 drivers/firmware/efi/efi.c                                     |    4 
 drivers/firmware/efi/libstub/efistub.h                         |    2 
 drivers/firmware/efi/libstub/random.c                          |   42 +
 drivers/gpio/gpio-sifive.c                                     |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                        |   13 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                     |    3 
 drivers/gpu/drm/drm_connector.c                                |    3 
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c                   |    4 
 drivers/gpu/drm/i915/gt/intel_migrate.c                        |    8 
 drivers/gpu/drm/i915/gvt/debugfs.c                             |   17 
 drivers/gpu/drm/i915/gvt/scheduler.c                           |    1 
 drivers/gpu/drm/imx/ipuv3-plane.c                              |   14 
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c                      |    6 
 drivers/gpu/drm/meson/meson_viu.c                              |    5 
 drivers/gpu/drm/mgag200/mgag200_pll.c                          |    3 
 drivers/gpu/drm/panfrost/panfrost_drv.c                        |   27 
 drivers/gpu/drm/panfrost/panfrost_gem.c                        |   16 
 drivers/gpu/drm/panfrost/panfrost_gem.h                        |    5 
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                            |    3 
 drivers/hid/hid-ids.h                                          |    3 
 drivers/hid/hid-multitouch.c                                   |    4 
 drivers/hid/hid-plantronics.c                                  |    9 
 drivers/infiniband/hw/mlx5/counters.c                          |    6 
 drivers/infiniband/hw/mlx5/qp.c                                |   49 +
 drivers/iommu/amd/init.c                                       |    7 
 drivers/md/dm-cache-metadata.c                                 |   54 +
 drivers/md/dm-cache-target.c                                   |   11 
 drivers/md/dm-clone-target.c                                   |    1 
 drivers/md/dm-integrity.c                                      |    2 
 drivers/md/dm-thin-metadata.c                                  |   60 +-
 drivers/md/dm-thin.c                                           |   18 
 drivers/md/md-bitmap.c                                         |   20 
 drivers/md/md.c                                                |    9 
 drivers/media/dvb-core/dmxdev.c                                |    8 
 drivers/media/dvb-core/dvbdev.c                                |    1 
 drivers/media/dvb-frontends/stv0288.c                          |    5 
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c                  |    4 
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c                   |   12 
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c                |   14 
 drivers/mfd/mt6360-core.c                                      |   14 
 drivers/mmc/host/sdhci-sprd.c                                  |   16 
 drivers/mmc/host/vub300.c                                      |    2 
 drivers/mtd/spi-nor/core.c                                     |    2 
 drivers/net/bonding/bond_3ad.c                                 |    1 
 drivers/net/dsa/mv88e6xxx/Kconfig                              |    4 
 drivers/net/ethernet/amazon/ena/ena_com.c                      |   29 -
 drivers/net/ethernet/amazon/ena/ena_ethtool.c                  |    6 
 drivers/net/ethernet/amazon/ena/ena_netdev.c                   |   83 ++
 drivers/net/ethernet/amazon/ena/ena_netdev.h                   |   17 
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                       |    3 
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c                       |    4 
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c                      |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                |  178 ++----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h                |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c        |   75 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c      |    3 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c       |   30 -
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c      |   11 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c              |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                |   12 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h                |    4 
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c  |    7 
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c |   33 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c              |   30 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h              |    6 
 drivers/net/ethernet/mellanox/mlx5/core/health.c               |    6 
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c          |    4 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                 |    2 
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c            |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c          |    8 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h                |   10 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c               |    8 
 drivers/net/ethernet/renesas/ravb_main.c                       |    2 
 drivers/net/phy/xilinx_gmii2rgmii.c                            |    1 
 drivers/net/usb/rndis_host.c                                   |    3 
 drivers/net/veth.c                                             |    5 
 drivers/net/vmxnet3/vmxnet3_drv.c                              |    8 
 drivers/net/wireless/microchip/wilc1000/sdio.c                 |    1 
 drivers/nvme/host/core.c                                       |   32 -
 drivers/nvme/host/nvme.h                                       |    2 
 drivers/nvme/host/pci.c                                        |   37 -
 drivers/nvme/target/admin-cmd.c                                |   35 -
 drivers/nvme/target/passthru.c                                 |   11 
 drivers/of/kexec.c                                             |   10 
 drivers/parisc/led.c                                           |    3 
 drivers/pci/pci-sysfs.c                                        |   13 
 drivers/pci/pci.c                                              |    2 
 drivers/phy/qualcomm/phy-qcom-qmp.c                            |    8 
 drivers/remoteproc/remoteproc_core.c                           |    9 
 drivers/rtc/rtc-ds1347.c                                       |    2 
 drivers/soc/qcom/Kconfig                                       |    1 
 drivers/soc/ux500/ux500-soc-id.c                               |   10 
 drivers/soundwire/dmi-quirks.c                                 |    8 
 drivers/soundwire/intel.c                                      |    8 
 drivers/soundwire/qcom.c                                       |    8 
 drivers/soundwire/stream.c                                     |    4 
 drivers/staging/media/ipu3/ipu3-v4l2.c                         |   57 +-
 drivers/staging/media/tegra-video/csi.c                        |    4 
 drivers/staging/media/tegra-video/csi.h                        |    2 
 drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c |    4 
 drivers/usb/dwc3/dwc3-qcom.c                                   |   13 
 drivers/vdpa/vdpa_sim/vdpa_sim.c                               |    3 
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c                           |    4 
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c                           |    4 
 drivers/vhost/vhost.c                                          |    4 
 drivers/vhost/vringh.c                                         |    5 
 drivers/vhost/vsock.c                                          |    9 
 drivers/video/fbdev/matrox/matroxfb_base.c                     |    4 
 fs/binfmt_elf_fdpic.c                                          |    5 
 fs/btrfs/backref.c                                             |    4 
 fs/btrfs/disk-io.c                                             |   35 -
 fs/btrfs/disk-io.h                                             |    6 
 fs/btrfs/ioctl.c                                               |    9 
 fs/btrfs/rcu-string.h                                          |    6 
 fs/btrfs/super.c                                               |   76 ++
 fs/btrfs/tree-defrag.c                                         |    6 
 fs/btrfs/volumes.c                                             |   43 -
 fs/ceph/caps.c                                                 |    2 
 fs/ceph/locks.c                                                |    4 
 fs/ceph/super.h                                                |    1 
 fs/cifs/cifsfs.c                                               |    8 
 fs/cifs/cifsglob.h                                             |   69 ++
 fs/cifs/cifsproto.h                                            |    4 
 fs/cifs/connect.c                                              |    4 
 fs/cifs/misc.c                                                 |    4 
 fs/cifs/smb2ops.c                                              |  143 ++---
 fs/dlm/lowcomms.c                                              |    9 
 fs/ext4/balloc.c                                               |    2 
 fs/ext4/ext4.h                                                 |    9 
 fs/ext4/ext4_jbd2.c                                            |    3 
 fs/ext4/extents.c                                              |    8 
 fs/ext4/extents_status.c                                       |    3 
 fs/ext4/fast_commit.c                                          |  285 ++++++----
 fs/ext4/fast_commit.h                                          |    7 
 fs/ext4/indirect.c                                             |   13 
 fs/ext4/inode.c                                                |   50 +
 fs/ext4/ioctl.c                                                |   13 
 fs/ext4/namei.c                                                |   47 -
 fs/ext4/orphan.c                                               |   26 
 fs/ext4/resize.c                                               |    6 
 fs/ext4/super.c                                                |   52 +
 fs/ext4/verity.c                                               |    2 
 fs/ext4/xattr.c                                                |   19 
 fs/f2fs/gc.c                                                   |    1 
 fs/f2fs/node.c                                                 |    3 
 fs/hfs/inode.c                                                 |   13 
 fs/hfsplus/hfsplus_fs.h                                        |    2 
 fs/hfsplus/inode.c                                             |   16 
 fs/hfsplus/options.c                                           |    4 
 fs/ksmbd/auth.c                                                |    3 
 fs/ksmbd/connection.c                                          |    7 
 fs/ksmbd/transport_tcp.c                                       |    5 
 fs/locks.c                                                     |   23 
 fs/mbcache.c                                                   |  121 +---
 fs/nfsd/nfs4xdr.c                                              |   11 
 fs/nfsd/nfssvc.c                                               |    2 
 fs/ntfs3/attrib.c                                              |   18 
 fs/ntfs3/attrlist.c                                            |    5 
 fs/ntfs3/bitmap.c                                              |    2 
 fs/ntfs3/file.c                                                |    4 
 fs/ntfs3/frecord.c                                             |   14 
 fs/ntfs3/fslog.c                                               |   35 -
 fs/ntfs3/fsntfs.c                                              |   10 
 fs/ntfs3/index.c                                               |    6 
 fs/ntfs3/inode.c                                               |    9 
 fs/ntfs3/record.c                                              |   10 
 fs/ntfs3/super.c                                               |    9 
 fs/overlayfs/dir.c                                             |   46 +
 fs/pnode.c                                                     |    2 
 fs/pstore/ram.c                                                |    2 
 fs/pstore/zone.c                                               |    2 
 fs/quota/dquot.c                                               |    2 
 fs/udf/inode.c                                                 |    2 
 include/linux/devfreq.h                                        |    7 
 include/linux/efi.h                                            |    2 
 include/linux/fs.h                                             |    6 
 include/linux/mbcache.h                                        |   33 -
 include/linux/mlx5/device.h                                    |    5 
 include/linux/mlx5/mlx5_ifc.h                                  |    3 
 include/linux/netfilter/ipset/ip_set.h                         |    2 
 include/linux/nvme.h                                           |    3 
 include/linux/sunrpc/rpc_pipe_fs.h                             |    5 
 include/net/mptcp.h                                            |   12 
 include/net/netfilter/nf_tables.h                              |   25 
 include/sound/soc-dai.h                                        |   32 -
 include/trace/events/ext4.h                                    |    7 
 include/trace/events/jbd2.h                                    |   44 -
 io_uring/io_uring.c                                            |   13 
 kernel/events/core.c                                           |    6 
 kernel/kcsan/core.c                                            |   50 +
 kernel/rcu/tasks.h                                             |   20 
 kernel/trace/Kconfig                                           |    2 
 kernel/trace/trace.c                                           |   38 -
 kernel/trace/trace.h                                           |   27 
 kernel/trace/trace_eprobe.c                                    |    3 
 kernel/trace/trace_events_hist.c                               |   11 
 kernel/trace/trace_events_synth.c                              |    2 
 kernel/trace/trace_probe.c                                     |    2 
 mm/compaction.c                                                |   18 
 net/caif/cfctrl.c                                              |    6 
 net/core/filter.c                                              |    7 
 net/ipv4/syncookies.c                                          |    7 
 net/mptcp/subflow.c                                            |   76 ++
 net/netfilter/ipset/ip_set_core.c                              |    7 
 net/netfilter/ipset/ip_set_hash_ip.c                           |   14 
 net/netfilter/ipset/ip_set_hash_ipmark.c                       |   13 
 net/netfilter/ipset/ip_set_hash_ipport.c                       |   13 
 net/netfilter/ipset/ip_set_hash_ipportip.c                     |   13 
 net/netfilter/ipset/ip_set_hash_ipportnet.c                    |   13 
 net/netfilter/ipset/ip_set_hash_net.c                          |   17 
 net/netfilter/ipset/ip_set_hash_netiface.c                     |   15 
 net/netfilter/ipset/ip_set_hash_netnet.c                       |   23 
 net/netfilter/ipset/ip_set_hash_netport.c                      |   19 
 net/netfilter/ipset/ip_set_hash_netportnet.c                   |   40 -
 net/netfilter/nf_tables_api.c                                  |  261 ++++++---
 net/nfc/netlink.c                                              |   52 +
 net/packet/af_packet.c                                         |   20 
 net/sched/cls_tcindex.c                                        |   12 
 net/sched/sch_atm.c                                            |    5 
 net/sched/sch_cbq.c                                            |    4 
 net/sunrpc/auth_gss/auth_gss.c                                 |   19 
 net/sunrpc/auth_gss/svcauth_gss.c                              |    9 
 security/device_cgroup.c                                       |   33 +
 security/integrity/ima/ima_template.c                          |    5 
 security/integrity/platform_certs/load_uefi.c                  |    1 
 sound/pci/hda/patch_realtek.c                                  |   50 +
 sound/soc/codecs/hdac_hda.c                                    |   22 
 sound/soc/codecs/max98373-sdw.c                                |    2 
 sound/soc/codecs/rt1308-sdw.c                                  |    2 
 sound/soc/codecs/rt1316-sdw.c                                  |    2 
 sound/soc/codecs/rt5682-sdw.c                                  |    2 
 sound/soc/codecs/rt700.c                                       |    2 
 sound/soc/codecs/rt711-sdca.c                                  |    2 
 sound/soc/codecs/rt711.c                                       |    2 
 sound/soc/codecs/rt715-sdca.c                                  |    2 
 sound/soc/codecs/rt715.c                                       |    2 
 sound/soc/codecs/sdw-mockup.c                                  |    2 
 sound/soc/codecs/wcd938x.c                                     |    2 
 sound/soc/codecs/wsa881x.c                                     |    2 
 sound/soc/intel/boards/bytcr_rt5640.c                          |   15 
 sound/soc/intel/boards/sof_sdw.c                               |    6 
 sound/soc/intel/skylake/skl-pcm.c                              |    7 
 sound/soc/jz4740/jz4740-i2s.c                                  |   39 +
 sound/soc/qcom/sdm845.c                                        |    4 
 sound/soc/qcom/sm8250.c                                        |    4 
 sound/soc/sof/intel/hda-dai.c                                  |    7 
 sound/usb/line6/driver.c                                       |    3 
 sound/usb/line6/midi.c                                         |    6 
 sound/usb/line6/midibuf.c                                      |   25 
 sound/usb/line6/midibuf.h                                      |    5 
 sound/usb/line6/pod.c                                          |    3 
 tools/objtool/check.c                                          |    2 
 tools/perf/util/cgroup.c                                       |   23 
 tools/perf/util/data.c                                         |    2 
 tools/perf/util/dwarf-aux.c                                    |   23 
 tools/testing/ktest/ktest.pl                                   |   23 
 tools/testing/selftests/Makefile                               |   26 
 tools/testing/selftests/bpf/config                             |    4 
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c                |   48 -
 tools/testing/selftests/bpf/progs/test_bpf_nf.c                |  109 ---
 tools/testing/selftests/lib.mk                                 |    5 
 305 files changed, 3238 insertions(+), 1866 deletions(-)

Adam Vodopjan (1):
      ata: ahci: Fix PCS quirk application for suspend

Adham Faris (1):
      net/mlx5e: Fix hw mtu initializing at XDP SQ allocation

Aditya Garg (2):
      hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount
      efi: Add iMac Pro 2017 to uefi skip cert quirk

Adrian Freund (1):
      ACPI: resource: do IRQ override on Lenovo 14ALC7

Aidan MacDonald (1):
      ASoC: jz4740-i2s: Handle independent FIFO flush bits

Alex Deucher (2):
      drm/amdgpu: handle polaris10/11 overlap asics (v2)
      drm/amdgpu: make display pinning more flexible (v2)

Alexander Antonov (2):
      perf/x86/intel/uncore: Disable I/O stacks to PMU mapping on ICX-D
      perf/x86/intel/uncore: Clear attr_update properly

Alexander Aring (2):
      fs: dlm: fix sock release if listen fails
      fs: dlm: retry accept() until -EAGAIN or error returns

Alexander Potapenko (1):
      fs: ext4: initialize fsdata in pagecache_write()

Alexander Sverdlin (1):
      mtd: spi-nor: Check for zero erase size in spi_nor_find_best_erase_type()

Ard Biesheuvel (1):
      efi: random: combine bootloader provided RNG seed with RNG protocol output

Arnd Bergmann (1):
      hfs/hfsplus: use WARN_ON for sanity check

Artem Egorkine (2):
      ALSA: line6: correct midi status byte when receiving data from podxt
      ALSA: line6: fix stack overflow in line6_midi_transmit

Ashok Raj (1):
      x86/microcode/intel: Do not retry microcode reloading on the APs

Baokun Li (8):
      ext4: add inode table check in __ext4_get_inode_loc to aovid possible infinite loop
      ext4: fix use-after-free in ext4_orphan_cleanup
      ext4: add EXT4_IGET_BAD flag to prevent unexpected bad inode
      ext4: add helper to check quota inums
      ext4: fix bug_on in __es_tree_search caused by bad quota inode
      ext4: fix bug_on in __es_tree_search caused by bad boot loader inode
      ext4: fix corruption when online resizing a 1K bigalloc fs
      ext4: correct inconsistent error msg in nojournal mode

Ben Dooks (1):
      riscv: uaccess: fix type of 0 variable on error in get_user()

Biju Das (1):
      ravb: Fix "failed to switch device to config mode" message during unbind

Bixuan Cui (1):
      jbd2: use the correct print format

Björn Töpel (1):
      riscv, kprobes: Stricter c.jr/c.jalr decoding

Boris Burkov (1):
      btrfs: fix resolving backrefs for inline extent followed by prealloc

Borislav Petkov (1):
      x86/mce: Get rid of msr_ops

Carlo Caione (1):
      drm/meson: Reduce the FIFO lines held when AFBC is not used

ChiYuan Huang (1):
      mfd: mt6360: Add bounds checking in Regmap read/write call-backs

Chris Chiu (1):
      ALSA: hda/realtek: Apply dual codec fixup for Dell Latitude laptops

Chris Mi (1):
      net/mlx5e: Always clear dest encap in neigh-update-del

Christian Brauner (1):
      pnode: terminate at peers of source

Christoph Hellwig (4):
      nvme: fix the NVME_CMD_EFFECTS_CSE_MASK definition
      nvmet: don't defer passthrough commands with trivial effects to the workqueue
      nvmet: use NVME_CMD_EFFECTS_CSUPP instead of open coding it
      nvme: also return I/O command effects from nvme_command_effects

Christophe Leroy (1):
      objtool: Fix SEGFAULT

Chuck Lever (1):
      SUNRPC: Don't leak netobj memory when gss_read_proxy_verf() fails

Corentin Labbe (1):
      crypto: n2 - add missing hash statesize

Damien Le Moal (2):
      block: mq-deadline: Do not break sequential write streams to zoned HDDs
      block: mq-deadline: Fix dd_finish_request() for zoned devices

Dan Carpenter (3):
      fs/ntfs3: Delete duplicate condition in ntfs_read_mft()
      ipmi: fix use after free in _ipmi_destroy_user()
      drm/i915: unpin on error in intel_vgpu_shadow_mm_pin()

Daniil Tatianin (2):
      qlcnic: prevent ->dcb use-after-free on qlcnic_dcb_enable() failure
      drivers/net/bonding/bond_3ad: return when there's no aggregator

David Arinzon (7):
      net: ena: Fix toeplitz initial hash value
      net: ena: Don't register memory info on XDP exchange
      net: ena: Account for the number of processed bytes in XDP
      net: ena: Use bitmask to indicate packet redirection
      net: ena: Fix rx_copybreak value update
      net: ena: Set default value for RX interrupt moderation
      net: ena: Update NUMA TPH hint register upon NUMA node update

Deren Wu (1):
      mmc: vub300: fix warning - do not call blocking ops when !TASK_RUNNING

Dragos Tatulea (1):
      net/mlx5e: IPoIB, Don't allow CQE compression to be turned on by default

Edward Lo (7):
      fs/ntfs3: Validate data run offset
      fs/ntfs3: Add null pointer check to attr_load_runs_vcn
      fs/ntfs3: Add null pointer check for inode operations
      fs/ntfs3: Validate attribute name offset
      fs/ntfs3: Validate buffer length while parsing index
      fs/ntfs3: Validate resident attribute name
      fs/ntfs3: Validate index root when initialize NTFS security

Eric Biggers (12):
      ext4: fix leaking uninitialized memory in fast-commit journal
      ext4: remove unused enum EXT4_FC_COMMIT_FAILED
      ext4: use ext4_debug() instead of jbd_debug()
      ext4: introduce EXT4_FC_TAG_BASE_LEN helper
      ext4: factor out ext4_fc_get_tl()
      ext4: fix potential out of bound read in ext4_fc_replay_scan()
      ext4: disable fast-commit of encrypted dir operations
      ext4: don't set up encryption key during jbd2 transaction
      ext4: add missing validation of fast-commit record lengths
      ext4: fix unaligned memory access in ext4_fc_reserve_space()
      ext4: fix off-by-one errors in fast-commit block filling
      ext4: don't allow journal inode to have encrypt flag

Eric Dumazet (1):
      net/af_packet: make sure to pull mac header

Eric Whitney (1):
      ext4: fix delayed allocation bug in ext4_clu_mapped for bigalloc + inline

Erik Schumacher (1):
      ACPI: resource: do IRQ override on XMG Core 15

Florian Westphal (1):
      mptcp: mark ops structures as ro_after_init

Florian-Ewald Mueller (1):
      md/bitmap: Fix bitmap chunk size overflow issues

Gaosheng Cui (1):
      ext4: fix undefined behavior in bit shift for ext4_check_flag_values

Geetha sowjanya (1):
      octeontx2-pf: Fix lmtst ID used in aura free

Greg Kroah-Hartman (1):
      Linux 5.15.87

Guo Ren (1):
      riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument

Hangbin Liu (1):
      net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO

Hanjun Guo (3):
      tpm: acpi: Call acpi_put_table() to fix memory leak
      tpm: tpm_crb: Add the missed acpi_put_table() to fix memory leak
      tpm: tpm_tis: Add the missed acpi_put_table() to fix memory leak

Hans de Goede (1):
      ASoC: Intel: bytcr_rt5640: Add quirk for the Advantech MICA-071 tablet

Hao Chen (1):
      net: hns3: refactor hns3_nic_reuse_page()

Harshit Mogalapalli (1):
      io_uring: Fix unsigned 'res' comparison with zero in io_fixup_rw_res()

Hawkins Jiawei (2):
      fs/ntfs3: Fix slab-out-of-bounds read in run_unpack
      net: sched: fix memory leak in tcindex_set_parms

Horatiu Vultur (1):
      net: sparx5: Fix reading of the MAC address

Huaxin Lu (1):
      ima: Fix a potential NULL pointer access in ima_restore_measurement_list

Ian Abbott (1):
      rtc: ds1347: fix value written to century register

Isaac J. Manjarres (1):
      driver core: Fix bus_type.match() error handling in __driver_attach()

Jaegeuk Kim (1):
      f2fs: allow to read node block after shutdown

Jakub Kicinski (1):
      bpf: pull before calling skb_postpull_rcsum()

Jamal Hadi Salim (2):
      net: sched: atm: dont intepret cls results when asked to drop
      net: sched: cbq: dont intepret cls results when asked to drop

Jan Kara (7):
      ext4: avoid BUG_ON when creating xattrs
      ext4: initialize quota before expanding inode in setproject ioctl
      ext4: avoid unaccounted block allocation when expanding inode
      mbcache: automatically delete entries from cache on freeing
      ext4: fix deadlock due to mbcache entry corruption
      udf: Fix extension of the last extent in the file
      mbcache: Avoid nesting of cache->c_list_lock under bit locks

Jason A. Donenfeld (2):
      media: stv0288: use explicitly signed char
      ARM: ux500: do not directly dereference __iomem

Jason Yan (1):
      ext4: goto right label 'failed_mount3a'

Jeff Layton (3):
      nfsd: shut down the NFSv4 state objects before the filecache
      filelock: new helper: vfs_inode_has_locks
      nfsd: fix handling of readdir in v4root vs. mount upcall timeout

Jens Axboe (3):
      ARM: renumber bits related to _TIF_WORK_MASK
      io_uring: check for valid register opcode earlier
      block: don't allow splitting of a REQ_NOWAIT bio

Jian Shen (2):
      net: hns3: fix miss L3E checking for rx packet
      net: hns3: fix VF promisc mode not update when mac table full

Jie Wang (2):
      net: hns3: add interrupts re-initialization while doing VF FLR
      net: hns3: fix return value check bug of rx copybreak

Jiguang Xiao (1):
      net: amd-xgbe: add missed tasklet_kill

Jiri Pirko (1):
      net/mlx5: Add forgotten cleanup calls into mlx5_init_once() error path

Jiri Slaby (SUSE) (1):
      ACPI: resource: do IRQ override on LENOVO IdeaPad

Jocelyn Falempe (1):
      drm/mgag200: Fix PLL setup for G200_SE_A rev >=4

Johan Hovold (1):
      phy: qcom-qmp-combo: fix sc8180x reset

Johnny S. Lee (1):
      net: dsa: mv88e6xxx: depend on PTP conditionally

José Expósito (1):
      HID: multitouch: fix Asus ExpertBook P2 P2451FA trackpoint

Jozsef Kadlecsik (2):
      netfilter: ipset: fix hash:net,port,net hang with /0 subnet
      netfilter: ipset: Rework long task execution when adding/deleting entries

Kant Fan (1):
      PM/devfreq: governor: Add a private governor_data for governor

Keita Suzuki (1):
      media: dvb-core: Fix double free in dvb_register_device()

Keith Busch (2):
      nvme-pci: fix mempool alloc size
      nvme-pci: fix page size checks

Kim Phillips (1):
      iommu/amd: Fix ivrs_acpihid cmdline parsing code

Klaus Jensen (1):
      nvme-pci: fix doorbell buffer value endianness

Krzysztof Kozlowski (2):
      arm64: dts: qcom: sdm845-db845c: correct SPI2 pins drive strength
      arm64: dts: qcom: sdm850-lenovo-yoga-c630: correct I2C12 pins drive strength

Linus Torvalds (1):
      hfs/hfsplus: avoid WARN_ON() for sanity check, use proper error handling

Luca Ceresoli (2):
      staging: media: tegra-video: fix chan->mipi value on error
      staging: media: tegra-video: fix device_node use after free

Luca Stefani (1):
      pstore: Properly assign mem_type property

Luo Meng (5):
      dm thin: resume even if in FAIL mode
      dm thin: Fix UAF in run_timer_softirq()
      dm integrity: Fix UAF in dm_integrity_dtr()
      dm clone: Fix UAF in clone_dtr()
      dm cache: Fix UAF in destroy()

Luís Henriques (2):
      ext4: remove trailing newline from ext4_msg() message
      ext4: fix error code return to user-space in ext4_get_branch()

Manivannan Sadhasivam (1):
      soc: qcom: Select REMAP_MMIO for LLCC driver

Maor Gottlieb (1):
      RDMA/mlx5: Fix validation of max_rd_atomic caps for DC

Marco Elver (1):
      kcsan: Instrument memcpy/memset/memmove with newer Clang

Maria Yu (1):
      remoteproc: core: Do pm_relax when in RPROC_OFFLINE state

Mario Limonciello (2):
      crypto: ccp - Add support for TEE for PCI ID 0x14CA
      Revert "ACPI: PM: Add support for upcoming AMD uPEP HID AMDI007"

Masami Hiramatsu (Google) (5):
      x86/kprobes: Fix kprobes instruction boudary check with CONFIG_RETHUNK
      x86/kprobes: Fix optprobe optimization check with CONFIG_RETHUNK
      tracing: Fix complicated dependency of CONFIG_TRACER_MAX_TRACE
      perf probe: Use dwarf_attr_integrate as generic DWARF attr accessor
      perf probe: Fix to get the DW_AT_decl_file and DW_AT_call_file as unsinged data

Matthew Auld (3):
      drm/i915/migrate: don't check the scratch page
      drm/i915/migrate: fix offset calculation
      drm/i915/migrate: fix length calculation

Matthieu Baerts (3):
      mptcp: remove MPTCP 'ifdef' in TCP SYN cookies
      mptcp: dedicated request sock for subflow in v6
      mptcp: use proper req destructor for IPv6

Maximilian Luz (1):
      ipu3-imgu: Fix NULL pointer dereference in imgu_subdev_set_selection()

Miaoqian Lin (5):
      usb: dwc3: qcom: Fix memory leak in dwc3_qcom_interconnect_init
      nfc: Fix potential resource leaks
      net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe
      gpio: sifive: Fix refcount leak in sifive_gpio_probe
      perf tools: Fix resources leak in perf_data__open_dir()

Michael S. Tsirkin (1):
      PCI: Fix pci_device_is_present() for VFs by checking PF

Michael Walle (1):
      wifi: wilc1000: sdio: fix module autoloading

Mickaël Salaün (1):
      selftests: Use optional USERCFLAGS and USERLDFLAGS

Mike Snitzer (2):
      dm cache: Fix ABBA deadlock between shrink_slab and dm_cache_metadata_abort
      dm cache: set needs_check flag after aborting metadata

Mikko Kovanen (1):
      drm/i915/dsi: fix VBT send packet port selection for dual link DSI

Mikulas Patocka (1):
      md: fix a crash in mempool_free

Moshe Shemesh (1):
      net/mlx5: E-Switch, properly handle ingress tagged packets on VST

Muhammad Usama Anjum (1):
      selftests: set the BUILD variable to absolute path

NARIBAYASHI Akira (1):
      mm, compaction: fix fast_isolate_around() to stay within boundaries

Namhyung Kim (2):
      perf/core: Call LSM hook after copying perf_event_attr
      perf stat: Fix handling of --for-each-cgroup with --bpf-counters to match non BPF mode

Namjae Jeon (1):
      ksmbd: fix infinite loop in ksmbd_conn_handler_loop()

Nathan Lynch (2):
      powerpc/rtas: avoid device tree lookups in rtas_os_term()
      powerpc/rtas: avoid scheduling in rtas_os_term()

Nick Desaulniers (1):
      ARM: 9256/1: NWFPE: avoid compiler-generated __aeabi_uldivmod

Nikolay Borisov (1):
      btrfs: move missing device handling in a dedicate function

Pablo Neira Ayuso (4):
      netfilter: nf_tables: consolidate set description
      netfilter: nf_tables: add function to create set stateful expressions
      netfilter: nf_tables: perform type checking for existing sets
      netfilter: nf_tables: honor set timeout and garbage collection updates

Paul E. McKenney (1):
      rcu-tasks: Simplify trc_read_check_handler() atomic operations

Paul Menzel (1):
      fbdev: matroxfb: G200eW: Increase max memory from 1 MB to 16 MB

Paulo Alcantara (2):
      cifs: fix oops during encryption
      cifs: fix confusing debug message

Pavel Begunkov (1):
      io_uring: fix CQ waiting timeout handling

Pavel Machek (1):
      f2fs: should put a page when checking the summary info

Peng Li (1):
      net: hns3: extract macro to simplify ring stats update code

Philipp Jungkamp (1):
      ALSA: patch_realtek: Fix Dell Inspiron Plus 16

Philipp Zabel (1):
      drm/imx: ipuv3-plane: Fix overlay plane width

Pierre-Louis Bossart (3):
      soundwire: dmi-quirks: add quirk variant for LAPBC710 NUC15
      ASoC: Intel/SOF: use set_stream() instead of set_tdm_slots() for HDAudio
      ASoC/SoundWire: dai: expand 'stream' concept beyond SoundWire

Qiujun Huang (1):
      pstore/zone: Use GFP_ATOMIC to allocate zone buffer

Qu Wenruo (2):
      btrfs: check superblock to ensure the fs was not modified at thaw time
      btrfs: make thaw time super block check to also verify checksum

Rob Herring (1):
      of/kexec: Fix reading 32-bit "linux,initrd-{start,end}" values

Rodrigo Branco (1):
      x86/bugs: Flush IBP in ib_prctl_set()

Roi Dayan (1):
      net/mlx5e: TC, Refactor mlx5e_tc_add_flow_mod_hdr() to get flow attr

Ronak Doshi (1):
      vmxnet3: correctly report csum_level for encapsulated packet

Sascha Hauer (1):
      PCI/sysfs: Fix double free in error path

Sasha Levin (4):
      Revert "selftests/bpf: Add test for unstable CT lookup API"
      phy: qcom-qmp-combo: fix out-of-bounds clock access
      btrfs: replace strncpy() with strscpy()
      btrfs: fix an error handling path in btrfs_defrag_leaves()

Sean Christopherson (3):
      KVM: VMX: Resume guest immediately when injecting #GP on ECREATE
      KVM: nVMX: Inject #GP, not #UD, if "generic" VMXON CR0/CR4 check fails
      KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1

Sergey Matyukevich (1):
      riscv: mm: notify remote harts about mmu cache updates

Shang XiaoJing (1):
      parisc: led: Fix potential null-ptr-deref in start_task()

Shawn Bohrer (1):
      veth: Fix race with AF_XDP exposing old or uninitialized descriptors

Shay Drory (2):
      net/mlx5: Avoid recovery in probe flows
      RDMA/mlx5: Fix mlx5_ib_get_hw_stats when used for device

Shigeru Yoshida (1):
      fs/ntfs3: Fix memory leak on ntfs_fill_super() error path

Simon Ser (1):
      drm/connector: send hotplug uevent on connector cleanup

Smitha T Murthy (3):
      media: s5p-mfc: Fix to handle reference queue during finishing
      media: s5p-mfc: Clear workbit to handle error condition
      media: s5p-mfc: Fix in register read and write for H264

Srinivas Pandruvada (1):
      thermal: int340x: Add missing attribute for data rate base

Stefano Garzarella (3):
      vringh: fix range used in iotlb_translate()
      vhost: fix range used in translate_desc()
      vdpa_sim: fix vringh initialization in vdpasim_queue_ready()

Steve French (1):
      cifs: fix missing display of three mount options

Steven Price (1):
      drm/panfrost: Fix GEM handle creation ref-counting

Steven Rostedt (2):
      kest.pl: Fix grub2 menu handling for rebooting
      ktest.pl minconfig: Unset configs instead of just removing them

Steven Rostedt (Google) (3):
      ftrace/x86: Add back ftrace_expected for ftrace bug reports
      tracing: Fix race where eprobes can be called before the event
      tracing/probes: Handle system names with hyphens

Szymon Heidrich (1):
      usb: rndis_host: Secure rndis_query check against int overflow

Takashi Iwai (2):
      media: dvb-core: Fix UAF due to refcount races at releasing
      x86/kexec: Fix double-free of elf header buffer

Tamim Khan (1):
      ACPI: resource: Skip IRQ override on Asus Vivobook K3402ZA/K3502ZA

Terry Junge (1):
      HID: plantronics: Additional PIDs for double volume key presses quirk

Tetsuo Handa (3):
      fs/ntfs3: Use __GFP_NOWARN allocation at wnd_init()
      fs/ntfs3: Use __GFP_NOWARN allocation at ntfs_fill_super()
      fs/ntfs3: don't hold ni_lock when calling truncate_setsize()

Wang Weiyang (1):
      device_cgroup: Roll back to original exceptions after copy failure

Wang Yufen (1):
      binfmt: Fix error return code in load_elf_fdpic_binary()

Wenchao Chen (1):
      mmc: sdhci-sprd: Disable CLK_AUTO when the clock is less than 400K

William Liu (1):
      ksmbd: check nt_len to be at least CIFS_ENCPWD_SIZE in ksmbd_decode_ntlmssp_auth_blob

Xiubo Li (1):
      ceph: switch to vfs_inode_has_locks() to fix file lock bug

Yang Jihong (1):
      tracing: Fix infinite loop in tracing_read_pipe on overflowed print_trace_line

Yanjun Zhang (1):
      nvme: fix multipath crash caused by flush request when blktrace is enabled

Yazen Ghannam (1):
      x86/MCE/AMD: Clear DFR errors found in THR handler

Ye Bin (6):
      ext4: fix reserved cluster accounting in __es_remove_extent()
      ext4: fix uninititialized value in 'ext4_evict_inode'
      ext4: init quota for 'old.inode' in 'ext4_rename'
      ext4: fix kernel BUG in 'ext4_write_inline_data_end()'
      ext4: fix inode leak in ext4_xattr_inode_create() on an error path
      ext4: allocate extended attribute value in vmalloc area

Yin Xiujiang (1):
      fs/ntfs3: Fix slab-out-of-bounds in r_page

Yongqiang Liu (1):
      cpufreq: Init completion before kobject_init_and_add()

Yu Kuai (1):
      block, bfq: fix uaf for bfqq in bfq_exit_icq_bfqq

Yuan Can (2):
      drm/ingenic: Fix missing platform_driver_unregister() call in ingenic_drm_init()
      vhost/vsock: Fix error handling in vhost_vsock_init()

Zack Rusin (1):
      drm/vmwgfx: Validate the box size for the snooped cursor

Zhang Tianci (1):
      ovl: Use ovl mounter's fsuid and fsgid in ovl_link()

Zhang Yi (2):
      ext4: silence the warning when evicting inode with dioread_nolock
      ext4: check and assert if marking an no_delete evicting inode dirty

Zhang Yuchen (1):
      ipmi: fix long wait in unload when IPMI disconnect

Zheng Yejian (3):
      tracing/hist: Fix out-of-bound write on 'action_data.var_ref_idx'
      tracing/hist: Fix wrong return value in parse_action_params()
      tracing: Fix issue of missing one synthetic field

Zhengchao Shao (1):
      caif: fix memory leak in cfctrl_linkup_request()

Zhenyu Wang (2):
      drm/i915/gvt: fix gvt debugfs destroy
      drm/i915/gvt: fix vgpu debugfs clean in remove

Zhihao Cheng (2):
      dm thin: Fix ABBA deadlock between shrink_slab and dm_pool_abort_metadata
      dm thin: Use last transaction's pmd->root when commit failed

edward lo (2):
      fs/ntfs3: Validate BOOT record_size
      fs/ntfs3: Add overflow check for attribute size

minoura makoto (1):
      SUNRPC: ensure the matching upcall is in-flight upon downcall

ruanjinjie (1):
      vdpa_sim: fix possible memory leak in vdpasim_net_init() and vdpasim_blk_init()

void0red (1):
      btrfs: fix extent map use-after-free when handling missing device in read_one_chunk

