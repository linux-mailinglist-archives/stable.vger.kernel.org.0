Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972E580A57
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 12:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfHDKNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 06:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbfHDKNN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Aug 2019 06:13:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7BB12085B;
        Sun,  4 Aug 2019 10:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564913590;
        bh=0x1K37CZHp6F3Ca8S2/YTaBLn6uJViyZxjvRX+4KOfc=;
        h=Date:From:To:Cc:Subject:From;
        b=Fk2vpyoaUDytmWv3IIVUPbm0b/mmTzhctwFicmYtaDyV+oGM1FB5YjkSEnth+YzJ/
         3qp6jwLslC6m1fNZLWDv63tjYga0i9qAktntoYV54Vvogm5Db6LqiUxUzNfertGUXd
         htzHgbMQwMBuWBBY0Qw6Qv5hU6mKBp9W7tdWR4Hc=
Date:   Sun, 4 Aug 2019 12:13:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.187
Message-ID: <20190804101307.GA21860@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.187 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/serial/mvebu-uart.txt |    2=20
 Makefile                                                |    3=20
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi            |    2=20
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi          |    3=20
 arch/arm64/boot/dts/nvidia/tegra210.dtsi                |    2=20
 arch/arm64/crypto/sha1-ce-glue.c                        |    2=20
 arch/arm64/crypto/sha2-ce-glue.c                        |    2=20
 arch/arm64/include/asm/compat.h                         |    1=20
 arch/arm64/kernel/acpi.c                                |   10=20
 arch/arm64/kernel/image.h                               |    6=20
 arch/mips/boot/compressed/Makefile                      |    2=20
 arch/mips/boot/compressed/calc_vmlinuz_load_addr.c      |    2=20
 arch/mips/include/asm/mach-ath79/ar933x_uart.h          |    4=20
 arch/parisc/kernel/ptrace.c                             |   31=20
 arch/powerpc/boot/xz_config.h                           |   20=20
 arch/powerpc/kernel/eeh.c                               |   15=20
 arch/powerpc/kernel/exceptions-64s.S                    |    9=20
 arch/powerpc/kernel/pci_of_scan.c                       |    2=20
 arch/powerpc/kernel/signal_32.c                         |    3=20
 arch/powerpc/kernel/signal_64.c                         |    5=20
 arch/powerpc/kernel/swsusp_32.S                         |   73=20
 arch/powerpc/platforms/powermac/sleep.S                 |   68=20
 arch/powerpc/sysdev/uic.c                               |    1=20
 arch/sh/include/asm/io.h                                |    6=20
 arch/um/include/asm/mmu_context.h                       |    2=20
 arch/um/include/asm/thread_info.h                       |    3=20
 arch/um/include/shared/os.h                             |    2=20
 arch/um/kernel/process.c                                |    4=20
 arch/um/os-Linux/skas/process.c                         |   17=20
 arch/x86/events/amd/uncore.c                            |  106=20
 arch/x86/kernel/cpu/bugs.c                              |    2=20
 arch/x86/kernel/cpu/mkcapflags.sh                       |    2=20
 arch/x86/kernel/sysfb_efi.c                             |   46=20
 arch/x86/kvm/pmu.c                                      |    4=20
 arch/x86/um/os-Linux/registers.c                        |   30=20
 arch/x86/um/user-offsets.c                              |    6=20
 block/compat_ioctl.c                                    |  340 --
 crypto/asymmetric_keys/Kconfig                          |    3=20
 crypto/chacha20poly1305.c                               |   30=20
 crypto/ghash-generic.c                                  |    8=20
 drivers/ata/libata-eh.c                                 |    8=20
 drivers/base/regmap/regmap.c                            |    2=20
 drivers/block/floppy.c                                  |  362 ++
 drivers/bluetooth/hci_ath.c                             |    3=20
 drivers/bluetooth/hci_bcm.c                             |    3=20
 drivers/bluetooth/hci_bcsp.c                            |    5=20
 drivers/bluetooth/hci_intel.c                           |    3=20
 drivers/bluetooth/hci_ldisc.c                           |    9=20
 drivers/bluetooth/hci_mrvl.c                            |    3=20
 drivers/bluetooth/hci_uart.h                            |    1=20
 drivers/char/hpet.c                                     |    3=20
 drivers/clocksource/exynos_mct.c                        |    4=20
 drivers/crypto/amcc/crypto4xx_trng.c                    |    1=20
 drivers/crypto/caam/caamalg.c                           |   16=20
 drivers/crypto/ccp/ccp-dev.c                            |  102=20
 drivers/crypto/ccp/ccp-dev.h                            |    2=20
 drivers/crypto/talitos.c                                |   35=20
 drivers/dma/imx-sdma.c                                  |   48=20
 drivers/edac/edac_mc_sysfs.c                            |   24=20
 drivers/edac/edac_module.h                              |    2=20
 drivers/gpio/gpio-omap.c                                |   17=20
 drivers/gpio/gpiolib.c                                  |    6=20
 drivers/gpu/drm/bridge/sii902x.c                        |    5=20
 drivers/gpu/drm/bridge/tc358767.c                       |    7=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c          |   20=20
 drivers/gpu/drm/panel/panel-simple.c                    |    9=20
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c             |    3=20
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                  |    3=20
 drivers/gpu/drm/virtio/virtgpu_vq.c                     |    2=20
 drivers/gpu/ipu-v3/ipu-ic.c                             |    2=20
 drivers/hwtracing/intel_th/msu.c                        |    2=20
 drivers/i2c/busses/i2c-qup.c                            |    2=20
 drivers/infiniband/hw/i40iw/i40iw_verbs.c               |    2=20
 drivers/infiniband/sw/rxe/rxe_resp.c                    |    5=20
 drivers/infiniband/sw/rxe/rxe_verbs.h                   |    1=20
 drivers/infiniband/ulp/ipoib/ipoib_main.c               |    1=20
 drivers/input/tablet/gtco.c                             |   20=20
 drivers/isdn/hardware/mISDN/hfcsusb.c                   |    3=20
 drivers/mailbox/mailbox.c                               |    6=20
 drivers/md/bcache/super.c                               |    2=20
 drivers/md/dm-bufio.c                                   |    4=20
 drivers/media/dvb-frontends/tua6100.c                   |   22=20
 drivers/media/i2c/Makefile                              |    2=20
 drivers/media/i2c/adv7511-v4l2.c                        | 2008 +++++++++++=
