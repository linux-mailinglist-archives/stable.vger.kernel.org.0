Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0310327F089
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 19:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgI3Ral (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 13:30:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:46708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3Ral (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Sep 2020 13:30:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601487039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=biOcQgRacEB1O2dTYCm0GDqdrroYsSjpfb2OedWVUTw=;
        b=EK/w/axD8ZfcFy/PaKA/wDQx24iLPwNNpF0zHN4mW3zXlFIqy2W8S0UMyip1Tlwv00szGp
        ZMX+ZUjbZ/lvGzUGNPuYI6nAjxq1XrGPGI5LyyfVB1xjuKA2w/0jwfSdnEh1ClhHHyNhub
        qOqAjBFEM8KtTb7KEpY6xEfbDX/GnaQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D4D39ABE3;
        Wed, 30 Sep 2020 17:30:38 +0000 (UTC)
Date:   Wed, 30 Sep 2020 19:30:38 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, cheloha@linux.ibm.com,
        David Hildenbrand <david@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ldufour@linux.ibm.com, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org, nathanl@linux.ibm.com,
        Oscar Salvador <osalvador@suse.de>,
        Rafael Wysocki <rafael@kernel.org>,
        stable <stable@vger.kernel.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 8/9] mm: replace memmap_context by meminit_context
Message-ID: <20200930173038.GZ2277@dhcp22.suse.cz>
References: <20200925211725.0fea54be9e9715486efea21f@linux-foundation.org>
 <20200926041928.9xJHGgkah%akpm@linux-foundation.org>
 <CAHk-=wjcg4ni8_zhGDS9vTQQYM-3ZBg4hGF7Ot9MzW5F2o7mpA@mail.gmail.com>
 <20200929133737.99427221b858425e5ddff706@linux-foundation.org>
 <CAHk-=wgGN3drZeV-RZpVn20yZ6tB0PDCgXa=DaD47sRvM16sGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgGN3drZeV-RZpVn20yZ6tB0PDCgXa=DaD47sRvM16sGw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 30-09-20 09:00:26, Linus Torvalds wrote:
> On Tue, Sep 29, 2020 at 1:37 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > 1/3 and 2/3 were cc:stable and 3/3 was not.  As far as I can tell, 3/3
> > is rather theoretical once 2/3 has done its work, so I held it off for
> > the next merge window.
> 
> That's not the problem, holding off is fine.
> 
> The problem is that the commit messages are garbage as a result. They
> were written as a series of three, but the patches weren't _sent_ as a
> series of three.

This part of the commit message is coming from a cover letter and it is
something that would usually go to a merge commit (from a pull request).
With Andrew's worklflow he preserves the information in the first patch
of the series. It is great to have that information around because there
is usually more background and a high level description. 
 
> So if you split up a series like that, you should look at the commit
> mesages and edit them appropriately.

Yeah, in cases like that it is better to just drop that cover letter
part.

I would still argue that all three could have gone in together. The last
patch has not been marked for stable but it is a useful patch on its own
as it drops a really distasteful BUG() on a failure mode. IMHO it
wouldn't be a big deal to postpone sending these during the merge window
as these patches are not addressing a regression for this part merge
window.

Just my 2c
-- 
Michal Hocko
SUSE Labs
