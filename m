Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C0D24A6F1
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 21:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHSTdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 15:33:35 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:58362 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgHSTdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 15:33:31 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 87F4D1C0BCB; Wed, 19 Aug 2020 21:33:26 +0200 (CEST)
Date:   Wed, 19 Aug 2020 21:33:26 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/i915/gem: Replace reloc chain with terminator on
 error unwind
Message-ID: <20200819193326.p62h2dj7jpzfkeyy@duo.ucw.cz>
References: <20200819103952.19083-1-chris@chris-wilson.co.uk>
 <20200819172331.GA4796@amd>
 <159785861047.667.10730572472834322633@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aqiw3ttvxkjmpp4d"
Content-Disposition: inline
In-Reply-To: <159785861047.667.10730572472834322633@build.alporthouse.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aqiw3ttvxkjmpp4d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > If we hit an error during construction of the reloc chain, we need to
> > > replace the chain into the next batch with the terminator so that upon
> > > flushing the relocations so far, we do not execute a hanging batch.
> >=20
> > Thanks for the patches. I assume this should fix problem from
> > "5.9-rc1: graphics regression moved from -next to mainline" thread.
> >=20
> > I have applied them over current -next, and my machine seems to be
> > working so far (but uptime is less than 30 minutes).
> >=20
> > If the machine still works tommorow, I'll assume problem is solved.
>=20
> Aye, best wait until we have to start competing with Chromium for
> memory... The suspicion is that it was the resource allocation failure
> path.

Yep, my machines are low on memory.

But ... test did not work that well. I have dead X and blinking
screen. Machine still works reasonably well over ssh, so I guess
that's an improvement.

Best regards,
							Pavel

