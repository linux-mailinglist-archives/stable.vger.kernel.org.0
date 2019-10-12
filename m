Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60DC9D4E29
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 09:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbfJLH5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Oct 2019 03:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbfJLH5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Oct 2019 03:57:52 -0400
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 783912089C;
        Sat, 12 Oct 2019 07:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570867069;
        bh=bOtj3gZYnkBII6xPKGLwtaHJMdjtnPVPstB6USjwc9Y=;
        h=Date:From:To:Cc:Subject:From;
        b=K0mmE5UZ6dcYza+0+o50dTgyqzOLA02gVxFcbEdxlmQpmNprGWivIYmiL5saw9XV4
         XtolXm+7Cy+KMO3hRaVdJ7KMEO8CShN0VCRczfkqqD8CP3fi2fHupIG2+bIEWIJcqT
         BNj/nZNN8aazFk8bCf1V7lim0N8MCO78eZl5scvQ=
Date:   Sat, 12 Oct 2019 09:57:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.149
Message-ID: <20191012075739.GA2038430@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.149 kernel.

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

 Makefile                                       |    2=20
 arch/powerpc/kvm/book3s_hv.c                   |    9=20
 arch/powerpc/kvm/book3s_xive.c                 |   18 +
 arch/powerpc/mm/hash_utils_64.c                |    9=20
 arch/powerpc/platforms/powernv/opal.c          |   11 -
 arch/powerpc/platforms/pseries/lpar.c          |    8=20
 arch/s390/kernel/process.c                     |   22 +-
 arch/s390/kernel/topology.c                    |    3=20
 arch/s390/kvm/kvm-s390.c                       |    2=20
 arch/x86/kvm/vmx.c                             |    2=20
 crypto/skcipher.c                              |   42 ++--
 drivers/block/nbd.c                            |   61 ++++--
 drivers/crypto/caam/caamalg_desc.c             |    9=20
 drivers/crypto/caam/caamalg_desc.h             |    2=20
 drivers/crypto/cavium/zip/zip_main.c           |    3=20
 drivers/crypto/qat/qat_common/adf_common_drv.h |    2=20
 drivers/devfreq/tegra-devfreq.c                |   12 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c        |    3=20
 drivers/gpu/drm/omapdrm/dss/dss.c              |    2=20
 drivers/hwtracing/coresight/coresight-etm4x.c  |   14 +
 drivers/mmc/host/sdhci-of-esdhc.c              |    7=20
 drivers/mmc/host/sdhci.c                       |   15 +
 drivers/net/can/spi/mcp251x.c                  |   19 +-
 drivers/net/ieee802154/atusb.c                 |    3=20
 drivers/pwm/pwm-stm32-lp.c                     |    6=20
 drivers/s390/cio/ccwgroup.c                    |    2=20
 drivers/s390/cio/css.c                         |    2=20
 drivers/thermal/thermal_core.c                 |    2=20
 drivers/watchdog/aspeed_wdt.c                  |    4=20
 drivers/watchdog/imx2_wdt.c                    |    4=20
 drivers/xen/pci.c                              |   21 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c       |   20 +-
 fs/9p/vfs_file.c                               |    3=20
 fs/ceph/inode.c                                |    7=20
 fs/ceph/mds_client.c                           |    4=20
 fs/fuse/cuse.c                                 |    1=20
 fs/nfs/nfs4xdr.c                               |    2=20
 fs/nfs/pnfs.c                                  |    9=20
 fs/statfs.c                                    |   17 -
 include/linux/ieee80211.h                      |   53 +++++
 include/sound/soc-dapm.h                       |    2=20
 kernel/elfcore.c                               |    1=20
 kernel/locking/qspinlock_paravirt.h            |    2=20
 kernel/sched/core.c                            |    4=20
 kernel/time/tick-broadcast-hrtimer.c           |   57 +++---
 kernel/time/timer.c                            |    8=20
 mm/usercopy.c                                  |    8=20
 net/netfilter/nf_tables_api.c                  |    7=20
 net/netfilter/nft_lookup.c                     |    3=20
 net/wireless/nl80211.c                         |   42 ++++
 net/wireless/reg.c                             |    2=20
 net/wireless/scan.c                            |   14 -
 net/wireless/wext-compat.c                     |    2=20
 security/integrity/ima/ima_crypto.c            |    5=20
 sound/soc/codecs/sgtl5000.c                    |  232 ++++++++++++++++++++=
