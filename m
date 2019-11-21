Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5C2105B2C
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 21:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfKUUem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 15:34:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:48336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbfKUUem (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 15:34:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07BFE2067D;
        Thu, 21 Nov 2019 20:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574368481;
        bh=1pMN6bXWdJEGAAJywuLJPmySDy//QQ5YqVE75AIAWv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A9wz4fAMaUqfMVlwGFXjhu6iRdbuiZU0oxvfi/nuIXokZ6Na0EUFQ/MBDg3LZsTbT
         4n0eD8BA/QWRjFqE7ofNZkU5SUwcfaRMI+i8Jgr/XfdxG4QzNUp1gU257IsLlz1x2G
         Pd35GsCaoY6Qgqyuz78fuEjKNQigaTFn0aRGO3mg=
Date:   Thu, 21 Nov 2019 21:34:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vinayak Menon <vinmenon@codeaurora.org>
Cc:     akpm@linux-foundation.org, hughd@google.com, mhocko@suse.com,
        minchan@google.com, minchan@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm/page_io.c: do not free shared swap
 slots" failed to apply to 4.19-stable tree
Message-ID: <20191121203439.GB813260@kroah.com>
References: <1574095036140231@kroah.com>
 <20191118164038.GA595410@kroah.com>
 <0101016e834f2833-62565910-1153-4759-bed3-4779158dc514-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0101016e834f2833-62565910-1153-4759-bed3-4779158dc514-000000@us-west-2.amazonses.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 10:57:13AM +0000, Vinayak Menon wrote:
> 
> On 11/18/2019 10:10 PM, Greg KH wrote:
> > On Mon, Nov 18, 2019 at 05:37:16PM +0100, gregkh@linuxfoundation.org wrote:
> >> The patch below does not apply to the 4.19-stable tree.
> >> If someone wants it applied there, or to any other stable or longterm
> >> tree, then please email the backport, including the original git commit
> >> id to <stable@vger.kernel.org>.
> > Note, this applies, but just breaks the build, so it needs a backport
> > for 4.19 if people want to see it there.
> 
> The version below fixes the build on 4.19.

The patch you sent was totally corrupted, I couldn't figure out how to
fix it up.  Please resend it in a format I can apply it in.

thanks,

greg k-h
