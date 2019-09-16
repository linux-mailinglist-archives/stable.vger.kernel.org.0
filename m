Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 705BAB3875
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 12:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfIPKnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 06:43:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfIPKnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 06:43:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BB23214AF;
        Mon, 16 Sep 2019 10:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568630578;
        bh=n4r5IyKuLQRESockPpnPmr7IYQxtbGO7jJzem4fcKIw=;
        h=Date:From:To:Cc:Subject:From;
        b=rAPBZPvGzgU33aTmhn7aOLlmyeMnsH/b/oeP5Z9nWMzPuGb/Ywv6lkEyJ6/xW3j6G
         E+Y6izk6cvbRQg2Bj+r0JG1Nx8QNeTB442qFFH5w8c06LDJ9pm+P8ZZrRzj+NwPxRn
         L8RG9RvPvD2pfbu9LXSsQVeCwItxho7Ap5yEEGeU=
Date:   Mon, 16 Sep 2019 12:42:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.73
Message-ID: <20190916104255.GA1386960@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.73 kernel.

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

 Documentation/devicetree/bindings/display/panel/armadeus,st0700-adapt.txt =
|    9=20
 Documentation/devicetree/bindings/iio/adc/samsung,exynos-adc.txt          =
|    6=20
 Documentation/devicetree/bindings/mmc/mmc.txt                             =
|    4=20
 Makefile                                                                  =
|    2=20
 arch/arc/kernel/troubleshoot.c                                            =
|    8=20
 arch/arc/mm/fault.c                                                       =
|   38 --
 arch/arm/boot/dts/gemini-dlink-dir-685.dts                                =
|    2=20
 arch/arm/boot/dts/qcom-ipq4019.dtsi                                       =
|    6=20
 arch/arm/mach-davinci/devices-da8xx.c                                     =
|   40 ++
 arch/arm/mach-davinci/dm355.c                                             =
|   30 +
 arch/arm/mach-davinci/dm365.c                                             =
|   35 ++
 arch/arm/mach-davinci/dm644x.c                                            =
|   20 +
 arch/arm/mach-davinci/dm646x.c                                            =
|   10=20
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi                         =
|    3=20
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts                            =
|    2=20
 arch/powerpc/include/asm/kvm_book3s.h                                     =
|    4=20
 arch/powerpc/include/asm/kvm_book3s_64.h                                  =
|    4=20
 arch/powerpc/include/asm/kvm_booke.h                                      =
|    4=20
 arch/powerpc/include/asm/kvm_host.h                                       =
|    2=20
 arch/powerpc/include/asm/mmu_context.h                                    =
|   15=20
 arch/powerpc/include/asm/reg.h                                            =
|    7=20
 arch/powerpc/kernel/asm-offsets.c                                         =
|    4=20
 arch/powerpc/kernel/head_64.S                                             =
|    2=20
 arch/powerpc/kernel/process.c                                             =
|   38 --
 arch/powerpc/kvm/book3s_64_mmu_hv.c                                       =
|    3=20
 arch/powerpc/kvm/book3s_emulate.c                                         =
|   12=20
 arch/powerpc/kvm/book3s_hv.c                                              =
|   19 -
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                                   =
|   30 +
 arch/powerpc/kvm/book3s_hv_tm.c                                           =
|   12=20
 arch/powerpc/kvm/book3s_hv_tm_builtin.c                                   =
|    5=20
 arch/powerpc/kvm/book3s_pr.c                                              =
|    4=20
 arch/powerpc/kvm/bookehv_interrupts.S                                     =
|    8=20
 arch/powerpc/kvm/emulate_loadstore.c                                      =
|    1=20
 arch/powerpc/mm/hash_utils_64.c                                           =
|    9=20
 arch/powerpc/mm/pkeys.c                                                   =
|   10=20
 arch/riscv/kernel/ftrace.c                                                =
|    1=20
 arch/x86/include/asm/kvm_host.h                                           =
|   15=20
 arch/x86/kernel/ftrace.c                                                  =
|   42 +-
 arch/x86/kernel/kvmclock.c                                                =
|    6=20
 arch/x86/kernel/setup.c                                                   =
|    2=20
 arch/x86/kvm/emulate.c                                                    =
|   10=20
 arch/x86/kvm/hyperv.c                                                     =
|   71 +++-
 arch/x86/kvm/hyperv.h                                                     =
|    4=20
 arch/x86/kvm/irq.c                                                        =
