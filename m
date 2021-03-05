Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0813432F420
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 20:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhCETlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 14:41:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23029 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229768AbhCETlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 14:41:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614973271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rIyScA6Mo4EmL+2XyKsh9B4ovscCNZHcZ56Sz7w7WWU=;
        b=DqZiwEpfhXuez59jQlceoQtLGU3jhlWqgwPgSaD4NirWBufrlpd+uL0aScmUgyBLHQEUBB
        +Ax2KYA3MF2qEReLdXFw5BqhN1KVK8koP2TWeuJCpAhjIFr7vL9tvDo4tH8pCBzKK2CKeA
        mZ4OIxf5Nmwrsj1yPCOaVwY6Xt11XZ8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-RDh-5cVAN5iISlZmbyOmsg-1; Fri, 05 Mar 2021 14:41:08 -0500
X-MC-Unique: RDh-5cVAN5iISlZmbyOmsg-1
Received: by mail-wm1-f71.google.com with SMTP id a63so746150wmd.8
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 11:41:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=rIyScA6Mo4EmL+2XyKsh9B4ovscCNZHcZ56Sz7w7WWU=;
        b=JxJjO1LG1eLOb9FnHqzjTuA1QMfD0Zbx9fDQAixmMBVdXr6i8NFFLdUocJJyd0FBFa
         owPxOTinK9VfQS5Ojx/mwj8e+0ejAIDLXFfy7E9EYhKbcehjUHGXyxyM6vWEdhXObz3K
         SyeyV+OySGSmo73vcXzjcFkIJSDUYwel9TCl7riu3BVkxbvFvPO16a8v/RWHc/d7ZnsM
         MffSLbzE2PdkWjTuWrFr9CTXdB7k+ZLBtqtajM/5PddErRcMTguWmyIgn6EYlu8SCq/L
         jpVZD2t85wKQtTp7iw2ardmdh6EYKP7K1WsKofyIT+Gdn9jhkaK3doIw7WzhiNbWyLlL
         HL/g==
X-Gm-Message-State: AOAM530aUCz0jLRBcNIjz/HPfPTbAA8HPQ9vLuC8eh1M8EsNZgW8IMx7
        C9ctqyiGpy2Aol4X2W9/CWe9F5VCcgTQy+cy7nRwQzUMe5Skxoe1KJSX8+ie6WnrMZunGR95lBr
        YWrbUW126AV3CQu0P
X-Received: by 2002:adf:ebcb:: with SMTP id v11mr10763996wrn.231.1614973267346;
        Fri, 05 Mar 2021 11:41:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzqDcoG6FcwCmOVbjwrPRYQFV7JxlxpioxDFxV9pX+oshrNklhdZBtTvpbW2VEu4S4Eb2JV7w==
X-Received: by 2002:adf:ebcb:: with SMTP id v11mr10763976wrn.231.1614973267004;
        Fri, 05 Mar 2021 11:41:07 -0800 (PST)
Received: from [192.168.3.108] (p5b0c6b97.dip0.t-ipconnect.de. [91.12.107.151])
        by smtp.gmail.com with ESMTPSA id m11sm5693156wrz.40.2021.03.05.11.41.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 11:41:06 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v3 1/1] mm/madvise: replace ptrace attach requirement for process_madvise
Date:   Fri, 5 Mar 2021 20:41:04 +0100
Message-Id: <245612A8-56DA-47D8-BB18-613FF9C8AF96@redhat.com>
References: <CAJuCfpHDtu0R6zZ0uo0YZgCE=dyhy6bsToUU2+reo3pBV0PcBg@mail.gmail.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Shakeel Butt <shakeelb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        =?utf-8?Q?Edgar_Arriaga_Garc=C3=ADa?= <edgararriaga@google.com>,
        Tim Murray <timmurray@google.com>,
        Florian Weimer <fweimer@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        James Morris <jmorris@namei.org>,
        Linux MM <linux-mm@kvack.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>
