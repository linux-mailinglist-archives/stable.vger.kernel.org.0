Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1194D31DA60
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 14:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhBQN12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 08:27:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:33168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232972AbhBQN1W (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 08:27:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3669760238;
        Wed, 17 Feb 2021 13:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613568400;
        bh=0y8VlHh4ghwywTGswuQ+ij9ax4F4yn+djEeFpPpJNHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sj51smvWP5oYn5JLYzAAgdBCfZGvaVjAlJ0+dw73On0+ZV1Wrg448s9BWHVZjkXCh
         3G4i5W5KaMtLMDcWiQZcNPCgu7SFUo7CMo789oNt2b4Jb3ay6byJh4AWn0Yys1R8du
         4/CsZtSkZX1SLkEWFb8yq8sqAow8BUjb0xxJwgAc=
Date:   Wed, 17 Feb 2021 14:26:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] virtio-blk: close udev startup race condition as
 default groups
Message-ID: <YC0ZjUYhSCawoJ7N@kroah.com>
References: <20210207114656.32141-1-jefflexu@linux.alibaba.com>
 <20210207114656.32141-2-jefflexu@linux.alibaba.com>
 <YB/Vgb4y4Dts0Y2G@kroah.com>
 <f466aacc-f9ca-49ca-0da8-16dc045c9000@linux.alibaba.com>
 <6046ceef-061c-d93f-b6a1-2ce2483bec3c@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6046ceef-061c-d93f-b6a1-2ce2483bec3c@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Feb 17, 2021 at 09:12:38PM +0800, JeffleXu wrote:
> Hi all,
> 
> Would you please evaluate if these should be fixed in stable tree, at
> least for the virtio-blk scenario [1] ?

What is "these"?

> [1] commit e982c4d0a29b1d61fbe7716a8dcf8984936d6730 ("virtio-blk:
> modernize sysfs attribute creation")

Do you want this backported?  To where?  Why?  If so, where is the
working backport that you have properly tested?

totally confused,

greg k-h
