Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491D4694BEA
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 17:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjBMQAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 11:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjBMQAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 11:00:10 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C851F4B3
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 08:00:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kE3Q3gqOWCo3MpQ2bRs88KVI3SknLgNRUGexX3/wc87wtMArNeNa0Ow1rVBQrQmuiQVXjpLRJFTA3iTd62cORa+z2OtAiBMweQr2DedqQKctt1PcslFB6e+6R1/4GKkUm87C5G8yJrNQDgD7cY91RYmBAvbeDeQHQlJPGCBJuClwN844kSAnxsNOUp0l+1gg2/JGWk88q0EOXUjXQL+Yv8EbEZgei1X1LqpHPb5D7eH2I80a+IIqYdMmegjJAG4TZ9ZOlnD5ShuZBmwIdJIC+jKMHcEFHTrH8C13jk2KPi/xcYIKN4VbnW0fU2vhnaHUxnDYfZ2LGGfX9ezromfZRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s1AprK5ANdPOeGsec4nxprnSrWrjxr5M4K4195VrfoA=;
 b=nACayq5GtMqii6cB3h+zV3l0uAqiIwrhl+4le5URl1lwyvNdK+/iHYhoVn7y1cGAVBMJX2A6yXzXXkPpHehhErZTXZONqI1ZOEMpC2x6QrWjnWJ2K7wnwsMbmqqi0ZhqXCjkVVSMQBD91mEB+OT3/+7AlesrZq5pvj4pjuv0Yixnb89yTdfa0s8ItkYygAZVUvyI7GNywlrmNHSFj1vw/vJWpl3/mCtG4f1+DOUUtOtxFX/IJt++fbLYQUgGz55ifRd3Va3HQ+YyRy2OgRAMB8T03YjAjX8AIG5j5Or7Gfi/q1HMr/R2uIsjo34PU8ytvdT2zBg/f43NYA/+pIq8Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s1AprK5ANdPOeGsec4nxprnSrWrjxr5M4K4195VrfoA=;
 b=ibaajRCL8xmvOAV5iDVsBBmTXzooII0b/BIQU9xGAqQhgh81HlXeTrflF1H7rwiGr21t2m65u7mADX/DmuJPYlZi0xYsYTo/PCTiB9+NBKh5O4zV4YJPFUaK7xRS9B71R1IQ6492Bb1UDmCKaOUCF9pov6aOnBxXhaFs536qFzM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB6280.namprd12.prod.outlook.com (2603:10b6:8:a2::11) by
 DS0PR12MB8020.namprd12.prod.outlook.com (2603:10b6:8:14f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23; Mon, 13 Feb 2023 16:00:00 +0000
Received: from DM4PR12MB6280.namprd12.prod.outlook.com
 ([fe80::5935:7d8d:e955:6298]) by DM4PR12MB6280.namprd12.prod.outlook.com
 ([fe80::5935:7d8d:e955:6298%7]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 16:00:00 +0000
Message-ID: <904b2f2c-960f-d564-3741-4f5c184d8a10@amd.com>
Date:   Mon, 13 Feb 2023 11:01:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] drm/amd/display: Fail atomic_check early on
 normalize_zpos error
To:     sunpeng.li@amd.com, amd-gfx@lists.freedesktop.org
Cc:     harry.wentland@amd.com, Rodrigo.Siqueira@amd.com,
        stable@vger.kernel.org,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
References: <20230213155126.29435-1-sunpeng.li@amd.com>
Content-Language: en-US
From:   Hamza Mahfooz <hamza.mahfooz@amd.com>
In-Reply-To: <20230213155126.29435-1-sunpeng.li@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR01CA0026.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::34)
 To DM4PR12MB6280.namprd12.prod.outlook.com (2603:10b6:8:a2::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB6280:EE_|DS0PR12MB8020:EE_
X-MS-Office365-Filtering-Correlation-Id: cb42b46e-42ab-4e8a-61db-08db0ddb5c52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGG7jQ1aXJPtcJhmEyaDE8Fkywnz2H2Ti73qCSNbz8Qy2JRnQeG6io3dgZOagtUf1GWP4u7uiNpSKC+d6on4A7P8cJYanocr1tEVnMas+ZCkdYnGFwIlf4Te4MKKwbfL5lglfy7IfwUYUDY2vql79KPBCjFo1BI7Y+36MpKTFzr9Ufdgj+LmMCdtT6c9mOEc31m1PNLHpCMOjMwPyTPvq1OaiaO85KEbVqomWBn0o2gurxoQOYhUcclXeuB1PrvNvsWTYe1HvqfNlTnlkvbaH5gQldFN+KpelHLibGGpfkvPtXqo4NVljSsr3xWYrp1SsG5QhZhaW31120i9Aju2A2EKkh9a3KA8IZmLFIVBCZ1dBP0+c/Q/bViea7hFLY7G7TpAjt9N7S7sXX/+IhEkvauPo+9dlNT7NhOttagie6vhTPy1b5NWxdm8j3poyqB799BmvfvsLEYIKM5KXuNtY7YS3IkZZuTsQOU4v5q0eUCGwmc0W5PBG6U3GfJV9UNAMRMEuuyXX5smlEjeH5NANVbtNt2Xx2uhW9phGr3SXQ6Wit/95hgqg2iXNwDmG4CxqaNnrwvLHS8YvcK7V8WuceiAbh2lY9P5yW8d1gh/Bmm8nFg0eJEBn3DCDTxM1XtOh+6sW/1E/wA1xLGbW0duO48xZJrwUPLeciIFB8/In5NSLGeDlFjhu9TDMvjHL1VytvZq1akEEywwulwJiMCMAYlprDHkKqYtYyn8ei0Dmak=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6280.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(451199018)(8676002)(8936002)(2906002)(38100700002)(2616005)(6486002)(36756003)(44832011)(5660300002)(86362001)(53546011)(26005)(186003)(6512007)(6506007)(31696002)(41300700001)(31686004)(478600001)(316002)(66556008)(4326008)(66476007)(66946007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTlvUGlKdXNhOURNdnp3TFc4VWJFOVBMS2pMN2kyejg4ekJmQm1qcnRPUXVn?=
 =?utf-8?B?YTE2ZkkvUHZDQUdBVlZjQkRmbGVYVXBodkxhelVtMVBXZjF6NndpYUVkR3lY?=
 =?utf-8?B?UnJsNXBidExmK2JXSFhhRjF2MklYYlFnS2N4ZzNmczZ5eXliblFIRGMreVdJ?=
 =?utf-8?B?Z2FhV1JmajBqbHZvYW53QWZRWlVtVjYyMUNLREpWRUVDVmVtaVhFYkJneG1N?=
 =?utf-8?B?TTBNZFUzejhIZ0RNeU9yb1RkUW9hTUM3YVNhakFXT1I3d0NGdWxGbFpJenV4?=
 =?utf-8?B?US9lU1dRdGlyUWJCemlma0JTaW43SkJVY2pzc0VyY0ptWXJqUVRtR09kOFhK?=
 =?utf-8?B?aTNVd1V1ZXVvdFJuSEI1cG5wOVNUNVBSanFlZkxvWTRFVnovMlU0TTJSVGY2?=
 =?utf-8?B?V09YR0VJWThRSmc0b2RzMlYrNmd3RTNaWEJOaGQ3K241eUEwa3JKM1F3RWNq?=
 =?utf-8?B?dmorRGcrMnlkQ3BYd2wzaDcrSUI5TFRVWUNqakRLVmdwU1hidnk1RlgrYmVy?=
 =?utf-8?B?L2xmaVltZlBKdVRqbFBqTHVlTzYwMVRlVEpWakFnTitpTDNDTm0zRnUyRkxq?=
 =?utf-8?B?eWVDelVsQ1FaMnlGeVpHVlZDME0vUDMyQlZ5T1h2b0tqWmFob0UxUmdEeDRn?=
 =?utf-8?B?RkdlbnFTUkVUb2xJTUFNNk5iZ1c4bHJ3TkZwNWMrNDhoR1dhUnk1V0ppUVZU?=
 =?utf-8?B?djJaSHFqei9BeGIwYU1adnZsT2ptYmttMGpnUXlTZEREN3hvcVdTVTN6Tloz?=
 =?utf-8?B?c0RsdW5aekVYYk5qM3BQcmdNM3lOUHJHRDFtMXEyaUFzRXV0c3JLUzQydEk2?=
 =?utf-8?B?SGVacHM0c3pDbEZrQ2xGYmJqZFFrWFRNQldHdjZ0VGwwYktnYkpWNWw2L3NW?=
 =?utf-8?B?OUtJbTZaR095czVPYXFhcHNJL2c3WDhVMUpYcnhjS3hLQnZvTnRRaW1jdy9r?=
 =?utf-8?B?SlVQeXRhYlE0VVFTa1hVZk1FQ3ViS1hEd2RaYVZaanQwbjN4d21yZUlOenRE?=
 =?utf-8?B?c2orZjJNZEhkT0RHMFBGemh3V1NBVEdsdk4zSy9lc1F6ZENDYy9yQnlaUnJt?=
 =?utf-8?B?Z3MrUEZ4NUx2OENyZVhtRTFrdHdxRkdZcFdCcmxIZlhkdGZoOURaSmxHS0Y2?=
 =?utf-8?B?Mm52MHBmcEFab1Npb3RXcnpyUXE3YW5xL2xYbjRaU3F6bmI1SEVTM0ZqSit6?=
 =?utf-8?B?N1krcXJmc0x6d3FPQXZlZHlsaWFaYTdXemRRUFJkbEFWVDZJSXN5a3Z2S2R6?=
 =?utf-8?B?Mnp4dFI4RHF5OEdVK2FPeWpvUm9jemFzVCt3ald0SWs3QXNLdTVnTk80TWs3?=
 =?utf-8?B?K1RPVmpiZ2NJMkhnMnhNMlpyYUpURHRLY0ROSkNPQWRqT2dpY2FFY0ZJa1Nr?=
 =?utf-8?B?VU9URUFJWnh1VmVPYm1KZWVxa002U3RITjMxZUNiWlJXRi9sVFNGaVVoYzhj?=
 =?utf-8?B?eVBjWThCTWp6RmV3OVdXV3RoM2tKdytzMXdLSUozTWJMcmdDWGRmR2JYb0I2?=
 =?utf-8?B?TldVaVRYaWRobEx3Y0tiZjZxeE4xeHdwTUI4L1ZQcXVxK2dxcVZKSDgwWmxK?=
 =?utf-8?B?VDYyMVdnS2k1aXZZd3ZyR1VsTFR5b0FpT3pEcGlZdkJCYTcxQWV4VUJwd0pY?=
 =?utf-8?B?ZmR1dGVMRVEvOEVGYzVRZllQcE1yQ013TFZUZ1ExSDNqQ3RON1YwbW1mVFFF?=
 =?utf-8?B?d1VLSGNNdVZkWEVNOUFWODhQNndmYy9ONXFLQjVzQ0VBRVpoUFZUNWhmaDBl?=
 =?utf-8?B?M1l0bU94NVAzWUNYa2dxQ3pGd2Z6cGlST1JwYjQrSFBEVVA0U2pERnl3TjRz?=
 =?utf-8?B?R0RuM0JzZVRqL2tVUnY4eThoMWk1UEYyYkVUTlRxeDFKU3NtNkdvdFRJWEtS?=
 =?utf-8?B?cWN6RjdySGpJckNobTR0Vnk4cWFKdGF5UXBneHVjTTJ3WHVyUXh1RW9KVjVz?=
 =?utf-8?B?NG4yUWtMV3VWNE9pSkZHRytrOHVVTDM5Qjd4ZTRCR24yZWJRa0lGN0Qyd3U4?=
 =?utf-8?B?TmNDcXhNQzhmYzhWcTBkaGZqUGoyRjJjaHdUWm9xZFdobEgrSDg4K3JCQjRP?=
 =?utf-8?B?STNUemZSKzZMWVNENmthdkhrejJ3MklpMm9maG5NcmJYY2ljNEVDU2grL1Qx?=
 =?utf-8?Q?NxLBlvkoqoJp7AjM5izFKUZmr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb42b46e-42ab-4e8a-61db-08db0ddb5c52
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6280.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 16:00:00.2366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lXCh3h8gNfZp3F2hb9GT8sg0KxuC0ipx40nd8fUq/DYH6EyJgAYr+xsiBgItOMmeawMZWZfw8FwdTu3VzhR5Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8020
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/23 10:51, sunpeng.li@amd.com wrote:
> From: Leo Li <sunpeng.li@amd.com>
> 
> [Why]
> 
> drm_atomic_normalize_zpos() can return an error code when there's
> modeset lock contention. This was being ignored.
> 
> [How]
> 
> Bail out of atomic check if normalize_zpos() returns an error.
> 
> Fixes: b261509952bc ("drm/amd/display: Fix double cursor on non-video RGB MPO")
> Signed-off-by: Leo Li <sunpeng.li@amd.com>
> Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

Cc: stable@vger.kernel.org

Reviewed-by: Hamza Mahfooz <hamza.mahfooz@amd.com>

> ---
>   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index c10982f841f98..cb2a57503000d 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -9889,7 +9889,11 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
>   	 * `dcn10_can_pipe_disable_cursor`). By now, all modified planes are in
>   	 * atomic state, so call drm helper to normalize zpos.
>   	 */
> -	drm_atomic_normalize_zpos(dev, state);
> +	ret = drm_atomic_normalize_zpos(dev, state);
> +	if (ret) {
> +		drm_dbg(dev, "drm_atomic_normalize_zpos() failed\n");
> +		goto fail;
> +	}
>   
>   	/* Remove exiting planes if they are modified */
>   	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {

-- 
Hamza

