Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9E532D836
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 18:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238515AbhCDRAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 12:00:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236865AbhCDQ7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 11:59:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9743664F59;
        Thu,  4 Mar 2021 16:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614877132;
        bh=ogPCAqUrJsPTWID/+dxg64jg17NrKa1OqVqf+iKrOZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NTZ3MuTBdv2veyQJULk1auCEomEWtDBdbyrLSq0BDydjsVqcw1S5s+cUazQWv2KOF
         mvdM+ix6BlFX6MGTXuAtyLWIQdwB6iog+zJeKWIY8ssps30imD+UnKwNIRqL27k+8V
         xoczlHPXSUEmp3BpnZu2FKYuD3aUjNtwiNZRf1Ro=
Date:   Thu, 4 Mar 2021 17:58:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH STABLE 5.10 5.11] swap: fix swapfile page to sector
 mapping
Message-ID: <YEERyfs8QSB5lGVz@kroah.com>
References: <20210304150824.29878-1-ailiop@suse.com>
 <20210304150824.29878-5-ailiop@suse.com>
 <YED5ypwsrExHWD7N@kroah.com>
 <YEELCJkGx78SP34d@technoir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEELCJkGx78SP34d@technoir>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 05:30:00PM +0100, Anthony Iliopoulos wrote:
> On Thu, Mar 04, 2021 at 04:16:26PM +0100, Greg Kroah-Hartman wrote:
> > On Thu, Mar 04, 2021 at 04:08:24PM +0100, Anthony Iliopoulos wrote:
> > > commit caf6912f3f4af7232340d500a4a2008f81b93f14 upstream.
> > 
> > No, this does not look like that commit.
> > 
> > Why can I not just take caf6912f3f4a ("swap: fix swapfile read/write
> > offset") directly for 5.10 and 5.11?  WHat has changed to prevent that?
> 
> You're right of course, the upstream fix applies even on v5.4 so you
> could just take it directly for those branches if this is preferable.

But, that commit says it fixes 48d15436fde6 ("mm: remove get_swap_bio"),
which is NOT what you are saying here in these patches.

So which is it?  Is there a problem in 5.11 and older kernels
(48d15436fde6 ("mm: remove get_swap_bio") showed up in 5.12-rc1), that
requires this fix, or is there nothing needed to be backported?

As a note, I've been running swapfiles on 5.11 and earlier just fine for
a very long time now, so is this really an issue?

confused,

greg k-h