|    7=20
 arch/x86/kvm/irq.h                                                        =
|    1=20
 arch/x86/kvm/lapic.c                                                      =
|   14=20
 arch/x86/kvm/lapic.h                                                      =
|    2=20
 arch/x86/kvm/mmu.c                                                        =
|   13=20
 arch/x86/kvm/mmu.h                                                        =
|    2=20
 arch/x86/kvm/mtrr.c                                                       =
|   10=20
 arch/x86/kvm/svm.c                                                        =
|    2=20
 arch/x86/kvm/vmx.c                                                        =
|   41 +-
 arch/x86/kvm/x86.c                                                        =
|   26 -
 arch/x86/kvm/x86.h                                                        =
|   12=20
 block/blk-core.c                                                          =
|    3=20
 block/blk-iolatency.c                                                     =
|   55 +--
 block/blk-mq-sysfs.c                                                      =
|    6=20
 block/blk-mq.c                                                            =
|    8=20
 block/blk-mq.h                                                            =
|    2=20
 drivers/char/tpm/st33zp24/i2c.c                                           =
|    2=20
 drivers/char/tpm/st33zp24/spi.c                                           =
|    2=20
 drivers/char/tpm/st33zp24/st33zp24.h                                      =
|    4=20
 drivers/char/tpm/tpm_i2c_infineon.c                                       =
|   15=20
 drivers/char/tpm/tpm_i2c_nuvoton.c                                        =
|   16 -
 drivers/clk/clk-s2mps11.c                                                 =
|    2=20
 drivers/clk/tegra/clk-audio-sync.c                                        =
|    3=20
 drivers/clk/tegra/clk-tegra-audio.c                                       =
|    7=20
 drivers/clk/tegra/clk-tegra114.c                                          =
|    9=20
 drivers/clk/tegra/clk-tegra124.c                                          =
|    9=20
 drivers/clk/tegra/clk-tegra210.c                                          =
|   11=20
 drivers/clk/tegra/clk-tegra30.c                                           =
|    9=20
 drivers/clk/tegra/clk.h                                                   =
|    4=20
 drivers/crypto/ccree/cc_driver.c                                          =
|    7=20
 drivers/crypto/ccree/cc_pm.c                                              =
|   13=20
 drivers/crypto/ccree/cc_pm.h                                              =
|    3=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c                                   =
|    5=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c                                   =
|    5=20
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                                     =
|    3=20
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c                                     =
|    5=20
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c                                     =
|    5=20
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                                   =
|    1=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c               =
|    3=20
 drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c                          =
|   32 +-
 drivers/gpu/drm/drm_atomic.c                                              =
|   21 +
 drivers/gpu/drm/drm_ioc32.c                                               =
|    6=20
 drivers/gpu/drm/drm_vblank.c                                              =
|   45 ++
 drivers/gpu/drm/i915/i915_debugfs.c                                       =
|    4=20
 drivers/gpu/drm/i915/i915_gem.c                                           =
|   39 ++
 drivers/gpu/drm/i915/i915_reg.h                                           =
|    2=20
 drivers/gpu/drm/i915/intel_cdclk.c                                        =
|   11=20
 drivers/gpu/drm/i915/intel_display.c                                      =
|   37 +-
 drivers/gpu/drm/i915/intel_dp.c                                           =
|   16 +
 drivers/gpu/drm/i915/intel_dp_mst.c                                       =
|    2=20
 drivers/gpu/drm/nouveau/dispnv50/disp.c                                   =
|    3=20
 drivers/gpu/drm/panel/panel-simple.c                                      =
|   29 +
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                                       =
|    8=20
 drivers/hv/hv_kvp.c                                                       =
|   32 +-
 drivers/i2c/busses/i2c-at91.c                                             =
|   11=20
 drivers/iio/adc/exynos_adc.c                                              =
|   31 ++
 drivers/iio/adc/rcar-gyroadc.c                                            =
|    4=20
 drivers/infiniband/core/uverbs_main.c                                     =
|    7=20
 drivers/infiniband/hw/hfi1/sdma.c                                         =
|    9=20
 drivers/infiniband/hw/mlx5/odp.c                                          =
|    3=20
 drivers/infiniband/ulp/srp/ib_srp.c                                       =
|   24 +
 drivers/iommu/iova.c                                                      =
|    5=20
 drivers/md/bcache/btree.c                                                 =
|   49 ++-
 drivers/md/bcache/btree.h                                                 =
