Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FF01E3F76
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 12:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgE0K61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 06:58:27 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:43599 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728830AbgE0K60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 06:58:26 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 706CF1347;
        Wed, 27 May 2020 06:58:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Wed, 27 May 2020 06:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zHqCS7
        Z689pQF/3uanD+RlgrJXGmDAv4EXM9WKoGV58=; b=uvzkhJS0MYCw0v+kKU97jo
        nHlDvFFAUglvwhMr8qDOohl2587Yot1xA4Hy4XzHyucaFML5dU3YX8AdE1NV7AvC
        69GLnbvFpWtGzasA98uKm4gHCs5n7FyYL06k0NGk3AliER7bP/MuP1VRiRBDkJym
        t3juWlOVo5ljLpF5VILmDLv2dVzshDdg5gOR67LYsvJcXqU353F2aetl75Fcc/Qd
        epYBBX3X7WW0QHLgE3DYcd8RhH6TX4rkuGSZKPlSmUPpKArzDFE8+nYkrGHfH1Dh
        Ux7nbyxrLHDeqrHui1pMvXNxNib1j7/AXhyYj+L8OOVj3nfpQlT54zCwSYWHrZ+g
        ==
X-ME-Sender: <xms:0EfOXhw4T8MIJEKAO8Jz7j9cN6FB3bw5bviuLFY__HiI-7qbdk__6A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvgedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesghdtreertdervdenucfhrhhomhephghojhht
    vghkucfrohhrtgiihihkuceofihojhhusehinhhvihhsihgslhgvthhhihhnghhslhgrsg
    drtghomheqnecuggftrfgrthhtvghrnhepueeuuedvvdeukefgheffhfetkeelhfekhfej
    jeeigeejveevueeiueefleetkeelnecuffhomhgrihhnpehgihhthhhusgdrtghomhenuc
    fkphepledurddugeehrdduieelrdeiheenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpeifohhjuhesihhnvhhishhisghlvghthhhinhhgshhlrg
    gsrdgtohhm
X-ME-Proxy: <xmx:0EfOXhQo6p7W31mr52aneglNYzcm-R_yD3jsfp05FMjRNp8IIMF-3Q>
    <xmx:0EfOXrVghUu4LbMj_MmqRg4sdICFTSnp-ieSlmtryzCjeZrsbruIsA>
    <xmx:0EfOXjg3bF6D80J1JZDG9UNzg4dJrXbHiSAJY9v_qhILOpN_M1vLLQ>
    <xmx:0UfOXqN3JsaZLzLD0W5mGDZ3xlyL5taH9Q0Svo4uwW9dXMmzpB6jXg>
Received: from mail-itl.localdomain (91-145-169-65.internetia.net.pl [91.145.169.65])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6DB2D3280066;
        Wed, 27 May 2020 06:58:24 -0400 (EDT)
Received: by mail-itl.localdomain (Postfix, from userid 1000)
        id A6AF55D3F2; Wed, 27 May 2020 12:58:19 +0200 (CEST)
Date:   Wed, 27 May 2020 12:58:19 +0200
From:   Wojtek Porczyk <woju@invisiblethingslab.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, keescook@chromium.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] x86: Pin cr4 FSGSBASE
Message-ID: <20200527105819.GJ14256@invisiblethingslab.com>
References: <20200526052848.605423-1-andi@firstfloor.org>
 <20200526065618.GC2580410@kroah.com>
 <20200526154835.GW499505@tassilo.jf.intel.com>
 <20200526163235.GA42137@kroah.com>
 <20200526172403.GA14256@invisiblethingslab.com>
 <20200527070755.GB39696@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sGwo475CiIwWEjLI"
Content-Disposition: inline
In-Reply-To: <20200527070755.GB39696@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sGwo475CiIwWEjLI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 27, 2020 at 09:07:55AM +0200, Greg KH wrote:
> On Tue, May 26, 2020 at 07:24:03PM +0200, Wojtek Porczyk wrote:
> > On Tue, May 26, 2020 at 06:32:35PM +0200, Greg KH wrote:
> > > On Tue, May 26, 2020 at 08:48:35AM -0700, Andi Kleen wrote:
> > > > On Tue, May 26, 2020 at 08:56:18AM +0200, Greg KH wrote:
> > > > > On Mon, May 25, 2020 at 10:28:48PM -0700, Andi Kleen wrote:
> > > > > > From: Andi Kleen <ak@linux.intel.com>
> > > > > >=20
> > > > > > Since there seem to be kernel modules floating around that set
> > > > > > FSGSBASE incorrectly, prevent this in the CR4 pinning. Currently
> > > > > > CR4 pinning just checks that bits are set, this also checks
> > > > > > that the FSGSBASE bit is not set, and if it is clears it again.
> > > > >=20
> > > > > So we are trying to "protect" ourselves from broken out-of-tree k=
ernel
> > > > > modules now? =20
> > > >=20
> > > > Well it's a specific case where we know they're opening a root hole
> > > > unintentionally. This is just an pragmatic attempt to protect the u=
sers in the=20
> > > > short term.
> > >=20
> > > Can't you just go and fix those out-of-tree kernel modules instead?
> > > What's keeping you all from just doing that instead of trying to force
> > > the kernel to play traffic cop?
> >=20
> > We'd very much welcome any help really, but we're under impression that=
 this
