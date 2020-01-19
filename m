Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1797141F03
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 17:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgASQSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 11:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgASQSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Jan 2020 11:18:32 -0500
Received: from localhost (96-81-74-198-static.hfc.comcastbusiness.net [96.81.74.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A1CC20678;
        Sun, 19 Jan 2020 16:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579450711;
        bh=hY9FwnMFMFgf6V5eLGqawC5g8WNmBT7/sbVwOeHFkSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m22aK3ELcyshomuCLQYRmxLdxdJZI2tEqa7pAtE/h+L9WSZ2uQkhKKQBk+bINkI15
         2EBk+wj0+KXiRSFLN1FMwBZN9eKR60Qj6Zp41YYXsqxcbxWXMjAWlkOrwjEodmj++m
         VmEzdvHupS3tNfJ/MTf+k3/JkkoFUiMBI5ZL18Vs=
Date:   Sun, 19 Jan 2020 11:18:30 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     mario.kleiner.de@gmail.com, alexander.deucher@amd.com,
        harry.wentland@amd.com, martin.leung@amd.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amd/display: Reorder
 detect_edp_sink_caps before link" failed to apply to 5.4-stable tree
Message-ID: <20200119161829.GT1706@sasha-vm>
References: <157944472417561@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157944472417561@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 19, 2020 at 03:38:44PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 3b7c59754cc22760760a84ebddb8e0b1e8dd871b Mon Sep 17 00:00:00 2001
>From: Mario Kleiner <mario.kleiner.de@gmail.com>
>Date: Thu, 9 Jan 2020 16:20:27 +0100
>Subject: [PATCH] drm/amd/display: Reorder detect_edp_sink_caps before link
> settings read.
>
>read_current_link_settings_on_detect() on eDP 1.4+ may use the
>edp_supported_link_rates table which is set up by
>detect_edp_sink_caps(), so that function needs to be called first.
>
>Reviewed-by: Harry Wentland <harry.wentland@amd.com>
>Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
>Cc: Martin Leung <martin.leung@amd.com>
>Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>Cc: stable@vger.kernel.org

Context conflicts due to missing 7f7652ee8c8c ("drm/amd/display: enable
single dp seamless boot"). Fixed up and queued for 5.4 and 4.19.

-- 
Thanks,
Sasha