|    2=20
 drivers/md/bcache/extents.c                                               =
|   15=20
 drivers/md/bcache/journal.c                                               =
|    7=20
 drivers/md/dm-crypt.c                                                     =
|    5=20
 drivers/md/dm-mpath.c                                                     =
|   17 +
 drivers/md/dm-rq.c                                                        =
|    8=20
 drivers/md/dm-target.c                                                    =
|    3=20
 drivers/md/dm-thin-metadata.c                                             =
|    7=20
 drivers/media/cec/Makefile                                                =
|    2=20
 drivers/media/cec/cec-adap.c                                              =
|   13=20
 drivers/media/cec/cec-edid.c                                              =
|   95 ------
 drivers/media/i2c/Kconfig                                                 =
|    3=20
 drivers/media/i2c/adv7604.c                                               =
|    4=20
 drivers/media/i2c/adv7842.c                                               =
|    4=20
 drivers/media/i2c/tc358743.c                                              =
|    2=20
 drivers/media/platform/stm32/stm32-dcmi.c                                 =
|    2=20
 drivers/media/platform/vim2m.c                                            =
|   28 -
 drivers/media/platform/vivid/vivid-vid-cap.c                              =
|    4=20
 drivers/media/platform/vivid/vivid-vid-common.c                           =
|    2=20
 drivers/media/v4l2-core/v4l2-dv-timings.c                                 =
|  151 ++++++++++
 drivers/mfd/Kconfig                                                       =
|    6=20
 drivers/mmc/host/renesas_sdhi_core.c                                      =
|   11=20
 drivers/mmc/host/sdhci-pci-core.c                                         =
|    2=20
 drivers/mmc/host/sdhci-pci.h                                              =
|    2=20
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c                            =
|   65 ++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h                           =
|    9=20
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                             =
|   56 +--
 drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c                    =
|    2=20
 drivers/nvme/host/fc.c                                                    =
|   15=20
 drivers/pci/controller/dwc/pcie-designware-host.c                         =
|   21 -
 drivers/pci/controller/dwc/pcie-qcom.c                                    =
|   58 ++-
 drivers/pci/quirks.c                                                      =
|  148 ++++++---
 drivers/remoteproc/qcom_q6v5.c                                            =
|   44 ++
 drivers/remoteproc/qcom_q6v5_pil.c                                        =
|    3=20
 drivers/s390/crypto/ap_bus.c                                              =
|    8=20
 drivers/s390/crypto/ap_bus.h                                              =
|    1=20
 drivers/s390/crypto/ap_queue.c                                            =
|   15=20
 drivers/s390/crypto/zcrypt_cex2a.c                                        =
|    1=20
 drivers/s390/crypto/zcrypt_cex4.c                                         =
|    1=20
 drivers/s390/crypto/zcrypt_pcixcc.c                                       =
|    1=20
 drivers/s390/scsi/zfcp_fsf.c                                              =
|   10=20
 drivers/s390/virtio/virtio_ccw.c                                          =
|    3=20
 drivers/scsi/megaraid/megaraid_sas_base.c                                 =
|   76 +++--
 drivers/scsi/qla2xxx/qla_gs.c                                             =
|   15=20
 drivers/scsi/qla2xxx/qla_init.c                                           =
|   48 +--
 drivers/spi/spi-gpio.c                                                    =
|    3=20
 drivers/staging/wilc1000/linux_wlan.c                                     =
|   12=20
 drivers/target/target_core_iblock.c                                       =
|    6=20
 drivers/target/target_core_iblock.h                                       =
|    1=20
 drivers/usb/typec/tcpm.c                                                  =
|   27 +
 drivers/vhost/test.c                                                      =
|   13=20
 drivers/vhost/vhost.c                                                     =
|    4=20
 fs/btrfs/compression.c                                                    =
|   16 +
 fs/btrfs/compression.h                                                    =
|    1=20
 fs/btrfs/ctree.h                                                          =
|    3=20
 fs/btrfs/extent-tree.c                                                    =
|   34 +-
 fs/btrfs/extent_io.c                                                      =
|   20 -
 fs/btrfs/extent_io.h                                                      =
|    5=20
 fs/btrfs/inode.c                                                          =
|   40 +-
 fs/btrfs/props.c                                                          =
|    6=20
 fs/btrfs/scrub.c                                                          =
|  119 +++++--
 fs/btrfs/volumes.c                                                        =
|   29 +
 fs/ceph/inode.c                                                           =
