Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC686548BF
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 23:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLVW6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 17:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiLVW6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 17:58:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E1927CF4;
        Thu, 22 Dec 2022 14:58:18 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BMLwoTL023535;
        Thu, 22 Dec 2022 22:58:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=HGSYslZAjz23WwkC0/oujmHDc4McAiz/kyLvLMKHUL4=;
 b=B6hobQ4rsro9v8qTveKIYmoodE1iKv0xKV1hV66i3ccRmzpSS/nyxPlc0IHT60mUAa1m
 W+dO97X3fgt2L5m+mSU4LbEe020HVcENeoxI4QlAa9vEH6wdmGOY6lVrOrVd+1TdICVn
 /xOGLpsW+baUaZoZSYC/26ClLNyIqrkgVDwIV9YhE3kGz9DIlIgVSpPRn28wSC0MjU3U
 qAxePfe3qTtRCCVWrCsy5qsPflzjCKBW99JuhKThmhvW6R5wcbjuNi8SNEnN4Y9GiFUh
 6JK7yuodQk80y1BsMS/plAAG5NxHGFiZFdS0gbVvwOpbEBI3j6f4Lwvzgs49Fk8I0yxD nA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tt4qpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Dec 2022 22:58:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BMMP8MC031965;
        Thu, 22 Dec 2022 22:58:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh47ewku2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Dec 2022 22:58:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpBbcWDfK/34V0YpXWoSqFWyxwR8Z8FTIo1jAryFc9vGXl0R/cPVS2OTUNBQPVPZ4Mmp70ybWhxKAZfGhRAHx0UZqPDTwVsk/T/KylCh2rqaYxPhEvISioQe2MrKztrsgkCgntqmRKrRMAZ0hHdEtoVL1T8HtdGuApOIzf+fUg1H77Sy4XVmwSUfT0xWbEwnumhu4wsLUZg2zHzAoafd8zV+XQCv7MKKbiy84aXJ2bsXxeI0XyaNFbz/lyFp3ElBFKSOTDkcHJDQpa7TnFQEr2wvJGCT+nRZYr9U2O3Sedp+k4rsiSzyTn6IECa3MaFjJH6yKqWf6L31zSz4ASRE6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGSYslZAjz23WwkC0/oujmHDc4McAiz/kyLvLMKHUL4=;
 b=U7R3CMTda0JSLoa//H9k2ac/2d83JCsO5MvbLAbNDtnkTbz3i1mKpesHEQauqwZsr+zXN0uJJX2R9HzbMsYfjZWNpaTQkncsCtIZVNcQvf2ZmeuAahVWK0nn073N5LUBVqwZC1LdazPnrHEMSxS0NTJpKymTRL/KHhv9VKOlFGFNom24ICM5G3HgrtOIiYmhIKSWzKFS1OehFF2FUklCkjwTYs2j/3qg+ynwyG5myybVLTyWZiaLa3vaGBbdEpqhzwGDWqW5idUMuW1H/e2kBpoE6fmb/yZI3offGJk3UTCWVZqJgeOK7NuaohjRzmLKM/Lu8krradtOjHVrQwB3YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGSYslZAjz23WwkC0/oujmHDc4McAiz/kyLvLMKHUL4=;
 b=BSPTHVLjkSOlw2Pn0V3gG6PTUtQFnIS4zf+RAGsNGmbEG62AlGmMfJPjvzC1JvJBIpIqio25HwM+J7dZ8b0ajs1D/xzycYCwcg9Y8TIFT0+/1XsGBGaH5K7NEnq31vCjYJn9GOc26/BCYkhEtpwaHzCJBmw971C6vfB+Q+ISHAY=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SN7PR10MB6406.namprd10.prod.outlook.com (2603:10b6:806:26a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Thu, 22 Dec
 2022 22:57:59 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%7]) with mapi id 15.20.5944.012; Thu, 22 Dec 2022
 22:57:59 +0000
Date:   Thu, 22 Dec 2022 14:57:56 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Muchun Song <muchun.song@linux.dev>,
        Miaohe Lin <linmiaohe@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/hugetlb: fix PTE marker handling in
 hugetlb_change_protection()
Message-ID: <Y6Tg9B6GQonjuN+p@monkey>
References: <20221222205511.675832-1-david@redhat.com>
 <20221222205511.675832-2-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222205511.675832-2-david@redhat.com>
