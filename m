Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFDB521E9B
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345385AbiEJPcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345960AbiEJPbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:31:16 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C79616B;
        Tue, 10 May 2022 08:23:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djkt6OJYyZ1XOlSh6F8H0mwi6nhG7RH86lG+MNi1MlnM1YHjG42MfNgl54lkOJg5hwjEYJsYFa0ODT++t2Xa75WFpWzw8xiZhP1xH8IlZ/VjGR/o9zhbXtjYf5gkUN14u+9F1ABa9MqWcH0nspQEzNX7yvmFqRz/lCMc8vDCgdDAwNMnHN/AGyBNeB39AyyFNkOJl0lZV0X8p0CK34CHkvTaGvU0/8mBJj1Zr5oWdwv5vwKsznwwJS6Qx5R4Ja/VW/cLIGcLG22y5DvIqNo2Q5IqlXhK3iCsLGCdsHe8X7nm33+koXXD+sBCDtYM74txzuxaFy99tPP/pQd93s/RCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lpqw37cWQud9J/3iIj85i7GsSgDdLzBKaLoAAb7bg8s=;
 b=aEqU0GafxzqF6j/pwweuhEFFS7kj6o11MzyohfXNPlrF7vhcwsxcEunYdH1Etc1h4dWxHqOCtn7C4P2agAJzAwBfBUAVLtnqErX0Ry/tMH0CcGWUxNpzoMH+WUVEuVsTb4CxCmDjNJ6R523/Jf9u+HBp1dH878Sj5hjrOsB9NEyMjM9s4i3CZRFxhv72Zhgk7gFg/OFXgOjCaOQlz+AEa61gX9Vot6WNEyu3BF59O5eRBDAb/W8BzQSeW8t8jNN6QQWQ+IaxOI061dDovGIu84fi/IByD4PxSccuOUmv0zrfKK/51/rgZSxWUbCAKadgHPeMHDhyodAxnSAwMSjIgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lpqw37cWQud9J/3iIj85i7GsSgDdLzBKaLoAAb7bg8s=;
 b=KKJLS5gb+sAoKShNrcnfLsh52qyY5yRD5UpOzQXOjcMR3u8Ew62pNSccXvY8mYfqdFgAJd7vfhilSBtDRB6etMVLePDwKDPraZAx6ucFyaJ9BQk1T5F7Y+GZqpouxxrt9XPKb620fpLPLJKbNn7IDYrXkm4WD+qtfOsgFwkeNMI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by BN8PR12MB3410.namprd12.prod.outlook.com (2603:10b6:408:45::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 15:23:43 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::fdba:2c6c:b9ab:38f]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::fdba:2c6c:b9ab:38f%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 15:23:43 +0000
Message-ID: <984e7d70-a86a-5183-ce8d-6055f664890e@amd.com>
Date:   Tue, 10 May 2022 17:23:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.15 082/135] drm/amdgpu: unify BO evicting method in
 amdgpu_ttm
Content-Language: en-US
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Nirmoy Das <nirmoy.das@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
References: <20220510130740.392653815@linuxfoundation.org>
 <20220510130742.763825220@linuxfoundation.org>
 <ebc2e664-dd4c-d600-b99c-abe104ec76fa@amd.com>
 <BL1PR12MB5157CA2ABDAB710A4F30778DE2C99@BL1PR12MB5157.namprd12.prod.outlook.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <BL1PR12MB5157CA2ABDAB710A4F30778DE2C99@BL1PR12MB5157.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM6P194CA0094.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::35) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a46fea02-0cb0-4486-e685-08da329911bd
