Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2132019D6ED
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390750AbgDCMqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728012AbgDCMqC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Apr 2020 08:46:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 545D92077D;
        Fri,  3 Apr 2020 12:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585917961;
        bh=8Vbyn6IHc/xaPmxjThTQilgsoTSBkIvn8J7KjZ6GjOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FqgXgRzNUBD0KaJt38FHSN8DoQOj/vMsKFuUfyzxb8B1ZTBD0JSHqXBrogUppGvF+
         TerqmrOTdo/fo2iYnBRpQIxUR6WLbElIMCOMOIQjX2KHH6/39rf4Gkt1+MW2f12YWI
         FtrDHoXdbqZnCBtthQYhvjt2jGbEu6ZsYAnqZye0=
Date:   Fri, 3 Apr 2020 14:45:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, g.nault@alphalink.fr
Subject: Re: [PATCH 0/8] [backports] l2tp use-after-free fixes for 4.4 stable
Message-ID: <20200403124557.GA3984782@kroah.com>
References: <20200402173250.7858-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402173250.7858-1-will@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 06:32:42PM +0100, Will Deacon wrote:
> Hi Greg,
> 
> Syzbot has been complaining about KASAN splats due to use-after-free
> issues in the l2tp code on 4.4 Android kernels (although I reproduced
> with latest 4.4 stable on my laptop):
> 
> https://syzkaller.appspot.com/bug?id=de316389db0fa0cd7ced6e564601ea8e56625ebc
> 
> These have been fixed upstream, but for some reason didn't get picked up
> for stable. This series applies to 4.4.y and I've sent patches for 4.9
> separately.

All now queued up, thanks.

greg k-h
