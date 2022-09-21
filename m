Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327455BF443
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiIUDY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiIUDYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:24:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1DC79EEB;
        Tue, 20 Sep 2022 20:24:18 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLOPwk000833;
        Wed, 21 Sep 2022 03:24:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=SBbt+VFwiJWGLuDn6qeRA2DxrPj3SD35BF7OBbTnZ1U=;
 b=raDZrp83nLfIUvU6gcUj68ZZIMb06Q2VLimqBZx6j6Ttmu/7rtIrpfJUi6UHIUYveLLf
 9iqZZiDt9t+Xp/DT8PFnqNuV09I56cSa6qYbjYkvFuJGNVQOjiXO4n24XKNE4+xC/Kqi
 oR8Rxka+xIt6yu4LqoO0PdZ74SkeHF69jfouIj1ZwIJAYriyZsDiFdSmVtweinYx+Lve
 cLG9hnyVP6ohZQUqiHGlyj8uRhd260ooXHvLmvaECtTWBPrR4w+MNFsedTGbPpqhd+9R
 BNMNzzbNQ5uvDYwVz5EGR0yu3LucF7nT9fNPzoMvk8hZftLgR+hm+g6+zB9ZDKDYIKql MA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68rgwk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:13 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L2Rx7J009996;
        Wed, 21 Sep 2022 03:24:07 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3c9p5fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xi8GpMX4vv5uy3r8lYQ3jp1rJ/KkHFKbCWaDP7IYs0sq/oaDV5FB2LEFNo3hsgVfeudEtmtb5zsZ3ye7jbAy7lJdQIgtodE99Gc/qd/LtJ1lE+ljyKWRTOjzjfEfOWXh3RBeWdM0lMZRe4MgoakGHKNGt+40s6IKU7SdX9ZdJHvuRRwDbomgp3YbapKnQMPsySAOvQRMpeXFzJxEc4ulhxZVwVTsvQbgakTLys99X4ZUgq80ABigCtG3jjq9k3IaI6bMw/iM1tJ7Phbrf1p3A7YJP5f0bPyYnE94QI0ZcOurosvKelr9rKK3yYV94iqSzRKe3Cid+0f7aXIpBByniw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBbt+VFwiJWGLuDn6qeRA2DxrPj3SD35BF7OBbTnZ1U=;
 b=dSo3BvDty/9Tv/1kz2ALEszp6Vay0bN1vxMAvQFYYnbh4Nb9uqhrB8YB2bmfDlImzlvronvRwTvXtIvpSzYiM+OtECFP713Sb7Ynsoxwl1edU+WEYAPrkAX9DrD8gIFHSiOJUglVWHLNsvm81+sTdooRGVfNeTeYQTDaRrdrxbCmFz0TiJ3SyZLMY5a1CHHUpaE98IdmlXqCcBIsKi1YtnEvPeVnmrYMGv+BPNPgcjFJX4HjC0lr7pXgAEXmCohHS43azKPn66DaATD51kZSEauhZ37P6bARwgiUOLG9yJvZvaePejsk5pjCORLcd/GxpMOTtuZDtdiZhn4Dgf/PPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBbt+VFwiJWGLuDn6qeRA2DxrPj3SD35BF7OBbTnZ1U=;
 b=Z5Bd98Grc3UGaUG3wdtCT4i8gjhfjWxui+hMJw2fHDouEpIqGUrB217/hfwonK5f6Xen+p8rnrbEv3/4TEgD+2Kckz4izwrQ9J5ZhFC0qIxkvOjvSEjgmNYyJXSSgUQRI75+KSFC75pWx1iZ04kqVt2qeEguN1HdnkUlOQtMMKo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW4PR10MB5838.namprd10.prod.outlook.com (2603:10b6:303:18e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Wed, 21 Sep
 2022 03:24:05 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:24:05 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 01/17] MAINTAINERS: add Chandan as xfs maintainer for 5.4.y
