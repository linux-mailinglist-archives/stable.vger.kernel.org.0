Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024865AF6B4
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 23:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiIFVUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 17:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiIFVUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 17:20:14 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3643782F8F
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 14:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662499213; x=1694035213;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RkntbmrS3pK2yl9XkwzYaRJBbJIwWB8s/UOImg+V4Yo=;
  b=TIBR/S/6w4R50TNSJJO7ZZQGdbAdGqDpnPC3fiDhwq9yhaykhRwqD4ay
   fxqI2v7H4++2mV//IjLjThW/eT+i7/Cw4YbM4vw5rtadEXH/jRVPCHN9Z
   0U23h/t6W26D5+9Ul1x+6dOCjKJWGkkCHwdCk0HzYeL/y4VJQ23rIC970
   ELpKdF0vaF3c0K0P0FcaaIO222Xc57hfRmaRkOZ9PZuiK386mXYdIiGL4
   q36YY49QV1T/Ckp9azvLXE3GgOsC4YA2VtIxj3Uzyvr/QAMWJ5VG7XP3Q
   qFBygpYtsa4BRqJXnMSzOVBkdRd2vjb+oPYIcfim66j8TH8Hk6GYx0Blr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="360656450"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="asc'?scan'208";a="360656450"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 14:20:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="asc'?scan'208";a="756517974"
Received: from morris9x-mobl1.amr.corp.intel.com (HELO desk) ([10.252.134.166])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 14:20:12 -0700
Date:   Tue, 6 Sep 2022 14:20:10 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Greg KH <gregkh@linuxfoundation.org>, peterz@infradead.org,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: Re: FAILED: patch "[PATCH] x86/nospec: Fix i386 RSB stuffing" failed
 to apply to 5.10-stable tree
Message-ID: <20220906212010.rfvxzkt25nwakfad@desk>
References: <166176181110563@kroah.com>
 <3e14d81d0576aed9583d07fbd14e6a502f2d4739.camel@decadent.org.uk>
 <YxB+xgcz9QD5BK77@kroah.com>
 <ff8d3521a32e1a425af32711856d0d8fdfa84d2b.camel@decadent.org.uk>
 <Yxc4CeyDS2tWLXfo@kroah.com>
 <3fb3cc8cb6bfab9dc52e351c56a31c233051c9b0.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vhwtaklazz5sbxmy"
Content-Disposition: inline
In-Reply-To: <3fb3cc8cb6bfab9dc52e351c56a31c233051c9b0.camel@decadent.org.uk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vhwtaklazz5sbxmy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Tue, Sep 06, 2022 at 07:07:57PM +0200, Ben Hutchings wrote:
> On Tue, 2022-09-06 at 14:07 +0200, Greg KH wrote:
> > On Fri, Sep 02, 2022 at 04:26:57PM +0200, Ben Hutchings wrote:
> > > On Thu, 2022-09-01 at 11:43 +0200, Greg KH wrote:
> > > > On Mon, Aug 29, 2022 at 04:04:58PM +0200, Ben Hutchings wrote:
> > > > > On Mon, 2022-08-29 at 10:30 +0200, gregkh@linuxfoundation.org wro=
te:
> > > > > > The patch below does not apply to the 5.10-stable tree.
> > > > > > If someone wants it applied there, or to any other stable or lo=
ngterm
> > > > > > tree, then please email the backport, including the original gi=
t commit
> > > > > > id to <stable@vger.kernel.org>.
> > > > > >=20
> > > > >=20
> > > > > You need commit 4e3aa9238277 "x86/nospec: Unwreck the RSB stuffin=
g"
> > > > > before this one.  I've attached the backport of that for 5.10.  I
> > > > > haven't checked the older branches.
> > > >=20
> > > > Great, thanks, this worked.  But the backport did not apply to 4.19=
, so
> > > > I will need that in order to take this one as well.
> > >=20
> > > I've had a look at 5.4, and it's sufficiently different from upstream
> > > that I don't see how to move forward.
> > >=20
> > > However, I also found that the PBRSB mitigation seems broken, as comm=
it
> > > fc02735b14ff "KVM: VMX: Prevent guest RSB poisoning attacks with eIBR=
S"
> > > was not backported (and would be hard to add).
> > >=20
> > > So, perhaps it would be best to revert the backports of:
> > >=20
> > > 2b1299322016 x86/speculation: Add RSB VM Exit protections
> > > ba6e31af2be9 x86/speculation: Add LFENCE to RSB fill sequence
> > >=20
> > > in stable branches older than 5.10.
> >=20
> > Why?  Is it because they do not work at all there, or are they causing
> > problems?
>=20
> - They both add unconditional LFENCE instructions, which are not
> implemented on older 32-bit CPUs and will therefore result in a crash.

Backporting commit 332924973725 ("x86/nospec: Fix i386 RSB stuffing") should
fix this?

  https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=3D=
332924973725e8cdcc783c175f68cf7e162cb9e5

> - The added mitigation, for PBRSB, requires removing any RET
> instructions executed between VM exit and the RSB filling.  In these
> older branches that hasn't been done, so the mitigation doesn't work.

I checked 4.19 and 5.4, I don't see any RET between VM-exit and RSB
filling. Could you please point me to any specific instance you are
seeing?

Thanks,
Pawan

--vhwtaklazz5sbxmy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEhLB5DdoLvdxF3TZu/KkigcHMTKMFAmMXuYoACgkQ/KkigcHM
TKOUbQ/8D3KGaLie9fxJTf+XkSoyUG5zTHI6cXb5tVJtGoaId41wHSmnpJapKPOD
E367jVfANxwZjdgx6C5OoN/RxEvUHVspiamHsq0PTnxQjClCHTHEqpDnE0X75WWE
UR/WUeyJuRPYml0D/zP3fjau/M8/lcA2BgU7pcviXAuwKQvSL6rpqmiLtBHRQRiu
LTGxv9I3KLrpXRdhJoALy4x4f6Sny4R6PL7dsO88h1WuOPhk4HKVMzos5uwL7Yfl
gfKaAGcxq5BTvVP6E8QH8yJBdin1yuzZ/uTgEnive1RkOTbyBWdBzOTkf4wiBHi6
uXOMxHU4jFa/9tDS4O9Dw31fUkljtyOLFimx9BnqEaoZVN7BojeJOPF3vMwk4Fxm
V9OfVQ+Y9KcT3xTHkYJPPb0YsYdi6ZnB0adPEac6usUb51Bt5wSaB9mI2Sv6icR+
CyleCf3s/fBLjQeVB9akB3qDoi0XVn0lrieQaejsxp59JasfQvjbkRIaZllTFxMG
VY+0N3UudZAFTANQD8xEx5iHU09HTL9dn7v0rBCTyBSybiN8MAZTsK1Q5D6agCB5
S1tgzpEc0syvJ1MQPf4nM44HsHIYgJQ3eUjcDn+BMY8Aj+5BptXeChXZG5HLnLDH
P224c+l+oj7D4ci2g/wD19ytGDZNPhQF7Pxfmt+W1XfNK17XIJE=
=72PH
-----END PGP SIGNATURE-----

--vhwtaklazz5sbxmy--
