Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62FF218A8AC
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 23:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgCRWz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 18:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:32918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgCRWz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 18:55:26 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A5102076E;
        Wed, 18 Mar 2020 22:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584572125;
        bh=78Nf4mARvPIs7QGbl8xZIjkTrHpzmUqX/N3OWsROUFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y/yyeu0KjeBpTQqqCv1PFKdv55ktqgLTSmEXO5irmyLXS71aUYAG1mjOihAnCYUdL
         l7pyu2J4XhuK90TIpPEnrc/BOzluT7PfUOARLf+sxaevAi2NHHCMLHuo4gd7auejY7
         4G/MsL+aEXd+Z5nEpftvxRVbZxuVrqgy+I+r+kPY=
Date:   Wed, 18 Mar 2020 15:55:24 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Kees Cook <keescook@chromium.org>, NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v3 2/5] fs/filesystems.c: downgrade user-reachable
 WARN_ONCE() to pr_warn_once()
Message-ID: <20200318225524.GE2334@sol.localdomain>
References: <20200314213426.134866-3-ebiggers@kernel.org>
 <20200317223028.6840A20738@mail.kernel.org>
 <20200318150926.GA4144@linux-8ccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318150926.GA4144@linux-8ccs>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 04:09:26PM +0100, Jessica Yu wrote:
> +++ Sasha Levin [17/03/20 22:30 +0000]:
> > Hi
> > 
> > [This is an automated email]
> > 
> > This commit has been processed because it contains a -stable tag.
> > The stable tag indicates that it's relevant for the following trees: all
> > 
> > The bot has tested the following trees: v5.5.9, v5.4.25, v4.19.109, v4.14.173, v4.9.216, v4.4.216.
> > 
> > v5.5.9: Build OK!
> > v5.4.25: Build OK!
> > v4.19.109: Build OK!
> > v4.14.173: Build OK!
> > v4.9.216: Failed to apply! Possible dependencies:
> >    41124db869b7 ("fs: warn in case userspace lied about modprobe return")
> > 
> > v4.4.216: Failed to apply! Possible dependencies:
> >    41124db869b7 ("fs: warn in case userspace lied about modprobe return")
> > 
> > 
> > NOTE: The patch will not be queued to stable trees until it is upstream.
> > 
> > How should we proceed with this patch?
> 
> Since commit 41124db869b7 was introduced v4.13, I guess we should
> change the stable tag to:
> 
> Cc: stable@vger.kernel.org # v4.13+
> 

It should use:

 Fixes: 41124db869b7 ("fs: warn in case userspace lied about modprobe return")
 Cc: <stable@vger.kernel.org> # v4.13+

I'll add it.
