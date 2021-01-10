Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C58E2F0660
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 11:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbhAJKUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 05:20:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbhAJKUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 05:20:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 825B6236F9;
        Sun, 10 Jan 2021 10:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610273970;
        bh=Jw0l8gSsx8En7t0dNhT3ZISp+QqP4m6mM+GqH79ZZZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u5tyrYK+KUj1HdKkURjetX0/vavu9Q6DGFiVb1AIbGfneigANZRLTM2dqoMaqWYtE
         cQN2YyEFNUzx7/QnaXW5FS3XoH5yuXqmNvAr8gORRaU1tYw2V4NWF6a8iM4Fq/rea8
         2MX3a4WgE6b5LzBG+7jd2xx65ZGndylr747MNAfZIVrk8AXWrrz2ql/z66PTLIGhDh
         PA8LT58ToR56QCt83NA8x1RmFn+OAZKwEMIqPnQvMY++7R8stA5j6KMohBhgff8eal
         BjMlZ0hNPeWAYAcod+g+gOP8F0diG0EFTS9yvo5O/6l2BatNBTRD201LRlk4xo9/qs
         ViQ5ImxHhO/3Q==
Date:   Sun, 10 Jan 2021 05:19:29 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Sedat Dilek <sedat.dilek@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: depmod fixes for linux-stable releases
Message-ID: <20210110101929.GG4035784@sasha-vm>
References: <CA+icZUUq9Skdt0ws7uqa3N9P5vwhQX6DrhfNxMvkoKMEbyWE-Q@mail.gmail.com>
 <CAHk-=whNpzmU0UQ+dXU-A8tAyiKEzfrX-ax_80UmM77Ehjzy1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHk-=whNpzmU0UQ+dXU-A8tAyiKEzfrX-ax_80UmM77Ehjzy1A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 09, 2021 at 05:23:22PM -0800, Linus Torvalds wrote:
>Ack, I think 436e980e2ed5 ("kbuild: don't hardcode depmod path") is
>stable material even if it doesn't fix a bug.
>
>Not only does the fix for that commit not make sense without the
>commit in the first place, but any environment that sets depmod
>somewhere else might well be an environment that still wants stable
>kernels.
>
>It may not be the traditional case, but there's little reason for the
>kernel build to force that /sbin/depmod location.

I'll take it, thanks!

-- 
Thanks,
Sasha
