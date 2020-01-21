Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 432FD14480B
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 00:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAUXIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 18:08:42 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:36168 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgAUXIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 18:08:42 -0500
Received: by mail-pf1-f180.google.com with SMTP id x184so2286134pfb.3
        for <stable@vger.kernel.org>; Tue, 21 Jan 2020 15:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=NN0QRApHWsj9Jc61AGLC2+G4vRrnR78BzunYBZ0r8+0=;
        b=Pt4JRRAZSoDXob0iKOLyBmh0z9DGFowWHVU8Vvt3+16bLiVJx+wi6qgjYxJxVngAeH
         Wz83pPWqG4NiJpHFeSlfnDOiL+3NIg/vCJuVYKHaxyouewm5mPz7YoUuqq3XnYUBPYqD
         Zks0qVTi5BlsJpzuXPrwRPgbjNHZlmTK4TkLTkaPpmjs4hI9wUdQeF4UXHS8F2lxePgU
         9lBK35gEIU+XX7x1NpummcHXPeyZf0pIB4Y6xKtvofLsVcmHR+oki6GIKoyXwoyhwoit
         HYSLn7FcqvJV9C/Ar7mJ4N7CxFhpgarK4uVEuHkbEUtoHG0vDE9gGBlRJDj/hW37iVal
         gfag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=NN0QRApHWsj9Jc61AGLC2+G4vRrnR78BzunYBZ0r8+0=;
        b=az59Rd1kfRe2XCEoWsQjzewoWy+kA98bZo5Kc6q3xRXNPd9lcg59POQ5Tqvn6Q8VTQ
         CRfM3Uqva84Wen3SNRxM9gek3BaGuXLeqGWBBwLXygmsi/TiQEB24OGBxGqdkd6AQ/so
         G+6heuVV/vuT/g5Zn0DOA2Wof2+DwGeZQx8nNYiyVckif13aSX2iqRQ5BSY1OAtL4pn3
         MZ/X05dxWTIbk5GF/2Hs8pKcGoWt5BoMBJoef+WWkXZAvKxXN68s6E7ucS7UJuASVG2p
         2Gf5nW8zQ5OLUEvhs8bqg6J6qtbXXOAzR/NS/7GkEWkB5AZHtXVhBplLAPtgVh9WIwsy
         RUrg==
X-Gm-Message-State: APjAAAXuoA+Zgq8DHWuGNvXREpqjf9mBNKrrIBlNZhJrzJGHmfV+VATU
        Y5JXphjUk5S1kp5v+RBFuSHdvw==
X-Google-Smtp-Source: APXvYqxfXNo8eNWyLAMLVTSsxKbGwDX3H+6Y2UK42qwLqsuwp466iqqBi92d/WzdE9KyrqjcrZd2AA==
X-Received: by 2002:aa7:9567:: with SMTP id x7mr6685120pfq.133.1579648121268;
        Tue, 21 Jan 2020 15:08:41 -0800 (PST)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id g9sm45139913pfm.150.2020.01.21.15.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 15:08:40 -0800 (PST)
Date:   Tue, 21 Jan 2020 15:08:39 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Michal Hocko <mhocko@kernel.org>
cc:     Andrew Morton <akpm@linux-foundation.org>,
        Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        vdavydov.dev@gmail.com, ktkhai@virtuozzo.com,
        kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        stable@vger.kernel.org
Subject: Re: [Patch v4] mm: thp: remove the defer list related code since
 this will not happen
In-Reply-To: <20200120212726.GB29276@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.21.2001211500250.157547@chino.kir.corp.google.com>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com> <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org> <alpine.DEB.2.21.2001181525250.27051@chino.kir.corp.google.com> <20200120072237.GA18451@dhcp22.suse.cz>
 <alpine.DEB.2.21.2001201307520.259466@chino.kir.corp.google.com> <20200120212726.GB29276@dhcp22.suse.cz>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Jan 2020, Michal Hocko wrote:

> > > > When migrating memcg charges of thp memory, there are two possibilities:
> > > > 
> > > >  (1) The underlying compound page is mapped by a pmd and thus does is not 
> > > >      on a deferred split queue (it's mapped), or
> > > > 
> > > >  (2) The compound page is not mapped by a pmd and is awaiting split on a
> > > >      deferred split queue.
> > > > 
> > > > The current charge migration implementation does *not* migrate charges for 
> > > > thp memory on the deferred split queue, it only migrates charges for pages 
> > > > that are mapped by a pmd.
> > > > 
> > > > Thus, to migrate charges, the underlying compound page cannot be on a 
> > > > deferred split queue; no list manipulation needs to be done in 
> > > > mem_cgroup_move_account().
> > > > 
> > > > With the current code, the underlying compound page is moved to the 
> > > > deferred split queue of the memcg its memory is not charged to, so 
> > > > susbequent reclaim will consider these pages for the wrong memcg.  Remove 
> > > > the deferred split queue handling in mem_cgroup_move_account() entirely.
> > > 
> > > I believe this still doesn't describe the underlying problem to the full
> > > extent. What happens with the page on the deferred list when it
> > > shouldn't be there in fact? Unless I am missing something deferred_split_scan
> > > will simply split that huge page. Which is a bit unfortunate but nothing
> > > really critical. This should be mentioned in the changelog.
> > > 
> > 
> > Are you referring to a compound page on the deferred split queue before a 
> > task is moved?  I'm not sure this is within the scope of Wei's patch.. 
> > this is simply preventing a page from being moved to the deferred split
> > queue of a memcg that it is not charged to.  Is there a concern about why 
> > this code can be removed or a suggestion on something else it should be 
> > doing instead?
> 
> No, I do not have any concern about the patch itslef. It is that the
> changelog doesn't decribe the user visible effect. All I am saying is
> that the current code splits THPs of moved pages under memory pressure
> even if that is not needed. And that is a clear bug.

Ah, gotcha.  I tried to do this in the final paragraph of my amedment to 
Wei's patch and why it's important that this is marked as stable.

The current code in 5.4 from commit 87eaceb3faa59 places any migrated 
compound page onto the deferred split queue of the destination memcg 
regardless of whether it has a mapping pmd 
(list_empty(page_deferred_list()) was already false) or it does not have a 
mapping pmd (but is now on the wrong queue).  For the latter, 
can_split_huge_page() can help for the actual split but not for the 
removal of the page that is now erroneously on the queue.  For the former, 
memcg reclaim would not see the pages that it should split under memcg 
pressure so we'll see the same memcg oom conditions we saw before the 
deferred split shrinker became SHRINKER_MEMCG_AWARE: unnecessary ooms.
