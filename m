Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E17260BFF1
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 02:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiJYAoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 20:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiJYAn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 20:43:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3B814138B;
        Mon, 24 Oct 2022 16:16:54 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OKTuTC021680;
        Mon, 24 Oct 2022 23:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=RUFUoQQTQZeXUIcbKhBYWPkrkMyKUPIQ7codJL9dFt8=;
 b=WIQvTCiuuZN7ostCt8VFJw0FOMsoQdmgIXGjMcWf8uF2rVDeiN7alZ3kumE9Voi5puuB
 IYs+7ZkpNRG8ZcT5SrnemFQ8R08OfSkJVYT0A9/IqgU4bsR8iZNYPjq24iIOt2Eygrmk
 ywyhv98cEEWPYu8r70DZkz14D5Kcy8e8RdtmVmYNVczbIPJtWSN0uHYR5kc75re62tFP
 OMVSM52hzwLnJDqH6cSZk3fw/Q5ivbtQW7QP7ZBCNTdreFf+Kdll2elxG9YGs4lmr4RU
 ZL3ctpkdrpX34hfUZBi9Y7DJARjLZCDBq8esZ5A1wa8EG8A7IRNngfkb0AwTnJLT5Fej vg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc9396vpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 23:14:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29OM9J4k039912;
        Mon, 24 Oct 2022 23:14:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6ya3khn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 23:14:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YlSfrgXt7Qo6E5Ey5nsOLKeDREXOVUZ3gGUaBxcfn3bphQyiDfWtjm4l2AYeHuYgTFRSJAeEtjAGdpwFSkX/fLiulhuifvBdT1OGg5mG0BcKDKtqann5G8jOzyeDPSAiOezRuSlvHmHKUsAvb5YQ0jHPh558Ztwxv5J0jX3DnDtzZutjA3EeSwSpcnyMXjXbnCVkyAs2zXt/4qTuYnNsaO5sLSPRpKbFv8HmhSfXfoPG9gtTDAMw8U+uhzGRpW2C3SyFTxcNgGHwOqHwYYtOsybPqDyVVkghG+FtxPC2NcOywgPpOVSNDu5zUxFuUi2p9m7X50z+bOePK5LZX43nzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUFUoQQTQZeXUIcbKhBYWPkrkMyKUPIQ7codJL9dFt8=;
 b=MzEc86VV2zw8lw+bb4AcqjnRU+t+T9eFrCqTW+v0he3OedrfI7SMMBDe35cE73ISXiKWlWGbI8X3hWVt1KyLuqntJG4tG5LSP7SU6dg7Lk13GuoGWT9EQ7NWQL0LIvuKzIahsRTuItX8N0qllCmeJXy9QotG7YDffNTYnuocf+fZVPLuRIChsSNC2nMk4n0Hz1tIpXdPTPYB/MWPCRwm20a+wdOFepmsE0CASRjWaLtb7ujSSCzKKpGlL9AGhONHm7ChawVZD+mgy2R9Jn8SR97CCwHVXkMkl+8/Yz3skMf4gICwBzs6GpdTm88unVH5cLLxe40IYSoz1CJitIu6Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUFUoQQTQZeXUIcbKhBYWPkrkMyKUPIQ7codJL9dFt8=;
 b=x1iV0qV0FN7lokOOTRyUNB4V1wy59NmjZ0WcXkPn6izdT8tzK4CZuH6O8wZ+hAJTaD/HbBy/T625rUbS7P8g90Q1cw3wcjMO/DJEjD9ePRMvuk8nez5/RWmZdS0jmMaeJcTutKqUb/qF6ojeAcgVMtgaFoyCvM42V+EvF6U4uRQ=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB6328.namprd10.prod.outlook.com (2603:10b6:a03:44e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 23:14:26 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%5]) with mapi id 15.20.5746.026; Mon, 24 Oct 2022
 23:14:26 +0000
