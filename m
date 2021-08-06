Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A113E2353
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 08:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243355AbhHFGhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 02:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhHFGhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 02:37:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8632E611C5;
        Fri,  6 Aug 2021 06:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628231850;
        bh=2sjiAyYo1Ehoo7KqMTtuA0e0ySN6zjTZx7qwVQKTNYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uIJ2tKraNFi4WTCD34KnXSUw9G6pjWTxfhRudYi+9/ouCWUNBV4xN+gIyMpTQLgcw
         E6Nxw/Jg9Wb1DaxpFpJD6Bd1w/btZfJq4dnFiUyhjiAwR5VTrxQBh2iaEb2i/zfkWP
         0e4MomDO6JFc+iw1RVS6ndEKudaV05Ka4TIRnIck=
Date:   Fri, 6 Aug 2021 08:37:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexander.deucher@amd.com>
Cc:     stable@vger.kernel.org, Stylon Wang <stylon.wang@amd.com>
Subject: Re: [RESEND PATCH] drm/amd/display: Fix ASSR regression on embedded
 panels
Message-ID: <YQzYpyYCCSjvjo6t@kroah.com>
References: <20210804164443.3279339-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804164443.3279339-1-alexander.deucher@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 04, 2021 at 12:44:43PM -0400, Alex Deucher wrote:
> From: Stylon Wang <stylon.wang@amd.com>
> 
> [Why]
> Regression found in some embedded panels traces back to the earliest
> upstreamed ASSR patch. The changed code flow are causing problems
> with some panels.
> 
> [How]
> - Change ASSR enabling code while preserving original code flow
>   as much as possible
> - Simplify the code on guarding with internal display flag
> 
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=213779
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1620
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Stylon Wang <stylon.wang@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org
> (cherry picked from commit 6be50f5d83adc9541de3d5be26e968182b5ac150)
> ---
> 
> This is a backport of this patch to 5.13.  I originally sent this
> out as a follow up to the reply that the original patch failed to
> apply to 5.13, but it hasn't been applied yet.  Resending to make
> sure it didn't get lost.

Not lost, just not caught up on yet.  Now queued up, thanks.

greg k-h
