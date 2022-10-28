Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086C8610C51
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 10:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJ1IhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 04:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJ1IhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 04:37:12 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B541C4ED4;
        Fri, 28 Oct 2022 01:37:10 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id u11so7476415ljk.6;
        Fri, 28 Oct 2022 01:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ka+GZa+YYoZ2LUQfvRv+80E0jLSWTavzkIW/ckjHRIU=;
        b=bwK9lXaA1SOQKa/fmDpcdcONDjnMGzcdm8ol9rirIiq1SqKRNI7wKte3TNTwRjN7hN
         0Z8yYCBR8u5gJqzZhE1i8PzfgN2/UEkJM+n3SM2pJdHPwXdbMVoTucc+cuoBjh3XrqH0
         PfpF6gPR8ATR+nZ1KSdJSvag3ZUSF+nPWQGsjtjqltFjKppYPGYcNXJ4CerqXy5GHKMn
         ypMFEKte6XQcA7uaTQjsGFT+t17rDGVNfwrVUmjoLBw05nDFR3rBIT58e75Lxx5Wqj6X
         igQDvUlEAC/IoPc3KRFRNrA/I09LL2J4tHHErvCXNvtB/yejhgKsQ7qAZKujQlJXK2K7
         NT3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ka+GZa+YYoZ2LUQfvRv+80E0jLSWTavzkIW/ckjHRIU=;
        b=C5DCvCIEhF9xHgBLtGCJkU3GW4kqlf8Inz5KZqSpbevXrB0lutMz9FpjSAxUblmQqF
         5T4BkZVMLf43fpWJumAlK5K/Z9QXWGCnrmktF90vnCbPJzEVT6p/4Ucc5S3l/vEZgccN
         q9w8FR66qsSRY2tsi1xgEgwX/csUD9MotaUzz9/Q1Q/DGNzNwrELGad2DMNohni9lyOS
         wmH7/YeXBuAEjXeZ92y4M7581l4Ok7dx63u2qOPmk1nnPI15wxXZ1VDggCyKdrqRKAj7
         c3Tm9QPp/nKuZO2d6QjElGZ7OSTLPvMGf9w8ndal2aTFotxFTcXt3QtZSD6iS6uQXHH6
         Au1A==
X-Gm-Message-State: ACrzQf0lbsmrzHsd6AWvFKRwiN+2WZmhH++1SaNvAp88XFBGW1E3znPz
        B4uakNS7YFIer+q5Oyw7WSM=
X-Google-Smtp-Source: AMsMyM7GYX6E9cQTX8qPbmcz1wx8VmdimEjU87nq+yccXLoEMENUdg6gKqSd2cKISCOmjITQ0JnpXg==
X-Received: by 2002:a2e:8008:0:b0:276:1ee8:718a with SMTP id j8-20020a2e8008000000b002761ee8718amr14622832ljg.133.1666946229044;
        Fri, 28 Oct 2022 01:37:09 -0700 (PDT)
Received: from eldfell ([194.136.85.206])
        by smtp.gmail.com with ESMTPSA id 12-20020ac25f0c000000b004994c190581sm475348lfq.123.2022.10.28.01.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 01:37:08 -0700 (PDT)
Date:   Fri, 28 Oct 2022 11:37:05 +0300
From:   Pekka Paalanen <ppaalanen@gmail.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Hector Martin <marcan@marcan.st>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, asahi@lists.linux.dev
Subject: Re: [PATCH v2] drm/format-helper: Only advertise supported formats
 for conversion
