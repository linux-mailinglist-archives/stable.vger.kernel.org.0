Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19356BACB9
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 10:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjCOJzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 05:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbjCOJzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 05:55:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232B184805
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 02:53:40 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32F9673I028273
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 09:53:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=V4xt7UQz61WKYEHAU9tUM2s2Kh77LDnJvhpFv9IYO/s=;
 b=ZSjxoWgfmLUnO64UHOxT2h55b2D+N34SxvG5bsCQgrX7g3aV6gV9FQUje31DQ75XGtQ3
 qKa1iXxI7qyvQwWz1zVAiUMoZAIUpF1u45vNlYVHnijKenmyvw9duKNyD6RJQnolNnPP
 2Z+RxNW97y4OOIkhd3hDCvUzuuOQY7nrbQ5otT8dXM8nQPK9izXSb5Enn/l2OIAY+qQ+
 w9x6K29dHFhpbUY55oK22D5xLxeKKkM4+Ecm/RWngmtBDFBq6IUrFj2JV2M9McolpJOc
 wqHBKBZqFWqtlB9qRbyCZtCdGayFCG2e4S2/0XnQYDtfhqYUDnoGbvrtm2y6QFUAw4ao ng== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pb6wmy32x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 09:53:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32EN5GAq021116
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 09:53:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pb29srkvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 09:53:35 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32F9rVou50790660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 09:53:31 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26B1920043;
        Wed, 15 Mar 2023 09:53:31 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0015B20040;
        Wed, 15 Mar 2023 09:53:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Mar 2023 09:53:30 +0000 (GMT)
From:   =?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     sth@linux.ibm.com
Subject: [PATCH 5.10.y] s390/dasd: add missing discipline function
Date:   Wed, 15 Mar 2023 10:53:30 +0100
Message-Id: <20230315095330.1105164-1-hoeppner@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <16782678934450@kroah.com>
References: <16782678934450@kroah.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9zKzA3T8fo0b5KXueW--AKRecJN75uKO
X-Proofpoint-GUID: 9zKzA3T8fo0b5KXueW--AKRecJN75uKO
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_04,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 bulkscore=0 clxscore=1015 adultscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2302240000 definitions=main-2303150081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

Fix crash with illegal operation exception in dasd_device_tasklet.
Commit b72949328869 ("s390/dasd: Prepare for additional path event handling")
renamed the verify_path function for ECKD but not for FBA and DIAG.
This leads to a panic when the path verification function is called for a
FBA or DIAG device.

Fix by defining a wrapper function for dasd_generic_verify_path().

Fixes: b72949328869 ("s390/dasd: Prepare for additional path event handling")
Cc: <stable@vger.kernel.org> #5.11
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Link: https://lore.kernel.org/r/20210525125006.157531-2-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/s390/block/dasd_diag.c | 7 ++++++-
 drivers/s390/block/dasd_fba.c  | 7 ++++++-
 drivers/s390/block/dasd_int.h  | 1 -
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 1b9e1442e6a5..d5c7b70bd4de 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -642,12 +642,17 @@ static void dasd_diag_setup_blk_queue(struct dasd_block *block)
 	blk_queue_segment_boundary(q, PAGE_SIZE - 1);
 }
 
+static int dasd_diag_pe_handler(struct dasd_device *device, __u8 tbvpm)
+{
+	return dasd_generic_verify_path(device, tbvpm);
+}
+
 static struct dasd_discipline dasd_diag_discipline = {
 	.owner = THIS_MODULE,
 	.name = "DIAG",
 	.ebcname = "DIAG",
 	.check_device = dasd_diag_check_device,
-	.verify_path = dasd_generic_verify_path,
+	.pe_handler = dasd_diag_pe_handler,
 	.fill_geometry = dasd_diag_fill_geometry,
 	.setup_blk_queue = dasd_diag_setup_blk_queue,
 	.start_IO = dasd_start_diag,
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index 1a44e321b54e..b159575a2760 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -803,13 +803,18 @@ static void dasd_fba_setup_blk_queue(struct dasd_block *block)
 	blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
 }
 
+static int dasd_fba_pe_handler(struct dasd_device *device, __u8 tbvpm)
+{
+	return dasd_generic_verify_path(device, tbvpm);
+}
+
 static struct dasd_discipline dasd_fba_discipline = {
 	.owner = THIS_MODULE,
 	.name = "FBA ",
 	.ebcname = "FBA ",
 	.check_device = dasd_fba_check_characteristics,
 	.do_analysis = dasd_fba_do_analysis,
-	.verify_path = dasd_generic_verify_path,
+	.pe_handler = dasd_fba_pe_handler,
 	.setup_blk_queue = dasd_fba_setup_blk_queue,
 	.fill_geometry = dasd_fba_fill_geometry,
 	.start_IO = dasd_start_IO,
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index e8a06d85d6f7..5d7d35ca5eb4 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -298,7 +298,6 @@ struct dasd_discipline {
 	 * e.g. verify that new path is compatible with the current
 	 * configuration.
 	 */
-	int (*verify_path)(struct dasd_device *, __u8);
 	int (*pe_handler)(struct dasd_device *, __u8);
 
 	/*
-- 
2.37.2

