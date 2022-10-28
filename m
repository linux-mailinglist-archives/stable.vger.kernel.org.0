Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14C3611C5A
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 23:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJ1VTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 17:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiJ1VTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 17:19:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573EB11A14;
        Fri, 28 Oct 2022 14:19:38 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SKxQGd013284;
        Fri, 28 Oct 2022 21:17:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=C6MKcE+3H4A8tpfl4uyZEYV4c4cpJ4fNN2uzI3TGYiU=;
 b=rMkBKMBdjd66Y+qxjXFdeAEq0A8pHXIgf9WixSjYPMAvwhO5BszXdnWgPp0HDFA8IYoJ
 q/RbgoqGi54yXz/OPEkyQcU8X/3tgKH/wLyQDvBVwkyzZYG1MdvHBbukDYYnG2METGpy
 a1G/wLqcPM+UVb8F5wGG26SCMzPGt6t3+ISgjNvDvTx5O3o1YF01y990xmG+pTlubHHC
 eEk8Ilud+9mm5AhzkmoEbQ4GgCJ/vSkhVXxWKysiup+BSEqtT14NMF263802sY0m977N
 EQkvxs3UhKmPqpGDZueV/RJ1hXbFwqBHEqzMcsM8+KmrND37L7u55IP7033MCq1tPV7j qg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgmsd8bj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 21:17:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SKcqiW032681;
        Fri, 28 Oct 2022 21:17:11 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagpg128-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 21:17:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DS/G3Up7U8NTdXMGTfmvXL9Q3lFNjeMfIIw2f31/J0wdWv0zJHSdCeIi4ZxAq09B4xzyJK69OzAGI80WqaeL7rT7ZWuZ3CRpKYJhPSsB+/VVFybAXCRSjgylxK4MRW4Yo8iheJOORKL83ueKM63AMTv3cx9io7MPupSNK0I/Tp4dYWiyTwPfSuutodSnAMSS+VpJgOgA7SXQGqGq4/0wvrckBYmMJBsDZJgAVUaa6CeKTBc80CCsiIZJ2GiyVZvRYa21seJPb4HaR1PGr5lyyNS4DY2OwcGCVXwx1/bmLI83dcfGOPbzPHKTGU7JDTmHYju40dCm5YLGmHAbEmD0jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C6MKcE+3H4A8tpfl4uyZEYV4c4cpJ4fNN2uzI3TGYiU=;
 b=hURS5wsvnnLKPGwFUzWXwzIqRi/bsArxxtjaxPELCpl1zPlq4ZltOcByKVjKMgdq6VjClSEJfgi7Ry/qqNdq7yXXrVGl/2QdvOhF6U7dV6JnuKiseqMAjFmc/GuMze0qqnJWbftZCZjQotJJlLl/A5RS5EF8uiu2SvdNZ90xIySqA30ilN7etzwstXXycHUW3tkBPyAOlzWy5EK7avzIzv+KhFqikbnRjwpZ8X+FJzNn06xAx2lUIAYDftuqs7K0zDkbycSajFjj2u5w5aPDjXRtxQY9xR+JN2hjXYh8MvH6DRZs5+LnUQjRaAHwedyVFm5ZqiJQ7u5uc+/tPcenHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C6MKcE+3H4A8tpfl4uyZEYV4c4cpJ4fNN2uzI3TGYiU=;
 b=eI0LEben4VnhBdY/XvB9izszfZNLLslpNOaOoW+02KqnqTrcRL7Mc3ukoDPIWr/TB97YjKaW+xzfU5oaGDUcQuwVArOriO7p6fKO/EoXx1uHmkKU/yRmDDH7dbdSEZbJVIqmbT6tSVwbux6B01vgDQRnubrTkRA79iFbr/JSuLg=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by PH0PR10MB4792.namprd10.prod.outlook.com (2603:10b6:510:3d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Fri, 28 Oct
 2022 21:17:08 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%6]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 21:17:08 +0000
Date:   Fri, 28 Oct 2022 14:17:01 -0700
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
Message-ID: <Y1xGzR/nHQTJxTCj@monkey>
References: <20221023025047.470646-1-mike.kravetz@oracle.com>
 <Y1mpwKpwsiN6u6r7@x1n>
 <Y1nImUVseAOpXwPv@monkey>
 <Y1nbErXmHkyrzt8F@x1n>
 <Y1vz7VvQ5zg5KTxk@monkey>
 <Y1v/x5RRpRjU4b/W@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1v/x5RRpRjU4b/W@x1n>
X-ClientProxiedBy: MW4PR04CA0197.namprd04.prod.outlook.com
 (2603:10b6:303:86::22) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|PH0PR10MB4792:EE_
