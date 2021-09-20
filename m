Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFF9411544
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 15:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbhITNIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 09:08:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231704AbhITNIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 09:08:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9681560F6E;
        Mon, 20 Sep 2021 13:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632143217;
        bh=dHyxhZp0tyLVmdPwvjpHcTls+PuoexgxlB2XEK6+C3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ldcyr+Xr05YzGDkFJSyXEtRL3CTtV1TwtFOFeUqruRkuW467HEqiVoLZ2VgmZTLZo
         mgeT5tgSDHiNXq3/+BaqYt01tSSzFvprH6McXBUhcev+AO5K2lmIxbiZKnOaqnIdoj
         zU1kgEyDEZ34Aw6GIBJ9kLawsN9QVNTsfHvyRx9U=
Date:   Mon, 20 Sep 2021 15:06:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pankaj Gupta <pankaj.gupta@ionos.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH 4.19 STABLE] mm/memory_hotplug: use "unsigned long" for
 PFN in zone_for_pfn_range()
Message-ID: <YUiHbj8hfb74zaP7@kroah.com>
References: <163179697124554@kroah.com>
 <20210920113224.7478-1-david@redhat.com>
 <YUh6kI6f4Q9NgB7B@kroah.com>
 <469a6a19-fef0-2e5f-1b61-34305eaf02bb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469a6a19-fef0-2e5f-1b61-34305eaf02bb@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 02:19:53PM +0200, David Hildenbrand wrote:
> On 20.09.21 14:12, Greg KH wrote:
> > On Mon, Sep 20, 2021 at 01:32:24PM +0200, David Hildenbrand wrote:
> > > commit 7cf209ba8a86410939a24cb1aeb279479a7e0ca6 upstream.
> > > 
> > 
> > We also need a 5.4.y version if we are going to be able to apply the
> > 4.19.y and 4.14.y versions.
> 
> On it, still compiling :)

Ah, thanks, all now queued up.

greg k-h
