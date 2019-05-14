Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73A461CE80
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 20:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfENSF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 14:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbfENSF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 14:05:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D1FF20881;
        Tue, 14 May 2019 18:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557857125;
        bh=k+8FdvXuBe75v9rBFkVqQpD1bmlqFde+7w36JKOaxxM=;
        h=Date:From:To:Cc:Subject:From;
        b=Lr5OgG/ebB2162BTB+sD2UsKe1xJnNRAtGs43WP4r6lwMmz1b6TAeE8t7hpm1iyqi
         vKx56OvZAW0MH6wwMOvh5GGYWeF4dtVr4Rv56edSk+wgxOu+uJCZb4zaHBp0xC901j
         S1aGkE0lvN+N1rerH9WrrQb9ieUnLZuYYmjEoPM4=
Date:   Tue, 14 May 2019 20:05:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.43
Message-ID: <20190514180522.GA13164@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.43 kernel.

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

 Documentation/ABI/testing/sysfs-devices-system-cpu    |    4=20
 Documentation/admin-guide/hw-vuln/index.rst           |   13=20
 Documentation/admin-guide/hw-vuln/l1tf.rst            |  615 +++++++++++++=
+++++
 Documentation/admin-guide/hw-vuln/mds.rst             |  308 +++++++++
 Documentation/admin-guide/index.rst                   |    6=20
 Documentation/admin-guide/kernel-parameters.txt       |   62 +
 Documentation/admin-guide/l1tf.rst                    |  614 -------------=
----
 Documentation/index.rst                               |    1=20
 Documentation/x86/conf.py                             |   10=20
 Documentation/x86/index.rst                           |    8=20
 Documentation/x86/mds.rst                             |  225 ++++++
 Makefile                                              |    2=20
 arch/powerpc/kernel/security.c                        |    6=20
 arch/powerpc/kernel/setup_64.c                        |    2=20
 arch/s390/kernel/nospec-branch.c                      |    3=20
 arch/x86/entry/common.c                               |    3=20
 arch/x86/events/intel/core.c                          |   20=20
 arch/x86/events/intel/cstate.c                        |    8=20
 arch/x86/events/intel/rapl.c                          |    4=20
 arch/x86/events/msr.c                                 |    8=20
 arch/x86/include/asm/cpufeatures.h                    |    3=20
 arch/x86/include/asm/intel-family.h                   |   33=20
 arch/x86/include/asm/irqflags.h                       |    4=20
 arch/x86/include/asm/msr-index.h                      |   39 -
 arch/x86/include/asm/mwait.h                          |    7=20
 arch/x86/include/asm/nospec-branch.h                  |   50 +
 arch/x86/include/asm/processor.h                      |    6=20
 arch/x86/kernel/cpu/bugs.c                            |  146 ++++
 arch/x86/kernel/cpu/common.c                          |  116 +--
 arch/x86/kernel/cpu/intel_rdt_pseudo_lock.c           |    4=20
 arch/x86/kernel/nmi.c                                 |    4=20
 arch/x86/kernel/traps.c                               |    8=20
 arch/x86/kernel/tsc.c                                 |    2=20
 arch/x86/kernel/tsc_msr.c                             |   10=20
 arch/x86/kvm/cpuid.c                                  |    5=20
 arch/x86/kvm/vmx.c                                    |    7=20
 arch/x86/mm/pti.c                                     |    4=20
 arch/x86/platform/atom/punit_atom_debug.c             |    4=20
 arch/x86/platform/intel-mid/device_libs/platform_bt.c |    2=20
 drivers/acpi/acpi_lpss.c                              |    2=20
 drivers/acpi/x86/utils.c                              |    2=20
 drivers/base/cpu.c                                    |    8=20
 drivers/cpufreq/intel_pstate.c                        |    4=20
 drivers/edac/pnd2_edac.c                              |    2=20
 drivers/idle/intel_idle.c                             |   18=20
 drivers/mmc/host/sdhci-acpi.c                         |    2=20
 drivers/pci/pci-mid.c                                 |    4=20
 drivers/platform/x86/intel_int0002_vgpio.c            |    2=20
 drivers/platform/x86/intel_mid_powerbtn.c             |    4=20
 drivers/platform/x86/intel_telemetry_debugfs.c        |    2=20
 drivers/platform/x86/intel_telemetry_pltdrv.c         |    2=20
 drivers/powercap/intel_rapl.c                         |   10=20
 drivers/thermal/intel_soc_dts_thermal.c               |    2=20
 include/linux/cpu.h                                   |   26=20
 kernel/cpu.c                                          |   15=20
 sound/soc/intel/boards/bytcr_rt5651.c                 |    2=20
 tools/power/x86/turbostat/Makefile                    |    2=20
 tools/power/x86/turbostat/turbostat.c                 |   46 -
 tools/power/x86/x86_energy_perf_policy/Makefile       |    2=20
 59 files changed, 1730 insertions(+), 803 deletions(-)

