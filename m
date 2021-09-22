Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA3E414D87
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 17:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhIVP4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 11:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230480AbhIVP4G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 11:56:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C45316112F;
        Wed, 22 Sep 2021 15:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632326076;
        bh=v+v5IcOhSWgfkpnLsJPE0jXo2Oi5jjX0K+aTyZupcTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EYlA7TBYrtU2VGrPBJJK+eCtY0GXNXxL8qH9M+WHt7mLh4xjujMBzK+qnk1iyhgyV
         FeQ+swSMkN5YS4KksoUBfviAs6J15zZABitx6Gfl+bK0tVMJO+Innf7bH809Kb9eZ8
         HNhHyMlmL/DF1y0g8ZHMdVlLOQkzD0xYijRA1WvY=
Date:   Wed, 22 Sep 2021 17:54:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     lorenzo.pieralisi@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: aardvark: Fix reporting CRS value"
 failed to apply to 5.14-stable tree
Message-ID: <YUtRuTF+pglF9R84@kroah.com>
References: <16317162038625@kroah.com>
 <20210915164643.wuvqooapjccdc2nd@pali>
 <YUtAmk46bRf/qO2i@kroah.com>
 <20210922150333.3p7jjaz7fqt6ovwh@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210922150333.3p7jjaz7fqt6ovwh@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 22, 2021 at 05:03:33PM +0200, Pali Rohár wrote:
> On Wednesday 22 September 2021 16:41:30 Greg KH wrote:
> > On Wed, Sep 15, 2021 at 06:46:43PM +0200, Pali Rohár wrote:
> > > On Wednesday 15 September 2021 16:30:03 gregkh@linuxfoundation.org wrote:
> > > > The patch below does not apply to the 5.14-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > 
> > > Hello that patch depends on commit which fixes name of rootcap member:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e902bb7c24a7099d0eb0eb4cba06f2d91e9299f3
> > 
> > Thanks, that worked for 5.10 and 5.14, but not for 5.4.y.  If this needs
> > to go there too, can you send a working set of backported patches?
> 
> Hello Greg!
> 
> Applying patches in this order passes:
> 
> git cherry-pick e0d9d30b73548fbfe5c024ed630169bdc9a08aee
> git cherry-pick b1bd5714472cc72e14409f5659b154c765a76c65
> git cherry-pick e902bb7c24a7099d0eb0eb4cba06f2d91e9299f3
> git cherry-pick 43f5c77bcbd27cce70bf33c2b86d6726ce95dd66
> 
> First patch fixes big endian support in driver code and second patch
> fixes filling return value of function call on error (return value is
> passed via pointer argument). I do not know why they do not have
> appropriate Fixes tag, but for me it looks like that both patches are
> suitable for stable backporting.
> 
> What do you think, are first two patches suitable for backport? Or do
> you need some other solution?

Looks good to me, thanks for these, all now queued up!

greg k-h
