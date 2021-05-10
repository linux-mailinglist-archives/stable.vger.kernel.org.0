Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C4237996B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 23:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhEJVtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 17:49:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51036 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229946AbhEJVtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 17:49:53 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14ALXmsc126425;
        Mon, 10 May 2021 17:48:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=P39Oib40GXzeNDaTB43BpzKW5YHtdvvLdTFwbihRiMk=;
 b=Q6uCu92up0QjhgAq7ZnVwhRZvy00h6wWJOPYnk1k+gQYSF6SwOzaQkYJv/MNqaFqTr5i
 MVr464sxzafNhdIg7r0tQ8VQa8q+PulGDt6PTZv5RG0pwI4kVlEqt8A6YL1XEOeClLFj
 FAew+nXHTs0gJRgyUyds+UHWlwrtnEfFy1fmvVkNPHFLXY7JqR53aNAHHW1dYIrm+Rl1
 lmrj5vcLsM6bXKRzDWj/yTJNxH9v4yqNgjGMaBKF+vvZjx8/BkiFYfijj4em4XSLQ+5z
 Xw5NQfSq+s2V8q0FHufa6UlV+6sphUjeUNUYJxAEya5AVP/Ko1q1qIDJZShX8VYEV7v2 Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f9rpx10e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 17:48:45 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14ALZBkl137083;
        Mon, 10 May 2021 17:48:44 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f9rpx0yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 17:48:44 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14ALQdcG009113;
        Mon, 10 May 2021 21:48:43 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01dal.us.ibm.com with ESMTP id 38dj99dna3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 21:48:43 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14ALmgqC22020518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 21:48:42 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 367A6BE053;
        Mon, 10 May 2021 21:48:42 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12A6EBE04F;
        Mon, 10 May 2021 21:48:40 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com.com (unknown [9.85.140.234])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 21:48:40 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com, jgg@nvidia.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        Tony Krowiak <akrowiak@linux.ibm.com>, stable@vger.kernel.org,
        Tony Krowiak <akrowiak@stny.rr.com>
Subject: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
Date:   Mon, 10 May 2021 17:48:37 -0400
Message-Id: <20210510214837.359717-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pDssY_eJuqQDcj1EriVuUJQ7QiUZ1cqR
X-Proofpoint-GUID: o_MYZTdijfyJ_WTinENXLlbeKS9oCONJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_12:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 spamscore=0 impostorscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100147
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The mdev remove callback for the vfio_ap device driver bails out with
-EBUSY if the mdev is in use by a KVM guest. The intended purpose was
to prevent the mdev from being removed while in use; however, returning a
non-zero rc does not prevent removal. This could result in a memory leak
of the resources allocated when the mdev was created. In addition, the
KVM guest will still have access to the AP devices assigned to the mdev
even though the mdev no longer exists.

To prevent this scenario, cleanup will be done - including unplugging the
AP adapters, domains and control domains - regardless of whether the mdev
is in use by a KVM guest or not.

Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
Cc: stable@vger.kernel.org
Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index b2c7e10dfdcd..f90c9103dac2 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -26,6 +26,7 @@
 
 static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
+static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev);
 
 static int match_apqn(struct device *dev, const void *data)
 {
@@ -366,17 +367,7 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
 	mutex_lock(&matrix_dev->lock);
-
-	/*
-	 * If the KVM pointer is in flux or the guest is running, disallow
-	 * un-assignment of control domain.
-	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
-		mutex_unlock(&matrix_dev->lock);
-		return -EBUSY;
-	}
-
-	vfio_ap_mdev_reset_queues(mdev);
+	vfio_ap_mdev_unset_kvm(matrix_mdev);
 	list_del(&matrix_mdev->node);
 	kfree(matrix_mdev);
 	mdev_set_drvdata(mdev, NULL);
-- 
2.30.2