X-MS-TrafficTypeDiagnostic: BN8PR12MB3410:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB341055714FAF8F19F666056783C99@BN8PR12MB3410.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BXq1sWSubi8r6YcnBaMiFBjcgU5mVoW0EsnWuCtwuQkcEZym6xnLIVqgFlpk1K8OeGSPKsa8rWpK2eHyMbM0xp2oASsHz3P/ir6RWMd+9tFUDi2+7jxn1SPqP65ps/dIkYm4S6AjxWrfTI6SJVtefqo+YoJloV6b3p5MCnvLeewZ0g1y9fkhmQbSjK732mXsNZNn17jqpyg11XArHivaSv2BEwAcwdWJ/7mIi2wVXyfrI/c7r3TZkQYNZYijOz0s2wsvWMR92ByMkMRKKo24IX9OeFiHgHUJGwgOXUJQ2GjEH1DBMxleepngdKQj44jTk5bBMUKfuaphQxDKlyLef5SlnL1oCmuG4ZpyWMvrcIAsDeoA6Yeqm94ajZQDvbCOxE0CDMQHFLj65ruLVl4pXzzxDGC/2n9i8xV6kIlgOW/F1Q3EMaoPepbaJGgqrH6+eG5KfRlO1fwYk/9285InO/i53yBw3dqmUb/WRgaklu8H0wkwR/c+eRGPEoyiUEoJTImd9NU3IXDI6hnkAzrmYGcuI014rqjDdM5iv+6TcFMMnflJOQjL4s/Ke+FBXuO/b9yfJhJkFJZhsfP70b/c4/shdqxZ+cf7bOGK0OjVV5apqKvvGFDI4+3WNAMJLIY8jJPGua5ABlXy52G9hAxhjIiNfVWJNyuxhQ07gLyJYyX4SsKHE4VpXP3tkB3iSM4R96/YfT3V4J54cRSJF50peEZlb0y+43YonISyJVge/8HetEwXBbjy33P/1nIg2Tt4Q5vx6YefN4utciFTSv2ndI/owCBC2CPyY+blExsLkwunQ/gDROxXzG6EBFgT41eoApD+cSJncD/kbnRfghycRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(6486002)(38100700002)(31696002)(45080400002)(966005)(8936002)(86362001)(6666004)(53546011)(316002)(6506007)(508600001)(66476007)(66556008)(54906003)(66946007)(4326008)(8676002)(110136005)(83380400001)(31686004)(186003)(36756003)(66574015)(2616005)(6512007)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1hyMHcxRFNGeXQ5SEZ5WjdHbXd4a1JrQ2ZHM204dVFLYVJwSWljU1lMcHA4?=
 =?utf-8?B?ZmI0SkJTbXNRNjJOTFN0eXc5dXQvMUJGZ1FnVEFNbE5qRU5zUWt2QlQ5aDdS?=
 =?utf-8?B?Y1grTjljS1R3dHExdkNoWWIzdy95NFpLSnl3UldBSGpJQ2prUHJMUElTZFI5?=
 =?utf-8?B?QklhYSsyNk9mU2wxbW14VDVSU0VhRWtBaE42L0M2TEphQzlSQ2xtVDVGL1M0?=
 =?utf-8?B?TUV1UUN5QXczYzdtZURhdytLRUFvOWMwWERudXVUQXRleEVrTzFJUks5bWht?=
 =?utf-8?B?SGNwREZYUmNQQnJNWlVWOGxaY1lDTW9YVGRCRnVUcGZmU2tMYlRrUGlVQTIy?=
 =?utf-8?B?c2l1MlI0U2FYNmdFT1JMQ20rdnJ6bmJKbmI5cjlOTzRWOU1tZzZ6Y2E4NGhh?=
 =?utf-8?B?RGswVlZEc1J5S0VSRXU5WGRUK3lpNUE5STZjRGhRYUhCeTZWVzFTOTJBT2E1?=
 =?utf-8?B?NHhnaGIrandqZ0FVTzk2akE3L0lzSEpkREgyTWVWUGljL0JCWGFtTDVvUjRQ?=
 =?utf-8?B?cUxTZUhOUkJuS2NCdXhSYUdMa0NIWUVwZ1lva2U4U0JqTTVKdzFVM3M3OVQw?=
 =?utf-8?B?SEtZM01NOGlsU2pzekV2OE1aS05EMFFHWXM0NGNCRUxxUENZY3lweVpYOUJO?=
 =?utf-8?B?Ni9wOSt4bU5aTGNicUNmVmNSY1B1QXpmekpoU1VSUGlGMWtxOVFhbk1oQWVj?=
 =?utf-8?B?WVpYRks4cFpWMFdOQ2xiWkgxS0l1VnNiajl3M043MzdVMXo4UTRiU3VkRzY1?=
 =?utf-8?B?UGovN0tPdHoyS002WDBzOEtwdm1vWDZ6MGlneGdJRE5HYS9UNFZBKzJYU1dT?=
 =?utf-8?B?VTJnSmZvQlQyNFFLbCswcHp0YTlaZGZjRXMvYlhrTWVXdkhOOEd1WnNUZk5r?=
 =?utf-8?B?cDZSQklXTHU1bG9vNXlTRTZKZk4zYjJyY1pxTFp6bjdwOWh6VEY3V29qbEhW?=
 =?utf-8?B?TFdiWGJQSWJITjJFWmtSeHJxL0VrbmExMGFhZ3pVd0hvNll2WURRY0N1MzZj?=
 =?utf-8?B?bUphSmxxYXdBSVVmdjJXclJpMklmckl1T2pyTHg1WWwweEt0bWlHOGZqdGVj?=
 =?utf-8?B?SzZvbzdpa01HeE53V1hGcXd1TkthYUhZSHRMYkp1WmNvNzJZcC83VEp1NjZn?=
 =?utf-8?B?dFZMVytzS1p3Q3F0OHJ0UjA2dHdBbGoxYlRoNVo3dXQrWE4rNDh6ajZFaWVR?=
 =?utf-8?B?eHFKcTg5bUQ2bnRaTUIzV2lya2ZaZjduOGZzUERGZzV5Y2pBRm5UWU9tb0hM?=
 =?utf-8?B?c3h4c0Q4OE1sMjd5ZjdjSVg3cUt6c2RtemRXZFhYZmNDYktuc3F6RVZ4UkRB?=
 =?utf-8?B?S2tQNlE0dnJMempoQ282Smt3SHJGUnIxaVVXaWRWRmxTWHJIbmpVUHFnQzY3?=
 =?utf-8?B?akx1Tk5aWUdoNWV2Qm9RVWdHblJEeEtxOUtEU2tIaFRyMW9NOE9WNHZObkJF?=
 =?utf-8?B?V0lEQUcvRm56by81YWl6aklta2ljZ2IyQmlzUno4NEtrN3N5ZTVBakhUeE9a?=
 =?utf-8?B?b3djOXJqQjV2R0xJajUvQzExc0JiTnRMcHIxUWswT2M5WHJGTzVoS24vOHhV?=
 =?utf-8?B?SGhpMWh5MzlWam1WU1QwMkt3M0ZRUmU4Q1BuSTBKSWRRakwxUDdBUVRYOHh6?=
 =?utf-8?B?S3pyaHFhSkdnZEUzQ3E0cXdBRFBvMWZMcVZuQi9xV05DdWE2QStBSm9RTURU?=
 =?utf-8?B?L29GQkxzaXFiaHRLbGtiN2hWODZ5eVBQNG9zV1pvUVo0dmxZaTh5ZE9LaDlI?=
 =?utf-8?B?QkxiTlJraVlMT0xlOTViaWllZnRJRUdTU0FRL05TQjdjNVVBS3ZkanJtNXdC?=
 =?utf-8?B?ejB0ZUx6SDNPSHhKMkJPSTdIbUxmdGZMSDNSRjlXYjEvejJuMXJnTUpydGJP?=
 =?utf-8?B?d1RUTmNBeTBBY1A4aGNCd0Z2TlZRVCtldEQxSjh4bUNUZkMyTER4NEFkNGpn?=
 =?utf-8?B?ZlluV3BGYTFhLzg5TTFWZzRLYmFKVXNST094QVkrZHV1WVg4emRUcCt4eTNG?=
 =?utf-8?B?b3hjV0JKcGZSa205aUYvd3BQNE1rNEdwVDZWeVNOMzNqenQ1RWc4a3lFU3lm?=
 =?utf-8?B?SmVhNnJWSTBpVjF3cmc1bitwUU5KWEpkbDh6a0ZJWERnVU5NQnIyMW8zUXJ0?=
 =?utf-8?B?RGpwOFg4a25oblN3VER6TmI4S1JsRDV6eU55S2xoenZHQkswdUZUZlJEZnFH?=
 =?utf-8?B?K3k3VGF5SnluK3hVblFhR3RhZmZsbTRaTm9LcXR4NjAvdGpGY3U2Z04yTDJz?=
 =?utf-8?B?TmRsUVdhVmI3UFdzWjBSa2d5ZEpNUlc0aDBUcTlvRTUreXR0a2VjVm5TajUz?=
 =?utf-8?B?RHZ4RWlKUmJ6WjhoMEFzNUJIdlQxQWhHK0E1Wmc0RVErdnJxZlV5ZW51K3RZ?=
 =?utf-8?Q?BbnqneacaGunyztRwLFVUAzZh5xAxLIk9L8ZNPOfgeYC9?=
