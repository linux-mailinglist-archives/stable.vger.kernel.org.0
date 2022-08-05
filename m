Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBC258AFC3
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 20:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238240AbiHESdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 14:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiHESdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 14:33:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839427AC34;
        Fri,  5 Aug 2022 11:33:46 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 275IQ74e023049;
        Fri, 5 Aug 2022 18:33:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=Bj82cvEZxhn3OWcESQ5Nz2zZ3cDCkveQg+CO5aAns4U=;
 b=B5Er/K7Felgq0Ejn4EYaAqoCemvXF74oIh6uZWdgXzqa/yvtil4KbdYuwN9XGu6zPZHY
 m+jtrh8Ow2MJ+ONVj6Ra0/E6c6Jn20R5ZnAS+dQTTKAk7vSmFBtwGyYoPJEIWQn/Vvgl
 9QcEYArHeRiWWIhp9M+Ls4o37IwY6TAL93x6DE2hywubXyFM9VnryvXKSGj5f/+BODC7
 VNWV/T6itxQjXEeynNMYSuhAPGeJ68hNwRFDV04myvzlejtpuyRSs1Pw5NdK+xJL9uVd
 +d9o+Hc8G8G3DN5NR2qwK57kByk2fOQHTpExF7r2oJBvZmkO0I0rvvQuqTaE4yW/goLF NA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu818h17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 18:33:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 275GvaUS030891;
        Fri, 5 Aug 2022 18:33:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu35p71b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 18:33:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMJoVn3JGTcCgDsgTF1NuJcFVE/kismp758mVjMddXFXNMt5WsdQh6h2POC+Xf9FpCiVAC/I+FcpRj7qKX6i+L4sXhVChNjo0UMAtABnOEKon4bVTYCJT90pAxx3n1E6qX5zdHMhG2KZL358f8c0Kw0009Atv3mufc10jzcZCXZMimJo7GzgPE+8RXohZR+yk7WsA93NIMC+RnbWTLUlZXsIDW2GkcerXn31SdRKYYo4lNEADL8z1IynWOB/UpeDU7oeHC1LuxQT+iUG6L7jrfBI6j04x3MtUJPf1o5b6kvozkd9oNTrA5AhgUqyUjpWatj5IprmEBeWdFCAIQXLzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bj82cvEZxhn3OWcESQ5Nz2zZ3cDCkveQg+CO5aAns4U=;
 b=LFez7vg3T8Fz6hpivxnvJMbuPHjw9DAva0CsgyhFMTEWnRgUMMHHQEq92mArmbi1E629Y18XC/PgqADuqgb7F5SjmBgTGFK1fp22q2dbhs7Yrmi4DXbaOXGunF7khJQlnY+kJ+pv+rBxABk4QaG44XZCDDqfSTTD7U5p4IMUmSSXOFZccXbeE0sPEmEdfKX3YERJjErGyj/vdiw6eNTX+m3Ysij7ie3nVHsRzGP4n5cyb/gOQj4Bd7WJc1WzqXPmft8SxEqGggTLBMArs6hyWQ3m6IZnuIil7mt68rpNpE4K78sq73MhU+lep8Ar+jDQIcVWGyz94IV+4NQjwB1ROQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bj82cvEZxhn3OWcESQ5Nz2zZ3cDCkveQg+CO5aAns4U=;
 b=Y9aAM87ODFomnF55zENyfBpoJ8Z03WYLjdEcYPZkQkKBfYup7nEmTkzA82a59C9LYF+l1aXVJk5HsPYhHtP8TqrQEqLcHdUL7CoLd6rcwRzSmdejgMueZc2yzBUFFFkczC1chj92VDi6KGIY8hItSMt5QZRb3Yu9pDPWYUuorI0=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by MWHPR10MB1328.namprd10.prod.outlook.com (2603:10b6:300:21::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Fri, 5 Aug
 2022 18:33:34 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0%5]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 18:33:34 +0000
Date:   Fri, 5 Aug 2022 11:33:31 -0700
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
Message-ID: <Yu1ie559zt8VvDc1@monkey>
References: <20220805110329.80540-1-david@redhat.com>
 <20220805110329.80540-2-david@redhat.com>
 <Yu1eCsMqa641zj5C@xz-m1.local>
 <Yu1gHnpKRZBhSTZB@monkey>
 <c2a3b903-099c-4b79-6923-8b288d404c51@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2a3b903-099c-4b79-6923-8b288d404c51@redhat.com>
X-ClientProxiedBy: MW2PR2101CA0031.namprd21.prod.outlook.com
 (2603:10b6:302:1::44) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c60ae9d-1499-465a-d9e2-08da7711012b
