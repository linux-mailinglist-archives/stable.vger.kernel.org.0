Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E53939471E
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 20:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhE1Spd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 14:45:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33390 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhE1Spd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 14:45:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14SIhPFt175250;
        Fri, 28 May 2021 18:43:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=uoLYHwRCdRv6i0NlE7jrI/Yq3b5SI2QxVDAsfKIk97M=;
 b=ENhf3ekws9RBdp33bPQ/HjVBxD39Pibsx/xztIsREgQAGh4I0Tbi3FmVxNiVN/uPQ29U
 19+esluaJke7wWhQ5GySN1XJCOol8OajF7oQif4uc/nAJnLKpPzIxBq30zEqMP1Vbfnt
 et2beiM8lRAvxj6SJ9GtxQ7N2eF1WYZOCZr62NWUuaF7xFEuXVtjAv8J1iYqU7J39Sdm
 2lwYrtkFlH5LihtuX+ya14d1QlNJrLjikPnj5U4ezdDr+l7FQ1hexhVxWySsPo6a/wMr
 pHai6s26XbzO618LpfoFksl7pmUGSwU07/U3eITsaTo5PSMrprrQJcLyBdVyYTMIwN2+ mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38rne4bemc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 18:43:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14SIehEx086789;
        Fri, 28 May 2021 18:43:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by aserp3020.oracle.com with ESMTP id 38rehmq6p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 18:43:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efEcrWxAHexMjcLj6n26CWNY6lhBLBjg1ZT1rPwRB0+ctBBa5pDSaQ9/nA60A6bwr7xbFWaEGs9jXJa3XdrnM2blS/eA6Qfp+LcFDeExi5iRvbpSae5BmWPIXj5xyl2ohP2iNYpkhd5iCDXfHQXv42PdnDBwALDbSZc/jNrzYPkWZtdimARcuYKj4oMYq8XZOHG28PWrzgjTJcv9IngQ6EsNVcQ3fV3TwO9BqBHyjIdgESYlt+qEqgaTmS1ToFixcDRi2aYFsECF/oG40znQImONqARtx4Ro7XX5srBEbwjiFXxLGE1koOrNXwSTrmA9EL3S8y32Lo99Fq7cF/MVIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoLYHwRCdRv6i0NlE7jrI/Yq3b5SI2QxVDAsfKIk97M=;
 b=cViGUOkLXzQ8nJaZ0GoKGTTJ8F95LnYlrPNjYC4WDrGIik/qW4FrquKnjZAt281G4ACYrC2R+BUie1dKtxlK8ql7NFti3TPzxmrVAUAQRIo16wZ0WqS+xJivEoqYXwCL6Jh38j5NK41eF2XJyK/Af+Dcn/bTQfIljRRvjG4vrI2hrYTB8UDZMKxucrbysk3dl0cyB5TAYo5xcllRwZPq4FQkXpcrCSpocTNElppZVUJm3xnqDoMtZH9tueCYlJ2A3x3KErPES/zAo96f3FRuGlV+jHlMlpKuhe7X9a5t2lO8XQAf0cSMesOOXpXZ/0jYH+fLXszJdo3qAa5+sz0NtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoLYHwRCdRv6i0NlE7jrI/Yq3b5SI2QxVDAsfKIk97M=;
 b=LB+/JwIhBP3oxpxUJBbZdHAIqC4pgbndP/dYgZtE29+KgfPdk11W6Arbnzfcdf9t8yLdP8KvpgM180TZLLDKT1bwcH9ui99cZTw3n4616sekj11wxA6w8QYtHffq11pzW2CORF9z+xemLxNHCQ+IDaGbbWjIT7HIeVv3b0AIe4E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB4528.namprd10.prod.outlook.com (2603:10b6:a03:2d4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 28 May
 2021 18:43:50 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90%8]) with mapi id 15.20.4173.026; Fri, 28 May 2021
 18:43:50 +0000
Subject: Re: [PATCH v4] mm, hugetlb: Fix simple resv_huge_pages underflow on
 UFFDIO_COPY
