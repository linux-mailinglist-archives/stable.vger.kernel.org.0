Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAA729EA08
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 12:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbgJ2LHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 07:07:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727445AbgJ2LHX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 07:07:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 204CF20727;
        Thu, 29 Oct 2020 11:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603969263;
        bh=R92KNs8S38MZTxidNQ/KELDDBq80do4lAJlTlaY7shs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vkGu2R5XbT1ery9DxQP4CncywLf46MpkH8l+MZPgbWeL8TWh1rXnL9Ogv3nZe7cS2
         BOr68XfGWSeYQ6TUKApn6Q+xjJyO1R7MFCHBQl4f0XtauJc8ArdXwmgUU0jZ0rzxMH
         oMxDMzkjJRH8SqDuQLmAfaNJWRMkAlNxDe3NVZOc=
Date:   Thu, 29 Oct 2020 12:01:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jian Cai <jiancai@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>, arnd@arndb.de
Subject: Re: Backport 44623b2818f4a442726639572f44fd9b6d0ef68c to kernel 5.4
Message-ID: <20201029110153.GA3840801@kroah.com>
References: <CA+SOCLLXnxcf=bTazCT1amY7B4_37HTEXL2OwHowVGCb8SLSQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+SOCLLXnxcf=bTazCT1amY7B4_37HTEXL2OwHowVGCb8SLSQQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 06:17:00PM -0700, Jian Cai wrote:
> Hello,
> 
> I am working on assembling kernel 5.4 with LLVM's integrated assembler on
> ChromeOS, and the following patch is required to make it work. Would you
> please consider backporting it to 5.4?
> 
> 
> commit 44623b2818f4a442726639572f44fd9b6d0ef68c
> Author: Arnd Bergmann <arnd@arndb.de>
> Date:   Wed May 27 16:17:40 2020 +0200
> 
>     crypto: x86/crc32c - fix building with clang ias
> 
> Link:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=44623b2818f4a442726639572f44fd9b6d0ef68c
> 

It does not apply cleanly, can you please provide a properly backported
and tested version?

thanks,

greg k-h
