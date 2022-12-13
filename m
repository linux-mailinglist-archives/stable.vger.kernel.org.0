Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5E864B86B
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 16:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbiLMPad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 10:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbiLMPad (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 10:30:33 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F8911829;
        Tue, 13 Dec 2022 07:30:31 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDF9XNa028390;
        Tue, 13 Dec 2022 15:30:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=nVPaX5QJ+Zz8gxqvh/aOCvC4eDf3fQpQJTn1yo4HVEs=;
 b=r/2rSbfzdTApeNx0iEplqCK53ZzWs0PqKa2J/MiKyjrMZMBvnVfugsgyDBLzF+6SkQHf
 G+wiZZatvtuQ1MqzI2jOnbgrSos1O7iJzgYPWI0vIkJ8pu7YcOX4jeu6MiZ2YGqjARWk
 6bALfaZfDW20HCOGNyLOUggKSn3021ariWRfAsfZpovWx8X9dGiEzOa4fcWpKKMCykK4
 mo4tj5EW+HI5kH4wjqaOzTs1DtNuKbaCV4izVWzSlz8YIVkp4ic+3qH39sT3+es0XkUT
 R7hOYS+AHP1Yt+kQsSZwj5OTOg4EmsPLQbXUJb019ZhRzGr7+XEYG6sfrWTXV+7cg2eA 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mesmxckab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:30:13 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDFCHb0006064;
        Tue, 13 Dec 2022 15:30:12 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mesmxck9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:30:12 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2BDEj9Lx019468;
        Tue, 13 Dec 2022 15:30:11 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3mchr6s71e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:30:11 +0000
Received: from smtpav01.dal12v.mail.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDFUATI48365978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:30:10 GMT
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3D3458061;
        Tue, 13 Dec 2022 15:30:09 +0000 (GMT)
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D95A58058;
        Tue, 13 Dec 2022 15:30:09 +0000 (GMT)
Received: from sig-9-65-192-247.ibm.com (unknown [9.65.192.247])
        by smtpav01.dal12v.mail.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 15:30:09 +0000 (GMT)
Message-ID: <efd4ce83299a10b02b1c04cc94934b8d51969e1c.camel@linux.ibm.com>
Subject: Re: [RFC] IMA LSM based rule race condition issue on 4.19 LTS
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     "Guozihua (Scott)" <guozihua@huawei.com>,
        dmitry.kasatkin@gmail.com, Paul Moore <paul@paul-moore.com>,
        sds@tycho.nsa.gov, eparis@parisplace.org,
        Greg KH <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     selinux@vger.kernel.org,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        stable@vger.kernel.org
Date:   Tue, 13 Dec 2022 10:30:08 -0500
In-Reply-To: <389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com>
References: <389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zOxeuoPUB74ZbgwDoR4_FV4X8X9oesGG
X-Proofpoint-ORIG-GUID: k67Y2O8uFLeNPHT5Y8ttIusX1iE9c5-p
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 clxscore=1011 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130133
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-12-09 at 15:00 +0800, Guozihua (Scott) wrote:
> Hi community.
> 
> Previously our team reported a race condition in IMA relates to LSM 
> based rules which would case IMA to match files that should be filtered 
> out under normal condition. The issue was originally analyzed and fixed 
> on mainstream. The patch and the discussion could be found here: 
> https://lore.kernel.org/all/20220921125804.59490-1-guozihua@huawei.com/
> 
> After that, we did a regression test on 4.19 LTS and the same issue 
> arises. Further analysis reveled that the issue is from a completely 
> different cause.
> 
> The cause is that selinux_audit_rule_init() would set the rule (which is 
> a second level pointer) to NULL immediately after called. The relevant 
> codes are as shown:
> 
> security/selinux/ss/services.c:
> > int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
> > {
> >         struct selinux_state *state = &selinux_state;
> >         struct policydb *policydb = &state->ss->policydb;
> >         struct selinux_audit_rule *tmprule;
> >         struct role_datum *roledatum;
> >         struct type_datum *typedatum;
> >         struct user_datum *userdatum;
> >         struct selinux_audit_rule **rule = (struct selinux_audit_rule **)vrule;
> >         int rc = 0;
> > 
> >         *rule = NULL;
> *rule is set to NULL here, which means the rule on IMA side is also NULL.
> > 
> >         if (!state->initialized)
> >                 return -EOPNOTSUPP;
> ...
> > out:
> >         read_unlock(&state->ss->policy_rwlock);
> > 
> >         if (rc) {
> >                 selinux_audit_rule_free(tmprule);
> >                 tmprule = NULL;
> >         }
> > 
> >         *rule = tmprule;
> rule is updated at the end of the function.
> > 
> >         return rc;
> > }
> 
> security/integrity/ima/ima_policy.c:
> > static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
> >                             const struct cred *cred, u32 secid,
> >                             enum ima_hooks func, int mask)
> > {...
> > for (i = 0; i < MAX_LSM_RULES; i++) {
> >                 int rc = 0;
> >                 u32 osid;
> >                 int retried = 0;
> > 
> >                 if (!rule->lsm[i].rule)
> >                         continue;
> Setting rule to NULL would lead to LSM based rule matching being skipped.
> > retry:
> >                 switch (i) {
> 
> To solve this issue, there are multiple approaches we might take and I 
> would like some input from the community.
> 
> The first proposed solution would be to change 
> selinux_audit_rule_init(). Remove the set to NULL bit and update the 
> rule pointer with cmpxchg.
> 
> > diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> > index a9f2bc8443bd..aa74b04ccaf7 100644
> > --- a/security/selinux/ss/services.c
> > +++ b/security/selinux/ss/services.c
> > @@ -3297,10 +3297,9 @@ int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
> >         struct type_datum *typedatum;
> >         struct user_datum *userdatum;
> >         struct selinux_audit_rule **rule = (struct selinux_audit_rule **)vrule;
> > +       struct selinux_audit_rule *orig = rule;
> >         int rc = 0;
> >  
> > -       *rule = NULL;
> > -
> >         if (!state->initialized)
> >                 return -EOPNOTSUPP;
> >  
> > @@ -3382,7 +3381,8 @@ int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
> >                 tmprule = NULL;
> >         }
> >  
> > -       *rule = tmprule;
> > +       if (cmpxchg(rule, orig, tmprule) != orig)
> > +               selinux_audit_rule_free(tmprule);
> >  
> >         return rc;
> >  }
> 
> This solution would be an easy fix, but might influence other modules 
> calling selinux_audit_rule_init() directly or indirectly (on 4.19 LTS, 
> only auditfilter and IMA it seems). And it might be worth returning an 
> error code such as -EAGAIN.
> 
> Or, we can access rules via RCU, similar to what we do on 5.10. This 
> could means more code change and testing.

In the 4.19 kernel, IMA is doing a lazy LSM based policy rule update as
needed.  IMA waits for selinux_audit_rule_init() to complete and
shouldn't see NULL, unless there is an SELinux failure.  Before
"fixing" the problem, what exactly is the problem?

thanks,

Mimi

