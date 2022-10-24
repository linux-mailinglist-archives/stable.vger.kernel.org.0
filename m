Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224CA60BEBB
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 01:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJXXjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 19:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiJXXj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 19:39:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B190D2F3E53;
        Mon, 24 Oct 2022 14:58:33 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OKpD07010282;
        Mon, 24 Oct 2022 21:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=I75nGouLWpzndbtSO+oe5SHKpbpDtNTHazhDdIbKQvc=;
 b=T67ke40hMwxXjUSOnVS5NTHnj1HBHTIFNSVOeCyzYApBFHWMFdFugDi4h5lPOT69Y8dU
 5qi5BrZOwHoJylEPgB0vJjDQ+O6+HElbhyqoxPWTNXbQkLObMmLIWn1iMb829navGUUj
 d0Dt/WqICkHugAu14cn8OJZRfYylUfiRPLDoJWt2ywzpOqrRHnlFBTvMJLDz3UgxXZ9m
 2vrYFrBkEbM4ZeM0U9K1+KGrv6SAUIBe6jprp2DZy5CiLnXDvNJxziV6590iFoRtE4Fn
 ZJHmpLzORKTLmggmx7WkW2e9P298U5kvtD2edAHRqYPmcDsFwNEm2W0n+9Jc2kXynR8r Ww== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2wt1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 21:55:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29OLbH4q012770;
        Mon, 24 Oct 2022 21:55:33 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y416ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 21:55:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/o01NUoI9wbzpWRCHIenZE/9a78xCNIJ+0hkSXJOZzLsg3lb7/Q8aEfojPE/kOM1B+DBROoT/PIcx5n77IIz9xDEfrPqKFd999pbz6+KPrjAliqWQ0KAF13YDrRIoRVyZvTyinHOBIGZPOWF/8CoRB6iPoB2ZSpTyTXhQ42TP9J3f5bnWgd+KS0ErllT3AQ3I0AZPCMgWVVi02bFzsqc2asGuOdfZ/GJ0TN3qXHkxcIpfTdAbkC2sLnAcO9vccWfxE0rR/7/JuB9ZmfbIIWLAKpM+m9tO9xoKSLDrr3dQwWwRNJ0AQGiC3f7Pj5nhuYu/Ns86CJuGLzoLSuXwW4ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I75nGouLWpzndbtSO+oe5SHKpbpDtNTHazhDdIbKQvc=;
 b=iiNLgDqzO9dYevScjTcQLrwKdNSnzsgRWGLbYj2NS2EWrfo3hMQq/nQhNjF13tXKHU0aoD3XCkebuwvqQV+TquZZ8NDxMvFy7QE+G5OSJOu2cheUOBZGpACjnfgSYemr27lJhw48/HpVX4S2cav/qsW2y6df+dCEbk48eFMEuo4iP6i6zUnCrJ4JHE9wwtRC7AjVvHp0jT4Q8YfmwSw0KY8yksSTcNdmvltokMqh0qUWNPfnbzmY1fIpdvI2XX1NRJZpHg3FuPkNTDZfkn3Y+wDhHrERhY/G4hliRrhYtlZltpkOh7Oxc28NVeUTZb19Mk+mJTMwLbAbPA3T1VKi1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I75nGouLWpzndbtSO+oe5SHKpbpDtNTHazhDdIbKQvc=;
 b=laX7nkQQdvicXKanFtYXJdv0Xy6C5s1OgC2fEI6+WnQhI3R2/4E3Bys2bi+kh6UHrRJi3SxqkcsajlhEH2Iik3e+nADQzAMv48zzwO6rD8Wuh9PAzI5egsMb7c/eGBVEx8wwpXLAlLzmC6h8ZhVsEcmTBUi7xzck7KyNruiA9/k=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by PH7PR10MB6652.namprd10.prod.outlook.com (2603:10b6:510:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Mon, 24 Oct
 2022 21:55:30 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%5]) with mapi id 15.20.5746.026; Mon, 24 Oct 2022
 21:55:30 +0000
Date:   Mon, 24 Oct 2022 14:55:27 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
Message-ID: <Y1cJz6i5YMNfSeAm@monkey>
References: <20221023025047.470646-1-mike.kravetz@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221023025047.470646-1-mike.kravetz@oracle.com>
X-ClientProxiedBy: MW4PR03CA0037.namprd03.prod.outlook.com
 (2603:10b6:303:8e::12) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|PH7PR10MB6652:EE_
