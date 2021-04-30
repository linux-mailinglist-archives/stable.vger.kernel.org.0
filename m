Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11F836FE2E
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 17:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhD3P6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 11:58:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34930 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhD3P6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 11:58:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UFo8P9162650;
        Fri, 30 Apr 2021 15:57:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=rPJGzmI/BxBYkTfZJZozKKv9dwf1NBpExXu0IBau9a8=;
 b=S5aHKOqYcKqUTA444gzuqeN6+a97FMDcxai8no0n2OuaR/RB1CDyRZjfSFrylbzsqrEM
 Csu5gINCoNOfzJQGnoEP54R+YDJTwVrSp4WHHDfoyrplDCtkyiHZuTOt7Ml3HuOI8+wj
 lXUKK49VsQBGIx0XCC1xzN1R7DMScJP8ADz1+oJfR/tCvpFPoii1N5QbiBxLO8RTPRcm
 7ICmAmKHAmsb/CPDEsNwff66TXAVKTYs5aLbnb1GRT9288E2haqv9dnPvxQyzE5RiHRN
 YtJIIwOqIqR+J+hyOQfTlK3n9mZaRLyrKqIfx1Dx2tDIquKwSUshXBF7FXp4VzFbOc78 ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 385aeq86ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 15:57:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UFv05w043530;
        Fri, 30 Apr 2021 15:57:31 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by aserp3030.oracle.com with ESMTP id 3874d53vme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 15:57:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1cQzwdWXZ9h+i6OYtqCP6CPCgQUJjyK9uAoKt8yhTySxHZmaEh7b9NN9oefHz0mQ2XScoBshfda3JGsePM22yPsMROpwW863nJ1DB3dvpT9DgA2iTOs/N6t6VXlT7EULnlSmIhLa/4s7byP0EJBrQrc2O/o4P1rpoTIhqrDmZlIsOo8SMhxM+JGdj2y0lfJo1yGG3TDCcyKZAz/FFM51HCkWg+2WT5y/6ysJ0yBGdB3j0+ViK57TCXtylwE0Mx1fQfIoKL9oNgyy+/aFGqFqi8I+Ay0J8YuuJJ9BOJ96y/kPC/5zxWJpapxIy9c/AIXWVS0MbPThsI4dmck2jx7CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPJGzmI/BxBYkTfZJZozKKv9dwf1NBpExXu0IBau9a8=;
 b=L6uINiJstwhkaTIzbgfhBHz9G+Qz3YJdC5Jyfm52utNyb3QkkJFXO76aUidMynaeeeY5Ji+YpUSHkI//TTp6/k14j2VtB1cMVXbmu+DztHEqi+u5x5ar3AQx4Kpv77qe9A3aiTohdoyRLeNRR8VqfQ1RGRj9n5ifq3IbxOeXxnUawe9OFqTyFjlE0IKzruRB+syXTCLC6TwFLyQljzi8aoGswkPvmdkXpl+foTd9MJ51gQZMSqf4edQfcGyTD1CqmMJwgN53nHcvqhX636CqrP/RADX/nPPfu2qV7+Ir7D6yqrDRDTiZoty946osJ3g00QOLUcvrWZ9A7Rnjz9w7pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPJGzmI/BxBYkTfZJZozKKv9dwf1NBpExXu0IBau9a8=;
 b=qplUgLAe0dKtH1mIeKPTGvQhxDLOQLVpOWIv45QI5pgpwpkAalUizBxTf5eK+/qt1OiVUeCFTc9Qbgz2fta/QlAi3D1BFsXUaZo8SrnQrBoV7KbheZJVRT3N6xRJdnjQlwADhq3Wr3CjEwxa+kbgUtqkbJezP6NzZdJlFciH/gA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3851.namprd10.prod.outlook.com (2603:10b6:5:1fb::17)
 by DM6PR10MB4252.namprd10.prod.outlook.com (2603:10b6:5:215::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.26; Fri, 30 Apr
 2021 15:57:29 +0000
Received: from DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6]) by DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6%7]) with mapi id 15.20.4087.035; Fri, 30 Apr 2021
 15:57:29 +0000
Subject: Re: Needed in 5.4.y: [PATCH 5.10 055/126] ACPI: tables: x86: Reserve
 memory occupied by ACPI tables
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dhaval Giani <dhaval.giani@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86 Maintainers <x86@kernel.org>
References: <13f5c864-9b15-b2dd-53e1-d71b27a94a74@oracle.com>
 <69f6104e-ca54-5686-4cbf-dc14cb1697f3@oracle.com>
 <YIjrQdJtpJ0br5m9@kroah.com>
 <db5625eb-f304-2f47-49f3-5fb7b3d019e9@oracle.com>
 <36779f96-2314-fd35-7c02-accd6da0be56@oracle.com>
 <YIwIvx+uBBb/nz+S@kroah.com>
