Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9BD15FB3C
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 01:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgBNX7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 18:59:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727935AbgBNX7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 18:59:51 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 039B2206B6;
        Fri, 14 Feb 2020 23:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581724791;
        bh=kdcvtJLmnTtzWUQS0+tFQbmbizzUANyG9omQMu4DSRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=raLSWtEZHlFlaXAJTM8RqjpN+mb5UJy42NT1cOjfH8kY9ByeF2ZLivS+3qfWn8S9q
         QZJEkNTe/0RXnJJI8sUxzmXpTLb0DbZPpn5i+ONXTK7FNmWA5EMb4rJh5GzSaG2AZf
         Qf0F5A52NVjAD/3qlr5/TB+G9r9XeaIed7r6V9SM=
Date:   Fri, 14 Feb 2020 18:59:49 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 5.5 155/542] drm/amdkfd: remove set but not used
 variable 'top_dev'
Message-ID: <20200214235949.GG1734@sasha-vm>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-155-sashal@kernel.org>
 <20200214214429.GA4193448@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200214214429.GA4193448@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 04:44:29PM -0500, Greg KH wrote:
>On Fri, Feb 14, 2020 at 10:42:27AM -0500, Sasha Levin wrote:
>> From: zhengbin <zhengbin13@huawei.com>
>>
>> [ Upstream commit d191bd678153307573d615bb42da4fcca19fe477 ]
>>
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> drivers/gpu/drm/amd/amdkfd/kfd_iommu.c: In function kfd_iommu_device_init:
>> drivers/gpu/drm/amd/amdkfd/kfd_iommu.c:65:30: warning: variable top_dev set but not used [-Wunused-but-set-variable]
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Fixes: 1ae99eab34f9 ("drm/amdkfd: Initialize HSA_CAP_ATS_PRESENT capability in topology codes")
>> Signed-off-by: zhengbin <zhengbin13@huawei.com>
>> Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
>> Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/gpu/drm/amd/amdkfd/kfd_iommu.c | 3 ---
>>  1 file changed, 3 deletions(-)
>
>Unless all of these "unused bt set variable" patches are needed for
>"real" fixes, there's no need to add them here as we are NOT building
>the kernel with that option enabled any time soon from what I can tell.
>
>So you can drop a ton of these patches from all of these AUTOSEL
>branches please.

Sigh, I confused the -Wno-unused-but-set-variable flag we pass in the
makefile with -Wunused-but-set-variable. Sorry about all this noise,
I'll drop it.

-- 
Thanks,
Sasha
