Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADFA710E14A
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 10:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfLAJmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 04:42:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726256AbfLAJmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Dec 2019 04:42:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75E2F2146E;
        Sun,  1 Dec 2019 09:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575193368;
        bh=pne2iFxz85QIg5Vp39wT525FL+kknT72UEZq7FHBH7U=;
        h=Date:From:To:Cc:Subject:From;
        b=wrOCYjmN3ZcckHqt36fiqQ7PyrIWa14Xuvz53P+CvC8y2cTRT5IDgSRdzk0r5BhDN
         0EywSr6598F9MI264mu/7wMvmeUisdFdeMcxDy6fScwRhZgjh7U89Oip/tXnuHipId
         ltbAfwLvq9gjLtioafQdXPRhlY9IQgQcytzTNg50=
Date:   Sun, 1 Dec 2019 10:42:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.1
Message-ID: <20191201094246.GA3799322@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.1 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/mds.rst                      |    7=20
 Documentation/admin-guide/hw-vuln/tsx_async_abort.rst          |    5=20
 Documentation/admin-guide/kernel-parameters.txt                |   11=20
 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt |    6=20
 Makefile                                                       |    2=20
 arch/powerpc/include/asm/asm-prototypes.h                      |    3=20
 arch/powerpc/include/asm/security_features.h                   |    3=20
 arch/powerpc/kernel/entry_64.S                                 |    6=20
 arch/powerpc/kernel/security.c                                 |   57 +
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                        |   30=20
 arch/x86/entry/entry_32.S                                      |  211 ++++=
--
 arch/x86/include/asm/cpu_entry_area.h                          |   18=20
 arch/x86/include/asm/pgtable_32_types.h                        |    8=20
 arch/x86/include/asm/segment.h                                 |   12=20
 arch/x86/kernel/cpu/bugs.c                                     |   30=20
 arch/x86/kernel/doublefault.c                                  |    3=20
 arch/x86/kernel/head_32.S                                      |   10=20
 arch/x86/mm/cpu_entry_area.c                                   |    4=20
 arch/x86/tools/gen-insn-attr-x86.awk                           |    4=20
 arch/x86/xen/xen-asm_32.S                                      |   75 --
 drivers/block/nbd.c                                            |    5=20
 drivers/bluetooth/hci_bcsp.c                                   |    3=20
 drivers/bluetooth/hci_ll.c                                     |   39 -
 drivers/cpufreq/cpufreq.c                                      |    6=20
 drivers/md/dm-crypt.c                                          |    9=20
 drivers/md/raid10.c                                            |    2=20
 drivers/media/platform/vivid/vivid-kthread-cap.c               |    8=20
 drivers/media/platform/vivid/vivid-kthread-out.c               |    8=20
 drivers/media/platform/vivid/vivid-sdr-cap.c                   |    8=20
 drivers/media/platform/vivid/vivid-vid-cap.c                   |    3=20
 drivers/media/platform/vivid/vivid-vid-out.c                   |    3=20
 drivers/media/rc/imon.c                                        |    3=20
 drivers/media/rc/mceusb.c                                      |  141 +++-
 drivers/media/usb/b2c2/flexcop-usb.c                           |    3=20
 drivers/media/usb/dvb-usb/cxusb.c                              |    3=20
 drivers/media/usb/usbvision/usbvision-video.c                  |   29=20
 drivers/media/usb/uvc/uvc_driver.c                             |   28=20
 drivers/net/wireless/ath/ath10k/pci.c                          |   36 -
 drivers/net/wireless/ath/ath10k/qmi.c                          |   13=20
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c                 |   22=20
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h                 |    1=20
 drivers/net/wireless/ath/ath10k/snoc.c                         |   11=20
 drivers/net/wireless/ath/ath10k/snoc.h                         |    1=20
 drivers/net/wireless/ath/ath10k/usb.c                          |    8=20
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                 |    2=20
 drivers/staging/comedi/drivers/usbduxfast.c                    |   21=20
 drivers/usb/misc/appledisplay.c                                |    8=20
 drivers/usb/misc/chaoskey.c                                    |   24=20
 drivers/usb/serial/cp210x.c                                    |    1=20
 drivers/usb/serial/mos7720.c                                   |    4=20
 drivers/usb/serial/mos7840.c                                   |   16=20
 drivers/usb/serial/option.c                                    |    7=20
 drivers/usb/usbip/Kconfig                                      |    1=20
 drivers/usb/usbip/stub_rx.c                                    |   50 -
 fs/exec.c                                                      |    2=20
 include/linux/compat.h                                         |    2=20
 include/linux/futex.h                                          |   40 -
 include/linux/sched.h                                          |    3=20
 include/linux/sched/mm.h                                       |    6=20
 kernel/exit.c                                                  |   30=20
 kernel/fork.c                                                  |   40 -
 kernel/futex.c                                                 |  324 ++++=
