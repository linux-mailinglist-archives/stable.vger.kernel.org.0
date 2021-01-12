Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472552F3B0F
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 20:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406189AbhALTr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 14:47:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406947AbhALTr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 14:47:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C62823117;
        Tue, 12 Jan 2021 19:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610480835;
        bh=fAh86nxaz/GyK/lSJJ8eyfi2WXDPUejebvrkM8ZuONw=;
        h=From:To:Cc:Subject:Date:From;
        b=HVjxW3nHBbG4Ou3U/uG9WlN2Yojb5/iVaY1vhRmi7y+qdejkrmzQjR/9ZtBRKOUj7
         Mhi5k1ROzz1EH+DK+M8qJt2CUuqYsA2YnY29mk3SF3s2b7Tci528VH0XOnnNtjgbif
         wyWZG3pSGFUTOgSM+Mh5moJTRUO4zelUPVYZAfYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.89
Date:   Tue, 12 Jan 2021 20:48:23 +0100
Message-Id: <16104809036124@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.89 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    4 
 arch/powerpc/kernel/vmlinux.lds.S                  |    2 
 arch/x86/kernel/cpu/mtrr/generic.c                 |    6 -
 arch/x86/kvm/mmu.h                                 |    2 
 arch/x86/mm/pgtable.c                              |    2 
 crypto/asymmetric_keys/asym_tpm.c                  |    2 
 crypto/ecdh.c                                      |    3 
 drivers/atm/idt77252.c                             |    2 
 drivers/base/core.c                                |    2 
 drivers/bluetooth/hci_h5.c                         |    8 -
 drivers/dma-buf/dma-buf.c                          |   21 +++
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |    4 
 drivers/ide/ide-atapi.c                            |    1 
 drivers/ide/ide-io.c                               |    5 
 drivers/net/dsa/lantiq_gswip.c                     |   27 +---
 drivers/net/ethernet/broadcom/bcmsysport.c         |    1 
 drivers/net/ethernet/ethoc.c                       |    3 
 drivers/net/ethernet/freescale/ucc_geth.c          |    3 
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |    4 
 drivers/net/ethernet/ibm/ibmvnic.c                 |    3 
 drivers/net/ethernet/intel/i40e/i40e.h             |    3 
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   10 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    4 
 drivers/net/ethernet/intel/iavf/iavf_main.c        |    4 
 drivers/net/ethernet/marvell/mvneta.c              |    2 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   13 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     |   38 ++++++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h     |    2 
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |    2 
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |    5 
 drivers/net/ethernet/realtek/r8169_main.c          |    6 -
 drivers/net/ethernet/ti/cpts.c                     |    2 
 drivers/net/tun.c                                  |    2 
 drivers/net/usb/cdc_ncm.c                          |    3 
 drivers/net/usb/qmi_wwan.c                         |    1 
 drivers/net/virtio_net.c                           |   12 +-
 drivers/net/wan/hdlc_ppp.c                         |    7 +
 drivers/scsi/scsi_transport_spi.c                  |   27 +++-
 drivers/scsi/ufs/ufshcd-pci.c                      |   34 +++++-
 drivers/scsi/ufs/ufshcd.c                          |    2 
 drivers/staging/mt7621-dma/mtk-hsdma.c             |    4 
 drivers/target/target_core_xcopy.c                 |  119 ++++++++++++---------
 drivers/target/target_core_xcopy.h                 |    1 
 drivers/usb/chipidea/ci_hdrc_imx.c                 |    6 -
 drivers/usb/class/cdc-acm.c                        |    4 
 drivers/usb/class/cdc-wdm.c                        |   16 ++
 drivers/usb/class/usblp.c                          |   21 +++
 drivers/usb/dwc3/core.h                            |    1 
 drivers/usb/dwc3/ulpi.c                            |    2 
 drivers/usb/gadget/Kconfig                         |    2 
 drivers/usb/gadget/composite.c                     |   10 +
 drivers/usb/gadget/configfs.c                      |   19 ++-
 drivers/usb/gadget/function/f_printer.c            |    1 
 drivers/usb/gadget/function/f_uac2.c               |   69 +++++++++---
 drivers/usb/gadget/function/u_ether.c              |    9 -
 drivers/usb/gadget/legacy/acm_ms.c                 |    4 
 drivers/usb/host/xhci.c                            |   24 ++--
 drivers/usb/misc/yurex.c                           |    3 
 drivers/usb/serial/iuu_phoenix.c                   |   20 ++-
 drivers/usb/serial/keyspan_pda.c                   |    2 
 drivers/usb/serial/option.c                        |    3 
 drivers/usb/storage/unusual_uas.h                  |    7 +
 drivers/usb/usbip/vhci_hcd.c                       |    2 
 drivers/vhost/net.c                                |    6 -
 drivers/video/fbdev/hyperv_fb.c                    |    6 -
 fs/btrfs/send.c                                    |   49 +++++---
 fs/proc/generic.c                                  |   55 ++++++---
 fs/proc/internal.h                                 |    7 +
 fs/proc/proc_net.c                                 |   16 --
 include/linux/proc_fs.h                            |    8 +
 include/net/red.h                                  |    4 
 kernel/workqueue.c                                 |   13 +-
 lib/genalloc.c                                     |   25 ++--
 net/core/net-sysfs.c                               |   65 +++++++++--
 net/ipv4/fib_frontend.c                            |    2 
 net/ipv4/gre_demux.c                               |    2 
 net/ipv4/netfilter/arp_tables.c                    |    2 
 net/ipv4/netfilter/ip_tables.c                     |    2 
 net/ipv6/netfilter/ip6_tables.c                    |    2 
 net/ncsi/ncsi-rsp.c                                |    2 
 net/netfilter/ipset/ip_set_hash_gen.h              |   20 ---
 net/netfilter/nft_dynset.c                         |    6 -
 net/netfilter/xt_RATEEST.c                         |    3 
 net/sched/sch_choke.c                              |    2 
 net/sched/sch_gred.c                               |    2 
 net/sched/sch_red.c                                |    2 
 net/sched/sch_sfq.c                                |    2 
 net/sched/sch_taprio.c                             |    2 
 scripts/depmod.sh                                  |    2 
 sound/pci/hda/hda_intel.c                          |    2 
 sound/pci/hda/patch_conexant.c                     |    1 
 sound/pci/hda/patch_realtek.c                      |    9 +
 sound/pci/hda/patch_via.c                          |   13 ++
 sound/usb/midi.c                                   |    4 
 virt/kvm/kvm_main.c                                |    3 
 95 files changed, 658 insertions(+), 314 deletions(-)

