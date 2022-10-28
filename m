Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F083B6115CC
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 17:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJ1P02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 11:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiJ1P0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 11:26:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBEC5019E;
        Fri, 28 Oct 2022 08:26:03 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SEiEai031725;
        Fri, 28 Oct 2022 15:23:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=jptW4H73YAta3clzUE6xLYV1PLE8QUv2nO0jr4oxgo8=;
 b=dMnlW0K5vkX5wv84SDGmWimSRxeL5pWzZwh3kliumMhP1c5y9ejp5FClVqPOspU/ZqtO
 y+9RBoKcoxs0nPNXKZErYXsG4VC4xbO5ofJdvsN6KsVoDA2082dVMVQnVZFjnS6d8H5q
 7NlMuxqIHKTqjJB4RvgrhaHDK2H6uZGgPEjUt1ywrgDQ5+iVcYPVL7HYV7roIKKPCGF8
 SWm7wEQXxoM2UE/Ll4CSf5bpvRTWHOST9AKiEoGeIurJa/RNx4/XEpMxqomXoN+43V1h
 lT+OzzESAyIMhI/MwmsfqRtICtGL1McqvUp4aN5RUj5Hz2UXtswHcU+ysPKHtzgb89h5 hg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfagv5f5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 15:23:38 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SEUJ1a017431;
        Fri, 28 Oct 2022 15:23:37 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaghp0hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 15:23:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGTEC1MWO7RXhrRp5GOo5nc/6umpwwKELqkkg2jjrozCVRm2g6VM8UaC5VGwVjV6bszNHF9RnLASu5Y7QL9OzmVX/LGUwLZhyg8Cdf3b2rTrctcxu9q09IVNpseW6HmuRIXLEAoK1NJ8YXQfY5j+i9T+9Z+8FPWvWMB6j13PTfXY+D5DbOLT08pkj57COvQeZvvqfv3Se5i8bolWgXim74uRo303XUDWtkXHp26SbSxwdFusL0JuY7nqe3BYSQ8XYgWDEDEqBegX0/UCa8j9eFIZQIhc4M+CHUiPeZldtSClMVnKbg8NVsU6kw6RDHItYo7mo4qh/pPvVzjYcfTXmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jptW4H73YAta3clzUE6xLYV1PLE8QUv2nO0jr4oxgo8=;
 b=B1DmW6NMro5d0owifn6fSvwGpCJdwVQxpNHqlUiR5crlH9Wnc0wcwIkjUcwcAhZ+sLCr8pQpG+/TaWMglMqAhlY7d90Y7JomRbK5HstPBOlxqH82P1kOmqfeLnA008xQ8H0oR69sl6D4cdidZaIG+M9tbNMWc0sS5jxr+GSioQSJtfq3MHRcfLBuLNk7SISwiPkAlygyrjkC+UCsAgB9DWPwLB7ergAogg1fJwsEgLniwdr76BvtCnmBHQuZPfkCEf33zPCr9M8qDj1Gdk2haMWJELEr8NdMLIphSiTDzkR8+7CbLvFOkVM8XRtTN2u5sEkkcJtXLT2WOvgWWiZXtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jptW4H73YAta3clzUE6xLYV1PLE8QUv2nO0jr4oxgo8=;
 b=W9GHdroUWWfFMChNreGDhwwoVQQ2nWiT4vBHBt9rtrv8aOi6JXeWoflUI6DCt1Nu2JG8dXnL8zHS8R1pP0A/7Ee00iJa3pYzLw2aX4xyre7SqYMGNH0OG69+sLmogErYQMH1kThsBoWtcAAB1hEreQesdYWg1QTczuIhRH8A5Ss=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BY5PR10MB4276.namprd10.prod.outlook.com (2603:10b6:a03:201::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 15:23:34 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%6]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 15:23:34 +0000
Date:   Fri, 28 Oct 2022 08:23:25 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
Message-ID: <Y1vz7VvQ5zg5KTxk@monkey>
References: <20221023025047.470646-1-mike.kravetz@oracle.com>
 <Y1mpwKpwsiN6u6r7@x1n>
 <Y1nImUVseAOpXwPv@monkey>
 <Y1nbErXmHkyrzt8F@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1nbErXmHkyrzt8F@x1n>
X-ClientProxiedBy: MW4PR04CA0301.namprd04.prod.outlook.com
 (2603:10b6:303:82::6) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|BY5PR10MB4276:EE_
