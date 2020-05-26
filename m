Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37491E2899
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 19:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389107AbgEZRYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 13:24:15 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:54259 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388662AbgEZRYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 13:24:11 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 048C510AB;
        Tue, 26 May 2020 13:24:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Tue, 26 May 2020 13:24:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=N+2HgG
        4kGwu+YjXYKXb+GfVj8egbu/mj++VICG8Oszo=; b=YIZRmfxqcVE3kvuGbPKBoq
        aWnC2jlvWdbp2Lt+f/NVV4DkUFyQuSyGZMKzMgHuCEl3/s+OkYUb47jUx/u484wx
        Z7qqK+0MIrCZ6Os/tkm6HspzXzxOf6Lt0kWLcphVkycKP+6iZ6DKCUscvaUbG/iX
        zF1CLYq+6DK7dMscg9jL6u2f59/Y9WDLlQPlkTBUwqBhEdx8F72vo3QZJYqKrXOo
        PzZV26QaY5sS+M+WQCC7Ru2RlthukPareVdqMxb5WiNZYOtwvPleQBu/pw05tQK/
        Usz9d2rzzVzgFAKuegM6VUSe+e9HSZi3rLmQ/FgaVG2uwq3OW395VJyGQWixqCcA
        ==
X-ME-Sender: <xms:uFDNXoOKWlvBO4sOMkY-NgvlA80NCydWVcLBYHM9cQIZOZIckaphDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvvddgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehgtderredtredvnecuhfhrohhmpeghohhj
    thgvkhcurfhorhgtiiihkhcuoeifohhjuhesihhnvhhishhisghlvghthhhinhhgshhlrg
    gsrdgtohhmqeenucggtffrrghtthgvrhhnpedtudevvdffheejveekieetjeduueduffeg
    heffffejgeeuteehtdegudetgeetteenucfkphepledurddugeehrdduieelrdeiheenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpeifohhjuhes
    ihhnvhhishhisghlvghthhhinhhgshhlrggsrdgtohhm
X-ME-Proxy: <xmx:uFDNXu_HuNBaUwtbrVQMbyHId1nCU_d2i4qlTdMzZtV4PmyBkKsTrQ>
    <xmx:uFDNXvQyAmwbSFm0SU5C80ugDB_oI_J4ZSrvvLET6WmkjoDviQuY-w>
    <xmx:uFDNXgtWisxh10JbgC0YHmik5NZIgRAC41gJH1uCGOL72lkR-HfemQ>
    <xmx:uVDNXo4AfRDmgMAtfuWyQkE0gRCE15mhx5uo1Bp9f5Mg0MKiIbEDKg>
Received: from mail-itl.localdomain (91-145-169-65.internetia.net.pl [91.145.169.65])
        by mail.messagingengine.com (Postfix) with ESMTPA id 15AAF30665C7;
        Tue, 26 May 2020 13:24:08 -0400 (EDT)
Received: by mail-itl.localdomain (Postfix, from userid 1000)
        id F1DA25CF91; Tue, 26 May 2020 19:24:03 +0200 (CEST)
Date:   Tue, 26 May 2020 19:24:03 +0200
From:   Wojtek Porczyk <woju@invisiblethingslab.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Andi Kleen <ak@linux.intel.com>
Cc:     Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] x86: Pin cr4 FSGSBASE
Message-ID: <20200526172403.GA14256@invisiblethingslab.com>
References: <20200526052848.605423-1-andi@firstfloor.org>
 <20200526065618.GC2580410@kroah.com>
 <20200526154835.GW499505@tassilo.jf.intel.com>
 <20200526163235.GA42137@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20200526163235.GA42137@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2020 at 06:32:35PM +0200, Greg KH wrote:
