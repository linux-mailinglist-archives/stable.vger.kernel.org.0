Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677971B5785
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 10:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgDWI5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 04:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgDWI5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 04:57:50 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08DEC03C1AF
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 01:57:49 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id y4so5390359ljn.7
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 01:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6fxS0sRpVzeKpCQ9DZnK+D9PrkbIMQB8wAa4rtLJMqE=;
        b=lXNwYcxSWOrjXhcUeHFZcVlJZq8SpERhMm4ytefHKx+nnKvdqFjIvzm+rBilHJXWp2
         Tk1wX3ZuyWvaqpyZoWhpekIvt/xq1e1DkUaybqHXx4pcAb0HFqgkwmEUeoKgSFieYXdd
         CbYbFpoQ7KtPXjKvVXFFXULBd7BJJzSTM6X5D+bY6SkcfGetjPkdlONG7JnsJs65yD9T
         EtQ2C2hfg7atxbRVbIHNxzx70P43AnMkYAHP9AxGE8DUmYsOz/q4auqeUSIT3mnIDuit
         268kEZdcWCAnLwkb2K7SjdmiC9fcGPCfgA9beulLNMRcIzwhIiWjMwvhpNRT7US4BrAR
         9gNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6fxS0sRpVzeKpCQ9DZnK+D9PrkbIMQB8wAa4rtLJMqE=;
        b=fE6/zwePKSRlns1qfcXf9C4z/Zeb4gu6ZfknjT65k4lQ4qPGacY5gdQ3udcMl4N0XB
         bO4LoBPOD1GROyI9M1iKEkPkxqiwQjUx+xUncNXp5CB+dPnfaWP7uKLCNX7Lt8y6o/pt
         PzrqmhL/xvxgWBZY+xONIyo12y18PSQzLWY2S799Zz32hR4tibuzhIm5RkdKxlyNTXb7
         d1p3DKwz3dt9ha57gZfWN65fYYn7n7meybUPogFN12QWwZakzShB7w716gPlsV+sUhKD
         p8S0mssZwW3zg0htZeLkDbK5XGnRg2O4cc3lDQRPVa/nq66pQLhw9vvNBsLDRfeb0Sjj
         Mj1g==
X-Gm-Message-State: AGi0PuapptDfugDbAr1tBUUm5Pz1RjTNEitzwVDv8A4eeHHiAlBQseE7
        fLuRbvuy1MEzTaXyCw3sRVDsQXUhrnkZMANiKbjyMw==
X-Google-Smtp-Source: APiQypKmaGX7+yfayz9GQsxXt/2GmavWcwMEmE24QGk3lpItVwd9FbGc+Svq9iOTM7V2svlBgsTeoDQXWWRvMdPBBao=
X-Received: by 2002:a2e:b8c1:: with SMTP id s1mr1880474ljp.0.1587632268278;
 Thu, 23 Apr 2020 01:57:48 -0700 (PDT)
MIME-Version: 1.0
References: <c304ad9c-f404-d22e-de74-9398da3ebfc3@hauke-m.de>
 <CAFA6WYN3FbqTivGJTfXtHsMjXNPXW+P4MZWiCL14utF2sHkeYg@mail.gmail.com> <885ae3bffad315445be3fc70cccade9067ee6937.camel@sipsolutions.net>
In-Reply-To: <885ae3bffad315445be3fc70cccade9067ee6937.camel@sipsolutions.net>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 23 Apr 2020 14:27:36 +0530
Message-ID: <CAFA6WYMYQAnW0vKm4fxNn+nA6dYXvqaungBEYDpd-wrzaavr8A@mail.gmail.com>
Subject: Re: Commit "mac80211: fix race in ieee80211_register_hw()" breaks
 mac80211 debugfs
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johannes,

On Thu, 23 Apr 2020 at 13:29, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Hi Hauke, Sumit,
>
> > > Felix reported that the file /sys/kernel/debug/ieee80211/phy0/rc is now
> > > located at /sys/kernel/debug/rc.
>
> Yeah, we noticed this the other day too.
>
> > +++ b/net/wireless/core.c
> > @@ -473,6 +473,10 @@ struct wiphy *wiphy_new_nm(const struct
> > cfg80211_ops *ops, int sizeof_priv,
> >                 }
> >         }
> >
> > +       /* add to debugfs */
> > +       rdev->wiphy.debugfsdir = debugfs_create_dir(wiphy_name(&rdev->wiphy),
> > +                                                   ieee80211_debugfs_dir);
>
> This cannot work, we haven't committed to the name of the wiphy yet at
> this point.

Maybe I am missing something, can you please elaborate here?

Looking at the code, the default or requested wiphy name is configured
just above this and the rename API "cfg80211_dev_rename()" takes care
of renaming wiphy debugfs directory too.

-Sumit

>
> I have some fixes, I'll send them out asap.
>
> johannes
>
