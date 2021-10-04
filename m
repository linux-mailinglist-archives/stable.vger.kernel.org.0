Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BCF421AC0
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 01:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbhJDXjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 19:39:53 -0400
Received: from sonic307-16.consmr.mail.ne1.yahoo.com ([66.163.190.39]:43456
        "EHLO sonic307-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232875AbhJDXjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 19:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633390683; bh=nZeXrjzRtK3UU5hiJ+Ec3aHGmGIKwTyAOQoux0JGTGQ=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=mDS0KZFIB2ewEkW8nmIKOIeqUPqAcqG+O3eiUw8pYW/YjYfenUW9/OZVmAHRzyS1CLVia86wgqm0ejEePkeDrjvvl7dQwbINnbnyzJECEKXO9KNCqcPnF8ju28VFncZ8aIgCy9PXcgs3vXRFrMSYoGGeBzzNL32CW/qHKiDESbDvyIp4Ed4oMkGjX9nojIWguulUMvgzJ1GX+WAbVwSIAPZNFyPrxvmMpJHppht2jt/FdApWsfbPkvBkr2b+tFik0zLTpZKH1EKjjzoWnPJoFgnb+lfpq2HeRrKRLfa7t+5mo5MPj6lgnHPz+iYI5yjUSM9oiN6d1Mesp8sjEHY17Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633390683; bh=0oa3TICGV+ypV8PZK9n/khhIyB2XNCAUnVDhvOLy/rW=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=lg5FdxIVN3+BYNu0dF6mO9GlV/xaf9wsOzASLQKoaKQx6rtQydaeTfnK4fWv5GnojdeuTRjIdo4K3i9JsNygpka45aHx5HGbzg5W4t076Z/CGZMt6JIFqGKFSKa5QFI+mzYr1QIv4/hiQxdx5kxvX18td5C1NKOjbdipqfl/rg8RdvVQYgPD6GO1PNR0g8D6tewOKOExL25B5SxupNGlU+t08f81JZpLqvyJpx88X0n3xIvZeQLAlz2qqKLt4O4ZSaF4I0e+tn2GunB9yvaZ2biRiEY4H9qyjMnEdIJUQI3pwcfan6fki5cwIdrOo1KvehvI1Tmee/btn6+SUiqq2g==
X-YMail-OSG: xAyAB6MVM1kQjGFYeXYrFp9Y_h5jTAjOFz_uCnegniJoAQCswNBymxULtyBZIpZ
 eDpIzi7i9v3wxt_N9kIJMIzjdL2m09QFvlEs_ITUXH6LPqXKWP9SmgpE218xzYzeUdak65M.R6DB
 se5OGlDWh0Tb6KTA41J7NUzZcJXlieHLCwZ0t2lE8jFSspkZ26V4tpicv.bbb36jgTiE1UmXFJMd
 fTy7GzZvNcgRPduoO8aiRoHajCfhRxvYrqJuNSG_Do2TIlAYX03w4kDOJEY2RfUPG8BtojPJSa3g
 0NKqXwZAEmy4jxSgOgAVaNfVx9kWL8Ka.u7cf83xBQrnzlgSRBPWFOoSOYf_WrOK_8_a2TJsgtq6
 iYSPRrLLtELLIosX5_VIYsDr_edEXFPDEMJea5SQ9AscZLaXy.xXG.82RTY0dEMXR0GTrHYOz.kx
 7vvR5UuGuvmo7gfo3XwYve5xfKm7ZEq1tfEl7apjvExgInB3XhPQmhKla6n2xzNTcLoxT7m6W4Kn
 c_hqmK6wRPo1Pt0AcxkPMr30np2YHVvQ8FcRFpKbXag7r_a2brQ6lXQ7Nk7AkmcQO.S2wSOt4CzQ
 bgaqhKxA0dbvJZrMYyyGyUK3x55lsfoxDo2ZkQSw.RcKpr.e2EAmKr1yZrd3ANEBSkgEnpI6616_
 .fS91fIyp.i5xDJDmLRyKPRvhpQTeLmrp0KGwSqaakbDAhraaFpQRhDzmLhiupE0m8YxwTLfMvGx
 s45JK_2EL89wX.ahuL3b.TUjgitkCl5pcvRD0cKySm4pTpCCTgEZ3Fbn4C3.a5AE1jOrFjSxEWH1
 .SmrqSLs2al7mwVLt1b4SNxHMaA1biqFuuiLRpH2nC8qwROOEa4.9dTmYaGlPdw9PAhMK59InFgo
 3QpbzUAOSKw1ed96jknhZJmv7xNfAbfQNcZg7i3hTTDCo0kC86b3fOnaks8mJghRWGsh0gGRJ6tS
 Fbyigk8y5YQ5j7x7FtI3M4fr_vE0z4EpXQX1h5gD2Bjwh1kuVAE2PncMYnTOxRWmRidU3Oyf6fZY
 sogo_JKQEKsLTcpHdnZjyhv3tA2ihebtpsyqKwHfoY6fglGhdYSn38eVCk_.x3k8zRUL1409pMx1
 HXi8SQl6xiM.YN2kjWH6V21RDmUOxnBZ_6CChHoXfTKBzEhdXwjmXBQsAMJIPG04CK0jra.5lzp2
 rEqY4Pq6xdyEsFSdgSe2YR23Oh5BSgj79cfKHjQxF6KyIJEQhJb1U9J5GRua2PrN9tHPZSDaHBeu
 4r7jdY7gLkbkNzLtQGHEECUoY9Y42GvQh_6FqinQ59bTegOGe0uJ1_H6e4YXNdT.4CS0EM4kGE6E
 icN1S9Ij_XO0U1fAboebJFXjr4X9qcyVZ0K5QTAuyFmJjXKM9EayZzc9ZYti2lyanhYwGQeyhoKS
 s9R4iTRahPqKWdR9IrB_k6o.WBUJB1v5sIbU7apYbBTetVaVHmt5HWoFJ5nLkcOx54gVHli12FN_
 noEZLCSqf1_d.ML8nlESiuxOj1W372r8kGybvLY44XkYlY7hG4N07PMsZLha8bvSLkc98YfbjmOF
 ZQj5n1kcGR9seZz9MeacX54_jbmSKSPElAcDE1C1Lwb9vL1C0VH28tjII3Xsy5K7FqHAMsJmbFYi
 gHCtXolDXrqL51PVmIy2Ven7rgSYzuWZ_mTvWmpT5jJO9pwkYLgfLCNHnqWD1l5DqMbqGQAQbPeD
 Dl2vOypFRITj9EBgJxSY.8Uulel14QUjBDPoJi_vld1_iycH9SgXURyVCCVyKotbPb.T7p7D4n22
 5KYAOelaqhPPFOXc5l1cevf.yJVBEVxK5hzEub7F8c7NbgcnTTEldpdVGpsXDVwWYjuz2WblNaBh
 suDgLt3b5HzB6R0s8NRnXfKUwOo1ibojpkatpWwEVSsa7rtJRhujYkVZnDCLCdmaE4scNaojyKxm
 _zVM88UKcFx1_YKy7lRgOtcgYAkRjW9E3Qd1sVrOQwo21JgrbuSoggwpAR1u8aIy7cVSUSHL9SUj
 WVkUV4JS6yfNfBPAZNGE6xWHhAbkEdb5a5C3pEqD.tirAD4YPNFx7LXPftpF9NtMVngRiOOXySc7
 YWaJTrGOmltPMOZAtLY_DEGInXaBHX3dt.XqcD3jXdC79meF3QH04yfgjiwFkAdEt5_hgKHrHZ3Y
 YQEdu5a3it9_WQ0NsAZU.2sAah928oyAODcYQmoMCEf5VnWyA8iKphQyFfnAFLqD3lZ8o_WLx2_C
 hXaGIPoakqlz_IbicejT8s_8vUbiMT6VlaoUN6sAI2JiEg7H5Izfre_xDZhwB3eNIlIAIfw8KTpR
 p0l.gzD0-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Mon, 4 Oct 2021 23:38:03 +0000
Received: by kubenode513.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 6d7bcf93567d1f2ff56e26bd47a6512e;
          Mon, 04 Oct 2021 23:37:59 +0000 (UTC)
Subject: Re: [PATCH v2] binder: use cred instead of task for selinux checks
To:     Jann Horn <jannh@google.com>
Cc:     Todd Kjos <tkjos@google.com>, gregkh@linuxfoundation.org,
        arve@android.com, tkjos@android.com, maco@android.com,
        christian@brauner.io, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, keescook@chromium.org, jeffv@google.com,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        kernel-team@android.com, stable@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20211001175521.3853257-1-tkjos@google.com>
 <c6a650e4-15e4-2943-f759-0e9577784c7a@schaufler-ca.com>
 <CAG48ez2tejBUXJGf0R9qpEiauL9-ABgkds6mZTQD7sZKLMdAAQ@mail.gmail.com>
 <CAG48ez1SRau1Tnge5HVqxCFsNCizmnQLErqnC=eSeERv8jg-zQ@mail.gmail.com>
 <f59c6e9f-2892-32da-62f8-8bbeec18ee4c@schaufler-ca.com>
 <CAG48ez0yF0u=QBLVL2XrGB8r8ouQj-_aS9SScu4O4f+LhZxCDw@mail.gmail.com>
 <e0c1fab9-cb97-d5af-1f4b-f15b6b2097fd@schaufler-ca.com>
 <CAG48ez3qc+2sc6xTJQVqLTRcjCiw_Adx13KT3OvPMCjBLjZvgA@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <6bd2de29-b46a-1d24-4c73-9e4e0f3f6eea@schaufler-ca.com>
Date:   Mon, 4 Oct 2021 16:37:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez3qc+2sc6xTJQVqLTRcjCiw_Adx13KT3OvPMCjBLjZvgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.19076 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/2021 3:28 PM, Jann Horn wrote:
> On Mon, Oct 4, 2021 at 6:19 PM Casey Schaufler <casey@schaufler-ca.com>=
 wrote:
>> On 10/1/2021 3:58 PM, Jann Horn wrote:
>>> On Fri, Oct 1, 2021 at 10:10 PM Casey Schaufler <casey@schaufler-ca.c=
om> wrote:
>>>> On 10/1/2021 12:50 PM, Jann Horn wrote:
>>>>> On Fri, Oct 1, 2021 at 9:36 PM Jann Horn <jannh@google.com> wrote:
>>>>>> On Fri, Oct 1, 2021 at 8:46 PM Casey Schaufler <casey@schaufler-ca=
=2Ecom> wrote:
>>>>>>> On 10/1/2021 10:55 AM, Todd Kjos wrote:
>>>>>>>> Save the struct cred associated with a binder process
>>>>>>>> at initial open to avoid potential race conditions
>>>>>>>> when converting to a security ID.
>>>>>>>>
>>>>>>>> Since binder was integrated with selinux, it has passed
>>>>>>>> 'struct task_struct' associated with the binder_proc
>>>>>>>> to represent the source and target of transactions.
>>>>>>>> The conversion of task to SID was then done in the hook
>>>>>>>> implementations. It turns out that there are race conditions
>>>>>>>> which can result in an incorrect security context being used.
>>>>>>> In the LSM stacking patch set I've been posting for a while
>>>>>>> (on version 29 now) I use information from the task structure
>>>>>>> to ensure that the security information passed via the binder
>>>>>>> interface is agreeable to both sides. Passing the cred will
>>>>>>> make it impossible to do this check. The task information
>>>>>>> required is not appropriate to have in the cred.
>>>>>> Why not? Why can't you put the security identity of the task into =
the creds?
>>>>> Ah, I get it now, you're concerned about different processes wantin=
g
>>>>> to see security contexts formatted differently (e.g. printing the
>>>>> SELinux label vs printing the AppArmor label), right?
>>>> That is correct.
>>>>
>>>>> But still, I don't think you can pull that information from the
>>>>> receiving task. Maybe the easiest solution would be to also store t=
hat
>>>>> in the creds? Or you'd have to manually grab that information when
>>>>> /dev/binder is opened.
>>>> I'm storing the information in the task security blob because that's=

>>>> the appropriate scope. Today the LSM hook is given both task_struct'=
s.
>>> Which is wrong, because you have no idea who the semantic "recipient
>>> task" is - any task that has a mapping of the binder fd can
>>> effectively receive transactions from it.
>>>
>>> (And the current "sender task" is also wrong, because binder looks at=

>>> the task that opened the binder device, not the task currently
>>> performing the action.)
>> I'm confused. Are you saying that the existing binder code is
>> completely broken? Are you saying that neither "task" is correct?
> Yeah, basically

Well, hot biscuits and gravy!

>  - but luckily the actual impact this has is limited by
> the transitions that SELinux permits. If domain1 has no way to
> transition to domain2, then it can't abuse this bug to pretend to be
> domain2. I do have a reproducer that lets Android's "shell" domain
> send a binder transaction that appears to come from "runas", but
> luckily "runas" has no interesting privileges with regards to binder,
> so that's not exploitable.

You're counting on the peculiarities of the SELinux policy you're
assuming is used to mask the fact that the hook isn't really doing
what it is supposed to?  Ouch.

>> How does passing the creds from the wrong tasks "fix" the problem?
> This patch is not passing the creds from the "wrong" tasks at all. It
> relies on the basic idea that when a security context opens a
> resource, and then hands that resource to another context for
> read/write operations, then you can effectively treat this as a
> delegation of privileges from the original opener, and perform access
> checks against the credentials using which the resource was opened.

OK. I can understand that without endorsing it.

> In particular, we already have those semantics in the core kernel for
> ->read() and ->write() VFS operations - they are *not allowed* to look
> at the credentials of the caller, and if they want to make security
> checks, they have to instead check against file->f_cred, which are the
> credentials using which the file was originally opened. (Yes, some
> places still get that wrong.) Passing a file descriptor to another
> task is a delegation of access, and the other task can then call
> syscalls like read() / write() / mmap() on the file descriptor without
> needing to have any access to the underlying file.

A mechanism sufficiently entrenched.

> You can't really attribute binder transactions to specific tasks that
> are actually involved in the specific transaction, neither on the
> sending side nor on the receiving side, because binder is built around
> passing data through memory mappings. Memory mappings can be accessed
> by multiple tasks, and even a task that does not currently have it
> mapped could e.g. map it at a later time. And on top of that you have
> the problem that the receiving task might also go through privileged
> execve() transitions.

OK. I'm curious now as to why the task_struct was being passed to the
hook in the first place. And about where you are getting the cred from
if not a task.

>>>> It's easy to compare to make sure the tasks are compatible.
>>> It would be, if you actually had a pair of tasks that accurately
>>> represent the sender and the recipient.
>>>
>>>> Adding the
>>>> information to the cred would be yet another case where the scope of=

>>>> security information is wrong.
>>> Can you elaborate on why you think that?
>> The information identifies how the task is going to display
>> the security "context". It isn't used in access checks.
> But it is data that AFAICS needs to be preserved in the same places
> where the creds need to be preserved, and it is also related to
> security labels, so isn't "struct cred" a logical place to stuff it
> anyway?

I am probably the only person on the planet who dislikes shared creds.
One of the things that made me happiest when I switched from UNIX
development to Linux was that it didn't have shared creds and all the
associated management. Oh well. Yes, it could go in the cred.

But that raises another question. Where are the creds coming from?
Is it even rational to make access decisions based on them? You've
explained how SELinux ends up with an Uncle Bob, but that's doesn't
leave me confident that another security module would be able to
come up with something sensible.=20

At this point I'm really looking for something that I can put in
the change log explaining why creds work and task_structs don't.


