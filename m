Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E80ABAFE7
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 10:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731609AbfIWIsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 04:48:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:41792 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725816AbfIWIsI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Sep 2019 04:48:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1D2A4AAB2;
        Mon, 23 Sep 2019 08:48:06 +0000 (UTC)
Subject: Re: [PATCH STABLE 4.9] x86, mm, gup: prevent get_page() race with
 munmap in paravirt guest
To:     Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        Jann Horn <jannh@google.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        xen-devel@lists.xenproject.org, Oscar Salvador <osalvador@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
References: <20190802160614.8089-1-vbabka@suse.cz>
 <d3bb280b405d6acf0bc4176d63639201ff62853f.camel@decadent.org.uk>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <78bbba27-81ed-40db-eb6e-5add997b2027@suse.cz>
Date:   Mon, 23 Sep 2019 10:48:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d3bb280b405d6acf0bc4176d63639201ff62853f.camel@decadent.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/19/19 8:26 PM, Ben Hutchings wrote:
> On Mon, 2019-08-19 at 18:58 +0100, Vlastimil Babka wrote:
> [...]
>> Hi, I'm sending this stable-only patch for consideration because it's probably
>> unrealistic to backport the 4.13 switch to generic GUP. I can look at 4.4 and
>> 3.16 if accepted. The RCU page table freeing could be also considered.
> 
> I would be interested in backports for 3.16 and 4.4.
> 
>> Note the patch also includes page refcount protection. I found out that
>> 8fde12ca79af ("mm: prevent get_user_pages() from overflowing page refcount")
>> backport to 4.9 missed the arch-specific gup implementations:
>> https://lore.kernel.org/lkml/6650323f-dbc9-f069-000b-f6b0f941a065@suse.cz/
> [...]
> 
> I suppose that still needs to be addressed for 4.9, right?

Yeah, I'll take a look, thanks for reminding.

> Ben.
> 

