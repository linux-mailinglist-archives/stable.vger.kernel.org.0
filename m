Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3B342AA07
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 18:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhJLQyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 12:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhJLQym (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 12:54:42 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A37BC061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 09:52:40 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id n8so87639931lfk.6
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 09:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xawnIR012Yk1jlMpJVQsdMc2RuzZeUTjtaZq6SPv/vQ=;
        b=CKhySEFvBmeBz2lcrERZC74hIR/KWwGPXSyIVPq6Td7ba04vZohMLOQL35RLwjANyH
         tfRgYDWy9nS8fywNgnSJSAzXNkbXoJ8qv+rsx9CVsCqcxvQWM6yTOBwjT6GIxGxTJ309
         bdaopyFfF+TiJh1ryg3F2OgcV1MxRjt94pHkqLEqDjFEn71AgZ/T64PwP29o9jxf8FOf
         JQqiSaU7BsB1x3DmlIPL0UmzMPqNnYAeenGf9Xc0aIPeoz1FxZofoYiGi9sCj348z2MM
         I5RdGgQMykcHrAo3w2BRDPeuDZh+Mh1f0p5hwizFdVfDfL5rTmqE5UK7aKtZ8hzLJi02
         vXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xawnIR012Yk1jlMpJVQsdMc2RuzZeUTjtaZq6SPv/vQ=;
        b=yb8VVH24m9myT8FBkbqnR8CB705I4lMFwcxQSk1Rqms/ZR9Rr6YZOmjeV2sHUpz9xz
         cs75frahKy+MnlomMalE03ZwHtuPfdWJfLU5gxlW9syknn0SWDyq7Znk4IDzK4cOxDQy
         S3E4mkgOnWeBwg6o8OwqZsA7JUGuMGvBnwvJJKVuDQsDIQFDi1OYb4xj00NmWiNwiW32
         YQO14a6CFT4LvrYOYKQVNFqlBoV7reFVez5bruLR9ZxKD3t0nT+pTQff9dw/r2oJwYHx
         QHa9cFI6XEqV0SX7/Xc7LHwAXrSQQBMk25gNR9VzGqgREE3ArrTv8VEkaYWdjqVoPjVI
         GO4g==
X-Gm-Message-State: AOAM530s8I6NqUXW8iEuL94GSNMndVqFTsilYWfIyNJp2+TDENMGAKtW
        vycJuFOlSpwUWijQoIJHfi9IYUCiPd4PS80TjC+njw==
X-Google-Smtp-Source: ABdhPJwB9dqUf+AUdpqZ35D03WL9djp77vt7gTwCxcfcHj8MfPK1AU+kSPKFzNG8xdRVQ054ptpUFcbbXHlOvgM1N1Q=
X-Received: by 2002:a05:6512:13a5:: with SMTP id p37mr34642679lfa.403.1634057558265;
 Tue, 12 Oct 2021 09:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211007004629.1113572-1-tkjos@google.com> <20211007004629.1113572-4-tkjos@google.com>
 <CAHC9VhTRTcZW9eyXXvAN7T=ZCQ_zwH5iBz+d0h2ntf7=XHE-Vw@mail.gmail.com>
 <CAHRSSEy=eC0rbHUzDmCo6Na7Ya=uCq7zJ6_cXysi0oWQB=19YQ@mail.gmail.com>
 <CAHC9VhQVKTxwUUP02U43=zVZrEFWc0hhmpaR1YSxe+KHjhnhbw@mail.gmail.com>
 <CAHRSSEwYrqFum7gS0XOYG0p3F+0Hv8qvaZbWLUyXUm0oCWpX9w@mail.gmail.com> <CAEjxPJ5YT36ZvrN6uSDOCNv3pYrWBzcutsnSjSzya-5e0v9Rpw@mail.gmail.com>
In-Reply-To: <CAEjxPJ5YT36ZvrN6uSDOCNv3pYrWBzcutsnSjSzya-5e0v9Rpw@mail.gmail.com>
From:   Todd Kjos <tkjos@google.com>
Date:   Tue, 12 Oct 2021 09:52:26 -0700
Message-ID: <CAHRSSExyd--=r2g6FaRdhh5YtWBWPDOezyqW+8-HSOJw2bZhUw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] binder: use euid from cred instead of using task
To:     Stephen Smalley <stephen.smalley.work@gmail.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        arve@android.com, tkjos@android.com, maco@android.com,
        christian@brauner.io, James Morris <jmorris@namei.org>,
        Serge Hallyn <serge@hallyn.com>,
        Eric Paris <eparis@parisplace.org>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 12, 2021 at 5:24 AM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
