Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1D32E6C37
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbgL1Wzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61486 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729331AbgL1Tp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 14:45:57 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BSJcwXF004599;
        Mon, 28 Dec 2020 11:45:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=LRR1D0hqBUOFMz5uANlIdHUf3XOP2UxydxuYUHXsOtA=;
 b=P6ZQ2ljC0ALO1R9DBa7WJN3Q5IW2adTiwE+IftjeXOdCVxLUZr9vM5QU4M3fXMkshc0N
 7Bkrk7njpv8sW/6dgMPJoTIRgWqu8WvZbSltvQ9HDNz5kywUvNiGi9IPIffMyEKVrWtR
 +5MQH9jdOX0o5WehroKA0SaF6E4Y0zZ4uq0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 35p1j5y5as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 28 Dec 2020 11:45:06 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 28 Dec 2020 11:45:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcSVbgQDLeDYURl8Pc04zpPFou9g4uJk5DvzvKSKrcOJLO/G3b/Z3N+I+YMhvBOu0XHlYORmyMeBgwtxPvmIj/ADrJ0obesCIxhs/DwFJVocprSTR0CmuWgyvv8KUrdz5xNN2kwo/dgTZU/UZVt1iQcmBd93upAgoFxBSQ3HRyoEnFIS+lQ5C/+ueDP1wFQxiwhLoj4iSm99nj0YLMiNuA8wywDHyUR9xZw8+LREQi5aDBBfb3f5EanLvCsRsIkT5uPzJwFg7D0Gg/RE0Olk53fw9XtVnza9KAbmC+rSfsIrrC+Fpk9MCpKtqG2SnyPduv0LgK6f3y8kWG/xCN1oug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRR1D0hqBUOFMz5uANlIdHUf3XOP2UxydxuYUHXsOtA=;
 b=e2VwDknizEi74IqPHeKw/DUSG0exnqEvX96vTOhbkEpGHvzX208vkU/A0Kp426Jo3h4dfgC+8T2C/MlDQ67hBmbUxLi3lAOjPK1jc1bLhrrVAfohPJTieE/0Gmh6lXCm4+ULLWfmLy6DqhGVRENIFNa/RXivfF+5qZMGWwT6Q9IKNT1TMCRUksXQ93oqXe3I3ptNLhb0vghGO0KLOY5gxhvbd+z9hzt0cJEg1KWfb6WygTlgUXq9E7YNbiT8pry5rx7VybyMXW2WsvP2huSKldsAxN1AIRNsGaYK0LaXA6yDxif6gfHNLsrS/wQlYfFqFgXD4SyRwccySq71AvkU2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRR1D0hqBUOFMz5uANlIdHUf3XOP2UxydxuYUHXsOtA=;
 b=C2SINFfXY3u/iDxxa7gWQyOMyB3r670MGzsh80p46puNFbsx1y6HJGZfZ72Kh/w1aO1pfm3JNkZE7M7d+zzJq1NNbXFg6puIrRHJ/wFcgO5iM0Wh4rB1MuHAF6KvAY8m+50Nj16uR1UQfBiPRX7gkwEij8noe63PtdhXwk9G+pk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2437.namprd15.prod.outlook.com (2603:10b6:a02:8d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.31; Mon, 28 Dec
 2020 19:45:04 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::ed8c:29c3:6ebf:3e66]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::ed8c:29c3:6ebf:3e66%5]) with mapi id 15.20.3700.031; Mon, 28 Dec 2020
 19:45:04 +0000
Date:   Mon, 28 Dec 2020 11:44:59 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     Muchun Song <songmuchun@bytedance.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm: fix numa stats for thp migration
Message-ID: <20201228194459.GB318614@carbon.dhcp.thefacebook.com>
References: <20201227181310.3235210-1-shakeelb@google.com>
 <20201227181310.3235210-2-shakeelb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201227181310.3235210-2-shakeelb@google.com>
