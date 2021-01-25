Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC2330280C
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 17:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbhAYQji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 11:39:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730704AbhAYQiA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 11:38:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 597CD22510;
        Mon, 25 Jan 2021 16:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611592639;
        bh=FQyJWruesbqdwh9dBTiLkl74hA/Bt9R0fvtHh18RkeI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kkrFgc1lrYRXXBrNCpMkNdQQUoPtCQ8xVrjyvAC/85YJr1PM0nJjsR2eKnBzqEf/q
         V/8e5wF5RnNv6JvaidVfLvSdielGPYcRpnE5QSuWw8KQLsjEiFGB/IgQCZ6fe4uEBL
         0D/NZgF5VoatbMlLcZRLwt3Gn+gqZmi86vhKTjn4=
Date:   Mon, 25 Jan 2021 17:37:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        LinusW <linus.walleij@linaro.org>,
        Maulik Shah <mkshah@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        "# 4.0+" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] pinctrl: qcom: Properly clear
 "intr_ack_high" interrupts when" failed to apply to 5.4-stable tree
Message-ID: <YA7zvfywG1oh1T7e@kroah.com>
References: <1611585675228156@kroah.com>
 <CAD=FV=UmMuiR=NV_fs7w-JGAdBy+NL1GinLw3=on0rMNNKeDqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=UmMuiR=NV_fs7w-JGAdBy+NL1GinLw3=on0rMNNKeDqQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 08:26:55AM -0800, Doug Anderson wrote:
> Hi,
> 
> On Mon, Jan 25, 2021 at 6:41 AM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> > thanks,
> >
> > greg k-h
> >
> > ------------------ original commit in Linus's tree ------------------
> >
> > From a95881d6aa2c000e3649f27a1a7329cf356e6bb3 Mon Sep 17 00:00:00 2001
> > From: Douglas Anderson <dianders@chromium.org>
> > Date: Thu, 14 Jan 2021 19:16:23 -0800
> > Subject: [PATCH] pinctrl: qcom: Properly clear "intr_ack_high" interrupts when
> >  unmasking
> 
> I think for 5.4 the most expedient thing is to take these two:
> 
> a95881d6aa2c pinctrl: qcom: Properly clear "intr_ack_high" interrupts
> when unmasking
> 4079d35fa4fc pinctrl: qcom: No need to read-modify-write the interrupt status
> 
> Then it should apply cleanly and you'll get this one fix.
> 
> After fixing, you might hit the next failure when trying to apply
> ("pinctrl: qcom: Don't clear pending interrupts when enabling").  That
> one might be slightly harder to backport since it interacts with the
> PDC patches.  Presumably anyone running a real system on 5.4 also has
> the PDC patches backported so they can get wakeup, but getting all the
> PDC support in 5.4 stable would probably be too much of a "feature"
> for linux-stable?  In any case, my default answer for that I'd be
> happy to help review a backport if someone saw a benefit but I won't
> attempt it myself.

Ok, I'll just not worry about these for 5.4.y for now, thanks!

greg k-h
