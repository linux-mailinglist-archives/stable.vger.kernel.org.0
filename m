Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4B54B8C4
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 14:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfFSMiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 08:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727314AbfFSMiv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 08:38:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5D78214AF;
        Wed, 19 Jun 2019 12:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560947930;
        bh=Fp8SU+M1CRtdifddePEie87XgMQR+Je5pQgBdgGEBck=;
        h=Date:From:To:Cc:Subject:From;
        b=1yE81a+NSLBIHffNsNWIWUOHaXuoR3J/eyTPLPUAEDsHFGm+vrSKBpANlJVJUtYI3
         UxI3ymWVhcr8e+laBwBF23PfPL38cUx7onjt16tOSDKyDkTjqTsMCeA9uqHgE/9gdx
         9mxyi9GBBsbE7LTF/mYK7g/ZjDcmh1Xyq7a8X0q8=
Date:   Wed, 19 Jun 2019 14:38:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.128
Message-ID: <20190619123848.GA7325@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.128 kernel.

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

 Makefile                                        |    2=20
 arch/arm64/mm/mmu.c                             |   11 ++-
 arch/s390/include/asm/uaccess.h                 |    2=20
 arch/s390/kvm/kvm-s390.c                        |   35 ++++++-----
 arch/x86/kernel/cpu/microcode/core.c            |    2=20
 arch/x86/kvm/pmu_intel.c                        |   13 ++--
 arch/x86/mm/kasan_init_64.c                     |    2=20
 drivers/ata/libata-core.c                       |    9 +-
 drivers/gpu/drm/i915/intel_sdvo.c               |   58 +++++++++++++++---
 drivers/gpu/drm/i915/intel_sdvo_regs.h          |    3=20
 drivers/gpu/drm/nouveau/Kconfig                 |   13 +++-
 drivers/gpu/drm/nouveau/nouveau_drm.c           |    7 +-
 drivers/gpu/drm/nouveau/nouveau_ttm.c           |    4 +
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c         |    7 +-
 drivers/hid/wacom_wac.c                         |   21 ++++--
 drivers/i2c/busses/i2c-acorn.c                  |    1=20
 drivers/iommu/arm-smmu.c                        |   15 +++-
 drivers/md/bcache/bset.c                        |   16 ++++-
 drivers/md/bcache/bset.h                        |   34 ++++++----
 drivers/media/v4l2-core/v4l2-ioctl.c            |   17 +++++
 drivers/misc/kgdbts.c                           |    4 -
 drivers/net/usb/ipheth.c                        |    3=20
 drivers/nvdimm/bus.c                            |    4 -
 drivers/nvdimm/label.c                          |    2=20
 drivers/nvdimm/label.h                          |    2=20
 drivers/nvme/host/core.c                        |    2=20
 drivers/platform/x86/pmc_atom.c                 |   33 ++++++++++
 drivers/ras/cec.c                               |   34 ++++++----
 drivers/rtc/rtc-pcf8523.c                       |   32 +++++++---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                |    2=20
 drivers/scsi/lpfc/lpfc_els.c                    |    5 +
 drivers/scsi/qedi/qedi_dbg.c                    |   32 ++--------
 drivers/scsi/qedi/qedi_iscsi.c                  |    4 -
 drivers/usb/core/quirks.c                       |    3=20
 drivers/usb/dwc2/hcd.c                          |   39 +++++++-----
 drivers/usb/dwc2/hcd.h                          |   20 +++---
 drivers/usb/dwc2/hcd_intr.c                     |    5 -
 drivers/usb/dwc2/hcd_queue.c                    |   10 +--
 drivers/usb/serial/option.c                     |    6 +
 drivers/usb/serial/pl2303.c                     |    1=20
 drivers/usb/serial/pl2303.h                     |    3=20
 drivers/usb/storage/unusual_realtek.h           |    5 +
 fs/ocfs2/dcache.c                               |   12 +++
 include/linux/cgroup.h                          |   10 ++-
 include/linux/cpuhotplug.h                      |    1=20
 kernel/Makefile                                 |    1=20
 kernel/cred.c                                   |    9 ++
 kernel/ptrace.c                                 |   20 +++++-
 mm/list_lru.c                                   |    2=20
 mm/vmscan.c                                     |    2=20
 sound/core/seq/seq_clientmgr.c                  |   10 ---
 sound/core/seq/seq_ports.c                      |   13 ++--
 sound/core/seq/seq_ports.h                      |    5 -
 sound/firewire/motu/motu-stream.c               |    2=20
 sound/firewire/oxfw/oxfw.c                      |    3=20
 sound/pci/hda/patch_realtek.c                   |   75 +++++++++++++++++++=
