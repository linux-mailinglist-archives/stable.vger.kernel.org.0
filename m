Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6130F5215F
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 05:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfFYDx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 23:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfFYDx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 23:53:27 -0400
Received: from localhost (unknown [116.226.249.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8B0620665;
        Tue, 25 Jun 2019 03:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561434806;
        bh=WdAQksep6/G3ADoK98f+wAGREBeKGTO+oUjDyKFdzhI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LY8ES9E+1etUoa9OPMc+panh2qCG8miOhtbRxxr9OeVCNbJpEVRVK+A1aa8UNuZ3M
         msEicCoNmHC5EA+p/sKZHpKrB/qREizhGj5EeDn7xjcihS0bvSWbc17dhHokARELoD
         Pnl+EDIZoHkN9Qlxn3m5YY+gIDHWJRng+JhRDnRA=
Date:   Tue, 25 Jun 2019 08:47:57 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-4.19
Message-ID: <20190625004757.GA8185@kroah.com>
References: <cki.81646CFC88.UKA4CPY12X@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.81646CFC88.UKA4CPY12X@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 24, 2019 at 07:32:52PM -0400, CKI Project wrote:
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 78778071092e - Linux 4.19.55
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: FAILED
> 
> 
> 
> 
> When we attempted to merge the patchset, we received an error:
> 
>   Patch is empty.

I'm all for reporting errors, but can you all figure out how to
determine the difference between your scripts failing as they pull at an
bad time, and a real problem?

thanks,

greg k-h
