Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41831189BD
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 14:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfLJN1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 08:27:37 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40777 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbfLJN1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 08:27:37 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so20087494wrn.7;
        Tue, 10 Dec 2019 05:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RekjqW1ZbDFBW6dgxIKrAVm55RszEGDcZgCongbr73U=;
        b=NnzCbw8YCXTc9phEkoyWHOSWMisbmcA1cNqPxjeioQCFALUheMo5gltJxBC2/01L3/
         mes+WfmhKjSRGonBd9EyHlf3j/MYquz+OlIrqWwOXl6pw8hgDrebv9NIAE+315VwatOM
         98ZAIYV2vSSVmSdixuSfmSQ7g6PKqtpyU/P276ZELIqB2KUjtE82d3s+kq7SGG06EeXZ
         mK+0282laBvZgSxpkRa3qUroqvAUWFyWjKU3XygO160J+YylbYQ5k98xWS6WxcX+Mm/w
         Rw/ffQtDku4hRoAbAxvyOalvenXj7K7EDJ+Yun8OYtXEg71LmfEcqM47kJAQfquqrLFP
         q+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RekjqW1ZbDFBW6dgxIKrAVm55RszEGDcZgCongbr73U=;
        b=DTEVGsENHkknEmNMZnY0UWhTV+d31lW82NxERgte8xKxf8QpDxbJZx9+B5fqVIIA3c
         MkIt0ugqZBvfceJG88lnKrfRmvQlT2xOe5Z0QkLbrky4SjuGei8WoMCQeUlJHOriln70
         1o8rozYuqjN6UF6ILQJws9JgtVYHInHRcJuaclQGnH4klyVFagnLLcT7q50PDxwLXJNc
         fV74yx01eM4TSaZnPMulnx7yNggtw1i3JK1900JGb22/XeK5ABXqq/f58QCDH5b/kLg6
         cLEl/LVEF8Ket6XAEEmchX8Sy+huZ2oPxcx8ArMT2wqTD788Zf8G4JBw2Ebote9HBMK6
         /zIQ==
X-Gm-Message-State: APjAAAW8xse2QAhrylh5vhSZmAOZhY6VRmdOpZMqVxzYZOvnsJXY6kjD
        rzXiuowKTxGbfuVnUdZnTueAVqcN
X-Google-Smtp-Source: APXvYqwRxEoMvq2unok+vO+O1bw+EShUC2jRpn8ZDaewKJGXRjgcpB/+/nZ/WrRJyziDrq9s1COcYg==
X-Received: by 2002:a5d:43c7:: with SMTP id v7mr3128994wrr.32.1575984454917;
        Tue, 10 Dec 2019 05:27:34 -0800 (PST)
Received: from localhost (pD9E518ED.dip0.t-ipconnect.de. [217.229.24.237])
        by smtp.gmail.com with ESMTPSA id n67sm3263420wmb.8.2019.12.10.05.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 05:27:33 -0800 (PST)
Date:   Tue, 10 Dec 2019 14:27:32 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        David Airlie <airlied@linux.ie>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH 3.16 10/72] video: of: display_timing: Add of_node_put()
 in of_get_display_timing()
Message-ID: <20191210132732.GG2703785@ulmo>
References: <lsq.1575813164.154362148@decadent.org.uk>
 <lsq.1575813165.830287385@decadent.org.uk>
 <CAD=FV=XpyONBT_XcKLRj2qkcJHkVntoHJJs=tYbVjzF9V10ziQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yQbNiKLmgenwUfTN"
Content-Disposition: inline
In-Reply-To: <CAD=FV=XpyONBT_XcKLRj2qkcJHkVntoHJJs=tYbVjzF9V10ziQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yQbNiKLmgenwUfTN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 09, 2019 at 01:19:01PM -0800, Doug Anderson wrote:
> Hi,
>=20
> On Sun, Dec 8, 2019 at 5:54 AM Ben Hutchings <ben@decadent.org.uk> wrote:
> >
> > 3.16.79-rc1 review patch.  If anyone has any objections, please let me =
know.
> >
> > ------------------
> >
> > From: Douglas Anderson <dianders@chromium.org>
> >
> > commit 4faba50edbcc1df467f8f308893edc3fdd95536e upstream.
> >
> > =3D46romcode inspection it can be seen that of_get_display_timing() is
> > lacking an of_node_put().  Add it.
>=20
> I don't object, but I am curious why "From code" got turned into
> "=3D46romcode" in the commit message.

I vaguely recall earlier versions of patchwork doing something similar.
This has to do with lines starting with "From" needing special treatment
in some situations. I'm not exactly sure about the details, but I think
this is only needed for the mailbox format, so whatever happened here
was probably a bit over the top.

Thierry

--yQbNiKLmgenwUfTN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl3vnUQACgkQ3SOs138+
s6GaPQ//ejE0NFKoXNYIBQfPjbNzLb+rJiSX4+8oNLEa95FqIT78NZDM/R/1M28L
Th87fYaLVUifVInN2IJEYwnSTeeWYITOJCeBwr3D+oxFVbvqFy5Rj9aVwz28midp
y8lmA/0XFNZx+7C17v+AGCH+EfjDLAT0gB6MIOo+cASPjPPRuQc0QxOlLw61nRyt
EFiYyHRv+FH1o9FdQEGGPvCzCCv3k87RnC/TkrBJeK7PZdXjjBWi3j8Y2zC+5PyW
EKXhZ0EH9fFPIYoC3qLOt5LoOQDVNueUDxE44suXHd0H7UGq+VSmloHmrYova9p/
yKv92hRwlSV5mrCXEfR/0Mu/WBLkM6ATaE19W2Wc6sy9qnkIcutiWjspxa+bjR+d
Pnc8nwzh4Bt1ro1yfxav9k2y8BOBNAYGwAAgGCWjwGJGX9J/cnoYEBYhzvfbQ39/
mFSufPKySzVlzjabqj4iZmKR8AN2NsnaQWquJA1mKggumu/UYdkgUZUDZdrUZo0s
KH3UK/uUtwgfXQFMXizr+zODEoLz3vyzJZ2UWFZ4c0ejuVp6+qnkFLcoiwcZ2cnR
JpBcelvUAKjmInYQNuL7AVQSotb3aPfgOCzw88UIGBEFkrNUTvdfAK3LcE7O7/b3
AfnnxRPMEayJgZIkXHZBpvQZojVWulY2me8Ars/Uc1Z6F+vHhRs=
=OSWD
-----END PGP SIGNATURE-----

--yQbNiKLmgenwUfTN--
