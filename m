Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D741650C7C
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 14:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiLSNMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 08:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiLSNMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 08:12:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F36FAE6;
        Mon, 19 Dec 2022 05:12:12 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJCtms5012747;
        Mon, 19 Dec 2022 13:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7SOk3YQS9lGF+iOcoXSrRXy0VxCFllYVUtTeYrhBRa4=;
 b=Mw80rg3XtzkNIKSPvjeoAktUoofyrw3eEO1clBdKVy812AVaudYoubfEsO8oAtr0XOpF
 6RyoKoGWLcGLgtgHB2S6tCB+Z0Wnn0TMfmnz9DK/RZAZ7iBKghrhc/98gHYCeQNckoNx
 uoVx0Rj7gAuVOcWYHxsEJA2FpbU9fQIgFZD2JRZkmwYSvuqaE2CzgrypDdDcklVJ+Gro
 9PyvrOhDVpJq02/KBjRSFwa4xzb9IUvrhqyHicAqaURktYNmXsevIa/ItUVQNrS3U0YU
 h7e8IogRImIP1SdhfXzTEH7WbPmINUpcBDnqb61qnP+hE/keOKAOAaQ6tAuWVWsqCJL2 lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjrd0gcuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 13:11:52 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BJCtmn7012754;
        Mon, 19 Dec 2022 13:11:52 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjrd0gcu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 13:11:52 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJCtBGB027516;
        Mon, 19 Dec 2022 13:11:51 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3mh6yugva5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 13:11:51 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJDBnwU35914172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 13:11:49 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6206758063;
        Mon, 19 Dec 2022 13:11:49 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B233458056;
        Mon, 19 Dec 2022 13:11:48 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.175.166])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 13:11:48 +0000 (GMT)
Message-ID: <6348a26f165c27c562db48eb39b04417cbe1380c.camel@linux.ibm.com>
Subject: Re: [RFC] IMA LSM based rule race condition issue on 4.19 LTS
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     "Guozihua (Scott)" <guozihua@huawei.com>,
        Paul Moore <paul@paul-moore.com>
Cc:     dmitry.kasatkin@gmail.com, sds@tycho.nsa.gov,
        eparis@parisplace.org, Greg KH <gregkh@linuxfoundation.org>,
        sashal@kernel.org, selinux@vger.kernel.org,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        stable@vger.kernel.org
Date:   Mon, 19 Dec 2022 08:11:48 -0500
In-Reply-To: <381efcb7-604f-7f89-e950-efc142350417@huawei.com>
References: <389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com>
         <efd4ce83299a10b02b1c04cc94934b8d51969e1c.camel@linux.ibm.com>
         <6a5bc829-b788-5742-cbfc-dba348065dbe@huawei.com>
         <566721e9e8d639c82d841edef4d11d30a4d29694.camel@linux.ibm.com>
         <fffb29b7-a1ac-33fb-6aca-989e5567f565@huawei.com>
         <40cf70a96d2adbff1c0646d3372f131413989854.camel@linux.ibm.com>
         <a63d5d4b-d7a9-fdcb-2b90-b5e2a974ca4c@huawei.com>
         <757bc525f7d3fe6db5f3ee1f86de2f4d02d8286b.camel@linux.ibm.com>
         <CAHC9VhR2mfaVjXz3sBzbkBamt8nE-9aV+jSOs9jH1ESnKvDrvw@mail.gmail.com>
         <fc11076f-1760-edf3-c0e4-8f58d5e0335c@huawei.com>
         <CAHC9VhT0SRWMi2gQKaBPOj1owqUh-24O9L2DyOZ8JDgEr+ZQiQ@mail.gmail.com>
         <381efcb7-604f-7f89-e950-efc142350417@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Amv06k9OtLUp96ONYuzQNEdbPO-IKNK3
X-Proofpoint-ORIG-GUID: JDSlwQ3HQPtBFR7CoLs4wZH2Qe5GKoWd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015 phishscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-12-19 at 15:10 +0800, Guozihua (Scott) wrote:
> On 2022/12/16 11:04, Paul Moore wrote:
> > On Thu, Dec 15, 2022 at 9:36 PM Guozihua (Scott) <guozihua@huawei.com> wrote:
> >> On 2022/12/16 5:04, Paul Moore wrote:
> > 
> > ...
> > 
> >>> How bad is the backport really?  Perhaps it is worth doing it to see
> >>> what it looks like?
> >>>
> >> It might not be that bad, I'll try to post a version next Monday.
> > 
> > Thanks for giving it a shot.
> > 
> When I am trying a partial backport of b16942455193 ("ima: use the lsm
> policy update notifier"), I took a closer look into it and if we rip off
> the RCU and the notifier part, there would be a potential UAF issue when
> multiple processes are calling ima_lsm_update_rule() and
> ima_match_rules() at the same time. ima_lsm_update_rule() would free the
> old rule if the new rule is successfully copied and initialized, leading
> to ima_match_rules() accessing a freed rule.
> 
> To reserve the mainline solution, we would have to either introduce RCU
> for rule access, which would work better with notifier mechanism or the
> same rule would be updated multiple times, or we would have to introduce
> a lock for LSM based rule update.

Even with the RCU changes, the rules will be updated multiple times. 
With your "ima: Handle -ESTALE returned by ima_filter_rule_match()"
patch, upstream makes a single local copy of the rule to avoid updating
it multiple times.  Without the notifier, it's updating all the rules.

Perhaps an atomic variable to detect if the rules are already being
updated would suffice.  If the atomic variable is set, make a single
local copy of the rule.

-- 
thanks,

Mimi


