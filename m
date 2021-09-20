Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CA84118A9
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 17:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhITP4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 11:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231184AbhITP4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 11:56:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A97FE60F58;
        Mon, 20 Sep 2021 15:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632153310;
        bh=mlv+xGDcFvaytERU4zMjINm/KlQwqgRMg3KVx149M44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ly69LuxwUDJwvwokPZSVxrEASP9nLbyGXNLdeoMB9RKg/9RZHN5xGr2RpTOUJ7umJ
         PmXqfHhOWX9kK9z5lYUTVQSM2u68b/WUD+U1JtEacX4AJzyrl7HwLtPgQApHqRvmJ6
         MIkkU/Te1Z8aeYJ0oaA/MZVNwEsySvX0HGxViksM=
Date:   Mon, 20 Sep 2021 17:55:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wei Liu <wei.liu@kernel.org>
Cc:     mikelley@microsoft.com, torvalds@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/hyperv: remove on-stack cpumask from"
 failed to apply to 5.14-stable tree
Message-ID: <YUiu3KYIVycHS9CB@kroah.com>
References: <1632128215208163@kroah.com>
 <20210920154447.gess7eb3qho6s2ax@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920154447.gess7eb3qho6s2ax@liuwe-devbox-debian-v2>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 03:44:47PM +0000, Wei Liu wrote:
> Hi Greg,
> 
> On Mon, Sep 20, 2021 at 10:56:55AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> There is one prerequisite patch for this patch.  I can backport both to
> all relevant stable branches, but I would like to know how you would
> like to receive backport patches. Several git bundles to stable@?
> Several two-patch series to stable@? I can also give you several tags /
> branches to pull from if you like.

If they cherry-pick cleanly, just the git ids are all we need.

Otherwise a patch series is great, git bundles are only a last-resort.

thanks,

greg k-h
