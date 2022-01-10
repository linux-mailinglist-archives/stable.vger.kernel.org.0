Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDA9489D50
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 17:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237196AbiAJQQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 11:16:29 -0500
Received: from mail-dm6nam10on2080.outbound.protection.outlook.com ([40.107.93.80]:5312
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237194AbiAJQQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jan 2022 11:16:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8l6amIKoqyI3lzaABLiriBcwCEJ9nuJGz0xCEUWxp7BNZQy9gIIhTBrwJusNu7V9Y5FhmGg8O48RgfVdRDwLfwEiTdcF+T2FcWtleLl/gp1a7SynEUX4uUmxvE50ZjoL2WxA7IcjX1F6svFViJalMw+x29qOSdHzKTUMkZZeSdRH7caAB4iBTKkR/iIzMrun6ElPE6rs4vOgzf8XDxO4FwB+kkm+loR6uOphGbt5jkkScSaQmlF5l+ID3ECgaLnGLzKmCL4EnR+XLRgZSCrf5Hi0iZ/gH/Krksi6kefyymJ/7Q/bXwSMvT6esLMeY9tOR0rrj8cYZUPyPZD70bHpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=baMf/8ZCBam30sms6HF5SoErgC9TJgkWoueiToInqBI=;
 b=GsCaQIoltTkREdjXfZawu25Gjo8KWsz5SmDVp9WRhvLxBzVNNS8bb9djz/wURprr2D9Q8y6TvZ9F1kySF0asJ1IwjM0tDJcqquaJwS1u0PpzJS0KZOHYPUnirFnRxQ0kJTmFuThiYt2qIVzFVYidKUfFB6Tisfhb89hABJFNs/byc9aZYSs+URl2BGCiJ+6etqceWMhx/c2ERq6osqQEI7+mDBzk9APr0Q4HPRdz+/YcQNe8tiRBSaE1HGWYtvl4iX50pnh16eS29CI8OSIvZJaPe5Y5H2lEY1C8ZOGZI6z2KBq3BOr5+1xtDBguftDDDon7Qskin9U5gzqWR0iSmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=baMf/8ZCBam30sms6HF5SoErgC9TJgkWoueiToInqBI=;
 b=LPTk1wYUL2m1K91SWBGr7qwNva8AC/rLq5TpS0eCI1K9jfWA/5e//YHyTIiZuzmilxfo++Xjf1ETGgv2B888/UnMlzbcdlMaL6pP0ffwUn3eGc9D46Wu5sJQ/CLqUIXdxTrEMO/2drxkv43lBypjnK9l83HLROV52FCBH8FnjSg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14) by MW3PR12MB4474.namprd12.prod.outlook.com
 (2603:10b6:303:2e::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Mon, 10 Jan
 2022 16:16:24 +0000
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::b4d6:f148:3798:6246]) by MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::b4d6:f148:3798:6246%7]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 16:16:24 +0000
Subject: Re: [PATCH REGRESSION] Revert "drm/amdgpu: stop scheduler when
 calling hw_fini (v2)"
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Len Brown <lenb@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "Chen, Guchun" <Guchun.Chen@amd.com>,
        "Grodzovsky, Andrey" <Andrey.Grodzovsky@amd.com>
Cc:     "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <8ab406c8bb2e58969668a806a529d5988b447530.1641750730.git.len.brown@intel.com>
 <BL1PR12MB514403767AC6BC6CD617674DF7509@BL1PR12MB5144.namprd12.prod.outlook.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <2e3fbfe8-e7a1-2483-dbbd-ebb3824fc886@amd.com>
