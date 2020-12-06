Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68BA2D0258
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 10:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgLFJ5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 04:57:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgLFJ5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 04:57:21 -0500
Date:   Sun, 6 Dec 2020 10:57:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607248600;
        bh=SKUmhkEwZWOhc6+o2rbPgGEX5q3yVxFAM2WKqf71XxI=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=PAHP6Lkb+PJtufermPBZWJkb4FPXfSNrgKwM4/q7gHcUyb5Rv5Adczmu8R72IEXFm
         CXPr3Ma+VREz16J4mEoEywpMKIPOvRe2sBuHY5So14Lo7WWwukV0EfOyqje/d8EYRb
         xwplbSV1kb+P80EJX/5y4XpHcvEzklCSG1M9LIqU=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        bsegall@google.com, pauld@redhat.com, zohooouoto@zoho.com.cn,
        stable@vger.kernel.org, Gavin Guo <gavin.guo@canonical.com>,
        nivedita.singhvi@canonical.com, halves@canonical.com
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
Message-ID: <X8yrIKm/ODrrlwx5@kroah.com>
References: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 19, 2020 at 11:56:01AM -0300, Guilherme G. Piccoli wrote:
> Hi Sasha / Peter, is there anything blocking this backport from Vincent
> to get merged in 5.4.y?

The backport doesn't apply to the tree.  How did you test this?

thanks,

greg k-h
