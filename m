Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DB82D04B3
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 13:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgLFMLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 07:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgLFMLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 07:11:42 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCCCC0613D0
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 04:11:01 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id s11so3237559ljp.4
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 04:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kJXWMpj6UKzIeFwLIi3niYqEB8uaDFs6TOVJE8hmRW4=;
        b=q6Ul/VesKrA9VdJp7r1FV7J+/oPFqjJfXp/gFKgzatJnGQ3Aojl+sLttuYTVXVNeuz
         GGk6aDWxnfbrclkAiGE81BCQXgkWPaBINpf1dfV1erLJ63hMyJLDcr9SeUH9PvpyGp6F
         FkmsMcJdYY5olhiVW4kM17GNWY9W9nDU3cE03C9ZjauP3Hbz8VUF+AAiS7rVNDQ/A9Lj
         xQcWjA9XBcAyw6mui41ycZh6N4zvmWhuCXdiJA1MK42uS/LRgrVMLwC2H3KeMhSGYSCq
         WyjUpoQS0bvPtP06fYHM4elRP1zQzjqWiclLAC/IVfM8+LQsCZmVP27S6UsLMhEeifdD
         QtUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kJXWMpj6UKzIeFwLIi3niYqEB8uaDFs6TOVJE8hmRW4=;
        b=lNm6GUV3v6mRnfgePWb9FOt0Yfl4CFPx3wjH18F1VlDZKh/eCFSCJQjS9N6dVKQsot
         5jUjhKsIi+luA5K6UwOqbVjy3AznhQqMfW4Jrtp/ME8lkgMYe2suvubyGIXxVbDRNIFs
         wJXyesZUy03nvh/bHhOOdL3K/aMZQM6iOvWCfejw8wkwC9yKFKdElJJX495hdKE087Gy
         kdy0eqjOc8QnTkLl4ccxYIH3kIw6RpmXM2s8cUA4Wk97ENRb9r7nOjtHrUwL6NX4GW1Z
         8j/Ure5/btiZlBTJhHIiIuP+/LTRyir/obYz/AgvcmKXbNN7zS/OIZIfEbXZchR/VGSF
         PQ7Q==
X-Gm-Message-State: AOAM532Wg0DbAFJoYkFVJj81aVIY5IjNJiIyLruMWAvtK3ocd4R9hSqZ
        4KHqFmZRa79kVlxlxyizntT8/Z7SES69jR8yKF7xQg==
X-Google-Smtp-Source: ABdhPJwOWRYI4zqj50pe/JPF0WTdjPHg6S50QPBgmvfiK491gg+51pFz621VIIoqK6L7dApK5jjqYynKr+jWJggxGfI=
X-Received: by 2002:a2e:9990:: with SMTP id w16mr6867508lji.111.1607256660049;
 Sun, 06 Dec 2020 04:11:00 -0800 (PST)
MIME-Version: 1.0
References: <159041776924279@kroah.com> <20200525172709.GB7427@vingu-book>
 <X8yq+7/dQADbrTTL@kroah.com> <CAKfTPtDmpYYA2nc-+d3OfT-=2kf82+3O50WGguDQ=XOXTnbZGQ@mail.gmail.com>
 <X8zDGGvVkyDGbco/@kroah.com> <CAKfTPtBTXdVVwB+st4agBbJ3oXnB5gJ7BwvgM7=191PWvvxMLg@mail.gmail.com>
 <X8zJbSgaegj5He+i@kroah.com>
In-Reply-To: <X8zJbSgaegj5He+i@kroah.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Sun, 6 Dec 2020 13:10:48 +0100
Message-ID: <CAKfTPtCuohx7dYXm4tgA9JujEAfOv0dSVPjjFz2VNw9dzcBCHA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tao Zhou <zohooouoto@zoho.com.cn>,
        "# v4 . 16+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 6 Dec 2020 at 13:05, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sun, Dec 06, 2020 at 12:54:57PM +0100, Vincent Guittot wrote:
