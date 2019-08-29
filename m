Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A52FA179B
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfH2LAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfH2LAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 07:00:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B785B20828;
        Thu, 29 Aug 2019 11:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567076411;
        bh=TNiL6vkAKwQD8/g5FUBu6/BqNlIy5MHtwIQhOxBdWUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YW7GNsFAJjBcqBmK1PL7p50Ti/OxxwQq18F0DD3njNAfpy7uIH7PGUXOIpgunPx6K
         h6TQYV3/otxH3E1LpWENuGGZ9/D/oJu2v/oREMQ4b8DXJ/YgEuVnMIiVAOOjjaEepL
         q8xISwZnD1MkBsXonWcAsyXaakO2QUkhCg+58bSE=
Date:   Thu, 29 Aug 2019 07:00:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Patches potentially missing from stable releases
Message-ID: <20190829110009.GH5281@sasha-vm>
References: <20190827171621.GA30360@roeck-us.net>
 <20190827181003.GR5281@sasha-vm>
 <20190827200151.GA19618@roeck-us.net>
 <20190828122240.GC5281@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190828122240.GC5281@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 08:22:40AM -0400, Sasha Levin wrote:
>On Tue, Aug 27, 2019 at 01:01:51PM -0700, Guenter Roeck wrote:
>>make sense to start with looking at Fixes: ? After all, additional
>>references (wich higher chance for false positives) can always be
>>searched for later.
>
>Yes, let me send a branch out for review later today and we could
>compare our results.

The AUTOSEL set I've just sent
(https://lore.kernel.org/stable/20190829105009.2265-1-sashal@kernel.org/)
is really a batch of these fixes for v4.19 and older.

--
Thanks,
Sasha
