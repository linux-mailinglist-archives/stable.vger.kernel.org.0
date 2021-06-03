Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CF039975C
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 03:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhFCBJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 21:09:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57170 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFCBJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 21:09:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1530xrOh065141;
        Thu, 3 Jun 2021 01:07:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=EkLvAeUqSWdTY6CP9iom+Uy3gQRRyL2rduptgnvqWc8=;
 b=L7MyEs+YgtK4ff1YuNhylZNGS9Bp9iFS7G6N3kFSv9DXHLNuFlL5SC03FrNIRe6F5Vbu
 DKh/owpi0uwXlzQim21gemSb51uHpOIgXoQgCCrvosSLJGNtBBYmiP3xRNhB1CbizPHX
 fwGdjjxOCViO4BNXgXvbsj+jSTXMx2YljTAdxzXlc3bYJ7lVeJHitngf09XJfHjQCWIC
 OwnWQeYYqTtYdqwxYsjZEfYoh0DSCiyYZ86H+gl89A2H/YVt2Q4D+EkiA31/dKkodoQ+
 Zo/wfIZeJ2SkwjFc9DrFV6gxVmiHLllZvBdMKSPqCVj5hjYLcITZhnlMeh0NJSumqniK 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ue8phyu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 01:07:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15310hUv077247;
        Thu, 3 Jun 2021 01:07:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3020.oracle.com with ESMTP id 38x1bddua1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 01:07:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D09hSS3LDjDfZC018VEpjcaGXE5TnWHKvK0W2y5yQLcG7f0umlS/iEYyRjjWr8Np3r4Gz1tv1GjXW7VUF92pXrR/ALVP6CAKwKS/hEbA6jQDq0RVgJOfzu/e9SeGs3UVVTQu9d0fTQzprWdjU1t9vU6m4e8y5MNlFE9lx1Z/L9g/DIh8mXtBI+gvEFo4BuLjxqOg0dzeEwg5sGGCGSexhUX3NtL2Z1kH2PmJQKFw9bZaql/PP/3laUA+FInhBaraUHA/Q3BVJycTf6j0gL98TPWCEwjlp2cPDABlOLUGJf/cHVjnxV3DYJBhi4g2MsF7FPqV6HSZyTU6WIGfrDUiEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkLvAeUqSWdTY6CP9iom+Uy3gQRRyL2rduptgnvqWc8=;
 b=fGCr3suKSy87iAjuOd1Q8G4PCeHTEmzbvIH5O35+ZJqssIpI+F1Q0Srvgcun3Vo0kRmvABYhQy8XU6mS+g3mGI6N3q/+CPezvT35OZD5KowoNeEKYwH3M4Kd1XA1OmmHewbR7al4KNQZ19UPoeTAH6ob4VCe5jTOTR766VoLy1o1uh57jO2K7n2mDvGOezgda/ucNsC3SYS7n/KGX1NYwKESQG3R0e4ljpqNXMS/SxqgueGloc92nIEkQD2hdm1oYiPGpP820daEMzMR7K8t7MeY8er3Fhx2cQx6s6JV4AKZKvH44Twy2bUJPeZOv5/1H41kCvInih/acppk4DUd0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkLvAeUqSWdTY6CP9iom+Uy3gQRRyL2rduptgnvqWc8=;
 b=uN1MzKBS8eADoboBI23JSLRI34OJDgzI49zu/NTfd959rj76//EDF6jwX8XyhAiOpZ1h+2DNIKAiXuT2dQxXD6jSc2aEek7KG3a15WAaftVExxNog3LaXxbdpgPKE+vjKcijWl07EWqLUcGUK57qbQaaCGWhjKZyNRmU4xRxd8s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB4703.namprd10.prod.outlook.com (2603:10b6:a03:2d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 01:07:49 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90%8]) with mapi id 15.20.4173.033; Thu, 3 Jun 2021
 01:07:49 +0000
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
 <CAHS8izPD4mY_5MgAfNnjCQPN3Xc3Ttn8KDnT4Ub3XwgiiGbSjw@mail.gmail.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <2436bc51-cccb-85dc-423c-0a9c45d80988@oracle.com>