|    7=20
 fs/ceph/super.c                                                           =
|    2=20
 fs/ceph/super.h                                                           =
|    2=20
 fs/cifs/cifs_fs_sb.h                                                      =
|    5=20
 fs/cifs/cifsfs.c                                                          =
|    1=20
 fs/cifs/cifsglob.h                                                        =
|   24 +
 fs/cifs/cifssmb.c                                                         =
|   24 +
 fs/cifs/connect.c                                                         =
|    8=20
 fs/cifs/file.c                                                            =
|   37 +-
 fs/cifs/inode.c                                                           =
|   10=20
 fs/cifs/misc.c                                                            =
|    1=20
 fs/cifs/smb2pdu.c                                                         =
|    1=20
 fs/cifs/smbdirect.c                                                       =
|   55 +--
 fs/cifs/smbdirect.h                                                       =
|    5=20
 fs/cifs/transport.c                                                       =
|    2=20
 fs/ext4/block_validity.c                                                  =
|   54 +++
 fs/ext4/extents.c                                                         =
|   12=20
 fs/ext4/inode.c                                                           =
|    4=20
 fs/nfs/delegation.c                                                       =
|    2=20
 fs/nfs/delegation.h                                                       =
|    2=20
 fs/nfs/nfs4proc.c                                                         =
|   25 -
 fs/pstore/inode.c                                                         =
|   12=20
 include/drm/drm_device.h                                                  =
|    8=20
 include/drm/drm_vblank.h                                                  =
|   22 +
 include/linux/device-mapper.h                                             =
|    3=20
 include/linux/gpio/consumer.h                                             =
|   62 ++--
 include/media/cec.h                                                       =
|   80 -----
 include/media/v4l2-dv-timings.h                                           =
|    6=20
 include/net/cfg80211.h                                                    =
|   15=20
 include/uapi/linux/keyctl.h                                               =
|    7=20
 kernel/module.c                                                           =
|   29 +
 kernel/resource.c                                                         =
|  110 +++----
 kernel/sched/fair.c                                                       =
|    5=20
 kernel/time/timekeeping.c                                                 =
|    2=20
 mm/migrate.c                                                              =
|   17 -
 net/batman-adv/bat_iv_ogm.c                                               =
|   20 -
 net/batman-adv/netlink.c                                                  =
|    2=20
 net/mac80211/util.c                                                       =
|    7=20
 net/vmw_vsock/hyperv_transport.c                                          =
|    8=20
 net/wireless/core.c                                                       =
|    6=20
 net/wireless/nl80211.c                                                    =
|    4=20
 net/wireless/util.c                                                       =
|   27 +
 scripts/decode_stacktrace.sh                                              =
|    2=20
 security/apparmor/policy_unpack.c                                         =
|   40 ++
 sound/pci/hda/hda_auto_parser.c                                           =
|    4=20
 sound/pci/hda/hda_codec.c                                                 =
|    8=20
 sound/pci/hda/hda_codec.h                                                 =
|    2=20
 sound/pci/hda/hda_generic.c                                               =
|    3=20
 sound/pci/hda/hda_generic.h                                               =
|    1=20
 sound/pci/hda/hda_intel.c                                                 =
|    6=20
 sound/pci/hda/patch_hdmi.c                                                =
|    6=20
 sound/pci/hda/patch_realtek.c                                             =
|   17 +
 tools/testing/selftests/net/fib_rule_tests.sh                             =
|    5=20
 virt/kvm/eventfd.c                                                        =
|    9=20
 222 files changed, 2341 insertions(+), 1167 deletions(-)

Adrian Hunter (1):
      mmc: sdhci-pci: Add support for Intel CML

Ajay Singh (1):
      staging: wilc1000: fix error path cleanup in wilc_wlan_initialize()

Anand Jain (1):
      btrfs: scrub: fix circular locking dependency warning

Arnd Bergmann (1):
      iio: adc: gyroadc: fix uninitialized return code

Bart Van Assche (3):
      scsi: target/core: Use the SECTOR_SHIFT constant
      RDMA/srp: Document srp_parse_in() arguments
      RDMA/srp: Accept again source addresses that do not have a port number

Bartosz Golaszewski (6):
      ARM: davinci: da8xx: define gpio interrupts as separate resources
      ARM: davinci: dm365: define gpio interrupts as separate resources
      ARM: davinci: dm646x: define gpio interrupts as separate resources
      ARM: davinci: dm355: define gpio interrupts as separate resources
      ARM: davinci: dm644x: define gpio interrupts as separate resources
      gpio: don't WARN() on NULL descs if gpiolib is disabled

