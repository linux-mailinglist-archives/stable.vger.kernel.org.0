Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFF27B368
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 21:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbfG3Tb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 15:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728522AbfG3Tb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 15:31:58 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB26E2067D;
        Tue, 30 Jul 2019 19:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564515118;
        bh=8yD0S9fSH5v/5Hl/wEGQwDxo0ojb/Bg4JQGOdpy8YTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aLJuCTAfDgQaL4l2X9n6/xwi83FV90PDFsDWOe2ysMT9I6Zc4y95xykbq51H7U7ck
         r5Ar7NhYR8yT2Kd9j2OxYOD9/I3G1u7I5hrLe3sQFw5Y96czSGbeEDjDAG8PSQiiuy
         ebHu2HxoSCNK2x6ItcjkdSsYiw2qg3k9k3Gn23Sg=
Date:   Tue, 30 Jul 2019 15:31:56 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Xin Long <lucien.xin@gmail.com>
Subject: Re: Backport request for 4.9 99253eb750fd ("ipv6: check sk sk_type
 and protocol early in ip_mroute_set/getsockopt")
Message-ID: <20190730193156.GD29162@sasha-vm>
References: <20190730103914.GA3114@lorien.valinor.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190730103914.GA3114@lorien.valinor.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 30, 2019 at 12:39:15PM +0200, Salvatore Bonaccorso wrote:
>Hi
>
>As this goes to the 4.9 series according to
>https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#q-are-all-networking-bug-fixes-backported-to-all-stable-releases
>I'm sending it primarily to stable@v.k.o but Cc'ing Dave and Xin Long.
>
>Could you please apply 99253eb750fd ("ipv6: check sk sk_type and
>protocol early in ip_mroute_set/getsockopt") to the 4.9 stable series?
>
>While 5e1859fbcc3c was done back in 3.8-rc1, 99253eb750fd from
>4.11-rc1 was not backported to older stable series itself, where it is
>needed as well.
>
>Only checked if applicable without change in 4.9, but the fix should
>probably go as well to the 4.4 and 3.16.

I've queued it for 4.9 and 4.4, thank you!

--
Thanks,
Sasha
