Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0A731C4ED
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 02:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBPBQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 20:16:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14760 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229796AbhBPBQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 20:16:43 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11G11bNm002079;
        Mon, 15 Feb 2021 20:15:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=gU4FNIphuUI1q38DRUTcXAriUiExmJdHEkApVL/gVdU=;
 b=ehKGnKc35FezKoeEpXjh2mz4jdRjCR/lYpo97aMuZJNPjxf4SvJ/mys2bgW5QDekbrDr
 ibbcMlkkH0YxwMVfJETBr1OeZu5AgOLlWy2mPZBUn8XDKjaiXdhsmO0Sx2qBwq1HyXeu
 AS686W4kAKr3Rf0NyHAXizVY60k+EcyuMr9EDDSkeOIXjFs7Ik35080rTAJXXNc3K9dA
 6/7va8qEQnggKJ1+9/TT52dopzO6GDO7h0+wt7S0uY+EfLGMWiU1vOM5W9cJO4af6W2K
 /pEnrdqKIu99ROitG/g3pPu91AVRVhTLZ8MbkhF6VzE1SRXt1KnaDsrEYMQVhVZSoIjS Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36r2dwadac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 20:15:56 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11G14di3015818;
        Mon, 15 Feb 2021 20:15:56 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36r2dwada2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 20:15:55 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11G1Biw2004463;
        Tue, 16 Feb 2021 01:15:55 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04wdc.us.ibm.com with ESMTP id 36p6d8tx9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 01:15:55 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11G1FsBh30933426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Feb 2021 01:15:54 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA1822805E;
        Tue, 16 Feb 2021 01:15:54 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17A8E28058;
        Tue, 16 Feb 2021 01:15:54 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.203.235])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Feb 2021 01:15:53 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v2 0/1] s390/vfio-ap: fix circular lockdep when staring SE guest
Date:   Mon, 15 Feb 2021 20:15:46 -0500
Message-Id: <20210216011547.22277-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-15_16:2021-02-12,2021-02-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160003
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM
pointer invalidated") introduced a change that results in a circular
lockdep when a Secure Execution guest that is configured with
crypto devices is started. The problem resulted due to the fact that the
patch moved the setting of the guest's AP masks within the protection of
the matrix_dev->lock when the vfio_ap driver is notified that the KVM 
pointer has been set. Since it is not critical that setting/clearing of
the guest's AP masks be done under the matrix_dev->lock when the driver is
notified, the masks will not be updated under the matrix_dev->lock. The
lock is necessary for the setting/unsetting of the KVM pointer, however,
so that will remain in place. 

The dependency chain for the circular lockdep resolved by this patch 
is (in reverse order):

2:	vfio_ap_mdev_group_notifier:	kvm->lock
					matrix_dev->lock

1:	handle_pqap:			matrix_dev->lock
	kvm_vcpu_ioctl:			vcpu->mutex

0:	kvm_s390_cpus_to_pv:		vcpu->mutex
	kvm_vm_ioctl:  			kvm->lock

Please note that if checkpatch is run against this patch series, you may
get a "WARNING: Unknown commit id 'f21916ec4826', maybe rebased or not 
pulled?" message. The commit 'f21916ec4826', however, is definitely
in the master branch on top of which this patch series was built, so I'm
not sure why this message is being output by checkpatch. 

Change log v1=> v2:
------------------
* No longer holding the matrix_dev->lock prior to setting/clearing the
  masks supplying the AP configuration to a KVM guest.
* Make all updates to the data in the matrix mdev that is used to manage
  AP resources used by the KVM guest in the vfio_ap_mdev_set_kvm() function
  instead of the group notifier callback.
* Check for the matrix mdev's KVM pointer in the vfio_ap_mdev_unset_kvm()
  function instead of the vfio_ap_mdev_release() function.

Tony Krowiak (1):
  s390/vfio-ap: fix circular lockdep when setting/clearing crypto masks

 drivers/s390/crypto/vfio_ap_ops.c | 119 +++++++++++++++++++++---------
 1 file changed, 84 insertions(+), 35 deletions(-)

-- 
2.21.1