> > On Sun, 6 Dec 2020 at 12:47, Greg KH <gregkh@linuxfoundation.org> wrote=
:
> > >
> > > On Sun, Dec 06, 2020 at 12:25:12PM +0100, Vincent Guittot wrote:
> > > > On Sun, 6 Dec 2020 at 10:56, Greg KH <gregkh@linuxfoundation.org> w=
rote:
> > > > >
> > > > > On Mon, May 25, 2020 at 07:27:09PM +0200, Vincent Guittot wrote:
> > > > > > Le lundi 25 mai 2020 =C3=A0 16:42:49 (+0200), gregkh@linuxfound=
ation.org a =C3=A9crit :
> > > > > > >
> > > > > > > The patch below does not apply to the 5.4-stable tree.
> > > > > > > If someone wants it applied there, or to any other stable or =
longterm
> > > > > > > tree, then please email the backport, including the original =
git commit
> > > > > > > id to <stable@vger.kernel.org>.
> > > > > >
> > > > > > This patch needs  commit
> > > > > >     b34cb07dde7c ("sched/fair: Fix enqueue_task_fair() warning =
some more")
> > > > > > to be applied first. But then, it will not apply. The backport =
is :
> > > > > >
> > > > > > [ Upstream commit 39f23ce07b9355d05a64ae303ce20d1c4b92b957 upst=
ream ]
> > > > > >
> > > > > > Although not exactly identical, unthrottle_cfs_rq() and enqueue=
_task_fair()
> > > > > > are quite close and follow the same sequence for enqueuing an e=
ntity in the
> > > > > > cfs hierarchy. Modify unthrottle_cfs_rq() to use the same patte=
rn as
> > > > > > enqueue_task_fair(). This fixes a problem already faced with th=
e latter and
> > > > > > add an optimization in the last for_each_sched_entity loop.
> > > > > >
> > > > > > Fixes: fe61468b2cb (sched/fair: Fix enqueue_task_fair warning)
> > > > > > Reported-by Tao Zhou <zohooouoto@zoho.com.cn>
> > > > > > Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> > > > > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > > > > Reviewed-by: Phil Auld <pauld@redhat.com>
> > > > > > Reviewed-by: Ben Segall <bsegall@google.com>
> > > > > > Link: https://lkml.kernel.org/r/20200513135528.4742-1-vincent.g=
uittot@linaro.org
> > > > > > ---
> > > > > >  kernel/sched/fair.c | 36 ++++++++++++++++++++++++++++--------
> > > > > >  1 file changed, 28 insertions(+), 8 deletions(-)
> > > > >
> > > > > This patch doesn't apply to the 5.4.y tree at all.  Can someone p=
lease
> > > > > provide a working backport?
> > > >
> > > > It seems that commit b34cb07dde7c ("sched/fair: Fix
> > > > enqueue_task_fair() warning some more") has already been applied ba=
ck
> > > > in May. But then, I'm able to apply this patch on top of
> > > > v5.4.y/v5.4.81
> > > >
> > >
> > > What is "this patch" here?  I tried to apply 39f23ce07b93 ("sched/fai=
r:
> > > Fix unthrottle_cfs_rq() for leaf_cfs_rq list") directly to the 5.4 tr=
ee
> > > and it too did not apply.
> >
> > commit 39f23ce07b93 ("sched/fair: Fix unthrottle_cfs_rq() for
> > leaf_cfs_rq list") can't apply because there are several changes which
> > are not fixes which have been applied since v5.4 on the same code.
> >
> > This patch is the backport on v5.4 of the commit 39f23ce07b93
>
> What is "this"?  I tried to apply the above patch to the 5.4.y tree, and

I was referring to the email  <20200525172709.GB7427@vingu-book>

> it didn't apply.  So I still do not understand what I can do here...

Let me resend it with a clean subject title

>
> greg k-h
