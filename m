Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E85610CE6
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 11:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiJ1JRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 05:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiJ1JRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 05:17:52 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C701C6BCD;
        Fri, 28 Oct 2022 02:17:50 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id d3so7629822ljl.1;
        Fri, 28 Oct 2022 02:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2+bFbBP8ns8xq3x2BMd450Ge6FZT8Vp3QkbUmMsSfsU=;
        b=IIfNbwIMwTKh0YKpr3QJiWhdsYqTnLLGe9aXQ+wujmhk3gQV/VF5IbWJ/yr2g5xTPK
         y8g5FKBf9kzx/3ZycjuIko7bFhLd7R+SjO/fEOGDJpO5vu8NTnREc/y2pdy5rHvSFY9u
         bQljKGl2VXbzfsrwgxP5zH6DwzGNBHvUzPLO7DaTAYUDbkMzDK5X4gXVGgn6yQpTNLOE
         xuHFYlsH6GH/ZpQV6mWJd3RqPlxPfYM6jec6bZQCGwylQh9INFGYW0A54XnFZLDNmtNw
         shKvn3pxNM8nitaIdnExFKxv8DECEu7ttcXnHW9cq5A7dCpqCv1FZwqYzwO4zgmQxST1
         nTfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2+bFbBP8ns8xq3x2BMd450Ge6FZT8Vp3QkbUmMsSfsU=;
        b=RCKKet3rmsWYg5oevN/US2uatspTN72fEqQkziMCVMpxH71u6lhMrVH0/AaIBgMIYa
         BjVaPvfrmIHYH437gFA4pRn+qnfABBDPYroXS040t8OpuXS/1deFMA3Bp+YqHoFMnklI
         anH+8sGpvmhojL92vcTbW4W/IUW0WR5OeN95naG+W/rvywEqm1+nCetTvuZTkVJK+cIM
         xgzimetNbTbs7kU48Vkg91c/TdABfI+9RGRsPlHR3VueghROEt9Qs2eiJBfWa/UoIE8K
         wHcTyBUbI5tYqCXhMBOtg/A4J8QnqIAcPDO3PHZbMzNfXvKNJ85/Nq3EVqFepLXYl1RY
         s8iA==
X-Gm-Message-State: ACrzQf3ftUbpSiz4vx0GDxwdwljawD2OiAUA5ZEo6gpuTZuAx+U0LXbu
        t7nm1ZSvNVRdTQhJHwbA85o=
X-Google-Smtp-Source: AMsMyM52cCC5l0/pleoxmx+UasWkyr1+rt73OdGzubrzzFENKmyuA7WgCfvadZ+G4x/hdqKERNxYAw==
X-Received: by 2002:a2e:9e93:0:b0:277:2d4c:6e98 with SMTP id f19-20020a2e9e93000000b002772d4c6e98mr3038861ljk.110.1666948668832;
        Fri, 28 Oct 2022 02:17:48 -0700 (PDT)
Received: from eldfell ([194.136.85.206])
        by smtp.gmail.com with ESMTPSA id o4-20020ac24944000000b0048aa9d67483sm484785lfi.160.2022.10.28.02.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 02:17:48 -0700 (PDT)
Date:   Fri, 28 Oct 2022 12:17:44 +0300
From:   Pekka Paalanen <ppaalanen@gmail.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Hector Martin <marcan@marcan.st>,
        Javier Martinez Canillas <javierm@redhat.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org, asahi@lists.linux.dev
Subject: Re: [PATCH v2] drm/format-helper: Only advertise supported formats
 for conversion
Message-ID: <20221028121744.2073d196@eldfell>
In-Reply-To: <efd80dc5-d732-113d-b8fd-398b650beb8f@suse.de>
References: <20221027135711.24425-1-marcan@marcan.st>
        <6102d131-fd3f-965b-cd52-d8d3286e0048@suse.de>
        <20221028113705.084502b6@eldfell>
        <efd80dc5-d732-113d-b8fd-398b650beb8f@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yRiM+hqrOkszcyyxfm6cinC";
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