Ben Dooks (1):
      drm: add __user attribute to ptr_to_compat()

Ben Gardon (1):
      kvm: mmu: Fix overflow on kvm mmu page limit calculation

Benjamin Block (1):
      scsi: zfcp: fix request object use-after-free in send path causing wr=
ong traces

Bjorn Andersson (2):
      PCI: qcom: Fix error handling in runtime PM support
      PCI: qcom: Don't deassert reset GPIO during probe

Bjorn Helgaas (2):
      resource: Include resource end in walk_*() interfaces
      resource: Fix find_next_iomem_res() iteration issue

Breno Leitao (1):
      powerpc/tm: Remove msr_tm_active()

Brian Norris (2):
      remoteproc: qcom: q6v5: shore up resource probe handling
      remoteproc: qcom: q6v5-mss: add SCM probe dependency

Chris Wilson (4):
      drm/i915: Restore sane defaults for KMS on GEM error load
      drm/i915: Cleanup gt powerstate from gem
      drm/i915: Sanity check mmap length against object size
      iommu/iova: Remove stale cached32_node

Christian Lamparter (1):
      ARM: dts: qcom: ipq4019: enlarge PCIe BAR range

Christoph Muellner (1):
      dt-bindings: mmc: Add disable-cqe-dcmd property.

Christophe Leroy (1):
      powerpc/64: mark start_here_multiplatform as __ref

Colin Ian King (1):
      ext4: unsigned int compared against zero

Coly Li (4):
      bcache: replace hard coded number with BUCKET_GC_GEN_MAX
      bcache: only clear BTREE_NODE_dirty bit when it is set
      bcache: add comments for mutex_lock(&b->write_lock)
      bcache: fix race in btree_flush_write()

Dan Carpenter (1):
      drm/vmwgfx: Fix double free in vmw_recv_msg()

Dan Robertson (1):
      btrfs: init csum_list before possible free

David Abdurachmanov (1):
      riscv: remove unused variable in ftrace

David Francis (1):
      powerplay: Respect units on max dcfclk watermark

David Howells (1):
      keys: Fix the use of the C++ keyword "private" in uapi/linux/keyctl.h

David Sterba (2):
      btrfs: scrub: pass fs_info to scrub_setup_ctx
      btrfs: scrub: move scrub_setup_ctx allocation out of device_list_mutex

Dennis Zhou (1):
      blk-iolatency: fix STS_AGAIN handling

Dexuan Cui (4):
      hv_sock: Fix hang when a connection is closed
      Drivers: hv: kvp: Fix two "this statement may fall through" warnings
      Drivers: hv: kvp: Fix the indentation of some "break" statements
      Drivers: hv: kvp: Fix the recent regression caused by incorrect clean=
-up

Dhinakaran Pandiyan (1):
      drm/i915: Rename PLANE_CTL_DECOMPRESSION_ENABLE

Dinh Nguyen (1):
      arm64: dts: stratix10: add the sysmgr-syscon property from the gmac's

Dmitry Voytik (1):
      arm64: dts: rockchip: enable usb-host regulators at boot on rk3328-ro=
ck64

Eric Dumazet (1):
      batman-adv: fix uninit-value in batadv_netlink_get_ifindex()

Eric W. Biederman (1):
      signal/arc: Use force_sig_fault where appropriate

Eugeniy Paltsev (2):
      ARC: mm: fix uninitialised signal code in do_page_fault
      ARC: mm: SIGSEGV userspace trying to access kernel virtual memory

Fabien Dessenne (1):
      media: stm32-dcmi: fix irq =3D 0 case

Feifei Xu (2):
      drm/amdgpu/gfx9: Update gfx9 golden settings.
      drm/amdgpu: Update gc_9_0 golden settings.

Felix Fietkau (1):
      mt76: fix corrupted software generated tx CCMP PN

Filipe Manana (2):
      Btrfs: fix deadlock with memory reclaim during scrub
      Btrfs: fix race between block group removal and block group allocation

Gilad Ben-Yossef (2):
      crypto: ccree - fix resume race condition on init
      crypto: ccree - add missing inline qualifier

Giridhar Malavali (1):
      scsi: qla2xxx: Move log messages before issuing command to firmware

Greg Kroah-Hartman (1):
      Linux 4.19.73

