Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C348598413
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 15:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244953AbiHRN0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 09:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245084AbiHRN0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 09:26:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2BE9C1F6;
        Thu, 18 Aug 2022 06:26:14 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27ID0BtS027112;
        Thu, 18 Aug 2022 13:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=F3bmkDPwt+zlKjze2zKYRPH5RJeld2Yio31gn14ffKc=;
 b=fxDsKqbKkcc3dZClWJ7exYmVtQz+9+CKYyS+r6fOb0M5OBrGjMaKZ4gUV3u0udLQT0ia
 D4Em4UvcWv8uUsBLIXzu6DPp2eoulax2W9TCBxMXoRgS8LbFPL5UhXOPXZsm/uB3wU1Q
 xD3UQDOxeBgydRcwnJ1+J1QG7YzMMZE9G3URWW/XfTSvzppt9Crr/oe85uea8dG4dvTg
 cd93cONJGRpUCim9Xe58PjCE3XUuhCBJR6RW2ZdvBfPhUQSDth81X0F4DV+aAcoElZaz
 beiA4GpYYzZ6m2FaExZ/E/z1qAFe/hpcTyJf6MeGf8aapFwXE6uaIFp+zONC/LnH038o gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1nx6gxac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:26:12 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27ID0JVC027872;
        Thu, 18 Aug 2022 13:26:11 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1nx6gx9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:26:11 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27IDKo80016253;
        Thu, 18 Aug 2022 13:26:10 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 3hx3k9y30y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:26:10 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27IDQ96C49414650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 13:26:09 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E53436E059;
        Thu, 18 Aug 2022 13:26:09 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEE676E053;
        Thu, 18 Aug 2022 13:26:08 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.160.64.167])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Aug 2022 13:26:08 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, stable@vger.kernel.org
Subject: [PATCH v2 1/2] s390/vfio-ap: fix hang during removal of mdev after duplicate assignment
Date:   Thu, 18 Aug 2022 09:26:05 -0400
Message-Id: <20220818132606.13321-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220818132606.13321-1-akrowiak@linux.ibm.com>
References: <20220818132606.13321-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HF5u6iRCroJZRUOtS0NRZAmiAeK3zTqY
X-Proofpoint-ORIG-GUID: S-txIsbb-veF7rIWsbJYSMMSFyTDGj0t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_12,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501
 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0 clxscore=1011
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the same adapter or domain is assigned more than one time prior to
removing the matrix mdev to which it is assigned, the remove operation
will hang. The reason is because the same vfio_ap_queue objects with an
APQN containing the APID of the adapter or APQI of the domain being
assigned will get added to the hashtable that holds them multiple times.
This results in the pprev and next pointers of the hlist_node (mdev_qnode
field in the vfio_ap_queue object) pointing to the queue object itself.
This causes an interminable loop when the mdev is removed and the queue
table is iterated to reset the queues.

To fix this problem, the assignment operation is bypassed when assigning
an adapter or domain if it is already assigned to the matrix mdev.

Since it is not necessary to assign a resource already assigned or to
unassign a resource that has not been assigned, this patch will bypass
all assignment/unassignment operations for an adapter, domain or
control domain under these circumstances.

Cc: stable@vger.kernel.org
Fixes: 771e387d5e79 ("s390/vfio-ap: manage link between queue struct and matrix mdev")
Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 6c8c41fac4e1..ee82207b4e60 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -984,6 +984,11 @@ static ssize_t assign_adapter_store(struct device *dev,
 		goto done;
 	}
 
+	if (test_bit_inv(apid, matrix_mdev->matrix.apm)) {
+		ret = count;
+		goto done;
+	}
+
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
 
 	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
@@ -1109,6 +1114,11 @@ static ssize_t unassign_adapter_store(struct device *dev,
 		goto done;
 	}
 
+	if (!test_bit_inv(apid, matrix_mdev->matrix.apm)) {
+		ret = count;
+		goto done;
+	}
+
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_hot_unplug_adapter(matrix_mdev, apid);
 	ret = count;
@@ -1183,6 +1193,11 @@ static ssize_t assign_domain_store(struct device *dev,
 		goto done;
 	}
 
+	if (test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
+		ret = count;
+		goto done;
+	}
+
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
 
 	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
@@ -1286,6 +1301,11 @@ static ssize_t unassign_domain_store(struct device *dev,
 		goto done;
 	}
 
+	if (!test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
+		ret = count;
+		goto done;
+	}
+
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
 	vfio_ap_mdev_hot_unplug_domain(matrix_mdev, apqi);
 	ret = count;
@@ -1329,6 +1349,11 @@ static ssize_t assign_control_domain_store(struct device *dev,
 		goto done;
 	}
 
+	if (test_bit_inv(id, matrix_mdev->matrix.adm)) {
+		ret = count;
+		goto done;
+	}
+
 	/* Set the bit in the ADM (bitmask) corresponding to the AP control
 	 * domain number (id). The bits in the mask, from most significant to
 	 * least significant, correspond to IDs 0 up to the one less than the
@@ -1378,6 +1403,11 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 		goto done;
 	}
 
+	if (!test_bit_inv(domid, matrix_mdev->matrix.adm)) {
+		ret = count;
+		goto done;
+	}
+
 	clear_bit_inv(domid, matrix_mdev->matrix.adm);
 
 	if (test_bit_inv(domid, matrix_mdev->shadow_apcb.adm)) {
-- 
2.31.1

