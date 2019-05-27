Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9549D2B744
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 16:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfE0OHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 10:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbfE0OHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 May 2019 10:07:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85251205ED;
        Mon, 27 May 2019 14:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558966059;
        bh=1vqEAA9pwvs1X+N7U4t+gRNUXs5J9CVs5eYDaa9sbsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PjTPnQCjip6nPNmRGkrZmFvq4W5PI+mJXyM1+Z+NWlX+IcxhnMs8Z5rrQ1/IGabkX
         154dnLeXtOf0cFeYL/UscTlHQtZPMPYvlVr66DBGHFqXSCokwSBn8e6/npcan0pn+/
         YVvepwce+o4My5Ca+uU8KRuSKRzIkvXCW6xhO/rc=
Date:   Mon, 27 May 2019 16:07:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     akpm@linux-foundation.org, dbueso@suse.de, iamjoonsoo.kim@lge.com,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] hugetlb: use same fault hash key for
 shared and private" failed to apply to 4.4-stable tree
Message-ID: <20190527140736.GC7659@kroah.com>
References: <1558105205227215@kroah.com>
 <d7d4ab79-bb4a-224f-9614-225070f3b78e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7d4ab79-bb4a-224f-9614-225070f3b78e@oracle.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 04:41:24PM -0700, Mike Kravetz wrote:
> On 5/17/19 8:00 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> From: Mike Kravetz <mike.kravetz@oracle.com>
> Date: Thu, 23 May 2019 13:52:15 -0700
> Subject: [PATCH] hugetlb: use same fault hash key for shared and private
>  mappings
> 
> commit 1b426bac66e6cc83c9f2d92b96e4e72acf43419a upstream.

Thanks for all of these, now queued up,

greg k-h
