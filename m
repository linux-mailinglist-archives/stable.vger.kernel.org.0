Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C91441892A
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 15:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhIZN5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 09:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231772AbhIZN5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 09:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1684760EE4;
        Sun, 26 Sep 2021 13:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632664539;
        bh=B1YqoQhwhmLHHt1Y/Xa8AsmeMHhlkIS5XRMFHNxHvpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pFu6G1m5Sw56tWvnZBd4hIFVS/JWokEGdfKNeyYIZx7o3BFzw6oUAx6p6J8ydA90v
         T3oueeNLpW1ShRl6UK9LdVXpGn2cq85W7LL52w5DoXYJUVNZNRYI8goY5firvVCqwx
         4OPMqkdHX+Geb0cu3wsTyHKcPJNszZCY7FuhZLG4qQ+KwiIP1gJsjZBe5S5CePYIXd
         86Ua42zUvYyg+Y7DWbV8eHAw38hh7YEMfcMo/mm8gGNTv3+DJRcHSjC8+cQNS3AhGO
         s/34VRX+rlsn9ivHsHdQsIcFtx0wid714xg4MZIZ+KvIEU42qEEI1jXxpyXuYuphM3
         HDP0DZU35Ezgg==
Received: by pali.im (Postfix)
        id B613660D; Sun, 26 Sep 2021 15:55:36 +0200 (CEST)
Date:   Sun, 26 Sep 2021 15:55:36 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     kabel@kernel.org, lorenzo.pieralisi@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: aardvark: Increase polling delay to
 1.5s while waiting" failed to apply to 5.10-stable tree
Message-ID: <20210926135536.a6g2vxbnporfevvc@pali>
References: <16317166872028@kroah.com>
 <20210915165243.xaviyv4pwdmk6vhi@pali>
 <20210925214639.3fnbfc5eovd5bzqg@pali>
 <YVBlSNYjASqDizPG@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YVBlSNYjASqDizPG@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sunday 26 September 2021 14:19:20 Greg KH wrote:
> On Sat, Sep 25, 2021 at 11:46:39PM +0200, Pali Rohár wrote:
> > On Wednesday 15 September 2021 18:52:43 Pali Rohár wrote:
> > > On Wednesday 15 September 2021 16:38:07 gregkh@linuxfoundation.org wrote:
> > > > The patch below does not apply to the 5.10-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > 
> > > Hello! Below is backport for 5.10 (and probably it should apply also for
> > > older versions):
> > 
> > Hello Greg! Have you looked at this backport for 5.10?
> 
> Ick, I somehow missed this for 5.10.y, thanks for catching it.  I'll go
> queue it up now.

Ok!

Now I'm checking other aardvark patches and I found out that following
commits marked with Cc: stable tags are not included in 4.14 tree yet:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8ceeac307a79f68c0d0c72d6e48b82fa424204ec
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fcb461e2bc8b83b7eaca20cb2221e8b940f2189c

And this in 4.19 stable tree:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fcb461e2bc8b83b7eaca20cb2221e8b940f2189c

With merge.renamelimit = 24506 these commits applies cleanly for 4.14 /
4.19 stable trees. Could you look at it, why there are missing?
