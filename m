Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E31C7851B
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 08:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfG2Gmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 02:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbfG2Gmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 02:42:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53252206BA;
        Mon, 29 Jul 2019 06:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564382554;
        bh=Qp9+T1z2JgN5taraKdHZ8P7RrUP3W9ZQcf9mXUEHr54=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Itis7Uoc/ebDJscDKwh9OYYS9VZTc6K84hKaPyzYONudDWrDJDHHW5X9dOJEOQKvG
         6P/tQDK5PA5PbPMH56QUzTXHNrng+aRSLtB/GyEkhFqFdMRXffAZvmXBD4MGUhjx0D
         9ZRHezjNvTPLfdJrL+KRcNfTfGYc8BpMnyICQZKE=
Date:   Mon, 29 Jul 2019 08:42:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, stable <stable@vger.kernel.org>
Subject: Re: nosmp build errors in v4.14.y-queue
Message-ID: <20190729064232.GA13931@kroah.com>
References: <1ab4245e-3174-f081-9dbc-0847723157b9@roeck-us.net>
 <20190728141216.GB8637@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190728141216.GB8637@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 28, 2019 at 10:12:16AM -0400, Sasha Levin wrote:
> On Sat, Jul 27, 2019 at 08:38:00AM -0700, Guenter Roeck wrote:
> > Just in case it has't been reported.
> > 
> > x86/x86_64 allnoconfig, tinyconfig:
> > 
> > Error log:
> > arch/x86/events/amd/uncore.c: In function 'amd_uncore_event_init':
> > events/amd/uncore.c:222:7: error: 'smp_num_siblings' undeclared
> > 
> > "#include <asm/smp.h>" is missing. Added upstream with commit 812af433038f9
> > ("perf/events/amd/uncore: Fix amd_uncore_llc ID to use pre-defined cpu_llc_id").
> 
> I've queued it up, thanks!

thanks for fixing this.

greg k-h