+++++
 drivers/media/i2c/adv7511.c                             | 2003 -----------=
----
 drivers/media/media-device.c                            |   10=20
 drivers/media/platform/coda/coda-bit.c                  |    9=20
 drivers/media/platform/davinci/vpss.c                   |    5=20
 drivers/media/platform/marvell-ccic/mcam-core.c         |    5=20
 drivers/media/radio/radio-raremono.c                    |   30=20
 drivers/media/radio/wl128x/fmdrv_v4l2.c                 |    3=20
 drivers/media/usb/au0828/au0828-core.c                  |   12=20
 drivers/media/usb/cpia2/cpia2_usb.c                     |    3=20
 drivers/media/usb/dvb-usb/dvb-usb-init.c                |    7=20
 drivers/media/v4l2-core/v4l2-ctrls.c                    |    9=20
 drivers/memstick/core/memstick.c                        |   13=20
 drivers/mfd/arizona-core.c                              |    2=20
 drivers/mfd/hi655x-pmic.c                               |    2=20
 drivers/mfd/mfd-core.c                                  |    1=20
 drivers/net/bonding/bond_main.c                         |   37=20
 drivers/net/caif/caif_hsi.c                             |    2=20
 drivers/net/dsa/mv88e6xxx/chip.c                        |    2=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c         |    8=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c     |    4=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c        |   33=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h       |    3=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.c          |   57=20
 drivers/net/ethernet/freescale/fec_main.c               |    6=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c        |    3=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h            |    1=20
 drivers/net/ethernet/marvell/sky2.c                     |    7=20
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c    |    6=20
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c       |   10=20
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c       |   20=20
 drivers/net/gtp.c                                       |    4=20
 drivers/net/macsec.c                                    |    6=20
 drivers/net/phy/phy_device.c                            |    6=20
 drivers/net/usb/asix_devices.c                          |    6=20
 drivers/net/vrf.c                                       |   58=20
 drivers/net/wireless/ath/ath10k/hw.c                    |    2=20
 drivers/net/wireless/ath/ath10k/mac.c                   |    4=20
 drivers/net/wireless/ath/ath6kl/wmi.c                   |   10=20
 drivers/net/wireless/ath/ath9k/hw.c                     |   32=20
 drivers/net/wireless/ath/dfs_pattern_detector.c         |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c             |    3=20
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c            |   27=20
 drivers/net/wireless/mediatek/mt7601u/dma.c             |   54=20
 drivers/net/wireless/mediatek/mt7601u/tx.c              |    4=20
 drivers/nvdimm/dax_devs.c                               |    2=20
 drivers/nvdimm/pfn.h                                    |    1=20
 drivers/nvdimm/pfn_devs.c                               |   18=20
 drivers/pci/host/pci-hyperv.c                           |   19=20
 drivers/pci/host/pcie-xilinx-nwl.c                      |   11=20
 drivers/pci/pci-sysfs.c                                 |    2=20
 drivers/pci/pci.c                                       |    7=20
 drivers/phy/phy-rcar-gen2.c                             |    2=20
 drivers/pinctrl/pinctrl-rockchip.c                      |    1=20
 drivers/pps/pps.c                                       |    8=20
 drivers/regulator/s2mps11.c                             |    4=20
 drivers/s390/cio/qdio_main.c                            |    1=20
 drivers/scsi/NCR5380.c                                  |   33=20
 drivers/scsi/mac_scsi.c                                 |    4=20
 drivers/staging/media/davinci_vpfe/vpfe_video.c         |    3=20
 drivers/tty/serial/8250/8250_port.c                     |    3=20
 drivers/tty/serial/cpm_uart/cpm_uart_core.c             |   17=20
 drivers/tty/serial/digicolor-usart.c                    |    6=20
 drivers/tty/serial/max310x.c                            |   51=20
 drivers/tty/serial/msm_serial.c                         |    4=20
 drivers/tty/serial/serial_core.c                        |    7=20
 drivers/tty/serial/sh-sci.c                             |   33=20
 drivers/usb/core/hub.c                                  |   35=20
 drivers/usb/gadget/function/f_fs.c                      |    6=20
 drivers/usb/host/hwa-hc.c                               |    2=20
 drivers/usb/host/pci-quirks.c                           |   31=20
 drivers/vhost/net.c                                     |    2=20
 drivers/xen/balloon.c                                   |   16=20
 fs/9p/vfs_addr.c                                        |    6=20
 fs/btrfs/file.c                                         |    5=20
 fs/ceph/caps.c                                          |    7=20
 fs/coda/file.c                                          |   69=20
 fs/ecryptfs/crypto.c                                    |   12=20
 fs/exec.c                                               |    2=20
 fs/ext4/dir.c                                           |   19=20
 fs/ext4/namei.c                                         |   45=20
 fs/f2fs/segment.c                                       |    5=20
 fs/fs-writeback.c                                       |    8=20
 fs/nfs/inode.c                                          |    1=20
 fs/nfs/nfs4file.c                                       |    2=20
 fs/nfs/nfs4proc.c                                       |   41=20
 fs/nfsd/nfs4state.c                                     |   11=20
 fs/nfsd/nfssvc.c                                        |    2=20
 fs/open.c                                               |   19=20
 fs/proc/proc_sysctl.c                                   |    4=20
 include/linux/compiler.h                                |   22=20
 include/linux/cpuhotplug.h                              |    2=20
 include/linux/cred.h                                    |    7=20
 include/linux/rcupdate.h                                |    2=20
 include/linux/sched.h                                   |    4=20
 include/net/tcp.h                                       |   11=20
 kernel/bpf/Makefile                                     |    1=20
 kernel/cred.c                                           |   21=20
 kernel/fork.c                                           |    2=20
 kernel/locking/lockdep.c                                |   18=20
 kernel/locking/lockdep_proc.c                           |    8=20
 kernel/padata.c                                         |   12=20
 kernel/pid_namespace.c                                  |    2=20
 kernel/sched/fair.c                                     |   24=20
 kernel/time/ntp.c                                       |    4=20
 kernel/time/timer_list.c                                |   36=20
 kernel/trace/trace.c                                    |   12=20
 lib/reed_solomon/decode_rs.c                            |   18=20
 lib/scatterlist.c                                       |    9=20
 lib/string.c                                            |    2=20
 mm/kmemleak.c                                           |    2=20
 mm/mmu_notifier.c                                       |    2=20
 net/9p/trans_virtio.c                                   |    8=20
 net/batman-adv/translation-table.c                      |    2=20
 net/bluetooth/6lowpan.c                                 |   14=20
 net/bluetooth/hci_event.c                               |    5=20
 net/bluetooth/l2cap_core.c                              |   15=20
 net/bluetooth/smp.c                                     |   13=20
 net/bridge/br_multicast.c                               |   32=20
 net/bridge/br_stp_bpdu.c                                |    3=20
 net/core/neighbour.c                                    |    2=20
 net/ipv4/devinet.c                                      |    8=20
 net/ipv4/igmp.c                                         |    8=20
 net/ipv4/tcp.c                                          |    2=20
 net/ipv6/ip6mr.c                                        |   11=20
 net/key/af_key.c                                        |    8=20
 net/netrom/af_netrom.c                                  |    4=20
 net/nfc/nci/data.c                                      |    2=20
 net/openvswitch/actions.c                               |    6=20
 net/rxrpc/af_rxrpc.c                                    |    4=20
 net/xfrm/Kconfig                                        |    2=20
 net/xfrm/xfrm_user.c                                    |   19=20
 scripts/kallsyms.c                                      |    3=20
 scripts/recordmcount.h                                  |    3=20
 sound/core/seq/seq_clientmgr.c                          |   11=20
 sound/pci/hda/patch_conexant.c                          |    1=20
 sound/pci/hda/patch_realtek.c                           |    5=20
 sound/usb/line6/podhd.c                                 |    2=20
 tools/iio/iio_utils.c                                   |    4=20
 tools/perf/arch/arm/util/cs-etm.c                       |  127 -
 tools/perf/perf.h                                       |    2=20
 tools/perf/tests/mmap-thread-lookup.c                   |    2=20
 tools/perf/tests/parse-events.c                         |   27=20
 tools/perf/util/evsel.c                                 |    8=20
 tools/perf/util/header.c                                |    2=20
 tools/power/cpupower/utils/cpufreq-set.c                |    2=20
 229 files changed, 4293 insertions(+), 3082 deletions(-)

