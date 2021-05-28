Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8D0394606
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 18:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbhE1QvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 12:51:00 -0400
Received: from mail-dm3nam07on2045.outbound.protection.outlook.com ([40.107.95.45]:44417
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235710AbhE1Qrs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 12:47:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i19gCNK8gEjcJIl0wU0GekBYx6Xo0jnMMouLCBm3aRFp7NAdF3fzfCZW8Oetw22b6gnXlGhW3ATR/ZotuejhKbrbzmaKACb3oq5QhUBq4xqbS6HxKadiEfQPWmSHoBcOOdW7bch/qo/7kirNyC0dMOQrJsaFvu0fAXBVVJwadsGDcLzANX9mebEt4Bav72+7JKyhTJQ5DNlC2LYbMWZwjmmbMrwk+JHCJcwbnXLzIehIbKpL6ICGBT83tqKFH+sSWILbbRXotTkX8fCpkWEr0xYbXFGe6MHjZJ1LbMRKrehaPOupoMpL8ZBRUhTDd9xY4PAEq4MoUD25w9y3JaOSKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjXJzQTSrtkal9rFj4dFZDmmEr282KofR/BVxJubJ90=;
 b=DtAw//eOjnUYWOx5pizlVmMtIpEzKM1jz47ObVisFpnXESgTfDLK2Djazc5dsawz5Q6EQKPkJT8wC+zNBQ5vG5E6tSolDoSD3AeYlTctNQVUVkR2jOETszo/zQrNgwTWH1tLQi6oqBBHE/CKuyEQhRerxfKMFCR5Gi+MIahm/6gP8qFbFHgdStmyO3ErrYDzYWibUO+risbnMKgSjcziNNKDwnFud4q/0yCKiXEX7QBe52I8AxEP4eaotgYuo+TQI9mw23BvB960jzIFE0N1pw6fQU5FYKK18eqvmCEYKB7PXWszS3ZX1SciqDJq9rfdxbB4mk6ZQF/c849g+NZa6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.4.225.191) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=infinera.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=infinera.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjXJzQTSrtkal9rFj4dFZDmmEr282KofR/BVxJubJ90=;
 b=Efhc97Qs9M2KMv09OQLZxckgL9nVu7xO5xRSArOMRxYHoemAqyFLMtUMdqhh4HMP0MfWW7GC7K0OP/TU8tPMNJhMJNz8AoumK20s72xkAo7DMl2zsdorehVJyRnu9BC736b63615iS+w6Rc8Ee4f9LzXXM5BbJ1pkmF2lfGIVAA=
Received: from DM6PR06CA0050.namprd06.prod.outlook.com (2603:10b6:5:54::27) by
 BYAPR10MB2824.namprd10.prod.outlook.com (2603:10b6:a03:8c::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.24; Fri, 28 May 2021 16:46:11 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::22) by DM6PR06CA0050.outlook.office365.com
 (2603:10b6:5:54::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Fri, 28 May 2021 16:46:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 8.4.225.191)
 smtp.mailfrom=infinera.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=infinera.com;
Received-SPF: Pass (protection.outlook.com: domain of infinera.com designates
 8.4.225.191 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.4.225.191; helo=owa.infinera.com;
Received: from owa.infinera.com (8.4.225.191) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4150.30 via Frontend Transport; Fri, 28 May 2021 16:46:11 +0000
Received: from sv-ex16-prd.infinera.com (10.100.96.229) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 09:46:10 -0700
Received: from sv-smtp-prod2.infinera.com (10.100.98.82) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 28 May 2021 09:46:10 -0700
Received: from se-metroit-prd1.infinera.com ([10.210.32.58]) by sv-smtp-prod2.infinera.com with Microsoft SMTPSVC(7.5.7601.17514);
         Fri, 28 May 2021 09:46:10 -0700
Received: from gentoo-jocke.infinera.com (gentoo-jocke.infinera.com [10.210.71.2])
        by se-metroit-prd1.infinera.com (Postfix) with ESMTP id ACE3F2A973D3;
        Fri, 28 May 2021 18:46:09 +0200 (CEST)
Received: by gentoo-jocke.infinera.com (Postfix, from userid 1001)
        id A844E20002B0; Fri, 28 May 2021 18:46:09 +0200 (CEST)
From:   Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     <linux-bluetooth@vger.kernel.org>
CC:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/2] Bluetooth: btrtl: rename USB fw for RTL8761
Date:   Fri, 28 May 2021 18:46:07 +0200
Message-ID: <20210528164608.27941-1-joakim.tjernlund@infinera.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 May 2021 16:46:10.0580 (UTC) FILETIME=[F69A3540:01D753E0]
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df21c006-5859-46f5-fb13-08d921f8198a
X-MS-TrafficTypeDiagnostic: BYAPR10MB2824:
X-Microsoft-Antispam-PRVS: <BYAPR10MB28241E47551552B2125A3584F4229@BYAPR10MB2824.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YcddcZ2WqDD6DclmCi+GpeUkxdMLUQDyOqRejpTvp1axcib7QFr7RpeVIUBI8bbsoXb4kY37FXW21BAX7zdOhr6WzVYyp6IkzapjkoIOe32biTh02nLzTnI5yrybp1cLckQVWCsX46WxqMVfi8IaUAW20KJkn6t0PWwo53FrIqCcnnocp74YIPJlPkeRKjxokQw7Q/q3Z0RAfVi3P8gNZxq42OlB+q1YMNcgy3UnPA72FWPR0xReXEHJ7/Qb8ddvlnSuzCMMivto9CtTwxe9y9NEeG5DXOzAjHWDKuNbKqnJZc69Pcek8ov5kW6PSOahfBzC0oGR0vpj2LWjDibGUAome5ZY9adzEdI+ltwxYrBNXSBQO9q6VuH/CHn60qRCqLgxE2onFNVkQBsFzng/rlV2erFaWzMA2h2MFtdfH0N21RWPEgcPi3AwLfFE8tnf3iXhf0y6i0fUxXclmcyYs4//ZMFWLS+Oq+WB4ccoWDt/KWSCkmiMEJUPyvZGq+3bMlpd6YZeU0Qn842IHeK6WeonQAlemZlPnATKFsvttaDik1QHPwVT8D4ja9kJxJRPIB1jSVQr0nffep4SHGietLVg0A+vOTrRn+kgxjGqtJJAcnpH7IVo2AD1oMXfw/qHkHHwjqg8cwNOGqI7krqKTKSREwSP66QsqnHqYBNwYw+bAO80t7sIGEnW3Wwxiz/q
X-Forefront-Antispam-Report: CIP:8.4.225.191;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:owa.infinera.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(39850400004)(376002)(36840700001)(46966006)(1076003)(36860700001)(2906002)(44832011)(47076005)(6916009)(356005)(86362001)(478600001)(8936002)(6266002)(336012)(186003)(81166007)(426003)(2616005)(82310400003)(5660300002)(316002)(36756003)(36906005)(83380400001)(42186006)(54906003)(26005)(4326008)(8676002)(70586007)(82740400003)(70206006)(450100002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 16:46:11.2641
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df21c006-5859-46f5-fb13-08d921f8198a
X-MS-Exchange-CrossTenant-Id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.191];Helo=[owa.infinera.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2824
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>

According Realteks own BT drivers firmware RTL8761B is for UART
and RTL8761BU is for USB.

Change existing 8761B to UART and add an 8761BU entry for USB

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc: stable@vger.kernel.org
---
 drivers/bluetooth/btrtl.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index e7fe5fb22753..ccef8b2cfee2 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -132,12 +132,19 @@ static const struct id_table ic_id_table[] = {
 	  .cfg_name = "rtl_bt/rtl8761a_config" },
 
 	/* 8761B */
-	{ IC_INFO(RTL_ROM_LMP_8761A, 0xb, 0xa, HCI_USB),
+	{ IC_INFO(RTL_ROM_LMP_8761A, 0xb, 0xa, HCI_UART),
 	  .config_needed = false,
 	  .has_rom_version = true,
 	  .fw_name  = "rtl_bt/rtl8761b_fw.bin",
 	  .cfg_name = "rtl_bt/rtl8761b_config" },
 
+	/* 8761BU */
+	{ IC_INFO(RTL_ROM_LMP_8761A, 0xb, 0xa, HCI_USB),
+	  .config_needed = false,
+	  .has_rom_version = true,
+	  .fw_name  = "rtl_bt/rtl8761bu_fw.bin",
+	  .cfg_name = "rtl_bt/rtl8761bu_config" },
+
 	/* 8822C with UART interface */
 	{ IC_INFO(RTL_ROM_LMP_8822B, 0xc, 0xa, HCI_UART),
 	  .config_needed = true,
-- 
2.31.1

