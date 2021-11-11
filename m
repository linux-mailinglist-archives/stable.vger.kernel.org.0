Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBDD44CE1F
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 01:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhKKALd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 19:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbhKKALc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 19:11:32 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046FAC061766;
        Wed, 10 Nov 2021 16:08:44 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id bu18so10063584lfb.0;
        Wed, 10 Nov 2021 16:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N3jFp8W9ilWqwkaIVy9aLsCmnV22fi+ycejIpcZrj/A=;
        b=MFbHsE61kHIPJrgy6iP8g26Yumhdl9WffyegPfGt9kKQrUQv2dnEPn8veMr5Fuv4E6
         pRiqBxkuBj2TIJKBcGsnMBY1k6CmsaYXTlEIfJNrYxsOf/3YCeU4SXSQYizJ3piCFPw1
         vmrNiAA2gSyRELnd9soFcDRDDNrruYmpR8EWs+fIyPctaSgbBH1Oacol6I4S4ECsnz5L
         1lVcbtqchB2XhDLCxFK9Cw5y73OednSZoRK9pCz3kXEjaylpSXuMYToPr9lcS8JMs/YZ
         caNMWwzaVSqMHCl0jpoUHCIpkZYMNT49UHfJqyNbnJ/O6BoC+JYSNhE6O2/xNWCYr4F7
         M6gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N3jFp8W9ilWqwkaIVy9aLsCmnV22fi+ycejIpcZrj/A=;
        b=h/aMdyeDOSIMLFam1qLkIoZ8kd19YW2IqUrZ8lDhicTnFA8OVcUQiAGN8tCH9ZDhX7
         Tl1edUoa7BSxWFV6iNZ8Qjf0+2/IvXepGHERNIHpqM8bI3mTBWm5ymQeV8MpP7OjHFvN
         f2/LjNym/pTm9WNzll70WEEmlw1VwjBKedcBwRfRXP9QvXUJZAIMBhvibNWUSDRZgjr9
         Ycz13pDCX9QRZOiiabnnGLEjIsc6blSoYbi+1AoAnns9mglGWeZfUUks3c4ZdH2gYnU5
         64ad2+/eAJ20pZ9t1EAh19oq1BX+HIed9sHF/Jk0edYzbsUwKlxjjMRxr0evAUAVI+PX
         rlfA==
X-Gm-Message-State: AOAM5310m4z2OjlAxqR/jOXi1jsuRdymEZ4i7n6Q1IJPIgsZeo5J5mHp
        aArSOVuSOwRHv0idDnRms5E=
X-Google-Smtp-Source: ABdhPJwtPsAGPak73Rl6zPNYuRAX2LxsvXjSsRkbHFPDykDgVuu9nD6I9RThx6uZNnqm7qodL29rJA==
X-Received: by 2002:a05:6512:10cb:: with SMTP id k11mr2952607lfg.534.1636589322404;
        Wed, 10 Nov 2021 16:08:42 -0800 (PST)
Received: from lahvuun (93-76-191-141.kha.volia.net. [93.76.191.141])
        by smtp.gmail.com with ESMTPSA id s9sm124597lfr.304.2021.11.10.16.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 16:08:42 -0800 (PST)
Date:   Thu, 11 Nov 2021 02:08:40 +0200
From:   Ilya Trukhanov <lahvuun@gmail.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>, regressions@lists.linux.dev,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <len.brown@intel.com>, pavel@ucw.cz
Subject: Re: [REGRESSION]: drivers/firmware: move x86 Generic System
 Framebuffers support
Message-ID: <20211111000840.kezb5gobtht5skk4@lahvuun>
References: <20211110200253.rfudkt3edbd3nsyj@lahvuun>
 <CAMj1kXHuU8dFBUeM41bHu13nd2qQVPJizt8Epw596K89_samiQ@mail.gmail.com>
 <20211110232157.xfeue3sbquyhtqmf@lahvuun>
 <CAMj1kXEY=Jp_mtLFGG2_7r97zZcan2bXpotfRdNeuLOsraoPWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEY=Jp_mtLFGG2_7r97zZcan2bXpotfRdNeuLOsraoPWg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 12:25:35AM +0100, Ard Biesheuvel wrote:
> On Thu, 11 Nov 2021 at 00:22, Ilya Trukhanov <lahvuun@gmail.com> wrote:
> >
> > On Wed, Nov 10, 2021 at 11:24:03PM +0100, Ard Biesheuvel wrote:
> > > Hi Ilya,
> > >
> > > On Wed, 10 Nov 2021 at 21:02, Ilya Trukhanov <lahvuun@gmail.com> wrote:
> > > >
> > > > Suspend-to-RAM with elogind under Wayland stopped working in 5.15.
> > > >
> > > > This occurs with 5.15, 5.15.1 and latest master at
> > > > 89d714ab6043bca7356b5c823f5335f5dce1f930. 5.14 and earlier releases work
> > > > fine.
> > > >
> > > > git bisect gives d391c58271072d0b0fad93c82018d495b2633448.
> > > >
> > > > To reproduce:
> > > > - Use elogind and Linux 5.15.1 with CONFIG_SYSFB_SIMPLEFB=n.
> > > > - Start a Wayland session. I tested sway and weston, neither worked.
> > > > - In a terminal emulator (I used alacritty) execute `loginctl suspend`.
> > > >
> > > > Normally after the last step the system would suspend, but it no longer
> > > > does so after I upgraded to Linux 5.15. After running `loginctl suspend`
> > > > in dmesg I get the following:
> > > > [  103.098782] elogind-daemon[2357]: Suspending system...
> > > > [  103.098794] PM: suspend entry (deep)
> > > > [  103.124621] Filesystems sync: 0.025 seconds
> > > >
> > > > But nothing happens afterwards.
> > > >
> > > > Suspend works as expected if I do any of the following:
> > > > - Revert d391c58271072d0b0fad93c82018d495b2633448.
> > > > - Build with CONFIG_SYSFB_SIMPLEFB=y.
> > >
> > > If this solves the issue, what else is there to discuss?
> > Sorry, I'm not a kernel developer, but I was under the impression
> > that this is a regression and should at least be brought to attention.
> >
> > I also think I'm probably not the last person to encounter this. I'm
> > fortunate because I had the time to bisect and get the idea to try
> > enabling that option, but others may not know how to fix it.
> >
> > The suspend not working is also not the only effect. After you execute
> > `loginctl suspend`, for example, the compositor just hangs if you try to
> > exit. Should you kill it with SysRq+I, the system suspends but after
> > resume doesn't respond to anything and has to be hard reset. I think
> > this is a pretty serious issue, even if it won't affect most users.
> >
> > Sorry if I wasn't meant to CC you. The issue reporting guide says that
> > you should CC maintainers of affected subsystems.
> 
> No worries. You cc'ed the right people, and we appreciate the time you
> have spent to track down the root cause.
> 
> So can you explain why the solution to this issue is not simply
> 'enable CONFIG_SYSFB_SIMPLEFB' ?

I'm not sure I understand what you're asking.

I can definitely enable CONFIG_SYSFB_SIMPLEFB and it would be *a*
solution, but only for me. In the future other people with setups
similar to mine will update to 5.15 or later and also face this issue.
They will then have to do everything I did (or at least search through
the mailing list) to get suspend working again. Is this desirable?

Besides, this option existed before (albeit under a different name), and
there was no need to enable it for suspend to work properly. The change
in question did not indicate that this option must now be enabled, it
wasn't even made `default y`. And even if it were, some people might
still have legitimate reasons to ignore the default and disable it, and
then have their suspend not work.
