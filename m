Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF4F3C87E9
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 17:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhGNPtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 11:49:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232318AbhGNPtQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 11:49:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00E1D61374;
        Wed, 14 Jul 2021 15:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626277584;
        bh=z+ygMX861WLNXQe7kWq6asnSgjE1WJbUM8xAE/4rwEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F7JrF/Sj6btztkaPSgzsNH4JYCD4X8u0p6JM2dYd6FGbeONayJoyHDUdr9Uff6O1l
         IjCEn55LB0NbvvFGBFCxkiR71s0q+d2fqBZTtHWx1fO3IsZ+UthlRCTTkEsl6AfCmY
         dGXGnfiw9F+a006JbNHhlszWsMxYFL0CyqyFpFMA=
Date:   Wed, 14 Jul 2021 17:46:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Sasha Levin <sashal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: 5.13.2-rc and others have many not for stable
Message-ID: <YO8Gzl2zmg8+R8Uu@kroah.com>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
 <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
 <YO6r1k7CIl16o61z@kroah.com>
 <YO7sNd+6Vlw+hw3y@sashalap>
 <YO8EQZF4+iQ13QU/@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO8EQZF4+iQ13QU/@mit.edu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 11:35:29AM -0400, Theodore Y. Ts'o wrote:
> Another solution (and these don't have to be mutually exclusive) might
> be for maintainers can explicitly state that certain patches shouldn't
> be backported into stable kernels.  I think having an explicit
> "No-Backport: <Reason>" might be useful, since it documents why a
> maintainer requested that the patch not be backported, and being an
> explicit tag, it makes it clear that it wasn't just a case of the
> developer forgetting the "Cc: stable" tag.  This makes it much better
> than implicit rules such as "If from: akpm then don't backport" hidden
> in various stable maintainers' scripts.

The number of valid cases where someone puts a "Fixes:" tag, and that
patch should NOT be backported is really really slim.  Why would you put
that tag and not want to have known-broken kernels fixed?

If it really is not an issue, just do not put the "Fixes:" tag?

thanks,

greg k-h