Date:   Mon, 10 Jan 2022 17:16:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <BL1PR12MB514403767AC6BC6CD617674DF7509@BL1PR12MB5144.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM6PR08CA0048.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::36) To MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcbe571b-175d-460d-533f-08d9d4548bd7
X-MS-TrafficTypeDiagnostic: MW3PR12MB4474:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4474D0713ED66E0A477DD1F583509@MW3PR12MB4474.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:785;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QXBZT1IAUhMrrGLwED+Md2CHeQ8dofPxES0akWay/L3zdxwbTeyFksW+AcWEXtIIXjK5oniITasUDC42EQu6UwT8qMuxYzTWImIY31OuJCGQZvAqXPNWEg5AspP9D5qMbMGpV67/kSocteRGzBzOvMojGtLAvqP42H3bFUBiVoJ/UZ77C8cDe+9T4rxguEJ7jbiGWKUg7Al/b6MOFs1Tj5DbuKhdX/Ibp9y3Exm4Ypmapx0oIGrYwXpqgL2n82EFxfIbDQ6XrdIFfJ7tc5dZ1oGo4VkA9c3MGJdOgVWujA8034yp5aNcYuiQjs0GD2g8kizze+IT2EWw1TSAaXQGcuqIw5lteZfk7ZMhd7mnFO5xE6f2o9DTC+L9B+JxivvwdYLVuqHEw66e3zf1Ype53Po1Pq1yqi9HkKX4AMdPFv6aYNp4tNVis2ZPsqmE8GKhUNLDd9gpIa3qTdbR9MaSP4nUoYCX5ebd7Cb9q3canTGLa37OXP8BmIM61DcYm7epPtXL3HVCsUGjUxlbvc/yCwll3E3ywsHNTelndgYaWw6Oe4slm+mmT1JBEG+TIyp6wZttrrGg3w4toGRJ+TjzWDEApUsrjWnbRB/mOAkRQVxzlt7/xHU58QW+WfbdsdSxW23d+Mh6j7oWcMEWfaLxs25q4WbplgG4neZZZ+IwAkW+zwAHW65iCK0Dd4rsqCZRcQDxpMYXILrXBnFWaxjiXGLt1eZ94y1Fh6pk/N//ao5PgkgZjJuQAbUC0QfGWOqouNQx5Tc3OkwNlxP/VHAw5Vac6HLru9k88EeZBXuvuoxhct4wlm88TUovggqHJub/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1201MB0192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(53546011)(186003)(86362001)(8676002)(966005)(83380400001)(8936002)(6636002)(45080400002)(66556008)(31686004)(66946007)(5660300002)(6512007)(2906002)(508600001)(316002)(6506007)(6666004)(38100700002)(6486002)(36756003)(54906003)(31696002)(110136005)(4326008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmlNRzVDSWgweXZJeXIreGlGS2VmVnczU0RkVWZ1d1VVU3RjaVZpb0Y3SVZn?=
 =?utf-8?B?ai9TM1F6QzdCT1pGc3hFMEFPc3FOc3FpOXlsMmdzcFVaazR0KzRISCtNS3A5?=
 =?utf-8?B?bldFNmR6NXViY2pXdnVCeDVYbjVhbjJNaytLcTNtNHZER05QSGlvRUJFZHNV?=
 =?utf-8?B?TjRlZWV0NDFnVmJzd3IveXVGMGNYcUo2anVGamdUYlVKYU42RjN1N3ByYlIx?=
 =?utf-8?B?YkVBWEdmOTY0NlZBcnZDM2lINlFGNnVjN1JiNDQ5UlFodkFGb0I4TlVudTZ4?=
 =?utf-8?B?ckFhZ2JaQWhURFFUQk8wOXV6NFFBRjZvQW8rbFZvQlpENTV0eVJRTmtHU09Y?=
 =?utf-8?B?ZUwvcUFlcjQzWnYrUFlmdTRwT0RBa05qQkhjaTZUYUozdHJYVVdTUS9id0ZV?=
 =?utf-8?B?Szl3bkJRcEFqWWljdDRuTEswQjRoZ25BMXZuZE0wT0FtV2NOSDdMajRuU0U2?=
 =?utf-8?B?emVNbml5dzhnV243eEdkMzlMcmJVaTRteFQzaGtNdHFueWJ2QXBFL0xDWXdy?=
 =?utf-8?B?TGYvMjVHSzM2QkN0Q1FZMHBpQUJwMUovbmpFME1ydFovMjNScXo1dS8weENR?=
 =?utf-8?B?Ung5djFxV2tlMThFSUowd1RwNXYxeGllcHBWVlZvMXJKdFpucTRmK0c4dDkz?=
 =?utf-8?B?dGZNYkFhWkJOMmlQNGJVQWZSelA0bzdOa1poQ3NKNStXbWlFb3hBL0ZwV0sz?=
 =?utf-8?B?OVBSMWpLL0ZTckZqTGZxWFhWbm5hUEN4VVVhck5ROUdmNE1sdGFLNnVnQ01S?=
 =?utf-8?B?dXpEZndWQ01MdFd4M1ZxOEN5aS91QnI3aWRjVkhXZTZSdGVSbXd4cnVjUVFP?=
 =?utf-8?B?OXh6Z3FFV054bEgvRjF2UVZ6dlFWN2ViQjM2dTVKQTNZWlhaV0FpdklFZTZI?=
 =?utf-8?B?a01HNUg2UzVMSUFlUnpJQW1ORjlJMm4wZXE2dklPNDRwM3Vrdmo4WjdjaEhw?=
 =?utf-8?B?V0hEdmdIbFFTRkRvUml6TUhaZHMxOW9VQkZCblRqaUlSUU1aa05icHpWa0w4?=
 =?utf-8?B?V1ZDSUdyN2VpV0JrQURtai91SzBNU1RoMVZFZDVYeHh3Z3pLS1d3VS91WXMz?=
 =?utf-8?B?b0twYlBuUUZwRGNoZml5S29qcisveEJQL25jbldpV2swQ2pCaWxTSXkzTS9X?=
 =?utf-8?B?Q2krakNrcUVqSzQwVDdvTUhMWW1oeWh2ODZrU1NTYmVpSGNUUjE4aEk5ajVu?=
 =?utf-8?B?THREZzEvNXprQlE3RE83VlAvMndKcm0yL0NoZjFEQkhnTWlEK3N3VE11Yldv?=
 =?utf-8?B?eVRPVVJnQ0x6QW1ST3lrck1SWUlnU1ROUi9nTVUzdkJXQ0prU0VKTzdKZGRp?=
 =?utf-8?B?am5pejRJVUEzdXpBK21JRjdBSHlqcUU3ZXZIQ3pjUmdEV3hzQUEybVRUdWJt?=
 =?utf-8?B?aTBzVWsrL0poeEFOYkwrcmZMVGQ5eEtHS0QvYXNEcXcwRTJGVG5QZU04Q3Rw?=
 =?utf-8?B?Uk9LVUtLZXNIUzFyc1hmMEJSeFlydytSWGVWKzdVc2g1QnZxa05Kckt3OFNl?=
 =?utf-8?B?M3dLbFpWSFBnSngrblNlZjFGMDFhU25mNVpGV2Q4M3VtckRUb3ljWExDVTAr?=
 =?utf-8?B?NE95ZDdlakpYNGRKNWxXcWpyMFZzUnNVQlFjUXVYcFpPeU95V0VNcXVzNWNT?=
 =?utf-8?B?dytzZVBTWlVIc2NmakJGakt2TWFFOEtISzVwTUsyMThtUEZkYWpKOWUveXRM?=
 =?utf-8?B?Wko5Ums1THdySzRTYldLZW5VcGJDSWZkYTFBUnhTRE5TRmI3ZmV0eU9LRVZY?=
 =?utf-8?B?K0FKQUNQRDg3TzZ2OUZtSm1ySDlMNGR1RExFMTV3bzc2aVlUMFlPYndjOVFI?=
 =?utf-8?B?RVJ0ZDEzcG5VQ0h5byttN2Mwd0ZNaS9lYVd0dnpQZGM1QlJHUVNuREwwOGhv?=
 =?utf-8?B?TEVtNlR0VmVnZ2VrMGg2NXREeVMzOFFESXFkcTNQL2p4bmQvNitiYUpqM0RK?=
 =?utf-8?B?OUk3WTZjWUNMcmRLNyt6N0tUcWhZSy9KcVBLU1BJazhKY05XbENMNUUzNXpa?=
 =?utf-8?B?amNFMDFhZy8yTHJiSjNkMjVwTVlYbjVJS2hDZ3RxTWEyQmdMRmJIQjZHQzUz?=
 =?utf-8?B?WW5LT2lHOEMydWJrQVpaYTQ3QXRrMG5oeUgwQlk2bGhjQk5vd21XVkowaDR0?=
 =?utf-8?B?STZieWIzcFA4WXNhbnFsQXFqNnJmcTI5ejJjUmRxNGxJdnpQYmVOTVFHRTVs?=
 =?utf-8?Q?SeXuJCGi4j93O6i2Q+HZJww=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcbe571b-175d-460d-533f-08d9d4548bd7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1201MB0192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 16:16:24.0465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Llu2K+HeYkQQXkJ67C37fed4/enWeVrX4LCUdEPnuNIkSWQ6MQqSZwRM1wlnf3vv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4474
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 10.01.22 um 17:08 schrieb Deucher, Alexander:
> [Public]
>
>> -----Original Message-----
>> From: Len Brown <lenb417@gmail.com> On Behalf Of Len Brown
>> Sent: Sunday, January 9, 2022 1:12 PM
>> To: torvalds@linux-foundation.org
>> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Len Brown
>> <len.brown@intel.com>; Chen, Guchun <Guchun.Chen@amd.com>;
>> Grodzovsky, Andrey <Andrey.Grodzovsky@amd.com>; Koenig, Christian
>> <Christian.Koenig@amd.com>; Deucher, Alexander
>> <Alexander.Deucher@amd.com>; stable@vger.kernel.org
>> Subject: [PATCH REGRESSION] Revert "drm/amdgpu: stop scheduler when
>> calling hw_fini (v2)"
>>
>> From: Len Brown <len.brown@intel.com>
>>
>> This reverts commit f7d6779df642720e22bffd449e683bb8690bd3bf.
>>
>> This bisected regression has impacted suspend-resume stability since 5.15-
>> rc1. It regressed -stable via 5.14.10.
>>
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugz
>> illa.kernel.org%2Fshow_bug.cgi%3Fid%3D215315&amp;data=04%7C01%7Cal
>> exander.deucher%40amd.com%7Ccf790be4827f4df9f2d808d9d39b81af%7C3
>> dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637773487569442716%7C
>> Unknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJB
>> TiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=AX0TXkyoMhy%2BZqE
>> VgRSWMkKd5nPa4WOv%2B1FZHLSErSw%3D&amp;reserved=0
>>
>> Fixes: f7d6779df64 ("drm/amdgpu: stop scheduler when calling hw_fini (v2)")
>> Cc: Guchun Chen <guchun.chen@amd.com>
>> Cc: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
>> Cc: Christian Koenig <christian.koenig@amd.com>
>> Cc: Alex Deucher <alexander.deucher@amd.com>
>> Cc: <stable@vger.kernel.org> # 5.14+
>> Signed-off-by: Len Brown <len.brown@intel.com>
> @Chen, Guchun, @Grodzovsky, Andrey, @Koenig, Christian
>
> Any ideas?  What's the consequence of reverting this patch?  Didn't this patch fix another suspend/resume issue?

