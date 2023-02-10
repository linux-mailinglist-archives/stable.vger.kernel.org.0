Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F5A6924E4
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 18:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbjBJRzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 12:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbjBJRzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 12:55:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A8474041;
        Fri, 10 Feb 2023 09:55:47 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHsATR013475;
        Fri, 10 Feb 2023 17:55:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=jdsxoJu/le3WzUyGsQ3i3KKDyAP1na77DcnDUC/E/QM=;
 b=tf6enj/DlSrXiBrbOaAtyv2ekPjDgbAOma8Hb8HAXfpVm1RdyOn72RMBSxzMrKf+v+bF
 AlbyVi/0J1HWchffonKQyVEY400Yvuvi2M+9dPyHkFSD29zy7qYmlZzBEBU+NKkggn7N
 OI+gDqzmCLR4e8weE0hm6NEeFFbh2m5gSl1QRIR+nl1KQ7k/Pnq0X7e32cq71CyrdZ7n
 mQWH2n95WNMUk1SEMnwHfUYb35nQTVTepM02+OwvaXrsAZUI1xS+fgzK+PQeSbYyPP9a
 /dQa56Q+LDkqKfOnuyrD1/FG4PBm4Wq/e+tzxyCpmaTQUCY3Uu8bkJHxzvAlU3yKp839 WA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1e06m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 17:55:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AGUH2r013754;
        Fri, 10 Feb 2023 17:55:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtajccv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 17:55:45 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31AHti0P015195;
        Fri, 10 Feb 2023 17:55:45 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3nhdtajcc6-1;
        Fri, 10 Feb 2023 17:55:44 +0000
From:   Alok Tiwari <alok.a.tiwari@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     alok.a.tiwari@oracle.com, darren.kenny@oracle.com,
        michael.christie@oracle.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, martin.petersen@oracle.com,
        d.bogdanov@yadro.com, r.bolshakov@yadro.com,
        target-devel@vger.kernel.org
Subject: [PATCH] scsi: target: core: Added a blank line after target_remove_from_tmr_list()
Date:   Fri, 10 Feb 2023 09:55:22 -0800
Message-Id: <20230210175521.1469826-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_13,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100149
X-Proofpoint-GUID: 9fl-1ScwRFIasn_SnS6nUQg5ANWyj-8b
X-Proofpoint-ORIG-GUID: 9fl-1ScwRFIasn_SnS6nUQg5ANWyj-8b
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is no separate blank line between target_remove_from_tmr_list() and
transport_cmd_check_stop_to_fabric
As per coding-style, it is require to separate functions with one blank line.

Fixes: 12b6fcd0ea7f ("scsi: target: core: Remove from tmr_list during LUN unlink")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 drivers/target/target_core_transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5926316252eb..f1cdf78fc5ef 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -691,6 +691,7 @@ static void target_remove_from_tmr_list(struct se_cmd *cmd)
 		spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
 	}
 }
+
 /*
  * This function is called by the target core after the target core has
  * finished processing a SCSI command or SCSI TMF. Both the regular command
-- 
2.39.1

