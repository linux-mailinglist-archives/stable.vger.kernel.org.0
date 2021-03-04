Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C1A32D7CB
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 17:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbhCDQbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 11:31:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:50268 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233617AbhCDQas (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 11:30:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614875402; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sQN9SAzuKzLYoT1rSq62TVM+z2FHdV17wB6gfhjAs+Y=;
        b=RWc0jmeryKrVIElTF0ZYzWUy8nKZJLQz84sjQXW+i4wbvNDgrbpaFbIYtkS3gKGI5oHIqs
        Uka5j7VBKxwvUagHkGulyz2ggGVdUyG+nDypoednBwjCwfTBIpZxWf7QoZbOibPNR3W9D3
        TCr65fIsGnKuA4Qon/qFrUVPohH3lg4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F2FCEAD2B;
        Thu,  4 Mar 2021 16:30:01 +0000 (UTC)
Date:   Thu, 4 Mar 2021 17:30:00 +0100
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH STABLE 5.10 5.11] swap: fix swapfile page to sector
 mapping
Message-ID: <YEELCJkGx78SP34d@technoir>
References: <20210304150824.29878-1-ailiop@suse.com>
 <20210304150824.29878-5-ailiop@suse.com>
 <YED5ypwsrExHWD7N@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YED5ypwsrExHWD7N@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 04:16:26PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Mar 04, 2021 at 04:08:24PM +0100, Anthony Iliopoulos wrote:
> > commit caf6912f3f4af7232340d500a4a2008f81b93f14 upstream.
> 
> No, this does not look like that commit.
> 
> Why can I not just take caf6912f3f4a ("swap: fix swapfile read/write
> offset") directly for 5.10 and 5.11?  WHat has changed to prevent that?

You're right of course, the upstream fix applies even on v5.4 so you
could just take it directly for those branches if this is preferable.

Regards,
Anthony