Date:   Wed, 21 Sep 2022 08:53:36 +0530
Message-Id: <20220921032352.307699-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:195::17) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB5838:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fc1eb89-74ed-4aca-9cc7-08da9b80bce3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bq2UIkmVRVX/4c/gZVzVVsJljQ2POg/esthBFxl0G1tW+Lk5TIb8QIQCd0BoGEO9rOxpBo7HhZEbq59HR1OiChySP9xc+aOpUBq53bj7CsGmyP3/yxtI16sgYa+kE+AO/1nfKaWHt/5bK2S9mS3ox6WccB+Q4ia2alhW1KW+44GP2GBImoZ/nDRdiVKWPu3mlr0vH+hQfKAk/EB4aDExubCoMiSBKeH4U00gizYrKq879smKNNDA8DRvayGezB1b53V5qqyPoDUixHFS8s2ACb4cegFIPsNbfRyLIZ7N43FXBtxwA3GjFfCn3fwaYZDbbGCEBgrt0EfJlbPbwC/J1z5nWsPqUyYbzil5FVuNeVpWTVX9YF/6a2JKFR2oBWV+c+JHHnCAR3Ftd0yBLWwI4BbW5n0F1+KLdojz4v+4cRp51hiePcSmKgbTpR4cV4JrBEgPUOdIKzi/tBOCRFDhGVkWZLrYw/aKRK+FV/ZnQVJDx/SVsOMhAMYwanhxw9h5yh5P2z5pYIjdeitGhpzmCSyfBpd2fMvX+KXMk9XEbNDqi76+lzj1KKayTtU+dIW+p+AdeFOaNZRj7odHjYrlQYiNtzWYuVaqzmUOwXCfxJDz3Zrpmug/S2vqYLIKSX7Bwp7sia/3rYIXwkGA7uzvHDZS7IiSVW18tvOMq8auCa7yyKPZf1oVNq9v7svBQcpNl3KNK7RX6WDyFqM5Ll/zFDxJUQJ9DZBHXZZpPA0QNfdGHCXBqbNJSTrzJVDy3huB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199015)(186003)(2616005)(1076003)(5660300002)(316002)(966005)(478600001)(6486002)(38100700002)(86362001)(36756003)(6916009)(41300700001)(66556008)(6512007)(6666004)(6506007)(26005)(83380400001)(4744005)(66476007)(8936002)(66946007)(8676002)(2906002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ck3fy+fi9U1ebmW2rhFWaVSKBITlvsfQvxfjeqp3In1ljr0yn3f3xAh58ZAi?=
 =?us-ascii?Q?bpF7qKnHTN6BVHYEOrXeUjaR9+4HYE1VYmKy88b1lUxVi9GT1F8WvRn33KQK?=
 =?us-ascii?Q?vz8MKGf/sFjxlK2Xx64TdKRUIGurnKHi/E0+XIGnbR1Eep9Onwb0xhk+D1/Q?=
 =?us-ascii?Q?+iUjZcE/h2AANyDNUuSai95KMqsiDR75z3511/D2aV7TV0UTs0Ezmt3gf7n1?=
 =?us-ascii?Q?Ef9FVaOQE3U2avWYXGwBnFWBiaR++B8j+WBjpR+rQnp5CFJPrK+ulh2DK/Zk?=
 =?us-ascii?Q?cGqytwBBFqDaJuUiytoFGjp4wmoQrwdJv1Y9sf2wUgy1W+IJsgEUt+zzkVFv?=
 =?us-ascii?Q?Frts/kRoauaSvY+fzA682VcEDC2nsed3hp0wtNuOPa70X28Ymb4Aq6KlqwMY?=
 =?us-ascii?Q?xoLhhjpvO/+uleCKYJ5JZnC0zCcaI+ppUmRv2ZQbIzd0utgKD0eMY2Jd3sP9?=
 =?us-ascii?Q?2yhihjGZbG1ORZ20K3fR/DCV2I6aPC13OQciOiWzTKytzlAZImeyUNE9N4Fj?=
 =?us-ascii?Q?8sBQgUmHsdGO0wAPP7z6rJlV8H/W2it1UB0MpwEx8goXIgpYbFhIqkCXBLw/?=
 =?us-ascii?Q?8M83q9YQ+PRI2J396nl+kFEwNpMNF5ONS1xf1gL75aFcHLKA0nb+WB4TuF11?=
 =?us-ascii?Q?7NlVNCC1Urp4UdOfd0UQrg5+J6kgPs8mcMIPrBlIjtJTMMGTLIHK2tuN08dI?=
 =?us-ascii?Q?E1lhOhoYjPL9m3E8fTwZoFcpFLt1etI3vxz+ge+i1yAWAQTlcF9c9nvYKJij?=
 =?us-ascii?Q?Ek5/+Vy1kkwIWHU8pzuchtsc7usMf0aRPjzNDuQnuYDPG5zXV3jZGP2uDhaN?=
 =?us-ascii?Q?Hi0CSCBlussiOzcawbLmS2ZSOn6WSvhoZmc+0LhwsublUUFk/7BgJPqs1HJt?=
 =?us-ascii?Q?TOOpJCqQtgstCZy3eFBH7MoC0NWz284QzAEpLDHCmYPEz2o6hVXFvPxoHGzY?=
 =?us-ascii?Q?2L7FUbGc0MqJYVncuUTxdqmmiCYqNj0G0zu/M37hKQz5IdlVqcukkdwo/MT4?=
 =?us-ascii?Q?OrGBa10ly2CX77pQeuSesu7I0vK3d8PBNgYARlFn1r0k46MoYEjmy3XQ1VhW?=
 =?us-ascii?Q?UsgqFD9PCuCdljJLopnK5T/MlBrW5MEkr4eOlRGxftD/FDGnunOk9xrMKdpu?=
 =?us-ascii?Q?IKQMr6znhwDFSfVQ5b3dqScZEJ7CX9ahYG/uClr3XFXe6FZpMKqaTvLktJQy?=
 =?us-ascii?Q?P47kqzoKrHknrHPf/NdX6txN44gq4/XmFpFE/z55yLYJ2r81YEJ1rUmELKbx?=
 =?us-ascii?Q?1VJCyvjTXs7UQGpp3OlFnTGtLY5efCHLw+/dWFwv776ZwZ/FhXcqvv8Wcv8X?=
 =?us-ascii?Q?3jKhDb3AblvEhOs2jZnTC+n+OHrpbdzSMbq1q1mYKm30VU+fUV+U5Z8O01V4?=
 =?us-ascii?Q?KxwlH29TOg+N6X/oR/UDzC+lpUOZjQ8D0aMZccpoy9eTyyl/LJhu6Dnjnuex?=
 =?us-ascii?Q?hDeyK1dopbX5pUzfL67gDmRYlDLlHLJuq7rUwIc6FNsUhCln7SLyOnAYXKnT?=
 =?us-ascii?Q?RA9kWkZF+GAHSDicLCXkvoWK/l+Ikl484iPgNzN+eNKFANwnqb1OuWkkAOKQ?=
 =?us-ascii?Q?/9mcd3Rzww0LDUVWK2P0BsE4umsTRGPhsxaf8mr/YiXM+0zwpDPfDg+zpnJG?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fc1eb89-74ed-4aca-9cc7-08da9b80bce3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:24:05.6311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BC2MVcVGfLY6SKBfftsT+55JdLP5NxqkQSRo7vi4U+F2uwCXv+Rg5Egu8ddSWxJfjjLRXDtHvTFrdJSFMtZ67Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5838
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210020
X-Proofpoint-GUID: msZGBNP5ho4H7uysLZ_BPzRTmiecxwB2
X-Proofpoint-ORIG-GUID: msZGBNP5ho4H7uysLZ_BPzRTmiecxwB2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an attempt to direct the bots and humans that are testing
LTS 5.4.y towards the maintainer of xfs in the 5.4.y tree.

Update Darrick's email address from upstream and add Chandan as xfs
maintaier for the 5.4.y tree.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/linux-xfs/Yrx6%2F0UmYyuBPjEr@magnolia/
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f45d6548a4aa..973fcc9143d1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17864,7 +17864,8 @@ S:	Supported
 F:	sound/xen/*
 
 XFS FILESYSTEM
-M:	Darrick J. Wong <darrick.wong@oracle.com>
+M:	Chandan Babu R <chandan.babu@oracle.com>
+M:	Darrick J. Wong <djwong@kernel.org>
 M:	linux-xfs@vger.kernel.org
 L:	linux-xfs@vger.kernel.org
 W:	http://xfs.org/
-- 
2.35.1