> > couldn't be done correctly in a module, so this hack occured.
>=20
> Really?  How is this hack anything other than a "prevent a kernel module
> from doing something foolish" change?

By "this hack" I meant our module [1], which just enables FSGSBASE bit with=
out
doing everything else that Sasha's patchset does, and that "everything else"
is there to prevent a gaping root hoole.

Original author wanted module for the reason snipped below, but Sasha's
patchset can't be packaged into module. I'll be happy to be corrected on
this point, I personally have next to no kernel programming experience.

This kernel change I think is correct, because if kernel assumes some
invariants, it's a good idea to actually enforce them, isn't it? So we don't
have anything against this kernel change. We'll have to live with it, with =
our
hand forced.

> Why can't you just change the kernel module's code to not do this?  What
> prevents that from happening right now which would prevent the need to
> change a core api from being abused in such a way?
[snip]
> I'm sorry, but I still do not understand.  Your kernel module calls the
> core with this bit being set, and this new kernel patch is there to
> prevent the bit from being set and will WARN_ON() if it happens.  Why
> can't you just change your module code to not set the bit?

Because we need userspace access to wrfsbase, which this bit enables:

https://github.com/oscarlab/graphene/blob/58c53ad747579225bf29e3506d883586f=
f4b8eee/Pal/src/host/Linux-SGX/sgx_api.h#L94-L98
https://github.com/oscarlab/graphene/blob/0dd84ddf943d256e5494f07cb41b1d0ec=
e847c1a/Pal/src/host/Linux-SGX/enclave_entry.S#L675
https://github.com/oscarlab/graphene/blob/e4e16aa10e3c2221170aee7da66370507=
cc52428/Pal/src/host/Linux-SGX/db_misc.c#L69

> Do you have a pointer to the kernel module code that does this operation
> which this core kernel change will try to prevent from happening?

Sure: https://github.com/oscarlab/graphene-sgx-driver/blob/a73de5fed96fc330=
fc0417d262ba5e87fea128c2/gsgx.c#L32-L39

The whole module is 86 sloc, and the sole purpose is to set this bit on load
and clear on unload.

[1] ^


--=20
pozdrawiam / best regards
Wojtek Porczyk
Graphene / Invisible Things Lab
=20
 I do not fear computers,
 I fear lack of them.
    -- Isaac Asimov

--sGwo475CiIwWEjLI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEaO0VFfpr0tEF6hYkv2vZMhA6I1EFAl7OR8wACgkQv2vZMhA6
I1FPXBAAlQEJ78hTB6bfoNWdD8JsbGMlglrky8HMVgdEO///gMx042JRPUfcJa2K
kQGigRidOsF5iDYmGd7mp7LXHC/Mmp7CVh4B/JidUtZeyyhfr8xTTiib/xT8K4Fb
QjHK9Az0TwB+E0iexSjLpxI8owWnlWL8DfZGxCk5AUPk8TBjTH2h6ajeG0NBzvh7
Je8gbzCL9CWOqFouhHtbnEXEWF9uqOCvCSqKG+yuXZRjCaLti0R1N8FXNeLF6PxQ
TsObfgyyILIDD0MPuM8ViyRXRx4dG6yFsglmzYONqweODGSltqbs1EAmn5X0tiE2
L8oq2qcggCeDWN5NjiEr6U7Z/fyJ6/3gBGqT7n9ivk7YB5Fvytz73ueQEDjfQ/ZR
gn8nOj4PAvxCMkmwdgMIaMotVEPZ7pTxrESPCAgtF6NXadpwN5fkt8wZwBQLZmXy
qIneQfld5/xlUFETp5hCM6NDkDOG85vZKpjOEBQrq+J7xVcdUewuD8FOu28RmHP+
WDQdHKrkvN9yoYUz+v6SD5XSZymIJMVeB+J7tBRSXXDtj0vWGEamgZ6jXVPzhVig
4mOkfuzU36HUb45HA1W3WJW7B59hgEDs750ElMl/LrwRFxME87h/j33YxRMrsCxx
m+gxFA76VYZXW8aOptf+fxF2olf3PafdHtxFOHOvpzEbS9yKRZg=
=u6SW
-----END PGP SIGNATURE-----

--sGwo475CiIwWEjLI--
