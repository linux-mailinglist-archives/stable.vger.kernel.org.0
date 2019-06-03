Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A463302C
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 14:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfFCMtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 08:49:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54582 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726713AbfFCMtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 08:49:05 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53Cau5h008913
        for <stable@vger.kernel.org>; Mon, 3 Jun 2019 08:49:04 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sw3q70jgs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 08:49:03 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Mon, 3 Jun 2019 13:49:01 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 13:48:57 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x53Cmu2F50856002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 12:48:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9421BAE051;
        Mon,  3 Jun 2019 12:48:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45E87AE04D;
        Mon,  3 Jun 2019 12:48:55 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.80.245])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 12:48:55 +0000 (GMT)
Subject: Re: [PATCH v2 2/3] ima: don't ignore INTEGRITY_UNKNOWN EVM status
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        dmitry.kasatkin@huawei.com, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Mon, 03 Jun 2019 08:48:44 -0400
In-Reply-To: <e6b31aa9-0319-1805-bdfc-3ddde5884494@huawei.com>
References: <20190529133035.28724-1-roberto.sassu@huawei.com>
         <20190529133035.28724-3-roberto.sassu@huawei.com>
         <1559217621.4008.7.camel@linux.ibm.com>
         <e6b31aa9-0319-1805-bdfc-3ddde5884494@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19060312-0012-0000-0000-0000032257A7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060312-0013-0000-0000-0000215B31B6
Message-Id: <1559566124.4365.65.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030091
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2019-06-03 at 11:25 +0200, Roberto Sassu wrote:
> On 5/30/2019 2:00 PM, Mimi Zohar wrote:
> > On Wed, 2019-05-29 at 15:30 +0200, Roberto Sassu wrote:
> >> Currently, ima_appraise_measurement() ignores the EVM status when
> >> evm_verifyxattr() returns INTEGRITY_UNKNOWN. If a file has a valid
> >> security.ima xattr with type IMA_XATTR_DIGEST or IMA_XATTR_DIGEST_NG,
> >> ima_appraise_measurement() returns INTEGRITY_PASS regardless of the EVM
> >> status. The problem is that the EVM status is overwritten with the
> >>> appraisal status
> > 
> > Roberto, your framing of this problem is harsh and misleading.  IMA
> > and EVM are intentionally independent of each other and can be
> > configured independently of each other.  The intersection of the two
> > is the call to evm_verifyxattr().  INTEGRITY_UNKNOWN is returned for a
> > number of reasons - when EVM is not configured, the EVM hmac key has
> > not yet been loaded, the protected security attribute is unknown, or
> > the file is not in policy.
> > 
> > This patch does not differentiate between any of the above cases,
> > requiring mutable files to always be protected by EVM, when specified
> > as an "ima_appraise=" option on the boot command line.
> > 
> > IMA could be extended to require EVM on a per IMA policy rule basis.
> > Instead of framing allowing IMA file hashes without EVM as a bug that
> > has existed from the very beginning, now that IMA/EVM have matured and
> > is being used, you could frame it as extending IMA or hardening.
> 
> I'm seeing it from the perspective of an administrator that manages an
> already hardened system, and expects that the system only grants access
> to files with a valid signature/HMAC. That system would not enforce this
> behavior if EVM keys are removed and the digest in security.ima is set
> to the actual file digest.
> 
> Framing it as a bug rather than an extension would in my opinion help to
> convince people about the necessity to switch to the safe mode, if their
> system is already hardened.

I don't disagree with you that people should be using EVM to protect
IMA hashes.  If you claim this is a bug in the design from the very
beginning, then there needs some explanation as to why it was
upstreamed as it was.  My review of this patch provided that
context/background.

Mimi

> 
> 
> >> This patch mitigates the issue by selecting signature verification as the
> >> only method allowed for appraisal when EVM is not initialized. Since the
> >> new behavior might break user space, it must be turned on by adding the
> >> '-evm' suffix to the value of the ima_appraise= kernel option.
> >>
> >> Fixes: 2fe5d6def1672 ("ima: integrity appraisal extension")
> >> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> >> Cc: stable@vger.kernel.org
> 

