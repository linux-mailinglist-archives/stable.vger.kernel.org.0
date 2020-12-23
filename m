Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CAE2E1148
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 02:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgLWBSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 20:18:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726846AbgLWBRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 20:17:00 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BN11w6A121358;
        Tue, 22 Dec 2020 20:16:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=D+EFG/gc3p78ZE8Oc9NsUtkZSWv2wrbRfIoTzSXMAds=;
 b=a7Ao4i4onqPbViwfp5UORPnP5j7hJqJhWigYonOr+WyvHJE+LMSoUs5crV9t86l263Vb
 sq/yj6v2/J+hgnRz4BWssKGOaIBzVvZF6Jm3iYkweOKxUWs+FOKAvehjIGMg59zuEIuD
 /LSdKO1tHOCPZ/qW8Z2XszuHZDh2WDgFIRyFZ1ESEMZLFElI4IGOZH3dL3sdx8bcXf7M
 JRs8c/z1ysMZcpVUFRx4iyilDerTcAenZ07+Vps+bQe+ux9JrxUNSKE197FGGd/DKBds
 YYHbRegGtxodLkDEwQur9S/4IjbTHkrrRqpPBN8PC8mJW9cRn/2J9F7GvnzXZphwNVMA yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35kuk5rk71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:17 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BN12A32121749;
        Tue, 22 Dec 2020 20:16:17 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35kuk5rk6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:17 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BN1BP8U028172;
        Wed, 23 Dec 2020 01:16:16 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 35kfercjd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Dec 2020 01:16:16 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BN1GElP11731450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Dec 2020 01:16:14 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C0E7112067;
        Wed, 23 Dec 2020 01:16:14 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 571DB112064;
        Wed, 23 Dec 2020 01:16:13 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.193.150])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 23 Dec 2020 01:16:13 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH v13 01/15] s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated
Date:   Tue, 22 Dec 2020 20:15:52 -0500
Message-Id: <20201223011606.5265-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201223011606.5265-1-akrowiak@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-22_13:2020-12-21,2020-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 phishscore=0 suspectscore=0 adultscore=0 impostorscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012230003
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
 drivers/s390/crypto/vfio_ap_ops.c | 49 ++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e0bde8518745..7339043906cf 100644
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
@@ -1083,35 +1078,52 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
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
+	int ret, notify_rc = NOTIFY_OK;
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
+		goto notify_done;
 	}
 
 	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
-	if (ret)
-		return NOTIFY_DONE;
+	if (ret) {
+		notify_rc = NOTIFY_DONE;
+		goto notify_done;
+	}
 
 	/* If there is no CRYCB pointer, then we can't copy the masks */
-	if (!matrix_mdev->kvm->arch.crypto.crycbd)
-		return NOTIFY_DONE;
+	if (!matrix_mdev->kvm->arch.crypto.crycbd) {
+		notify_rc = NOTIFY_DONE;
+		goto notify_done;
+	}
 
 	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
 				  matrix_mdev->matrix.aqm,
 				  matrix_mdev->matrix.adm);
 
-	return NOTIFY_OK;
+notify_done:
+	mutex_unlock(&matrix_dev->lock);
+	return notify_rc;
 }
 
 static void vfio_ap_irq_disable_apqn(int apqn)
@@ -1222,13 +1234,8 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
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