Message-ID: <20221028113705.084502b6@eldfell>
In-Reply-To: <6102d131-fd3f-965b-cd52-d8d3286e0048@suse.de>
References: <20221027135711.24425-1-marcan@marcan.st>
        <6102d131-fd3f-965b-cd52-d8d3286e0048@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/T02il3y85kOs7h=vZE4CGlN";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/T02il3y85kOs7h=vZE4CGlN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Oct 2022 10:07:27 +0200
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Hi
>=20
> Am 27.10.22 um 15:57 schrieb Hector Martin:
> > drm_fb_build_fourcc_list() currently returns all emulated formats
> > unconditionally as long as the native format is among them, even though
> > not all combinations have conversion helpers. Although the list is
> > arguably provided to userspace in precedence order, userspace can pick
> > something out-of-order (and thus break when it shouldn't), or simply
> > only support a format that is unsupported (and thus think it can work,
> > which results in the appearance of a hang as FB blits fail later on,
> > instead of the initialization error you'd expect in this case).
> >=20
> > Add checks to filter the list of emulated formats to only those
> > supported for conversion to the native format. This presumes that there
> > is a single native format (only the first is checked, if there are
> > multiple). Refactoring this API to drop the native list or support it
> > properly (by returning the appropriate emulated->native mapping table)
> > is left for a future patch.
> >=20
> > The simpledrm driver is left as-is with a full table of emulated
> > formats. This keeps all currently working conversions available and
> > drops all the broken ones (i.e. this a strict bugfix patch, adding no
> > new supported formats nor removing any actually working ones). In order
> > to avoid proliferation of emulated formats, future drivers should
> > advertise only XRGB8888 as the sole emulated format (since some
> > userspace assumes its presence).
> >=20
> > This fixes a real user regression where the ?RGB2101010 support commit
> > started advertising it unconditionally where not supported, and KWin
> > decided to start to use it over the native format and broke, but also
> > the fixes the spurious RGB565/RGB888 formats which have been wrongly
> > unconditionally advertised since the dawn of simpledrm.
> >=20
> > Fixes: 6ea966fca084 ("drm/simpledrm: Add [AX]RGB2101010 formats")
> > Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Hector Martin <marcan@marcan.st> =20
>=20
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
>=20
> Thanks for your patch. I have verified that video=3D-{16,24} still works=
=20
> with simpledrm.
>=20
> > ---
> > I'm proposing this alternative approach after a heated discussion on
> > IRC. I'm out of ideas, if y'all don't like this one you can figure it
> > out for yourseves :-)
> >=20
> > Changes since v1:
> > This v2 moves all the changes to the helper (so they will apply to
> > the upcoming ofdrm, though ofdrm also needs to be fixed to trim its
> > format table to only formats that should be emulated, probably only
> > XRGB8888, to avoid further proliferating the use of conversions),
> > and avoids touching more than one file. The API still needs cleanup
> > as mentioned (supporting more than one native format is fundamentally
> > broken, since the helper would need to tell the driver *what* native
> > format to use for *each* emulated format somehow), but all current and
> > planned users only pass in one native format, so this can (and should)
> > be fixed later.
> >=20
> > Aside: After other IRC discussion, I'm testing nuking the
> > XRGB2101010 <-> ARGB2101010 advertisement (which does not involve
> > conversion) by removing those entries from simpledrm in the Asahi Linux
> > downstream tree. As far as I'm concerned, it can be removed if nobody
> > complains (by removing those entries from the simpledrm array), if
> > maintainers are generally okay with removing advertised formats at all.
> > If so, there might be other opportunities for further trimming the list
> > non-native formats advertised to userspace. =20
>=20
> IMHO all of the extra A formats can immediately go. We have plenty of=20
> simple drivers that only export XRGB8888 plus sometimes a few other=20
> non-A formats. If anything in userspace had a hard dependency on an A=20
> format, we'd probably heard about it.
>=20
> In yesterday's discussion on IRC, it was said that several devices=20
> advertise ARGB framebuffers when the hardware actually uses XRGB? Is=20
> there hardware that supports transparent primary planes?

I'm fairly sure such hardware does exist, but I don't know if it's the
drivers in question here.

It's not uncommon to have extra hardware planes below the primary
plane, and then use alpha on primary plane to cut a hole to see through
to the "underlay" plane. This is a good setup for video playback, where
the video is on the underlay, and (a slow GPU or CPU renders) the
subtitles and UI on the primary plane.

I've heard that some hardware also has a separate background color
"plane" below all hardware planes, but I forget if upstream KMS exposes
that.

You'd find this mostly in "embedded" display chips.


Thanks,
pq

> Before removing the extra non-A formats, we first have to fix the fbdev=20
> console's format selection. So if users set video=3D-24 without native=20
> hardware support, simpledrm (and any other driver) falls back to a=20
> supported format. This worked with the old fbdev drivers, such as=20
> simplefb and efifb, and some users expect it.
>=20
> If nothing else comes in, I'll merge your patch on Monday.
>=20
> Best regards
> Thomas

--Sig_/T02il3y85kOs7h=vZE4CGlN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJQjwWQChkWOYOIONI1/ltBGqqqcFAmNblLIACgkQI1/ltBGq
qqcizA//Zy5WiKUGT37azP+IbUk+bTDsYM8fB2JTBwXdJqkoJsUaj3uDQoZY6NJB
uR9BHhKoyjxq2olEDvN/W28bu246aelBWrgOGWYIHu2ULLSkUk0pnVkruswjtJe9
opP/G4H8yxUhgHKrr8A493lfW9xXi84nTQoKFyJGp/iQgPjoiGiyAe5l9R0GRpES
oyTBjs5gMX7aiExyYNcAeGNnypR7odLyrl0EatDkScJLAzy6xu/xUHpM2ucq4t+B
JqWBQ8xLrqlBa85/2ZKObC6xrg+DIVAAsbQ+ToeZQIFpJL7BvrozCx7kFw92+bTp
sQo20gDE/WfEYrxXzkaE6kWKGr8AflXsxVBb1Nkfl6SJ35wIBrltMWz9IYqcD5s2
xR0xipLq23hW6/6biSsnGWvomwpvTY5xXE7KE11VjtEaG5qwqZkv5hHJ71fd1d48
5Vb3mB46cHT59Nq7hwtdvfWCHGpcGBC/ckySjbnzTR/QxhP9lZsLj26bUHKOErU4
GuadyHI8Rfi1e5O3odKsaHmlJsE6CYFlwquG77GKjyvlpK8Mk0K8bi1z4p+U/2m9
QhHXc2xHykVtdg1GVQ8faR+OTrdFFsgFMW6+nU+plXgiLEZHEDGbkjL4RSspguNt
33nwwt3WTto+LaomcNYXm9ctZIOTYf9ZypXbTa0c6/pGIo1DHGQ=
=jzYV
-----END PGP SIGNATURE-----

--Sig_/T02il3y85kOs7h=vZE4CGlN--
