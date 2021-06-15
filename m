Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB55B3A76F9
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 08:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhFOGT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 02:19:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhFOGT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 02:19:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7270613DA;
        Tue, 15 Jun 2021 06:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623737874;
        bh=KeB5L0kVFMc/wPmzyE6S1gGGHbRh8TTAbFMMtnLQ6PU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VyTrAwHr24tIhhAoqdQ4x1fQnZlyjZW/9lgVUbCC7roYcTseuelGm+Sjoe4Ine78K
         u02jLrJQFubxJmJ9GaBx3yv1JFOCnsl7NIhdwXJTE3QZrK0e68vqpMAKAcNS8mM7OA
         r4XFJYaRV85OJphIgekhLAq9O5oYxhFWxJZFoIzI=
Date:   Tue, 15 Jun 2021 08:17:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adam Edge <baronedge@protonmail.com>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Regression after 5.7.19 causing major freezes on CPU loads
Message-ID: <YMhGDxrELFMrye9c@kroah.com>
References: <HnYKcqmY_z0ERb5qOOUauOLY1vt6nxuKHXzuKVrZ297elyqtzpsWTrjUUnlIDG7mQUYnJMfS8HkFceFMf0Fd_GLzOMghgf4btNt9YhwwZK0=@protonmail.com>
 <YMhCK8x7R4TbnLAF@kroah.com>
 <GUSUkWNwTxbgBsjYfpPEreYbwdu5JGec4XqJhWkFs8UncAWLJ9MdDIUvmZ0wYDLj8dFmEGcImo_fDBWte9QaFV2Yil6W7XLHlyXENv6vqd8=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GUSUkWNwTxbgBsjYfpPEreYbwdu5JGec4XqJhWkFs8UncAWLJ9MdDIUvmZ0wYDLj8dFmEGcImo_fDBWte9QaFV2Yil6W7XLHlyXENv6vqd8=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 06:13:46AM +0000, Adam Edge wrote:
> On Tuesday, June 15th, 2021 at 6:01 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > Can you use 'git bisect' to track down the commit that caused the
> > problem?
> 
> As I have mentioned in my previous email, anytime I'm within the v5.8-rc*
> range of commits, running the kernel fails to get past a certain point
> at boot. init doesn't get executed, but SysRq keys work and I can reboot
> from there. Has this happened before? If there is an alternate method
> of getting the kernel debug logs for this (that doesn't involve a serial
> connection, as I don't have the equipment for that), I'm happy to get
> them for you.

That sounds like the offending commit is in that range, which is good,
you have narrowed it down.

Just use 'git bisect' to track down the place where this fails at,
that's all we want.  No need to get a debug log yet, "failing to boot"
is a good sign something is going wrong :)

thanks,

greg k-h
