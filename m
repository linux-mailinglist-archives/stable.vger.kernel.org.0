Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C085365AF0
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 16:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhDTOMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 10:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231758AbhDTOMR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 10:12:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B62A613B0;
        Tue, 20 Apr 2021 14:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618927905;
        bh=eYUfvlEmAaMRZ4eabJHaLpmEHUVXJM07EUXVkS0fcMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eBZZRV3BaVe0Hn+f1x9PmBS1VrODWyuE3wJA4XAKNbTqPVZBt+R+cqUEBpNS5MSI1
         vf6V589GVFFuQMQs1C/h3kctLjFlQnfLniXZPOgqtNryodfW606iSV9oEpRB24JZqm
         SeQznOIy2Yi6U6LhsYtVR46cnqDDl5Rvd1bDhS6r8H69b/3IZhfH5cKmuOAPzcle/Z
         ivGhJYtA5Q2wvSlLighj87Xl/tR5KYVZX0D0wTBWcwqFQi8DKS+UWuWixjd+6k2xHn
         vT+j2NRQBmcBH7M7YL0NmWOC0Y7Txn+FPMEpNR5MD8MmN36L+aZ5fPR4j+aU/ktK2B
         u6XZjPXfJHKzg==
Date:   Tue, 20 Apr 2021 10:11:44 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH AUTOSEL 5.4 13/14] gcov: clang: fix clang-11+ build
Message-ID: <YH7hIK+7ujuJaClU@sashalap>
References: <20210419204454.6601-1-sashal@kernel.org>
 <20210419204454.6601-13-sashal@kernel.org>
 <74494183e65ef549fc5596f314db43a8e792d2ff.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <74494183e65ef549fc5596f314db43a8e792d2ff.camel@sipsolutions.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 20, 2021 at 09:01:19AM +0200, Johannes Berg wrote:
>On Mon, 2021-04-19 at 20:44 +0000, Sasha Levin wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> [ Upstream commit 04c53de57cb6435738961dace8b1b71d3ecd3c39 ]
>>
>> With clang-11+, the code is broken due to my kvmalloc() conversion
>> (which predated the clang-11 support code) leaving one vmalloc() in
>> place.  Fix that.
>
>This patch might *apply* on 5.4 (and the other kernels you selected it
>for), but then I'm pretty sure it'll be broken, unless you also applied
>the various patches this was actually fixing (my kvmalloc conversion,
>and the clang-11 support).
>
>Also, Linus has (correctly) reverted this patch from mainline, it
>shouldn't have gone there in the first place, probably really should be
>squashed into my kvmalloc conversion patch that's in -mm now.
>
>Sorry if I didn't make that clear enough at the time.
>
>
>In any case, please drop this patch from all stable trees.

Will do, thanks!

-- 
Thanks,
Sasha
