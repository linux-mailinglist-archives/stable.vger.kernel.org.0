Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD8B411403
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 14:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhITMN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 08:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231792AbhITMN3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 08:13:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C8C260F50;
        Mon, 20 Sep 2021 12:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632139922;
        bh=Owm1ajp1Rqd+aBn96tGjs4+3HW0GVUikZSmZy794YIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0i6a/GiHAm1cyA+2u4xrVLVlBDgbw2RGSOS94xHCRg+4PYAJgMNKbX4mnrZj4fis1
         4OFfBpYqUV2rSgMNiCpI/3rBGVEzylXa7zLD+UPM4oKf1c+QKWuX26MuH2y7PEiqdC
         MPV+27IcmXGse2T2YirxJuj37Y/iGygATZG/mBUQ=
Date:   Mon, 20 Sep 2021 14:12:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pankaj Gupta <pankaj.gupta@ionos.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH 4.19 STABLE] mm/memory_hotplug: use "unsigned long" for
 PFN in zone_for_pfn_range()
Message-ID: <YUh6kI6f4Q9NgB7B@kroah.com>
References: <163179697124554@kroah.com>
 <20210920113224.7478-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920113224.7478-1-david@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 01:32:24PM +0200, David Hildenbrand wrote:
> commit 7cf209ba8a86410939a24cb1aeb279479a7e0ca6 upstream.
> 

We also need a 5.4.y version if we are going to be able to apply the
4.19.y and 4.14.y versions.

thanks,

greg k-h
