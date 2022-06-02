Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6065853C104
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 00:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239776AbiFBWrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 18:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239757AbiFBWrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 18:47:12 -0400
Received: from esa.hc4959-67.iphmx.com (esa.hc4959-67.iphmx.com [216.71.153.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7988DD11A
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 15:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1654210031; x=1685746031;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=fESTwgSp9C8M5iY9KkxqZ4tyQHRpyxysp1kFdG542fU=;
  b=QHbWEfy9VAggvLagiKG/O67mOK1k0mknh4FBF14aCg+YANBriDDw/oLV
   Fv49LhLDP4u5UGuQL4DqfT75ZA+n0ISxpZcCwTwxzXtlfOjki4hoZlkGv
   lvqAuEZrebAEhtI5kFvt72KnB5VlEHOEfYqPthrQnGFS1Y/bpvAdcBsYp
   k=;
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 15:46:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ct4g74Ce+P4O1xgA0fLMkk2xM6qFKg9HtCD0P9LbpnaLQKyS6vdM+kRtyYegjEs02WE1DDNguOq1+LLgoBjHN7qdDaK10+dgPd0iG9RWqIcda4oVch7f67Ovocs3LtR0LBzKPtEo4onusM9InnSLbfwYGW9LP/GbXtRFDWpWXGAsJL5kPzQPaG/wkH7orM/nE6AACx2A+7X3uPhdmdgZ1dH/QFKNnhpUkIcatV9X1f05mYvBOi3hpTbnxYNTRSzcu7ZY9IlzvCuXdZ3T3iwS2+G2b0DGkRt9bB3vx6c5dF2J9eVrUcO5k/mZ+9Cfvzg2cIwWUrJZA0LEADihBz2mfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6uYAp+BBT4Z/mQY35yc+yn8WHaPxzZeF158FLYfZdas=;
 b=F+MGbbWAUeDcU8gmTT2CtB6zz4BKOIQVEcrQIHSzMkog9OEy/PzyB9FjTB9JesoBz/0IahXKPtabaq6V9JHkPhnyeQcjdIqkFE9tmReUfbsWX2fvoPiEoDcjzSV+1hfRclQb3/bqI66MiwCvNpKnobTJbRgsYpXBRB+de8GU6TyFRZHyMzw3mHNgdm7O6gGBf37WUwiWKlh3UVqKCV8eH2c0jbbWlqOZM2HND0MzKbgnGHQAueswfg6IRFtvvfDl8iHHPSSc3TMlW6zOni4bYGSXAz47OGgY359xkNIl5pvdWP/RGk9zgMBO4QoosJql/Zg1tzAKC1yJIvVyaMlA+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 192.55.16.51) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=seagate.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject
 header.from=seagate.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6uYAp+BBT4Z/mQY35yc+yn8WHaPxzZeF158FLYfZdas=;
 b=D5aiGwSEUWvP6f5na+/cNU7P298ntis1x/Y71YnwMGoUuYHqJ3/YlLsoRuQMMz25D+QmcSoxMlR20AZj4LrhwvvzKL1YMrqFLMc1YKR4+K66GUSkLqYDIcvzhmqsLxgzKHWhL0Y5uS9Rg2vsTaetDPx3LnwoqqXikgQKl8hcW0k=
Received: from DM5PR05CA0007.namprd05.prod.outlook.com (2603:10b6:3:d4::17) by
 PH7PR20MB5081.namprd20.prod.outlook.com (2603:10b6:510:1f2::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.13; Thu, 2 Jun 2022 22:46:05 +0000
Received: from DM6NAM10FT060.eop-nam10.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::31) by DM5PR05CA0007.outlook.office365.com
 (2603:10b6:3:d4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.14 via Frontend
 Transport; Thu, 2 Jun 2022 22:46:05 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is 192.55.16.51)
 smtp.mailfrom=seagate.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=seagate.com;
Received: from sgspzesaa002.seagate.com (192.55.16.51) by
 DM6NAM10FT060.mail.protection.outlook.com (10.13.152.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12 via Frontend Transport; Thu, 2 Jun 2022 22:46:04 +0000
Received: from sgspiesaa002.seagate.com ([10.4.144.53])
  by sgspzesaa002.seagate.com with ESMTP; 02 Jun 2022 15:48:39 -0700
X-IronPort-AV: E=Sophos;i="5.91,272,1647327600"; 
   d="scan'208";a="62195127"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
STX-Internal-Mailhost: TRUE
Received: from unknown (HELO tyler-ubuntu.colo.seagate.com) ([10.4.50.15])
  by sgspiesaa002.seagate.com with ESMTP; 02 Jun 2022 15:33:34 -0700
From:   Tyler Erickson <tyler.erickson@seagate.com>
To:     damien.lemoal@opensource.wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com, tyler.erickson@seagate.com,
        stable@vger.kernel.org
Subject: [PATCH v2 3/3] scsi: sd: Fix interpretation of VPD B9h length
Date:   Thu,  2 Jun 2022 16:51:13 -0600
Message-Id: <20220602225113.10218-4-tyler.erickson@seagate.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220602225113.10218-1-tyler.erickson@seagate.com>
References: <20220602225113.10218-1-tyler.erickson@seagate.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: e58074f4-1008-4b38-35b0-08da44e9ad68
X-MS-TrafficTypeDiagnostic: PH7PR20MB5081:EE_
X-Microsoft-Antispam-PRVS: <PH7PR20MB50811F187728F8FF0FBDB7D889DE9@PH7PR20MB5081.namprd20.prod.outlook.com>
STX-Hosted-IronPort-Oubound: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z/jmal5t0Anu063zPd3IPiWoTrOT4f0NBj7/Uq2REDa9ktQEMy3c3ICby9Y0Zr8VJOdiQ/mnvN++t88zXhmiHEUWvktMuJT/UZwx6isuC04VR4B4bq/kllQfMVFh0ayZoVWOA7iY/sSJGNp79EktZJO7XzEQW/cV2BL1XGN0g5P1kMuuhtb4MhThPGTpq71Nl0sHBPdBDMAvo6bDBqito/upDlHYHglFzLci1jFurOZS+fKatZRCBD8sd6SDx5xfZ2cdzgrOxgj0JLR9ucKFCnREo1IyIG1xk35FcE44g/yehHREZ0lbeThprvuIeye6e6BOrFWzJl0DI8XgRmlzb9bA6ZTiGOBo671dQbRcHSKdv6jWgkvMi9V6SNbSsWr7Vi4DydcKDQH1DBkwgI6TsvMtsdz609kGOz+Wg+G/SoFDHkPWKD0spcMNTwe1vd4q7DA+DtfA3rzTYMWzInFYATFvMNkTHTABvXFGpwLrxLsHD3RM/TbA1GFbCoy/sgJAgrh5N8gY28gl2m4lPgfUDOLj5o2scMYQVxEVxt1+bsbnTJz2i0CJGETqMJH3aknsm8UQ7TY8P5tEAR8NzMKtN2tJsp8ZcORSjecJI6fVXb8T58XnHvc9ArqqC7NSqtQWqSS13fQF+mhHJeYfhCWohw+TRTYceqZT93fXsAN7qqtN5Mt6P5S6Iz/fY7zluz7p1WwEl+Lctf4oaQ5kMBFr+Q==
X-Forefront-Antispam-Report: CIP:192.55.16.51;CTRY:SG;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sgspzesaa002.seagate.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(46966006)(40470700004)(36840700001)(86362001)(47076005)(336012)(1076003)(186003)(426003)(508600001)(83380400001)(81166007)(356005)(36860700001)(316002)(2616005)(82310400005)(5660300002)(450100002)(8936002)(40460700003)(4326008)(70586007)(8676002)(70206006)(6666004)(2906002)(26005)(7696005)(44832011)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 22:46:04.1672
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e58074f4-1008-4b38-35b0-08da44e9ad68
X-MS-Exchange-CrossTenant-Id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d466216a-c643-434a-9c2e-057448c17cbe;Ip=[192.55.16.51];Helo=[sgspzesaa002.seagate.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM10FT060.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR20MB5081
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixing the interpretation of the length of the B9h VPD page
(concurrent positioning ranges). Adding 4 is necessary as
the first 4 bytes of the page is the header with page number
and length information. Adding 3 was likely a misinterpretation
of the SBC-5 specification which sets all offsets starting at zero.

This fixes the error in dmesg:
[ 9.014456] sd 1:0:0:0: [sda] Invalid Concurrent Positioning Ranges VPD page

Cc: stable@vger.kernel.org
Fixes: e815d36548f0 ("scsi: sd: add concurrent positioning ranges support")
Signed-off-by: Tyler Erickson <tyler.erickson@seagate.com>
Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
Tested-by: Michael English <michael.english@seagate.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 749316462075..f25b0cc5dd21 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3072,7 +3072,7 @@ static void sd_read_cpr(struct scsi_disk *sdkp)
 		goto out;
 
 	/* We must have at least a 64B header and one 32B range descriptor */
-	vpd_len = get_unaligned_be16(&buffer[2]) + 3;
+	vpd_len = get_unaligned_be16(&buffer[2]) + 4;
 	if (vpd_len > buf_len || vpd_len < 64 + 32 || (vpd_len & 31)) {
 		sd_printk(KERN_ERR, sdkp,
 			  "Invalid Concurrent Positioning Ranges VPD page\n");
-- 
2.17.1

