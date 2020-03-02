Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE551761FC
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 19:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgCBSI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 13:08:57 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:45556 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbgCBSI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 13:08:57 -0500
Received: by mail-oi1-f195.google.com with SMTP id v19so96668oic.12
        for <stable@vger.kernel.org>; Mon, 02 Mar 2020 10:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PzpHTT1CytF1CxOEOyrFfNGNhtkDEaDUtrYOH2iFLfA=;
        b=UqoUm420YQqph3lafHzahQC9V4PdPL/4Qyv6M+TEFjDDlhJUhALb/SAIvAmoSGffyg
         a+snzgE9CJkyJGW23tqeS/3KQPZf8xJ7BanaVOsbMgKmsVis3fA3OOYQ4v4jTJ1AGhBx
         K9uQcOSkDeBAtHH7P5nmgTAOojjqNLiO2lPI2fA3RN3wz4dmhavt79Zq4NlnBzpJ+OiA
         y/TbZNOouXWb/oNa3vM1C3IKrlLfcmIRapwpat4xfLEuvxXctHbiwYexiaQCCtswST76
         0aZ+VZ+Y0oTlg6eIsuwolOfq1+Y8oOzdLvBO6TZUDoqbSO/q1tj2btepq92gHR5lOUfD
         s1FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PzpHTT1CytF1CxOEOyrFfNGNhtkDEaDUtrYOH2iFLfA=;
        b=PquB12ZrVEGy4Xjj5LZ10mnvPkOz3T23jo4AcNxCAcUshjmxMHpa+lAcfrVDi+e7ff
         SdSS7At72B/DPEqYA/RUtimvzi0VOaN4EL9wKZ7IvGxweuxzYJ58WLayqjrRQYRvKyZg
         2ADVvi32L8Eqy4I8zEaThRdHUE7CzoPB5zEYX/xC2oYRWXSc1IoHcjzIUNIUWkK0mT6c
         TKBcOrEOfE2BXXIereyefShGbJjvC6XrAS3/K8AuwnQcmWgwMRln0sIUoLCl5/Nd+7O2
         6SB5Ci6Z4/bJKIeULNHh8SAb7OH/zGTqtxKeH0I1VV+bPtgix21THihhObvEYAoFaAFO
         xx8Q==
X-Gm-Message-State: ANhLgQ2c3J1yP+H4wbxt3HsE3ewMexyQW6A8wn0xooFS1ImOLxr0/KN9
        vr09oz8uaOzZF3FkQyyTGAcU8SzS2mx1O+3Bjqn1Og==
X-Google-Smtp-Source: ADFU+vvElPHbaOkc/ffKR7JWZMzjpg6bZ6JiSaTN3SNT/Yuy1ZmDiKrsYKSVrGwdXREPaOYmbN9ESv+hvKDnpyK2MgA=
X-Received: by 2002:aca:538e:: with SMTP id h136mr242942oib.39.1583172536153;
 Mon, 02 Mar 2020 10:08:56 -0800 (PST)
MIME-Version: 1.0
References: <AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <CAG48ez3QHVpMJ9Rb_Q4LEE6uAqQJeS1Myu82U=fgvUfoeiscgw@mail.gmail.com>
 <20200301185244.zkofjus6xtgkx4s3@wittgenstein> <CAG48ez3mnYc84iFCA25-rbJdSBi3jh9hkp569XZTbFc_9WYbZw@mail.gmail.com>
 <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74zmfc9.fsf@x220.int.ebiederm.org> <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k142lpfz.fsf@x220.int.ebiederm.org> <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org> <CAG48ez0iXMD0mduKWHG6GZZoR+s2jXy776zwiRd+tFADCEiBEw@mail.gmail.com>
 <AM6PR03MB5170BD130F15CE1909F59B55E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <CAG48ez1jj_J3PtENWvu8piFGsik6RvuyD38ie48TYr2k1Rbf3A@mail.gmail.com> <5e5d45a3.1c69fb81.f99ac.0806@mx.google.com>
In-Reply-To: <5e5d45a3.1c69fb81.f99ac.0806@mx.google.com>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 2 Mar 2020 19:08:29 +0100
Message-ID: <CAG48ez0zfutdReRCP38+F2O=LMU11FUQAG59YkaKZY8AJNxSGQ@mail.gmail.com>
Subject: Re: [PATCHv2] exec: Fix a deadlock in ptrace
To:     Christian Brauner <christian@brauner.io>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 2, 2020 at 6:43 PM <christian@brauner.io> wrote:
> On March 2, 2020 6:37:27 PM GMT+01:00, Jann Horn <jannh@google.com> wrote:
> >On Mon, Mar 2, 2020 at 6:01 PM Bernd Edlinger
> ><bernd.edlinger@hotmail.de> wrote:
> >> On 3/2/20 5:43 PM, Jann Horn wrote:
> >> > On Mon, Mar 2, 2020 at 5:19 PM Eric W. Biederman
> ><ebiederm@xmission.com> wrote:
[...]
> >> >> I am 99% convinced that the fix is to move cred_guard_mutex down.
> >> >
> >> > "move cred_guard_mutex down" as in "take it once we've already set
> >up
> >> > the new process, past the point of no return"?
> >> >
> >> >> Then right after we take cred_guard_mutex do:
> >> >>         if (ptraced) {
> >> >>                 use_original_creds();
> >> >>         }
> >> >>
> >> >> And call it a day.
> >> >>
> >> >> The details suck but I am 99% certain that would solve everyones
> >> >> problems, and not be too bad to audit either.
> >> >
> >> > Ah, hmm, that sounds like it'll work fine at least when no LSMs are
> >involved.
> >> >
> >> > SELinux normally doesn't do the execution-degrading thing, it just
> >> > blocks the execution completely - see their
> >selinux_bprm_set_creds()
> >> > hook. So I think they'd still need to set some state on the task
> >that
> >> > says "we're currently in the middle of an execution where the
> >target
> >> > task will run in context X", and then check against that in the
> >> > ptrace_may_access hook. Or I suppose they could just kill the task
> >> > near the end of execve, although that'd be kinda ugly.
> >> >
> >>
> >> We have current->in_execve for that, right?
> >> I think when the cred_guard_mutex is taken only in the critical
> >section,
> >> then PTRACE_ATTACH could take the guard_mutex, and look at
> >current->in_execve,
> >> and just return -EAGAIN in that case, right, everybody happy :)
> >
> >It's probably going to mean that things like strace will just randomly
> >fail to attach to processes if they happen to be in the middle of
> >execve... but I guess that works?
>
> That sounds like an acceptable outcome.
> We can at least risk it and if we regress
> revert or come up with the more complex
> solution suggested in another mail here?

Yeah, sounds reasonable, I guess.
