Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E564E59E981
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 19:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbiHWRaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 13:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbiHWR35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 13:29:57 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE59479A64;
        Tue, 23 Aug 2022 08:06:53 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NDtNX6010830;
        Tue, 23 Aug 2022 15:06:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qggOT6o6oGh3ApPfF15x+1bZNg0ZPP3Kh5jAsyZFOLI=;
 b=CnWrbV+z7TNsG9NBZYcGSfpWU36qo7AOWDwcYZ90aY0pT/x4nZLNeWQzj+8o62Ra8VA8
 xX4+AlS+KTb4dzEyNPf9AYtMeSsZ+SwkcOgSP+0j/izHh2nKs7O7N1fWTJi2ndzyaamM
 /WRs/fgoLTPy86FnIe9jmN1N/0Tv3EWBsuI/yOpbXd/wKyRUPAJSQsXdc/4zmyFMkXZ8
 BDxlUTePgO/6CFdQBHtxYtiiqqXV+3kh2rzgvEawyvWVR5yuyczG99RNPudbIXzkevc6
 +CUnQHr756fUb3BkX1YGkdLqCS+U2lSafzFPiVrB3s5k4Z5PFqWjPuF0XKYMaixdON2S fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5071th1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:06:52 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NDtWxV011309;
        Tue, 23 Aug 2022 15:06:50 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5071tgxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:06:50 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NF6Hxc017360;
        Tue, 23 Aug 2022 15:06:47 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 3j2q8a3m5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:06:47 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NF6kQW65274148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 15:06:46 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 822F9112064;
        Tue, 23 Aug 2022 15:06:46 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2E4C112061;
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
Subject: [PATCH v3 2/2] s390/vfio-ap: fix unlinking of queues from the mdev
Date:   Tue, 23 Aug 2022 11:06:43 -0400
Message-Id: <20220823150643.427737-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220823150643.427737-1-akrowiak@linux.ibm.com>
References: <20220823150643.427737-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4kNwgD-qK281gKIQa_MU1nGX6WzPC6gN
X-Proofpoint-GUID: T0jqJTs2GTZkAluKUcyQ0l1ZZtr0n6mM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_05,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 phishscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=917 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208230062
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
Fixes: 70aeefe574cb ("s390/vfio-ap: reset queues after adapter/domain unassignment")
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

