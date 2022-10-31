Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACCF612EA9
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 02:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJaBqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 21:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaBqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 21:46:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B955F5B;
        Sun, 30 Oct 2022 18:46:40 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29UKliq4008910;
        Mon, 31 Oct 2022 01:44:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=JBXwSiABG/nDDIvkHULUf99C/hmk/xUlie1/qOIMM3o=;
 b=nsV1WcX2nGxdEeziXEAtYBmg798Q/p9UTiekLDqP3yfCtPMyvpMvpJ+zZ+A+6n4fBg95
 KK99X9ZjtmEe6cpqGUNWSWJC/MVYRwFjHUDE43KN49PK6PjY3h9L9J8Z6lEmdXew4nGK
 M++v/ydFLHi9T0FyiduvpYUaH07cZHNFBNbVdBF0rKdWGIRWlr1Lmi+F2BK45JrILe8K
 jXmcNAQB+A5Blo/sxXSZjljUcuxOepaYMmyM4QGKU0xJ2WvjRqsQVKk2wLQdHaXMOC3e
 kTRuInykjjg1GO5+L8b9u9mp6aR8/Um69tY3lrozv6ZRo8iZYHrE61XQ7X3Vki4eaSHK wQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgty2t62e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Oct 2022 01:44:18 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29ULMXZV010190;
        Mon, 31 Oct 2022 01:44:18 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm8r13p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Oct 2022 01:44:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMmDBAUpVCWVpZ0UXIPpjFCX2bdZnP9Qc14o6Y7G8rq90AslGlhx0ttiLLW6D1CkImAHRogopqNLl6gmcqE6HKZdTY3ALSxMuKUtwlCUm1NEMWVbXPIRmSLSLzxJlM7PLJSMvebSlVLgnQJu323cPtlcIRUGuBk9o5ADqJKAuhrxNYINtYzhCmFDGc0X/SO5+3bakTiSaTQrx4DQ3dHC2OEoZwxps4LCDjrVCtR9uCeZ/y3xlgPmL+Pb9g9aLCHVfponVeePK7AMpVD6Nubwr96SOeJkZu4paYrAGildRS6wlrwl+dBFufArSmYKwNFsBRsEoYuaWxfkeYmYb/rqsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JBXwSiABG/nDDIvkHULUf99C/hmk/xUlie1/qOIMM3o=;
 b=JJvo6GEaIrxQ1WYZDTkmQkhcdgVG14+ngi/bZfD/p82mam2DfPKH4V+wsyxgV00JnIe03nBERZVBoLMHoMs409ZGFfgLS6r+Ss/kh3DO4jms4VVVjARC6pCEE3f8llyzOad6x5dWX+NEzKQTCtkbsiAeo2KXwuNxL16Xs+8yTV8HVebf/6OVf5f4YKZo0/3v1w6hIOOn5KURKIfRq5zL7VuO/DD7U2W+RIs8/pFp+XlDID6TNoK93FRpbKGWs+5/1FjdBXxqT8IoeLI3fgirBdr5nEtUUizEbKFJW7QziiLEs9kTbyj/jhFSoMV4LriWPkifnTGZOESJJLtr2SVr+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBXwSiABG/nDDIvkHULUf99C/hmk/xUlie1/qOIMM3o=;
 b=IyNlsH4TW/rjgni6UxwhLV0eFIFuQqwEBuyaR35hDtMSzcuhN5jqAHWXtjhViZ79ubfOWnMsqSpQBs4CCsbHgeVVjzDYWuDFbuPmCXTwEgxxG4iMZY8WEpcHxdO4Sq0vpa8dcLwIxvS7m0xvVWnGQGY5i3DVhapn69WqNcoxIb8=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by PH7PR10MB6155.namprd10.prod.outlook.com (2603:10b6:510:1f4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 01:44:15 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%6]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 01:44:15 +0000
Date:   Sun, 30 Oct 2022 18:44:10 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Peter Xu <peterx@redhat.com>, Linux-MM <linux-mm@kvack.org>,
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
Message-ID: <Y18oagswntNCEszs@monkey>
References: <Y1nImUVseAOpXwPv@monkey>
 <Y1nbErXmHkyrzt8F@x1n>
 <Y1vz7VvQ5zg5KTxk@monkey>
 <Y1v/x5RRpRjU4b/W@x1n>
 <Y1xGzR/nHQTJxTCj@monkey>
 <Y1xjyLWNCK7p0XSv@x1n>
 <Y13CO8iIGfDnV24u@monkey>
 <7048D2B5-5FA5-4F72-8FDC-A02411CFD71D@gmail.com>
 <Y17F50ktT9fZw4do@x1n>
 <3232338E-77BB-42A8-9A25-5A4AD61FD4B2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3232338E-77BB-42A8-9A25-5A4AD61FD4B2@gmail.com>
X-ClientProxiedBy: CH0PR03CA0299.namprd03.prod.outlook.com
 (2603:10b6:610:e6::34) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|PH7PR10MB6155:EE_
