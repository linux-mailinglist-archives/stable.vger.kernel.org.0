Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 439FA1A7A7
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 13:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfEKLTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 07:19:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60909 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728518AbfEKLTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 May 2019 07:19:46 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id DA7AE8033F; Sat, 11 May 2019 13:19:32 +0200 (CEST)
Date:   Sat, 11 May 2019 13:19:45 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/66] 4.19.42-stable review
Message-ID: <20190511111945.GA27538@amd>
References: <20190509181301.719249738@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.42 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat 11 May 2019 06:11:18 PM UTC.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.42=
-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.19.y
> and the diffstat can be found below.

I reviewed these patches and found them ok:

    /- commit in linux-stable-rc.git linux-4.19.
    |            /- mainline commit it references.
a | c9849e7b0d19 03110a5cb216 | arm64: futex: Bound number of LDXR/STXR loo=
ps in FUTEX_WAKE_OP
a | 7f70094a664c 0efa3334d65b | ASoC: Intel: avoid Oops if DMA setup fails
a diff has whitespace problems | b47e4bc2c6bf 3ae62a42090f | UAS: fix align=
ment of scatter/gather segments
a | d93b3794e11d a1616a5ac99e | Bluetooth: hidp: fix buffer overflow
a | 390fb51f14ed 2137490f2147 | scsi: qla2xxx: Fix device staying in blocke=
d state
a | 648efce413c9 5cbdae10bf11 | scsi: qla2xxx: Fix incorrect region-size se=
tting in optrom SYSFS routines
a | de4ed47623d2 a84014e1db35 | soc: sunxi: Fix missing dependency on REGMA=
P_MMIO
a | cfccebbba945 8db82563451f | cpufreq: armada-37xx: fix frequency calcula=
tion for opp
a | a747d98ffde8 e60e9a4b231a | intel_th: pci: Add Comet Lake support
a | 79c5c7d9ce07 747668dbc061 | usb-storage: Set virt_boundary_mask to avoi=
d SG overflows
a | 841f47e3548c 764478f41130 | USB: cdc-acm: fix unthrottle races
a | 14fa060959b0 8d791929b2fb | usb: dwc3: Fix default lpm_nyet_threshold v=
alue
a | 3b34dc57f585 59c39840f5ab | genirq: Prevent use-after-free and work lis=
t corruption
a | 2b02d3a95527 b995dcca7cf1 | platform/x86: pmc_atom: Drop __initconst on=
 dmi table
a | 997718a02d82 d6ba3f815bc5 | ASoC: Intel: kbl: fix wrong number of chann=
els
a | 1483cfcf3c9f 4772e03d2394 | RDMA/hns: Fix bug that caused srq creation =
to fail
a | 506a0e6862e1 6a8aae68c873 | virtio_pci: fix a NULL pointer reference in=
 vp_del_vqs
a | 02fd02c489cc 1a07a94b47b1 | drm/sun4i: tcon top: Fix NULL/invalid point=
er dereference in sun8i_tcon_top_un/bind
a | 71ad65f5bb67 fcf88917dd43 | slab: fix a crash by reading /proc/slab_all=
ocators
a | b5d7ac566868 c85064435fe7 | ASoC: rockchip: pdm: fix regmap_ops hang is=
sue
a | eaa1d16862ee d7262457e35d | perf/x86/intel: Initialize TFA MSR
a | 378151a25204 583feb08e7f7 | perf/x86/intel: Fix handling of wakeup_even=
ts for multi-entry PEBS
a | 0c56a7078088 2d85978341e6 | drm/mediatek: Fix an error code in mtk_hdmi=
_dt_parse_pdata()
a | adbf3d1f3ed8 c63adb28f6d9 | ASoC: tlv320aic32x4: Fix Common Pins
a | b9cdb2937e9a ab8a6d821179 | MIPS: KGDB: fix kgdb support for SMP platfo=
rms.
a | de583e633e02 a8639a79e85c | IB/hfi1: Eliminate opcode tests on mr deref
a typo: inaudile | b13ae59295e9 c899df3e9b0b | ASoC:intel:skl:fix a simulta=
neous playback & capture issue on hda platform
a | 3161876cbf97 570f18b6a8d1 | ASoC:soc-pcm:fix a codec fixup issue in TDM=
 case
a wrong reference counting, not terribly serious; noone unloads these anywa=
y | d978c80542e6 af708900e9a4 | ee3b6ffe3302 82ad759143ed | ASoC: tlv320aic=
3x: fix reset gpio reference counting
a "))" in changelog | e275c9a0765b 47830c1127ef | staging: greybus: power_s=
upply: fix prop-descriptor request size
a | c211648a4906 a0033bd1eae4 | Drivers: hv: vmbus: Remove the undesired pu=
t_cpu_ptr() in hv_synic_cleanup()
a | 97aec5cea4fa b90cd6f2b905 | scsi: libsas: fix a race condition when smp=
 task timeout
a | bf78d2cb30eb f87db4dbd52f | net: stmmac: Use bfsize1 in ndesc_init_rx_d=
esc

A lot of the autosel patches do not seem to match stable criteria to
me. It would be good to synchronize documentation with actual practice here.

Best regards,
								Pavel


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzWr9EACgkQMOfwapXb+vIG+wCfVo//MbW8Cjw53FocurDod4dz
vaQAoKtaVJMMkCuqkYPWiCuX/SazVt22
=HEpk
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
