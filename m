Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57E5E10535D
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 14:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfKUNmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 08:42:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbfKUNmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 08:42:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0A192070A;
        Thu, 21 Nov 2019 13:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574343719;
        bh=S4pJm8XNNfNqhLFUvnUqsLJF+K1CKQlf7Tc0dmOKJYQ=;
        h=Date:From:To:Cc:Subject:From;
        b=qwKgDJGGaY3KLdLBhjAAh5mSepszl8GEc0YkdDjyIgvPFbywpD9ID+dq7tG2UJKON
         RX0ruRKvhKI72CwXiuMhxGZTlvbv1Mu6bFj+pkxjCxE3uslU+k5P6oYJP0yfRRLYCm
         tCIuMovVSg+DPZilc+8VCIOJ4IsP3+9hVSn165I4=
Date:   Thu, 21 Nov 2019 14:41:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.3.12
Message-ID: <20191121134156.GA548418@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.3.12 kernel.

All users of the 5.3 kernel series must upgrade.

The updated 5.3.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.3.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                           |    2=20
 arch/x86/kernel/early-quirks.c                     |    2=20
 arch/x86/kvm/mmu.c                                 |    8 +-
 drivers/base/memory.c                              |   36 +++++++++++++
 drivers/gpu/drm/i915/display/intel_display_power.c |    3 +
 drivers/gpu/drm/i915/gt/intel_mocs.c               |    8 --
 drivers/gpu/drm/i915/i915_drv.c                    |    3 -
 drivers/i2c/i2c-core-acpi.c                        |   28 +++++++++-
 drivers/infiniband/hw/hfi1/init.c                  |    1=20
 drivers/infiniband/hw/hfi1/pcie.c                  |    4 +
 drivers/infiniband/hw/hfi1/rc.c                    |   16 ++---
 drivers/infiniband/hw/hfi1/sdma.c                  |    5 +
 drivers/infiniband/hw/hfi1/tid_rdma.c              |   57 +++++++++++-----=
-----
 drivers/infiniband/hw/hfi1/tid_rdma.h              |    3 -
 drivers/infiniband/hw/hfi1/verbs.c                 |   10 +--
 drivers/input/ff-memless.c                         |    9 +++
 drivers/input/rmi4/rmi_f11.c                       |    4 -
 drivers/input/rmi4/rmi_f12.c                       |   32 ++++++++++-
 drivers/input/rmi4/rmi_f54.c                       |    5 +
 drivers/mmc/host/sdhci-of-at91.c                   |    2=20
 drivers/net/can/slcan.c                            |    1=20
 drivers/net/ethernet/cortina/gemini.c              |    1=20
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   10 +++
 drivers/net/ethernet/mellanox/mlx4/main.c          |    3 +
 drivers/net/ethernet/mellanox/mlxsw/core.c         |    5 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |    2=20
 drivers/net/netdevsim/dev.c                        |    2=20
 drivers/net/slip/slip.c                            |    1=20
 drivers/net/usb/ax88172a.c                         |    2=20
 drivers/net/usb/qmi_wwan.c                         |    2=20
 drivers/scsi/scsi_lib.c                            |    3 -
 fs/btrfs/inode.c                                   |   15 +++++
 fs/ecryptfs/inode.c                                |   19 ++++---
 fs/io_uring.c                                      |    2=20
 include/linux/intel-iommu.h                        |    6 +-
 include/linux/kvm_host.h                           |    1=20
 include/linux/memory.h                             |    1=20
 include/net/devlink.h                              |    3 +
 include/trace/events/tcp.h                         |    2=20
 include/uapi/linux/devlink.h                       |    1=20
 kernel/signal.c                                    |    2=20
 kernel/time/ntp.c                                  |    2=20
 mm/hugetlb_cgroup.c                                |    2=20
 mm/memcontrol.c                                    |    2=20
 mm/memory_hotplug.c                                |   43 +++++++++------
 mm/mempolicy.c                                     |   14 +++--
 mm/page_io.c                                       |    6 +-
 mm/slub.c                                          |   39 +++-----------
 net/core/devlink.c                                 |   45 ++++++++++++++++
 net/ipv4/ipmr.c                                    |    3 -
 net/smc/af_smc.c                                   |    3 -
 sound/usb/endpoint.c                               |    3 +
 sound/usb/mixer.c                                  |    4 +
 sound/usb/quirks.c                                 |    4 -
 sound/usb/validate.c                               |    6 +-
 virt/kvm/kvm_main.c                                |   26 ++++++++-
 56 files changed, 369 insertions(+), 155 deletions(-)

Al Viro (2):
      ecryptfs_lookup_interpose(): lower_dentry->d_inode is not stable
      ecryptfs_lookup_interpose(): lower_dentry->d_parent is not stable eit=
her

Aleksander Morgado (1):
      net: usb: qmi_wwan: add support for Foxconn T77W968 LTE modules

Andrew Duggan (2):
      Input: synaptics-rmi4 - disable the relative position IRQ in the F12 =
driver
      Input: synaptics-rmi4 - do not consume more data than we have (F11, F=
12)

Arnd Bergmann (1):
      ntp/y2038: Remove incorrect time_t truncation

Aya Levin (1):
      devlink: Add method for time-stamp on reporter's dump

Chuhong Yuan (2):
      net: gemini: add missed free_netdev
      Input: synaptics-rmi4 - destroy F54 poller workqueue when removing

