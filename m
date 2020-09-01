Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315CD258D41
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 13:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgIALOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 07:14:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41812 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726929AbgIALOS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 07:14:18 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 081B2xXE021249;
        Tue, 1 Sep 2020 07:05:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=xXWHJPjAJlz3TybqT9CscGwSEJpGhYi9Z4DQ9I5Cebw=;
 b=dK+g3nPbtCX+mi/9VqDIlKsayT5XBPcLexGA1J8R0Y6kEapzKyRghjRtxYVbmCjwgtXi
 /OAl65LQ7GLTOU+jRjV9ayjTXE/eVP0BLV9HT0Iw/FKVHgZodDUK1Y7VgEwXBV0/FsXh
 e0yc0K4PflokZ1/e+YTtNrzb++ouK87NeXYwMLkvp0lzxs3NeNtlOsV1k64Ml2HNqs8g
 DCs+Eodswe+cOAuCOl2d7dK6RPFr5TrwcVFmBVjiPMr3g/WmjYhqPBxwxMJLMCoMLUJT
 xTwMWYcZ09sxKM5OwAuKDYhGe6tflAw0WY806hxg+jgbEKOFP+kB6AUdCG+DEZ29NxhV 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 339m1qhqrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 07:05:33 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 081B3nJr023217;
        Tue, 1 Sep 2020 07:05:31 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 339m1qhqf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 07:05:26 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 081B3XUH027732;
        Tue, 1 Sep 2020 11:05:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 337en8ba5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 11:05:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 081B576Q17039682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Sep 2020 11:05:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26B9BAE056;
        Tue,  1 Sep 2020 11:05:07 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10363AE05F;
        Tue,  1 Sep 2020 11:05:06 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.77.139])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Sep 2020 11:05:05 +0000 (GMT)
Message-ID: <ae06c113ec91442e293f2466cae3dd1b81f241eb.camel@linux.ibm.com>
Subject: Re: [PATCH 07/11] evm: Set IMA_CHANGE_XATTR/ATTR bit if
 EVM_ALLOW_METADATA_WRITES is set
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        "mjg59@google.com" <mjg59@google.com>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Tue, 01 Sep 2020 07:05:05 -0400
In-Reply-To: <a5e6a5acf2274a6d844b275dacfbabb8@huawei.com>
References: <20200618160329.1263-2-roberto.sassu@huawei.com>
         <20200618160458.1579-7-roberto.sassu@huawei.com>
         <67cafcf63daf8e418871eb5302e7327ba851e253.camel@linux.ibm.com>
         <a5e6a5acf2274a6d844b275dacfbabb8@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_08:2020-09-01,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010091
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-09-01 at 09:08 +0000, Roberto Sassu wrote:
> > From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> > Sent: Monday, August 24, 2020 2:18 PM
> > On Thu, 2020-06-18 at 18:04 +0200, Roberto Sassu wrote:
> > > When EVM_ALLOW_METADATA_WRITES is set, EVM allows any operation
> > on
> > > metadata. Its main purpose is to allow users to freely set metadata when
> > > they are protected by a portable signature, until the HMAC key is loaded.
> > >
> > > However, IMA is not notified about metadata changes and, after the first
> > > appraisal, always allows access to the files without checking metadata
> > > again.
> > 
> > ^after the first successful appraisal
> > >
> > > This patch checks in evm_reset_status() if EVM_ALLOW_METADATA
> > WRITES is
> > > enabled and if it is, sets the IMA_CHANGE_XATTR/ATTR bits depending on
> > the
> > > operation performed. At the next appraisal, metadata are revalidated.
> > 
> > EVM modifying IMA bits crosses the boundary between EVM and IMA.
> > There
> > is already an IMA post_setattr hook.  IMA could reset its own bit
> > there.  If necessary EVM could export as a function it's status info.
> 
> I wouldn't try to guess in IMA when EVM resets its status. We would have
> to duplicate the logic to check if an EVM key is loaded, if the passed xattr
> is a POSIX ACL, ...

Agreed, but IMA could call an EVM function.

> 
> I think it is better to set a flag, maybe a new one, directly in EVM, to notify
> the integrity subsystem that iint->evm_status is no longer valid.
> 
> If the EVM flag is set, IMA would reset the appraisal flags, as it uses
> iint->evm_status for appraisal. We can consider to reset also the measure
> flags when we have a template that includes file metadata.

When would IMA read the EVM flag?   Who would reset the flag?  At what
point would it be reset?   Just as EVM shouldn't be resetting the IMA
flag, IMA shouldn't be resetting the EVM flag.

Mimi

