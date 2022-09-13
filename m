Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56275B64AD
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 02:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiIMAxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 20:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiIMAxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 20:53:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3A72229B
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 17:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663030402; x=1694566402;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zlooSZEu66Dsap4iMZFdWDOm0F8C9gPOI5QrpZIoMWo=;
  b=SEEtvoCDMQrfPMij253FaYa81ImsQnvm5k6CL7dveb7mTtenzPOsxaX+
   Lbm5xX/Qv5T7Ji9o162i+t3/Mg5vnLPvFjmUP2cSXV3RGPklM0hbukQ7b
   xUpan8AE5yx1y8rTx1LhDw/AMjQ3+H5mCxK7SYd8CQUY/cvA9T+E3L5WK
   476ODbJKOF0FjFJmlvNk/0gTwKl1gYqoiKWjXyFKiEs7CWunM3SkT2G6d
   CfMNo3LMk2bEY6hw52TbVoOypRI1JFQrsn9n4aM3D6QRsRB4v30nwn0Ek
   +fHm5BhfZVOSgiboLKSNdC8sYBFwOLXNExMDkQt7qK9ScsWDpxH2ODjdp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="324246111"
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="asc'?scan'208";a="324246111"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 17:53:22 -0700
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="asc'?scan'208";a="678337541"
Received: from sho10-mobl1.amr.corp.intel.com (HELO desk) ([10.251.9.78])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 17:53:21 -0700
Date:   Mon, 12 Sep 2022 17:53:20 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Greg KH <gregkh@linuxfoundation.org>, peterz@infradead.org,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: Re: FAILED: patch "[PATCH] x86/nospec: Fix i386 RSB stuffing" failed
 to apply to 5.10-stable tree
Message-ID: <20220913005320.74lddsftgrm3myza@desk>
References: <166176181110563@kroah.com>
 <3e14d81d0576aed9583d07fbd14e6a502f2d4739.camel@decadent.org.uk>
 <YxB+xgcz9QD5BK77@kroah.com>
 <ff8d3521a32e1a425af32711856d0d8fdfa84d2b.camel@decadent.org.uk>
 <Yxc4CeyDS2tWLXfo@kroah.com>
 <3fb3cc8cb6bfab9dc52e351c56a31c233051c9b0.camel@decadent.org.uk>
 <20220906212010.rfvxzkt25nwakfad@desk>
 <4c8251e607ad3248bf6309069a3d7c577c4da7a5.camel@decadent.org.uk>
 <20220908060949.dcybz74j3wm7pzrg@desk>
 <61fd8fab49c19340656b2b5fbad5bc1e9f73d955.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yktssuvtcvz2zqik"
Content-Disposition: inline
In-Reply-To: <61fd8fab49c19340656b2b5fbad5bc1e9f73d955.camel@decadent.org.uk>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yktssuvtcvz2zqik
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 08, 2022 at 02:44:33PM +0200, Ben Hutchings wrote:
> On Wed, 2022-09-07 at 23:09 -0700, Pawan Gupta wrote:
> > On Wed, Sep 07, 2022 at 02:23:58AM +0200, Ben Hutchings wrote:
> > > > > - The added mitigation, for PBRSB, requires removing any RET
> > > > > instructions executed between VM exit and the RSB filling.  In th=
ese
> > > > > older branches that hasn't been done, so the mitigation doesn't w=
ork.
> > > >=20
> > > > I checked 4.19 and 5.4, I don't see any RET between VM-exit and RSB
> > > > filling. Could you please point me to any specific instance you are
> > > > seeing?
> > >=20
> > > Yes, you're right.  The backported versions avoid this problem.  They
> > > are quite different from the upstream commit - and I would have
> > > appreciated some explanation of this in their commit messages.
> >=20
> > Ahh right, I will keep in mind next time.
> >=20
> > > So, let's try again to move forward.  I've attached a backport for 4.=
19
> > > and 5.4 (only tested with the latter so far).
> >=20
> > I am not understanding why lfence in single-entry-fill sequence is okay
> > on 32-bit kernels?
> >=20
> > #define __FILL_ONE_RETURN                               \
> >         __FILL_RETURN_SLOT                              \
> >         add     $(BITS_PER_LONG/8), %_ASM_SP;           \
> >         lfence;
>=20
> This isn't exactly about whether the kernel is 32-bit vs 64-bit, it's
> about whether the code may run on a processor that lacks support for
> LFENCE (part of SSE2).
>=20
> - SSE2 is architectural on x86_64, so 64-bit kernels can use LFENCE
> unconditionally.
> - PBRSB doesn't affect any of those old processors, so its mitigation
> can use LFENCE unconditionally.  (Those procesors don't support VMX
> either.)

Thanks Ben.

--yktssuvtcvz2zqik
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEhLB5DdoLvdxF3TZu/KkigcHMTKMFAmMf1IAACgkQ/KkigcHM
TKO+Jw/+Kp//MHRhB1sEiNiApB9biAE8S/1VrdzxYZVwLf2K2Q09cuhHtZJdKe3B
+yEfmfyu+YxEWZwRVLm0Hz+cMOkHxJv87WWLQvXeaTuQ3Pun8nMpdCoyQUCfFcOE
EwEO/boW4pNrlk1Nx0PGNXIk2jG5u0sxqiS3qyQRvkfZZ8E4dFJF9RYSshqxdqdt
xHKJZQVdJ5MpdAvJ0it9c2yDVG0D31V6wa+6bgSOZAbY6enQP4R4zuGpYJ8KEEe6
2xC6+A9Pl5f73Qu6TIcoF8Q0OB/3FmvvaFw54c7H+Sy24Fr61yDJvPxVpUcl7yji
xRAXHc36jFADqU17ZVDLzXWCWIaE66NcuSIUZC98DCqQC4kQ2eIlrS4JyvXEkEqf
ylPRxJxAfhRhDJW5Nhi4UyF8H5pNJcKNRmOZiPy4gZo5jchM8gl4s9dH5wCwomhP
WPbOcFy4do2TifJFUghTyseLe25qtpQcad4XPlNWW6jmdndGl/BOw8YenLbRmOVL
PovuzO3/iuLdriZhYpAay9zSDHH5Xzuy7aK/kXoe4KDZU3fRXYgtQvNxic4piBr4
jk/oAsVv0FejpQ9d0jPwdefrggtu+w4mwE3mYNsGkixuDJcE7LMBr0FzY/udFDWk
PIFzTkwSwNs4yHm0WeDmQmD4DuhT+T68x/gO27tfzJh6nefOUHg=
=Nh6S
-----END PGP SIGNATURE-----

--yktssuvtcvz2zqik--