X-MS-Office365-Filtering-Correlation-Id: df6f0966-d97e-4cf2-f952-08dab8f86078
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hLF+Dccr3A5Mz5s3fsoHEdDh+6uP2PnMdsqr2pKsfyhn7vGt8Ji6G4HbfK3AnfA092LH/ulGKOMYOnQbv55yLTMKzeBBge5BPdRbdb+PEMJsxijYhYpWShoNKYfzh+iAWzPrWM9dVI+K0NCoLsJe0OR6OvL64usQlNli0JHWKo2qCcUgQxYdl2LAqCKT9Bb95479uNUUNXZ5tA/8ZAUv4LbeNmqy/VL2BGSsFnv5+HjnHBFbRq/i+gLyQ8WfRi6NA2UO0xxWR1UICW2wQor5YPEfzrT3eLnWk482SUwg2IeCofuqKQkcCsi+l8EVUcHxfWZ0NjX26QtIIVkcDi+MODNo3QEgQGQWT6tpL3uIgZefpsUeXpMTbxuBEmF3RzCQqZQArcAemMj6Ka4+PhY4Ht9yhvLpMM1eOH/3hZiRUdcBmIpmfmPpUAdF24GKjBLuKV2NbyjBLvdta0rlQHH+BW9HPc8eFStTWhK12aJ3dtTfdbT/djjS7V8uamTYWvafOGZV+/fmCjYoZnaDSxu4lRg53HNpWcm+yKezGdZY37TAmBB/KHHawVl0lJqXc1EvC4/zUFHAX7NdvvPYE8yuCj2XY4wNBmSl1fziUZ8r5KJPJ4qjY02T2uTfVJOQBPSCSHpmCZjG33lOFuBQwwZovY3skmmoUJ28Mt12W0iOR8A6TXm7DKe9mHjCvMPdVru98/ewGMObxl9cjYE9jj2Wqe3qpSypGptZsZzSw8PETkA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(346002)(366004)(396003)(39860400002)(376002)(451199015)(6666004)(316002)(54906003)(6916009)(8936002)(5660300002)(4326008)(186003)(7416002)(30864003)(8676002)(44832011)(53546011)(6506007)(66476007)(66946007)(66556008)(6512007)(9686003)(26005)(41300700001)(83380400001)(86362001)(38100700002)(2906002)(6486002)(966005)(33716001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ktMO3S1BdJ9BMRx2K6qUqlp3h6ov/hSV3kkuDL6zvbbDPqrH4TBsTJBqa8fr?=
 =?us-ascii?Q?v+CR63CUGYjoDrdpGQeDSl01QX4R17CKzfKA0l+dtXyv2FWvqGE0T8Ue3yCu?=
 =?us-ascii?Q?/MG9+HHgXX+1uWkBusiD+nxCzwFkL6TKbtjierjKyjKFIHcYWFaW57ZGSSML?=
 =?us-ascii?Q?iFz3GFlozaC8PMcJ/jy8bVdFDJJ9SNuDWJiR/dTeSXq8MjztQUqVPmo0y3BB?=
 =?us-ascii?Q?ndhnsTTbfKB7ZoB/0X+Ykdtcd5ie3e8mf31L9qpxr+L2zC1eKGFx4PtCvabu?=
 =?us-ascii?Q?KyOxj+ZwGEW0vgEclk3nbAWkM1WpKyCjo4l9u3iVQ17j44h59c8vj2Efy3ej?=
 =?us-ascii?Q?Rnv2qwraGfrDhvHbjMYSJlFYIZvY2F/Tu3HbnMwTWUeLhdlXAdujHE9tlQrQ?=
 =?us-ascii?Q?u56xtWORFRYTOOXjue7LUKCRE23bAAkY3+TKwoclZKJbjO/AZFAJomUxy6WX?=
 =?us-ascii?Q?ngvLBe6EqYnrGyLSb+1KpmIRXaXLez3NX/OQwVraAFWON0zQLP8nQeC/q0bs?=
 =?us-ascii?Q?3V8OLjzXcnsNThuhimNoAgHbwb2nW4xYxNZIU4NkIR+sB/b/roIhnOU6REO/?=
 =?us-ascii?Q?VZES3i4guozStS+dua2gObFnjFXMSSuYA3iSie0xQInfd1020hlgHn5kTv7D?=
 =?us-ascii?Q?+d5ae+NcKlaN5K+SXSkfmKsKe4VNHCSKHbEwZm7v7N4p5Z24MgMAn5h43HyY?=
 =?us-ascii?Q?SkE8PtzznHgVPbtgqrV+FKj53Pd1/LkJsmBWn/9/J1QacOU/cOQasqrbO9S+?=
 =?us-ascii?Q?X4sDeFr3r+AruhpwM1qYMDuxrqakXCKB8BPdNaFmYo2dFLC10DSw5DqkgvD2?=
 =?us-ascii?Q?ytcaHuHb3E16MPfJDBd2MnasOIp024Zg4rywsDck/UqzgdH0LQ+jpKMDnv7f?=
 =?us-ascii?Q?Z4rfA4VKYGW+xGeYwyh+Ck10xxJDadQkDCgFyBzsO8coP4IqNf7JCNRO0BLa?=
 =?us-ascii?Q?gKk9iZ9N9PIjhtfOaPxEyCWgSY117UbSu9y3T03rvqdSWekPSQLG68Ae+BEd?=
 =?us-ascii?Q?odJRGZdoqcHik02+Eh7LTakd8oi96fiFhJJMQMDKP0p8f/uoEbFK7ECYDKq7?=
 =?us-ascii?Q?+i5aSzk4Ys1nEI8hdu6jmYE0jsuNifOepteFJjY+PBrKA0+C0CVHHc1otv5R?=
 =?us-ascii?Q?bIE0szs0Zw88lE+l3QxDmcKA/13273eNQoKFmP5t5buw/WNf5YO99psQaWZ1?=
 =?us-ascii?Q?nsDyjmgQCndNwwq5fp07KysmFJShi/xX1aaHbeJCEsHB3eAp/qyRGETMjcdx?=
 =?us-ascii?Q?4uyMiL/gcNv00qnIcVv16ZYAc/JSdmt0wuwEnk73Y5db70Qby87iaQyPNJyl?=
 =?us-ascii?Q?0mIp+nGP/hU3XUYrjYK8KkqeZNCaWuBNZOxsvSfE6AXyoRj3h0X0aHM18ont?=
 =?us-ascii?Q?9GVJ4UIz53V4B85DmMT6pdJeXZ9UtXNqpY6gaLkXv0otPmfl9iCAAxJmTg4B?=
 =?us-ascii?Q?bfqHEULjw+aNx8QmMZlhKRAWoCofdk2WsO0xOsgPy5e+Dj5UiZbwy4lMz6ML?=
 =?us-ascii?Q?v/5COITyjtplFQuHQrqMceH4dkwFFBSLvXpTB1fEw/kaDKTq1VigoHnWZ5/E?=
 =?us-ascii?Q?A0wUrggOXvdDC3WH1ASendGeieH1uvY4INjWO6TCnjFXwndqKedtngMTFppq?=
 =?us-ascii?Q?qQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df6f0966-d97e-4cf2-f952-08dab8f86078
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 15:23:34.7223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ih61Qz10smU4gK6xe9rIkw/l3SDIgxWZRQNiTICWClR4wDOCidIYNA8JDQC/ZCJ9V48OPBhfOjLx1esdvJuDJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4276
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280096
X-Proofpoint-ORIG-GUID: FvnQl62egmr_ftIytwc03Nj99_cc5FQX
X-Proofpoint-GUID: FvnQl62egmr_ftIytwc03Nj99_cc5FQX
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/26/22 21:12, Peter Xu wrote:
> On Wed, Oct 26, 2022 at 04:54:01PM -0700, Mike Kravetz wrote:
> > On 10/26/22 17:42, Peter Xu wrote:
> > > 
> > > Pure question: can we rely on hugetlb_vm_op_close() to destroy the hugetlb
> > > vma lock?
> > > 
> > > I read the comment above, it seems we are trying to avoid racing with pmd
> > > sharing, but I don't see how that could ever happen, since iiuc there
> > > should only be two places that unmaps the vma (final==true):
> > > 
> > >   (1) munmap: we're holding write lock, so no page fault possible
> > >   (2) exit_mmap: we've already reset current->mm so no page fault possible
> > > 
> > 
> > Thanks for taking a look Peter!
> > 
> > The possible sharing we are trying to stop would be initiated by a fault
> > in a different process on the same underlying mapping object (inode).  The
> > specific vma in exit processing is still linked into the mapping interval
> > tree.  So, even though we call huge_pmd_unshare in the unmap processing (in
> > __unmap_hugepage_range) the sharing could later be initiated by another
> > process.
> > 
> > Hope that makes sense.  That is also the reason the routine
> > page_table_shareable contains this check:
> > 
> > 	/*
> > 	 * match the virtual addresses, permission and the alignment of the
> > 	 * page table page.
> > 	 *
> > 	 * Also, vma_lock (vm_private_data) is required for sharing.
> > 	 */
> > 	if (pmd_index(addr) != pmd_index(saddr) ||
> > 	    vm_flags != svm_flags ||
> > 	    !range_in_vma(svma, sbase, s_end) ||
> > 	    !svma->vm_private_data)
> > 		return 0;
> 
> Ah, makes sense.  Hmm, then I'm wondering whether hugetlb_vma_lock_free()
> would ever be useful at all?  Because remove_vma() (or say, the close()
> hook) seems to always be called after an precedent unmap_vmas().

You are right.  hugetlb_vma_lock_free will almost always be a noop when
called from the close hook.  It is still 'needed' for vms setup error
pathss.

> > > > +void clear_hugetlb_page_range(struct vm_area_struct *vma, unsigned long start,
> > > > +				unsigned long end)
> > > > +{
> > > > +	struct mmu_notifier_range range;
> > > > +	struct mmu_gather tlb;
> > > > +
> > > > +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
> > > > +				start, end);
> > > 
> > > Is mmu_notifier_invalidate_range_start() missing here?
> > > 
> > 
> > It certainly does look like it.  When I created this routine, I was trying to
> > mimic what was done in the current calling path zap_page_range to
> > __unmap_hugepage_range_final.  Now when I look at that, I am not seeing
> > a mmu_notifier_invalidate_range_start/end.  Am I missing something, or
> > are these missing today?
> 
> I'm not sure whether we're looking at the same code base; here it's in
> zap_page_range() itself.
> 
> 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
> 				start, start + size);
> 	tlb_gather_mmu(&tlb, vma->vm_mm);
> 	update_hiwater_rss(vma->vm_mm);
> 	mmu_notifier_invalidate_range_start(&range);
> 	do {
> 		unmap_single_vma(&tlb, vma, start, range.end, NULL);
> 	} while ((vma = mas_find(&mas, end - 1)) != NULL);
> 	mmu_notifier_invalidate_range_end(&range);

