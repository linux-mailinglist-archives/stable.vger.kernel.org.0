Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58C2311B8
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 17:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfEaPzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 11:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbfEaPzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 11:55:05 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64F9626AAD;
        Fri, 31 May 2019 15:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559318101;
        bh=1sp7WO5BGBB3dMYIngKK1FRBz7SE2rkszRGnqrufxC0=;
        h=Date:From:To:Cc:Subject:From;
        b=qkNd3Y7AUMplA0EAM2Z4s2ZrFQL9FFHX2y0emy9LEbyK9Leit/J44kY8RT4fzjP5e
         LvILcSJ/+/VvAlT9ER9PtOsjgJVNAgU5G9yThOQ1jIkf/CXeeogQ5FC6bNYpWkyhRj
         5GQaA0c4nFH/veI9uKcDWtl5yWalpj5Z5oQg/9AQ=
Date:   Fri, 31 May 2019 08:55:01 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.123
Message-ID: <20190531155501.GA12515@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.123 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                    |    2=20
 arch/arm/include/asm/cp15.h                                 |    2=20
 arch/arm/vdso/vgettimeofday.c                               |    5 -
 arch/arm64/include/asm/pgtable.h                            |    3=20
 arch/arm64/include/asm/vdso_datapage.h                      |    1=20
 arch/arm64/kernel/asm-offsets.c                             |    2=20
 arch/arm64/kernel/cpu_ops.c                                 |    1=20
 arch/arm64/kernel/vdso.c                                    |    3=20
 arch/arm64/kernel/vdso/gettimeofday.S                       |    7 -
 arch/arm64/mm/dma-mapping.c                                 |   10 ++
 arch/powerpc/boot/addnote.c                                 |    6 +
 arch/powerpc/kernel/head_64.S                               |    4=20
 arch/powerpc/mm/numa.c                                      |   18 ++--
 arch/powerpc/perf/imc-pmu.c                                 |    5 +
 arch/x86/Makefile                                           |    2=20
 arch/x86/ia32/ia32_signal.c                                 |   29 +++---
 arch/x86/include/asm/text-patching.h                        |    4=20
 arch/x86/kernel/cpu/mcheck/mce.c                            |   44 +++++++=
+--
 arch/x86/kernel/cpu/microcode/core.c                        |    3=20
 arch/x86/kernel/irq_64.c                                    |   19 +++-
 arch/x86/kernel/signal.c                                    |   29 +++---
 arch/x86/kernel/vmlinux.lds.S                               |    6 -
 arch/x86/kvm/svm.c                                          |    6 +
 arch/x86/kvm/x86.c                                          |    2=20
 arch/x86/mm/fault.c                                         |    2=20
 block/sed-opal.c                                            |    9 +-
 drivers/acpi/property.c                                     |    8 +
 drivers/base/power/main.c                                   |    4=20
 drivers/char/hw_random/omap-rng.c                           |    1=20
 drivers/char/random.c                                       |   52 ++++++-=
