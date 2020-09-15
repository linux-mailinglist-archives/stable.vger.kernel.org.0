Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A943226A336
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 12:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgIOKdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 06:33:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:58780 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgIOKdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 06:33:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2CD41AC46;
        Tue, 15 Sep 2020 10:33:45 +0000 (UTC)
Date:   Tue, 15 Sep 2020 12:33:27 +0200
From:   Oscar Salvador <osalvador@suse.de>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        mhocko@suse.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm: don't panic when links can't be created in
 sysfs
Message-ID: <20200915103327.GC30015@linux>
References: <20200915094143.79181-1-ldufour@linux.ibm.com>
 <20200915094143.79181-4-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915094143.79181-4-ldufour@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 11:41:43AM +0200, Laurent Dufour wrote:
> At boot time, or when doing memory hot-add operations, if the links in
> sysfs can't be created, the system is still able to run, so just report the
> error in the kernel log rather than BUG_ON and potentially make system
> unusable because the callpath can be called with locks held.
> 
> Since the number of memory blocks managed could be high, the messages are
> rate limited.
> 
> As a consequence, link_mem_sections() has no status to report anymore.
> 
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

-- 
Oscar Salvador
SUSE L3