X-MS-Office365-Filtering-Correlation-Id: 292a4c87-daf2-4cc0-00ea-08dab60a77ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z9nqmV2woe0xCyQE61szEA+GlHIRT3aU2AoQ25HanbjKF2WrmUvDSXuHxhtJmLK9CpBEwC3jjBXiQLZ4g4TA9i+t8q2wYef7eSvVGjbRoZyIN6OGGJBDlEhGwrV/MPiVvUSuY9dxyB2PJqlZ3UCPfpd4VHrkNIHrJkgr2X7iwMwH3SGVx5avvjJ+JZiA6UHsW8EuEACU6KDO4nFRtLP4o6IPuGvAS/PjgQX+AtqWelt81XKftRqX/u92serOy1or4oWB6mA1LLTb0sbcm7yADZNgz85HUMv5Lnu4q2EAiFGd8vNigevkX0IsuI9zcY2Rvqa/e0FDv263rDkDvGNBnLrGmHxm6d5w7fZt2CXEP5wadZ+eaWdP9cizAZWE+QLpePjAUQ8DznmDxZ3E2xxq7ymtVy8Rwe6aeIpi4v0Gctt2DvDxUERKdn2czOK1T2xYJLlM+rdkNu9SeJI35udq7W3La8nBv4KRRlhJBZ3zevD3iNCMUIl00IxKL/VHBYUO5kNmQ3rnMA+31r5URkg1VmWkUXCu7xoCbtzDNYZGcrkZpVLiy+6ima03JINCHXwFWRIAhUWSmCa/ylW2m4p7KtNR+n1rJau6k626NatZfDH2Yf7+7MKfbgVookVXlDrMMrrVSpdbSIM7AMs6NyuGUzTxO4+xKrpAKQxeMf/Hk50QtbmW9hVX6V18wjm9mAjJcLJLK/DVLu3Z2WWAJWnrpGXj0aSCyw9uJI+SmWUs3JQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199015)(66476007)(66556008)(6506007)(4326008)(8676002)(66946007)(33716001)(6666004)(7416002)(6512007)(26005)(41300700001)(9686003)(5660300002)(53546011)(8936002)(54906003)(2906002)(316002)(86362001)(83380400001)(38100700002)(44832011)(186003)(966005)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ShRYfgJUWxxHRuoM0nxGIVHXpns36+pFRUAI65GmNPqbu+eUwmi2BaAtr5ZH?=
 =?us-ascii?Q?XFzp1+5IiXabiw5NZmpjF3Y3fcbWQ72vJYVEhWANVu2IR6P2whVvlEaRCEwe?=
 =?us-ascii?Q?JlJK+K+yTeJgehVqJYc5eh8N2W1+N6hFh75PwFyP//CNJYSIkSc65VOmtsqM?=
 =?us-ascii?Q?uih3dklADgYkDhEzmPIOqZj56l5SKjV+FQWrbX22jgESxIhWgsqr9TAHE1Cn?=
 =?us-ascii?Q?VIZ9rdBRSL8uANTVkDeYG+gy4twCRK5JV0RE7m6mA9PavvVgubCvhRI1eCv7?=
 =?us-ascii?Q?NMuaaDNAhJkbpMskDmCljgeHr/icvo5yt9CT7WC02rBbjaQb5hUVjqXVQSzT?=
 =?us-ascii?Q?aH+jXWxqXtSte4WpvzhpF7/F6v2YshZtOJxoD9ud4nuQQEQEZZjBil+uLWQm?=
 =?us-ascii?Q?W5QSnerWXGsyCmMkxkJNgHZ8QRvEXJujlvjhzgS2WCgNNvs/8LxJ19SZjJu/?=
 =?us-ascii?Q?xjaXC6x7kuABJXsnDFwFcNImzqGfN4R8hZtV27VcKp7GGTNgpy0J6WJQxDRW?=
 =?us-ascii?Q?upLYarOVNBwkAeA4D8kF9qto3cKbnEQo143ABo9Dp3DaiYP2ZDNLkIGu4Z+k?=
 =?us-ascii?Q?+aaunxE4otLA1wAU6Zh1mqCcb9HL+NHM/gJxMABNMeOh9DncC7FaV8MNwYgV?=
 =?us-ascii?Q?pgnf0cN3GkAh8pUAZMwuUwcSHNwGnBf8QPeu18dmrXsUNi6DsnmdoDGEF5Yh?=
 =?us-ascii?Q?iBZSBCMcOB6vCySF8sd0YbrkLenofx4fxA/2CozF8SzGz+D+emIdBdb1XiMB?=
 =?us-ascii?Q?V6HxcX89OvJ5lO+3Jbad+5nyPmdJaRD/hbUN/67EipY0PO3uw4vV0T/tSIp7?=
 =?us-ascii?Q?lzclqOKOxIytpJDpkGGjNaHIKH34T1E0As1On6kcsGDMw2mFRQLuIGkHp6wh?=
 =?us-ascii?Q?i4dskMz8qaGDZOGDc3LrUV3OY0quZt7RQwVAiO2sV1mZ/I9anISZsSrKlOrz?=
 =?us-ascii?Q?8QstvmofPpiD+odg53gS/QA8A+8TjYgdrlzf7XlxDWX/vi0ubdpWxzGv1aJ+?=
 =?us-ascii?Q?ylNNV8Veht/jbMBHARptfJ4tw1eaUHxR+TKHuHIJjMMa4yYIPvguY7PIsr8t?=
 =?us-ascii?Q?79kwBFfGOjZOgmoJ7CYwDXWxYD7w0Ug5+Rq2UhpCwox3Bg+uLt2F4TRC5Yu6?=
 =?us-ascii?Q?KEIJXjHmf5VK7zpwM7+TR5msLg3tAkLTWpsMZYqKKlSfGs9chxY+E+xJkTdC?=
 =?us-ascii?Q?R1bzhQ+w3wV77xxI/PvLigWvHgSubN3KOCHNWnYfz6vgm/vkiibFj1rjY+U4?=
 =?us-ascii?Q?P2lnk7itvlLDI+uLgvJMbUNAzhUhNW6qmryb24cicoDf12DSw015k2nBXFSZ?=
 =?us-ascii?Q?3bFLX3nyb4jd13iso5EmCcHLNbUykfQZ8cJMwOkvqjt57Xa5p55R3d4O3oWO?=
 =?us-ascii?Q?ggjpA2z234mBbM+vahdgGTOZCb0vcoP5+cBR9L0GdPkGJweusXFH+ozE5EM5?=
 =?us-ascii?Q?Mz45FWMpPdPcmOAWGCP5w8yP8MVnTTin8YqVd6EbIXvhn1ujXo5/G98g6kH6?=
 =?us-ascii?Q?7vYWMEjyN3LPLp/HWu1P2vrH4Cs2fsmbIVahx7CWfq+vA2i/FzP4sCSTyGM9?=
 =?us-ascii?Q?yPvfL7znhmQITNiJ8ibleRC9GWZlE8bdDCrLARCRuX/Eji/kn8As2ykPOW5t?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 292a4c87-daf2-4cc0-00ea-08dab60a77ef
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 21:55:30.6926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ePuJkS3IEx7Zni+VU07HA47PSzOvvQ04C4eZqoGAAlxcv4QEYVhhpTtq/ixRgNC/HGL8y5kZwXFjXQ+6Eu4ZQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_07,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=739 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240131
X-Proofpoint-GUID: l_YoxmKm-Bu4kgo4Ywe88O45d5dxRjGL
X-Proofpoint-ORIG-GUID: l_YoxmKm-Bu4kgo4Ywe88O45d5dxRjGL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/22/22 19:50, Mike Kravetz wrote:
> madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear the
> page tables associated with the address range.  For hugetlb vmas,
> zap_page_range will call __unmap_hugepage_range_final.  However,
> __unmap_hugepage_range_final assumes the passed vma is about to be
> removed and deletes the vma_lock to prevent pmd sharing as the vma is
> on the way out.  In the case of madvise(MADV_DONTNEED) the vma remains,
> but the missing vma_lock prevents pmd sharing and could potentially
> lead to issues with truncation/fault races.
> 
> This issue was originally reported here [1] as a BUG triggered in
> page_try_dup_anon_rmap.  Prior to the introduction of the hugetlb
> vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag to
> prevent pmd sharing.  Subsequent faults on this vma were confused as
> VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping
> was not set in new pages added to the page table.  This resulted in
> pages that appeared anonymous in a VM_SHARED vma and triggered the BUG.
> 
> Create a new routine clear_hugetlb_page_range() that can be called from
> madvise(MADV_DONTNEED) for hugetlb vmas.  It has the same setup as
> zap_page_range, but does not delete the vma_lock.

