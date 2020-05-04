Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951341C36BC
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 12:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgEDKXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 06:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbgEDKXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 06:23:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4094F206E6;
        Mon,  4 May 2020 10:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588587779;
        bh=LE2j/0yWkhpsL8S7d5RwBLRRxEJLVLsxSkZu8MbYSEw=;
        h=Date:From:To:Cc:Subject:From;
        b=RR0wubdv9kN+j+qpdHDmV4j3wm0jTBAVsRpSGKVRQy2LeWsWR+7nslq0kEzNa8bpA
         M7Bj1WezT3Vhlptbd40mfpB96e3caTQ0f7bjPSCPt4z7Lwp+f0Epd6rEbGkesHM8nw
         7eWVfvaDpJTW952ktdahdE8nggQafP50i+3ZolTw=
Date:   Mon, 4 May 2020 12:22:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.120
Message-ID: <20200504102257.GA1455215@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.120 kernel.

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

 Makefile                                                 |    2=20
 arch/arm/boot/dts/bcm283x.dtsi                           |    1=20
 arch/arm64/include/asm/sysreg.h                          |    4=20
 arch/x86/kernel/cpu/mshyperv.c                           |    4=20
 arch/x86/net/bpf_jit_comp.c                              |   18 +
 arch/x86/net/bpf_jit_comp32.c                            |   24 +-
 drivers/android/binder_alloc.c                           |    8=20
 drivers/hwmon/jc42.c                                     |    2=20
 drivers/i2c/busses/i2c-altera.c                          |    9=20
 drivers/iio/adc/ad7793.c                                 |    2=20
 drivers/mtd/chips/cfi_cmdset_0002.c                      |    6=20
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c               |    2=20
 drivers/net/ethernet/freescale/fec.h                     |    7=20
 drivers/net/ethernet/freescale/fec_main.c                |  149 ++++++++++=
++---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c |    6=20
 drivers/net/ethernet/qlogic/qed/qed_dev.c                |   38 +--
 drivers/pci/quirks.c                                     |   18 +
 drivers/remoteproc/remoteproc_core.c                     |    2=20
 drivers/staging/gasket/apex_driver.c                     |    7=20
 drivers/target/target_core_fabric_lib.c                  |    2=20
 drivers/target/target_core_user.c                        |    1=20
 drivers/usb/dwc3/gadget.c                                |    8=20
 drivers/usb/gadget/udc/bdc/bdc_ep.c                      |    2=20
 drivers/xen/xenbus/xenbus_client.c                       |    9=20
 fs/ext4/ialloc.c                                         |    2=20
 fs/ext4/inode.c                                          |    2=20
 fs/ext4/mballoc.c                                        |    6=20
 fs/ext4/super.c                                          |    3=20
 fs/nfsd/nfs4state.c                                      |    2=20
 fs/pnode.c                                               |    9=20
 fs/xfs/xfs_icache.c                                      |   10 +
 fs/xfs/xfs_ioctl.c                                       |    5=20
 fs/xfs/xfs_reflink.c                                     |    1=20
 fs/xfs/xfs_trans_ail.c                                   |    4=20
 include/linux/qed/qed_chain.h                            |   24 +-
 include/linux/sunrpc/svc_rdma.h                          |    1=20
 include/trace/events/rpcrdma.h                           |   50 +++--
 include/uapi/linux/swab.h                                |    4=20
 kernel/bpf/cpumap.c                                      |    2=20
 kernel/events/core.c                                     |   13 +
 mm/shmem.c                                               |    4=20
 net/rxrpc/local_object.c                                 |    9=20
 net/rxrpc/output.c                                       |   44 +---
 net/sunrpc/svc_xprt.c                                    |    3=20
 net/sunrpc/svcsock.c                                     |    4=20
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c                  |   22 ++
 net/sunrpc/xprtrdma/svc_rdma_rw.c                        |    3=20
 net/sunrpc/xprtrdma/svc_rdma_sendto.c                    |   29 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c                 |    5=20
 sound/pci/hda/hda_intel.c                                |   17 +
 sound/soc/codecs/tas571x.c                               |   20 +-
 sound/soc/codecs/wm8960.c                                |    3=20
 sound/soc/qcom/qdsp6/q6afe-dai.c                         |   16 +
 tools/objtool/check.c                                    |   17 +
 tools/objtool/orc_dump.c                                 |   44 ++--
 55 files changed, 470 insertions(+), 239 deletions(-)

Al Viro (1):
      propagate_one(): mnt_set_mountpoint() needs mount_lock

Bjorn Helgaas (1):
      PCI: Move Apex Edge TPU class quirk to fix BAR assignment

Bodo Stroesser (2):
      scsi: target: fix PR IN / READ FULL STATUS for FC
      scsi: target: tcmu: reset_ring should reset TCMU_DEV_BIT_BROKEN

Brian Foster (1):
      xfs: acquire superblock freeze protection on eofblocks scans

Christian Borntraeger (1):
      include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LON=
G for swap

Chuck Lever (2):
      svcrdma: Fix trace point use-after-free race
      svcrdma: Fix leak of svc_rdma_recv_ctxt objects

Clement Leger (1):
      remoteproc: Fix wrong rvring index computation

Darrick J. Wong (1):
      xfs: fix partially uninitialized structure in xfs_reflink_remap_extent