++++--
 sound/pci/hda/patch_hdmi.c                                     |   22=20
 sound/usb/mixer.c                                              |    3=20
 sound/usb/mixer_scarlett_gen2.c                                |   36 -
 tools/arch/x86/tools/gen-insn-attr-x86.awk                     |    4=20
 tools/testing/selftests/x86/mov_ss_trap.c                      |    3=20
 tools/testing/selftests/x86/sigreturn.c                        |   13=20
 tools/usb/usbip/libsrc/usbip_host_common.c                     |    2=20
 69 files changed, 1090 insertions(+), 472 deletions(-)

A Sun (1):
      media: mceusb: fix out of bounds read in MCE receiver buffer

Adam Ford (1):
      Revert "Bluetooth: hci_ll: set operational frequency earlier"

Alan Stern (2):
      media: usbvision: Fix invalid accesses after device disconnect
      media: usbvision: Fix races among open, close, and disconnect

Aleksander Morgado (2):
      USB: serial: option: add support for DW5821e with eSIM support
      USB: serial: option: add support for Foxconn T77W968 LTE modules

Alexander Kapshuk (1):
      x86/insn: Fix awk regexp warnings

Alexander Popov (1):
      media: vivid: Fix wrong locking that causes race conditions on stream=
ing stop

Andy Lutomirski (7):
      x86/doublefault/32: Fix stack canaries in the double fault handler
      x86/entry/32: Use %ss segment where required
      x86/entry/32: Move FIXUP_FRAME after pushing %fs in SAVE_ALL
      x86/entry/32: Unwind the ESPFIX stack earlier on exception entry
      selftests/x86/mov_ss_trap: Fix the SYSENTER test
      selftests/x86/sigreturn/32: Invalidate DS and ES when abusing the ker=
nel
      x86/entry/32: Fix FIXUP_ESPFIX_STACK with user CR3

Bernd Porr (1):
      staging: comedi: usbduxfast: usbduxfast_ai_cmdtest rounding error

Bjorn Andersson (1):
      ath10k: Fix HOST capability QMI incompatibility

Christian Lamparter (1):
      ath10k: restore QCA9880-AR1A (v1) detection

Denis Efremov (1):
      ath9k_hw: fix uninitialized variable data

Geoffrey D. Bennett (1):
      ALSA: usb-audio: Fix Scarlett 6i6 Gen 2 port data

Greg Kroah-Hartman (2):
      usb-serial: cp201x: support Mark-10 digital force gauge
      Linux 5.4.1

Hewenliang (1):
      usbip: tools: fix fd leakage in the function of read_attr_usbip_status

Hui Peng (1):
      ath10k: Fix a NULL-ptr-deref bug in ath10k_usb_alloc_urb_from_pipe

Ingo Molnar (1):
      x86/pti/32: Calculate the various PTI cpu_entry_area sizes correctly,=
 make the CPU_ENTRY_AREA_PAGES assert precise

Jan Beulich (3):
      x86/stackframe/32: Repair 32-bit Xen PV
      x86/xen/32: Make xen_iret_crit_fixup() independent of frame layout
      x86/xen/32: Simplify ring check in xen_iret_crit_fixup()

Johan Hovold (2):
      USB: serial: mos7720: fix remote wakeup
      USB: serial: mos7840: fix remote wakeup

John Pittman (1):
      md/raid10: prevent access of uninitialized resync_pages offset

Kai Shen (1):
      cpufreq: Add NULL checks to show() and store() methods of cpufreq

Laurent Pinchart (1):
      media: uvcvideo: Fix error path in control parsing failure

