Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57ADF2E0088
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 19:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgLUS5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 13:57:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbgLUS5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 13:57:16 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BLIht5P076431;
        Mon, 21 Dec 2020 13:56:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=kbzJ7ryv5p0ZhVmMAUh4iYRadSfOtNqvQimC3qmEzr4=;
 b=NYwSTIrM6c5YtXbTQWRM78oYqSJTJwQXBzEWD0WWdK9oQIgGUtX2/CkoCJ2h6GAbhRNd
 aJJCzrCymeb8yKyo8ae6YaAGeAQP8yNIqSCp4vWkxsH/FaSUu88hchdhNCsZ/iy/9v+q
 c46GxlWwNzM4eHAMlh7gyTDIgbHIDhBpUDfQNwEyyPWEU0M944cyQ8o2xI0mNdJ7NgZ9
 CUbDztWXv7KksgOtGJWq+5khidr3Hm2gcbdx6rAa7DF8pHoPbpI3GyIAo1/1dGR+IQCo
 8xQ30G3YZ2Rbj/Cv/+RpIUcMgIutruwfeCPJB1wU+TOMaVzzn+ApLGLXEkA0bhkCTz4F 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35k181r9mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Dec 2020 13:56:35 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BLIiUt3080528;
        Mon, 21 Dec 2020 13:56:35 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35k181r9mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Dec 2020 13:56:35 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BLIr7kp031425;
        Mon, 21 Dec 2020 18:56:34 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02dal.us.ibm.com with ESMTP id 35h958wn7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Dec 2020 18:56:34 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BLIuWWL19857870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Dec 2020 18:56:32 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E26F6E04C;
        Mon, 21 Dec 2020 18:56:32 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F9AF6E04E;
        Mon, 21 Dec 2020 18:56:31 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.193.150])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 21 Dec 2020 18:56:31 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: [PATCH v4] s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated
Date:   Mon, 21 Dec 2020 13:56:25 -0500
Message-Id: <20201221185625.24914-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-21_10:2020-12-21,2020-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 phishscore=0 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210128
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The vfio_ap device driver registers a group notifier with VFIO when the
file descriptor for a VFIO mediated device for a KVM guest is opened to
receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
event). When the KVM pointer is set, the vfio_ap driver takes the
following actions:
1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
   of the mediated device.
2. Calls the kvm_get_kvm() function to increment its reference counter.
3. Sets the function pointer to the function that handles interception of
   the instruction that enables/disables interrupt processing.
4. Sets the masks in the KVM guest's CRYCB to pass AP resources through to
   the guest.

In order to avoid memory leaks, when the notifier is called to receive
notification that the KVM pointer has been set to NULL, the vfio_ap device
driver should reverse the actions taken when the KVM pointer was set.

Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
Cc: stable@vger.kernel.org
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 42 +++++++++++++++++--------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e0bde8518745..44f3378540d5 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1037,19 +1037,14 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 {
 	struct ap_matrix_mdev *m;
 
-	mutex_lock(&matrix_dev->lock);
-
 	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
-		if ((m != matrix_mdev) && (m->kvm == kvm)) {
-			mutex_unlock(&matrix_dev->lock);
+		if ((m != matrix_mdev) && (m->kvm == kvm))
 			return -EPERM;
-		}
 	}
 
 	matrix_mdev->kvm = kvm;
 	kvm_get_kvm(kvm);
 	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
-	mutex_unlock(&matrix_dev->lock);
 
 	return 0;
 }
@@ -1083,35 +1078,49 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
+{
+	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
+	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
+	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
+	kvm_put_kvm(matrix_mdev->kvm);
+	matrix_mdev->kvm = NULL;
+}
+
 static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 				       unsigned long action, void *data)
 {
-	int ret;
+	int ret, notify_rc = NOTIFY_DONE;
 	struct ap_matrix_mdev *matrix_mdev;
 
 	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
 		return NOTIFY_OK;
 
 	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
+	mutex_lock(&matrix_dev->lock);
 
 	if (!data) {
-		matrix_mdev->kvm = NULL;
-		return NOTIFY_OK;
+		if (matrix_mdev->kvm)
+			vfio_ap_mdev_unset_kvm(matrix_mdev);
+		notify_rc = NOTIFY_OK;
+		goto notify_done;
 	}
 
 	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
 	if (ret)
-		return NOTIFY_DONE;
+		goto notify_done;
 
 	/* If there is no CRYCB pointer, then we can't copy the masks */
 	if (!matrix_mdev->kvm->arch.crypto.crycbd)
-		return NOTIFY_DONE;
+		goto notify_done;
 
 	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
 				  matrix_mdev->matrix.aqm,
 				  matrix_mdev->matrix.adm);
 
-	return NOTIFY_OK;
+notify_done:
+	mutex_unlock(&matrix_dev->lock);
+	return notify_rc;
 }
 
 static void vfio_ap_irq_disable_apqn(int apqn)
@@ -1222,13 +1231,8 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
 	mutex_lock(&matrix_dev->lock);
-	if (matrix_mdev->kvm) {
-		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
-		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
-		vfio_ap_mdev_reset_queues(mdev);
-		kvm_put_kvm(matrix_mdev->kvm);
-		matrix_mdev->kvm = NULL;
-	}
+	if (matrix_mdev->kvm)
+		vfio_ap_mdev_unset_kvm(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
-- 
2.21.1

