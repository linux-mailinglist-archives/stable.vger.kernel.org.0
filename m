Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3381664FE
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 18:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgBTRgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 12:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728434AbgBTRgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 12:36:20 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43C992071E;
        Thu, 20 Feb 2020 17:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582220179;
        bh=jExt8zvCnhq4nFkDrelFYPJX4O9YBfHtIRXodwOMU3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tgrdWxtdEFjf0cEtDH+b/WTPMQh/HuCjY2inNVVEdq3JhfiCB6pUjaEOmxrOIlP9I
         9rj6vkB9GFOgFTuHtxmY0+Dvg0wdsBAKr/J0KNPnSFVcpp74eEU1v5DcwhoZlG7sEk
         90oIMGs9Tt53R+FlMcAWz8kjBwWUUowcwfiBf170=
Date:   Thu, 20 Feb 2020 12:36:18 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>, Feifei Xu <Feifei.Xu@amd.com>,
        xinhui pan <xinhui.pan@amd.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH AUTOSEL 5.5 408/542] drm/amdgpu: add the lost mutex_init
 back
Message-ID: <20200220173618.GI1734@sasha-vm>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-408-sashal@kernel.org>
 <CADnq5_MMLNtb=3LLHsYnXtONQf4NWNgV226w2=OFk3JpCRj3sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADnq5_MMLNtb=3LLHsYnXtONQf4NWNgV226w2=OFk3JpCRj3sA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 11:22:27AM -0500, Alex Deucher wrote:
>On Fri, Feb 14, 2020 at 10:57 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: "Pan, Xinhui" <Xinhui.Pan@amd.com>
>>
>> [ Upstream commit bd0522112332663e386df1b8642052463ea9b3b9 ]
>>
>> Initialize notifier_lock.
>>
>> Bug: https://gitlab.freedesktop.org/drm/amd/issues/1016
>> Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
>> Reviewed-by: Christian König <christian.koenig@amd.com>
>> Signed-off-by: xinhui pan <xinhui.pan@amd.com>
>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>> index 332b9c24a2cd0..a2f788ad7e1c6 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>> @@ -2797,6 +2797,7 @@ int amdgpu_device_init(struct amdgpu_device *adev,
>>         mutex_init(&adev->notifier_lock);
>>         mutex_init(&adev->virt.dpm_mutex);
>>         mutex_init(&adev->psp.mutex);
>> +       mutex_init(&adev->notifier_lock);
>>
>
>This patch is not relevant here.  The same mutex is already
>initialized 3 lines above.

Now dropped, thank you.

-- 
Thanks,
Sasha