> On Tue, May 26, 2020 at 08:48:35AM -0700, Andi Kleen wrote:
> > On Tue, May 26, 2020 at 08:56:18AM +0200, Greg KH wrote:
> > > On Mon, May 25, 2020 at 10:28:48PM -0700, Andi Kleen wrote:
> > > > From: Andi Kleen <ak@linux.intel.com>
> > > >=20
> > > > Since there seem to be kernel modules floating around that set
> > > > FSGSBASE incorrectly, prevent this in the CR4 pinning. Currently
> > > > CR4 pinning just checks that bits are set, this also checks
> > > > that the FSGSBASE bit is not set, and if it is clears it again.
> > >=20
> > > So we are trying to "protect" ourselves from broken out-of-tree kernel
> > > modules now? =20
> >=20
> > Well it's a specific case where we know they're opening a root hole
> > unintentionally. This is just an pragmatic attempt to protect the users=
 in the=20
> > short term.
>=20
> Can't you just go and fix those out-of-tree kernel modules instead?
> What's keeping you all from just doing that instead of trying to force
> the kernel to play traffic cop?

We'd very much welcome any help really, but we're under impression that this
couldn't be done correctly in a module, so this hack occured.

This was written in 2015 as part of original (research) codebase for those
reasons:
- A module is easier to deploy by scientists, who are no kernel developers =
and
  no sysadmins either, so applying patchset and recompiling kernel is a big
  ask.
- It has no implications on security in SGX/Graphene threat model and in
  expected deployment scenario.
- This had no meaning to the actual research being done, so it wasn't cared
  about.

Let me expand the second point, because I understand both the module and the
explanation looks wrong.

Graphene is intended to be run in a cloud, where the CPU time is sold in
a form of virtual machine, so the VM kernel, which would load this module, =
is
not trusted by hardware owner, so s/he don't care. But the owner of the
enclave also doesn't care, because SGX' threat model assumes adversary who =
is
capable of arbitrary code execution in both kernel and userspace outside
enclave. So the kernel immediately outside the enclave is a no-man's land,
untrusted by both sides and forsaken, reduced to a compatibility layer
between x86 and ELF.

I acknowledge this is unusual threat model and certainly to mainline
developers, who rarely encounter userspace that is more trusted than kernel.

What we've failed at is to properly explain this, because if someone loads
this module outside of this expected scenario, will certainly be exposed to
a gaping root hole. Therefore we acknowledge this patch and as part of
Graphene we'll probably maintain a patchset, until the support is upstream.
Right now this will take us some time to change from our current kernel
interfaces.


--=20
pozdrawiam / best regards
Wojtek Porczyk
Graphene / Invisible Things Lab
=20
 I do not fear computers,
 I fear lack of them.
    -- Isaac Asimov

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEaO0VFfpr0tEF6hYkv2vZMhA6I1EFAl7NULMACgkQv2vZMhA6
I1HeVhAAopSXwAHYY1jjElt533B4ztTXw4rQVCXIs+nC3wCUerQ0Qib79WmofOBZ
lcl/BUsIF+qo+yL7FagLcqnxGg5AGBYxJ9KXiFb/iha3jpRYLZpFyxAEr/Y+LCh3
zmChvR+UYmONCapQDDW6B3IVMyLqeTUPxZ26kHOt2MMQyb+aGhtSPfxnFLtN0MHg
2ST5TqOWQ+izMVu4xTOuuGZBs131oodfkC1s58KOF/r6OIdBx9zGbNBQeFS1OwXA
bYLOijvk0Q9lMPyqq7FKJuHN2dH2uP/liLOosN+OUCfjQRbz34KptMakOSZ/FJTf
2mUWq59579kkKfW9J5nwfj27I7vUejutXDy/YFImga4HwxqGQGbXIFtlDOEdKZ7U
aXKugpGmqfzQnyUFbeLBetdkb3Lq0H8qEOLUpHPQiHrriMm7m/7q9hEDtzplk+WJ
Yj5gLQlIyDaMO63PRi+tR6K8s9p2E9JL/hCOUtjptEWGjzDVptoFDKWXeGe8M9ak
caGjZRQihWkjyzvG2/f4s3/0zJ6aA1NE909X9W7hPKY6y60WJkUySXFCkSpsO/GN
1C6s/O7nOmLeHd1IHclpNbDLMxxRtoFMb7KPjAXsFsC2Zx8Pz+1TM094TGyggWcI
7DD8dQRMKd+IayyDmuMrmULLRLqoThIbHVKAn0OUtZDvqnHvk24=
=OSfl
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
