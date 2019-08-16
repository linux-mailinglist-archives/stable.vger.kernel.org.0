Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34138FF3E
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 11:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfHPJoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 05:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbfHPJoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 05:44:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4742720644;
        Fri, 16 Aug 2019 09:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565948668;
        bh=xqvZV/5sop1smCrhGFdjzMSJ8zpq+3cqst1pjFg7rSc=;
        h=Date:From:To:Cc:Subject:From;
        b=shPliwbRfxEkMkKDcV9EJk5WEisG9FuTF9t57o9NQE2IlwXmnRyT0H9ChtImNWDIZ
         Lr5mk5bVb3VH/ZrL8u0OI2R3fZCQXdH64mE7BpW/hI97R7yrQzB6b3hpJD/NbvHGQE
         O4LMhyF9i41dAwsutufY8Vvfkel7VTtH1Vx81PEQ=
Date:   Fri, 16 Aug 2019 11:44:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.139
Message-ID: <20190816094426.GA32738@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.139 kernel.

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

 Makefile                                     |    2=20
 arch/arm/mach-davinci/sleep.S                |    1=20
 arch/powerpc/kvm/powerpc.c                   |    5=20
 arch/x86/include/asm/kvm_host.h              |    1=20
 arch/x86/kvm/svm.c                           |    6 +
 arch/x86/kvm/vmx.c                           |    6 +
 arch/x86/kvm/x86.c                           |   16 +++
 arch/x86/mm/fault.c                          |   15 +-
 drivers/acpi/arm64/iort.c                    |    4=20
 drivers/block/drbd/drbd_receiver.c           |   14 ++
 drivers/block/loop.c                         |    2=20
 drivers/cpufreq/pasemi-cpufreq.c             |   23 +---
 drivers/crypto/ccp/ccp-crypto-aes-galois.c   |   14 ++
 drivers/crypto/ccp/ccp-ops.c                 |  139 +++++++++++++++++++---=
-----
 drivers/firmware/Kconfig                     |    5=20
 drivers/firmware/iscsi_ibft.c                |    4=20
 drivers/gpu/drm/drm_framebuffer.c            |    2=20
 drivers/gpu/drm/i915/intel_dsi_pll.c         |    4=20
 drivers/hid/hid-sony.c                       |   15 ++
 drivers/hwmon/nct6775.c                      |    3=20
 drivers/hwmon/nct7802.c                      |    6 -
 drivers/iio/adc/max9611.c                    |    2=20
 drivers/input/mouse/synaptics.c              |    1=20
 drivers/misc/Makefile                        |    3=20
 drivers/mmc/host/cavium.c                    |    4=20
 drivers/net/can/rcar/rcar_canfd.c            |    9 -
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |    8 -
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c   |    2=20
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c  |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  |   29 ++++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c |    2=20
 drivers/net/wireless/marvell/mwifiex/main.h  |    1=20
 drivers/net/wireless/marvell/mwifiex/scan.c  |    3=20
 drivers/s390/cio/qdio_main.c                 |   12 +-
 drivers/s390/cio/vfio_ccw_cp.c               |    4=20
 drivers/scsi/device_handler/scsi_dh_alua.c   |    7 +
 drivers/scsi/ibmvscsi/ibmvfc.c               |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c    |    3=20
 drivers/tty/tty_ldsem.c                      |    5=20
 drivers/usb/core/devio.c                     |    2=20
 drivers/usb/host/xhci-rcar.c                 |    9 +
 drivers/usb/misc/iowarrior.c                 |    7 -
 drivers/usb/misc/yurex.c                     |    2=20
 fs/cifs/smb2pdu.c                            |    7 +
 fs/nfs/nfs4proc.c                            |   12 +-
 include/linux/ccp.h                          |    2=20
 include/linux/kvm_host.h                     |    1=20
 include/net/tcp.h                            |    3=20
 include/sound/compress_driver.h              |    5=20
 kernel/events/core.c                         |    2=20
 lib/test_firmware.c                          |    5=20
 mm/vmalloc.c                                 |    9 +
 net/ipv4/netfilter/ipt_rpfilter.c            |    1=20
 net/ipv6/netfilter/ip6t_rpfilter.c           |    8 +
 net/mac80211/driver-ops.c                    |   13 +-
 net/mac80211/mlme.c                          |   10 +
 net/netfilter/nfnetlink.c                    |    2=20
 net/netfilter/nft_hash.c                     |    2=20
 scripts/sphinx-pre-install                   |    2=20
 sound/core/compress_offload.c                |   60 +++++++++--
 sound/firewire/packets-buffer.c              |    2=20
 sound/pci/hda/hda_controller.c               |   13 +-
 sound/pci/hda/hda_controller.h               |    2=20
 sound/pci/hda/hda_intel.c                    |   63 ++++++++++++
 sound/sound_core.c                           |    3=20
 tools/perf/arch/s390/util/machine.c          |   31 +++++-
 tools/perf/builtin-probe.c                   |   10 +
 tools/perf/util/header.c                     |    2=20
 tools/perf/util/machine.c                    |    3=20
 tools/perf/util/machine.h                    |    2=20
 tools/perf/util/symbol.c                     |    7 +
 tools/perf/util/symbol.h                     |    1=20
 tools/perf/util/thread.c                     |   12 ++
 virt/kvm/kvm_main.c                          |   25 ++++
 74 files changed, 557 insertions(+), 169 deletions(-)

