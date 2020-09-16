Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FF026B7E4
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgIPAbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:31:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727176AbgIPAbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 20:31:20 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE25F20739;
        Wed, 16 Sep 2020 00:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600216279;
        bh=dYoe6uIsk8p/WBGtB6mGYFHVptzfKKSycmXz7RalSEM=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=DvVkryFX3mWNs7za2TmpfGEZWinva3YSjp9NZQDgcV2+TsvnERxUJfpd0NHl98GpC
         9MgyleOy9G1UmJBdj73/LpSjpdgM6WEZU3hmpAcR7uSFIskeu0/RI/jHVk5LSnX88G
         +BFfWr5H1ZmcB+yZV6s4na7hEVXGLw6YJdFF3Vzs=
Date:   Tue, 15 Sep 2020 20:31:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        ben.hutchings@codethink.co.uk, stable@vger.kernel.org,
        pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Jonathan Marek <jonathan@marek.ca>
Subject: Re: [PATCH 5.4 000/130] 5.4.66-rc2 review
Message-ID: <20200916003117.GF2431@sasha-vm>
References: <20200915164455.372746145@linuxfoundation.org>
 <20200915201732.4474qpgnxwshanpw@nuc.therub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200915201732.4474qpgnxwshanpw@nuc.therub.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 03:17:32PM -0500, Dan Rue wrote:
>On Tue, Sep 15, 2020 at 06:45:55PM +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.4.66 release.
>> There are 130 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 17 Sep 2020 16:44:19 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.66-rc2.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>> -------------
>> Pseudo-Shortlog of commits:
>>
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>     Linux 5.4.66-rc2
>>
>> Jordan Crouse <jcrouse@codeaurora.org>
>>     drm/msm: Disable the RPTR shadow
>>
>> Jonathan Marek <jonathan@marek.ca>
>>     drm/msm/a6xx: update a6xx_hw_init for A640 and A650
>
>This one ("drm/msm/a6xx: update a6xx_hw_init for A640 and A650") is
>still causing builds to fail on arm and arm64.

I've dropped it, thanks!

-- 
Thanks,
Sasha
