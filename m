Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5256142E6
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 02:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiKABvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 21:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiKABvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 21:51:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE5515A31;
        Mon, 31 Oct 2022 18:51:12 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A10xRGd032219;
        Tue, 1 Nov 2022 01:48:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=7rbBPfo+/SGJmSgn/QJP6vwNHlvsfI2B78yfXZjqnME=;
 b=VjbaGb75tk58QGE4szv1bneq5VTUJUgGqdTSATDY2UJXdbmNUdxCg/REw7daZ7Td1CFX
 qjOzOjnhBWxQBiWTXrIrE1fV96xHOU7q/2jNlkKXRSkJnPPqiJMat2He/fLmH3LNZ1t2
 KvlDE6515nwFuLyqv97Ij84PFTzLOncS0xhyAKSpCVNDsfBymKfVWm4rQHTdzgDKomd7
 jP4V8g3NgNCkTWxvHS2ZgF6WIX/5YLJIC823WwHQzDD+tba4/3SS/38WDWFj2DtGo0Gw
 OF+UbjYTVB3NKUWD9rkmTm7G5JyaLMyQoco+rIgm7fzzHomDCMTrNLnIYMs+KeHKio44 6Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgussneb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Nov 2022 01:48:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29VN5HsF019157;
        Tue, 1 Nov 2022 01:48:46 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm9x0fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Nov 2022 01:48:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=arC0/kW8EEXBLSG6oK9gfB8VeEeost+Bo+C6t1QcPQcHpRjaApXF0m7upJUcX0i1F85U/LhdIRwlPSr09YTd3IpLyJezrtHCXUrkW7y5IqkFQ9EQYZggtQtnciefwARcjqoRhiXl12bnhQrQyuSxX8IGk6dnt/MFIOPoCL1SQc//sq1NHYsBvCnNCSybmrzl/g1SUsmv1JJPQrgeqe2H3FpSlIhnCw0nJJxtx5kQ39+Vtq2GWx0nY9sXaOUR1JikJrrnkYq4fsjmTUjxI4Fa+rXiOSSOzOY984u8NXswA5MGwK7spImr63J7dRCkNNYdl2DTGXrWeJ/4YuYPpOp2/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rbBPfo+/SGJmSgn/QJP6vwNHlvsfI2B78yfXZjqnME=;
 b=V7lB7pbhr1cr+1q405qFWxGT7EZtNzF6ZFs+NOqSchfFaX72iHylHnHgTM8jxshwLwbXZ/ivjo1uF/KSu1Il+EI4uhm/5S8Gg3iwc/scVmkxPxdlciGOH8fC37acTwK1JTH8wlC8NQJRPcqi52Rj5cV5aCunnufSzp1dk91GXjnqxovdupYDR11lCvukkkWvfxSzJK10J7SVBsndx+eIau898JIV8GHODL4JFva69Xd7xSHIPF8qhXs3C/7mBzJCS5u+4kHYP3In5TELJhA0jX0n8zabwKW0hrFyTCIWiTPLVMfXmf948zxh3jykX+GRhOK9MdRZrpuaEhpE3ms4Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rbBPfo+/SGJmSgn/QJP6vwNHlvsfI2B78yfXZjqnME=;
 b=ftTNMc1FJ06RNuN3t0rqOs1WBRV6mnVX0neiihxeF1t4v4bqyBdaszJDJKHuQ5SnuxzDW1NefX226EpPGc8eYz6xekhS+Uoc2Jwi97CD0IjiNLmMLGCv2CCz3Re7l6IiW5FxDql21EDISY9eK3YuHXRi1NiUchxmfqo+4N3TbAw=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by MN2PR10MB4352.namprd10.prod.outlook.com (2603:10b6:208:1de::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Tue, 1 Nov
 2022 01:48:43 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%6]) with mapi id 15.20.5769.021; Tue, 1 Nov 2022
 01:48:43 +0000
Date:   Mon, 31 Oct 2022 18:48:37 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>,
        "# 5 . 10+" <stable@vger.kernel.org>