-----
 drivers/char/virtio_console.c                               |    3=20
 drivers/clk/rockchip/clk-rk3288.c                           |   21 ++--
 drivers/cpufreq/cpufreq.c                                   |    1=20
 drivers/cpufreq/cpufreq_governor.c                          |    2=20
 drivers/cpufreq/kirkwood-cpufreq.c                          |   19 ++--
 drivers/cpufreq/pasemi-cpufreq.c                            |    1=20
 drivers/cpufreq/pmac32-cpufreq.c                            |    2=20
 drivers/cpufreq/ppc_cbe_cpufreq.c                           |    1=20
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c                     |    5 -
 drivers/crypto/vmx/aesp8-ppc.pl                             |    2=20
 drivers/dma/at_xdmac.c                                      |    6 +
 drivers/dma/pl330.c                                         |   10 +-
 drivers/dma/tegra210-adma.c                                 |   28 +++---
 drivers/extcon/extcon-arizona.c                             |   10 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c                   |   24 +++--
 drivers/gpu/drm/drm_drv.c                                   |    5 -
 drivers/gpu/drm/drm_file.c                                  |    1=20
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c                       |   10 +-
 drivers/hid/hid-core.c                                      |   36 +++++---
 drivers/hid/hid-logitech-hidpp.c                            |   23 ++++-
 drivers/hwmon/f71805f.c                                     |   15 ++-
 drivers/hwmon/pc87427.c                                     |   14 +++
 drivers/hwmon/smsc47b397.c                                  |   13 ++-
 drivers/hwmon/smsc47m1.c                                    |   28 ++++--
 drivers/hwmon/vt1211.c                                      |   15 ++-
 drivers/iio/adc/ad_sigma_delta.c                            |   16 ++-
 drivers/iio/common/ssp_sensors/ssp_iio.c                    |    2=20
 drivers/iio/magnetometer/hmc5843_i2c.c                      |    7 +
 drivers/iio/magnetometer/hmc5843_spi.c                      |    7 +
 drivers/infiniband/hw/cxgb4/cm.c                            |    2=20
 drivers/infiniband/hw/hfi1/init.c                           |    3=20
 drivers/infiniband/hw/hns/hns_roce_ah.c                     |    2=20
 drivers/md/bcache/alloc.c                                   |    5 -
 drivers/md/bcache/journal.c                                 |   26 +++++-
 drivers/md/bcache/super.c                                   |   17 ++-
 drivers/media/dvb-frontends/m88ds3103.c                     |    9 --
 drivers/media/i2c/ov2659.c                                  |    6 -
 drivers/media/i2c/ov6650.c                                  |   25 +++--
 drivers/media/pci/saa7146/hexium_gemini.c                   |    5 -
 drivers/media/pci/saa7146/hexium_orion.c                    |    5 -
 drivers/media/platform/coda/coda-bit.c                      |    3=20
 drivers/media/platform/stm32/stm32-dcmi.c                   |    6 +
 drivers/media/platform/video-mux.c                          |    5 +
 drivers/media/platform/vimc/vimc-core.c                     |    2=20
 drivers/media/platform/vimc/vimc-streamer.c                 |    2=20
 drivers/media/platform/vivid/vivid-vid-cap.c                |    2=20
 drivers/media/radio/wl128x/fmdrv_common.c                   |    7 +
 drivers/media/rc/serial_ir.c                                |    9 --
 drivers/media/usb/au0828/au0828-video.c                     |   16 ++-
 drivers/media/usb/cpia2/cpia2_v4l.c                         |    3=20
 drivers/media/usb/go7007/go7007-fw.c                        |    4=20
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                     |    2=20
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h                     |    1=20
 drivers/mmc/core/pwrseq_emmc.c                              |   38 ++++----
 drivers/mmc/core/sd.c                                       |    8 +
 drivers/mmc/host/mmc_spi.c                                  |    4=20
 drivers/mmc/host/sdhci-iproc.c                              |    6 -
 drivers/mmc/host/sdhci-of-esdhc.c                           |    8 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c                |    2=20
 drivers/net/ethernet/chelsio/cxgb3/l2t.h                    |    2=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c             |   15 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c                 |    8 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c          |    6 -
 drivers/net/wireless/atmel/at76c50x-usb.c                   |    4=20
 drivers/net/wireless/broadcom/b43/phy_lp.c                  |    6 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |    6 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     |   15 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h     |   16 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c |   42 +++++--=