Abhishek Goel (1):
      cpupower : frequency-set -r option misses the last cpu in related cpu=
 list

Abhishek Sahu (1):
      i2c: qup: fixed releasing dma without flush operation completion

Al Viro (1):
      take floppy compat ioctls to sodding floppy.c

Alexander Shishkin (1):
      intel_th: msu: Fix single mode with disabled IOMMU

Alexey Kardashevskiy (1):
      powerpc/pci/of: Fix OF flags parsing for 64bit BARs

Anders Roxell (1):
      media: i2c: fix warning same module names

Andreas Steinmetz (2):
      macsec: fix use-after-free of skb during RX
      macsec: fix checksumming after decryption

Andrei Otcheretianski (1):
      iwlwifi: mvm: Drop large non sta frames

Andrey Ryabinin (3):
      compiler.h, kasan: Avoid duplicating __read_once_size_nocheck()
      compiler.h: Add read_word_at_a_time() function.
      lib/strscpy: Shut up KASAN false-positives in strscpy()

Andrzej Pietrasiewicz (1):
      usb: gadget: Zero ffs_io_data

Anilkumar Kolli (1):
      ath: DFS JP domain W56 fixed pulse type 3 RADAR detection

Anirudh Gupta (1):
      xfrm: Fix xfrm sel prefix length validation

