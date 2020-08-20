Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBE824B0AF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgHTIB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbgHTIB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 04:01:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A96E2080C;
        Thu, 20 Aug 2020 08:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597910516;
        bh=AXRSCclaOFZ2qfG5TN0/by/Vee9wPQljElWaf2OkM7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OBr7tUvTujDv7eJ9oMYwA3T0VjLw8dChba+scj/M3p3f6KeW0H/QnvBdOuK5mZrfH
         sSTz7Wy8GlyoxDIH+vJzSCKu612dqRNjgecyva5pmL6mjKC7D8r//NRW9qLS9uPvQF
         /E7JITgZk5ofm3bUd/CiT8Su3ZMTDejKSr1R8c8w=
Date:   Thu, 20 Aug 2020 10:02:18 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Justin He <Justin.He@arm.com>
Cc:     "Jonathan.Cameron@Huawei.com" <Jonathan.Cameron@huawei.com>,
        Kaly Xin <Kaly.Xin@arm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bhe@redhat.com" <bhe@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dalias@libc.org" <dalias@libc.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "hslester96@gmail.com" <hslester96@gmail.com>,
        "logang@deltatee.com" <logang@deltatee.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
        "will@kernel.org" <will@kernel.org>,
        "ysato@users.sourceforge.jp" <ysato@users.sourceforge.jp>
Subject: Re: FAILED: patch "[PATCH] mm/memory_hotplug: fix unpaired
 mem_hotplug_begin/done" failed to apply to 4.19-stable tree
Message-ID: <20200820080218.GA4049659@kroah.com>
References: <1597840117224138@kroah.com>
 <AM6PR08MB4069874E06B127B704F0D683F75A0@AM6PR08MB4069.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR08MB4069874E06B127B704F0D683F75A0@AM6PR08MB4069.eurprd08.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 02:27:40AM +0000, Justin He wrote:
> Hi Greg,
> If anybody wants to backport it to stable tree, there are 2 pre-condition for
> this commit ("[PATCH] mm/memory_hotplug: fix unpaired mem_hotplug_begin/done")
> 
> 1. eca499ab3 ("mm/hotplug: make remove_memory() interface usable") applied
> in v5.2, it disabled the BUG() when check_memblock_offlined_cb() failed.
> 2. f1037ec0c ("mm/memory_hotplug: fix remove_memory() lockdep splat")
> in v5.5, it introduced the unpair but depends on eca499ab3
> 
> I checked https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/memory_hotplug.c?h=linux-4.19.y#n1913.
> Looks like stable tree v4.19 hasn't applied eca499ab3 but applied f1037ec0c.
> Hence I don't think v4.19 needs this patch.

Thanks, I'll just leave this out of 4.19.y for now then.

greg k-h
