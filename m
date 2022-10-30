Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DAF612699
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 02:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJ3ASm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 20:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiJ3ASj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 20:18:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FB724F26;
        Sat, 29 Oct 2022 17:18:37 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29TKK9g0012622;
        Sun, 30 Oct 2022 00:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=tPsYwScA75zcoPjU6ZQCZx2s7XqRblCuzFqWsG+amoM=;
 b=oaWeDHFx4YApOnPE6qQmVvR+uDdt8bAOSbbLgs8jOrWMo1hW/bNFvcUBPeO6KyoDhJJa
 4SWkKtu5nOdLe3G07QHck8OcHKo+kEWpH73pd1ImNyfYXvB27Fd8iLH71nSpq6lxoIPO
 +Cg6D1MYAaWi2uOpogmEHKXN/ElYoAcOY4Fb2dQLCd7gxLMEXohiFhdRMSpPgsgAUhfQ
 aP2HCCj6GE7GlPbxqT8zMByBuMqH9b8tNWZ1KRZOsSOtEvT4Ci+XfXr4VtLbotTvaUgF
 osfmK0u2dGsWRCCqlkO1RODxVjvH1l2yzKmZ9RFfxRLqRjg8nVtYJ/kobQZ9482uX+X/ ow== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts10y4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 30 Oct 2022 00:16:06 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29TNs0ur019481;
        Sun, 30 Oct 2022 00:16:05 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm836m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 30 Oct 2022 00:16:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ht6QxAoRFlbjchLmem+Bpo8Uv3762UcaWnfBNoynqvmWyeC7tXg4HKJuwKFodpPGhk0GzhDhW32dIRE1PzXi6dJtK6dgKnRtYdfGL+Jj7ko3jDS/+/QUB1uIgSbShtjc4PyU9wm9OKDqfvhNjjw7Kqg9WuAnCrjX2F6NrpbY0rqpjdvT653gyt2I9FSOCYOD8Y7XNL0U6kkAp1SpBtC+QwHioru2AbUwzYqO6NHXPBeNYSfgQHKjpQj25CD+f2puLKGKj2U20Q3SZr6HBm/EV831Ws2rB+qaFwOPwmgLUVIFHk9/PXq7ytWKtbiYgalm1EyLGq+/XiEzDLzD4ErTJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tPsYwScA75zcoPjU6ZQCZx2s7XqRblCuzFqWsG+amoM=;
 b=fOaS7XCDpVR8LGSTrhRHfUsz/x4c0wgPqNV3X6YLMVNqmRqXToJAWCRVVX58x9MN5d/hCpUt/MRUgs7EMcOoMn36lRjtQtnaVJBcUfTQFRSVkyKZlIkeShmzDKaCnCJ12WoEB8OJcK7XQw3+LAGNbiEibzbTYqgixV/gMOCNL64YrL2rbMNGHnTFDTbr+XqvNvpDCpaNdJUMaby2MDPfrESk8cyWNdGVUdISgfm5TEw5msrV/TrqdYSocM84HUsWdL16NFuX/1R3pUnUzfuVKRT+ZrzrthcvojGR3U7bD444UP8H9T+Ysb/pR0ra0RTSmy444RBnyhkprnwaQrMoRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPsYwScA75zcoPjU6ZQCZx2s7XqRblCuzFqWsG+amoM=;
 b=OG1/Kom1Qm57GQCCDjqwYyLoO94KqFsfC4QNRn43DaVEYoGK3Veyz5eOojow5R5CCueGQAgNcgDFn9eA02aJu2hcjnBxJCrGNelEp2VtGgMGvFMkV5zXrBhCSkf2M8r/akgiEBkoBMcDpOdiPL16mEArQN4uHlcIQeqfw6pEpqo=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by DS7PR10MB5904.namprd10.prod.outlook.com (2603:10b6:8:84::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.34; Sun, 30 Oct 2022 00:16:02 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%6]) with mapi id 15.20.5769.018; Sun, 30 Oct 2022
 00:16:02 +0000
