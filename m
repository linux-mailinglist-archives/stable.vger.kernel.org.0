Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5596B41F62A
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 22:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhJAUMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 16:12:32 -0400
Received: from sonic312-30.consmr.mail.ne1.yahoo.com ([66.163.191.211]:40331
        "EHLO sonic312-30.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229531AbhJAUMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 16:12:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633119047; bh=NbT4aX25UmGTs2KNlzFwLzW3coF+0tN96OB3Ln3hMT8=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=atfU4ZG0n6tHKcdBbfw0Z2/BP+jBZdiAUK4xgk9afn4iQI5I+hcOKk8kXLgYUXDMVLMh9e3EgM58ZG2wUaRjmI4Vk0RQwjZl0mg6lxsQj1TKUCWn3KZNlq6GwB5ks7MvIw8dbRFjviJey/v6w4XhJr0XlZf2d/6Kj6laVP2RwhjQH2dqF0ZOMBkZ+XbEyxysAR0mIDwwEowSp8oyR3weBKrHkEtWrcw8ziGAD1uZIiwsMhEUrV5EzTZATXHAObEs6ewspXHC6Mv/tBOPCZ4NaZq5JQCqa9nqhcMyyxz1s24MMlqX6ZqAZl7Q+7npvAYgoypAk+q+gzNHS4fDWXrlBg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633119047; bh=PEkVZrQuv7WZzf1LAupJbkpa/GBeGywPyZaViQ8ityL=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=KUc62KEcUl6arxcV6rX9wqdi/1MkzmL+xl/ro2u7nEV7JrO/UjwYhWioxFc1aQfKCCsQU//XpAQ+Cxlvzpi7Y2/haU2+ryO6d7Z3O21hyMecKqQKmULnwpMOEFVLYf9IPQDNR6Bar/ghc7wTLLDrjNI522mrd361COmQwt7ksZ3cCos1wfgLQ7JxEZcxPK6U8FjJGk/aMMwis38pmx6E3PyN1Q+okKUaABTxbTuVcjv8yfBOq+EXPC6UzrsiihT4HKZKk0jIVxcImAOCKpc+Pk7P+7dA/WP7Z2R9G3NxjVvxjC1/o971tcsNaQ2K9sQWS6PjnZZBgybIjhRpg2q+BA==
X-YMail-OSG: eh59I_wVM1nsdcwCDSrdgVVoCU3LoobWIGmq3Ebn35RfEeqtfrXooYgYeo80imt
 A7cAHfqH9FtlEWUc9rWriaaEmJPYOxmT7hstkMDQnbWBb0Ts._dozPfyMWuFHZBrPmnOY9pBYyIn
 yANGiXRb9LNaW1y0vcA35wLa0lK7iCR6S9hbfjC1OxdQWNjcpJxefuzP49rgbMdKUKVoh_gCNvjK
 LGLKXesamcOrUUyjd3xal8H0qRlQ3qkBAIXkEZb3vPkFgXna8Mu17n7eeyPlg7fpkgl.dpFEay3d
 v3utmwVn6olFYQMRAexN8KUWrhczVQQ9tdKmOkBY95DLN0FHArvpGrHCGC.cj0ohaKnMxcUzTmJd
 m.bcL3b3ageCkK7ceZyFfDeppWHA9HgYpbX.AsIT3UE7g4AFdW7Bwqf_ZxyGuRMwAX1l5GTqZw2G
 hPTcChTgYo7GbFYY5Q8TZy3dNknwT9PdQ2tZimd0HPjKWnroxtblYCssqHijioiQLnAHyjmyzX_5
 VM8JqlAPFYtfWKDc1jp61k4H33osQcjCOfeq7GmY4FiCuVCJc9OABy82kbBCY6xxv.7kd87doJ62
 DLV_MbZKjnUT7p13XK4QCk5vBHxRjhlluKtYk3Bw2Op66uky2tLBH0dU7GmHjPUKmhqkz5Stxfu2
 DHAfXgbBW4eUY_VZ.2WQceFAZNLkO1Ahn6xo7InFtZXDG3OjVJw0m0AwryyL_LdoXdzwtgYF0ms_
 5VvyU4pyyUFh2Z0zR10m8HBfEIf.93bxvuhKUMB2M_dlxEQt3zBg1UYtiAjK6Y5DTZ8Vz.DI9Uii
 GSn98GJzdEQhqduAsaTFZz0JZxQapiq.vBdZ661leWV6jTqdFptM4wjJtcwiZzWb86gZC2NV03fY
 2Z__UH.hGOrmnjWigrEn852SVdAKwquv2XCbvWfQcR5GWzUuyIr3dwgGYaMaqGysqAF9fOTA0yJW
 W9Ir21O45CTAX3DxEPOXwiB6QNimKsIHuihqlh6qLdM5CHUlpReRVR4y2TCYrwa3gmr3zd7Utwzy
 mV5iyb6rHgz4W7wt2WEb9AQzOEteTlSUiMHomLTN2YH7HZ9L6vNIZVKJ9v7xTcXvT6zKrrxz8eNO
 YPlM0I7ZtiDVg7LpIcjTmfIPKLtfR77WPwlnQkogRq8vdBhijhs1RDLEadH6TdhL2h0VsfykCjOa
 kfNXfFr1sYU_l3FYRG_zNDcVDqYwsfGLc0SNgJT9BJio.bjVqTKLRxIU4fJgcOpGWJ28nXBxTwCZ
 IIeIS9s4IomfDgIm9bx_sAsrx2QlK0yjVaFJe9kkxJXDWoxjZ8kMeUsTPPX3lVJmxWzoP4vepNRU
 klQU.K15P6hoHomUKRMrMQpfQddflR9HE7qd915N0ttowwN57BBUE2.OMYP4mCjXsAHjgcoQ5Kg1
 xWDj5Vk2dGm873Ij6gw.IZOQ4qr1eRvPlqJuL7a_iBJi1mHccoBEgpMsmGSvc1KKZD_mLoxE6nRo
 0yvb6I14nLzsfbjE.foAdTOhyxbbYQFXaeO2IW18VueexwjrAiRe1QX83Xjb8.Mt_paHgOnVUO14
 Zb5hwxHlBCF7Ibek1QG3b6VEP6DFsXuHlEeilrAwJTr1sH5MS0C2.saH4tRoKJ0kN.pI8OFo.emr
 91m3XQv8MDRbCmSTO.VVgvns_YiSftPuSC2sP2RdABxSXY1s3W_tQMHxd9UTgPJ6SAKg3ljFN2TR
 MAVdnZzCbY.G4mTIwF_COXg6.JqMipsHCjvtU61_P5BgCTsqu4hDm3cHRVjsDbzzUfhhwLYL3Cfd
 ZUQnR9a9q.cQkez6lMe2rbpAIfkptUKkwKRLsvN1gfaZ3HvShzAbbrke0D6hmlZwoZMFkDZQZCHB
 GN.9HxgcxVTXpLd2QWArEFFe8VDHO4bsf8iI.LRQr7JAG0YKcSklZIu.IqMmEOJoBn8pvaPXGRNA
 R5IL4OE4SD2BO_HZZ0yhyebkFWi8qb0kaDKs4NmQuw3MXvY6SVXhpwCOLtkFFuEZJesLWjPXE9UW
 _JFrcuTV.HlX.xO4Uj9bL7cNCpz0r1m.CemWoTrKL7Bv_9y.Lhv575.w0BjZj4bjFeGuDJcN0U14
 XlinUW4YAiWsVYBMLIeNPqa9_HoEDuLqEL.1XZrayaLZJGC7ypA1WFfsgnCUXUf1ahpBM8bK6Lb4
 nBjGJd33wdVhymd3LHvjmwLjqSNSzzO2oLWwtxJ.b3xutgRu6Qqbk8pKFeK3DEfnMulwwj08Zhv8
 HcN9tp2J_aixf4.4qjX7lPpUV37Umik7RtKz72CA64j2LwPv51yd6GJ_fCOpHJjcXd4EIYnVotEe
 49S4H5Jqf4PL3No5j_g--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Fri, 1 Oct 2021 20:10:47 +0000
Received: by kubenode522.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID a0d506d20189faf2f9edc4021f88dbe6;
          Fri, 01 Oct 2021 20:10:42 +0000 (UTC)
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
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <f59c6e9f-2892-32da-62f8-8bbeec18ee4c@schaufler-ca.com>
Date:   Fri, 1 Oct 2021 13:10:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez1SRau1Tnge5HVqxCFsNCizmnQLErqnC=eSeERv8jg-zQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.19076 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/1/2021 12:50 PM, Jann Horn wrote:
> On Fri, Oct 1, 2021 at 9:36 PM Jann Horn <jannh@google.com> wrote:
>> On Fri, Oct 1, 2021 at 8:46 PM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
>>> On 10/1/2021 10:55 AM, Todd Kjos wrote:
>>>> Save the struct cred associated with a binder process
>>>> at initial open to avoid potential race conditions
>>>> when converting to a security ID.
>>>>
>>>> Since binder was integrated with selinux, it has passed
>>>> 'struct task_struct' associated with the binder_proc
>>>> to represent the source and target of transactions.
>>>> The conversion of task to SID was then done in the hook
>>>> implementations. It turns out that there are race conditions
>>>> which can result in an incorrect security context being used.
>>> In the LSM stacking patch set I've been posting for a while
>>> (on version 29 now) I use information from the task structure
>>> to ensure that the security information passed via the binder
>>> interface is agreeable to both sides. Passing the cred will
>>> make it impossible to do this check. The task information
>>> required is not appropriate to have in the cred.
>> Why not? Why can't you put the security identity of the task into the =
creds?
> Ah, I get it now, you're concerned about different processes wanting
> to see security contexts formatted differently (e.g. printing the
> SELinux label vs printing the AppArmor label), right?

That is correct.

> But still, I don't think you can pull that information from the
> receiving task. Maybe the easiest solution would be to also store that
> in the creds? Or you'd have to manually grab that information when
> /dev/binder is opened.

I'm storing the information in the task security blob because that's
the appropriate scope. Today the LSM hook is given both task_struct's.
It's easy to compare to make sure the tasks are compatible. Adding the
information to the cred would be yet another case where the scope of
security information is wrong.=20