--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c   |    2=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c      |   27 +++---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c   |    5 -
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c                |    7 +
 drivers/net/wireless/marvell/mwifiex/cfg80211.c             |    6 +
 drivers/net/wireless/marvell/mwifiex/cfp.c                  |    3=20
 drivers/net/wireless/realtek/rtlwifi/base.c                 |    5 +
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c         |    2=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c   |    2=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c         |    2=20
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c         |    2=20
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c         |    2=20
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c         |    4=20
 drivers/net/wireless/st/cw1200/main.c                       |    5 +
 drivers/nvdimm/label.c                                      |   29 +++---
 drivers/nvdimm/namespace_devs.c                             |   15 +++
 drivers/nvdimm/nd.h                                         |    4=20
 drivers/nvdimm/pmem.c                                       |    8 +
 drivers/phy/allwinner/phy-sun4i-usb.c                       |    4=20
 drivers/pinctrl/pinctrl-pistachio.c                         |    2=20
 drivers/pinctrl/samsung/pinctrl-exynos-arm.c                |    1=20
 drivers/pinctrl/zte/pinctrl-zx.c                            |    1=20
 drivers/rtc/rtc-88pm860x.c                                  |    2=20
 drivers/rtc/rtc-xgene.c                                     |   18 ++--
 drivers/s390/cio/cio.h                                      |    2=20
 drivers/s390/cio/vfio_ccw_drv.c                             |   32 ++++---
 drivers/s390/cio/vfio_ccw_ops.c                             |   11 ++
 drivers/s390/crypto/zcrypt_api.c                            |    4=20
 drivers/scsi/libsas/sas_expander.c                          |    5 +
 drivers/scsi/lpfc/lpfc_ct.c                                 |   20 +++-
 drivers/scsi/lpfc/lpfc_hbadisc.c                            |   11 ++
 drivers/scsi/qedf/qedf_io.c                                 |    1=20
 drivers/scsi/qedi/qedi_iscsi.c                              |    3=20
 drivers/scsi/qla2xxx/qla_isr.c                              |    6 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                          |    5 -
 drivers/scsi/qla4xxx/ql4_os.c                               |    2=20
 drivers/scsi/sd.c                                           |    3=20
 drivers/scsi/ufs/ufshcd.c                                   |   28 ++++--
 drivers/spi/spi-pxa2xx.c                                    |    8 +
 drivers/spi/spi-rspi.c                                      |    9 +-
 drivers/spi/spi-tegra114.c                                  |   32 ++++---
 drivers/spi/spi-topcliff-pch.c                              |   15 +++
 drivers/spi/spi.c                                           |    2=20
 drivers/ssb/bridge_pcmcia_80211.c                           |    9 +-
 drivers/thunderbolt/switch.c                                |   22 +++--
 drivers/tty/ipwireless/main.c                               |    8 +
 drivers/usb/core/hcd.c                                      |    3=20
 drivers/usb/core/hub.c                                      |    5 -
 drivers/video/fbdev/core/fbcmap.c                           |    2=20
 drivers/video/fbdev/core/modedb.c                           |    3=20
 drivers/w1/w1_io.c                                          |    3=20
 fs/btrfs/backref.c                                          |   17 ++-
 fs/btrfs/extent-tree.c                                      |   28 +-----
 fs/btrfs/file.c                                             |   15 +++
 fs/btrfs/relocation.c                                       |   31 ++++---
 fs/btrfs/root-tree.c                                        |   17 ++-
 fs/btrfs/sysfs.c                                            |    7 +
 fs/btrfs/tree-log.c                                         |    1=20
 fs/char_dev.c                                               |    6 +
 fs/ext4/inode.c                                             |    2=20
 fs/f2fs/data.c                                              |   17 ++-
 fs/f2fs/f2fs.h                                              |   11 ++
 fs/f2fs/file.c                                              |    2=20
 fs/f2fs/gc.c                                                |    2=20
 fs/f2fs/segment.c                                           |    6 -
 fs/gfs2/glock.c                                             |   23 +++--
 fs/gfs2/lock_dlm.c                                          |    9 +-
 fs/gfs2/log.c                                               |    3=20
 fs/gfs2/lops.c                                              |    6 -
 fs/hugetlbfs/inode.c                                        |    8 -
 fs/nfs/client.c                                             |    7 +
 include/linux/bio.h                                         |    2=20
 include/linux/cgroup-defs.h                                 |    5 +
 include/linux/hid.h                                         |    1=20
 include/linux/hugetlb.h                                     |    4=20
 include/linux/iio/adc/ad_sigma_delta.h                      |    1=20
 include/linux/smpboot.h                                     |    2=20
 kernel/auditfilter.c                                        |   12 +-
 kernel/bpf/devmap.c                                         |    3=20
 kernel/cgroup/cgroup.c                                      |    6 +
 kernel/rcu/rcuperf.c                                        |    5 +
 kernel/rcu/rcutorture.c                                     |    5 +
 kernel/sched/core.c                                         |    9 +-
 kernel/sched/rt.c                                           |    5 +
 kernel/trace/trace_branch.c                                 |    4=20
 lib/kobject_uevent.c                                        |   11 +-
 lib/sbitmap.c                                               |    2=20
 lib/strncpy_from_user.c                                     |    5 -
 lib/strnlen_user.c                                          |    4=20
 mm/hugetlb.c                                                |   23 +----
 mm/userfaultfd.c                                            |    3=20
 net/batman-adv/distributed-arp-table.c                      |    4=20
 net/batman-adv/main.c                                       |    1=20
 net/batman-adv/multicast.c                                  |   11 --
 net/batman-adv/types.h                                      |    2=20
 net/ipv4/ip_gre.c                                           |    2=20
 net/mac80211/mlme.c                                         |    3=20
 net/wireless/nl80211.c                                      |    5 +
 sound/soc/codecs/hdmi-codec.c                               |    6 +
 sound/soc/davinci/davinci-mcasp.c                           |    2=20
 sound/soc/fsl/Kconfig                                       |    9 +-
 sound/soc/fsl/eukrea-tlv320.c                               |    4=20
 sound/soc/fsl/fsl_sai.c                                     |    2=20
 sound/soc/fsl/fsl_utils.c                                   |    1=20
 tools/lib/bpf/bpf.c                                         |    2=20
 tools/lib/bpf/bpf.h                                         |    1=20
 205 files changed, 1215 insertions(+), 551 deletions(-)

