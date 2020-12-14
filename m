Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A90C2D9D01
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 17:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440232AbgLNQ5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 11:57:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9052 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2440222AbgLNQ5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 11:57:11 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BEGWTZ1101299;
        Mon, 14 Dec 2020 11:56:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3cyEYzE/Ow9jjL5B0Midoc9R0devhKEwKmZgd6sWhps=;
 b=eiQl7vhk9jFLkLddfp8cXLY/6HuGWJXBbyL5UVOys5M1ZApqLhS5ik4BZRmfTY/L3Kca
 KHSGSYCq8WGlO71YM+i20lktVaQ9Y90qaTc4Akg8Tn5VgtaprAXAhcDTj24tT/CY/S/2
 VMzRMTnomrE/bbCacbkjm5IhYtz8vwB7SGZPeRC+dCNxJVYOo/DiOP+mxTGcetb3Uo0X
 9Wyprm3tY4qdS9WMf1FGjRFDMLYY+igsd/cqd2+5cO4UtV3tPj9xq/2P9u5Eqf9eOFaI
 Sgrspr0yGMXkY4oDb2KrP1nD+CBzzDJehUuz/GX2uL1WnTegJ1/PmITIneSCTyw/RM+b 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35ebcg19hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 11:56:26 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BEGXNbQ106437;
        Mon, 14 Dec 2020 11:56:26 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35ebcg19hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 11:56:26 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BEGc13f018796;
        Mon, 14 Dec 2020 16:56:25 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04wdc.us.ibm.com with ESMTP id 35cng8s9rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 16:56:25 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BEGuPFn28180968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 16:56:25 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8DE5124053;
        Mon, 14 Dec 2020 16:56:24 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 414E3124052;
        Mon, 14 Dec 2020 16:56:24 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.193.150])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Dec 2020 16:56:24 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v3] s390/vfio-ap: clean up vfio_ap resources when KVM pointer invalidated
Date:   Mon, 14 Dec 2020 11:56:17 -0500
Message-Id: <20201214165617.28685-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_06:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 bulkscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140111
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
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e0bde8518745..cd22e85588e1 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1037,8 +1037,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 {
 	struct ap_matrix_mdev *m;
 
-	mutex_lock(&matrix_dev->lock);
-
 	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
 		if ((m != matrix_mdev) && (m->kvm == kvm)) {
 			mutex_unlock(&matrix_dev->lock);
@@ -1049,7 +1047,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 	matrix_mdev->kvm = kvm;
 	kvm_get_kvm(kvm);
 	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
-	mutex_unlock(&matrix_dev->lock);
 
 	return 0;
 }
@@ -1083,35 +1080,49 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
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
-- 
2.21.1

