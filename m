Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57257481A0F
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 07:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbhL3G4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 01:56:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38496 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhL3G4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 01:56:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00112615F1;
        Thu, 30 Dec 2021 06:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7226C36AE7;
        Thu, 30 Dec 2021 06:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640847359;
        bh=Ok3nu+E48XkOW0foa211Xbo4P99RYxnVnjuv1MOAwGE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MB8lNO8bFI+mRW/TetQhmTEuuqiNX6Kl72QoAzR2ZaAlH4bdS22146/scvma6dqSC
         FHtAbml5kIKhW5a79RVshfld7B3sopBIATe4uonqHn7qf0osZibGZTZylhF4mSZ/OR
         22ThSZ/Q+MvbbYvuG7+59MZ4AeUrtFL81KIz1lN4=
Date:   Thu, 30 Dec 2021 07:55:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: Should write-time tree-checker backported to v5.10?
Message-ID: <Yc1X/HqU8zK85xFd@kroah.com>
References: <8b9f45d8-768a-d76d-3de1-f3998dd77e41@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b9f45d8-768a-d76d-3de1-f3998dd77e41@gmx.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 30, 2021 at 08:06:49AM +0800, Qu Wenruo wrote:
> Hi,
> 
> Since v5.10 is an LTS release, I'm wondering should we backport write
> time tree-checker feature to v5.10?
> 
> There are already some reports of runtime memory bitflip get written to
> disk and causing problems.
> 
> Unfortunately write-time tree-checker is only introduced in v5.11, one
> version late.
> 
> Considering how many bitflips write-time tree-checker has caught (and
> prevented corrupted data reaching disk), I think it's definitely worthy
> to backport it to an LTS kernel.
> 
> Or is there any special requirement for LTS kernel to reject certain
> features?

Stable/LTS kernels do not get new features, sorry.  If someone wants
this feature, why not just use 5.15?

thanks,

greg k-h
