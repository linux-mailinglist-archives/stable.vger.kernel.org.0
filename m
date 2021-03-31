Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A632F350337
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 17:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbhCaPX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 11:23:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236256AbhCaPXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 11:23:19 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12VF3Ia3031141;
        Wed, 31 Mar 2021 11:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eddZYayLgbK9LT7a0g2otyK+KzhpC5hr6wrwydXZlus=;
 b=oLJKsDjzbNxZoRh05dCZBui73giOP9ggH/N/7gX+UqMae7vwtCwJ/KyFt47meCFFn+w8
 v2uJo2KzEriNdaDVN7grqID/1YGTW6PHDpLXefRYkL+H240H2FgV6XLWGWKfDpmWwMTn
 nxAMeN968YGXfkkncgIZXnRGPPjR5fCHslJ/wh5bCl/0azSJvUl8koViib8ThrC0ef2w
 kvdsrOOZzxnhVvFAZc0dOESjSrQMzZF/AFONOdgJionLJL/b8926ta41+C298KwUVEU+
 JbTtIic+s2WHmI0taGub8qBIP/wsICIkZJ/CcVFeuzKHfGbryFEmwRDD2JURz3wyKs9D NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37mu4u9d4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 11:23:17 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12VF3rmP033896;
        Wed, 31 Mar 2021 11:23:17 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37mu4u9d3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 11:23:17 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12VF2ARQ012103;
        Wed, 31 Mar 2021 15:23:16 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 37maawfd6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 15:23:16 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12VFNCUX8257814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 15:23:12 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F5616E05B;
        Wed, 31 Mar 2021 15:23:12 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C48C6E04E;
        Wed, 31 Mar 2021 15:23:10 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.146.149])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 31 Mar 2021 15:23:10 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH v14 01/13] s390/vfio-ap: fix circular lockdep when setting/clearing crypto masks
Date:   Wed, 31 Mar 2021 11:22:44 -0400
Message-Id: <20210331152256.28129-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20210331152256.28129-1-akrowiak@linux.ibm.com>
References: <20210331152256.28129-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: K5X4BCybdBzZMQPtflRUigGsJwY4_CMc
X-Proofpoint-GUID: oPgbMmxDQYHXPxfGLkWPG6P_xMLQAv8Y
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-31_06:2021-03-31,2021-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 mlxscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103300000
 definitions=main-2103310107
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes a lockdep splat introduced by commit f21916ec4826
("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated").
The lockdep splat only occurs when starting a Secure Execution guest.
Crypto virtualization (vfio_ap) is not yet supported for SE guests;
however, in order to avoid this problem when support becomes available,
this fix is being provided.

The circular locking dependency was introduced when the setting of the
masks in the guest's APCB was executed while holding the matrix_dev->lock.
While the lock is definitely needed to protect the setting/unsetting of the
matrix_mdev->kvm pointer, it is not necessarily critical for setting the
masks; so, the matrix_dev->lock will be released while the masks are being
set or cleared.

Keep in mind, however, that another process that takes the matrix_dev->lock
can get control while the masks in the guest's APCB are being set or
cleared as a result of the driver being notified that the KVM pointer
has been set or unset. This could result in invalid access to the
matrix_mdev->kvm pointer by the intervening process. To avoid this
scenario, two new fields are being added to the ap_matrix_mdev struct:

struct ap_matrix_mdev {
	...
	bool kvm_busy;
	wait_queue_head_t wait_for_kvm;
   ...
};

The functions that handle notification that the KVM pointer value has
been set or cleared will set the kvm_busy flag to true until they are done
processing at which time they will set it to false and wake up the tasks on
the matrix_mdev->wait_for_kvm wait queue. Functions that require
access to matrix_mdev->kvm will sleep on the wait queue until they are
awakened at which time they can safely access the matrix_mdev->kvm
field.

Fixes: f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated")
Cc: stable@vger.kernel.org
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 308 ++++++++++++++++++--------
 drivers/s390/crypto/vfio_ap_private.h |   2 +
 2 files changed, 215 insertions(+), 95 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 1ffdd411201c..6946a7e26eff 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -294,6 +294,19 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
 				   struct ap_matrix_mdev, pqap_hook);
 
+	/*
+	 * If the KVM pointer is in the process of being set, wait until the
+	 * process has completed.
+	 */
+	wait_event_cmd(matrix_mdev->wait_for_kvm,
+		       !matrix_mdev->kvm_busy,
+		       mutex_unlock(&matrix_dev->lock),
+		       mutex_lock(&matrix_dev->lock));
+
+	/* If the there is no guest using the mdev, there is nothing to do */
+	if (!matrix_mdev->kvm)
+		goto out_unlock;
+
 	q = vfio_ap_get_queue(matrix_mdev, apqn);
 	if (!q)
 		goto out_unlock;
@@ -337,6 +350,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 
 	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
