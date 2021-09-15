Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC68740C459
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 13:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhIOL0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 07:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232540AbhIOL0J (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 07:26:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2F2A6124E;
        Wed, 15 Sep 2021 11:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631705091;
        bh=AQxlFWOwBrKclI7wGmLPSRlsZwQQovB/1BLS+Aa5gxM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0cIWW32/b3tZtfbBJs5kKk9vAyAX4//A1AW5NYPEz6r7qbrfFlDYmP/JhhGxeBiRR
         dPRR+h5gzvyGJ7ajtE9g4YvX6J+ueQvwcFdlT0oOiNpE2tRRZ02tySoRvZeX+pB4uZ
         U8gs8002/JZDMHNqKJGBcSb6MTe3Mm2qhfnV9Yi0=
Date:   Wed, 15 Sep 2021 13:24:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: Btrfs backports for 5.14.x
Message-ID: <YUHX+UyiXZoBgoD4@kroah.com>
References: <20210914154700.GC9286@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914154700.GC9286@twin.jikos.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 05:47:00PM +0200, David Sterba wrote:
> Hi,
> 
> please add the following patches to 5.14 queue. All apply cleanly, thanks.
> 
> 03fe78cc2942c55  btrfs: use delalloc_bytes to determine flush amount for shrink_delalloc
> e16460707e94c3d  btrfs: wait on async extents when flushing delalloc
> 93c60b17f2b5fca  btrfs: reduce the preemptive flushing threshold to 90%
> 114623979405abf  btrfs: do not do preemptive flushing if the majority is global rsv

All now queued up, thanks!

greg k-h
