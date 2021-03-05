Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883B032E377
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 09:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhCEINp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 03:13:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbhCEINp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 03:13:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50AC065011;
        Fri,  5 Mar 2021 08:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614932024;
        bh=c7FLxN1TIGE/IHKOW2FYr6BeKhcBUjGjqMwFZLmtkHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=imBzRJAAWgPNQc7OTftV3hSu2cNqMV9blwLAVDz82jZxYmrniWJKhyrhFj3QgxUDU
         G5KcEnTeU9MBmUlOIgQ66/ygi9I6TwaFWfo1XzQtGxtpc9/o+HJO8CF4IU5kpUBfOE
         xhjZ97i3MB7OyvNPv/HArrYCjuaeZ5arR73rhvFc=
Date:   Fri, 5 Mar 2021 09:13:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rokudo Yan <wu-yan@tcl.com>
Cc:     akpm@linux-foundation.org, minchan@kernel.org,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] zsmalloc: account the number of compacted
 pages correctly" failed to apply to 4.4-stable tree
Message-ID: <YEHoNSdkbk/V+XLf@kroah.com>
References: <1614520628114242@kroah.com>
 <20210305051338.2638116-1-wu-yan@tcl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051338.2638116-1-wu-yan@tcl.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 01:13:38PM +0800, Rokudo Yan wrote:
> commit 2395928158059b8f9858365fce7713ce7fef62e4 backported to
> 4.4-stable tree.

Thanks for telling me which commit was for which one, and for all the
backports.

now queued up.

greg k-h
