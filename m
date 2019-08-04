Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D53980A55
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 12:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfHDKMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 06:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfHDKMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Aug 2019 06:12:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AFBE2075C;
        Sun,  4 Aug 2019 10:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564913566;
        bh=GoUWdvN9nytueDnIceNw2LWMG5RBCPUE1Z9/SWVoY2s=;
        h=Date:From:To:Cc:Subject:From;
        b=vbj+VkfEbM/5SOAqiAZtsw51rTAPtsPSq/UebnQE948ROgagqxS1QI34G+rIvvA0a
         YzeHSA6DnmRrY9cgeW13IFoOb3i28b3pQWqMai65kFo+3uIHwcO+tJKoeVrJQVyISm
         JKw1K9EYAcleUuVHqyobG0cOqFvySHAKU4ZAe2Ws=
Date:   Sun, 4 Aug 2019 12:12:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.187
Message-ID: <20190804101244.GA17898@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.187 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 arch/arm64/crypto/sha1-ce-glue.c                     |    2 
 arch/arm64/crypto/sha2-ce-glue.c                     |    2 
 arch/arm64/kernel/acpi.c                             |   10 
 arch/mips/boot/compressed/Makefile                   |    2 
 arch/mips/boot/compressed/calc_vmlinuz_load_addr.c   |    2 
 arch/mips/include/asm/mach-ath79/ar933x_uart.h       |    4 
 arch/parisc/kernel/ptrace.c                          |   28 
 arch/powerpc/kernel/eeh.c                            |   15 
 arch/powerpc/kernel/exceptions-64s.S                 |    9 
 arch/powerpc/kernel/pci_of_scan.c                    |    2 
 arch/powerpc/kernel/signal_32.c                      |    3 
 arch/powerpc/kernel/signal_64.c                      |    5 
 arch/powerpc/kernel/swsusp_32.S                      |   73 
 arch/powerpc/platforms/powermac/sleep.S              |   68 
 arch/powerpc/sysdev/uic.c                            |    1 
 arch/sh/include/asm/io.h                             |    6 
 arch/um/include/asm/mmu_context.h                    |    2 
 arch/x86/kernel/cpu/bugs.c                           |    2 
 arch/x86/kernel/cpu/mkcapflags.sh                    |    2 
 arch/x86/kernel/sysfb_efi.c                          |   46 
 arch/x86/kvm/pmu.c                                   |    4 
 block/compat_ioctl.c                                 |  340 ----
 crypto/ghash-generic.c                               |    8 
 drivers/base/regmap/regmap.c                         |    2 
 drivers/block/floppy.c                               |  362 ++++
 drivers/bluetooth/hci_ath.c                          |    3 
 drivers/bluetooth/hci_bcm.c                          |    3 
 drivers/bluetooth/hci_bcsp.c                         |    5 
 drivers/bluetooth/hci_intel.c                        |    3 
 drivers/bluetooth/hci_ldisc.c                        |    9 
 drivers/bluetooth/hci_uart.h                         |    1 
 drivers/char/hpet.c                                  |    3 
 drivers/crypto/talitos.c                             |    4 
 drivers/dma/imx-sdma.c                               |   48 
 drivers/edac/edac_mc_sysfs.c                         |   24 
 drivers/edac/edac_module.h                           |    2 
 drivers/gpio/gpio-omap.c                             |   17 
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c       |   20 
 drivers/gpu/drm/panel/panel-simple.c                 |    9 
 drivers/gpu/drm/virtio/virtgpu_ioctl.c               |    3 
 drivers/gpu/drm/virtio/virtgpu_vq.c                  |    2 
 drivers/gpu/ipu-v3/ipu-ic.c                          |    2 
 drivers/hwtracing/intel_th/msu.c                     |    2 
 drivers/input/tablet/gtco.c                          |   20 
 drivers/isdn/hardware/mISDN/hfcsusb.c                |    3 
 drivers/mailbox/mailbox.c                            |    6 
 drivers/md/bcache/super.c                            |    2 
 drivers/md/dm-bufio.c                                |    4 
 drivers/media/dvb-frontends/tua6100.c                |   22 
 drivers/media/i2c/Makefile                           |    2 
 drivers/media/i2c/adv7511-v4l2.c                     | 1600 +++++++++++++++++++
 drivers/media/i2c/adv7511.c                          | 1595 ------------------
 drivers/media/platform/coda/coda-bit.c               |    9 
 drivers/media/platform/davinci/vpss.c                |    5 
 drivers/media/platform/marvell-ccic/mcam-core.c      |    5 
 drivers/media/radio/radio-raremono.c                 |   30 
 drivers/media/radio/wl128x/fmdrv_v4l2.c              |    3 
 drivers/media/usb/cpia2/cpia2_usb.c                  |    3 
 drivers/media/usb/dvb-usb/dvb-usb-init.c             |    7 
 drivers/media/v4l2-core/v4l2-ctrls.c                 |    9 
 drivers/memstick/core/memstick.c                     |   13 
 drivers/mfd/arizona-core.c                           |    2 
 drivers/mfd/mfd-core.c                               |    1 
 drivers/net/bonding/bond_main.c                      |   37 
 drivers/net/caif/caif_hsi.c                          |    2 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c      |    3 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c       |   57 
 drivers/net/ethernet/freescale/fec_main.c            |    6 
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c     |    3 
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h         |    1 
 drivers/net/ethernet/marvell/sky2.c                  |    7 
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c |    6 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c    |   20 
 drivers/net/phy/phy_device.c                         |    6 
 drivers/net/wireless/ath/ath10k/hw.c                 |    2 
 drivers/net/wireless/ath/ath10k/mac.c                |    4 
 drivers/net/wireless/ath/ath6kl/wmi.c                |   10 
 drivers/net/wireless/ath/ath9k/hw.c                  |   32 
 drivers/net/wireless/ath/dfs_pattern_detector.c      |    2 
 drivers/net/wireless/mediatek/mt7601u/dma.c          |   54 
 drivers/net/wireless/mediatek/mt7601u/tx.c           |    4 
 drivers/pci/pci-sysfs.c                              |    2 
 drivers/pci/pci.c                                    |    7 
 drivers/phy/phy-rcar-gen2.c                          |    2 
 drivers/pinctrl/pinctrl-rockchip.c                   |    1 
 drivers/pps/pps.c                                    |    8 
 drivers/regulator/s2mps11.c                          |    4 
 drivers/s390/cio/qdio_main.c                         |    1 
 drivers/staging/media/davinci_vpfe/vpfe_video.c      |    3 
 drivers/tty/serial/cpm_uart/cpm_uart_core.c          |   17 
 drivers/tty/serial/digicolor-usart.c                 |    6 
 drivers/tty/serial/max310x.c                         |   51 
 drivers/tty/serial/msm_serial.c                      |    4 
 drivers/tty/serial/sh-sci.c                          |   22 
 drivers/usb/core/hub.c                               |   35 
 drivers/usb/gadget/function/f_fs.c                   |    6 
 drivers/usb/host/hwa-hc.c                            |    2 
 drivers/usb/host/pci-quirks.c                        |   31 
 drivers/vhost/net.c                                  |    2 
 fs/9p/vfs_addr.c                                     |    6 
 fs/ceph/caps.c                                       |    7 
 fs/coda/file.c                                       |   69 
 fs/ecryptfs/crypto.c                                 |   12 
 fs/exec.c                                            |    2 
 fs/f2fs/segment.c                                    |    5 
 fs/nfs/inode.c                                       |    1 
 fs/nfs/nfs4file.c                                    |    2 
 fs/nfs/nfs4proc.c                                    |   41 
 fs/nfsd/nfs4state.c                                  |   11 
 fs/nfsd/nfssvc.c                                     |    2 
 fs/open.c                                            |   19 
 include/linux/cred.h                                 |    7 
 include/linux/elevator.h                             |    2 
 include/linux/rcupdate.h                             |    2 
 include/linux/sched.h                                |    4 
 include/net/tcp.h                                    |   11 
 kernel/bpf/Makefile                                  |    1 
 kernel/cred.c                                        |   21 
 kernel/fork.c                                        |    2 
 kernel/locking/lockdep.c                             |   18 
 kernel/locking/lockdep_proc.c                        |    8 
 kernel/padata.c                                      |   12 
 kernel/pid_namespace.c                               |    2 
 kernel/sched/fair.c                                  |   24 
 kernel/time/ntp.c                                    |    4 
 kernel/time/timer_list.c                             |   36 
 kernel/trace/trace.c                                 |   12 
 lib/reed_solomon/decode_rs.c                         |   18 
 lib/scatterlist.c                                    |    9 
 mm/kmemleak.c                                        |    2 
 mm/mmu_notifier.c                                    |    2 
 mm/vmstat.c                                          |   80 
 net/9p/trans_virtio.c                                |    8 
 net/batman-adv/translation-table.c                   |    2 
 net/bluetooth/6lowpan.c                              |   14 
 net/bluetooth/hci_event.c                            |    5 
 net/bluetooth/l2cap_core.c                           |   15 
 net/bluetooth/smp.c                                  |   13 
 net/bridge/br_multicast.c                            |   32 
 net/bridge/br_stp_bpdu.c                             |    3 
 net/core/neighbour.c                                 |    2 
 net/ipv4/devinet.c                                   |    8 
 net/ipv4/tcp.c                                       |    2 
 net/ipv6/ip6mr.c                                     |   11 
 net/key/af_key.c                                     |    8 
 net/netrom/af_netrom.c                               |    4 
 net/nfc/nci/data.c                                   |    2 
 net/xfrm/xfrm_user.c                                 |   19 
 scripts/kallsyms.c                                   |    3 
 scripts/recordmcount.h                               |    3 
 sound/core/seq/seq_clientmgr.c                       |   11 
 sound/pci/hda/patch_conexant.c                       |    1 
 sound/usb/line6/podhd.c                              |    2 
 tools/iio/iio_utils.c                                |    4 
 tools/perf/tests/mmap-thread-lookup.c                |    2 
 tools/perf/tests/parse-events.c                      |   27 
 tools/perf/util/evsel.c                              |    8 
 tools/power/cpupower/utils/cpufreq-set.c             |    2 
 159 files changed, 3245 insertions(+), 2383 deletions(-)

