Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CBE3B0A9C
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 18:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFVQuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 12:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhFVQuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Jun 2021 12:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A683F6128C;
        Tue, 22 Jun 2021 16:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624380482;
        bh=qzUuBzb5F0RHtgCbQOzZ6UtpAoaK5hevWWN4NFK156o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nJoq6v0DtatRI5NeqDDHU6hQiYmNqZQcRRlXAv1DVcGrEGpzmtX7pD0xtoYBJakRr
         TkZ2A0E5WIipEWk4NQJNn+UjGzXrnkeO886XmWa2A/tWWBY5PlMpLrwXIKb21EfqdR
         TIxH2B82R+N+xEaB15MhCRxo5jkGbxUL9mCObQGI=
Date:   Tue, 22 Jun 2021 18:47:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Backport d583d360a6 into 5.12 stable
Message-ID: <YNIUP70J5yWPaguo@kroah.com>
References: <11282373.oIR2C0Pl9h@spock>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11282373.oIR2C0Pl9h@spock>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 22, 2021 at 06:30:46PM +0200, Oleksandr Natalenko wrote:
> Hello.
> 
> I'd like to nominate d583d360a6 ("psi: Fix psi state corruption when 
> schedule() races with cgroup move") for 5.12 stable tree.
> 
> Recently, I've hit this:
> 
> ```
> kernel: psi: inconsistent task state! task=2667:clementine cpu=21 psi_flags=0 
> clear=1 set=0
> ```
> 
> and after that PSI IO went crazy high. That seems to match the symptoms 
> described in the commit message.

But this says it fixes 4117cebf1a9f ("psi: Optimize task switch inside
shared cgroups") which did not show up until 5.13-rc1, so how are you
hitting this issue?

Did you try this patch on 5.12.y and see that it solved your problem?

thanks,

greg k-h