In-Reply-To: <CAJuCfpHDtu0R6zZ0uo0YZgCE=dyhy6bsToUU2+reo3pBV0PcBg@mail.gmail.com>
To:     Suren Baghdasaryan <surenb@google.com>
X-Mailer: iPhone Mail (18D52)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Am 05.03.2021 um 19:36 schrieb Suren Baghdasaryan <surenb@google.com>:
>=20
> =EF=BB=BFOn Fri, Mar 5, 2021 at 10:23 AM David Hildenbrand <david@redhat.c=
om> wrote:
>>=20
>>> On 05.03.21 19:08, Suren Baghdasaryan wrote:
>>> On Fri, Mar 5, 2021 at 9:52 AM David Hildenbrand <david@redhat.com> wrot=
e:
>>>>=20
>>>> On 05.03.21 18:45, Shakeel Butt wrote:
>>>>> On Fri, Mar 5, 2021 at 9:37 AM David Hildenbrand <david@redhat.com> wr=
ote:
>>>>>>=20
>>>>>> On 04.03.21 01:03, Shakeel Butt wrote:
>>>>>>> On Wed, Mar 3, 2021 at 3:34 PM Suren Baghdasaryan <surenb@google.com=
> wrote:
>>>>>>>>=20
>>>>>>>> On Wed, Mar 3, 2021 at 3:17 PM Shakeel Butt <shakeelb@google.com> w=
rote:
>>>>>>>>>=20
>>>>>>>>> On Wed, Mar 3, 2021 at 10:58 AM Suren Baghdasaryan <surenb@google.=
com> wrote:
>>>>>>>>>>=20
>>>>>>>>>> process_madvise currently requires ptrace attach capability.
>>>>>>>>>> PTRACE_MODE_ATTACH gives one process complete control over anothe=
r
>>>>>>>>>> process. It effectively removes the security boundary between the=

>>>>>>>>>> two processes (in one direction). Granting ptrace attach capabili=
ty
>>>>>>>>>> even to a system process is considered dangerous since it creates=
 an
>>>>>>>>>> attack surface. This severely limits the usage of this API.
>>>>>>>>>> The operations process_madvise can perform do not affect the corr=
ectness
>>>>>>>>>> of the operation of the target process; they only affect where th=
e data
>>>>>>>>>> is physically located (and therefore, how fast it can be accessed=
).
>>>>>>>>>> What we want is the ability for one process to influence another p=
rocess
>>>>>>>>>> in order to optimize performance across the entire system while l=
eaving
>>>>>>>>>> the security boundary intact.
>>>>>>>>>> Replace PTRACE_MODE_ATTACH with a combination of PTRACE_MODE_READ=

