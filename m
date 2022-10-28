Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216F0610E74
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 12:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJ1K2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 06:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiJ1K2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 06:28:41 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D056C947;
        Fri, 28 Oct 2022 03:28:39 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id o12so7538442lfq.9;
        Fri, 28 Oct 2022 03:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tkun3rRy+GzEVIQYIXSl4ZmmxciQnM9huc9BB1/7wtE=;
        b=SBX8JZ9XHJCczt7NDMF++v1va3K7PfSKi0knv8JyLkArFjK8rumzqOEWBr1aptiLAw
         dQmvgEisV+NfgBA9+m1m3/oO7iBbVPvE/rDFaUBMAeMvcjlqoleTe+GN4UZNmmve/jG6
         HU3mCC2XHat/5xtiESvjdk7++heBO2VyJDm/6ntJqToqE/l1rYWvji4hk7hjksSGFjrq
         M780Er4qTM3Igm9U9Fd/oKuDv3PQ96pBUtfaxhJudrA4ItL9v0oBLYb1fdy0Gbyuu/tn
         ugQc+qmA2EhABlFjWUSVjzoaYdWhsQBjK9dGj+pbAD/YcPLED5GgHrL7hub91p9L98rW
         JFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tkun3rRy+GzEVIQYIXSl4ZmmxciQnM9huc9BB1/7wtE=;
        b=gSuaS+vQy9Au0UfB80po5YNmfpXuP4c8RSh6ANmDrs+uwZcUfz2qtu8hyu3eCI2msz
         YLsH7TWvuM8wIZtW8qCpa7MihwJMr6TyPh4ePvajQwHEARfTUmfMgC3DXY20Lc4OSxZ2
         OAHODUT3pBSqH2LcVQk3ZoajSkCCxOZpV3QfFABdKXKgYg1SAdDD4UPACSUafRgc09VH
         Pn23952tDLRDe4NjDXkhLY2tEsUvjqVsl4d4LKGsHTqyk0KYAx/2blCl4k8Jgqo8nulb
         DbUj7HsbFx9eZdxpgOWTwq/PBD2SpiU+t9MnphU+hO5ltOQXKM0warJXS+UYqNmjA8/n
         qXuA==
X-Gm-Message-State: ACrzQf1MIhexiXa6F3rcjapsEi5DNNjq2z+YbVNhNR4C+EB8qz+FcGg2
        YvKhEFO8IrrGh8i1h0jtkO4=
X-Google-Smtp-Source: AMsMyM6Ky5cOVvQNbwTNrAZX8JSaggXdVR5qTbRzqueJXB8sJK0bOuw4suTa/Sr3h62sZF6Hw3Tv4A==
X-Received: by 2002:a05:6512:1287:b0:4a2:a7c3:641d with SMTP id u7-20020a056512128700b004a2a7c3641dmr21949742lfs.511.1666952917737;
        Fri, 28 Oct 2022 03:28:37 -0700 (PDT)
Received: from eldfell ([194.136.85.206])
        by smtp.gmail.com with ESMTPSA id i15-20020a056512006f00b004a4251c7f75sm506551lfo.202.2022.10.28.03.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 03:28:37 -0700 (PDT)
Date:   Fri, 28 Oct 2022 13:28:24 +0300
From:   Pekka Paalanen <ppaalanen@gmail.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     dri-devel@lists.freedesktop.org, Hector Martin <marcan@marcan.st>,
        Javier Martinez Canillas <javierm@redhat.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        asahi@lists.linux.dev
Subject: Re: [PATCH v2] drm/format-helper: Only advertise supported formats
 for conversion
Message-ID: <20221028132824.7155b072@eldfell>
In-Reply-To: <98ec2c54-cf99-6465-31a1-b63e3b4d021d@suse.de>
References: <20221027135711.24425-1-marcan@marcan.st>
        <6102d131-fd3f-965b-cd52-d8d3286e0048@suse.de>
        <20221028113705.084502b6@eldfell>
        <efd80dc5-d732-113d-b8fd-398b650beb8f@suse.de>
        <20221028121744.2073d196@eldfell>
        <98ec2c54-cf99-6465-31a1-b63e3b4d021d@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hL8suL49hYQ0bVssPUv1n2x";
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

