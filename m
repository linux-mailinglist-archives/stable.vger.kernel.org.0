Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239B117A81D
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 15:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgCEOvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 09:51:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgCEOvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 09:51:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E59820848;
        Thu,  5 Mar 2020 14:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583419877;
        bh=dYUB22SQyb7z9lvN1AIxINebJYpOpFyO+EhGN+R7FuU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=htLK1dfb3Rn9WsAsH4YUgSg1yM5D7yyjUuwI6cuaLKA3vq98Nk+3FLMmkyv4xx0M3
         VlHVoy9PvJV8PeavVDBYFjqyyTIo8cSvQnxDw3VOC8M2uLGP1zBxUpVoRAu+Hw+t/3
         O7R3tAREXS4+LD/CmDvs5qcFHPrWR9+xzICiE2Lc=
Date:   Thu, 5 Mar 2020 15:51:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, Qian Cai <cai@lca.pw>,
        Lech Perczak <l.perczak@camlintechnologies.com>
Subject: Re: Regression in v4.14.172 - please revert commit 28820c5802f9
Message-ID: <20200305145115.GA1950999@kroah.com>
References: <20200304211419.GA30249@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304211419.GA30249@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 04, 2020 at 01:14:19PM -0800, Guenter Roeck wrote:
> Hi,
> 
> We see a regression in v4.14.172, caused by commit 28820c5802f9
> ("char/random: silence a lockdep splat with printk()"). I could try
> to explain it, but as it turns out it was already reported for v4.19.y,
> and the commit has already been reverted there. See commit cfc30449bbc50
> ("Revert "char/random: silence a lockdep splat with printk()") in v4.19.y
> for a detailed description of the problem.
> 
> Please revert this commit in v4.14.y as well.

Now reverted, sorry for missing that it also was in 4.14.

greg k-h