From:   George Kennedy <george.kennedy@oracle.com>
Organization: Oracle Corporation
Message-ID: <31211f9c-56ee-d5b5-ccb2-eb58a324c548@oracle.com>
Date:   Fri, 30 Apr 2021 11:57:27 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <YIwIvx+uBBb/nz+S@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [108.26.147.230]
X-ClientProxiedBy: SA9PR13CA0132.namprd13.prod.outlook.com
 (2603:10b6:806:27::17) To DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.228] (108.26.147.230) by SA9PR13CA0132.namprd13.prod.outlook.com (2603:10b6:806:27::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 15:57:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8ec6fa4-84b7-4daf-b464-08d90bf0a863
X-MS-TrafficTypeDiagnostic: DM6PR10MB4252:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB4252BDB5A8837DCD410E9CE2E65E9@DM6PR10MB4252.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BTO5yS461GuQMMx4kZbCKu0r3eLReepR5gpsM3mvYjuNB6xmoqVInXvgPMluLS13k9F0jWuvWUjsrzxl3/A0v+FneEJwZsvxXvsWNokJ36C1Dm8If08cMtPxM9zbB/zLx8DOMf0/Au099RvETB5FmxXgqX7KcQ1lReBgBd6/VhT1YARuCA0xmQztYxEh9rAjSXuOL2G+RVcJDyrIPqvoiIHVhaCY6tcgaay9p6Y14zdztf290mJYD7HEMOiIWJMfua4fc31SEqnvFFo5BAJHmRkm8HjHLymSzMiG5QPc8T96fUgol0OYHC1CCp9FezpCUr+ZraztZe7KD5lcMtGqbKpxaN5mI49fuf1Asmkuv0DdUQl/wb3GPxFZ6MHhyJaO573mWtmgeG2X2Ig4tWbC0PYz0DKPqG2Q5D+0NXTT8IrTACw3DTud3NvNP6quiAsge5oo4rQelPuvBBXrrrsOlfqfy50rusxommkf3AsCFnl8Ss9oxgKqO6Hay3kQJ0ujQuy9rHcR4JvQeqoQtHyjPP/bdKZt6xyQ7ujNMSNpr9HK8GtM9OXUlcu6e6dOV0nGSEW70BFQAVgFix0DNWmX9mHdkVccSCAhqM6anGXu5Ru4LqYUCKkS6QZAkCrxa63v3cl6gnQcj2veyzmD/7NXPpx/uTKAt44jOQXyTlXuMVgzAq1E3Buqle5GEfNkIQOe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3851.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(396003)(376002)(5660300002)(316002)(6916009)(38100700002)(36756003)(956004)(36916002)(66946007)(26005)(86362001)(16526019)(53546011)(2906002)(4326008)(54906003)(16576012)(44832011)(186003)(31686004)(8676002)(66556008)(2616005)(31696002)(83380400001)(8936002)(478600001)(6486002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?LzFLSmJVcVY0dThMY1p3cEh0OWRONVBidzhBQXlKYTJhS2N4UGU4U25kYWZi?=
 =?utf-8?B?ejJpTkxjYUY1aXpkd1djUkNFd1Q4ZnFmVGdDaXg4L2RqWnU5VFYyR0FEeXFw?=
 =?utf-8?B?aUJwSVlJUEZ4aGFxT3loQ0grL3FlS2dnVktKdDY4UXVCQ0VsUWJUcDIxU0Jp?=
 =?utf-8?B?eHM2cEVnLzhSUVJuZHlMQkpZeGRBdWF0eUxwQmt0ZGk3SUNkWjZmb0ZxVEdm?=
 =?utf-8?B?Nnpkb0ZHSjUwVWJYTE5QanF3MjZwUWtTb29iRnVCS2dERE84V1pCQmNaRm5M?=
 =?utf-8?B?YU9XVWFjMHF0QUgrTy9MOTFtMzJKTTlEb1BaaXNpbTliRG0za052WjQrUlUy?=
 =?utf-8?B?cTRGaXVpVThlaTNRelptM2RHL3M4akhUanA1MytpdWh3OGx0K2tiWU5iaTFV?=
 =?utf-8?B?NWJ0TWpjd3NoU2VZcEZsNGNORmxwVnhrNzNYb0VIQXJrcFlLbVZWbmRGZzJo?=
 =?utf-8?B?Y2UvdWVJNFhiOVhWSW93bGpFZysyRGdISS9NcFcwZWZFcWJrcjkxN2ZnUmk1?=
 =?utf-8?B?YWUvQU1vRysvT1RVZEthdTVQMW1aT2pPUTc1QkEwcHA3NGlWSmxvb2JySHN2?=
 =?utf-8?B?K1FGemdHaHBGMk9YaXlkRDdvTFpkT2tuWnRERVRYeC9ya0UzQTlqTUMvcTgz?=
 =?utf-8?B?anl4R2lWZFdZTTFPZklrNytXcUtsTjQ4bDVvKzFtSWJOVnJhVElJM3N1cnpP?=
 =?utf-8?B?RlV0Mzk2UGx5cWFmWVZuYlNBanJxS0svcEYvR3VsQ2FTY3pMTE5aTTBOekJR?=
 =?utf-8?B?UElOZnVNck93YlJWZFFLdlAxRmY2NU9QbTlYS2R4akpCYjVqdWJ0YTBYZzVn?=
 =?utf-8?B?alZ6QVRYQXFnakJNaHZpVE9HMjc1bEF2SktrZWh6K0tvN2RnTzNZcjNCMG1S?=
 =?utf-8?B?RGlMYmJWZFNJNXJLOW9hRmNlSUw4Y1ZESFptTnd6OFJDRVd4VE0wYXVJVkJ5?=
 =?utf-8?B?SXNpWkd4TWpwYnRwS2xtV1FOSjhrUGsvRDllemZjUjlmQXBvWHZ5TzRteGRh?=
 =?utf-8?B?aW9xM0NJcjRkaGlvQlVNaGozLzlJOCswWmhyU2t5Rm5UMjFlTUQ1SjBBTHFF?=
 =?utf-8?B?d0ZPNXJtUWNjNzJsR1BqalJEUE5sZjM5V2Urd1FlZE1oWDN1Mm1MOS9MZlVU?=
 =?utf-8?B?L0RBWkF0WHM4MEZ1b1VwMVlmZUlrVDNhaDgvUmorZHpTZUhQMXU5OG8yREFY?=
 =?utf-8?B?NTFvcmFhb01IRjU1ZDl3ZmZNU3k5Y3JiWGQ4aWlUZCt1eVRTVmZ3V011Y1B4?=
 =?utf-8?B?WVMwcVVCYVRXQWJxOExQMUY2R29YVHkwQlJZa3NLUVpReWtFNktySlRJVmZh?=
 =?utf-8?B?SGhTRk9EN0pYdDlEQldlTkhZMlRBQUJLWFY1RjMvZ2lYODNpMXlWQkgzais0?=
 =?utf-8?B?dEp5ek96UTB0QXBUK09YeXI0dVJtMTB4NHQ2Qk01UVdGTldVbGd5dFp3eXZq?=
 =?utf-8?B?c1o4czg2ZmdudlQ0NUtyWFIxb2ZyUlI4c2xma2RrL0hyWXUrckxsckhSeGU5?=
 =?utf-8?B?cmFieWNOT3k0TVZ0bjJNMzZieWJzMWQwSEpuemxGSWpaK3pOcmpaczFUa2xB?=
 =?utf-8?B?WXl6Mm9BUmNONGdIR3dKQVNYb3BmZi9SQlRwMHo5V3JtSS9zTGRzeFdkRmJj?=
 =?utf-8?B?VVk1Qm1wZ0liOVUzZXRPRmJodkcva1FFSEZ6ZmZCWXFjMVlNQXBVUHY4UHJ0?=
 =?utf-8?B?WW9vRy9RdWNad21WSmY4WGh5UWdsNlIzTzA0eDgwK0dremNJL1Z6UjQ2VWZQ?=
 =?utf-8?Q?F1T4Er/G1I3Ew5zxr1oGWtXhKM3knXXB/ybAgSh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ec6fa4-84b7-4daf-b464-08d90bf0a863
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3851.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 15:57:29.6757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R2BGyjfcgE4u7yahkrmeHwH731NGLnFFFlK1gmHqpCQpOX+mfi60p0t0tGYX4xRe9t/X8XVH1bauPuBa0VvHRlM8BM5R9oh2k+DzkxxaTxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4252
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300107
X-Proofpoint-ORIG-GUID: s-kzdmvNZZjLXw-xGRv_9h8oPJ4e3jih
X-Proofpoint-GUID: s-kzdmvNZZjLXw-xGRv_9h8oPJ4e3jih
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104300106
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/30/2021 9:40 AM, Greg Kroah-Hartman wrote:
> On Thu, Apr 29, 2021 at 01:24:06PM -0400, George Kennedy wrote:
>>
>> On 4/28/2021 8:52 AM, George Kennedy wrote:
>>>
>>> On 4/28/2021 12:57 AM, Greg Kroah-Hartman wrote:
>>>> On Tue, Apr 27, 2021 at 06:18:05PM -0400, George Kennedy wrote:
>>>>> CC+ stable@vger.kernel.org
>>>>>
>>>>> On 4/27/2021 6:17 PM, George Kennedy wrote:
>>>>>> Hello Greg,
>>>>>>
>>>>>> We need the following 2 upstream commits applied to 5.4.y to
>>>>>> fix an iBFT
>>>>>> boot failure:
>>>>>>
>>>>>> 2021-03-29 rafael.j.wysocki@intel.com - 1a1c130a 2021-03-23 Rafael J.
>>>>>> Wysocki ACPI: tables: x86: Reserve memory occupied by ACPI tables
>>>>>> 2021-04-13 rafael.j.wysocki@intel.com - 6998a88 2021-04-13 Rafael J.
>>>>>> Wysocki ACPI: x86: Call acpi_boot_table_init() after
>>>>>> acpi_table_upgrade()
>>>>>>
>>>>>> Currently, only the first commit (1a1c130a) is destined for
>>>>>> 5.10 & 5.11.
>>>>>>
>>>>>> The 2nd commit (6998a88) is needed as well and both commits are needed
>>>>>> in 5.4.y.
>>>> Is this a regression (i.e. did this hardware work on older kernels?),
>>>> and if so, what commit caused the problem?
>>>>
>>>> These commits are already in 5.10.y, what changed in older kernels to
>>>> require this to be backported?
>> Hello Greg,
>>
>> Can the same 2 patches also be applied to 4.14.y, which one of distros is
>> based on?
>>
>> 4.14.y crashes during ibft boot with KASAN enabled without the 2 patches.
> What about 4.19.y?  You do not want to skip anything in the middle,
> right?
>
> And I need an ack from the authors and maintainers of these changes
> before I can take them into the stable trees.  Any reason you didn't cc:
> them all?
CC+ maintainers

Rafael and Mike,

We need Rafael's 2 upstream ACPI commits (1a1c130a & 6998a88) backported 
to more of the stable branches - at least in 5.4.y, 4.14.y, and 4.19.y.

Can you (along with the other maintainers) ACK the request?

Without the 2 ACPI commits, the failure occurs in latest 4.19.y and 
other stable branches. Rafael's 2 ACPI commits fix the crash.

[   17.239703] iscsi: registered transport (iser)
[   17.241038] OPA Virtual Network Driver - v1.0
[   17.242833] iBFT detected.
[   17.243593] 
==================================================================
[   17.243615] BUG: KASAN: use-after-free in ibft_init+0x134/0xab7
[   17.243615] Read of size 4 at addr ffff8880be451004 by task swapper/0/1
[   17.243615]
[   17.243615] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 
4.19.190-rc1-1bd8f1c #1
[   17.243615] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 0.0.0 02/06/2015
[   17.243615] Call Trace:
[   17.243615]  dump_stack+0xb3/0xf0
[   17.243615]  ? ibft_init+0x134/0xab7
[   17.243615]  print_address_description+0x71/0x239
[   17.243615]  ? ibft_init+0x134/0xab7
[   17.243615]  kasan_report.cold.6+0x242/0x2fe
[   17.243615]  __asan_report_load_n_noabort+0x14/0x20
[   17.243615]  ibft_init+0x134/0xab7
[   17.243615]  ? dcdrbu_init+0x1e6/0x225
[   17.243615]  ? ibft_check_initiator_for+0x14a/0x14a
[   17.243615]  ? ibft_check_initiator_for+0x14a/0x14a
[   17.243615]  do_one_initcall+0xb6/0x3a0
[   17.243615]  ? perf_trace_initcall_level+0x430/0x430
[   17.243615]  ? kasan_unpoison_shadow+0x35/0x50
[   17.243615]  kernel_init_freeable+0x54d/0x64d
[   17.243615]  ? start_kernel+0x7e9/0x7e9
[   17.243615]  ? __switch_to_asm+0x41/0x70
[   17.243615]  ? kasan_check_read+0x11/0x20
[   17.243615]  ? rest_init+0xdc/0xdc
[   17.243615]  kernel_init+0x16/0x180
[   17.243615]  ? rest_init+0xdc/0xdc
[   17.243615]  ret_from_fork+0x35/0x40
[   17.243615]
[   17.243615] The buggy address belongs to the page:
[   17.243615] page:ffffea0002f91440 count:0 mapcount:0 
mapping:0000000000000000 index:0x1
[   17.243615] flags: 0xfffffc0000000()
[   17.243615] raw: 000fffffc0000000 ffffea0002df9708 ffffea0002f91408 
0000000000000000
[   17.243615] raw: 0000000000000001 0000000000000000 00000000ffffffff 
0000000000000000
[   17.243615] page dumped because: kasan: bad access detected
[   17.243615]
[   17.243615] Memory state around the buggy address:
[   17.243615]  ffff8880be450f00: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   17.243615]  ffff8880be450f80: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   17.243615] >ffff8880be451000: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   17.243615]                    ^
[   17.243615]  ffff8880be451080: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   17.243615]  ffff8880be451100: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   17.243615] 
==================================================================

Thank you,
George
>
> thanks,
>
> greg k-h

