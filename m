Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1847461FF17
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 21:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiKGUFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 15:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiKGUE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 15:04:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8026B27DEA;
        Mon,  7 Nov 2022 12:04:33 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7JOKLl006548;
        Mon, 7 Nov 2022 20:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=7agR3pXB0OaoJ7+T7mr4z2J2OqKKHGTJUdnUSY4SA1A=;
 b=IQTdrGpZQAj4GzgJtzZeyuq/HjZzehwB1hAT/Vd3VzBBqf+wvOkJfgswbKpHju4TwED/
 N+DRHedE+j5sIpr3b424ETWG15BuLuBeFrQrNr2b4eAMvlSNMlLFmsEohUFFw5Ql3OL1
 tvvZ5Po8D45NG2cJgDnhhNP3rPzsL9iFRXK4s555kWscKDYQprot+b/X/H118TQkQ0kw
 B/xeu9Nd3uhMPJtKGCnm2CQJ7aRKx06ikC1Redhep6SnvtdmmNg0tSSUocvp+gaiU8T4
 Oqh02V6TYUb6T1pi9V8k8YZfHZ5rBcTs26bzRhJ4abCMkVS1dYYhmAheWiqknPcZdkkt qw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkfw8cd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 20:02:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7I932r030139;
        Mon, 7 Nov 2022 20:02:02 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctjncuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 20:02:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nh0qfIc7q8WS90wJWIYZmml6UOJFhdMBCHJ6eCELuuoklTMuAxBr29ea9/l9vWwGXWkBocZMkejPkQ+XzUZK5Ke8rXyYfImOyiiuqZ5Qt8TEW3y2YGe33APTRsU28BCeDmpaWkBgfZ7St40EJY2+4NyHMeUw9jdxuSR27wZux4yEO38WByXyK/VjacRe0x+vP2zTRmDp5B/lusaYyScLs5A9r3+GxzXBAlh2WxrsLBpYUF3FZl1Y+6ZOvO024CTqTVEN/KBURX/2bDViAu3eIKP5WCULsKW/H+e9y327K0F/wcrtPtkEmbt0YppMqX9v9J32It1a13uQ3PxVD6phZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7agR3pXB0OaoJ7+T7mr4z2J2OqKKHGTJUdnUSY4SA1A=;
 b=RaopuPcdX7t6/BiYs2GHLJROd6X+tP3esrMjLZ90egC7/c0c2E45w9LMcKeuV0ZsdZSrRzy0R9sg/HjNydB0ci3k2Qodv6JzOMkYWl6XMapF1cL2c1+qCNymAhpYW/WXaGHFiB3kf5UROp0im0OMzt/inYxWxESyrcr9RTKNyN4R21UkWIqyTREVpvV9a3OhNt3dKhecWcID0v4Hjo8/PDZkIJn5XRH8DkCK169H3LkeIDx4x5WWZFhWPQHGwaoWGA+nCnTcbMToCxBvoEBTtm+Ccdza8LuI+Koc03L4vbdZX2kNHpTB7ct4C4GOZunxOBnbUU3ILDqtotpD9CKTFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7agR3pXB0OaoJ7+T7mr4z2J2OqKKHGTJUdnUSY4SA1A=;
 b=QVtoWF2rI4SIaQmrfHvNkg3YjlH2h4KuhnJNeMaccmNqPctk8f+xF7sgp7MbqmBNgp4/hzRoMVlw8PL1vmNNoSfoZWLVdpvfalVpE4x3qq0fJcAHe7H/GEegaPfERtUElY0Nu8JBG6yRGVroCzx/iBBxrlISoY7YF4tis4I6RLU=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by DM4PR10MB6888.namprd10.prod.outlook.com (2603:10b6:8:100::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Mon, 7 Nov
 2022 20:02:00 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 20:01:59 +0000
Date:   Mon, 7 Nov 2022 12:01:57 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>,
        "# 5 . 10+" <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
Message-ID: <Y2lkNXC9cEYqPugY@monkey>
References: <Y1vz7VvQ5zg5KTxk@monkey>
 <Y1v/x5RRpRjU4b/W@x1n>
 <Y1xGzR/nHQTJxTCj@monkey>
 <Y1xjyLWNCK7p0XSv@x1n>
 <Y13CO8iIGfDnV24u@monkey>
 <7048D2B5-5FA5-4F72-8FDC-A02411CFD71D@gmail.com>
 <Y17F50ktT9fZw4do@x1n>
 <3232338E-77BB-42A8-9A25-5A4AD61FD4B2@gmail.com>
 <Y18oagswntNCEszs@monkey>
 <Y2LD1Vxt3vbChUyD@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2LD1Vxt3vbChUyD@x1n>
X-ClientProxiedBy: MW2PR16CA0035.namprd16.prod.outlook.com (2603:10b6:907::48)
 To BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|DM4PR10MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fb386de-289b-4ba2-5b53-08dac0faee36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1rGIERWEZTEqIVNVmGQeRPeurEwOD4Xc8ep4mU50m8CdGiZeFyT12iqhwcvjdR4eEbyaSbjlqvM70Dv0iG+18AK1LBhirbIWVUrEs+eDLaarJM2HmFi2MNe2DpAvxf+D0gGAqGNkYsIbraIh+hycpayu+0T448nYYgi94bcHtCA8hgnPh4Jn/1vkynzV1buDog7UzSsXuqFzDis4+mrFqMoZNsOGs8WRiQbuTK7kjd/F/yNUkkeczMeqhlHnazFxDyYtJu7hoHmL6MX18W7dINnC+m37UdvTNItYqcE8QRvfXhrlM+lp+xuQBYTIKY9ZQTIxp9l2e3DpzmCKb4F6sjNyNLDjia/q8K8W1ce4LujTDQapFA8164VxrYlpryV7qUp++XC97Q/odojYTKvXtm/dK2u59je1YAU7h7LbVcR9Ed1beZOa9eJprqAzPXfgV+wowIIx9GhfSACAU0nlfM6vRfjlhCKITtWbN+EzmiGI7w58SvDfEbA722rLyHbIVl41IaLAOSverD8TqjL8u7yuBRhc+OCe0q7qubUovMb+2VAicu6BVQqpuKfjmwfeSsdyuGBuWYyr6FspCh9rFVO/f6MMiiwA0dSDurLS0Xupy1lvvlp3vuHhQZ9u+HxOmEjIuVZf6ExtoJhv7Ug0+GpKqI0C8g6dDybnH7CqloGdfftAalSjCr58AYj1ASl/M5WXNhEXvaJfrSP8oFxGZYJ2f/XBMalQICE6Fqho5Eg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199015)(41300700001)(66556008)(66476007)(66946007)(4326008)(8676002)(6916009)(54906003)(83380400001)(44832011)(6486002)(8936002)(966005)(478600001)(2906002)(316002)(7416002)(5660300002)(26005)(9686003)(186003)(53546011)(6512007)(33716001)(38100700002)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BqTq2x/OpPBEgiDSA8xFJX/iLc+OcSEeEZpyP6ajVlRFvfhFrpE8HalfOtoZ?=
 =?us-ascii?Q?wW6WTRn2+WTQjWS2DGfq3lz247vb/rUxrm3Zw390clyRZP/7U2m2hCk0U9mW?=
 =?us-ascii?Q?Pz6bejCmdEwFBxSQny/buyAYqBvDINT8eKyck+hzopFJOhMO0XLnWI5zOeIp?=
 =?us-ascii?Q?dhebAghkmB2dV0FoJxw+TK5+uwQFww2UU4S7SO1no9gy+vKHzjHny7A4HR8H?=
 =?us-ascii?Q?9sqjoQLVTJy74MTOSDanGueFpGFAvpemFAHZQxeFnnez61fz31F1gKKyHcba?=
 =?us-ascii?Q?UhBPxFBc9Ah2fw8w7V4Jr4KueBDUXEROSStUcaxc51mHyk5MMRwRUaQA+dex?=
 =?us-ascii?Q?F2YiypbpnggbxuotXrw3wpmQqvFpkHP0EhEWcNmghWUKd5I5PtpWreZsS1M6?=
 =?us-ascii?Q?l9SH5ltSVIP6mr3xpfVpvgFcBSBUM0n78IWccR4zXuFAb2j45YqFEpHvDjI/?=
 =?us-ascii?Q?m0wbVqKZWqihIhNhVitr3BeilBzcEsV1N8B8Z9UBgEFNHYfyfyqDytpoouOC?=
 =?us-ascii?Q?MK75VQXBKnKAYi/TKVm5CzalSNqYkHmUrp3XhuzQ6vZ1pqWkoYB/soCBqZVr?=
 =?us-ascii?Q?on4fNtIs/9fxEwSeYYBIR1ShWlLlqhWMBxRJNIfnGtbCkc/L5WZ+qE81vrnX?=
 =?us-ascii?Q?r8ealS8nO2CHlYjaO+oWk1BxrTYVvVdhMhv5iyJuZe4uuEZKRQr46pLUYccs?=
 =?us-ascii?Q?XhNYaZGTNutiflnvyVjRMnyPfDQ6DgeIOA4TwXzrmEpzJEYIPP3qP6UiB3I+?=
 =?us-ascii?Q?M3yUxkJVGJcILNWmAhGhHYKyOwCH766OG1txm6LHLU09R+vrgKlUvTCbMp/c?=
 =?us-ascii?Q?kvIHF8yC9VNmQMcTI22LmekwOxFF9KJD6DyzpzCPEVyCLbFT/Z1VmiOGiAUH?=
 =?us-ascii?Q?DaC2csFjSzhcMSC5+Qh1o+LgiZHeCxrPjuM/R08xGaL/dbxjRy4GkntECNVx?=
 =?us-ascii?Q?CE9FVZ29tRd/AbXrj0vAN6uoLfuGOXXkhTAxZWKrrSc9d9AG+rt1YBNUNIPP?=
 =?us-ascii?Q?nBCr1Q+FIWbp0qPNofUQRTzi1VmtFjIu7Ou/BMmb9+GSh+z1KU8zl0ov0X1H?=
 =?us-ascii?Q?SuOSdccCmXz2IZS/YFM66oSeQ1mRFaD8TwTKG9NocP7ryqybevb4KeSpsXxj?=
 =?us-ascii?Q?rvlXAjFT4U6GcTP6dmQys98LgeDEgd6uOOHWA2pJtc8dX5PA+/S2qClg6XAl?=
 =?us-ascii?Q?MGHRhJhKYxTnqoRKLbahuqK8cQjFSROwDVETzAmjpWw6n0IUgEbR0X2mlzkr?=
 =?us-ascii?Q?RIh8gcx4parbQucigXt3mLbIriLA/nkDohD57/ibUYuL7H8aYg+YBfu/2f3t?=
 =?us-ascii?Q?VVF02AfX1XB5MH8gR9D4lC6GXuJcFO8j+1Me7nElb4YCgwxgN7u1k5ORM2YH?=
 =?us-ascii?Q?CDcM8Wk6+if/VSB2Pd8PFyquyehBlu5uArnYznR4e/bpmHuLUoNMnTklgHqz?=
 =?us-ascii?Q?XmN2xD8C9V5cjfK9ahnQ/cWNzsbX2rqeP7dd4zU3/vGbxhITPFmHDIwrtaXx?=
 =?us-ascii?Q?eN+TAZXOEhBZLYVWkYTx0/dV+GT3IZvPFbwHMFYRVN4FUOb/1WiLn6C1LCzP?=
 =?us-ascii?Q?VSbq/96fRzYyfcVDQOLIV8LPhQyh9ZMEmyswZ/aLeB4EoAc4baDXD7Qhr/NI?=
 =?us-ascii?Q?qA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb386de-289b-4ba2-5b53-08dac0faee36
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 20:01:59.9586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLtJgoGYd62OTADcxLiUvAHo89bUdbN9W1VAPGeJG05Ed24/kAIYSbO2P1HIQg1ofGqdrdhr0B3hQWC/6o5ezA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6888
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070157
X-Proofpoint-ORIG-GUID: 2tRePQAx5xvsO7uktDZ7M9iq860bz9gH
X-Proofpoint-GUID: 2tRePQAx5xvsO7uktDZ7M9iq860bz9gH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/02/22 15:24, Peter Xu wrote:
> On Sun, Oct 30, 2022 at 06:44:10PM -0700, Mike Kravetz wrote:
> > On 10/30/22 11:52, Nadav Amit wrote:
> > > On Oct 30, 2022, at 11:43 AM, Peter Xu <peterx@redhat.com> wrote:
> > > 
> > > > The loop comes from 7e027b14d53e ("vm: simplify unmap_vmas() calling
> > > > convention", 2012-05-06), where zap_page_range() was used to replace a call
> > > > to unmap_vmas() because the patch wanted to eliminate the zap details
> > > > pointer for unmap_vmas(), which makes sense.
> > > > 
> > > > I didn't check the old code, but from what I can tell (and also as Mike
> > > > pointed out) I don't think zap_page_range() in the lastest code base is
> > > > ever used on multi-vma at all.  Otherwise the mmu notifier is already
> > > > broken - see mmu_notifier_range_init() where the vma pointer is also part
> > > > of the notification.
> > > > 
> > > > Perhaps we should just remove the loop?
> > > 
> > > There is already zap_page_range_single() that does exactly that. Just need
> > > to export it.
> > 
> > I was thinking that zap_page_range() should perform a notification call for
> > each vma within the loop.  Something like this?
> 
> I'm boldly guessing what Nadav suggested was using zap_page_range_single()
> and export it for MADV_DONTNEED.  Hopefully that's also the easiest for
> stable?

I started making this change, then noticed that zap_vma_ptes() just calls
zap_page_range_single().  And, it is already exported.  That may be a
better fit since exporting zap_page_range_single would require a wrapper
as I do not think we want to export struct zap_details as well.

In any case, we still need to add the adjust_range_if_pmd_sharing_possible()
call to zap_page_range_single.

> 
> For the long term, I really think we should just get rid of the loop..
> 

Yes.  It will look a little strange if adjust_range_if_pmd_sharing_possible is
added to zap_page_range_single but not zap_page_range.  And, to properly add
it to zap_page_range means rewriting the routine as I did here:
https://lore.kernel.org/linux-mm/20221102013100.455139-1-mike.kravetz@oracle.com/

-- 
Mike Kravetz
