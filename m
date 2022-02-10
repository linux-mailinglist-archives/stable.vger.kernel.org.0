Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76F04B090D
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 10:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238137AbiBJJAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 04:00:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238141AbiBJJAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 04:00:36 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2049.outbound.protection.outlook.com [40.107.22.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2C41091;
        Thu, 10 Feb 2022 01:00:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjO4LK+SjgjADEdKSe2R39+znUyU7PDmXRfl0ElIuMDdL1iKcgoxnbzQ537rPMLm6YSRKixFXWbDBLNTZmaWJdrTm/o3fRHxqzfj+8Md+qiyW2SaZWGM8FTLxGFuuN73NUw+NRkvQUeoPjtRHcTc2y+J2tbgy+Fll7VcsX2hj4dUFMfkUwxzSP2hbjjA9hzyTVyqwLLfkv3BgnH2aoiEvFrLVW6zgha6mw5Td6/a+Hcl3q32Cj2FqCXDVKH03uph9Sb8T0naEmyVpuLnxMujdcTabGBZQM/d8UA8oYV5GVYsn8o7g9dgGmXTEybO+rnW1DFSCWCDZVmq44JAZ0IlUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Be+nfvf4zKqJtYrrcYAY736iNotKqaVy2D5KpGCPUc=;
 b=ahHRvBN+1y64dBjuNAbPMDkIP8OnrnGJUaxFNW7AhBJiT76mHPLqZQpHGZDCcIXf7EVH/Q5b2xkccoQE3sYTzUr0HOFP2OGshMexCM9dl5KGKDIkHzh60HAUw7R+pm5Sfc6rMB/sagfElTVGfGbL5Rd9hSckMKDyvTR4mEvye3cmv6FrBGABAb1mE0q10+55gGYzZUZqQspSuLkEgWct82l2sLlCl9dN2BjIrKgi/YnwG1gAFgCxwiBc/qxjzkpUpScYBc3nNFF7Ra1fW77wfkJ3aHzIkQP9pEoNNinc9BdzIff/o/gt7EK7HPajT94ifFkh+MEdGm4uigitzf5GzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=KoCoConnector.onmicrosoft.com; s=selector2-KoCoConnector-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Be+nfvf4zKqJtYrrcYAY736iNotKqaVy2D5KpGCPUc=;
 b=j9GdRxaUCvhB0WcuTbwGqH5tsHB9gg0lbCyEnB0KoUHnZSH6TVVOEsJGrh1BKj2j60mimZccPKXwD/104Z8mGy2d7xJW8+Fuln8KeUjqXNAvFowvgKFYzDyvlsdiZ6AbOlSbOB4X6Jfgq0WwWXEJ9UhCrEQlUel6x0eywgNzDz0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kococonnector.com;
Received: from AM9PR09MB4884.eurprd09.prod.outlook.com (2603:10a6:20b:281::9)
 by VI1PR0902MB1869.eurprd09.prod.outlook.com (2603:10a6:800:e8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 09:00:35 +0000
Received: from AM9PR09MB4884.eurprd09.prod.outlook.com
 ([fe80::3c7a:2af6:3623:4c3d]) by AM9PR09MB4884.eurprd09.prod.outlook.com
 ([fe80::3c7a:2af6:3623:4c3d%7]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 09:00:35 +0000
From:   Oliver Graute <oliver.graute@kococonnector.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dennis Menschel <menschel-d@posteo.de>
Cc:     Oliver Graute <oliver.graute@kococonnector.com>,
        stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] staging: fbtft: fb_st7789v: reset display before initialization
Date:   Thu, 10 Feb 2022 09:53:22 +0100
Message-Id: <20220210085322.15676-1-oliver.graute@kococonnector.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0156.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::23) To AM9PR09MB4884.eurprd09.prod.outlook.com
 (2603:10a6:20b:281::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a728f69-9297-4913-bf6d-08d9ec73cd04
X-MS-TrafficTypeDiagnostic: VI1PR0902MB1869:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0902MB1869E881F7B1746E44FC93CAEB2F9@VI1PR0902MB1869.eurprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1inGot3X1lVcBZPjdDPCM6JP4zeX0HQO/3mnEXzHVQScGvSQUnxIdc5bOsZxVFZxNZ2Iqec3tJ93NwSG2o3cg+7lUor6u2HE/YB32w10W7rKOBqOwyQr/1F/UZSrmwoIVeDxNEtl8EzDjsD+pU3ol088bf5xqJQzXa7ScCqkZSo2e/8LjTzIRo86088d4ZKRQeZOoNYNjJfqUDk2aXJeKc4UI7hTKWtZrX24uF9y8WsDdvRbpJkvkCI1LbgUlPdAp/UO8gKCI5uEB5VW5o/bhYuCxbwmADnFglSagzwor3fAlhhyfLLm3BL29Jiw8HyiNWp6f14H/CdisVSIqXSDz+AmW/Q7BYZqhj78Z9/uFbtvN+Kn8mjTLwPg1HsInQwODRhpEMe1dcuB902zwGON92f93ADw43SqPearTHE+U11BcPnpCHIDswvs1LZxUa5Is+1U4cZPggFHiCjKp6jcsmr80Lxr8ILGbt1cPghCg4Rv5q8EC9rFrIxogyT/sCL3xwlGM15pKMjKC9mMdRVjyu2e4wbeUKNzEg6QgmfLZkjFvPwluCA0WedS7in1ICiODcsqYA3VACJ/A07AwbccsRglVv0kmt8t+yJoE+LraIU+dfZ9mAtkw6Ze9Doa7fDT2YQ58VyAUjHjf0gP/aNtHJWTm+myt1gZXxqta+jobPXy6o6UhwNGvPlrIxJcBLAr/WkqQQYw/rn9veGVxPIKJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR09MB4884.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(136003)(396003)(366004)(39840400004)(376002)(508600001)(2906002)(4744005)(1076003)(2616005)(38350700002)(186003)(6486002)(26005)(5660300002)(38100700002)(6512007)(52116002)(66476007)(66556008)(66946007)(316002)(86362001)(110136005)(36756003)(8676002)(44832011)(8936002)(6666004)(4326008)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rSG/3dJMxalCLaywmxTZbdYHmKa74/Ogl+drNMPWnzMZ8VyH2DUwY4qBiN9+?=
 =?us-ascii?Q?mYd7rT8JbSIf7G12+mnbfN7oCh2fR7DXcxxk8CNGc+4jfR/1yAe8qh1GDj0P?=
 =?us-ascii?Q?BUEX33nDqTNS33zSS2Ap46BHOIrBqY4q1dykjwUNQZSRZ1Jn//2Y2pRSzJ36?=
 =?us-ascii?Q?yCqCnke9xgbjim/Y7H3TMD9Vb5Dooz2JMZC5eop2LOn5EfNhseUkOA3Y5iV+?=
 =?us-ascii?Q?VQjOED5xQ+MbkTqGBP0Kmv7s0ekLfVloAct8YGfsdKT2zF5z7j7sWCffBMZU?=
 =?us-ascii?Q?0kxI2wLUwQl7XzxESC462+vow84rTRN401RW2rCtPx+nk7g875uxm7laRD+T?=
 =?us-ascii?Q?wmAxIfmGof3gfxPAg4y757xH/LUzXMs09tWx7L8N4QqFyTPgZX3RSj5ti+hb?=
 =?us-ascii?Q?5+ryPrBmRt5M24AZSjlBTVH7B9O+KlUU2eHG6Io6YYI7BMnqOsMnyMorneNE?=
 =?us-ascii?Q?4dqWHxC0A+9chxzPS1iapJ4URy2IXDdS3BzTQgcEbR9uennaqwQEf/UYarYn?=
 =?us-ascii?Q?hlKaie0Kuq44dJXiOdRteS9v7yhowm/AVxs0+K+Ggby8h/WY9Zr432uSa463?=
 =?us-ascii?Q?Budz+1jo+08LUoHPkf7whGx/v6GmSf7oJaVEz1R6rspVhWCoE8lrW6b5RlFT?=
 =?us-ascii?Q?KL6wGYOpZfzLcvMkQcn94vfIduk89xCgUvM35LpIhkMU7zD4oZui4BTlZ6Ap?=
 =?us-ascii?Q?koilOzEZ+oreKDzS+5U2Jbo7Jx/aivU5WVtExDGHYITLD/Lck24BWmCOPqO7?=
 =?us-ascii?Q?E2Ig0YGeFrL1RDo2cC681eWrFcWSCRwVEuuhcbFEllbnY0tnSoxgu7QitclL?=
 =?us-ascii?Q?90WyrH/0wiANdu840lLa8UKyKl/+HahYkYI8nREAUhQoBXMdWq7kfrSmW4ri?=
 =?us-ascii?Q?EnjJVgjbT+E2gwDQqn7OJTtRi2L1kqSMEQgHqvW1CTt4/Geh8UKUZoZQkMJ1?=
 =?us-ascii?Q?gZvNE5ThfPF4UQ5eE+Yc0/qhz3biHE1hwtUzDGIdFELktmvHsPgFO/+rNZaU?=
 =?us-ascii?Q?5An0ROlM+LL1xTox7xy7oqrezDsECn8Ng7E0MlweLp5vRf5CwEJXNQEgTmQd?=
 =?us-ascii?Q?QDfti/Asbjn1n0esYKRb92ZzpZhLEM4xxwH8Ie6Mj3GGdv6v07f8K+wmN/eZ?=
 =?us-ascii?Q?NJdVRFlUh/zeAP9a8i8uHvCLXUR6Q0k67ESO7e99SSRyLdMh4jaqedN0re+z?=
 =?us-ascii?Q?c39h0vlFVsO3xrxBtEB9GrV5dj/phsYHdj7kGWHh45wwfWVkKwuA7wAjhou5?=
 =?us-ascii?Q?hTttL7N7dl151ZGSTrwoIdRc5NcYpzMxLu1jeDT+t5VnkHTVt7yWFFSSsCHu?=
 =?us-ascii?Q?hV+tiy3wzSiAxAxMq3TsKu9Mx3+OsR0p9zXzMltxNnjTLHkMcd40P0VJUC5m?=
 =?us-ascii?Q?3FCcj6it0I2q3jVQoApXT++J/HPaR/di8VsRH4cpFqH8gZEaGqi1jexcCF5J?=
 =?us-ascii?Q?VCmqqPzJedeXzvlzDRSUrquFvyzhQ/1j3cVM/4Rxqw4v1I7oAZEKh9Eu5gVB?=
 =?us-ascii?Q?8zKT25fUZHAQOk0EboW087brhSX+cdmSm13Gii+5uDEbcjLy0QUKMtmlz8F/?=
 =?us-ascii?Q?8p0ErpyqzeMvk4AjN0OPBmfAE677mlL0pshhkNlWYDYVj7u5BaI1wWWlcwYN?=
 =?us-ascii?Q?hWLI2wEFIv9j5Tx7Imsj5Htw0oa7yzCOHMVc7R1lFLHpfG7ZGqlANACQcv+p?=
 =?us-ascii?Q?dqoAqA=3D=3D?=
X-OriginatorOrg: kococonnector.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a728f69-9297-4913-bf6d-08d9ec73cd04
X-MS-Exchange-CrossTenant-AuthSource: AM9PR09MB4884.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 09:00:35.6388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 59845429-0644-4099-bd7e-17fba65a2f2b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ixmy4AJ2EUN2Fq2Z/VnpoQLTZBacTg37gCdvvPDEUZ6NxHjnFLJvVULdSUOzpJBFtVPJKPPLImmw3+BLaFe9TgzWFlf1bOhlMHMP2CRlmsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0902MB1869
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In rare cases the display is flipped or mirrored. This was observed more
often in a low temperature environment. A clean reset on init_display()
should help to get registers in a sane state.

Fixes: ef8f317795da (staging: fbtft: use init function instead of init sequence)
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Graute <oliver.graute@kococonnector.com>
---
 drivers/staging/fbtft/fb_st7789v.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/fbtft/fb_st7789v.c b/drivers/staging/fbtft/fb_st7789v.c
index 3a280cc1892c..0a2dbed9ffc7 100644
--- a/drivers/staging/fbtft/fb_st7789v.c
+++ b/drivers/staging/fbtft/fb_st7789v.c
@@ -82,6 +82,8 @@ enum st7789v_command {
 {
 	int rc;

+	par->fbtftops.reset(par);
+
 	rc = init_tearing_effect_line(par);
 	if (rc)
 		return rc;
-- 
2.17.1