>
> On Mon, Oct 11, 2021 at 7:39 PM Todd Kjos <tkjos@google.com> wrote:
> >
> > On Mon, Oct 11, 2021 at 2:39 PM Paul Moore <paul@paul-moore.com> wrote:
> > >
> > > On Fri, Oct 8, 2021 at 5:24 PM Todd Kjos <tkjos@google.com> wrote:
> > > >
> > > > On Fri, Oct 8, 2021 at 2:12 PM Paul Moore <paul@paul-moore.com> wrote:
> > > > >
> > > > > On Wed, Oct 6, 2021 at 8:46 PM Todd Kjos <tkjos@google.com> wrote:
> > > > > >
> > > > > > Set a transaction's sender_euid from the 'struct cred'
> > > > > > saved at binder_open() instead of looking up the euid
> > > > > > from the binder proc's 'struct task'. This ensures
> > > > > > the euid is associated with the security context that
> > > > > > of the task that opened binder.
> > > > > >
> > > > > > Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
> > > > > > Signed-off-by: Todd Kjos <tkjos@google.com>
> > > > > > Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> > > > > > Cc: stable@vger.kernel.org # 4.4+
> > > > > > ---
> > > > > > v3: added this patch to series
> > > > > >
> > > > > >  drivers/android/binder.c | 2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >
> > > > > This is an interesting ordering of the patches.  Unless I'm missing
> > > > > something I would have expected patch 3/3 to come first, followed by
> > > > > 2/3, with patch 1/3 at the end; basically the reverse of what was
> > > > > posted here.
> > > >
> > > > 2/3 and 3/3 both depend on 1/3 (add "cred" member of struct
> > > > binder_proc). I kept that in 1/3 to keep that patch the same as what
> > > > had already been reviewed. I didn't think much about the ordering
> > > > between 2/3 and 3/3 -- but I agree that it would have been sensible to
> > > > reverse their order.
> > > >
> > > > >
> > > > > My reading of the previous thread was that Casey has made his peace
> > > > > with these changes so unless anyone has any objections I'll plan on
> > > > > merging 2/3 and 3/3 into selinux/stable-5.15 and merging 1/3 into
> > > > > selinux/next.
> > > >
> > > > Thanks Paul. I'm not familiar with the branch structure, but you need
> > > > 1/3 in selinux/stable-5.15 to resolve the dependency on proc->cred.
> > >
> > > Yep, thanks.  My eyes kinda skipped over that part when looking at the
> > > patchset but that would have fallen out as soon as I merged them.
> > >
> > > Unfortunately that pretty much defeats the purpose of splitting this
> > > into three patches.  While I suppose one could backport patches 2/3
> > > and 3/3 individually, both of them have a very small footprint
> > > especially considering their patch 1/3 dependency.  At the very least
> > > it looks like patch 2/3 needs to be respun to address the
> > > !CONFIG_SECURITY case and seeing the split patches now I think the
> > > smart thing is to just combine them into a single patch.  I apologize
> > > for the bad recommendation earlier, I should have followed that thread
> > > a bit closer after the discussion with Casey and Stephen.
> >
> > I'm happy to submit a single patch for all of this. Another part of
> > the rationale
> > for splitting it into 3 patches was correctly identify the patch that introduced
> > the patch that introduced the issue -- so each of the 3 had a different
> > "Fixes:" tag. Should I cite the oldest (binder introduction) with the "Fixes"
> > tag and perhaps mention the other two in the commit message?
>
> Couldn't you just split patch 1 into the "add cred to binder proc"
> part and "use cred in LSM/SELinux hooks" part, combine patch 3 with
> the "add cred to binder proc" part to create new patch 1, then "use
> cred in LSM/SELinux hooks" part is patch 2, and "switch task_getsecid
> to cred_getsecid" to patch 3? Then patch 1 can be cherry-picked/ported
> all the way back to the introduction of binder, patch 2 all the way
> back to the introduction of binder LSM/SELinux hooks, and patch 3 just
> back to where passing the secctx across binder was introduced.

Sending a v5 with this refactoring and the !CONFIG_SECURITY fix