X-MS-Exchange-AntiSpam-MessageData-1: 25mxA+AcdsxgyA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a46fea02-0cb0-4486-e685-08da329911bd
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 15:23:43.6639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z5dEVDg8DUpHzG/v/H7J/xT9zSz9Q2UanOoSF6ELJhWA55Lbo5x9QgSlqHKH06Z6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3410
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 10.05.22 um 17:17 schrieb Limonciello, Mario:
> [AMD Official Use Only - General]
>
>
>
>> -----Original Message-----
>> From: Koenig, Christian <Christian.Koenig@amd.com>
>> Sent: Tuesday, May 10, 2022 10:15
>> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; linux-
>> kernel@vger.kernel.org
>> Cc: stable@vger.kernel.org; Nirmoy Das <nirmoy.das@amd.com>; Deucher,
>> Alexander <Alexander.Deucher@amd.com>; Limonciello, Mario
>> <Mario.Limonciello@amd.com>
>> Subject: Re: [PATCH 5.15 082/135] drm/amdgpu: unify BO evicting method in
>> amdgpu_ttm
>>
>> Hi Greg,
>>
>> sorry only noticing this now. Why is that patch backported?
>>
>> I mean it probably doesn't hurt, but that is just a code cleanup without
>> much function difference and not a bug fix.
> Christian,
>
> It was for supporting a backport of some other fixes.
> See:
> https://lore.kernel.org/stable/BL1PR12MB5157776D00DAA747EF550CF1E2C69@BL1PR12MB5157.namprd12.prod.outlook.com/
>
> Technically it could have been a hand modified e53d9665ab00 but distros are
> doing it as a straight backport already so my thought was it's better to align what they're doing.

