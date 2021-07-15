Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E073C9E11
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 13:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbhGOMBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhGOMBs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 08:01:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41B206117A;
        Thu, 15 Jul 2021 11:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626350335;
        bh=RFWM/NJY5/Ou2ibLjHmCmzcNYGNZtzFI521J53C4PDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m36CN2copU8VfAGZAeulEX3fYQKTndMUi3FNGegGxpDNGnagZOF7j/8OBHY8qHqq7
         bj1pYZSJpzgw1Uyjq/4VJ8BIC1+ZIS9CBLHT+JkBbKewZL+wXx7JuVh2wcq/7mIJYu
         +1KgE9GVFjBqJWayttlE6fB/uDAIw5QDnZb8kMe4=
Date:   Thu, 15 Jul 2021 13:35:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     stable <stable@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 5.4.y stable only] MIPS: fix "mipsel-linux-ld:
 decompress.c:undefined reference to `memmove'"
Message-ID: <YPAdi8UOhyaw0eNT@kroah.com>
References: <YOglcE85xuwfD7It@kroah.com>
 <20210709132408.174206-1-hsiangkao@linux.alibaba.com>
 <YPATcUXGydBlQ+BK@kroah.com>
 <YPAaWOM1z75o21V1@B-P7TQMD6M-0146.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPAaWOM1z75o21V1@B-P7TQMD6M-0146.local>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 07:22:00PM +0800, Gao Xiang wrote:
> Hi Greg,
> 
> On Thu, Jul 15, 2021 at 12:52:33PM +0200, Greg Kroah-Hartman wrote:
> > On Fri, Jul 09, 2021 at 09:24:08PM +0800, Gao Xiang wrote:
> > > commit a510b616131f85215ba156ed67e5ed1c0701f80f upstream.
> > 
> > That is not what this commit id is :(
> > 
> > Please fix this up and be more careful.
> 
> That's the exact commit, the original upstream commit was named as
> "MIPS: Add support for ZSTD-compressed kernels", which contains the
> memmove() definition so the upstream / 5.10 LTS kernel is fine.
> 
> But for 5.4 LTS, we shouldn't backport the whole patch since only
> memmove() part is needed in order to fix the build regression...

That was not obvious, and is confusing :(

Please just submit the fix and say _why_ this is not an upstream commit,
do not attempt to emulate an upstream commit like your change did.

thanks,

greg k-h