Date:   Wed, 2 Jun 2021 18:07:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <CAHS8izPD4mY_5MgAfNnjCQPN3Xc3Ttn8KDnT4Ub3XwgiiGbSjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MWHPR14CA0024.namprd14.prod.outlook.com
 (2603:10b6:300:ae::34) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MWHPR14CA0024.namprd14.prod.outlook.com (2603:10b6:300:ae::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 01:07:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a0b668b-a126-4351-afb5-08d9262c0172
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4703:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4703D983FE6B690AE6485CFEE23C9@SJ0PR10MB4703.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MYmqTHrL0p4pCGNtVOBabKlZaKdsCuCN8PbiDrYH0RHod+u2ll3K9yQSGOgQjlobILyPoKTmceVkyhFRJtoj5ujdOFJ3FpaQ+1iPT4O7Aep5ySovpUHDjcrONtCadviUh9JW5EW4/CHXzyY4Vk8PT41RfwrsP08TK3ViLTZh/0Tvtesg5oRFakfpybQENygXpgETZCnFBuTg2yEbhLWZmG3a5UQSvM8FQ0WxIUiEJiMsRvJ5DH0qi2TNpMX7oc8z8q4ocd4LDp6eSkygNHIXhfcZq8af8SHPW/sDUAycuAxFsy/OdiVMtUr27SY7g3BZWki3pcngO1W3fUOo99RU8A1zI0vuIxDvpXDOuj3J1sM/tqQUtBPFai7iLU4owmuJ5x6SFHOdbLkUv7+RJqgZ9i9EbpTqpfX/CLQCf7ANu0DKRiSt+8nfLovahGhKD0V3QhDLYW3yk14kL1eM14ajgEO4Y3RDElg9QudKDZjJoWjMNhP1bSoxrT2+xvOlJ4T6lXuciGWBNDr4TD1uz9JhQV8W7tRcVpUh9iF1cg2SVMRpo6ptiLFy5hSHqQ56JPKE4OTSq7/Fpt5HCfgKHT4B8RonrE1RPZnxacme9K2pkXWOPNhJuJzPrA/JWbScv8WqN7sZEQb1Y2ArH7lG7FkXk2GDCQ9Dr6Mh3RleWpHGr963lSBoO6DYWcuyF9t5hHTvYG648WzZN/qclmZtc3olLkZ2kZ8Hel06AczcANSuxxjlBoDKBdLnZCVwiK+fX/PbkIarPJCAU4+z4g83wFYFoMAchLg2bE7qpl3+qmwRBlBCk3lBRzE+nWEMLV3HdxGTWMl1TuFnw4Ku8eZnNdFu9dc5anSfqR+AMgJxPpwA8zI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(136003)(396003)(376002)(478600001)(966005)(5660300002)(316002)(83380400001)(2616005)(6486002)(54906003)(66946007)(956004)(16576012)(66476007)(44832011)(66556008)(53546011)(31686004)(52116002)(26005)(186003)(16526019)(7416002)(38100700002)(38350700002)(86362001)(36756003)(8676002)(31696002)(6916009)(4326008)(2906002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NjNSZnNmeEl2VzA2VFpHV0lLb2RDazRmV3BqbytyNlh3V05HK2ZVMU9PbWhG?=
 =?utf-8?B?bUMvVEt1dXhtZ0I1cWlaTk1yN3QxNFJRbmIxYkY1enExUjdUaU1jVU55QVZ0?=
 =?utf-8?B?SkYrQTZzUXVadFVwbng1ekVlSG1Qa3NlTTAxa3JPaEUwekRkRmtQeUVUWXZU?=
 =?utf-8?B?NGJHRmtlRzBMTmUxbVc2WlFpbkx2VmlUNGtiZHBINjJQR2dLUUVORzR5OW9O?=
 =?utf-8?B?cnQ5ay9zUEhLbnE1NStHME1BMnY0ZGNIaHNBblNWN2xSNmZrd1JQSUJrdnFW?=
 =?utf-8?B?NkNHRkxRc1JxakJXQ3AzM3hUYUF4Zm9CSzlLdnVUSm1VWlR6Q0t5bjROQ1VD?=
 =?utf-8?B?dmVlT3RNUnNjNWNiZzIwWGZ3dDBCMFVnTDRHeTVWTHY2M2ZnYzJQZVAwY1h5?=
 =?utf-8?B?ZmxqRzkvTzNGWWc1aUd3VC9DelJUaW8wUDU1aFdmS0ZxaHNVcU0xcHhrVFNC?=
 =?utf-8?B?SmRaT1FkanlOTktaZW55QVVaY2w5WGxZUkJQWlJWMU94TmkvV2tNVmJZdlVm?=
 =?utf-8?B?ZGZLcS8rbllLQXJWWVdzZldjZS9xb2FLT1Z5V0VHbHAyQWtNandSdnRPQXhO?=
 =?utf-8?B?TTZZYVRWaGQ2RllOKzBJbk01SlpaZThCN1hzdkduUjNHQ2xiN3Z1ZEJOWUMz?=
 =?utf-8?B?OS9CbEI1TCtYQVNDTzdUeHBFMXdDU2ErRXZicFZjbVF0OVhoaDVqaU1JOTBR?=
 =?utf-8?B?Ky9jT1dEaU5DS2RLT0dNeGpkSm9jc1QrWisyOXFhVzRDUjFCdW04MWFraEp4?=
 =?utf-8?B?TSs0OWRscitINlMycjZzbkN3eGtlKzR0a3h1bzhyclFFRW54SEV6WU1Pa09F?=
 =?utf-8?B?YkVMb2ZvYkl5ZXRLcEs0elZIeHBidlRub3lxaDhabGpqb1ZZSGNFQXRXYjBT?=
 =?utf-8?B?WnhtMkVzalJYZU51QkNScm9COU1WUEJMdFhRczNyTzlEWHBPMTJpOWpURkow?=
 =?utf-8?B?Y0VEa0szTkN4UzRPVG94WVcyTWRmQzhVMTEvY3h2czlWNnNkWEMvdG5vSXox?=
 =?utf-8?B?SWM2c1NvejMyOER3Qkt5SEd6cmRWN2E2YlRvYXNVbjFsaDhta0g3SVJZWjdj?=
 =?utf-8?B?S3d6UmtZM2ZhaXJDQjZLMkhjSVBUV0hpM3ZlRm1QUStnRUlrdlF6aGw5d3BZ?=
 =?utf-8?B?TksyT2owdXZwbW5EczVpaUpsWHVXdWJGakd3clg0OXJkSXliQ0JmRWhRYTJq?=
 =?utf-8?B?bjQ3VjIzcDM3MXUxbVlyZCthbjVwOTVpN1VhZGlBbEtnQjhxd3V1RVArWDR0?=
 =?utf-8?B?MWt0aS9ESGpRaGRJOEhPYTJZbk1PTjlyWnB4Q1Y2d2RWQ3NnRDBYY0pPSDh2?=
 =?utf-8?B?dStBT0NjbCtNWUVCL1ZjWTR2bWx1ZmQ0SmNCREs1Ymx0K3lydUFXY1V4UzMz?=
 =?utf-8?B?OWY1cEYxRWlxaWd3dDlma2UzRW5pKzJxa2VWcUdxWTZhZU1ZallJWWNJMTM5?=
 =?utf-8?B?eWJqVk5xY05tdzdJQmtFaERiM2dpZXBYdDJYTkNLN2EvekpMSWdLR3QrSXlF?=
 =?utf-8?B?dFlPMld0SW1PTHlja1lmcUVxamZTZ3N1b1lnOUdOckx2b1pNOFUxR2NuNjRx?=
 =?utf-8?B?ZGlJRFVTZUN0bk44aDB0SG54ZDZJcHE0Y2Evb2pwYThtY3EvV1BDVkV2bVB3?=
 =?utf-8?B?MmJZc3RENlluRHAyWFJhU0RvbXBnSFdlTklGb1J6N1J0UXJSRE9zMklBbXF4?=
 =?utf-8?B?OG1hc3hhZTg0SzdYZkREQUNjWElVcG5FcFdWYTQveVdEV2orcHBXQUdTR3lJ?=
 =?utf-8?Q?Cen8UEeXF3dokgWVPx2SHV10Bf6OEGcYz/tAvWi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a0b668b-a126-4351-afb5-08d9262c0172
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 01:07:49.6376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6zo3gtnVr0NfQ1FkliogmYOAPeZdPQ9Om/npVtTrekbBC3/ZTvUy9BiSH9Ogtrer/J1Ccrkq9IBWeyqw219Zww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4703
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10003 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030005
X-Proofpoint-GUID: IpF3XF_DuEtRotvnkIhTAjCHCZo8ZET5
X-Proofpoint-ORIG-GUID: IpF3XF_DuEtRotvnkIhTAjCHCZo8ZET5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10003 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030005
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/2/21 5:38 PM, Mina Almasry wrote:
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
>> ---
>>  fs/hugetlbfs/inode.c    |   1 +
>>  include/linux/hugetlb.h |   2 +
>>  mm/hugetlb.c            | 120 ++++++++++++++++++++++++++++++++--------
>>  3 files changed, 100 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>> index 21f7a5c92e8a..926eeb9bf4eb 100644
>> --- a/fs/hugetlbfs/inode.c
>> +++ b/fs/hugetlbfs/inode.c
>> @@ -735,6 +735,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>>                 __SetPageUptodate(page);
>>                 error = huge_add_to_page_cache(page, mapping, index);
>>                 if (unlikely(error)) {
>> +                       restore_reserve_on_error(h, &pseudo_vma, addr, page);
>>                         put_page(page);
>>                         mutex_unlock(&hugetlb_fault_mutex_table[hash]);
>>                         goto out;
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 44721df20e89..b375b31f60c4 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -627,6 +627,8 @@ struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
>>                                 unsigned long address);
>>  int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
>>                         pgoff_t idx);
>> +void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
>> +                               unsigned long address, struct page *page);
>>
>>  /* arch callback */
>>  int __init __alloc_bootmem_huge_page(struct hstate *h);
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 9a616b7a8563..36b691c3eabf 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -2259,12 +2259,18 @@ static void return_unused_surplus_pages(struct hstate *h,
>>   * be restored when a newly allocated huge page must be freed.  It is
>>   * to be called after calling vma_needs_reservation to determine if a
>>   * reservation exists.
>> + *
>> + * vma_del_reservation is used in error paths where an entry in the reserve
>> + * map was created during huge page allocation and must be removed.  It is to
>> + * be called after calling vma_needs_reservation to determine if a reservation
>> + * exists.
>>   */
>>  enum vma_resv_mode {
>>         VMA_NEEDS_RESV,
>>         VMA_COMMIT_RESV,
>>         VMA_END_RESV,
>>         VMA_ADD_RESV,
>> +       VMA_DEL_RESV,
>>  };
>>  static long __vma_reservation_common(struct hstate *h,
>>                                 struct vm_area_struct *vma, unsigned long addr,
>> @@ -2308,11 +2314,21 @@ static long __vma_reservation_common(struct hstate *h,
>>                         ret = region_del(resv, idx, idx + 1);
>>                 }
>>                 break;
>> +       case VMA_DEL_RESV:
>> +               if (vma->vm_flags & VM_MAYSHARE) {
>> +                       region_abort(resv, idx, idx + 1, 1);
>> +                       ret = region_del(resv, idx, idx + 1);
>> +               } else {
>> +                       ret = region_add(resv, idx, idx + 1, 1, NULL, NULL);
>> +                       /* region_add calls of range 1 should never fail. */
>> +                       VM_BUG_ON(ret < 0);
>> +               }
>> +               break;
> 
> I haven't tested, but at first glance I don't think this quite works,
> no? The thing is that alloc_huge_page() does a
> vma_commit_reservation() which does add_region() regardless if
> vm_flags & VM_MAYSHARE or not, so to unroll that we need a function
> that does a region_del() regardless if vm_flags & VM_MAYSHARE or not.
> I wonder if the root of the bug is the unconditional region_add()
> vma_commit_reservation() does.

Do give it a test.  I beleive I tested in the same way you tested, but
could be mistaken.

We may not want to always unroll.  vma_del_reservation is only called in
the path where HPageRestoreReserve is not set.  So, no reservation entry
was present in the reserve map before the allocation.  alloc_huge_page
likely added an entry via vma_commit_reservation.  Since there was
an error and we will be freeing the page, we need to make sure no
reservation exists.  As you know, making sure a reservation does not
exist is different for shared and private mappings.
- For shared mappings, we need to make sure there is not an entry in the
  reserve map.
- For private mappings, we need to make sure there is an entry in the
  reserve map.
That is why vma_del_reservation does a region_del for shared mappings
and a region_add for private mappings.


> Also, I believe hugetlb_unreserve_pages() calls region_del() directly,
> and doesn't go through the vma_*_reservation() interface. If you're
> adding a delete function it may be nice to convert that to use the new
> function as well.
> 
> I'm happy to take this fix over and submit a v2, since I think I
> understand the problem and can readily reproduce the issue (I just add
> the warning and some prints and run the userfaultfd tests).

Do run your test.  I am interested to see if you experience issues.
-- 
Mike Kravetz