+	init_waitqueue_head(&matrix_mdev->wait_for_kvm);
 	mdev_set_drvdata(mdev, matrix_mdev);
 	matrix_mdev->pqap_hook.hook = handle_pqap;
 	matrix_mdev->pqap_hook.owner = THIS_MODULE;
@@ -351,17 +365,23 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	if (matrix_mdev->kvm)
+	mutex_lock(&matrix_dev->lock);
+
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of control domain.
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+		mutex_unlock(&matrix_dev->lock);
 		return -EBUSY;
+	}
 
-	mutex_lock(&matrix_dev->lock);
 	vfio_ap_mdev_reset_queues(mdev);
 	list_del(&matrix_mdev->node);
-	mutex_unlock(&matrix_dev->lock);
-
 	kfree(matrix_mdev);
 	mdev_set_drvdata(mdev, NULL);
 	atomic_inc(&matrix_dev->available_instances);
+	mutex_unlock(&matrix_dev->lock);
 
 	return 0;
 }
@@ -606,24 +626,31 @@ static ssize_t assign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
+	mutex_lock(&matrix_dev->lock);
+
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of adapter
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+		ret = -EBUSY;
+		goto done;
+	}
 
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
-		return ret;
+		goto done;
 
-	if (apid > matrix_mdev->matrix.apm_max)
-		return -ENODEV;
+	if (apid > matrix_mdev->matrix.apm_max) {
+		ret = -ENODEV;
+		goto done;
+	}
 
 	/*
 	 * Set the bit in the AP mask (APM) corresponding to the AP adapter
 	 * number (APID). The bits in the mask, from most significant to least
 	 * significant bit, correspond to APIDs 0-255.
 	 */
-	mutex_lock(&matrix_dev->lock);
-
 	ret = vfio_ap_mdev_verify_queues_reserved_for_apid(matrix_mdev, apid);
 	if (ret)
 		goto done;
@@ -672,22 +699,31 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
+	mutex_lock(&matrix_dev->lock);
+
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of adapter
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+		ret = -EBUSY;
+		goto done;
+	}
 
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
-		return ret;
+		goto done;
 
-	if (apid > matrix_mdev->matrix.apm_max)
-		return -ENODEV;
+	if (apid > matrix_mdev->matrix.apm_max) {
+		ret = -ENODEV;
+		goto done;
+	}
 
-	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
+	ret = count;
+done:
 	mutex_unlock(&matrix_dev->lock);
-
-	return count;
+	return ret;
 }
 static DEVICE_ATTR_WO(unassign_adapter);
 
@@ -753,17 +789,24 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	/* If the guest is running, disallow assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
+	mutex_lock(&matrix_dev->lock);
+
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * assignment of domain
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+		ret = -EBUSY;
+		goto done;
+	}
 
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
-		return ret;
-	if (apqi > max_apqi)
-		return -ENODEV;
-
-	mutex_lock(&matrix_dev->lock);
+		goto done;
+	if (apqi > max_apqi) {
+		ret = -ENODEV;
+		goto done;
+	}
 
 	ret = vfio_ap_mdev_verify_queues_reserved_for_apqi(matrix_mdev, apqi);
 	if (ret)
@@ -814,22 +857,32 @@ static ssize_t unassign_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
+	mutex_lock(&matrix_dev->lock);
+
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of domain
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+		ret = -EBUSY;
+		goto done;
+	}
 
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
-		return ret;
+		goto done;
 
-	if (apqi > matrix_mdev->matrix.aqm_max)
-		return -ENODEV;
+	if (apqi > matrix_mdev->matrix.aqm_max) {
+		ret = -ENODEV;
+		goto done;
+	}
 
-	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
-	mutex_unlock(&matrix_dev->lock);
+	ret = count;
 
-	return count;
+done:
+	mutex_unlock(&matrix_dev->lock);
+	return ret;
 }
 static DEVICE_ATTR_WO(unassign_domain);
 
@@ -858,27 +911,36 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
+	mutex_lock(&matrix_dev->lock);
+
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * assignment of control domain.
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+		ret = -EBUSY;
+		goto done;
+	}
 
 	ret = kstrtoul(buf, 0, &id);
 	if (ret)
-		return ret;
+		goto done;
 
-	if (id > matrix_mdev->matrix.adm_max)
-		return -ENODEV;
+	if (id > matrix_mdev->matrix.adm_max) {
+		ret = -ENODEV;
+		goto done;
+	}
 
 	/* Set the bit in the ADM (bitmask) corresponding to the AP control
 	 * domain number (id). The bits in the mask, from most significant to
 	 * least significant, correspond to IDs 0 up to the one less than the
 	 * number of control domains that can be assigned.
 	 */
-	mutex_lock(&matrix_dev->lock);
 	set_bit_inv(id, matrix_mdev->matrix.adm);
+	ret = count;
+done:
 	mutex_unlock(&matrix_dev->lock);
