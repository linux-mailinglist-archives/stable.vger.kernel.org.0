Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A2387AD0
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406273AbfHINE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:04:56 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39080 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfHINEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 09:04:55 -0400
Received: by mail-ed1-f65.google.com with SMTP id e16so1646007edv.6;
        Fri, 09 Aug 2019 06:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HikLq69FX/TB2EKLEAL0B2ZPlM84LHQzg3aeaVoxCn8=;
        b=EfDC1Di+1kxiLgWnx0lXgZfLNkPpFiWcfPyvXObRiRV8PouU7NQX5r7A8JTEJSKtry
         QshsLlGLedu6/aoj34YNnhs6ZMuMZrMnGPYoBb5nUcew9ErOnem9WL1831Pl//fIsxGr
         8zHmsgm+GF1YSq0jj2BgY2hIcT7GCkqt+PKNyO2vjZpAGA48REmNqq/0P3uG5NTLpina
         y5CYkhlXZ+UJOEQ4D4eNhV4B4QSdxuDRxLjs/2p69m947+JNpplSbPdQ33JcAnct6XXG
         /YRWSZrpJf/zT55aD8LKWj92kL9dVmyrnBFUdXC5vfpHQZsFdfTx3m+93U+o18oSuNBA
         4DMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HikLq69FX/TB2EKLEAL0B2ZPlM84LHQzg3aeaVoxCn8=;
        b=MLmNPnzcWnlKiPEe90fIQXkyLeGmlFYKSnrsZlVKSl8k6ZKdUJb1/ixIADOCrK1Kch
         XgpZTsRS1CBA5RL7E2oPaf7T0uEvcLy92hyGfT0X+WQTypiCRf4KwQ/aCPD2tpp/de9c
         CAc4kghEkkXYx2zBM+YfNyisAnedTG8xaqLHjTJuSuv8l+qetotKeUXPs9zPCp+wMcyz
         BtnTNfYHllkIb9CttrLSRVpMZ5pgVhXm2VY7bu8myS0NiBzt71JDOU1Hm6nOZ6T4RjrS
         0XSHxGLrAkFI8Tr4P1WaHLTWa17tJHOOpDFRoo/s/cLVST06CzwTZQCU9XCkmlvR9krM
         NexA==
X-Gm-Message-State: APjAAAWBd0ZaktGTaccmjXEZM9juJ0cIRq4xwUFxNsVKS5u+Kh+dVsfT
        hKKThcn1c+tNgRZvzsGw5VI=
X-Google-Smtp-Source: APXvYqxa1/+ph3WiFYEd6beaFORcNnEbd4v8M1yObgCcJdJFGAybNCTDCndL3Q+J5ae8Xge7mecytA==
X-Received: by 2002:a17:907:447e:: with SMTP id oo22mr17854086ejb.169.1565355893266;
        Fri, 09 Aug 2019 06:04:53 -0700 (PDT)
Received: from localhost (pD9E51890.dip0.t-ipconnect.de. [217.229.24.144])
        by smtp.gmail.com with ESMTPSA id w35sm22498609edd.32.2019.08.09.06.04.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 06:04:51 -0700 (PDT)
Date:   Fri, 9 Aug 2019 15:04:49 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.2 00/20] 5.2.6-stable review
Message-ID: <20190809130449.GA27957@ulmo>
References: <20190802092055.131876977@linuxfoundation.org>
 <20190802172105.18999-1-thierry.reding@gmail.com>
 <20190803070932.GB24334@kroah.com>
 <20190805114821.GA24378@ulmo>
 <20190809085253.GA25046@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20190809085253.GA25046@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 09, 2019 at 10:52:53AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Aug 05, 2019 at 01:48:21PM +0200, Thierry Reding wrote:
