Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D17B15FB9E
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 01:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgBOAoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 19:44:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727572AbgBOAn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 19:43:59 -0500
Received: from localhost (unknown [38.98.37.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 381C6206CC;
        Sat, 15 Feb 2020 00:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581727438;
        bh=3hEz//GDbodY7feFl5/9YfCh3nBmuoFsx9L+zdF7VUE=;
        h=Date:From:To:Cc:Subject:From;
        b=RBbRYBpEKyhL8DLjIXK4buMShDQc49aMQhN3pm1LQvqkjYe0AuWcGDBYOziUYkAlY
         H6HROtSqJ8LHaCbSbpinrKIVoVHSHFOuhzglksG7kOkkDwZAFxGZsF6z42JFhlhCFK
         Nnsjh4XqAc1jDPBQm1R2LGrNubOfv4SVVjpsahNg=
Date:   Fri, 14 Feb 2020 19:40:49 -0500
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.214
Message-ID: <20200215004049.GA28463@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.214 kernel.

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

 Makefile                                               |    2=20
 arch/arc/boot/dts/axs10x_mb.dtsi                       |    1=20
 arch/arm/boot/dts/sama5d3.dtsi                         |   28=20
 arch/arm/boot/dts/sama5d3_can.dtsi                     |    4=20
 arch/arm/boot/dts/sama5d3_tcb1.dtsi                    |    1=20
 arch/arm/boot/dts/sama5d3_uart.dtsi                    |    4=20
 arch/arm/mach-tegra/sleep-tegra30.S                    |   11=20
 arch/powerpc/Kconfig                                   |    1=20
 arch/powerpc/boot/4xx.c                                |    2=20
 arch/powerpc/kvm/book3s_hv.c                           |    4=20
 arch/powerpc/kvm/book3s_pr.c                           |    4=20
 arch/powerpc/platforms/pseries/hotplug-memory.c        |    4=20
 arch/powerpc/platforms/pseries/iommu.c                 |   43=20
 arch/sparc/include/uapi/asm/ipcbuf.h                   |   22=20
 arch/x86/kernel/cpu/tsx.c                              |   13=20
 arch/x86/kvm/emulate.c                                 |   28=20
 arch/x86/kvm/hyperv.c                                  |   11=20
 arch/x86/kvm/ioapic.c                                  |   15=20
 arch/x86/kvm/lapic.c                                   |   14=20
 arch/x86/kvm/mtrr.c                                    |    9=20
 arch/x86/kvm/pmu.h                                     |   18=20
 arch/x86/kvm/pmu_intel.c                               |   24=20
 arch/x86/kvm/vmx.c                                     |    4=20
 arch/x86/kvm/vmx/vmx.c                                 | 8033 ++++++++++++=
+++++
 arch/x86/kvm/x86.c                                     |   23=20
 crypto/algapi.c                                        |   22=20
 crypto/api.c                                           |    3=20
 crypto/internal.h                                      |    1=20
 crypto/pcrypt.c                                        |    1=20
 drivers/clk/tegra/clk-tegra-periph.c                   |    6=20
 drivers/crypto/atmel-aes.c                             |   37=20
 drivers/crypto/picoxcell_crypto.c                      |   15=20
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c         |    8=20
 drivers/infiniband/core/addr.c                         |    2=20
 drivers/infiniband/core/sa_query.c                     |    4=20
 drivers/infiniband/hw/mlx5/gsi.c                       |    3=20
 drivers/md/dm.c                                        |    9=20
 drivers/md/persistent-data/dm-space-map-common.c       |   27=20
 drivers/md/persistent-data/dm-space-map-common.h       |    2=20
 drivers/md/persistent-data/dm-space-map-disk.c         |    6=20
 drivers/md/persistent-data/dm-space-map-metadata.c     |    5=20
 drivers/media/rc/iguanair.c                            |    2=20
 drivers/media/usb/uvc/uvc_driver.c                     |   12=20
 drivers/media/v4l2-core/videobuf-dma-sg.c              |    5=20
 drivers/mfd/da9062-core.c                              |    2=20
 drivers/mfd/dln2.c                                     |   13=20
 drivers/mfd/rn5t618.c                                  |    1=20
 drivers/mmc/host/mmc_spi.c                             |   11=20
 drivers/mtd/ubi/fastmap.c                              |   23=20
 drivers/net/bonding/bond_alb.c                         |   44=20
 drivers/net/ethernet/broadcom/bcmsysport.c             |    3=20
 drivers/net/ethernet/dec/tulip/dmfe.c                  |    7=20
 drivers/net/ethernet/dec/tulip/uli526x.c               |    4=20
 drivers/net/ethernet/smsc/smc911x.c                    |    2=20
 drivers/net/gtp.c                                      |    6=20
 drivers/net/ppp/ppp_async.c                            |   18=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    1=20
 drivers/net/wireless/marvell/libertas/cfg.c            |    2=20
 drivers/net/wireless/marvell/mwifiex/scan.c            |    7=20
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c       |    1=20
 drivers/net/wireless/marvell/mwifiex/wmm.c             |    4=20
 drivers/nfc/pn544/pn544.c                              |    2=20
 drivers/of/Kconfig                                     |    4=20
 drivers/of/address.c                                   |    6=20
 drivers/pci/host/pci-keystone-dw.c                     |    2=20
 drivers/pci/setup-bus.c                                |   20=20
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c                   |    4=20
 drivers/power/supply/ltc2941-battery-gauge.c           |    2=20
 drivers/rtc/rtc-cmos.c                                 |    2=20
 drivers/rtc/rtc-hym8563.c                              |    2=20
 drivers/scsi/csiostor/csio_scsi.c                      |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c              |    3=20
 drivers/scsi/megaraid/megaraid_sas_fusion.c            |    3=20
 drivers/scsi/megaraid/megaraid_sas_fusion.h            |    1=20
 drivers/scsi/qla2xxx/qla_mbx.c                         |    3=20
 drivers/scsi/qla2xxx/qla_nx.c                          |    7=20
 drivers/scsi/qla4xxx/ql4_os.c                          |    2=20
 drivers/scsi/ufs/ufshcd.c                              |    3=20
 drivers/usb/gadget/function/f_ecm.c                    |   16=20
 drivers/usb/gadget/function/f_ncm.c                    |   17=20
 drivers/usb/gadget/legacy/cdc2.c                       |    2=20
 drivers/usb/gadget/legacy/g_ffs.c                      |    2=20
 drivers/usb/gadget/legacy/multi.c                      |    2=20
 drivers/usb/gadget/legacy/ncm.c                        |    2=20
 fs/btrfs/ctree.c                                       |   64=20
 fs/btrfs/ctree.h                                       |    6=20
 fs/btrfs/delayed-ref.c                                 |    8=20
 fs/btrfs/disk-io.c                                     |   11=20
 fs/btrfs/extent_io.c                                   |    8=20
 fs/btrfs/tests/btrfs-tests.c                           |    1=20
 fs/btrfs/transaction.c                                 |    8=20
 fs/btrfs/tree-log.c                                    |    7=20
 fs/cifs/smb2pdu.c                                      |   10=20
 fs/ext2/super.c                                        |    6=20
 fs/ext4/page-io.c                                      |   19=20
 fs/nfs/Kconfig                                         |    2=20
 fs/nfs/callback_proc.c                                 |    2=20
 fs/nfs/dir.c                                           |   92=20
 fs/nfs/nfs4client.c                                    |    2=20
 fs/nfs/nfs4proc.c                                      |    5=20
 fs/nfs/pnfs.c                                          |    2=20
 fs/nfsd/nfs4layouts.c                                  |    2=20
 fs/nfsd/nfs4state.c                                    |    2=20
 fs/nfsd/state.h                                        |    2=20
 fs/ubifs/file.c                                        |    6=20
 include/media/v4l2-rect.h                              |    8=20
 kernel/events/core.c                                   |   10=20
 kernel/time/clocksource.c                              |   11=20
 lib/test_kasan.c                                       |    1=20
 net/hsr/hsr_slave.c                                    |    2=20
 net/ipv4/tcp.c                                         |    6=20
 net/rxrpc/ar-internal.h                                |    1=20
 net/rxrpc/call_object.c                                |    4=20
 net/rxrpc/conn_client.c                                |    3=20
 net/rxrpc/conn_object.c                                |    3=20
 net/rxrpc/input.c                                      |    3=20
 net/rxrpc/output.c                                     |   26=20
 net/sched/cls_rsvp.h                                   |    6=20
 net/sched/cls_tcindex.c                                |   40=20
 net/sunrpc/auth_gss/svcauth_gss.c                      |    4=20
 sound/drivers/dummy.c                                  |    2=20
 sound/soc/qcom/apq8016_sbc.c                           |    3=20
 sound/soc/soc-pcm.c                                    |   95=20
 tools/power/acpi/Makefile.config                       |    2=20
 124 files changed, 8800 insertions(+), 446 deletions(-)

Alexandre Belloni (2):
      ARM: dts: at91: sama5d3: fix maximum peripheral clock rates
      ARM: dts: at91: sama5d3: define clock rate range for tcb1

Alexey Kardashevskiy (1):
      powerpc/pseries: Allow not having ibm, hypertas-functions::hcall-mult=
i-tce for DDW

Anand Jain (1):
      btrfs: use bool argument in free_root_pointers()

Anand Lodnoor (1):
      scsi: megaraid_sas: Do not initiate OCR if controller is not in ready=
 state

Andreas Kemnade (1):
      mfd: rn5t618: Mark ADC control register volatile

Andy Shevchenko (1):
      rtc: cmos: Stop using shared IRQ

Arnd Bergmann (3):
      sparc32: fix struct ipc64_perm type definition
      nfsd: fix delay timer on 32-bit architectures
      nfsd: fix jiffies/time_t mixup in LRU list

Bart Van Assche (1):
      scsi: qla2xxx: Fix the endianness of the qla82xx_get_fw_size() return=
 type

Bean Huo (1):
      scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_ad=
d_wlus() fails

Benjamin Coddington (1):
      NFS: switch back to to ->iterate()

Brian Norris (1):
      mwifiex: fix unbalanced locking in mwifiex_process_country_ie()

Bryan O'Donoghue (2):
      usb: gadget: f_ncm: Use atomic_t to track in-flight request
      usb: gadget: f_ecm: Use atomic_t to track in-flight request

Chuhong Yuan (1):
      crypto: picoxcell - adjust the position of tasklet_init and fix misse=
d tasklet_kill

Claudiu Beznea (1):
      drm: atmel-hlcdc: enable clock before configuring timing engine

Cong Wang (1):
      net_sched: fix an OOB access in cls_tcindex

Dan Carpenter (1):
      ubi: Fix an error pointer dereference in error handling code

David Howells (3):
      rxrpc: Fix insufficient receive notification generation
      rxrpc: Fix NULL pointer deref due to call->conn being cleared on disc=
onnect
      rxrpc: Fix service call disconnection

David Sterba (1):
      btrfs: remove trivial locking wrappers of tree mod log

Eric Biggers (1):
      ext4: fix deadlock allocating crypto bounce page from mempool

Eric Dumazet (7):
      cls_rsvp: fix rsvp_policy
      net: hsr: fix possible NULL deref in hsr_handle_frame()
      tcp: clear tp->total_retrans in tcp_disconnect()
      tcp: clear tp->delivered in tcp_disconnect()
      tcp: clear tp->data_segs{in|out} in tcp_disconnect()
      tcp: clear tp->segs_{in|out} in tcp_disconnect()
      bonding/alb: properly access headers in bond_alb_xmit()

Filipe Manana (2):
      Btrfs: fix assertion failure on fsync with NO_HOLES enabled
      Btrfs: fix race between adding and putting tree mod seq elements and =
nodes

Florian Fainelli (1):
      net: systemport: Avoid RBUF stuck in Wake-on-LAN mode

Geert Uytterhoeven (2):
      nfs: NFS_SWAP should depend on SWAP
      pinctrl: sh-pfc: r8a7778: Fix duplicate SDSELF_B and SD1_CLK_B

Greg Kroah-Hartman (1):
      Linux 4.9.214

Gustavo A. R. Silva (1):
      lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()

Helen Koike (1):
      media: v4l2-rect.h: fix v4l2_rect_map_inside() top/left adjustments

Herbert Xu (3):
      crypto: api - Check spawn->alg under lock in crypto_drop_spawn
      crypto: pcrypt - Do not clear MAY_SLEEP flag in original request
      crypto: api - Fix race condition in crypto_spawn_alg

Hyunchul Lee (1):
      ubifs: Change gfp flags in page allocation for bulk read

H=E5kon Bugge (1):
      RDMA/netlink: Do not always generate an ACK for some netlink operatio=
ns

Joe Thornber (1):
      dm space map common: fix to ensure new block isn't already in use

Johan Hovold (1):
      media: iguanair: fix endpoint sanity check

John Hubbard (1):
      media/v4l2-core: set pages dirty upon releasing DMA buffers

Jose Abreu (1):
      ARC: [plat-axs10x]: Add missing multicast filter number to GMAC node

Josef Bacik (2):
      btrfs: set trans->drity in btrfs_commit_transaction
      btrfs: flush write bio if we loop in extent_write_cache_pages

Konstantin Khlebnikov (1):
      clocksource: Prevent double add_timer_on() for watchdog_timer

Linus Walleij (1):
      mmc: spi: Toggle SPI polarity, do not hardcode it

Logan Gunthorpe (1):
      PCI: Don't disable bridge BARs when assigning bus resources

Marco Felsch (1):
      mfd: da9062: Fix watchdog compatible string

Marios Pomonis (11):
      KVM: x86: Refactor prefix decoding to prevent Spectre-v1/L1TF attacks
      KVM: x86: Protect DR-based index computations from Spectre-v1/L1TF at=
tacks
      KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF attacks
      KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data() from Spectre-v1/L=
1TF attacks
      KVM: x86: Protect ioapic_write_indirect() from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations in pmu.h from Spectre-=
v1/L1TF attacks
      KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations from Spectre-v1/L1TF a=
ttacks in x86.c
      KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations in fixed_msr_to_seg_un=
it() from Spectre-v1/L1TF attacks
      KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks

Miaohe Lin (1):
      KVM: nVMX: vmread should not set rflags to specify success in case of=
 #PF

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
      libertas: don't exit from lbs_ibss_join_existing() with RCU read lock=
 held
      libertas: make lbs_ibss_join_existing() return error code on rates ov=
erflow

Nobuhiro Iwamatsu (1):
      ASoC: qcom: Fix of-node refcount unbalance to link->codec_of_node

Oliver Neukum (1):
      mfd: dln2: More sanity checking for endpoints

Paul Kocialkowski (1):
      rtc: hym8563: Return -EINVAL if the time is known to be invalid

Pawan Gupta (1):
      x86/cpu: Update cached HLE state on write to TSX_CTRL_CPUID_CLEAR

Pingfan Liu (1):
      powerpc/pseries: Advance pfn if section is not present in lmb_is_remo=
vable()

Prabhath Sajeepa (1):
      IB/mlx5: Fix outstanding_pi index for GSI qps

Qing Xu (2):
      mwifiex: Fix possible buffer overflows in mwifiex_ret_wmm_get_status()
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv=
()

Quinn Tran (1):
      scsi: qla2xxx: Fix mtcp dump collection failure

Ranjani Sridharan (1):
      ASoC: pcm: update FE/BE trigger order based on the command

Robert Milkowski (1):
      NFSv4: try lease recovery on NFS4ERR_EXPIRED

Roberto Bergantinos Corpas (1):
      sunrpc: expiry_time should be seconds not timeval

Roger Quadros (1):
      usb: gadget: legacy: set max_speed to super-speed

Ronnie Sahlberg (1):
      cifs: fail i/o on soft mounts if sessionsetup errors out

Sascha Hauer (1):
      ubi: fastmap: Fix inverted logic in seen selfcheck

Sean Christopherson (5):
      KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails
      KVM: PPC: Book3S PR: Free shared page if mmu initialization fails
      KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails
      KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM
      KVM: VMX: Add non-canonical check on writes to RTIT address MSRs

Song Liu (1):
      perf/core: Fix mlock accounting in perf_mmap()

Stephen Warren (2):
      ARM: tegra: Enable PLLP bypass during Tegra124 LP1
      clk: tegra: Mark fuse clock as critical

Sven Van Asbroeck (1):
      power: supply: ltc2941-battery-gauge: fix use-after-free

Taehee Yoo (1):
      gtp: use __GFP_NOWARN to avoid memalloc warning

Takashi Iwai (1):
      ALSA: dummy: Fix PCM format loop in proc output

Thomas Meyer (1):
      NFS: Fix bool initialization/comparison

Trond Myklebust (2):
      NFS: Fix memory leaks and corruption in readdir
      NFS: Directory page cache pages need to be locked when read

Tudor Ambarus (1):
      crypto: atmel-aes - Fix counter overflow in CTR mode

Will Deacon (1):
      media: uvcvideo: Avoid cyclic entity chains due to malformed USB desc=
riptors

Yurii Monakov (1):
      PCI: keystone: Fix link training retries initiation

Zhengyuan Liu (1):
      tools/power/acpi: fix compilation error

Zhihao Cheng (1):
      ubifs: Fix deadlock in concurrent bulk-read and writepage


--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5HPg4ACgkQONu9yGCS
aT7ztBAAgdR1jkjxI3rixyXlmawbB5KRYW5MsGGJHRbg6kNHRB4m9biZQIpicHcm
kbdyBsR/KrsTiq9Y+dB9HQxZ5NNtX5uWardIR2tDlLq+TVT+6x58+cTTGUdBchzs
rGYrRau0EC5VnZbcfpi2LZCFf3FtGBzZe1pNcBHTfNAbx/9i2J7AY2odmf/oupMP
I5J5QgCgca/sGP53EXjzGRv0BPmGHm5lrxXduvAm4QAjbcZQ0yiTouiLjbXYIQtj
us+rLvPuGBMfkJ3577f4aYxylBfzsEMNxNeJSgnWNis4b1tSL+seoEbOWLpCXUc2
Sq0PXqh5UArrGFNSVX5G/IOkFAloZA83T37PNOn7CTHbDIWmVu2BSJFsJoGmjplq
FJRx48eWitES9BY2JUJrJDwmc6vPVWfPUTuLjnTn2l7y3X56nzfrHKJI92vNzTqx
BZsmA9ka1jL7r1/6NIvsicH+cAyrtbO61REF2T2e87fyRa5aE81nr/f6nyTNE2ka
ZbWPQpLuo5pRFmYw1TilEYcAWLjhwE52suwfmhPNUYuwfLTBh412S/3aUUvqKAnN
xFJDV29KNFP/Q55rviCexMi6uJJQpyoGv0w9+rqOfeQiYjTNTZKPb+We5bEK9fGM
whVFinF+YFobnPaY4ysVUgEZveP86R/MaKQw4HJZ263rezSIWGQ=
=F63V
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
