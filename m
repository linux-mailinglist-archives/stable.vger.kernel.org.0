Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E344D0A62
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 22:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242421AbiCGV6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 16:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244971AbiCGV6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 16:58:34 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1190A6473;
        Mon,  7 Mar 2022 13:57:37 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227L6sYd028218;
        Mon, 7 Mar 2022 21:57:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=CUCvgxOEp7hDhdHjh3kbyJXvr9AszEEomFLMV4YhH4Y=;
 b=ei7jRNrplvM5TVSjLJdgSP3tXiqU/bOaREAwcvfy0i5LLSmg0w2tU4Vd7UN70YOcpDze
 7SDbgaiRD3+U5he7djIr6AzicdHChq2Q0l1NMFxYG72E0SHTUurFi149iXt6JxsC8fem
 9umBO+lCeKa2LCu+z0Fpiwvmedv0RjRKo2bIhPiOGaHvD9l4PARMb5Nc9LSgir6v7zxC
 /LtXaAxtzQjF9a9I51NeQqbCU3PGhBQ5SiK/0IFl4OeoixM1SPVTsiLxX+YdkbZQTB1J
 0iqTJmApcVeZ9YnFSD8KIumXGJH8mOXTL+r3NGBd2Oe+X6Q9ijPy3rZHDv1lq1zqIruZ pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2db49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 21:57:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227LaIIN067434;
        Mon, 7 Mar 2022 21:57:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3030.oracle.com with ESMTP id 3ekvyty630-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 21:57:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5eRKuahGz+G+RcBmiN7jNuC5RLWEsPJFeJv4NQYbmXJEIpecShrYlpqs8bYLNrQuBAElskRaU7PBgUAx9qfgDXvG49iJJD6JF8Rl5LsG3Hmwot6C/z4pAXTzXhjaI4jwLwDyhFvWVzl31oLGOEBpV+qGKyOnV7WeyHnjSmreCp/PYBIrWtAphGv8f3XBsXsIsFwse/aUDvlVcQakvw654UmgDwUwSUddtXoZE5Xc3akrMEq0rhe25krC3o+3D7N07GbbJUw5fyQYf1Aq7/A3ZsRFJw+fbLsz1JjFACQTCB1gzaoc2H4rU1aPhAoKEuzy6o9yOXbwGCr9bcG8HD65A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUCvgxOEp7hDhdHjh3kbyJXvr9AszEEomFLMV4YhH4Y=;
 b=lckMeX12CAdrmBwv6TkDSjNlGgVpx/8Jw2d5ct8mDRXpaPTNNr242Rru79qLwHmvv5XwrAjNuYAd/8QykYVeuBNei/lGl/6unul6OFX5n27Y7TvbY0DKsYEW+YL1qL98qYyJEPKZOFS4BHoJ+O+rNM2jMQA96IVkATqHkRolXFkqLjYB+aGzms+JuhfXtSlxTxFdgoJG3Av3QPnaSF7ML9n+lstObFXP+b3bGg1aok//AV6mmVs8zNSV0iTrUMQqsGmw+u35XiCGK1kw9MmxG1rVMudpKOtxjO8of/sx06A2vCD7I5fdjQkb9GXK4l2zPTTE9zW/fSvnHKY/hZ5QmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUCvgxOEp7hDhdHjh3kbyJXvr9AszEEomFLMV4YhH4Y=;
 b=fmQVGR3uRBaFI1FZY8FXWn0SSkuaVegIN/UDIc4y5cLexJe2LFo5FUXs5R/Rodeq7cDmr4F52RNBjWr3iC8ogrcbUyXKE/ZkOmPb471aPhpHPCYpU+dCY8peWaift0N6YbfX+d+D/WBeVRGvrBMITFdxtI2ydu/xb6noABGNz0o=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CH0PR10MB5003.namprd10.prod.outlook.com (2603:10b6:610:ca::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 21:57:19 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::51f1:9cb7:a497:f0f7]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::51f1:9cb7:a497:f0f7%5]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 21:57:19 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     HORIGUCHI NAOYA <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] hugetlb: do not demote poisoned hugetlb pages