Date:   Sat, 29 Oct 2022 17:15:55 -0700
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
Message-ID: <Y13CO8iIGfDnV24u@monkey>
References: <20221023025047.470646-1-mike.kravetz@oracle.com>
 <Y1mpwKpwsiN6u6r7@x1n>
 <Y1nImUVseAOpXwPv@monkey>
 <Y1nbErXmHkyrzt8F@x1n>
 <Y1vz7VvQ5zg5KTxk@monkey>
 <Y1v/x5RRpRjU4b/W@x1n>
 <Y1xGzR/nHQTJxTCj@monkey>
 <Y1xjyLWNCK7p0XSv@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1xjyLWNCK7p0XSv@x1n>
X-ClientProxiedBy: MW4PR03CA0354.namprd03.prod.outlook.com
 (2603:10b6:303:dc::29) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|DS7PR10MB5904:EE_
X-MS-Office365-Filtering-Correlation-Id: 6af8381d-973c-41e8-dfea-08daba0bedc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W8FujCDrULrve9Tul+RYcLYk2dBwDAMjwJhbBqEB0FcJopbfHMs/FKkLZDUm6YlV64QFgCXMwDjEXiJWUAm/zJwZarklb4ll5KyJo9DyuARAmkfoENieZf/Ld+WjuxTtt833xsEufScgcnSIonEQvppfLQuGfEkIgDAZX/JsoBR3MMJ2PCG4fWO7P8oqFSTXn5I6kVyrvc6fm+JxACdcwxUJgz94NifhoOSsBjTuibHVovFwQ5JdUIYz2VvszsKFsjlZHH92/dsVarFkyB7Meo66kvLpKpuhEjgF02aObkfsqRCFSoOhspvmeWElcSKcGzQT0dACHoscfCnhAqkwpyna/6JQqgDRRMYC0r/HbdWp/sP2mrJ/U7vdXmUC4KP/uRof8z/iJi8QPxe6xyyIpKUIMd2jIWhM4TtHhAhTHHMoRViVpW3HYsEFozchbNZE9nUuHunWCKd57XBr42DqB5NceHhiCkf0YR4ufW3OJw2//utXatXfJ1UUhoJ7F/+yWe7wsiPKhiID9kIMuAtxZm53nk6HtOK09vhtmiNtCJ5/ZmN93wUkm2NqGaP8ZBxr1gFb+CTquCHO+AJjwkq8SM3EcyCQh4yiqY+am/FkQEwiAL+310MRoP0V4uYdXVbIzvNt9JsUE+/ZhP0362NbC9BK1tiwTVa99n6WfQ2Kzg/sE5NQz1mL0bvLkA8UG/T8Nqi1Ha18VwMkDM6Oepv2Iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199015)(66556008)(86362001)(186003)(6916009)(9686003)(316002)(41300700001)(54906003)(6512007)(8936002)(5660300002)(26005)(6506007)(44832011)(2906002)(66946007)(66476007)(4326008)(53546011)(6666004)(83380400001)(7416002)(478600001)(38100700002)(6486002)(33716001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?396hMfIWetatqpuL3upx5gQeDh8UWO8Nohv9WrRoTyu7SUJv21LfvpPljdb/?=
 =?us-ascii?Q?oYGrsx6n1DxVunRGUxHAybNwD6LiGd98sNIEIMHSA34CxMe22687FI+5hqiS?=
 =?us-ascii?Q?4rcU6XJDBqydmbZnsMdXo0dvK0Or6nWTYYvmqMUlHDi8Nc+5RYEW6Uk/IJvu?=
 =?us-ascii?Q?BisuP+0OfCl8miuDkV9kaN+k2kxbpE+o6y6bG8dGY5V8vO7ZCS0z3ta0TOXz?=
 =?us-ascii?Q?HVINaSmfoI5W/rOKqUEcoGdjWc4DqCOe71UylUkW9zOzJGeOhVcdBgBfUgG4?=
 =?us-ascii?Q?yhMFUZ3aTzheO1jGp/2QEid7gxPL0P0X9quJTwhoGLDx5Dt22inEjrDYtrsQ?=
 =?us-ascii?Q?UvPLX/jeh4TwpM90LPBbd1+9fZD12nicbXU3dk6c5R0ey7Mw6/YbwkY7L2a8?=
 =?us-ascii?Q?PqBvH4Iyb48d+Xnd/lGCApvWkrBE/XnFNF5qYQ0aptd6i1ayB2rMc/xKNM4M?=
 =?us-ascii?Q?6gP5o8cAVqMOudtpfBvarIPkAk2uzRwTdIBx5dFxy1kXGelqAYsdKjOPFYkc?=
 =?us-ascii?Q?CEaL5Svh4cOnAms2gHbnoOCiCr3h9Rf088Y7d5nQh9k458S715DEdjXlNgY0?=
 =?us-ascii?Q?Sj5YTtpi8y6dkEo0MsNlr5MCQKGDfXlIBVvqop8+5A+4Q8CnBH5Y1U8t1XjN?=
 =?us-ascii?Q?5YJbJNPMNGeKN68sLM38HVX4sLIXnSX9yZXjewpF+F8dD+u9k5+KhqGy/TKU?=
 =?us-ascii?Q?74Vd1GndGSBGdWSgMK7Gr4NVM50vkBz6OfLFqvqRWpVLQ08zPkPw9TOC9RRA?=
 =?us-ascii?Q?qn1fY1GxOuci2V0/M/8HUgi3Oy0zB8/gTO+gRohuquu7zs0gGm6i7NAzqigp?=
 =?us-ascii?Q?1G4PMVXdZB/pJSQ6oiz72Wq0Q9gw7RGP59GW22boykvJSo6XLBXlV3SPIWOG?=
 =?us-ascii?Q?jazlGRCl9DdNIAAJZNmU2H7wICqM4UbS87Swx5zoE68GEQxuUhU1OzkIncVB?=
 =?us-ascii?Q?Icx/45yj+ZMW4NUhVhhJNVboh3dCjYtvgaoqJRgp7KHiQWtAbzSy/BTdvTUb?=
 =?us-ascii?Q?DIqDpwtWzo0H93ZOWJrsd3dC+G9c2MGS0Du7vQteg9LSh7ibrjifwpkEikmm?=
 =?us-ascii?Q?TfGREjKTA36EeolAEnPLF8rNvWS1sFuOYG+C7G/3SoN9f2T8A1F9ptgGfrY6?=
 =?us-ascii?Q?qkb5Y5c9+g5rlyoTLAEoTF0M+gedJejKhJWzCzrcvlPQJR8V7Oa88vkA8JNS?=
 =?us-ascii?Q?ycNMXubycEm6CYA/tE03USJcFasHj0AiYMCVClt2e6jDFI3ENfHH10BEFDdH?=
 =?us-ascii?Q?Z61Woeartu7k4U2anhQNtwyldTerHlCjun2lX9k9zciv/Ynhohl0ZhohDiiT?=
 =?us-ascii?Q?ReXOrX/f/iYMzHJSp92B9kfrLih7oZp0ou0nSs2gg243qWhMrZbdaUwaZU74?=
 =?us-ascii?Q?vXnPHq/e9ONA19o0ZA21+QKUPjxLrxbCuo+lTRKhdYttHzpXPOPz+Jd/gLu9?=
 =?us-ascii?Q?m7SL5o8YgkUwDBekAv2HMPPKSOhbojnMCttWQKJa6wsCfMzSv3CRouBZf9O4?=
 =?us-ascii?Q?ae8eohq62Int5RSLDQQnITifz5M8+J2PVCoroixTlM3QUR9y7/J5U/nPAe6A?=
 =?us-ascii?Q?l4D4oEV3tsIKdlxgcN7r04MSUD2GjOtUHHjqJhcrjwOY6AaGtRqjs6PSfyql?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af8381d-973c-41e8-dfea-08daba0bedc8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 00:16:02.6867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LcS2YbG252+RyW08471ff5/pHBTEbMIfyvs2yMQhyjy5PWb5HnUtGL5U3+3zYc35+7B7Gh8F28aHOAuA3MUUvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-29_15,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210290175
