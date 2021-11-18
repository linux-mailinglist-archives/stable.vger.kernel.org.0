Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EE045572C
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244717AbhKRIoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 03:44:07 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:60229 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244806AbhKRIny (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 03:43:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1637224853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=llQ4wRsyJ0uGbRlru51nj9tulLG7/T2vCEv5MdCMxTM=;
        b=e3nuhx7zDXbUIOK5qAQBV8Uxasc7Y3bl4zAJJaPE+6jTkSJ+OGMbZLoO40VdJKPx4qI4Om
        w7OUgUyRCTWYa6f/4JIjPVUo/AYe0/vPJrxS2RzhZclNcKDBNRIw1EYcwPv0sGZgzouGMs
        QmDrM+a+w2E3/aUHxuXXwZzXFp5ejh0=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2050.outbound.protection.outlook.com [104.47.1.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-NJNWaiqcM4uaPpgrfocvRQ-1; Thu, 18 Nov 2021 09:40:51 +0100
X-MC-Unique: NJNWaiqcM4uaPpgrfocvRQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DecLPgdqOw04eIHzxby8foNruQm7zL5CVvalwhQOFCwgBLJKdOAVwU1/K4V+LvedHLBLAA/kNvTgwKcg0GHYbtFb9adTgOuPjGvRu3WobkJTwK2kyRgjNfP4qCLanFQNPlswNfufNJ8u7n6icxv63dyOvJ5Ldn/yDR+OcnWA184/sxllevVF40plkLZAAFcz0tnorwdbYDA6huFlcGxFCBKY3y+jAygiJOMnDwuADOLrzFTcOkzR7zDfVV4SrOfieMNnnFLEo3D3bbw0/DDAHPhIggfH7U3stvC8/C/zHs1BgrYiHw1jebgiprravVHhyGqzQDaRK3PXtxxw5gU4Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=llQ4wRsyJ0uGbRlru51nj9tulLG7/T2vCEv5MdCMxTM=;
 b=f22gJbkX4/TAC2N1aDrIPIcj+2jhtGt2zW4tjXBH6a3xqIL2zaIUO9x8jd2R9oDwCmyVxM8d3cewjcfHwGDlqnN2oR74tjHsq/K8OrdDGGsNy1aqnwIr5dNrsrScNFKnywn8Lx5NEMvyjMVXlxPeS4bDuwXyBw4yCHM2aV7iTe5cgi6eU5Ppf6xIq29R39Q4Q4cxg3urNDVin49PQ8a0mKbDrSevm8HmUp+03xpW9SiQCv8eKWGkL2TKSzONSQhfFkPnfV1tptnnz9uCqYzTZYWuo+ab3yJ2JGZLHNpY9BJWgReEw8pbGaDgSNhgmQLl6dl5HSOYZshK+2hIGNm7fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR04MB3118.eurprd04.prod.outlook.com (2603:10a6:802:a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Thu, 18 Nov
 2021 08:40:48 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898%3]) with mapi id 15.20.4713.019; Thu, 18 Nov 2021
 08:40:48 +0000
Message-ID: <4c952e5b-a136-3fda-810c-29fa556ef965@suse.com>
Date:   Thu, 18 Nov 2021 09:40:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] xen: detect uninitialized xenbus in xenbus_init
Content-Language: en-US
To:     Stefano Stabellini <sstabellini@kernel.org>
Cc:     boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org, jgross@suse.com
References: <20211117021145.3105042-1-sstabellini@kernel.org>
 <2592121c-ed62-c346-5aeb-37adb6bb1982@suse.com>
 <alpine.DEB.2.22.394.2111171823160.1412361@ubuntu-linux-20-04-desktop>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <alpine.DEB.2.22.394.2111171823160.1412361@ubuntu-linux-20-04-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0058.eurprd06.prod.outlook.com
 (2603:10a6:20b:463::32) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