Yes, I missed that.  Thanks!

> 
> > Do note that we do MMU_NOTIFY_UNMAP in __unmap_hugepage_range.
> 
> Hmm, I think we may want CLEAR for zap-only and UNMAP only for unmap.
> 
>  * @MMU_NOTIFY_UNMAP: either munmap() that unmap the range or a mremap() that
>  * move the range
>  * @MMU_NOTIFY_CLEAR: clear page table entry (many reasons for this like
>  * madvise() or replacing a page by another one, ...).
> 
> The other thing is that unmap_vmas() also notifies (same to
> zap_page_range), it looks a duplicated notification if any of them calls
> __unmap_hugepage_range() at last.

The only call into __unmap_hugepage_range() from generic zap/unmap calls
is via __unmap_hugepage_range_final.  Other call paths are entirely
within hugetlb code.

> > > > +	tlb_gather_mmu(&tlb, vma->vm_mm);
> > > > +	update_hiwater_rss(vma->vm_mm);
> > > > +
> > > > +	__unmap_hugepage_range_locking(&tlb, vma, start, end, NULL, 0, false);
> > > > +
> > > > +	mmu_notifier_invalidate_range_end(&range);
> > > > +	tlb_finish_mmu(&tlb);
> > > > +}
> > > > +#endif
> > > > +
> > > >  void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
> > > >  			  unsigned long end, struct page *ref_page,
> > > >  			  zap_flags_t zap_flags)
> > > > diff --git a/mm/madvise.c b/mm/madvise.c
> > > > index 2baa93ca2310..90577a669635 100644
> > > > --- a/mm/madvise.c
> > > > +++ b/mm/madvise.c
> > > > @@ -790,7 +790,10 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
> > > >  static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
> > > >  					unsigned long start, unsigned long end)
> > > >  {
> > > > -	zap_page_range(vma, start, end - start);
> > > > +	if (!is_vm_hugetlb_page(vma))
> > > > +		zap_page_range(vma, start, end - start);
> > > > +	else
> > > > +		clear_hugetlb_page_range(vma, start, end);
> > > >  	return 0;
> > > >  }
> > > 
> > > This does look a bit unfortunate - zap_page_range() contains yet another
> > > is_vm_hugetlb_page() check (further down in unmap_single_vma), it can be
> > > very confusing on which code path is really handling hugetlb.
> > > 
> > > The other mm_users check in v3 doesn't need this change, but was a bit
> > > hackish to me, because IIUC we're clear on the call paths to trigger this
> > > (unmap_vmas), so it seems clean to me to pass that info from the upper
> > > stack.
> > > 
> > > Maybe we can have a new zap_flags passed into unmap_single_vma() showing
> > > that it's destroying the vma?
> > 
> > I thought about that.  However, we would need to start passing the flag
> > here into zap_page_range as this is the beginning of that call down into
> > the hugetlb code where we do not want to remove zap_page_rangethe
> > vma_lock.
> 
> Right.  I was thinking just attach the new flag in unmap_vmas().  A pesudo
> (not compiled) code attached.

