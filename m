Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A277F479790
	for <lists+stable@lfdr.de>; Sat, 18 Dec 2021 00:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhLQXgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 18:36:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39056 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhLQXgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 18:36:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2865B623ED
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 23:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DE1C36AE2;
        Fri, 17 Dec 2021 23:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639784180;
        bh=3l8a4rJw55E3AJjTZwb1pNKeMVZoICcO5/sgJ+LJ8pI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SLRZFSlfzxyZTZcv6lZ22/NFBVpKKf2QDF7Us/vuhLRpkWzvjsK05f40J5/qXyUMO
         VMp5NN+4i4q0RTxe++K4KfQCDgXkJschWAYLY1Nmmy7PsN9TwwTI4c6BYLfN8C7EdJ
         BWuBkzNxkmKW/izT+ZAIILd4HoqCRvvfUXFjWBrM=
Date:   Sat, 18 Dec 2021 00:36:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4.19 1/2] mac80211: mark TX-during-stop for TX in
 in_reconfig
Message-ID: <Yb0e8mSZZT0jxgSl@kroah.com>
References: <20211217203550.54684-1-johannes@sipsolutions.net>
 <3ce00af3568e08d25b88ba9c7d27638d95c95536.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ce00af3568e08d25b88ba9c7d27638d95c95536.camel@sipsolutions.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 09:42:21PM +0100, Johannes Berg wrote:
> On Fri, 2021-12-17 at 20:35 +0000, Johannes Berg wrote:
> > 
> > I'm not sure why you say it doesn't apply - it did for me?
> > 
> 
> Oh, I'm an idiot, it doesn't *compile* afterwards since
> IEEE80211_TXQ_STOP_NETIF_TX doesn't exist yet.
> 
> Let's ignore this patch for now, but please take 2/2.
> 
> I'll have to think if we even want to introduce this on the old kernels,
> the bug that was reported required a firmware crash in the first place,
> and it was reported on iwlwifi which doesn't even use TXQs on 4.19 yet.

Yeah, I don't think it's needed, but as it was marked to go back really
far, I wanted to give you the option to do so or not.

Thanks for the 2/2 patch, I'll queue it up when I get a chance tomorrow.

greg k-h
