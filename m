Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B86F40B5DD
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 19:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhINR0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 13:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhINR0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 13:26:08 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EEAC061762
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 10:24:50 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id z1so18159835ioh.7
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 10:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MGxIKUsb5FP4AsXfc/89dNxHXi2H4NcJUiI1QiagwdY=;
        b=iyrYbI4T8mMOxoTpHdf24U1Ihc4jeVugugDcbUpPPi9+BFYdHzvFYERq2kK2RmDalM
         MVgPdl/vsIs1fpZefdUxu6zAyDFPelsDP9l9Lx/UPNh4U6CWpdEBJMUpbOARU4dpRmTA
         7gl1EFRKcfg0JEn8EhoGza9JVjPp6mOSKYCG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MGxIKUsb5FP4AsXfc/89dNxHXi2H4NcJUiI1QiagwdY=;
        b=rmtNBujDZmVBPbxervDc0HYpbgNjeTl3rS1WYnQw0NGI27JNvOaXX5sgve9jG/RTrv
         XLceWB7+e51YqJRVrLEms/yrzj3jrgHSqvUQUCHE3K0bwbw3QRFt8tNkPcr7pVJhKQeN
         LGalAK5FxVwQnCk5FCKCjL6s7lmF/QJGQvyPFgXUhX4sIQ7+nyv73WY3yXCZGy9xRFDv
         1t0OnRgWFRPDQvQNAeeG4XjyEOdiTOHOXvmMeeExz6ZCunTvtBMprUXlpI54P0iaUiH4
         YppyiLDtPuRbZnEAYdkLeibs5vSNzhAqj+DM4uCi/Flpm6drhlnS2GDmMnkt0JIYHsah
         Qo8Q==
X-Gm-Message-State: AOAM530Jq4Jkam6aKar21212LtOBFPbBcyANrDACYDDY3Gc8N7tZ3Few
        J1zMwuQvWUWNeYTi3kX/nlnkRxr+rX2+pw==
X-Google-Smtp-Source: ABdhPJzos9KXml3ZIJz/qnlyTC+5BUEoDWvEM9MG8T0Qd2DuWA0AYWvQgJzRbQaXsIixSzMopP9A4g==
X-Received: by 2002:a6b:d617:: with SMTP id w23mr11975255ioa.89.1631640289809;
        Tue, 14 Sep 2021 10:24:49 -0700 (PDT)
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com. [209.85.166.49])
        by smtp.gmail.com with ESMTPSA id a20sm7448332ilt.8.2021.09.14.10.24.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 10:24:49 -0700 (PDT)
Received: by mail-io1-f49.google.com with SMTP id z1so18159741ioh.7
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 10:24:48 -0700 (PDT)
X-Received: by 2002:a02:711e:: with SMTP id n30mr15666865jac.3.1631640288500;
 Tue, 14 Sep 2021 10:24:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131118.330293390@linuxfoundation.org>
 <CAD=FV=UhovUSmvbpc3q9=J_NSU0mcvQ3Fv8r4hi1ZNO=cMteuA@mail.gmail.com>
 <YT93qkd8B7jy6AzV@kroah.com> <CAD=FV=WPkVGTUmx2+Egt+ryO02n4cNGjN3S8gkBJP-WW3jPLWw@mail.gmail.com>
 <YUDNXAVHfsrM7sR6@kroah.com>
