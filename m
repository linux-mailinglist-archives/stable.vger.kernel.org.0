Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC5142477B
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 21:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239404AbhJFTvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 15:51:33 -0400
Received: from sonic304-28.consmr.mail.ne1.yahoo.com ([66.163.191.154]:37386
        "EHLO sonic304-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239377AbhJFTvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 15:51:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633549779; bh=VIPyd54z/wzDFWl1xVw7oaW4QxmfZE80q7UQBO2XXkQ=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=osno9CndQ4zrT3gxbG8ZqHAXie5B49WcyjC5M4tBLOk7sI/vI0wjiQxk4TrQUjoxO02bCi4CYkqT9AFC+z/hB+XmKWrzkkAny1rtoV9kyYzZNaydRpn9kW18ewgfrwI8hiwFhk1ITinfswdEQqtxqfMQ19uL2k3Eu35TE13tO5szmAsilX2/mZGMJU9bDEhO8hXcDB4Yzn4hSAPd60OCLbd8FhL+lVg/CCXnJhaxM0ksGKAstqvjHJ5YvIxsW3yLk9VSatURRkxPwWSM52yXjY4oz5yUsSx22rnhNwpF4BNMOjdpBBUBOomHBKORtBX6nSP14FgTi2Ytbyay7/15Vg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633549779; bh=Ik4lcZbUqAP/9s3fSnBrMk+blCcnlusWaCTJsNi9UdO=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=S4IrT1rhgAQUVLe6UuLehAYIQY5yIMAnlMAFTLCaH8ZETNmzWKkq7AGHvfJufd4WY5gz+wjUCe7Bl7iZf/ypM5ywCPo6j3W7FB+mJaHCblgnF54wckThxL1LzFyOtS2nBy8EHfjXl0oc4QIt+U4YXpl2vyMznsEcDBVulVIZ/wdDNiGsk57YpV8MoMWnqze/6HLLh2womo+ds/9M9xlzxpw6Zy6T33QXE5N7v3yqgiXwY0iaF9yspeZFuBfraBShMs1A36xLQawSr/4mBRr12fTppG5YJVoxvzhv4VcJgOKuKM9pHRQuOnkUR74UMOaZont4LxL+hWiD5W922LnVqA==
X-YMail-OSG: y_SqfkUVM1mdnLMiXYPqcJLMjO3Q.UnyAvHtxq9nyF_UFEqN3jLPdfB0W.mkCG_
 z28gm3T7BmF1LqEel.0_ZaYyJYDzMQ3CnESL4gpNqRuRiOnXl8ZMIjZIvbbWbzU6Vp3_0Jw9V3oe
 tPRMSb7Bmv7Vp_nfI3IKUqTeqG9DLcuKPskzzdApJH9dQa0cxQxvvi1Q46LjLUla8EDakqGCNNYl
 4r6UdGQrcGFizYkt5X45idc2OegYKCYfiegOZSnOz3gVxSgAi8qyEpZ6pyrVutc6KD2FFVlhHg4C
 TAFu726k6uA65CJznvexuBp9t.whPsUWZddsgkTpxvmv9gHi.4IVnJ1Kbi4oAzBnjtUdyTh78UEn
 uU6C7sY2Qkcrkh7_oOWqIcAwt2ws05RyYV5L9HIflHcadWcO7iQibzX6FP29tHou7WNAlQjZZtCf
 3wGyeaC0Hmt5UyKZWvbFJpRK_GZIhaq.1zaX_ohL7iJ6KYlOn71rFVvmvfpoZo1RivAaovWszVap
 rvSh_R.S_P63ZOppw6oqT68NFcswEMs0NFRpiUPEGSDI.nQD7JHqrfd2KQFhJA_tfA5FKny57dRi
 L.4p4YZpNjnKCJ4gXMxImMe6e2XLkdAS2per2.8u8eEyEob.NRRb4zgI_w3Di5mAntcqifHnwpMs
 Vhe9RKp4jjhTfHfny7ak.sLbQhy3J3V7kgI0QDrfl3nJidi765.bN4LOgvGYnw2rQMr7EmdhbHTb
 fKBeMnyDs28nBVNdGcUhRV2M68MTrLmrI1mWEubyerOP6UQM_kjWVm9wSYApznFHu_QB90PjNPDp
 ggcIUEFeSJVStQcDCHicL5_FPt9RrM_hmN9lzlpvhnfitqVnVuc.ATQpAAuwZxyXZvLdZU7x2cnb
 LwI72YtMePVPdg_dHVpa0CGoWk06bV5BZEjq1aqITd9noHBRULacn.xH51hysH8J.m3TiQmpiiH8
 RWDadbnfe1mXhM5NwVerw44IxHdXwF2q50DKbLoe.UBcKoqfrNChQRiXve6agMa5OeOYLbItdx35
 8iWd9QuHAOqhMzoy8SBfO62Aoji9x4siWTjO.0PUHyXgg9srEw9spqaHYQBhnjZfmdF7j8Ok1ZN.
 Kawp0OXQSTbeCJdIq.mET9DSj2GNhHTYGkITZy7_vptAVCgGskjrEoLsnon9Z4NSHenON.iNCukU
 .BYaxQlQGj91QhSod4qMWt308xi73jk0ry2q6bc631VH1WgRL2Am.ZX3bnuBlbMMSLureA50ASYq
 vkjFI1q6YzwMJ2.T3m08fAKubRKlYZFRVYUQ0viaZNLwe_QUZ0voMEyKgGPvPFT2J14X10X_ZnKo
 2RjqofnOoUXNP.wzoC3BGaIqq7Olp1WUkqiE..AYJF7gJWfvYGQSasWUqRfZrtwWWnDEgskl58.Q
 ctbeSttHmpW6lupybgA60cnX86FurXpzG17vJRdLGjQ2_Fe2xVqC2FC5Ts9cpZ.3.dls_mMm1gvA
 n3zYLJEDb5ZqCYhzWxHLt.LoCcYkHIOuZliY3M2ZfnhXg8IqcprRCZlWayl9hNX6gboA5w2b820V
 s8.2dfa8Vl2JL9Ys8BnN1Z154qGY1HvcgchupFDcvZOgrhKizzvt7Ua3s5wwxG_vHJIybmVsTyJS
 nRS0kR.d6YBspXpbcQP.cRdl5yKNp1zoRaB0Ik_dpnweaFhB3ORb1qfr0ezjsN76lpjnud7Jey9v
 Xz1FcFnaX_cgq00CdbJ2pxCNVJxjQDfunhgm9nIRUA6IHT7sukdl0M_ab3gPf61Pm3tZhiyElcs1
 lnHgq8XwgV86RgURKz51Kf7.xYUW3upbxskiwQabrLWyMi89nVKmsqD8eOrFAyYuAZdumJOKqzNR
 3h0UlIN5W.WPU7V6MkmqeecGBSWbbDMkym8SLXO1mk5iRpVtcQZr3NzVB.IW8AjNMo8PaHJiDhCM
 6nW3I6PTasTWuUJsNQdUDSGOSAJESjRa5be_FwhmuzLNYVnsrG4CMZiven_d6jqp2tMTnM1coo2e
 cCaGb56uzaGS_iVHK3E8Nh8MBeEYALnntGN1Jv9HsRevXHebPoVizqOxyeVjhJ50bVC9_J0JIawZ
 o2.l2QieROCwGBuaRMjJasr5Aw_01EgiNGdLAuBpwxMM1YDL.1wqouTaZMFjE4CXIFchPF9aBDsD
 .SNFGxWw4tnZO3BOWhnD79NUiL.kMCYVR2DbAcvxGVSPvPuFKNPLRnPRqHoNWlk60ezR7SB6hUgT
 C9_YielVB5lRJq9e0eWLnyvw7HRRVG7315DlcvGtJ3QrqjdRCxoOkkFvCmVWmuoXCASnXe4s5u_s
 LfCcfkLKGzH4gA6RPGbWP9U6xuHDUQT5l
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Wed, 6 Oct 2021 19:49:39 +0000
Received: by kubenode550.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 1bb23e74cc4c89dc61f36dc83a60a63b;
          Wed, 06 Oct 2021 19:49:37 +0000 (UTC)
Subject: Re: [PATCH v2] binder: use cred instead of task for selinux checks
To:     Jann Horn <jannh@google.com>
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
        stable@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
References: <20211001175521.3853257-1-tkjos@google.com>
 <c6a650e4-15e4-2943-f759-0e9577784c7a@schaufler-ca.com>
 <CAG48ez2tejBUXJGf0R9qpEiauL9-ABgkds6mZTQD7sZKLMdAAQ@mail.gmail.com>
 <CAG48ez1SRau1Tnge5HVqxCFsNCizmnQLErqnC=eSeERv8jg-zQ@mail.gmail.com>
 <f59c6e9f-2892-32da-62f8-8bbeec18ee4c@schaufler-ca.com>
 <CAG48ez0yF0u=QBLVL2XrGB8r8ouQj-_aS9SScu4O4f+LhZxCDw@mail.gmail.com>
 <e0c1fab9-cb97-d5af-1f4b-f15b6b2097fd@schaufler-ca.com>
 <CAG48ez3qc+2sc6xTJQVqLTRcjCiw_Adx13KT3OvPMCjBLjZvgA@mail.gmail.com>
 <6bd2de29-b46a-1d24-4c73-9e4e0f3f6eea@schaufler-ca.com>
 <CAG48ez0RM6NGZLdEjaqU9KmaOgeFR6cSeNo50XG9oaFxC_ayYw@mail.gmail.com>
 <CAEjxPJ4X4N_zgH4oRbdkZi21mvS--ExDb_1gad09buMHshB_hQ@mail.gmail.com>
 <7ec1090d-5bd7-bd05-4f38-07b1cc993721@schaufler-ca.com>
 <CAG48ez3ZxzO3fa0T3pE0a4wQYQDvBNY=i+Nj4MtZq-QHtJdFdA@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <736d2fab-311b-f663-cc69-d1febf0d019b@schaufler-ca.com>
Date:   Wed, 6 Oct 2021 12:49:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez3ZxzO3fa0T3pE0a4wQYQDvBNY=i+Nj4MtZq-QHtJdFdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.19116 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/2021 7:27 PM, Jann Horn wrote:
> On Tue, Oct 5, 2021 at 6:59 PM Casey Schaufler <casey@schaufler-ca.com>=
 wrote:
>> On 10/5/2021 8:21 AM, Stephen Smalley wrote:
>>> On Mon, Oct 4, 2021 at 8:27 PM Jann Horn <jannh@google.com> wrote:
>>>> On Tue, Oct 5, 2021 at 1:38 AM Casey Schaufler <casey@schaufler-ca.c=
om> wrote:
>>>>> On 10/4/2021 3:28 PM, Jann Horn wrote:
>>>>>> You can't really attribute binder transactions to specific tasks t=
hat
>>>>>> are actually involved in the specific transaction, neither on the
>>>>>> sending side nor on the receiving side, because binder is built ar=
ound
>>>>>> passing data through memory mappings. Memory mappings can be acces=
sed
>>>>>> by multiple tasks, and even a task that does not currently have it=

>>>>>> mapped could e.g. map it at a later time. And on top of that you h=
ave
>>>>>> the problem that the receiving task might also go through privileg=
ed
>>>>>> execve() transitions.
>>>>> OK. I'm curious now as to why the task_struct was being passed to t=
he
>>>>> hook in the first place.
>>>> Probably because that's what most other LSM hooks looked like and th=
e
>>>> authors/reviewers of the patch didn't realize that this model doesn'=
t
>>>> really work for binder? FWIW, these hooks were added in commit
>>>> 79af73079d75 ("Add security hooks to binder and implement the hooks
>>>> for SELinux."). The commit message also just talks about "processes"=
=2E
>>> Note that in the same code path (binder_transaction), sender_euid is
>>> set from proc->tsk and security_ctx is based on proc->tsk. If we are
>>> changing the hooks to operate on the opener cred, then presumably we
>>> should be doing that for sender_euid and replace the
>>> security_task_getsecid_obj() call with security_cred_getsecid()?
>>>
>>> NB Mandatory Access Control doesn't allow uncontrolled delegation,
>>> hence typically checks against the subject credential either at
>>> delegation/transfer or use or both. That's true in other places too,
>>> e.g. file_permission, socket_sendmsg.
>> Terrific. Now I'm even less convinced that either the proposed change
>> or the existing code make sense. It's also disturbing that the change
>> log claims that the reason for the change is fix a race condition when=

>> in fact it changes the data being sent to the hook completely.
> The race it's referring to is the one between
> security_binder_transaction() (which checks for permission to send a
> transaction and checks for delegation) and
> security_task_getsecid_obj() (which tells the recipient what the
> sender's security context is). (It's a good thing Paul noticed that
> the v1 patch didn't actually change the security_task_getsecid_obj()
> call... somehow I missed that.)

It appears that I'll be better off using some other mechanism for
the recipient to identify the security module used by the sender
than the arguments to security_binder_transaction(). It's likely to
be more invasive to the binder driver, but that's the way things go.
At any rate, I'm no longer concerned about either the data type or
the source of what goes into the hook.


