Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9997E26A323
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 12:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgIOK24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 06:28:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:54730 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgIOK24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 06:28:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9641BAC46;
        Tue, 15 Sep 2020 10:29:09 +0000 (UTC)
Date:   Tue, 15 Sep 2020 12:28:51 +0200
From:   Oscar Salvador <osalvador@suse.de>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        mhocko@suse.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm: replace memmap_context by memplug_context
Message-ID: <20200915102845.GA30015@linux>
References: <20200915094143.79181-1-ldufour@linux.ibm.com>
 <20200915094143.79181-2-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915094143.79181-2-ldufour@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 11:41:41AM +0200, Laurent Dufour wrote:
> The memmap_context is used to detect whether a memory operation is due to a
> hot-add operation or happening at boot time.
> 
> Make it general to the hotplug operation and rename it at memplug_context.
> 
> There is no functional change introduced by this patch
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

-- 
Oscar Salvador
SUSE L3
