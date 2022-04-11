Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46CFC4FBAE3
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 13:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244698AbiDKLaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 07:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239843AbiDKLaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 07:30:20 -0400
X-Greylist: delayed 682 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Apr 2022 04:28:06 PDT
Received: from mx0a-00328301.pphosted.com (mx0a-00328301.pphosted.com [148.163.145.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F215838DAD
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 04:28:06 -0700 (PDT)
Received: from pps.filterd (m0156134.ppops.net [127.0.0.1])
        by mx0a-00328301.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23BB62LR027505;
        Mon, 11 Apr 2022 04:16:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=invensense.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=pfpt1;
 bh=tl4bVV8r/Qn5aIXQC7Ok1Z2S/lMkg7n/v/Zt/1kf/CU=;
 b=u7yPbelrsbiqyFpThEye5cQ93+/V0OHVnH8oZgHzFCRrVacfEQ96MW/qAe3S7aj1WHbm
 zxrVyeKcgZSdLk/pZG8hIM8U6tiVrNRu14Gl5MQSY+xrpjyatS5zPJdIs7PvaVvHQECf
 t2XVReUGQHQUd3z6BqrfUBdQ5a9LE68RLUCtxszYhgVa+NQUVaNDaZf0zALIAwkXzJ+V
 c71BTkfOuAJMjQo5EYi6fjNCS14SL8LlVQQ8vugOa4M+ccpfhvphqE4icle7hihTwyJV
 RwVKDDeJ4DUqtMnM3ZFs8Q8l6bHWBuaZjsucFzMse2vVyaXAEH9qz8SFkO01KAran4ZI oQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by mx0a-00328301.pphosted.com (PPS) with ESMTPS id 3fb5mm0tjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 04:16:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYPBH9EeCZrAmuvjgMeX63C86My//x0wW2WmM4n9CqYClzJfrQYU4avipLZrpkUmUHvT571pNPbjTg0SQYQICYZYKrU0sbVX/smAc7qs/nrQLjQEQ3JD6b8Vz7ZMK8P3CLc+VA9nng+i2j3hCpU67sHxA3BqC3GvDw5EtBdK5b3n7EsRGzuBUzDD5leSlY42HZw+/lIfgyrzeUa1fo4OtmSNxAr41Da5Gn6lynGy69XLxynAxrtaftWSPzQuxOAImYVF4D/fWq1pTJELhNZptQXPytORhzWh7+U4+MWdI2QUXX4QBO+7kvWixvmWjW7umNYNV28kV/a0K04gupxavQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tl4bVV8r/Qn5aIXQC7Ok1Z2S/lMkg7n/v/Zt/1kf/CU=;
 b=VUlnc8mbu9/KI3WSAX77gZVoxjfLzahAKahbWF3RF+bCyKKyg68XcIiHQjoJBBwGoSfg0ThtHWWe7BmNQXxB4VukmvyWUf2YUFgECqJHAJ5e9K0D/qLqv3SiHfFr3RiwuCdthkHPt3SIK4WHZx/VOvlGYFy+KbMh8Oig5f1LowIzdYk5fw6ZCI2DnPF4bEPuNiw2bYgD7gSD66L/9HnqhEuPtfAmyctPa5wrzDUg28lR9jRwZWgnknzlY3V8iUuJI+BubaqxCw9hfGkwXvM2BHy2AaZqO3p/av5Whf8y9EL8LIwcBmtLogkPcxf2wJJdShE4z7ENP60bOpzY20nwRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=invensense.com; dmarc=pass action=none
 header.from=invensense.com; dkim=pass header.d=invensense.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=invensense.onmicrosoft.com; s=selector2-invensense-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tl4bVV8r/Qn5aIXQC7Ok1Z2S/lMkg7n/v/Zt/1kf/CU=;
 b=kFStVst+BB1TZFVceuyoV0BzTv0/Et5KJQ/yHJbMFPfL1Ylf3ywqyNCJlFTAnRO6QOQp3Jt2EJvhp4xUSidI8ykL+hfukn6U6RvPIQW0nBT6ejjiN4PUQXjwIpfDNY1iXCZ9u2Ubd1+0SlMadb4OgdYklBknFbF0p8FWsNw9I8E=
Received: from BYAPR12MB4759.namprd12.prod.outlook.com (2603:10b6:a03:9d::16)
 by MW2PR12MB2524.namprd12.prod.outlook.com (2603:10b6:907:9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 11:15:58 +0000
Received: from BYAPR12MB4759.namprd12.prod.outlook.com
 ([fe80::64cb:4c54:5e87:543b]) by BYAPR12MB4759.namprd12.prod.outlook.com
 ([fe80::64cb:4c54:5e87:543b%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 11:15:57 +0000
From:   Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
To:     jmaneyrol@invensense.com, jic23@kernel.org, lars@metafoo.de
Cc:     linux-iio@vger.kernel.org, stable@vger.kernel.org,
        Fawzi Khaber <fawzi.khaber@tdk.com>,
        Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Subject: [PATCH v3] iio: imu: inv_icm42600: Fix I2C init possible nack
Date:   Mon, 11 Apr 2022 13:15:33 +0200
Message-Id: <20220411111533.5826-1-jmaneyrol@invensense.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::48) To BYAPR12MB4759.namprd12.prod.outlook.com
 (2603:10b6:a03:9d::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2bf7866-62b9-425e-9bed-08da1baca6a3
X-MS-TrafficTypeDiagnostic: MW2PR12MB2524:EE_
X-LD-Processed: 462b3b3b-e42b-47ea-801a-f1581aac892d,ExtFwd
X-Microsoft-Antispam-PRVS: <MW2PR12MB2524576718A76D0302AB6F16C4EA9@MW2PR12MB2524.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GR200GBXjJowgGli9xqm8n/CsW8ryQZ/VX4c2HHC6XvgVyGNGmn89LX9MaxqoAYydvLwQXq3OC8Zj6CKyfllaV2kLi79dH0Dg7j0z2OkyjlmqlnlZy21c0NNjSzXEjlfHywLSaN6qQ4SD9IQt1apyVOm3N0t5+CTA1ZJ6Wc0HCjkWXet8y0gwTfDdbA3zQrMC10irrghGU7ukETcm2CzkaAJb0kx06InLc01+z1VBiCwLkoLau2C+bd2FgL89Plg5xP5FFvBgAJ2gqserhoE/JGzQ/Jc+dzSuyhSB95oIJ9CY/dqO5/DDiPhxL8a6C7dSIeMw+zIAwzK9QHTtRloGwJl5c0R12QzRWkLp/IbcpI76TRUAmIjJ5N+mx8vg5LooBwwyd53ElB9725FEiyGRKG1i+60dj9BwAFc2UH3ADaGgnNd3Tt/vDUrAgs2eB22gUJmWiTqXeq8zA8+Ya3clZf73l1IplYxZRJt5jA4WN/ztTjU9Q2iXchXp3dhlHuXhySMHiP+A7MF0y+COD98IPqVrmcfZqLLAiRq3/wSTfElYHyg+rWM4o9nUHLwufq7HWO77cUboWt+rml7kiCF57AAGNfw6h2ncUbylUmxlh60B6SDy4OcdDojfZzr9Mg5xoQOvdZ0b9NrCGQfwo9qQ+nE8VWrtD4li+cH9tXJKKsSF+IHf1Jec16ML/cxxVdk947pph7ueaxGW1fXBr/jPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(54906003)(36756003)(5660300002)(83380400001)(2616005)(86362001)(1076003)(26005)(186003)(38100700002)(66476007)(4326008)(316002)(8676002)(38350700002)(66556008)(6486002)(8936002)(6512007)(6506007)(508600001)(6666004)(52116002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BLmwspDhHmGBWJbp1ZuAaKUurhCqALmhurhEiMy2waLILTesJkDQqh3soEpp?=
 =?us-ascii?Q?CSFRaqS4e859/LF777FkWqdfewRVJ9u30Waiach0M/o2TzAbfiojpzGgajqK?=
 =?us-ascii?Q?sQmPGbD72EaEQJYcbC9FFp4vx1l4ddqVXOr+/mCwzxfsQfPpRO+ilnTJm/EK?=
 =?us-ascii?Q?Fm0adI5YPRVRp/0QLfuM+Nsw4nxGSBiie6XxAgtY8tndKMhYEIsa8hcADYBl?=
 =?us-ascii?Q?DxuokX4Qpir0bwEetXnHRFGkXes+2kxgkr7IqTRdUE/0FbW17QfpHJR31nfX?=
 =?us-ascii?Q?5t98ujC5NjU6A+uhjiV1Y/fKpUyGSeShCjX7+BTJS/EUGnjpBeYiM0txaSGP?=
 =?us-ascii?Q?KZpRqLWr5mYYgaAuIHq7vZEiY1TxK1Xsxn1efrLN998drgqN58Gu53z13HTO?=
 =?us-ascii?Q?SRQEZeRhoIPnIapBZfBp5c66etEx374OgbGrhjV+ck/WGa/imj7a/gz/UGEY?=
 =?us-ascii?Q?HxXLHW8ugEp1hJckgkv2N9vaztYR7GXNRjuFpFl0Ey+i9kh6wAVoxQB23Jjb?=
 =?us-ascii?Q?t4fo+LMANcFjwRsXGRpIdv80VAVEWMlLBX5Ex0H6Cuv4jDyJNQzeau65oJFg?=
 =?us-ascii?Q?l/MEUS+IhjxFZdLFm/KKo8wO3AZGvQaC6+OOrUfCYtJgpWvnfOflorUrZjEx?=
 =?us-ascii?Q?UJGsKmHBibXTXl9AwwxEa+3CfUwI07u+1Qt4Cvoejonjym2YDYHUnq+XGO1x?=
 =?us-ascii?Q?7/9pURroUmA5rflOBxjNP2TB9/TeY3/PnmzNkHJ+eQimEJLWLbjanWMq2cQr?=
 =?us-ascii?Q?tO3YhU/Wfjz+UiFDyc26/gwzH7IC9iHsBNczE6t/9Rhu2tSPuOvUB130aZjY?=
 =?us-ascii?Q?0lJSs6vqRxuhCXWQbuf7VuwHVsBtKSZNa04EuTsWNfbfdXgn9rS9hmKqzcGJ?=
 =?us-ascii?Q?owSnGRSHAw0joo7qp092HUS1JdAIGE27kC99bbOcb8bSGM02bREdikQWm8uX?=
 =?us-ascii?Q?3Tq5phd+B+04/eOEiFi2crU2Q0i1wMB37R79YsuD3WSP6B2pGOwy710MW9jm?=
 =?us-ascii?Q?d/6GeinfDthT+0zYLppTAb4myajvggH2+EeqAQqpm0fpMIeIwg0+uQZ9VoX3?=
 =?us-ascii?Q?wn3yORR6GKDbzPD4UhlflqMSAJEYtTNGpqVY1kGxRrLzha3yHULzCYTwr25Y?=
 =?us-ascii?Q?NK+wN07kqnRVpME7gqTnnf0ePKPCFXP/SiavDXIUBl4l3A4issh8c2xsMhTc?=
 =?us-ascii?Q?3N7oV7Z+oPOldWoluihhPlVrUIHAHtXt9abZAKy9NhKRMOHFKPyP7k+uYszY?=
 =?us-ascii?Q?rtl8WuhImKnePJXnLKxlkwSXiaNEKCbcXyzTbCi/5fpbq3d3X7qzxU19zNFE?=
 =?us-ascii?Q?lTm40ax/kOllIfpPdcv0uc/vkH91QLp8dEYceryF/Jq+xvgHmXZv42G9lvgc?=
 =?us-ascii?Q?l83+P510Io3keeBOim+sEPYxSoeG3tl5uQ/DMZjpYSPE3oeW6L7i+e944D/v?=
 =?us-ascii?Q?Yfo8z9v/kA+eIo5ZtmtnIyBs6Kq6mqg1LyGca/cOKe7p/doTPpvgqRxqYuN7?=
 =?us-ascii?Q?Zo2wWET1kIcgfPwe9fb+5Lir+PC+/JVJC5a5yLM0HdJt3Cj6Y/Ln+xoNAiQz?=
 =?us-ascii?Q?z0RGggJUPl/Di8KQ1Cca5+QYOhy+6R7mau0BJzt893mVXBp2l0ADYVH6PS0I?=
 =?us-ascii?Q?KnoTASbFOn4+hP4rl2QaWsZZ428eCrKBEBrkRZw61llfKjTgiE8PTBsykmQD?=
 =?us-ascii?Q?x1/odouNt7TjMJiSJGq+NT5osiwiF2vLOSHdqZQx501tf3T5Pn7J0RiuH8Yq?=
 =?us-ascii?Q?N5UpH7M2uOfmnGtc26Ah4v2lo12tm5s=3D?=
X-OriginatorOrg: invensense.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2bf7866-62b9-425e-9bed-08da1baca6a3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 11:15:57.3846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 462b3b3b-e42b-47ea-801a-f1581aac892d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MKZ7caWUUpewsqsEuNGDjq34Skjk3ErycJVaZQbuRFwHRlgUXCt7s84feOJFoArWsnvLP3nxSf/F63sArY9+qdXUgo7/wIv9blIn0sgSTS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2524
X-Proofpoint-ORIG-GUID: AN51cr1cyDfzZ44Fn1WZxIGYHodLnYMW
X-Proofpoint-GUID: AN51cr1cyDfzZ44Fn1WZxIGYHodLnYMW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_04,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 mlxlogscore=775
 spamscore=0 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110064
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fawzi Khaber <fawzi.khaber@tdk.com>

This register write to REG_INTF_CONFIG6 enables a spike filter that
is impacting the line and can prevent the I2C ACK to be seen by the
controller. So we don't test the return value.

Fixes: 7297ef1e261672b8 ("iio: imu: inv_icm42600: add I2C driver")
Signed-off-by: Fawzi Khaber <fawzi.khaber@tdk.com>
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c
index 33d9afb1ba91..01fd883c8459 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c
@@ -18,12 +18,15 @@ static int inv_icm42600_i2c_bus_setup(struct inv_icm42600_state *st)
 	unsigned int mask, val;
 	int ret;
 
-	/* setup interface registers */
-	ret = regmap_update_bits(st->map, INV_ICM42600_REG_INTF_CONFIG6,
+	/*
+	 * setup interface registers
+	 * This register write to REG_INTF_CONFIG6 enables a spike filter that
+	 * is impacting the line and can prevent the I2C ACK to be seen by the
+	 * controller. So we don't test the return value.
+	 */
+	regmap_update_bits(st->map, INV_ICM42600_REG_INTF_CONFIG6,
 				 INV_ICM42600_INTF_CONFIG6_MASK,
 				 INV_ICM42600_INTF_CONFIG6_I3C_EN);
-	if (ret)
-		return ret;
 
 	ret = regmap_update_bits(st->map, INV_ICM42600_REG_INTF_CONFIG4,
 				 INV_ICM42600_INTF_CONFIG4_I3C_BUS_ONLY, 0);
-- 
2.17.1

