Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26065A67E3
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 18:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiH3QGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 12:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiH3QGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 12:06:41 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2084.outbound.protection.outlook.com [40.107.96.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE55E68FC
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 09:06:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P17ZTO1Q5DiOYwdQmWnGH42Iedq7T3HQN4baQw7vveGWCM9dMvSykoEaxWbqi0mveFAyggaK6s3sGkJnCpcEeSvVjKf62bldrzs64l1iSWfIoFa+Kh8k0OhQb51nMlveb2kl/Z4mxw5g+f69YaBo3i0UjSzmED4iF3M518VdpeBctr5jCpFNUBWHygrmb9P9xMziV2Tg/ApsbolFgm3xTGeDdDwT1FoBx6q0yQLgIUZFR4hHk1IfOoS2s1RyqT592oUcmkcyP48sY+bNeCOluPiWQjHAvNDqV5ts87jInIQ2aP1fk2e+q51jSwidAy4/gYiM2icMumhEZQ+ki8vEVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fy4luFZlWHY2rFNk0AwtVLid8A4Bl2BJsj7C+NSwnS8=;
 b=NUpDLSX8A4WR6gk+YQRxmdDdJu1czxo1dzBSYD8ClZ05NgFxh72xCK75Mea545BBXCj9X97ClEvcyklmfyuYQAjtobUhC5+H2apRpUJQ5WmHsDX4fyTiuehzBPolv88bXZVpNOJMpdzWeOKbFuTzAnUyEFPYHElyREX3+dPdwWIlvqwGUOxC9lcIk+erE9sKcZpsnqQjBYOrSy/CTadLkOYRuVvhpUQeNTw1KP2j75BhIyRKiTqIai+WhNhAEZYBArFGMe4HB8HSv3zQCPIt0q/zlD5y3iEtOoWiSJWrpMsmeoRocHTg5XDOjhSl/r22tQzGdxOcOHclRfnRugp8ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fy4luFZlWHY2rFNk0AwtVLid8A4Bl2BJsj7C+NSwnS8=;
 b=1bl6mYGZE+w2LJBjREGpmzO97g7GaSUDUxdFxRVihJNaNb+vQQVwiHegGFjYk26TVfZ/041KGpp0Gao0TqCL9xeexCr32/ecqXecZPboEGYWDMeuvCM2YvtAD4WHx/+qVUL5FUDWZAXLLfSg0+oWL06nhiNV6ouudgp50koDIE0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by IA1PR12MB6089.namprd12.prod.outlook.com (2603:10b6:208:3ef::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 16:06:37 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::2925:100a:f0b9:9ad8]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::2925:100a:f0b9:9ad8%3]) with mapi id 15.20.5588.010; Tue, 30 Aug 2022
 16:06:37 +0000
Message-ID: <9ef0287a-e463-d440-58fe-0323a6eca94a@amd.com>
Date:   Tue, 30 Aug 2022 21:36:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 1/2] drm/amdgpu: Move HDP remapping earlier during init
Content-Language: en-US
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     amd-gfx@lists.freedesktop.org, Felix.Kuehling@amd.com,
        stable@vger.kernel.org, tseewald@gmail.com, helgaas@kernel.org,
        Alexander.Deucher@amd.com, sr@denx.de, Christian.Koenig@amd.com,
        Hawking.Zhang@amd.com
