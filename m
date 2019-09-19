Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB24B80C8
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 20:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391519AbfISS0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 14:26:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57466 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389805AbfISS0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 14:26:54 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iB18i-000664-79; Thu, 19 Sep 2019 19:26:48 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iB18h-0001a6-C8; Thu, 19 Sep 2019 19:26:47 +0100
Message-ID: <d3bb280b405d6acf0bc4176d63639201ff62853f.camel@decadent.org.uk>
Subject: Re: [PATCH STABLE 4.9] x86, mm, gup: prevent get_page() race with
 munmap in paravirt guest
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Vlastimil Babka <vbabka@suse.cz>, stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        Jann Horn <jannh@google.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        xen-devel@lists.xenproject.org, Oscar Salvador <osalvador@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Date:   Thu, 19 Sep 2019 19:26:41 +0100
In-Reply-To: <20190802160614.8089-1-vbabka@suse.cz>
References: <20190802160614.8089-1-vbabka@suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-FBmeXmh5MpmOJLyUNuxi"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-FBmeXmh5MpmOJLyUNuxi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-08-19 at 18:58 +0100, Vlastimil Babka wrote:
[...]
> Hi, I'm sending this stable-only patch for consideration because it's pro=
bably
> unrealistic to backport the 4.13 switch to generic GUP. I can look at 4.4=
 and
> 3.16 if accepted. The RCU page table freeing could be also considered.

I would be interested in backports for 3.16 and 4.4.

> Note the patch also includes page refcount protection. I found out that
> 8fde12ca79af ("mm: prevent get_user_pages() from overflowing page refcoun=
t")
> backport to 4.9 missed the arch-specific gup implementations:
> https://lore.kernel.org/lkml/6650323f-dbc9-f069-000b-f6b0f941a065@suse.cz=
/
[...]

I suppose that still needs to be addressed for 4.9, right?

Ben.

--=20
Ben Hutchings
Quantity is no substitute for quality, but it's the only one we've got.



--=-FBmeXmh5MpmOJLyUNuxi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl2DyGIACgkQ57/I7JWG
EQmtMBAAi586lgxSJosug6EchWJu1bRh3VBWNNPgJ4J6ffWIDUl3ADDOA94ewtHd
yv3AmUmnMZf6HzM2pxfWzVtzEUf2MnaUtttFjJ3ChyY1PYTd+sKB9xL63Frdfv4K
rhLq/Gh/buYvFzvPAgLFIF9OedV4winWz1OM66ZFPKs56UzTMGWS6FxEDgsuSeVL
UJbi/nU7eEV9BWu7hcnYWedHXemtvzJdVApsDSypcHloXHBDmMl1wkVyYhpKp5UZ
M6s56CvPZXWrIpVo8/YJYIuPLB1ExeaqvddJHGQ8sZAjkcFDSXwTonASK5YdiVYa
+7NtLgVp1sKLls2FDVrhKP70XVwB9HkeThnShdifTO4Q3YIfRF8DjaWwl2EtaC2b
OGOGCdBZZY7kMFdGPiySxQarEAFGK4N6aNeAdl7Dst2XH88olWmSwy4m6Auw/hBD
V5npJtk92/M/QILGzyjrmABefbktwY2xo+byqoAHY/CBGZv/p/WfNikBQpCb7s4g
1LKslHq9CzQzTSoD7EYkjrNHtNFZHhYrJCM8INcM3aK589/3t+ktz13QxKVrCGIp
jZjWn2QA5uINC26dkeszYhzyInFsKO4QeR7riuxKH13rH+D+bVel5HpL8q7gvefd
toAfqG2c3MrjekRhyA8GyTRoHz7LAPbvH+J2tJhA++9AcFW+5l8=
=jVXl
-----END PGP SIGNATURE-----

--=-FBmeXmh5MpmOJLyUNuxi--
