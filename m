Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C4B5B8F1E
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 21:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiINTET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 15:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiINTES (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 15:04:18 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2189C4332D;
        Wed, 14 Sep 2022 12:04:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVaXqoc6lEOpJu1ZoTI2yoRPkVr2yXo84sOf951i4hLbgzTcPvNjkp8Ez+Or619muuv6kWjyFkSGy0fXdaeiyIzuGUbK6bkxsAcETsEhJpVK7Xqn+uSA6KxPPrB6rkNAPY6ymxqPyEoa0mT5bE4DBuLlF+u+BFH8UXWi53NymFozLYIbn+xIreP7qRzE78ErSLPrLN5boPYaiDDaoEGfz9Bqd21eC4Czlclyx5QuC5PikKY9ef9GjXdAds71WiUhnSmAxv7QzBpD1Ve/J+CcPVdOebTBqyA8GebT6V+MqucqjdDt+Xue3wH0xObFCzLKp/sEj2sEzwKPA8tqpfkJuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+cU7VBWDPa+H6fi0gHL2b5vwqw9vTpbD0DqqTSRn/I=;
 b=NV9ZbYGiwvuB2G0gPGOkGorZKpiv5LZefbfTZyyWqmwwzkaTzH4CeWODBgZvUCJ93mTj+fhlsfWTqeouX1C+ujY8C8f6g58GPIN83u75oVcNdEDA7svQ8EfaiuQUr3bMmiJoktMwvaixBnleyUHFwLg5oU84g8ZKs7JFlamLjRJ55jB7FtNosLjBf4haLsEc+s7ynmCBrfM3C1CqGwXo047UKHor3zXNujYgCArXlK4Vol4D0+fZJl4a9/213Mw9/PXKNYhHNJQkt9mEYKxsXJVgR3o+kfIHKPY6yW3cv1XQla7ajnS0gg+6jQrBaTbgIOA8aHbMOSWPJGSZhkKZmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+cU7VBWDPa+H6fi0gHL2b5vwqw9vTpbD0DqqTSRn/I=;
 b=gPXPbfpcazDOt8YFRvnAlIxGP4P/VSE9DpEdcvkoDjWP1kmPW0CaxIyjxewib1np8huzaZ5BEunRfHobkztMELTCDVUuUhxOQxfCPcjIY/CrqniLYJzrGcx/MlcWhENXkq02QfAqgm7dYqTJ18gNlmPJj3yjN/p1lsxXvJ3p390=
Received: from BN0PR08CA0009.namprd08.prod.outlook.com (2603:10b6:408:142::13)
 by BY5PR12MB4114.namprd12.prod.outlook.com (2603:10b6:a03:20c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.23; Wed, 14 Sep
 2022 19:04:14 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::ac) by BN0PR08CA0009.outlook.office365.com
 (2603:10b6:408:142::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Wed, 14 Sep 2022 19:04:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 19:04:13 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 14 Sep
 2022 14:04:09 -0500
From:   Kim Phillips <kim.phillips@amd.com>
To:     <iommu@lists.linux.dev>, <joro@8bytes.org>
CC:     <robin.murphy@arm.com>, <suravee.suthikulpanit@amd.com>,
        <vasant.hegde@amd.com>, Mike Day <michael.day@amd.com>,
        <linux-acpi@vger.kernel.org>, Kim Phillips <kim.phillips@amd.com>,
        <stable@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 1/2] iommu/amd: Fix ivrs_acpihid cmdline parsing code
Date:   Wed, 14 Sep 2022 14:03:29 -0500
Message-ID: <20220914190330.60779-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT013:EE_|BY5PR12MB4114:EE_
X-MS-Office365-Filtering-Correlation-Id: 09b06418-2cd3-4f5a-cf82-08da9683ea12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BMVHc/ojr9pMG3BRplOA7mdKjbkZMcxLdI9cq0pVQCvk7U8CVi+4D4sPiyZJSL17h95ndurqsnNXbjLpJekZ5IXDM7t0pp6DuBcf94uFOhNgJ+B276r2lnef8pvwNJUnQ1n+wkUNyWHLGoS9swCdjw2zeRvaYE68MpcLmBjovB5OoDRKm3yinTlKDBdFg+mPxOoHxDqntWooLcLw3reyxjxGI1NPm5gZob/AWdPnzyK1wqMvrQj8Usanr26YxfhbANcIWvThbE9oD0oc796QqhvmACWx9IDIwECEhwxpuyW7aF4XlF32vUYy51Acsc4CWTywPluadQymV2MP38ZhHWKR5Y6isDjTM3ObZDaKur+La0CE6tCwGWeeiDraltt0eB5zZCoW9uHZUb+d2ug3lYbVolIwYY4VkxBlrgKCnc5eDsedjd6mFvxz4Pt1JsRSJPydWbEogF6fOsH3mTOczNoumz+NbHjwd1Z5Jf4xMA0+PIM8jxs09bGXi77YI9kpAyZRyXpeuyPUI4RDkM9GcFOsvK5p/DiEM9qK9FNOtepE3X9VTnsxCoFgUoxjiz8o82uhmQyhoqy6QtCznANTb6uVIctoNe3wZXPVIX7vv2YIhgf1sTaBs3SqwP+wBjBnSlKLGG4EWfz+eHqa+eZDEGVKHW/97IFUZ90qfwjf1s2DmxZ7ASQoNhOdL+/Ts9o4QlWx6t0SNrQ1T/TGYrn5BALeCEUKbImRktOd1oD7+OiU36eDSg7oOk0k63kLVw3Y+9sXG6Usr1soQCOEnCIIBmqglYT+z+CkOhP9YEemFh5n4Rvh+tUS2irzrJpmKhnd
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(336012)(16526019)(2616005)(44832011)(186003)(1076003)(41300700001)(6666004)(82740400003)(8676002)(5660300002)(4326008)(26005)(70586007)(8936002)(70206006)(40460700003)(36756003)(36860700001)(86362001)(82310400005)(40480700001)(356005)(81166007)(426003)(47076005)(2906002)(110136005)(478600001)(7696005)(54906003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 19:04:13.7548
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b06418-2cd3-4f5a-cf82-08da9683ea12
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4114
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The second (UID) strcmp in acpi_dev_hid_uid_match considers
"0" and "00" different, which can prevent device registration.

Have the AMD IOMMU driver's ivrs_acpihid parsing code remove
any leading zeroes to make the UID strcmp succeed.  Now users
can safely specify "AMDxxxxx:00" or "AMDxxxxx:0" and expect
the same behaviour.

Fixes: ca3bf5d47cec ("iommu/amd: Introduces ivrs_acpihid kernel parameter")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Cc: stable@vger.kernel.org
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd/init.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index fdc642362c14..ef0e1a4b5a11 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3471,6 +3471,13 @@ static int __init parse_ivrs_acpihid(char *str)
 		return 1;
 	}
 
+	/*
+	 * Ignore leading zeroes after ':', so e.g., AMDI0095:00
+	 * will match AMDI0095:0 in the second strcmp in acpi_dev_hid_uid_match
+	 */
+	while (*uid == '0' && *(uid + 1))
+		uid++;
+
 	i = early_acpihid_map_size++;
 	memcpy(early_acpihid_map[i].hid, hid, strlen(hid));
 	memcpy(early_acpihid_map[i].uid, uid, strlen(uid));
-- 
2.34.1

