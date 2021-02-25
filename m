Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF7632587C
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 22:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhBYVR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 16:17:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40094 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231895AbhBYVRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 16:17:21 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PL9DpU163877
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 16:16:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WKFHey0X/JYxRihmeIP9qHqH69ZXzRAa4NJXDbgbbdw=;
 b=DjF/mWKxuzLAP4dRmemaE2MTC1rESrg1fX65HFT48VJTBZ8QoZpd9n0qVYMz3zWa3UhO
 JrFGOfraUF5Y1dPNrkzaSbWMek7Aw0a/OHQQvk/DW2g/VEu8Z3HeK89jmEHnFAIzUAE9
 zeCq+5czkx7c6cidErY/8ao1v0lTpLQf2/OKXVoHfHhfYYeQyX8SRkpQoO3AIc3DQnqn
 8I4SgT8aZs5M4NSgHzff7mxm16eOVFVnm5jpVaYsvyMaWKm4A8mQ7/fYrEC+GcW3XrxF
 iHY6cCTtKzSrb3rhg6crapinAAYZx3/Wfvlj1AQFOlCxBSuqGJLjlddGnNVZiVDQZIML gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xk6dgt2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 16:16:38 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11PL9qQT167901
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 16:16:38 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xk6dgt27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 16:16:38 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11PL85Hj027941;
        Thu, 25 Feb 2021 21:16:38 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 36tt29hqkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 21:16:38 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11PLGa5N28246344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 21:16:36 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C24F2C6055;
        Thu, 25 Feb 2021 21:16:36 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DB9AC6059;
        Thu, 25 Feb 2021 21:16:36 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.150.254])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 25 Feb 2021 21:16:36 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     pasic@linux.ibm.com
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, stable@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [RFC 1/1] s390/vfio-ap: fix circular lockdep when setting/clearing crypto masks
Date:   Thu, 25 Feb 2021 16:16:28 -0500
Message-Id: <20210225211628.30690-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20210225211628.30690-1-akrowiak@linux.ibm.com>
References: <20210225211628.30690-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_14:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102250161
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
Acked-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 169 ++++++++++++++++++--------
 drivers/s390/crypto/vfio_ap_private.h |   1 +
 2 files changed, 122 insertions(+), 48 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 41fc2e4135fe..82b204f573b7 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -294,6 +294,21 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
 				   struct ap_matrix_mdev, pqap_hook);
 
+	/*
+	 * If the KVM pointer is in the process of being set, wait until the
+	 * process has completed. Unlock the matrix_dev->lock while waiting to
+	 * allow the value of the KVM pointer to be set.
+	 */
+	while (matrix_mdev->kvm_busy) {
+		mutex_unlock(&matrix_dev->lock);
+		msleep(100);
+		mutex_lock(&matrix_dev->lock);
+	}
+
+	/* If the there is no guest using the mdev, there is nothing to do */
+	if (!matrix_mdev->kvm)
+		goto out_unlock;
+
 	q = vfio_ap_get_queue(matrix_mdev, apqn);
 	if (!q)
 		goto out_unlock;
@@ -350,8 +365,11 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 static int vfio_ap_mdev_remove(struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
-
-	if (matrix_mdev->kvm)
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * removal of the mdev
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm)
 		return -EBUSY;
 
 	mutex_lock(&matrix_dev->lock);
@@ -606,8 +624,11 @@ static ssize_t assign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of adapter */
-	if (matrix_mdev->kvm)
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of adapter
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm)
 		return -EBUSY;
 
 	ret = kstrtoul(buf, 0, &apid);
@@ -672,8 +693,11 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of adapter */
-	if (matrix_mdev->kvm)
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of adapter
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm)
 		return -EBUSY;
 
 	ret = kstrtoul(buf, 0, &apid);
@@ -753,8 +777,11 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	/* If the guest is running, disallow assignment of domain */
-	if (matrix_mdev->kvm)
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of domain
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm)
 		return -EBUSY;
 
 	ret = kstrtoul(buf, 0, &apqi);
@@ -814,8 +841,11 @@ static ssize_t unassign_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of domain */
-	if (matrix_mdev->kvm)
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of domain
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm)
 		return -EBUSY;
 
 	ret = kstrtoul(buf, 0, &apqi);
@@ -858,8 +888,11 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of control domain */
-	if (matrix_mdev->kvm)
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of control domain
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm)
 		return -EBUSY;
 
 	ret = kstrtoul(buf, 0, &id);
@@ -908,8 +941,11 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	/* If the guest is running, disallow un-assignment of control domain */
-	if (matrix_mdev->kvm)
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of control domain
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm)
 		return -EBUSY;
 
 	ret = kstrtoul(buf, 0, &domid);
@@ -1027,8 +1063,15 @@ static const struct attribute_group *vfio_ap_mdev_attr_groups[] = {
  * @matrix_mdev: a mediated matrix device
  * @kvm: reference to KVM instance
  *
- * Verifies no other mediated matrix device has @kvm and sets a reference to
- * it in @matrix_mdev->kvm.
+ * Sets all data for @matrix_mdev that are needed to manage AP resources
+ * for the guest whose state is represented by @kvm.
+ *
+ * Note: The matrix_dev->lock must be taken prior to calling
+ * this function; however, the lock will be temporarily released while the
+ * guest's AP configuration is set to avoid a potential lockdep splat.
+ * The kvm->lock is taken to set the guest's AP configuration which, under
+ * certain circumstances, will result in a circular lock dependency if this is
+ * done under the @matrix_mdev->lock.
  *
  * Return 0 if no other mediated matrix device has a reference to @kvm;
  * otherwise, returns an -EPERM.
@@ -1043,9 +1086,18 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 			return -EPERM;
 	}
 
