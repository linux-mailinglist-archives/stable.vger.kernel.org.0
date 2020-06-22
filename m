Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929A0204318
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 23:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbgFVV6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 17:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730926AbgFVV6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 17:58:41 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C99802076A;
        Mon, 22 Jun 2020 21:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592863121;
        bh=iyyyLD5G17mwT26ZXa1mpYmmM5k5JWcqkMBwxhN+ALQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aFXcrJDdf9VTSXJy7bWCh+2Zp4USn50oodQ0vwfrbyzPEfFUChX3F0KPOcU3bQgGF
         cLOiZaiHgv+sVcONHyDDLocKY/qHVT+HcSBj/6NnmLtylf/FrFW3vFcGi1tvssn703
         wRSKtP6b3y7qDfsxJURD4Ezd2w713ZC9ubuI9iXE=
Date:   Mon, 22 Jun 2020 17:58:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     alexander.deucher@amd.com, nicholas.kazlauskas@amd.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amdgpu/display: use blanked rather
 than plane state for" failed to apply to 5.4-stable tree
Message-ID: <20200622215839.GN1931@sasha-vm>
References: <15928491981887@kroah.com>
 <20200622213602.GL1931@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200622213602.GL1931@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 05:36:02PM -0400, Sasha Levin wrote:
>On Mon, Jun 22, 2020 at 08:06:38PM +0200, gregkh@linuxfoundation.org wrote:
>>
>>The patch below does not apply to the 5.4-stable tree.
>>If someone wants it applied there, or to any other stable or longterm
>>tree, then please email the backport, including the original git commit
>>id to <stable@vger.kernel.org>.
>>
>>thanks,
>>
>>greg k-h
>>
>>------------------ original commit in Linus's tree ------------------
>>
>>From b7f839d292948142eaab77cedd031aad0bfec872 Mon Sep 17 00:00:00 2001
>>From: Alex Deucher <alexander.deucher@amd.com>
>>Date: Tue, 2 Jun 2020 17:22:48 -0400
>>Subject: [PATCH] drm/amdgpu/display: use blanked rather than plane state for
>>sync groups
>>
>>We may end up with no planes set yet, depending on the ordering, but we
>>should have the proper blanking state which is either handled by either
>>DPG or TG depending on the hardware generation.  Check both to determine
>>the proper blanked state.
>>
>>Bug: https://gitlab.freedesktop.org/drm/amd/issues/781
>>Fixes: 5fc0cbfad45648 ("drm/amd/display: determine if a pipe is synced by plane state")
>>Cc: nicholas.kazlauskas@amd.com
>>Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
>>Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>>Cc: stable@vger.kernel.org
>
>I've grabbed 34b86b75dfc9 ("drm/amd/display: Use swap() where appropriate") as
>a dependency and queued both for 5.4.

Nevermind, looks like it also depends on functionality from eb7a74a36c24
("drm/amd/display: Add DCN2 OPP").

-- 
Thanks,
Sasha