X-MS-Office365-Filtering-Correlation-Id: 798798e3-a2ba-4067-4181-08dab929c553
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wjW29OVhEU6Aq8UiMpdgOVzBEq2r7aOT9qf3MaRdfaG+JOsFjCIfFX65tXumT/0DORZoT/lNvbmT9+aj3bV5RpgPp8Qw5PU7F7k34lNLOcxQxdi00kIE0JNx1uM25XhQqV2vZLXlv+bdSnUCGt/SBfLR+QD/I5sjGLRt56lgV1ctIB3N3MmrsEEg+xhOtV/B6rtEKmLZyq0UX5dpCuuGThhwCv+jedIxRAzAsQ5kp4ViWqkqsaWH707Ycs1GiS/OWkb0WxTskeQem5mhzAF1nZl323gRFc7UvjVKdtH99/SqANxkYTymUhTZI+XZAg37P8OQnYUQsKDeIXlWlKvSvkQ2PYkiREB0S0elcuAjOcK5Izq9pi66MAtkEyDeIdyYbGvt3kh7qQhYkEN6j95lc5ZsFJwUEEaFZUo3zf0e9h6nTFHLE+UcOeuFKnUayckztn1v2WiLn0deOdRYjHa2Y5tN3kB6RPg7KM5XqTUcRsfp8hI68PSnPfRbYCLcLkGI0vZMu7AwNALkM7EL+ceWLa14VDaEGOmVNEPLVx+r0+Md9+UYOaPxR2AdpC43GOgu5qaI1HwCB2bdrtJbUejHePyD/iTUMMLEzEt1C0RywLp/f3gF19vx/1myWu2Y7lfM8YJk9WuMcF10t0F6JPzWiQ25E+EOVEFN/wekuV0rCIzp9hi3KlCYB41IJBar+wtwfnRNzOPHTjR7oIKcZGX+4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(53546011)(6666004)(6486002)(478600001)(38100700002)(33716001)(54906003)(6506007)(316002)(6916009)(44832011)(26005)(6512007)(9686003)(86362001)(186003)(2906002)(8936002)(66946007)(66476007)(41300700001)(4326008)(5660300002)(7416002)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RoaYpC0dCjO6fkkXzV3/jRkUrhUiuQ0LKmKj5ocNwycY9Dfurb4mMSJq6R7B?=
 =?us-ascii?Q?MPjqvRGFmz5p9jI2iMUG96mTNPoKJUsmNx3OquT+mdjNFocQ1Oo04aQSr8mm?=
 =?us-ascii?Q?Y/BBE/Q2gAbOHCygQhs0jzouWVj8Dqdk2hK5oRcjLRYqBKMk2PGiSFFX+kiy?=
 =?us-ascii?Q?9gv0XlY7jcw8RSxyu+oTYvKbkkRotB3PbCjxuq82uJPJXBwZQhChLa3cgUN8?=
 =?us-ascii?Q?UpFqgg8q025q0tgVJvtVvwmtPWZL2RVyoouzRJZASqJUz5O8Svzn8O5TrkAA?=
 =?us-ascii?Q?KZ3XsP5aGMTZugJqssSFd+Xvg/UNy1w73tPF6Fli4ubPAzdADAkU5q90jsoS?=
 =?us-ascii?Q?HpMove6LJDSjI9ahS1kNxhjoV6ow/qWm3YngOZ9rvyt5joF9Jc8KyX/tj7iD?=
 =?us-ascii?Q?g7AqX1ZU8sNK5ZphqkiTRgBxn8Rf8+RUr/GHjw+lcyg8RRejKmV9Pd+dZFYE?=
 =?us-ascii?Q?GWvBw0r+7sx4krDSt8LK8EB/b9uOtWdjyQeKwH22qYqy0Z11YHAn9vUmNURo?=
 =?us-ascii?Q?tX69NrMgPUsEvPeIiUzZpVtK4l/NY1MJ1ERG6ZwoHiqVi1pHvWSRaAk5B9RF?=
 =?us-ascii?Q?XAmjj+DEmMULuF/IaiVlKkXqrb8Qu5bkfGQngkEAoIERke2a6RWGPTNqIK4M?=
 =?us-ascii?Q?VHJ0dH/K8hK3ZX4YjZ1clMV2FF0MFrU6y64REw4KC4f22n6VRPJRjngZJqfP?=
 =?us-ascii?Q?1XsV8kqaIqqbx35XOCd6yv5LrzXNl0VS/OWXwBhuQqmN5yn85pm4IVNt197S?=
 =?us-ascii?Q?B8mC1Q85o/hekcV1JZSfrDzSIwSPR/U1uZobNCsCuWw7y82UH+nswYMMDmyP?=
 =?us-ascii?Q?L2xlCJSUrsZ56nlI+gkl+kD1am8DxjHdl5DGdVPOSIJj/syUnCDFmoIgR/Ra?=
 =?us-ascii?Q?pOeDhzQBS7pFVYrefYW9v5LjA2CtUeZ47rbh81CCZv3UhIcsU2MI5ymbJJmG?=
 =?us-ascii?Q?qN2jpn48Y51vwb6BAYFFB2DIoDH/HBBOPdtpoIYTDfZvuKyFqzp51MFnIoni?=
 =?us-ascii?Q?2+myKCaGPQACHj8HaNMumLy6kKeyTgtYnRHEViwugz2iN4Gluhg9koD9g9Af?=
 =?us-ascii?Q?w7un1monIhnIEXDGMWz3AExPhI39jeDJdGpRU1Pv7qocZwZgmEggPGCXTex9?=
 =?us-ascii?Q?UH/Pon6aFN6ibyL7GMj+1IlUsmlsGUJXALG1dc7O45MxZbxsSi7k8c+1IqJT?=
 =?us-ascii?Q?WQPGmL72NhntDuY0hbhb2GetUnyUjdK0jPGYHzAp8aUl51Zlu3ac+bauqRUb?=
 =?us-ascii?Q?b30iixDEaoiS6hkqBWY7VX+G4aHAnHTgKLPczp7EC/rvnto1k9Ew4RThmHFk?=
 =?us-ascii?Q?Q3GgztxprEE6CL65tq05JD2Vi+UzGw+k6MY32IVZBCm7MaRL2j6kbemHkRUU?=
 =?us-ascii?Q?fiQs+DYqrNSsvj7/XtGNTYwQ1jmokZfKF14zn3nKve6bQTqk7SoB8Q0rPOab?=
 =?us-ascii?Q?ouSW9sSpvJv3R51BZt6C3YgHp8GcOcnHT9QR6SOVZuvtHD+1Lu1SwLh4Lv8o?=
 =?us-ascii?Q?gmhfJ6eh6MqRqNJgD/aqihy2FIk+Jb44rfhtlb2S1r6HzR06m8kLfJPMnQBq?=
 =?us-ascii?Q?H7MKlcDyvl1OHkuwbrlXb37RaUSVhInuhMOEonihhY7gNr8y0TBXo1dobdCY?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 798798e3-a2ba-4067-4181-08dab929c553
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 21:17:08.5461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2phOdEVrau5a2Dk6qZJM+7GkalV+2j7vCzhxlcd3Bf5ONlMtWjZPq5OeMTGtFt0VAzbHTd7KO8/L+Ah899JstA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4792
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_10,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280134
X-Proofpoint-ORIG-GUID: Og8ioJyyYTqvsHQbT5-hLMewk8WZocso
X-Proofpoint-GUID: Og8ioJyyYTqvsHQbT5-hLMewk8WZocso
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/28/22 12:13, Peter Xu wrote:
> On Fri, Oct 28, 2022 at 08:23:25AM -0700, Mike Kravetz wrote:
> > On 10/26/22 21:12, Peter Xu wrote:
> > > On Wed, Oct 26, 2022 at 04:54:01PM -0700, Mike Kravetz wrote:
> > > > On 10/26/22 17:42, Peter Xu wrote:
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index c7105ec6d08c..d8b4d7e56939 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -790,7 +790,10 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
> >  static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
> >  					unsigned long start, unsigned long end)
> >  {
> > -	zap_page_range(vma, start, end - start);
> > +	if (!is_vm_hugetlb_page(vma))
> > +		zap_page_range(vma, start, end - start);
> > +	else
> > +		clear_hugetlb_page_range(vma, start, end);
> 
> With the new ZAP_FLAG_UNMAP flag, clear_hugetlb_page_range() can be dropped
> completely?  As zap_page_range() won't be with ZAP_FLAG_UNMAP so we can
> identify things?
> 
> IIUC that's the major reason why I thought the zap flag could be helpful..

Argh.  I went to drop clear_hugetlb_page_range() but there is one issue.
In zap_page_range() the MMU_NOTIFY_CLEAR notifier is certainly called.
However, we really need to have a 'adjust_range_if_pmd_sharing_possible'
call in there because the 'range' may be part of a shared pmd.  :(

I think we need to either have a separate routine like clear_hugetlb_page_range
that sets up the appropriate range, or special case hugetlb in zap_page_range.
What do you think?
I think clear_hugetlb_page_range is the least bad of the two options.
-- 
Mike Kravetz
