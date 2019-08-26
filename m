Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9235C9C706
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 03:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfHZBf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Aug 2019 21:35:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbfHZBf7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Aug 2019 21:35:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89B3020673;
        Mon, 26 Aug 2019 01:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566783358;
        bh=l94varozL2rWoYilTnPgj/K5CGZap91Eyrr/jIcGZEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IzEFVFQhEhqX0BlhmQ4joV09hzlOWQQLJjsOfJicwsJO3yf19DfChj023asiqu4I0
         1neNZuQfh2IX1HWKSLOO6FzIxjdLybZswqe++Cii+Cw5183fzJITfNpPv85zDcW88e
         3tlISiGzRfa7KzeBbNBsZ9vwp/v+NqZj6m8OS6MM=
Date:   Sun, 25 Aug 2019 21:35:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Muchun Song <smuchun@gmail.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Prateek Sood <prsood@codeaurora.org>
Subject: Re: [PATCH AUTOSEL 5.2 067/123] driver core: Fix use-after-free and
 double free on glue directory
Message-ID: <20190826013557.GH5281@sasha-vm>
References: <20190814021047.14828-1-sashal@kernel.org>
 <20190814021047.14828-67-sashal@kernel.org>
 <20190814073608.GA23414@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190814073608.GA23414@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 14, 2019 at 09:36:08AM +0200, Greg Kroah-Hartman wrote:
>On Tue, Aug 13, 2019 at 10:09:51PM -0400, Sasha Levin wrote:
>This one needs a bit more time to "soak" in the -rc releases before I
>want to apply it to the stable release.  So if you could drop it from
>all of your autosel queues, that would be great.
>
>I'll queue it up in a few weeks if all goes well with it.

I've dropped it and will ignore it, thanks.

--
Thanks,
Sasha
