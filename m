Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E817397404
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 15:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhFANXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 09:23:53 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52222 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbhFANXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 09:23:52 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A50B01FD2D;
        Tue,  1 Jun 2021 13:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622553730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=n9bmauxkr3Ps73bV2OZm/3+K/1zGwQvE3BbFvnJ+0l8=;
        b=gYobQuiDzajOJCzsnsziDE3+u5aYg3+6wGFJUTCnAzlY6/5X4NgdAL7wJBavaxJv8lmnhU
        1PJm4tDx2NiZXjx7f+VhiFmIkMxAwTFTT5zlQKBCBiaXi0xKsHRdwpj/QW90VcFjPskbUg
        YKBjbjM+5FSUF1iCjNCpYKZ07c7HvG0=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 7B6CB118DD;
        Tue,  1 Jun 2021 13:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622553730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=n9bmauxkr3Ps73bV2OZm/3+K/1zGwQvE3BbFvnJ+0l8=;
        b=gYobQuiDzajOJCzsnsziDE3+u5aYg3+6wGFJUTCnAzlY6/5X4NgdAL7wJBavaxJv8lmnhU
        1PJm4tDx2NiZXjx7f+VhiFmIkMxAwTFTT5zlQKBCBiaXi0xKsHRdwpj/QW90VcFjPskbUg
        YKBjbjM+5FSUF1iCjNCpYKZ07c7HvG0=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id r4jrHII0tmCTAwAALh3uQQ
        (envelope-from <jgross@suse.com>); Tue, 01 Jun 2021 13:22:10 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Patch for stable 5.4 and below
Message-ID: <82837f40-130e-c6f0-58a0-c8ff1b1d06a8@suse.com>
Date:   Tue, 1 Jun 2021 15:22:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6eSIovdcFl3Li3hGNp1zXw0sIfWw5fPs8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6eSIovdcFl3Li3hGNp1zXw0sIfWw5fPs8
Content-Type: multipart/mixed; boundary="PkzywYoKduGRPnZrrjd17h4wSNhCmDYzn";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: Jan Beulich <jbeulich@suse.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <82837f40-130e-c6f0-58a0-c8ff1b1d06a8@suse.com>
Subject: Patch for stable 5.4 and below

--PkzywYoKduGRPnZrrjd17h4wSNhCmDYzn
Content-Type: multipart/mixed;
 boundary="------------25B2E7372FF9E656E7053CD7"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------25B2E7372FF9E656E7053CD7
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Greg,

please add the attached patch to the stable kernels 5.4 and below.
It is a backport of upstream commit 4ba50e7c423c29639878c005732
which already went into 5.10 and 5.12.


Juergen

--------------25B2E7372FF9E656E7053CD7
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-xen-pciback-redo-VF-placement-in-the-virtual-topolog.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-xen-pciback-redo-VF-placement-in-the-virtual-topolog.pa";
 filename*1="tch"

=46rom 4ba50e7c423c29639878c00573288869aa627068 Mon Sep 17 00:00:00 2001
From: Jan Beulich <jbeulich@suse.com>
Date: Tue, 18 May 2021 18:13:42 +0200
Subject: [PATCH] xen-pciback: redo VF placement in the virtual topology

The commit referenced below was incomplete: It merely affected what
would get written to the vdev-<N> xenstore node. The guest would still
find the function at the original function number as long as
__xen_pcibk_get_pci_dev() wouldn't be in sync. The same goes for AER wrt
__xen_pcibk_get_pcifront_dev().

Undo overriding the function to zero and instead make sure that VFs at
function zero remain alone in their slot. This has the added benefit of
improving overall capacity, considering that there's only a total of 32
slots available right now (PCI segment and bus can both only ever be
zero at present).

This is upstream commit 4ba50e7c423c29639878c00573288869aa627068.

