Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22B8368167
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 15:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbhDVNYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 09:24:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236231AbhDVNYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Apr 2021 09:24:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74D92601FC;
        Thu, 22 Apr 2021 13:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619097825;
        bh=PimRmnoYIpXio3UO+VOxCaI2zmNGxX8GtLU76apIbdQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L3zxrlJiDyAL1tfhDht3fS0PWvyopCeas5h0U87P0v+dRGqQMAoZ6bEQBAcCMnVSr
         35ABHIqEN/EzdRZhEnHabS7827+xTyWzpG+rQFLFn7us23UloLh5oST+DL+auclBIl
         OEprH5i0OJ3aMc2V3VgcR+sw0dBDEJsOaPzZ5nfA=
Date:   Thu, 22 Apr 2021 15:23:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [resend] revert series of umn.edu commits for v5.11.y
Message-ID: <YIF43u7rY/eo7OCi@kroah.com>
References: <YICidTdSYPut4oVa@debian>
 <YIEVGXEoeizx6O1p@debian>
 <YIFjKbiZd9hUJmbQ@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIFjKbiZd9hUJmbQ@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 22, 2021 at 07:51:05AM -0400, Sasha Levin wrote:
> On Thu, Apr 22, 2021 at 07:18:01AM +0100, Sudip Mukherjee wrote:
> > Hi Greg,
> > 
> > Resending with individual attachments as the previous mail with all the
> > attachments (sent last night) did not appear in https://lore.kernel.org/stable.
> > 
> > This is based on the 190 commits that you posted for mainline. Out of
> > that 24 patches had a reply mail asking not to revert (till last night).
> > So, the attached series for stable is based on the remaining 166 commits.
> > I have borrowed the commit message from your series.
> 
> Let's wait with these until reverts are merged upstream, we don't want
> to diverge here.

I agree, I am going to wait until the reverts hit Linus's tree before
doing anything.  That is probably going to take a few weeks as I wade
through this mess...

greg k-h
