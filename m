Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB00D5BFB01
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 11:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiIUJak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 05:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbiIUJac (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 05:30:32 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DAB13DD9;
        Wed, 21 Sep 2022 02:30:29 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9366B1C0003; Wed, 21 Sep 2022 11:30:27 +0200 (CEST)
Date:   Wed, 21 Sep 2022 11:30:27 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: AUTOSEL: batches that did not make it in was Re: [PATCH AUTOSEL 4.9
 01/13] spi: spi-cadence: Fix SPI CS gets toggling sporadically
Message-ID: <20220921093027.GA11214@duo.ucw.cz>
References: <20220914090540.471725-1-sashal@kernel.org>
 <20220920134832.GA19086@duo.ucw.cz>
 <YynnXkGHUTY3Fbxc@sashalap>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <YynnXkGHUTY3Fbxc@sashalap>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > From: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
> > >=20
> > > [ Upstream commit 21b511ddee09a78909035ec47a6a594349fe3296 ]
> > >=20
> > > As part of unprepare_transfer_hardware, SPI controller will be disabl=
ed
> > > which will indirectly deassert the CS line. This will create a problem
> > > in some of the devices where message will be transferred with
> > > cs_change flag set(CS should not be deasserted).
> > > As per SPI controller implementation, if SPI controller is disabled t=
hen
> > > all output enables are inactive and all pins are set to input mode wh=
ich
> > > means CS will go to default state high(deassert). This leads to an is=
sue
> > > when core explicitly ask not to deassert the CS (cs_change =3D 1). Th=
is
> > > patch fix the above issue by checking the Slave select status bits fr=
om
> > > configuration register before disabling the SPI.
> >=20
> > My records say this was already submitted to AUTOSEL at "Jun
> > 27". There are more patches from that era that were reviewed in
> > AUTOSEL but not merged anywhere. Can you investigate?
>=20
> Yup, there was a batch that never went in, going to queue it up for the
> next round of releases.

For the record, these are batches that did not seem to make it in
(along with my notes, ignore those).

Best regards,
								Pavel

Jun 21

a 4.9 1/3] mei: me: set internal pg flag to off on hardware reset
a relatively important performance tweak 4.9 2/3] ext4: improve write perfo=
rmance with disabled delal
a 4.9 3/3] ext4: correct the judgment of BUG in ext4_mb_normal

a 4.19 1/7] genirq: PM: Use runtime PM for chained interrupts
a 4.19 2/7] irqchip/uniphier-aidet: Add compatible string for
a just a printk tweak 4.19 4/7] nvme-pci: add trouble shooting steps for ti=
meouts
a 4.19 6/7] blk-mq: protect q->elevator by ->sysfs_lock in blk

a 5.10 05/11] nvme-pci: phison e12 has bogus namespace ids
a 5.10 06/11] nvme-pci: smi has bogus namespace ids
a 5.10 07/11] nvme-pci: sk hynix p31 has bogus namespace ids
a 5.10 10/11] blk-mq: don't clear flush_rq from tags->rqs[]

Jun 27

a 4.19 03/22] ALSA: usb-audio: US16x08: Move overflow check b
n unused preparation 4.19 05/22] drm/vc4: crtc: Move the BO handling out of=
 comm
! do we have everything? 4.19 06/22] ALSA: x86: intel_hdmi_audio: enable pm=
_runtime
! 4.19 07/22] hamradio: 6pack: fix array-index-out-of-bounds
a 4.19 13/22] arch: mips: generic: Add missing of_node_put()
a 4.19 14/22] mips: mti-malta: Fix refcount leak in malta-tim
a 4.19 15/22] mips: ralink: Fix refcount leak in of.c
a 4.19 20/22] drm/sun4i: Add DMA mask and segment size
! 4.19 21/22] drm/amdgpu: Adjust logic around GTT size (v3)