Fixes: 8a5248fe10b1 ("xen PV passthru: assign SR-IOV virtual functions to=20
separate virtual slots")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/8def783b-404c-3452-196d-3f3fd4d72c9e@suse=
=2Ecom
Signed-off-by: Juergen Gross <jgross@suse.com>
---
This is a backport for stable-5.4 and below.
---
 drivers/xen/xen-pciback/vpci.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/xen-pciback/vpci.c b/drivers/xen/xen-pciback/vpc=
i.c
index 4162d0e7e00d..cc7450f2b2a9 100644
--- a/drivers/xen/xen-pciback/vpci.c
+++ b/drivers/xen/xen-pciback/vpci.c
@@ -69,7 +69,7 @@ static int __xen_pcibk_add_pci_dev(struct xen_pcibk_dev=
ice *pdev,
 				   struct pci_dev *dev, int devid,
 				   publish_pci_dev_cb publish_cb)
 {
-	int err =3D 0, slot, func =3D -1;
+	int err =3D 0, slot, func =3D PCI_FUNC(dev->devfn);
 	struct pci_dev_entry *t, *dev_entry;
 	struct vpci_dev_data *vpci_dev =3D pdev->pci_dev_data;
=20
@@ -94,23 +94,26 @@ static int __xen_pcibk_add_pci_dev(struct xen_pcibk_d=
evice *pdev,
=20
 	/*
 	 * Keep multi-function devices together on the virtual PCI bus, except
-	 * virtual functions.
+	 * that we want to keep virtual functions at func 0 on their own. They
+	 * aren't multi-function devices and hence their presence at func 0
+	 * may cause guests to not scan the other functions.
 	 */
-	if (!dev->is_virtfn) {
+	if (!dev->is_virtfn || func) {
 		for (slot =3D 0; slot < PCI_SLOT_MAX; slot++) {
 			if (list_empty(&vpci_dev->dev_list[slot]))
 				continue;
=20
 			t =3D list_entry(list_first(&vpci_dev->dev_list[slot]),
 				       struct pci_dev_entry, list);
+			if (t->dev->is_virtfn && !PCI_FUNC(t->dev->devfn))
+				continue;
=20
 			if (match_slot(dev, t->dev)) {
 				pr_info("vpci: %s: assign to virtual slot %d func %d\n",
 					pci_name(dev), slot,
-					PCI_FUNC(dev->devfn));
+					func);
 				list_add_tail(&dev_entry->list,
 					      &vpci_dev->dev_list[slot]);
-				func =3D PCI_FUNC(dev->devfn);
 				goto unlock;
 			}
 		}
@@ -123,7 +126,6 @@ static int __xen_pcibk_add_pci_dev(struct xen_pcibk_d=
evice *pdev,
 				pci_name(dev), slot);
 			list_add_tail(&dev_entry->list,
 				      &vpci_dev->dev_list[slot]);
-			func =3D dev->is_virtfn ? 0 : PCI_FUNC(dev->devfn);
 			goto unlock;
 		}
 	}
--=20
2.26.2


--------------25B2E7372FF9E656E7053CD7
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
Content-Description: OpenPGP public key
Content-Disposition: attachment;
 filename="OpenPGP_0xB0DE9DD628BF132F.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOBy=
cWx
w3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJvedYm8O=
f8Z
d621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y=
9bf
IhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xq=
G7/
377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR=
3Jv
c3MgPGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsEFgIDA=
QIe
AQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4FUGNQH2lvWAUy+dnyT=
hpw
dtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3TyevpB0CA3dbBQp0OW0fgCetToGIQrg0=
MbD
1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbv=
oPH
Z8SlM4KWm8rG+lIkGurqqu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v=
5QL
+qHI3EIPtyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVyZ=
2Vu
IEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJCAcDAgEGFQgCC=
QoL
BBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4RF7HoZhPVPogNVbC4YA6lW7Dr=
Wf0
teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz78X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC=
/nu
AFVGy+67q2DH8As3KPu0344TBDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0Lh=
ITT
d9jLzdDad1pQSToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLm=
XBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkMnQfvUewRz=
80h
SnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMBAgAjBQJTjHDXAhsDBwsJC=
AcD
AgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJn=
FOX
gMLdBQgBlVPO3/D9R8LtF9DBAFPNhlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1=
jnD
kfJZr6jrbjgyoZHiw/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0=
N51
N5JfVRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwPOoE+l=
otu
fe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK/1xMI3/+8jbO0tsn1=
tqS
EUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuZGU+wsB5BBMBAgAjBQJTjHDrA=
hsD
BwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3=
g3O
ZUEBmDHVVbqMtzwlmNC4k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5=
dM7
wRqzgJpJwK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu5=
D+j
LRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzBTNh30FVKK1Evm=
V2x
AKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37IoN1EblHI//x/e2AaIHpzK5h88N=
Eaw
QsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpW=
nHI
s98ndPUDpnoxWQugJ6MpMncr0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZR=
wgn
BC5mVM6JjQ5xDk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNV=
bVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mmwe0icXKLk=
pEd
IXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0Iv3OOImwTEe4co3c1mwARA=
QAB
wsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMvQ/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEw=
Tbe
8YFsw2V/Buv6Z4Mysln3nQK5ZadD534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1=
vJz
Q1fOU8lYFpZXTXIHb+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8=
VGi
wXvTyJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqcsuylW=
svi
uGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5BjR/i1DG86lem3iBDX=
zXs
ZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------25B2E7372FF9E656E7053CD7--

--PkzywYoKduGRPnZrrjd17h4wSNhCmDYzn--

--6eSIovdcFl3Li3hGNp1zXw0sIfWw5fPs8
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmC2NIEFAwAAAAAACgkQsN6d1ii/Ey9b
xgf+J7XlPPb4iRvGsXqPixvqZ0hMDcsfusOAmPu+RK49wkMscCrlR0v7W+nLNv3n709EXHuNXQOn
Z+BTn62flivuKv/L6Qd12IUJAe53ZPZOyeA1wkMlYq+Eg6brT1QEiswHfT0yo3UvAZhg/mX7J/q3
P8RZiFJ9okABIUUfunMMeUwsEu4VgjCBiEBCEeVIqG9LNceQvMHT8X0nJAJOKWBQ1yoNRQJVVlFg
SqJiJEHkb89qtj5V9h3uMwyJzyovzXKoQbaz/Fk7AdRuz7G5ztqkzb5g1PzsY/bBep71qjfNWkuM
2Kwid/dwkZq5Ak2IU2HaB1zY2fevK76O34Gyf4vafQ==
=Ckn/
-----END PGP SIGNATURE-----

--6eSIovdcFl3Li3hGNp1zXw0sIfWw5fPs8--
