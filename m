Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826C245837D
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 13:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238091AbhKUM5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 07:57:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236416AbhKUM5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Nov 2021 07:57:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0CA46054E;
        Sun, 21 Nov 2021 12:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637499260;
        bh=JQtS1mjaff38zOk9LjR19EVjKHqmR/J4BLXrKZXfflc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zZ4s2U5wZs3Kg0wTxFNooockcz+TSp4hpxV3JGj1vy7WzhW/P8po1cOHkHT42C3fS
         cMVWzZtUsZLYWtQyAqDIn5TR6kHmDN8qZQ2AV810NkG18oUTodenPfKLi2RQc7CfiZ
         WSbkYblAVWO9PnvJpZPdvck1l95k3FfqJAkkuzPg=
Date:   Sun, 21 Nov 2021 13:54:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
Subject: Re: Linux 5.4.161
Message-ID: <YZpBeXrpVa/e5xPG@kroah.com>
References: <163749885759102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163749885759102@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 21, 2021 at 01:47:37PM +0100, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 5.4.161 kernel.
> 
> All users of the 5.4 kernel series must upgrade.
> 
> The updated 5.4.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
> and can be browsed at the normal kernel.org git web browser:
> 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

And I didn't even announce a -rc release for this kernel, yet I did a
release for it, sorry about that everyone.

The reason this happened was my scripts went and "take the review
comments for the kernel release and dump them in a mbox" triggered the
messages that were reviewing the "5.15.4-rc1" release as valid for the
5.4 release tree as the simple search was just for "5.4" in the subject
line. :(

So that caused the 5.15.4 and 5.4.161 release commits to have the
identical "Tested-by:" messages in it, ick.

Anyway, bonus kernel release, sorry about that everyone.  It might be
nice to have people test it, even though it does work for me here...

greg "release all the kernels!" k-h
