Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF4E31576D
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 21:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbhBIUEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 15:04:49 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48812 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233755AbhBITvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 14:51:35 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119JgP6q079175;
        Tue, 9 Feb 2021 14:49:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=z8M8GC/vnud9WhkHtY6cAALZNKFHQBkh8OeJZYNyVZg=;
 b=IbfWBSL078+8bQhD9L+d6NIzboZExUvJJip+J5YhLwCUalsdSZnsnP744plJ41AnOkON
 F5agcLQdyMssTF4GvUcMSGEqn+MNOpCbWzDb8+6iHZEE4hroeWz9GHVw5hBJbYpVhjx3
 3XketnJPCyFQVvgpi1q5GbCud9q9QwVSWEDGvgbM6pjJF5+OYTXLulO2JUs2gUeKJbeU
 yTXdHU9Ga62bMOFlT/Cz8C9IazSxDfly333HXRNArvUw6kYmRlMlgbsSdW8vviLcrSzz
 KMnIzbJQeSyu3ZZ4aFqs0Y+zLLDcMS7FRZ+I61uZZWyBtWztXPYPxd9fEIcXPlp6Jw+c 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36m0smr4r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 14:49:01 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119JgYvt079419;
        Tue, 9 Feb 2021 14:49:01 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36m0smr4qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 14:49:01 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119JhFJI031990;
        Tue, 9 Feb 2021 19:49:00 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 36hjr98x2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 19:49:00 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119Jn07A23331072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 19:49:00 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DAB9B2067;
        Tue,  9 Feb 2021 19:49:00 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A502B205F;
        Tue,  9 Feb 2021 19:48:59 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.203.235])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 19:48:59 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH 1/1] s390/vfio-ap: fix circular lockdep when setting/clearing crypto masks
Date:   Tue,  9 Feb 2021 14:48:30 -0500
Message-Id: <20210209194830.20271-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20210209194830.20271-1-akrowiak@linux.ibm.com>
References: <20210209194830.20271-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_06:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090090
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes a circular locking dependency in the CI introduced by
commit f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM
pointer invalidated"). The lockdep only occurs when starting a Secure
Execution guest. Crypto virtualization (vfio_ap) is not yet supported for
SE guests; however, in order to avoid CI errors, this fix is being
provided.

The circular lockdep was introduced when the masks in the guest's APCB
were taken under the matrix_dev->lock. While the lock is definitely
needed to protect the setting/unsetting of the KVM pointer, it is not
necessarily critical for setting the masks, so this will not be done under
protection of the matrix_dev->lock.

Fixes: f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated")
Cc: stable@vger.kernel.org
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 75 ++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 30 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 41fc2e4135fe..f4e19aa2acb9 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -322,6 +322,20 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
+static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
+{
+	return (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd);
+}
+
+static void vfio_ap_mdev_commit_apcb(struct ap_matrix_mdev *matrix_mdev)
+{
+	if (vfio_ap_mdev_has_crycb(matrix_mdev))
+		kvm_arch_crypto_set_masks(matrix_mdev->kvm,
+					  matrix_mdev->matrix.apm,
+					  matrix_mdev->matrix.aqm,
+					  matrix_mdev->matrix.adm);
+}
+
 static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -1028,7 +1042,9 @@ static const struct attribute_group *vfio_ap_mdev_attr_groups[] = {
  * @kvm: reference to KVM instance
  *
  * Verifies no other mediated matrix device has @kvm and sets a reference to
- * it in @matrix_mdev->kvm.
+ * it in @matrix_mdev->kvm. The matrix_dev->lock must not be taken prior to
+ * calling this function; doing so may result in a circular lock dependency
+ * when the kvm->lock is taken to set masks in the guest's APCB.
  *
  * Return 0 if no other mediated matrix device has a reference to @kvm;
  * otherwise, returns an -EPERM.
@@ -1038,6 +1054,8 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 {
 	struct ap_matrix_mdev *m;
 
+	mutex_lock(&matrix_dev->lock);
+
 	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
 		if ((m != matrix_mdev) && (m->kvm == kvm))
 			return -EPERM;
@@ -1046,6 +1064,8 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 	matrix_mdev->kvm = kvm;
 	kvm_get_kvm(kvm);
 	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
+	mutex_unlock(&matrix_dev->lock);
+	vfio_ap_mdev_commit_apcb(matrix_mdev);
 
 	return 0;
 }
@@ -1079,13 +1099,27 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+/**
+ * vfio_ap_mdev_unset_kvm
+ *
+ * @matrix_mdev: a matrix mediated device
+ *
+ * Clears the masks in the guest's APCB as well as the reference to KVM from
+ * @matrix_mdev. The matrix_dev->lock must not be taken prior to calling this
+ * function; doing so may result in a circular lock dependency when the
+ * kvm->lock is taken to clear the masks in the guest's APCB.
+ */
 static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 {
-	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
-	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
-	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
-	kvm_put_kvm(matrix_mdev->kvm);
-	matrix_mdev->kvm = NULL;
+	if (matrix_mdev->kvm) {
+		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
+		mutex_lock(&matrix_dev->lock);
+		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
+		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
+		kvm_put_kvm(matrix_mdev->kvm);
+		matrix_mdev->kvm = NULL;
+		mutex_unlock(&matrix_dev->lock);
+	}
 }
 
 static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
@@ -1098,32 +1132,15 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 		return NOTIFY_OK;
 
 	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
-	mutex_lock(&matrix_dev->lock);
-
-	if (!data) {
-		if (matrix_mdev->kvm)
-			vfio_ap_mdev_unset_kvm(matrix_mdev);
-		goto notify_done;
-	}
 
-	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
-	if (ret) {
-		notify_rc = NOTIFY_DONE;
-		goto notify_done;
-	}
+	if (!data)
+		vfio_ap_mdev_unset_kvm(matrix_mdev);
+	else
+		ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
 
-	/* If there is no CRYCB pointer, then we can't copy the masks */
-	if (!matrix_mdev->kvm->arch.crypto.crycbd) {
+	if (ret)
 		notify_rc = NOTIFY_DONE;
-		goto notify_done;
-	}
-
-	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
-				  matrix_mdev->matrix.aqm,
-				  matrix_mdev->matrix.adm);
 
-notify_done:
-	mutex_unlock(&matrix_dev->lock);
 	return notify_rc;
 }
 
@@ -1257,10 +1274,8 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	mutex_lock(&matrix_dev->lock);
 	if (matrix_mdev->kvm)
 		vfio_ap_mdev_unset_kvm(matrix_mdev);
-	mutex_unlock(&matrix_dev->lock);
 
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
 				 &matrix_mdev->iommu_notifier);
-- 
2.21.1

