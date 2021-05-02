Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF48370B38
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 13:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhEBLGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 07:06:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhEBLGG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 07:06:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07A936128C;
        Sun,  2 May 2021 11:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619953514;
        bh=T8UlhW6JWCBpXDIut8H1iErLE4ZfL6f/yp3Mc++OJhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r6kQsG3UWKsPQNxZ5uFj4nNlN75rJEpPqxa8ci55B9Ezsh/GrXCpMl0DiZv3p0RMT
         YYrus7M81y1GfP/CMGP4HXgsGSZaDaPCfqYnzYZIYpnfssxXBSevu3z9VDRronmGF1
         dRL+mqlzIb1krpiGxHy9nHxJvLTTzP+qzh4NutM8=
Date:   Sun, 2 May 2021 13:05:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Romain Naour <romain.naour@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: request for 4.14-stable to 5.12-stable: 1d7ba0165d82 ("mips: Do
 not include hi and lo in clobber list for R6")
Message-ID: <YI6HaLLlQFz1aqau@kroah.com>
References: <YIyKsnjERure9/UG@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIyKsnjERure9/UG@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 11:54:42PM +0100, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> The config malta_qemu_32r6_defconfig for mips fails to build for gcc-10+.
> Please apply 1d7ba0165d82 ("mips: Do not include hi and lo in clobber list for R6")
> to 4.14-stable to 5.12-stable branches.
> It will apply cleanly to 5.9-stable to 5.12-stable. I will send the backport
> for 4.14-stable, 4.19-stable and 5.4-stable.

It seems to apply cleanly to 5.4.y to me, but backports for the other
trees would be appreciated.

thanks,

greg k-h
