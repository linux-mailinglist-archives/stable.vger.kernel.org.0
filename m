Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB552D44D4
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 15:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732325AbgLIOxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 09:53:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732059AbgLIOxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 09:53:50 -0500
Date:   Wed, 9 Dec 2020 15:54:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607525590;
        bh=IIfUJorqMDpBd82MCjqYNcMz9MwC1uE5ZYVW7orcYZA=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=FGSaiilLUwmBIk0rZNRQHTyvh3Pq8cwIuv2+x4lySFPBlsw3nnB7ukYH/xx7IV+TR
         0pkv/O+hcpRqgLNnRWN0H0yWRrVM7Xb35jv6dSEGIJjRMCkOylEP9OGdvaskR07AFk
         mQDkK6kzaS8alz1L4U4JDzZ3a5GUrsAhnIvogNCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jim Cromie <jim.cromie@gmail.com>
Cc:     Jason Baron <jbaron@akamai.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] dyndbg: fix use before null check
Message-ID: <X9DlIkNg2mVf20Bo@kroah.com>
References: <20201123184334.1777186-1-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123184334.1777186-1-jim.cromie@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 11:43:34AM -0700, Jim Cromie wrote:
> commit a2d375eda771 ("dyndbg: refine export, rename to dynamic_debug_exec_queries()")
> 
> Above commit copies a string before checking for null pointer, fix
> this, and add a pr_err.  Also trim comment, and add return val info.

The way you list the above commit is very odd, and hard to read and
understand.  How about something like:

	In commit a2d375eda771 ("dyndbg: refine export, rename to
	dynamic_debug_exec_queries()"), a string is copied before
	checking....


Also, when you say "also" in a patch, that is a HUGE flag that the
commit needs to be broken up into multiple patches.  Put the bugfix
first, and then fix up the comment later, if it is not being changed for
this fix.

Also:

> Fixes: a2d375eda771

You need the full information here, please write:
	Fixes: a2d375eda771 ("dyndbg: refine export, rename to dynamic_debug_exec_queries()")


Can you fix all of that up and resend?

thanks,

greg k-h