+----
 tools/lib/traceevent/Makefile                  |    4=20
 tools/lib/traceevent/event-parse.c             |    3=20
 tools/perf/Makefile.config                     |    2=20
 tools/perf/arch/x86/util/unwind-libunwind.c    |    2=20
 tools/perf/builtin-stat.c                      |    5=20
 tools/perf/util/header.c                       |    2=20
 tools/perf/util/stat.c                         |   17 +
 tools/perf/util/stat.h                         |    1=20
 63 files changed, 656 insertions(+), 206 deletions(-)

Alexander Sverdlin (1):
      crypto: qat - Silence smp_processor_id() warning

Andrew Donnellan (1):
      powerpc/powernv: Restrict OPAL symbol map to only be readable by root

Andrew Murray (1):
      coresight: etm4x: Use explicit barriers on enable/disable

Arnaldo Carvalho de Melo (1):
      perf unwind: Fix libunwind build failure on i386 systems

Balasubramani Vivekanandan (1):
      tick: broadcast-hrtimer: Fix a race in bc_set_next

Chengguang Xu (1):
      9p: avoid attaching writeback_fid on mmap with type PRIVATE

C=C3=A9dric Le Goater (1):
      KVM: PPC: Book3S HV: XIVE: Free escalation interrupts before disablin=
g the VP

Dan Melnic (1):
      block/ndb: add WQ_UNBOUND to the knbd-recv workqueue

Dmitry Osipenko (1):
      PM / devfreq: tegra: Fix kHz to Hz conversion

Eric Sandeen (1):
      vfs: Fix EOVERFLOW testing in put_compat_statfs64

Erqi Chen (1):
      ceph: reconnect connection if session hang in opening state

Fabrice Gasnier (1):
      pwm: stm32-lp: Add check in case requested period cannot be achieved

Florian Westphal (1):
      netfilter: nf_tables: allow lookups in dynamic sets

Gautham R. Shenoy (1):
      powerpc/pseries: Fix cpu_hotplug_lock acquisition in resize_hpt()

Greg Kroah-Hartman (1):
      Linux 4.14.149

Herbert Xu (1):
      crypto: skcipher - Unmap pages after an external error

Horia Geant=C4=83 (1):
      crypto: caam - fix concurrency issue in givencrypt descriptor

Ido Schimmel (1):
      thermal: Fix use-after-free when unregistering thermal zone device

Igor Druzhinin (1):
      xen/pci: reserve MCFG areas earlier

Jack Wang (1):
      KVM: nVMX: handle page fault in vmread fix

Jia-Ju Bai (1):
      fs: nfs: Fix possible null-pointer dereferences in encode_attrs()

Jiri Olsa (1):
      perf tools: Fix segfault in cpu_cache_level__read()

Johan Hovold (1):
      ieee802154: atusb: fix use-after-free at disconnect

Johannes Berg (3):
      cfg80211: initialize on-stack chandefs
      cfg80211: add and use strongly typed element iteration macros
      nl80211: validate beacon head

Jouni Malinen (1):
      cfg80211: Use const more consistently in for_each_element macros

Juergen Gross (1):
      xen/xenbus: fix self-deadlock after killing user process

KeMeng Shi (1):
      sched/core: Fix migration to invalid CPU in __set_cpus_allowed_ptr()

Kees Cook (1):
      usercopy: Avoid HIGHMEM pfn warning

Li RongQing (1):
      timer: Read jiffies once when forwarding base clk

Luis Henriques (1):
      ceph: fix directories inode i_blkbits initialization

Marc Kleine-Budde (1):
      can: mcp251x: mcp251x_hw_reset(): allow more time after a reset