X-MS-TrafficTypeDiagnostic: MWHPR10MB1328:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DMD8iJ2XiG+g43TgLpBj5gzmIHquACen1wX+VFkArjBApb9GmUuquBDQ+nbMpgur/fIYdB/Tdl4cWgWuPfcq9JozYfHtFBRKX+3F0tTESa1zavom0Nwki3COSN/2CADs06JmNaM/em8FvUi2tlMoA/gAAiXx1t7uDFPWimdc10WXh1iIOgCmazZrQRDycIslHNPyWMm7oO0dq5saZmnlAWxxC/gKI2i6/3ummux4MdUlOzPTDaATJYtPJajHvp0KJ9J5YAimAUeEo04GxPkspkoQXdkQsJ40oYkxr4hYm8sgRJEas5x/al1r1pEs31vBUfQ8IVz5XfOhrswx6G8eYJlCTfARj/tDoonBjTwNN9cHqm3U3dJdKk3gMnMMMu58Vbf4hXu33zIyxKOFisoJ5f/scWSqx8H6BMbPGIe/ahGvFrqkK0nyAASD3FIG3IRMKD3kDv5wCRja2tkalnOws9hefOmWOIK3LEWm1v3ITFMBfSTfAOLSdhWX+uPbxKhOJGxsQjSSJydnKcDaU2beiKXbq8jMOmuAckaqEtfthyiADqmtAoUXjyUJPEG+LUyW0oMb1LPr/3USmr/upKNhOCWEKwjBcejQj/+0hWGdIS9N98sQS7XX4YAz8waC7ucv7IQy3I0mJ1RnkNaS0HCnN8nEEBUDq175UhQS6Y4mdePAbT9RATB0gMxx6wrRWXyos85bw7BalW/JZGsqUMrz8+aRKeJHFrdfb3FlIoOwmFRgOiUUwAkemwF5P3r74ySa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(366004)(346002)(39860400002)(376002)(396003)(41300700001)(6666004)(2906002)(6506007)(6512007)(53546011)(26005)(9686003)(186003)(38100700002)(33716001)(5660300002)(86362001)(316002)(54906003)(8936002)(6916009)(6486002)(478600001)(8676002)(44832011)(66556008)(66476007)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I0zft/PEVzM8LsOEbenF4cBYnJ6QL4RNTEfmDTp0bnX3DPDC7NoRIzPm1b6p?=
 =?us-ascii?Q?P0aaf7o3bsketkzlnCLXs4YAgsHMJ8CgfQd4xVZWJIuahFVwCC4RX1m0iYiC?=
 =?us-ascii?Q?c822S2/6XpKoc7r2DeXz4jd2xAbZn35/bo7LKmFqg9T4M0zRzAmH4JFDzANH?=
 =?us-ascii?Q?od9arbq7DxqtttwXr371uvQA5L5UwHMrO0APYsrxsFsdc4cfvu80K1G7ryjp?=
 =?us-ascii?Q?RsmcrslwkOXGKE+B17CYYL79Ttl3TKc880jWOn2/tcJsdMC48M3q5UEAKMQ/?=
 =?us-ascii?Q?QuJ1VZwo/+g0AMbz9gNtrVqkN9zq/koB2QkdpuUL+AR7MLEGgjcH13PBUEzJ?=
 =?us-ascii?Q?3LTF0ClKLH1RFopH2OWZ1boU9Tp7gvnMwBVm1B0enybSW2zm7HD2C9LUdWzq?=
 =?us-ascii?Q?iHTBLeOMeaz+lsbtg5K1/ssU1DBMLfIfS1xwqJFq1SzIFvIsJgMxvj2k6ZuF?=
 =?us-ascii?Q?oYgOCAdJDTAf34xc/AhW76E2tmV47DePSC9SLdelng6SolpXtkiY6uyPNnrj?=
 =?us-ascii?Q?DqQ/t2VK3nErwfsceMcven1Yr6WOclVlHWPG0gyIoyc9/JfG1wmlhlzanLpo?=
 =?us-ascii?Q?0Dycr+yk2HlRG36BukztKNGjB70opbWYgWmy6MDinyH3HglkORtYMGnvERYy?=
 =?us-ascii?Q?mUhIqmvWGfEDwUGoOvVp9UTwMJ1tsRjbPA4nC+1ccDK6/cOkyCoww6SZgIJd?=
 =?us-ascii?Q?SO/qz/ZEZiqxvFchk6O5hdEe+9uneboUNdF0fEVcCCxJso+e4xjpMbsHH2my?=
 =?us-ascii?Q?DZUQYRHRGLxqGYL/p8/7oqw4CRUj6dxKP3tBwTaZA4gCvLHp4+aCvN+skuhI?=
 =?us-ascii?Q?0/qLwzEDST7Ah/6PoX97r+EFEh4Qwrv/XEg3r9PypMZBPMlQ94faQPErBO1D?=
 =?us-ascii?Q?crI/KO0S9StCGEzeju3wi89/XLy3V6YqjclcHjVEYqiX35wAL/NE1ubBK3eV?=
 =?us-ascii?Q?/5PJgdqRrpddORZv+D0aglWbuAT9sqYUBX22Y3hclTQ8reti5iZ7wvGeBPod?=
 =?us-ascii?Q?z4o+oAF3I+17wajT3dqdTRT3E38xZK49GJkdNWVm78AOL9iJ1XR7UtxRrf44?=
 =?us-ascii?Q?bpBSaetxtMlM2Wk3c21pNCbJU28xMmUuKdjC1UL8cszI5dAbu+JSypoFUqJH?=
 =?us-ascii?Q?fsEf3rcQR3NWoVuqXaMQSErjxodrwxIY3Kuyrny/URgQK3PHl76UdC2HqFAr?=
 =?us-ascii?Q?z6Nb+dl5LdYzEE4Ya/clWM2uMu+xpsvP9qCJqMXNMTd6qoUGsWOzeG5oo5Pj?=
 =?us-ascii?Q?drb95gQyyeqGQvqFqaQoizztKqiG94HPGEy2prGJW4arFWscMvC3IA5G3u6M?=
 =?us-ascii?Q?lYTyQ6NHUjMUEhzzWePIsNBcD9vaWVNXpduLGEqjTaCXGX5Li49Q7H9vAKn1?=
 =?us-ascii?Q?SeDeRwE1V+7vLWaWBk4ScgHg6MHyETT99LN2xlOh+FoOzHazd9nL2XZ6D8TV?=
 =?us-ascii?Q?qc2pFu0+FOfBhTyxTgpQ97MdNDhW7H8/uU7jJG/nc/H0lwpkx0PmacaY8j6+?=
 =?us-ascii?Q?FhI1RTPzpsJS3xluY5n6cCjc4o4MqoxEScTW8eNkB630jT4v6PhJdm0NRBab?=
 =?us-ascii?Q?ck4BH65g2jOVXNBgZK74BwUMfN4zGdB82cjjwkYS2y0x3oVotizi/97AjwHT?=
 =?us-ascii?Q?Bg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c60ae9d-1499-465a-d9e2-08da7711012b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 18:33:34.4928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wiMOS/1u4Lgrj0FRsGuOWyXUtbxV7+OoCl/xA/ufwbOPV7nCf30aOppEuXGxJhqGySq/jMIWIEVqDxFe5lnbrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1328
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_09,2022-08-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=973 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208050086
X-Proofpoint-ORIG-GUID: Hco8plQxIX8RKKrFvnqDnNP5LDNycaMZ
X-Proofpoint-GUID: Hco8plQxIX8RKKrFvnqDnNP5LDNycaMZ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/05/22 20:25, David Hildenbrand wrote:
> On 05.08.22 20:23, Mike Kravetz wrote:
> > On 08/05/22 14:14, Peter Xu wrote:
> >> On Fri, Aug 05, 2022 at 01:03:28PM +0200, David Hildenbrand wrote:
> >>> diff --git a/mm/mmap.c b/mm/mmap.c
> >>> index 61e6135c54ef..462a6b0344ac 100644
> >>> --- a/mm/mmap.c
> >>> +++ b/mm/mmap.c
> >>> @@ -1683,6 +1683,13 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
> >>>  	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
> >>>  		return 0;
> >>>  
> >>> +	/*
> >>> +	 * Hugetlb does not require/support writenotify; especially, it does not
> >>> +	 * support softdirty tracking.
> >>> +	 */
> >>> +	if (is_vm_hugetlb_page(vma))
> >>> +		return 0;
> >>
> >> I'm kind of confused here..  you seems to be fixing up soft-dirty for
> >> hugetlb but here it's explicitly forbidden.
> >>
> >> Could you explain a bit more on why this patch is needed if (assume
> >> there'll be a working) patch 2 being provided?
> >>
> > 
> > No comments on the patch, but ...
> > 
> > Since it required little thought, I ran the test program on next-20220802 and
> > was surprised that the issue did not recreate.  Even added a simple printk
> > to make sure we were getting into vma_wants_writenotify with a hugetlb vma.
> > We were.
> 
> 
> ... does your config have CONFIG_MEM_SOFT_DIRTY enabled?
> 

No, Duh!

FYI - Some time back, I started looking at adding soft dirty support for
hugetlb mappings.  I did not finish that work.  But, I seem to recall
places where code was operating on hugetlb mappings when perhaps it should
not.

Perhaps, it would also be good to just disable soft dirty for hugetlb at
the source?
-- 
Mike Kravetz
