Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8FBF45471
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 08:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfFNGA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 02:00:29 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:43215 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbfFNGA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 02:00:29 -0400
Received: by mail-vk1-f194.google.com with SMTP id m193so283195vke.10
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 23:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UC1HXVtHWwclbVW+VJ6ygUlrADUHyNEIUiNQBaSaxIo=;
        b=U08AIEUzbxFVpWR3vAbyxMsG68c7bJ5TQxY0alk8CJ/iD1DIGZJzG1eaFQNxkCuySP
         ZRuTKnsrLKZmXm0zINg25TtHHMrabeWdhEd/MzHt2m86RRhiqNHOkq0C7ClupSbecm0A
         Eh3cFjKB6Z092TjLUgALKqLub9MY86AMyC0WVNNBfWEHJQ6YWJNRJY1F6Y68s0BTls5g
         aWADg8nHU93JWkaM/BDkFYl6z/hQlzHgS/YRcRUmvtVdOFODSMeHMhbZm1EtJJw+LeJF
         KazDShkTizmeTXCU6EJE4aMj8EYwEjh5F5l/SnemrZT2OZahNy1jpmj3nj6DOnRIBJA+
         5iuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UC1HXVtHWwclbVW+VJ6ygUlrADUHyNEIUiNQBaSaxIo=;
        b=OBhIndYUPu1NiNyzOR0zUKnw9lTzCmo7BFz+ZZ3bVzHc5u1mS1D0djDRdvUsUxaQQX
         TmY9oMzPNOfYf4czyAd7jApHO7KMWwLOr73p2eIWs5JqTP5tfcbWg/CbG2erS7u5xUxD
         OtzlWVCV2buVkS1bFmU8EHfJRk7I6h5py/p3mTFpw6FzfHDKzRcSgeX9b+MZpCYQc22F
         RPVEs/M+I1xMDKNi48Nv3ITHCVfJO4pAgU0SHbyH42xw0vdSgeDTJO4Z8/DJPiAlW0iw
         uSs/5O6T4HUMasaWt94pVKXCIUeIuoYE/cnk/7lOCmsVu2Rq0DuH8+3X03rDwRGVnpXV
         JB0w==
X-Gm-Message-State: APjAAAU42hQNG1DuPkHqD9lUM7ftkl/YsUmFe3a7MA2IdllHHZDm1Aof
        6vnoGZrTS8cX6dKePWys/C/9gZjD5P6MVoSMZYgyOQ==
X-Google-Smtp-Source: APXvYqyt9DXfPlBOi7yhAdm1e85MTURnFc+MH8ax24HmQjSF1Nb3PK8jG/w28sVQv1HJHaIkACIu21piNJwdZKAJcHk=
X-Received: by 2002:a1f:ccc4:: with SMTP id c187mr37320635vkg.56.1560492027624;
 Thu, 13 Jun 2019 23:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190603100938.5414-1-jian-hong@endlessm.com> <20190610060141.5377-1-jian-hong@endlessm.com>
 <20190613075256.GF19685@kroah.com> <CAPpJ_ecg1ERjrSYoB_Abuf2oy_Nay4sr3Bpb15OXRFbrXUW=6Q@mail.gmail.com>
 <20190613100547.GW5942@intel.com>
In-Reply-To: <20190613100547.GW5942@intel.com>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Fri, 14 Jun 2019 13:59:51 +0800
Message-ID: <CAPpJ_edxMP=uXCJxogsrKGMWmUy5G0u870_G9r-P7-i_0v9eWQ@mail.gmail.com>
Subject: Re: [PATCH stable-5.1 0/3] drm/i915: Prevent screen from flickering
 when the CDCLK changes
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     Abhay Kumar <abhay.kumar@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Clint Taylor <Clinton.A.Taylor@intel.com>,
        stable@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>,
        Hui Wang <hui.wang@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com> =E6=96=BC 2019=E5=