Ard Biesheuvel (2):
      acpi/arm64: ignore 5.1 FADTs that are reported as 5.0
      crypto: caam - limit output IV to CBC to work around CTR mode DMA iss=
ue

Arnaldo Carvalho de Melo (1):
      perf evsel: Make perf_evsel__name() accept a NULL argument

Arnd Bergmann (4):
      ipsec: select crypto ciphers for xfrm_algo
      crypto: asymmetric_keys - select CRYPTO_HASH where needed
      mfd: arizona: Fix undefined behavior
      locking/lockdep: Hide unused 'class' variable

Axel Lin (1):
      mfd: hi655x-pmic: Fix missing return value check for devm_regmap_init=
_mmio_clk

Baruch Siach (1):
      net: dsa: mv88e6xxx: wait after reset deactivation

Bastien Nocera (1):
      iio: iio-utils: Fix possible incorrect mask calculation

Bharat Kumar Gogada (1):
      PCI: xilinx-nwl: Fix Multi MSI data programming

Boris Brezillon (1):
      media: v4l2: Test type instead of cfg->type in v4l2_ctrl_new_custom()

Brian King (1):
      bnx2x: Prevent load reordering in tx completion processing

Christian Lamparter (1):
      powerpc/4xx/uic: clear pending interrupt after irq type/pol change

Christoph Hellwig (1):
      9p: pass the correct prototype to read_cache_page

Christoph Paasch (1):
      tcp: Reset bytes_acked and bytes_received when disconnecting

Christophe Leroy (6):
      crypto: talitos - fix skcipher failure due to wrong output IV
      crypto: talitos - properly handle split ICV.
      crypto: talitos - Align SEC1 accesses to 32 bits boundaries.
      lib/scatterlist: Fix mapping iterator when sg->offset is greater than=
 PAGE_SIZE
      powerpc/32s: fix suspend/resume when IBATs 4-7 are used
      tty: serial: cpm_uart - fix init when SMC is relocated

