Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4254213E1
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 18:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbhJDQU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 12:20:59 -0400
Received: from sonic307-15.consmr.mail.ne1.yahoo.com ([66.163.190.38]:36015
        "EHLO sonic307-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236732AbhJDQU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 12:20:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633364348; bh=mY7WN61pldcW5w9M+Qq0QbpFbxJpAORC0hm78GtixUY=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=awzUlRwuRvU8ZaC+IxNKjo2uaT9qBom3JlFeXBqaEBYzXCigALfbzOPIRbGj9G4QCrtutuLYesg7wJCN55JZ8rBGsCMR76tMIJf4pr0FE8lHLW3NvT1/L/IOTuyIM/e292x61hld49hZIoqWVbRs+ydazXC0twUqWQJRNGQuEGtlVPtod/DS+ZQOhXqJrpYuGhqwfXPd2zeEZZMsH05oJkmEgyWqPu4cxK3N2EnftR7BnXGP+KZk4bFGE6HxSQmpxr40rJDiPaycPuujDb8NzqddpJ09ntoue6ndvJ/g40wSjN5RsXOMYkMW25+fLQy1IRcRUdypxx/N3N3xoc5ihQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633364348; bh=IOyCt/jN1iZCaTXIb2MvAFsfFiY4NcJ6xUvOTOjgfzE=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=NRRX1CoNjzdt24zkbdU5dwx2B0LZxBFnSDSpDcWUi+3nvxAlFQMR2M/acThytn6H4fnRriZ0dWntKCQNZiaTS+T9yHADnDOPEWrq8F3vUYOIpe4hE39WOXK0TzHHu12GcNknGiRGjC/ImuvETKucEeUGvU38bPlWRn82uhTrzWvGhqQ3lSPwQ0VeTZyaRgYfMVwJp+Pqs0R5XxS396upgk12/VfCWrKu5slmH6MBscZJacwDDZaKGAerneAeOMCITy/aSGbhubdoj+NsadLABgp3OAaPJm7heo3PmQq0mdsZrEcRAN4DMfDZ4ioyhzeABIK2QLUhdaFj2a3+Y5V7Lw==
X-YMail-OSG: _YNEJFkVM1nLkTKq0WW1nyHy3k1soK5D6P.ap7q9A9gzAgbb1Zhu7Rd4A.xp2an
 c5I15VhYweUie8GFh4hEVeIdYUJnAm8NriYarnm9O.9Asxmu9qVtQrA0P4QoP2nWBaumkcsfSqEN
 Gw1rkL8oqhanK9CTOvQw5ElCT_kFje3ZJvr51_5gHUVL_kN0kfYdDr_NoCxkHiMCj7kjF7aRg5VR
 IOb5FxgoJCwY81nOcTjXH8IC9I_Z_UzMFa_jdf..r62xmwZv4JvgleWv8d6B_kKSJKKmM0uk4yg.
 2c.deQ8Zx.zbqjJDC4o2_GjZMmSmXo27jN.W.0rmd.nBWSGXGorWDMvXr7AliqMyZjLHSdlRnbSk
 6dqtQVQOtG_jMHUuN1t6nx9Xi3oJ8ubEpAs8u76JpPrRQ3hqHj8gvGMF3.KPes8YUj.OEuaAZ8m0
 qGEm9ycst_Yeso9Ro0DntLAYjy4zT__jUIducYgV3M2soyfOE51xuXWY_18EHU3DVxd29dYURwy1
 xXKmVmQp7VndsnDFWm_6RMQciLQ1U8s8jtmubue1Dkb40AHwobJ1MqyXYqwLnQprgpG0tsgjNe0L
 PH9AefYMFHrzFByCUEMiyCKMkMCJRUXPI_fGmIZzlh0on0eY0ATEgKLnX6imN.7F.rQjSAvqaftC
 PKcKNgm_E5YpL5ywFYSSN8obokAToFLKoen0aKj4TWnNirBb3.UhiaIyfhFUWyZRmc.A20pqONoM
 MRnaGvTdmBMf2mYpzyuxtQNnQkZT.V4rstaNJPdO0AAsSHKz8coRPczYVOwEEMPLj18CswKYDmXH
 Nr.5.rf1ERxuND9bmkdrPMZMaFZzwoxc_947.67IiL9xL8C1iVird6lpi6hSBjawuYwGYPWa4dXJ
 w0s2ir67Ax.2hONwoZ18aBU_mR1KROph4klDQFP8NCQ7.3wPnYJ4_eETWN6M1c0xsLtY2V.KvgIs
 l.iL0.lQsoJd7IBA8geMcI9ak1_2gUs0mcMmAr0lN7pq4bpHRQoMVyaqH5ohwDRYD2FqIKFhaIIg
 L5m7UzkW_Wjpn7veIp3gRmhAw.tycRepbYimTFPOUN.OBVT156eTNnsAqIkELjUHz2aAWQFVtEqb
 m1MoWtm6q4MDeFq6MODPnc6v9Dvz5sR08GZ9vJD38_D5XWiPZaSH.YELp3WYT4lbfLqQKdfinLWs
 GQrDVyCLFcq3y048SiasLdjnBrxu5RA9TvthjCGCfS.CjiMkGLHgXj_QbcZD1MlkZzqdOFw7u.XL
 a81ApPoHUP9zclWfImy2kitcdRA8UcEYEl2CoayCg.L3J4ckBjq_hptLeukUkxnbbdco9PnJET3v
 GvFGnQE3XNhiNwFwIpQsRZboBh_EdQBMtxF7Q7zc2TFaEI_8C9.dbmHJpcJjw_.7VSoDnxJUQbBu
 96kG5QncOhCMq08fR9eG2.WWVq2_lIwUymt.orYVgHjRtm1rcgQjoiCzA3DzGB_uB5Vz2ro8Douc
 VPOdk3jBr9VJKpe4A1aXYFs3tDpdlYAuGsil0Wqa.d4sorlQWWxhWM1O.V05tbGJfReaBHmDslE3
 scXnJ.0yTnESd7HOpa9GVhMWuFznQY0eiYLxSeP2cfGF6N.GzVEbXUaenWOSPIE21JdVf04.akCe
 d_oTRCfx.VNQsslRAQaUXwIEo6ukX67sXfI46kgvIKFc10U7_MbnULmn6YQsh8R0JjshFm4J03rh
 u2TRZ9C4bNyYYfm9pxtsCnGdAdN3lnAtnM5XcXFpfU6j9KC7te9n9BssbleEfOcVBQDDXMeNPMwQ
 QDQRuILlodAcA0TwTZAab2xMxiq0eF9xdjrN27vIxmEMfjNtEjMFbw5Q4mhWj9i7da__p9RVhBxw
 vbMwLERCneDeuFmDfow_BAFLimSjvvCx_XHbFalJUOyhWGPw9apKTUlEw9SjCg9vle4f4RO_VWzU
 57lCJgcTWsgqTQrXmaGE1Lxi32gq.Yp1ugKvNZBVSWPi.NXLK7sn_JEIeqLImPdUrt71fXzk.sQI
 Mo22dQqO_1SxerIZZjkiUF7kZLW9wuGhWacL1U5fzEkZHHCqZ8jHMywMrDUYdiV4ohT9w1gJyBh7
 v.gUx3D8ovVaiV7AJ2AxZdCfs7pHE322O7OlbT3rGTeGjxWo4vrRK1IwUUQ8wqgo95p0m26LpTdH
 FrYJKGFZiVu2GT3JPfZVlatKjyLR82Vna_bkDS5LcNWRrJBwVWa.M2V6uJ.GYAPdm9j_8C4aUNz7
 4h1z47jEbpBLyWMHdebfzol1RjO3dytFmvnzSgUYwXk21Rm1SG_VEyrSg9ljqadDaZ363VQ9IMXk
 JshWuyXr5sfA7slk6eyPxFhkzWcZnVJTIFEx7f6wcBIs-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Mon, 4 Oct 2021 16:19:08 +0000
Received: by kubenode510.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 6372976e85edb1cbbbfc2c0ba5be9d7a;
          Mon, 04 Oct 2021 16:19:03 +0000 (UTC)
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
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <e0c1fab9-cb97-d5af-1f4b-f15b6b2097fd@schaufler-ca.com>
Date:   Mon, 4 Oct 2021 09:19:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez0yF0u=QBLVL2XrGB8r8ouQj-_aS9SScu4O4f+LhZxCDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.19076 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/1/2021 3:58 PM, Jann Horn wrote:
> On Fri, Oct 1, 2021 at 10:10 PM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
>> On 10/1/2021 12:50 PM, Jann Horn wrote:
>>> On Fri, Oct 1, 2021 at 9:36 PM Jann Horn <jannh@google.com> wrote:
>>>> On Fri, Oct 1, 2021 at 8:46 PM Casey Schaufler <casey@schaufler-ca.c=
om> wrote:
>>>>> On 10/1/2021 10:55 AM, Todd Kjos wrote:
>>>>>> Save the struct cred associated with a binder process
>>>>>> at initial open to avoid potential race conditions
>>>>>> when converting to a security ID.
>>>>>>
>>>>>> Since binder was integrated with selinux, it has passed
>>>>>> 'struct task_struct' associated with the binder_proc
>>>>>> to represent the source and target of transactions.
>>>>>> The conversion of task to SID was then done in the hook
>>>>>> implementations. It turns out that there are race conditions
>>>>>> which can result in an incorrect security context being used.
>>>>> In the LSM stacking patch set I've been posting for a while
>>>>> (on version 29 now) I use information from the task structure
>>>>> to ensure that the security information passed via the binder
>>>>> interface is agreeable to both sides. Passing the cred will
>>>>> make it impossible to do this check. The task information
>>>>> required is not appropriate to have in the cred.
>>>> Why not? Why can't you put the security identity of the task into th=
e creds?
>>> Ah, I get it now, you're concerned about different processes wanting
>>> to see security contexts formatted differently (e.g. printing the
>>> SELinux label vs printing the AppArmor label), right?
>> That is correct.
>>
>>> But still, I don't think you can pull that information from the
>>> receiving task. Maybe the easiest solution would be to also store tha=
t
>>> in the creds? Or you'd have to manually grab that information when
>>> /dev/binder is opened.
>> I'm storing the information in the task security blob because that's
>> the appropriate scope. Today the LSM hook is given both task_struct's.=

> Which is wrong, because you have no idea who the semantic "recipient
> task" is - any task that has a mapping of the binder fd can
> effectively receive transactions from it.
>
> (And the current "sender task" is also wrong, because binder looks at
> the task that opened the binder device, not the task currently
> performing the action.)

I'm confused. Are you saying that the existing binder code is
completely broken? Are you saying that neither "task" is correct?
How does passing the creds from the wrong tasks "fix" the problem?

>> It's easy to compare to make sure the tasks are compatible.
> It would be, if you actually had a pair of tasks that accurately
> represent the sender and the recipient.
>
>> Adding the
>> information to the cred would be yet another case where the scope of
>> security information is wrong.
> Can you elaborate on why you think that?

The information identifies how the task is going to display
the security "context". It isn't used in access checks.


