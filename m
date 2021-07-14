Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE663C7F9B
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 09:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbhGNHzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 03:55:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41000 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238139AbhGNHzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 03:55:51 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 23B392058A;
        Wed, 14 Jul 2021 07:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1626249179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ujqb/zEY2k9KvhKQHF6Csk8Ctg8A3CK/RhiEIwOGvQA=;
        b=mflHGjHAofHGhgtGzeEs8vUR+3U3yHRYl6hwwZpM5P9l9DMXZpV2dPZGYR2MCBojyn/4Gi
        iCX3TqfqM4EYUA15Vt/MUeHNN8f1GkQ1W4J14zMjbj9dE4JcqsLVR4n5T9T4xc7I+DPOXU
        UA2rvnU5k18eBPSdS5sWMjgpof5fDkI=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 93688A3B85;
        Wed, 14 Jul 2021 07:52:58 +0000 (UTC)
Date:   Wed, 14 Jul 2021 09:52:58 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: 5.13.2-rc and others have many not for stable
Message-ID: <YO6X2og4mzqAEwJn@dhcp22.suse.cz>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
 <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 13-07-21 18:28:13, Andrew Morton wrote:
[...]
> > Trying to keep a "do not apply" list for Fixes: tags only is much harder
> > for both of us as we do these semi-manually and review them
> > individually.  Trying to remember what subsystem only does Fixes tags
> > yet really doesn't mean it is an impossible task.
> 
> Well, it shouldn't be super hard to skip all patches which have Fixes:,
> Signed-off-by:akpm and no cc:stable?
> 
> I'd really really prefer this, please.

Yes please!

> At present this -stable
> promiscuity is overriding the (sometime carefully) considered decisions
> of the MM developers, and that's a bit scary.

Not only scary, it is also a waste of precious time of those who
carefuly evaluate stable tree backports.

> I've actually been
> spending the past couple of years believing that if I left off
> cc:stable, the fix wasn't going to go into -stable!
> 
> Alternatively I could just invent a new tag to replace the "Fixes:"
> ("Fixes-no-backport?") to be used on patches which fix a known previous
> commit but which we don't want backported.
 
Please no. We already do have a way to mark for stable trees. The fact
that stable kernel maintainers tend oto ignore that shouldn't put the
burden to developers/maintainers. But hey, if stable maintainers really
want to push to quantity over quality then be it....

-- 
Michal Hocko
SUSE Labs