Adam Ludkiewicz (1):
      i40e: Able to add up to 16 MAC filters on an untrusted VF

Aditya Pakki (2):
      thunderbolt: Fix to check for kmemdup failure
      spi : spi-topcliff-pch: Fix to handle empty DMA buffers

Akinobu Mita (1):
      media: ov2659: make S_FMT succeed even if requested format doesn't ma=
tch

Alan Stern (1):
      USB: core: Don't unbind interfaces following device reset failure

Alexander Potapenko (1):
      media: vivid: use vfree() instead of kfree() for dev->bitmap_cap

Alexandre Belloni (1):
      rtc: xgene: fix possible race condition

Andrea Merello (1):
      mmc: core: make pwrseq_emmc (partially) support sleepy GPIO controlle=
rs

Andrea Parri (2):
      bio: fix improper use of smp_mb__before_atomic()
      sbitmap: fix improper use of smp_mb__before_atomic()

Andreas Gruenbacher (2):
      gfs2: Fix sign extension bug in gfs2_update_stats
      gfs2: Fix occasional glock use-after-free

Anju T Sudhakar (1):
      powerpc/perf: Return accordingly on invalid chip-id in

Arend van Spriel (2):
      brcmfmac: assure SSID length from firmware is limited
      brcmfmac: add subtype check for event handling in data path

Arnd Bergmann (9):
      ASoC: imx: fix fiq dependencies
      bcache: avoid clang -Wunintialized warning
      s390: zcrypt: initialize variables before_use
      s390: cio: fix cio_irb declaration
      b43: shut up clang -Wuninitialized variable warning
      scsi: qla4xxx: avoid freeing unallocated dma memory
      media: go7007: avoid clang frame overflow warning with KASAN
      media: saa7146: avoid high stack usage with clang
      ASoC: davinci-mcasp: Fix clang warning without CONFIG_PM

Bart Van Assche (3):
      scsi: qla2xxx: Fix a qla24xx_enable_msix() error path
      scsi: qla2xxx: Fix abort handling in tcm_qla2xxx_write_pending()
      scsi: qla2xxx: Avoid that lockdep complains about unsafe locking in t=
cm_qla2xxx_close_session()

Benjamin Coddington (1):
      NFS: Fix a double unlock from nfs_match,get_client

