Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 696221750B
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 11:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfEHJXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 05:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727185AbfEHJXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 05:23:12 -0400
Received: from localhost (unknown [84.241.196.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FC3420656;
        Wed,  8 May 2019 09:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557307390;
        bh=DgX7r+4Sxz0jgH7bOJOCpABsJChyo77yJAo6NMIVMfU=;
        h=Date:From:To:Cc:Subject:From;
        b=nBpHVa/RsByC7gzRI5dDhATy7VRcQWKEv9gWGm5Zy3BJPsLDEXbUe3uZb9V/r2KJv
         f2c/XcIIYlDaszGJmc/Ux6KTAUlHvZLddrTmv5dFUZN1bxbafX6HT5fg/4gRI3qSac
         ubPMXGQQuc0acvasGIfeuDvXxx6tvsV5oV6Rqmmo=
Date:   Wed, 8 May 2019 11:23:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.0.14
Message-ID: <20190508092307.GA2291@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.0.14 kernel.

All users of the 5.0 kernel series must upgrade.

The updated 5.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/driver-api/usb/power-management.rst          |   14=20
 Makefile                                                   |    2=20
 arch/arc/lib/memset-archs.S                                |    4=20
 arch/arm/boot/dts/am33xx-l4.dtsi                           |    4=20
 arch/arm/boot/dts/rk3288.dtsi                              |   12=20
 arch/arm/mach-at91/pm.c                                    |    6=20
 arch/arm/mach-iop13xx/setup.c                              |    8=20
 arch/arm/mach-iop13xx/tpmi.c                               |   10=20
 arch/arm/mach-omap2/display.c                              |    4=20
 arch/arm/plat-iop/adma.c                                   |    6=20
 arch/arm/plat-orion/common.c                               |    4=20
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts             |    4=20
 arch/arm64/kernel/sdei.c                                   |    6=20
 arch/powerpc/kernel/kvm.c                                  |    7=20
 arch/powerpc/mm/slice.c                                    |   10=20
 arch/riscv/include/asm/uaccess.h                           |    2=20
 arch/sh/boards/of-generic.c                                |    4=20
 arch/x86/events/amd/core.c                                 |  111 +++
 arch/x86/kernel/cpu/mce/severity.c                         |    5=20
 arch/x86/kvm/lapic.c                                       |   73 +-
 arch/x86/kvm/lapic.h                                       |    4=20
 arch/x86/kvm/svm.c                                         |   12=20
 arch/x86/kvm/vmx/nested.c                                  |    2=20
 arch/x86/kvm/vmx/vmx.c                                     |    6=20
 arch/x86/kvm/vmx/vmx.h                                     |    8=20
 arch/x86/kvm/x86.c                                         |   15=20
 arch/x86/kvm/x86.h                                         |    2=20
 arch/x86/mm/init.c                                         |    6=20
 arch/x86/mm/kaslr.c                                        |    2=20
 arch/x86/mm/tlb.c                                          |    2=20
 block/blk-mq.c                                             |    5=20
 drivers/block/null_blk_main.c                              |    5=20
 drivers/block/xsysace.c                                    |    2=20
 drivers/bluetooth/btmtkuart.c                              |    2=20
 drivers/bluetooth/btusb.c                                  |    2=20
 drivers/clk/qcom/gcc-msm8998.c                             |    1=20
 drivers/clk/x86/clk-pmc-atom.c                             |   14=20
 drivers/gpio/gpio-mxc.c                                    |    5=20
 drivers/hid/hid-core.c                                     |    6=20
 drivers/hid/hid-debug.c                                    |    5=20
 drivers/hid/hid-input.c                                    |    1=20
 drivers/hid/hid-logitech-hidpp.c                           |    8=20
 drivers/hid/hid-quirks.c                                   |    5=20
 drivers/i2c/busses/i2c-imx.c                               |    4=20
 drivers/i2c/busses/i2c-stm32f7.c                           |    2=20
 drivers/i2c/busses/i2c-synquacer.c                         |    2=20
 drivers/i2c/i2c-core-base.c                                |    4=20
 drivers/infiniband/core/security.c                         |   11=20
 drivers/infiniband/core/verbs.c                            |   41 -
 drivers/infiniband/ulp/srpt/ib_srpt.c                      |   11=20
 drivers/input/keyboard/snvs_pwrkey.c                       |    6=20
 drivers/input/touchscreen/stmfts.c                         |   30 -
 drivers/media/i2c/ov7670.c                                 |   16=20
 drivers/mfd/twl-core.c                                     |   23=20
 drivers/mtd/nand/raw/marvell_nand.c                        |   12=20
 drivers/net/bonding/bond_sysfs_slave.c                     |    4=20
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c         |    9=20
 drivers/net/ethernet/hisilicon/hns/hnae.c                  |    4=20
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c         |   33 -
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c        |    2=20
 drivers/net/ethernet/hisilicon/hns/hns_enet.c              |   12=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile        |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile        |    2=20
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c             |    3=20
 drivers/net/ethernet/intel/i40e/i40e_ptp.c                 |    5=20
 drivers/net/ethernet/intel/igb/e1000_defines.h             |    2=20
 drivers/net/ethernet/intel/igb/igb_main.c                  |   57 --
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c               |   16=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          |    6=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |    1=20
 drivers/net/ethernet/stmicro/stmmac/descs_com.h            |   22=20
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c         |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c       |    2=20
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c             |   22=20
 drivers/net/ethernet/stmicro/stmmac/hwif.h                 |    2=20
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c            |   12=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c          |   34 -
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c              |    3=20
 drivers/net/wireless/marvell/mwifiex/sdio.c                |    2=20
 drivers/platform/x86/intel_pmc_core.c                      |    4=20
 drivers/platform/x86/pmc_atom.c                            |   21=20
 drivers/reset/reset-meson-audio-arb.c                      |    1=20
 drivers/rtc/rtc-cros-ec.c                                  |    4=20
 drivers/rtc/rtc-da9063.c                                   |    7=20
 drivers/rtc/rtc-sh.c                                       |    2=20
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                     |    3=20
 drivers/scsi/scsi_devinfo.c                                |    1=20
 drivers/scsi/scsi_dh.c                                     |    1=20
 drivers/scsi/storvsc_drv.c                                 |   13=20
 drivers/staging/iio/addac/adt7316.c                        |   34 -
 drivers/usb/core/driver.c                                  |   13=20
 drivers/usb/core/message.c                                 |    4=20
 drivers/usb/dwc3/gadget.c                                  |    2=20
 drivers/usb/gadget/udc/dummy_hcd.c                         |   19=20
 drivers/usb/misc/yurex.c                                   |    1=20
 drivers/usb/storage/realtek_cr.c                           |   13=20
 drivers/usb/usbip/stub_rx.c                                |   12=20
 drivers/usb/usbip/usbip_common.h                           |    7=20
 drivers/vfio/pci/vfio_pci.c                                |    4=20
 drivers/w1/masters/ds2490.c                                |    6=20
 drivers/xen/xenbus/xenbus_dev_frontend.c                   |    4=20
 fs/debugfs/inode.c                                         |   13=20
 fs/hugetlbfs/inode.c                                       |   20=20
 fs/jffs2/readinode.c                                       |    5=20
 fs/jffs2/super.c                                           |    5=20
 fs/open.c                                                  |   18=20
 fs/read_write.c                                            |    5=20
 include/linux/fs.h                                         |    4=20
 include/linux/platform_data/x86/clk-pmc-atom.h             |    3=20
 include/linux/usb.h                                        |    2=20
 kernel/bpf/cpumap.c                                        |   13=20
 kernel/seccomp.c                                           |   17=20
 mm/kmemleak.c                                              |   18=20
 net/batman-adv/bat_v_elp.c                                 |    6=20
 net/batman-adv/bridge_loop_avoidance.c                     |   16=20
 net/batman-adv/translation-table.c                         |   32 -
 net/mac80211/debugfs_netdev.c                              |    2=20
 net/mac80211/key.c                                         |    9=20
 scripts/coccinelle/api/stream_open.cocci                   |  363 ++++++++=
+++++
 security/selinux/avc.c                                     |   23=20
 security/selinux/hooks.c                                   |   44 +
 security/selinux/include/avc.h                             |    1=20
 sound/pci/hda/patch_realtek.c                              |   13=20
 sound/soc/codecs/wm_adsp.c                                 |    4=20
 sound/soc/intel/boards/bytcr_rt5651.c                      |    2=20
 sound/soc/sh/rcar/gen.c                                    |   24=20
 sound/soc/sh/rcar/rsnd.h                                   |   27=20
 sound/soc/sh/rcar/ssiu.c                                   |   24=20
 sound/soc/soc-pcm.c                                        |    7=20
 sound/soc/stm/stm32_sai_sub.c                              |    2=20
 sound/soc/sunxi/sun50i-codec-analog.c                      |    4=20
 tools/testing/selftests/seccomp/seccomp_bpf.c              |   34 -
 132 files changed, 1345 insertions(+), 428 deletions(-)

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

Charles Keepax (2):
      ASoC: wm_adsp: Correct handling of compressed streams that restart
      ASoC: wm_adsp: Check for buffer in trigger stop

Chen-Yu Tsai (1):
      ASoC: sunxi: sun50i-codec-analog: Rename hpvcc regulator supply to cp=
vdd

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

Dongli Zhang (1):
      blk-mq: do not reset plug->rq_count before the list is sorted

Douglas Anderson (2):
      mwifiex: Make resume actually do something useful again on SDIO cards
      ARM: dts: rockchip: Fix gpu opp node names for rk3288

Emmanuel Grumbach (1):
      iwlwifi: fix driver operation for 5350

Eugeniy Paltsev (1):
      ARC: memset: fix build with L1_CACHE_SHIFT !=3D 6

Geert Uytterhoeven (1):
      rtc: sh: Fix invalid alarm warning for non-enabled alarm

Greg Kroah-Hartman (1):
      Linux 5.0.14

Guenter Roeck (1):
      xsysace: Fix error handling in ace_setup

Hans de Goede (1):
      ASoC: Intel: bytcr_rt5651: Revert "Fix DMIC map headsetmic mapping"

He, Bo (1):
      HID: debug: fix race condition with between rdesc_show() and device r=
emoval

Ivan Vecera (1):
      ixgbe: fix mdio bus registration

Jacob Keller (1):
      i40e: fix i40e_ptp_adjtime when given a negative delta

Jacopo Mondi (1):
      media: v4l2: i2c: ov7670: Fix PLL bypass register values

Jarkko Nikula (1):
      i2c: Prevent runtime suspend of adapter when Host Notify is required

Jeffrey Hugo (2):
      HID: quirks: Fix keyboard + touchpad on Lenovo Miix 630
      clk: qcom: Add missing freq for usb30_master_clk on 8998

Jeremy Fertic (4):
      staging: iio: adt7316: allow adt751x to use internal vref for all dacs
      staging: iio: adt7316: fix the dac read calculation
      staging: iio: adt7316: fix handling of dac high resolution option
      staging: iio: adt7316: fix the dac write calculation

Jerome Brunet (1):
      ASoC: dpcm: skip missing substream while applying symmetry

Jesper Dangaard Brouer (1):
      xdp: fix cpumap redirect SKB creation bug

Jiada Wang (1):
      ASoC: rsnd: gen: fix SSI9 4/5/6/7 busif related register address

Johannes Berg (1):
      mac80211: don't attempt to rename ERR_PTR() debugfs dirs

John Garry (1):
      scsi: hisi_sas: Fix to only call scsi_get_prot_op() for non-NULL scsi=
_cmnd

John Pittman (1):
      null_blk: prevent crash from bad home_node value

Julia Lawall (1):
      ARM: OMAP2+: add missing of_node_put after of_device_is_available

Kai-Heng Feng (1):
      HID: Increase maximum report size allowed by hid_field_extract()

Kailang Yang (2):
      ALSA: hda/realtek - Add new Dell platform for headset mode
      ALSA: hda/realtek - Fixed Dell AIO speaker noise

Kangjie Lu (1):
      HID: logitech: check the return value of create_singlethread_workqueue

Kees Cook (1):
      selftests/seccomp: Prepare for exclusive seccomp flags

Kim Phillips (1):
      perf/x86/amd: Update generic hardware cache events for Family 17h

Kirill Smelkov (1):
      fs: stream_open - opener for stream-like files so that read and write=
 can run simultaneously without deadlock

Konstantin Khorenko (1):
      bonding: show full hw address in sysfs for slave entries

Leonidas P. Papadakos (1):
      arm64: dts: rockchip: fix rk3328-roc-cc gmac2io tx/rx_delay

Liran Alon (1):
      KVM: x86: Consider LAPIC TSC-Deadline timer expired if deadline too s=
hort

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

Miquel Raynal (1):
      mtd: rawnand: marvell: Clean the controller state before each operati=
on

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

Roi Dayan (1):
      net/mlx5: E-Switch, Protect from invalid memory access in offload fdb=
 table

Sean Christopherson (7):
      KVM: lapic: Disable timer advancement if adaptive tuning goes haywire
      KVM: lapic: Track lapic timer advance per vCPU
      KVM: lapic: Allow user to disable adaptive tuning of timer advancement
      KVM: lapic: Convert guest TSC to host time domain if necessary
      KVM: VMX: Save RSI to an unused output in the vCPU-run asm blob
      KVM: nVMX: Remove a rogue "rax" clobber from nested_vmx_check_vmentry=
_hw()
      KVM: lapic: Check for in-kernel LAPIC before deferencing apic pointer

Sean Wang (1):
      Bluetooth: mediatek: fix up an error path to restore bdev->tx_state

Shenghui Wang (1):
      block: use blk_free_flush_queue() to free hctx->fq in blk_mq_init_hctx

Stefan Assmann (1):
      i40e: fix WoL support check

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

Thinh Nguyen (1):
      usb: dwc3: Reset num_trbs after skipping

Tony Lindgren (1):
      ARM: dts: Fix dcan clkctrl clock for am3

Tony Luck (1):
      x86/mce: Improve error message when kernel cannot recover, p2

Tycho Andersen (1):
      seccomp: Make NEW_LISTENER and TSYNC flags exclusive

Varun Prakash (1):
      libcxgb: fix incorrect ppmax calculation

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

Yu Zhang (1):
      kvm: vmx: Fix typos in vmentry/vmexit control setting

Yuval Avnery (1):
      IB/core: Destroy QP if XRC QP fails


--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzSn/sACgkQONu9yGCS
aT5gFhAAoQzCkJo2U33TiDO19hwKjM3AsrThrKnmdA4aFijk6iU+kjF5j58fiyFd
d0joMEbI+8PjqdGTlBTPNccBe43KT2DWZh5jvxmIqY94A/mrBsTnUy1vtgNLnPTd
kp2vjMpO6aJGXwoGMLMdj7e1YHQGFc3Vfi+ogUVEQ3SPluia1E9rB76WkJK4p8/1
0c5TA3SGNvAZYq81q0xsUCsZyIK8Jn0I/LuBnJ9daHI0M+FWgEDmraiv+IgHQCfu
U52FQey9b2Mq5iL0MP4f+e4EZuJF3OZKQna4Znz6Q8yvI13TLTTzfy0lg02rXrGv
ytfkbTlUR/tYM+vJlDJHY1Adx9P+68ueaFWr5P6p6PNsjfCffQbtMAVHP1vT3jSF
eGOADPSk7A2x/8ECjBHZD4QuKUyEwSIL4JdyS35BSv7eDJF8bwdtiprHelE+UHwu
KGN/K6tXGyNtJCKsKBsS3AmQpsZSyzYlsaq9k2SBECAT3Dj7MaL+BQptWzJnqXfI
yI+rCbaErqXiFbJAsUCtFH5z3G+diguryc2VR3qwXZbKcQfnsFe5sGwKsvFormUL
jSyP6SOY8DNmJtYcCeb5oF+8VE2FzevMDozGVjFgm6v3YyU78SSlO/qxg8JCtXka
G55yKtIAJE7BxGw8Vh75fLgqQt77MQ0+12OBO4TQTSkgsAlrRJc=
=oH52
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