Date:   Mon, 24 Oct 2022 16:14:23 -0700
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
Message-ID: <Y1ccT8Q9ESmR3+X9@monkey>
References: <20221023025047.470646-1-mike.kravetz@oracle.com>
 <Y1cJz6i5YMNfSeAm@monkey>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1cJz6i5YMNfSeAm@monkey>
X-ClientProxiedBy: MW4PR03CA0104.namprd03.prod.outlook.com
 (2603:10b6:303:b7::19) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SJ0PR10MB6328:EE_
X-MS-Office365-Filtering-Correlation-Id: f53e8247-7c53-4754-b50d-08dab6157ebd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V6Vson3kjznmZGiK9VVAnfkRZsX5gyVZUIe+H4ajrtBPghFMMSHKTfbcQ5Rp+2pbeNxuAmyi5r3pYqAxPOPLAUHI6tw2w9uVQh++CgDHau4uSKR4YIhDHwcWCUBoNhpWfnunKVswjxFOh3r3z9orf0FcXBTtltub3Pbf89OTIgl2s3zcUEhlhnpqh3CUXbzVryKnlnAh0KSBIhSVzPRqZX/UoEwsRHtYpyJwDxyKh3PFS5X77IG781ZCNxMIKPm/SzpTnJEVfILehJibNUVKBrMRqY7eTCW/XpWDgiikTWIL3Bg5zA+acG7b/zoTi384cS9/72Rbcmix94OVWwGhPWxNXr3O8SvoWVtQCjXAeWzQPbCucGWnHjoSVzhK6v2/KKyjNISWxAXNkLT1cedTfQg5a2CGR3udrlyOLbA8UJT/YjKNSKixj8x2NYTkVdNenv01KJOQ24hgCDUJHN6bMTggHMa2VccPbZ+N96zIzeIyA92pzaKwh5OnZDsV5OdAxWPbHqZdczhSwTSsP57JHdHCZ1TOrpHj4FV9rr9QCJrod6ij89xueOmHhr4lfmNuUGHji+oh8Mrtex2FvKnlLbdGx/nQ2+7AqEeubp5LwhanqW4zetBkYR7kzxN0hXYqY489J34ZFJT/mWsbels2zfPaQKlbovziyi4YVw/b5Azi/RJ2rJE2ZExKbLLU/uVolzlrKJwxFmKjbftoz6NIM7586xz/vdQoepXZiLIiCHvLGO7fGdivGpicZS08SUt0dr7wC8nOU5XI92TVYdp4r4+4QicGwRZnxUfhJSmTnF1NL/8OnKipL3oq0iKOSBBOk0zJmC7IgooB5hybkwnSjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(396003)(366004)(136003)(376002)(39860400002)(451199015)(9686003)(6506007)(86362001)(44832011)(6512007)(2906002)(38100700002)(83380400001)(66946007)(6666004)(6486002)(53546011)(26005)(66556008)(316002)(186003)(4326008)(8676002)(66476007)(5660300002)(54906003)(33716001)(7416002)(8936002)(41300700001)(966005)(478600001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qabp5TTW9bAQECvJ+ygrzZYrLI6HnBFJwj8YubDZF5+b+oh2AaWXHBxgN6Xx?=
 =?us-ascii?Q?L8RuQt8j5N2+y6MaXL7VZLBHtkaNZFUSPX+53UVrHnmkeSHUAKsh5nPKFT2i?=
 =?us-ascii?Q?KqtRW1KeMjsnhjYUY1lk3WNNyKWpVNA+7mooQsMPmcsasiN005udz1Sp94mW?=
 =?us-ascii?Q?ElBHI7trzxqVtJgfixyEMt7oS4gUivCd124WihVAn3TKGkj9Il5aYOM1zhME?=
 =?us-ascii?Q?xrpvMyUZkNNZ4Af1oAIKtKFAA/N8d3JtCHXSHiIP8OElq/0U/LuFQqCQ1UlI?=
 =?us-ascii?Q?ZHA1m5fwg/RQwDnBtu97ARsye2rxtE4L9ublrtqT6oHdqW2udTlGEB8Y3p66?=
 =?us-ascii?Q?Q7REeYNa6ulea2+Snp6bn3yQkxzvon93xsqJT/Ag/s8Cshx7OtK7dN7GNYnu?=
 =?us-ascii?Q?rsmBKJ8QEZxH7IukDIt970QHrmVe+PDmXso8u03/jlJgXXooNVHX2nqua1Aw?=
 =?us-ascii?Q?nh5cKYWkckvA+6L7a/OdRw7OTze3auJU9m05poZK1LZIyjbWy/YDg8uyXg2D?=
 =?us-ascii?Q?lhMwxGM8N5DiwxMl0MZVASnygRzQZO+2H9B99jiENcwhj8jG1JssqVqh9mE3?=
 =?us-ascii?Q?I4QjOE02rp9c2BthJlTsz4KPZjV2sOu1g7j2kF/Ly42JPbvUCwYshwUWVZp0?=
 =?us-ascii?Q?mm+ztGvxPfO/Usgpto9BoQd9q3OvJ00CurjhbMafL7tBdl2+ptBYrKKoZUN/?=
 =?us-ascii?Q?PiDQvJBX6AHbkWHQINR7ccXR1tKOvZozg6seXJMa7fkqiooeYTwoSR/9EbyG?=
 =?us-ascii?Q?8vddGfsaior9oHfWH8MQNItRqmyPhWQBoiP6ipHK1qYY8XmhMNaclHFDZL7x?=
 =?us-ascii?Q?gAgaN6YDls6Q2YkCed8F/596pfEURssL6xrG+LGbuxpyk6Iv0fJZvhEEii9f?=
 =?us-ascii?Q?uAN0MjPOMOo0HZh0n5y1ww50kTNciYjF+7jfd91b0II0pqu/MmLiy0Q6XZsG?=
 =?us-ascii?Q?YqrYkxLdkZMIPMw2OrdHf+TU03vNZoG15j8ftRrrN+Zfo9rT0Sxo4i2hvKZC?=
 =?us-ascii?Q?SZry4t7JNBJb8KlUFDXTk5vpEOmbHH7vbgBbl5Buzyn78qiI+w9sLBaNpFD/?=
 =?us-ascii?Q?JWhBaLQwEgk5GvtXLTYD05lpaxvo/M3PQEsEp0O8SC3rC+kX7tRf/tq8GZ8A?=
 =?us-ascii?Q?SFlZ0hbuAC4OIFeMmnZDUv+vm4hncpKRPOCzxrs9VOr7MNj3MP2gfj9/qB4d?=
 =?us-ascii?Q?mG1IVakvb25P4Fy2bY70hs/CTz8+3MP1A1bRJRFbHWvHKJNPDMNvyow6QwnT?=
 =?us-ascii?Q?Gl8kpzynXPwDnNx+23bRS5PPghP1NNlC5FoldcreGOxanHsNrKlUHvxtyyT/?=
 =?us-ascii?Q?1yYllh0Q1/oovZAUEyVCxH2gWMM6z7wJZvCXTB+PsPF6/9K0hFxFAQQccOVh?=
 =?us-ascii?Q?/3J9k+jPqzTT71FOi/MCKEjM8xPqCw09LhaYQ64fJ8XwXOZV1VZMKpjHc4SG?=
 =?us-ascii?Q?bpMYYLbglGhjFOFrNPesged2ud2GFQMvCkUOp5k62J/utTkY5AGFVZ8PopQ/?=
 =?us-ascii?Q?iuAkbM+8rWTJSypUpUyAJlIN8KKLx6hkTAUDp4bq0b6JEtjWSOqR+lY/TOQG?=
 =?us-ascii?Q?OzeDVhTyyu3mF8Dwc7Uh67hWQyIgdL+a5fm/hXgB6rSkOe4TxWlgVNnVxJ13?=
 =?us-ascii?Q?gQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f53e8247-7c53-4754-b50d-08dab6157ebd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 23:14:26.5765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cEPR7J3usxEsy/cY1MYcIyJ0Lse1pNbvShOc5yBXs5rZSkJOksXi0t9hini9f8/ieRE5wC1+Ux/Kqb4yQgw4Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6328
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_07,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=957 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240139
X-Proofpoint-GUID: OQLcoo22KdsKwzastAiIsVYfed5xsCCw
X-Proofpoint-ORIG-GUID: OQLcoo22KdsKwzastAiIsVYfed5xsCCw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/24/22 14:55, Mike Kravetz wrote:
> On 10/22/22 19:50, Mike Kravetz wrote:
> > madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear the
> > page tables associated with the address range.  For hugetlb vmas,
> > zap_page_range will call __unmap_hugepage_range_final.  However,
> > __unmap_hugepage_range_final assumes the passed vma is about to be
> > removed and deletes the vma_lock to prevent pmd sharing as the vma is
> > on the way out.  In the case of madvise(MADV_DONTNEED) the vma remains,
> > but the missing vma_lock prevents pmd sharing and could potentially
> > lead to issues with truncation/fault races.
> > 
> > This issue was originally reported here [1] as a BUG triggered in
> > page_try_dup_anon_rmap.  Prior to the introduction of the hugetlb
> > vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag to
> > prevent pmd sharing.  Subsequent faults on this vma were confused as
> > VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping
> > was not set in new pages added to the page table.  This resulted in
> > pages that appeared anonymous in a VM_SHARED vma and triggered the BUG.
> > 
> > Create a new routine clear_hugetlb_page_range() that can be called from
> > madvise(MADV_DONTNEED) for hugetlb vmas.  It has the same setup as
> > zap_page_range, but does not delete the vma_lock.
> 
> After seeing a syzbot use after free report [2] that is also addressed by
> this patch, I started thinking ... 
> 
> When __unmap_hugepage_range_final was created, the only time unmap_single_vma
> was called for hugetlb vmas was during process exit time via exit_mmap.  I got
> in trouble when I added a call via madvise(MADV_DONTNEED) which calls
> zap_page_range.  This patch takes care of that calling path by having
> madvise(MADV_DONTNEED) call a new routine clear_hugetlb_page_range instead of
> zap_page_range for hugetlb vmas.  The use after free bug had me auditing code
> paths to make sure __unmap_hugepage_range_final was REALLY only called at
> process exit time.  If not, and we could fault on a vma after calling
> __unmap_hugepage_range_final we would be in trouble.
> 
> My thought was, what if we had __unmap_hugepage_range_final check mm->mm_users
> to determine if it was being called in the process exit path?  If !mm_users,
> then we can delete the vma_lock to prevent pmd sharing as we know the process
> is exiting.  If not, we do not delete the lock.  That seems to be more robust
> and would prevent issues if someone accidentally introduces a new code path
> where __unmap_hugepage_range_final (unmap_single_vma for a hugetlb vma)
> could be called outside process exit context.
> 
> Thoughts?
> 
> [2] https://lore.kernel.org/linux-mm/000000000000d5e00a05e834962e@google.com/

Sorry if this seems like I am talking to myself.  Here is a proposed v3 as
described above.

From 1466fd43e180ede3f6479d1dca4e7f350f86f80b Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Mon, 24 Oct 2022 15:40:05 -0700
Subject: [PATCH v3] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED
 processing

When hugetlb madvise(MADV_DONTNEED) support was added, the existing
code to call zap_page_range() to clear the page tables associated
with the address range was not modified.  However, for hugetlb vmas
zap_page_range will call __unmap_hugepage_range_final. This routine
assumes the passed hugetlb vma is about to be removed and deletes
the vma_lock to prevent pmd sharing as the vma is on the way out.  In
the case of madvise(MADV_DONTNEED) the vma remains, but the missing
vma_lock prevents pmd sharing and could potentially lead to issues
with truncation/fault races.

This issue was originally reported here [1] as a BUG triggered in
page_try_dup_anon_rmap.  Prior to the introduction of the hugetlb
vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag
to prevent pmd sharing.  Subsequent faults on this vma were confused
as VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping
was not set in new pages added to the page table.  This resulted in
pages that appeared anonymous in a VM_SHARED vma and triggered the BUG.

__unmap_hugepage_range_final was originally designed only to be called
in the context of process exit (exit_mmap).  It is now called in the
context of madvise(MADV_DONTNEED).  Restructure the routine and check
for !mm_users which indicates it is being called in the context of
process exit.  If being called in process exit context, delete the
vma_lock.  Otherwise, just unmap and leave the lock.  Since the routine
is called in more than just process exit context, rename to eliminate
'final' as __unmap_hugetlb_page_range.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/

Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Reported-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
---
v3 - Check for !mm_users in __unmap_hugepage_range_final instead of
     creating a separate function.

 include/linux/hugetlb.h |  4 ++--
 mm/hugetlb.c            | 30 ++++++++++++++++++++----------
 mm/memory.c             |  2 +-
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index a899bc76d677..bc19a1f6ca10 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -158,7 +158,7 @@ long follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
 void unmap_hugepage_range(struct vm_area_struct *,
 			  unsigned long, unsigned long, struct page *,
 			  zap_flags_t);
-void __unmap_hugepage_range_final(struct mmu_gather *tlb,
+void __unmap_hugetlb_page_range(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma,
 			  unsigned long start, unsigned long end,
 			  struct page *ref_page, zap_flags_t zap_flags);
@@ -418,7 +418,7 @@ static inline unsigned long hugetlb_change_protection(
 	return 0;
 }
 
-static inline void __unmap_hugepage_range_final(struct mmu_gather *tlb,
+static inline void __unmap_hugetlb_page_range(struct mmu_gather *tlb,
 			struct vm_area_struct *vma, unsigned long start,
 			unsigned long end, struct page *ref_page,
 			zap_flags_t zap_flags)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 931789a8f734..3fe1152c3c20 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5202,27 +5202,37 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 		tlb_flush_mmu_tlbonly(tlb);
 }
 
-void __unmap_hugepage_range_final(struct mmu_gather *tlb,
+void __unmap_hugetlb_page_range(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page,
 			  zap_flags_t zap_flags)
 {
+	struct mm_struct *mm = vma->vm_mm;
+
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
 	/*
-	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
-	 * the vma_lock is freed, this makes the vma ineligible for pmd
-	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
-	 * This is important as page tables for this unmapped range will
-	 * be asynchrously deleted.  If the page tables are shared, there
-	 * will be issues when accessed by someone else.
+	 * Free the vma_lock here if process exiting
 	 */
-	__hugetlb_vma_unlock_write_free(vma);
-
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
+	if (!atomic_read(&mm->mm_users)) {
+		/*
+		 * Unlock and free the vma lock before releasing i_mmap_rwsem.
+		 * When the vma_lock is freed, this makes the vma ineligible
+		 * for pmd sharing.  And, i_mmap_rwsem is required to set up
+		 * pmd sharing.  This is important as page tables for this
+		 * unmapped range will be asynchrously deleted.  If the page
+		 * tables are shared, there will be issues when accessed by
+		 * someone else.
+		 */
+		__hugetlb_vma_unlock_write_free(vma);
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+	} else {
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+		hugetlb_vma_unlock_write(vma);
+	}
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
diff --git a/mm/memory.c b/mm/memory.c
index 8e72f703ed99..1de8ea504047 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1687,7 +1687,7 @@ static void unmap_single_vma(struct mmu_gather *tlb,
 			if (vma->vm_file) {
 				zap_flags_t zap_flags = details ?
 				    details->zap_flags : 0;
-				__unmap_hugepage_range_final(tlb, vma, start, end,
+				__unmap_hugetlb_page_range(tlb, vma, start, end,
 							     NULL, zap_flags);
 			}
 		} else
-- 
2.37.3