=B9=B46=E6=9C=8813=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=886:05=E5=AF=
=AB=E9=81=93=EF=BC=9A
>
> On Thu, Jun 13, 2019 at 04:37:48PM +0800, Jian-Hong Pan wrote:
> > Greg KH <gregkh@linuxfoundation.org> =E6=96=BC 2019=E5=B9=B46=E6=9C=881=
3=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=883:52=E5=AF=AB=E9=81=93=EF=
=BC=9A
> > >
> > > On Mon, Jun 10, 2019 at 02:01:39PM +0800, Jian-Hong Pan wrote:
> > > > Hi,
> > > >
> > > > After apply the commit "drm/i915: Force 2*96 MHz cdclk on glk/cnl w=
hen audio
> > > > power is enabled", it induces the screen to flicker when the CDCLK =
changes on
> > > > the laptop like ASUS E406MA. [1]
> > > >
> > > > So, we need these commits to prevent that:
> > > > commit 48d9f87ddd21 drm/i915: Save the old CDCLK atomic state
> > > > commit 2b21dfbeee72 drm/i915: Remove redundant store of logical CDC=
LK state
> > > > commit 59f9e9cab3a1 drm/i915: Skip modeset for cdclk changes if pos=
sible
> > > >
> > > > [1]: https://bugzilla.kernel.org/show_bug.cgi?id=3D203623#c12
> > > >
> > > > Jian-Hong Pan
> > > >
> > > > Imre Deak (2):
> > > >   drm/i915: Save the old CDCLK atomic state
> > > >   drm/i915: Remove redundant store of logical CDCLK state
> > > >
> > > > Ville Syrj=C3=A4l=C3=A4 (1):
> > > >   drm/i915: Skip modeset for cdclk changes if possible
> > > >
> > > >  drivers/gpu/drm/i915/i915_drv.h      |   3 +-
> > > >  drivers/gpu/drm/i915/intel_cdclk.c   | 155 ++++++++++++++++++++++-=
----
> > > >  drivers/gpu/drm/i915/intel_display.c |  48 +++++++--
> > > >  drivers/gpu/drm/i915/intel_drv.h     |  18 +++-
> > > >  4 files changed, 186 insertions(+), 38 deletions(-)
> > >
> > > These are all big patches, I would like to get an ack from the i915
> > > developer(s) that these are acceptable for the stable tree before
> > > applying them...
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Hi Intel friends,
> >
> > We have laptops like ASUS E406MA, which hits the issue: The audio
> > playback does not work anymore after suspend & resume [1]
> > Thanks for your contribution.  We found the commit "drm/i915: Force
> > 2*96 MHz cdclk on glk/cnl when audio power is enabled" can fix it.
> > But, it induces the screen to flicker when the CDCLK changes on.  So,
> > we need these commits to be back ported to Linux stable 5.1.x tree to
> > prevent flickering:
>
> Pardon the delay.
>
> Now that I refreshed my memory a bit I can't really see how
> this could fix anything, except by luck. Before these patches
> we always forced cdclk to be >=3D2*96 MHz so audio should never
> have hit this particular problem.
>
> The reason for adding this extra complexity was to claw back
> a few milliwatts of power by allowing cdclk to drop below that
> magic limit when audio isn't needed.
>
> I *think* these patches should probably work in 5.1, but for
> now I don't see this as anything more than bandaid for an
> unknown issue somewhere else. So I'd rather like a new bug
> filed at https://bugs.freedesktop.org/enter_bug.cgi?product=3DDRI&compone=
nt=3DDRM/Intel
> with a full dmesg with drm.debug=3D0xe (+ some audio debug
> knob(s) which show when it's trying to poke the hw during
> suspend/resume) attached.

Thanks for your attention!
I have filed the bug on freedesktop's bugzilla.
https://bugs.freedesktop.org/show_bug.cgi?id=3D110916

I can upload more log information with guidance.

Jian-Hong Pan

> >
> > 59f9e9cab3a1 drm/i915: Skip modeset for cdclk changes if possible
> > 2b21dfbeee72 drm/i915: Remove redundant store of logical CDCLK state
> > 48d9f87ddd21 drm/i915: Save the old CDCLK atomic state
> > 905801fe7237 drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio
> > power is enabled
> >
> > [1] https://bugzilla.kernel.org/show_bug.cgi?id=3D203623
> >
> > May we have your comment or ack for the back port patches?
> > https://www.spinics.net/lists/stable/msg308491.html
> > https://www.spinics.net/lists/stable/msg310121.html
> > https://www.spinics.net/lists/stable/msg310122.html
> > https://www.spinics.net/lists/stable/msg310124.html
> > https://www.spinics.net/lists/stable/msg310125.html
> >
> > Thank you,
> > Jian-Hong Pan
>
> --
> Ville Syrj=C3=A4l=C3=A4
> Intel