[ 5604.909393] ACPI: EC: event unblocked
[ 5604.913590] usb usb2: root hub lost power or was reset
[ 5604.913812] usb usb3: root hub lost power or was reset
[ 5604.914046] usb usb4: root hub lost power or was reset
[ 5604.918812] ata6: port disabled--ignoring
[ 5604.925353] sd 0:0:0:0: [sda] Starting disk
[ 5605.150042] thinkpad_acpi: ACPI backlight control delay disabled
[ 5605.204955] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 5605.205931] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[ 5605.205941] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[ 5605.205949] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[ 5605.207748] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[ 5605.207757] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[ 5605.207765] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[ 5605.208227] ata1.00: configured for UDMA/133
[ 5605.281913] usb 5-2: reset full-speed USB device number 3 using uhci_hcd
[ 5605.569752] usb 5-1: reset full-speed USB device number 2 using uhci_hcd
[ 5609.082771] PM: resume devices took 4.192 seconds
[ 5609.083380] OOM killer enabled.
[ 5609.083387] Restarting tasks ... done.
[ 5609.103164] video LNXVIDEO:00: Restoring backlight state
[ 5609.150144] PM: suspend exit
[ 5609.190535] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 5609.239495] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 5609.287144] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 5609.344497] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 5611.426855] wlan0: authenticate with 5c:f4:ab:10:d2:bb
[ 5611.430609] wlan0: send auth to 5c:f4:ab:10:d2:bb (try 1/3)
[ 5611.432552] wlan0: authenticated
[ 5611.433705] wlan0: associate with 5c:f4:ab:10:d2:bb (try 1/3)
[ 5611.436440] wlan0: RX AssocResp from 5c:f4:ab:10:d2:bb (capab=3D0x411 st=
atus=3D0 aid=3D1)
[ 5611.439083] wlan0: associated
[ 7744.718473] BUG: unable to handle page fault for address: f8c00000
[ 7744.718484] #PF: supervisor write access in kernel mode
[ 7744.718487] #PF: error_code(0x0002) - not-present page
[ 7744.718491] *pdpt =3D 0000000031b0b001 *pde =3D 0000000000000000=20
[ 7744.718500] Oops: 0002 [#1] PREEMPT SMP PTI
[ 7744.718506] CPU: 0 PID: 3004 Comm: Xorg Not tainted 5.9.0-rc1-next-20200=
819+ #134
[ 7744.718509] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 7744.718518] EIP: eb_relocate_vma+0xdbf/0xf20
[ 7744.718523] Code: 48 74 8b 41 08 89 41 0c 8b 85 a4 fd ff ff 89 95 a0 fd =
ff ff e8 c2 12 6c 00 8b 95 a0 fd ff ff e9 03 fc ff ff 8b 85 d0 fd ff ff <c7=
> 03 01 00 40 10 89 43 04 8b 85 dc fd ff ff 89 43 08 e9 4a f6 ff
[ 7744.718527] EAX: 01397010 EBX: f8c00000 ECX: 01247000 EDX: 00000000
[ 7744.718531] ESI: f519cd80 EDI: f1ac1cd4 EBP: f1ac1c6c ESP: f1ac1a04
[ 7744.718535] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00210246
[ 7744.718539] CR0: 80050033 CR2: f8c00000 CR3: 31ac2000 CR4: 000006b0
[ 7744.718543] Call Trace:
[ 7744.718553]  ? shmem_read_mapping_page_gfp+0x32/0x70
[ 7744.718560]  ? eb_lookup_vmas+0x272/0x9f0
[ 7744.718565]  i915_gem_do_execbuffer+0xa7b/0x2730
[ 7744.718573]  ? intel_runtime_pm_put_unchecked+0xd/0x10
[ 7744.718578]  ? i915_gem_gtt_pwrite_fast+0xf6/0x520
[ 7744.718586]  ? __lock_acquire.isra.0+0x223/0x500
[ 7744.718592]  ? cache_alloc_debugcheck_after+0x151/0x180
[ 7744.718596]  ? kvmalloc_node+0x69/0x80
[ 7744.718600]  ? __kmalloc+0x92/0x120
[ 7744.718604]  ? kvmalloc_node+0x69/0x80
[ 7744.718608]  i915_gem_execbuffer2_ioctl+0xdd/0x350
[ 7744.718613]  ? i915_gem_execbuffer_ioctl+0x2a0/0x2a0
[ 7744.718619]  drm_ioctl_kernel+0x91/0xe0
[ 7744.718623]  ? i915_gem_execbuffer_ioctl+0x2a0/0x2a0
[ 7744.718627]  drm_ioctl+0x1fd/0x371
[ 7744.718631]  ? i915_gem_execbuffer_ioctl+0x2a0/0x2a0
[ 7744.718639]  ? posix_get_monotonic_timespec+0x1d/0x80
[ 7744.718645]  ? __sys_recvmsg+0x37/0x80
[ 7744.718649]  ? drm_ioctl_kernel+0xe0/0xe0
[ 7744.718654]  __ia32_sys_ioctl+0x14b/0x7c6
[ 7744.718661]  ? exit_to_user_mode_prepare+0x53/0x100
[ 7744.718667]  do_int80_syscall_32+0x2c/0x40
[ 7744.718674]  entry_INT80_32+0x111/0x111
[ 7744.718678] EIP: 0xb7fd3092
[ 7744.718683] Code: 00 00 00 e9 90 ff ff ff ff a3 24 00 00 00 68 30 00 00 =
00 e9 80 ff ff ff ff a3 e8 ff ff ff 66 90 00 00 00 00 00 00 00 00 cd 80 <c3=
> 8d b4 26 00 00 00 00 8d b6 00 00 00 00 8b 1c 24 c3 8d b4 26 00
[ 7744.718687] EAX: ffffffda EBX: 0000000a ECX: c0406469 EDX: bfe67abc
[ 7744.718691] ESI: b73c1000 EDI: c0406469 EBP: 0000000a ESP: bfe67a34
[ 7744.718695] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00200292
[ 7744.718700]  ? asm_exc_nmi+0xcc/0x2bc
[ 7744.718703] Modules linked in:
[ 7744.718709] CR2: 00000000f8c00000
[ 7744.718714] ---[ end trace 121f748dd4d0d6ec ]---
[ 7744.718719] EIP: eb_relocate_vma+0xdbf/0xf20
[ 7744.718723] Code: 48 74 8b 41 08 89 41 0c 8b 85 a4 fd ff ff 89 95 a0 fd =
ff ff e8 c2 12 6c 00 8b 95 a0 fd ff ff e9 03 fc ff ff 8b 85 d0 fd ff ff <c7=
> 03 01 00 40 10 89 43 04 8b 85 dc fd ff ff 89 43 08 e9 4a f6 ff
[ 7744.718727] EAX: 01397010 EBX: f8c00000 ECX: 01247000 EDX: 00000000
[ 7744.718731] ESI: f519cd80 EDI: f1ac1cd4 EBP: f1ac1c6c ESP: f1ac1a04
[ 7744.718735] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00210246
[ 7744.718739] CR0: 80050033 CR2: f8c00000 CR3: 31ac2000 CR4: 000006b0
[ 7744.723687] BUG: unable to handle page fault for address: f8c02038
[ 7744.723695] #PF: supervisor write access in kernel mode
[ 7744.723699] #PF: error_code(0x0002) - not-present page
[ 7744.723702] *pdpt =3D 0000000031866001 *pde =3D 0000000000000000=20
[ 7744.723711] Oops: 0002 [#2] PREEMPT SMP PTI
[ 7744.723717] CPU: 1 PID: 3004 Comm: Xorg Tainted: G      D           5.9.=
0-rc1-next-20200819+ #134
[ 7744.723720] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 7744.723728] EIP: n_tty_open+0x26/0x80
[ 7744.723733] Code: 00 00 00 90 55 89 e5 56 53 89 c3 b8 f0 22 00 00 e8 4f =
39 cb ff 85 c0 74 62 89 c6 a1 00 2d 27 c5 b9 e8 2a 77 c5 ba 85 83 12 c5 <89=
> 46 38 8d 86 58 22 00 00 e8 8c 12 c0 ff 8d 86 a4 22 00 00 b9 e0
[ 7744.723738] EAX: 001c65c0 EBX: f2339000 ECX: c5772ae8 EDX: c5128385
[ 7744.723741] ESI: f8c02000 EDI: 00000000 EBP: f1ac1ee4 ESP: f1ac1edc
[ 7744.723745] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00210286
[ 7744.723751] CR0: 80050033 CR2: f8c02038 CR3: 31864000 CR4: 000006b0
[ 7744.723755] Call Trace:
[ 7744.723763]  tty_ldisc_open.isra.0+0x23/0x40
[ 7744.723768]  tty_ldisc_reinit+0x99/0xe0
[ 7744.723772]  tty_ldisc_hangup+0xc4/0x1e0
[ 7744.723776]  __tty_hangup.part.0+0x13f/0x250
[ 7744.723781]  tty_vhangup_session+0x11/0x20
[ 7744.723786]  disassociate_ctty.part.0+0x34/0x230
[ 7744.723790]  disassociate_ctty+0x28/0x30
[ 7744.723797]  do_exit+0x456/0x960
[ 7744.723803]  ? exit_to_user_mode_prepare+0x53/0x100
[ 7744.723808]  rewind_stack_do_exit+0x11/0x13
[ 7744.723812] EIP: 0xb7fd3092
[ 7744.723815] Code: Bad RIP value.
[ 7744.723819] EAX: ffffffda EBX: 0000000a ECX: c0406469 EDX: bfe67abc
[ 7744.723823] ESI: b73c1000 EDI: c0406469 EBP: 0000000a ESP: bfe67a34
[ 7744.723827] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00200292
[ 7744.723837]  ? asm_exc_nmi+0xcc/0x2bc
[ 7744.723839] Modules linked in:
[ 7744.723845] CR2: 00000000f8c02038
[ 7744.723851] ---[ end trace 121f748dd4d0d6ed ]---
[ 7744.723857] EIP: eb_relocate_vma+0xdbf/0xf20
[ 7744.723861] Code: 48 74 8b 41 08 89 41 0c 8b 85 a4 fd ff ff 89 95 a0 fd =
ff ff e8 c2 12 6c 00 8b 95 a0 fd ff ff e9 03 fc ff ff 8b 85 d0 fd ff ff <c7=
> 03 01 00 40 10 89 43 04 8b 85 dc fd ff ff 89 43 08 e9 4a f6 ff
[ 7744.723865] EAX: 01397010 EBX: f8c00000 ECX: 01247000 EDX: 00000000
[ 7744.723869] ESI: f519cd80 EDI: f1ac1cd4 EBP: f1ac1c6c ESP: f1ac1a04
[ 7744.723873] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00210246
[ 7744.723877] CR0: 80050033 CR2: f8c02038 CR3: 31864000 CR4: 000006b0
[ 7744.723880] Fixing recursive fault but reboot is needed!
[ 7749.589011] i915 0000:00:02.0: [drm] GPU HANG: ecode 3:0:00000000
[ 7749.589024] GPU hangs can indicate a bug anywhere in the entire gfx stac=
k, including userspace.
[ 7749.589030] Please file a _new_ bug report at https://gitlab.freedesktop=
=2Eorg/drm/intel/issues/new.
[ 7749.589036] Please see https://gitlab.freedesktop.org/drm/intel/-/wikis/=
How-to-file-i915-bugs for details.
[ 7749.589041] drm/i915 developers can then reassign to the right component=
 if it's not a kernel issue.