Subject: Re: [PATCH v6] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
Message-ID: <Y2B69ViNMYHvPXYk@monkey>
References: <20221031223440.285187-1-mike.kravetz@oracle.com>
 <8D2D2F0F-9A53-42B5-8A9D-936E06E4A4E9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8D2D2F0F-9A53-42B5-8A9D-936E06E4A4E9@gmail.com>
X-ClientProxiedBy: MW4PR03CA0127.namprd03.prod.outlook.com
 (2603:10b6:303:8c::12) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|MN2PR10MB4352:EE_
X-MS-Office365-Filtering-Correlation-Id: 99c66aa6-9396-4d3d-7520-08dabbab3538
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x1v5mDThsIb8ahupXPxFgbnuz3w9mWJGAB8GjFz072gSF1L4R5S44X8ikaVRqduELtJakqLKbT3gORo9TfHtQuQkM/lPq0VU9MY/1iPza4mdav/isA5bUo2VNItUhJJ3bHSh5Arld7ztS/P5/32hMt9sDLtHaQx41GTiz+m9y2wDP5Ur71326i2Onh8r9xKAapA7PVace5bKc3NMTm911MCJXsINvZW8MS326XEJ/Rv5tRSO4XLWKilJVyIX77qP5hINgRpxwaG6EjiJvu8qU4cdcyGQ1opyWfQBL+G6ZpljM8kX8701/6Cho+KOltAUgNLdqomP6HZB+DkyyfiY1/biCkRDVWSDIMg8rxmklZoJLhKPR42lZYqPziHnWmG16UnEIZqV2WGP9V4IDshYNexncZY4aoOU3KADKUQ9S3PBF5piblF3ErO8JgDKEO5YJ1IM3j5l2p8ouW7H7pNhEbrPzTHqkKQFJim1+kYJDo6SDrEnBy6kgXPBbRienptCJEUtrrTQcSbVxprwMxztflUe21GP5grlmFi2fvDnEcnxub/Nofn/pKAnEemKBbNoezqunJ40mKouWRdtiDp9Nqb1toU0Q/gwVd31vSsYf5xVWKmhz8f+R4iAIIKJkPxyI4GgtaPmdL0aAsVn3P7hcK6kRdtqZXwDjMCWjj/cDfY+pSnpnMNeQVobHRbivk+c7eA6sIB+hxasgCh6gx1wW0yiNIFsJu69bjqA57jI8Ak=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199015)(38100700002)(186003)(6666004)(6506007)(966005)(478600001)(53546011)(6512007)(26005)(9686003)(83380400001)(5660300002)(7416002)(41300700001)(8936002)(8676002)(2906002)(44832011)(6486002)(86362001)(54906003)(6916009)(4326008)(33716001)(66946007)(316002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clhZeGtrdG0rVTNMa0gzdkxvVy9hZlkyWlliT0oxZGVybkVTalYzbTV5dW8z?=
 =?utf-8?B?K3BQcWt5WlB0M05WS3k5SDdhMjhEemZpNHJua1Rsb1NSWGtNaThRcWZDbzVh?=
 =?utf-8?B?STVsZEFkSDQreDYxOVlaZE4rclBWQlFlNUk2RlpYdjAvR1B6a1d6RGFva1A0?=
 =?utf-8?B?MXpKTXlZQWd3RVkwYlgwMndIQjFvTkJHVUtVSFRpbU10YUZCRWFhKzQwdVpq?=
 =?utf-8?B?VkFnS1dtWlFoTUM5TGYrWXVqcHQ1L3RQejIxMzNxMU1hZW0yTjZmZ2krbTdJ?=
 =?utf-8?B?OTExdGVMUnhGbUFaeEIzeUlHOGtrZFRqUy8rTkx4ZVlzZnI0cEJiS0V2azFz?=
 =?utf-8?B?SGZWek0xdHFBclhMRTVaQXpGcCsxSlVpbkdmdlVzbmI5ajA0UVhmMkFkWkpo?=
 =?utf-8?B?elpPZFRwZmxkUnBvRjMwSGpKd25YZWtNU1NvdkJiTzNHYVNDOVhDN1V5WHQz?=
 =?utf-8?B?SGxJbkFBRXE3cjYwK2JpNklrS1A4aS9jUnRUWWFqV2ZXUWhZRzZ5b21DV241?=
 =?utf-8?B?RmkwUk9mYkVQRTRsT2pEcmI1ZnYySVNabmttMWpabXVEMkpuRitocGNSSVNO?=
 =?utf-8?B?RFVuWktheGRtZXh5cEJiN3NUR29rRHdseGplSmtpaVBpT0hmOTg3Kys5U2tM?=
 =?utf-8?B?eGUraDNyV2hqSWRBK1EzaHJldFRLNGdDODI1N2kyODFRUkxFOGpkZkdwaWdq?=
 =?utf-8?B?SVQvelAyZDgvNWRjemQ0SlNuKzFwVkVXU2lOWTRxUkQvbEdUdDZsSk1yQnhV?=
 =?utf-8?B?RjZrYkg4d3FlOFMwNXBMUVZYcktoWnVUY3lCb0R2b2FrcjlCdGtRTWtDVlk3?=
 =?utf-8?B?Y3kwVDhoRlNWc0lGVTVQMmwwZ21sc2tJb2s3ODVYbTNyTk1xSmdvOWwxUkpT?=
 =?utf-8?B?Z3pmSUJiendMZk9CcEVUK2hVZXBmeDNCVkhhV0QrQWRJS2FEaFlRQkExczR6?=
 =?utf-8?B?MXdqdEdYSXhFM3dQQ2JHY2wvWjIycW1rVzQ5Zi9kYktRcUZXMHhHU2FqV3FD?=
 =?utf-8?B?c3VpUlV2SzVHOTUzaFZaRllyTDdWYjlHeEtZa1pRQ2ZrdFpkNHljRFFOVW5C?=
 =?utf-8?B?d0dNQ08wKy82UjZHdklzeUFvUlR3U0VZUzdSUVFXQkxxellZOVFhRG5JNXRD?=
 =?utf-8?B?Nm5FbWNsT0I1dGtrRXV2RTV5YVpETTIrUnk2Q3VYd21hUTBvbFhwRFNCSkRR?=
 =?utf-8?B?RVVDazBFU0w2VTdNSU9DejhXb2V2UDJaMjdjOG9nR21lRGtBNnFQangranRR?=
 =?utf-8?B?aTJsR3hxZzBQKzc1MEpDVDArWUhzTXgvSmdBY0FHM0VrYStuTnhyeGM3M2lj?=
 =?utf-8?B?MjBMSCtHU3VxeDRPRkhHeHF6KzVzV3NpYnlOc0FaUWVqNDJDWnJZQ2tOYVR1?=
 =?utf-8?B?WGZKRTR5RGRnQkNTKzBKWGJZb21xUTNDT2ovbVVqTE52SDVRcFhxUzBmTW9V?=
 =?utf-8?B?TGtVcEZHM1Uvb0daWmo0aDMvYU1rUm1UNDBlYWsyQlhaT2JLZzhDNlVmdzRo?=
 =?utf-8?B?T0wwc05SS3BEMGQ3NHp3ZjlSenN3eUhHOGw2azA3OTE1Nkozbkt5M1dMUTVl?=
 =?utf-8?B?b3FvSUtKVHhTWjIvdUtNYXhxRC9hbGVQUnl2V0NqWE9xazNLMFA3cVdVc1lK?=
 =?utf-8?B?ZEpmUXRaZWtHZHhSWDdLcGN5MWRHVHpEQkxZN3B3ZDM3OElGM3NYZnlmQkhT?=
 =?utf-8?B?dzd5OUc3RW41ZkVYQjVQdmRmbFRmQWhqQXI1aUlmUjE1UHlKSVcremVseDQr?=
 =?utf-8?B?d3hic3M0bnVuelQrUWlKdGVlNnNxWmt1UGNSQXpLSmw0UDNYL01veGdhZTRC?=
 =?utf-8?B?L3poekpmM21hN3NwMVpHWGhKU2tEOE5vS040ZFQvaytGUVpKL0lkcmUyOEJF?=
 =?utf-8?B?UDd4ZTRqVFFxSzdpelB1V1VzVkRjMkZuQ1gweHgrNkg5QngyYVZqeWYzdnJh?=
 =?utf-8?B?NGNSYzhkcHE4cGdNeFVyOW5kdnE5TW1TWDlQZldqWlZra2lXeEozYlZ6RzBs?=
 =?utf-8?B?dGc0eEhEdStyUFB4MkpBNFl3ZEpKQ3V2UXdtQkxMNlFBM2hENHdLUS96ZzZi?=
 =?utf-8?B?Zmxwb0Q5dzNRSXN1bjg4ZXZvTGRCdEZsN0RFZkMwZktCeGFzV3JranByekw1?=
 =?utf-8?B?WXpuV1A2cVV1dnBWNWo3czNRRGpCSXJHM3ZjTGhiN2NlTTczQU5tTkx0aG5p?=
 =?utf-8?B?QUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c66aa6-9396-4d3d-7520-08dabbab3538
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 01:48:43.6008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +dQ3dnIEPdr7s8Ap2TVvdWA4snzE/15jeBN1fs8C15Hp/o9/SI1lp6wMD2okLFXwcRb481M48mxeLDm9Q7sQlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4352
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_22,2022-10-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211010012
X-Proofpoint-ORIG-GUID: ISptwYJcFumDZYZhOVFWUeDPV97BZo-f
X-Proofpoint-GUID: ISptwYJcFumDZYZhOVFWUeDPV97BZo-f
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/31/22 17:54, Nadav Amit wrote:
> On Oct 31, 2022, at 3:34 PM, Mike Kravetz <mike.kravetz@oracle.com> wrote:
> 
> > madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear the page
> > tables associated with the address range.  For hugetlb vmas,
> > zap_page_range will call __unmap_hugepage_range_final.  However,
> > __unmap_hugepage_range_final assumes the passed vma is about to be removed
> > and deletes the vma_lock to prevent pmd sharing as the vma is on the way
> > out.  In the case of madvise(MADV_DONTNEED) the vma remains, but the
> > missing vma_lock prevents pmd sharing and could potentially lead to issues
> > with truncation/fault races.
> > 
> 
> [snip]
> 
> > index 978c17df053e..517c8cc8ccb9 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -3464,4 +3464,7 @@ madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
> >  */
> > #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
> > 
> > +/* Set in unmap_vmas() to indicate an unmap call.  Only used by hugetlb */
> > +#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
> 
> PeterZ wants to add ZAP_FLAG_FORCE_FLUSH that would be set on
> zap_pte_range(). Not sure you would want to combine them both together, but
> at least be aware of potential conflict.
> 
> https://lore.kernel.org/all/Y1f7YvKuwOl1XEwU@hirez.programming.kicks-ass.net/
> 

Ok, noted

> [snip]
> 
> > +#ifdef CONFIG_ADVISE_SYSCALLS
> > +/*
> > + * Similar setup as in zap_page_range().  madvise(MADV_DONTNEED) can not call
> > + * zap_page_range for hugetlb vmas as __unmap_hugepage_range_final will delete
> > + * the associated vma_lock.
> > + */
> > +void clear_hugetlb_page_range(struct vm_area_struct *vma, unsigned long start,
> > +				unsigned long end)
> > +{
> > +	struct mmu_notifier_range range;
> > +	struct mmu_gather tlb;
> > +
> > +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
> > +				start, end);
> > +	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
> > +	tlb_gather_mmu(&tlb, vma->vm_mm);
> > +	update_hiwater_rss(vma->vm_mm);
> > +	mmu_notifier_invalidate_range_start(&range);
> > +
> > +	__unmap_hugepage_range_locking(&tlb, vma, start, end, NULL, 0);
> > +
> > +	mmu_notifier_invalidate_range_end(&range);
> > +	tlb_finish_mmu(&tlb);
> > }
> > +#endif
> 
> I hate ifdef’s. And the second definition of clear_hugetlb_page_range() is
> confusing since it does not have an ifdef at all. . How about moving the
> ifdef’s into the function like being done in io_madvise_prep()? I think it
> is less confusing.

Dang!!!  I sent the wrong version of the patch.  clear_hugetlb_page_range
is not even used here.  I used Peter's idea to eliminate the need for
this separate routine.  And, this was a development version.

Really sorry about that.

Andrew, if you can please drop the version of the patch.
-- 
Mike Kravetz
