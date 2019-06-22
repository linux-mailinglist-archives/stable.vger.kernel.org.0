Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F534F4E1
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 11:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfFVJqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 05:46:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbfFVJqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 05:46:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 186842084E;
        Sat, 22 Jun 2019 09:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561196769;
        bh=irYPJ5xR5fntfDMJ6xPXd7IHfcZwUfkqXt2bJXFA+ks=;
        h=Date:From:To:Cc:Subject:From;
        b=J77PUmOa11KiJMg+nt8tt402BHstYc55CDN23IuLwE3Iyoa/Ir0Hiu+gYAxnG6Q61
         D+zivvAxp4A7QEnxh87wavJChoFQPQNgHjplykKtZax8I/GXS3Y+PbpmGIetCmrodB
         Zka05nFXFQcIz9sDMgVHGAwNlxoAoBcZDkebejw4=
Date:   Sat, 22 Jun 2019 11:46:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.129
Message-ID: <20190622094607.GA12317@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.129 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                  |    2=20
 arch/ia64/mm/numa.c                                       |    1=20
 arch/powerpc/include/asm/kvm_host.h                       |    1=20
 arch/powerpc/kvm/book3s.c                                 |    1=20
 arch/powerpc/kvm/book3s_hv.c                              |    9 --
 arch/powerpc/kvm/book3s_rtas.c                            |   14 +--
 arch/powerpc/platforms/powernv/opal-imc.c                 |    4=20
 arch/x86/events/intel/ds.c                                |   28 +++---
 arch/x86/kernel/cpu/amd.c                                 |    7 +
 drivers/clk/ti/clkctrl.c                                  |    8 -
 drivers/gpio/Kconfig                                      |    1=20
 drivers/hid/wacom_wac.c                                   |   41 ++++++---
 drivers/i2c/i2c-dev.c                                     |    1=20
 drivers/infiniband/hw/mlx4/main.c                         |    4=20
 drivers/infiniband/hw/mlx5/main.c                         |    3=20
 drivers/isdn/mISDN/socket.c                               |    5 -
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c |   61 +++++++--=
-----
 drivers/net/ethernet/dec/tulip/de4x5.c                    |    1=20
 drivers/net/ethernet/emulex/benet/be_ethtool.c            |    2=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c            |    4=20
 drivers/net/ethernet/renesas/sh_eth.c                     |    4=20
 drivers/net/phy/dp83867.c                                 |    4=20
 drivers/scsi/cxgbi/libcxgbi.c                             |    4=20
 drivers/scsi/device_handler/scsi_dh_alua.c                |    6 -
 drivers/scsi/libsas/sas_expander.c                        |    2=20
 drivers/scsi/smartpqi/smartpqi_init.c                     |    2=20
 drivers/staging/vc04_services/bcm2835-camera/controls.c   |    4=20
 drivers/tty/serial/sunhv.c                                |    2=20
 fs/configfs/dir.c                                         |   14 +--
 fs/inode.c                                                |    9 +-
 include/linux/sched/mm.h                                  |    4=20
 kernel/events/ring_buffer.c                               |   39 +++++++-
 mm/khugepaged.c                                           |    3=20
 net/ax25/ax25_route.c                                     |    2=20
 net/core/neighbour.c                                      |    7 +
 net/ipv6/ip6_flowlabel.c                                  |    7 -
 net/lapb/lapb_iface.c                                     |    1=20
 net/netfilter/ipvs/ip_vs_core.c                           |    2=20
 net/netfilter/nf_queue.c                                  |    1=20
 net/openvswitch/vport-internal_dev.c                      |   18 ++--
 net/sctp/sm_make_chunk.c                                  |    8 +
 sound/pci/hda/hda_intel.c                                 |    5 -
 tools/perf/arch/s390/util/machine.c                       |    9 +-
 tools/perf/util/data-convert-bt.c                         |    2=20
 tools/perf/util/machine.c                                 |    3=20
 tools/testing/selftests/netfilter/nft_nat.sh              |    6 +
 46 files changed, 238 insertions(+), 128 deletions(-)

Ajay Kaher (1):
      infiniband: fix race condition between infiniband mlx4, mlx5 driver a=
nd core dumping

Alexander Lochmann (1):
      Abort file_remove_privs() for non-reg. files

Amit Cohen (1):
      mlxsw: spectrum: Prevent force of 56G

Andrea Arcangeli (1):
      coredump: fix race condition between collapse_huge_page() and core du=
mping

Anju T Sudhakar (1):
      powerpc/powernv: Return for invalid IMC domain

Arnaldo Carvalho de Melo (1):
      perf machine: Guard against NULL in machine__exit()

Bard Liao (1):
      ALSA: hda - Force polling mode on CNL for fixing codec communication

Dan Carpenter (2):
      Staging: vc04_services: Fix a couple error codes
      mISDN: make sure device name is NUL terminated

Dmitry Bogdanov (1):
      net: aquantia: fix LRO with FCS error

Eric Dumazet (3):
      ax25: fix inconsistent lock state in ax25_destroy_timer
      ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero
      neigh: fix use-after-free read in pneigh_get_next

