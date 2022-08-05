Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F26858AF6D
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 20:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbiHESBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 14:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241358AbiHESBR (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 5 Aug 2022 14:01:17 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30F6EA2
        for <Stable@vger.kernel.org>; Fri,  5 Aug 2022 11:01:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCdTSufKC6uv5rd+AfivfDxB0xdPC04uKAShovWel4UPWv5jXvO57RwMKOBLyVLM9BJmiKHmRJ11NweNxyvKr0I0oiUTFAiBj+Z65bLgsgf8LnEc4vPLVlJChQq4zhrb3jw3DENTvJnj/XXCo5DNqAw1+cbWcDmphW9kkVlXqtlCl7ZRFsXs55t6eKN85IkdxEPDKzQeELzgXEqpwAm76VHw5BQUk7eq7/W+9rtUsL3tvseNeGg54NjZPVlcG7/hs5dqV0ekMwh2hWJsPMM6j3cmc4glhRAIyIWIPBSmlJBpg5VRC2AFRz+5xm4ilhELGBY2HMcEc4TftsR8Nkizew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcyPRc51Owj1mt4UWeGJGZCzDCjAz7q4RpMHj60013U=;
 b=jh4x3ZjAFXP74XDbo6Ozj07KQWXhm6FK4nfwwFj5gP/yu9PdZPXJyDO5MwDeFqMj353HraweNUaf6vg9MK9cSOCSFO6FcVZODRHdtCAsTMCrhaKtZEeqTV/1PSwWydh/bQx1QE1z5ygSboVCrWH43Qi0eWsdW40ZRDezbmsq+pHxz+i9+HYyW0ECPdyHMFDRP4wGH5RAg0Ef7zKPr79k2a5yYatATjQWylv8O4HYF5Wq4YHzukhhreRx44c0wCa0jjhri3Jb9At4X7sbvtOKCWkPkA5ugM/DM0xE1dB32YSXQznaW6A1Z+JALZug9JzIKiTKJkb55z+frHKj5/OS2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcyPRc51Owj1mt4UWeGJGZCzDCjAz7q4RpMHj60013U=;
 b=xCuZfjlur7tx8uTuYGlda1+NvTFvSwSLJQHUaovpcaXninft+ZtTsMmxzCHPyJDkYopHj6zJ9h8KwBtAPznDpFheAoQNxrix9RtPVhQWpHHMXLTbiLSHdbcHJqeOmvp3+JKNEI2XYpANRpCce1kvPflIVrs2VUbsQ224+AqQ6yg=
Received: from MW4PR04CA0075.namprd04.prod.outlook.com (2603:10b6:303:6b::20)
 by BN6PR1201MB2545.namprd12.prod.outlook.com (2603:10b6:404:b1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 18:01:13 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::a9) by MW4PR04CA0075.outlook.office365.com
 (2603:10b6:303:6b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Fri, 5 Aug 2022 18:01:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5504.14 via Frontend Transport; Fri, 5 Aug 2022 18:01:12 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 5 Aug
 2022 13:01:07 -0500
Received: from tom-HP.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Fri, 5 Aug 2022 13:00:56 -0500
From:   Tom Chung <chiahsuan.chung@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <Stable@vger.kernel.org>, Chris Park <Chris.Park@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>
Subject: [PATCH 24/32] drm/amd/display: Check correct bounds for stream encoder instances for DCN303
Date:   Sat, 6 Aug 2022 01:58:18 +0800
Message-ID: <20220805175826.2992171-25-chiahsuan.chung@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220805175826.2992171-1-chiahsuan.chung@amd.com>
References: <20220805175826.2992171-1-chiahsuan.chung@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce2267ab-d4ab-4891-b84d-08da770c7ba8
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2545:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i2Xc/SOquEZXcmQfPalSa5YYIjxXN9xsSOlWSQ29IOPfmBv67zk29ibrgHnGSmBcjseyePjSTi1Md5S4XIIqQnsV8jJXfF3MIQFfKNav6UIkMFbNwkapkptY1kqPlnddC4YRR10jbjzTnLail1QDbabDYbHosFZr7zQtcrDaeH9X2I1IQZBnqNhc1qR0doCnqVhDfjCxkyUDM7TlI4dcs2Qj/j4jjv/M8F7klo1FlH82SHJgyMRB3zIJi0wZBpCnIlZ54Am9XglyfYzrJEpv6ZkBNjTwNdY5AwWcRkvf2pBQTiPGNcHIwy7xq+QbkpU+brxsZ2ZzOtNV+JdNtAZMXTNDSIZlHiBN5gsMTFilYIkQl3jqPOna02m+b4nTCelcdrL4oMl4nh24oouimcf/jEf4ywzi9Y/H+XgjBBRrNs2rtlkN6FXAT6viM7oNhnLkYeJU+xVT3IEF2F5mZ1Xf4vDuyvR1lrKobuCX6HDOKNga95FfgnsgyHS5lrMIF8epGmyjue8U+94LssvFVD3EHzFZnCU2MbIO5CxK8a9dyUDafqsy4G9ISv0Q+ntOrtCS/pourBguMLMqTo2009YNhYJwt7W9866CVFdcPfhTTk0ATZ9c+tOhJ3xAm8yKzY0uyZ++LFg5UkyOTbiamPF+bxg2k3OzChnVP3nbpy234QetIhUFrda8SiCJF924/lmIQTlS4c+fcaCbAqi+ed8hvkOY62fmGRLIlcdqh0RcofSHJbPs3MyL4ey0V4ywzj7n3G4tU3JQGX0Noh3OW3Zje8XZYmzy4eX+y06gJGlv1eTWqMkUdkHNzjdlJd2hQcE3Fpi7gRMYH/0bY11hVMivjQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(376002)(346002)(46966006)(40470700004)(36840700001)(6666004)(478600001)(40460700003)(82310400005)(41300700001)(40480700001)(2906002)(36756003)(6916009)(70206006)(70586007)(86362001)(54906003)(316002)(186003)(1076003)(83380400001)(47076005)(426003)(2616005)(36860700001)(356005)(336012)(26005)(7696005)(8936002)(5660300002)(4326008)(8676002)(81166007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 18:01:12.2595
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce2267ab-d4ab-4891-b84d-08da770c7ba8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2545
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[Why & How]
eng_id for DCN303 cannot be more than 1, since we have only two
instances of stream encoders.

Check the correct boundary condition for engine ID for DCN303 prevent
the potential out of bounds access.

Fixes: cd6d421e3d1a ("drm/amd/display: Initial DC support for Beige Goby")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: <Stable@vger.kernel.org>

Reviewed-by: Chris Park <Chris.Park@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
---
 drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c b/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
index 0a67f8a5656d..d97076648acb 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
@@ -372,7 +372,7 @@ static struct stream_encoder *dcn303_stream_encoder_create(enum engine_id eng_id
 	int afmt_inst;
 
 	/* Mapping of VPG, AFMT, DME register blocks to DIO block instance */
-	if (eng_id <= ENGINE_ID_DIGE) {
+	if (eng_id <= ENGINE_ID_DIGB) {
 		vpg_inst = eng_id;
 		afmt_inst = eng_id;
 	} else
-- 
2.25.1