Abhishek Goel (1):
      cpupower : frequency-set -r option misses the last cpu in related cpu list

Al Viro (1):
      take floppy compat ioctls to sodding floppy.c

Alexander Shishkin (1):
      intel_th: msu: Fix single mode with disabled IOMMU

Alexey Kardashevskiy (1):
      powerpc/pci/of: Fix OF flags parsing for 64bit BARs

Anders Roxell (1):
      media: i2c: fix warning same module names

Andrzej Pietrasiewicz (1):
      usb: gadget: Zero ffs_io_data

Anilkumar Kolli (1):
      ath: DFS JP domain W56 fixed pulse type 3 RADAR detection

Anirudh Gupta (1):
      xfrm: Fix xfrm sel prefix length validation

Ard Biesheuvel (1):
      acpi/arm64: ignore 5.1 FADTs that are reported as 5.0

Arnaldo Carvalho de Melo (1):
      perf evsel: Make perf_evsel__name() accept a NULL argument

Arnd Bergmann (2):
      mfd: arizona: Fix undefined behavior
      locking/lockdep: Hide unused 'class' variable

Bastien Nocera (1):
      iio: iio-utils: Fix possible incorrect mask calculation

Boris Brezillon (1):
      media: v4l2: Test type instead of cfg->type in v4l2_ctrl_new_custom()

