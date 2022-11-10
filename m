Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB29624D67
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 23:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiKJWDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 17:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiKJWDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 17:03:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C890945A2E;
        Thu, 10 Nov 2022 14:03:17 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AALwESN003610;
        Thu, 10 Nov 2022 22:01:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=09dzP1aQgPZQtVkhJXhAyB7KxeXoTPtg1aAruUKWINM=;
 b=01fThF+HqiN0UB0aOVfCdsY+St28c9iSKT12hrMnZZsuyKOznEt8KSfe0j2kNWN7E20+
 Wd+6IEOWLh8KWIDAs3JFzICSz1PPfA2xmjcOmvKFTg2sIuBpgEDm3Tj5so8aQ+iyxbMJ
 HDT1U55EEXqjPcgN6sL9dRWplxD0CWRLFFWH084b7RScIrrzngZdsaQH6OruddG4zG3g
 Q5uCrJ3Ruq7MNdAlRrE2YzGBCggkmpNTM9b28RvK49ntCl1GYAR14vchUrl47MeFsgvE
 a9bQk2nKmZq9bpL6DyMlxkrkpBubq1MzDQrhTuE2ye+85q59syMb7Uvcpe9PUAkZa8Ay QQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks9ns8151-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 22:01:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKZVlB004235;
        Thu, 10 Nov 2022 21:55:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctq23j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 21:55:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiIHfWmq3muZka/QI22I9rf5+A8eaxHeapz8ondwmsjYjOBgB7j2vkt45Ejc5K8AxYlzKEkP96SE7SwtR+3orVqR+Sdmugify0PHfawVT3Tuz170s9f2QsxLMt6QXieaLGQMENdxVlexSOUQWlo0TC4FxrgH1z4ghoqEZgg7J5UObfbDF4Vh8wKWW389CSWNDEy8bRA+ishBEsHteqvA1O2fE0JMmR2l69vjwY14Ejx/4kxnn0N4SQYSnsRMxRJYWL5G/x7HCyiCaux+wP4c2W9C8cbvk/yEMEnJrsY+NWB3YEPhBqMhqTCikZPGDc/mvM7OUgnM19mZ3TADcWGhVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09dzP1aQgPZQtVkhJXhAyB7KxeXoTPtg1aAruUKWINM=;
 b=PzY/n4qZwzrpjo04bCqZ0owFT+ZC0hZivTM3W2ld11rFAoQVj62/Rm3FfAE6JM5X8rrIRVxQXQcvcepU41gXzoCMEIPsv3y3lnJilossjHWpwZ9es5O8oCUbhfS9B+XbrbJeRZPIIK6Eiz1FsFUyAST/4Bq7nYtuRwoeko6iALDBl6tT7hFb+JHBp/xpBOPP4QnqFpr4sVFF95fJevvywDe9kZTyKr+JjjNwXBLS8hP84Izlc4X9bMRwuk+tZ/+Ju+Mjnp9hAAOanIfQGw9jOjIWcmxSNxElhHDELonSB6jmVv4MUu35H+V0TdIcDLXmm3I9+FRYjLBAl/38+bl0dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09dzP1aQgPZQtVkhJXhAyB7KxeXoTPtg1aAruUKWINM=;
 b=zSlzPahhmqkpprIcwbDWv0etlcK/oskUhQLK2H+ywQCr+ipbfXz5xQo4DyKXGhvHHRsn5LotC/eP9UwuvZVlNXtcYdhVyRO5hIeS6A3tjNT8pc9vzljsLKRsBYe7guotlTRvDk8QA1dA9ZCrvAa3INBMMmknaSI8zuJ2h6WFpv4=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SA1PR10MB6293.namprd10.prod.outlook.com (2603:10b6:806:250::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:55:53 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5813.012; Thu, 10 Nov 2022
 21:55:53 +0000
Date:   Thu, 10 Nov 2022 13:55:50 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v8 1/2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
Message-ID: <Y21zZgHzUz8gJfTI@monkey>
References: <20221108011910.350887-1-mike.kravetz@oracle.com>
 <20221108011910.350887-2-mike.kravetz@oracle.com>
 <Y21lkEMOALb2pP89@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y21lkEMOALb2pP89@x1n>
X-ClientProxiedBy: MW4PR04CA0255.namprd04.prod.outlook.com
 (2603:10b6:303:88::20) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SA1PR10MB6293:EE_
X-MS-Office365-Filtering-Correlation-Id: 6521af67-1fad-4286-3850-08dac36656bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5gj13tNJjlNap/6i4vUC11A1LVQAq8Z2we7L3FesMfKa7YEU7tQQNGcfPp+csngBVS/ij5fLa1dZ4IuwTxP6MwHcOIem7PCfqFCY6U7Qnym22aD4MlK0ElsdOohe29H0fZPQTmYHJeLw9061jaIIHT/QtyEvlfpO3ATiofVlBNcvwPx5AnR7p492Hluc2PYI5Lii8XJt5/BULUNmq61vKim3L2j5XGbzPlOd4Wc0oa2+g86HPKpyrLXpjhije+1zbm6z9YZjU94PxCm7MLC+iio5SAuxgD2yFryOvGt7/cWHTjv00xrcSz50MY4LcklFV+IkJHsOd5h81WFg6FjxMOIAuCHcNLCkWbtofdORu253LIDhN0glxMrEWkpVgteh989jZX2uN8LJb5N2XOU4Dj8cdyI4SR6gOt96OMLcThOWhn4a3pMPMqo4iEeD6DTQ2R+uCpTcR8Kz35e6kzsvgkKwZVR9B+WF9jTXuJW00sTJ75IulWmP8FDN5fGItuwu3obV5zLEqrnvPB1WkutGBe56qs4F3ChvOdYc7qwqY3kTiOiZ2FAmjUVmJ7UhYxMZvvMyN6m8jT+4TbtzdR3WTdTrBx9kgu6U9s+8Zhs1e4btdXJNLd4gR1aXK31TpYckOiTunQBtPSMY+sPurgHMJ03+v/NRJcjESYhqWBM7ZF1HMC9bGmnvOBT2s6GHJqLL49GoZZytgeAZiOSNdmg2sAydhtqXAhCGhmR47DnRdoQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199015)(86362001)(8936002)(44832011)(5660300002)(26005)(7416002)(9686003)(6512007)(83380400001)(186003)(38100700002)(316002)(2906002)(66946007)(41300700001)(66556008)(54906003)(66476007)(33716001)(966005)(53546011)(8676002)(6506007)(4326008)(6916009)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qoNSKUhm4Yps3mRNCz8ex0L93CW2dO3HeeLT7WE7n/XW+66RL/2kM9vlFO9W?=
 =?us-ascii?Q?l4uAoETwW+ET9lt6Nq1VjarhtJRZ9PpBI7Scq6TFnKbDgr8oPlvZ+ls6jGUg?=
 =?us-ascii?Q?0eOcrtQ2E5lndIOpEsAw4c1K2p1psQvZYH4jtvjozjVGhuMc4RBgvaHVM45g?=
 =?us-ascii?Q?CQBAkiCc4CyT+64hE5S1Ba9zY5E+sYglShls3Mv30yXkFMn0gUSAx5UKTWwO?=
 =?us-ascii?Q?CifM/52CtrkbG3hlhWlP0DCnBRjnpAfTn2urQJjaI88ro3y7uMWBtHusPP6F?=
 =?us-ascii?Q?K1sG0MBeg22Kf3HKDvu7RciAuboG3pTd1GkoxQiNlsbvI5xZBISuhzOmTF07?=
 =?us-ascii?Q?k6kQX6qgG6pyqJgbTFe3iGKzzWXX6zafpWLB2DbdqUf3m088lxqRQC5itni0?=
 =?us-ascii?Q?WWb2tPgVHZOUIdBAmpty66cPqVcao8i/YzPzZalvp8OrIlYCqfT5k+Iyj/se?=
 =?us-ascii?Q?PnFsNUkgG6M0P/0GJP6X97ZZO2DcCfv8HeqmUrZnlYFjgHEa7yCK5UyIGsTA?=
 =?us-ascii?Q?IJp7XJx3/4haHJG2G+SfVUQ3udNHceHZDLk+grBPYpbyODHlp9uN+hO6Ez7B?=
 =?us-ascii?Q?LILf8cBwUm02YSziAWEN9wsdf4mj5TGmI1wkQlrryCs6/hX/Q5rFMFs9/vRb?=
 =?us-ascii?Q?+iTGjEd2pDp+V68gaC7R2zMx0pk2SZPH+Wz572Qz7bHlEmofRSikuv2S6qlY?=
 =?us-ascii?Q?y2dqhXFgOH+GJit5VfO/hKm7hA0AKgEeqc3lFg8AJXFO32T/di9J2XMCLr++?=
 =?us-ascii?Q?8ICHyDePay648fva489OL2biZkopf9wa7UsMrpOJXYZ3t02jjdQy9te2PGlv?=
 =?us-ascii?Q?mbOd8J7wcNvnyZ2H2KGK94vshKTx+ClKuM+FZTJd+uAS0DjxCdz6D2wQq0Fk?=
 =?us-ascii?Q?B0omzHCYQcsX5kU+W5eeVDf8HG+Z74Dj5wb5e9rCgvT+tkHql1NbibA7lVPD?=
 =?us-ascii?Q?XzB0epfA1cjzNTbvfDhlZ4zqbDfkAyHfMo+N9rPX445LaxdldiShIIJoHXHE?=
 =?us-ascii?Q?EiPdwiqUvdJMvC8Bqq8nMCqdhDh+bSay8wwSLYXxxS+HW1szZkGM6AR8YfXJ?=
 =?us-ascii?Q?XJNMypG639ZDnxKFJVqVRxUHemHzwdWeu3ye1iCwRcI1/lOLpXYr5kNt89ca?=
 =?us-ascii?Q?GIhqxP+4J+CGhZgHNKvwuJlIHDbfFf+tHn4DQcbjwTyLwWDue675oLnilqas?=
 =?us-ascii?Q?vU9PMLdyYVK8q1PK+PUUzbxOed7yNGUb6EEJSVpN0vn+/Yz5/B4xjdEcWjkm?=
 =?us-ascii?Q?X44boqS2/T7fF2TgxfcVpKYBxKw+C5lvJeba7FgqRTIDDjP81MlTmCSIERmn?=
 =?us-ascii?Q?+3orptMSxNXubLORWGWBnsGwu0a3+gXw7iSBUkQ4NZXXl/EtT6oj0fOEj/DX?=
 =?us-ascii?Q?D5TN63X+wZp2xIFEqklw9VEt7GXFW0kq8J0e8+Mu1gSsfW0yhtrPEHy90dOR?=
 =?us-ascii?Q?Mvouj6YtVwszWeLV+j7le+IALEKvxRlbQvIrAMlkixyfA9RGVs42s2KpxIlQ?=
 =?us-ascii?Q?a+LMeSbnLpNpZEOJwDTQCfVb2HlZJZFqA/jyETqu8QmFL8h04GRoteAiGxPR?=
 =?us-ascii?Q?kWvjcwDzod/JceCrXog8W+CEp+3CR8Jvo93OtYB0IjbmxF2s/Wec5ODFWDXL?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6521af67-1fad-4286-3850-08dac36656bb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:55:53.7568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WMfTvQ86nJDllU/IdX2nIgo/a8/JrtCCQN9elm6oMrtTQ4TQyKIGCbypYc+Bv6rSvQK3DeTRiNE/lHXW0VY5kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6293
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_14,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100154
X-Proofpoint-GUID: -CAs5uiWAqqLD4GNNoBpvIhDpBRLzGLL
X-Proofpoint-ORIG-GUID: -CAs5uiWAqqLD4GNNoBpvIhDpBRLzGLL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/22 15:56, Peter Xu wrote:
> Hi, Mike,
> 
> Sorry to be late, took me quite some time working on another bug..
> 
> On Mon, Nov 07, 2022 at 05:19:09PM -0800, Mike Kravetz wrote:
> > madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear page
> > tables associated with the address range.  For hugetlb vmas,
> > zap_page_range will call __unmap_hugepage_range_final.  However,
> > __unmap_hugepage_range_final assumes the passed vma is about to be removed
> > and deletes the vma_lock to prevent pmd sharing as the vma is on the way
> > out.  In the case of madvise(MADV_DONTNEED) the vma remains, but the
> > missing vma_lock prevents pmd sharing and could potentially lead to issues
> > with truncation/fault races.
> > 
> > This issue was originally reported here [1] as a BUG triggered in
> > page_try_dup_anon_rmap.  Prior to the introduction of the hugetlb
> > vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag to
> > prevent pmd sharing.  Subsequent faults on this vma were confused as
> > VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping was
> > not set in new pages added to the page table.  This resulted in pages that
> > appeared anonymous in a VM_SHARED vma and triggered the BUG.
> > 
> > Address issue by:
> > - Add a new zap flag ZAP_FLAG_UNMAP to indicate an unmap call from
> >   unmap_vmas().  This is used to indicate the 'final' unmapping of a vma.
> >   When called via MADV_DONTNEED, this flag is not set and the vm_lock is
> >   not deleted.
> > - mmu notification is removed from __unmap_hugepage_range to avoid
> >   duplication, and notification is added to the other calling routine
> >   (unmap_hugepage_range).
> > - notification range in zap_page_range_single is updated to take into
> >   account the possibility of hugetlb pmd sharing.
> > - zap_page_range_single renamed to __zap_page_range_single to be used
> >   internally within mm/memory.c
> > - zap_vma_range() interface created to zap a range within a single vma.
> > - madvise_dontneed_single_vma is updated to call zap_vma_range instead of
> >   zap_page_range as it only operates on a range within a single vma
> > 
> > [1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/
> > Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
> > Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> > Reported-by: Wei Chen <harperchen1110@gmail.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  include/linux/mm.h |  5 +++++
> >  mm/hugetlb.c       | 45 +++++++++++++++++++++++++++------------------
> >  mm/madvise.c       |  4 ++--
> >  mm/memory.c        | 17 +++++++++++++----
> >  4 files changed, 47 insertions(+), 24 deletions(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 978c17df053e..d205bcd9cd2e 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1840,6 +1840,8 @@ void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
> >  		  unsigned long size);
> >  void zap_page_range(struct vm_area_struct *vma, unsigned long address,
> >  		    unsigned long size);
> > +void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
> > +		    unsigned long size);
> >  void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
> >  		struct vm_area_struct *start_vma, unsigned long start,
> >  		unsigned long end);
> > @@ -3464,4 +3466,7 @@ madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
> >   */
> >  #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
> >  
> > +/* Set in unmap_vmas() to indicate an unmap call.  Only used by hugetlb */
> > +#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
> 
> It seems this is not set anywhere in the patch?

