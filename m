Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F3D25E40
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 08:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfEVGib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 02:38:31 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39792 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfEVGib (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 02:38:31 -0400
Received: by mail-pf1-f195.google.com with SMTP id z26so781536pfg.6;
        Tue, 21 May 2019 23:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DQ52817AKioJ5SLBdUakiC/9OCsDFxjnULVrtoQ9K0Y=;
        b=g3jDTTyEa1hf6/PSRmLJ13ck88ewxlGAPcC+InrMnN5g1jJDz8N7Cru+z1XGVYfXQx
         Gbsb2Qem/06x6zd2mG+h4rg5CYhyCOry6Z4yStWheNSZb0+QlZ1oyuOPpKdCkMcHpdB+
         wLOczZB5521RypIUAVz1SgoZ8+tFwzq9vYB5FLpHUhuWwvmaQ5BLI3djOKRsXcgVGTzF
         pXpqu4NCgXLW79eUk/2RAVfg5J/CruMuzyRu2XS1atXAyOYI3tjyFxwE3vMsFE308a2P
         JAAGJg+2Y4wKumkTXRxLOuwpB8NdN1rLu5JBtu48aYD4A0jFQZWKRaGgXkjngScyH944
         eOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DQ52817AKioJ5SLBdUakiC/9OCsDFxjnULVrtoQ9K0Y=;
        b=FK8Kyh9NgaCh6ioNCw+msTn6p8Gemvi718/VFgs62OrAgvUhuCn5SwwWJMvpymCztz
         jopT/K3erXsksNJ9+AY5jka+9UoYOf+zscK8Tdqqgf35+tl+YVcaPlI190TInraNKX6j
         jl/LkPdJabHVjSZykQsOqByyGKO0LcX2Bcovi+Iglo6yCX/MEMDldGccayq7Oh8L6jGH
         CTExGRSlY2FuJIZPaQak6cu0RvVtidRB5mnnVp/UtWDObWRY+bbHj1FQuXOLxJ/ZCN1d
         AaPII60+Iq4XUMlw/xb4cK9W8BIx6DNbAD4A6eRZhAd2yuTMqGUtHI4D53Q+jwFtZRP6
         +y+Q==
X-Gm-Message-State: APjAAAWo2QgHfiAvr36GXqCy4g7lGXHJscNeF7yC/hMwDIaq3uHGEgWC
        mgLPPY3noTcLYFdP6jiQ82g=
X-Google-Smtp-Source: APXvYqz4b+h5uZjVF7PtbYibaYICzTPOeYyHHiSNqxtwduScxCfZUSonL7En8XlPFKGHMBLcr0Kxug==
X-Received: by 2002:a62:3145:: with SMTP id x66mr67792521pfx.223.1558507110337;
        Tue, 21 May 2019 23:38:30 -0700 (PDT)
Received: from Gentoo ([103.231.90.172])
        by smtp.gmail.com with ESMTPSA id h1sm38055350pfq.3.2019.05.21.23.38.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 23:38:28 -0700 (PDT)
Date:   Wed, 22 May 2019 12:08:18 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.4
Message-ID: <20190522063818.GA28881@Gentoo>
References: <20190522063404.GA20902@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20190522063404.GA20902@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thanks, a bunch Greg!

On 08:34 Wed 22 May , Greg KH wrote:
>I'm announcing the release of the 5.1.4 kernel.
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
> Documentation/devicetree/bindings/mmc/mmc.txt      |    2
> Documentation/x86/mds.rst                          |   44 ---
> Makefile                                           |    4
> arch/arm/boot/dts/exynos5260.dtsi                  |    2
> arch/arm/boot/dts/exynos5422-odroidxu3-audio.dtsi  |    5
> arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi      |    2
> arch/arm/boot/dts/imx6dl-riotboard.dts             |    2
> arch/arm/boot/dts/imx6q-ba16.dtsi                  |    2
> arch/arm/boot/dts/imx6q-marsboard.dts              |    2
> arch/arm/boot/dts/imx6q-tbs2910.dts                |    2
> arch/arm/boot/dts/imx6qdl-apf6.dtsi                |    2
> arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |    2
> arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |    2
> arch/arm/boot/dts/imx6qdl-sr-som.dtsi              |    2
> arch/arm/boot/dts/imx6qdl-wandboard.dtsi           |    2
> arch/arm/boot/dts/imx6sx-sabreauto.dts             |    2
> arch/arm/boot/dts/imx6sx-sdb.dtsi                  |    2
> arch/arm/boot/dts/imx7d-pico.dtsi                  |    2
> arch/arm/boot/dts/qcom-ipq4019.dtsi                |    4
> arch/arm/crypto/aes-neonbs-glue.c                  |    2
> arch/arm/mach-exynos/firmware.c                    |    1
> arch/arm/mach-exynos/suspend.c                     |    2
> arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts  |    2
> arch/arm64/boot/dts/rockchip/rk3399.dtsi           |    1
> arch/arm64/crypto/aes-neonbs-glue.c                |    2
> arch/arm64/crypto/ghash-ce-glue.c                  |   10
> arch/arm64/include/asm/arch_timer.h                |   33 ++
> arch/arm64/include/asm/processor.h                 |    8
> arch/arm64/kernel/debug-monitors.c                 |    1
> arch/arm64/kernel/sys.c                            |    2
> arch/arm64/kernel/vdso/gettimeofday.S              |   15 -
> arch/arm64/mm/proc.S                               |   34 +-
> arch/arm64/net/bpf_jit.h                           |    6
> arch/arm64/net/bpf_jit_comp.c                      |    1
> arch/powerpc/mm/hash_low_32.S                      |    3
> arch/s390/Kconfig                                  |    1
> arch/s390/include/asm/pgtable.h                    |   79 +++--
> arch/s390/mm/Makefile                              |    2
> arch/s390/mm/gup.c                                 |  300 ---------------=
------
> arch/x86/crypto/crct10dif-pclmul_glue.c            |   13
> arch/x86/entry/entry_32.S                          |    2
> arch/x86/entry/entry_64.S                          |    2
> arch/x86/include/asm/switch_to.h                   |    1
> arch/x86/kernel/cpu/mce/amd.c                      |   52 ++-
> arch/x86/kernel/cpu/mce/core.c                     |    8
> arch/x86/kernel/cpu/mce/genpool.c                  |    3
> arch/x86/kernel/cpu/mce/internal.h                 |    9
> arch/x86/kernel/process_32.c                       |    7
> arch/x86/kernel/process_64.c                       |    8
> arch/x86/kernel/traps.c                            |    8
> arch/x86/kvm/lapic.c                               |    2
> arch/x86/kvm/vmx/vmx.c                             |   25 -
> arch/x86/kvm/x86.c                                 |   37 +-
> arch/x86/platform/pvh/enlighten.c                  |    8
> arch/x86/xen/efi.c                                 |   12
> arch/x86/xen/enlighten_pv.c                        |    2
> arch/x86/xen/enlighten_pvh.c                       |    7
> arch/x86/xen/xen-ops.h                             |    4
> crypto/ccm.c                                       |   44 +--
> crypto/chacha20poly1305.c                          |    4
> crypto/chacha_generic.c                            |    2
> crypto/crct10dif_generic.c                         |   11
> crypto/gcm.c                                       |   34 --
> crypto/lrw.c                                       |    4
> crypto/salsa20_generic.c                           |    2
> crypto/skcipher.c                                  |    9
> drivers/acpi/sleep.c                               |    4
> drivers/char/ipmi/ipmi_dmi.c                       |    2
> drivers/char/ipmi/ipmi_plat_data.c                 |   27 +
> drivers/char/ipmi/ipmi_plat_data.h                 |    3
> drivers/char/ipmi/ipmi_si_hardcode.c               |    1
> drivers/char/ipmi/ipmi_si_hotmod.c                 |    1
> drivers/char/ipmi/ipmi_ssif.c                      |    6
> drivers/crypto/amcc/crypto4xx_alg.c                |   12
> drivers/crypto/amcc/crypto4xx_core.c               |   31 +-
> drivers/crypto/caam/caamalg_qi2.c                  |  177 +++++-------
> drivers/crypto/caam/caamalg_qi2.h                  |    2
> drivers/crypto/ccp/psp-dev.c                       |    2
> drivers/crypto/ccree/cc_aead.c                     |   11
> drivers/crypto/ccree/cc_buffer_mgr.c               |  113 ++-----
> drivers/crypto/ccree/cc_driver.h                   |    1
> drivers/crypto/ccree/cc_fips.c                     |   23 +
> drivers/crypto/ccree/cc_fips.h                     |    2
> drivers/crypto/ccree/cc_hash.c                     |   28 +
> drivers/crypto/ccree/cc_ivgen.c                    |    9
> drivers/crypto/ccree/cc_pm.c                       |    9
> drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |   25 +
> drivers/crypto/vmx/aesp8-ppc.pl                    |    4
> drivers/dax/Kconfig                                |    3
> drivers/dax/device.c                               |    6
> drivers/edac/mce_amd.c                             |    4
> drivers/md/bcache/journal.c                        |   11
> drivers/md/bcache/super.c                          |    2
> drivers/mmc/core/queue.c                           |    1
> drivers/mmc/host/Kconfig                           |    1
> drivers/mmc/host/sdhci-of-arasan.c                 |    5
> drivers/mmc/host/sdhci-pci-core.c                  |   96 ++++++
> drivers/mmc/host/sdhci-tegra.c                     |    1
> drivers/mtd/maps/Kconfig                           |    2
> drivers/mtd/maps/physmap-core.c                    |    2
> drivers/mtd/spi-nor/intel-spi.c                    |    8
> drivers/nvdimm/label.c                             |   29 +-
> drivers/nvdimm/namespace_devs.c                    |   15 +
> drivers/nvdimm/nd.h                                |    4
> drivers/power/supply/axp288_charger.c              |    4
> drivers/power/supply/axp288_fuel_gauge.c           |   20 +
> drivers/tty/hvc/hvc_riscv_sbi.c                    |    1
> drivers/tty/vt/keyboard.c                          |   33 +-
> drivers/tty/vt/vt.c                                |    2
> fs/btrfs/backref.c                                 |   34 +-
> fs/btrfs/ctree.c                                   |   10
> fs/btrfs/ctree.h                                   |    6
> fs/btrfs/disk-io.c                                 |   27 +
> fs/btrfs/disk-io.h                                 |    3
> fs/btrfs/extent-tree.c                             |   25 +
> fs/btrfs/ioctl.c                                   |   19 +
> fs/btrfs/send.c                                    |   62 ++++
> fs/cifs/cifs_debug.c                               |    2
> fs/dax.c                                           |    6
> fs/ext4/extents.c                                  |   17 +
> fs/ext4/file.c                                     |    7
> fs/ext4/ioctl.c                                    |    2
> fs/ext4/mballoc.c                                  |    2
> fs/ext4/namei.c                                    |    5
> fs/ext4/resize.c                                   |    1
> fs/ext4/super.c                                    |   62 ++--
> fs/ext4/xattr.c                                    |    2
> fs/fs-writeback.c                                  |   11
> fs/hugetlbfs/inode.c                               |    7
> fs/jbd2/journal.c                                  |   53 ++-
> fs/jbd2/revoke.c                                   |   32 +-
> fs/jbd2/transaction.c                              |    8
> fs/ocfs2/export.c                                  |   30 ++
> include/acpi/platform/aclinux.h                    |   10
> include/linux/huge_mm.h                            |    6
> include/linux/hugetlb.h                            |    4
> include/linux/jbd2.h                               |    8
> include/linux/mfd/da9063/registers.h               |    6
> include/linux/mfd/max77620.h                       |    4
> kernel/bpf/core.c                                  |    4
> kernel/fork.c                                      |   31 ++
> kernel/locking/rwsem-xadd.c                        |   44 ++-
> mm/compaction.c                                    |    4
> mm/huge_memory.c                                   |   16 -
> mm/hugetlb.c                                       |   25 -
> mm/mincore.c                                       |   23 +
> mm/userfaultfd.c                                   |    3
> sound/pci/hda/patch_hdmi.c                         |   11
> sound/pci/hda/patch_realtek.c                      |   68 ++--
> sound/soc/codecs/hdac_hdmi.c                       |   11
> sound/soc/codecs/max98090.c                        |   12
> sound/soc/codecs/rt5677-spi.c                      |   35 +-
> sound/soc/fsl/fsl_esai.c                           |    2
> sound/usb/line6/toneport.c                         |   16 -
> sound/usb/mixer.c                                  |    2
> tools/objtool/check.c                              |    3
> virt/kvm/kvm_main.c                                |    2
> 157 files changed, 1360 insertions(+), 1078 deletions(-)
>
>Adrian Hunter (1):
>      mmc: sdhci-pci: Fix BYT OCP setting
>
>Alexander Sverdlin (1):
>      mtd: spi-nor: intel-spi: Avoid crossing 4K address boundary on read/=
write
>
>Andrea Arcangeli (1):
>      userfaultfd: use RCU to free the task struct when fork fails
>
>Andy Lutomirski (2):
>      x86/speculation/mds: Revert CPU buffer clear on double fault exit
>      x86/speculation/mds: Improve CPU buffer clear documentation
>
>Aneesh Kumar K.V (1):
>      drivers/dax: Allow to include DEV_DAX_PMEM as builtin
>
>Anup Patel (1):
>      tty: Don't force RISCV SBI console as preferred console
>
>Barret Rhoden (1):
>      ext4: fix use-after-free race with debug_want_extra_isize
>
>Boyang Zhou (1):
>      arm64: mmap: Ensure file offset is treated as unsigned
>
>Chengguang Xu (1):
>      jbd2: fix potential double free
>
>Chris Packham (2):
>      mtd: maps: physmap: Store gpio_values correctly
>      mtd: maps: Allow MTD_PHYSMAP with MTD_RAM
>
>Christian Lamparter (3):
>      ARM: dts: qcom: ipq4019: enlarge PCIe BAR range
>      crypto: crypto4xx - fix ctr-aes missing output IV
>      crypto: crypto4xx - fix cfb and ofb "overran dst buffer" issues
>
>Christoph Muellner (3):
>      arm64: dts: rockchip: Disable DCMDs on RK3399's eMMC controller.
>      mmc: sdhci-of-arasan: Add DTS property to disable DCMDs.
>      dt-bindings: mmc: Add disable-cqe-dcmd property.
>
>Christophe Leroy (1):
>      powerpc/32s: fix flush_hash_pages() on SMP
>
>Coly Li (1):
>      bcache: never set KEY_PTRS of journal key to 0 in journal_reclaim()
>
>Corey Minyard (1):
>      ipmi: Add the i2c-addr property for SSIF interfaces
>
>Curtis Malainey (1):
>      ASoC: RT5677-SPI: Disable 16Bit SPI Transfers
>
>Dan Williams (2):
>      mm/huge_memory: fix vmf_insert_pfn_{pmd, pud}() crash, handle unalig=
ned addresses
>      libnvdimm/namespace: Fix label tracking error
>
>Daniel Axtens (1):
>      crypto: vmx - fix copy-paste error in CTR mode
>
>Daniel Borkmann (2):
>      bpf, arm64: remove prefetch insn in xadd mapping
>      bpf: fix out of bounds backwards jmps due to dead code removal
>
>Debabrata Banerjee (1):
>      ext4: fix ext4_show_options for file systems w/o journal
>
>Dmitry Osipenko (1):
>      mfd: max77620: Fix swapped FPS_PERIOD_MAX_US values
>
>Eric Biggers (12):
>      crypto: salsa20 - don't access already-freed walk.iv
>      crypto: lrw - don't access already-freed walk.iv
>      crypto: chacha-generic - fix use as arm64 no-NEON fallback
>      crypto: chacha20poly1305 - set cra_name correctly
>      crypto: ccm - fix incompatibility between "ccm" and "ccm_base"
>      crypto: skcipher - don't WARN on unprocessed data after slow walk st=
ep
>      crypto: crct10dif-generic - fix use via crypto_shash_digest()
>      crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()
>      crypto: arm64/gcm-aes-ce - fix no-NEON fallback code
>      crypto: gcm - fix incompatibility between "gcm" and "gcm_base"
>      crypto: arm/aes-neonbs - don't access already-freed walk.iv
>      crypto: arm64/aes-neonbs - don't access already-freed walk.iv
>
>Erik Schmauss (1):
>      ACPICA: Linux: move ACPI_DEBUG_DEFAULT flag out of ifndef
>
>Fabio Estevam (1):
>      ARM: dts: imx: Fix the AR803X phy-mode
>
>Filipe Manana (4):
>      Btrfs: send, flush dellaloc in order to avoid data loss
>      Btrfs: do not start a transaction during fiemap
>      Btrfs: do not start a transaction at iterate_extent_inodes()
>      Btrfs: fix race between send and deduplication that lead to failures=
 and crashes
>
>Gilad Ben-Yossef (5):
>      crypto: ccree - remove special handling of chained sg
>      crypto: ccree - fix mem leak on error path
>      crypto: ccree - don't map MAC key on stack
>      crypto: ccree - use correct internal state sizes for export
>      crypto: ccree - don't map AEAD key and IV on stack
>
>Greg Kroah-Hartman (1):
>      Linux 5.1.4
>
>Gustavo A. R. Silva (1):
>      power: supply: axp288_charger: Fix unchecked return value
>
>Hans de Goede (1):
>      power: supply: axp288_fuel_gauge: Add ACEPC T8 and T11 mini PCs to t=
he blacklist
>
>Horia Geant=C4=83 (3):
>      crypto: caam/qi2 - fix zero-length buffer DMA mapping
>      crypto: caam/qi2 - fix DMA mapping of stack memory
>      crypto: caam/qi2 - generate hash keys in-place
>
>Hui Wang (2):
>      ALSA: hda/hdmi - Read the pin sense from register when repolling
>      ALSA: hda/hdmi - Consider eld_valid when reporting jack event
>
>Jan Kara (2):
>      ext4: make sanity check in mballoc more strict
>      ext4: avoid panic during forced reboot due to aborted journal
>
>Jean-Philippe Brucker (2):
>      arm64: Clear OSDLR_EL1 on CPU boot
>      arm64: Save and restore OSDLR_EL1 across suspend/resume
>
>Jeremy Soller (2):
>      ALSA: hdea/realtek - Headset fixup for System76 Gazelle (gaze14)
>      ALSA: hda/realtek - Corrected fixup for System76 Gazelle (gaze14)
>
>Jiri Kosina (1):
>      mm/mincore.c: make mincore() more conservative
>
>Jiufei Xue (2):
>      jbd2: check superblock mapped prior to committing
>      fs/writeback.c: use rcu_barrier() to wait for inflight wb switches g=
oing into workqueue when umount
>
>Jon Hunter (1):
>      ASoC: max98090: Fix restore of DAPM Muxes
>
>Josh Poimboeuf (1):
>      objtool: Fix function fallthrough detection
>
>Kai Shen (1):
>      mm/hugetlb.c: don't put_page in lock of hugetlb_lock
>
>Kailang Yang (2):
>      ALSA: hda/realtek - EAPD turn on later
>      ALSA: hda/realtek - Fixup headphone noise via runtime suspend
>
>Kamlakant Patel (1):
>      ipmi:ssif: compare block number correctly for multi-part return mess=
ages
>
>Katsuhiro Suzuki (1):
>      arm64: dts: rockchip: fix IO domain voltage setting of APIO5 on rock=
pro64
>
>Kirill Tkhai (1):
>      ext4: actually request zeroing of inode table after grow
>
>Liang Chen (1):
>      bcache: fix a race between cache register and cacheset unregister
>
>Libin Yang (1):
>      ASoC: codec: hdac_hdmi add device_link to card device
>
>Lukas Czerner (1):
>      ext4: fix data corruption caused by overlapping unaligned and aligne=
d IO
>
>Martin Schwidefsky (2):
>      s390/mm: make the pxd_offset functions more robust
>      s390/mm: convert to the generic get_user_pages_fast code
>
>Masahiro Yamada (1):
>      kbuild: turn auto.conf.cmd into a mandatory include file
>
>Mel Gorman (1):
>      mm/compaction.c: correct zone boundary handling when isolating pages=
 from a pageblock
>
>Micha=C5=82 Wadowski (1):
>      ALSA: hda/realtek - Fix for Lenovo B50-70 inverted internal micropho=
ne bug
>
>Mike Kravetz (1):
>      hugetlb: use same fault hash key for shared and private mappings
>
>Nikolay Borisov (2):
>      btrfs: Correctly free extent buffer in case btree_read_extent_buffer=
_pages fails
>      btrfs: Honour FITRIM range constraints during free space trim
>
>Ofir Drang (4):
>      crypto: ccree - pm resume first enable the source clk
>      crypto: ccree - HOST_POWER_DOWN_EN should be the last CC access duri=
ng suspend
>      crypto: ccree - add function to handle cryptocell tee fips error
>      crypto: ccree - handle tee fips error during power management resume
>
>Pan Bian (1):
>      ext4: avoid drop reference to iloc.bh twice
>
>Peter Xu (1):
>      KVM: Fix the bitmap range to copy during clear dirty
>
>Peter Zijlstra (1):
>      sched/x86: Save [ER]FLAGS on context switch
>
>Qu Wenruo (1):
>      btrfs: Check the first key and level for cached extent buffer
>
>Rajat Jain (1):
>      ACPI: PM: Set enable_for_wake for wakeup GPEs during suspend-to-idle
>
>Raul E Rangel (1):
>      mmc: core: Fix tag set memory leak
>
>Roger Pau Monne (2):
>      xen/pvh: set xen_domain_type to HVM in xen_pvh_init
>      xen/pvh: correctly setup the PV EFI interface for dom0
>
>S.j. Wang (1):
>      ASoC: fsl_esai: Fix missing break in switch statement
>
>Sahitya Tummala (1):
>      ext4: fix use-after-free in dx_release()
>
>Sean Christopherson (3):
>      Revert "KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU"
>      KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes
>      KVM: lapic: Busy wait for timer to expire when using hv_timer
>
>Sergei Trofimovich (1):
>      tty/vt: fix write/write race in ioctl(KDSKBSENT) handler
>
>Shuning Zhang (1):
>      ocfs2: fix ocfs2 read inode data panic in ocfs2_iget
>
>Singh, Brijesh (1):
>      crypto: ccp - Do not free psp_master when PLATFORM_INIT fails
>
>Sowjanya Komatineni (1):
>      mmc: tegra: fix ddr signaling for non-ddr modes
>
>Sriram Rajagopalan (1):
>      ext4: zero out the unused memory region in the extent tree block
>
>Steve French (1):
>      smb3: display session id in debug data
>
>Steve Twiss (1):
>      mfd: da9063: Fix OTP control register names to match datasheets for =
DA9063/63L
>
>Stuart Menefy (1):
>      ARM: dts: exynos: Fix interrupt for shared EINTs on Exynos5260
>
>Sylwester Nawrocki (2):
>      ARM: dts: exynos: Fix audio routing on Odroid XU3
>      ARM: dts: exynos: Fix audio (microphone) routing on Odroid XU3
>
>Takashi Iwai (1):
>      ALSA: line6: toneport: Fix broken usage of timer for delayed executi=
on
>
>Theodore Ts'o (1):
>      ext4: ignore e_value_offs for xattrs with value-in-ea-inode
>
>Vincenzo Frascino (1):
>      arm64: compat: Reduce address limit
>
>Waiman Long (1):
>      locking/rwsem: Prevent decrement of reader count before increment
>
>Wen Yang (1):
>      ARM: exynos: Fix a leaked reference by adding missing of_node_put
>
>Wenwen Wang (1):
>      ALSA: usb-audio: Fix a memory leak bug
>
>Will Deacon (1):
>      arm64: arch_timer: Ensure counter register reads occur with seqlock =
held
>
>Yazen Ghannam (2):
>      x86/MCE: Add an MCE-record filtering function
>      x86/MCE/AMD: Don't report L1 BTB MCA errors on some family 17h models
>
>Yifeng Li (1):
>      tty: vt.c: Fix TIOCL_BLANKSCREEN console blanking if blankinterval =
=3D=3D 0
>
>Zhang Zhijie (1):
>      crypto: rockchip - update IV buffer to contain the next IV
>



--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAlzk7lMACgkQsjqdtxFL
KRWfpQf9HiuoTbyzPqaGckvLfr09OUGTm7LzlKf3Gqk/SeFNH/iu1BqvVC2lUfc5
JNNmXLIGYsZL6qZJEkZGu2zgW7Whz4u7z0hAIl6mNzH4uj82QiCMMeZGYZQBqs68
yTIq44jN+DdTZ7EmueocHUXKPUViEjRVs8gEeX3DGhmmWp3k8N8MLgZZhgqXY8KX
1Hz1X2r3LFMvXUW+n3m1BJUm++f59fq0ra+VBaBr6NwhB3hAleh+qGjsGgVEzfyi
1Untm06AdPLFRZlP2FJZAMOI6vkN9OhNWbHWTQK9FvBtujRQGNqNyrWt35xdv7ix
UHDAXJvcTqvzPzsKdJaNNAqH8Rpswg==
=79mM
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
