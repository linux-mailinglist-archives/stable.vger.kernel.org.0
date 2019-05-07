Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C05168A7
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfEGRCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 13:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbfEGRCK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 13:02:10 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3030A205C9;
        Tue,  7 May 2019 17:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557248529;
        bh=+dH1dylfToIztT6tIsED1NzXkgisvmtolImG8/gDIeU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g67/5rAMyjMObT6TuHwzVVr5fhZH+BNj5IA+NG26oX7D7N4Az/RLsgF1Jc+jUk5c+
         WAC9pINLyovaABMYNG69uAcI1Z1rL/PoxWrlPNd8yFEF2xS7eu0xqXW/90vGKpIwKR
         2kZ9uGjgtwHlfzPHAQvgsHdgIpxzJRUuhzepGMCc=
Date:   Tue, 7 May 2019 13:02:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Pasha Tatashin <Pavel.Tatashin@microsoft.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH AUTOSEL 4.14 62/95] mm, memory_hotplug: initialize struct
 pages for the full memory section
Message-ID: <20190507170208.GF1747@sasha-vm>
References: <20190507053826.31622-1-sashal@kernel.org>
 <20190507053826.31622-62-sashal@kernel.org>
 <CAKgT0Uc8ywg8zrqyM9G+Ws==+yOfxbk6FOMHstO8qsizt8mqXA@mail.gmail.com>
 <CAHk-=win03Q09XEpYmk51VTdoQJTitrr8ON9vgajrLxV8QHk2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHk-=win03Q09XEpYmk51VTdoQJTitrr8ON9vgajrLxV8QHk2A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 09:50:50AM -0700, Linus Torvalds wrote:
>On Tue, May 7, 2019 at 9:31 AM Alexander Duyck
><alexander.duyck@gmail.com> wrote:
>>
>> Wasn't this patch reverted in Linus's tree for causing a regression on
>> some platforms? If so I'm not sure we should pull this in as a
>> candidate for stable should we, or am I missing something?
>
>Good catch. It was reverted in commit 4aa9fc2a435a ("Revert "mm,
>memory_hotplug: initialize struct pages for the full memory
>section"").
>
>We ended up with efad4e475c31 ("mm, memory_hotplug:
>is_mem_section_removable do not pass the end of a zone") instead (and
>possibly others - this was just from looking for commit messages that
>mentioned that reverted commit).

I got it wrong then. I'll fix it up and get efad4e475c31 in instead.
Thanks!

--
Thanks,
Sasha
