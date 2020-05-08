Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44EB1CB5FB
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 19:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgEHR3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 13:29:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7586 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726767AbgEHR3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 13:29:53 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048H2EhP128834;
        Fri, 8 May 2020 13:29:43 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30vtsgud79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 13:29:42 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 048HTCHp116150;
        Fri, 8 May 2020 13:29:42 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30vtsgud61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 13:29:42 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 048H4rFB032591;
        Fri, 8 May 2020 17:29:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5wtd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 17:29:39 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 048HTbZO44695568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 May 2020 17:29:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8924A405B;
        Fri,  8 May 2020 17:29:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8765EA4054;
        Fri,  8 May 2020 17:29:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.139.55])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  8 May 2020 17:29:36 +0000 (GMT)
Message-ID: <1588958976.5146.83.camel@linux.ibm.com>
Subject: Re: [PATCH v4 1/7] ima: Switch to ima_hash_algo for boot aggregate
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Jerry Snitselaar <jsnitsel@redhat.com>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        James.Bottomley@hansenpartnership.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Date:   Fri, 08 May 2020 13:29:36 -0400
In-Reply-To: <20200508045410.t7gawyklyecupe2u@cantor>
References: <20200325104712.25694-1-roberto.sassu@huawei.com>
         <20200325104712.25694-2-roberto.sassu@huawei.com>
         <1585871617.7311.5.camel@linux.ibm.com>
         <20200508045410.t7gawyklyecupe2u@cantor>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_15:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999
 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080142
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-05-07 at 21:54 -0700, Jerry Snitselaar wrote:
> On Thu Apr 02 20, Mimi Zohar wrote:
> >Hi Roberto,
> >
> >On Wed, 2020-03-25 at 11:47 +0100, Roberto Sassu wrote:
> >> boot_aggregate is the first entry of IMA measurement list. Its purpose is
> >> to link pre-boot measurements to IMA measurements. As IMA was designed to
> >> work with a TPM 1.2, the SHA1 PCR bank was always selected even if a
> >> TPM 2.0 with support for stronger hash algorithms is available.
> >>
> >> This patch first tries to find a PCR bank with the IMA default hash
> >> algorithm. If it does not find it, it selects the SHA256 PCR bank for
> >> TPM 2.0 and SHA1 for TPM 1.2. Ultimately, it selects SHA1 also for TPM 2.0
> >> if the SHA256 PCR bank is not found.
> >>
> >> If none of the PCR banks above can be found, boot_aggregate file digest is
> >> filled with zeros, as for TPM bypass, making it impossible to perform a
> >> remote attestation of the system.
> >>
> >> Cc: stable@vger.kernel.org # 5.1.x
> >> Fixes: 879b589210a9 ("tpm: retrieve digest size of unknown algorithms with PCR read")
> >> Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
> >> Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> >> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> >
> >Thank you!  This patch set is now queued in next-integrity-testing
> >during the open window.  Jerry, I assume this works for you.  Could we
> >get your tag?
> >
> 
> Yes, I no longer get the errors with this patch.
> 
> 
> Tested-by: Jerry Snitselaar <jsnitsel@redhat.com>

Thanks, Jerry.  I really do appreciate receiving your tag.

Not all, but a lot of subsystems, do not rebase their branch, at least
once it is in linux-next.  Adding tags is considered rebasing.  For
this reason, I've started staging patches in the next-integrity-
testing branch, before moving them to next-integrity.

thanks,

Mimi
