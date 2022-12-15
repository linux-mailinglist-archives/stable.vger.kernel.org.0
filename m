Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF4C64D8AA
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 10:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiLOJf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 04:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiLOJfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 04:35:01 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2116.outbound.protection.outlook.com [40.107.215.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79772EF39
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 01:34:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sj0bAFn5Ab3SQuWsYAP9btnPy1D0wRHxqUyTek6zk5eB51Y10cZ/2/T2CeIYJe3AKLokoedn0tmIRuN9Rc2PEn0hGHSueLk5Q60JUi7VbgbjbEpyWeFyaXLxPd6aH39PtEJejLWh4FgnZIalcapqITPrKJ6pA4nPpUdyScN8gOAlVQmuGuy/pcWqHA3gaptqBUsEtxOBMjX4cB05UgZzJDbu1QzIwdPXcCrxmbNN+HzH7osBU7lQoUlF2NqdrRFkPuyRFUTnBj+Gow7c67LitK7eZ27nhjYltkJ8RvM/CVnAHPbx4053+NNF+FnWwuZqYmlmSM1RdKch7MJzA9+2ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jB2t4QbcKkadqWqfWRPvvGxGP1G6oJIAwy0BLn6Ol4A=;
 b=kfcMI61RZRSzxIB/QM6T5hnqzT7MPEj97nsnhS/CrJOiG/9PwX1+mFRLK/EVypkJ4Ul2PdM0TFuYwN4YSOlR3TUgWE/ShNP0X6qjer4OAeit8RpTuyIgOezvVPDduSDUQKo3MjNectcCmQEn44h9/p8xTxHFCeBAWxmAyRRQJlEr9baCam19mUWbw/1YsYg0+F/INqq6FoYe99ulgXahDRRNuoEOlMjzxehU25p6hZhnAo+RyZfkZOeONCWCr114oY0wCgKbrjFcTisQSMuZZptOKILNA7CKEJZUEJcl415DICavtBW9JbzWymBV5ep040lXZE2tBW7gWl4EpQb9QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jB2t4QbcKkadqWqfWRPvvGxGP1G6oJIAwy0BLn6Ol4A=;
 b=DgWoIrgv8BQ/Ufr5RVdZjm+iTFojUt1THyv3hC/JlQqqzpYlDKOHop46qcvHjv1b9QAtVyiDzUxAxlKFwDusp/13f1z9vNTPbz3X4f0YHZwfk31y1rb7dGuk2l5XAb99yUkv/9rcpj5QtpTnOudLOizxf3QW0grwJH71EyllwI0cauzvGDubDvCj2WH1KxVvxaJukstuQum1wKidabkJqav0wJqg1UEwzWSFZ788ESKita4PGLCYtimDn74pQYdaayTChk4ItMNQLnwQDnKiHu+3/7m9kzp3meWQId/WZL8a3lZFAy+VwuzaFw9XcHvf636b6koLJx/sIWewSel4Uw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3017.apcprd06.prod.outlook.com (2603:1096:100:3a::16)
 by KL1PR0601MB4419.apcprd06.prod.outlook.com (2603:1096:820:67::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 09:34:18 +0000
Received: from SL2PR06MB3017.apcprd06.prod.outlook.com
 ([fe80::e125:bcde:8a10:54ab]) by SL2PR06MB3017.apcprd06.prod.outlook.com
 ([fe80::e125:bcde:8a10:54ab%5]) with mapi id 15.20.5924.011; Thu, 15 Dec 2022
 09:34:18 +0000
From:   Wu Bo <bo.wu@vivo.com>
To:     stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Ken Schalk <kschalk@nvidia.com>, Wu Bo <bo.wu@vivo.com>
Subject: [PATCH 5.10] fuse: always revalidate if exclusive create
Date:   Thu, 15 Dec 2022 17:34:08 +0800
Message-Id: <20221215093408.43407-1-bo.wu@vivo.com>
X-Mailer: git-send-email 2.35.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0016.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::17) To SL2PR06MB3017.apcprd06.prod.outlook.com
 (2603:1096:100:3a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SL2PR06MB3017:EE_|KL1PR0601MB4419:EE_
X-MS-Office365-Filtering-Correlation-Id: cfb7fba2-b51f-4c46-9d78-08dade7f8a05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: waM/GVrW5cxnN5Fh0Nj/AwO6cmQ0zovkq43W4ZEMUs7Bq2WKSRP/CjY+3bXk/4nGeeKehcG4sjAm6O0fSLpuNRd3WKtE+ES7U2AoQVYy2Q3XsW8yC/FUoQDo3iqEndcf7xzwte4g6o3QtDm+L8rvOazWHJ0Wqdg+YRGZRppX5q2sgIRoIOXMSc6VUVnYbGQ6nf41rTR2aR2uLvT5oDsUOGN+HDlhLVVLonUYbUqT4ls0ahF4/Td2TON8tGmKJVEvxpkYaSHMajC52cZ62/+1ZzBL0N6Hi9ryRGqqSbNyC/+BdX3nUC9yviwaHSTmmwPxiENV55WDC6imxMsJK4kG29Mb93q6wQ6K9Fqej/6w8UJlYvmUiBmdJ4XZOPIOey0G23b7212qXl513aNFIF4Lf/ddgSy03CAjWddwdO03HMMaydhNgfquJF5CaBKtvZViHLCFcpciFIO5cThAZ0MPv6Y3QPNXEy4mEV/C8Fl3YCWAV9NGfzkc+O9j5y6jiGg7dyC8NYQfn9YrgNM7xQdN39WAj+5WkAxfZ7Ljp5Y0qLI9r9l7xeOl2nxaaVKsX6JyLdAilJfKb1eJo5+4Wqi2CQw35QH53EOdW4F1vsgKGk0+YvvNsARcG/Iu5LsoprIaGDUBVrrtszLO8qXB+LbIcWcolK3rmnQytfPRirIbNxXOBGd4BOeFGXquRP4f1dyy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3017.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199015)(38350700002)(36756003)(54906003)(66476007)(66946007)(316002)(38100700002)(83380400001)(8676002)(6916009)(86362001)(66556008)(107886003)(6486002)(52116002)(6506007)(5660300002)(2616005)(6666004)(1076003)(2906002)(478600001)(6512007)(186003)(4326008)(26005)(8936002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OVTeW66Es4bhP6w0/ZJHWoKoSuU72elY+GdeZfWI58CjxwWWTww09yOMWybe?=
 =?us-ascii?Q?j0uhpxuCACFlgxkcJp8PBSUY/TBYDjrvB6KbP1Q5WwntWi44tyyuEM6uIZvH?=
 =?us-ascii?Q?RpfteRtBxosrbx6PSkKLT2n8R6RxF5i7R6+Q7ERojGel3/DHCqHpCxbEru1W?=
 =?us-ascii?Q?OySc/rR26oQYgzm+JlVmuEBn/iRwrGS2Q2CMeMDY1R7Wtic3TRS5evALfWJq?=
 =?us-ascii?Q?WDTEJihoxDC+KUof2V8K4e+Wi5Rla+3xCf62EO3qF/XezCH6sJa31Fynr8ED?=
 =?us-ascii?Q?jeGk4uZHgrC6jt5IP1CHwXOxgjRi3+mgCa6lAhqQDwxpw+8p4rqL6YHy60Bs?=
 =?us-ascii?Q?33DIDzf9VjXMBTE2bIOo0mjbXyWaBSaC7Z2vZuLZbfZUGSfloHXe/0emGHBz?=
 =?us-ascii?Q?Nl/cun3u+ZWUz8+4PW0apnke+28yJBlDQAXLTwH4Kiqp9vPLFVNMh1QwLkQ7?=
 =?us-ascii?Q?94R5yIU79iqSmU+8+iaLJkSQg6sKCVuUV6SP94M+JF9dnQqr23IX+v+Bwno5?=
 =?us-ascii?Q?Men/Cc8yeGLghN7fPhE3/VRpmNbv6DY8RS+JamD9P/VWedVBc3sugy+BoPQZ?=
 =?us-ascii?Q?FvMwQylU/wSc2WIPlnVvJcr1vemFfQQcFlKXpzy3GUVpoOWc0TQqmB3R2HVM?=
 =?us-ascii?Q?mrG/GFr+mla5b2K8I5zhawSSx3x5nPLxQ9igcmquMN9DfyQqw6KDmXTXS2jd?=
 =?us-ascii?Q?kUAcEUQh4uH40BFMs7SbLLlzc2EoKT7XLNSwR/bxWhSJcTNwRl8tZrpJutV4?=
 =?us-ascii?Q?pT+W0aUOSkg11G4i40zIEgY9IC3mq77PjQFF458QpylY/IbxrgAT6J88YnWE?=
 =?us-ascii?Q?7tkzLLKRo072hswnMRMWQzWGgKmr34FSQUUfC6RNYnyRGCFuIAaG42Y92VIV?=
 =?us-ascii?Q?BB7/8FeVejxpcIjYuDtwrZGBp94D0Bpi8VL15Hjb/Y5G78r0gfpGE2mQLE5E?=
 =?us-ascii?Q?i/JCnA18iWl2T2xLXhyZ1V7Grcy+oW7R9Jdxlx0ReOVHrXldUZT2rF2WXJCi?=
 =?us-ascii?Q?NM38dOexgfxwh+DzwyTZDN/sRDj09GddKmVlYyo2zMJExStPdFP9rWv98NK3?=
 =?us-ascii?Q?fwhUJZ1jyooof8Xt67CIBUPX7rG+Wyw7G7HbtngeibXGwnCXDoVXNKuJvkAi?=
 =?us-ascii?Q?t2DBjZJz3vcQRlGWw2ajJKb5Zgs9PnK3QRSgLX8kzm+xyaS8hIWhM9LkxUVL?=
 =?us-ascii?Q?6Y3Q78K3bG0n4F5YF1xoPNOdxlfLOaEVVq99G39W/oeSSmV+Mp88vrz/8eDI?=
 =?us-ascii?Q?04kkYLK8pcDKsp5pAz/NPwzO7/HZCr3DvrzvgM3Gf1J2x9+kHD89Z8sauU4k?=
 =?us-ascii?Q?qVVDQkGMKXxhCwfkLbVdpmN+Ov4TRUpkMpDbGm4IPj15Re7b4YqL8g06NAsd?=
 =?us-ascii?Q?CjSfGrQGczdlRtkP3Cq+xGIKwkNwAEaBIIPzZ8/pR2x2VdM3ww0/LXdcyLB7?=
 =?us-ascii?Q?9tWIu4gKImaaHUG13kWnSLWw7SSWpzZdEd6zDYB2tXaVFxpjydGF8Rh/FxFX?=
 =?us-ascii?Q?96Ia2W1byLi3HAXMfax9QH7jKj7UFXW1lEbM3YRW5QCVnIE3Lz5SZ14ozqrq?=
 =?us-ascii?Q?Fa5VzzrI2NBKfkwkrgCt3x1HDiymVtfpQxWyp4h7?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfb7fba2-b51f-4c46-9d78-08dade7f8a05
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3017.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 09:34:18.6526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +wTpQqSBiR1Zy+RhSxYD+dyIonjNa+vso9p5gjeMSw3V2LOTFRhFMOB6CxDDcZz9MqAgnImo+ROAwYmnJeRxMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4419
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit df8629af293493757beccac2d3168fe5a315636e upstream.

Failure to do so may result in EEXIST even if the file only exists in the
cache and not in the filesystem.

The atomic nature of O_EXCL mandates that the cached state should be
ignored and existence verified anew.

Change-Id: I0f173de6f9f1af05d6e816246b5c56b670ec079c
Reported-by: Ken Schalk <kschalk@nvidia.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Wu Bo <bo.wu@vivo.com>
---
 fs/fuse/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 8e95a75a4559..80a9e50392a0 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -205,7 +205,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
-		 (flags & LOOKUP_REVAL)) {
+		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL))) {
 		struct fuse_entry_out outarg;
 		FUSE_ARGS(args);
 		struct fuse_forget_link *forget;
-- 
2.35.3

