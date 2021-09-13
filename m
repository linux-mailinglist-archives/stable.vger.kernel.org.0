Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15261409946
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 18:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238159AbhIMQc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 12:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237860AbhIMQcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 12:32:35 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6AEC061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 09:31:19 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id m4so5720813ilj.9
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 09:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cK1O5oYXE9Yq4IhVSTEvLpil344BX7052XXq/p9EKhQ=;
        b=KZ683FMGsKYX7nh+Na0v8TkT/llXwB1yUAfWPknsPkGyF9QN67K0tfPiydRe0s9Xyz
         BgADpGRoNOoNJ4/TPLc2brWfCTjGjvzSEVrRwqt8QXxDdxsbs//WHVR3zdRWmMfoL4Pl
         251Q0jd5wwIhrNPf4iaCGwICOZ1qwVRL2W5yE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cK1O5oYXE9Yq4IhVSTEvLpil344BX7052XXq/p9EKhQ=;
        b=i8zojzp7V4psJMy7Urg9iG6I/WMbKZTXGK3GkWdPYwvrD26/JLBjcyhBmEc89gmC6n
         xd/81llo4qXYAYhMYFHfRjjToqRzMekadw0ul89BKQ7L9SEUOpTD9ofxp7SixTcRPD1L
         uPJjJtYDLXff5zlFxefhLP52STGT207C+qMf9xuIOUCznPjH6egWMlKvmnKgIbMC+7Gv
         YJGTt1cX0zBji4AUVrDDPBqsdPV6Q/xkf9SUgv9Pi2rkXhPg6Q94gfHkiqjq11W1S8ED
         cvR/X0oosu5a/V7s2BtKe3Gt/JpvSDKDIH4YvrEVE+1tLilNnP2upP86QnonUxW+egsU
         oVXw==
X-Gm-Message-State: AOAM533+/c3s4b5o07gxy4U9s6azNXCE3p5cltD84j3XpQVlXOPdvZGl
        E/KZSwXURRNcU97i7ovgBVDj0P4TKIcHUg==
X-Google-Smtp-Source: ABdhPJxBVvLYqPAtVK/tOt5DSGKU9DaaIOalRs+8MEYqjNyc/efCFCTe9qIgu0wzQ1gf3xKVwS4Txw==
X-Received: by 2002:a92:d102:: with SMTP id a2mr8677892ilb.162.1631550678692;
        Mon, 13 Sep 2021 09:31:18 -0700 (PDT)
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com. [209.85.166.54])
        by smtp.gmail.com with ESMTPSA id i17sm4920750ioh.21.2021.09.13.09.31.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 09:31:18 -0700 (PDT)
Received: by mail-io1-f54.google.com with SMTP id n128so2306250iod.5
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 09:31:18 -0700 (PDT)
X-Received: by 2002:a05:6602:1346:: with SMTP id i6mr9759468iov.128.1631550677870;
 Mon, 13 Sep 2021 09:31:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131118.330293390@linuxfoundation.org>
 <CAD=FV=UhovUSmvbpc3q9=J_NSU0mcvQ3Fv8r4hi1ZNO=cMteuA@mail.gmail.com> <YT93qkd8B7jy6AzV@kroah.com>
In-Reply-To: <YT93qkd8B7jy6AzV@kroah.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 13 Sep 2021 09:31:03 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WPkVGTUmx2+Egt+ryO02n4cNGjN3S8gkBJP-WW3jPLWw@mail.gmail.com>
Message-ID: <CAD=FV=WPkVGTUmx2+Egt+ryO02n4cNGjN3S8gkBJP-WW3jPLWw@mail.gmail.com>
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

