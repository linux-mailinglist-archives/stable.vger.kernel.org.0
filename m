Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A599C15FB9C
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 01:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbgBOAng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 19:43:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727567AbgBOAng (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 19:43:36 -0500
Received: from localhost (unknown [38.98.37.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E43E207FF;
        Sat, 15 Feb 2020 00:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581727415;
        bh=l8EIgfMIQB2POoW1Uyf5xATQl1HGemk6JNL7VNMQEyw=;
        h=Date:From:To:Cc:Subject:From;
        b=gEyEFdj2M4QUDN+/wBO+Hx63Gl6YnLY6TeSDKTkteu5E+7xDUZqJPffnzd/9Pgan/
         6RvCXZ/ztvUBIhSEGxQ12AvQtUlHBr1BIflNiyxkb2YiUIqU8Iat4PlaVtyH+WL904
         a0J4KwcbtWL7k85rd3xa8YZHYGgIjLibtYWMgxNM=
Date:   Fri, 14 Feb 2020 19:40:23 -0500
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.214
Message-ID: <20200215004023.GA28140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.214 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arc/boot/dts/axs10x_mb.dtsi                   |    1 
 arch/arm/boot/dts/sama5d3.dtsi                     |   28 
 arch/arm/boot/dts/sama5d3_can.dtsi                 |    4 
 arch/arm/boot/dts/sama5d3_tcb1.dtsi                |    1 
 arch/arm/boot/dts/sama5d3_uart.dtsi                |    4 
 arch/arm/mach-tegra/sleep-tegra30.S                |   11 
 arch/powerpc/Kconfig                               |    1 
 arch/powerpc/boot/4xx.c                            |    2 
 arch/powerpc/kvm/book3s_hv.c                       |    4 
 arch/powerpc/kvm/book3s_pr.c                       |    4 
 arch/powerpc/platforms/pseries/hotplug-memory.c    |    4 
 arch/powerpc/platforms/pseries/iommu.c             |   43 
 arch/sparc/include/uapi/asm/ipcbuf.h               |   22 
 arch/x86/kernel/cpu/tsx.c                          |   13 
 arch/x86/kvm/emulate.c                             |   28 
 arch/x86/kvm/hyperv.c                              |   11 
 arch/x86/kvm/i8259.c                               |   41 
 arch/x86/kvm/ioapic.c                              |   15 
 arch/x86/kvm/lapic.c                               |   13 
 arch/x86/kvm/mtrr.c                                |    9 
 arch/x86/kvm/pmu.h                                 |   18 
 arch/x86/kvm/pmu_intel.c                           |   24 
 arch/x86/kvm/vmx.c                                 |    4 
 arch/x86/kvm/vmx/vmx.c                             | 8033 +++++++++++++++++++++
 arch/x86/kvm/x86.c                                 |   23 
 crypto/algapi.c                                    |   22 
 crypto/api.c                                       |    3 
 crypto/internal.h                                  |    1 
 crypto/pcrypt.c                                    |    1 
 drivers/crypto/picoxcell_crypto.c                  |   15 
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c     |    8 
 drivers/md/dm.c                                    |    9 
 drivers/md/persistent-data/dm-space-map-common.c   |   27 
 drivers/md/persistent-data/dm-space-map-common.h   |    2 
 drivers/md/persistent-data/dm-space-map-disk.c     |    6 
 drivers/md/persistent-data/dm-space-map-metadata.c |    5 
 drivers/media/rc/iguanair.c                        |    2 
 drivers/media/usb/uvc/uvc_driver.c                 |   12 
 drivers/mfd/da9062-core.c                          |    2 
 drivers/mfd/dln2.c                                 |   13 
 drivers/mfd/rn5t618.c                              |    1 
 drivers/mmc/host/mmc_spi.c                         |   11 
 drivers/net/bonding/bond_alb.c                     |   44 
 drivers/net/ethernet/broadcom/bcmsysport.c         |    3 
 drivers/net/ethernet/dec/tulip/dmfe.c              |    7 
 drivers/net/ethernet/dec/tulip/uli526x.c           |    4 
 drivers/net/ethernet/smsc/smc911x.c                |    2 
 drivers/net/ppp/ppp_async.c                        |   18 
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    1 
 drivers/net/wireless/libertas/cfg.c                |    2 
 drivers/net/wireless/mwifiex/scan.c                |    7 
 drivers/net/wireless/mwifiex/sta_ioctl.c           |    1 
 drivers/net/wireless/mwifiex/wmm.c                 |    4 
 drivers/nfc/pn544/pn544.c                          |    2 
 drivers/of/Kconfig                                 |    4 
 drivers/of/address.c                               |    6 
 drivers/pci/host/pci-keystone-dw.c                 |    2 
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c               |    4 
 drivers/power/ltc2941-battery-gauge.c              |    2 
 drivers/rtc/rtc-hym8563.c                          |    2 
 drivers/scsi/csiostor/csio_scsi.c                  |    2 
 drivers/scsi/qla2xxx/qla_mbx.c                     |    3 
 drivers/scsi/qla2xxx/qla_nx.c                      |    8 
 drivers/scsi/qla4xxx/ql4_os.c                      |    2 
 drivers/scsi/ufs/ufshcd.c                          |    3 
 drivers/usb/gadget/function/f_ecm.c                |   16 
 drivers/usb/gadget/function/f_ncm.c                |   17 
 drivers/usb/gadget/legacy/cdc2.c                   |    2 
 drivers/usb/gadget/legacy/g_ffs.c                  |    2 
 drivers/usb/gadget/legacy/multi.c                  |    2 
 drivers/usb/gadget/legacy/ncm.c                    |    2 
 fs/btrfs/ctree.c                                   |   64 
 fs/btrfs/ctree.h                                   |    6 
 fs/btrfs/delayed-ref.c                             |    8 
 fs/btrfs/disk-io.c                                 |    1 
 fs/btrfs/extent_io.c                               |    8 
 fs/btrfs/tests/btrfs-tests.c                       |    1 
 fs/btrfs/transaction.c                             |    8 
 fs/btrfs/tree-log.c                                |    7 
 fs/cifs/smb2pdu.c                                  |   10 
 fs/ext2/super.c                                    |    6 
 fs/nfs/callback_proc.c                             |    2 
 fs/nfs/dir.c                                       |   59 
 fs/nfs/nfs4client.c                                |    2 
 fs/overlayfs/inode.c                               |   13 
 kernel/events/core.c                               |   10 
 kernel/time/clocksource.c                          |   11 
 lib/test_kasan.c                                   |    1 
 net/hsr/hsr_slave.c                                |    2 
 net/ipv4/tcp.c                                     |    3 
 net/sched/cls_rsvp.h                               |    6 
 net/sched/cls_tcindex.c                            |   40 
 net/sunrpc/auth_gss/svcauth_gss.c                  |    4 
 sound/drivers/dummy.c                              |    2 
 sound/soc/qcom/apq8016_sbc.c                       |    3 
 sound/soc/soc-pcm.c                                |   95 
 97 files changed, 8688 insertions(+), 361 deletions(-)

Alexandre Belloni (2):
      ARM: dts: at91: sama5d3: fix maximum peripheral clock rates
      ARM: dts: at91: sama5d3: define clock rate range for tcb1

Alexey Kardashevskiy (1):
      powerpc/pseries: Allow not having ibm, hypertas-functions::hcall-multi-tce for DDW

Andreas Kemnade (1):
      mfd: rn5t618: Mark ADC control register volatile

Arnd Bergmann (1):
      sparc32: fix struct ipc64_perm type definition

Bart Van Assche (1):
      scsi: qla2xxx: Fix the endianness of the qla82xx_get_fw_size() return type

Bean Huo (1):
      scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_add_wlus() fails

Brian Norris (1):
      mwifiex: fix unbalanced locking in mwifiex_process_country_ie()

Bryan O'Donoghue (2):
      usb: gadget: f_ncm: Use atomic_t to track in-flight request
      usb: gadget: f_ecm: Use atomic_t to track in-flight request

Chuhong Yuan (1):
      crypto: picoxcell - adjust the position of tasklet_init and fix missed tasklet_kill

Claudiu Beznea (1):
      drm: atmel-hlcdc: enable clock before configuring timing engine

Cong Wang (1):
      net_sched: fix an OOB access in cls_tcindex

David Hildenbrand (1):
      KVM: x86: drop picdev_in_range()

David Sterba (1):
      btrfs: remove trivial locking wrappers of tree mod log

Eric Dumazet (5):
      cls_rsvp: fix rsvp_policy
      net: hsr: fix possible NULL deref in hsr_handle_frame()
      tcp: clear tp->total_retrans in tcp_disconnect()
      tcp: clear tp->segs_{in|out} in tcp_disconnect()
      bonding/alb: properly access headers in bond_alb_xmit()

Filipe Manana (2):
      Btrfs: fix assertion failure on fsync with NO_HOLES enabled
      Btrfs: fix race between adding and putting tree mod seq elements and nodes

Florian Fainelli (1):
      net: systemport: Avoid RBUF stuck in Wake-on-LAN mode

Geert Uytterhoeven (1):
      pinctrl: sh-pfc: r8a7778: Fix duplicate SDSELF_B and SD1_CLK_B

Greg Kroah-Hartman (1):
      Linux 4.4.214

Gustavo A. R. Silva (1):
      lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()

Herbert Xu (3):
      crypto: api - Check spawn->alg under lock in crypto_drop_spawn
      crypto: pcrypt - Do not clear MAY_SLEEP flag in original request
      crypto: api - Fix race condition in crypto_spawn_alg

Ioanna Alifieraki (1):
      Revert "ovl: modify ovl_permission() to do checks on two inodes"

Joe Thornber (1):
      dm space map common: fix to ensure new block isn't already in use

Johan Hovold (1):
      media: iguanair: fix endpoint sanity check

Jose Abreu (1):
      ARC: [plat-axs10x]: Add missing multicast filter number to GMAC node

Josef Bacik (2):
      btrfs: set trans->drity in btrfs_commit_transaction
      btrfs: flush write bio if we loop in extent_write_cache_pages

Konstantin Khlebnikov (1):
      clocksource: Prevent double add_timer_on() for watchdog_timer

Linus Walleij (1):
      mmc: spi: Toggle SPI polarity, do not hardcode it

Marco Felsch (1):
      mfd: da9062: Fix watchdog compatible string

Marios Pomonis (12):
      KVM: x86: Refactor prefix decoding to prevent Spectre-v1/L1TF attacks
      KVM: x86: Protect DR-based index computations from Spectre-v1/L1TF attacks
      KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data() from Spectre-v1/L1TF attacks
      KVM: x86: Protect ioapic_write_indirect() from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations in pmu.h from Spectre-v1/L1TF attacks
      KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations from Spectre-v1/L1TF attacks in x86.c
      KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations in fixed_msr_to_seg_unit() from Spectre-v1/L1TF attacks
      KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF attacks
      KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks
      KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF attacks

Miaohe Lin (1):
      KVM: nVMX: vmread should not set rflags to specify success in case of #PF

Michael Ellerman (1):
      of: Add OF_DMA_DEFAULT_COHERENT & select it on powerpc

Mike Snitzer (1):
      dm: fix potential for q->make_request_fn NULL pointer

Nathan Chancellor (8):
      scsi: csiostor: Adjust indentation in csio_device_reset
      scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free
      ext2: Adjust indentation in ext2_fill_super
      powerpc/44x: Adjust indentation in ibm4xx_denali_fixup_memsize
      NFC: pn544: Adjust indentation in pn544_hci_check_presence
      ppp: Adjust indentation into ppp_async_input
      net: smc911x: Adjust indentation in smc911x_phy_configure
      net: tulip: Adjust indentation in {dmfe, uli526x}_init_module

Navid Emamdoost (1):
      brcmfmac: Fix memory leak in brcmf_usbdev_qinit

Nicolai Stange (2):
      libertas: don't exit from lbs_ibss_join_existing() with RCU read lock held
      libertas: make lbs_ibss_join_existing() return error code on rates overflow

Nobuhiro Iwamatsu (1):
      ASoC: qcom: Fix of-node refcount unbalance to link->codec_of_node

Oliver Neukum (1):
      mfd: dln2: More sanity checking for endpoints

Paul Kocialkowski (1):
      rtc: hym8563: Return -EINVAL if the time is known to be invalid

Pawan Gupta (1):
      x86/cpu: Update cached HLE state on write to TSX_CTRL_CPUID_CLEAR

Pingfan Liu (1):
      powerpc/pseries: Advance pfn if section is not present in lmb_is_removable()

Qing Xu (2):
      mwifiex: Fix possible buffer overflows in mwifiex_ret_wmm_get_status()
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv()

Quinn Tran (1):
      scsi: qla2xxx: Fix mtcp dump collection failure

Ranjani Sridharan (1):
      ASoC: pcm: update FE/BE trigger order based on the command

Roberto Bergantinos Corpas (1):
      sunrpc: expiry_time should be seconds not timeval

Roger Quadros (1):
      usb: gadget: legacy: set max_speed to super-speed

Ronnie Sahlberg (1):
      cifs: fail i/o on soft mounts if sessionsetup errors out

Sean Christopherson (5):
      KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails
      KVM: PPC: Book3S PR: Free shared page if mmu initialization fails
      KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails
      KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM
      KVM: VMX: Add non-canonical check on writes to RTIT address MSRs

Song Liu (1):
      perf/core: Fix mlock accounting in perf_mmap()

Stephen Warren (1):
      ARM: tegra: Enable PLLP bypass during Tegra124 LP1

Sven Van Asbroeck (1):
      power: supply: ltc2941-battery-gauge: fix use-after-free

Takashi Iwai (1):
      ALSA: dummy: Fix PCM format loop in proc output

Thomas Meyer (1):
      NFS: Fix bool initialization/comparison

Trond Myklebust (2):
      NFS: Fix memory leaks and corruption in readdir
      NFS: Directory page cache pages need to be locked when read

Will Deacon (1):
      media: uvcvideo: Avoid cyclic entity chains due to malformed USB descriptors

Yurii Monakov (1):
      PCI: keystone: Fix link training retries initiation