Date:   Mon,  7 Mar 2022 13:57:07 -0800
Message-Id: <20220307215707.50916-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:303:8f::16) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55136c5c-7b1b-4e6d-bb47-08da00857355
X-MS-TrafficTypeDiagnostic: CH0PR10MB5003:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB500379EF47E43D79EA7B649CE2089@CH0PR10MB5003.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eMz3lrkiP6PTc3elvXjKBucT41PRA8S4a0IYfD9LBEBruEHlQSgzln8/aFvhJM3cTnDWrjPd9CmO0+qxGEduCXwXRHY2/o/gtGL/HUQZE9ErUp0a3EeLIK7pI0zQHOMWr6ViWrYEJb1SiBj7ikzYngvdKXK6cpd3fv6ikXMtl4/9V8emX4+CV/e8QXMfxy/yBmtVNAZszOfGkNkhlL8RGYlKk6ASac8UKv7vGwGgau6t9cUtkrXfYrKQ++56lep7+rES97VefQV+4wNwieVSjMtyjxKdenScgj08kTQrqfSMSUlh6dQM9OjvXOdQEvz73GYTxumrwZJ9X/mX/OeF3cGfD9m41eh3fCrpvVO2IiC5qwtEdINaF63E10OLSosAm61P5A3/p//q7WRnx5hxSKIJfgdFkX7WP2hYMRdR510+/bd1u5faSvW3jsjVEEBsERpklwQ11LdXIneCANnTb36UILz1Dh+bTrDrp1mFF1tDdRZ+FlEr5VYh2wjwM6hZ+T3NP51lLghdw32omjnYiMRMHttbp9qXFxh7HZ0C1M3kr16qtwjTAUCPplMhAbCkz9oyjkPkNGei7uRibSZe30pFEkqEAtbH9rGvG2Z34Xp9C5T/S8/Fl/6GzTTVU2OpAdzvo5buTPRCatG3aW1ctsBjRHN9mMUV3DyOWibTGQY3iriZtR1ePC0b7Kst0pU5nwLFA3VNhUQpIg2io7FlSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(4326008)(83380400001)(2906002)(44832011)(86362001)(66556008)(66946007)(36756003)(66476007)(5660300002)(316002)(8676002)(54906003)(508600001)(6486002)(6666004)(6512007)(52116002)(6506007)(1076003)(2616005)(186003)(26005)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7mda3GAVkP1q2Oz4lvWbjGoPWKypMTINCTqvWUvp5BwirG//crpzFRos6MHI?=
 =?us-ascii?Q?rC4SMVdP1g3ZjaAuvgfNFlENifMSi+oV7ZaSt2td5xRdOzJKwj1evFsFeb3m?=
 =?us-ascii?Q?y2ZygJKS7WvuHWdHCcbUZaE5tMlNnJewGlqxSS4GZfGXQdk0cVIAXwMWqHq/?=
 =?us-ascii?Q?Axa7Gzs44lkkjC++7fgcVIrlX+Vz0/z0xxnxDLWDCCrz+6pwteOd8uxNM4Wf?=
 =?us-ascii?Q?8PVBAAT+p+NtxIdeD6D4BMbKAhBR5Rd6ZbWrhc7gXCKkJrSmCXQQqE5n+uM1?=
 =?us-ascii?Q?jOIBSniD+TRGuUmLoYwYuvfCyZOS6ZtoLKMBaslWo88Z1mLGsAfxvR5z4tzj?=
 =?us-ascii?Q?hJphHc+eW8zhV+hxjBaCK3K64UmxRKeLrdDJwpnykjVydCK6THfjyRiT4FX5?=
 =?us-ascii?Q?/R1NlO7qgTpTevDSYRWXdgRgaGlNCmg5hXRojEJO1KnCqJummRlJ7sYUt4dy?=
 =?us-ascii?Q?KHv4DdOm7cn+xYp0MRj2nv+7IHDuQzHctJs21fFLF7NdIaPG3eeekLGuwIVd?=
 =?us-ascii?Q?4tSqcA0kVfyZPJP8kbnblvUiJJJXui+roxBKlFvlMZ1W3dXckVO0Ipv+jIr1?=
 =?us-ascii?Q?niNI/D5QCN2NeLVKMNKXLh/SFIjfNosP7Uma+9ExGAbnZaEh3+gus2jYv8TD?=
 =?us-ascii?Q?qjh68U9PHVEPUoxClgCkFElVq1xSqEimsEzoa5wWYj8AUyVdMpZ1FPTEpwD0?=
 =?us-ascii?Q?on+K+mClVqXn2h3CnFuwoAChJUQJ7ra3OSypnspEE/nhTXTKizD7O59UHkNL?=
 =?us-ascii?Q?MfVulUumMlPJPjlacCoc+bvvHSb52eBeB2bArjAXCxPF3Spmaoq8I43tB6TV?=
 =?us-ascii?Q?jrNitdI7Na4i64DvrLstYP9jYEJEUTNkUhCnnJhjxqgjBBFs7MnOeqECGOng?=
 =?us-ascii?Q?7hHBGeTDloiMkxdyY8+Y2Ku6cTMcI1ayZKW/juWb1ELqkXIC3Et/Or6bX7ld?=
 =?us-ascii?Q?jfEq6A+/Zp24wowTyvBYFqcZxBHAh4yK9N4OIjzJ822bnVC9pBHbNoMEaM+m?=
 =?us-ascii?Q?jmtLm2BmgKpyKqTxY0w+XvZ8Extr9ALDZXMJ1qGkosnOIZ9h3KhFeJCbCgfr?=
 =?us-ascii?Q?YnZDxXxL/GjBwUv35PKl03HqcS+jYSRYcyJ3RjI7/FRAnKDwfLIa1aMCajsn?=
 =?us-ascii?Q?cwAQXu4/5+y3Ot2Pzmszar5w3nmvWmf8NNghv91SRahKHPS0ZMgNGFB7NtrL?=
 =?us-ascii?Q?jKisExnf8Tg4MqC+8bTzeRx3/fpYfM9n0AaqxdGkiiaXovbsK+umJlsqU+em?=
 =?us-ascii?Q?ttl+CFb6XxQ4xutqv4gN/EHHxPa9jSrpJ2orBey3gznIlPkwp5hU5LbFZveN?=
 =?us-ascii?Q?4tBXJy88TCAvZ+UstD3LLHx76MP0AoPjrHlAobLuWRh3CQSBxQxThzRs2Qst?=
 =?us-ascii?Q?D+CKEJ9Onel3rF7XWYICew1AJRRCmHk9sOnD06kBQxfG8bhDakiNm3VVdTpr?=
 =?us-ascii?Q?EW1PjyPb71BkoDOrE674fWAltgFkF3mAX87qTKjrzNjG0LpgGCJPLyPrS0We?=
 =?us-ascii?Q?8500+27L3pe9/4G31LMI23vsF4MQg3E8TTeFPxi/QPCaPB0rxDOZRkWeFybD?=
 =?us-ascii?Q?L6Cp2IIEbfviPQl/UNG42reB6d8AZ+bSJj1RRfC65mKaOTMjn3MwnG2pp6in?=
 =?us-ascii?Q?H1HG6356vmjq0ktO2Pacmrk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55136c5c-7b1b-4e6d-bb47-08da00857355
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 21:57:19.4026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 65/Qrqlj6dpXuI0j01cUkQ/bmSJjhNK+IWJDuw0riH02fLQ1fnAGWrZmJAHI+LpfAtGH2ZC4/aAjKZvEj4h9ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5003
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070113
X-Proofpoint-ORIG-GUID: re9iXaL76QQD-dODJMpEgnb-lQ9kl4cD
X-Proofpoint-GUID: re9iXaL76QQD-dODJMpEgnb-lQ9kl4cD
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is possible for poisoned hugetlb pages to reside on the free lists.
The huge page allocation routines which dequeue entries from the free
lists make a point of avoiding poisoned pages.  There is no such check
and avoidance in the demote code path.

