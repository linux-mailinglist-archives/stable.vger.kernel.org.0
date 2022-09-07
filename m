Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D69F5AF8F1
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 02:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiIGAYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 20:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIGAYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 20:24:12 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5465FD3
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 17:24:06 -0700 (PDT)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1oVirL-0001C5-HS; Wed, 07 Sep 2022 02:24:03 +0200
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1oVirK-000Tpp-32;
        Wed, 07 Sep 2022 02:24:02 +0200
Message-ID: <4c8251e607ad3248bf6309069a3d7c577c4da7a5.camel@decadent.org.uk>
Subject: Re: FAILED: patch "[PATCH] x86/nospec: Fix i386 RSB stuffing"
 failed to apply to 5.10-stable tree
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, peterz@infradead.org,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Date:   Wed, 07 Sep 2022 02:23:58 +0200
In-Reply-To: <20220906212010.rfvxzkt25nwakfad@desk>
References: <166176181110563@kroah.com>
         <3e14d81d0576aed9583d07fbd14e6a502f2d4739.camel@decadent.org.uk>
         <YxB+xgcz9QD5BK77@kroah.com>
         <ff8d3521a32e1a425af32711856d0d8fdfa84d2b.camel@decadent.org.uk>
         <Yxc4CeyDS2tWLXfo@kroah.com>
         <3fb3cc8cb6bfab9dc52e351c56a31c233051c9b0.camel@decadent.org.uk>
         <20220906212010.rfvxzkt25nwakfad@desk>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Nm2Mo15GjXk+UK9ZOD4c"
User-Agent: Evolution 3.44.4-1+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 213.219.160.184
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-Nm2Mo15GjXk+UK9ZOD4c
Content-Type: multipart/mixed; boundary="=-S1c1y8ufXRkU+sBTa4tJ"

--=-S1c1y8ufXRkU+sBTa4tJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-09-06 at 14:20 -0700, Pawan Gupta wrote:
> Hi Ben,
>=20
> On Tue, Sep 06, 2022 at 07:07:57PM +0200, Ben Hutchings wrote:
> > On Tue, 2022-09-06 at 14:07 +0200, Greg KH wrote:
> > > On Fri, Sep 02, 2022 at 04:26:57PM +0200, Ben Hutchings wrote:
> > > > On Thu, 2022-09-01 at 11:43 +0200, Greg KH wrote:
> > > > > On Mon, Aug 29, 2022 at 04:04:58PM +0200, Ben Hutchings wrote:
> > > > > > On Mon, 2022-08-29 at 10:30 +0200, gregkh@linuxfoundation.org w=
rote:
> > > > > > > The patch below does not apply to the 5.10-stable tree.
> > > > > > > If someone wants it applied there, or to any other stable or =
longterm
> > > > > > > tree, then please email the backport, including the original =
git commit
> > > > > > > id to <stable@vger.kernel.org>.
> > > > > > >=20
> > > > > >=20
> > > > > > You need commit 4e3aa9238277 "x86/nospec: Unwreck the RSB stuff=
ing"
> > > > > > before this one.  I've attached the backport of that for 5.10. =
 I
> > > > > > haven't checked the older branches.
> > > > >=20
> > > > > Great, thanks, this worked.  But the backport did not apply to 4.=
19, so
> > > > > I will need that in order to take this one as well.
> > > >=20
> > > > I've had a look at 5.4, and it's sufficiently different from upstre=
am
> > > > that I don't see how to move forward.
> > > >=20
> > > > However, I also found that the PBRSB mitigation seems broken, as co=
mmit
> > > > fc02735b14ff "KVM: VMX: Prevent guest RSB poisoning attacks with eI=
BRS"
> > > > was not backported (and would be hard to add).
> > > >=20
> > > > So, perhaps it would be best to revert the backports of:
> > > >=20
> > > > 2b1299322016 x86/speculation: Add RSB VM Exit protections
> > > > ba6e31af2be9 x86/speculation: Add LFENCE to RSB fill sequence
> > > >=20
> > > > in stable branches older than 5.10.
> > >=20
> > > Why?  Is it because they do not work at all there, or are they causin=
g
> > > problems?
> >=20
> > - They both add unconditional LFENCE instructions, which are not
> > implemented on older 32-bit CPUs and will therefore result in a crash.
>=20
> Backporting commit 332924973725 ("x86/nospec: Fix i386 RSB stuffing") sho=
uld
> fix this?

