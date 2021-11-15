Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC734508DB
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 16:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236728AbhKOPs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 10:48:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236577AbhKOPsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 10:48:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EE8F610CA;
        Mon, 15 Nov 2021 15:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636991158;
        bh=jP/73MGAVW3Fz/kknJhdLjRgzGxgC4xHoDArMyHNhLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KdP1XBN4eVeOSdOVwCjkiKIup/O+R8CDeQubCBNudYfConmhitX396Eu/vtJ0d1oO
         IMvV3yhh/0WJmXi11mqYnFjISmPus+iGfW8e1dlPIy7w6G76WAbS5vpdnvgzPQb+RO
         lsVFqC66+HY0BcUdInXaa/kO1f5tvV/k1SKOjP5M=
Date:   Mon, 15 Nov 2021 16:45:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH v2] drm/amd/display: Look at firmware version to
 determine using dmub on dcn21
Message-ID: <YZKAs1rxuonK64kN@kroah.com>
References: <20211115153655.4870-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115153655.4870-1-mario.limonciello@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 09:36:55AM -0600, Mario Limonciello wrote:
> commit 91adec9e0709 ("drm/amd/display: Look at firmware version to
> determine using dmub on dcn21")
> 
> Newer DMUB firmware on Renoir and Green Sardine do not need to disable
> dmcu and this actually causes problems with DP-C alt mode for a number of
> machines.
> 
> Backport the fix from this from hand modified backport because mainline
> switched to IP version checking which doesn't exist in linux-stable.
> 
> BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1772
> BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1735
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> ---
> Changes from v1->v2:
>  * Update commit message syntax for hand modified commit
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

What tree(s) are you wanting this backported to?

thanks,

greg k-h
