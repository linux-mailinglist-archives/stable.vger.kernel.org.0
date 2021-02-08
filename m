Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6457313AC9
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 18:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhBHRXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 12:23:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233905AbhBHRWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 12:22:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C86F64E9D;
        Mon,  8 Feb 2021 17:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612804849;
        bh=fAvTvgv3LjW9LjKykFtKNEzPk92r0oH4fR74QFmbTxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ehpgdRdRCpS6BHQtyDZmFvt07c1JWrRUqkNG1sFWsZ3i7xX6yZmG3JZXAdFdlkZam
         pzDaXGpc+SQy6elpguVppXL00xKhq8Gs9WV2vcyM7Ezg3WQ3w+3dDos9Ue7YjFYLdp
         BzJCGgp6e+I1wLrDVk6XqwF1PwB1mh5GOfJUHKyU=
Date:   Mon, 8 Feb 2021 18:20:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net, jslaby@suse.cz,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com
Subject: Re: Linux 4.4.256
Message-ID: <YCFy7ot/xo427FX4@kroah.com>
References: <1612534196241236@kroah.com>
 <20210205205658.GA136925@roeck-us.net>
 <YB6S612pwLbQJf4u@kroah.com>
 <20210206131113.GB7312@1wt.eu>
 <20210206132239.GC7312@1wt.eu>
 <e173809f-505d-64a8-1547-37e0f6243f4c@roeck-us.net>
 <YB7cU7SCyBOHFJGS@kroah.com>
 <20210206184926.GA19587@roeck-us.net>
 <YB+jVD6r4vlzuZO0@kroah.com>
 <20210208171453.GA174128@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208171453.GA174128@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 09:14:53AM -0800, Guenter Roeck wrote:
> On Sun, Feb 07, 2021 at 09:22:44AM +0100, Greg Kroah-Hartman wrote:
> [ ... ]
> > > There are lots (35) of "KERNEL_VERSION(4, 5, 0)" in chromeos-4.4.
> > > That should not matter with the clamped LINUX_VERSION_CODE, but
> > > I'd prefer to clamp KERNEL_VERSION as well just to be sure. On
> > > top of that, some of the vendor code we carry along does check
> > > SUBVERSION, but that is probably more of an academic concern.
> > 
> > Ah, the internal checks, I think the other patch by Sasha will let that
> > get bigger and should work for you as well.  Can you try it out?
> > 
> Quite frankly I like the "complete" fix much better, but then I dislike
> deviating from stable releases even more. I'll use Sasha's version.

We will backport the "complete" fix soon when it hits Linus's tree.

thanks,

greg k-h
