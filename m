Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C5041896C
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 16:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhIZO1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 10:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhIZO1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 10:27:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 555F960FDC;
        Sun, 26 Sep 2021 14:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632666370;
        bh=ahsTWpfARJ1aLT6nZVhxv4ljEjyq5pizx6nT7rPRMRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h2Doj7CMYTGYBtIXKVrUoPk09sHSs9I8AmSqZwDf9L2X04LztcWost1pbf9cGZr3E
         rPuC2mA8zz2XHZPrGmE5Petj6aF7/WOJQClXkNgFIWgSgrS+j3hbQnSlpZeUXPdzJf
         uXC1sIc0S6gEf4lKhUCbQ9T/X3XI34zetEwmqdH8QPjQMlyq3Fb9sDv1FjlfS4V+P/
         PaAbMxjHnLRqh6XCxHvExilA5ejzSs3mioMukVGnJR32mAknboKrZRfUzM2st7bB5Z
         zGih6kHQUrz1E8nmJSo+IMf6iDuQL2CGK/owCYu50dczWpS+o6X4hVTUJGrhBdYy5A
         VPVf4sTzvN8cA==
Received: by pali.im (Postfix)
        id 49F5460D; Sun, 26 Sep 2021 16:26:08 +0200 (CEST)
Date:   Sun, 26 Sep 2021 16:26:08 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     kabel@kernel.org, lorenzo.pieralisi@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: aardvark: Increase polling delay to
 1.5s while waiting" failed to apply to 5.10-stable tree
Message-ID: <20210926142608.24j5woctzbrfuiso@pali>
References: <16317166872028@kroah.com>
 <20210915165243.xaviyv4pwdmk6vhi@pali>
 <20210925214639.3fnbfc5eovd5bzqg@pali>
 <YVBlSNYjASqDizPG@kroah.com>
 <20210926135536.a6g2vxbnporfevvc@pali>
 <YVB+tgg0Dzx/U+Gy@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YVB+tgg0Dzx/U+Gy@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sunday 26 September 2021 16:07:50 Greg KH wrote:
> On Sun, Sep 26, 2021 at 03:55:36PM +0200, Pali Rohár wrote:
> > On Sunday 26 September 2021 14:19:20 Greg KH wrote:
> > > On Sat, Sep 25, 2021 at 11:46:39PM +0200, Pali Rohár wrote:
> > > > On Wednesday 15 September 2021 18:52:43 Pali Rohár wrote:
> > > > > On Wednesday 15 September 2021 16:38:07 gregkh@linuxfoundation.org wrote:
> > > > > > The patch below does not apply to the 5.10-stable tree.
> > > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > > tree, then please email the backport, including the original git commit
> > > > > > id to <stable@vger.kernel.org>.
> > > > > 
> > > > > Hello! Below is backport for 5.10 (and probably it should apply also for
> > > > > older versions):
> > > > 
> > > > Hello Greg! Have you looked at this backport for 5.10?
> > > 
> > > Ick, I somehow missed this for 5.10.y, thanks for catching it.  I'll go
> > > queue it up now.
> > 
> > Ok!
> > 
> > Now I'm checking other aardvark patches and I found out that following
> > commits marked with Cc: stable tags are not included in 4.14 tree yet:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8ceeac307a79f68c0d0c72d6e48b82fa424204ec
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fcb461e2bc8b83b7eaca20cb2221e8b940f2189c
> > 
> > And this in 4.19 stable tree:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fcb461e2bc8b83b7eaca20cb2221e8b940f2189c
> > 
> > With merge.renamelimit = 24506 these commits applies cleanly for 4.14 /
> > 4.19 stable trees. Could you look at it, why there are missing?
> 
> They are missing because I do not use renames when applying patches like
> this (we use quilt for the patch queue).
> 
> If you can send the updated patches, I will be glad to queue them up.

Ok. Now I have sent them to stable list.

> thanks,
> 
> greg k-h