I think Guchun was just trying to adapt that we removed the scheduler 
stop from the fence driver hw fini path.

Not sure if that actually fixed something or was just a precaution.

Regards,
Christian.

>
> Alex
>
>> ---
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c | 8 --------
>>   1 file changed, 8 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
>> index 9afd11ca2709..45977a72b5dd 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
>> @@ -547,9 +547,6 @@ void amdgpu_fence_driver_hw_fini(struct
>> amdgpu_device *adev)
>>   		if (!ring || !ring->fence_drv.initialized)
>>   			continue;
>>
>> -		if (!ring->no_scheduler)
>> -			drm_sched_stop(&ring->sched, NULL);
>> -
>>   		/* You can't wait for HW to signal if it's gone */
>>   		if (!drm_dev_is_unplugged(adev_to_drm(adev)))
>>   			r = amdgpu_fence_wait_empty(ring);
>> @@ -609,11 +606,6 @@ void amdgpu_fence_driver_hw_init(struct
>> amdgpu_device *adev)
>>   		if (!ring || !ring->fence_drv.initialized)
>>   			continue;
>>
>> -		if (!ring->no_scheduler) {
>> -			drm_sched_resubmit_jobs(&ring->sched);
>> -			drm_sched_start(&ring->sched, true);
>> -		}
>> -
>>   		/* enable the interrupt */
>>   		if (ring->fence_drv.irq_src)
>>   			amdgpu_irq_get(adev, ring->fence_drv.irq_src,
>> --
>> 2.25.1

