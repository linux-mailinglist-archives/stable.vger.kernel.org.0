Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299AC3D7B46
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 18:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhG0QnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 12:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhG0QnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 12:43:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08FB961037;
        Tue, 27 Jul 2021 16:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627404203;
        bh=sSmzIHa/V2owjHzwhM8RLG5HAtHV+dbTgi67JJVQYlI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tTtxRwl05avo5DZ3oEcGdD6P8Co7IRZPzH/lB1of/q3hnm3J6fqaj7hWkeKnWBqru
         d3Gv9uu3K1Z6I9C0KVwYqS8SrFi29yH4KYHvxE+ECRlBAVrvnt+M2FgOhPSGfpNS0U
         +xT523WxQj5VU9lUZsJqitF6ZsF8VH2TJ+ZeJUYI=
Date:   Tue, 27 Jul 2021 18:43:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Greear <greearb@candelatech.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: very long boot times in 5.13 stable.
Message-ID: <YQA3qULTdCvWuVCo@kroah.com>
References: <aeac0ff3-6606-3752-db6c-306a9c643f8f@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeac0ff3-6606-3752-db6c-306a9c643f8f@candelatech.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 09:10:11AM -0700, Ben Greear wrote:
> Hello,
> 
> My system was stable with 5.13.0, though there was a KASAN warning.
> So, I upgrade to 5.13.5, and now it takes a very long time to fully boot to
> login prompt, and I see this splat in the logs.
> 
> I'm working on bisecting, but if someone has a clue, please let me know.
> 
> [ 2187.021338] irq 4: nobody cared (try booting with the "irqpoll" option)

Have you tried booting with that option?