To:     Mina Almasry <almasrymina@google.com>
Cc:     Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210528004649.85298-1-almasrymina@google.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <cbd3a3d6-1a4f-d771-1479-4c285ce49145@oracle.com>
Date:   Fri, 28 May 2021 11:43:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <20210528004649.85298-1-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MWHPR10CA0002.namprd10.prod.outlook.com (2603:10b6:301::12)
 To BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MWHPR10CA0002.namprd10.prod.outlook.com (2603:10b6:301::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 18:43:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0ff0aa7-ad26-49f8-8cf2-08d9220888f0
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4528:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4528A0EF95DE9698F0960DE5E2229@SJ0PR10MB4528.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVQQq9PJ6Q0kb4ZVnbOtuw6tsGZgzjxz+5A7otU5R2Gqn6OUhVedYuBKm4Et3AQ72HZLu33Sp3cGe0nqwYJlwI8suqmaGmrqcBMIKomrrZRrd0rpxc9ABLAvldOwv2to1FY4pRc3m8SNe1CbVRs4p5NgcuCfjzQryC5oWkdnaLFmDxZL5Fa9ghuAqtJdjkJsFwZsz9BpZhxHlvzckooUVsmPP8nLzg9zxFpZCiTHiYsXrfoU7aQdTjNRPyOXYHcg6VeO3ZZui+jeprtd+AXMlU8oFvTaLzF80MG8MGlHW2sFzZ8hxiFjvpyJlP2FJtNBa13JkVVPDihzENSrttQG75WcRPwTatATAZwWmLzoK+OINelezKQtLpy9JiNmk6UDwqn5Xp7o/U731mk6sJZWPKGKw7Wa9WKOfasc3VwcegeavH/x7oalfTV6bLEBUjqKknNToZhi1Nuy7EPkq8xzRkOl/zpZtGg1kM2P7v1DWxyhmasB3CUko61ywfj7pPlnycDWtt1edQepGaI5Kll0RGZjqCcabETQM9DWFn6JxOneel6KpjlhvoiPx66Je9UlDF1Vsrht/9XJXrge/nYvYlPbby/7riMFwlKgRFJZHFgQNPF8Md8aIJklcqKHlVHVJ6DOzIFRdCaiV4L+E2u8yyGD3D9L14pYViwoFI2Q43rOoyiw0656l0Bv9aCcdJnpcxaiCBj9fD2nMDtYwt5fHrCU7lc7NtYDxHBlWUVhvPszQ/6wHjEY0aWtapf0EqQ8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(346002)(136003)(396003)(52116002)(44832011)(53546011)(38350700002)(26005)(478600001)(66556008)(54906003)(2616005)(956004)(38100700002)(6916009)(316002)(6486002)(83380400001)(66946007)(66476007)(16576012)(8676002)(8936002)(36756003)(5660300002)(31696002)(4326008)(16526019)(2906002)(86362001)(186003)(31686004)(14583001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V2tqd2E3YklGOWRKcklrSzJibHo4K0hISkZyckU4cnoyZTZ0WnhrUGJmOGdv?=
 =?utf-8?B?MEUvUWZkRjRJQmNYQ0h0QTJUa0kya2hhVTB3b2NVL1VNMjc4Nk5ZVEx0dyt5?=
 =?utf-8?B?ZUtSNGwxRDRUL3ZFWnBReVBEcHNkTmpHVnhFTDVuQVFDS2Zva0FjbU4rWE85?=
 =?utf-8?B?L3hKRHpEdVdJOUhobmkzWU1lM1pnNDBwbGtPRFlLb01lejdUQ21LQUVYZU9T?=
 =?utf-8?B?VE9xb0Q2SHVic2cwOW9TenRsNnVjVDJrU2JMSDZGTXI3OERSMmdpNUxzZlZI?=
 =?utf-8?B?bUFsV0RUVVI2K3ptRnlKNGhWbjlnaGRJaWZWL1FUcUJMV01OZGs1bjBaVytt?=
 =?utf-8?B?WVZWZU1iLzd5ZjMzYzVjUFphQ3NMSW5MTTlFVTQzMUZTOHkycldFdjdrbWxD?=
 =?utf-8?B?WFdXbzB2b2dYeGtFTUVadlhrdXR1YlVBb1h4TVM0TTZJei9TcDdZM0dqT0hk?=
 =?utf-8?B?UUJZc25zVGVhVFdaakkxbG5SdTRCaktpajlscUJDVncvaVZKamExajlzaFFU?=
 =?utf-8?B?RFB3UGpvenJ0MTRhdS9qUXU5djdKTWtOUk9TNzVwM2RMaVhTY0p4bXZaS25z?=
 =?utf-8?B?T2JnTlRzOU9HOFJZRk1iR2RSQVBJK210Mk81ekt4dVRFS0FYS0VBV0VVMit2?=
 =?utf-8?B?Y3AzT2NGUWs4azN5cFlMVUQya0NxRE05TmltY0NHUjJBNTdrdTdUU1ZpR1Fz?=
 =?utf-8?B?ZDdDQStkVzE5NUVjdEJEbTZkSXp0MWQrQk4vMm5yMVR6cy8wVDVMTVJTTGVo?=
 =?utf-8?B?dEZSWFpHMkoxaUxKWmJrOS9tcmJUb2w2eGxZMEVXMGh1NTlLU2JWVE4vTWdW?=
 =?utf-8?B?UG1oekdhQ3cwL2Y3UUhHamZtcUZUakhDNU1vYm1iUUY0RWxoUGlSOTlGU3N3?=
 =?utf-8?B?ZE54K0trTDkxRkNnSVNUT25ERkdLOGVxN250bFhqWGtWSWJSeDlvVkZZNnJr?=
 =?utf-8?B?M1NmaWlnVGJFTFQ2ZnVwYXRMM0QwdC95eHBrNHJ0eWhYc2x5N0VtcFBibTgy?=
 =?utf-8?B?LzYwOHFrbnNBZ0p6UnpIUm9tOGluT0pkVWkxNkNTNjlVWFEwYWd4U2lYMW1H?=
 =?utf-8?B?V1lZNnJOMW11ekNybCttYURseEp4ejMrVG13YTRYS2lPZ3gwK2pIR0JaRi91?=
 =?utf-8?B?cXhqTGlDZDROODNpZDBhV3pKWUlTV2JhOFJZOWM0TzhQbjZiWnVxNTk4VUVD?=
 =?utf-8?B?MzVSNEltQnZXWUFuQjc0eXZ6cHdYbTdNT2U3aXduRFVKd3dKZlBleXZZd1FK?=
 =?utf-8?B?NzgyQkVoOW9pU3daVGVqUVNmd1d6M1V1TUlXYkJiMHdVdWlsWEkrK1oxMFB6?=
 =?utf-8?B?UzQ1dEdnY295OFpDeUFrQ3Q5akRYNHBJN2pqS3JZbGcrT0dZVjJMSGp2cWpo?=
 =?utf-8?B?UTBHU1JFVnpCbjAxOFd1cFVscXNUWFNscGxab2p2RUZ1Nkh4R095TjdTOWF0?=
 =?utf-8?B?SjdhUDhLVlRCYWhyY1AwY2J5WmhFYmkxaVpUU0NYcW1NRkZQc1ZTanhyRzVR?=
 =?utf-8?B?Q2tjUzZUUk5rNTFlYkV1Y1NBTjFGbEEvM0FIeDlJUlFQYUhwK21mekpQOG56?=
 =?utf-8?B?VnFZR05FcmxhSjRieFQxTnBrODFxVVVCQXl2QmdFUDVxam9nb25qUTRGdzlU?=
 =?utf-8?B?bWhRbkk2MjRjVnR1TUhBeFM4ZUlqWGI0bU5LVnNNdlVnbWJDZ0wycGlOSUlk?=
 =?utf-8?B?SE1PZnloQklEZ2FHMW8wKzFsbWRGQmlPQVBUcGVYUi9hdDJtcXVBeGlBWjQz?=
 =?utf-8?Q?U+35tSubLHJhZk+qx8ABQ5QsNeNlqFemgrxICtM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0ff0aa7-ad26-49f8-8cf2-08d9220888f0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 18:43:50.3946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KEEDvqmVY+/2CTykyw8PP6Sn4EOOSmysjjwqSa7F8zg5iNQ2g1grH4aNFEjLK4ZaF53JX4eOW/LhueDwSujKxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4528
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9998 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280121
X-Proofpoint-ORIG-GUID: 9QO1YiKAE-VImeMFla2K-ioIFBLCLJ1q
X-Proofpoint-GUID: 9QO1YiKAE-VImeMFla2K-ioIFBLCLJ1q
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9998 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280121
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/27/21 5:46 PM, Mina Almasry wrote:
> The userfaultfd hugetlb tests detect a resv_huge_pages underflow. This

Perhaps say,
The userfaultfd hugetlb tests cause a resv_huge_pages underflow. This

> happens when hugetlb_mcopy_atomic_pte() is called with !is_continue on
> an index for which we already have a page in the cache. When this
> happens, we allocate a second page, double consuming the reservation,
> and then fail to insert the page into the cache and return -EEXIST.
> 
> To fix this, we first if there exists a page in the cache which already

To fix this, we first check if there is a page in the cache which already

> To fix this, we first if there exists a page in the cache which already
> consumed the reservation, and return -EEXIST immediately if so.
> 
> There is still a rare condition where we fail to copy the page contents
> AND race with a call for hugetlb_no_page() for this index and again we
> will underflow resv_huge_pages. That is fixed in a more complicated
> patch not targeted for -stable.
> 
> Test:
> Hacked the code locally such that resv_huge_pages underflows produce
> a warning, then:
> 
> ./tools/testing/selftests/vm/userfaultfd hugetlb_shared 10
> 	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success
> ./tools/testing/selftests/vm/userfaultfd hugetlb 10
> 	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success
> 
> Both tests succeed and produce no warnings. After the
> test runs number of free/resv hugepages is correct.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: linux-mm@kvack.org
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> 
> ---
>  mm/hugetlb.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)

Code changes are fine.  Thanks,

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

-- 
Mike Kravetz
