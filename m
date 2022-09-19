Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BE55BD180
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 17:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiISP5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 11:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiISP47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 11:56:59 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5150810544;
        Mon, 19 Sep 2022 08:56:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQ7iJqVUnTwrsiz9mzFvoEP/u9h9vr5MlWtsTPG5S+OhtIdhsZRwojnKZeTs7wz25lhZCer8OBMXSmxfmsVv8PpZTRz2XE3gq8l9t9opOX2Z50Eob6YFseVBHY3YkzctH2WqK3TxUQ7miUmW/XTKSK9yAX4WWzzvj2YixMF6yqI1vEk6qq8khy1PHapxovvYKyPDMTiDQsUK7C4kOdsMSD/oxkmAFIZp3MM1cjjfKxHh5lg79T/Q+Zb9cY3zBUOQLIol/swy/HbungNeetklCnMv1OQvZ7i/r8zB0PsoDFGgB59NAMoncbBWehzRc4Jj+u50IlWok0BBJkotvSb8Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHVVtPH9cZ5zdqMlNQu4tD1oz6I+8NMZ/o30hZRnc6I=;
 b=dJdw1SQPxVt8MFNs5qZkEspbzm+IkDmIYn4JJd9Ngq3yIpObalcHpIzJ0P1RvvalQ+UR+pOOfPwTVyvv3jLlSrgJ9PqwLN3Nv6tGKESjD1TqfWYhHrcBdSqoJj4RbSLV4zIthL+dXErlHJ8fAZWAoiy3pjdDu02reyw1MnsLzFgtpC5f2bbICYahXBt/LEAaPwH3xEIObj/RmRRC2jpgrEr/UmTKbgX7qjcYwrgmIkNpKjMyZ73X9A+DwJn3jVjDH1uHoHvlK/uZIn8KjKUMqKzHZbb5SeG4wh6QEs09SKNbvBdWxXhuC4Uacf65Pzs9tCsp9dyFdXeNcs9XSkO1JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHVVtPH9cZ5zdqMlNQu4tD1oz6I+8NMZ/o30hZRnc6I=;
 b=Qtm9fJ1jDiInwUHuIMnbO4JuuB5lPGN1+k4cCtyV4K03CRLWrOJ6sFMSp2uCsKIHZYnq466LUPqUly7ZU+jySSby/TKZAdrnPnl70pZw6CgpV7a7WcVbxCTzJNB/MnrTFkjbDONqDx0dea9oh99j5mQhG6phbdDuRSfe5uaca2E=
Received: from MW4PR04CA0353.namprd04.prod.outlook.com (2603:10b6:303:8a::28)
 by MN2PR12MB4287.namprd12.prod.outlook.com (2603:10b6:208:1dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Mon, 19 Sep
 2022 15:56:56 +0000
Received: from CO1NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::e1) by MW4PR04CA0353.outlook.office365.com
 (2603:10b6:303:8a::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21 via Frontend
 Transport; Mon, 19 Sep 2022 15:56:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT092.mail.protection.outlook.com (10.13.175.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Mon, 19 Sep 2022 15:56:55 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 19 Sep
 2022 10:56:54 -0500
From:   Kim Phillips <kim.phillips@amd.com>
To:     <iommu@lists.linux.dev>, <joro@8bytes.org>
CC:     <robin.murphy@arm.com>, <suravee.suthikulpanit@amd.com>,
        <vasant.hegde@amd.com>, Mike Day <michael.day@amd.com>,
        <linux-acpi@vger.kernel.org>, Kim Phillips <kim.phillips@amd.com>,
        <stable@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH v2 1/2] iommu/amd: Fix ivrs_acpihid cmdline parsing code
Date:   Mon, 19 Sep 2022 10:56:37 -0500
Message-ID: <20220919155638.391481-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT092:EE_|MN2PR12MB4287:EE_
X-MS-Office365-Filtering-Correlation-Id: 37a5486f-f788-4118-1abe-08da9a5793de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2uMq2r5LosbScVsEZwfsM/Fmvsk78zVq8f792VSKYvrrTyHpg1fHQGViFyoKhzMSjVWsBCgnJZ6rwugW0OjjVizJMV4TRZLy9YdnDxmde3D22xvMudoD5uAJyhQuhj10aePXVH9+BgnY72WB0tkTaA8B3UwS0dbMTHXqyJHMD5P0vhzIbTQWyJtI9zisSydTwozMKwS9MMiK1TDitRhHo5Gt04jiVACwQU4hwRxm3EBBUdDYtVtQmhw5vpETORIMTaxbBQdXOk8eYUTT01Dl/BHyntOOxxQ8J8UprVd5N5pm7fkC9EX4YqEJ+LdpB/mXSWZje9Smvg1usNVYLOU+9y0bIiZSpMtV+Ul2cA60KOe9OWeaDgMl+vtPL1h3+rrr4vrHvSM21eUtwN2su9vix+nvQChFEBzrgaRh/mfTbND6lkof0FiHeTq9G/7dwJhTrk02IF73sCaG3rLoygfPsHAXByxm4suCOsNu7bFgS3hMkBpl3bSknGvFO/tAhFJL3+p/Qu9jCwiH46npKMRVwS2+d0ZUqNGxLAzxJdgQt425rmOfbGWq5g2bgvjnhkRmEZucWdTl+kTVd47MX3ViIGrRwFAOpEnXaaP9sRH96rPiJvpwgRd5D5TUehDTV2DQxmGKz5x6IsU/MTRMjghAGKUFRPNd1njzejYl9IoAu++YtoLiYjlPAlrX2wLJIji/on5umopz7i0PJMVacs3viTYK4kxdIac3/68aq3CJtezrXyny3lZp9mPX/DHqs3fB/bzqw7SPhJcg5+IdxfIrJeTI/sMHJGCQEBV9rKPsj+wwMa1zMfh6Gw/SFxhPw1iK
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(5660300002)(36860700001)(44832011)(82740400003)(47076005)(26005)(81166007)(40480700001)(2906002)(316002)(54906003)(110136005)(478600001)(40460700003)(1076003)(356005)(336012)(426003)(82310400005)(2616005)(186003)(16526019)(8936002)(41300700001)(86362001)(36756003)(6666004)(70206006)(70586007)(8676002)(4326008)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 15:56:55.8110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37a5486f-f788-4118-1abe-08da9a5793de
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4287
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
v2: no changes

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

