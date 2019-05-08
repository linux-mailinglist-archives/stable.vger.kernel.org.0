Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B4017AD0
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 15:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfEHNi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 09:38:58 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36799 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbfEHNi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 09:38:58 -0400
Received: by mail-pf1-f195.google.com with SMTP id v80so10524068pfa.3;
        Wed, 08 May 2019 06:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dA5QctpAz32M08AMxXY2mqAe4EGXD4nRUfu9CN8y9TM=;
        b=pdwc2TeixQrr0w9qFX+G8MIjOAkyxZMueCZfZ5GwTTbi/gQmbcxt/55Z+f6EATprIV
         0luw9W2LSeNS/VIkUw6gca6p5CvQ+qCUO5zospKcYKd4aUTQjNaoTdJ9PP1N42SEORJK
         0bD0fxmI+TwpRhtMoePgnJnjVdDEVjw1SrCLW+uNfHHL8gSN+MTUVy2cUwPBNDLYAC//
         f1TVjcGJ9ekRE+Zc0mZx1W9sUagWMEMv8CpIf2+WMS8ZOE+KJWE37+KohuQw0KWHnvj4
         Bo/tCvF8rSsF9Mk0qO+gBLC1T1brLtk9bmU6fwmo0rtug/+RaHVxPIFEyvdRp+JKf73F
         Y8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dA5QctpAz32M08AMxXY2mqAe4EGXD4nRUfu9CN8y9TM=;
        b=ITKFPSHVI+6nXWeZZAyM7LNlFk60vog8laV3YyX3aYbg/m5PwBk7UyW4a8qlEiwQtA
         g8dhBIzVy5jmQH8Vlj9zf5TFt2mngPpaZe5YIMEZcHQVOgSHyAp/txNLZzd4TO7ctA6d
         /jsN7vYADIesVTrICWuuSlgzdahgb9AkjQYoC04MCn5YnxaubqpjpkF5Uig8kQwvhHrG
         oqLLOORfkkgYeF15hoeyCE9XCk+Nb3E64t4hwW72zZBRJz0ka5AD5sF5CuCT5RGFqEkD
         qXmU4Z9vD665HoAY6Iehx/E7+ICmqWc5spWIcQDQaWlqqY/o8fCFlPup0nO5+8rCpOm1
         /teA==
X-Gm-Message-State: APjAAAWub+gzIAyTo1eULetp3oCbjIXW/u8Isczk8LZVe4RVLkDOpGW9
        k//0w8NEesa+2UZAPhJVusk=
X-Google-Smtp-Source: APXvYqyi7I0/TvW1rzKivJWkd8EkOTvVF/kE9cTKMKeCkd81L5lwaqp/Ka8R+nRo6RSxFIZMyKQtAg==
X-Received: by 2002:a63:1558:: with SMTP id 24mr47552296pgv.126.1557322735393;
        Wed, 08 May 2019 06:38:55 -0700 (PDT)
Received: from Gentoo ([103.231.91.38])
        by smtp.gmail.com with ESMTPSA id z187sm14773081pfb.132.2019.05.08.06.38.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 06:38:53 -0700 (PDT)
Date:   Wed, 8 May 2019 19:08:37 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.0.14
Message-ID: <20190508133837.GA17634@Gentoo>
References: <20190508092307.GA2291@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20190508092307.GA2291@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thanks, a bunch Greg!=20

