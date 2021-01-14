Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2E62F5DA9
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 10:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbhANJdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 04:33:51 -0500
Received: from mail-eopbgr770041.outbound.protection.outlook.com ([40.107.77.41]:53985
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727861AbhANJdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 04:33:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQbMvLUEjrPBiZoV96xy2pyuc3PwyTScjHysSY6HSSKIQCY7w30HH9nwT9yqayOUqB26NjZt1LOvpXowHsCYuerKSKJFe8QhMKYhTMGxZcT0G9c1HuGrGqq7FAx0oqTe9p/1dEWrs8NDNU/ZnHtefJ0J4zNTvTh0V0HF3iXBPqvYrre/9fZdJ6m6DOjIepDy8rqdsmzeeLp2jI/anXrQQq0bItjo/8NG6u3VE+dEJOoQ8JdYU5IBhtxGH4vkDOPNkkXuouaHYT9Pd2ZW+TmLJjtmXmoi0dQF3x+pFCAof7z3getbiP6ubjif4eWdNXj4fdWCKqyDe8dBA7/zav5WPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1AWoTNRNP1ZglZe6usjcI+12fbudRqw7fGy3CVbXpc=;
 b=Z5o+pmzUTUsC2p0sxaRo05tEgDn0+TegViSOCMQqOaC9B2Ist1Gsis/gCFExatdMpbQEajLEtSscv8p30mUMPOt9L94byHjqglX/go2zIlLlOzwy2ybHXoDDc5sETGed35tWj8S1f6N1OPFXTRrHbzrHMTFal7U4mdyZCrN0MCZsS7qlI/NW3R41X92i4Km+kR3Yt1cwsQDa9Xv6kabhw5X8Lln1dlHQC3yKMKzaRQ3noe6ug1VvvpN5h7c5I0KlXGDCSzv4GF4m4p/aOVahCmYv1q/5uhV0/LYKkNzjNsZj2axvPK541u09b1XhJIzeJKCqLZDg7E2heZHXDqXCOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1AWoTNRNP1ZglZe6usjcI+12fbudRqw7fGy3CVbXpc=;
 b=cMtkysvz3Ahf8yzHshtbyAIFXXICTbbi4k2rFq6YgpE+57vuUU6jf4nhr26BdenivGnYR0IRpMya1ZZxnoTDZXOtswxFPYP3kOjuPW7FRTaEG1rWhPYBdXZfqkYsfLYJZdSaN/9MWZ3uy3OzedrrkO6UeuyjSzsXrjx3OA1hugY=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB3001.namprd12.prod.outlook.com (2603:10b6:5:116::28)
 by DM6PR12MB4234.namprd12.prod.outlook.com (2603:10b6:5:213::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Thu, 14 Jan
 2021 09:32:59 +0000
Received: from DM6PR12MB3001.namprd12.prod.outlook.com
 ([fe80::e11b:e481:38cf:b276]) by DM6PR12MB3001.namprd12.prod.outlook.com
 ([fe80::e11b:e481:38cf:b276%3]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 09:32:59 +0000
From:   Mengbing Wang <mengbing.wang@amd.com>
To:     mengbing.wang@amd.com
Cc:     Prike Liang <Prike.Liang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/amdgpu: add green_sardine device id (v2)
Date:   Thu, 14 Jan 2021 17:32:37 +0800
Message-Id: <20210114093237.4698-1-mengbing.wang@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HK2PR04CA0084.apcprd04.prod.outlook.com
 (2603:1096:202:15::28) To DM6PR12MB3001.namprd12.prod.outlook.com
 (2603:10b6:5:116::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from code-machine.amd.com (180.167.199.189) by HK2PR04CA0084.apcprd04.prod.outlook.com (2603:1096:202:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 09:32:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9c8d4081-32f8-461c-6334-08d8b86f619f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4234:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB423409CF17C2689A3B6CD292EFA80@DM6PR12MB4234.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:343;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D/sLPM0vZSgP2XYOHAwy0e5tDmFL+0eEzq3r5VvdTD2imiwBAbx1485CuOHj49jxVWPazGb3mP4qmJ7LgUV3pf8XgDw2Sa29RIad5Pl0NT2b7cIgV6+fUqHet8eYbVZGOnSyCkVzRy0DRn+hYiErwstgJwsmzNXH/lu1EYZstlzcnpBHeofbmoFQakVFzvmBfcs0FibyX4qxKwTBTHgOMyggbUSltqSnw5SlscYnNhbgNDw3T+OW1OBiJ5i0mZ/TVD3P5L4P3GR4Gdq7O1FKAyqrKTy6bbHzTXf0D49mUTRJR4jX1kfWTuk0kjFJ4RpiQYAmgOVL+LWTzGWYHA64NsLef0RY9UmFzcOqYzA4apZLgv21HFLMpa3chCT8uzunz7JBt5S3hajl+CXpDwe7zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(36756003)(8936002)(4744005)(6666004)(1076003)(66946007)(66556008)(5660300002)(66476007)(2906002)(2616005)(956004)(44832011)(8676002)(26005)(186003)(16526019)(6486002)(478600001)(316002)(4326008)(34206002)(37006003)(54906003)(52116002)(86362001)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5Rtuh4WJfFwMI5kBuWAaErfnH8GIyr9QPLI4mg0lLZJlQIb++9KMC+qnS2/7?=
 =?us-ascii?Q?S0y8Yroekeb13hzu1aVKqZtq1BHsuvkQjLz2P8oIi0qKgfnjT8LEIH8GzThT?=
 =?us-ascii?Q?Yb3CexWXpJQxTbHKJZmIh6AeaqH2pzLi4LoxxAMXjGrBM3BRXCDgzjxyw63I?=
 =?us-ascii?Q?CBoUBkC3V4vYuej+cvUIi7p6X1zpoWBTGzIM/rx8r20UB63Tn6thDl6Wt916?=
 =?us-ascii?Q?RgRl3n4B/cb+zDAdOG0f16zQA/JG/ogxnhbmnbSoybxb41rFem9FGDHfQJ3O?=
 =?us-ascii?Q?R074KeRM8KIItwhJrJM4BmWBw5JYIwsAseJoDyPJch0A4MI9agDlsYZxNym2?=
 =?us-ascii?Q?ILTIPlcXTxLtKzmQmaKffYeM9IKABhnOKOybxMCKb/K2WG2Za+RVZVUv+7HQ?=
 =?us-ascii?Q?1bwORKLFXmMEgnNXK5nkK09pmfIEo89cQAawi+i9ESn0ub3t/bAInD4hpdMT?=
 =?us-ascii?Q?V8i+q+K7B4luA/hvxI5jaOkpc/HgzLIRhKLtKF8A2zY5HUg2Ofub1RXhOZOT?=
 =?us-ascii?Q?SyjTtNK6HwbTEBjNGZIHwRiln8jyeBGcJML83hwJqjkWHx87FTX9KgFyFFTU?=
 =?us-ascii?Q?0fnhGN6xFVgpe/B6t6wGoFLbnCmE2+9ON+HA/A+kTLdFWK1vglz2pYhRv+JY?=
 =?us-ascii?Q?kBSX02jCobhuOm/UVc4xW+LOYDJETLXNw7s6ftFirCzr+Xfxr5S93njd/cst?=
 =?us-ascii?Q?eoOPqqSTfudCNuKGg6RpVqPV/OZQPgc1YDdsDkkK2ri/QMaa1VuHepORi2+O?=
 =?us-ascii?Q?Fd02cD1bicGvhMRJuF9pB9HvfVFPKn5YCCrR0Apcd1etSQYo647Osats6qJm?=
 =?us-ascii?Q?zcw4Ga8x3TI2nsmQLrcHNZVDo21yATcaI7QGJFd+yjpWmmwfNFeDIqkzp/mW?=
 =?us-ascii?Q?dYc5ld81Ax0QHWFsxysPEdz7MEBjR6nq0kbeP8BphGeV5pmMzDQoYP0GSod8?=
 =?us-ascii?Q?DQZI40Jnoc+hSVGc0yLDAuZ+tn52vgqdIuVeokq7lsdEo8rONsVXBjOniNVg?=
 =?us-ascii?Q?gEES?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 09:32:59.1131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c8d4081-32f8-461c-6334-08d8b86f619f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0WZcdwucjaXfrdP8ysB43O32HmwaCeR+wFFRgtIua4sgOz1zPbIIha7f8XKesjohMxJ6UfL5V7GZkc9jpFkHQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4234
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prike Liang <Prike.Liang@amd.com>

Add green_sardine PCI id support and map it to renoir asic type.

v2: add apu flag

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.10.x
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index f52fa2cf58e2..f523eae461b4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1119,6 +1119,7 @@ static const struct pci_device_id pciidlist[] = {
 
 	/* Renoir */
 	{0x1002, 0x1636, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
+	{0x1002, 0x1638, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
 
 	/* Navi12 */
 	{0x1002, 0x7360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI12},
-- 
2.17.1

