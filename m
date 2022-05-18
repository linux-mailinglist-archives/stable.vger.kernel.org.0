Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE9052B306
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 09:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiERHBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 03:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbiERHBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 03:01:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C68DE8A;
        Wed, 18 May 2022 00:01:32 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24I2lUpd008024;
        Wed, 18 May 2022 07:01:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=fTZIl7ju36S+z0kX/Ppjpx6v4edkkJJ/982bi7Dx6aY=;
 b=oXEXlZrXRoPfYcET9j6E2W9jySPDiRA6qvY09K4wCwOi4sJrcLQTMb1LNrNkovEkUeeT
 jGOamP6FYIR1XY4ObrxMtGUZPTmJ8zpuZz7RCbXZj0LMgh6h0dh79hcvNKl9tUjHUQ+u
 xELHxO0AYdSckNESItxL2XJdJJBb58TuWVMO9MnVu009cHFoHlggWw2FSwe+tihkvKN2
 WFBQLYGE94AbheY6DegTymL8pSaitFjrj+FgnFSV5bkW2gTbZWaomBd9tFi5p3+ftez6
 MDv/6lEcnj9Vc9MkEs02yk8jVk9o605HKwA7/KXi7SMbEpV+tbHJVRCOv7+3WP/3Ady5 8A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22uc854c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 07:01:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I6tYA3029638;
        Wed, 18 May 2022 07:01:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3qgwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 07:01:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMqbpTDEqmq5xWeVOCJFOIW67bJr4SkUsHQjuEY8KeZuIRDRkPCnapUVBEm66faUhCzl3t9xwhkG61Hus3TumGBD1yrtHuEpxmZ1HA3ICkCUZi9D2rg3Nl0uYwkTdFtLPNAi2T8Jbo3gyLngX9ByHmxcNfekVAucNOR4FoIX6cS7ILZK7r0gbFPYw/2/Yb2qHw+US7zK/EaPVe3yHteZWl6hvoFHmZ6U7gYb3BEMu+6eRebARebkYQGi6Guc+2WXeeWifoISIpfxSkQ+JuBeTk6fSVorrOM6RppP3Aih3nd7BZgrObPeCRhfSVLdBPRFTHacvMMNDe2IIA6bQYjszg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTZIl7ju36S+z0kX/Ppjpx6v4edkkJJ/982bi7Dx6aY=;
 b=HpasIQ9/a22TkyZ8M1BBdg6Kznvhgk3Ex0n4wQ0NK+xK53BWI2lk/idp9GKM8UGbkBVS4bPDwpVnKerihBjMZcmhcPWI4qmud5SjhtBgjkQJwTBTqH/bAWX+OyHkJ4Qp/M5ggHSyhKRl6IMlwsZr7ZPkCTcl00sZMjJFx5G3FnSsZLlvIEhEyyVyMRIZ++CAANO6EXaZtbxVot6Giro6qb7olXcvh13BQYZQJOH7WRJL7Z28vCQxCTZWBTvYNu/rRyQe0PXcoIQLSq5D+OetfQ69Kl8NrTz0t6dkSEImt+xaKscjtXD71+koVdYAYMZiPOsbr5ijoMJohxrnOrtixQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTZIl7ju36S+z0kX/Ppjpx6v4edkkJJ/982bi7Dx6aY=;
 b=UmZQe/gNNKTI9/LoIYvgvG63OEE/lsvRwLPrKgbWQ8gHWjUJVyKv6JipiAknweBuR2L6PpiF1dsPotTf+XsskpTRvpFkw6om8yNzSL2gicu/5y1XO0nPxOzr/r+5sCkt15uWmm5R9Z1/GmQJ7xhatDJzwV8qRdc6MFDk+ABKstk=
