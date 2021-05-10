Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCC7377D54
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 09:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhEJHn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 03:43:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26268 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229852AbhEJHn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 03:43:57 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14A7XfYr156227;
        Mon, 10 May 2021 03:42:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1F2WCDyQaFSBBmgHCEPnVEfRBFVqXlAWW3A5JGbRtYI=;
 b=h0XB8g0JNys/xpufjwXvOVlbeSfraB+MwGO4grHE4NLmphN8+leMd8cDK3e8UhRddw3e
 SG3zUdVuZabFwNH3hjTkeMFgfzDttVnO49AwUMCceKZgRbYoyn5N6SRqKnmHEcQCdit/
 0eu/ecHx9bx/c56OOi7lncEhDH4w1AIqajP+bhkdApPHj1PzPvdbdOnCT6/kAqy1icbN
 ph3sEGNwnBgnuqQxyeu7NaPhUz13dj5gfDN5UAVHJwk7gOod1WM6nZpxxHA5awK6be73
 x7EpG9+49xMHQrbh0xBBKkyz5+WLeeWC9tSKl7+To3YUZFPCmP7pOOqPo5uYMBDykTi1 WA== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f0j388g4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 03:42:52 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14A7fTfR013821;
        Mon, 10 May 2021 07:42:49 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 38ef37g66e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 07:42:49 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14A7gloD33096158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 07:42:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6722D42054;
        Mon, 10 May 2021 07:42:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3427B42056;
        Mon, 10 May 2021 07:42:47 +0000 (GMT)
Received: from sig-9-145-37-150.uk.ibm.com (unknown [9.145.37.150])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 07:42:47 +0000 (GMT)
Message-ID: <57af9bf26f6cb7f33a2f81bab1a0b8254c98d159.camel@linux.ibm.com>
Subject: Re: Patch "s390/pci: expose UID uniqueness guarantee" has been
 added to the 5.12-stable tree
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Date:   Mon, 10 May 2021 09:42:46 +0200
In-Reply-To: <20210508032523.30E2D61400@mail.kernel.org>
References: <20210508032523.30E2D61400@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: l6o-_IlohAqgP4PiaL28nEBEazxBMERI
X-Proofpoint-ORIG-GUID: l6o-_IlohAqgP4PiaL28nEBEazxBMERI
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_02:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 clxscore=1011 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100053
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-05-07 at 23:25 -0400, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     s390/pci: expose UID uniqueness guarantee
> 
> to the 5.12-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      s390-pci-expose-uid-uniqueness-guarantee.patch
> and it can be found in the queue-5.12 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> 
> commit 7b9825aa0891087c5c91be0fb75431919e2027e3
> Author: Niklas Schnelle <schnelle@linux.ibm.com>
> Date:   Wed Feb 24 11:29:36 2021 +0100
> 
>     s390/pci: expose UID uniqueness guarantee
>     
>     [ Upstream commit 408f2c9c15682fc21b645fdec1f726492e235c4b ]
>     
>     On s390 each PCI device has a user-defined ID (UID) exposed under
>     /sys/bus/pci/devices/<dev>/uid. This ID was designed to serve as the PCI
>     device's primary index and to match the device within Linux to the
>     device configured in the hypervisor. To serve as a primary identifier
>     the UID must be unique within the Linux instance, this is guaranteed by
>     the platform if and only if the UID Uniqueness Checking flag is set
>     within the CLP List PCI Functions response.
>     
>     While the UID has been exposed to userspace since commit ac4995b9d570
>     ("s390/pci: add some new arch specific pci attributes") whether or not
>     the platform guarantees its uniqueness for the lifetime of the Linux
>     instance while defined is not visible from userspace. Remedy this by
>     exposing this as a per device attribute at
>     
>     /sys/bus/pci/devices/<dev>/uid_is_unique
>     
>     Keeping this a per device attribute allows for maximum flexibility if we
>     ever end up with some devices not having a UID or not enjoying the
>     guaranteed uniqueness.
>     
>     Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
>     Reviewed-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
>     Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> 

Hi Sasha,

I think we should not backport this patch to the stable kernels either
5.12, 5.11 nor 5.10.

The reason is that I'd like this staty together with commit
81bbf03905aa ("s390/pci: expose a PCI device's UID as its index") since
this then allows to reason that if uid_is_unique is 1 that implies that
the index attribute must exist. On the other hand backporting the other
patch too  would create new network interface names. I reckon that
there would be some value for the uid_is_unique attribute alone but I
think it's not worth having more possible scenarios.

Thanks,
Niklas Schnelle