I took your suggestions and came up with a new version of this patch.  Not
sure if I love the new zap flag, as it is only used by hugetlb code.  I also
added a bool to __unmap_hugepage_range to eliminate the duplicate notification
calls.

From 15ffe922b60af9f4c19927d5d5aaca75840d0f6c Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Fri, 28 Oct 2022 07:46:50 -0700
Subject: [PATCH v5] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED
 processing

madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear the page
tables associated with the address range.  For hugetlb vmas,
zap_page_range will call __unmap_hugepage_range_final.  However,
__unmap_hugepage_range_final assumes the passed vma is about to be removed
and deletes the vma_lock to prevent pmd sharing as the vma is on the way
out.  In the case of madvise(MADV_DONTNEED) the vma remains, but the
missing vma_lock prevents pmd sharing and could potentially lead to issues
with truncation/fault races.

This issue was originally reported here [1] as a BUG triggered in
page_try_dup_anon_rmap.  Prior to the introduction of the hugetlb
vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag to
prevent pmd sharing.  Subsequent faults on this vma were confused as
VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping was
not set in new pages added to the page table.  This resulted in pages that
appeared anonymous in a VM_SHARED vma and triggered the BUG.

Create a new routine clear_hugetlb_page_range() that can be called from
madvise(MADV_DONTNEED) for hugetlb vmas.  It has the same setup as
zap_page_range, but does not delete the vma_lock.  Also, add a new zap
flag ZAP_FLAG_UNMAP to indicate an unmap call from unmap_vmas().  This
is used to indicate the 'final' unmapping of a vma.  The routine
__unmap_hugepage_range to take a notification_needed argument.  This is
used to prevent duplicate notifications.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: <stable@vger.kernel.org>
---
 include/linux/hugetlb.h |  7 ++++
 include/linux/mm.h      |  3 ++
 mm/hugetlb.c            | 93 +++++++++++++++++++++++++++++++----------
 mm/madvise.c            |  5 ++-
 mm/memory.c             |  2 +-
 5 files changed, 86 insertions(+), 24 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 3568b90b397d..badcb277603d 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -158,6 +158,8 @@ long follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
 void unmap_hugepage_range(struct vm_area_struct *,
 			  unsigned long, unsigned long, struct page *,
 			  zap_flags_t);