In-Reply-To: <YUDNXAVHfsrM7sR6@kroah.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 14 Sep 2021 10:24:35 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XA4CVUp0DGs55PGdMirusits8SSmeZG=DoLzu1Km_-xw@mail.gmail.com>
Message-ID: <CAD=FV=XA4CVUp0DGs55PGdMirusits8SSmeZG=DoLzu1Km_-xw@mail.gmail.com>
Subject: Re: [PATCH 5.14 147/334] drm/bridge: ti-sn65dsi86: Dont read EDID
 blob over DDC
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Sep 14, 2021 at 9:27 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Sep 13, 2021 at 09:31:03AM -0700, Doug Anderson wrote:
> > Hi,
> >
> > On Mon, Sep 13, 2021 at 9:09 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Sep 13, 2021 at 06:57:20AM -0700, Doug Anderson wrote:
> > > > Hi,
> > > >
> > > > On Mon, Sep 13, 2021 at 6:51 AM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > From: Douglas Anderson <dianders@chromium.org>
> > > > >
> > > > > [ Upstream commit a70e558c151043ce46a5e5999f4310e0b3551f57 ]
> > > > >
> > > > > This is really just a revert of commit 58074b08c04a ("drm/bridge:
> > > > > ti-sn65dsi86: Read EDID blob over DDC"), resolving conflicts.
> > > > >
> > > > > The old code failed to read the EDID properly in a very important
> > > > > case: before the bridge's pre_enable() was called. The way things need
> > > > > to work:
> > > > > 1. Read the EDID.
> > > > > 2. Based on the EDID, decide on video settings and pixel clock.
> > > > > 3. Enable the bridge w/ the desired settings.
> > > > >
> > > > > The way things were working:
> > > > > 1. Try to read the EDID but fail; fall back to hardcoded values.
> > > > > 2. Based on hardcoded values, decide on video settings and pixel clock.
> > > > > 3. Enable the bridge w/ the desired settings.
> > > > > 4. Try again to read the EDID, it works now!
> > > > > 5. Realize that the hardcoded settings weren't quite right.
> > > > > 6. Disable / reenable the bridge w/ the right settings.
> > > > >
> > > > > The reasons for the failures were twofold:
> > > > > a) Since we never ran the bridge chip's pre-enable then we never set
> > > > >    the bit to ignore HPD. This meant the bridge chip didn't even _try_
> > > > >    to go out on the bus and communicate with the panel.
> > > > > b) Even if we fixed things to ignore HPD, the EDID still wouldn't read
> > > > >    if the panel wasn't on.
> > > > >
> > > > > Instead of reverting the code, we could fix it to set the HPD bit and
> > > > > also power on the panel. However, it also works nicely to just let the
> > > > > panel code read the EDID. Now that we've split the driver up we can
> > > > > expose the DDC AUX channel bus to the panel node. The panel can take
> > > > > charge of reading the EDID.
> > > > >
> > > > > NOTE: in order for things to work, anyone that needs to read the EDID
> > > > > will need to instantiate their panel using the new DP AUX bus (AKA by
> > > > > listing their panel under the "aux-bus" node of the bridge chip in the
> > > > > device tree).
> > > > >
> > > > > In the future if we want to use the bridge chip to provide a full
> > > > > external DP port (which won't have a panel) then we will have to
> > > > > conditinally add EDID reading back in.
> > > > >
> > > > > Suggested-by: Andrzej Hajda <a.hajda@samsung.com>
> > > > > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > > > > Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > > > > Link: https://patchwork.freedesktop.org/patch/msgid/20210611101711.v10.9.I9330684c25f65bb318eff57f0616500f83eac3cc@changeid
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > > ---
> > > > >  drivers/gpu/drm/bridge/ti-sn65dsi86.c | 22 ----------------------
> > > > >  1 file changed, 22 deletions(-)
> > > >
> > > > I guess it's not a huge deal, but I did respond to Sasha and request
> > > > that this patch be dropped from the stable queue unless the whole big
> > > > pile of patches was being backported. See:
> > > >
> > > > https://lore.kernel.org/lkml/CAD=FV=U2dGjeEzp+K1vnLTj8oPJ-GKBTTKz2XQ1OZ7QF_sTHuw@mail.gmail.com/
> > > >
> > > > I said:
> > > >
> > > > > I would suggest against backporting this one unless you're going to
> > > > > backport the whole pile of DP AUX bus patches, which probably doesn't
> > > > > make sense for stable. Even though the old EDID reading was broken for
> > > > > the first read, it still worked for later reads. ...and the first read
> > > > . didn't crash or anything--it just timed out.
> > >
> > > I see a "bunch" of patches for this driver in this -rc, did Sasha not
> > > get them all?  If not, I can drop this one, but maybe it was needed for
> > > the follow-on patches?
> >
> > It's been a long journey trying to make this bridge work better. I
> > think the easiest way to say it is that if you don't have the parent
> > of ${SUBJECT} patch, AKA:
> >
> > e0bbcc6233f7 drm/bridge: ti-sn65dsi86: Add support for the DP AUX bus
> >
> > ...then you don't have DP AUX bus support and you shouldn't take
> > ${SUBJECT} patch. If you have that patch and it compiles / builds then
> > it means that you have all the proper dependencies. However, there are
> > _a lot_ of dependencies and I wouldn't suggest picking them all to
> > stable unless it's critical for someone.
>
> I tried to drop this one, and it turned out to be a depandancy for
> another patch for this driver.  And that was another dependancy.  So
> I've now dropped all of these from the queue.

Ugh. :(


> Here are the commits I dropped.  If you think any should be added back,
> please let us know:
>
> 05a7f4a8dff1 ("devlink: Break parameter notification sequence to be before/after unload/load driver")

I don't understand what the "devlink" patch had to do with
ti-sn65dsi86. I'll assume you didn't intend to have it in your list.


> e183bf31cf0d ("drm/bridge: ti-sn65dsi86: Add some 100 us delays")
> c7782443a889 ("drm/bridge: ti-sn65dsi86: Avoid creating multiple connectors")
> a70e558c1510 ("drm/bridge: ti-sn65dsi86: Don't read EDID blob over DDC")
> acb06210b096 ("drm/bridge: ti-sn65dsi86: Fix power off sequence")
> 4c1b3d94bf63 ("drm/bridge: ti-sn65dsi86: Improve probe errors with dev_err_probe()")
> 4e5763f03e10 ("drm/bridge: ti-sn65dsi86: Wrap panel with panel-bridge")

I'd say it's OK to drop these. If someone demonstrates a need for them
on stable channel then I can help with backporting, but otherwise I
can't see that it's worth it. Basically:

1. I think ${SUBJECT} patch without full DP AUX support for people
could cause a real regression if anyone is using this bridge chip on
5.14 stable.

2. I think picking back full DP AUX support is too heavy for a
stable-channel backport without a demonstrated need.

3. Of the above patches, only one fixes a problem that was observed on
real hardware ("Fix power off sequence"). That was only seen on a
panel that _requires_ the full DP AUX support in order to work. Other
ones are fixes based on code inspection, cleanups, or fixes for other
patches in the series there.

-Doug
