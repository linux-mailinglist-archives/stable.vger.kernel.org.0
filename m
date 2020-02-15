Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86FB015FBB0
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 01:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgBOAox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 19:44:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727723AbgBOAow (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 19:44:52 -0500
Received: from localhost (unknown [38.98.37.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74217206CC;
        Sat, 15 Feb 2020 00:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581727490;
        bh=SkpcweScq5mrqjcorvsRRHjgKMBdM5HhrVbKoxCnEjU=;
        h=Date:From:To:Cc:Subject:From;
        b=VdQMLX3GHaGBIlTZQCLkF3lAhHbZzVg9ZaiPPjjgb9pqmWGfYsgyvhGZenvJ2Xp7N
         y9DQ4kcM0W3ZveR31QMm3z1Ny6ugtDuD4g7J01UEKlZYxPq72jxFLEg3193X5++knU
         9tDkSPwUErsW4pQot5mZMGcL36pmNUE3doGNCrHE=
Date:   Fri, 14 Feb 2020 19:41:31 -0500
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.104
Message-ID: <20200215004131.GA28582@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.104 kernel.

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

 Makefile                                    |    2=20
 arch/arc/boot/dts/axs10x_mb.dtsi            |    1=20
 arch/arm/boot/dts/am43xx-clocks.dtsi        |   54 +++++++++++++++
 arch/arm/boot/dts/at91sam9260.dtsi          |   12 +--
 arch/arm/boot/dts/at91sam9261.dtsi          |    6 -
 arch/arm/boot/dts/at91sam9263.dtsi          |    6 -
 arch/arm/boot/dts/at91sam9g45.dtsi          |    8 +-
 arch/arm/boot/dts/at91sam9rl.dtsi           |    8 +-
 arch/arm/boot/dts/sama5d3.dtsi              |   28 ++++----
 arch/arm/boot/dts/sama5d3_can.dtsi          |    4 -
 arch/arm/boot/dts/sama5d3_tcb1.dtsi         |    1=20
 arch/arm/boot/dts/sama5d3_uart.dtsi         |    4 -
 arch/arm/mm/init.c                          |    2=20
 arch/arm64/kernel/cpufeature.c              |    2=20
 arch/arm64/kernel/ptrace.c                  |   21 ++++++
 arch/powerpc/platforms/pseries/iommu.c      |   43 ++++++++----
 arch/powerpc/platforms/pseries/vio.c        |    2=20
 arch/x86/entry/calling.h                    |   15 ----
 arch/x86/entry/entry_32.S                   |   16 ----
 arch/x86/include/asm/frame.h                |   49 ++++++++++++++
 arch/x86/kernel/ftrace_32.S                 |    3=20
 arch/x86/kernel/ftrace_64.S                 |    3=20
 drivers/crypto/atmel-sha.c                  |    7 --
 drivers/crypto/axis/artpec6_crypto.c        |    2=20
 drivers/gpio/gpio-zynq.c                    |   23 ++++++
 drivers/infiniband/core/addr.c              |    2=20
 drivers/infiniband/core/sa_query.c          |    4 -
 drivers/infiniband/core/uverbs_main.c       |   32 ++++-----
 drivers/infiniband/hw/mlx4/main.c           |   20 ++++-
 drivers/iommu/arm-smmu-v3.c                 |    1=20
 drivers/media/i2c/adv748x/adv748x.h         |    8 +-
 drivers/mtd/nand/onenand/onenand_base.c     |   82 ++++++++++++------------
 drivers/mtd/parsers/sharpslpart.c           |    4 -
 drivers/net/wireless/ath/ath10k/pci.c       |   19 +++++
 drivers/net/wireless/marvell/libertas/cfg.c |    2=20
 drivers/net/wireless/marvell/mwifiex/scan.c |    7 ++
 drivers/net/wireless/marvell/mwifiex/wmm.c  |    4 +
 drivers/pci/iov.c                           |    9 +-
 drivers/pci/setup-bus.c                     |   20 ++++-
 drivers/pci/switch/switchtec.c              |    2=20
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c        |    4 -
 drivers/platform/x86/intel_mid_powerbtn.c   |    5 -
 drivers/rtc/rtc-cmos.c                      |    2=20
 drivers/rtc/rtc-hym8563.c                   |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c   |    3=20
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    3=20
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    1=20
 drivers/scsi/ufs/ufshcd.c                   |    3=20
 drivers/spi/spi-mem.c                       |   54 ++++++++++++++-
 drivers/tty/serial/xilinx_uartps.c          |   17 +++--
 fs/nfs/Kconfig                              |    2=20
 fs/nfs/direct.c                             |    4 -
 fs/nfs/nfs3xdr.c                            |    5 +
 fs/nfs/nfs4proc.c                           |    5 +
 fs/nfs/nfs4xdr.c                            |    5 +
 fs/nfs/pnfs_nfs.c                           |    7 --
 fs/nfs/write.c                              |   12 +++
 include/rdma/ib_verbs.h                     |    3=20
 kernel/padata.c                             |    1=20
 net/vmw_vsock/hyperv_transport.c            |   68 ++------------------
 sound/soc/soc-pcm.c                         |   95 ++++++++++++++++++++---=
-----
 tools/power/acpi/Makefile.config            |    2=20
 virt/kvm/arm/aarch32.c                      |   14 ++--
 virt/kvm/arm/mmu.c                          |    3=20
 virt/kvm/arm/pmu.c                          |    3=20
 virt/kvm/arm/vgic/vgic-its.c                |    3=20
 66 files changed, 563 insertions(+), 301 deletions(-)

Alexandre Belloni (2):
      ARM: dts: at91: sama5d3: fix maximum peripheral clock rates
      ARM: dts: at91: sama5d3: define clock rate range for tcb1

Alexey Kardashevskiy (1):
      powerpc/pseries: Allow not having ibm, hypertas-functions::hcall-mult=
i-tce for DDW

Anand Lodnoor (1):
      scsi: megaraid_sas: Do not initiate OCR if controller is not in ready=
 state

Andy Shevchenko (1):
      rtc: cmos: Stop using shared IRQ

Bean Huo (1):
      scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_ad=
d_wlus() fails

Boris Brezillon (1):
      spi: spi-mem: Add extra sanity checks on the op param

Brandon Maier (1):
      gpio: zynq: Report gpio direction at boot

Bryan O'Donoghue (1):
      ath10k: pci: Only dump ATH10K_MEM_REGION_TYPE_IOREG when safe

Daniel Jordan (1):
      padata: fix null pointer deref of pd->pinst

Eric Auger (2):
      KVM: arm/arm64: vgic-its: Fix restoration of unmapped collections
      KVM: arm64: pmu: Don't increment SW_INCR if PMCR.E is unset

Eric Biggers (2):
      crypto: artpec6 - return correct error code for failed setkey()
      crypto: atmel-sha - fix error handling when setting hmac key

Gavin Shan (1):
      KVM: arm/arm64: Fix young bit from mmu notifier

Geert Uytterhoeven (3):
      nfs: NFS_SWAP should depend on SWAP
      spi: spi-mem: Fix inverted logic in op sanity check
      pinctrl: sh-pfc: r8a7778: Fix duplicate SDSELF_B and SD1_CLK_B

Greg Kroah-Hartman (1):
      Linux 4.19.104

Gustavo A. R. Silva (1):
      media: i2c: adv748x: Fix unsafe macros

H=E5kon Bugge (1):
      RDMA/netlink: Do not always generate an ACK for some netlink operatio=
ns

Ingo van Lil (1):
      ARM: dts: at91: Reenable UART TX pull-ups

Jack Morgenstein (1):
      IB/mlx4: Fix memory leak in add_gid error flow

James Morse (2):
      KVM: arm: Fix DFSR setting for non-LPAE aarch32 guests
      KVM: arm: Make inject_abt32() inject an external abort instead

Jason Gunthorpe (1):
      RDMA/core: Fix locking in ib_uverbs_event_read

Jose Abreu (1):
      ARC: [plat-axs10x]: Add missing multicast filter number to GMAC node

Logan Gunthorpe (2):
      PCI/switchtec: Fix vep_vector_number ioread width
      PCI: Don't disable bridge BARs when assigning bus resources

Michael Guralnik (1):
      RDMA/uverbs: Verify MR access flags

Mika Westerberg (1):
      platform/x86: intel_mid_powerbtn: Take a copy of ddata

Nathan Chancellor (1):
      mtd: onenand_base: Adjust indentation in onenand_read_ops_nolock

Navid Emamdoost (1):
      PCI/IOV: Fix memory leak in pci_iov_add_virtfn()

Nicolai Stange (2):
      libertas: don't exit from lbs_ibss_join_existing() with RCU read lock=
 held
      libertas: make lbs_ibss_join_existing() return error code on rates ov=
erflow

Olof Johansson (1):
      ARM: 8949/1: mm: mark free_memmap as __init

Paul Kocialkowski (1):
      rtc: hym8563: Return -EINVAL if the time is known to be invalid

Peter Zijlstra (2):
      x86/stackframe: Move ENCODE_FRAME_POINTER to asm/frame.h
      x86/stackframe, x86/ftrace: Add pt_regs frame annotations

Qing Xu (2):
      mwifiex: Fix possible buffer overflows in mwifiex_ret_wmm_get_status()
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv=
()

Ranjani Sridharan (1):
      ASoC: pcm: update FE/BE trigger order based on the command

Robert Milkowski (1):
      NFSv4: try lease recovery on NFS4ERR_EXPIRED

Shameer Kolothum (1):
      iommu/arm-smmu-v3: Populate VMID field for CMDQ_OP_TLBI_NH_VA

Shubhrajyoti Datta (2):
      serial: uartps: Add a timeout to the tx empty wait
      serial: uartps: Move the spinlock after the read of the tx empty

Sunil Muthuswamy (1):
      hv_sock: Remove the accept port restriction

Suzuki K Poulose (2):
      arm64: cpufeature: Fix the type of no FP/SIMD capability
      arm64: ptrace: nofpsimd: Fail FP/SIMD regset operations

Tero Kristo (1):
      ARM: dts: am43xx: add support for clkout1 clock

Trond Myklebust (2):
      NFS: Revalidate the file size on a fatal write error
      NFS/pnfs: Fix pnfs_generic_prepare_to_resend_writes()

Tyrel Datwyler (1):
      powerpc/pseries/vio: Fix iommu_table use-after-free refcount warning

YueHaibing (1):
      mtd: sharpslpart: Fix unsigned comparison to zero

Zhengyuan Liu (1):
      tools/power/acpi: fix compilation error


--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5HPjsACgkQONu9yGCS
aT4lTBAAvshhxiHEOopNXPhBf5ISlfrHgh/nkiZpRxS2GxgFqRJEGpUA9SI0fKT5
KiywyiZtjLHwMptxI3SvMl6MnNnux0Bbew79mRobs4kDhuxN0i/H/EsyBvips54B
dTwi8izi7mCUwZ6VvWPFBKZE+SuHV3b+y0tCB8stSTyqap8nwQs0s34HOg6HVHAN
uPiFxhlLu4XX4cXCbc1OCRypCiz9c9A5nHXhBTpNGhKjQ2EwXVibShrvQie/RNp5
L/Of9SK+T2uhWQNpXF7w2YVa2GWdf6XsxNVwL5fyFzjN+NDq/fsoKdoLg1p5Y0VX
AVHvkuSZld4MPo9FX+76jA9Vp9b2kT5hQ7CvMAVlPq1e8iUVg/zPebD5DF+jBwIk
l3veZzVqK+yP+HhcIH2nKNc+1/cQmDebPvABkFFL+evtAHZZdszsD6GeXk7fq3Oz
Un2u7K1avtcdcQYStYdAuEeCDAIqo/DilDUb1v0DTCFW9h/ZhUBNdAQanh/gpmSZ
MFBTNbMd2q1ELEbZcdRHEb0GUYBjtEhohtN742F1j73ueazvKCIpabziBkMVpC/B
T+E/saM15KqINKfxqR+/crl3HU60L5gEDUN1e8pEj6Baqsd8BpvtEcne3HCvXMhd
OpsvB/U0KU/+9/fTesJZRgw9dEJ9ySabFpLM4LIDaiUPULYFQ2w=
=YOk0
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
