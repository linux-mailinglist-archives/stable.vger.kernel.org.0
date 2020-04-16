Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29FE1AB5F9
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 04:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388173AbgDPCiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 22:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388327AbgDPCiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 22:38:11 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6EC6206F9;
        Thu, 16 Apr 2020 02:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587004691;
        bh=m8QHjqIVseGe0Skoqdt+YHrABRW0bvMuqILcv0AgBRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uus5XovhpUwwZoX3D4kEembTt0NLEtFBcQKPdxIYS6qLGnZGdCGhNOtNVXpUQ4azo
         rXybf+WN5/3QG+xkfmb2+XIq4LcCX8W71u9fPCirKZFQSlGTTY2p8+y6xAFlncFtfe
         /rEeS4sqenRn8ra1pPv4sM71V115xpBu0D/TaBA0=
Date:   Wed, 15 Apr 2020 22:38:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     Prike.Liang@amd.com, Mengbing.Wang@amd.com,
        alexander.deucher@amd.com, ray.huang@amd.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: fix gfx hang during suspend
 with video playback" failed to apply to 5.6-stable tree
Message-ID: <20200416023809.GZ1068@sasha-vm>
References: <15869504681998@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15869504681998@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:34:28PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.6-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 487eca11a321ef33bcf4ca5adb3c0c4954db1b58 Mon Sep 17 00:00:00 2001
>From: Prike Liang <Prike.Liang@amd.com>
>Date: Tue, 7 Apr 2020 20:21:26 +0800
>Subject: [PATCH] drm/amdgpu: fix gfx hang during suspend with video playback
> (v2)
>
>The system will be hang up during S3 suspend because of SMU is pending
>for GC not respose the register CP_HQD_ACTIVE access request.This issue
>root cause of accessing the GC register under enter GFX CGGPG and can
>be fixed by disable GFX CGPG before perform suspend.
>
>v2: Use disable the GFX CGPG instead of RLC safe mode guard.
>
>Signed-off-by: Prike Liang <Prike.Liang@amd.com>
>Tested-by: Mengbing Wang <Mengbing.Wang@amd.com>
>Reviewed-by: Huang Rui <ray.huang@amd.com>
>Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>Cc: stable@vger.kernel.org

Conflict because of missing 9593f4d6a69b ("drm/amdkfd: refactor runtime
pm for baco"). Fixed and queued up.

-- 
Thanks,
Sasha
