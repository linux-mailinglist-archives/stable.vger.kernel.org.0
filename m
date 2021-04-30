Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7635236F522
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 06:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhD3Eh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 00:37:59 -0400
Received: from mail-dm6nam11on2083.outbound.protection.outlook.com ([40.107.223.83]:40221
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229448AbhD3Eh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 00:37:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKsKLosAK5fpsTIFn0c+HbRugj2YhQn9rZb7qI+jr7c3xDHtXhELXUbcq5rZih/IGXY27nW54aHAvMTNW4uBJTjSpCSNxvQSKosRLMCX0za3ew26/7TrMZAi5vc0AsLxQSY2QorZila+N+guLz1a8k4YqSs8W73iHUeBkERuK880IuPSJKpsx+5YURaH+ehtVf6cf9x7d4etcvbP4xb3B1FM/0eo0QYfEtYtjX3rj01sqYhAluL+qEu/z6OHaQPhHfcHCTgonetyI9dSC7yI/WPKsuO6KgS3Yl54KGoRkMdETa/PgdP9Bq0jqr7w7sCkWYsnmhMVnYIOssaW93lmUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S4Svcme3RFW2TVEudc0shQyZjcvPreEUMMY8epvbwW8=;
 b=W7kiooJiOb3NTh55otr6L2x2EAWSMTREknzSWvOLeLCJSoNazNZgn0hwrGqUzMCjkApFYi9yHEf3uzAVQaOKPfLkEFjrFBUxC4BAWUUGTsracwxdXUDfVU4SktiPQ8lrvmAgQYjVj7Xr/6L5ChtVogyI5kHmZlJeGhAUgJ0Otix4XnxTkNFKcT4LkduOrCJ881Xv0EkTkRC2B3wL3E9xUUUk4RgyOIMPeisKDdMSNtW0ibrAn3olLx4TaZ+XTted8C9ojvKvu8Im/xbg7VuTVnKqkFpSduyXJo+9OB0Nj+amspCYCmJdSD1XkitfH8gLkEOSNuhUEjSJnprWW7rd5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S4Svcme3RFW2TVEudc0shQyZjcvPreEUMMY8epvbwW8=;
 b=D1ZW7FPHZ1K/InHo37XeIlWX2wskl1uhPuf2FRSrw4QvTCkBi2kRZxC+AFq7UrNsxvJ/hvoIsAd2aEJlRkfLmuPBQjNGyz7rlPlvIxftWAwbNVOf0MxJWm3D05o/6bLaSp1/PZvpYPl2oxx0UZmdJA+Z9YRfim/K0/tgM5Pp4Ak=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB4488.namprd12.prod.outlook.com (2603:10b6:208:24e::19)
 by BL0PR12MB2401.namprd12.prod.outlook.com (2603:10b6:207:4d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Fri, 30 Apr
 2021 04:37:09 +0000
Received: from MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::3d98:cefb:476c:c36e]) by MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::3d98:cefb:476c:c36e%8]) with mapi id 15.20.4087.026; Fri, 30 Apr 2021
 04:37:09 +0000