Mike Christie (1):
      nbd: fix max number of supported devs

Oleksandr Suvorov (2):
      ASoC: Define a set of DAPM pre/post-up events
      ASoC: sgtl5000: Improve VAG power and mute control

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Don't lose pending doorbell request on migration=
 on P9

Rasmus Villemoes (1):
      watchdog: imx2_wdt: fix min() calculation in imx2_wdt_set_timeout

Russell King (2):
      mmc: sdhci: improve ADMA error reporting
      mmc: sdhci-of-esdhc: set DMA snooping based on DMA coherence

Ryan Chen (1):
      watchdog: aspeed: Add support for AST2600

Sascha Hauer (1):
      ima: always return negative code for error

Srikar Dronamraju (2):
      perf stat: Fix a segmentation fault when using repeat forever
      perf stat: Reset previous counts on repeat with interval

Steven Rostedt (VMware) (2):
      tools lib traceevent: Fix "robust" test of do_generate_dynamic_list_f=
ile
      tools lib traceevent: Do not free tep->cmdlines in add_new_comm() on =
failure

Thomas Huth (1):
      KVM: s390: Test for bad access register and size at the start of S390=
_MEM_OP

Thomas Richter (1):
      perf build: Add detection of java-11-openjdk-devel package

Tomi Valkeinen (1):
      drm/omap: fix max fclk divider for omap36xx

Trek (1):
      drm/amdgpu: Check for valid number of registers to read

Trond Myklebust (1):
      pNFS: Ensure we do clear the return-on-close layout stateid on fatal =
errors

Valdis Kletnieks (1):
      kernel/elfcore.c: include proper prototypes

Vasily Gorbik (4):
      s390/process: avoid potential reading of freed stack
      s390/topology: avoid firing events before kobjs are created
      s390/cio: avoid calling strlen on null pointer
      s390/cio: exclude subchannels with no parent from pseudo check

Wanpeng Li (1):
      Revert "locking/pvqspinlock: Don't wait if vCPU is preempted"

Wei Yongjun (1):
      crypto: cavium/zip - Add missing single_release()

Xiubo Li (1):
      nbd: fix crash when the blksize is zero

zhengbin (1):
      fuse: fix memleak in cuse_channel_open


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2hh3AACgkQONu9yGCS
aT6+7xAAg7QTUAYoac3B1Gd0UXXj8Tj51j0Bisp9DIIEx7xUfM1NmluI9Yi4ygVQ
s2kwks1g5fFYI4AvwZejvSeRQlVPIBkc5TN2uWlwUg1aFYDR1i1+a+InRp65GzEw
7OQ/ac/nrW3fUfa0HMMLFFOB+kqCrrqU24hX3s3skwt4r6oj9kyqfsQmdqwxrYg8
mbD5saeHlUnuuTzhey5z3ntio+TQpvseA/ebF33YJzxDZ/VoX1SixV2zcpMwK0H0
rmAhTDX9u4nAZ3OJGhLHaRh0va4AMd1ioeiwUt2UBsefSGHhkHW69/Y6T9+6OnXc
H1FEq+6pHiQDaFtS+78zX35gT8oc7QRcGCRFBGUL7FZ6dpJEsHFXQmDcnF/l/FM3
e2fSdxF/or3X+wZhEFReI27N6GTuGOCYdzkSHaB35QXB8TKqbdun80+hfc/mgSFA
qFo0CsqYpf0BB6ZjUnRnlfCSYWb0Cr+eP84rX2PB3cFnxBADJeUWbCoQm+qSu5i1
0v2HGYgWjG/59xU2ia3UVMWXFFrCZ74hZqI7/Mg2WCoeEJIUYa1d0eMSEH/9JMIZ
J3ZeNdl5g0paqmm4Ia34tJcmsTl6IZN148aqMsXimuHFshyT3eLzxoUyWWmzSOxw
VZqleIzE/5kB0xA5EthU/CVwdTo/5qPScFaxxwOj5Kn1e9XiJU0=
=InSr
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
