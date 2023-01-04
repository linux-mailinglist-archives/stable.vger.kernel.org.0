Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCD265DB8C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 18:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbjADRwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 12:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjADRwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 12:52:24 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03A92BE9;
        Wed,  4 Jan 2023 09:52:22 -0800 (PST)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304HbV6q024499;
        Wed, 4 Jan 2023 09:52:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=l3e6I94k/ZqWPDWhBXjDOWDqowM6L6nKdKizhP2ZwLM=;
 b=ciSWUKFS/I2ixoyv+/b8K7k1QeFQemyzPYvQdDzCh+wkYJcZAlTfTX0Oe/pzoUc50XtN
 cNPqZT6+RKysrl5PVxw6cmE5K5O7SgvKKg+kWXIcjHfGbjIMvnVOtoll3OzJE0GJJB1A
 jKF6D/sqaZrdImjke2flB/sVAFTSUyHxmrCFyUHGZxExNfa7fdeFr7BhVsY+QOwU4sDK
 NzcwdaEa/JV/Tm2ZXzD2sC11HLDNhmlkTOV3Menjm4nqxAHLgy14CXEpk43j1WURCuYq
 iwWGdFRfp9XnnNBILwU/hCH7EgrAOZtUfZRjXPOgiJDQ1d8nfWNLT64mlO4UG7cyeu5B MA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3mth87tj0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 09:52:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3oodw0PJOJyCw0xHzbW85dGVjlwsEwhQrD75hXhYI5aiKhO36JZdy4Pg4pJ4YYS9gIWdwQxUI+Y4p1et5H2hPx584MptP7a9qNKCsOjIg0Xm+gP3djAVjqzIfvsFCy0INZChOGiI0hvezzy9TJ1jbL3sbhjaw+W2EtWz90oTVrMo/XSYW533a05ees40k3BdGfXkTm8f40E29fqqwC/Ldbet5x+V5uFXGuSUM8358bT9K8ClpvkwolKfXNba2eOqomG/DcrhtTjEPBjzvjUnyse50YWwldlpmwE1tXDPUXPHLsmzl9hE5Ldt83dhUJZRbug+Q+8gjSeTEJL0PuWXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3e6I94k/ZqWPDWhBXjDOWDqowM6L6nKdKizhP2ZwLM=;
 b=UmjOsZkyLEvmpiLfB2AgoCFXz2CtpbsXptH/dCpyKnpBTJIl9FEDvNoRmj3X/CGSKbwGnzbdYfRd2n+pWNH5p8izlIFAKXNM3ZB5ld0OZ4lUWLtfVF3i23MsspcC8zFF09DSesNTQ9fMkw79toHW0h29pWU2xNSHkNbOBNWHUsXLX+bE4yHoD84lWLx81kGST1y2VauEoKn1MwgWaqGGq6QzAXtWdsItI6N0IkepU2DmOQVZ9he+7uNdMWSnrRjYCO1peePhkJrGnpZyZB1L8TrjpfrsDqMyeXh9us2jXHCQjcYn+bDSE4H8AZghJAE/hkfQz7UgYRqbV2vZzJ6uwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by IA1PR11MB8223.namprd11.prod.outlook.com (2603:10b6:208:450::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 17:52:13 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::52f4:f398:b983:2380]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::52f4:f398:b983:2380%7]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 17:52:13 +0000
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kent Russell <kent.russell@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        Ben Goz <ben.goz@amd.com>, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5.4 1/1] drm/amdkfd: Check for null pointer after calling kmemdup
Date:   Wed,  4 Jan 2023 19:51:55 +0200
Message-Id: <20230104175155.1415258-2-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104175155.1415258-1-dragos.panait@windriver.com>
References: <20230104175155.1415258-1-dragos.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0133.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::17) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|IA1PR11MB8223:EE_
X-MS-Office365-Filtering-Correlation-Id: 36b90077-4c79-41b9-a364-08daee7c6926
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1B7XktFUfAN92HRmfWh5hix/hCrbRdoFE+Drruky55/5HoSzn48HdoVwqZrDgmKNMlMCcgR2gHTq1eUVT1bMl/5zus+YH+gWKlnh3eAou28WdSLpbbS0JEseuZog6QODT6X9Nn7ClRnG8ym2xWy8jUcXoPitakpeGIMQDR7TWdEZwkhPkS6+AcL58ENCHw0Ec7eqYStM4URSI4lCXsR4J4QRIjnlnLqUC8v8gObs4gxmcmo5MYLmELmqJ35zr5iL/VbT6iHjQhmWGmtPrMIJdNC06DfgD/h9K8Q+coYP3d3zUZhBNtccq5OB2idsRZWerZC3saCwqKpPK/Ah+mqH6v5wrcf/EZDmQVUftG5v1EdtJ+oQyFcUJlS9aiX1Bb5/EjLVQAm+KnpljN8NRqm5MTWTv+x6A/UtLfNz+xDNcmpd33OuwGwltugPWVwXPiikRHDSQ8nt+t22IBVT1hSVGxnJ116KPAmLM94S0xMdJ9bjHgd27CqQAb2rthPqiJ9q+6MSZyUT6n+A+R9lySVsUH3der/6y5BMZujBpP+COo1kLPXR8FPTZIg8u6SKnb8OpewtcUHxu2W0wnSrVdRqEkYlBFKJrzLSkdFXvis3tT1vbk04HNL1Qh8s+IGk9AfTh3WbRTJAdx7+Z00BRbcW8i2zy4LLcfvG0MBt3jgatizt6t4WiKsYForCg2BdWBFR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(366004)(39850400004)(451199015)(38100700002)(38350700002)(36756003)(86362001)(1076003)(66556008)(6916009)(6666004)(6506007)(2616005)(66476007)(478600001)(6512007)(6486002)(186003)(26005)(316002)(52116002)(54906003)(8676002)(2906002)(66946007)(41300700001)(4326008)(8936002)(83380400001)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lm78rsaq7+SFoiKqGoxiuGhTjRbtS6U1pnE2U/EByzzgJDQjADf/6SShPmsT?=
 =?us-ascii?Q?FY+YqcDNKjuv14HwfgdJ6ShzQfrllp8NQ7p8i5oN0gydGB6mf05huLGbOUe4?=
 =?us-ascii?Q?WstvtXvjxIZUcsjHu8MxHbpRajtYsazNVUDj9GcdluqJkOCIwaN4ZDo2uYoA?=
 =?us-ascii?Q?9MePfuEnG1OfSiRYNiqjUKT+eB2uZcbvszg3SK2h1ur7f6EMQ9Ru2WxKEwJK?=
 =?us-ascii?Q?uvDU0JMH+RrhDlYhkel5xl17423mZp4IeocFyQluUJe5noT93nHtL1PRw61Z?=
 =?us-ascii?Q?4c1tWUxRJu+LG65e2VbrV5qmpNw2wW3Evi94fgDORRDuDhXsIBRs0PBwMqS8?=
 =?us-ascii?Q?iChqvn0D8HUPHLD3sTXW2HhbUhACtlWQMoe71YsBrhNC2gNINQkVFWpJfW9g?=
 =?us-ascii?Q?zg25TjwYVW8tPRhMrQx6F8xeVg5rS4Mwyk7P1w3NDxpghB+OTcQ8LBhHA4TI?=
 =?us-ascii?Q?Ch3fDdDMXo116H4CLHbMntasKmg7MehSw0/BADUl2sqr5M0HyC7WLOldWsEO?=
 =?us-ascii?Q?hc7CYeaYAXRz4GgG2UlNed24ekiiJ9ehOFZqB+F/rfY6ajxgVm4/Uj0Vu1aM?=
 =?us-ascii?Q?FfyQ/Ed/VbzKtLjk3az4+EUZRbEy15RWpq4+RPm0n/cYhFET2g0gKG0B5KOO?=
 =?us-ascii?Q?kCPGP/oHsTDfniEzfFYmSA4k4sDmYIORGIlHS3d40v2mun7BUPoPoMSLvuJW?=
 =?us-ascii?Q?RHj8c0riprIsMV2VabLCYg+/bGFnCEWPwcuyOK9e6Ib/GHzce9wZjH6naEQD?=
 =?us-ascii?Q?Cw8RoWOP1YKmk6wMB0rzZJaqPOFANPZkZNeWtBKhNNNe73aUhwar5CDvXj4A?=
 =?us-ascii?Q?tFebBBac16IjQA8LV3rPB25P9E+3ha05p5vIAwpBdTg/fbe2jPj07k6WCXLx?=
 =?us-ascii?Q?y1ftv9ow9cWOVSitD967XFmgi+dDQDuSxcZyKM8AfioonATIlmhBAh73A/IT?=
 =?us-ascii?Q?QnUKZlAxo+T8OLhXXjyxASlPp4Jt5Gnq2VI67s/C6NCXqc8MrPFnJZOK3IOB?=
 =?us-ascii?Q?/vqgviwfUUpXo6tGeKLmoiQvGvj6BcTt9QO/HLggQYKwuvJaXT4162svgNx3?=
 =?us-ascii?Q?KLRFnUq31H2FeXLDv4NkwVvM2NZa4BLFWd5p6IvMQyRw2JA3B7T5n+lZawLh?=
 =?us-ascii?Q?cQVqtXo0NeBxxdS9iJeL9CLcF7nglVdI26ug5wT9kVy/oZ2PQ0jsbzDmg64p?=
 =?us-ascii?Q?m/Q3FXu7F2kdIgN4laXQlPSXTQroWUfWC5GGx1CVadksc4apjz75vqMa/zZZ?=
 =?us-ascii?Q?N6cp+tvmalYF9wSc8OTehsA5cxnA3s0eUxf4kPQCGczWv/uctcPSA3QROsU6?=
 =?us-ascii?Q?n8c6DvZ1/hpO2IY0w49gCWpH0MfNW0+y9ctGgoAxXhYJ1vwILUTl1CbuyeZi?=
 =?us-ascii?Q?olOQJFaIgeeoOAvnnDAMHT4FX1mi5C/gw7i+CsJRlPIMdUBxCZ6bM9FiVu1B?=
 =?us-ascii?Q?XKV4MrkHEi0FrZVVx2g1COpQcWqeA0atPyxQfUFVLZkE1FygHsZEVal/py25?=
 =?us-ascii?Q?RFM+zr8qC/i85y5+ll3EiS6ogl9Qcem0+Fl5WwNCDQLT43opXzHkFESthM2d?=
 =?us-ascii?Q?r1o5m6B6WkX1Ppjy1sKY+eaij81MUfOrQyYZv7VOpAD9AD5mLC9zzCZe///G?=
 =?us-ascii?Q?ag=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b90077-4c79-41b9-a364-08daee7c6926
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 17:52:13.7766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWoAkdxrKeqDVkDlgycBZQbRr+ZBjEmlg9sPaESrOC6eWobF0A7/Xs1lh57HTq/lRS/6agKdZVOlUUYFrkwyj4Ha7Hrvhpxu6GZViqeGY7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8223
X-Proofpoint-ORIG-GUID: pikKZc6x6uWbdP5WagCRtQiUoIRpmNcG
X-Proofpoint-GUID: pikKZc6x6uWbdP5WagCRtQiUoIRpmNcG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301040149
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit abfaf0eee97925905e742aa3b0b72e04a918fa9e ]

As the possible failure of the allocation, kmemdup() may return NULL
pointer.
Therefore, it should be better to check the 'props2' in order to prevent
the dereference of NULL pointer.

Fixes: 3a87177eb141 ("drm/amdkfd: Add topology support for dGPUs")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index 3685e89415d5..6066cd7a9d8c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -407,6 +407,9 @@ static int kfd_parse_subtype_iolink(struct crat_subtype_iolink *iolink,
 			return -ENODEV;
 		/* same everything but the other direction */
 		props2 = kmemdup(props, sizeof(*props2), GFP_KERNEL);
+		if (!props2)
+			return -ENOMEM;
+
 		props2->node_from = id_to;
 		props2->node_to = id_from;
 		props2->kobj = NULL;
-- 
2.38.1

