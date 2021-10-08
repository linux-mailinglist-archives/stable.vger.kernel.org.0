Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75A2427306
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 23:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243467AbhJHV1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 17:27:41 -0400
Received: from sonic313-15.consmr.mail.ne1.yahoo.com ([66.163.185.38]:46172
        "EHLO sonic313-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243459AbhJHV1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 17:27:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633728344; bh=Snt0oAS/MfGkwpmtxKgKtsWiSjFspUWMisHHBPU2yRQ=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=Ka2FFteVuAZllpHTONwjaSmXoPORBdrZ5xq43qt8h/rPvu8X1D/r1EbZUWP36XpZWqtAYojG2XR8aricMlesem9uwVpmNFZ6w5+EipD+5vmqFF6aDfr9WgarjnlVwFAkZfV5E3xNl/1qxizLYT8J6hn2DwdaC9N45N+9G9NR92n0Z/LIaALJIRwOdNgpg8tLZVAHnI0wdMGcb7DkhvRFWK7Pq90ii8JMTLZd+v6CWjp4HJvzjVB1VtT4uXN4Hehze5XSDi+LRnlnF5ZGTykSz7/cZVnZb6d5uAdpn/Xh5zqXx6uUq4TvcqkRKGWkX2hu+nfdU1nn5qhHeMNSWBUfhA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633728344; bh=nG4+d0jTj76puUpfeVDNN17Gm+xQmTCTFcVWN8RDLzL=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=oDtO1sINm+TijpV6/9lKw6n7PZV88InB7Jtl+xNMPV91cfs7jhpbq29D/muLefjXINyuoBDB16NpNRqt5lD+AUgxKF3JybZr6an8uFL1Zfl8XG4myf1U+dlfChlnV0cylHRcPX/v0N27c25MC9duO+O7yUiteNyiN7WpfPr3YGVDnNJtV9RtSibNGTjmwZmyQJb05CeGc+M7jzHtCgv9kPLsPuuzL/Seh1LiLRz+IV4bsp8GAIGNos0AKBUGuDteo4ueNsd22dRBrnX6fGGDq7rrD4xNAtifuDNXRKsQwwapXf+LFGxkRuc5HINnBgZj9yeHYla7JeRBaOH50F4rfA==
X-YMail-OSG: hcXpzk4VM1k6OX1cRScoV8arck7bzLaT1.FlsT3C6Q0x_q..kZbJcJYzoXK34lr
 5U.YzJ6.MQdniP6qfNRTzbrX7s3HYLzJBmvedcj4lwWW5Zvl0upi_CjlRA4DWSrYm_ZRgHiYXHZl
 ANyw46kwN4kNXzDCPyfeF2OZDychOo5zj5WawZxATkZRvRlnIG1uqE3YCO26ia7nEyavB948LIBA
 Q0zr7rsNg_VPW2Nm4E5GK4CUu_.OBtSFAXmtnPsK55csmL58wxSETHroMCnrhQyQAHIBWHHsDN__
 l2XlRNKjsKtvlHAlc6y7KLoCiTBpsHYw1fNHSYQHZRHtw2E7kM75NO.7n5Vn2Xdb7TBQPqdLz1go
 Z0TQkW0lOh8TabrSiovj6ZjS5T4hibVnytwJQsjGHwkQhoPOuTzgMxEHo4.olw.LEUHk962WrJ_P
 my6OEUyuFLtTDrAJOY83k4Dj7eAWYDBCO5qBrT4IbSntz0qyj.BQDA_Z0BUhpUXNEy5jnGTapo3S
 XFiTn_lBrUtWUbV33sXgJCfF5lUDDP.LWLNJqxC9Qcwp4F79eiTizB95m43iCfh0nRm_fufaMJCd
 XqK9aKIBlcDZpyoS.UFPN.do0NodFmOCQlwCTGE3xkmMOLAcOjNaHqAlZxb8qe3bMGaNq7wnc.oV
 0MFdk4lZt7SwxPhvf9BsQ4BjP.Kr_DLnLWTCcqI3Nrra46dJPXbXNPZQYtntwdWFCC3qOVEzWkqq
 Z5X5Wnt6UBE2k_WeRh1gOuL9CZJft5fDqvv168Cq1q34J2i5pAXAYnMyRclxRuVCaJX1GH7_9yxL
 qRdmlVafkW.IL4bG66NON_5eGscagXZ.J_lG.fXcQeSlwlpqvnQhHdQNUdZOlVFG3WUPiFgbw6l6
 wYlmQ2UHnXZXXd5SWcB1EeBGv10Egt_8m_hoo6eXUkzuW0QmeSThuMISffm4Jf_SaDz4AVg_tNnO
 4OLK23RrUQOnKJzsfNJjMRpwQbrxCzFpxapK6EdoHlShT4NMjqfjtmuqCPE8yJyHxv3HcJBfonV2
 dOwYC0mAn10LxnXJIRuKBKav0Itfuh4y_YRnSFuxypfv5W6QxBqeOZnS.1pE2rVb1sBxXRBbhh1v
 zLJSsMk.j8GBtXVr.JoAlB4IDojJ2Z13D66oO658LBIYjVtMIK5HJMqEaVHHvLoqXmxsuqVOuzy9
 UOfIEtU0rPNf2qVbNawvk.AzjSO21AhpIi2.bTsRev87Dg8hDtPvjEgxzwknqCdtdouOekCcuNhp
 Mb1GM605D4gWWt_APQRL3OdlhyQjeSCLrg_axWNbDAsruY2B9REdXlB1KR_WAI34683njK1U5k8e
 l3DZ52KGhsu.iv53k9pS49BXanUKyCS4XnSYKCd8E1VfpwstRCA8v2IeaiBx87ARjO.y8qcV4HIR
 O.NUPcZSlDc3b3ufyS1wZNw377Ws3WrieJ9euDCFHV_3ddkYT..3XEPzYfs0qmEUDAEn5FC7bMGh
 9BoEj_lU_i9_l9eRJ8zqgb71p64CXH5OCMV8U0X8wjmKd_RIiWV54P4i0LUZ9NoOGceMolEm7_Og
 zYwA8VYRwmQasD_cSzCakPufXMeZub9TcxHt6A7.Sr7uRLx.z0pHDS.ZnYdh7mqIz5uSxFBM08Ak
 dQKtQG7qBybMAA49QqnLw_wxbwGBm04T1vPadxZ53HlDlPzlAg.ellFymVZHZTBrvwIFU2vcFPJ8
 e5zI0qwcVzAbab2Tjg2EwK5ge57_im2EJQDM7ly554.uaFftpf30uYGa3n8obrXKkpdLqXZoP954
 GLFv9kTEko7srx7zG_iw9P5ojZXdUwJSmNlMFClWsEnocNr5Qfsovy2Pdm95wiEmrc1CyHQY7L5T
 U_hXga02OerDuKzn2VezwRjGOXoNYbl71dqhH2RhETuQ6IOT.yIKDPGlLXoz8IXTuQhXMebMUiTb
 e__xUEtK_vWE_CQlqUPOmXton8aciay.mucZVdNnxofpZGlHY0WNnE10PiCbga6WkWQ3M2JFaH_P
 D4y5vv8Mg8d6RUfNjPI_sb28Znr1M3YEO.tu.30UtjyMgroodGUSYJl97w.HBFfglj6VIdSLGR7o
 RtRH_s9PqM.BBpLLUF0BngGNvL33xy3F0UESXOzF5oB0h5kNkLXQfkI8Kz5X1IfUB2MsT0mxUcFJ
 bTMpzR30QjiAbZiamnlx2nJbM.wmn7hJQjZNRdKu4c4YWxv.oDpfNqkGc_KpjHQVKS8pbdqo7hHU
 ySL7y6CdjKA1EW7lTVQFVGiIS3GGvHWjn.SgGKF5VUAYn
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Fri, 8 Oct 2021 21:25:44 +0000
Received: by kubenode539.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID e23bb4e81f3ea750c8f215ab702bdae3;
          Fri, 08 Oct 2021 21:25:40 +0000 (UTC)
Subject: Re: [PATCH v4 3/3] binder: use euid from cred instead of using task
To:     Paul Moore <paul@paul-moore.com>, Todd Kjos <tkjos@google.com>
Cc:     gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com,
        maco@android.com, christian@brauner.io,
        James Morris <jmorris@namei.org>,
        Serge Hallyn <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, keescook@chromium.org,
        jannh@google.com, Jeffrey Vander Stoep <jeffv@google.com>,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        kernel-team@android.com, stable@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20211007004629.1113572-1-tkjos@google.com>
 <20211007004629.1113572-4-tkjos@google.com>
 <CAHC9VhTRTcZW9eyXXvAN7T=ZCQ_zwH5iBz+d0h2ntf7=XHE-Vw@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <6dd3cdff-c4eb-6457-f04c-199263acd80b@schaufler-ca.com>
Date:   Fri, 8 Oct 2021 14:25:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhTRTcZW9eyXXvAN7T=ZCQ_zwH5iBz+d0h2ntf7=XHE-Vw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.19116 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/2021 2:12 PM, Paul Moore wrote:
> On Wed, Oct 6, 2021 at 8:46 PM Todd Kjos <tkjos@google.com> wrote:
>> Set a transaction's sender_euid from the 'struct cred'
>> saved at binder_open() instead of looking up the euid
>> from the binder proc's 'struct task'. This ensures
>> the euid is associated with the security context that
>> of the task that opened binder.
>>
>> Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
>> Signed-off-by: Todd Kjos <tkjos@google.com>
>> Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
>> Cc: stable@vger.kernel.org # 4.4+
>> ---
>> v3: added this patch to series
>>
>>  drivers/android/binder.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> This is an interesting ordering of the patches.  Unless I'm missing
> something I would have expected patch 3/3 to come first, followed by
> 2/3, with patch 1/3 at the end; basically the reverse of what was
> posted here.
>
> My reading of the previous thread was that Casey has made his peace
> with these changes

Yes. I will address the stacking concerns more directly.
I am still somewhat baffled by the intent of the hook, the data
passed to it, and the SELinux policy enforcement decisions, but
that's beyond my scope.

>  so unless anyone has any objections I'll plan on
> merging 2/3 and 3/3 into selinux/stable-5.15 and merging 1/3 into
> selinux/next.
>
>> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
>> index 989afd0804ca..26382e982c5e 100644
>> --- a/drivers/android/binder.c
>> +++ b/drivers/android/binder.c
>> @@ -2711,7 +2711,7 @@ static void binder_transaction(struct binder_pro=
c *proc,
>>                 t->from =3D thread;
>>         else
>>                 t->from =3D NULL;
>> -       t->sender_euid =3D task_euid(proc->tsk);
>> +       t->sender_euid =3D proc->cred->euid;
>>         t->to_proc =3D target_proc;
>>         t->to_thread =3D target_thread;
>>         t->code =3D tr->code;
>> --
>> 2.33.0.800.g4c38ced690-goog
> --
> paul moore
> www.paul-moore.com