From:   Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] drm/amd/display: Update modifier list for gfx10_3
Date:   Fri, 30 Apr 2021 00:36:50 -0400
Message-Id: <20210430043650.1317075-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [192.161.79.245]
X-ClientProxiedBy: BL0PR0102CA0037.prod.exchangelabs.com
 (2603:10b6:208:25::14) To MN2PR12MB4488.namprd12.prod.outlook.com
 (2603:10b6:208:24e::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (192.161.79.245) by BL0PR0102CA0037.prod.exchangelabs.com (2603:10b6:208:25::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Fri, 30 Apr 2021 04:37:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fe000dc-aec0-4999-de8d-08d90b919da9
X-MS-TrafficTypeDiagnostic: BL0PR12MB2401:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB24013D816367E865B0CE1C96F75E9@BL0PR12MB2401.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:206;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 686y7baWRkjYpoeYPL0iILeBcRrpKJeKH5fe59LnVq8ovId01v80FSJM6cJPIKriei/h9RSmSkN73oEJaQmB7g+dUg4pSYK4UVeGGMw8oMC9JLtp+1kkm0ANjpdgNwEkwxnilbLG6YJPuzXk7oZjErx0eT0q2G6eXds8f6Do9e3NnokaNGgdFtJP+sVy6YYJ7Q548n/VwqtgOkRNEZAyhWmeoka52GagOmqz9m5pIoY25FLARB+4V8n21ekmXki3n9Onnk/KIpO4fzeFPv93owSYdYiV3TEZX8hZqgs9MvFS9GHDamEeCpY19dEi1kKI4vizrw9xs3JrTEXC3FZOZlPWFDJAS+D5NRkcYIxEb4MdB9t7uz573B4EiI/Iff5hI2fNFhm4oPyqyclLn3t2KpgpjV/V0x6g0IQ9zlFmfD/bQj/EXjRxLryCnmvrqA6FbetnY6+rrj9g36eSk0qZLstGemMmXso0RrrKxDxGPSv3aIO02y5oxseWYSAxtpBJaUCTDiQCUjKSOxVgBh49w+VreypXDdww8yIGn6g98egc7ioOq9GZldsUEcVDMBPbT7xwUGbEo6hXKZt+0wKzOtRQ3W7nYuKi77G2L1tw0Hdv+HDoIMA2r9yMBcJfQ5VaOqnKLfky5pqgw/LfWv9oq9wzzsvjaaJBysVqXYMCU079m56Q98r4cG3xS5X1V0YP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4488.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(26005)(8936002)(83380400001)(6512007)(316002)(6666004)(16526019)(36756003)(2616005)(6486002)(6506007)(6916009)(2906002)(38100700002)(4326008)(54906003)(86362001)(52116002)(186003)(66556008)(66476007)(1076003)(956004)(8676002)(38350700002)(478600001)(66946007)(5660300002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dJQdAa1dwBoC6CYAGVySPFzYXXwdV5KqsnXhcLPeqW05JCJAk+lK1CSLZN/m?=
 =?us-ascii?Q?uyjIALupRxkTuozTObN5EwFSr/+aMhpCkFuwMZp5yfFNKhoRAR43Hop9pnA+?=
 =?us-ascii?Q?yHG+zuxPALkB0yNnBHQeIGWusv2VGRB1JjZfS4Cn9dFpnPzQUB7D4Iu6SKs3?=
 =?us-ascii?Q?bt5V2mcdiYrIstMIfSsQ/dU1ueJSSt13NmY491Ti/6uXjfbpwcaBR73iKA/1?=
 =?us-ascii?Q?tOKtORmnCNEmLM0+awebaz4kzbfmM1dX+PnmD6O8z1sIefr/+JlOrZ2adY8G?=
 =?us-ascii?Q?giw+gabauuzYFlWUuQAyd+biDi2lDnkZnx4Xvl6bZptyL6LhWBkF5+fbYJ7B?=
 =?us-ascii?Q?b2d/IY/rXiWkSk64vucZyS7kczsGqUte7f/rxhI44olFZsj5hDzeDcA0wqhL?=
 =?us-ascii?Q?U0Pe/B+pTDxckB+T0rr0TtOxPONM4criUiQeR+maKFc8LOMXg4DsCrbqKd+9?=
 =?us-ascii?Q?n5DNwOmJra6V+m7VkT3oZ1RkQyCJn2+x6QJmQ3Y8RqsE2aDMxPnQBtY8FmDy?=
 =?us-ascii?Q?38oJVwiMc09MzWm5k9jw2ozJaB4hg2jKBn+OrqFaPHaRQgUBUDZFmP8vwYJJ?=
 =?us-ascii?Q?lwdPxunbibXQfNmWE08bxdRyHkfA0D5K5W2FCiR42t1Neecs3+yzTGIhj/El?=
 =?us-ascii?Q?/sBlnLOQXRUo8r0R2GmO7jleCdepBJ3WPYUEOQvR7QoMZhG1yo6NbnpQBCU9?=
 =?us-ascii?Q?BYhGlgbX5uFpN+chRuOVeqqPliRgnZhdBuhQ9IKS/kYZ+dFYotfkxOs84zAE?=
 =?us-ascii?Q?zo0gIN/oAJZUgg6ns2KT4wkjxulDpc5g3T09HjNXhwJNY2EfopbrL0Ke9Rj9?=
 =?us-ascii?Q?VpAB18ZqDnm1kmfqNlfIrQaSyZoLQz3FLrYpMhKZsauvEtK2qVGjUnu/lumb?=
 =?us-ascii?Q?aMJ9q4S+ErtzpeWzVNyeJUAGUeV22NzZnPNlM1Gh482sRfDuEQp/tBioSI2z?=
 =?us-ascii?Q?KuNGO7ix1qvpuzifqJmsBAbgFPD3YJqm3uo19knjRpdEOJ/lz5iFchzshoFH?=
 =?us-ascii?Q?MLd6/aToZEyKbTmr93GKA3k+mAybk/fvnUn1FusU+z2dWJown/VrFa/8u1N7?=
 =?us-ascii?Q?Lj60rPH6QxK/tr4cL3S3KGcGbmL1fJ1CRFvYS8obzBnCYDkLPJXG5KhBL/mK?=
 =?us-ascii?Q?FNV0cdE5h/GXgB5uJspyuq6dqnhW+hcNJ6qMts7UW/ohP/b4U3dpiz7AIOC4?=
 =?us-ascii?Q?HmVdPf1H7ou8YUXVqSOGj7Qjt/SL+siH0uerFFAC5lSqmw6u9OhN2XBqQ455?=
 =?us-ascii?Q?DmMIpiJYmjYJ4AQqVNud6mT59WI6clF1WRxqSPFZLt8dGGHrU5Lgg8GZweMq?=
 =?us-ascii?Q?qr1hJrK+b+Fn2E5y+zQjm/VH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fe000dc-aec0-4999-de8d-08d90b919da9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4488.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 04:37:09.4288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bMATaItzJsR8yyZdQJTxeR0OE5XuRRKLN8Wsxuzu+iwDAl+fZ0A7d3v8BHR+mmHGaTO0rZ1i8pNS1RBMTySivg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2401
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qingqing Zhuo <qingqing.zhuo@amd.com>

[Why]
Current list supports modifiers that have DCC_MAX_COMPRESSED_BLOCK
set to AMD_FMT_MOD_DCC_BLOCK_128B, while AMD_FMT_MOD_DCC_BLOCK_64B
is used instead by userspace.

[How]
Replace AMD_FMT_MOD_DCC_BLOCK_128B with AMD_FMT_MOD_DCC_BLOCK_64B
for modifiers with DCC supported.

Fixes: faa37f54ce0462 ("drm/amd/display: Expose modifiers")
Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Reviewed-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Tested-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
(cherry picked from commit 6d638b3ffd27036c062d32cb4efd4be172c2a65e)
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
2.30.2

