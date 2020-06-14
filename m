Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EF21F8A61
	for <lists+stable@lfdr.de>; Sun, 14 Jun 2020 21:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgFNTcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 15:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgFNTcZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jun 2020 15:32:25 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2624206B7;
        Sun, 14 Jun 2020 19:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592163144;
        bh=MjaOqKjyMHqYKRAclrZCzsVHgJQqdJW7CQ6/SGUd/DA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ocmm35qil24//+556DwxCKxkOxa+UTodFrWDB/p2WaIICSgl2SGZdPKlY8jwh8kPx
         avoHkEkvv90CnF6InMvHNA1NYte2EIAl8sSG0TWzLGvHPBv7IYR6QTO8DseGAOJf4a
         4fpPr7w/Y6Y1q90kRkoy015LspWNmssx8njorw5g=
Date:   Sun, 14 Jun 2020 15:32:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     William Dauchy <wdauchy@gmail.com>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: backport status of "ipv4: fix a RCU-list lock in
 fib_triestat_seq_show"
Message-ID: <20200614193223.GC5492@sasha-vm>
References: <CAJ75kXaUoedk2UjQ74G2uYkaDUpanvYWtCNU78uX2vVSUVkmjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJ75kXaUoedk2UjQ74G2uYkaDUpanvYWtCNU78uX2vVSUVkmjA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 14, 2020 at 02:22:47PM +0200, William Dauchy wrote:
>Hello,
>
>I found the following commit fbe4e0c1b298b4665ee6915266c9d6c5b934ef4a
>("ipv4: fix a RCU-list lock in fib_triestat_seq_show") backported in
>the following stable versions: v5.6.x, v5.5.x, v4.19.x, v4.14.x,
>v4.9.x, v4.4.x.
>However I cannot find it in v5.4.x yet. I checked stable queue on
>netdev side (http://patchwork.ozlabs.org/bundle/davem/stable/?state=*)
>but also main stable queue
>https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
>
>I was wondering whether it was an oversight or it was expected?
>
>Sorry for the noise if I'm mistaken.

That's a good catch! I've queued it for 5.4 as well, thank you!

-- 
Thanks,
Sasha