On 11:23 Wed 08 May , Greg KH wrote:
>I'm announcing the release of the 5.0.14 kernel.
>
>All users of the 5.0 kernel series must upgrade.
>
>The updated 5.0.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.0.y
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
> Documentation/driver-api/usb/power-management.rst          |   14
> Makefile                                                   |    2
> arch/arc/lib/memset-archs.S                                |    4
> arch/arm/boot/dts/am33xx-l4.dtsi                           |    4
> arch/arm/boot/dts/rk3288.dtsi                              |   12
> arch/arm/mach-at91/pm.c                                    |    6
> arch/arm/mach-iop13xx/setup.c                              |    8
> arch/arm/mach-iop13xx/tpmi.c                               |   10
> arch/arm/mach-omap2/display.c                              |    4
> arch/arm/plat-iop/adma.c                                   |    6
> arch/arm/plat-orion/common.c                               |    4
> arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts             |    4
> arch/arm64/kernel/sdei.c                                   |    6
> arch/powerpc/kernel/kvm.c                                  |    7
> arch/powerpc/mm/slice.c                                    |   10
> arch/riscv/include/asm/uaccess.h                           |    2
> arch/sh/boards/of-generic.c                                |    4
> arch/x86/events/amd/core.c                                 |  111 +++
> arch/x86/kernel/cpu/mce/severity.c                         |    5
> arch/x86/kvm/lapic.c                                       |   73 +-
> arch/x86/kvm/lapic.h                                       |    4
> arch/x86/kvm/svm.c                                         |   12
> arch/x86/kvm/vmx/nested.c                                  |    2
> arch/x86/kvm/vmx/vmx.c                                     |    6
> arch/x86/kvm/vmx/vmx.h                                     |    8
> arch/x86/kvm/x86.c                                         |   15
> arch/x86/kvm/x86.h                                         |    2
> arch/x86/mm/init.c                                         |    6
> arch/x86/mm/kaslr.c                                        |    2
> arch/x86/mm/tlb.c                                          |    2
> block/blk-mq.c                                             |    5
> drivers/block/null_blk_main.c                              |    5
> drivers/block/xsysace.c                                    |    2
> drivers/bluetooth/btmtkuart.c                              |    2
> drivers/bluetooth/btusb.c                                  |    2
> drivers/clk/qcom/gcc-msm8998.c                             |    1
> drivers/clk/x86/clk-pmc-atom.c                             |   14
> drivers/gpio/gpio-mxc.c                                    |    5
> drivers/hid/hid-core.c                                     |    6
> drivers/hid/hid-debug.c                                    |    5
> drivers/hid/hid-input.c                                    |    1
> drivers/hid/hid-logitech-hidpp.c                           |    8
> drivers/hid/hid-quirks.c                                   |    5
> drivers/i2c/busses/i2c-imx.c                               |    4
> drivers/i2c/busses/i2c-stm32f7.c                           |    2
> drivers/i2c/busses/i2c-synquacer.c                         |    2
> drivers/i2c/i2c-core-base.c                                |    4
> drivers/infiniband/core/security.c                         |   11
> drivers/infiniband/core/verbs.c                            |   41 -
> drivers/infiniband/ulp/srpt/ib_srpt.c                      |   11
> drivers/input/keyboard/snvs_pwrkey.c                       |    6
> drivers/input/touchscreen/stmfts.c                         |   30 -
> drivers/media/i2c/ov7670.c                                 |   16
> drivers/mfd/twl-core.c                                     |   23
> drivers/mtd/nand/raw/marvell_nand.c                        |   12
> drivers/net/bonding/bond_sysfs_slave.c                     |    4
> drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c         |    9
> drivers/net/ethernet/hisilicon/hns/hnae.c                  |    4
> drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c         |   33 -
> drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c        |    2
> drivers/net/ethernet/hisilicon/hns/hns_enet.c              |   12
> drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile        |    2
> drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile        |    2
> drivers/net/ethernet/intel/i40e/i40e_ethtool.c             |    3
> drivers/net/ethernet/intel/i40e/i40e_ptp.c                 |    5
> drivers/net/ethernet/intel/igb/e1000_defines.h             |    2
> drivers/net/ethernet/intel/igb/igb_main.c                  |   57 --
> drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c               |   16
> drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          |    6
> drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |    1
> drivers/net/ethernet/stmicro/stmmac/descs_com.h            |   22
> drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c         |    2
> drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c       |    2
> drivers/net/ethernet/stmicro/stmmac/enh_desc.c             |   22
> drivers/net/ethernet/stmicro/stmmac/hwif.h                 |    2
> drivers/net/ethernet/stmicro/stmmac/norm_desc.c            |   12
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c          |   34 -
> drivers/net/wireless/intel/iwlwifi/cfg/5000.c              |    3
> drivers/net/wireless/marvell/mwifiex/sdio.c                |    2
> drivers/platform/x86/intel_pmc_core.c                      |    4
> drivers/platform/x86/pmc_atom.c                            |   21
> drivers/reset/reset-meson-audio-arb.c                      |    1
> drivers/rtc/rtc-cros-ec.c                                  |    4
> drivers/rtc/rtc-da9063.c                                   |    7
> drivers/rtc/rtc-sh.c                                       |    2
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                     |    3
> drivers/scsi/scsi_devinfo.c                                |    1
> drivers/scsi/scsi_dh.c                                     |    1
> drivers/scsi/storvsc_drv.c                                 |   13
> drivers/staging/iio/addac/adt7316.c                        |   34 -
> drivers/usb/core/driver.c                                  |   13
> drivers/usb/core/message.c                                 |    4
> drivers/usb/dwc3/gadget.c                                  |    2
> drivers/usb/gadget/udc/dummy_hcd.c                         |   19
> drivers/usb/misc/yurex.c                                   |    1
> drivers/usb/storage/realtek_cr.c                           |   13
> drivers/usb/usbip/stub_rx.c                                |   12
> drivers/usb/usbip/usbip_common.h                           |    7
> drivers/vfio/pci/vfio_pci.c                                |    4
> drivers/w1/masters/ds2490.c                                |    6
> drivers/xen/xenbus/xenbus_dev_frontend.c                   |    4
> fs/debugfs/inode.c                                         |   13
> fs/hugetlbfs/inode.c                                       |   20
> fs/jffs2/readinode.c                                       |    5
> fs/jffs2/super.c                                           |    5
> fs/open.c                                                  |   18
> fs/read_write.c                                            |    5
> include/linux/fs.h                                         |    4
> include/linux/platform_data/x86/clk-pmc-atom.h             |    3
> include/linux/usb.h                                        |    2
> kernel/bpf/cpumap.c                                        |   13
> kernel/seccomp.c                                           |   17
> mm/kmemleak.c                                              |   18
> net/batman-adv/bat_v_elp.c                                 |    6
> net/batman-adv/bridge_loop_avoidance.c                     |   16
> net/batman-adv/translation-table.c                         |   32 -
> net/mac80211/debugfs_netdev.c                              |    2
> net/mac80211/key.c                                         |    9
> scripts/coccinelle/api/stream_open.cocci                   |  363 +++++++=
++++++
> security/selinux/avc.c                                     |   23
> security/selinux/hooks.c                                   |   44 +
> security/selinux/include/avc.h                             |    1
> sound/pci/hda/patch_realtek.c                              |   13
> sound/soc/codecs/wm_adsp.c                                 |    4
> sound/soc/intel/boards/bytcr_rt5651.c                      |    2
> sound/soc/sh/rcar/gen.c                                    |   24
> sound/soc/sh/rcar/rsnd.h                                   |   27
> sound/soc/sh/rcar/ssiu.c                                   |   24
> sound/soc/soc-pcm.c                                        |    7
> sound/soc/stm/stm32_sai_sub.c                              |    2
> sound/soc/sunxi/sun50i-codec-analog.c                      |    4
> tools/testing/selftests/seccomp/seccomp_bpf.c              |   34 -
> 132 files changed, 1345 insertions(+), 428 deletions(-)
>
>Aaro Koskinen (6):
>      net: stmmac: use correct DMA buffer size in the RX descriptor
>      net: stmmac: ratelimit RX error logs
>      net: stmmac: don't stop NAPI processing when dropping a packet
>      net: stmmac: don't overwrite discard_frame status
>      net: stmmac: fix dropping of multi-descriptor RX frames
>      net: stmmac: don't log oversized frames
>
>Al Viro (2):
>      jffs2: fix use-after-free on symlink traversal
>      debugfs: fix use-after-free on symlink traversal
>
>Alan Kao (1):
>      riscv: fix accessing 8-byte variable from RV32
>
>Alan Stern (5):
>      USB: yurex: Fix protection fault after device removal
>      USB: w1 ds2490: Fix bug caused by improper use of altsetting array
>      USB: dummy-hcd: Fix failure to give back unlinked URBs
>      USB: core: Fix unterminated string returned by usb_string()
>      USB: core: Fix bug caused by duplicate interface PM usage counter
>
>Alexander Wetzel (1):
>      mac80211: Honor SW_CRYPTO_CONTROL for unicast keys in AP VLAN mode
>
>Alexandre Belloni (1):
>      rtc: da9063: set uie_unsupported when relevant
>
>Anders Roxell (1):
>      batman-adv: fix warning in function batadv_v_elp_get_throughput
>
>Andreas Kemnade (1):
>      mfd: twl-core: Disable IRQ while suspended
>
>Aneesh Kumar K.V (1):
>      powerpc/mm/hash: Handle mmap_min_addr correctly in get_unmapped_area=
 topdown search