Bo YU (1):
      powerpc/boot: Fix missing check of lseek() return value

Borislav Petkov (1):
      x86/microcode: Fix the ancient deprecated microcode loading method

Chad Dupuis (1):
      scsi: qedf: Add missing return in qedf_post_io_req() in the fcport of=
fload check

Charles Keepax (1):
      extcon: arizona: Disable mic detect if running when driver is removed

Chengguang Xu (1):
      chardev: add additional check for minor range overlap

Chris Lesiak (1):
      spi: Fix zero length xfer bug

Chris Wilson (1):
      drm: Wake up next in drm_read() chain if we are forced to putback the=
 event

Christian K=F6nig (1):
      drm/amdgpu: fix old fence check in amdgpu_fence_emit

Christoph Hellwig (1):
      arm64/iommu: handle non-remapped addresses in ->mmap and ->get_sgtable

Colin Ian King (1):
      RDMA/cxgb4: Fix null pointer dereference on alloc_skb failure

Coly Li (2):
      bcache: return error immediately in bch_journal_replay()
      bcache: add failure check to run_cache_set() for journal replay

Corentin Labbe (1):
      crypto: sun4i-ss - Fix invalid calculation of hash end

Damien Le Moal (1):
      f2fs: Fix use of number of devices

Dan Carpenter (4):
      brcm80211: potential NULL dereference in brcmf_cfg80211_vndr_cmds_dcm=
d_handler()
      mwifiex: prevent an array overflow
      media: pvrusb2: Prevent a buffer overflow
      media: wl128x: prevent two potential buffer overflows

Dan Williams (2):
      libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
      libnvdimm/namespace: Fix label tracking error

Daniel Axtens (1):
      crypto: vmx - CTR: always increment IV as quadword

Daniel Baluta (1):
      ASoC: fsl_sai: Update is_slave_mode with correct value

Daniel T. Lee (1):
      libbpf: fix samples/bpf build failure due to undefined UINT32_MAX

David Kozub (1):
      block: sed-opal: fix IOC_OPAL_ENABLE_DISABLE_MBR

David Sterba (1):
      Revert "btrfs: Honour FITRIM range constraints during free space trim"

Douglas Anderson (3):
      clk: rockchip: undo several noc and special clocks as critical on rk3=
288
      clk: rockchip: Fix video codec clocks on rk3288
      clk: rockchip: Make rkpwm a critical clock on rk3288

Eric Dumazet (1):
      bpf: devmap: fix use-after-free Read in __dev_map_entry_free

Farhan Ali (3):
      vfio-ccw: Do not call flush_workqueue while holding the spinlock
      vfio-ccw: Release any channel program when releasing/removing vfio-cc=
w mdev
      vfio-ccw: Prevent quiesce function going into an infinite loop

Filipe Manana (3):
      Btrfs: do not abort transaction at btrfs_update_root() after failure =
to COW path
      Btrfs: avoid fallback to transaction commit during fsync of files wit=
h holes
      Btrfs: fix race between ranged fsync and writeback of adjacent ranges

Flavio Suligoi (1):
      spi: pxa2xx: fix SCR (divisor) calculation

Geert Uytterhoeven (1):
      spi: rspi: Fix sequencer reset during initialization

Greg Kroah-Hartman (1):
      Linux 4.14.123

Guenter Roeck (5):
      hwmon: (vt1211) Use request_muxed_region for Super-IO accesses
      hwmon: (smsc47m1) Use request_muxed_region for Super-IO accesses
      hwmon: (smsc47b397) Use request_muxed_region for Super-IO accesses
      hwmon: (pc87427) Use request_muxed_region for Super-IO accesses
      hwmon: (f71805f) Use request_muxed_region for Super-IO accesses

Gustavo A. R. Silva (1):
      cxgb3/l2t: Fix undefined behaviour

Hans Verkuil (2):
      media: au0828: stop video streaming only when last user stops
      media: vimc: zero the media_device on probe

Hans de Goede (2):
      HID: logitech-hidpp: use RAP instead of FAP to get the protocol versi=
