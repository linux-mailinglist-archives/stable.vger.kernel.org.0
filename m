Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B0D10002D
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 09:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfKRIPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 03:15:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfKRIPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 03:15:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA6B420740;
        Mon, 18 Nov 2019 08:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574064902;
        bh=MtRcj7TYgpaKK4o46mNHhaFxPKrwinUNMQVZy1ibEXA=;
        h=Date:From:To:Cc:Subject:From;
        b=i6qgiK5omj0E3VzuEDFHElWa+Z7CIoeWpNsfesHK/QwzmwQ+tEN6h+81prCCv5Tem
         kkd7CaJrKKvoOY1ADUwnryfzA3nwdeqWrcfOgE4lZtOxQE0mZtinHB9WpN1CpurKQr
         nWvzJoya2gQQ1OnszxbU0WYlXtyPGmNp3UOb9r4A=
Date:   Mon, 18 Nov 2019 09:14:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.202
Message-ID: <20191118081459.GA134166@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.202 kernel.

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

 Documentation/ABI/testing/sysfs-devices-system-cpu |    2=20
 Documentation/hw-vuln/index.rst                    |    2=20
 Documentation/hw-vuln/multihit.rst                 |  163 +++++++
 Documentation/hw-vuln/tsx_async_abort.rst          |  276 ++++++++++++
 Documentation/kernel-parameters.txt                |   92 ++++
 Documentation/virtual/kvm/locking.txt              |    6=20
 Documentation/x86/index.rst                        |    1=20
 Documentation/x86/tsx_async_abort.rst              |  117 +++++
 Makefile                                           |    2=20
 arch/mips/bcm63xx/reset.c                          |    2=20
 arch/s390/kvm/kvm-s390.c                           |    4=20
 arch/x86/Kconfig                                   |   45 ++
 arch/x86/include/asm/cpufeatures.h                 |    2=20
 arch/x86/include/asm/kvm_host.h                    |    6=20
 arch/x86/include/asm/msr-index.h                   |   16=20
 arch/x86/include/asm/nospec-branch.h               |    4=20
 arch/x86/include/asm/processor.h                   |    7=20
 arch/x86/kernel/cpu/Makefile                       |    2=20
 arch/x86/kernel/cpu/bugs.c                         |  161 +++++++
 arch/x86/kernel/cpu/common.c                       |   93 ++--
 arch/x86/kernel/cpu/cpu.h                          |   18=20
 arch/x86/kernel/cpu/intel.c                        |    5=20
 arch/x86/kernel/cpu/tsx.c                          |  140 ++++++
 arch/x86/kvm/cpuid.c                               |    8=20
 arch/x86/kvm/mmu.c                                 |  452 ++++++++++++++++=
-----
 arch/x86/kvm/mmu.h                                 |   21=20
 arch/x86/kvm/mmutrace.h                            |   59 ++
 arch/x86/kvm/paging_tmpl.h                         |   79 ++-
 arch/x86/kvm/svm.c                                 |   10=20
 arch/x86/kvm/vmx.c                                 |   27 -
 arch/x86/kvm/x86.c                                 |   61 ++
 drivers/base/cpu.c                                 |   17=20
 drivers/bluetooth/hci_ldisc.c                      |    3=20
 drivers/usb/gadget/udc/core.c                      |    5=20
 include/linux/cpu.h                                |   30 -
 include/linux/kvm_host.h                           |    8=20
 include/linux/usb/gadget.h                         |    2=20
 kernel/cpu.c                                       |   27 +
 virt/kvm/kvm_main.c                                |  132 +++++-
 39 files changed, 1854 insertions(+), 253 deletions(-)

Ben Hutchings (1):
      KVM: x86: Add is_executable_pte()

Gomez Iglesias, Antonio (1):
      Documentation: Add ITLB_MULTIHIT documentation

Greg Kroah-Hartman (1):
      Linux 4.9.202

Jack Pham (1):
      usb: gadget: core: unmap request from DMA only if previously mapped

Jonas Gorski (1):
      MIPS: BCM63XX: fix switch core reset on BCM6368

