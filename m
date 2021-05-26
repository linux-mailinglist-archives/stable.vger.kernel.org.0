Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F695391E58
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 19:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbhEZRsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 13:48:18 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59136 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbhEZRsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 13:48:17 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14QHdW01192796;
        Wed, 26 May 2021 17:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ypxbACqBKO4kjDdcmnuVpe1wdi1Hk4qEKyGkYCtZ0Dk=;
 b=QpOUm1vfJ9Ma7iBY6WTlIF78JPnCyKZu1RhhXF2jnGxcG9W2gpFiVre9rmkO9EydQqbR
 BjHPhyhePvio+/qEFSKpbDDkMtLS9aSf9xLr4maq7RPsfGj5JkzYnne05oVofUAncdiH
 vsBwdtgWWmxcq1h7rtPl09u3xtFWf2lzHOSeeUVuANZ/z8kHzv2j8SeeOvCr+YPuLibr
 FqlNKAjVIIcWZfbqp3A/iWkgQ9BD5kIrPL8FOjJi0VUhF7ULPhFHb20VN0OESPV3MedB
 45SEnUNZ3Q15O3qYqI3/mF0gawIp9Dn1wNywu1PBWYq9rRUjGztZ8bnFb2ZBvs46lP1B Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38pqfchynp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 17:46:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14QHjRms193973;
        Wed, 26 May 2021 17:46:34 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3030.oracle.com with ESMTP id 38pq2vh9fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 17:46:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pp1TenB3dCVuhjOxvz6rkzufmMQ9TdU96+Sq8SRqxWsAsegZIdMEjbRujvyCE3DrUlDr6ylH17WpRZaS0XgFlCcqX+0NZ4xfInhYJZ5U77rKMalICWbpIlgZX4/kpQN6XUVNLMLKC0lfoYASB2KaAiz1XX1cPpP6KIxVbMHLQI3DAjEvAcx885K1a1XfCDXTsOHCVFo8SpwA0lL4Ue+n6f39dvX2PQwfeuONGHbFNdZuliOETD3iy/qr4J5TWtaBdUhA27iXFQHLmPwcxW4nFTpAA/hk6p+jzGYrf/1gUgqKr20HNGtcSM92+K5WEkBNKePBHzhTZ9bWCRd+k4595A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypxbACqBKO4kjDdcmnuVpe1wdi1Hk4qEKyGkYCtZ0Dk=;
 b=ESstPH4ZlowIK7ofLXVUzc3ZR26V1oVnMEoYW3vTWn0zOkAATXEvvL3j8SODE6vDAwQBrEvbnQgx1sfIYQhvdzm5dDC8uLabKQE7IdoquTgPq3t/PkeU1iOrn10k16UwhmpwcOF7M2K+1B6MOweKrNjcGFznIsW7uVZMoDQgbbFkVigNWragP+TWxAWVpecuJ+p5TKN37Puf4mxCXUmSg8jnphlRhtoEmLKQIcZrwQy/+QnXIa0z6vzPOLt7dMR0aaTM8cZMXcs5MwEmJ1DAlxCeXEwW7aTlr07JHAk9ZV/iesaYu2rnG8iVfdfOMW8NrVab/9bLGBrCG0L0DDMzkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypxbACqBKO4kjDdcmnuVpe1wdi1Hk4qEKyGkYCtZ0Dk=;
 b=Uuk0kT5EQoFxdPYevxVLsBVx4pklAd1XtNZcyqEUhcJpjG6Gi6+RC7CW2KNZat+ykC/xu4CgRLwEBW4cB+m5+NIFJz5BSuunq/MWtxXwLHYeBhUjaShfBpU50LxqfeXGcVVqhoPn/KtSAW7fhXT71wUxQ85MTGbYxHBfhnkG6yM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2823.namprd10.prod.outlook.com (2603:10b6:a03:87::15)
 by BY5PR10MB3969.namprd10.prod.outlook.com (2603:10b6:a03:1f8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Wed, 26 May
 2021 17:46:32 +0000
Received: from BYAPR10MB2823.namprd10.prod.outlook.com
 ([fe80::5cc8:7154:975d:b2a2]) by BYAPR10MB2823.namprd10.prod.outlook.com
 ([fe80::5cc8:7154:975d:b2a2%3]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 17:46:32 +0000
From:   Stephen Brennan <stephen.s.brennan@oracle.com>
To:     stable@vger.kernel.org
Cc:     Stephen Brennan <stephen.s.brennan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
        Mel Gorman <mel@csn.ul.ie>, Andy Whitcroft <apw@shadowen.org>,
        Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
        Khalid Aziz <khalid.aziz@oracle.com>
Subject: [PATCH STABLE 4.4-5.3] mm, vmstat: drop zone->lock in /proc/pagetypeinfo
Date:   Wed, 26 May 2021 10:46:13 -0700
Message-Id: <20210526174613.339990-1-stephen.s.brennan@oracle.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2606:b400:8301:1041::11]
X-ClientProxiedBy: SN4PR0501CA0055.namprd05.prod.outlook.com
 (2603:10b6:803:41::32) To BYAPR10MB2823.namprd10.prod.outlook.com
 (2603:10b6:a03:87::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2606:b400:8301:1041::11) by SN4PR0501CA0055.namprd05.prod.outlook.com (2603:10b6:803:41::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Wed, 26 May 2021 17:46:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 131cba72-5e53-4738-a2a2-08d9206e32e4
X-MS-TrafficTypeDiagnostic: BY5PR10MB3969:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3969FADE120C3EFA8C026699DB249@BY5PR10MB3969.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?zXl5wZisIecc/k/OJRsXLRt+6yAPp6hUb/FQYPnweF3YL3HO5RqC66GtdzuX?=
 =?us-ascii?Q?bqLeUCBa+YhVH9b24Z43ACUUyGLLbJ53AqKzCN9xT3ugvn11Fba5hQIIPL1P?=
 =?us-ascii?Q?l17fzzpMV+XhqzAjl6ikCkWzQbRzYP5Bp8Vj7SQy4riUPYIraYMl5HWBDzr5?=
 =?us-ascii?Q?LEnYrzpuRYVzEo2WZsZwUfkwO3gd2FCH3VjyQcBQ9rdAJgi5gXXHgN9xg8gM?=
 =?us-ascii?Q?rwwYQpk48QNpo7nRBx+AUT39oDjfy6OuFODgRNiDKJ4BIfwGS2UgV/2qafFa?=
 =?us-ascii?Q?dUeg9d5Q2P3BFyovfBP2RoLxuZx1LslcOcT6JRYtZ4zr4WOnW8VVgUHsV47y?=
 =?us-ascii?Q?hNtOhp/dvfhCDoowF+wCVeDJUSmGDJjxNqGKn7UXjZ0esG1DTl+uY7Uz8Fo1?=
 =?us-ascii?Q?YtjN1nvgpcMmDhV98KJ2AxmNN7kwIMLPcz/6KiRlmDQme0DmoPcX5MAM+YMI?=
 =?us-ascii?Q?o+lOp0zAXK7MWUFcxGMswOXC4qTFJmC1a6sYO/d9KHq4WLqHjlxnXpNkFF1d?=
 =?us-ascii?Q?VSfqqCBsaAm7/aQIIstP2hHGbsxYrCA0oN5a5qYWB55/bW4Nr5nDVz1GwBqz?=
 =?us-ascii?Q?X+154g/GZ6CFqICMNlpe7JC7enM7L3ktDFdFfdlNzuXchcAGlSCsW0hhHZ7H?=
 =?us-ascii?Q?cNgvpHCf6/PfhZHYoJkpvaepl1nVU8kDEyQjEvHSP2TnEOCyPlsl5/phQYtQ?=
 =?us-ascii?Q?M8KcoHkIHqhQZSaWOnzi//w7bSALShJJBjyUh118yKzK47PrZ7DxQSnlDEn8?=
 =?us-ascii?Q?SBrnWUFNIH0ODxLuKTI3o0DqsGv5RF2XES/HAmdI4lrdGE3+mSkNGkSydZHj?=
 =?us-ascii?Q?qZpmh8x+NT7SBvKa/ngfiVP9boGsxPkLoTDXTTLKqCK6imt5haaOaqU46Fpa?=
 =?us-ascii?Q?GnWLn1z4zjJ/y4SVnA/VggArtwBAhIX1LGtIK70ObH56q9jBKoLZzJm/4wi7?=
 =?us-ascii?Q?IqGQmCxz7kyOT7pNu61YYQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:BYAPR10MB2823.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(136003)(396003)(366004)(346002)(39860400002)(376002)(478600001)(107886003)(83380400001)(6666004)(6916009)(6496006)(4326008)(6486002)(66476007)(66946007)(2906002)(86362001)(66556008)(52116002)(8936002)(103116003)(316002)(1076003)(5660300002)(8676002)(16526019)(36756003)(38100700002)(186003)(54906003)(2616005)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lzjsn0vDaf8wxrgQjHDuSot/fgLvxdwfHiWhuyPQH58+fTO9wEfud1q8A9aO?=
 =?us-ascii?Q?JwAcPHr5Gvg6MlM5Vjphw6jXK9UeHPrkSznkU+xWIaW/9COR9dEAn75lBOFr?=
 =?us-ascii?Q?CeSuSQ5t58LLYDzaoF9nx6bEISdLVyZML9OFgbZwCxRnUhBqh8SaS4vniTde?=
 =?us-ascii?Q?FkUkOQ/6xc0OLi2tyLHN74Q/C9AltK26rXSpvx1TgOIe1hHgNCExqh9zPI6R?=
 =?us-ascii?Q?aj/PCtzyLs4OiUSfoxJm+AbN3WrsD+odcfu+P3o4JgrBUCT+MBv6vxn/LyNr?=
 =?us-ascii?Q?l5unUI6tgycLBhrpq1o6k3fMYKN/1LbwsoXu4RQYJzlS3xG6usiTJBJDXefY?=
 =?us-ascii?Q?7v1AbUdbjMXrA+NnIzs2ZSlGDNjBMTi/wk0TSU6rsiKalDvTRKjCg6BfBgzO?=
 =?us-ascii?Q?s1aCcRkYUucppifgezzhTBTYUuMVxnbP6fSqMXQKWCacSDgQa74P1/nt4+Od?=
 =?us-ascii?Q?aPeqHQL8p2gOzRiERolcaAj1dM1Qoitd4UMtVX1gBSKI12qr9BoDj1dzcMzM?=
 =?us-ascii?Q?bQzX9mGmbj7bkO/fwhabVAM99sqOa+f4XZ/CCGuIK688lY8aISpK/mNust62?=
 =?us-ascii?Q?dasB4Wn4RCyXWyJr9OTj7VMh3qQ0B3PON5fN15sQdZvtNYC2EDMO/Ki8IZWb?=
 =?us-ascii?Q?WWp1sQt+gK5agKFbOfKRwu/Bys+eCvah7iP/9IUKZLStfqc6FDX3VZhlAblD?=
 =?us-ascii?Q?rT5dY3K/bufUMTevzUqjTT56dmqycWrvpXVsVqrh42NCUAglYhupHRbzIWVH?=
 =?us-ascii?Q?sl8WUacd0JxCYlMBMo/iwnTZeqshCj5S6IWbySCwUFYTpZoZ6giOTWq6MsnA?=
 =?us-ascii?Q?0TnDDpLfYq8F6/vGskgOsmw0g0joBnC6c2hCq7pXj0+L1FgXJbml71dUq0kQ?=
 =?us-ascii?Q?J4NAk2wJ4FdNgqjDrnOwzfubcvq4eXAaOS1mvxgGoORPAVemldVNQ20H4aWt?=
 =?us-ascii?Q?vy78KmjjNDcYK0Hrnkly/OaIkrbSi6uEGplW7rIU6jBwjp4zyPfxNXxKlDoV?=
 =?us-ascii?Q?dOiDKFx2zl000EGfQmxsvhoLssWRfVtljqOwQKdRlIzn0ze3wDIOcwy8iA0y?=
 =?us-ascii?Q?Ch+bmXnhbUqbkuKxJHvCI5qreJFS/osOKgl6QXvtXdeFk8f6IekdndYTK8Hk?=
 =?us-ascii?Q?ZtmH2TfcDyZ5i3cBAZ20P9Vdf6C4JV1RJ73NGu7dN1Tc8lEgtxzudTQHa+kv?=
 =?us-ascii?Q?7UChQ0MJ9yAgnqnMOu5esQRblUk6I/vsRvIcEhUBCcN4NT9mXJTMvcnztkzg?=
 =?us-ascii?Q?ZXSGKsxaTg3lr1+M+oQ8XfBJlBVBKv/eyNSygtGDL4H7eLFE1u/1xWtkOAXl?=
 =?us-ascii?Q?WOcw6JHKRY+Y1vS2NiqiytPuuuEpsWVZTyr9PNfA0vCRjg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 131cba72-5e53-4738-a2a2-08d9206e32e4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2823.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 17:46:32.3700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RnQZXBVnPRxINOYl+hi0L3jCQ8QH4P3PKxp4b+/id5uEa7cvzmT3BSbVJ8TS6X6kF5/NNUNfexmx/u6lC0n9HCw/siC7ZseQOJnbvLUatCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3969
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=988 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260120
X-Proofpoint-ORIG-GUID: dyHUTvtvtIpBdw4G2rnqN-cen8vKO2-O
X-Proofpoint-GUID: dyHUTvtvtIpBdw4G2rnqN-cen8vKO2-O
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1011 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260119
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 93b3a674485f6a4b8ffff85d1682d5e8b7c51560 upstream

Commit 93b3a674485f ("mm,vmstat: reduce zone->lock holding time by
/proc/pagetypeinfo") upstream caps the number of iterations over each
free_list at 100,000, and also drops the zone->lock in between each
migrate type. Capping the iteration count alters the file contents in
some cases, which means this approach may not be suitable for stable
backports.

However, dropping zone->lock in between migrate types (and, as a result,
page orders) will not change the /proc/pagetypeinfo file contents. It
can significantly reduce the length of time spent with IRQs disabled,
which can prevent missed interrupts or soft lockups which we have
observed on systems with particularly large memory.

Thus, this commit is a modified version of the upstream one which only
drops the lock in between migrate types.

Fixes: 467c996c1e19 ("Print out statistics in relation to fragmentation avoidance to /proc/pagetypeinfo")
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Reviewed-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
---

mm/vmstat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 13b74c4314a7e..663069cf7724a 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1316,6 +1316,9 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
 			list_for_each(curr, &area->free_list[mtype])
 				freecount++;
 			seq_printf(m, "%6lu ", freecount);
+			spin_unlock_irq(&zone->lock);
+			cond_resched();
+			spin_lock_irq(&zone->lock);
 		}
 		seq_putc(m, '\n');
 	}
-- 
2.27.0