X-Proofpoint-GUID: XwaT0TVSStWJ7d_iPC6_tiCXTd9yktja
X-Proofpoint-ORIG-GUID: XwaT0TVSStWJ7d_iPC6_tiCXTd9yktja
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/28/22 19:20, Peter Xu wrote:
> On Fri, Oct 28, 2022 at 02:17:01PM -0700, Mike Kravetz wrote:
> > On 10/28/22 12:13, Peter Xu wrote:
> > > On Fri, Oct 28, 2022 at 08:23:25AM -0700, Mike Kravetz wrote:
> > > > On 10/26/22 21:12, Peter Xu wrote:
> > > > > On Wed, Oct 26, 2022 at 04:54:01PM -0700, Mike Kravetz wrote:
> > > > > > On 10/26/22 17:42, Peter Xu wrote:
> > > > diff --git a/mm/madvise.c b/mm/madvise.c
> > > > index c7105ec6d08c..d8b4d7e56939 100644
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
> > > 
> > > With the new ZAP_FLAG_UNMAP flag, clear_hugetlb_page_range() can be dropped
> > > completely?  As zap_page_range() won't be with ZAP_FLAG_UNMAP so we can
> > > identify things?
> > > 
> > > IIUC that's the major reason why I thought the zap flag could be helpful..
> > 
> > Argh.  I went to drop clear_hugetlb_page_range() but there is one issue.
> > In zap_page_range() the MMU_NOTIFY_CLEAR notifier is certainly called.
> > However, we really need to have a 'adjust_range_if_pmd_sharing_possible'
> > call in there because the 'range' may be part of a shared pmd.  :(
> > 
> > I think we need to either have a separate routine like clear_hugetlb_page_range
> > that sets up the appropriate range, or special case hugetlb in zap_page_range.
> > What do you think?
> > I think clear_hugetlb_page_range is the least bad of the two options.
> 
> How about special case hugetlb as you mentioned?  If I'm not wrong, it
> should be 3 lines change:
> 
> ---8<---
> diff --git a/mm/memory.c b/mm/memory.c
> index c5599a9279b1..0a1632e44571 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1706,11 +1706,13 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
>         lru_add_drain();
>         mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
>                                 start, start + size);
> +       if (is_vm_hugetlb_page(vma))
> +               adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
>         tlb_gather_mmu(&tlb, vma->vm_mm);
>         update_hiwater_rss(vma->vm_mm);
>         mmu_notifier_invalidate_range_start(&range);
>         do {
> -               unmap_single_vma(&tlb, vma, start, range.end, NULL);
> +               unmap_single_vma(&tlb, vma, start, start + size, NULL);
>         } while ((vma = mas_find(&mas, end - 1)) != NULL);
>         mmu_notifier_invalidate_range_end(&range);
>         tlb_finish_mmu(&tlb);
> ---8<---
> 
> As zap_page_range() is already vma-oriented anyway.  But maybe I missed
> something important?

zap_page_range is a bit confusing.  It appears that the passed range can
span multiple vmas.  Otherwise, there would be no do while loop.  Yet, there
is only one mmu_notifier_range_init call specifying the passed vma.

It appears all callers pass a range entirely within a single vma.

The modifications above would work for a range within a single vma.  However,
things would be more complicated if the range can indeed span multiple vmas.
For multiple vmas, we would need to check the first and last vmas for
pmd sharing.

Anyone know more about this seeming confusing behavior?  Perhaps, range
spanning multiple vmas was left over earlier code?
-- 
Mike Kravetz
