Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE72B65DBB6
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 18:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjADR5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 12:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240167AbjADR4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 12:56:55 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0AF3E0D9;
        Wed,  4 Jan 2023 09:56:53 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304FPeLq020752;
        Wed, 4 Jan 2023 09:56:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=Vaio7YrSAPXlij4IH9/aay1Ifg5Rf4oWjiyu1XcDCjQ=;
 b=A3gGXi32SWDIIiof4JeCcYDqk/ln18DS5hTTAjikfUUjK5pH12e5Y6gR/a7be7kWmt4o
 X+kvGMCq+j6Wbo50ZUztJ6btMzqMThp3SPl0bXjUVqzDeTtBGsylUVjODMNPX21IJ2PO
 E1Ljjn7no3u389MbrVduq4ClcnAWohnoMZV4Rqrk8iZ/+8+byb+PrCRIt8zolpItJUO4
 5y6qiJ1sgEWs3Jh+8vdHD/uzZtdTfohVz2oU6oN6nePSLPfrd4jG3N1+UdH7m02VI+2o
 fNzYv5ZUFZq1K9o8ZjEyUbH9Mrw5hUAxyKMHiRnGgNHXFZ3jyCDkvh+plvidSxkpvceh Fg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3mtnfrtfff-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 09:56:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPcKCCuqm9ODuEp8f6QciayVBqLZJaZhcWMg4oq2p37x6h9ONq6gR3fxttXusBKSzoUXLtJKHk/9MuOPTzB4HMMynAkMhiN+vimTL1x1uo4MV0U1v8SvDdXUWVMszylWxE6Aefj2+jRt1P6PR0qtoCp6tmNbvpFgTH3xlHS2erJGVsmBrQpIpdz+u9pEbkJ/PSiju38k05mt7VaiW5NgT2Yche1/Qdqu9Sna/iQVR13J3Zew03p3342WpDm7TEo4/U90xjAdOzQSvU5rZmyCjNDa++OiXlDqMxobuKQhh6tu4yQ56r5GS23Y+L7H/zjd8uCnwO3Ly64OQ7s2AMbMnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vaio7YrSAPXlij4IH9/aay1Ifg5Rf4oWjiyu1XcDCjQ=;
 b=Zs6F2Yfp3aG9sxTzhdjeazjoSylODX1YjKTrvT/F4ww3qmDeuK2+qhFjtPGZDA4VMlq1WqWOyPY3NHwNXp1ZCEG3NqCvI0U3tBDwrp1tfLibYz9Q5BoGz8ihbSXsGJJtgNQvvjGZneP/YlWtq2+xm2Vl+Z4pgb6GJbfT7zwOaBhItFGF/EoSHRsvwKZVpx46mxtRUZbMixjtnlKX5RdFWVt125QfAYKR5yr4MhhSkczas3QUn3SyIURZgFfy/oz8N5RJLhhx6DnRBbjO5zDJ+VoR0W1zLrDUfmtGjvBakczNLyKFK9ptZu9HcMgy6qgpWLMUJUIaG8FXMfPV33Jbfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by BL1PR11MB5462.namprd11.prod.outlook.com (2603:10b6:208:31e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 17:56:47 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::52f4:f398:b983:2380]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::52f4:f398:b983:2380%7]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 17:56:47 +0000
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kent Russell <kent.russell@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.10 1/1] drm/amdkfd: Check for null pointer after calling kmemdup
Date:   Wed,  4 Jan 2023 19:56:33 +0200
Message-Id: <20230104175633.1420151-2-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104175633.1420151-1-dragos.panait@windriver.com>
References: <20230104175633.1420151-1-dragos.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:803:118::48) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|BL1PR11MB5462:EE_
X-MS-Office365-Filtering-Correlation-Id: f63a7d30-7a7c-4081-b963-08daee7d0c5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QIXh7NFvo6/0jV1HXMSrkpUS8y/ssvVFjAhlJW0DRnyR0SzpNDatk84pJZlcVY2yFWZgQcHCX1+5NkuaY5a3O2JLqGeMikD6P1U+HXA/GEcPbrsVYQ1Tl60i1QzEcIMf+sGQtIjWd1m6VJ5qtg2YuQl3TC9ccXilHj5rpySQrZRJqv9LyoM16Fg4A32To4d0O0Y1QDevMFWDhJqUmoqNW0Htjh8xm6EuZRstM6K9y9+gRXWW2gCDbPdZWL9uN54oabjG4GsWYA/mqqFlUrV7/MFzLr0JTt2rqT+K1gkTQkjT3b62VWlYtk0Xm/coETypDLk19ITDdz6cg28/dyWvDYHDdAKWHYWUgye85TZyic8fxnkHZFvsHxgmR2DDMC2UinLg/PvEfI96G5Ve8r5uNl74OaDAGQEr+9MGgji8eBeNBjOA5zIlF41lPCbez0u73dqzu9y8pPYXQUD06aJ9mrhkncNsfr0vK3MUW56SaG0r/xZYdCT6JV9evwgRqJMtkEsLngbk5aziExjPVNrdfvrlMUhSCgjwCAY9ksnNZ/sdhF+Y8jA81kkb8Z+o908lCgyz+C/Q4mInsxAKPHwB5gwjEtPKlpehNo403lpMGNMZPA/luRO8dNToMpuN14KftlBLeHRJWAVpttf+nG50+ViQ7GynuQ/axDT7SPQIvUJnWqhCQutkNoqPRw7Lsv5v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(136003)(366004)(346002)(376002)(396003)(451199015)(8676002)(4326008)(66946007)(66556008)(6506007)(66476007)(478600001)(6486002)(36756003)(52116002)(86362001)(54906003)(38100700002)(6916009)(316002)(1076003)(2616005)(38350700002)(83380400001)(7416002)(41300700001)(5660300002)(6666004)(186003)(8936002)(2906002)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0tW7trc/VqgC2Zl4NsR5ioqEmkfHvtShxNcPzfTxyRR4cXo71QSsAVpScluQ?=
 =?us-ascii?Q?h1qK3vlFSjdhTatfcBtWKZGqlfB1llQAyyuE8K4Jgn2C+XOpPxEuVs2tUfNJ?=
 =?us-ascii?Q?Wh2gMgeczd4ijSStIB9NY/qL75hIfZpYcSfrKZADdgfZtWE6gEs2xeKe2dzK?=
 =?us-ascii?Q?stz9zUshZM7OBXH7LQ7VQx7dTx4Q9J/XU16YZdlUTijpzDMqogwycSY8IhKN?=
 =?us-ascii?Q?+f7mX+jzwVmgDtPUXplpd/MW5j/9NwRU3pAC4YVfWypiZgOUmOZO0PyPxHP4?=
 =?us-ascii?Q?VY/oNcolsUSNbDeQNmIGlWYt9cbcqJnY3q8Vir+eaM4zp/7keswdX9w2ozho?=
 =?us-ascii?Q?juHcuarXrac2mpuK5MiDLeDUVA9eNuGgQNzqgd3V9PMlXxrIVnrlpQ2qc+A4?=
 =?us-ascii?Q?87omoI3F80gCJYOpUAg6izOolUzAc+rDxulGbekvlvOeTT1qoMSLSND45ggR?=
 =?us-ascii?Q?4jG3jx3kyBapMZsp3/FpFkqRuFPFCsMusFfTxxmbSyzWTUz3aB1KBcTtrgh+?=
 =?us-ascii?Q?BrOY2mvJlg/a+RAXsgnIN994Svd/Ne6KzSl5dQJ4CW1Nd2763iQe7m7DraI+?=
 =?us-ascii?Q?D4wCk7IptJbkyZAXzXf1PaeZvY8ur9k4mJpc0q0f/AWjoafd5wCaFm+7svUx?=
 =?us-ascii?Q?eOHDgBTKKkqxnIax+b4hd/Ubs4jRWmM/hCHLXsapTHH4rqMrpa4r161AxhCy?=
 =?us-ascii?Q?L2+utSTAmHMcPaxTocwhha2guC9v5PkjuEQ+YfCCsjqRDrrU90Wwyrub4yD5?=
 =?us-ascii?Q?DaJ2a/uKVmey+zuSwRrzrmP23xG8N1LD+5MX0WWYLhjikij1f6H2HfiEx4zy?=
 =?us-ascii?Q?Bh9xFyrxR47jH/DdzNLvQdwrcPCIuGZ37qoiXCvG6Wfhxdx+5VNXpgs2R5Ba?=
 =?us-ascii?Q?AORndX+WGfS/6wZsUBiYCoHNm8Slo+Ex06WN3gV0YrvDzgOk5m2oT8Q68c2x?=
 =?us-ascii?Q?7KdrZIn697EI/cH5FbD32bB/P5ScD3Z60Vf9fB3t1VPA36pV+fCUtv+BDWdj?=
 =?us-ascii?Q?fIDOTJ8HhuP8VTARXD97RUOv26Ao93a5qucLXoJghVUyqw1q0yZySKsiIw1H?=
 =?us-ascii?Q?hsKMPaEZE/tOriigs1TsXOHPtPP1GWC+LRV2Wsh/+7MdwwN8pSquxoLXZhs+?=
 =?us-ascii?Q?UfLFQycnkC+00fQ5s5TB/XuwjG4miDNTVEXtiE+MJ6MeZfoqFyL4UuNKZdI/?=
 =?us-ascii?Q?Uawrxz7FIiqx3a5l6qW/lcbEU/XDd7tnkcS0dIehzSdEwf6YeypPChwrwO+0?=
 =?us-ascii?Q?j433MBOTSU+zcMzzkFVVZSz7Ihw5+mCTzNQaWVKlij5cMYfw0fhp4Rvrik8a?=
 =?us-ascii?Q?ALFY5POPVkkXvaIY8noRcTJR1xeOI2QD/ItY7ZGJZu62UUC7YI382Lcmww59?=
 =?us-ascii?Q?nxXg4PXutJAmYnAm3e3HOxjzdeq78uFB8HJZY4ee1CqgswFt6bspBsU7AAxK?=
 =?us-ascii?Q?D/PFwPAKmDFiGs7AR8ILznH+Z/Fx6oF/CVXWxVxogVThpRKav6rp4ngak9sg?=
 =?us-ascii?Q?mPSKgl7VnaB7qxLav1fzphv75OkI38BmNOwvF6up0Tr/SWVyN2e962mCdGpQ?=
 =?us-ascii?Q?px8ZsdBwlJuWsr5dSXFH7cEmBR9Ct9E1l84WxYybreTvb3gaXymc3SYEtL0j?=
 =?us-ascii?Q?tg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f63a7d30-7a7c-4081-b963-08daee7d0c5c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 17:56:47.5040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VlWAPJHQWHh6FLCIsR1rrNQRZrXaODlIG2FhujLt/eyMrJLHWzyZRK36vvkcSpHW4J8eCjbjBPKlsMUUc7WkqKLzH+pSTXnvIMctWBZPj94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5462
X-Proofpoint-ORIG-GUID: JwwY7w5YdxMeYnazvQ3pWxC_0R0rSZVo
X-Proofpoint-GUID: JwwY7w5YdxMeYnazvQ3pWxC_0R0rSZVo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301040150
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
index 86b4dadf772e..02e3c650ed1c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -408,6 +408,9 @@ static int kfd_parse_subtype_iolink(struct crat_subtype_iolink *iolink,
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

