Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E44215576C
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 13:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgBGMM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 07:12:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgBGMM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Feb 2020 07:12:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09DEA20838;
        Fri,  7 Feb 2020 12:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581077575;
        bh=BwkyB/pOX5dnyRcjt+0Rdj3Q2NdZ1sO4g7KJmP9R6EQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=djoT5YbikrsZmrV3pHWo47jToSY9HtIwISbRZ19anbuH0r5XbT+xPq1tMKhhCTTgY
         x9mUSSwZQ3c2bSG05lSx8OR5iuBZS/HPfdYc6EXI+Z/JDb2qvW75dIyLhVsaqD5uBV
         G7KzvdhbYQXa27/otZV8k2zR71vOMeSXyZS5Od88=
Date:   Fri, 7 Feb 2020 13:12:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm writecache: fix incorrect flush
 sequence when doing SSD" failed to apply to 4.19-stable tree
Message-ID: <20200207121253.GA925204@kroah.com>
References: <15810716881950@kroah.com>
 <alpine.LRH.2.02.2002070553070.30271@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2002070553070.30271@file01.intranet.prod.int.rdu2.redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 07, 2020 at 05:54:29AM -0500, Mikulas Patocka wrote:
> 
> 
> On Fri, 7 Feb 2020, gregkh@linuxfoundation.org wrote:
> 
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi
> 
> Here I'm sending updated patch for 4.19.

Thanks, now queued up.

greg k-h
