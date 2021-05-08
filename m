Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4443772EC
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 18:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhEHQNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 12:13:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhEHQNu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 May 2021 12:13:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD25061260;
        Sat,  8 May 2021 16:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620490368;
        bh=xmWHTRmz0Q45MId+r/9ViIhSRsBdKZun/yeXtRj5jRc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nzrP8W6KtRxssBEJ/p7cqqHIH7bLYPydabcD0WW/N8bZu8cN7VYyHc2DtQYs/ATyD
         XDg6b0f9wyLveY6aSOF9MXYGWWMjqZlVJsWhDpDaJBwv7RZhJ5QZy9wsqEfBqhk1CP
         33r/pC5fa+6b12KUXO5Tgr0eb5wlRJCJHVLu1Eb4=
Date:   Sat, 8 May 2021 18:12:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Chen Yu <yu.c.chen@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: Please apply commit 301b1d3a9104 ("tools/power/turbostat: Fix
 turbostat for AMD Zen CPUs") to v5.10.y and later
Message-ID: <YJa4fUfMY9/suEkm@kroah.com>
References: <YJaTXf1b9IPj/5If@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJaTXf1b9IPj/5If@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 08, 2021 at 03:34:21PM +0200, Salvatore Bonaccorso wrote:
> Hi
> 
> the following was commited in Linus tree a couple of days ago, but so
> is not yet in a tagged version. 
> 
> But still please consider to queue up 301b1d3a9104
> ("tools/power/turbostat: Fix turbostat for AMD Zen CPUs") to v5.10.y
> and later for the next round of updates, as it turbostat no lonwer
> worked on those Zen based systems since 5.10.
> 
> Thank you for considering, I can otherwise reping once 5.13-rc1 is
> tagged and released.

Now queued up, thanks.

greg k-h