--Sig_/yRiM+hqrOkszcyyxfm6cinC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Oct 2022 10:53:49 +0200
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Hi
>=20
> Am 28.10.22 um 10:37 schrieb Pekka Paalanen:
> > On Fri, 28 Oct 2022 10:07:27 +0200
> > Thomas Zimmermann <tzimmermann@suse.de> wrote:
> >  =20
> >> Hi
> >>
> >> Am 27.10.22 um 15:57 schrieb Hector Martin: =20
> >>> drm_fb_build_fourcc_list() currently returns all emulated formats
> >>> unconditionally as long as the native format is among them, even thou=
gh
> >>> not all combinations have conversion helpers. Although the list is
> >>> arguably provided to userspace in precedence order, userspace can pick
> >>> something out-of-order (and thus break when it shouldn't), or simply
> >>> only support a format that is unsupported (and thus think it can work,
> >>> which results in the appearance of a hang as FB blits fail later on,
> >>> instead of the initialization error you'd expect in this case).
> >>>
> >>> Add checks to filter the list of emulated formats to only those
> >>> supported for conversion to the native format. This presumes that the=
re
> >>> is a single native format (only the first is checked, if there are
> >>> multiple). Refactoring this API to drop the native list or support it
> >>> properly (by returning the appropriate emulated->native mapping table)
> >>> is left for a future patch.
> >>>
> >>> The simpledrm driver is left as-is with a full table of emulated
> >>> formats. This keeps all currently working conversions available and
> >>> drops all the broken ones (i.e. this a strict bugfix patch, adding no
> >>> new supported formats nor removing any actually working ones). In ord=
er
> >>> to avoid proliferation of emulated formats, future drivers should
> >>> advertise only XRGB8888 as the sole emulated format (since some
> >>> userspace assumes its presence).
> >>>
> >>> This fixes a real user regression where the ?RGB2101010 support commit
> >>> started advertising it unconditionally where not supported, and KWin
> >>> decided to start to use it over the native format and broke, but also
> >>> the fixes the spurious RGB565/RGB888 formats which have been wrongly
> >>> unconditionally advertised since the dawn of simpledrm.
> >>>
> >>> Fixes: 6ea966fca084 ("drm/simpledrm: Add [AX]RGB2101010 formats")
> >>> Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: Hector Martin <marcan@marcan.st> =20
> >>
> >> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> >>
> >> Thanks for your patch. I have verified that video=3D-{16,24} still wor=
ks
> >> with simpledrm.
> >> =20
> >>> ---
> >>> I'm proposing this alternative approach after a heated discussion on
> >>> IRC. I'm out of ideas, if y'all don't like this one you can figure it
> >>> out for yourseves :-)
> >>>
> >>> Changes since v1:
> >>> This v2 moves all the changes to the helper (so they will apply to
> >>> the upcoming ofdrm, though ofdrm also needs to be fixed to trim its
> >>> format table to only formats that should be emulated, probably only
> >>> XRGB8888, to avoid further proliferating the use of conversions),
> >>> and avoids touching more than one file. The API still needs cleanup
> >>> as mentioned (supporting more than one native format is fundamentally
> >>> broken, since the helper would need to tell the driver *what* native
> >>> format to use for *each* emulated format somehow), but all current and
> >>> planned users only pass in one native format, so this can (and should)
> >>> be fixed later.
> >>>
> >>> Aside: After other IRC discussion, I'm testing nuking the
> >>> XRGB2101010 <-> ARGB2101010 advertisement (which does not involve
> >>> conversion) by removing those entries from simpledrm in the Asahi Lin=
ux
> >>> downstream tree. As far as I'm concerned, it can be removed if nobody
> >>> complains (by removing those entries from the simpledrm array), if
> >>> maintainers are generally okay with removing advertised formats at al=
l.
> >>> If so, there might be other opportunities for further trimming the li=
st
> >>> non-native formats advertised to userspace. =20
> >>
> >> IMHO all of the extra A formats can immediately go. We have plenty of
> >> simple drivers that only export XRGB8888 plus sometimes a few other
> >> non-A formats. If anything in userspace had a hard dependency on an A
> >> format, we'd probably heard about it.
> >>
> >> In yesterday's discussion on IRC, it was said that several devices
> >> advertise ARGB framebuffers when the hardware actually uses XRGB? Is
> >> there hardware that supports transparent primary planes? =20
> >=20
> > I'm fairly sure such hardware does exist, but I don't know if it's the
> > drivers in question here.
> >=20
> > It's not uncommon to have extra hardware planes below the primary
> > plane, and then use alpha on primary plane to cut a hole to see through
> > to the "underlay" plane. This is a good setup for video playback, where
> > the video is on the underlay, and (a slow GPU or CPU renders) the
> > subtitles and UI on the primary plane.
> >=20
> > I've heard that some hardware also has a separate background color
> > "plane" below all hardware planes, but I forget if upstream KMS exposes
> > that. =20
>=20
> That's also what I heard of. It's not something we can control within=20
> simpledrm or any other generic driver.
>=20
> I'm worried that we advertise ARGB to userspace when the scanout buffer=20
> is actually XRGB.

What would be the problem with that?
simpledrm would never expose more than only the primary plane, right?
Not even background color.

That means that userspace cannot use the alpha channel for anything
anyway, there is nothing to show through. Or are you thinking about
transparent monitors?

Of course, it would be best to advertise strictly what the hardware
does.

> But if we advertise XRGB and the scanout buffer is=20
> really ARGB, any garbage in the X filler byte would interfere.

Yes, probably. Garbage alpha being used would not hurt if a) userspace
thinks it's rendering XRGB which means that RGB values are all opaque,
and b) the hardware blending mode is pre-multiplied-alpha, and c)
whatever is behind the primary plane is all zeroes.

