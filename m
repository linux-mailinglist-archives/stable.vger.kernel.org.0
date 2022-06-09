Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9600A544997
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 13:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiFILBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 07:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbiFILBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 07:01:09 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Jun 2022 04:01:05 PDT
Received: from mx0b-00328301.pphosted.com (mx0b-00328301.pphosted.com [148.163.141.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB871AD8D;
        Thu,  9 Jun 2022 04:01:03 -0700 (PDT)
Received: from pps.filterd (m0156136.ppops.net [127.0.0.1])
        by mx0b-00328301.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2599mPdW006549;
        Thu, 9 Jun 2022 03:23:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=invensense.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=pfpt1;
 bh=hUmSm+0ZsnDtZvySduMKWpTud8E7yOYrS8jqo1Wp/oE=;
 b=wOja6m3f8B9JkGPKtFIKRKJ9rtmPNEfhGf87VkUGYp5NBW7YEJMFbuUqSmqI+xpjzNDI
 op2PUeJiIEJF9bkZUyq39isaHJ25bJHBxYuqbJFGMmgRiU5xya8jJV62IGYiWkFcTMUy
 f0OKsUfyNSiyq0Pifuj4wU/P2993FpkLMhpzE7FeqtEO4PeNnlygW+V7TvW9wtk2Jn5O
 J+1HF2djlO0o6Rk2zDbtguBWm2uqGLOg336PV6wKn89J2wE1EL8aBFqCYEHJ6wzJaAfD
 A7b++fVNvArBXhBRXEe3RWeKZnI+T1Vphmj5HiAilBta3jpwfUw0KwquDnYqs9O0jE3e Jw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0b-00328301.pphosted.com (PPS) with ESMTPS id 3gg3bp2dgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jun 2022 03:23:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XX8f9dGzErPbdi7BqJyPiFS8U+oQS1MDrBC7NR3EP5beKp/KPB4x3EbJQCgef9ZT7HHK6CJ7b44C/nVQAxlDGyqLvuDTpZzh0lEq/LYArTIOA1cZ6mManiSo1dKMPeanDLjChLvVQ/bcXDkAGpseH4K4EZ1VrRMMcJRrDz5zTi/euzNiXNNVRGGsDwhDcIBUSHxbdIs1lzeTsOP6UsENF4d6ZeAi1bB1VRSQTKIRumCPfEwV38fgpsMpGUmu6WRqQX7OUuyv1mjrYkgw+ymDZWWl2qtSYexUgBH5xbFUaZRXE22c+wCBhQaC7Rk0bOjr65RJKjUa/xqd2W0zU5RIbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUmSm+0ZsnDtZvySduMKWpTud8E7yOYrS8jqo1Wp/oE=;
 b=A+yrA4Y44rBmAYJ9G5D8NklqlXQap3GrppD4sUwvC/noDEsHjXqnDViyDDQihq8V5YdmV4SPB/8u76snQ5/Bp6R/vv3DE3P0q3iacuiaO4CZ25mPOb5kzDl4ScWtoImJcjX+jDmAC9cxrprQv9bNI0o2FK6unN/8Mgeu7Mis4063XI5IPRUyhXERb0bUIr3PIN7nURbfAwgEDvYfMeGVEIaWRu+20OW9VZSlqJCVXs961sl0kPx6lumaZs4xbWHrPwFTbUzEou2seeDRK7RwUTematTORkBV0dJt+EYlK7+BJ61UBT1FQA+m10jiS7uX7zEaDhEHv1nb79zM/gi0MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=invensense.com; dmarc=pass action=none
 header.from=invensense.com; dkim=pass header.d=invensense.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=invensense.onmicrosoft.com; s=selector2-invensense-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUmSm+0ZsnDtZvySduMKWpTud8E7yOYrS8jqo1Wp/oE=;
 b=h9FysRBKT08H2rAGYzfUKMOLQVYTMXQ7LMupoT/VNvz4s5d2b8fWKD4DCao3zx3ZWctb9WF2nY/hJ9vUKlJmYTvFBa1NW2NuPKk80Jn+MIeyDBAkuyM4aTYP7leIO1+incWE0itIjgb/Wq6rW6h5P3cmMEvr8xGXFbdmSdQ7Noo=
Received: from BYAPR12MB4759.namprd12.prod.outlook.com (2603:10b6:a03:9d::16)
 by BY5PR12MB4936.namprd12.prod.outlook.com (2603:10b6:a03:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Thu, 9 Jun
 2022 10:23:20 +0000
Received: from BYAPR12MB4759.namprd12.prod.outlook.com
 ([fe80::64f5:a6bb:b5aa:ce61]) by BYAPR12MB4759.namprd12.prod.outlook.com
 ([fe80::64f5:a6bb:b5aa:ce61%7]) with mapi id 15.20.5332.013; Thu, 9 Jun 2022
 10:23:20 +0000
From:   Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
To:     jic23@kernel.org
Cc:     linux-iio@vger.kernel.org, stable@vger.kernel.org,
        Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Subject: [PATCH] iio: imu: inv_icm42600: Fix broken icm42600 (chip id 0 value)
Date:   Thu,  9 Jun 2022 12:23:01 +0200
Message-Id: <20220609102301.4794-1-jmaneyrol@invensense.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: LO3P265CA0013.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::18) To BYAPR12MB4759.namprd12.prod.outlook.com
 (2603:10b6:a03:9d::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d729c493-490c-43e4-d13f-08da4a02138d
X-MS-TrafficTypeDiagnostic: BY5PR12MB4936:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB493660E2B4E968D0BA148CBCC4A79@BY5PR12MB4936.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8mfBue6jDeHGPUL+Hyi5FScTZH770v9fCO3HJU6aOwle5Eb40ex4eavkWzQKAhTDEzRrDxRHWm+m3tzhma4JLpQbN9vH7ujCc6K1ARkqKE+cPFToe1G9Mzv58qF4WxiZ8Q1jsLFUagbBtWD3qytYQPJLX0tSAhrc4kJfspx9/1/7ANq5Dgi62VD8aQlfgAoPoMI4Vt0F4E/bYWt362oDYSdIxP8Iq30gqIVv5moI77FP0pyhKqH81aFqaxXL4Zd2gkxzU4n4Or/H968RUFcro/NWfUd+6vOaJ4ySUo3LcE+A9FrH19RGLNChFxsnW0TNKK167/0KDe99ehBeouKzPJUlfZS3vWVgNfCfptQfceHN7Aaj7QomLmSLhMTBoopIiSb4eP1kE52Yj70/WqZWDzLBsPDA4ETM7tOc/Rsw/Qbx2MKAtYtn/H8yiCDkf0bh9SDCAsabIgmJ37xIJFNGiSGwaP07kqkOr8N1gSUFFS1mGmsP87sLnlNKvglVUFd+qSs3a5xf0Oj+qetIwyz4FUQ1A2pfvMYlljDy8yvOMe7vQLrklCk0uKeeKlQMsNECTD5ZsbieIAO+x/WvHRKqFGBVZKwTm4UqhpupbkMixBHF4s7mVI/Bt5xTmWy+fqf55f/fHMNpecel66WFV7bjS6n4NPb7seuY++C8BK4asDUqCOXJWqTUkF/8+V5Dp/ar
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(6486002)(2906002)(66946007)(8676002)(66556008)(66476007)(5660300002)(4326008)(36756003)(6666004)(26005)(6512007)(86362001)(52116002)(6506007)(508600001)(2616005)(186003)(1076003)(6916009)(8936002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zuf0ndmtM7BJ3BnXRQ/utCxR5jE90Ul4q7LSgRWyexM1qpdyOMNeApiJiw4v?=
 =?us-ascii?Q?b/xGSuPqP2pqP60z8BSwS0wPvUT7NGDBQwYS9sutaWYghcd70SqrGqVYM/2s?=
 =?us-ascii?Q?zuGxWN+pF/rqg1bgrdW4egn4uPhwjhQXA5pwFWErEbDSvHnJkgPwy3Xinj1P?=
 =?us-ascii?Q?sghQElZh3AWUkqotX2enCJeCrSQcpjXPcOJo7V3HSa2iZ4xKjm4YZIkPDw7N?=
 =?us-ascii?Q?8SmbR9YT6oGiaDZuwKM8L1Hlsr4Pm1A2NLnTSTxdLHIWFTzWqne/vmx5nQbQ?=
 =?us-ascii?Q?LXZh/gA0hQ3vVmvsZYvT6fXm6WKR2uQ7d+5/XWSr9szpgp+uNRDLiqjIjENY?=
 =?us-ascii?Q?dYg2VLCXsT904PSiAIjDI8Tc4YLGoMap9rIRjRLPgcn2gNRph6RGvTp9pNMK?=
 =?us-ascii?Q?0PtlH54q6d/jGbQVvfHtPT8eaicNECLedjD13ru6FBLvoab7c/71fSXzT6no?=
 =?us-ascii?Q?bkXyCZWTbxuPWLReagPJkmYwWQ/Vq5SWDRRcYbz5t76gUd1aIainS7iXl8ao?=
 =?us-ascii?Q?JvY+K8GWTQcZ5bUR651r8xuh+Eq2puO8JrTe/cb+toq5/qvJDbsXLHhIfbJW?=
 =?us-ascii?Q?rodZc8YXEj+a2E2/UuwnbVUpW0fnOWI81p1vRA3dELGRrkyQXppo8I64ldLK?=
 =?us-ascii?Q?Nf5I3BaQH0fShjN7ZADKxtBQ07wqVO0Ep7BZTiyjfsHJXBmMWLajHDAjc7ux?=
 =?us-ascii?Q?Q3G+J0VNKUiil78JR1o6p3j2YWVIKPOtZWaFtg7KYN5v3X9/vByb7nNrgHAw?=
 =?us-ascii?Q?GnhAAtAs4zhYFTsS4frSNow9AvY5j0KtbAPrVQLLNTylppy5m1aK6kr9C7Nr?=
 =?us-ascii?Q?TULj8CzYM6oil+PZe1J0keaDwAdo43AoifnbFH0XbWq+95EI7b5Ay44IuIcD?=
 =?us-ascii?Q?IC98ierVv8HGJ09qPI+H+HjEfTqEmCoekOKcxb2oKI0Jz9MZR/WkVIPmbowh?=
 =?us-ascii?Q?w4J+3Pttan/axB+DBPKLJ+tLdby5ZHX2FGeR+5fmMkMZHF22wERJXet0tpCT?=
 =?us-ascii?Q?q0m++26oIcZFb8811I2u97iRwuc3MGBnpzK7kXPvJfn34RoGvGLXf02hETe1?=
 =?us-ascii?Q?QLV/Isnut9HtmME0wBD8jg+baXg0jtFYRrB29on05Ikl5T9k4jJzfHGhLpBX?=
 =?us-ascii?Q?TdK2HjT+6BDrOQ1s2pt3u6ihXhjccZIuXTcw7ewqZndlbz+fmZEqXTXvpGwn?=
 =?us-ascii?Q?Twr+rjXnvHYHhfFBtISlwDpjVVPe6r/VR7BDQ/7rn643ailrN5CeN/bBKD76?=
 =?us-ascii?Q?f649pNIDh4+dbhYBEYUYF14PbeGNuHSvE5MK8BEtZkJckmM4AH0WiAGA0UKo?=
 =?us-ascii?Q?xe7AFZbkCnDDYaVu0+TgWuW2DtA7pceWLN8krHk2VSPBz93JrhR5AuEY/RKb?=
 =?us-ascii?Q?4TzBowpCNW+Hly9gz++uRNekaBnMKNQODsZVx5/Uge870heWIzJdeO9hPdjE?=
 =?us-ascii?Q?n+QrlnwVCJZEAAPLqk5hwSqzKt9V6oRSIFKyhS2FuwrWc8PwHyZbTU9Pl0cG?=
 =?us-ascii?Q?8kC8OItIegqK7ayNwOWmOWaNaClq+QZjxAxuUYThm/RLD3GVsGQmda03Wana?=
 =?us-ascii?Q?SzArh6fH3/33mSNlHSMza0nntbK1X+vJpzZUV0iQWi6O5JA0hJWvNF2lpM2C?=
 =?us-ascii?Q?y7RHNMRVtPUyznWQ7zn3Yq3GcNUfFjQ/2WGuxaq11POx1S9rBVeSpSJbhbGM?=
 =?us-ascii?Q?2qxnMcHI8wcPOavqR+knzpEZIIIurpfxotbf+zPXwTd7kVsOtgA1mVO7A7fp?=
 =?us-ascii?Q?TAAKnyyseXcktj9TP3H+dVf/PswTjRY=3D?=
X-OriginatorOrg: invensense.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d729c493-490c-43e4-d13f-08da4a02138d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 10:23:20.6985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 462b3b3b-e42b-47ea-801a-f1581aac892d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fm2yTAaY62GE40CJiB3y0It++46EpUi97rDS40jdhjbsgDvd3U1dA9+3B/EGA8QasZP8ShOF4LsLrEquFRRmFANtyXrqJ3LkuMxeExzhvuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4936
X-Proofpoint-GUID: Kb2ZNsfHV_FIP2nF056JBtpEjiQIwKP8
X-Proofpoint-ORIG-GUID: Kb2ZNsfHV_FIP2nF056JBtpEjiQIwKP8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-09_08,2022-06-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 spamscore=0 impostorscore=0 phishscore=0 mlxlogscore=671
 clxscore=1011 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206090041
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

The 0 value used for INV_CHIP_ICM42600 was not working since the
match in i2c/spi was checking against NULL value.

To keep this check, add a first INV_CHIP_INVALID 0 value as safe
guard.

Fixes: 31c24c1e93c3 ("iio: imu: inv_icm42600: add core of new inv_icm42600 driver")
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600.h      | 1 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600.h b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
index 62fedac54e65..3d91469beccb 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600.h
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
@@ -17,6 +17,7 @@
 #include "inv_icm42600_buffer.h"
 
 enum inv_icm42600_chip {
+	INV_CHIP_INVALID,
 	INV_CHIP_ICM42600,
 	INV_CHIP_ICM42602,
 	INV_CHIP_ICM42605,
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
index 86858da9cc38..ca85fccc9839 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -565,7 +565,7 @@ int inv_icm42600_core_probe(struct regmap *regmap, int chip, int irq,
 	bool open_drain;
 	int ret;
 
-	if (chip < 0 || chip >= INV_CHIP_NB) {
+	if (chip <= INV_CHIP_INVALID || chip >= INV_CHIP_NB) {
 		dev_err(dev, "invalid chip = %d\n", chip);
 		return -ENODEV;
 	}
-- 
2.17.1

