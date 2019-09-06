Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7CFABFD7
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 20:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389011AbfIFSsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 14:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388265AbfIFSsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 14:48:52 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AF5C20838;
        Fri,  6 Sep 2019 18:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567795731;
        bh=Q9FD4VEg2CE1PHL3dqhCqK94wMwy1fA6VuGfiXRZyZo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f7qBSG7UMmAEzYZV/OwkYm5u+hJgiwIgTVqUiZp7RFdBvO3CrKPJP4d4pISoqX5UF
         TRGBmv6a5K0Qy7T5BqOjUBvYk8J9h3OWEZ1TOPFwOwErbKXo/caHzj6iZocDM4GgoB
         kz6TGbq4G8MEbu1+9p8ChZZBikW3VOpafGihBJeA=
Date:   Fri, 6 Sep 2019 14:48:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sean Nyekjaer <sean@geanix.com>
Cc:     linux-stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rasmus Pedersen (RD SC)" <rap@serenergy.com>
Subject: Re: bcm2835aux: broken in (4.9), 4.14 and 4.19
Message-ID: <20190906184849.GC1528@sasha-vm>
References: <5f6bd329-3848-98aa-bae9-e988de0d361a@geanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5f6bd329-3848-98aa-bae9-e988de0d361a@geanix.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 05, 2019 at 02:18:35PM +0200, Sean Nyekjaer wrote:
>Hi,
>
>Please consider picking:
>
>commit 7188a6f0eee3f1fae5d826cfc6d569657ff950ec
>Author: Martin Sperl <kernel@martin.sperl.org>
>Date:   Sat Mar 30 09:30:58 2019 +0000
>
>    spi: bcm2835aux: unifying code between polling and interrupt 
>driven code
>
>commit c7de8500fd8ecbb544846dd5f11dca578c3777e1
>Author: Martin Sperl <kernel@martin.sperl.org>
>Date:   Sat Mar 30 09:30:59 2019 +0000
>
>    spi: bcm2835aux: remove dangerous uncontrolled read of fifo
>
>
>commit 73b114ee7db1750c0b535199fae383b109bd61d0
>Author: Martin Sperl <kernel@martin.sperl.org>
>Date:   Sat Mar 30 09:31:00 2019 +0000
>
>    spi: bcm2835aux: fix corruptions for longer spi transfers
>
>for stable kernel 4.14 and 4.19.
>
>If we want to fix this in 4.9 you should also pick:
>
>commit bc519d9574618e47a0c788000fb78da95e18d953
>Author: Rob Herring <robh@kernel.org>
>Date:   Thu May 3 13:09:44 2018 -0500
>
>    spi: bcm2835aux: ensure interrupts are enabled for shared handler

I've queued this as per your instructions (plus all 4 for 4.4), thank
you!


--
Thanks,
Sasha