a 5.10 03/34] regulator: qcom_smd: correct MP5496 ranges
a just a printk tweak 5.10 05/34] bus: bt1-apb: Don't print error on -EPROB=
E_DEFE
a just a printk tweak 5.10 06/34] bus: bt1-axi: Don't print error on -EPROB=
E_DEFE
n unused preparation 5.10 09/34] scsi: ufs: Simplify ufshcd_clear_cmd()
n unused preparation 5.10 10/34] scsi: ufs: Support clearing multiple comma=
nds a
! c/e 5.10 12/34] ALSA: x86: intel_hdmi_audio: use pm_runtime_res
! needed? 5.10 15/34] powerpc/prom_init: Fix build failure with GCC_P
! c/e, just a robustness 5.10 20/34] btrfs: do not BUG_ON() on failure to m=
igrate sp
a 5.10 29/34] drm/sun4i: Return if frontend is not present
n just a workaround for bug 5.10 is not triggering -- we don't have 281d0c9=
62752 ("fortify: Add Clang support") 5.10 30/34] hin\
ic: Replace memcpy() with direct assignment
a 5.10 32/34] nvme: add a bogus subsystem NQN quirk for Micro
a 5.10 33/34] gpio: grgpio: Fix device removing


Aug 11

a just a warning fix 4.9 01/12] drm/r128: Fix undefined behavior due to shi=
ft overf
a 4.9 02/12] drm/radeon: Initialize fences array entries in r
a could be cleaned up 4.9 03/12] media: airspy: respect the DMA coherency r=
ules
a 4.9 04/12] media: pvrusb2: fix memory leak in pvr_probe
n preparation for patches not queued here 4.9 05/12] mlxsw: cmd: Increase '=
config_profile.flood_mode'
! do they in 4.9? 4.9 06/12] iov_iter_get_pages{,_alloc}(): cap the maxsize=
 w
a just a warning fix 4.9 07/12] crypto: vmx - Fix warning on p8_ghash_alg
n preparation for patches not queued, not needed in 4.9/5.10 4.9 08/12] can=
: sja1000: Add Quirk for RZ/N1 SJA1000 CAN co
! performance tweaks, known to cause regressions 4.9 09/12] net/cdc_ncm: In=
crease NTB max RX/TX values to 64
a 4.9 10/12] wifi: rtl8xxxu: Fix the error handling of the pr
a 4.9 11/12] d_add_ci(): make sure we don't miss d_lookup_don
n PREEMPT_RT does not exist on 4.9 and 4.19 4.9 12/12] fs/dcache: Disable p=
reemption on i_dir_seq write

a 4.19 02/14] drm/radeon: integer overflow in radeon_mode_dum
! check, is it using endpoing after that? 4.19 04/14] media: davinci: vpif:=
 add missing of_node_put()
a 4.19 09/14] drm/nouveau/nvkm: use list_add_tail() when buil

! check requisites 5.10 02/46] ath10k: htt_tx: do not interpret Eth frames =
as
a 5.10 03/46] ath10k: fix misreported tx bandwidth for 160Mhz
a 5.10 04/46] drm/nouveau: clear output poll workers before n
n preparation for patches not queued here 5.10 05/46] drm/panfrost: Handle =
HW_ISSUE_TTRX_2968_TTRX_31
! just a cleanup 5.10 06/46] drm/panfrost: Don't set L2_MMU_CONFIG quirks
a 5.10 07/46] ath10k: fix regdomain info of iw reg set/get
a 5.10 08/46] drm/amd/display: Detect dpcd_rev when hotplug m
 5.10 09/46] drm/amd/display: Fix dpp dto for disabled pipes
 5.10 12/46] udmabuf: Set the DMA mask for the udmabuf devic
 5.10 13/46] net/mlx5: Add HW definitions of vport debug cou
 5.10 14/46] drm/amd/display: Fix monitor flash issue


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYyrZswAKCRAw5/Bqldv6
8teLAJ9zWpKXc+uUXlQbbwDu18LnlEuc4wCeMEyQcQWZXuh+sImFM2lpjTsKH1s=
=ZQm0
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
