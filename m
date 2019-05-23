Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2C327971
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 11:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfEWJkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 05:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbfEWJkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 05:40:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FD212070D;
        Thu, 23 May 2019 09:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558604407;
        bh=nBtq/9urstmaZab9WmDG5ELma1BhW4UrNA/Tid+Cg+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KedPjCAct0A/2w0I/bbf7S4FRmb7Tk5C5Jh4O/RFXnh9uB0pqbsUX4Zyk+EGzmlE2
         WLBWtYFtrZYy1sYCNyjxVMvfIgFQ3f9c5BTXCX0RqhW1ZnpPBstfpnApklccVWyNAd
         70N4rOd9vRWGi5xZsf7BJJKkAAT6o9sA8Hnqls9E=
Date:   Thu, 23 May 2019 11:40:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-4.19
Message-ID: <20190523094005.GA27622@kroah.com>
References: <cki.37177F7312.Q0D4LFFA7N@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.37177F7312.Q0D4LFFA7N@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 05:33:03AM -0400, CKI Project wrote:
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: c3a072597748 - Linux 4.19.45
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: FAILED
> 
> 
> When we attempted to merge the patchset, we received an error:
> 
>   error: patch failed: drivers/md/md.c:9227
>   error: drivers/md/md.c: patch does not apply
>   hint: Use 'git am --show-current-patch' to see the failed patch
>   Applying: md: add a missing endianness conversion in check_sb_changes
>   Patch failed at 0001 md: add a missing endianness conversion in check_sb_changes

My fault, this should be dropped, my build scripts don't error out, they
just ignore this type of problem.  I should fix that...

I'll go fix this now, thanks.

greg k-h

