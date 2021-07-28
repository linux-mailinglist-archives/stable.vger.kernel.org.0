Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4530C3D9484
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 19:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhG1Rpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 13:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhG1Rpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 13:45:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C371E6023F;
        Wed, 28 Jul 2021 17:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627494349;
        bh=F2v66I70HoIjFP9RyBBXTn+x6D05McIv+z/aLBTToqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iLtcfzbNIOvRLDbL+QfRmgdZPmuoKtDK7qFKUAcXww73qsgDaX6itGP30MFKRWxCy
         8Yn555T4ez+5i79sRRymlmViFfwYaIQ25qoPYOWrgJaoCZa282V+rtCc8OF3OTTEix
         8OpR7Bgvpl31381yxJ5guwWEZPp0iekvvXMS/Opc=
Date:   Wed, 28 Jul 2021 19:45:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     bof@bof.de
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: stable 5.4.135 REGRESSION / once-a-day WARNING: at
 kthread_is_per_cpu+0x1c/0x20
Message-ID: <YQGXyiMb1IntqacG@kroah.com>
References: <61018d93.xsvXcO161PFLQFCX%bof@bof.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61018d93.xsvXcO161PFLQFCX%bof@bof.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 28, 2021 at 07:02:11PM +0200, bof@bof.de wrote:
> Hi,
> 
> first regression report in a long while... hope I'm doing this right.
> 
> I run self-build, from time to time, mainline kernels, in production, both on HP DL hosts + inside kvm VMs on these. I usually stick to a certain
> long term stable line for a year or three. As such, for a bit longer already, I'm running 5.4, starting somewhere at 5.4.4x. At the moment, I started
> to roll out 5.4.135 on a few of the hosts, and encounter a rare "WARNING: CPU ... PID ... at kthread_is_per_cpu+0x1c/0x20" splat (see full dmesg below)
> 
> Previous kernel I was running there, never seeing that, was 5.4.114
> 
> Searching a bit, turns up this 5.4.118 commit / backport:
> 	https://lore.kernel.org/stable/162074016514831@kroah.com/
> 	https://lore.kernel.org/lkml/20210407220628.3798191-2-valentin.schneider@arm.com/
> pointing to exactly the place shown in the dmesg trace.

Can you narrow this down to a specific commit using 'git bisect'?

thanks,

greg k-h