That's where this thread started.  The problem is that it seems to
depend on a lot of other changes.

>   https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=
=3D332924973725e8cdcc783c175f68cf7e162cb9e5
>=20
> > - The added mitigation, for PBRSB, requires removing any RET
> > instructions executed between VM exit and the RSB filling.  In these
> > older branches that hasn't been done, so the mitigation doesn't work.
>=20
> I checked 4.19 and 5.4, I don't see any RET between VM-exit and RSB
> filling. Could you please point me to any specific instance you are
> seeing?

Yes, you're right.  The backported versions avoid this problem.  They
are quite different from the upstream commit - and I would have
appreciated some explanation of this in their commit messages.

So, let's try again to move forward.  I've attached a backport for 4.19
and 5.4 (only tested with the latter so far).

Ben.

--=20
Ben Hutchings
Hoare's Law of Large Problems:
   Inside every large problem is a small problem struggling to get out.

--=-S1c1y8ufXRkU+sBTa4tJ
Content-Disposition: attachment; filename="0001-x86-nospec-Fix-i386-RSB-stuffing.patch"
Content-Type: text/x-patch; name="0001-x86-nospec-Fix-i386-RSB-stuffing.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSBlNzUxZThhNDNjNzhlMDQ1YTIwODE5ZWI2YjU5ODAzOWMzMDI3NDQ5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+
CkRhdGU6IEZyaSwgMTkgQXVnIDIwMjIgMTM6MDE6MzUgKzAyMDAKU3ViamVjdDogW1BBVENIXSB4
ODYvbm9zcGVjOiBGaXggaTM4NiBSU0Igc3R1ZmZpbmcKCmNvbW1pdCAzMzI5MjQ5NzM3MjVlOGNk
Y2M3ODNjMTc1ZjY4Y2Y3ZTE2MmNiOWU1IHVwc3RyZWFtLgoKVHVybnMgb3V0IHRoYXQgaTM4NiBk
b2Vzbid0IHVuY29uZGl0aW9uYWxseSBoYXZlIExGRU5DRSwgYXMgc3VjaCB0aGUKbG9vcCBpbiBf
X0ZJTExfUkVUVVJOX0JVRkZFUiBpc24ndCBhY3R1YWxseSBzcGVjdWxhdGlvbiBzYWZlIG9uIHN1
Y2gKY2hpcHMuCgpGaXhlczogYmE2ZTMxYWYyYmU5ICgieDg2L3NwZWN1bGF0aW9uOiBBZGQgTEZF
TkNFIHRvIFJTQiBmaWxsIHNlcXVlbmNlIikKUmVwb3J0ZWQtYnk6IEJlbiBIdXRjaGluZ3MgPGJl
bkBkZWNhZGVudC5vcmcudWs+ClNpZ25lZC1vZmYtYnk6IFBldGVyIFppamxzdHJhIChJbnRlbCkg
PHBldGVyekBpbmZyYWRlYWQub3JnPgpMaW5rOiBodHRwczovL2xrbWwua2VybmVsLm9yZy9yL1l2
OXRqOXZiUTluTmxYb1lAd29ya3RvcC5wcm9ncmFtbWluZy5raWNrcy1hc3MubmV0Cltid2g6IEJh
Y2twb3J0ZWQgdG8gNC4xOS81LjQ6CiAtIF9fRklMTF9SRVRVUk5fQlVGRkVSIHRha2VzIGFuIHNw
IHBhcmFtZXRlcgogLSBPcGVuLWNvZGUgX19GSUxMX1JFVFVSTl9TTE9UXQpTaWduZWQtb2ZmLWJ5
OiBCZW4gSHV0Y2hpbmdzIDxiZW5AZGVjYWRlbnQub3JnLnVrPgotLS0KIGFyY2gveDg2L2luY2x1
ZGUvYXNtL25vc3BlYy1icmFuY2guaCB8IDE0ICsrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdl
ZCwgMTQgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL25v
c3BlYy1icmFuY2guaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL25vc3BlYy1icmFuY2guaAppbmRl
eCAxZTVkZjNjY2RkNWMuLmExZWUxYTc2MGMzZSAxMDA2NDQKLS0tIGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20vbm9zcGVjLWJyYW5jaC5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL25vc3BlYy1i
cmFuY2guaApAQCAtNDQsNiArNDQsNyBAQAogICogdGhlIG9wdGltYWwgdmVyc2lvbiDigJQgdHdv
IGNhbGxzLCBlYWNoIHdpdGggdGhlaXIgb3duIHNwZWN1bGF0aW9uCiAgKiB0cmFwIHNob3VsZCB0
aGVpciByZXR1cm4gYWRkcmVzcyBlbmQgdXAgZ2V0dGluZyB1c2VkLCBpbiBhIGxvb3AuCiAgKi8K
KyNpZmRlZiBDT05GSUdfWDg2XzY0CiAjZGVmaW5lIF9fRklMTF9SRVRVUk5fQlVGRkVSKHJlZywg
bnIsIHNwKQlcCiAJbW92CSQobnIvMiksIHJlZzsJCQlcCiA3NzE6CQkJCQkJXApAQCAtNjQsNiAr
NjUsMTkgQEAKIAlhZGQJJChCSVRTX1BFUl9MT05HLzgpICogbnIsIHNwOwlcCiAJLyogYmFycmll
ciBmb3Igam56IG1pc3ByZWRpY3Rpb24gKi8JXAogCWxmZW5jZTsKKyNlbHNlCisvKgorICogaTM4
NiBkb2Vzbid0IHVuY29uZGl0aW9uYWxseSBoYXZlIExGRU5DRSwgYXMgc3VjaCBpdCBjYW4ndAor
ICogZG8gYSBsb29wLgorICovCisjZGVmaW5lIF9fRklMTF9SRVRVUk5fQlVGRkVSKHJlZywgbnIs
IHNwKQlcCisJLnJlcHQgbnI7CQkJCVwKKwljYWxsCTc3MmY7CQkJCVwKKwlpbnQzOwkJCQkJXAor
NzcyOjsJCQkJCQlcCisJLmVuZHI7CQkJCQlcCisJYWRkCSQoQklUU19QRVJfTE9ORy84KSAqIG5y
LCBzcDsKKyNlbmRpZgogCiAjZGVmaW5lIF9fSVNTVUVfVU5CQUxBTkNFRF9SRVRfR1VBUkQoc3Ap
CVwKIAljYWxsCTg4MWY7CQkJCVwK