Correct.  Should be set in unmap_vmas.

> > +
> >  #endif /* _LINUX_MM_H */
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index ceb47c4e183a..7c8fbce4441e 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -5072,7 +5072,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
> >  	struct page *page;
> >  	struct hstate *h = hstate_vma(vma);
> >  	unsigned long sz = huge_page_size(h);
> > -	struct mmu_notifier_range range;
> >  	unsigned long last_addr_mask;
> >  	bool force_flush = false;
> >  
> > @@ -5087,13 +5086,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
> >  	tlb_change_page_size(tlb, sz);
> >  	tlb_start_vma(tlb, vma);
> >  
> > -	/*
> > -	 * If sharing possible, alert mmu notifiers of worst case.
> > -	 */
> > -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, start,
> > -				end);
> > -	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
> > -	mmu_notifier_invalidate_range_start(&range);
> >  	last_addr_mask = hugetlb_mask_last_page(h);
> >  	address = start;
> >  	for (; address < end; address += sz) {
> > @@ -5178,7 +5170,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
> >  		if (ref_page)
> >  			break;
> >  	}
> > -	mmu_notifier_invalidate_range_end(&range);
> >  	tlb_end_vma(tlb, vma);
> >  
> >  	/*
> > @@ -5203,32 +5194,50 @@ void __unmap_hugepage_range_final(struct mmu_gather *tlb,
> >  			  unsigned long end, struct page *ref_page,
> >  			  zap_flags_t zap_flags)
> >  {
> > +	bool final = zap_flags & ZAP_FLAG_UNMAP;
> > +
> >  	hugetlb_vma_lock_write(vma);
> >  	i_mmap_lock_write(vma->vm_file->f_mapping);
> >  
> >  	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
> >  
> >  	/*
> > -	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
> > -	 * the vma_lock is freed, this makes the vma ineligible for pmd
> > -	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
> > -	 * This is important as page tables for this unmapped range will
> > -	 * be asynchrously deleted.  If the page tables are shared, there
> > -	 * will be issues when accessed by someone else.
> > +	 * When called via zap_vma_range (MADV_DONTNEED), this is not the
> > +	 * final unmap of the vma, and we do not want to delete the vma_lock.
> >  	 */
> > -	__hugetlb_vma_unlock_write_free(vma);
> > -
> > -	i_mmap_unlock_write(vma->vm_file->f_mapping);
> > +	if (final) {
> > +		/*
> > +		 * Unlock and free the vma lock before releasing i_mmap_rwsem.
> > +		 * When the vma_lock is freed, this makes the vma ineligible
> > +		 * for pmd sharing.  And, i_mmap_rwsem is required to set up
> > +		 * pmd sharing.  This is important as page tables for this
> > +		 * unmapped range will be asynchrously deleted.  If the page
> > +		 * tables are shared, there will be issues when accessed by
> > +		 * someone else.
> > +		 */
> > +		__hugetlb_vma_unlock_write_free(vma);
> > +		i_mmap_unlock_write(vma->vm_file->f_mapping);
> > +	} else {
> > +		i_mmap_unlock_write(vma->vm_file->f_mapping);
> > +		hugetlb_vma_unlock_write(vma);
> > +	}
> >  }
> >  
> >  void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
> >  			  unsigned long end, struct page *ref_page,
> >  			  zap_flags_t zap_flags)
> >  {
> > +	struct mmu_notifier_range range;
> >  	struct mmu_gather tlb;
> >  
> > +	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
> 
> Should this be s/UNMAP/CLEAR/?  As IIUC the unmap path was only happening
> in __unmap_hugepage_range_final().

Right, unmap_hugepage_range is employed in the truncate and hole punch
path where we should be using the CLEAR notifier.

> > +				start, end);
> > +	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
> >  	tlb_gather_mmu(&tlb, vma->vm_mm);
> > +
> >  	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, zap_flags);
> > +
> > +	mmu_notifier_invalidate_range_end(&range);
> >  	tlb_finish_mmu(&tlb);
> >  }
> >  
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index c7105ec6d08c..9d2625b8029a 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -772,7 +772,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
> >   * Application no longer needs these pages.  If the pages are dirty,
> >   * it's OK to just throw them away.  The app will be more careful about
> >   * data it wants to keep.  Be sure to free swap resources too.  The
> > - * zap_page_range call sets things up for shrink_active_list to actually free
> > + * zap_vma_range call sets things up for shrink_active_list to actually free
> >   * these pages later if no one else has touched them in the meantime,
> >   * although we could add these pages to a global reuse list for
> >   * shrink_active_list to pick up before reclaiming other pages.
> > @@ -790,7 +790,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
> >  static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
> >  					unsigned long start, unsigned long end)
> >  {
> > -	zap_page_range(vma, start, end - start);
> > +	zap_vma_range(vma, start, end - start);
> 
> I'd rather just call zap_page_range_single() directly with NULL passed
> over, considering that this is for stable, but no strong opinions.

As mentioned in reply to Nadav, if we expose zap_page_range_single we
need to expose 'struct zap_details'.  Any concerns there?  That was the
primary reason I did not just call zap_page_range_single directly.
-- 
Mike Kravetz
