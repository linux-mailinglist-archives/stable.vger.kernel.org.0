Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B921385CF
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 11:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732577AbgALKWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 05:22:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732565AbgALKWW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Jan 2020 05:22:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1180A21569;
        Sun, 12 Jan 2020 10:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578824541;
        bh=y+j0iLiyp9dU8Y8qKZGhD5a92WJXc5kAisSjAyPF09U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ajwgpSleWNAJ6gKcZhLtXqPUW0YZRwYLvnwEgoOxWVrzPxsUfUhRJISj2v1kWMNEQ
         5VMfy3DDB91PpB46Q70EpDhFZStNcXd2rcYCIAjfW2+3JthkgE0u/f/XQICLpUvHFi
         wLdwSq+4gwOSyDE889O/NnLb/f/2LQ0hk1duaj0I=
Date:   Sat, 11 Jan 2020 21:41:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/84] 4.19.95-stable review
Message-ID: <20200111204113.GA460087@kroah.com>
References: <20200111094845.328046411@linuxfoundation.org>
 <23c3a0d1-1655-8cc2-7c96-743a47953795@roeck-us.net>
 <20200111174715.GB394778@kroah.com>
 <565353ce-9383-9af6-3150-529e9ef73398@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <565353ce-9383-9af6-3150-529e9ef73398@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 11, 2020 at 12:10:11PM -0800, Guenter Roeck wrote:
> On 1/11/20 9:47 AM, Greg Kroah-Hartman wrote:
> > On Sat, Jan 11, 2020 at 08:02:40AM -0800, Guenter Roeck wrote:
> > > On 1/11/20 1:49 AM, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.19.95 release.
> > > > There are 84 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > Build results:
> > > 	total: 156 pass: 154 fail: 2
> > > Failed builds:
> > > 	arm64:defconfig
> > > 	arm64:allmodconfig
> > > Qemu test results:
> > > 	total: 382 pass: 339 fail: 43
> > > Failed tests:
> > > 	<all arm64>
> > > 
> > > arch/arm64/kvm/hyp/switch.c: In function 'handle_tx2_tvm':
> > > arch/arm64/kvm/hyp/switch.c:438:2: error: implicit declaration of function '__kvm_skip_instr'; did you mean 'kvm_skip_instr'?
> > 
> > Thanks for this, I'll go push out a -rc2 with the offending patch
> > removed.
> > 
> 
> For v4.19.94-84-g4f77fc728c70:
> 
> Build results:
> 	total: 156 pass: 156 fail: 0
> Qemu test results:
> 	total: 382 pass: 382 fail: 0

Wonderful, thanks for testing all of these and letting me know.

greg k-h
