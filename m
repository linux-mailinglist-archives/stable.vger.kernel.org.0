Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4EE451916
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 00:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350773AbhKOXOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 18:14:24 -0500
Received: from sonic301-38.consmr.mail.ne1.yahoo.com ([66.163.184.207]:46846
        "EHLO sonic301-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241141AbhKOVpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 16:45:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1637012578; bh=JLM+dQYuxLqsARbffxhy9CCQHdkq0qFjOtXJ8aRN2hc=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=kezj0zhEqdCNSddi1oM7xnc5vDVDln4nIlyRU3xPHfaytHTIN4R5KsnAfLkPdY4BUVkLk3b4g9rvzmn50P70Y9QjxUvxta4kluK0g3HOsvGHO7KvLNuOx5MmOxuBxQdk3JcHBhmYyssLW9O5dsfWDEV5Ie9v91XlOLThFEDYnfDjVN4u4xmjIhErqVobLVifcuSO+UxkT2QlS8cx6tsN6McG+SPk6d5OM06rw3r4qvP39MJGOvVllHVWVXTXDCNsvZ+UjDIeKsgCuN+DHSsAzhkyahJ7NkhypTea4au7dvO1rJG4Xcds5q4v/zeCHNoeAJlrV4mfXfziCQFhZVA3lQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1637012578; bh=W6pjmLetEZnxT4wQ+2+TNfXRU6U4x4VxZ/dhUj0kamE=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=uEpQsYxm7aO65rhbD2wGjODq0N0geymDQTfz40sQ6d9WN4evibd06qiQZH/yvEqQZNgoCGl/CiKnwjj5WJ93i701AEMvcXmP+loESNoNBSYihkqrhkuw4uxAOeOgOlIjDq9Wlb6KfB2PPiTFmeT1JS2xTZzAZRfl95qLlqaSv7y8SN4BdzxmXKMrobkqmYy2SdEwxXLOnsMoAYKOVQ6+RCTBX+ZUEG0F2gKjg+qy1gYuejfkpZPHrWwelLB5MP0wkTvrjbK2QeY2T72jLHCRKwNrT07yDRpX3jWxJ54tDGnoIh/SrNqW3ppeLYeEc4cOaDlVDTt56+cbn65nGWxbvQ==
X-YMail-OSG: .DYPHs8VM1nVHnPd8p..lO.L9YV5pkpSk90UeMwSXFy_tcPZ9b_MjEfXULCD1HU
 xHyfEkQ7OVaSFs7dDrSngDXq3ArI0pYX6f2bvNyLa.ISN1ra7IP0f9DV01k3LD48Z4Sbp3Shgr_Y
 1L7I5Z3GgnTbwIZkq356vhz8i4zYjYQzZ26uJ95FmhyzwoRmVpUBsHcKiNk2z2oycdpCwsveh9Gp
 upM7_gdukyBbNrYhnis5PmD3KPOUSbvQh4pMSy.TO9E6sMK4NXfBIq91wEipLGDFM_3bKM8gsRf5
 QRh4Y57MWcxLC2bPOwAqGGsGIAlczod16T5_9WchTFq.EKI4dVH3XVe20FsgfVdLQoa4lf5cZaOp
 XS211dbPXL4dCVKsdpeNwW4KR87N1liF6pM4bWhHXsa3nZ4w3.VAULBrNAXvoXjjjBe_ND3N38Cg
 yVRAWaT2.QuSiMoaLxRLJnZWNkXPt6jQILJpCaCshdcTnjowpnX.fag3wBS97XlS8X72WhgwGR8G
 mxWNZt2M6zB6DXXgJZyP_6uHaIeBrUXGgf2PNaTf.IWsbol2Z1t3980BPY4NkJkJlOLlYvQSWdCe
 mKrwIxamITRldJB7.vrGgjrGPW4rvjaCIF7lNxneA6Uubwi.acBYuNskeMvQ5iKPsq12vz4RhUnH
 0VDA_K9T6rK.7PFJu6fiNot7ylPoiHE1Db60OYk_Wc36psN1hLwRuekwwjxK0HPDWRka6gU3f1H1
 ZaTGE1Ofc3t_4UdfWt2Eyx.FHnlXvrHQuIrzcflLJLZAaguaGLnZyR8hXZNcvMwuyU9d8bO4mbrn
 _eABpQNElvSjtp7ROICU0ZAw2zHVotKMr1z8EWW.YhzZytDO5JFel4n0jA7dv4SqiHkPvRgosciN
 A25B.ZDYeDKaGvSbWZ2iDltM8H34kUP_mIPerM4EBaZQUgBVYE2I.1Qtn_3qD5cO9JmsTTsLKT8W
 gs_qVCE4fw6feDIEAWRzhgsqF8GBY43YJVujj2TErne1AgOG5w3nD1qvkl7wGQFFt2J5d7p4ir.S
 GX4cTVfovHCIerA7miIfqVmDiEe3X0NxLxaE6w__s9UaVE6qceiFJeJKGj._DR8p4cJoNbEfzIqN
 Aou5c8Sg9QPoznOngYxI4usWv.oWvGfF.zzuo.tqkNGyjfd_UTibWJrusc0.WsqZZf7QM2yefylg
 BCew4hBQ5JhKzoelqHaKyfQ_30OASG1k_Grtfith2XOJ.9OihlG1HZyaF8F5.Sz0guIw5UGNQ5l5
 WRcaiUAvDddDSpK0r8t6Ym.cOmUZM08bepTVzJQ1CsDoM.WkEpJLQy1jWtSUCwjiCe4eW06g8pL1
 tr9KiWUfZmtOi66fh00fUvSA16z_o3ZqE5yBLC4z68VaOif5D165UHybuaodeuW3GlfmSdoGt_M.
 KQ..OTx3MtVbcBHBYttBKYG_8GdGtG4Xztsz6dAYQHN29tLl4oq5aMqfD3X49bSUHhFmgIphGFWY
 vqzRy2VCd7t0BjD2UQVWlgf4jH9KR8Q3OiKzcXSF.QfiNPjLLY3U0P4anbCvPYX1hS4JBcWbWEQy
 kW4E7IXa4OzImHKskkPDMyki_0SQntV2RZoNYY6wz6tfnrqt0olC3bVL6Jt7DvsAKofcZiSa74Ss
 KEiU4vw0nTpW.hU5NsVBG5rMuseKoIe0nclBimfeg6sFKwekztPxw5Q.MmsOnPoTAo0pv3CGXJv_
 i_4Zm7LIohbgHVaURxLqBcz6mR_HEQEEgfaDunRpgmrGpIgVRiW3I7I3pZ2Qs7r0RgHcKOrNtdsW
 BCB9oPl6O6Vbuc7HsOz6FEWeRa4OnwmBiPJlfwNq8Tdb5AT2MrMTRHNhh.3KatOetvYXanf2wWP.
 XNsrk68DcsmfOGfmcYG8nUjPMm6TNdrYE63fFLkJjZUI1xMV44zT21NgrBTy705xNPaZJnDMbljT
 nd4kivKeUAv9HNly_phyT0g7SOWSZH4vnT5qfVlcgOX2FpoNOKh8ToAK0C5Lwo45833OZ5c_8MJP
 MjXE8moLhh7nqEDMOfZzRqd_Qi7FoAP7dm4iv.LR47Llh89zxehLMFZ9wHCkcIUiRafIcRBDiuxd
 Gy2Y5F5ke.wdsrUkFjWa244IeXiFk4ZGdzK7YSMsvcrVaQTPHizJg7hhfZZn6JYIknONSGutDFla
 ERNhwnbF5lBnzI0f5o3rYzOPxA9UDYf6jfTlmkgCDEdOT_Cm1GYIp4WtIWAg9v2sbnX1p.aANm7_
 USpgM2L3WJeGk2YvGq6RVSg.LKWjEdimhrSyDSRLCy.N9naFFxOlhGHuLTU3kF5lk0afCtqejt0C
 hFkfbWToqYw--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Mon, 15 Nov 2021 21:42:58 +0000
Received: by kubenode516.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID f245e8adb4dd8224e2af8148652e2228;
          Mon, 15 Nov 2021 21:42:57 +0000 (UTC)
Message-ID: <ead81edf-ca8f-9e97-96ca-984202e7d8ac@schaufler-ca.com>
Date:   Mon, 15 Nov 2021 13:42:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
Content-Language: en-US
To:     Alistair Delva <adelva@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Serge Hallyn <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20211115173850.3598768-1-adelva@google.com>
 <CAFqZXNvVHv8Oje-WV6MWMF96kpR6epTsbc-jv-JF+YJw=55i1w@mail.gmail.com>
 <CANDihLEFZAz8DwkkMGiDJnDMjxiUuSCanYsJtkRwa9RoyruLFA@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CANDihLEFZAz8DwkkMGiDJnDMjxiUuSCanYsJtkRwa9RoyruLFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.19306 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/2021 11:08 AM, Alistair Delva wrote:
> On Mon, Nov 15, 2021 at 11:04 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>> On Mon, Nov 15, 2021 at 7:14 PM Alistair Delva <adelva@google.com> wrote:
>>> Booting to Android userspace on 5.14 or newer triggers the following
>>> SELinux denial:
>>>
>>> avc: denied { sys_nice } for comm="init" capability=23
>>>       scontext=u:r:init:s0 tcontext=u:r:init:s0 tclass=capability
>>>       permissive=0
>>>
>>> Init is PID 0 running as root, so it already has CAP_SYS_ADMIN. For
>>> better compatibility with older SEPolicy, check ADMIN before NICE.
>> But with this patch you in turn punish the new/better policies that
>> try to avoid giving domains CAP_SYS_ADMIN unless necessary (using only
>> the more granular capabilities wherever possible), which may now get a
>> bogus sys_admin denial. IMHO the order is better as it is, as it
>> motivates the "good" policy writing behavior - i.e. spelling out the
>> capability permissions more explicitly and avoiding CAP_SYS_ADMIN.
>>
>> IOW, if you domain does CAP_SYS_NICE things, and you didn't explicitly
>> grant it that (and instead rely on the CAP_SYS_ADMIN fallback), then
>> the denial correctly flags it as an issue in your policy and
>> encourages you to add that sys_nice permission to the domain. Then
>> when one beautiful hypothetical day the CAP_SYS_ADMIN fallback is
>> removed, your policy will be ready for that and things will keep
>> working.
>>
>> Feel free to carry that patch downstream if patching the kernel is
>> easier for you than fixing the policy, but for the upstream kernel
>> this is just a step in the wrong direction.
> I'm personally fine with this position, but I am curious why "never
> break userspace" doesn't apply to SELinux policies.

Because SELinux policy is configuration data, not system code.
One is free to modify SELinux policy to suit one's whims without
making any change to the Linux kernel or its APIs.

>   At the end of the
> day, booting 5.13 or older, we don't get a denial, and there's nothing
> for the sysadmin to do. On 5.14 and newer, we get denials. This is a
> common pattern we see each year: some new capability or permission is
> required where it wasn't required before, and there's no compatibility
> mechanism to grandfather in old policies.

This is an artifact of separating policy from mechanism. The
capability mechanism does not suffer from this issue because
it embodies its policy. SELinux, Smack, AppArmor and "containers"
are vulnerable to it because they explicitly deny the kernel and
kernel developers permission to make assumptions about how they
define "policy".

>   So, we have to touch
> userspace. If this is just how things are, I can certainly update our
> init.te definitions.

If SELinux was a required kernel mechanism and the policy was
included in the kernel tree you might be able to argue that
kernel developers are responsible for changes to SELinux policy.
But it ain't, and it isn't.   By design.

>
>>> Fixes: 9d3a39a5f1e4 ("block: grant IOPRIO_CLASS_RT to CAP_SYS_NICE")
>>> Signed-off-by: Alistair Delva <adelva@google.com>
>>> Cc: Khazhismel Kumykov <khazhy@google.com>
>>> Cc: Bart Van Assche <bvanassche@acm.org>
>>> Cc: Serge Hallyn <serge@hallyn.com>
>>> Cc: Jens Axboe <axboe@kernel.dk>
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Cc: Paul Moore <paul@paul-moore.com>
>>> Cc: selinux@vger.kernel.org
>>> Cc: linux-security-module@vger.kernel.org
>>> Cc: kernel-team@android.com
>>> Cc: stable@vger.kernel.org # v5.14+
>>> ---
>>>   block/ioprio.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/block/ioprio.c b/block/ioprio.c
>>> index 0e4ff245f2bf..4d59c559e057 100644
>>> --- a/block/ioprio.c
>>> +++ b/block/ioprio.c
>>> @@ -69,7 +69,7 @@ int ioprio_check_cap(int ioprio)
>>>
>>>          switch (class) {
>>>                  case IOPRIO_CLASS_RT:
>>> -                       if (!capable(CAP_SYS_NICE) && !capable(CAP_SYS_ADMIN))
>>> +                       if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
>>>                                  return -EPERM;
>>>                          fallthrough;
>>>                          /* rt has prio field too */
>>> --
>>> 2.34.0.rc1.387.gb447b232ab-goog
>>>
>> --
>> Ondrej Mosnacek
>> Software Engineer, Linux Security - SELinux kernel
>> Red Hat, Inc.
>>