Adrian Hunter (1):
      scsi: ufs-pci: Ensure UFS device is in PowerDown mode for suspend-to-disk ->poweroff()

Alexey Dobriyan (2):
      proc: change ->nlink under proc_subdir_lock
      proc: fix lookup in /proc/net subdirectories after setns(2)

Antoine Tenart (4):
      net-sysfs: take the rtnl lock when storing xps_cpus
      net-sysfs: take the rtnl lock when accessing xps_cpus_map and num_tc
      net-sysfs: take the rtnl lock when storing xps_rxqs
      net-sysfs: take the rtnl lock when accessing xps_rxqs_map and num_tc

Ard Biesheuvel (1):
      crypto: ecdh - avoid buffer overflow in ecdh_set_secret()

Arnd Bergmann (1):
      usb: gadget: select CONFIG_CRC32

Bard Liao (1):
      Revert "device property: Keep secondary firmware node secondary by type"

Bart Van Assche (2):
      scsi: ide: Do not set the RQF_PREEMPT flag for sense requests
      scsi: scsi_transport_spi: Set RQF_PM for domain validation commands

Bean Huo (1):
      scsi: ufs: Fix wrong print message in dev_err()

Bjørn Mork (2):
      net: usb: qmi_wwan: add Quectel EM160R-GL
      USB: serial: option: add Quectel EM160R-GL

Chandana Kishori Chiluveru (1):
      usb: gadget: configfs: Preserve function ordering after bind failure

Charan Teja Reddy (1):
      dmabuf: fix use-after-free of dmabuf's file->f_inode

Christophe JAILLET (1):
      staging: mt7621-dma: Fix a resource leak in an error handling path

Cong Wang (1):
      erspan: fix version 1 check in gre_parse_header()

Dan Carpenter (1):
      atm: idt77252: call pci_disable_device() on error path

Dan Williams (1):
      x86/mm: Fix leak of pmd ptlock

Daniel Palmer (1):
      USB: serial: option: add LongSung M5710 module support

David Disseldorp (1):
      scsi: target: Fix XCOPY NAA identifier lookup

Davide Caratti (1):
      net/sched: sch_taprio: ensure to reset/destroy all child qdiscs

Dexuan Cui (1):
      video: hyperv_fb: Fix the mmap() regression for v5.4.y and older

Dinghao Liu (2):
      net: ethernet: mvneta: Fix error handling in mvneta_probe
      net: ethernet: Fix memleak in ethoc_probe

Dominique Martinet (1):
      kbuild: don't hardcode depmod path

Eddie Hung (1):
      usb: gadget: configfs: Fix use-after-free issue with udc_name

Filipe Manana (1):
      btrfs: send: fix wrong file path when there is an inode with a pending rmdir

Florian Fainelli (1):
      net: systemport: set dev->max_mtu to UMAC_MAX_MTU_SIZE

Florian Westphal (1):
      netfilter: xt_RATEEST: reject non-null terminated string from userspace

Greg Kroah-Hartman (2):
      crypto: asym_tpm: correct zero out potential secrets
      Linux 5.4.89

Grygorii Strashko (1):
      net: ethernet: ti: cpts: fix ethtool output when no ptp_clock registered

Guillaume Nault (1):
      ipv4: Ignore ECN bits for fib lookups in fib_compute_spec_dst()

