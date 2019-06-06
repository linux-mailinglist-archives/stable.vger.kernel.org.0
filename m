Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8BB93771F
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 16:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfFFOuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 10:50:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36298 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728508AbfFFOuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 10:50:17 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56EZVab098772
        for <stable@vger.kernel.org>; Thu, 6 Jun 2019 10:50:16 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sy41vu5rg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 10:50:15 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Thu, 6 Jun 2019 15:50:13 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 15:50:09 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56Eo82q45809782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 14:50:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 765A94C058;
        Thu,  6 Jun 2019 14:50:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AAF74C044;
        Thu,  6 Jun 2019 14:50:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.80.30])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jun 2019 14:50:07 +0000 (GMT)
Subject: Re: [PATCH v3 0/2] ima/evm fixes for v5.2
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        dmitry.kasatkin@huawei.com, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        silviu.vlasceanu@huawei.com
Date:   Thu, 06 Jun 2019 10:49:56 -0400
In-Reply-To: <3711f387-3aef-9fbb-1bb4-dded6807b033@huawei.com>
References: <20190606112620.26488-1-roberto.sassu@huawei.com>
         <3711f387-3aef-9fbb-1bb4-dded6807b033@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19060614-0012-0000-0000-00000325A790
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060614-0013-0000-0000-0000215E8FBB
Message-Id: <1559832596.4278.124.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060102
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-06-06 at 13:43 +0200, Roberto Sassu wrote:
> On 6/6/2019 1:26 PM, Roberto Sassu wrote:
> > Previous versions included the patch 'ima: don't ignore INTEGRITY_UNKNOWN
> > EVM status'. However, I realized that this patch cannot be accepted alone
> > because IMA-Appraisal would deny access to new files created during the
> > boot. With the current behavior, those files are accessible because they
> > have a valid security.ima (not protected by EVM) created after the first
> > write.
> > 
> > A solution for this problem is to initialize EVM very early with a random
> > key. Access to created files will be granted, even with the strict
> > appraisal, because after the first write those files will have both
> > security.ima and security.evm (HMAC calculated with the random key).
> > 
> > Strict appraisal will work only if it is done with signatures until the
> > persistent HMAC key is loaded.
> 
> Changelog
> 
> v2:
> - remove patch 1/3 (evm: check hash algorithm passed to init_desc());
>    already accepted
> - remove patch 3/3 (ima: show rules with IMA_INMASK correctly);
>    already accepted
> - add new patch (evm: add option to set a random HMAC key at early boot)
> - patch 2/3: modify patch description

Roberto, as I tried explaining previously, this feature is not a
simple bug fix.  These patches, if upstreamed, will be upstreamed the
normal way, during an open window.  Whether they are classified as a
bug fix has yet to be decided.

Please stop Cc'ing stable.  If I don't Cc stable before sending the pull request, then Greg and Sasha have been really good about deciding which patches should be backported.  (Please refer to the comment on "Cc'ing stable" in section "5) Select the recipients for your patch" in Documentation/process/submitting-patches.rst.)

I'll review these patches, but in the future please use an appropriate patch set cover letter title in the subject line.

thanks,

Mimi


> 
> v1:
> - remove patch 2/4 (evm: reset status in evm_inode_post_setattr()); file
>    attributes cannot be set if the signature is portable and immutable
> - patch 3/4: add __ro_after_init to ima_appraise_req_evm variable
>    declaration
> - patch 3/4: remove ima_appraise_req_evm kernel option and introduce
>    'enforce-evm' and 'log-evm' as possible values for ima_appraise=
> - remove patch 4/4 (ima: only audit failed appraisal verifications)
> - add new patch (ima: show rules with IMA_INMASK correctly)
> 
> 
> > Roberto Sassu (2):
> >    evm: add option to set a random HMAC key at early boot
> >    ima: add enforce-evm and log-evm modes to strictly check EVM status
> > 
> >   .../admin-guide/kernel-parameters.txt         | 11 ++--
> >   security/integrity/evm/evm.h                  | 10 +++-
> >   security/integrity/evm/evm_crypto.c           | 57 ++++++++++++++++---
> >   security/integrity/evm/evm_main.c             | 41 ++++++++++---
> >   security/integrity/ima/ima_appraise.c         |  8 +++
> >   security/integrity/integrity.h                |  1 +
> >   6 files changed, 106 insertions(+), 22 deletions(-)
> > 
> 

