Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3360B58B0E9
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 22:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbiHEUtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 16:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbiHEUtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 16:49:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C2324F01;
        Fri,  5 Aug 2022 13:49:01 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 275KV7jT026478;
        Fri, 5 Aug 2022 20:48:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=7yPM476md+sX/USVAmruhaAIHX8SYNe8x+rHCfADBmY=;
 b=3VQ7MppGPd5DZ3KOjMx5IpeL9wcTeE1PraHQbAKYbNSVGMl/5s7Kj8TUyxS88TYoc7Dl
 1IEQj/lPXypp9KmA0JYkaxcRVk6QdO/mbpttunklvb2nPyTKJ+37F19fC1Vs+VEsCxp3
 u/8u1y3cxbS2CTK6x2rWiZmD26/5eeyRVoigr/wtn6DcMI/YSWJbwoC1fAtiHvp91+0m
 bL33t/gWfyOh02qLeiXs1Gsu7Ee9iyqn4OR1NzZir1ZkTmdGnMXsF+QKsMb2aVzj7DA5
 FjRErnGZ5X0bwm3i93tAZFLQjiCJVmSlqoZdULGgVw4ZDRmh3l+IgWw9DahVwttZenNN ag== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmv8sgt1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 20:48:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 275HUwDe000973;
        Fri, 5 Aug 2022 20:48:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hp57ukfec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 20:48:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJujiW02vamnMOdbGa7ZEGJRAALTNtrtkf+3aHvbJTvFJ/dbDkeZgyQBZ/DXIxFmhVxiuKYZZCf5OI+1jT4g84zsVDruBK9nSz8nc7KsGqTmVR2Jnr7UI1SJyLWeDToYpysCitn+fsCCYlq6+uYNGIZ1bWPrWihMj62q1CBrzTRS1066l+9BfsneuXfArxVu4bbz3ijX0Aahk5o3EM0fK40iSCs+K6FLgWUe5a0KSsO7Jxyo595giuyX8nbKfUHY0o/WdtzHPxi2dG1BEuBvNGRkQLOwWCpl62avMpKKSOfzQ4m6Lj6jRIwkENHrBGS5JgERlQQfoEr52eIubkPeiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7yPM476md+sX/USVAmruhaAIHX8SYNe8x+rHCfADBmY=;
 b=RQhBPlPUPrp/YgaVjOtruwNYZrXcR2YrIhVoEU4WO2+USKO1BCEupyfF/RPVH+A2TthfApbvUddsULcYqiFCoYBIr1j1kG1y6aUeTXdAM0THLQt/QxqY0ul898nhzc1adKWaNAHQZ3hoJtUrCwFNm5fmFGY/dD8kj/VqYznBrovYs5/Nbd8cTrFlXRu1iDA3pXlHsNYlw87d6RKeu69INME0Fbmt4A19foLK/drmgoPh0exhmsj1S7WieN1HF5WFRbbHrklTvvhjYTjwe1TKg3S+hX+/h/q4w36GsvQ8c4VxUlnj8LFWrtTbJ7ISybl9oDzBM1e94AXsO0BFmkMxyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7yPM476md+sX/USVAmruhaAIHX8SYNe8x+rHCfADBmY=;
 b=rp6mhH6TM3Pz55ExH1kJtN9Vf1yHS1pirvp2GRUni/ZQHJB4Z6sGOq7m6CVfOxRMudEDsh1NfX8tjzEj0ohKW70HSTPCPnrQw3s15G+fqQ3w1tyejzTnb9xv3Ncfn1o/frNdTZ14+wTU29cfgkxanU9Q8q+ky6vaVN/9Tn5XMG8=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CH2PR10MB3974.namprd10.prod.outlook.com (2603:10b6:610:c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Fri, 5 Aug
 2022 20:48:38 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0%5]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 20:48:38 +0000