Corentin Labbe (1):
      net: ethernet: dwmac-sun8i: Use the correct function in exit path

David Hildenbrand (1):
      mm/memory_hotplug: fix try_offline_node()

Eric Auger (1):
      iommu/vt-d: Fix QI_DEV_IOTLB_PFSID and QI_DEV_EIOTLB_PFSID macros

Eugen Hristev (1):
      mmc: sdhci-of-at91: fix quirk2 overwrite

Filipe Manana (1):
      Btrfs: fix log context list corruption after rename exchange operation

Greg Kroah-Hartman (1):
      Linux 5.3.12

Guillaume Nault (1):
      ipmr: Fix skb headroom in ipmr_get_route().

Hans de Goede (1):
      i2c: acpi: Force bus speed to 400KHz if a Silead touchscreen is prese=
nt

Henry Lin (1):
      ALSA: usb-audio: not submit urb for stopped endpoint

Ioana Ciornei (1):
      dpaa2-eth: free already allocated channels on probe defer

James Erwin (1):
      IB/hfi1: Ensure full Gen3 speed in a Gen4 system

Jani Nikula (1):
      drm/i915: update rawclk also on resume

Jens Axboe (1):
      io_uring: ensure registered buffer import returns the IO length

Jiri Pirko (2):
      devlink: disallow reload operation during device cleanup
      mlxsw: core: Enable devlink reload only on probe

Jouni Hogander (2):
      slip: Fix memory leak in slip_open error path
      slcan: Fix memory leak in error path

Kai-Heng Feng (1):
      x86/quirks: Disable HPET on Intel Coffe Lake platforms

Kaike Wan (3):
      IB/hfi1: Ensure r_tid_ack is valid before building TID RDMA ACK packet
      IB/hfi1: Calculate flow weight based on QP MTU for TID RDMA
      IB/hfi1: TID RDMA WRITE should not return IB_WC_RNR_RETRY_EXC_ERR

Laura Abbott (1):
      mm: slub: really fix slab walking for init_on_free

Lucas Stach (2):
      Input: synaptics-rmi4 - fix video buffer size
      Input: synaptics-rmi4 - clear IRQ enables for F54

Matt Roper (1):
      Revert "drm/i915/ehl: Update MOCS table for EHL"

Michael Schmitz (1):
      scsi: core: Handle drivers which set sg_tablesize to zero

Mike Marciniszyn (1):
      IB/hfi1: Use a common pad buffer for 9B and 16B packets

Oleg Nesterov (1):
      cgroup: freezer: call cgroup_enter_frozen() with preemption disabled =
in ptrace_stop()

Oliver Neukum (2):
      ax88172a: fix information leak on short answers
      Input: ff-memless - kill timer in destroy()

Roman Gushchin (2):
      mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()
      mm: hugetlb: switch to css_tryget() in hugetlb_cgroup_charge_cgroup()

Sean Christopherson (1):
      KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved

Takashi Iwai (3):
      ALSA: usb-audio: Fix missing error check at mixer resolution test
      ALSA: usb-audio: Fix incorrect NULL check in create_yamaha_midi_quirk=
()
      ALSA: usb-audio: Fix incorrect size check for processing/extension un=
its

Tony Lu (1):
      tcp: remove redundant new line from tcp_event_sk_skb

Ursula Braun (2):
      net/smc: fix fastopen for non-blocking connect()
      net/smc: fix refcount non-blocking connect() -part 2

Vinayak Menon (1):
      mm/page_io.c: do not free shared swap slots

Yang Shi (1):
      mm: mempolicy: fix the wrong return value and potential pages leak of=
 mbind


--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3WlCQACgkQONu9yGCS
aT6l8g//QH0k4O0BzU2GbVp7ZVwZ3iBjpe/5w0dd02kI49/3qtOb1znbVs35l6XC
TXwUA3oN1scn3n7v6FWUVnYOLr1d7q5VBeZZSNSrtPD2KSRAY/8Zt665qoVnxPav
3/XP9y5f7kSXPv7cgLvJ/CGe+L4mmn/sc3QNaVO7YgXieY5RG1EDUgQnxFviENO5
efazh3Vbdk3j1rxwyR0xPS7M//Qf96RDkscQRHKFyzVdiImCQ0a3WUsCB6d42wy6
UsIXAAsEqsHVxHn19Spmdd7V1rboCjISosyvv4caOXRbErd1YPAQDOKfGg23jU7F
C5DsyMWbS7YQ3571y6Z7VdeaZO3Hqe1JxnZvxV683Q7HcXu26gmBnqPTzAf28B02
TLNJsWDgJ5o8DW1zcLdUTk596XAONtJ7tavEUa+pEuNYkzjY2ics9QuNW9lUIZjL
COvFRYq7jHRQHUpOJQyuZgTLuc1PcfZ7O4Lp+gjU7FDKUHbEHxZkSlpaaJO5V7LV
6jSIR1SmFHVUGJ58VGmbJsGj9sY6gIUiCPxl4DuklAn5bioPJsUvBokys94FZoeL
BNZIqSpKRcr0iw4cGhacVJkK3+qh0b9fi8OFzrQLcHXKkzX/I5JJkLaw/Okd0XBX
0qC9UzhLs9NWvrapSxp1dCr52P22XNqsOVK6bSlen0rZy0SwurI=
=/HDQ
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
