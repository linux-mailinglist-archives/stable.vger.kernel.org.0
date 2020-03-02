Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D69176156
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 18:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgCBRnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 12:43:03 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53434 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgCBRnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 12:43:02 -0500
Received: by mail-wm1-f65.google.com with SMTP id f15so202341wml.3
        for <stable@vger.kernel.org>; Mon, 02 Mar 2020 09:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=message-id:from:date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc;
        bh=I9QbkrVVYHhIoSifcadeu1EkGLpO8eHQFkfllDR/K2c=;
        b=f0oD/nK5puQRTMWphzAe+fUjcl+QhqrVxCo/yA6SLJElb5NXYz9gSyZUxWwCdooL64
         EL9J2cXo3+/hyx+w009TNArcZCCZ2lAmyKO8ssx5+yngWIyAUI0rHXMm2qy5M9qUEQVY
         p88BcddFHbuYjhgn96fRgpAxgjHaSRGOtQdU0BA81I9V+CnwPR4dQFRDP93fj+JW/Cbf
         Bb1bhdKCnBU4zukfA4g4ab5SJssq/TYd/QkgYUbGPABaMxgCBhErzfKfrYri+hXVP4HR
         ZgGcaDMuaaLq1HX1ZF8eeApGXLdzfZgDWEGnb0ySJ77RCGpErepUZ1dPfgVzr2NhlJ7/
         DZAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:date:user-agent:in-reply-to
         :references:mime-version:content-transfer-encoding:subject:to:cc;
        bh=I9QbkrVVYHhIoSifcadeu1EkGLpO8eHQFkfllDR/K2c=;
        b=CYoIwjUmxb6GQksMds87aJ9bEv6bzdnRWACfYengtqKPZx9jbm8sSBMUeic7CFJr5q
         xL+OJw7L7xnurggJZrGTAyKsLU/6OS8oIqjk0Rk7enV4DMjII3gpmuWSIb1DMi7fJBje
         L+A5tF7h82dz6vpZ9QKTjwvS82rB5q7LNvY2nhwHAPGIXujbhUJ8jIiJE06ggFDpKSGI
         YVKXoTcqkUAHJvjUujKVW/YY5QDrhFVz2Y+s3yuh7366RqLEktFspYqwLKS5Oclu3cki
         jrCisgdvL4/8oZCmSawt9xpDdrP7Wt8dGEtKVaSOllNbYfQ3dr8VnSjvs8YsSDZ8l0Jx
         vzPw==
X-Gm-Message-State: ANhLgQ2QICE768L4232GRtF8eb+xbaWNdJJhC8TPnXuESDHY+QjnGa1u
        Ls9rBXX0ppevMhvpTtEpWvPSbg==
X-Google-Smtp-Source: ADFU+vuS7wyTTj+q9BrEadAA7WBI95PRV87TDlze0qES8p6CzMOXqclt96Kjx7Zix17kmY7TxiR3Fw==
X-Received: by 2002:a1c:c2c5:: with SMTP id s188mr186830wmf.162.1583170980356;
        Mon, 02 Mar 2020 09:43:00 -0800 (PST)
Received: from Google-Pixel-3a.fritz.box (ip5f5bf7ec.dynamic.kabel-deutschland.de. [95.91.247.236])
        by smtp.gmail.com with ESMTPSA id z19sm120954wmi.43.2020.03.02.09.42.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 09:42:59 -0800 (PST)
Message-ID: <5e5d45a3.1c69fb81.f99ac.0806@mx.google.com>
From:   christian@brauner.io
Date:   Mon, 02 Mar 2020 18:42:57 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <CAG48ez1jj_J3PtENWvu8piFGsik6RvuyD38ie48TYr2k1Rbf3A@mail.gmail.com>
References: <AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com> <CAG48ez3QHVpMJ9Rb_Q4LEE6uAqQJeS1Myu82U=fgvUfoeiscgw@mail.gmail.com> <20200301185244.zkofjus6xtgkx4s3@wittgenstein> <CAG48ez3mnYc84iFCA25-rbJdSBi3jh9hkp569XZTbFc_9WYbZw@mail.gmail.com> <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com> <87a74zmfc9.fsf@x220.int.ebiederm.org> <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com> <87k142lpfz.fsf@x220.int.ebiederm.org> <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com> <875zfmloir.fsf@x220.int.ebiederm.org> <CAG48ez0iXMD0mduKWHG6GZZoR+s2jXy776zwiRd+tFADCEiBEw@mail.gmail.com> <AM6PR03MB5170BD130F15CE1909F59B55E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com> <CAG48ez1jj_J3PtENWvu8piFGsik6RvuyD38ie48TYr2k1Rbf3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCHv2] exec: Fix a deadlock in ptrace
To:     Jann Horn <jannh@google.com>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>
CC:     "Eric W. Biederman" <ebiederm@xmission.com>,
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
        "Dmitry V. Levin" <ldv@altlinux.org>, linux-doc@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

