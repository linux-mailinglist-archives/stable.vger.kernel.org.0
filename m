Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1347E4A6606
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 21:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242580AbiBAUi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 15:38:59 -0500
Received: from mail-bn8nam12on2083.outbound.protection.outlook.com ([40.107.237.83]:20192
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240671AbiBAUiU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Feb 2022 15:38:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jfzwer21CtyyPWHr0E9u6lHBA2mkSTcgW+E4HPYOiPSGKkoKsKPktKcYjR1dpzeYSN2PTDATRz/iAVgVGAL0d4rcrfi2+p+8NTrEISSNDTmoSUWVhk4EbHXRM6aDI8tYEnhsRvZX6KQn8ZMTR54G7/S1/XD9f34VIX0ZUi2fREZC1ZpfZwmxsRt4AetoF62728kN7YMft+WmdCOwqGTfqIhbAoqf0wy0vaZ5MBiV2ehHeIA8NXWGm+XAzIZ/cBtlhAPFMfunlvLd5Xp3DWYQk3LDUOTrFF0DIFD+UmEVBC43731Krf8SJnLBxvlMG2HbNBQnHqKn7PTxLNjH5pYz4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OjwP/cNGeeIMZZxCIvXiwbVBBNOZDvVUB86/Qo1hkJM=;
 b=T7dei4raPV4/KFDShog1w4smUopeqaLwy18aKHNSGaZ8Fd+ijGBa06gYGux2Fdy5EcXzyHJFdSNycRkFoOn7MgV9VyP/a1RLYJ1GyRqJGNYJfO3tbK/EWxNA6fRBs6IHmpqp7+8AMxJyJNGPnbVAGun4HdYUU66yqTQyuocKl4pxwloKrJ+fF5GsAXmaLAbT7P7W016EhUbzrZpyzzWTss9MnDI0xP1anofz3HXObC2gnj5zdoTmNB4ZKngFaPA7955Fsfgn5aePh5YOif+SUZ+s5eAnDfmq3UTMlg8UDsFaWs5Lntxsam30T4VqLNDU5CGe2FSbJdwhge/SsH2Zkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OjwP/cNGeeIMZZxCIvXiwbVBBNOZDvVUB86/Qo1hkJM=;
 b=tW0101LNMFzU9ncwgxSxVVPZD4qhcg2B5CNr7HTqCHnsHHmqSIScLVxpfZYGvrsCSjTokeI0xjMd+NHPAfI8UiP1PaoTL7eWje6Sk9+uMQX6Hvy+5ziLSEZlTrSiglbOLQwdwFsYSjgIOR5yQIC0YoG2o4+3cv9yOOj+eskSOM1SnvHjQHHtsd/vVeY+A38gzoA9FNHwhUQF/fmJzXXbn2kmghz3FI20FD2IoEfCGkfWY1FTtLp2cQl+hU+FRemOVhhH9Xk0IS9TTgXJ5u/fZOaOJWxJhVdtZx5yfC5GkkhV0j7D9JgaOQUZGMfc43EZ11VYS6pPdi6qLMfokPY7Bg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by PH0PR12MB5403.namprd12.prod.outlook.com (2603:10b6:510:eb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Tue, 1 Feb
 2022 20:38:18 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::2d75:a464:eaed:5f99]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::2d75:a464:eaed:5f99%6]) with mapi id 15.20.4951.012; Tue, 1 Feb 2022
 20:38:18 +0000
Message-ID: <f0f5db0e-dec9-7291-3a6f-645a8b3df90a@nvidia.com>
Date:   Tue, 1 Feb 2022 12:38:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] Revert mm/gup: small refactoring: simplify
 try_grab_page()
Content-Language: en-US
To:     Will McVicker <willmcvicker@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>
References: <20220201092927.242254-1-jhubbard@nvidia.com>
 <CABYd82biLQ7x1zD0MibXMrMHD9Y-cejitbNo=M2=tPNfUMTePA@mail.gmail.com>
 <CABYd82Y3rFUpCpoudxuYHL6YfuXM19hO1g1FWFCQpSZWMo9p8w@mail.gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <CABYd82Y3rFUpCpoudxuYHL6YfuXM19hO1g1FWFCQpSZWMo9p8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0282.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::17) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26994833-0b9d-4736-715d-08d9e5c2c733