X-MS-Office365-Filtering-Correlation-Id: 435c7a0c-ae45-4591-9f3f-08dabae16afa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xa3vkNFCHqjTqgPzlbexaOd+xcbqBxF7vYxFM8nJYOHlruLD5vYPzwHqTDEwLDaMEoPiPin9N0NXl/g67GyudZEgtI/xQe0sl2WCNC1IDJF7C7R2jTTbg3Q++MiGWPeZDDDDBIzOC2T/GWOaBcp5pi15boh+QSyPbt5DMqxohUTQ0EuKplbDr4lylyvIdZEcetitn2A9bdYMdW+w/1hkdP2E5+CIowspOsAOorqTkvCxQed7fs/ZCcDMoyIaJOIusbDkqwMrmSitrzUwSi4KSmI05bfE5YOR6ISV8FwumFwO/G4a+TrjW5Bq6UtvQgZk+w+LhUlJKzb/QZwqG96/aLLwLPkJ1gnt0zut2mytpmnIUOknw3OCa5ArIOeIq2UtH0wuMYWmCWOHhI/M05/4oZyu+PzeZfNd4Cm7UPUSgPhVLxtri59WoRgKfWW8MbwacfSmr+f8tmVi94jFeZHp8BQLr4Sijl0FnlXL7EJIhJscdxd5+aMymMxvlstu5v0yIm6Th8LBFFRlGCtnwVlwmaFGpmMheFzODpiyDFovrNoM/9kxDtgZt28RA/ovBiSoALHM5+kVPu77f17qSnIQqYBcOVGViVENCgROyiFbqsiIeOHC/UjT4SakGwnnX9Gkh2gtU6C7EcZ9z3w33rxBgXrLWdxUvElU3nx9G8nIdg2iq60wqw24DWtc/XcvsCVoVeRJFtTXQhFPMAU39RMdTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(396003)(376002)(366004)(346002)(136003)(451199015)(41300700001)(4326008)(8676002)(66476007)(66556008)(44832011)(8936002)(7416002)(5660300002)(66946007)(478600001)(6486002)(6916009)(54906003)(316002)(83380400001)(38100700002)(53546011)(6506007)(86362001)(6666004)(26005)(6512007)(9686003)(186003)(33716001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jh6oMbn+RCA25CkVB2ubfGk6/3WTJ0wDFkvGtWCekzO/kRYj34Tn1nYPJOdt?=
 =?us-ascii?Q?dhR/f2FqJ/2F+IBGe0A41SojfE2M+cm4B1FO1b3/OK5l303aorsnGM5tsVFN?=
 =?us-ascii?Q?iXMRjnJU0RZWd23txN/DYUmmdYih5YilqWpZwL84V9SMF/tRGjNuf29Oj0MC?=
 =?us-ascii?Q?U8IeNrwz/uVEAJFfl3XXZucY82pB3Wtrlsz+pADUHCSoj+pTuV2fAN0/7NiA?=
 =?us-ascii?Q?CUeWkAusZDgrYu0YrFrJuhG+cMsXfc8Zquy6aEXIDGl8gJ2DBw3DUgQ3FuG/?=
 =?us-ascii?Q?YfRKGaxYIWUx05Z8vlirgNeazqBoTqwRPT/NJvZVosGENlggshoqQA3O8bvs?=
 =?us-ascii?Q?q4ihVUWuL/6wSHADuL0xZjAZVvMuWOyXR6on4GRLzGufjSuYCQeQlOfpQS6D?=
 =?us-ascii?Q?NQXZahUF/eqDzxhsI6cspASq+vnBhhJbwLeUT9+0CdW/OpdvBdHmRS6M2j7N?=
 =?us-ascii?Q?fZu6LQUmhKBt3BNQPm5Utg6vf1VKHv6oQ0mfGt/ZWnUvqz9exfpTnJPAVHqn?=
 =?us-ascii?Q?ftCAeffX4FyClqW6IRUW1nGdrXRm8U1wIgt4j0huyelfzhZPd1P09l4E4/5g?=
 =?us-ascii?Q?MGqw8gBcaf+uuY/4e1k6Yk5O05+0mCSaPtioAerHxQUtX/u68SyytjA59yr3?=
 =?us-ascii?Q?Tcu5W+weE/JECZncur8+R2x/yoRxtWWcocP7XAiYB3xYxSfEuJdW08cusMnz?=
 =?us-ascii?Q?+kBm2bFNYeM8g/9WwOaxqMwWGdZWERy+12P5Cq3fC0oVYaamQeTvEd+GcDyx?=
 =?us-ascii?Q?82XGd1VWWpV/2d/oTZGdgBaiuHzrZFnX35du1d1Oe08eal/7u3W6r26xoFup?=
 =?us-ascii?Q?zRH4yRSzK4DU9mpLGf9v+qutPdb7kYjQ6auwopRtAjvLUEBi/eEozJJNElAH?=
 =?us-ascii?Q?/zCXFf97JWWTL9AlF5N7hr5aIMsNG5W+3ohGDFbgQIKTh85B/uSdn9xOQYZC?=
 =?us-ascii?Q?IpGdax3UwHWueTkf+voX379SqJw8mcL4O1plHSj8+jxhMaI5yKlxUTofVVYF?=
 =?us-ascii?Q?F8GJDGm0WEiEh/7xNLnXOkDTlle6vrDGGeZCFSbOcQ0ysFratS0CWzBQRcXe?=
 =?us-ascii?Q?5++EOP18rhOFWMruzgMMJTEgkDq8kXFfaf5lfNUMcBKfNHKv2CbdoJkTisqZ?=
 =?us-ascii?Q?Rx9igIYG/wjWVBNM9injnzkYkyT4vn4hmqBNCrlWlQV5KkyCNGxLXOAwaoqT?=
 =?us-ascii?Q?a6h/TIw96U79s1KQhMnHIoudH2iLtk3OWqdJ1ZlH84TTPugRsd638/n6w88x?=
 =?us-ascii?Q?1ibZKPRcNxlZEJ0wDwNd68igv5zOUan206codwYAwrYeHqEtWxJJScj1NAEF?=
 =?us-ascii?Q?6n+Ie0uuXAOUu1i+US5UAbpXsKkYUZQrMdHUyuF1iN6dJt8a0gxWhBtnGyT2?=
 =?us-ascii?Q?R62nnYmLPMf62p+pltVgB69NuEzUCzAVaMVnaoS4EWhgTufS7u24zPhfHaaz?=
 =?us-ascii?Q?0wXwiIFwabfauNNQ2A3ow/LemEDomWQ4Gzf3/Wa7Oo32B23aHZwH98YlLwB3?=
 =?us-ascii?Q?lUXkkEJE+nFFFmLrW4lUxwWeY53IEVbN/Hr3br3GfIaQe4VLyJsbDHK7EXSv?=
 =?us-ascii?Q?SdUQU7WYtkIfemodhlI3k1sBJ4jZJs41fhySNPUjT4yVPlochnqzcmFGzPVh?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 435c7a0c-ae45-4591-9f3f-08dabae16afa
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 01:44:15.4531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6sjZwOchrbzwW3DzH6kj556UsBcv8mswBk+ppaw9Bvxk3YjL8vwnSpffIae5qfHOP1ijId0fdMKF3q/1ltPW4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6155
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-30_16,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=972
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210310010
X-Proofpoint-ORIG-GUID: zGmdRQ7tkfmrNkBeNWLG2dJntb99u9xF
X-Proofpoint-GUID: zGmdRQ7tkfmrNkBeNWLG2dJntb99u9xF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/30/22 11:52, Nadav Amit wrote:
> On Oct 30, 2022, at 11:43 AM, Peter Xu <peterx@redhat.com> wrote:
> 
> > The loop comes from 7e027b14d53e ("vm: simplify unmap_vmas() calling
> > convention", 2012-05-06), where zap_page_range() was used to replace a call
> > to unmap_vmas() because the patch wanted to eliminate the zap details
> > pointer for unmap_vmas(), which makes sense.
> > 
> > I didn't check the old code, but from what I can tell (and also as Mike
> > pointed out) I don't think zap_page_range() in the lastest code base is
> > ever used on multi-vma at all.  Otherwise the mmu notifier is already
> > broken - see mmu_notifier_range_init() where the vma pointer is also part
> > of the notification.
> > 
> > Perhaps we should just remove the loop?
> 
> There is already zap_page_range_single() that does exactly that. Just need
> to export it.

I was thinking that zap_page_range() should perform a notification call for
each vma within the loop.  Something like this?

@@ -1704,15 +1704,21 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
 	MA_STATE(mas, mt, vma->vm_end, vma->vm_end);
 
 	lru_add_drain();
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
-				start, start + size);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 	update_hiwater_rss(vma->vm_mm);
-	mmu_notifier_invalidate_range_start(&range);
 	do {
-		unmap_single_vma(&tlb, vma, start, range.end, NULL);
+		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma,
+				vma->vm_mm,
+				max(start, vma->vm_start),
+				min(start + size, vma->vm_end));
+		if (is_vm_hugetlb_page(vma))
+			adjust_range_if_pmd_sharing_possible(vma,
+				&range.start,
+				&range.end);
+		mmu_notifier_invalidate_range_start(&range);
+		unmap_single_vma(&tlb, vma, start, start + size, NULL);
+		mmu_notifier_invalidate_range_end(&range);
 	} while ((vma = mas_find(&mas, end - 1)) != NULL);
-	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
 }
 

One thing to keep in mind is that this patch is a fix that must be
backported to stable.  Therefore, I do not think we want to add too
many changes out of the direct scope of the fix.

We can always change things like this in follow up patches.
-- 
Mike Kravetz