> > Hi Greg,
>=20
> Sorry for the delay, this got pushed down my queue...
>=20
> > I stumbled across something as I was attempting to automate more parts
> > of our process to generate these reports. The original test results were
> > from a different version of the tree: 5.2.6-rc1-gdbc7f5c7df28. I suspect
> > that's the same thing that you were discussing with Pavel regarding the
> > IP tunnel patch that was added subsequent to the announcement.
> >=20
> > Just for my understanding, does this mean that the patch still makes it
> > into the 5.2.6 release, or was it supposed to go into 5.2.7?
> >=20
> > One problem that I ran into was that when I tried to correlate the test
> > results with your announcement email, there's no indication other than
> > the branch name and the release candidate name (5.2.6-rc1 in this case),
> > so there's no way to uniquely identify which test run belongs to the
> > announcement. Given that there are no tags for the release candidates
> > means that that's also not an option to uniquely associate with the
> > builds and tests.
> >=20
> > While the differences between the two builds are very minor here, I
> > wonder if there could perhaps in the future be a problem where I report
> > successful results for a test, but the same tests would be broken by a
> > patch added to the stable-rc branch subsequent to the announcement. The
> > test report would be misleading in that case.
> >=20
> > I noticed that you do add a couple of X-KernelTest-* headers to your
> > announcement emails, so I'm wondering if perhaps it was possible for you
> > to add another one that contains the exact SHA1 that corresponds to the
> > snapshot that's the release candidate. That would allow everyone to
> > uniquely associate test results with a specific release candidate.
> >=20
> > That said, perhaps I've just got this all wrong and there's already a
> > way to connect all the dots that I'm not aware of. Or maybe I'm being
> > too pedantic here?
>=20
> You aren't being pedantic, I think you are missing exactly what the
> linux-stable-rc tree is for and how it is created.
>=20
> Granted, it's not really documented anywhere so it's not your fault :)
>=20
> The linux-stable-rc tree is there ONLY for people who want to test the
> -rc kernels and can not, or do not want to, use the quilt tree of
> patches in the stable-queue.git tree on kernel.org.  I generate the
> branches there from a script that throws away the current -rc branch and
> rebuilds it "from scratch" by applying the patches that are in the
> stable-quilt tree and then adds the -rc patch as well.  This tree is
> generated multiple times when I am working on the queues and then when I
> want to do a "real" -rc release.
>=20
> The branches are constantly rebased, so you can not rely on 'git pull'
> doing the right thing (unless you add --rebase to it), and are there for
> testing only.
>=20
> Yes, you will see different results of a "-rc1" release in the tree
> depending on the time of day/week when I created the tree, and sometimes
> I generate them multiple times a day just to have some of the
> auto-builders give me results quickly (Linaro does pull from it and
> sends me results within the hour usually).
>=20
> So does that help?  Ideally everyone would just use the quilt trees from
> stable-queue.git, but no everyone likes that, so the -rc git tree is
> there to make automated testing "easier".  If that works with your
> workflow, wonderful, feel free to use it.  If not, then go with the
> stable-quilt.git tree, or the tarballs on kernel.org.

I'll have to look into that, to see if that'd work. I have to admit that
having a git tree to point scripts at is rather convenient for
automation.

> And as for the SHA1 being in the emails, that doesn't make all that much
> sense as that SHA1 doesn't live very long.  When I create the trees
> locally, I instantly delete them after pushing them to kernel.org so I
> can't regenerate them or do anything with them.

Fair enough. I suppose the worst thing that could happen is that we may
fail to test a couple of commits occasionally. In the rare case where
this actually matters we'll likely end up reporting the failure for the
stable release, in which case it can be fixed in the next one.

> DOes that help explain things better?

Yes, makes a lot more sense now. Thanks for taking the time to explain
it. Do you want me to snapshot this and submit it as documentation
somewhere for later reference?

Thierry

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl1Nb2UACgkQ3SOs138+
s6FRdA/9GU0yA4w4dROmGZXrA3QoBnNlSLJG5WkFykmE2USTwALWZDZcQZRSvlFc
TWH/nXRYOfYnpEA8rJqvP2poWo/1UU0mDmu4bnHB25qsBp5+42Y/tsX9mEwcm9Sl
Ob7tx1RZ/AFppxFoiwpsxBhVTDx8YuWQrT8okCT984LO531RuJWbuRLD2IyDPGh3
sXuLTpKGbA46GNy0deb21ehVkHSIFmyYSjUcw5tAfFAn89nsBh+PYDq8XxSsFjnA
3GyPfWHPgPDjn8vl3u0BwYrQ7AxFZJmjChT7oymAEUHwEIS+mdSGJVBnie5vRfeD
AFqFBgz+tJKGl1Jt0yVC2OJaZomsLhljdUCjU+IKuRSK0U/RDGq9dgHYBJykoIkR
HeNrGomeIWdqhnK6G1+ip8KZ3Yv7NJYo1oDhBWXh8uPTrqXrHhwUX8lIC/InjYny
sif1WMwoTvc3mR7jEAq/WWvLb0vopfQxllDUxXTyNXweirLd3c5+Um2NmRjNGzi6
K4PPLfBvkEYRpmL4Ne+mACsm8uaGE6U/oEkbY8Xof6Ltm0q3tRs7Nwk6RPT6obWx
qRaOTAv+SD60YymGijJsOohEabk85VtejJx0Oe1sLprAN9eLNsAX/UtsZ7WbqjDd
4W4ga4Svh0XB97HLNGhUommS0hsV06gAPWNnWXiCxSQeGPX8Mlw=
=Z8/R
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
