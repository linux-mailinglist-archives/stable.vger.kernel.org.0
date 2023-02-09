Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF66690EDF
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 18:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjBIRJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 12:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjBIRJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 12:09:25 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB32663CA
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 09:09:15 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id q9so3186055ybk.2
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 09:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DY0JZr3/FM1oQfF6chE6B8rxd0sU12VPwe3bSSteMxg=;
        b=I8HZPf7D0FxIe6VTVVFAubTVAgnI+tCYjqI7KRQ/HMFj6pEKCqM7h2j5P9SFBXyuym
         /2I69PCgJEsmbUXrscXRakg6lGYyKbw9gmZ8su+2VJ33b8PWUXnTCk/Cpfnx9rIaJuQd
         QyWTa/mgK4uVWFidgakqQEh0cG9bkn6FnPbKN2ByA0jBTHsT7ja1UtTwgnVTcHti7MC1
         40ns2kqErfyA1IiHIJol0TFmmPO+7Vn2LFg2MoOmnfhuyaBx0qC7fHUmGMG1MLsWY+oZ
         vGPrVq7E4sjXxYAOXxeCxz7UA6ovZ+ycAljOE1XqSknomRu6Q4j8JaDSCPrPLhZdPw3A
         RciQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DY0JZr3/FM1oQfF6chE6B8rxd0sU12VPwe3bSSteMxg=;
        b=XCxarPLJVM+Mi4CTdeSX9UJAsBih+ais0Xz000MhoMvgK8b2ISxr9bLJNIj6CoW7Nk
         ViXQhniO2uQrCWwYuxIWVcGF+aK+lUwa3IwEc9Yfqj9EcvGNAi1BC2wPgMsT1KEEP6DM
         rbsmyRioIVb7OyMA/Wn7d9dhPzc4Ru5hhPPrbA7uYHR08/zuO7OmjiaL4pC5xM8MaAZO
         3fbDJBfb29XHO3Li5Oi5UpDsTYIuOIfkomD46Qxt7fOn7rRaDA2eoAT0X/JSXKg80ghg
         iFguoLYPVcZw+ij5byOhUKY/LcezH3em/dH9IGee+cjYswwgglKBoSdBGG6vakEZTph2
         0WFQ==
X-Gm-Message-State: AO0yUKU/uWtd3btJaXZF0xQuPwiS5fvEFjblLAY7F+ZehN64FDQW9/um
        tqws+0aO156Uz37AdTYkd5UalAZbwXiOTifvMwfqMQ==
X-Google-Smtp-Source: AK7set9rAr8bauVdnM3urYoRXpGl0jF9WECXkedkogNbOjy+WCD2HhQ1JJJjnxIYu6wnN0dLrS/+XK4Ab6whWRlD6OY=
X-Received: by 2002:a25:8d83:0:b0:8e8:8b13:dd36 with SMTP id
 o3-20020a258d83000000b008e88b13dd36mr14486ybl.340.1675962553991; Thu, 09 Feb
 2023 09:09:13 -0800 (PST)
MIME-Version: 1.0
References: <CAJuCfpFZ3B4530TgsSHqp5F_gwfrDujwRYewKReJru==MdEHQg@mail.gmail.com>
 <20230202030023.1847084-1-kamatam@amazon.com> <Y9tCl4r/qjqsrVj9@sol.localdomain>
 <CAJuCfpFb0J5ZwO6kncjRG0_4jQLXUy-_dicpH5uGiWP8aKYEJQ@mail.gmail.com>
In-Reply-To: <CAJuCfpFb0J5ZwO6kncjRG0_4jQLXUy-_dicpH5uGiWP8aKYEJQ@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Thu, 9 Feb 2023 09:09:03 -0800
Message-ID: <CAJuCfpH4aAAfEJeFzZSGsifhFNCpzZ17MEzXtxhZqoX04jrWbA@mail.gmail.com>
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

On Thu, Feb 2, 2023 at 1:11 PM Suren Baghdasaryan <surenb@google.com> wrote:
>
> On Wed, Feb 1, 2023 at 8:56 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Wed, Feb 01, 2023 at 07:00:23PM -0800, Munehisa Kamata wrote:
> > > diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> > > index 8ac8b81bfee6..6e66c15f6450 100644
> > > --- a/kernel/sched/psi.c
> > > +++ b/kernel/sched/psi.c
> > > @@ -1343,10 +1343,11 @@ void psi_trigger_destroy(struct psi_trigger *t)
> > >
> > >       group = t->group;
> > >       /*
> > > -      * Wakeup waiters to stop polling. Can happen if cgroup is deleted
> > > -      * from under a polling process.
> > > +      * Wakeup waiters to stop polling and clear the queue to prevent it from
> > > +      * being accessed later. Can happen if cgroup is deleted from under a
> > > +      * polling process otherwise.
> > >        */
> > > -     wake_up_interruptible(&t->event_wait);
> > > +     wake_up_pollfree(&t->event_wait);
> > >
> > >       mutex_lock(&group->trigger_lock);
> >
> > wake_up_pollfree() should only be used in extremely rare cases.  Why can't the
> > lifetime of the waitqueue be fixed instead?
>
> waitqueue lifetime in this case is linked to cgroup_file_release(),
> which seems appropriate to me here. Unfortunately
> cgroup_file_release() is not directly linked to the file's lifetime.
> For more details see:
> https://lore.kernel.org/all/CAJuCfpFZ3B4530TgsSHqp5F_gwfrDujwRYewKReJru==MdEHQg@mail.gmail.com/#t
> .
> So, if we want to fix the lifetime of the waitqueue, we would have to
> tie cgroup_file_release() to the fput() somehow. IOW, the fix would
> have to be done at the cgroups or higher (kernfs?) layer.

Hi Eric,
Do you still object to using wake_up_pollfree() for this case?
Changing higher levels to make cgroup_file_release() be tied to fput()
would be ideal but I think that would be a big change for this one
case. If you agree I'll Ack this patch.
Thanks,
Suren.

> Thanks,
> Suren.
>
> >
> > - Eric