+void clear_hugetlb_page_range(struct vm_area_struct *vma,
+			unsigned long start, unsigned long end);
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma,
 			  unsigned long start, unsigned long end,
@@ -428,6 +430,11 @@ static inline void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 	BUG();
 }
 
+static void __maybe_unused clear_hugetlb_page_range(struct vm_area_struct *vma,
+			unsigned long start, unsigned long end)
+{
+}
+
 static inline vm_fault_t hugetlb_fault(struct mm_struct *mm,
 			struct vm_area_struct *vma, unsigned long address,
 			unsigned int flags)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 978c17df053e..517c8cc8ccb9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3464,4 +3464,7 @@ madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
  */
 #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
 
+/* Set in unmap_vmas() to indicate an unmap call.  Only used by hugetlb */
+#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
+
 #endif /* _LINUX_MM_H */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4a0289ef09fa..0309a7c0f3bc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5062,7 +5062,8 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 
 static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end,
-				   struct page *ref_page, zap_flags_t zap_flags)
+				   struct page *ref_page, zap_flags_t zap_flags,
+				   bool notification_needed)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
@@ -5087,13 +5088,16 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 	tlb_change_page_size(tlb, sz);
 	tlb_start_vma(tlb, vma);
 
-	/*
-	 * If sharing possible, alert mmu notifiers of worst case.
-	 */
-	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, start,
-				end);
-	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
-	mmu_notifier_invalidate_range_start(&range);
+	if (notification_needed) {
+		/*
+		 * If sharing possible, alert mmu notifiers of worst case.
+		 */
+		mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm,
+					start, end);
+		adjust_range_if_pmd_sharing_possible(vma, &range.start,
+					&range.end);
+		mmu_notifier_invalidate_range_start(&range);
+	}
 	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
