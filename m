Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E9149E613
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiA0PaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiA0PaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:30:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CE7C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FDBB61651
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 15:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C0EC340E4;
        Thu, 27 Jan 2022 15:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643297411;
        bh=wz00s2VImC1s4E1r4mu/LqT9pgeBIkabUhWaI74osCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VIrFZLE3Cy3dGonfZm76J4Yqb2gOCD/987g8u/FpI+OtjnK6Ic6TYm3hojeuLPVVk
         O66CQusQWLWtvo5cHPbFp2hWGIOoAfebRXJ8ENwQq8vw8yuP3wkOFaGSeoaVUsnWdE
         K4PCKhzRYjBZCtSsGmxBfrBAYReH0zcRbR+TmqD0=
Date:   Thu, 27 Jan 2022 16:30:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: Backport memcg flush improvements into 5.15
Message-ID: <YfK6gfXZZGNqsnyr@kroah.com>
References: <CABWYdi28yMU2YbJGKvPb91HR7yYAEyq3Zg6QeeBUk3KwjiyTMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABWYdi28yMU2YbJGKvPb91HR7yYAEyq3Zg6QeeBUk3KwjiyTMg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 19, 2022 at 04:15:34PM -0800, Ivan Babrou wrote:
> Hello,
> 
> We've seen a significant perf degradation when reading a tmpfs file
> swapped into zram between 5.10 and 5.15. The source of the issue is:
> 
> * aa48e47e3906: memcg: infrastructure to flush memcg stats
> 
> There's a couple of commits that helps to bridge the gap in 5.16:
> 
> * 11192d9c124d: memcg: flush stats only if updated
> * fd25a9e0e23b: memcg: unify memcg stat flushing
> 
> Both of these apply cleanly and Shakeel (the author) has okayed the
> backport from his end. He also suggested backporting the following:
> 
> * 5b3be698a872: memcg: better bounds on the memcg stats updates
> 
> I personally did not test this one, but it applies cleanly, so there's
> probably no harm. I cc'd Shakeel in case you want confirmation on
> that. It's not a part of any tag yet.
> 
> Please backport all three (or at least the first two) to 5.15 LTS.

All now queued up, thanks!

greg k-h
