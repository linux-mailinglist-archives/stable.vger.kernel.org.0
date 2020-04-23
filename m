Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B901B584A
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 11:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgDWJgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 05:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgDWJgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 05:36:22 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1869CC03C1AF
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 02:36:22 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id u6so5480139ljl.6
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 02:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TfAeV8yk12RMyli5C0sf/nIamgsKLONTz3cbB7A848o=;
        b=eGGSkmwhU+ebYBteOxzPOclVJrKdkqgJcauqpPsi2F/beFLysiDdBYnktVDqYtJalt
         y40LcRmW/b1KlIaJVjjEPkdfNYfaAIfpOrpaBzTUCqcX6zvSkvpXnU1LUimv2mBcyWF/
         Gc0qvKSRJOHyPXJvpToCB5MOzyepdXuAYPYytBoIsoblH/u27KTa2MRserAmwqhbJgC8
         f05bKuVsK9oXrPjnQh91RApu278u+Zkl9Wcyj688BQ4M93f45fuD1zMWjQi8xmExTOCC
         ISsMrVkaHpn42PUwltinv+X6MclCZ9fbk6GUh0n2SH6R+vqRwvozT0Ejn4HkfgDajxlp
         EqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TfAeV8yk12RMyli5C0sf/nIamgsKLONTz3cbB7A848o=;
        b=cvUxJ7SzNWnR6Q1gvSMXrbzcJqt6SLxYYRoKIxbob91mrTDy6SUFGxYLNBCujG6rUT
         u8foSvE+Rq9/sqeoYxQ6uUW2ScDPy9ZYS38wU0rYfo94OJoCTQMbeJ81so0a8XSYAgAh
         MTcZIZfaUPhjuBi2UO7RIEh9+yGYuknIwsk3TMKUV0qpG48suW6zlnTjgvqRPMYnd1/x
         xAINroSLiqffGVxBHWNNnYXxcJ5LTcUWeZFez7ABRH5YpATjXfPp2BOt/EQVBCqfkCz3
         jQbPko51aDM1/mg5By5NiSMbBm9B6wg6RwU6a8xXiwn+wIR+QF8on4EY4YYoxPXmZc3p
         ZcBQ==
X-Gm-Message-State: AGi0PuaABtfyo9D5sk/LKYUMxGsAlUzP96z3vjo2d0je1RrdKpxFP0TD
        bFhYoNobjK8qKA5aPJz1g079OAbiUjQ4teH0vXm4xFHb
X-Google-Smtp-Source: APiQypL2jGwxZR8TODe2Lsg0dkEG09wMhVYxOpiLJA0Xbc+xIxHa3AGUeXqT1n2ctcdpSboClAGZWk6CtrVrlQmtQr8=
X-Received: by 2002:a05:651c:2002:: with SMTP id s2mr1672967ljo.285.1587634580596;
 Thu, 23 Apr 2020 02:36:20 -0700 (PDT)
MIME-Version: 1.0
References: <c304ad9c-f404-d22e-de74-9398da3ebfc3@hauke-m.de>
 <CAFA6WYN3FbqTivGJTfXtHsMjXNPXW+P4MZWiCL14utF2sHkeYg@mail.gmail.com>
 <885ae3bffad315445be3fc70cccade9067ee6937.camel@sipsolutions.net>
 <CAFA6WYMYQAnW0vKm4fxNn+nA6dYXvqaungBEYDpd-wrzaavr8A@mail.gmail.com> <42e9ac2651c677e9143b019393d60c3254893ae0.camel@sipsolutions.net>
In-Reply-To: <42e9ac2651c677e9143b019393d60c3254893ae0.camel@sipsolutions.net>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 23 Apr 2020 15:06:09 +0530
Message-ID: <CAFA6WYN5STtNPK+TJF_SwqSfO6sj8mwaJZ2zSno=pmSv2bbmdw@mail.gmail.com>
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

On Thu, 23 Apr 2020 at 14:29, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Thu, 2020-04-23 at 14:27 +0530, Sumit Garg wrote:
>
> > > > +++ b/net/wireless/core.c
> > > > @@ -473,6 +473,10 @@ struct wiphy *wiphy_new_nm(const struct
> > > > cfg80211_ops *ops, int sizeof_priv,
> > > >                 }
> > > >         }
> > > >
> > > > +       /* add to debugfs */
> > > > +       rdev->wiphy.debugfsdir = debugfs_create_dir(wiphy_name(&rdev->wiphy),
> > > > +                                                   ieee80211_debugfs_dir);
> > >
> > > This cannot work, we haven't committed to the name of the wiphy yet at
> > > this point.
> >
> > Maybe I am missing something, can you please elaborate here?
> >
> > Looking at the code, the default or requested wiphy name is configured
> > just above this and the rename API "cfg80211_dev_rename()" takes care
> > of renaming wiphy debugfs directory too.
>
> Yes, but I think wiphy_register() can still fail at this point, due to
> name clashes or so?
>
> In any case, it'd be very strange to have a debugfs entry around when
> the wiphy doesn't exist yet, and could possibly cause the same issue
> that you fixed again, just through debugfs accesses?
>

Now I understood your point. Yeah it's definitely better to expose
debugfs after the wiphy device is registered.

> Can you take a look at the patch I sent?

Sure I will take a look.

-Sumit

>
> johannes
>
