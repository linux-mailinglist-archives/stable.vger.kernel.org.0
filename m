Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC7D1B6448
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 21:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgDWTKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 15:10:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4882 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727812AbgDWTKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 15:10:38 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03NJ2QWi083940
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 15:10:38 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmuapg75-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 15:10:38 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Thu, 23 Apr 2020 20:09:48 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 23 Apr 2020 20:09:46 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03NJAWch58720378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 19:10:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EC5F11C0A7;
        Thu, 23 Apr 2020 19:10:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47E0E11C09F;
        Thu, 23 Apr 2020 19:10:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.178.107])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Apr 2020 19:10:31 +0000 (GMT)
Subject: Re: [PATCH] ima: Fix return value of ima_write_policy()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Thu, 23 Apr 2020 15:10:30 -0400
In-Reply-To: <baf2fd326f5043538390254304b85e41@huawei.com>
References: <20200421090442.22693-1-roberto.sassu@huawei.com>
         <1587609266.5165.58.camel@linux.ibm.com>
         <baf2fd326f5043538390254304b85e41@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042319-4275-0000-0000-000003C5753F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042319-4276-0000-0000-000038DB00E0
Message-Id: <1587669030.5610.43.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-23_13:2020-04-23,2020-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230144
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-04-23 at 09:39 +0000, Roberto Sassu wrote:
> > On Tue, 2020-04-21 at 11:04 +0200, Roberto Sassu wrote:
> > > Return datalen instead of zero if there is a rule to appraise the policy
> > > but that rule is not enforced.
> > >
> > > Cc: stable@vger.kernel.org
> > > Fixes: 19f8a84713edc ("ima: measure and appraise the IMA policy itself")
> > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > ---
> > >  security/integrity/ima/ima_fs.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/security/integrity/ima/ima_fs.c
> > b/security/integrity/ima/ima_fs.c
> > > index a71e822a6e92..2c2ea814b954 100644
> > > --- a/security/integrity/ima/ima_fs.c
> > > +++ b/security/integrity/ima/ima_fs.c
> > > @@ -340,6 +340,8 @@ static ssize_t ima_write_policy(struct file *file,
> > const char __user *buf,
> > >  				    1, 0);
> > >  		if (ima_appraise & IMA_APPRAISE_ENFORCE)
> > >  			result = -EACCES;
> > > +		else
> > > +			result = datalen;
> > 
> > In all other cases, where the IMA_APPRAISE_ENFORCE is not enabled we
> > allow the action.  Here we prevent loading the policy, but don't
> > return an error.  One option, as you did, is return some indication
> > that the policy was not loaded.  Another option would be to allow
> > loading the policy in LOG or FIX mode, but I don't think that would be
> > productive.  Perhaps differentiate between the LOG and FIX modes from
> > the OFF mode.  For the LOG and FIX modes, perhaps return -EACCES as
> > well.  For the OFF case, loading a policy with appraise rules should
> > not be permitted.
> 
> In LOG or FIX mode, loading a policy with absolute path will succeed.

Yes

> Maybe we should just keep the same behavior also when the policy
> is directly written to securityfs.

The purpose of LOG mode is to learn about the filesystem behavior in
order to label it properly.  FIX mode is for re-calculating and fixing
existing file hashes.  If we permit directly writing the policy to
securityfs, even if the existing policy requires the policy to be
signed, then it is behaving differently than it would in enforcing
mode.  I'm ok with that, as long as the error message is emitted.

> Ok for the OFF mode, but probably this should be a separate patch.

Agreed

Mimi

> 
> > >  	} else {
> > >  		result = ima_parse_add_rule(data);
> > >  	}
> 