[ 7749.589047] The GPU crash dump is required to analyze GPU hangs, so plea=
se always attach it.
[ 7749.589053] GPU crash dump saved to /sys/class/drm/card0/error
[ 7749.909841] i915 0000:00:02.0: [drm] Resetting chip for no heartbeat on =
rcs0
[ 7756.504232] i915 0000:00:02.0: [drm] GPU HANG: ecode 3:0:00000000
[ 7756.817879] i915 0000:00:02.0: [drm] Resetting chip for no heartbeat on =
rcs0
[ 7763.672921] i915 0000:00:02.0: [drm] GPU HANG: ecode 3:0:00000000
[ 7763.985882] i915 0000:00:02.0: [drm] Resetting chip for no heartbeat on =
rcs0
[ 7770.580999] i915 0000:00:02.0: [drm] GPU HANG: ecode 3:0:00000000
[ 7770.897884] i915 0000:00:02.0: [drm] Resetting chip for no heartbeat on =
rcs0
[ 7777.497036] i915 0000:00:02.0: [drm] GPU HANG: ecode 3:0:00000000
[ 7777.825882] i915 0000:00:02.0: [drm] Resetting chip for no heartbeat on =
rcs0
[ 7784.664999] i915 0000:00:02.0: [drm] GPU HANG: ecode 3:0:00000000


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--aqiw3ttvxkjmpp4d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXz1+hgAKCRAw5/Bqldv6
8pk5AJ4zwFBiWMiLXhJQX4xq8N/GDTHEYQCePcgOrT/g5SN+mBj5hXL8PTcaUOw=
=TrVo
-----END PGP SIGNATURE-----

--aqiw3ttvxkjmpp4d--
