Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C23664E2BE
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 22:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiLOVE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 16:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiLOVE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 16:04:57 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24808537F8
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 13:04:56 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so4003560pjj.2
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 13:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5Dq1IyikL/aoRRLuONjbjyd+Wq1KNy/6b5KAhrbuu1E=;
        b=2IK3sAd3hRT6SMAjFvotoswSpXca0NQeQrTzk09+Lg5nSLE9ICgTEHTY84nQp5ZS1i
         GdgAW8/w6lQgGXkfXZt/kcMzOvk+FZXtA4bbapWDb17tkrrmQ4H2mWD9J3EivL9EbDKP
         +6vtk363CBhljJv8I2UfnBwR9gM9GVAiD0syVySzjRDXA8rHsWoT5XTv7DRi8iWjyYyN
         XVczAh1gm8wuwS+r+OoeLU1ExOqqEq2KUAeUpumLRK1+IIcUvEAIlkVmax4plzdVZreJ
         UzAlO9BY6Ys6YhucRcV25DpQBHwvH5Pl3XLi0sV+g0kvx6oNtMXYIXL46h96ankGUtLt
         JnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Dq1IyikL/aoRRLuONjbjyd+Wq1KNy/6b5KAhrbuu1E=;
        b=ZP65llO9qCKvhNWKGdcqzeO8MG5HxcuE44++KyitA/N9tonKhY98HQa/Zwt8hrSSKP
         /Z83AaRTtXeXF7W3Y8ROecwNZl1yS19ha4XntrURvPBEQ9JksET5CN2SuHgfFpux9FuX
         uYKShQVPNOZxtqM+emt1mGd9JFaWm/ESa3iMuFpXbySW553D7dEW111TIjwtMQ8lwLCy
         B0I4F3TmwsFLXLUODERonK/FkUMn1mtEsx2TSse8K/Xt+2IavY5WBgoPhXnpuACP4byn
         q7NqUTIX5+dJB0Dtn+crAKLjAQNCaPzYDllX4adDj5u2bJ+OeEciGwYRcu218MR7evfr
         TYIA==
X-Gm-Message-State: AFqh2ko8dZTw1JtmeFm3iQYacPwiTZhvp249cYbCKw3qyTbSJKRiAP7n
        osN99kv6+5HqdB53pm/TaK3GCOjrh/jdxKnB81FbZTM3LibKNIA=
X-Google-Smtp-Source: AMrXdXvyb50epPoJQFEppcxQkac1NfAwuZ8X/nOBfPrvVEjwraHwWQS5zYrq8KZfr6iwieKH+CI989l5cmZNVOCenfo=
X-Received: by 2002:a17:90a:b948:b0:219:8ee5:8dc0 with SMTP id
 f8-20020a17090ab94800b002198ee58dc0mr363922pjw.72.1671138295487; Thu, 15 Dec
 2022 13:04:55 -0800 (PST)
MIME-Version: 1.0
References: <389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com>
 <efd4ce83299a10b02b1c04cc94934b8d51969e1c.camel@linux.ibm.com>
 <6a5bc829-b788-5742-cbfc-dba348065dbe@huawei.com> <566721e9e8d639c82d841edef4d11d30a4d29694.camel@linux.ibm.com>
 <fffb29b7-a1ac-33fb-6aca-989e5567f565@huawei.com> <40cf70a96d2adbff1c0646d3372f131413989854.camel@linux.ibm.com>
 <a63d5d4b-d7a9-fdcb-2b90-b5e2a974ca4c@huawei.com> <757bc525f7d3fe6db5f3ee1f86de2f4d02d8286b.camel@linux.ibm.com>
In-Reply-To: <757bc525f7d3fe6db5f3ee1f86de2f4d02d8286b.camel@linux.ibm.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 15 Dec 2022 16:04:44 -0500
Message-ID: <CAHC9VhR2mfaVjXz3sBzbkBamt8nE-9aV+jSOs9jH1ESnKvDrvw@mail.gmail.com>
Subject: Re: [RFC] IMA LSM based rule race condition issue on 4.19 LTS
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     "Guozihua (Scott)" <guozihua@huawei.com>,
        dmitry.kasatkin@gmail.com, sds@tycho.nsa.gov,
        eparis@parisplace.org, Greg KH <gregkh@linuxfoundation.org>,
        sashal@kernel.org, selinux@vger.kernel.org,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 15, 2022 at 9:30 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> On Thu, 2022-12-15 at 21:15 +0800, Guozihua (Scott) wrote:
> > On 2022/12/15 18:49, Mimi Zohar wrote:
> > > On Thu, 2022-12-15 at 16:51 +0800, Guozihua (Scott) wrote:
> > >> On 2022/12/14 20:19, Mimi Zohar wrote:
> > >>> On Wed, 2022-12-14 at 09:33 +0800, Guozihua (Scott) wrote:
> > >>>> On 2022/12/13 23:30, Mimi Zohar wrote:
> > >>>>> On Fri, 2022-12-09 at 15:00 +0800, Guozihua (Scott) wrote:
> > >>>>>> Hi community.
> > >>>>>>
> > >>>>>> Previously our team reported a race condition in IMA relates to LSM
> > >>>>>> based rules which would case IMA to match files that should be filtered
> > >>>>>> out under normal condition. The issue was originally analyzed and fixed
> > >>>>>> on mainstream. The patch and the discussion could be found here:
> > >>>>>> https://lore.kernel.org/all/20220921125804.59490-1-guozihua@huawei.com/
> > >>>>>>
> > >>>>>> After that, we did a regression test on 4.19 LTS and the same issue
> > >>>>>> arises. Further analysis reveled that the issue is from a completely
> > >>>>>> different cause.
> > >>>>>>
> > >>>>>> The cause is that selinux_audit_rule_init() would set the rule (which is
> > >>>>>> a second level pointer) to NULL immediately after called. The relevant
> > >>>>>> codes are as shown:
> > >>>>>>
> > >>>>>> security/selinux/ss/services.c:
> > >>>>>>> int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
> > >>>>>>> {
> > >>>>>>>         struct selinux_state *state = &selinux_state;
> > >>>>>>>         struct policydb *policydb = &state->ss->policydb;
> > >>>>>>>         struct selinux_audit_rule *tmprule;
> > >>>>>>>         struct role_datum *roledatum;
> > >>>>>>>         struct type_datum *typedatum;
> > >>>>>>>         struct user_datum *userdatum;
> > >>>>>>>         struct selinux_audit_rule **rule = (struct selinux_audit_rule **)vrule;
> > >>>>>>>         int rc = 0;
> > >>>>>>>
> > >>>>>>>         *rule = NULL;
> > >>>>>> *rule is set to NULL here, which means the rule on IMA side is also NULL.
> > >>>>>>>
> > >>>>>>>         if (!state->initialized)
> > >>>>>>>                 return -EOPNOTSUPP;
> > >>>>>> ...
> > >>>>>>> out:
> > >>>>>>>         read_unlock(&state->ss->policy_rwlock);
> > >>>>>>>
> > >>>>>>>         if (rc) {
> > >>>>>>>                 selinux_audit_rule_free(tmprule);
> > >>>>>>>                 tmprule = NULL;
> > >>>>>>>         }
> > >>>>>>>
> > >>>>>>>         *rule = tmprule;
> > >>>>>> rule is updated at the end of the function.
> > >>>>>>>
> > >>>>>>>         return rc;
> > >>>>>>> }
> > >>>>>>
> > >>>>>> security/integrity/ima/ima_policy.c:
> > >>>>>>> static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
> > >>>>>>>                             const struct cred *cred, u32 secid,
> > >>>>>>>                             enum ima_hooks func, int mask)
> > >>>>>>> {...
> > >>>>>>> for (i = 0; i < MAX_LSM_RULES; i++) {
> > >>>>>>>                 int rc = 0;
> > >>>>>>>                 u32 osid;
> > >>>>>>>                 int retried = 0;
> > >>>>>>>
> > >>>>>>>                 if (!rule->lsm[i].rule)
> > >>>>>>>                         continue;
> > >>>>>> Setting rule to NULL would lead to LSM based rule matching being skipped.
> > >>>>>>> retry:
> > >>>>>>>                 switch (i) {
> > >>>>>>
> > >>>>>> To solve this issue, there are multiple approaches we might take and I
> > >>>>>> would like some input from the community.
> > >>>>>>
> > >>>>>> The first proposed solution would be to change
> > >>>>>> selinux_audit_rule_init(). Remove the set to NULL bit and update the
> > >>>>>> rule pointer with cmpxchg.
> > >>>>>>
> > >>>>>>> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> > >>>>>>> index a9f2bc8443bd..aa74b04ccaf7 100644
> > >>>>>>> --- a/security/selinux/ss/services.c
> > >>>>>>> +++ b/security/selinux/ss/services.c
> > >>>>>>> @@ -3297,10 +3297,9 @@ int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
> > >>>>>>>         struct type_datum *typedatum;
> > >>>>>>>         struct user_datum *userdatum;
> > >>>>>>>         struct selinux_audit_rule **rule = (struct selinux_audit_rule **)vrule;
> > >>>>>>> +       struct selinux_audit_rule *orig = rule;
> > >>>>>>>         int rc = 0;
> > >>>>>>>
> > >>>>>>> -       *rule = NULL;
> > >>>>>>> -
> > >>>>>>>         if (!state->initialized)
> > >>>>>>>                 return -EOPNOTSUPP;
> > >>>>>>>
> > >>>>>>> @@ -3382,7 +3381,8 @@ int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
> > >>>>>>>                 tmprule = NULL;
> > >>>>>>>         }
> > >>>>>>>
> > >>>>>>> -       *rule = tmprule;
> > >>>>>>> +       if (cmpxchg(rule, orig, tmprule) != orig)
> > >>>>>>> +               selinux_audit_rule_free(tmprule);
> > >>>>>>>
> > >>>>>>>         return rc;
> > >>>>>>>  }
> > >>>>>>
> > >>>>>> This solution would be an easy fix, but might influence other modules
> > >>>>>> calling selinux_audit_rule_init() directly or indirectly (on 4.19 LTS,
> > >>>>>> only auditfilter and IMA it seems). And it might be worth returning an
> > >>>>>> error code such as -EAGAIN.
> > >>>>>>
> > >>>>>> Or, we can access rules via RCU, similar to what we do on 5.10. This
> > >>>>>> could means more code change and testing.
> > >>>>>
> > >>>>> In the 4.19 kernel, IMA is doing a lazy LSM based policy rule update as
> > >>>>> needed.  IMA waits for selinux_audit_rule_init() to complete and
> > >>>>> shouldn't see NULL, unless there is an SELinux failure.  Before
> > >>>>> "fixing" the problem, what exactly is the problem?
> > >>>>
> > >>>> IMA runs on multiple cores. On 4.19 kernel, IMA do a lazy update on ALL
> > >>>> LSM based rules in one go without using RCU, which would still allow
> > >>>> other cores to access the rule being updated. And that's the issue.
> > >>>>
> > >>>> An example scenario would be:
> > >>>>  CPU1                    |       CPU2
> > >>>> opened a file and starts |
> > >>>> updating LSM based rules.        |
> > >>>>                          | opened a file and starts
> > >>>>                          | matching rules.
> > >>>>                          |
> > >>>> set a LSM based rule to NULL.    | access the same LSM based rule and
> > >>>>                                  | see that it's NULL.
> > >>>>
> > >>>> In this situation, CPU 2 would recognize this rule as not LSM based and
> > >>>> ignore the LSM part of the rule while matching.
> > >>>
> > >>> Would picking up just ima_lsm_update_rule(), without changing to the
> > >>> lsm policy update notifier, from upstream and calling it from
> > >>> ima_lsm_update_rules() resolve the RCU locking issue?  Or are there
> > >>> other issues?
> > >>
> > >> Hi Mimi,
> > >>
> > >> That should resolve the issue just fine. However, that'd mean having a
> > >> customized ima_lsm_update_rules as well as a customized
> > >> ima_lsm_update_rule functions on 4.19.y, potentially decrease the
> > >> maintainability. The customization of the two functions mentioned above
> > >> would be to ripoff the RCU part so that we can leave the other rule-list
> > >> access untouched.
> > >
> > > Hi Scott,
> > >
> > > Neither do we want to backport new functionality.  Perhaps it is only a
> > > subset of commit b16942455193 ("ima: use the lsm policy update
> > > notifier").
> > Yes we are able to backport part of this commit to get a mainline-like
> > behavior which would solve the issue at hand as well. However from a
> > maintenance standpoint it might be better to form a different commit and
> > not re-use the commit message from mainline commit.
>
> I assume that is fine, but cherry-pick the original commit with the -x
> option, so there is a correlation to the upstream commit.  The patch
> description would mention that the patch is a partial backport.

FWIW, if the changes in the backport are significant I tend to use the
following approach as it captures both the original commit as well as
the details on what changes were made and why.

>>>
ima: use the lsm policy update notifier

Really good explanation of what changes were necessary from the
original patch, including why they were necessary in the first place.

   commit b169424551930a9325f700f502802f4d515194e5
   Author: Janne Karhunen <janne.karhunen@gmail.com>
   Date:   Fri Jun 14 15:20:15 2019 +0300

   ima: use the lsm policy update notifier

   Don't do lazy policy updates while running the rule matching,
   run the updates as they happen.

   Depends on commit f242064c5df3 ("LSM: switch to blocking policy update
                                   notifiers")

   Signed-off-by: Janne Karhunen <janne.karhunen@gmail.com>
   Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
>>>

> > > Although your suggested solution of using "cmpxchg" isn't needed in
> > > recent kernels,  it wouldn't hurt either, right?  Assuming that Paul
> > > would be willing to accept it, that could be another option.
> > The cmpxchg part is merely to avoid multiple updates on the same rule
> > item. However I am not so sure why SELinux would set the rule to NULL.
> > My guess is that SELinux is trying to stop others from using an
> > invalidated rule?
> >
> > Would Paul be able to provide some insight? as well as some Comment on
> > the proposed solution?

I'm not comfortable with what might happen with a cmpxchg assignment
when multiple threads are in a related RCU critical section; I'm
assuming they would see the new value immediately (it is atomic,
right?), which I imagine could cause some consistency problems.
However, if someone who understands the intersection of cmpxchg/RCU
better than I do can assure me this isn't a problem we can consider
it.

How bad is the backport really?  Perhaps it is worth doing it to see
what it looks like?

-- 
paul-moore.com