Gustavo Romero (2):
      powerpc/tm: Fix FP/VMX unavailable exceptions inside a transaction
      powerpc/tm: Fix restoring FP/VMX facility incorrectly on interrupts

Halil Pasic (1):
      virtio/s390: fix race on airq_areas[]

Hangbin Liu (1):
      selftests: fib_rule_tests: use pre-defined DEV_ADDR

Hannes Reinecke (1):
      nvme-fc: use separate work queue to avoid warning

Hans Verkuil (5):
      media: cec/v4l2: move V4L2 specific CEC functions to V4L2
      media: cec: remove cec-edid.c
      media: vim2m: use workqueue
      media: vim2m: use cancel_delayed_work_sync instead of flush_schedule_=
work
      media: vim2m: only cancel work if it is for right context

Hans de Goede (1):
      usb: typec: tcpm: Try PD-2.0 if sink does not respond to 3.0 source-c=
aps

Harald Freudenberger (1):
      s390/zcrypt: reinit ap queue state machine during device probe

Hui Wang (1):
      ALSA: hda/realtek - Fix the problem of two front mics on a ThinkCentre

Ihab Zhaika (1):
      iwlwifi: add new card for 9260 series

Imre Deak (1):
      drm/i915/gen9+: Fix initial readout for Y tiled framebuffers

Jan-Marek Glogowski (1):
      drm/i915: Re-apply "Perform link quality check, unconditionally durin=
g long pulse"

Jarkko Nikula (1):
      mfd: Kconfig: Fix I2C_DESIGNWARE_PLATFORM dependencies

Jarkko Sakkinen (1):
      tpm: Fix some name collisions with drivers/char/tpm.h

Jason A. Donenfeld (1):
      timekeeping: Use proper ktime_add when adding nsecs in coarse offset

Jessica Yu (1):
      modules: always page-align module section allocations

Jian-Hong Pan (1):
      ALSA: hda/realtek - Enable internal speaker & headset mic of ASUS UX4=
31FL

Jisheng Zhang (1):
      PCI: dwc: Use devm_pci_alloc_host_bridge() to simplify code

Johannes Thumshirn (1):
      btrfs: correctly validate compression type

Jon Hunter (2):
      clk: tegra: Fix maximum audio sync clock for Tegra124/210
      clk: tegra210: Fix default rates for HDA clocks

Jonathan Bakker (2):
      iio: adc: exynos-adc: Add S5PV210 variant
      dt-bindings: iio: adc: exynos-adc: Add S5PV210 variant

Joonas Lahtinen (1):
      drm/i915: Handle vm_mmap error during I915_GEM_MMAP ioctl with WC set

Jos=C3=A9 Roberto de Souza (1):
      drm/i915/ilk: Fix warning when reading emon_status with no output

Kent Russell (1):
      drm/amdkfd: Add missing Polaris10 ID

Koen Vandeputte (1):
      media: i2c: tda1997x: select V4L2_FWNODE

Krzysztof Kozlowski (1):
      iio: adc: exynos-adc: Use proper number of channels for Exynos4x12

Ladi Prosek (1):
      KVM: hyperv: define VP assist page helpers

Liangyan (1):
      sched/fair: Don't assign runtime for throttled cfs_rq

Linus Walleij (1):
      ARM: dts: gemini: Set DIR-685 SPI CS as active low

Liu Bo (1):
      Blk-iolatency: warn on negative inflight IO counter

Logan Gunthorpe (1):
      PCI: Add macro for Switchtec quirk declarations

Long Li (1):
      cifs: smbd: take an array of reqeusts when sending upper layer data

Louis Li (1):
      drm/amdgpu: fix ring test failure issue during s3 in vce 3.0 (V2)

Luca Coelho (1):
      iwlwifi: fix devices with PCI Device ID 0x34F0 and 11ac RF modules

Lyude Paul (7):
      drm/i915: Fix intel_dp_mst_best_encoder()
      drm/atomic_helper: Disallow new modesets on unregistered connectors
      drm/amd/dm: Understand why attaching path/tile properties are needed
      drm/nouveau: Don't WARN_ON VCPI allocation failures
      PCI: Reset Lenovo ThinkPad P50 nvgpu at boot if necessary
      drm/atomic_helper: Allow DPMS On<->Off changes for unregistered conne=
ctors
      PCI: Reset both NVIDIA GPU and HDA in ThinkPad P50 workaround

Manikanta Pubbisetty (1):
      {nl,mac}80211: fix interface combinations on crypto controlled devices