References: <20220829081752.1258274-1-lijo.lazar@amd.com>
 <CADnq5_O=3u1Z4kH_5A+UsynQ31Grh-=j=3+hPWo398kfMi411w@mail.gmail.com>
 <3b2a9a8f-dedf-2781-0023-d6bd64f16d65@amd.com>
 <CADnq5_P0=+NNk2v_VOxyjOVSnY55SY=OX40xD5Bx6etspREnfA@mail.gmail.com>
 <1890aec6-a92d-e9b7-a782-fd6b0e8f8595@amd.com>
 <CADnq5_Pkpe_-SH8Wh=_s6FXDFEWvO8rr5Ls2=Q4HRXy9+eSOBQ@mail.gmail.com>
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
In-Reply-To: <CADnq5_Pkpe_-SH8Wh=_s6FXDFEWvO8rr5Ls2=Q4HRXy9+eSOBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0047.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::22) To BYAPR12MB4614.namprd12.prod.outlook.com
 (2603:10b6:a03:a6::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3613cff1-83c3-49d5-d880-08da8aa19deb
X-MS-TrafficTypeDiagnostic: IA1PR12MB6089:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: txBB8Sz8AYtX6UJDqvRwLbJb20n9DjyO6UzJ5d9kFZ3LFJirYrkPyE/beo9asmj587F+Ni6IaMILBuAvY2nquud0FmeBe+dhQSVxfYQHsSsVTKaTNjO4UvMUb5uk4KQVTPo1d3o3V1sH2K8G8C+ARfgtW0h/Q2rUrWnoKHHASKsYa5SAcytST2Ocjkv+yPJ+Mp/iZY7NcKQP/8jyp2/mDUO2DmaexuhZBQm00hRW78E3vS+zBqiSz3s5EMTjOZmvJPeGgomN+MK5+ALovUE74lZDXqXWM68q5UwAkxpuVOrPQvj+Yj2B1ZehpUSPirs/CwHdgEFlbiPlsL20zfBcHFZr3qKnQBtuze/zbwHCV2ZsEBxOiGcZES1UG8L2+hTg3YyUskac3fGtlISZJECKd59KCuP/CKm5SFaHcERosxZMsO/Y0Zigj0C29lVUksdJLpdzTtnX+P7prg945WeNiclnqKkmnkdDBrTCBcfhEfpl9ALSeaTO1r0t/XXtIl9uqNioE8KqXQM7MAfrECobBPSRigpm0sjBeTRIBuobtXDo+ORnjZN60r0OmhKNxcTCgsy1YxyU27hzBmWkSMJJ5Yl5YX8j5/cdbLI2eRqw3Nu+An1zwb5BP1QBbhJyMwakGkHB0aPsvqLLn2SznE7rizj3nLTNPC3oiPsLj1sab3ZsYR73JtLHBWBDbqZJRDfmEVBPE8Spj5Fs5j4mJMhfku0L9rJgngItjWTwRedRE3LyiyXtEeaAFmSI/e98Fq2Nts1ADF4Uzd3xVBsX9qyBClVSWNOZhO+mHGthsMp80JzVhBT97Kbs82WyLyC6IiWJKqfV9CJ1eyphKGlISeMuaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(36756003)(45080400002)(6916009)(38100700002)(316002)(31686004)(83380400001)(4326008)(66946007)(6486002)(478600001)(66476007)(966005)(66556008)(8676002)(41300700001)(5660300002)(8936002)(6506007)(26005)(6666004)(6512007)(53546011)(2906002)(2616005)(31696002)(86362001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0ExSklrc2orYXVmVkJMSUE5bEF2c1BrbC9Ydk1FeVpBY3dEVUZzK0Z2eXp4?=
 =?utf-8?B?ZkZCdkk2Rk9GRmUyOXpYK0ZRUDA4Z3I5cktFV1RVM1hPOU10U1M1NzNOUHNa?=
 =?utf-8?B?UmlRS3VpVDNYSk9BcHRaMnI4NWhWQ2VHbHNySmdZRmJ4QlJkUkJ2cUJNb01K?=
 =?utf-8?B?OFlyTTFGYXg0NVlBc25pdXpIMnRzSVZyTlNhOFlCVDdZa2lyMGdGTTkrRHlK?=
 =?utf-8?B?ak5RLzQ0NjBzUy9ua21Fbk1lMEREY0ZXamlBTXRNZFIzWHR5Y1o2em1nWXUz?=
 =?utf-8?B?OGk0SXZnMkx4akhDd2Q0NnNWQVJ6NUMxSzJsWTNheXRDdjhrSFZJUDlRUEwr?=
 =?utf-8?B?bVBRUU53RkpaU1J4aU1iZkVsbWlEUTk3Q09zbXljSnVPZGY3WkZGRmNldXIv?=
 =?utf-8?B?b0FEODZ6c0Vjci80K3N5Tm1lOFZEeC8zWmlkSGp4M0ZQSWVDK2Q0c1lGelVu?=
 =?utf-8?B?YmF3Z1ZtZWdaV0dwaWJCcDNZclZ2cXNVNzlySHYwODhUUDlXdTkrd3M2bDlG?=
 =?utf-8?B?d1kyZklzZUh0Ni9NajUrOWNzeTg0cFNCbkVNU2tGNnhYa21GdFEyZExoN0VS?=
 =?utf-8?B?ZXZZUG1sMDNqM1hqNk9ZdXhUTUk3VFpDWTNWbkJVMXU2VDdSdmgvbC80cDdO?=
 =?utf-8?B?RzRHNy9CRk9yQlRTRXFCTEt3QStrU3E1TmJDN1A4RnpkRmkrcXpSYTUrK0VL?=
 =?utf-8?B?UFhkNnJ1dEVtL2xtNU1UNThHYnVBdlNwL1JOTnRrQldCM01ZQlBhZnNpUkNq?=
 =?utf-8?B?MDNwekpBVlFPRnNkS0tockhHZUwzNjcrYUEzQTMxVTByNlBKMEJYUVkrd3VD?=
 =?utf-8?B?T2I5eGtPQkh5MldSRlZMRG9wVGIwaWx2QlpFQnBnajBtNnNvRWVGbjhwTW9D?=
 =?utf-8?B?K1EzY0huOHh0QVVrajBpcHVsOUF6TlIwcmszSjUyY3ppOElYYkZVc0lOS2lW?=
 =?utf-8?B?cG9yUGV5UHRSeFlmZFJMVG1MenlOeWhvUVdvVTZhMEorbytkYWtSdFJUcjFN?=
 =?utf-8?B?U25oNGRlMnVsMXN2MVppL2Y1bGRaTUt5REN4c1MwcW1HR0tTbU1rWXNHVVFE?=
 =?utf-8?B?ejIyK0R0SFRib0MwdHBNRC9zWno0OC9NbXlpTFE1eXVPVE9Qd2tJYVB6L0hk?=
 =?utf-8?B?WjdQaXhQSHhXeklMMk01eXBMY1d1eVNDaTNJRkxMTGdqNUpZZk1EOUFMSCtw?=
 =?utf-8?B?VCtHVHI3RXRINGdYcW9JSnF1cEVXUEdnLzlPT1NlSEFaZ3RyekdLUVIrdHVr?=
 =?utf-8?B?eHVKVjFmRHRBWjlvZVg2cDFpRitBbEo2Y284d0Vkc2tFdUYyR2tqVnBoQWs4?=
 =?utf-8?B?b285bkZuOXdNTWk3OVZDUVFoeEpCT1BRa2tMTEtKV3puWjluQkFJQmk3Kzla?=
 =?utf-8?B?NU4xZ05heGpiNzRMZTZwUlAvWmd6dWdKelJ0b3dKUEJFeTZycVpydkk3NHlk?=
 =?utf-8?B?bCt2VVgzeDNBb3VzRnJneHQ4QUpVSlJIQ2dFdEFCeVE3Rms3dFd0ZTJaOGs4?=
 =?utf-8?B?QlJGSTBzdFZJZExvTEluUnA5ejhqUXNGOEdzU29WZTVubm50cGFrMmQ4YXVL?=
 =?utf-8?B?UG1wdm9UbGdDODlteFo5cjJqMDFZRzJlb0thUnJ0L3RxVkl6MHFVUDN1Z1I3?=
 =?utf-8?B?YkxERFlxRWlDRjdTS0hIVi9qL3Q4UTJyT3lvcExONkNSVS84T1RtU3FkSSt6?=
 =?utf-8?B?NWxVWXFUL09PQXdwcm1aTERtZ1lYTjBaeGRLQ2k4UStnMENDMFQ2S3hNWUla?=
 =?utf-8?B?S3JTOGw2UGY2U2VtMmJ5V1dnYmVkM2FMcExHUlVFSkRWT0Jvbk0rRmRlL2VR?=
 =?utf-8?B?WkdEZExlZjl1OEJoWkhrajVrbmdMS2duNmY0QUx4RVdOUHFTV2c2U3Jkb0xz?=
 =?utf-8?B?NG5nNGpYTnRBaXNDeERhWVhQOXBlenlnb0JBeUpBT2liNlB2Zms1aS8rSEx5?=
 =?utf-8?B?RkV3aXRsSG14Y2hmeUNYejFJRGhCTXVkenJNUzQ4OVFKMkNRUHIxQ0pLY3VY?=
 =?utf-8?B?MkNjbTZvOVVFcTZxNGRBV1hVRUQ3ZTNubVRoT0huWVJlNXBNVXZnMmhKRENJ?=
 =?utf-8?B?bFhJazlwL0d5ZGZuUXlQaDRTZ1FwNDF6cDVRSEZvdFNpci9ZWUMvVmh0YVFP?=
 =?utf-8?Q?zutTQT0aLz2ceQ7/sOyVkdpeE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3613cff1-83c3-49d5-d880-08da8aa19deb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 16:06:37.3943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kzGRidThsqlA8EqXAG4HCDL3dsDiPTM8bjOmL8Qa8nvaerbGbVYI8t2b//4hGDye
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6089
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/30/2022 8:39 PM, Alex Deucher wrote:
> On Tue, Aug 30, 2022 at 10:45 AM Lazar, Lijo <lijo.lazar@amd.com> wrote:
>>
>>
>>
>> On 8/30/2022 7:18 PM, Alex Deucher wrote:
>>> On Tue, Aug 30, 2022 at 12:05 AM Lazar, Lijo <lijo.lazar@amd.com> wrote:
>>>>
>>>>
>>>>
>>>> On 8/29/2022 10:20 PM, Alex Deucher wrote:
>>>>> On Mon, Aug 29, 2022 at 4:18 AM Lijo Lazar <lijo.lazar@amd.com> wrote:
>>>>>>
>>>>>> HDP flush is used early in the init sequence as part of memory controller
>>>>>> block initialization. Hence remapping of HDP registers needed for flush
>>>>>> needs to happen earlier.
>>>>>>
>>>>>> This also fixes the Unsupported Request error reported through AER during
>>>>>> driver load. The error happens as a write happens to the remap offset
>>>>>> before real remapping is done.
>>>>>>
>>>>>> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D216373&amp;data=05%7C01%7Clijo.lazar%40amd.com%7Cbe8781fe1b0c41d3bad408da8a99b3d8%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637974690005710507%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=98WWFEcwi2tzyf%2BxnYC%2FK3UcCE5mfXI00qfYGUpt2Sk%3D&amp;reserved=0
>>>>>>
>>>>>> The error was unnoticed before and got visible because of the commit
>>>>>> referenced below. This doesn't fix anything in the commit below, rather
>>>>>> fixes the issue in amdgpu exposed by the commit. The reference is only
>>>>>> to associate this commit with below one so that both go together.
>>>>>>
>>>>>> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
>>>>>>
>>>>>> Reported-by: Tom Seewald <tseewald@gmail.com>
>>>>>> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
>>>>>> Cc: stable@vger.kernel.org
>>>>>
>>>>> How about something like the attached patch rather than these two
>>>>> patches?  It's a bit bigger but seems cleaner and more defensive in my
>>>>> opinion.
>>>>>
>>>>
>>>> Whenever device goes to suspend/reset and then comes back, remap offset
>>>> has to be set back to 0 to make sure it doesn't use the wrong offset
>>>> when the register assumes default values again.
>>>>
>>>> To avoid the if-check in hdp_flush (which is more frequent), another way
>>>> is to initialize the remap offset to default offset during early init
>>>> and hw fini/suspend sequences. It won't be obvious (even with this
>>>> patch) as to when remap offset vs default offset is used though.
>>>
>>> On resume, the common IP is resumed first so it will always be set.
>>> The only case that is a problem is init because we init GMC out of
>>> order.  We could init common before GMC in amdgpu_device_ip_init().  I
>>> think that should be fine, but I wasn't sure if there might be some
>>> fallout from that on certain cards.
>>>
>>
>> There are other places where an IP order is forced like in
>> amdgpu_device_ip_reinit_early_sriov(). This also may not affect this
>> case as remapping is not done for VF.
>>
>> Agree that a better way is to have the common IP to be inited first.
> 
> How about these patches?
> 

Looks good to me. BTW, is nbio 7.7 for an APU (in which case hdp flush 
is not expected to be used)?

Thanks,
Lijo

> Alex
> 
> 
>>
>> Thanks,
>> Lijo
>>
>>> Alex
>>>
>>>>
>>>> Thanks,
>>>> Lijo
>>>>
>>>>> Alex
>>>>>
>>>>>> ---
>>>>>> v2:
>>>>>>            Take care of IP resume cases (Alex Deucher)
>>>>>>            Add NULL check to nbio.funcs to cover older (GFXv8) ASICs (Felix Kuehling)
>>>>>>            Add more details in commit message and associate with AER patch (Bjorn
>>>>>> Helgaas)
>>>>>>
>>>>>>     drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 24 ++++++++++++++++++++++
>>>>>>     drivers/gpu/drm/amd/amdgpu/nv.c            |  6 ------
>>>>>>     drivers/gpu/drm/amd/amdgpu/soc15.c         |  6 ------
>>>>>>     drivers/gpu/drm/amd/amdgpu/soc21.c         |  6 ------
>>>>>>     4 files changed, 24 insertions(+), 18 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>>>> index ce7d117efdb5..e420118769a5 100644
>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>>>> @@ -2334,6 +2334,26 @@ static int amdgpu_device_init_schedulers(struct amdgpu_device *adev)
>>>>>>            return 0;
>>>>>>     }
>>>>>>
>>>>>> +/**
>>>>>> + * amdgpu_device_prepare_ip - prepare IPs for hardware initialization
>>>>>> + *
>>>>>> + * @adev: amdgpu_device pointer
>>>>>> + *
>>>>>> + * Any common hardware initialization sequence that needs to be done before
>>>>>> + * hw init of individual IPs is performed here. This is different from the
>>>>>> + * 'common block' which initializes a set of IPs.
>>>>>> + */
>>>>>> +static void amdgpu_device_prepare_ip(struct amdgpu_device *adev)
>>>>>> +{
>>>>>> +       /* Remap HDP registers to a hole in mmio space, for the purpose
>>>>>> +        * of exposing those registers to process space. This needs to be
>>>>>> +        * done before hw init of ip blocks to take care of HDP flush
>>>>>> +        * operations through registers during hw_init.
>>>>>> +        */
>>>>>> +       if (adev->nbio.funcs && adev->nbio.funcs->remap_hdp_registers &&
>>>>>> +           !amdgpu_sriov_vf(adev))
>>>>>> +               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>>> +}
>>>>>>
>>>>>>     /**
>>>>>>      * amdgpu_device_ip_init - run init for hardware IPs
>>>>>> @@ -2376,6 +2396,8 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
>>>>>>                                    DRM_ERROR("amdgpu_vram_scratch_init failed %d\n", r);
>>>>>>                                    goto init_failed;
>>>>>>                            }
>>>>>> +
>>>>>> +                       amdgpu_device_prepare_ip(adev);
>>>>>>                            r = adev->ip_blocks[i].version->funcs->hw_init((void *)adev);
>>>>>>                            if (r) {
>>>>>>                                    DRM_ERROR("hw_init %d failed %d\n", i, r);
>>>>>> @@ -3058,6 +3080,7 @@ static int amdgpu_device_ip_reinit_early_sriov(struct amdgpu_device *adev)
>>>>>>                    AMD_IP_BLOCK_TYPE_IH,
>>>>>>            };
>>>>>>
>>>>>> +       amdgpu_device_prepare_ip(adev);
>>>>>>            for (i = 0; i < adev->num_ip_blocks; i++) {
>>>>>>                    int j;
>>>>>>                    struct amdgpu_ip_block *block;
>>>>>> @@ -3139,6 +3162,7 @@ static int amdgpu_device_ip_resume_phase1(struct amdgpu_device *adev)
>>>>>>     {
>>>>>>            int i, r;
>>>>>>
>>>>>> +       amdgpu_device_prepare_ip(adev);
>>>>>>            for (i = 0; i < adev->num_ip_blocks; i++) {
>>>>>>                    if (!adev->ip_blocks[i].status.valid || adev->ip_blocks[i].status.hw)
>>>>>>                            continue;
>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
>>>>>> index b3fba8dea63c..3ac7fef74277 100644
>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/nv.c
>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/nv.c
>>>>>> @@ -1032,12 +1032,6 @@ static int nv_common_hw_init(void *handle)
>>>>>>            nv_program_aspm(adev);
>>>>>>            /* setup nbio registers */
>>>>>>            adev->nbio.funcs->init_registers(adev);
>>>>>> -       /* remap HDP registers to a hole in mmio space,
>>>>>> -        * for the purpose of expose those registers
>>>>>> -        * to process space
>>>>>> -        */
>>>>>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_vf(adev))
>>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>>>            /* enable the doorbell aperture */
>>>>>>            nv_enable_doorbell_aperture(adev, true);
>>>>>>
>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
>>>>>> index fde6154f2009..a0481e37d7cf 100644
>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/soc15.c
>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
>>>>>> @@ -1240,12 +1240,6 @@ static int soc15_common_hw_init(void *handle)
>>>>>>            soc15_program_aspm(adev);
>>>>>>            /* setup nbio registers */
>>>>>>            adev->nbio.funcs->init_registers(adev);
>>>>>> -       /* remap HDP registers to a hole in mmio space,
>>>>>> -        * for the purpose of expose those registers
>>>>>> -        * to process space
>>>>>> -        */
>>>>>> -       if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_vf(adev))
>>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>>>
>>>>>>            /* enable the doorbell aperture */
>>>>>>            soc15_enable_doorbell_aperture(adev, true);
>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
>>>>>> index 55284b24f113..16b447055102 100644
>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/soc21.c
>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
>>>>>> @@ -660,12 +660,6 @@ static int soc21_common_hw_init(void *handle)
>>>>>>            soc21_program_aspm(adev);
>>>>>>            /* setup nbio registers */
>>>>>>            adev->nbio.funcs->init_registers(adev);
>>>>>> -       /* remap HDP registers to a hole in mmio space,
>>>>>> -        * for the purpose of expose those registers
>>>>>> -        * to process space
>>>>>> -        */
>>>>>> -       if (adev->nbio.funcs->remap_hdp_registers)
>>>>>> -               adev->nbio.funcs->remap_hdp_registers(adev);
>>>>>>            /* enable the doorbell aperture */
>>>>>>            soc21_enable_doorbell_aperture(adev, true);
>>>>>>
>>>>>> --
>>>>>> 2.25.1
>>>>>>
