Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3EB1166717
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 20:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgBTT04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 14:26:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:59656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728334AbgBTT04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 14:26:56 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA038208C4;
        Thu, 20 Feb 2020 19:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582226816;
        bh=u1DImfIcA/rN3QlVcHUZyq0IO0dkwkKvI3WbXn3NCho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vJ5dLSdSRVVkJEKYfZsSA0ycfYm0NRmTfjbVU5Sbl7D2xVMhn0rDdHost2I+6TH8U
         EfkeRIg6qtYWL9JH/ChhvqcvZfwZt3ozdTvLtEQda2/Ww48hQdAlB1IlgMDDmvCJJw
         wdZx2ma3SzQA1KOFzj4AizptXhTZYDa32DYaMVu8=
Date:   Thu, 20 Feb 2020 14:26:54 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>
Subject: Re: [PATCH AUTOSEL 5.5 530/542] drm/amdgpu/smu10: fix
 smu10_get_clock_by_type_with_voltage
Message-ID: <20200220192654.GJ1734@sasha-vm>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-530-sashal@kernel.org>
 <CADnq5_Oq-6VYYMWgvSbTcs5S6+DHP1K+ambo3Cd_BBkYFQk8HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CADnq5_Oq-6VYYMWgvSbTcs5S6+DHP1K+ambo3Cd_BBkYFQk8HQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 11:31:31AM -0500, Alex Deucher wrote:
>On Fri, Feb 14, 2020 at 11:00 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Alex Deucher <alexander.deucher@amd.com>
>>
>> [ Upstream commit 1064ad4aeef94f51ca230ac639a9e996fb7867a0 ]
>>
>> Cull out 0 clocks to avoid a warning in DC.
>>
>> Bug: https://gitlab.freedesktop.org/drm/amd/issues/963
>
>All of the upstream commits that reference this bug need to be applied
>or this patch set will be broken.  Please either apply them all or
>drop them.

Okay, so I have these 3 in 4.19-5.5:

c37243579d6c ("drm/amdgpu/display: handle multiple numbers of fclks in dcn_calcs.c (v2)")
4d0a72b66065 ("drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_latency")
1064ad4aeef9 ("drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_voltage"

-- 
Thanks,
Sasha