X-Originating-IP: [2620:10d:c090:400::5:116b]
X-ClientProxiedBy: CO1PR15CA0069.namprd15.prod.outlook.com
 (2603:10b6:101:20::13) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:116b) by CO1PR15CA0069.namprd15.prod.outlook.com (2603:10b6:101:20::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Mon, 28 Dec 2020 19:45:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8218937-6792-41a1-927d-08d8ab691286
X-MS-TrafficTypeDiagnostic: BYAPR15MB2437:
X-Microsoft-Antispam-PRVS: <BYAPR15MB243779CA1DFD6CFDB01F1FD9BED90@BYAPR15MB2437.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kteaW2lwgp1PwMh+Mi01HlbDc5jkd1cTLKG2Q4OpZ91Tqutv/D8PNP6Oz7b/WIOWeLoaS/VM3TnfMcVPw41hoCW840129/SZ5CbeEOR1n+A28kv80b8ZpYZExoGbG3zSDeZyAbzCLrCMwWA/XMeGDcNH3UmTUgBHacNMFXAtI0KylgjFeHv8DUn9Tgw6OW9vX1SffQYut6fP3QPcxPE7Jz1hdNIhCNZyG8fFoUgPsMQgL8OkUaxjGumQ38/9kyx1o2GgmsgRfV9RFsxv7k0vlAuNJPCakHxHaMG2yFlxQzW/lS/LCZz+yuj8gbjSnfoouon0a7aef+cmiiCweN52nOA+EQSmZ1m8px0H74X+s63w2J1hiE0XonBfmkej1tc1Rz3NQiJ0RjaMJb2iZBH1uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(396003)(376002)(86362001)(6666004)(8936002)(55016002)(16526019)(4326008)(54906003)(186003)(66946007)(5660300002)(316002)(6916009)(478600001)(66556008)(2906002)(66476007)(33656002)(6506007)(7416002)(1076003)(7696005)(4744005)(52116002)(9686003)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zJrct+8q80vVEEhCVjHYUKhcaB/q55tNj6pxdGJg3fpPszB2uNydjsVb+YY5?=
 =?us-ascii?Q?s5AQL427CrbWDDoOkKU+ld4ugZeEVz8ly9Ddj+xaeFvV6pYefOvD2JfCxDJA?=
 =?us-ascii?Q?KO0EsPoAOT55SGDBnuMkO7UoCytctmsOe5rBMNO92YCs3QeP8NqMg76lUtAd?=
 =?us-ascii?Q?NWD1Wx06vqMgDRhDkCB8UM+wYqmbswwI2b+/5xyclce4BIZ7WKhNM4CL4xfR?=
 =?us-ascii?Q?QiRfqdFIlXKEiiwC/wD7i7sbGW/k+2NsKKcrLN+I8BzV7nQQAOhqtjwL2cmW?=
 =?us-ascii?Q?gM43VDg1o6BioHNpBQxLQuR3crhMZmPB52TvlnPtlgyL4tyBh6Ki5MOO6Bp+?=
 =?us-ascii?Q?hYxW02++JaA4G6RcghlNB+9McuZKQnAI2MpkOqvdQfFJzNTtiKluvT6wO0Qx?=
 =?us-ascii?Q?s+VPsgOGEFqHyI8hz8u63erYoNxYbjhW7qdK/qzI7gPHDRKqt1xAz7gFLzw3?=
 =?us-ascii?Q?gig4Lynet0ExUQJf1ICNZWt4Nw9OETnAIm83UFn1/n+rUInpe72Bq+myeTjl?=
 =?us-ascii?Q?Kuv+SeuXqwIoVz9kXcxuvbSDN4AXrH4ON7cLpTLGhze4z3JW59XWQgLZxUpP?=
 =?us-ascii?Q?2J6onKSZuICWEURC+3P75sjC+CCjY93Bukj8eiGiqVvnahittGelhzEaQ2AJ?=
 =?us-ascii?Q?IYFP7CCrFwh4JntR3hkb5L4x7yMj+3Gdk57pU18xhGQMhqrvw+aIiW2uNpJ2?=
 =?us-ascii?Q?fFSM4tXyB5mG7BqG2csY8P1XSKcZVIznoq8u6/f8f8kiHcYaNK6bICbhLZZB?=
 =?us-ascii?Q?MX5qvZZQaHyNS3AuuN2sIwVxCrY6rT8ZwhjliUVetCBtzu3dqDCmNAfI189M?=
 =?us-ascii?Q?QI5qCyIoan2at7UNqfY9t0MsLAdMKtWOsSAhNP2Dg8hdVL8YxXdv4ouE+efV?=
 =?us-ascii?Q?4vivjIa4a5XkaHhnhgF40e8O8MOyfA2Go9rg945FwJTmkNGpUxsQJMCsmPR6?=
 =?us-ascii?Q?2iYp8tHUca1CpTjGE9CGFuznIpCCjpNsmIsiIbEaYl28Vj7zcksx7uADb9yE?=
 =?us-ascii?Q?Fb96WCtJneI+J1Zel9ch+IWEig=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2020 19:45:04.2880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: a8218937-6792-41a1-927d-08d8ab691286
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3uMVzuVwr1Gj2EIQyQOfwv2OAeOt82bJ2t0ULaPCE7m3QMwrDIYVif9vpVLX9I38
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2437
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-28_18:2020-12-28,2020-12-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=817 bulkscore=0 phishscore=0 lowpriorityscore=0
 mlxscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012280120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 27, 2020 at 10:13:10AM -0800, Shakeel Butt wrote:
> Currently the kernel is not correctly updating the numa stats for
> NR_FILE_PAGES and NR_SHMEM on THP migration. Fix that. For NR_FILE_DIRTY
> and NR_ZONE_WRITE_PENDING, although at the moment there is no need to
> handle THP migration as kernel still does not have write support for
> file THP but to be more future proof, this patch adds the THP support
> for those stats as well.
> 
> Fixes: e71769ae52609 ("mm: enable thp migration for shmem thp")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: <stable@vger.kernel.org>

With the typo fix ("__mod_zone_page_tate")

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!
