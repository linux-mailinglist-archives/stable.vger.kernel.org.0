Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5381076982
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387924AbfGZNwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388305AbfGZNwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:52:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B44E22CE9;
        Fri, 26 Jul 2019 13:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564149156;
        bh=c21k69hrhCb4HouQsKmYP+sRgv9Y9FFiZJd1DthvLCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dzgYaWYK/6bDz2pkJsQC4O8wvuKZeOdLkH3T6oX+nuNPi/Q5Ng3jySfqxQ1JUf07d
         GFw9FzS/P9xHveM2pWl+bLPL1zW9VuG0VvL1pvX8ej8Vx3CU4OKyFqrWwS21nIC9z7
         RcBKbr3dFw7VZSn5eRCP3kfLQJlctQ1aOW+Jxuf8=
Date:   Fri, 26 Jul 2019 15:52:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kuo-Hsin Yang <vovoy@chromium.org>
Cc:     stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Rik van Riel <riel@redhat.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.14, 4.19, 5.1] mm: vmscan: scan anonymous pages on file
 refaults
Message-ID: <20190726135233.GD23085@kroah.com>
References: <20190725072614.114942-1-vovoy@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725072614.114942-1-vovoy@chromium.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 03:26:14PM +0800, Kuo-Hsin Yang wrote:
> commit 2c012a4ad1a2cd3fb5a0f9307b9d219f84eda1fa upstream.
> 

Thanks for the backport, now queued up.

greg k-h
