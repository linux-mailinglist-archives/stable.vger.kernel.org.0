Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1987336CAA
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 08:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhCKHBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 02:01:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231590AbhCKHAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 02:00:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E66C664E46;
        Thu, 11 Mar 2021 07:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615446054;
        bh=QgLOvn43euCqf5+GkvsfnAw34aq1zyBVVyozfMCAlw4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gOyb0lplNHbOijNit0siKZ/SkFM8Z9ceD14rHNNCtiVrlmZckpQcBb5b9bd8uRBwG
         czFaDFct3Sg+q30v5Zwm34dILAhdp8yI4LNfmCQGgyS23ciIjIf5shWCyOD4AvdPlG
         OOvfUxT3MTGKAa5PfDi+U14EpuVLdNgNstPKI3eU=
Date:   Thu, 11 Mar 2021 08:00:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: commit <sha> upstream. vs git cherry-pick -x
Message-ID: <YEnAI2xuoaM+B04f@kroah.com>
References: <CAKwvOdmAEKQmi-Hy4Gi33t4nb3mCuKUd_qmbEdwrkRwezAWpiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmAEKQmi-Hy4Gi33t4nb3mCuKUd_qmbEdwrkRwezAWpiA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 02:37:03PM -0800, Nick Desaulniers wrote:
> Hello stable maintainers,
> While working on some backports I'm about to send hopefully today or
> tomorrow, I was curious why the convention seems to be for folks to
> use "commit <sha> upstream." in commit messages?  I know that's what's
> in https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#option-3,
> but I was curious whether the format from `git cherry-pick -xs <sha>`
> is not acceptable? I assume there's context as to why not?  It is nice
> to have that info uniformly near the top, but I find myself having to
> cherry-pick then amend a lot.  Or is there an option in git to
> automate the stable kernel's preferred style?

There is no option in git, but I do have a script:
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/scripts/c2p
that takes a git id and turns it into the format we use.

I think Sasha has one somewhere as well that does it in a nicer way
(mine is in perl and hard-codes a lot of stuff).

thanks,

greg k-h
