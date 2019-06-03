Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD3C3320F
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 16:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfFCOYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 10:24:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37028 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbfFCOYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 10:24:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53EOKe1153232;
        Mon, 3 Jun 2019 14:24:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=f/3shJw30h+WPErENrMOOkyLDOALkiWq64WdWc2LbQk=;
 b=lpDfhW7vcM3NqgOU20G8JwmRYda5o7+JCmgmlR1EiI3PUxdJ9OVVc3oQRzEGVqgk43ee
 Oj+SvO7mPkDoXfLtWF5vdMomW6QQjyClLKY2KXKM+RXHuSH7wB2b4Ef9hIzQjwRta7vZ
 TC+pssiOGIrHvb4n/+nGSWNuHHnSjCHNS82tYfxDPscbn/L8Lwn8nP/YmxxTgyFgb3Z3
 8RK9nvoH5S3BllsWzAnMFZtzIdQ+uSUNBQk1u1WqS46fi3dQJx+BfJS2thYhDnmDj3gr
 nMs1yp3sE6KBEFM58xl7YkixKe5qSgtbjyYvP3jL3tLXM1kMEp0ys5QAM/cM2RUiueHA Qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2suj0q78em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jun 2019 14:24:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53EOZKb010822;
        Mon, 3 Jun 2019 14:24:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2sv36s8d9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jun 2019 14:24:36 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x53EOTPb026124;
        Mon, 3 Jun 2019 14:24:30 GMT
Received: from anon-dhcp-171.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Jun 2019 07:24:29 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v2 2/3] ima: don't ignore INTEGRITY_UNKNOWN EVM status
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <1559569401.5052.17.camel@HansenPartnership.com>
Date:   Mon, 3 Jun 2019 10:24:27 -0400
Cc:     Mimi Zohar <zohar@linux.ibm.com>, dmitry.kasatkin@huawei.com,
        Matthew Garrett <mjg59@google.com>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        silviu.vlasceanu@huawei.com, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8658CD39-B977-41A7-841B-D209AE05D9C0@oracle.com>
References: <20190529133035.28724-1-roberto.sassu@huawei.com>
 <20190529133035.28724-3-roberto.sassu@huawei.com>
 <1559217621.4008.7.camel@linux.ibm.com>
 <e6b31aa9-0319-1805-bdfc-3ddde5884494@huawei.com>
 <1559569401.5052.17.camel@HansenPartnership.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Roberto Sassu <roberto.sassu@huawei.com>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9276 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906030102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9276 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906030102
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jun 3, 2019, at 9:43 AM, James Bottomley =
<James.Bottomley@HansenPartnership.com> wrote:
>=20
> On Mon, 2019-06-03 at 11:25 +0200, Roberto Sassu wrote:
>> On 5/30/2019 2:00 PM, Mimi Zohar wrote:
>>> On Wed, 2019-05-29 at 15:30 +0200, Roberto Sassu wrote:
>>>> Currently, ima_appraise_measurement() ignores the EVM status when
>>>> evm_verifyxattr() returns INTEGRITY_UNKNOWN. If a file has a
>>>> valid security.ima xattr with type IMA_XATTR_DIGEST or
>>>> IMA_XATTR_DIGEST_NG, ima_appraise_measurement() returns
>>>> INTEGRITY_PASS regardless of the EVM status. The problem is that
>>>> the EVM status is overwritten with the appraisal statu
>>>=20
>>> Roberto, your framing of this problem is harsh and misleading.  IMA
>>> and EVM are intentionally independent of each other and can be
>>> configured independently of each other.  The intersection of the
>>> two is the call to evm_verifyxattr().  INTEGRITY_UNKNOWN is
>>> returned for a number of reasons - when EVM is not configured, the
>>> EVM hmac key has not yet been loaded, the protected security
>>> attribute is unknown, or the file is not in policy.
>>>=20
>>> This patch does not differentiate between any of the above cases,
>>> requiring mutable files to always be protected by EVM, when
>>> specified as an "ima_appraise=3D" option on the boot command line.
>>>=20
>>> IMA could be extended to require EVM on a per IMA policy rule
>>> basis. Instead of framing allowing IMA file hashes without EVM as a
>>> bug that has existed from the very beginning, now that IMA/EVM have
>>> matured and is being used, you could frame it as extending IMA
>>> or hardening.
>>=20
>> I'm seeing it from the perspective of an administrator that manages
>> an already hardened system, and expects that the system only grants
>> access to files with a valid signature/HMAC. That system would not
>> enforce this behavior if EVM keys are removed and the digest in
>> security.ima is set to the actual file digest.
>>=20
>> Framing it as a bug rather than an extension would in my opinion help
>> to convince people about the necessity to switch to the safe mode, if
>> their system is already hardened.
>=20
> I have a use case for IMA where I use it to enforce immutability of
> containers.  In this use case, the cluster admin places hashes on
> executables as the image is unpacked so that if an executable file is
> changed, IMA will cause an execution failure.  For this use case, I
> don't care about the EVM, in fact we don't use it, because the only
> object is to fail execution if a binary is mutated.
>=20
> So I can see your use case requires IMA+EVM, but requiring it would
> cause more complexity for my use case.

... and would not work at all for the current NFS IMA implementation.


--
Chuck Lever



