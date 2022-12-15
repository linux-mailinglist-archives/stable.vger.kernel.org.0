Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D29864DCE3
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 15:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiLOOaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 09:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiLOOap (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 09:30:45 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A6313FB3;
        Thu, 15 Dec 2022 06:30:44 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFDuBUN030999;
        Thu, 15 Dec 2022 14:30:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=rTsvu1JO434rh6muHDQ2tC9/milU9+JL5tb9fp7Iaus=;
 b=LR/vnTd0sFkN2ywNbz35nNO+SirdX9ldHjVdNnDTR0lFVDOfDsPU4FS6JXrH8vzan/KP
 wM4d2p+VtWmKxYvXGjaO5Rvj0s+j5ktR8Gh2WXIeDODCKiZnxMAWsRnNsKHPvvrOsRpf
 ugpDb1q2/4E5aT6QtLhqOFb0fe/mk6B9ZM16J5/7QzdowY63yk3QdF84QJ9NUb5Q+y3A
 tdOomlMgA6VusvAyC1uNelgU51WjHN8h1MGWh20PF0MQYVn4jAlNgsGHSYssNiPz+3Yj
 MvwWq22HD9MI3MW0P4opz0jKd8emNrnv1I/+E5kJyKTdDZ/XzSaOBBnNrLyIE/8XEmOq tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg4wds3v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 14:30:27 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFDuCR1031019;
        Thu, 15 Dec 2022 14:30:27 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg4wds3ug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 14:30:27 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFDwd41017094;
        Thu, 15 Dec 2022 14:30:26 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3mf07gp97b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 14:30:26 +0000
Received: from smtpav01.dal12v.mail.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BFEUOCj47448536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 14:30:25 GMT
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95B5C58057;
        Thu, 15 Dec 2022 14:30:24 +0000 (GMT)
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3F7F58058;
        Thu, 15 Dec 2022 14:30:23 +0000 (GMT)
Received: from sig-9-65-242-118.ibm.com (unknown [9.65.242.118])
        by smtpav01.dal12v.mail.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 14:30:23 +0000 (GMT)
Message-ID: <757bc525f7d3fe6db5f3ee1f86de2f4d02d8286b.camel@linux.ibm.com>
Subject: Re: [RFC] IMA LSM based rule race condition issue on 4.19 LTS
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     "Guozihua (Scott)" <guozihua@huawei.com>,
        dmitry.kasatkin@gmail.com, Paul Moore <paul@paul-moore.com>,
        sds@tycho.nsa.gov, eparis@parisplace.org,
        Greg KH <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     selinux@vger.kernel.org,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        stable@vger.kernel.org
Date:   Thu, 15 Dec 2022 09:30:23 -0500
In-Reply-To: <a63d5d4b-d7a9-fdcb-2b90-b5e2a974ca4c@huawei.com>
References: <389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com>
         <efd4ce83299a10b02b1c04cc94934b8d51969e1c.camel@linux.ibm.com>
         <6a5bc829-b788-5742-cbfc-dba348065dbe@huawei.com>
         <566721e9e8d639c82d841edef4d11d30a4d29694.camel@linux.ibm.com>
         <fffb29b7-a1ac-33fb-6aca-989e5567f565@huawei.com>
         <40cf70a96d2adbff1c0646d3372f131413989854.camel@linux.ibm.com>
         <a63d5d4b-d7a9-fdcb-2b90-b5e2a974ca4c@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _xqLonGWNCZ9e5ivEYb90vsGsIpf2-od
X-Proofpoint-ORIG-GUID: j5Ar0w61dJGpyTj1FsJ70s69TDMZWmdR
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_08,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 impostorscore=0 clxscore=1015
 adultscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212150114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-12-15 at 21:15 +0800, Guozihua (Scott) wrote:
> On 2022/12/15 18:49, Mimi Zohar wrote:
> > On Thu, 2022-12-15 at 16:51 +0800, Guozihua (Scott) wrote:
> >> On 2022/12/14 20:19, Mimi Zohar wrote:
> >>> On Wed, 2022-12-14 at 09:33 +0800, Guozihua (Scott) wrote:
> >>>> On 2022/12/13 23:30, Mimi Zohar wrote:
> >>>>> On Fri, 2022-12-09 at 15:00 +0800, Guozihua (Scott) wrote:
> >>>>>> Hi community.
> >>>>>>
> >>>>>> Previously our team reported a race condition in IMA relates to LSM 
> >>>>>> based rules which would case IMA to match files that should be filtered 
> >>>>>> out under normal condition. The issue was originally analyzed and fixed 
> >>>>>> on mainstream. The patch and the discussion could be found here: 
> >>>>>> https://lore.kernel.org/all/20220921125804.59490-1-guozihua@huawei.com/
> >>>>>>
> >>>>>> After that, we did a regression test on 4.19 LTS and the same issue 
> >>>>>> arises. Further analysis reveled that the issue is from a completely 
> >>>>>> different cause.
> >>>>>>
> >>>>>> The cause is that selinux_audit_rule_init() would set the rule (which is 
> >>>>>> a second level pointer) to NULL immediately after called. The relevant 
> >>>>>> codes are as shown:
> >>>>>>
> >>>>>> security/selinux/ss/services.c:
> >>>>>>> int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
> >>>>>>> {
> >>>>>>>         struct selinux_state *state = &selinux_state;
> >>>>>>>         struct policydb *policydb = &state->ss->policydb;
> >>>>>>>         struct selinux_audit_rule *tmprule;
> >>>>>>>         struct role_datum *roledatum;
> >>>>>>>         struct type_datum *typedatum;
> >>>>>>>         struct user_datum *userdatum;
> >>>>>>>         struct selinux_audit_rule **rule = (struct selinux_audit_rule **)vrule;
> >>>>>>>         int rc = 0;
> >>>>>>>
> >>>>>>>         *rule = NULL;
> >>>>>> *rule is set to NULL here, which means the rule on IMA side is also NULL.
> >>>>>>>
> >>>>>>>         if (!state->initialized)
> >>>>>>>                 return -EOPNOTSUPP;
> >>>>>> ...
> >>>>>>> out:
> >>>>>>>         read_unlock(&state->ss->policy_rwlock);
> >>>>>>>
> >>>>>>>         if (rc) {
> >>>>>>>                 selinux_audit_rule_free(tmprule);
> >>>>>>>                 tmprule = NULL;
> >>>>>>>         }
> >>>>>>>
> >>>>>>>         *rule = tmprule;
> >>>>>> rule is updated at the end of the function.
> >>>>>>>
> >>>>>>>         return rc;
> >>>>>>> }
> >>>>>>
> >>>>>> security/integrity/ima/ima_policy.c:
> >>>>>>> static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
> >>>>>>>                             const struct cred *cred, u32 secid,
> >>>>>>>                             enum ima_hooks func, int mask)
> >>>>>>> {...
> >>>>>>> for (i = 0; i < MAX_LSM_RULES; i++) {
> >>>>>>>                 int rc = 0;
> >>>>>>>                 u32 osid;
> >>>>>>>                 int retried = 0;
> >>>>>>>
> >>>>>>>                 if (!rule->lsm[i].rule)
> >>>>>>>                         continue;
> >>>>>> Setting rule to NULL would lead to LSM based rule matching being skipped.
> >>>>>>> retry:
> >>>>>>>                 switch (i) {
> >>>>>>
> >>>>>> To solve this issue, there are multiple approaches we might take and I 
> >>>>>> would like some input from the community.
> >>>>>>
> >>>>>> The first proposed solution would be to change 
> >>>>>> selinux_audit_rule_init(). Remove the set to NULL bit and update the 
> >>>>>> rule pointer with cmpxchg.
> >>>>>>
> >>>>>>> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> >>>>>>> index a9f2bc8443bd..aa74b04ccaf7 100644
> >>>>>>> --- a/security/selinux/ss/services.c
> >>>>>>> +++ b/security/selinux/ss/services.c
> >>>>>>> @@ -3297,10 +3297,9 @@ int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
> >>>>>>>         struct type_datum *typedatum;
> >>>>>>>         struct user_datum *userdatum;
> >>>>>>>         struct selinux_audit_rule **rule = (struct selinux_audit_rule **)vrule;
> >>>>>>> +       struct selinux_audit_rule *orig = rule;
> >>>>>>>         int rc = 0;
> >>>>>>>  
> >>>>>>> -       *rule = NULL;
> >>>>>>> -
> >>>>>>>         if (!state->initialized)
> >>>>>>>                 return -EOPNOTSUPP;
> >>>>>>>  
> >>>>>>> @@ -3382,7 +3381,8 @@ int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
> >>>>>>>                 tmprule = NULL;
> >>>>>>>         }
> >>>>>>>  
> >>>>>>> -       *rule = tmprule;
> >>>>>>> +       if (cmpxchg(rule, orig, tmprule) != orig)
> >>>>>>> +               selinux_audit_rule_free(tmprule);
> >>>>>>>  
> >>>>>>>         return rc;
> >>>>>>>  }
> >>>>>>
> >>>>>> This solution would be an easy fix, but might influence other modules 
> >>>>>> calling selinux_audit_rule_init() directly or indirectly (on 4.19 LTS, 
> >>>>>> only auditfilter and IMA it seems). And it might be worth returning an 
> >>>>>> error code such as -EAGAIN.
> >>>>>>
> >>>>>> Or, we can access rules via RCU, similar to what we do on 5.10. This 
> >>>>>> could means more code change and testing.
> >>>>>
> >>>>> In the 4.19 kernel, IMA is doing a lazy LSM based policy rule update as
> >>>>> needed.  IMA waits for selinux_audit_rule_init() to complete and
> >>>>> shouldn't see NULL, unless there is an SELinux failure.  Before
> >>>>> "fixing" the problem, what exactly is the problem?
> >>>>
> >>>> IMA runs on multiple cores. On 4.19 kernel, IMA do a lazy update on ALL
> >>>> LSM based rules in one go without using RCU, which would still allow
> >>>> other cores to access the rule being updated. And that's the issue.
> >>>>
> >>>> An example scenario would be:
> >>>> 	CPU1			|	CPU2
> >>>> opened a file and starts	|
> >>>> updating LSM based rules.	|
> >>>> 				| opened a file and starts
> >>>> 				| matching rules.
> >>>> 				|
> >>>> set a LSM based rule to NULL.	| access the same LSM based rule and
> >>>>  				| see that it's NULL.
> >>>>
> >>>> In this situation, CPU 2 would recognize this rule as not LSM based and
> >>>> ignore the LSM part of the rule while matching.
> >>>
> >>> Would picking up just ima_lsm_update_rule(), without changing to the
> >>> lsm policy update notifier, from upstream and calling it from
> >>> ima_lsm_update_rules() resolve the RCU locking issue?  Or are there
> >>> other issues?
> >>
> >> Hi Mimi,
> >>
> >> That should resolve the issue just fine. However, that'd mean having a
> >> customized ima_lsm_update_rules as well as a customized
> >> ima_lsm_update_rule functions on 4.19.y, potentially decrease the
> >> maintainability. The customization of the two functions mentioned above
> >> would be to ripoff the RCU part so that we can leave the other rule-list
> >> access untouched.
> > 
> > Hi Scott,
> > 
> > Neither do we want to backport new functionality.  Perhaps it is only a
> > subset of commit b16942455193 ("ima: use the lsm policy update
> > notifier").
> Yes we are able to backport part of this commit to get a mainline-like
> behavior which would solve the issue at hand as well. However from a
> maintenance standpoint it might be better to form a different commit and
> not re-use the commit message from mainline commit.

I assume that is fine, but cherry-pick the original commit with the -x
option, so there is a correlation to the upstream commit.  The patch
description would mention that the patch is a partial backport.

thanks,

Mimi

> > 
> > Although your suggested solution of using "cmpxchg" isn't needed in
> > recent kernels,  it wouldn't hurt either, right?  Assuming that Paul
> > would be willing to accept it, that could be another option.
> The cmpxchg part is merely to avoid multiple updates on the same rule
> item. However I am not so sure why SELinux would set the rule to NULL.
> My guess is that SELinux is trying to stop others from using an
> invalidated rule?
> 
> Would Paul be able to provide some insight? as well as some Comment on
> the proposed solution?


