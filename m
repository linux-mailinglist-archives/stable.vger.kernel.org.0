Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD3A18E3EA
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 20:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgCUTRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 15:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbgCUTRZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 15:17:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64B6020663;
        Sat, 21 Mar 2020 19:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584818245;
        bh=tkrHwIhsy2D7ro4IhRh1yy1L652d7Cg8jmD5KQlk+9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2bFWiqXwSUnyxUIcUhyRs2nkw+jvT1+7No4YmlOO98Kf/hCSnIAiuzFxRnGAHxKCt
         BBIAi/h0cAdPWPqj1teJX/2CPa9ZM3ZM+tYt9trqzYLfc6+it96Rt9EkTAYeTeAvfH
         fkbQfrKxM48DdDMOw/phMZHtriR/ewtuAGmBijaY=
Date:   Sat, 21 Mar 2020 20:17:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: Handling of patches missing in stable releases based on Fixes:
 tags
Message-ID: <20200321191722.GA4201@kroah.com>
References: <ea9275e1-728f-9b12-c787-7109985bf7c3@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea9275e1-728f-9b12-c787-7109985bf7c3@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 21, 2020 at 09:13:47AM -0700, Guenter Roeck wrote:
> Hi,
> 
> we now have a script that identifies patches in stable releases which were
> later fixed upstream, but the fix was not applied to the respective stable
> releases. We identify such patches based on Fixes: tags in the upstream
> kernel.

THat's great.

> Example: Upstream commit c54c7374ff4 ("drm/dp_mst: Skip validating ports
> during destruction, just ref") was applied to v4.4.y as commit 05d994f68019.
> It was later reverted upstream with commit 9765635b307, but the revert has
> (at least not yet) found its way into v4.4.y.
> 
> This is an easy example, where the revert should (or at least I think it
> should) be applied to v4.4.y (and possibly to later kernels - I didn't check).
> A more tricky patch is commit 3ef240eaff36 ("futex: Prevent exit livelock")
> in v5.4.y, which was later fixed upstream with commit 51bfb1d11d6 ("futex:
> Fix kernel-doc notation warning"). I am not entirely sure what to do with
> that, given that it only fixes documentation (though that may of course also
> be valuable).
> 
> How should we handle this ? Would it be ok to send half-automated requests
> to the stable mailing list, for example with basic test results ?

Sure, half-automated requests are fine, send them on!

thanks,

greg k-h
