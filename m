Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511F33746F9
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbhEERgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:36:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56968 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238304AbhEER3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 13:29:40 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 145HRjcE105328;
        Wed, 5 May 2021 13:28:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=RamQjXn9S1YS2Xm/STJqrMgquXvsymwgI5b2/HLFwLI=;
 b=JlRpVv1z+SgJEkOtQQfVhD7mjdI7XGOQ32wsPzVgydxz593tdmDQrr73ui7xZYXdDkp/
 /YZDJq+3rLeo9HoYs1GpVl9eELhB8OkzzwC0irXlglTMpsq++mnuhjbis/SlttVO28Ps
 Ksnk6LMWMRH4st3h9m8cFHRp7EoJEF+wtsetNQLlN7eVp6cRBdqFAUq63l62hOYMc4uV
 Rh4lMKHdE6kEZsKrPa/uxIH24fyRWpI3lXp+6lZGYN58cew+fGl2QC6M/FmL8m0FfEdD
 8w/AT7CaU7SlMoRXbg0lYgn5Tv6sAT6a8felH6GJpE34ZNGi1peL1z/UjjIYTRfDmJCe pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38byse00uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 13:28:34 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 145HSX7Q113628;
        Wed, 5 May 2021 13:28:33 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38byse00u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 13:28:33 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 145HNgcl018288;
        Wed, 5 May 2021 17:28:32 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 38bedtq9s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 17:28:32 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 145HSVrX13828358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 May 2021 17:28:31 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED1BC6E059;
        Wed,  5 May 2021 17:28:30 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8EED6E04C;
        Wed,  5 May 2021 17:28:29 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.140.234])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  5 May 2021 17:28:29 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com, jgg@nvidia.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        Tony Krowiak <akrowiak@linux.ibm.com>, stable@vger.kernel.org,
        Tony Krowiak <akrowiak@stny.rr.com>
Subject: [PATCH] s390/vfio-ap: fix memory leak in mdev remove callback
Date:   Wed,  5 May 2021 13:28:26 -0400
Message-Id: <20210505172826.105304-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Wh8g7m19hm-xqOEU-iZhVCMePjKVunox
X-Proofpoint-ORIG-GUID: c1MsSw88HdDvKafsngS6LoxAzMQEUby9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_09:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 impostorscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050117
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
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 39 +++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index b2c7e10dfdcd..757166da947e 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -335,6 +335,32 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
+static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
+{
+	return (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd);
+}
+
+static void vfio_ap_mdev_clear_apcb(struct ap_matrix_mdev *matrix_mdev)
+{
+	/*
+	 * If the KVM pointer is in the process of being set, wait until the
+	 * process has completed.
+	 */
+	wait_event_cmd(matrix_mdev->wait_for_kvm,
+		       !matrix_mdev->kvm_busy,
+		       mutex_unlock(&matrix_dev->lock),
+		       mutex_lock(&matrix_dev->lock));
+
+	if (vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		matrix_mdev->kvm_busy = true;
+		mutex_unlock(&matrix_dev->lock);
+		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
+		mutex_lock(&matrix_dev->lock);
+		matrix_mdev->kvm_busy = false;
+		wake_up_all(&matrix_mdev->wait_for_kvm);
+	}
+}
+
 static int vfio_ap_mdev_create(struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -366,16 +392,9 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
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
+	WARN(vfio_ap_mdev_has_crycb(matrix_mdev),
+	     "Removing mdev leaves KVM guest without any crypto devices");
+	vfio_ap_mdev_clear_apcb(matrix_mdev);
 	vfio_ap_mdev_reset_queues(mdev);
 	list_del(&matrix_mdev->node);
 	kfree(matrix_mdev);
-- 
2.30.2

