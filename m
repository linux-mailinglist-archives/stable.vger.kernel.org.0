Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17EA33D91B
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 17:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhCPQV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 12:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236076AbhCPQV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 12:21:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60ACD6508A;
        Tue, 16 Mar 2021 16:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615911688;
        bh=JGA1BYJ4DnjkWs2uoiTYFr2jx9MyA+44cAQvE2O4UV0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ktIMhylmaxtlTzafPoz2hATAZL600RlZfL9ib7IL9WgxbnZIZEl5x/EMwWhL4nKlQ
         LuFXIj9s+0RHQnttz8m0jidqe9Eyq+clqafnKe9ukbEkAQHjXuXwk0mh39rOGun2fF
         9USB/a9jfGZ4L+ENinQcVXOd7Ee8dTtEI1GLZt+vhdTVUj440iXl4KQgvTFzKSRWWM
         IawPB/6NvyawRK7Or8QpNOqe7NbzgOG387I946HsSX3LU6e2BDxBb5bemPftgRJRI2
         pdO9qsnoee4U6udFNT2RK0wAt2bN9czxy5TKnBEjhQMxGt6w1ct9OVxrfPV2ZDCkH+
         QCD4IWcoZoshw==
Date:   Tue, 16 Mar 2021 12:21:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>
Subject: Re: [PATCH 5.10 113/290] net: dsa: implement a central TX
 reallocation procedure
Message-ID: <YFDbBygzYu1yqBh9@sashalap>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135545.737069480@linuxfoundation.org>
 <20210315195601.auhfy5uafjafgczs@skbuf>
 <YFBGIt2jRQLmjtln@kroah.com>
 <YFC4eVripXbAw2cG@sashalap>
 <YFDXNxW9w25n/51o@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YFDXNxW9w25n/51o@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 05:05:11PM +0100, gregkh@linuxfoundation.org wrote:
>On Tue, Mar 16, 2021 at 09:54:01AM -0400, Sasha Levin wrote:
>> On Tue, Mar 16, 2021 at 06:46:10AM +0100, gregkh@linuxfoundation.org wrote:
>> > I cc: everyone on the signed-off-by list on the patch, why would we need
>> > to add more?  A maintainer should always be on that list automatically.
>>
>> Oh, hm, could this be an issue with subsystems that have a shared
>> maintainership model? In that scenario not all maintainers will sign-off
>> on a commit.
>
>So a shared maintainer trusts their co-maintainer for reviewing patches
>for Linus's tree and all future kernels, but NOT into an old backported
>stable tree?  I doubt that, trust should be the same for both.

I don't think it's necessarily a trust issue, but is an availability
issue: one of the reasons shared maintainership models exist is so
that one maintainer can go on vacation (or focus other work) while the
other maintainer(s) take over. If we send a review request to that
maintainer he might be away and we'll never get our review.

-- 
Thanks,
Sasha