>>>>>>>>>> and CAP_SYS_NICE. PTRACE_MODE_READ to prevent leaking ASLR metada=
ta
>>>>>>>>>> and CAP_SYS_NICE for influencing process performance.
>>>>>>>>>>=20
>>>>>>>>>> Cc: stable@vger.kernel.org # 5.10+
>>>>>>>>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>>>>>>>>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>>>>>>>>> Acked-by: Minchan Kim <minchan@kernel.org>
>>>>>>>>>> Acked-by: David Rientjes <rientjes@google.com>
>>>>>>>>>> ---
>>>>>>>>>> changes in v3
>>>>>>>>>> - Added Reviewed-by: Kees Cook <keescook@chromium.org>
>>>>>>>>>> - Created man page for process_madvise per Andrew's request: http=
s://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=3Da144f45=
8bad476a3358e3a45023789cb7bb9f993
>>>>>>>>>> - cc'ed stable@vger.kernel.org # 5.10+ per Andrew's request
>>>>>>>>>> - cc'ed linux-security-module@vger.kernel.org per James Morris's r=
equest
>>>>>>>>>>=20
>>>>>>>>>>    mm/madvise.c | 13 ++++++++++++-
>>>>>>>>>>    1 file changed, 12 insertions(+), 1 deletion(-)
>>>>>>>>>>=20
>>>>>>>>>> diff --git a/mm/madvise.c b/mm/madvise.c
>>>>>>>>>> index df692d2e35d4..01fef79ac761 100644
>>>>>>>>>> --- a/mm/madvise.c
>>>>>>>>>> +++ b/mm/madvise.c
>>>>>>>>>> @@ -1198,12 +1198,22 @@ SYSCALL_DEFINE5(process_madvise, int, pid=
fd, const struct iovec __user *, vec,
>>>>>>>>>>                   goto release_task;
>>>>>>>>>>           }
>>>>>>>>>>=20
>>>>>>>>>> -       mm =3D mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
>>>>>>>>>> +       /* Require PTRACE_MODE_READ to avoid leaking ASLR metadat=
a. */
>>>>>>>>>> +       mm =3D mm_access(task, PTRACE_MODE_READ_FSCREDS);
>>>>>>>>>>           if (IS_ERR_OR_NULL(mm)) {
>>>>>>>>>>                   ret =3D IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
>>>>>>>>>>                   goto release_task;
>>>>>>>>>>           }
>>>>>>>>>>=20
>>>>>>>>>> +       /*
>>>>>>>>>> +        * Require CAP_SYS_NICE for influencing process performan=
ce. Note that
>>>>>>>>>> +        * only non-destructive hints are currently supported.
>>>>>>>>>=20
>>>>>>>>> How is non-destructive defined? Is MADV_DONTNEED non-destructive?
>>>>>>>>=20
>>>>>>>> Non-destructive in this context means the data is not lost and can b=
e
>>>>>>>> recovered. I follow the logic described in
>>>>>>>> https://lwn.net/Articles/794704/ where Minchan was introducing
>>>>>>>> MADV_COLD and MADV_PAGEOUT as non-destructive versions of MADV_FREE=

>>>>>>>> and MADV_DONTNEED. Following that logic, MADV_FREE and MADV_DONTNEE=
D
>>>>>>>> would be considered destructive hints.
>>>>>>>> Note that process_madvise_behavior_valid() allows only MADV_COLD an=
d
>>>>>>>> MADV_PAGEOUT at the moment, which are both non-destructive.
>>>>>>>>=20
>>>>>>>=20
>>>>>>> There is a plan to support MADV_DONTNEED for this syscall. Do we nee=
d
>>>>>>> to change these access checks again with that support?
>>>>>>=20
>>>>>> Eh, I absolutely don't think letting another process discard memory i=
n
>>>>>> another process' address space is a good idea. The target process can=

>>>>>> observe that easily and might even run into real issues.
>>>>>>=20
>>>>>> What's the use case?
>>>>>>=20
>>>>>=20
>>>>> Userspace oom reaper. Please look at
>>>>> https://lore.kernel.org/linux-api/20201014183943.GA1489464@google.com/=
T/
>>>>>=20
>>>>=20
>>>> Thanks, somehow I missed that (not that it really changed my opinion on=

>>>> the approach while skimming over the discussion :) will have a more
>>>> detailed look)
>>>=20
>>> The latest version of that patchset is:
>>> https://lore.kernel.org/patchwork/patch/1344419/
>>> Yeah, memory reaping is a special case when we are operating on a
>>> dying process to speed up the release of its memory. I don't know if
>>> for that particular case we need to make the checks stricter. It's a
>>> dying process anyway and the data is being destroyed. Allowing to
>>> speed up that process probably can still use CAP_SYS_NICE.
>>=20
>> I know, unrelated discussion (sorry, I don't have above thread in my
>> archive anymore due to automatic cleanups ...) , but introducing
>> MADV_DONTEED on a remote processes, having to tweak range logic because
>> we always want to apply it to the whole MM, just to speed up memory
>> reaping sounds like completely abusing madvise()/process_madvise() to me.=

>>=20
>> You want different semantics than MADV_DONTNEED. You want different
>> semantics than madvise.
>>=20
>> Simple example: mlock()ed pages in the target process. MADV_DONTNEED
>> would choke on that. For the use case of reaping, you certainly don't car=
e.
>>=20
>> I am not sure if process_madvise() is the right interface to enforce
>> discarding of all target memory.
>>=20
>>=20
>> Not to mention that MADV_FREE doesn't make any sense IMHO for memory
>> reaping ... no to mention exposing this via process_madvise().
>=20
> Yeah, that was the last comment from Christoph Hellwig on
> https://lore.kernel.org/patchwork/patch/1344418/
> I'll be rethinking the whole approach. Previously I proposed couple
> different approaches that would make reaping a part of the kill by
> adding a new flag for pidfd_send_signal:
> https://lore.kernel.org/patchwork/patch/1338196/
> https://lore.kernel.org/patchwork/patch/1060407/
> but maybe a separate syscall for reaping is indeed the right way to go...

Yeah, most likely!

>=20