Adrian Hunter (1):
      perf db-export: Fix thread__exec_comm()

Arnaldo Carvalho de Melo (1):
      perf probe: Avoid calling freeing routine multiple times for same poi=
nter

Arnd Bergmann (2):
      drbd: dynamically allocate shash descriptor
      ARM: davinci: fix sleep.S build error on ARMv4

Ben Hutchings (1):
      tcp: Clear sk_send_head after purging the write queue

Bj=F6rn Gerhart (1):
      hwmon: (nct6775) Fix register address and added missed tolerance for =
nct6106

Brian Norris (3):
      mac80211: don't warn about CW params when not using them
      mac80211: don't WARN on short WMM parameters from AP
      mwifiex: fix 802.11n/WPA detection

Charles Keepax (4):
      ALSA: compress: Fix regression on compressed capture streams
      ALSA: compress: Prevent bypasses of set_params
      ALSA: compress: Don't allow paritial drain operations on capture stre=
ams
      ALSA: compress: Be more restrictive about when a drain is allowed

Dmitry Torokhov (1):
      Input: synaptics - enable RMI mode for HP Spectre X360

Emmanuel Grumbach (2):
      iwlwifi: don't unmap as page memory that was mapped as single
      iwlwifi: mvm: fix an out-of-bound access

Farhan Ali (1):
      vfio-ccw: Set pa_nr to 0 if memory allocation fails for pa_iova_pfn

Florian Westphal (1):
      netfilter: nfnetlink: avoid deadlock due to synchronous request_module

Gary R Hook (4):
      crypto: ccp - Fix oops by properly managing allocated structures
      crypto: ccp - Ignore tag length when decrypting GCM ciphertext
      crypto: ccp - Validate buffer lengths for copy operations
      crypto: ccp - Add support for valid authsize values less than 16

Gavin Li (1):
      usb: usbfs: fix double-free of usb memory upon submiturb error

Greg Kroah-Hartman (1):
      Linux 4.14.139

Guenter Roeck (1):
      hwmon: (nct7802) Fix wrong detection of in4 presence

Hannes Reinecke (1):
      scsi: scsi_dh_alua: always use a 2 second delay before retrying RTPG

Jiri Olsa (1):
      perf tools: Fix proper buffer size for feature processing

Joe Perches (1):
      iio: adc: max9611: Fix misuse of GENMASK macro

Joerg Roedel (3):
      x86/mm: Check for pfn instead of page in vmalloc_sync_one()
      x86/mm: Sync also unmappings in vmalloc_sync_all()
      mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy()

Julian Wiedmann (1):
      s390/qdio: add sanity checks to the fast-requeue path

Junxiao Bi (1):
      scsi: megaraid_sas: fix panic on loading firmware crashdump

Kevin Hao (2):
      mmc: cavium: Set the correct dma max segment size for mmc_host
      mmc: cavium: Add the missing dma unmap when the dma has finished.

Laura Garcia Liebana (1):
      netfilter: nft_hash: fix symhash with modulus one

Leonard Crestez (1):
      perf/core: Fix creating kernel counters for PMUs that override event-=
>cpu

Lorenzo Pieralisi (1):
      ACPI/IORT: Fix off-by-one check in iort_dev_find_its_id()

Luca Coelho (2):
      iwlwifi: mvm: don't send GEO_TX_POWER_LIMIT on version < 41
      iwlwifi: mvm: fix version check for GEO_TX_POWER_LIMIT support