-----
 sound/soc/codecs/cs42xx8.c                      |    1=20
 sound/soc/fsl/fsl_asrc.c                        |    4 -
 tools/testing/selftests/timers/adjtick.c        |    1=20
 tools/testing/selftests/timers/leapcrash.c      |    1=20
 tools/testing/selftests/timers/mqueue-lat.c     |    1=20
 tools/testing/selftests/timers/nanosleep.c      |    1=20
 tools/testing/selftests/timers/nsleep-lat.c     |    1=20
 tools/testing/selftests/timers/raw_skew.c       |    1=20
 tools/testing/selftests/timers/set-tai.c        |    1=20
 tools/testing/selftests/timers/set-tz.c         |    2=20
 tools/testing/selftests/timers/threadtest.c     |    1=20
 tools/testing/selftests/timers/valid-adjtimex.c |    2=20
 68 files changed, 502 insertions(+), 203 deletions(-)

Andrey Ryabinin (1):
      x86/kasan: Fix boot with 5-level paging and KASAN

Baruch Siach (1):
      rtc: pcf8523: don't return invalid date when battery is low

Bernd Eckstein (1):
      usbnet: ipheth: fix racing condition

Borislav Petkov (2):
      RAS/CEC: Fix binary search function
      x86/microcode, cpuhotplug: Add a microcode loader CPU hotplug callback

Chris Packham (1):
      USB: serial: pl2303: add Allied Telesis VT-Kit3

Christian Borntraeger (1):
      KVM: s390: fix memory slot handling for KVM_SET_USER_MEMORY_REGION

Christoph Hellwig (1):
      nvme: remove the ifdef around nvme_nvm_ioctl

Colin Ian King (1):
      scsi: bnx2fc: fix incorrect cast to u64 on shift operation

Coly Li (1):
      bcache: fix stack corruption by PRECEDING_KEY()

Daniele Palmas (1):
      USB: serial: option: add Telit 0x1260 and 0x1261 compositions

Dave Airlie (1):
      drm/nouveau: add kconfig option to turn off nouveau legacy contexts. =
(v3)

Douglas Anderson (1):
      usb: dwc2: host: Fix wMaxPacketSize handling (fix webcam regression)

Eric W. Biederman (1):
      signal/ptrace: Don't leak unitialized kernel memory with PTRACE_PEEK_=
SIGINFO

Greg Kroah-Hartman (1):
      Linux 4.14.128

Hans Verkuil (1):
      media: v4l2-ioctl: clear fields in s_parm

Hans de Goede (2):
      libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk
      platform/x86: pmc_atom: Add Lex 3I380D industrial PC to critclk_syste=
ms DMI table

James Smart (1):
      scsi: lpfc: add check for loss of ndlp when sending RRQ

Jann Horn (1):
      ptrace: restore smp_rmb() in __ptrace_may_access()

Jason Gerecke (2):
      HID: wacom: Correct button numbering 2nd-gen Intuos Pro over Bluetooth
      HID: wacom: Sync INTUOSP2_BT touch state after each frame if necessary

J=F6rgen Storvist (1):
      USB: serial: option: add support for Simcom SIM7500/SIM7600 RNDIS mode

Kai-Heng Feng (1):
      USB: usb-storage: Add new ID to ums-realtek

Kailang Yang (1):
      ALSA: hda/realtek - Update headset mode for ALC256

Kees Cook (1):
      selftests/timers: Add missing fflush(stdout) calls

Marco Zatta (1):
      USB: Fix chipmunk-like voice when using Logitech C270 for recording a=
udio.

Mark Rutland (1):
      arm64/mm: Inhibit huge-vmap with ptdump

Martin Schiller (1):
      usb: dwc2: Fix DMA cache alignment issues