X-ClientProxiedBy: MW4PR03CA0087.namprd03.prod.outlook.com
 (2603:10b6:303:b6::32) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SN7PR10MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: d5c66759-f127-4044-606b-08dae46ff8b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: koE8Q7vpkyby2pvM+xjaHFmIgizXBsFvb7G7FEactr45+ppaPCkrn6tCQVD9+H3sqUwsKMWGYzERqr2qvr2gtPEJZFDUpCxpxMAE79tOLqckcObYDriLSAJIFRsmo06YNt2AWz2QpdRQ1WVk7qysR08odOx/k+bMIQxqNBcq1FB/ZRRV8aZv1c8ieBxVHmB+JYwalQ+FBgRTsVV954p5EwCDh3XfmrO6KOjXjfQ/4Q9LaaYxthHGsSGHxSErGJRIzgcQFNrbJcUPmdEpIKMC8xlllrpxiw6sw9OC+fI5msGEZ5V08qnJ84rGJb2uRBzbZ3lG/2O/F+8Nj2kWhn4EXtTJaWtvTHUPFAkXyQYEouQk2TqE2OpSRfKZxAkRU39w6LumMTuCSBK2dwfZjSno6ZLGhcWkkGGK+J4nj7IvAqCf86DTav76n4EXn9kIxLgzfDPHSG+7tp6x75P+Y0WkWI85Sb155n/ZcIgChujlq5trkbrqiCyWlyISOr96r9j90rvVEfvbZQJ1sS4N6vF3rUlrFquTJCauR92voGEo94FUZ2cSuc9zY0th9ZvInaKBRkMwTBINUgKYjWFBEUtp91QODDlr+wfGVKncXfEh9bya/IvwabLMlh9oE04Wt/vgx/xowwUiqIzNn8casesomwXh/68Bq6si3b6BiHsr5LyhcC+v8XzgakxwvUq9jrij
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199015)(41300700001)(9686003)(186003)(8936002)(316002)(6512007)(66946007)(2906002)(6916009)(54906003)(44832011)(86362001)(38100700002)(66556008)(66476007)(5660300002)(83380400001)(33716001)(8676002)(4326008)(6486002)(478600001)(53546011)(6506007)(6666004)(26005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Vt5MIAXJRJ2ZQ2ej0Mpd0H/x/f0jX0DWeBWdrIkWveAOzF8aUxXj0KhiBZW?=
 =?us-ascii?Q?L1JEXZt2EJ3xTVWV1iTO9GrtT1CAQJA6yROK3vUTIh4EJ0wovdipYwwWcMR1?=
 =?us-ascii?Q?wgEhn7461Sf+DFZFWJau9b6jK6m2eowbDNmwZBU6PpUdkghhgCrjTBxS8d4v?=
 =?us-ascii?Q?uLdE38CNrPepKpTBWAN9a6ON9bHm/eI5+UA88e6TEGdUHcX2IZP0GqeaseTh?=
 =?us-ascii?Q?HGpEovK65ks+a+vA2tzLFAZ0AfFTvxWJrXS1s47fr18tAbJ01pRI8/UsaC34?=
 =?us-ascii?Q?zO8Oa9fkq1e9NLB9ADEhl2KhnSz2dpliTzgCKRT/nsCnym3AN7VPD5Xd1gpg?=
 =?us-ascii?Q?ipHqj6o5UCM7Ly3EBPYBjdmJWsM288VFhSiJ6+Zf0mNXes5+BFFl+s/qU/wt?=
 =?us-ascii?Q?CFByUz26pF9h/vK7oT8qvyZEBIPoYy943y5m2s62qrlF8iRUlhhUktfAu4Lk?=
 =?us-ascii?Q?pmvhTWAB0ukPa2xMhiD0gX+gr2ejvfko7UT2EH6B09kVfWB+DUmQrdChfP/g?=
 =?us-ascii?Q?jpqZ62j18TPFeS/JLcE4QcO9/FfidVcf086MJXkHry5N2+g068kSNxRTKbQp?=
 =?us-ascii?Q?F+11QArNzAzoYc6YIdnA/IARCA3X/hxqw/inH8NqbNckundxGJrQPSOGI6DD?=
 =?us-ascii?Q?YwRPYSnipYtyIuffg+EJy2SxrCpXA+YoCBTIQp7WrIU8KEsGLDVIoeaQ1S/G?=
 =?us-ascii?Q?ajEm8C/eULCWqbKcsDIMutG15pDbswC9JgRBIR7YvDEQt1NQIAdmIPmZEwj/?=
 =?us-ascii?Q?eXGuTlQ0EqGRylHnjUninaJrf9GVaahek1Px1GpNYofAa/i/KD7RBc5kOahh?=
 =?us-ascii?Q?MNhtlRtvkoRB9NaRYOxsXgtT7JG3Yz7nRpU2yL43t/DRc6s+DpCr9p//L1ub?=
 =?us-ascii?Q?GMrpm+RP0FVGHKxyD0bgXAlMnCb2cvYxoCGbDv8F2uFf3YDrtXXCP26ymIxA?=
 =?us-ascii?Q?NCvKEzQrJSHwGorLRVqWOwe6QJguAo/PaLA7tMB0+gm8HYq/ITCwEQo4NrjX?=
 =?us-ascii?Q?aA1fQKwuGvxBHHaIORkhy4JIkoWiL4rd8NjOi7sYDeUY3w2Wra/5NmSUOZKW?=
 =?us-ascii?Q?geLXyO3R7CG3rRcaYwMT7GI29kGK+KT6kIabe57e1AKajhQlHfijagVVQ6Yr?=
 =?us-ascii?Q?DOE0K8LT8Pas0whQjrAX/d6vqAO2zKxiYPWK7XozQSI1neTSswb8+5AfYhW+?=
 =?us-ascii?Q?E24QvyIDNg7mGA3uT34hYzJE0nBjEnFgxhtlhsOmL/+hRfNyFWslL7dVlLiX?=
 =?us-ascii?Q?e7X5Pp4/g5uH4Uo0Q9XuBlCSrnpz1V+6Cq0jwG6hFeqJOXDpAOEtebTfrynT?=
 =?us-ascii?Q?FVpGSRB8FARWCKh11dcG99j/TQJoI11+057Guz/HNldAzhHIpiwrbWO9e/uP?=
 =?us-ascii?Q?/rbb2FIYt1kO2MsLKjIgGKnByESr5VUJjKStQ06/yLMVRs0LfGxfu1OaIWdp?=
 =?us-ascii?Q?sy6FSj2ppyQYPdGGMyd7gorQ982ew1jYMZUhTpaaA8Rjxi50m8UDh+x4Zj4b?=
 =?us-ascii?Q?5c9lZs56O5IyPokDqc7LIK6Hd0JlkZuzarr3O5VcuivPuNkSOCpqH4wm3Nkn?=
 =?us-ascii?Q?NoOxmV/ZRGKpUh19mz5vK1uPHyMOTkvddO5jebw0NlYHp0GLXCsuipxRWYDe?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c66759-f127-4044-606b-08dae46ff8b1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2022 22:57:59.2941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jtcl1XPIw89xTmkqp3mrI/iKpE7auOVESm1kkhtOR2xhZzd9+aKSweq1ehNlbM5U282lmpm+p/pkP2H29IBMWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6406
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_10,2022-12-22_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212220194
X-Proofpoint-ORIG-GUID: 5Kq_ivrMXtXuIpDUOhKHpuVJ2Qbw3yyU
X-Proofpoint-GUID: 5Kq_ivrMXtXuIpDUOhKHpuVJ2Qbw3yyU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/22/22 21:55, David Hildenbrand wrote:
> There are two problematic cases when stumbling over a PTE marker in
> hugetlb_change_protection():
> 
> (1) We protect an uffd-wp PTE marker a second time using uffd-wp: we will
>     end up in the "!huge_pte_none(pte)" case and mess up the PTE marker.
> 
> (2) We unprotect a uffd-wp PTE marker: we will similarly end up in the
>     "!huge_pte_none(pte)" case even though we cleared the PTE, because
>     the "pte" variable is stale. We'll mess up the PTE marker.
> 
> For example, if we later stumble over such a "wrongly modified" PTE marker,
> we'll treat it like a present PTE that maps some garbage page.
> 
> This can, for example, be triggered by mapping a memfd backed by huge
> pages, registering uffd-wp, uffd-wp'ing an unmapped page and (a)
> uffd-wp'ing it a second time; or (b) uffd-unprotecting it; or (c)
> unregistering uffd-wp. Then, ff we trigger fallocate(FALLOC_FL_PUNCH_HOLE)
> on that file range, we will run into a VM_BUG_ON:
> 
> [  195.039560] page:00000000ba1f2987 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x0
> [  195.039565] flags: 0x7ffffc0001000(reserved|node=0|zone=0|lastcpupid=0x1fffff)
> [  195.039568] raw: 0007ffffc0001000 ffffe742c0000008 ffffe742c0000008 0000000000000000
> [  195.039569] raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
> [  195.039569] page dumped because: VM_BUG_ON_PAGE(compound && !PageHead(page))
> [  195.039573] ------------[ cut here ]------------
> [  195.039574] kernel BUG at mm/rmap.c:1346!
> [  195.039579] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> [  195.039581] CPU: 7 PID: 4777 Comm: qemu-system-x86 Not tainted 6.0.12-200.fc36.x86_64 #1
> [  195.039583] Hardware name: LENOVO 20WNS1F81N/20WNS1F81N, BIOS N35ET50W (1.50 ) 09/15/2022
> [  195.039584] RIP: 0010:page_remove_rmap+0x45b/0x550
> [  195.039588] Code: [...]
> [  195.039589] RSP: 0018:ffffbc03c3633ba8 EFLAGS: 00010292
> [  195.039591] RAX: 0000000000000040 RBX: ffffe742c0000000 RCX: 0000000000000000
> [  195.039592] RDX: 0000000000000002 RSI: ffffffff8e7aac1a RDI: 00000000ffffffff
> [  195.039592] RBP: 0000000000000001 R08: 0000000000000000 R09: ffffbc03c3633a08
> [  195.039593] R10: 0000000000000003 R11: ffffffff8f146328 R12: ffff9b04c42754b0
> [  195.039594] R13: ffffffff8fcc6328 R14: ffffbc03c3633c80 R15: ffff9b0484ab9100
> [  195.039595] FS:  00007fc7aaf68640(0000) GS:ffff9b0bbf7c0000(0000) knlGS:0000000000000000
> [  195.039596] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  195.039597] CR2: 000055d402c49110 CR3: 0000000159392003 CR4: 0000000000772ee0
> [  195.039598] PKRU: 55555554
> [  195.039599] Call Trace:
> [  195.039600]  <TASK>
> [  195.039602]  __unmap_hugepage_range+0x33b/0x7d0
> [  195.039605]  unmap_hugepage_range+0x55/0x70
> [  195.039608]  hugetlb_vmdelete_list+0x77/0xa0
> [  195.039611]  hugetlbfs_fallocate+0x410/0x550
> [  195.039612]  ? _raw_spin_unlock_irqrestore+0x23/0x40
> [  195.039616]  vfs_fallocate+0x12e/0x360
> [  195.039618]  __x64_sys_fallocate+0x40/0x70
> [  195.039620]  do_syscall_64+0x58/0x80
> [  195.039623]  ? syscall_exit_to_user_mode+0x17/0x40
> [  195.039624]  ? do_syscall_64+0x67/0x80
> [  195.039626]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  195.039628] RIP: 0033:0x7fc7b590651f
> [  195.039653] Code: [...]
> [  195.039654] RSP: 002b:00007fc7aaf66e70 EFLAGS: 00000293 ORIG_RAX: 000000000000011d
> [  195.039655] RAX: ffffffffffffffda RBX: 0000558ef4b7f370 RCX: 00007fc7b590651f
> [  195.039656] RDX: 0000000018000000 RSI: 0000000000000003 RDI: 000000000000000c
> [  195.039657] RBP: 0000000008000000 R08: 0000000000000000 R09: 0000000000000073
> [  195.039658] R10: 0000000008000000 R11: 0000000000000293 R12: 0000000018000000
> [  195.039658] R13: 00007fb8bbe00000 R14: 000000000000000c R15: 0000000000001000
> [  195.039661]  </TASK>
> 
> Fix it by not going into the "!huge_pte_none(pte)" case if we stumble
> over an exclusive marker. spin_unlock() + continue would get the job
> done.
> 
> However, instead, make it clearer that there are no fall-through
> statements: we process each case (hwpoison, migration, marker, !none, none)
> and then unlock the page table to continue with the next PTE. Let's
> avoid "continue" statements and use a single spin_unlock() at the end.
> 
> Fixes: 60dfaad65aa9 ("mm/hugetlb: allow uffd wr-protect none ptes")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/hugetlb.c | 21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)

Thanks for the fix, and restructuring to make the code more clear.

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
-- 
Mike Kravetz