on
      HID: logitech-hidpp: change low battery level threshold from 31 to 30=
 percent

Helen Fornazier (1):
      media: vimc: stream: fix thread state before sleep

Hugues Fruchet (1):
      media: stm32-dcmi: fix crash when subdev do not expose any formats

James Hutchinson (1):
      media: m88ds3103: serialize reset messages in m88ds3103_set_frontend

James Smart (3):
      scsi: lpfc: Fix FDMI manufacturer attribute value
      scsi: lpfc: Fix fc4type information for FDMI
      scsi: lpfc: Fix SLI3 commands being issued on SLI4 devices

Jan Kara (1):
      ext4: do not delete unlinked inode from orphan list on failed truncate

Janusz Krzysztofik (1):
      media: ov6650: Move v4l2_clk_get() to ov6650_video_probe() helper

Jerome Brunet (1):
      ASoC: hdmi-codec: unlock the device on startup errors

Jiri Kosina (1):
      x86/mm: Remove in_nmi() warning from 64-bit implementation of vmalloc=
_fault()

Jiufei Xue (1):
      fbdev: fix WARNING in __alloc_pages_nodemask bug

Johannes Berg (1):
      iwlwifi: pcie: don't crash on invalid RX interrupt

John Garry (1):
      scsi: libsas: Do discovery on empty PHY to update PHY info

Josef Bacik (2):
      btrfs: honor path->skip_locking in backref code
      btrfs: fix panic during relocation after ENOSPC before writeback happ=
ens

Kangjie Lu (7):
      net: cw1200: fix a NULL pointer dereference
      mmc_spi: add a status check for spi_sync_locked
      iio: hmc5843: fix potential NULL pointer dereferences
      rtlwifi: fix a potential NULL pointer dereference
      brcmfmac: fix missing checks for kmemdup
      media: video-mux: fix null pointer dereferences
      tty: ipwireless: fix missing checks for ioremap

Kees Cook (2):
      x86/build: Move _etext to actual end of .text
      x86/build: Keep local relocations with ld.lld

Konstantin Khlebnikov (3):
      sched/core: Check quota and period overflow at usec to nsec conversion
      sched/rt: Check integer overflow at usec to nsec conversion
      sched/core: Handle overflow in cpu_shares_write_u64

Lars-Peter Clausen (1):
      iio: ad_sigma_delta: Properly handle SPI bus locking vs CS assertion

Leon Romanovsky (1):
      RDMA/hns: Fix bad endianess of port_pd variable

Linus L=FCssing (2):
      batman-adv: mcast: fix multicast tt/tvlv worker locking
      batman-adv: allow updating DAT entry timeouts on incoming ARP Replies

Manish Rangankar (1):
      scsi: qedi: Abort ep termination if offload not scheduled

Marc Zyngier (1):
      ARM: vdso: Remove dependency with the arch_timer driver internals

Mariusz Bialonczyk (1):
      w1: fix the resume command API

Martin K. Petersen (1):
      Revert "scsi: sd: Keep disk read-only when re-reading partition"

Mike Kravetz (1):
      hugetlb: use same fault hash key for shared and private mappings

Mike Marciniszyn (1):
      IB/hfi1: Fix WQ_MEM_RECLAIM warning

Nathan Chancellor (1):
      iio: common: ssp_sensors: Initialize calculated_time in ssp_common_pr=
ocess_data

Nathan Lynch (1):
      powerpc/numa: improve control of topology updates

Nicholas Nunley (1):
      i40e: don't allow changes to HW VLAN stripping on active port VLANs

Nicolas Ferre (1):
      dmaengine: at_xdmac: remove BUG_ON macro in tasklet

Nicolas Saenz Julienne (1):
      HID: core: move Usage Page concatenation to Main item

Noralf Tr=F8nnes (1):
      drm/drv: Hold ref on parent device during drm_device lifetime

Pankaj Gupta (1):
      virtio_console: initialize vtermno value for ports

Paolo Bonzini (1):
      KVM: x86: fix return value for reserved EFER