X-MS-TrafficTypeDiagnostic: PH0PR12MB5403:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB5403452A9438F51DB999AECBA8269@PH0PR12MB5403.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gnrhvt1ifRan6Vte8tSj9ozBRLj4j5TZbOs+CzJAirX9YbnMNn0yX3M5a0SkEejhzcfdRoGkdhmvcH8i2vx9/Di8eW9QZuPR6wIjZu6KzfQajDSl2bsR5iywPL1MhWROyi5TIdqqgwYOEbHtbYRryhQ0mB0DmPee7uPxHiOmk1GDc3n1F6xWoeqgwCtZ7XnFO/OwGCIBfmQ3/PK75oLz5qbFqLeDeGd65F8VMgbaezELFTWZC+cxWpJD5xxjNyLTNJD8lvcfRERro5sHwsYioF53tnKiNyTWfwDzhI1Rg166Oospf97nxzhw5jnQVYgzLtZTfAZeXULGQId/PfPcPj+NgkmPNI+B4WUY0rVeYc4P0XREAscQEW/nuwfBcTzCKttAzkQgMaei3qikP7HtgEpm4uiX4FZHEftI64ylYic56uD1F5fkWA7SXlJaJIj5VVXQUdlHayYMu7A8PRSoyQUi6JkdavbrL1vvqmPTT45x9SWHe5cvewGJiz7bPqsBtKtDQULbrl61HpS3qzfN0jfxsW61rhU/w5cHE+W7zLvSm+c9t0z8nQ4Dsp05f5IKzN3AAYwdd08KOXpPIE2E+rDOZuY+DS5H+o1CFE8fqxWnHNGl3G7IWjXsQg83CnLOLQRAF283FlpDa9hRnS5C/j8oGN7WA9giYBGumC5+tYYPvGa6lCQqowfnv3vhgP4ahDh/MKhtr+AWtnEIs5uiCBPPYbvA+IiMBb5B+D3EkT3vUblEDNi5O9dVVEhctWf8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(36756003)(31696002)(83380400001)(54906003)(86362001)(6916009)(6486002)(508600001)(316002)(8936002)(8676002)(4326008)(6506007)(4744005)(66946007)(66556008)(66476007)(38100700002)(186003)(2906002)(2616005)(6666004)(53546011)(6512007)(26005)(7416002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUVBWTR0QXRIVkROVndMeEUwbCtaN0xWRHBQbXc5aVRBZE82NXUvWXhNZGVK?=
 =?utf-8?B?VUJoUEpmZ0hBYi9UeXpXUXBpWlBFdG5yMTNFeXFBbHFTNHdkQjQ0R21ST0o2?=
 =?utf-8?B?UlZDc25zK0xjYzJsRUlraXJGemFiMmNjWVZ6SlJGVld3SmNuY2ZNTkFrMVVJ?=
 =?utf-8?B?NXRTWUJOZk9lMmlEN2tzTytFczRrdDBQK3gyUkNQQW5IK1hIWHlHUUtZdXl1?=
 =?utf-8?B?b3R6N3kwODR4SmxEeHo4SFhFaWJPZ3oxV0ZKNzlaOUhQM3dLZzM2SGl6eDBK?=
 =?utf-8?B?b1RORWR3S0ZjWXp2YVZGakV5VTVRMm5OSzVpd3lnTXhKWmRDdWt2ZVNpdVhq?=
 =?utf-8?B?L0VRS2g0N3d2b1BlUEV1SVoybWRHalUrNGhLdGVLWEtnN3ZMZHJXU05sQ1RW?=
 =?utf-8?B?MGdsclJHUENBaVd4dDBMZWQzemVHRUtHVGc4dEQyc3UvWExycjU2REhidUY4?=
 =?utf-8?B?TnBiZ1JEdE1XOGJTVUFKM0NZTnVCeWE3UWdQdnJNMmdLRU1peDJVc3Fya2pY?=
 =?utf-8?B?Sm9iSTA1SnMzKytLL0I5WEJZNUlLMFlhQkhSODE2aU9KQW5ISE9LUUl2cEl4?=
 =?utf-8?B?eDg0WkV0SjdKM0hwZjBlaENvSEloeFBHdnI2dkJleUJLeTJLUG5CSmpncEl5?=
 =?utf-8?B?eWJsK0hsT1pZYjFtcEFYVENYUUZOSkFqNldsbWFHT0VHZENKVWZGc3NYdVVp?=
 =?utf-8?B?cFVlTVNCVHYwdlpDRDlLWFY5L2llSlZES2N5ckZDYWNkQXZCL1RCVEhuOUt5?=
 =?utf-8?B?RXpyNm1UcXZ1R1dkc01KdFFFaUlMZWtWUkFXQU8vekE0MC9jVVNDN2JuYkta?=
 =?utf-8?B?UTBYbjhUS0JDQW1BWnhDcS9uMnovL3dBT1Y3L0xLdUtxRGVMNWFzbmYzVC9T?=
 =?utf-8?B?R0ZyOEY2dnBjTUFmOWlLbHJoZXRDOEFjekFxN21oVmF5Q0h4bGVqVTUzWGlM?=
 =?utf-8?B?NUFmS25RMkJDbCtaRlpWTEx0aCtrWGlJNVAyeFVoeDVSSEJUZG83ZXBWYzFz?=
 =?utf-8?B?dzhJNW5yT2xOUFhDU0xuV2xkVDdHS29pN3lmOHZSQkp6aFRGVFEvaUx3dzA1?=
 =?utf-8?B?MUpxcFQwc3hWY0pTUDg2U3BKZEZPNWZCeXpGMm1vM0JPZ1o4Ry9ZWm84cEZp?=
 =?utf-8?B?eENHbVlaSDZXU0k5ZE5RQU8yTkJYVmdVcGtoRTh6N3N6dVB1TEg4Zk1Qa2Zt?=
 =?utf-8?B?OHk2ekxKcG8xK2R0UXpDMHdMam5lWktQQ0l5RlhNNlpXS1VTaHBoaUVOSkJ1?=
 =?utf-8?B?VUoxK1Z2d1ZhdTJSSWxKdzdESS9JZnZYYnZvZWJPRDNFMGhpMlRRNWhkTnJM?=
 =?utf-8?B?NUV5TS9FeVdJMGJTVVpocTZSRi9LQ242YnpWZGpKK3RqUEswdUdObGlHWHVD?=
 =?utf-8?B?NTNtMmt0akdoT2ZvMlVSZmVnZlhCaVVGOTVVRXg2ejJrWVR1c3V1bE96cVZq?=
 =?utf-8?B?YkpxVUJYY05FcmxnVEw3T00rKyt5TWxXL2RORHdwcTJQVVlpQ2M5MmQ2d3Jw?=
 =?utf-8?B?cUNNcERBdkJrRDU1bzh1aU1aSG5EU1U4d0dzQzFZYThtcW1YcTFURFA0UTFI?=
 =?utf-8?B?d0JPUlVKdG9wZ2JnZm5ZZkY2bVU5Z1VVRitHTVZORzRwN2o3T0NYOHFtN2NO?=
 =?utf-8?B?Y1Y5OTZnZ1ZWVTFWV0xWSy9FRFMyRlZSSEJZVEZLQ1Bielo1U2NlQ2IxTS9Q?=
 =?utf-8?B?K0czMDJleHNDcmR2MTZsWnJTU0RHOXFUVkVjemo4TktHNG9MZG5tbjBGR0h4?=
 =?utf-8?B?dy9tQkpFZG9TNzJENk5yNlZkc2FZeHFpVGJxTjZuZmlXSUlkWGd5OENVbFkz?=
 =?utf-8?B?M1p0SU9LS0VuUEpSOFIzQUZWaVQyRjlYcEllbjhlVFVzaklvT2xBb1IxdHI2?=
 =?utf-8?B?UEpsQ2gyU1VFaUVCMi80aVZtRm9BRjVjSU81TnNQekR1QXE5NGNNVnBOSWJj?=
 =?utf-8?B?RkVzUXRKY0RwZjlIUXYyYnBLVm12QVJNRnA4QUg0a21WVjdscVpFdjRZRWd2?=
 =?utf-8?B?eTJQTE00cmJ0Z1l4MTRYZmdVWXMvVVI2K3lGdDZteEVOQmc3MzRWUitUb2kr?=
 =?utf-8?B?SXZlejJDZGkya0dWMFExSUlEVHg5WmcvNW1jUURDVndYTkpvQnZMNkF4dXlk?=
 =?utf-8?B?VUlvWGZudWtRc0dpaGtRUjJvcDZnMDc5THBSWnoyZzBNSWZpMFUxbnRPK1NN?=
 =?utf-8?Q?GRr4ddLODxqrQbKpTeIMZBI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26994833-0b9d-4736-715d-08d9e5c2c733
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 20:38:18.0588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k+Mp44XUHk6Aq9YxY4Xy/HUuty9rE7zwMVPdV0a6u86fSRCbLydJDXB9YffVL/CjlER6M9W1CRULENg6ldCrDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5403
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/1/22 10:32, Will McVicker wrote:
...
>> Thanks John! I verified this works on the Pixel 6 with the 5.15 kernel
>> for my camera use-case. Free free to include:
>>
>> Tested-by: Will McVicker <willmcvicker@google.com>
>>
>> Thanks,
>> Will
> 
> And just so we don't miss this, I'd also like to request this be
> pulled into the 5.15 stable branch please.
> 
> Cc: stable@vger.kernel.org # 5.15
> 
> Thanks,
> Will
> 

Yes. Let's see if any feedback shows up about the approach, otherwise
I'll post a v2 in a day or so, that adds your tested-by, as well as the
Cc: stable.


thanks,
-- 
John Hubbard
NVIDIA
