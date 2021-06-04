Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE2039BEE3
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 19:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhFDRfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 13:35:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45180 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhFDRfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 13:35:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154HV58i170086;
        Fri, 4 Jun 2021 17:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=JcdiRB4VNb2749CPmXpoB8dPkIsX70ozLeRON2BCT0k=;
 b=oCa+ORLMWUthEtOhaSUP9T86KYnp5hHfGJk2hRuSztweZWtJt32e1iEj4ycc4JDWYI+9
 JEg9mt9H22n4qqt00SRS5Agqj+eKEYEezwDmTpNMyFU9xRGZYzCU/2DY2NQOgjcLzlD8
 4R0QTEgVpuSRiTtiznd2v1QHBfQf1L2KoCRkGtzZuWsZjqFTMJ3ZQIpiOcSt1/jj7snc
 mBsYP4puJkU9JrHMxqmLuBfbVm/HHC7L4DcRNeAbfAGZxUSA+jxbCQuqXL4tmOggIqWU
 IViREp/fvWUFwAhBncjHWCgL582sO2k9g+dqVK8yd5sgB983QkpCoq3gakUD4jh0qAg0 6w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38ud1spgks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 17:33:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154HU9X6026134;
        Fri, 4 Jun 2021 17:33:31 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by userp3030.oracle.com with ESMTP id 38uar0dut2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 17:33:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4+G0hlqoQqSUVURvfXaZnEB79EorqUnFtImAciiUD5jI7R2W7fwXgPbc3X/u6riD/b/+eU0Wmr3P5hZlR3RqTyzBMacgcqba92J1k6Ge59zEBVmJZz/zznOp10Rkn8Ym+Ebm64aYRnXghabVy0c0T5ZnHfrX3NYb/LLfc9syEXOHCUyX+IXv62ky+GmRTutmavTs2TyKiNLGgVbA6LvtGP9UZqe71SKK8eL3jevwqNmL9RVISy439BaanbGp+3Aen00ACf0o4rAh4rbZCZ5YEzKMRTQXdXAsZ2wNTbl9zhLz+V9gz2KFzUfHfDO4UaeFF4Rj/cB60WL0mYk8QRW7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcdiRB4VNb2749CPmXpoB8dPkIsX70ozLeRON2BCT0k=;
 b=mqYF/w2ESHS8bZhZF6kzPJ8ScOIPJ/4SMBKfc124ffvVCL5AH44BGj4lmhsQ18Yo3PuarIC8IuTAy5xAzhzZRTzBMSskj4Tg8f7pX0/hZPJiNzO1inbV26jkRf0OYxbBNNRtMsmHA/rT4M4gvy6KxMwMXW4jizxXpfpYj+7VfmJhJ64e7orFm9pHrJqlkaOGleB2FApPux3r0HhJKnsJyktVEgd/5vfsDy60nUjWUhPAIOdioyvz3XkErnjBCFIxHAjCJomi9lXqFNojaOQvtJxWCVWjI5wgw3GOSvWVOIbp/NqrddAcHVeeCSd9dKfSple1A4swe9e3d6YG5nMp9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcdiRB4VNb2749CPmXpoB8dPkIsX70ozLeRON2BCT0k=;
 b=h1vYI/+YQNKtmpKcrTNiLPZkXveQ4YzgCotXgCM3rO+lBgJmW4yx8yUAR0xP30hHy+w/mRPLAntiQODsddSUF1FZEqoaGYGWkHcMWaXEZ3kxZBFWDNeuvysUFR1M1kHJDDRBreHR/chwrNAXxBPAaw9cp7WQd1YrHJB8SBOA2bE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BY5PR10MB4323.namprd10.prod.outlook.com (2603:10b6:a03:211::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Fri, 4 Jun
 2021 17:33:28 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90%9]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 17:33:28 +0000
Subject: Re: [PATCH] mm/hugetlb: expand restore_reserve_on_error functionality
To:     Mina Almasry <almasrymina@google.com>
Cc:     Linux-MM <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20210602234954.122199-1-mike.kravetz@oracle.com>
 <CAHS8izM-GU8_v2A9p0-ez+QNU=J9nh2zM6ZAkAMsNK7ubnsK3A@mail.gmail.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <aa145d1d-93ff-2507-3c4b-20e509a3a048@oracle.com>
