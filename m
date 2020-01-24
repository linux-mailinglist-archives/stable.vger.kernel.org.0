Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0021147A54
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbgAXJXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:23:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729880AbgAXJXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:23:04 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D44A2070A;
        Fri, 24 Jan 2020 09:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579857784;
        bh=s+0h+4dvs2aEXmrQqesmTDSRft0Krb3OwIM0msq0JiU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hU2gp7ka4QLqikuGGTp5PXPNF7fgIQh6E1EafaqOZlURu5EkYIAObAgsIH9CapuH/
         jZRVmVikzFr5vGH4kg+Nxo8fQRyBBZMhayPhgCCTAkXysg/u70OeF/D2Uf40w8y965
         b+EqeiisL4xaJEpsNUBK5tfbQnwC+n1LV5yXcAa8=
Date:   Fri, 24 Jan 2020 10:23:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH for 4.19-stable v2 05/24] mm, memory_hotplug: add nid
 parameter to arch_remove_memory
Message-ID: <20200124092300.GA2984592@kroah.com>
References: <20200121180150.37454-1-david@redhat.com>
 <20200121180150.37454-6-david@redhat.com>
 <f38c2c53-b896-560c-97fe-4a76f98835b5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f38c2c53-b896-560c-97fe-4a76f98835b5@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 10:25:14AM +0100, David Hildenbrand wrote:
> On 21.01.20 19:01, David Hildenbrand wrote:
> > commit 2c2a5af6fed20cf74401c9d64319c76c5ff81309 upstream.
> > 
> 
> Grml, lost the author information of that one again.
> 
> This should have
> 
> From: Oscar Salvador <osalvador@suse.com>
> 
> 
> The other ones seem to be fine.

Can you please fix up and resend, doing this by hand on my end does not
scale.

thanks,

greg k-h
