Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C669695503
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 00:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjBMXun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 18:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBMXum (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 18:50:42 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0179118AA0
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:50:16 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id 81so5806847ybp.5
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/FT+wytgM0VWNp2khoBQRK6+3iQndNyjsjvLj9/BF0o=;
        b=YX6UBeGBrDsSaPExb1/m/al7La5LF8ds9CzmACNP5wZ3A7aRy0S5n5EYAboZE1AVYk
         LKnS6iCpkm+NCAJRfgXMBPAAee82MANl6z9Egn3HBQL8+DDTloIoKF1hf0rqhrRR3Z4Q
         HDEumfMrljpTLskBJLusW4Aux5ztIp5pSnmGrygyRElhRq2bGknFQFca17kbpN+mn/uI
         /pNjKVTVOxwi4EedxjiXrKLI/5GAUFJ1uKqMaYfPHvKEbtrVEK7s574QvJ6sxN6KuPpK
         GF3ID5mQGWn/fj5+twl9PJdyzo8T2o7cl8RC5jgz4gthQhBLpoFPgZzJzgFk0EPvzo7B
         yg6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/FT+wytgM0VWNp2khoBQRK6+3iQndNyjsjvLj9/BF0o=;
        b=KgAZNiqvGSch26WUcQBh2RiLXvRSjhAN8g8wN9RF4F4M3AlLRBcgwSArymmaTMhzgj
         EcGTKwUJrHl9AL0sXgGZInCc56rIMEaTnIVF5mhsPO8tatmluzReZbmtnqQALJpKFA+K
         bdc+skcjXi3lQlrTVW74O4q+VFcA6zfnGA9jVP40GmDiomEPDIZov9MrFyIG8jTbc011
         VK3FdsT10pr+G5BCmsuQhXBcHxmBhuSmqMUGnKcvfA4/le0ZvSPKWxZ5juA3IRCuBex3
         fR9yf9b/DAXb2AzesvTvBLKEhrlMfV4ubxUm4uj8+406bXxMnG00nMKUERrNfPqnDwfZ
         vfIg==
X-Gm-Message-State: AO0yUKVC2ObJDzqYHi8mEiJ9gf4/K938NmYNvuhyTK57zZNJh4GBc+/A
        Z0BZMjBCHijULBx2TUy6mv7Kb3M88IY21Z4EkKI6iA==
X-Google-Smtp-Source: AK7set9YvqKjU6/vp0rfYhefce64PiRsLuVzPrjuRi58c5zUNgAb80Bye1pFfse0I4QrxilSLOi+TmkNQydBgyh36MQ=
X-Received: by 2002:a05:6902:52a:b0:900:c3fd:a078 with SMTP id
 y10-20020a056902052a00b00900c3fda078mr76541ybs.657.1676332215989; Mon, 13 Feb
 2023 15:50:15 -0800 (PST)
MIME-Version: 1.0
References: <CAJuCfpFZ3B4530TgsSHqp5F_gwfrDujwRYewKReJru==MdEHQg@mail.gmail.com>
 <20230202030023.1847084-1-kamatam@amazon.com> <Y9tCl4r/qjqsrVj9@sol.localdomain>
 <CAJuCfpFb0J5ZwO6kncjRG0_4jQLXUy-_dicpH5uGiWP8aKYEJQ@mail.gmail.com>
 <CAJuCfpH4aAAfEJeFzZSGsifhFNCpzZ17MEzXtxhZqoX04jrWbA@mail.gmail.com>
 <Y+U/k678tB5w5hJP@gmail.com> <CAJuCfpECvLiEdp+VfDo=_ZmhakEbtL2JzcwDfFahUk4XBOYNpg@mail.gmail.com>
In-Reply-To: <CAJuCfpECvLiEdp+VfDo=_ZmhakEbtL2JzcwDfFahUk4XBOYNpg@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Mon, 13 Feb 2023 15:50:05 -0800
Message-ID: <CAJuCfpHa+RhNk_-C=c=E8opF7mR2tnpd-KyhaXCQ8XnKvwVXoQ@mail.gmail.com>
Subject: Re: [PATCH] sched/psi: fix use-after-free in ep_remove_wait_queue()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Munehisa Kamata <kamatam@amazon.com>, hannes@cmpxchg.org,
        hdanton@sina.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mengcc@amazon.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 9, 2023 at 11:13 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
> On Thu, Feb 9, 2023 at 10:46 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Thu, Feb 09, 2023 at 09:09:03AM -0800, Suren Baghdasaryan wrote:
> > > On Thu, Feb 2, 2023 at 1:11 PM Suren Baghdasaryan <surenb@google.com> wrote:
> > > >
> > > > On Wed, Feb 1, 2023 at 8:56 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > > > >
> > > > > On Wed, Feb 01, 2023 at 07:00:23PM -0800, Munehisa Kamata wrote:
> > > > > > diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> > > > > > index 8ac8b81bfee6..6e66c15f6450 100644
> > > > > > --- a/kernel/sched/psi.c
> > > > > > +++ b/kernel/sched/psi.c
> > > > > > @@ -1343,10 +1343,11 @@ void psi_trigger_destroy(struct psi_trigger *t)
> > > > > >
> > > > > >       group = t->group;
> > > > > >       /*
> > > > > > -      * Wakeup waiters to stop polling. Can happen if cgroup is deleted
> > > > > > -      * from under a polling process.
> > > > > > +      * Wakeup waiters to stop polling and clear the queue to prevent it from
> > > > > > +      * being accessed later. Can happen if cgroup is deleted from under a
> > > > > > +      * polling process otherwise.
> > > > > >        */
> > > > > > -     wake_up_interruptible(&t->event_wait);
> > > > > > +     wake_up_pollfree(&t->event_wait);
> > > > > >
> > > > > >       mutex_lock(&group->trigger_lock);
> > > > >
> > > > > wake_up_pollfree() should only be used in extremely rare cases.  Why can't the
> > > > > lifetime of the waitqueue be fixed instead?
> > > >
> > > > waitqueue lifetime in this case is linked to cgroup_file_release(),
> > > > which seems appropriate to me here. Unfortunately
> > > > cgroup_file_release() is not directly linked to the file's lifetime.
> > > > For more details see:
> > > > https://lore.kernel.org/all/CAJuCfpFZ3B4530TgsSHqp5F_gwfrDujwRYewKReJru==MdEHQg@mail.gmail.com/#t
> > > > .
> > > > So, if we want to fix the lifetime of the waitqueue, we would have to
> > > > tie cgroup_file_release() to the fput() somehow. IOW, the fix would
> > > > have to be done at the cgroups or higher (kernfs?) layer.
> > >
> > > Hi Eric,
> > > Do you still object to using wake_up_pollfree() for this case?
> > > Changing higher levels to make cgroup_file_release() be tied to fput()
> > > would be ideal but I think that would be a big change for this one
> > > case. If you agree I'll Ack this patch.
> > > Thanks,
> > > Suren.
> > >
> >
> > I haven't read the code closely in this case.  I'm just letting you know that
> > wake_up_pollfree() is very much a last-resort option for when the waitqueue
> > lifetime can't be fixed.
>
> Got it. Thanks for the warning.
> I think it can be fixed but the right fix would require a sizable
> higher level refactoring which might be more justifiable if we have
> more such cases in the future.
>
> >  So if you want to use wake_up_pollfree(), you need to
> > explain why no other fix is possible.  For example maybe the UAPI depends on the
> > waitqueue having a nonstandard lifetime.
>
> I think the changelog should explain that the waitqueue lifetime in
> cases of non-root cgroups is tied to cgroup_file_release() callback,
> which in turn is not tied to file's lifetime. That's the reason for
> waitqueue and the file having different lifecycles. Would that suffice
> as the justification?

Ok, in the absence of objections, I would suggest resending this patch
with the changelog including details about waitqueue lifetime and
reasons wake_up_pollfree() is required here.
Munehisa, feel free to reuse
https://lore.kernel.org/all/CAJuCfpFZ3B4530TgsSHqp5F_gwfrDujwRYewKReJru==MdEHQg@mail.gmail.com/#t
if you find it useful.
Thanks,
Suren.

> Again, I'm not saying that no other fix is possible, but that the
> right fix would be much more complex.
> Thanks,
> Suren.
>
> >
> > - Eric
