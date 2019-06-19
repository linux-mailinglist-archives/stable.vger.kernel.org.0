Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66ABF4B8B9
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 14:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731785AbfFSMg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 08:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731711AbfFSMg2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 08:36:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BD8E206BA;
        Wed, 19 Jun 2019 12:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560947787;
        bh=dNtz+UmXEwOaFLmPld0uQip6OX9jvbsdKr0MPC33wtI=;
        h=Date:From:To:Cc:Subject:From;
        b=MzrFIf6HBUBJmK1GADHtQyiO4WAVxOcZ6ooiFprKVQ8zvPcT9Hr99MlCerjqnzjLR
         lgIwmxplEyZF8MKoh5Zz+H/7eVkGfPp2pe8sp34Kx4H+FtxTh99fyd70H0rcwWRZPD
         v1E37VJj+T4kKX1eVr4X/8pUuAGFqikQ81OvLLpY=
Date:   Wed, 19 Jun 2019 14:36:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.53
Message-ID: <20190619123624.GA6864@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.53 kernel.

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

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Andrey Ryabinin (1):
      x86/kasan: Fix boot with 5-level paging and KASAN

Baoquan He (1):
      x86/mm/KASLR: Compute the size of the vmemmap section properly

Baruch Siach (1):
      rtc: pcf8523: don't return invalid date when battery is low

Benjamin Tissoires (1):
      HID: multitouch: handle faulty Elo touch device

Bernd Eckstein (1):
      usbnet: ipheth: fix racing condition

Borislav Petkov (2):
      RAS/CEC: Fix binary search function
      x86/microcode, cpuhotplug: Add a microcode loader CPU hotplug callback

Chris Packham (1):
      USB: serial: pl2303: add Allied Telesis VT-Kit3

Christian Borntraeger (1):
      KVM: s390: fix memory slot handling for KVM_SET_USER_MEMORY_REGION

Christoph Hellwig (4):
      nvme: fix srcu locking on error return in nvme_get_ns_from_disk
      nvme: remove the ifdef around nvme_nvm_ioctl
      nvme: merge nvme_ns_ioctl into nvme_ioctl
      nvme: release namespace SRCU protection before performing controller =
ioctls

Colin Ian King (1):
      scsi: bnx2fc: fix incorrect cast to u64 on shift operation

Coly Li (2):
      bcache: fix stack corruption by PRECEDING_KEY()
      bcache: only set BCACHE_DEV_WB_RUNNING when cached device attached

Cong Wang (1):
      RAS/CEC: Convert the timer callback to a workqueue

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
      Linux 4.19.53

Hangbin Liu (1):
      selftests: fib_rule_tests: fix local IPv4 address typo

Hans de Goede (2):
      libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk
      platform/x86: pmc_atom: Add Lex 3I380D industrial PC to critclk_syste=
ms DMI table

Hui Wang (1):
      Revert "ALSA: hda/realtek - Improve the headset mic for Acer Aspire l=
aptops"

James Morse (1):
      KVM: arm/arm64: Move cc/it checks under hyp's Makefile to avoid instr=
umentation

James Smart (2):
      scsi: lpfc: correct rcu unlock issue in lpfc_nvme_info_show
      scsi: lpfc: add check for loss of ndlp when sending RRQ

Jani Nikula (2):
      drm/edid: abstract override/firmware EDID retrieval
      drm: add fallback override/firmware EDID modes workaround

Jann Horn (1):
      ptrace: restore smp_rmb() in __ptrace_may_access()

Jason Gerecke (5):
      HID: wacom: Don't set tool type until we're in range
      HID: wacom: Don't report anything prior to the tool entering range
      HID: wacom: Send BTN_TOUCH in response to INTUOSP2_BT eraser contact
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

Paolo Bonzini (2):
      KVM: x86/pmu: mask the result of rdpmc according to the width of the =
counters
      KVM: x86/pmu: do not mask the value that is written to fixed PMUs

Peter Zijlstra (1):
      x86/uaccess, kcov: Disable stack protector

Prarit Bhargava (1):
      x86/resctrl: Prevent NULL pointer dereference when local MBM is disab=
led

Qian Cai (1):
      libnvdimm: Fix compilation warnings with W=3D1

Randall Huang (1):
      f2fs: fix to avoid accessing xattr across the boundary

Robin Murphy (1):
      iommu/arm-smmu: Avoid constant zero in TLBI writes

Russell King (1):
      i2c: acorn: fix i2c warning

S.j. Wang (2):
      ASoC: cs42xx8: Add regcache mask dirty
      ASoC: fsl_asrc: Fix the issue about unsupported rate

Shakeel Butt (1):
      mm/list_lru.c: fix memory leak in __memcg_init_list_lru_node

Stefan Raspl (1):
      tools/kvm_stat: fix fields filter for child events

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

Thomas Gleixner (1):
      timekeeping: Repair ktime_get_coarse*() granularity

Tom Zanussi (1):
      tracing: Prevent hist_field_var_ref() from accessing NULL tracing_map=
_elts

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

Yufen Yu (1):
      nvme: fix memory leak for power latency tolerance


--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0KLEgACgkQONu9yGCS
aT6lWw/+OFYVnn09Sir3TXSstJthE8741wibUarAlYQ60hZhPzYSN5EgxWk42efT
S0tWXnGTrxgD+zZff2coCKhqgZ12yYX3U91cWXqaxnc3QSNv5Kl8zKfYe+xAE5Wr
zbkqMRE/ADeGD6HoZwdOtoIOhVLtGYlzGfVCe2YUL89SoU8d4Lc7ZtH4WsGVLR57
pv05kCaX0Js5uB9lBMSGZlMJv4zkM+h7pa1y3bCA6FiBSAlOyPa7xsJOPa2ELDm+
kqvxWJZACoiL0O4//YSnmFL3tuaMxBUbKnnqx137qp1c/7ygOTxqQFVSu/eQBP68
BT48Emw3PuJtHaoMdnnmiJZVn8O+FMT5FDY1WtaDV8QehENYTZSrwZKNvOWCtwLj
zMuKwfRWx+kfgJPHI1jwoVOU/HDMnhI3LrU89lZbrO27A6iY80j9u9bZ6E4uMtIS
YDqvBaKl0iBNY4F0iGhzSU88x8VgwMBuJMc8DZg+O68baS9dffSYHrZ3bvty0UC6
foDfnF5bkv29K5LdBY8Bntk25xaQdF+Q4idK5N35ZZg3JYnD2vaHXBHUVMtmJz7J
i2/AAHBOppBhCtColuv7E1hNjvQrwjBrntsSBARpGx20TPH5un2igQlrAI5p6QuT
WdnfsPr/bEBH1SGZZxnbOcMSg3Mdg6gWjCXGXk7ieAAvWUWut5k=
=unGQ
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