--=-S1c1y8ufXRkU+sBTa4tJ--

--=-Nm2Mo15GjXk+UK9ZOD4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmMX5J4ACgkQ57/I7JWG
EQkh5hAAx6NFRN0v3Q5tG9efJAYpFbplEaSGVsAX8ZlVBV1AJ2bCIRNHCa1PlQq4
XUYKI1gvQFWKMoD0Ixbl+kq8o+w0KytSB+rFeL7tsUgrhDGUcGtcqgUoNaayO4qG
EFAamzzCPSg/8XXG4BRzG9Hj6rF3TmypbntemiV7Nms+ymQBuzChe8l9fMw4YwDP
VslInJBUEBEFx/rOwE/dZL0GFqHhkLDYArL2gJhAdwlaQufi5L+a+qJp8Gt2Tt2s
jEflAepVlMyaC2cwgI7P4DwHTwFQcgXNe7G+FjMQeX7bTNRiaDjwasAIx+ImjZ6Z
ngU9xnQrwYb2PH74HHSL0zVvwR9yXninWcrS46iXfOQwG4wwAGGhhYcf/oY8+d0t
ZBgeLyNLDu/e7vGxUqp+TDWxqSUy+pKJYN/mEo5X21qHRD95cYeFPCaiZ5hN/mKQ
iGJ7pir/Oad8h41fr62PMmOfF4ovt8YOz1Hg3jUo1OJo7btcjL7R11L1HtcvKh4A
IeEaEigh4jbSe4ks8ErRJGJX7XG0NKYSNuxJswMPGoH9BBP1aT+1JWVNTsJO5MBU
s+9yVuzGAAF8Pp7/O88EeJ1dRkD89fXZ5ME1m2PNknEs2Q+Wdf3mqZURblxD0Hpj
VfgU+gceL09Ri6o2xAvmhcaaHGkoAM9cuFI6f4Nnjm44zL/RXcU=
=oBnp
-----END PGP SIGNATURE-----

--=-Nm2Mo15GjXk+UK9ZOD4c--
