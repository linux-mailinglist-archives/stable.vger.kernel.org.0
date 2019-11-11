Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2E8BF7053
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 10:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfKKJSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 04:18:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbfKKJSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 04:18:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB25E20674;
        Mon, 11 Nov 2019 09:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573463896;
        bh=n+juRajGnBdMAbfBT6DJwijoYF6H+Bn/2ZOcyKmcGP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bCEMxYQHBdAS4A7mdB+h1ZBgJw9+YjsnLrJK6z42D+5hslWU4cKapd4u+qYaBjtGE
         Ez33MxtS7vdCUC+XwjxeQj1DUvpcqjh/qUokGRC0K+mQPovMuLth80q8FEBcdHedRe
         3Csgo3u7yH2igD0dQB9APNh37YU4w0EITnZo3l7c=
Date:   Mon, 11 Nov 2019 10:18:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dave Chiluk <chiluk+linux@indeed.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH v4.14.y 0/2] Please backport de53fd7aedb1 : sched/fair:
 Fix low cpu usage with high throttling by removing expiration of cpu-local
 slices
Message-ID: <20191111091813.GB4139389@kroah.com>
References: <20191104110832.GE1945210@kroah.com>
 <1573244157-28339-1-git-send-email-chiluk+linux@indeed.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573244157-28339-1-git-send-email-chiluk+linux@indeed.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 02:15:55PM -0600, Dave Chiluk wrote:
> Here's the backported patches for 4.14.y.  Logic is basically the same, the
> issue was primarily with patch context. The patches are really back-ports and
> not cherry-picks because of that, if that's an issue feel free to change the
> text description.
> 
> [PATCH v4.14.y 1/2] sched/fair: Fix low cpu usage with high throttling by
> [PATCH v4.14.y 2/2] sched/fair: Fix -Wunused-but-set-variable warnings
> 

Both now applied, thanks!

greg k-h
