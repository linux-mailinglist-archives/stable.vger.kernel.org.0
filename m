Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334552754DE
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 11:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgIWJzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 05:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWJzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 05:55:08 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C18C0613CE
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 02:55:08 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id 77so14064375lfj.0
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 02:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=rZX18Nb4B451H35fKxXNz+FOKZsolDgT7G8y6qr1qK8=;
        b=uLypUFcA0E5rVNI+RHeLjOrO4R8ls0qGgb1mQ4xXOjxL4P+SVeUDySQixtaLA2ndbU
         lKcSyW3bD8EfQEQePh+TxLXQHxTA5s9ePEm7DRnXLtO3CcHWhqZqJBUi7rmsPrqW1G3F
         aCE3b230KvbVW9TzmlxeIa/DQtape50xveN6eMW7kVr2rZsGQ4Gl8V8P3RCmkZHESKfu
         J2jVGJJQFNAYEwJGbTeSfY+Ze/HzUlJ6JtsJfqdBBk0OgU47cITD9UbcexFrXZGOmdao
         7vRp5+KY9kApwJ2iq+ikXE60TBTjqa6Ug80zU7x8A5ddtDqP94hAxuFZvPqGgSh7/zbY
         czVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=rZX18Nb4B451H35fKxXNz+FOKZsolDgT7G8y6qr1qK8=;
        b=GlXsKprWqDl33iauqVVhxrcR83Ga2H9ik27Yq+CzDOAaR2CdoS+UBtQDiO7SQqAlx1
         ealbCQOa4Ec5Eeh70AyVU9mjqNPy7VokfsgSR8889zTzIPCdgIITiYjYNtTHoJh1n1gY
         GmBA2MugOPR9kIMaG7zs5hAPqvRnPadJMhC1Lc8uHvnEcnQ34fvKw0w+IRFbUFJtsWAo
         swnqLMffztGdGiioXIONvnOn76CR7R1ZCYPR4LDdM7pxRVj2B2cUc75MbD8kIAmRplkC
         dOPpyNkO2ns2lvWLJa9CwqwJAx18aI2QjsWr1lrDJFljyASjIRvrugyyAsvmQ+2UnMNY
         TwAw==
X-Gm-Message-State: AOAM5314Z4mwGkjofQFWGGnODjhUrsJFW7ZgcgB63Xn9x+TD3KwysXE1
        IvjMYTr0fxMrY459lmlavlY=
X-Google-Smtp-Source: ABdhPJyFeme2PzRuZLADYLxEONkLoODcIN2LPNtvFAqYLkEDt5nJjxLqw/RieypMiZXXaxpboW4iuA==
X-Received: by 2002:a05:6512:3606:: with SMTP id f6mr3398610lfs.282.1600854906538;
        Wed, 23 Sep 2020 02:55:06 -0700 (PDT)
Received: from eldfell ([194.136.85.206])
        by smtp.gmail.com with ESMTPSA id 78sm4635269lfi.81.2020.09.23.02.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 02:55:06 -0700 (PDT)
Date:   Wed, 23 Sep 2020 12:55:02 +0300
From:   Pekka Paalanen <ppaalanen@gmail.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Stone <daniel@fooishbar.org>,
        Simon Ser <contact@emersion.fr>,
        stable <stable@vger.kernel.org>,
        Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH] drm: document and enforce rules around "spurious" EBUSY
 from atomic_commit
Message-ID: <20200923125502.4735f720@eldfell>
In-Reply-To: <CAKMK7uFvaMRK3Zh-s21OG=V3sPQZjn7Z_WQaNMcL=_R36enR2g@mail.gmail.com>
References: <20200922181834.2913552-1-daniel.vetter@ffwll.ch>
        <20200923111717.68d9eb51@eldfell>
        <CAKMK7uFvaMRK3Zh-s21OG=V3sPQZjn7Z_WQaNMcL=_R36enR2g@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/HSKGjOiwSV7m_k8F45bc62z"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/HSKGjOiwSV7m_k8F45bc62z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Sep 2020 11:26:39 +0200
Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> I'm really not awake yet ...
>=20
> On Wed, Sep 23, 2020 at 10:17 AM Pekka Paalanen <ppaalanen@gmail.com> wro=
te:
> >
> > On Tue, 22 Sep 2020 20:18:34 +0200
> > Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > =20
> > > When doing an atomic modeset with ALLOW_MODESET drivers are allowed to
> > > pull in arbitrary other resources, including CRTCs (e.g. when
> > > reconfiguring global resources).

> > If yes, and *if* userspace is single-threaded wrt. to KMS updates,
> > that might offer a way to work around it in userspace. But if userspace
> > is flipping other CRTCs from other threads, TEST_ONLY commit does not
> > help because another thread may cut in and make a CRTC busy. =20
>=20
> This is not a legit programming model for atomic. An atomic commit is
> always relative to the current state. If that state changes, then you
> need to re-run your TEST_ONLY commit. So multiple threads changing
> state in parallel isn't really a good idea anyway. Minimally we'd need
> some kind of TEST_ONLY pile-up, so you can validate a change assuming
> another commit has already happened. That's even harder than deep
> queues on the commit side, we'd probably need full rollback of
> commits.

Yes, very good point. I forgot that for a moment.


Thanks,
pq

--Sig_/HSKGjOiwSV7m_k8F45bc62z
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJQjwWQChkWOYOIONI1/ltBGqqqcFAl9rG3YACgkQI1/ltBGq
qqeSUA//X6te+sf+nLiLiPV9iiFduKqr69eeaBnYPlJXqr1GWWR+3jQ16GV39RUT
E+kx2ZmlTm8eJ0lQFbrbvbEpyikbOv+gH4s4E1t7GHOBjEldzGD30xtylfSUDIJJ
YdJw3bxYFt3bPGshSWIub6p0ig3OuBe9jvonzNggWRqwBMY/zVvVwrpVBhZDy10T
jHZ0HQT2OwFoxqbF46WO87+Dc6i+HHvQPHMjfj7Otk10ZuGAiWUKq+ry58iDliGn
KNbc5QWaSMInsTDq/anoMaB36yFG/s1/eYc8mEjjSj6Xh+GGPfrT1vxZHjIOB0qd
JvW2wW9bTEKOjaNlj7KIipGbpnvjFyAxX7kF6xarTkgLUbNoRw7xSTUNPOEatW9R
/3b/k2voBaagpdVEnUyxxjQYkrO36SCSrUHn5wFnJUXCfO/FyijqWGg7EDdc2Apr
no9vATwKFSNPI4Ilr6pe0wLTw8ETDUAtu2XCkaWuAQDvPg4759/MBPZjZgWAEFX0
XaddqM8nOm2+zZzGkx7L5XGcFta09TbaMqKFIO5KlypU6tapZf7u44dw1az4ninm
aAoX4kGBNQAEaB1ryfA+1hGR8OWwzl2fluArXiSOP+7OZNXgLv/i0Uu44YE/uN68
FqvTbwEuwMIAtKd/kTyoh7AOYK5W8/D/l7U/dpfGt96xge17R4o=
=BdYf
-----END PGP SIGNATURE-----

--Sig_/HSKGjOiwSV7m_k8F45bc62z--
