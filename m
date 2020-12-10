Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E2A2D5ACC
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 13:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732601AbgLJMqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 07:46:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgLJMqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 07:46:00 -0500
Date:   Thu, 10 Dec 2020 13:46:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607604319;
        bh=t2LcR0FjFWcKbaBou7VoBUrZDX7LwyalVlXTeQCSDaQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZFJYwU8Lu3TYclTYdBw69+7D1gYniMXouDlAEukqPoxgQbEcuJXzCyqNWjvY+c444
         4DGS8NZ0u007n5sfp53q6phi+WhlpE+QHtTmFiRgvj1m2GTPCaZjBpuW4iEc2+xcPW
         rK248DbKDvQkmQ8FOqGtOyiEyGHSB0p0EyLsNa8M=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org,
        hannes@cmpxchg.org, mhocko@kernel.org, shakeelb@google.com,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm: memcg/slab: fix obj_cgroup_charge()
 return value handling" failed to apply to 5.9-stable tree
Message-ID: <X9IYqsjffUezU7sD@kroah.com>
References: <1607504747243177@kroah.com>
 <20201209213004.GA2470631@carbon.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209213004.GA2470631@carbon.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 01:30:04PM -0800, Roman Gushchin wrote:
> On Wed, Dec 09, 2020 at 10:05:47AM +0100, Greg Kroah-Hartman wrote:
> > 
> > The patch below does not apply to the 5.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Hi Greg!
> 
> Please, find the backport below.

Now queued up, thanks!

greg k-h