Hans de Goede (1):
      Bluetooth: revert: hci_h5: close serdev device and free hu in h5_close

Heiner Kallweit (1):
      r8169: work around power-saving bug on some chip versions

Huang Shijie (1):
      lib/genalloc: fix the overflow when size is too big

Jakub Kicinski (1):
      iavf: fix double-release of rtnl_lock

Jeff Dike (1):
      virtio_net: Fix recursive call to cpus_read_lock()

Jerome Brunet (1):
      usb: gadget: f_uac2: reset wMaxPacketSize

Johan Hovold (4):
      USB: serial: iuu_phoenix: fix DMA from stack
      USB: yurex: fix control-URB timeout handling
      USB: usblp: fix DMA to stack
      USB: serial: keyspan_pda: remove unused variable

John Wang (1):
      net/ncsi: Use real net-device for response handler

Kai-Heng Feng (1):
      ALSA: hda/realtek: Enable mute and micmute LED on HP EliteBook 850 G7

Kailang Yang (1):
      ALSA: hda/realtek - Fix speaker volume control on Lenovo C940

Lai Jiangshan (1):
      kvm: check tlbs_dirty directly

Lijun Pan (1):
      ibmvnic: continue fatal error reset after passive init

Linus Torvalds (1):
      depmod: handle the case of /sbin/depmod without /sbin in PATH

Manish Chopra (1):
      qede: fix offload for IPIP tunnel packets

Manish Narani (1):
      usb: gadget: u_ether: Fix MTU size mismatch with RX packet size

Martin Blumenstingl (2):
      net: dsa: lantiq_gswip: Enable GSWIP_MII_CFG_EN also for internal PHYs
      net: dsa: lantiq_gswip: Fix GSWIP_MII_CFG(p) register access

Matthew Auld (1):
      drm/i915: clear the gpu reloc batch

Michael Grzeschik (1):
      USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set

Nathan Chancellor (1):
      powerpc: Handle .text.{hot,unlikely}.* in linker script

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: report EOPNOTSUPP on missing set feature

Paolo Bonzini (1):
      KVM: x86: fix shift out of bounds reported by UBSAN

PeiSen Hou (1):
      ALSA: hda/realtek: Add two "Intel Reference board" SSID in the ALC256.

Randy Dunlap (2):
      net: sched: prevent invalid Scell_log shift count
      usb: usbip: vhci_hcd: protect shift size

Rasmus Villemoes (2):
      ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()
      ethernet: ucc_geth: set dev->max_mtu to 1518

Roland Dreier (1):
      CDC-NCM: remove "connected" log message

Sean Young (1):
      USB: cdc-acm: blacklist another IR Droid device

Serge Semin (1):
      usb: dwc3: ulpi: Use VStsDone to detect PHY regs access completion

Shannon Nelson (1):
      ionic: account for vlan tag len in rx buffer len

Sriharsha Allenki (1):
      usb: gadget: Fix spinlock lockup on usb_function_deactivate

Stefan Chulski (4):
      net: mvpp2: Add TCAM entry to drop flow control pause frames
      net: mvpp2: prs: fix PPPoE with ipv6 packet parse
      net: mvpp2: Fix GoP port 3 Networking Complex Control configurations
      net: mvpp2: fix pkt coalescing int-threshold configuration

Subash Abhinov Kasiviswanathan (1):
      netfilter: x_tables: Update remaining dereference to RCU

Sylwester Dziedziuch (1):
      i40e: Fix Error I40E_AQ_RC_EINVAL when removing VFs

Takashi Iwai (2):
      ALSA: usb-audio: Fix UBSAN warnings for MIDI jacks
      ALSA: hda/via: Fix runtime PM for Clevo W35xSS

Tetsuo Handa (1):
      USB: cdc-wdm: Fix use after free in service_outstanding_interrupt().

Thinh Nguyen (1):
      usb: uas: Add PNY USB Portable SSD to unusual_uas

Vasily Averin (1):
      netfilter: ipset: fix shift-out-of-bounds in htable_bits()

Xie He (1):
      net: hdlc_ppp: Fix issues when mod_timer is called while timer is running

Yang Yingliang (1):
      USB: gadget: legacy: fix return error code in acm_ms_bind()

Ying-Tsun Huang (1):
      x86/mtrr: Correct the range check before performing MTRR type lookups

Yu Kuai (1):
      usb: chipidea: ci_hdrc_imx: add missing put_device() call in usbmisc_get_init_data()

Yunfeng Ye (1):
      workqueue: Kick a worker based on the actual activation of delayed works

Yunjian Wang (3):
      tun: fix return value when the number of iovs exceeds MAX_SKB_FRAGS
      net: hns: fix return value check in __lb_other_process()
      vhost_net: fix ubuf refcount incorrectly when sendmsg fails

Zqiang (1):
      usb: gadget: function: printer: Fix a memory leak for interface descriptor

bo liu (1):
      ALSA: hda/conexant: add a new hda codec CX11970

taehyun.cho (1):
      usb: gadget: enable super speed plus

