Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11F62E7A61
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 16:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgL3Pfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 10:35:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:43364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbgL3Pfh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 10:35:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A416821D94;
        Wed, 30 Dec 2020 15:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609342497;
        bh=hK5gFDiN91NDmOwjfEfljYy2aVJO0tHLby8ILY+u7rg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RrONJR8jnyNhCfUarq0SMfsIDheVHUOal5u6qac/Mx35ybDMWWYzF0LyFrJ1+8bqn
         eN+6x7AmcWkwY4689DjZQ0C3UwfR9Abh649zFusdCgGITnsb3mlhb+RS0L8NhQzUUx
         Q2i/sTMMemazSHE96bCicqNkg3CLq/ODkeKXhR5U=
Date:   Wed, 30 Dec 2020 16:36:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Labisch <clnetbox@gmail.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sound
Message-ID: <X+yedztHPUK4Qryc@kroah.com>
References: <d1b1e6b0e3af13f3756a34131ffb84df6a209ee0.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1b1e6b0e3af13f3756a34131ffb84df6a209ee0.camel@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 30, 2020 at 04:26:00PM +0100, Christian Labisch wrote:
> Hello !
> 
> I could need your help ... I have tested the new kernel 5.10.3 and sound doesn't work with this
> version.
> Seems the new Intel audio drivers are the main reason. What can be done ? Do you have any ideas ?
> 
> Intel Catpt driver support is new ... This deprecates the previous Haswell SoC audio driver code
> previously providing the audio capabilities.
> And I am having a Haswell CPU -> Audio device: Intel Corporation Xeon E3-1200 v3/4th Gen Core
> Processor HD Audio Controller (rev 06)

Can you try 5.10.4?  I think a fix for this is in there as was reported
by another user yesterday.

If not, can you run 'git bisect' on the kernels between the last good
one that worked for you, and the one that doesn't?

thanks,

greg k-h