Coly Li (1):
      bcache: check c->gc_thread by IS_ERR_OR_NULL in cache_set_flush()

Cong Wang (3):
      netrom: fix a memory leak in nr_rx_frame()
      netrom: hold sock when setting skb->destructor
      bonding: validate ip header before check IPPROTO_IGMP

Dan Carpenter (2):
      ath6kl: add some bounds checking
      eCryptfs: fix a couple type promotion bugs

Dan Williams (1):
      libnvdimm/pfn: fix fsdax-mode namespace info-block zero-fields

Daniel Jordan (1):
      padata: use smp_mb in padata_reorder to avoid orphaned padata jobs

David Howells (1):
      rxrpc: Fix send on a connected, but unbound socket

David Riley (1):
      drm/virtio: Add memory barriers for capset cache.

David S. Miller (1):
      tua6100: Avoid build warnings.

Denis Efremov (4):
      floppy: fix div-by-zero in setup_format_params
      floppy: fix out-of-bounds read in next_valid_format
      floppy: fix invalid pointer dereference in drive_name
      floppy: fix out-of-bounds read in copy_buffer

Denis Kirjanov (1):
      ipoib: correcly show a VF hardware address

Dexuan Cui (2):
      PCI: hv: Delete the device earlier from hbus->children for hot-remove
      PCI: hv: Fix a use-after-free bug in hv_eject_device_work()

Dmitry Vyukov (1):
      mm/kmemleak.c: fix check for softirq context

Douglas Anderson (1):
      drm/rockchip: Properly adjust to a true clock in adjusted_mode

Eiichi Tsukata (2):
      EDAC: Fix global-out-of-bounds write when setting edac_mc_poll_msec
      tracing/snapshot: Resize spare buffer if size changed

Elena Petrova (2):
      crypto: arm64/sha1-ce - correct digest for empty data in finup
      crypto: arm64/sha2-ce - correct digest for empty data in finup

Emmanuel Grumbach (1):
      iwlwifi: pcie: don't service an interrupt that was masked

Eric Biggers (2):
      crypto: ghash - fix unaligned memory access in ghash_setkey()
      crypto: chacha20poly1305 - fix atomic sleep when using async algorithm

Eric Dumazet (1):
      igmp: fix memory leak in igmpv3_del_delrec()

Eric W. Biederman (1):
      signal/pid_namespace: Fix reboot_pid_ns to use send_sig not force_sig

Ezequiel Garcia (1):
      media: coda: Remove unbalanced and unneeded mutex unlock

Fabio Estevam (1):
      net: fec: Do not use netdev messages too early

Ferdinand Blomqvist (2):
      rslib: Fix decoding of shortened codes
      rslib: Fix handling of of caller provided syndrome

Filipe Manana (1):
      Btrfs: add missing inode version, ctime and mtime updates when punchi=
ng hole

Finn Thain (3):
      scsi: NCR5380: Reduce goto statements in NCR5380_select()
      scsi: NCR5380: Always re-enable reselection interrupt
      scsi: mac_scsi: Increase PIO/PDMA transfer length threshold

Florian Fainelli (1):
      um: Allow building and running on older hosts

Geert Uytterhoeven (3):
      gpiolib: Fix references to gpiod_[gs]et_*value_cansleep() variants
      serial: sh-sci: Terminate TX DMA during buffer flushing
      serial: sh-sci: Fix TX DMA buffer flushing and workqueue races

Grant Hernandez (1):
      Input: gtco - bounds check collection indent level

Greg Kroah-Hartman (1):
      Linux 4.9.187

Guilherme G. Piccoli (1):
      bnx2x: Prevent ptp_task to be rescheduled indefinitely

Hans Verkuil (1):
      media: mc-device.c: don't memset __user pointer contents

Hans de Goede (1):
      x86/sysfb_efi: Add quirks for some devices with swapped width and hei=
ght

Helge Deller (2):
      parisc: Ensure userspace privilege for ptraced processes in regset fu=
nctions
      parisc: Fix kernel panic due invalid values in IAOQ0 or IAOQ1

Hook, Gary (1):
      crypto: ccp - Validate the the error value used to index error messag=
es

Hui Wang (2):
      ALSA: hda/realtek: apply ALC891 headset fixup to one Dell machine
      ALSA: hda - Add a conexant codec entry to let mute led work

Imre Deak (1):
      locking/lockdep: Fix merging of hlocks with non-zero references

