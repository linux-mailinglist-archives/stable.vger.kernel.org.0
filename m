Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E442624DA8
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 23:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbiKJWd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 17:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiKJWd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 17:33:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CF259FEC;
        Thu, 10 Nov 2022 14:33:55 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAMSEYH003526;
        Thu, 10 Nov 2022 22:31:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=Xs8XjWpnNBNmtL9Q+9lPbKSAf84dbybiRCw79dObnbw=;
 b=CMbYkYR5z8xWUxJ4+FMbb4AHz9T/3YbdPbTFfaUtrRRwoH1AKkZOTl69AELE9l6F6IVD
 Zdh7MyAnuUwh8Du9wToIq3h2ZomN+ANkP98LzKcA6Fp8OzgNEIHlzJyPqvq0XMNioRzD
 8sc893CR1qcE6+o4fGDz5BjmKRPpreDV3xSUDkbnBtLAN0Xz6gRY5xmDrDb7QfFYhwdG
 WIYUi4whUyQxfVF9NiZSbNcyJoJTrCM5QPqHl6Kh5pEd9qhjA/Z78yhdHnPqvqU/26VT
 /9jckChRWX8bldpoUoJaWAXiwtn38i8PR5SxHXUrPnfJBgd6ZVjOcfV6CI/a9LZ4Ms3i fw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksa4dr0d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 22:31:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAMLhem038087;
        Thu, 10 Nov 2022 22:31:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsh7epw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 22:31:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FL+fqhzVORu/ypDyBwJfsy2tpCQNjuC8DdudQyzK7WI/bKKHjSBz1f8x+qmGtupSeO4wLceFeZ4vUWAK9rig8gb8lfgD1xu6Pnss/D6iAMRnV6rzgWritHFhs08MLueYNrbdMPE6YQbL7po3SmnrZqw56/04P6x3DuLkGD4Askg/Pw9cDrvf3/o8YjyJx2xcJs30N1IgdfG6twdAnu07s2ankh0rbYKSm36U/RyM+SAlznsqJnXWChJbjwg4VStWOrgA69y7z/TAiOeB2JZlmJ8x4p2jzwVm96nio4r1nbR72JvbE6CAdn81yyCKUsjQbsB2xKNfIp7tyu6hTySiEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xs8XjWpnNBNmtL9Q+9lPbKSAf84dbybiRCw79dObnbw=;
 b=Gh/UfDIyDaDV2M30D06uufHl+Ehr1+mkSzPyYngXLfmSomOjjMXu2YPYvLMXDngCTh4StcnxINL2178Cpf61PMikgETGtzFTm/yl9hBk3yX+GIggCD6HYLQ9zBPNv5/a/DbfxzeWSwmHvQ+9Atlc2DzNS8ZbcbyeziDPj/jHGE5buJgWnx31pn8cXXbaJInW3RfCK3j5NPWBeya0MkeneA9IyohaEmfBrduKeUedrAIZsk1Gsqxjq33m3NOq83RhHfHLgkGK7GuixFlMgwM+avBszZHHAo85+rqoUF4wTx9gi3Ako4ZVZnXZrX0iQDxIufhowbJE3KNPNoXZ3ZxvjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xs8XjWpnNBNmtL9Q+9lPbKSAf84dbybiRCw79dObnbw=;
 b=Yb3Wgm8GkJfFZ5dBqHE9BiaWULNLqf1SlLpsotbwMcp+jH4hQLVoeNuPqeNgL23epLaUmnMKnk/Q/f5jHGSps0h3OK9xhW+RJ3iDy3dspwS4qjnultsgIBCFjrD27EZYaOGYBCh1uUCWidvT1nsOn7n3qBvjyGWFwRAZWGfdjf8=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SA2PR10MB4585.namprd10.prod.outlook.com (2603:10b6:806:11c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 22:31:31 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5813.012; Thu, 10 Nov 2022
 22:31:31 +0000
Date:   Thu, 10 Nov 2022 14:31:27 -0800
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
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v8 1/2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
Message-ID: <Y217vw+cMjXcT3aq@monkey>
References: <20221108011910.350887-1-mike.kravetz@oracle.com>
 <20221108011910.350887-2-mike.kravetz@oracle.com>
 <9BB0EA0C-6E7C-462B-8374-5BFEC34E8415@gmail.com>
 <Y21xlgG6sxP6q5K9@monkey>
 <05FB2C99-9141-4F2A-8664-31CA5587B310@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05FB2C99-9141-4F2A-8664-31CA5587B310@gmail.com>
X-ClientProxiedBy: MW3PR06CA0021.namprd06.prod.outlook.com
 (2603:10b6:303:2a::26) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SA2PR10MB4585:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ac95c1f-3471-4408-e66e-08dac36b50a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +f8R2DJ45d3jGUmApRHzChp2BunZv3P6bRpSCeuLoZxVuMJjPVd33fSDV3Y4HpPnCP/GMjmK9Hbky1CtPxMaxCnaFZHAhcgOIMfsZhZLExruHb9voFwVBjxCl4+LbXnqHVAAMZO7ZdkP/N0W+2TBmA6m3XBVUEwXhNKTrs9PpEzsHyMk0stQnxyhD5EaCWhxw4hKeYPZhvzzg1JYIQ2ikRagIMETzAqZ7DYpODr/ofggTR5ut8nqiZMenBESf+R0QilIcF5b4gbKZxmtnCdv9n5zPvNkYWiG8o5Abtpe8qzEd+mv/8xc/J+4dnPbNuUaQTXYRp9dcrZPXUAhVF9qaVewGc+JruHLeLkD1LMlvaxa7VGBsTQ5goxko/a7/AyWl6T4NBEynXY4LFif1yuX97XMDNqIDi6PX46EwHr3L1wnNp79PDA8r8Da5XTzY/NQw4k3c0IOr5MInc6P5VXIl3remLJ54rwEpMrIpgivb2MZl27kmGD61/uKDNkIIJxFONkkckB2ANF9nyoSMWAr1cbCLld+sWhAHPRMImMonuR87qx+RFxr288+ywDhDxIHisyx230OP/TmgrULlvTFt+KCEbo82Y3RkMaA9XIsL1dH1dezDMb4sOWYkdiJQ561gdiSPspriDLpBOLvYtIWEgAtxtwpkU4bUFasrAGWfZDfWurHUnxBpYbO5Wx9ImyBefwSlV1OWMtKqjfZmfhPr2HD2d4d9h2OM1Gu4tsMMGYvNbWrlEZelt9HYTE/R6Em
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(346002)(366004)(39860400002)(376002)(396003)(451199015)(83380400001)(478600001)(38100700002)(86362001)(33716001)(4326008)(6506007)(26005)(9686003)(8936002)(44832011)(2906002)(316002)(6666004)(6916009)(7416002)(53546011)(41300700001)(6486002)(5660300002)(66556008)(66946007)(54906003)(6512007)(186003)(66476007)(8676002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjhONGw1WTJEME9VWDZNanZaelRmSDc1RytHR01Qa0NpSjlCeDJKUUpHNXB6?=
 =?utf-8?B?bTh5bHFuMDVWTTR1WHFVZURDZVR6RHlpVFhiRXRrZjhmOWR0MW5sNWJaWnFC?=
 =?utf-8?B?QmtoNHJjS1NFZDdiZFpjMkFZVnUvQmg2Q3JmL2c3ekYxTWJITmJLbUp2NFBn?=
 =?utf-8?B?RGM1NzJzcVUvR0pWYjQ1M2llQzFQUHF1Ym5jT3MvM0xkWkYvbndKTUI2QzRs?=
 =?utf-8?B?Uzd0QW5iNG01U3hNdXd1OGNXUm0vVHcxMHg3eWNEc1ZkR1hjTDc0UHpUNVpF?=
 =?utf-8?B?d051L3ZBdzJPQUt4Tk1rUVJGTEZ2aVoxdUx4Z0h4OXRUcTVCdGYxTXc0YU12?=
 =?utf-8?B?TEUzVG15YkswU05vQjNMMUNCYVN6N3B5SnVPa3NFcHdrejFuSFZZUnhGR3E1?=
 =?utf-8?B?NkFnNmxTYXZHNWRwWkhacG4rQjZVMDFjejVhZU95dGY3YllUMzBSWTF6aC9Q?=
 =?utf-8?B?U2FUcVBXWnBGcWtNanh4dy9BdlVkWFRFQlVjaUNzbXUwMWFITjJidit0a0pY?=
 =?utf-8?B?TzQ3djgwU01DcXhtQnM4WjJaUTVXN29lUXN1TVpzYmc1eXI1djg4MHM2ZUl1?=
 =?utf-8?B?c05WWkF6REp1WUxsZlVtSU04V3g1WmVwcE1qMkdqMERFODRXRFVWK0FHbUJQ?=
 =?utf-8?B?UTlZUDAwWkMwaTZqTm96UlpFaFZ4Q2pRK3VzRk1ZY1AwT3hOeDR1RzhNRGVN?=
 =?utf-8?B?QmpYMHdJZlh6aW9xeHppQ2s0Q3FBSkJ4MXZTUzJoZng1UTJUYkNLU1B1U2dO?=
 =?utf-8?B?Zzhabm1ZV2Z2dU9VU2JNMnEyT0V2c282ZCtQck5zeCtXc21OS3lxMWw3WGVa?=
 =?utf-8?B?UnJtdFFYRmhtSnhmZFpPZStLb2QrekNIOTR1Rm9UQi9KNGRqcjZ3ZlFraHB3?=
 =?utf-8?B?cEJtWFZBWm51Yy90cnA4WXJBV3VjdVdHQ2pWdlNQZVFKT1JWcUsvam9oblhu?=
 =?utf-8?B?VGhyZGVLaHR4dUtBUENHYncrOXcwd1FSaHZ3OEQ3MVVLaEpWS0UwZTBxOWR0?=
 =?utf-8?B?alR2bU9KT2JOY0hrdFFGM1NiT3FSckI3dGZVaHhtYlMyejQ1L3J6alY4WG5C?=
 =?utf-8?B?SVF0SVA0YndNNzB5Znh3cmpiM1BWWXdoU3Qza3pVWjgxeUZBdVZlRFdHZVJu?=
 =?utf-8?B?dkpYZVdLclU5dklmRFc5ZFR3U2MyOUJBdEVMMGNWejFWRk1pbEpVQVZ5Y2cx?=
 =?utf-8?B?MHRyWlF6SzZkZ2xaTEpJRHBlVXJKblZGb0FSZ0VIZWVidVdZdFNZdi9Sc1lL?=
 =?utf-8?B?MXg1OEpIMlJpL3l4dDJRS1dIcEh2UGNPSW5SME9aUlhYYUxsZDNkMWcveitL?=
 =?utf-8?B?ZEFHSmRhelZKUkxXbTR4dHdpYjhlczY0dFdwMEJURnFtbXYvakFRZ3U2ZkRR?=
 =?utf-8?B?WFg1eW1RdHYxT0JuYXVYZWJGTGpvOEtjcUY0NlVvTTUxejM3VHNBQnZJNDR3?=
 =?utf-8?B?ZDFxWjlJc0NEUzF5N0E4c0hQckpkWWVqdjFrTFJWanMwY0s4WFQyUkhWajFI?=
 =?utf-8?B?LzB4SVVXWStham9UdnFvUVMyekJNV1ljS25GMGZiUkJmdGxERWY3YlJ5WWs2?=
 =?utf-8?B?bnpSVWdxdzdCaHdqV1MyRzRucG5NNTJvQ2FOWEp4dlUybHJZRU5lOGdTbjFR?=
 =?utf-8?B?bkp2Z3hjMzI2TTE2SGp2YzBpUCtQSkVValBwd1pGY0NOZTR1TWNPTlp0cTl1?=
 =?utf-8?B?MlhZQnBJdUtFbzZVcmlFQkxXNURnK0VUSHdnM1VKelNDK0w2bFRWYnYzZnY4?=
 =?utf-8?B?ZnNFOGYzYnVrRkFHWUQ4bTRhN0dnd2tIVlNCczRXcUhQR09MQWFkbWNLR3VH?=
 =?utf-8?B?QU1TV2NDWmlBR0VmWE5QNm9ud01jSWF1UC8yR3hJQUtyc2hQVW83eVBWdHRH?=
 =?utf-8?B?N05TQWNrWU91eVZGRGhVdytEU0lpOXBHaGNlSzduazNDOWx5dzlHV3hiTkRH?=
 =?utf-8?B?ZXNUSEE5RXZocGo4SDJDdHV5cUUzL01zckQrYldYa0x2ZWcrZzdsTyt4QVFm?=
 =?utf-8?B?aFQ2NnlKM2doNWFWVmhTRXZ5NTJkSm05NjR0V29WcWJkMEoxUEk0RFkwUVlL?=
 =?utf-8?B?T0pQbDc5SEtzOEFZd2hSSDdUWm91Uk0zOTk4K1VYTHI1cUZUMm9POGh0ZkJo?=
 =?utf-8?B?NjdOTzN4UFBjSTdqUTVlY0ZUR1BoMU9EWExRMDZ4S0JmYTVNU2crWmkyK05Y?=
 =?utf-8?B?S0E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ac95c1f-3471-4408-e66e-08dac36b50a0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 22:31:30.9703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mD7QGvOLOxTVcMVU6qgPKWB55ydZr956LGYTXATz3BEF++a7v+K10mCMeF0JEFcN58E0DuScoE+x6mYudPTeJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4585
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_14,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100158
X-Proofpoint-ORIG-GUID: tKtT4Qjj8DqQON2XZxDG29c9uBAzkpCq
X-Proofpoint-GUID: tKtT4Qjj8DqQON2XZxDG29c9uBAzkpCq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/22 14:22, Nadav Amit wrote:
> On Nov 10, 2022, at 1:48 PM, Mike Kravetz <mike.kravetz@oracle.com> wrote:
> 
> >>> void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
> >>> 			  unsigned long end, struct page *ref_page,
> >>> 			  zap_flags_t zap_flags)
> >>> {
> >>> +	struct mmu_notifier_range range;
> >>> 	struct mmu_gather tlb;
> >>> 
> >>> +	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
> >>> +				start, end);
> >>> +	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
> >>> 	tlb_gather_mmu(&tlb, vma->vm_mm);
> >>> +
> >>> 	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, zap_flags);
> >> 
> >> Is there a reason for not using range.start and range.end?
> > 
> > After calling adjust_range_if_pmd_sharing_possible, range.start - range.end
> > could be much greater than the range we actually want to unmap.  The range
> > gets adjusted to account for pmd sharing if that is POSSIBLE.  It does not
> > know for sure if we will actually 'unshare a pmd'.
> > 
> > I suppose adjust_range_if_pmd_sharing_possible could be modified to actually
> > check if unmapping will result in unsharing, but it does not do that today.
> 
> Thanks for the explanation. It’s probably me, but I am still not sure that I
> understand the the different between __unmap_hugepage_range() using (start,
> end) and __zap_page_range_single() using (address, range.end). Perhaps it
> worth a comment in the code?

__zap_page_range_single is wrong.  It should have been updated to use
the range address - (address + size).

At Peter's suggestion the mmu notifier updates will be broken out in a
separate patch.  I will also add comments, to make this easier to follow.

> But anyhow… shouldn’t unmap_hugepage_range() call
> mmu_notifier_invalidate_range_start()?

Yes, thanks!

-- 
Mike Kravetz
