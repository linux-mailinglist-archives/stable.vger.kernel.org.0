Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D6159E97F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 19:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiHWRci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 13:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiHWRaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 13:30:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52101022B7;
        Tue, 23 Aug 2022 08:07:37 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NEg4qh019327;
        Tue, 23 Aug 2022 15:07:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mUU1xc76wbMKDrZpO6WU7WvK277v0Bd+/Fhctni9zJQ=;
 b=MUk1bTqvG7HfxO/0/KSlYXsWTE/DCg22tH2VjgITkKYhEr7tlpd1ua8epVZrbj8NLRbE
 SRViacv9vENsk/n/Zm5fxHLMMWCMwbvIG/A2JYvqPfjjsNzuXCa/XvyylWwecNsEPFLp
 8pD+6V4W1m12LoyE2vgWjQa1kbh6wTprZLjJpv9kMjW1fzZAg0popCguKqXQ2syLjGBC
 TJxr9I1vxca/5JIOla1h0ADdYmio3uYQ6Cx25S3wfkvibDufWZqGTuTnUWaRlC/bObcV
 GVyCBPU/pFlh2o3CvnC0YQt8PdCcAiQ/P5mkGbSmwvo53eLR6L+/vClt58SsRvUeiroB 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j50vs0yxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:07:36 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NEgjUT021200;
        Tue, 23 Aug 2022 15:07:10 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j50vs0x5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:07:10 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NEowtp022320;
        Tue, 23 Aug 2022 15:06:47 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 3j2q8a0g0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:06:46 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NF6jqQ65536440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 15:06:46 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA5D5112062;
        Tue, 23 Aug 2022 15:06:45 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 518AB112061;
        Tue, 23 Aug 2022 15:06:45 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.160.64.167])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 15:06:45 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, stable@vger.kernel.org
Subject: [PATCH v3 1/2] s390/vfio-ap: bypass unnecessary processing of AP resources
Date:   Tue, 23 Aug 2022 11:06:42 -0400
Message-Id: <20220823150643.427737-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220823150643.427737-1-akrowiak@linux.ibm.com>
References: <20220823150643.427737-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: shTqvp-cUWkbpVGgTFPE1SkrFG1yweGb
X-Proofpoint-ORIG-GUID: tTzDFNX_uRSXXf26LvuqGR05WM_t1YiL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_05,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is not necessary to go through the process of validation, linking of
queues to mdev and vice versa and filtering the APQNs assigned to the
matrix mdev to build an AP configuration for a guest if an adapter or
domain being assigned is already assigned to the matrix mdev. Likewise, it
is not necessary to proceed through the process the unassignment of an
adapter, domain or control domain if it is not assigned to the matrix mdev.

Since it is not necessary to process assignment of a resource resource
already assigned or process unassignment of a resource that is been assigned,
this patch will bypass all assignment/unassignment operations for an adapter,
domain or control domain under these circumstances.

Not only is assignment of a duplicate adapter or domain unnecessary, it
will also cause a hang situation when removing the matrix mdev to which it is
assigned. The reason is because the same vfio_ap_queue objects with an
APQN containing the APID of the adapter or APQI of the domain being
assigned will get added multiple times to the hashtable that holds them.
This results in the pprev and next pointers of the hlist_node (mdev_qnode
field in the vfio_ap_queue object) pointing to the queue object itself
resulting in an interminable loop when the mdev is removed and the queue
table is iterated to reset the queues.

Cc: stable@vger.kernel.org
Fixes: 11cb2419fafe ("s390/vfio-ap: manage link between queue struct and matrix mdev")
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