Paul E. McKenney (2):
      rcutorture: Fix cleanup path for invalid torture_type strings
      rcuperf: Fix cleanup path for invalid perf_type strings

Paul Kocialkowski (1):
      phy: sun4i-usb: Make sure to disable PHY0 passby for peripheral mode

Peter Zijlstra (4):
      mm/uaccess: Use 'unsigned long' to placate UBSAN warnings on older GC=
C versions
      x86/uaccess, ftrace: Fix ftrace_likely_update() vs. SMAP
      x86/uaccess, signal: Fix AC=3D1 bloat
      x86/ia32: Fix ia32_restore_sigcontext() AC leak

Philipp Zabel (1):
      media: coda: clear error return value before picture run

Pierre-Louis Bossart (1):
      ACPI / property: fix handling of data_nodes in acpi_get_next_subnode()

Ping-Ke Shih (1):
      rtlwifi: fix potential NULL pointer dereference

Piotr Figiel (4):
      brcmfmac: convert dev_init_lock mutex to completion
      brcmfmac: fix WARNING during USB disconnect in case of unempty psq
      brcmfmac: fix race during disconnect when USB completion is in progre=
ss
      brcmfmac: fix Oops when bringing up interface during USB disconnect

Qian Cai (1):
      arm64: Fix compiler warning from pte_unmap() with -Wunused-but-set-va=
riable

Qu Wenruo (1):
      btrfs: Don't panic when we can't find a root key

Raul E Rangel (1):
      mmc: core: Verify SD bus width

Robbie Ko (1):
      Btrfs: fix data bytes_may_use underflow with fallocate due to failed =
quota reserve

Roberto Bergantinos Corpas (1):
      NFS: make nfs_match_client killable

Roman Gushchin (1):
      cgroup: protect cgroup->nr_(dying_)descendants by css_set_lock

Ross Lagerwall (1):
      gfs2: Fix lru_count going negative

Rouven Czerwinski (1):
      hwrng: omap - Set default quality

Russell Currey (1):
      powerpc/64: Fix booting large kernels with STRICT_KERNEL_RWX

Sameeh Jubran (1):
      net: ena: gcc 8: fix compilation warning

Sameer Pujar (2):
      dmaengine: tegra210-dma: free dma controller in remove()
      dmaengine: tegra210-adma: use devm_clk_*() helpers

Sebastian Andrzej Siewior (2):
      smpboot: Place the __percpu annotation correctly
      random: add a spinlock_t to struct batched_entropy

Sergey Matyukevich (1):
      mac80211/cfg80211: update bss channel on channel switch

Shile Zhang (1):
      fbdev: fix divide error in fb_var_to_videomode

Shuah Khan (1):
      media: au0828: Fix NULL pointer dereference in au0828_analog_stream_e=
nable()

Sowjanya Komatineni (1):
      spi: tegra114: reset controller on probe

Stanley Chu (2):
      scsi: ufs: Fix regulator load and icc-level configuration
      scsi: ufs: Avoid configuring regulator with undefined voltage range

Steven Rostedt (VMware) (1):
      x86: Hide the int3_emulate_call/jmp functions from UML

Sugar Zhang (1):
      dmaengine: pl330: _stop: clear interrupt status

Suthikulpanit, Suravee (1):
      kvm: svm/avic: fix off-by-one in checking host APIC ID

Sven Van Asbroeck (1):
      rtc: 88pm860x: prevent use-after-free on device remove

Tang Junhui (1):
      bcache: fix failure in journal relplay

Tetsuo Handa (1):
      kobject: Don't trigger kobject_uevent(KOBJ_REMOVE) twice.

Thomas Gleixner (1):
      x86/irq/64: Limit IST stack overflow check to #DB stack

Tobin C. Harding (2):
      btrfs: sysfs: Fix error path kobject memory leak
      btrfs: sysfs: don't leak memory when failing add fsid

Tony Lindgren (1):
      usb: core: Add PM runtime calls to usb_hcd_platform_shutdown