Ioana Ciornei (1):
      net: phy: Check against net_device being NULL

J. Bruce Fields (3):
      nfsd: increase DRC cache limit
      nfsd: give out fewer session slots as limit approaches
      nfsd: fix performance-limiting session calculation

Jan Harkes (1):
      coda: pass the host file in vma->vm_file on mmap

Janakarajan Natarajan (2):
      perf/x86/amd/uncore: Rename 'L2' to 'LLC'
      perf/x86/amd/uncore: Get correct number of cores sharing last level c=
ache

Jann Horn (1):
      sched/fair: Don't free p->numa_faults with concurrent readers

Jason Wang (1):
      vhost_net: disable zerocopy by default

Jean-Philippe Brucker (1):
      mm/mmu_notifier: use hlist_add_head_rcu()

Jeremy Sowden (2):
      batman-adv: fix for leaked TVLV handler.
      af_key: fix leaks in key_pol_get_resp and dump_sp.

Johannes Berg (1):
      um: Silence lockdep complaint about mmap_sem

John Hurley (1):
      net: openvswitch: fix csum updates for MPLS actions

Jon Hunter (2):
      arm64: tegra: Update Jetson TX1 GPU regulator timings
      arm64: tegra: Fix AGIC register range

Jorge Ramirez-Ortiz (1):
      tty: serial: msm_serial: avoid system lockup condition

Jose Abreu (2):
      net: stmmac: dwmac1000: Clear unused address entries
      net: stmmac: dwmac4/5: Clear unused address entries

Josua Mayer (1):
      Bluetooth: 6lowpan: search for destination address in all peers

Juergen Gross (1):
      xen: let alloc_xenballooned_pages() fail if not enough memory free

Julian Wiedmann (1):
      s390/qdio: handle PENDING state for QEBSM devices

Jungo Lin (1):
      media: media_device_enum_links32: clean a reserved field

Junxiao Bi (1):
      dm bufio: fix deadlock with loop device

Justin Chen (1):
      net: bcmgenet: use promisc for unsupported filters

Jyri Sarha (1):
      drm/bridge: sii902x: pixel clock unit is 10kHz instead of 1kHz

Kai-Heng Feng (1):
      ALSA: line6: Fix wrong altsetting for LINE6_PODHD500_1

Kangjie Lu (1):
      media: vpss: fix a potential NULL pointer dereference

Kefeng Wang (3):
      media: wl128x: Fix some error handling in fm_v4l2_init_video_device()
      tty/serial: digicolor: Fix digicolor-usart already registered warning
      hpet: Fix division by zero in hpet_time_div()

Kevin Darbyshire-Bryant (1):
      MIPS: fix build on non-linux hosts

Konstantin Taranov (1):
      RDMA/rxe: Fill in wc byte_len with IB_WC_RECV_RDMA_WITH_IMM

Krzysztof Kozlowski (1):
      regulator: s2mps11: Fix buck7 and buck8 wrong voltages

Kyle Meyer (1):
      perf tools: Increase MAX_NR_CPUS and MAX_CACHES

Lee, Chiasheng (1):
      usb: Handle USB3 remote wakeup for LPM enabled devices correctly

Like Xu (1):
      KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed

Linus Torvalds (1):
      access: avoid the RCU grace period for the temporary subjective crede=
ntials

Liu, Changcheng (1):
      RDMA/i40iw: Set queue pair state when being queried

Lorenzo Bianconi (3):
      mt7601u: do not schedule rx_tasklet when the device has been disconne=
cted
      mt7601u: fix possible memory leak when the device is disconnected
      net: neigh: fix multiple neigh timer scheduling

Lubomir Rintel (1):
      media: marvell-ccic: fix DMA s/g desc number calculation

Luke Nowakowski-Krijger (1):
      media: radio-raremono: change devm_k*alloc to k*alloc

Lyude Paul (1):
      drm/nouveau/i2c: Enable i2c pads & busses during preinit

Marek Szyprowski (1):
      clocksource/drivers/exynos_mct: Increase priority over ARM arch timer

Marek Vasut (1):
      PCI: sysfs: Ignore lockdep for remove attribute

Masahiro Yamada (2):
      x86/build: Add 'set -e' to mkcapflags.sh to delete broken capflags.c
      powerpc/boot: add {get, put}_unaligned_be32 to xz_config.h

Mathieu Poirier (1):
      perf cs-etm: Properly set the value of 'old' and 'head' in snapshot m=
ode

Matias Karhumaa (1):
      Bluetooth: Check state in l2cap_disconnect_rsp