Received: from SJ0PR10MB4638.namprd10.prod.outlook.com (2603:10b6:a03:2d8::18)
 by BN8PR10MB3393.namprd10.prod.outlook.com (2603:10b6:408:ca::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 07:01:22 +0000
Received: from SJ0PR10MB4638.namprd10.prod.outlook.com
 ([fe80::2162:a766:29eb:1d5c]) by SJ0PR10MB4638.namprd10.prod.outlook.com
 ([fe80::2162:a766:29eb:1d5c%7]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 07:01:22 +0000
From:   Denis Efremov <denis.e.efremov@oracle.com>
To:     Larry.Finger@lwfinger.net
Cc:     Denis Efremov <denis.e.efremov@oracle.com>, phil@philpotter.co.uk,
        gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        straube.linux@gmail.com, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: [PATCH] staging: r8188eu: prevent ->Ssid overflow in rtw_wx_set_scan()
Date:   Wed, 18 May 2022 11:00:52 +0400
Message-Id: <20220518070052.108287-1-denis.e.efremov@oracle.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <YEHymwsnHewzoam7@mwanda>
References: <YEHymwsnHewzoam7@mwanda>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DXXP273CA0003.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:2::15) To SJ0PR10MB4638.namprd10.prod.outlook.com
 (2603:10b6:a03:2d8::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8b46a19-e64f-4b8a-0050-08da389c36d6
X-MS-TrafficTypeDiagnostic: BN8PR10MB3393:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3393253D4DEA13006A6F52FFD3D19@BN8PR10MB3393.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TqBn32FvkGDf1N9Nko2TKe9sf+7EdelKiDfJLDhZdF4HlRS0mcEQwQQ6okTxGthJA/ls0H+62Yi8UkzRpRN3pWRpFlIB85tGZYsQNteCOXrF5xaMxi/140taUYEChk7lFo0rApjGQXP4KmBTSVQxBJddl9DLohpQzutVkmlrZfAR2GYsg2YfaXM0GLO8l+zACTD3QewlMpzlDR7mjH/jJWoIehF6Uu0p2QIkkZXCYnk/RJaOiyKj1JnAfu2ZEuX/di2KE2zlmKV04jr/XtTFysZtj4au+oJVOSjfvVZDvvpVSQN9I52vAlMQ5+pbcWHe6B/nvaUehi0YYkAtxbfFVjqdl9l2Feu5ejrifSMjGz68OZl5pZVhg1V9GAwiHzAHRswWzE58S2MogSqUwXDVymxLS4H5hTaZg0GDABA44rt2sOAR7F2qaFQcMGsnwtq712Y+7G+6P2MZK097b/Rq4p+xT/Qqf1juaXRzLUzWOgCMF5rmoeNAsL9cNx7KDVkPO1X9SIh9WgX/Aoj3RTYC55aWFTU3t5YfN7qfTcA2EMzifvt6S8EMdIMSqSDE0mainwFCfn6M95+5VkhB6BUrVQGmmDw/GGKv0XJeWoQDxhc5y5WFgz1erMt/O4EEWHAEZD9tFTbs6Pui0Dq+etJYyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4638.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(5660300002)(8676002)(6506007)(4326008)(2906002)(6512007)(6916009)(36756003)(6666004)(86362001)(66946007)(186003)(66476007)(54906003)(316002)(38100700002)(66556008)(508600001)(6486002)(1076003)(2616005)(8936002)(103116003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ssXNxNNRazykBgYWJtcvXgPAT3DfL6LKJgUx0vRFpH3LXZmJUbyC30h7ArRL?=
 =?us-ascii?Q?cUlQ+UgL1tTsPszc4rDXWBtd/qB9Db8jWfqQ1JW+cvRYeSDcJVxh4yK617sT?=
 =?us-ascii?Q?88oWDdVrqfS/yrId+Ev90RkDUHIgAqVnlvhACeULgW/lbsqT4toRoUtu4G2W?=
 =?us-ascii?Q?TBEx339bJVmYkfgUCFSFDy3oYUmQvhHMCmmXkKGY4LUJJheDpFJlKQXlbu6W?=
 =?us-ascii?Q?HdCPLLK7/eXRc9ZxEeSBk9yANecUvjvthzEjxcnWNZD1a2S0OETGpgU9HGKT?=
 =?us-ascii?Q?+lmS/p3vU/lwmDQf7GpDE7JWU1uxEgcyRclHAffew6C2wEI9GQdNsApM3uwx?=
 =?us-ascii?Q?VLqi9xS5exjGrii7r4G0emuJn9OlbOI9ZHwHEkBWBF0kKIY95RT76QOiZj7R?=
 =?us-ascii?Q?gpxsjXwaCWClSmCHrH2a4oHANOnVi2SsMG231WXaygGDxW/KNgsEcFMPY7Ja?=
 =?us-ascii?Q?ulg8FLp0dxgeii+Wza0cueEJ8Gjf+0/rCt3D2epqGJ9F9HRr+njy8B6+FExA?=
 =?us-ascii?Q?AiYOg4CGLsnFimoEgvL9536ao2AY8NhnBjZ1HaDp8tDKK5vsznk3Wi/DY5eu?=
 =?us-ascii?Q?PMpUBhYBRaiGQPcSEnAv+w2RbiLn16Xv0NXVuYXazrfDfGZnBk1ceoNZCCNb?=
 =?us-ascii?Q?MAgOk8rQeRfYfxmOk83NmzrRnHERGPJJAADEDoXT30V+L9oy46eC7/V0duzy?=
 =?us-ascii?Q?YbUKgqWXArgR5I9x+sQk22U2MTwr0oVl36KcwW6sg1HyNsIM6IglJ3JzJkF4?=
 =?us-ascii?Q?Qb+zsn0w/FWBpJYMQ/mYp4WlrT/kXRoSFiFw6uUKA+wBfrb+BiurGp7OT9cu?=
 =?us-ascii?Q?Gq+erpp7YdIUFYOl/p4BUdbXnzMpO+oVdVuOI6gmZIoIv4Xp1lXRzUZtgEWA?=
 =?us-ascii?Q?wvuRAH+Ri57VpLruwY2D0mzSF8Qh+/E1q67lCOAxW6XMaX/H+Z6WLDDaw//2?=
 =?us-ascii?Q?Rqym3UbfXt0ChJdkyZoeZXH8SaWZUstDnj2+DCM9Uk+8EVq9EhxAOC8gH7X2?=
 =?us-ascii?Q?IjBdSs/yzbzme501mW9xq0id36mu5ilxxekf+aGidat2DNomWhbAyJR233N3?=
 =?us-ascii?Q?wVk4uTNs1kHXGLqu1lJ+UwyTPYn7XV2M0vbeBDGKKs/pmX9Tbvu2IwKTuFVt?=
 =?us-ascii?Q?O025VqbvTHZ6llJAEfzojcaEz7WUVa8ZlPvlumfBPXn7grUDct2n6v6lWxzg?=
 =?us-ascii?Q?n6BwA2Vibe2Dyx8hi0P00lsLtrpMozyAGA0VnmF0dp+gvZnr//Uv6fVYNKl1?=
 =?us-ascii?Q?0Zweqqz2rxiLTogeoi5KKEAM8JPu3rC3lXGrPMLxutA0/DsI9TDLATzilGOS?=
 =?us-ascii?Q?vv+eN2JeAd9KxO9lLfk0i810uOf+NFPxSPFjin80VKf/Ai+hCM0r/IlD7hkd?=
 =?us-ascii?Q?pD1Ykc7bScZSFvc82F5Mmq2ZvXGyt7Pzeo8ZwLA9KjZ0JoQrrYHcaIMWkt+v?=
 =?us-ascii?Q?YARcgq2QMXSErD70CEgQHU907fPV19OU3sBHS5F2cTu9Qjc1KxpmRd9EXOKi?=
 =?us-ascii?Q?qZNOS3nH3yC5k1D4Uvlqo2sJuNGVpyuICUPHCx86S5eUADIOdSMOBthfHqqR?=
 =?us-ascii?Q?DB9pdJHg2no9rwSNywi4v9wP8oRjhGGgURdInqJ0LjnIcQsPfA4QivfIbRbP?=
 =?us-ascii?Q?NnnY7wR+IFSxltJPFvLSPMZuyt1eWdMzhpSQHKOUekFe3JW8Na1pB/X8r5eD?=
 =?us-ascii?Q?dWb//PLKXr3qgNwDvzaCjaN8OC3Mj+Mf7o+15zPlyWQz6AjI33OjKe2FY/om?=
 =?us-ascii?Q?yEVi7Whs0Qu3vMZDkc+i+My0iu9tmRI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b46a19-e64f-4b8a-0050-08da389c36d6
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4638.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 07:01:22.3332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8p/2SuECRIhEWBS9aLXIIIuGTuDY8RmYe4WGWUmEl1Ib0wSERklBolr3Z1xiI9eIk+GaHmaS/i8vTPc+QiQmI/Bmf96zFKh/4ArP22uZHuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3393
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_02:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205180036
X-Proofpoint-GUID: DGkfysnRvqk2Q0mgVagQI8-ud--WNIgj
X-Proofpoint-ORIG-GUID: DGkfysnRvqk2Q0mgVagQI8-ud--WNIgj
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This code has a check to prevent read overflow but it needs another
check to prevent writing beyond the end of the ->Ssid[] array.

Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
---

This patch is a copy of Dan's 74b6b20df8cf (CVE-2021-28660).
Drivers r8188eu and rtl8188eu share the same code.

 drivers/staging/r8188eu/os_dep/ioctl_linux.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/r8188eu/os_dep/ioctl_linux.c b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
index eb9375b0c660..a2692ce02bc2 100644
--- a/drivers/staging/r8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
@@ -1131,9 +1131,11 @@ static int rtw_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 						break;
 					}
 					sec_len = *(pos++); len -= 1;
-					if (sec_len > 0 && sec_len <= len) {
+					if (sec_len > 0 &&
+					    sec_len <= len &&
+					    sec_len <= 32) {
 						ssid[ssid_index].SsidLength = sec_len;
-						memcpy(ssid[ssid_index].Ssid, pos, ssid[ssid_index].SsidLength);
+						memcpy(ssid[ssid_index].Ssid, pos, sec_len);
 						ssid_index++;
 					}
 					pos += sec_len;
-- 
2.35.3

