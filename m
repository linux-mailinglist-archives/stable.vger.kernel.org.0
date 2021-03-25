Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFF8349B03
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 21:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhCYUcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 16:32:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229977AbhCYUcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 16:32:20 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PK5MPi112725;
        Thu, 25 Mar 2021 16:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=oEpHvDI3puLg+Vq05BFMSURNGiOqUaXOZOQzdNfRnn8=;
 b=VsjPK/h/a14XiyiZzBLZYZnGWylzon8Hh/Awb8F1M7OwOD9WKnmYH6Nc2Zp/f9g8u+TJ
 CFFFVQLuxJqZs7mupOr9BbYgmPIwZMa9U5l+FiXwHZadc2eDRPP557qYaXnnI8eW939c
 CbY/rVGxgKk5AfCaanpZ7cWWfygHvyesgUvySULy0qZ1cmIreV1WbHrFdQNOxHX5JurH
 h/fVlEeOFi5T4OdQtKw3YmA3z2hFfruTlp1Tub1PoGKeby7RjDYHhSDwqSvbcXj0J4ao
 /sD15n1E2acERF+wOA+J5S4fApwZalWfDp/iWKeLEIYsPW7xdff64NsRp3OqaLpAlLe5 nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37h18egr2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 16:32:18 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PK5jpV114396;
        Thu, 25 Mar 2021 16:32:17 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37h18egr17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 16:32:17 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PKRdK4025569;
        Thu, 25 Mar 2021 20:32:15 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 37h15100pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 20:32:15 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PKVsF835455354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 20:31:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E71EFA4053;
        Thu, 25 Mar 2021 20:32:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 306E2A4051;
        Thu, 25 Mar 2021 20:32:12 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.84.230])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 25 Mar 2021 20:32:12 +0000 (GMT)
Date:   Thu, 25 Mar 2021 21:32:10 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v5 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210325213210.62cb11b9.pasic@linux.ibm.com>
In-Reply-To: <20210325124640.23995-2-akrowiak@linux.ibm.com>
References: <20210325124640.23995-1-akrowiak@linux.ibm.com>
        <20210325124640.23995-2-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5qRJTkiymQM0dqZpHznUPt1kLU6qfsUH
X-Proofpoint-GUID: QXXZp66eNcmEuopvnEsEfdxFpPwpWzli
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_07:2021-03-25,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 mlxscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103250146
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Mar 2021 08:46:40 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> This patch fixes a lockdep splat introduced by commit f21916ec4826
> ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated").
> The lockdep splat only occurs when starting a Secure Execution guest.
> Crypto virtualization (vfio_ap) is not yet supported for SE guests;
> however, in order to avoid this problem when support becomes available,
> this fix is being provided.
> 
> The circular locking dependency was introduced when the setting of the
> masks in the guest's APCB was executed while holding the matrix_dev->lock.
> While the lock is definitely needed to protect the setting/unsetting of the
> matrix_mdev->kvm pointer, it is not necessarily critical for setting the
> masks; so, the matrix_dev->lock will be released while the masks are being
> set or cleared.
> 
> Keep in mind, however, that another process that takes the matrix_dev->lock
> can get control while the masks in the guest's APCB are being set or
> cleared as a result of the driver being notified that the KVM pointer
> has been set or unset. This could result in invalid access to the
> matrix_mdev->kvm pointer by the intervening process. To avoid this
> scenario, two new fields are being added to the ap_matrix_mdev struct:
> 
> struct ap_matrix_mdev {
> 	...
> 	bool kvm_busy;
> 	wait_queue_head_t wait_for_kvm;
>    ...
> };
> 
> The functions that handle notification that the KVM pointer value has
> been set or cleared will set the kvm_busy flag to true until they are done
> processing at which time they will set it to false and wake up the tasks on
> the matrix_mdev->wait_for_kvm wait queue. Functions that require
> access to matrix_mdev->kvm will sleep on the wait queue until they are
> awakened at which time they can safely access the matrix_mdev->kvm
> field.
> 
> Fixes: f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

I intend to give a couple of work-days to others, and if nobody objects
merge this. (I will wait till Tuesday.)

I've tested it and it does silence the lockdep splat.

Regards,
Halil
