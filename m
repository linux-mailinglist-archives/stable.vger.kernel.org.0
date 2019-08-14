Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D218C5C4
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfHNCDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbfHNCDQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:03:16 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A913320844;
        Wed, 14 Aug 2019 02:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748195;
        bh=F8prTQ/k/b+W43RtabebnHqUglUVLPyMKRVC+/Nz7Vg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eavud9KM/G4Y+VFqXEPoGdZBJzeWlrvIthMYhHqb09rtfMoMACgIE31fqYVZF+vbf
         bc8w4XdnfQrKLMRWccc7tpnYpyqh/EKlV+8SI/ebkLpmUcljB0jOKE5ayulPdnnfuH
         iikw6fRZFnFVLg/jpOLTwgzIHEiolseBAdToHSxU=
Date:   Tue, 13 Aug 2019 22:03:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Rob Clark <robdclark@chromium.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Stephen Boyd <sboyd@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        freedreno <freedreno@lists.freedesktop.org>
Subject: Re: [PATCH AUTOSEL 5.2 42/76] drm/msm: stop abusing dma_map/unmap
 for cache
Message-ID: <20190814020314.GG17747@sasha-vm>
References: <20190802131951.11600-1-sashal@kernel.org>
 <20190802131951.11600-42-sashal@kernel.org>
 <CAJs_Fx4ddE-85uA3S+YLPat4uX8Mk9zRU2SFm2xmGgmAFWPEyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJs_Fx4ddE-85uA3S+YLPat4uX8Mk9zRU2SFm2xmGgmAFWPEyg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 05:14:35PM -0700, Rob Clark wrote:
>Hi Sasha,
>
>It's probably best *not* to backport this patch.. drm/msm abuses the
>DMA API in a way that it is not intended be used, to work around the
>lack of cache sync API exported to kernel modules on arm/arm64.  I
>couldn't really guarantee that this patch does the right thing on
>older versions of DMA API, so best to leave things as they were.

Now dropped, thank you.

--
Thanks,
Sasha
