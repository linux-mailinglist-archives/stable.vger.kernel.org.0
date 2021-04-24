Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4824336A1AB
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 16:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhDXOqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Apr 2021 10:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhDXOqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Apr 2021 10:46:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFB08613CB;
        Sat, 24 Apr 2021 14:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619275522;
        bh=ZNDw/askQ3AOwdtjuErjLlZmlQsu/7HG8A7DtybgB8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f3Tvwt2OUQbg9Ofk8/kSpQ7ZAf3IRm8D9vqyWnC8a+Xm7vDC0F+1wFK9nie6TnmVA
         aw7goCejEC5zlpW/hrT0O4I3p3Kzl9md7+agOST7bqUuk1Cpk3nTaYt29ezBPYhkdV
         weX0FpH3zUKWTrGjUkMudn4jrXpRbcQ2QNlKp1i4=
Date:   Sat, 24 Apr 2021 16:45:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org, Tom Seewald <tseewald@gmail.com>
Subject: Re: FAILED: patch "[PATCH] usbip: vudc synchronize sysfs code paths"
 failed to apply to 4.14-stable tree
Message-ID: <YIQu/4tcAaUB6rDQ@kroah.com>
References: <161812561233164@kroah.com>
 <YIMjud72SYv5t5tt@debian>
 <5a668128-93ff-8e77-f595-dea0c8233d58@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a668128-93ff-8e77-f595-dea0c8233d58@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 23, 2021 at 01:59:18PM -0600, Shuah Khan wrote:
> On 4/23/21 1:44 PM, Sudip Mukherjee wrote:
> > Hi Greg,
> > 
> > On Sun, Apr 11, 2021 at 09:20:12AM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 4.14-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > ------------------ original commit in Linus's tree ------------------
> > > 
> > >  From bd8b82042269a95db48074b8bb400678dbac1815 Mon Sep 17 00:00:00 2001
> > 
> > Just wondering if you have missed this one as I am not seeing it in your
> > queue for 4.14-stable but can see in 4.9-stable queue. And this will apply
> > directly on top of your 4.14-stable queue.
> > 
> > 
> This patch needed some work. Tom sent in the patch.
> 
> https://lore.kernel.org/stable/d2cc4517-4790-b3a7-eec0-16fe06ea22eb@linuxfoundation.org/

Ok, I missed that.

Can I get a set of patches just for 4.14.y now?  Mixing them in the
series like that is a guarantee that someone will mess up.  And I did.

thanks,

greg k-h
