Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C826317507
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 11:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfEHJWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 05:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727185AbfEHJWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 05:22:50 -0400
Received: from localhost (unknown [84.241.196.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DB1D20656;
        Wed,  8 May 2019 09:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557307369;
        bh=zDOE0WD1zvKzE6oo9cfuyytFkkBwfmGKLcaBczcPdJs=;
        h=Date:From:To:Cc:Subject:From;
        b=lfKhMeD6Qyy7a1llSditypuI6cGy3vH/SPtCXBgHYlDpbjqsBJ9HYwqK7pmtYl116
         ZS1wOvKUzsIfMmb14aR8ofOgHKMCIFkZyI29+joJ+5UH9DNn8r7HJyhf5dGdCy9ZGO
         7ODCVpXVzXIwJ2x52E42ZvFu69s6hPmI0rdoSs/g=
Date:   Wed, 8 May 2019 11:22:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.41
Message-ID: <20190508092245.GA2233@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.41 kernel.

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

 Documentation/driver-api/usb/power-management.rst    |   14=20
 Makefile                                             |    2=20
 arch/arm/boot/dts/rk3288.dtsi                        |   12=20
 arch/arm/mach-at91/pm.c                              |    6=20
 arch/arm/mach-iop13xx/setup.c                        |    8=20
 arch/arm/mach-iop13xx/tpmi.c                         |   10=20
 arch/arm/plat-iop/adma.c                             |    6=20
 arch/arm/plat-orion/common.c                         |    4=20
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts       |    4=20
 arch/arm64/kernel/sdei.c                             |    6=20
 arch/powerpc/kernel/kvm.c                            |    7=20
 arch/powerpc/mm/slice.c                              |   10=20
 arch/riscv/include/asm/uaccess.h                     |    2=20
 arch/sh/boards/of-generic.c                          |    4=20
 arch/x86/events/amd/core.c                           |  111 +++++
 arch/x86/kernel/cpu/mcheck/mce-severity.c            |    5=20
 arch/x86/kvm/svm.c                                   |   12=20
 arch/x86/mm/init.c                                   |    6=20
 arch/x86/mm/kaslr.c                                  |    2=20
 arch/x86/mm/tlb.c                                    |    2=20
 block/blk-core.c                                     |    6=20
 block/blk-mq.c                                       |    2=20
 drivers/block/xsysace.c                              |    2=20
 drivers/bluetooth/btmtkuart.c                        |    2=20
 drivers/bluetooth/btusb.c                            |    2=20
 drivers/clk/qcom/gcc-msm8998.c                       |    1=20
 drivers/clk/x86/clk-pmc-atom.c                       |   14=20
 drivers/firmware/efi/runtime-wrappers.c              |    2=20
 drivers/gpio/gpio-mxc.c                              |    5=20
 drivers/hid/hid-debug.c                              |    5=20
 drivers/hid/hid-input.c                              |    1=20
 drivers/hid/hid-logitech-hidpp.c                     |    8=20
 drivers/hid/hid-quirks.c                             |    5=20
 drivers/i2c/busses/i2c-imx.c                         |    4=20
 drivers/i2c/busses/i2c-stm32f7.c                     |    2=20
 drivers/i2c/busses/i2c-synquacer.c                   |    2=20
 drivers/i2c/i2c-core-base.c                          |   18=20
 drivers/infiniband/core/security.c                   |   11=20
 drivers/infiniband/core/verbs.c                      |   41 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c                |   11=20
 drivers/input/keyboard/snvs_pwrkey.c                 |    6=20
 drivers/input/touchscreen/stmfts.c                   |   30 -
 drivers/media/i2c/ov7670.c                           |   16=20
 drivers/mfd/twl-core.c                               |   23 +
 drivers/net/bonding/bond_sysfs_slave.c               |    4=20
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c   |    9=20
 drivers/net/ethernet/hisilicon/hns/hnae.c            |    4=20
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c   |   33 +
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c  |    2=20
 drivers/net/ethernet/hisilicon/hns/hns_enet.c        |   12=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile  |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile  |    2=20
 drivers/net/ethernet/intel/igb/e1000_defines.h       |    2=20
 drivers/net/ethernet/intel/igb/igb_main.c            |   57 --
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c    |    6=20
 drivers/net/ethernet/stmicro/stmmac/descs_com.h      |   22 -
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c   |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c |    2=20
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c       |   22 -
 drivers/net/ethernet/stmicro/stmmac/hwif.h           |    2=20
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c      |   12=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |   34 -
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c        |    3=20
 drivers/net/wireless/marvell/mwifiex/sdio.c          |    2=20
 drivers/nvme/target/core.c                           |   20 -
 drivers/platform/x86/intel_pmc_core.c                |    4=20
 drivers/platform/x86/pmc_atom.c                      |   21 +
 drivers/reset/reset-meson-audio-arb.c                |    1=20
 drivers/rtc/rtc-cros-ec.c                            |    4=20
 drivers/rtc/rtc-da9063.c                             |    7=20
 drivers/rtc/rtc-sh.c                                 |    2=20
 drivers/scsi/scsi_devinfo.c                          |    1=20
 drivers/scsi/scsi_dh.c                               |    1=20
 drivers/scsi/storvsc_drv.c                           |   13=20
 drivers/staging/iio/addac/adt7316.c                  |   22 -
 drivers/usb/core/driver.c                            |   13=20
 drivers/usb/core/message.c                           |    4=20
 drivers/usb/gadget/udc/dummy_hcd.c                   |   19=20
 drivers/usb/misc/yurex.c                             |    1=20
 drivers/usb/storage/realtek_cr.c                     |   13=20
 drivers/usb/usbip/stub_rx.c                          |   12=20
 drivers/usb/usbip/usbip_common.h                     |    7=20
 drivers/vfio/pci/vfio_pci.c                          |    4=20
 drivers/w1/masters/ds2490.c                          |    6=20
 drivers/xen/xenbus/xenbus_dev_frontend.c             |    4=20
 fs/debugfs/inode.c                                   |   13=20
 fs/hugetlbfs/inode.c                                 |   20 -
 fs/jffs2/readinode.c                                 |    5=20
 fs/jffs2/super.c                                     |    5=20
 fs/open.c                                            |   18=20
 fs/read_write.c                                      |    5=20
 include/linux/fs.h                                   |    4=20
 include/linux/i2c.h                                  |    1=20
 include/linux/platform_data/x86/clk-pmc-atom.h       |    3=20
 include/linux/usb.h                                  |    2=20
 mm/kmemleak.c                                        |   18=20
 net/batman-adv/bat_v_elp.c                           |    6=20
 net/batman-adv/bridge_loop_avoidance.c               |   16=20
 net/batman-adv/translation-table.c                   |   32 +
 net/mac80211/debugfs_netdev.c                        |    2=20
 net/mac80211/key.c                                   |    9=20
 scripts/coccinelle/api/stream_open.cocci             |  363 ++++++++++++++=
+++++
 security/selinux/avc.c                               |   23 +
 security/selinux/hooks.c                             |   44 +-
 security/selinux/include/avc.h                       |    1=20
 sound/pci/hda/patch_realtek.c                        |   13=20
 sound/soc/codecs/wm_adsp.c                           |    4=20
 sound/soc/intel/boards/bytcr_rt5651.c                |    2=20
 sound/soc/stm/stm32_sai_sub.c                        |    2=20
 109 files changed, 1127 insertions(+), 349 deletions(-)

Aaro Koskinen (6):
      net: stmmac: use correct DMA buffer size in the RX descriptor
      net: stmmac: ratelimit RX error logs
      net: stmmac: don't stop NAPI processing when dropping a packet
      net: stmmac: don't overwrite discard_frame status
      net: stmmac: fix dropping of multi-descriptor RX frames
      net: stmmac: don't log oversized frames

Al Viro (2):
      jffs2: fix use-after-free on symlink traversal
      debugfs: fix use-after-free on symlink traversal

Alan Kao (1):
      riscv: fix accessing 8-byte variable from RV32

Alan Stern (5):
      USB: yurex: Fix protection fault after device removal
      USB: w1 ds2490: Fix bug caused by improper use of altsetting array
      USB: dummy-hcd: Fix failure to give back unlinked URBs
      USB: core: Fix unterminated string returned by usb_string()
      USB: core: Fix bug caused by duplicate interface PM usage counter

Alexander Wetzel (1):
      mac80211: Honor SW_CRYPTO_CONTROL for unicast keys in AP VLAN mode

Alexandre Belloni (1):
      rtc: da9063: set uie_unsupported when relevant

Anders Roxell (1):
      batman-adv: fix warning in function batadv_v_elp_get_throughput

Andreas Kemnade (1):
      mfd: twl-core: Disable IRQ while suspended

Aneesh Kumar K.V (1):
      powerpc/mm/hash: Handle mmap_min_addr correctly in get_unmapped_area =
topdown search

Anson Huang (3):
      i2c: imx: correct the method of getting private data in notifier_call
      Input: snvs_pwrkey - initialize necessary driver data before enabling=
 IRQ
      gpio: mxc: add check to return defer probe if clock tree NOT ready

Ard Biesheuvel (1):
      i2c: synquacer: fix enumeration of slave devices

Arnaud Pouliquen (1):
      ASoC: stm32: fix sai driver name initialisation

Arnd Bergmann (3):
      ARM: orion: don't use using 64-bit DMA masks
      ARM: iop: don't use using 64-bit DMA masks
      mm/kmemleak.c: fix unused-function warning

Arvind Sankar (1):
      igb: Fix WARN_ONCE on runtime suspend

Axel Lin (1):
      reset: meson-audio-arb: Fix missing .owner setting of reset_controlle=
r_dev

Baoquan He (1):
      x86/mm/KASLR: Fix the size of the direct mapping section

Bart Van Assche (1):
      scsi: RDMA/srpt: Fix a credit leak for aborted commands

Brian Norris (1):
      Bluetooth: btusb: request wake pin with NOAUTOEN

Catalin Marinas (1):
      kmemleak: powerpc: skip scanning holes in the .bss section

Charles Keepax (4):
      i2c: Remove unnecessary call to irq_find_mapping
      i2c: Clear client->irq in i2c_device_remove
      ASoC: wm_adsp: Correct handling of compressed streams that restart
      ASoC: wm_adsp: Check for buffer in trigger stop

Daniel Jurgens (2):
      IB/core: Unregister notifier before freeing MAD security
      IB/core: Fix potential memory leak while creating MAD agents

David M=FCller (1):
      clk: x86: Add system specific quirk to mark clocks as critical

David Rientjes (1):
      KVM: SVM: prevent DBG_DECRYPT and DBG_ENCRYPT overflow

Dmitry Torokhov (2):
      HID: input: add mapping for Assistant key
      Input: stmfts - acknowledge that setting brightness is a blocking call

Douglas Anderson (2):
      mwifiex: Make resume actually do something useful again on SDIO cards
      ARM: dts: rockchip: Fix gpu opp node names for rk3288

Emmanuel Grumbach (1):
      iwlwifi: fix driver operation for 5350

Geert Uytterhoeven (1):
      rtc: sh: Fix invalid alarm warning for non-enabled alarm

Greg Kroah-Hartman (1):
      Linux 4.19.41

Guenter Roeck (1):
      xsysace: Fix error handling in ace_setup

Hans de Goede (1):
      ASoC: Intel: bytcr_rt5651: Revert "Fix DMIC map headsetmic mapping"

He, Bo (1):
      HID: debug: fix race condition with between rdesc_show() and device r=
emoval

Jacopo Mondi (1):
      media: v4l2: i2c: ov7670: Fix PLL bypass register values

Jarkko Nikula (1):
      i2c: Prevent runtime suspend of adapter when Host Notify is required

Jeffrey Hugo (2):
      HID: quirks: Fix keyboard + touchpad on Lenovo Miix 630
      clk: qcom: Add missing freq for usb30_master_clk on 8998

Jeremy Fertic (3):
      staging: iio: adt7316: allow adt751x to use internal vref for all dacs
      staging: iio: adt7316: fix the dac read calculation
      staging: iio: adt7316: fix the dac write calculation

Jim Broadus (1):
      i2c: Allow recovery of the initial IRQ by an I2C client device.

Johannes Berg (1):
      mac80211: don't attempt to rename ERR_PTR() debugfs dirs

Kailang Yang (2):
      ALSA: hda/realtek - Add new Dell platform for headset mode
      ALSA: hda/realtek - Fixed Dell AIO speaker noise

Kangjie Lu (1):
      HID: logitech: check the return value of create_singlethread_workqueue

Kim Phillips (1):
      perf/x86/amd: Update generic hardware cache events for Family 17h

Kirill Smelkov (1):
      fs: stream_open - opener for stream-like files so that read and write=
 can run simultaneously without deadlock

Konstantin Khorenko (1):
      bonding: show full hw address in sysfs for slave entries

Leonidas P. Papadakos (1):
      arm64: dts: rockchip: fix rk3328-roc-cc gmac2io tx/rx_delay

Liubin Shu (1):
      net: hns: fix KASAN: use-after-free in hns_nic_net_xmit_hw()

Louis Taylor (1):
      vfio/pci: use correct format characters

Malte Leip (1):
      usb: usbip: fix isoc packet num validation in get_pipe

Michael Kelley (1):
      scsi: storvsc: Fix calculation of sub-channel count

Mike Kravetz (1):
      hugetlbfs: fix memory leak for resv_map

Nicolas Le Bayon (1):
      i2c: i2c-stm32f7: Fix SDADEL minimum formula

Omri Kahalon (1):
      net/mlx5: E-Switch, Fix esw manager vport indication for more vport c=
ommands

Ondrej Mosnacek (1):
      selinux: never allow relabeling on context mounts

Peng Hao (1):
      arm/mach-at91/pm : fix possible object reference leak

Peter Zijlstra (1):
      x86/mm/tlb: Revert "x86/mm: Align TLB invalidation info"

Qian Cai (1):
      x86/mm: Fix a crash with kmemleak_scan()

Rajneesh Bhardwaj (2):
      platform/x86: intel_pmc_core: Fix PCH IP name
      platform/x86: intel_pmc_core: Handle CFL regmap properly

Randy Dunlap (1):
      sh: fix multiple function definition build errors

Sean Wang (1):
      Bluetooth: mediatek: fix up an error path to restore bdev->tx_state

Shenghui Wang (1):
      block: use blk_free_flush_queue() to free hctx->fq in blk_mq_init_hctx

Stephen Boyd (1):
      rtc: cros-ec: Fail suspend/resume if wake IRQ can't be configured

Stephen Smalley (1):
      selinux: avoid silent denials in permissive mode under RCU walk

Sven Eckelmann (3):
      batman-adv: Reduce claim hash refcnt only for removed entry
      batman-adv: Reduce tt_local hash refcnt only for removed entry
      batman-adv: Reduce tt_global hash refcnt only for removed entry

Takashi Iwai (1):
      ALSA: hda/realtek - Apply the fixup for ASUS Q325UAR

Tetsuo Handa (1):
      block: pass no-op callback to INIT_WORK().

Tony Luck (1):
      x86/mce: Improve error message when kernel cannot recover, p2

Varun Prakash (1):
      libcxgb: fix incorrect ppmax calculation

Waiman Long (1):
      efi: Fix debugobjects warning on 'efi_rts_work'

Wei Li (1):
      arm64: fix wrong check of on_sdei_stack in nmi context

Xi Wang (1):
      net: hns3: fix compile error

Xose Vazquez Perez (1):
      scsi: core: add new RDAC LENOVO/DE_Series device

Yonglong Liu (4):
      net: hns: Use NAPI_POLL_WEIGHT for hns driver
      net: hns: Fix probabilistic memory overwrite when HNS driver initiali=
zed
      net: hns: fix ICMP6 neighbor solicitation messages discard problem
      net: hns: Fix WARNING when remove HNS driver with SMMU enabled

Yufen Yu (1):
      nvme-loop: init nvmet_ctrl fatal_err_work when allocate

Yuval Avnery (1):
      IB/core: Destroy QP if XRC QP fails


--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzSn+UACgkQONu9yGCS
aT60XA/9HDHT1tHgcoP32ahpQrC0XuDkkNmw3yamkH1CYFi/MMiT5DKWS+GT3jO7
ypPCQCwTJxoCABui9voBk7C2hrisyW1S8EHEgGWHcCgkkUMNT/aurTzKZFefwc1d
Vojd+CV/Uuk8MSj61iSsO9pecpFUrK0aLYB7mDyt2accJPy2+N7UkdlsHCNPD8Di
aMkBpCGG0Bisxzw2HF67eAqbjlEkh3XL+hLMRBT/K1qktzsiipi24ZZmOvzSEM2p
xE5Nsn0zLgd1smhxOpRpYyhjkrhl1U7Wg39VpIhWvD5r+CTy4Jw5E29iqe71rZ4V
e48gesU1tbj6HLOiHOZn9Ki0l+FE6t3xJH1lGFZiAS1q+ecxr+84TIoIg4yYGitz
tkjOK7dewPjGJwqptoe4MHBDfMhQpkONRfTK4IM7zd3M3b5F3YTvZHzp1I0XX048
F5LH5JJCyV9B5+wudZ++KAqk4w5DLTspdUJ1DSyEgDw3La4aX22Ouwxpoyrmn8Q8
f7NvDN931w8JWC04g1Dz9vxuM7DfSolXmOCxvt2qtbluWYBWAvEFpqHartv0jy96
4NH7XoDeD3kHjX27F5bBwUte2j8T0FyBctxeLdpf5V50RGcd/PJD7+LqKu6XLnl/
tsA0R07k/KoZ3H4PXMQpTPAPwiYSRbXPptMrtLl3wJOkS+63nH0=
=4C3n
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