If a hugetlb page on the is on a free list, poison will only be set in
the head page rather then the page with the actual error.  If such a
page is demoted, then the poison flag may follow the wrong page.  A page
without error could have poison set, and a page with poison could not
have the flag set.

Check for poison before attempting to demote a hugetlb page.  Also,
return -EBUSY to the caller if only poisoned pages are on the free list.

Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
---
 mm/hugetlb.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b34f50156f7e..f8ca7cca3c1a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3475,7 +3475,6 @@ static int demote_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
 {
 	int nr_nodes, node;
 	struct page *page;
-	int rc = 0;
 
 	lockdep_assert_held(&hugetlb_lock);
 
@@ -3486,15 +3485,19 @@ static int demote_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
 	}
 
 	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
-		if (!list_empty(&h->hugepage_freelists[node])) {
-			page = list_entry(h->hugepage_freelists[node].next,
-					struct page, lru);
-			rc = demote_free_huge_page(h, page);
-			break;
+		list_for_each_entry(page, &h->hugepage_freelists[node], lru) {
+			if (PageHWPoison(page))
+				continue;
+
+			return demote_free_huge_page(h, page);
 		}
 	}
 
-	return rc;
+	/*
+	 * Only way to get here is if all pages on free lists are poisoned.
+	 * Return -EBUSY so that caller will not retry.
+	 */
+	return -EBUSY;
 }
 
 #define HSTATE_ATTR_RO(_name) \
-- 
2.35.1

