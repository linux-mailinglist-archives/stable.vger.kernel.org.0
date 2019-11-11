Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB3EF7057
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 10:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfKKJTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 04:19:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfKKJTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 04:19:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECFDF20674;
        Mon, 11 Nov 2019 09:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573463955;
        bh=39ESEpbrfDZlt8O1yJvrIVTvQQNzGYfnoMPQY9m6x2E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fo8ebVbAWD/DRT5m5DcfNgU3Zc73CiuDW6ZZp+5qG/hZs1H01P+aljqESU6y/fbnW
         Kl5ig1F/hfA3wOPNDb2w8SOymxKg5Wg0ZOEvDQ+d63trumwLnNCorJme6KyzWjf/N5
         VxQfJCapAhNdChLlfKN3OYs6Zp2kFFb96SKrRzGE=
Date:   Mon, 11 Nov 2019 10:19:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dave Chiluk <chiluk+linux@indeed.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH v4.19.y 0/2] Please backport de53fd7aedb1 : sched/fair:
 Fix low cpu usage with high throttling by removing expiration of cpu-local
 slices
Message-ID: <20191111091913.GC4139389@kroah.com>
References: <20191104110832.GE1945210@kroah.com>
 <1573244408-31101-1-git-send-email-chiluk+linux@indeed.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573244408-31101-1-git-send-email-chiluk+linux@indeed.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 02:20:06PM -0600, Dave Chiluk wrote:
> Here's the backported patches for 4.19.y.  Logic is basically the same, the
> issue was primarily with patch context. The patches are really back-ports and
> not cherry-picks because of that, if that's an issue feel free to change the
> text description.
> 
> [PATCH v4.19.y 1/2] sched/fair: Fix low cpu usage with high throttling by
> [PATCH v4.19.y 2/2] sched/fair: Fix -Wunused-but-set-variable warnings

Both now queued up, thanks.

greg k-h