Mathias Kresin (1):
      ARM: dts: qcom: ipq4019: fix PCI range

Michael Ellerman (1):
      powerpc/kvm: Save and restore host AMR/IAMR/UAMOR

Michael Neuling (1):
      KVM: PPC: Book3S HV: Fix CR0 setting in TM emulation

Micha=C5=82 Miros=C5=82aw (2):
      i2c: at91: disable TXRDY interrupt after sending data
      i2c: at91: fix clk_offset for sama5d2

Mike Marciniszyn (1):
      IB/hfi1: Avoid hardlockup with flushlist_lock

Mike Salvatore (1):
      apparmor: reset pos on failure to unpack for various functions

Mike Snitzer (1):
      dm thin metadata: check if in fail_io mode when setting needs_check

Milan Broz (1):
      dm crypt: move detailed message into debug level

Ming Lei (1):
      blk-mq: free hw queue's resource in hctx's release handler

Moni Shoua (1):
      IB/mlx5: Reset access mask when looping inside page fault handler

Nadav Amit (1):
      resource: fix locking in find_next_iomem_res()

Nathan Chancellor (1):
      clk: s2mps11: Add used attribute to s2mps11_dt_match

Nicolas Boichat (1):
      scripts/decode_stacktrace: match basepath using shell prefix operator=
, not regex

Niklas Cassel (1):
      ARM: dts: qcom: ipq4019: Fix MSI IRQ type

Nikolay Borisov (2):
      btrfs: Remove extent_io_ops::fill_delalloc
      btrfs: Fix error handling in btrfs_cleanup_ordered_extents

Norbert Manthey (1):
      pstore: Fix double-free in pstore_mkfile() failure path

Omar Sandoval (1):
      Btrfs: clean up scrub is_dev_replace parameter

Paolo Bonzini (1):
      KVM: x86: optimize check for valid PAT value

Paul Mackerras (2):
      KVM: PPC: Book3S HV: Fix race between kvm_unmap_hva_range and MMU mod=
e switch
      KVM: PPC: Use ccr field in pt_regs struct embedded in vcpu struct

Paulo Alcantara (SUSE) (1):
      cifs: Properly handle auto disabling of serverino option

Pavel Shilovsky (2):
      CIFS: Fix error paths in writeback code
      CIFS: Fix leaking locked VFS cache pages in writeback retry

Pavel Tatashin (1):
      x86/kvmclock: set offset for kvm unstable clock

Peter Xu (1):
      kvm: Check irqchip mode before assign irqfd

Qu Wenruo (2):
      btrfs: volumes: Make sure no dev extent is beyond device boundary
      btrfs: Use real device structure to verify dev extent

Ralph Campbell (1):
      mm/migrate.c: initialize pud_entry in migrate_vma()

Ram Pai (1):
      powerpc/pkeys: Fix handling of pkey state across fork()

Rex Zhu (1):
      drm/amd/pp: Fix truncated clock value when set watermark

Roman Bolshakov (1):
      scsi: target/iblock: Fix overrun in WRITE SAME emulation

Ronnie Sahlberg (1):
      cifs: add spinlock for the openFileList to cifsInodeInfo

Russell King (1):
      spi: spi-gpio: fix SPI_CS_HIGH capability

Sam Bazley (1):
      ALSA: hda/realtek - Add quirk for HP Pavilion 15

Sean Christopherson (4):
      KVM: VMX: Compare only a single byte for VMCS' "launched" in vCPU-run
      KVM: x86: Always use 32-bit SMRAM save state for 32-bit kernels
      KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with bad value
      KVM: VMX: Fix handling of #MC that occurs during VM-Entry

Shirish S (1):
      drm/amdgpu/{uvd,vcn}: fetch ring's read_ptr after alloc

Shivasharan S (3):
      scsi: megaraid_sas: Fix combined reply queue mode detection
      scsi: megaraid_sas: Add check for reset adapter bit
      scsi: megaraid_sas: Use 63-bit DMA addressing

Sowjanya Komatineni (1):
      dt-bindings: mmc: Add supports-cqe property

Steven Rostedt (VMware) (1):
      x86/ftrace: Fix warning and considate ftrace_jmp_replace() and ftrace=
_call_replace()

Suraj Jitindar Singh (1):
      powerpc/mm: Limit rma_size to 1TB when running without HV mode

Sven Eckelmann (1):
      batman-adv: Only read OGM tvlv_len after buffer len check

