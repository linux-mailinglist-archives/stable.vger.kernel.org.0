Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C696EC050E
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 14:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfI0MVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 08:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfI0MVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Sep 2019 08:21:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 066BC20872;
        Fri, 27 Sep 2019 12:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569586872;
        bh=t67KXmR1q5Gx2ZE+Tc7FneoAI3cDXbY4gALkOvkqT4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2AhsQf8rx0HBxG59uOUOBdUOQw9WpWQL4jwcRh934Twpzpm+O1wPUFDffhJJgWWcB
         8W24uKPAGuKqOP52K6hYKG22jV9sdLevUjDTOC0s+Axh3uNseuZfvD4iy9PjmZjfJ3
         0uhdzujYO9sBv8VjYlcMmk+Iit+zSiVyy8RWvdSQ=
Date:   Fri, 27 Sep 2019 08:21:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable@vger.kernel.org, Yu Wang <yyuwang@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Please backport 79c92ca42b5a ("mac80211: handle
 deauthentication/disassociation from TDLS peer") to 4.9
Message-ID: <20190927122110.GN8171@sasha-vm>
References: <20190927115711.GA8961@eldamar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190927115711.GA8961@eldamar.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 27, 2019 at 01:57:11PM +0200, Salvatore Bonaccorso wrote:
>Hi
>
>79c92ca42b5a ("mac80211: handle deauthentication/disassociation from
>TDLS peer") was backported to various stable versions, back to 4.14,
>but not 4.9, because there is a conflict making it not applying
>cleanly to 4.9.
>
>Ben has done the work for 3.16, which got applied 3.16.74.
>
>Attached the backport for 4.9 for review, adjusting the context to
>make it apply on top of 4.9.194.

Thank you for pointing it out. Instead of the backport, I took
68506e9af132a ("mac80211: Print text for disassociation reason") as a
dependency. Queued up both for 4.9 and 4.4, thank you!

--
Thanks,
Sasha
