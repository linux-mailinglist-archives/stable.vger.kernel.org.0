Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6EE4235CE
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 04:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbhJFC3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 22:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237217AbhJFC3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 22:29:42 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7F9C061755
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 19:27:50 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id d18so1344459vsh.1
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 19:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4OYSce36HFIDKSweIZsHOeEUQcMTMlRZW+u2FdUpafE=;
        b=gHppIZL0NNL41Ah+TizK4cJGOSQt6n8ckgXCCWKJaVG6WuNu6D39wA8hcCUdEJ2ZBF
         qP4uE8XmPBjyiFvPVso2jkrCUkzwGiwtyJdgYFh1W5jA3tUXXB194CJSf1C7SEgMRs4W
         P6IDsUGsVQQvAQ7Amh1603Oup30JJYY0v3AZShcjcLS2cXmQ+BJ6vQoFS+wc7BMdd6bh
         3EMeA44QQpjNXBGt2u4IpozI3Xy6CHpvFOfLvcPRLEmIVi6pIMRUrkMqgtyU0i2mHuuj
         Q0k1kaP8hRW26c/ju0oSzrupcbkC9MJyflrfUTGXotsjd/k5vs3AS5biUUCmwpkqPkfE
         RsZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4OYSce36HFIDKSweIZsHOeEUQcMTMlRZW+u2FdUpafE=;
        b=W6K8BVlc5WDnQ+Kbdh47rtRtzn4e2nVqlErJvKkBH3UUohrQB4+1Lqi0UrOyz6AeA9
         bkW+W05TmMuy0N4S/meAG0sUuBc4aIibtfaCv+L7lQs6H+bHPxX1zjpMZkKI0jIQ8CFe
         vO2Ax5oPfKGRM1W4D4WbF5ASdqumCeFxSCU88eoRJJfwNR0CfYiawq2ABvX1xc9MQC48
         jMzdyFtvbUvDJxs2RcNrq7UOkPcLiRftshyndpXsnuG3LuOK0IWfqc8kb28jt7boXbjR
         Aa5nhkm6iMY7JXkve8CpC84+4tsqmaRTmEc1OAjA+lSQA7JNCZyCJzCSNSAGhE7L7OCf
         8c+A==
X-Gm-Message-State: AOAM530V5we9vv1Jf/azEq+tUgGgoivKpt+7zresXAyjN0U8Qk9Abnmf
        WTMt0ZdItF3mz2o6742fSvsiOPBnoRlTZkwMNuAhRA==
X-Google-Smtp-Source: ABdhPJyTH29CQo/Jwiml4RScXu5onK6nUS1xqUF5+/gSLGjq9q1MVF4srzfle3qW/NbIcsfW6Jj+di+yUzIVAAeTe7Y=
X-Received: by 2002:a67:fd67:: with SMTP id h7mr382372vsa.52.1633487269836;
 Tue, 05 Oct 2021 19:27:49 -0700 (PDT)
MIME-Version: 1.0
References: <20211001175521.3853257-1-tkjos@google.com> <c6a650e4-15e4-2943-f759-0e9577784c7a@schaufler-ca.com>
 <CAG48ez2tejBUXJGf0R9qpEiauL9-ABgkds6mZTQD7sZKLMdAAQ@mail.gmail.com>
 <CAG48ez1SRau1Tnge5HVqxCFsNCizmnQLErqnC=eSeERv8jg-zQ@mail.gmail.com>
 <f59c6e9f-2892-32da-62f8-8bbeec18ee4c@schaufler-ca.com> <CAG48ez0yF0u=QBLVL2XrGB8r8ouQj-_aS9SScu4O4f+LhZxCDw@mail.gmail.com>
 <e0c1fab9-cb97-d5af-1f4b-f15b6b2097fd@schaufler-ca.com> <CAG48ez3qc+2sc6xTJQVqLTRcjCiw_Adx13KT3OvPMCjBLjZvgA@mail.gmail.com>
 <6bd2de29-b46a-1d24-4c73-9e4e0f3f6eea@schaufler-ca.com> <CAG48ez0RM6NGZLdEjaqU9KmaOgeFR6cSeNo50XG9oaFxC_ayYw@mail.gmail.com>
 <CAEjxPJ4X4N_zgH4oRbdkZi21mvS--ExDb_1gad09buMHshB_hQ@mail.gmail.com> <7ec1090d-5bd7-bd05-4f38-07b1cc993721@schaufler-ca.com>
In-Reply-To: <7ec1090d-5bd7-bd05-4f38-07b1cc993721@schaufler-ca.com>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 6 Oct 2021 04:27:22 +0200
Message-ID: <CAG48ez3ZxzO3fa0T3pE0a4wQYQDvBNY=i+Nj4MtZq-QHtJdFdA@mail.gmail.com>
Subject: Re: [PATCH v2] binder: use cred instead of task for selinux checks
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Stephen Smalley <stephen.smalley.work@gmail.com>,
        Todd Kjos <tkjos@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        arve@android.com, tkjos@android.com, maco@android.com,
        christian@brauner.io, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Kees Cook <keescook@chromium.org>,
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

On Tue, Oct 5, 2021 at 6:59 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 10/5/2021 8:21 AM, Stephen Smalley wrote:
> > On Mon, Oct 4, 2021 at 8:27 PM Jann Horn <jannh@google.com> wrote:
> >> On Tue, Oct 5, 2021 at 1:38 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>> On 10/4/2021 3:28 PM, Jann Horn wrote:
> >>>> You can't really attribute binder transactions to specific tasks that
> >>>> are actually involved in the specific transaction, neither on the
> >>>> sending side nor on the receiving side, because binder is built around
> >>>> passing data through memory mappings. Memory mappings can be accessed
> >>>> by multiple tasks, and even a task that does not currently have it
> >>>> mapped could e.g. map it at a later time. And on top of that you have
> >>>> the problem that the receiving task might also go through privileged
> >>>> execve() transitions.
> >>> OK. I'm curious now as to why the task_struct was being passed to the
> >>> hook in the first place.
> >> Probably because that's what most other LSM hooks looked like and the
> >> authors/reviewers of the patch didn't realize that this model doesn't
> >> really work for binder? FWIW, these hooks were added in commit
> >> 79af73079d75 ("Add security hooks to binder and implement the hooks
> >> for SELinux."). The commit message also just talks about "processes".
> > Note that in the same code path (binder_transaction), sender_euid is
> > set from proc->tsk and security_ctx is based on proc->tsk. If we are
> > changing the hooks to operate on the opener cred, then presumably we
> > should be doing that for sender_euid and replace the
> > security_task_getsecid_obj() call with security_cred_getsecid()?
> >
> > NB Mandatory Access Control doesn't allow uncontrolled delegation,
> > hence typically checks against the subject credential either at
> > delegation/transfer or use or both. That's true in other places too,
> > e.g. file_permission, socket_sendmsg.
>
> Terrific. Now I'm even less convinced that either the proposed change
> or the existing code make sense. It's also disturbing that the change
> log claims that the reason for the change is fix a race condition when
> in fact it changes the data being sent to the hook completely.

The race it's referring to is the one between
security_binder_transaction() (which checks for permission to send a
transaction and checks for delegation) and
security_task_getsecid_obj() (which tells the recipient what the
sender's security context is). (It's a good thing Paul noticed that
the v1 patch didn't actually change the security_task_getsecid_obj()
call... somehow I missed that.)
