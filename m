Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E30732B2DB
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344211AbhCCAyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30200 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347714AbhCBUqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 15:46:10 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122KikOc125081;
        Tue, 2 Mar 2021 15:45:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=i2kvvKV8YkI3FIKc2WLAgthz4xGwzpGL2uBfqaKoBgQ=;
 b=Q31pWqt/6r8ME6Q2YxafHOQzl2WjvAUBs8jmYh6mFKnhj/Bz0NMiAvR3kaw16UfpgbmW
 Ul240Ii7O178xskcdpRvefh29GiU6PtVMLvrZv8+dVsWUpOGnh31PNT4iVAArHdQ8V3k
 E+mKGkfJKgtZ7NQurMCUHuQ/urTO0rEJiJKevCKsQhcCD507K3tyxcPJhDtYy3HSpAbp
 m05bjn2QSGr4UofYw9//SNB3D7CvAlzVaqYXt4aHcAxtOA2JfAfPiAop/t48dPGfgMei
 /95nZ7El3rWTjTMTffQvFSR/zDorvsT2k2L9P2Dkpo3P/zMlK4nr0HAHx0e+hEYanUUd ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371vnt00cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 15:45:03 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 122Kj2ea127175;
        Tue, 2 Mar 2021 15:45:02 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371vnt0043-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 15:45:02 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122KhChr004042;
        Tue, 2 Mar 2021 20:43:42 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 37103w5r0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 20:43:42 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122Khe5N38011334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 20:43:40 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0BE278060;
        Tue,  2 Mar 2021 20:43:40 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED9237805C;
        Tue,  2 Mar 2021 20:43:38 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.150.254])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  2 Mar 2021 20:43:38 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v3 0/1] s390/vfio-ap: fix circular lockdep when starting SE guest
Date:   Tue,  2 Mar 2021 15:43:21 -0500
Message-Id: <20210302204322.24441-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 adultscore=0 spamscore=0 phishscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020156
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

*Commit f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM
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

Please note:
-----------
* If checkpatch is run against this patch series, you may
  get a "WARNING: Unknown commit id 'f21916ec4826', maybe rebased or not 
  pulled?" message. The commit 'f21916ec4826', however, is definitely
  in the master branch on top of which this patch series was built, so I'm
 not sure why this message is being output by checkpatch.
* All acks granted from previous review of this patch have been removed due
  to the fact that this patch introduces non-trivial changes (see change
  log below).

Change log v2=> v3:
------------------ 
* Added two fields - 'bool kvm_busy' and 'wait_queue_head_t wait_for_kvm' -
  fields to struct ap_matrix_mdev. The former indicates that the KVM
  pointer is in the process of being updated and the second allows a
  function that needs access to the KVM pointer to wait until it is
  no longer being updated. Resolves problem of synchronization between
  the functions that change the KVM pointer value and the functions that
  required access to it.

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

 drivers/s390/crypto/vfio_ap_ops.c     | 312 ++++++++++++++++++--------
 drivers/s390/crypto/vfio_ap_private.h |   2 +
 2 files changed, 218 insertions(+), 96 deletions(-)

-- 
2.21.3