-	matrix_mdev->kvm = kvm;
-	kvm_get_kvm(kvm);
-	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
+	if (kvm->arch.crypto.crycbd) {
+		matrix_mdev->kvm_busy = true;
+		kvm_get_kvm(kvm);
+		mutex_unlock(&matrix_dev->lock);
+		kvm_arch_crypto_set_masks(kvm,
+					  matrix_mdev->matrix.apm,
+					  matrix_mdev->matrix.aqm,
+					  matrix_mdev->matrix.adm);
+		mutex_lock(&matrix_dev->lock);
+		matrix_mdev->kvm = kvm;
+		matrix_mdev->kvm_busy = false;
+	}
 
 	return 0;
 }
@@ -1079,51 +1131,54 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+/**
+ * vfio_ap_mdev_unset_kvm
+ *
+ * @matrix_mdev: a matrix mediated device
+ *
+ * Performs clean-up of resources no longer needed by @matrix_mdev.
+ *
+ * Note: The matrix_dev->lock must be taken prior to calling
+ * this function; however, the lock will be temporarily released while the
+ * guest's AP configuration is cleared to avoid a potential lockdep splat.
+ * The kvm->lock is taken to clear the guest's AP configuration which, under
+ * certain circumstances, will result in a circular lock dependency if this is
+ * done under the @matrix_mdev->lock.
+ *
+ */
 static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 {
-	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
-	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
-	vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
-	kvm_put_kvm(matrix_mdev->kvm);
-	matrix_mdev->kvm = NULL;
+	if (matrix_mdev->kvm) {
+		matrix_mdev->kvm_busy = true;
+		mutex_unlock(&matrix_dev->lock);
+		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
+		mutex_lock(&matrix_dev->lock);
+		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
+		kvm_put_kvm(matrix_mdev->kvm);
+		matrix_mdev->kvm = NULL;
+		matrix_mdev->kvm_busy = false;
+	}
 }
 
 static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 				       unsigned long action, void *data)
 {
-	int ret, notify_rc = NOTIFY_OK;
+	int notify_rc = NOTIFY_OK;
 	struct ap_matrix_mdev *matrix_mdev;
 
 	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
 		return NOTIFY_OK;
 
-	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
 	mutex_lock(&matrix_dev->lock);
+	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
 
-	if (!data) {
-		if (matrix_mdev->kvm)
-			vfio_ap_mdev_unset_kvm(matrix_mdev);
-		goto notify_done;
-	}
-
-	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
-	if (ret) {
-		notify_rc = NOTIFY_DONE;
-		goto notify_done;
-	}
-
-	/* If there is no CRYCB pointer, then we can't copy the masks */
-	if (!matrix_mdev->kvm->arch.crypto.crycbd) {
+	if (!data)
+		vfio_ap_mdev_unset_kvm(matrix_mdev);
+	else if (vfio_ap_mdev_set_kvm(matrix_mdev, data))
 		notify_rc = NOTIFY_DONE;
-		goto notify_done;
-	}
-
-	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
-				  matrix_mdev->matrix.aqm,
-				  matrix_mdev->matrix.adm);
 
-notify_done:
 	mutex_unlock(&matrix_dev->lock);
+
 	return notify_rc;
 }
 
@@ -1258,8 +1313,20 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
 	mutex_lock(&matrix_dev->lock);
+	/*
+	 * If the KVM pointer is in the process of being set, wait until the
+	 * process has completed. Unlock the matrix_dev->lock while waiting to
+	 * allow the value of the KVM pointer to be set.
+	 */
+	while (matrix_mdev->kvm_busy) {
+		mutex_unlock(&matrix_dev->lock);
+		msleep(100);
+		mutex_lock(&matrix_dev->lock);
+	}
+
 	if (matrix_mdev->kvm)
 		vfio_ap_mdev_unset_kvm(matrix_mdev);
+
 	mutex_unlock(&matrix_dev->lock);
 
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
@@ -1293,6 +1360,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 				    unsigned int cmd, unsigned long arg)
 {
 	int ret;
+	struct ap_matrix_mdev *matrix_mdev;
 
 	mutex_lock(&matrix_dev->lock);
 	switch (cmd) {
@@ -1300,7 +1368,12 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 		ret = vfio_ap_mdev_get_device_info(arg);
 		break;
 	case VFIO_DEVICE_RESET:
-		ret = vfio_ap_mdev_reset_queues(mdev);
+		matrix_mdev = mdev_get_drvdata(mdev);
+
+		if (matrix_mdev->kvm_busy)
+			ret = -EBUSY;
+		else
+			ret = vfio_ap_mdev_reset_queues(mdev);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 28e9d9989768..d1c8d25a899e 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -83,6 +83,7 @@ struct ap_matrix_mdev {
 	struct ap_matrix matrix;
 	struct notifier_block group_notifier;
 	struct notifier_block iommu_notifier;
+	bool kvm_busy;
 	struct kvm *kvm;
 	struct kvm_s390_module_hook pqap_hook;
 	struct mdev_device *mdev;
-- 
2.21.3