Frank van der Linden (1):
      x86/CPU/AMD: Don't force the CPB cap when running under a hypervisor

Greg Kroah-Hartman (1):
      Linux 4.14.129

Ivan Vecera (1):
      be2net: Fix number of Rx queues used for flow hashing

Jagdish Motwani (1):
      netfilter: nf_queue: fix reinject verdict handling

Jason Gerecke (3):
      HID: wacom: Don't set tool type until we're in range
      HID: wacom: Don't report anything prior to the tool entering range
      HID: wacom: Send BTN_TOUCH in response to INTUOSP2_BT eraser contact

Jason Yan (1):
      scsi: libsas: delete sas port if expander discover failed

Jeffrin Jose T (1):
      selftests: netfilter: missing error check when setting up veth interf=
ace

Jeremy Sowden (1):
      lapb: fixed leak of control-blocks.

John Paul Adrian Glaubitz (1):
      sunhv: Fix device naming inconsistency between sunhv_console and sunh=
v_reg

Kees Cook (1):
      net: tulip: de4x5: Drop redundant MODULE_DEVICE_TABLE()

Lianbo Jiang (1):
      scsi: smartpqi: properly set both the DMA mask and the coherent DMA m=
ask

Max Uvarov (1):
      net: phy: dp83867: Set up RGMII TX delay

Neil Horman (1):
      sctp: Free cookie before we memdup a new one

Paul Mackerras (2):
      KVM: PPC: Book3S: Use new mutex to synchronize access to rtas token l=
ist
      KVM: PPC: Book3S HV: Don't take kvm->lock around kvm_for_each_vcpu

Peter Zijlstra (2):
      perf/ring_buffer: Add ordering to rb->nest increment
      perf/ring-buffer: Always use {READ,WRITE}_ONCE() for rb->user_page da=
ta

Randy Dunlap (2):
      gpio: fix gpio-adp5588 build errors
      ia64: fix build errors by exporting paddr_to_nid()

Sahitya Tummala (1):
      configfs: Fix use-after-free when accessing sd->s_dentry

Shawn Landden (1):
      perf data: Fix 'strncat may truncate' build failure with recent gcc

Stephane Eranian (1):
      perf/x86/intel/ds: Fix EVENT vs. UEVENT PEBS constraints

Taehee Yoo (1):
      net: openvswitch: do not free vport if register_netdevice() is failed.

Thomas Richter (1):
      perf record: Fix s390 missing module symbol and warning for non-root =
users

Tony Lindgren (1):
      clk: ti: clkctrl: Fix clkdm_clk handling

Varun Prakash (1):
      scsi: libcxgbi: add a check for NULL pointer in cxgbi_check_route()

Yabin Cui (1):
      perf/ring_buffer: Fix exposing a temporarily decreased data_head

Yingjoe Chen (1):
      i2c: dev: fix potential memory leak in i2cdev_ioctl_rdwr

Yoshihiro Shimoda (1):
      net: sh_eth: fix mdio access in sh_eth_close() for R-Car Gen2 and RZ/=
A1 SoCs

YueHaibing (2):
      ipvs: Fix use-after-free in ip_vs_in
      scsi: scsi_dh_alua: Fix possible null-ptr-deref


--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0N+N8ACgkQONu9yGCS
aT6t/hAApBofG0Q5RVpefUbBtPi9LoJXnOMfmWvkkfuKwKCOE3Z6HPdGNTNWUaE/
JKafhTT0P6rtpl6OmLB3xKDdDLMM7xCVeQj1P1eqlGdHozLE4+Lb4pe2ukLL8CgR
9MI/g3gdYVb7PNL7NAS4T7poY5FrdqU+cShIJD4ctKHLd3Mqv7bz42OEb6nxpXUx
sinYwD2TfD2/rtTzYwMXEt43+G8NBdMNRrULqOal6Qg27JXJYZ2mBmH8sJRFvZRa
a+fZNJJbNIrwMvLMfzB9fFDoiVReLZk+5oCWyGQltpT61iwgbo5sdM3kN6mK5EJZ
7kkPMVUAQMND4XcAgQzN1IJzT2ntTc594s7H+zr4VD3CEI1+1XRrWnEoaapOBMMn
l0JkBG9YoGr3HGoQpPoaLBNI09oBKtuOAh+PJocbBwKPGPHxDLIYwGgVPnHtHE3N
dFgslE0ES5jNdORWE81fAX2IiWygPJJuE3Qlmi8JL5VoGmPgjcSEANnJ+vJXUVPG
kQAUdF/2lKz2rVVDa3YDqKYIHhh5deaBs+CsLjTjoTcHh8GOTUW+GM/3vEttm/1B
3NBFeBrdFpEqCjK9aADdrVmcMgo95tP60drVbTR87UflMqJF2bPQkK9l9G11TOoe
YmvC+UUXHmw2vrXCauXYQT3F8FFqBguT3yNM5VU06K9gmUL3Zkw=
=qfv4
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
