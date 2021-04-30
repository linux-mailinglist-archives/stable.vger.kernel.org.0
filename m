Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2650436F364
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 03:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhD3BH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 21:07:56 -0400
Received: from mail-bn8nam12on2045.outbound.protection.outlook.com ([40.107.237.45]:52257
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229519AbhD3BHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Apr 2021 21:07:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXUtedmzIqzdY8dUMJAtY/4h2QKEsWRajk4+okkaJWf0jufq01mA8pS+ZV6ydhgp7rTHepXzz1WzD3n/KFA7zV2KNFQnt/88yw+XsW+v81jAMrXejWITWrThOPkrPviLboVlWaL8FW3ItIzYhE1FxGTQUeWM1LeJjlqy2fpYYRh8EXbyOhHoQ4JCBATq87hWWbpZjlCHKMO1HqmIQCcT8J8jrhl29F5Swd6JYxEIQCNKbSJCgvDRlGia8NxG1lhHJU1h1RN0zADbeBZ8sZhr/9LxRqVAxMk6eMVmUbF90o7PQNQ7WsYQmVEJDkD+VG9lzkpa4bfFGg4fx7SJS9z/QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqG5KEouhpFBHBAMNQiArRYQWHfKcQT6UHQxmfDTQJI=;
 b=mCbmu7ZNsCtEH+Jxhh7JKd6puj4UihrnCsi0rg0GcAtWqG/b8y9yonL73K+ok50Ep3rON3XZFCwPfANqUvkNPBuXQkd+QtR8hO54Btzhss9ro8OJLrFNS3z9w4JHQTa+N38LqpwX4BEMnGEe6EOBZsXb0+88ATHVccM9I8MetlwCXCLz+sItNnRciNFi0wwQkJ3q/DsSTb5efLD9/GZOTpKk540F6I+YlGnXq7LjG+OUARYnm6VrEhvY08cAS/eky/63ajSYMsXNwbch3HSFUofTMWb20cCRZ4UoYDs3XskdL3ApjLKtUTIZlePtmqz6BDuGIeYTJ8Xr5VeFHxpeBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqG5KEouhpFBHBAMNQiArRYQWHfKcQT6UHQxmfDTQJI=;
 b=jUAMn6DJYgSOFcoxxPQ12tT6LWTPhunhrTSQqY56YB2s3ad5zyPUvLYENFlonTlZheDJkGZN2HdcD/GibEqoPEiTp4j710ZiFMj1I0SIUa+iBATznQairGLtdl/K8p3nkT2sp+9GNzr9IN7yWWcKemXoKk3KfxD7yKvK/wJE1bM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2939.namprd12.prod.outlook.com (20.179.106.216) by
 DM5PR1201MB0204.namprd12.prod.outlook.com (10.174.104.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.23; Fri, 30 Apr 2021 01:07:05 +0000
Received: from DM6PR12MB2939.namprd12.prod.outlook.com
 ([fe80::8c44:4e91:880a:1065]) by DM6PR12MB2939.namprd12.prod.outlook.com
 ([fe80::8c44:4e91:880a:1065%4]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 01:07:04 +0000
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     stable@vger.kernel.org
Cc:     alexander.deucher@amd.com, bas@basnieuwenhuizen.nl
Subject: [PATCH] drm/amd/display: Update modifier list for gfx10_3
Date:   Thu, 29 Apr 2021 21:06:39 -0400
Message-Id: <20210430010639.958609-1-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.55.250]
X-ClientProxiedBy: YT2PR01CA0024.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::29) To DM6PR12MB2939.namprd12.prod.outlook.com
 (2603:10b6:5:18b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (165.204.55.250) by YT2PR01CA0024.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:38::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25 via Frontend Transport; Fri, 30 Apr 2021 01:07:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a5571a4-dacc-47ce-df1b-08d90b7444aa
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0204:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0204A0D544AE5E38CDCCFF04FB5E9@DM5PR1201MB0204.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QCWTDcWWyawAOckBC6hCxwTHuU8VzCscaFof2C2q9rM0Zwm70KTDqSu17SbmcaRhltj8aHUJm8Yp3mSez/yBm5LKbUA40wkpECNPK76+K7NUiUMhS+CWXwVNfL7binex7+tmELW7uzwHGD4e5OahNpeVzKwxge52FSdoVFwZZfJt9LfhCoP9dgCatCfoKv/Ip7TuMtYPhaLNxUYmbgB1VzmKlqHnlwCB942/WEObyYcpy9h/+fmv/5UB2Z4AO5ZWJ83dRCRTwNX56uTHD6oGgwzNdn1YFQjuaIoyx+qoXQlsjPnjfxD5NSJZHAXytw7myWmsJfH10eRNXJQiKWGyuFIXxRsLwKspy71jRYBBkekfR01a6eO4me050GBg/GY6L/rAonxYDnFMb3WaixmOd1RUueZOPBWr4vdMz1skofK8UDp3Ww+JBzIsvRt+LCFqKcv5wqTWB3PSM0ix/KthELIx46zfQ/KH3NHfJyokAYVDrV1bB8jMRz9lgqxaiZT45U3FjEMGBKwT29HrNdVDdqbYVzO78joC7u1iHYzG57y3PR7iMymZOi+LKe29atu8ou1gaM7mqe4dS5i1OH3og4JDGfrmOTzBNqyXRDmzz4+FoxLJ4KrQQEgAgfZWdkBKZbUHiNVjrYs5ZtBoFAIjO1QSm5/nvlGdqYlGNqmsFZjSUvmzel4L/dNqF3IOVrOw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2939.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(16526019)(186003)(36756003)(26005)(86362001)(38100700002)(6486002)(956004)(8676002)(44832011)(4326008)(6916009)(2616005)(38350700002)(478600001)(6512007)(8936002)(83380400001)(6666004)(2906002)(66556008)(52116002)(66476007)(316002)(6506007)(66946007)(5660300002)(1076003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MWTL+Rf8bD5hBuJgKh/0N190vj6Iloiu2nONCvTEmKWYhVThyUeFfUQctMEE?=
 =?us-ascii?Q?Z76e+nZ8o5GwjWrC1co3pmlJAy1PhbvZ/Er+MFiBRG8Eq3YbLVCZB3EIBH/y?=
 =?us-ascii?Q?fdoyREZXs5+a7g9KayCnJztdWonsde540dpu37I//QLA4ETID0a/Y/9S+0nW?=
 =?us-ascii?Q?ql7axL8lybgaahjcewfeQSi3mCewewL1tgz93ygv+6C5rbGS8eUUAZY3q6kL?=
 =?us-ascii?Q?Bc4Q810IbvHOk/qvfjuSb89BM3YR2P+Q4s4+62FeAjV07O3ho4moUWBbSXhT?=
 =?us-ascii?Q?x4RuxJvnryWnnNC1W6Nl9ItuZ7Dsq/N6OeDv7TTslRT5vKpGnLhHPlYEG/+m?=
 =?us-ascii?Q?gtwJ1LMc0wrKGIcp8A/m8GGVsFGLYxth7I3n7O/AqLdhzrnCeO55HVA00L1k?=
 =?us-ascii?Q?s7o3KBJFa/Y6et7LLZYrCvfbieV2BU21drIKht5NOYYe5QmWEGNklGG6y04q?=
 =?us-ascii?Q?p3vhRaJBuxxgZjQeDtTSF9bFA3Bukh5XLBKLQhrV9FL/DSx5lFBiDGz/eobR?=
 =?us-ascii?Q?byidI5oYT04nPXu059+Vdt8QpmlCVm5qHWYpZIgreSNBagDDMF4PpYGZdO3Z?=
 =?us-ascii?Q?1PZVGmrmHNxbiip+TnPwFeHhudcUgsvRyLT/IMouNsoIc0Gyx6upS09yvoMR?=
 =?us-ascii?Q?KOQSg1g6m7S5o6AlkBQhqWln3ZC7pIYdBcCn/PtgCHQxRZAJ2fS54lpVeC0i?=
 =?us-ascii?Q?pI3YAFErKEMSpdH0vwQRQi5Y5wLkGuPsRLViKkAlHMP6z7LUyW5T8ENsyeWD?=
 =?us-ascii?Q?nRSl52t9hzizvDaT6XgRp49fw6m3qq7VNpXo7+3t4+ZsnYOkmsMC0tWmUzwL?=
 =?us-ascii?Q?gATqCVS52kNtf3WIVab45D1a9oht35Fy6aJTdZNUav61R7sB0qKqJsNVT/j9?=
 =?us-ascii?Q?hwHUU/J4VQj9TyiLk7nsXu1rfx2LTf6kHcOogTkovqEGCSQCE7tBDSom3pCp?=
 =?us-ascii?Q?W1ky83ApSISL3ZnoQ64stjYtQVyok81suzA1UAxdG2k1NdlegMgEd718btIh?=
 =?us-ascii?Q?u8SjYeRouafmHfgOlp7IK7eF8xgCntxi34Q0jB/9hYDQLtb6pTWYGDlsdDyU?=
 =?us-ascii?Q?1N0Z5X7R8rFkQn2S12IR9s7f/hz6gmdDJBxPN7JChKjBFUkWubH5o/5XpjGe?=
 =?us-ascii?Q?AGT/OxzxxNCFvS12DcKvXAcNF1ElgI0uKbqDn4tQ2nKeVgcvV3qjBd4Fvvq5?=
 =?us-ascii?Q?qGcEfaPiDlCDm+uCHyBpN5NXLJgN3sF5ImMU/stmlGJXEeHJXHqdoNQz805O?=
 =?us-ascii?Q?/JLuM7Dc4eyXZyzvelr23+d6UmgIpFqfBHs65zYlp6/z7/MRxA/03+xbr/tq?=
 =?us-ascii?Q?fwGRUuOKErhaxsubSgrOu0x/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5571a4-dacc-47ce-df1b-08d90b7444aa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2939.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 01:07:04.7535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCTahZgp6edVN84z2P2g9OsOh+xzD5DxX9eTcVDErm1csojDTqCx2vvg6wpa1ttj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0204
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The attached patch failed to apply to 5.11-stable tree, but would be preferred to be there.

Thanks,
Lillian

---

commit 6d638b3ffd27036c062d32cb4efd4be172c2a65e upstream.

[Why]
Current list supports modifiers that have DCC_MAX_COMPRESSED_BLOCK set to AMD_FMT_MOD_DCC_BLOCK_128B, while AMD_FMT_MOD_DCC_BLOCK_64B is used instead by userspace.

[How]
Replace AMD_FMT_MOD_DCC_BLOCK_128B with AMD_FMT_MOD_DCC_BLOCK_64B for modifiers with DCC supported.

Fixes: faa37f54ce0462 ("drm/amd/display: Expose modifiers")
Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Reviewed-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Tested-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 54fd48ee5f27..62a637c03f60 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4184,7 +4184,7 @@ add_gfx10_3_modifiers(const struct amdgpu_device *adev,
 		    AMD_FMT_MOD_SET(DCC_CONSTANT_ENCODE, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_64B, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_128B, 1) |
-		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_128B));
+		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_64B));
 
 	add_modifier(mods, size, capacity, AMD_FMT_MOD |
 		    AMD_FMT_MOD_SET(TILE, AMD_FMT_MOD_TILE_GFX9_64K_R_X) |
@@ -4196,7 +4196,7 @@ add_gfx10_3_modifiers(const struct amdgpu_device *adev,
 		    AMD_FMT_MOD_SET(DCC_CONSTANT_ENCODE, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_64B, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_128B, 1) |
-		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_128B));
+		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_64B));
 
 	add_modifier(mods, size, capacity, AMD_FMT_MOD |
 		    AMD_FMT_MOD_SET(TILE, AMD_FMT_MOD_TILE_GFX9_64K_R_X) |
-- 
2.25.1