Matteo Croce (1):
      ipv4: don't set IPv6 only flags to IPv4 addresses

Mauro S. M. Rodrigues (1):
      ixgbe: Check DDM existence in transceiver before access

Miaoqing Pan (1):
      ath10k: fix PCIE device wake up failed

Michael Neuling (1):
      powerpc/tm: Fix oops on sigreturn on systems without TM

Mika Westerberg (1):
      PCI: Do not poll for PME if the device is in D3cold

Miroslav Lichvar (2):
      ntp: Limit TAI-UTC offset
      drivers/pps/pps.c: clear offset flags in PPS_SETPARAMS ioctl

Nathan Chancellor (2):
      arm64/efi: Mark __efistub_stext_offset as an absolute symbol explicit=
ly
      kbuild: Add -Werror=3Dunknown-warning-option to CLANG_FLAGS

Nathan Huckleberry (1):
      timer_list: Guard procfs specific code

Naveen N. Rao (1):
      recordmcount: Fix spurious mcount entries on powerpc

Nicolas Dichtel (1):
      xfrm: fix sa selector validation

Nikolay Aleksandrov (3):
      net: bridge: mcast: fix stale nsrcs pointer in igmp3/mld2 report hand=
ling
      net: bridge: mcast: fix stale ipv6 hdr pointer when handling v6 query
      net: bridge: stp: don't cache eth dest pointer before skb pull

Numfor Mbiziwo-Tiapo (1):
      perf test mmap-thread-lookup: Initialize variable to suppress memory =
sanitizer warning

Ocean Chen (1):
      f2fs: avoid out-of-range memory access

Oliver Neukum (2):
      media: dvb: usb: fix use after free in dvb_usb_device_exit
      media: cpia2_usb: first wake up, then free in disconnect

Oliver O'Halloran (1):
      powerpc/eeh: Handle hugepages in ioremap space

Pan Bian (1):
      EDAC/sysfs: Fix memory leak when creating a csrow object

Paul Menzel (1):
      nfsd: Fix overflow causing non-working mounts on 1 TB machines

Peter Kosyh (1):
      vrf: make sure skb->data contains ip header to make routing

Peter Ujfalusi (1):
      drm/panel: simple: Fix panel_simple_dsi_probe

Philipp Zabel (2):
      media: coda: fix mpeg2 sequence number handling
      media: coda: increment sequence offset for the last returned frame

Phong Tran (3):
      net: usb: asix: init MAC address buffers
      usb: wusbcore: fix unbalanced get/put cluster_id
      ISDN: hfcsusb: checking idx of ep configuration

Radoslaw Burny (1):
      fs/proc/proc_sysctl.c: fix the default values of i_uid/i_gid on /proc=
/sys inodes.

Rautkoski Kimmo EXT (1):
      serial: 8250: Fix TX interrupt handling condition

Ravi Bangoria (1):
      powerpc/watchpoint: Restore NV GPRs while returning from exception

Robert Hancock (2):
      net: axienet: Fix race condition causing TX hang
      mfd: core: Set fwnode for created devices

Russell King (2):
      gpio: omap: fix lack of irqstatus_raw0 for OMAP4
      gpio: omap: ensure irq is enabled before wakeup

Ryan Kennedy (1):
      usb: pci-quirks: Correct AMD PLL quirk detection

Sam Ravnborg (1):
      sh: prevent warnings when using iounmap

Sean Young (1):
      media: au0828: fix null dereference in error path

Serge Semin (2):
      tty: max310x: Fix invalid baudrate divisors calculator
      tty: serial_core: Set port active bit in uart_port_activate

Shailendra Verma (1):
      media: staging: media: davinci_vpfe: - Fix for memory leak if decoder=
 initialization fails.

Soheil Hassas Yeganeh (1):
      tcp: reset sk_send_head in tcp_write_queue_purge

Srinivas Kandagatla (1):
      regmap: fix bulk writes on paged registers

Stefan Hellermann (1):
      MIPS: ath79: fix ar933x uart parity mode

Steve Longerbeam (1):
      gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM

Surabhi Vishnoi (1):
      ath10k: Do not send probe response template for mesh

Suravee Suthikulpanit (1):
      perf/events/amd/uncore: Fix amd_uncore_llc ID to use pre-defined cpu_=
llc_id

Sven Van Asbroeck (1):
      dmaengine: imx-sdma: fix use-after-free on probe error path

Szymon Janc (1):
      Bluetooth: Add SMP workaround Microsoft Surface Precision Mouse bug