On Mon, Sep 13, 2021 at 9:09 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Sep 13, 2021 at 06:57:20AM -0700, Doug Anderson wrote:
> > Hi,
> >
> > On Mon, Sep 13, 2021 at 6:51 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Douglas Anderson <dianders@chromium.org>
> > >
> > > [ Upstream commit a70e558c151043ce46a5e5999f4310e0b3551f57 ]
> > >
> > > This is really just a revert of commit 58074b08c04a ("drm/bridge:
> > > ti-sn65dsi86: Read EDID blob over DDC"), resolving conflicts.
> > >
> > > The old code failed to read the EDID properly in a very important
> > > case: before the bridge's pre_enable() was called. The way things need
> > > to work:
> > > 1. Read the EDID.
> > > 2. Based on the EDID, decide on video settings and pixel clock.
> > > 3. Enable the bridge w/ the desired settings.
> > >
> > > The way things were working:
> > > 1. Try to read the EDID but fail; fall back to hardcoded values.
> > > 2. Based on hardcoded values, decide on video settings and pixel clock.
> > > 3. Enable the bridge w/ the desired settings.
> > > 4. Try again to read the EDID, it works now!
> > > 5. Realize that the hardcoded settings weren't quite right.
> > > 6. Disable / reenable the bridge w/ the right settings.
> > >
> > > The reasons for the failures were twofold:
> > > a) Since we never ran the bridge chip's pre-enable then we never set
> > >    the bit to ignore HPD. This meant the bridge chip didn't even _try_
> > >    to go out on the bus and communicate with the panel.
> > > b) Even if we fixed things to ignore HPD, the EDID still wouldn't read
> > >    if the panel wasn't on.
> > >
> > > Instead of reverting the code, we could fix it to set the HPD bit and
> > > also power on the panel. However, it also works nicely to just let the
> > > panel code read the EDID. Now that we've split the driver up we can
> > > expose the DDC AUX channel bus to the panel node. The panel can take
> > > charge of reading the EDID.
> > >
> > > NOTE: in order for things to work, anyone that needs to read the EDID
> > > will need to instantiate their panel using the new DP AUX bus (AKA by
> > > listing their panel under the "aux-bus" node of the bridge chip in the
> > > device tree).
> > >
> > > In the future if we want to use the bridge chip to provide a full
> > > external DP port (which won't have a panel) then we will have to
> > > conditinally add EDID reading back in.
> > >
> > > Suggested-by: Andrzej Hajda <a.hajda@samsung.com>
> > > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > > Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > > Link: https://patchwork.freedesktop.org/patch/msgid/20210611101711.v10.9.I9330684c25f65bb318eff57f0616500f83eac3cc@changeid
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  drivers/gpu/drm/bridge/ti-sn65dsi86.c | 22 ----------------------
> > >  1 file changed, 22 deletions(-)
> >
> > I guess it's not a huge deal, but I did respond to Sasha and request
> > that this patch be dropped from the stable queue unless the whole big
> > pile of patches was being backported. See:
> >
> > https://lore.kernel.org/lkml/CAD=FV=U2dGjeEzp+K1vnLTj8oPJ-GKBTTKz2XQ1OZ7QF_sTHuw@mail.gmail.com/
> >
> > I said:
> >
> > > I would suggest against backporting this one unless you're going to
> > > backport the whole pile of DP AUX bus patches, which probably doesn't
> > > make sense for stable. Even though the old EDID reading was broken for
> > > the first read, it still worked for later reads. ...and the first read
> > . didn't crash or anything--it just timed out.
>
> I see a "bunch" of patches for this driver in this -rc, did Sasha not
> get them all?  If not, I can drop this one, but maybe it was needed for
> the follow-on patches?

It's been a long journey trying to make this bridge work better. I
think the easiest way to say it is that if you don't have the parent
of ${SUBJECT} patch, AKA:

e0bbcc6233f7 drm/bridge: ti-sn65dsi86: Add support for the DP AUX bus

...then you don't have DP AUX bus support and you shouldn't take
${SUBJECT} patch. If you have that patch and it compiles / builds then
it means that you have all the proper dependencies. However, there are
_a lot_ of dependencies and I wouldn't suggest picking them all to
stable unless it's critical for someone.

-Doug