Mauro Carvalho Chehab (1):
      scripts/sphinx-pre-install: fix script for RHEL/CentOS

Miaohe Lin (1):
      netfilter: Fix rpfilter dropping vrf packets by mistake

Mikulas Patocka (1):
      loop: set PF_MEMALLOC_NOIO for the worker thread

Nick Desaulniers (1):
      lkdtm: support llvm-objcopy

Nikita Yushchenko (1):
      can: rcar_canfd: fix possible IRQ storm on high load

Oliver Neukum (1):
      usb: iowarrior: fix deadlock on disconnect

Pavel Shilovsky (1):
      SMB3: Fix deadlock in validate negotiate hits reconnect

Peter Zijlstra (1):
      tty/ldsem, locking/rwsem: Add missing ACQUIRE to read_failed sleep lo=
op

Qian Cai (1):
      drm: silence variable 'conn' set but not used

Roderick Colenbrander (1):
      HID: sony: Fix race condition between rumble and device remove.

Stanislav Lisovskiy (1):
      drm/i915: Fix wrong escape clock divisor init for GLK

Stephane Grosjean (1):
      can: peak_usb: fix potential double kfree_skb()

Steve French (1):
      smb3: send CAP_DFS capability during session setup

Suzuki K Poulose (1):
      usb: yurex: Fix use-after-free in yurex_delete

Takashi Iwai (2):
      ALSA: hda - Don't override global PCM hw info flag
      ALSA: hda - Workaround for crackled sound on AMD controller (1022:145=
7)

Thomas Richter (2):
      perf annotate: Fix s390 gap between kernel end and module start
      perf record: Fix module size on s390

Thomas Tai (1):
      iscsi_ibft: make ISCSI_IBFT dependson ACPI instead of ISCSI_IBFT_FIND

Tomas Bortoli (2):
      can: peak_usb: pcan_usb_pro: Fix info-leaks to USB devices
      can: peak_usb: pcan_usb_fd: Fix info-leaks to USB devices

Trond Myklebust (2):
      NFSv4: Only pass the delegation to setattr if we're sending a truncate
      NFSv4: Fix an Oops in nfs4_do_setattr

Tyrel Datwyler (1):
      scsi: ibmvfc: fix WARN_ON during event pool release

Wanpeng Li (1):
      KVM: Fix leak vCPU's VMCS value into other pCPU

Wen Yang (1):
      cpufreq/pasemi: fix use-after-free in pas_cpufreq_cpu_init()

Wenwen Wang (3):
      sound: fix a memory leak bug
      test_firmware: fix a memory leak bug
      ALSA: firewire: fix a memory leak bug

Yoshihiro Shimoda (1):
      usb: host: xhci-rcar: Fix timeout in xhci_suspend()


--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1WevcACgkQONu9yGCS
aT5KYRAAwViHDYhMJ6UoWPjGmcTnjjVqPXTGjUtBbZgO8QcL03OkECM5Biu5IEi4
7uBrF8Fe4L6s2pt7YT7nE6xZYQ9GAQTBHSbLpytqMST5SaGMmYXj0jsT1/QmO4kP
YDHsaw1EnTt81NNpxYTJoT0WMRQlUzJ35UFmJEqDMA0IeE5BHND/2HA9fUwX/R8C
RnfvYz5eIloAchZKSg9MXKcPhuPwJzrdGkf57Ve3SFw4NncOIlpmBVmGmk18J04h
BVhhfK5eUe4BCLrf8Sm4uo53y6tXIG7ck9ehy5mYupHOsNOcAw8HhkKZcAHA8qMc
0+gugtFMM4TO2HP2DfrJQFInLtepJqoiZzo+D3O6ZRgaVdS5UwQNSp6M4KdFLMVv
hQPJJipU8hon9h1zRYSRFY4coCrTmTCdyPiXubYGRhoC9dXsN9SMRR6dipi+Wq7W
cKYyslYFv/8KlB8rhWdqz1Xh13Qddu/fb6u/WoZov97JjivjYx3QoimSPmIVXVFF
w7FvmtD49v/Rz4GXQNtwk67lWyy+Mu7GM34zTZ3aKQ3XhZMUsltef3fHarXmUS8z
wyLtGDZRc2BvawSE5NJi+3PNI2ikQAO1FLVRmK82KCQ3cjWE9j2ZouUNgNHpJEzT
YyHobUz6aLXVgkv46+o73+EWjnxbVZeHU5KGYXqAXrOcEFpq6mo=
=gqGt
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
