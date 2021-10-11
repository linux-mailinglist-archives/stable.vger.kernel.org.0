Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88280429940
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 23:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbhJKWBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 18:01:52 -0400
Received: from sonic313-15.consmr.mail.ne1.yahoo.com ([66.163.185.38]:34557
        "EHLO sonic313-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235372AbhJKWBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 18:01:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633989590; bh=Zqhg448+kp6mEiue7M5/FNvpz96vUnZrgGFVgDvWQDQ=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=Et9ee1Csb2UNZamsi+KZ4pRLbTprSEvdYjruG+zGhpRBL0S/VFpbGIkMg3z8PhibobYmFekZ8DlpCm/u9axYfxHKphk+W/RocVMOgXm4zATIWIpYUCQEdmwwBkBTU540lPEb9Jw3iIITiovwaCBFt88na28VZSmlUvTbwi3eTZeWr7xQ3iWdi8shbqbG01P5Bh6MgoeK/toC9hIyLY8ihXKSDSxJofkZXe8dGiYuvxLgTsLlz91pG4+XKGr4E4KLiJKdPkBAd4AwphRvxMu+A8BuO49OrHXca8RxhybPLA3v5YGUGzg32YZy67lQXtUj5FnVOJavxOVlDz0ik1XF7Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633989590; bh=gCBOFNRCnbv//7buHKjtp80F2ar0lHhJO5vz1hXnyui=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=CPWvjbYrYq7iCfRzzXq+1LRR1zc1HraeIoZvoIASJ0fSmgKvDg+/tjfHBA8+26ASkd4YV7KqTr33xu+M1paQtCPPcF5FoKXp+zY09VMZRVlG0K7n3nj3vo9DEvjyIH/IrMFGK9FMl2deFzhFviD4EEx3OoW2YROT52PcTvs9zYJ9i5PCZopNvWpMnlMJk5Jel5/tIPmWC2cD/MLoDjunmVvApKrEaX0WngSEa7iK7BPTjPxfWu73xgkI7a8A/XLdCELd9UbhDiYR0/gQ10AG4RYwAyWk8C791u6q2dk3Nazfx3NWp194dumoY7mTAFH/D0vd1B4LbU9931OO3nChwg==
X-YMail-OSG: aC0JH90VM1kfDaKTkIdU2qA35lYCCxBu2otVh_5jlPvwsFge4HpFDaXmDW5vvOB
 GwrAbfYk95JHT2s.peY5piTSdcmT9U_lm97avpy2QuRQeg232Yvj3mMDUdhLtPc4n39COSGc0mXA
 SpEWvgxiBhukIU7D5LYOZ1IW7ifATJ418D.5spvthYI4iTdsJX_A8JhTOpKvLGL46FgLVPFK29to
 afKhuG9_i5hLuhPKVfigyf0c7ebxBcMF5lGT_pJES8NN_wykPN_9H7RHqhs6VDCfzYcFHxyBQlBY
 MCL_8sxRupLd_TDuiEoMOvFyxEzsUzfBnF3M9CxtMMeaDbtVadc2bWgiDeYMfvXrGdo7i4K6CnPs
 9yKe0m3YOzmVGGrKF7EpiE0lC5aM5m3ZwuBUAVKfRLiUbtt.0afW8JFkq_nBLqy6BMjzD_Nu.z4z
 Up7EvQ0z88cOrjZzfjVqeJZSSLkVO8loo8opin59vIFvJMoRgWObKmg.IzgfSmmQ4fB9gAkHmUAS
 XYhgiceXQL1oka6ysLgZWAidGXoKac8ja7PehpFWMUzqNXHfknNdUcO8f.MBFCtsVfi.PtVxc_Wk
 gyCE2V2rQIpbPTcULt_qIp9MSCkeillZ.qcXsaJxe8vRy0uEdrzXzfXYQ3ft0TiCEq3Hj93bcMLQ
 G_3eq5svQzY6utGHIac5sCV5KYqEyflwc6RbuCLLXWiIGfXtZfUj2_LGShDLWqVmQSDQ.HqTL4hK
 xdOL6zx0JbdmHiacB0FAZGV7BIkF9_aagRSxHjkSYLOcY1oHXmlcbtpbw6E16ewy7m0HQHEOzoF_
 j0hwF8qFaILSMtkVuNp1rtMC3Nq5ebOrX43moO.S73qqRRCgRwEXNnVVjufX5G12jTrT7wZqjhme
 6Kt5U29KCovNh3qqvyZVAb3Gl.Hlnqmn4ez8T3i0sI4TDcbo3w3MFS.DOfayLt3HobrosfZAsVUL
 _5sa7awUj2cUka.3xSAOctPBXFnhT_xt3mgW2lnGPxEM7s0DAfY3VuQ9Y3s1D4c9CF.riQYX3pch
 j7b4_EJDLR_NXc5951c7iaV7pQB.rmExBnVkjk1AygQ7XR4MQEmfywB0UDQnCLW0NP.9nSopLh1t
 AA7RNBPODRXPYC551LrFF7k1aH5zCKo.8GOleu_KvxA9VulVtzujEyScr6xzPjar2o1LJ8gKz98c
 xlx6qvslsSHHn6H_LCxQG6EqEkgTPdQPwKYpL3PmBq6fzS_6PidclodJdHHok1wJp5Q35Gv1EHul
 tYP62nckwEuNQa1w1NFR7CV0WH6VkSgKlCu80PnK5HsrZB0E1H919DLFpHFK7K.EHyOzpIW_FwMb
 uqzOGmM.z35liqYIz7hOMfdAYYfPlKA5_6kyLDVYX3YG_Pa_vOmFLB7jcyIkaJP.UmUC_1ERZCpN
 TmZXer7IfecorSQtCBufKfV97KYRJ6MdIYoLO4RgQ8pHU1toRGnWYC_ELrJ8i4NPoH1dA3h58gRn
 vfh5pmkbS0kwFRsZLcTAddGgceXNDipMTmtT2QCVdzxIWlGJQSmOdUwVizvoUjCIsH.K9AzZrt1R
 hwRO5HzeR.ewqXZyY1961LOfeG69sI0VAVhfGMVhuQXe66_fsyqi7fuNQ90n_fpykS285RATFuar
 GIjaWeQqtZtlVgejKB7354d_F3vHWKDEbahvr9dJG.bnwVpZXPo3k_8vaGUl_qrgG3nfBzCTRUFF
 tINgV_vwbsjh_YN3kAws4bkHGP8O2Yq0vVSHUtXhdW2Kxg7lsF0JPlu5wIESd7p8aE8p6DP0vKHy
 wZFDZjM1ttPuLzZwx1z4LYou06eLhbtdAE7x4oy9KAA26emlZic4dMHsmzprft1YKtT18U9OYbbV
 XX8ywJgOzQd9tEc.6It0nNurBrn1DeCaQZY7LA9okkv_oHDE8j4qfJbs6.yWAfM9nkUBanvdU1kt
 Xih8M.n2ArtWIf6rVCol3M0tNt5d7_NP16o60lKxQZXHykvJjjGtr4_TxZlRVGucwJgiFepVhMgr
 Q56u_fYQ8GT.ciwl.FbzivVzoBCI9H7DI1XvWkAyv8YZyT6WlQWfUI_NN3AfHlP_4_AAgcYKjaXT
 fSP8476K9iTcQFK.V2jrt3bD9hklRFUQhud5wNUgD0RpNqPLBe0KZ6Ukm2CCaOPsj9BcNCObdXGg
 rlHRPVVRmY1uDkeX6.oolgkhPHf.2T6o.Gtk1igEHCu3XwYbwD1xWtKerIWoDlSz_LyU5bo9bT.C
 8uSrQAiPf.hLyNn00JtN9oLvLwD4eJ6UqJA8c
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Mon, 11 Oct 2021 21:59:50 +0000
Received: by kubenode517.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 3ba437dd57240fce1e91852cfbdd0152;
          Mon, 11 Oct 2021 21:59:14 +0000 (UTC)
Subject: Re: [PATCH v4 2/3] binder: use cred instead of task for getsecid
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
        kernel-team@android.com, kernel test robot <lkp@intel.com>,
        stable@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
References: <20211007004629.1113572-1-tkjos@google.com>
 <20211007004629.1113572-3-tkjos@google.com>
 <CAHC9VhSDnwapGk6Pvn5iuKv0zCtZSbfnGAkZwKcxVYLVRH6CLg@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <8c07f9b7-58b8-18b5-84f8-9b6c78acb08b@schaufler-ca.com>
Date:   Mon, 11 Oct 2021 14:59:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhSDnwapGk6Pvn5iuKv0zCtZSbfnGAkZwKcxVYLVRH6CLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.19116 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/11/2021 2:33 PM, Paul Moore wrote:
> On Wed, Oct 6, 2021 at 8:46 PM Todd Kjos <tkjos@google.com> wrote:
>> Use the 'struct cred' saved at binder_open() to lookup
>> the security ID via security_cred_getsecid(). This
>> ensures that the security context that opened binder
>> is the one used to generate the secctx.
>>
>> Fixes: ec74136ded79 ("binder: create node flag to request sender's
>> security context")
>> Signed-off-by: Todd Kjos <tkjos@google.com>
>> Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Cc: stable@vger.kernel.org # 5.4+
>> ---
>> v3: added this patch to series
>> v4: fix build-break for !CONFIG_SECURITY
>>
>>  drivers/android/binder.c | 11 +----------
>>  include/linux/security.h |  4 ++++
>>  2 files changed, 5 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
>> index ca599ebdea4a..989afd0804ca 100644
>> --- a/drivers/android/binder.c
>> +++ b/drivers/android/binder.c
>> @@ -2722,16 +2722,7 @@ static void binder_transaction(struct binder_proc *proc,
>>                 u32 secid;
>>                 size_t added_size;
>>
>> -               /*
>> -                * Arguably this should be the task's subjective LSM secid but
>> -                * we can't reliably access the subjective creds of a task
>> -                * other than our own so we must use the objective creds, which
>> -                * are safe to access.  The downside is that if a task is
>> -                * temporarily overriding it's creds it will not be reflected
>> -                * here; however, it isn't clear that binder would handle that
>> -                * case well anyway.
>> -                */
>> -               security_task_getsecid_obj(proc->tsk, &secid);
>> +               security_cred_getsecid(proc->cred, &secid);
>>                 ret = security_secid_to_secctx(secid, &secctx, &secctx_sz);
>>                 if (ret) {
>>                         return_error = BR_FAILED_REPLY;
>> diff --git a/include/linux/security.h b/include/linux/security.h
>> index 6344d3362df7..f02cc0211b10 100644
>> --- a/include/linux/security.h
>> +++ b/include/linux/security.h
>> @@ -1041,6 +1041,10 @@ static inline void security_transfer_creds(struct cred *new,
>>  {
>>  }
>>
>> +static inline void security_cred_getsecid(const struct cred *c, u32 *secid)
>> +{
>> +}
> Since security_cred_getsecid() doesn't return an error code we should
> probably set the secid to 0 in this case, for example:
>
>   static inline void security_cred_getsecid(...)
>   {
>     *secid = 0;
>   }

If CONFIG_SECURITY is unset there shouldn't be any case where
the secid value is ever used for anything. Are you suggesting that
it be set out of an abundance of caution?

