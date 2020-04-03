Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D35B19D0B5
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 09:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732595AbgDCHDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 03:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730550AbgDCHDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Apr 2020 03:03:07 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01AB22063A;
        Fri,  3 Apr 2020 07:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585897387;
        bh=USlWScoyW9mTVH5gXc4JkNmbHWm+ihrjsnEMITSlBvM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iOtIyaL12FIeKDMGT48MrRouRR4iWYVtV3/OjHSHnvYP+70T//uKhH8ymq1tJ8U3l
         tn/ygaBcYsnNTQ+WiGQ2UN8PhqgsQ9FOfY6zOatHmS6ojhSx7qPLfzdST5IG1Dwsau
         7C/LjNZ0uz3G9/8wjW1Ao95QF+S2ej4sMOYYehpc=
Date:   Fri, 3 Apr 2020 08:03:02 +0100
From:   Will Deacon <will@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        g.nault@alphalink.fr
Subject: Re: [PATCH 1/2] l2tp: ensure sessions are freed after their PPPOL2TP
 socket
Message-ID: <20200403070301.GA16361@willie-the-truck>
References: <20200402173158.7798-1-will@kernel.org>
 <20200402173158.7798-2-will@kernel.org>
 <20200402.125930.1715113142516280666.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402.125930.1715113142516280666.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 12:59:30PM -0700, David Miller wrote:
> Sorry, you will have to repost all of these l2tp patches with proper
> cover letters for a patch series.
> 
> In this particular case it's even more necessary, you posted two patch
> series.  One with 2 patches and one with 8 patches.  Do they depend
> upon eachother?  If so, which one goes first.  What is each patch
> series doing?  How is it doing it?  And why are you doing it that way?
> 
> Those are the questions answered by a properly written header posting.

Sorry, David. These two series are just backports for stable of patches
that are already in mainline. Git added you to CC because of your SoB
on the patches, but I don't think there's anything for you to do.

The 2-patch series is for 4.9-stable kernels.
The 8-patch series is for 4.4-stable kernels, and it's bigger because
there are missing dependencies in 4.4-stable.

I did call this out in the cover letters but, of course, you weren't CC'd
on those. Duh. Anyway, sorry again for the noise.

Will
