Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E71379459
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 18:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhEJQpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 12:45:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56636 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231736AbhEJQpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 12:45:44 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AGZJ7Q115336;
        Mon, 10 May 2021 12:44:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vnAYmSre0cOZDcxrTRW9FEGmvaFURp4YtQVfXpnn4d0=;
 b=eJYXg2emET8lP6XiXTs1ErkAJ2zXrS0Ak4yu2eqomjxMzLXTZ4QPSWrSTLNzgtZlJ8wl
 E1kGRzzXTSU4j6Qjj+PnF0sM2d2xh6jjzPfFWauoFenyYPLpJ2pFPYMiSOW2JDKVWn5s
 E1TZhEQZlOQuIDwCxa5RqOqJH/T+Vjox2jX4sqrFK1x9CaqJE5i5rVpX6btyCebAjYQZ
 TSmXIgIvlV8fZofjrrU+wo/cgulsB4G1fQHxr7fMJIT64d3kOQdziCKSmI0TtsDRL0Fr
 DSRsDB6P/0hG4PpG4tvhIodnGmc71A4NkhduxcrGQbU3W1dZMx3LFSey15oJ1Q43G4dP OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f7ha9ytb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 12:44:37 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AGZT2b116620;
        Mon, 10 May 2021 12:44:36 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f7ha9yse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 12:44:36 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AGh0Y7021538;
        Mon, 10 May 2021 16:44:34 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 38dj993hv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:44:34 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AGiWx830736834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 16:44:32 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5327DAE064;
        Mon, 10 May 2021 16:44:32 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1133DAE05F;
        Mon, 10 May 2021 16:44:31 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com.com (unknown [9.85.140.234])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 16:44:30 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>, stable@vger.kernel.org,
        Tony Krowiak <akrowiak@stny.rr.com>
Subject: [PATCH v16 01/14] s390/vfio-ap: fix memory leak in mdev remove callback
Date:   Mon, 10 May 2021 12:44:10 -0400
Message-Id: <20210510164423.346858-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510164423.346858-1-akrowiak@linux.ibm.com>
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sj-owWYLxgvi1eCc--2z6vfYwjqFjfqc
X-Proofpoint-ORIG-GUID: en8IrDvmBzIHIC1B4KkillZeqIqnPQJn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_09:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100113
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