<linux-doc@vger.kernel.org>,"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,"linux-mm@kvack.org" <linux-mm@kvack.org>,"stable@vger.kernel.org" <stable@vger.kernel.org>,linux-security-module <linux-security-module@vger.kernel.org>
From: Christian Brauner <christian.brauner@ubuntu.com>
Message-ID: <9C3BF644-0F82-48C9-9116-8554204FB57D@ubuntu.com>

On March 2, 2020 6:37:27 PM GMT+01:00, Jann Horn <jannh@google=2Ecom> wrote=
:
>On Mon, Mar 2, 2020 at 6:01 PM Bernd Edlinger
><bernd=2Eedlinger@hotmail=2Ede> wrote:
>> On 3/2/20 5:43 PM, Jann Horn wrote:
>> > On Mon, Mar 2, 2020 at 5:19 PM Eric W=2E Biederman
><ebiederm@xmission=2Ecom> wrote:
>> >>
>> >> Bernd Edlinger <bernd=2Eedlinger@hotmail=2Ede> writes:
>> >>
>> >>> On 3/2/20 4:57 PM, Eric W=2E Biederman wrote:
>> >>>> Bernd Edlinger <bernd=2Eedlinger@hotmail=2Ede> writes:
>> >>>>
>> >>>>>
>> >>>>> I tried this with s/EACCESS/EACCES/=2E
>> >>>>>
>> >>>>> The test case in this patch is not fixed, but strace does not
>freeze,
>> >>>>> at least with my setup where it did freeze repeatable=2E
>> >>>>
>> >>>> Thanks, That is what I was aiming at=2E
>> >>>>
>> >>>> So we have one method we can pursue to fix this in practice=2E
>> >>>>
>> >>>>> That is
>> >>>>> obviously because it bypasses the cred_guard_mutex=2E  But all
>other
>> >>>>> process that access this file still freeze, and cannot be
>> >>>>> interrupted except with kill -9=2E
>> >>>>>
>> >>>>> However that smells like a denial of service, that this
>> >>>>> simple test case which can be executed by guest, creates a
>/proc/$pid/mem
>> >>>>> that freezes any process, even root, when it looks at it=2E
>> >>>>> I mean: "ln -s README /proc/$pid/mem" would be a nice bomb=2E
>> >>>>
>> >>>> Yes=2E  Your the test case in your patch a variant of the original
>> >>>> problem=2E
>> >>>>
>> >>>>
>> >>>> I have been staring at this trying to understand the
>fundamentals of the
>> >>>> original deeper problem=2E
>> >>>>
>> >>>> The current scope of cred_guard_mutex in exec is because being
>ptraced
>> >>>> causes suid exec to act differently=2E  So we need to know early
>if we are
>> >>>> ptraced=2E
>> >>>>
>> >>>
>> >>> It has a second use, that it prevents two threads entering
>execve,
>> >>> which would probably result in disaster=2E
>> >>
>> >> Exec can fail with an error code up until de_thread=2E  de_thread
>causes
>> >> exec to fail with the error code -EAGAIN for the second thread to
>get
>> >> into de_thread=2E
>> >>
>> >> So no=2E  The cred_guard_mutex is not needed for that case at all=2E
>> >>
>> >>>> If that case did not exist we could reduce the scope of the
>> >>>> cred_guard_mutex in exec to where your patch puts the
>cred_change_mutex=2E
>> >>>>
>> >>>> I am starting to think reworking how we deal with ptrace and
>exec is the
>> >>>> way to solve this problem=2E
>> >>
>> >>
>> >> I am 99% convinced that the fix is to move cred_guard_mutex down=2E
>> >
>> > "move cred_guard_mutex down" as in "take it once we've already set
>up
>> > the new process, past the point of no return"?
>> >
>> >> Then right after we take cred_guard_mutex do:
>> >>         if (ptraced) {
>> >>                 use_original_creds();
>> >>         }
>> >>
>> >> And call it a day=2E
>> >>
>> >> The details suck but I am 99% certain that would solve everyones
>> >> problems, and not be too bad to audit either=2E
>> >
>> > Ah, hmm, that sounds like it'll work fine at least when no LSMs are
>involved=2E
>> >
>> > SELinux normally doesn't do the execution-degrading thing, it just
>> > blocks the execution completely - see their
>selinux_bprm_set_creds()
>> > hook=2E So I think they'd still need to set some state on the task
>that
>> > says "we're currently in the middle of an execution where the
>target
>> > task will run in context X", and then check against that in the
>> > ptrace_may_access hook=2E Or I suppose they could just kill the task
>> > near the end of execve, although that'd be kinda ugly=2E
>> >
>>
>> We have current->in_execve for that, right?
>> I think when the cred_guard_mutex is taken only in the critical
>section,
>> then PTRACE_ATTACH could take the guard_mutex, and look at
>current->in_execve,
>> and just return -EAGAIN in that case, right, everybody happy :)
>
>It's probably going to mean that things like strace will just randomly
>fail to attach to processes if they happen to be in the middle of
>execve=2E=2E=2E but I guess that works?

That sounds like an acceptable outcome=2E
We can at least risk it and if we regress
revert or come up with the more complex
solution suggested in another mail here?
