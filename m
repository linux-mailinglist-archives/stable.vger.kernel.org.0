Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFD859841E
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 15:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245094AbiHRN0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 09:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245087AbiHRN0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 09:26:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0E6B2493;
        Thu, 18 Aug 2022 06:26:15 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27ICimRF025753;
        Thu, 18 Aug 2022 13:26:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gGbwGSZztbIxZzV+S0y6tRfatsi96ZLFsT2xrbTxVng=;
 b=YtM71PizdDHkHPacgMW0VgCr3q+LDSAX5yia6fontFe92kETBiijUW549D79YdcsIixt
 vHiZ0WFewByCXQuOuPqfIaMokWcpMf+8+IEB6HIlPO4/1moRuiTEXdYq2ZTy/QL5Kpzf
 Ik4cvC9r81wDonn2Y6FCEcH205GCJHEqoLb3/YFqUl259A+8sTtGofG389WDYnBbdRrn
 2OVPjlpzDenwt81alPp0Hf2/JJ9NJBKvggU0qJhVyArpQTMPtMvCGWv5t3u2fPx+/Uyh
 Dm6vzrEVIETP1u1WZAFgs3yzHsfgRVqDrW3wVWJJZ58PFdVGmEEYFD71iXkl8edAarlY dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1npxhcpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:26:14 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27ICwYRd032374;
        Thu, 18 Aug 2022 13:26:13 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1npxhcpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:26:13 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27IDKjMZ003771;
        Thu, 18 Aug 2022 13:26:12 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 3hx3kaek2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:26:12 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27IDQBZw50725132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 13:26:11 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 181306E050;
        Thu, 18 Aug 2022 13:26:11 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 133346E04E;
        Thu, 18 Aug 2022 13:26:10 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.160.64.167])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Aug 2022 13:26:09 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, stable@vger.kernel.org
Subject: [PATCH v2 2/2] s390/vfio-ap: fix unlinking of queues from the mdev
Date:   Thu, 18 Aug 2022 09:26:06 -0400
Message-Id: <20220818132606.13321-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220818132606.13321-1-akrowiak@linux.ibm.com>
References: <20220818132606.13321-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NSKZkpMTEJpZWlXcSOuXS1I3RvXps_y0
X-Proofpoint-GUID: Uuf19tzZwRiT3p_Qth9vnnowfmEdz48y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_12,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 mlxlogscore=926 adultscore=0
 suspectscore=0 mlxscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The vfio_ap_mdev_unlink_adapter and vfio_ap_mdev_unlink_domain functions
add the associated vfio_ap_queue objects to the hashtable that links them
to the matrix mdev to which their APQN is assigned. In order to unlink
them, they must be deleted from the hashtable; if not, they will continue
to be reset whenever userspace closes the mdev fd or removes the mdev.
This patch fixes that issue.

Cc: stable@vger.kernel.org
Fixes: 2838ba5bdcd6 ("s390/vfio-ap: reset queues after adapter/domain unassignment")
Reported-by: Tony Krowiak <akrowiak@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index ee82207b4e60..2493926b5dfb 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1049,8 +1049,7 @@ static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev *matrix_mdev,
 		if (q && qtable) {
 			if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
 			    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
-				hash_add(qtable->queues, &q->mdev_qnode,
-					 q->apqn);
+				vfio_ap_unlink_queue_fr_mdev(q);
 		}
 	}
 }
@@ -1236,8 +1235,7 @@ static void vfio_ap_mdev_unlink_domain(struct ap_matrix_mdev *matrix_mdev,
 		if (q && qtable) {
 			if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
 			    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
-				hash_add(qtable->queues, &q->mdev_qnode,
-					 q->apqn);
+				vfio_ap_unlink_queue_fr_mdev(q);
 		}
 	}
 }
-- 
2.31.1

