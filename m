Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889D01B830C
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 03:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgDYBiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 21:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbgDYBiW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 21:38:22 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA5AD20736;
        Sat, 25 Apr 2020 01:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587778702;
        bh=c93b2qpleh+wMUNTELdi88oQyMNr4bUsF3tcc1P69BA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xfF/t7BLHWNM/KZV1zUZoeBUctI+sjxMyReQzbTQxhs/ybdijboMf3QbWcaN9OqcB
         eMBgaSRDYQYFvCXxFGJfflevmGvYksq+JjoRDJyk6F3Pmy0mJOZV87s3Q3fD3HvjOp
         NwtCoRxb9C7wciKIW7H1Q4QX9fMynWamBMtoioo4=
Date:   Fri, 24 Apr 2020 21:38:19 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: Queue up bc0c4d1e176e
Message-ID: <20200425013819.GB13035@sasha-vm>
References: <8ed4e92d-b226-61a9-6679-b807dbc4fcbc@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8ed4e92d-b226-61a9-6679-b807dbc4fcbc@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 02:58:49PM -0600, Jens Axboe wrote:
>Hi,
>
>Can you queue up this:
>
>commit bc0c4d1e176eeb614dc8734fc3ace34292771f11
>Author: Linus Torvalds <torvalds@linux-foundation.org>
>Date:   Fri Apr 24 11:10:58 2020 -0700
>
>    mm: check that mm is still valid in madvise()
>
>for 5.6-stable?

I've queued it up, thanks!

-- 
Thanks,
Sasha