Tony Luck (1):
      x86/mce: Fix machine_check_poll() tests for error types

Trac Hoang (2):
      mmc: sdhci-iproc: cygnus: Set NO_HISPD bit to fix HS50 data hold time=
 problem
      mmc: sdhci-iproc: Set NO_HISPD bit to fix HS50 data hold time problem

Ulf Hansson (1):
      PM / core: Propagate dev->power.wakeup_path when no callbacks

Vincenzo Frascino (1):
      arm64: vdso: Fix clock_getres() for CLOCK_REALTIME

Vineet Gupta (1):
      tools/bpf: fix perf build error with uClibc (seen on ARC)

Viresh Kumar (1):
      sched/cpufreq: Fix kobject memleak

Wen Yang (11):
      pinctrl: zte: fix leaked of_node references
      pinctrl: pistachio: fix leaked of_node references
      pinctrl: samsung: fix leaked of_node references
      drm/msm: a5xx: fix possible object reference leak
      cpufreq: ppc_cbe: fix possible object reference leak
      cpufreq/pasemi: fix possible object reference leak
      cpufreq: pmac32: fix possible object reference leak
      cpufreq: kirkwood: fix possible object reference leak
      arm64: cpu_ops: fix a leaked reference by adding missing of_node_put
      ASoC: eukrea-tlv320: fix a leaked reference by adding missing of_node=
_put
      ASoC: fsl_utils: fix a leaked reference by adding missing of_node_put

Wenwen Wang (1):
      audit: fix a memory leak bug

William Tu (1):
      net: erspan: fix use-after-free

Yinbo Zhu (3):
      mmc: sdhci-of-esdhc: add erratum eSDHC5 support
      mmc: sdhci-of-esdhc: add erratum A-009204 support
      mmc: sdhci-of-esdhc: add erratum eSDHC-A001 and A-008358 support

YueHaibing (6):
      media: cpia2: Fix use-after-free in cpia2_exit
      media: serial_ir: Fix use-after-free in serial_ir_init_module
      ssb: Fix possible NULL pointer dereference in ssb_host_pcmcia_exit
      at76c50x-usb: Don't register led_trigger if usb_register_driver failed
      cxgb4: Fix error path in cxgb4_init_module
      mwifiex: Fix mem leak in mwifiex_tm_cmd


--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzxTlUACgkQONu9yGCS
aT46LBAAqMjCgmSgHyP2ScWRswuFkrizR3LX26ZhjDiRBD6IwLj7f5wW2ojC1Qvp
uQVk1+LS6IGOcXLNwBL6pcj8Y+mnRr/cdc6joJPEwA/7iJDL7Bxr+1BimeMmuUEq
PYAdqvSweRBXP5SZMcUVFvyc0p1aIK5v9LhklVWe9tSJVFmla2akhlzjgUle81Fn
BIuKB1a855GC32nEwd25ElBaKeSA+ZxpfygGns8tWe7hWWay3ctUDeeoA2cu5thV
DdcWH/Tlrt7tciR9IhnxBreifqzUHI6vXwA1WKrvmrsCfNyuwLB4cvOQiCZXPj5T
+7+K6FLrYwCPGbIty38H0grY191H2y2XuwcceTYkFAhTtA+AT6EcQvfQ6abtNtaj
rovBlcS8JitJstb766spP375gNUuVkJtKYgImIT2xbKmiEhWWlv+iN7kMfg4Zg7c
muwyIZ1g3ClXs+D11BzSzIj34Snoe57Ndu3tKE9W1foWgZ2LV2yXWReyrcvZrGFe
VQeYY7kE6fG0vlADJT/a5X2ZEOnPS3ot0zt8mYMxpz4YYERBDwXxb4CPbd288na3
BSr6RTKTjmOrf3K4hb3AdLgPhsdIfA/1jn36eQN3m5mttFcUPv++BM6mvuuFzEnf
RLqCWiPdhZHUj3/ZvQkBRTA2RqLg5zYD2JdcUCWPXCCftAf+Oas=
=CM1G
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