After seeing a syzbot use after free report [2] that is also addressed by
this patch, I started thinking ... 

When __unmap_hugepage_range_final was created, the only time unmap_single_vma
was called for hugetlb vmas was during process exit time via exit_mmap.  I got
in trouble when I added a call via madvise(MADV_DONTNEED) which calls
zap_page_range.  This patch takes care of that calling path by having
madvise(MADV_DONTNEED) call a new routine clear_hugetlb_page_range instead of
zap_page_range for hugetlb vmas.  The use after free bug had me auditing code
paths to make sure __unmap_hugepage_range_final was REALLY only called at
process exit time.  If not, and we could fault on a vma after calling
__unmap_hugepage_range_final we would be in trouble.

My thought was, what if we had __unmap_hugepage_range_final check mm->mm_users
to determine if it was being called in the process exit path?  If !mm_users,
then we can delete the vma_lock to prevent pmd sharing as we know the process
is exiting.  If not, we do not delete the lock.  That seems to be more robust
and would prevent issues if someone accidentally introduces a new code path
where __unmap_hugepage_range_final (unmap_single_vma for a hugetlb vma)
could be called outside process exit context.

Thoughts?

[2] https://lore.kernel.org/linux-mm/000000000000d5e00a05e834962e@google.com/
-- 
Mike Kravetz
