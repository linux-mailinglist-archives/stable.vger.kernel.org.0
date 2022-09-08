Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3D35B1466
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 08:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiIHGJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 02:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiIHGJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 02:09:56 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B2727DE3
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 23:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662617395; x=1694153395;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MZdi/0QRFXobj4jdGUdYTWYQoagcM8E2yCOTnOespsM=;
  b=JwzpTiZKnrW/ShYpq0Abxn2wCsa+sP8/VIi5lvm5eVBXTZZUI2mjdW3L
   KIMfBJ37nL/e0qVtN2zKOs6Cvd1K57gsi7tTYVO9bfjw5OiDdVf/MR4qY
   PPpZoPSutQp3opvifP3YtqVJznl5Az3033BmmdZRKmfwBVPSsPcCEM93C
   BzSHlQIx1fl3vtqAii3Nc5sR3B9Lpk9qgPeg45U+9RPalXuEmzGFBO8eL
   +lZXj94MOvi3sksisR3+E8FoWX+ZGFipDCUrdbwz0YdVEPj+fjwsQ2iMR
   WyOqvMci+taACBVw/avra/mvn4+6mwYMlX9zQpGdX0SVPSeYJ1CKBbMNM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10463"; a="295812815"
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="asc'?scan'208";a="295812815"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 23:09:55 -0700
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="asc'?scan'208";a="614769666"
Received: from arashsob-mobl.amr.corp.intel.com (HELO desk) ([10.209.110.101])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 23:09:54 -0700
Date:   Wed, 7 Sep 2022 23:09:49 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Greg KH <gregkh@linuxfoundation.org>, peterz@infradead.org,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: Re: FAILED: patch "[PATCH] x86/nospec: Fix i386 RSB stuffing" failed
 to apply to 5.10-stable tree
Message-ID: <20220908060949.dcybz74j3wm7pzrg@desk>
References: <166176181110563@kroah.com>
 <3e14d81d0576aed9583d07fbd14e6a502f2d4739.camel@decadent.org.uk>
 <YxB+xgcz9QD5BK77@kroah.com>
 <ff8d3521a32e1a425af32711856d0d8fdfa84d2b.camel@decadent.org.uk>
 <Yxc4CeyDS2tWLXfo@kroah.com>
 <3fb3cc8cb6bfab9dc52e351c56a31c233051c9b0.camel@decadent.org.uk>
 <20220906212010.rfvxzkt25nwakfad@desk>
 <4c8251e607ad3248bf6309069a3d7c577c4da7a5.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iodzz4t7fv6ltohy"
Content-Disposition: inline
In-Reply-To: <4c8251e607ad3248bf6309069a3d7c577c4da7a5.camel@decadent.org.uk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--iodzz4t7fv6ltohy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 07, 2022 at 02:23:58AM +0200, Ben Hutchings wrote:
> > > - The added mitigation, for PBRSB, requires removing any RET
> > > instructions executed between VM exit and the RSB filling.  In these
> > > older branches that hasn't been done, so the mitigation doesn't work.
> >=20
> > I checked 4.19 and 5.4, I don't see any RET between VM-exit and RSB
> > filling. Could you please point me to any specific instance you are
> > seeing?
>=20
> Yes, you're right.  The backported versions avoid this problem.  They
> are quite different from the upstream commit - and I would have
> appreciated some explanation of this in their commit messages.

Ahh right, I will keep in mind next time.

> So, let's try again to move forward.  I've attached a backport for 4.19
> and 5.4 (only tested with the latter so far).

I am not understanding why lfence in single-entry-fill sequence is okay
on 32-bit kernels?

#define __FILL_ONE_RETURN                               \
        __FILL_RETURN_SLOT                              \
        add     $(BITS_PER_LONG/8), %_ASM_SP;           \
        lfence;

--iodzz4t7fv6ltohy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEhLB5DdoLvdxF3TZu/KkigcHMTKMFAmMZhy0ACgkQ/KkigcHM
TKNZ2A/+O//8TkcXm0UuGGlSJBOsk1XZg7SkVOABeOKyS8HipzvHzegTp4G9Lg9J
dKBRPNfPcr9k9jD9N37yvCrddNAijEFn8ug66svCFedceI88xawkrgIJfMERJy4W
yqHBRpCqMIiCzsmOwXDsF3cN5g9U5RdW3GoXT6lt1ufO6Ou+LBrN080iDRz4ifxY
AEuwmjc8en+56jgWYHQFoO5ST+XTY7gQD/asOTyTo9sJOTT87dqF4ttOeJhf1BvC
cRc56CVAsIXvEPdXqg1AfAdu3f6Uhzw/r+7302WGUk66+AGWG0p5g0+Fvgyke5zr
3vv4BwiY0/XgoptVP4/A7MJVG2f2Ft4f+XE+e6Fq4uph/eHoxgzASs/uHgmxkxfx
VJkpBe4vdFJMb7o/hONfSolRGZb3icHYtGqFQOPDhjEiyDtl4aHK4hmzCpSlhvVY
0ocC17LTWb9I2/WA95koIh1Tx9aoP01UkKDNt89ZPP4mYdTc3v+Jk/4SiWGYUWjF
GnkdoEJu4kkuWF0ilyCTR2xatoO4J77zGY+e9IG2F/LoFlgDq8exo/QwsEG8zuIK
i/K2/KurRA0NLxHacMwk+L3mqe60J3LOhNSZ3Ar44MDYXuqT7qtYfM4Fi0s7AiuT
IFwBj1fRo/yM68Jj+X0Rp7gUDRO2Wfof7rpyZBgNcqVl4ntLt2o=
=vEbQ
-----END PGP SIGNATURE-----

--iodzz4t7fv6ltohy--
