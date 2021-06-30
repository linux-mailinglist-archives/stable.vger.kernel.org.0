Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A743B7F9D
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 11:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhF3JHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 05:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233514AbhF3JHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 05:07:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC0E9619BE;
        Wed, 30 Jun 2021 09:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625043892;
        bh=dDbVKllmYGwodeUR0MU6gWTp8rDyNKjkRIqypB5Ypgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bwjf18KVWEOl0ZLJhHIHMpfA5zIHj0tnNkTF3ycWqgGt1yTBGNF0WmQ7NgXRJF0F4
         uH63SKlSiz2pcn3FZl/5mz9TnJB2tGFt9acnFOelAq0AsWRV+6KgjHLZrAETplkUna
         DcUgIvYMW+SJXzs6B+GM/MPcvfiqh4DVMo4mEl7A=
Date:   Wed, 30 Jun 2021 11:04:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Nick Hu <nickhu@andestech.com>, Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        iLifetruth <yixiaonn@gmail.com>, Michal Hocko <mhocko@suse.com>,
        Qiang Liu <cyruscyliu@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] nds32: fix up stack guard gap
Message-ID: <YNwzsi3GHRBppvlo@kroah.com>
References: <20210629104024.2293615-1-gregkh@linuxfoundation.org>
 <382e353f-7489-d8c8-5711-a2d99b0b7f0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <382e353f-7489-d8c8-5711-a2d99b0b7f0@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 29, 2021 at 01:33:14PM -0700, Hugh Dickins wrote:
> On Tue, 29 Jun 2021, Greg Kroah-Hartman wrote:
> 
> > Commit 1be7107fbe18 ("mm: larger stack guard gap, between vmas") fixed
> > up almost all architectures to deal with the stack guard gap, but forgit
> > nds32.
> > 
> > Resolve this by properly fixing up the nsd32's version of
> > arch_get_unmapped_area()
> > 
> > Reported-by: iLifetruth <yixiaonn@gmail.com>
> > Cc: Nick Hu <nickhu@andestech.com>
> > Cc: Greentime Hu <green.hu@gmail.com>
> > Cc: Vincent Chen <deanbo422@gmail.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Hugh Dickins <hughd@google.com>
> > Cc: Qiang Liu <cyruscyliu@gmail.com>
> > Cc: stable <stable@vger.kernel.org>
> > Fixes: 1be7107fbe18 ("mm: larger stack guard gap, between vmas")
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Acked-by: Hugh Dickins <hughd@google.com>
> 
> but it's a bit unfair to say that commit forgot nds32:
> nds32 came into the tree nearly a year later.

Ah, missed that.  I will change the text to say that.

greg k-h