Brian King (1):
      bnx2x: Prevent load reordering in tx completion processing

Christian Lamparter (1):
      powerpc/4xx/uic: clear pending interrupt after irq type/pol change

Christoph Hellwig (1):
      9p: pass the correct prototype to read_cache_page

Christoph Lameter (1):
      vmstat: Remove BUG_ON from vmstat_update

Christoph Paasch (1):
      tcp: Reset bytes_acked and bytes_received when disconnecting

Christophe Leroy (4):
      crypto: talitos - fix skcipher failure due to wrong output IV
      lib/scatterlist: Fix mapping iterator when sg->offset is greater than PAGE_SIZE
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

Daniel Jordan (1):
      padata: use smp_mb in padata_reorder to avoid orphaned padata jobs

David Riley (1):
      drm/virtio: Add memory barriers for capset cache.

David S. Miller (1):
      tua6100: Avoid build warnings.

Denis Efremov (4):
      floppy: fix div-by-zero in setup_format_params
      floppy: fix out-of-bounds read in next_valid_format
      floppy: fix invalid pointer dereference in drive_name
      floppy: fix out-of-bounds read in copy_buffer

Dmitry Vyukov (1):
      mm/kmemleak.c: fix check for softirq context

Eiichi Tsukata (2):
      EDAC: Fix global-out-of-bounds write when setting edac_mc_poll_msec
      tracing/snapshot: Resize spare buffer if size changed

Elena Petrova (2):
      crypto: arm64/sha1-ce - correct digest for empty data in finup
      crypto: arm64/sha2-ce - correct digest for empty data in finup

Eric Biggers (2):
      crypto: ghash - fix unaligned memory access in ghash_setkey()
      elevator: fix truncation of icq_cache_name

Eric W. Biederman (1):
      signal/pid_namespace: Fix reboot_pid_ns to use send_sig not force_sig

Ezequiel Garcia (1):
      media: coda: Remove unbalanced and unneeded mutex unlock

Fabio Estevam (1):
      net: fec: Do not use netdev messages too early

Ferdinand Blomqvist (2):
      rslib: Fix decoding of shortened codes
      rslib: Fix handling of of caller provided syndrome

Geert Uytterhoeven (1):
      serial: sh-sci: Fix TX DMA buffer flushing and workqueue races