Josh Poimboeuf (1):
      x86/speculation/taa: Fix printing of TAA_MSG_SMT on IBRS_ALL CPUs

Junaid Shahid (5):
      kvm: mmu: Don't read PDPTEs when paging is not enabled
      kvm: Convert kvm_lock to a mutex
      kvm: x86: Do not release the page inside mmu_set_spte()
      kvm: Add helper function for creating VM worker threads
      kvm: x86: mmu: Recovery of shattered NX large pages

Kefeng Wang (1):
      Bluetooth: hci_ldisc: Postpone HCI_UART_PROTO_READY bit set in hci_ua=
rt_set_proto()

Michal Hocko (1):
      x86/tsx: Add config options to set tsx=3Don|off|auto

Paolo Bonzini (9):
      KVM: x86: use Intel speculation bugs and features as derived in gener=
ic x86 code
      KVM: x86: simplify ept_misconfig
      KVM: x86: extend usage of RET_MMIO_PF_* constants
      KVM: x86: make FNAME(fetch) and __direct_map more similar
      KVM: x86: remove now unneeded hugepage gfn adjustment
      KVM: x86: change kvm_mmu_page_get_gfn BUG_ON to WARN_ON
      KVM: x86: add tracepoints around __direct_map and FNAME(fetch)
      KVM: vmx, svm: always run with EFER.NXE=3D1 when shadow paging is act=
ive
      kvm: mmu: ITLB_MULTIHIT mitigation

Pawan Gupta (8):
      x86/msr: Add the IA32_TSX_CTRL MSR
      x86/cpu: Add a helper function x86_read_arch_cap_msr()
      x86/cpu: Add a "tsx=3D" cmdline option with TSX disabled by default
      x86/speculation/taa: Add mitigation for TSX Async Abort
      x86/speculation/taa: Add sysfs reporting for TSX Async Abort
      kvm/x86: Export MDS_NO=3D0 to guests when TSX is enabled
      x86/tsx: Add "auto" option to the tsx=3D cmdline parameter
      x86/speculation/taa: Add documentation for TSX Async Abort

Tyler Hicks (1):
      cpu/speculation: Uninline and export CPU mitigations helpers

Vineela Tummalapalli (1):
      x86/bugs: Add ITLB_MULTIHIT bug infrastructure


--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3SUwAACgkQONu9yGCS
aT4nBBAAtGB6oOIrlpB+1gkHUkFkIp4+Jmf+3rC9WPirOl3wVV5amN/N6ttZehta
O0COtD2jUSQERUyAaFv9+fSDdhC9B8MnkB6qW6dUI8hJrkUwIzctRu2WjrdqVrO+
PgmBrlNpJSbzPz2Z37FwJ4X6m6gkV1th7xCbTJum/0546xmmSUJR/IlUIUFZr+6J
8+gDIFgXYz2+tBJSlPsrIrUwKScdXA8h01SrWEq7uaHjYAypAMF4uJyPonBCiU+z
Eud7sMh0LwgOVds5RDAuww+lCOrv3mb2mzrlV4cnuXn1rI65OBuW5AaLSim3wrfx
n+JHieXLGB/M6qAciBCzp+WT1wgXL0qX6yao/1Wtcv0to4ASn4m32t6VqIjIooE1
/FbvCBM+VKEV0Qbr3oM1T7M+2dCtbxMrZI1sj7P3AamDjVCxxPVg202GunPo+paU
/ipDAfML142ZTDD/HgaPR5dv9eXSi1mLjQYwwFmpzjmdP/vEffp6CN6/4bnBT7Jy
1+Dh/CzDAe2em/t8439bNs6SCmxS5dr9kOL2YyJ2NwULKB1Yf6ydZUdOUtBkt5su
cGnGrxp9ssTCItki4MTsKZcrSzCk74ll8jido10DAh8/1gSFzc+vlDzIw4z8hw7C
0f8YerH+PjLlnbZqv5lotljIScJgilSpkNVZkGAGBxtZTrzRUFc=
=g4yC
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