S=C3=A9bastien Szymanski (1):
      drm/panel: Add support for Armadeus ST0700 Adapt

Takashi Iwai (4):
      ALSA: hda - Fix potential endless loop at applying quirks
      ALSA: hda/realtek - Fix overridden device-specific initialization
      ALSA: hda - Don't resume forcibly i915 HDMI/DP codec
      ALSA: hda - Fix intermittent CORB/RIRB stall on Intel chips

Takeshi Saito (1):
      mmc: renesas_sdhi: Fix card initialization failure in high speed mode

Tang Junhui (1):
      bcache: treat stale && dirty keys as bad keys

Theodore Ts'o (3):
      ext4: protect journal inode's blocks using block_validity
      ext4: don't perform block validity checks on the journal inode
      ext4: fix block validity checks for journal inodes using indirect blo=
cks

Tiwei Bie (2):
      vhost/test: fix build for vhost test
      vhost/test: fix build for vhost test - again

Trond Myklebust (1):
      NFSv4: Fix delegation state recovery

Ville Syrj=C3=A4l=C3=A4 (2):
      drm/vblank: Allow dynamic per-crtc max_vblank_count
      drm/i915: Make sure cdclk is high enough for DP audio on VLV/CHV

Vineet Gupta (2):
      ARC: show_regs: lockdep: re-enable preemption
      ARC: mm: do_page_fault fixes #1: relinquish mmap_sem if signal arrive=
s while handle_mm_fault

Vitaly Kuznetsov (4):
      KVM: x86: hyperv: enforce vp_index < KVM_MAX_VCPUS
      KVM: x86: hyperv: consistently use 'hv_vcpu' for 'struct kvm_vcpu_hv'=
 variables
      KVM: x86: hyperv: keep track of mismatched VP indexes
      x86/kvm/lapic: preserve gfn_to_hva_cache len on cache reinit

WANG Chao (1):
      x86/kvm: move kvm_load/put_guest_xcr0 into atomic context

Wanpeng Li (1):
      KVM: VMX: check CPUID before allowing read/write of IA32_XSS

Yan, Zheng (1):
      ceph: use ceph_evict_inode to cleanup inode's resource

Yishai Hadas (1):
      IB/uverbs: Fix OOPs upon device disassociation

YueHaibing (1):
      kernel/module: Fix mem leak in module_add_modinfo_attrs

Yufen Yu (1):
      dm mpath: fix missing call of path selector type->end_io

ZhangXiaoxu (1):
      cifs: Fix lease buffer length error

Zhimin Gu (1):
      x86, hibernate: Fix nosave_regions setup for hibernation

yongduan (1):
      vhost: make sure log_num < in_num


--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1/Zy8ACgkQONu9yGCS
aT7dFQ//U7l+AXiNDss5uc0Lo8XI32VZgXRSRvNYj54JNy3PQHExDeJCYeJonMf9
wQEa9rGQPY37VWbyb1NQ3CLfJU/XMtd06hwLSH/13aM7D7wtBpocZXOo3yRl/uiA
0O7eW6PIBmI2Gi2NeDbnVDorToneYJhtBAWPDgpSFexwlrGQhSRH+BWUcBlnXT7h
9ypQrB8XZofzciF3Sl2HhT8wYRmHDTPv6LInooK/hdRtrXOrQI3A1tpn4UlNnV4M
SHIOfUbwcuVSivKdmYw/iF4cyttpms2lrHfX+sVf7wuX465/4zxDyLQokknzewhS
NTGC2fIZCIpoCyFwQlQlI7LPpSVVk0e+EhI4L9XuqORz0F4dIPg03J+Jih8MvlxU
uXFpNQCZSLVYD1t1Xv37A+fbIWMRvqlGAddGf5LC7w419JPQ7e8pj+OCZgRCwgND
ZXGkEzh6OFXjD4HBZEKle7Znjhv854nAbQGI+rRc3rR8gIwLKuMk/51dWsbO/lDf
TITFyhYbVzE9WNf/QqQqjn18iOVF4+w2/TkB8rmXEMvKoF+NPAnqHSX6DzxYtgR1
CB8tSgeSJ9MKxoHjJciz+mMoHk5rakr6AM814+Ou+UMP2KXcG6S8cWSVv5WNnalP
dw+BQ4ODHBUt1gbLT6dN4sBAoQuRVPXdAYTYgyOdS9dAklbArZ4=
=qRdT
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
