Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B752E182068
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 19:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730610AbgCKSIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 14:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730607AbgCKSIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 14:08:07 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8914320691;
        Wed, 11 Mar 2020 18:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583950087;
        bh=6MIXU7Mwc0VDsHaOdMgwhPDerRJ9XxPEu+qxamHI2sk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y91BYwoVFMWy7IhSUNFJFEBDLOTgaFp0aa6zpHM9bavXn9CAVlX5mS7qovrtGxVbu
         0qY1xaAEIt2V7umCxRqPJgz8Kmzg8GbXZCGXbybREUWq4Xd87J7KF0ebr1bUHZGP0Y
         auoWsQmrNChcLY2Kf3O6tZ13U9jg93hvrDbEkXY8=
Date:   Wed, 11 Mar 2020 11:08:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH] kmod: make request_module() return an error when
 autoloading is disabled
Message-ID: <20200311180805.GA1273@sol.localdomain>
References: <20200310223731.126894-1-ebiggers@kernel.org>
 <202003111026.2BBE41C@keescook>
 <20200311174134.GB20006@gmail.com>
 <20200311180107.GO11244@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311180107.GO11244@42.do-not-panic.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 06:01:07PM +0000, Luis Chamberlain wrote:
> On Wed, Mar 11, 2020 at 10:41:34AM -0700, Eric Biggers wrote:
> > On Wed, Mar 11, 2020 at 10:28:07AM -0700, Kees Cook wrote:
> > > On Tue, Mar 10, 2020 at 03:37:31PM -0700, Eric Biggers wrote:
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > It's long been possible to disable kernel module autoloading completely
> > > > by setting /proc/sys/kernel/modprobe to the empty string.  This can be
> > > 
> > > Hunh. I've never seen that before. :) I've always used;
> > > 
> > > echo 1 > /proc/sys/kernel/modules_disabled
> > > 
> > > Regardless,
> > > 
> > > Reviewed-by: Kees Cook <keescook@chromium.org>
> > > 
> > 
> > modules_disabled is different because it disables *all* module loading, not just
> > autoloading.
> 
> Clarifying this on your patch would be useful, otherwise its lost
> tribal knowledge.

I think it would be more useful to improve the documentation in proc(5) and
Documentation/admin-guide/sysctl/kernel.rst.  People shouldn't have to read
random kernel commit messages to find the documentation.

I'll send out patches for those.

- Eric
