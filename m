Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D13399E9D
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 12:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhFCKQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 06:16:39 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16210 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229800AbhFCKQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 06:16:39 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 153AArYM001204;
        Thu, 3 Jun 2021 03:14:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=PYVCIS/4HtuijguOaQzB/RF7yjuT3rFJkW7Fp9VoyCo=;
 b=LAY5Jz8KOjiW8iw0mb36zo8Fxowh7eLYMvRdwXFzgin8Br9A7uLJe8qzVFcEShSMaDto
 nDllag9visqXHSoepCRYzXk7zydK/slwKrJbDkkQXHSXy6/cVs0tbVHoneCDadX/J0Tt
 nPgBZpAVqmhRPnvhJexVhw5msX7aWuA8NzUf1unYO6tjV9CqinXPB4hO4atk8grvpAjg
 BSs5bUBfSOtKcOOtzQ9hs/GxNrwwvkgwWLSI4E/xiHm++TbcCgO7T05zLqx59I/SlW1i
 9RtoPR29DmiOCibkrlCQZ7usLw/HErS5Z3z8Y63E1KKP+w1EecnGEqD7l6k+U94sEttW rQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 38xe7xu6jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 03 Jun 2021 03:14:54 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 03:14:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 03:14:53 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D7C5E3F7040;
        Thu,  3 Jun 2021 03:14:52 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 153AEq0w007881;
        Thu, 3 Jun 2021 03:14:52 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 153AEqfv007880;
        Thu, 3 Jun 2021 03:14:52 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>,
        <stable@vger.kernel.org>
Subject: [PATCH V2 1/2] scsi: fc: Corrected RHBA attributes length
Date:   Thu, 3 Jun 2021 03:14:03 -0700
Message-ID: <20210603101404.7841-2-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210603101404.7841-1-jhasan@marvell.com>
References: <20210603101404.7841-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: T4pgjMrBe1ydB4yBrSAlkSfYh0MPk8_M
X-Proofpoint-GUID: T4pgjMrBe1ydB4yBrSAlkSfYh0MPk8_M
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-03_06:2021-06-02,2021-06-03 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

 -As per document of FC-GS-5, attribute lengths of node_name
  and manufacturer should in range of "4 to 64 Bytes" only.

Fixes: e721eb0616f6 ("scsi: scsi_transport_fc: Match HBA Attribute Length with HBAAPI V2.0 definitions")
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
CC: stable@vger.kernel.org
---
Changes in v2:
 - Added stable@vger.kernel.org in cc
---
 include/scsi/fc/fc_ms.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/scsi/fc/fc_ms.h b/include/scsi/fc/fc_ms.h
index 9e273fed0a85..800d53dc9470 100644
--- a/include/scsi/fc/fc_ms.h
+++ b/include/scsi/fc/fc_ms.h
@@ -63,8 +63,8 @@ enum fc_fdmi_hba_attr_type {
  * HBA Attribute Length
  */
 #define FC_FDMI_HBA_ATTR_NODENAME_LEN		8
-#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	80
-#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	80
+#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	64
+#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	64
 #define FC_FDMI_HBA_ATTR_MODEL_LEN		256
 #define FC_FDMI_HBA_ATTR_MODELDESCR_LEN		256
 #define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	256
-- 
2.26.2