Date:   Fri, 5 Aug 2022 13:48:35 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Peter Feiner <pfeiner@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/hugetlb: fix hugetlb not supporting
 write-notify
Message-ID: <Yu2CI4wGLHCjMSWm@monkey>
References: <20220805110329.80540-1-david@redhat.com>
 <20220805110329.80540-2-david@redhat.com>
 <Yu1eCsMqa641zj5C@xz-m1.local>
 <Yu1gHnpKRZBhSTZB@monkey>
 <c2a3b903-099c-4b79-6923-8b288d404c51@redhat.com>
 <Yu1ie559zt8VvDc1@monkey>
 <73050e64-e40f-0c94-be96-316d1e8d5f3b@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73050e64-e40f-0c94-be96-316d1e8d5f3b@redhat.com>
X-ClientProxiedBy: MW4PR04CA0068.namprd04.prod.outlook.com
 (2603:10b6:303:6b::13) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51956da9-c528-413c-b8e1-08da7723df66
X-MS-TrafficTypeDiagnostic: CH2PR10MB3974:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K0bTtVC+zrdcPYjVq5VsViODdMuaUJwexly72y4fTJB3dPXOl9t4+EX5gffX8gvbRY3ckzM2oaX6mzmz6D0JKyWtkWPgtBvDvKi79v5QLBiHyi1666YlCRB04GHC59LShUTlu/UG8kTGZsAZFGM7MnDjWaNWZuKBZBigUOLKBBlQpuYlSAotpg1c+adWLoofqBw+bAo8yI7EW76vxxEHtI9gqDguOyEMQB4hkN2d2yBft1wnihFb5QSLFFFk93K00VRWe3U4Hze5yHjI1FIiR+B7oCWmjTUX5yhjMsl1cHp2Oy6aiY0/Ph/mX5fBRY7lwt7cFwQNNIjvzPdquOGX8BCOhDjREjwMR+mRkUWf7ruac6Sd0BH4JdpIpzwi9dqA/yWlovGsXNptnyVtZ4qWZ3/h4PijhYNAQxPKN1Y+mPyGENGcX1rwVQKNmouBrCFFLPENXenbgfCSNFQdq6FLKZe7vL0RS7JUOJBlOY6PffvvTBRD1uuF4r1dPFkVI/wDTc0MCpzdeEGa8G7Lhh3FaZpV6iS4J+sQIrdtpWWbxVDP9LSKhV4L6y9h67IdobbG0kyhkN+CaXaJVhHKLm6gjYhncC3DKJgVhYq0e/B7nhNhYI0D7I0Rju3FaXj9hQNjFjZzy22oKKFCGHR+nMpdpjwkL8I85Rmmt0GNrGN7QkR8f4b39EC54xphVYBpRdw84hBb1Ipc/Qk7+NfNGpN901tK6UFJ/jJlmfaZ5YJ7QC5hgLG6jUKT3563EBbvTRkj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(39860400002)(366004)(376002)(346002)(396003)(33716001)(6916009)(54906003)(38100700002)(9686003)(316002)(83380400001)(66556008)(186003)(66476007)(6486002)(53546011)(8936002)(4326008)(44832011)(66946007)(5660300002)(8676002)(41300700001)(478600001)(2906002)(6666004)(86362001)(6512007)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k5m0rkVZ1rqogU5TJ+8hQ68yFXVFGCDEqfpPiiJvmdO1XdudSdtiPVe8N/1h?=
 =?us-ascii?Q?AeQ7Ak1RFNpHWQSXSdnBJRrLDF8hu1zK5TXRmU0Kta65mSP+5QOoY3AyC8Or?=
 =?us-ascii?Q?U91o9RHQ/BUMkAWOrffkRfiWhcwrq1VUWC35ncjHe/QPsCjx88WHpqxt8etc?=
 =?us-ascii?Q?/b0IneTw03cT9BVyAVYsawdhRWLWQAkBcMaC7qdU7mH6QhNWLWeLQGKhQ38L?=
 =?us-ascii?Q?FuwLce9UnhYK49RW4QESRq8xuxp/3p4V+WDEZ4EM7YsyzO+eYS0jgOEZauYy?=
 =?us-ascii?Q?pGqC2yP2w6guvL9WvDuBYB2g2cytYsvVbLEiOob7JxlqOjchUH/gK5Ej2LiP?=
 =?us-ascii?Q?dIHLDLlYfcXaa8InogMcdYK/84ea43QfBfYG5xgyUX90e7xjtpDG52RDoqkD?=
 =?us-ascii?Q?vZegNrh1GWqClTlxN6UFEsWM1aykS7iSnZWhUqZNErJoNp3MOUMddTlDmCl9?=
 =?us-ascii?Q?z9rd4MYdYs0bxGFaKBkCqqBNln0RVWYOMqvhw8OzOruId9whxIjqTG5SUCdL?=
 =?us-ascii?Q?d26xC/Mz1VDTYnMGYdihWwfq1CLMCMV3iVIK2bBP/CyC8qqC646fByPZX+cW?=
 =?us-ascii?Q?rxIJqHcs2ey+gXYDgk8+NG+KHYQCS2hcaWCW7YWW0k+8vvjmeSZ9gaL4lkmy?=
 =?us-ascii?Q?q/FEm5CxfKmzYAVNzCPlzhA1lrhhLwfOFC0rvJU/bxll4qlOnEEwXbFghhhq?=
 =?us-ascii?Q?TsmI2lQQA3/D1UKY0x0twddy1mc4s86qVCkIBVePUxR6fWg42aATzqBQLkqR?=
 =?us-ascii?Q?W3LM1ItpWJfBbGASvy9Ppxjqiecj5KW9ZbosU4FB/tOtMzbpZp6BH0X/qImL?=
 =?us-ascii?Q?QgVG1QXamN1TCPu03uDmE8QCqOjQn2ysRPKOw1FaZkO22Aonjb5TD7h2VmsT?=
 =?us-ascii?Q?X3CxRJnVrPxkfiP7dVCOkPxk1r1qawApGIvJCeTdxAXTBLgJ1+qPz6SHWXb1?=
 =?us-ascii?Q?mnhhQiZl1/9Ij9LlHgOZE5nWyvJwFAUuG6/wThYVy4Y2SBIqXD1FsEbVZ0g6?=
 =?us-ascii?Q?eAbk0c5JfsaQKggVt5TtFVZG8hJ6uDKrncFvZHOWMAX65yoW41mWL0cjBgMi?=
 =?us-ascii?Q?K5Do61q3jjEYngBTo40ikH3IfKZq79JwNIxOUEu7UqZetP2D652+sAdGhOqK?=
 =?us-ascii?Q?ZuB+XdYL5k3yUTZtFSSOLN+rglYvCzdfCRQbNEkHJVZ25BvD7u+EvfRAQaCa?=
 =?us-ascii?Q?9/kPQ595FUa3+9egqKGSYirorosVA01wfCpJ/33qHjc7Mvyw42H4Zw4rosO+?=
 =?us-ascii?Q?pLlG7ShAUwwdw5uuXKgyRuC3RXcIoxpwtltMx48FWbp4UXurGoo4JeNK0gfr?=
 =?us-ascii?Q?LPnL4gxSvMvhsqVGoh1KHrqAhl0RfUn+mPC+YRuKqd/pCcQzvG8SZxWXNt9F?=
 =?us-ascii?Q?7hVHFrzn5ASISaMdVB0H6WN7yAP/eBVoAB8YsNsSTieBAb6QNUwuirqOc92b?=
 =?us-ascii?Q?F9UW2T0IhCaeexIznKNzjIUxcT0QNZjn0o7ZmpHaROAFJ1xlbg4FL4IqVdQz?=
 =?us-ascii?Q?uwSWZIYZtQO5u0P7JOZzpRs/XIk1FYUmjvL0wCsti4t77dkDerTfGfRbMFUX?=
 =?us-ascii?Q?cnYkX47SVQKjX/rdxpDGaNqq9uitFKLfVGjlg/BBu4sbYA9EvM2Z2PuXcDAr?=
 =?us-ascii?Q?LQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51956da9-c528-413c-b8e1-08da7723df66
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 20:48:38.3520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vrpek0cp8MlovNElBOzwnkDZro5GLujUcks55T374+PJb8pF7vFUiKNu3qcJTnmjImZcl2thc4z2tS3+SOt5HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3974
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_11,2022-08-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208050091
X-Proofpoint-GUID: DxOuy34Yc1odJOTyUNGQn0sEFTJdQgq0
X-Proofpoint-ORIG-GUID: DxOuy34Yc1odJOTyUNGQn0sEFTJdQgq0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/05/22 20:57, David Hildenbrand wrote:
> On 05.08.22 20:33, Mike Kravetz wrote:
> > On 08/05/22 20:25, David Hildenbrand wrote:
> >> On 05.08.22 20:23, Mike Kravetz wrote:
> >>> On 08/05/22 14:14, Peter Xu wrote:
> >>>> On Fri, Aug 05, 2022 at 01:03:28PM +0200, David Hildenbrand wrote:
> >>>>> diff --git a/mm/mmap.c b/mm/mmap.c
> >>>>> index 61e6135c54ef..462a6b0344ac 100644
> >>>>> --- a/mm/mmap.c
> >>>>> +++ b/mm/mmap.c
> >>>>> @@ -1683,6 +1683,13 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
> >>>>>  	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
> >>>>>  		return 0;
> >>>>>  
> >>>>> +	/*
> >>>>> +	 * Hugetlb does not require/support writenotify; especially, it does not
> >>>>> +	 * support softdirty tracking.
> >>>>> +	 */
> >>>>> +	if (is_vm_hugetlb_page(vma))
> >>>>> +		return 0;
> >>>>
> >>>> I'm kind of confused here..  you seems to be fixing up soft-dirty for
> >>>> hugetlb but here it's explicitly forbidden.
> >>>>
> >>>> Could you explain a bit more on why this patch is needed if (assume
> >>>> there'll be a working) patch 2 being provided?
> >>>>
> >>>
> >>> No comments on the patch, but ...
> >>>
> >>> Since it required little thought, I ran the test program on next-20220802 and
> >>> was surprised that the issue did not recreate.  Even added a simple printk
> >>> to make sure we were getting into vma_wants_writenotify with a hugetlb vma.
> >>> We were.
> >>
> >>
> >> ... does your config have CONFIG_MEM_SOFT_DIRTY enabled?
> >>
> > 
> > No, Duh!
> > 
> > FYI - Some time back, I started looking at adding soft dirty support for
> > hugetlb mappings.  I did not finish that work.  But, I seem to recall
> > places where code was operating on hugetlb mappings when perhaps it should
> > not.
> > 
> > Perhaps, it would also be good to just disable soft dirty for hugetlb at
> > the source?
> 
> I thought about that as well. But I came to the conclusion that without
> patch #2, hugetlb VMAs cannot possibly support write-notify, so there is
> no need to bother in vma_wants_writenotify() at all.
> 
> The "root" would be places where we clear VM_SOFTDIRTY. That should only
> be fs/proc/task_mmu.c:clear_refs_write() IIRC.
> 
> So I don't particularly care, I consider this patch a bit cleaner and
> more generic, but I can adjust clear_refs_write() instead of there is a
> preference.
> 

After a closer look, I agree that this may be the simplest/cleanest way to
proceed.  I was going to suggest that you note hugetlb does not support
softdirty, but see you did in the comment.

Acked-by: Mike Kravetz <mike.kravetz@oracle.com>

-- 
Mike Kravetz