Received: from [10.156.60.236] (37.24.206.209) by AS9PR06CA0058.eurprd06.prod.outlook.com (2603:10a6:20b:463::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Thu, 18 Nov 2021 08:40:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7e0e5b9-3918-45e1-97a3-08d9aa6f1e89
X-MS-TrafficTypeDiagnostic: VI1PR04MB3118:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <VI1PR04MB311852305D2CECB5DFF2BA2BB39B9@VI1PR04MB3118.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hvtYZcg1qJeK1HWmHowhMTYW3sJN53CytO1lnmBMB8Sb5wNlAWsH8VhK3+thTfNjRt/fxYrvPytMv4gy4YWvFiHfbKe+TGOWwszXbioGO8RHwtdDWFrMty7/qYtOA9IE/vno0YuNsvPmKxbeBtPgA5W4CA7g5AfwBZVLbslZgMfoNKT0FaymMhmKv2fhJUAhrEFNC+kJKROjHCOSNd0ssXBQUpjp3CefxqRE+25vYFbqakvdAH/T8PdV11QXVVu5j5eJvuvU84ZkmWl3vT745OZaCndcnBhI1lFiSYV3i0k5nSZF9t/JFvO/HUc7SL6czG5aCFqwFCl5/ZmiQyJYVlxhwa0sjPpTeyZc9LOO5vYWtefHgJ2g4ommkGP1Bwywd/66tBjL1JA7DvASORD9uR0x1CA02qj2FXvn2vRuocVGOpsp5T24Uvo50AhYoy24j9mVFLbOI9Gnc+ru2TP02BytDo90opzjClSLK9YqgP8EszqEQu+BirXRn9vbKQ6/Y1TIvhfQ4WQf4XvYjpWQ2lWSoG37QBtGCYhJy+ETTxHlhDsFeOuOYNkvzgeFhtpJBKChgCTWlBGySHopxTZRTkMMHak5RJ2d9F7EmS8q8NXqRqXN3XALyL5kDy3B4IrbxYlnUKpICqqdX+0QZgTVrRjXuVOd71IhpVDn3ac9+znlq+KzJYhGbQzDs7x/NXV+PnJsFXPPHCeYVzHQ+t9VZf24Q8bvE9crMfIBJFCX2q0VsYimHjUuToaszzwfe48i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(6666004)(66946007)(8676002)(8936002)(6486002)(107886003)(31696002)(956004)(86362001)(5660300002)(316002)(38100700002)(31686004)(4326008)(6916009)(508600001)(16576012)(53546011)(36756003)(26005)(186003)(2616005)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXV4blAyY1Z6WUtIUnBjOTltcndac2FpMEdyOVZCRkNrUUMwMS80Y1Rhemx1?=
 =?utf-8?B?V3ZGWVd4eVgrTjA4NVFPKyt5RlBjRVZ4UnhLR3J1d0dSdE1sUzRaWURUTVRE?=
 =?utf-8?B?YUhVK1FaLzB4WlhQd0Jqek8xY3dQUUx1Q3FtMUplZHd0U1kvUERvQlZaeTh1?=
 =?utf-8?B?ZkdXYThuSmxZbHJnN3ZJODhJR05BUklGOWV1ZjFydWJ5K2EvV0VKTjlJb3NN?=
 =?utf-8?B?WDJvTlIzRmVZaFptS2NReGxKcm5KNkhCVERwQW1VWi9ycGxGN3UxbXdFVXBr?=
 =?utf-8?B?V3hxei9Gdk1rZEY2ekd0RUdUWkdoQjgxdUYrQWczUm44bTZVNzNyZmVsZmpr?=
 =?utf-8?B?OVgrNVRtSG1lS2pyRkZEMUNnRUc4RnVZaU1yaXU4NXNUNnpScVBUeWMzbUts?=
 =?utf-8?B?dXJNaTNjeTZ1K1psVjBpd1dPa1VBYjMxVk1zNGdOOFRna2dZTTdhd2FmQlMw?=
 =?utf-8?B?cFdycEI2QlhXTzlSWHh0OG10ZmNYSU5TZHhCMHA0SFlJTVIvSnpFZkcvWlMy?=
 =?utf-8?B?WTBIbm5kVy9jUUs2aUFJRktvMjhSSEErWmlONEtvUDArSDBldmxKZkJIcGpG?=
 =?utf-8?B?QmZFZFFtT0FpQUZZQjNoMkhaK1g1SWUyeUQxRUJoTzRZbkJKMlNLSE9xb2pH?=
 =?utf-8?B?RzNLOFNETDhEWDgvRy92T3Z5NEV5YnV1ODRBT0ZTTG83dENSTjhDclJ3aTEx?=
 =?utf-8?B?dFdPRDNIaW1MMk80L1FFeEZickdVUlh4SXFNSkVCdkRLc3dYQndBVkhNSjdO?=
 =?utf-8?B?WGJ1MWVoNkJ0bHVLWTdrOU45dC95RGZmdTBpck93T28yWUFqOStYVE02clAv?=
 =?utf-8?B?SUF6OXJ5QVV4YVFreGpHT3FncnV3Mk40RjExWG11OS96S3JWanVGQnJVUDRh?=
 =?utf-8?B?dWVzbi9FNlk3QWI5OXBxU2lGeHlYSFQyazQ4TmN6azh5TnZDMzhEMHc3OStS?=
 =?utf-8?B?MmxoaVBRd2NlNEhUaVo1ditzVzJOZkYvM05DWWZrbG9SYUtRVnE3YnNKblhU?=
 =?utf-8?B?TWc3MENVMjJMOFQ0U1JWM2hqTXk4cHVlbVZTdGFXY21TdUtFM1Q3em83UXZ4?=
 =?utf-8?B?eFc4MlR6WEJVZnZkY2t3WnBteGxabHZySjA3elphWUFSdlpkTFc0VGFmK1Y5?=
 =?utf-8?B?ZVdqcjBRZHVQSFlUWWFqUE9IeXFrT04xSVAzaXVOMU95K3dVdEVLNnpDVU5q?=
 =?utf-8?B?SmVOTmJtTUl4TlV2VFByTDhVSDdVTEhuVk82VHArMEJwVUFoeVcxbklFMjkz?=
 =?utf-8?B?WC9FNHNFcjd3V1duWWN4TTBLem9keW1mK3JSUVRYV0ZrQVUyN1h1MWpWUSt5?=
 =?utf-8?B?YVBOOTdGb1MyejZONG5yZW5iYlFXeEtKc1BUbXVub0RyRmY0NGVhMGtmS0hO?=
 =?utf-8?B?MXFsaFpqNXJFVGdqOEJSZncyMXc4RkFVclkxQ3FqMHp3YnNDRlNJUE5RVnJk?=
 =?utf-8?B?UTdGUENPYmYyem1PL002VVlPaHBBVHZJK1F2THYzazdIbHdHcUR0allIdUpZ?=
 =?utf-8?B?M3pQVjVCbWVlQnV3ejgrcXZvLzJ3MVhXc3YrdWFZS0hOa3RwNC9HNGtmRzRx?=
 =?utf-8?B?VTU4NVZmNXI3QitGT1duV2pRRWZEL1Y2ajkzc0JIeWZZVThiNGJJUmh4ekc3?=
 =?utf-8?B?d1pPZ2lBMGVBQnZidVRyOW9aVzhtanhidkNYQ0w1WFBpaUxjdGJLN2pBYTN5?=
 =?utf-8?B?MDQyQnk5MElIREdKVHhldUxsQXZHZHZNVkhHQ3Znam5PUitoQUc1d1hKUC8y?=
 =?utf-8?B?RkxjdElBODdPOENQRVYwTFBSZHp6OFQ0cTdkNFphbU9mTUdSUFc3RWtBS1FN?=
 =?utf-8?B?V3dqaEFpV0F0U0UrY3hYQ28xZzhGMVBtOXRpTW1VZW9XTUJZN2VmUTdYTXhh?=
 =?utf-8?B?dEpDMEhHVlJjQngyb09xNG4rVDZ2N0JnN1RVSzhudG9YRHFhN1h5MGp4K1lz?=
 =?utf-8?B?dXBCa24yRHFoNWVoNkxPQlh1dTZqNUZXYjFpYzVkZFR6SGM4S05hWU42Ynlq?=
 =?utf-8?B?NXFiODJmbFF6bDVyZmVtUnZqY2M3ckVDRS9BdVM4RmMyaXl2ck9JR2FaNm9z?=
 =?utf-8?B?anl6aWdodkt1RG82RHpZRUJJQTNBdlFwZjB6M2xxdzZneXRDUG5IdUxoNG9Y?=
 =?utf-8?B?MldaeXpjOUFpQTduT2lWZnMva05mYVd3SDdKR25Pd0dSbEFGak9GenNMZDBQ?=
 =?utf-8?Q?Vhi0KR2dyUO9G1UoQluNjUA=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7e0e5b9-3918-45e1-97a3-08d9aa6f1e89
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 08:40:48.1370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q1nq2NLsNtEbK2pFOH7Jmob0wrIxPyNS8DoZKw+53mVMhp5xJVSxgSQFprKXlieVlC+BIA3QTef6cjdvL0RJqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3118
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.11.2021 03:37, Stefano Stabellini wrote:
> On Wed, 17 Nov 2021, Jan Beulich wrote:
>> On 17.11.2021 03:11, Stefano Stabellini wrote:
>>> --- a/drivers/xen/xenbus/xenbus_probe.c
>>> +++ b/drivers/xen/xenbus/xenbus_probe.c
>>> @@ -951,6 +951,18 @@ static int __init xenbus_init(void)
>>>  		err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
>>>  		if (err)
>>>  			goto out_error;
>>> +		/*
>>> +		 * Uninitialized hvm_params are zero and return no error.
>>> +		 * Although it is theoretically possible to have
>>> +		 * HVM_PARAM_STORE_PFN set to zero on purpose, in reality it is
>>> +		 * not zero when valid. If zero, it means that Xenstore hasn't
>>> +		 * been properly initialized. Instead of attempting to map a
>>> +		 * wrong guest physical address return error.
>>> +		 */
>>> +		if (v == 0) {
>>> +			err = -ENOENT;
>>> +			goto out_error;
>>> +		}
>>
>> If such a check gets added, then I think known-invalid frame numbers
>> should be covered at even higher a priority than zero.
> 
> Uhm, that's a good point. We could check for 0 and also ULONG_MAX

Why ULONG_MAX? The upper bound is determined by the number of physical
address bits (in a guest: the virtual counterpart thereof). In a 32-bit
environment ULONG_MAX could in principle even represent a valid frame
number.

Jan