@@ -5178,7 +5182,8 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 		if (ref_page)
 			break;
 	}
-	mmu_notifier_invalidate_range_end(&range);
+	if (notification_needed)
+		mmu_notifier_invalidate_range_end(&range);
 	tlb_end_vma(tlb, vma);
 
 	/*
@@ -5198,29 +5203,72 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 		tlb_flush_mmu_tlbonly(tlb);
 }
 
-void __unmap_hugepage_range_final(struct mmu_gather *tlb,
+static void __unmap_hugepage_range_locking(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page,
 			  zap_flags_t zap_flags)
 {
+	bool final = zap_flags & ZAP_FLAG_UNMAP;
+
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 
-	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
+	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags,
+				false);
 
-	/*
-	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
-	 * the vma_lock is freed, this makes the vma ineligible for pmd
-	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
-	 * This is important as page tables for this unmapped range will
-	 * be asynchrously deleted.  If the page tables are shared, there
-	 * will be issues when accessed by someone else.
-	 */
-	__hugetlb_vma_unlock_write_free(vma);
+	if (final) {
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
+}
 
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
+void __unmap_hugepage_range_final(struct mmu_gather *tlb,
+			  struct vm_area_struct *vma, unsigned long start,
+			  unsigned long end, struct page *ref_page,
+			  zap_flags_t zap_flags)
+{
+	__unmap_hugepage_range_locking(tlb, vma, start, end, ref_page,
+					zap_flags);
 }
 
+#ifdef CONFIG_ADVISE_SYSCALLS
+/*
+ * Similar setup as in zap_page_range().  madvise(MADV_DONTNEED) can not call
+ * zap_page_range for hugetlb vmas as __unmap_hugepage_range_final will delete
+ * the associated vma_lock.
+ */
+void clear_hugetlb_page_range(struct vm_area_struct *vma, unsigned long start,
+				unsigned long end)
+{
+	struct mmu_notifier_range range;
+	struct mmu_gather tlb;
+
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
+				start, end);
+	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	update_hiwater_rss(vma->vm_mm);
+	mmu_notifier_invalidate_range_start(&range);
+
+	__unmap_hugepage_range_locking(&tlb, vma, start, end, NULL, 0);
+
+	mmu_notifier_invalidate_range_end(&range);
+	tlb_finish_mmu(&tlb);
+}
+#endif
+
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page,
 			  zap_flags_t zap_flags)
@@ -5228,7 +5276,8 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 	struct mmu_gather tlb;
 
 	tlb_gather_mmu(&tlb, vma->vm_mm);
-	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, zap_flags);
+	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, zap_flags,
+				true);
 	tlb_finish_mmu(&tlb);
 }
 
diff --git a/mm/madvise.c b/mm/madvise.c
index c7105ec6d08c..d8b4d7e56939 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -790,7 +790,10 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
 static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end)
 {
-	zap_page_range(vma, start, end - start);
+	if (!is_vm_hugetlb_page(vma))
+		zap_page_range(vma, start, end - start);
+	else
+		clear_hugetlb_page_range(vma, start, end);
 	return 0;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index c5599a9279b1..679b702af4ce 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1671,7 +1671,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
-		.zap_flags = ZAP_FLAG_DROP_MARKER,
+		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
 		/* Careful - we need to zap private pages too! */
 		.even_cows = true,
 	};
-- 
2.37.3

