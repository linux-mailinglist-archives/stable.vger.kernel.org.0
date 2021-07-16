Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D9C3CB784
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 14:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhGPMxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 08:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232803AbhGPMxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 08:53:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE1E6613F2;
        Fri, 16 Jul 2021 12:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626439856;
        bh=f5n1K0mFr3KGE4uLLcmzbieneKDB1GC/uHgiliqHzuI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N0Getapco/f1FRRHD90VyIkaUGA1ypXJnxiKB62OTTZmoRf3MR/nsGHs4hakrxnyN
         E/Ldv46ybP2xEBzS0gMR9VjpwbGPwa9nhenKMwzy1PjSJJKOK2wFZcIDt1NNg0rbM9
         RamliJCABh6ozbNYyDZdBI74czR23irDmvTbZ6fA=
Date:   Fri, 16 Jul 2021 14:50:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Werner Sembach <wse@tuxedocomputers.com>
Cc:     kernel-team@lists.ubuntu.com,
        Mario Limonciello <mario.limonciello@amd.com>,
        Prike Liang <Prike.Liang@amd.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [SRU][H][PATCH v2 1/1] usb: pci-quirks: disable D3cold on xhci
 suspend for s2idle on AMD Renoir
Message-ID: <YPGAq1zdem2QVTsb@kroah.com>
References: <20210716104010.4889-1-wse@tuxedocomputers.com>
 <20210716104010.4889-2-wse@tuxedocomputers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716104010.4889-2-wse@tuxedocomputers.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 12:40:10PM +0200, Werner Sembach wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> BugLink: https://bugs.launchpad.net/bugs/1936583
> 
> The XHCI controller is required to enter D3hot rather than D3cold for AMD
> s2idle on this hardware generation.
> 
> Otherwise, the 'Controller Not Ready' (CNR) bit is not being cleared by
> host in resume and eventually this results in xhci resume failures during
> the s2idle wakeup.
> 
> Link: https://lore.kernel.org/linux-usb/1612527609-7053-1-git-send-email-Prike.Liang@amd.com/
> Suggested-by: Prike Liang <Prike.Liang@amd.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> Cc: stable <stable@vger.kernel.org> # 5.11+
> Link: https://lore.kernel.org/r/20210527154534.8900-1-mario.limonciello@amd.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> (cherry picked from commit d1658268e43980c071dbffc3d894f6f6c4b6732a)
> Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
> ---
>  drivers/usb/host/xhci-pci.c | 7 ++++++-
>  drivers/usb/host/xhci.h     | 1 +
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 

Any reason you resent us a patch that is already in a stable release?

And why not just use the stable kernel trees as-is?  Why attempt to
cherry-pick random portions of them?

thanks,

greg k-h