--Sig_/hL8suL49hYQ0bVssPUv1n2x
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Oct 2022 11:34:34 +0200
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Hi
>=20
> Am 28.10.22 um 11:17 schrieb Pekka Paalanen:
> > On Fri, 28 Oct 2022 10:53:49 +0200
> > Thomas Zimmermann <tzimmermann@suse.de> wrote:
> >  =20
> >> Hi
> >>
> >> Am 28.10.22 um 10:37 schrieb Pekka Paalanen: =20
> >>> On Fri, 28 Oct 2022 10:07:27 +0200
> >>> Thomas Zimmermann <tzimmermann@suse.de> wrote:
> >>>     =20
> >>>> Hi
> >>>>
> >>>> Am 27.10.22 um 15:57 schrieb Hector Martin: =20
> >>>>> drm_fb_build_fourcc_list() currently returns all emulated formats
> >>>>> unconditionally as long as the native format is among them, even th=
ough
> >>>>> not all combinations have conversion helpers. Although the list is
> >>>>> arguably provided to userspace in precedence order, userspace can p=
ick
> >>>>> something out-of-order (and thus break when it shouldn't), or simply
> >>>>> only support a format that is unsupported (and thus think it can wo=
rk,
> >>>>> which results in the appearance of a hang as FB blits fail later on,
> >>>>> instead of the initialization error you'd expect in this case).
> >>>>>
> >>>>> Add checks to filter the list of emulated formats to only those
> >>>>> supported for conversion to the native format. This presumes that t=
here
> >>>>> is a single native format (only the first is checked, if there are
> >>>>> multiple). Refactoring this API to drop the native list or support =
it
> >>>>> properly (by returning the appropriate emulated->native mapping tab=
le)
> >>>>> is left for a future patch.
> >>>>>
> >>>>> The simpledrm driver is left as-is with a full table of emulated
> >>>>> formats. This keeps all currently working conversions available and
> >>>>> drops all the broken ones (i.e. this a strict bugfix patch, adding =
no
> >>>>> new supported formats nor removing any actually working ones). In o=
rder
> >>>>> to avoid proliferation of emulated formats, future drivers should
> >>>>> advertise only XRGB8888 as the sole emulated format (since some
> >>>>> userspace assumes its presence).
> >>>>>
> >>>>> This fixes a real user regression where the ?RGB2101010 support com=
mit
> >>>>> started advertising it unconditionally where not supported, and KWin
> >>>>> decided to start to use it over the native format and broke, but al=
so
> >>>>> the fixes the spurious RGB565/RGB888 formats which have been wrongly
> >>>>> unconditionally advertised since the dawn of simpledrm.
> >>>>>
> >>>>> Fixes: 6ea966fca084 ("drm/simpledrm: Add [AX]RGB2101010 formats")
> >>>>> Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
> >>>>> Cc: stable@vger.kernel.org
> >>>>> Signed-off-by: Hector Martin <marcan@marcan.st> =20
> >>>>
> >>>> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> >>>>
> >>>> Thanks for your patch. I have verified that video=3D-{16,24} still w=
orks
> >>>> with simpledrm.
> >>>>    =20
> >>>>> ---
> >>>>> I'm proposing this alternative approach after a heated discussion on
> >>>>> IRC. I'm out of ideas, if y'all don't like this one you can figure =
it
> >>>>> out for yourseves :-)
> >>>>>
> >>>>> Changes since v1:
> >>>>> This v2 moves all the changes to the helper (so they will apply to
> >>>>> the upcoming ofdrm, though ofdrm also needs to be fixed to trim its
> >>>>> format table to only formats that should be emulated, probably only
> >>>>> XRGB8888, to avoid further proliferating the use of conversions),
> >>>>> and avoids touching more than one file. The API still needs cleanup
> >>>>> as mentioned (supporting more than one native format is fundamental=
ly
> >>>>> broken, since the helper would need to tell the driver *what* native
> >>>>> format to use for *each* emulated format somehow), but all current =
and
> >>>>> planned users only pass in one native format, so this can (and shou=
ld)
> >>>>> be fixed later.
> >>>>>
> >>>>> Aside: After other IRC discussion, I'm testing nuking the
> >>>>> XRGB2101010 <-> ARGB2101010 advertisement (which does not involve
> >>>>> conversion) by removing those entries from simpledrm in the Asahi L=
inux
> >>>>> downstream tree. As far as I'm concerned, it can be removed if nobo=
dy
> >>>>> complains (by removing those entries from the simpledrm array), if
> >>>>> maintainers are generally okay with removing advertised formats at =
all.
> >>>>> If so, there might be other opportunities for further trimming the =
list
> >>>>> non-native formats advertised to userspace. =20
> >>>>
> >>>> IMHO all of the extra A formats can immediately go. We have plenty of
> >>>> simple drivers that only export XRGB8888 plus sometimes a few other
> >>>> non-A formats. If anything in userspace had a hard dependency on an A
> >>>> format, we'd probably heard about it.
> >>>>
> >>>> In yesterday's discussion on IRC, it was said that several devices
> >>>> advertise ARGB framebuffers when the hardware actually uses XRGB? Is
> >>>> there hardware that supports transparent primary planes? =20
> >>>
> >>> I'm fairly sure such hardware does exist, but I don't know if it's the
> >>> drivers in question here.
> >>>
> >>> It's not uncommon to have extra hardware planes below the primary
> >>> plane, and then use alpha on primary plane to cut a hole to see throu=
gh
> >>> to the "underlay" plane. This is a good setup for video playback, whe=
re
> >>> the video is on the underlay, and (a slow GPU or CPU renders) the
> >>> subtitles and UI on the primary plane.
> >>>
> >>> I've heard that some hardware also has a separate background color
> >>> "plane" below all hardware planes, but I forget if upstream KMS expos=
es
> >>> that. =20
> >>
> >> That's also what I heard of. It's not something we can control within
> >> simpledrm or any other generic driver.
> >>
> >> I'm worried that we advertise ARGB to userspace when the scanout buffer
> >> is actually XRGB. =20
> >=20
> > What would be the problem with that?
> > simpledrm would never expose more than only the primary plane, right?
> > Not even background color. =20
>=20
> Right. My concerns are the proliferation of A format, and userspace that=
=20
> tries something fancy with that incorrect A byte, which leads to display=
=20
> artifacts. Like fading in/out the content of the primary plane.

I agree.

> > That means that userspace cannot use the alpha channel for anything
> > anyway, there is nothing to show through. Or are you thinking about
> > transparent monitors? =20
>=20
> I can't tell if you're serious, but I'm not going to rule this out. ;)

I am kind of serious. See-through monitors would be cool if not
practical. They actually kind of exist already as projections through
semi-mirrors like in AR-goggles or car windscreens, but they don't yet
allow displaying opaque black (or do they?). OTOH, one could use a
traditional LCD and replace the mirror with another polarizing filter,
I guess. Maybe that's a way to implement controllable opacity. I've no
idea if anyone has combined these technologies.

Hmm, if alpha controls the opacity layer, then RGB values would behave
as if pre-multiplied in optical blending. The projected RGB primaries
can only add light on top of what passes through the LCD opacity mask.

Why don't I have one of those yet!


Thanks,
pq

--Sig_/hL8suL49hYQ0bVssPUv1n2x
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJQjwWQChkWOYOIONI1/ltBGqqqcFAmNbrsgACgkQI1/ltBGq
qqcvPw//Tp0h1jYN+RREbW3JJUS8hX9177kB4uZA4+7JGREUDBPqaRLxYqp2s+Ut
068BR7NP8QEMbVABjaArCCPrbwJcDluEXm8Il10Ednni6DFunoME4YxSkcBVJdw/
S7wHQtYzyg1shR8J3gtpKyaRzkrmvP32YZr4EhShVKq+TBkTRZglKPmJqC+4X/gH
mf4tZP8fbX3wWABA7kZYMcraGTELG7shkomG037/QqyRoE5tqzWc3OrNM+SOCe4B
62A1bAi5yVCFk6XJXSyO3MN6Pcqb0+0WXOSvcFzA4Pkj3IMh8VmtEPRZ4XMmQQQ9
Q5oW5w2NO/m8jpog/aok1B4iJBIJOKZ5k1ZMLDajw1x/xWi4y0EeEXKw/K0stqMc
wV4zudB/p++ttsUc7ihbydmKNNQDSNl70hH44qNgSYddpbsgDIDxAwtlX9aiAJ4c
1tMzS0lJCcysaEF8Jzja0Ow4nwwc0lG3+QVJPEKnkUwIASFJWoccbCVHE+oV7eQg
UZN1VkNmjfveX2wZYrfHb+4E4BNDiWBQHzOH/xT8qX+nooXnzGbVWTb7QNqz8A0M
Tzw5r9luliZaP8U6wSEzFbcK2JVfC05CoBqs2IGAok/gCnZNbrxTH1w3xYF9njX3
pXGfp9Ef5HsNB40e0s88U2fU4Hs2hyclaRVE+3vsrC34vo6LGt8=
=z5Fk
-----END PGP SIGNATURE-----

--Sig_/hL8suL49hYQ0bVssPUv1n2x--
