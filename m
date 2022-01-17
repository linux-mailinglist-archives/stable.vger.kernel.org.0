Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C70F490FF5
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241548AbiAQRzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238173AbiAQRzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:55:07 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F5CC061574
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 09:55:07 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id br17so60612791lfb.6
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 09:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=embecosm.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=cwLRKEGEpMI2ZE1H9bFkR9wzYdchQAM25oYHbDE2xJI=;
        b=Z4uRl0MVRiirvaT9sJ1t9OkkLO3CHmIQ751lzUNYhxDx7ws/GTs5S/AZd0bN+BySCm
         sHCN8MzJVc8iI5k2e2+EddfoXccN1yMRUhCYH59ncx2PDXEWyEYIHw+7c2dOaj0qNB3P
         GOj+hBBdhVtdki2iaCxAQ+yuKM7iyJ4yL1e19IJTJLE6UIYY9IfWSeEQbC8wP940wkRV
         zJBewdJ/7Kp02fYC4DiiOs+CnfRpwISGGu/+fTGOfjvcr3GEqSzuGwNcPom8k5eLLGOq
         QZDfb/qb0XZdvcmEOqt8kU8GGJS4rkbc582DstuDCda8nODZj2cl7/hQ+U1LpgsR5bvi
         8eDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=cwLRKEGEpMI2ZE1H9bFkR9wzYdchQAM25oYHbDE2xJI=;
        b=uHoWdd4jVBpu4f22yvFNsEIvQpQ6utTicZbdr9SzMhrH6k01YfJZp+xHd0L99aF7FU
         Vl5CMon0eu/EUkXkwnbwUAwmqVa9AurNWFb9lDTLqi3rSZ1MqPWi3yoVuOHxMKMIDuRw
         8PpTmM66T8HxB7Zj7jNId1EZM4k86SG96xrpjwliNZiAeYdCfmqNfHkUlrGdKxHkXqtY
         t/UgOD2B60yvU95Vg3OxXvp1ely/7oEZVdcBDT18zTwB8vPz3SG9CDBWP2izuOTUQgPd
         GigQ15K3fDj5yr3o/PQR+gmDelqtXySlzYIHgLYAjLiXYsgKRiFJnpHg4dfWoueDKg+p
         8DGg==
X-Gm-Message-State: AOAM533P2o82hnnUa8GB476KelXUz2AXvcHX5vGUQWaavPOQa711fzbZ
        tBIeU/SO6/8oYP42vOFdTUM47A==
X-Google-Smtp-Source: ABdhPJy+LfZBkjXYa1Q5BuuXNEb0Ca47QVTVnKosBFub+2myWJLAzkrYXRRQbzGGN969EE+Zx/4Cgw==
X-Received: by 2002:a05:6512:308c:: with SMTP id z12mr12242340lfd.35.1642442105820;
        Mon, 17 Jan 2022 09:55:05 -0800 (PST)
Received: from [192.168.219.3] ([78.8.192.131])
        by smtp.gmail.com with ESMTPSA id i6sm756372lfb.76.2022.01.17.09.55.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jan 2022 09:55:05 -0800 (PST)
Date:   Mon, 17 Jan 2022 17:55:02 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@embecosm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Jiri Slaby <jirislaby@kernel.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tty: Revert the removal of the Cyclades public API
In-Reply-To: <YeKDD6imTh1Y6GuN@kroah.com>
Message-ID: <alpine.DEB.2.20.2201151231020.11348@tpp.orcam.me.uk>
References: <alpine.DEB.2.20.2201141832330.11348@tpp.orcam.me.uk> <YeKDD6imTh1Y6GuN@kroah.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 15 Jan 2022, Greg Kroah-Hartman wrote:

> On Fri, Jan 14, 2022 at 08:54:05PM +0000, Maciej W. Rozycki wrote:
> > Fix a user API regression introduced with commit f76edd8f7ce0 ("tty: 
> > cyclades, remove this orphan"), which removed a part of the API and 
> > caused compilation errors for user programs using said part, such as 
> > GCC 9 in its libsanitizer component[1]:
> > 
> > .../libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc:160:10: fatal error: linux/cyclades.h: No such file or directory
> >   160 | #include <linux/cyclades.h>
> >       |          ^~~~~~~~~~~~~~~~~~
> > compilation terminated.
> > make[4]: *** [Makefile:664: sanitizer_platform_limits_posix.lo] Error 1
> 
> So all we need is an empty header file?  Why bring back all of the
> unused structures?

 Because they have become a part of the published API.  Someone may even 
use a system using headers from the most recent version of the Linux 
kernel (though not necessarily running such a kernel) to build software 
intended to run on an older version that still does implement the API.  
Times where people individually built pefectly matching software from 
sources to run on each system they looked after have largely long gone.

> > Any part of the public API is a contract between the kernel and the 
> > userland and therefore once there it must not be removed even if its 
> > implementation side has gone and any relevant calls will now fail 
> > unconditionally.
> 
> Does this code actually use any of these structures?

 Well, they have been exported, so they have become a part of the API.  
This user program may not use them, another one will.  If you don't want 
an API to become public, then do not export it in the first place.

> > Revert the part of the commit referred then that affects the user API, 
> > bringing the most recent version of <linux/cyclades.h> back verbatim 
> > modulo the removal of trailing whitespace which used to be there, and 
> > updating <linux/major.h> accordingly.
> 
> Why major.h?  What uses that?  No userspace code should care about that.

 So it shouldn't have been a part of the user API in the first place.  
Given that it has become a part of it it has to stay, that's the whole 
point of having a user API.

> Also, your text here is full of trailing whitespace, so I couldn't take
> this commit as-is anyway :(

 Well, `git' is supposed to sort it automatically.  I've been routinely 
feeding my patches as posted to `git am' for other projects so as to push 
them and any trailing whitespace (added automatically by my e-mail client, 
I guess for presentation purposes; not to be confused with `format=flowed' 
arrangement as indicated by `Content-Type:', which I know to avoid) does 
get stripped as the command executes, clearly prepared for this situation.

 The same must have happened for my earlier Linux kernel submissions ever 
since the switch to `git' back in 2005 as they have been correctly applied 
and no maintainer including you had an issue with it before.  And I have 
been using the same e-mail client doing the same all over these years.

 To double-check I have just fed my submission as it to `git am' and it 
did strip all the unwanted trailing whitespace.  Does that not happen with 
your setup now?  Odd.

 Or did you get confused with the formatting issues the header itself used 
to have that I did not address as preexisting code?  If so, then I could 
reformat the body of the change, however due to the original defects it 
wouldn't be a trivial revert anymore (arguably in that case there ought to 
be two changes in a series then, first a genuine revert, followed by the 
style fix).  Let me know if that is what you desire and I'll adapt v2 
accordingly.

 Thank you for your review.

  Maciej