Date:   Fri, 4 Jun 2021 10:33:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <CAHS8izM-GU8_v2A9p0-ez+QNU=J9nh2zM6ZAkAMsNK7ubnsK3A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MW3PR06CA0013.namprd06.prod.outlook.com
 (2603:10b6:303:2a::18) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MW3PR06CA0013.namprd06.prod.outlook.com (2603:10b6:303:2a::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26 via Frontend Transport; Fri, 4 Jun 2021 17:33:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53dd67e9-09b2-495f-c853-08d9277edd50
X-MS-TrafficTypeDiagnostic: BY5PR10MB4323:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4323F573F34A8E3D185C17CBE23B9@BY5PR10MB4323.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uWqAH4qzs4ldgFqYSv7NlBxnrCFaccPMiek/Ol37sTB4mmWw1Pdq3oA5T2oeT0W19GCwgMr6GLzH2EgpGbC5cXqc+KAyFGGOZMJWHbmQJGFKky8xKrrCOUMRBAdAMEPrd0dZ+XU7rMqEusmoO3pdzgXNOIQ8NNqO2jqAW6NxI3hZiExa5T4c91ZPT8/mvbAFqIAI1bOt6DtTGaYDdU2wZsozHkPTr7241m1kw0LZkRgBmbuAACBRRkX5qCGU/OYekgZzREolIgcJ3oGR4nFh2U5lJYfgobgIgSNU7i7Bvj4Zyv2QElzesszD8e5E4vxlonG3PC6q+7WQKXkFmD05j3HzSGNaJZPQa+ZlqNrWibPoAazN81eQ/eDGMHEdpyPkV9/x713mKt8w0plEqugo39VAie/0WbnUPHj+WhYnFFeG8Q91PcRM4stPG5HJPB0x504ffo8RSMJdEIXRQfqBhLfoOajg/Xclb5gDxhGzc0EgkIXOEffyrDJRNve5j1OxPaXhPiniKY+c7RherP/eyU6GC6og3RIklTCgivg4UP26FgJvMYZdcURbC2Pw6EprAqCVScqdfUd4YCRxVQMShX6gDy///RbER73EM+QoCtZGJu7EcSp2YGLJ5LG5LrbkHstcf+ND4DpHEaFIi4BXrSS5t01BP6x5NqIEYg1VTERs6OPsiofvE4Zm/yTk7KLwFE3UIbADTFKMnosqq7lDtL7zN/iMuOBUd01WNWkdBPUh14unDoMvXU3GTO+qcskA1W8bSp9dJbPp+DBSBGqZGAGfKbQ/hPKRnH01EdAAQHosWWH7UXzcOqh70/GCqbyJlkjmKLgTRPt+HZO+ygIMuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39860400002)(376002)(366004)(38100700002)(2906002)(38350700002)(31696002)(8676002)(8936002)(86362001)(6486002)(83380400001)(36756003)(966005)(2616005)(44832011)(52116002)(53546011)(26005)(186003)(16526019)(956004)(66476007)(66946007)(66556008)(4326008)(478600001)(7416002)(16576012)(316002)(5660300002)(31686004)(6916009)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U2dVYmFNUlhMLzdPOUNOTHFWcmhsa0V0bkhlK1lXd2Z3NWhrOXhoOUZnSnRa?=
 =?utf-8?B?c0NkRlNzL05lQVNHRDR2c3NWdUtEYXdqVGRmKzhHTUZUdU5oNG1pRFhXRmk3?=
 =?utf-8?B?RHF5dHlSM2t5b3NYKzhuejZLL3p3YUhPbU55WkFIVVZqaUVuTXFZM2tBOFZk?=
 =?utf-8?B?MC9vOERuUndtaVVhZVN6UFM5RHF4VDd4QktBV3dzK0RMejlEcUoxQkV4Vy9a?=
 =?utf-8?B?NGpiYUhvTi90QUlLOEFUYTd3SFVKdXBKK3Jncng0a3RrUDhlNXNFeU1JbzhM?=
 =?utf-8?B?bis5K1EzcTZjeGJkeENiRlZheVE5OFZRRmJvNzZBVEV6NmV3c3VsbGJoQVpm?=
 =?utf-8?B?bGpoeUFYRTZQUGgwdm5WWk02bUs2cC9IVWZKb1R2VEFoTlVLZDJxTVU5cnAw?=
 =?utf-8?B?MnQrbGlBUnU1Y252QitZbDFGWGFSYWw4NVJXeU5CYWRicmRtODNITXZqZCtp?=
 =?utf-8?B?NS9CMHQxaVNxMHRScWxaVFIrZmhyMFVlYWwzc3hkNE9YcTU0L3JxWVE0VHFF?=
 =?utf-8?B?VlVENlVtaXBBWE13eVdhQmdJSDFsUnNQQWlkWjBwcFlOYWJLQzhsV0wrOWlG?=
 =?utf-8?B?aEtidE9XdDR0SVhCbWxOT3VCMW5INncwWTQ4SDZoWjkvQVg4QnVBMWJ5djc1?=
 =?utf-8?B?Vm1yaXl0WEkrRG5oOEpyMUJRWUNwSUpybGtKUmFMamVuQWdhZUdBYTBWY0xQ?=
 =?utf-8?B?YWZwV2VSS0Z6WUp2VEhVVHZ1YTgrcHk5VTk0ZDk1a0QxeWNYVFNzRHppYkxM?=
 =?utf-8?B?U0M5bEg3ZzBDb0pnKytqakVxYWRid2FTdXhqMUxWT3MvMW5qS0xIZyt5Q2VC?=
 =?utf-8?B?L2JRRGhWdDE4eWhzZUVVQzM4ODFreWhCRDdGQTJNTnp4TUZyaXNvcFNCMThD?=
 =?utf-8?B?MVoxNDRVcllScmZFblZhZnlJa2tmK3l2TjVvVjFGNDlOR3N1ZUV4b2FvRmJ3?=
 =?utf-8?B?Sk9pdjF3UnZha3dhSWRZQ2VuS0xpVE5LeXVHb3U5SjBDOTdYNUJPQ3grNS9q?=
 =?utf-8?B?OHZ3NloxdktNWkJ2clZha2ptSVBWWWF1eE1PSDZDLzlKa3g1OEdEQWJQa2M3?=
 =?utf-8?B?NEo0d0p4RnRaTFZNdW1aSkpmTGdxQ05ZRUZaMnc3V256N0hPSStVUThmYXQz?=
 =?utf-8?B?SE8xMVVnMi9RYU1VbEI3Y0xJK1NBbWRhTS8xWVl3Z3RKNGVsOEtiNUE5Skx1?=
 =?utf-8?B?dERna25YY00zWFVTQW5mT1pNZko3ejJvZkp1RHdnbCttZS8vU09sWWwwZnJK?=
 =?utf-8?B?d3N3WFdIbDdwanVpdVZHUWF0Z1QwN2ZQWFAvT3hVTGNHeElUaUZVcTY5VGNU?=
 =?utf-8?B?Mm9lNXRmcXpYYkl3OGZTK1h4bk13VnpFL0VWekh6TVEwK1RPMXQwT3F5c2wy?=
 =?utf-8?B?enBhR3VCaGxodWQ2dzdwTzZtRDNMeGFLeHN3bWxJQUQ4Vm1tUTQ3V0xBVWJy?=
 =?utf-8?B?dTQrMnpxWWlUaFlJeXhxL25EUHZVV2FPNTR6NjBqNDhtRjhmWm05Mnlocy9y?=
 =?utf-8?B?U0hGQlRLYno3dVB3UkZrN0gwVjFvQ1d4MXZ6QzVodjczWnVaVmhMdXo0ZmdF?=
 =?utf-8?B?enRJVHZNbUVvQS8wb0ZTRlNJeVpWa2JWMy9YQkFFbStzZ3ZsMHRXV0F1WnVB?=
 =?utf-8?B?WGJZdDdmRDZqZ1RvUW5Wemh5eFE1YXd3OWlIN3NSRGtLRFRVR1RVSjRLVnd3?=
 =?utf-8?B?aXdtM09WUXl6UmlCQXQweU8rbW9LNHc4OXNSdUxFWGVBU3kvQU1LY0JlV3Vh?=
 =?utf-8?Q?lnsvlWYiaFDqQj/rDJmCyd50Xm3CJTYPYHOKoWs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53dd67e9-09b2-495f-c853-08d9277edd50
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 17:33:28.3899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/MmSTzKOTlfru0NFatUiDyOLhpE7NesXyVbBIH3DvpEP3L8dffXxOaPQoWSbqD9XqNvh4FNmsFZHY5hk2TRCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4323
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040125
X-Proofpoint-ORIG-GUID: SDNdL5zMyA_c7vrxIQG4TPWJGKwbjyEr
X-Proofpoint-GUID: SDNdL5zMyA_c7vrxIQG4TPWJGKwbjyEr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040125
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/3/21 4:59 PM, Mina Almasry wrote:
> On Wed, Jun 2, 2021 at 4:50 PM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>>
>> The routine restore_reserve_on_error is called to restore reservation
>> information when an error occurs after page allocation.  The routine
>> alloc_huge_page modifies the mapping reserve map and potentially the
>> reserve count during allocation.  If code calling alloc_huge_page
>> encounters an error after allocation and needs to free the page, the
>> reservation information needs to be adjusted.
>>
>> Currently, restore_reserve_on_error only takes action on pages for which
>> the reserve count was adjusted(HPageRestoreReserve flag).  There is
>> nothing wrong with these adjustments.  However, alloc_huge_page ALWAYS
>> modifies the reserve map during allocation even if the reserve count is
>> not adjusted.  This can cause issues as observed during development of
>> this patch [1].
>>
>> One specific series of operations causing an issue is:
>> - Create a shared hugetlb mapping
>>   Reservations for all pages created by default
>> - Fault in a page in the mapping
>>   Reservation exists so reservation count is decremented
>> - Punch a hole in the file/mapping at index previously faulted
>>   Reservation and any associated pages will be removed
>> - Allocate a page to fill the hole
>>   No reservation entry, so reserve count unmodified
>>   Reservation entry added to map by alloc_huge_page
>> - Error after allocation and before instantiating the page
>>   Reservation entry remains in map
>> - Allocate a page to fill the hole
>>   Reservation entry exists, so decrement reservation count
>> This will cause a reservation count underflow as the reservation count
>> was decremented twice for the same index.
>>
>> A user would observe a very large number for HugePages_Rsvd in
>> /proc/meminfo.  This would also likely cause subsequent allocations of
>> hugetlb pages to fail as it would 'appear' that all pages are reserved.
>>
>> This sequence of operations is unlikely to happen, however they were
>> easily reproduced and observed using hacked up code as described in [1].
>>
>> Address the issue by having the routine restore_reserve_on_error take
>> action on pages where HPageRestoreReserve is not set.  In this case, we
>> need to remove any reserve map entry created by alloc_huge_page.  A new
>> helper routine vma_del_reservation assists with this operation.
>>
>> There are three callers of alloc_huge_page which do not currently call
>> restore_reserve_on error before freeing a page on error paths.  Add
>> those missing calls.
>>
>> [1] https://lore.kernel.org/linux-mm/20210528005029.88088-1-almasrymina@google.com/
>> Fixes: 96b96a96ddee ("mm/hugetlb: fix huge page reservation leak in private mapping error paths"
>> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
>> Cc: <stable@vger.kernel.org>
> 
> Yep, works perfectly. Thanks!
> 

Thank you for testing!

>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> @@ -2360,25 +2376,39 @@ static long vma_add_reservation(struct hstate *h,
>>         return __vma_reservation_common(h, vma, addr, VMA_ADD_RESV);
>>  }
>>
>> +static long vma_del_reservation(struct hstate *h,
>> +                       struct vm_area_struct *vma, unsigned long addr)
>> +{
>> +       return __vma_reservation_common(h, vma, addr, VMA_DEL_RESV);
>> +}
>> +
>>  /*
>> - * This routine is called to restore a reservation on error paths.  In the
>> - * specific error paths, a huge page was allocated (via alloc_huge_page)
>> - * and is about to be freed.  If a reservation for the page existed,
>> - * alloc_huge_page would have consumed the reservation and set
>> - * HPageRestoreReserve in the newly allocated page.  When the page is freed
>> - * via free_huge_page, the global reservation count will be incremented if
>> - * HPageRestoreReserve is set.  However, free_huge_page can not adjust the
>> - * reserve map.  Adjust the reserve map here to be consistent with global
>> - * reserve count adjustments to be made by free_huge_page.
>> + * This routine is called to restore reservation information on error paths.
>> + * It should ONLY be called for pages allocated via alloc_huge_page(), and
>> + * the hugetlb mutex should remain held when calling this routine.
>> + *
>> + * It handles two specific cases:
>> + * 1) A reservation was in place and page consumed the reservation.
>> + *    HPageRestoreRsvCnt is set in the page.
> 
> HPageRestoreReserve, not HPageRestoreRsvCnt.
> 

Oops, that was from a previous attempt at fixing where I renamed the flag.

I took some time to think about exactly what was needed in error paths
after page allocation.  The result was this patch.  I tried to add lots
of comments describing what is being done and why.  This code is very
complicated with subtle details.  The opposite meaning of entries in the
reserve map for shared and private mappings being one example.

>> + * 2) No reservation was in place for the page, so HPageRestoreRsvCnt is
> 
> Same.

Will be fixed in v2.

> 
> Otherwise it looks good to me. Thanks!
> 
> Reviewed-by: Mina Almasry <almasrymina@google.com>

Thank you,
-- 
Mike Kravetz