Taehee Yoo (3):
      gtp: fix Illegal context switch in RCU read-side critical section.
      gtp: fix use-after-free in gtp_newlink()
      caif-hsi: fix possible deadlock in cfhsi_exit_module()

Takashi Iwai (2):
      ALSA: seq: Break too long mutex context in the write loop
      sky2: Disable MSI on ASUS P6T

Tejun Heo (2):
      blkcg, writeback: dead memcgs shouldn't contribute to writeback owner=
ship arbitration
      libata: don't request sense data on !ZAC ATA devices

Theodore Ts'o (1):
      ext4: allow directory holes

Thinh Nguyen (1):
      usb: core: hub: Disable hub-initiated U1/U2

Thomas Meyer (1):
      um: Fix FP register size for XSTATE/XSAVE

Thomas Richter (1):
      perf test 6: Fix missing kvm module load for s390

Tim Schumacher (1):
      ath9k: Check for errors when reading SREV register

Tomas Bortoli (1):
      Bluetooth: hci_bcsp: Fix memory leak in rx_skb

Tomi Valkeinen (1):
      drm/bridge: tc358767: read display_props in get_modes()

Trond Myklebust (2):
      NFSv4: Handle the special Linux file open access mode
      NFSv4: Fix open create exclusive when the server reboots

Valdis Kletnieks (1):
      bpf: silence warning messages in core

Vasily Gorbik (1):
      kallsyms: exclude kasan local symbols on s390

Vladis Dronov (1):
      Bluetooth: hci_uart: check for missing tty operations

Waiman Long (1):
      rcu: Force inlining of rcu_read_lock()

Wang Hai (1):
      memstick: Fix error cleanup path of memstick_init

Wen Yang (2):
      crypto: crypto4xx - fix a potential double free in ppc4xx_trng_probe
      pinctrl: rockchip: fix leaked of_node references

Will Deacon (1):
      arm64: compat: Provide definition for COMPAT_SIGMINSTKSZ

Xin Long (1):
      ipv6: check sk sk_type and protocol early in ip_mroute_set/getsockopt

Yan, Zheng (1):
      ceph: hold i_ceph_lock when removing caps for freeing inode

Yang Wei (1):
      nfc: fix potential illegal memory access

Yoshihiro Shimoda (1):
      phy: renesas: rcar-gen2: Fix memory leak at error paths

YueHaibing (1):
      9p/virtio: Add cleanup path in p9_virtio_init

Yuyang Du (1):
      locking/lockdep: Fix lock used or unused stats error

Zhenzhong Duan (1):
      x86/speculation/mds: Apply more accurate check on hypervisor platform

allen yan (1):
      arm64: dts: marvell: Fix A37xx UART0 register size

csonsino (1):
      Bluetooth: validate BLE connection interval updates

morten petersen (1):
      mailbox: handle failed named mailbox channel request


--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1Gr7AACgkQONu9yGCS
aT6JTw/+JzjirhrkPQRBx1V3dyMPXHrQTzOFgMpyM/Y1lDKdMkHAHVGp91WZBLQd
mSvHCahtqhLWrUGDIc7mwnWc+kxPf0gwcVesRoF57mQuMkAhMy7TIPSM5z+s1RKk
Z0cYEQba2TzeLMFYeeiXkwiv5FfKW8lOj2QFBpPFYHeEillL9AGlR/bNO7aS/gOx
x/YzVrY25kMAgThpYqRjKAnfE5fd2frqgN28zPtpA1Bc1QAzg30p6FrNO3cI6Tdd
k+FRddHc0PlkLTJG7zmm6C9Jw3BtK3K/JV11n5QJYgCdFLe93ErpRmIBpQafeneE
xOmgV+6Ixi5do6eeZfqtt7DUGAN/HZbpcOhvqLvdOnr9CRXJ6vVHGOrDpiY70L1s
29Ifx/vw3KjwFAyg3pEAwYgbgrvpFTGyoQN0t99/ande7f6ecclC032tc+0WyD0B
xwx2JPRqtD4pm4ieb66eCTyHt+3Tb34FIXr9o880LVvfOJM4ehZfnE09Y4CVmt2q
DH3hfcWBGk0ib4nXO8507gKIgtG57YJOYHmUh3miWwsih2xtxKhmdUGqv7fZF7R1
OgoA0cMjnkPZFR08hUcnz98l2I6TNZSY5WTqMnvIPJv4kh8ZOnB0YoKSRs95PRh0
cO+jatgZZDK9OPah6dDt8v09bTlAgQusfuRZhZiEg153L1t5Dz0=
=N0gm
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