Ah! That makes more sense now, yes feel free to go ahead with that.

It's just that the backmerge notice of this patch alone ended up in my 
inbox and that didn't made to much sense.

Thanks,
Christian.

>
>> Regards,
>> Christian.
>>
>> Am 10.05.22 um 15:07 schrieb Greg Kroah-Hartman:
>>> From: Nirmoy Das <nirmoy.das@amd.com>
>>>
>>> commit 58144d283712c9e80e528e001af6ac5aeee71af2 upstream.
>>>
>>> Unify BO evicting functionality for possible memory
>>> types in amdgpu_ttm.c.
>>>
>>> Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
>>> Reviewed-by: Christian König <christian.koenig@amd.com>
>>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>>> Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    8 ++-----
>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_device.c  |   30
>> ++++++++++++++++++++++------
>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_object.c  |   23 ---------------------
>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_object.h  |    1
>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c     |   30
>> ++++++++++++++++++++++++++++
>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h     |    1
>>>    6 files changed, 58 insertions(+), 35 deletions(-)
>>>
>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
>>> @@ -1176,7 +1176,7 @@ static int amdgpu_debugfs_evict_vram(voi
>>>    		return r;
>>>    	}
>>>
>>> -	*val = amdgpu_bo_evict_vram(adev);
>>> +	*val = amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM);
>>>
>>>    	pm_runtime_mark_last_busy(dev->dev);
>>>    	pm_runtime_put_autosuspend(dev->dev);
>>> @@ -1189,17 +1189,15 @@ static int amdgpu_debugfs_evict_gtt(void
>>>    {
>>>    	struct amdgpu_device *adev = (struct amdgpu_device *)data;
>>>    	struct drm_device *dev = adev_to_drm(adev);
>>> -	struct ttm_resource_manager *man;
>>>    	int r;
>>>
>>>    	r = pm_runtime_get_sync(dev->dev);
>>>    	if (r < 0) {
>>> -		pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
>>> +		pm_runtime_put_autosuspend(dev->dev);
>>>    		return r;
>>>    	}
>>>
>>> -	man = ttm_manager_type(&adev->mman.bdev, TTM_PL_TT);
>>> -	*val = ttm_resource_manager_evict_all(&adev->mman.bdev, man);
>>> +	*val = amdgpu_ttm_evict_resources(adev, TTM_PL_TT);
>>>
>>>    	pm_runtime_mark_last_busy(dev->dev);
>>>    	pm_runtime_put_autosuspend(dev->dev);
>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>> @@ -3928,6 +3928,25 @@ void amdgpu_device_fini_sw(struct amdgpu
>>>
>>>    }
>>>
>>> +/**
>>> + * amdgpu_device_evict_resources - evict device resources
>>> + * @adev: amdgpu device object
>>> + *
>>> + * Evicts all ttm device resources(vram BOs, gart table) from the lru list
>>> + * of the vram memory type. Mainly used for evicting device resources
>>> + * at suspend time.
>>> + *
>>> + */
>>> +static void amdgpu_device_evict_resources(struct amdgpu_device
>> *adev)
>>> +{
>>> +	/* No need to evict vram on APUs for suspend to ram */
>>> +	if (adev->in_s3 && (adev->flags & AMD_IS_APU))
>>> +		return;
>>> +
>>> +	if (amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM))
>>> +		DRM_WARN("evicting device resources failed\n");
>>> +
>>> +}
>>>
>>>    /*
>>>     * Suspend & resume.
>>> @@ -3968,17 +3987,16 @@ int amdgpu_device_suspend(struct drm_dev
>>>    	if (!adev->in_s0ix)
>>>    		amdgpu_amdkfd_suspend(adev, adev->in_runpm);
>>>
>>> -	/* evict vram memory */
>>> -	amdgpu_bo_evict_vram(adev);
>>> +	/* First evict vram memory */
>>> +	amdgpu_device_evict_resources(adev);
>>>
>>>    	amdgpu_fence_driver_hw_fini(adev);
>>>
>>>    	amdgpu_device_ip_suspend_phase2(adev);
>>> -	/* evict remaining vram memory
>>> -	 * This second call to evict vram is to evict the gart page table
>>> -	 * using the CPU.
>>> +	/* This second call to evict device resources is to evict
>>> +	 * the gart page table using the CPU.
>>>    	 */
>>> -	amdgpu_bo_evict_vram(adev);
>>> +	amdgpu_device_evict_resources(adev);
>>>
>>>    	return 0;
>>>    }
>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
>>> @@ -1038,29 +1038,6 @@ void amdgpu_bo_unpin(struct amdgpu_bo *b
>>>    	}
>>>    }
>>>
>>> -/**
>>> - * amdgpu_bo_evict_vram - evict VRAM buffers
>>> - * @adev: amdgpu device object
>>> - *
>>> - * Evicts all VRAM buffers on the lru list of the memory type.
>>> - * Mainly used for evicting vram at suspend time.
>>> - *
>>> - * Returns:
>>> - * 0 for success or a negative error code on failure.
>>> - */
>>> -int amdgpu_bo_evict_vram(struct amdgpu_device *adev)
>>> -{
>>> -	struct ttm_resource_manager *man;
>>> -
>>> -	if (adev->in_s3 && (adev->flags & AMD_IS_APU)) {
>>> -		/* No need to evict vram on APUs for suspend to ram */
>>> -		return 0;
>>> -	}
>>> -
>>> -	man = ttm_manager_type(&adev->mman.bdev, TTM_PL_VRAM);
>>> -	return ttm_resource_manager_evict_all(&adev->mman.bdev, man);
>>> -}
>>> -
>>>    static const char *amdgpu_vram_names[] = {
>>>    	"UNKNOWN",
>>>    	"GDDR1",
>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
>>> @@ -304,7 +304,6 @@ int amdgpu_bo_pin(struct amdgpu_bo *bo,
>>>    int amdgpu_bo_pin_restricted(struct amdgpu_bo *bo, u32 domain,
>>>    			     u64 min_offset, u64 max_offset);
>>>    void amdgpu_bo_unpin(struct amdgpu_bo *bo);
>>> -int amdgpu_bo_evict_vram(struct amdgpu_device *adev);
>>>    int amdgpu_bo_init(struct amdgpu_device *adev);
>>>    void amdgpu_bo_fini(struct amdgpu_device *adev);
>>>    int amdgpu_bo_set_tiling_flags(struct amdgpu_bo *bo, u64 tiling_flags);
>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
>>> @@ -2036,6 +2036,36 @@ error_free:
>>>    	return r;
>>>    }
>>>
>>> +/**
>>> + * amdgpu_ttm_evict_resources - evict memory buffers
>>> + * @adev: amdgpu device object
>>> + * @mem_type: evicted BO's memory type
>>> + *
>>> + * Evicts all @mem_type buffers on the lru list of the memory type.
>>> + *
>>> + * Returns:
>>> + * 0 for success or a negative error code on failure.
>>> + */
>>> +int amdgpu_ttm_evict_resources(struct amdgpu_device *adev, int
>> mem_type)
>>> +{
>>> +	struct ttm_resource_manager *man;
>>> +
>>> +	switch (mem_type) {
>>> +	case TTM_PL_VRAM:
>>> +	case TTM_PL_TT:
>>> +	case AMDGPU_PL_GWS:
>>> +	case AMDGPU_PL_GDS:
>>> +	case AMDGPU_PL_OA:
>>> +		man = ttm_manager_type(&adev->mman.bdev,
>> mem_type);
>>> +		break;
>>> +	default:
>>> +		DRM_ERROR("Trying to evict invalid memory type\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	return ttm_resource_manager_evict_all(&adev->mman.bdev, man);
>>> +}
>>> +
>>>    #if defined(CONFIG_DEBUG_FS)
>>>
>>>    static int amdgpu_mm_vram_table_show(struct seq_file *m, void
>> *unused)
>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
>>> @@ -190,6 +190,7 @@ bool amdgpu_ttm_tt_is_readonly(struct tt
>>>    uint64_t amdgpu_ttm_tt_pde_flags(struct ttm_tt *ttm, struct
>> ttm_resource *mem);
>>>    uint64_t amdgpu_ttm_tt_pte_flags(struct amdgpu_device *adev, struct
>> ttm_tt *ttm,
>>>    				 struct ttm_resource *mem);
>>> +int amdgpu_ttm_evict_resources(struct amdgpu_device *adev, int
>> mem_type);
>>>    void amdgpu_ttm_debugfs_init(struct amdgpu_device *adev);
>>>
>>>
>>>