>
>Anson Huang (3):
>      i2c: imx: correct the method of getting private data in notifier_call
>      Input: snvs_pwrkey - initialize necessary driver data before enablin=
g IRQ
>      gpio: mxc: add check to return defer probe if clock tree NOT ready
>
>Ard Biesheuvel (1):
>      i2c: synquacer: fix enumeration of slave devices
>
>Arnaud Pouliquen (1):
>      ASoC: stm32: fix sai driver name initialisation
>
>Arnd Bergmann (3):
>      ARM: orion: don't use using 64-bit DMA masks
>      ARM: iop: don't use using 64-bit DMA masks
>      mm/kmemleak.c: fix unused-function warning
>
>Arvind Sankar (1):
>      igb: Fix WARN_ONCE on runtime suspend
>
>Axel Lin (1):
>      reset: meson-audio-arb: Fix missing .owner setting of reset_controll=
er_dev
>
>Baoquan He (1):
>      x86/mm/KASLR: Fix the size of the direct mapping section
>
>Bart Van Assche (1):
>      scsi: RDMA/srpt: Fix a credit leak for aborted commands
>
>Brian Norris (1):
>      Bluetooth: btusb: request wake pin with NOAUTOEN
>
>Catalin Marinas (1):
>      kmemleak: powerpc: skip scanning holes in the .bss section
>
>Charles Keepax (2):
>      ASoC: wm_adsp: Correct handling of compressed streams that restart
>      ASoC: wm_adsp: Check for buffer in trigger stop
>
>Chen-Yu Tsai (1):
>      ASoC: sunxi: sun50i-codec-analog: Rename hpvcc regulator supply to c=
pvdd
>
>Daniel Jurgens (2):
>      IB/core: Unregister notifier before freeing MAD security
>      IB/core: Fix potential memory leak while creating MAD agents
>
>David M=FCller (1):
>      clk: x86: Add system specific quirk to mark clocks as critical
>
>David Rientjes (1):
>      KVM: SVM: prevent DBG_DECRYPT and DBG_ENCRYPT overflow
>
>Dmitry Torokhov (2):
>      HID: input: add mapping for Assistant key
>      Input: stmfts - acknowledge that setting brightness is a blocking ca=
ll
>
>Dongli Zhang (1):
>      blk-mq: do not reset plug->rq_count before the list is sorted
>
>Douglas Anderson (2):
>      mwifiex: Make resume actually do something useful again on SDIO cards
>      ARM: dts: rockchip: Fix gpu opp node names for rk3288
>
>Emmanuel Grumbach (1):
>      iwlwifi: fix driver operation for 5350
>
>Eugeniy Paltsev (1):
>      ARC: memset: fix build with L1_CACHE_SHIFT !=3D 6
>
>Geert Uytterhoeven (1):
>      rtc: sh: Fix invalid alarm warning for non-enabled alarm
>
>Greg Kroah-Hartman (1):
>      Linux 5.0.14
>
>Guenter Roeck (1):
>      xsysace: Fix error handling in ace_setup
>
>Hans de Goede (1):
>      ASoC: Intel: bytcr_rt5651: Revert "Fix DMIC map headsetmic mapping"
>
>He, Bo (1):
>      HID: debug: fix race condition with between rdesc_show() and device =
removal
>
>Ivan Vecera (1):
>      ixgbe: fix mdio bus registration
>
>Jacob Keller (1):
>      i40e: fix i40e_ptp_adjtime when given a negative delta
>
>Jacopo Mondi (1):
>      media: v4l2: i2c: ov7670: Fix PLL bypass register values
>
>Jarkko Nikula (1):
>      i2c: Prevent runtime suspend of adapter when Host Notify is required
>
>Jeffrey Hugo (2):
>      HID: quirks: Fix keyboard + touchpad on Lenovo Miix 630
>      clk: qcom: Add missing freq for usb30_master_clk on 8998
>
>Jeremy Fertic (4):
>      staging: iio: adt7316: allow adt751x to use internal vref for all da=
cs
>      staging: iio: adt7316: fix the dac read calculation
>      staging: iio: adt7316: fix handling of dac high resolution option
>      staging: iio: adt7316: fix the dac write calculation
>
>Jerome Brunet (1):
>      ASoC: dpcm: skip missing substream while applying symmetry
>
>Jesper Dangaard Brouer (1):
>      xdp: fix cpumap redirect SKB creation bug
>
>Jiada Wang (1):
>      ASoC: rsnd: gen: fix SSI9 4/5/6/7 busif related register address
>
>Johannes Berg (1):
>      mac80211: don't attempt to rename ERR_PTR() debugfs dirs
>
>John Garry (1):
>      scsi: hisi_sas: Fix to only call scsi_get_prot_op() for non-NULL scs=
i_cmnd
>
>John Pittman (1):
>      null_blk: prevent crash from bad home_node value
>
>Julia Lawall (1):
>      ARM: OMAP2+: add missing of_node_put after of_device_is_available
>
>Kai-Heng Feng (1):
>      HID: Increase maximum report size allowed by hid_field_extract()
>
>Kailang Yang (2):
>      ALSA: hda/realtek - Add new Dell platform for headset mode
>      ALSA: hda/realtek - Fixed Dell AIO speaker noise
>
>Kangjie Lu (1):
>      HID: logitech: check the return value of create_singlethread_workque=
ue
>
>Kees Cook (1):
>      selftests/seccomp: Prepare for exclusive seccomp flags
>
>Kim Phillips (1):
>      perf/x86/amd: Update generic hardware cache events for Family 17h
>
>Kirill Smelkov (1):
>      fs: stream_open - opener for stream-like files so that read and writ=
e can run simultaneously without deadlock
>
>Konstantin Khorenko (1):
>      bonding: show full hw address in sysfs for slave entries
>
>Leonidas P. Papadakos (1):
>      arm64: dts: rockchip: fix rk3328-roc-cc gmac2io tx/rx_delay
>
>Liran Alon (1):
>      KVM: x86: Consider LAPIC TSC-Deadline timer expired if deadline too =
short
>
>Liubin Shu (1):
>      net: hns: fix KASAN: use-after-free in hns_nic_net_xmit_hw()
>
>Louis Taylor (1):
>      vfio/pci: use correct format characters
>
>Malte Leip (1):
>      usb: usbip: fix isoc packet num validation in get_pipe
>
>Michael Kelley (1):
>      scsi: storvsc: Fix calculation of sub-channel count
>
>Mike Kravetz (1):
>      hugetlbfs: fix memory leak for resv_map
>
>Miquel Raynal (1):
>      mtd: rawnand: marvell: Clean the controller state before each operat=
ion
>
>Nicolas Le Bayon (1):
>      i2c: i2c-stm32f7: Fix SDADEL minimum formula
>
>Omri Kahalon (1):
>      net/mlx5: E-Switch, Fix esw manager vport indication for more vport =
commands
>
>Ondrej Mosnacek (1):
>      selinux: never allow relabeling on context mounts
>
>Peng Hao (1):
>      arm/mach-at91/pm : fix possible object reference leak
>
>Peter Zijlstra (1):
>      x86/mm/tlb: Revert "x86/mm: Align TLB invalidation info"
>
>Qian Cai (1):
>      x86/mm: Fix a crash with kmemleak_scan()
>
>Rajneesh Bhardwaj (2):
>      platform/x86: intel_pmc_core: Fix PCH IP name
>      platform/x86: intel_pmc_core: Handle CFL regmap properly
>
>Randy Dunlap (1):
>      sh: fix multiple function definition build errors
>
>Roi Dayan (1):
>      net/mlx5: E-Switch, Protect from invalid memory access in offload fd=
b table
>
>Sean Christopherson (7):
>      KVM: lapic: Disable timer advancement if adaptive tuning goes haywire
>      KVM: lapic: Track lapic timer advance per vCPU
>      KVM: lapic: Allow user to disable adaptive tuning of timer advanceme=
nt
>      KVM: lapic: Convert guest TSC to host time domain if necessary
>      KVM: VMX: Save RSI to an unused output in the vCPU-run asm blob
>      KVM: nVMX: Remove a rogue "rax" clobber from nested_vmx_check_vmentr=
y_hw()
>      KVM: lapic: Check for in-kernel LAPIC before deferencing apic pointer
>
>Sean Wang (1):
>      Bluetooth: mediatek: fix up an error path to restore bdev->tx_state
>
>Shenghui Wang (1):
>      block: use blk_free_flush_queue() to free hctx->fq in blk_mq_init_hc=
tx
>
>Stefan Assmann (1):
>      i40e: fix WoL support check
>
>Stephen Boyd (1):
>      rtc: cros-ec: Fail suspend/resume if wake IRQ can't be configured
>
>Stephen Smalley (1):
>      selinux: avoid silent denials in permissive mode under RCU walk
>
>Sven Eckelmann (3):
>      batman-adv: Reduce claim hash refcnt only for removed entry
>      batman-adv: Reduce tt_local hash refcnt only for removed entry
>      batman-adv: Reduce tt_global hash refcnt only for removed entry
>
>Takashi Iwai (1):
>      ALSA: hda/realtek - Apply the fixup for ASUS Q325UAR
>
>Thinh Nguyen (1):
>      usb: dwc3: Reset num_trbs after skipping
>
>Tony Lindgren (1):
>      ARM: dts: Fix dcan clkctrl clock for am3
>
>Tony Luck (1):
>      x86/mce: Improve error message when kernel cannot recover, p2
>
>Tycho Andersen (1):
>      seccomp: Make NEW_LISTENER and TSYNC flags exclusive
>
>Varun Prakash (1):
>      libcxgb: fix incorrect ppmax calculation
>
>Wei Li (1):
>      arm64: fix wrong check of on_sdei_stack in nmi context
>
>Xi Wang (1):
>      net: hns3: fix compile error
>
>Xose Vazquez Perez (1):
>      scsi: core: add new RDAC LENOVO/DE_Series device
>
>Yonglong Liu (4):
>      net: hns: Use NAPI_POLL_WEIGHT for hns driver
>      net: hns: Fix probabilistic memory overwrite when HNS driver initial=
ized
>      net: hns: fix ICMP6 neighbor solicitation messages discard problem
>      net: hns: Fix WARNING when remove HNS driver with SMMU enabled
>
>Yu Zhang (1):
>      kvm: vmx: Fix typos in vmentry/vmexit control setting
>
>Yuval Avnery (1):
>      IB/core: Destroy QP if XRC QP fails
>



--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAlzS29oACgkQsjqdtxFL
KRXsbAf+Jx2Llzi097J74UJKjv26mCE0kB1sTyBTTXq8wBVtpMQ754yDyOotpQ4g
k7A03OKxbJ/sqnQmrQ8VsgDU6OlWQ1/UrQh1b5IV5nEumocXRn1L/mRKMlXueQeV
sBTv7JMSCCDQBUVRz4r5PR/SGyJ2AHgTHVd2qhwyRaYO1bFu/Jld1Av9u9Ooj3qO
HyU9VfUWY83ILlozqY+e2mKRUQOAld70JfSooHNme+OvwLgwQFeX2c4acbvKYu/d
oPTxVTLlBgJO+ZNWFokJjx0w1FuYuy0kvF/hYKQZ85m5F3uxDy27S/ck4yHBz0/X
85e3xkvAi8TVJcT9IPEql+6eLQdFcw==
=5/eT
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
