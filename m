Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0852042C4
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 23:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgFVVgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 17:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgFVVgE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 17:36:04 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B327A2075A;
        Mon, 22 Jun 2020 21:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592861764;
        bh=xJuJTCcvLk7qfBU+5o6QQjD4r67q59Mp4wTQ0KmFO4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OhPUi4a/eJHPzvHyHATRraW2xMtf467FxoBrgAXaCDzuxHtsf/bnJrF5jVagzsozu
         /j8brfW4+IgGaf6gXutZMaSR+lX0fk6R8v/BoP1AGyUJOYzMW/Hk5mDkkyyyXsYRfp
         kkiMnd/B2OlAajRIx+B7WdwYEtiXWVx0iHR49kI0=
Date:   Mon, 22 Jun 2020 17:36:02 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     alexander.deucher@amd.com, nicholas.kazlauskas@amd.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amdgpu/display: use blanked rather
 than plane state for" failed to apply to 5.4-stable tree
Message-ID: <20200622213602.GL1931@sasha-vm>
References: <15928491981887@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15928491981887@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 08:06:38PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
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
>From b7f839d292948142eaab77cedd031aad0bfec872 Mon Sep 17 00:00:00 2001
>From: Alex Deucher <alexander.deucher@amd.com>
>Date: Tue, 2 Jun 2020 17:22:48 -0400
>Subject: [PATCH] drm/amdgpu/display: use blanked rather than plane state for
> sync groups
>
>We may end up with no planes set yet, depending on the ordering, but we
>should have the proper blanking state which is either handled by either
>DPG or TG depending on the hardware generation.  Check both to determine
>the proper blanked state.
>
>Bug: https://gitlab.freedesktop.org/drm/amd/issues/781
>Fixes: 5fc0cbfad45648 ("drm/amd/display: determine if a pipe is synced by plane state")
>Cc: nicholas.kazlauskas@amd.com
>Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
>Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>Cc: stable@vger.kernel.org

I've grabbed 34b86b75dfc9 ("drm/amd/display: Use swap() where appropriate") as
a dependency and queued both for 5.4.

-- 
Thanks,
Sasha
