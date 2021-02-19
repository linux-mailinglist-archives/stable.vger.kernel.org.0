Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5705831FF25
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 20:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhBSTBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 14:01:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229871AbhBSTBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 14:01:17 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11JIVlfq125303;
        Fri, 19 Feb 2021 14:00:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=kYBrrtSge5RPCw/T4HxQULOmmog1iRXNHvJMgs2CZT4=;
 b=kKAoV2CarNi65lB7bDgJJPVMwt7HpyH8cmsf5+djc2OtQcPjqI0moFMkUkV1jMlc/rUP
 TWa+TwWTBey+dGsOyiZTBqkWNJhKSMQOF7LZhniZaze5x6nrzJvFaYKoJDq2loNMTadm
 VoyrtafisQyyhT5E2nYc4Co8PWVuMwbSSjlUmAagu/+FwbU5WCfswrUKBCo+xBS9EpZC
 6jIdGNBaPZbgDIfHRvsE1dasiW37mTL1kfjO+3lGrYMgsIFo8VbLEXIPX6F9Tp9aDoWX
 wcPYS/V/8ILZm5Z60pecFpFr8nlkp35GJGdpWFqz/4hCJ28Rbm8Mq+ot+tlcQjWXsPLl UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36tgvqmg62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Feb 2021 14:00:35 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11JIaEqT140149;
        Fri, 19 Feb 2021 14:00:34 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36tgvqmg4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Feb 2021 14:00:34 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11JIw72s008348;
        Fri, 19 Feb 2021 19:00:32 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 36p6d8dtku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Feb 2021 19:00:31 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11JJ0Tf52753092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 19:00:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBD87AE055;
        Fri, 19 Feb 2021 19:00:28 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A2B6AE045;
        Fri, 19 Feb 2021 19:00:28 +0000 (GMT)
Received: from localhost (unknown [9.171.86.198])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 19 Feb 2021 19:00:28 +0000 (GMT)
Date:   Fri, 19 Feb 2021 20:00:24 +0100
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] virtio/s390: implement virtio-ccw revision 2 correctly
Message-ID: <your-ad-here.call-01613761224-ext-6505@work.hours>
References: <20210216110645.1087321-1-cohuck@redhat.com>
 <20210219173828.6a2ab5d4.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210219173828.6a2ab5d4.cohuck@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-19_08:2021-02-18,2021-02-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=842
 clxscore=1011 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190142
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 19, 2021 at 05:38:28PM +0100, Cornelia Huck wrote:
> I was thinking of queuing this, but maybe it is quicker to pick it into
> the s390 tree directly and save us the extra pull request dance?
> Especially as this is a stable-worthy bugfix.

Yes, sure. I'll pick it up. Thanks.
