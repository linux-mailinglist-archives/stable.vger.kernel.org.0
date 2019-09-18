Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B55C5B64CE
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 15:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbfIRNjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 09:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730308AbfIRNjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 09:39:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A394721927;
        Wed, 18 Sep 2019 13:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568813960;
        bh=Jo2Q3eLwLLOVPAG7qagoTwLMte9kxxS4Rgq7e1yQwqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MXGavJj5LJor5X9x8pyJlovjnDv4m8q0CeOQ+UW58h3r3F308FQHGOMbHRi4AMOiM
         dxi+uriEuVnmz4bWe77ShOgzd5MzmjIlP+B+T5+eGyRithFDtHJQHj0nCqYIDGcM9e
         kT7HjeaohCtcrjVng+W22QHmiMAvmD+Pw1xW55WM=
Date:   Wed, 18 Sep 2019 15:39:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: Re: [PATCH v4.4] ARC: configs: Remove CONFIG_INITRAMFS_SOURCE from
 defconfigs
Message-ID: <20190918133917.GE1908968@kroah.com>
References: <20190918133423.17639-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918133423.17639-1-linux@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 06:34:23AM -0700, Guenter Roeck wrote:
> From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
> 
> commit 64234961c145606b36eaa82c47b11be842b21049 upstream.
> 
> We used to have pre-set CONFIG_INITRAMFS_SOURCE with local path
> to intramfs in ARC defconfigs. This was quite convenient for
> in-house development but not that convenient for newcomers
> who obviusly don't have folders like "arc_initramfs" next to
> the Linux source tree. Which leads to quite surprising failure
> of defconfig building:
> ------------------------------->8-----------------------------
>   ../scripts/gen_initramfs_list.sh: Cannot open '../../arc_initramfs_hs/'
> ../usr/Makefile:57: recipe for target 'usr/initramfs_data.cpio.gz' failed
> make[2]: *** [usr/initramfs_data.cpio.gz] Error 1
> ------------------------------->8-----------------------------
> 
> So now when more and more people start to deal with our defconfigs
> let's make their life easier with removal of CONFIG_INITRAMFS_SOURCE.
> 
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> Cc: Kevin Hilman <khilman@baylibre.com>
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> [backport: Fix context conflicts, drop non-existing configuration files]
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> This patch fixes various build errors observed at kernelci.

Now queued up, thanks!

greg k-h