Grant Hernandez (1):
      Input: gtco - bounds check collection indent level

Greg Kroah-Hartman (1):
      Linux 4.4.187

Hans de Goede (1):
      x86/sysfb_efi: Add quirks for some devices with swapped width and height

Helge Deller (1):
      parisc: Fix kernel panic due invalid values in IAOQ0 or IAOQ1

Hui Wang (1):
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

Jorge Ramirez-Ortiz (1):
      tty: serial: msm_serial: avoid system lockup condition

Jose Abreu (1):
      net: stmmac: dwmac1000: Clear unused address entries

Josua Mayer (1):
      Bluetooth: 6lowpan: search for destination address in all peers

Julian Wiedmann (1):
      s390/qdio: handle PENDING state for QEBSM devices

Junxiao Bi (1):
      dm bufio: fix deadlock with loop device

Justin Chen (1):
      net: bcmgenet: use promisc for unsupported filters

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

Krzysztof Kozlowski (1):
      regulator: s2mps11: Fix buck7 and buck8 wrong voltages

Lee, Chiasheng (1):
      usb: Handle USB3 remote wakeup for LPM enabled devices correctly

Like Xu (1):
      KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed

Linus Torvalds (1):
      access: avoid the RCU grace period for the temporary subjective credentials

Lorenzo Bianconi (3):
      mt7601u: do not schedule rx_tasklet when the device has been disconnected
      mt7601u: fix possible memory leak when the device is disconnected
      net: neigh: fix multiple neigh timer scheduling

Lubomir Rintel (1):
      media: marvell-ccic: fix DMA s/g desc number calculation

Luke Nowakowski-Krijger (1):
      media: radio-raremono: change devm_k*alloc to k*alloc

Lyude Paul (1):
      drm/nouveau/i2c: Enable i2c pads & busses during preinit

Marek Vasut (1):
      PCI: sysfs: Ignore lockdep for remove attribute

Masahiro Yamada (1):
      x86/build: Add 'set -e' to mkcapflags.sh to delete broken capflags.c

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

Michal Hocko (1):
      mm, vmstat: make quiet_vmstat lighter

Mika Westerberg (1):
      PCI: Do not poll for PME if the device is in D3cold

Miroslav Lichvar (2):
      ntp: Limit TAI-UTC offset
      drivers/pps/pps.c: clear offset flags in PPS_SETPARAMS ioctl

Nathan Huckleberry (1):
      timer_list: Guard procfs specific code

Naveen N. Rao (1):
      recordmcount: Fix spurious mcount entries on powerpc

Nicolas Dichtel (1):
      xfrm: fix sa selector validation

Nikolay Aleksandrov (3):
      net: bridge: mcast: fix stale nsrcs pointer in igmp3/mld2 report handling
      net: bridge: mcast: fix stale ipv6 hdr pointer when handling v6 query
      net: bridge: stp: don't cache eth dest pointer before skb pull

Numfor Mbiziwo-Tiapo (1):
      perf test mmap-thread-lookup: Initialize variable to suppress memory sanitizer warning

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

Peter Ujfalusi (1):
      drm/panel: simple: Fix panel_simple_dsi_probe

Philipp Zabel (2):
      media: coda: fix mpeg2 sequence number handling
      media: coda: increment sequence offset for the last returned frame

Phong Tran (2):
      usb: wusbcore: fix unbalanced get/put cluster_id
      ISDN: hfcsusb: checking idx of ep configuration

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

Serge Semin (1):
      tty: max310x: Fix invalid baudrate divisors calculator

Shailendra Verma (1):
      media: staging: media: davinci_vpfe: - Fix for memory leak if decoder initialization fails.

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

Sven Van Asbroeck (1):
      dmaengine: imx-sdma: fix use-after-free on probe error path

Szymon Janc (1):
      Bluetooth: Add SMP workaround Microsoft Surface Precision Mouse bug

Taehee Yoo (1):
      caif-hsi: fix possible deadlock in cfhsi_exit_module()

Takashi Iwai (2):
      ALSA: seq: Break too long mutex context in the write loop
      sky2: Disable MSI on ASUS P6T

Thinh Nguyen (1):
      usb: core: hub: Disable hub-initiated U1/U2

Thomas Richter (1):
      perf test 6: Fix missing kvm module load for s390

Tim Schumacher (1):
      ath9k: Check for errors when reading SREV register

Tomas Bortoli (1):
      Bluetooth: hci_bcsp: Fix memory leak in rx_skb

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

Wen Yang (1):
      pinctrl: rockchip: fix leaked of_node references

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

csonsino (1):
      Bluetooth: validate BLE connection interval updates

morten petersen (1):
      mailbox: handle failed named mailbox channel request