Minchan Kim (1):
      mm/vmscan.c: fix trying to reclaim unevictable LRU page

Murray McAllister (2):
      drm/vmwgfx: integer underflow in vmw_cmd_dx_set_shader() leading to a=
n invalid read
      drm/vmwgfx: NULL pointer dereference from vmw_cmd_dx_view_define()

Paolo Bonzini (1):
      KVM: x86/pmu: do not mask the value that is written to fixed PMUs

Peter Zijlstra (1):
      x86/uaccess, kcov: Disable stack protector

Qian Cai (1):
      libnvdimm: Fix compilation warnings with W=3D1

Robin Murphy (1):
      iommu/arm-smmu: Avoid constant zero in TLBI writes

Russell King (1):
      i2c: acorn: fix i2c warning

S.j. Wang (2):
      ASoC: cs42xx8: Add regcache mask dirty
      ASoC: fsl_asrc: Fix the issue about unsupported rate

Shakeel Butt (1):
      mm/list_lru.c: fix memory leak in __memcg_init_list_lru_node

Steffen Dirkwinkel (1):
      platform/x86: pmc_atom: Add several Beckhoff Automation boards to cri=
tclk_systems DMI table

Takashi Iwai (3):
      ALSA: seq: Protect in-kernel ioctl calls with mutex
      ALSA: seq: Fix race of get-subscription call vs port-delete ioctls
      Revert "ALSA: seq: Protect in-kernel ioctl calls with mutex"

Takashi Sakamoto (2):
      ALSA: oxfw: allow PCM capture for Stanton SCS.1m
      ALSA: firewire-motu: fix destruction of data for isochronous resources

Tejun Heo (1):
      cgroup: Use css_tryget() instead of css_tryget_online() in task_get_c=
ss()

Thomas Backlund (1):
      nouveau: Fix build with CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT disabled

Vasily Gorbik (1):
      s390/kasan: fix strncpy_from_user kasan checks

Ville Syrj=E4l=E4 (1):
      drm/i915/sdvo: Implement proper HDMI audio support for SDVO

Wengang Wang (1):
      fs/ocfs2: fix race in ocfs2_dentry_attach_lock()

Young Xiao (1):
      Drivers: misc: fix out-of-bounds access in function param_set_kgdbts_=
var

YueHaibing (2):
      scsi: qedi: remove memset/memcpy to nfunc and use func instead
      scsi: qedi: remove set but not used variables 'cdev' and 'udev'


--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0KLNgACgkQONu9yGCS
aT4qpRAAw7fUi0EkCUf+gqQXlrXApjqLB5ehge2EM4CUMmXlN69F+h/zp6Wa6ybq
xkk33F+2ymuV7rO98a8TgSgFUJ74AFuooTZ/txogJtH916EInZAPrEwujrfBgaPQ
5p557xkjSQCt6ql345DKkHlHp9M4Hz5NZacNw/3gbSGM8nL5icfRjnDMFvQKRGRU
gzd6jQiTMWt3Pkh9F83REsM5Ym0sEBwokTxyRo7lQWqffOAg8twvLbgBTPe45mEf
r3NV60Iqize8jqyqeWmw92Rx3cVYUyVl12EvP1mEXjj4cdef9PJtck5nxrOb6d+n
bG0YPzpiUvTI4sJazaTry0UaaCso9Wut63e4ZDGQYx9gVJzWFg8nLsK+ils3IAMo
fA8UkF1eKiZy+6Crf+gkrAiTIC4fS60wksmwDcJhgHYRT3CrWU9KwsS1CjSQ12fo
fgw7HPQbqwgRFRkwoAG+ubreyYF03bjOH+mqPmg4QaNYK81JzjwjR+ZDKbCcfCee
KSaVLLMG8xN4tmzZfXnXA7KiaXRI7uMgM4+Ru7E3TlgCCUQ3NTDdOHsch3wJsZoP
LJfNsEMEmaSg/FcaUM0k9NloHs3V7eQJYCvYHYzGqTigSQn7/I7bDqVfBZ/YF54p
jrYX/Ub9IK1czFe6yfugX0j82IAikuhXuefkXtAxiia1DbVYGpA=
=umMK
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