Andi Kleen (2):
      x86/speculation/mds: Add basic bug infrastructure for MDS
      x86/kvm: Expose X86_FEATURE_MD_CLEAR to guests

Boris Ostrovsky (1):
      x86/speculation/mds: Fix comment

Eduardo Habkost (1):
      kvm: x86: Report STIBP on GET_SUPPORTED_CPUID

Greg Kroah-Hartman (1):
      Linux 4.19.43

Josh Poimboeuf (9):
      x86/speculation/mds: Add mds=3Dfull,nosmt cmdline option
      x86/speculation: Move arch_smt_update() call to after mitigation deci=
sions
      x86/speculation/mds: Add SMT warning message
      cpu/speculation: Add 'mitigations=3D' cmdline option
      x86/speculation: Support 'mitigations=3D' cmdline option
      powerpc/speculation: Support 'mitigations=3D' cmdline option
      s390/speculation: Support 'mitigations=3D' cmdline option
      x86/speculation/mds: Add 'mitigations=3D' support for MDS
      x86/speculation/mds: Fix documentation typo

Konrad Rzeszutek Wilk (1):
      x86/speculation/mds: Print SMT vulnerable on MSBDS with mitigations o=
ff

Peter Zijlstra (1):
      x86/cpu: Sanitize FAM6_ATOM naming

Salvatore Bonaccorso (1):
      Documentation/l1tf: Fix small spelling typo

Thomas Gleixner (12):
      x86/msr-index: Cleanup bit defines
      x86/speculation: Consolidate CPU whitelists
      x86/speculation/mds: Add BUG_MSBDS_ONLY
      x86/speculation/mds: Add mds_clear_cpu_buffers()
      x86/speculation/mds: Clear CPU buffers on exit to user
      x86/kvm/vmx: Add MDS protection when L1D Flush is not active
      x86/speculation/mds: Conditionally clear CPU buffers on idle entry
      x86/speculation/mds: Add mitigation control for MDS
      x86/speculation/mds: Add sysfs reporting for MDS
      x86/speculation/mds: Add mitigation mode VMWERV
      Documentation: Move L1TF to separate directory
      Documentation: Add MDS vulnerability documentation

Tyler Hicks (1):
      Documentation: Correct the possible MDS sysfs values

speck for Pawan Gupta (1):
      x86/mds: Add MDSUM variant to the MDS documentation


--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzbA2IACgkQONu9yGCS
aT6Vaw//bQT5H0BOoSh6vtI64UPf/GJ0b10h5I0kUjPztaLUrENjIkBhsIpr6R26
r6nzfMpstKbkdJVV40Fug1wKX6S8fpZNqB71vrm0m/m9SLdJKhK1y3dvBCGrOar7
ig6O8FD7hADDwfee9bla7KYS/jU3o1pyM+dGOpIveIP+s1FgqOC1SfQsFNwyabjV
6ksg9KY1259wFhSVhvSDLfY5N/6onI8YtLgV8/idFp3zM1hjQvVxbxHbCwlYb9nN
5ByNSNNCkCr8vNegW0Nb/QCaDDJ6ojRXQtxDHxxGPKk+zujwf9BKimuQCHnz9nuN
DPmE4tUcddzCcu0mGpipP4Yqi547PHFi0wTINx+fSACAEtEf5ctPLTfaDDgADrv1
nNg09ji89eZTtR/5MbcnL69+oJhk0BWo6VgOLZaLZJdL6vApEkocYHb92MwnARqK
YoU3ocb0Udljk+MaHhrn7M469lX6HewOHIaUxhnmeiR8YrL54SLUD0gPkXnC3y1Q
lnxWeE+GzlIV7YxgAKSEUFG/E+DuWuKHXY9qnPYRKtlDBMtBDiKDqWpdi41Mpdb0
ZUZRssj8Tr1YZSc02vARXATpoivIwmdyCSI6n03IoUT5hk6E9hMqgas/YNLQOeed
9iLnPQBw46zlyKAl6lev7TTKPkyBVZiM935l18L7031ewgd5tLI=
=xU7N
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