David Howells (1):
      rxrpc: Fix DATA Tx to disable nofrag for UDP on AF_INET6 socket

Eric Biggers (1):
      xfs: clear PF_MEMALLOC before exiting xfsaild thread

Fangrui Song (1):
      arm64: Delete the space separator in __emit_inst

Greg Kroah-Hartman (1):
      Linux 4.19.120

Hui Wang (1):
      ALSA: hda: call runtime_allow() for all hda controllers

Ian Rogers (1):
      perf/core: fix parent pid/tid in task exit events

Jason Gunthorpe (1):
      net/cxgb4: Check the return from t4_query_params properly

Josh Poimboeuf (2):
      objtool: Fix CONFIG_UBSAN_TRAP unreachable warnings
      objtool: Support Clang non-section symbols in ORC dump

Juergen Gross (1):
      xen/xenbus: ensure xenbus_map_ring_valloc() returns proper grant stat=
us

Kai-Heng Feng (1):
      PCI: Avoid ASMedia XHCI USB PME# from D0 defect

Liu Jian (1):
      mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer

Luke Nelson (3):
      bpf, x86_32: Fix incorrect encoding in BPF_LDX zero-extension
      bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX BPF_B
      bpf, x86_32: Fix clobbering of dst for BPF_JSET

Martin Fuzzey (1):
      net: fec: set GPR bit on suspend by DT configuration.

Nathan Chancellor (1):
      usb: gadget: udc: bdc: Remove unnecessary NULL checks in bdc_req_comp=
lete

Nicolas Saenz Julienne (1):
      ARM: dts: bcm283x: Disable dsi0 node

Niklas Schnelle (1):
      net/mlx5: Fix failing fw tracer allocation on s390

Olaf Hering (1):
      x86: hyperv: report value of misc_features

Philipp Puschmann (1):
      ASoC: tas571x: disable regulators on failed probe

Ritesh Harjani (1):
      ext4: check for non-zero journal inum in ext4_calculate_overhead

Roy Spliet (1):
      ALSA: hda: Explicitly permit using autosuspend if runtime PM is suppo=
rted

Sascha Hauer (1):
      hwmon: (jc42) Fix name to have no illegal characters

Shengjiu Wang (1):
      ASoC: wm8960: Fix wrong clock after suspend & resume

Stephan Gerhold (1):
      ASoC: q6dsp6: q6afe-dai: add missing channels to MI2S DAIs

Takashi Iwai (1):
      ALSA: hda: Keep the controller initialization even if no codecs found

Theodore Ts'o (2):
      ext4: increase wait time needed before reuse of deleted inode numbers
      ext4: convert BUG_ON's to WARN_ON's in mballoc.c

Thinh Nguyen (1):
      usb: dwc3: gadget: Do link recovery for SS and SSP

Toke H=F8iland-J=F8rgensen (1):
      cpumap: Avoid warning when CONFIG_DEBUG_PER_CPU_MAPS is enabled

Tyler Hicks (1):
      binder: take read mode of mmap_sem in binder_alloc_free_page()

Vasily Averin (1):
      nfsd: memory corruption in nfsd4_lock()

Wolfram Sang (1):
      i2c: altera: use proper variable to hold errno

Yang Shi (1):
      mm: shmem: disable interrupt when acquiring info->lock in userfaultfd=
_copy path

YueHaibing (1):
      iio:ad7797: Use correct attribute_group

Yuval Basson (1):
      qed: Fix use after free in qed_chain_free

yangerkun (1):
      ext4: use matching invalidatepage in ext4_writepage


--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6v7QEACgkQONu9yGCS
aT5kOA//ajMxL3hYkWyv8qbRVJ0RGE4NcvuVdTIa9pUzD58Dqz7+32Gy1z5H6A1Z
WW8yzMWr8XVK4P6lhPEL/ep3yZapMjGy7zzACUbvVQXXptCtvoIARDKtmIvQ9McX
tSexbQZq9UZI1YrOup1KCc0MFuZEjlT3qQRmtlMVT1xwYNUobIjRpqJ95O6MGsKz
jNOVQl2Gj0SRd5WVLckzN9+VWEGE4tCdNva6iJJmrP2IAL0qvXrWuhjfwhr73gJ6
AOPPRugCRiCJsme6kDunH10fCIIuHj3PmuqOruofilRQyK+gqEOaGlLzXhU8e9kA
4JV3O9A+8FuqduFf3dhcziBRdWzO0TkONVQivaWtv4T3oJuETqylltqiLOr+GgMw
DL/MTxSNWmKe9lNTaGGoi8ReF3a8+AWQTqzO4AleyPy4GtMF7HEEuWq96TBEgFOf
psrIqcirBc+yRq39DUDNU4miXhE+VBPGTP0lc9glORKDbPfcjetykIDhogBEd9yM
WvJXkAOq+1Bwcmo9mghdApC6Qoa/Yx3j396b8Zuzddui1pCQGJDyKrBNnPgA1m6H
fNatuCsXHDQxyBIUrhdrcMd2fQkIKS/HVVgRIDkqW1REpSJ8jKMo8uy3UxMvwbRZ
PDbl8+RUp/eI6FeEtvJNF0luUwt+drM9l9+Q3nO7bxYXeBQ4QxY=
=XTpa
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