> If we have a native ARGB scanout buffer, we could advertise XRGB to=20
> userspace and set the filler byte unconditionally during the pageflip=20
> step. That should be safe on all hardware.

Correct. Since you say "filler byte", I assume you are referring to
XRGB8888 only. That's good. Other formats should not be emulated.


Thanks,
pq

--Sig_/yRiM+hqrOkszcyyxfm6cinC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJQjwWQChkWOYOIONI1/ltBGqqqcFAmNbnjgACgkQI1/ltBGq
qqcGyw/9HVztJ6EJNKfXrT+mexYzWTv8w0DDJSMpW9+BsbWFVn0orVIeYq97kp1B
5vfY9OOtvciJ+vkicJ7mQuovhvdT5axFBgY+dqOYNQbn1ffn+bgKPvzszKUo3IPU
uka6O8Afn41EGA3uR+XFtQ1txBwGe1j6ZjJhHrHvq+Z7mdVr8w98lcZZZr8pfy7N
mFZ3hZzmFK/sb0tkFlgqZ5W2aMG+uyz/JHoiGguSZiASkNovnZc/i8RMHMTk8gtA
yz1ou7aC7pk8aC6SsOT0JoaopPglEvq7fvL/oWvMjUoORMP6omSYaP8VPrXs+0nO
LsU3zy9TOsqYxNdzENvAytEtqOZjuek6l7wLq0/yw41WbLEkK/DVEJ4VKFtXPVbw
sfJCMhqXImJedDz7RHsyUelb/e5CV84oQQ/Gk47dyNDSr+27YXKF/6yNioE63ZAC
JWfUWQAhYlc+Q0qIRMBn3cSfqr94XnHHC1vSIqAK+C8nzgh2VN8U60VnXugqHZi0
R4uWuwr2k1YygBrwQCBpXXlDCpLP0eqVLjV3ONRko51XNHO+D7mbtixRUDuGkBxJ
x0kFS8pQGZYsBjur8kEKF9QfEYF5IOUpStZHC4kof48o4kj4s1dAcBSooq0QlOYb
b/JQy7/WPZv8JxuNEq6/TV7mpXUYQrXV6D5nvNZgYt7VNe2/9rQ=
=kGxn
-----END PGP SIGNATURE-----

--Sig_/yRiM+hqrOkszcyyxfm6cinC--