Michael Ellerman (2):
      powerpc/book3s64: Fix link stack flush on context switch
      KVM: PPC: Book3S HV: Flush link stack on guest exit to host kernel

Mike Snitzer (1):
      Revert "dm crypt: use WQ_HIGHPRI for the IO and crypt workqueues"

Navid Emamdoost (1):
      nbd: prevent memory leak

Oliver Neukum (4):
      media: b2c2-flexcop-usb: add sanity checking
      USBIP: add config dependency for SGL_ALLOC
      USB: chaoskey: fix error case of a timeout
      appledisplay: fix error handling in the scheduled work

Pavel L=F6bl (1):
      USB: serial: mos7840: add USB ID to support Moxa UPort 2210

Peter Zijlstra (2):
      x86/entry/32: Fix IRET exception
      x86/entry/32: Fix NMI vs ESPFIX

Sean Young (1):
      media: imon: invalid dereference in imon_touch_event

Suwan Kim (1):
      usbip: Fix uninitialized symbol 'nents' in stub_recv_cmd_submit()

Takashi Iwai (2):
      ALSA: usb-audio: Fix NULL dereference at parsing BADD
      ALSA: hda - Disable audio component for legacy Nvidia HDMI codecs

Thomas Gleixner (13):
      x86/pti/32: Size initial_page_table correctly
      x86/cpu_entry_area: Add guard page for entry stack on 32bit
      futex: Move futex exit handling into futex code
      futex: Replace PF_EXITPIDONE with a state
      exit/exec: Seperate mm_release()
      futex: Split futex_mm_release() for exit/exec
      futex: Set task::futex_state to DEAD right after handling futex exit
      futex: Mark the begin of futex exit explicitly
      futex: Sanitize exit state handling
      futex: Provide state handling for exec() as well
      futex: Add mutex around futex exit
      futex: Provide distinct return value when owner is exiting
      futex: Prevent exit livelock

Tomas Bortoli (1):
      Bluetooth: Fix invalid-free in bcsp_close()

Vandana BN (1):
      media: vivid: Set vid_cap_streaming and vid_out_streaming to true

Vito Caputo (1):
      media: cxusb: detect cxusb_ctrl_msg error in query

Waiman Long (2):
      x86/speculation: Fix incorrect MDS/TAA mitigation status
      x86/speculation: Fix redundant MDS mitigation message

Yang Tao (1):
      futex: Prevent robust futex exit race


--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3jixYACgkQONu9yGCS
aT5brw//bYAFuxlLY57r9pLn6nY5WZzPGYX0slVPGn65nvNRHpFvFGn3i7g2cxXZ
9P+rusXPCVMBG3sjsXlPHqtrcbpS51af97uX+u/Z78ZGHCDuwOr06gF8m9imqQKU
Qsl8nNEqC8ngo0rWAhI7UVYwizMuUPUJSNEV4cryQlMWB4DMS5W/b43IQ44oIwsE
sxDpiOx5BXGfkC7iNYh+t14tpb6L1WMObRj4PDUV2A7NwxpbhT+cbiZYm46JODz2
SoTcAUd38YoEhIPqX1nPyr0/LhhUSS+g8z1Yp1ZxrlUL3T3i3x0eWjZX14fIV09t
9dhqX0QT0jw1JfdxnxyJ9sbWATzqKoIiuJhHwCL3P0ki04kvOUZ0bkSqUaLxg+jE
HY60RHmTFlx3DVrJzuSWyD2sEHGbMIr93u6nBmnsQL28VtAVe9sT6p1om+6eg5fr
7cv07zEWeQ0X3+B0bzSSqWe/VSES+6yzDdhfzyDV1XeB/MN5V6c4txcKx6Asm853
yoSlManQGqsclmyEG8UGZxk0RqZMISRL85yjusa8vVUpnByFjsTj/5WvmR8nu0RF
Mbt3JEU2oV9x4NT3KZTCeY8fQtb7Z87l8Maz9bIWJk/r2O5koHjEp8qPSQLxa9xb
cMZnWFVN2nNVF5/k3v79Q5Y9Zd94fSyvqEAk0D7cryadux04c6E=
=/PUh
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