-
-	return count;
+	return ret;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
 
@@ -908,21 +970,30 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	/* If the guest is running, disallow un-assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
+	mutex_lock(&matrix_dev->lock);
+
+	/*
+	 * If the KVM pointer is in flux or the guest is running, disallow
+	 * un-assignment of control domain.
+	 */
+	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
+		ret = -EBUSY;
+		goto done;
+	}
 
 	ret = kstrtoul(buf, 0, &domid);
 	if (ret)
-		return ret;
-	if (domid > max_domid)
-		return -ENODEV;
+		goto done;
+	if (domid > max_domid) {
+		ret = -ENODEV;
+		goto done;
+	}
 
-	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
+	ret = count;
+done:
 	mutex_unlock(&matrix_dev->lock);
-
-	return count;
+	return ret;
 }
 static DEVICE_ATTR_WO(unassign_control_domain);
 
@@ -1027,8 +1098,15 @@ static const struct attribute_group *vfio_ap_mdev_attr_groups[] = {
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
@@ -1038,14 +1116,25 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 {
 	struct ap_matrix_mdev *m;
 
-	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
-		if ((m != matrix_mdev) && (m->kvm == kvm))
-			return -EPERM;
-	}
+	if (kvm->arch.crypto.crycbd) {
+		list_for_each_entry(m, &matrix_dev->mdev_list, node) {
+			if (m != matrix_mdev && m->kvm == kvm)
+				return -EPERM;
+		}
 
-	matrix_mdev->kvm = kvm;
-	kvm_get_kvm(kvm);
-	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
+		kvm_get_kvm(kvm);
+		matrix_mdev->kvm_busy = true;
+		mutex_unlock(&matrix_dev->lock);
+		kvm_arch_crypto_set_masks(kvm,
+					  matrix_mdev->matrix.apm,
+					  matrix_mdev->matrix.aqm,
+					  matrix_mdev->matrix.adm);
+		mutex_lock(&matrix_dev->lock);
+		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
+		matrix_mdev->kvm = kvm;
+		matrix_mdev->kvm_busy = false;
+		wake_up_all(&matrix_mdev->wait_for_kvm);
+	}
 
 	return 0;
 }
@@ -1079,51 +1168,65 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
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
+	/*
+	 * If the KVM pointer is in the process of being set, wait until the
+	 * process has completed.
+	 */
+	wait_event_cmd(matrix_mdev->wait_for_kvm,
+		       !matrix_mdev->kvm_busy,
+		       mutex_unlock(&matrix_dev->lock),
+		       mutex_lock(&matrix_dev->lock));
+
+	if (matrix_mdev->kvm) {
+		matrix_mdev->kvm_busy = true;
+		mutex_unlock(&matrix_dev->lock);
+		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
+		mutex_lock(&matrix_dev->lock);
+		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
+		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
+		kvm_put_kvm(matrix_mdev->kvm);
+		matrix_mdev->kvm = NULL;
+		matrix_mdev->kvm_busy = false;
+		wake_up_all(&matrix_mdev->wait_for_kvm);
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
 
@@ -1258,8 +1361,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
 	mutex_lock(&matrix_dev->lock);
-	if (matrix_mdev->kvm)
-		vfio_ap_mdev_unset_kvm(matrix_mdev);
+	vfio_ap_mdev_unset_kvm(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
@@ -1293,6 +1395,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 				    unsigned int cmd, unsigned long arg)
 {
 	int ret;
+	struct ap_matrix_mdev *matrix_mdev;
 
 	mutex_lock(&matrix_dev->lock);
 	switch (cmd) {
@@ -1300,6 +1403,21 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 		ret = vfio_ap_mdev_get_device_info(arg);
 		break;
 	case VFIO_DEVICE_RESET:
+		matrix_mdev = mdev_get_drvdata(mdev);
+		if (WARN(!matrix_mdev, "Driver data missing from mdev!!")) {
+			ret = -EINVAL;
+			break;
+		}
+
+		/*
+		 * If the KVM pointer is in the process of being set, wait until
+		 * the process has completed.
+		 */
+		wait_event_cmd(matrix_mdev->wait_for_kvm,
+			       !matrix_mdev->kvm_busy,
+			       mutex_unlock(&matrix_dev->lock),
+			       mutex_lock(&matrix_dev->lock));
+
 		ret = vfio_ap_mdev_reset_queues(mdev);
 		break;
 	default:
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 28e9d9989768..f82a6396acae 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -83,6 +83,8 @@ struct ap_matrix_mdev {
 	struct ap_matrix matrix;
 	struct notifier_block group_notifier;
 	struct notifier_block iommu_notifier;
+	bool kvm_busy;
+	wait_queue_head_t wait_for_kvm;
 	struct kvm *kvm;
 	struct kvm_s390_module_hook pqap_hook;
 	struct mdev_device *mdev;
-- 
2.21.3

